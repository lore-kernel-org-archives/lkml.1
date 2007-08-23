Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbXHWOWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbXHWOWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbXHWOVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:21:55 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:38440 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780AbXHWOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:21:52 -0400
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 10:21:52 EDT
Message-ID: <46CD92B6.5090900@itwm.fraunhofer.de>
Date: Thu, 23 Aug 2007 15:59:18 +0200
From: Martin Vogt <vogt@itwm.fraunhofer.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs corruption by doing nothing
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------080503090703020400080303"
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080503090703020400080303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



Hello,

this bug report describes the following scenario:

- Insert a Knoppix 5.1.1 CD
  into a fileserver with a clean reiserfs system and
  Knoppix completely destroys the reiser filesystem on the fileserver,
  just by booting Knoppix.


Its unclear if this is a knoppix bug, but reiserfs
simply tries to "correct something" which is wrong.

>ReiserFS: sda2: found reiserfs format "3.6" with standard journal
>ReiserFS: sda2: using ordered data mode
>ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size
>(144767). Changed to 1024

^^^^^^^^^^here

>ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
>ReiserFS: sdb2: using ordered data mode
>ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size
>(144767). Changed to 1024

^^^^^^^^^^here

After that the filesystem is completely broken.

The setup:

The fileserver is a mirror raid, two drives:

>DEVICE /dev/sda1 /dev/sdb1 /dev/sda2 /dev/sdb2
>ARRAY /dev/md0 level=raid1 num-devices=2 devices=/dev/sda1,/dev/sdb1 name=0
>UUID=bd639458:60844c49:38db9f1f:61e51054
>ARRAY /dev/md1 level=raid1 num-devices=2 devices=/dev/sda2,/dev/sdb2 name=1
>UUID=016fdb8b:4d1e2ba7:9734a5c9:f4e84a24


So knoppix should _not_ identify the drives in the fstab
(1. Error)
fstab:
># Added by KNOPPIX
>/dev/sda1 /media/sda1 ext3 noauto,users,exec 0 0
># Added by KNOPPIX
>/dev/sda2 /media/sda2 reiserfs noauto,users,exec 0 0
># Added by KNOPPIX
>/dev/sdb1 /media/sdb1 ext3 noauto,users,exec 0 0
># Added by KNOPPIX
>/dev/sdb2 /media/sdb2 reiserfs noauto,users,exec 0 0

And reiserfs should not try to correct something, without
even issuing a mount command.
(2. Error)
>ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size
>(144767). Changed to 1024
>ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size
>(144767). Changed to 1024


This is the history of what I typed:

root@Knoppix:/# history
    1  mdrun
    2  modprobe raid1
    3  mdrun
    4  vgscan
    5  vgchange -a y
    6  mkdir /newroot
    7  mount /dev/system3/slash /newroot/

1: failed because the raid1 driver was missing
The other commands then bring up the root device,
but a chroot to /newroot fails. (filesystem completely
broken)

Is this bug reproducible?
No.


I did the same procedure today for, I think 6 times or so,
this did all work. (same machine, clean raid,lvm,reiserfs)
I had this bug some weeks ago on another fileserver, with
different hardware. I thought, well ok. But now its
on this hardware the same, so there is really something
broken.

>Linux Knoppix 2.6.19 #7 SMP PREEMPT Sun Dec 17 22:01:07 CET 2006 i686
>GNU/Linux

I had on this machine software irq lockups, which were gone
after a BIOS update and disable hyperthreading and L3 cache.
So maybe its preempt related too?


Even if knoppix should not be used as a rescue/live CD, then
the reiserfs module should not try to correct something,
this should be done by another tool.(fsck.reiserfs or a module option...)

Well ok, the obvious workaround is not to use reiserfs
in a setup md->lvm->reiserfs.
Does XFS or ext3 has such problems?

(dmesg as attachement)

regards,

Martin





--------------080503090703020400080303
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.19 (root@Knoppix) (gcc version 4.1.2 20061028 (prerelease) (Debian 4.1.1-19)) #7 SMP PREEMPT Sun Dec 17 22:01:07 CET 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
 BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ca000 - 00000000000cc000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fef0000 (usable)
 BIOS-e820: 000000007fef0000 - 000000007fefc000 (ACPI data)
 BIOS-e820: 000000007fefc000 - 000000007ff00000 (ACPI NVS)
 BIOS-e820: 000000007ff00000 - 000000007ff80000 (usable)
 BIOS-e820: 000000007ff80000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f64d0
Entering add_active_range(0, 0, 524160) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524160
early_node_map[1] active PFN ranges
    0:        0 ->   524160
