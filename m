Return-Path: <linux-kernel-owner+w=401wt.eu-S1757281AbZCDURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbZCDURf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZCDUR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:17:27 -0500
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:20643 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbZCDURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:17:23 -0500
From: Frans Pop <elendil@planet.nl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Wed, 4 Mar 2009 21:17:15 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rene Herman <rene.herman@keyaccess.nl>
References: <200809091250.08620.elendil@planet.nl> <200809201756.25157.bjorn.helgaas@hp.com> <200809261540.31443.bjorn.helgaas@hp.com>
In-Reply-To: <200809261540.31443.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OHurJqexfNTfR2d"
Message-Id: <200903042117.18034.elendil@planet.nl>
X-OriginalArrivalTime: 04 Mar 2009 20:17:18.0750 (UTC) FILETIME=[37C08BE0:01C99D06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_OHurJqexfNTfR2d
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 26 September 2008, Bjorn Helgaas wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11550

Sorry for having to revive this old thread. In November 2008 I reported
that this issue had been solved for me as a result of 1f98757776ea, but I
now find that was due to faulty testing. (I suspect that changing the BIOS
setting that affects this issue on my Toshiba laptop only takes effect
after a cold boot, not a normal reboot.)

The problem was that with the BIOS setting for "Device config" set to
"Setup by OS", I get 78 messages like:
    pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
    pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling

If the BIOS setting is set to "All Devices", the problem does not occur.

The origin of these messages was bisected to:
commit aee3ad815dd291a7193ab01da0f1a30c84d00061
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Jun 27 16:56:57 2008 -0600
    PNP: replace pnp_resource_table with dynamically allocated resources

Last analysis from Bjorn was:
> The problem seems to be that Frans has some PCI devices that are not
> configured by the BIOS, and their BARs contain zero.  A PNP quirk
> checks for overlaps of PCI devices and PNP devices, and those zero-
> valued BARs of course conflict with the PNP motherboard devices that
> describe legacy hardware.
>
> Here's another approach based on section 3.5 of the PCI Firmware spec.
> It says:
>
>   Since not all devices may be configured prior to the operating
>   system handoff, the operating system needs to know whether a
>   specific BAR register has been configured by firmware. The operating
>   system makes the determination by checking the I/O Enable, and
>   Memory Enable bits in the device's command register, and Expansion
>   ROM BAR enable bits. If the enable bit is set, then the corresponding
>   resource register has been configured.
>
> So instead of checking whether the BAR contains zero, the patch below
> checks the I/O, Mem, and ROM BAR enable bits to determine whether a
> BAR is enabled.

Below the then proposed patch from Bjorn, rediffed against 2.6.29-rc7.
I've verified that the patch still solves the issue for me. Attached
dmesg output for 2.6.29-rc7 without and with the patch.

Bjorn, could you please consider this patch for inclusion again?

Original thread: http://marc.info/?l=linux-kernel&m=122095745403793&w=4

TIA and sorry for the confusion,
FJP


diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 32e8d88..e63f800 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,6 +26,28 @@
 #include "pci.h"
 
 
+int pci_resource_enabled(struct pci_dev *dev, int bar)
+{
+	u16 command = 0;
+	u32 addr = 0;
+
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+
+	if (pci_resource_flags(dev, bar) & IORESOURCE_IO)
+		return command & PCI_COMMAND_IO;
+
+	if (command & PCI_COMMAND_MEMORY) {
+		if (bar == PCI_ROM_RESOURCE) {
+			pci_read_config_dword(dev, dev->rom_base_reg, &addr);
+			return addr & PCI_ROM_ADDRESS_ENABLE;
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
 void pci_update_resource(struct pci_dev *dev, int resno)
 {
 	struct pci_bus_region region;
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 8473fe5..1f37988 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -247,6 +247,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			unsigned long type;
 
+			if (!pci_resource_enabled(pdev, i))
+				continue;
+
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
 			if (!type || pci_resource_len(pdev, i) == 0)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c927ae9..9848ac2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -870,6 +870,8 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+extern int pci_resource_enabled(struct pci_dev *dev, int bar);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*
@@ -1050,6 +1052,9 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 						unsigned int devfn)
 { return NULL; }
 
+static inline int pci_resource_enabled(struct pci_dev *dev, int bar)
+{ return 0; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */


--Boundary-00=_OHurJqexfNTfR2d
Content-Type: text/plain;
  charset="iso 8859-15";
  name="2.6.29-rc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.29-rc7"

Linux version 2.6.29-rc7 (root@aragorn) (gcc version 4.3.3 (Debian 4.3.3-5) ) #25 SMP Wed Mar 4 13:04:29 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
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
DMI 2.3 present.
last_pfn = 0x1ef40 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
kernel direct mapping tables up to 1ef40000 @ 7000-c000
RAMDISK: 1eb65000 - 1ef2f4b4
ACPI: RSDP 000F0180, 0014 (r0 TOSHIB)
ACPI: RSDT 1EF40000, 0038 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 1EF40060, 0084 (r2 TOSHIB 750      20030101 TASM  4010000)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 1EF40558, 4B72 (r1 TOSHIB A000C    20031216 MSFT  100000E)
ACPI: FACS 000EEE00, 0040
ACPI: SSDT 1EF402CA, 0082 (r1 TOSHIB A000C    20030917 MSFT  100000E)
ACPI: DBGP 1EF400E4, 0034 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: BOOT 1EF40038, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: APIC 1EF40118, 0062 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
495MB LOWMEM available.
  mapped low ram: 0 - 1ef40000
  low ram: 00000000 - 1ef40000
  bootmap 00002000 - 00005de8
(9 early reservations) ==> bootmem [0000000000 - 001ef40000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000498804]    TEXT DATA BSS ==> [0000100000 - 0000498804]
  #4 [001eb65000 - 001ef2f4b4]          RAMDISK ==> [001eb65000 - 001ef2f4b4]
  #5 [0000499000 - 000049c000]    INIT_PG_TABLE ==> [0000499000 - 000049c000]
  #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
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
free_area_init_node: node 0, pgdat c03cf520, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 959 pages used for memmap
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
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 1f000000:dfc00000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 32768 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 125696
Kernel command line: root=/dev/mapper/strider-root ro vga=791 quiet
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 2793.043 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 494568k/507136k available (1860k kernel code, 12052k reserved, 1112k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdf740000 - 0xff7fe000   ( 512 MB)
    lowmem  : 0xc0000000 - 0xdef40000   ( 495 MB)
      .init : 0xc03ef000 - 0xc0432000   ( 268 kB)
      .data : 0xc02d127d - 0xc03e75ec   (1112 kB)
      .text : 0xc0100000 - 0xc02d127d   (1860 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.08 BogoMIPS (lpj=11172172)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
[ds] using Netburst configuration
CPU: Hyper-Threading is disabled
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Mobile Intel(R) Pentium(R) 4     CPU 2.80GHz stepping 09
Brought up 1 CPUs
Total of 1 processors activated (5586.08 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 996 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd2fe, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (F) larger than NumElements count (2), truncated
 [20081204]
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xd0000000-0xd007ffff]
pci 0000:00:02.0: reg 18 io port: [0xeff8-0xefff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.1: reg 10 32bit mmio: [0x20000000-0x27ffffff]
pci 0000:00:02.1: reg 14 32bit mmio: [0x2c000000-0x2c07ffff]
pci 0000:00:02.1: supports D1
pci 0000:00:1d.0: reg 20 io port: [0xcfe0-0xcfff]
pci 0000:00:1d.1: reg 20 io port: [0xcf80-0xcf9f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0xbff8-0xbfff]
pci 0000:00:1f.1: reg 14 io port: [0xbff4-0xbff7]
pci 0000:00:1f.1: reg 18 io port: [0xbfe8-0xbfef]
pci 0000:00:1f.1: reg 1c io port: [0xbfe4-0xbfe7]
pci 0000:00:1f.1: reg 20 io port: [0xbfa0-0xbfaf]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x2c080400-0x2c0807ff]
pci 0000:00:1f.5: reg 10 io port: [0x00-0xff]
pci 0000:00:1f.5: reg 14 io port: [0x00-0x3f]
pci 0000:00:1f.5: reg 18 32bit mmio: [0x000000-0x0001ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0x000000-0x0000ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0x00-0xff]
pci 0000:00:1f.6: reg 14 io port: [0x00-0x7f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:08.0: reg 10 32bit mmio: [0xcffff000-0xcfffffff]
pci 0000:01:08.0: reg 14 io port: [0xcf40-0xcf7f]
pci 0000:01:08.0: supports D1 D2
pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:08.0: PME# disabled
pci 0000:01:0b.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xcff00000-0xcfffffff]
pci_bus 0000:00: on NUMA node 0
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
PCI: Using ACPI for IRQ routing
pci 0000:00:1d.0: BAR 4: can't allocate resource
pci 0000:00:1d.1: BAR 4: can't allocate resource
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling
pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x62-0x62) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x66-0x66) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x80-0x80) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x84-0x86) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x88-0x88) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x8c-0x8e) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xe0-0xef) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x24-0x25) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x28-0x29) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x2c-0x2d) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x30-0x31) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x34-0x35) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x38-0x39) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x3c-0x3d) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x50-0x53) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x63-0x63) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x65-0x65) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x72-0x77) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x90-0x9f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xa4-0xa5) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xa8-0xa9) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xac-0xad) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xb0-0xb5) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xb8-0xb9) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xbc-0xbd) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x24-0x25) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x28-0x29) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x2c-0x2d) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x30-0x31) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x34-0x35) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x38-0x39) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x3c-0x3d) overlaps 0000:00:1f.5 BAR 1 (0x0-0x3f), disabling
pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x62-0x62) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x66-0x66) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x80-0x80) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x84-0x86) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x88-0x88) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x8c-0x8e) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xe0-0xef) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x24-0x25) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x28-0x29) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x2c-0x2d) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x30-0x31) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x34-0x35) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x38-0x39) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x3c-0x3d) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x50-0x53) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x63-0x63) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x65-0x65) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x72-0x77) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x90-0x9f) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xa4-0xa5) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xa8-0xa9) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xac-0xad) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xb0-0xb5) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xb8-0xb9) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0xbc-0xbd) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x62-0x62) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x66-0x66) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x24-0x25) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x28-0x29) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x2c-0x2d) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x30-0x31) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x34-0x35) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x38-0x39) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x3c-0x3d) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x50-0x53) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x63-0x63) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x65-0x65) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp 00:08: io resource (0x72-0x77) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1ef3ffff could not be reserved
system 00:00: iomem range 0x1ef40000-0x1ef4ffff could not be reserved
system 00:00: iomem range 0x1ef50000-0x1effffff has been reserved
system 00:00: iomem range 0xfec10000-0xfec1ffff has been reserved
system 00:00: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:00: iomem range 0xffe80000-0xffffffff has been reserved
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
pci 0000:00:1e.0:   MEM window: 0xcff00000-0xcfffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000028000000-0x0000002bffffff
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:01:0b.0: enabling device (0000 -> 0003)
pci 0000:01:0b.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:01: resource 1 mem: [0xcff00000-0xcfffffff]
pci_bus 0000:01: resource 2 mem: [0x28000000-0x2bffffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:02: resource 0 io:  [0xc000-0xc0ff]
pci_bus 0000:02: resource 1 io:  [0xc400-0xc4ff]
pci_bus 0000:02: resource 2 mem: [0x28000000-0x2bffffff]
pci_bus 0000:02: resource 3 mem: [0x30000000-0x33ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3881k freed
Simple Boot Flag at 0x7c set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1236175417.524:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 973
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
vesafb: framebuffer at 0xd8000000, mapped to 0xdf780000, using 3072k, total 16192k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial 0000:00:1f.6: power state changed by ACPI to D0
serial 0000:00:1f.6: enabling device (0000 -> 0001)
serial 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
serial 0000:00:1f.6: PCI INT B disabled
brd: module loaded
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:01:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e100 0000:01:08.0: PME# disabled
e100: eth0: e100_probe: addr 0xcffff000, irq 20, MAC addr 00:08:0d:17:bf:f5
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
Freeing unused kernel memory: 268k freed
input: AT Translated Set 2 keyboard as /class/input/input0
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (58 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x2c080000
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018e0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xbfa0-0xbfa7
    ide1: BM-DMA at 0xbfa8-0xbfaf
Probing IDE interface ide0...
Marking TSC unstable due to TSC halts in idle
hda: HTS541080G9AT00, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
Clocksource tsc unstable (delta = -496610873 ns)
hdc: TOSHIBA DVD-ROM SD-R6112, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 3.00 loaded.
ide-gd driver 1.18
hda: max request size: 512KiB
ide-cd driver 5.00
hda: 156301488 sectors (80026 MB) w/7539KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
ide-cd: hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI Warning (nspredef-0940): \_SB_.BAT1._BIF: Return Package type mismatch at index 12 - found Integer, expected String/Buffer [20081204]
ACPI: Battery Slot [BAT1] (battery present)
ACPI: AC Adapter [ADP1] (on-line)
Linux agpgart interface v0.103
acpi device:0f: registered as cooling_device2
input: Video Bus as /class/input/input4
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
parport_pc 00:09: activated
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0xd860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
input: PC Speaker as /class/input/input5
agpgart-intel 0000:00:00.0: Intel 855GM Chipset
agpgart-intel 0000:00:00.0: detected 16252K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xd8000000
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, 114 bytes nvram
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
yenta_cardbus 0000:01:0b.0: CardBus bridge found [1179:0001]
yenta_cardbus 0000:01:0b.0: ISA IRQ mask 0x0c38, PCI irq 18
yenta_cardbus 0000:01:0b.0: Socket status: 30000020
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xcfff: clean.
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0xcff00000 - 0xcfffffff
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH 0000:00:1f.5: setting latency timer to 64
input: PS/2 Mouse as /class/input/input6
input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:02:00.0: reg 10 32bit mmio: [0x000000-0x00ffff]
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: EU
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
ath5k 0000:02:00.0: enabling device (0000 -> 0002)
ath5k 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k 0000:02:00.0: registered as 'phy0'
wmaster0 (ath5k): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (ath5k): not using net_device_ops yet
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112B 2GHz radio found (0x46)
udev: renamed network interface wlan0 to ath0
intel8x0_measure_ac97_clock: measured 55377 usecs
intel8x0: clocking to 48000
Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
Intel ICH Modem 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
EXT3 FS on dm-1, internal journal
loop: module loaded
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
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
ath0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=2)
ath0: associated
ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
ADDRCONF(NETDEV_UP): eth0: link is not ready
ath0: no IPv6 routers present
ADDRCONF(NETDEV_UP): eth0: link is not ready
CPU0 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.

--Boundary-00=_OHurJqexfNTfR2d
Content-Type: text/plain;
  charset="iso-8859-15";
  name="2.6.29-rc7.patched"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.29-rc7.patched"

Linux version 2.6.29-rc7 (root@aragorn) (gcc version 4.3.3 (Debian 4.3.3-5) ) #10 SMP Wed Mar 4 20:32:19 CET 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
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
DMI 2.3 present.
last_pfn = 0x1ef40 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1ef40000 @ 7000-c000
RAMDISK: 1eb65000 - 1ef2f40f
ACPI: RSDP 000F0180, 0014 (r0 TOSHIB)
ACPI: RSDT 1EF40000, 0038 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 1EF40060, 0084 (r2 TOSHIB 750      20030101 TASM  4010000)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 1EF40558, 4B72 (r1 TOSHIB A000C    20031216 MSFT  100000E)
ACPI: FACS 000EEE00, 0040
ACPI: SSDT 1EF402CA, 0082 (r1 TOSHIB A000C    20030917 MSFT  100000E)
ACPI: DBGP 1EF400E4, 0034 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: BOOT 1EF40038, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: APIC 1EF40118, 0062 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
495MB LOWMEM available.
  mapped low ram: 0 - 1ef40000
  low ram: 00000000 - 1ef40000
  bootmap 00002000 - 00005de8
(9 early reservations) ==> bootmem [0000000000 - 001ef40000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000498804]    TEXT DATA BSS ==> [0000100000 - 0000498804]
  #4 [001eb65000 - 001ef2f40f]          RAMDISK ==> [001eb65000 - 001ef2f40f]
  #5 [0000499000 - 000049c000]    INIT_PG_TABLE ==> [0000499000 - 000049c000]
  #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
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
free_area_init_node: node 0, pgdat c03cf520, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 959 pages used for memmap
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
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 1f000000:dfc00000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 32768 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 125696
Kernel command line: root=/dev/mapper/strider-root rootdelay=10 ro vga=791 quiet
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Fast TSC calibration using PIT
Detected 2793.051 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 494568k/507136k available (1860k kernel code, 12052k reserved, 1112k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdf740000 - 0xff7fe000   ( 512 MB)
    lowmem  : 0xc0000000 - 0xdef40000   ( 495 MB)
      .init : 0xc03ef000 - 0xc0432000   ( 268 kB)
      .data : 0xc02d130d - 0xc03e75ec   (1112 kB)
      .text : 0xc0100000 - 0xc02d130d   (1860 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.10 BogoMIPS (lpj=11172204)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
[ds] using Netburst configuration
CPU: Hyper-Threading is disabled
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Mobile Intel(R) Pentium(R) 4     CPU 2.80GHz stepping 09
Brought up 1 CPUs
Total of 1 processors activated (5586.10 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 996 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd2fe, last bus=3
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (F) larger than NumElements count (2), truncated
 [20081204]
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xd8000000-0xdfffffff]
pci 0000:00:02.0: reg 14 32bit mmio: [0xd0000000-0xd007ffff]
pci 0000:00:02.0: reg 18 io port: [0xeff8-0xefff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.1: reg 10 32bit mmio: [0x000000-0x7ffffff]
pci 0000:00:02.1: reg 14 32bit mmio: [0x000000-0x07ffff]
pci 0000:00:02.1: supports D1
pci 0000:00:1d.0: reg 20 io port: [0xcfe0-0xcfff]
pci 0000:00:1d.1: reg 20 io port: [0xcf80-0xcf9f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:1f.0: quirk: region d800-d87f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region eec0-eeff claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0xbff8-0xbfff]
pci 0000:00:1f.1: reg 14 io port: [0xbff4-0xbff7]
pci 0000:00:1f.1: reg 18 io port: [0xbfe8-0xbfef]
pci 0000:00:1f.1: reg 1c io port: [0xbfe4-0xbfe7]
pci 0000:00:1f.1: reg 20 io port: [0xbfa0-0xbfaf]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.5: reg 10 io port: [0x00-0xff]
pci 0000:00:1f.5: reg 14 io port: [0x00-0x3f]
pci 0000:00:1f.5: reg 18 32bit mmio: [0x000000-0x0001ff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0x000000-0x0000ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0x00-0xff]
pci 0000:00:1f.6: reg 14 io port: [0x00-0x7f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:08.0: reg 10 32bit mmio: [0xcffff000-0xcfffffff]
pci 0000:01:08.0: reg 14 io port: [0xcf40-0xcf7f]
pci 0000:01:08.0: supports D1 D2
pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:08.0: PME# disabled
pci 0000:01:0b.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xcff00000-0xcfffffff]
pci_bus 0000:00: on NUMA node 0
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
PCI: Using ACPI for IRQ routing
pci 0000:00:1d.0: BAR 4: can't allocate resource
pci 0000:00:1d.1: BAR 4: can't allocate resource
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x1ef3ffff could not be reserved
system 00:00: iomem range 0x1ef40000-0x1ef4ffff could not be reserved
system 00:00: iomem range 0x1ef50000-0x1effffff has been reserved
system 00:00: iomem range 0xfec10000-0xfec1ffff has been reserved
system 00:00: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:00: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:00: iomem range 0xffe80000-0xffffffff has been reserved
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
pci 0000:00:1e.0:   MEM window: 0xcff00000-0xcfffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000028000000-0x0000002bffffff
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:01:0b.0: enabling device (0000 -> 0003)
pci 0000:01:0b.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:01: resource 1 mem: [0xcff00000-0xcfffffff]
pci_bus 0000:01: resource 2 mem: [0x28000000-0x2bffffff]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:02: resource 0 io:  [0xc000-0xc0ff]
pci_bus 0000:02: resource 1 io:  [0xc400-0xc4ff]
pci_bus 0000:02: resource 2 mem: [0x28000000-0x2bffffff]
pci_bus 0000:02: resource 3 mem: [0x30000000-0x33ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3881k freed
Simple Boot Flag at 0x7c set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1236195728.528:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 973
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
vesafb: framebuffer at 0xd8000000, mapped to 0xdf780000, using 3072k, total 16192k
vesafb: mode is 1024x768x16, linelength=2048, pages=9
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial 0000:00:1f.6: power state changed by ACPI to D0
serial 0000:00:1f.6: enabling device (0000 -> 0001)
serial 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
serial 0000:00:1f.6: PCI INT B disabled
brd: module loaded
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:01:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
e100 0000:01:08.0: PME# disabled
e100: eth0: e100_probe: addr 0xcffff000, irq 20, MAC addr 00:08:0d:17:bf:f5
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
Freeing unused kernel memory: 268k freed
input: AT Translated Set 2 keyboard as /class/input/input0
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device1
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (33 C)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x2c080000
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018e0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xbfa0-0xbfa7
    ide1: BM-DMA at 0xbfa8-0xbfaf
Probing IDE interface ide0...
Marking TSC unstable due to TSC halts in idle
hda: HTS541080G9AT00, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
Clocksource tsc unstable (delta = -496546074 ns)
hdc: TOSHIBA DVD-ROM SD-R6112, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
SCSI subsystem initialized
libata version 3.00 loaded.
ide-gd driver 1.18
hda: max request size: 512KiB
ide-cd driver 5.00
hda: 156301488 sectors (80026 MB) w/7539KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
ide-cd: hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
Linux agpgart interface v0.103
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI: AC Adapter [ADP1] (on-line)
ACPI Warning (nspredef-0940): \_SB_.BAT1._BIF: Return Package type mismatch at index 12 - found Integer, expected String/Buffer [20081204]
ACPI: Battery Slot [BAT1] (battery present)
agpgart-intel 0000:00:00.0: Intel 855GM Chipset
agpgart-intel 0000:00:00.0: detected 16252K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xd8000000
acpi device:0f: registered as cooling_device2
input: Video Bus as /class/input/input4
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
parport_pc 00:09: activated
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, 114 bytes nvram
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input5
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0xd860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
toshiba_acpi:     HCI method: \_SB_.VALZ.GHCI
yenta_cardbus 0000:01:0b.0: CardBus bridge found [1179:0001]
yenta_cardbus 0000:01:0b.0: ISA IRQ mask 0x0c38, PCI irq 18
yenta_cardbus 0000:01:0b.0: Socket status: 30000020
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge I/O window: 0xc000 - 0xcfff
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc000-0xcfff: clean.
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0xcff00000 - 0xcfffffff
yenta_cardbus 0000:01:0b.0: pcmcia: parent PCI bridge Memory window: 0x28000000 - 0x2bffffff
Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
Intel ICH Modem 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH Modem 0000:00:1f.6: setting latency timer to 64
Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Intel ICH 0000:00:1f.5: setting latency timer to 64
input: PS/2 Mouse as /class/input/input6
input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
pcmcia_socket pcmcia_socket0: pccard: CardBus card inserted into slot 0
pci 0000:02:00.0: reg 10 32bit mmio: [0x000000-0x00ffff]
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: EU
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
ath5k 0000:02:00.0: enabling device (0000 -> 0002)
ath5k 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k 0000:02:00.0: registered as 'phy0'
wmaster0 (ath5k): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (ath5k): not using net_device_ops yet
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF2112B 2GHz radio found (0x46)
udev: renamed network interface wlan0 to ath0
intel8x0_measure_ac97_clock: measured 55358 usecs
intel8x0: clocking to 48000
EXT3 FS on dm-1, internal journal
loop: module loaded
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
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
ath0: RX AssocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=2)
ath0: associated
ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
lp0: using parport0 (interrupt-driven).
ppdev: user-space parallel port driver
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): eth0: link is not ready
ath0: no IPv6 routers present
CPU0 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.

--Boundary-00=_OHurJqexfNTfR2d--
