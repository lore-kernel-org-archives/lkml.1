Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYJ3BZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYJ3BZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYJ3BZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:25:18 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:52100 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbYJ3BZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:25:01 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 21:24:59 EDT
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Thu, 30 Oct 2008 02:15:18 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.4r4; KDE/4.1.71; x86_64; ; )
Cc: linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mqQCJkHuvEmEojz"
Message-Id: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_mqQCJkHuvEmEojz
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I have a A770Crossfire board from Asrock.
With kernel 2.6.26.X and 2.6.27.[1,2,3,4] I have the following problem that=
=20
makes usb mostly unusable.

I have a 4 port hub attached. A logitech mouse receiver is inserted into on=
e=20
of its ports - it does not matter which one. Everything works fine.

I turn on an external enclosure, which is either attached to one of the=20
mainboards ports or the hub. Everything works for a couple of seconds. I mo=
unt=20
the cdrom/harddisk partition and start copying a file - or just wait a coup=
le=20
of seconds.
USB completly locks up. First the mouse, then a bit later the file transfer=
=20
(so one was started) stops. Turning of the enclosure does not help, remving=
=20
the receiver and reinserting it, does not help, not using the hub does not=
=20
help.
Only thing that brings back USB:
rmmod ehci_hcd
modprobe ehci-hcd

rmmod and modprobe usb-storage does NOT help.

after that I get another couple of seconds until it locks up again.

If I modprobe ohci-hcd I get this:
with 2.6.26 and the mouse at ohci, enclosure at ehci, everything works - bu=
t=20
gaming (with fglrx loaded) is impossible, since the mouse is extremly jerky=
=20
(shared interrupts).
with 2.6.27 both mouse and enclose are driven by ohci - and copying works=20
without locking up. Trying to 'force' ehci for the enclosure makes it locku=
p=20
again.

This happens with kernel.org kernels+reiser4.

Another board with Nvidia nf520 chipset never showed this problems with=20
2.6.26. I have tried 3 different enclosures, one with a cdrom, two with=20
harddisks, all three show the same symptoms.

lsusb, mouse receiver in hub, only ehci loaded:
Bus 002 Device 001: ID 1d6b:0002
Bus 001 Device 003: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 001 Device 001: ID 1d6b:0002

lsusb with cdrom in a usb enclosure:
cat /home/lsusb_mit_cdrom
Bus 002 Device 001: ID 1d6b:0002
Bus 001 Device 004: ID 05e3:0701 Genesys Logic, Inc. USB 2.0 IDE Adapter
Bus 001 Device 003: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 001 Device 001: ID 1d6b:0002

interrupts:
          CPU0       CPU1
  0:         14          1   IO-APIC-edge      timer
  1:          0        400   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          3   IO-APIC-edge      i8042
 17:          1       2449   IO-APIC-fasteoi   ehci_hcd:usb1
 19:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 21:          0          4   IO-APIC-fasteoi   bttv0
 22:          4      11147   IO-APIC-fasteoi   ahci
 23:          0          0   IO-APIC-fasteoi   EMU10K1
316:          0        232   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:      97395      79417   Local timer interrupts
RES:       9963       3848   Rescheduling interrupts
CAL:       5881       1912   function call interrupts
TLB:        224        177   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

dmesg parts:

on boot:
[    7.906863] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17           =20
[    7.906875] ehci_hcd 0000:00:12.2: EHCI Host Controller                 =
                =20
[    7.906931] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1        =20
[    7.906969] ehci_hcd 0000:00:12.2: debug port 1                         =
                =20
[    7.906986] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000            =
                =20
[    7.917509] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004       =20
[    7.917582] usb usb1: configuration #1 chosen from 1 choice             =
                =20
[    7.917603] hub 1-0:1.0: USB hub found                                  =
                =20
[    7.917609] hub 1-0:1.0: 6 ports detected                               =
                =20
[    8.124261] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002               =20
[    8.124263] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1          =20
[    8.124265] usb usb1: Product: EHCI Host Controller                     =
                =20
[    8.124266] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd           =
                =20
[    8.124267] usb usb1: SerialNumber: 0000:00:12.2                        =
                =20
[    8.124290] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19           =20
[    8.124300] ehci_hcd 0000:00:13.2: EHCI Host Controller                 =
                =20
[    8.124335] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2        =20
[    8.124369] ehci_hcd 0000:00:13.2: debug port 1                         =
                =20
[    8.124387] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800            =
                =20
[    8.134180] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004       =20
[    8.134245] usb usb2: configuration #1 chosen from 1 choice             =
                =20
[    8.134268] hub 2-0:1.0: USB hub found                                  =
                =20
[    8.134274] hub 2-0:1.0: 6 ports detected                               =
                =20
[    8.237599] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002               =20
[    8.237602] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1          =20
[    8.237604] usb usb2: Product: EHCI Host Controller                     =
                =20
[    8.237605] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd           =
                =20
[    8.237606] usb usb2: SerialNumber: 0000:00:13.2                        =
                =20
[    8.240862] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 2           =20
    8.365879] usb 1-2: configuration #1 chosen from 1 choice               =
               =20
[    8.366107] hub 1-2:1.0: USB hub found                                  =
                =20
[    8.366339] hub 1-2:1.0: 4 ports detected                               =
                =20
[    8.574264] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608                =20
[    8.574267] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0           =20
[    8.574269] usb 1-2: Product: USB2.0 Hub                                =
                =20
[    8.641575] usb 1-2.2: new low speed USB device using ehci_hcd and addre=
ss=20
3            =20
[    8.730973] usb 1-2.2: configuration #1 chosen from 1 choice            =
                =20
[    8.741415] input: Logitech USB Receiver as /class/input/input3         =
                =20
[    8.774208] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n=20
usb-0000:00:12.2-2.2                                                       =
                               =20
[    8.780037] input: Logitech USB Receiver as /class/input/input4         =
                =20
[    8.807569] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB=20
Receiver] on usb-0000:00:12.2-2.2
[    8.807631] usb 1-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc518
[    8.807633] usb 1-2.2: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[    8.807634] usb 1-2.2: Product: USB Receiver
[    8.807635] usb 1-2.2: Manufacturer: Logitech

and turning on cdrom enclosure:
[  218.390824] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 4
[  218.524662] usb 1-1: configuration #1 chosen from 1 choice
[  218.525245] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0701
[  218.525250] usb 1-1: New USB device strings: Mfr=3D2, Product=3D3,=20
SerialNumber=3D0
[  218.525252] usb 1-1: Product: USB Mass Storage Device
[  218.525253] usb 1-1: Manufacturer: Genesyslogic
[  218.564013] Initializing USB Mass Storage driver...
[  218.564639] scsi6 : SCSI emulation for USB Mass Storage devices
[  218.564720] usb-storage: device found at 4
[  218.564725] usb-storage: waiting for device to settle before scanning
[  218.564732] usbcore: registered new interface driver usb-storage
[  218.564735] USB Mass Storage support registered.
[  223.563564] usb-storage: device scan complete
[  223.660792] scsi 6:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.=
19=20
PQ: 0 ANSI: 0
[  223.661073] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[  223.675766] Driver 'sr' needs updating - please use bus_type methods
[  223.770898] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[  223.770903] Uniform CD-ROM driver Revision: 3.20
[  223.770972] sr 6:0:0:0: Attached scsi CD-ROM sr0
[  291.280350] ISO 9660 Extensions: RRIP_1991A

and here is where the funs starts:

[  332.634154] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess=20
4           =20
[  347.770812] usb 1-1: device descriptor read/64, error -110              =
                =20
[  363.010812] usb 1-1: device descriptor read/64, error -110              =
                =20
[  363.220812] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess=20
4           =20
[  378.357476] usb 1-1: device descriptor read/64, error -110              =
                =20
[  393.544727] usb 1-1: USB disconnect, address 4                          =
                =20
[  393.545020] sr 6:0:0:0: Device offlined - not ready after error recovery=
                =20
[  393.545033] sr 6:0:0:0: [sr0] Result: hostbyte=3D0x05 driverbyte=3D0x00 =
                    =20
[  393.545037] end_request: I/O error, dev sr0, sector 1662128             =
                =20
[  393.545041] Buffer I/O error on device sr0, logical block 415532        =
                =20
[  393.545045] Buffer I/O error on device sr0, logical block 415533        =
                =20
[  393.545051] Buffer I/O error on device sr0, logical block 415534        =
                =20
[  393.545054] Buffer I/O error on device sr0, logical block 415535        =
                =20
[  393.545057] Buffer I/O error on device sr0, logical block 415536        =
                =20
[  393.545060] Buffer I/O error on device sr0, logical block 415537        =
                =20
[  393.545063] Buffer I/O error on device sr0, logical block 415538        =
                =20
[  393.545066] Buffer I/O error on device sr0, logical block 415539        =
                =20
[  393.545069] Buffer I/O error on device sr0, logical block 415540        =
                =20
[  393.545072] Buffer I/O error on device sr0, logical block 415541        =
                =20
[  393.545085] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545102] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545104] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545117] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545128] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545137] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545148] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545160] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545175] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545187] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545199] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545210] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545221] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545232] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545244] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545256] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545270] sr 6:0:0:0: [sr0] Result: hostbyte=3D0x01 driverbyte=3D0x00 =
                    =20
[  393.545272] end_request: I/O error, dev sr0, sector 1662192             =
                =20
[  393.545313] VFS: busy inodes on changed media.                          =
                =20
[  393.545481] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545486] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545603] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.545611] sr 6:0:0:0: rejecting I/O to offline device                 =
                =20
[  393.572083] scsi 6:0:0:0: rejecting I/O to dead device                  =
                =20
[  393.572300] scsi 6:0:0:0: rejecting I/O to dead device                  =
                =20
[  393.572369] scsi 6:0:0:0: rejecting I/O to dead device                  =
                =20
[  400.120806] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 5             =20
[  415.257471] usb 1-1: device descriptor read/64, error -110              =
                =20
[  430.497470] usb 1-1: device descriptor read/64, error -110              =
                =20
[  430.707468] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 6             =20
[  439.049097] ehci_hcd 0000:00:13.2: remove, state 4                      =
                =20
[  439.049107] usb usb2: USB disconnect, address 1                         =
                =20
[  439.050329] ehci_hcd 0000:00:13.2: USB bus 2 deregistered               =
                =20
[  439.050399] ehci_hcd 0000:00:13.2: PCI INT B disabled                   =
                =20
[  439.050409] ehci_hcd 0000:00:12.2: remove, state 1                      =
                =20
[  439.050414] usb usb1: USB disconnect, address 1                         =
                =20
[  440.727481] hub 1-0:1.0: cannot reset port 1 (err =3D -19)              =
                  =20
[  440.727487] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  440.727496] hub 1-0:1.0: cannot reset port 1 (err =3D -19)              =
                  =20
[  440.727498] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  440.727500] hub 1-0:1.0: cannot reset port 1 (err =3D -19)              =
                  =20
