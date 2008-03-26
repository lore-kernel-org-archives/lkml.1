Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYCZJ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYCZJ7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYCZJ7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:59:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:19464 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbYCZJ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:59:33 -0400
Subject: DMA not working on SATA?
From: Alex Bennee <kernel-hacker@bennee.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Mar 2008 09:59:22 +0000
Message-Id: <1206525562.7022.16.camel@pitcairn.cambridgebroadband.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I got my new machine I noticed it seemed to be running slower than
I expected for a duel core machine including a lot of stuttering. After
tweaking the BIOS settings from "Legacy" to "AHCI" I measured a doubling
of read performance with hdparm but heavy IO still makes the machine
sluggish, with top showing ~80% of the time in the wait state (and
loadavg shooting up). This seems like a DMA problem because I was under
the impression a task demanding IO should be able to sleep on a DMA
completion rather than blocking everything else.

Looking with hdparm I get the following info on my disk:

root@pitcairn:/home/ajb# hdparm -v -i /dev/sda

/dev/sda:
 IO_support    =  0 (default 16-bit)
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 19457/255/63, sectors = 312581808, start = 0

 Model=ST3160815AS                             , FwRev=3.AAD   , SerialNo=            6RA38XMD
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=?16?
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=268435455
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: Unspecified:  ATA/ATAPI-1,2,3,4,5,6,7

 * signifies the current active mode

Which seems to indicate DMA is supported but not on. Attempting to
switch it on with -d just fails:

root@pitcairn:/home/ajb# hdparm -v -d 1 /dev/sda

/dev/sda:
 setting using_dma to 1 (on)
 HDIO_SET_DMA failed: Inappropriate ioctl for device
 IO_support    =  0 (default 16-bit)
 readonly      =  0 (off)
 readahead     = 256 (on)
 geometry      = 19457/255/63, sectors = 312581808, start = 0

I'm currently running an Ubuntu (7.10) distro kernel although I can get
a test kernel running if it helps to debug:

root@pitcairn:/home/ajb# uname -a
Linux pitcairn 2.6.22-14-generic #1 SMP Tue Feb 12 02:46:46 UTC 2008
x86_64 GNU/Linux

The (hopefully) relevant chunks of lspci show this:

root@pitcairn:/home/ajb# lspci -v
00:1f.0 ISA bridge: Intel Corporation 82801IH (ICH9DH) LPC Interface Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 5044
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: Intel Corporation Unknown device 5044
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 21
        I/O ports at 3428 [size=8]
        I/O ports at 3434 [size=4]
        I/O ports at 3420 [size=8]
        I/O ports at 3430 [size=4]
        I/O ports at 3020 [size=32]
        Memory at 53225000 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4 Enable-
        Capabilities: [70] Power Management version 3
        Capabilities: [a8] #12 [0010]
        Capabilities: [b0] Vendor Specific Information

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
        Subsystem: Intel Corporation Unknown device 5044
        Flags: medium devsel, IRQ 10
        Memory at 53226000 (64-bit, non-prefetchable) [size=256]
        I/O ports at 3000 [size=32]
03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
single-port PATA133 interface (rev b2) (prog-if 8f [Master SecP SecO
PriP PriO])
        Subsystem: Marvell Technology Group Ltd. 88SE6101 single-port
PATA133 interface
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at 1018 [size=8]
        I/O ports at 1024 [size=4]
        I/O ports at 1010 [size=8]
        I/O ports at 1020 [size=4]
        I/O ports at 1000 [size=16]
        Memory at 53100000 (32-bit, non-prefetchable) [size=512]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
        Capabilities: [e0] Express Legacy Endpoint IRQ 0

And the (snipped) dmesg output:

