Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYHKU2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYHKU2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYHKU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:28:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58806 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbYHKU2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:28:36 -0400
Date: Mon, 11 Aug 2008 22:27:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Message-ID: <20080811202731.GB2916@elte.hu>
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> A have problem with booting 2.6.26* and 2.6.27-rc* kernels. Very often
> booting stops on this message:
> 
> [...]
> Uniform Multi-Platform E-IDE driver
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> ICH7: not 100% native mode: will probe irqs later
> ICH7: IDE port disabled
>     ide0: BM-DMA at 0x60a0-0x60a7
> 
> afer should be:
> hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: MWDMA2 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [...]
> 
> Initially I was think, that is hardware problem. But XP and 2.6.25.8 
> work with _no_ problem (booting from xp, linux, knoppix, linux 
> firmware development kit - about 50 reboots).

> http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26.2.txt
> dmesg: http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.25.8.txt

i had a look at diff -up dmesg-2.6.25.8.txt dmesg-2.6.26.2.txt, and 
these changes stood out:

  ACPI: bus type pci registered
 -PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
 +PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
  PCI: Not using MMCONFIG.

  ACPI: Using IOAPIC for interrupt routing
 +PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
 +PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
 +PCI: Using MMCONFIG for extended config space
  ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62

    IO window: 0x00007400-0x000074ff
 -  PREFETCH window: 0x60000000-0x63ffffff
 -  MEM window: 0x64000000-0x67ffffff
 +  MEM window: 0x60000000-0x63ffffff
  PCI: Bridge: 0000:00:1e.0
    IO window: 7000-7fff
    MEM window: 0xe8100000-0xe83fffff
 -  PREFETCH window: 0x0000000060000000-0x0000000063ffffff
 +  PREFETCH window: disabled.

so a quirk that triggered previously does not seem to trigger anymore.

find below some of the other deltas. I edited out the dmesg deltas that 
i considered non-interesting - this should make it shorter/easier for 
others to review the changes.

	Ingo

--- dmesg-2.6.25.8.txt	2008-08-10 21:49:49.000000000 +0200
+++ dmesg-2.6.26.2.txt	2008-08-10 21:49:50.000000000 +0200
@@ -112,13 +111,14 @@ CPU: Processor Core ID: 0
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#0.
 using mwait in idle threads.
-Compat vDSO mapped to ffffe000.
 Checking 'hlt' instruction... OK.
-ACPI: Core revision 20070126
+ACPI: Core revision 20080321
+ENABLING IO-APIC IRQs
+..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
@@ -126,32 +126,33 @@ CPU: Processor Core ID: 1
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#1.
 CPU1: Intel Genuine Intel(R) CPU           T2050  @ 1.60GHz stepping 08
-Total of 2 processors activated (6387.08 BogoMIPS).
-ENABLING IO-APIC IRQs
-..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
 No dock devices found.
 ACPI: bus type pci registered
-PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
+PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
 PCI: Not using MMCONFIG.
 PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
