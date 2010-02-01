Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0BAO7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:59:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:45815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab0BAO7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:59:13 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: IRQ regression messes up xseries 330 SCI resulting in apic=off - bisected to commit b9c61b70075c87a861262473
Date: Mon, 1 Feb 2010 15:59:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: yinghai@kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       mingo@elte.hu
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7wuZLKkcf2qj7pG"
Message-Id: <201002011559.07869.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7wuZLKkcf2qj7pG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

booting a latest kernel on this machine results in:

PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
PCI: Using configuration type 1 for base access bio: create slab <bio-0> at 0
ACPI: SCI (IRQ30) allocation failed
ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
ACPI: Unable to start the ACPI Interpreter

Later all kind of devices fail...

I could bisect it down to this commit:
commit b9c61b70075c87a8612624736faf4a2de5b1ed30
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Wed May 6 10:10:06 2009 -0700

    x86/pci: update pirq_enable_irq() to setup io apic routing

    So we can set io apic routing only when enabling the device irq.

    This is advantageous for IRQ descriptor allocation affinity: if we set up
    the IO-APIC entry later, we have a chance to allocate the IRQ descriptor
    later and know which device it is on and can set affinity accordingly.

    [ Impact: standardize/enhance irq-enabling sequence for mptable irqs ]

    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    LKML-Reference: <4A01C46E.8000501@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>



Attached are dmesg of an umodified broken 2.6.32 kernel and
dmesg of a 2.6.32 kernel in which I reverted above patch (apic=verbose).
The reverting needed some adjusting and I did this without understanding
the code. I also attach the backported patch reverting above for 2.6.32
which makes the machine work again (see dmesg attachment).
This probably cannot go in, it would be great if someone could help
finding a proper patch for mainline which makes the machine work again.
(The ACPI irq, SCI, is meant to be on IRQ 30, rerouted from IRQ 3 via
APIC source override table, which is rather odd/uncommon. Hope that helps)

Thanks,

    Thomas