On node 0 totalpages: 524160
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292481 pages, LIFO batch:31
DMI present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6500
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x7fef8674
ACPI: FADT (v001 Intel  SE7501CW 0x06040000 PTL  0x00000008) @ 0x7fefbe94
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0x7fefbf08
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x7fefbf88
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @ 0x7fefbfb0
ACPI: DSDT (v001  INTEL   PLUMAS 0x06040000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x04] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Detected 3056.571 MHz processor.
Built 1 zonelists.  Total pages: 520065
Kernel command line: ramdisk_size=100000 init=/etc/init lang=us apm=power-off vga=791 initrd=minirt.gz nomce loglevel=0 quiet BOOT_IMAGE=knoppix BOOT_IMAGE=linux 3
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80400)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2072408k/2096640k available (2747k kernel code, 22860k reserved, 958k data, 336k init, 1179072k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe16000 - 0xfffff000   (1956 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc04a6000 - 0xc04fa000   ( 336 kB)
      .data : 0xc03aef9c - 0xc049e7b4   ( 958 kB)
      .text : 0xc0100000 - 0xc03aef9c   (2747 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6117.80 BogoMIPS (lpj=12235606)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00000080 00004400 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Checking for popad bug... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
CPU0: Intel(R) Xeon(TM) CPU 3.06GHz stepping 05
SMP alternatives: switching to SMP code
Booting processor 1/6 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6113.45 BogoMIPS (lpj=12226915)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebfbff 00000000 00000000 00000080 00004400 00000000 00000000
CPU1: Intel(R) Xeon(TM) CPU 3.06GHz stepping 05
Total of 2 processors activated (12231.26 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=816
checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 1188k freed
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd905, last bus=4
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:04:03.0
PCI: Firmware left 0000:04:04.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 *11 14 15)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICH3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HLB_.Z000._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HLB_.Z001._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PnPBIOS: Disabled by ACPI PNP
Intel 82802 RNG detected
SCSI subsystem initialized
libata version 2.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI: Bridge: 0000:01:1d.0
  IO window: 7000-7fff
  MEM window: fb200000-fbffffff
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:01:1f.0
  IO window: 8000-8fff
  MEM window: fc000000-fc0fffff
  PREFETCH window: 88100000-881fffff
PCI: Bridge: 0000:00:02.0
  IO window: 7000-8fff
  MEM window: fb100000-fc0fffff
  PREFETCH window: 88000000-881fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-9fff
  MEM window: fc100000-fdffffff
  PREFETCH window: 88200000-882fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x35 set to 0x1
audit: initializing netlink socket (disabled)
audit(1187879883.688:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
fuse init (API version 7.8)
fuse distribution version: 2.6.1
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
vesafb: framebuffer at 0xfd000000, mapped to 0xf8880000, using 3072k, total 8128k
vesafb: mode is 1024x768x16, linelength=2048, pages=4
vesafb: protected mode interface info at c000:4bbc
vesafb: pmi: set display start = c00c4c22, set palette = c00c4c7c
vesafb: pmi: ports = 9085 901f 90b4 90b8 9018 9014 90c0 90c3 90c1 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 100000K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH3: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH3: chipset revision 2
ICH3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x6c60-0x6c67, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x6c68-0x6c6f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
hdc: _NEC DV-5800C, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide0...
hdc: ATAPI 48X DVD-ROM drive, 512kB Cache
Uniform CD-ROM driver Revision: 3.20
Loading iSCSI transport class v2.0-724.<6>PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EISA: Probing bus 0 at eisa.0
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 6
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 15
Using IPI No-Shortcut mode
ACPI: (supports S0 S4 S5)
Time: tsc clocksource has been installed.
input: AT Translated Set 2 keyboard as /class/input/input0
RAMDISK: Compressed image found at block 0
EXT2-fs warning: checktime reached, running e2fsck is recommended
VFS: Mounted root (ext2 filesystem).
Failed initialization of WD-7000 SCSI card!
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 17, io base 0x00006c00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006c20
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 16, io base 0x00006c40
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
usb 1-2: new low speed USB device using uhci_hcd and address 2
usb 1-2: configuration #1 chosen from 1 choice
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input1
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-2
input: Cherry GmbH as /class/input/input2
input: USB HID v1.11 Keyboard [Cherry GmbH] on usb-0000:00:1d.1-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ieee1394: Initialized config rom entry `ip1394'
ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
ieee1394: sbp2: Try serialize_io=0 for better performance
Warning: /proc/ide/hd?/settings interface is obsolete, and will be removed soon!
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
cloop: Initializing cloop v2.05
cloop: loaded (max 8 devices)
cloop: /cdrom/KNOPPIX/KNOPPIX: 15609 blocks, 131072 bytes/block, largest block is 131098 bytes.
cloop: loaded 256 blocks into cache.
ISO 9660 Extensions: RRIP_1991A
aufs 2.6.19-20061211
Freeing unused kernel memory: 336k freed
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
Using specific hotkey driver
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x2
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x3
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x4
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x5
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x6
ACPI Exception (acpi_processor-0681): AE_NOT_FOUND, Processor Device is not present [20060707]
ACPI: Getting cpuindex for acpiid 0x7
cpufreq: No nForce2 chipset.
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
powernow: This module only works with AMD K7 CPUs
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 19
EDAC MC: Ver: 2.0.1 Dec 13 2006
EDAC e7xxx: tolm = 80000, remapbase = ffc000, remaplimit = 0
EDAC MC0: Giving out device to e7xxx_edac E7501: DEV 0000:00:00.0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
3ware Storage Controller device driver for Linux v1.26.02.001.
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 28 (level, low) -> IRQ 20
Intel(R) PRO/1000 Network Driver - version 7.2.9-k4
Copyright (c) 1999-2006 Intel Corporation.
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
scsi0 : 3ware Storage Controller
3w-xxxx: scsi0: Found a 3ware Storage Controller at 0x7000, IRQ: 20.
scsi 0:0:0:0: Direct-Access     3ware    Logical Disk 0   1.2  PQ: 0 ANSI: 0
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
SCSI device sda: drive cache: write back w/ FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: Direct-Access     3ware    Logical Disk 1   1.2  PQ: 0 ANSI: 0
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 00 00 00
SCSI device sdb: drive cache: write back w/ FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 00 00 00
SCSI device sdb: drive cache: write back w/ FUA
 sdb: sdb1 sdb2
sd 0:0:1:0: Attached scsi disk sdb
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 48 (level, low) -> IRQ 21
e1000: 0000:03:01.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:a8:de:ee
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 49 (level, low) -> IRQ 22
e1000: 0000:03:01.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:04:23:a8:de:ef
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 19 (level, low) -> IRQ 18
e1000: 0000:04:02.0: e1000_probe: (PCI:33MHz:32-bit) 00:1b:21:00:a8:07
e1000: eth2: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 23 (level, low) -> IRQ 23
e1000: 0000:04:05.0: e1000_probe: (PCI:33MHz:32-bit) 00:02:b3:ea:44:ee
e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 20 (level, low) -> IRQ 24
e100: eth4: e100_probe: addr 0xfc181000, irq 24, MAC addr 00:02:B3:EA:46:E3
NET: Registered protocol family 17
e1000: eth2: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
Linux agpgart interface v0.101 (c) Dave Jones
device-mapper: ioctl: 4.10.0-ioctl (2006-09-14) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sda2: found reiserfs format "3.6" with standard journal
ReiserFS: sda2: using ordered data mode
ReiserFS: sda2: warning: sh-461: journal_init: wrong transaction max size (144767). Changed to 1024
ReiserFS: sda2: journal params: device sda2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 268435456, max trans age 30
ReiserFS: sda2: checking transaction log (sda2)
ReiserFS: warning: is_tree_node: node level 1 does not match to the expected one 4
ReiserFS: sda2: warning: vs-5150: search_by_key: invalid format found in block 2239561. Fsck?
ReiserFS: sda2: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [1 2 0x0 SD]
ReiserFS: sda2: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: sdb2: found reiserfs format "3.6" with standard journal
ReiserFS: sdb2: using ordered data mode
ReiserFS: sdb2: warning: sh-461: journal_init: wrong transaction max size (144767). Changed to 1024
ReiserFS: sdb2: journal params: device sdb2, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 268435456, max trans age 30
ReiserFS: sdb2: checking transaction log (sdb2)
ReiserFS: warning: is_tree_node: node level 1 does not match to the expected one 4
ReiserFS: sdb2: warning: vs-5150: search_by_key: invalid format found in block 2239561. Fsck?
ReiserFS: sdb2: warning: vs-13070: reiserfs_read_locked_inode: i/o failure occurred trying to find stat data of [1 2 0x0 SD]
ReiserFS: sdb2: Using r5 hash to sort names
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_UP): eth4: link is not ready
Mobile IPv6
e1000: eth2: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): eth2: link is not ready
ADDRCONF(NETDEV_UP): eth3: link is not ready
e1000: eth2: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
eth2: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth4: link is not ready
md: raid1 personality registered for level 1
md: md0 stopped.
md: bind<sda1>
md: bind<sdb1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: md1 stopped.
md: bind<sda2>
md: bind<sdb2>
raid1: raid set md1 active with 2 out of 2 mirrors
ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: Using r5 hash to sort names
ReiserFS: dm-5: found reiserfs format "3.6" with standard journal
ReiserFS: dm-5: using ordered data mode
ReiserFS: dm-5: journal params: device dm-5, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-5: checking transaction log (dm-5)
ReiserFS: dm-5: Using r5 hash to sort names
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
ReiserFS: dm-3: found reiserfs format "3.6" with standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: Using r5 hash to sort names

--------------080503090703020400080303--