[  440.727502] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  440.727505] hub 1-0:1.0: unable to enumerate USB device on port 1       =
                =20
[  440.727506] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  440.747470] usb 1-2: USB disconnect, address 2                          =
                =20
[  440.747474] usb 1-2.2: USB disconnect, address 3                        =
                =20
[  440.826627] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024=
=20
0000c000 00000000 -> -110                                                  =
                                =20
[  440.838259] ehci_hcd 0000:00:12.2: USB bus 1 deregistered               =
                =20
[  440.838451] ehci_hcd 0000:00:12.2: PCI INT B disabled                   =
                =20
[  443.288544] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17           =20
[  443.288562] ehci_hcd 0000:00:12.2: EHCI Host Controller                 =
                =20
[  443.289133] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1        =20
[  443.289173] ehci_hcd 0000:00:12.2: debug port 1                         =
                =20
[  443.289185] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000            =
                =20
[  443.300241] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004       =20
[  443.300352] usb usb1: configuration #1 chosen from 1 choice             =
                =20
[  443.300377] hub 1-0:1.0: USB hub found                                  =
                =20
[  443.300385] hub 1-0:1.0: 6 ports detected                               =
                =20
[  443.507560] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002               =20
[  443.507564] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1          =20
[  443.507566] usb usb1: Product: EHCI Host Controller                     =
                =20
[  443.507569] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd           =
                =20
[  443.507571] usb usb1: SerialNumber: 0000:00:12.2                        =
                =20
[  443.507594] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19           =20
[  443.507606] ehci_hcd 0000:00:13.2: EHCI Host Controller                 =
                =20
[  443.507644] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2        =20
[  443.507679] ehci_hcd 0000:00:13.2: debug port 1                         =
                =20
[  443.507691] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800            =
                =20
[  443.517470] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004       =20
[  443.517556] usb usb2: configuration #1 chosen from 1 choice             =
                =20
[  443.517579] hub 2-0:1.0: USB hub found                                  =
                =20
[  443.517586] hub 2-0:1.0: 6 ports detected                               =
                =20
[  443.620902] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002               =20
[  443.620906] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1          =20
[  443.620908] usb usb2: Product: EHCI Host Controller                     =
                =20
[  443.620910] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd           =
                =20
[  443.620913] usb usb2: SerialNumber: 0000:00:13.2                        =
                =20
[  443.624147] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2             =20
[  443.757595] usb 1-1: configuration #1 chosen from 1 choice              =
                =20
[  443.760852] scsi7 : SCSI emulation for USB Mass Storage devices         =
                =20
[  443.761012] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0701                =20
[  443.761016] usb 1-1: New USB device strings: Mfr=3D2, Product=3D3,=20
SerialNumber=3D0           =20
[  443.761018] usb 1-1: Product: USB Mass Storage Device                   =
                =20
[  443.761019] usb 1-1: Manufacturer: Genesyslogic                         =
                =20
[  443.761111] usb-storage: device found at 2                              =
                =20
[  443.761113] usb-storage: waiting for device to settle before scanning   =
                =20
[  443.867470] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 3             =20
[  443.992571] usb 1-2: configuration #1 chosen from 1 choice              =
                =20
[  443.992786] hub 1-2:1.0: USB hub found                                  =
                =20
[  443.993136] hub 1-2:1.0: 4 ports detected                               =
                =20
[  444.200888] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608                =20
[  444.200892] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0           =20
[  444.200894] usb 1-2: Product: USB2.0 Hub                                =
                =20
[  444.267751] usb 1-2.2: new low speed USB device using ehci_hcd and addre=
ss=20
4            =20
[  444.358581] usb 1-2.2: configuration #1 chosen from 1 choice            =
                =20
[  444.368837] input: Logitech USB Receiver as /class/input/input5         =
                =20
[  444.402089] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n=20
usb-0000:00:12.2-2.2                                                       =
                               =20
[  444.424061] input: Logitech USB Receiver as /class/input/input6         =
                =20
[  444.457545] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB=20
Receiver] on usb-0000:00:12.2-2.2                                          =
                                  =20
[  444.457615] usb 1-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc518              =20
[  444.457617] usb 1-2.2: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0         =20
[  444.457619] usb 1-2.2: Product: USB Receiver                            =
                =20
[  444.457620] usb 1-2.2: Manufacturer: Logitech                           =
                =20
[  448.761103] usb-storage: device scan complete                           =
                =20
[  448.762343] scsi 7:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.=
19=20
PQ: 0 ANSI: 0=20
[  448.768983] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tra=
y               =20
[  448.770775] sr 7:0:0:0: Attached scsi CD-ROM sr0                        =
                =20
[  448.770921] sr 7:0:0:0: Attached scsi generic sg2 type 5                =
                =20
[  557.656626] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess=20
2           =20
[  572.793288] usb 1-1: device descriptor read/64, error -110              =
                =20
[  587.357595] ehci_hcd 0000:00:13.2: remove, state 4                      =
                =20
[  587.357605] usb usb2: USB disconnect, address 1                         =
                =20
[  587.357833] ehci_hcd 0000:00:13.2: USB bus 2 deregistered               =
                =20
[  587.357897] ehci_hcd 0000:00:13.2: PCI INT B disabled                   =
                =20
[  587.357908] ehci_hcd 0000:00:12.2: remove, state 1                      =
                =20
[  587.357913] usb usb1: USB disconnect, address 1                         =
                =20
[  587.357914] usb 1-1: USB disconnect, address 0                          =
                =20
[  587.926629] hub 1-0:1.0: cannot reset port 1 (err =3D -19)              =
                  =20
[  587.926634] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  587.926636] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[  587.926828] sr 7:0:0:0: Device offlined - not ready after error recovery=
                =20
[  587.926975] scsi 7:0:0:0: rejecting I/O to dead device                  =
                =20
[  587.926981] scsi 7:0:0:0: rejecting I/O to dead device                  =
                =20
[  587.926985] scsi 7:0:0:0: rejecting I/O to dead device                  =
                =20
[  587.926989] scsi 7:0:0:0: rejecting I/O to dead device                  =
                =20
[  587.927458] usb 1-2: USB disconnect, address 3                          =
                =20
[  587.927464] usb 1-2.2: USB disconnect, address 4                        =
                =20
[  588.024111] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024=
=20
0000c000 00000000 -> -110
[  588.036066] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[  588.036155] ehci_hcd 0000:00:12.2: PCI INT B disabled
[  590.188780] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17
[  590.188794] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  590.188862] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1
[  590.188900] ehci_hcd 0000:00:12.2: debug port 1
[  590.188912] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[  590.197454] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[  590.197563] usb usb1: configuration #1 chosen from 1 choice
[  590.197587] hub 1-0:1.0: USB hub found
[  590.197595] hub 1-0:1.0: 6 ports detected
[  590.404219] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[  590.404224] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[  590.404226] usb usb1: Product: EHCI Host Controller
[  590.404228] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  590.404230] usb usb1: SerialNumber: 0000:00:12.2
[  590.404254] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19
[  590.404266] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  590.404305] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2
[  590.404341] ehci_hcd 0000:00:13.2: debug port 1
[  590.404353] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[  590.414122] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[  590.414205] usb usb2: configuration #1 chosen from 1 choice
[  590.414229] hub 2-0:1.0: USB hub found
[  590.414236] hub 2-0:1.0: 6 ports detected
[  590.517549] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[  590.517553] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[  590.517555] usb usb2: Product: EHCI Host Controller
[  590.517557] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  590.517560] usb usb2: SerialNumber: 0000:00:13.2
[  590.520798] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 2
[  590.645820] usb 1-2: configuration #1 chosen from 1 choice
[  590.646034] hub 1-2:1.0: USB hub found
[  590.646385] hub 1-2:1.0: 4 ports detected
[  590.854211] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608
[  590.854215] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0
[  590.854217] usb 1-2: Product: USB2.0 Hub
[  590.921122] usb 1-2.2: new low speed USB device using ehci_hcd and addre=
ss=20
3
[  591.011038] usb 1-2.2: configuration #1 chosen from 1 choice
[  591.023018] input: Logitech USB Receiver as /class/input/input7
[  591.065109] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n=20
usb-0000:00:12.2-2.2
[  591.080005] input: Logitech USB Receiver as /class/input/input8
[  591.118378] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB=20
Receiver] on usb-0000:00:12.2-2.2
[  591.118449] usb 1-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc518
[  591.118451] usb 1-2.2: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[  591.118452] usb 1-2.2: Product: USB Receiver
[  591.118453] usb 1-2.2: Manufacturer: Logitech

and again:

mouse works, I turn on cdrom:
[ 1494.097363] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 4             =20
[ 1494.230935] usb 1-1: configuration #1 chosen from 1 choice              =
                =20
[ 1494.231387] scsi8 : SCSI emulation for USB Mass Storage devices         =
                =20
[ 1494.231653] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0701                =20
[ 1494.231658] usb 1-1: New USB device strings: Mfr=3D2, Product=3D3,=20
SerialNumber=3D0           =20
[ 1494.231660] usb 1-1: Product: USB Mass Storage Device                   =
                =20
[ 1494.231661] usb 1-1: Manufacturer: Genesyslogic                         =
                =20
[ 1494.231665] usb-storage: device found at 4                              =
                =20
[ 1494.231667] usb-storage: waiting for device to settle before scanning   =
                =20
[ 1499.230962] usb-storage: device scan complete                           =
                =20
[ 1499.258449] scsi 8:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.=
19=20
PQ: 0 ANSI: 0=20
[ 1499.350559] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tra=
y               =20
[ 1499.351554] sr 8:0:0:0: Attached scsi CD-ROM sr0                        =
                =20
[ 1499.351688] sr 8:0:0:0: Attached scsi generic sg2 type 5                =
                =20
[ 1531.767361] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess=20
4           =20
[ 1546.904030] usb 1-1: device descriptor read/64, error -110              =
                =20
[ 1562.144026] usb 1-1: device descriptor read/64, error -110              =
                =20
[ 1562.354025] usb 1-1: reset high speed USB device using ehci_hcd and addr=
ess=20
4           =20

and it locks up. I rmmod & modprobe ehci

[ 1571.031747] ehci_hcd 0000:00:13.2: remove, state 4                      =
                =20
[ 1571.031757] usb usb2: USB disconnect, address 1                         =
                =20
[ 1571.031991] ehci_hcd 0000:00:13.2: USB bus 2 deregistered               =
                =20
[ 1571.032056] ehci_hcd 0000:00:13.2: PCI INT B disabled                   =
                =20
[ 1571.032064] ehci_hcd 0000:00:12.2: remove, state 1                      =
                =20
[ 1571.032070] usb usb1: USB disconnect, address 1                         =
                =20
[ 1571.032071] usb 1-1: USB disconnect, address 0                          =
                =20
[ 1572.374030] hub 1-0:1.0: cannot reset port 1 (err =3D -19)              =
                  =20
