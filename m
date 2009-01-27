Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZA0RHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZA0RHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZA0RHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:07:35 -0500
Received: from mx1.wp.pl ([212.77.101.5]:34667 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZA0RHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:07:31 -0500
Date: Tue, 27 Jan 2009 18:10:50 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <abelay@mit.edu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: How should I handle device with two PNP-BIOS ids?
Message-Id: <20090127181050.b5d3d7ad.krzysztof.h1@wp.pl>
In-Reply-To: <200901270852.52153.bjorn.helgaas@hp.com>
References: <497d80991ef709.35340258@wp.pl>
	<200901261513.32348.bjorn.helgaas@hp.com>
	<20090127094255.fc038987.krzysztof.h1@wp.pl>
	<200901270852.52153.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QRNk]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 08:52:51 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Tuesday 27 January 2009 01:42:55 am Krzysztof Helt wrote:
> > On Mon, 26 Jan 2009 15:13:31 -0700
> > 
> > The laptop in question is the Dell Latitude CPi and it does not
> > have ACPI only the PnP BIOS. 
> > The both ids are reported as unrelated (two separate nodes in 
> > the /sys/bus/pnp/).
> 
> Oh.  That sounds like a BIOS bug.  If there's only one actual
> chip, the BIOS should not report it as two separate devices.
> I guess it might report two devices if only one of them is
> enabled at a time.  In that case, there might be a BIOS setup
> switch to toggle between them.
> 

If it is the BIOS bug it is pretty widespread. At least, the same 
chip in IBM laptops have the same problem. Desktop Dell models
have the problem as well. I suspect this is how a MS Windows 
driver expects this chip.

> Can you turn on CONFIG_PNP_DEBUG_MESSAGES and boot with the
> pnp.debug kernel parameter?  Then collect the dmesg log and
> the output of "grep . /sys/devices/pnp*/*/*".
> 

I did the "grep . /sys/bus/pnp/*/*". The chip in question has the ids 00:0f
and 00:10. The grep log is at the end of the email.

> > 
> > Currently, I iterate over pnpbios_protocol to find out if the second 
> > id exists. It is not elegant but works.
> 
> Can you point me to the driver?
> 

The driver in question is snd-cs4232 and snd-cs4236. The change has
been posted here 

http://mailman.alsa-project.org/pipermail/alsa-devel/2009-January/014226.html

The iteration part is here:

