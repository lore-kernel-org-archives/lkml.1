Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYJ0Nd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYJ0Nd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYJ0NdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:33:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54789 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbYJ0NdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:33:12 -0400
Date: Mon, 27 Oct 2008 14:32:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip/cpus4096-v2] cpumask: fix cpumask of
	call_function_data
Message-ID: <20081027133248.GA1007@elte.hu>
References: <49015358.9050308@ct.jp.nec.com> <200810242215.19440.rusty@rustcorp.com.au> <20081027125512.GD12461@elte.hu> <20081027125904.GA24347@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20081027125904.GA24347@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.7
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.7 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE,UPPERCASE_50_75 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
	0.8 UPPERCASE_50_75        message body is 50-75% uppercase
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Ingo Molnar <mingo@elte.hu> wrote:

> in any case, i've started testing tip/cpus4096-v2 again on x86 - the 
> problem with d4de5a above was the only outstanding known issue, right?

the sched_init() slab corruption bug is still there, i just triggered it 
on two separate test-systems:

[    0.510620] CPU1 attaching sched-domain:
[    0.512007]  domain 0: span 0-1 level CPU
[    0.517730]   groups: 1 0
[    0.520528] =============================================================================
[    0.524002] BUG kmalloc-8: Wrong object count. Counter is 11 but counted were 50
[    0.524002] -----------------------------------------------------------------------------
[    0.524002] 

i've pushed out that specific tree: tip/tmp.cpus4096-v2.broken, which 
you should be able to reproduce via:

  git remote update
  git checkout -b tmp.test tip/tmp.cpus4096-v2.broken

config attached. This config should just run through a 'make oldconfig' 
fine and if the bzImage is built, it should produce the slab corruption 
messages on any typical 64-bit PC. I've attached the boot log below as 
well. (You can see the gcc version i used in the bootup log as well.)

I'll disable MAXSMP in these testruns - just to establish the stability 
without any of the dynamic-cpumask_t stuff.

	Ingo