[ 1572.374036] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[ 1572.374039] hub 1-0:1.0: cannot disable port 1 (err =3D -19)            =
                  =20
[ 1572.374435] scsi 8:0:0:0: Device offlined - not ready after error recove=
ry              =20
[ 1572.374575] usb 1-2: USB disconnect, address 2                          =
                =20
[ 1572.374581] usb 1-2.2: USB disconnect, address 3                        =
                =20
[ 1572.377436] scsi 8:0:0:0: rejecting I/O to dead device                  =
                =20
[ 1572.377451] scsi 8:0:0:0: rejecting I/O to dead device                  =
                =20
[ 1572.377456] scsi 8:0:0:0: rejecting I/O to dead device                  =
                =20
[ 1572.477346] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024=
=20
0000c000 00000000 -> -110                                                  =
                                =20
[ 1572.489340] ehci_hcd 0000:00:12.2: USB bus 1 deregistered               =
                =20
[ 1572.489430] ehci_hcd 0000:00:12.2: PCI INT B disabled                   =
                =20
[ 1574.758187] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> I=
RQ=20
17           =20
[ 1574.758204] ehci_hcd 0000:00:12.2: EHCI Host Controller                 =
                =20
[ 1574.758801] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus=
=20
number 1        =20
[ 1574.758841] ehci_hcd 0000:00:12.2: debug port 1                         =
                =20
[ 1574.758854] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000            =
                =20
[ 1574.770181] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004       =20
[ 1574.770293] usb usb1: configuration #1 chosen from 1 choice
[ 1574.770318] hub 1-0:1.0: USB hub found
[ 1574.770326] hub 1-0:1.0: 6 ports detected
[ 1574.977449] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[ 1574.977454] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[ 1574.977456] usb usb1: Product: EHCI Host Controller
[ 1574.977458] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1574.977460] usb usb1: SerialNumber: 0000:00:12.2
[ 1574.977483] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> I=
RQ=20
19
[ 1574.977496] ehci_hcd 0000:00:13.2: EHCI Host Controller
[ 1574.977536] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus=
=20
number 2
[ 1574.977571] ehci_hcd 0000:00:13.2: debug port 1
[ 1574.977583] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[ 1574.987358] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[ 1574.987442] usb usb2: configuration #1 chosen from 1 choice
[ 1574.987470] hub 2-0:1.0: USB hub found
[ 1574.987477] hub 2-0:1.0: 6 ports detected
[ 1575.090791] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[ 1575.090796] usb usb2: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[ 1575.090798] usb usb2: Product: EHCI Host Controller
[ 1575.090800] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1575.090803] usb usb2: SerialNumber: 0000:00:13.2
[ 1575.094032] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[ 1575.227511] usb 1-1: configuration #1 chosen from 1 choice
[ 1575.227959] scsi9 : SCSI emulation for USB Mass Storage devices
[ 1575.228120] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0701
[ 1575.228124] usb 1-1: New USB device strings: Mfr=3D2, Product=3D3,=20
SerialNumber=3D0
[ 1575.228126] usb 1-1: Product: USB Mass Storage Device
[ 1575.228127] usb 1-1: Manufacturer: Genesyslogic
[ 1575.228219] usb-storage: device found at 2
[ 1575.228220] usb-storage: waiting for device to settle before scanning
[ 1575.334022] usb 1-2: new high speed USB device using ehci_hcd and addres=
s 3
[ 1575.459111] usb 1-2: configuration #1 chosen from 1 choice
[ 1575.459328] hub 1-2:1.0: USB hub found
[ 1575.459679] hub 1-2:1.0: 4 ports detected
[ 1575.667443] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608
[ 1575.667447] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1,=20
SerialNumber=3D0
[ 1575.667448] usb 1-2: Product: USB2.0 Hub
[ 1575.734416] usb 1-2.2: new low speed USB device using ehci_hcd and addre=
ss=20
4
[ 1575.824203] usb 1-2.2: configuration #1 chosen from 1 choice
[ 1575.835976] input: Logitech USB Receiver as /class/input/input9
[ 1575.864086] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] o=
n=20
usb-0000:00:12.2-2.2
[ 1575.870254] input: Logitech USB Receiver as /class/input/input10
[ 1575.917434] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB=20
Receiver] on usb-0000:00:12.2-2.2
[ 1575.917505] usb 1-2.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc518
[ 1575.917507] usb 1-2.2: New USB device strings: Mfr=3D1, Product=3D2,=20
SerialNumber=3D0
[ 1575.917508] usb 1-2.2: Product: USB Receiver
[ 1575.917509] usb 1-2.2: Manufacturer: Logitech

config is attached.
complete dmesg is attached.
lsmod is attached.
lspci -vvv is attached

Gl=FCck Auf,
Volker

--Boundary-00=_mqQCJkHuvEmEojz
Content-Type: text/plain;
  charset="UTF-8";
  name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27.4
