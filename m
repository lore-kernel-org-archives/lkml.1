Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbZIZLka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbZIZLka (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 07:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIZLka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 07:40:30 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:59604 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZIZLk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 07:40:27 -0400
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, khali@linux-fr.org, lm-sensors@lm-sensors.org,
       linux-i2c@vger.kernel.org
Subject: 2.6.31 regression: brand-new ACPI conflicts prevent I2C bus and temperature sensors being visible
From: Nix <nix@esperi.org.uk>
Emacs: Lovecraft was an optimist.
Date: Sat, 26 Sep 2009 12:36:33 +0100
Message-ID: <87ws3maqf2.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-x.dcc-servers-Metrics: spindle 104; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the huge Cc:, but this problem may cross subsystems: at least
 I have no idea which subsystem the problem is in.]

My desktop system is a newish Nehalem with PCIe (of course), the usual
coretemp sensor, and a Winbond W83667HG on the I2C bus. In 2.6.30.5,
this all worked, but in 2.6.31.1 the latter sensor isn't found. The boot
log says, in part (full log appended):

[    0.929754] i2c /dev entries driver
[    0.929821] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.929887] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
[    0.929955] ACPI: Device needs an ACPI driver
[    0.930003] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    0.930077] coretemp coretemp.0: Using relative temperature scale!
[    0.930156] coretemp coretemp.1: Using relative temperature scale!
[    0.930228] coretemp coretemp.2: Using relative temperature scale!
[    0.930304] coretemp coretemp.3: Using relative temperature scale!
[    0.930375] coretemp coretemp.4: Using relative temperature scale!
[    0.930448] coretemp coretemp.5: Using relative temperature scale!
[    0.930521] coretemp coretemp.6: Using relative temperature scale!
[    0.930596] coretemp coretemp.7: Using relative temperature scale!
[    0.930682] w83627ehf: Found W83667HG chip at 0x290
[    0.930736] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
[    0.930804] ACPI: Device needs an ACPI driver

2.6.30.x said (I didn't have coretemp built in back then):

[   40.297764] i2c /dev entries driver
[   40.297830] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   40.297952] w83627ehf: Found W83667HG chip at 0x290

Note: coretemp is not at fault, I just built it in because I wanted
*some* sort of temperature monitoring. Here's the same part of my first
2.6.31.x boot log, without coretemp:

[    0.931782] i2c /dev entries driver
[    0.931848] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.931914] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
[    0.931982] ACPI: Device needs an ACPI driver
[    0.932031] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    0.932109] w83627ehf: Found W83667HG chip at 0x290
[    0.932163] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
[    0.932231] ACPI: Device needs an ACPI driver

The only kernel patch installed is TuxOnIce, and that too was installed
and working in 2.6.30 and has hardly changed since then. (I very much
doubt it gets involved in bus probes anyway, but I could verify that
the regression still happens without it if need be.)

I can bisect for this if you wish.

Full boot log of that last boot, up to the point at which early
userspace comes up, .config follows:

[    0.000000] Linux version 2.6.31.1-04843-g79daf3e-dirty (compiler@mutilate) (gcc version 4.4.2 20090902 (prerelease) (GCC) ) #1 SMP PREEMPT Fri Sep 25 22:24:44 BST 2009
[    0.000000] Command line: BOOT_IMAGE=Linux ro resume=swap:/dev/sda2
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4c00 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf680000 (usable)
[    0.000000]  BIOS-e820: 00000000bf680000 - 00000000bf698000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf698000 - 00000000bf6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf6dc000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E3FFF write-protect
[    0.000000]   E4000-EBFFF write-through
[    0.000000]   EC000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   5 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf680 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4c00 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf680000 (usable)
[    0.000000]  modified: 00000000bf680000 - 00000000bf698000 (ACPI data)
[    0.000000]  modified: 00000000bf698000 - 00000000bf6dc000 (ACPI NVS)
[    0.000000]  modified: 00000000bf6dc000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf680000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf680000 page 4k
[    0.000000] kernel direct mapping tables up to bf680000 @ 10000-15000
[    0.000000] init_memory_mapping: 0000000100000000-0000000340000000
[    0.000000]  0100000000 - 0340000000 page 2M
[    0.000000] kernel direct mapping tables up to 340000000 @ 13000-21000
[    0.000000] ACPI: RSDP 00000000000fae10 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf680100 0005C (v01 032509 XSDT1124 20090325 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf680290 000F4 (v03 032509 FACP1124 20090325 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf6804b0 0C3DD (v01  A1146 A1146001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000bf698000 00040
[    0.000000] ACPI: APIC 00000000bf680390 000D8 (v01 032509 APIC1124 20090325 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf680470 0003C (v01 032509 OEMMCFG  20090325 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf698040 00072 (v01 032509 OEMB1124 20090325 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf68f4b0 00038 (v01 032509 OEMHPET  20090325 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf68f4f0 000B0 (v01 032509 OEMOSFR  20090325 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf69a140 0249F (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0340000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00017bf37c]    TEXT DATA BSS ==> [0001000000 - 00017bf37c]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #4 [00017c0000 - 00017c0288]              BRK ==> [00017c0000 - 00017c0288]
[    0.000000]   #5 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
[    0.000000]   #6 [0000013000 - 000001c000]          PGTABLE ==> [0000013000 - 000001c000]
[    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00340000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bf680
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000] On node 0 totalpages: 3143182
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 112 pages reserved
[    0.000000]   DMA zone: 3814 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765624 pages, LIFO batch:31
[    0.000000]   Normal zone: 32256 pages used for memmap
[    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 16 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 48
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e5000
[    0.000000] PM: Registered nosave memory: 00000000000e5000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf680000 - 00000000bf698000
[    0.000000] PM: Registered nosave memory: 00000000bf698000 - 00000000bf6dc000
[    0.000000] PM: Registered nosave memory: 00000000bf6dc000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages at ffff880028034000, static data 80608 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096478
[    0.000000] Kernel command line: BOOT_IMAGE=Linux ro resume=swap:/dev/sda2
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 12300148k/13631488k available (4002k kernel code, 1058760k absent, 271688k reserved, 2219k data, 1096k init)
[    0.000000] NR_IRQS:4352 nr_irqs:880
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2672.883 MHz processor.
[    0.006550] Console: colour VGA+ 80x50
[    0.006551] console [tty0] enabled
[    0.012451] hpet clockevent registered
[    0.012454] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.012509] Calibrating delay loop (skipped), value calculated using timer frequency.. 5345.76 BogoMIPS (lpj=2672883)
[    0.012646] Mount-cache hash table entries: 256
[    0.012778] CPU: Physical Processor ID: 0
[    0.012825] CPU: Processor Core ID: 0
[    0.012872] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.012946] CPU: L2 cache: 256K
[    0.012990] CPU: L3 cache: 8192K
[    0.013036] mce: CPU supports 9 MCE banks
[    0.013089] CPU0: Thermal monitoring enabled (TM1)
[    0.013138] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.013349] using mwait in idle threads.
[    0.013395] Performance Counters: Nehalem/Corei7 events, Intel PMU driver.
[    0.013515] ... version:                 3
[    0.013562] ... bit width:               48
[    0.013608] ... generic counters:        4
[    0.013654] ... value mask:              0000ffffffffffff
[    0.013703] ... max period:              000000007fffffff
[    0.013751] ... fixed-purpose counters:  3
[    0.013798] ... counter mask:            000000070000000f
[    0.013857] ACPI: Core revision 20090521
[    0.053964] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.054019] ftrace: allocating 17976 entries in 71 pages
[    0.058639] Setting APIC routing to flat
[    0.059129] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069177] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.173420] Booting processor 1 APIC 0x2 ip 0x6000
[    0.183851] Initializing CPU#1
[    0.244371] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
[    0.244377] CPU: Physical Processor ID: 0
[    0.244378] CPU: Processor Core ID: 1
[    0.244380] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.244381] CPU: L2 cache: 256K
[    0.244382] CPU: L3 cache: 8192K
[    0.244385] mce: CPU supports 9 MCE banks
[    0.244392] CPU1: Thermal monitoring enabled (TM1)
[    0.244395] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.244985] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.245587] CPU1: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.246218] Skipping synchronization checks as TSC is reliable.
[    0.246393] Booting processor 2 APIC 0x4 ip 0x6000
[    0.256797] Initializing CPU#2
[    0.318340] Calibrating delay using timer specific routine.. 5451.56 BogoMIPS (lpj=2725784)
[    0.318348] CPU: Physical Processor ID: 0
[    0.318349] CPU: Processor Core ID: 2
[    0.318351] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.318352] CPU: L2 cache: 256K
[    0.318353] CPU: L3 cache: 8192K
[    0.318355] mce: CPU supports 9 MCE banks
[    0.318363] CPU2: Thermal monitoring enabled (TM1)
[    0.318366] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.318951] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.319572] CPU2: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.326198] Skipping synchronization checks as TSC is reliable.
[    0.326356] Booting processor 3 APIC 0x6 ip 0x6000
[    0.336764] Initializing CPU#3
[    0.397305] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672339)
[    0.397311] CPU: Physical Processor ID: 0
[    0.397312] CPU: Processor Core ID: 3
[    0.397314] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.397315] CPU: L2 cache: 256K
[    0.397316] CPU: L3 cache: 8192K
[    0.397318] mce: CPU supports 9 MCE banks
[    0.397326] CPU3: Thermal monitoring enabled (TM1)
[    0.397328] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.397918] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.398523] CPU3: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.399154] Skipping synchronization checks as TSC is reliable.
[    0.399330] Booting processor 4 APIC 0x1 ip 0x6000
[    0.409734] Initializing CPU#4
[    0.470273] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672339)
[    0.470280] CPU: Physical Processor ID: 0
[    0.470281] CPU: Processor Core ID: 0
[    0.470284] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.470285] CPU: L2 cache: 256K
[    0.470287] CPU: L3 cache: 8192K
[    0.470289] mce: CPU supports 9 MCE banks
[    0.470298] CPU4: Thermal monitoring enabled (TM1)
[    0.470301] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.471051] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.471835] CPU4: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.472472] Skipping synchronization checks as TSC is reliable.
[    0.473293] Booting processor 5 APIC 0x3 ip 0x6000
[    0.483701] Initializing CPU#5
[    0.545242] Calibrating delay using timer specific routine.. 5451.57 BogoMIPS (lpj=2725785)
[    0.545249] CPU: Physical Processor ID: 0
[    0.545250] CPU: Processor Core ID: 1
[    0.545252] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.545253] CPU: L2 cache: 256K
[    0.545254] CPU: L3 cache: 8192K
[    0.545256] mce: CPU supports 9 MCE banks
[    0.545264] CPU5: Thermal monitoring enabled (TM1)
[    0.545266] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.546028] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.546884] CPU5: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.547515] Skipping synchronization checks as TSC is reliable.
[    0.548260] Booting processor 6 APIC 0x5 ip 0x6000
[    0.558667] Initializing CPU#6
[    0.619208] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672338)
[    0.619214] CPU: Physical Processor ID: 0
[    0.619215] CPU: Processor Core ID: 2
[    0.619217] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.619218] CPU: L2 cache: 256K
[    0.619219] CPU: L3 cache: 8192K
[    0.619221] mce: CPU supports 9 MCE banks
[    0.619229] CPU6: Thermal monitoring enabled (TM1)
[    0.619231] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.619989] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.620827] CPU6: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.621458] Skipping synchronization checks as TSC is reliable.
[    0.622226] Booting processor 7 APIC 0x7 ip 0x6000
[    0.632635] Initializing CPU#7
[    0.693176] Calibrating delay using timer specific routine.. 5344.67 BogoMIPS (lpj=2672337)
[    0.693182] CPU: Physical Processor ID: 0
[    0.693183] CPU: Processor Core ID: 3
[    0.693185] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.693186] CPU: L2 cache: 256K
[    0.693187] CPU: L3 cache: 8192K
[    0.693189] mce: CPU supports 9 MCE banks
[    0.693197] CPU7: Thermal monitoring enabled (TM1)
[    0.693199] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.693958] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.694794] CPU7: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.695425] Skipping synchronization checks as TSC is reliable.
[    0.695487] Brought up 8 CPUs
[    0.695532] Total of 8 processors activated (42972.28 BogoMIPS).
[    0.695626] CPU0 attaching sched-domain:
[    0.695628]  domain 0: span 0,4 level SIBLING
[    0.695630]   groups: 0 4
[    0.695633]   domain 1: span 0-7 level MC
[    0.695634]    groups: 0,4 1,5 2,6 3,7
[    0.695639] CPU1 attaching sched-domain:
[    0.695640]  domain 0: span 1,5 level SIBLING
[    0.695642]   groups: 1 5
[    0.695644]   domain 1: span 0-7 level MC
[    0.695645]    groups: 1,5 2,6 3,7 0,4
[    0.695650] CPU2 attaching sched-domain:
[    0.695651]  domain 0: span 2,6 level SIBLING
[    0.695652]   groups: 2 6
[    0.695655]   domain 1: span 0-7 level MC
[    0.695656]    groups: 2,6 3,7 0,4 1,5
[    0.695660] CPU3 attaching sched-domain:
[    0.695662]  domain 0: span 3,7 level SIBLING
[    0.695663]   groups: 3 7
[    0.695666]   domain 1: span 0-7 level MC
[    0.695667]    groups: 3,7 0,4 1,5 2,6
[    0.695671] CPU4 attaching sched-domain:
[    0.695672]  domain 0: span 0,4 level SIBLING
[    0.695674]   groups: 4 0
[    0.695676]   domain 1: span 0-7 level MC
[    0.695678]    groups: 0,4 1,5 2,6 3,7
[    0.695682] CPU5 attaching sched-domain:
[    0.695683]  domain 0: span 1,5 level SIBLING
[    0.695685]   groups: 5 1
[    0.695687]   domain 1: span 0-7 level MC
[    0.695688]    groups: 1,5 2,6 3,7 0,4
[    0.695692] CPU6 attaching sched-domain:
[    0.695694]  domain 0: span 2,6 level SIBLING
[    0.695695]   groups: 6 2
[    0.695698]   domain 1: span 0-7 level MC
[    0.695699]    groups: 2,6 3,7 0,4 1,5
[    0.695703] CPU7 attaching sched-domain:
[    0.695704]  domain 0: span 3,7 level SIBLING
[    0.695706]   groups: 7 3
[    0.695708]   domain 1: span 0-7 level MC
[    0.695710]    groups: 3,7 0,4 1,5 2,6
[    0.696209] NET: Registered protocol family 16
[    0.696324] ACPI: bus type pci registered
[    0.696404] dca service started, version 1.8
[    0.696473] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.696525] PCI: Not using MMCONFIG.
[    0.696570] PCI: Using configuration type 1 for base access
[    0.697389] bio: create slab <bio-0> at 0
[    0.698262] ACPI: EC: Look up EC in DSDT
[    0.731986] ACPI: Interpreter enabled
[    0.732035] ACPI: (supports S0 S4 S5)
[    0.732173] ACPI: Using IOAPIC for interrupt routing
[    0.732271] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.734602] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.740058] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.748457] ACPI: No dock devices found.
[    0.748635] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.748753] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.748804] pci 0000:00:00.0: PME# disabled
[    0.748902] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.748953] pci 0000:00:01.0: PME# disabled
[    0.749050] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.749101] pci 0000:00:03.0: PME# disabled
[    0.749200] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.749252] pci 0000:00:07.0: PME# disabled
[    0.749585] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
[    0.749646] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
[    0.749707] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
[    0.749773] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfbaff000-0xfbaff3ff]
[    0.749822] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.749874] pci 0000:00:1a.7: PME# disabled
[    0.749955] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfbaf8000-0xfbafbfff]
[    0.749992] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.750043] pci 0000:00:1b.0: PME# disabled
[    0.750140] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.750192] pci 0000:00:1c.0: PME# disabled
[    0.750290] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.750342] pci 0000:00:1c.2: PME# disabled
[    0.750439] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.750491] pci 0000:00:1c.3: PME# disabled
[    0.750588] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.750639] pci 0000:00:1c.4: PME# disabled
[    0.750735] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
[    0.750796] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
[    0.750857] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
[    0.750922] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfbafe000-0xfbafe3ff]
[    0.750971] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.751023] pci 0000:00:1d.7: PME# disabled
[    0.751175] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.751242] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.751295] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
[    0.751363] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 001f)
[    0.751483] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
[    0.751488] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
[    0.751493] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
[    0.751497] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
[    0.751502] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
[    0.751507] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfbafc000-0xfbafc7ff]
[    0.751535] pci 0000:00:1f.2: PME# supported from D3hot
[    0.751584] pci 0000:00:1f.2: PME# disabled
[    0.751654] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfbafd000-0xfbafd0ff]
[    0.751666] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.751735] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.751742] pci 0000:02:00.0: reg 18 64bit mmio: [0xfbbe0000-0xfbbeffff]
[    0.751747] pci 0000:02:00.0: reg 20 io port: [0xb000-0xb0ff]
[    0.751755] pci 0000:02:00.0: reg 30 32bit mmio: [0xfbbc0000-0xfbbdffff]
[    0.751771] pci 0000:02:00.0: supports D1 D2
[    0.751800] pci 0000:02:00.1: reg 10 64bit mmio: [0xfbbfc000-0xfbbfffff]
[    0.751831] pci 0000:02:00.1: supports D1 D2
[    0.753778] pci 0000:00:03.0: bridge io port: [0xb000-0xbfff]
[    0.753782] pci 0000:00:03.0: bridge 32bit mmio: [0xfbb00000-0xfbbfffff]
[    0.753788] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.753863] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfaf00000-0xfaffffff]
[    0.753906] pci 0000:06:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.753924] pci 0000:06:00.0: reg 18 64bit mmio: [0xfbeff000-0xfbefffff]
[    0.753937] pci 0000:06:00.0: reg 20 64bit mmio: [0xfaef0000-0xfaefffff]
[    0.753944] pci 0000:06:00.0: reg 30 32bit mmio: [0xfbec0000-0xfbedffff]
[    0.753980] pci 0000:06:00.0: supports D1 D2
[    0.753982] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.754036] pci 0000:06:00.0: PME# disabled
[    0.755804] pci 0000:00:1c.2: bridge io port: [0xe000-0xefff]
[    0.755809] pci 0000:00:1c.2: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
[    0.755815] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xfae00000-0xfaefffff]
[    0.755867] pci 0000:05:00.0: reg 10 64bit mmio: [0xfbdff000-0xfbdff7ff]
[    0.755874] pci 0000:05:00.0: reg 18 io port: [0xd800-0xd8ff]
[    0.755928] pci 0000:05:00.0: supports D2
[    0.755929] pci 0000:05:00.0: PME# supported from D2 D3hot D3cold
[    0.755982] pci 0000:05:00.0: PME# disabled
[    0.757807] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.757811] pci 0000:00:1c.3: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
[    0.757904] pci 0000:04:00.0: reg 24 32bit mmio: [0xfbcfe000-0xfbcfffff]
[    0.757912] pci 0000:04:00.0: reg 30 32bit mmio: [0xfbce0000-0xfbceffff]
[    0.757942] pci 0000:04:00.0: PME# supported from D3hot
[    0.757993] pci 0000:04:00.0: PME# disabled
[    0.758088] pci 0000:04:00.1: reg 10 io port: [0xcc00-0xcc07]
[    0.758097] pci 0000:04:00.1: reg 14 io port: [0xc880-0xc883]
[    0.758105] pci 0000:04:00.1: reg 18 io port: [0xc800-0xc807]
[    0.758113] pci 0000:04:00.1: reg 1c io port: [0xc480-0xc483]
[    0.758121] pci 0000:04:00.1: reg 20 io port: [0xc400-0xc40f]
[    0.758186] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.758318] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
[    0.758322] pci 0000:00:1c.4: bridge 32bit mmio: [0xfbc00000-0xfbcfffff]
[    0.758368] pci 0000:00:1e.0: transparent bridge
[    0.758448] pci_bus 0000:00: on NUMA node 0
[    0.758452] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.758737] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.758837] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.758893] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.758945] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.758997] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.759064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.759116] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.759170] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.784435] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.784886] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.785118] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.785566] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.786014] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.786461] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.786909] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.787356] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.787850] SCSI subsystem initialized
[    0.788005] libata version 3.00 loaded.
[    0.788046] usbcore: registered new interface driver usbfs
[    0.788105] usbcore: registered new interface driver hub
[    0.788172] usbcore: registered new device driver usb
[    0.788280] PCI: Using ACPI for IRQ routing
[    0.791752] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.791941] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.801152] Switched to high resolution mode on CPU 0
[    0.801298] Switched to high resolution mode on CPU 2
[    0.801301] Switched to high resolution mode on CPU 3
[    0.801303] Switched to high resolution mode on CPU 1
[    0.801718] Switched to high resolution mode on CPU 4
[    0.801720] Switched to high resolution mode on CPU 6
[    0.801722] Switched to high resolution mode on CPU 7
[    0.801728] Switched to high resolution mode on CPU 5
[    0.804403] pnp: PnP ACPI init
[    0.804467] ACPI: bus type pnp registered
[    0.806963] pnp: PnP ACPI: found 16 devices
[    0.813008] ACPI: ACPI bus type pnp unregistered
[    0.813063] system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
[    0.813116] system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
[    0.813169] system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
[    0.813221] system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
[    0.813274] system 00:01: iomem range 0xfec8a000-0xfec8afff could not be reserved
[    0.813339] system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
[    0.813396] system 00:06: ioport range 0x290-0x29f has been reserved
[    0.813449] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.813500] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.813551] system 00:07: ioport range 0x500-0x57f could not be reserved
[    0.813603] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.813656] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.813708] system 00:07: iomem range 0xfed40000-0xfed8ffff has been reserved
[    0.813763] system 00:0a: iomem range 0xffc00000-0xffdfffff has been reserved
[    0.813817] system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.813882] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.813937] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.813991] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.814042] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    0.814094] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    0.814146] system 00:0f: iomem range 0x100000-0xbfefffff could not be reserved
[    0.814211] system 00:0f: iomem range 0xfed90000-0xffffffff could not be reserved
[    0.819052] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.819102] pci 0000:00:01.0:   IO window: disabled
[    0.819153] pci 0000:00:01.0:   MEM window: disabled
[    0.819202] pci 0000:00:01.0:   PREFETCH window: disabled
[    0.819252] pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
[    0.819303] pci 0000:00:03.0:   IO window: 0xb000-0xbfff
[    0.819354] pci 0000:00:03.0:   MEM window: 0xfbb00000-0xfbbfffff
[    0.819407] pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.819475] pci 0000:00:07.0: PCI bridge, secondary bus 0000:03
[    0.819524] pci 0000:00:07.0:   IO window: disabled
[    0.819574] pci 0000:00:07.0:   MEM window: disabled
[    0.819623] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.819673] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:07
[    0.819723] pci 0000:00:1c.0:   IO window: disabled
[    0.819773] pci 0000:00:1c.0:   MEM window: disabled
[    0.819823] pci 0000:00:1c.0:   PREFETCH window: 0x000000faf00000-0x000000faffffff
[    0.819891] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:06
[    0.819942] pci 0000:00:1c.2:   IO window: 0xe000-0xefff
[    0.819993] pci 0000:00:1c.2:   MEM window: 0xfbe00000-0xfbefffff
[    0.820044] pci 0000:00:1c.2:   PREFETCH window: 0x000000fae00000-0x000000faefffff
[    0.820113] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:05
[    0.820164] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.820215] pci 0000:00:1c.3:   MEM window: 0xfbd00000-0xfbdfffff
[    0.820266] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.820317] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.820367] pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
[    0.820420] pci 0000:00:1c.4:   MEM window: 0xfbc00000-0xfbcfffff
[    0.820471] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.820522] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:08
[    0.820571] pci 0000:00:1e.0:   IO window: disabled
[    0.820621] pci 0000:00:1e.0:   MEM window: disabled
[    0.820671] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.820727] pci 0000:00:01.0: setting latency timer to 64
[    0.820733] pci 0000:00:03.0: setting latency timer to 64
[    0.820738] pci 0000:00:07.0: setting latency timer to 64
[    0.820745]   alloc irq_desc for 17 on node -1
[    0.820746]   alloc kstat_irqs on node -1
[    0.820751] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.820803] pci 0000:00:1c.0: setting latency timer to 64
[    0.820809]   alloc irq_desc for 18 on node -1
[    0.820810]   alloc kstat_irqs on node -1
[    0.820813] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.820866] pci 0000:00:1c.2: setting latency timer to 64
[    0.820871]   alloc irq_desc for 19 on node -1
[    0.820872]   alloc kstat_irqs on node -1
[    0.820875] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.820928] pci 0000:00:1c.3: setting latency timer to 64
[    0.820934] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.820986] pci 0000:00:1c.4: setting latency timer to 64
[    0.820991] pci 0000:00:1e.0: setting latency timer to 64
[    0.820995] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.820996] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.820998] pci_bus 0000:02: resource 0 io:  [0xb000-0xbfff]
[    0.821000] pci_bus 0000:02: resource 1 mem: [0xfbb00000-0xfbbfffff]
[    0.821002] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.821004] pci_bus 0000:07: resource 2 pref mem [0xfaf00000-0xfaffffff]
[    0.821006] pci_bus 0000:06: resource 0 io:  [0xe000-0xefff]
[    0.821007] pci_bus 0000:06: resource 1 mem: [0xfbe00000-0xfbefffff]
[    0.821009] pci_bus 0000:06: resource 2 pref mem [0xfae00000-0xfaefffff]
[    0.821011] pci_bus 0000:05: resource 0 io:  [0xd000-0xdfff]
[    0.821012] pci_bus 0000:05: resource 1 mem: [0xfbd00000-0xfbdfffff]
[    0.821014] pci_bus 0000:04: resource 0 io:  [0xc000-0xcfff]
[    0.821016] pci_bus 0000:04: resource 1 mem: [0xfbc00000-0xfbcfffff]
[    0.821018] pci_bus 0000:08: resource 3 io:  [0x00-0xffff]
[    0.821019] pci_bus 0000:08: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.821072] NET: Registered protocol family 2
[    0.821193] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.821763] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.822416] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.822604] TCP: Hash tables configured (established 262144 bind 65536)
[    0.822655] TCP reno registered
[    0.822788] NET: Registered protocol family 1
[    0.834789] Scanning for low memory corruption every 60 seconds
[    0.835521] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.835735] VFS: Disk quotas dquot_6.5.2
[    0.835805] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.836073] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.836197] fuse init (API version 7.12)
[    0.836300] msgmni has been set to 24025
[    0.836539] alg: No test for stdrng (krng)
[    0.836593] io scheduler noop registered
[    0.836659] io scheduler cfq registered (default)
[    0.836840] pci 0000:02:00.0: Boot video device
[    0.836943]   alloc irq_desc for 48 on node -1
[    0.836944]   alloc kstat_irqs on node -1
[    0.836951] pcieport-driver 0000:00:01.0: irq 48 for MSI/MSI-X
[    0.836957] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.837046]   alloc irq_desc for 49 on node -1
[    0.837047]   alloc kstat_irqs on node -1
[    0.837052] pcieport-driver 0000:00:03.0: irq 49 for MSI/MSI-X
[    0.837057] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.837145]   alloc irq_desc for 50 on node -1
[    0.837146]   alloc kstat_irqs on node -1
[    0.837151] pcieport-driver 0000:00:07.0: irq 50 for MSI/MSI-X
[    0.837157] pcieport-driver 0000:00:07.0: setting latency timer to 64
[    0.837240]   alloc irq_desc for 51 on node -1
[    0.837241]   alloc kstat_irqs on node -1
[    0.837246] pcieport-driver 0000:00:1c.0: irq 51 for MSI/MSI-X
[    0.837253] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.837343]   alloc irq_desc for 52 on node -1
[    0.837344]   alloc kstat_irqs on node -1
[    0.837350] pcieport-driver 0000:00:1c.2: irq 52 for MSI/MSI-X
[    0.837356] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.837451]   alloc irq_desc for 53 on node -1
[    0.837452]   alloc kstat_irqs on node -1
[    0.837458] pcieport-driver 0000:00:1c.3: irq 53 for MSI/MSI-X
[    0.837464] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.837554]   alloc irq_desc for 54 on node -1
[    0.837556]   alloc kstat_irqs on node -1
[    0.837561] pcieport-driver 0000:00:1c.4: irq 54 for MSI/MSI-X
[    0.837567] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.837636] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    0.837641] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    0.837645] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    0.837697] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.837762] ACPI: Power Button [PWRF]
[    0.837855] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.837921] ACPI: Power Button [PWRB]
[    0.838748] ACPI: SSDT 00000000bf6980c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
[    0.841279] processor LNXCPU:00: registered as cooling_device0
[    0.841801] ACPI: SSDT 00000000bf6984d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
[    0.844240] processor LNXCPU:01: registered as cooling_device1
[    0.844757] ACPI: SSDT 00000000bf6988e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
[    0.847195] processor LNXCPU:02: registered as cooling_device2
[    0.847714] ACPI: SSDT 00000000bf698cf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
[    0.850153] processor LNXCPU:03: registered as cooling_device3
[    0.850669] ACPI: SSDT 00000000bf699100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
[    0.853106] processor LNXCPU:04: registered as cooling_device4
[    0.853622] ACPI: SSDT 00000000bf699510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
[    0.856059] processor LNXCPU:05: registered as cooling_device5
[    0.856572] ACPI: SSDT 00000000bf699920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
[    0.859014] processor LNXCPU:06: registered as cooling_device6
[    0.859530] ACPI: SSDT 00000000bf699d30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
[    0.861970] processor LNXCPU:07: registered as cooling_device7
[    0.865101] Linux agpgart interface v0.103
[    0.865149] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.865517] ahci 0000:00:1f.2: version 3.0
[    0.865527]   alloc irq_desc for 20 on node -1
[    0.865529]   alloc kstat_irqs on node -1
[    0.865534] ahci 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[    0.865610]   alloc irq_desc for 55 on node -1
[    0.865611]   alloc kstat_irqs on node -1
[    0.865617] ahci 0000:00:1f.2: irq 55 for MSI/MSI-X
[    0.865639] ahci: SSS flag set, parallel bus scan disabled
[    0.865722] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.865789] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    0.865858] ahci 0000:00:1f.2: setting latency timer to 64
[    0.875191] scsi0 : ahci
[    0.875306] scsi1 : ahci
[    0.875390] scsi2 : ahci
[    0.875469] scsi3 : ahci
[    0.875548] scsi4 : ahci
[    0.875628] scsi5 : ahci
[    0.875768] ata1: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc100 irq 55
[    0.875834] ata2: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc180 irq 55
[    0.875899] ata3: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc200 irq 55
[    0.875965] ata4: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc280 irq 55
[    0.876030] ata5: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc300 irq 55
[    0.876095] ata6: SATA max UDMA/133 abar m2048@0xfbafc000 port 0xfbafc380 irq 55
[    0.876182]   alloc irq_desc for 16 on node -1
[    0.876184]   alloc kstat_irqs on node -1
[    0.876189] ahci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.887157] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    0.887232] ahci 0000:04:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    0.887287] ahci 0000:04:00.0: setting latency timer to 64
[    0.887377] scsi6 : ahci
[    0.887460] scsi7 : ahci
[    0.887555] ata7: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe100 irq 16
[    0.887622] ata8: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe180 irq 16
[    0.887733] pata_jmicron 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.887814] pata_jmicron 0000:04:00.1: setting latency timer to 64
[    0.887860] scsi8 : pata_jmicron
[    0.887941] scsi9 : pata_jmicron
[    0.894615] ata9: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 17
[    0.894669] ata10: PATA max UDMA/100 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 17
[    0.894772] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.894838] r8169 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.894914] r8169 0000:06:00.0: setting latency timer to 64
[    0.894952]   alloc irq_desc for 56 on node -1
[    0.894953]   alloc kstat_irqs on node -1
[    0.894963] r8169 0000:06:00.0: irq 56 for MSI/MSI-X
[    0.895116] eth0: RTL8168c/8111c at 0xffffc90000042000, 00:24:8c:0f:64:18, XID 3c4000c0 IRQ 56
[    0.897977] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.898039] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.898097] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.898100] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.898166] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.902135] ehci_hcd 0000:00:1a.7: debug port 1
[    0.902185] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.902196] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbaff000
[    0.911125] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.911238] usb usb1: configuration #1 chosen from 1 choice
[    0.911305] hub 1-0:1.0: USB hub found
[    0.911354] hub 1-0:1.0: 6 ports detected
[    0.911446]   alloc irq_desc for 23 on node -1
[    0.911447]   alloc kstat_irqs on node -1
[    0.911451] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.911510] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.911513] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.911564] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.915528] ehci_hcd 0000:00:1d.7: debug port 1
[    0.915579] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.915589] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbafe000
[    0.925121] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.925228] usb usb2: configuration #1 chosen from 1 choice
[    0.925293] hub 2-0:1.0: USB hub found
[    0.925342] hub 2-0:1.0: 6 ports detected
[    0.925435] uhci_hcd: USB Universal Host Controller Interface driver
[    0.925503] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.925558] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.925561] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.925613] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.925697] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    0.925795] usb usb3: configuration #1 chosen from 1 choice
[    0.925860] hub 3-0:1.0: USB hub found
[    0.925908] hub 3-0:1.0: 2 ports detected
[    0.925984]   alloc irq_desc for 21 on node -1
[    0.925986]   alloc kstat_irqs on node -1
[    0.925989] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.926045] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.926047] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.926100] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.926192] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    0.926288] usb usb4: configuration #1 chosen from 1 choice
[    0.926354] hub 4-0:1.0: USB hub found
[    0.926405] hub 4-0:1.0: 2 ports detected
[    0.926483] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.926538] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.926540] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.926592] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.926681] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000ac00
[    0.926777] usb usb5: configuration #1 chosen from 1 choice
[    0.926842] hub 5-0:1.0: USB hub found
[    0.926890] hub 5-0:1.0: 2 ports detected
[    0.926967] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.927022] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.927024] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.927076] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.927160] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
[    0.927258] usb usb6: configuration #1 chosen from 1 choice
[    0.927323] hub 6-0:1.0: USB hub found
[    0.927374] hub 6-0:1.0: 2 ports detected
[    0.927450] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.927505] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.927507] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.927559] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.927643] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    0.927738] usb usb7: configuration #1 chosen from 1 choice
[    0.927806] hub 7-0:1.0: USB hub found
[    0.927854] hub 7-0:1.0: 2 ports detected
[    0.927929] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.927984] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.927986] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.928039] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.928123] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
[    0.928222] usb usb8: configuration #1 chosen from 1 choice
[    0.928287] hub 8-0:1.0: USB hub found
[    0.928336] hub 8-0:1.0: 2 ports detected
[    0.928430] usbcore: registered new interface driver usblp
[    0.928479] Initializing USB Mass Storage driver...
[    0.928555] usbcore: registered new interface driver usb-storage
[    0.928605] USB Mass Storage support registered.
[    0.928679] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.931323] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.931376] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.931448] mice: PS/2 mouse device common for all mice
[    0.931583] rtc_cmos 00:03: RTC can wake from S4
[    0.931652] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.931724] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.931782] i2c /dev entries driver
[    0.931848] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.931914] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
[    0.931982] ACPI: Device needs an ACPI driver
[    0.932031] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    0.932109] w83627ehf: Found W83667HG chip at 0x290
[    0.932163] ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region HWRE [0x290-0x299]
[    0.932231] ACPI: Device needs an ACPI driver
[    0.932283] md: raid1 personality registered for level 1
[    0.932409] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    0.932534] EDAC MC: Ver: 2.1.0 Sep 25 2009
[    0.932684] cpuidle: using governor ladder
[    0.932731] cpuidle: using governor menu
[    0.932829] usbcore: registered new interface driver usbhid
[    0.932879] usbhid: v2.6:USB HID core driver
[    0.932940] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    0.933161]   alloc irq_desc for 22 on node -1
[    0.933162]   alloc kstat_irqs on node -1
[    0.933166] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.933248] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.948924] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    0.972626]   alloc irq_desc for 34 on node -1
[    0.972628]   alloc kstat_irqs on node -1
[    0.972633] HDA Intel 0000:02:00.1: PCI INT B -> GSI 34 (level, low) -> IRQ 34
[    0.972713] HDA Intel 0000:02:00.1: setting latency timer to 64
[    0.998350] ALSA device list:
[    0.998395]   #0: HDA Intel at 0xfbaf8000 irq 22
[    0.998442]   #1: HDA ATI HDMI at 0xfbbfc000 irq 34
[    0.998681] TCP cubic registered
[    0.998727] NET: Registered protocol family 17
[    0.998939] RPC: Registered udp transport module.
[    0.998986] RPC: Registered tcp transport module.
[    1.003954] TuxOnIce 3.0.1 (http://tuxonice.net)
[    1.004035] TuxOnIce: Ignoring late initcall, as requested.
[    1.181364] ata1: SATA link down (SStatus 0 SControl 300)
[    1.192061] ata8: SATA link down (SStatus 0 SControl 300)
[    1.345016] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.345303] ata7.15: Port Multiplier 1.1, 0x0322:0x1043 r0, 5 ports, feat 0x5/0xf
[    1.345622] ata7.15: applying bridge limits
[    1.345709] ata7.00: hard resetting link
[    1.382013] usb 7-1: new low speed USB device using uhci_hcd and address 2
[    1.496966] ata2: SATA link down (SStatus 0 SControl 300)
[    1.544567] usb 7-1: configuration #1 chosen from 1 choice
[    1.560626] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.0/input/input3
[    1.560728] generic-usb 0003:046D:C018.0001: input: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:1d.1-1/input0
[    1.566233] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
[    1.803083] ata7.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[    1.803142] ata7.01: hard resetting link
[    1.812877] ata3: SATA link down (SStatus 0 SControl 300)
[    2.260961] ata7.01: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    2.261017] ata7.02: hard resetting link
[    2.281751] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.282504] ata4.00: ATAPI: TSSTcorp CDDVDW SH-S223F, SB03, max UDMA/100, ATAPI AN
[    2.283528] ata4.00: configured for UDMA/100
[    2.295271] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223F  SB03 PQ: 0 ANSI: 5
[    2.298504] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.298576] Uniform CD-ROM driver Revision: 3.20
[    2.298707] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.565989] ata7.02: SATA link down (SStatus 0 SControl 0)
[    2.572152] ata7.03: hard resetting link
[    2.603656] ata5: SATA link down (SStatus 0 SControl 300)
[    2.876900] ata7.03: SATA link down (SStatus 0 SControl 0)
[    2.876955] ata7.04: hard resetting link
[    2.919568] ata6: SATA link down (SStatus 0 SControl 300)
[    3.181814] ata7.04: SATA link down (SStatus 0 SControl 0)
[    3.181952] ata7.00: ATA-7: ST3500320AS, 0909, max UDMA/133
[    3.182006] ata7.00: 976773168 sectors, multi 1: LBA48 
[    3.182218] ata7.00: configured for UDMA/133
[    3.183809] ata7.01: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    3.183863] ata7.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.185882] ata7.01: configured for UDMA/133
[    3.185963] ata7: EH complete
[    3.186101] scsi 6:0:0:0: Direct-Access     ATA      ST3500320AS      0909 PQ: 0 ANSI: 5
[    3.186293] sd 6:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.186338] scsi 6:1:0:0: Direct-Access     ATA      ST3500320AS      SD1A PQ: 0 ANSI: 5
[    3.186457] sd 6:1:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.186475] sd 6:0:0:0: [sda] Write Protect is off
[    3.186478] sd 6:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.186499] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.186609]  sda:
[    3.186733] sd 6:1:0:0: [sdb] Write Protect is off
[    3.186831] sd 6:1:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.186852] sd 6:1:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.187027]  sdb: sda1 sda2 sda3
[    3.214417] sd 6:0:0:0: [sda] Attached SCSI disk
[    3.237335]  sdb1 sdb2 sdb3
[    3.237695] sd 6:1:0:0: [sdb] Attached SCSI disk
[    3.349475] rtc_cmos 00:03: setting system clock to 2009-09-25 21:53:38 UTC (1253915618)
[    3.349631] Freeing unused kernel memory: 1096k freed
[    3.349848] Write protecting the kernel read-only data: 5812k


CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
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
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_CLASSIC_RCU=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
CONFIG_CGROUPS=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="usr/initramfs.mutilate"
CONFIG_INITRAMFS_ROOT_UID=99
CONFIG_INITRAMFS_ROOT_GID=101
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y
CONFIG_PERF_COUNTERS=y
CONFIG_EVENT_PROFILE=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_SLAB=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_MCORE2=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_X86_PAT=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_TOI_CORE=y
CONFIG_TOI_SWAP=y
CONFIG_TOI_CRYPTO=y
CONFIG_TOI_USERUI=y
CONFIG_TOI_USERUI_DEFAULT_PATH="/usr/sbin/tuxoniceui_text"
CONFIG_TOI_REPLACE_SWSUSP=y
CONFIG_TOI_IGNORE_LATE_INITCALL=y
CONFIG_TOI_DEFAULT_WAIT=-1
CONFIG_TOI_DEFAULT_EXTRA_PAGES_ALLOWANCE=2000
CONFIG_TOI=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=16
CONFIG_MISC_DEVICES=y
CONFIG_HAVE_IDE=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_PATA_JMICRON=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_RAID1=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_R8169=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_GAMEPORT=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_UNIX98_PTYS=y
CONFIG_NVRAM=m
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_I801=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_SSB_POSSIBLE=y
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_DRM=m
CONFIG_DRM_RADEON=m
CONFIG_FB=m
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_USB_HID=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_PRINTER=y
CONFIG_USB_STORAGE=y
CONFIG_EDAC=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=y
CONFIG_DMADEVICES=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y
CONFIG_NET_DMA=y
CONFIG_DCA=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_UTF8=m
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_LZO=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_BINARY_PRINTF=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y