[   30.478794] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps
0x3f impl SATA mode
[   30.478797] ahci 0000:00:1f.2: flags: 64bit ncq led clo pmp pio slum
part 
[   30.478801] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   30.479035] scsi0 : ahci
[   30.479066] scsi1 : ahci
[   30.479090] scsi2 : ahci
[   30.479112] scsi3 : ahci
[   30.479135] scsi4 : ahci
[   30.479158] scsi5 : ahci
[   30.479228] ata1: SATA max UDMA/133 cmd 0xffffc200005f8100 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.479231] ata2: SATA max UDMA/133 cmd 0xffffc200005f8180 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.479234] ata3: SATA max UDMA/133 cmd 0xffffc200005f8200 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.479237] ata4: SATA max UDMA/133 cmd 0xffffc200005f8280 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.479240] ata5: SATA max UDMA/133 cmd 0xffffc200005f8300 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.479243] ata6: SATA max UDMA/133 cmd 0xffffc200005f8380 ctl
0x0000000000000000 bmdma 0x0000000000000000 irq 21
[   30.670632] usb 7-1.1: new high speed USB device using ehci_hcd and
address 5
[   30.746315] ieee1394: Host added: ID:BUS[0-00:1023]
GUID[0090270001eac2c3]
[   30.764496] usb 7-1.1: configuration #1 chosen from 1 choice
[   30.961793] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.962030] usb 7-1.2: new high speed USB device using ehci_hcd and
address 6
[   30.999213] ata1.00: ATA-7: ST3160815AS, 3.AAD, max UDMA/133
[   30.999216] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth
31/32)
[   31.054773] usb 7-1.2: configuration #1 chosen from 1 choice
[   31.055515] usbcore: registered new interface driver libusual
[   31.057399] ata1.00: configured for UDMA/133
[   31.059152] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   31.059155] ide: Assuming 33MHz system bus speed for PIO modes;
override with idebus=xx
[   31.060168] Initializing USB Mass Storage driver...
[   31.293123] usb 2-1: new low speed USB device using uhci_hcd and
address 2
[   31.368971] ata2: SATA link down (SStatus 0 SControl 300)
[   31.475149] usb 2-1: configuration #1 chosen from 1 choice
[   31.680343] ata3: SATA link down (SStatus 0 SControl 300)
[   31.716270] usb 2-2: new low speed USB device using uhci_hcd and
address 3
[   31.898263] usb 2-2: configuration #1 chosen from 1 choice
[   31.901635] scsi6 : SCSI emulation for USB Mass Storage devices
[   31.901668] usb-storage: device found at 5
[   31.901670] usb-storage: waiting for device to settle before scanning
[   31.901694] scsi7 : SCSI emulation for USB Mass Storage devices
[   31.901718] usb-storage: device found at 6
[   31.901719] usb-storage: waiting for device to settle before scanning
[   31.901734] usbcore: registered new interface driver usb-storage
[   31.901736] usbcore: registered new interface driver hiddev
[   31.901738] USB Mass Storage support registered.
[   31.916372] input: Microsoft Microsoft 5-Button Mouse with
IntelliEye(TM) as /class/input/input1
[   31.916388] input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button
Mouse with IntelliEye(TM)] on usb-0000:00:1a.1-1
[   31.930335] input: Microsoft Natural� Ergonomic Keyboard 4000
as /class/input/input2
[   31.930341] input: USB HID v1.11 Keyboard [Microsoft Natural�
Ergonomic Keyboard 4000] on usb-0000:00:1a.1-2
[   31.951194] input: Microsoft Natural� Ergonomic Keyboard 4000
as /class/input/input3
[   31.951199] input: USB HID v1.11 Device [Microsoft Natural� Ergonomic
Keyboard 4000] on usb-0000:00:1a.1-2
[   31.951207] usbcore: registered new interface driver usbhid
[
31.951209] /build/buildd/linux-source-2.6.22-2.6.22/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   31.991722] ata4: SATA link down (SStatus 0 SControl 300)
[   32.303093] ata5: SATA link down (SStatus 0 SControl 300)
[   32.614466] ata6: SATA link down (SStatus 0 SControl 300)
[   32.614550] scsi 0:0:0:0: Direct-Access     ATA      ST3160815AS
3.AA PQ: 0 ANSI: 5
[   32.614825] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   32.614847] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   32.614870] scsi8 : pata_marvell
[   32.614998] scsi9 : pata_marvell
[   32.615114] ata7: PATA max UDMA/100 cmd 0x0000000000011018 ctl
0x0000000000011026 bmdma 0x0000000000011000 irq 17
[   32.615116] ata8: DUMMY
[   32.615866] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00
08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   32.622523] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   32.622533] sd 0:0:0:0: [sda] Write Protect is off
[   32.622535] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.622545] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   32.622580] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors
(160042 MB)
[   32.622586] sd 0:0:0:0: [sda] Write Protect is off
[   32.622588] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.622598] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   32.622601]  sda: sda1 sda2 < sda5 >
[   32.666726] sd 0:0:0:0: [sda] Attached SCSI disk
[   32.668697] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   32.861928] Attempting manual resume
[   32.861931] swsusp: Resume From Partition 8:5
[   32.861932] PM: Checking swsusp image.
[   32.862067] PM: Resume from disk failed.
[   32.898435] kjournald starting.  Commit interval 5 seconds
[   32.898444] EXT3-fs: mounted filesystem with ordered data mode.
[   32.934174] ata7.00: ATAPI: TSSTcorpDVD-ROM SH-D162D, SB00, max
UDMA/33
[   33.105820] ata7.00: configured for UDMA/33
[   33.106844] scsi 8:0:0:0: CD-ROM            TSSTcorp DVD-ROM SH-D162D
SB00 PQ: 0 ANSI: 5
[   33.106894] scsi 8:0:0:0: Attached scsi generic sg1 type 5
[   36.890025] usb-storage: device scan complete
[   36.890101] usb-storage: device scan complete
[   36.890525] scsi 7:0:0:0: Direct-Access     WD       1200BEVExternal
1.02 PQ: 0 ANSI: 0
[   36.890668] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader
1.00 PQ: 0 ANSI: 0
[   36.891139] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader
1.01 PQ: 0 ANSI: 0
[   36.891506] sd 7:0:0:0: [sdb] 234441648 512-byte hardware sectors
(120034 MB)
[   36.891636] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader
1.02 PQ: 0 ANSI: 0
[   36.892138] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader
1.03 PQ: 0 ANSI: 0
[   36.892253] sd 7:0:0:0: [sdb] Write Protect is off
[   36.892255] sd 7:0:0:0: [sdb] Mode Sense: 00 00 00 00
[   36.892257] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[   36.893125] sd 7:0:0:0: [sdb] 234441648 512-byte hardware sectors
(120034 MB)
[   36.893746] sd 7:0:0:0: [sdb] Write Protect is off
[   36.893748] sd 7:0:0:0: [sdb] Mode Sense: 00 00 00 00
[   36.893749] sd 7:0:0:0: [sdb] Assuming drive cache: write through
[   36.893753]  sdb:<6>pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   39.011940] shpchp: Standard Hot Plug PCI Controller Driver version:
0.4
[   39.042055] input: PC Speaker as /class/input/input4
[   39.146879] Intel(R) PRO/1000 Network Driver - version 7.6.5-NAPI
[   39.146882] Copyright (c) 1999-2007 Intel Corporation.
[   39.146920] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level,
low) -> IRQ 20
[   39.146930] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   39.193869] e1000: 0000:00:19.0: e1000_probe: (PCI
Express:2.5Gb/s:Width x1) 00:19:d1:7c:f2:69
[   39.223347] heci: Intel(R) AMT Management Interface - version
3.1.0.31
[   39.223350] heci: Copyright (c) 2003 - 2007 Intel Corporation.
[   39.263051] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network
Connection
[   39.263092] ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   39.263096] PCI: Setting latency timer of device 0000:00:03.0 to 64
[   39.264034] heci: link layer has been established.
[   39.285949] nvidia: module license 'NVIDIA' taints kernel.
[   39.539111] heci: heci driver initialization successful.
[   39.543742] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   39.543750] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   39.543823] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19
Wed Sep 12 14:08:38 PDT 2007
[   39.554103] usbcore: registered new interface driver xpad
[
39.554106] /build/buildd/linux-source-2.6.22-2.6.22/drivers/input/joystick/xpad.c: driver for Xbox controllers v0.1.6
[   39.745530] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[   39.745534] Uniform CD-ROM driver Revision: 3.20
[   39.745699] sr 8:0:0:0: Attached scsi CD-ROM sr0
[   39.959429] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 22
[   39.960191] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   40.167253] hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS...
[   40.501814]  sdb1
[   40.501866] sd 7:0:0:0: [sdb] Attached SCSI disk
[   40.501899] sd 7:0:0:0: Attached scsi generic sg2 type 0
[   40.502634] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   40.502657] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   40.503677] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[   40.503701] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   40.506604] sd 6:0:0:2: [sde] Attached SCSI removable disk
[   40.506639] sd 6:0:0:2: Attached scsi generic sg5 type 0
[   40.510621] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[   40.510649] sd 6:0:0:3: Attached scsi generic sg6 type 0