--Boundary-00=_7wuZLKkcf2qj7pG
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg_2.6.32_boots_apic_verbose.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.32_boots_apic_verbose.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32.6-pae (geeko@buildhost) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #5 SMP Mon Feb 1 15:18:05 CET 2010
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffec340 (usable)
[    0.000000]  BIOS-e820: 000000003ffec340 - 000000003fff0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3ffec max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 100000000 mask F00000000 write-back
[    0.000000]   2 base 200000000 mask E00000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000040000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003ffec340 (usable)
[    0.000000]  modified: 000000003ffec340 - 000000003fff0000 (ACPI data)
[    0.000000]  modified: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 00e00000
[    0.000000] init_memory_mapping: 0000000000000000-0000000036ffe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0036e00000 page 2M
[    0.000000]  0036e00000 - 0036ffe000 page 4k
[    0.000000] kernel direct mapping tables up to 36ffe000 @ 7000-12000
[    0.000000] RAMDISK: 3724c000 - 37fef453
[    0.000000] Allocated new RAMDISK: 00938000 - 016db453
[    0.000000] Move RAMDISK from 000000003724c000 - 0000000037fef452 to 00938000 - 016db452
[    0.000000] ACPI: RSDP 000fdfd0 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 3ffeff80 0002C (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] ACPI: FACP 3ffeff00 00074 (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] ACPI: DSDT 3ffec340 03AAC (v01 IBM    SEREMRLD 00001000 MSFT 0100000B)
[    0.000000] ACPI: FACS 3ffefe40 00040
[    0.000000] ACPI: APIC 3ffefe80 0005E (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] could not find any ACPI SRAT memory areas.
[    0.000000] failed to get NUMA memory information from SRAT table
[    0.000000] NUMA - single node, flat memory mode
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 3ffec
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000 2c000 30000 34000 38000 3c000 
[    0.000000] node 0 pfn: [0 - 3ffec]
[    0.000000] Reserving 2560 pages of KVA for lmem_map of node 0 at 3f400
[    0.000000] remove_active_range (0, 259072, 261632)
[    0.000000] Reserving total of a00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 36400 max_low_pfn ~ 36ffe
[    0.000000] max_pfn = 3ffec
[    0.000000] 143MB HIGHMEM available.
[    0.000000] 879MB LOWMEM available.
[    0.000000] max_low_pfn = 36ffe, highstart_pfn = 36ffe
[    0.000000] Low memory ends at vaddr f6ffe000
[    0.000000] node 0 will remap to vaddr f6400000 - f6e00000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f6400000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f6400000 to pfn 0003f400
[    0.000000] remap_numa_kva: f6600000 to pfn 0003f600
[    0.000000] remap_numa_kva: f6800000 to pfn 0003f800
[    0.000000] remap_numa_kva: f6a00000 to pfn 0003fa00
[    0.000000] remap_numa_kva: f6c00000 to pfn 0003fc00
[    0.000000] High memory starts at vaddr f6ffe000
[    0.000000]   mapped low ram: 0 - 36ffe000
[    0.000000]   low ram: 0 - 36ffe000
[    0.000000]   node 0 low ram: 00000000 - 36ffe000
[    0.000000]   node 0 bootmap 0000f000 - 00015e00
[    0.000000] (11 early reservations) ==> bootmem [0000000000 - 0036ffe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 000092fec4]    TEXT DATA BSS ==> [0000200000 - 000092fec4]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #5 [0000930000 - 00009371e6]              BRK ==> [0000930000 - 00009371e6]
[    0.000000]   #6 [0000007000 - 000000f000]          PGTABLE ==> [0000007000 - 000000f000]
[    0.000000]   #7 [0000938000 - 00016db453]      NEW RAMDISK ==> [0000938000 - 00016db453]
[    0.000000]   #8 [003f400000 - 003fe00000]          KVA RAM
[    0.000000]   #9 [0036400000 - 0036e00000]           KVA PG ==> [0036400000 - 0036e00000]
[    0.000000]   #10 [000000f000 - 0000016000]          BOOTMAP ==> [000000f000 - 0000016000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009dc00 for 1024 bytes.
[    0.000000] found SMP MP-table at [c009ddd0] 9ddd0
[    0.000000]   mpc: 9dde0-9ded4
[    0.000000] crashkernel reservation failed - memory is in use
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00036ffe
[    0.000000]   HighMem  0x00036ffe -> 0x0003ffec
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0003f400
[    0.000000]     0: 0x0003fe00 -> 0x0003ffec
[    0.000000] On node 0 totalpages: 259461
[    0.000000] free_area_init_node: node 0, pgdat f6400000, node_mem_map f6402000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3961 pages, LIFO batch:0
[    0.000000]   Normal zone: 1728 pages used for memmap
[    0.000000]   Normal zone: 219454 pages, LIFO batch:31
[    0.000000]   HighMem zone: 288 pages used for memmap
[    0.000000]   HighMem zone: 33998 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4e8
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: Assigned apic_id 14
[    0.000000] IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: Assigned apic_id 13
[    0.000000] IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 30 dfl dfl)
[    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] mapped IOAPIC to ffff9000 (fec01000)
[    0.000000] nr_irqs_gsi: 32
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:2 nr_node_ids:8
[    0.000000] PERCPU: Embedded 14 pages/cpu @c1800000 s32984 r0 d24360 u1048576
[    0.000000] pcpu-alloc: s32984 r0 d24360 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257413
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=/dev/disk/by-id/scsi-35005076706c8184b-part3 console=ttyS0,57600 resume=/dev/disk/by-id/scsi-35005076706c8184b-part1 splash=silent crashkernel=128M-:64M@16M showopts apic=verbose
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00036ffe:0003ffec)
[    0.000000] Memory: 1005252k/1048496k available (3505k kernel code, 32588k reserved, 2424k data, 424k init, 137144k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xff5b5000 - 0xfffff000   (10536 kB)
[    0.000000]     pkmap   : 0xff000000 - 0xff200000   (2048 kB)
[    0.000000]     vmalloc : 0xf77fe000 - 0xfeffe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf6ffe000   ( 879 MB)
[    0.000000]       .init : 0xc07cb000 - 0xc0835000   ( 424 kB)
[    0.000000]       .data : 0xc056c417 - 0xc07ca668   (2424 kB)
[    0.000000]       .text : 0xc0200000 - 0xc056c417   (3505 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1128.537 MHz processor.
[    0.012012] Calibrating delay loop (skipped), value calculated using timer frequency.. 2257.07 BogoMIPS (lpj=4514148)
[    0.020145] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
[    0.036165] Security Framework initialized
[    0.040071] AppArmor: AppArmor initialized
[    0.044070] Mount-cache hash table entries: 512
[    0.048362] Initializing cgroup subsys ns
[    0.052017] Initializing cgroup subsys cpuacct
[    0.056010] Initializing cgroup subsys memory
[    0.060031] Initializing cgroup subsys devices
[    0.064008] Initializing cgroup subsys freezer
[    0.068006] Initializing cgroup subsys net_cls
[    0.072085] mce: CPU supports 5 MCE banks
[    0.076038] Performance Events: p6 PMU driver.
[    0.084007] ... version:                0
[    0.088005] ... bit width:              32
[    0.092004] ... generic registers:      2
[    0.096005] ... value mask:             00000000ffffffff
[    0.100005] ... max period:             000000007fffffff
[    0.104005] ... fixed-purpose events:   0
[    0.108005] ... event mask:             0000000000000003
[    0.112015] Checking 'hlt' instruction... OK.
[    0.133820] ACPI: Core revision 20090903
[    0.145886] enabled ExtINT on CPU#0
[    0.148268] Mapping cpu 0 to node 0
[    0.152006] ENABLING IO-APIC IRQs
[    0.156006] init IO_APIC IRQs
[    0.156019] IOAPIC[0]: Set routing entry (14-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.156031] IOAPIC[0]: Set routing entry (14-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.156040] IOAPIC[0]: Set routing entry (14-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.156049] IOAPIC[0]: Set routing entry (14-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.156057] IOAPIC[0]: Set routing entry (14-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.156065] IOAPIC[0]: Set routing entry (14-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.156074] IOAPIC[0]: Set routing entry (14-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.156082] IOAPIC[0]: Set routing entry (14-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.156093] IOAPIC[0]: Set routing entry (14-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
[    0.156101] IOAPIC[0]: Set routing entry (14-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.156110] IOAPIC[0]: Set routing entry (14-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.156119] IOAPIC[0]: Set routing entry (14-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.156127] IOAPIC[0]: Set routing entry (14-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.156136] IOAPIC[0]: Set routing entry (14-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.156144] IOAPIC[0]: Set routing entry (14-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.156151]  13-0 13-1 13-2 13-3 13-4 13-5 13-6 13-7 13-8 13-9 13-10 13-11 13-12 13-13 (apicid-pin) not connected
[    0.156178]   alloc irq_desc for 30 on node 0
[    0.156183]   alloc kstat_irqs on node 0
[    0.156192] IOAPIC[1]: Set routing entry (13-14 -> 0x49 -> IRQ 30 Mode:1 Active:1)
[    0.156198]  13-15 (apicid-pin) not connected
[    0.156334] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.160001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.160001] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.160001] ..... (found apic 0 pin 0) ...
[    0.202581] ....... works.
[    0.204005] CPU0: Intel(R) Pentium(R) III CPU family      1133MHz stepping 01
[    0.216006] Using local APIC timer interrupts.
[    0.216008] calibrating APIC timer ...
[    0.224001] ... lapic delta = 829852
[    0.224001] ... PM-Timer delta = 357976
[    0.224001] ... PM-Timer result ok
[    0.224001] ..... delta 829852
[    0.224001] ..... mult: 35639644
[    0.224001] ..... calibration result: 531105
[    0.224001] ..... CPU clock speed is 1128.2396 MHz.
[    0.224001] ..... host bus clock speed is 132.3105 MHz.
[    0.224834] Booting Node   0, Processors  #1 Ok.
[    0.016000] Initializing CPU#1
[    0.016000] masked ExtINT on CPU#1
[    0.016000] Mapping cpu 1 to node 0
[    0.320114] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.324089] Brought up 2 CPUs
[    0.328008] Total of 2 processors activated (4650.74 BogoMIPS).
[    0.332943] devtmpfs: initialized
[    0.337055] regulator: core version 0.5
[    0.340055] Time: 14:22:24  Date: 02/01/10
[    0.344175] NET: Registered protocol family 16
[    0.352141] ACPI: bus type pci registered
[    0.356530] PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
[    0.360008] PCI: Using configuration type 1 for base access
[    0.365925] bio: create slab <bio-0> at 0
[    0.369306] ACPI: EC: Look up EC in DSDT
[    0.376513] ACPI: Interpreter enabled
[    0.380012] ACPI: (supports S0 S4 S5)
[    0.385701] ACPI: Using IOAPIC for interrupt routing
[    0.396189] ACPI: No dock devices found.
[    0.405770] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.408096] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.408099] * this clock source is slow. If you are sure your timer does not have
[    0.408102] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.412041] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.412045] * this clock source is slow. If you are sure your timer does not have
[    0.412047] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.416061] pci 0000:00:01.0: reg 10 32bit mmio: [0xfeb80000-0xfebfffff]
[    0.416071] pci 0000:00:01.0: reg 14 32bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.416094] pci 0000:00:01.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.416112] pci 0000:00:01.0: supports D1 D2
[    0.416143] pci 0000:00:02.0: reg 10 32bit mmio: [0xfeb7f000-0xfeb7ffff]
[    0.416153] pci 0000:00:02.0: reg 14 io port: [0x2200-0x223f]
[    0.416162] pci 0000:00:02.0: reg 18 32bit mmio: [0xfea00000-0xfeafffff]
[    0.416190] pci 0000:00:02.0: supports D1 D2
[    0.416196] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.420008] pci 0000:00:02.0: PME# disabled
[    0.424041] pci 0000:00:0a.0: reg 10 32bit mmio: [0xfeb7e000-0xfeb7efff]
[    0.424051] pci 0000:00:0a.0: reg 14 io port: [0x2240-0x227f]
[    0.424060] pci 0000:00:0a.0: reg 18 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.424089] pci 0000:00:0a.0: supports D1 D2
[    0.424094] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.428007] pci 0000:00:0a.0: PME# disabled
[    0.432082] pci 0000:00:0f.1: reg 20 io port: [0x700-0x70f]
[    0.432122] pci 0000:00:0f.2: reg 10 32bit mmio: [0xfeb7d000-0xfeb7dfff]
[    0.432183] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.444914] ACPI: PCI Root Bridge [PCI1] (0000:01)
[    0.448100] pci 0000:01:03.0: reg 10 io port: [0x2300-0x23ff]
[    0.448115] pci 0000:01:03.0: reg 14 64bit mmio: [0xeffff000-0xefffffff]
[    0.448135] pci 0000:01:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.448189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
[    0.449336] ACPI: PCI Interrupt Link [LPE1] (IRQs *10)
[    0.453693] ACPI: PCI Interrupt Link [LPE2] (IRQs *10)
[    0.460959] ACPI: PCI Interrupt Link [LPVI] (IRQs) *0, disabled.
[    0.468761] ACPI: PCI Interrupt Link [LPUS] (IRQs *7)
[    0.476380] ACPI: PCI Interrupt Link [LPSA] (IRQs *9)
[    0.481510] ACPI: PCI Interrupt Link [LP1A] (IRQs) *0, disabled.
[    0.491248] ACPI: PCI Interrupt Link [LP1B] (IRQs) *0, disabled.
[    0.495455] ACPI: PCI Interrupt Link [LP2A] (IRQs) *0, disabled.
[    0.500376] ACPI: PCI Interrupt Link [LP2B] (IRQs) *0, disabled.
[    0.508664] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.512014] vgaarb: loaded
[    0.516198] PCI: Using ACPI for IRQ routing
[    0.520277] NetLabel: Initializing
[    0.524006] NetLabel:  domain hash size = 128
[    0.528004] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.532032] NetLabel:  unlabeled traffic allowed by default
[    0.536008] 
[    0.536009] printing PIC contents
[    0.536014] ... PIC  IMR: fffe
[    0.536018] ... PIC  IRR: 0001
[    0.536024] ... PIC  ISR: 0000
[    0.536028] ... PIC ELCR: 0ea8
[    0.536034] printing local APIC contents on CPU#0/3:
[    0.536038] ... APIC ID:      03000000 (3)
[    0.540002] ... APIC VERSION: 00040011
[    0.540002] ... APIC TASKPRI: 00000000 (00)
[    0.540002] ... APIC ARBPRI: 000000e0 (e0)
[    0.540002] ... APIC PROCPRI: 00000000
[    0.540002] ... APIC LDR: 01000000
[    0.540002] ... APIC DFR: ffffffff
[    0.540002] ... APIC SPIV: 000001ff
[    0.540002] ... APIC ISR field:
[    0.540002] 0000000000000000000000000000000000000000000000000000000000000000
[    0.540002] ... APIC TMR field:
[    0.540002] 0000000000000000000000000000000000000000000000000000000000000000
[    0.540002] ... APIC IRR field:
[    0.540002] 0000000000000000000000000000000000000000000000000000000000008000
[    0.540002] ... APIC ESR: 00000000
[    0.540002] ... APIC ICR: 000208fb
[    0.540002] ... APIC ICR2: 02000000
[    0.540002] ... APIC LVTT: 000200ef
[    0.540002] ... APIC LVTPC: 00000400
[    0.540002] ... APIC LVT0: 00010700
[    0.540002] ... APIC LVT1: 00000400
[    0.540002] ... APIC LVTERR: 000000fe
[    0.540002] ... APIC TMICT: 000081aa
[    0.540002] ... APIC TMCCT: 00006319
[    0.540002] ... APIC TDCR: 00000003
[    0.540002] 
[    0.540013] printing local APIC contents on CPU#1/0:
[    0.540021] ... APIC ID:      00000000 (0)
[    0.544002] ... APIC VERSION: 00040011
[    0.544002] ... APIC TASKPRI: 00000000 (00)
[    0.544002] ... APIC ARBPRI: 000000e0 (e0)
[    0.544002] ... APIC PROCPRI: 00000000
[    0.544002] ... APIC LDR: 02000000
[    0.544002] ... APIC DFR: ffffffff
[    0.544002] ... APIC SPIV: 000001ff
[    0.544002] ... APIC ISR field:
[    0.544002] 0000000000000000000000000000000000000000000000000000000000000000
[    0.544002] ... APIC TMR field:
[    0.544002] 0000000000000000000000000000000000000000000000000000000000000000
[    0.544002] ... APIC IRR field:
[    0.544002] 0000000000000000000000000000000000000000000000000000000000008000
[    0.544002] ... APIC ESR: 00000000
[    0.544002] ... APIC ICR: 000008fd
[    0.544002] ... APIC ICR2: 01000000
[    0.544002] ... APIC LVTT: 000200ef
[    0.544002] ... APIC LVTPC: 00010400
[    0.544002] ... APIC LVT0: 00010700
[    0.544002] ... APIC LVT1: 00010400
[    0.544002] ... APIC LVTERR: 000000fe
[    0.544002] ... APIC TMICT: 000081aa
[    0.544002] ... APIC TMCCT: 0000350d
[    0.544002] ... APIC TDCR: 00000003
[    0.544002] 
[    0.605716] number of MP IRQ sources: 17.
[    0.605721] number of IO-APIC #14 registers: 16.
[    0.605725] number of IO-APIC #13 registers: 16.
[    0.605729] testing the IO APIC.......................
[    0.608009] 
[    0.612005] IO APIC #14......
[    0.612009] .... register #00: 0E000000
[    0.612012] .......    : physical APIC id: 0E
[    0.612016] .......    : Delivery Type: 0
[    0.612019] .......    : LTS          : 0
[    0.612023] .... register #01: 000F0011
[    0.612027] .......     : max redirection entries: 000F
[    0.612030] .......     : PRQ implemented: 0
[    0.612034] .......     : IO APIC version: 0011
[    0.612038] .... register #02: 08000000
[    0.612041] .......     : arbitration: 08
[    0.612044] .... IRQ redirection table:
[    0.612047]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    0.612055]  00 003 0    0    0   0   0    1    1    30
[    0.612066]  01 003 0    0    0   0   0    1    1    31
[    0.612076]  02 003 1    0    0   0   0    0    0    32
[    0.612086]  03 003 0    0    0   0   0    1    1    33
[    0.612095]  04 003 0    0    0   0   0    1    1    34
[    0.612105]  05 003 0    0    0   0   0    1    1    35
[    0.612115]  06 003 0    0    0   0   0    1    1    36
[    0.612125]  07 003 0    0    0   0   0    1    1    37
[    0.612135]  08 003 0    0    0   0   0    1    1    38
[    0.612144]  09 003 0    0    0   0   0    1    1    39
[    0.612154]  0a 003 0    0    0   0   0    1    1    3A
[    0.612164]  0b 003 0    0    0   0   0    1    1    3B
[    0.612174]  0c 003 0    0    0   0   0    1    1    3C
[    0.612184]  0d 003 0    0    0   0   0    1    1    3D
[    0.612193]  0e 003 0    0    0   0   0    1    1    3E
[    0.612203]  0f 003 0    0    0   0   0    1    1    3F
[    0.612214] 
[    0.616005] IO APIC #13......
[    0.616009] .... register #00: 0D000000
[    0.616012] .......    : physical APIC id: 0D
[    0.616016] .......    : Delivery Type: 0
[    0.616019] .......    : LTS          : 0
[    0.616023] .... register #01: 000F0011
[    0.616026] .......     : max redirection entries: 000F
[    0.616030] .......     : PRQ implemented: 0
[    0.616034] .......     : IO APIC version: 0011
[    0.616037] .... register #02: 0A000000
[    0.616041] .......     : arbitration: 0A
[    0.616044] .... IRQ redirection table:
[    0.616047]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    0.616054]  00 000 1    0    0   0   0    0    0    00
[    0.616064]  01 000 1    0    0   0   0    0    0    00
[    0.616074]  02 000 1    0    0   0   0    0    0    00
[    0.616084]  03 000 1    0    0   0   0    0    0    00
[    0.616094]  04 000 1    0    0   0   0    0    0    00
[    0.616103]  05 000 1    0    0   0   0    0    0    00
[    0.616113]  06 000 1    0    0   0   0    0    0    00
[    0.616123]  07 000 1    0    0   0   0    0    0    00
[    0.616132]  08 000 1    0    0   0   0    0    0    00
[    0.616142]  09 000 1    0    0   0   0    0    0    00
[    0.616152]  0a 000 1    0    0   0   0    0    0    00
[    0.616161]  0b 000 1    0    0   0   0    0    0    00
[    0.616171]  0c 000 1    0    0   0   0    0    0    00
[    0.616181]  0d 000 1    0    0   0   0    0    0    00
[    0.616190]  0e 003 0    1    0   1   0    1    1    49
[    0.616200]  0f 000 1    0    0   0   0    0    0    00
[    0.616207] IRQ to pin mappings:
[    0.616211] IRQ0 -> 0:0
[    0.616217] IRQ1 -> 0:1
[    0.616222] IRQ2 -> 0:2
[    0.616227] IRQ3 -> 0:3
[    0.616233] IRQ4 -> 0:4
[    0.616238] IRQ5 -> 0:5
[    0.616243] IRQ6 -> 0:6
[    0.616248] IRQ7 -> 0:7
[    0.616254] IRQ8 -> 0:8
[    0.616259] IRQ9 -> 0:9
[    0.616264] IRQ10 -> 0:10
[    0.616270] IRQ11 -> 0:11
[    0.616275] IRQ12 -> 0:12
[    0.616280] IRQ13 -> 0:13
[    0.616286] IRQ14 -> 0:14
[    0.616291] IRQ15 -> 0:15
[    0.616297] IRQ30 -> 1:14
[    0.616308] .................................... done.
[    0.620008] Switching to clocksource tsc
[    0.627556] AppArmor: AppArmor Filesystem Enabled
[    0.637009] pnp: PnP ACPI init
[    0.643151] ACPI: bus type pnp registered
[    0.657380] IOAPIC[0]: Set routing entry (14-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.657480] IOAPIC[0]: Set routing entry (14-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.658055] IOAPIC[0]: Set routing entry (14-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.659666] IOAPIC[0]: Set routing entry (14-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.660388] pnp 00:06: IRQ 5 override to edge, high
[    0.670143] IOAPIC[0]: Set routing entry (14-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.670630] IOAPIC[0]: Set routing entry (14-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.670874] IOAPIC[0]: Set routing entry (14-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.678011] pnp: PnP ACPI: found 14 devices
[    0.686376] ACPI: ACPI bus type pnp unregistered
[    0.695621] system 00:01: ioport range 0x438-0x439 has been reserved
[    0.708315] system 00:01: ioport range 0x430-0x437 has been reserved
[    0.721028] system 00:0c: ioport range 0x600-0x600 has been reserved
[    0.733716] system 00:0c: ioport range 0xf50-0xf58 has been reserved
[    0.781885] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.781892] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.781899] pci_bus 0000:01: resource 0 io:  [0x00-0xffff]
[    0.781905] pci_bus 0000:01: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.782109] NET: Registered protocol family 2
[    0.791109] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.806409] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.825555] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.841162] TCP: Hash tables configured (established 131072 bind 65536)
[    0.854409] TCP reno registered
[    0.861154] NET: Registered protocol family 1
[    0.869954] pci 0000:00:01.0: Boot video device
[    0.870004] pci 0000:00:0a.0: Firmware left e100 interrupts enabled; disabling
[    0.899444] Unpacking initramfs...
[    1.626260] Freeing initrd memory: 13965k freed
[    1.675381] Scanning for low memory corruption every 60 seconds
[    1.687804] audit: initializing netlink socket (disabled)
[    1.698671] type=2000 audit(1265034143.698:1): initialized
[    1.723670] highmem bounce pool size: 64 pages
[    1.732590] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.745738] VFS: Disk quotas dquot_6.5.2
[    1.753684] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.766924] msgmni has been set to 430
[    1.774786] alg: No test for stdrng (krng)
[    1.783093] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.797869] io scheduler noop registered
[    1.805715] io scheduler anticipatory registered
[    1.814951] io scheduler deadline registered
[    1.823540] io scheduler cfq registered (default)
[    1.833299] pci-stub: invalid id string ""
[    1.845247] Non-volatile memory driver v1.3
[    1.853615] Linux agpgart interface v0.103
[    1.861848] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    1.874698] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.887564] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.899087] Fixed MDIO Bus: probed
[    1.905990] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.923185] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.933129] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.943390] mice: PS/2 mouse device common for all mice
[    1.954006] cpuidle: using governor ladder
[    1.962199] cpuidle: using governor menu
[    2.118956] TCP cubic registered
[    2.125523] Using IPI No-Shortcut mode
[    2.133230] PM: Checking image partition /dev/disk/by-id/scsi-35005076706c8184b-part1
[    2.154362] psmouse serio1: ID: 00 02 64
[    3.388111] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input0
[    3.406700] PM: Resume from disk failed.
[    3.406730] registered taskstats version 1
[    3.415164]   Magic number: 14:355:383
[    3.422845] Freeing unused kernel memory: 424k freed
[    3.433369] Write protecting the kernel text: 3508k
[    3.443321] Write protecting the kernel read-only data: 2176k
[    3.631589] SCSI subsystem initialized
[    3.667032]   alloc irq_desc for 28 on node -1
[    3.667042]   alloc kstat_irqs on node -1
[    3.667055] IOAPIC[1]: Set routing entry (13-12 -> 0x51 -> IRQ 28 Mode:1 Active:1)
[    3.667067] aic7xxx 0000:01:03.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
[   18.892056] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   18.892060]         <Adaptec aic7892 Ultra160 SCSI adapter>
[   18.892063]         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   18.892066] 
[   18.935513] scsi 0:0:0:0: Direct-Access     IBM-PSG  DDYS-T18350M  M  S9HA PQ: 0 ANSI: 3
[   18.951678] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   18.962683] scsi target0:0:0: Beginning Domain Validation
[   18.976508] scsi target0:0:0: wide asynchronous
[   18.987877] scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   19.016956] scsi target0:0:0: Ending Domain Validation
[   20.566251] scsi 0:0:8:0: Processor         IBM      FTlV1 S2         0    PQ: 0 ANSI: 2
[   20.582427] scsi target0:0:8: Beginning Domain Validation
[   20.593657] scsi target0:0:8: Ending Domain Validation
[   22.472239] libata version 3.00 loaded.
[   22.479005] scsi1 : pata_serverworks
[   22.486347] scsi2 : pata_serverworks
[   22.493588] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x700 irq 14
[   22.507162] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x708 irq 15
[   22.676436] ata1.00: ATAPI: CRN-8241B, 1.25_b, max MWDMA2
[   22.692394] ata1.00: configured for MWDMA2
[   22.701081] scsi 1:0:0:0: CD-ROM            LG       CD-ROM CRN-8241B 1.25 PQ: 0 ANSI: 5
[   22.952107] Uniform Multi-Platform E-IDE driver
[   23.051975] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   23.073998] udevd version 128 started
[   23.483127] sd 0:0:0:0: [sda] 35548320 512-byte logical blocks: (18.2 GB/16.9 GiB)
[   23.500614] sd 0:0:0:0: [sda] Write Protect is off
[   23.510247] sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
[   23.513946] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   23.535815]  sda: sda1 sda2 sda3
[   23.557012] sd 0:0:0:0: [sda] Attached SCSI disk
[   23.659137] usbcore: registered new interface driver usbfs
[   23.670239] usbcore: registered new interface driver hub
[   23.680964] usbcore: registered new device driver usb
[   23.710175] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.739415] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.752295] ACPI: PCI Interrupt Link [LPUS] enabled at IRQ 7
[   23.763623] IOAPIC[0]: Set routing entry (14-7 -> 0x37 -> IRQ 7 Mode:1 Active:1)
[   23.763636] ohci_hcd 0000:00:0f.2: PCI INT A -> Link[LPUS] -> GSI 7 (level, low) -> IRQ 7
[   23.780009] ohci_hcd 0000:00:0f.2: OHCI Host Controller
[   23.790552] ohci_hcd 0000:00:0f.2: new USB bus registered, assigned bus number 1
[   23.805388] ohci_hcd 0000:00:0f.2: irq 7, io mem 0xfeb7d000
[   23.878034] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   23.891609] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   23.906040] usb usb1: Product: OHCI Host Controller
[   23.915797] usb usb1: Manufacturer: Linux 2.6.32.6-pae ohci_hcd
[   23.927626] usb usb1: SerialNumber: 0000:00:0f.2
[   23.937115] usb usb1: configuration #1 chosen from 1 choice
[   23.948327] hub 1-0:1.0: USB hub found
[   23.955839] hub 1-0:1.0: 2 ports detected
[   24.061246] PM: Marking nosave pages: 0000000000002000 - 0000000000006000
[   24.061259] PM: Marking nosave pages: 000000000009d000 - 0000000000100000
[   24.061268] PM: Basic memory bitmaps created
[   24.079168] PM: Basic memory bitmaps freed
[   24.097762] PM: Starting manual resume from disk
[   24.108105] PM: Resume from partition 8:1
[   24.108109] PM: Checking hibernation image.
[   24.108497] PM: Error -22 checking image file
[   24.108506] PM: Resume from disk failed.
[   24.336065] usb 1-2: new low speed USB device using ohci_hcd and address 2
[   24.486248] kjournald starting.  Commit interval 15 seconds
[   24.508127] EXT3 FS on sda3, internal journal
[   24.522270] EXT3-fs: mounted filesystem with ordered data mode.
[   24.570927] usb 1-2: New USB device found, idVendor=0d3d, idProduct=0001
[   24.584337] usb 1-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   24.598609] usb 1-2: Product: USBPS2
[   24.605997] usb 1-2: configuration #1 chosen from 1 choice
[   24.668344] usbcore: registered new interface driver hiddev
[   24.685704] input: USBPS2 as /devices/pci0000:00/0000:00:0f.2/usb1/1-2/1-2:1.0/input/input1
[   24.702651] generic-usb 0003:0D3D:0001.0001: input,hidraw0: USB HID v1.00 Keyboard [USBPS2] on usb-0000:00:0f.2-2/input0
[   24.732136] input: USBPS2 as /devices/pci0000:00/0000:00:0f.2/usb1/1-2/1-2:1.1/input/input2
[   24.749057] generic-usb 0003:0D3D:0001.0002: input,hidraw1: USB HID v1.00 Mouse [USBPS2] on usb-0000:00:0f.2-2/input1
[   24.770310] usbcore: registered new interface driver usbhid
[   24.781450] usbhid: v2.6:USB HID core driver
[   26.823606] udevd version 128 started
[   27.378981] Floppy drive(s): fd0 is 1.44M
[   27.470719] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   27.481438] scsi 0:0:8:0: Attached scsi generic sg1 type 3
[   27.492471] scsi 1:0:0:0: Attached scsi generic sg2 type 5
[   27.595233] FDC 0 is a National Semiconductor PC87306
[   27.933076] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   27.945300] e100: Copyright(c) 1999-2006 Intel Corporation
[   27.956370]   alloc irq_desc for 27 on node -1
[   27.956376]   alloc kstat_irqs on node -1
[   27.956388] IOAPIC[1]: Set routing entry (13-11 -> 0x59 -> IRQ 27 Mode:1 Active:1)
[   27.956399] e100 0000:00:02.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
[   27.992284] e100 0000:00:02.0: PME# disabled
[   28.001660] e100: eth0: e100_probe: addr 0xfeb7f000, irq 27, MAC addr 00:02:55:c6:00:b8
[   28.010851] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   28.010860] Uniform CD-ROM driver Revision: 3.20
[   28.011141] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   28.039240]   alloc irq_desc for 25 on node -1
[   28.039245]   alloc kstat_irqs on node -1
[   28.039253] IOAPIC[1]: Set routing entry (13-9 -> 0x61 -> IRQ 25 Mode:1 Active:1)
[   28.039261] e100 0000:00:0a.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[   28.074976] e100 0000:00:0a.0: PME# disabled
[   28.084185] e100: eth1: e100_probe: addr 0xfeb7e000, irq 25, MAC addr 00:02:55:c6:00:f0
[   28.151269] agpgart-serverworks 0000:00:00.0: can't determine aperture size
[   28.165202] agpgart-serverworks 0000:00:00.0: agp_backend_initialize() failed
[   28.179476] agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
[   28.187814] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[   28.187948] ACPI: Power Button [PWRF]
[   28.215666] agpgart-serverworks 0000:00:00.1: can't determine aperture size
[   28.229569] agpgart-serverworks 0000:00:00.1: agp_backend_initialize() failed
[   28.243874] agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
[   28.332857] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   28.478500] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[   28.490800] rtc0: alarms up to one year, 242 bytes nvram
[   28.506450] piix4_smbus 0000:00:0f.0: Host SMBus controller not enabled!
[   29.135443] Adding 771080k swap on /dev/sda1.  Priority:-1 extents:1 across:771080k 
[   29.790177] device-mapper: uevent: version 1.0.3
[   29.799787] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   30.110605] loop: module loaded
[   30.393290] fuse init (API version 7.13)
[   32.775410] type=1505 audit(1265034174.773:2): operation="profile_load" pid=1645 name=/bin/ping
[   32.898749] type=1505 audit(1265034174.897:3): operation="profile_load" pid=1697 name=/sbin/klogd
[   33.105170] type=1505 audit(1265034175.105:4): operation="profile_load" pid=1710 name=/sbin/syslog-ng
[   33.318918] type=1505 audit(1265034175.316:5): operation="profile_load" pid=1739 name=/sbin/syslogd
[   33.557338] type=1505 audit(1265034175.557:6): operation="profile_load" pid=1741 name=/usr/sbin/avahi-daemon
[   33.821469] type=1505 audit(1265034175.821:7): operation="profile_load" pid=1742 name=/usr/sbin/identd
[   34.068782] type=1505 audit(1265034176.068:8): operation="profile_load" pid=1753 name=/usr/sbin/mdnsd
[   34.316512] type=1505 audit(1265034176.316:9): operation="profile_load" pid=1772 name=/usr/sbin/nscd
[   34.767494] type=1505 audit(1265034176.764:10): operation="profile_load" pid=1800 name=/usr/sbin/ntpd
[   34.962132] type=1505 audit(1265034176.960:11): operation="profile_load" pid=1826 name=/usr/sbin/traceroute
[  126.657150] microcode: CPU0 sig=0x6b1, pf=0x10, revision=0x1c
[  126.669829] platform microcode: firmware: requesting intel-ucode/06-0b-01
[  126.716996] microcode: CPU1 sig=0x6b1, pf=0x10, revision=0x1c
[  126.728489] platform microcode: firmware: requesting intel-ucode/06-0b-01
[  126.752073] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  127.660292] NET: Registered protocol family 10
[  127.670631] lo: Disabled Privacy Extensions
[  127.744193] ip6_tables: (C) 2000-2006 Netfilter Core Team
[  127.895409] ip_tables: (C) 2000-2006 Netfilter Core Team
[  128.103602] nf_conntrack version 0.5.0 (15931 buckets, 63724 max)
[  132.315356] Bridge firewalling registered
[  132.350599] e100 0000:00:02.0: firmware: requesting e100/d101m_ucode.bin
[  132.400628] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  132.404270] e100: eth0 NIC Link is Up 100 Mbps Full Duplex
[  132.409731] device eth0 entered promiscuous mode
[  132.410316] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  132.418240] br0: port 1(eth0) entering forwarding state
[  132.804925] NET: Registered protocol family 17
[  142.436011] br0: no IPv6 routers present
[  143.244016] eth0: no IPv6 routers present
[  298.226830] SFW2-INext-ACC-TCP IN=br0 OUT= PHYSIN=eth0 MAC=00:02:55:c6:00:b8:00:e0:81:34:56:62:08:00 SRC=10.11.136.1 DST=10.11.137.7 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=40469 DF PROTO=TCP SPT=60729 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A57BA873E0000000001030302) 
[  798.952563] SFW2-OUT-ERROR IN= OUT=br0 SRC=10.11.137.7 DST=10.11.136.1 LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=TCP SPT=22 DPT=60729 WINDOW=0 RES=0x00 RST URGP=0 
[  805.676448] SFW2-INext-ACC-TCP IN=br0 OUT= PHYSIN=eth0 MAC=00:02:55:c6:00:b8:00:1c:17:f3:5c:4b:08:00 SRC=10.10.2.125 DST=10.11.137.7 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=63714 DF PROTO=TCP SPT=59019 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080AED3641DC0000000001030307) 

