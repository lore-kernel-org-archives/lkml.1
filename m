Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbZLOHIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbZLOHIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZLOHIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:08:13 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:41043 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbZLOHIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:08:11 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: K8 ECC error with linux-2.6.32
Date: Tue, 15 Dec 2009 08:08:04 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <200912141426.46361.johannes.hirte@fem.tu-ilmenau.de> <20091214222331.GB32614@liondog.tnic>
In-Reply-To: <20091214222331.GB32614@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912150808.04814.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 14 Dezember 2009 23:23:31 schrieb Borislav Petkov:
> Ok, let's see what kind of errors does your machine report. It looks
> like benign GART TLB walk errors but let's verify that first. Can you
> apply the following patchlet and re-trigger the problem:
> 
> --
> diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
> index 713ed7d..fc4a68e 100644
> --- a/drivers/edac/edac_mce_amd.c
> +++ b/drivers/edac/edac_mce_amd.c
> @@ -311,9 +311,12 @@ void amd_decode_nb_mce(int node_id, struct err_regs
>  *regs, int handle_errors) if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
>  			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
>  	} else {
> -		pr_cont(", core: %d\n", ilog2((regs->nbsh & 0xf)));
> +		pr_cont(", core: %d\n", fls(regs->nbsh & 0xf) - 1);
>  	}
> 
> +	pr_err("%s: NBSL: 0x%08x, NBSL: 0x%08x\n",
> +		__func__, regs->nbsl, regs->nbsh);
> +
> 
>  	pr_emerg("%s.\n", EXT_ERR_MSG(xec));

So here is the first one:

Linux version 2.6.32 (root@datengrab) (gcc version 4.4.2 (Gentoo 4.4.2 p1.0) ) 
#6 SMP Tue Dec 15 00:08:34 CET 2009
Command line: acpi_enforce_resources=lax root=/dev/sda1
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009fff0000 (usable)
 BIOS-e820: 000000009fff0000 - 000000009ffff000 (ACPI data)
 BIOS-e820: 000000009ffff000 - 00000000a0000000 (ACPI NVS)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x120000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FF00000000 write-back
  1 base 0100000000 mask FFE0000000 write-back
  2 base 00A0000000 mask FFE0000000 uncachable
  3 base 00C0000000 mask FFC0000000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000a0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0x9fff0 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000009fff0000
 0000000000 - 009fe00000 page 2M
 009fe00000 - 009fff0000 page 4k
kernel direct mapping tables up to 9fff0000 @ 10000-15000
init_memory_mapping: 0000000100000000-0000000120000000
 0100000000 - 0120000000 page 2M
kernel direct mapping tables up to 120000000 @ 13000-19000
ACPI: RSDP 00000000000f6d60 00024 (v02 ACPIAM)
ACPI: XSDT 000000009fff0100 0004C (v01 A M I  OEMXSDT  05000716 MSFT 00000097)
ACPI: FACP 000000009fff0281 000F4 (v01 A M I  OEMFACP  05000716 MSFT 00000097)
ACPI: DSDT 000000009fff03f0 035BC (v01  0AAAA 0AAAA000 00000000 INTL 02002026)
ACPI: FACS 000000009ffff000 00040
ACPI: APIC 000000009fff0380 0006C (v01 A M I  OEMAPIC  05000716 MSFT 00000097)
ACPI: OEMB 000000009ffff040 00041 (v01 A M I  OEMBIOS  05000716 MSFT 00000097)
ACPI: HPET 000000009fff39b0 00038 (v01 A M I  OEMHPET  05000716 MSFT 00000097)
ACPI: ASF! 000000009fff39f0 00086 (v01 AMIASF AMDSTRET 00000001 INTL 02002026)
ACPI: Local APIC address 0xfee00000
Scanning NUMA topology in Northbridge 24
Number of nodes 2
Node 0 MemBase 0000000000000000 Limit 0000000120000000
Skipping disabled node 1
NUMA: Using 63 for the hash shift.
Using node hash shift of 63
ACPI: Local APIC address 0xfee00000
Bootmem setup node 0 0000000000000000-0000000120000000
  NODE_DATA [0000000000014000 - 0000000000016fff]
  bootmap [0000000000017000 -  000000000003afff] pages 24
