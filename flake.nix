{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      forSystem =
        s: f:
        inputs.nixpkgs.lib.genAttrs s (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              # Allow unfree packages like Terraform
              # config.allowUnfree = true;
            };
          }
        );

      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forEachSupportedSystem = forSystem supportedSystems;
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go_1_23
              gopls
              gotools
              go-tools
              delve
            ];
          };
        }
      );
    };
}
