Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZJ2Cnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZJ2Cnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbZJ2Cnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:43:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZJ2Cn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:43:28 -0400
Subject: [regression bisect -next] BUG: using smp_processor_id() in
 preemptible [00000000] code: rmmod
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Content-Type: multipart/mixed; boundary="=-gMMff2ZHdVokXhAdgdu0"
Date: Wed, 28 Oct 2009 22:42:38 -0400
Message-Id: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gMMff2ZHdVokXhAdgdu0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I get a slew of these on boot.

[    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.593043] caller is task_hot+0x86/0xd0
[    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.595443] Call Trace:
[    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b

f685ceacab07d3f6c236f04803e2f2f0dbcc5afb is first bad commit
commit f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
Author: Mike Galbraith <efault@gmx.de>
Date:   Fri Oct 23 23:09:22 2009 +0200

    sched: Strengthen buddies and mitigate buddy induced latencies
    
    This patch restores the effectiveness of LAST_BUDDY in preventing
    pgsql+oltp from collapsing due to wakeup preemption. It also
    switches LAST_BUDDY to exclusively do what it does best, namely
    mitigate the effects of aggressive wakeup preemption, which
    improves vmark throughput markedly, and restores mysql+oltp
    scalability.

[snip]


--=-gMMff2ZHdVokXhAdgdu0
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-rc3-fanotify (paris@paris.rdu.redhat.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-46)) #127 SMP PREEMPT Wed Oct 28 22:34:17 EDT 2009
[    0.000000] Command line: ro root=/dev/mapper/VolGroup-lv_root console=ttyS1,115200 console=tty0 audit=1 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 debug
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000800f0000 (usable)
[    0.000000]  BIOS-e820: 00000000800f0000 - 0000000080100000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000c1000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x800f0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00C0000000 mask FFFFFFFFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000800f0000 (usable)
[    0.000000]  modified: 00000000800f0000 - 0000000080100000 (ACPI data)
[    0.000000]  modified: 00000000c0000000 - 00000000c1000000 (reserved)
[    0.000000]  modified: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000800f0000
[    0.000000]  0000000000 - 00800f0000 page 4k
[    0.000000] kernel direct mapping tables up to 800f0000 @ 100000-505000
[    0.000000] RAMDISK: 3627b000 - 37fef194
[    0.000000] ACPI: RSDP 00000000000fbf70 00014 (v00 QEMU  )
[    0.000000] ACPI: RSDT 00000000800f0000 0002C (v01 QEMU   QEMURSDT 00000001 QEMU 00000001)
[    0.000000] ACPI: FACP 00000000800f002c 00074 (v01 QEMU   QEMUFACP 00000001 QEMU 00000001)
[    0.000000] ACPI: DSDT 00000000800f0100 02540 (v01   BXPC   BXDSDT 00000001 INTL 20061109)
[    0.000000] ACPI: FACS 00000000800f00c0 00040
[    0.000000] ACPI: APIC 00000000800f2640 000E0 (v01 QEMU   QEMUAPIC 00000001 QEMU 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000800f0000
[    0.000000] Bootmem setup node 0 0000000000000000-00000000800f0000
[    0.000000]   NODE_DATA [0000000000008000 - 000000000001ffff]
[    0.000000]   bootmap [0000000000020000 -  000000000003001f] pages 11
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 00800f0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000268fed8]    TEXT DATA BSS ==> [0001000000 - 000268fed8]
[    0.000000]   #3 [003627b000 - 0037fef194]          RAMDISK ==> [003627b000 - 0037fef194]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #5 [0002690000 - 0002690069]              BRK ==> [0002690000 - 0002690069]
[    0.000000]   #6 [0000100000 - 0000503000]          PGTABLE ==> [0000100000 - 0000503000]
[    0.000000] found SMP MP-table at [ffff8800000fbd60] fbd60
[    0.000000] kvm-clock: cpu 0, msr 0:1a1dd81, boot clock
[    0.000000]  [ffffea0000000000-ffffea00037fffff] PMD -> [ffff880002c00000-ffff8800063fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000800f0
[    0.000000] On node 0 totalpages: 524426
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 1126 pages reserved
[    0.000000]   DMA zone: 2764 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13215 pages used for memmap
[    0.000000]   DMA32 zone: 507217 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 16 CPUs, 10 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 80100000 (gap: 80100000:3ff00000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 479 pages/cpu @ffff880006400000 s1931352 r8192 d22440 u2097152
[    0.000000] pcpu-alloc: s1931352 r8192 d22440 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07 
[    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15 
[    0.000000] kvm-clock: cpu 0, msr 0:65d6d81, primary cpu clock
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 509981
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/mapper/VolGroup-lv_root console=ttyS1,115200 console=tty0 audit=1 SYSFONT=latarcyrheb-sun16 LANG=en_US.UTF-8 debug
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 1951968k/2098112k available (5559k kernel code, 408k absent, 145736k reserved, 2909k data, 3260k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:536
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS1] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: 24 of 24 active objects replaced
[    0.000000] Detected 2933.526 MHz processor.
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.003255] Security Framework initialized
[    0.004021] SELinux:  Initializing.
[    0.004837] SELinux:  Starting in permissive mode
[    0.008133] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.011748] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.013618] Mount-cache hash table entries: 256
[    0.016420] Initializing cgroup subsys ns
[    0.017013] Initializing cgroup subsys cpuacct
[    0.018014] Initializing cgroup subsys devices
[    0.018824] Initializing cgroup subsys freezer
[    0.019214] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.020461] CPU: L2 cache: 2048K
[    0.021010] CPU 0/0x0 -> Node 0
[    0.022009] mce: CPU supports 0 MCE banks
[    0.022787] numa_add_cpu cpu 0 node 0: mask now 0
[    0.023003] Performance Events: p6 PMU driver.
[    0.024443] ... version:                0
[    0.025002] ... bit width:              32
[    0.026002] ... generic registers:      2
[    0.026745] ... value mask:             00000000ffffffff
[    0.027002] ... max period:             000000007fffffff
[    0.028002] ... fixed-purpose events:   0
[    0.029002] ... event mask:             0000000000000003
[    0.033872] ACPI: Core revision 20090903
[    0.041424] Setting APIC routing to flat
[    0.043542] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.044000] CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.046992] APIC calibration not consistent with PM-Timer: 101ms instead of 100ms
[    0.046992] APIC delta adjusted to PM-Timer: 6249942 (6315313)
[    0.052138] lockdep: fixing up alternatives.
[    0.054209] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 2048K
[    0.001999] CPU 1/0x1 -> Node 0
[    0.001999] mce: CPU supports 0 MCE banks
[    0.001999] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.068523] CPU1: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.076002] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.001999] kvm-clock: cpu 1, msr 0:67d6d81, secondary cpu clock
[    0.100104] lockdep: fixing up alternatives.
[    0.101074] Booting processor 2 APIC 0x2 ip 0x6000
[    0.001999] Initializing CPU#2
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 2048K
[    0.001999] CPU 2/0x2 -> Node 0
[    0.001999] mce: CPU supports 0 MCE banks
[    0.001999] numa_add_cpu cpu 2 node 0: mask now 0-2
[    0.113447] CPU2: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.120995] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.001999] kvm-clock: cpu 2, msr 0:69d6d81, secondary cpu clock
[    0.145088] lockdep: fixing up alternatives.
[    0.146053] Booting processor 3 APIC 0x3 ip 0x6000
[    0.001999] Initializing CPU#3
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 2048K
[    0.001999] CPU 3/0x3 -> Node 0
[    0.001999] mce: CPU supports 0 MCE banks
[    0.001999] numa_add_cpu cpu 3 node 0: mask now 0-3
[    0.158348] CPU3: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.167986] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.001999] kvm-clock: cpu 3, msr 0:6bd6d81, secondary cpu clock
[    0.192090] lockdep: fixing up alternatives.
[    0.193027] Booting processor 4 APIC 0x4 ip 0x6000
[    0.001999] Initializing CPU#4
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 2048K
[    0.001999] CPU 4/0x4 -> Node 0
[    0.001999] mce: CPU supports 0 MCE banks
[    0.001999] numa_add_cpu cpu 4 node 0: mask now 0-4
[    0.205330] CPU4: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.212980] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.001999] kvm-clock: cpu 4, msr 0:6dd6d81, secondary cpu clock
[    0.238081] lockdep: fixing up alternatives.
[    0.239046] Booting processor 5 APIC 0x5 ip 0x6000
[    0.001999] Initializing CPU#5
[    0.001999] Calibrating delay loop (skipped) preset value.. 5867.05 BogoMIPS (lpj=2933526)
[    0.001999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001999] CPU: L2 cache: 2048K
[    0.001999] CPU 5/0x5 -> Node 0
[    0.001999] mce: CPU supports 0 MCE banks
[    0.001999] numa_add_cpu cpu 5 node 0: mask now 0-5
[    0.252267] CPU5: Intel QEMU Virtual CPU version 0.9.1 stepping 03
[    0.260392] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.001999] kvm-clock: cpu 5, msr 0:6fd6d81, secondary cpu clock
[    0.281984] Brought up 6 CPUs
[    0.281988] Total of 6 processors activated (35202.31 BogoMIPS).
[    0.286037] CPU0 attaching sched-domain:
[    0.286844]  domain 0: span 0-5 level CPU
[    0.287452]   groups: 0 1 2 3 4 5
[    0.288780]   domain 1: span 0-5 level NODE
[    0.289462]    groups: 0-5 (cpu_power = 6144)
[    0.290668] CPU1 attaching sched-domain:
[    0.290961]  domain 0: span 0-5 level CPU
[    0.292451]   groups: 1 2 3 4 5 0
[    0.293780]   domain 1: span 0-5 level NODE
[    0.294462]    groups: 0-5 (cpu_power = 6144)
[    0.295646] CPU2 attaching sched-domain:
[    0.295960]  domain 0: span 0-5 level CPU
[    0.297468]   groups: 2 3 4 5 0 1
[    0.298691]   domain 1: span 0-5 level NODE
[    0.299463]    groups: 0-5 (cpu_power = 6144)
[    0.300651] CPU3 attaching sched-domain:
[    0.300960]  domain 0: span 0-5 level CPU
[    0.302463]   groups: 3 4 5 0 1 2
[    0.303698]   domain 1: span 0-5 level NODE
[    0.306465]    groups: 0-5 (cpu_power = 6144)
[    0.307962] CPU4 attaching sched-domain:
[    0.308763]  domain 0: span 0-5 level CPU
[    0.309450]   groups: 4 5 0 1 2 3
[    0.310773]   domain 1: span 0-5 level NODE
[    0.311458]    groups: 0-5 (cpu_power = 6144)
[    0.312962] CPU5 attaching sched-domain:
[    0.313762]  domain 0: span 0-5 level CPU
[    0.314446]   groups: 5 0 1 2 3 4
[    0.315778]   domain 1: span 0-5 level NODE
[    0.316457]    groups: 0-5 (cpu_power = 6144)
[    0.323343] khelper used greatest stack depth: 4736 bytes left
[    0.327310] Time:  3:36:35  Date: 10/29/09
[    0.329517] NET: Registered protocol family 16
[    0.334217] ACPI: bus type pci registered
[    0.338186] PCI: Using configuration type 1 for base access
[    0.429306] bio: create slab <bio-0> at 0
[    0.438091] ACPI: EC: Look up EC in DSDT
[    0.472989] ACPI: Interpreter enabled
[    0.474006] ACPI: (supports S0 S3 S5)
[    0.476013] ACPI: Using IOAPIC for interrupt routing
[    0.541888] ACPI: No dock devices found.
[    0.543114] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.548352] pci 0000:00:01.1: reg 20 io port: [0xc000-0xc00f]
[    0.551086] pci 0000:00:01.2: reg 20 io port: [0xc020-0xc03f]
[    0.553261] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
[    0.556019] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
[    0.572064] pci 0000:00:02.0: reg 10 32bit mmio pref: [0xc2000000-0xc3ffffff]
[    0.576082] pci 0000:00:02.0: reg 14 32bit mmio: [0xc4000000-0xc4000fff]
[    0.596322] pci 0000:00:03.0: reg 10 io port: [0xc040-0xc05f]
[    0.598292] pci 0000:00:04.0: reg 10 io port: [0xc080-0xc0bf]
[    0.599362] pci 0000:00:05.0: reg 10 io port: [0xc0c0-0xc0df]
[    0.601421] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.637481] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.639572] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.641292] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.642868] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.647229] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.649019] vgaarb: loaded
[    0.653107] SCSI subsystem initialized
[    0.657104] libata version 3.00 loaded.
[    0.660252] usbcore: registered new interface driver usbfs
[    0.662249] usbcore: registered new interface driver hub
[    0.664214] usbcore: registered new device driver usb
[    0.668175] PCI: Using ACPI for IRQ routing
[    0.673236] NetLabel: Initializing
[    0.674008] NetLabel:  domain hash size = 128
[    0.675007] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.677215] NetLabel:  unlabeled traffic allowed by default
[    0.679596] Switching to clocksource kvm-clock
[    0.710567] pnp: PnP ACPI init
[    0.712232] ACPI: bus type pnp registered
[    0.720982] pnp: PnP ACPI: found 7 devices
[    0.721841] ACPI: ACPI bus type pnp unregistered
[    0.735763] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.737837] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.740798] NET: Registered protocol family 2
[    0.749095] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.764125] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.777029] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    0.784955] TCP: Hash tables configured (established 262144 bind 65536)
[    0.786301] TCP reno registered
[    0.787239] NET: Registered protocol family 1
[    0.789412] Trying to unpack rootfs image as initramfs...
[    1.549167] debug: unmapping init memory ffff88003627b000..ffff880037ff0000
[    1.572124] Scanning for low memory corruption every 60 seconds
[    1.578724] audit: initializing netlink socket (enabled)
[    1.580926] type=2000 audit(1256783796.580:1): initialized
[    1.593123] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.694690] VFS: Disk quotas dquot_6.5.2
[    1.697477] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.708820] msgmni has been set to 3812
[    1.716288] SELinux:  Registering netfilter hooks
[    1.728255] alg: No test for stdrng (krng)
[    1.751382] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.754444] io scheduler noop registered
[    1.756127] io scheduler anticipatory registered
[    1.757942] io scheduler deadline registered
[    1.761577] io scheduler cfq registered (default)
[    1.764030] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.766288] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.768553] pci 0000:00:02.0: Boot video device
[    1.779065] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.780618] ACPI: Power Button [PWRF]
[    1.786617] processor LNXCPU:00: registered as cooling_device0
[    1.788792] processor LNXCPU:01: registered as cooling_device1
[    1.791350] processor LNXCPU:02: registered as cooling_device2
[    1.794592] processor LNXCPU:03: registered as cooling_device3
[    1.798384] processor LNXCPU:04: registered as cooling_device4
[    1.802299] processor LNXCPU:05: registered as cooling_device5
[    1.883129] Non-volatile memory driver v1.3
[    1.885513] Linux agpgart interface v0.103
[    1.899402] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.150503] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.403472] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.415367] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.420092] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.438012] FDC 0 is a S82078B
[    2.470442] brd: module loaded
[    2.485798] loop: module loaded
[    2.496069] input: Macintosh mouse button emulation as /devices/virtual/input/input1
[    2.503121] SCSI Media Changer driver v0.25 
[    2.509943] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.513152] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.516250] uhci_hcd: USB Universal Host Controller Interface driver
[    2.520461] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.522636] uhci_hcd 0000:00:01.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
[    2.530876] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    2.534974] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    2.538211] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c020
[    2.541063] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.543582] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.546583] usb usb1: Product: UHCI Host Controller
[    2.548509] usb usb1: Manufacturer: Linux 2.6.32-rc3-fanotify uhci_hcd
[    2.550842] usb usb1: SerialNumber: 0000:00:01.2
[    2.554386] usb usb1: configuration #1 chosen from 1 choice
[    2.556453] hub 1-0:1.0: USB hub found
[    2.557287] hub 1-0:1.0: 2 ports detected
[    2.560787] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.566623] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.568843] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.573681] mice: PS/2 mouse device common for all mice
[    2.578600] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    2.580818] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    2.586917] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    2.589822] rtc0: alarms up to one day, 114 bytes nvram
[    2.595608] device-mapper: uevent: version 1.0.3
[    2.598849] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    2.609643] cpuidle: using governor ladder
[    2.610563] cpuidle: using governor menu
[    2.613538] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    2.615839] virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, high) -> IRQ 10
[    2.628170] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
[    2.632932]  vda: vda1 vda2
[    2.640828] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.642089] virtio-pci 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, high) -> IRQ 10
[    2.646536] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.651342] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    2.652877] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[    2.654568] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    2.658105] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.659385] TCP cubic registered
[    2.660138] Initializing XFRM netlink socket
[    2.661239] NET: Registered protocol family 17
[    2.664258] registered taskstats version 1
[    2.665886] No TPM chip found, activating TPM-bypass!
[    2.668112]   Magic number: 13:101:615
[    2.669596] rtc_cmos 00:01: setting system clock to 2009-10-29 03:36:38 UTC (1256787398)
[    2.671460] debug: unmapping init memory ffffffff81847000..ffffffff81b76000
[    2.674075] Write protecting the kernel read-only data: 7592k
[    2.726628] modprobe used greatest stack depth: 4672 bytes left
[    2.795780] dracut: dracut-002-13.4.git8f397a9b.fc12
[    2.817130] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    2.862155] usb 1-2: new full speed USB device using uhci_hcd and address 2
[    2.866274] udev: starting version 145
[    2.931788] udevadm used greatest stack depth: 4632 bytes left
[    3.048722] dracut: Starting plymouth daemon
[    3.233954] ata_piix 0000:00:01.1: version 2.13
[    3.236255] scsi0 : ata_piix
[    3.244941] scsi1 : ata_piix
[    3.247009] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
[    3.248422] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
[    3.265553] blkid used greatest stack depth: 4264 bytes left
[    3.300023] usb 1-2: New USB device found, idVendor=0627, idProduct=0001
[    3.301571] usb 1-2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.304018] usb 1-2: Product: QEMU USB Tablet
[    3.304974] usb 1-2: Manufacturer: QEMU 0.9.1
[    3.306001] usb 1-2: SerialNumber: 1
[    3.310873] usb 1-2: configuration #1 chosen from 1 choice
[    3.406574] ------------[ cut here ]------------
[    3.406608] WARNING: at drivers/ata/libata-core.c:5039 ata_qc_complete+0x195/0x210()
[    3.406616] Hardware name: 
[    3.406618] Modules linked in: ata_piix
[    3.406624] Pid: 284, comm: ata/0 Not tainted 2.6.32-rc3-fanotify #127
[    3.406630] Call Trace:
[    3.406637]  [<ffffffff813bde55>] ? ata_qc_complete+0x195/0x210
[    3.406650]  [<ffffffff81071f91>] warn_slowpath_common+0x91/0xd0
[    3.406652]  [<ffffffff81071ff2>] warn_slowpath_null+0x22/0x40
[    3.406654]  [<ffffffff813bde55>] ata_qc_complete+0x195/0x210
[    3.406662]  [<ffffffff813ca816>] ata_do_link_abort+0xa6/0x100
[    3.406665]  [<ffffffff813ce6df>] ? ata_sff_freeze+0x5f/0x80
[    3.406667]  [<ffffffff813ca88e>] ata_port_abort+0x1e/0x40
[    3.406670]  [<ffffffff813ca8e9>] ata_port_freeze+0x39/0x70
[    3.406672]  [<ffffffff813cf6bd>] ata_hsm_qc_complete+0x16d/0x180
[    3.406674]  [<ffffffff813d0989>] ata_sff_hsm_move+0x1d9/0x720
[    3.406676]  [<ffffffff813d1250>] ? ata_pio_task+0x0/0x130
[    3.406689]  [<ffffffff812a714d>] ? __delay+0x1d/0x40
[    3.406691]  [<ffffffff813d1250>] ? ata_pio_task+0x0/0x130
[    3.406693]  [<ffffffff813d1293>] ata_pio_task+0x43/0x130
[    3.406713]  [<ffffffff81092eee>] worker_thread+0x25e/0x3d0
[    3.406715]  [<ffffffff81092e99>] ? worker_thread+0x209/0x3d0
[    3.406719]  [<ffffffff81098d40>] ? autoremove_wake_function+0x0/0x60
[    3.406721]  [<ffffffff81092c90>] ? worker_thread+0x0/0x3d0
[    3.406723]  [<ffffffff8109872c>] kthread+0xac/0xc0
[    3.406737]  [<ffffffff81a1f140>] ? early_idt_handler+0x0/0x71
[    3.406746]  [<ffffffff8101439a>] child_rip+0xa/0x20
[    3.406751]  [<ffffffff81013cd4>] ? restore_args+0x0/0x30
[    3.406754]  [<ffffffff81098680>] ? kthread+0x0/0xc0
[    3.406755]  [<ffffffff81014390>] ? child_rip+0x0/0x20
[    3.406759] ---[ end trace eafb6926f92af9f5 ]---
[    3.407020] ata2.01: NODEV after polling detection
[    3.407936] ata2.00: ATAPI: QEMU DVD-ROM, 0.9.1, max UDMA/100
[    3.408745] ata2.00: configured for MWDMA2
[    3.416486] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.9. PQ: 0 ANSI: 5
[    3.465214] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
[    3.467374] Uniform CD-ROM driver Revision: 3.20
[    3.472133] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.479338] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    3.486381] modprobe used greatest stack depth: 4072 bytes left
[    3.527927] cdrom_id used greatest stack depth: 3016 bytes left
[    3.643410] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.646802] caller is task_hot+0x86/0xd0
[    3.648504] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.654406] Call Trace:
[    3.655141]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.656352]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.657340]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.658482]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.659461]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.660874]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.662116]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.663079]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.664311]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.665299]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.667177] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.668767] caller is task_hot+0x86/0xd0
[    3.669591] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.671138] Call Trace:
[    3.671723]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.672937]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.673918]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.675056]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.676044]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.677226]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.678214]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.679454]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.680442]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.681677]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.683329] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.685079] caller is task_hot+0x86/0xd0
[    3.685881] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.687429] Call Trace:
[    3.690283]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.691271]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.692411]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.693400]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.694475]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.695463]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.698761]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.699969]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.701060]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.702049]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.703711] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.705468] caller is task_hot+0x86/0xd0
[    3.706327] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.707899] Call Trace:
[    3.708515]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.709672]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.710643]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.711687]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.712674]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.713891]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.715131]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.716119]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.717362]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.718349]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.720153] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.721750] caller is task_hot+0x86/0xd0
[    3.722572] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.726492] Call Trace:
[    3.727137]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.728292]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.729280]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.730345]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.731329]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.733328]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.735730]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.738028]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.740271]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.742581]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.745323] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1277
[    3.748572] caller is task_hot+0x86/0xd0
[    3.750323] Pid: 1277, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    3.752743] Call Trace:
[    3.753363]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    3.754510]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    3.755496]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    3.756530]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    3.757518]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    3.758687]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    3.762025]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    3.763255]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    3.764244]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    3.765513]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    3.789475] dracut: Scanning devices vda2  for LVM volume groups 
[    3.846290] dracut: Reading all physical volumes. This may take a while...
[    3.847859] dracut: Found volume group "VolGroup" using metadata type lvm2
[    4.033923] dracut: 2 logical volume(s) in volume group "VolGroup" now active
[    4.590699] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.593043] caller is task_hot+0x86/0xd0
[    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.595443] Call Trace:
[    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    4.608082] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.609664] caller is task_hot+0x86/0xd0
[    4.610491] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.612064] Call Trace:
[    4.612652]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.613831]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.614778]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.615854]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.616915]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.618128]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.619115]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.620399]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.624351]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.625332]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    4.627006] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1314
[    4.628597] caller is task_hot+0x86/0xd0
[    4.629427] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    4.630965] Call Trace:
[    4.631553]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    4.632722]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    4.633703]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    4.634774]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    4.635831]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    4.637030]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    4.638012]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    4.639295]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    4.640283]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    4.641558]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    4.809070] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[    4.820763] dracut: Mounted root filesystem /dev/mapper/VolGroup-lv_root
[    4.873647] dracut: Loading SELinux policy
[    5.054525] SELinux: 8192 avtab hash slots, 141870 rules.
[    5.161459] SELinux: 8192 avtab hash slots, 141870 rules.
[    5.485224] SELinux:  8 users, 12 roles, 2908 types, 130 bools, 1 sens, 1024 cats
[    5.487034] SELinux:  75 classes, 141870 rules
[    5.499700] SELinux:  Completing initialization.
[    5.500662] SELinux:  Setting up existing superblocks.
[    5.502028] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    5.504130] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.505663] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.521580] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    5.523338] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    5.525158] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    5.526816] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    5.528502] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    5.530237] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[    5.532090] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    5.533846] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    5.535291] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    5.539494] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    5.540734] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.542320] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    5.543810] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    5.545242] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    5.549851] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    5.815154] dracut: Switching root
[    7.242104] udev: starting version 145
[    7.379336] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    7.397338] __ratelimit: 22 callbacks suppressed
[    7.397344] type=1400 audit(1256787403.227:5): avc:  denied  { mmap_zero } for  pid=1487 comm="vbetool" scontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tcontext=system_u:system_r:vbetool_t:s0-s0:c0.c1023 tclass=memprotect
[    7.397436] type=1300 audit(1256787403.227:5): arch=c000003e syscall=9 success=no exit=-13 a0=1000 a1=a0000 a2=7 a3=11 items=0 ppid=1473 pid=1487 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="vbetool" exe="/usr/sbin/vbetool" subj=system_u:system_r:vbetool_t:s0-s0:c0.c1023 key=(null)
[    7.437358] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    7.769571] input: QEMU 0.9.1 QEMU USB Tablet as /devices/pci0000:00/0000:00:01.2/usb1/1-2/1-2:1.0/input/input5
[    7.770940] generic-usb 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU 0.9.1 QEMU USB Tablet] on usb-0000:00:01.2-2/input0
[    7.771946] usbcore: registered new interface driver usbhid
[    7.771953] usbhid: v2.6:USB HID core driver
[    7.898916] ip used greatest stack depth: 2952 bytes left
[    8.452195] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1675
[    8.452237] caller is task_hot+0x86/0xd0
[    8.452242] Pid: 1675, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.452250] Call Trace:
[    8.452274]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.452280]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.452291]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.452309]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.452322]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.452329]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.452340]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    8.452348]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    8.452354]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    8.452372]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.453395] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1675
[    8.453402] caller is task_hot+0x86/0xd0
[    8.453406] Pid: 1675, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.453409] Call Trace:
[    8.453415]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.453420]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.453425]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.453430]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.453436]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.453441]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.453447]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    8.453451]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    8.453456]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    8.453462]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.453876] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1675
[    8.453882] caller is task_hot+0x86/0xd0
[    8.453885] Pid: 1675, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.453888] Call Trace:
[    8.453893]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.453898]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.453904]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.453909]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.453914]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.453919]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.453925]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    8.453930]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    8.453935]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    8.453941]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.454361] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1675
[    8.454366] caller is task_hot+0x86/0xd0
[    8.454369] Pid: 1675, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.454372] Call Trace:
[    8.454377]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.454382]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.454388]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.454393]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.454398]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.454403]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.454408]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    8.454427]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    8.454432]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    8.454438]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.454911] BUG: using smp_processor_id() in preemptible [00000000] code: rmmod/1675
[    8.454916] caller is task_hot+0x86/0xd0
[    8.454920] Pid: 1675, comm: rmmod Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.454923] Call Trace:
[    8.454928]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.454933]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.454938]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.454943]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.454948]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.454954]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.454959]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
[    8.454964]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
[    8.454969]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
[    8.454975]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.598412] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/1683
[    8.598427] caller is task_hot+0x86/0xd0
[    8.598432] Pid: 1683, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.598436] Call Trace:
[    8.598445]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.598450]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.598457]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.598463]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.598473]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.598480]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.598489]  [<ffffffff8109e3c5>] ? up_read+0x35/0x60
[    8.598507]  [<ffffffffa010a000>] ? dm_multipath_init+0x0/0x15e [dm_multipath]
[    8.598514]  [<ffffffffa010a07a>] dm_multipath_init+0x7a/0x15e [dm_multipath]
[    8.598524]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[    8.598530]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[    8.598538]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.599354] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/1683
[    8.599360] caller is task_hot+0x86/0xd0
[    8.599364] Pid: 1683, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.599367] Call Trace:
[    8.599373]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.599378]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.599383]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.599388]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.599393]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.599398]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.599404]  [<ffffffff8109e3c5>] ? up_read+0x35/0x60
[    8.599410]  [<ffffffffa010a000>] ? dm_multipath_init+0x0/0x15e [dm_multipath]
[    8.599416]  [<ffffffffa010a07a>] dm_multipath_init+0x7a/0x15e [dm_multipath]
[    8.599422]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[    8.599427]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[    8.599433]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.599821] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/1683
[    8.599827] caller is task_hot+0x86/0xd0
[    8.599831] Pid: 1683, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[    8.599834] Call Trace:
[    8.599839]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[    8.599844]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[    8.599850]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[    8.599855]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[    8.599860]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[    8.599865]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[    8.599877]  [<ffffffff8109e3c5>] ? up_read+0x35/0x60
[    8.599883]  [<ffffffffa010a000>] ? dm_multipath_init+0x0/0x15e [dm_multipath]
[    8.599889]  [<ffffffffa010a07a>] dm_multipath_init+0x7a/0x15e [dm_multipath]
[    8.599895]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[    8.599900]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[    8.599905]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[    8.601030] device-mapper: multipath: version 1.1.0 loaded
[    9.289336] kjournald starting.  Commit interval 5 seconds
[    9.308365] EXT3 FS on vda1, internal journal
[    9.308776] EXT3-fs: mounted filesystem with writeback data mode.
[    9.309895] SELinux: initialized (dev vda1, type ext3), uses xattr
[    9.359285] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.012073] Adding 950264k swap on /dev/mapper/VolGroup-lv_swap.  Priority:-1 extents:1 across:950264k 
[   10.025249] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   11.345650] NET: Registered protocol family 10
[   11.351124] lo: Disabled Privacy Extensions
[   11.397430] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.212554] end_request: I/O error, dev vda, sector 0
[   14.213408] end_request: I/O error, dev vda, sector 0
[   14.933139] __ratelimit: 11 callbacks suppressed
[   14.933143] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/2204
[   14.933156] caller is task_hot+0x86/0xd0
[   14.933160] Pid: 2204, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[   14.933163] Call Trace:
[   14.933171]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[   14.933174]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[   14.933179]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[   14.933184]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[   14.933191]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[   14.933195]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[   14.933222]  [<ffffffffa01d70f0>] ? init_sunrpc+0x0/0x8c [sunrpc]
[   14.933234]  [<ffffffffa01a6153>] rpc_init_mempool+0x53/0x150 [sunrpc]
[   14.933241]  [<ffffffffa01d7135>] init_sunrpc+0x45/0x8c [sunrpc]
[   14.933248]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[   14.933251]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[   14.933257]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[   14.933693] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/2204
[   14.933698] caller is task_hot+0x86/0xd0
[   14.933702] Pid: 2204, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[   14.933705] Call Trace:
[   14.933710]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[   14.933715]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[   14.933720]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[   14.933725]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[   14.933730]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[   14.933736]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[   14.933752]  [<ffffffffa01d70f0>] ? init_sunrpc+0x0/0x8c [sunrpc]
[   14.933770]  [<ffffffffa01a6153>] rpc_init_mempool+0x53/0x150 [sunrpc]
[   14.933785]  [<ffffffffa01d7135>] init_sunrpc+0x45/0x8c [sunrpc]
[   14.933792]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[   14.933795]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[   14.933797]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[   14.934344] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/2204
[   14.934347] caller is task_hot+0x86/0xd0
[   14.934348] Pid: 2204, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[   14.934350] Call Trace:
[   14.934353]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[   14.934355]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[   14.934358]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[   14.934360]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[   14.934369]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[   14.934372]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[   14.934381]  [<ffffffffa01d70f0>] ? init_sunrpc+0x0/0x8c [sunrpc]
[   14.934390]  [<ffffffffa01a6153>] rpc_init_mempool+0x53/0x150 [sunrpc]
[   14.934398]  [<ffffffffa01d7135>] init_sunrpc+0x45/0x8c [sunrpc]
[   14.934401]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[   14.934404]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[   14.934406]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[   14.936757] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/2204
[   14.936761] caller is task_hot+0x86/0xd0
[   14.936763] Pid: 2204, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[   14.936765] Call Trace:
[   14.936768]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[   14.936770]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[   14.936773]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[   14.936776]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[   14.936778]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[   14.936781]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[   14.936790]  [<ffffffffa01d70f0>] ? init_sunrpc+0x0/0x8c [sunrpc]
[   14.936798]  [<ffffffffa01a6153>] rpc_init_mempool+0x53/0x150 [sunrpc]
[   14.936806]  [<ffffffffa01d7135>] init_sunrpc+0x45/0x8c [sunrpc]
[   14.936809]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[   14.936811]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[   14.936814]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[   14.937180] BUG: using smp_processor_id() in preemptible [00000000] code: modprobe/2204
[   14.937184] caller is task_hot+0x86/0xd0
[   14.937187] Pid: 2204, comm: modprobe Tainted: G        W  2.6.32-rc3-fanotify #127
[   14.937190] Call Trace:
[   14.937193]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
[   14.937196]  [<ffffffff81051d66>] task_hot+0x86/0xd0
[   14.937199]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
[   14.937203]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
[   14.937207]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
[   14.937210]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
[   14.937219]  [<ffffffffa01d70f0>] ? init_sunrpc+0x0/0x8c [sunrpc]
[   14.937229]  [<ffffffffa01a6153>] rpc_init_mempool+0x53/0x150 [sunrpc]
[   14.937237]  [<ffffffffa01d7135>] init_sunrpc+0x45/0x8c [sunrpc]
[   14.937241]  [<ffffffff8100a070>] do_one_initcall+0x40/0x1b0
[   14.937244]  [<ffffffff810c7a3a>] sys_init_module+0x10a/0x290
[   14.937248]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
[   14.940007] RPC: Registered udp transport module.
[   14.940011] RPC: Registered tcp transport module.
[   14.940012] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   14.962978] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   15.760071] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   15.779086] SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
[   17.559114] end_request: I/O error, dev vda, sector 0
[   17.560025] end_request: I/O error, dev vda, sector 0
[   17.561058] end_request: I/O error, dev vda, sector 0
[   17.562724] end_request: I/O error, dev vda, sector 0
[   17.563826] end_request: I/O error, dev vda, sector 0
[   17.722823] end_request: I/O error, dev vda, sector 0
[   17.723636] end_request: I/O error, dev vda, sector 0
[   17.724075] end_request: I/O error, dev vda, sector 0
[   17.725555] end_request: I/O error, dev vda, sector 0
[   17.727495] end_request: I/O error, dev vda, sector 0
[   19.974312] Slow work thread pool: Starting up
[   19.975533] Slow work thread pool: Ready
[   19.975948] FS-Cache: Loaded
[   20.124749] FS-Cache: Netfs 'nfs' registered for caching
[   20.188008] SELinux: initialized (dev 0:15, type nfs), uses genfs_contexts
[   20.192510] mount.nfs used greatest stack depth: 1720 bytes left
[   23.710503] end_request: I/O error, dev vda, sector 0
[   23.711613] end_request: I/O error, dev vda, sector 0
[   24.756464] eth0: no IPv6 routers present
[   29.717426] end_request: I/O error, dev vda, sector 0
[   29.718412] end_request: I/O error, dev vda, sector 0
[   35.706878] end_request: I/O error, dev vda, sector 0
[   35.707675] end_request: I/O error, dev vda, sector 0
[   41.716251] end_request: I/O error, dev vda, sector 0
[   41.716862] end_request: I/O error, dev vda, sector 0
[   47.724078] end_request: I/O error, dev vda, sector 0
[   47.725064] end_request: I/O error, dev vda, sector 0
[   53.721420] end_request: I/O error, dev vda, sector 0
[   53.722172] end_request: I/O error, dev vda, sector 0
[   59.713583] end_request: I/O error, dev vda, sector 0
[   59.714841] end_request: I/O error, dev vda, sector 0
[   65.718490] end_request: I/O error, dev vda, sector 0
[   65.719286] end_request: I/O error, dev vda, sector 0
[   71.717424] end_request: I/O error, dev vda, sector 0
[   71.718183] end_request: I/O error, dev vda, sector 0
[   77.716412] end_request: I/O error, dev vda, sector 0
[   77.717268] end_request: I/O error, dev vda, sector 0
[   83.715375] end_request: I/O error, dev vda, sector 0
[   83.716227] end_request: I/O error, dev vda, sector 0
[   89.717325] end_request: I/O error, dev vda, sector 0
[   89.718139] end_request: I/O error, dev vda, sector 0
[   95.721366] end_request: I/O error, dev vda, sector 0
[   95.721974] end_request: I/O error, dev vda, sector 0
[  101.720390] end_request: I/O error, dev vda, sector 0
[  101.721315] end_request: I/O error, dev vda, sector 0
[  107.719080] end_request: I/O error, dev vda, sector 0
[  107.720282] end_request: I/O error, dev vda, sector 0
[  113.718541] end_request: I/O error, dev vda, sector 0
[  113.719352] end_request: I/O error, dev vda, sector 0
[  119.716913] end_request: I/O error, dev vda, sector 0
[  119.717973] end_request: I/O error, dev vda, sector 0
[  125.715933] end_request: I/O error, dev vda, sector 0
[  125.716775] end_request: I/O error, dev vda, sector 0
[  131.716010] end_request: I/O error, dev vda, sector 0
[  131.716899] end_request: I/O error, dev vda, sector 0
[  136.455746] end_request: I/O error, dev vda, sector 0
[  136.456328] end_request: I/O error, dev vda, sector 0
[  136.456659] end_request: I/O error, dev vda, sector 0
[  136.457697] end_request: I/O error, dev vda, sector 0
[  136.461142] end_request: I/O error, dev vda, sector 0
[  136.461689] end_request: I/O error, dev vda, sector 0
[  136.461821] end_request: I/O error, dev vda, sector 0
[  136.544370] end_request: I/O error, dev vda, sector 0
[  136.544830] end_request: I/O error, dev vda, sector 0
[  136.544979] end_request: I/O error, dev vda, sector 0
[  136.545566] end_request: I/O error, dev vda, sector 0
[  136.546625] end_request: I/O error, dev vda, sector 0
[  136.617887] end_request: I/O error, dev vda, sector 0
[  136.618387] end_request: I/O error, dev vda, sector 0
[  136.618514] end_request: I/O error, dev vda, sector 0
[  136.619290] end_request: I/O error, dev vda, sector 0
[  136.620323] end_request: I/O error, dev vda, sector 0
[  136.696947] end_request: I/O error, dev vda, sector 0
[  136.697452] end_request: I/O error, dev vda, sector 0
[  136.697580] end_request: I/O error, dev vda, sector 0
[  136.698338] end_request: I/O error, dev vda, sector 0
[  136.699333] end_request: I/O error, dev vda, sector 0
[  136.786275] end_request: I/O error, dev vda, sector 0
[  136.786710] end_request: I/O error, dev vda, sector 0
[  136.786931] end_request: I/O error, dev vda, sector 0
[  136.787592] end_request: I/O error, dev vda, sector 0
[  136.788693] end_request: I/O error, dev vda, sector 0
[  136.869035] end_request: I/O error, dev vda, sector 0
[  136.869497] end_request: I/O error, dev vda, sector 0
[  136.869632] end_request: I/O error, dev vda, sector 0
[  136.870255] end_request: I/O error, dev vda, sector 0
[  136.871294] end_request: I/O error, dev vda, sector 0
[  136.942134] end_request: I/O error, dev vda, sector 0
[  136.942582] end_request: I/O error, dev vda, sector 0
[  136.942712] end_request: I/O error, dev vda, sector 0
[  136.943348] end_request: I/O error, dev vda, sector 0
[  136.944324] end_request: I/O error, dev vda, sector 0
[  137.015362] end_request: I/O error, dev vda, sector 0
[  137.015835] end_request: I/O error, dev vda, sector 0
[  137.016256] end_request: I/O error, dev vda, sector 0
[  137.016827] end_request: I/O error, dev vda, sector 0
[  137.018168] end_request: I/O error, dev vda, sector 0
[  137.089781] end_request: I/O error, dev vda, sector 0
[  137.090456] end_request: I/O error, dev vda, sector 0
[  137.090585] end_request: I/O error, dev vda, sector 0
[  137.091263] end_request: I/O error, dev vda, sector 0
[  137.092402] end_request: I/O error, dev vda, sector 0
[  137.163228] end_request: I/O error, dev vda, sector 0
[  137.164165] end_request: I/O error, dev vda, sector 0
[  137.164293] end_request: I/O error, dev vda, sector 0
[  137.165119] end_request: I/O error, dev vda, sector 0
[  137.166217] end_request: I/O error, dev vda, sector 0
[  137.241291] end_request: I/O error, dev vda, sector 0
[  137.241746] end_request: I/O error, dev vda, sector 0
[  137.242074] end_request: I/O error, dev vda, sector 0
[  137.242780] end_request: I/O error, dev vda, sector 0
[  137.243955] end_request: I/O error, dev vda, sector 0
[  137.316039] end_request: I/O error, dev vda, sector 0
[  137.316576] end_request: I/O error, dev vda, sector 0
[  137.316705] end_request: I/O error, dev vda, sector 0
[  137.317405] end_request: I/O error, dev vda, sector 0
[  137.319513] end_request: I/O error, dev vda, sector 0
[  137.320015] end_request: I/O error, dev vda, sector 0
[  137.320230] end_request: I/O error, dev vda, sector 0
[  137.394061] end_request: I/O error, dev vda, sector 0
[  137.394509] end_request: I/O error, dev vda, sector 0
[  137.394867] end_request: I/O error, dev vda, sector 0
[  137.396015] end_request: I/O error, dev vda, sector 0
[  137.396832] end_request: I/O error, dev vda, sector 0
[  137.467945] end_request: I/O error, dev vda, sector 0
[  137.468410] end_request: I/O error, dev vda, sector 0
[  137.468541] end_request: I/O error, dev vda, sector 0
[  137.469293] end_request: I/O error, dev vda, sector 0
[  137.470249] end_request: I/O error, dev vda, sector 0
[  137.541335] end_request: I/O error, dev vda, sector 0
[  137.541795] end_request: I/O error, dev vda, sector 0
[  137.542229] end_request: I/O error, dev vda, sector 0
[  137.543228] end_request: I/O error, dev vda, sector 0
[  137.544569] end_request: I/O error, dev vda, sector 0
[  142.715215] end_request: I/O error, dev vda, sector 0
[  142.715793] end_request: I/O error, dev vda, sector 0
[  148.712128] end_request: I/O error, dev vda, sector 0
[  148.712962] end_request: I/O error, dev vda, sector 0
[  154.710622] end_request: I/O error, dev vda, sector 0
[  154.711254] end_request: I/O error, dev vda, sector 0
[  160.711311] end_request: I/O error, dev vda, sector 0
[  160.711943] end_request: I/O error, dev vda, sector 0
[  166.716580] end_request: I/O error, dev vda, sector 0
[  166.717427] end_request: I/O error, dev vda, sector 0
[  172.718298] end_request: I/O error, dev vda, sector 0
[  172.719033] end_request: I/O error, dev vda, sector 0
[  178.714635] end_request: I/O error, dev vda, sector 0
[  178.715434] end_request: I/O error, dev vda, sector 0
[  184.713389] end_request: I/O error, dev vda, sector 0
[  184.714199] end_request: I/O error, dev vda, sector 0
[  190.711770] end_request: I/O error, dev vda, sector 0
[  190.712837] end_request: I/O error, dev vda, sector 0
[  196.713417] end_request: I/O error, dev vda, sector 0
[  196.714136] end_request: I/O error, dev vda, sector 0
[  202.718790] end_request: I/O error, dev vda, sector 0
[  202.719570] end_request: I/O error, dev vda, sector 0
[  208.717100] end_request: I/O error, dev vda, sector 0
[  208.717798] end_request: I/O error, dev vda, sector 0
[  214.713902] end_request: I/O error, dev vda, sector 0
[  214.714569] end_request: I/O error, dev vda, sector 0
[  220.714948] end_request: I/O error, dev vda, sector 0
[  220.715950] end_request: I/O error, dev vda, sector 0
[  226.713831] end_request: I/O error, dev vda, sector 0
[  226.715625] end_request: I/O error, dev vda, sector 0
[  232.713567] end_request: I/O error, dev vda, sector 0
[  232.714343] end_request: I/O error, dev vda, sector 0
[  238.711824] end_request: I/O error, dev vda, sector 0
[  238.712679] end_request: I/O error, dev vda, sector 0
[  244.719042] end_request: I/O error, dev vda, sector 0
[  244.719719] end_request: I/O error, dev vda, sector 0
[  246.969395] end_request: I/O error, dev vda, sector 0
[  246.970169] end_request: I/O error, dev vda, sector 0
[  246.970467] end_request: I/O error, dev vda, sector 0

--=-gMMff2ZHdVokXhAdgdu0
Content-Disposition: attachment; filename="config"
Content-Type: text/x-mpsub; name="config"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.32-rc3
# Wed Oct 28 22:27:28 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
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
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
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
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_EVENT_PROFILE=y
CONFIG_PERF_COUNTERS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_IBS is not set
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_X86_CPU_DEBUG is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65535
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
# CONFIG_INTR_REMAP is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_CFG80211_DEFAULT_PS_VALUE=0
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_XEN_BLKDEV_FRONTEND is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
# CONFIG_SCSI_DH_HP_SW is not set
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MULTICORE_RAID456 is not set
CONFIG_MD_RAID6_PQ=m
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
# CONFIG_TULIP is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_E100 is not set
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=m
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_XEN_NETDEV_FRONTEND is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_WINBOND_CIR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_VGA_ARB=y
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_KYE=m
CONFIG_HID_GYRATION=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LOGITECH=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set

#
# TI VLYNQ
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_HP_WMI is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_NILFS2_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_V4_1 is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
CONFIG_SECURITY_TOMOYO=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_NLATTR=y

--=-gMMff2ZHdVokXhAdgdu0--

