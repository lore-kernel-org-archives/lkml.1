Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYITXtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYITXtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYITXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:49:16 -0400
Received: from hpsmtp-eml16.kpnxchange.com ([213.75.38.116]:49639 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbYITXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:49:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Sun, 21 Sep 2008 01:49:05 +0200
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200809091250.08620.elendil@planet.nl> <48C6C0ED.2000409@keyaccess.nl> <200809172310.01580.bjorn.helgaas@hp.com>
In-Reply-To: <200809172310.01580.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zvY1IX1R1NLfeJX"
Message-Id: <200809210149.07755.elendil@planet.nl>
X-OriginalArrivalTime: 20 Sep 2008 23:49:10.0113 (UTC) FILETIME=[7A27DD10:01C91B7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zvY1IX1R1NLfeJX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 18 September 2008, Bjorn Helgaas wrote:
> On Tuesday 09 September 2008 12:31:09 pm Rene Herman wrote:
> > On 09-09-08 19:40, Bjorn Helgaas wrote:
> > > If the PCI device isn't fully initialized, it doesn't seem right to
> > > check it for resource conflicts.  But I don't know how to tell
> > > that.
> >
> > His pci_resource_start() values are 0. How about just checking for
> > that?
>
> Frans, can you test Rene's patch?  I think it will solve the problem
> you're seeing, and if so, we should put it in for 2.6.27.  But I'd like
> to have your "Tested-by" first.

Tested against current git (v2.6.27-rc6-158-g9824b8f) and looks good.
Attached the patch with Rene's Signed-off and my Tested-by for 
convenience.

I had not tested earlier as you said you wanted to better understand the 
cause first. Did you get anything more about why things happen as they do 
from the info I sent?

Attached also a dmesg diff for boots with the two different BIOS settings 
with this kernel (with Rene's patch having filtered out the "io resource 
overlap" messages).
It still clearly shows the difference in how some devices get enabled and 
how their resources get assigned.

Cheers,
FJP


--Boundary-00=_zvY1IX1R1NLfeJX
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="quirk_system_pci_resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="quirk_system_pci_resources.diff"

From: Rene Herman <rene.herman@gmail.com>

PNP: avoid checking unitialized BARs for conflicts
    
Avoid checking a PCI BAR for conflicts if the BIOS left it unitialized.
    
Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Rene Herman <rene.herman@gmail.com>
Tested-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..d0120a5 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -253,6 +253,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				continue;
 
 			pci_start = pci_resource_start(pdev, i);
+			if (!pci_start)
+				continue;
+
 			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
 			     (res = pnp_get_resource(dev, type, j)); j++) {

--Boundary-00=_zvY1IX1R1NLfeJX
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="dmesg.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg.diff"

--- rc6_setup-by-os.dmesg	2008-09-21 01:12:27.000000000 +0200
+++ rc6_all-devices.dmesg	2008-09-21 01:28:00.000000000 +0200
@@ -1,472 +1,466 @@
 Linux version 2.6.27-rc6 (root@faramir) (gcc version 4.3.2 (Debian 4.3.2-1) ) #12 SMP Sun Sep 21 01:04:33 CEST 2008
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000001ef40000 (usable)
  BIOS-e820: 000000001ef40000 - 000000001ef50000 (ACPI data)
  BIOS-e820: 000000001ef50000 - 000000001f000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
  BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
  BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
 PAT support disabled.
 last_pfn = 0x1ef40 max_arch_pfn = 0x100000
 kernel direct mapping tables up to 1ef40000 @ 7000-d000
 RAMDISK: 1ebb2000 - 1ef2faad
 DMI 2.3 present.
 ACPI: RSDP 000F0180, 0014 (r0 TOSHIB)
-ACPI: RSDT 1EF40000, 0038 (r1 TOSHIB 750        970814 TASM  4010000)
+ACPI: RSDT 1EF40000, 0034 (r1 TOSHIB 750        970814 TASM  4010000)
 ACPI: FACP 1EF40060, 0084 (r2 TOSHIB 750      20030101 TASM  4010000)
 ACPI: DSDT 1EF40558, 4B72 (r1 TOSHIB A000C    20031216 MSFT  100000E)
 ACPI: FACS 000EEE00, 0040
 ACPI: SSDT 1EF402CA, 0082 (r1 TOSHIB A000C    20030917 MSFT  100000E)
 ACPI: DBGP 1EF400E4, 0034 (r1 TOSHIB 750        970814 TASM  4010000)
-ACPI: BOOT 1EF40038, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
 ACPI: APIC 1EF40118, 0062 (r1 TOSHIB 750        970814 TASM  4010000)
 ACPI: DMI detected: Toshiba
 0MB HIGHMEM available.
 495MB LOWMEM available.
   mapped low ram: 0 - 1ef40000
   low ram: 00000000 - 1ef40000
   bootmap 00002000 - 00005de8
 (9 early reservations) ==> bootmem [0000000000 - 001ef40000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
   #3 [0000100000 - 00004561fc]    TEXT DATA BSS ==> [0000100000 - 00004561fc]
   #4 [001ebb2000 - 001ef2faad]          RAMDISK ==> [001ebb2000 - 001ef2faad]
   #5 [0000457000 - 000045a000]    INIT_PG_TABLE ==> [0000457000 - 000045a000]
   #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
   #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
   #8 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
 Zone PFN ranges:
   DMA      0x00000000 -> 0x00001000
   Normal   0x00001000 -> 0x0001ef40
   HighMem  0x0001ef40 -> 0x0001ef40
 Movable zone start PFN for each node
 early_node_map[2] active PFN ranges
     0: 0x00000000 -> 0x0000009f
     0: 0x00000100 -> 0x0001ef40
 On node 0 totalpages: 126687
 free_area_init_node: node 0, pgdat c0399200, node_mem_map c1000000
   DMA zone: 3967 pages, LIFO batch:0
   Normal zone: 121729 pages, LIFO batch:31
 ACPI: PM-Timer IO Port: 0xd808
 ACPI: Local APIC address 0xfee00000
 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
 ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
 ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 ACPI: IRQ0 used by override.
 ACPI: IRQ2 used by override.
 ACPI: IRQ9 used by override.
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 Using ACPI (MADT) for SMP configuration information
 SMP: Allowing 2 CPUs, 1 hotplug CPUs
 mapped APIC to ffffb000 (fee00000)
 mapped IOAPIC to ffffa000 (fec00000)
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
 PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
 PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
 PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
 Allocating PCI resources starting at 20000000 (gap: 1f000000:dfc00000)
 PERCPU: Allocating 36828 bytes of per cpu data
 NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 125696
 Kernel command line: root=/dev/mapper/strider-root nopat ro vga=791 quiet
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 2048 (order: 11, 8192 bytes)
 TSC: PIT calibration confirmed by PMTIMER.
 TSC: using PMTIMER calibration value
-Detected 2792.987 MHz processor.
+Detected 2792.990 MHz processor.
 Console: colour dummy device 80x25
 console [tty0] enabled
 Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
 Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
 Memory: 495084k/507136k available (1765k kernel code, 11492k reserved, 955k data, 232k init, 0k highmem)
 virtual kernel memory layout:
     fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xdf800000 - 0xff7fe000   ( 511 MB)
     lowmem  : 0xc0000000 - 0xdef40000   ( 495 MB)
       .init : 0xc03b1000 - 0xc03eb000   ( 232 kB)
       .data : 0xc02b94a2 - 0xc03a8208   ( 955 kB)
       .text : 0xc0100000 - 0xc02b94a2   (1765 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
 CPA: page pool initialized 1 of 1 pages preallocated
-Calibrating delay loop (skipped), value calculated using timer frequency.. 5585.97 BogoMIPS (lpj=11171948)
+Calibrating delay loop (skipped), value calculated using timer frequency.. 5585.98 BogoMIPS (lpj=11171960)
 Security Framework initialized
 SELinux:  Disabled at boot.
 Mount-cache hash table entries: 512
 CPU: Trace cache: 12K uops, L1 D cache: 8K
 CPU: L2 cache: 512K
 CPU: Hyper-Threading is disabled
 Intel machine check architecture supported.
 Intel machine check reporting enabled on CPU#0.
 CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
 CPU0: Thermal monitoring enabled
 Checking 'hlt' instruction... OK.
 ACPI: Core revision 20080609
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
 CPU0: Intel Mobile Intel(R) Pentium(R) 4     CPU 2.80GHz stepping 09
 Brought up 1 CPUs
-Total of 1 processors activated (5585.97 BogoMIPS).
+Total of 1 processors activated (5585.98 BogoMIPS).
 CPU0 attaching sched-domain:
  domain 0: span 0 level CPU
   groups: 0
 net_namespace: 816 bytes
 NET: Registered protocol family 16
 ACPI: bus type pci registered
 PCI: PCI BIOS revision 2.10 entry at 0xfd2fe, last bus=3
 PCI: Using configuration type 1 for base access
 ACPI: EC: Look up EC in DSDT
 ACPI Warning (dsobject-0501): Package List length (F) larger than NumElements count (2), truncated
  [20080609]
 ACPI: Interpreter enabled
 ACPI: (supports S0 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: PCI Root Bridge [PCI0] (0000:00)
 PCI: 0000:00:02.0 reg 10 32bit mmio: [d8000000, dfffffff]
 PCI: 0000:00:02.0 reg 14 32bit mmio: [d0000000, d007ffff]
 PCI: 0000:00:02.0 reg 18 io port: [eff8, efff]
 pci 0000:00:02.0: supports D1
-PCI: 0000:00:02.1 reg 10 32bit mmio: [20000000, 27ffffff]
-PCI: 0000:00:02.1 reg 14 32bit mmio: [2c000000, 2c07ffff]
+PCI: 0000:00:02.1 reg 10 32bit mmio: [0, 7ffffff]
+PCI: 0000:00:02.1 reg 14 32bit mmio: [0, 7ffff]
 pci 0000:00:02.1: supports D1
 PCI: 0000:00:1d.0 reg 20 io port: [cfe0, cfff]
 PCI: 0000:00:1d.1 reg 20 io port: [cf80, cf9f]
-PCI: 0000:00:1d.7 reg 10 32bit mmio: [0, 3ff]
+PCI: 0000:00:1d.7 reg 10 32bit mmio: [cffffc00, cfffffff]
 pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
 pci 0000:00:1d.7: PME# disabled
 HPET not enabled in BIOS. You might try hpet=force boot option
 pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH4 ACPI/GPIO/TCO
 pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH4 GPIO
 PCI: 0000:00:1f.1 reg 10 io port: [bff8, bfff]
 PCI: 0000:00:1f.1 reg 14 io port: [bff4, bff7]
 PCI: 0000:00:1f.1 reg 18 io port: [bfe8, bfef]
 PCI: 0000:00:1f.1 reg 1c io port: [bfe4, bfe7]
 PCI: 0000:00:1f.1 reg 20 io port: [bfa0, bfaf]
-PCI: 0000:00:1f.1 reg 24 32bit mmio: [2c080400, 2c0807ff]
-PCI: 0000:00:1f.5 reg 10 io port: [0, ff]
-PCI: 0000:00:1f.5 reg 14 io port: [0, 3f]
-PCI: 0000:00:1f.5 reg 18 32bit mmio: [0, 1ff]
-PCI: 0000:00:1f.5 reg 1c 32bit mmio: [0, ff]
+PCI: 0000:00:1f.1 reg 24 32bit mmio: [0, 3ff]
+PCI: 0000:00:1f.5 reg 10 io port: [be00, beff]
+PCI: 0000:00:1f.5 reg 14 io port: [bdc0, bdff]
+PCI: 0000:00:1f.5 reg 18 32bit mmio: [cfdffe00, cfdfffff]
+PCI: 0000:00:1f.5 reg 1c 32bit mmio: [cfdffd00, cfdffdff]
 pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.5: PME# disabled
-PCI: 0000:00:1f.6 reg 10 io port: [0, ff]
-PCI: 0000:00:1f.6 reg 14 io port: [0, 7f]
+PCI: 0000:00:1f.6 reg 10 io port: [ba00, baff]
+PCI: 0000:00:1f.6 reg 14 io port: [b980, b9ff]
 pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.6: PME# disabled
-PCI: 0000:01:08.0 reg 10 32bit mmio: [cffff000, cfffffff]
+PCI: 0000:01:08.0 reg 10 32bit mmio: [cfeff000, cfefffff]
 PCI: 0000:01:08.0 reg 14 io port: [cf40, cf7f]
 pci 0000:01:08.0: supports D1
 pci 0000:01:08.0: supports D2
 pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:01:08.0: PME# disabled
 PCI: 0000:01:0b.0 reg 10 32bit mmio: [0, fff]
 pci 0000:00:1e.0: transparent bridge
 PCI: bridge 0000:00:1e.0 io port: [c000, cfff]
-PCI: bridge 0000:00:1e.0 32bit mmio: [cff00000, cfffffff]
+PCI: bridge 0000:00:1e.0 32bit mmio: [cfe00000, cfefffff]
 bus 00 -> node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
 ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
 ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *11)
 ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11)
 ACPI: Power Resource [PFAN] (off)
 Linux Plug and Play Support v0.97 (c) Adam Belay
 pnp: PnP ACPI init
 ACPI: bus type pnp registered
 pnp: PnP ACPI: found 10 devices
 ACPI: ACPI bus type pnp unregistered
 PnPBIOS: Disabled by ACPI PNP
 PCI: Using ACPI for IRQ routing
 pci 0000:00:1d.0: BAR 4: can't allocate resource
 pci 0000:00:1d.1: BAR 4: can't allocate resource
 ACPI: RTC can wake from S4
 system 00:00: iomem range 0x0-0x9ffff could not be reserved
 system 00:00: iomem range 0xe0000-0xeffff could not be reserved
 system 00:00: iomem range 0xf0000-0xfffff could not be reserved
 system 00:00: iomem range 0x100000-0x1ef3ffff could not be reserved
 system 00:00: iomem range 0x1ef40000-0x1ef4ffff could not be reserved
 system 00:00: iomem range 0x1ef50000-0x1effffff could not be reserved
 system 00:00: iomem range 0xfec10000-0xfec1ffff could not be reserved
 system 00:00: iomem range 0xfeda0000-0xfedbffff could not be reserved
 system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
 system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
 system 00:00: iomem range 0xffb00000-0xffbfffff could not be reserved
 system 00:00: iomem range 0xffe80000-0xffffffff could not be reserved
 system 00:08: ioport range 0x1e0-0x1ef has been reserved
 system 00:08: ioport range 0x480-0x48f has been reserved
 system 00:08: ioport range 0x680-0x6ff has been reserved
 system 00:08: ioport range 0x800-0x80f has been reserved
 system 00:08: ioport range 0xd800-0xd87f has been reserved
 system 00:08: ioport range 0xd880-0xd89f has been reserved
 system 00:08: ioport range 0xd8a0-0xd8bf has been reserved
 system 00:08: ioport range 0xe000-0xe07f has been reserved
 system 00:08: ioport range 0xe080-0xe0ff has been reserved
 system 00:08: ioport range 0xe400-0xe47f has been reserved
 system 00:08: ioport range 0xe480-0xe4ff has been reserved
 system 00:08: ioport range 0xe800-0xe87f has been reserved
 system 00:08: ioport range 0xe880-0xe8ff has been reserved
 system 00:08: ioport range 0xec00-0xec7f has been reserved
 system 00:08: ioport range 0xec80-0xecff has been reserved
 system 00:08: ioport range 0xeeac-0xeeac has been reserved
 system 00:08: ioport range 0xeeb0-0xeebf has been reserved
 system 00:08: ioport range 0xeec0-0xeeff has been reserved
 system 00:08: ioport range 0x4d0-0x4d1 has been reserved
 pci 0000:01:0b.0: CardBus bridge, secondary bus 0000:02
 pci 0000:01:0b.0:   IO window: 0x00c000-0x00c0ff
 pci 0000:01:0b.0:   IO window: 0x00c400-0x00c4ff
 pci 0000:01:0b.0:   PREFETCH window: 0x28000000-0x2bffffff
 pci 0000:01:0b.0:   MEM window: 0x30000000-0x33ffffff
 pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
 pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
-pci 0000:00:1e.0:   MEM window: 0xcff00000-0xcfffffff
+pci 0000:00:1e.0:   MEM window: 0xcfe00000-0xcfefffff
 pci 0000:00:1e.0:   PREFETCH window: 0x00000028000000-0x0000002bffffff
 pci 0000:00:1e.0: setting latency timer to 64
 pci 0000:01:0b.0: enabling device (0000 -> 0003)
 pci 0000:01:0b.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 bus: 00 index 0 io port: [0, ffff]
 bus: 00 index 1 mmio: [0, ffffffff]
 bus: 01 index 0 io port: [c000, cfff]
-bus: 01 index 1 mmio: [cff00000, cfffffff]
+bus: 01 index 1 mmio: [cfe00000, cfefffff]
 bus: 01 index 2 mmio: [28000000, 2bffffff]
 bus: 01 index 3 io port: [0, ffff]
 bus: 01 index 4 mmio: [0, ffffffff]
 bus: 02 index 0 io port: [c000, c0ff]
 bus: 02 index 1 io port: [c400, c4ff]
 bus: 02 index 2 mmio: [28000000, 2bffffff]
 bus: 02 index 3 mmio: [30000000, 33ffffff]
 NET: Registered protocol family 2
 IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
 TCP established hash table entries: 16384 (order: 5, 131072 bytes)
 TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
 TCP: Hash tables configured (established 16384 bind 16384)
 TCP reno registered
 NET: Registered protocol family 1
 checking if image is initramfs... it is
 Freeing initrd memory: 3574k freed
-Simple Boot Flag at 0x7c set to 0x1
 audit: initializing netlink socket (disabled)
-type=2000 audit(1221952098.428:1): initialized
+type=2000 audit(1221953191.428:1): initialized
 VFS: Disk quotas dquot_6.5.1
 Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
 msgmni has been set to 974
 io scheduler noop registered
 io scheduler anticipatory registered
 io scheduler deadline registered
 io scheduler cfq registered (default)
 pci 0000:00:02.0: Boot video device
 pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
 vesafb: framebuffer at 0xd8000000, mapped to 0xdf880000, using 3072k, total 16192k
 vesafb: mode is 1024x768x16, linelength=2048, pages=9
 vesafb: scrolling: redraw
 vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
 Console: switching to colour frame buffer device 128x48
 fb0: VESA VGA frame buffer device
 isapnp: Scanning for PnP cards...
 Switched to high resolution mode on CPU 0
 isapnp: No Plug & Play device found
 Serial: 8250/16550 driver4 ports, IRQ sharing enabled
 serial 0000:00:1f.6: power state changed by ACPI to D0
-serial 0000:00:1f.6: enabling device (0000 -> 0001)
 serial 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 serial 0000:00:1f.6: PCI INT B disabled
 brd: module loaded
 e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
 e100: Copyright(c) 1999-2006 Intel Corporation
 e100 0000:01:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
 e100 0000:01:08.0: PME# disabled
-e100: eth0: e100_probe: addr 0xcffff000, irq 20, MAC addr 00:08:0d:17:bf:f5
+e100: eth0: e100_probe: addr 0xcfeff000, irq 20, MAC addr 00:08:0d:17:bf:f5
 console [netcon0] enabled
 netconsole: network logging started
 PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
 mice: PS/2 mouse device common for all mice
 cpuidle: using governor ladder
 cpuidle: using governor menu
 TCP bic registered
 NET: Registered protocol family 17
 Using IPI No-Shortcut mode
 Freeing unused kernel memory: 232k freed
 input: AT Translated Set 2 keyboard as /class/input/input0
 ACPI: Transitioning device [FAN] to D3
 fan PNP0C0B:00: registered as cooling_device0
 ACPI: Fan [FAN] (off)
 ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
 processor ACPI0007:00: registered as cooling_device1
 thermal LNXTHERM:01: registered as thermal_zone0
-ACPI: Thermal Zone [THRM] (61 C)
+ACPI: Thermal Zone [THRM] (44 C)
 usbcore: registered new interface driver usbfs
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
-ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
 ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
 ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: EHCI Host Controller
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
 ehci_hcd 0000:00:1d.7: debug port 1
 ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
-ehci_hcd 0000:00:1d.7: irq 23, io mem 0x2c080000
+ehci_hcd 0000:00:1d.7: irq 23, io mem 0xcffffc00
 USB Universal Host Controller Interface driver v3.0
 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
 usb usb1: configuration #1 chosen from 1 choice
 hub 1-0:1.0: USB hub found
 hub 1-0:1.0: 6 ports detected
 Uniform Multi-Platform E-IDE driver
 uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
-uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
+uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001000
 usb usb2: configuration #1 chosen from 1 choice
 hub 2-0:1.0: USB hub found
 hub 2-0:1.0: 2 ports detected
 Marking TSC unstable due to TSC halts in idle
 uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
 uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
-uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018e0
+uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
 usb usb3: configuration #1 chosen from 1 choice
 hub 3-0:1.0: USB hub found
 hub 3-0:1.0: 2 ports detected
 piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
 PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 piix 0000:00:1f.1: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xbfa0-0xbfa7
     ide1: BM-DMA at 0xbfa8-0xbfaf
 Probing IDE interface ide0...
 hda: HTS541080G9AT00, ATA DISK drive
 hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
 hda: UDMA/100 mode selected
 Probing IDE interface ide1...
-Clocksource tsc unstable (delta = -245158847 ns)
+Clocksource tsc unstable (delta = -239288271 ns)
 hdc: TOSHIBA DVD-ROM SD-R6112, ATAPI CD/DVD-ROM drive
 hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
 hdc: UDMA/33 mode selected
 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
 ide1 at 0x170-0x177,0x376 on irq 15
 No dock devices found.
 SCSI subsystem initialized
 libata version 3.00 loaded.
 hda: max request size: 512KiB
 hda: 156301488 sectors (80026 MB) w/7539KiB Cache, CHS=16383/255/63
 hda: cache flushes supported
  hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
 hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
 Uniform CD-ROM driver Revision: 3.20
 device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 udevd version 125 started
 input: PC Speaker as /class/input/input1
-rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
-rtc0: alarms up to one year
 Linux agpgart interface v0.103
 agpgart-intel 0000:00:00.0: Intel 855GM Chipset
 agpgart-intel 0000:00:00.0: detected 16252K stolen memory
 agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xd8000000
-input: Power Button (FF) as /class/input/input2
-ACPI: Power Button (FF) [PWRF]
-input: Lid Switch as /class/input/input3
 iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
 iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0xd860)
 iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
+pci_hotplug: PCI Hot Plug PCI Core version: 0.5
+shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
+rtc0: alarms up to one year
+input: Power Button (FF) as /class/input/input2
+ACPI: Power Button (FF) [PWRF]
+input: Lid Switch as /class/input/input3
 ACPI: Lid Switch [LID]
 input: Power Button (CM) as /class/input/input4
+parport_pc 00:09: reported by Plug and Play ACPI
+parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
 ACPI: Power Button (CM) [PWRB]
-ACPI: AC Adapter [ADP1] (on-line)
-pci_hotplug: PCI Hot Plug PCI Core version: 0.5
 ACPI: Battery Slot [BAT1] (battery present)
-shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
+ACPI: AC Adapter [ADP1] (on-line)
 acpi device:0f: registered as cooling_device2
 input: Video Bus as /class/input/input5
-ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
 Yenta: CardBus bridge found at 0000:01:0b.0 [1179:0001]
-Yenta: ISA IRQ mask 0x0cb8, PCI irq 18
+ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
+Yenta: ISA IRQ mask 0x0c38, PCI irq 18
 Socket status: 30000020
 pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
 cs: IO port probe 0xc000-0xcfff: clean.
-pcmcia: parent PCI bridge Memory window: 0xcff00000 - 0xcfffffff
+pcmcia: parent PCI bridge Memory window: 0xcfe00000 - 0xcfefffff
 pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
 Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
-Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
 Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH 0000:00:1f.5: setting latency timer to 64
 input: PS/2 Mouse as /class/input/input6
-input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
-parport_pc 00:09: activated
-parport_pc 00:09: reported by Plug and Play ACPI
-parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
 pccard: CardBus card inserted into slot 0
 PCI: 0000:02:00.0 reg 10 32bit mmio: [0, ffff]
+input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
 cs: IO port probe 0x100-0x3af: clean.
 cs: IO port probe 0x3e0-0x4ff: clean.
 cs: IO port probe 0x820-0x8ff: clean.
 cs: IO port probe 0xc00-0xcf7: clean.
 cs: IO port probe 0xa00-0xaff: clean.
-intel8x0_measure_ac97_clock: measured 55239 usecs
+intel8x0_measure_ac97_clock: measured 53133 usecs
 intel8x0: clocking to 48000
 Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
 Intel ICH Modem 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
 ath5k_pci 0000:02:00.0: enabling device (0000 -> 0002)
 ath5k_pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
 ath5k_pci 0000:02:00.0: registered as 'phy0'
 phy0: Selected rate control algorithm 'pid'
 ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
 ath5k phy0: RF2112A 2GHz radio found (0x46)
 udev: renamed network interface wlan0 to ath0
 EXT3 FS on dm-1, internal journal
 padlock: VIA PadLock not detected.
 padlock: VIA PadLock Hash Engine not detected.
 loop: module loaded
 NET: Registered protocol family 10
 lo: Disabled Privacy Extensions
 toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
 toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on dm-7, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on dm-5, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on dm-2, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
 kjournald starting.  Commit interval 5 seconds
 EXT3 FS on dm-3, internal journal
 EXT3-fs: mounted filesystem with ordered data mode.
 Adding 1048568k swap on /dev/mapper/strider-swap_crypt.  Priority:-1 extents:1 across:1048568k
 ADDRCONF(NETDEV_UP): ath0: link is not ready
 ath0: authenticate with AP 00:14:c1:38:e5:15
 ath0: authenticated
 ath0: associate with AP 00:14:c1:38:e5:15
 ath0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
 ath0: associated
 ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
 lp0: using parport0 (interrupt-driven).
 ppdev: user-space parallel port driver
 ADDRCONF(NETDEV_UP): eth0: link is not ready
 ath0: no IPv6 routers present
 ADDRCONF(NETDEV_UP): eth0: link is not ready

--Boundary-00=_zvY1IX1R1NLfeJX--