-PCI: Using configuration type 1
+PCI: Using configuration type 1 for base access
 Setting up standard PCI resources
 ACPI: EC: Look up EC in DSDT
 ACPI: EC: non-query interrupt received, switching to interrupt mode
 ACPI: Interpreter enabled
 ACPI: (supports S0 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
+PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
+PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
+PCI: Using MMCONFIG for extended config space
 ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
 ACPI: EC: driver started in interrupt mode
 ACPI: PCI Root Bridge [C002] (0000:00)
@@ -170,14 +171,13 @@ ACPI: PCI Interrupt Link [C111] (IRQs *1
 ACPI: PCI Interrupt Link [C12A] (IRQs *10 11)
 ACPI: PCI Interrupt Link [C12B] (IRQs 10 *11)
 ACPI: PCI Interrupt Link [C12C] (IRQs 10 11) *0, disabled.
-ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
+ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20080321]
 ACPI: Power Resource [C21A] (on)
 ACPI: Power Resource [C222] (off)
 ACPI: Power Resource [C321] (off)
 ACPI: Power Resource [C322] (off)
 ACPI: Power Resource [C323] (off)
 ACPI: Power Resource [C324] (off)
-ACPI: WMI: Mapper loaded
 Linux Plug and Play Support v0.97 (c) Adam Belay
 pnp: PnP ACPI init
 ACPI: bus type pnp registered
@@ -186,7 +186,6 @@ ACPI: ACPI bus type pnp unregistered
 SCSI subsystem initialized
 libata version 3.00 loaded.
 PCI: Using ACPI for IRQ routing
-PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
 hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
 hpet0: 3 64-bit timers, 14318180 Hz
 ACPI: RTC can wake from S4
@@ -208,6 +207,7 @@ system 00:0a: iomem range 0xfed45000-0xf
 system 00:0a: iomem range 0xfed90000-0xfed9afff could not be reserved
 system 00:0b: iomem range 0xfeda0000-0xfedbffff could not be reserved
 system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
+PCI: region 0000:02:06.0/9 too large: 0x0000000000000000-0x0000000003ffffff
 PCI: Bridge: 0000:00:1c.0
   IO window: disabled.
   MEM window: 0xe8000000-0xe80fffff
@@ -223,12 +223,11 @@ PCI: Bridge: 0000:00:1c.3
 PCI: Bus 3, cardbus bridge: 0000:02:06.0
   IO window: 0x00007000-0x000070ff
   IO window: 0x00007400-0x000074ff
-  PREFETCH window: 0x60000000-0x63ffffff
-  MEM window: 0x64000000-0x67ffffff
+  MEM window: 0x60000000-0x63ffffff
 PCI: Bridge: 0000:00:1e.0
   IO window: 7000-7fff
   MEM window: 0xe8100000-0xe83fffff
-  PREFETCH window: 0x0000000060000000-0x0000000063ffffff
+  PREFETCH window: disabled.
 ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
 PCI: Setting latency timer of device 0000:00:1c.0 to 64
 ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
@@ -243,9 +242,11 @@ TCP established hash table entries: 1310
 TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
 TCP: Hash tables configured (established 131072 bind 65536)
 TCP reno registered
+NET: Registered protocol family 1
 audit: initializing netlink socket (disabled)
-type=2000 audit(1218404726.442:1): initialized
+type=2000 audit(1218404863.342:1): initialized
 highmem bounce pool size: 64 pages
+msgmni has been set to 1757
 io scheduler noop registered
 io scheduler anticipatory registered
 io scheduler deadline registered
@@ -255,21 +256,22 @@ PCI: Setting latency timer of device 000
 assign_interrupt_mode Found MSI capability
 Allocate Port Service[0000:00:1c.0:pcie00]
 Allocate Port Service[0000:00:1c.0:pcie02]
+Allocate Port Service[0000:00:1c.0:pcie03]
 PCI: Setting latency timer of device 0000:00:1c.2 to 64
 assign_interrupt_mode Found MSI capability
 Allocate Port Service[0000:00:1c.2:pcie00]
 Allocate Port Service[0000:00:1c.2:pcie02]
+Allocate Port Service[0000:00:1c.2:pcie03]
 PCI: Setting latency timer of device 0000:00:1c.3 to 64
 assign_interrupt_mode Found MSI capability
 Allocate Port Service[0000:00:1c.3:pcie00]
 Allocate Port Service[0000:00:1c.3:pcie02]
+Allocate Port Service[0000:00:1c.3:pcie03]
 vesafb: framebuffer at 0xd0000000, mapped to 0xf8880000, using 6144k, total 7872k
 vesafb: mode is 1024x768x32, linelength=4096, pages=1
 vesafb: scrolling: redraw
 vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
 Console: switching to colour frame buffer device 128x48
@@ -297,21 +301,8 @@ hpet_resources: 0xfed00000 is busy
 intel_rng: FWH not detected
 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
 brd: module loaded
-Uniform Multi-Platform E-IDE driver
-ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
-ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
-ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
-ICH7: not 100% native mode: will probe irqs later
-ICH7: IDE port disabled
-    ide0: BM-DMA at 0x60a0-0x60a7, BIOS settings: hda:DMA, hdb:PIO
-Probing IDE interface ide0...
-hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
-hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
-hda: MWDMA2 mode selected
-ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
-hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
-Uniform CD-ROM driver Revision: 3.20
 Driver 'sd' needs updating - please use bus_type methods
+Driver 'sr' needs updating - please use bus_type methods
 ahci 0000:00:1f.2: version 3.0
 ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
@@ -329,13 +320,13 @@ ata1: SATA link up 1.5 Gbps (SStatus 113
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
-ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
+ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
 ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
 ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
 ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
 ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
-ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
+ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
 ata1.00: configured for UDMA/133
 ata1.00: configured for UDMA/133
 ata1: EH complete
@@ -350,6 +341,20 @@ sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 0
 sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
 sd 0:0:0:0: [sda] Attached SCSI disk
+ata_piix 0000:00:1f.1: version 2.12
+ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
+PCI: Setting latency timer of device 0000:00:1f.1 to 64
+scsi4 : ata_piix
+scsi5 : ata_piix
+ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
+ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
+ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
+ata5.00: configured for MWDMA2
+ata6: port disabled. ignoring.
+scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  1.11 PQ: 0 ANSI: 5
+sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
+Uniform CD-ROM driver Revision: 3.20
+sr 4:0:0:0: Attached scsi CD-ROM sr0
 PNP: PS/2 Controller [PNP0303:C217,PNP0f13:C218] at 0x60,0x64 irq 1,12
 i8042.c: Detected active multiplexing controller, rev 1.1.
 serio: i8042 KBD port at 0x60,0x64 irq 1