# Wed Oct 29 20:20:38 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="r4"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=16
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_SGI_XP is not set
# CONFIG_HP_ILO is not set
# CONFIG_SGI_GRU is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
CONFIG_RTL8180=m
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_INTEL is not set
CONFIG_HW_RANDOM_AMD=m
CONFIG_NVRAM=m
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
# CONFIG_VIDEO_SAA6588 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
# CONFIG_USB_GSPCA is not set
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_VIDEO_SH_MOBILE_CEU is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_DVB_CINERGYT2=m
# CONFIG_DVB_CINERGYT2_TUNING is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
# CONFIG_DVB_BT8XX is not set

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_DRX397XD is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_TDA10048 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522 is not set
# CONFIG_DVB_S5H1411 is not set

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
CONFIG_SND_VIRMIDI=m
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_EMU10K1=m
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
# CONFIG_SND_HDA_CODEC_VIA is not set
CONFIG_SND_HDA_CODEC_ATIHDMI=y
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
# CONFIG_SND_HDA_GENERIC is not set
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_REISER4_FS=y
# CONFIG_REISER4_DEBUG is not set
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
# CONFIG_FTRACE is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-00=_mqQCJkHuvEmEojz
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.27.4r4 (root@energy) (gcc version 4.3.2 (Gentoo 4.3.2 p1.0) ) #4 SMP Wed Oct 29 20:28:06 CET 2008
[    0.000000] Command line: root=/dev/md1 md=1,1,/dev/sda3,/dev/sdb3 nopat nmi_watchdog=0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ceeb0000 (usable)
[    0.000000]  BIOS-e820: 00000000ceeb0000 - 00000000ceec0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000ceec0000 - 00000000ceef0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ceef0000 - 00000000cef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000131000000 (usable)
[    0.000000] PAT support disabled.
[    0.000000] last_pfn = 0x131000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xceeb0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 00cee00000 page 2M
[    0.000000]  00cee00000 - 00ceeb0000 page 4k
[    0.000000] kernel direct mapping tables up to ceeb0000 @ 8000-e000
[    0.000000] last_map_addr: ceeb0000 end: ceeb0000
[    0.000000] init_memory_mapping
[    0.000000]  0100000000 - 0131000000 page 2M
[    0.000000] kernel direct mapping tables up to 131000000 @ c000-12000
[    0.000000] last_map_addr: 131000000 end: 131000000
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FA390, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CEEB0000, 003C (r1 090808 RSDT1057 20080908 MSFT       97)
[    0.000000] ACPI: FACP CEEB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT       97)
[    0.000000] ACPI: DSDT CEEB0440, 74C0 (r1  AS140 AS140103      103 INTL 20051117)
[    0.000000] ACPI: FACS CEEC0000, 0040
[    0.000000] ACPI: APIC CEEB0390, 006C (r1 090808 APIC1057 20080908 MSFT       97)
[    0.000000] ACPI: MCFG CEEB0400, 003C (r1 090808 OEMMCFG  20080908 MSFT       97)
[    0.000000] ACPI: OEMB CEEC0040, 0071 (r1 090808 OEMB1057 20080908 MSFT       97)
[    0.000000] ACPI: HPET CEEB7900, 0038 (r1 090808 OEMHPET  20080908 MSFT       97)
[    0.000000] ACPI: SSDT CEEB7940, 030E (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 0131000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000708028]    TEXT DATA BSS ==> [0000200000 - 0000708028]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #5 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00131000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000ceeb0
[    0.000000]     0: 0x00100000 -> 0x00131000
[    0.000000] On node 0 totalpages: 1048143
[    0.000000]   DMA zone: 2551 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 829160 pages, LIFO batch:31
[    0.000000]   Normal zone: 197960 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000ceeb0000 - 00000000ceec0000
[    0.000000] PM: Registered nosave memory: 00000000ceec0000 - 00000000ceef0000
[    0.000000] PM: Registered nosave memory: 00000000ceef0000 - 00000000cef00000
[    0.000000] PM: Registered nosave memory: 00000000cef00000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: cef00000:31000000)
[    0.000000] PERCPU: Allocating 45792 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1029671
[    0.000000] Kernel command line: root=/dev/md1 md=1,1,/dev/sda3,/dev/sdb3 nopat nmi_watchdog=0
[    0.000000] md: Will configure md1 (super-block) from 1,/dev/sda3,/dev/sdb3, below.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC: PIT calibration confirmed by PMTIMER.
[    0.000000] TSC: using PIT calibration value
[    0.000000] Detected 3000.078 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003333] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003333] Checking aperture...
[    0.003333] No AGP bridge found
[    0.003333] Node 0: aperture @ 20000000 size 32 MB
[    0.003333] Aperture pointing to e820 RAM. Ignoring.
[    0.003333] Your BIOS doesn't leave a aperture memory hole
[    0.003333] Please enable the IOMMU option in the BIOS setup
[    0.003333] This costs you 64 MB of RAM
[    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.003333] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.003333] Memory: 4042784k/4997120k available (3234k kernel code, 148912k reserved, 1104k data, 304k init)
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003338] Calibrating delay loop (skipped), value calculated using timer frequency.. 6002.16 BogoMIPS (lpj=10000260)
[    0.003454] Mount-cache hash table entries: 256
[    0.003603] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003656] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003709] tseg: 0000000000
[    0.003714] CPU: Physical Processor ID: 0
[    0.003765] CPU: Processor Core ID: 0
[    0.003822] using C1E aware idle routine
[    0.003884] ACPI: Core revision 20080609
[    0.011408] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044469] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.044555] Using local APIC timer interrupts.
[    0.046667] APIC timer calibration result 12500333
[    0.046668] Detected 12.500 MHz APIC timer.
[    0.046785] Booting processor 1/1 ip 6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 6002.15 BogoMIPS (lpj=10000244)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.140128] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[    0.140561] Brought up 2 CPUs
[    0.140613] Total of 2 processors activated (12005.31 BogoMIPS).
[    0.140854] net_namespace: 800 bytes
[    0.140940] Time:  1:39:50  Date: 10/30/08
[    0.141004] NET: Registered protocol family 16
[    0.141160] No dock devices found.
[    0.141265] node 0 link 0: io port [1000, ffffff]
[    0.141267] TOM: 00000000cf000000 aka 3312M
[    0.141321] node 0 link 0: mmio [e0000000, efffffff]
[    0.141323] node 0 link 0: mmio [f0000000, ffffffff]
[    0.141325] node 0 link 0: mmio [a0000, bffff]
[    0.141327] node 0 link 0: mmio [cf000000, dfffffff]
[    0.141329] TOM2: 0000000131000000 aka 4880M
[    0.141381] bus: [00,07] on node 0 link 0
[    0.141382] bus: 00 index 0 io port: [0, ffff]
[    0.141384] bus: 00 index 1 mmio: [cf000000, ffffffff]
[    0.141385] bus: 00 index 2 mmio: [a0000, bffff]
[    0.141386] bus: 00 index 3 mmio: [131000000, fcffffffff]
[    0.141391] ACPI: bus type pci registered
[    0.141501] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.141555] PCI: Not using MMCONFIG.
[    0.141607] PCI: Using configuration type 1 for base access
[    0.142539] ACPI: EC: Look up EC in DSDT
[    0.149268] ACPI: Interpreter enabled
[    0.149321] ACPI: (supports S0 S1 S3 S4 S5)
[    0.149465] ACPI: Using IOAPIC for interrupt routing
[    0.149558] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.152768] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.156003] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.162194] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.162302] PCI: 0000:00:00.0 reg 1c 64bit mmio: [e0000000, ffffffff]
[    0.162343] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.162398] pci 0000:00:02.0: PME# disabled
[    0.162480] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.162534] pci 0000:00:09.0: PME# disabled
[    0.162609] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.162663] pci 0000:00:0a.0: PME# disabled
[    0.162757] PCI: 0000:00:11.0 reg 10 io port: [a000, a007]
[    0.162764] PCI: 0000:00:11.0 reg 14 io port: [9000, 9003]
[    0.162770] PCI: 0000:00:11.0 reg 18 io port: [8000, 8007]
[    0.162777] PCI: 0000:00:11.0 reg 1c io port: [7000, 7003]
[    0.162784] PCI: 0000:00:11.0 reg 20 io port: [6000, 600f]
[    0.162790] PCI: 0000:00:11.0 reg 24 32bit mmio: [fddff800, fddffbff]
[    0.162829] PCI: 0000:00:12.0 reg 10 32bit mmio: [fddfe000, fddfefff]
[    0.162882] PCI: 0000:00:12.1 reg 10 32bit mmio: [fddfd000, fddfdfff]
[    0.162953] PCI: 0000:00:12.2 reg 10 32bit mmio: [fddff000, fddff0ff]
[    0.162999] pci 0000:00:12.2: supports D1
[    0.163000] pci 0000:00:12.2: supports D2
[    0.163002] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.163057] pci 0000:00:12.2: PME# disabled
[    0.163132] PCI: 0000:00:13.0 reg 10 32bit mmio: [fddfc000, fddfcfff]
[    0.163184] PCI: 0000:00:13.1 reg 10 32bit mmio: [fddf7000, fddf7fff]
[    0.163255] PCI: 0000:00:13.2 reg 10 32bit mmio: [fddf6800, fddf68ff]
[    0.163302] pci 0000:00:13.2: supports D1
[    0.163303] pci 0000:00:13.2: supports D2
[    0.163304] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.163336] pci 0000:00:13.2: PME# disabled
[    0.163487] PCI: 0000:00:14.1 reg 10 io port: [0, 7]
[    0.163494] PCI: 0000:00:14.1 reg 14 io port: [0, 3]
[    0.163500] PCI: 0000:00:14.1 reg 18 io port: [0, 7]
[    0.163507] PCI: 0000:00:14.1 reg 1c io port: [0, 3]
[    0.163513] PCI: 0000:00:14.1 reg 20 io port: [ff00, ff0f]
[    0.163632] PCI: 0000:00:14.5 reg 10 32bit mmio: [fddf5000, fddf5fff]
[    0.163750] PCI: 0000:02:00.0 reg 10 32bit mmio: [d0000000, dfffffff]
[    0.163762] PCI: 0000:02:00.0 reg 18 64bit mmio: [fdff0000, fdffffff]
[    0.163767] PCI: 0000:02:00.0 reg 20 io port: [c000, c0ff]
[    0.163775] PCI: 0000:02:00.0 reg 30 32bit mmio: [fdfc0000, fdfdffff]
[    0.163789] pci 0000:02:00.0: supports D1
[    0.163790] pci 0000:02:00.0: supports D2
[    0.163814] PCI: 0000:02:00.1 reg 10 64bit mmio: [fdfec000, fdfeffff]
[    0.163845] pci 0000:02:00.1: supports D1
[    0.163846] pci 0000:02:00.1: supports D2
[    0.163893] PCI: bridge 0000:00:02.0 io port: [c000, cfff]
[    0.163895] PCI: bridge 0000:00:02.0 32bit mmio: [fdf00000, fdffffff]
[    0.163899] PCI: bridge 0000:00:02.0 64bit mmio pref: [d0000000, dfffffff]
[    0.163944] PCI: bridge 0000:00:09.0 io port: [d000, dfff]
[    0.163947] PCI: bridge 0000:00:09.0 32bit mmio: [fe000000, feafffff]
[    0.163950] PCI: bridge 0000:00:09.0 64bit mmio pref: [fa000000, fcefffff]
[    0.163984] PCI: 0000:01:00.0 reg 10 io port: [b800, b8ff]
[    0.163995] PCI: 0000:01:00.0 reg 18 32bit mmio: [cffff000, cfffffff]
[    0.164006] PCI: 0000:01:00.0 reg 20 32bit mmio: [cffe0000, cffeffff]
[    0.164016] PCI: 0000:01:00.0 reg 30 32bit mmio: [fdef0000, fdefffff]
[    0.164038] pci 0000:01:00.0: supports D1
[    0.164039] pci 0000:01:00.0: supports D2
[    0.164040] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.164095] pci 0000:01:00.0: PME# disabled
[    0.164188] PCI: bridge 0000:00:0a.0 io port: [b000, bfff]
[    0.164190] PCI: bridge 0000:00:0a.0 32bit mmio: [fde00000, fdefffff]
[    0.164194] PCI: bridge 0000:00:0a.0 64bit mmio pref: [cff00000, cfffffff]
[    0.164244] PCI: 0000:05:05.0 reg 10 io port: [e800, e8ff]
[    0.164251] PCI: 0000:05:05.0 reg 14 32bit mmio: [febff000, febfffff]
[    0.164285] PCI: 0000:05:05.0 reg 30 32bit mmio: [febe0000, febeffff]
[    0.164323] PCI: 0000:05:06.0 reg 10 32bit mmio: [fcfff000, fcffffff]
[    0.164405] PCI: 0000:05:08.0 reg 10 io port: [e400, e43f]
[    0.164461] pci 0000:05:08.0: supports D1
[    0.164462] pci 0000:05:08.0: supports D2
[    0.164499] pci 0000:00:14.4: transparent bridge
[    0.164554] PCI: bridge 0000:00:14.4 io port: [e000, efff]
[    0.164558] PCI: bridge 0000:00:14.4 32bit mmio: [feb00000, febfffff]
[    0.164562] PCI: bridge 0000:00:14.4 32bit mmio pref: [fcf00000, fcffffff]
[    0.164576] bus 00 -> node 0
[    0.164581] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.164854] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.164936] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.165019] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.165138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
[    0.167486] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
[    0.167774] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
[    0.168060] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
[    0.168345] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.168630] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
[    0.168915] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 *10 11 12 14 15)
[    0.169201] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
[    0.169470] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
[    0.169777] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.169848] pnp: PnP ACPI init
[    0.169905] ACPI: bus type pnp registered
[    0.171137] pnp 00:08: mem resource (0xfec00000-0xfec00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.171226] pnp 00:08: mem resource (0xfee00000-0xfee00fff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.171510] pnp 00:09: mem resource (0xffb80000-0xffbfffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.171599] pnp 00:09: mem resource (0xfec10000-0xfec1001f) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.172229] pnp 00:0c: mem resource (0xe0000000-0xefffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.173617] pnp 00:0d: mem resource (0xfec00000-0xffffffff) overlaps 0000:00:00.0 BAR 3 (0xe0000000-0xffffffff), disabling
[    0.173979] pnp: PnP ACPI: found 14 devices
[    0.174032] ACPI: ACPI bus type pnp unregistered
[    0.174188] SCSI subsystem initialized
[    0.174290] libata version 3.00 loaded.
[    0.174359] usbcore: registered new interface driver usbfs
[    0.174438] usbcore: registered new interface driver hub
[    0.174520] usbcore: registered new device driver usb
[    0.174685] PCI: Using ACPI for IRQ routing
[    0.174743] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.186670] DMAR:parse DMAR table failure.
[    0.186902] PCI-DMA: Disabling AGP.
[    0.187068] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.187120] PCI-DMA: using GART IOMMU.
[    0.187174] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.187703] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.187842] hpet0: 4 32-bit timers, 14318180 Hz
[    0.188938] ACPI: RTC can wake from S4
[    0.190012] Switched to high resolution mode on CPU 0
[    0.190098] Switched to high resolution mode on CPU 1
[    0.200038] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    0.200092] system 00:09: ioport range 0x40b-0x40b has been reserved
[    0.200145] system 00:09: ioport range 0x4d6-0x4d6 has been reserved
[    0.200199] system 00:09: ioport range 0xc00-0xc01 has been reserved
[    0.200252] system 00:09: ioport range 0xc14-0xc14 has been reserved
[    0.200305] system 00:09: ioport range 0xc50-0xc51 has been reserved
[    0.200358] system 00:09: ioport range 0xc52-0xc52 has been reserved
[    0.200411] system 00:09: ioport range 0xc6c-0xc6c has been reserved
[    0.200465] system 00:09: ioport range 0xc6f-0xc6f has been reserved
[    0.200518] system 00:09: ioport range 0xcd0-0xcd1 has been reserved
[    0.200571] system 00:09: ioport range 0xcd2-0xcd3 has been reserved
[    0.200624] system 00:09: ioport range 0xcd4-0xcd5 has been reserved
[    0.200677] system 00:09: ioport range 0xcd6-0xcd7 has been reserved
[    0.200731] system 00:09: ioport range 0xcd8-0xcdf has been reserved
[    0.200784] system 00:09: ioport range 0x800-0x89f has been reserved
[    0.200841] system 00:09: ioport range 0xb00-0xb0f has been reserved
[    0.200896] system 00:09: ioport range 0xb20-0xb3f has been reserved
[    0.200950] system 00:09: ioport range 0x900-0x90f has been reserved
[    0.201003] system 00:09: ioport range 0x910-0x91f has been reserved
[    0.201057] system 00:09: ioport range 0xfe00-0xfefe has been reserved
[    0.201113] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.201171] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.201224] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.201278] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.201331] system 00:0d: iomem range 0x100000-0xceefffff could not be reserved
[    0.206364] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
[    0.206418] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
[    0.206472] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.206526] pci 0000:00:02.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.206615] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
[    0.206680] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
[    0.206734] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfeafffff
[    0.206787] pci 0000:00:09.0:   PREFETCH window: 0x000000fa000000-0x000000fcefffff
[    0.206877] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
[    0.206930] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
[    0.206984] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
[    0.207037] pci 0000:00:0a.0:   PREFETCH window: 0x000000cff00000-0x000000cfffffff
[    0.207129] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
[    0.207183] pci 0000:00:14.4:   IO window: 0xe000-0xefff
[    0.207239] pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
[    0.207294] pci 0000:00:14.4:   PREFETCH window: 0x000000fcf00000-0x000000fcffffff
[    0.207394] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.207449] pci 0000:00:02.0: setting latency timer to 64
[    0.207454] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.207512] pci 0000:00:09.0: setting latency timer to 64
[    0.207516] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.207570] pci 0000:00:0a.0: setting latency timer to 64
[    0.207576] bus: 00 index 0 io port: [0, ffff]
[    0.207628] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.207681] bus: 02 index 0 io port: [c000, cfff]
[    0.207733] bus: 02 index 1 mmio: [fdf00000, fdffffff]
[    0.207786] bus: 02 index 2 mmio: [d0000000, dfffffff]
[    0.207838] bus: 02 index 3 mmio: [0, 0]
[    0.207890] bus: 03 index 0 io port: [d000, dfff]
[    0.207943] bus: 03 index 1 mmio: [fe000000, feafffff]
[    0.207995] bus: 03 index 2 mmio: [fa000000, fcefffff]
[    0.208048] bus: 03 index 3 mmio: [0, 0]
[    0.208100] bus: 01 index 0 io port: [b000, bfff]
[    0.208152] bus: 01 index 1 mmio: [fde00000, fdefffff]
[    0.208204] bus: 01 index 2 mmio: [cff00000, cfffffff]
[    0.208257] bus: 01 index 3 mmio: [0, 0]
[    0.208309] bus: 05 index 0 io port: [e000, efff]
[    0.208361] bus: 05 index 1 mmio: [feb00000, febfffff]
[    0.208414] bus: 05 index 2 mmio: [fcf00000, fcffffff]
[    0.208466] bus: 05 index 3 io port: [0, ffff]
[    0.208518] bus: 05 index 4 mmio: [0, ffffffffffffffff]
[    0.208576] NET: Registered protocol family 2
[    0.240023] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.240456] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.241946] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.242447] TCP: Hash tables configured (established 262144 bind 65536)
[    0.242501] TCP reno registered
[    0.250048] NET: Registered protocol family 1
[    0.251321] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.251464] Loading Reiser4. See www.namesys.com for a description of Reiser4.
[    0.251582] msgmni has been set to 7897
[    0.251696] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.251784] io scheduler noop registered
[    0.251838] io scheduler cfq registered (default)
[    0.251959] pci 0000:02:00.0: Boot video device
[    0.252031] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.252053] pcieport-driver 0000:00:02.0: found MSI capability
[    0.252128] pci_express 0000:00:02.0:pcie00: allocate port service
[    0.252188] pcieport-driver 0000:00:09.0: setting latency timer to 64
[    0.252209] pcieport-driver 0000:00:09.0: found MSI capability
[    0.252281] pci_express 0000:00:09.0:pcie00: allocate port service
[    0.252337] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    0.252357] pcieport-driver 0000:00:0a.0: found MSI capability
[    0.252429] pci_express 0000:00:0a.0:pcie00: allocate port service
[    0.252650] input: Power Button (FF) as /class/input/input0
[    0.252703] ACPI: Power Button (FF) [PWRF]
[    0.252810] input: Power Button (CM) as /class/input/input1
[    0.252863] ACPI: Power Button (CM) [PWRB]
[    0.253096] processor ACPI0007:00: registered as cooling_device0
[    0.253151] ACPI: Processor [P001] (supports 8 throttling states)
[    0.253277] processor ACPI0007:01: registered as cooling_device1
[    0.286784] hpet_resources: 0xfed00000 is busy
[    0.286818] Linux agpgart interface v0.103
[    0.286988] Driver 'sd' needs updating - please use bus_type methods
[    0.287102] ahci 0000:00:11.0: version 3.0
[    0.287114] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.287285] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.287373] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.287800] scsi0 : ahci
[    0.287925] scsi1 : ahci
[    0.288035] scsi2 : ahci
[    0.288141] scsi3 : ahci
[    0.288249] scsi4 : ahci
[    0.288355] scsi5 : ahci
[    0.288496] ata1: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff900 irq 22
[    0.288585] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 22
[    0.288674] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 22
[    0.288763] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 22
[    0.288852] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 22
[    0.288941] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 22
[    0.767509] ata1: softreset failed (device not ready)
[    0.767566] ata1: failed due to HW bug, retry pmp=0
[    0.927519] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.933878] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
[    0.933931] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    0.940344] ata1.00: configured for UDMA/133
[    1.434175] ata2: softreset failed (device not ready)
[    1.434229] ata2: failed due to HW bug, retry pmp=0
[    1.594184] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.600533] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
[    1.600586] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.606996] ata2.00: configured for UDMA/133
[    1.940857] ata3: SATA link down (SStatus 0 SControl 300)
[    2.274189] ata4: SATA link down (SStatus 0 SControl 300)
[    2.607523] ata5: SATA link down (SStatus 0 SControl 300)
[    2.940856] ata6: SATA link down (SStatus 0 SControl 300)
[    2.954240] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    2.954429] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.954491] sd 0:0:0:0: [sda] Write Protect is off
[    2.954544] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.954560] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.954682] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[    2.954743] sd 0:0:0:0: [sda] Write Protect is off
[    2.954795] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.954810] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.954899]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    2.979876] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.979998] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.980135] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    2.980310] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    2.980372] sd 1:0:0:0: [sdb] Write Protect is off
[    2.980425] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.980441] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.980564] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[    2.980624] sd 1:0:0:0: [sdb] Write Protect is off
[    2.980677] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.980693] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.980781]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >
[    3.007273] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.007383] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.008486] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PSMS] at 0x60,0x64 irq 1,12
[    3.010953] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.011009] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.011108] mice: PS/2 mouse device common for all mice
[    3.040945] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.041021] rtc0: alarms up to one month, y3k, hpet irqs
[    3.041097] md: raid1 personality registered for level 1
[    3.041207] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    3.041333] cpuidle: using governor ladder
[    3.041438] usbcore: registered new interface driver hiddev
[    3.041515] usbcore: registered new interface driver usbhid
[    3.041568] usbhid: v2.6:USB HID core driver
[    3.041680] TCP cubic registered
[    3.041732] Initializing XFRM netlink socket
[    3.041796] NET: Registered protocol family 10
[    3.041933] IPv6 over IPv4 tunneling driver
[    3.042064] NET: Registered protocol family 17
[    3.042134] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[    3.042254] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[    3.042308] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[    3.042361] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[    3.042413] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[    3.042466] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[    3.042518] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[    3.042571] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[    3.042623] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[    3.042839] registered taskstats version 1
[    3.042995]   Magic number: 12:514:661
[    3.067237] input: AT Translated Set 2 keyboard as /class/input/input2
[    3.143434] md: Autodetecting RAID arrays.
[    3.221791] md: Scanned 8 and added 8 devices.
[    3.221844] md: autorun ...
[    3.221896] md: considering sdb6 ...
[    3.221951] md:  adding sdb6 ...
[    3.222004] md: sdb5 has different UUID to sdb6
[    3.222057] md: sdb3 has different UUID to sdb6
[    3.222111] md: sdb1 has different UUID to sdb6
[    3.222165] md:  adding sda6 ...
[    3.222218] md: sda5 has different UUID to sdb6
[    3.222271] md: sda3 has different UUID to sdb6
[    3.222325] md: sda1 has different UUID to sdb6
[    3.222453] md: created md3
[    3.222506] md: bind<sda6>
[    3.222563] md: bind<sdb6>
[    3.222620] md: running: <sdb6><sda6>
[    3.222804] raid1: raid set md3 active with 2 out of 2 mirrors
[    3.222894] md: considering sdb5 ...
[    3.222948] md:  adding sdb5 ...
[    3.223001] md: sdb3 has different UUID to sdb5
[    3.223055] md: sdb1 has different UUID to sdb5
[    3.223109] md:  adding sda5 ...
[    3.223162] md: sda3 has different UUID to sdb5
[    3.223215] md: sda1 has different UUID to sdb5
[    3.223338] md: created md2
[    3.223390] md: bind<sda5>
[    3.223446] md: bind<sdb5>
[    3.223502] md: running: <sdb5><sda5>
[    3.223672] raid1: raid set md2 active with 2 out of 2 mirrors
[    3.223760] md: considering sdb3 ...
[    3.223814] md:  adding sdb3 ...
[    3.223867] md: sdb1 has different UUID to sdb3
[    3.223921] md:  adding sda3 ...
[    3.223974] md: sda1 has different UUID to sdb3
[    3.224096] md: created md1
[    3.224148] md: bind<sda3>
[    3.224217] md: bind<sdb3>
[    3.224274] md: running: <sdb3><sda3>
[    3.224443] raid1: raid set md1 active with 2 out of 2 mirrors
[    3.224530] md: considering sdb1 ...
[    3.224584] md:  adding sdb1 ...
[    3.224637] md:  adding sda1 ...
[    3.224689] md: created md0
[    3.224741] md: bind<sda1>
[    3.224798] md: bind<sdb1>
[    3.224854] md: running: <sdb1><sda1>
[    3.225018] raid1: raid set md0 active with 2 out of 2 mirrors
[    3.225104] md: ... autorun DONE.
[    3.225177] md: Loading md1: 1
[    3.225237] md: couldn't update array info. -22
[    3.225325] md: could not open unknown-block(0,1).
[    3.225378] md: md_import_device returned -6
[    3.225434] md: could not bd_claim sda3.
[    3.225486] md: md_import_device returned -16
[    3.225540] md: could not bd_claim sdb3.
[    3.225592] md: md_import_device returned -16
[    3.225646] md: starting md1 failed
[    3.274690] reiser4: md1: found disk format 4.0.0.
[    5.307450] VFS: Mounted root (reiser4 filesystem) readonly.
[    5.307526] Freeing unused kernel memory: 304k freed
[    7.880474] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.880490] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.880503] r8169 0000:01:00.0: setting latency timer to 64
[    7.880648] eth0: RTL8168c/8111c at 0xffffc2000005c000, 00:19:66:86:ce:12, XID 3c4000c0 IRQ 316
[    7.906863] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    7.906875] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    7.906931] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    7.906969] ehci_hcd 0000:00:12.2: debug port 1
[    7.906986] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[    7.917509] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    7.917582] usb usb1: configuration #1 chosen from 1 choice
[    7.917603] hub 1-0:1.0: USB hub found
[    7.917609] hub 1-0:1.0: 6 ports detected
[    8.124261] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    8.124263] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.124265] usb usb1: Product: EHCI Host Controller
[    8.124266] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[    8.124267] usb usb1: SerialNumber: 0000:00:12.2
[    8.124290] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    8.124300] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    8.124335] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    8.124369] ehci_hcd 0000:00:13.2: debug port 1
[    8.124387] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[    8.134180] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    8.134245] usb usb2: configuration #1 chosen from 1 choice
[    8.134268] hub 2-0:1.0: USB hub found
[    8.134274] hub 2-0:1.0: 6 ports detected
[    8.237599] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    8.237602] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.237604] usb usb2: Product: EHCI Host Controller
[    8.237605] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[    8.237606] usb usb2: SerialNumber: 0000:00:13.2
[    8.240862] usb 1-2: new high speed USB device using ehci_hcd and address 2
[    8.272087] Linux video capture interface: v2.00
[    8.284977] bttv: driver version 0.9.17 loaded
[    8.284980] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    8.285015] bttv: Bt8xx card found (0).
[    8.285028] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    8.285038] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 32, mmio: 0xfcfff000
[    8.285434] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[    8.285475] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
[    8.365879] usb 1-2: configuration #1 chosen from 1 choice
[    8.366107] hub 1-2:1.0: USB hub found
[    8.366339] hub 1-2:1.0: 4 ports detected
[    8.574264] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[    8.574267] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    8.574269] usb 1-2: Product: USB2.0 Hub
[    8.641575] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[    8.730973] usb 1-2.2: configuration #1 chosen from 1 choice
[    8.741415] input: Logitech USB Receiver as /class/input/input3
[    8.774208] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[    8.780037] input: Logitech USB Receiver as /class/input/input4
[    8.807569] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[    8.807631] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[    8.807633] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    8.807634] usb 1-2.2: Product: USB Receiver
[    8.807635] usb 1-2.2: Manufacturer: Logitech
[    9.286685] bttv0: tea5757: read timeout
[    9.286688] bttv0: tuner type=5
[    9.286691] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[    9.287421] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[    9.288159] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[    9.316516] All bytes are equal. It is not a TEA5767
[    9.316551] tuner' 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
[    9.319915] tuner-simple 0-0060: creating new instance
[    9.319918] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
[    9.331908] bttv0: registered device video0
[    9.331924] bttv0: registered device vbi0
[    9.723122] reiser4: md2: found disk format 4.0.0.
[   10.909343] reiser4: md3: found disk format 4.0.0.
[   35.753338] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 across:7815612k
[   35.812962] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 across:7815612k
[   36.666864] r8169: eth0: link up
[   36.666870] r8169: eth0: link up
[   38.189266] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   38.189276] ALSA sound/pci/emu10k1/emu10k1_main.c:1749: vendor=0x1102, device=0x8, subsystem_vendor_id=0x10011102, subsystem_id=0x1001
[   38.189280] ALSA sound/pci/emu10k1/emu10k1_main.c:1774: Sound card name=Audigy 2 Value [SB0400]
[   38.195525] ALSA sound/pci/emu10k1/emu10k1_main.c:219: Audigy2 value: Special config.
[   38.766413] w83627ehf: Found W83627EHG chip at 0x290
[   39.500007] Clocksource tsc unstable (delta = -141128012 ns)
[  218.390824] usb 1-1: new high speed USB device using ehci_hcd and address 4
[  218.524662] usb 1-1: configuration #1 chosen from 1 choice
[  218.525245] usb 1-1: New USB device found, idVendor=05e3, idProduct=0701
[  218.525250] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[  218.525252] usb 1-1: Product: USB Mass Storage Device 
[  218.525253] usb 1-1: Manufacturer: Genesyslogic
[  218.564013] Initializing USB Mass Storage driver...
[  218.564639] scsi6 : SCSI emulation for USB Mass Storage devices
[  218.564720] usb-storage: device found at 4
[  218.564725] usb-storage: waiting for device to settle before scanning
[  218.564732] usbcore: registered new interface driver usb-storage
[  218.564735] USB Mass Storage support registered.
[  223.563564] usb-storage: device scan complete
[  223.660792] scsi 6:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 PQ: 0 ANSI: 0
[  223.661073] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[  223.675766] Driver 'sr' needs updating - please use bus_type methods
[  223.770898] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[  223.770903] Uniform CD-ROM driver Revision: 3.20
[  223.770972] sr 6:0:0:0: Attached scsi CD-ROM sr0
[  291.280350] ISO 9660 Extensions: RRIP_1991A
[  332.634154] usb 1-1: reset high speed USB device using ehci_hcd and address 4
[  347.770812] usb 1-1: device descriptor read/64, error -110
[  363.010812] usb 1-1: device descriptor read/64, error -110
[  363.220812] usb 1-1: reset high speed USB device using ehci_hcd and address 4
[  378.357476] usb 1-1: device descriptor read/64, error -110
[  393.544727] usb 1-1: USB disconnect, address 4
[  393.545020] sr 6:0:0:0: Device offlined - not ready after error recovery
[  393.545033] sr 6:0:0:0: [sr0] Result: hostbyte=0x05 driverbyte=0x00
[  393.545037] end_request: I/O error, dev sr0, sector 1662128
[  393.545041] Buffer I/O error on device sr0, logical block 415532
[  393.545045] Buffer I/O error on device sr0, logical block 415533
[  393.545051] Buffer I/O error on device sr0, logical block 415534
[  393.545054] Buffer I/O error on device sr0, logical block 415535
[  393.545057] Buffer I/O error on device sr0, logical block 415536
[  393.545060] Buffer I/O error on device sr0, logical block 415537
[  393.545063] Buffer I/O error on device sr0, logical block 415538
[  393.545066] Buffer I/O error on device sr0, logical block 415539
[  393.545069] Buffer I/O error on device sr0, logical block 415540
[  393.545072] Buffer I/O error on device sr0, logical block 415541
[  393.545085] sr 6:0:0:0: rejecting I/O to offline device
[  393.545102] sr 6:0:0:0: rejecting I/O to offline device
[  393.545104] sr 6:0:0:0: rejecting I/O to offline device
[  393.545117] sr 6:0:0:0: rejecting I/O to offline device
[  393.545128] sr 6:0:0:0: rejecting I/O to offline device
[  393.545137] sr 6:0:0:0: rejecting I/O to offline device
[  393.545148] sr 6:0:0:0: rejecting I/O to offline device
[  393.545160] sr 6:0:0:0: rejecting I/O to offline device
[  393.545175] sr 6:0:0:0: rejecting I/O to offline device
[  393.545187] sr 6:0:0:0: rejecting I/O to offline device
[  393.545199] sr 6:0:0:0: rejecting I/O to offline device
[  393.545210] sr 6:0:0:0: rejecting I/O to offline device
[  393.545221] sr 6:0:0:0: rejecting I/O to offline device
[  393.545232] sr 6:0:0:0: rejecting I/O to offline device
[  393.545244] sr 6:0:0:0: rejecting I/O to offline device
[  393.545256] sr 6:0:0:0: rejecting I/O to offline device
[  393.545270] sr 6:0:0:0: [sr0] Result: hostbyte=0x01 driverbyte=0x00
[  393.545272] end_request: I/O error, dev sr0, sector 1662192
[  393.545313] VFS: busy inodes on changed media.
[  393.545481] sr 6:0:0:0: rejecting I/O to offline device
[  393.545486] sr 6:0:0:0: rejecting I/O to offline device
[  393.545603] sr 6:0:0:0: rejecting I/O to offline device
[  393.545611] sr 6:0:0:0: rejecting I/O to offline device
[  393.572083] scsi 6:0:0:0: rejecting I/O to dead device
[  393.572300] scsi 6:0:0:0: rejecting I/O to dead device
[  393.572369] scsi 6:0:0:0: rejecting I/O to dead device
[  400.120806] usb 1-1: new high speed USB device using ehci_hcd and address 5
[  415.257471] usb 1-1: device descriptor read/64, error -110
[  430.497470] usb 1-1: device descriptor read/64, error -110
[  430.707468] usb 1-1: new high speed USB device using ehci_hcd and address 6
[  439.049097] ehci_hcd 0000:00:13.2: remove, state 4
[  439.049107] usb usb2: USB disconnect, address 1
[  439.050329] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[  439.050399] ehci_hcd 0000:00:13.2: PCI INT B disabled
[  439.050409] ehci_hcd 0000:00:12.2: remove, state 1
[  439.050414] usb usb1: USB disconnect, address 1
[  440.727481] hub 1-0:1.0: cannot reset port 1 (err = -19)
[  440.727487] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  440.727496] hub 1-0:1.0: cannot reset port 1 (err = -19)
[  440.727498] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  440.727500] hub 1-0:1.0: cannot reset port 1 (err = -19)
[  440.727502] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  440.727505] hub 1-0:1.0: unable to enumerate USB device on port 1
[  440.727506] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  440.747470] usb 1-2: USB disconnect, address 2
[  440.747474] usb 1-2.2: USB disconnect, address 3
[  440.826627] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024 0000c000 00000000 -> -110
[  440.838259] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[  440.838451] ehci_hcd 0000:00:12.2: PCI INT B disabled
[  443.288544] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  443.288562] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  443.289133] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[  443.289173] ehci_hcd 0000:00:12.2: debug port 1
[  443.289185] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[  443.300241] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  443.300352] usb usb1: configuration #1 chosen from 1 choice
[  443.300377] hub 1-0:1.0: USB hub found
[  443.300385] hub 1-0:1.0: 6 ports detected
[  443.507560] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  443.507564] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  443.507566] usb usb1: Product: EHCI Host Controller
[  443.507569] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  443.507571] usb usb1: SerialNumber: 0000:00:12.2
[  443.507594] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  443.507606] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  443.507644] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[  443.507679] ehci_hcd 0000:00:13.2: debug port 1
[  443.507691] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[  443.517470] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  443.517556] usb usb2: configuration #1 chosen from 1 choice
[  443.517579] hub 2-0:1.0: USB hub found
[  443.517586] hub 2-0:1.0: 6 ports detected
[  443.620902] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[  443.620906] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  443.620908] usb usb2: Product: EHCI Host Controller
[  443.620910] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  443.620913] usb usb2: SerialNumber: 0000:00:13.2
[  443.624147] usb 1-1: new high speed USB device using ehci_hcd and address 2
[  443.757595] usb 1-1: configuration #1 chosen from 1 choice
[  443.760852] scsi7 : SCSI emulation for USB Mass Storage devices
[  443.761012] usb 1-1: New USB device found, idVendor=05e3, idProduct=0701
[  443.761016] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[  443.761018] usb 1-1: Product: USB Mass Storage Device 
[  443.761019] usb 1-1: Manufacturer: Genesyslogic
[  443.761111] usb-storage: device found at 2
[  443.761113] usb-storage: waiting for device to settle before scanning
[  443.867470] usb 1-2: new high speed USB device using ehci_hcd and address 3
[  443.992571] usb 1-2: configuration #1 chosen from 1 choice
[  443.992786] hub 1-2:1.0: USB hub found
[  443.993136] hub 1-2:1.0: 4 ports detected
[  444.200888] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[  444.200892] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[  444.200894] usb 1-2: Product: USB2.0 Hub
[  444.267751] usb 1-2.2: new low speed USB device using ehci_hcd and address 4
[  444.358581] usb 1-2.2: configuration #1 chosen from 1 choice
[  444.368837] input: Logitech USB Receiver as /class/input/input5
[  444.402089] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[  444.424061] input: Logitech USB Receiver as /class/input/input6
[  444.457545] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[  444.457615] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[  444.457617] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  444.457619] usb 1-2.2: Product: USB Receiver
[  444.457620] usb 1-2.2: Manufacturer: Logitech
[  448.761103] usb-storage: device scan complete
[  448.762343] scsi 7:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 PQ: 0 ANSI: 0
[  448.768983] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[  448.770775] sr 7:0:0:0: Attached scsi CD-ROM sr0
[  448.770921] sr 7:0:0:0: Attached scsi generic sg2 type 5
[  557.656626] usb 1-1: reset high speed USB device using ehci_hcd and address 2
[  572.793288] usb 1-1: device descriptor read/64, error -110
[  587.357595] ehci_hcd 0000:00:13.2: remove, state 4
[  587.357605] usb usb2: USB disconnect, address 1
[  587.357833] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[  587.357897] ehci_hcd 0000:00:13.2: PCI INT B disabled
[  587.357908] ehci_hcd 0000:00:12.2: remove, state 1
[  587.357913] usb usb1: USB disconnect, address 1
[  587.357914] usb 1-1: USB disconnect, address 0
[  587.926629] hub 1-0:1.0: cannot reset port 1 (err = -19)
[  587.926634] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  587.926636] hub 1-0:1.0: cannot disable port 1 (err = -19)
[  587.926828] sr 7:0:0:0: Device offlined - not ready after error recovery
[  587.926975] scsi 7:0:0:0: rejecting I/O to dead device
[  587.926981] scsi 7:0:0:0: rejecting I/O to dead device
[  587.926985] scsi 7:0:0:0: rejecting I/O to dead device
[  587.926989] scsi 7:0:0:0: rejecting I/O to dead device
[  587.927458] usb 1-2: USB disconnect, address 3
[  587.927464] usb 1-2.2: USB disconnect, address 4
[  588.024111] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024 0000c000 00000000 -> -110
[  588.036066] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[  588.036155] ehci_hcd 0000:00:12.2: PCI INT B disabled
[  590.188780] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[  590.188794] ehci_hcd 0000:00:12.2: EHCI Host Controller
[  590.188862] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[  590.188900] ehci_hcd 0000:00:12.2: debug port 1
[  590.188912] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[  590.197454] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  590.197563] usb usb1: configuration #1 chosen from 1 choice
[  590.197587] hub 1-0:1.0: USB hub found
[  590.197595] hub 1-0:1.0: 6 ports detected
[  590.404219] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[  590.404224] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  590.404226] usb usb1: Product: EHCI Host Controller
[  590.404228] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  590.404230] usb usb1: SerialNumber: 0000:00:12.2
[  590.404254] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[  590.404266] ehci_hcd 0000:00:13.2: EHCI Host Controller
[  590.404305] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[  590.404341] ehci_hcd 0000:00:13.2: debug port 1
[  590.404353] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[  590.414122] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[  590.414205] usb usb2: configuration #1 chosen from 1 choice
[  590.414229] hub 2-0:1.0: USB hub found
[  590.414236] hub 2-0:1.0: 6 ports detected
[  590.517549] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[  590.517553] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  590.517555] usb usb2: Product: EHCI Host Controller
[  590.517557] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[  590.517560] usb usb2: SerialNumber: 0000:00:13.2
[  590.520798] usb 1-2: new high speed USB device using ehci_hcd and address 2
[  590.645820] usb 1-2: configuration #1 chosen from 1 choice
[  590.646034] hub 1-2:1.0: USB hub found
[  590.646385] hub 1-2:1.0: 4 ports detected
[  590.854211] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[  590.854215] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[  590.854217] usb 1-2: Product: USB2.0 Hub
[  590.921122] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[  591.011038] usb 1-2.2: configuration #1 chosen from 1 choice
[  591.023018] input: Logitech USB Receiver as /class/input/input7
[  591.065109] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[  591.080005] input: Logitech USB Receiver as /class/input/input8
[  591.118378] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[  591.118449] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[  591.118451] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  591.118452] usb 1-2.2: Product: USB Receiver
[  591.118453] usb 1-2.2: Manufacturer: Logitech
[ 1494.097363] usb 1-1: new high speed USB device using ehci_hcd and address 4
[ 1494.230935] usb 1-1: configuration #1 chosen from 1 choice
[ 1494.231387] scsi8 : SCSI emulation for USB Mass Storage devices
[ 1494.231653] usb 1-1: New USB device found, idVendor=05e3, idProduct=0701
[ 1494.231658] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[ 1494.231660] usb 1-1: Product: USB Mass Storage Device 
[ 1494.231661] usb 1-1: Manufacturer: Genesyslogic
[ 1494.231665] usb-storage: device found at 4
[ 1494.231667] usb-storage: waiting for device to settle before scanning
[ 1499.230962] usb-storage: device scan complete
[ 1499.258449] scsi 8:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 PQ: 0 ANSI: 0
[ 1499.350559] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[ 1499.351554] sr 8:0:0:0: Attached scsi CD-ROM sr0
[ 1499.351688] sr 8:0:0:0: Attached scsi generic sg2 type 5
[ 1531.767361] usb 1-1: reset high speed USB device using ehci_hcd and address 4
[ 1546.904030] usb 1-1: device descriptor read/64, error -110
[ 1562.144026] usb 1-1: device descriptor read/64, error -110
[ 1562.354025] usb 1-1: reset high speed USB device using ehci_hcd and address 4
[ 1571.031747] ehci_hcd 0000:00:13.2: remove, state 4
[ 1571.031757] usb usb2: USB disconnect, address 1
[ 1571.031991] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[ 1571.032056] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 1571.032064] ehci_hcd 0000:00:12.2: remove, state 1
[ 1571.032070] usb usb1: USB disconnect, address 1
[ 1571.032071] usb 1-1: USB disconnect, address 0
[ 1572.374030] hub 1-0:1.0: cannot reset port 1 (err = -19)
[ 1572.374036] hub 1-0:1.0: cannot disable port 1 (err = -19)
[ 1572.374039] hub 1-0:1.0: cannot disable port 1 (err = -19)
[ 1572.374435] scsi 8:0:0:0: Device offlined - not ready after error recovery
[ 1572.374575] usb 1-2: USB disconnect, address 2
[ 1572.374581] usb 1-2.2: USB disconnect, address 3
[ 1572.377436] scsi 8:0:0:0: rejecting I/O to dead device
[ 1572.377451] scsi 8:0:0:0: rejecting I/O to dead device
[ 1572.377456] scsi 8:0:0:0: rejecting I/O to dead device
[ 1572.477346] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024 0000c000 00000000 -> -110
[ 1572.489340] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[ 1572.489430] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 1574.758187] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 1574.758204] ehci_hcd 0000:00:12.2: EHCI Host Controller
[ 1574.758801] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[ 1574.758841] ehci_hcd 0000:00:12.2: debug port 1
[ 1574.758854] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[ 1574.770181] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[ 1574.770293] usb usb1: configuration #1 chosen from 1 choice
[ 1574.770318] hub 1-0:1.0: USB hub found
[ 1574.770326] hub 1-0:1.0: 6 ports detected
[ 1574.977449] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[ 1574.977454] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 1574.977456] usb usb1: Product: EHCI Host Controller
[ 1574.977458] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1574.977460] usb usb1: SerialNumber: 0000:00:12.2
[ 1574.977483] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 1574.977496] ehci_hcd 0000:00:13.2: EHCI Host Controller
[ 1574.977536] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[ 1574.977571] ehci_hcd 0000:00:13.2: debug port 1
[ 1574.977583] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[ 1574.987358] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[ 1574.987442] usb usb2: configuration #1 chosen from 1 choice
[ 1574.987470] hub 2-0:1.0: USB hub found
[ 1574.987477] hub 2-0:1.0: 6 ports detected
[ 1575.090791] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[ 1575.090796] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 1575.090798] usb usb2: Product: EHCI Host Controller
[ 1575.090800] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1575.090803] usb usb2: SerialNumber: 0000:00:13.2
[ 1575.094032] usb 1-1: new high speed USB device using ehci_hcd and address 2
[ 1575.227511] usb 1-1: configuration #1 chosen from 1 choice
[ 1575.227959] scsi9 : SCSI emulation for USB Mass Storage devices
[ 1575.228120] usb 1-1: New USB device found, idVendor=05e3, idProduct=0701
[ 1575.228124] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=0
[ 1575.228126] usb 1-1: Product: USB Mass Storage Device 
[ 1575.228127] usb 1-1: Manufacturer: Genesyslogic
[ 1575.228219] usb-storage: device found at 2
[ 1575.228220] usb-storage: waiting for device to settle before scanning
[ 1575.334022] usb 1-2: new high speed USB device using ehci_hcd and address 3
[ 1575.459111] usb 1-2: configuration #1 chosen from 1 choice
[ 1575.459328] hub 1-2:1.0: USB hub found
[ 1575.459679] hub 1-2:1.0: 4 ports detected
[ 1575.667443] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[ 1575.667447] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 1575.667448] usb 1-2: Product: USB2.0 Hub
[ 1575.734416] usb 1-2.2: new low speed USB device using ehci_hcd and address 4
[ 1575.824203] usb 1-2.2: configuration #1 chosen from 1 choice
[ 1575.835976] input: Logitech USB Receiver as /class/input/input9
[ 1575.864086] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[ 1575.870254] input: Logitech USB Receiver as /class/input/input10
[ 1575.917434] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[ 1575.917505] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[ 1575.917507] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1575.917508] usb 1-2.2: Product: USB Receiver
[ 1575.917509] usb 1-2.2: Manufacturer: Logitech
[ 1580.227646] usb-storage: device scan complete
[ 1580.983567] scsi 9:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.19 PQ: 0 ANSI: 0
[ 1580.993028] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[ 1580.993271] sr 9:0:0:0: Attached scsi CD-ROM sr0
[ 1580.993360] sr 9:0:0:0: Attached scsi generic sg2 type 5
[ 1680.120201] usb 1-1: USB disconnect, address 2
[ 1680.131960] scsi 9:0:0:0: rejecting I/O to dead device
[ 1680.131971] scsi 9:0:0:0: rejecting I/O to dead device
[ 1680.131979] scsi 9:0:0:0: rejecting I/O to dead device
[ 1680.131984] scsi 9:0:0:0: rejecting I/O to dead device
[ 1685.304799] ehci_hcd 0000:00:13.2: remove, state 4
[ 1685.304906] usb usb2: USB disconnect, address 1
[ 1685.305180] ehci_hcd 0000:00:13.2: USB bus 2 deregistered
[ 1685.305294] ehci_hcd 0000:00:13.2: PCI INT B disabled
[ 1685.305304] ehci_hcd 0000:00:12.2: remove, state 1
[ 1685.305310] usb usb1: USB disconnect, address 1
[ 1685.305311] usb 1-2: USB disconnect, address 3
[ 1685.305313] usb 1-2.2: USB disconnect, address 4
[ 1685.399836] ehci_hcd 0000:00:12.2: force halt; handhake ffffc2000004a024 0000c000 00000000 -> -110
[ 1685.411356] ehci_hcd 0000:00:12.2: USB bus 1 deregistered
[ 1685.411537] ehci_hcd 0000:00:12.2: PCI INT B disabled
[ 1686.874095] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[ 1686.874111] ehci_hcd 0000:00:12.2: EHCI Host Controller
[ 1686.874309] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[ 1686.874393] ehci_hcd 0000:00:12.2: debug port 1
[ 1686.874407] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
[ 1686.883176] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[ 1686.883297] usb usb1: configuration #1 chosen from 1 choice
[ 1686.883320] hub 1-0:1.0: USB hub found
[ 1686.883327] hub 1-0:1.0: 6 ports detected
[ 1687.089941] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[ 1687.089946] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 1687.089948] usb usb1: Product: EHCI Host Controller
[ 1687.089949] usb usb1: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1687.089950] usb usb1: SerialNumber: 0000:00:12.2
[ 1687.090179] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[ 1687.090192] ehci_hcd 0000:00:13.2: EHCI Host Controller
[ 1687.090303] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[ 1687.090384] ehci_hcd 0000:00:13.2: debug port 1
[ 1687.090397] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
[ 1687.197351] usb 1-2: new high speed USB device using ehci_hcd and address 2
[ 1687.206511] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[ 1687.206590] usb usb2: configuration #1 chosen from 1 choice
[ 1687.206612] hub 2-0:1.0: USB hub found
[ 1687.206619] hub 2-0:1.0: 6 ports detected
[ 1687.309946] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[ 1687.309950] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[ 1687.309952] usb usb2: Product: EHCI Host Controller
[ 1687.309953] usb usb2: Manufacturer: Linux 2.6.27.4r4 ehci_hcd
[ 1687.309954] usb usb2: SerialNumber: 0000:00:13.2
[ 1687.332439] usb 1-2: configuration #1 chosen from 1 choice
[ 1687.332654] hub 1-2:1.0: USB hub found
[ 1687.336182] hub 1-2:1.0: 4 ports detected
[ 1687.544102] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
[ 1687.544106] usb 1-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[ 1687.544107] usb 1-2: Product: USB2.0 Hub
[ 1687.610991] usb 1-2.2: new low speed USB device using ehci_hcd and address 3
[ 1687.701404] usb 1-2.2: configuration #1 chosen from 1 choice
[ 1687.711835] input: Logitech USB Receiver as /class/input/input11
[ 1687.758335] input,hidraw0: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[ 1687.767852] input: Logitech USB Receiver as /class/input/input12
[ 1687.816583] input,hiddev96,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2
[ 1687.816756] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
[ 1687.816760] usb 1-2.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1687.816761] usb 1-2.2: Product: USB Receiver
[ 1687.816762] usb 1-2.2: Manufacturer: Logitech

