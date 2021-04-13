unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, EditBtn;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    edFilename: TFileNameEdit;
    edPassword: TEditButton;
    ImageList1: TImageList;
    lblFileName: TLabel;
    lblPassword: TLabel;
    Panel1: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure edFilenameAcceptFileName(Sender: TObject; var Value: String);
    procedure edPasswordButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ Extracts the password of a password-protected MDB database.
  Taken from: Delphi3000, Article ID 3663: "How to retrieve the password of a
  protected Access database?" (Sunish Isaac) }
function ExtractAccessPassword(const AFileName: string): ansistring;
const
  key: packed array[0..12] of byte
    = ($86, $FB, $EC, $37, $5D, $44, $9C, $FA, $C6, $5E, $28, $E6, $13);
var
  stream: TFileStream;
  buffer: array[0..12] of byte;
  i: integer;
  ch: ansichar;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead);
  try
    stream.Seek($42, soFromBeginning);
    stream.Read(buffer{%H-}, SizeOf(key));
    Result := '';
    for i := 0 to High(key) do begin
      ch := ansichar(buffer[i] xor key[i]);
      if ch = #0 then
        exit
      else
        Result := Result + ch;
    end;
  finally
    stream.Free;
  end;
end;


{ TForm1 }

procedure TForm1.edFilenameAcceptFileName(Sender: TObject; var Value: String);
var
  pwd: string;
begin
  edFilename.InitialDir := ExtractFileDir(Value);
  pwd := ExtractAccessPassword(Value);
  if pwd = '' then begin
    edPassword.Text := '- no password -';
    edPassword.ReadOnly := true;
  end else begin
    edPassword.Text := pwd;
    edPassword.ReadOnly := false;
  end;
end;

procedure TForm1.edPasswordButtonClick(Sender: TObject);
begin
  edPassword.SelectAll;
  edPassword.CopyToClipboard;
  edPassword.SelLength := 0;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.

