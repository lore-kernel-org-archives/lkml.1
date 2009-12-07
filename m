Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbZLGUgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbZLGUgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964775AbZLGUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:36:40 -0500
Received: from twilight.fidra.de ([88.198.14.164]:55179 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934943AbZLGUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:36:38 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Mon, 7 Dec 2009 21:36:40 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-tip-02731-gd17424f; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <200912072013.46332.vl@fidra.de> <4B1D561C.9030802@kernel.org>
In-Reply-To: <4B1D561C.9030802@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912072136.40202.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009 20:23:08 Yinghai Lu wrote:
> Volker Lanz wrote:
> > On Monday 07 December 2009 19:24:02 Yinghai Lu wrote:
> >> Volker Lanz wrote:
> >>> Hi,
> >>>
> >>> updating to my distro's new 2.6.31 kernel on an x86_64 quad core
> >>> machine with 6 GB of RAM I noticed resuming from suspend still worked
> >>> as before, but the machine will now reproducably freeze (have to hard
> >>> reset) afterwards as soon as I do something disk I/O heavy, though the
> >>> problem is probably not related to disk activity at all.
> >>>
> >>> A current mainline 2.6.32 checkout shows the same behaviour.
> >>>
> >>> I git-bisected the problem to this commit:
> >>>
> >>>
> >>> -----------------------------------------------------------------------
> >>>-- ---- commit 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
> >>> Author: Yinghai Lu <yinghai@kernel.org>
> >>> Date:   Thu Mar 12 22:36:01 2009 -0700
> >>>
> >>>     x86: make e820_update_range() handle small range update
> >>>
> >>>     Impact: enhance e820 code to handle more cases
> >>>
> >>>     Try to handle new range which could be covered by one entry.
> >>>
> >>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>     Cc: jbeulich@novell.com
> >>>     LKML-Reference: <49B9F0C1.10402@kernel.org>
> >>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>> -----------------------------------------------------------------------
> >>>-- ----
> >>>
> >>>
> >>> A kernel built from this revision does not boot, so the first booting
> >>> kernel to show the problem actually seems to be:
> >>>
> >>>
> >>> -----------------------------------------------------------------------
> >>>-- ---- commit 6d7942dc2a70a7e74c352107b150265602671588
> >>> Author: Yinghai Lu <yinghai@kernel.org>
> >>> Date:   Sat Mar 14 14:32:41 2009 -0700
> >>>
> >>>     x86: fix 64k corruption-check
> >>>
> >>>     Impact: fix boot crash
> >>>
> >>>     Need to exit early if the addr is far above 64k.
> >>>
> >>>     The crash got exposed by:
> >>>
> >>>       78a8b35: x86: make e820_update_range() handle small range update
> >>>
> >>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>     Cc: <stable@kernel.org>
> >>>     LKML-Reference: <49BC2279.2030101@kernel.org>
> >>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>> -----------------------------------------------------------------------
> >>>-- ----
> >>>
> >>>
> >>> The last kernel to work without problems thus seems to be this one:
> >>>
> >>>
> >>> -----------------------------------------------------------------------
> >>>-- ---- commit 773e673de27297d07d852e7e9bfd1a695cae1da2
> >>> Author: Yinghai Lu <yinghai@kernel.org>
> >>> Date:   Thu Mar 12 21:35:18 2009 -0700
> >>>
> >>>     x86: fix e820_update_range()
> >>>
> >>>     Impact: fix left range size on head
> >>>
> >>>     | commit 5c0e6f035df983210e4d22213aed624ced502d3d
> >>>     |    x86: fix code paths used by update_mptable
> >>>     |    Impact: fix crashes under Xen due to unrobust e820 code
> >>>
> >>>     fixes one e820 bug, but introduces another bug.
> >>>
> >>>     Need to update size for left range at first in case it is header.
> >>>
> >>>     also add __e820_add_region take more parameter.
> >>>
> >>>     Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>>     Cc: jbeulich@novell.com
> >>>     LKML-Reference: <49B9E286.502@kernel.org>
> >>>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>> -----------------------------------------------------------------------
> >>>-- ----
> >>>
> >>>
> >>> The problem is 100% reproducable on this machine: Resuming and then
> >>> copying /usr/ to $HOME will freeze after a few hundred MB have been
> >>> copied. Earlier kernels worked fine for the last couple of months.
> >>>
> >>> What additional information is required to help diagnose and hopefully
> >>> fix the problem?
> >>
> >> whole boot log with CONFIG_PCI_DEBUG and debug on command line.
> >
> > Here it is. It's huge, I hope you were expecting that...
> 
> and the one with current tip?
> 
> http://people.redhat.com/mingo/tip.git/readme.txt

With this kernel, the problem persists. Here's the log:


-----------------------------------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-tip-02731-gd17424f (vl@trevor) (gcc 
version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #22 SMP Mon Dec 7 21:09:21 CET 2009
[    0.000000] Command line: root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro 
nosplash debug
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 1B0000000 mask FF0000000 uncachable
[    0.000000]   6 base 0CFF00000 mask FFFF00000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) 
==> (reserved)
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
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ c000-12000
[    0.000000] init_memory_mapping: 0000000100000000-00000001b0000000
[    0.000000]  0100000000 - 01b0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1b0000000 @ 10000-18000
[    0.000000] RAMDISK: 34054000 - 37fef801
[    0.000000] ACPI: RSDP 00000000000f7280 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfee2040 0004C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfee2180 04CD9 (v01 GBT    GBTUACPI 00001000 
MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cfee0000 00040
[    0.000000] ACPI: EUDS 00000000cfee7580 00500 (v01 GBT             00000000      
00000000)
[    0.000000] ACPI: HPET 00000000cfee74c0 00038 (v01 GBT    GBTUACPI 42302E31 
GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfee7540 0003C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: APIC 00000000cfee6ec0 00084 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000cfee83b0 0018A (v01  PmRef  Cpu0Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee8540 0018A (v01  PmRef  Cpu1Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee86d0 0018A (v01  PmRef  Cpu2Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee8860 0018A (v01  PmRef  Cpu3Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee89f0 003AB (v01  PmRef    CpuPm 00003000 
INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] found SMP MP-table at [ffff8800000f5890] f5890
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001b0000000
[    0.000000] Bootmem setup node 0 0000000000000000-00000001b0000000
[    0.000000]   NODE_DATA [0000000000013000 - 0000000000017fff]
[    0.000000]   bootmap [0000000000018000 -  000000000004dfff] pages 36
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 01b0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0001000000 - 0001c89284]    TEXT DATA BSS ==> [0001000000 
- 0001c89284]
[    0.000000]   #3 [0034054000 - 0037fef801]          RAMDISK ==> [0034054000 
- 0037fef801]
[    0.000000]   #4 [0001c8a000 - 0001c8a0f6]              BRK ==> [0001c8a000 
- 0001c8a0f6]
[    0.000000]   #5 [0000008000 - 000000c000]      ACPI WAKEUP ==> [0000008000 
- 000000c000]
[    0.000000]   #6 [000000c000 - 0000010000]          PGTABLE ==> [000000c000 
- 0000010000]
[    0.000000]   #7 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 
- 0000013000]
[    0.000000]   #8 [00000f58a0 - 0000100000]    BIOS reserved ==> [00000f58a0 
- 0000100000]
[    0.000000]   #9 [00000f5890 - 00000f58a0]     MP-table mpf ==> [00000f5890 
- 00000f58a0]
[    0.000000]   #10 [000009f800 - 00000f0d00]    BIOS reserved ==> 
[000009f800 - 00000f0d00]
[    0.000000]   #11 [00000f0ebc - 00000f5890]    BIOS reserved ==> 
[00000f0ebc - 00000f5890]
[    0.000000]   #12 [00000f0d00 - 00000f0ebc]     MP-table mpc ==> 
[00000f0d00 - 00000f0ebc]
[    0.000000]  [ffffea0000000000-ffffea0005ffffff] PMD -> [ffff880028600000-
ffff88002dbfffff] on node 0
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
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3829 pages, LIFO batch:0
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
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
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
[    0.000000] Allocating PCI resources starting at e4000000 (gap: 
e4000000:1ac00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s91416 r8192 
d23272 u524288
[    0.000000] pcpu-alloc: s91416 r8192 d23272 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 1548173
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=160351ee-
c9b0-4a72-9fd5-9962c8137a7e ro nosplash debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 6057076k/7077888k available (5318k kernel code, 787992k 
absent, 232820k reserved, 5695k data, 652k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2833.355 MHz processor.
[    0.010005] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5666.71 BogoMIPS (lpj=28333550)
[    0.010102] Security Framework initialized
[    0.010145] SELinux:  Disabled at boot.
[    0.010690] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.015409] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.017728] Mount-cache hash table entries: 256
[    0.017893] Initializing cgroup subsys ns
[    0.017935] Initializing cgroup subsys cpuacct
[    0.017975] Initializing cgroup subsys memory
[    0.018017] Initializing cgroup subsys freezer
[    0.018056] Initializing cgroup subsys net_cls
[    0.018112] CPU 0/0x0 -> Node 0
[    0.018149] CPU: Physical Processor ID: 0
[    0.018187] CPU: Processor Core ID: 0
[    0.018226] mce: CPU supports 6 MCE banks
[    0.018269] CPU0: Thermal monitoring enabled (TM2)
[    0.018309] using mwait in idle threads.
[    0.018347] Performance Events: Core2 events, Intel PMU driver.
[    0.018442] ... version:                2
[    0.018479] ... bit width:              40
[    0.018517] ... generic registers:      2
[    0.018555] ... value mask:             000000ffffffffff
[    0.018594] ... max period:             000000007fffffff
[    0.018632] ... fixed-purpose events:   3
[    0.018670] ... event mask:             0000000700000003
[    0.019692] ACPI: Core revision 20090903
[    0.027900] Setting APIC routing to flat
[    0.028240] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.127856] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.130000] Booting processor 1 APIC 0x3 ip 0x6000
[    0.130000] Initializing CPU#1
[    0.130000] CPU 1/0x3 -> Node 0
[    0.130000] CPU: Physical Processor ID: 0
[    0.130000] CPU: Processor Core ID: 3
[    0.130000] CPU1: Thermal monitoring enabled (TM2)
[    0.280090] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.290059] Booting processor 2 APIC 0x2 ip 0x6000
[    0.290050] Initializing CPU#2
[    0.290050] CPU 2/0x2 -> Node 0
[    0.290050] CPU: Physical Processor ID: 0
[    0.290050] CPU: Processor Core ID: 2
[    0.290050] CPU2: Thermal monitoring enabled (TM2)
[    0.450090] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.460059] Booting processor 3 APIC 0x1 ip 0x6000
[    0.460049] Initializing CPU#3
[    0.460049] CPU 3/0x1 -> Node 0
[    0.460049] CPU: Physical Processor ID: 0
[    0.460049] CPU: Processor Core ID: 1
[    0.460049] CPU3: Thermal monitoring enabled (TM2)
[    0.620088] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.630013] Brought up 4 CPUs
[    0.630052] Total of 4 processors activated (22664.82 BogoMIPS).
[    0.632719] regulator: core version 0.5
[    0.632778] Time: 21:22:24  Date: 12/07/09
[    0.632844] NET: Registered protocol family 16
[    0.632966] ACPI: bus type pci registered
[    0.633053] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.633094] PCI: MCFG area at e0000000 reserved in E820
[    0.634412] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.634451] PCI: Using configuration type 1 for base access
[    0.635112] bio: create slab <bio-0> at 0
[    0.635613] ACPI: EC: Look up EC in DSDT
[    0.640352] ACPI: Interpreter enabled
[    0.640395] ACPI: (supports S0 S3 S4 S5)
[    0.640553] ACPI: Using IOAPIC for interrupt routing
[    0.644231] ACPI: No dock devices found.
[    0.644344] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.644402] PCI: Scanning bus 0000:00
[    0.644445] pci 0000:00:00.0: found [8086:2e20] class 000600 header type 00
[    0.644503] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.644544] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.644597] pci 0000:00:01.0: found [8086:2e21] class 000604 header type 01
[    0.644651] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x19f
[    0.644692] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.644741] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.644782] pci 0000:00:01.0: PME# disabled
[    0.644848] pci 0000:00:1a.0: found [8086:3a37] class 000c03 header type 00
[    0.644913] pci 0000:00:1a.0: reg 20 io port: [0xe100-0xe11f]
[    0.644962] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x19f
[    0.645003] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645064] pci 0000:00:1a.1: found [8086:3a38] class 000c03 header type 00
[    0.645128] pci 0000:00:1a.1: reg 20 io port: [0xe200-0xe21f]
[    0.645177] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x19f
[    0.645218] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645278] pci 0000:00:1a.2: found [8086:3a39] class 000c03 header type 00
[    0.645343] pci 0000:00:1a.2: reg 20 io port: [0xe000-0xe01f]
[    0.645391] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x19f
[    0.645432] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645498] pci 0000:00:1a.7: found [8086:3a3c] class 000c03 header type 00
[    0.645552] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe9305000-0xe93053ff]
[    0.645617] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x19f
[    0.645658] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645723] pci 0000:00:1b.0: found [8086:3a3e] class 000403 header type 00
[    0.645777] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe9300000-0xe9303fff]
[    0.645835] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x19f
[    0.645876] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645930] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.645972] pci 0000:00:1b.0: PME# disabled
[    0.646022] pci 0000:00:1c.0: found [8086:3a40] class 000604 header type 01
[    0.646080] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x19f
[    0.646121] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646178] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.646219] pci 0000:00:1c.0: PME# disabled
[    0.646272] pci 0000:00:1c.3: found [8086:3a46] class 000604 header type 01
[    0.646330] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x19f
[    0.646370] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646428] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.646469] pci 0000:00:1c.3: PME# disabled
[    0.646520] pci 0000:00:1c.4: found [8086:3a48] class 000604 header type 01
[    0.646578] pci 0000:00:1c.4: calling quirk_resource_alignment+0x0/0x19f
[    0.646619] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646676] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.646717] pci 0000:00:1c.4: PME# disabled
[    0.646771] pci 0000:00:1d.0: found [8086:3a34] class 000c03 header type 00
[    0.646836] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.646885] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x19f
[    0.646926] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646986] pci 0000:00:1d.1: found [8086:3a35] class 000c03 header type 00
[    0.647051] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.647099] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x19f
[    0.647140] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647201] pci 0000:00:1d.2: found [8086:3a36] class 000c03 header type 00
[    0.647266] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.647314] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x19f
[    0.647355] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647420] pci 0000:00:1d.7: found [8086:3a3a] class 000c03 header type 00
[    0.647473] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe9304000-0xe93043ff]
[    0.647538] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x19f
[    0.647579] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647641] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    0.647700] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x19f
[    0.647740] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647802] pci 0000:00:1f.0: found [8086:3a18] class 000601 header type 00
[    0.647885] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x19f
[    0.647926] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647993] pci 0000:00:1f.2: found [8086:3a20] class 000101 header type 00
[    0.648046] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.648088] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.648130] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.648172] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.648214] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.648256] pci 0000:00:1f.2: reg 24 io port: [0xf100-0xf10f]
[    0.648302] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x19f
[    0.648343] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.648403] pci 0000:00:1f.3: found [8086:3a30] class 000c05 header type 00
[    0.648452] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe9306000-0xe93060ff]
[    0.648502] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.648549] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x19f
[    0.648590] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.648642] pci 0000:00:1f.5: found [8086:3a26] class 000101 header type 00
[    0.648695] pci 0000:00:1f.5: reg 10 io port: [0xe700-0xe707]
[    0.648738] pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe803]
[    0.648780] pci 0000:00:1f.5: reg 18 io port: [0xe900-0xe907]
[    0.648822] pci 0000:00:1f.5: reg 1c io port: [0xea00-0xea03]
[    0.648865] pci 0000:00:1f.5: reg 20 io port: [0xeb00-0xeb0f]
[    0.648907] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.648952] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x19f
[    0.648993] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.649050] PCI: Fixups for bus 0000:00
[    0.649089] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    0.649131] PCI: Scanning bus 0000:01
[    0.649177] pci 0000:01:00.0: found [10de:0402] class 000300 header type 00
[    0.649227] pci 0000:01:00.0: reg 10 32bit mmio: [0xe6000000-0xe6ffffff]
[    0.649273] pci 0000:01:00.0: reg 14 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.649319] pci 0000:01:00.0: reg 1c 64bit mmio: [0xe4000000-0xe5ffffff]
[    0.649362] pci 0000:01:00.0: reg 24 io port: [0xb000-0xb07f]
[    0.649404] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.649447] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.649529] PCI: Fixups for bus 0000:01
[    0.649568] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.650002] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
[    0.650650] pci 0000:00:01.0: bridge 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.650691] PCI: Bus scan for 0000:01 returning with max=01
[    0.650732] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    0.650779] PCI: Scanning bus 0000:02
[    0.650841] PCI: Fixups for bus 0000:02
[    0.650884] PCI: Bus scan for 0000:02 returning with max=02
[    0.650925] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 0
[    0.650968] PCI: Scanning bus 0000:03
[    0.651020] pci 0000:03:00.0: found [197b:2363] class 000101 header type 00
[    0.651072] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x140
[    0.651160] pci 0000:03:00.0: reg 24 32bit mmio: [0xe9000000-0xe9001fff]
[    0.651210] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.651274] pci 0000:03:00.0: PME# supported from D3hot
[    0.651316] pci 0000:03:00.0: PME# disabled
[    0.651378] pci 0000:03:00.1: found [197b:2363] class 000101 header type 00
[    0.651431] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x140
[    0.651480] pci 0000:03:00.1: reg 10 io port: [0xc000-0xc007]
[    0.651525] pci 0000:03:00.1: reg 14 io port: [0xc100-0xc103]
[    0.651571] pci 0000:03:00.1: reg 18 io port: [0xc200-0xc207]
[    0.651617] pci 0000:03:00.1: reg 1c io port: [0xc300-0xc303]
[    0.651662] pci 0000:03:00.1: reg 20 io port: [0xc400-0xc40f]
[    0.651719] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x19f
[    0.651816] PCI: Fixups for bus 0000:03
[    0.651855] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    0.651896] pci 0000:00:1c.3: bridge 32bit mmio: [0xe9000000-0xe90fffff]
[    0.651940] PCI: Bus scan for 0000:03 returning with max=03
[    0.651981] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 0
[    0.652024] PCI: Scanning bus 0000:04
[    0.652076] pci 0000:04:00.0: found [10ec:8168] class 000200 header type 00
[    0.652135] pci 0000:04:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.652190] pci 0000:04:00.0: reg 18 64bit mmio pref: 
[0xe9110000-0xe9110fff]
[    0.652241] pci 0000:04:00.0: reg 20 64bit mmio pref: 
[0xe9100000-0xe910ffff]
[    0.652287] pci 0000:04:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.652331] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.652400] pci 0000:04:00.0: supports D1 D2
[    0.652438] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.652481] pci 0000:04:00.0: PME# disabled
[    0.652559] PCI: Fixups for bus 0000:04
[    0.652599] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.652640] pci 0000:00:1c.4: bridge 32bit mmio: [0xe8000000-0xe8ffffff]
[    0.652683] pci 0000:00:1c.4: bridge 64bit mmio pref: 
[0xe9100000-0xe91fffff]
[    0.652724] PCI: Bus scan for 0000:04 returning with max=04
[    0.652765] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
[    0.652807] PCI: Scanning bus 0000:05
[    0.652863] pci 0000:05:07.0: found [104c:8024] class 000c00 header type 00
[    0.652918] pci 0000:05:07.0: reg 10 32bit mmio: [0xe9204000-0xe92047ff]
[    0.652963] pci 0000:05:07.0: reg 14 32bit mmio: [0xe9200000-0xe9203fff]
[    0.653026] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x19f
[    0.653078] pci 0000:05:07.0: supports D1 D2
[    0.653117] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.653158] pci 0000:05:07.0: PME# disabled
[    0.653225] PCI: Fixups for bus 0000:05
[    0.653263] pci 0000:00:1e.0: transparent bridge
[    0.653304] pci 0000:00:1e.0: bridge 32bit mmio: [0xe9200000-0xe92fffff]
[    0.653348] PCI: Bus scan for 0000:05 returning with max=05
[    0.653388] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    0.653431] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    0.653474] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 1
[    0.653517] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 1
[    0.653561] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
[    0.653604] PCI: Bus scan for 0000:00 returning with max=05
[    0.653645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.653784] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.653865] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.653949] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.654028] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.666430] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 
15)
[    0.666890] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.667404] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 
15)
[    0.667863] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 
15)
[    0.668322] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.668835] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 
15)
[    0.669294] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 
15)
[    0.669753] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 
15)
[    0.670217] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.670277] vgaarb: loaded
[    0.670386] SCSI subsystem initialized
[    0.670512] libata version 3.00 loaded.
[    0.670596] usbcore: registered new interface driver usbfs
[    0.670647] usbcore: registered new interface driver hub
[    0.670701] usbcore: registered new device driver usb
[    0.670822] ACPI: WMI: Mapper loaded
[    0.670860] PCI: Using ACPI for IRQ routing
[    0.671016] Bluetooth: Core ver 2.15
[    0.671072] NET: Registered protocol family 31
[    0.671110] Bluetooth: HCI device and connection manager initialized
[    0.671151] Bluetooth: HCI socket layer initialized
[    0.671190] NetLabel: Initializing
[    0.671227] NetLabel:  domain hash size = 128
[    0.671265] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.671311] NetLabel:  unlabeled traffic allowed by default
[    0.671364] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.671409] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.671582] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.690004] Switching to clocksource tsc
[    0.691273] pnp: PnP ACPI init
[    0.691317] ACPI: bus type pnp registered
[    0.693002] pnp: PnP ACPI: found 12 devices
[    0.693041] ACPI: ACPI bus type pnp unregistered
[    0.693084] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.693125] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.693165] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.693206] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.693246] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.693287] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    0.693330] system 00:08: ioport range 0x400-0x4bf has been reserved
[    0.693373] system 00:09: iomem range 0xe0000000-0xe3ffffff has been 
reserved
[    0.693416] system 00:0a: iomem range 0xccc00-0xcffff has been reserved
[    0.693457] system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
[    0.693498] system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
[    0.693539] system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
[    0.693580] system 00:0a: iomem range 0xcfee0000-0xcfefffff could not be 
reserved
[    0.693629] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.693669] system 00:0a: iomem range 0x100000-0xcfedffff could not be 
reserved
[    0.693718] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.693767] system 00:0a: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.693808] system 00:0a: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.693849] system 00:0a: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.693890] system 00:0a: iomem range 0xffb00000-0xffb7ffff has been 
reserved
[    0.693932] system 00:0a: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.693973] system 00:0a: iomem range 0xe0000-0xeffff has been reserved
[    0.698648] pci 0000:01:00.0: BAR 6: got res [0xe7000000-0xe701ffff] bus 
[0xe7000000-0xe701ffff] flags 0x27200
[    0.698699] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.698740] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.698780] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe7ffffff
[    0.698821] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.698870] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.698911] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.698952] pci 0000:00:1c.0:   MEM window: 0xe9400000-0xe95fffff
[    0.698993] pci 0000:00:1c.0:   PREFETCH window: 
0x000000e9600000-0x000000e97fffff
[    0.699045] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.699085] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    0.699126] pci 0000:00:1c.3:   MEM window: 0xe9000000-0xe90fffff
[    0.699168] pci 0000:00:1c.3:   PREFETCH window: 
0x000000e9800000-0x000000e99fffff
[    0.699220] pci 0000:04:00.0: BAR 6: got res [0xe9120000-0xe912ffff] bus 
[0xe9120000-0xe912ffff] flags 0x27200
[    0.699270] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.699311] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.699352] pci 0000:00:1c.4:   MEM window: 0xe8000000-0xe8ffffff
[    0.699393] pci 0000:00:1c.4:   PREFETCH window: 
0x000000e9100000-0x000000e91fffff
[    0.699444] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.699498] pci 0000:00:1e.0:   IO window: disabled
[    0.699539] pci 0000:00:1e.0:   MEM window: 0xe9200000-0xe92fffff
[    0.699581] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.699625]   alloc irq_desc for 16 on node -1
[    0.699663]   alloc kstat_irqs on node -1
[    0.699703] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.699751] pci 0000:00:01.0: setting latency timer to 64
[    0.699795] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.699836] pci 0000:00:1c.0: setting latency timer to 64
[    0.699879]   alloc irq_desc for 19 on node -1
[    0.699918]   alloc kstat_irqs on node -1
[    0.699956] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.699998] pci 0000:00:1c.3: setting latency timer to 64
[    0.700041] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.700083] pci 0000:00:1c.4: setting latency timer to 64
[    0.700125] pci 0000:00:1e.0: setting latency timer to 64
[    0.700166] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.700205] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.700246] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.700285] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe7ffffff]
[    0.700326] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.700366] pci_bus 0000:02: resource 0 io:  [0x1000-0x1fff]
[    0.701002] pci_bus 0000:02: resource 1 mem: [0xe9400000-0xe95fffff]
[    0.701042] pci_bus 0000:02: resource 2 pref mem [0xe9600000-0xe97fffff]
[    0.701083] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.701122] pci_bus 0000:03: resource 1 mem: [0xe9000000-0xe90fffff]
[    0.701163] pci_bus 0000:03: resource 2 pref mem [0xe9800000-0xe99fffff]
[    0.701203] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.701243] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe8ffffff]
[    0.701283] pci_bus 0000:04: resource 2 pref mem [0xe9100000-0xe91fffff]
[    0.701324] pci_bus 0000:05: resource 1 mem: [0xe9200000-0xe92fffff]
[    0.701364] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.701403] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.701462] NET: Registered protocol family 2
[    0.701670] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.702574] TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)
[    0.705993] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.706603] TCP: Hash tables configured (established 524288 bind 65536)
[    0.706644] TCP reno registered
[    0.706775] NET: Registered protocol family 1
[    0.706834] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x192
[    0.706876] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.706917] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.706959] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xbd
[    0.707000] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x192
[    0.707041] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.707081] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.707122] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xbd
[    0.707163] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x192
[    0.707204] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.707244] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.707297] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xbd
[    0.707338] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x192
[    0.707378] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.707419] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.707470] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xbd
[    0.707511] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x192
[    0.707552] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.707592] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.707644] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xbd
[    0.707685] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x192
[    0.707725] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
[    0.707766] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x580
[    0.707826] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xbd
[    0.707867] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x192
[    0.707908] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.707948] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.707989] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xbd
[    0.708030] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x192
[    0.708070] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.708111] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.708151] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xbd
[    0.708192] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x192
[    0.708232] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
[    0.708273] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x580
[    0.708314] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xbd
[    0.708354] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x192
[    0.708395] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x30
[    0.708435] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x580
[    0.708476] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xbd
[    0.708517] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x192
[    0.708558] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.708598] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.708649] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xbd
[    0.708690] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x192
[    0.708731] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.708771] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.708822] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xbd
[    0.708864] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x192
[    0.708904] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.708944] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.708996] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xbd
[    0.709037] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x192
[    0.709077] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
[    0.709118] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x580
[    0.709183] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xbd
[    0.709224] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x192
[    0.709265] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.709306] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.709346] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xbd
[    0.709387] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x192
[    0.709428] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.709468] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.709536] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xbd
[    0.709577] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x192
[    0.709618] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.709658] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.709699] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xbd
[    0.709750] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x192
[    0.709791] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
[    0.709831] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x580
[    0.709872] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xbd
[    0.709913] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x192
[    0.709954] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x30
[    0.709994] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x580
[    0.710035] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xbd
[    0.710075] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0xd
[    0.710122] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.710163] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.710203] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xbd
[    0.710244] pci 0000:01:00.0: Boot video device
[    0.710284] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.710324] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.710365] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xbd
[    0.710405] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.710446] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.710486] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xbd
[    0.710527] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.710567] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.710608] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xbd
[    0.710649] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.710689] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.710730] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xbd
[    0.710809] Trying to unpack rootfs image as initramfs...
[    1.812734] Freeing initrd memory: 65134k freed
[    1.843111] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.843156] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    1.843205] software IO TLB at phys 0x20000000 - 0x24000000
[    1.843519] Scanning for low memory corruption every 60 seconds
[    1.843700] audit: initializing netlink socket (disabled)
[    1.843753] type=2000 audit(1260220944.840:1): initialized
[    1.854067] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.855065] VFS: Disk quotas dquot_6.5.2
[    1.855139] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.855555] fuse init (API version 7.13)
[    1.855645] msgmni has been set to 11957
[    1.855869] alg: No test for stdrng (krng)
[    1.855914] io scheduler noop registered
[    1.855952] io scheduler anticipatory registered
[    1.855990] io scheduler deadline registered
[    1.856051] io scheduler cfq registered (default)
[    1.856173]   alloc irq_desc for 24 on node -1
[    1.856212]   alloc kstat_irqs on node -1
[    1.856256] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.856298] pcieport 0000:00:01.0: setting latency timer to 64
[    1.856405]   alloc irq_desc for 25 on node -1
[    1.856443]   alloc kstat_irqs on node -1
[    1.856485] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.856528] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.856649]   alloc irq_desc for 26 on node -1
[    1.856687]   alloc kstat_irqs on node -1
[    1.856729] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.856772] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.856893]   alloc irq_desc for 27 on node -1
[    1.856931]   alloc kstat_irqs on node -1
[    1.856973] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    1.857016] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.857114] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.857219] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.857366] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.857417] ACPI: Power Button [PWRB]
[    1.857496] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.857544] ACPI: Power Button [PWRF]
[    1.857951] ACPI: SSDT 00000000cfee7ad0 0022A (v01  PmRef  Cpu0Ist 00003000 
INTL 20040311)
[    1.858207] Marking TSC unstable due to TSC halts in idle
[    1.858274] processor LNXCPU:00: registered as cooling_device0
[    1.858490] ACPI: SSDT 00000000cfee7f90 00152 (v01  PmRef  Cpu1Ist 00003000 
INTL 20040311)
[    1.858812] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU1._PDC] (Node ffff8801a9048f40), AE_ALREADY_EXISTS
[    1.858946] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.859099] Switching to clocksource hpet
[    1.859287] processor LNXCPU:01: registered as cooling_device1
[    1.859530] ACPI: SSDT 00000000cfee80f0 00152 (v01  PmRef  Cpu2Ist 00003000 
INTL 20040311)
[    1.859851] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU2._PDC] (Node ffff8801a9048fc0), AE_ALREADY_EXISTS
[    1.859991] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.860227] processor LNXCPU:02: registered as cooling_device2
[    1.860434] ACPI: SSDT 00000000cfee8250 00152 (v01  PmRef  Cpu3Ist 00003000 
INTL 20040311)
[    1.860756] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU3._PDC] (Node ffff8801a904f040), AE_ALREADY_EXISTS
[    1.860890] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.861733] processor LNXCPU:03: registered as cooling_device3
[    1.864013] Linux agpgart interface v0.103
[    1.864057] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.864930] brd: module loaded
[    1.865271] loop: module loaded
[    1.865349] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    1.865455] ahci 0000:03:00.0: version 3.0
[    1.865504] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.883786] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 
impl SATA mode
[    1.883838] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part 
[    1.883888] ahci 0000:03:00.0: setting latency timer to 64
[    1.884054] scsi0 : ahci
[    1.884139] scsi1 : ahci
[    1.884229] ata1: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000100 
irq 19
[    1.884279] ata2: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000180 
irq 19
[    2.230026] ata1: SATA link down (SStatus 0 SControl 300)
[    2.600025] ata2: SATA link down (SStatus 0 SControl 300)
[    2.620049] ata_piix 0000:00:1f.2: version 2.13
[    2.620096] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    2.620145] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.620342] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.620427] scsi2 : ata_piix
[    2.620500] scsi3 : ata_piix
[    2.621072] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    2.621115] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    3.480056] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.480113] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.546220] ata3.00: HPA detected: current 1953523055, native 1953525168
[    3.546266] ata3.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    3.546312] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.546507] ata3.01: ATA-7: ST3300831AS, 3.02, max UDMA/133
[    3.546549] ata3.01: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.606228] ata3.00: configured for UDMA/133
[    3.620303] ata3.01: configured for UDMA/133
[    3.620432] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 
PQ: 0 ANSI: 5
[    3.620540] sd 2:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 
TB/931 GiB)
[    3.620617] sd 2:0:0:0: [sda] Write Protect is off
[    3.620656] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.620710] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.620842]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    3.709735] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.709803] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.709883] scsi 2:0:1:0: Direct-Access     ATA      ST3300831AS      3.02 
PQ: 0 ANSI: 5
[    3.709983] sd 2:0:1:0: [sdb] 586072368 512-byte logical blocks: (300 
GB/279 GiB)
[    3.710062] sd 2:0:1:0: [sdb] Write Protect is off
[    3.710101] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.710154] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.710276]  sdb: sdb1
[    3.733490] sd 2:0:1:0: [sdb] Attached SCSI disk
[    3.733553] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    4.590055] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.590112] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.630289] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    4.630332] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.630394] ata4.01: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[    4.650303] ata4.00: configured for UDMA/133
[    4.690193] ata4.01: configured for UDMA/100
[    4.690568] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    4.690686] sd 3:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 
GB/465 GiB)
[    4.690761] sd 3:0:0:0: [sdc] Write Protect is off
[    4.690801] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.690853] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.690972]  sdc: sdc2 < sdc5 sdc6 sdc7 > sdc3
[    4.771287] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.771349] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    4.772662] scsi 3:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 
PQ: 0 ANSI: 5
[    4.776309] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
[    4.776361] Uniform CD-ROM driver Revision: 3.20
[    4.776469] sr 3:0:1:0: Attached scsi CD-ROM sr0
[    4.776532] sr 3:0:1:0: Attached scsi generic sg3 type 5
[    4.776585] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    4.776628] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.776823] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.776889] scsi4 : ata_piix
[    4.776959] scsi5 : ata_piix
[    4.777364] ata5: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 
19
[    4.777407] ata6: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 
19
[    5.130659] ata5: SATA link down (SStatus 0 SControl 300)
[    5.490657] ata6: SATA link down (SStatus 0 SControl 300)
[    5.490918] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    5.490961] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[    5.491026] pata_jmicron 0000:03:00.1: enabling bus mastering
[    5.491069] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    5.491147] scsi6 : pata_jmicron
[    5.491217] scsi7 : pata_jmicron
[    5.491729] ata7: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 
16
[    5.491771] ata8: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 
16
[    5.821774] Fixed MDIO Bus: probed
[    5.821834] PPP generic driver version 2.4.2
[    5.821914] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.821965]   alloc irq_desc for 18 on node -1
[    5.822004]   alloc kstat_irqs on node -1
[    5.822044] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.822090] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.822131] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.822198] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    5.826136] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    5.826183] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
[    5.850012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.850124] usb usb1: configuration #1 chosen from 1 choice
[    5.850186] hub 1-0:1.0: USB hub found
[    5.850227] hub 1-0:1.0: 6 ports detected
[    5.850306]   alloc irq_desc for 23 on node -1
[    5.850344]   alloc kstat_irqs on node -1
[    5.850384] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.850430] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.850470] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.850533] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    5.854488] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.854536] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
[    5.870012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.870103] usb usb2: configuration #1 chosen from 1 choice
[    5.870173] hub 2-0:1.0: USB hub found
[    5.870214] hub 2-0:1.0: 6 ports detected
[    5.870290] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.870339] uhci_hcd: USB Universal Host Controller Interface driver
[    5.870410] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    5.870453] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.870493] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.870554] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    5.870620] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
[    5.870708] usb usb3: configuration #1 chosen from 1 choice
[    5.870765] hub 3-0:1.0: USB hub found
[    5.870806] hub 3-0:1.0: 2 ports detected
[    5.870871]   alloc irq_desc for 21 on node -1
[    5.870910]   alloc kstat_irqs on node -1
[    5.870949] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    5.870992] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.871033] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.871092] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    5.871163] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
[    5.871249] usb usb4: configuration #1 chosen from 1 choice
[    5.871306] hub 4-0:1.0: USB hub found
[    5.871347] hub 4-0:1.0: 2 ports detected
[    5.871413] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.871456] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.871496] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.871552] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    5.871617] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
[    5.871706] usb usb5: configuration #1 chosen from 1 choice
[    5.871760] hub 5-0:1.0: USB hub found
[    5.871800] hub 5-0:1.0: 2 ports detected
[    5.871867] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.871911] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.871951] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.872007] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    5.872072] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    5.872159] usb usb6: configuration #1 chosen from 1 choice
[    5.872214] hub 6-0:1.0: USB hub found
[    5.872256] hub 6-0:1.0: 2 ports detected
[    5.872323] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    5.872367] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.872407] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.872470] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    5.872535] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    5.872623] usb usb7: configuration #1 chosen from 1 choice
[    5.873275] hub 7-0:1.0: USB hub found
[    5.873317] hub 7-0:1.0: 2 ports detected
[    5.873385] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.873428] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.873468] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.873524] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    5.873590] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    5.873678] usb usb8: configuration #1 chosen from 1 choice
[    5.873732] hub 8-0:1.0: USB hub found
[    5.873772] hub 8-0:1.0: 2 ports detected
[    5.873869] PNP: No PS/2 controller found. Probing ports directly.
[    5.874253] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.874297] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.874418] mice: PS/2 mouse device common for all mice
[    5.874499] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    5.874565] rtc_cmos 00:04: RTC can wake from S4
[    5.874623] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    5.874681] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.874797] device-mapper: uevent: version 1.0.3
[    5.874884] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: 
dm-devel@redhat.com
[    5.875013] device-mapper: multipath: version 1.1.0 loaded
[    5.875053] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.875353] cpuidle: using governor ladder
[    5.875544] cpuidle: using governor menu
[    5.875821] TCP cubic registered
[    5.875954] NET: Registered protocol family 10
[    5.876293] lo: Disabled Privacy Extensions
[    5.876518] NET: Registered protocol family 17
[    5.876567] Bluetooth: L2CAP ver 2.14
[    5.876605] Bluetooth: L2CAP socket layer initialized
[    5.876644] Bluetooth: SCO (Voice Link) ver 0.6
[    5.876682] Bluetooth: SCO socket layer initialized
[    5.876736] Bluetooth: RFCOMM TTY layer initialized
[    5.876775] Bluetooth: RFCOMM socket layer initialized
[    5.876814] Bluetooth: RFCOMM ver 1.11
[    5.882144] PM: Resume from disk failed.
[    5.882194] registered taskstats version 1
[    5.882564]   Magic number: 5:613:398
[    5.882699] rtc_cmos 00:04: setting system clock to 2009-12-07 21:22:29 UTC 
(1260220949)
[    5.882755] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.882794] EDD information not available.
[    5.882873] Freeing unused kernel memory: 652k freed
[    5.883017] Write protecting the kernel read-only data: 10240k
[    5.883246] Freeing unused kernel memory: 808k freed
[    5.883550] Freeing unused kernel memory: 1764k freed
[    5.976979] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.977040] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.977087] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    5.977167] r8169 0000:04:00.0: setting latency timer to 64
[    5.977247]   alloc irq_desc for 28 on node -1
[    5.977291]   alloc kstat_irqs on node -1
[    5.977341] r8169 0000:04:00.0: irq 28 for MSI/MSI-X
[    5.977778] eth0: RTL8168c/8111c at 0xffffc90000c5c000, 00:1f:d0:9d:27:af, 
XID 1c4000c0 IRQ 28
[    5.980983] Floppy drive(s): fd0 is 1.44M
[    6.005636] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.006235] FDC 0 is a post-1991 82077
[    6.063833] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[e9204000-e92047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.458065] kjournald starting.  Commit interval 5 seconds
[    6.458075] EXT3-fs: mounted filesystem with writeback data mode.
[    6.810046] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    7.106807] usb 3-1: configuration #1 chosen from 1 choice
[    7.390029] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    7.390128] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007c2d6400001fd0]
[    7.562823] usb 5-1: configuration #1 chosen from 1 choice
[    7.840038] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    8.019777] usb 5-2: configuration #1 chosen from 1 choice
[    8.300039] usb 8-1: new full speed USB device using uhci_hcd and address 2
[    8.476735] usb 8-1: configuration #1 chosen from 1 choice
[    8.478696] hub 8-1:1.0: USB hub found
[    8.480677] hub 8-1:1.0: 4 ports detected
[    8.760029] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    8.938728] usb 8-2: configuration #1 chosen from 1 choice
[    9.021674] usb 8-1.4: new low speed USB device using uhci_hcd and address 
4
[    9.163725] usb 8-1.4: configuration #1 chosen from 1 choice
[   11.782064] udev: starting version 147
[   12.299406] usbcore: registered new interface driver hiddev
[   12.316947] input: Logitech USB RECEIVER as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
[   12.317025] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.2-2/input0
[   12.330897] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.0/input/input4
[   12.330934] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 
Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input0
[   12.361985] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.1/input/input5
[   12.362100] generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 
Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input1
[   12.362124] usbcore: registered new interface driver usbhid
[   12.362148] usbhid: v2.6:USB HID core driver
[   12.529906] lp: driver loaded but no devices found
[   12.602382] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.283068] nvidia: module license 'NVIDIA' taints kernel.
[   13.283071] Disabling lock debugging due to kernel taint
[   13.644907]   alloc irq_desc for 22 on node -1
[   13.644910]   alloc kstat_irqs on node -1
[   13.644918] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[   13.645025] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   13.740059] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.740065] nvidia 0000:01:00.0: setting latency timer to 64
[   13.740190] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fri 
Aug 14 17:35:21 PDT 2009
[   13.798095] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[   13.879985] usbcore: registered new interface driver snd-usb-audio
[   14.126815] Adding 6562544k swap on /dev/mapper/cryptoswap.  Priority:-1 
extents:1 across:6562544k 
[   15.530195] EXT3 FS on sda8, internal journal
[   15.906396] r8169: eth0: link up
[   15.906398] r8169: eth0: link up
[   16.308462] kjournald starting.  Commit interval 5 seconds
[   16.308468] EXT3-fs: mounted filesystem with writeback data mode.
[   16.347904] kjournald starting.  Commit interval 5 seconds
[   16.348154] EXT3 FS on sda6, internal journal
[   16.348156] EXT3-fs: mounted filesystem with writeback data mode.
[   16.522213] kjournald starting.  Commit interval 5 seconds
[   16.522219] EXT3-fs: mounted filesystem with writeback data mode.
[   16.542184] kjournald starting.  Commit interval 5 seconds
[   16.542520] EXT3 FS on sdc6, internal journal
[   16.542522] EXT3-fs: mounted filesystem with writeback data mode.
[   17.720700] RPC: Registered udp transport module.
[   17.720703] RPC: Registered tcp transport module.
[   17.720704] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   17.891520] ppdev: user-space parallel port driver
[   18.340322] svc: failed to register lockdv1 RPC service (errno 97).
[   25.734557] kjournald starting.  Commit interval 5 seconds
[   25.734568] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[   25.750204] EXT3 FS on dm-1, internal journal
[   25.750209] EXT3-fs: mounted filesystem with writeback data mode.
[   26.792535] eth0: no IPv6 routers present
[   28.008085] CPUFREQ: Per core ondemand sysfs interface is deprecated - 
up_threshold
-----------------------------------------------------------------------------


Volker