--Boundary-00=_7wuZLKkcf2qj7pG
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg_2.6.32_does_not_boot.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.32_does_not_boot.txt"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32.3-0.3-default (geeko@buildhost) (gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux) ) #1 SMP 2010-01-12 12:31:10 +0100
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
[    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffec340 (usable)
[    0.000000]  BIOS-e820: 000000003ffec340 - 000000003fff0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn = 0x3ffec max_arch_pfn = 0x100000
[    0.000000] PAT not supported by CPU.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009dc00 (usable)
[    0.000000]  modified: 000000000009dc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003ffec340 (usable)
[    0.000000]  modified: 000000003ffec340 - 000000003fff0000 (ACPI data)
[    0.000000]  modified: 000000003fff0000 - 0000000040000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000] RAMDISK: 36beb000 - 37fef6c9
[    0.000000] Allocated new RAMDISK: 00953000 - 01d576c9
[    0.000000] Move RAMDISK from 0000000036beb000 - 0000000037fef6c8 to 00953000 - 01d576c8
[    0.000000] ACPI: RSDP 000fdfd0 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 3ffeff80 0002C (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] ACPI: FACP 3ffeff00 00074 (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] ACPI: DSDT 3ffec340 03AAC (v01 IBM    SEREMRLD 00001000 MSFT 0100000B)
[    0.000000] ACPI: FACS 3ffefe40 00040
[    0.000000] ACPI: APIC 3ffefe80 0005E (v01 IBM    SEREMRLD 00001000 IBM  45444F43)
[    0.000000] 139MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00009000 - 0000fe80
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 000094ed84]    TEXT DATA BSS ==> [0000200000 - 000094ed84]
[    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
[    0.000000]   #5 [000094f000 - 00009521e6]              BRK ==> [000094f000 - 00009521e6]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000953000 - 0001d576c9]      NEW RAMDISK ==> [0000953000 - 0001d576c9]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c009ddd0] 9ddd0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003ffec
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x0003ffec
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x4e8
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 30 dfl dfl)
[    0.000000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c2800000 s32152 r0 d21096 u2097152
[    0.000000] pcpu-alloc: s32152 r0 d21096 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259973
[    0.000000] Kernel command line: install=nfs://10.10.0.100/dist/install/SLP/SLES-11-SP1-Beta2/i386/DVD1 ssh=1 sshpassword=qwerty console=ttyS0,57600
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0003ffec)
[    0.000000] Memory: 1010400k/1048496k available (3587k kernel code, 37148k reserved, 2477k data, 412k init, 143288k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd34000 - 0xfffff000   (2860 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc07ed000 - 0xc0854000   ( 412 kB)
[    0.000000]       .data : 0xc0580f95 - 0xc07ec3c8   (2477 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0580f95   (3587 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1128.537 MHz processor.
[    0.012014] Calibrating delay loop (skipped), value calculated using timer frequency.. 2257.07 BogoMIPS (lpj=4514148)
[    0.020122] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All Rights Reserved
kdb_cmd[0]: defcmd archkdb "" "First line arch debugging"
kdb_cmd[8]: defcmd archkdbcpu "" "archkdb with only tasks on cpus"
kdb_cmd[15]: defcmd archkdbshort "" "archkdb with less detailed backtrace"
[    0.036154] Security Framework initialized
[    0.040082] AppArmor: AppArmor initialized
[    0.044051] Mount-cache hash table entries: 512
[    0.048321] Initializing cgroup subsys ns
[    0.052016] Initializing cgroup subsys cpuacct
[    0.056010] Initializing cgroup subsys memory
[    0.060019] Initializing cgroup subsys devices
[    0.064008] Initializing cgroup subsys freezer
[    0.068006] Initializing cgroup subsys net_cls
[    0.072065] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.080005] CPU: L2 cache: 512K
[    0.084012] mce: CPU supports 5 MCE banks
[    0.088037] Performance Events: p6 PMU driver.
[    0.096011] ... version:                0
[    0.100005] ... bit width:              32
[    0.104005] ... generic registers:      2
[    0.108005] ... value mask:             00000000ffffffff
[    0.112005] ... max period:             000000007fffffff
[    0.116005] ... fixed-purpose events:   0
[    0.120005] ... event mask:             0000000000000003
[    0.124012] Checking 'hlt' instruction... OK.
[    0.145858] ACPI: Core revision 20090903
[    0.160372] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.164001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.164001] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.164001] ..... (found apic 0 pin 0) ...
[    0.203913] ....... works.
[    0.204005] CPU0: Intel(R) Pentium(R) III CPU family      1133MHz stepping 01
[    0.216001] Booting processor 1 APIC 0x0 ip 0x6000
[    0.016000] Initializing CPU#1
[    0.016000] Calibrating delay using timer specific routine.. 2257.26 BogoMIPS (lpj=4514526)
[    0.016000] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.016000] CPU: L2 cache: 512K
[    0.308088] CPU1: Intel(R) Pentium(R) III CPU family      1133MHz stepping 01
[    0.320014] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.324084] Brought up 2 CPUs
[    0.328009] Total of 2 processors activated (4514.33 BogoMIPS).
[    0.332836] devtmpfs: initialized
[    0.336984] regulator: core version 0.5
[    0.340055] Time: 12:27:03  Date: 01/21/10
[    0.344168] NET: Registered protocol family 16
[    0.348244] ACPI: bus type pci registered
[    0.352547] PCI: PCI BIOS revision 2.10 entry at 0xfd61c, last bus=1
[    0.356008] PCI: Using configuration type 1 for base access
[    0.365174] bio: create slab <bio-0> at 0
[    0.369228] ACPI: SCI (IRQ30) allocation failed
[    0.372009] ACPI Exception: AE_NOT_ACQUIRED, Unable to install System Control Interrupt handler (20090903/evevent-161)
[    0.384005] ACPI: Unable to start the ACPI Interpreter
[    0.392564] vgaarb: loaded
[    0.396134] PCI: Probing PCI hardware
[    0.400084] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.400087] * this clock source is slow. If you are sure your timer does not have
[    0.400090] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.404042] * The chipset may have PM-Timer Bug. Due to workarounds for a bug,
[    0.404046] * this clock source is slow. If you are sure your timer does not have
[    0.404049] * this bug, please use "acpi_pm_good" to disable the workaround
[    0.408194] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.412009] pci 0000:00:02.0: PME# disabled
[    0.416094] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.420008] pci 0000:00:0a.0: PME# disabled
[    0.424293] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.432170] PCI: Discovered peer bus 01
[    0.440369] NetLabel: Initializing
[    0.444007] NetLabel:  domain hash size = 128
[    0.448007] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.452030] NetLabel:  unlabeled traffic allowed by default
[    0.456018] Switching to clocksource tsc
[    0.463162] AppArmor: AppArmor Filesystem Enabled
[    0.472589] pnp: PnP ACPI: disabled
[    0.479567] PnPBIOS: Scanning system for PnP BIOS support...
[    0.490986] PnPBIOS: Found PnP BIOS installation structure at 0xc00fde40
[    0.504383] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x3a09, dseg 0xf0000
[    0.518725] pnp 00:01: unknown tag 0x0 length 0
[    0.527791] pnp 00:01: unknown tag 0x0 length 0
[    0.536847] pnp 00:01: unknown tag 0x0 length 0
[    0.545893] pnp 00:01: unknown tag 0x0 length 0
[    0.554953] pnp 00:01: unknown tag 0x0 length 0
[    0.563999] pnp 00:01: unknown tag 0x0 length 0
[    0.573043] pnp 00:01: unknown tag 0x0 length 0
[    0.582089] pnp 00:01: unknown tag 0x0 length 0
[    0.591150] pnp 00:01: unknown tag 0x0 length 0
[    0.600194] pnp 00:01: unknown tag 0x0 length 0
[    0.609241] pnp 00:01: unknown tag 0x0 length 0
[    0.618286] pnp 00:01: unknown tag 0x0 length 0
[    0.627345] pnp 00:01: no end tag in resource structure
[    0.638357] pnp 00:08: mem resource (0xe00-0xfff) overlaps 0000:00:01.0 BAR 6 (0x0-0xffff), disabling
[    0.656783] pnp 00:08: mem resource (0xe00-0xfff) overlaps 0000:01:03.0 BAR 6 (0x0-0x1ffff), disabling
[    0.675848] PnPBIOS: 19 nodes reported by PnP BIOS; 19 recorded by driver
[    0.691793] system 00:01: ioport range 0xfd00-0xfd3f has been reserved
[    0.704835] system 00:01: ioport range 0xfe00-0xfe0f has been reserved
[    0.717882] system 00:01: ioport range 0x4e0-0x4ff has been reserved
[    0.730583] system 00:01: ioport range 0x900-0x90f has been reserved
[    0.743282] system 00:01: ioport range 0x430-0x439 has been reserved
[    0.756011] system 00:09: iomem range 0xfffc0000-0xffffffff has been reserved
[    0.770266] system 00:09: iomem range 0xfff00000-0xfffbffff has been reserved
[    0.784529] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.797741] system 00:0a: iomem range 0x100000-0x3fffffff could not be reserved
[    0.847977] NET: Registered protocol family 2
[    0.856968] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.872254] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.891487] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.907114] TCP: Hash tables configured (established 131072 bind 65536)
[    0.920359] TCP reno registered
[    0.927066] NET: Registered protocol family 1
[    0.935895] pci 0000:00:02.0: Firmware left e100 interrupts enabled; disabling
[    0.952592] pci 0000:00:0a.0: Firmware left e100 interrupts enabled; disabling
[    0.980952] Unpacking initramfs...
[    2.146256] Freeing initrd memory: 20497k freed
[    2.214680] Scanning for low memory corruption every 60 seconds
[    2.227028] audit: initializing netlink socket (disabled)
[    2.237898] type=2000 audit(1264076823.236:1): initialized
[    2.263108] highmem bounce pool size: 64 pages
[    2.272018] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.285569] VFS: Disk quotas dquot_6.5.2
[    2.293504] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.306869] msgmni has been set to 433
[    2.314603] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    2.329387] io scheduler noop registered
[    2.337250] io scheduler anticipatory registered
[    2.346483] io scheduler deadline registered
[    2.355068] io scheduler cfq registered (default)
[    2.364793] pci-stub: invalid id string ""
[    2.373213] isapnp: Scanning for PnP cards...
[    2.735064] isapnp: No Plug & Play device found
[    2.747466] Non-volatile memory driver v1.3
[    2.755850] Linux agpgart interface v0.103
[    2.764090] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    2.776937] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.789691] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.801067] PNPBIOS fault.. attempting recovery.
[    2.810296] PnPBIOS: Warning! Your PnP BIOS caused a fatal error. Attempting to continue
[    2.826459] PnPBIOS: You may need to reboot with the "pnpbios=off" option to operate stably
[    2.843146] PnPBIOS: Check with your vendor for an updated BIOS
[    2.854982] PnPBIOS: set_dev_node: unexpected status 0x3a
[    2.865775] serial 00:04: activation failed
[    2.874149] serial: probe of 00:04 failed with error -5
[    2.885179] Fixed MDIO Bus: probed
[    2.892089] PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
[    2.907533] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.917480] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.927740] mice: PS/2 mouse device common for all mice
[    2.938387] cpuidle: using governor ladder
[    2.946574] cpuidle: using governor menu
[    3.107720] TCP cubic registered
[    3.114285] Using IPI No-Shortcut mode
[    3.122030] registered taskstats version 1
[    3.130457]   Magic number: 10:743:481
[    3.138129] Freeing unused kernel memory: 412k freed
[    3.148648] Write protecting the kernel text: 3588k
[    3.158509] Write protecting the kernel read-only data: 2264k
Moving into tmpfs... done.
[    3.706727] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found