(7 early reservations) ==> bootmem [0000000000 - 0120000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00015ec544]    TEXT DATA BSS ==> [0001000000 - 00015ec544]
  #3 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
  #4 [00015ed000 - 00015ed1c1]              BRK ==> [00015ed000 - 00015ed1c1]
  #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
  #6 [0000013000 - 0000014000]          PGTABLE ==> [0000013000 - 0000014000]
 [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002b1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0009fff0
    0: 0x00100000 -> 0x00120000
On node 0 totalpages: 786303
  DMA zone: 56 pages used for memmap
  DMA zone: 103 pages reserved
  DMA zone: 3824 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 636968 pages, LIFO batch:31
  Normal zone: 1792 pages used for memmap
  Normal zone: 129280 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x102282a0 base: 0xfec01000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at a0000000 (gap: a0000000:5f780000)
NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880028200000 s71448 r8192 d22760 u524288
pcpu-alloc: s71448 r8192 d22760 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 770072
Policy zone: Normal
Kernel command line: acpi_enforce_resources=lax root=/dev/sda1
PID hash table entries: 4096 (order: 3, 32768 bytes)
Initializing CPU#0
Checking aperture...
AGP bridge at 00:00:00
Aperture from AGP @ e0000000 old size 32 MB
Aperture from AGP @ e0000000 size 256 MB (APSIZE f00)
Node 0: aperture @ e0000000 size 256 MB
Node 1: aperture @ e0000000 size 256 MB
Memory: 3093476k/4718592k available (3377k kernel code, 1573380k absent, 
51736k reserved, 1584k data, 388k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:384
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Fast TSC calibration using PIT
Detected 2587.799 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 
5175.59 BogoMIPS (lpj=2587799)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
mce: CPU supports 5 MCE banks
ACPI: Core revision 20090903
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: AMD Opteron(tm) Processor 252 stepping 01
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5175.55 BogoMIPS (lpj=2587776)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x1 -> Node 0
CPU1: AMD Opteron(tm) Processor 252 stepping 01
Brought up 2 CPUs
Total of 2 processors activated (10351.15 BogoMIPS).
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000a0000000 aka 2560M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [a0000000, ffffffff]
TOM2: 0000000120000000 aka 4608M
bus: [00,ff] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [a0000000, ffffffff]
bus: 00 index 3 mmio: [120000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:00:07.1: reg 20 io port: [0xffa0-0xffaf]
pci 0000:00:07.2: reg 10 io port: [0xcc00-0xcc1f]
pci 0000:01:00.0: reg 10 32bit mmio pref: [0xc0000000-0xcfffffff]
pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xff3f0000-0xff3fffff]
pci 0000:01:00.0: reg 30 32bit mmio pref: [0xff3c0000-0xff3dffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x7000-0x9fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xff300000-0xff3fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xbeb00000-0xdeafffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xff5fd000-0xff5fdfff]
pci 0000:02:00.1: reg 10 32bit mmio: [0xff5fe000-0xff5fefff]
pci 0000:02:03.0: reg 10 32bit mmio: [0xff5c0000-0xff5dffff]
pci 0000:02:03.0: reg 14 32bit mmio: [0xff5a0000-0xff5bffff]
pci 0000:02:03.0: reg 18 io port: [0xb000-0xb03f]
pci 0000:02:03.0: reg 30 32bit mmio pref: [0xff580000-0xff59ffff]
pci 0000:02:03.0: PME# supported from D0 D3hot D3cold
pci 0000:02:03.0: PME# disabled
pci 0000:02:05.0: reg 10 io port: [0xb880-0xb887]
pci 0000:02:05.0: reg 14 io port: [0xb800-0xb803]
pci 0000:02:05.0: reg 18 io port: [0xb480-0xb487]
pci 0000:02:05.0: reg 1c io port: [0xb400-0xb403]
pci 0000:02:05.0: reg 20 io port: [0xb080-0xb08f]
pci 0000:02:05.0: reg 24 32bit mmio: [0xff5ffc00-0xff5fffff]
pci 0000:02:05.0: reg 30 32bit mmio pref: [0xff500000-0xff57ffff]
pci 0000:02:05.0: supports D1 D2
pci 0000:02:07.0: reg 10 io port: [0xac00-0xac1f]
pci 0000:02:07.0: supports D1 D2
pci 0000:02:07.1: reg 10 io port: [0xbc00-0xbc07]
pci 0000:02:07.1: supports D1 D2
pci 0000:02:0a.0: reg 10 32bit mmio: [0xff5fc800-0xff5fcfff]
pci 0000:02:0a.0: reg 14 io port: [0xa880-0xa8ff]
pci 0000:02:0a.0: supports D2
pci 0000:02:0a.0: PME# supported from D2 D3hot D3cold
pci 0000:02:0a.0: PME# disabled
pci 0000:02:0b.0: reg 20 io port: [0xa480-0xa49f]
pci 0000:02:0b.0: supports D1 D2
pci 0000:02:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:0b.0: PME# disabled
pci 0000:02:0b.1: reg 20 io port: [0xa800-0xa81f]
pci 0000:02:0b.1: supports D1 D2
pci 0000:02:0b.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:0b.1: PME# disabled
pci 0000:02:0b.2: reg 10 32bit mmio: [0xff5ff000-0xff5ff0ff]
pci 0000:02:0b.2: supports D1 D2
pci 0000:02:0b.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:0b.2: PME# disabled
pci 0000:00:06.0: bridge io port: [0xa000-0xbfff]
pci 0000:00:06.0: bridge 32bit mmio: [0xff400000-0xff5fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 0: address space collision on of device 
[0xe0000000-0xefffffff]
pci 0000:00:00.0: BAR 0: can't allocate resource
hpet0: at MMIO 0xfec01000, IRQs 2, 8, 0
hpet0: 3 comparators, 32-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0e: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 0 (0x0-0xfffffff), 
disabling
pnp 00:0e: mem resource (0xc0000-0xdffff) overlaps 0000:00:00.0 BAR 0 
(0x0-0xfffffff), disabling
pnp 00:0e: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 BAR 0 
(0x0-0xfffffff), disabling
pnp 00:0e: mem resource (0x100000-0x9fffffff) overlaps 0000:00:00.0 BAR 0 
(0x0-0xfffffff), disabling
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
system 00:0a: ioport range 0x680-0x6ff has been reserved
system 00:0a: ioport range 0x295-0x296 has been reserved
system 00:0a: ioport range 0x778-0x77f has been reserved
system 00:0a: ioport range 0xb78-0xb7f has been reserved
system 00:0a: ioport range 0xf78-0xf7f has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0x1000-0x10bf has been reserved
system 00:0b: ioport range 0x10e0-0x10ff has been reserved
system 00:0b: ioport range 0x10c0-0x10df has been reserved
system 00:0b: ioport range 0xde00-0xde7f has been reserved
system 00:0b: ioport range 0xde80-0xdeff has been reserved
system 00:0d: ioport range 0xca0-0xcaf has been reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xfff80000-0xffffffff has been reserved
system 00:0d: iomem range 0xff780000-0xff7fffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x7000-0x9fff
pci 0000:00:01.0:   MEM window: 0xff300000-0xff3fffff
pci 0000:00:01.0:   PREFETCH window: 0xbeb00000-0xdeafffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:02
pci 0000:00:06.0:   IO window: 0xa000-0xbfff
pci 0000:00:06.0:   MEM window: 0xff400000-0xff5fffff
pci 0000:00:06.0:   PREFETCH window: disabled
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x7000-0x9fff]
pci_bus 0000:01: resource 1 mem: [0xff300000-0xff3fffff]
pci_bus 0000:01: resource 2 pref mem [0xbeb00000-0xdeafffff]
pci_bus 0000:02: resource 0 io:  [0xa000-0xbfff]
pci_bus 0000:02: resource 1 mem: [0xff400000-0xff5fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:07.3: boot interrupts on device [1022:746b] already disabled
pci 0000:01:00.0: Boot video device
agpgart-amd64 0000:00:00.0: AMD 8151 AGP Bridge rev B3
agpgart-amd64 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
init_memory_mapping: 00000000e0000000-00000000f0000000
 00e0000000 - 00f0000000 page 2M
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 128MB of IOMMU area in the AGP aperture
microcode: no support for this CPU vendor
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Btrfs loaded
msgmni has been set to 6041
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
AMD768 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
loop: module loaded
pata_amd 0000:00:07.1: version 0.4.1
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:02:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ata1.00: ATA-6: ST3120026A, 8.54, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 
ata1.01: ATA-6: WDC WD2500SB-01KBA0, 08.02D08, max UDMA/100
ata1.01: 488397168 sectors, multi 16: LBA48 
e1000: 0000:02:03.0: e1000_probe: (PCI:33MHz:32-bit) 00:e0:81:2b:c6:dd
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3120026A       8.54 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/111 GiB)
scsi 0:0:1:0: Direct-Access     ATA      WDC WD2500SB-01K 08.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:1:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdb:
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00

sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sda: sda1
sd 0:0:1:0: [sdb] Attached SCSI disk
 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ata2.00: ATAPI: _NEC DVD_RW ND-3540A, 1.01, max UDMA/33
ata2.00: configured for UDMA/33
scsi 1:0:0:0: CD-ROM            _NEC     DVD_RW ND-3540A  1.01 PQ: 0 ANSI: 5
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:02:0b.2: PCI INT C -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:02:0b.2: EHCI Host Controller
ehci_hcd 0000:02:0b.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:02:0b.2: irq 19, io mem 0xff5ff000
ehci_hcd 0000:02:0b.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
Driver 'rtc_cmos' needs updating - please use bus_type methods
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
i2c /dev entries driver
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-
devel@redhat.com
EDAC MC: Ver: 2.1.0 Dec  8 2009
EDAC amd64_edac:  Ver: 3.2.0 Dec  8 2009
EDAC amd64: ECC is enabled by BIOS.
EDAC amd64: ECC is enabled by BIOS.
EDAC MC: Rev E or earlier detected
EDAC MC0: Giving out device to 'amd64_edac' 'RevF': DEV 0000:00:18.2
EDAC MC: Rev E or earlier detected
EDAC MC1: Giving out device to 'amd64_edac' 'RevF': DEV 0000:00:19.2
EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI 
controller': DEV '0000:00:18.2' (POLLED)
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
powernow-k8: Found 1 AMD Opteron(tm) Processor 252 processors (2 cpu cores) 
(version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x6
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0x8
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x8
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x8
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x6
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0x8
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0x8
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x8
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x8
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x8
rtc_cmos 00:02: setting system clock to 2009-12-15 00:11:46 UTC (1260835906)
usb 1-3: new high speed USB device using ehci_hcd and address 2
device fsid 5c40945eb102d7aa-2b8ac816f03a0b89 devid 1 transid 77420 /dev/root
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 4 ports detected
Clocksource tsc unstable (delta = -335021639 ns)
VFS: Mounted root (btrfs filesystem) readonly on device 0:14.
Freeing unused kernel memory: 388k freed
Write protecting the kernel read-only data: 4468k
udev: starting version 149
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:02:00.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:02:00.0: OHCI Host Controller
ohci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:02:00.0: irq 19, io mem 0xff5fd000
ACPI: I/O resource 0000:00:07.2 [0xcc00-0xcc1f] conflicts with ACPI region ECIO 
[0xcc00-0xcc1f]
ACPI: This conflict may cause random problems and system instability
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
ACPI: I/O resource amd756_smbus [0x10e0-0x10ef] conflicts with ACPI region PMIO 
[0x1000-0x10fe]
ACPI: This conflict may cause random problems and system instability
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:02:00.1: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:02:00.1: OHCI Host Controller
ohci_hcd 0000:02:00.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:02:00.1: irq 19, io mem 0xff5fe000
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
scsi 1:0:0:0: Attached scsi generic sg2 type 5
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
sata_sil 0000:02:05.0: version 2.4
sata_sil 0000:02:05.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
scsi2 : sata_sil
scsi3 : sata_sil
scsi4 : sata_sil
scsi5 : sata_sil
ata3: SATA max UDMA/100 mmio m1024@0xff5ffc00 tf 0xff5ffc80 irq 19
ata4: SATA max UDMA/100 mmio m1024@0xff5ffc00 tf 0xff5ffcc0 irq 19
ata5: SATA max UDMA/100 mmio m1024@0xff5ffc00 tf 0xff5ffe80 irq 19
ata6: SATA max UDMA/100 mmio m1024@0xff5ffc00 tf 0xff5ffec0 irq 19
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:02:0b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:02:0b.0: UHCI Host Controller
uhci_hcd 0000:02:0b.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:02:0b.0: irq 17, io base 0x0000a480
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:02:0b.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:02:0b.1: UHCI Host Controller
uhci_hcd 0000:02:0b.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:02:0b.1: irq 18, io base 0x0000a800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
usb 3-1: new low speed USB device using ohci_hcd and address 2
ata3.00: ATA-7: WDC WD3200KS-00PFB0, 21.00M21, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/1)
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200KS-00P 21.0 PQ: 0 ANSI: 5
sd 2:0:0:0: Attached scsi generic sg3 type 0
sd 2:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
 sdc:
sd 2:0:0:0: [sdc] Attached SCSI disk
usb 3-1: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as 
/devices/pci0000:00/0000:00:06.0/0000:02:00.1/usb3/3-1/3-1:1.0/input/input2
generic-usb 0003:046D:C03E.0001: input: USB HID v1.10 Mouse [Logitech USB-PS/2 
Optical Mouse] on usb-0000:02:00.1-1/input0
usb 3-2: new low speed USB device using ohci_hcd and address 3
ata4: SATA link down (SStatus 0 SControl 310)
usb 3-2: configuration #1 chosen from 1 choice
input: Dell Dell USB Keyboard as 
/devices/pci0000:00/0000:00:06.0/0000:02:00.1/usb3/3-2/3-2:1.0/input/input3
generic-usb 0003:413C:2003.0002: input: USB HID v1.10 Keyboard [Dell Dell USB 
Keyboard] on usb-0000:02:00.1-2/input0
ata5: SATA link down (SStatus 0 SControl 310)
ata6: SATA link down (SStatus 0 SControl 310)
EMU10K1_Audigy 0000:02:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
device fsid 684de8a411520e72-b8f11b72f9f953b9 devid 1 transid 53876 
/dev/mapper/sdb
Adding 2104504k swap on /dev/sda2.  Priority:-1 extents:1 across:2104504k 
e1000: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present
[drm] Initialized drm 1.1.0 20060810
[drm] radeon kernel modesetting enabled.
radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
mtrr: type mismatch for e0000000,8000000 old: write-back new: write-combining
[drm] radeon: Initializing kernel modesetting.
[drm] register mmio base: 0xFF3F0000
[drm] register mmio size: 65536
ATOM BIOS: 
[drm] Clocks initialized !
agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
agpgart-amd64 0000:00:00.0: putting AGP V3 device into 4x mode
radeon 0000:01:00.0: putting AGP V3 device into 4x mode
mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 128bits DDR
[TTM] Zone  kernel: Available graphics memory: 1546932 kiB.
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 128M of GTT memory ready.
[drm] Loading RV635 CP Microcode
platform radeon_cp.0: firmware: requesting radeon/RV635_pfp.bin
platform radeon_cp.0: firmware: requesting radeon/RV635_me.bin
[drm] GART: num cpu pages 32768, num gpu pages 32768
[drm] ring test succeeded in 0 usecs
[drm] radeon: ib pool ready.
[drm] ib test succeeded in 0 usecs
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DVI-I
[drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 1:
[drm]   DIN
[drm]   Encoders:
[drm]     TV1: INTERNAL_KLDSCP_DAC2
[drm] Connector 2:
[drm]   DVI-I
[drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[drm]   Encoders:
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
[drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[drm] fb mappable at 0xC0081000
[drm] vram apper at 0xC0000000
[drm] size 7257600
[drm] fb depth is 24
[drm]    pitch is 6912
executing set pll
executing set crtc timing
[drm] TMDS-9: set mode 1680x1050 29
Console: switching to colour frame buffer device 210x65
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.0.0 20080528 for 0000:01:00.0 on minor 0
 Northbridge Error, node 0, core: -1
amd_decode_nb_mce: NBSL: 0x0005001b, NBSL: 0xa4000000
K8 ECC error.


regards,
  Johannes
