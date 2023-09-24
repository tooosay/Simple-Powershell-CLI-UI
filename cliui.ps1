function Menu(){
    Param(
        [Parameter(Mandatory=$True)][String]$Title,
        [Parameter(Mandatory=$True)][array]$MenuOptions
    )
    [console]::CursorVisible = $false
    $MaxValue = $MenuOptions.count - 1
    $enter = $False
    $Selection = 0
    $Style = $PSStyle.ForeGround.Red + "> " + $PSStyle.ForeGround.BrightWhite
    Write-Host $Title
    $PosY = [Console]::CursorTop
    $PreY = $PosY
    $PreSelection = $Selection
    foreach ($Opt in $MenuOptions){
        Write-Host "  $Opt"
    }
    $EndPos = [Console]::CursorTop

    do{
        Update-Choice 0 $PreY
        Write-Host "  $($MenuOptions[$PreSelection])"
        Update-Choice 0 $PosY
        Write-Host $Style"$($MenuOptions[$Selection])"
        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode
        switch($KeyInput){
            0x0D{
                $enter = $True
                break
            }
            0x26{
                $PreSelection = $Selection
                $PreY = $PosY
                if ($Selection -eq 0){
                    $PosY = $PosY
                    $Selection = $Selection
                } else {
                    $PosY -= 1
                    $Selection -= 1
                }
                break
            }
            0x28{
                $PreSelection = $Selection
                $PreY = $PosY
                if ($Selection -eq $MaxValue){
                    $PosY = $PosY
                    $Selection = $Selection
                }else{
                    $PosY += 1
                    $Selection += 1
                }
                break
            }
            default{
                break
            }
        }

    }until($enter -eq $True)
    Update-Choice 0 $EndPos
    return $Selection
}

function YesNo(){
    Param ( 
        [Parameter(Mandatory=$True)][string]$Title,
        [Parameter(mandatory=$False)][String]$Default = "No"
    )
    [console]::CursorVisible = $false
    $Style = $PSStyle.ForeGround.Green + $PSStyle.Underline 
    $EnterPressed = $False
    $Selection = ($Default -eq "Yes")? 0 : 1
    Write-Host -NoNewLine "$Title (Default $Default)> "
    $PosX = $Host.UI.RawUI.CursorPosition.X 
    do{
        
        if($Selection -eq 0){
            Write-Host -NoNewLine $Style"Yes"
            Write-Host -NoNewLine " / "
            Write-Host "No"
        } else {
            Write-Host -NoNewLine "Yes"
            Write-Host -NoNewLine " / "
            Write-Host $Style"No"
        }
        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode
        switch($KeyInput){
            0x0D{
                $EnterPressed = $True
                break
            }
            0x25{
                $Selection = 0
                Update-Choice $PosX
                break
            }
            0x27{
                $Selection = 1
                Update-Choice $PosX
                break
            }
            default {
                Update-Choice $PosX
                break
            }
        }
    }while($EnterPressed -eq $False) 
    if ($Selection -eq 0) { return $True }
    return $False
}

function Update-Choice() {
    Param(
        [Parameter(Mandatory=$True)][int]$PosX,
        [Parameter(Mandatory=$False)][int]$PosY = ([Console]::CursorTop - 1)
    )
    
    [Console]::SetCursorPosition($PosX, $PosY)
}