>>> SUSE Linux Enterprise Server 11 installation program v3.3.48 (c) 1996-2009 SUSE Linux Products GmbH <<<
Starting udev... [    3.746419] udevd version 128 started
[    3.793855] agpgart-serverworks 0000:00:00.0: can't determine aperture size
[    3.807814] agpgart-serverworks 0000:00:00.0: agp_backend_initialize() failed
[    3.822083] agpgart-serverworks: probe of 0000:00:00.0 failed with error -22
[    3.836196] agpgart-serverworks 0000:00:00.1: can't determine aperture size
[    3.850105] agpgart-serverworks 0000:00:00.1: agp_backend_initialize() failed
[    3.864372] agpgart-serverworks: probe of 0000:00:00.1 failed with error -22
[    3.878281] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    3.878287] e100: Copyright(c) 1999-2006 Intel Corporation
[    3.931834] e100 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
[    3.970051] e100 0000:00:02.0: PME# disabled
[    3.979356] e100: eth0: e100_probe: addr 0xfeb7f000, irq 10, MAC addr 00:02:55:c6:00:b8
[    3.995386] e100 0000:00:0a.0: can't find IRQ for PCI INT A; probably buggy MP table
[    4.033485] e100 0000:00:0a.0: PME# disabled
[    4.042652] e100: eth1: e100_probe: addr 0xfeb7e000, irq 10, MAC addr 00:02:55:c6:00:f0
[    4.102684] usbcore: registered new interface driver usbfs
[    4.113798] usbcore: registered new interface driver hub
[    4.131974] usbcore: registered new device driver usb
[    4.196009] SCSI subsystem initialized
[    4.223483] aic7xxx 0000:01:03.0: can't find IRQ for PCI INT A; probably buggy MP table
[    4.382180] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input0
[    4.469979] PnPBIOS: get_dev_node: function not supported on this system
[    4.483382] parport_pc 00:05: activation failed
[    4.492437] parport_pc: probe of 00:05 failed with error -5
[    4.515425] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    4.522239] Floppy drive(s): fd0 is 1.44M
[    4.537378] rtc_cmos 00:0e: rtc core: registered rtc_cmos as rtc0
[    4.549604] rtc0: alarms up to one day, 114 bytes nvram
[    4.568802] FDC 0 is a National Semiconductor PC87306
[    4.593672] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.647469] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.659886] ohci_hcd 0000:00:0f.2: can't find IRQ for PCI INT A; probably buggy MP table
[    4.676080] ohci_hcd 0000:00:0f.2: OHCI Host Controller
[    4.686589] ohci_hcd 0000:00:0f.2: new USB bus registered, assigned bus number 1
[    4.701406] ohci_hcd 0000:00:0f.2: irq 7, io mem 0xfeb7d000
[    4.775058] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.788667] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.803105] usb usb1: Product: OHCI Host Controller
[    4.812868] usb usb1: Manufacturer: Linux 2.6.32.3-0.3-default ohci_hcd
[    4.826078] usb usb1: SerialNumber: 0000:00:0f.2
[    4.835573] usb usb1: configuration #1 chosen from 1 choice
[    4.846797] hub 1-0:1.0: USB hub found
[    4.854309] hub 1-0:1.0: 2 ports detected
[    4.862899] scsi1 : pata_serverworks
[    4.870378] scsi2 : pata_serverworks
[    4.877630] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x700 irq 14
[    4.891199] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x708 irq 15
[    5.060469] ata1.00: ATAPI: CRN-8241B, 1.25_b, max MWDMA2
[    5.076399] ata1.00: configured for MWDMA2
[    5.085164] scsi 1:0:0:0: CD-ROM            LG       CD-ROM CRN-8241B 1.25 PQ: 0 ANSI: 5
[    5.236030] usb 1-2: new low speed USB device using ohci_hcd and address 2
[    5.313815] Uniform Multi-Platform E-IDE driver
[    5.348425] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[    5.360809] Uniform CD-ROM driver Revision: 3.20
[    5.383686] sr 1:0:0:0: Attached scsi generic sg0 type 5
[   10.248034] ohci_hcd 0000:00:0f.2: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
[   19.452039] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   19.452042]         <Adaptec aic7892 Ultra160 SCSI adapter>
[   19.452044]         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   19.452047] 
[   40.816044] scsi 0:0:0:0: Attempting to queue an ABORT message
[   40.827712] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[   40.836150] scsi 0:0:0:0: Command already completed
[   40.845901] aic7xxx_abort returns 0x2002
[   70.852030] scsi 0:0:0:0: Attempting to queue an ABORT message
[   70.863691] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[   70.872199] scsi0: At time of recovery, card was paused
[   70.872475] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[   70.872475] scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x103
[   70.872475] Card was paused
[   70.872475] ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
[   70.872475] HCNT = 0x0 SCBPTR = 0x0
[   70.872475] SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
[   70.872475] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xe0]:(MSGI|IOI|CDI) 
[   70.872475] SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
[   70.872475] SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
[   70.872475] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] 
[   70.872475] SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE) 
[   70.872475] SSTAT1[0x11]:(REQINIT|PHASEMIS) 
[   70.872475] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
[   70.872475] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
[   70.872475] SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
[   70.872475] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[   70.872475] STACK: 0x0 0x164 0x179 0x102
[   70.872475] SCB count = 4
[   70.872475] Kernel NEXTQSCB = 3
[   70.872475] Card NEXTQSCB = 2
[   70.872475] QINFIFO entries: 2 
[   70.872475] Waiting Queue entries: 
[   70.872475] Disconnected Queue entries: 
[   70.872475] QOUTFIFO entries: 
[   70.872475] Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[   70.872475] Sequencer SCB Info: 
[   70.872475]   0 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
[   70.872475] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
[   70.872475]   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[   70.872475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[   70.872475] Pending list: 
[   70.872475]   2 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
[   70.872475] Kernel Free SCB list: 1 0 
[   70.872475] Untagged Q(0): 2 
[   70.872475] 
[   70.872475] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[   70.872475] scsi0:0:0:0: Cmd aborted from QINFIFO
[   72.031375] aic7xxx_abort returns 0x2002
[   72.039251] scsi 0:0:0:0: Attempting to queue a TARGET RESET message
[   72.051942] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[   72.060380] scsi 0:0:0:0: Command not found
[   72.068751] aic7xxx_dev_reset returns 0x2002
[  102.076020] scsi 0:0:0:0: Attempting to queue an ABORT message
[  102.087680] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  102.095770] scsi 0:0:0:0: Command already completed
[  102.105524] aic7xxx_abort returns 0x2002
[  142.116019] scsi 0:0:0:0: Attempting to queue an ABORT message
[  142.127677] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  142.135771] scsi0: At time of recovery, card was paused
[  142.136464] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[  142.136464] scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x196
[  142.136464] Card was paused
[  142.136464] ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
[  142.136464] HCNT = 0x0 SCBPTR = 0x0
[  142.136464] SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
[  142.136464] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xe0]:(MSGI|IOI|CDI) 
[  142.136464] SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
[  142.136464] SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
[  142.136464] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] 
[  142.136464] SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE) 
[  142.136464] SSTAT1[0x11]:(REQINIT|PHASEMIS) 
[  142.136464] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
[  142.136464] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
[  142.136464] SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
[  142.136464] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[  142.136464] STACK: 0x102 0x0 0x164 0x179
[  142.136464] SCB count = 4
[  142.136464] Kernel NEXTQSCB = 3
[  142.136464] Card NEXTQSCB = 2
[  142.136464] QINFIFO entries: 2 
[  142.136464] Waiting Queue entries: 
[  142.136464] Disconnected Queue entries: 
[  142.136464] QOUTFIFO entries: 
[  142.136464] Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[  142.136464] Sequencer SCB Info: 
[  142.136464]   0 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
[  142.136464] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0x2] 
[  142.136464]   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  142.136464] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  142.136464] Pending list: 
[  142.136464]   2 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
[  142.136464] Kernel Free SCB list: 1 0 
[  142.136464] Untagged Q(0): 2 
[  142.136464] 
[  142.136464] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[  142.136464] scsi0:0:0:0: Cmd aborted from QINFIFO
[  143.294360] aic7xxx_abort returns 0x2002
[  143.302214] scsi 0:0:0:0: Device offlined - not ready after error recovery
[  164.816032] scsi 0:0:1:0: Attempting to queue an ABORT message
[  164.827687] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  164.836214] scsi 0:0:1:0: Command already completed
[  164.845964] aic7xxx_abort returns 0x2002
ok
[  194.852030] scsi 0:0:1:0: Attempting to queue an ABORT message
[  194.863702] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  194.871876] scsi 0:0:1:0: Command already completed
[  194.881632] aic7xxx_abort returns 0x2002
[  194.889487] scsi 0:0:1:0: Attempting to queue a TARGET RESET message
[  194.902178] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  194.910591] scsi 0:0:1:0: Command not found
[  194.918951] aic7xxx_dev_reset returns 0x2002
[  224.924019] scsi 0:0:1:0: Attempting to queue an ABORT message
[  224.935677] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  224.943834] scsi 0:0:1:0: Command already completed
[  224.953592] aic7xxx_abort returns 0x2002
[  264.964019] scsi 0:0:1:0: Attempting to queue an ABORT message
[  264.975675] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  264.983832] scsi 0:0:1:0: Command already completed
[  264.993591] aic7xxx_abort returns 0x2002
[  265.001439] scsi 0:0:1:0: Device offlined - not ready after error recovery
[  285.816025] scsi 0:0:2:0: Attempting to queue an ABORT message
[  285.827676] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  285.836198] scsi 0:0:2:0: Command already completed
[  285.845951] aic7xxx_abort returns 0x2002
^[[D    [  315.852018] scsi 0:0:2:0: Attempting to queue an ABORT message
[  315.863681] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  315.871836] scsi 0:0:2:0: Command already completed
[  315.881578] aic7xxx_abort returns 0x2002
[  315.889427] scsi 0:0:2:0: Attempting to queue a TARGET RESET message
[  315.902121] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  315.910534] scsi 0:0:2:0: Command not found
[  315.918893] aic7xxx_dev_reset returns 0x2002
[  345.924018] scsi 0:0:2:0: Attempting to queue an ABORT message
[  345.935670] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  345.943826] scsi 0:0:2:0: Command already completed
[  345.953568] aic7xxx_abort returns 0x2002
[  385.964018] scsi 0:0:2:0: Attempting to queue an ABORT message
[  385.975679] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  385.983834] scsi 0:0:2:0: Command already completed
[  385.993593] aic7xxx_abort returns 0x2002
[  386.001446] scsi 0:0:2:0: Device offlined - not ready after error recovery
[  407.000026] scsi 0:0:3:0: Attempting to queue an ABORT message
[  407.011679] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  407.020187] scsi 0:0:3:0: Command already completed
[  407.029941] aic7xxx_abort returns 0x2002
[  437.036024] scsi 0:0:3:0: Attempting to queue an ABORT message
[  437.047688] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  437.055840] scsi 0:0:3:0: Command already completed
[  437.065583] aic7xxx_abort returns 0x2002
[  437.073432] scsi 0:0:3:0: Attempting to queue a TARGET RESET message
[  437.086127] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  437.094541] scsi 0:0:3:0: Command not found
[  437.102899] aic7xxx_dev_reset returns 0x2002
[  467.108024] scsi 0:0:3:0: Attempting to queue an ABORT message
[  467.119679] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  467.127832] scsi 0:0:3:0: Command already completed
[  467.137575] aic7xxx_abort returns 0x2002
[  507.148024] scsi 0:0:3:0: Attempting to queue an ABORT message
[  507.159676] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  507.167830] scsi 0:0:3:0: Command already completed
[  507.177590] aic7xxx_abort returns 0x2002
[  507.185437] scsi 0:0:3:0: Device offlined - not ready after error recovery
[  528.000021] scsi 0:0:4:0: Attempting to queue an ABORT message
[  528.011689] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  528.020197] scsi 0:0:4:0: Command already completed
[  528.029949] aic7xxx_abort returns 0x2002
[  558.036017] scsi 0:0:4:0: Attempting to queue an ABORT message
[  558.047681] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  558.055838] scsi 0:0:4:0: Command already completed
[  558.065581] aic7xxx_abort returns 0x2002
[  558.073431] scsi 0:0:4:0: Attempting to queue a TARGET RESET message
[  558.086130] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  558.094546] scsi 0:0:4:0: Command not found
[  558.102905] aic7xxx_dev_reset returns 0x2002
[  588.108017] scsi 0:0:4:0: Attempting to queue an ABORT message
[  588.119674] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  588.127830] scsi 0:0:4:0: Command already completed
[  588.137589] aic7xxx_abort returns 0x2002
[  628.148018] scsi 0:0:4:0: Attempting to queue an ABORT message
[  628.159674] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  628.167830] scsi 0:0:4:0: Command already completed
[  628.177572] aic7xxx_abort returns 0x2002
[  628.185422] scsi 0:0:4:0: Device offlined - not ready after error recovery
[  649.000021] scsi 0:0:5:0: Attempting to queue an ABORT message
[  649.011673] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  649.020182] scsi 0:0:5:0: Command already completed
[  649.029935] aic7xxx_abort returns 0x2002
[  679.036025] scsi 0:0:5:0: Attempting to queue an ABORT message
[  679.047681] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  679.055837] scsi 0:0:5:0: Command already completed
[  679.065594] aic7xxx_abort returns 0x2002
[  679.073443] scsi 0:0:5:0: Attempting to queue a TARGET RESET message
[  679.086140] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  679.094556] scsi 0:0:5:0: Command not found
[  679.102915] aic7xxx_dev_reset returns 0x2002
[  709.108024] scsi 0:0:5:0: Attempting to queue an ABORT message
[  709.119677] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  709.127831] scsi 0:0:5:0: Command already completed
[  709.137574] aic7xxx_abort returns 0x2002
[  749.148023] scsi 0:0:5:0: Attempting to queue an ABORT message
[  749.159686] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  749.167839] scsi 0:0:5:0: Command already completed
[  749.177582] aic7xxx_abort returns 0x2002
[  749.185429] scsi 0:0:5:0: Device offlined - not ready after error recovery
[  770.000021] scsi 0:0:6:0: Attempting to queue an ABORT message
[  770.011682] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  770.020190] scsi 0:0:6:0: Command already completed
[  770.029941] aic7xxx_abort returns 0x2002
[  800.036018] scsi 0:0:6:0: Attempting to queue an ABORT message
[  800.047672] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  800.055826] scsi 0:0:6:0: Command already completed
[  800.065567] aic7xxx_abort returns 0x2002
[  800.073418] scsi 0:0:6:0: Attempting to queue a TARGET RESET message
[  800.086113] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  800.094526] scsi 0:0:6:0: Command not found
[  800.102886] aic7xxx_dev_reset returns 0x2002
[  830.108017] scsi 0:0:6:0: Attempting to queue an ABORT message
[  830.119683] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  830.127838] scsi 0:0:6:0: Command already completed
[  830.137596] aic7xxx_abort returns 0x2002
[  870.148018] scsi 0:0:6:0: Attempting to queue an ABORT message
[  870.159666] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  870.167821] scsi 0:0:6:0: Command already completed
[  870.177581] aic7xxx_abort returns 0x2002
[  870.185427] scsi 0:0:6:0: Device offlined - not ready after error recovery
[  891.000021] scsi 0:0:8:0: Attempting to queue an ABORT message
[  891.011683] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  891.020127] scsi 0:0:8:0: Command already completed
[  891.029873] aic7xxx_abort returns 0x2002
[  921.036024] scsi 0:0:8:0: Attempting to queue an ABORT message
[  921.047683] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  921.056190] scsi0: At time of recovery, card was paused
[  921.056475] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[  921.056475] scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x103
[  921.056475] Card was paused
[  921.056475] ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
[  921.056475] HCNT = 0x0 SCBPTR = 0x0
[  921.056475] SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
[  921.056475] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xe0]:(MSGI|IOI|CDI) 
[  921.056475] SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
[  921.056475] SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
[  921.056475] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] 
[  921.056475] SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE) 
[  921.056475] SSTAT1[0x11]:(REQINIT|PHASEMIS) 
[  921.056475] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
[  921.056475] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
[  921.056475] SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
[  921.056475] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[  921.056475] STACK: 0x0 0x164 0x179 0x102
[  921.056475] SCB count = 4
[  921.056475] Kernel NEXTQSCB = 3
[  921.056475] Card NEXTQSCB = 2
[  921.056475] QINFIFO entries: 2 
[  921.056475] Waiting Queue entries: 
[  921.056475] Disconnected Queue entries: 
[  921.056475] QOUTFIFO entries: 
[  921.056475] Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[  921.056475] Sequencer SCB Info: 
[  921.056475]   0 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
[  921.056475] SCB_SCSIID[0x87]:(TWIN_CHNLB) SCB_LUN[0x0] 
[  921.056475] SCB_TAG[0xff] 
[  921.056475]   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  921.056475] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  921.056475] Pending list: 
[  921.056475]   2 SCB_CONTROL[0x0] SCB_SCSIID[0x87]:(TWIN_CHNLB) 
[  921.056475] SCB_LUN[0x0] 
[  921.056475] Kernel Free SCB list: 1 0 
[  921.056475] Untagged Q(8): 2 
[  921.056475] 
[  921.056475] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[  921.056475] scsi0:0:8:0: Cmd aborted from QINFIFO
[  922.226131] aic7xxx_abort returns 0x2002
[  922.233984] scsi 0:0:8:0: Attempting to queue a TARGET RESET message
[  922.246680] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[  922.255109] scsi 0:0:8:0: Command not found
[  922.263468] aic7xxx_dev_reset returns 0x2002
[  952.272018] scsi 0:0:8:0: Attempting to queue an ABORT message
[  952.283681] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  952.291770] scsi 0:0:8:0: Command already completed
[  952.301524] aic7xxx_abort returns 0x2002
[  992.312027] scsi 0:0:8:0: Attempting to queue an ABORT message
[  992.323683] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[  992.331781] scsi0: At time of recovery, card was paused
[  992.332474] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
[  992.332474] scsi0: Dumping Card State in Message-in phase, at SEQADDR 0x196
[  992.332474] Card was paused
[  992.332474] ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4, ARG_2 = 0x0
[  992.332474] HCNT = 0x0 SCBPTR = 0x0
[  992.332474] SCSIPHASE[0x8]:(MSG_IN_PHASE) SCSISIGI[0xe6]:(REQI|BSYI|MSGI|IOI|CDI) 
[  992.332474] ERROR[0x0] SCSIBUSL[0x0] LASTPHASE[0xe0]:(MSGI|IOI|CDI) 
[  992.332474] SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
[  992.332474] SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
[  992.332474] SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] 
[  992.332474] SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE) 
[  992.332474] SSTAT1[0x11]:(REQINIT|PHASEMIS) 
[  992.332474] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP) 
[  992.332474] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
[  992.332474] SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
[  992.332474] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
[  992.332474] STACK: 0x102 0x0 0x164 0x179
[  992.332474] SCB count = 4
[  992.332474] Kernel NEXTQSCB = 3
[  992.332474] Card NEXTQSCB = 2
[  992.332474] QINFIFO entries: 2 
[  992.332474] Waiting Queue entries: 
[  992.332474] Disconnected Queue entries: 
[  992.332474] QOUTFIFO entries: 
[  992.332474] Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
[  992.332474] Sequencer SCB Info: 
[  992.332474]   0 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
[  992.332474] SCB_SCSIID[0x87]:(TWIN_CHNLB) SCB_LUN[0x0] 
[  992.332474] SCB_TAG[0x2] 
[  992.332474]   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474]  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
[  992.332474] SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
[  992.332474] Pending list: 
[  992.332474]   2 SCB_CONTROL[0x0] SCB_SCSIID[0x87]:(TWIN_CHNLB) 
[  992.332474] SCB_LUN[0x0] 
[  992.332474] Kernel Free SCB list: 1 0 
[  992.332474] Untagged Q(8): 2 
[  992.332474] 
[  992.332474] <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[  992.332474] scsi0:0:8:0: Cmd aborted from QINFIFO
[  993.501131] aic7xxx_abort returns 0x2002
[  993.508980] scsi 0:0:8:0: Device offlined - not ready after error recovery
[ 1015.000025] scsi 0:0:9:0: Attempting to queue an ABORT message
[ 1015.011675] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1015.020186] scsi 0:0:9:0: Command already completed
[ 1015.029937] aic7xxx_abort returns 0x2002
[ 1045.036024] scsi 0:0:9:0: Attempting to queue an ABORT message
[ 1045.047684] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1045.055840] scsi 0:0:9:0: Command already completed
[ 1045.065598] aic7xxx_abort returns 0x2002
[ 1045.073447] scsi 0:0:9:0: Attempting to queue a TARGET RESET message
[ 1045.086145] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1045.094560] scsi 0:0:9:0: Command not found
[ 1045.102919] aic7xxx_dev_reset returns 0x2002
[ 1075.108024] scsi 0:0:9:0: Attempting to queue an ABORT message
[ 1075.119687] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1075.127841] scsi 0:0:9:0: Command already completed
[ 1075.137586] aic7xxx_abort returns 0x2002
[ 1115.148024] scsi 0:0:9:0: Attempting to queue an ABORT message
[ 1115.159679] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1115.167832] scsi 0:0:9:0: Command already completed
[ 1115.177575] aic7xxx_abort returns 0x2002
[ 1115.185423] scsi 0:0:9:0: Device offlined - not ready after error recovery
[ 1136.000021] scsi 0:0:10:0: Attempting to queue an ABORT message
[ 1136.011853] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1136.020362] scsi 0:0:10:0: Command already completed
[ 1136.030287] aic7xxx_abort returns 0x2002
[ 1166.036018] scsi 0:0:10:0: Attempting to queue an ABORT message
[ 1166.047852] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1166.056007] scsi 0:0:10:0: Command already completed
[ 1166.065923] aic7xxx_abort returns 0x2002
[ 1166.073773] scsi 0:0:10:0: Attempting to queue a TARGET RESET message
[ 1166.086643] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1166.095058] scsi 0:0:10:0: Command not found
[ 1166.103590] aic7xxx_dev_reset returns 0x2002
[ 1196.112017] scsi 0:0:10:0: Attempting to queue an ABORT message
[ 1196.123844] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1196.132001] scsi 0:0:10:0: Command already completed
[ 1196.141934] aic7xxx_abort returns 0x2002
[ 1236.152018] scsi 0:0:10:0: Attempting to queue an ABORT message
[ 1236.163847] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1236.172003] scsi 0:0:10:0: Command already completed
[ 1236.181935] aic7xxx_abort returns 0x2002
[ 1236.189784] scsi 0:0:10:0: Device offlined - not ready after error recovery
[ 1257.000021] scsi 0:0:11:0: Attempting to queue an ABORT message
[ 1257.011853] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1257.020363] scsi 0:0:11:0: Command already completed
[ 1257.030286] aic7xxx_abort returns 0x2002
[ 1287.036025] scsi 0:0:11:0: Attempting to queue an ABORT message
[ 1287.047853] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1287.056008] scsi 0:0:11:0: Command already completed
[ 1287.065940] aic7xxx_abort returns 0x2002
[ 1287.073789] scsi 0:0:11:0: Attempting to queue a TARGET RESET message
[ 1287.086662] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1287.095091] scsi 0:0:11:0: Command not found
[ 1287.103624] aic7xxx_dev_reset returns 0x2002
[ 1317.112024] scsi 0:0:11:0: Attempting to queue an ABORT message
[ 1317.123861] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1317.132015] scsi 0:0:11:0: Command already completed
[ 1317.141931] aic7xxx_abort returns 0x2002
[ 1357.152024] scsi 0:0:11:0: Attempting to queue an ABORT message
[ 1357.163863] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1357.172017] scsi 0:0:11:0: Command already completed
[ 1357.181950] aic7xxx_abort returns 0x2002
[ 1357.189797] scsi 0:0:11:0: Device offlined - not ready after error recovery
[ 1378.000027] scsi 0:0:12:0: Attempting to queue an ABORT message
[ 1378.011859] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1378.020369] scsi 0:0:12:0: Command already completed
[ 1378.030293] aic7xxx_abort returns 0x2002
[ 1408.036019] scsi 0:0:12:0: Attempting to queue an ABORT message
[ 1408.047857] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1408.056012] scsi 0:0:12:0: Command already completed
[ 1408.065945] aic7xxx_abort returns 0x2002
[ 1408.073793] scsi 0:0:12:0: Attempting to queue a TARGET RESET message
[ 1408.086665] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1408.095093] scsi 0:0:12:0: Command not found
[ 1408.103624] aic7xxx_dev_reset returns 0x2002
[ 1438.112018] scsi 0:0:12:0: Attempting to queue an ABORT message
[ 1438.123851] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1438.132005] scsi 0:0:12:0: Command already completed
[ 1438.141921] aic7xxx_abort returns 0x2002
[ 1478.152018] scsi 0:0:12:0: Attempting to queue an ABORT message
[ 1478.163856] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1478.172010] scsi 0:0:12:0: Command already completed
[ 1478.181943] aic7xxx_abort returns 0x2002
[ 1478.189790] scsi 0:0:12:0: Device offlined - not ready after error recovery
[ 1499.000021] scsi 0:0:13:0: Attempting to queue an ABORT message
[ 1499.011862] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1499.020372] scsi 0:0:13:0: Command already completed
[ 1499.030297] aic7xxx_abort returns 0x2002
[ 1529.036024] scsi 0:0:13:0: Attempting to queue an ABORT message
[ 1529.047849] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1529.056003] scsi 0:0:13:0: Command already completed
[ 1529.065919] aic7xxx_abort returns 0x2002
[ 1529.073769] scsi 0:0:13:0: Attempting to queue a TARGET RESET message
[ 1529.086638] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1529.095050] scsi 0:0:13:0: Command not found
[ 1529.103584] aic7xxx_dev_reset returns 0x2002
[ 1559.112024] scsi 0:0:13:0: Attempting to queue an ABORT message
[ 1559.123859] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1559.132015] scsi 0:0:13:0: Command already completed
[ 1559.141948] aic7xxx_abort returns 0x2002
[ 1599.152024] scsi 0:0:13:0: Attempting to queue an ABORT message
[ 1599.163854] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1599.172009] scsi 0:0:13:0: Command already completed
[ 1599.181942] aic7xxx_abort returns 0x2002
[ 1599.189790] scsi 0:0:13:0: Device offlined - not ready after error recovery
[ 1620.000021] scsi 0:0:14:0: Attempting to queue an ABORT message
[ 1620.011848] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1620.020360] scsi 0:0:14:0: Command already completed
[ 1620.030283] aic7xxx_abort returns 0x2002
[ 1650.036018] scsi 0:0:14:0: Attempting to queue an ABORT message
[ 1650.047854] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1650.056010] scsi 0:0:14:0: Command already completed
[ 1650.065927] aic7xxx_abort returns 0x2002
[ 1650.073777] scsi 0:0:14:0: Attempting to queue a TARGET RESET message
[ 1650.086646] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1650.095060] scsi 0:0:14:0: Command not found
[ 1650.103593] aic7xxx_dev_reset returns 0x2002
[ 1680.112017] scsi 0:0:14:0: Attempting to queue an ABORT message
[ 1680.123841] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1680.131997] scsi 0:0:14:0: Command already completed
[ 1680.141929] aic7xxx_abort returns 0x2002
[ 1720.152019] scsi 0:0:14:0: Attempting to queue an ABORT message
[ 1720.163857] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1720.172012] scsi 0:0:14:0: Command already completed
[ 1720.181947] aic7xxx_abort returns 0x2002
[ 1720.189793] scsi 0:0:14:0: Device offlined - not ready after error recovery
[ 1741.000021] scsi 0:0:15:0: Attempting to queue an ABORT message
[ 1741.011857] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1741.020366] scsi 0:0:15:0: Command already completed
[ 1741.030291] aic7xxx_abort returns 0x2002
[ 1771.036024] scsi 0:0:15:0: Attempting to queue an ABORT message
[ 1771.047856] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1771.056011] scsi 0:0:15:0: Command already completed
[ 1771.065943] aic7xxx_abort returns 0x2002
[ 1771.073794] scsi 0:0:15:0: Attempting to queue a TARGET RESET message
[ 1771.086665] CDB: 0x12 0x0 0x0 0x0 0x24 0x0
[ 1771.095095] scsi 0:0:15:0: Command not found
[ 1771.103627] aic7xxx_dev_reset returns 0x2002
[ 1801.112020] scsi 0:0:15:0: Attempting to queue an ABORT message
[ 1801.123844] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1801.131998] scsi 0:0:15:0: Command already completed
[ 1801.141932] aic7xxx_abort returns 0x2002
[ 1841.152024] scsi 0:0:15:0: Attempting to queue an ABORT message
[ 1841.163855] CDB: 0x0 0x0 0x0 0x0 0x0 0x0
[ 1841.172010] scsi 0:0:15:0: Command already completed
[ 1841.181942] aic7xxx_abort returns 0x2002
[ 1841.189790] scsi 0:0:15:0: Device offlined - not ready after error recovery
-- 5:ix32ph007  (NUE-3.2.16-Rack2) -- time-stamp -- 2010-01-21 14:00:09 --
-- 5:ix32ph007  (NUE-3.2.16-Rack2) -- time-stamp -- 2010-01-21 14:14:07 --