--Boundary-00=_mqQCJkHuvEmEojz
Content-Type: text/plain;
  charset="UTF-8";
  name="lsmod"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lsmod"

Module                  Size  Used by
ehci_hcd               36620  0 
isofs                  35176  0 
nls_base                8260  1 isofs
sr_mod                 16708  0 
cdrom                  36968  1 sr_mod
usb_storage            48768  0 
w83627ehf              24208  0 
hwmon_vid               3712  1 w83627ehf
hwmon                   2888  1 w83627ehf
snd_seq_midi            8640  0 
snd_emu10k1_synth       8192  0 
snd_emux_synth         39296  1 snd_emu10k1_synth
snd_seq_virmidi         6144  1 snd_emux_synth
snd_seq_midi_emul       7232  1 snd_emux_synth
snd_pcm_oss            50304  0 
snd_mixer_oss          17280  1 snd_pcm_oss
snd_seq_dummy           3332  0 
snd_seq_oss            34560  0 
snd_seq_midi_event      7488  3 snd_seq_midi,snd_seq_virmidi,snd_seq_oss
snd_seq                59936  9 snd_seq_midi,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_emu10k1           157152  2 snd_emu10k1_synth
snd_rawmidi            24192  3 snd_seq_midi,snd_seq_virmidi,snd_emu10k1
snd_ac97_codec        118552  1 snd_emu10k1
ac97_bus                2048  1 snd_ac97_codec
snd_pcm                87688  3 snd_pcm_oss,snd_emu10k1,snd_ac97_codec
snd_seq_device          7572  8 snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq_dummy,snd_seq_oss,snd_seq,snd_emu10k1,snd_rawmidi
snd_timer              23376  3 snd_seq,snd_emu10k1,snd_pcm
snd_page_alloc          9104  2 snd_emu10k1,snd_pcm
snd_util_mem            4480  2 snd_emux_synth,snd_emu10k1
snd_hwdep               8904  2 snd_emux_synth,snd_emu10k1
snd                    66888  20 snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_pcm_oss,snd_mixer_oss,snd_seq_dummy,snd_seq_oss,snd_seq,snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_pcm,snd_seq_device,snd_timer,snd_util_mem,snd_hwdep
tuner_simple           15060  1 
tuner_types            17472  1 tuner_simple
tea5767                 7108  0 
tuner                  29324  0 
bttv                  198228  0 
ir_common              37380  1 bttv
compat_ioctl32          9408  1 bttv
videodev               36224  3 tuner,bttv,compat_ioctl32
v4l1_compat            16004  1 videodev
i2c_algo_bit            6468  1 bttv
v4l2_common            11584  2 tuner,bttv
videobuf_dma_sg        11908  1 bttv
videobuf_core          17668  2 bttv,videobuf_dma_sg
btcx_risc               4680  1 bttv
tveeprom               14852  1 bttv
i2c_core               23392  7 tuner_simple,tea5767,tuner,bttv,i2c_algo_bit,v4l2_common,tveeprom
r8169                  29892  0 

