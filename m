Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYEYPqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYEYPqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 11:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYEYPq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 11:46:29 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:59900 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYEYPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 11:46:26 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 11:46:26 EDT
From: Riccardo Gori <goric@trivenet.it>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #10749] the system doesn't shutdown
Date: Sun, 25 May 2008 17:40:07 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.w4C.BeIOIB@albercik> <200805260019.09846.bzolnier@gmail.com>
In-Reply-To: <200805260019.09846.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251740.07631.goric@trivenet.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008 00:19:09 Bartlomiej Zolnierkiewicz wrote:
> Hi,
>
> On Saturday 24 May 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10749
> > Subject		: the system doesn't shutdown
> > Submitter	: Riccardo <goric@trivenet.it>
> > Date		: 2008-05-19 09:00 (6 days old)
>
> Riccardo, thanks for bisecting the problem.  Could you also attach dmesgs
> for "good" and "bad" kernels at bugzilla entry (so we can see if there are
> any clues for solving the regression in messages printed by the driver)?
>
> Also does the following patch help (we should always setup PCI device
> with pci_enable_device() before using it, my patch changed it)?
>
> ---
>  drivers/ide/pci/sis5513.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> Index: b/drivers/ide/pci/sis5513.c
> ===================================================================
> --- a/drivers/ide/pci/sis5513.c
> +++ b/drivers/ide/pci/sis5513.c
> @@ -569,6 +569,11 @@ static int __devinit sis5513_init_one(st
>  {
>  	struct ide_port_info d = sis5513_chipset;
>  	u8 udma_rates[] = { 0x00, 0x00, 0x07, 0x1f, 0x3f, 0x3f, 0x7f, 0x7f };
> +	int rc;
> +
> +	rc = pci_enable_device(dev);
> +	if (rc)
> +		return rc;
>
>  	if (sis_find_family(dev) == 0)
>  		return -ENOTSUPP;


Hello,
I'm bisecting again the kernel because I think I made something wrong.

I don't think that is this the first bad commit because, after bisecting, I 
tried to git reset hard to that commit 3 times and build the kernel, and once 
the problem was not present. I'm really sorry.

This is the output of dmesg when the problem is present:

# dmesg
r (psparse-0537): Method parse/execution failed [\ISMI] (Node f7c18630), 
AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.MIDI._STA] (Node f7c1ef68), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.GAME._STA] (Node f7c1eedc), AE_NO_MEMORY
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: Enabling SiS 96x SMBus
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.FDC0._STA] (Node f7c1ebd0), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.FDC0._STA] 
(Node f7c1ebd0), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.LPT_._STA] (Node f7c1eb44), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.LPT_._STA] 
(Node f7c1eb44), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.ECP_._STA] (Node f7c1eab8), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.ECP_._STA] 
(Node f7c1eab8), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.UAR1._STA] (Node f7c1ea18), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.UAR1._STA] 
(Node f7c1ea18), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.UAR2._STA] (Node f7c1e978), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.UAR2._STA] 
(Node f7c1e978), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.SMAR._STA] (Node f7c1e8ec), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.SMAR._STA] 
(Node f7c1e8ec), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.IRDA._STA] (Node f7c1e860), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.IRDA._STA] 
(Node f7c1e860), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.MIDI._STA] (Node f7c1ef68), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.MIDI._STA] 
(Node f7c1ef68), AE_NO_MEMORY
ACPI Error (exregion-0164): Could not map memory at F7C218943FFFFF00, size 200 
[20070126]
ACPI Exception (evregion-0420): AE_NO_MEMORY, Returned by Handler for 
[SystemMemory] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\ISMI] (Node 
f7c18630), AE_NO_MEMORY
ACPI Error (psparse-0537): Method parse/execution failed 
[\_SB_.PCI0.PX40.GAME._STA] (Node f7c1eedc), AE_NO_MEMORY
ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.PX40.GAME._STA] 
(Node f7c1eedc), AE_NO_MEMORY
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x3fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:02: ioport range 0xe400-0xe47f has been reserved
system 00:02: ioport range 0xe480-0xe4ff has been reserved
system 00:02: ioport range 0xe600-0xe61f has been reserved
system 00:02: ioport range 0x480-0x48f has been reserved
system 00:02: iomem range 0xffee0000-0xffefffff has been reserved
system 00:03: iomem range 0xfffe0000-0xffffffff could not be reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x295-0x296 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: 0xcf000000-0xcfffffff
  PREFETCH window: 0x00000000e0000000-0x00000000febfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) 
as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Invalid PBLK length [5]
ACPI: ACPI0007:00 is registered as cooling_device0
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
SIS5513: IDE controller (0x1039:0x5513 rev 0x00) at  PCI slot 0000:00:02.5
ACPI: PCI Interrupt 0000:00:02.5[A] -> GSI 16 (level, low) -> IRQ 16
SIS5513: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xa400-0xa407
    ide1: BM-DMA at 0xa408-0xa40f
Probing IDE interface ide0...
hda: Maxtor 6Y080L0, ATA DISK drive
hdb: Maxtor 6E040L0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/133 mode selected
Probing IDE interface ide1...
hdc: PHILIPS DVDR1660P1, ATAPI CD/DVD-ROM drive
hdd: LG DVD-ROM DRD-8160B, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 128KiB
hda: 156250000 sectors (80000 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdb: max request size: 128KiB
hdb: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=65535/16/63
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3
hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 48X DVD-ROM drive, 512kB Cache
Driver 'sd' needs updating - please use bus_type methods
ehci_hcd 0000:00:03.3: enabling device (0004 -> 0006)
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
PCI: cache line size of 128 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: irq 23, io mem 0xcc800000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25 ehci_hcd
usb usb1: SerialNumber: 0000:00:03.3
Initializing USB Mass Storage driver...
usb 1-3: new high speed USB device using ehci_hcd and address 2
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 6 ports detected
usb 1-3: New USB device found, idVendor=050d, idProduct=0255
usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input2
cpuidle: using governor ladder
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
logips2pp: Detected unknown logitech mouse model 57
input: ImExPS/2 Logitech Explorer Mouse 
as /devices/platform/i8042/serio1/input/input3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 20, io mem 0xce000000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25 ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 21, io mem 0xcd800000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25 ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:03.2: irq 22, io mem 0xcd000000
sis900.c: v1.08.10 Apr. 2 2006
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25 ohci_hcd
usb usb4: SerialNumber: 0000:00:03.2
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0xe600
sis900 0000:00:04.0: enabling device (0004 -> 0007)
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 19
0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x8800, IRQ 19, 00:e0:18:a2:44:11
Linux agpgart interface v0.103
agpgart: Detected SiS chipset - id:1608
agpgart: AGP aperture is 128M @ 0xd0000000
C-Media PCI 0000:00:0a.0: enabling device (0084 -> 0085)
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
EXT3 FS on hda3, internal journal
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized radeon 1.28.0 20060524 on minor 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1044216k swap on /dev/hda2.  Priority:-1 extents:1 across:1044216k
eth0: Media Link On 100mbps full-duplex
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: X requested AGPx8 but bridge not capable.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
agpgart: SiS delay workaround: giving bridge time to recover.
agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] writeback test succeeded in 1 usecs
NET: Registered protocol family 10
eth0: no IPv6 routers present

Sorry again

Riccardo Gori
