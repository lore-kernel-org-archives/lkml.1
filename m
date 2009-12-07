Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZLGTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZLGTNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbZLGTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:13:49 -0500
Received: from twilight.fidra.de ([88.198.14.164]:32868 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbZLGTNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:13:46 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Mon, 7 Dec 2009 20:13:46 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.29-rc7-01054-g6d7942d; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <4B1D4842.80000@kernel.org>
In-Reply-To: <4B1D4842.80000@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912072013.46332.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009 19:24:02 Yinghai Lu wrote:
> Volker Lanz wrote:
> > Hi,
> >
> > updating to my distro's new 2.6.31 kernel on an x86_64 quad core machine
> > with 6 GB of RAM I noticed resuming from suspend still worked as before,
> > but the machine will now reproducably freeze (have to hard reset)
> > afterwards as soon as I do something disk I/O heavy, though the problem
> > is probably not related to disk activity at all.
> >
> > A current mainline 2.6.32 checkout shows the same behaviour.
> >
> > I git-bisected the problem to this commit:
> >
> >
> > -------------------------------------------------------------------------
> >---- commit 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Thu Mar 12 22:36:01 2009 -0700
> >
> >     x86: make e820_update_range() handle small range update
> >
> >     Impact: enhance e820 code to handle more cases
> >
> >     Try to handle new range which could be covered by one entry.
> >
> >     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >     Cc: jbeulich@novell.com
> >     LKML-Reference: <49B9F0C1.10402@kernel.org>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > -------------------------------------------------------------------------
> >----
> >
> >
> > A kernel built from this revision does not boot, so the first booting
> > kernel to show the problem actually seems to be:
> >
> >
> > -------------------------------------------------------------------------
> >---- commit 6d7942dc2a70a7e74c352107b150265602671588
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Sat Mar 14 14:32:41 2009 -0700
> >
> >     x86: fix 64k corruption-check
> >
> >     Impact: fix boot crash
> >
> >     Need to exit early if the addr is far above 64k.
> >
> >     The crash got exposed by:
> >
> >       78a8b35: x86: make e820_update_range() handle small range update
> >
> >     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >     Cc: <stable@kernel.org>
> >     LKML-Reference: <49BC2279.2030101@kernel.org>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > -------------------------------------------------------------------------
> >----
> >
> >
> > The last kernel to work without problems thus seems to be this one:
> >
> >
> > -------------------------------------------------------------------------
> >---- commit 773e673de27297d07d852e7e9bfd1a695cae1da2
> > Author: Yinghai Lu <yinghai@kernel.org>
> > Date:   Thu Mar 12 21:35:18 2009 -0700
> >
> >     x86: fix e820_update_range()
> >
> >     Impact: fix left range size on head
> >
> >     | commit 5c0e6f035df983210e4d22213aed624ced502d3d
> >     |    x86: fix code paths used by update_mptable
> >     |    Impact: fix crashes under Xen due to unrobust e820 code
> >
> >     fixes one e820 bug, but introduces another bug.
> >
> >     Need to update size for left range at first in case it is header.
> >
> >     also add __e820_add_region take more parameter.
> >
> >     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >     Cc: jbeulich@novell.com
> >     LKML-Reference: <49B9E286.502@kernel.org>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > -------------------------------------------------------------------------
> >----
> >
> >
> > The problem is 100% reproducable on this machine: Resuming and then
> > copying /usr/ to $HOME will freeze after a few hundred MB have been
> > copied. Earlier kernels worked fine for the last couple of months.
> >
> > What additional information is required to help diagnose and hopefully
> > fix the problem?
> 
> whole boot log with CONFIG_PCI_DEBUG and debug on command line.

Here it is. It's huge, I hope you were expecting that...


-----------------------------------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc7-01054-g6d7942d (vl@trevor) (gcc 
version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #21 SMP Mon Dec 7 19:56:44 CET 2009
[    0.000000] Command line: root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro 
nosplash debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x100000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  modified: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  modified: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-00000001b0000000
[    0.000000]  0100000000 - 01b0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1b0000000 @ c000-14000
[    0.000000] RAMDISK: 3499d000 - 37feffc4
[    0.000000] ACPI: RSDP 000F7280, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFEE2040, 004C (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: FACP CFEE20C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN 
(4)
[    0.000000] ACPI: DSDT CFEE2180, 4CD9 (r1 GBT    GBTUACPI     1000 MSFT  
100000C)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: EUDS CFEE7580, 0500 (r1 GBT                    0             
0)
[    0.000000] ACPI: HPET CFEE74C0, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       
98)
[    0.000000] ACPI: MCFG CFEE7540, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: APIC CFEE6EC0, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: SSDT CFEE83B0, 018A (r1  PmRef  Cpu0Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE8540, 018A (r1  PmRef  Cpu1Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE86D0, 018A (r1  PmRef  Cpu2Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE8860, 018A (r1  PmRef  Cpu3Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE89F0, 03AB (r1  PmRef    CpuPm     3000 INTL 
20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001b0000000
[    0.000000] Bootmem setup node 0 0000000000000000-00000001b0000000
[    0.000000]   NODE_DATA [000000000000f000 - 0000000000013fff]
[    0.000000]   bootmap [0000000000014000 -  0000000000049fff] pages 36
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 01b0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0000200000 - 0000b002f8]    TEXT DATA BSS ==> [0000200000 
- 0000b002f8]
[    0.000000]   #3 [003499d000 - 0037feffc4]          RAMDISK ==> [003499d000 
- 0037feffc4]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 
- 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 
- 000000c000]
[    0.000000]   #6 [000000c000 - 000000f000]          PGTABLE ==> [000000c000 
- 000000f000]
[    0.000000] found SMP MP-table at [ffff8800000f5890] f5890
[    0.000000]  [ffffe20000000000-ffffe20005ffffff] PMD -> [ffff880028200000-
ffff88002d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001b0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x001b0000
[    0.000000] On node 0 totalpages: 1572474
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2410 pages reserved
[    0.000000]   DMA zone: 1528 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 9856 pages used for memmap
[    0.000000]   Normal zone: 711040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 
00000000cfee2000
[    0.000000] PM: Registered nosave memory: 00000000cfee2000 - 
00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 
00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at e6000000 (gap: 
e4000000:1ac00000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages at ffff880028034000, static data 
80608 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 1545872
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=160351ee-
c9b0-4a72-9fd5-9962c8137a7e ro nosplash debug
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2833.325 MHz processor.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] console [tty0] enabled
[    0.010000] allocated 62914560 bytes of page_cgroup
[    0.010000] please try cgroup_disable=memory option if you don't want
[    0.010000] Checking aperture...
[    0.010000] No AGP bridge found
[    0.010000] Calgary: detecting Calgary via BIOS EBDA area
[    0.010000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.010000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.010000] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    0.010000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.010000] Memory: 6008820k/7077888k available (4755k kernel code, 787992k 
absent, 281076k reserved, 2561k data, 624k init)
[    0.010000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5666.65 BogoMIPS (lpj=28333250)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Disabled at boot.
[    0.010000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.010000] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys ns
[    0.010000] Initializing cgroup subsys cpuacct
[    0.010000] Initializing cgroup subsys memory
[    0.010000] Initializing cgroup subsys freezer
[    0.010000] Initializing cgroup subsys net_cls
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 6144K
[    0.010000] [ds] using Core 2/Atom configuration
[    0.010000] CPU 0/0x0 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] CPU0: Thermal monitoring enabled (TM2)
[    0.010000] using mwait in idle threads.
[    0.010000] ACPI: Core revision 20081204
[    0.017969] Setting APIC routing to flat
[    0.018308] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.118373] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.120000] Booting processor 1 APIC 0x3 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 5666.01 
BogoMIPS (lpj=28330075)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 6144K
[    0.010000] [ds] using Core 2/Atom configuration
[    0.010000] CPU 1/0x3 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 3
[    0.010000] CPU1: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106
[    0.271497] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.271985] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.280060] Booting processor 2 APIC 0x2 ip 0x6000
[    0.010000] Initializing CPU#2
[    0.010000] Calibrating delay using timer specific routine.. 5666.02 
BogoMIPS (lpj=28330122)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 6144K
[    0.010000] [ds] using Core 2/Atom configuration
[    0.010000] CPU 2/0x2 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 2
[    0.010000] CPU2: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106
[    0.441427] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.441919] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.450107] Booting processor 3 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#3
[    0.010000] Calibrating delay using timer specific routine.. 5665.98 
BogoMIPS (lpj=28329923)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 6144K
[    0.010000] [ds] using Core 2/Atom configuration
[    0.010000] CPU 3/0x1 -> Node 0
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] CPU3: Thermal monitoring enabled (TM2)
[    0.010000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106
[    0.611419] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.611922] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.620015] Brought up 4 CPUs
[    0.620054] Total of 4 processors activated (22664.67 BogoMIPS).
[    0.620139] CPU0 attaching sched-domain:
[    0.620178]  domain 0: span 0,3 level MC
[    0.620242]   groups: 0 3
[    0.620359]   domain 1: span 0-3 level CPU
[    0.620424]    groups: 0,3 1-2
[    0.620542] CPU1 attaching sched-domain:
[    0.620580]  domain 0: span 1-2 level MC
[    0.620644]   groups: 1 2
[    0.620761]   domain 1: span 0-3 level CPU
[    0.620826]    groups: 1-2 0,3
[    0.620944] CPU2 attaching sched-domain:
[    0.620981]  domain 0: span 1-2 level MC
[    0.621046]   groups: 2 1
[    0.621162]   domain 1: span 0-3 level CPU
[    0.621226]    groups: 1-2 0,3
[    0.621344] CPU3 attaching sched-domain:
[    0.621382]  domain 0: span 0,3 level MC
[    0.621446]   groups: 3 0
[    0.621563]   domain 1: span 0-3 level CPU
[    0.621627]    groups: 0,3 1-2
[    0.621845] net_namespace: 1840 bytes
[    0.621845] Booting paravirtualized kernel on bare hardware
[    0.621845] regulator: core version 0.5
[    0.621845] Time: 20:04:17  Date: 12/07/09
[    0.621845] NET: Registered protocol family 16
[    0.621845] ACPI: bus type pci registered
[    0.621845] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.621845] PCI: MCFG area at e0000000 reserved in E820
[    0.622150] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.622189] PCI: Using configuration type 1 for base access
[    0.622693] bio: create slab <bio-0> at 0
[    0.622742] ACPI: EC: Look up EC in DSDT
[    0.633005] ACPI: Interpreter enabled
[    0.633048] ACPI: (supports S0 S3 S4 S5)
[    0.633209] ACPI: Using IOAPIC for interrupt routing
[    0.636668] ACPI: No dock devices found.
[    0.636716] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.636773] PCI: Scanning bus 0000:00
[    0.636818] pci 0000:00:00.0: found [8086:2e20] class 000600 header type 00
[    0.636875] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.636931] pci 0000:00:01.0: found [8086:2e21] class 000604 header type 01
[    0.636978] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.637028] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.637069] pci 0000:00:01.0: PME# disabled
[    0.637140] pci 0000:00:1a.0: found [8086:3a37] class 000c03 header type 00
[    0.637199] pci 0000:00:1a.0: reg 20 io port: [0xe100-0xe11f]
[    0.637247] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.637314] pci 0000:00:1a.1: found [8086:3a38] class 000c03 header type 00
[    0.637373] pci 0000:00:1a.1: reg 20 io port: [0xe200-0xe21f]
[    0.637421] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.637488] pci 0000:00:1a.2: found [8086:3a39] class 000c03 header type 00
[    0.637547] pci 0000:00:1a.2: reg 20 io port: [0xe000-0xe01f]
[    0.637595] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.637668] pci 0000:00:1a.7: found [8086:3a3c] class 000c03 header type 00
[    0.637715] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe9305000-0xe93053ff]
[    0.637780] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.637850] pci 0000:00:1b.0: found [8086:3a3e] class 000403 header type 00
[    0.637899] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe9300000-0xe9303fff]
[    0.637956] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.638011] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.638052] pci 0000:00:1b.0: PME# disabled
[    0.638105] pci 0000:00:1c.0: found [8086:3a40] class 000604 header type 01
[    0.638156] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.638213] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.638255] pci 0000:00:1c.0: PME# disabled
[    0.638310] pci 0000:00:1c.3: found [8086:3a46] class 000604 header type 01
[    0.638361] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.638418] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.638460] pci 0000:00:1c.3: PME# disabled
[    0.638513] pci 0000:00:1c.4: found [8086:3a48] class 000604 header type 01
[    0.638565] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.638622] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.638663] pci 0000:00:1c.4: PME# disabled
[    0.638724] pci 0000:00:1d.0: found [8086:3a34] class 000c03 header type 00
[    0.638782] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.638831] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.638898] pci 0000:00:1d.1: found [8086:3a35] class 000c03 header type 00
[    0.638956] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.639005] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.639071] pci 0000:00:1d.2: found [8086:3a36] class 000c03 header type 00
[    0.639130] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.639178] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.639249] pci 0000:00:1d.7: found [8086:3a3a] class 000c03 header type 00
[    0.639296] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe9304000-0xe93043ff]
[    0.639361] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.639428] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    0.639479] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.639548] pci 0000:00:1f.0: found [8086:3a18] class 000601 header type 00
[    0.639624] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.639698] pci 0000:00:1f.2: found [8086:3a20] class 000101 header type 00
[    0.639743] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.639785] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.639827] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.639869] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.639911] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.639953] pci 0000:00:1f.2: reg 24 io port: [0xf100-0xf10f]
[    0.640009] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.640071] pci 0000:00:1f.3: found [8086:3a30] class 000c05 header type 00
[    0.640119] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe9306000-0xe93060ff]
[    0.640169] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.640216] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.640276] pci 0000:00:1f.5: found [8086:3a26] class 000101 header type 00
[    0.640321] pci 0000:00:1f.5: reg 10 io port: [0xe700-0xe707]
[    0.640363] pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe803]
[    0.640406] pci 0000:00:1f.5: reg 18 io port: [0xe900-0xe907]
[    0.640448] pci 0000:00:1f.5: reg 1c io port: [0xea00-0xea03]
[    0.640490] pci 0000:00:1f.5: reg 20 io port: [0xeb00-0xeb0f]
[    0.640532] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.640578] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.640635] PCI: Fixups for bus 0000:00
[    0.640673] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    0.640716] PCI: Scanning bus 0000:01
[    0.640766] pci 0000:01:00.0: found [10de:0402] class 000300 header type 00
[    0.640811] pci 0000:01:00.0: reg 10 32bit mmio: [0xe6000000-0xe6ffffff]
[    0.640857] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.640902] pci 0000:01:00.0: reg 1c 64bit mmio: [0xe4000000-0xe5ffffff]
[    0.640946] pci 0000:01:00.0: reg 24 io port: [0xb000-0xb07f]
[    0.640988] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.641070] PCI: Fixups for bus 0000:01
[    0.641109] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.641149] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
[    0.641191] pci 0000:00:01.0: bridge 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.641231] PCI: Bus scan for 0000:01 returning with max=01
[    0.641272] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    0.641315] PCI: Scanning bus 0000:02
[    0.641374] PCI: Fixups for bus 0000:02
[    0.641417] PCI: Bus scan for 0000:02 returning with max=02
[    0.641458] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 0
[    0.642117] PCI: Scanning bus 0000:03
[    0.642177] pci 0000:03:00.0: found [197b:2363] class 000101 header type 00
[    0.642220] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x140
[    0.642308] pci 0000:03:00.0: reg 24 32bit mmio: [0xe9000000-0xe9001fff]
[    0.642381] pci 0000:03:00.0: PME# supported from D3hot
[    0.642423] pci 0000:03:00.0: PME# disabled
[    0.642496] pci 0000:03:00.1: found [197b:2363] class 000101 header type 00
[    0.642537] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x140
[    0.642586] pci 0000:03:00.1: reg 10 io port: [0xc000-0xc007]
[    0.642632] pci 0000:03:00.1: reg 14 io port: [0xc100-0xc103]
[    0.642678] pci 0000:03:00.1: reg 18 io port: [0xc200-0xc207]
[    0.642723] pci 0000:03:00.1: reg 1c io port: [0xc300-0xc303]
[    0.642769] pci 0000:03:00.1: reg 20 io port: [0xc400-0xc40f]
[    0.642880] PCI: Fixups for bus 0000:03
[    0.642919] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    0.642960] pci 0000:00:1c.3: bridge 32bit mmio: [0xe9000000-0xe90fffff]
[    0.643003] PCI: Bus scan for 0000:03 returning with max=03
[    0.643044] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 0
[    0.643087] PCI: Scanning bus 0000:04
[    0.643149] pci 0000:04:00.0: found [10ec:8168] class 000200 header type 00
[    0.643197] pci 0000:04:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.643252] pci 0000:04:00.0: reg 18 64bit mmio: [0xe9110000-0xe9110fff]
[    0.643303] pci 0000:04:00.0: reg 20 64bit mmio: [0xe9100000-0xe910ffff]
[    0.643349] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.643421] pci 0000:04:00.0: supports D1 D2
[    0.643459] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.643502] pci 0000:04:00.0: PME# disabled
[    0.643579] PCI: Fixups for bus 0000:04
[    0.643618] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.643658] pci 0000:00:1c.4: bridge 32bit mmio: [0xe8000000-0xe8ffffff]
[    0.643702] pci 0000:00:1c.4: bridge 64bit mmio pref: 
[0xe9100000-0xe91fffff]
[    0.643743] PCI: Bus scan for 0000:04 returning with max=04
[    0.643784] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
[    0.643828] PCI: Scanning bus 0000:05
[    0.643888] pci 0000:05:07.0: found [104c:8024] class 000c00 header type 00
[    0.643935] pci 0000:05:07.0: reg 10 32bit mmio: [0xe9204000-0xe92047ff]
[    0.643980] pci 0000:05:07.0: reg 14 32bit mmio: [0xe9200000-0xe9203fff]
[    0.644054] pci 0000:05:07.0: supports D1 D2
[    0.644093] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.644134] pci 0000:05:07.0: PME# disabled
[    0.644200] PCI: Fixups for bus 0000:05
[    0.644238] pci 0000:00:1e.0: transparent bridge
[    0.644279] pci 0000:00:1e.0: bridge 32bit mmio: [0xe9200000-0xe92fffff]
[    0.644322] PCI: Bus scan for 0000:05 returning with max=05
[    0.644363] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    0.644405] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    0.644449] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 1
[    0.644492] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 1
[    0.644536] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
[    0.644578] PCI: Bus scan for 0000:00 returning with max=05
[    0.644621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.644761] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.644841] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.644921] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.644999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.657882] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 
15)
[    0.658354] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.658881] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 
15)
[    0.659352] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 
15)
[    0.659822] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.660360] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 
15)
[    0.660830] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 
15)
[    0.661300] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 
15)
[    0.661973] SCSI subsystem initialized
[    0.661973] libata version 3.00 loaded.
[    0.661973] usbcore: registered new interface driver usbfs
[    0.661973] usbcore: registered new interface driver hub
[    0.661973] usbcore: registered new device driver usb
[    0.661973] ACPI: WMI: Mapper loaded
[    0.661973] PCI: Using ACPI for IRQ routing
[    0.690009] Bluetooth: Core ver 2.14
[    0.690059] NET: Registered protocol family 31
[    0.690063] Bluetooth: HCI device and connection manager initialized
[    0.690104] Bluetooth: HCI socket layer initialized
[    0.690142] NetLabel: Initializing
[    0.690180] NetLabel:  domain hash size = 128
[    0.690218] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.690264] NetLabel:  unlabeled traffic allowed by default
[    0.690337] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.690509] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.720005] Switched to high resolution mode on CPU 0
[    0.721700] Switched to high resolution mode on CPU 2
[    0.721759] Switched to high resolution mode on CPU 1
[    0.722003] Switched to high resolution mode on CPU 3
[    0.750009] pnp: PnP ACPI init
[    0.750054] ACPI: bus type pnp registered
[    0.751849] pnp: PnP ACPI: found 12 devices
[    0.751888] ACPI: ACPI bus type pnp unregistered
[    0.751931] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.751972] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.752012] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.752053] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.752093] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.752134] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    0.752177] system 00:08: ioport range 0x400-0x4bf has been reserved
[    0.752220] system 00:09: iomem range 0xe0000000-0xe3ffffff has been 
reserved
[    0.752263] system 00:0a: iomem range 0xccc00-0xcffff has been reserved
[    0.752303] system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
[    0.752344] system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
[    0.752385] system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
[    0.752427] system 00:0a: iomem range 0xcfee0000-0xcfefffff could not be 
reserved
[    0.752475] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.752531] system 00:0a: iomem range 0x100000-0xcfedffff could not be 
reserved
[    0.752580] system 00:0a: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.752621] system 00:0a: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.752662] system 00:0a: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.752703] system 00:0a: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.752744] system 00:0a: iomem range 0xffb00000-0xffb7ffff has been 
reserved
[    0.752785] system 00:0a: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.752826] system 00:0a: iomem range 0xe0000-0xeffff has been reserved
[    0.757480] pci 0000:01:00.0: BAR 6: got res [0xe7000000-0xe701ffff] bus 
[0xe7000000-0xe701ffff] flags 0x27200
[    0.757532] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.757572] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.757612] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe7ffffff
[    0.757653] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.757703] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.757742] pci 0000:00:1c.0:   IO window: disabled
[    0.757783] pci 0000:00:1c.0:   MEM window: disabled
[    0.757823] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.757865] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.757905] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    0.757947] pci 0000:00:1c.3:   MEM window: 0xe9000000-0xe90fffff
[    0.757988] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.758030] pci 0000:04:00.0: BAR 6: got res [0xe9120000-0xe912ffff] bus 
[0xe9120000-0xe912ffff] flags 0x27200
[    0.758081] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.758121] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.758163] pci 0000:00:1c.4:   MEM window: 0xe8000000-0xe8ffffff
[    0.758204] pci 0000:00:1c.4:   PREFETCH window: 
0x000000e9100000-0x000000e91fffff
[    0.758255] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.758295] pci 0000:00:1e.0:   IO window: disabled
[    0.758336] pci 0000:00:1e.0:   MEM window: 0xe9200000-0xe92fffff
[    0.758377] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.758422]   alloc irq_desc for 16 on cpu 0 node 0
[    0.758461]   alloc kstat_irqs on cpu 0 node 0
[    0.758501] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.758542] pci 0000:00:01.0: setting latency timer to 64
[    0.758585] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.758627] pci 0000:00:1c.0: setting latency timer to 64
[    0.758669]   alloc irq_desc for 19 on cpu 0 node 0
[    0.758708]   alloc kstat_irqs on cpu 0 node 0
[    0.758747] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.758789] pci 0000:00:1c.3: setting latency timer to 64
[    0.758832] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.758874] pci 0000:00:1c.4: setting latency timer to 64
[    0.758916] pci 0000:00:1e.0: setting latency timer to 64
[    0.758956] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.758996] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.759037] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.759076] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe7ffffff]
[    0.759116] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
[    0.759157] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.759195] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.759234] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.759273] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.759312] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.759351] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.759391] pci_bus 0000:03: resource 1 mem: [0xe9000000-0xe90fffff]
[    0.759431] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.759469] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.759508] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.759548] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe8ffffff]
[    0.759588] pci_bus 0000:04: resource 2 mem: [0xe9100000-0xe91fffff]
[    0.759628] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.759667] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.759706] pci_bus 0000:05: resource 1 mem: [0xe9200000-0xe92fffff]
[    0.759746] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.760398] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.760437] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.760495] NET: Registered protocol family 2
[    0.860203] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.861134] TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)
[    0.864359] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.864964] TCP: Hash tables configured (established 524288 bind 65536)
[    0.865005] TCP reno registered
[    0.890115] NET: Registered protocol family 1
[    0.890614] checking if image is initramfs... it is
[    2.666303] Freeing initrd memory: 55627k freed
[    2.692716] Scanning for low memory corruption every 60 seconds
[    2.692862] audit: initializing netlink socket (disabled)
[    2.692913] type=2000 audit(1260216258.690:1): initialized
[    2.699348] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.700414] VFS: Disk quotas dquot_6.5.2
[    2.700490] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.700920] fuse init (API version 7.11)
[    2.701011] msgmni has been set to 11844
[    2.701223] alg: No test for stdrng (krng)
[    2.701279] io scheduler noop registered
[    2.701319] io scheduler anticipatory registered
[    2.701357] io scheduler deadline registered
[    2.701436] io scheduler cfq registered (default)
[    2.701481] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x181
[    2.701523] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.701564] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.701606] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xba
[    2.701647] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x181
[    2.701687] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.701728] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.701768] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xba
[    2.701809] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x181
[    2.701849] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.701890] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.701943] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xba
[    2.701984] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x181
[    2.702024] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
[    2.702065] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x399
[    2.702116] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xba
[    2.702157] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x181
[    2.702197] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x30
[    2.702238] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x399
[    2.702288] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xba
[    2.702329] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x181
[    2.702369] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
[    2.702419] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x399
[    2.702478] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xba
[    2.702525] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x181
[    2.702565] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.702606] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.702646] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xba
[    2.702687] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x181
[    2.702727] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.702768] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.702809] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xba
[    2.702849] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x181
[    2.702890] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
[    2.702930] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x399
[    2.702971] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xba
[    2.703011] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x181
[    2.703052] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x30
[    2.703092] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x399
[    2.703133] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xba
[    2.703173] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x181
[    2.703214] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.703254] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.703305] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xba
[    2.703346] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x181
[    2.703387] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
[    2.703427] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x399
[    2.703478] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xba
[    2.703519] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x181
[    2.703559] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
[    2.703600] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x399
[    2.703651] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xba
[    2.703692] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x181
[    2.703732] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
[    2.703772] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x399
[    2.703835] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xba
[    2.703876] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x181
[    2.703917] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.703957] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.703998] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xba
[    2.704039] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x181
[    2.704079] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.704119] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.704160] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xba
[    2.704201] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x181
[    2.704241] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
[    2.704282] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x399
[    2.704323] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xba
[    2.704363] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x181
[    2.704404] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
[    2.704444] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x399
[    2.704485] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xba
[    2.704525] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x181
[    2.704566] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x30
[    2.704606] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x399
[    2.704647] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xba
[    2.704688] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk+0x0/0x1ed
[    2.704734] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.704774] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.704815] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xba
[    2.704856] pci 0000:01:00.0: Boot video device
[    2.704895] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.704936] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.704976] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xba
[    2.705017] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    2.705058] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x399
[    2.705098] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xba
[    2.705139] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.705179] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.705220] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xba
[    2.705260] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x30
[    2.705301] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x399
[    2.705342] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xba
[    2.705440] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    2.705509]   alloc irq_desc for 24 on cpu 0 node 0
[    2.705548]   alloc kstat_irqs on cpu 0 node 0
[    2.705591] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    2.705674] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.705750]   alloc irq_desc for 25 on cpu 0 node 0
[    2.705789]   alloc kstat_irqs on cpu 0 node 0
[    2.705830] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    2.705929] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    2.706006]   alloc irq_desc for 26 on cpu 0 node 0
[    2.706044]   alloc kstat_irqs on cpu 0 node 0
[    2.706085] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    2.706187] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.706263]   alloc irq_desc for 27 on cpu 0 node 0
[    2.706302]   alloc kstat_irqs on cpu 0 node 0
[    2.706342] pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
[    2.706449] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.706965] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.707117] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.707167] ACPI: Power Button (FF) [PWRF]
[    2.707233] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.707283] ACPI: Power Button (CM) [PWRB]
[    2.707679] ACPI: SSDT CFEE7AD0, 022A (r1  PmRef  Cpu0Ist     3000 INTL 
20040311)
[    2.707961] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.708120] processor ACPI_CPU:00: registered as cooling_device0
[    2.708161] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.708406] ACPI: SSDT CFEE7F90, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 
20040311)
[    2.708742] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU1._PDC] (Node ffff8801af044f20), AE_ALREADY_EXISTS
[    2.708877] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.709140] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.709307] processor ACPI_CPU:01: registered as cooling_device1
[    2.709349] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.709637] ACPI: SSDT CFEE80F0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 
20040311)
[    2.709997] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU2._PDC] (Node ffff8801af044fa0), AE_ALREADY_EXISTS
[    2.710142] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.710352] ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
[    2.710510] processor ACPI_CPU:02: registered as cooling_device2
[    2.710551] ACPI: Processor [CPU2] (supports 8 throttling states)
[    2.710812] ACPI: SSDT CFEE8250, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 
20040311)
[    2.711149] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU3._PDC] (Node ffff8801af04b020), AE_ALREADY_EXISTS
[    2.711283] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.711516] ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
[    2.711677] processor ACPI_CPU:03: registered as cooling_device3
[    2.711719] ACPI: Processor [CPU3] (supports 8 throttling states)
[    2.803909] Linux agpgart interface v0.103
[    2.803953] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.804644] brd: module loaded
[    2.804889] loop: module loaded
[    2.805096] Fixed MDIO Bus: probed
[    2.805750] PPP generic driver version 2.4.2
[    2.805822] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    2.805886] Driver 'sd' needs updating - please use bus_type methods
[    2.805931] Driver 'sr' needs updating - please use bus_type methods
[    2.806006] ahci 0000:03:00.0: version 3.0
[    2.806020] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.830031] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 
impl SATA mode
[    2.830083] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part 
[    2.830134] ahci 0000:03:00.0: setting latency timer to 64
[    2.830332] scsi0 : ahci
[    2.830447] scsi1 : ahci
[    2.830539] ata1: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000100 
irq 19
[    2.830589] ata2: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000180 
irq 19
[    3.180022] ata1: SATA link down (SStatus 0 SControl 300)
[    3.550021] ata2: SATA link down (SStatus 0 SControl 300)
[    3.570050] ata_piix 0000:00:1f.2: version 2.12
[    3.570097] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    3.570155] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    3.570354] ata_piix 0000:00:1f.2: setting latency timer to 64
[    3.570463] scsi2 : ata_piix
[    3.570575] scsi3 : ata_piix
[    3.571146] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    3.571189] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    4.430053] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.430109] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.496205] ata3.00: HPA detected: current 1953523055, native 1953525168
[    4.496250] ata3.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    4.496292] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.496474] ata3.01: ATA-7: ST3300831AS, 3.02, max UDMA/133
[    4.496516] ata3.01: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.556223] ata3.00: configured for UDMA/133
[    4.590299] ata3.01: configured for UDMA/133
[    4.590423] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 
PQ: 0 ANSI: 5
[    4.590537] sd 2:0:0:0: [sda] 1953523055 512-byte hardware sectors: (1.00 
TB/931 GiB)
[    4.590595] sd 2:0:0:0: [sda] Write Protect is off
[    4.590634] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.590688] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.590772] sd 2:0:0:0: [sda] 1953523055 512-byte hardware sectors: (1.00 
TB/931 GiB)
[    4.590829] sd 2:0:0:0: [sda] Write Protect is off
[    4.590868] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.590921] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.590972]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    4.662355] sd 2:0:0:0: [sda] Attached SCSI disk
[    4.662418] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    4.662495] scsi 2:0:1:0: Direct-Access     ATA      ST3300831AS      3.02 
PQ: 0 ANSI: 5
[    4.662606] sd 2:0:1:0: [sdb] 586072368 512-byte hardware sectors: (300 
GB/279 GiB)
[    4.662665] sd 2:0:1:0: [sdb] Write Protect is off
[    4.662704] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.662758] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.662836] sd 2:0:1:0: [sdb] 586072368 512-byte hardware sectors: (300 
GB/279 GiB)
[    4.662893] sd 2:0:1:0: [sdb] Write Protect is off
[    4.662932] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    4.662985] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.663036]  sdb: sdb1
[    4.682863] sd 2:0:1:0: [sdb] Attached SCSI disk
[    4.682925] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    5.540051] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.540108] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.600280] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    5.600323] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.600384] ata4.01: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[    5.620295] ata4.00: configured for UDMA/133
[    5.660188] ata4.01: configured for UDMA/100
[    5.660561] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    5.660668] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)
[    5.660725] sd 3:0:0:0: [sdc] Write Protect is off
[    5.660764] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.660817] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    5.660899] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)
[    5.660955] sd 3:0:0:0: [sdc] Write Protect is off
[    5.660995] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.661048] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    5.661099]  sdc: sdc2 < sdc5 sdc6 sdc7 > sdc3
[    5.733039] sd 3:0:0:0: [sdc] Attached SCSI disk
[    5.733101] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    5.734301] scsi 3:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 
PQ: 0 ANSI: 5
[    5.737903] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
[    5.737954] Uniform CD-ROM driver Revision: 3.20
[    5.738060] sr 3:0:1:0: Attached scsi CD-ROM sr0
[    5.738121] sr 3:0:1:0: Attached scsi generic sg3 type 5
[    5.738178] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    5.738221] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    5.738416] ata_piix 0000:00:1f.5: setting latency timer to 64
[    5.738509] scsi4 : ata_piix
[    5.738615] scsi5 : ata_piix
[    5.739034] ata5: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 
19
[    5.739077] ata6: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 
19
[    6.090639] ata5: SATA link down (SStatus 0 SControl 300)
[    6.450638] ata6: SATA link down (SStatus 0 SControl 300)
[    6.450901] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    6.450944] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[    6.451009] pata_jmicron 0000:03:00.1: enabling bus mastering
[    6.451052] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    6.451133] scsi6 : pata_jmicron
[    6.451208] scsi7 : pata_jmicron
[    6.451697] ata7: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 
16
[    6.451738] ata8: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 
16
[    6.781589] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.781643]   alloc irq_desc for 18 on cpu 0 node 0
[    6.781682]   alloc kstat_irqs on cpu 0 node 0
[    6.781722] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.781769] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.781810] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.781882] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    6.785832] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.785881] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
[    6.800010] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.800119] usb usb1: configuration #1 chosen from 1 choice
[    6.800180] hub 1-0:1.0: USB hub found
[    6.800221] hub 1-0:1.0: 6 ports detected
[    6.800328]   alloc irq_desc for 23 on cpu 0 node 0
[    6.800367]   alloc kstat_irqs on cpu 0 node 0
[    6.800407] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.800453] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.800493] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.800559] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    6.804507] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.804554] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
[    6.820006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.820101] usb usb2: configuration #1 chosen from 1 choice
[    6.820163] hub 2-0:1.0: USB hub found
[    6.820204] hub 2-0:1.0: 6 ports detected
[    6.820300] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.820348] uhci_hcd: USB Universal Host Controller Interface driver
[    6.820418] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    6.820462] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.820502] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.820566] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    6.820632] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
[    6.820720] usb usb3: configuration #1 chosen from 1 choice
[    6.820774] hub 3-0:1.0: USB hub found
[    6.820815] hub 3-0:1.0: 2 ports detected
[    6.820905]   alloc irq_desc for 21 on cpu 0 node 0
[    6.820944]   alloc kstat_irqs on cpu 0 node 0
[    6.820984] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    6.821027] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.821068] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.821137] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    6.821209] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
[    6.821302] usb usb4: configuration #1 chosen from 1 choice
[    6.821355] hub 4-0:1.0: USB hub found
[    6.821396] hub 4-0:1.0: 2 ports detected
[    6.821485] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.821529] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.821569] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.821633] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    6.821698] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
[    6.821785] usb usb5: configuration #1 chosen from 1 choice
[    6.821838] hub 5-0:1.0: USB hub found
[    6.821879] hub 5-0:1.0: 2 ports detected
[    6.821967] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.822011] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.822051] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.822711] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    6.822776] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    6.822863] usb usb6: configuration #1 chosen from 1 choice
[    6.822918] hub 6-0:1.0: USB hub found
[    6.822959] hub 6-0:1.0: 2 ports detected
[    6.823049] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    6.823092] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.823133] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.823197] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    6.823262] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    6.823349] usb usb7: configuration #1 chosen from 1 choice
[    6.823407] hub 7-0:1.0: USB hub found
[    6.823447] hub 7-0:1.0: 2 ports detected
[    6.823537] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.823580] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.823621] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.823683] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    6.823748] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    6.823840] usb usb8: configuration #1 chosen from 1 choice
[    6.823893] hub 8-0:1.0: USB hub found
[    6.823935] hub 8-0:1.0: 2 ports detected
[    6.824054] PNP: No PS/2 controller found. Probing ports directly.
[    6.824376] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.824420] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.843781] mice: PS/2 mouse device common for all mice
[    6.943809] rtc_cmos 00:04: RTC can wake from S4
[    6.943884] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    6.943943] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    6.944042] device-mapper: uevent: version 1.0.3
[    6.944129] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
[    6.944262] device-mapper: multipath: version 1.0.5 loaded
[    6.944304] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.944514] cpuidle: using governor ladder
[    6.944700] cpuidle: using governor menu
[    6.944992] TCP cubic registered
[    6.945113] NET: Registered protocol family 10
[    6.945427] lo: Disabled Privacy Extensions
[    6.945651] NET: Registered protocol family 17
[    6.945699] Bluetooth: L2CAP ver 2.11
[    6.945737] Bluetooth: L2CAP socket layer initialized
[    6.945776] Bluetooth: SCO (Voice Link) ver 0.6
[    6.945815] Bluetooth: SCO socket layer initialized
[    6.945879] Bluetooth: RFCOMM socket layer initialized
[    6.945925] Bluetooth: RFCOMM TTY layer initialized
[    6.945967] Bluetooth: RFCOMM ver 1.10
[    6.947638] Marking TSC unstable due to TSC halts in idle
[    6.951271] registered taskstats version 1
[    6.951414]   Magic number: 5:198:93
[    6.951527] rtc_cmos 00:04: setting system clock to 2009-12-07 20:04:23 UTC 
(1260216263)
[    6.951582] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.951622] EDD information not available.
[    6.951696] Freeing unused kernel memory: 624k freed
[    6.951845] Write protecting the kernel read-only data: 6772k
[    7.045512] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.045579] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.045630] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    7.045681] r8169 0000:04:00.0: setting latency timer to 64
[    7.045800]   alloc irq_desc for 28 on cpu 0 node 0
[    7.045842]   alloc kstat_irqs on cpu 0 node 0
[    7.045889] r8169 0000:04:00.0: irq 28 for MSI/MSI-X
[    7.046024] r8169 0000:04:00.0: Missing EEPROM signature: 0000
[    7.046459] eth0: RTL8168c/8111c at 0xffffc20000c5c000, 00:1f:d0:9d:27:af, 
XID 3c4000c0 IRQ 28
[    7.068759] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    7.130054] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[e9204000-e92047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    7.651956] kjournald starting.  Commit interval 5 seconds
[    7.651980] EXT3-fs: mounted filesystem with ordered data mode.
[    7.772530] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    8.056786] usb 3-1: configuration #1 chosen from 1 choice
[    8.333788] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    8.450425] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007c2d6400001fd0]
[    8.524843] usb 5-1: configuration #1 chosen from 1 choice
[    8.800042] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    8.980869] usb 5-2: configuration #1 chosen from 1 choice
[    9.261291] usb 8-1: new full speed USB device using uhci_hcd and address 2
[    9.434890] usb 8-1: configuration #1 chosen from 1 choice
[    9.436854] hub 8-1:1.0: USB hub found
[    9.438822] hub 8-1:1.0: 4 ports detected
[    9.721285] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    9.900922] usb 8-2: configuration #1 chosen from 1 choice
[    9.982826] usb 8-1.4: new low speed USB device using uhci_hcd and address 
4
[   10.132878] usb 8-1.4: configuration #1 chosen from 1 choice
[   12.958357] udev: starting version 147
[   13.545994] nvidia: module license 'NVIDIA' taints kernel.
[   13.799818] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.799824] nvidia 0000:01:00.0: setting latency timer to 64
[   13.800187] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fri 
Aug 14 17:35:21 PDT 2009
[   14.220041] usbcore: registered new interface driver hiddev
[   14.238120] input: Logitech USB RECEIVER as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
[   14.313867] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.2-2/input0
[   14.328095] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.0/input/input4
[   14.375754] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.392623] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 
Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input0
[   14.411531] Linux video capture interface: v2.00
[   14.417145] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.1/input/input5
[   14.432938] lp: driver loaded but no devices found
[   14.510156] generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 
Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input1
[   14.510186] usbcore: registered new interface driver usbhid
[   14.510189] usbhid: v2.6:USB HID core driver
[   14.672447] pwc: Philips webcam module version 10.0.13 loaded.
[   14.672449] pwc: Supports Philips PCA645/646, PCVC675/680/690, 
PCVC720[40]/730/740/750 & PCVC830/840.
[   14.672451] pwc: Also supports the Askey VC010, various Logitech Quickcams, 
Samsung MPC-C10 and MPC-C30,
[   14.672452] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and 
Visionite VCS-UC300 and VCS-UM100.
[   14.672471] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
[   14.672547] pwc: Registered as /dev/video0.
[   14.675806] usbcore: registered new interface driver Philips webcam
[   15.158552]   alloc irq_desc for 22 on cpu 0 node 0
[   15.158555]   alloc kstat_irqs on cpu 0 node 0
[   15.158560] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[   15.158733] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.361076] usbcore: registered new interface driver snd-usb-audio
[   15.649258] Adding 6562544k swap on /dev/mapper/cryptoswap.  Priority:-1 
extents:1 across:6562544k 
[   16.516327] EXT3 FS on sda8, internal journal
[   16.975508] r8169: eth0: link up
[   16.975513] r8169: eth0: link up
[   17.327586] kjournald starting.  Commit interval 5 seconds
[   17.327604] EXT3-fs: mounted filesystem with ordered data mode.
[   17.375307] kjournald starting.  Commit interval 5 seconds
[   17.381488] EXT3 FS on sda6, internal journal
[   17.381491] EXT3-fs: mounted filesystem with ordered data mode.
[   17.550320] kjournald starting.  Commit interval 5 seconds
[   17.550346] EXT3-fs: mounted filesystem with ordered data mode.
[   17.570280] kjournald starting.  Commit interval 5 seconds
[   17.570567] EXT3 FS on sdc6, internal journal
[   17.570569] EXT3-fs: mounted filesystem with ordered data mode.
[   19.008616] ppdev: user-space parallel port driver
[   20.715390] RPC: Registered udp transport module.
[   20.715392] RPC: Registered tcp transport module.
[   25.525338] kjournald starting.  Commit interval 5 seconds
[   25.525361] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[   25.525843] EXT3 FS on dm-1, internal journal
[   25.525848] EXT3-fs: mounted filesystem with ordered data mode.
[   27.371276] eth0: no IPv6 routers present
-----------------------------------------------------------------------------


Volker