+static int __devinit snd_cs423x_pnpbios_detect(struct pnp_dev *pdev,
 					       const struct pnp_device_id *id)
 {
 	static int dev;
 	int err;
 	struct snd_card *card;
+	struct pnp_dev *cdev;
+	struct list_head *pos;
+	char cid[PNP_ID_LEN];
 
 	if (pnp_device_is_isapnp(pdev))
 		return -ENOENT;	/* we have another procedure - card */
@@ -594,10 +575,20 @@ static int __devinit snd_cs4232_pnpbios_detect(struct pnp_dev *pdev,
 	if (dev >= SNDRV_CARDS)
 		return -ENODEV;
 
+	/* prepare second id */
+	strcpy(cid, pdev->id[0].id);
+	cid[5] = '1';
+	cdev = NULL;
+	list_for_each(pos, &(pdev->protocol->devices)) {
+		cdev = list_entry(pos, struct pnp_dev, protocol_list);
+		if (!strcmp(cdev->id[0].id, cid))
+			break;
+	}

If the cdev is not NULL after the loop it means that the chip is later 
model with additional ports. It is not very messy.

I asked because I thought maybe there is a simpler or cleaner way
which I am not aware of.

Regards,
Krzysztof

dmesg:
BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28mmx (root@darkstar) (gcc version 3.4.6) #6 Tue Jan 27 17:41:35 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Cyrix CyrixInstead
  NSC Geode by NSC
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000002000000 (usable)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI not present or invalid.
last_pfn = 0x2000 max_arch_pfn = 0x100000
kernel direct mapping tables up to 2000000 @ 7000-c000
32MB LOWMEM available.
  mapped low ram: 0 - 02000000
  low ram: 00000000 - 02000000
  bootmap 00001000 - 00001400
(6 early reservations) ==> bootmem [0000000000 - 0002000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000200000 - 00004a3d20]    TEXT DATA BSS ==> [0000200000 - 00004a3d20]
  #2 [00004a4000 - 00004a7000]    INIT_PG_TABLE ==> [00004a4000 - 00004a7000]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #5 [0000001000 - 0000002000]          BOOTMAP ==> [0000001000 - 0000002000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00002000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00002000
On node 0 totalpages: 8095
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 32 pages used for memmap
  Normal zone: 4064 pages, LIFO batch:0
  Movable zone: 0 pages used for memmap
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 10000000 (gap: 2000000:fdf00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8031
Kernel command line: BOOT_IMAGE=linux-2.6.28 ro root=801 pnp.debug
Initializing CPU#0
PID hash table entries: 128 (order: 7, 512 bytes)
TSC: Using PIT calibration value
Detected 233.856 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 29108k/32768k available (1571k kernel code, 3268k reserved, 715k data, 184k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
    vmalloc : 0xc2800000 - 0xfffeb000   ( 983 MB)
    lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
      .init : 0xc043e000 - 0xc046c000   ( 184 kB)
      .data : 0xc0388f05 - 0xc043bee8   ( 715 kB)
      .text : 0xc0200000 - 0xc0388f05   (1571 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 467.71 BogoMIPS (lpj=2338560)
Mount-cache hash table entries: 512
Intel Pentium with F0 0F bug - workaround enabled.

CPU: Intel Mobile Pentium MMX stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
net_namespace: 288 bytes
Time: 17:46:27  Date: 01/27/09
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb98e, last bus=0
PCI: Using configuration type 1 for base access
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pci 0000:00:01.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:01.2: reg 20 io port: [0xece0-0xecff]
pci 0000:00:01.3: quirk: region 0800-083f claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: region 0840-084f claimed by PIIX4 SMB
pci 0000:00:01.3: PIIX4 devres B PIO at 00e0-00e7
pci 0000:00:01.3: PIIX4 devres C PIO at 0210-0217
pci 0000:00:01.3: PIIX4 devres E PIO at 0388-038b
pci 0000:00:01.3: PIIX4 devres G PIO at 0290-0297
pci 0000:00:02.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xff000000-0xff1fffff]
pci 0000:00:02.0: reg 18 32bit mmio: [0xff200000-0xff2fffff]
pci 0000:00:03.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:00:03.1: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:00:01.0: PIIX/ICH IRQ router [8086:7110]
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fe2d0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xe2f4, dseg 0x40
pnp 00:00: parse allocated resources
pnp 00:00:   add io  0xcf8-0xcff flags 0x0
pnp 00:00: parse resource options
pnp 00:00: Plug and Play BIOS device, IDs PNP0a03 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add mem 0x0-0x9ffff flags 0x0
pnp 00:01:   add mem 0x100000-0x1ffffff flags 0x0
pnp 00:01:   add mem 0xf0000-0xfffff flags 0x0
pnp 00:01:   add mem 0xfffe0000-0xffffffff flags 0x0
pnp 00:01:   add io  0x800-0x83f flags 0x0
pnp 00:01:   add io  0x840-0x84f flags 0x0
pnp 00:01:   add io  0x3f0-0x3f1 flags 0x0
pnp 00:01:   add io  0xe0-0xe1 flags 0x0
pnp 00:01: parse resource options
pnp 00:01: PNP0c01: calling quirk_system_pci_resources+0x0/0x162
pnp 00:01: Plug and Play BIOS device, IDs PNP0c01 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0xfc00-0xfcfe flags 0x0
pnp 00:02: parse resource options
pnp 00:02: PNP0c01: calling quirk_system_pci_resources+0x0/0x162
pnp 00:02: Plug and Play BIOS device, IDs PNP0c01 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add irq 2 flags 0x0
pnp 00:03:   add io  0x20-0x3f flags 0x0
pnp 00:03:   add io  0xa0-0xbf flags 0x0
pnp 00:03:   add io  0x4d0-0x4d1 flags 0x0
pnp 00:03: parse resource options
pnp 00:03: Plug and Play BIOS device, IDs PNP0000 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add irq 0 flags 0x0
pnp 00:04:   add io  0x40-0x5f flags 0x0
pnp 00:04: parse resource options
pnp 00:04: Plug and Play BIOS device, IDs PNP0100 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x80-0x9f flags 0x0
pnp 00:05:   add io  0x0-0x1f flags 0x0
pnp 00:05:   add io  0xc0-0xdf flags 0x0
pnp 00:05:   add dma 4 flags 0x0
pnp 00:05: parse resource options
pnp 00:05: Plug and Play BIOS device, IDs PNP0200 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add irq 1 flags 0x0
pnp 00:06:   add io  0x60-0x60 flags 0x0
pnp 00:06:   add io  0x64-0x64 flags 0x0
pnp 00:06: parse resource options
pnp 00:06: Plug and Play BIOS device, IDs PNP0303 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add irq 12 flags 0x0
pnp 00:07: parse resource options
pnp 00:07: Plug and Play BIOS device, IDs PNP0f13 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x61-0x61 flags 0x0
pnp 00:08: parse resource options
pnp 00:08: Plug and Play BIOS device, IDs PNP0800 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add irq 8 flags 0x0
pnp 00:09:   add io  0x70-0x7f flags 0x0
pnp 00:09: parse resource options
pnp 00:09: Plug and Play BIOS device, IDs PNP0b00 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add irq 13 flags 0x0
pnp 00:0a:   add io  0xf0-0xff flags 0x0
pnp 00:0a: parse resource options
pnp 00:0a: Plug and Play BIOS device, IDs PNP0c04 (active)
pnp 00:0b: parse allocated resources
pnp 00:0b:   add irq 11 flags 0x0
pnp 00:0b:   add io  0x3e0-0x3e1 flags 0x0
pnp 00:0b: parse resource options
pnp 00:0b:   independent irq 9 flags 0x1
pnp 00:0b:   independent io  min 0x3e0 max 0x3e0 align 1 size 2 flags 0x1
pnp 00:0b: Plug and Play BIOS device, IDs PNP0e03 PNP0e00 (active)
pnp 00:0c: parse allocated resources
pnp 00:0c:   add irq 4 flags 0x0
pnp 00:0c:   add io  0x3f8-0x3ff flags 0x0
pnp 00:0c: parse resource options
pnp 00:0c:   dependent set 0 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0c:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 8 size 8 flags 0x1
pnp 00:0c:   dependent set 1 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0c:   dependent set 1 (acceptable) io  min 0x2f8 max 0x2f8 align 8 size 8 flags 0x1
pnp 00:0c:   dependent set 2 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0c:   dependent set 2 (acceptable) io  min 0x3e8 max 0x3e8 align 8 size 8 flags 0x1
pnp 00:0c:   dependent set 3 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0c:   dependent set 3 (acceptable) io  min 0x2e8 max 0x2e8 align 8 size 8 flags 0x1
pnp 00:0c: Plug and Play BIOS device, IDs PNP0501 (active)
pnp 00:0d: parse allocated resources
pnp 00:0d:   add irq 4 flags 0x0
pnp 00:0d:   add io  0x3e8-0x3ef flags 0x0
pnp 00:0d:   add io  0x290-0x297 flags 0x0
pnp 00:0d:   add dma 3 flags 0x0
pnp 00:0d: parse resource options
pnp 00:0d:   dependent set 0 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 0 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 0 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0d:   dependent set 1 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 1 (acceptable) io  min 0x2f8 max 0x2f8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 1 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0d:   dependent set 2 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 2 (acceptable) io  min 0x3e8 max 0x3e8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 2 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0d:   dependent set 3 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 3 (acceptable) io  min 0x2e8 max 0x2e8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 3 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0d:   dependent set 4 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 4 (acceptable) io  min 0x3f8 max 0x3f8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 4 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 4 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0d:   dependent set 5 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 5 (acceptable) io  min 0x2f8 max 0x2f8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 5 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 5 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0d:   dependent set 6 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 6 (acceptable) io  min 0x3e8 max 0x3e8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 6 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 6 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0d:   dependent set 7 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 7 (acceptable) io  min 0x2e8 max 0x2e8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 7 (acceptable) io  min 0x270 max 0x400 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 7 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0d:   dependent set 8 (acceptable) irq 3 4 6 12 flags 0x1
pnp 00:0d:   dependent set 8 (acceptable) io  min 0x3e8 max 0x3e8 align 8 size 8 flags 0x1
pnp 00:0d:   dependent set 8 (acceptable) io  min 0x0 max 0x0 align 8 size 0 flags 0x1
pnp 00:0d:   dependent set 8 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0d: Plug and Play BIOS device, IDs SMCf010 PNP0510 (active)
pnp 00:0e: parse allocated resources
pnp 00:0e:   add dma -1 flags 0x10000000
pnp 00:0e:   add irq 7 flags 0x0
pnp 00:0e:   add io  0x378-0x37f flags 0x0
pnp 00:0e:   add io  0x778-0x77b flags 0x0
pnp 00:0e: parse resource options
pnp 00:0e:   dependent set 0 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 0 (acceptable) irq 3 4 5 7 flags 0x1
pnp 00:0e:   dependent set 0 (acceptable) io  min 0x378 max 0x378 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 0 (acceptable) io  min 0x778 max 0x778 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0e:   dependent set 1 (acceptable) irq 7 flags 0x1
pnp 00:0e:   dependent set 1 (acceptable) io  min 0x378 max 0x378 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 1 (acceptable) io  min 0x778 max 0x778 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 2 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 2 (acceptable) irq 3 4 5 7 flags 0x1
pnp 00:0e:   dependent set 2 (acceptable) io  min 0x278 max 0x278 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 2 (acceptable) io  min 0x678 max 0x678 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0e:   dependent set 3 (acceptable) irq 3 4 5 7 flags 0x1
pnp 00:0e:   dependent set 3 (acceptable) io  min 0x278 max 0x278 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 3 (acceptable) io  min 0x678 max 0x678 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 4 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 4 (acceptable) irq 3 4 5 7 flags 0x1
pnp 00:0e:   dependent set 4 (acceptable) io  min 0x3bc max 0x3bc align 4 size 4 flags 0x1
pnp 00:0e:   dependent set 4 (acceptable) io  min 0x7bc max 0x7bc align 4 size 4 flags 0x1
pnp 00:0e:   dependent set 5 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0e:   dependent set 5 (acceptable) irq 3 4 5 7 flags 0x1
pnp 00:0e:   dependent set 5 (acceptable) io  min 0x3bc max 0x3bc align 4 size 4 flags 0x1
pnp 00:0e:   dependent set 5 (acceptable) io  min 0x7bc max 0x7bc align 4 size 4 flags 0x1
pnp 00:0e:   dependent set 6 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 6 (acceptable) irq <none> flags 0x1
pnp 00:0e:   dependent set 6 (acceptable) io  min 0x378 max 0x378 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 6 (acceptable) io  min 0x778 max 0x778 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 7 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 7 (acceptable) irq <none> flags 0x1
pnp 00:0e:   dependent set 7 (acceptable) io  min 0x278 max 0x278 align 8 size 8 flags 0x1
pnp 00:0e:   dependent set 7 (acceptable) io  min 0x678 max 0x678 align 8 size 4 flags 0x1
pnp 00:0e:   dependent set 8 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0e:   dependent set 8 (acceptable) irq <none> flags 0x1
pnp 00:0e:   dependent set 8 (acceptable) io  min 0x3bc max 0x3bc align 4 size 4 flags 0x1
pnp 00:0e:   dependent set 8 (acceptable) io  min 0x7bc max 0x7bc align 4 size 4 flags 0x1
pnp 00:0e: Plug and Play BIOS device, IDs PNP0401 (active)
pnp 00:0f: parse allocated resources
pnp 00:0f:   add io  0x530-0x537 flags 0x0
pnp 00:0f:   add io  0x388-0x38b flags 0x0
pnp 00:0f:   add io  0x220-0x22f flags 0x0
pnp 00:0f:   add irq 5 flags 0x0
pnp 00:0f:   add dma 1 flags 0x0
pnp 00:0f:   add dma 0 flags 0x0
pnp 00:0f: parse resource options
pnp 00:0f:   dependent set 0 (acceptable) io  min 0x530 max 0x530 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 0 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 0 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 0 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 0 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 0 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 1 (acceptable) io  min 0x604 max 0x604 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 1 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 1 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 1 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 2 (acceptable) io  min 0xe80 max 0xe80 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 2 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 2 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 2 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 3 (acceptable) io  min 0xf40 max 0xf40 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 3 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 3 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 3 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 4 (acceptable) io  min 0x530 max 0x530 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 4 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 4 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 4 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 4 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 4 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0f:   dependent set 5 (acceptable) io  min 0x604 max 0x604 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 5 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 5 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 5 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 5 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 5 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0f:   dependent set 6 (acceptable) io  min 0xe80 max 0xe80 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 6 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 6 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 6 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 6 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 6 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0f:   dependent set 7 (acceptable) io  min 0xf40 max 0xf40 align 4 size 8 flags 0x1
pnp 00:0f:   dependent set 7 (acceptable) io  min 0x388 max 0x3b8 align 16 size 4 flags 0x1
pnp 00:0f:   dependent set 7 (acceptable) io  min 0x220 max 0x280 align 32 size 16 flags 0x1
pnp 00:0f:   dependent set 7 (acceptable) irq 5 7 9 10 11 15 flags 0x1
pnp 00:0f:   dependent set 7 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x8
pnp 00:0f:   dependent set 7 (acceptable) dma <none> (bitmask 0x0) flags 0x8
pnp 00:0f: Plug and Play BIOS device, IDs CSC0000 (active)
pnp 00:10: parse allocated resources
pnp 00:10:   add io  0x210-0x217 flags 0x0
pnp 00:10: parse resource options
pnp 00:10:   dependent set 0 (acceptable) io  min 0x210 max 0x210 align 16 size 8 flags 0x1
pnp 00:10:   dependent set 1 (acceptable) io  min 0x340 max 0x340 align 16 size 8 flags 0x1
pnp 00:10:   dependent set 2 (acceptable) io  min 0x540 max 0x540 align 16 size 8 flags 0x1
pnp 00:10:   dependent set 3 (acceptable) io  min 0x120 max 0x120 align 16 size 8 flags 0x1
pnp 00:10: Plug and Play BIOS device, IDs CSC0010 (active)
pnp 00:11: parse allocated resources
pnp 00:11:   add irq 6 flags 0x0
pnp 00:11:   add io  0x3f2-0x3f5 flags 0x0
pnp 00:11:   add io  0x3f7-0x3f7 flags 0x0
pnp 00:11:   add dma 2 flags 0x0
pnp 00:11: parse resource options
pnp 00:11: Plug and Play BIOS device, IDs PNP0700 (active)
PnPBIOS: 18 nodes reported by PnP BIOS; 18 recorded by driver
system 00:01: ioport range 0x800-0x83f has been reserved
system 00:01: ioport range 0x840-0x84f has been reserved
system 00:01: ioport range 0x3f0-0x3f1 has been reserved
system 00:01: iomem range 0x0-0x9ffff could not be reserved
system 00:01: iomem range 0x100000-0x1ffffff could not be reserved
system 00:01: iomem range 0xf0000-0xfffff could not be reserved
system 00:01: iomem range 0xfffe0000-0xffffffff has been reserved
system 00:02: ioport range 0xfc00-0xfcfe has been reserved
pci 0000:00:03.0: CardBus bridge, secondary bus 0000:01
pci 0000:00:03.0:   IO window: 0x001000-0x0010ff
pci 0000:00:03.0:   IO window: 0x001400-0x0014ff
pci 0000:00:03.0:   PREFETCH window: 0x10000000-0x13ffffff
pci 0000:00:03.0:   MEM window: 0x14000000-0x17ffffff
pci 0000:00:03.1: CardBus bridge, secondary bus 0000:05
pci 0000:00:03.1:   IO window: 0x001800-0x0018ff
pci 0000:00:03.1:   IO window: 0x001c00-0x001cff
pci 0000:00:03.1:   PREFETCH window: 0x18000000-0x1bffffff
pci 0000:00:03.1:   MEM window: 0x1c000000-0x1fffffff
PCI: setting IRQ 11 as level-triggered
pci 0000:00:03.0: found PCI INT A -> IRQ 11
pci 0000:00:03.0: sharing IRQ 11 with 0000:00:01.2
pci 0000:00:03.0: sharing IRQ 11 with 0000:00:03.1
pci 0000:00:03.1: found PCI INT B -> IRQ 11
pci 0000:00:03.1: sharing IRQ 11 with 0000:00:01.2
pci 0000:00:03.1: sharing IRQ 11 with 0000:00:03.0
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0x1000-0x10ff]
bus: 01 index 1 io port: [0x1400-0x14ff]
bus: 01 index 2 mmio: [0x10000000-0x13ffffff]
bus: 01 index 3 mmio: [0x14000000-0x17ffffff]
bus: 05 index 0 io port: [0x1800-0x18ff]
bus: 05 index 1 io port: [0x1c00-0x1cff]
bus: 05 index 2 mmio: [0x18000000-0x1bffffff]
bus: 05 index 3 mmio: [0x1c000000-0x1fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
NET: Registered protocol family 1
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
msgmni has been set to 56
io scheduler noop registered
io scheduler anticipatory registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:02.0: Boot video device
PCI: setting IRQ 9 as level-triggered
neofb 0000:00:02.0: found PCI INT A -> IRQ 9
neofb: mapped io at c2800000
Autodetected internal display
Panel is a 800x600 color TFT display
neofb: mapped framebuffer at c2a80000
neofb v0.4.2: 2048kB VRAM, using 800x600, 37.878kHz, 60Hz
Console: switching to colour frame buffer device 100x37
fb0: MagicGraph 128X frame buffer device
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
loop: module loaded
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:01.1: version 2.12
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata1.00: ATA-3: IBM-DTNA-22160, A50GF0, max MWDMA2
ata1.00: 4233600 sectors, multi 8: LBA 
ata1.00: configured for MWDMA2
ata1.00: configured for MWDMA2
ata1: EH complete
ata2.00: ATAPI: CD-ROM  CDR_U200, 1.09, max MWDMA1, CDB intr
ata2.00: configured for MWDMA1
scsi 0:0:0:0: Direct-Access     ATA      IBM-DTNA-22160   A50G PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 4233600 512-byte hardware sectors: (2.16 GB/2.01 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 4233600 512-byte hardware sectors: (2.16 GB/2.01 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            TORiSAN  CD-ROM CDR_U200  1.09 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 16x/16x xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
yenta_cardbus 0000:00:03.0: CardBus bridge found [1028:0075]
yenta_cardbus 0000:00:03.0: ISA IRQ mask 0x0418, PCI irq 11
yenta_cardbus 0000:00:03.0: Socket status: 30000010
yenta_cardbus 0000:00:03.1: CardBus bridge found [1028:0075]
yenta_cardbus 0000:00:03.1: ISA IRQ mask 0x0418, PCI irq 11
yenta_cardbus 0000:00:03.1: Socket status: 30000006
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:01.2: found PCI INT D -> IRQ 11
uhci_hcd 0000:00:01.2: sharing IRQ 11 with 0000:00:03.0
uhci_hcd 0000:00:01.2: sharing IRQ 11 with 0000:00:03.1
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:01.2: irq 11, io base 0x0000ece0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28mmx uhci_hcd
usb usb1: SerialNumber: 0000:00:01.2
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 242 bytes nvram
i2c /dev entries driver
piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x840, revision 0
cpuidle: using governor ladder
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
ALSA device list:
  No soundcards found.
TCP cubic registered
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
  Magic number: 9:38:796
rtc_cmos 00:09: setting system clock to 2009-01-27 17:46:29 UTC (1233078389)
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input1
pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 184k freed
Adding 76600k swap on /dev/sda3.  Priority:-1 extents:1 across:76600k
parport_pc 00:0e: reported by Plug and Play BIOS
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcff: clean.
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
CS4231: VERSION (I25) = 0x3
CS4231: ext version; rev = 0xe8, id = 0xe8
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x800-0x80f: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x800-0x80f: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
CS4236: [0x210] C1 (version) = 0xe8, ext = 0xe8
pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: excluding 0x290-0x297
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: excluding 0x290-0x297
pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
ata1: soft resetting link
ata1.00: configured for MWDMA2
ata1.00: configured for MWDMA2
ata1: EH complete
sd 0:0:0:0: [sda] 4233600 512-byte hardware sectors: (2.16 GB/2.01 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 4233600 512-byte hardware sectors: (2.16 GB/2.01 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata2: soft resetting link
ata2.00: configured for MWDMA1
ata2: EH complete
lm75 0-0048: hwmon0: sensor 'lm75'
usb 1-1: new full speed USB device using uhci_hcd and address 2
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: New USB device found, idVendor=058f, idProduct=6362
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: Mass Storage Device
usb 1-1: Manufacturer: Generic
usb 1-1: SerialNumber: 058F312D81B
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 2:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
sd 2:0:0:0: [sdb] 3870720 512-byte hardware sectors: (1.98 GB/1.84 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 3870720 512-byte hardware sectors: (1.98 GB/1.84 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
scsi 2:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
sd 2:0:0:1: [sdc] Attached SCSI removable disk
scsi 2:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
sd 2:0:0:2: [sdd] Attached SCSI removable disk
scsi 2:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
sd 2:0:0:3: [sde] Attached SCSI removable disk
usb-storage: device scan complete

pnp.log
/sys/bus/pnp/devices/00:00/id:PNP0a03
/sys/bus/pnp/devices/00:00/resources:state = active
/sys/bus/pnp/devices/00:00/resources:io 0xcf8-0xcff
/sys/bus/pnp/devices/00:01/id:PNP0c01
/sys/bus/pnp/devices/00:01/resources:state = active
/sys/bus/pnp/devices/00:01/resources:mem 0x0-0x9ffff
/sys/bus/pnp/devices/00:01/resources:mem 0x100000-0x1ffffff
/sys/bus/pnp/devices/00:01/resources:mem 0xf0000-0xfffff
/sys/bus/pnp/devices/00:01/resources:mem 0xfffe0000-0xffffffff
/sys/bus/pnp/devices/00:01/resources:io 0x800-0x83f
/sys/bus/pnp/devices/00:01/resources:io 0x840-0x84f
/sys/bus/pnp/devices/00:01/resources:io 0x3f0-0x3f1
/sys/bus/pnp/devices/00:01/resources:io 0xe0-0xe1
/sys/bus/pnp/devices/00:01/uevent:DRIVER=system
/sys/bus/pnp/devices/00:02/id:PNP0c01
/sys/bus/pnp/devices/00:02/resources:state = active
/sys/bus/pnp/devices/00:02/resources:io 0xfc00-0xfcfe
/sys/bus/pnp/devices/00:02/uevent:DRIVER=system
/sys/bus/pnp/devices/00:03/id:PNP0000
/sys/bus/pnp/devices/00:03/resources:state = active
/sys/bus/pnp/devices/00:03/resources:irq 2
/sys/bus/pnp/devices/00:03/resources:io 0x20-0x3f
/sys/bus/pnp/devices/00:03/resources:io 0xa0-0xbf
/sys/bus/pnp/devices/00:03/resources:io 0x4d0-0x4d1
/sys/bus/pnp/devices/00:04/id:PNP0100
/sys/bus/pnp/devices/00:04/resources:state = active
/sys/bus/pnp/devices/00:04/resources:irq 0
/sys/bus/pnp/devices/00:04/resources:io 0x40-0x5f
/sys/bus/pnp/devices/00:05/id:PNP0200
/sys/bus/pnp/devices/00:05/resources:state = active
/sys/bus/pnp/devices/00:05/resources:io 0x80-0x9f
/sys/bus/pnp/devices/00:05/resources:io 0x0-0x1f
/sys/bus/pnp/devices/00:05/resources:io 0xc0-0xdf
/sys/bus/pnp/devices/00:05/resources:dma 4
/sys/bus/pnp/devices/00:06/id:PNP0303
/sys/bus/pnp/devices/00:06/resources:state = active
/sys/bus/pnp/devices/00:06/resources:irq 1
/sys/bus/pnp/devices/00:06/resources:io 0x60-0x60
/sys/bus/pnp/devices/00:06/resources:io 0x64-0x64
/sys/bus/pnp/devices/00:06/uevent:DRIVER=i8042 kbd
/sys/bus/pnp/devices/00:07/id:PNP0f13
/sys/bus/pnp/devices/00:07/resources:state = active
/sys/bus/pnp/devices/00:07/resources:irq 12
/sys/bus/pnp/devices/00:07/uevent:DRIVER=i8042 aux
/sys/bus/pnp/devices/00:08/id:PNP0800
/sys/bus/pnp/devices/00:08/resources:state = active
/sys/bus/pnp/devices/00:08/resources:io 0x61-0x61
/sys/bus/pnp/devices/00:09/id:PNP0b00
Binary file /sys/bus/pnp/devices/00:09/nvram matches
/sys/bus/pnp/devices/00:09/resources:state = active
/sys/bus/pnp/devices/00:09/resources:irq 8
/sys/bus/pnp/devices/00:09/resources:io 0x70-0x7f
/sys/bus/pnp/devices/00:09/uevent:DRIVER=rtc_cmos
/sys/bus/pnp/devices/00:0a/id:PNP0c04
/sys/bus/pnp/devices/00:0a/resources:state = active
/sys/bus/pnp/devices/00:0a/resources:irq 13
/sys/bus/pnp/devices/00:0a/resources:io 0xf0-0xff
/sys/bus/pnp/devices/00:0b/id:PNP0e03
/sys/bus/pnp/devices/00:0b/id:PNP0e00
/sys/bus/pnp/devices/00:0b/options:irq 2/9 High-Edge
/sys/bus/pnp/devices/00:0b/options:port 0x3e0-0x3e0, align 0x0, size 0x2, 16-bit address decoding
/sys/bus/pnp/devices/00:0b/resources:state = active
/sys/bus/pnp/devices/00:0b/resources:irq 11
/sys/bus/pnp/devices/00:0b/resources:io 0x3e0-0x3e1
/sys/bus/pnp/devices/00:0c/id:PNP0501
/sys/bus/pnp/devices/00:0c/options:Dependent: 00 - Priority acceptable
/sys/bus/pnp/devices/00:0c/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0c/options:  port 0x3f8-0x3f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0c/options:Dependent: 01 - Priority acceptable
/sys/bus/pnp/devices/00:0c/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0c/options:  port 0x2f8-0x2f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0c/options:Dependent: 02 - Priority acceptable
/sys/bus/pnp/devices/00:0c/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0c/options:  port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0c/options:Dependent: 03 - Priority acceptable
/sys/bus/pnp/devices/00:0c/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0c/options:  port 0x2e8-0x2e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0c/resources:state = active
/sys/bus/pnp/devices/00:0c/resources:irq 4
/sys/bus/pnp/devices/00:0c/resources:io 0x3f8-0x3ff
/sys/bus/pnp/devices/00:0c/uevent:DRIVER=serial
/sys/bus/pnp/devices/00:0d/id:SMCf010
/sys/bus/pnp/devices/00:0d/id:PNP0510
/sys/bus/pnp/devices/00:0d/options:Dependent: 00 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x3f8-0x3f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 01 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x2f8-0x2f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 02 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 03 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x2e8-0x2e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 04 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x3f8-0x3f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 05 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x2f8-0x2f8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 06 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 07 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x2e8-0x2e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x270-0x400, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/options:Dependent: 08 - Priority acceptable
/sys/bus/pnp/devices/00:0d/options:  irq 3,4,6,12 High-Edge
/sys/bus/pnp/devices/00:0d/options:  port 0x3e8-0x3e8, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  port 0x0-0x0, align 0x7, size 0x0, 16-bit address decoding
/sys/bus/pnp/devices/00:0d/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0d/resources:state = active
/sys/bus/pnp/devices/00:0d/resources:irq 4
/sys/bus/pnp/devices/00:0d/resources:io 0x3e8-0x3ef
/sys/bus/pnp/devices/00:0d/resources:io 0x290-0x297
/sys/bus/pnp/devices/00:0d/resources:dma 3
/sys/bus/pnp/devices/00:0e/id:PNP0401
/sys/bus/pnp/devices/00:0e/options:Dependent: 00 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 3,4,5,7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x378-0x378, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x778-0x778, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 01 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x378-0x378, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x778-0x778, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 02 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 3,4,5,7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x278-0x278, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x678-0x678, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 03 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 3,4,5,7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x278-0x278, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x678-0x678, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 04 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 3,4,5,7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x3bc-0x3bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x7bc-0x7bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 05 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq 3,4,5,7 High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x3bc-0x3bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x7bc-0x7bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 06 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq <none> High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x378-0x378, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x778-0x778, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 07 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq <none> High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x278-0x278, align 0x7, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x678-0x678, align 0x7, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:Dependent: 08 - Priority acceptable
/sys/bus/pnp/devices/00:0e/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0e/options:  irq <none> High-Edge
/sys/bus/pnp/devices/00:0e/options:  port 0x3bc-0x3bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/options:  port 0x7bc-0x7bc, align 0x3, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0e/resources:state = active
/sys/bus/pnp/devices/00:0e/resources:dma disabled
/sys/bus/pnp/devices/00:0e/resources:irq 7
/sys/bus/pnp/devices/00:0e/resources:io 0x378-0x37f
/sys/bus/pnp/devices/00:0e/resources:io 0x778-0x77b
/sys/bus/pnp/devices/00:0e/uevent:DRIVER=parport_pc
/sys/bus/pnp/devices/00:0f/id:CSC0000
/sys/bus/pnp/devices/00:0f/options:Dependent: 00 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0x530-0x530, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 01 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0x604-0x604, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 02 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0xe80-0xe80, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 03 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0xf40-0xf40, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 04 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0x530-0x530, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 05 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0x604-0x604, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 06 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0xe80-0xe80, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:Dependent: 07 - Priority acceptable
/sys/bus/pnp/devices/00:0f/options:  port 0xf40-0xf40, align 0x3, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x388-0x3b8, align 0xf, size 0x4, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  port 0x220-0x280, align 0x1f, size 0x10, 16-bit address decoding
/sys/bus/pnp/devices/00:0f/options:  irq 5,7,2/9,10,11,15 High-Edge
/sys/bus/pnp/devices/00:0f/options:  dma 0,1,3 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/options:  dma <none> 8-bit byte-count compatible
/sys/bus/pnp/devices/00:0f/resources:state = active
/sys/bus/pnp/devices/00:0f/resources:io 0x530-0x537
/sys/bus/pnp/devices/00:0f/resources:io 0x388-0x38b
/sys/bus/pnp/devices/00:0f/resources:io 0x220-0x22f
/sys/bus/pnp/devices/00:0f/resources:irq 5
/sys/bus/pnp/devices/00:0f/resources:dma 1
/sys/bus/pnp/devices/00:0f/resources:dma 0
/sys/bus/pnp/devices/00:0f/uevent:DRIVER=cs4232-pnpbios
/sys/bus/pnp/devices/00:10/id:CSC0010
/sys/bus/pnp/devices/00:10/options:Dependent: 00 - Priority acceptable
/sys/bus/pnp/devices/00:10/options:  port 0x210-0x210, align 0xf, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:10/options:Dependent: 01 - Priority acceptable
/sys/bus/pnp/devices/00:10/options:  port 0x340-0x340, align 0xf, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:10/options:Dependent: 02 - Priority acceptable
/sys/bus/pnp/devices/00:10/options:  port 0x540-0x540, align 0xf, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:10/options:Dependent: 03 - Priority acceptable
/sys/bus/pnp/devices/00:10/options:  port 0x120-0x120, align 0xf, size 0x8, 16-bit address decoding
/sys/bus/pnp/devices/00:10/resources:state = active
/sys/bus/pnp/devices/00:10/resources:io 0x210-0x217
/sys/bus/pnp/devices/00:11/id:PNP0700
/sys/bus/pnp/devices/00:11/resources:state = active
/sys/bus/pnp/devices/00:11/resources:irq 6
/sys/bus/pnp/devices/00:11/resources:io 0x3f2-0x3f5
/sys/bus/pnp/devices/00:11/resources:io 0x3f7-0x3f7
/sys/bus/pnp/devices/00:11/resources:dma 2