--Boundary-00=_mqQCJkHuvEmEojz
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci"

00:00.0 Host bridge: ATI Technologies Inc RX780/RX790 Chipset Host Bridge
	Subsystem: ASRock Incorporation Device 5957
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 3: Memory at <ignored> (64-bit, non-prefetchable)
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [9c] HyperTransport: #1a

00:02.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (external gfx0 port A) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fdf00000-fdffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4159
	Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport-driver

00:09.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port E) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fe000000-feafffff
	Prefetchable memory behind bridge: 00000000fa000000-00000000fcefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #247, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -3.5dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4161
	Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport-driver

00:0a.0 PCI bridge: ATI Technologies Inc RD790 PCI to PCI bridge (PCI express gpp port F) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: 00000000cff00000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #5, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis- ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
		Address: fee0300c  Data: 4169
	Capabilities: [b0] Subsystem: ASRock Incorporation Device 5957
	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [100] Vendor Specific Information <?>
	Capabilities: [110] Virtual Channel <?>
	Kernel driver in use: pcieport-driver

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode] (prog-if 01 [AHCI 1.0])
	Subsystem: ASRock Incorporation Device 4391
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at a000 [size=8]
	Region 1: I/O ports at 9000 [size=4]
	Region 2: I/O ports at 8000 [size=8]
	Region 3: I/O ports at 7000 [size=4]
	Region 4: I/O ports at 6000 [size=16]
	Region 5: Memory at fddff800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 4397
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at fddfe000 (32-bit, non-prefetchable) [size=4K]
	Kernel modules: ohci-hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 4398
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at fddfd000 (32-bit, non-prefetchable) [size=4K]
	Kernel modules: ohci-hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation Device 4396
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 4397
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fddfc000 (32-bit, non-prefetchable) [size=4K]
	Kernel modules: ohci-hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 4398
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fddf7000 (32-bit, non-prefetchable) [size=4K]
	Kernel modules: ohci-hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ASRock Incorporation Device 4396
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fddf6800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
	Subsystem: ASRock Incorporation Device 4385
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR+ <PERR+ INTx-
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+
	Kernel modules: i2c-piix4

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: ASRock Incorporation Device 439c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 0
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Capabilities: [70] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
		Address: 00000000  Data: 0000

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
	Subsystem: ASRock Incorporation Device 439d
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: feb00000-febfffff
	Prefetchable memory behind bridge: fcf00000-fcffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: ASRock Incorporation Device 4399
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at fddf5000 (32-bit, non-prefetchable) [size=4K]
	Kernel modules: ohci-hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: ASRock Incorporation Device 8168
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 316
	Region 0: I/O ports at b800 [size=256]
	Region 2: Memory at cffff000 (64-bit, prefetchable) [size=4K]
	Region 4: Memory at cffe0000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at fdef0000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Count=1/2 Enable+
		Address: 00000000fee0300c  Data: 4179
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
		Vector table: BAR=4 offset=00000000
		PBA: BAR=4 offset=00000800
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 00-e0-4c-68-12-34-56-78
	Kernel driver in use: r8169
	Kernel modules: r8169

02:00.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3870 (prog-if 00 [VGA controller])
	Subsystem: Info-Tek Corp. Device 4070
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 2: Memory at fdff0000 (64-bit, non-prefetchable) [size=64K]
	Region 4: I/O ports at c000 [size=256]
	Expansion ROM at fdfc0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Vendor Specific Information <?>
	Kernel modules: fglrx

02:00.1 Audio device: ATI Technologies Inc Radeon HD 3870 Audio device
	Subsystem: Info-Tek Corp. Device aa18
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 10
	Region 0: Memory at fdfec000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Vendor Specific Information <?>
	Kernel modules: snd-hda-intel

05:05.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
	Subsystem: Adaptec Device 7884
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 2000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at e800 [size=256]
	Region 1: Memory at febff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at fcf00000 [disabled] [size=64K]
	Capabilities: [dc] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel modules: aic7xxx

05:06.0 Multimedia video controller: Brooktree Corporation Bt848 Video Capture (rev 12)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at fcfff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: bttv
	Kernel modules: bttv

05:08.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
	Subsystem: Creative Labs Device 1001
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: I/O ports at e400 [size=64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: EMU10K1_Audigy
	Kernel modules: snd-emu10k1


--Boundary-00=_mqQCJkHuvEmEojz--
