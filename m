Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZHMJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZHMJpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZHMJpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:45:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZHMJpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:45:09 -0400
Date: Thu, 13 Aug 2009 11:44:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: kmemleak: Protect the seq start/next/stop sequence
	byrcu_read_lock()
Message-ID: <20090813094437.GB22762@elte.hu>
References: <20090812205215.GA21451@elte.hu> <1250115375.11496.25.camel@pc1117.cambridge.arm.com> <20090813065253.GC12143@elte.hu> <1250156396.13180.24.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1250156396.13180.24.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Thu, 2009-08-13 at 08:52 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > On Wed, 2009-08-12 at 21:52 +0100, Ingo Molnar wrote:
> > > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > 
> > > > > kmemleak: Allow rescheduling during an object scanning
> > > > 
> > > > i tried this in -tip testing, and it crashes quickly:
> > > > 
> > > > [   81.900051] BUG: unable to handle kernel paging request at ffff880020000000
> > > > [   81.901382] IP: [<ffffffff8112ae7e>] scan_block+0xee/0x190
> > > 
> > > It looks like my check for object->flags & OBJECT_ALLOCATED in 
> > > scan_object() may not be enough.
> > > 
> > > I'm a bit confused as the config you sent says x86_32 but the 
> > > fault address above looks like a 64 bit one (and my knowledge 
> > > of x86 isn't great). Is this x86_64?
> > 
> > ahm indeed. It crashed not straight during bootup but while my 
> > tests built the next kernel iteration already (with a new random 
> > config),
> 
> Looking through the code and documentation, the fault address 
> above seems to be the directly mapped RAM. Do you have 512MB of 
> RAM or less on your machine? Or is there a hole in the virtual 
> space at that point?

i still have the full crashlog (attached below) - you can see all 
the mappings (and other details) in that.

It's a fairly regular whitebox PC with 1GB of RAM:

[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 10000-13000

	Ingo

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

[    0.000000] Linux version 2.6.31-rc5-tip (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #3776 SMP Wed Aug 12 22:42:06 CEST 2009
[    0.000000] Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FFC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003fff0000
[    0.000000]  0000000000 - 003fe00000 page 2M
[    0.000000]  003fe00000 - 003fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 10000-13000
[    0.000000] ACPI: RSDP 00000000000f76f0 00014 (v00 Nvidia)
[    0.000000] ACPI: RSDT 000000003fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP 000000003fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT 000000003fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000003fff0000 00040
[    0.000000] ACPI: SRAT 000000003fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
[    0.000000] ACPI: MCFG 000000003fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC 000000003fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-40000000
[    0.000000] NUMA: Allocated memnodemap from 11000 - 11840
[    0.000000] NUMA: Using 20 for the hash shift.
[    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
[    0.000000]   NODE_DATA [0000000000011840 - 000000000002083f]
[    0.000000]   bootmap [0000000000021000 -  0000000000028fff] pages 8
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 003fff0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00028f3450]    TEXT DATA BSS ==> [0001000000 - 00028f3450]
[    0.000000]   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #4 [00028f4000 - 00028f4149]              BRK ==> [00028f4000 - 00028f4149]
[    0.000000]   #5 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
[    0.000000]   #6 [0000011000 - 0000011840]       MEMNODEMAP ==> [0000011000 - 0000011840]
[    0.000000]  [ffffea0000000000-ffffea00019fffff] PMD -> [ffff880002e00000-ffff8800047fffff] on node 0
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
[    0.000000]   DMA zone: 100 pages reserved
[    0.000000]   DMA zone: 3779 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6552 pages used for memmap
[    0.000000]   DMA32 zone: 251480 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
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
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages at ffff88000290d000, static data 1915808 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 255259
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel selinux=0 nmi_watchdog=0 panic=1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 8270000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] Memory: 926324k/1048512k available (8556k kernel code, 452k absent, 121736k reserved, 4130k data, 2608k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.601 MHz processor.
[    0.000043] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [ttyS0] enabled, bootconsole disabled
[    0.004000] console [ttyS0] enabled, bootconsole disabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.004000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.004000] ... CHAINHASH_SIZE:          16384
[    0.004000]  memory used by lock dependency info: 6367 kB
[    0.004000]  per task-struct memory footprint: 2688 bytes
[    0.004033] Calibrating delay loop (skipped), value calculated using timer frequency.. 4021.20 BogoMIPS (lpj=8042404)
[    0.012218] Security Framework initialized
[    0.016039] TOMOYO Linux initialized
[    0.020490] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.024815] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.028385] Mount-cache hash table entries: 256
[    0.037574] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.040008] CPU: L2 Cache: 512K (64 bytes/line)
[    0.044009] CPU 0/0x0 -> Node 0
[    0.048007] tseg: 0000000000
[    0.050959] CPU: Physical Processor ID: 0
[    0.052010] CPU: Processor Core ID: 0
[    0.056011] numa_add_cpu cpu 0 node 0: mask now 0
[    0.064917] Freeing SMP alternatives: 40k freed
[    0.068045] ACPI: Core revision 20090521
[    0.196466] Setting APIC routing to flat
[    0.200088] enabled ExtINT on CPU#0
[    0.204238] ENABLING IO-APIC IRQs
[    0.207554] init IO_APIC IRQs
[    0.208140] IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.212105] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.216107] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.220097] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.224121] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.228099] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.232100] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.236100] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.240107] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.244100] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.248101] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.252099] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.256099] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.260100] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.264099] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.268083]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
[    0.276219] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.320460] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.325306] Using local APIC timer interrupts.
[    0.325307] calibrating APIC timer ...
[    0.332001] ... lapic delta = 1256511
[    0.332001] ... PM-Timer delta = 357976
[    0.332001] ... PM-Timer result ok
[    0.332001] ..... delta 1256511
[    0.332001] ..... mult: 53963363
[    0.332001] ..... calibration result: 804167
[    0.332001] ..... CPU clock speed is 2010.1679 MHz.
[    0.332001] ..... host bus clock speed is 201.0167 MHz.
[    0.332033] calling  migration_init+0x0/0x7f @ 1
[    0.336310] initcall migration_init+0x0/0x7f returned 0 after 0 usecs
[    0.340078] calling  spawn_ksoftirqd+0x0/0x7f @ 1
[    0.344498] initcall spawn_ksoftirqd+0x0/0x7f returned 0 after 0 usecs
[    0.348007] calling  init_call_single_data+0x0/0xea @ 1
[    0.352017] initcall init_call_single_data+0x0/0xea returned 0 after 0 usecs
[    0.356007] calling  spawn_softlockup_task+0x0/0x9e @ 1
[    0.360112] initcall spawn_softlockup_task+0x0/0x9e returned 0 after 0 usecs
[    0.364007] calling  relay_init+0x0/0x32 @ 1
[    0.368007] initcall relay_init+0x0/0x32 returned 0 after 0 usecs
[    0.372459] lockdep: fixing up alternatives.
[    0.376285] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] masked ExtINT on CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4020.87 BogoMIPS (lpj=8041744)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.468530] CPU1: 
[    0.468011] ------------[ cut here ]------------
[    0.468023] WARNING: at kernel/rcutree.c:1140 __rcu_process_callbacks+0x12b/0x140()
[    0.468025] Hardware name: System Product Name
[    0.468027] Modules linked in:
[    0.468031] Pid: 0, comm: swapper Not tainted 2.6.31-rc5-tip #3776
[    0.468033] Call Trace:
[    0.468035]  <IRQ>  [<ffffffff810de7eb>] ? __rcu_process_callbacks+0x12b/0x140
[    0.468044]  [<ffffffff81082510>] warn_slowpath_common+0x80/0xe0
[    0.468048]  [<ffffffff81082592>] warn_slowpath_null+0x22/0x40
[    0.468051]  [<ffffffff810de7eb>] __rcu_process_callbacks+0x12b/0x140
[    0.468055]  [<ffffffff810de839>] rcu_process_callbacks+0x39/0x80
[    0.468059]  [<ffffffff81089a32>] __do_softirq+0x112/0x210
[    0.468064]  [<ffffffff810306cc>] call_softirq+0x1c/0x30
[    0.468068]  [<ffffffff810325a5>] do_softirq+0xb5/0x100
[    0.468071]  [<ffffffff810894f5>] irq_exit+0xb5/0xe0
[    0.468075]  [<ffffffff81047490>] smp_apic_timer_interrupt+0x80/0xd0
[    0.468079]  [<ffffffff810300d3>] apic_timer_interrupt+0x13/0x20
[    0.468081]  <EOI>  [<ffffffff81053306>] ? native_safe_halt+0x6/0x10
[    0.468089]  [<ffffffff81038f3a>] ? default_idle+0x9a/0x110
[    0.468093]  [<ffffffff8102d9b6>] ? cpu_idle+0xb6/0x160
[    0.468097]  [<ffffffff81cc8909>] ? start_secondary+0xb6/0xfd
[    0.468101]  [<ffffffff813788b3>] ? acpi_ns_one_complete_parse+0x10b/0x13a
[    0.468131] ---[ end trace 6d450e935ee1897c ]---
[    0.472007] AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.477267] Brought up 2 CPUs
[    0.480008] Total of 2 processors activated (8042.07 BogoMIPS).
[    0.485203] CPU0 attaching sched-domain:
[    0.488016]  domain 0: span 0-1 level CPU
[    0.493756]   groups: 0 1
[    0.496626] CPU1 attaching sched-domain:
[    0.500017]  domain 0: span 0-1 level CPU
[    0.505755]   groups: 1 0
[    0.512221] calling  init_cpufreq_transition_notifier_list+0x0/0x42 @ 1
[    0.516016] initcall init_cpufreq_transition_notifier_list+0x0/0x42 returned 0 after 0 usecs
[    0.524033] calling  net_ns_init+0x0/0x134 @ 1
[    0.532256] initcall net_ns_init+0x0/0x134 returned 0 after 0 usecs
[    0.536009] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.540015] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.548043] calling  pci_reboot_init+0x0/0x40 @ 1
[    0.552034] initcall pci_reboot_init+0x0/0x40 returned 0 after 0 usecs
[    0.560009] calling  init_lapic_sysfs+0x0/0x54 @ 1
[    0.565910] initcall init_lapic_sysfs+0x0/0x54 returned 0 after 0 usecs
[    0.572035] calling  print_banner+0x0/0xe @ 1
[    0.576007] Booting paravirtualized kernel on bare hardware
[    0.580019] initcall print_banner+0x0/0xe returned 0 after 3906 usecs
[    0.588010] calling  init_smp_flush+0x0/0x70 @ 1
[    0.592009] initcall init_smp_flush+0x0/0x70 returned 0 after 0 usecs
[    0.600008] calling  sysctl_init+0x0/0x5d @ 1
[    0.604281] initcall sysctl_init+0x0/0x5d returned 0 after 0 usecs
[    0.608007] calling  ksysfs_init+0x0/0xeb @ 1
[    0.615866] initcall ksysfs_init+0x0/0xeb returned 0 after 0 usecs
[    0.620009] calling  async_init+0x0/0x77 @ 1
[    0.624008] initcall async_init+0x0/0x77 returned 0 after 0 usecs
[    0.632013] calling  init_jiffies_clocksource+0x0/0x3d @ 1
[    0.636025] initcall init_jiffies_clocksource+0x0/0x3d returned 0 after 0 usecs
[    0.644008] calling  pm_init+0x0/0x70 @ 1
[    0.648052] initcall pm_init+0x0/0x70 returned 0 after 0 usecs
[    0.652008] calling  init_hw_breakpoint+0x0/0x40 @ 1
[    0.660021] initcall init_hw_breakpoint+0x0/0x40 returned 0 after 0 usecs
[    0.664008] calling  filelock_init+0x0/0x63 @ 1
[    0.668029] initcall filelock_init+0x0/0x63 returned 0 after 0 usecs
[    0.676007] calling  init_misc_binfmt+0x0/0x6b @ 1
[    0.680027] initcall init_misc_binfmt+0x0/0x6b returned 0 after 0 usecs
[    0.688008] calling  init_script_binfmt+0x0/0x40 @ 1
[    0.692008] initcall init_script_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.700007] calling  init_elf_binfmt+0x0/0x40 @ 1
[    0.704008] initcall init_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.712007] calling  init_compat_elf_binfmt+0x0/0x40 @ 1
[    0.716008] initcall init_compat_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
[    0.724008] calling  debugfs_init+0x0/0x83 @ 1
[    0.728040] initcall debugfs_init+0x0/0x83 returned 0 after 0 usecs
[    0.732008] calling  securityfs_init+0x0/0x80 @ 1
[    0.740039] initcall securityfs_init+0x0/0x80 returned 0 after 0 usecs
[    0.744009] calling  random32_init+0x0/0x101 @ 1
[    0.748009] initcall random32_init+0x0/0x101 returned 0 after 0 usecs
[    0.756008] calling  regulator_init+0x0/0x55 @ 1
[    0.760006] regulator: core version 0.5
[    0.766491] initcall regulator_init+0x0/0x55 returned 0 after 3906 usecs
[    0.772009] calling  cpufreq_core_init+0x0/0xa3 @ 1
[    0.776010] initcall cpufreq_core_init+0x0/0xa3 returned 0 after 0 usecs
[    0.784012] calling  cpuidle_init+0x0/0x66 @ 1
[    0.788047] initcall cpuidle_init+0x0/0x66 returned 0 after 0 usecs
[    0.792009] calling  virtio_init+0x0/0x60 @ 1
[    0.800194] initcall virtio_init+0x0/0x60 returned 0 after 3906 usecs
[    0.804009] calling  sock_init+0x0/0x90 @ 1
[    0.808389] initcall sock_init+0x0/0x90 returned 0 after 0 usecs
[    0.816014] calling  netpoll_init+0x0/0x69 @ 1
[    0.820008] initcall netpoll_init+0x0/0x69 returned 0 after 0 usecs
[    0.828016] calling  netlink_proto_init+0x0/0x189 @ 1
[    0.832220] NET: Registered protocol family 16
[    0.836155] initcall netlink_proto_init+0x0/0x189 returned 0 after 3906 usecs
[    0.844010] calling  bdi_class_init+0x0/0x68 @ 1
[    0.849952] initcall bdi_class_init+0x0/0x68 returned 0 after 0 usecs
[    0.856010] calling  kobject_uevent_init+0x0/0x7b @ 1
[    0.860039] initcall kobject_uevent_init+0x0/0x7b returned 0 after 0 usecs
[    0.868019] calling  pcibus_class_init+0x0/0x43 @ 1
[    0.873967] initcall pcibus_class_init+0x0/0x43 returned 0 after 0 usecs
[    0.880009] calling  pci_driver_init+0x0/0x40 @ 1
[    0.885706] initcall pci_driver_init+0x0/0x40 returned 0 after 0 usecs
[    0.892018] calling  backlight_class_init+0x0/0x90 @ 1
[    0.897822] initcall backlight_class_init+0x0/0x90 returned 0 after 0 usecs
[    0.904018] calling  video_output_class_init+0x0/0x45 @ 1
[    0.910519] initcall video_output_class_init+0x0/0x45 returned 0 after 0 usecs
[    0.916019] calling  tty_class_init+0x0/0x58 @ 1
[    0.922710] initcall tty_class_init+0x0/0x58 returned 0 after 0 usecs
[    0.928018] calling  vtconsole_class_init+0x0/0xf1 @ 1
[    0.934676] initcall vtconsole_class_init+0x0/0xf1 returned 0 after 0 usecs
[    0.940018] calling  register_node_type+0x0/0xe3 @ 1
[    0.947395] initcall register_node_type+0x0/0xe3 returned 0 after 0 usecs
[    0.952028] calling  i2c_init+0x0/0x9c @ 1
[    0.958717] initcall i2c_init+0x0/0x9c returned 0 after 0 usecs
[    0.964020] calling  amd_postcore_init+0x0/0xe1 @ 1
[    0.968012] node 0 link 0: io port [1000, fffff]
[    0.972034] TOM: 0000000040000000 aka 1024M
[    0.976018] node 0 link 0: mmio [e0000000, efffffff]
[    0.980202] node 0 link 0: mmio [feb00000, fec0ffff]
[    0.988202] node 0 link 0: mmio [a0000, bffff]
[    0.992202] node 0 link 0: mmio [40000000, fed3ffff]
[    0.996201] bus: [00,ff] on node 0 link 0
[    1.000008] bus: 00 index 0 io port: [0, ffff]
[    1.004008] bus: 00 index 1 mmio: [40000000, fcffffffff]
[    1.012008] bus: 00 index 2 mmio: [feb00000, fec0ffff]
[    1.016007] bus: 00 index 3 mmio: [a0000, bffff]
[    1.020009] initcall amd_postcore_init+0x0/0xe1 returned 0 after 50781 usecs
[    1.028009] calling  arch_kdebugfs_init+0x0/0x6b @ 1
[    1.032142] initcall arch_kdebugfs_init+0x0/0x6b returned 0 after 0 usecs
[    1.040009] calling  mtrr_if_init+0x0/0xa0 @ 1
[    1.044039] initcall mtrr_if_init+0x0/0xa0 returned 0 after 0 usecs
[    1.048009] calling  ffh_cstate_init+0x0/0x5b @ 1
[    1.056009] initcall ffh_cstate_init+0x0/0x5b returned -1 after 0 usecs
[    1.060009] initcall ffh_cstate_init+0x0/0x5b returned with error code -1 
[    1.068008] calling  uv_rtc_setup_clock+0x0/0x16a @ 1
[    1.072008] initcall uv_rtc_setup_clock+0x0/0x16a returned -19 after 0 usecs
[    1.080008] calling  acpi_pci_init+0x0/0x93 @ 1
[    1.084046] ACPI: bus type pci registered
[    1.088009] initcall acpi_pci_init+0x0/0x93 returned 0 after 3906 usecs
[    1.096009] calling  dma_bus_init+0x0/0x77 @ 1
[    1.102047] initcall dma_bus_init+0x0/0x77 returned 0 after 0 usecs
[    1.108011] calling  dma_channel_table_init+0x0/0x149 @ 1
[    1.112065] initcall dma_channel_table_init+0x0/0x149 returned 0 after 0 usecs
[    1.120017] calling  pci_arch_init+0x0/0x90 @ 1
[    1.124086] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    1.132009] PCI: MCFG area at e0000000 reserved in E820
[    1.142800] PCI: Using MMCONFIG at e0000000 - efffffff
[    1.148013] PCI: Using configuration type 1 for base access
[    1.152019] initcall pci_arch_init+0x0/0x90 returned 0 after 27343 usecs
[    1.160010] calling  topology_init+0x0/0x113 @ 1
[    1.165830] initcall topology_init+0x0/0x113 returned 0 after 0 usecs
[    1.172014] calling  mtrr_init_finialize+0x0/0x65 @ 1
[    1.176010] initcall mtrr_init_finialize+0x0/0x65 returned 0 after 0 usecs
[    1.184033] calling  param_sysfs_init+0x0/0x117 @ 1
[    1.268211] initcall param_sysfs_init+0x0/0x117 returned 0 after 78125 usecs
[    1.272045] calling  pm_sysrq_init+0x0/0x50 @ 1
[    1.276055] initcall pm_sysrq_init+0x0/0x50 returned 0 after 0 usecs
[    1.284044] calling  audit_watch_init+0x0/0x5d @ 1
[    1.288688] initcall audit_watch_init+0x0/0x5d returned 0 after 0 usecs
[    1.296011] calling  default_bdi_init+0x0/0x63 @ 1
[    1.303624] initcall default_bdi_init+0x0/0x63 returned 0 after 0 usecs
[    1.308050] calling  init_bio+0x0/0xfb @ 1
[    1.314917] bio: create slab <bio-0> at 0
[    1.316122] initcall init_bio+0x0/0xfb returned 0 after 3906 usecs
[    1.324015] calling  fsnotify_init+0x0/0x3d @ 1
[    1.328122] initcall fsnotify_init+0x0/0x3d returned 0 after 0 usecs
[    1.336011] calling  fsnotify_notification_init+0x0/0x129 @ 1
[    1.340027] initcall fsnotify_notification_init+0x0/0x129 returned 0 after 0 usecs
[    1.348020] calling  cryptomgr_init+0x0/0x40 @ 1
[    1.352010] initcall cryptomgr_init+0x0/0x40 returned 0 after 0 usecs
[    1.360009] calling  blk_settings_init+0x0/0x53 @ 1
[    1.364009] initcall blk_settings_init+0x0/0x53 returned 0 after 0 usecs
[    1.372009] calling  blk_ioc_init+0x0/0x51 @ 1
[    1.376019] initcall blk_ioc_init+0x0/0x51 returned 0 after 0 usecs
[    1.380009] calling  blk_softirq_init+0x0/0xd5 @ 1
[    1.388010] initcall blk_softirq_init+0x0/0xd5 returned 0 after 0 usecs
[    1.392009] calling  genhd_device_init+0x0/0x8c @ 1
[    1.399681] initcall genhd_device_init+0x0/0x8c returned 0 after 0 usecs
[    1.404011] calling  blk_dev_integrity_init+0x0/0x53 @ 1
[    1.408021] initcall blk_dev_integrity_init+0x0/0x53 returned 0 after 0 usecs
[    1.416011] calling  gpiolib_debugfs_init+0x0/0x4d @ 1
[    1.424242] initcall gpiolib_debugfs_init+0x0/0x4d returned 0 after 0 usecs
[    1.428011] calling  max732x_init+0x0/0x40 @ 1
[    1.436090] initcall max732x_init+0x0/0x40 returned 0 after 3906 usecs
[    1.440013] calling  pci_slot_init+0x0/0x80 @ 1
[    1.444041] initcall pci_slot_init+0x0/0x80 returned 0 after 0 usecs
[    1.448009] calling  acpi_init+0x0/0x14e @ 1
[    1.461870] ACPI: EC: Look up EC in DSDT
[    1.659094] ACPI: Interpreter enabled
[    1.660009] ACPI: (supports S0 S5)
[    1.664735] ACPI: Using IOAPIC for interrupt routing
[    1.812409] initcall acpi_init+0x0/0x14e returned 0 after 351563 usecs
[    1.816196] calling  dock_init+0x0/0xb4 @ 1
[    1.826507] ACPI: No dock devices found.
[    1.828011] initcall dock_init+0x0/0xb4 returned 0 after 7812 usecs
[    1.832010] calling  acpi_pci_root_init+0x0/0x4f @ 1
[    1.837421] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.844553] PCI: Scanning bus 0000:00
[    1.848205] pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
[    1.852154] pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
[    1.856094] pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
[    1.860030] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    1.864034] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    1.868015] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    1.872040] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.876012] pci 0000:00:01.1: PME# disabled
[    1.880075] pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
[    1.884113] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    1.888134] pci 0000:00:02.0: supports D1 D2
[    1.892046] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.896012] pci 0000:00:02.0: PME# disabled
[    1.900061] pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
[    1.904060] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    1.908071] pci 0000:00:02.1: supports D1 D2
[    1.912009] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.916012] pci 0000:00:02.1: PME# disabled
[    1.920079] pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
[    1.924030] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    1.932016] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    1.936017] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    1.940051] pci 0000:00:04.0: supports D1 D2
[    1.944054] pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
[    1.948057] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    1.952084] pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
[    1.956069] pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
[    1.960029] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    1.964018] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    1.968056] pci 0000:00:0a.0: supports D1 D2
[    1.972009] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.976012] pci 0000:00:0a.0: PME# disabled
[    1.980060] pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
[    1.984084] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.988012] pci 0000:00:0b.0: PME# disabled
[    1.992067] pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
[    1.996079] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.000014] pci 0000:00:0c.0: PME# disabled
[    2.004065] pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
[    2.008079] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.012012] pci 0000:00:0d.0: PME# disabled
[    2.016070] pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
[    2.024078] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    2.028012] pci 0000:00:0e.0: PME# disabled
[    2.032087] pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
[    2.036107] pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
[    2.040087] pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
[    2.044083] pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
[    2.048091] PCI: Fixups for bus 0000:00
[    2.052012] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
[    2.056040] PCI: Scanning bus 0000:05
[    2.060069] pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
[    2.064034] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    2.068017] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    2.072067] pci 0000:05:07.0: supports D1 D2
[    2.076012] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    2.080013] pci 0000:05:07.0: PME# disabled
[    2.084100] PCI: Fixups for bus 0000:05
[    2.088009] pci 0000:00:09.0: transparent bridge
[    2.092014] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    2.096012] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    2.100012] PCI: Bus scan for 0000:05 returning with max=05
[    2.104013] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
[    2.108041] PCI: Scanning bus 0000:04
[    2.112115] PCI: Fixups for bus 0000:04
[    2.116024] PCI: Bus scan for 0000:04 returning with max=04
[    2.120013] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
[    2.124036] PCI: Scanning bus 0000:03
[    2.128121] PCI: Fixups for bus 0000:03
[    2.132024] PCI: Bus scan for 0000:03 returning with max=03
[    2.136010] Clocksource tsc unstable (delta = 122025523 ns)
[    2.140040] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
[    2.144039] PCI: Scanning bus 0000:02
[    2.148116] PCI: Fixups for bus 0000:02
[    2.152023] PCI: Bus scan for 0000:02 returning with max=02
[    2.156013] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
[    2.160036] PCI: Scanning bus 0000:01
[    2.164051] pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
[    2.168030] pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
[    2.172017] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    2.176017] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    2.180038] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    2.184053] pci 0000:01:00.0: supports D1 D2
[    2.188066] pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
[    2.192028] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    2.196089] pci 0000:01:00.1: supports D1 D2
[    2.200148] PCI: Fixups for bus 0000:01
[    2.204015] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    2.208013] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    2.212015] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    2.216010] PCI: Bus scan for 0000:01 returning with max=01
[    2.220013] pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
[    2.224015] pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
[    2.228015] pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
[    2.232015] pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
[    2.236015] pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
[    2.240014] PCI: Bus scan for 0000:00 returning with max=05
[    2.244044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.258624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    3.321529] initcall acpi_pci_root_init+0x0/0x4f returned 0 after 1449221 usecs
[    3.324112] calling  acpi_pci_link_init+0x0/0x6a @ 1
[    3.329388] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.341148] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    3.349713] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    3.358211] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.368250] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.377527] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.387706] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.393407] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    3.402710] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    3.411412] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.421181] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.430879] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.440716] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.449647] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.460489] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.469653] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    3.481550] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    3.490120] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    3.497720] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    3.505291] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    3.512524] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    3.521217] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    3.530656] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    3.540534] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    3.549247] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    3.558839] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    3.568516] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    3.578155] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    3.587607] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    3.593557] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    3.602755] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    3.613088] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    3.620645] initcall acpi_pci_link_init+0x0/0x6a returned 0 after 285156 usecs
[    3.624102] calling  pnp_init+0x0/0x3c @ 1
[    3.628892] initcall pnp_init+0x0/0x3c returned 0 after 0 usecs
[    3.632017] calling  regulator_fixed_voltage_init+0x0/0x40 @ 1
[    3.636160] initcall regulator_fixed_voltage_init+0x0/0x40 returned 0 after 0 usecs
[    3.640016] calling  da903x_regulator_init+0x0/0x40 @ 1
[    3.644152] initcall da903x_regulator_init+0x0/0x40 returned 0 after 0 usecs
[    3.648019] calling  misc_init+0x0/0xdb @ 1
[    3.652221] initcall misc_init+0x0/0xdb returned 0 after 0 usecs
[    3.656019] calling  cn_init+0x0/0x11e @ 1
[    3.660151] initcall cn_init+0x0/0x11e returned 0 after 0 usecs
[    3.664019] calling  twl4030_init+0x0/0x40 @ 1
[    3.668154] initcall twl4030_init+0x0/0x40 returned 0 after 0 usecs
[    3.672024] calling  da903x_init+0x0/0x40 @ 1
[    3.676216] initcall da903x_init+0x0/0x40 returned 0 after 0 usecs
[    3.680020] calling  ab3100_i2c_init+0x0/0x3d @ 1
[    3.684217] initcall ab3100_i2c_init+0x0/0x3d returned 0 after 0 usecs
[    3.688020] calling  init_scsi+0x0/0xd0 @ 1
[    3.693448] SCSI subsystem initialized
[    3.696020] initcall init_scsi+0x0/0xd0 returned 0 after 3906 usecs
[    3.700014] calling  ata_init+0x0/0xb7 @ 1
[    3.704207] libata version 3.00 loaded.
[    3.708031] initcall ata_init+0x0/0xb7 returned 0 after 3906 usecs
[    3.712014] calling  phy_init+0x0/0x65 @ 1
[    3.720462] initcall phy_init+0x0/0x65 returned 0 after 3906 usecs
[    3.724018] calling  usb_init+0x0/0x1e9 @ 1
[    3.732510] usbcore: registered new interface driver usbfs
[    3.736251] usbcore: registered new interface driver hub
[    3.740216] usbcore: registered new device driver usb
[    3.744048] initcall usb_init+0x0/0x1e9 returned 0 after 15625 usecs
[    3.748013] calling  serio_init+0x0/0xc0 @ 1
[    3.752194] initcall serio_init+0x0/0xc0 returned 0 after 0 usecs
[    3.756050] calling  gameport_init+0x0/0xc0 @ 1
[    3.760226] initcall gameport_init+0x0/0xc0 returned 0 after 0 usecs
[    3.764033] calling  input_init+0x0/0x16c @ 1
[    3.768220] initcall input_init+0x0/0x16c returned 0 after 0 usecs
[    3.772021] calling  rtc_init+0x0/0xa0 @ 1
[    3.776215] initcall rtc_init+0x0/0xa0 returned 0 after 0 usecs
[    3.780030] calling  hwmon_init+0x0/0x7b @ 1
[    3.784159] initcall hwmon_init+0x0/0x7b returned 0 after 0 usecs
[    3.788019] calling  thermal_init+0x0/0x83 @ 1
[    3.792218] initcall thermal_init+0x0/0x83 returned 0 after 0 usecs
[    3.796020] calling  leds_init+0x0/0x70 @ 1
[    3.800221] initcall leds_init+0x0/0x70 returned 0 after 0 usecs
[    3.804018] calling  acpi_wmi_init+0x0/0x8c @ 1
[    3.808230] ACPI: WMI: Mapper loaded
[    3.812020] initcall acpi_wmi_init+0x0/0x8c returned 0 after 3906 usecs
[    3.816014] calling  pci_subsys_init+0x0/0x170 @ 1
[    3.820012] PCI: Using ACPI for IRQ routing
[    3.824765] initcall pci_subsys_init+0x0/0x170 returned 0 after 3906 usecs
[    3.828017] calling  proto_init+0x0/0x3b @ 1
[    3.832060] initcall proto_init+0x0/0x3b returned 0 after 0 usecs
[    3.836014] calling  net_dev_init+0x0/0x210 @ 1
[    3.844925] initcall net_dev_init+0x0/0x210 returned 0 after 3906 usecs
[    3.848063] calling  neigh_init+0x0/0x9d @ 1
[    3.852015] initcall neigh_init+0x0/0x9d returned 0 after 0 usecs
[    3.856012] calling  fib_rules_init+0x0/0xcc @ 1
[    3.860017] initcall fib_rules_init+0x0/0xcc returned 0 after 0 usecs
[    3.864015] calling  pktsched_init+0x0/0xf0 @ 1
[    3.868057] initcall pktsched_init+0x0/0xf0 returned 0 after 0 usecs
[    3.872013] calling  tc_filter_init+0x0/0x80 @ 1
[    3.876013] initcall tc_filter_init+0x0/0x80 returned 0 after 0 usecs
[    3.880014] calling  tc_action_init+0x0/0x80 @ 1
[    3.884013] initcall tc_action_init+0x0/0x80 returned 0 after 0 usecs
[    3.888013] calling  genl_init+0x0/0xff @ 1
[    3.900120] initcall genl_init+0x0/0xff returned 0 after 7812 usecs
[    3.904015] calling  cipso_v4_init+0x0/0xb3 @ 1
[    3.908059] initcall cipso_v4_init+0x0/0xb3 returned 0 after 0 usecs
[    3.912014] calling  wireless_nlevent_init+0x0/0x69 @ 1
[    3.916016] initcall wireless_nlevent_init+0x0/0x69 returned 0 after 0 usecs
[    3.920018] calling  netlbl_init+0x0/0xb5 @ 1
[    3.924012] NetLabel: Initializing
[    3.928012] NetLabel:  domain hash size = 128
[    3.932013] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.936238] NetLabel:  unlabeled traffic allowed by default
[    3.940017] initcall netlbl_init+0x0/0xb5 returned 0 after 15625 usecs
[    3.944013] calling  sysctl_init+0x0/0x73 @ 1
[    3.948017] initcall sysctl_init+0x0/0x73 returned 0 after 0 usecs
[    3.952014] calling  pci_iommu_init+0x0/0x54 @ 1
[    3.956807] PCI-DMA: Disabling AGP.
[    3.964080] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    3.968013] PCI-DMA: using GART IOMMU.
[    3.972016] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    3.980591] initcall pci_iommu_init+0x0/0x54 returned 0 after 23437 usecs
[    3.984024] calling  print_all_ICs+0x0/0xc9 @ 1
[    3.988013] 
[    3.988013] printing PIC contents
[    3.992015] ... PIC  IMR: ffff
[    3.995065] ... PIC  IRR: 0829
[    3.996015] ... PIC  ISR: 0000
[    4.000013] ... PIC ELCR: 0828
[    4.004013] printing local APIC contents on CPU#0/0:
[    4.008008] ... APIC ID:      00000000 (0)
[    4.008008] ... APIC VERSION: 00040010
[    4.008008] ... APIC TASKPRI: 00000000 (00)
[    4.008008] ... APIC ARBPRI: 000000e0 (e0)
[    4.008008] ... APIC PROCPRI: 00000000
[    4.008008] ... APIC LDR: 01000000
[    4.008008] ... APIC DFR: ffffffff
[    4.008008] ... APIC SPIV: 000001ff
[    4.008008] ... APIC ISR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000000000
[    4.008008] ... APIC TMR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000000000
[    4.008008] ... APIC IRR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000008000
[    4.008008] ... APIC ESR: 00000000
[    4.008008] ... APIC ICR: 000008fb
[    4.008008] ... APIC ICR2: 02000000
[    4.008008] ... APIC LVTT: 000200ef
[    4.008008] ... APIC LVTPC: 00010000
[    4.008008] ... APIC LVT0: 00010700
[    4.008008] ... APIC LVT1: 00000400
[    4.008008] ... APIC LVTERR: 000000fe
[    4.008008] ... APIC TMICT: 0000c454
[    4.008008] ... APIC TMCCT: 000046fa
[    4.008008] ... APIC TDCR: 00000003
[    4.008008] 
[    4.008005] printing local APIC contents on CPU#1/1:
[    4.008008] ... APIC ID:      01000000 (1)
[    4.008008] ... APIC VERSION: 00040010
[    4.008008] ... APIC TASKPRI: 00000000 (00)
[    4.008008] ... APIC ARBPRI: 000000e0 (e0)
[    4.008008] ... APIC PROCPRI: 00000000
[    4.008008] ... APIC LDR: 02000000
[    4.008008] ... APIC DFR: ffffffff
[    4.008008] ... APIC SPIV: 000001ff
[    4.008008] ... APIC ISR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000000000
[    4.008008] ... APIC TMR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000000000
[    4.008008] ... APIC IRR field:
[    4.008008] 0000000000000000000000000000000000000000000000000000000000008000
[    4.008008] ... APIC ESR: 00000000
[    4.008008] ... APIC ICR: 000008fd
[    4.008008] ... APIC ICR2: 01000000
[    4.008008] ... APIC LVTT: 000200ef
[    4.008008] ... APIC LVTPC: 00010000
[    4.008008] ... APIC LVT0: 00010700
[    4.008008] ... APIC LVT1: 00010400
[    4.008008] ... APIC LVTERR: 000000fe
[    4.008008] ... APIC TMICT: 0000c454
[    4.008008] ... APIC TMCCT: 0000bd8c
[    4.008008] ... APIC TDCR: 00000003
[    4.008008] 
[    4.117250] number of MP IRQ sources: 16.
[    4.120012] number of IO-APIC #2 registers: 24.
[    4.124014] testing the IO APIC.......................
[    4.128016] 
[    4.132012] IO APIC #2......
[    4.134888] .... register #00: 00000000
[    4.136012] .......    : physical APIC id: 00
[    4.140014] .......    : Delivery Type: 0
[    4.144012] .......    : LTS          : 0
[    4.148012] .... register #01: 00170011
[    4.152012] .......     : max redirection entries: 0017
[    4.156014] .......     : PRQ implemented: 0
[    4.160012] .......     : IO APIC version: 0011
[    4.164012] .... register #02: 00000000
[    4.168012] .......     : arbitration: 00
[    4.172013] .... IRQ redirection table:
[    4.176019]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    4.180015]  00 003 0    0    0   0   0    1    1    30
[    4.188016]  01 003 0    0    0   0   0    1    1    31
[    4.192015]  02 003 1    0    0   0   0    0    0    32
[    4.196015]  03 003 1    0    0   0   0    1    1    33
[    4.203238]  04 003 0    0    0   0   0    1    1    34
[    4.208015]  05 003 1    0    0   0   0    1    1    35
[    4.212015]  06 003 0    0    0   0   0    1    1    36
[    4.219239]  07 003 1    0    0   0   0    1    1    37
[    4.224015]  08 003 0    0    0   0   0    1    1    38
[    4.228015]  09 003 0    1    0   0   0    1    1    39
[    4.235239]  0a 003 0    0    0   0   0    1    1    3A
[    4.240015]  0b 003 1    0    0   0   0    1    1    3B
[    4.244015]  0c 003 0    0    0   0   0    1    1    3C
[    4.248015]  0d 003 0    0    0   0   0    1    1    3D
[    4.256014]  0e 003 0    0    0   0   0    1    1    3E
[    4.260015]  0f 003 0    0    0   0   0    1    1    3F
[    4.264015]  10 000 1    0    0   0   0    0    0    00
[    4.272014]  11 000 1    0    0   0   0    0    0    00
[    4.276015]  12 000 1    0    0   0   0    0    0    00
[    4.280015]  13 000 1    0    0   0   0    0    0    00
[    4.287239]  14 000 1    0    0   0   0    0    0    00
[    4.292015]  15 000 1    0    0   0   0    0    0    00
[    4.296015]  16 000 1    0    0   0   0    0    0    00
[    4.303240]  17 000 1    0    0   0   0    0    0    00
[    4.308012] IRQ to pin mappings:
[    4.312012] IRQ0 -> 0:0
[    4.314492] IRQ1 -> 0:1
[    4.316741] IRQ2 -> 0:2
[    4.319218] IRQ3 -> 0:3
[    4.320742] IRQ4 -> 0:4
[    4.324205] IRQ5 -> 0:5
[    4.326681] IRQ6 -> 0:6
[    4.328742] IRQ7 -> 0:7
[    4.331219] IRQ8 -> 0:8
[    4.332741] IRQ9 -> 0:9
[    4.336741] IRQ10 -> 0:10
[    4.339392] IRQ11 -> 0:11
[    4.340829] IRQ12 -> 0:12
[    4.344831] IRQ13 -> 0:13
[    4.347479] IRQ14 -> 0:14
[    4.348831] IRQ15 -> 0:15
[    4.352833] .................................... done.
[    4.356014] initcall print_all_ICs+0x0/0xc9 returned 0 after 359375 usecs
[    4.360015] calling  hpet_late_init+0x0/0x246 @ 1
[    4.364016] initcall hpet_late_init+0x0/0x246 returned -19 after 0 usecs
[    4.368015] calling  clocksource_done_booting+0x0/0x37 @ 1
[    4.372014] initcall clocksource_done_booting+0x0/0x37 returned 0 after 0 usecs
[    4.376014] calling  init_pipe_fs+0x0/0x74 @ 1
[    4.380289] initcall init_pipe_fs+0x0/0x74 returned 0 after 0 usecs
[    4.384024] calling  eventpoll_init+0x0/0x120 @ 1
[    4.388058] initcall eventpoll_init+0x0/0x120 returned 0 after 0 usecs
[    4.392014] calling  anon_inode_init+0x0/0x15d @ 1
[    4.396244] initcall anon_inode_init+0x0/0x15d returned 0 after 0 usecs
[    4.400018] calling  tomoyo_initerface_init+0x0/0x186 @ 1
[    4.404622] initcall tomoyo_initerface_init+0x0/0x186 returned 0 after 0 usecs
[    4.408016] calling  blk_scsi_ioctl_init+0x0/0x2ad @ 1
[    4.412015] initcall blk_scsi_ioctl_init+0x0/0x2ad returned 0 after 0 usecs
[    4.416016] calling  acpi_event_init+0x0/0xa7 @ 1
[    4.428093] initcall acpi_event_init+0x0/0xa7 returned 0 after 7812 usecs
[    4.432017] calling  pnpacpi_init+0x0/0xb5 @ 1
[    4.436013] pnp: PnP ACPI init
[    4.440128] ACPI: bus type pnp registered
[    4.466300] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    4.472663] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    4.481706] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    4.490817] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    4.506430] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    4.509311] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    4.516851] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    4.526892] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    4.542440] pnp: PnP ACPI: found 16 devices
[    4.544458] ACPI: ACPI bus type pnp unregistered
[    4.548019] initcall pnpacpi_init+0x0/0xb5 returned 0 after 109375 usecs
[    4.552015] calling  pnp_system_init+0x0/0x40 @ 1
[    4.556114] system 00:01: ioport range 0x4000-0x407f has been reserved
[    4.560033] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    4.564029] system 00:01: ioport range 0x4400-0x447f has been reserved
[    4.568029] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    4.572029] system 00:01: ioport range 0x4800-0x487f has been reserved
[    4.576033] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    4.580077] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    4.584030] system 00:02: ioport range 0x800-0x805 has been reserved
[    4.588032] system 00:02: ioport range 0x290-0x297 has been reserved
[    4.592087] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    4.596088] system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
[    4.600040] system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
[    4.604039] system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
[    4.608041] system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
[    4.612043] system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
[    4.616031] system 00:0f: iomem range 0xffff0000-0xffffffff has been reserved
[    4.620040] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    4.624039] system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
[    4.628039] system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
[    4.632034] system 00:0f: iomem range 0xfee00000-0xfeefffff has been reserved
[    4.636031] system 00:0f: iomem range 0xfefff000-0xfeffffff has been reserved
[    4.640029] system 00:0f: iomem range 0xfff80000-0xfff80fff has been reserved
[    4.644031] system 00:0f: iomem range 0xfff90000-0xfffbffff has been reserved
[    4.648034] system 00:0f: iomem range 0xfffed000-0xfffeffff has been reserved
[    4.652135] initcall pnp_system_init+0x0/0x40 returned 0 after 93750 usecs
[    4.656019] calling  chr_dev_init+0x0/0xe0 @ 1
[    4.664395] initcall chr_dev_init+0x0/0xe0 returned 0 after 3906 usecs
[    4.668051] calling  ieee1394_init+0x0/0x2c4 @ 1
[    4.672264] initcall ieee1394_init+0x0/0x2c4 returned 0 after 0 usecs
[    4.676112] calling  cpufreq_gov_userspace_init+0x0/0x40 @ 1
[    4.680039] initcall cpufreq_gov_userspace_init+0x0/0x40 returned 0 after 0 usecs
[    4.684015] calling  init_acpi_pm_clocksource+0x0/0x12f @ 1
[    4.696449] initcall init_acpi_pm_clocksource+0x0/0x12f returned 0 after 7812 usecs
[    4.700066] Switched to high resolution mode on CPU 0
[    4.700498] Switched to high resolution mode on CPU 1
[    4.710178] calling  ssb_modinit+0x0/0x9f @ 1
[    4.715004] initcall ssb_modinit+0x0/0x9f returned 0 after 440 usecs
[    4.721413] calling  pcibios_assign_resources+0x0/0x9c @ 1
[    4.727230] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    4.733166] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    4.738501] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    4.744608] pci 0000:00:09.0:   PREFETCH window: disabled
[    4.750023] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    4.755959] pci 0000:00:0b.0:   IO window: disabled
[    4.760859] pci 0000:00:0b.0:   MEM window: disabled
[    4.765840] pci 0000:00:0b.0:   PREFETCH window: disabled
[    4.771258] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    4.777190] pci 0000:00:0c.0:   IO window: disabled
[    4.782082] pci 0000:00:0c.0:   MEM window: disabled
[    4.787065] pci 0000:00:0c.0:   PREFETCH window: disabled
[    4.792482] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    4.798415] pci 0000:00:0d.0:   IO window: disabled
[    4.803308] pci 0000:00:0d.0:   MEM window: disabled
[    4.808289] pci 0000:00:0d.0:   PREFETCH window: disabled
[    4.813722] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
[    4.823779] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    4.829713] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    4.835045] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    4.841156] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    4.848751] pci 0000:00:09.0: setting latency timer to 64
[    4.854170] pci 0000:00:0b.0: setting latency timer to 64
[    4.859588] pci 0000:00:0c.0: setting latency timer to 64
[    4.865012] pci 0000:00:0d.0: setting latency timer to 64
[    4.870436] pci 0000:00:0e.0: setting latency timer to 64
[    4.875848] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    4.881347] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    4.888230] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    4.893906] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    4.900267] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    4.905764] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    4.912653] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    4.918328] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    4.924691] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    4.931409] initcall pcibios_assign_resources+0x0/0x9c returned 0 after 199705 usecs
[    4.939165] calling  sysctl_core_init+0x0/0x65 @ 1
[    4.944136] initcall sysctl_core_init+0x0/0x65 returned 0 after 153 usecs
[    4.950933] calling  inet_init+0x0/0x26f @ 1
[    4.955285] NET: Registered protocol family 2
[    4.960309] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    4.969610] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    4.979395] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    4.995176] TCP: Hash tables configured (established 131072 bind 65536)
[    5.001872] TCP reno registered
[    5.005663] initcall inet_init+0x0/0x26f returned 0 after 49261 usecs
[    5.012139] calling  af_unix_init+0x0/0x83 @ 1
[    5.016617] NET: Registered protocol family 1
[    5.021103] initcall af_unix_init+0x0/0x83 returned 0 after 4394 usecs
[    5.027645] calling  populate_rootfs+0x0/0x14d @ 1
[    5.033080] initcall populate_rootfs+0x0/0x14d returned 0 after 612 usecs
[    5.039966] calling  calgary_fixup_tce_spaces+0x0/0x129 @ 1
[    5.045560] initcall calgary_fixup_tce_spaces+0x0/0x129 returned -19 after 1 usecs
[    5.053140] calling  i8259A_init_sysfs+0x0/0x50 @ 1
[    5.058736] initcall i8259A_init_sysfs+0x0/0x50 returned 0 after 681 usecs
[    5.065623] calling  vsyscall_init+0x0/0x60 @ 1
[    5.070209] initcall vsyscall_init+0x0/0x60 returned 0 after 38 usecs
[    5.076659] calling  sbf_init+0x0/0x140 @ 1
[    5.080859] initcall sbf_init+0x0/0x140 returned 0 after 1 usecs
[    5.086879] calling  i8237A_init_sysfs+0x0/0x4d @ 1
[    5.092496] initcall i8237A_init_sysfs+0x0/0x4d returned 0 after 702 usecs
[    5.099390] calling  add_rtc_cmos+0x0/0xfe @ 1
[    5.103854] initcall add_rtc_cmos+0x0/0xfe returned 0 after 4 usecs
[    5.110132] calling  cache_sysfs_init+0x0/0x80 @ 1
[    5.118566] initcall cache_sysfs_init+0x0/0x80 returned 0 after 3535 usecs
[    5.125468] calling  ioapic_init_sysfs+0x0/0xf3 @ 1
[    5.131067] initcall ioapic_init_sysfs+0x0/0xf3 returned 0 after 687 usecs
[    5.138007] calling  uv_ptc_init+0x0/0x7a @ 1
[    5.142383] initcall uv_ptc_init+0x0/0x7a returned 0 after 1 usecs
[    5.148576] calling  uv_bau_init+0x0/0x2af @ 1
[    5.153040] initcall uv_bau_init+0x0/0x2af returned 0 after 1 usecs
[    5.159324] calling  sgi_uv_sysfs_init+0x0/0xdb @ 1
[    5.164225] initcall sgi_uv_sysfs_init+0x0/0xdb returned -19 after 1 usecs
[    5.171111] calling  audit_classes_init+0x0/0xe0 @ 1
[    5.176166] initcall audit_classes_init+0x0/0xe0 returned 0 after 69 usecs
[    5.183062] calling  start_pageattr_test+0x0/0x80 @ 1
[    5.188263] initcall start_pageattr_test+0x0/0x80 returned 0 after 127 usecs
[    5.195338] calling  init+0x0/0x40 @ 1
[    5.199658] initcall init+0x0/0x40 returned 0 after 540 usecs
[    5.205430] calling  crc32c_intel_mod_init+0x0/0x50 @ 1
[    5.210668] initcall crc32c_intel_mod_init+0x0/0x50 returned -19 after 1 usecs
[    5.217900] calling  init_vdso_vars+0x0/0x25b @ 1
[    5.222654] initcall init_vdso_vars+0x0/0x25b returned 0 after 34 usecs
[    5.229280] calling  ia32_binfmt_init+0x0/0x3c @ 1
[    5.234121] initcall ia32_binfmt_init+0x0/0x3c returned 0 after 36 usecs
[    5.240836] calling  sysenter_setup+0x0/0xeb @ 1
[    5.245477] initcall sysenter_setup+0x0/0xeb returned 0 after 6 usecs
[    5.251927] calling  init_aout_binfmt+0x0/0x40 @ 1
[    5.256744] initcall init_aout_binfmt+0x0/0x40 returned 0 after 3 usecs
[    5.263366] calling  init_sched_debug_procfs+0x0/0x53 @ 1
[    5.268808] initcall init_sched_debug_procfs+0x0/0x53 returned 0 after 31 usecs
[    5.276129] calling  proc_schedstat_init+0x0/0x50 @ 1
[    5.281222] initcall proc_schedstat_init+0x0/0x50 returned 0 after 25 usecs
[    5.288198] calling  proc_execdomains_init+0x0/0x50 @ 1
[    5.293468] initcall proc_execdomains_init+0x0/0x50 returned 0 after 27 usecs
[    5.300616] calling  ioresources_init+0x0/0x65 @ 1
[    5.305476] initcall ioresources_init+0x0/0x65 returned 0 after 45 usecs
[    5.312187] calling  uid_cache_init+0x0/0xb5 @ 1
[    5.316851] initcall uid_cache_init+0x0/0xb5 returned 0 after 25 usecs
[    5.323395] calling  init_posix_timers+0x0/0x115 @ 1
[    5.328418] initcall init_posix_timers+0x0/0x115 returned 0 after 39 usecs
[    5.335303] calling  init_posix_cpu_timers+0x0/0x11b @ 1
[    5.340633] initcall init_posix_cpu_timers+0x0/0x11b returned 0 after 1 usecs
[    5.347779] calling  nsproxy_cache_init+0x0/0x63 @ 1
[    5.352771] initcall nsproxy_cache_init+0x0/0x63 returned 0 after 12 usecs
[    5.359653] calling  timekeeping_init_device+0x0/0x4d @ 1
[    5.365760] initcall timekeeping_init_device+0x0/0x4d returned 0 after 681 usecs
[    5.373173] calling  init_clocksource_sysfs+0x0/0x7b @ 1
[    5.379203] initcall init_clocksource_sysfs+0x0/0x7b returned 0 after 689 usecs
[    5.386529] calling  init_timer_list_procfs+0x0/0x53 @ 1
[    5.391887] initcall init_timer_list_procfs+0x0/0x53 returned 0 after 25 usecs
[    5.399121] calling  lockdep_proc_init+0x0/0xa5 @ 1
[    5.404111] initcall lockdep_proc_init+0x0/0xa5 returned 0 after 84 usecs
[    5.410908] calling  futex_init+0x0/0xfb @ 1
[    5.415208] initcall futex_init+0x0/0xfb returned 0 after 7 usecs
[    5.421318] calling  init_rttest+0x0/0x1a0 @ 1
[    5.430074] Initializing RT-Tester: OK
[    5.433872] initcall init_rttest+0x0/0x1a0 returned 0 after 7900 usecs
[    5.440410] calling  proc_dma_init+0x0/0x50 @ 1
[    5.444990] initcall proc_dma_init+0x0/0x50 returned 0 after 28 usecs
[    5.451446] calling  proc_modules_init+0x0/0x50 @ 1
[    5.456365] initcall proc_modules_init+0x0/0x50 returned 0 after 23 usecs
[    5.463173] calling  kallsyms_init+0x0/0x50 @ 1
[    5.467747] initcall kallsyms_init+0x0/0x50 returned 0 after 24 usecs
[    5.474222] calling  crash_save_vmcoreinfo_init+0x0/0x49c @ 1
[    5.480023] initcall crash_save_vmcoreinfo_init+0x0/0x49c returned 0 after 40 usecs
[    5.487686] calling  crash_notes_memory_init+0x0/0x61 @ 1
[    5.493115] initcall crash_notes_memory_init+0x0/0x61 returned 0 after 9 usecs
[    5.500349] calling  backtrace_regression_test+0x0/0x120 @ 1
[    5.506025] ====[ backtrace testing ]===========
[    5.510662] Testing a backtrace from process context.
[    5.515731] The following trace is a kernel self test and not a bug!
[    5.522093] Pid: 1, comm: swapper Tainted: G        W  2.6.31-rc5-tip #3776
[    5.529070] Call Trace:
[    5.531524]  [<ffffffff810ca575>] backtrace_regression_test+0x45/0x120
[    5.538066]  [<ffffffff810ca530>] ? backtrace_regression_test+0x0/0x120
[    5.544699]  [<ffffffff8184ef3b>] ? printk+0x4b/0x65
[    5.549681]  [<ffffffff810ab512>] ? ktime_get+0x72/0x100
[    5.555009]  [<ffffffff810ca530>] ? backtrace_regression_test+0x0/0x120
[    5.561641]  [<ffffffff8100907b>] do_one_initcall+0x4b/0x1a0
[    5.567317]  [<ffffffff81c73a6d>] do_basic_setup+0x70/0xa0
[    5.572820]  [<ffffffff81c73b2d>] kernel_init+0x90/0xec
[    5.578065]  [<ffffffff810305ca>] child_rip+0xa/0x20
[    5.583046]  [<ffffffff8102ff50>] ? restore_args+0x0/0x30
[    5.588462]  [<ffffffff81c73a9d>] ? kernel_init+0x0/0xec
[    5.593793]  [<ffffffff810305c0>] ? child_rip+0x0/0x20
[    5.598947] Testing a backtrace from irq context.
[    5.603661] The following trace is a kernel self test and not a bug!
[    5.610035] Pid: 4, comm: ksoftirqd/0 Tainted: G        W  2.6.31-rc5-tip #3776
[    5.617354] Call Trace:
[    5.619799]  <IRQ>  [<ffffffff810ca4fc>] backtrace_test_irq_callback+0x1c/0x50
[    5.627061]  [<ffffffff810890d5>] tasklet_action+0x95/0x140
[    5.632641]  [<ffffffff81089a32>] __do_softirq+0x112/0x210
[    5.638138]  [<ffffffff810306cc>] call_softirq+0x1c/0x30
[    5.643456]  <EOI>  [<ffffffff810325a5>] do_softirq+0xb5/0x100
[    5.649333]  [<ffffffff81089bd0>] ksoftirqd+0xa0/0x1a0
[    5.654484]  [<ffffffff8106ccaa>] ? complete+0x5a/0x80
[    5.659629]  [<ffffffff81089b30>] ? ksoftirqd+0x0/0x1a0
[    5.664866]  [<ffffffff810a0176>] kthread+0xb6/0xd0
[    5.669754]  [<ffffffff810305ca>] child_rip+0xa/0x20
[    5.674729]  [<ffffffff8102ff50>] ? restore_args+0x0/0x30
[    5.680135]  [<ffffffff810a00c0>] ? kthread+0x0/0xd0
[    5.685110]  [<ffffffff810305c0>] ? child_rip+0x0/0x20
[    5.690298] Testing a saved backtrace.
[    5.694116] The following trace is a kernel self test and not a bug!
[    5.700537]  [<ffffffff8103d9c9>] save_stack_trace+0x39/0x70
[    5.706320]  [<ffffffff810ca61a>] backtrace_regression_test+0xea/0x120
[    5.712924]  [<ffffffff8100907b>] do_one_initcall+0x4b/0x1a0
[    5.718714]  [<ffffffff81c73a6d>] do_basic_setup+0x70/0xa0
[    5.724276]  [<ffffffff81c73b2d>] kernel_init+0x90/0xec
[    5.729614]  [<ffffffff810305ca>] child_rip+0xa/0x20
[    5.734651]  [<ffffffffffffffff>] 0xffffffffffffffff
[    5.739683] ====[ end of backtrace testing ]====
[    5.744351] initcall backtrace_regression_test+0x0/0x120 returned 0 after 232737 usecs
[    5.752315] calling  ikconfig_init+0x0/0x60 @ 1
[    5.756950] initcall ikconfig_init+0x0/0x60 returned 0 after 48 usecs
[    5.763406] calling  audit_init+0x0/0x18f @ 1
[    5.767773] audit: initializing netlink socket (disabled)
[    5.773292] type=2000 audit(1250131255.773:1): initialized
[    5.778802] initcall audit_init+0x0/0x18f returned 0 after 10769 usecs
[    5.785339] calling  init_kprobes+0x0/0x1c7 @ 1
[    5.800667] initcall init_kprobes+0x0/0x1c7 returned 0 after 10529 usecs
[    5.807380] calling  hung_task_init+0x0/0x7f @ 1
[    5.812182] initcall hung_task_init+0x0/0x7f returned 0 after 159 usecs
[    5.818814] calling  rcu_torture_init+0x0/0x77e @ 1
[    5.823749] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
[    5.838589] initcall rcu_torture_init+0x0/0x77e returned 0 after 14531 usecs
[    5.845656] calling  rcuclassic_trace_init+0x0/0x17f @ 1
[    5.851156] initcall rcuclassic_trace_init+0x0/0x17f returned 0 after 168 usecs
[    5.858471] calling  utsname_sysctl_init+0x0/0x40 @ 1
[    5.863615] initcall utsname_sysctl_init+0x0/0x40 returned 0 after 81 usecs
[    5.870587] calling  init_markers+0x0/0x40 @ 1
[    5.875041] initcall init_markers+0x0/0x40 returned 0 after 1 usecs
[    5.881313] calling  init_tracepoints+0x0/0x40 @ 1
[    5.886118] initcall init_tracepoints+0x0/0x40 returned 0 after 1 usecs
[    5.892736] calling  init_lstats_procfs+0x0/0x50 @ 1
[    5.897751] initcall init_lstats_procfs+0x0/0x50 returned 0 after 36 usecs
[    5.904638] calling  init_per_zone_wmark_min+0x0/0x9f @ 1
[    5.910127] initcall init_per_zone_wmark_min+0x0/0x9f returned 0 after 78 usecs
[    5.917445] calling  pdflush_init+0x0/0x4d @ 1
[    5.922128] initcall pdflush_init+0x0/0x4d returned 0 after 220 usecs
[    5.928586] calling  kswapd_init+0x0/0x93 @ 1
[    5.933124] initcall kswapd_init+0x0/0x93 returned 0 after 167 usecs
[    5.939489] calling  init_tmpfs+0x0/0x119 @ 1
[    5.944256] initcall init_tmpfs+0x0/0x119 returned 0 after 383 usecs
[    5.950628] calling  setup_vmstat+0x0/0xf5 @ 1
[    5.955191] initcall setup_vmstat+0x0/0xf5 returned 0 after 102 usecs
[    5.961637] calling  mm_sysfs_init+0x0/0x50 @ 1
[    5.966222] initcall mm_sysfs_init+0x0/0x50 returned 0 after 42 usecs
[    5.972669] calling  proc_vmalloc_init+0x0/0x50 @ 1
[    5.977585] initcall proc_vmalloc_init+0x0/0x50 returned 0 after 24 usecs
[    5.984377] calling  hugetlb_init+0x0/0x34c @ 1
[    5.988923] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.995417] initcall hugetlb_init+0x0/0x34c returned 0 after 6343 usecs
[    6.002048] calling  slab_proc_init+0x0/0x50 @ 1
[    6.006707] initcall slab_proc_init+0x0/0x50 returned 0 after 26 usecs
[    6.013247] calling  slab_sysfs_init+0x0/0x123 @ 1
[    6.073549] initcall slab_sysfs_init+0x0/0x123 returned 0 after 54192 usecs
[    6.080663] calling  fasync_init+0x0/0x57 @ 1
[    6.085071] initcall fasync_init+0x0/0x57 returned 0 after 33 usecs
[    6.091352] calling  proc_filesystems_init+0x0/0x4d @ 1
[    6.096623] initcall proc_filesystems_init+0x0/0x4d returned 0 after 34 usecs
[    6.103769] calling  dnotify_init+0x0/0xa9 @ 1
[    6.109215] initcall dnotify_init+0x0/0xa9 returned 0 after 964 usecs
[    6.115727] calling  inotify_setup+0x0/0x37 @ 1
[    6.120275] initcall inotify_setup+0x0/0x37 returned 0 after 1 usecs
[    6.126640] calling  inotify_user_setup+0x0/0xed @ 1
[    6.131981] initcall inotify_user_setup+0x0/0xed returned 0 after 353 usecs
[    6.138949] calling  proc_locks_init+0x0/0x4d @ 1
[    6.143690] initcall proc_locks_init+0x0/0x4d returned 0 after 25 usecs
[    6.150311] calling  init_sys32_ioctl+0x0/0xb5 @ 1
[    6.155131] initcall init_sys32_ioctl+0x0/0xb5 returned 0 after 17 usecs
[    6.161837] calling  init_mbcache+0x0/0x40 @ 1
[    6.166298] initcall init_mbcache+0x0/0x40 returned 0 after 4 usecs
[    6.172575] calling  proc_cmdline_init+0x0/0x50 @ 1
[    6.177489] initcall proc_cmdline_init+0x0/0x50 returned 0 after 24 usecs
[    6.184283] calling  proc_cpuinfo_init+0x0/0x50 @ 1
[    6.189197] initcall proc_cpuinfo_init+0x0/0x50 returned 0 after 24 usecs
[    6.195992] calling  proc_devices_init+0x0/0x50 @ 1
[    6.200905] initcall proc_devices_init+0x0/0x50 returned 0 after 24 usecs
[    6.207707] calling  proc_interrupts_init+0x0/0x50 @ 1
[    6.212883] initcall proc_interrupts_init+0x0/0x50 returned 0 after 23 usecs
[    6.219938] calling  proc_loadavg_init+0x0/0x50 @ 1
[    6.224851] initcall proc_loadavg_init+0x0/0x50 returned 0 after 23 usecs
[    6.231647] calling  proc_meminfo_init+0x0/0x50 @ 1
[    6.236560] initcall proc_meminfo_init+0x0/0x50 returned 0 after 23 usecs
[    6.243355] calling  proc_stat_init+0x0/0x50 @ 1
[    6.248024] initcall proc_stat_init+0x0/0x50 returned 0 after 37 usecs
[    6.254561] calling  proc_uptime_init+0x0/0x50 @ 1
[    6.259391] initcall proc_uptime_init+0x0/0x50 returned 0 after 25 usecs
[    6.266097] calling  proc_version_init+0x0/0x50 @ 1
[    6.271011] initcall proc_version_init+0x0/0x50 returned 0 after 23 usecs
[    6.277806] calling  proc_softirqs_init+0x0/0x4d @ 1
[    6.282807] initcall proc_softirqs_init+0x0/0x4d returned 0 after 23 usecs
[    6.289688] calling  proc_kmsg_init+0x0/0x50 @ 1
[    6.294342] initcall proc_kmsg_init+0x0/0x50 returned 0 after 24 usecs
[    6.300876] calling  proc_page_init+0x0/0x70 @ 1
[    6.305551] initcall proc_page_init+0x0/0x70 returned 0 after 44 usecs
[    6.312091] calling  configfs_init+0x0/0xf9 @ 1
[    6.316707] initcall configfs_init+0x0/0xf9 returned 0 after 71 usecs
[    6.323160] calling  init_devpts_fs+0x0/0x7a @ 1
[    6.328185] initcall init_devpts_fs+0x0/0x7a returned 0 after 388 usecs
[    6.334807] calling  init_ext3_fs+0x0/0x95 @ 1
[    6.341407] initcall init_ext3_fs+0x0/0x95 returned 0 after 2091 usecs
[    6.347971] calling  init_ext2_fs+0x0/0x95 @ 1
[    6.353315] initcall init_ext2_fs+0x0/0x95 returned 0 after 867 usecs
[    6.359792] calling  journal_init+0x0/0xd3 @ 1
[    6.369096] initcall journal_init+0x0/0xd3 returned 0 after 4731 usecs
[    6.375655] calling  init_ramfs_fs+0x0/0x3d @ 1
[    6.380199] initcall init_ramfs_fs+0x0/0x3d returned 0 after 3 usecs
[    6.386562] calling  init_hugetlbfs_fs+0x0/0xd0 @ 1
[    6.392660] initcall init_hugetlbfs_fs+0x0/0xd0 returned 0 after 1177 usecs
[    6.399645] calling  init_coda+0x0/0x190 @ 1
[    6.407907] initcall init_coda+0x0/0x190 returned 0 after 3887 usecs
[    6.414287] calling  init_fat_fs+0x0/0x80 @ 1
[    6.420352] initcall init_fat_fs+0x0/0x80 returned 0 after 1654 usecs
[    6.426810] calling  init_vfat_fs+0x0/0x40 @ 1
[    6.431272] initcall init_vfat_fs+0x0/0x40 returned 0 after 3 usecs
[    6.437550] calling  init_msdos_fs+0x0/0x3d @ 1
[    6.442096] initcall init_msdos_fs+0x0/0x3d returned 0 after 3 usecs
[    6.448461] calling  init_hfs_fs+0x0/0x83 @ 1
[    6.454090] initcall init_hfs_fs+0x0/0x83 returned 0 after 1229 usecs
[    6.460550] calling  vxfs_init+0x0/0x90 @ 1
[    6.466124] initcall vxfs_init+0x0/0x90 returned 0 after 1339 usecs
[    6.472414] calling  init_nfs_fs+0x0/0x170 @ 1
[    6.480301] initcall init_nfs_fs+0x0/0x170 returned 0 after 3345 usecs
[    6.486958] calling  init_nlm+0x0/0x51 @ 1
[    6.491164] initcall init_nlm+0x0/0x51 returned 0 after 93 usecs
[    6.497177] calling  init_nls_cp855+0x0/0x40 @ 1
[    6.501851] initcall init_nls_cp855+0x0/0x40 returned 0 after 45 usecs
[    6.508391] calling  init_nls_cp862+0x0/0x40 @ 1
[    6.513030] initcall init_nls_cp862+0x0/0x40 returned 0 after 2 usecs
[    6.519475] calling  init_nls_cp863+0x0/0x40 @ 1
[    6.524108] initcall init_nls_cp863+0x0/0x40 returned 0 after 2 usecs
[    6.530560] calling  init_nls_cp866+0x0/0x40 @ 1
[    6.535193] initcall init_nls_cp866+0x0/0x40 returned 0 after 2 usecs
[    6.541644] calling  init_nls_cp936+0x0/0x40 @ 1
[    6.546276] initcall init_nls_cp936+0x0/0x40 returned 0 after 1 usecs
[    6.552721] calling  init_nls_iso8859_1+0x0/0x40 @ 1
[    6.557700] initcall init_nls_iso8859_1+0x0/0x40 returned 0 after 2 usecs
[    6.564499] calling  init_nls_iso8859_2+0x0/0x40 @ 1
[    6.569478] initcall init_nls_iso8859_2+0x0/0x40 returned 0 after 2 usecs
[    6.576276] calling  init_nls_koi8_r+0x0/0x40 @ 1
[    6.580994] initcall init_nls_koi8_r+0x0/0x40 returned 0 after 2 usecs
[    6.587535] calling  init_nls_koi8_u+0x0/0x40 @ 1
[    6.592253] initcall init_nls_koi8_u+0x0/0x40 returned 0 after 2 usecs
[    6.598784] calling  init_nls_koi8_ru+0x0/0x75 @ 1
[    6.603590] initcall init_nls_koi8_ru+0x0/0x75 returned 0 after 3 usecs
[    6.610215] calling  init_ncp_fs+0x0/0x85 @ 1
[    6.615438] initcall init_ncp_fs+0x0/0x85 returned 0 after 832 usecs
[    6.621852] calling  init_hpfs_fs+0x0/0x85 @ 1
[    6.627143] initcall init_hpfs_fs+0x0/0x85 returned 0 after 810 usecs
[    6.633652] calling  init_ntfs_fs+0x0/0x26f @ 1
[    6.638191] NTFS driver 2.1.29 [Flags: R/O DEBUG].
[    6.644886] initcall init_ntfs_fs+0x0/0x26f returned 0 after 6536 usecs
[    6.651544] calling  init_romfs_fs+0x0/0xad @ 1
[    6.656087] ROMFS MTD (C) 2007 Red Hat, Inc.
[    6.661222] initcall init_romfs_fs+0x0/0xad returned 0 after 5011 usecs
[    6.667855] calling  init_qnx4_fs+0x0/0x93 @ 1
[    6.673179] QNX4 filesystem 0.2.3 registered.
[    6.677560] initcall init_qnx4_fs+0x0/0x93 returned 0 after 5122 usecs
[    6.684099] calling  init_autofs4_fs+0x0/0x4c @ 1
[    6.689658] initcall init_autofs4_fs+0x0/0x4c returned 0 after 821 usecs
[    6.696380] calling  init_adfs_fs+0x0/0x86 @ 1
[    6.701955] initcall init_adfs_fs+0x0/0x86 returned 0 after 1093 usecs
[    6.708496] calling  fuse_init+0x0/0x180 @ 1
[    6.712777] fuse init (API version 7.12)
[    6.719078] initcall fuse_init+0x0/0x180 returned 0 after 6150 usecs
[    6.725455] calling  init_btrfs_fs+0x0/0xdc @ 1
[    6.734251] Btrfs loaded
[    6.736822] initcall init_btrfs_fs+0x0/0xdc returned 0 after 6658 usecs
[    6.743449] calling  init_mqueue_fs+0x0/0xf5 @ 1
[    6.749354] initcall init_mqueue_fs+0x0/0xf5 returned 0 after 1245 usecs
[    6.756139] calling  key_proc_init+0x0/0x90 @ 1
[    6.760739] initcall key_proc_init+0x0/0x90 returned 0 after 59 usecs
[    6.767187] calling  crypto_wq_init+0x0/0x60 @ 1
[    6.772082] initcall crypto_wq_init+0x0/0x60 returned 0 after 259 usecs
[    6.778733] calling  crypto_algapi_init+0x0/0x35 @ 1
[    6.783775] initcall crypto_algapi_init+0x0/0x35 returned 0 after 66 usecs
[    6.790657] calling  chainiv_module_init+0x0/0x40 @ 1
[    6.795756] initcall chainiv_module_init+0x0/0x40 returned 0 after 36 usecs
[    6.802728] calling  eseqiv_module_init+0x0/0x40 @ 1
[    6.807710] initcall eseqiv_module_init+0x0/0x40 returned 0 after 6 usecs
[    6.814508] calling  seqiv_module_init+0x0/0x40 @ 1
[    6.819428] initcall seqiv_module_init+0x0/0x40 returned 0 after 22 usecs
[    6.826227] calling  hmac_module_init+0x0/0x40 @ 1
[    6.831041] initcall hmac_module_init+0x0/0x40 returned 0 after 5 usecs
[    6.837665] calling  crypto_xcbc_module_init+0x0/0x3d @ 1
[    6.843081] initcall crypto_xcbc_module_init+0x0/0x3d returned 0 after 6 usecs
[    6.850310] calling  crypto_null_mod_init+0x0/0xa3 @ 1
[    6.855622] alg: No test for cipher_null (cipher_null-generic)
[    6.862720] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    6.868868] alg: No test for digest_null (digest_null-generic)
[    6.876435] alg: No test for compress_null (compress_null-generic)
[    6.882689] initcall crypto_null_mod_init+0x0/0xa3 returned 0 after 26592 usecs
[    6.890015] calling  md4_mod_init+0x0/0x40 @ 1
[    6.894707] initcall md4_mod_init+0x0/0x40 returned 0 after 223 usecs
[    6.901176] calling  md5_mod_init+0x0/0x40 @ 1
[    6.906081] initcall md5_mod_init+0x0/0x40 returned 0 after 439 usecs
[    6.912537] calling  rmd256_mod_init+0x0/0x40 @ 1
[    6.917974] initcall rmd256_mod_init+0x0/0x40 returned 0 after 704 usecs
[    6.924699] calling  sha1_generic_mod_init+0x0/0x3d @ 1
[    6.930158] initcall sha1_generic_mod_init+0x0/0x3d returned 0 after 211 usecs
[    6.937396] calling  sha256_generic_mod_init+0x0/0x73 @ 1
[    6.943288] initcall sha256_generic_mod_init+0x0/0x73 returned 0 after 467 usecs
[    6.950707] calling  wp512_mod_init+0x0/0xa0 @ 1
[    6.956107] initcall wp512_mod_init+0x0/0xa0 returned 0 after 745 usecs
[    6.962761] calling  crypto_cbc_module_init+0x0/0x40 @ 1
[    6.968088] initcall crypto_cbc_module_init+0x0/0x40 returned 0 after 5 usecs
[    6.975231] calling  crypto_module_init+0x0/0x3d @ 1
[    6.980211] initcall crypto_module_init+0x0/0x3d returned 0 after 5 usecs
[    6.987014] calling  crypto_ctr_module_init+0x0/0x67 @ 1
[    6.992350] initcall crypto_ctr_module_init+0x0/0x67 returned 0 after 9 usecs
[    6.999499] calling  crypto_ccm_module_init+0x0/0x85 @ 1
[    7.004834] initcall crypto_ccm_module_init+0x0/0x85 returned 0 after 13 usecs
[    7.012065] calling  des_generic_mod_init+0x0/0x67 @ 1
[    7.017744] initcall des_generic_mod_init+0x0/0x67 returned 0 after 517 usecs
[    7.024904] calling  cast5_mod_init+0x0/0x40 @ 1
[    7.029815] initcall cast5_mod_init+0x0/0x40 returned 0 after 270 usecs
[    7.036450] calling  arc4_init+0x0/0x40 @ 1
[    7.040884] initcall arc4_init+0x0/0x40 returned 0 after 229 usecs
[    7.047090] calling  deflate_mod_init+0x0/0x40 @ 1
[    7.052503] initcall deflate_mod_init+0x0/0x40 returned 0 after 590 usecs
[    7.059300] calling  zlib_mod_init+0x0/0x40 @ 1
[    7.064532] initcall zlib_mod_init+0x0/0x40 returned 0 after 665 usecs
[    7.071067] calling  crc32c_mod_init+0x0/0x40 @ 1
[    7.076197] initcall crc32c_mod_init+0x0/0x40 returned 0 after 404 usecs
[    7.082909] calling  crypto_authenc_module_init+0x0/0x40 @ 1
[    7.088590] initcall crypto_authenc_module_init+0x0/0x40 returned 0 after 6 usecs
[    7.096079] calling  krng_mod_init+0x0/0x40 @ 1
[    7.100762] alg: No test for stdrng (krng)
[    7.106570] initcall krng_mod_init+0x0/0x40 returned 0 after 5807 usecs
[    7.113195] calling  proc_genhd_init+0x0/0x65 @ 1
[    7.117973] initcall proc_genhd_init+0x0/0x65 returned 0 after 58 usecs
[    7.124593] calling  bsg_init+0x0/0x161 @ 1
[    7.131732] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    7.139141] initcall bsg_init+0x0/0x161 returned 0 after 10110 usecs
[    7.145503] calling  noop_init+0x0/0x40 @ 1
[    7.149740] io scheduler noop registered
[    7.153677] initcall noop_init+0x0/0x40 returned 0 after 3883 usecs
[    7.159952] calling  as_init+0x0/0x3d @ 1
[    7.163975] io scheduler anticipatory registered (default)
[    7.169471] initcall as_init+0x0/0x3d returned 0 after 5366 usecs
[    7.175579] calling  libcrc32c_mod_init+0x0/0x5b @ 1
[    7.180569] initcall libcrc32c_mod_init+0x0/0x5b returned 0 after 14 usecs
[    7.187452] calling  init_kmp+0x0/0x40 @ 1
[    7.191582] initcall init_kmp+0x0/0x40 returned 0 after 20 usecs
[    7.197599] calling  init_bm+0x0/0x40 @ 1
[    7.201626] initcall init_bm+0x0/0x40 returned 0 after 2 usecs
[    7.207471] calling  init_fsm+0x0/0x3d @ 1
[    7.211582] initcall init_fsm+0x0/0x3d returned 0 after 2 usecs
[    7.217517] calling  percpu_counter_startup+0x0/0x63 @ 1
[    7.222841] initcall percpu_counter_startup+0x0/0x63 returned 0 after 1 usecs
[    7.229989] calling  pci_init+0x0/0x5d @ 1
[    7.234411] initcall pci_init+0x0/0x5d returned 0 after 306 usecs
[    7.240518] calling  pci_proc_init+0x0/0x93 @ 1
[    7.246026] initcall pci_proc_init+0x0/0x93 returned 0 after 938 usecs
[    7.252566] calling  pcie_portdrv_init+0x0/0x80 @ 1
[    7.259158]   alloc irq_desc for 24 on node 0
[    7.262935]   alloc kstat_irqs on node 0
[    7.267572] pcieport-driver 0000:00:0b.0: irq 24 for MSI/MSI-X
[    7.273427] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    7.282797]   alloc irq_desc for 25 on node 0
[    7.286352]   alloc kstat_irqs on node 0
[    7.291259] pcieport-driver 0000:00:0c.0: irq 25 for MSI/MSI-X
[    7.297113] pcieport-driver 0000:00:0c.0: setting latency timer to 64
[    7.306028]   alloc irq_desc for 26 on node 0
[    7.309901]   alloc kstat_irqs on node 0
[    7.314446] pcieport-driver 0000:00:0d.0: irq 26 for MSI/MSI-X
[    7.320295] pcieport-driver 0000:00:0d.0: setting latency timer to 64
[    7.330856]   alloc irq_desc for 27 on node 0
[    7.334728]   alloc kstat_irqs on node 0
[    7.339241] pcieport-driver 0000:00:0e.0: irq 27 for MSI/MSI-X
[    7.345088] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    7.354580] initcall pcie_portdrv_init+0x0/0x80 returned 0 after 94845 usecs
[    7.361693] calling  aer_service_init+0x0/0x50 @ 1
[    7.367298] initcall aer_service_init+0x0/0x50 returned 0 after 763 usecs
[    7.374163] calling  genericbl_init+0x0/0x40 @ 1
[    7.379815] initcall genericbl_init+0x0/0x40 returned 0 after 944 usecs
[    7.386467] calling  mbp_init+0x0/0x127 @ 1
[    7.390673] initcall mbp_init+0x0/0x127 returned -19 after 3 usecs
[    7.396864] calling  display_class_init+0x0/0xa9 @ 1
[    7.402974] initcall display_class_init+0x0/0xa9 returned 0 after 1107 usecs
[    7.410088] calling  acpi_reserve_resources+0x0/0x112 @ 1
[    7.415547] initcall acpi_reserve_resources+0x0/0x112 returned 0 after 47 usecs
[    7.422863] calling  irqrouter_init_sysfs+0x0/0x5f @ 1
[    7.430576] initcall irqrouter_init_sysfs+0x0/0x5f returned 0 after 2500 usecs
[    7.437823] calling  acpi_button_init+0x0/0x7d @ 1
[    7.444527] input: Power Button as /class/input/input0
[    7.449753] ACPI: Power Button [PWRF]
[    7.455165] input: Power Button as /class/input/input1
[    7.460336] ACPI: Power Button [PWRB]
[    7.465870] initcall acpi_button_init+0x0/0x7d returned 0 after 22696 usecs
[    7.472850] calling  acpi_container_init+0x0/0x65 @ 1
[    7.537502] initcall acpi_container_init+0x0/0x65 returned 0 after 58180 usecs
[    7.544739] calling  acpi_battery_init+0x0/0x3d @ 1
[    7.551126] initcall acpi_battery_init+0x0/0x3d returned 0 after 1456 usecs
[    7.558214] calling  regulator_virtual_consumer_init+0x0/0x3d @ 1
[    7.569123] initcall regulator_virtual_consumer_init+0x0/0x3d returned 0 after 4585 usecs
[    7.577307] calling  lp3971_module_init+0x0/0x63 @ 1
[    7.583440] initcall lp3971_module_init+0x0/0x63 returned 0 after 1123 usecs
[    7.590503] calling  rand_initialize+0x0/0x60 @ 1
[    7.595274] initcall rand_initialize+0x0/0x60 returned 0 after 54 usecs
[    7.601899] calling  tty_init+0x0/0x125 @ 1
[    7.667731] initcall tty_init+0x0/0x125 returned 0 after 60184 usecs
[    7.674487] calling  pty_init+0x0/0x40 @ 1
[    8.170569] initcall pty_init+0x0/0x40 returned 0 after 480309 usecs
[    8.177121] calling  sysrq_init+0x0/0x50 @ 1
[    8.181448] initcall sysrq_init+0x0/0x50 returned 0 after 40 usecs
[    8.187637] calling  raw_init+0x0/0x113 @ 1
[    8.195995] initcall raw_init+0x0/0x113 returned 0 after 4063 usecs
[    8.202338] calling  applicom_init+0x0/0x55d @ 1
[    8.206972] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    8.214142] ac.o: No PCI boards found.
[    8.217899] ac.o: For an ISA board you must supply memory and irq parameters.
[    8.225044] initcall applicom_init+0x0/0x55d returned -6 after 17646 usecs
[    8.231923] initcall applicom_init+0x0/0x55d returned with error code -6 
[    8.238718] calling  hpet_init+0x0/0x90 @ 1
[    8.245946] initcall hpet_init+0x0/0x90 returned 0 after 2959 usecs
[    8.252237] calling  mod_init+0x0/0x75 @ 1
[    8.256350] initcall mod_init+0x0/0x75 returned -19 after 1 usecs
[    8.262455] calling  init+0x0/0xc6 @ 1
[    8.267382] initcall init+0x0/0xc6 returned 0 after 1134 usecs
[    8.273277] calling  ppdev_init+0x0/0xe8 @ 1
[    8.280201] ppdev: user-space parallel port driver
[    8.285021] initcall ppdev_init+0x0/0xe8 returned 0 after 7281 usecs
[    8.291387] calling  mwave_init+0x0/0x380 @ 1
[    8.295762] smapi::smapi_init, ERROR invalid usSmapiID
[    8.300908] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    8.310218] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    8.317444] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    8.323722] initcall mwave_init+0x0/0x380 returned -5 after 27312 usecs
[    8.330341] initcall mwave_init+0x0/0x380 returned with error code -5 
[    8.336877] calling  agp_init+0x0/0x51 @ 1
[    8.340985] Linux agpgart interface v0.103
[    8.345093] initcall agp_init+0x0/0x51 returned 0 after 4010 usecs
[    8.351280] calling  agp_intel_init+0x0/0x60 @ 1
[    8.356994] initcall agp_intel_init+0x0/0x60 returned 0 after 1058 usecs
[    8.363715] calling  agp_via_init+0x0/0x60 @ 1
[    8.369762] initcall agp_via_init+0x0/0x60 returned 0 after 1550 usecs
[    8.376311] calling  ipmi_init_msghandler_mod+0x0/0x35 @ 1
[    8.382974] ipmi message handler version 39.2
[    8.387397] initcall ipmi_init_msghandler_mod+0x0/0x35 returned 0 after 5457 usecs
[    8.394971] calling  init_ipmi_si+0x0/0x31c @ 1
[    8.400702] IPMI System Interface driver.
[    8.429108] ipmi_si: Unable to find any System Interface(s)
[    8.434707] initcall init_ipmi_si+0x0/0x31c returned -19 after 34367 usecs
[    8.441589] calling  ipmi_poweroff_init+0x0/0xc0 @ 1
[    8.446563] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    8.454344] initcall ipmi_poweroff_init+0x0/0xc0 returned 0 after 7596 usecs
[    8.461401] calling  init_tis+0x0/0xcb @ 1
[    8.466537] initcall init_tis+0x0/0xcb returned 0 after 1002 usecs
[    8.472867] calling  serial8250_init+0x0/0x189 @ 1
[    8.477668] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.486047] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.498312] initcall serial8250_init+0x0/0x189 returned 0 after 20156 usecs
[    8.505315] calling  init_kgdboc+0x0/0x50 @ 1
[    8.509686] initcall init_kgdboc+0x0/0x50 returned 0 after 2 usecs
[    8.515879] calling  parport_default_proc_register+0x0/0x50 @ 1
[    8.521897] initcall parport_default_proc_register+0x0/0x50 returned 0 after 87 usecs
[    8.529742] calling  parport_pc_init+0x0/0xdc @ 1
[    8.535569] IT8712 SuperIO detected.
[    8.540172] parport_pc 00:09: reported by Plug and Play ACPI
[    8.546002] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
[    8.668672] initcall parport_pc_init+0x0/0xdc returned 0 after 131059 usecs
[    8.675723] calling  topology_sysfs_init+0x0/0xc0 @ 1
[    8.680947] initcall topology_sysfs_init+0x0/0xc0 returned 0 after 153 usecs
[    8.688016] calling  cpqarray_init+0x0/0x94 @ 1
[    8.692562] Compaq SMART2 Driver (v 2.6.0)
[    8.699726] initcall cpqarray_init+0x0/0x94 returned -19 after 6993 usecs
[    8.706561] calling  cciss_init+0x0/0x7c @ 1
[    8.710845] HP CISS Driver (v 3.6.20)
[    8.716825] initcall cciss_init+0x0/0x7c returned 0 after 5837 usecs
[    8.723200] calling  pkt_init+0x0/0x1fc @ 1
[    8.731015] initcall pkt_init+0x0/0x1fc returned 0 after 3530 usecs
[    8.737299] calling  mm_init+0x0/0x200 @ 1
[    8.742676] MM: desc_per_page = 128
[    8.746193] initcall mm_init+0x0/0x200 returned 0 after 4669 usecs
[    8.752383] calling  nbd_init+0x0/0x3bd @ 1
[    8.758421] nbd: registered device at major 43
[    8.806589] initcall nbd_init+0x0/0x3bd returned 0 after 48833 usecs
[    8.813094] calling  init_kgdbts+0x0/0x50 @ 1
[    8.817476] initcall init_kgdbts+0x0/0x50 returned 0 after 1 usecs
[    8.823667] calling  sm501_base_init+0x0/0x60 @ 1
[    8.830982] initcall sm501_base_init+0x0/0x60 returned 0 after 2537 usecs
[    8.837977] calling  mac_hid_init+0x0/0x104 @ 1
[    8.843978] input: Macintosh mouse button emulation as /class/input/input2
[    8.851028] initcall mac_hid_init+0x0/0x104 returned 0 after 8309 usecs
[    8.857648] calling  spi_transport_init+0x0/0xb0 @ 1
[    8.866914] initcall spi_transport_init+0x0/0xb0 returned 0 after 4187 usecs
[    8.873987] calling  fc_transport_init+0x0/0x80 @ 1
[    8.881342] initcall fc_transport_init+0x0/0x80 returned 0 after 2410 usecs
[    8.888320] calling  iscsi_transport_init+0x0/0x182 @ 1
[    8.893558] Loading iSCSI transport class v2.0-870.
[    8.902069] initcall iscsi_transport_init+0x0/0x182 returned 0 after 8307 usecs
[    8.909400] calling  sas_transport_init+0x0/0xe6 @ 1
[    8.918120] initcall sas_transport_init+0x0/0xe6 returned 0 after 3656 usecs
[    8.925190] calling  sas_class_init+0x0/0x58 @ 1
[    8.931413] initcall sas_class_init+0x0/0x58 returned 0 after 1555 usecs
[    8.938438] calling  scsi_dh_init+0x0/0x65 @ 1
[    8.942941] initcall scsi_dh_init+0x0/0x65 returned 0 after 4 usecs
[    8.949219] calling  rdac_init+0x0/0x57 @ 1
[    8.953467] rdac: device handler registered
[    8.957664] initcall rdac_init+0x0/0x57 returned 0 after 4146 usecs
[    8.963937] calling  clariion_init+0x0/0x64 @ 1
[    8.968482] emc: device handler registered
[    8.972597] initcall clariion_init+0x0/0x64 returned 0 after 4018 usecs
[    8.979215] calling  libfc_init+0x0/0xa0 @ 1
[    8.986366] initcall libfc_init+0x0/0xa0 returned 0 after 2797 usecs
[    8.992869] calling  advansys_init+0x0/0x50 @ 1
[    8.998642] initcall advansys_init+0x0/0x50 returned 0 after 1187 usecs
[    9.005278] calling  arcmsr_module_init+0x0/0x50 @ 1
[    9.011402] initcall arcmsr_module_init+0x0/0x50 returned 0 after 1121 usecs
[    9.018507] calling  ahc_linux_init+0x0/0x95 @ 1
[    9.024463] initcall ahc_linux_init+0x0/0x95 returned 0 after 1291 usecs
[    9.031183] calling  aac_init+0x0/0x97 @ 1
[    9.035289] Adaptec aacraid driver 1.1-5[2461]-ms
[    9.042344] initcall aac_init+0x0/0x97 returned 0 after 6887 usecs
[    9.048545] calling  ips_module_init+0x0/0x8e @ 1
[    9.055636] initcall ips_module_init+0x0/0x8e returned -19 after 2313 usecs
[    9.062617] calling  init_this_scsi_driver+0x0/0x118 @ 1
[    9.068074] scsi: <fdomain> Detection failed (no card)
[    9.073226] initcall init_this_scsi_driver+0x0/0x118 returned -19 after 5162 usecs
[    9.080806] calling  qla4xxx_module_init+0x0/0x170 @ 1
[    9.087249] iscsi: registered transport (qla4xxx)
[    9.093585] QLogic iSCSI HBA Driver
[    9.097114] initcall qla4xxx_module_init+0x0/0x170 returned 0 after 10895 usecs
[    9.104433] calling  sym2_init+0x0/0x133 @ 1
[    9.111449] initcall sym2_init+0x0/0x133 returned 0 after 2669 usecs
[    9.117823] calling  init_this_scsi_driver+0x0/0x118 @ 1
[    9.123175] initcall init_this_scsi_driver+0x0/0x118 returned -19 after 30 usecs
[    9.130579] calling  dc390_module_init+0x0/0xc9 @ 1
[    9.135467] DC390: clustering now enabled by default. If you get problems load
[    9.142694]        with "disable_clustering=1" and report to maintainers
[    9.150750] initcall dc390_module_init+0x0/0xc9 returned 0 after 14921 usecs
[    9.157819] calling  megaraid_init+0x0/0xe7 @ 1
[    9.163633] initcall megaraid_init+0x0/0xe7 returned 0 after 1241 usecs
[    9.170265] calling  atp870u_init+0x0/0x50 @ 1
[    9.175894] initcall atp870u_init+0x0/0x50 returned 0 after 1145 usecs
[    9.182441] calling  inia100_init+0x0/0x50 @ 1
[    9.188127] initcall inia100_init+0x0/0x50 returned 0 after 1200 usecs
[    9.194668] calling  hptiop_module_init+0x0/0x70 @ 1
[    9.199647] RocketRAID 3xxx/4xxx Controller driver v1.3 (071203)
[    9.207424] initcall hptiop_module_init+0x0/0x70 returned 0 after 7592 usecs
[    9.214487] calling  stex_init+0x0/0x60 @ 1
[    9.218685] stex: Promise SuperTrak EX Driver version: 4.6.0000.3
[    9.227013] initcall stex_init+0x0/0x60 returned 0 after 8131 usecs
[    9.233293] calling  init_st+0x0/0x138 @ 1
[    9.237406] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    9.245335] initcall init_st+0x0/0x138 returned 0 after 7741 usecs
[    9.251529] calling  init_sd+0x0/0x152 @ 1
[    9.257544] initcall init_sd+0x0/0x152 returned 0 after 1857 usecs
[    9.263741] calling  init_sr+0x0/0x7e @ 1
[    9.269019] initcall init_sr+0x0/0x7e returned 0 after 1223 usecs
[    9.275128] calling  ahci_init+0x0/0x50 @ 1
[    9.280647] initcall ahci_init+0x0/0x50 returned 0 after 1288 usecs
[    9.286934] calling  piix_init+0x0/0x60 @ 1
[    9.292350] initcall piix_init+0x0/0x60 returned 0 after 1189 usecs
[    9.298635] calling  pdc_ata_init+0x0/0x50 @ 1
[    9.304359] initcall pdc_ata_init+0x0/0x50 returned 0 after 1234 usecs
[    9.310903] calling  qs_ata_init+0x0/0x50 @ 1
[    9.316484] initcall qs_ata_init+0x0/0x50 returned 0 after 1178 usecs
[    9.322940] calling  nv_init+0x0/0x45 @ 1
[    9.328105] initcall nv_init+0x0/0x45 returned 0 after 1108 usecs
[    9.334218] calling  ali_init+0x0/0x7b @ 1
[    9.339660] initcall ali_init+0x0/0x7b returned 0 after 1297 usecs
[    9.345856] calling  amd_init+0x0/0x50 @ 1
[    9.350194] pata_amd 0000:00:06.0: version 0.4.1
[    9.355058] pata_amd 0000:00:06.0: setting latency timer to 64
[    9.361880] scsi0 : pata_amd
[    9.366758] scsi1 : pata_amd
[    9.371327] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    9.378306] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    9.557904] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[    9.564235] ata1.00: 488397168 sectors, multi 1: LBA48 
[    9.569521] ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
[    9.602714] ata1.00: configured for UDMA/100
[    9.607033] async_waiting @ 1280
[    9.610293] async_continuing @ 1280 after 2 usec
[    9.616121] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[    9.628558] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    9.636942] sd 0:0:0:0: [sda] Write Protect is off
[    9.641758] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.647259] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.659343]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    9.782982] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.790793] async_waiting @ 1280
[    9.794110] async_continuing @ 1280 after 2 usec
[    9.966014] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[    9.972089] ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
[    9.997310] ata2.01: configured for UDMA/33
[   10.003026] async_waiting @ 1280
[   10.006280] async_continuing @ 1280 after 2 usec
[   10.011572] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   10.026426] sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
[   10.033167] Uniform CD-ROM driver Revision: 3.20
[   10.042036] sr 1:0:1:0: Attached scsi CD-ROM sr0
[   10.051533] initcall amd_init+0x0/0x50 returned 0 after 685118 usecs
[   10.057914] calling  atiixp_init+0x0/0x50 @ 1
[   10.063521] initcall atiixp_init+0x0/0x50 returned 0 after 1210 usecs
[   10.070016] calling  cs5520_init+0x0/0x50 @ 1
[   10.075410] initcall cs5520_init+0x0/0x50 returned 0 after 996 usecs
[   10.081785] calling  cs5530_init+0x0/0x50 @ 1
[   10.087330] initcall cs5530_init+0x0/0x50 returned 0 after 1141 usecs
[   10.093808] calling  efar_init+0x0/0x50 @ 1
[   10.099001] initcall efar_init+0x0/0x50 returned 0 after 968 usecs
[   10.105201] calling  hpt36x_init+0x0/0x50 @ 1
[   10.110524] initcall hpt36x_init+0x0/0x50 returned 0 after 933 usecs
[   10.116910] calling  hpt37x_init+0x0/0x50 @ 1
[   10.122422] initcall hpt37x_init+0x0/0x50 returned 0 after 1110 usecs
[   10.128885] calling  it821x_init+0x0/0x50 @ 1
[   10.134543] initcall it821x_init+0x0/0x50 returned 0 after 1259 usecs
[   10.141005] calling  netcell_init+0x0/0x50 @ 1
[   10.146636] initcall netcell_init+0x0/0x50 returned 0 after 1139 usecs
[   10.153189] calling  ninja32_init+0x0/0x50 @ 1
[   10.158629] initcall ninja32_init+0x0/0x50 returned 0 after 955 usecs
[   10.165086] calling  marvell_init+0x0/0x50 @ 1
[   10.170811] initcall marvell_init+0x0/0x50 returned 0 after 1237 usecs
[   10.177355] calling  mpiix_init+0x0/0x50 @ 1
[   10.184185] initcall mpiix_init+0x0/0x50 returned 0 after 2485 usecs
[   10.190552] calling  oldpiix_init+0x0/0x50 @ 1
[   10.196277] initcall oldpiix_init+0x0/0x50 returned 0 after 1233 usecs
[   10.202820] calling  triflex_init+0x0/0x50 @ 1
[   10.208609] initcall triflex_init+0x0/0x50 returned 0 after 1301 usecs
[   10.215149] calling  e1000_init_module+0x0/0xa0 @ 1
[   10.220040] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   10.225967] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.233208] initcall e1000_init_module+0x0/0xa0 returned 0 after 12856 usecs
[   10.240274] calling  igb_init_module+0x0/0x7d @ 1
[   10.244991] Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
[   10.251699] Copyright (c) 2007-2009 Intel Corporation.
[   10.258034] initcall igb_init_module+0x0/0x7d returned 0 after 12734 usecs
[   10.264930] calling  igbvf_init_module+0x0/0x93 @ 1
[   10.269821] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[   10.276442] Copyright (c) 2009 Intel Corporation.
[   10.282464] initcall igbvf_init_module+0x0/0x93 returned 0 after 12344 usecs
[   10.289528] calling  plip_init+0x0/0x8c @ 1
[   10.296892] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   10.302395] plip0: Parallel port at 0x378, using IRQ 7.
[   10.307639] initcall plip_init+0x0/0x8c returned 0 after 13585 usecs
[   10.314004] calling  vortex_init+0x0/0xe6 @ 1
[   10.319580] initcall vortex_init+0x0/0xe6 returned 0 after 1175 usecs
[   10.326045] calling  e100_init_module+0x0/0x85 @ 1
[   10.330845] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   10.336944] e100: Copyright(c) 1999-2006 Intel Corporation
[   10.343643] initcall e100_init_module+0x0/0x85 returned 0 after 12496 usecs
[   10.350619] calling  sis190_init_module+0x0/0x50 @ 1
[   10.356770] initcall sis190_init_module+0x0/0x50 returned 0 after 1143 usecs
[   10.363836] calling  sis900_init_module+0x0/0x50 @ 1
[   10.370919] initcall sis900_init_module+0x0/0x50 returned 0 after 2054 usecs
[   10.377977] calling  r6040_init+0x0/0x50 @ 1
[   10.383513] initcall r6040_init+0x0/0x50 returned 0 after 1218 usecs
[   10.389890] calling  tg3_init+0x0/0x45 @ 1
[   10.395202] initcall tg3_init+0x0/0x45 returned 0 after 1174 usecs
[   10.401403] calling  rhine_init+0x0/0x94 @ 1
[   10.407020] initcall rhine_init+0x0/0x94 returned 0 after 1296 usecs
[   10.413392] calling  velocity_init_module+0x0/0x77 @ 1
[   10.419833] initcall velocity_init_module+0x0/0x77 returned 0 after 1258 usecs
[   10.427069] calling  cicada_init+0x0/0x6d @ 1
[   10.433027] initcall cicada_init+0x0/0x6d returned 0 after 1550 usecs
[   10.439487] calling  qs6612_init+0x0/0x40 @ 1
[   10.444875] initcall qs6612_init+0x0/0x40 returned 0 after 990 usecs
[   10.451305] calling  ste10Xp_init+0x0/0x50 @ 1
[   10.458357] initcall ste10Xp_init+0x0/0x50 returned 0 after 2528 usecs
[   10.464923] calling  hamachi_init+0x0/0x50 @ 1
[   10.470516] initcall hamachi_init+0x0/0x50 returned 0 after 1106 usecs
[   10.477057] calling  net_olddevs_init+0x0/0x4c @ 1
[   10.481868] initcall net_olddevs_init+0x0/0x4c returned 0 after 6 usecs
[   10.488490] calling  sb1000_init+0x0/0x40 @ 1
[   10.494783] initcall sb1000_init+0x0/0x40 returned 0 after 1877 usecs
[   10.501249] calling  hp100_module_init+0x0/0x45 @ 1
[   10.507344] initcall hp100_module_init+0x0/0x45 returned 0 after 1176 usecs
[   10.514326] calling  b44_init+0x0/0x8b @ 1
[   10.520789] initcall b44_init+0x0/0x8b returned 0 after 2295 usecs
[   10.526985] calling  init_nic+0x0/0x50 @ 1
[   10.531333] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[   10.543581] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[   10.549360]   alloc irq_desc for 23 on node 0
[   10.553331]   alloc kstat_irqs on node 0
[   10.557739] IOAPIC[0]: Set routing entry (2-23 -> 0x69 -> IRQ 23 Mode:1 Active:1)
[   10.565233] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[   10.573680] forcedeth 0000:00:0a.0: setting latency timer to 64
[   10.579738] nv_probe: set workaround bit for reversed mac addr
[   11.110408] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   11.118782] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[   11.125603] initcall init_nic+0x0/0x50 returned 0 after 580567 usecs
[   11.131979] calling  ifb_init_module+0x0/0x120 @ 1
[   11.140842] initcall ifb_init_module+0x0/0x120 returned 0 after 3959 usecs
[   11.147736] calling  de600_init+0x0/0x53 @ 1
[   11.152057] DE600: port 0x378 busy
[   11.155474] initcall de600_init+0x0/0x53 returned -16 after 3373 usecs
[   11.162015] initcall de600_init+0x0/0x53 returned with error code -16 
[   11.168556] calling  cp_init+0x0/0x50 @ 1
[   11.172824] <6>8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   11.179288] 8139cp 0000:05:07.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip, use 8139too
[   11.189318] initcall cp_init+0x0/0x50 returned 0 after 16346 usecs
[   11.195531] calling  rtl8139_init_module+0x0/0x45 @ 1
[   11.200812] 8139too Fast Ethernet driver 0.9.28
[   11.207416] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[   11.213217]   alloc irq_desc for 17 on node 0
[   11.217165]   alloc kstat_irqs on node 0
[   11.221588] IOAPIC[0]: Set routing entry (2-17 -> 0x71 -> IRQ 17 Mode:1 Active:1)
[   11.229083] 8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[   11.239921] eth1: RealTek RTL8139 at 0xffffc900001f6000, 00:c0:df:03:68:5d, IRQ 17
[   11.247942] initcall rtl8139_init_module+0x0/0x45 returned 0 after 46231 usecs
[   11.255260] calling  tun_init+0x0/0xbb @ 1
[   11.259401] tun: Universal TUN/TAP device driver, 1.6
[   11.264460] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.271319] initcall tun_init+0x0/0xbb returned 0 after 11632 usecs
[   11.277688] calling  veth_init+0x0/0x40 @ 1
[   11.282052] initcall veth_init+0x0/0x40 returned 0 after 104 usecs
[   11.288278] calling  rio_init+0x0/0x50 @ 1
[   11.292990] initcall rio_init+0x0/0x50 returned 0 after 537 usecs
[   11.299162] calling  amd8111e_init+0x0/0x50 @ 1
[   11.304219] initcall amd8111e_init+0x0/0x50 returned 0 after 468 usecs
[   11.310827] calling  ethoc_init+0x0/0x40 @ 1
[   11.315564] initcall ethoc_init+0x0/0x40 returned 0 after 415 usecs
[   11.321880] calling  hdlc_module_init+0x0/0x70 @ 1
[   11.326696] HDLC support module revision 1.22
[   11.331086] initcall hdlc_module_init+0x0/0x70 returned 0 after 4286 usecs
[   11.337974] calling  mod_init+0x0/0x40 @ 1
[   11.342090] initcall mod_init+0x0/0x40 returned 0 after 3 usecs
[   11.348023] calling  mod_init+0x0/0x40 @ 1
[   11.352139] initcall mod_init+0x0/0x40 returned 0 after 2 usecs
[   11.358071] calling  mod_init+0x0/0x75 @ 1
[   11.362184] initcall mod_init+0x0/0x75 returned 0 after 3 usecs
[   11.368118] calling  pc300_init_module+0x0/0x9b @ 1
[   11.373540] initcall pc300_init_module+0x0/0x9b returned 0 after 512 usecs
[   11.380432] calling  catc_init+0x0/0x60 @ 1
[   11.385033] usbcore: registered new interface driver catc
[   11.390469] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[   11.396411] initcall catc_init+0x0/0x60 returned 0 after 11506 usecs
[   11.402784] calling  usb_rtl8150_init+0x0/0x60 @ 1
[   11.407585] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   11.414861] usbcore: registered new interface driver rtl8150
[   11.420548] initcall usb_rtl8150_init+0x0/0x60 returned 0 after 12657 usecs
[   11.427518] calling  cdc_init+0x0/0x50 @ 1
[   11.432019] usbcore: registered new interface driver cdc_ether
[   11.437880] initcall cdc_init+0x0/0x50 returned 0 after 6101 usecs
[   11.444072] calling  smsc95xx_init+0x0/0x50 @ 1
[   11.449101] usbcore: registered new interface driver smsc95xx
[   11.454875] initcall smsc95xx_init+0x0/0x50 returned 0 after 6096 usecs
[   11.461500] calling  rndis_init+0x0/0x45 @ 1
[   11.466189] usbcore: registered new interface driver rndis_host
[   11.472140] initcall rndis_init+0x0/0x45 returned 0 after 6195 usecs
[   11.478505] calling  usbnet_init+0x0/0x5b @ 1
[   11.482902] initcall usbnet_init+0x0/0x5b returned 0 after 9 usecs
[   11.489095] calling  usbpn_init+0x0/0x50 @ 1
[   11.493777] usbcore: registered new interface driver cdc_phonet
[   11.499729] initcall usbpn_init+0x0/0x50 returned 0 after 6193 usecs
[   11.506090] calling  init_netconsole+0x0/0x1a3 @ 1
[   11.511393] console [netcon0] enabled
[   11.515070] netconsole: network logging started
[   11.519620] initcall init_netconsole+0x0/0x1a3 returned 0 after 8504 usecs
[   11.526513] calling  init+0x0/0x40 @ 1
[   11.530683] initcall init+0x0/0x40 returned 0 after 392 usecs
[   11.536445] calling  sbp2_module_init+0x0/0xa0 @ 1
[   11.541653] initcall sbp2_module_init+0x0/0xa0 returned 0 after 392 usecs
[   11.548464] calling  uio_init+0x0/0x30 @ 1
[   11.552580] initcall uio_init+0x0/0x30 returned 0 after 1 usecs
[   11.558523] calling  hilscher_init_module+0x0/0x50 @ 1
[   11.564157] initcall hilscher_init_module+0x0/0x50 returned 0 after 472 usecs
[   11.571308] calling  uio_pdrv_init+0x0/0x40 @ 1
[   11.576314] initcall uio_pdrv_init+0x0/0x40 returned 0 after 442 usecs
[   11.582858] calling  uio_pdrv_genirq_init+0x0/0x40 @ 1
[   11.588393] initcall uio_pdrv_genirq_init+0x0/0x40 returned 0 after 371 usecs
[   11.595544] calling  aectc_init+0x0/0x45 @ 1
[   11.600343] initcall aectc_init+0x0/0x45 returned 0 after 501 usecs
[   11.606635] calling  cdrom_init+0x0/0x9b @ 1
[   11.610928] initcall cdrom_init+0x0/0x9b returned 0 after 1 usecs
[   11.617036] calling  ehci_hcd_init+0x0/0x120 @ 1
[   11.621670] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   11.628212] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
[   11.638791] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[   11.644576]   alloc irq_desc for 22 on node 0
[   11.648552]   alloc kstat_irqs on node 0
[   11.652956] IOAPIC[0]: Set routing entry (2-22 -> 0x79 -> IRQ 22 Mode:1 Active:1)
[   11.660461] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
[   11.668879] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   11.674736] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   11.680702] drivers/usb/core/inode.c: creating file 'devices'
[   11.686599] drivers/usb/core/inode.c: creating file '001'
[   11.692130] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   11.699560] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[   11.707926] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[   11.714552] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[   11.722812] ehci_hcd 0000:00:02.1: park 0
[   11.726911] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   11.735679] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[   11.743497] ehci_hcd 0000:00:02.1: debug port 1
[   11.748051] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[   11.754849] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[   11.760750] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfeb00000
[   11.766425] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   11.775131] ehci_hcd 0000:00:02.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   11.792053] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[   11.798317] usb usb1: default language 0x0409
[   11.802881] usb usb1: udev 1, busnum 1, minor = 0
[   11.807600] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   11.814400] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.821643] usb usb1: Product: EHCI Host Controller
[   11.826529] usb usb1: Manufacturer: Linux 2.6.31-rc5-tip ehci_hcd
[   11.832629] usb usb1: SerialNumber: 0000:00:02.1
[   11.838070] usb usb1: uevent
[   11.841456] usb usb1: usb_probe_device
[   11.845246] usb usb1: configuration #1 chosen from 1 choice
[   11.851078] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   11.857142] usb 1-0:1.0: uevent
[   11.860743] hub 1-0:1.0: usb_probe_interface
[   11.865035] hub 1-0:1.0: usb_probe_interface - got id
[   11.870096] hub 1-0:1.0: USB hub found
[   11.873995] hub 1-0:1.0: 10 ports detected
[   11.878103] hub 1-0:1.0: standalone hub
[   11.881950] hub 1-0:1.0: no power switching (usb 1.0)
[   11.887013] hub 1-0:1.0: individual port over-current protection
[   11.893030] hub 1-0:1.0: power on to power good time: 20ms
[   11.898818] hub 1-0:1.0: local power source is good
[   11.903717] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   11.912321] drivers/usb/core/inode.c: creating file '001'
[   11.918557] initcall ehci_hcd_init+0x0/0x120 returned 0 after 289926 usecs
[   11.925529] calling  isp116x_init+0x0/0x70 @ 1
[   11.930038] 116x: driver isp116x-hcd, 03 Nov 2005
[   11.935331] initcall isp116x_init+0x0/0x70 returned 0 after 5167 usecs
[   11.941923] calling  ohci_hcd_mod_init+0x0/0x12f @ 1
[   11.946934] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   11.953164] ohci_hcd: block sizes: ed 80 td 96
[   11.962382] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[   11.968158]   alloc irq_desc for 21 on node 0
[   11.972135]   alloc kstat_irqs on node 0
[   11.976527] IOAPIC[0]: Set routing entry (2-21 -> 0x81 -> IRQ 21 Mode:1 Active:1)
[   11.984027] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
[   11.992443] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   11.998286] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   12.003576] drivers/usb/core/inode.c: creating file '002'
[   12.009031] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   12.017072] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   12.017089] ohci_hcd 0000:00:02.0: USB HC TakeOver from BIOS/SMM
[   12.044182] ohci_hcd 0000:00:02.0: created debug files
[   12.049334] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[   12.055226] ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
[   12.118034] ohci_hcd 0000:00:02.0: OHCI controller state
[   12.123365] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[   12.130071] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[   12.137470] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[   12.142969] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[   12.148555] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[   12.155264] ohci_hcd 0000:00:02.0: hcca frame #0028
[   12.160151] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[   12.167293] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[   12.173915] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[   12.179844] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[   12.186551] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[   12.193259] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[   12.199967] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[   12.206675] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[   12.213383] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[   12.220090] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[   12.226797] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[   12.233506] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[   12.240214] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[   12.247139] usb usb2: default language 0x0409
[   12.251682] usb usb2: udev 1, busnum 2, minor = 128
[   12.256569] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   12.263362] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.270590] usb usb2: Product: OHCI Host Controller
[   12.275479] usb usb2: Manufacturer: Linux 2.6.31-rc5-tip ohci_hcd
[   12.281580] usb usb2: SerialNumber: 0000:00:02.0
[   12.286828] usb usb2: uevent
[   12.290126] usb usb2: usb_probe_device
[   12.293895] usb usb2: configuration #1 chosen from 1 choice
[   12.299562] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   12.305609] usb 2-0:1.0: uevent
[   12.309202] hub 2-0:1.0: usb_probe_interface
[   12.313508] hub 2-0:1.0: usb_probe_interface - got id
[   12.318571] hub 2-0:1.0: USB hub found
[   12.322440] hub 2-0:1.0: 10 ports detected
[   12.326551] hub 2-0:1.0: standalone hub
[   12.330400] hub 2-0:1.0: no power switching (usb 1.0)
[   12.335460] hub 2-0:1.0: global over-current protection
[   12.340696] hub 2-0:1.0: power on to power good time: 2ms
[   12.346208] hub 2-0:1.0: local power source is good
[   12.351095] hub 2-0:1.0: no over-current condition exists
[   12.356517] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   12.364678] drivers/usb/core/inode.c: creating file '001'
[   12.371611] initcall ohci_hcd_mod_init+0x0/0x12f returned 0 after 414720 usecs
[   12.378927] calling  uhci_hcd_init+0x0/0x1a1 @ 1
[   12.383612] uhci_hcd: USB Universal Host Controller Interface driver
[   12.391966] initcall uhci_hcd_init+0x0/0x1a1 returned 0 after 8155 usecs
[   12.398740] calling  wdm_init+0x0/0x45 @ 1
[   12.403275] usbcore: registered new interface driver cdc_wdm
[   12.409256] initcall wdm_init+0x0/0x45 returned 0 after 6223 usecs
[   12.415452] calling  usb_mdc800_init+0x0/0x41b @ 1
[   12.420719] usbcore: registered new interface driver mdc800
[   12.426419] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   12.434084] initcall usb_mdc800_init+0x0/0x41b returned 0 after 13479 usecs
[   12.441070] calling  appledisplay_init+0x0/0x80 @ 1
[   12.446487] usbcore: registered new interface driver appledisplay
[   12.452640] initcall appledisplay_init+0x0/0x80 returned 0 after 6509 usecs
[   12.459615] calling  emi62_init+0x0/0x60 @ 1
[   12.464424] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   12.464660] usbcore: registered new interface driver emi62 - firmware loader
[   12.464685] initcall emi62_init+0x0/0x60 returned 0 after 758 usecs
[   12.464689] calling  iowarrior_init+0x0/0x45 @ 1
[   12.465188] usbcore: registered new interface driver iowarrior
[   12.465204] initcall iowarrior_init+0x0/0x45 returned 0 after 497 usecs
[   12.465208] calling  usb_lcd_init+0x0/0x62 @ 1
[   12.465604] usbcore: registered new interface driver usblcd
[   12.465620] initcall usb_lcd_init+0x0/0x62 returned 0 after 397 usecs
[   12.465624] calling  usb_led_init+0x0/0x62 @ 1
[   12.466027] usbcore: registered new interface driver usbled
[   12.466043] initcall usb_led_init+0x0/0x62 returned 0 after 404 usecs
[   12.466046] calling  tv_init+0x0/0x70 @ 1
[   12.466443] usbcore: registered new interface driver trancevibrator
[   12.466457] trancevibrator: v1.1:PlayStation 2 Trance Vibrator driver
[   12.466462] initcall tv_init+0x0/0x70 returned 0 after 400 usecs
[   12.466465] calling  vstusb_init+0x0/0x77 @ 1
[   12.466851] usbcore: registered new interface driver vstusb
[   12.466868] initcall vstusb_init+0x0/0x77 returned 0 after 389 usecs
[   12.466871] calling  usb_sisusb_init+0x0/0x50 @ 1
[   12.467263] usbcore: registered new interface driver sisusb
[   12.467280] initcall usb_sisusb_init+0x0/0x50 returned 0 after 393 usecs
[   12.467283] calling  i8042_init+0x0/0x157 @ 1
[   12.468244] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   12.472433] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.472525] serio: i8042 AUX port at 0x60,0x64 irq 12
[   12.472559] initcall i8042_init+0x0/0x157 returned 0 after 5142 usecs
[   12.472563] calling  parkbd_init+0x0/0x211 @ 1
[   12.472592] parport0: cannot grant exclusive access for device parkbd
[   12.472608] initcall parkbd_init+0x0/0x211 returned -19 after 39 usecs
[   12.472611] calling  pcips2_init+0x0/0x50 @ 1
[   12.473963] initcall pcips2_init+0x0/0x50 returned 0 after 1314 usecs
[   12.473967] calling  emu_init+0x0/0x50 @ 1
[   12.474945] initcall emu_init+0x0/0x50 returned 0 after 949 usecs
[   12.474948] calling  mousedev_init+0x0/0xc4 @ 1
[   12.477504] mice: PS/2 mouse device common for all mice
[   12.477513] initcall mousedev_init+0x0/0xc4 returned 0 after 2496 usecs
[   12.477517] calling  atkbd_init+0x0/0x58 @ 1
[   12.477953] initcall atkbd_init+0x0/0x58 returned 0 after 420 usecs
[   12.477956] calling  lm8323_init+0x0/0x40 @ 1
[   12.478702] initcall lm8323_init+0x0/0x40 returned 0 after 723 usecs
[   12.478706] calling  matrix_keypad_init+0x0/0x40 @ 1
[   12.479106] initcall matrix_keypad_init+0x0/0x40 returned 0 after 385 usecs
[   12.479109] calling  adi_init+0x0/0x50 @ 1
[   12.479576] initcall adi_init+0x0/0x50 returned 0 after 450 usecs
[   12.479579] calling  grip_init+0x0/0x50 @ 1
[   12.480333] initcall grip_init+0x0/0x50 returned 0 after 727 usecs
[   12.480337] calling  guillemot_init+0x0/0x45 @ 1
[   12.481508] initcall guillemot_init+0x0/0x45 returned 0 after 1137 usecs
[   12.481511] calling  iforce_init+0x0/0x7b @ 1
[   12.481925] usbcore: registered new interface driver iforce
[   12.482353] initcall iforce_init+0x0/0x7b returned 0 after 815 usecs
[   12.482356] calling  magellan_init+0x0/0x50 @ 1
[   12.482820] initcall magellan_init+0x0/0x50 returned 0 after 447 usecs
[   12.482823] calling  stinger_init+0x0/0x50 @ 1
[   12.483243] initcall stinger_init+0x0/0x50 returned 0 after 404 usecs
[   12.483246] calling  tmdc_init+0x0/0x50 @ 1
[   12.483658] initcall tmdc_init+0x0/0x50 returned 0 after 397 usecs
[   12.483662] calling  tgfx_init+0x0/0xfa @ 1
[   12.483669] initcall tgfx_init+0x0/0xfa returned -19 after 2 usecs
[   12.483672] calling  aiptek_init+0x0/0x7b @ 1
[   12.484225] usbcore: registered new interface driver aiptek
[   12.484239] aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
[   12.484242] aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
[   12.484247] initcall aiptek_init+0x0/0x7b returned 0 after 554 usecs
[   12.484251] calling  eeti_ts_init+0x0/0x40 @ 1
[   12.484634] initcall eeti_ts_init+0x0/0x40 returned 0 after 368 usecs
[   12.484637] calling  elo_init+0x0/0x50 @ 1
[   12.485059] initcall elo_init+0x0/0x50 returned 0 after 407 usecs
[   12.485063] calling  touchit213_init+0x0/0x50 @ 1
[   12.485483] initcall touchit213_init+0x0/0x50 returned 0 after 405 usecs
[   12.485486] calling  tr_init+0x0/0x50 @ 1
[   12.485898] initcall tr_init+0x0/0x50 returned 0 after 396 usecs
[   12.485902] calling  w8001_init+0x0/0x50 @ 1
[   12.486316] initcall w8001_init+0x0/0x50 returned 0 after 399 usecs
[   12.486320] calling  ds1553_init+0x0/0x40 @ 1
[   12.486715] initcall ds1553_init+0x0/0x40 returned 0 after 380 usecs
[   12.486719] calling  ds1672_init+0x0/0x40 @ 1
[   12.487096] initcall ds1672_init+0x0/0x40 returned 0 after 363 usecs
[   12.487099] calling  ds1742_init+0x0/0x40 @ 1
[   12.487516] initcall ds1742_init+0x0/0x40 returned 0 after 402 usecs
[   12.487520] calling  max6900_init+0x0/0x40 @ 1
[   12.487904] initcall max6900_init+0x0/0x40 returned 0 after 369 usecs
[   12.487907] calling  twl4030_rtc_init+0x0/0x40 @ 1
[   12.489502] initcall twl4030_rtc_init+0x0/0x40 returned 0 after 1549 usecs
[   12.489506] calling  ali1563_init+0x0/0x50 @ 1
[   12.489954] initcall ali1563_init+0x0/0x50 returned 0 after 432 usecs
[   12.489958] calling  i2c_ali15x3_init+0x0/0x50 @ 1
[   12.490378] initcall i2c_ali15x3_init+0x0/0x50 returned 0 after 405 usecs
[   12.490382] calling  i2c_amd8111_init+0x0/0x50 @ 1
[   12.490804] initcall i2c_amd8111_init+0x0/0x50 returned 0 after 407 usecs
[   12.490808] calling  i2c_i801_init+0x0/0x50 @ 1
[   12.491279] initcall i2c_i801_init+0x0/0x50 returned 0 after 454 usecs
[   12.491283] calling  ocores_i2c_init+0x0/0x3d @ 1
[   12.491674] initcall ocores_i2c_init+0x0/0x3d returned 0 after 376 usecs
[   12.491677] calling  i2c_parport_init+0x0/0x70 @ 1
[   12.491681] i2c-parport: adapter type unspecified
[   12.491686] initcall i2c_parport_init+0x0/0x70 returned -19 after 3 usecs
[   12.491689] calling  i2c_parport_init+0x0/0x193 @ 1
[   12.491693] i2c-parport-light: adapter type unspecified
[   12.491698] initcall i2c_parport_init+0x0/0x193 returned -19 after 3 usecs
[   12.491701] calling  sensors_w83793_init+0x0/0x40 @ 1
[   12.492185] initcall sensors_w83793_init+0x0/0x40 returned 0 after 463 usecs
[   12.492189] calling  ad7418_init+0x0/0x40 @ 1
[   12.492564] initcall ad7418_init+0x0/0x40 returned 0 after 360 usecs
[   12.492567] calling  sensors_adm1025_init+0x0/0x40 @ 1
[   12.492944] initcall sensors_adm1025_init+0x0/0x40 returned 0 after 363 usecs
[   12.492948] calling  sensors_adm9240_init+0x0/0x40 @ 1
[   12.493325] initcall sensors_adm9240_init+0x0/0x40 returned 0 after 363 usecs
[   12.493329] calling  sensors_ads7828_init+0x0/0x90 @ 1
[   12.493712] initcall sensors_ads7828_init+0x0/0x90 returned 0 after 369 usecs
[   12.493716] calling  adt7470_init+0x0/0x40 @ 1
[   12.494103] initcall adt7470_init+0x0/0x40 returned 0 after 371 usecs
[   12.494106] calling  adt7473_init+0x0/0x40 @ 1
[   12.494555] initcall adt7473_init+0x0/0x40 returned 0 after 432 usecs
[   12.494559] calling  applesmc_init+0x0/0x4b0 @ 1
[   12.494567] applesmc: supported laptop not found!
[   12.494569] applesmc: driver init failed (ret=-19)!
[   12.494574] initcall applesmc_init+0x0/0x4b0 returned -19 after 10 usecs
[   12.494578] calling  atxp1_init+0x0/0x40 @ 1
[   12.494975] initcall atxp1_init+0x0/0x40 returned 0 after 381 usecs
[   12.494978] calling  dme1737_init+0x0/0xf6 @ 1
[   12.495395] initcall dme1737_init+0x0/0xf6 returned 0 after 402 usecs
[   12.495399] calling  f71882fg_init+0x0/0xb7 @ 1
[   12.495435] initcall f71882fg_init+0x0/0xb7 returned -19 after 31 usecs
[   12.495439] calling  sensors_fscher_init+0x0/0x40 @ 1
[   12.495832] initcall sensors_fscher_init+0x0/0x40 returned 0 after 377 usecs
[   12.495835] calling  fschmd_init+0x0/0x40 @ 1
[   12.497550] initcall fschmd_init+0x0/0x40 returned 0 after 1666 usecs
[   12.497555] calling  sensors_gl518sm_init+0x0/0x40 @ 1
[   12.497940] initcall sensors_gl518sm_init+0x0/0x40 returned 0 after 370 usecs
[   12.497944] calling  sensors_gl520sm_init+0x0/0x40 @ 1
[   12.498319] initcall sensors_gl520sm_init+0x0/0x40 returned 0 after 360 usecs
[   12.498323] calling  ibmpex_init+0x0/0x40 @ 1
[   12.498333] initcall ibmpex_init+0x0/0x40 returned 0 after 5 usecs
[   12.498336] calling  sm_it87_init+0x0/0x8f @ 1
[   12.498375] it87: Found IT8712F chip at 0x290, revision 7
[   12.498384] it87: in3 is VCC (+5V)
[   12.498385] it87: in7 is VCCH (+5V Stand-By)
[   12.498781] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__ [0x295-0x296]
[   12.498784] ACPI: Device needs an ACPI driver
[   12.499169] initcall sm_it87_init+0x0/0x8f returned -16 after 806 usecs
[   12.499173] initcall sm_it87_init+0x0/0x8f returned with error code -16 
[   12.499176] calling  lis3lv02d_init_module+0x0/0x6c @ 1
[   12.499632] lis3lv02d driver loaded.
[   12.499638] initcall lis3lv02d_init_module+0x0/0x6c returned 0 after 446 usecs
[   12.499642] calling  sensors_lm63_init+0x0/0x40 @ 1
[   12.500128] initcall sensors_lm63_init+0x0/0x40 returned 0 after 465 usecs
[   12.500131] calling  sensors_lm77_init+0x0/0x40 @ 1
[   12.500513] initcall sensors_lm77_init+0x0/0x40 returned 0 after 366 usecs
[   12.500516] calling  sm_lm85_init+0x0/0x40 @ 1
[   12.501785] initcall sm_lm85_init+0x0/0x40 returned 0 after 1233 usecs
[   12.501789] calling  sensors_lm87_init+0x0/0x40 @ 1
[   12.502210] input: AT Translated Set 2 keyboard as /class/input/input3
[   12.502686] initcall sensors_lm87_init+0x0/0x40 returned 0 after 870 usecs
[   12.502690] calling  sensors_max1619_init+0x0/0x40 @ 1
[   12.503092] initcall sensors_max1619_init+0x0/0x40 returned 0 after 386 usecs
[   12.503095] calling  pc87427_init+0x0/0xaa @ 1
[   12.503119] initcall pc87427_init+0x0/0xaa returned -19 after 18 usecs
[   12.503123] calling  sm_thmc50_init+0x0/0x40 @ 1
[   12.503519] initcall sm_thmc50_init+0x0/0x40 returned 0 after 380 usecs
[   12.503522] calling  sm_via686a_init+0x0/0x50 @ 1
[   12.503972] initcall sm_via686a_init+0x0/0x50 returned 0 after 433 usecs
[   12.503976] calling  vt1211_init+0x0/0xf2 @ 1
[   12.504302] initcall vt1211_init+0x0/0xf2 returned -19 after 310 usecs
[   12.504306] calling  sm_vt8231_init+0x0/0x50 @ 1
[   12.505437] initcall sm_vt8231_init+0x0/0x50 returned 0 after 1098 usecs
[   12.505441] calling  sensors_w83l786ng_init+0x0/0x3d @ 1
[   12.505827] initcall sensors_w83l786ng_init+0x0/0x3d returned 0 after 370 usecs
[   12.505830] calling  wdtpci_init+0x0/0x45 @ 1
[   12.506275] initcall wdtpci_init+0x0/0x45 returned 0 after 428 usecs
[   12.506280] calling  twl4030_wdt_init+0x0/0x3d @ 1
[   12.506686] initcall twl4030_wdt_init+0x0/0x3d returned 0 after 390 usecs
[   12.506689] calling  acq_init+0x0/0x87 @ 1
[   12.506694] WDT driver for Acquire single board computer initialising.
[   12.507801] acquirewdt: I/O address 0x0043 already in use
[   12.507831] acquirewdt: probe of acquirewdt failed with error -5
[   12.507842] initcall acq_init+0x0/0x87 returned 0 after 1119 usecs
[   12.507846] calling  advwdt_init+0x0/0x94 @ 1
[   12.507849] WDT driver for Advantech single board computer initialising.
[   12.509546] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[   12.509560] initcall advwdt_init+0x0/0x94 returned 0 after 1665 usecs
[   12.509563] calling  watchdog_init+0x0/0xf7 @ 1
[   12.509624] initcall watchdog_init+0x0/0xf7 returned -19 after 53 usecs
[   12.509628] calling  alim7101_wdt_init+0x0/0x1f5 @ 1
[   12.509631] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   12.509657] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   12.509663] initcall alim7101_wdt_init+0x0/0x1f5 returned -16 after 28 usecs
[   12.509666] initcall alim7101_wdt_init+0x0/0x1f5 returned with error code -16 
[   12.509670] calling  sc520_wdt_init+0x0/0x113 @ 1
[   12.509715] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   12.509775] initcall sc520_wdt_init+0x0/0x113 returned -16 after 96 usecs
[   12.509779] initcall sc520_wdt_init+0x0/0x113 returned with error code -16 
[   12.509783] calling  wafwdt_init+0x0/0x1a9 @ 1
[   12.509786] WDT driver for Wafer 5823 single board computer initialising.
[   12.509808] Wafer 5823 WDT: I/O address 0x0443 already in use
[   12.509820] initcall wafwdt_init+0x0/0x1a9 returned -5 after 31 usecs
[   12.509824] initcall wafwdt_init+0x0/0x1a9 returned with error code -5 
[   12.509827] calling  iTCO_wdt_init_module+0x0/0x8e @ 1
[   12.509832] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   12.511092] iTCO_wdt: No card detected
[   12.511131] initcall iTCO_wdt_init_module+0x0/0x8e returned 0 after 1268 usecs
[   12.511135] calling  sch311x_wdt_init+0x0/0x19b @ 1
[   12.511167] initcall sch311x_wdt_init+0x0/0x19b returned -19 after 26 usecs
[   12.511171] calling  zf_init+0x0/0x1b8 @ 1
[   12.511175] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   12.511179] machzwd: no ZF-Logic found
[   12.511183] initcall zf_init+0x0/0x1b8 returned -19 after 7 usecs
[   12.511187] calling  cpufreq_stats_init+0x0/0xcb @ 1
[   12.511248] initcall cpufreq_stats_init+0x0/0xcb returned 0 after 54 usecs
[   12.511252] calling  cpufreq_gov_powersave_init+0x0/0x40 @ 1
[   12.511262] initcall cpufreq_gov_powersave_init+0x0/0x40 returned 0 after 4 usecs
[   12.511265] calling  init_ladder+0x0/0x40 @ 1
[   12.511293] cpuidle: using governor ladder
[   12.511300] initcall init_ladder+0x0/0x40 returned 0 after 28 usecs
[   12.511304] calling  init_menu+0x0/0x40 @ 1
[   12.511308] cpuidle: using governor menu
[   12.511314] initcall init_menu+0x0/0x40 returned 0 after 4 usecs
[   12.511317] calling  i7300_idle_init+0x0/0x1dd @ 1
[   12.511605] initcall i7300_idle_init+0x0/0x1dd returned -19 after 275 usecs
[   12.511608] calling  memstick_init+0x0/0xb0 @ 1
[   12.513547] initcall memstick_init+0x0/0xb0 returned 0 after 1884 usecs
[   12.513552] calling  gpio_led_init+0x0/0x40 @ 1
[   12.513946] initcall gpio_led_init+0x0/0x40 returned 0 after 379 usecs
[   12.513950] calling  da903x_led_init+0x0/0x40 @ 1
[   12.514348] initcall da903x_led_init+0x0/0x40 returned 0 after 383 usecs
[   12.514352] calling  timer_trig_init+0x0/0x40 @ 1
[   12.514481] initcall timer_trig_init+0x0/0x40 returned 0 after 120 usecs
[   12.514484] calling  dcdbas_init+0x0/0x91 @ 1
[   12.515508] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   12.515521] initcall dcdbas_init+0x0/0x91 returned 0 after 1007 usecs
[   12.515525] calling  hifn_init+0x0/0x50 @ 1
[   12.515528] HIFN supports only 32-bit addresses.
[   12.515533] initcall hifn_init+0x0/0x50 returned -22 after 3 usecs
[   12.515537] initcall hifn_init+0x0/0x50 returned with error code -22 
[   12.515540] calling  hid_init+0x0/0x60 @ 1
[   12.515991] initcall hid_init+0x0/0x60 returned 0 after 434 usecs
[   12.515996] calling  a4_init+0x0/0x50 @ 1
[   12.516509] initcall a4_init+0x0/0x50 returned 0 after 403 usecs
[   12.516513] calling  apple_init+0x0/0x60 @ 1
[   12.516990] initcall apple_init+0x0/0x60 returned 0 after 460 usecs
[   12.516994] calling  belkin_init+0x0/0x50 @ 1
[   12.517386] initcall belkin_init+0x0/0x50 returned 0 after 377 usecs
[   12.517390] calling  ch_init+0x0/0x50 @ 1
[   12.517790] initcall ch_init+0x0/0x50 returned 0 after 386 usecs
[   12.517794] calling  dr_init+0x0/0x45 @ 1
[   12.518186] initcall dr_init+0x0/0x45 returned 0 after 376 usecs
[   12.518189] calling  gyration_init+0x0/0x50 @ 1
[   12.518582] initcall gyration_init+0x0/0x50 returned 0 after 378 usecs
[   12.518586] calling  lg_init+0x0/0x50 @ 1
[   12.518975] initcall lg_init+0x0/0x50 returned 0 after 374 usecs
[   12.518978] calling  ms_init+0x0/0x50 @ 1
[   12.519377] initcall ms_init+0x0/0x50 returned 0 after 383 usecs
[   12.519380] calling  samsung_init+0x0/0x50 @ 1
[   12.519785] initcall samsung_init+0x0/0x50 returned 0 after 389 usecs
[   12.519789] calling  hid_init+0x0/0xdd @ 1
[   12.522059] usbcore: registered new interface driver usbhid
[   12.522073] usbhid: v2.6:USB HID core driver
[   12.522082] initcall hid_init+0x0/0xdd returned 0 after 2231 usecs
[   12.522086] calling  usb_mouse_init+0x0/0x60 @ 1
[   12.522476] usbcore: registered new interface driver usbmouse
[   12.522490] usbmouse: v1.6:USB HID Boot Protocol mouse driver
[   12.522496] initcall usb_mouse_init+0x0/0x60 returned 0 after 395 usecs
[   12.522500] calling  virtio_pci_init+0x0/0x7f @ 1
[   12.523042] initcall virtio_pci_init+0x0/0x7f returned 0 after 523 usecs
[   12.523047] calling  flow_cache_init+0x0/0x1d9 @ 1
[   12.523130] initcall flow_cache_init+0x0/0x1d9 returned 0 after 75 usecs
[   12.523133] calling  pg_init+0x0/0x1c9 @ 1
[   12.523137] pktgen v2.70: Packet Generator for packet performance testing.
[   13.964752] initcall pg_init+0x0/0x1c9 returned 0 after 1407822 usecs
[   13.971272] ohci_hcd 0000:00:02.0: auto-stop root hub
[   13.976362] calling  llc_init+0x0/0x50 @ 1
[   13.980481] initcall llc_init+0x0/0x50 returned 0 after 4 usecs
[   13.986409] calling  llc2_init+0x0/0xf8 @ 1
[   13.990989] NET: Registered protocol family 26
[   13.995453] initcall llc2_init+0x0/0xf8 returned 0 after 4734 usecs
[   14.001732] calling  snap_init+0x0/0x6d @ 1
[   14.005976] initcall snap_init+0x0/0x6d returned 0 after 46 usecs
[   14.012081] calling  blackhole_module_init+0x0/0x40 @ 1
[   14.017318] initcall blackhole_module_init+0x0/0x40 returned 0 after 3 usecs
[   14.024378] calling  ipt_init_module+0x0/0x40 @ 1
[   14.029122] initcall ipt_init_module+0x0/0x40 returned 0 after 24 usecs
[   14.035740] calling  nat_init_module+0x0/0x40 @ 1
[   14.040458] initcall nat_init_module+0x0/0x40 returned 0 after 2 usecs
[   14.046989] calling  skbedit_init_module+0x0/0x40 @ 1
[   14.052055] initcall skbedit_init_module+0x0/0x40 returned 0 after 2 usecs
[   14.058942] calling  htb_module_init+0x0/0x40 @ 1
[   14.063659] initcall htb_module_init+0x0/0x40 returned 0 after 2 usecs
[   14.070200] calling  hfsc_init+0x0/0x40 @ 1
[   14.074398] initcall hfsc_init+0x0/0x40 returned 0 after 2 usecs
[   14.080416] calling  gred_module_init+0x0/0x40 @ 1
[   14.085221] initcall gred_module_init+0x0/0x40 returned 0 after 2 usecs
[   14.091844] calling  dsmark_module_init+0x0/0x40 @ 1
[   14.096827] initcall dsmark_module_init+0x0/0x40 returned 0 after 2 usecs
[   14.103626] calling  teql_init+0x0/0x10a @ 1
[   14.110222] initcall teql_init+0x0/0x10a returned 0 after 2258 usecs
[   14.116588] calling  prio_module_init+0x0/0x40 @ 1
[   14.121397] initcall prio_module_init+0x0/0x40 returned 0 after 2 usecs
[   14.128022] calling  netem_module_init+0x0/0x50 @ 1
[   14.132910] netem: version 1.2
[   14.135966] initcall netem_module_init+0x0/0x50 returned 0 after 2985 usecs
[   14.142937] calling  init_route4+0x0/0x40 @ 1
[   14.147346] initcall init_route4+0x0/0x40 returned 0 after 37 usecs
[   14.153625] calling  init_fw+0x0/0x40 @ 1
[   14.157648] initcall init_fw+0x0/0x40 returned 0 after 2 usecs
[   14.163488] calling  init_rsvp+0x0/0x40 @ 1
[   14.167684] initcall init_rsvp+0x0/0x40 returned 0 after 2 usecs
[   14.173700] calling  init_em_cmp+0x0/0x40 @ 1
[   14.178092] initcall init_em_cmp+0x0/0x40 returned 0 after 24 usecs
[   14.184364] calling  init_em_u32+0x0/0x3d @ 1
[   14.188736] initcall init_em_u32+0x0/0x3d returned 0 after 2 usecs
[   14.194921] calling  nfnetlink_init+0x0/0x8b @ 1
[   14.199550] Netfilter messages via NETLINK v0.30.
[   14.204301] initcall nfnetlink_init+0x0/0x8b returned 0 after 4639 usecs
[   14.211022] calling  nfnetlink_log_init+0x0/0x110 @ 1
[   14.216190] initcall nfnetlink_log_init+0x0/0x110 returned 0 after 101 usecs
[   14.223248] calling  xt_init+0x0/0x1bb @ 1
[   14.227390] initcall xt_init+0x0/0x1bb returned 0 after 28 usecs
[   14.233413] calling  tcpudp_mt_init+0x0/0x50 @ 1
[   14.238076] initcall tcpudp_mt_init+0x0/0x50 returned 0 after 35 usecs
[   14.244616] calling  hl_tg_init+0x0/0x50 @ 1
[   14.248902] initcall hl_tg_init+0x0/0x50 returned 0 after 4 usecs
[   14.255008] calling  nflog_tg_init+0x0/0x40 @ 1
[   14.259553] initcall nflog_tg_init+0x0/0x40 returned 0 after 3 usecs
[   14.265918] calling  xt_rateest_tg_init+0x0/0x70 @ 1
[   14.270904] initcall xt_rateest_tg_init+0x0/0x70 returned 0 after 8 usecs
[   14.277699] calling  tcpmss_tg_init+0x0/0x50 @ 1
[   14.282330] initcall tcpmss_tg_init+0x0/0x50 returned 0 after 4 usecs
[   14.288782] calling  trace_tg_init+0x0/0x3d @ 1
[   14.293326] initcall trace_tg_init+0x0/0x3d returned 0 after 3 usecs
[   14.299692] calling  dccp_mt_init+0x0/0xd3 @ 1
[   14.304159] initcall dccp_mt_init+0x0/0xd3 returned 0 after 10 usecs
[   14.310525] calling  dscp_mt_init+0x0/0x50 @ 1
[   14.315005] initcall dscp_mt_init+0x0/0x50 returned 0 after 16 usecs
[   14.321370] calling  iprange_mt_init+0x0/0x50 @ 1
[   14.326088] initcall iprange_mt_init+0x0/0x50 returned 0 after 5 usecs
[   14.332626] calling  length_mt_init+0x0/0x50 @ 1
[   14.337259] initcall length_mt_init+0x0/0x50 returned 0 after 4 usecs
[   14.343711] calling  limit_mt_init+0x0/0x40 @ 1
[   14.348256] initcall limit_mt_init+0x0/0x40 returned 0 after 3 usecs
[   14.354620] calling  multiport_mt_init+0x0/0x45 @ 1
[   14.359519] initcall multiport_mt_init+0x0/0x45 returned 0 after 6 usecs
[   14.366225] calling  xt_osf_init+0x0/0xbb @ 1
[   14.370600] initcall xt_osf_init+0x0/0xbb returned 0 after 4 usecs
[   14.376792] calling  xt_rateest_mt_init+0x0/0x40 @ 1
[   14.381773] initcall xt_rateest_mt_init+0x0/0x40 returned 0 after 2 usecs
[   14.388569] calling  string_mt_init+0x0/0x45 @ 1
[   14.393203] initcall string_mt_init+0x0/0x45 returned 0 after 4 usecs
[   14.399653] calling  time_mt_init+0x0/0xbb @ 1
[   14.404109] xt_time: kernel timezone is -0000
[   14.408479] initcall time_mt_init+0x0/0xbb returned 0 after 4267 usecs
[   14.415015] calling  sysctl_ipv4_init+0x0/0x76 @ 1
[   14.421962] initcall sysctl_ipv4_init+0x0/0x76 returned 0 after 2089 usecs
[   14.428845] calling  ipip_init+0x0/0x95 @ 1
[   14.433039] IPv4 over IPv4 tunneling driver
[   14.439876] initcall ipip_init+0x0/0x95 returned 0 after 6675 usecs
[   14.446155] calling  esp4_init+0x0/0xa0 @ 1
[   14.450360] initcall esp4_init+0x0/0xa0 returned 0 after 5 usecs
[   14.456376] calling  ipcomp4_init+0x0/0xa0 @ 1
[   14.460838] initcall ipcomp4_init+0x0/0xa0 returned 0 after 3 usecs
[   14.467115] calling  ipip_init+0x0/0xf0 @ 1
[   14.471315] initcall ipip_init+0x0/0xf0 returned 0 after 5 usecs
[   14.477334] calling  xfrm4_beet_init+0x0/0x50 @ 1
[   14.482056] initcall xfrm4_beet_init+0x0/0x50 returned 0 after 3 usecs
[   14.488591] calling  tunnel4_init+0x0/0xa0 @ 1
[   14.493059] initcall tunnel4_init+0x0/0xa0 returned 0 after 3 usecs
[   14.499340] calling  ipv4_netfilter_init+0x0/0x40 @ 1
[   14.504440] initcall ipv4_netfilter_init+0x0/0x40 returned 0 after 37 usecs
[   14.511412] calling  ip_tables_init+0x0/0xd1 @ 1
[   14.516158] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.521490] initcall ip_tables_init+0x0/0xd1 returned 0 after 5321 usecs
[   14.528200] calling  iptable_mangle_init+0x0/0x6c @ 1
[   14.533371] initcall iptable_mangle_init+0x0/0x6c returned 0 after 107 usecs
[   14.540435] calling  iptable_raw_init+0x0/0x6c @ 1
[   14.545288] initcall iptable_raw_init+0x0/0x6c returned 0 after 48 usecs
[   14.551997] calling  addrtype_mt_init+0x0/0x50 @ 1
[   14.556804] initcall addrtype_mt_init+0x0/0x50 returned 0 after 4 usecs
[   14.563429] calling  ah_mt_init+0x0/0x40 @ 1
[   14.567712] initcall ah_mt_init+0x0/0x40 returned 0 after 3 usecs
[   14.573812] calling  ecn_mt_init+0x0/0x40 @ 1
[   14.578183] initcall ecn_mt_init+0x0/0x40 returned 0 after 3 usecs
[   14.584378] calling  ecn_tg_init+0x0/0x40 @ 1
[   14.588748] initcall ecn_tg_init+0x0/0x40 returned 0 after 3 usecs
[   14.594939] calling  log_tg_init+0x0/0x60 @ 1
[   14.599314] initcall log_tg_init+0x0/0x60 returned 0 after 4 usecs
[   14.605506] calling  arp_tables_init+0x0/0xb3 @ 1
[   14.610300] arp_tables: (C) 2002 David S. Miller
[   14.614928] initcall arp_tables_init+0x0/0xb3 returned 0 after 4597 usecs
[   14.621721] calling  arpt_mangle_init+0x0/0x40 @ 1
[   14.626527] initcall arpt_mangle_init+0x0/0x40 returned 0 after 3 usecs
[   14.633158] calling  hstcp_register+0x0/0x40 @ 1
[   14.637790] TCP highspeed registered
[   14.641379] initcall hstcp_register+0x0/0x40 returned 0 after 3505 usecs
[   14.648084] calling  htcp_register+0x0/0x40 @ 1
[   14.652626] TCP htcp registered
[   14.655767] initcall htcp_register+0x0/0x40 returned 0 after 3069 usecs
[   14.662392] calling  tcp_vegas_register+0x0/0x40 @ 1
[   14.667368] TCP vegas registered
[   14.670612] initcall tcp_vegas_register+0x0/0x40 returned 0 after 3166 usecs
[   14.677663] calling  tcp_veno_register+0x0/0x40 @ 1
[   14.682555] TCP veno registered
[   14.685708] initcall tcp_veno_register+0x0/0x40 returned 0 after 3078 usecs
[   14.692674] calling  tcp_yeah_register+0x0/0x40 @ 1
[   14.697564] TCP yeah registered
[   14.700717] initcall tcp_yeah_register+0x0/0x40 returned 0 after 3078 usecs
[   14.707684] calling  tcp_illinois_register+0x0/0x3d @ 1
[   14.712921] TCP illinois registered
[   14.716423] initcall tcp_illinois_register+0x0/0x3d returned 0 after 3420 usecs
[   14.723735] calling  inet6_init+0x0/0x333 @ 1
[   14.731872] NET: Registered protocol family 10
[   14.756006] initcall inet6_init+0x0/0x333 returned 0 after 27240 usecs
[   14.762549] calling  tunnel6_init+0x0/0xa0 @ 1
[   14.767016] initcall tunnel6_init+0x0/0xa0 returned 0 after 3 usecs
[   14.773292] calling  ip6_tables_init+0x0/0xd1 @ 1
[   14.778100] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   14.783517] initcall ip6_tables_init+0x0/0xd1 returned 0 after 5381 usecs
[   14.790313] calling  ip6table_mangle_init+0x0/0x6c @ 1
[   14.795523] initcall ip6table_mangle_init+0x0/0x6c returned 0 after 58 usecs
[   14.802578] calling  ip6table_raw_init+0x0/0x6c @ 1
[   14.805220] hub 1-0:1.0: hub_suspend
[   14.805343] usb usb1: bus auto-suspend
[   14.805346] ehci_hcd 0000:00:02.1: suspend root hub
[   14.819731] initcall ip6table_raw_init+0x0/0x6c returned 0 after 63 usecs
[   14.826721] calling  frag_mt6_init+0x0/0x40 @ 1
[   14.831283] initcall frag_mt6_init+0x0/0x40 returned 0 after 17 usecs
[   14.837757] calling  ipv6header_mt6_init+0x0/0x40 @ 1
[   14.842821] initcall ipv6header_mt6_init+0x0/0x40 returned 0 after 3 usecs
[   14.849707] calling  rt_mt6_init+0x0/0x40 @ 1
[   14.854079] initcall rt_mt6_init+0x0/0x40 returned 0 after 3 usecs
[   14.860270] calling  log_tg6_init+0x0/0x55 @ 1
[   14.864732] initcall log_tg6_init+0x0/0x55 returned 0 after 5 usecs
[   14.871010] calling  ip6_tunnel_init+0x0/0xc8 @ 1
[   14.881162] initcall ip6_tunnel_init+0x0/0xc8 returned 0 after 5308 usecs
[   14.887966] calling  packet_init+0x0/0x73 @ 1
[   14.892341] NET: Registered protocol family 17
[   14.896891] initcall packet_init+0x0/0x73 returned 0 after 4445 usecs
[   14.903344] calling  dsa_init_module+0x0/0x40 @ 1
[   14.908064] initcall dsa_init_module+0x0/0x40 returned 0 after 3 usecs
[   14.914602] calling  edsa_init_module+0x0/0x40 @ 1
[   14.919407] initcall edsa_init_module+0x0/0x40 returned 0 after 2 usecs
[   14.926033] calling  trailer_init_module+0x0/0x40 @ 1
[   14.931107] initcall trailer_init_module+0x0/0x40 returned 0 after 2 usecs
[   14.937993] calling  mv88e6060_init+0x0/0x40 @ 1
[   14.942668] initcall mv88e6060_init+0x0/0x40 returned 0 after 42 usecs
[   14.949218] calling  mv88e6123_61_65_init+0x0/0x40 @ 1
[   14.954369] initcall mv88e6123_61_65_init+0x0/0x40 returned 0 after 2 usecs
[   14.961340] calling  mv88e6131_init+0x0/0x40 @ 1
[   14.965973] initcall mv88e6131_init+0x0/0x40 returned 0 after 2 usecs
[   14.972426] calling  dsa_init_module+0x0/0x40 @ 1
[   14.977572] initcall dsa_init_module+0x0/0x40 returned 0 after 420 usecs
[   14.984313] calling  ipx_init+0x0/0x140 @ 1
[   14.989692] NET: Registered protocol family 4
[   15.000253] initcall ipx_init+0x0/0x140 returned 0 after 11461 usecs
[   15.006623] calling  init_sunrpc+0x0/0x9a @ 1
[   15.013249] RPC: Registered udp transport module.
[   15.017983] RPC: Registered tcp transport module.
[   15.022711] initcall init_sunrpc+0x0/0x9a returned 0 after 11439 usecs
[   15.029321] calling  init_rpcsec_gss+0x0/0x75 @ 1
[   15.034250] initcall init_rpcsec_gss+0x0/0x75 returned 0 after 204 usecs
[   15.040970] calling  init_kerberos_module+0x0/0x57 @ 1
[   15.046261] initcall init_kerberos_module+0x0/0x57 returned 0 after 130 usecs
[   15.053413] calling  init_spkm3_module+0x0/0x5a @ 1
[   15.058352] initcall init_spkm3_module+0x0/0x5a returned 0 after 45 usecs
[   15.065150] calling  phonet_init+0x0/0xb0 @ 1
[   15.069556] NET: Registered protocol family 35
[   15.074192] initcall phonet_init+0x0/0xb0 returned 0 after 4561 usecs
[   15.080638] calling  pep_register+0x0/0x50 @ 1
[   15.086073] initcall pep_register+0x0/0x50 returned 0 after 950 usecs
[   15.092524] calling  vlan_proto_init+0x0/0xf0 @ 1
[   15.097244] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   15.104035] All bugs added by David S. Miller <davem@redhat.com>
[   15.110232] initcall vlan_proto_init+0x0/0xf0 returned 0 after 12681 usecs
[   15.117116] calling  tipc_init+0x0/0xda @ 1
[   15.121334] TIPC: Activated (version 1.6.4 compiled Aug 12 2009 22:41:53)
[   15.129618] NET: Registered protocol family 30
[   15.134095] TIPC: Started in single node mode
[   15.138468] initcall tipc_init+0x0/0xda returned 0 after 16747 usecs
[   15.144834] calling  dcbnl_init+0x0/0x5d @ 1
[   15.149125] initcall dcbnl_init+0x0/0x5d returned 0 after 2 usecs
[   15.155233] calling  cpufreq_p4_init+0x0/0x90 @ 1
[   15.159951] initcall cpufreq_p4_init+0x0/0x90 returned -19 after 1 usecs
[   15.166665] calling  hpet_insert_resource+0x0/0x4a @ 1
[   15.171816] initcall hpet_insert_resource+0x0/0x4a returned 1 after 1 usecs
[   15.178787] initcall hpet_insert_resource+0x0/0x4a returned with error code 1 
[   15.186022] calling  lapic_insert_resource+0x0/0x6f @ 1
[   15.191266] initcall lapic_insert_resource+0x0/0x6f returned 0 after 4 usecs
[   15.198325] calling  init_lapic_nmi_sysfs+0x0/0x60 @ 1
[   15.203474] initcall init_lapic_nmi_sysfs+0x0/0x60 returned 0 after 1 usecs
[   15.210448] calling  io_apic_bug_finalize+0x0/0x42 @ 1
[   15.215600] initcall io_apic_bug_finalize+0x0/0x42 returned 0 after 1 usecs
[   15.222573] calling  uv_init_heartbeat+0x0/0x6d @ 1
[   15.227462] initcall uv_init_heartbeat+0x0/0x6d returned 0 after 1 usecs
[   15.234170] calling  check_early_ioremap_leak+0x0/0xa5 @ 1
[   15.239667] initcall check_early_ioremap_leak+0x0/0xa5 returned 0 after 1 usecs
[   15.246987] calling  pat_memtype_list_init+0x0/0x50 @ 1
[   15.252316] initcall pat_memtype_list_init+0x0/0x50 returned 0 after 87 usecs
[   15.259546] calling  sched_init_debug+0x0/0x4d @ 1
[   15.264438] initcall sched_init_debug+0x0/0x4d returned 0 after 38 usecs
[   15.271163] calling  init_oops_id+0x0/0x60 @ 1
[   15.275652] initcall init_oops_id+0x0/0x60 returned 0 after 1 usecs
[   15.281949] calling  disable_boot_consoles+0x0/0x104 @ 1
[   15.287276] initcall disable_boot_consoles+0x0/0x104 returned 0 after 1 usecs
[   15.294425] calling  pm_qos_power_init+0x0/0x108 @ 1
[   15.301222] initcall pm_qos_power_init+0x0/0x108 returned 0 after 1768 usecs
[   15.308328] calling  debugfs_kprobe_init+0x0/0xb0 @ 1
[   15.313509] initcall debugfs_kprobe_init+0x0/0xb0 returned 0 after 112 usecs
[   15.320567] calling  kmemleak_late_init+0x0/0xae @ 1
[   15.325792] kmemleak: Kernel memory leak detector initialized
[   15.325798] kmemleak: Automatic memory scanning thread started
[   15.337515] initcall kmemleak_late_init+0x0/0xae returned 0 after 11691 usecs
[   15.344660] calling  init_ima+0x0/0x42 @ 1
[   15.349643] No TPM chip found, activating TPM-bypass!
[   15.355002] initcall init_ima+0x0/0x42 returned 0 after 6085 usecs
[   15.361273] calling  fail_io_timeout_debugfs+0x0/0x32 @ 1
[   15.366686] initcall fail_io_timeout_debugfs+0x0/0x32 returned -19 after 1 usecs
[   15.374092] calling  random32_reseed+0x0/0xc4 @ 1
[   15.378829] initcall random32_reseed+0x0/0xc4 returned 0 after 20 usecs
[   15.385459] calling  pci_resource_alignment_sysfs_init+0x0/0x45 @ 1
[   15.391754] initcall pci_resource_alignment_sysfs_init+0x0/0x45 returned 0 after 14 usecs
[   15.399936] calling  pci_sysfs_init+0x0/0x7d @ 1
[   15.405494] initcall pci_sysfs_init+0x0/0x7d returned 0 after 907 usecs
[   15.412124] calling  regulator_init_complete+0x0/0x17b @ 1
[   15.417653] initcall regulator_init_complete+0x0/0x17b returned 0 after 35 usecs
[   15.425062] calling  seqgen_init+0x0/0x40 @ 1
[   15.429448] initcall seqgen_init+0x0/0x40 returned 0 after 18 usecs
[   15.435720] calling  hd_init+0x0/0x378 @ 1
[   15.439925] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[   15.447989] initcall hd_init+0x0/0x378 returned -1 after 7967 usecs
[   15.454276] initcall hd_init+0x0/0x378 returned with error code -1 
[   15.460553] calling  scsi_complete_async_scans+0x0/0x1a0 @ 1
[   15.466220] initcall scsi_complete_async_scans+0x0/0x1a0 returned 0 after 1 usecs
[   15.473707] calling  rtc_hctosys+0x0/0x1b0 @ 1
[   15.478162] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   15.484438] initcall rtc_hctosys+0x0/0x1b0 returned -19 after 6129 usecs
[   15.491151] calling  memmap_init+0x0/0xd5 @ 1
[   15.496011] initcall memmap_init+0x0/0xd5 returned 0 after 475 usecs
[   15.502468] calling  pci_mmcfg_late_insert_resources+0x0/0x18b @ 1
[   15.508693] initcall pci_mmcfg_late_insert_resources+0x0/0x18b returned 0 after 18 usecs
[   15.516818] calling  init_net_drop_monitor+0x0/0x200 @ 1
[   15.522147] Initalizing network drop monitor service
[   15.527354] initcall init_net_drop_monitor+0x0/0x200 returned 0 after 5083 usecs
[   15.534763] calling  tcp_congestion_default+0x0/0x40 @ 1
[   15.540109] initcall tcp_congestion_default+0x0/0x40 returned 0 after 3 usecs
[   15.547255] calling  ip_auto_config+0x0/0x396 @ 1
[   15.552020] initcall ip_auto_config+0x0/0x396 returned 0 after 39 usecs
[   15.558649] calling  initialize_hashrnd+0x0/0x40 @ 1
[   15.563640] initcall initialize_hashrnd+0x0/0x40 returned 0 after 10 usecs
[   15.570585] async_waiting @ 1
[   15.573572] async_continuing @ 1 after 3 usec
[   15.580549] EXT3-fs: INFO: recovery required on readonly filesystem.
[   15.586977] EXT3-fs: write access will be enabled during recovery.
[   15.637745] kjournald starting.  Commit interval 5 seconds
[   15.637883] EXT3-fs: recovery complete.
[   15.638971] EXT3-fs: mounted filesystem with ordered data mode.
[   15.639129] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   15.639183] async_waiting @ 1
[   15.639191] async_continuing @ 1 after 2 usec
[   15.666966] Freeing unused kernel memory: 2608k freed
[   15.673931] Write protecting the kernel read-only data: 11716k
[   15.682203] Testing CPA: undo ffffffff81009000-ffffffff81b7a000
[   15.689639] Testing CPA: again
[   15.747384] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
modprobe: FATAL: Could not load /lib/modules/2.6.31-rc5-tip/modules.dep: No such file or directory