As you can see I'm running the NVida kernel module (needed for duel
screen), but I can test without it if needed. Finally the lsmod output:

root@pitcairn:/home/ajb# lsmod
Module                  Size  Used by
rfcomm                 47656  2 
l2cap                  28672  11 rfcomm
bluetooth              63876  4 rfcomm,l2cap
ppdev                  11272  0 
button                 10400  0 
sbs                    21520  0 
ac                      7304  0 
video                  21140  0 
container               6400  0 
dock                   12264  0 
battery                12424  0 
acpi_cpufreq           10632  0 
cpufreq_stats           8160  0 
cpufreq_userspace       6048  0 
cpufreq_ondemand       10896  2 
freq_table              6464  3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand
cpufreq_conservative     9608  0 
cpufreq_powersave       3072  0 
ipv6                  317192  20 
nfs                   272984  2 
lockd                  76336  2 nfs
sunrpc                198536  3 nfs,lockd
parport_pc             41896  0 
lp                     15048  0 
parport                44172  3 ppdev,parport_pc,lp
loop                   21764  0 
snd_hda_intel         337192  4 
snd_pcm_oss            50048  0 
snd_mixer_oss          20096  1 snd_pcm_oss
snd_pcm                94344  3 snd_hda_intel,snd_pcm_oss
snd_seq_dummy           5380  0 
snd_seq_oss            36864  0 
sr_mod                 19876  0 
cdrom                  41768  1 sr_mod
snd_seq_midi           11008  0 
snd_rawmidi            29824  1 snd_seq_midi
snd_seq_midi_event      9984  2 snd_seq_oss,snd_seq_midi
snd_seq                62496  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              27272  3 snd_pcm,snd_seq
xpad                   11400  0 
snd_seq_device         10260  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
nvidia               7013492  36 
psmouse                45596  0 
ata_generic             9988  0 
i2c_core               30208  1 nvidia
heci                   66064  0 
serio_raw               9092  0 
e1000_ich9            211008  0 
snd                    69288  15 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore              10272  1 snd
snd_page_alloc         12560  2 snd_hda_intel,snd_pcm
pcspkr                  4608  0 
shpchp                 38300  0 
pci_hotplug            36612  1 shpchp
intel_agp              30624  0 
joydev                 13440  0 
evdev                  13056  4 
ext3                  146576  2 
jbd                    69360  1 ext3
mbcache                11272  1 ext3
sg                     41384  0 
sd_mod                 32512  5 
usbhid                 32576  0 
hid                    33408  1 usbhid
usb_storage            81728  1 
ide_core              141200  1 usb_storage
libusual               22824  1 usb_storage
ahci                   27012  2 
pata_marvell            9472  0 
ohci1394               38984  0 
ieee1394              109528  1 ohci1394
libata                138928  3 ata_generic,ahci,pata_marvell
scsi_mod              172856  5 sr_mod,sg,sd_mod,usb_storage,libata
ehci_hcd               40076  0 
uhci_hcd               29600  0 
usbcore               161584  7 xpad,usbhid,usb_storage,libusual,ehci_hcd,uhci_hcd
thermal                16528  0 
processor              36232  2 acpi_cpufreq,thermal
fan                     6920  0 
fuse                   52528  1 
apparmor               47008  0 
commoncap               9472  1 apparmor

Any pointers?

--
Alex, homepage: http://www.bennee.com/~alex/ 
Other restrictions may apply.