-- 5:ix32ph007  (NUE-3.2.16-Rack2) -- time-stamp -- 2010-01-21 14:15:59 --

--Boundary-00=_7wuZLKkcf2qj7pG
Content-Type: text/x-vhdl;
  charset="UTF-8";
  name="x86_xseries_330_sci_irq.fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="x86_xseries_330_sci_irq.fix"

---
 arch/x86/kernel/apic/io_apic.c |  154 +++++++++++++++++++----------------------
 arch/x86/pci/irq.c             |   80 +++++++++++++--------
 2 files changed, 125 insertions(+), 109 deletions(-)

Index: linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.32-SLE11-SP1/arch/x86/kernel/apic/io_apic.c
@@ -1476,13 +1476,9 @@ static void setup_IO_APIC_irq(int apic_i
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
 static void __init setup_IO_APIC_irqs(void)
 {
-	int apic_id = 0, pin, idx, irq;
+	int apic_id, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
@@ -1490,58 +1486,47 @@ static void __init setup_IO_APIC_irqs(vo
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		apic_id = mp_find_ioapic(0);
-		if (apic_id < 0)
-			apic_id = 0;
-	}
-#endif
+	for (apic_id = 0; apic_id < nr_ioapics; apic_id++) {
+		for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
 
-	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
-		idx = find_irq_entry(apic_id, pin, mp_INT);
-		if (idx == -1) {
-			if (!notcon) {
-				notcon = 1;
+			idx = find_irq_entry(apic_id, pin, mp_INT);
+			if (idx == -1) {
+				if (!notcon) {
+					notcon = 1;
+					apic_printk(APIC_VERBOSE,
+						KERN_DEBUG " %d-%d",
+						mp_ioapics[apic_id].apicid, pin);
+				} else
+					apic_printk(APIC_VERBOSE, " %d-%d",
+						mp_ioapics[apic_id].apicid, pin);
+				continue;
+			}
+			if (notcon) {
 				apic_printk(APIC_VERBOSE,
-					KERN_DEBUG " %d-%d",
-					mp_ioapics[apic_id].apicid, pin);
-			} else
-				apic_printk(APIC_VERBOSE, " %d-%d",
-					mp_ioapics[apic_id].apicid, pin);
-			continue;
-		}
-		if (notcon) {
-			apic_printk(APIC_VERBOSE,
-				" (apicid-pin) not connected\n");
-			notcon = 0;
-		}
-
-		irq = pin_2_irq(idx, apic_id, pin);
-
-		/*
-		 * Skip the timer IRQ if there's a quirk handler
-		 * installed and if it returns 1:
-		 */
-		if (apic->multi_timer_check &&
-				apic->multi_timer_check(apic_id, irq))
-			continue;
+					" (apicid-pin) not connected\n");
+				notcon = 0;
+			}
+			irq = pin_2_irq(idx, apic_id, pin);
+			/*
+			 * Skip the timer IRQ if there's a quirk handler
+			 * installed and if it returns 1:
+			 */
+			if (apic->multi_timer_check &&
+					apic->multi_timer_check(apic_id, irq))
+				continue;
+
+			desc = irq_to_desc_alloc_node(irq, node);
+			if (!desc) {
+				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
+				continue;
+			}
+			cfg = desc->chip_data;
+			add_pin_to_irq_node(cfg, node, apic_id, pin);
 
-		desc = irq_to_desc_alloc_node(irq, node);
-		if (!desc) {
-			printk(KERN_INFO "can not get irq_desc for %d\n", irq);
-			continue;
+			setup_IO_APIC_irq(apic_id, pin, irq, desc,
+					  irq_trigger(idx), irq_polarity(idx));
 		}
-		cfg = desc->chip_data;
-		add_pin_to_irq_node(cfg, node, apic_id, pin);
-		/*
-		 * don't mark it in pin_programmed, so later acpi could
-		 * set it correctly when irq < 16
-		 */
-		setup_IO_APIC_irq(apic_id, pin, irq, desc,
-				irq_trigger(idx), irq_polarity(idx));
 	}
-
 	if (notcon)
 		apic_printk(APIC_VERBOSE,
 			" (apicid-pin) not connected\n");
@@ -3899,6 +3884,10 @@ static int __io_apic_set_pci_routing(str
 	return 0;
 }
 
+static struct {
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} mp_ioapic_routing[MAX_IO_APICS];
+
 int io_apic_set_pci_routing(struct device *dev, int irq,
 				struct io_apic_irq_attr *irq_attr)
 {
@@ -4058,44 +4047,51 @@ int acpi_get_override_irq(int bus_irq, i
 #ifdef CONFIG_SMP
 void __init setup_ioapic_dest(void)
 {
-	int pin, ioapic = 0, irq, irq_entry;
+	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-#ifdef CONFIG_ACPI
-	if (!acpi_disabled && acpi_ioapic) {
-		ioapic = mp_find_ioapic(0);
-		if (ioapic < 0)
-			ioapic = 0;
-	}
-#endif
+	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
+		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
+			if (irq_entry == -1)
+				continue;
+			irq = pin_2_irq(irq_entry, ioapic, pin);
+
+			/* setup_IO_APIC_irqs could fail to get vector for some device
+			 * when you have too many devices, because at that time only boot
+			 * cpu is online.
+			 */
+			desc = irq_to_desc(irq);
+			cfg = desc->chip_data;
+			if (!cfg->vector) {
+				setup_IO_APIC_irq(ioapic, pin, irq, desc,
+						  irq_trigger(irq_entry),
+						  irq_polarity(irq_entry));
+				continue;
 
-	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
-		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
-		if (irq_entry == -1)
-			continue;
-		irq = pin_2_irq(irq_entry, ioapic, pin);
+			}
 
-		desc = irq_to_desc(irq);
+			/*
+			 * Honour affinities which have been set in early boot
+			 */
+			if (desc->status &
+			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
+				mask = desc->affinity;
+			else
+				mask = apic->target_cpus();
 
-		/*
-		 * Honour affinities which have been set in early boot
-		 */
-		if (desc->status &
-		    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-			mask = desc->affinity;
-		else
-			mask = apic->target_cpus();
+			if (intr_remapping_enabled)
+				set_ir_ioapic_affinity_irq_desc(desc, mask);
+			else
+				set_ioapic_affinity_irq_desc(desc, mask);
+		}
 
-		if (intr_remapping_enabled)
-			set_ir_ioapic_affinity_irq_desc(desc, mask);
-		else
-			set_ioapic_affinity_irq_desc(desc, mask);
 	}
-
 }
 #endif
 
Index: linux-2.6.32-SLE11-SP1/arch/x86/pci/irq.c
===================================================================
--- linux-2.6.32-SLE11-SP1.orig/arch/x86/pci/irq.c
+++ linux-2.6.32-SLE11-SP1/arch/x86/pci/irq.c
@@ -891,9 +891,6 @@ static int pcibios_lookup_irq(struct pci
 		return 0;
 	}
 
-	if (io_apic_assign_pci_irqs)
-		return 0;
-
 	/* Find IRQ routing entry */
 
 	if (!pirq_table)
@@ -1044,15 +1041,60 @@ static void __init pcibios_fixup_irqs(vo
 		pirq_penalty[dev->irq]++;
 	}
 
-	if (io_apic_assign_pci_irqs)
-		return;
-
 	dev = NULL;
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 		if (!pin)
 			continue;
 
+#ifdef CONFIG_X86_IO_APIC
+		/*
+		 * Recalculate IRQ numbers if we use the I/O APIC.
+		 */
+		if (io_apic_assign_pci_irqs) {
+			int irq;
+			struct io_apic_irq_attr irq_attr;
+			
+
+			/*
+			 * interrupt pins are numbered starting from 1
+			 */
+			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+						PCI_SLOT(dev->devfn), pin - 1,
+						&irq_attr);
+			/*
+			 * Busses behind bridges are typically not listed in the
+			 * MP-table.  In this case we have to look up the IRQ
+			 * based on the parent bus, parent slot, and pin number.
+			 * The SMP code detects such bridged busses itself so we
+			 * should get into this branch reliably.
+			 */
+			if (irq < 0 && dev->bus->parent) {
+				/* go back to the bridge */
+				struct pci_dev *bridge = dev->bus->self;
+				int bus;
+
+				pin = pci_swizzle_interrupt_pin(dev, pin);
+				bus = bridge->bus->number;
+				irq = IO_APIC_get_PCI_irq_vector(bus,
+						PCI_SLOT(bridge->devfn),
+						pin - 1, &irq_attr);
+				if (irq >= 0)
+					dev_warn(&dev->dev,
+						"using bridge %s INT %c to "
+							"get IRQ %d\n",
+						 pci_name(bridge),
+						 'A' + pin - 1, irq);
+			}
+			if (irq >= 0) {
+				dev_info(&dev->dev,
+					"PCI->APIC IRQ transform: INT %c "
+						"-> IRQ %d\n",
+					'A' + pin - 1, irq);
+				dev->irq = irq;
+			}
+		}
+#endif
 		/*
 		 * Still no IRQ? Try to lookup one...
 		 */
@@ -1147,19 +1189,6 @@ int __init pcibios_irq_init(void)
 	pcibios_enable_irq = pirq_enable_irq;
 
 	pcibios_fixup_irqs();
-
-	if (io_apic_assign_pci_irqs && pci_routeirq) {
-		struct pci_dev *dev = NULL;
-		/*
-		 * PCI IRQ routing is set up by pci_enable_device(), but we
-		 * also do it here in case there are still broken drivers that
-		 * don't use pci_enable_device().
-		 */
-		printk(KERN_INFO "PCI: Routing PCI interrupts for all devices because \"pci=routeirq\" specified\n");
-		for_each_pci_dev(dev)
-			pirq_enable_irq(dev);
-	}
-
 	return 0;
 }
 
@@ -1190,17 +1219,13 @@ void pcibios_penalize_isa_irq(int irq, i
 static int pirq_enable_irq(struct pci_dev *dev)
 {
 	u8 pin;
+	struct pci_dev *temp_dev;
 
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
-	if (pin && !pcibios_lookup_irq(dev, 1)) {
+	if (pin && !pcibios_lookup_irq(dev, 1) && !dev->irq) {
 		char *msg = "";
 
-		if (!io_apic_assign_pci_irqs && dev->irq)
-			return 0;
-
 		if (io_apic_assign_pci_irqs) {
-#ifdef CONFIG_X86_IO_APIC
-			struct pci_dev *temp_dev;
 			int irq;
 			struct io_apic_irq_attr irq_attr;
 
@@ -1230,15 +1255,10 @@ static int pirq_enable_irq(struct pci_de
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				io_apic_set_pci_routing(&dev->dev, irq,
-							 &irq_attr);
 				dev->irq = irq;
-				dev_info(&dev->dev, "PCI->APIC IRQ transform: "
-					 "INT %c -> IRQ %d\n", 'A' + pin - 1, irq);
 				return 0;
 			} else
 				msg = "; probably buggy MP table";
-#endif
 		} else if (pci_probe & PCI_BIOS_IRQ_SCAN)
 			msg = "";
 		else

--Boundary-00=_7wuZLKkcf2qj7pG--