[    0.000000] BIOS EBDA/lowmem at: 0009f800/0009f800
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.28-rc2-tip-00767-gd1142e8 (mingo@dione) (gcc version 4.2.3) #45748 SMP Mon Oct 27 14:24:20 CET 2008
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] using polling idle threads.
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000]  0000000000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 29c8000-2bca000
[    0.000000] last_map_addr: 3fff0000 end: 3fff0000
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
[    0.000000] ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (5 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 00029c7e38]    TEXT DATA BSS ==> [0000200000 - 00029c7e38]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [00029c8000 - 0002bc8000]          PGTABLE ==> [00029c8000 - 0002bc8000]
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000f5680] 000f5680
[    0.000000]  [ffffe20000000000-ffffe200019fffff] PMD -> [ffff880002e00000-ffff8800047fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 262015
[    0.000000]   DMA zone: 104 pages used for memmap
[    0.000000]   DMA zone: 101 pages reserved
[    0.000000]   DMA zone: 3778 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6552 pages used for memmap
[    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] PERCPU: Allocating 1900544 bytes of per cpu data
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 255258
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=2 idle=poll panic=1
[    0.000000] debug: sysrq always enabled.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.302 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:           4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 4351 kB
[    0.004000]  per task-struct memory footprint: 2688 bytes
[    0.004000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.004000] allocated 10485760 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 20000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Memory: 962348k/1048512k available (8300k kernel code, 452k absent, 85124k reserved, 12145k data, 2444k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004018] Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.60 BogoMIPS (lpj=8041208)
[    0.012108] Security Framework initialized
[    0.016012] SELinux:  Initializing.
[    0.020150] SELinux:  Starting in permissive mode
[    0.024095] Mount-cache hash table entries: 256
[    0.033317] Initializing cgroup subsys ns
[    0.036024] Initializing cgroup subsys memory
[    0.040041] Initializing cgroup subsys devices
[    0.044028] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.048007] CPU: L2 Cache: 512K (64 bytes/line)
[    0.052007] tseg: 0000000000
[    0.056024] CPU: Physical Processor ID: 0
[    0.060007] CPU: Processor Core ID: 0
[    0.065643] ACPI: Core revision 20080926
[    0.105845] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.108010] ftrace: allocating 24346 entries in 191 pages
[    0.116342] Setting APIC routing to flat
[    0.120010] enabled ExtINT on CPU#0
[    0.124175] ENABLING IO-APIC IRQs
[    0.128006] init IO_APIC IRQs
[    0.130950] IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.132014] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.136012] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.140011] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.144011] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.148011] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.152011] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.156011] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.160011] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.164012] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.168011] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.172011] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.176011] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.180011] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.184011] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.188010]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.195539] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.237588] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.244005] Using local APIC timer interrupts.
[    0.244007] calibrating APIC timer ...
[    0.252001] ... lapic delta = 1256509
[    0.252001] ... PM timer delta = 357974
[    0.252001] ... PM timer result ok
[    0.252001] ..... delta 1256509
[    0.252001] ..... mult: 53963277
[    0.252001] ..... calibration result: 804165
[    0.252001] ..... CPU clock speed is 2010.1658 MHz.
[    0.252001] ..... host bus clock speed is 201.0165 MHz.
[    0.252025] calling  migration_init+0x0/0x5b @ 1
[    0.256159] initcall migration_init+0x0/0x5b returned 1 after 0 usecs
[    0.260007] initcall migration_init+0x0/0x5b returned with error code 1 
[    0.264005] calling  spawn_ksoftirqd+0x0/0x58 @ 1
[    0.268128] initcall spawn_ksoftirqd+0x0/0x58 returned 0 after 0 usecs
[    0.272007] calling  init_call_single_data+0x0/0x78 @ 1
[    0.276007] initcall init_call_single_data+0x0/0x78 returned 0 after 0 usecs
[    0.280006] calling  relay_init+0x0/0x14 @ 1
[    0.284007] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.288006] calling  tracer_alloc_buffers+0x0/0x170 @ 1
[    0.293945] initcall tracer_alloc_buffers+0x0/0x170 returned 0 after 0 usecs
[    0.296292] lockdep: fixing up alternatives.
[    0.300181] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4020.87 BogoMIPS (lpj=8041759)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.396174] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.408037] Brought up 2 CPUs
[    0.412006] Total of 2 processors activated (8041.48 BogoMIPS).
[    0.416080] Testing NMI watchdog ... OK.
[    0.501354] CPU0 attaching sched-domain:
[    0.504009]  domain 0: span 0-1 level CPU
[    0.508005]   groups: 0 1
[    0.510620] CPU1 attaching sched-domain:
[    0.512007]  domain 0: span 0-1 level CPU
[    0.517730]   groups: 1 0
[    0.520528] =============================================================================
[    0.524002] BUG kmalloc-8: Wrong object count. Counter is 11 but counted were 50
[    0.524002] -----------------------------------------------------------------------------
[    0.524002] 
[    0.524002] INFO: Slab 0xffffe200019cc270 objects=51 used=11 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.524002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.524002] Call Trace:
[    0.524002]  [<ffffffff802d532d>] slab_err+0x99/0xa7
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.524002]  [<ffffffff8024fac7>] ? rq_attach_root+0xc0/0xc9
[    0.524002]  [<ffffffff80254f0e>] ? cpu_attach_domain+0x5a2/0x5d7
[    0.524002]  [<ffffffff802d5797>] ? slab_pad_check+0xa7/0x11f
[    0.524002]  [<ffffffff802d5660>] on_freelist+0x1bd/0x1ff
[    0.524002]  [<ffffffff802d6246>] __slab_free+0x1a5/0x2fc
[    0.524002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.524002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff80255521>] __build_sched_domains+0x5de/0x616
[    0.524002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.524002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.524002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.524002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.524002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.524002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.524002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.524002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.524002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.524002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.524002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.524002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.524002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.524002] FIX kmalloc-8: Object count adjusted.
[    0.524002] =============================================================================
[    0.524002] BUG kmalloc-8: Redzone overwritten
[    0.524002] -----------------------------------------------------------------------------
[    0.524002] 
[    0.524002] INFO: 0xffff88003f806328-0xffff88003f80632f. First byte 0x0 instead of 0xcc
[    0.524002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.524002] INFO: Object 0xffff88003f806320 @offset=800 fp=0x0000000000000000
[    0.524002] 
[    0.524002] Bytes b4 0xffff88003f806310:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.524002]   Object 0xffff88003f806320:  02 00 00 00 00 00 00 00                         ........        
[    0.524002]  Redzone 0xffff88003f806328:  00 00 00 00 00 00 00 00                         ........        
[    0.524002]  Padding 0xffff88003f806368:  00 00 00 00 00 00 00 00                         ........        
[    0.524002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.524002] Call Trace:
[    0.524002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.524002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.524002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.524002]  [<ffffffff802d6264>] __slab_free+0x1c3/0x2fc
[    0.524002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.524002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.524002]  [<ffffffff80255521>] __build_sched_domains+0x5de/0x616
[    0.524002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.524002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.524002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.524002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.524002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.524002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.524002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.524002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.524002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.524002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.524002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.524002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.524002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.524002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.524002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.524002] FIX kmalloc-8: Restoring 0xffff88003f806328-0xffff88003f80632f=0xcc
[    0.524002] 
[    0.524006] =============================================================================
[    0.528002] BUG kmalloc-8: Redzone overwritten
[    0.528002] -----------------------------------------------------------------------------
[    0.528002] 
[    0.528002] INFO: 0xffff88003f8062d8-0xffff88003f8062df. First byte 0x0 instead of 0xcc
[    0.528002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.528002] INFO: Object 0xffff88003f8062d0 @offset=720 fp=0x0000000000000000
[    0.528002] 
[    0.528002] Bytes b4 0xffff88003f8062c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.528002]   Object 0xffff88003f8062d0:  03 00 00 00 00 00 00 00                         ........        
[    0.528002]  Redzone 0xffff88003f8062d8:  00 00 00 00 00 00 00 00                         ........        
[    0.528002]  Padding 0xffff88003f806318:  00 00 00 00 00 00 00 00                         ........        
[    0.528002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.528002] Call Trace:
[    0.528002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.528002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.528002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.528002]  [<ffffffff802d6264>] __slab_free+0x1c3/0x2fc
[    0.528002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.528002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.528002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.528002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.528002]  [<ffffffff8025552a>] __build_sched_domains+0x5e7/0x616
[    0.528002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.528002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.528002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.528002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.528002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.528002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.528002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.528002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.528002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.528002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.528002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.528002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.528002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.528002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.528002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.528002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.528002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.528002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.528002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.528002] FIX kmalloc-8: Restoring 0xffff88003f8062d8-0xffff88003f8062df=0xcc
[    0.528002] 
[    0.528006] =============================================================================
[    0.532002] BUG kmalloc-8: Redzone overwritten
[    0.532002] -----------------------------------------------------------------------------
[    0.532002] 
[    0.532002] INFO: 0xffff88003f806288-0xffff88003f80628f. First byte 0x0 instead of 0xcc
[    0.532002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.532002] INFO: Object 0xffff88003f806280 @offset=640 fp=0x0000000000000000
[    0.532002] 
[    0.532002] Bytes b4 0xffff88003f806270:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.532002]   Object 0xffff88003f806280:  00 00 00 00 00 00 00 00                         ........        
[    0.532002]  Redzone 0xffff88003f806288:  00 00 00 00 00 00 00 00                         ........        
[    0.532002]  Padding 0xffff88003f8062c8:  00 00 00 00 00 00 00 00                         ........        
[    0.532002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.532002] Call Trace:
[    0.532002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.532002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.532002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.532002]  [<ffffffff802d6264>] __slab_free+0x1c3/0x2fc
[    0.532002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.532002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.532002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.532002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.532002]  [<ffffffff80255533>] __build_sched_domains+0x5f0/0x616
[    0.532002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.532002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.532002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.532002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.532002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.532002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.532002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.532002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.532002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.532002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.532002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.532002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.532002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.532002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.532002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.532002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.532002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.532002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.532002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.532002] FIX kmalloc-8: Restoring 0xffff88003f806288-0xffff88003f80628f=0xcc
[    0.532002] 
[    0.532006] =============================================================================
[    0.536002] BUG kmalloc-8: Redzone overwritten
[    0.536002] -----------------------------------------------------------------------------
[    0.536002] 
[    0.536002] INFO: 0xffff88003f806238-0xffff88003f80623f. First byte 0x0 instead of 0xcc
[    0.536002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.536002] INFO: Object 0xffff88003f806230 @offset=560 fp=0x0000000000000000
[    0.536002] 
[    0.536002] Bytes b4 0xffff88003f806220:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.536002]   Object 0xffff88003f806230:  00 00 00 00 00 00 00 00                         ........        
[    0.536002]  Redzone 0xffff88003f806238:  00 00 00 00 00 00 00 00                         ........        
[    0.536002]  Padding 0xffff88003f806278:  00 00 00 00 00 00 00 00                         ........        
[    0.536002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.536002] Call Trace:
[    0.536002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.536002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.536002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.536002]  [<ffffffff802d6264>] __slab_free+0x1c3/0x2fc
[    0.536002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.536002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.536002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.536002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.536002]  [<ffffffff8025553c>] __build_sched_domains+0x5f9/0x616
[    0.536002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.536002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.536002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.536002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.536002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.536002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.536002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.536002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.536002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.536002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.536002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.536002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.536002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.536002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.536002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.536002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.536002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.536002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.536002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.536002] FIX kmalloc-8: Restoring 0xffff88003f806238-0xffff88003f80623f=0xcc
[    0.536002] 
[    0.536006] =============================================================================
[    0.540002] BUG kmalloc-8: Redzone overwritten
[    0.540002] -----------------------------------------------------------------------------
[    0.540002] 
[    0.540002] INFO: 0xffff88003f8061e8-0xffff88003f8061ef. First byte 0x0 instead of 0xcc
[    0.540002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.540002] INFO: Object 0xffff88003f8061e0 @offset=480 fp=0x0000000000000000
[    0.540002] 
[    0.540002] Bytes b4 0xffff88003f8061d0:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[    0.540002]   Object 0xffff88003f8061e0:  03 00 00 00 00 00 00 00                         ........        
[    0.540002]  Redzone 0xffff88003f8061e8:  00 00 00 00 00 00 00 00                         ........        
[    0.540002]  Padding 0xffff88003f806228:  00 00 00 00 00 00 00 00                         ........        
[    0.540002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.540002] Call Trace:
[    0.540002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.540002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.540002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.540002]  [<ffffffff802d6264>] __slab_free+0x1c3/0x2fc
[    0.540002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.540002]  [<ffffffff802d6dc4>] kfree+0xf0/0x128
[    0.540002]  [<ffffffff8049d85d>] ? free_cpumask_var+0x9/0xb
[    0.540002]  [<ffffffff8049d85d>] free_cpumask_var+0x9/0xb
[    0.540002]  [<ffffffff80255545>] __build_sched_domains+0x602/0x616
[    0.540002]  [<ffffffff81be18e4>] sched_init_smp+0xa0/0x23a
[    0.540002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.540002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.540002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.540002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.540002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.540002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.540002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.540002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.540002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.540002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.540002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.540002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.540002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.540002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.540002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.540002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.540002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.540002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.540002] FIX kmalloc-8: Restoring 0xffff88003f8061e8-0xffff88003f8061ef=0xcc
[    0.540002] 
[    0.540009] =============================================================================
[    0.544002] BUG kmalloc-8: Redzone overwritten
[    0.544002] -----------------------------------------------------------------------------
[    0.544002] 
[    0.544002] INFO: 0xffff88003f806378-0xffff88003f80637f. First byte 0x0 instead of 0xbb
[    0.544002] INFO: Slab 0xffffe200019cc270 objects=51 used=50 fp=0xffff88003f806370 flags=0x40000000000000c3
[    0.544002] INFO: Object 0xffff88003f806370 @offset=880 fp=0x0000000000000000
[    0.544002] 
[    0.544002] Bytes b4 0xffff88003f806360:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
[    0.544002]   Object 0xffff88003f806370:  00 00 00 00 00 00 00 00                         ........        
[    0.544002]  Redzone 0xffff88003f806378:  00 00 00 00 00 00 00 00                         ........        
[    0.544002]  Padding 0xffff88003f8063b8:  00 00 00 00 00 00 00 00                         ........        
[    0.544002] Pid: 1, comm: swapper Not tainted 2.6.28-rc2-tip-00767-gd1142e8 #45748
[    0.544002] Call Trace:
[    0.544002]  [<ffffffff802d5457>] print_trailer+0x11c/0x125
[    0.544002]  [<ffffffff802d597c>] check_bytes_and_report+0xa5/0xcc
[    0.544002]  [<ffffffff80255639>] ? register_sched_domain_sysctl+0xe0/0x439
[    0.544002]  [<ffffffff802d5a04>] check_object+0x61/0x20b
[    0.544002]  [<ffffffff802d6b04>] __slab_alloc+0x3f7/0x4fc
[    0.544002]  [<ffffffff80255639>] ? register_sched_domain_sysctl+0xe0/0x439
[    0.544002]  [<ffffffff80255639>] ? register_sched_domain_sysctl+0xe0/0x439
[    0.544002]  [<ffffffff802d7fd3>] __kmalloc_track_caller+0xa9/0x109
[    0.544002]  [<ffffffff802bb28d>] kstrdup+0x2f/0xca
[    0.544002]  [<ffffffff80255639>] register_sched_domain_sysctl+0xe0/0x439
[    0.544002]  [<ffffffff81be18e9>] sched_init_smp+0xa5/0x23a
[    0.544002]  [<ffffffff80a1755c>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    0.544002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.544002]  [<ffffffff802d5914>] ? check_bytes_and_report+0x3d/0xcc
[    0.544002]  [<ffffffff802d5afd>] ? check_object+0x15a/0x20b
[    0.544002]  [<ffffffff802d602c>] ? init_object+0x6c/0x74
[    0.544002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.544002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.544002]  [<ffffffff8027fbb0>] ? trace_hardirqs_on+0xd/0xf
[    0.544002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.544002]  [<ffffffff81bd89d2>] ? check_nmi_watchdog+0x20a/0x23b
[    0.544002]  [<ffffffff81bd6620>] ? native_smp_cpus_done+0x177/0x182
[    0.544002]  [<ffffffff8025dc83>] ? cpu_maps_update_done+0x15/0x17
[    0.544002]  [<ffffffff81bc89ad>] kernel_init+0x192/0x216
[    0.544002]  [<ffffffff8027fb78>] ? trace_hardirqs_on_caller+0x11a/0x145
[    0.544002]  [<ffffffff80223809>] child_rip+0xa/0x11
[    0.544002]  [<ffffffff80222a13>] ? restore_args+0x0/0x30
[    0.544002]  [<ffffffff81bc881b>] ? kernel_init+0x0/0x216
[    0.544002]  [<ffffffff802237ff>] ? child_rip+0x0/0x11
[    0.544002] FIX kmalloc-8: Restoring 0xffff88003f806378-0xffff88003f80637f=0xbb
[    0.544002] 
[    0.544002] FIX kmalloc-8: Marking all objects used
[    0.544278] device: 'platform': device_add
[    0.548046] PM: Adding info for No Bus:platform
[    0.552460] khelper used greatest stack depth: 5288 bytes left
[    0.556059] bus: 'platform': registered
[    0.560014] Registering sysdev class 'cpu'
[    0.568290] calling  net_ns_init+0x0/0x140 @ 1
[    0.572006] net_namespace: 1112 bytes
[    0.576030] initcall net_ns_init+0x0/0x140 returned 0 after 3906 usecs
[    0.580019] calling  init_smp_flush+0x0/0x72 @ 1
[    0.584008] initcall init_smp_flush+0x0/0x72 returned 0 after 0 usecs
[    0.588010] calling  print_banner+0x0/0xe @ 1
[    0.592005] Booting paravirtualized kernel on bare hardware

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc2
# Mon Oct 27 14:23:24 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MM_OWNER=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_KVM_CLOCK=y
# CONFIG_KVM_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_MEMTEST=y
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
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_64=y
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_UNEVICTABLE_LRU is not set
CONFIG_MMU_NOTIFIER=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_WMI is not set
CONFIG_ACPI_ASUS=y
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

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
CONFIG_DMAR_GFX_WA=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_INTR_REMAP=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=y
CONFIG_ACTISYS_DONGLE=y
CONFIG_TEKRAM_DONGLE=y
# CONFIG_TOIM3232_DONGLE is not set
CONFIG_LITELINK_DONGLE=y
# CONFIG_MA600_DONGLE is not set
# CONFIG_GIRBIL_DONGLE is not set
CONFIG_MCP2120_DONGLE=y
CONFIG_OLD_BELKIN_DONGLE=y
# CONFIG_ACT200L_DONGLE is not set
CONFIG_KINGSUN_DONGLE=y
# CONFIG_KSDAZZLE_DONGLE is not set
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_IEEE80211=y
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_LEDS=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SX4=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y
CONFIG_SATA_INIC162X=y
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=y
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87410=y
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_OPTIDMA=y
# CONFIG_PATA_PDC_OLD is not set
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_IEEE1394_VIDEO1394 is not set
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=y
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_NET_SB1000 is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_ENC28J60=y
# CONFIG_ENC28J60_WRITEVERIFY is not set
# CONFIG_NET_TULIP is not set
CONFIG_HP100=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
CONFIG_AMD8111_ETH=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
CONFIG_NATSEMI=y
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=y
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=y
CONFIG_NET_POCKET=y
CONFIG_ATP=y
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_DL2K=y
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IP1000=y
CONFIG_IGB=y
# CONFIG_IGB_LRO is not set
CONFIG_NS83820=y
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
CONFIG_SIS190=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKY2 is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
CONFIG_QLA3XXX=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
CONFIG_MLX4_CORE=y
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
# CONFIG_LIBERTAS is not set
CONFIG_AIRO=y
CONFIG_HERMES=y
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_IWLWIFI_LEDS is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
CONFIG_HOSTAP_PLX=y
CONFIG_HOSTAP_PCI=y

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_HSO is not set
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
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

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
CONFIG_AT24=y
CONFIG_SENSORS_EEPROM=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_LM70_LLP is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=y
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_WM8400 is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMIZE=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

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
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1760_PCI=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49W=y
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=y
CONFIG_USB_PHIDGETKIT=y
CONFIG_USB_PHIDGETMOTORCONTROL=y
# CONFIG_USB_PHIDGETSERVO is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_VST is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=y
CONFIG_UWB_I1480U=y
# CONFIG_UWB_I1480U_WLP is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_DA903X=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_NES=y
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_SMX=y
CONFIG_UIO_SERCOS3=y
# CONFIG_STAGING is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
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
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_CRAMFS=y
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_EXPERIMENTAL is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_UTF8 is not set
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
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
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_BACKTRACE_SELF_TEST=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--ZPt4rx8FFjLCG7dd--