Mount failed for selinuxfs on /selinux:  No such device
INIT: version 2.86 booting
[   16.805500] hub 2-0:1.0: hub_suspend
[   16.809171] usb usb2: bus auto-suspend
[   16.812951] ohci_hcd 0000:00:02.0: suspend root hub
		Welcome to Fedora 
		Press 'I' to enter interactive startup.
modprobe: FATAL: Could not load /lib/modules/2.6.31-rc5-tip/modules.dep: No such file or directory

Cannot access the Hardware Clock via any known method.
Use the --debug option to see the details of our search for an access method.
Setting clock  (localtime): Thu Aug 13 04:41:07 CEST 2009 [  OK  ]
Starting udev: /sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
/sbin/start_udev: line 85: cannot redirect standard input from /dev/null: No such file or directory
[   18.616910] usb usb2: uevent
[   18.619993] usb 2-0:1.0: uevent
[   18.623978] usb usb1: uevent
[   18.627846] usb 1-0:1.0: uevent
[   21.361455] eth1: link down
[   21.364748] ADDRCONF(NETDEV_UP): eth1: link is not ready
[  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda6 
/1: clean, 375671/7325696 files, 3527212/7325632 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: clean, 134943/6111232 files, 2544295/12209392 blocks
[  OK  ]
Remounting root filesystem in read-write mode:  [   28.898125] EXT3 FS on sda6, internal journal
[  OK  ]
Mounting local filesystems:  [   29.042023] kjournald starting.  Commit interval 5 seconds
[   29.047994] EXT3 FS on sda5, internal journal
[   29.052401] EXT3-fs: mounted filesystem with ordered data mode.
[  OK  ]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  swapon: /dev/sda2: Function not implemented
[FAILED]
INIT: Entering runlevel: 3
Entering non-interactive startup
[   31.372019] eth0: no IPv6 routers present
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [  OK  ]
Starting system message bus: [   32.811546] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
[  OK  ]
Starting sshd: [  OK  ]
Starting postgresql service: [   35.189030] CPA self-test:
[   35.191913]  4k 3056 large 506 gb 0 x 3066[ffff880000000000-ffff88003fc00000] miss 0
[   35.221607]  4k 143344 large 232 gb 0 x 143080[ffff880000000000-ffff88003fdff000] miss 0
[   35.246221]  4k 143344 large 232 gb 0 x 143080[ffff880000000000-ffff88003fdff000] miss 0
[   35.254366] ok.
[FAILED]
testing CPU hotplug ...
/etc/rc3.d/S99local: line 9: /sys/devices/system/cpu/cpu1/online: No such file or directory
/etc/rc3.d/S99local: line 11: /sys/devices/system/cpu/cpu1/online: No such file or directory
/etc/rc3.d/S99local: line 13: /sys/devices/system/cpu/cpu1/online: No such file or directory
/etc/rc3.d/S99local: line 15: /sys/devices/system/cpu/cpu1/online: No such file or directory
... done with testing of CPU hotplug
cat: /debug/kernel_page_tables: No such file or directory
Shutting down Distributed Compiler daemon (distccd): [FAILED]
Starting Distributed Compiler daemon (distccd): [  OK  ]
/etc/rc3.d/S99local: line 27: /proc/sys/kernel/shmmax: No such file or directory
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host

 Performance counter stats for 'true':

  <not counted>  task-clock-msecs        
  <not counted>  context-switches        
  <not counted>  CPU-migrations          
  <not counted>  page-faults             
  <not counted>  cycles                  
  <not counted>  instructions            
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.026012249  seconds time elapsed


Fedora release 8 (Werewolf)
Kernel 2.6.31-rc5-tip on an x86_64

mercury login: ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
[   81.900051] BUG: unable to handle kernel paging request at ffff880020000000
[   81.901382] IP: [<ffffffff8112ae7e>] scan_block+0xee/0x190
[   81.901382] PGD 1002063 PUD 1006063 PMD 200001e2 
[   81.901382] Oops: 0000 [#1] SMP 
[   81.901382] last sysfs file: /sys/class/net/eth0/broadcast
[   81.901382] CPU 1 
[   81.901382] Modules linked in:
[   81.901382] Pid: 1508, comm: kmemleak Tainted: G        W  2.6.31-rc5-tip #3776 System Product Name
[   81.901382] RIP: 0010:[<ffffffff8112ae7e>]  [<ffffffff8112ae7e>] scan_block+0xee/0x190
[   81.901382] RSP: 0018:ffff88003d625da0  EFLAGS: 00010046
[   81.901382] RAX: ffff880020000000 RBX: ffff880020001000 RCX: 0000000000000000
[   81.901382] RDX: ffff88003f826b80 RSI: ffff880020001000 RDI: ffff880020000000
[   81.901382] RBP: ffff88003d625de0 R08: 0000000000000002 R09: ffff88003d61b038
[   81.901382] R10: ffff88003d61b7a0 R11: 0000000000000001 R12: ffff880020000000
[   81.901382] R13: 0000000000000246 R14: ffff880020000ff9 R15: 0000000000000000
[   81.901382] FS:  00007f9b585da780(0000) GS:ffff880002ae8000(0000) knlGS:00000000f7f6a6c0
[   81.901382] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   81.901382] CR2: ffff880020000000 CR3: 000000003d5eb000 CR4: 00000000000006a0
[   81.901382] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.901382] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.901382] Process kmemleak (pid: 1508, threadinfo ffff88003d624000, task ffff88003d61b000)
[   81.901382] Stack:
[   81.901382]  ffff88003f826b80 ffffffff81852f2c 000000003ddd3038 ffff880020001000
[   81.901382] <0> ffff88003f826b80 0000000000000246 ffff880024000000 0000000000000000
[   81.901382] <0> ffff88003d625e20 ffffffff8112b016 000000003ddd3038 000000003ddd3038
[   81.901382] Call Trace:
[   81.901382]  [<ffffffff81852f2c>] ? _spin_lock_irqsave+0x8c/0xc0
[   81.901382]  [<ffffffff8112b016>] scan_object+0xf6/0x140
[   81.901382]  [<ffffffff8112b412>] kmemleak_scan+0x3b2/0x6b0
[   81.901382]  [<ffffffff8112b060>] ? kmemleak_scan+0x0/0x6b0
[   81.901382]  [<ffffffff8112be50>] ? kmemleak_scan_thread+0x0/0x100
[   81.901382]  [<ffffffff8112bebb>] kmemleak_scan_thread+0x6b/0x100
[   81.901382]  [<ffffffff810a0176>] kthread+0xb6/0xd0
[   81.901382]  [<ffffffff810305ca>] child_rip+0xa/0x20
[   81.901382]  [<ffffffff8102ff50>] ? restore_args+0x0/0x30
[   81.901382]  [<ffffffff810a00c0>] ? kthread+0x0/0xd0
[   81.901382]  [<ffffffff810305c0>] ? child_rip+0x0/0x20
[   81.901382] Code: 41 b3 a6 00 48 8d 7b 58 48 c7 c2 90 61 b9 81 e8 89 5a 20 00 4c 89 ee 48 89 df e8 9e 7b 72 00 49 83 c4 08 4d 39 e6 76 35 45 85 ff <49> 8b 1c 24 0f 84 50 ff ff ff 31 d2 be 7b 03 00 00 48 c7 c7 00 
[   81.901382] RIP  [<ffffffff8112ae7e>] scan_block+0xee/0x190
[   81.901382]  RSP <ffff88003d625da0>
[   81.901382] CR2: ffff880020000000
[   81.901382] ---[ end trace 6d450e935ee1897e ]---
[   81.901382] Kernel panic - not syncing: Fatal exception
[   81.901382] Pid: 1508, comm: kmemleak Tainted: G      D W  2.6.31-rc5-tip #3776
[   81.901382] Call Trace:
[   81.901382]  [<ffffffff8184ee14>] panic+0x84/0x160
[   81.901382]  [<ffffffff8185487a>] oops_end+0xba/0x110
[   81.901382]  [<ffffffff8105d599>] no_context+0x109/0x1b0
[   81.901382]  [<ffffffff8105d7ad>] __bad_area_nosemaphore+0x16d/0x210
[   81.901382]  [<ffffffff810b83c4>] ? mark_held_locks+0x84/0xc0
[   81.901382]  [<ffffffff810b9bf4>] ? __lock_acquire+0x304/0x5c0
[   81.901382]  [<ffffffff8105d871>] bad_area_nosemaphore+0x21/0x40
[   81.901382]  [<ffffffff81856abe>] do_page_fault+0x29e/0x350
[   81.901382]  [<ffffffff81852402>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   81.901382]  [<ffffffff81853875>] page_fault+0x25/0x30
[   81.901382]  [<ffffffff8112ae7e>] ? scan_block+0xee/0x190
[   81.901382]  [<ffffffff81852f2c>] ? _spin_lock_irqsave+0x8c/0xc0
[   81.901382]  [<ffffffff8112b016>] scan_object+0xf6/0x140
[   81.901382]  [<ffffffff8112b412>] kmemleak_scan+0x3b2/0x6b0
[   81.901382]  [<ffffffff8112b060>] ? kmemleak_scan+0x0/0x6b0
[   81.901382]  [<ffffffff8112be50>] ? kmemleak_scan_thread+0x0/0x100
[   81.901382]  [<ffffffff8112bebb>] kmemleak_scan_thread+0x6b/0x100
[   81.901382]  [<ffffffff810a0176>] kthread+0xb6/0xd0
[   81.901382]  [<ffffffff810305ca>] child_rip+0xa/0x20
[   81.901382]  [<ffffffff8102ff50>] ? restore_args+0x0/0x30
[   81.901382]  [<ffffffff810a00c0>] ? kthread+0x0/0xd0
[   81.901382]  [<ffffffff810305c0>] ? child_rip+0x0/0x20
[   81.901382] Rebooting in 1 seconds..Press any key to enter the menu

--oyUTqETQ0mS9luUI--
