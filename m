Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZFKKyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZFKKyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbZFKKyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:54:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762029AbZFKKxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:53:45 -0400
Date: Thu, 11 Jun 2009 12:52:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, mark.langsdorf@amd.com
Subject: Re: S06cpuspeed/2637 is trying to acquire lock
	(&(&dbs_info->work)->work (was: Re: [PATCH 4/6] x86/cpufreq: use
	cpumask_copy instead of =)
Message-ID: <20090611105211.GA6760@elte.hu>
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <200906101552.17397.rusty@rustcorp.com.au> <20090610111035.GG27724@elte.hu> <20090610205848.GA1445@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610205848.GA1445@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> On Wed, Jun 10, 2009 at 01:10:35PM +0200, Ingo Molnar wrote:
>  > 
>  > With a v2.6.30 based kernel i'm still getting a cpufreq lockdep 
>  > warning:
>  > 
>  >  =======================================================
>  >  [ INFO: possible circular locking dependency detected ]
>  >  2.6.30-tip #10420
>  >  -------------------------------------------------------
>  >  S06cpuspeed/2637 is trying to acquire lock:
>  >   (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff8106553d>] __cancel_work_timer+0xd6/0x22a
>  > 
>  >  but task is already holding lock:
>  >   (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335
>  > 
>  > This bug got introduced somewhere late in the .30-rc cycle, this box 
>  > was fine before.
> 
> See the thread " [PATCH] remove rwsem lock from CPUFREQ_GOV_STOP 
> call (second call site)" Though there's a report that the last 
> patch posted still doesn't fix the problem, so we still don't have 
> a quick fix suitable for -stable.

even with latest -git (which includes cpufreq fixes) i get:

[   54.819413] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
[   55.216665] 
[   55.216668] =======================================================
[   55.216963] [ INFO: possible circular locking dependency detected ]
[   55.217134] 2.6.30-tip #5836
[   55.217276] -------------------------------------------------------
[   55.217428] S99local/4262 is trying to acquire lock:
[   55.217577]  (&(&dbs_info->work)->work){+.+...}, at: [<4104261f>] __cancel_work_timer+0xb8/0x1e9
[   55.218065] 
[   55.218068] but task is already holding lock:
[   55.218351]  (dbs_mutex){+.+.+.}, at: [<4157bd6b>] cpufreq_governor_dbs+0x25d/0x2e4
[   55.218358] 

full bootlog below. Can test fixes.

	Ingo

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-tip (mingo@europe) (gcc version 4.2.2) #5836 SMP Thu Jun 11 02:27:14 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6e0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   2 base 07F800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f6e0000 (usable)
[    0.000000]  modified: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
[    0.000000]  modified: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
[    0.000000]  modified: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  modified: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 02800000
[    0.000000] init_memory_mapping: 0000000000000000-000000007f6e0000
[    0.000000]  0000000000 - 007f6e0000 page 4k
[    0.000000] kernel direct mapping tables up to 7f6e0000 @ 100000-301000
[    0.000000] ACPI: RSDP 000f68a0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 7f6e631f 00074 (v01 LENOVO TP-79    00001020  LTP 00000000)
[    0.000000] ACPI: FACP 7f6e6400 000F4 (v03 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI Warning (tbfadt-0531): 32/64X length mismatch in Gpe1Block: 0/32 [20090320]
[    0.000000] ACPI Warning (tbfadt-0562): Optional field Gpe1Block has zero address or length: 000000000000102C/0 [20090320]
[    0.000000] ACPI: DSDT 7f6e65e7 0C765 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
[    0.000000] ACPI: FACS 7f6f4000 00040
[    0.000000] ACPI: SSDT 7f6e65b4 00033 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
[    0.000000] ACPI: ECDT 7f6f2d4c 00052 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: TCPA 7f6f2d9e 00032 (v02 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: APIC 7f6f2dd0 00068 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: MCFG 7f6f2e38 0003E (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: HPET 7f6f2e76 00038 (v01 LENOVO TP-79    00001020 LNVO 00000001)
[    0.000000] ACPI: BOOT 7f6f2fd8 00028 (v01 LENOVO TP-79    00001020  LTP 00000001)
[    0.000000] ACPI: SSDT 7f6e58da 00507 (v01 LENOVO TP-79    00001020 INTL 20050513)
[    0.000000] ACPI: SSDT 7f6e5702 001D8 (v01 LENOVO TP-79    00001020 INTL 20050513)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2038MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 7f6e0000
[    0.000000]   low ram: 0 - 7f6e0000
[    0.000000]   node 0 low ram: 00000000 - 7f6e0000
[    0.000000]   node 0 bootmap 00007000 - 00016edc
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 007f6e0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00022aab34]    TEXT DATA BSS ==> [0001000000 - 00022aab34]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [00022ab000 - 00022b5138]              BRK ==> [00022ab000 - 00022b5138]
[    0.000000]   #6 [0000100000 - 00002f4000]          PGTABLE ==> [0000100000 - 00002f4000]
[    0.000000]   #7 [0000007000 - 0000017000]          BOOTMAP ==> [0000007000 - 0000017000]
[    0.000000] Scan SMP from 40000000 for 1024 bytes.
[    0.000000] Scan SMP from 4009fc00 for 1024 bytes.
[    0.000000] Scan SMP from 400f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [400f68e0] f68e0
[    0.000000]   mpc: 9f5a1-9f6b5
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0007f6e0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f6e0
[    0.000000] On node 0 totalpages: 521851
[    0.000000] free_area_init_node: node 0, pgdat 41aaf570, node_mem_map 422b6000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3943 pages, LIFO batch:0
[    0.000000]   Normal zone: 6575 pages used for memmap
[    0.000000]   Normal zone: 511281 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 15 pages at 43caf000, static data 37804 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515224
[    0.000000] Kernel command line: root=/dev/sda1 console=tty profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=1 relaxed_check=1 3 netconsole=4444@10.0.1.15/eth0,4444@10.0.1.21/00:30:48:c6:86:26
[    0.000000] debug: sysrq always enabled.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:1280
[    0.000000] CPU 0 irqstacks, hard=43caf000 soft=43cb0000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1828.480 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.003333] ... MAX_LOCKDEP_CHAINS:      32768
[    0.003333] ... CHAINHASH_SIZE:          16384
[    0.003333]  memory used by lock dependency info: 3487 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333] ----------------------------------------------------------------------------
[    0.003333]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]               recursive read-lock:             |  ok  |             |  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq read-recursion/123:  ok  |
[    0.003333]       soft-irq read-recursion/123:  ok  |
[    0.003333]       hard-irq read-recursion/132:  ok  |
[    0.003333]       soft-irq read-recursion/132:  ok  |
[    0.003333]       hard-irq read-recursion/213:  ok  |
[    0.003333]       soft-irq read-recursion/213:  ok  |
[    0.003333]       hard-irq read-recursion/231:  ok  |
[    0.003333]       soft-irq read-recursion/231:  ok  |
[    0.003333]       hard-irq read-recursion/312:  ok  |
[    0.003333]       soft-irq read-recursion/312:  ok  |
[    0.003333]       hard-irq read-recursion/321:  ok  |
[    0.003333]       soft-irq read-recursion/321:  ok  |
[    0.003333] -------------------------------------------------------
[    0.003333] Good, all 218 testcases passed! |
[    0.003333] ---------------------------------
[    0.003333] Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
[    0.003333] Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Memory: 2037632k/2087808k available (7029k kernel code, 49528k reserved, 4386k data, 536k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
[    0.003333]     vmalloc : 0xbfee0000 - 0xffe15000   (1023 MB)
[    0.003333]     lowmem  : 0x40000000 - 0xbf6e0000   (2038 MB)
[    0.003333]       .init : 0x41b2d000 - 0x41bb3000   ( 536 kB)
[    0.003333]       .data : 0x416dd647 - 0x41b25ff8   (4386 kB)
[    0.003333]       .text : 0x41000000 - 0x416dd647   (7029 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.003333] ODEBUG: 7 of 7 active objects replaced
[    0.003333] hpet clockevent registered
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 3658.33 BogoMIPS (lpj=6094933)
[    0.003333] Security Framework initialized
[    0.003333] TOMOYO Linux initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys debug
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys freezer
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] using mwait in idle threads.
[    0.003333] Checking 'hlt' instruction... OK.
[    0.016016] ACPI: Core revision 20090320
[    0.056681] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.056777] ftrace: allocating 23618 entries in 47 pages
[    0.060235] enabled ExtINT on CPU#0
[    0.060541] ESR value before enabling vector: 0x00000040  after: 0x00000000
[    0.060635] ENABLING IO-APIC IRQs
[    0.060722] init IO_APIC IRQs
[    0.060808]  1-0 (apicid-pin) not connected
[    0.060952] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.061091] IOAPIC[0]: Set routing entry (1-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
[    0.061226] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.061362] IOAPIC[0]: Set routing entry (1-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
[    0.061499] IOAPIC[0]: Set routing entry (1-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
[    0.061635] IOAPIC[0]: Set routing entry (1-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
[    0.061771] IOAPIC[0]: Set routing entry (1-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
[    0.061908] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.062044] IOAPIC[0]: Set routing entry (1-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
[    0.062180] IOAPIC[0]: Set routing entry (1-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
[    0.062318] IOAPIC[0]: Set routing entry (1-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
[    0.062454] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.062591] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.063344] IOAPIC[0]: Set routing entry (1-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
[    0.063481] IOAPIC[0]: Set routing entry (1-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
[    0.063616]  1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 (apicid-pin) not connected
[    0.064334] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.097457] CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.098413] Using local APIC timer interrupts.
[    0.098415] calibrating APIC timer ...
[    0.099999] ... lapic delta = 1039057
[    0.099999] ... PM-Timer delta = 357952
[    0.099999] ... PM-Timer result ok
[    0.099999] ..... delta 1039057
[    0.099999] ..... mult: 44630068
[    0.099999] ..... calibration result: 554163
[    0.099999] ..... CPU clock speed is 1828.3076 MHz.
[    0.099999] ..... host bus clock speed is 166.0885 MHz.
[    0.099999] calling  migration_init+0x0/0x40 @ 1
[    0.099999] initcall migration_init+0x0/0x40 returned 1 after 0 usecs
[    0.099999] initcall migration_init+0x0/0x40 returned with error code 1 
[    0.099999] calling  spawn_ksoftirqd+0x0/0x3c @ 1
[    0.099999] initcall spawn_ksoftirqd+0x0/0x3c returned 0 after 0 usecs
[    0.099999] calling  init_call_single_data+0x0/0x81 @ 1
[    0.099999] initcall init_call_single_data+0x0/0x81 returned 0 after 0 usecs
[    0.099999] calling  spawn_softlockup_task+0x0/0x5e @ 1
[    0.099999] initcall spawn_softlockup_task+0x0/0x5e returned 0 after 0 usecs
[    0.099999] calling  relay_init+0x0/0x11 @ 1
[    0.099999] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.099999] calling  tracer_alloc_buffers+0x0/0x121 @ 1
[    0.099999] initcall tracer_alloc_buffers+0x0/0x121 returned 0 after 0 usecs
[    0.099999] calling  init_trace_printk+0x0/0xf @ 1
[    0.099999] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.099999] calling  trace_workqueue_early_init+0x0/0xf5 @ 1
[    0.099999] initcall trace_workqueue_early_init+0x0/0xf5 returned 0 after 0 usecs
[    0.099999] lockdep: fixing up alternatives.
[    0.099999] CPU 1 irqstacks, hard=43cbf000 soft=43cc0000
[    0.099999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] masked ExtINT on CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3658.92 BogoMIPS (lpj=6095875)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.193930] CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.194765] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.196666] Measured 579656 cycles TSC warp between CPUs, turning off TSC clock.
[    0.196666] Marking TSC unstable due to check_tsc_sync_source failed
[    0.196832] Brought up 2 CPUs
[    0.196925] Total of 2 processors activated (7317.25 BogoMIPS).
[    0.197135] CPU0 attaching sched-domain:
[    0.197226]  domain 0: span 0-1 level MC
[    0.197358]   groups: 0 1
[    0.197606] CPU1 attaching sched-domain:
[    0.197695]  domain 0: span 0-1 level MC
[    0.197827]   groups: 1 0
[    0.200377] device: 'platform': device_add
[    0.200507] PM: Adding info for No Bus:platform
[    0.201333] bus: 'platform': registered
[    0.201427] Registering sysdev class 'cpu'
[    0.201915] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.202017] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.202148] calling  net_ns_init+0x0/0xce @ 1
[    0.202237] net_namespace: 1116 bytes
[    0.202514] initcall net_ns_init+0x0/0xce returned 0 after 0 usecs
[    0.202610] calling  e820_mark_nvs_memory+0x0/0x37 @ 1
[    0.202707] initcall e820_mark_nvs_memory+0x0/0x37 returned 0 after 0 usecs
[    0.202802] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.202891] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.202985] calling  reboot_init+0x0/0x11 @ 1
[    0.203081] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.203174] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    0.203263] Registering sysdev class 'lapic'
[    0.203454] Registering sys device of class 'lapic'
[    0.203552] Registering sys device 'lapic0'
[    0.203779] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 3255 usecs
[    0.203876] calling  print_banner+0x0/0xd @ 1
[    0.203964] Booting paravirtualized kernel on bare hardware
[    0.204056] initcall print_banner+0x0/0xd returned 0 after 0 usecs
[    0.204151] calling  init_smp_flush+0x0/0x2f @ 1
[    0.204243] initcall init_smp_flush+0x0/0x2f returned 0 after 0 usecs
[    0.204338] calling  alloc_frozen_cpus+0x0/0xc @ 1
[    0.204428] initcall alloc_frozen_cpus+0x0/0xc returned 0 after 0 usecs
[    0.204522] calling  sysctl_init+0x0/0x13 @ 1
[    0.204615] initcall sysctl_init+0x0/0x13 returned 0 after 0 usecs
[    0.204708] calling  ksysfs_init+0x0/0x96 @ 1
[    0.204820] initcall ksysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.204914] calling  async_init+0x0/0x6c @ 1
[    0.205003] initcall async_init+0x0/0x6c returned 0 after 0 usecs
[    0.205096] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.205191] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.205323] calling  pm_init+0x0/0x2d @ 1
[    0.205427] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.205520] calling  pm_disk_init+0x0/0x14 @ 1
[    0.205618] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.205713] calling  swsusp_header_init+0x0/0x2b @ 1
[    0.205806] initcall swsusp_header_init+0x0/0x2b returned 0 after 0 usecs
[    0.205902] calling  init_hw_breakpoint+0x0/0xf @ 1
[    0.206135] initcall init_hw_breakpoint+0x0/0xf returned 0 after 0 usecs
[    0.206230] calling  filelock_init+0x0/0x27 @ 1
[    0.206321] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.206415] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.206534] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.206629] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.206674] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.206768] calling  debugfs_init+0x0/0x4a @ 1
[    0.206866] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    0.206961] calling  securityfs_init+0x0/0x41 @ 1
[    0.207057] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.207152] calling  random32_init+0x0/0xa2 @ 1
[    0.207243] initcall random32_init+0x0/0xa2 returned 0 after 0 usecs
[    0.207337] calling  early_resume_init+0x0/0x187 @ 1
[    0.207456] Time:  0:28:04  Date: 06/11/09
[    0.207545] initcall early_resume_init+0x0/0x187 returned 0 after 0 usecs
[    0.207640] calling  cpufreq_core_init+0x0/0x5f @ 1
[    0.207733] initcall cpufreq_core_init+0x0/0x5f returned 0 after 0 usecs
[    0.207827] calling  cpuidle_init+0x0/0x32 @ 1
[    0.207927] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.208022] calling  virtio_init+0x0/0x24 @ 1
[    0.208242] bus: 'virtio': registered
[    0.208332] initcall virtio_init+0x0/0x24 returned 0 after 0 usecs
[    0.208426] calling  sock_init+0x0/0x51 @ 1
[    0.208737] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.208829] calling  net_inuse_init+0x0/0x1f @ 1
[    0.208947] initcall net_inuse_init+0x0/0x1f returned 0 after 0 usecs
[    0.209041] calling  netpoll_init+0x0/0x39 @ 1
[    0.209132] initcall netpoll_init+0x0/0x39 returned 0 after 0 usecs
[    0.209225] calling  netlink_proto_init+0x0/0x171 @ 1
[    0.209387] NET: Registered protocol family 16
[    0.209618] initcall netlink_proto_init+0x0/0x171 returned 0 after 0 usecs
[    0.209713] calling  olpc_init+0x0/0x103 @ 1
[    0.209802] initcall olpc_init+0x0/0x103 returned 0 after 0 usecs
[    0.209896] calling  bdi_class_init+0x0/0x35 @ 1
[    0.210005] device class 'bdi': registering
[    0.210533] initcall bdi_class_init+0x0/0x35 returned 0 after 0 usecs
[    0.210629] calling  kobject_uevent_init+0x0/0x4e @ 1
[    0.210732] initcall kobject_uevent_init+0x0/0x4e returned 0 after 0 usecs
[    0.210827] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.210916] device class 'pci_bus': registering
[    0.211144] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.211239] calling  pci_driver_init+0x0/0xf @ 1
[    0.211466] bus: 'pci': registered
[    0.211556] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.211650] calling  backlight_class_init+0x0/0x70 @ 1
[    0.211741] device class 'backlight': registering
[    0.211963] initcall backlight_class_init+0x0/0x70 returned 0 after 0 usecs
[    0.212059] calling  video_output_class_init+0x0/0x14 @ 1
[    0.212149] device class 'video_output': registering
[    0.212368] initcall video_output_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.212500] calling  tty_class_init+0x0/0x40 @ 1
[    0.212590] device class 'tty': registering
[    0.212802] initcall tty_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.212896] calling  vtconsole_class_init+0x0/0xf4 @ 1
[    0.212986] device class 'vtconsole': registering
[    0.213201] device: 'vtcon0': device_add
[    0.213388] PM: Adding info for No Bus:vtcon0
[    0.213685] initcall vtconsole_class_init+0x0/0xf4 returned 0 after 3255 usecs
[    0.213818] calling  i2c_init+0x0/0x54 @ 1
[    0.214046] bus: 'i2c': registered
[    0.214133] device class 'i2c-adapter': registering
[    0.214344] bus: 'i2c': add driver dummy
[    0.214591] i2c-core: driver [dummy] registered
[    0.214702] initcall i2c_init+0x0/0x54 returned 0 after 0 usecs
[    0.214795] calling  lguest_devices_init+0x0/0x17f @ 1
[    0.214887] initcall lguest_devices_init+0x0/0x17f returned 0 after 0 usecs
[    0.214982] calling  amd_postcore_init+0x0/0x66 @ 1
[    0.215075] initcall amd_postcore_init+0x0/0x66 returned 0 after 0 usecs
[    0.215169] calling  arch_kdebugfs_init+0x0/0x23f @ 1
[    0.215310] initcall arch_kdebugfs_init+0x0/0x23f returned 0 after 0 usecs
[    0.215405] calling  init_pit_clocksource+0x0/0x91 @ 1
[    0.215497] initcall init_pit_clocksource+0x0/0x91 returned 0 after 0 usecs
[    0.215592] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.215689] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.215783] calling  ffh_cstate_init+0x0/0x27 @ 1
[    0.215876] initcall ffh_cstate_init+0x0/0x27 returned 0 after 0 usecs
[    0.215971] calling  acpi_pci_init+0x0/0x4c @ 1
[    0.216088] ACPI: bus type pci registered
[    0.216179] initcall acpi_pci_init+0x0/0x4c returned 0 after 0 usecs
[    0.216274] calling  dmi_id_init+0x0/0x2c3 @ 1
[    0.216364] device class 'dmi': registering
[    0.216812] device: 'id': device_add
[    0.216973] PM: Adding info for No Bus:id
[    0.217249] initcall dmi_id_init+0x0/0x2c3 returned 0 after 3255 usecs
[    0.217344] calling  dma_bus_init+0x0/0x32 @ 1
[    0.217434] device class 'dma': registering
[    0.217652] initcall dma_bus_init+0x0/0x32 returned 0 after 0 usecs
[    0.217746] calling  dma_channel_table_init+0x0/0xdf @ 1
[    0.217885] initcall dma_channel_table_init+0x0/0xdf returned 0 after 0 usecs
[    0.217980] calling  pci_arch_init+0x0/0x4e @ 1
[    0.218200] PCI: PCI BIOS revision 2.10 entry at 0xfd84b, last bus=24
[    0.218293] PCI: Using configuration type 1 for base access
[    0.218394] initcall pci_arch_init+0x0/0x4e returned 0 after 0 usecs
[    0.218487] calling  topology_init+0x0/0x36 @ 1
[    0.218576] Registering sys device of class 'cpu'
[    0.218672] Registering sys device 'cpu0'
[    0.218885] Registering sys device of class 'cpu'
[    0.218980] Registering sys device 'cpu1'
[    0.219187] initcall topology_init+0x0/0x36 returned 0 after 0 usecs
[    0.219281] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.219373] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.220006] calling  mca_init+0x0/0x441 @ 1
[    0.220229] bus: 'MCA': registered
[    0.220319] initcall mca_init+0x0/0x441 returned -19 after 0 usecs
[    0.220413] calling  param_sysfs_init+0x0/0x1c1 @ 1
[    0.250700] initcall param_sysfs_init+0x0/0x1c1 returned 0 after 29296 usecs
[    0.250800] calling  pm_sysrq_init+0x0/0x1b @ 1
[    0.250914] initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
[    0.251008] calling  init_slow_work+0x0/0x2f @ 1
[    0.251100] initcall init_slow_work+0x0/0x2f returned 0 after 0 usecs
[    0.251194] calling  default_bdi_init+0x0/0x2f @ 1
[    0.251300] device: 'default': device_add
[    0.251415] PM: Adding info for No Bus:default
[    0.251693] initcall default_bdi_init+0x0/0x2f returned 0 after 0 usecs
[    0.251788] calling  init_bio+0x0/0x10d @ 1
[    0.251949] bio: create slab <bio-0> at 0
[    0.252052] initcall init_bio+0x0/0x10d returned 0 after 0 usecs
[    0.252145] calling  cryptomgr_init+0x0/0x29 @ 1
[    0.252255] initcall cryptomgr_init+0x0/0x29 returned 0 after 0 usecs
[    0.252349] calling  blk_settings_init+0x0/0x1d @ 1
[    0.252441] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.252535] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.252630] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.252723] calling  blk_softirq_init+0x0/0x5b @ 1
[    0.252817] initcall blk_softirq_init+0x0/0x5b returned 0 after 0 usecs
[    0.252911] calling  genhd_device_init+0x0/0x69 @ 1
[    0.253001] device class 'block': registering
[    0.253274] initcall genhd_device_init+0x0/0x69 returned 0 after 0 usecs
[    0.253446] calling  gpiolib_debugfs_init+0x0/0x1f @ 1
[    0.253550] initcall gpiolib_debugfs_init+0x0/0x1f returned 0 after 0 usecs
[    0.253645] calling  pca953x_init+0x0/0x11 @ 1
[    0.253736] bus: 'i2c': add driver pca953x
[    0.254092] i2c-core: driver [pca953x] registered
[    0.254187] initcall pca953x_init+0x0/0x11 returned 0 after 0 usecs
[    0.254281] calling  pcf857x_init+0x0/0x11 @ 1
[    0.254370] bus: 'i2c': add driver pcf857x
[    0.254580] i2c-core: driver [pcf857x] registered
[    0.254675] initcall pcf857x_init+0x0/0x11 returned 0 after 0 usecs
[    0.254770] calling  pci_slot_init+0x0/0x40 @ 1
[    0.254868] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    0.254962] calling  fbmem_init+0x0/0x96 @ 1
[    0.255097] device class 'graphics': registering
[    0.255306] initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
[    0.255400] calling  acpi_init+0x0/0x259 @ 1
[    0.264227] ACPI: EC: EC description table is found, configuring boot EC
[    0.294708] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.306939] ACPI: Interpreter enabled
[    0.307034] ACPI: (supports S0 S3 S4 S5)
[    0.307630] ACPI: Using IOAPIC for interrupt routing
[    0.307972] bus: 'acpi': registered
[    0.308142] device: 'LNXSYSTM:00': device_add
[    0.308264] bus: 'acpi': add device LNXSYSTM:00
[    0.308370] PM: Adding info for acpi:LNXSYSTM:00
[    0.308611] device: 'LNXPWRBN:00': device_add
[    0.308708] bus: 'acpi': add device LNXPWRBN:00
[    0.308814] PM: Adding info for acpi:LNXPWRBN:00
[    0.309078] device: 'ACPI_CPU:00': device_add
[    0.309175] bus: 'acpi': add device ACPI_CPU:00
[    0.309280] PM: Adding info for acpi:ACPI_CPU:00
[    0.309573] device: 'ACPI_CPU:01': device_add
[    0.309670] bus: 'acpi': add device ACPI_CPU:01
[    0.309775] PM: Adding info for acpi:ACPI_CPU:01
[    0.310104] device: 'device:00': device_add
[    0.310200] bus: 'acpi': add device device:00
[    0.310305] PM: Adding info for acpi:device:00
[    0.310399] device: 'device:00': dev_uevent: bus uevent() returned -12
[    0.311217] device: 'PNP0C0F:00': device_add
[    0.311313] bus: 'acpi': add device PNP0C0F:00
[    0.311418] PM: Adding info for acpi:PNP0C0F:00
[    0.312327] device: 'PNP0C0F:01': device_add
[    0.312424] bus: 'acpi': add device PNP0C0F:01
[    0.312529] PM: Adding info for acpi:PNP0C0F:01
[    0.313487] device: 'PNP0C0F:02': device_add
[    0.313585] bus: 'acpi': add device PNP0C0F:02
[    0.313691] PM: Adding info for acpi:PNP0C0F:02
[    0.314599] device: 'PNP0C0F:03': device_add
[    0.314698] bus: 'acpi': add device PNP0C0F:03
[    0.314802] PM: Adding info for acpi:PNP0C0F:03
[    0.315710] device: 'PNP0C0F:04': device_add
[    0.315809] bus: 'acpi': add device PNP0C0F:04
[    0.315913] PM: Adding info for acpi:PNP0C0F:04
[    0.316831] device: 'PNP0C0F:05': device_add
[    0.316929] bus: 'acpi': add device PNP0C0F:05
[    0.317034] PM: Adding info for acpi:PNP0C0F:05
[    0.317943] device: 'PNP0C0F:06': device_add
[    0.318040] bus: 'acpi': add device PNP0C0F:06
[    0.318146] PM: Adding info for acpi:PNP0C0F:06
[    0.319080] device: 'PNP0C0F:07': device_add
[    0.319178] bus: 'acpi': add device PNP0C0F:07
[    0.319284] PM: Adding info for acpi:PNP0C0F:07
[    0.319617] device: 'PNP0C01:00': device_add
[    0.319714] bus: 'acpi': add device PNP0C01:00
[    0.319819] PM: Adding info for acpi:PNP0C01:00
[    0.321620] device: 'PNP0C0D:00': device_add
[    0.321718] bus: 'acpi': add device PNP0C0D:00
[    0.321824] PM: Adding info for acpi:PNP0C0D:00
[    0.324242] device: 'PNP0C0E:00': device_add
[    0.324340] bus: 'acpi': add device PNP0C0E:00
[    0.324446] PM: Adding info for acpi:PNP0C0E:00
[    0.324778] device: 'PNP0A08:00': device_add
[    0.324874] bus: 'acpi': add device PNP0A08:00
[    0.324981] PM: Adding info for acpi:PNP0A08:00
[    0.325360] device: 'device:01': device_add
[    0.325457] bus: 'acpi': add device device:01
[    0.325562] PM: Adding info for acpi:device:01
[    0.325656] device: 'device:01': dev_uevent: bus uevent() returned -12
[    0.325865] device: 'PNP0C02:00': device_add
[    0.325962] bus: 'acpi': add device PNP0C02:00
[    0.326067] PM: Adding info for acpi:PNP0C02:00
[    0.326531] device: 'PNP0000:00': device_add
[    0.326627] bus: 'acpi': add device PNP0000:00
[    0.326694] PM: Adding info for acpi:PNP0000:00
[    0.327009] device: 'PNP0100:00': device_add
[    0.327105] bus: 'acpi': add device PNP0100:00
[    0.327211] PM: Adding info for acpi:PNP0100:00
[    0.327796] device: 'PNP0103:00': device_add
[    0.327892] bus: 'acpi': add device PNP0103:00
[    0.327998] PM: Adding info for acpi:PNP0103:00
[    0.328317] device: 'PNP0200:00': device_add
[    0.328414] bus: 'acpi': add device PNP0200:00
[    0.328520] PM: Adding info for acpi:PNP0200:00
[    0.328834] device: 'PNP0800:00': device_add
[    0.328932] bus: 'acpi': add device PNP0800:00
[    0.329038] PM: Adding info for acpi:PNP0800:00
[    0.329355] device: 'PNP0C04:00': device_add
[    0.329452] bus: 'acpi': add device PNP0C04:00
[    0.329558] PM: Adding info for acpi:PNP0C04:00
[    0.329871] device: 'PNP0B00:00': device_add
[    0.330013] bus: 'acpi': add device PNP0B00:00
[    0.330125] PM: Adding info for acpi:PNP0B00:00
[    0.330438] device: 'PNP0303:00': device_add
[    0.330535] bus: 'acpi': add device PNP0303:00
[    0.330641] PM: Adding info for acpi:PNP0303:00
[    0.330962] device: 'IBM0057:00': device_add
[    0.331062] bus: 'acpi': add device IBM0057:00
[    0.331167] PM: Adding info for acpi:IBM0057:00
[    0.334155] device: 'IBM0071:00': device_add
[    0.334253] bus: 'acpi': add device IBM0071:00
[    0.334359] PM: Adding info for acpi:IBM0071:00
[    0.334947] device: 'PNP0C09:00': device_add
[    0.335045] bus: 'acpi': add device PNP0C09:00
[    0.335151] PM: Adding info for acpi:PNP0C09:00
[    0.335707] device: 'LNXPOWER:00': device_add
[    0.335805] bus: 'acpi': add device LNXPOWER:00
[    0.335910] PM: Adding info for acpi:LNXPOWER:00
[    0.337544] device: 'PNP0C0A:00': device_add
[    0.337641] bus: 'acpi': add device PNP0C0A:00
[    0.337748] PM: Adding info for acpi:PNP0C0A:00
[    0.338941] device: 'ACPI0003:00': device_add
[    0.339038] bus: 'acpi': add device ACPI0003:00
[    0.339145] PM: Adding info for acpi:ACPI0003:00
[    0.339627] device: 'IBM0068:00': device_add
[    0.339723] bus: 'acpi': add device IBM0068:00
[    0.339829] PM: Adding info for acpi:IBM0068:00
[    0.340518] device: 'device:02': device_add
[    0.340615] bus: 'acpi': add device device:02
[    0.340721] PM: Adding info for acpi:device:02
[    0.341061] device: 'device:03': device_add
[    0.341157] bus: 'acpi': add device device:03
[    0.341263] PM: Adding info for acpi:device:03
[    0.342127] device: 'device:03': dev_uevent: bus uevent() returned -12
[    0.342332] device: 'device:04': device_add
[    0.342429] bus: 'acpi': add device device:04
[    0.342534] PM: Adding info for acpi:device:04
[    0.342628] device: 'device:04': dev_uevent: bus uevent() returned -12
[    0.342831] device: 'device:05': device_add
[    0.342927] bus: 'acpi': add device device:05
[    0.343032] PM: Adding info for acpi:device:05
[    0.343127] device: 'device:05': dev_uevent: bus uevent() returned -12
[    0.343353] device: 'device:06': device_add
[    0.343449] bus: 'acpi': add device device:06
[    0.343555] PM: Adding info for acpi:device:06
[    0.343649] device: 'device:06': dev_uevent: bus uevent() returned -12
[    0.343913] device: 'device:07': device_add
[    0.344009] bus: 'acpi': add device device:07
[    0.344114] PM: Adding info for acpi:device:07
[    0.344449] device: 'device:08': device_add
[    0.344545] bus: 'acpi': add device device:08
[    0.344651] PM: Adding info for acpi:device:08
[    0.344749] device: 'device:08': dev_uevent: bus uevent() returned -12
[    0.344957] device: 'device:09': device_add
[    0.345054] bus: 'acpi': add device device:09
[    0.345160] PM: Adding info for acpi:device:09
[    0.345254] device: 'device:09': dev_uevent: bus uevent() returned -12
[    0.345463] device: 'device:0a': device_add
[    0.345560] bus: 'acpi': add device device:0a
[    0.345665] PM: Adding info for acpi:device:0a
[    0.345759] device: 'device:0a': dev_uevent: bus uevent() returned -12
[    0.346032] device: 'device:0b': device_add
[    0.346129] bus: 'acpi': add device device:0b
[    0.346235] PM: Adding info for acpi:device:0b
[    0.346329] device: 'device:0b': dev_uevent: bus uevent() returned -12
[    0.346591] device: 'device:0c': device_add
[    0.346679] bus: 'acpi': add device device:0c
[    0.346791] PM: Adding info for acpi:device:0c
[    0.346884] device: 'device:0c': dev_uevent: bus uevent() returned -12
[    0.347138] device: 'device:0d': device_add
[    0.347235] bus: 'acpi': add device device:0d
[    0.347341] PM: Adding info for acpi:device:0d
[    0.347435] device: 'device:0d': dev_uevent: bus uevent() returned -12
[    0.347660] device: 'device:0e': device_add
[    0.347757] bus: 'acpi': add device device:0e
[    0.347863] PM: Adding info for acpi:device:0e
[    0.347956] device: 'device:0e': dev_uevent: bus uevent() returned -12
[    0.348194] device: 'device:0f': device_add
[    0.348291] bus: 'acpi': add device device:0f
[    0.348397] PM: Adding info for acpi:device:0f
[    0.348491] device: 'device:0f': dev_uevent: bus uevent() returned -12
[    0.348705] device: 'device:10': device_add
[    0.348801] bus: 'acpi': add device device:10
[    0.348908] PM: Adding info for acpi:device:10
[    0.349002] device: 'device:10': dev_uevent: bus uevent() returned -12
[    0.349243] device: 'device:11': device_add
[    0.349340] bus: 'acpi': add device device:11
[    0.349464] PM: Adding info for acpi:device:11
[    0.349558] device: 'device:11': dev_uevent: bus uevent() returned -12
[    0.349860] device: 'device:12': device_add
[    0.349960] bus: 'acpi': add device device:12
[    0.350030] PM: Adding info for acpi:device:12
[    0.350124] device: 'device:12': dev_uevent: bus uevent() returned -12
[    0.350345] device: 'device:13': device_add
[    0.350445] bus: 'acpi': add device device:13
[    0.350554] PM: Adding info for acpi:device:13
[    0.350648] device: 'device:13': dev_uevent: bus uevent() returned -12
[    0.350990] device: 'device:14': device_add
[    0.351086] bus: 'acpi': add device device:14
[    0.351193] PM: Adding info for acpi:device:14
[    0.351286] device: 'device:14': dev_uevent: bus uevent() returned -12
[    0.352198] device: 'device:15': device_add
[    0.352296] bus: 'acpi': add device device:15
[    0.352401] PM: Adding info for acpi:device:15
[    0.352809] device: 'device:16': device_add
[    0.352907] bus: 'acpi': add device device:16
[    0.353018] PM: Adding info for acpi:device:16
[    0.353112] device: 'device:16': dev_uevent: bus uevent() returned -12
[    0.353535] device: 'device:17': device_add
[    0.353632] bus: 'acpi': add device device:17
[    0.353739] PM: Adding info for acpi:device:17
[    0.353834] device: 'device:17': dev_uevent: bus uevent() returned -12
[    0.354067] device: 'device:18': device_add
[    0.354164] bus: 'acpi': add device device:18
[    0.354272] PM: Adding info for acpi:device:18
[    0.354365] device: 'device:18': dev_uevent: bus uevent() returned -12
[    0.358116] device: 'device:19': device_add
[    0.358214] bus: 'acpi': add device device:19
[    0.358321] PM: Adding info for acpi:device:19
[    0.358415] device: 'device:19': dev_uevent: bus uevent() returned -12
[    0.358814] device: 'device:1a': device_add
[    0.358912] bus: 'acpi': add device device:1a
[    0.359019] PM: Adding info for acpi:device:1a
[    0.359113] device: 'device:1a': dev_uevent: bus uevent() returned -12
[    0.359322] device: 'device:1b': device_add
[    0.359418] bus: 'acpi': add device device:1b
[    0.359525] PM: Adding info for acpi:device:1b
[    0.359618] device: 'device:1b': dev_uevent: bus uevent() returned -12
[    0.359811] device: 'device:1c': device_add
[    0.359906] bus: 'acpi': add device device:1c
[    0.360023] PM: Adding info for acpi:device:1c
[    0.360117] device: 'device:1c': dev_uevent: bus uevent() returned -12
[    0.361106] device: 'device:1d': device_add
[    0.361204] bus: 'acpi': add device device:1d
[    0.361311] PM: Adding info for acpi:device:1d
[    0.361406] device: 'device:1d': dev_uevent: bus uevent() returned -12
[    0.361622] device: 'device:1e': device_add
[    0.361728] bus: 'acpi': add device device:1e
[    0.361835] PM: Adding info for acpi:device:1e
[    0.361934] device: 'device:1e': dev_uevent: bus uevent() returned -12
[    0.362128] device: 'device:1f': device_add
[    0.362225] bus: 'acpi': add device device:1f
[    0.362332] PM: Adding info for acpi:device:1f
[    0.362427] device: 'device:1f': dev_uevent: bus uevent() returned -12
[    0.362631] device: 'device:20': device_add
[    0.362728] bus: 'acpi': add device device:20
[    0.362835] PM: Adding info for acpi:device:20
[    0.362929] device: 'device:20': dev_uevent: bus uevent() returned -12
[    0.363755] device: 'device:21': device_add
[    0.363852] bus: 'acpi': add device device:21
[    0.363959] PM: Adding info for acpi:device:21
[    0.364052] device: 'device:21': dev_uevent: bus uevent() returned -12
[    0.364272] device: 'device:22': device_add
[    0.364367] bus: 'acpi': add device device:22
[    0.364474] PM: Adding info for acpi:device:22
[    0.364567] device: 'device:22': dev_uevent: bus uevent() returned -12
[    0.364765] device: 'device:23': device_add
[    0.364862] bus: 'acpi': add device device:23
[    0.364968] PM: Adding info for acpi:device:23
[    0.365062] device: 'device:23': dev_uevent: bus uevent() returned -12
[    0.365260] device: 'device:24': device_add
[    0.365356] bus: 'acpi': add device device:24
[    0.365463] PM: Adding info for acpi:device:24
[    0.365557] device: 'device:24': dev_uevent: bus uevent() returned -12
[    0.365873] device: 'device:25': device_add
[    0.365972] bus: 'acpi': add device device:25
[    0.366079] PM: Adding info for acpi:device:25
[    0.366172] device: 'device:25': dev_uevent: bus uevent() returned -12
[    0.367241] device: 'LNXTHERM:00': device_add
[    0.367338] bus: 'acpi': add device LNXTHERM:00
[    0.367445] PM: Adding info for acpi:LNXTHERM:00
[    0.367698] device: 'LNXTHERM:01': device_add
[    0.367796] bus: 'acpi': add device LNXTHERM:01
[    0.367903] PM: Adding info for acpi:LNXTHERM:01
[    0.368163] device: 'LNXTHERM:02': device_add
[    0.368260] bus: 'acpi': add device LNXTHERM:02
[    0.368366] PM: Adding info for acpi:LNXTHERM:02
[    0.369095] bus: 'acpi': add driver ec
[    0.369213] bus: 'acpi': driver_probe_device: matched device PNP0C09:00 with driver ec
[    0.369345] bus: 'acpi': really_probe: probing driver ec with device PNP0C09:00
[    0.369844] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.369938] ACPI: EC: driver started in interrupt mode
[    0.370005] driver: 'PNP0C09:00': driver_bound: bound to device 'ec'
[    0.370099] bus: 'acpi': really_probe: bound device PNP0C09:00 to driver ec
[    0.370363] bus: 'acpi': add driver power
[    0.370480] bus: 'acpi': driver_probe_device: matched device LNXPOWER:00 with driver power
[    0.370612] bus: 'acpi': really_probe: probing driver power with device LNXPOWER:00
[    0.371318] ACPI: Power Resource [PUBS] (on)
[    0.371407] driver: 'LNXPOWER:00': driver_bound: bound to device 'power'
[    0.371501] bus: 'acpi': really_probe: bound device LNXPOWER:00 to driver power
[    0.372137] initcall acpi_init+0x0/0x259 returned 0 after 113932 usecs
[    0.372233] calling  dock_init+0x0/0x7d @ 1
[    0.372652] Registering platform device 'dock.0'. Parent at platform
[    0.372746] device: 'dock.0': device_add
[    0.372843] bus: 'platform': add device dock.0
[    0.372951] PM: Adding info for platform:dock.0
[    0.375501] Registering platform device 'dock.1'. Parent at platform
[    0.375596] device: 'dock.1': device_add
[    0.375692] bus: 'platform': add device dock.1
[    0.375801] PM: Adding info for platform:dock.1
[    0.378140] Registering platform device 'dock.2'. Parent at platform
[    0.378235] device: 'dock.2': device_add
[    0.378332] bus: 'platform': add device dock.2
[    0.378440] PM: Adding info for platform:dock.2
[    0.380997] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.381092] initcall dock_init+0x0/0x7d returned 0 after 9765 usecs
[    0.381185] calling  acpi_pci_root_init+0x0/0x25 @ 1
[    0.381275] bus: 'acpi': add driver pci_root
[    0.382167] bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
[    0.382301] bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
[    0.382475] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.382631] device: 'pci0000:00': device_add
[    0.382746] PM: Adding info for No Bus:pci0000:00
[    0.382840] device: '0000:00': device_add
[    0.382953] PM: Adding info for No Bus:0000:00
[    0.383226] PCI: Scanning bus 0000:00
[    0.383354] pci 0000:00:00.0: found [8086:27a0] class 000600 header type 00
[    0.383548] pci 0000:00:02.0: found [8086:27a2] class 000300 header type 00
[    0.383672] pci 0000:00:02.0: reg 10 32bit mmio: [0xee100000-0xee17ffff]
[    0.383772] pci 0000:00:02.0: reg 14 io port: [0x1800-0x1807]
[    0.383871] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.383971] pci 0000:00:02.0: reg 1c 32bit mmio: [0xee200000-0xee23ffff]
[    0.384141] pci 0000:00:02.1: found [8086:27a6] class 000380 header type 00
[    0.384257] pci 0000:00:02.1: reg 10 32bit mmio: [0xee180000-0xee1fffff]
[    0.384532] pci 0000:00:1b.0: found [8086:27d8] class 000403 header type 00
[    0.384667] pci 0000:00:1b.0: reg 10 64bit mmio: [0xee240000-0xee243fff]
[    0.384860] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.384957] pci 0000:00:1b.0: PME# disabled
[    0.385086] pci 0000:00:1c.0: found [8086:27d0] class 000604 header type 01
[    0.385281] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.385378] pci 0000:00:1c.0: PME# disabled
[    0.385512] pci 0000:00:1c.1: found [8086:27d2] class 000604 header type 01
[    0.385704] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.385801] pci 0000:00:1c.1: PME# disabled
[    0.385936] pci 0000:00:1c.2: found [8086:27d4] class 000604 header type 01
[    0.386127] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.386225] pci 0000:00:1c.2: PME# disabled
[    0.386359] pci 0000:00:1c.3: found [8086:27d6] class 000604 header type 01
[    0.386548] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.386676] pci 0000:00:1c.3: PME# disabled
[    0.386814] pci 0000:00:1d.0: found [8086:27c8] class 000c03 header type 00
[    0.386966] pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
[    0.387106] pci 0000:00:1d.1: found [8086:27c9] class 000c03 header type 00
[    0.387257] pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
[    0.387398] pci 0000:00:1d.2: found [8086:27ca] class 000c03 header type 00
[    0.387549] pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
[    0.387690] pci 0000:00:1d.3: found [8086:27cb] class 000c03 header type 00
[    0.387841] pci 0000:00:1d.3: reg 20 io port: [0x1880-0x189f]
[    0.388001] pci 0000:00:1d.7: found [8086:27cc] class 000c03 header type 00
[    0.388140] pci 0000:00:1d.7: reg 10 32bit mmio: [0xee444000-0xee4443ff]
[    0.388336] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.388433] pci 0000:00:1d.7: PME# disabled
[    0.388558] pci 0000:00:1e.0: found [8086:2448] class 000604 header type 01
[    0.388765] pci 0000:00:1f.0: found [8086:27b9] class 000601 header type 00
[    0.389037] pci 0000:00:1f.1: found [8086:27df] class 000101 header type 00
[    0.389150] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.389251] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.389351] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.389452] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.389553] pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
[    0.389708] pci 0000:00:1f.2: found [8086:27c5] class 000106 header type 00
[    0.389845] pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
[    0.389947] pci 0000:00:1f.2: reg 14 io port: [0x18c4-0x18c7]
[    0.390014] pci 0000:00:1f.2: reg 18 io port: [0x18c8-0x18cf]
[    0.390117] pci 0000:00:1f.2: reg 1c io port: [0x18c0-0x18c3]
[    0.390217] pci 0000:00:1f.2: reg 20 io port: [0x18b0-0x18bf]
[    0.390319] pci 0000:00:1f.2: reg 24 32bit mmio: [0xee444400-0xee4447ff]
[    0.390470] pci 0000:00:1f.2: PME# supported from D3hot
[    0.390565] pci 0000:00:1f.2: PME# disabled
[    0.390684] pci 0000:00:1f.3: found [8086:27da] class 000c05 header type 00
[    0.390846] pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
[    0.390991] PCI: Fixups for bus 0000:00
[    0.391083] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    0.391186] PCI: Scanning bus 0000:02
[    0.391319] pci 0000:02:00.0: found [8086:109a] class 000200 header type 00
[    0.391465] pci 0000:02:00.0: reg 10 32bit mmio: [0xee000000-0xee01ffff]
[    0.391590] pci 0000:02:00.0: reg 18 io port: [0x2000-0x201f]
[    0.391824] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.391925] pci 0000:02:00.0: PME# disabled
[    0.392105] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.392577] PCI: Fixups for bus 0000:02
[    0.392670] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.392767] pci 0000:00:1c.0: bridge 32bit mmio: [0xee000000-0xee0fffff]
[    0.392870] PCI: Bus scan for 0000:02 returning with max=02
[    0.392966] pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 0
[    0.393068] PCI: Scanning bus 0000:03
[    0.393269] pci 0000:03:00.0: found [8086:4227] class 000280 header type 00
[    0.393464] pci 0000:03:00.0: reg 10 32bit mmio: [0xedf00000-0xedf00fff]
[    0.393882] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.394028] pci 0000:03:00.0: PME# disabled
[    0.394259] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.394713] PCI: Fixups for bus 0000:03
[    0.394806] pci 0000:00:1c.1: bridge io port: [0x3000-0x4fff]
[    0.394903] pci 0000:00:1c.1: bridge 32bit mmio: [0xec000000-0xedffffff]
[    0.395007] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xe4000000-0xe40fffff]
[    0.395101] PCI: Bus scan for 0000:03 returning with max=03
[    0.395198] pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 0
[    0.395300] PCI: Scanning bus 0000:04
[    0.395479] PCI: Fixups for bus 0000:04
[    0.395572] pci 0000:00:1c.2: bridge io port: [0x5000-0x6fff]
[    0.395669] pci 0000:00:1c.2: bridge 32bit mmio: [0xe8000000-0xe9ffffff]
[    0.395773] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xe4100000-0xe41fffff]
[    0.395868] PCI: Bus scan for 0000:04 returning with max=04
[    0.395965] pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 0
[    0.396066] PCI: Scanning bus 0000:0c
[    0.396244] PCI: Fixups for bus 0000:0c
[    0.396337] pci 0000:00:1c.3: bridge io port: [0x7000-0x8fff]
[    0.396433] pci 0000:00:1c.3: bridge 32bit mmio: [0xea000000-0xebffffff]
[    0.396537] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xe4200000-0xe42fffff]
[    0.396671] PCI: Bus scan for 0000:0c returning with max=0c
[    0.396767] pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 0
[    0.396869] PCI: Scanning bus 0000:15
[    0.396981] pci 0000:15:00.0: found [104c:ac56] class 000607 header type 02
[    0.397117] pci 0000:15:00.0: reg 10 32bit mmio: [0xe4300000-0xe4300fff]
[    0.397251] pci 0000:15:00.0: supports D1 D2
[    0.397341] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.397440] pci 0000:15:00.0: PME# disabled
[    0.397642] PCI: Fixups for bus 0000:15
[    0.397731] pci 0000:00:1e.0: transparent bridge
[    0.397825] pci 0000:00:1e.0: bridge io port: [0x9000-0xcfff]
[    0.397921] pci 0000:00:1e.0: bridge 32bit mmio: [0xe4300000-0xe7ffffff]
[    0.398025] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xe0000000-0xe3ffffff]
[    0.398122] pci 0000:15:00.0: scanning behind bridge, config 181615, pass 0
[    0.398227] pci 0000:15:00.0: scanning behind bridge, config 181615, pass 1
[    0.398345] PCI: Bus scan for 0000:15 returning with max=17
[    0.398443] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    0.398548] pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 1
[    0.398652] pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 1
[    0.398755] pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 1
[    0.398858] pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 1
[    0.398959] PCI: Bus scan for 0000:00 returning with max=18
[    0.399050] pci_bus 0000:00: on NUMA node 0
[    0.399150] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.399778] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.400138] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.400441] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[    0.400750] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.401058] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.401517] device: '0000:00:00.0': device_add
[    0.402397] bus: 'pci': add device 0000:00:00.0
[    0.402545] PM: Adding info for pci:0000:00:00.0
[    0.402755] device: '0000:00:02.0': device_add
[    0.403654] bus: 'pci': add device 0000:00:02.0
[    0.403801] PM: Adding info for pci:0000:00:02.0
[    0.404012] device: '0000:00:02.1': device_add
[    0.404893] bus: 'pci': add device 0000:00:02.1
[    0.405040] PM: Adding info for pci:0000:00:02.1
[    0.405247] device: '0000:00:1b.0': device_add
[    0.406138] bus: 'pci': add device 0000:00:1b.0
[    0.406286] PM: Adding info for pci:0000:00:1b.0
[    0.406498] device: '0000:00:1c.0': device_add
[    0.407395] bus: 'pci': add device 0000:00:1c.0
[    0.407548] PM: Adding info for pci:0000:00:1c.0
[    0.407755] device: '0000:00:1c.1': device_add
[    0.408648] bus: 'pci': add device 0000:00:1c.1
[    0.408796] PM: Adding info for pci:0000:00:1c.1
[    0.409012] device: '0000:00:1c.2': device_add
[    0.409898] bus: 'pci': add device 0000:00:1c.2
[    0.410055] PM: Adding info for pci:0000:00:1c.2
[    0.410263] device: '0000:00:1c.3': device_add
[    0.411151] bus: 'pci': add device 0000:00:1c.3
[    0.411298] PM: Adding info for pci:0000:00:1c.3
[    0.411504] device: '0000:00:1d.0': device_add
[    0.412444] bus: 'pci': add device 0000:00:1d.0
[    0.412593] PM: Adding info for pci:0000:00:1d.0
[    0.412799] device: '0000:00:1d.1': device_add
[    0.413695] bus: 'pci': add device 0000:00:1d.1
[    0.413843] PM: Adding info for pci:0000:00:1d.1
[    0.414049] device: '0000:00:1d.2': device_add
[    0.414936] bus: 'pci': add device 0000:00:1d.2
[    0.415084] PM: Adding info for pci:0000:00:1d.2
[    0.415296] device: '0000:00:1d.3': device_add
[    0.416184] bus: 'pci': add device 0000:00:1d.3
[    0.416337] PM: Adding info for pci:0000:00:1d.3
[    0.416554] device: '0000:00:1d.7': device_add
[    0.417453] bus: 'pci': add device 0000:00:1d.7
[    0.417602] PM: Adding info for pci:0000:00:1d.7
[    0.417806] device: '0000:00:1e.0': device_add
[    0.418769] bus: 'pci': add device 0000:00:1e.0
[    0.418918] PM: Adding info for pci:0000:00:1e.0
[    0.419128] device: '0000:00:1f.0': device_add
[    0.420024] bus: 'pci': add device 0000:00:1f.0
[    0.420172] PM: Adding info for pci:0000:00:1f.0
[    0.420380] device: '0000:00:1f.1': device_add
[    0.422040] bus: 'pci': add device 0000:00:1f.1
[    0.422193] PM: Adding info for pci:0000:00:1f.1
[    0.422401] device: '0000:00:1f.2': device_add
[    0.423289] bus: 'pci': add device 0000:00:1f.2
[    0.423397] PM: Adding info for pci:0000:00:1f.2
[    0.423606] device: '0000:00:1f.3': device_add
[    0.424495] bus: 'pci': add device 0000:00:1f.3
[    0.424643] PM: Adding info for pci:0000:00:1f.3
[    0.424849] device: '0000:02:00.0': device_add
[    0.424954] bus: 'pci': add device 0000:02:00.0
[    0.425107] PM: Adding info for pci:0000:02:00.0
[    0.425370] device: '0000:02': device_add
[    0.425487] PM: Adding info for No Bus:0000:02
[    0.425696] device: '0000:03:00.0': device_add
[    0.425799] bus: 'pci': add device 0000:03:00.0
[    0.425947] PM: Adding info for pci:0000:03:00.0
[    0.426155] device: '0000:03': device_add
[    0.426272] PM: Adding info for No Bus:0000:03
[    0.426484] device: '0000:04': device_add
[    0.426599] PM: Adding info for No Bus:0000:04
[    0.426807] device: '0000:0c': device_add
[    0.426922] PM: Adding info for No Bus:0000:0c
[    0.427132] device: '0000:15:00.0': device_add
[    0.427384] bus: 'pci': add device 0000:15:00.0
[    0.427538] PM: Adding info for pci:0000:15:00.0
[    0.427750] device: '0000:16': device_add
[    0.427867] PM: Adding info for No Bus:0000:16
[    0.428076] device: '0000:15': device_add
[    0.428192] PM: Adding info for No Bus:0000:15
[    0.428403] driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
[    0.428498] bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
[    0.428784] initcall acpi_pci_root_init+0x0/0x25 returned 0 after 45572 usecs
[    0.428880] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    0.428971] bus: 'acpi': add driver pci_link
[    0.429073] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
[    0.429205] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
[    0.429836] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.430561] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
[    0.430657] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
[    0.430790] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
[    0.430921] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
[    0.431413] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.432078] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
[    0.432172] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
[    0.432306] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
[    0.432440] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
[    0.432933] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.433595] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
[    0.433691] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
[    0.433827] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
[    0.433959] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
[    0.434451] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.435102] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
[    0.435198] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
[    0.435332] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
[    0.435464] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
[    0.435955] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.436604] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
[    0.436672] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
[    0.436807] bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
[    0.436938] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
[    0.437433] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.438084] driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
[    0.438180] bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
[    0.438316] bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
[    0.438448] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
[    0.438938] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.439590] driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
[    0.439686] bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
[    0.439819] bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
[    0.440005] bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
[    0.440497] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.441149] driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
[    0.441244] bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
[    0.441535] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 13020 usecs
[    0.441632] calling  pnp_init+0x0/0xf @ 1
[    0.441856] bus: 'pnp': registered
[    0.441947] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.442038] calling  misc_init+0x0/0x9c @ 1
[    0.442135] device class 'misc': registering
[    0.442347] initcall misc_init+0x0/0x9c returned 0 after 0 usecs
[    0.442440] calling  tifm_init+0x0/0x75 @ 1
[    0.442736] bus: 'tifm': registered
[    0.442823] device class 'tifm_adapter': registering
[    0.443030] initcall tifm_init+0x0/0x75 returned 0 after 0 usecs
[    0.443123] calling  init_scsi+0x0/0x79 @ 1
[    0.443354] device class 'scsi_host': registering
[    0.443702] bus: 'scsi': registered
[    0.443789] device class 'scsi_device': registering
[    0.444038] SCSI subsystem initialized
[    0.444129] initcall init_scsi+0x0/0x79 returned 0 after 3255 usecs
[    0.444223] calling  ata_init+0x0/0x2a9 @ 1
[    0.444501] libata version 3.00 loaded.
[    0.444593] initcall ata_init+0x0/0x2a9 returned 0 after 0 usecs
[    0.444685] calling  phy_init+0x0/0x29 @ 1
[    0.444774] device class 'mdio_bus': registering
[    0.445118] bus: 'mdio_bus': registered
[    0.445208] bus: 'mdio_bus': add driver Generic PHY
[    0.445522] initcall phy_init+0x0/0x29 returned 0 after 0 usecs
[    0.445617] calling  init_pcmcia_cs+0x0/0x28 @ 1
[    0.445708] device class 'pcmcia_socket': registering
[    0.445915] initcall init_pcmcia_cs+0x0/0x28 returned 0 after 0 usecs
[    0.446009] calling  usb_init+0x0/0x138 @ 1
[    0.446293] bus: 'usb': registered
[    0.446381] device class 'usb_host': registering
[    0.446593] bus: 'usb': add driver usbfs
[    0.446822] usbcore: registered new interface driver usbfs
[    0.446934] bus: 'usb': add driver hub
[    0.447152] usbcore: registered new interface driver hub
[    0.447307] bus: 'usb': add driver usb
[    0.447536] usbcore: registered new device driver usb
[    0.447631] initcall usb_init+0x0/0x138 returned 0 after 3255 usecs
[    0.447723] calling  serio_init+0x0/0x9d @ 1
[    0.447952] bus: 'serio': registered
[    0.448100] initcall serio_init+0x0/0x9d returned 0 after 0 usecs
[    0.448195] calling  gameport_init+0x0/0x9d @ 1
[    0.448415] bus: 'gameport': registered
[    0.448563] initcall gameport_init+0x0/0x9d returned 0 after 0 usecs
[    0.448659] calling  input_init+0x0/0x101 @ 1
[    0.448748] device class 'input': registering
[    0.448983] initcall input_init+0x0/0x101 returned 0 after 0 usecs
[    0.449077] calling  thermal_init+0x0/0x46 @ 1
[    0.449166] device class 'thermal': registering
[    0.449369] initcall thermal_init+0x0/0x46 returned 0 after 0 usecs
[    0.449463] calling  mmc_init+0x0/0x6e @ 1
[    0.449730] bus: 'mmc': registered
[    0.449818] device class 'mmc_host': registering
[    0.450182] bus: 'sdio': registered
[    0.450274] initcall mmc_init+0x0/0x6e returned 0 after 3255 usecs
[    0.450367] calling  leds_init+0x0/0x4e @ 1
[    0.450456] device class 'leds': registering
[    0.450657] initcall leds_init+0x0/0x4e returned 0 after 0 usecs
[    0.450751] calling  pci_subsys_init+0x0/0xdf @ 1
[    0.450840] PCI: Using ACPI for IRQ routing
[    0.452390] initcall pci_subsys_init+0x0/0xdf returned 0 after 0 usecs
[    0.452483] calling  proto_init+0x0/0xf @ 1
[    0.452584] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    0.452678] calling  net_dev_init+0x0/0x140 @ 1
[    0.452791] device class 'net': registering
[    0.453049] device: 'lo': device_add
[    0.453426] PM: Adding info for No Bus:lo
[    0.454012] initcall net_dev_init+0x0/0x140 returned 0 after 3255 usecs
[    0.454107] calling  neigh_init+0x0/0x66 @ 1
[    0.454198] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    0.454290] calling  fib_rules_init+0x0/0x99 @ 1
[    0.454384] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    0.454478] calling  pktsched_init+0x0/0xa9 @ 1
[    0.454605] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    0.454698] calling  tc_filter_init+0x0/0x43 @ 1
[    0.454789] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    0.454882] calling  genl_init+0x0/0xb0 @ 1
[    0.466747] initcall genl_init+0x0/0xb0 returned 0 after 13020 usecs
[    0.466842] calling  cipso_v4_init+0x0/0x6d @ 1
[    0.466954] initcall cipso_v4_init+0x0/0x6d returned 0 after 0 usecs
[    0.467048] calling  atm_init+0x0/0x9c @ 1
[    0.467924] NET: Registered protocol family 8
[    0.468013] NET: Registered protocol family 20
[    0.468129] device class 'atm': registering
[    0.468330] initcall atm_init+0x0/0x9c returned 0 after 0 usecs
[    0.468424] calling  wireless_nlevent_init+0x0/0x39 @ 1
[    0.468516] initcall wireless_nlevent_init+0x0/0x39 returned 0 after 0 usecs
[    0.468613] calling  netlbl_init+0x0/0x6d @ 1
[    0.468701] NetLabel: Initializing
[    0.468788] NetLabel:  domain hash size = 128
[    0.468876] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.469075] NetLabel:  unlabeled traffic allowed by default
[    0.469168] initcall netlbl_init+0x0/0x6d returned 0 after 0 usecs
[    0.469261] calling  sysctl_init+0x0/0x3b @ 1
[    0.469354] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    0.469448] calling  pci_iommu_init+0x0/0x20 @ 1
[    0.482302] DMA-API: preallocated 32768 debug entries
[    0.482401] DMA-API: debugging enabled by kernel config
[    0.482502] initcall pci_iommu_init+0x0/0x20 returned 0 after 13020 usecs
[    0.482599] calling  print_all_ICs+0x0/0x43f @ 1
[    0.482688] 
[    0.482689] printing PIC contents
[    0.482862] ... PIC  IMR: ffff
[    0.482950] ... PIC  IRR: 0800
[    0.483045] ... PIC  ISR: 0000
[    0.483134] ... PIC ELCR: 0800
[    0.483223] 
[    0.483224] printing local APIC contents on CPU#0/0:
[    0.483332] ... APIC ID:      00000000 (0)
[    0.483332] ... APIC VERSION: 00050014
[    0.483332] ... APIC TASKPRI: 00000000 (00)
[    0.483332] ... APIC PROCPRI: 00000000
[    0.483332] ... APIC LDR: 01000000
[    0.483332] ... APIC DFR: ffffffff
[    0.483332] ... APIC SPIV: 000001ff
[    0.483332] ... APIC ISR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] ... APIC TMR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000001000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] ... APIC IRR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000010000000000000000
[    0.483332] ... APIC ESR: 00000000
[    0.483332] ... APIC ICR: 000008fb
[    0.483332] ... APIC ICR2: 02000000
[    0.483332] ... APIC LVTT: 000200ef
[    0.483332] ... APIC LVTPC: 00010000
[    0.483332] ... APIC LVT0: 00010700
[    0.483332] ... APIC LVT1: 00000400
[    0.483332] ... APIC LVTERR: 000000fe
[    0.483332] ... APIC TMICT: 0000874b
[    0.483332] ... APIC TMCCT: 0000536a
[    0.483332] ... APIC TDCR: 00000003
[    0.483332] 
[    0.483332] 
[    0.483332] printing local APIC contents on CPU#1/1:
[    0.483332] ... APIC ID:      01000000 (1)
[    0.483332] ... APIC VERSION: 00050014
[    0.483332] ... APIC TASKPRI: 00000000 (00)
[    0.483332] ... APIC PROCPRI: 00000000
[    0.483332] ... APIC LDR: 02000000
[    0.483332] ... APIC DFR: ffffffff
[    0.483332] ... APIC SPIV: 000001ff
[    0.483332] ... APIC ISR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] ... APIC TMR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] ... APIC IRR field:
[    0.483332] 0123456789abcdef0123456789abcdef
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000000000000000000000
[    0.483332] 00000000000000010000000000000000
[    0.483332] ... APIC ESR: 00000000
[    0.483332] ... APIC ICR: 000008fd
[    0.483332] ... APIC ICR2: 01000000
[    0.483332] ... APIC LVTT: 000200ef
[    0.483332] ... APIC LVTPC: 00010000
[    0.483332] ... APIC LVT0: 00010700
[    0.483332] ... APIC LVT1: 00010400
[    0.483332] ... APIC LVTERR: 000000fe
[    0.483332] ... APIC TMICT: 0000874b
[    0.483332] ... APIC TMCCT: 00005d5e
[    0.483332] ... APIC TDCR: 00000003
[    0.483332] 
[    0.523210] number of MP IRQ sources: 15.
[    0.523301] number of IO-APIC #1 registers: 24.
[    0.523338] testing the IO APIC.......................
[    0.523436] 
[    0.523519] IO APIC #1......
[    0.523604] .... register #00: 02000000
[    0.523692] .......    : physical APIC id: 02
[    0.523781] .......    : Delivery Type: 0
[    0.523869] .......    : LTS          : 0
[    0.523958] .... register #01: 00170020
[    0.524044] .......     : max redirection entries: 0017
[    0.524134] .......     : PRQ implemented: 0
[    0.524223] .......     : IO APIC version: 0020
[    0.524312] .... IRQ redirection table:
[    0.524399]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
[    0.524495]  00 000 1    0    0   0   0    0    0    00
[    0.524634]  01 003 0    0    0   0   0    1    1    31
[    0.524774]  02 003 0    0    0   0   0    1    1    30
[    0.524913]  03 003 0    0    0   0   0    1    1    33
[    0.525054]  04 003 0    0    0   0   0    1    1    34
[    0.525194]  05 003 0    0    0   0   0    1    1    35
[    0.525334]  06 003 0    0    0   0   0    1    1    36
[    0.525474]  07 003 0    0    0   0   0    1    1    37
[    0.525613]  08 003 0    0    0   0   0    1    1    38
[    0.525752]  09 003 0    1    0   0   0    1    1    39
[    0.525892]  0a 003 0    0    0   0   0    1    1    3A
[    0.526031]  0b 003 0    0    0   0   0    1    1    3B
[    0.526171]  0c 003 0    0    0   0   0    1    1    3C
[    0.526310]  0d 003 0    0    0   0   0    1    1    3D
[    0.526450]  0e 003 0    0    0   0   0    1    1    3E
[    0.526590]  0f 003 0    0    0   0   0    1    1    3F
[    0.526760]  10 000 1    0    0   0   0    0    0    00
[    0.526900]  11 000 1    0    0   0   0    0    0    00
[    0.527039]  12 000 1    0    0   0   0    0    0    00
[    0.527179]  13 000 1    0    0   0   0    0    0    00
[    0.527319]  14 000 1    0    0   0   0    0    0    00
[    0.527459]  15 000 1    0    0   0   0    0    0    00
[    0.527598]  16 000 1    0    0   0   0    0    0    00
[    0.527737]  17 000 1    0    0   0   0    0    0    00
[    0.527874] IRQ to pin mappings:
[    0.527960] IRQ0 -> 0:2
[    0.528132] IRQ1 -> 0:1
[    0.528306] IRQ3 -> 0:3
[    0.528481] IRQ4 -> 0:4
[    0.528654] IRQ5 -> 0:5
[    0.528827] IRQ6 -> 0:6
[    0.529000] IRQ7 -> 0:7
[    0.529174] IRQ8 -> 0:8
[    0.529347] IRQ9 -> 0:9
[    0.529522] IRQ10 -> 0:10
[    0.529695] IRQ11 -> 0:11
[    0.529869] IRQ12 -> 0:12
[    0.530083] IRQ13 -> 0:13
[    0.531026] IRQ14 -> 0:14
[    0.531200] IRQ15 -> 0:15
[    0.531484] .................................... done.
[    0.531578] initcall print_all_ICs+0x0/0x43f returned 0 after 48828 usecs
[    0.531673] calling  hpet_late_init+0x0/0x12f @ 1
[    0.531771] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.532040] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.533345] initcall hpet_late_init+0x0/0x12f returned 0 after 3255 usecs
[    0.533440] calling  clocksource_done_booting+0x0/0x11 @ 1
[    0.533533] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    0.533666] calling  ftrace_init_debugfs+0x0/0x1a5 @ 1
[    0.533938] initcall ftrace_init_debugfs+0x0/0x1a5 returned 0 after 0 usecs
[    0.534034] calling  rb_init_debugfs+0x0/0x27 @ 1
[    0.534134] initcall rb_init_debugfs+0x0/0x27 returned 0 after 0 usecs
[    0.534228] calling  tracer_init_debugfs+0x0/0x294 @ 1
[    0.534830] initcall tracer_init_debugfs+0x0/0x294 returned 0 after 0 usecs
[    0.534926] calling  init_trace_printk_function_export+0x0/0x2a @ 1
[    0.535030] initcall init_trace_printk_function_export+0x0/0x2a returned 0 after 0 usecs
[    0.535163] calling  init_annotated_branch_stats+0x0/0x27 @ 1
[    0.535266] Warning: could not register annotated branches stats
[    0.535360] initcall init_annotated_branch_stats+0x0/0x27 returned 1 after 0 usecs
[    0.535492] initcall init_annotated_branch_stats+0x0/0x27 returned with error code 1 
[    0.535623] calling  stat_workqueue_init+0x0/0x27 @ 1
[    0.535727] initcall stat_workqueue_init+0x0/0x27 returned 0 after 0 usecs
[    0.535822] calling  event_trace_init+0x0/0x138 @ 1
[    0.541545] initcall event_trace_init+0x0/0x138 returned 0 after 4749 usecs
[    0.541642] calling  init_pipe_fs+0x0/0x5a @ 1
[    0.541901] initcall init_pipe_fs+0x0/0x5a returned 0 after 162 usecs
[    0.541996] calling  init_mnt_writers+0x0/0x6a @ 1
[    0.542089] initcall init_mnt_writers+0x0/0x6a returned 0 after 1 usecs
[    0.542183] calling  anon_inode_init+0x0/0x121 @ 1
[    0.542421] initcall anon_inode_init+0x0/0x121 returned 0 after 142 usecs
[    0.542516] calling  fscache_init+0x0/0x92 @ 1
[    0.542638] Slow work thread pool: Starting up
[    0.542964] Slow work thread pool: Ready
[    0.543078] FS-Cache: Loaded
[    0.543168] initcall fscache_init+0x0/0x92 returned 0 after 546 usecs
[    0.543262] calling  tomoyo_initerface_init+0x0/0xe1 @ 1
[    0.543795] initcall tomoyo_initerface_init+0x0/0xe1 returned 0 after 417 usecs
[    0.543927] calling  acpi_event_init+0x0/0x6f @ 1
[    0.559972] initcall acpi_event_init+0x0/0x6f returned 0 after 15577 usecs
[    0.560068] calling  pnpacpi_init+0x0/0x7b @ 1
[    0.560157] pnp: PnP ACPI init
[    0.560277] device: 'pnp0': device_add
[    0.560386] PM: Adding info for No Bus:pnp0
[    0.560479] ACPI: bus type pnp registered
[    0.563668] device: '00:00': device_add
[    0.563823] bus: 'pnp': add device 00:00
[    0.563950] PM: Adding info for pnp:00:00
[    0.564262] device: '00:01': device_add
[    0.564460] bus: 'pnp': add device 00:01
[    0.564576] PM: Adding info for pnp:00:01
[    0.564989] device: '00:02': device_add
[    0.565129] bus: 'pnp': add device 00:02
[    0.565244] PM: Adding info for pnp:00:02
[    0.565646] device: '00:03': device_add
[    0.565793] bus: 'pnp': add device 00:03
[    0.565906] PM: Adding info for pnp:00:03
[    0.566156] device: '00:04': device_add
[    0.566305] bus: 'pnp': add device 00:04
[    0.566417] PM: Adding info for pnp:00:04
[    0.566668] device: '00:05': device_add
[    0.566817] bus: 'pnp': add device 00:05
[    0.566930] PM: Adding info for pnp:00:05
[    0.567174] IOAPIC[0]: Set routing entry (1-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
[    0.567317] device: '00:06': device_add
[    0.567474] bus: 'pnp': add device 00:06
[    0.567588] PM: Adding info for pnp:00:06
[    0.567829] IOAPIC[0]: Set routing entry (1-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
[    0.567968] device: '00:07': device_add
[    0.568121] bus: 'pnp': add device 00:07
[    0.568233] PM: Adding info for pnp:00:07
[    0.568474] IOAPIC[0]: Set routing entry (1-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
[    0.568616] device: '00:08': device_add
[    0.568772] bus: 'pnp': add device 00:08
[    0.568884] PM: Adding info for pnp:00:08
[    0.569128] IOAPIC[0]: Set routing entry (1-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
[    0.569269] device: '00:09': device_add
[    0.569425] bus: 'pnp': add device 00:09
[    0.569537] PM: Adding info for pnp:00:09
[    0.571999] IOAPIC[0]: Set routing entry (1-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
[    0.572228] device: '00:0a': device_add
[    0.572387] bus: 'pnp': add device 00:0a
[    0.572501] PM: Adding info for pnp:00:0a
[    0.575547] pnp: PnP ACPI: found 11 devices
[    0.575637] ACPI: ACPI bus type pnp unregistered
[    0.575731] initcall pnpacpi_init+0x0/0x7b returned 0 after 15205 usecs
[    0.575827] calling  pnpbios_init+0x0/0x31d @ 1
[    0.575919] PnPBIOS: Disabled by ACPI PNP
[    0.576010] initcall pnpbios_init+0x0/0x31d returned -19 after 89 usecs
[    0.576104] calling  pnp_system_init+0x0/0xf @ 1
[    0.576197] bus: 'pnp': add driver system
[    0.576296] bus: 'pnp': driver_probe_device: matched device 00:00 with driver system
[    0.576427] bus: 'pnp': really_probe: probing driver system with device 00:00
[    0.576535] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.576643] system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[    0.576741] system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[    0.576836] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.576934] system 00:00: iomem range 0xcc000-0xcffff could not be reserved
[    0.577032] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
[    0.577129] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.577226] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.577325] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.577422] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.577519] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.577616] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.577715] system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
[    0.577848] system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.577977] driver: '00:00': driver_bound: bound to device 'system'
[    0.578070] bus: 'pnp': really_probe: bound device 00:00 to driver system
[    0.578169] bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
[    0.578299] bus: 'pnp': really_probe: probing driver system with device 00:02
[    0.578405] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.578501] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.578596] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.578692] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.578786] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.578882] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.578978] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.579075] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.579171] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.579268] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.579363] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.579457] driver: '00:02': driver_bound: bound to device 'system'
[    0.579551] bus: 'pnp': really_probe: bound device 00:02 to driver system
[    0.579778] initcall pnp_system_init+0x0/0xf returned 0 after 3496 usecs
[    0.579873] calling  chr_dev_init+0x0/0x8d @ 1
[    0.579996] device class 'mem': registering
[    0.580209] device: 'mem': device_add
[    0.580324] PM: Adding info for No Bus:mem
[    0.580587] device: 'null': device_add
[    0.580700] PM: Adding info for No Bus:null
[    0.580905] device: 'port': device_add
[    0.581025] PM: Adding info for No Bus:port
[    0.581232] device: 'zero': device_add
[    0.581344] PM: Adding info for No Bus:zero
[    0.581556] device: 'full': device_add
[    0.581669] PM: Adding info for No Bus:full
[    0.581878] device: 'random': device_add
[    0.581996] PM: Adding info for No Bus:random
[    0.582206] device: 'urandom': device_add
[    0.582319] PM: Adding info for No Bus:urandom
[    0.582520] device: 'kmsg': device_add
[    0.582636] PM: Adding info for No Bus:kmsg
[    0.582838] initcall chr_dev_init+0x0/0x8d returned 0 after 2794 usecs
[    0.582933] calling  firmware_class_init+0x0/0x61 @ 1
[    0.583024] device class 'firmware': registering
[    0.583238] initcall firmware_class_init+0x0/0x61 returned 0 after 206 usecs
[    0.583345] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    0.583472] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 32 usecs
[    0.583604] calling  init_acpi_pm_clocksource+0x0/0x1aa @ 1
[    0.618250] initcall init_acpi_pm_clocksource+0x0/0x1aa returned 0 after 33742 usecs
[    0.618383] calling  ssb_modinit+0x0/0x41 @ 1
[    0.618616] bus: 'ssb': registered
[    0.618741] initcall ssb_modinit+0x0/0x41 returned 0 after 258 usecs
[    0.618835] calling  pcibios_assign_resources+0x0/0x76 @ 1
[    0.619050] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.619143] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.619243] pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
[    0.619339] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.619440] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.619534] pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
[    0.619633] pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
[    0.619730] pci 0000:00:1c.1:   PREFETCH window: 0x000000e4000000-0x000000e40fffff
[    0.620649] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.620745] pci 0000:00:1c.2:   IO window: 0x5000-0x6fff
[    0.620843] pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
[    0.620940] pci 0000:00:1c.2:   PREFETCH window: 0x000000e4100000-0x000000e41fffff
[    0.621080] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
[    0.621174] pci 0000:00:1c.3:   IO window: 0x7000-0x8fff
[    0.621273] pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
[    0.621370] pci 0000:00:1c.3:   PREFETCH window: 0x000000e4200000-0x000000e42fffff
[    0.621521] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.621614] pci 0000:15:00.0:   IO window: 0x009000-0x0090ff
[    0.621712] pci 0000:15:00.0:   IO window: 0x009400-0x0094ff
[    0.621809] pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
[    0.621911] pci 0000:15:00.0:   MEM window: 0x80000000-0x83ffffff
[    0.622009] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
[    0.622104] pci 0000:00:1e.0:   IO window: 0x9000-0xcfff
[    0.622202] pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
[    0.622300] pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
[    0.622459] IOAPIC[0]: Set routing entry (1-20 -> 0x49 -> IRQ 20 Mode:1 Active:1)
[    0.622592] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.622691] pci 0000:00:1c.0: setting latency timer to 64
[    0.622797] IOAPIC[0]: Set routing entry (1-21 -> 0x51 -> IRQ 21 Mode:1 Active:1)
[    0.622929] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.623028] pci 0000:00:1c.1: setting latency timer to 64
[    0.623133] IOAPIC[0]: Set routing entry (1-22 -> 0x59 -> IRQ 22 Mode:1 Active:1)
[    0.623266] pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    0.623374] pci 0000:00:1c.2: setting latency timer to 64
[    0.623479] IOAPIC[0]: Set routing entry (1-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
[    0.623613] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.623711] pci 0000:00:1c.3: setting latency timer to 64
[    0.623809] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.623908] pci 0000:00:1e.0: setting latency timer to 64
[    0.624015] IOAPIC[0]: Set routing entry (1-16 -> 0x69 -> IRQ 16 Mode:1 Active:1)
[    0.624148] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.624248] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.624340] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.624433] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.624526] pci_bus 0000:02: resource 1 mem: [0xee000000-0xee0fffff]
[    0.624619] pci_bus 0000:03: resource 0 io:  [0x3000-0x4fff]
[    0.624711] pci_bus 0000:03: resource 1 mem: [0xec000000-0xedffffff]
[    0.624805] pci_bus 0000:03: resource 2 pref mem [0xe4000000-0xe40fffff]
[    0.624898] pci_bus 0000:04: resource 0 io:  [0x5000-0x6fff]
[    0.624989] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe9ffffff]
[    0.625083] pci_bus 0000:04: resource 2 pref mem [0xe4100000-0xe41fffff]
[    0.625177] pci_bus 0000:0c: resource 0 io:  [0x7000-0x8fff]
[    0.625270] pci_bus 0000:0c: resource 1 mem: [0xea000000-0xebffffff]
[    0.625363] pci_bus 0000:0c: resource 2 pref mem [0xe4200000-0xe42fffff]
[    0.625457] pci_bus 0000:15: resource 0 io:  [0x9000-0xcfff]
[    0.625549] pci_bus 0000:15: resource 1 mem: [0xe4300000-0xe7ffffff]
[    0.625642] pci_bus 0000:15: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    0.625736] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
[    0.625828] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffff]
[    0.625921] pci_bus 0000:16: resource 0 io:  [0x9000-0x90ff]
[    0.626012] pci_bus 0000:16: resource 1 io:  [0x9400-0x94ff]
[    0.626104] pci_bus 0000:16: resource 2 pref mem [0xe0000000-0xe3ffffff]
[    0.626199] pci_bus 0000:16: resource 3 mem: [0x80000000-0x83ffffff]
[    0.626295] initcall pcibios_assign_resources+0x0/0x76 returned 0 after 7193 usecs
[    0.626427] calling  sysctl_core_init+0x0/0x2d @ 1
[    0.626554] initcall sysctl_core_init+0x0/0x2d returned 0 after 33 usecs
[    0.626658] calling  inet_init+0x0/0x1b3 @ 1
[    0.626769] NET: Registered protocol family 2
[    0.666736] IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.667509] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.669500] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.679664] TCP: Hash tables configured (established 262144 bind 65536)
[    0.679821] TCP reno registered
[    0.690139] initcall inet_init+0x0/0x1b3 returned 0 after 61897 usecs
[    0.690236] calling  af_unix_init+0x0/0x47 @ 1
[    0.690331] NET: Registered protocol family 1
[    0.690434] initcall af_unix_init+0x0/0x47 returned 0 after 103 usecs
[    0.690530] calling  populate_rootfs+0x0/0x104 @ 1
[    0.691001] initcall populate_rootfs+0x0/0x104 returned 0 after 368 usecs
[    0.691097] calling  i8259A_init_sysfs+0x0/0x1d @ 1
[    0.691189] Registering sysdev class 'i8259'
[    0.691458] Registering sys device of class 'i8259'
[    0.691558] Registering sys device 'i82590'
[    0.691767] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 561 usecs
[    0.691863] calling  sbf_init+0x0/0xba @ 1
[    0.691958] Simple Boot Flag at 0x35 set to 0x1
[    0.692054] initcall sbf_init+0x0/0xba returned 0 after 96 usecs
[    0.692147] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    0.692238] Registering sysdev class 'i8237'
[    0.692443] Registering sys device of class 'i8237'
[    0.692543] Registering sys device 'i82370'
[    0.692747] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 495 usecs
[    0.692842] calling  add_rtc_cmos+0x0/0x7e @ 1
[    0.692939] initcall add_rtc_cmos+0x0/0x7e returned 0 after 6 usecs
[    0.693036] calling  cache_sysfs_init+0x0/0x55 @ 1
[    0.694293] initcall cache_sysfs_init+0x0/0x55 returned 0 after 1136 usecs
[    0.694390] calling  powernow_k6_init+0x0/0x85 @ 1
[    0.694483] initcall powernow_k6_init+0x0/0x85 returned -19 after 1 usecs
[    0.694577] calling  sc520_freq_init+0x0/0x84 @ 1
[    0.694669] initcall sc520_freq_init+0x0/0x84 returned -19 after 1 usecs
[    0.694763] calling  cpufreq_gx_init+0x0/0x1a6 @ 1
[    0.694856] initcall cpufreq_gx_init+0x0/0x1a6 returned -19 after 1 usecs
[    0.694950] calling  msr_init+0x0/0xfa @ 1
[    0.695049] device class 'msr': registering
[    0.695274] device: 'msr0': device_add
[    0.695394] PM: Adding info for No Bus:msr0
[    0.695668] device: 'msr1': device_add
[    0.695781] PM: Adding info for No Bus:msr1
[    0.695990] initcall msr_init+0x0/0xfa returned 0 after 925 usecs
[    0.696085] calling  apm_init+0x0/0x3a0 @ 1
[    0.696187] apm: BIOS not found.
[    0.696277] initcall apm_init+0x0/0x3a0 returned -19 after 99 usecs
[    0.696372] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    0.696463] Registering sysdev class 'ioapic'
[    0.696679] Registering sys device of class 'ioapic'
[    0.696776] Registering sys device 'ioapic0'
[    0.696983] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 505 usecs
[    0.697081] calling  add_pcspkr+0x0/0x40 @ 1
[    0.697173] Registering platform device 'pcspkr'. Parent at platform
[    0.697266] device: 'pcspkr': device_add
[    0.697365] bus: 'platform': add device pcspkr
[    0.697474] PM: Adding info for platform:pcspkr
[    0.697688] initcall add_pcspkr+0x0/0x40 returned 0 after 504 usecs
[    0.697785] calling  start_periodic_check_for_corruption+0x0/0x37 @ 1
[    0.697878] Scanning for low memory corruption every 60 seconds
[    0.697978] initcall start_periodic_check_for_corruption+0x0/0x37 returned 0 after 96 usecs
[    0.698112] calling  crc32c_intel_mod_init+0x0/0x1d @ 1
[    0.698206] initcall crc32c_intel_mod_init+0x0/0x1d returned -19 after 1 usecs
[    0.698335] calling  init_sched_debug_procfs+0x0/0x27 @ 1
[    0.698438] initcall init_sched_debug_procfs+0x0/0x27 returned 0 after 10 usecs
[    0.698574] calling  proc_schedstat_init+0x0/0x1c @ 1
[    0.698673] initcall proc_schedstat_init+0x0/0x1c returned 0 after 6 usecs
[    0.698768] calling  proc_execdomains_init+0x0/0x1c @ 1
[    0.698867] initcall proc_execdomains_init+0x0/0x1c returned 0 after 6 usecs
[    0.698962] calling  ioresources_init+0x0/0x31 @ 1
[    0.699066] initcall ioresources_init+0x0/0x31 returned 0 after 11 usecs
[    0.699160] calling  uid_cache_init+0x0/0x5e @ 1
[    0.699278] initcall uid_cache_init+0x0/0x5e returned 0 after 24 usecs
[    0.699373] calling  init_posix_timers+0x0/0xac @ 1
[    0.699470] initcall init_posix_timers+0x0/0xac returned 0 after 5 usecs
[    0.699564] calling  init_posix_cpu_timers+0x0/0x90 @ 1
[    0.699658] initcall init_posix_cpu_timers+0x0/0x90 returned 0 after 1 usecs
[    0.699753] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    0.699849] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 2 usecs
[    0.699956] calling  timekeeping_init_device+0x0/0x1d @ 1
[    0.700048] Registering sysdev class 'timekeeping'
[    0.700324] Registering sys device of class 'timekeeping'
[    0.700422] Registering sys device 'timekeeping0'
[    0.700635] initcall timekeeping_init_device+0x0/0x1d returned 0 after 570 usecs
[    0.700767] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    0.700859] Registering sysdev class 'clocksource'
[    0.701069] Registering sys device of class 'clocksource'
[    0.701166] Registering sys device 'clocksource0'
[    0.701383] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 509 usecs
[    0.701516] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    0.701616] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 6 usecs
[    0.701711] calling  lockdep_proc_init+0x0/0x4f @ 1
[    0.701821] initcall lockdep_proc_init+0x0/0x4f returned 0 after 16 usecs
[    0.701917] calling  futex_init+0x0/0x79 @ 1
[    0.702053] initcall futex_init+0x0/0x79 returned 0 after 43 usecs
[    0.702147] calling  init_rttest+0x0/0x10a @ 1
[    0.702241] Registering sysdev class 'rttest'
[    0.702515] Registering sys device of class 'rttest'
[    0.702612] Registering sys device 'rttest0'
[    0.702883] Registering sys device of class 'rttest'
[    0.702979] Registering sys device 'rttest1'
[    0.703249] Registering sys device of class 'rttest'
[    0.703358] Registering sys device 'rttest2'
[    0.703638] Registering sys device of class 'rttest'
[    0.703735] Registering sys device 'rttest3'
[    0.704011] Registering sys device of class 'rttest'
[    0.704108] Registering sys device 'rttest4'
[    0.705200] Registering sys device of class 'rttest'
[    0.705305] Registering sys device 'rttest5'
[    0.705579] Registering sys device of class 'rttest'
[    0.705676] Registering sys device 'rttest6'
[    0.705944] Registering sys device of class 'rttest'
[    0.706042] Registering sys device 'rttest7'
[    0.706249] Initializing RT-Tester: OK
[    0.706342] initcall init_rttest+0x0/0x10a returned 0 after 4005 usecs
[    0.706436] calling  proc_dma_init+0x0/0x1c @ 1
[    0.706535] initcall proc_dma_init+0x0/0x1c returned 0 after 7 usecs
[    0.706639] calling  proc_modules_init+0x0/0x1c @ 1
[    0.706737] initcall proc_modules_init+0x0/0x1c returned 0 after 6 usecs
[    0.706832] calling  kallsyms_init+0x0/0x1f @ 1
[    0.706929] initcall kallsyms_init+0x0/0x1f returned 0 after 6 usecs
[    0.707023] calling  snapshot_device_init+0x0/0xf @ 1
[    0.707161] device: 'snapshot': device_add
[    0.707385] PM: Adding info for No Bus:snapshot
[    0.707827] initcall snapshot_device_init+0x0/0xf returned 0 after 693 usecs
[    0.707923] calling  crash_save_vmcoreinfo_init+0x0/0x348 @ 1
[    0.708046] initcall crash_save_vmcoreinfo_init+0x0/0x348 returned 0 after 27 usecs
[    0.708178] calling  crash_notes_memory_init+0x0/0x31 @ 1
[    0.708277] initcall crash_notes_memory_init+0x0/0x31 returned 0 after 5 usecs
[    0.708407] calling  pid_namespaces_init+0x0/0x27 @ 1
[    0.708504] initcall pid_namespaces_init+0x0/0x27 returned 0 after 4 usecs
[    0.708600] calling  ikconfig_init+0x0/0x3a @ 1
[    0.708699] initcall ikconfig_init+0x0/0x3a returned 0 after 7 usecs
[    0.708793] calling  hung_task_init+0x0/0x5c @ 1
[    0.708947] initcall hung_task_init+0x0/0x5c returned 0 after 58 usecs
[    0.709043] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    0.709141] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 4 usecs
[    0.709238] calling  init_markers+0x0/0x14 @ 1
[    0.709331] initcall init_markers+0x0/0x14 returned 0 after 1 usecs
[    0.709424] calling  init_tracepoints+0x0/0x14 @ 1
[    0.709517] initcall init_tracepoints+0x0/0x14 returned 0 after 1 usecs
[    0.709611] calling  init_lstats_procfs+0x0/0x1f @ 1
[    0.709711] initcall init_lstats_procfs+0x0/0x1f returned 0 after 7 usecs
[    0.709805] calling  ftrace_mod_cmd_init+0x0/0xf @ 1
[    0.709931] initcall ftrace_mod_cmd_init+0x0/0xf returned 0 after 32 usecs
[    0.710037] calling  init_events+0x0/0x4b @ 1
[    0.710134] initcall init_events+0x0/0x4b returned 0 after 5 usecs
[    0.710228] calling  init_sched_switch_trace+0x0/0xf @ 1
[    0.710324] initcall init_sched_switch_trace+0x0/0xf returned 0 after 3 usecs
[    0.710420] calling  init_stack_trace+0x0/0xf @ 1
[    0.710513] initcall init_stack_trace+0x0/0xf returned 0 after 2 usecs
[    0.710608] calling  init_function_trace+0x0/0x35 @ 1
[    0.710705] initcall init_function_trace+0x0/0x35 returned 0 after 4 usecs
[    0.710800] calling  stack_trace_init+0x0/0x5b @ 1
[    0.710942] initcall stack_trace_init+0x0/0x5b returned 0 after 48 usecs
[    0.711037] calling  init_branch_tracer+0x0/0x2f @ 1
[    0.711133] initcall init_branch_tracer+0x0/0x2f returned 0 after 3 usecs
[    0.711228] calling  init_power_trace+0x0/0xf @ 1
[    0.711322] initcall init_power_trace+0x0/0xf returned 0 after 2 usecs
[    0.711415] calling  init_ksym_trace+0x0/0x47 @ 1
[    0.711517] initcall init_ksym_trace+0x0/0x47 returned 0 after 11 usecs
[    0.711612] calling  init_per_zone_pages_min+0x0/0x80 @ 1
[    0.711808] initcall init_per_zone_pages_min+0x0/0x80 returned 0 after 99 usecs
[    0.711947] calling  pdflush_init+0x0/0x20 @ 1
[    0.712153] initcall pdflush_init+0x0/0x20 returned 0 after 108 usecs
[    0.712250] calling  kswapd_init+0x0/0x1d @ 1
[    0.712421] initcall kswapd_init+0x0/0x1d returned 0 after 78 usecs
[    0.712516] calling  init_tmpfs+0x0/0xd1 @ 1
[    0.712830] initcall init_tmpfs+0x0/0xd1 returned 0 after 215 usecs
[    0.712923] calling  setup_vmstat+0x0/0xa8 @ 1
[    0.713047] initcall setup_vmstat+0x0/0xa8 returned 0 after 30 usecs
[    0.713141] calling  mm_sysfs_init+0x0/0x22 @ 1
[    0.713243] initcall mm_sysfs_init+0x0/0x22 returned 0 after 8 usecs
[    0.713347] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    0.713446] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 7 usecs
[    0.713540] calling  procswaps_init+0x0/0x1c @ 1
[    0.713638] initcall procswaps_init+0x0/0x1c returned 0 after 6 usecs
[    0.713731] calling  hugetlb_init+0x0/0x24a @ 1
[    0.713823] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.713941] initcall hugetlb_init+0x0/0x24a returned 0 after 116 usecs
[    0.714036] calling  slab_proc_init+0x0/0x1f @ 1
[    0.714134] initcall slab_proc_init+0x0/0x1f returned 0 after 6 usecs
[    0.714227] calling  slab_sysfs_init+0x0/0xb7 @ 1
[    0.724509] initcall slab_sysfs_init+0x0/0xb7 returned 0 after 9949 usecs
[    0.724606] calling  fasync_init+0x0/0x24 @ 1
[    0.724709] initcall fasync_init+0x0/0x24 returned 0 after 11 usecs
[    0.724803] calling  proc_filesystems_init+0x0/0x1c @ 1
[    0.724904] initcall proc_filesystems_init+0x0/0x1c returned 0 after 8 usecs
[    0.724999] calling  inotify_setup+0x0/0x11 @ 1
[    0.725091] initcall inotify_setup+0x0/0x11 returned 0 after 1 usecs
[    0.725185] calling  aio_setup+0x0/0xdd @ 1
[    0.725520] initcall aio_setup+0x0/0xdd returned 0 after 233 usecs
[    0.725615] calling  proc_locks_init+0x0/0x1c @ 1
[    0.725714] initcall proc_locks_init+0x0/0x1c returned 0 after 7 usecs
[    0.725808] calling  init_mbcache+0x0/0x11 @ 1
[    0.725901] initcall init_mbcache+0x0/0x11 returned 0 after 1 usecs
[    0.725994] calling  proc_cmdline_init+0x0/0x1c @ 1
[    0.726092] initcall proc_cmdline_init+0x0/0x1c returned 0 after 6 usecs
[    0.726187] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    0.726284] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 6 usecs
[    0.726379] calling  proc_devices_init+0x0/0x1c @ 1
[    0.726477] initcall proc_devices_init+0x0/0x1c returned 0 after 6 usecs
[    0.726571] calling  proc_interrupts_init+0x0/0x1c @ 1
[    0.726680] initcall proc_interrupts_init+0x0/0x1c returned 0 after 6 usecs
[    0.726775] calling  proc_loadavg_init+0x0/0x1c @ 1
[    0.726873] initcall proc_loadavg_init+0x0/0x1c returned 0 after 6 usecs
[    0.726968] calling  proc_meminfo_init+0x0/0x1c @ 1
[    0.727066] initcall proc_meminfo_init+0x0/0x1c returned 0 after 6 usecs
[    0.727160] calling  proc_stat_init+0x0/0x1c @ 1
[    0.727259] initcall proc_stat_init+0x0/0x1c returned 0 after 6 usecs
[    0.727353] calling  proc_uptime_init+0x0/0x1c @ 1
[    0.727450] initcall proc_uptime_init+0x0/0x1c returned 0 after 6 usecs
[    0.727544] calling  proc_version_init+0x0/0x1c @ 1
[    0.727643] initcall proc_version_init+0x0/0x1c returned 0 after 6 usecs
[    0.727737] calling  proc_kcore_init+0x0/0x40 @ 1
[    0.727836] initcall proc_kcore_init+0x0/0x40 returned 0 after 6 usecs
[    0.727929] calling  proc_kmsg_init+0x0/0x1f @ 1
[    0.728027] initcall proc_kmsg_init+0x0/0x1f returned 0 after 7 usecs
[    0.728119] calling  proc_page_init+0x0/0x37 @ 1
[    0.728224] initcall proc_page_init+0x0/0x37 returned 0 after 12 usecs
[    0.728318] calling  configfs_init+0x0/0xbb @ 1
[    0.728671] initcall configfs_init+0x0/0xbb returned 0 after 254 usecs
[    0.728765] calling  init_devpts_fs+0x0/0x4e @ 1
[    0.729137] initcall init_devpts_fs+0x0/0x4e returned 0 after 272 usecs
[    0.729231] calling  init_dlm+0x0/0x7f @ 1
[    0.729772] device: 'dlm-control': device_add
[    0.729896] PM: Adding info for No Bus:dlm-control
[    0.730125] device: 'dlm-monitor': device_add
[    0.730240] PM: Adding info for No Bus:dlm-monitor
[    0.730466] device: 'dlm_plock': device_add
[    0.730581] PM: Adding info for No Bus:dlm_plock
[    0.730785] DLM (built Jun 11 2009 02:22:42) installed
[    0.730879] initcall init_dlm+0x0/0x7f returned 0 after 1520 usecs
[    0.730973] calling  init_reiserfs_fs+0x0/0x72 @ 1
[    0.731284] initcall init_reiserfs_fs+0x0/0x72 returned 0 after 213 usecs
[    0.731379] calling  init_ext3_fs+0x0/0x5f @ 1
[    0.732220] initcall init_ext3_fs+0x0/0x5f returned 0 after 730 usecs
[    0.732313] calling  init_ext4_fs+0x0/0xc0 @ 1
[    0.733537] initcall init_ext4_fs+0x0/0xc0 returned 0 after 1105 usecs
[    0.733633] calling  journal_init+0x0/0xa9 @ 1
[    0.734401] initcall journal_init+0x0/0xa9 returned 0 after 659 usecs
[    0.734496] calling  journal_init+0x0/0xc6 @ 1
[    0.734650] initcall journal_init+0x0/0xc6 returned 0 after 60 usecs
[    0.734744] calling  init_cramfs_fs+0x0/0x29 @ 1
[    0.734862] initcall init_cramfs_fs+0x0/0x29 returned 0 after 24 usecs
[    0.734957] calling  init_ramfs_fs+0x0/0xf @ 1
[    0.735051] initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
[    0.735145] calling  init_hugetlbfs_fs+0x0/0x9d @ 1
[    0.735690] initcall init_hugetlbfs_fs+0x0/0x9d returned 0 after 438 usecs
[    0.735786] calling  vxfs_init+0x0/0x4d @ 1
[    0.736091] initcall vxfs_init+0x0/0x4d returned 0 after 208 usecs
[    0.736186] calling  init_nls_cp861+0x0/0xf @ 1
[    0.736309] initcall init_nls_cp861+0x0/0xf returned 0 after 30 usecs
[    0.736403] calling  init_nls_cp864+0x0/0xf @ 1
[    0.736496] initcall init_nls_cp864+0x0/0xf returned 0 after 1 usecs
[    0.736590] calling  init_nls_cp865+0x0/0xf @ 1
[    0.736749] initcall init_nls_cp865+0x0/0xf returned 0 after 1 usecs
[    0.736843] calling  init_nls_cp874+0x0/0xf @ 1
[    0.736936] initcall init_nls_cp874+0x0/0xf returned 0 after 1 usecs
[    0.737030] calling  init_nls_cp1250+0x0/0xf @ 1
[    0.737122] initcall init_nls_cp1250+0x0/0xf returned 0 after 1 usecs
[    0.737216] calling  init_nls_iso8859_1+0x0/0xf @ 1
[    0.737310] initcall init_nls_iso8859_1+0x0/0xf returned 0 after 1 usecs
[    0.737403] calling  init_nls_iso8859_2+0x0/0xf @ 1
[    0.737496] initcall init_nls_iso8859_2+0x0/0xf returned 0 after 1 usecs
[    0.737591] calling  init_nls_iso8859_3+0x0/0xf @ 1
[    0.737685] initcall init_nls_iso8859_3+0x0/0xf returned 0 after 1 usecs
[    0.737779] calling  init_nls_cp1255+0x0/0xf @ 1
[    0.737871] initcall init_nls_cp1255+0x0/0xf returned 0 after 1 usecs
[    0.737965] calling  init_ufs_fs+0x0/0x4f @ 1
[    0.738260] initcall init_ufs_fs+0x0/0x4f returned 0 after 198 usecs
[    0.738353] calling  init_qnx4_fs+0x0/0x5e @ 1
[    0.738652] QNX4 filesystem 0.2.3 registered.
[    0.738745] initcall init_qnx4_fs+0x0/0x5e returned 0 after 293 usecs
[    0.738838] calling  init_udf_fs+0x0/0x4f @ 1
[    0.739132] initcall init_udf_fs+0x0/0x4f returned 0 after 197 usecs
[    0.739226] calling  init_xfs_fs+0x0/0x90 @ 1
[    0.739316] SGI XFS with ACLs, security attributes, realtime, debug enabled
[    0.741305] initcall init_xfs_fs+0x0/0x90 returned 0 after 1940 usecs
[    0.741400] calling  ipc_init+0x0/0x20 @ 1
[    0.741501] msgmni has been set to 3980
[    0.741605] initcall ipc_init+0x0/0x20 returned 0 after 110 usecs
[    0.741698] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    0.741794] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 3 usecs
[    0.742673] calling  init_mqueue_fs+0x0/0xc5 @ 1
[    0.743195] initcall init_mqueue_fs+0x0/0xc5 returned 0 after 419 usecs
[    0.743403] calling  key_proc_init+0x0/0x4e @ 1
[    0.743509] initcall key_proc_init+0x0/0x4e returned 0 after 13 usecs
[    0.743603] calling  crypto_wq_init+0x0/0x47 @ 1
[    0.743824] initcall crypto_wq_init+0x0/0x47 returned 0 after 123 usecs
[    0.743920] calling  crypto_algapi_init+0x0/0xc @ 1
[    0.744022] initcall crypto_algapi_init+0x0/0xc returned 0 after 9 usecs
[    0.744116] calling  chainiv_module_init+0x0/0xf @ 1
[    0.744286] initcall chainiv_module_init+0x0/0xf returned 0 after 76 usecs
[    0.744381] calling  eseqiv_module_init+0x0/0xf @ 1
[    0.744475] initcall eseqiv_module_init+0x0/0xf returned 0 after 2 usecs
[    0.744569] calling  seqiv_module_init+0x0/0xf @ 1
[    0.744664] initcall seqiv_module_init+0x0/0xf returned 0 after 1 usecs
[    0.744757] calling  hmac_module_init+0x0/0xf @ 1
[    0.744850] initcall hmac_module_init+0x0/0xf returned 0 after 2 usecs
[    0.744944] calling  md4_mod_init+0x0/0xf @ 1
[    0.745291] initcall md4_mod_init+0x0/0xf returned 0 after 249 usecs
[    0.745388] calling  md5_mod_init+0x0/0xf @ 1
[    0.745577] initcall md5_mod_init+0x0/0xf returned 0 after 95 usecs
[    0.745673] calling  rmd256_mod_init+0x0/0xf @ 1
[    0.745870] initcall rmd256_mod_init+0x0/0xf returned 0 after 101 usecs
[    0.745966] calling  rmd320_mod_init+0x0/0xf @ 1
[    0.746172] initcall rmd320_mod_init+0x0/0xf returned 0 after 109 usecs
[    0.746268] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    0.746453] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 90 usecs
[    0.746549] calling  sha512_generic_mod_init+0x0/0x33 @ 1
[    0.746920] initcall sha512_generic_mod_init+0x0/0x33 returned 0 after 260 usecs
[    0.747052] calling  wp512_mod_init+0x0/0x52 @ 1
[    0.747553] initcall wp512_mod_init+0x0/0x52 returned 0 after 399 usecs
[    0.747651] calling  tgr192_mod_init+0x0/0x52 @ 1
[    0.748072] initcall tgr192_mod_init+0x0/0x52 returned 0 after 320 usecs
[    0.748169] calling  crypto_ecb_module_init+0x0/0xf @ 1
[    0.748264] initcall crypto_ecb_module_init+0x0/0xf returned 0 after 2 usecs
[    0.748360] calling  crypto_cbc_module_init+0x0/0xf @ 1
[    0.748454] initcall crypto_cbc_module_init+0x0/0xf returned 0 after 1 usecs
[    0.748551] calling  crypto_ctr_module_init+0x0/0x33 @ 1
[    0.748650] initcall crypto_ctr_module_init+0x0/0x33 returned 0 after 3 usecs
[    0.748746] calling  crypto_gcm_module_init+0x0/0x4d @ 1
[    0.748842] initcall crypto_gcm_module_init+0x0/0x4d returned 0 after 3 usecs
[    0.748938] calling  cryptd_init+0x0/0xc1 @ 1
[    0.749035] initcall cryptd_init+0x0/0xc1 returned 0 after 6 usecs
[    0.749128] calling  des_generic_mod_init+0x0/0x33 @ 1
[    0.749429] initcall des_generic_mod_init+0x0/0x33 returned 0 after 201 usecs
[    0.749526] calling  serpent_mod_init+0x0/0x33 @ 1
[    0.749853] initcall serpent_mod_init+0x0/0x33 returned 0 after 229 usecs
[    0.750021] calling  aes_init+0x0/0xf @ 1
[    0.750227] initcall aes_init+0x0/0xf returned 0 after 111 usecs
[    0.750323] calling  camellia_init+0x0/0xf @ 1
[    0.750529] initcall camellia_init+0x0/0xf returned 0 after 112 usecs
[    0.750626] calling  arc4_init+0x0/0xf @ 1
[    0.750846] initcall arc4_init+0x0/0xf returned 0 after 126 usecs
[    0.750942] calling  anubis_mod_init+0x0/0xf @ 1
[    0.751176] initcall anubis_mod_init+0x0/0xf returned 0 after 137 usecs
[    0.751273] calling  salsa20_generic_mod_init+0x0/0xf @ 1
[    0.751451] initcall salsa20_generic_mod_init+0x0/0xf returned 0 after 81 usecs
[    0.751585] calling  deflate_mod_init+0x0/0xf @ 1
[    0.752326] initcall deflate_mod_init+0x0/0xf returned 0 after 631 usecs
[    0.752423] calling  zlib_mod_init+0x0/0xf @ 1
[    0.753491] initcall zlib_mod_init+0x0/0xf returned 0 after 951 usecs
[    0.753587] calling  michael_mic_init+0x0/0xf @ 1
[    0.753783] initcall michael_mic_init+0x0/0xf returned 0 after 101 usecs
[    0.753877] calling  crc32c_mod_init+0x0/0xf @ 1
[    0.754087] initcall crc32c_mod_init+0x0/0xf returned 0 after 114 usecs
[    0.754182] calling  crypto_authenc_module_init+0x0/0xf @ 1
[    0.754279] initcall crypto_authenc_module_init+0x0/0xf returned 0 after 2 usecs
[    0.754410] calling  krng_mod_init+0x0/0xf @ 1
[    0.754553] alg: No test for stdrng (krng)
[    0.754672] initcall krng_mod_init+0x0/0xf returned 0 after 166 usecs
[    0.754767] calling  prng_mod_init+0x0/0x24 @ 1
[    0.754906] alg: No test for stdrng (ansi_cprng)
[    0.755026] initcall prng_mod_init+0x0/0x24 returned 0 after 163 usecs
[    0.755120] calling  proc_genhd_init+0x0/0x31 @ 1
[    0.755246] initcall proc_genhd_init+0x0/0x31 returned 0 after 30 usecs
[    0.755346] calling  noop_init+0x0/0x11 @ 1
[    0.755481] io scheduler noop registered (default)
[    0.755573] initcall noop_init+0x0/0x11 returned 0 after 132 usecs
[    0.755667] calling  debug_objects_init_debugfs+0x0/0x57 @ 1
[    0.755789] initcall debug_objects_init_debugfs+0x0/0x57 returned 0 after 27 usecs
[    0.755922] calling  libcrc32c_mod_init+0x0/0x3d @ 1
[    0.756018] initcall libcrc32c_mod_init+0x0/0x3d returned 0 after 3 usecs
[    0.756112] calling  percpu_counter_startup+0x0/0x16 @ 1
[    0.756210] initcall percpu_counter_startup+0x0/0x16 returned 0 after 3 usecs
[    0.756305] calling  dynamic_debug_init+0x0/0x107 @ 1
[    0.756668] initcall dynamic_debug_init+0x0/0x107 returned 0 after 263 usecs
[    0.756765] calling  bt8xxgpio_init+0x0/0x1b @ 1
[    0.756861] bus: 'pci': add driver bt8xxgpio
[    0.757202] initcall bt8xxgpio_init+0x0/0x1b returned 0 after 335 usecs
[    0.757298] calling  pci_init+0x0/0x31 @ 1
[    0.757472] initcall pci_init+0x0/0x31 returned 0 after 81 usecs
[    0.757566] calling  pci_proc_init+0x0/0x5b @ 1
[    0.757885] initcall pci_proc_init+0x0/0x5b returned 0 after 221 usecs
[    0.757979] calling  pcie_portdrv_init+0x0/0x41 @ 1
[    0.758218] bus: 'pci_express': registered
[    0.758308] bus: 'pci': add driver pcieport-driver
[    0.758411] bus: 'pci': driver_probe_device: matched device 0000:00:1c.0 with driver pcieport-driver
[    0.758548] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.0
[    0.758732] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.758832] device: '0000:00:1c.0:pcie01': device_add
[    0.758932] bus: 'pci_express': add device 0000:00:1c.0:pcie01
[    0.759042] PM: Adding info for pci_express:0000:00:1c.0:pcie01
[    0.759260] device: '0000:00:1c.0:pcie04': device_add
[    0.759359] bus: 'pci_express': add device 0000:00:1c.0:pcie04
[    0.759467] PM: Adding info for pci_express:0000:00:1c.0:pcie04
[    0.759761] driver: '0000:00:1c.0': driver_bound: bound to device 'pcieport-driver'
[    0.759933] bus: 'pci': really_probe: bound device 0000:00:1c.0 to driver pcieport-driver
[    0.760082] bus: 'pci': driver_probe_device: matched device 0000:00:1c.1 with driver pcieport-driver
[    0.760215] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.1
[    0.760396] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.760494] device: '0000:00:1c.1:pcie01': device_add
[    0.760593] bus: 'pci_express': add device 0000:00:1c.1:pcie01
[    0.760701] PM: Adding info for pci_express:0000:00:1c.1:pcie01
[    0.760921] device: '0000:00:1c.1:pcie04': device_add
[    0.761021] bus: 'pci_express': add device 0000:00:1c.1:pcie04
[    0.761129] PM: Adding info for pci_express:0000:00:1c.1:pcie04
[    0.761424] driver: '0000:00:1c.1': driver_bound: bound to device 'pcieport-driver'
[    0.761556] bus: 'pci': really_probe: bound device 0000:00:1c.1 to driver pcieport-driver
[    0.761693] bus: 'pci': driver_probe_device: matched device 0000:00:1c.2 with driver pcieport-driver
[    0.761827] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.2
[    0.762032] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.762131] device: '0000:00:1c.2:pcie01': device_add
[    0.762230] bus: 'pci_express': add device 0000:00:1c.2:pcie01
[    0.762338] PM: Adding info for pci_express:0000:00:1c.2:pcie01
[    0.762551] device: '0000:00:1c.2:pcie04': device_add
[    0.762651] bus: 'pci_express': add device 0000:00:1c.2:pcie04
[    0.762760] PM: Adding info for pci_express:0000:00:1c.2:pcie04
[    0.763056] driver: '0000:00:1c.2': driver_bound: bound to device 'pcieport-driver'
[    0.763190] bus: 'pci': really_probe: bound device 0000:00:1c.2 to driver pcieport-driver
[    0.763351] bus: 'pci': driver_probe_device: matched device 0000:00:1c.3 with driver pcieport-driver
[    0.763483] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:1c.3
[    0.763663] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.763761] device: '0000:00:1c.3:pcie01': device_add
[    0.763859] bus: 'pci_express': add device 0000:00:1c.3:pcie01
[    0.763968] PM: Adding info for pci_express:0000:00:1c.3:pcie01
[    0.764184] device: '0000:00:1c.3:pcie04': device_add
[    0.764282] bus: 'pci_express': add device 0000:00:1c.3:pcie04
[    0.764391] PM: Adding info for pci_express:0000:00:1c.3:pcie04
[    0.764684] driver: '0000:00:1c.3': driver_bound: bound to device 'pcieport-driver'
[    0.764818] bus: 'pci': really_probe: bound device 0000:00:1c.3 to driver pcieport-driver
[    0.765111] initcall pcie_portdrv_init+0x0/0x41 returned 0 after 6873 usecs
[    0.765207] calling  aer_service_init+0x0/0x1d @ 1
[    0.765299] bus: 'pci_express': add driver aer
[    0.765524] initcall aer_service_init+0x0/0x1d returned 0 after 217 usecs
[    0.765619] calling  genericbl_init+0x0/0xf @ 1
[    0.765710] bus: 'platform': add driver generic-bl
[    0.765941] initcall genericbl_init+0x0/0xf returned 0 after 225 usecs
[    0.766035] calling  cyber2000fb_init+0x0/0xb2 @ 1
[    0.766126] bus: 'pci': add driver CyberPro
[    0.766389] initcall cyber2000fb_init+0x0/0xb2 returned 0 after 255 usecs
[    0.766484] calling  matroxfb_init+0x0/0x89e @ 1
[    0.766575] bus: 'pci': add driver matroxfb
[    0.766840] initcall matroxfb_init+0x0/0x89e returned 0 after 258 usecs
[    0.766937] calling  matroxfb_crtc2_init+0x0/0x2d @ 1
[    0.767031] initcall matroxfb_crtc2_init+0x0/0x2d returned 0 after 1 usecs
[    0.767125] calling  rivafb_init+0x0/0x1ab @ 1
[    0.767215] rivafb_setup START
[    0.767304] bus: 'pci': add driver rivafb
[    0.767558] initcall rivafb_init+0x0/0x1ab returned 0 after 333 usecs
[    0.767653] calling  viafb_init+0x0/0xebd @ 1
[    0.767744] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    0.768709] I2C adapter driver [via_i2c] forgot to specify physical device
[    0.768813] device: 'i2c-0': device_add
[    0.769064] PM: Adding info for No Bus:i2c-0
[    0.769480] i2c-adapter i2c-0: adapter [via_i2c] registered
[    0.769751] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    0.769843] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    1.329984] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    1.330077] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    1.889988] i2c-adapter i2c-0: master_xfer[0] W, addr=0x08, len=1
[    1.890080] i2c-adapter i2c-0: master_xfer[1] R, addr=0x08, len=1
[    2.449977] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    2.450069] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    3.009968] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    3.010062] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    3.569970] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    3.570062] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    4.129968] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    4.130060] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    4.689957] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    4.690050] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    5.249953] i2c-adapter i2c-0: master_xfer[0] W, addr=0x50, len=1
[    5.250045] i2c-adapter i2c-0: master_xfer[1] R, addr=0x50, len=1
[    5.809956] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[    5.810049] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[    6.369952] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[    6.370044] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[    6.929943] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[    6.930036] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[    7.489939] i2c-adapter i2c-0: master_xfer[0] W, addr=0x40, len=1
[    7.490031] i2c-adapter i2c-0: master_xfer[1] R, addr=0x40, len=1
[    8.049935] i2c-adapter i2c-0: master_xfer[0] W, addr=0x38, len=1
[    8.050027] i2c-adapter i2c-0: master_xfer[1] R, addr=0x38, len=1
[    8.609940] ioremap failed
[    8.610029] initcall viafb_init+0x0/0xebd returned -1 after 7658479 usecs
[    8.610124] initcall viafb_init+0x0/0xebd returned with error code -1 
[    8.610217] calling  tdfxfb_init+0x0/0x10b @ 1
[    8.610308] bus: 'pci': add driver tdfxfb
[    8.610578] initcall tdfxfb_init+0x0/0x10b returned 0 after 262 usecs
[    8.610672] calling  vt8623fb_init+0x0/0xc2 @ 1
[    8.610762] bus: 'pci': add driver vt8623fb
[    8.611025] initcall vt8623fb_init+0x0/0xc2 returned 0 after 255 usecs
[    8.611119] calling  vmlfb_init+0x0/0x81 @ 1
[    8.611207] vmlfb: initializing
[    8.611294] bus: 'pci': add driver vmlfb
[    8.611544] initcall vmlfb_init+0x0/0x81 returned 0 after 326 usecs
[    8.611637] calling  arkfb_init+0x0/0xb5 @ 1
[    8.611728] bus: 'pci': add driver arkfb
[    8.611990] initcall arkfb_init+0x0/0xb5 returned 0 after 254 usecs
[    8.612083] calling  hgafb_init+0x0/0x75 @ 1
[    8.612173] bus: 'platform': add driver hgafb
[    8.612392] Registering platform device 'hgafb.0'. Parent at platform
[    8.612485] device: 'hgafb.0': device_add
[    8.612580] bus: 'platform': add device hgafb.0
[    8.612689] PM: Adding info for platform:hgafb.0
[    8.612893] bus: 'platform': driver_probe_device: matched device hgafb.0 with driver hgafb
[    8.613023] bus: 'platform': really_probe: probing driver hgafb with device hgafb.0
[    8.613173] hgafb: HGA card not detected.
[    8.613301] hgafb: probe of hgafb.0 failed with error -22
[    8.613399] initcall hgafb_init+0x0/0x75 returned 0 after 1196 usecs
[    8.613491] calling  sstfb_init+0x0/0x193 @ 1
[    8.613582] bus: 'pci': add driver sstfb
[    8.613832] initcall sstfb_init+0x0/0x193 returned 0 after 243 usecs
[    8.613925] calling  mb862xxfb_init+0x0/0x1b @ 1
[    8.614016] bus: 'pci': add driver mb862xxfb
[    8.614266] initcall mb862xxfb_init+0x0/0x1b returned 0 after 244 usecs
[    8.614361] calling  efifb_init+0x0/0x1b8 @ 1
[    8.614461] initcall efifb_init+0x0/0x1b8 returned -19 after 8 usecs
[    8.614553] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    8.614652] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 6 usecs
[    8.614746] calling  irqrouter_init_sysfs+0x0/0x33 @ 1
[    8.614837] Registering sysdev class 'irqrouter'
[    8.615044] Registering sys device of class 'irqrouter'
[    8.615140] Registering sys device 'irqrouter0'
[    8.615345] initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 493 usecs
[    8.615439] calling  acpi_button_init+0x0/0x4a @ 1
[    8.615539] bus: 'acpi': add driver button
[    8.615638] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
[    8.615769] bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
[    8.615930] device: 'input0': device_add
[    8.616103] PM: Adding info for No Bus:input0
[    8.616395] input: Power Button as /class/input/input0
[    8.616570] ACPI: Power Button [PWRF]
[    8.616671] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    8.616764] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
[    8.616908] bus: 'acpi': driver_probe_device: matched device PNP0C0D:00 with driver button
[    8.617039] bus: 'acpi': really_probe: probing driver button with device PNP0C0D:00
[    8.617204] device: 'input1': device_add
[    8.617368] PM: Adding info for No Bus:input1
[    8.617593] input: Lid Switch as /class/input/input1
[    8.618385] ACPI: Lid Switch [LID]
[    8.618477] driver: 'PNP0C0D:00': driver_bound: bound to device 'button'
[    8.618572] bus: 'acpi': really_probe: bound device PNP0C0D:00 to driver button
[    8.618705] bus: 'acpi': driver_probe_device: matched device PNP0C0E:00 with driver button
[    8.618836] bus: 'acpi': really_probe: probing driver button with device PNP0C0E:00
[    8.618997] device: 'input2': device_add
[    8.619162] PM: Adding info for No Bus:input2
[    8.619389] input: Sleep Button as /class/input/input2
[    8.619485] ACPI: Sleep Button [SLPB]
[    8.619576] driver: 'PNP0C0E:00': driver_bound: bound to device 'button'
[    8.619669] bus: 'acpi': really_probe: bound device PNP0C0E:00 to driver button
[    8.619973] initcall acpi_button_init+0x0/0x4a returned 0 after 4337 usecs
[    8.620068] calling  acpi_processor_init+0x0/0xe3 @ 1
[    8.620210] bus: 'acpi': add driver processor
[    8.620309] bus: 'acpi': driver_probe_device: matched device ACPI_CPU:00 with driver processor
[    8.620441] bus: 'acpi': really_probe: probing driver processor with device ACPI_CPU:00
[    8.621714] ACPI: SSDT 7f6e609e 001ED (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    8.624465] ACPI: SSDT 7f6e5de1 00238 (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    8.628834] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    8.629207] device: 'cooling_device0': device_add
[    8.629315] PM: Adding info for No Bus:cooling_device0
[    8.629634] processor ACPI_CPU:00: registered as cooling_device0
[    8.629734] ACPI: Processor [CPU0] (supports 8 throttling states)
[    8.629916] driver: 'ACPI_CPU:00': driver_bound: bound to device 'processor'
[    8.630010] bus: 'acpi': really_probe: bound device ACPI_CPU:00 to driver processor
[    8.630143] bus: 'acpi': driver_probe_device: matched device ACPI_CPU:01 with driver processor
[    8.630275] bus: 'acpi': really_probe: probing driver processor with device ACPI_CPU:01
[    8.631507] ACPI: SSDT 7f6e628b 00094 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    8.634255] ACPI: SSDT 7f6e6019 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    8.637917] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    8.638205] device: 'cooling_device1': device_add
[    8.638313] PM: Adding info for No Bus:cooling_device1
[    8.638564] processor ACPI_CPU:01: registered as cooling_device1
[    8.638663] ACPI: Processor [CPU1] (supports 8 throttling states)
[    8.638846] driver: 'ACPI_CPU:01': driver_bound: bound to device 'processor'
[    8.638940] bus: 'acpi': really_probe: bound device ACPI_CPU:01 to driver processor
[    8.639307] initcall acpi_processor_init+0x0/0xe3 returned 0 after 18697 usecs
[    8.639437] calling  acpi_container_init+0x0/0x3d @ 1
[    8.639528] bus: 'acpi': add driver container
[    8.649870] initcall acpi_container_init+0x0/0x3d returned 0 after 10097 usecs
[    8.650001] calling  acpi_battery_init+0x0/0x13 @ 1
[    8.650216] bus: 'acpi': add driver battery
[    8.650334] bus: 'acpi': driver_probe_device: matched device PNP0C0A:00 with driver battery
[    8.650465] bus: 'acpi': really_probe: probing driver battery with device PNP0C0A:00
[    8.689384] ACPI: Battery Slot [BAT0] (battery present)
[    8.689476] driver: 'PNP0C0A:00': driver_bound: bound to device 'battery'
[    8.689569] bus: 'acpi': really_probe: bound device PNP0C0A:00 to driver battery
[    8.689859] initcall acpi_battery_init+0x0/0x13 returned 0 after 38833 usecs
[    8.689954] calling  pnpbios_thread_init+0x0/0x78 @ 1
[    8.690047] initcall pnpbios_thread_init+0x0/0x78 returned 0 after 1 usecs
[    8.690140] calling  isapnp_init+0x0/0xc5c @ 1
[    8.690235] device: 'pnp1': device_add
[    8.690337] PM: Adding info for No Bus:pnp1
[    8.690427] isapnp: Scanning for PnP cards...
[    9.047623] isapnp: No Plug & Play device found
[    9.047716] initcall isapnp_init+0x0/0xc5c returned 0 after 349105 usecs
[    9.047810] calling  rand_initialize+0x0/0x2a @ 1
[    9.047945] initcall rand_initialize+0x0/0x2a returned 0 after 43 usecs
[    9.048039] calling  tty_init+0x0/0xd5 @ 1
[    9.048135] device: 'tty': device_add
[    9.048249] PM: Adding info for No Bus:tty
[    9.048529] device: 'console': device_add
[    9.048641] PM: Adding info for No Bus:console
[    9.048855] device: 'tty0': device_add
[    9.048967] PM: Adding info for No Bus:tty0
[    9.049939] device class 'vc': registering
[    9.050150] device: 'vcs': device_add
[    9.050262] PM: Adding info for No Bus:vcs
[    9.050525] device: 'vcsa': device_add
[    9.050636] PM: Adding info for No Bus:vcsa
[    9.050882] device: 'tty1': device_add
[    9.050994] PM: Adding info for No Bus:tty1
[    9.051200] device: 'tty2': device_add
[    9.051312] PM: Adding info for No Bus:tty2
[    9.051524] device: 'tty3': device_add
[    9.051641] PM: Adding info for No Bus:tty3
[    9.051870] device: 'tty4': device_add
[    9.051983] PM: Adding info for No Bus:tty4
[    9.052189] device: 'tty5': device_add
[    9.052301] PM: Adding info for No Bus:tty5
[    9.052507] device: 'tty6': device_add
[    9.052619] PM: Adding info for No Bus:tty6
[    9.052825] device: 'tty7': device_add
[    9.052937] PM: Adding info for No Bus:tty7
[    9.053144] device: 'tty8': device_add
[    9.053256] PM: Adding info for No Bus:tty8
[    9.053465] device: 'tty9': device_add
[    9.053578] PM: Adding info for No Bus:tty9
[    9.053788] device: 'tty10': device_add
[    9.053901] PM: Adding info for No Bus:tty10
[    9.054117] device: 'tty11': device_add
[    9.054230] PM: Adding info for No Bus:tty11
[    9.054437] device: 'tty12': device_add
[    9.054550] PM: Adding info for No Bus:tty12
[    9.054756] device: 'tty13': device_add
[    9.054868] PM: Adding info for No Bus:tty13
[    9.055087] device: 'tty14': device_add
[    9.055216] PM: Adding info for No Bus:tty14
[    9.055432] device: 'tty15': device_add
[    9.055551] PM: Adding info for No Bus:tty15
[    9.055769] device: 'tty16': device_add
[    9.055882] PM: Adding info for No Bus:tty16
[    9.056093] device: 'tty17': device_add
[    9.056207] PM: Adding info for No Bus:tty17
[    9.056419] device: 'tty18': device_add
[    9.056532] PM: Adding info for No Bus:tty18
[    9.056741] device: 'tty19': device_add
[    9.056854] PM: Adding info for No Bus:tty19
[    9.057066] device: 'tty20': device_add
[    9.057181] PM: Adding info for No Bus:tty20
[    9.057390] device: 'tty21': device_add
[    9.057503] PM: Adding info for No Bus:tty21
[    9.057715] device: 'tty22': device_add
[    9.057828] PM: Adding info for No Bus:tty22
[    9.058037] device: 'tty23': device_add
[    9.058150] PM: Adding info for No Bus:tty23
[    9.058376] device: 'tty24': device_add
[    9.058489] PM: Adding info for No Bus:tty24
[    9.058706] device: 'tty25': device_add
[    9.058819] PM: Adding info for No Bus:tty25
[    9.059029] device: 'tty26': device_add
[    9.059143] PM: Adding info for No Bus:tty26
[    9.059355] device: 'tty27': device_add
[    9.059497] PM: Adding info for No Bus:tty27
[    9.059704] device: 'tty28': device_add
[    9.059829] PM: Adding info for No Bus:tty28
[    9.060036] device: 'tty29': device_add
[    9.060155] PM: Adding info for No Bus:tty29
[    9.060362] device: 'tty30': device_add
[    9.060474] PM: Adding info for No Bus:tty30
[    9.060689] device: 'tty31': device_add
[    9.060802] PM: Adding info for No Bus:tty31
[    9.061012] device: 'tty32': device_add
[    9.061125] PM: Adding info for No Bus:tty32
[    9.061331] device: 'tty33': device_add
[    9.061444] PM: Adding info for No Bus:tty33
[    9.061651] device: 'tty34': device_add
[    9.061791] PM: Adding info for No Bus:tty34
[    9.062001] device: 'tty35': device_add
[    9.062114] PM: Adding info for No Bus:tty35
[    9.062320] device: 'tty36': device_add
[    9.062433] PM: Adding info for No Bus:tty36
[    9.062639] device: 'tty37': device_add
[    9.062761] PM: Adding info for No Bus:tty37
[    9.062974] device: 'tty38': device_add
[    9.063088] PM: Adding info for No Bus:tty38
[    9.063299] device: 'tty39': device_add
[    9.063412] PM: Adding info for No Bus:tty39
[    9.063619] device: 'tty40': device_add
[    9.063737] PM: Adding info for No Bus:tty40
[    9.063946] device: 'tty41': device_add
[    9.064060] PM: Adding info for No Bus:tty41
[    9.064266] device: 'tty42': device_add
[    9.064379] PM: Adding info for No Bus:tty42
[    9.064592] device: 'tty43': device_add
[    9.064705] PM: Adding info for No Bus:tty43
[    9.064912] device: 'tty44': device_add
[    9.065041] PM: Adding info for No Bus:tty44
[    9.065252] device: 'tty45': device_add
[    9.065366] PM: Adding info for No Bus:tty45
[    9.065582] device: 'tty46': device_add
[    9.065695] PM: Adding info for No Bus:tty46
[    9.065907] device: 'tty47': device_add
[    9.066021] PM: Adding info for No Bus:tty47
[    9.066228] device: 'tty48': device_add
[    9.066342] PM: Adding info for No Bus:tty48
[    9.066554] device: 'tty49': device_add
[    9.066668] PM: Adding info for No Bus:tty49
[    9.066879] device: 'tty50': device_add
[    9.066993] PM: Adding info for No Bus:tty50
[    9.067200] device: 'tty51': device_add
[    9.067314] PM: Adding info for No Bus:tty51
[    9.067522] device: 'tty52': device_add
[    9.067641] PM: Adding info for No Bus:tty52
[    9.067852] device: 'tty53': device_add
[    9.067966] PM: Adding info for No Bus:tty53
[    9.068185] device: 'tty54': device_add
[    9.068299] PM: Adding info for No Bus:tty54
[    9.068795] device: 'tty55': device_add
[    9.068910] PM: Adding info for No Bus:tty55
[    9.069118] device: 'tty56': device_add
[    9.069233] PM: Adding info for No Bus:tty56
[    9.069439] device: 'tty57': device_add
[    9.069554] PM: Adding info for No Bus:tty57
[    9.069760] device: 'tty58': device_add
[    9.069875] PM: Adding info for No Bus:tty58
[    9.070083] device: 'tty59': device_add
[    9.070198] PM: Adding info for No Bus:tty59
[    9.070404] device: 'tty60': device_add
[    9.070519] PM: Adding info for No Bus:tty60
[    9.070726] device: 'tty61': device_add
[    9.070841] PM: Adding info for No Bus:tty61
[    9.071048] device: 'tty62': device_add
[    9.071162] PM: Adding info for No Bus:tty62
[    9.071368] device: 'tty63': device_add
[    9.071482] PM: Adding info for No Bus:tty63
[    9.071787] initcall tty_init+0x0/0xd5 returned 0 after 23102 usecs
[    9.071880] calling  pty_init+0x0/0x397 @ 1
[    9.071979] device: 'ptyp0': device_add
[    9.072098] PM: Adding info for No Bus:ptyp0
[    9.072375] device: 'ptyp1': device_add
[    9.072489] PM: Adding info for No Bus:ptyp1
[    9.072703] device: 'ptyp2': device_add
[    9.072817] PM: Adding info for No Bus:ptyp2
[    9.073028] device: 'ptyp3': device_add
[    9.073142] PM: Adding info for No Bus:ptyp3
[    9.073354] device: 'ptyp4': device_add
[    9.073468] PM: Adding info for No Bus:ptyp4
[    9.073681] device: 'ptyp5': device_add
[    9.073795] PM: Adding info for No Bus:ptyp5
[    9.074002] device: 'ptyp6': device_add
[    9.074116] PM: Adding info for No Bus:ptyp6
[    9.074326] device: 'ptyp7': device_add
[    9.074440] PM: Adding info for No Bus:ptyp7
[    9.074659] device: 'ptyp8': device_add
[    9.074773] PM: Adding info for No Bus:ptyp8
[    9.074982] device: 'ptyp9': device_add
[    9.075140] PM: Adding info for No Bus:ptyp9
[    9.075526] device: 'ptypa': device_add
[    9.075641] PM: Adding info for No Bus:ptypa
[    9.075849] device: 'ptypb': device_add
[    9.075963] PM: Adding info for No Bus:ptypb
[    9.076170] device: 'ptypc': device_add
[    9.076289] PM: Adding info for No Bus:ptypc
[    9.076497] device: 'ptypd': device_add
[    9.076611] PM: Adding info for No Bus:ptypd
[    9.076820] device: 'ptype': device_add
[    9.076934] PM: Adding info for No Bus:ptype
[    9.077148] device: 'ptypf': device_add
[    9.077263] PM: Adding info for No Bus:ptypf
[    9.077469] device: 'ptyq0': device_add
[    9.077583] PM: Adding info for No Bus:ptyq0
[    9.077794] device: 'ptyq1': device_add
[    9.077908] PM: Adding info for No Bus:ptyq1
[    9.078115] device: 'ptyq2': device_add
[    9.078230] PM: Adding info for No Bus:ptyq2
[    9.078452] device: 'ptyq3': device_add
[    9.078567] PM: Adding info for No Bus:ptyq3
[    9.078773] device: 'ptyq4': device_add
[    9.078888] PM: Adding info for No Bus:ptyq4
[    9.079094] device: 'ptyq5': device_add
[    9.079208] PM: Adding info for No Bus:ptyq5
[    9.079417] device: 'ptyq6': device_add
[    9.079531] PM: Adding info for No Bus:ptyq6
[    9.079741] device: 'ptyq7': device_add
[    9.080618] PM: Adding info for No Bus:ptyq7
[    9.080830] device: 'ptyq8': device_add
[    9.080950] PM: Adding info for No Bus:ptyq8
[    9.081162] device: 'ptyq9': device_add
[    9.081277] PM: Adding info for No Bus:ptyq9
[    9.081498] device: 'ptyqa': device_add
[    9.081613] PM: Adding info for No Bus:ptyqa
[    9.082173] device: 'ptyqb': device_add
[    9.082288] PM: Adding info for No Bus:ptyqb
[    9.082494] device: 'ptyqc': device_add
[    9.082609] PM: Adding info for No Bus:ptyqc
[    9.082815] device: 'ptyqd': device_add
[    9.082930] PM: Adding info for No Bus:ptyqd
[    9.083136] device: 'ptyqe': device_add
[    9.083251] PM: Adding info for No Bus:ptyqe
[    9.083459] device: 'ptyqf': device_add
[    9.083574] PM: Adding info for No Bus:ptyqf
[    9.083781] device: 'ptyr0': device_add
[    9.083896] PM: Adding info for No Bus:ptyr0
[    9.084101] device: 'ptyr1': device_add
[    9.084216] PM: Adding info for No Bus:ptyr1
[    9.084422] device: 'ptyr2': device_add
[    9.084538] PM: Adding info for No Bus:ptyr2
[    9.084743] device: 'ptyr3': device_add
[    9.084858] PM: Adding info for No Bus:ptyr3
[    9.085077] device: 'ptyr4': device_add
[    9.085197] PM: Adding info for No Bus:ptyr4
[    9.085408] device: 'ptyr5': device_add
[    9.085524] PM: Adding info for No Bus:ptyr5
[    9.085733] device: 'ptyr6': device_add
[    9.085849] PM: Adding info for No Bus:ptyr6
[    9.086058] device: 'ptyr7': device_add
[    9.086174] PM: Adding info for No Bus:ptyr7
[    9.086385] device: 'ptyr8': device_add
[    9.086501] PM: Adding info for No Bus:ptyr8
[    9.086708] device: 'ptyr9': device_add
[    9.086825] PM: Adding info for No Bus:ptyr9
[    9.087036] device: 'ptyra': device_add
[    9.087152] PM: Adding info for No Bus:ptyra
[    9.087365] device: 'ptyrb': device_add
[    9.087482] PM: Adding info for No Bus:ptyrb
[    9.087689] device: 'ptyrc': device_add
[    9.087805] PM: Adding info for No Bus:ptyrc
[    9.088017] device: 'ptyrd': device_add
[    9.088134] PM: Adding info for No Bus:ptyrd
[    9.088599] device: 'ptyre': device_add
[    9.088726] PM: Adding info for No Bus:ptyre
[    9.088935] device: 'ptyrf': device_add
[    9.089051] PM: Adding info for No Bus:ptyrf
[    9.089262] device: 'ptys0': device_add
[    9.089383] PM: Adding info for No Bus:ptys0
[    9.089589] device: 'ptys1': device_add
[    9.089705] PM: Adding info for No Bus:ptys1
[    9.089913] device: 'ptys2': device_add
[    9.090029] PM: Adding info for No Bus:ptys2
[    9.090235] device: 'ptys3': device_add
[    9.090351] PM: Adding info for No Bus:ptys3
[    9.090556] device: 'ptys4': device_add
[    9.090672] PM: Adding info for No Bus:ptys4
[    9.090880] device: 'ptys5': device_add
[    9.090996] PM: Adding info for No Bus:ptys5
[    9.091201] device: 'ptys6': device_add
[    9.091317] PM: Adding info for No Bus:ptys6
[    9.091522] device: 'ptys7': device_add
[    9.091638] PM: Adding info for No Bus:ptys7
[    9.091860] device: 'ptys8': device_add
[    9.091976] PM: Adding info for No Bus:ptys8
[    9.092186] device: 'ptys9': device_add
[    9.092303] PM: Adding info for No Bus:ptys9
[    9.092510] device: 'ptysa': device_add
[    9.092627] PM: Adding info for No Bus:ptysa
[    9.092836] device: 'ptysb': device_add
[    9.092953] PM: Adding info for No Bus:ptysb
[    9.093162] device: 'ptysc': device_add
[    9.093278] PM: Adding info for No Bus:ptysc
[    9.093484] device: 'ptysd': device_add
[    9.093606] PM: Adding info for No Bus:ptysd
[    9.093820] device: 'ptyse': device_add
[    9.093937] PM: Adding info for No Bus:ptyse
[    9.094146] device: 'ptysf': device_add
[    9.094263] PM: Adding info for No Bus:ptysf
[    9.094475] device: 'ptyt0': device_add
[    9.094592] PM: Adding info for No Bus:ptyt0
[    9.094801] device: 'ptyt1': device_add
[    9.094918] PM: Adding info for No Bus:ptyt1
[    9.095437] device: 'ptyt2': device_add
[    9.095554] PM: Adding info for No Bus:ptyt2
[    9.095761] device: 'ptyt3': device_add
[    9.095878] PM: Adding info for No Bus:ptyt3
[    9.096085] device: 'ptyt4': device_add
[    9.096202] PM: Adding info for No Bus:ptyt4
[    9.096408] device: 'ptyt5': device_add
[    9.096525] PM: Adding info for No Bus:ptyt5
[    9.096730] device: 'ptyt6': device_add
[    9.096847] PM: Adding info for No Bus:ptyt6
[    9.097051] device: 'ptyt7': device_add
[    9.097168] PM: Adding info for No Bus:ptyt7
[    9.097373] device: 'ptyt8': device_add
[    9.097491] PM: Adding info for No Bus:ptyt8
[    9.097695] device: 'ptyt9': device_add
[    9.097818] PM: Adding info for No Bus:ptyt9
[    9.098024] device: 'ptyta': device_add
[    9.098142] PM: Adding info for No Bus:ptyta
[    9.098566] device: 'ptytb': device_add
[    9.098684] PM: Adding info for No Bus:ptytb
[    9.098894] device: 'ptytc': device_add
[    9.099013] PM: Adding info for No Bus:ptytc
[    9.099221] device: 'ptytd': device_add
[    9.099339] PM: Adding info for No Bus:ptytd
[    9.099547] device: 'ptyte': device_add
[    9.099680] PM: Adding info for No Bus:ptyte
[    9.099889] device: 'ptytf': device_add
[    9.100007] PM: Adding info for No Bus:ptytf
[    9.100216] device: 'ptyu0': device_add
[    9.100335] PM: Adding info for No Bus:ptyu0
[    9.100546] device: 'ptyu1': device_add
[    9.100664] PM: Adding info for No Bus:ptyu1
[    9.100875] device: 'ptyu2': device_add
[    9.100994] PM: Adding info for No Bus:ptyu2
[    9.101205] device: 'ptyu3': device_add
[    9.101324] PM: Adding info for No Bus:ptyu3
[    9.101531] device: 'ptyu4': device_add
[    9.101650] PM: Adding info for No Bus:ptyu4
[    9.102030] device: 'ptyu5': device_add
[    9.102154] PM: Adding info for No Bus:ptyu5
[    9.102362] device: 'ptyu6': device_add
[    9.102480] PM: Adding info for No Bus:ptyu6
[    9.102685] device: 'ptyu7': device_add
[    9.102803] PM: Adding info for No Bus:ptyu7
[    9.103013] device: 'ptyu8': device_add
[    9.103131] PM: Adding info for No Bus:ptyu8
[    9.103337] device: 'ptyu9': device_add
[    9.103455] PM: Adding info for No Bus:ptyu9
[    9.103661] device: 'ptyua': device_add
[    9.103779] PM: Adding info for No Bus:ptyua
[    9.103984] device: 'ptyub': device_add
[    9.104103] PM: Adding info for No Bus:ptyub
[    9.104310] device: 'ptyuc': device_add
[    9.104428] PM: Adding info for No Bus:ptyuc
[    9.104634] device: 'ptyud': device_add
[    9.104753] PM: Adding info for No Bus:ptyud
[    9.104959] device: 'ptyue': device_add
[    9.105093] PM: Adding info for No Bus:ptyue
[    9.105300] device: 'ptyuf': device_add
[    9.105419] PM: Adding info for No Bus:ptyuf
[    9.105628] device: 'ptyv0': device_add
[    9.105747] PM: Adding info for No Bus:ptyv0
[    9.105955] device: 'ptyv1': device_add
[    9.106079] PM: Adding info for No Bus:ptyv1
[    9.106287] device: 'ptyv2': device_add
[    9.106405] PM: Adding info for No Bus:ptyv2
[    9.106622] device: 'ptyv3': device_add
[    9.106741] PM: Adding info for No Bus:ptyv3
[    9.106951] device: 'ptyv4': device_add
[    9.107070] PM: Adding info for No Bus:ptyv4
[    9.107284] device: 'ptyv5': device_add
[    9.107404] PM: Adding info for No Bus:ptyv5
[    9.107609] device: 'ptyv6': device_add
[    9.107728] PM: Adding info for No Bus:ptyv6
[    9.107934] device: 'ptyv7': device_add
[    9.108053] PM: Adding info for No Bus:ptyv7
[    9.108260] device: 'ptyv8': device_add
[    9.108402] PM: Adding info for No Bus:ptyv8
[    9.108831] device: 'ptyv9': device_add
[    9.108974] PM: Adding info for No Bus:ptyv9
[    9.109183] device: 'ptyva': device_add
[    9.109313] PM: Adding info for No Bus:ptyva
[    9.109520] device: 'ptyvb': device_add
[    9.109643] PM: Adding info for No Bus:ptyvb
[    9.109851] device: 'ptyvc': device_add
[    9.109970] PM: Adding info for No Bus:ptyvc
[    9.110177] device: 'ptyvd': device_add
[    9.110301] PM: Adding info for No Bus:ptyvd
[    9.110508] device: 'ptyve': device_add
[    9.110626] PM: Adding info for No Bus:ptyve
[    9.110835] device: 'ptyvf': device_add
[    9.110954] PM: Adding info for No Bus:ptyvf
[    9.111166] device: 'ptyw0': device_add
[    9.111285] PM: Adding info for No Bus:ptyw0
[    9.111491] device: 'ptyw1': device_add
[    9.112387] PM: Adding info for No Bus:ptyw1
[    9.112593] device: 'ptyw2': device_add
[    9.112712] PM: Adding info for No Bus:ptyw2
[    9.112918] device: 'ptyw3': device_add
[    9.113037] PM: Adding info for No Bus:ptyw3
[    9.113242] device: 'ptyw4': device_add
[    9.113362] PM: Adding info for No Bus:ptyw4
[    9.113569] device: 'ptyw5': device_add
[    9.113688] PM: Adding info for No Bus:ptyw5
[    9.113895] device: 'ptyw6': device_add
[    9.114016] PM: Adding info for No Bus:ptyw6
[    9.114224] device: 'ptyw7': device_add
[    9.114344] PM: Adding info for No Bus:ptyw7
[    9.114552] device: 'ptyw8': device_add
[    9.114673] PM: Adding info for No Bus:ptyw8
[    9.114885] device: 'ptyw9': device_add
[    9.115396] PM: Adding info for No Bus:ptyw9
[    9.115607] device: 'ptywa': device_add
[    9.115727] PM: Adding info for No Bus:ptywa
[    9.115932] device: 'ptywb': device_add
[    9.116053] PM: Adding info for No Bus:ptywb
[    9.116258] device: 'ptywc': device_add
[    9.116378] PM: Adding info for No Bus:ptywc
[    9.116584] device: 'ptywd': device_add
[    9.116704] PM: Adding info for No Bus:ptywd
[    9.116913] device: 'ptywe': device_add
[    9.117034] PM: Adding info for No Bus:ptywe
[    9.117239] device: 'ptywf': device_add
[    9.117359] PM: Adding info for No Bus:ptywf
[    9.117567] device: 'ptyx0': device_add
[    9.117687] PM: Adding info for No Bus:ptyx0
[    9.117893] device: 'ptyx1': device_add
[    9.118014] PM: Adding info for No Bus:ptyx1
[    9.118221] device: 'ptyx2': device_add
[    9.118366] PM: Adding info for No Bus:ptyx2
[    9.118799] device: 'ptyx3': device_add
[    9.118920] PM: Adding info for No Bus:ptyx3
[    9.119127] device: 'ptyx4': device_add
[    9.119247] PM: Adding info for No Bus:ptyx4
[    9.119453] device: 'ptyx5': device_add
[    9.119579] PM: Adding info for No Bus:ptyx5
[    9.119786] device: 'ptyx6': device_add
[    9.119907] PM: Adding info for No Bus:ptyx6
[    9.120113] device: 'ptyx7': device_add
[    9.120234] PM: Adding info for No Bus:ptyx7
[    9.120444] device: 'ptyx8': device_add
[    9.120565] PM: Adding info for No Bus:ptyx8
[    9.120774] device: 'ptyx9': device_add
[    9.120896] PM: Adding info for No Bus:ptyx9
[    9.121104] device: 'ptyxa': device_add
[    9.121225] PM: Adding info for No Bus:ptyxa
[    9.121434] device: 'ptyxb': device_add
[    9.121555] PM: Adding info for No Bus:ptyxb
[    9.121776] device: 'ptyxc': device_add
[    9.121898] PM: Adding info for No Bus:ptyxc
[    9.122108] device: 'ptyxd': device_add
[    9.122230] PM: Adding info for No Bus:ptyxd
[    9.122435] device: 'ptyxe': device_add
[    9.122556] PM: Adding info for No Bus:ptyxe
[    9.122764] device: 'ptyxf': device_add
[    9.122885] PM: Adding info for No Bus:ptyxf
[    9.123090] device: 'ptyy0': device_add
[    9.123211] PM: Adding info for No Bus:ptyy0
[    9.123416] device: 'ptyy1': device_add
[    9.123538] PM: Adding info for No Bus:ptyy1
[    9.123746] device: 'ptyy2': device_add
[    9.123873] PM: Adding info for No Bus:ptyy2
[    9.124081] device: 'ptyy3': device_add
[    9.124202] PM: Adding info for No Bus:ptyy3
[    9.124408] device: 'ptyy4': device_add
[    9.124530] PM: Adding info for No Bus:ptyy4
[    9.124735] device: 'ptyy5': device_add
[    9.124857] PM: Adding info for No Bus:ptyy5
[    9.125280] device: 'ptyy6': device_add
[    9.125402] PM: Adding info for No Bus:ptyy6
[    9.125613] device: 'ptyy7': device_add
[    9.125735] PM: Adding info for No Bus:ptyy7
[    9.125946] device: 'ptyy8': device_add
[    9.126068] PM: Adding info for No Bus:ptyy8
[    9.126276] device: 'ptyy9': device_add
[    9.126399] PM: Adding info for No Bus:ptyy9
[    9.126608] device: 'ptyya': device_add
[    9.126730] PM: Adding info for No Bus:ptyya
[    9.126941] device: 'ptyyb': device_add
[    9.127063] PM: Adding info for No Bus:ptyyb
[    9.127272] device: 'ptyyc': device_add
[    9.127395] PM: Adding info for No Bus:ptyyc
[    9.127604] device: 'ptyyd': device_add
[    9.127726] PM: Adding info for No Bus:ptyyd
[    9.127934] device: 'ptyye': device_add
[    9.128062] PM: Adding info for No Bus:ptyye
[    9.128271] device: 'ptyyf': device_add
[    9.128408] PM: Adding info for No Bus:ptyyf
[    9.128615] device: 'ptyz0': device_add
[    9.128738] PM: Adding info for No Bus:ptyz0
[    9.128948] device: 'ptyz1': device_add
[    9.129071] PM: Adding info for No Bus:ptyz1
[    9.129283] device: 'ptyz2': device_add
[    9.129405] PM: Adding info for No Bus:ptyz2
[    9.129612] device: 'ptyz3': device_add
[    9.129734] PM: Adding info for No Bus:ptyz3
[    9.129940] device: 'ptyz4': device_add
[    9.130063] PM: Adding info for No Bus:ptyz4
[    9.130272] device: 'ptyz5': device_add
[    9.130395] PM: Adding info for No Bus:ptyz5
[    9.130600] device: 'ptyz6': device_add
[    9.130723] PM: Adding info for No Bus:ptyz6
[    9.130932] device: 'ptyz7': device_add
[    9.131055] PM: Adding info for No Bus:ptyz7
[    9.131261] device: 'ptyz8': device_add
[    9.131384] PM: Adding info for No Bus:ptyz8
[    9.131590] device: 'ptyz9': device_add
[    9.131741] PM: Adding info for No Bus:ptyz9
[    9.132149] device: 'ptyza': device_add
[    9.132277] PM: Adding info for No Bus:ptyza
[    9.132484] device: 'ptyzb': device_add
[    9.132607] PM: Adding info for No Bus:ptyzb
[    9.132812] device: 'ptyzc': device_add
[    9.132935] PM: Adding info for No Bus:ptyzc
[    9.133141] device: 'ptyzd': device_add
[    9.133264] PM: Adding info for No Bus:ptyzd
[    9.133470] device: 'ptyze': device_add
[    9.133593] PM: Adding info for No Bus:ptyze
[    9.133797] device: 'ptyzf': device_add
[    9.133920] PM: Adding info for No Bus:ptyzf
[    9.134127] device: 'ptya0': device_add
[    9.134250] PM: Adding info for No Bus:ptya0
[    9.134457] device: 'ptya1': device_add
[    9.134581] PM: Adding info for No Bus:ptya1
[    9.134788] device: 'ptya2': device_add
[    9.134912] PM: Adding info for No Bus:ptya2
[    9.135132] device: 'ptya3': device_add
[    9.135256] PM: Adding info for No Bus:ptya3
[    9.135460] device: 'ptya4': device_add
[    9.135583] PM: Adding info for No Bus:ptya4
[    9.135790] device: 'ptya5': device_add
[    9.135914] PM: Adding info for No Bus:ptya5
[    9.136120] device: 'ptya6': device_add
[    9.136249] PM: Adding info for No Bus:ptya6
[    9.136468] device: 'ptya7': device_add
[    9.136592] PM: Adding info for No Bus:ptya7
[    9.136798] device: 'ptya8': device_add
[    9.136923] PM: Adding info for No Bus:ptya8
[    9.137134] device: 'ptya9': device_add
[    9.137258] PM: Adding info for No Bus:ptya9
[    9.137466] device: 'ptyaa': device_add
[    9.137591] PM: Adding info for No Bus:ptyaa
[    9.137801] device: 'ptyab': device_add
[    9.137926] PM: Adding info for No Bus:ptyab
[    9.138141] device: 'ptyac': device_add
[    9.138265] PM: Adding info for No Bus:ptyac
[    9.138812] device: 'ptyad': device_add
[    9.138937] PM: Adding info for No Bus:ptyad
[    9.139144] device: 'ptyae': device_add
[    9.139268] PM: Adding info for No Bus:ptyae
[    9.139474] device: 'ptyaf': device_add
[    9.139599] PM: Adding info for No Bus:ptyaf
[    9.139804] device: 'ptyb0': device_add
[    9.139929] PM: Adding info for No Bus:ptyb0
[    9.140135] device: 'ptyb1': device_add
[    9.140259] PM: Adding info for No Bus:ptyb1
[    9.140465] device: 'ptyb2': device_add
[    9.140595] PM: Adding info for No Bus:ptyb2
[    9.140800] device: 'ptyb3': device_add
[    9.140925] PM: Adding info for No Bus:ptyb3
[    9.141133] device: 'ptyb4': device_add
[    9.141258] PM: Adding info for No Bus:ptyb4
[    9.141463] device: 'ptyb5': device_add
[    9.141588] PM: Adding info for No Bus:ptyb5
[    9.141806] device: 'ptyb6': device_add
[    9.141932] PM: Adding info for No Bus:ptyb6
[    9.142137] device: 'ptyb7': device_add
[    9.142262] PM: Adding info for No Bus:ptyb7
[    9.142470] device: 'ptyb8': device_add
[    9.142595] PM: Adding info for No Bus:ptyb8
[    9.142801] device: 'ptyb9': device_add
[    9.142926] PM: Adding info for No Bus:ptyb9
[    9.143136] device: 'ptyba': device_add
[    9.143261] PM: Adding info for No Bus:ptyba
[    9.143471] device: 'ptybb': device_add
[    9.144348] PM: Adding info for No Bus:ptybb
[    9.144553] device: 'ptybc': device_add
[    9.144678] PM: Adding info for No Bus:ptybc
[    9.144883] device: 'ptybd': device_add
[    9.145029] PM: Adding info for No Bus:ptybd
[    9.145456] device: 'ptybe': device_add
[    9.145600] PM: Adding info for No Bus:ptybe
[    9.145807] device: 'ptybf': device_add
[    9.145933] PM: Adding info for No Bus:ptybf
[    9.146139] device: 'ptyc0': device_add
[    9.146265] PM: Adding info for No Bus:ptyc0
[    9.146476] device: 'ptyc1': device_add
[    9.146603] PM: Adding info for No Bus:ptyc1
[    9.146811] device: 'ptyc2': device_add
[    9.146937] PM: Adding info for No Bus:ptyc2
[    9.147142] device: 'ptyc3': device_add
[    9.147268] PM: Adding info for No Bus:ptyc3
[    9.147473] device: 'ptyc4': device_add
[    9.147600] PM: Adding info for No Bus:ptyc4
[    9.147805] device: 'ptyc5': device_add
[    9.147931] PM: Adding info for No Bus:ptyc5
[    9.148136] device: 'ptyc6': device_add
[    9.148262] PM: Adding info for No Bus:ptyc6
[    9.148485] device: 'ptyc7': device_add
[    9.148611] PM: Adding info for No Bus:ptyc7
[    9.148817] device: 'ptyc8': device_add
[    9.148944] PM: Adding info for No Bus:ptyc8
[    9.149149] device: 'ptyc9': device_add
[    9.149276] PM: Adding info for No Bus:ptyc9
[    9.149481] device: 'ptyca': device_add
[    9.149613] PM: Adding info for No Bus:ptyca
[    9.149824] device: 'ptycb': device_add
[    9.149950] PM: Adding info for No Bus:ptycb
[    9.150156] device: 'ptycc': device_add
[    9.150283] PM: Adding info for No Bus:ptycc
[    9.150490] device: 'ptycd': device_add
[    9.150617] PM: Adding info for No Bus:ptycd
[    9.150826] device: 'ptyce': device_add
[    9.150953] PM: Adding info for No Bus:ptyce
[    9.151157] device: 'ptycf': device_add
[    9.151284] PM: Adding info for No Bus:ptycf
[    9.151490] device: 'ptyd0': device_add
[    9.151617] PM: Adding info for No Bus:ptyd0
[    9.152169] device: 'ptyd1': device_add
[    9.152297] PM: Adding info for No Bus:ptyd1
[    9.152502] device: 'ptyd2': device_add
[    9.152629] PM: Adding info for No Bus:ptyd2
[    9.152833] device: 'ptyd3': device_add
[    9.152961] PM: Adding info for No Bus:ptyd3
[    9.153166] device: 'ptyd4': device_add
[    9.153294] PM: Adding info for No Bus:ptyd4
[    9.153503] device: 'ptyd5': device_add
[    9.153639] PM: Adding info for No Bus:ptyd5
[    9.153848] device: 'ptyd6': device_add
[    9.153976] PM: Adding info for No Bus:ptyd6
[    9.154183] device: 'ptyd7': device_add
[    9.154316] PM: Adding info for No Bus:ptyd7
[    9.154522] device: 'ptyd8': device_add
[    9.154649] PM: Adding info for No Bus:ptyd8
[    9.154856] device: 'ptyd9': device_add
[    9.154984] PM: Adding info for No Bus:ptyd9
[    9.155209] device: 'ptyda': device_add
[    9.155337] PM: Adding info for No Bus:ptyda
[    9.155547] device: 'ptydb': device_add
[    9.155675] PM: Adding info for No Bus:ptydb
[    9.155883] device: 'ptydc': device_add
[    9.156011] PM: Adding info for No Bus:ptydc
[    9.156218] device: 'ptydd': device_add
[    9.156346] PM: Adding info for No Bus:ptydd
[    9.156552] device: 'ptyde': device_add
[    9.156680] PM: Adding info for No Bus:ptyde
[    9.156887] device: 'ptydf': device_add
[    9.157015] PM: Adding info for No Bus:ptydf
[    9.157220] device: 'ptye0': device_add
[    9.157348] PM: Adding info for No Bus:ptye0
[    9.157556] device: 'ptye1': device_add
[    9.157685] PM: Adding info for No Bus:ptye1
[    9.157889] device: 'ptye2': device_add
[    9.158018] PM: Adding info for No Bus:ptye2
[    9.158226] device: 'ptye3': device_add
[    9.158384] PM: Adding info for No Bus:ptye3
[    9.158773] device: 'ptye4': device_add
[    9.158902] PM: Adding info for No Bus:ptye4
[    9.159106] device: 'ptye5': device_add
[    9.159236] PM: Adding info for No Bus:ptye5
[    9.159442] device: 'ptye6': device_add
[    9.159571] PM: Adding info for No Bus:ptye6
[    9.159777] device: 'ptye7': device_add
[    9.159933] PM: Adding info for No Bus:ptye7
[    9.160141] device: 'ptye8': device_add
[    9.160282] PM: Adding info for No Bus:ptye8
[    9.160488] device: 'ptye9': device_add
[    9.160617] PM: Adding info for No Bus:ptye9
[    9.160823] device: 'ptyea': device_add
[    9.160952] PM: Adding info for No Bus:ptyea
[    9.161164] device: 'ptyeb': device_add
[    9.161293] PM: Adding info for No Bus:ptyeb
[    9.161498] device: 'ptyec': device_add
[    9.161627] PM: Adding info for No Bus:ptyec
[    9.161847] device: 'ptyed': device_add
[    9.161977] PM: Adding info for No Bus:ptyed
[    9.162185] device: 'ptyee': device_add
[    9.162315] PM: Adding info for No Bus:ptyee
[    9.162521] device: 'ptyef': device_add
[    9.162656] PM: Adding info for No Bus:ptyef
[    9.162868] device: 'ttyp0': device_add
[    9.162993] PM: Adding info for No Bus:ttyp0
[    9.163199] device: 'ttyp1': device_add
[    9.163325] PM: Adding info for No Bus:ttyp1
[    9.163533] device: 'ttyp2': device_add
[    9.163659] PM: Adding info for No Bus:ttyp2
[    9.163864] device: 'ttyp3': device_add
[    9.163990] PM: Adding info for No Bus:ttyp3
[    9.164199] device: 'ttyp4': device_add
[    9.164325] PM: Adding info for No Bus:ttyp4
[    9.164534] device: 'ttyp5': device_add
[    9.164661] PM: Adding info for No Bus:ttyp5
[    9.164870] device: 'ttyp6': device_add
[    9.165031] PM: Adding info for No Bus:ttyp6
[    9.165457] device: 'ttyp7': device_add
[    9.165583] PM: Adding info for No Bus:ttyp7
[    9.165790] device: 'ttyp8': device_add
[    9.165917] PM: Adding info for No Bus:ttyp8
[    9.166125] device: 'ttyp9': device_add
[    9.166251] PM: Adding info for No Bus:ttyp9
[    9.166460] device: 'ttypa': device_add
[    9.166588] PM: Adding info for No Bus:ttypa
[    9.166796] device: 'ttypb': device_add
[    9.166928] PM: Adding info for No Bus:ttypb
[    9.167136] device: 'ttypc': device_add
[    9.167263] PM: Adding info for No Bus:ttypc
[    9.167469] device: 'ttypd': device_add
[    9.167596] PM: Adding info for No Bus:ttypd
[    9.167807] device: 'ttype': device_add
[    9.167934] PM: Adding info for No Bus:ttype
[    9.168139] device: 'ttypf': device_add
[    9.168266] PM: Adding info for No Bus:ttypf
[    9.168486] device: 'ttyq0': device_add
[    9.168613] PM: Adding info for No Bus:ttyq0
[    9.168818] device: 'ttyq1': device_add
[    9.168946] PM: Adding info for No Bus:ttyq1
[    9.169150] device: 'ttyq2': device_add
[    9.169277] PM: Adding info for No Bus:ttyq2
[    9.169483] device: 'ttyq3': device_add
[    9.169610] PM: Adding info for No Bus:ttyq3
[    9.169817] device: 'ttyq4': device_add
[    9.169944] PM: Adding info for No Bus:ttyq4
[    9.170157] device: 'ttyq5': device_add
[    9.170285] PM: Adding info for No Bus:ttyq5
[    9.170491] device: 'ttyq6': device_add
[    9.170619] PM: Adding info for No Bus:ttyq6
[    9.170827] device: 'ttyq7': device_add
[    9.170961] PM: Adding info for No Bus:ttyq7
[    9.171166] device: 'ttyq8': device_add
[    9.171294] PM: Adding info for No Bus:ttyq8
[    9.171501] device: 'ttyq9': device_add
[    9.171629] PM: Adding info for No Bus:ttyq9
[    9.172176] device: 'ttyqa': device_add
[    9.172304] PM: Adding info for No Bus:ttyqa
[    9.172511] device: 'ttyqb': device_add
[    9.172639] PM: Adding info for No Bus:ttyqb
[    9.172846] device: 'ttyqc': device_add
[    9.172974] PM: Adding info for No Bus:ttyqc
[    9.173180] device: 'ttyqd': device_add
[    9.173308] PM: Adding info for No Bus:ttyqd
[    9.173517] device: 'ttyqe': device_add
[    9.173645] PM: Adding info for No Bus:ttyqe
[    9.173858] device: 'ttyqf': device_add
[    9.173987] PM: Adding info for No Bus:ttyqf
[    9.174194] device: 'ttyr0': device_add
[    9.174323] PM: Adding info for No Bus:ttyr0
[    9.174535] device: 'ttyr1': device_add
[    9.174664] PM: Adding info for No Bus:ttyr1
[    9.174868] device: 'ttyr2': device_add
[    9.175011] PM: Adding info for No Bus:ttyr2
[    9.175217] device: 'ttyr3': device_add
[    9.175351] PM: Adding info for No Bus:ttyr3
[    9.175556] device: 'ttyr4': device_add
[    9.175685] PM: Adding info for No Bus:ttyr4
[    9.175893] device: 'ttyr5': device_add
[    9.176787] PM: Adding info for No Bus:ttyr5
[    9.176991] device: 'ttyr6': device_add
[    9.177120] PM: Adding info for No Bus:ttyr6
[    9.177328] device: 'ttyr7': device_add
[    9.177457] PM: Adding info for No Bus:ttyr7
[    9.177668] device: 'ttyr8': device_add
[    9.177797] PM: Adding info for No Bus:ttyr8
[    9.178002] device: 'ttyr9': device_add
[    9.178131] PM: Adding info for No Bus:ttyr9
[    9.178352] device: 'ttyra': device_add
[    9.178500] PM: Adding info for No Bus:ttyra
[    9.178808] device: 'ttyrb': device_add
[    9.178937] PM: Adding info for No Bus:ttyrb
[    9.179142] device: 'ttyrc': device_add
[    9.179271] PM: Adding info for No Bus:ttyrc
[    9.179479] device: 'ttyrd': device_add
[    9.179608] PM: Adding info for No Bus:ttyrd
[    9.179815] device: 'ttyre': device_add
[    9.179945] PM: Adding info for No Bus:ttyre
[    9.180151] device: 'ttyrf': device_add
[    9.180287] PM: Adding info for No Bus:ttyrf
[    9.180492] device: 'ttys0': device_add
[    9.180621] PM: Adding info for No Bus:ttys0
[    9.180829] device: 'ttys1': device_add
[    9.180958] PM: Adding info for No Bus:ttys1
[    9.181162] device: 'ttys2': device_add
[    9.181292] PM: Adding info for No Bus:ttys2
[    9.181496] device: 'ttys3': device_add
[    9.181626] PM: Adding info for No Bus:ttys3
[    9.181852] device: 'ttys4': device_add
[    9.181983] PM: Adding info for No Bus:ttys4
[    9.182190] device: 'ttys5': device_add
[    9.182320] PM: Adding info for No Bus:ttys5
[    9.182529] device: 'ttys6': device_add
[    9.182659] PM: Adding info for No Bus:ttys6
[    9.182866] device: 'ttys7': device_add
[    9.182997] PM: Adding info for No Bus:ttys7
[    9.183204] device: 'ttys8': device_add
[    9.183335] PM: Adding info for No Bus:ttys8
[    9.183547] device: 'ttys9': device_add
[    9.183678] PM: Adding info for No Bus:ttys9
[    9.183885] device: 'ttysa': device_add
[    9.184015] PM: Adding info for No Bus:ttysa
[    9.184225] device: 'ttysb': device_add
[    9.184356] PM: Adding info for No Bus:ttysb
[    9.184561] device: 'ttysc': device_add
[    9.184697] PM: Adding info for No Bus:ttysc
[    9.184906] device: 'ttysd': device_add
[    9.185060] PM: Adding info for No Bus:ttysd
[    9.185463] device: 'ttyse': device_add
[    9.185594] PM: Adding info for No Bus:ttyse
[    9.185800] device: 'ttysf': device_add
[    9.185931] PM: Adding info for No Bus:ttysf
[    9.186135] device: 'ttyt0': device_add
[    9.186266] PM: Adding info for No Bus:ttyt0
[    9.186472] device: 'ttyt1': device_add
[    9.186603] PM: Adding info for No Bus:ttyt1
[    9.186810] device: 'ttyt2': device_add
[    9.186941] PM: Adding info for No Bus:ttyt2
[    9.187150] device: 'ttyt3': device_add
[    9.187282] PM: Adding info for No Bus:ttyt3
[    9.187486] device: 'ttyt4': device_add
[    9.187617] PM: Adding info for No Bus:ttyt4
[    9.187823] device: 'ttyt5': device_add
[    9.187955] PM: Adding info for No Bus:ttyt5
[    9.188159] device: 'ttyt6': device_add
[    9.188290] PM: Adding info for No Bus:ttyt6
[    9.188509] device: 'ttyt7': device_add
[    9.188641] PM: Adding info for No Bus:ttyt7
[    9.188849] device: 'ttyt8': device_add
[    9.188986] PM: Adding info for No Bus:ttyt8
[    9.189196] device: 'ttyt9': device_add
[    9.189328] PM: Adding info for No Bus:ttyt9
[    9.189534] device: 'ttyta': device_add
[    9.189666] PM: Adding info for No Bus:ttyta
[    9.189873] device: 'ttytb': device_add
[    9.190005] PM: Adding info for No Bus:ttytb
[    9.190214] device: 'ttytc': device_add
[    9.190346] PM: Adding info for No Bus:ttytc
[    9.190555] device: 'ttytd': device_add
[    9.190687] PM: Adding info for No Bus:ttytd
[    9.190900] device: 'ttyte': device_add
[    9.191047] PM: Adding info for No Bus:ttyte
[    9.191256] device: 'ttytf': device_add
[    9.191389] PM: Adding info for No Bus:ttytf
[    9.191596] device: 'ttyu0': device_add
[    9.191753] PM: Adding info for No Bus:ttyu0
[    9.192140] device: 'ttyu1': device_add
[    9.192273] PM: Adding info for No Bus:ttyu1
[    9.192478] device: 'ttyu2': device_add
[    9.192611] PM: Adding info for No Bus:ttyu2
[    9.192816] device: 'ttyu3': device_add
[    9.192948] PM: Adding info for No Bus:ttyu3
[    9.193153] device: 'ttyu4': device_add
[    9.193291] PM: Adding info for No Bus:ttyu4
[    9.193499] device: 'ttyu5': device_add
[    9.193632] PM: Adding info for No Bus:ttyu5
[    9.193840] device: 'ttyu6': device_add
[    9.193972] PM: Adding info for No Bus:ttyu6
[    9.194177] device: 'ttyu7': device_add
[    9.194310] PM: Adding info for No Bus:ttyu7
[    9.194520] device: 'ttyu8': device_add
[    9.194653] PM: Adding info for No Bus:ttyu8
[    9.194860] device: 'ttyu9': device_add
[    9.195009] PM: Adding info for No Bus:ttyu9
[    9.195215] device: 'ttyua': device_add
[    9.195348] PM: Adding info for No Bus:ttyua
[    9.195558] device: 'ttyub': device_add
[    9.195691] PM: Adding info for No Bus:ttyub
[    9.195898] device: 'ttyuc': device_add
[    9.196031] PM: Adding info for No Bus:ttyuc
[    9.196236] device: 'ttyud': device_add
[    9.196369] PM: Adding info for No Bus:ttyud
[    9.196581] device: 'ttyue': device_add
[    9.196714] PM: Adding info for No Bus:ttyue
[    9.196926] device: 'ttyuf': device_add
[    9.197059] PM: Adding info for No Bus:ttyuf
[    9.197268] device: 'ttyv0': device_add
[    9.197407] PM: Adding info for No Bus:ttyv0
[    9.197616] device: 'ttyv1': device_add
[    9.197750] PM: Adding info for No Bus:ttyv1
[    9.197959] device: 'ttyv2': device_add
[    9.198093] PM: Adding info for No Bus:ttyv2
[    9.198300] device: 'ttyv3': device_add
[    9.198463] PM: Adding info for No Bus:ttyv3
[    9.198866] device: 'ttyv4': device_add
[    9.199001] PM: Adding info for No Bus:ttyv4
[    9.199207] device: 'ttyv5': device_add
[    9.199341] PM: Adding info for No Bus:ttyv5
[    9.199547] device: 'ttyv6': device_add
[    9.199681] PM: Adding info for No Bus:ttyv6
[    9.199886] device: 'ttyv7': device_add
[    9.200020] PM: Adding info for No Bus:ttyv7
[    9.200226] device: 'ttyv8': device_add
[    9.200360] PM: Adding info for No Bus:ttyv8
[    9.200567] device: 'ttyv9': device_add
[    9.200701] PM: Adding info for No Bus:ttyv9
[    9.200908] device: 'ttyva': device_add
[    9.201043] PM: Adding info for No Bus:ttyva
[    9.201252] device: 'ttyvb': device_add
[    9.201387] PM: Adding info for No Bus:ttyvb
[    9.201592] device: 'ttyvc': device_add
[    9.201746] PM: Adding info for No Bus:ttyvc
[    9.201952] device: 'ttyvd': device_add
[    9.202086] PM: Adding info for No Bus:ttyvd
[    9.202291] device: 'ttyve': device_add
[    9.202425] PM: Adding info for No Bus:ttyve
[    9.202630] device: 'ttyvf': device_add
[    9.202764] PM: Adding info for No Bus:ttyvf
[    9.202969] device: 'ttyw0': device_add
[    9.203104] PM: Adding info for No Bus:ttyw0
[    9.203313] device: 'ttyw1': device_add
[    9.203448] PM: Adding info for No Bus:ttyw1
[    9.203660] device: 'ttyw2': device_add
[    9.203795] PM: Adding info for No Bus:ttyw2
[    9.204001] device: 'ttyw3': device_add
[    9.204136] PM: Adding info for No Bus:ttyw3
[    9.204343] device: 'ttyw4': device_add
[    9.204478] PM: Adding info for No Bus:ttyw4
[    9.204687] device: 'ttyw5': device_add
[    9.204823] PM: Adding info for No Bus:ttyw5
[    9.205378] device: 'ttyw6': device_add
[    9.205514] PM: Adding info for No Bus:ttyw6
[    9.205725] device: 'ttyw7': device_add
[    9.205861] PM: Adding info for No Bus:ttyw7
[    9.206069] device: 'ttyw8': device_add
[    9.206210] PM: Adding info for No Bus:ttyw8
[    9.206421] device: 'ttyw9': device_add
[    9.206557] PM: Adding info for No Bus:ttyw9
[    9.206765] device: 'ttywa': device_add
[    9.206901] PM: Adding info for No Bus:ttywa
[    9.207111] device: 'ttywb': device_add
[    9.207247] PM: Adding info for No Bus:ttywb
[    9.207455] device: 'ttywc': device_add
[    9.207592] PM: Adding info for No Bus:ttywc
[    9.207798] device: 'ttywd': device_add
[    9.207935] PM: Adding info for No Bus:ttywd
[    9.208148] device: 'ttywe': device_add
[    9.208285] PM: Adding info for No Bus:ttywe
[    9.208508] device: 'ttywf': device_add
[    9.209409] PM: Adding info for No Bus:ttywf
[    9.209614] device: 'ttyx0': device_add
[    9.209750] PM: Adding info for No Bus:ttyx0
[    9.209957] device: 'ttyx1': device_add
[    9.210093] PM: Adding info for No Bus:ttyx1
[    9.210298] device: 'ttyx2': device_add
[    9.210434] PM: Adding info for No Bus:ttyx2
[    9.210641] device: 'ttyx3': device_add
[    9.210777] PM: Adding info for No Bus:ttyx3
[    9.210990] device: 'ttyx4': device_add
[    9.211151] PM: Adding info for No Bus:ttyx4
[    9.211366] device: 'ttyx5': device_add
[    9.211514] PM: Adding info for No Bus:ttyx5
[    9.212070] device: 'ttyx6': device_add
[    9.212215] PM: Adding info for No Bus:ttyx6
[    9.212426] device: 'ttyx7': device_add
[    9.212563] PM: Adding info for No Bus:ttyx7
[    9.212776] device: 'ttyx8': device_add
[    9.212914] PM: Adding info for No Bus:ttyx8
[    9.213124] device: 'ttyx9': device_add
[    9.213261] PM: Adding info for No Bus:ttyx9
[    9.213470] device: 'ttyxa': device_add
[    9.213607] PM: Adding info for No Bus:ttyxa
[    9.213814] device: 'ttyxb': device_add
[    9.213951] PM: Adding info for No Bus:ttyxb
[    9.214160] device: 'ttyxc': device_add
[    9.214297] PM: Adding info for No Bus:ttyxc
[    9.214506] device: 'ttyxd': device_add
[    9.214644] PM: Adding info for No Bus:ttyxd
[    9.214853] device: 'ttyxe': device_add
[    9.215004] PM: Adding info for No Bus:ttyxe
[    9.215212] device: 'ttyxf': device_add
[    9.215349] PM: Adding info for No Bus:ttyxf
[    9.215554] device: 'ttyy0': device_add
[    9.215691] PM: Adding info for No Bus:ttyy0
[    9.215899] device: 'ttyy1': device_add
[    9.216041] PM: Adding info for No Bus:ttyy1
[    9.216248] device: 'ttyy2': device_add
[    9.216385] PM: Adding info for No Bus:ttyy2
[    9.216591] device: 'ttyy3': device_add
[    9.216728] PM: Adding info for No Bus:ttyy3
[    9.216934] device: 'ttyy4': device_add
[    9.217071] PM: Adding info for No Bus:ttyy4
[    9.217276] device: 'ttyy5': device_add
[    9.217413] PM: Adding info for No Bus:ttyy5
[    9.217619] device: 'ttyy6': device_add
[    9.217756] PM: Adding info for No Bus:ttyy6
[    9.217961] device: 'ttyy7': device_add
[    9.218098] PM: Adding info for No Bus:ttyy7
[    9.218310] device: 'ttyy8': device_add
[    9.218685] PM: Adding info for No Bus:ttyy8
[    9.218896] device: 'ttyy9': device_add
[    9.219034] PM: Adding info for No Bus:ttyy9
[    9.219239] device: 'ttyya': device_add
[    9.219377] PM: Adding info for No Bus:ttyya
[    9.219584] device: 'ttyyb': device_add
[    9.219722] PM: Adding info for No Bus:ttyyb
[    9.219928] device: 'ttyyc': device_add
[    9.220066] PM: Adding info for No Bus:ttyyc
[    9.220273] device: 'ttyyd': device_add
[    9.220416] PM: Adding info for No Bus:ttyyd
[    9.220621] device: 'ttyye': device_add
[    9.220759] PM: Adding info for No Bus:ttyye
[    9.220967] device: 'ttyyf': device_add
[    9.221106] PM: Adding info for No Bus:ttyyf
[    9.221311] device: 'ttyz0': device_add
[    9.221450] PM: Adding info for No Bus:ttyz0
[    9.221671] device: 'ttyz1': device_add
[    9.221809] PM: Adding info for No Bus:ttyz1
[    9.222015] device: 'ttyz2': device_add
[    9.222153] PM: Adding info for No Bus:ttyz2
[    9.222359] device: 'ttyz3': device_add
[    9.222497] PM: Adding info for No Bus:ttyz3
[    9.222703] device: 'ttyz4': device_add
[    9.222842] PM: Adding info for No Bus:ttyz4
[    9.223047] device: 'ttyz5': device_add
[    9.223186] PM: Adding info for No Bus:ttyz5
[    9.223391] device: 'ttyz6': device_add
[    9.223530] PM: Adding info for No Bus:ttyz6
[    9.223735] device: 'ttyz7': device_add
[    9.223874] PM: Adding info for No Bus:ttyz7
[    9.224080] device: 'ttyz8': device_add
[    9.224219] PM: Adding info for No Bus:ttyz8
[    9.224426] device: 'ttyz9': device_add
[    9.224570] PM: Adding info for No Bus:ttyz9
[    9.224790] device: 'ttyza': device_add
[    9.224930] PM: Adding info for No Bus:ttyza
[    9.225451] device: 'ttyzb': device_add
[    9.225591] PM: Adding info for No Bus:ttyzb
[    9.225800] device: 'ttyzc': device_add
[    9.225940] PM: Adding info for No Bus:ttyzc
[    9.226146] device: 'ttyzd': device_add
[    9.226285] PM: Adding info for No Bus:ttyzd
[    9.226489] device: 'ttyze': device_add
[    9.226629] PM: Adding info for No Bus:ttyze
[    9.226834] device: 'ttyzf': device_add
[    9.226973] PM: Adding info for No Bus:ttyzf
[    9.227179] device: 'ttya0': device_add
[    9.227318] PM: Adding info for No Bus:ttya0
[    9.227523] device: 'ttya1': device_add
[    9.227663] PM: Adding info for No Bus:ttya1
[    9.227871] device: 'ttya2': device_add
[    9.228011] PM: Adding info for No Bus:ttya2
[    9.228221] device: 'ttya3': device_add
[    9.228375] PM: Adding info for No Bus:ttya3
[    9.228582] device: 'ttya4': device_add
[    9.228721] PM: Adding info for No Bus:ttya4
[    9.228928] device: 'ttya5': device_add
[    9.229072] PM: Adding info for No Bus:ttya5
[    9.229279] device: 'ttya6': device_add
[    9.229419] PM: Adding info for No Bus:ttya6
[    9.229626] device: 'ttya7': device_add
[    9.229765] PM: Adding info for No Bus:ttya7
[    9.229971] device: 'ttya8': device_add
[    9.230111] PM: Adding info for No Bus:ttya8
[    9.230317] device: 'ttya9': device_add
[    9.230456] PM: Adding info for No Bus:ttya9
[    9.230669] device: 'ttyaa': device_add
[    9.230810] PM: Adding info for No Bus:ttyaa
[    9.231017] device: 'ttyab': device_add
[    9.231157] PM: Adding info for No Bus:ttyab
[    9.231366] device: 'ttyac': device_add
[    9.231506] PM: Adding info for No Bus:ttyac
[    9.232091] device: 'ttyad': device_add
[    9.232232] PM: Adding info for No Bus:ttyad
[    9.232443] device: 'ttyae': device_add
[    9.232584] PM: Adding info for No Bus:ttyae
[    9.232791] device: 'ttyaf': device_add
[    9.232932] PM: Adding info for No Bus:ttyaf
[    9.233140] device: 'ttyb0': device_add
[    9.233281] PM: Adding info for No Bus:ttyb0
[    9.233490] device: 'ttyb1': device_add
[    9.233636] PM: Adding info for No Bus:ttyb1
[    9.233846] device: 'ttyb2': device_add
[    9.233987] PM: Adding info for No Bus:ttyb2
[    9.234200] device: 'ttyb3': device_add
[    9.234341] PM: Adding info for No Bus:ttyb3
[    9.234548] device: 'ttyb4': device_add
[    9.234690] PM: Adding info for No Bus:ttyb4
[    9.234901] device: 'ttyb5': device_add
[    9.235057] PM: Adding info for No Bus:ttyb5
[    9.235263] device: 'ttyb6': device_add
[    9.235404] PM: Adding info for No Bus:ttyb6
[    9.235610] device: 'ttyb7': device_add
[    9.235751] PM: Adding info for No Bus:ttyb7
[    9.235958] device: 'ttyb8': device_add
[    9.236098] PM: Adding info for No Bus:ttyb8
[    9.236304] device: 'ttyb9': device_add
[    9.236445] PM: Adding info for No Bus:ttyb9
[    9.236655] device: 'ttyba': device_add
[    9.236796] PM: Adding info for No Bus:ttyba
[    9.237003] device: 'ttybb': device_add
[    9.237144] PM: Adding info for No Bus:ttybb
[    9.237353] device: 'ttybc': device_add
[    9.237494] PM: Adding info for No Bus:ttybc
[    9.237705] device: 'ttybd': device_add
[    9.237851] PM: Adding info for No Bus:ttybd
[    9.238061] device: 'ttybe': device_add
[    9.238217] PM: Adding info for No Bus:ttybe
[    9.238752] device: 'ttybf': device_add
[    9.238893] PM: Adding info for No Bus:ttybf
[    9.239099] device: 'ttyc0': device_add
[    9.239240] PM: Adding info for No Bus:ttyc0
[    9.239445] device: 'ttyc1': device_add
[    9.239587] PM: Adding info for No Bus:ttyc1
[    9.239793] device: 'ttyc2': device_add
[    9.239934] PM: Adding info for No Bus:ttyc2
[    9.240140] device: 'ttyc3': device_add
[    9.240282] PM: Adding info for No Bus:ttyc3
[    9.240490] device: 'ttyc4': device_add
[    9.240631] PM: Adding info for No Bus:ttyc4
[    9.240837] device: 'ttyc5': device_add
[    9.240979] PM: Adding info for No Bus:ttyc5
[    9.241184] device: 'ttyc6': device_add
[    9.241326] PM: Adding info for No Bus:ttyc6
[    9.241533] device: 'ttyc7': device_add
[    9.241688] PM: Adding info for No Bus:ttyc7
[    9.241898] device: 'ttyc8': device_add
[    9.242040] PM: Adding info for No Bus:ttyc8
[    9.242247] device: 'ttyc9': device_add
[    9.243150] PM: Adding info for No Bus:ttyc9
[    9.243361] device: 'ttyca': device_add
[    9.243504] PM: Adding info for No Bus:ttyca
[    9.243712] device: 'ttycb': device_add
[    9.243855] PM: Adding info for No Bus:ttycb
[    9.244066] device: 'ttycc': device_add
[    9.244209] PM: Adding info for No Bus:ttycc
[    9.244418] device: 'ttycd': device_add
[    9.244560] PM: Adding info for No Bus:ttycd
[    9.244770] device: 'ttyce': device_add
[    9.244912] PM: Adding info for No Bus:ttyce
[    9.245462] device: 'ttycf': device_add
[    9.245605] PM: Adding info for No Bus:ttycf
[    9.245812] device: 'ttyd0': device_add
[    9.245955] PM: Adding info for No Bus:ttyd0
[    9.246161] device: 'ttyd1': device_add
[    9.246303] PM: Adding info for No Bus:ttyd1
[    9.246509] device: 'ttyd2': device_add
[    9.246652] PM: Adding info for No Bus:ttyd2
[    9.246858] device: 'ttyd3': device_add
[    9.247001] PM: Adding info for No Bus:ttyd3
[    9.247208] device: 'ttyd4': device_add
[    9.247351] PM: Adding info for No Bus:ttyd4
[    9.247560] device: 'ttyd5': device_add
[    9.247712] PM: Adding info for No Bus:ttyd5
[    9.247919] device: 'ttyd6': device_add
[    9.248067] PM: Adding info for No Bus:ttyd6
[    9.248275] device: 'ttyd7': device_add
[    9.248433] PM: Adding info for No Bus:ttyd7
[    9.248643] device: 'ttyd8': device_add
[    9.248786] PM: Adding info for No Bus:ttyd8
[    9.248995] device: 'ttyd9': device_add
[    9.249138] PM: Adding info for No Bus:ttyd9
[    9.249355] device: 'ttyda': device_add
[    9.249499] PM: Adding info for No Bus:ttyda
[    9.249705] device: 'ttydb': device_add
[    9.249848] PM: Adding info for No Bus:ttydb
[    9.250058] device: 'ttydc': device_add
[    9.250201] PM: Adding info for No Bus:ttydc
[    9.250408] device: 'ttydd': device_add
[    9.250551] PM: Adding info for No Bus:ttydd
[    9.250757] device: 'ttyde': device_add
[    9.250901] PM: Adding info for No Bus:ttyde
[    9.251107] device: 'ttydf': device_add
[    9.251251] PM: Adding info for No Bus:ttydf
[    9.251460] device: 'ttye0': device_add
[    9.251603] PM: Adding info for No Bus:ttye0
[    9.252136] device: 'ttye1': device_add
[    9.252280] PM: Adding info for No Bus:ttye1
[    9.252485] device: 'ttye2': device_add
[    9.252634] PM: Adding info for No Bus:ttye2
[    9.252842] device: 'ttye3': device_add
[    9.252986] PM: Adding info for No Bus:ttye3
[    9.253192] device: 'ttye4': device_add
[    9.253336] PM: Adding info for No Bus:ttye4
[    9.253546] device: 'ttye5': device_add
[    9.253690] PM: Adding info for No Bus:ttye5
[    9.253894] device: 'ttye6': device_add
[    9.254038] PM: Adding info for No Bus:ttye6
[    9.254249] device: 'ttye7': device_add
[    9.254393] PM: Adding info for No Bus:ttye7
[    9.254599] device: 'ttye8': device_add
[    9.254743] PM: Adding info for No Bus:ttye8
[    9.254948] device: 'ttye9': device_add
[    9.255107] PM: Adding info for No Bus:ttye9
[    9.255314] device: 'ttyea': device_add
[    9.255458] PM: Adding info for No Bus:ttyea
[    9.255665] device: 'ttyeb': device_add
[    9.255809] PM: Adding info for No Bus:ttyeb
[    9.256019] device: 'ttyec': device_add
[    9.256163] PM: Adding info for No Bus:ttyec
[    9.256371] device: 'ttyed': device_add
[    9.256516] PM: Adding info for No Bus:ttyed
[    9.256723] device: 'ttyee': device_add
[    9.256873] PM: Adding info for No Bus:ttyee
[    9.257080] device: 'ttyef': device_add
[    9.257225] PM: Adding info for No Bus:ttyef
[    9.257453] device: 'ptmx': device_add
[    9.257594] PM: Adding info for No Bus:ptmx
[    9.257804] initcall pty_init+0x0/0x397 returned 0 after 181474 usecs
[    9.257897] calling  sysrq_init+0x0/0x1f @ 1
[    9.258002] initcall sysrq_init+0x0/0x1f returned 0 after 13 usecs
[    9.258095] calling  stallion_module_init+0x0/0x3db @ 1
[    9.258186] Stallion Multiport Serial Driver: version 5.6.0
[    9.258290] bus: 'pci': add driver stallion
[    9.258829] device class 'staliomem': registering
[    9.259048] device: 'staliomem0': device_add
[    9.259177] PM: Adding info for No Bus:staliomem0
[    9.259458] device: 'staliomem1': device_add
[    9.259586] PM: Adding info for No Bus:staliomem1
[    9.259794] device: 'staliomem2': device_add
[    9.259921] PM: Adding info for No Bus:staliomem2
[    9.260128] device: 'staliomem3': device_add
[    9.260255] PM: Adding info for No Bus:staliomem3
[    9.260463] initcall stallion_module_init+0x0/0x3db returned 0 after 2221 usecs
[    9.260594] calling  specialix_init_module+0x0/0x35d @ 1
[    9.260684] sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
[    9.260775] sx: derived from work (c) D.Gorodchanin 1994-1996.
[    9.260865] sx: DTR/RTS pin is always RTS.
[    9.260963] device: 'ttyW0': device_add
[    9.261106] PM: Adding info for No Bus:ttyW0
[    9.261312] device: 'ttyW1': device_add
[    9.261455] PM: Adding info for No Bus:ttyW1
[    9.261675] device: 'ttyW2': device_add
[    9.261818] PM: Adding info for No Bus:ttyW2
[    9.262024] device: 'ttyW3': device_add
[    9.262167] PM: Adding info for No Bus:ttyW3
[    9.262373] device: 'ttyW4': device_add
[    9.262522] PM: Adding info for No Bus:ttyW4
[    9.262735] device: 'ttyW5': device_add
[    9.262879] PM: Adding info for No Bus:ttyW5
[    9.263086] device: 'ttyW6': device_add
[    9.263229] PM: Adding info for No Bus:ttyW6
[    9.263435] device: 'ttyW7': device_add
[    9.263579] PM: Adding info for No Bus:ttyW7
[    9.263786] device: 'ttyW8': device_add
[    9.263929] PM: Adding info for No Bus:ttyW8
[    9.264137] device: 'ttyW9': device_add
[    9.264281] PM: Adding info for No Bus:ttyW9
[    9.264492] device: 'ttyW10': device_add
[    9.264637] PM: Adding info for No Bus:ttyW10
[    9.264850] device: 'ttyW11': device_add
[    9.265010] PM: Adding info for No Bus:ttyW11
[    9.265436] device: 'ttyW12': device_add
[    9.265602] PM: Adding info for No Bus:ttyW12
[    9.265809] device: 'ttyW13': device_add
[    9.265964] PM: Adding info for No Bus:ttyW13
[    9.266170] device: 'ttyW14': device_add
[    9.266319] PM: Adding info for No Bus:ttyW14
[    9.266525] device: 'ttyW15': device_add
[    9.266668] PM: Adding info for No Bus:ttyW15
[    9.266877] device: 'ttyW16': device_add
[    9.267025] PM: Adding info for No Bus:ttyW16
[    9.267232] device: 'ttyW17': device_add
[    9.267376] PM: Adding info for No Bus:ttyW17
[    9.267581] device: 'ttyW18': device_add
[    9.267725] PM: Adding info for No Bus:ttyW18
[    9.267931] device: 'ttyW19': device_add
[    9.268075] PM: Adding info for No Bus:ttyW19
[    9.268279] device: 'ttyW20': device_add
[    9.268438] PM: Adding info for No Bus:ttyW20
[    9.268645] device: 'ttyW21': device_add
[    9.268789] PM: Adding info for No Bus:ttyW21
[    9.268994] device: 'ttyW22': device_add
[    9.269138] PM: Adding info for No Bus:ttyW22
[    9.269347] device: 'ttyW23': device_add
[    9.269491] PM: Adding info for No Bus:ttyW23
[    9.269699] device: 'ttyW24': device_add
[    9.269843] PM: Adding info for No Bus:ttyW24
[    9.270049] device: 'ttyW25': device_add
[    9.270194] PM: Adding info for No Bus:ttyW25
[    9.270400] device: 'ttyW26': device_add
[    9.270544] PM: Adding info for No Bus:ttyW26
[    9.270751] device: 'ttyW27': device_add
[    9.270895] PM: Adding info for No Bus:ttyW27
[    9.271102] device: 'ttyW28': device_add
[    9.271252] PM: Adding info for No Bus:ttyW28
[    9.271461] device: 'ttyW29': device_add
[    9.271606] PM: Adding info for No Bus:ttyW29
[    9.272104] device: 'ttyW30': device_add
[    9.272249] PM: Adding info for No Bus:ttyW30
[    9.272455] device: 'ttyW31': device_add
[    9.272600] PM: Adding info for No Bus:ttyW31
[    9.272809] device: 'ttyW32': device_add
[    9.272954] PM: Adding info for No Bus:ttyW32
[    9.273162] device: 'ttyW33': device_add
[    9.273307] PM: Adding info for No Bus:ttyW33
[    9.273513] device: 'ttyW34': device_add
[    9.273658] PM: Adding info for No Bus:ttyW34
[    9.273862] device: 'ttyW35': device_add
[    9.274008] PM: Adding info for No Bus:ttyW35
[    9.274215] device: 'ttyW36': device_add
[    9.274360] PM: Adding info for No Bus:ttyW36
[    9.274571] device: 'ttyW37': device_add
[    9.274717] PM: Adding info for No Bus:ttyW37
[    9.274925] device: 'ttyW38': device_add
[    9.275085] PM: Adding info for No Bus:ttyW38
[    9.275302] device: 'ttyW39': device_add
[    9.275447] PM: Adding info for No Bus:ttyW39
[    9.276418] device: 'ttyW40': device_add
[    9.276568] PM: Adding info for No Bus:ttyW40
[    9.276775] device: 'ttyW41': device_add
[    9.276920] PM: Adding info for No Bus:ttyW41
[    9.277129] device: 'ttyW42': device_add
[    9.277275] PM: Adding info for No Bus:ttyW42
[    9.277485] device: 'ttyW43': device_add
[    9.277631] PM: Adding info for No Bus:ttyW43
[    9.277840] device: 'ttyW44': device_add
[    9.277987] PM: Adding info for No Bus:ttyW44
[    9.278193] device: 'ttyW45': device_add
[    9.278359] PM: Adding info for No Bus:ttyW45
[    9.278765] device: 'ttyW46': device_add
[    9.278910] PM: Adding info for No Bus:ttyW46
[    9.279117] device: 'ttyW47': device_add
[    9.279263] PM: Adding info for No Bus:ttyW47
[    9.279469] device: 'ttyW48': device_add
[    9.279615] PM: Adding info for No Bus:ttyW48
[    9.279821] device: 'ttyW49': device_add
[    9.279967] PM: Adding info for No Bus:ttyW49
[    9.280175] device: 'ttyW50': device_add
[    9.280321] PM: Adding info for No Bus:ttyW50
[    9.280529] device: 'ttyW51': device_add
[    9.280675] PM: Adding info for No Bus:ttyW51
[    9.280882] device: 'ttyW52': device_add
[    9.281028] PM: Adding info for No Bus:ttyW52
[    9.281234] device: 'ttyW53': device_add
[    9.281386] PM: Adding info for No Bus:ttyW53
[    9.281592] device: 'ttyW54': device_add
[    9.281754] PM: Adding info for No Bus:ttyW54
[    9.281960] device: 'ttyW55': device_add
[    9.282107] PM: Adding info for No Bus:ttyW55
[    9.282314] device: 'ttyW56': device_add
[    9.282460] PM: Adding info for No Bus:ttyW56
[    9.282671] device: 'ttyW57': device_add
[    9.282818] PM: Adding info for No Bus:ttyW57
[    9.283023] device: 'ttyW58': device_add
[    9.283170] PM: Adding info for No Bus:ttyW58
[    9.283376] device: 'ttyW59': device_add
[    9.283523] PM: Adding info for No Bus:ttyW59
[    9.283730] device: 'ttyW60': device_add
[    9.283877] PM: Adding info for No Bus:ttyW60
[    9.284083] device: 'ttyW61': device_add
[    9.284230] PM: Adding info for No Bus:ttyW61
[    9.284437] device: 'ttyW62': device_add
[    9.284584] PM: Adding info for No Bus:ttyW62
[    9.284789] device: 'ttyW63': device_add
[    9.284936] PM: Adding info for No Bus:ttyW63
[    9.285541] sx0: specialix IO8+ Board at 0x100 not found.
[    9.285649] sx1: specialix IO8+ Board at 0x180 not found.
[    9.285756] sx2: specialix IO8+ Board at 0x250 not found.
[    9.285863] sx3: specialix IO8+ Board at 0x260 not found.
[    9.286348] device: 'ttyW0': device_unregister
[    9.286437] PM: Removing info for No Bus:ttyW0
[    9.286775] device: 'ttyW0': device_create_release
[    9.287210] device: 'ttyW1': device_unregister
[    9.287298] PM: Removing info for No Bus:ttyW1
[    9.287559] device: 'ttyW1': device_create_release
[    9.287993] device: 'ttyW2': device_unregister
[    9.288081] PM: Removing info for No Bus:ttyW2
[    9.288356] device: 'ttyW2': device_create_release
[    9.288790] device: 'ttyW3': device_unregister
[    9.288878] PM: Removing info for No Bus:ttyW3
[    9.289141] device: 'ttyW3': device_create_release
[    9.289575] device: 'ttyW4': device_unregister
[    9.289663] PM: Removing info for No Bus:ttyW4
[    9.289925] device: 'ttyW4': device_create_release
[    9.290359] device: 'ttyW5': device_unregister
[    9.290447] PM: Removing info for No Bus:ttyW5
[    9.290707] device: 'ttyW5': device_create_release
[    9.291141] device: 'ttyW6': device_unregister
[    9.291229] PM: Removing info for No Bus:ttyW6
[    9.291489] device: 'ttyW6': device_create_release
[    9.292080] device: 'ttyW7': device_unregister
[    9.292169] PM: Removing info for No Bus:ttyW7
[    9.292432] device: 'ttyW7': device_create_release
[    9.292866] device: 'ttyW8': device_unregister
[    9.292954] PM: Removing info for No Bus:ttyW8
[    9.293214] device: 'ttyW8': device_create_release
[    9.293649] device: 'ttyW9': device_unregister
[    9.293737] PM: Removing info for No Bus:ttyW9
[    9.293996] device: 'ttyW9': device_create_release
[    9.294430] device: 'ttyW10': device_unregister
[    9.294518] PM: Removing info for No Bus:ttyW10
[    9.294781] device: 'ttyW10': device_create_release
[    9.295230] device: 'ttyW11': device_unregister
[    9.295318] PM: Removing info for No Bus:ttyW11
[    9.295579] device: 'ttyW11': device_create_release
[    9.296012] device: 'ttyW12': device_unregister
[    9.296101] PM: Removing info for No Bus:ttyW12
[    9.296360] device: 'ttyW12': device_create_release
[    9.296794] device: 'ttyW13': device_unregister
[    9.296882] PM: Removing info for No Bus:ttyW13
[    9.297141] device: 'ttyW13': device_create_release
[    9.297575] device: 'ttyW14': device_unregister
[    9.297663] PM: Removing info for No Bus:ttyW14
[    9.297924] device: 'ttyW14': device_create_release
[    9.298389] device: 'ttyW15': device_unregister
[    9.298479] PM: Removing info for No Bus:ttyW15
[    9.298770] device: 'ttyW15': device_create_release
[    9.299204] device: 'ttyW16': device_unregister
[    9.299292] PM: Removing info for No Bus:ttyW16
[    9.299556] device: 'ttyW16': device_create_release
[    9.299991] device: 'ttyW17': device_unregister
[    9.300079] PM: Removing info for No Bus:ttyW17
[    9.300339] device: 'ttyW17': device_create_release
[    9.300774] device: 'ttyW18': device_unregister
[    9.300862] PM: Removing info for No Bus:ttyW18
[    9.301128] device: 'ttyW18': device_create_release
[    9.301562] device: 'ttyW19': device_unregister
[    9.301650] PM: Removing info for No Bus:ttyW19
[    9.301928] device: 'ttyW19': device_create_release
[    9.302362] device: 'ttyW20': device_unregister
[    9.302450] PM: Removing info for No Bus:ttyW20
[    9.302709] device: 'ttyW20': device_create_release
[    9.303143] device: 'ttyW21': device_unregister
[    9.303231] PM: Removing info for No Bus:ttyW21
[    9.303493] device: 'ttyW21': device_create_release
[    9.303927] device: 'ttyW22': device_unregister
[    9.304015] PM: Removing info for No Bus:ttyW22
[    9.304275] device: 'ttyW22': device_create_release
[    9.304709] device: 'ttyW23': device_unregister
[    9.304797] PM: Removing info for No Bus:ttyW23
[    9.305272] device: 'ttyW23': device_create_release
[    9.305706] device: 'ttyW24': device_unregister
[    9.305794] PM: Removing info for No Bus:ttyW24
[    9.306062] device: 'ttyW24': device_create_release
[    9.306496] device: 'ttyW25': device_unregister
[    9.306584] PM: Removing info for No Bus:ttyW25
[    9.306846] device: 'ttyW25': device_create_release
[    9.307284] device: 'ttyW26': device_unregister
[    9.307372] PM: Removing info for No Bus:ttyW26
[    9.307639] device: 'ttyW26': device_create_release
[    9.308073] device: 'ttyW27': device_unregister
[    9.308161] PM: Removing info for No Bus:ttyW27
[    9.308436] device: 'ttyW27': device_create_release
[    9.308870] device: 'ttyW28': device_unregister
[    9.308958] PM: Removing info for No Bus:ttyW28
[    9.309225] device: 'ttyW28': device_create_release
[    9.309660] device: 'ttyW29': device_unregister
[    9.309748] PM: Removing info for No Bus:ttyW29
[    9.310013] device: 'ttyW29': device_create_release
[    9.310447] device: 'ttyW30': device_unregister
[    9.310535] PM: Removing info for No Bus:ttyW30
[    9.310802] device: 'ttyW30': device_create_release
[    9.311236] device: 'ttyW31': device_unregister
[    9.311324] PM: Removing info for No Bus:ttyW31
[    9.311585] device: 'ttyW31': device_create_release
[    9.312120] device: 'ttyW32': device_unregister
[    9.312208] PM: Removing info for No Bus:ttyW32
[    9.312470] device: 'ttyW32': device_create_release
[    9.312904] device: 'ttyW33': device_unregister
[    9.312992] PM: Removing info for No Bus:ttyW33
[    9.313254] device: 'ttyW33': device_create_release
[    9.313688] device: 'ttyW34': device_unregister
[    9.313776] PM: Removing info for No Bus:ttyW34
[    9.314035] device: 'ttyW34': device_create_release
[    9.314469] device: 'ttyW35': device_unregister
[    9.314557] PM: Removing info for No Bus:ttyW35
[    9.314818] device: 'ttyW35': device_create_release
[    9.315267] device: 'ttyW36': device_unregister
[    9.315355] PM: Removing info for No Bus:ttyW36
[    9.315616] device: 'ttyW36': device_create_release
[    9.316050] device: 'ttyW37': device_unregister
[    9.316138] PM: Removing info for No Bus:ttyW37
[    9.316398] device: 'ttyW37': device_create_release
[    9.316832] device: 'ttyW38': device_unregister
[    9.316920] PM: Removing info for No Bus:ttyW38
[    9.317182] device: 'ttyW38': device_create_release
[    9.317616] device: 'ttyW39': device_unregister
[    9.317704] PM: Removing info for No Bus:ttyW39
[    9.317964] device: 'ttyW39': device_create_release
[    9.318530] device: 'ttyW40': device_unregister
[    9.318618] PM: Removing info for No Bus:ttyW40
[    9.318886] device: 'ttyW40': device_create_release
[    9.319320] device: 'ttyW41': device_unregister
[    9.319408] PM: Removing info for No Bus:ttyW41
[    9.319669] device: 'ttyW41': device_create_release
[    9.320103] device: 'ttyW42': device_unregister
[    9.320191] PM: Removing info for No Bus:ttyW42
[    9.321218] device: 'ttyW42': device_create_release
[    9.321651] device: 'ttyW43': device_unregister
[    9.321753] PM: Removing info for No Bus:ttyW43
[    9.322016] device: 'ttyW43': device_create_release
[    9.322450] device: 'ttyW44': device_unregister
[    9.322538] PM: Removing info for No Bus:ttyW44
[    9.322798] device: 'ttyW44': device_create_release
[    9.323233] device: 'ttyW45': device_unregister
[    9.323321] PM: Removing info for No Bus:ttyW45
[    9.323581] device: 'ttyW45': device_create_release
[    9.324015] device: 'ttyW46': device_unregister
[    9.324102] PM: Removing info for No Bus:ttyW46
[    9.324362] device: 'ttyW46': device_create_release
[    9.324796] device: 'ttyW47': device_unregister
[    9.324884] PM: Removing info for No Bus:ttyW47
[    9.325302] device: 'ttyW47': device_create_release
[    9.325737] device: 'ttyW48': device_unregister
[    9.325825] PM: Removing info for No Bus:ttyW48
[    9.326085] device: 'ttyW48': device_create_release
[    9.326519] device: 'ttyW49': device_unregister
[    9.326607] PM: Removing info for No Bus:ttyW49
[    9.326867] device: 'ttyW49': device_create_release
[    9.327301] device: 'ttyW50': device_unregister
[    9.327389] PM: Removing info for No Bus:ttyW50
[    9.327648] device: 'ttyW50': device_create_release
[    9.328082] device: 'ttyW51': device_unregister
[    9.328171] PM: Removing info for No Bus:ttyW51
[    9.328445] device: 'ttyW51': device_create_release
[    9.328879] device: 'ttyW52': device_unregister
[    9.328967] PM: Removing info for No Bus:ttyW52
[    9.329234] device: 'ttyW52': device_create_release
[    9.329668] device: 'ttyW53': device_unregister
[    9.329757] PM: Removing info for No Bus:ttyW53
[    9.330019] device: 'ttyW53': device_create_release
[    9.330453] device: 'ttyW54': device_unregister
[    9.330541] PM: Removing info for No Bus:ttyW54
[    9.330804] device: 'ttyW54': device_create_release
[    9.331239] device: 'ttyW55': device_unregister
[    9.331327] PM: Removing info for No Bus:ttyW55
[    9.331588] device: 'ttyW55': device_create_release
[    9.332113] device: 'ttyW56': device_unregister
[    9.332201] PM: Removing info for No Bus:ttyW56
[    9.332464] device: 'ttyW56': device_create_release
[    9.332898] device: 'ttyW57': device_unregister
[    9.332986] PM: Removing info for No Bus:ttyW57
[    9.333244] device: 'ttyW57': device_create_release
[    9.333678] device: 'ttyW58': device_unregister
[    9.333767] PM: Removing info for No Bus:ttyW58
[    9.334026] device: 'ttyW58': device_create_release
[    9.334460] device: 'ttyW59': device_unregister
[    9.334548] PM: Removing info for No Bus:ttyW59
[    9.334806] device: 'ttyW59': device_create_release
[    9.335266] device: 'ttyW60': device_unregister
[    9.335355] PM: Removing info for No Bus:ttyW60
[    9.335615] device: 'ttyW60': device_create_release
[    9.336049] device: 'ttyW61': device_unregister
[    9.336137] PM: Removing info for No Bus:ttyW61
[    9.336399] device: 'ttyW61': device_create_release
[    9.336832] device: 'ttyW62': device_unregister
[    9.336920] PM: Removing info for No Bus:ttyW62
[    9.337179] device: 'ttyW62': device_create_release
[    9.337613] device: 'ttyW63': device_unregister
[    9.337701] PM: Removing info for No Bus:ttyW63
[    9.337964] device: 'ttyW63': device_create_release
[    9.338100] sx: No specialix IO8+ boards detected.
[    9.338195] initcall specialix_init_module+0x0/0x35d returned -5 after 75690 usecs
[    9.338372] initcall specialix_init_module+0x0/0x35d returned with error code -5 
[    9.338505] calling  synclink_init+0x0/0x213 @ 1
[    9.338595] SyncLink serial driver $Revision: 4.38 $
[    9.338686] bus: 'pci': add driver synclink
[    9.338953] device: 'ttySL0': device_add
[    9.339103] PM: Adding info for No Bus:ttySL0
[    9.339309] device: 'ttySL1': device_add
[    9.339457] PM: Adding info for No Bus:ttySL1
[    9.339667] device: 'ttySL2': device_add
[    9.339815] PM: Adding info for No Bus:ttySL2
[    9.340021] device: 'ttySL3': device_add
[    9.340169] PM: Adding info for No Bus:ttySL3
[    9.340374] device: 'ttySL4': device_add
[    9.340522] PM: Adding info for No Bus:ttySL4
[    9.340729] device: 'ttySL5': device_add
[    9.340878] PM: Adding info for No Bus:ttySL5
[    9.341085] device: 'ttySL6': device_add
[    9.341233] PM: Adding info for No Bus:ttySL6
[    9.341442] device: 'ttySL7': device_add
[    9.341591] PM: Adding info for No Bus:ttySL7
[    9.341810] device: 'ttySL8': device_add
[    9.341959] PM: Adding info for No Bus:ttySL8
[    9.342169] device: 'ttySL9': device_add
[    9.342318] PM: Adding info for No Bus:ttySL9
[    9.342527] device: 'ttySL10': device_add
[    9.342675] PM: Adding info for No Bus:ttySL10
[    9.342883] device: 'ttySL11': device_add
[    9.343032] PM: Adding info for No Bus:ttySL11
[    9.343240] device: 'ttySL12': device_add
[    9.343384] PM: Adding info for No Bus:ttySL12
[    9.343590] device: 'ttySL13': device_add
[    9.343735] PM: Adding info for No Bus:ttySL13
[    9.343942] device: 'ttySL14': device_add
[    9.344087] PM: Adding info for No Bus:ttySL14
[    9.344293] device: 'ttySL15': device_add
[    9.344443] PM: Adding info for No Bus:ttySL15
[    9.344663] device: 'ttySL16': device_add
[    9.344808] PM: Adding info for No Bus:ttySL16
[    9.345197] device: 'ttySL17': device_add
[    9.345342] PM: Adding info for No Bus:ttySL17
[    9.345553] device: 'ttySL18': device_add
[    9.345698] PM: Adding info for No Bus:ttySL18
[    9.345908] device: 'ttySL19': device_add
[    9.346054] PM: Adding info for No Bus:ttySL19
[    9.346263] device: 'ttySL20': device_add
[    9.346408] PM: Adding info for No Bus:ttySL20
[    9.346616] device: 'ttySL21': device_add
[    9.346762] PM: Adding info for No Bus:ttySL21
[    9.346970] device: 'ttySL22': device_add
[    9.347115] PM: Adding info for No Bus:ttySL22
[    9.347324] device: 'ttySL23': device_add
[    9.347470] PM: Adding info for No Bus:ttySL23
[    9.347679] device: 'ttySL24': device_add
[    9.347825] PM: Adding info for No Bus:ttySL24
[    9.348036] device: 'ttySL25': device_add
[    9.348181] PM: Adding info for No Bus:ttySL25
[    9.348403] device: 'ttySL26': device_add
[    9.348549] PM: Adding info for No Bus:ttySL26
[    9.348758] device: 'ttySL27': device_add
[    9.348908] PM: Adding info for No Bus:ttySL27
[    9.349115] device: 'ttySL28': device_add
[    9.349260] PM: Adding info for No Bus:ttySL28
[    9.349471] device: 'ttySL29': device_add
[    9.349617] PM: Adding info for No Bus:ttySL29
[    9.349823] device: 'ttySL30': device_add
[    9.349969] PM: Adding info for No Bus:ttySL30
[    9.350174] device: 'ttySL31': device_add
[    9.350320] PM: Adding info for No Bus:ttySL31
[    9.350538] device: 'ttySL32': device_add
[    9.350685] PM: Adding info for No Bus:ttySL32
[    9.350895] device: 'ttySL33': device_add
[    9.351041] PM: Adding info for No Bus:ttySL33
[    9.351248] device: 'ttySL34': device_add
[    9.351394] PM: Adding info for No Bus:ttySL34
[    9.351600] device: 'ttySL35': device_add
[    9.351783] PM: Adding info for No Bus:ttySL35
[    9.352015] device: 'ttySL36': device_add
[    9.352161] PM: Adding info for No Bus:ttySL36
[    9.352367] device: 'ttySL37': device_add
[    9.352514] PM: Adding info for No Bus:ttySL37
[    9.352719] device: 'ttySL38': device_add
[    9.352865] PM: Adding info for No Bus:ttySL38
[    9.353072] device: 'ttySL39': device_add
[    9.353219] PM: Adding info for No Bus:ttySL39
[    9.353424] device: 'ttySL40': device_add
[    9.353576] PM: Adding info for No Bus:ttySL40
[    9.353782] device: 'ttySL41': device_add
[    9.353929] PM: Adding info for No Bus:ttySL41
[    9.354136] device: 'ttySL42': device_add
[    9.354283] PM: Adding info for No Bus:ttySL42
[    9.354489] device: 'ttySL43': device_add
[    9.354636] PM: Adding info for No Bus:ttySL43
[    9.354841] device: 'ttySL44': device_add
[    9.355002] PM: Adding info for No Bus:ttySL44
[    9.355210] device: 'ttySL45': device_add
[    9.355357] PM: Adding info for No Bus:ttySL45
[    9.355564] device: 'ttySL46': device_add
[    9.355712] PM: Adding info for No Bus:ttySL46
[    9.355918] device: 'ttySL47': device_add
[    9.356065] PM: Adding info for No Bus:ttySL47
[    9.356280] device: 'ttySL48': device_add
[    9.356427] PM: Adding info for No Bus:ttySL48
[    9.356632] device: 'ttySL49': device_add
[    9.356780] PM: Adding info for No Bus:ttySL49
[    9.356987] device: 'ttySL50': device_add
[    9.357134] PM: Adding info for No Bus:ttySL50
[    9.357345] device: 'ttySL51': device_add
[    9.357493] PM: Adding info for No Bus:ttySL51
[    9.357699] device: 'ttySL52': device_add
[    9.357852] PM: Adding info for No Bus:ttySL52
[    9.358071] device: 'ttySL53': device_add
[    9.358219] PM: Adding info for No Bus:ttySL53
[    9.359498] device: 'ttySL54': device_add
[    9.359646] PM: Adding info for No Bus:ttySL54
[    9.359852] device: 'ttySL55': device_add
[    9.359999] PM: Adding info for No Bus:ttySL55
[    9.360205] device: 'ttySL56': device_add
[    9.360353] PM: Adding info for No Bus:ttySL56
[    9.360563] device: 'ttySL57': device_add
[    9.360712] PM: Adding info for No Bus:ttySL57
[    9.360917] device: 'ttySL58': device_add
[    9.361065] PM: Adding info for No Bus:ttySL58
[    9.361271] device: 'ttySL59': device_add
[    9.361419] PM: Adding info for No Bus:ttySL59
[    9.361624] device: 'ttySL60': device_add
[    9.361787] PM: Adding info for No Bus:ttySL60
[    9.361995] device: 'ttySL61': device_add
[    9.362143] PM: Adding info for No Bus:ttySL61
[    9.362352] device: 'ttySL62': device_add
[    9.362501] PM: Adding info for No Bus:ttySL62
[    9.362706] device: 'ttySL63': device_add
[    9.362855] PM: Adding info for No Bus:ttySL63
[    9.363061] device: 'ttySL64': device_add
[    9.363215] PM: Adding info for No Bus:ttySL64
[    9.363428] device: 'ttySL65': device_add
[    9.363577] PM: Adding info for No Bus:ttySL65
[    9.363783] device: 'ttySL66': device_add
[    9.363932] PM: Adding info for No Bus:ttySL66
[    9.364139] device: 'ttySL67': device_add
[    9.364288] PM: Adding info for No Bus:ttySL67
[    9.364495] device: 'ttySL68': device_add
[    9.364645] PM: Adding info for No Bus:ttySL68
[    9.364863] device: 'ttySL69': device_add
[    9.365057] PM: Adding info for No Bus:ttySL69
[    9.365421] device: 'ttySL70': device_add
[    9.365570] PM: Adding info for No Bus:ttySL70
[    9.365776] device: 'ttySL71': device_add
[    9.365925] PM: Adding info for No Bus:ttySL71
[    9.366130] device: 'ttySL72': device_add
[    9.366280] PM: Adding info for No Bus:ttySL72
[    9.366489] device: 'ttySL73': device_add
[    9.366638] PM: Adding info for No Bus:ttySL73
[    9.366847] device: 'ttySL74': device_add
[    9.366997] PM: Adding info for No Bus:ttySL74
[    9.367203] device: 'ttySL75': device_add
[    9.367368] PM: Adding info for No Bus:ttySL75
[    9.367577] device: 'ttySL76': device_add
[    9.367732] PM: Adding info for No Bus:ttySL76
[    9.367941] device: 'ttySL77': device_add
[    9.368091] PM: Adding info for No Bus:ttySL77
[    9.368299] device: 'ttySL78': device_add
[    9.368464] PM: Adding info for No Bus:ttySL78
[    9.368674] device: 'ttySL79': device_add
[    9.368825] PM: Adding info for No Bus:ttySL79
[    9.369036] device: 'ttySL80': device_add
[    9.369186] PM: Adding info for No Bus:ttySL80
[    9.369398] device: 'ttySL81': device_add
[    9.369548] PM: Adding info for No Bus:ttySL81
[    9.369753] device: 'ttySL82': device_add
[    9.369904] PM: Adding info for No Bus:ttySL82
[    9.370110] device: 'ttySL83': device_add
[    9.370260] PM: Adding info for No Bus:ttySL83
[    9.370467] device: 'ttySL84': device_add
[    9.370617] PM: Adding info for No Bus:ttySL84
[    9.370827] device: 'ttySL85': device_add
[    9.370978] PM: Adding info for No Bus:ttySL85
[    9.371184] device: 'ttySL86': device_add
[    9.371335] PM: Adding info for No Bus:ttySL86
[    9.371539] device: 'ttySL87': device_add
[    9.371785] PM: Adding info for No Bus:ttySL87
[    9.372090] device: 'ttySL88': device_add
[    9.372247] PM: Adding info for No Bus:ttySL88
[    9.372452] device: 'ttySL89': device_add
[    9.372603] PM: Adding info for No Bus:ttySL89
[    9.372812] device: 'ttySL90': device_add
[    9.372964] PM: Adding info for No Bus:ttySL90
[    9.373169] device: 'ttySL91': device_add
[    9.373320] PM: Adding info for No Bus:ttySL91
[    9.373525] device: 'ttySL92': device_add
[    9.373676] PM: Adding info for No Bus:ttySL92
[    9.373883] device: 'ttySL93': device_add
[    9.374035] PM: Adding info for No Bus:ttySL93
[    9.374242] device: 'ttySL94': device_add
[    9.374394] PM: Adding info for No Bus:ttySL94
[    9.374598] device: 'ttySL95': device_add
[    9.374750] PM: Adding info for No Bus:ttySL95
[    9.374956] device: 'ttySL96': device_add
[    9.375123] PM: Adding info for No Bus:ttySL96
[    9.375336] device: 'ttySL97': device_add
[    9.375488] PM: Adding info for No Bus:ttySL97
[    9.375694] device: 'ttySL98': device_add
[    9.375846] PM: Adding info for No Bus:ttySL98
[    9.376053] device: 'ttySL99': device_add
[    9.376205] PM: Adding info for No Bus:ttySL99
[    9.376411] device: 'ttySL100': device_add
[    9.376568] PM: Adding info for No Bus:ttySL100
[    9.376779] device: 'ttySL101': device_add
[    9.376932] PM: Adding info for No Bus:ttySL101
[    9.377140] device: 'ttySL102': device_add
[    9.377291] PM: Adding info for No Bus:ttySL102
[    9.377498] device: 'ttySL103': device_add
[    9.377651] PM: Adding info for No Bus:ttySL103
[    9.377864] device: 'ttySL104': device_add
[    9.378016] PM: Adding info for No Bus:ttySL104
[    9.378220] device: 'ttySL105': device_add
[    9.378406] PM: Adding info for No Bus:ttySL105
[    9.378779] device: 'ttySL106': device_add
[    9.378931] PM: Adding info for No Bus:ttySL106
[    9.379137] device: 'ttySL107': device_add
[    9.379290] PM: Adding info for No Bus:ttySL107
[    9.379494] device: 'ttySL108': device_add
[    9.379647] PM: Adding info for No Bus:ttySL108
[    9.379852] device: 'ttySL109': device_add
[    9.380005] PM: Adding info for No Bus:ttySL109
[    9.380210] device: 'ttySL110': device_add
[    9.380363] PM: Adding info for No Bus:ttySL110
[    9.380570] device: 'ttySL111': device_add
[    9.380723] PM: Adding info for No Bus:ttySL111
[    9.380928] device: 'ttySL112': device_add
[    9.381086] PM: Adding info for No Bus:ttySL112
[    9.381294] device: 'ttySL113': device_add
[    9.381448] PM: Adding info for No Bus:ttySL113
[    9.381668] device: 'ttySL114': device_add
[    9.381822] PM: Adding info for No Bus:ttySL114
[    9.382037] device: 'ttySL115': device_add
[    9.382190] PM: Adding info for No Bus:ttySL115
[    9.382396] device: 'ttySL116': device_add
[    9.382550] PM: Adding info for No Bus:ttySL116
[    9.382758] device: 'ttySL117': device_add
[    9.382912] PM: Adding info for No Bus:ttySL117
[    9.383117] device: 'ttySL118': device_add
[    9.383270] PM: Adding info for No Bus:ttySL118
[    9.383476] device: 'ttySL119': device_add
[    9.383629] PM: Adding info for No Bus:ttySL119
[    9.383836] device: 'ttySL120': device_add
[    9.383989] PM: Adding info for No Bus:ttySL120
[    9.384200] device: 'ttySL121': device_add
[    9.384354] PM: Adding info for No Bus:ttySL121
[    9.384564] device: 'ttySL122': device_add
[    9.384718] PM: Adding info for No Bus:ttySL122
[    9.384924] device: 'ttySL123': device_add
[    9.385118] PM: Adding info for No Bus:ttySL123
[    9.385463] device: 'ttySL124': device_add
[    9.385616] PM: Adding info for No Bus:ttySL124
[    9.385825] device: 'ttySL125': device_add
[    9.385984] PM: Adding info for No Bus:ttySL125
[    9.386194] device: 'ttySL126': device_add
[    9.386348] PM: Adding info for No Bus:ttySL126
[    9.386554] device: 'ttySL127': device_add
[    9.386708] PM: Adding info for No Bus:ttySL127
[    9.386919] SyncLink serial driver $Revision: 4.38 $, tty major#254
[    9.387015] initcall synclink_init+0x0/0x213 returned 0 after 47283 usecs
[    9.387109] calling  sx_init+0x0/0x2a9 @ 1
[    9.387202] device: 'sxctl': device_add
[    9.387334] PM: Adding info for No Bus:sxctl
[    9.387567] bus: 'pci': add driver sx
[    9.387820] initcall sx_init+0x0/0x2a9 returned 0 after 605 usecs
[    9.387913] calling  rio_init+0x0/0xe94 @ 1
[    9.388006] device: 'rioctl': device_add
[    9.388136] PM: Adding info for No Bus:rioctl
[    9.389673] device: 'rioctl': device_unregister
[    9.389763] PM: Removing info for No Bus:rioctl
[    9.390122] device: 'rioctl': device_create_release
[    9.390220] initcall rio_init+0x0/0xe94 returned -5 after 2163 usecs
[    9.390313] initcall rio_init+0x0/0xe94 returned with error code -5 
[    9.390406] calling  init+0x0/0xf @ 1
[    9.390495] bus: 'virtio': add driver virtio_console
[    9.390722] initcall init+0x0/0xf returned 0 after 221 usecs
[    9.390814] calling  raw_init+0x0/0xdd @ 1
[    9.390909] device class 'raw': registering
[    9.391125] device: 'rawctl': device_add
[    9.391256] PM: Adding info for No Bus:rawctl
[    9.391537] initcall raw_init+0x0/0xdd returned 0 after 617 usecs
[    9.391630] calling  r3964_init+0x0/0x38 @ 1
[    9.391737] r3964: Philips r3964 Driver $Revision: 1.10 $
[    9.391831] initcall r3964_init+0x0/0x38 returned 0 after 90 usecs
[    9.391923] calling  sonypi_init+0x0/0x93 @ 1
[    9.392012] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    9.392107] initcall sonypi_init+0x0/0x93 returned -19 after 91 usecs
[    9.392200] calling  hpet_init+0x0/0x57 @ 1
[    9.392292] device: 'hpet': device_add
[    9.392424] PM: Adding info for No Bus:hpet
[    9.393399] bus: 'acpi': add driver hpet
[    9.393514] bus: 'acpi': driver_probe_device: matched device PNP0103:00 with driver hpet
[    9.393644] bus: 'acpi': really_probe: probing driver hpet with device PNP0103:00
[    9.394019] initcall hpet_init+0x0/0x57 returned 0 after 1687 usecs
[    9.394112] calling  nvram_init+0x0/0x70 @ 1
[    9.394205] device: 'nvram': device_add
[    9.394337] PM: Adding info for No Bus:nvram
[    9.394555] Non-volatile memory driver v1.3
[    9.394646] initcall nvram_init+0x0/0x70 returned 0 after 432 usecs
[    9.394738] calling  toshiba_init+0x0/0x318 @ 1
[    9.394828] toshiba: not a supported Toshiba laptop
[    9.394919] initcall toshiba_init+0x0/0x318 returned -19 after 88 usecs
[    9.395026] calling  i8k_init+0x0/0x1ad @ 1
[    9.395121] initcall i8k_init+0x0/0x1ad returned -19 after 4 usecs
[    9.395213] calling  mod_init+0x0/0x9f @ 1
[    9.395388] initcall mod_init+0x0/0x9f returned -19 after 83 usecs
[    9.395480] calling  mod_init+0x0/0x41 @ 1
[    9.395571] initcall mod_init+0x0/0x41 returned -19 after 1 usecs
[    9.395663] calling  pc8736x_gpio_init+0x0/0x3cb @ 1
[    9.395756] Registering platform device 'pc8736x_gpio.0'. Parent at platform
[    9.395849] device: 'pc8736x_gpio.0': device_add
[    9.395948] bus: 'platform': add device pc8736x_gpio.0
[    9.396058] PM: Adding info for platform:pc8736x_gpio.0
[    9.396271] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    9.396380] platform pc8736x_gpio.0: no device found
[    9.396469] PM: Removing info for platform:pc8736x_gpio.0
[    9.396608] bus: 'platform': remove device pc8736x_gpio.0
[    9.396832] initcall pc8736x_gpio_init+0x0/0x3cb returned -19 after 1051 usecs
[    9.396962] calling  nsc_gpio_init+0x0/0x11 @ 1
[    9.397051] nsc_gpio initializing
[    9.397139] initcall nsc_gpio_init+0x0/0x11 returned 0 after 84 usecs
[    9.397232] calling  cs5535_gpio_init+0x0/0x15d @ 1
[    9.397348] cs5535_gpio: DIVIL not found
[    9.397438] initcall cs5535_gpio_init+0x0/0x15d returned -19 after 111 usecs
[    9.397531] calling  mwave_init+0x0/0x26b @ 1
[    9.398236] smapi::smapi_query_DSP_cfg: Error: Could not get DSP modem settings. Aborting.
[    9.398379] mwave: tp3780i::tp3780I_CalcResources: Error: Could not query DSP config. Aborting.
[    9.398516] mwave: mwavedd:mwave_init: Error: Failed to calculate resources
[    9.398612] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    9.398710] initcall mwave_init+0x0/0x26b returned -5 after 1063 usecs
[    9.398805] initcall mwave_init+0x0/0x26b returned with error code -5 
[    9.398898] calling  init_tis+0x0/0xa5 @ 1
[    9.398989] bus: 'pnp': add driver tpm_tis
[    9.399226] initcall init_tis+0x0/0xa5 returned 0 after 231 usecs
[    9.399318] calling  init_nsc+0x0/0x801 @ 1
[    9.399424] initcall init_nsc+0x0/0x801 returned -19 after 15 usecs
[    9.399516] calling  init_inf+0x0/0xf @ 1
[    9.399606] bus: 'pnp': add driver tpm_inf_pnp
[    9.399834] initcall init_inf+0x0/0xf returned 0 after 222 usecs
[    9.399927] calling  serial8250_init+0x0/0x112 @ 1
[    9.400017] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    9.400136] Registering platform device 'serial8250'. Parent at platform
[    9.400229] device: 'serial8250': device_add
[    9.400325] bus: 'platform': add device serial8250
[    9.400434] PM: Adding info for platform:serial8250
[    9.400869] device: 'ttyS0': device_add
[    9.401205] PM: Adding info for No Bus:ttyS0
[    9.401734] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    9.401858] device: 'ttyS1': device_add
[    9.402025] PM: Adding info for No Bus:ttyS1
[    9.402264] device: 'ttyS2': device_add
[    9.402430] PM: Adding info for No Bus:ttyS2
[    9.402666] device: 'ttyS3': device_add
[    9.402832] PM: Adding info for No Bus:ttyS3
[    9.403052] bus: 'platform': add driver serial8250
[    9.403155] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    9.403286] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    9.403425] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    9.403519] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    9.403776] initcall serial8250_init+0x0/0x112 returned 0 after 3668 usecs
[    9.403870] calling  isa_bus_init+0x0/0x33 @ 1
[    9.404105] bus: 'isa': registered
[    9.404194] device: 'isa': device_add
[    9.404295] PM: Adding info for No Bus:isa
[    9.404387] initcall isa_bus_init+0x0/0x33 returned 0 after 415 usecs
[    9.404483] calling  topology_sysfs_init+0x0/0x44 @ 1
[    9.404619] initcall topology_sysfs_init+0x0/0x44 returned 0 after 43 usecs
[    9.404713] calling  cpqarray_init+0x0/0x22a @ 1
[    9.404802] Compaq SMART2 Driver (v 2.6.0)
[    9.404892] bus: 'pci': add driver cpqarray
[    9.405371] bus: 'pci': remove driver cpqarray
[    9.405587] driver: 'cpqarray': driver_release
[    9.405682] initcall cpqarray_init+0x0/0x22a returned -19 after 856 usecs
[    9.405779] calling  DAC960_init_module+0x0/0x46 @ 1
[    9.405871] bus: 'pci': add driver DAC960
[    9.406124] device: 'dac960_gam': device_add
[    9.406258] PM: Adding info for No Bus:dac960_gam
[    9.406471] initcall DAC960_init_module+0x0/0x46 returned 0 after 584 usecs
[    9.406565] calling  init+0x0/0x24 @ 1
[    9.406657] bus: 'virtio': add driver virtio_blk
[    9.406876] initcall init+0x0/0x24 returned 0 after 215 usecs
[    9.406968] calling  ub_init+0x0/0x65 @ 1
[    9.407062] bus: 'usb': add driver ub
[    9.407282] usbcore: registered new interface driver ub
[    9.407379] initcall ub_init+0x0/0x65 returned 0 after 313 usecs
[    9.407471] calling  ics932s401_init+0x0/0x11 @ 1
[    9.407563] bus: 'i2c': add driver ics932s401
[    9.407785] i2c-core: driver [ics932s401] registered
[    9.407882] initcall ics932s401_init+0x0/0x11 returned 0 after 312 usecs
[    9.407976] calling  phantom_init+0x0/0xf7 @ 1
[    9.408065] device class 'phantom': registering
[    9.408280] bus: 'pci': add driver phantom
[    9.408546] Phantom Linux Driver, version n0.9.8, init OK
[    9.408640] initcall phantom_init+0x0/0xf7 returned 0 after 559 usecs
[    9.408733] calling  enclosure_init+0x0/0x14 @ 1
[    9.408822] device class 'enclosure': registering
[    9.409033] initcall enclosure_init+0x0/0x14 returned 0 after 203 usecs
[    9.409127] calling  init_kgdbts+0x0/0x15 @ 1
[    9.409218] initcall init_kgdbts+0x0/0x15 returned 0 after 1 usecs
[    9.409311] calling  ilo_init+0x0/0x9c @ 1
[    9.409400] device class 'iLO': registering
[    9.409610] bus: 'pci': add driver hpilo
[    9.409868] initcall ilo_init+0x0/0x9c returned 0 after 455 usecs
[    9.409961] calling  isl29003_init+0x0/0x11 @ 1
[    9.410052] bus: 'i2c': add driver isl29003
[    9.410269] i2c-core: driver [isl29003] registered
[    9.410363] initcall isl29003_init+0x0/0x11 returned 0 after 303 usecs
[    9.410456] calling  c2port_init+0x0/0x45 @ 1
[    9.410545] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    9.410673] device class 'c2port': registering
[    9.410884] initcall c2port_init+0x0/0x45 returned 0 after 329 usecs
[    9.410978] calling  wm8400_module_init+0x0/0x2a @ 1
[    9.411069] bus: 'i2c': add driver WM8400
[    9.411286] i2c-core: driver [WM8400] registered
[    9.411381] initcall wm8400_module_init+0x0/0x2a returned 0 after 303 usecs
[    9.411474] calling  da903x_init+0x0/0x11 @ 1
[    9.411564] bus: 'i2c': add driver da903x
[    9.411954] i2c-core: driver [da903x] registered
[    9.412048] initcall da903x_init+0x0/0x11 returned 0 after 471 usecs
[    9.412141] calling  pcf50633_init+0x0/0x11 @ 1
[    9.412231] bus: 'i2c': add driver pcf50633
[    9.412453] i2c-core: driver [pcf50633] registered
[    9.412548] initcall pcf50633_init+0x0/0x11 returned 0 after 308 usecs
[    9.412641] calling  scsi_tgt_init+0x0/0x78 @ 1
[    9.412989] device: 'tgt': device_add
[    9.413148] PM: Adding info for No Bus:tgt
[    9.413361] initcall scsi_tgt_init+0x0/0x78 returned 0 after 613 usecs
[    9.413455] calling  spi_transport_init+0x0/0x27 @ 1
[    9.413545] device class 'spi_transport': registering
[    9.413797] device class 'spi_host': registering
[    9.414010] initcall spi_transport_init+0x0/0x27 returned 0 after 451 usecs
[    9.414104] calling  fc_transport_init+0x0/0x43 @ 1
[    9.414194] device class 'fc_host': registering
[    9.414403] device class 'fc_vports': registering
[    9.414611] device class 'fc_remote_ports': registering
[    9.414819] device class 'fc_transport': registering
[    9.415043] initcall fc_transport_init+0x0/0x43 returned 0 after 826 usecs
[    9.415137] calling  iscsi_transport_init+0x0/0x125 @ 1
[    9.415227] Loading iSCSI transport class v2.0-870.
[    9.415316] device class 'iscsi_transport': registering
[    9.415542] device class 'iscsi_endpoint': registering
[    9.415756] device class 'iscsi_host': registering
[    9.415969] device class 'iscsi_connection': registering
[    9.416189] device class 'iscsi_session': registering
[    9.416473] initcall iscsi_transport_init+0x0/0x125 returned 0 after 1213 usecs
[    9.416603] calling  libfc_init+0x0/0x6b @ 1
[    9.416790] initcall libfc_init+0x0/0x6b returned 0 after 93 usecs
[    9.416883] calling  fcoe_init+0x0/0x155 @ 1
[    9.417157] initcall fcoe_init+0x0/0x155 returned 0 after 179 usecs
[    9.417251] calling  fnic_init_module+0x0/0x1ad @ 1
[    9.417341] fnic: Cisco FCoE HBA Driver, ver 1.0.0.1121
[    9.417957] bus: 'pci': add driver fnic
[    9.418233] initcall fnic_init_module+0x0/0x1ad returned 0 after 868 usecs
[    9.418373] calling  advansys_init+0x0/0x5e @ 1
[    9.418469] bus: 'isa': add driver advansys
[    9.418703] device: 'advansys.0': device_add
[    9.418799] bus: 'isa': add device advansys.0
[    9.418904] PM: Adding info for isa:advansys.0
[    9.419109] bus: 'isa': driver_probe_device: matched device advansys.0 with driver advansys
[    9.419992] bus: 'isa': really_probe: probing driver advansys with device advansys.0
[    9.420154] device: 'advansys.1': device_add
[    9.420249] bus: 'isa': add device advansys.1
[    9.420354] PM: Adding info for isa:advansys.1
[    9.420559] bus: 'isa': driver_probe_device: matched device advansys.1 with driver advansys
[    9.420690] bus: 'isa': really_probe: probing driver advansys with device advansys.1
[    9.420848] device: 'advansys.2': device_add
[    9.420944] bus: 'isa': add device advansys.2
[    9.421048] PM: Adding info for isa:advansys.2
[    9.421252] bus: 'isa': driver_probe_device: matched device advansys.2 with driver advansys
[    9.421383] bus: 'isa': really_probe: probing driver advansys with device advansys.2
[    9.421542] device: 'advansys.3': device_add
[    9.421637] bus: 'isa': add device advansys.3
[    9.421756] PM: Adding info for isa:advansys.3
[    9.421963] bus: 'isa': driver_probe_device: matched device advansys.3 with driver advansys
[    9.422094] bus: 'isa': really_probe: probing driver advansys with device advansys.3
[    9.422252] device: 'advansys.4': device_add
[    9.422348] bus: 'isa': add device advansys.4
[    9.422453] PM: Adding info for isa:advansys.4
[    9.422656] bus: 'isa': driver_probe_device: matched device advansys.4 with driver advansys
[    9.422787] bus: 'isa': really_probe: probing driver advansys with device advansys.4
[    9.422945] device: 'advansys.5': device_add
[    9.423041] bus: 'isa': add device advansys.5
[    9.423146] PM: Adding info for isa:advansys.5
[    9.423350] bus: 'isa': driver_probe_device: matched device advansys.5 with driver advansys
[    9.423481] bus: 'isa': really_probe: probing driver advansys with device advansys.5
[    9.423645] device: 'advansys.6': device_add
[    9.423741] bus: 'isa': add device advansys.6
[    9.423845] PM: Adding info for isa:advansys.6
[    9.424048] bus: 'isa': driver_probe_device: matched device advansys.6 with driver advansys
[    9.424179] bus: 'isa': really_probe: probing driver advansys with device advansys.6
[    9.424337] device: 'advansys.7': device_add
[    9.424433] bus: 'isa': add device advansys.7
[    9.424537] PM: Adding info for isa:advansys.7
[    9.424740] bus: 'isa': driver_probe_device: matched device advansys.7 with driver advansys
[    9.424871] bus: 'isa': really_probe: probing driver advansys with device advansys.7
[    9.425058] device: 'advansys.8': device_add
[    9.425162] bus: 'isa': add device advansys.8
[    9.425281] PM: Adding info for isa:advansys.8
[    9.425485] bus: 'isa': driver_probe_device: matched device advansys.8 with driver advansys
[    9.425616] bus: 'isa': really_probe: probing driver advansys with device advansys.8
[    9.425775] device: 'advansys.9': device_add
[    9.425871] bus: 'isa': add device advansys.9
[    9.425976] PM: Adding info for isa:advansys.9
[    9.426180] bus: 'isa': driver_probe_device: matched device advansys.9 with driver advansys
[    9.426310] bus: 'isa': really_probe: probing driver advansys with device advansys.9
[    9.426472] device: 'advansys.10': device_add
[    9.426569] bus: 'isa': add device advansys.10
[    9.426674] PM: Adding info for isa:advansys.10
[    9.426877] bus: 'isa': driver_probe_device: matched device advansys.10 with driver advansys
[    9.427008] bus: 'isa': really_probe: probing driver advansys with device advansys.10
[    9.427165] bus: 'isa': add driver advansys_vlb
[    9.427389] device: 'advansys_vlb.0': device_add
[    9.427487] bus: 'isa': add device advansys_vlb.0
[    9.427592] PM: Adding info for isa:advansys_vlb.0
[    9.427795] bus: 'isa': driver_probe_device: matched device advansys_vlb.0 with driver advansys_vlb
[    9.427928] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.0
[    9.428088] device: 'advansys_vlb.1': device_add
[    9.428184] bus: 'isa': add device advansys_vlb.1
[    9.428290] PM: Adding info for isa:advansys_vlb.1
[    9.428510] bus: 'isa': driver_probe_device: matched device advansys_vlb.1 with driver advansys_vlb
[    9.428642] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.1
[    9.428802] device: 'advansys_vlb.2': device_add
[    9.428899] bus: 'isa': add device advansys_vlb.2
[    9.429005] PM: Adding info for isa:advansys_vlb.2
[    9.429210] bus: 'isa': driver_probe_device: matched device advansys_vlb.2 with driver advansys_vlb
[    9.429342] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.2
[    9.429501] device: 'advansys_vlb.3': device_add
[    9.429598] bus: 'isa': add device advansys_vlb.3
[    9.429704] PM: Adding info for isa:advansys_vlb.3
[    9.429907] bus: 'isa': driver_probe_device: matched device advansys_vlb.3 with driver advansys_vlb
[    9.430039] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.3
[    9.430198] device: 'advansys_vlb.4': device_add
[    9.430295] bus: 'isa': add device advansys_vlb.4
[    9.430401] PM: Adding info for isa:advansys_vlb.4
[    9.430606] bus: 'isa': driver_probe_device: matched device advansys_vlb.4 with driver advansys_vlb
[    9.430738] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.4
[    9.430898] device: 'advansys_vlb.5': device_add
[    9.430994] bus: 'isa': add device advansys_vlb.5
[    9.431100] PM: Adding info for isa:advansys_vlb.5
[    9.431304] bus: 'isa': driver_probe_device: matched device advansys_vlb.5 with driver advansys_vlb
[    9.431437] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.5
[    9.431601] device: 'advansys_vlb.6': device_add
[    9.431948] bus: 'isa': add device advansys_vlb.6
[    9.432059] PM: Adding info for isa:advansys_vlb.6
[    9.432266] bus: 'isa': driver_probe_device: matched device advansys_vlb.6 with driver advansys_vlb
[    9.432398] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.6
[    9.432558] device: 'advansys_vlb.7': device_add
[    9.432655] bus: 'isa': add device advansys_vlb.7
[    9.432761] PM: Adding info for isa:advansys_vlb.7
[    9.432964] bus: 'isa': driver_probe_device: matched device advansys_vlb.7 with driver advansys_vlb
[    9.433096] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.7
[    9.433256] device: 'advansys_vlb.8': device_add
[    9.433352] bus: 'isa': add device advansys_vlb.8
[    9.433459] PM: Adding info for isa:advansys_vlb.8
[    9.433664] bus: 'isa': driver_probe_device: matched device advansys_vlb.8 with driver advansys_vlb
[    9.433796] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.8
[    9.433955] device: 'advansys_vlb.9': device_add
[    9.434052] bus: 'isa': add device advansys_vlb.9
[    9.434158] PM: Adding info for isa:advansys_vlb.9
[    9.434363] bus: 'isa': driver_probe_device: matched device advansys_vlb.9 with driver advansys_vlb
[    9.434495] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.9
[    9.434655] device: 'advansys_vlb.10': device_add
[    9.434753] bus: 'isa': add device advansys_vlb.10
[    9.434859] PM: Adding info for isa:advansys_vlb.10
[    9.435074] bus: 'isa': driver_probe_device: matched device advansys_vlb.10 with driver advansys_vlb
[    9.435207] bus: 'isa': really_probe: probing driver advansys_vlb with device advansys_vlb.10
[    9.435366] bus: 'pci': add driver advansys
[    9.435624] initcall advansys_init+0x0/0x5e returned 0 after 16752 usecs
[    9.435719] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.435915] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 101 usecs
[    9.436044] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.436901] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 744 usecs
[    9.437032] calling  ahc_linux_init+0x0/0x4f @ 1
[    9.437127] bus: 'pci': add driver aic7xxx
[    9.437409] initcall ahc_linux_init+0x0/0x4f returned 0 after 278 usecs
[    9.437503] calling  ahd_linux_init+0x0/0x61 @ 1
[    9.437598] bus: 'pci': add driver aic79xx
[    9.437878] initcall ahd_linux_init+0x0/0x61 returned 0 after 275 usecs
[    9.437972] calling  ips_module_init+0x0/0x170 @ 1
[    9.438064] bus: 'pci': add driver ips
[    9.438379] bus: 'pci': remove driver ips
[    9.438661] driver: 'ips': driver_release
[    9.438755] initcall ips_module_init+0x0/0x170 returned -19 after 674 usecs
[    9.438849] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.438943] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 2 usecs
[    9.439073] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.439167] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 2 usecs
[    9.439297] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.439456] NCR53c406a: no available ports found
[    9.439547] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 154 usecs
[    9.439677] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.440524] sym53c416.c: Version 1.0.0-ac
[    9.440642] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 113 usecs
[    9.440772] calling  qlogicfas408_init+0x0/0x7 @ 1
[    9.440864] initcall qlogicfas408_init+0x0/0x7 returned 0 after 1 usecs
[    9.440957] calling  qlogicfas_init+0x0/0x1ee @ 1
[    9.441048] qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= optionsinitcall qlogicfas_init+0x0/0x1ee returned -19 after 97 usecs
[    9.441274] calling  lpfc_init+0x0/0xad @ 1
[    9.441362] Emulex LightPulse Fibre Channel SCSI driver 8.3.1
[    9.441452] Copyright(c) 2004-2009 Emulex.  All rights reserved.
[    9.441552] bus: 'pci': add driver lpfc
[    9.441821] initcall lpfc_init+0x0/0xad returned 0 after 445 usecs
[    9.441914] calling  init_this_scsi_driver+0x0/0xcb @ 1
[    9.442027] initcall init_this_scsi_driver+0x0/0xcb returned -19 after 19 usecs
[    9.442156] calling  dmx3191d_init+0x0/0x16 @ 1
[    9.442247] bus: 'pci': add driver dmx3191d
[    9.442496] initcall dmx3191d_init+0x0/0x16 returned 0 after 242 usecs
[    9.442590] calling  ibmmca_init+0x0/0x14 @ 1
[    9.442682] initcall ibmmca_init+0x0/0x14 returned 0 after 1 usecs
[    9.442774] calling  megaraid_init+0x0/0x9d @ 1
[    9.442878] bus: 'pci': add driver megaraid_legacy
[    9.443136] initcall megaraid_init+0x0/0x9d returned 0 after 264 usecs
[    9.443230] calling  gdth_init+0x0/0x80e @ 1
[    9.443319] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.443414] bus: 'pci': add driver gdth
[    9.443669] initcall gdth_init+0x0/0x80e returned 0 after 339 usecs
[    9.443763] calling  initio_init_driver+0x0/0x16 @ 1
[    9.443855] bus: 'pci': add driver initio
[    9.444109] initcall initio_init_driver+0x0/0x16 returned 0 after 246 usecs
[    9.444203] calling  inia100_init+0x0/0x16 @ 1
[    9.444294] bus: 'pci': add driver inia100
[    9.444545] initcall inia100_init+0x0/0x16 returned 0 after 244 usecs
[    9.444639] calling  tw_init+0x0/0x25 @ 1
[    9.444727] 3ware Storage Controller device driver for Linux v1.26.02.002.
[    9.444821] bus: 'pci': add driver 3w-xxxx
[    9.445269] initcall tw_init+0x0/0x25 returned 0 after 527 usecs
[    9.445362] calling  twa_init+0x0/0x25 @ 1
[    9.445451] 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
[    9.445580] bus: 'pci': add driver 3w-9xxx
[    9.445848] initcall twa_init+0x0/0x25 returned 0 after 386 usecs
[    9.445941] calling  init_nsp32+0x0/0x2c @ 1
[    9.446031] nsp32: loading...
[    9.446118] bus: 'pci': add driver nsp32
[    9.446372] initcall init_nsp32+0x0/0x2c returned 0 after 331 usecs
[    9.446465] calling  cxgb3i_init_module+0x0/0x31 @ 1
[    9.446557] cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
[    9.446669] device: 'cxgb3i': device_add
[    9.446774] PM: Adding info for No Bus:cxgb3i
[    9.447049] iscsi: registered transport (cxgb3i)
[    9.447177] initcall cxgb3i_init_module+0x0/0x31 returned 0 after 604 usecs
[    9.447272] calling  init_st+0x0/0x160 @ 1
[    9.447362] st: Version 20081215, fixed bufsize 32768, s/g segs 256
[    9.447454] device class 'scsi_tape': registering
[    9.447671] Driver 'st' needs updating - please use bus_type methods
[    9.447764] bus: 'scsi': add driver st
[    9.447997] initcall init_st+0x0/0x160 returned 0 after 619 usecs
[    9.448090] calling  init_sd+0x0/0xdf @ 1
[    9.448200] device class 'scsi_disk': registering
[    9.448423] Driver 'sd' needs updating - please use bus_type methods
[    9.448515] bus: 'scsi': add driver sd
[    9.448736] initcall init_sd+0x0/0xdf returned 0 after 543 usecs
[    9.448829] calling  init_ch_module+0x0/0xa7 @ 1
[    9.448919] SCSI Media Changer driver v0.25 
[    9.449007] device class 'scsi_changer': registering
[    9.449221] Driver 'ch' needs updating - please use bus_type methods
[    9.449314] bus: 'scsi': add driver ch
[    9.449535] initcall init_ch_module+0x0/0xa7 returned 0 after 599 usecs
[    9.449629] calling  ahci_init+0x0/0x16 @ 1
[    9.449720] bus: 'pci': add driver ahci
[    9.449842] bus: 'pci': driver_probe_device: matched device 0000:00:1f.2 with driver ahci
[    9.449972] bus: 'pci': really_probe: probing driver ahci with device 0000:00:1f.2
[    9.450113] ahci 0000:00:1f.2: version 3.0
[    9.450223] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    9.450453] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[    9.450586] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[    9.450684] ahci 0000:00:1f.2: setting latency timer to 64
[    9.451053] scsi2 : ahci
[    9.451367] device: 'host2': device_add
[    9.451469] PM: Adding info for No Bus:host2
[    9.451560] device: 'host2': device_add
[    9.451876] PM: Adding info for No Bus:host2
[    9.452241] scsi3 : ahci
[    9.452330] device: 'host3': device_add
[    9.452432] PM: Adding info for No Bus:host3
[    9.452522] device: 'host3': device_add
[    9.452670] PM: Adding info for No Bus:host3
[    9.452953] scsi4 : ahci
[    9.453042] device: 'host4': device_add
[    9.453143] PM: Adding info for No Bus:host4
[    9.453234] device: 'host4': device_add
[    9.453381] PM: Adding info for No Bus:host4
[    9.453663] scsi5 : ahci
[    9.453751] device: 'host5': device_add
[    9.453858] PM: Adding info for No Bus:host5
[    9.453949] device: 'host5': device_add
[    9.454097] PM: Adding info for No Bus:host5
[    9.454531] ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
[    9.454660] ata2: DUMMY
[    9.454744] ata3: DUMMY
[    9.454828] ata4: DUMMY
[    9.775024] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.777004] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    9.777097] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    9.777190] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    9.778575] ata1.00: ATA-7: HTS541080G9SA00, MB4IC60H, max UDMA/100
[    9.778668] ata1.00: 156301488 sectors, multi 16: LBA48 
[    9.780722] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    9.780815] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    9.780907] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    9.782215] ata1.00: configured for UDMA/100
[    9.797714] ata1.00: configured for UDMA/100
[    9.797805] ata1: EH complete
[    9.797902] async_waiting @ 1
[    9.797990] async_continuing @ 1 after 1 usec
[    9.799122] scsi 2:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
[    9.799258] device: 'target2:0:0': device_add
[    9.799503] PM: Adding info for No Bus:target2:0:0
[    9.799662] device: '2:0:0:0': device_add
[    9.799806] bus: 'scsi': add device 2:0:0:0
[    9.799946] PM: Adding info for scsi:2:0:0:0
[    9.800357] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 with driver st
[    9.800487] bus: 'scsi': really_probe: probing driver st with device 2:0:0:0
[    9.800708] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 with driver sd
[    9.800838] bus: 'scsi': really_probe: probing driver sd with device 2:0:0:0
[    9.801224] device: '2:0:0:0': device_add
[    9.801359] PM: Adding info for No Bus:2:0:0:0
[    9.801817] sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    9.802002] sd 2:0:0:0: [sda] Write Protect is off
[    9.802093] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.802281] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.802457] device: 'sda': device_add
[    9.802603] PM: Adding info for No Bus:sda
[    9.803745]  sda: sda1 sda2
[   10.191479] device: 'sda1': device_add
[   10.191852] PM: Adding info for No Bus:sda1
[   10.192412] device: 'sda2': device_add
[   10.192541] PM: Adding info for No Bus:sda2
[   10.193309] device: '8:0': device_add
[   10.193425] PM: Adding info for No Bus:8:0
[   10.193820] sd 2:0:0:0: [sda] Attached SCSI disk
[   10.193910] driver: '2:0:0:0': driver_bound: bound to device 'sd'
[   10.194003] bus: 'scsi': really_probe: bound device 2:0:0:0 to driver sd
[   10.194100] device: '2:0:0:0': device_add
[   10.194217] PM: Adding info for No Bus:2:0:0:0
[   10.194595] async_waiting @ 1
[   10.194684] async_continuing @ 1 after 1 usec
[   10.194799] async_waiting @ 1
[   10.194888] async_continuing @ 1 after 1 usec
[   10.208360] async_waiting @ 1
[   10.208451] async_continuing @ 1 after 1 usec
[   10.208540] driver: '0000:00:1f.2': driver_bound: bound to device 'ahci'
[   10.208635] bus: 'pci': really_probe: bound device 0000:00:1f.2 to driver ahci
[   10.208932] initcall ahci_init+0x0/0x16 returned 0 after 741414 usecs
[   10.209026] calling  k2_sata_init+0x0/0x16 @ 1
[   10.209119] bus: 'pci': add driver sata_svw
[   10.209378] initcall k2_sata_init+0x0/0x16 returned 0 after 253 usecs
[   10.209472] calling  piix_init+0x0/0x24 @ 1
[   10.209563] bus: 'pci': add driver ata_piix
[   10.209680] bus: 'pci': driver_probe_device: matched device 0000:00:1f.1 with driver ata_piix
[   10.209811] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.1
[   10.209950] ata_piix 0000:00:1f.1: version 2.13
[   10.210052] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[   10.210232] ata_piix 0000:00:1f.1: setting latency timer to 64
[   10.210516] scsi6 : ata_piix
[   10.211371] device: 'host6': device_add
[   10.211473] PM: Adding info for No Bus:host6
[   10.211564] device: 'host6': device_add
[   10.211734] PM: Adding info for No Bus:host6
[   10.212012] scsi7 : ata_piix
[   10.212102] device: 'host7': device_add
[   10.212204] PM: Adding info for No Bus:host7
[   10.212294] device: 'host7': device_add
[   10.212443] PM: Adding info for No Bus:host7
[   10.214288] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[   10.214383] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[   10.372124] ata5.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4246N, 0X05, max UDMA/33
[   10.385310] ata5.00: configured for UDMA/33
[   10.386273] async_waiting @ 1
[   10.386363] async_continuing @ 1 after 1 usec
[   10.390558] scsi 6:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4246N 0X05 PQ: 0 ANSI: 5
[   10.390696] device: 'target6:0:0': device_add
[   10.390801] PM: Adding info for No Bus:target6:0:0
[   10.390896] device: '6:0:0:0': device_add
[   10.391040] bus: 'scsi': add device 6:0:0:0
[   10.391146] PM: Adding info for scsi:6:0:0:0
[   10.391362] bus: 'scsi': driver_probe_device: matched device 6:0:0:0 with driver st
[   10.391493] bus: 'scsi': really_probe: probing driver st with device 6:0:0:0
[   10.391610] bus: 'scsi': driver_probe_device: matched device 6:0:0:0 with driver sd
[   10.391754] bus: 'scsi': really_probe: probing driver sd with device 6:0:0:0
[   10.391871] bus: 'scsi': driver_probe_device: matched device 6:0:0:0 with driver ch
[   10.392000] bus: 'scsi': really_probe: probing driver ch with device 6:0:0:0
[   10.392117] device: '6:0:0:0': device_add
[   10.392233] PM: Adding info for No Bus:6:0:0:0
[   10.392463] async_waiting @ 1
[   10.392551] async_continuing @ 1 after 1 usec
[   10.392693] ata6: port disabled. ignoring.
[   10.392797] async_waiting @ 1
[   10.392886] async_continuing @ 1 after 1 usec
[   10.392977] driver: '0000:00:1f.1': driver_bound: bound to device 'ata_piix'
[   10.393072] bus: 'pci': really_probe: bound device 0000:00:1f.1 to driver ata_piix
[   10.393349] initcall piix_init+0x0/0x24 returned 0 after 179477 usecs
[   10.393442] calling  pdc_ata_init+0x0/0x16 @ 1
[   10.393534] bus: 'pci': add driver sata_promise
[   10.393790] initcall pdc_ata_init+0x0/0x16 returned 0 after 249 usecs
[   10.393884] calling  qs_ata_init+0x0/0x16 @ 1
[   10.393975] bus: 'pci': add driver sata_qstor
[   10.394232] initcall qs_ata_init+0x0/0x16 returned 0 after 251 usecs
[   10.394326] calling  sil24_init+0x0/0x16 @ 1
[   10.394417] bus: 'pci': add driver sata_sil24
[   10.394669] initcall sil24_init+0x0/0x16 returned 0 after 245 usecs
[   10.394762] calling  vsc_sata_init+0x0/0x16 @ 1
[   10.394854] bus: 'pci': add driver sata_vsc
[   10.395122] initcall vsc_sata_init+0x0/0x16 returned 0 after 261 usecs
[   10.395215] calling  sis_init+0x0/0x16 @ 1
[   10.395306] bus: 'pci': add driver sata_sis
[   10.395558] initcall sis_init+0x0/0x16 returned 0 after 246 usecs
[   10.395652] calling  nv_init+0x0/0x16 @ 1
[   10.395742] bus: 'pci': add driver sata_nv
[   10.396011] initcall nv_init+0x0/0x16 returned 0 after 262 usecs
[   10.396103] calling  uli_init+0x0/0x16 @ 1
[   10.396194] bus: 'pci': add driver sata_uli
[   10.396445] initcall uli_init+0x0/0x16 returned 0 after 244 usecs
[   10.396537] calling  adma_ata_init+0x0/0x16 @ 1
[   10.396629] bus: 'pci': add driver pdc_adma
[   10.396882] initcall adma_ata_init+0x0/0x16 returned 0 after 247 usecs
[   10.396976] calling  amd_init+0x0/0x16 @ 1
[   10.397066] bus: 'pci': add driver pata_amd
[   10.397318] initcall amd_init+0x0/0x16 returned 0 after 245 usecs
[   10.397411] calling  cs5536_init+0x0/0x16 @ 1
[   10.397503] bus: 'pci': add driver pata_cs5536
[   10.397766] initcall cs5536_init+0x0/0x16 returned 0 after 256 usecs
[   10.397860] calling  cy82c693_init+0x0/0x16 @ 1
[   10.397951] bus: 'pci': add driver pata_cypress
[   10.398206] initcall cy82c693_init+0x0/0x16 returned 0 after 248 usecs
[   10.398299] calling  efar_init+0x0/0x16 @ 1
[   10.398403] bus: 'pci': add driver pata_efar
[   10.398659] initcall efar_init+0x0/0x16 returned 0 after 250 usecs
[   10.398752] calling  hpt36x_init+0x0/0x16 @ 1
[   10.398844] bus: 'pci': add driver pata_hpt366
[   10.399106] initcall hpt36x_init+0x0/0x16 returned 0 after 256 usecs
[   10.399200] calling  hpt37x_init+0x0/0x16 @ 1
[   10.399291] bus: 'pci': add driver pata_hpt37x
[   10.399545] initcall hpt37x_init+0x0/0x16 returned 0 after 247 usecs
[   10.399638] calling  hpt3x2n_init+0x0/0x16 @ 1
[   10.399729] bus: 'pci': add driver pata_hpt3x2n
[   10.399990] initcall hpt3x2n_init+0x0/0x16 returned 0 after 254 usecs
[   10.400084] calling  hpt3x3_init+0x0/0x16 @ 1
[   10.400175] bus: 'pci': add driver pata_hpt3x3
[   10.400428] initcall hpt3x3_init+0x0/0x16 returned 0 after 246 usecs
[   10.400521] calling  isapnp_init+0x0/0xf @ 1
[   10.400612] bus: 'pnp': add driver pata_isapnp
[   10.400840] initcall isapnp_init+0x0/0xf returned 0 after 222 usecs
[   10.400933] calling  ninja32_init+0x0/0x16 @ 1
[   10.401025] bus: 'pci': add driver pata_ninja32
[   10.401278] initcall ninja32_init+0x0/0x16 returned 0 after 247 usecs
[   10.401372] calling  marvell_init+0x0/0x16 @ 1
[   10.401463] bus: 'pci': add driver pata_marvell
[   10.401739] initcall marvell_init+0x0/0x16 returned 0 after 269 usecs
[   10.401833] calling  oldpiix_init+0x0/0x16 @ 1
[   10.401925] bus: 'pci': add driver pata_oldpiix
[   10.402187] initcall oldpiix_init+0x0/0x16 returned 0 after 256 usecs
[   10.402281] calling  radisys_init+0x0/0x16 @ 1
[   10.402373] bus: 'pci': add driver pata_radisys
[   10.402637] initcall radisys_init+0x0/0x16 returned 0 after 257 usecs
[   10.402731] calling  rz1000_init+0x0/0x16 @ 1
[   10.402822] bus: 'pci': add driver pata_rz1000
[   10.403082] initcall rz1000_init+0x0/0x16 returned 0 after 254 usecs
[   10.403176] calling  sl82c105_init+0x0/0x16 @ 1
[   10.403268] bus: 'pci': add driver pata_sl82c105
[   10.403526] initcall sl82c105_init+0x0/0x16 returned 0 after 251 usecs
[   10.403620] calling  sis_init+0x0/0x16 @ 1
[   10.403711] bus: 'pci': add driver pata_sis
[   10.403969] initcall sis_init+0x0/0x16 returned 0 after 252 usecs
[   10.404063] calling  triflex_init+0x0/0x16 @ 1
[   10.404154] bus: 'pci': add driver pata_triflex
[   10.404419] initcall triflex_init+0x0/0x16 returned 0 after 258 usecs
[   10.404513] calling  sch_init+0x0/0x16 @ 1
[   10.404604] bus: 'pci': add driver pata_sch
[   10.404860] initcall sch_init+0x0/0x16 returned 0 after 250 usecs
[   10.404953] calling  pata_platform_init+0x0/0xf @ 1
[   10.405059] bus: 'platform': add driver pata_platform
[   10.405294] initcall pata_platform_init+0x0/0xf returned 0 after 229 usecs
[   10.405388] calling  e1000_init_module+0x0/0x53 @ 1
[   10.405479] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[   10.405570] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   10.405662] bus: 'pci': add driver e1000e
[   10.405784] bus: 'pci': driver_probe_device: matched device 0000:02:00.0 with driver e1000e
[   10.405914] bus: 'pci': really_probe: probing driver e1000e with device 0000:02:00.0
[   10.406105] e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.406209] e1000e 0000:02:00.0: setting latency timer to 64
[   10.406460] 0000:02:00.0: 0000:02:00.0: Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
[   10.457454] e1000e 0000:02:00.0: Warning: detected ASPM enabled in EEPROM
[   10.508226] device: 'eth0': device_add
[   10.508505] PM: Adding info for No Bus:eth0
[   10.508886] 0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:41:17:49:d2
[   10.509016] 0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
[   10.509183] 0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
[   10.509275] driver: '0000:02:00.0': driver_bound: bound to device 'e1000e'
[   10.509369] bus: 'pci': really_probe: bound device 0000:02:00.0 to driver e1000e
[   10.509678] initcall e1000_init_module+0x0/0x53 returned 0 after 101753 usecs
[   10.509773] calling  ixgbe_init_module+0x0/0x43 @ 1
[   10.509864] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.8-k2
[   10.509992] ixgbe: Copyright (c) 1999-2009 Intel Corporation.
[   10.510085] bus: 'pci': add driver ixgbe
[   10.510339] initcall ixgbe_init_module+0x0/0x43 returned 0 after 461 usecs
[   10.510433] calling  cxgb3_init_module+0x0/0x1b @ 1
[   10.510526] bus: 'pci': add driver cxgb3
[   10.510790] initcall cxgb3_init_module+0x0/0x1b returned 0 after 257 usecs
[   10.510884] calling  atl2_init_module+0x0/0x39 @ 1
[   10.510974] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   10.511063] Copyright (c) 2007 Atheros Corporation.
[   10.511154] bus: 'pci': add driver atl2
[   10.511405] initcall atl2_init_module+0x0/0x39 returned 0 after 419 usecs
[   10.511498] calling  be_init_module+0x0/0x6a @ 1
[   10.511590] bus: 'pci': add driver be2net
[   10.511869] initcall be_init_module+0x0/0x6a returned 0 after 272 usecs
[   10.511962] calling  happy_meal_probe+0x0/0x16 @ 1
[   10.512054] bus: 'pci': add driver hme
[   10.512304] initcall happy_meal_probe+0x0/0x16 returned 0 after 244 usecs
[   10.512398] calling  gem_init+0x0/0x16 @ 1
[   10.512488] bus: 'pci': add driver gem
[   10.512767] initcall gem_init+0x0/0x16 returned 0 after 271 usecs
[   10.512859] calling  vortex_init+0x0/0x9c @ 1
[   10.512950] bus: 'pci': add driver 3c59x
[   10.513216] initcall vortex_init+0x0/0x9c returned 0 after 259 usecs
[   10.513309] calling  typhoon_init+0x0/0x16 @ 1
[   10.513400] bus: 'pci': add driver typhoon
[   10.513660] initcall typhoon_init+0x0/0x16 returned 0 after 254 usecs
[   10.513753] calling  e100_init_module+0x0/0x4d @ 1
[   10.513844] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   10.513935] e100: Copyright(c) 1999-2006 Intel Corporation
[   10.514027] bus: 'pci': add driver e100
[   10.515052] initcall e100_init_module+0x0/0x4d returned 0 after 1178 usecs
[   10.515146] calling  epic_init+0x0/0x16 @ 1
[   10.515237] bus: 'pci': add driver epic100
[   10.515493] initcall epic_init+0x0/0x16 returned 0 after 250 usecs
[   10.515586] calling  sis900_init_module+0x0/0x16 @ 1
[   10.515679] bus: 'pci': add driver sis900
[   10.515946] initcall sis900_init_module+0x0/0x16 returned 0 after 261 usecs
[   10.516040] calling  r6040_init+0x0/0x16 @ 1
[   10.516132] bus: 'pci': add driver r6040
[   10.516385] initcall r6040_init+0x0/0x16 returned 0 after 247 usecs
[   10.516477] calling  ns83820_init+0x0/0x20 @ 1
[   10.516566] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   10.516661] bus: 'pci': add driver ns83820
[   10.516916] initcall ns83820_init+0x0/0x20 returned 0 after 339 usecs
[   10.517009] calling  fealnx_init+0x0/0x16 @ 1
[   10.517101] bus: 'pci': add driver fealnx
[   10.517361] initcall fealnx_init+0x0/0x16 returned 0 after 255 usecs
[   10.517454] calling  tg3_init+0x0/0x16 @ 1
[   10.517545] bus: 'pci': add driver tg3
[   10.517805] initcall tg3_init+0x0/0x16 returned 0 after 254 usecs
[   10.517897] calling  starfire_init+0x0/0x16 @ 1
[   10.517989] bus: 'pci': add driver starfire
[   10.518243] initcall starfire_init+0x0/0x16 returned 0 after 248 usecs
[   10.518350] calling  marvell_init+0x0/0x46 @ 1
[   10.518441] bus: 'mdio_bus': add driver Marvell 88E1101
[   10.518671] bus: 'mdio_bus': add driver Marvell 88E1112
[   10.518890] bus: 'mdio_bus': add driver Marvell 88E1111
[   10.519112] bus: 'mdio_bus': add driver Marvell 88E1118
[   10.519331] bus: 'mdio_bus': add driver Marvell 88E1121R
[   10.519553] bus: 'mdio_bus': add driver Marvell 88E1145
[   10.519782] bus: 'mdio_bus': add driver Marvell 88E1240
[   10.520003] initcall marvell_init+0x0/0x46 returned 0 after 1524 usecs
[   10.520096] calling  davicom_init+0x0/0x4d @ 1
[   10.520186] bus: 'mdio_bus': add driver Davicom DM9161E
[   10.520405] bus: 'mdio_bus': add driver Davicom DM9161A
[   10.520622] bus: 'mdio_bus': add driver Davicom DM9131
[   10.520840] initcall davicom_init+0x0/0x4d returned 0 after 638 usecs
[   10.520934] calling  broadcom_init+0x0/0xdb @ 1
[   10.521024] bus: 'mdio_bus': add driver Broadcom BCM5411
[   10.521242] bus: 'mdio_bus': add driver Broadcom BCM5421
[   10.521468] bus: 'mdio_bus': add driver Broadcom BCM5461
[   10.521766] bus: 'mdio_bus': add driver Broadcom BCM5464
[   10.521991] bus: 'mdio_bus': add driver Broadcom BCM5481
[   10.522214] bus: 'mdio_bus': add driver Broadcom BCM5482
[   10.522436] bus: 'mdio_bus': add driver Broadcom BCM50610
[   10.522663] bus: 'mdio_bus': add driver Broadcom BCM57780
[   10.522888] initcall broadcom_init+0x0/0xdb returned 0 after 1819 usecs
[   10.522982] calling  fixed_mdio_bus_init+0x0/0xe1 @ 1
[   10.523075] Registering platform device 'Fixed MDIO bus.0'. Parent at platform
[   10.523204] device: 'Fixed MDIO bus.0': device_add
[   10.523303] bus: 'platform': add device Fixed MDIO bus.0
[   10.523414] PM: Adding info for platform:Fixed MDIO bus.0
[   10.523632] device: '0': device_add
[   10.523746] PM: Adding info for No Bus:0
[   10.524032] Fixed MDIO Bus: probed
[   10.524122] initcall fixed_mdio_bus_init+0x0/0xe1 returned 0 after 1023 usecs
[   10.524216] calling  mdio_gpio_init+0x0/0xf @ 1
[   10.524306] bus: 'platform': add driver mdio-gpio
[   10.524537] initcall mdio_gpio_init+0x0/0xf returned 0 after 224 usecs
[   10.524630] calling  ns_init+0x0/0xf @ 1
[   10.524719] bus: 'mdio_bus': add driver NatSemi DP83865
[   10.524948] initcall ns_init+0x0/0xf returned 0 after 222 usecs
[   10.525054] calling  ste10Xp_init+0x0/0x1d @ 1
[   10.525146] bus: 'mdio_bus': add driver STe100p
[   10.525367] bus: 'mdio_bus': add driver STe101p
[   10.525598] initcall ste10Xp_init+0x0/0x1d returned 0 after 441 usecs
[   10.525691] calling  hamachi_init+0x0/0x16 @ 1
[   10.525783] bus: 'pci': add driver hamachi
[   10.526045] initcall hamachi_init+0x0/0x16 returned 0 after 256 usecs
[   10.526138] calling  net_olddevs_init+0x0/0x81 @ 1
[   10.534590] Registering platform device 'ne.0'. Parent at platform
[   10.534682] device: 'ne.0': device_add
[   10.534778] bus: 'platform': add device ne.0
[   10.534885] PM: Adding info for platform:ne.0
[   10.535111] Registering platform device 'ne.1'. Parent at platform
[   10.535204] device: 'ne.1': device_add
[   10.535314] bus: 'platform': add device ne.1
[   10.535421] PM: Adding info for platform:ne.1
[   10.535633] Registering platform device 'ne.2'. Parent at platform
[   10.535725] device: 'ne.2': device_add
[   10.535820] bus: 'platform': add device ne.2
[   10.535927] PM: Adding info for platform:ne.2
[   10.536139] Registering platform device 'ne.3'. Parent at platform
[   10.536231] device: 'ne.3': device_add
[   10.536326] bus: 'platform': add device ne.3
[   10.536433] PM: Adding info for platform:ne.3
[   10.537928] initcall net_olddevs_init+0x0/0x81 returned 0 after 11423 usecs
[   10.538022] calling  hp100_module_init+0x0/0x16 @ 1
[   10.538115] bus: 'pci': add driver hp100
[   10.538378] initcall hp100_module_init+0x0/0x16 returned 0 after 257 usecs
[   10.538473] calling  ne_init+0x0/0x21 @ 1
[   10.538562] bus: 'platform': add driver ne
[   10.538662] bus: 'platform': driver_probe_device: matched device ne.0 with driver ne
[   10.538792] bus: 'platform': really_probe: probing driver ne with device ne.0
[   10.538944] bus: 'platform': driver_probe_device: matched device ne.1 with driver ne
[   10.539074] bus: 'platform': really_probe: probing driver ne with device ne.1
[   10.539224] bus: 'platform': driver_probe_device: matched device ne.2 with driver ne
[   10.539353] bus: 'platform': really_probe: probing driver ne with device ne.2
[   10.539502] bus: 'platform': driver_probe_device: matched device ne.3 with driver ne
[   10.539632] bus: 'platform': really_probe: probing driver ne with device ne.3
[   10.539921] bus: 'platform': remove driver ne
[   10.540139] driver: 'ne': driver_release
[   10.540230] PM: Removing info for platform:ne.0
[   10.540355] bus: 'platform': remove device ne.0
[   10.540574] PM: Removing info for platform:ne.1
[   10.540698] bus: 'platform': remove device ne.1
[   10.540920] PM: Removing info for platform:ne.2
[   10.541044] bus: 'platform': remove device ne.2
[   10.541269] PM: Removing info for platform:ne.3
[   10.541393] bus: 'platform': remove device ne.3
[   10.541616] initcall ne_init+0x0/0x21 returned -19 after 2981 usecs
[   10.541956] calling  init_nic+0x0/0x16 @ 1
[   10.542053] bus: 'pci': add driver forcedeth
[   10.542312] initcall init_nic+0x0/0x16 returned 0 after 254 usecs
[   10.542404] calling  cp_init+0x0/0x16 @ 1
[   10.542495] bus: 'pci': add driver 8139cp
[   10.542747] initcall cp_init+0x0/0x16 returned 0 after 246 usecs
[   10.542840] calling  rtl8139_init_module+0x0/0x16 @ 1
[   10.542933] bus: 'pci': add driver 8139too
[   10.543184] initcall rtl8139_init_module+0x0/0x16 returned 0 after 246 usecs
[   10.543279] calling  znet_probe+0x0/0x328 @ 1
[   10.543541] initcall znet_probe+0x0/0x328 returned -19 after 167 usecs
[   10.543634] calling  eql_init_module+0x0/0x50 @ 1
[   10.543724] Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[   10.543864] device: 'eql': device_add
[   10.544090] PM: Adding info for No Bus:eql
[   10.544333] initcall eql_init_module+0x0/0x50 returned 0 after 592 usecs
[   10.544427] calling  tun_init+0x0/0x79 @ 1
[   10.544515] tun: Universal TUN/TAP device driver, 1.6
[   10.544604] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   10.544701] device: 'tun': device_add
[   10.544904] PM: Adding info for No Bus:tun
[   10.545160] initcall tun_init+0x0/0x79 returned 0 after 627 usecs
[   10.545253] calling  amd8111e_init+0x0/0x16 @ 1
[   10.545345] bus: 'pci': add driver amd8111e
[   10.545603] initcall amd8111e_init+0x0/0x16 returned 0 after 252 usecs
[   10.545697] calling  dnet_init+0x0/0xf @ 1
[   10.545786] bus: 'platform': add driver dnet
[   10.546008] initcall dnet_init+0x0/0xf returned 0 after 215 usecs
[   10.546101] calling  arcnet_init+0x0/0x50 @ 1
[   10.546190] arcnet loaded.
[   10.546277] initcall arcnet_init+0x0/0x50 returned 0 after 84 usecs
[   10.546370] calling  arcnet_raw_init+0x0/0x52 @ 1
[   10.546459] arcnet: raw mode (`r') encapsulation support loaded.
[   10.546553] initcall arcnet_raw_init+0x0/0x52 returned 0 after 90 usecs
[   10.546646] calling  pegasus_init+0x0/0x121 @ 1
[   10.546736] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[   10.546867] bus: 'usb': add driver pegasus
[   10.547090] usbcore: registered new interface driver pegasus
[   10.547187] initcall pegasus_init+0x0/0x121 returned 0 after 439 usecs
[   10.547281] calling  usb_rtl8150_init+0x0/0x20 @ 1
[   10.547370] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[   10.547464] bus: 'usb': add driver rtl8150
[   10.547686] usbcore: registered new interface driver rtl8150
[   10.547783] initcall usb_rtl8150_init+0x0/0x20 returned 0 after 401 usecs
[   10.547877] calling  asix_init+0x0/0x16 @ 1
[   10.547967] bus: 'usb': add driver asix
[   10.548183] usbcore: registered new interface driver asix
[   10.548279] initcall asix_init+0x0/0x16 returned 0 after 305 usecs
[   10.548439] calling  cdc_init+0x0/0x16 @ 1
[   10.548533] bus: 'usb': add driver cdc_ether
[   10.548753] usbcore: registered new interface driver cdc_ether
[   10.548850] initcall cdc_init+0x0/0x16 returned 0 after 310 usecs
[   10.548942] calling  dm9601_init+0x0/0x16 @ 1
[   10.549033] bus: 'usb': add driver dm9601
[   10.549249] usbcore: registered new interface driver dm9601
[   10.549346] initcall dm9601_init+0x0/0x16 returned 0 after 305 usecs
[   10.549439] calling  plusb_init+0x0/0x16 @ 1
[   10.549529] bus: 'usb': add driver plusb
[   10.549747] usbcore: registered new interface driver plusb
[   10.549844] initcall plusb_init+0x0/0x16 returned 0 after 307 usecs
[   10.549937] calling  rndis_init+0x0/0x16 @ 1
[   10.550027] bus: 'usb': add driver rndis_host
[   10.550997] usbcore: registered new interface driver rndis_host
[   10.551095] initcall rndis_init+0x0/0x16 returned 0 after 1042 usecs
[   10.551188] calling  cdc_subset_init+0x0/0x16 @ 1
[   10.551279] bus: 'usb': add driver cdc_subset
[   10.551498] usbcore: registered new interface driver cdc_subset
[   10.551596] initcall cdc_subset_init+0x0/0x16 returned 0 after 309 usecs
[   10.551702] calling  zaurus_init+0x0/0x16 @ 1
[   10.551794] bus: 'usb': add driver zaurus
[   10.552013] usbcore: registered new interface driver zaurus
[   10.552110] initcall zaurus_init+0x0/0x16 returned 0 after 308 usecs
[   10.552203] calling  usbnet_init+0x0/0x26 @ 1
[   10.552303] initcall usbnet_init+0x0/0x26 returned 0 after 9 usecs
[   10.552395] calling  ipw2100_init+0x0/0x68 @ 1
[   10.552484] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   10.552576] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   10.552669] bus: 'pci': add driver ipw2100
[   10.552942] initcall ipw2100_init+0x0/0x68 returned 0 after 445 usecs
[   10.553035] calling  ieee80211_init+0x0/0x1b @ 1
[   10.553124] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   10.553216] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   10.553348] initcall ieee80211_init+0x0/0x1b returned 0 after 217 usecs
[   10.553441] calling  rndis_wlan_init+0x0/0x16 @ 1
[   10.553532] bus: 'usb': add driver rndis_wlan
[   10.553763] usbcore: registered new interface driver rndis_wlan
[   10.553861] initcall rndis_wlan_init+0x0/0x16 returned 0 after 321 usecs
[   10.553954] calling  w840_init+0x0/0x20 @ 1
[   10.554043] winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[   10.554045]   http://www.scyld.com/network/drivers.html
[   10.554263] bus: 'pci': add driver winbond-840
[   10.554514] initcall w840_init+0x0/0x20 returned 0 after 457 usecs
[   10.554606] calling  init_netconsole+0x0/0x210 @ 1
[   10.554700] netconsole: local port 4444
[   10.554787] netconsole: local IP 10.0.1.15
[   10.554874] netconsole: interface eth0
[   10.554961] netconsole: remote port 4444
[   10.555290] netconsole: remote IP 10.0.1.21
[   10.555379] netconsole: remote ethernet address 00:30:48:c6:86:26
[   10.555493] netconsole: device eth0 not up yet, forcing it
[   14.581664] netconsole: timeout waiting for carrier
[   14.582832] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   14.595046] console [netcon0] enabled
[   15.204721] netconsole: network logging started
[   15.204833] initcall init_netconsole+0x0/0x210 returned 0 after 4541144 usecs
[   15.204962] calling  fw_core_init+0x0/0x72 @ 1
[   15.205297] bus: 'firewire': registered
[   15.205489] initcall fw_core_init+0x0/0x72 returned 0 after 381 usecs
[   15.205597] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[   15.205794] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 69 usecs
[   15.205903] calling  yenta_socket_init+0x0/0x16 @ 1
[   15.206035] bus: 'pci': add driver yenta_cardbus
[   15.206209] bus: 'pci': driver_probe_device: matched device 0000:15:00.0 with driver yenta_cardbus
[   15.206357] bus: 'pci': really_probe: probing driver yenta_cardbus with device 0000:15:00.0
[   15.206551] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:2012]
[   15.206751] async_waiting @ 1
[   15.206857] async_continuing @ 1 after 1 usec
[   15.334033] yenta_cardbus 0000:15:00.0: ISA IRQ mask 0x0cf8, PCI irq 16
[   15.334146] yenta_cardbus 0000:15:00.0: Socket status: 30000007
[   15.334341] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
[   15.334547] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x9000-0xcfff: clean.
[   15.342537] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
[   15.342714] yenta_cardbus 0000:15:00.0: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
[   15.343117] device: 'pcmcia_socket0': device_add
[   15.343255] PM: Adding info for No Bus:pcmcia_socket0
[   15.343588] driver: '0000:15:00.0': driver_bound: bound to device 'yenta_cardbus'
[   15.343740] bus: 'pci': really_probe: bound device 0000:15:00.0 to driver yenta_cardbus
[   15.344093] initcall yenta_socket_init+0x0/0x16 returned 0 after 134827 usecs
[   15.344203] calling  uwb_subsys_init+0x0/0x46 @ 1
[   15.344368] device class 'uwb_rc': registering
[   15.344623] initcall uwb_subsys_init+0x0/0x46 returned 0 after 282 usecs
[   15.344732] calling  wlp_subsys_init+0x0/0x7 @ 1
[   15.344863] initcall wlp_subsys_init+0x0/0x7 returned 0 after 1 usecs
[   15.345003] calling  hwarc_driver_init+0x0/0x16 @ 1
[   15.345149] bus: 'usb': add driver hwa-rc
[   15.345408] usbcore: registered new interface driver hwa-rc
[   15.345522] initcall hwarc_driver_init+0x0/0x16 returned 0 after 381 usecs
[   15.345655] calling  mon_init+0x0/0xee @ 1
[   15.345805] device class 'usbmon': registering
[   15.346061] device: 'usbmon0': device_add
[   15.346299] PM: Adding info for No Bus:usbmon0
[   15.346624] initcall mon_init+0x0/0xee returned 0 after 824 usecs
[   15.346732] calling  ehci_hcd_init+0x0/0xbb @ 1
[   15.346860] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   15.346987] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[   15.347146] bus: 'pci': add driver ehci_hcd
[   15.347277] bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with driver ehci_hcd
[   15.347449] bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:1d.7
[   15.348342] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[   15.348468] IOAPIC[0]: Set routing entry (1-19 -> 0x71 -> IRQ 19 Mode:1 Active:1)
[   15.348647] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   15.348811] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   15.348923] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   15.349217] device: 'usb_host1': device_add
[   15.349541] PM: Adding info for No Bus:usb_host1
[   15.350584] drivers/usb/core/inode.c: creating file 'devices'
[   15.350876] drivers/usb/core/inode.c: creating file '001'
[   15.351140] device: 'usbmon1': device_add
[   15.351513] PM: Adding info for No Bus:usbmon1
[   15.352141] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   15.352299] ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
[   15.353241] ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
[   15.353684] ehci_hcd 0000:00:1d.7: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
[   15.357750] ehci_hcd 0000:00:1d.7: debug port 1
[   15.357867] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   15.358003] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   15.358187] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
[   15.358299] ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   15.362372] ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
[   15.371731] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   15.372155] usb usb1: default language 0x0409
[   15.372318] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   15.372429] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.372600] usb usb1: Product: EHCI Host Controller
[   15.372726] usb usb1: Manufacturer: Linux 2.6.30-tip ehci_hcd
[   15.372855] usb usb1: SerialNumber: 0000:00:1d.7
[   15.372981] device: 'usb1': device_add
[   15.373233] bus: 'usb': add device usb1
[   15.373359] PM: Adding info for usb:usb1
[   15.373621] usb usb1: uevent
[   15.373920] bus: 'usb': driver_probe_device: matched device usb1 with driver usb
[   15.374069] bus: 'usb': really_probe: probing driver usb with device usb1
[   15.374216] usb usb1: usb_probe_device
[   15.374344] usb usb1: configuration #1 chosen from 1 choice
[   15.374612] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   15.374724] device: '1-0:1.0': device_add
[   15.374913] bus: 'usb': add device 1-0:1.0
[   15.375064] PM: Adding info for usb:1-0:1.0
[   15.375206] usb 1-0:1.0: uevent
[   15.375560] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
[   15.375712] bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
[   15.375862] hub 1-0:1.0: usb_probe_interface
[   15.375994] hub 1-0:1.0: usb_probe_interface - got id
[   15.376125] hub 1-0:1.0: USB hub found
[   15.376518] hub 1-0:1.0: 8 ports detected
[   15.376629] hub 1-0:1.0: standalone hub
[   15.376765] hub 1-0:1.0: no power switching (usb 1.0)
[   15.376897] hub 1-0:1.0: individual port over-current protection
[   15.377032] hub 1-0:1.0: power on to power good time: 20ms
[   15.377463] hub 1-0:1.0: local power source is good
[   15.377576] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   15.377862] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[   15.377978] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[   15.378170] device class 'usb_endpoint': registering
[   15.378654] device: 'usbdev1.1_ep81': device_add
[   15.378870] PM: Adding info for No Bus:usbdev1.1_ep81
[   15.379283] drivers/usb/core/inode.c: creating file '001'
[   15.379451] driver: 'usb1': driver_bound: bound to device 'usb'
[   15.379563] bus: 'usb': really_probe: bound device usb1 to driver usb
[   15.379709] device: 'usbdev1.1_ep00': device_add
[   15.379934] PM: Adding info for No Bus:usbdev1.1_ep00
[   15.380186] driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd'
[   15.380298] bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd
[   15.380653] initcall ehci_hcd_init+0x0/0xbb returned 0 after 32997 usecs
[   15.380763] calling  oxu_module_init+0x0/0xf @ 1
[   15.380894] bus: 'platform': add driver oxu210hp-hcd
[   15.381180] initcall oxu_module_init+0x0/0xf returned 0 after 280 usecs
[   15.381289] calling  ohci_hcd_mod_init+0x0/0xb0 @ 1
[   15.381419] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.381545] ohci_hcd: block sizes: ed 64 td 64
[   15.381706] bus: 'pci': add driver ohci_hcd
[   15.382019] bus: 'ssb': add driver ohci_hcd
[   15.382265] initcall ohci_hcd_mod_init+0x0/0xb0 returned 0 after 824 usecs
[   15.382374] calling  uhci_hcd_init+0x0/0x124 @ 1
[   15.382502] uhci_hcd: USB Universal Host Controller Interface driver
[   15.382701] bus: 'pci': add driver uhci_hcd
[   15.382847] bus: 'pci': driver_probe_device: matched device 0000:00:1d.0 with driver uhci_hcd
[   15.382994] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.0
[   15.383860] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   15.383977] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.384141] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   15.384251] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   15.384399] device: 'usb_host2': device_add
[   15.384557] PM: Adding info for No Bus:usb_host2
[   15.384813] drivers/usb/core/inode.c: creating file '002'
[   15.384969] device: 'usbmon2': device_add
[   15.385201] PM: Adding info for No Bus:usbmon2
[   15.385443] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   15.385598] uhci_hcd 0000:00:1d.0: detected 2 ports
[   15.385733] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
[   15.385863] uhci_hcd 0000:00:1d.0: Performing full reset
[   15.386006] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   15.386151] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[   15.386564] usb usb2: default language 0x0409
[   15.386704] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   15.386843] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.387011] usb usb2: Product: UHCI Host Controller
[   15.387139] usb usb2: Manufacturer: Linux 2.6.30-tip uhci_hcd
[   15.387269] usb usb2: SerialNumber: 0000:00:1d.0
[   15.387398] device: 'usb2': device_add
[   15.387652] bus: 'usb': add device usb2
[   15.387778] PM: Adding info for usb:usb2
[   15.387939] usb usb2: uevent
[   15.388166] bus: 'usb': driver_probe_device: matched device usb2 with driver usb
[   15.388315] bus: 'usb': really_probe: probing driver usb with device usb2
[   15.388509] usb usb2: usb_probe_device
[   15.388641] usb usb2: configuration #1 chosen from 1 choice
[   15.388788] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   15.388923] device: '2-0:1.0': device_add
[   15.389105] bus: 'usb': add device 2-0:1.0
[   15.389232] PM: Adding info for usb:2-0:1.0
[   15.389373] usb 2-0:1.0: uevent
[   15.389642] bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
[   15.389794] bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
[   15.389946] hub 2-0:1.0: usb_probe_interface
[   15.390078] hub 2-0:1.0: usb_probe_interface - got id
[   15.390229] hub 2-0:1.0: USB hub found
[   15.390544] hub 2-0:1.0: 2 ports detected
[   15.390655] hub 2-0:1.0: standalone hub
[   15.390792] hub 2-0:1.0: no power switching (usb 1.0)
[   15.390925] hub 2-0:1.0: individual port over-current protection
[   15.391078] hub 2-0:1.0: power on to power good time: 2ms
[   15.391277] hub 2-0:1.0: local power source is good
[   15.391390] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   15.391551] driver: '2-0:1.0': driver_bound: bound to device 'hub'
[   15.391705] bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
[   15.391852] device: 'usbdev2.1_ep81': device_add
[   15.392084] PM: Adding info for No Bus:usbdev2.1_ep81
[   15.392332] drivers/usb/core/inode.c: creating file '001'
[   15.392457] driver: 'usb2': driver_bound: bound to device 'usb'
[   15.392596] bus: 'usb': really_probe: bound device usb2 to driver usb
[   15.392739] device: 'usbdev2.1_ep00': device_add
[   15.392973] PM: Adding info for No Bus:usbdev2.1_ep00
[   15.393235] driver: '0000:00:1d.0': driver_bound: bound to device 'uhci_hcd'
[   15.393347] bus: 'pci': really_probe: bound device 0000:00:1d.0 to driver uhci_hcd
[   15.393524] bus: 'pci': driver_probe_device: matched device 0000:00:1d.1 with driver uhci_hcd
[   15.393693] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.1
[   15.393880] IOAPIC[0]: Set routing entry (1-17 -> 0x79 -> IRQ 17 Mode:1 Active:1)
[   15.394055] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   15.394197] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   15.394330] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   15.394474] device: 'usb_host3': device_add
[   15.394651] PM: Adding info for No Bus:usb_host3
[   15.394938] drivers/usb/core/inode.c: creating file '003'
[   15.395255] device: 'usbmon3': device_add
[   15.395446] PM: Adding info for No Bus:usbmon3
[   15.395686] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   15.395842] uhci_hcd 0000:00:1d.1: detected 2 ports
[   15.395977] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
[   15.396108] uhci_hcd 0000:00:1d.1: Performing full reset
[   15.396269] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   15.396438] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[   15.396835] usb usb3: default language 0x0409
[   15.396974] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   15.397113] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.397281] usb usb3: Product: UHCI Host Controller
[   15.397410] usb usb3: Manufacturer: Linux 2.6.30-tip uhci_hcd
[   15.397540] usb usb3: SerialNumber: 0000:00:1d.1
[   15.397669] device: 'usb3': device_add
[   15.397922] bus: 'usb': add device usb3
[   15.398048] PM: Adding info for usb:usb3
[   15.398192] usb usb3: uevent
[   15.398457] bus: 'usb': driver_probe_device: matched device usb3 with driver usb
[   15.398606] bus: 'usb': really_probe: probing driver usb with device usb3
[   15.398772] usb usb3: usb_probe_device
[   15.398878] usb usb3: configuration #1 chosen from 1 choice
[   15.399029] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   15.399164] device: '3-0:1.0': device_add
[   15.399344] bus: 'usb': add device 3-0:1.0
[   15.399471] PM: Adding info for usb:3-0:1.0
[   15.400363] usb 3-0:1.0: uevent
[   15.400634] bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
[   15.400786] bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
[   15.400938] hub 3-0:1.0: usb_probe_interface
[   15.401070] hub 3-0:1.0: usb_probe_interface - got id
[   15.401202] hub 3-0:1.0: USB hub found
[   15.401462] hub 3-0:1.0: 2 ports detected
[   15.401573] hub 3-0:1.0: standalone hub
[   15.401736] hub 3-0:1.0: no power switching (usb 1.0)
[   15.401874] hub 3-0:1.0: individual port over-current protection
[   15.402010] hub 3-0:1.0: power on to power good time: 2ms
[   15.402164] hub 3-0:1.0: local power source is good
[   15.402300] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   15.402475] driver: '3-0:1.0': driver_bound: bound to device 'hub'
[   15.402590] bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
[   15.402739] device: 'usbdev3.1_ep81': device_add
[   15.402978] PM: Adding info for No Bus:usbdev3.1_ep81
[   15.403226] drivers/usb/core/inode.c: creating file '001'
[   15.403352] driver: 'usb3': driver_bound: bound to device 'usb'
[   15.403509] bus: 'usb': really_probe: bound device usb3 to driver usb
[   15.403630] device: 'usbdev3.1_ep00': device_add
[   15.403862] PM: Adding info for No Bus:usbdev3.1_ep00
[   15.404140] driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd'
[   15.404252] bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd
[   15.404429] bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with driver uhci_hcd
[   15.404598] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.2
[   15.405361] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   15.405480] IOAPIC[0]: Set routing entry (1-18 -> 0x81 -> IRQ 18 Mode:1 Active:1)
[   15.405660] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   15.405802] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   15.405935] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   15.406079] device: 'usb_host4': device_add
[   15.406256] PM: Adding info for No Bus:usb_host4
[   15.406491] drivers/usb/core/inode.c: creating file '004'
[   15.406693] device: 'usbmon4': device_add
[   15.406883] PM: Adding info for No Bus:usbmon4
[   15.407142] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   15.407298] uhci_hcd 0000:00:1d.2: detected 2 ports
[   15.407434] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
[   15.407566] uhci_hcd 0000:00:1d.2: Performing full reset
[   15.407710] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   15.407876] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[   15.408263] usb usb4: default language 0x0409
[   15.408504] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   15.408616] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.408792] usb usb4: Product: UHCI Host Controller
[   15.408920] usb usb4: Manufacturer: Linux 2.6.30-tip uhci_hcd
[   15.409050] usb usb4: SerialNumber: 0000:00:1d.2
[   15.409178] device: 'usb4': device_add
[   15.409434] bus: 'usb': add device usb4
[   15.409566] PM: Adding info for usb:usb4
[   15.409712] usb usb4: uevent
[   15.409963] bus: 'usb': driver_probe_device: matched device usb4 with driver usb
[   15.410112] bus: 'usb': really_probe: probing driver usb with device usb4
[   15.410260] usb usb4: usb_probe_device
[   15.410390] usb usb4: configuration #1 chosen from 1 choice
[   15.410555] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   15.410666] device: '4-0:1.0': device_add
[   15.410855] bus: 'usb': add device 4-0:1.0
[   15.410983] PM: Adding info for usb:4-0:1.0
[   15.411126] usb 4-0:1.0: uevent
[   15.411379] bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
[   15.411531] bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
[   15.411700] hub 4-0:1.0: usb_probe_interface
[   15.411834] hub 4-0:1.0: usb_probe_interface - got id
[   15.411968] hub 4-0:1.0: USB hub found
[   15.412230] hub 4-0:1.0: 2 ports detected
[   15.412341] hub 4-0:1.0: standalone hub
[   15.412479] hub 4-0:1.0: no power switching (usb 1.0)
[   15.412613] hub 4-0:1.0: individual port over-current protection
[   15.412749] hub 4-0:1.0: power on to power good time: 2ms
[   15.412904] hub 4-0:1.0: local power source is good
[   15.413040] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   15.413199] driver: '4-0:1.0': driver_bound: bound to device 'hub'
[   15.413336] bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
[   15.413500] device: 'usbdev4.1_ep81': device_add
[   15.413716] PM: Adding info for No Bus:usbdev4.1_ep81
[   15.413966] drivers/usb/core/inode.c: creating file '001'
[   15.414091] driver: 'usb4': driver_bound: bound to device 'usb'
[   15.414232] bus: 'usb': really_probe: bound device usb4 to driver usb
[   15.414392] device: 'usbdev4.1_ep00': device_add
[   15.414604] PM: Adding info for No Bus:usbdev4.1_ep00
[   15.414863] driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd'
[   15.414976] bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd
[   15.415199] bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with driver uhci_hcd
[   15.415348] bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.3
[   15.415556] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   15.415677] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   15.415815] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   15.415961] device: 'usb_host5': device_add
[   15.416139] PM: Adding info for No Bus:usb_host5
[   15.416374] drivers/usb/core/inode.c: creating file '005'
[   15.416583] device: 'usbmon5': device_add
[   15.416773] PM: Adding info for No Bus:usbmon5
[   15.417012] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   15.417168] uhci_hcd 0000:00:1d.3: detected 2 ports
[   15.417305] uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
[   15.417437] uhci_hcd 0000:00:1d.3: Performing full reset
[   15.417612] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[   15.417980] usb usb5: default language 0x0409
[   15.418143] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   15.418254] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   15.418445] usb usb5: Product: UHCI Host Controller
[   15.418575] usb usb5: Manufacturer: Linux 2.6.30-tip uhci_hcd
[   15.418705] usb usb5: SerialNumber: 0000:00:1d.3
[   15.418834] device: 'usb5': device_add
[   15.419093] bus: 'usb': add device usb5
[   15.419219] PM: Adding info for usb:usb5
[   15.419364] usb usb5: uevent
[   15.419613] bus: 'usb': driver_probe_device: matched device usb5 with driver usb
[   15.419761] bus: 'usb': really_probe: probing driver usb with device usb5
[   15.419911] usb usb5: usb_probe_device
[   15.420040] usb usb5: configuration #1 chosen from 1 choice
[   15.420187] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   15.420323] device: '5-0:1.0': device_add
[   15.420504] bus: 'usb': add device 5-0:1.0
[   15.420631] PM: Adding info for usb:5-0:1.0
[   15.420774] usb 5-0:1.0: uevent
[   15.421042] bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
[   15.421194] bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
[   15.421347] hub 5-0:1.0: usb_probe_interface
[   15.421479] hub 5-0:1.0: usb_probe_interface - got id
[   15.421612] hub 5-0:1.0: USB hub found
[   15.421863] hub 5-0:1.0: 2 ports detected
[   15.421975] hub 5-0:1.0: standalone hub
[   15.422114] hub 5-0:1.0: no power switching (usb 1.0)
[   15.422247] hub 5-0:1.0: individual port over-current protection
[   15.422383] hub 5-0:1.0: power on to power good time: 2ms
[   15.422538] hub 5-0:1.0: local power source is good
[   15.422674] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   15.422831] driver: '5-0:1.0': driver_bound: bound to device 'hub'
[   15.422970] bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
[   15.423133] device: 'usbdev5.1_ep81': device_add
[   15.423349] PM: Adding info for No Bus:usbdev5.1_ep81
[   15.423595] drivers/usb/core/inode.c: creating file '001'
[   15.423720] driver: 'usb5': driver_bound: bound to device 'usb'
[   15.423877] bus: 'usb': really_probe: bound device usb5 to driver usb
[   15.423998] device: 'usbdev5.1_ep00': device_add
[   15.424233] PM: Adding info for No Bus:usbdev5.1_ep00
[   15.424493] driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd'
[   15.424605] bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd
[   15.424969] initcall uhci_hcd_init+0x0/0x124 returned 0 after 41466 usecs
[   15.425092] calling  sl811h_init+0x0/0x38 @ 1
[   15.425225] sl811: driver sl811-hcd, 19 May 2005
[   15.425352] bus: 'platform': add driver sl811-hcd
[   15.425636] initcall sl811h_init+0x0/0x38 returned 0 after 399 usecs
[   15.425745] calling  r8a66597_init+0x0/0x38 @ 1
[   15.425877] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[   15.426004] bus: 'platform': add driver r8a66597_hcd
[   15.426287] initcall r8a66597_init+0x0/0x38 returned 0 after 399 usecs
[   15.426396] calling  c67x00_init+0x0/0xf @ 1
[   15.426528] bus: 'platform': add driver c67x00
[   15.426806] initcall c67x00_init+0x0/0xf returned 0 after 270 usecs
[   15.426914] calling  wusbcore_init+0x0/0x6c @ 1
[   15.427139] initcall wusbcore_init+0x0/0x6c returned 0 after 89 usecs
[   15.427249] calling  usblp_init+0x0/0x16 @ 1
[   15.427386] bus: 'usb': add driver usblp
[   15.427689] usbcore: registered new interface driver usblp
[   15.427802] initcall usblp_init+0x0/0x16 returned 0 after 406 usecs
[   15.427936] calling  wdm_init+0x0/0x16 @ 1
[   15.428062] bus: 'usb': add driver cdc_wdm
[   15.428435] usbcore: registered new interface driver cdc_wdm
[   15.428548] initcall wdm_init+0x0/0x16 returned 0 after 475 usecs
[   15.429436] calling  cypress_init+0x0/0x2f @ 1
[   15.429563] bus: 'usb': add driver cypress_cy7c63
[   15.429856] usbcore: registered new interface driver cypress_cy7c63
[   15.429971] initcall cypress_init+0x0/0x2f returned 0 after 398 usecs
[   15.430106] calling  emi26_init+0x0/0x16 @ 1
[   15.430232] bus: 'usb': add driver emi26 - firmware loader
[   15.430559] usbcore: registered new interface driver emi26 - firmware loader
[   15.430677] initcall emi26_init+0x0/0x16 returned 0 after 434 usecs
[   15.430812] calling  isight_firmware_init+0x0/0x16 @ 1
[   15.430940] bus: 'usb': add driver isight_firmware
[   15.431236] usbcore: registered new interface driver isight_firmware
[   15.431353] initcall isight_firmware_init+0x0/0x16 returned 0 after 403 usecs
[   15.431488] calling  usb_led_init+0x0/0x2f @ 1
[   15.431616] bus: 'usb': add driver usbled
[   15.431924] usbcore: registered new interface driver usbled
[   15.432039] initcall usb_led_init+0x0/0x2f returned 0 after 413 usecs
[   15.432174] calling  usb_sevseg_init+0x0/0x2f @ 1
[   15.432302] bus: 'usb': add driver usbsevseg
[   15.432586] usbcore: registered new interface driver usbsevseg
[   15.432699] initcall usb_sevseg_init+0x0/0x2f returned 0 after 388 usecs
[   15.432834] calling  vstusb_init+0x0/0x35 @ 1
[   15.432960] bus: 'usb': add driver vstusb
[   15.433253] usbcore: registered new interface driver vstusb
[   15.433366] initcall vstusb_init+0x0/0x35 returned 0 after 396 usecs
[   15.433500] calling  usb_sisusb_init+0x0/0x16 @ 1
[   15.433628] bus: 'usb': add driver sisusb
[   15.433915] usbcore: registered new interface driver sisusb
[   15.434029] initcall usb_sisusb_init+0x0/0x16 returned 0 after 391 usecs
[   15.434164] calling  i8042_init+0x0/0x34e @ 1
[   15.434309] bus: 'pnp': add driver i8042 kbd
[   15.434430] bus: 'pnp': driver_probe_device: matched device 00:08 with driver i8042 kbd
[   15.434602] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:08
[   15.434779] driver: '00:08': driver_bound: bound to device 'i8042 kbd'
[   15.434911] bus: 'pnp': really_probe: bound device 00:08 to driver i8042 kbd
[   15.435249] bus: 'pnp': add driver i8042 aux
[   15.435378] bus: 'pnp': driver_probe_device: matched device 00:09 with driver i8042 aux
[   15.435551] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:09
[   15.435728] driver: '00:09': driver_bound: bound to device 'i8042 aux'
[   15.435858] bus: 'pnp': really_probe: bound device 00:09 to driver i8042 aux
[   15.436137] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   15.436326] bus: 'platform': add driver i8042
[   15.436609] Registering platform device 'i8042'. Parent at platform
[   15.436717] device: 'i8042': device_add
[   15.436856] bus: 'platform': add device i8042
[   15.437026] PM: Adding info for platform:i8042
[   15.437259] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   15.437407] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   15.445327] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.445507] device: 'serio0': device_add
[   15.445522] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.445529] driver: 'i8042': driver_bound: bound to device 'i8042'
[   15.445533] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   15.445544] initcall i8042_init+0x0/0x34e returned 0 after 10990 usecs
[   15.445548] calling  l4_init+0x0/0x283 @ 1
[   15.445577] initcall l4_init+0x0/0x283 returned -19 after 22 usecs
[   15.445581] calling  mousedev_init+0x0/0x6c @ 1
[   15.445599] device: 'mice': device_add
[   15.445658] PM: Adding info for No Bus:mice
[   15.446692] bus: 'serio': add device serio0
[   15.446835] PM: Adding info for serio:serio0
[   15.447200] mice: PS/2 mouse device common for all mice
[   15.447312] initcall mousedev_init+0x0/0x6c returned 0 after 1684 usecs
[   15.447336] device: 'serio1': device_add
[   15.447347] bus: 'serio': add device serio1
[   15.447380] PM: Adding info for serio:serio1
[   15.447757] calling  evdev_init+0x0/0xf @ 1
[   15.447891] device: 'event0': device_add
[   15.448232] PM: Adding info for No Bus:event0
[   15.448930] device: 'event1': device_add
[   15.449118] PM: Adding info for No Bus:event1
[   15.449354] device: 'event2': device_add
[   15.449516] PM: Adding info for No Bus:event2
[   15.449776] initcall evdev_init+0x0/0xf returned 0 after 1847 usecs
[   15.449885] calling  atkbd_init+0x0/0x20 @ 1
[   15.450037] bus: 'serio': add driver atkbd
[   15.450309] initcall atkbd_init+0x0/0x20 returned 0 after 284 usecs
[   15.450316] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   15.450320] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   15.450741] calling  gpio_keys_init+0x0/0xf @ 1
[   15.450885] bus: 'platform': add driver gpio-keys
[   15.451237] initcall gpio_keys_init+0x0/0xf returned 0 after 343 usecs
[   15.451346] calling  adi_init+0x0/0x16 @ 1
[   15.451523] bus: 'gameport': add driver adi
[   15.451868] initcall adi_init+0x0/0x16 returned 0 after 337 usecs
[   15.451978] calling  analog_init+0x0/0xcd @ 1
[   15.452109] bus: 'gameport': add driver analog
[   15.452416] initcall analog_init+0x0/0xcd returned 0 after 298 usecs
[   15.452526] calling  cobra_init+0x0/0x16 @ 1
[   15.452656] bus: 'gameport': add driver cobra
[   15.452967] initcall cobra_init+0x0/0x16 returned 0 after 301 usecs
[   15.453076] calling  gf2k_init+0x0/0x16 @ 1
[   15.453206] bus: 'gameport': add driver gf2k
[   15.453519] initcall gf2k_init+0x0/0x16 returned 0 after 304 usecs
[   15.453628] calling  joydump_init+0x0/0x16 @ 1
[   15.453759] bus: 'gameport': add driver joydump
[   15.454063] initcall joydump_init+0x0/0x16 returned 0 after 295 usecs
[   15.454172] calling  sw_init+0x0/0x16 @ 1
[   15.454303] bus: 'gameport': add driver sidewinder
[   15.454609] initcall sw_init+0x0/0x16 returned 0 after 297 usecs
[   15.454717] calling  spaceorb_init+0x0/0x16 @ 1
[   15.454849] bus: 'serio': add driver spaceorb
[   15.455160] device: 'input3': device_add
[   15.455399] PM: Adding info for No Bus:input3
[   15.455788] initcall spaceorb_init+0x0/0x16 returned 0 after 916 usecs
[   15.455900] calling  stinger_init+0x0/0x16 @ 1
[   15.455923] input: AT Translated Set 2 keyboard as /class/input/input3
[   15.455977] device: 'event3': device_add
[   15.456076] PM: Adding info for No Bus:event3
[   15.456287] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   15.456291] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   15.456310] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   15.456314] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   15.456868] bus: 'serio': add driver stinger
[   15.457158] initcall stinger_init+0x0/0x16 returned 0 after 282 usecs
[   15.457267] calling  warrior_init+0x0/0x16 @ 1
[   15.457398] bus: 'serio': add driver warrior
[   15.457688] initcall warrior_init+0x0/0x16 returned 0 after 282 usecs
[   15.457796] calling  usb_xpad_init+0x0/0x2d @ 1
[   15.457928] bus: 'usb': add driver xpad
[   15.458228] usbcore: registered new interface driver xpad
[   15.458378] xpad: X-Box pad driver
[   15.458482] initcall usb_xpad_init+0x0/0x2d returned 0 after 541 usecs
[   15.458616] calling  zhenhua_init+0x0/0x16 @ 1
[   15.458741] bus: 'serio': add driver zhenhua
[   15.459026] initcall zhenhua_init+0x0/0x16 returned 0 after 277 usecs
[   15.459135] calling  aiptek_init+0x0/0x38 @ 1
[   15.459267] bus: 'usb': add driver aiptek
[   15.459550] usbcore: registered new interface driver aiptek
[   15.459660] aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
[   15.459830] aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
[   15.460012] initcall aiptek_init+0x0/0x38 returned 0 after 727 usecs
[   15.460143] calling  wacom_init+0x0/0x37 @ 1
[   15.460271] bus: 'usb': add driver wacom
[   15.460566] usbcore: registered new interface driver wacom
[   15.460676] wacom: v1.50:USB Wacom Graphire and Wacom Intuos tablet driver
[   15.460812] initcall wacom_init+0x0/0x37 returned 0 after 528 usecs
[   15.460941] calling  mk712_init+0x0/0x1b4 @ 1
[   15.461070] mk712: device not present
[   15.461197] initcall mk712_init+0x0/0x1b4 returned -19 after 126 usecs
[   15.461342] calling  touchit213_init+0x0/0x16 @ 1
[   15.461473] bus: 'serio': add driver touchit213
[   15.461917] initcall touchit213_init+0x0/0x16 returned 0 after 433 usecs
[   15.462028] calling  tr_init+0x0/0x16 @ 1
[   15.462159] bus: 'serio': add driver touchright
[   15.462450] initcall tr_init+0x0/0x16 returned 0 after 283 usecs
[   15.462559] calling  tw_init+0x0/0x16 @ 1
[   15.462690] bus: 'serio': add driver touchwin
[   15.462982] initcall tw_init+0x0/0x16 returned 0 after 284 usecs
[   15.463091] calling  cm109_init+0x0/0xe1 @ 1
[   15.463221] cm109: Keymap for Komunikate KIP1000 phone loaded
[   15.463349] bus: 'usb': add driver cm109
[   15.463648] usbcore: registered new interface driver cm109
[   15.463758] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[   15.463895] initcall cm109_init+0x0/0xe1 returned 0 after 656 usecs
[   15.464024] calling  powermate_init+0x0/0x16 @ 1
[   15.464151] bus: 'usb': add driver powermate
[   15.464436] usbcore: registered new interface driver powermate
[   15.464550] initcall powermate_init+0x0/0x16 returned 0 after 389 usecs
[   15.464685] calling  uinput_init+0x0/0xf @ 1
[   15.464815] device: 'uinput': device_add
[   15.465022] PM: Adding info for No Bus:uinput
[   15.465256] initcall uinput_init+0x0/0xf returned 0 after 433 usecs
[   15.465364] calling  wb_module_init+0x0/0x24f @ 1
[   15.465504] wistron_btns: System unknown
[   15.465631] initcall wb_module_init+0x0/0x24f returned -19 after 131 usecs
[   15.465760] calling  yealink_dev_init+0x0/0x2d @ 1
[   15.465888] bus: 'usb': add driver yealink
[   15.466927] usbcore: registered new interface driver yealink
[   15.467037] yealink: yld-20051230:Yealink phone driver
[   15.467171] initcall yealink_dev_init+0x0/0x2d returned 0 after 1253 usecs
[   15.467301] calling  i2c_ali1535_init+0x0/0x16 @ 1
[   15.467435] bus: 'pci': add driver ali1535_smbus
[   15.467763] initcall i2c_ali1535_init+0x0/0x16 returned 0 after 325 usecs
[   15.467872] calling  i2c_ali15x3_init+0x0/0x16 @ 1
[   15.468009] bus: 'pci': add driver ali15x3_smbus
[   15.468318] initcall i2c_ali15x3_init+0x0/0x16 returned 0 after 306 usecs
[   15.468445] calling  i2c_amd8111_init+0x0/0x16 @ 1
[   15.468596] bus: 'pci': add driver amd8111_smbus2
[   15.468908] initcall i2c_amd8111_init+0x0/0x16 returned 0 after 309 usecs
[   15.469017] calling  i2c_sch_init+0x0/0x16 @ 1
[   15.469153] bus: 'pci': add driver isch_smbus
[   15.469463] initcall i2c_sch_init+0x0/0x16 returned 0 after 306 usecs
[   15.469572] calling  nforce2_init+0x0/0x16 @ 1
[   15.469708] bus: 'pci': add driver nForce2_smbus
[   15.470018] initcall nforce2_init+0x0/0x16 returned 0 after 306 usecs
[   15.470126] calling  i2c_sis5595_init+0x0/0x16 @ 1
[   15.470263] bus: 'pci': add driver sis5595_smbus
[   15.470575] initcall i2c_sis5595_init+0x0/0x16 returned 0 after 308 usecs
[   15.470684] calling  i2c_vt586b_init+0x0/0x16 @ 1
[   15.470820] bus: 'pci': add driver vt586b_smbus
[   15.471131] initcall i2c_vt586b_init+0x0/0x16 returned 0 after 307 usecs
[   15.471240] calling  i2c_adap_simtec_init+0x0/0xf @ 1
[   15.471373] bus: 'platform': add driver simtec-i2c
[   15.471637] initcall i2c_adap_simtec_init+0x0/0xf returned 0 after 257 usecs
[   15.471759] calling  i2c_pca_pf_init+0x0/0xf @ 1
[   15.471892] bus: 'platform': add driver i2c-pca-platform
[   15.472173] initcall i2c_pca_pf_init+0x0/0xf returned 0 after 273 usecs
[   15.472283] calling  max6875_init+0x0/0x11 @ 1
[   15.472414] bus: 'i2c': add driver max6875
[   15.472673] i2c-core: driver [max6875] registered
[   15.472786] initcall max6875_init+0x0/0x11 returned 0 after 363 usecs
[   15.472921] calling  pcipcwd_init_module+0x0/0x2a @ 1
[   15.473053] bus: 'pci': add driver pcwd_pci
[   15.473362] initcall pcipcwd_init_module+0x0/0x2a returned 0 after 305 usecs
[   15.473471] calling  wdtpci_init+0x0/0x16 @ 1
[   15.473607] bus: 'pci': add driver wdt_pci
[   15.473916] initcall wdtpci_init+0x0/0x16 returned 0 after 305 usecs
[   15.474024] calling  alim7101_wdt_init+0x0/0x16b @ 1
[   15.474154] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
[   15.474297] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   15.474426] initcall alim7101_wdt_init+0x0/0x16b returned -16 after 263 usecs
[   15.474557] initcall alim7101_wdt_init+0x0/0x16b returned with error code -16 
[   15.474722] calling  ibmasr_init+0x0/0x236 @ 1
[   15.474850] initcall ibmasr_init+0x0/0x236 returned -19 after 1 usecs
[   15.474979] calling  it87_wdt_init+0x0/0x4bf @ 1
[   15.475351] IT87 WDT: no device
[   15.475455] initcall it87_wdt_init+0x0/0x4bf returned -19 after 144 usecs
[   15.475590] calling  hpwdt_init+0x0/0x16 @ 1
[   15.475721] bus: 'pci': add driver hpwdt
[   15.476103] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
[   15.476259] hub 1-0:1.0: port 8: status 0501 change 0001
[   15.476533] initcall hpwdt_init+0x0/0x16 returned 0 after 797 usecs
[   15.476642] calling  sc1200wdt_init+0x0/0x13c @ 1
[   15.476772] sc1200wdt: build 20020303
[   15.476896] bus: 'pnp': add driver scl200wdt
[   15.477178] sc1200wdt: io parameter must be specified
[   15.477301] bus: 'pnp': remove driver scl200wdt
[   15.477556] driver: 'scl200wdt': driver_release
[   15.477667] initcall sc1200wdt_init+0x0/0x13c returned -22 after 871 usecs
[   15.477802] initcall sc1200wdt_init+0x0/0x13c returned with error code -22 
[   15.477932] calling  pc87413_init+0x0/0x7e @ 1
[   15.478057] pc87413 WDT: Version 1.1 at io 0x2E
[   15.478186] device: 'watchdog': device_add
[   15.478399] PM: Adding info for No Bus:watchdog
[   15.478631] pc87413 WDT: initialized. timeout=1 min 
[   15.478877] initcall pc87413_init+0x0/0x7e returned 0 after 798 usecs
[   15.478985] calling  sbc8360_init+0x0/0x17d @ 1
[   15.479118] sbc8360: failed to register misc device
[   15.479249] initcall sbc8360_init+0x0/0x17d returned -16 after 129 usecs
[   15.479378] initcall sbc8360_init+0x0/0x17d returned with error code -16 
[   15.479509] calling  sch311x_wdt_init+0x0/0x143 @ 1
[   15.479668] initcall sch311x_wdt_init+0x0/0x143 returned -19 after 31 usecs
[   15.479798] calling  wb_smsc_wdt_init+0x0/0x18b @ 1
[   15.479924] SMsC 37B787 watchdog component driver 1.1 initialising...
[   15.481145] smsc37b787_wdt: Unable to register miscdev on minor 130
[   15.481257] initcall wb_smsc_wdt_init+0x0/0x18b returned -16 after 1299 usecs
[   15.481390] initcall wb_smsc_wdt_init+0x0/0x18b returned with error code -16 
[   15.481520] calling  wdt_init+0x0/0x1ae @ 1
[   15.481644] WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.
[   15.481864] w83627hf/thf/hg WDT: Watchdog already running. Resetting timeout to 60 sec
[   15.482090] w83627hf/thf/hg WDT: cannot register miscdev on minor=130 (err=-16)
[   15.482237] initcall wdt_init+0x0/0x1ae returned -16 after 578 usecs
[   15.482371] initcall wdt_init+0x0/0x1ae returned with error code -16 
[   15.482499] calling  wdt_init+0x0/0x1b7 @ 1
[   15.482624] w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
[   15.482752] w83697hf/hg WDT: Looking for watchdog at address 0x2e
[   15.482899] w83697hf/hg WDT: watchdog not found at address 0x2e
[   15.483027] w83697hf/hg WDT: No W83697HF/HG could be found
[   15.483155] initcall wdt_init+0x0/0x1b7 returned -5 after 516 usecs
[   15.483283] initcall wdt_init+0x0/0x1b7 returned with error code -5 
[   15.483412] calling  watchdog_init+0x0/0xa0 @ 1
[   15.483540] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   15.483672] initcall watchdog_init+0x0/0xa0 returned -16 after 129 usecs
[   15.483802] initcall watchdog_init+0x0/0xa0 returned with error code -16 
[   15.483931] calling  watchdog_init+0x0/0xa0 @ 1
[   15.484058] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   15.484188] initcall watchdog_init+0x0/0xa0 returned -16 after 127 usecs
[   15.484318] initcall watchdog_init+0x0/0xa0 returned with error code -16 
[   15.484448] calling  telephony_init+0x0/0x3f @ 1
[   15.484574] Linux telephony interface: v1.00
[   15.484706] initcall telephony_init+0x0/0x3f returned 0 after 126 usecs
[   15.484836] calling  isdn_init+0x0/0x26a @ 1
[   15.485378] ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[   15.485958] initcall isdn_init+0x0/0x26a returned 0 after 972 usecs
[   15.486087] calling  HiSax_init+0x0/0x2fe @ 1
[   15.486212] HiSax: Linux Driver for passive ISDN cards
[   15.486336] HiSax: Version 3.5 (kernel)
[   15.486460] HiSax: Layer1 Revision 2.46.2.5
[   15.486584] HiSax: Layer2 Revision 2.30.2.4
[   15.486708] HiSax: TeiMgr Revision 2.20.2.3
[   15.486833] HiSax: Layer3 Revision 2.22.2.3
[   15.486974] HiSax: LinkLayer Revision 2.59.2.4
[   15.487086] HiSax: Total 1 card defined
[   15.487283] HiSax: Card 1 Protocol EDSS1 Id=HiSax (0)
[   15.487390] HiSax: Traverse Tech. NETspider-U driver Rev. 2.14.2.3
[   15.487540] NETspider-U: No PCI card found
[   15.487768] HiSax: Card NETspider-U not installed !
[   15.487876] initcall HiSax_init+0x0/0x2fe returned -19 after 1622 usecs
[   15.488009] calling  hisax_isac_init+0x0/0x4b @ 1
[   15.488134] hisax_isac: ISAC-S/ISAC-SX ISDN driver v0.1.0
[   15.488263] initcall hisax_isac_init+0x0/0x4b returned 0 after 123 usecs
[   15.488432] calling  hisax_fcpcipnp_init+0x0/0x4c @ 1
[   15.488538] hisax_fcpcipnp: Fritz!Card PCI/PCIv2/PnP ISDN driver v0.0.1
[   15.488678] bus: 'pci': add driver fcpci
[   15.489003] hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.489013] bus: 'pnp': add driver fcpnp
[   15.489326] initcall hisax_fcpcipnp_init+0x0/0x4c returned 0 after 766 usecs
[   15.489437] calling  sc_init+0x0/0x161b @ 1
[   15.489566] SpellCaster ISA ISDN Adapter Driver rev. 2.0b1
[   15.489692] Copyright (C) 1996 SpellCaster Telecommunications Inc.
[   15.490588] Failed to find any adapters, driver unloaded
[   15.490696] initcall sc_init+0x0/0x161b returned -19 after 1101 usecs
[   15.490829] calling  cpufreq_stats_init+0x0/0x8b @ 1
[   15.490985] initcall cpufreq_stats_init+0x0/0x8b returned 0 after 27 usecs
[   15.491117] calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
[   15.491248] initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 3 usecs
[   15.491414] calling  cpufreq_gov_dbs_init+0x0/0x5d @ 1
[   15.491709] initcall cpufreq_gov_dbs_init+0x0/0x5d returned 0 after 162 usecs
[   15.491820] calling  init_ladder+0x0/0xf @ 1
[   15.493106] cpuidle: using governor ladder
[   15.493215] initcall init_ladder+0x0/0xf returned 0 after 1216 usecs
[   15.493350] calling  tifm_sd_init+0x0/0xf @ 1
[   15.493478] bus: 'tifm': add driver tifm_sd
[   15.493738] initcall tifm_sd_init+0x0/0xf returned 0 after 254 usecs
[   15.493847] calling  bd2802_init+0x0/0x11 @ 1
[   15.493979] bus: 'i2c': add driver BD2802
[   15.494243] i2c-core: driver [BD2802] registered
[   15.494354] initcall bd2802_init+0x0/0x11 returned 0 after 366 usecs
[   15.494488] calling  alix_led_init+0x0/0xcd @ 1
[   15.495350] initcall alix_led_init+0x0/0xcd returned -19 after 717 usecs
[   15.495459] calling  pca9532_init+0x0/0x11 @ 1
[   15.495591] bus: 'i2c': add driver pca9532
[   15.495871] i2c-core: driver [pca9532] registered
[   15.495981] initcall pca9532_init+0x0/0x11 returned 0 after 381 usecs
[   15.496116] calling  gpio_led_init+0x0/0xf @ 1
[   15.496260] bus: 'platform': add driver leds-gpio
[   15.496535] initcall gpio_led_init+0x0/0xf returned 0 after 285 usecs
[   15.496644] calling  timer_trig_init+0x0/0xf @ 1
[   15.496864] initcall timer_trig_init+0x0/0xf returned 0 after 85 usecs
[   15.496973] calling  dcdrbu_init+0x0/0x12c @ 1
[   15.497105] Registering platform device 'dell_rbu'. Parent at platform
[   15.497234] device: 'dell_rbu': device_add
[   15.497369] bus: 'platform': add device dell_rbu
[   15.497516] PM: Adding info for platform:dell_rbu
[   15.497806] initcall dcdrbu_init+0x0/0x12c returned 0 after 684 usecs
[   15.497915] calling  dcdbas_init+0x0/0x53 @ 1
[   15.498047] bus: 'platform': add driver dcdbas
[   15.498367] Registering platform device 'dcdbas'. Parent at platform
[   15.498476] device: 'dcdbas': device_add
[   15.498614] bus: 'platform': add device dcdbas
[   15.498760] PM: Adding info for platform:dcdbas
[   15.499790] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[   15.499937] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[   15.500155] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   15.500301] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[   15.500434] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[   15.500608] initcall dcdbas_init+0x0/0x53 returned 0 after 2500 usecs
[   15.500739] calling  hifn_init+0x0/0x9d @ 1
[   15.500871] bus: 'pci': add driver hifn795x
[   15.501210] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   15.501359] initcall hifn_init+0x0/0x9d returned 0 after 481 usecs
[   15.501492] calling  virtio_pci_init+0x0/0x5f @ 1
[   15.501621] device: 'virtio-pci': device_add
[   15.501813] PM: Adding info for No Bus:virtio-pci
[   15.501930] bus: 'pci': add driver virtio-pci
[   15.502202] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.502450] initcall virtio_pci_init+0x0/0x5f returned 0 after 810 usecs
[   15.502560] calling  flow_cache_init+0x0/0x14c @ 1
[   15.502978] initcall flow_cache_init+0x0/0x14c returned 0 after 279 usecs
[   15.503087] calling  llc_init+0x0/0x1b @ 1
[   15.503221] initcall llc_init+0x0/0x1b returned 0 after 3 usecs
[   15.503350] calling  llc2_init+0x0/0xb3 @ 1
[   15.503526] NET: Registered protocol family 26
[   15.503632] initcall llc2_init+0x0/0xb3 returned 0 after 153 usecs
[   15.503766] calling  snap_init+0x0/0x31 @ 1
[   15.503921] initcall snap_init+0x0/0x31 returned 0 after 27 usecs
[   15.504051] calling  blackhole_module_init+0x0/0xf @ 1
[   15.504180] initcall blackhole_module_init+0x0/0xf returned 0 after 2 usecs
[   15.504310] calling  cbq_module_init+0x0/0xf @ 1
[   15.504439] initcall cbq_module_init+0x0/0xf returned 0 after 1 usecs
[   15.504568] calling  sfq_module_init+0x0/0xf @ 1
[   15.504695] initcall sfq_module_init+0x0/0xf returned 0 after 1 usecs
[   15.504823] calling  atm_init+0x0/0xf @ 1
[   15.504949] initcall atm_init+0x0/0xf returned 0 after 1 usecs
[   15.505090] calling  drr_init+0x0/0xf @ 1
[   15.505221] initcall drr_init+0x0/0xf returned 0 after 1 usecs
[   15.505348] calling  init_route4+0x0/0xf @ 1
[   15.505526] initcall init_route4+0x0/0xf returned 0 after 51 usecs
[   15.505633] calling  init_rsvp+0x0/0xf @ 1
[   15.505764] initcall init_rsvp+0x0/0xf returned 0 after 1 usecs
[   15.505891] calling  init_rsvp+0x0/0xf @ 1
[   15.506018] initcall init_rsvp+0x0/0xf returned 0 after 1 usecs
[   15.506146] calling  cls_flow_init+0x0/0xf @ 1
[   15.506274] initcall cls_flow_init+0x0/0xf returned 0 after 1 usecs
[   15.506401] calling  nfnetlink_init+0x0/0x51 @ 1
[   15.506543] Netfilter messages via NETLINK v0.30.
[   15.506664] initcall nfnetlink_init+0x0/0x51 returned 0 after 133 usecs
[   15.506798] calling  nf_conntrack_standalone_init+0x0/0xf @ 1
[   15.506944] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.507707] initcall nf_conntrack_standalone_init+0x0/0xf returned 0 after 762 usecs
[   15.507854] calling  ctnetlink_init+0x0/0x62 @ 1
[   15.507985] ctnetlink v0.93: registering with nfnetlink.
[   15.508169] initcall ctnetlink_init+0x0/0x62 returned 0 after 177 usecs
[   15.508277] calling  xt_init+0x0/0x11a @ 1
[   15.508455] initcall xt_init+0x0/0x11a returned 0 after 34 usecs
[   15.508567] calling  tcpudp_mt_init+0x0/0x14 @ 1
[   15.508764] initcall tcpudp_mt_init+0x0/0x14 returned 0 after 61 usecs
[   15.508872] calling  connsecmark_tg_init+0x0/0xf @ 1
[   15.509006] initcall connsecmark_tg_init+0x0/0xf returned 0 after 2 usecs
[   15.509136] calling  mark_tg_init+0x0/0x14 @ 1
[   15.509266] initcall mark_tg_init+0x0/0x14 returned 0 after 4 usecs
[   15.509395] calling  secmark_tg_init+0x0/0xf @ 1
[   15.509541] initcall secmark_tg_init+0x0/0xf returned 0 after 18 usecs
[   15.509648] calling  tcpmss_tg_init+0x0/0x14 @ 1
[   15.509781] initcall tcpmss_tg_init+0x0/0x14 returned 0 after 3 usecs
[   15.509909] calling  conntrack_mt_init+0x0/0x14 @ 1
[   15.510039] initcall conntrack_mt_init+0x0/0x14 returned 0 after 3 usecs
[   15.510168] calling  ip_vs_init+0x0/0xa3 @ 1
[   15.510427] IPVS: Registered protocols (TCP, AH, ESP)
[   15.510595] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[   15.510740] IPVS: Each connection entry needs 200 bytes at least
[   15.510968] IPVS: ipvs loaded.
[   15.511071] initcall ip_vs_init+0x0/0xa3 returned 0 after 759 usecs
[   15.511204] calling  ip_vs_rr_init+0x0/0xf @ 1
[   15.511355] IPVS: [rr] scheduler registered.
[   15.511483] initcall ip_vs_rr_init+0x0/0xf returned 0 after 149 usecs
[   15.511612] calling  ip_vs_lc_init+0x0/0xf @ 1
[   15.511762] IPVS: [lc] scheduler registered.
[   15.511891] initcall ip_vs_lc_init+0x0/0xf returned 0 after 125 usecs
[   15.512019] calling  ip_vs_dh_init+0x0/0xf @ 1
[   15.512145] IPVS: [dh] scheduler registered.
[   15.512271] initcall ip_vs_dh_init+0x0/0xf returned 0 after 122 usecs
[   15.512399] calling  ip_vs_ftp_init+0x0/0x7a @ 1
[   15.512630] IPVS: ftp: loaded support on port[0] = 21
[   15.512737] initcall ip_vs_ftp_init+0x0/0x7a returned 0 after 207 usecs
[   15.512871] calling  sysctl_ipv4_init+0x0/0x3f @ 1
[   15.513009] initcall sysctl_ipv4_init+0x0/0x3f returned 0 after 10 usecs
[   15.513139] calling  init_syncookies+0x0/0x16 @ 1
[   15.513335] initcall init_syncookies+0x0/0x16 returned 0 after 67 usecs
[   15.513443] calling  ah4_init+0x0/0x5a @ 1
[   15.513576] initcall ah4_init+0x0/0x5a returned 0 after 4 usecs
[   15.513704] calling  xfrm4_transport_init+0x0/0x14 @ 1
[   15.513834] initcall xfrm4_transport_init+0x0/0x14 returned 0 after 2 usecs
[   15.513965] calling  ipv4_netfilter_init+0x0/0x14 @ 1
[   15.514146] initcall ipv4_netfilter_init+0x0/0x14 returned 0 after 52 usecs
[   15.514255] calling  cubictcp_register+0x0/0x93 @ 1
[   15.514386] TCP cubic registered
[   15.514512] initcall cubictcp_register+0x0/0x93 returned 0 after 122 usecs
[   15.514642] calling  xfrm_user_init+0x0/0x40 @ 1
[   15.514767] Initializing XFRM netlink socket
[   15.514950] initcall xfrm_user_init+0x0/0x40 returned 0 after 176 usecs
[   15.515070] calling  inet6_init+0x0/0x279 @ 1
[   15.515398] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.516543] NET: Registered protocol family 10
[   15.518862] initcall inet6_init+0x0/0x279 returned 0 after 3568 usecs
[   15.518972] calling  ipcomp6_init+0x0/0x5a @ 1
[   15.519125] initcall ipcomp6_init+0x0/0x5a returned 0 after 3 usecs
[   15.519233] calling  xfrm6_tunnel_init+0x0/0xdb @ 1
[   15.519441] initcall xfrm6_tunnel_init+0x0/0xdb returned 0 after 74 usecs
[   15.519551] calling  tunnel6_init+0x0/0x5a @ 1
[   15.519684] initcall tunnel6_init+0x0/0x5a returned 0 after 2 usecs
[   15.519813] calling  xfrm6_ro_init+0x0/0x14 @ 1
[   15.519942] initcall xfrm6_ro_init+0x0/0x14 returned 0 after 2 usecs
[   15.520072] calling  xfrm6_beet_init+0x0/0x14 @ 1
[   15.520200] initcall xfrm6_beet_init+0x0/0x14 returned 0 after 2 usecs
[   15.520330] calling  packet_init+0x0/0x39 @ 1
[   15.520472] NET: Registered protocol family 17
[   15.520653] initcall packet_init+0x0/0x39 returned 0 after 192 usecs
[   15.520761] calling  ipsec_pfkey_init+0x0/0x6e @ 1
[   15.520891] NET: Registered protocol family 15
[   15.521104] initcall ipsec_pfkey_init+0x0/0x6e returned 0 after 207 usecs
[   15.521213] calling  br_init+0x0/0xae @ 1
[   15.521479] initcall br_init+0x0/0xae returned 0 after 132 usecs
[   15.521586] calling  dsa_init_module+0x0/0x11 @ 1
[   15.521744] initcall dsa_init_module+0x0/0x11 returned 0 after 2 usecs
[   15.521876] calling  edsa_init_module+0x0/0x11 @ 1
[   15.522022] initcall edsa_init_module+0x0/0x11 returned 0 after 18 usecs
[   15.522130] calling  trailer_init_module+0x0/0x11 @ 1
[   15.522263] initcall trailer_init_module+0x0/0x11 returned 0 after 1 usecs
[   15.522393] calling  mv88e6060_init+0x0/0x11 @ 1
[   15.522574] initcall mv88e6060_init+0x0/0x11 returned 0 after 52 usecs
[   15.522682] calling  mv88e6123_61_65_init+0x0/0x11 @ 1
[   15.522815] initcall mv88e6123_61_65_init+0x0/0x11 returned 0 after 2 usecs
[   15.522945] calling  mv88e6131_init+0x0/0x11 @ 1
[   15.523074] initcall mv88e6131_init+0x0/0x11 returned 0 after 2 usecs
[   15.523203] calling  dsa_init_module+0x0/0xf @ 1
[   15.523331] bus: 'platform': add driver dsa
[   15.523563] uhci_hcd 0000:00:1d.3: port 2 portsc 008a,00
[   15.523759] initcall dsa_init_module+0x0/0xf returned 0 after 419 usecs
[   15.523869] calling  lapb_init+0x0/0x7 @ 1
[   15.524017] initcall lapb_init+0x0/0x7 returned 0 after 1 usecs
[   15.524124] calling  econet_proto_init+0x0/0x190 @ 1
[   15.524255] NET: Registered protocol family 19
[   15.524592] initcall econet_proto_init+0x0/0x190 returned 0 after 328 usecs
[   15.524702] calling  vlan_proto_init+0x0/0xa7 @ 1
[   15.524832] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   15.524961] All bugs added by David S. Miller <davem@redhat.com>
[   15.526090] initcall vlan_proto_init+0x0/0xa7 returned 0 after 1226 usecs
[   15.526199] calling  sctp_init+0x0/0x6ee @ 1
[   15.546396] SCTP: Hash tables configured (established 65536 bind 65536)
[   15.572234] sctp_init_sock(sk: be158000)
[   15.572486] initcall sctp_init+0x0/0x6ee returned 0 after 45067 usecs
[   15.572596] calling  lib80211_init+0x0/0x19 @ 1
[   15.572727] lib80211: common routines for IEEE802.11 drivers
[   15.572899] lib80211_crypt: registered algorithm 'NULL'
[   15.573007] initcall lib80211_init+0x0/0x19 returned 0 after 272 usecs
[   15.573140] calling  lib80211_crypto_wep_init+0x0/0xf @ 1
[   15.573267] lib80211_crypt: registered algorithm 'WEP'
[   15.573395] initcall lib80211_crypto_wep_init+0x0/0xf returned 0 after 123 usecs
[   15.573561] calling  lib80211_crypto_ccmp_init+0x0/0xf @ 1
[   15.573688] lib80211_crypt: registered algorithm 'CCMP'
[   15.573817] initcall lib80211_crypto_ccmp_init+0x0/0xf returned 0 after 124 usecs
[   15.573983] calling  lib80211_crypto_tkip_init+0x0/0xf @ 1
[   15.574111] lib80211_crypt: registered algorithm 'TKIP'
[   15.574240] initcall lib80211_crypto_tkip_init+0x0/0xf returned 0 after 124 usecs
[   15.574407] calling  acpi_cpufreq_init+0x0/0xc6 @ 1
[   15.575777] hub 1-0:1.0: state 7 ports 8 chg 0100 evt 0000
[   15.575915] hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[   15.580939] initcall acpi_cpufreq_init+0x0/0xc6 returned 0 after 6253 usecs
[   15.581050] calling  powernow_init+0x0/0x114 @ 1
[   15.581293] initcall powernow_init+0x0/0x114 returned -19 after 1 usecs
[   15.582198] calling  longhaul_init+0x0/0x77 @ 1
[   15.582330] initcall longhaul_init+0x0/0x77 returned -19 after 1 usecs
[   15.582460] calling  cpufreq_p4_init+0x0/0x4f @ 1
[   15.582588] initcall cpufreq_p4_init+0x0/0x4f returned -16 after 2 usecs
[   15.582718] initcall cpufreq_p4_init+0x0/0x4f returned with error code -16 
[   15.582847] calling  hpet_insert_resource+0x0/0x1e @ 1
[   15.582981] initcall hpet_insert_resource+0x0/0x1e returned 0 after 5 usecs
[   15.583111] calling  update_mp_table+0x0/0x38d @ 1
[   15.583239] initcall update_mp_table+0x0/0x38d returned 0 after 1 usecs
[   15.583368] calling  lapic_insert_resource+0x0/0x33 @ 1
[   15.583498] initcall lapic_insert_resource+0x0/0x33 returned 0 after 2 usecs
[   15.583629] calling  print_ipi_mode+0x0/0x25 @ 1
[   15.583771] Using IPI No-Shortcut mode
[   15.583875] initcall print_ipi_mode+0x0/0x25 returned 0 after 116 usecs
[   15.584010] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[   15.584139] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 1 usecs
[   15.584270] calling  ioapic_insert_resources+0x0/0x4b @ 1
[   15.584401] initcall ioapic_insert_resources+0x0/0x4b returned 0 after 2 usecs
[   15.584567] calling  io_apic_bug_finalize+0x0/0x1a @ 1
[   15.584696] initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 1 usecs
[   15.584826] calling  check_early_ioremap_leak+0x0/0x47 @ 1
[   15.584956] initcall check_early_ioremap_leak+0x0/0x47 returned 0 after 1 usecs
[   15.585173] calling  pat_memtype_list_init+0x0/0x23 @ 1
[   15.585298] initcall pat_memtype_list_init+0x0/0x23 returned 0 after 16 usecs
[   15.585433] calling  sched_init_debug+0x0/0x1f @ 1
[   15.585572] initcall sched_init_debug+0x0/0x1f returned 0 after 11 usecs
[   15.585720] calling  init_oops_id+0x0/0x3f @ 1
[   15.585833] initcall init_oops_id+0x0/0x3f returned 0 after 8 usecs
[   15.585966] calling  disable_boot_consoles+0x0/0x36 @ 1
[   15.586094] initcall disable_boot_consoles+0x0/0x36 returned 0 after 1 usecs
[   15.586224] calling  pm_qos_power_init+0x0/0x54 @ 1
[   15.586377] device: 'cpu_dma_latency': device_add
[   15.586661] PM: Adding info for No Bus:cpu_dma_latency
[   15.586926] device: 'network_latency': device_add
[   15.587078] PM: Adding info for No Bus:network_latency
[   15.587357] device: 'network_throughput': device_add
[   15.587540] PM: Adding info for No Bus:network_throughput
[   15.587788] initcall pm_qos_power_init+0x0/0x54 returned 0 after 1402 usecs
[   15.587898] calling  software_resume+0x0/0x1eb @ 1
[   15.588078] PM: Resume from disk failed.
[   15.588183] initcall software_resume+0x0/0x1eb returned -2 after 148 usecs
[   15.588317] initcall software_resume+0x0/0x1eb returned with error code -2 
[   15.588463] calling  clear_boot_tracer+0x0/0x27 @ 1
[   15.588613] initcall clear_boot_tracer+0x0/0x27 returned 0 after 1 usecs
[   15.588722] calling  max_swapfiles_check+0x0/0x7 @ 1
[   15.588854] initcall max_swapfiles_check+0x0/0x7 returned 0 after 1 usecs
[   15.588983] calling  failslab_debugfs_init+0x0/0x58 @ 1
[   15.589268] initcall failslab_debugfs_init+0x0/0x58 returned 0 after 153 usecs
[   15.589413] calling  init_ima+0x0/0x19 @ 1
[   15.589793] No TPM chip found, activating TPM-bypass!
[   15.590039] initcall init_ima+0x0/0x19 returned 0 after 482 usecs
[   15.590148] calling  random32_reseed+0x0/0x7d @ 1
[   15.590320] initcall random32_reseed+0x0/0x7d returned 0 after 37 usecs
[   15.590429] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   15.590571] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 6 usecs
[   15.590738] calling  pci_sysfs_init+0x0/0x44 @ 1
[   15.591173] initcall pci_sysfs_init+0x0/0x44 returned 0 after 299 usecs
[   15.591282] calling  seqgen_init+0x0/0xe @ 1
[   15.591441] initcall seqgen_init+0x0/0xe returned 0 after 25 usecs
[   15.591572] calling  late_resume_init+0x0/0xc7 @ 1
[   15.591711]   Magic number: 13:746:455
[   15.592012] initcall late_resume_init+0x0/0xc7 returned 0 after 293 usecs
[   15.592124] calling  scsi_complete_async_scans+0x0/0x125 @ 1
[   15.592260] initcall scsi_complete_async_scans+0x0/0x125 returned 0 after 1 usecs
[   15.592427] calling  memmap_init+0x0/0x8e @ 1
[   15.592770] initcall memmap_init+0x0/0x8e returned 0 after 211 usecs
[   15.592878] calling  tcp_congestion_default+0x0/0xf @ 1
[   15.593015] initcall tcp_congestion_default+0x0/0xf returned 0 after 2 usecs
[   15.593146] calling  ip_auto_config+0x0/0xbc0 @ 1
[   15.593308] initcall ip_auto_config+0x0/0xbc0 returned 0 after 33 usecs
[   15.593415] calling  initialize_hashrnd+0x0/0x16 @ 1
[   15.593556] initcall initialize_hashrnd+0x0/0x16 returned 0 after 7 usecs
[   15.593718] async_waiting @ 1
[   15.593818] async_continuing @ 1 after 2 usec
[   15.628650] ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
[   15.628784] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
[   15.628971] hub 1-0:1.0: port 8 not reset yet, waiting 50ms
[   15.637020] kjournald starting.  Commit interval 5 seconds
[   15.637367] EXT3-fs: mounted filesystem with ordered data mode.
[   15.637682] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[   15.637855] async_waiting @ 1
[   15.637956] async_continuing @ 1 after 1 usec
[   15.638082] debug: unmapping init memory 41b2d000..41bb3000
[   15.638417] Write protecting the kernel text: 7032k
[   15.638590] Write protecting the kernel read-only data: 3560k
[   15.681731] ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
[   15.682135] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   15.682241] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
[   15.698489] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   15.698607] uhci_hcd 0000:00:1d.3: port 2 portsc 0093,00
[   15.698760] hub 5-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   15.763940] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
[   15.818403] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   15.925071] usb 5-2: new full speed USB device using uhci_hcd and address 2
[   16.051710] usb 5-2: ep0 maxpacket = 8
[   16.074062] usb 5-2: default language 0x0409
[   16.093013] usb 5-2: New USB device found, idVendor=0483, idProduct=2016
[   16.093143] usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   16.093309] usb 5-2: Product: Biometric Coprocessor
[   16.093447] usb 5-2: Manufacturer: STMicroelectronics
[   16.093570] device: '5-2': device_add
[   16.093889] bus: 'usb': add device 5-2
[   16.094016] PM: Adding info for usb:5-2
[   16.094184] usb 5-2: uevent
[   16.094628] bus: 'usb': driver_probe_device: matched device 5-2 with driver usb
[   16.094772] bus: 'usb': really_probe: probing driver usb with device 5-2
[   16.095255] usb 5-2: usb_probe_device
[   16.095357] usb 5-2: configuration #1 chosen from 1 choice
[   16.098014] usb 5-2: adding 5-2:1.0 (config #1, interface 0)
[   16.098146] device: '5-2:1.0': device_add
[   16.098423] bus: 'usb': add device 5-2:1.0
[   16.098610] PM: Adding info for usb:5-2:1.0
[   16.098720] usb 5-2:1.0: uevent
[   16.099045] device: 'usbdev5.2_ep81': device_add
[   16.099273] PM: Adding info for No Bus:usbdev5.2_ep81
[   16.099530] device: 'usbdev5.2_ep02': device_add
[   16.099734] PM: Adding info for No Bus:usbdev5.2_ep02
[   16.099995] device: 'usbdev5.2_ep83': device_add
[   16.100200] PM: Adding info for No Bus:usbdev5.2_ep83
[   16.100456] drivers/usb/core/inode.c: creating file '002'
[   16.100601] driver: '5-2': driver_bound: bound to device 'usb'
[   16.100734] bus: 'usb': really_probe: bound device 5-2 to driver usb
[   16.100870] device: 'usbdev5.2_ep00': device_add
[   16.101104] PM: Adding info for No Bus:usbdev5.2_ep00
[   16.101363] hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   16.448359] usb usb2: suspend_rh (auto-stop)
[   16.448542] usb usb3: suspend_rh (auto-stop)
[   16.448708] usb usb4: suspend_rh (auto-stop)
[   26.198354] eth0: no IPv6 routers present
[   32.482417] device: 'device:00': dev_uevent: bus uevent() returned -12
[   32.482819] device: 'device:01': dev_uevent: bus uevent() returned -12
[   32.484203] device: 'device:03': dev_uevent: bus uevent() returned -12
[   32.484415] device: 'device:04': dev_uevent: bus uevent() returned -12
[   32.484619] device: 'device:05': dev_uevent: bus uevent() returned -12
[   32.484822] device: 'device:06': dev_uevent: bus uevent() returned -12
[   32.485131] device: 'device:08': dev_uevent: bus uevent() returned -12
[   32.485325] device: 'device:09': dev_uevent: bus uevent() returned -12
[   32.485508] device: 'device:0a': dev_uevent: bus uevent() returned -12
[   32.485703] device: 'device:0b': dev_uevent: bus uevent() returned -12
[   32.485903] device: 'device:0c': dev_uevent: bus uevent() returned -12
[   32.486101] device: 'device:0d': dev_uevent: bus uevent() returned -12
[   32.486311] device: 'device:0e': dev_uevent: bus uevent() returned -12
[   32.486510] device: 'device:0f': dev_uevent: bus uevent() returned -12
[   32.486717] device: 'device:10': dev_uevent: bus uevent() returned -12
[   32.486924] device: 'device:11': dev_uevent: bus uevent() returned -12
[   32.487134] device: 'device:12': dev_uevent: bus uevent() returned -12
[   32.487290] device: 'device:13': dev_uevent: bus uevent() returned -12
[   32.487497] device: 'device:14': dev_uevent: bus uevent() returned -12
[   32.487774] device: 'device:16': dev_uevent: bus uevent() returned -12
[   32.487973] device: 'device:17': dev_uevent: bus uevent() returned -12
[   32.488174] device: 'device:18': dev_uevent: bus uevent() returned -12
[   32.489844] device: 'device:19': dev_uevent: bus uevent() returned -12
[   32.490068] device: 'device:1a': dev_uevent: bus uevent() returned -12
[   32.490272] device: 'device:1b': dev_uevent: bus uevent() returned -12
[   32.490481] device: 'device:1c': dev_uevent: bus uevent() returned -12
[   32.490690] device: 'device:1d': dev_uevent: bus uevent() returned -12
[   32.490906] device: 'device:1e': dev_uevent: bus uevent() returned -12
[   32.491094] device: 'device:1f': dev_uevent: bus uevent() returned -12
[   32.491275] device: 'device:20': dev_uevent: bus uevent() returned -12
[   32.491478] device: 'device:21': dev_uevent: bus uevent() returned -12
[   32.491697] device: 'device:22': dev_uevent: bus uevent() returned -12
[   32.491902] device: 'device:23': dev_uevent: bus uevent() returned -12
[   32.492108] device: 'device:24': dev_uevent: bus uevent() returned -12
[   32.492307] device: 'device:25': dev_uevent: bus uevent() returned -12
[   32.496116] usb usb2: uevent
[   32.496374] usb 2-0:1.0: uevent
[   32.496655] usb usb3: uevent
[   32.497651] usb 3-0:1.0: uevent
[   32.497929] usb usb4: uevent
[   32.498121] usb 4-0:1.0: uevent
[   32.498416] usb usb5: uevent
[   32.498625] usb 5-0:1.0: uevent
[   32.498832] usb 5-2: uevent
[   32.499046] usb 5-2:1.0: uevent
[   32.499322] usb usb1: uevent
[   32.499535] usb 1-0:1.0: uevent
[   32.818273] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
[   32.821426] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
[   32.823203] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
[   32.824469] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
[   32.826215] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
[   41.954069] EXT3 FS on sda1, internal journal
[   46.804203] Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k 
[   54.819413] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
[   55.216665] 
[   55.216668] =======================================================
[   55.216963] [ INFO: possible circular locking dependency detected ]
[   55.217134] 2.6.30-tip #5836
[   55.217276] -------------------------------------------------------
[   55.217428] S99local/4262 is trying to acquire lock:
[   55.217577]  (&(&dbs_info->work)->work){+.+...}, at: [<4104261f>] __cancel_work_timer+0xb8/0x1e9
[   55.218065] 
[   55.218068] but task is already holding lock:
[   55.218351]  (dbs_mutex){+.+.+.}, at: [<4157bd6b>] cpufreq_governor_dbs+0x25d/0x2e4
[   55.218358] 
[   55.218358] which lock already depends on the new lock.
[   55.218358] 
[   55.218358] 
[   55.218358] the existing dependency chain (in reverse order) is:
[   55.218358] 
[   55.218358] -> #2 (dbs_mutex){+.+.+.}:
[   55.218358]        [<41053244>] __lock_acquire+0xd34/0xf96
[   55.218358]        [<41053541>] lock_acquire+0x9b/0xbe
[   55.218358]        [<416dae04>] mutex_lock_nested+0x3f/0x258
[   55.218358]        [<4157bb89>] cpufreq_governor_dbs+0x7b/0x2e4
[   55.218358]        [<4157934b>] __cpufreq_governor+0x6a/0x74
[   55.218358]        [<415794af>] __cpufreq_set_policy+0x15a/0x1c8
[   55.218358]        [<415799d2>] store_scaling_governor+0x15e/0x18d
[   55.218358]        [<4157a6e1>] store+0x47/0x60
[   55.218358]        [<410e7efe>] sysfs_write_file+0xba/0xe5
[   55.218358]        [<410ada48>] vfs_write+0xc5/0x13c
[   55.218358]        [<410adf89>] sys_write+0x41/0x7c
[   55.218358]        [<41003517>] sysenter_do_call+0x12/0x3c
[   55.218358]        [<ffffffff>] 0xffffffff
[   55.218358] 
[   55.218358] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[   55.218358]        [<41053244>] __lock_acquire+0xd34/0xf96
[   55.218358]        [<41053541>] lock_acquire+0x9b/0xbe
[   55.218358]        [<416db907>] down_write+0x2f/0x4b
[   55.218358]        [<41579dff>] lock_policy_rwsem_write+0x2f/0x6a
[   55.218358]        [<4157b89e>] do_dbs_timer+0x4a/0x2ba
[   55.218358]        [<410430d7>] worker_thread+0x17f/0x26f
[   55.218358]        [<410460c2>] kthread+0x4a/0x70
[   55.218358]        [<41004157>] kernel_thread_helper+0x7/0x10
[   55.218358]        [<ffffffff>] 0xffffffff
[   55.218358] 
[   55.218358] -> #0 (&(&dbs_info->work)->work){+.+...}:
[   55.218358]        [<41053050>] __lock_acquire+0xb40/0xf96
[   55.218358]        [<41053541>] lock_acquire+0x9b/0xbe
[   55.218358]        [<41042636>] __cancel_work_timer+0xcf/0x1e9
[   55.218358]        [<41042760>] cancel_delayed_work_sync+0x10/0x12
[   55.218358]        [<4157bd7c>] cpufreq_governor_dbs+0x26e/0x2e4
[   55.218358]        [<4157934b>] __cpufreq_governor+0x6a/0x74
[   55.218358]        [<41579499>] __cpufreq_set_policy+0x144/0x1c8
[   55.218358]        [<415799d2>] store_scaling_governor+0x15e/0x18d
[   55.218358]        [<4157a6e1>] store+0x47/0x60
[   55.218358]        [<410e7efe>] sysfs_write_file+0xba/0xe5
[   55.218358]        [<410ada48>] vfs_write+0xc5/0x13c
[   55.218358]        [<410adf89>] sys_write+0x41/0x7c
[   55.218358]        [<41003517>] sysenter_do_call+0x12/0x3c
[   55.218358]        [<ffffffff>] 0xffffffff
[   55.218358] 
[   55.218358] other info that might help us debug this:
[   55.218358] 
[   55.218358] 3 locks held by S99local/4262:
[   55.218358]  #0:  (&buffer->mutex){+.+.+.}, at: [<410e7e6d>] sysfs_write_file+0x29/0xe5
[   55.218358]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<41579dff>] lock_policy_rwsem_write+0x2f/0x6a
[   55.218358]  #2:  (dbs_mutex){+.+.+.}, at: [<4157bd6b>] cpufreq_governor_dbs+0x25d/0x2e4
[   55.218358] 
[   55.218358] stack backtrace:
[   55.218358] Pid: 4262, comm: S99local Not tainted 2.6.30-tip #5836
[   55.218358] Call Trace:
[   55.218358]  [<41051de8>] print_circular_bug_tail+0x84/0x8f
[   55.218358]  [<41053050>] __lock_acquire+0xb40/0xf96
[   55.218358]  [<41051147>] ? mark_held_locks+0x39/0x51
[   55.218358]  [<41053541>] lock_acquire+0x9b/0xbe
[   55.218358]  [<4104261f>] ? __cancel_work_timer+0xb8/0x1e9
[   55.218358]  [<41042636>] __cancel_work_timer+0xcf/0x1e9
[   55.218358]  [<4104261f>] ? __cancel_work_timer+0xb8/0x1e9
[   55.218358]  [<416db004>] ? mutex_lock_nested+0x23f/0x258
[   55.218358]  [<4104f989>] ? debug_mutex_free_waiter+0x25/0x40
[   55.218358]  [<416db015>] ? mutex_lock_nested+0x250/0x258
[   55.218358]  [<41042760>] cancel_delayed_work_sync+0x10/0x12
[   55.218358]  [<4157bd7c>] cpufreq_governor_dbs+0x26e/0x2e4
[   55.218358]  [<41049311>] ? up_read+0x1b/0x2e
[   55.218358]  [<4157934b>] __cpufreq_governor+0x6a/0x74
[   55.236003]  [<41579499>] __cpufreq_set_policy+0x144/0x1c8
[   55.236003]  [<41579874>] ? store_scaling_governor+0x0/0x18d
[   55.236003]  [<415799d2>] store_scaling_governor+0x15e/0x18d
[   55.236003]  [<41579f76>] ? handle_update+0x0/0x2d
[   55.236003]  [<41579e1e>] ? lock_policy_rwsem_write+0x4e/0x6a
[   55.236003]  [<41579874>] ? store_scaling_governor+0x0/0x18d
[   55.236003]  [<4157a6e1>] store+0x47/0x60
[   55.236003]  [<410e7efe>] sysfs_write_file+0xba/0xe5
[   55.236003]  [<410e7e44>] ? sysfs_write_file+0x0/0xe5
[   55.236003]  [<410ada48>] vfs_write+0xc5/0x13c
[   55.236003]  [<410adf89>] sys_write+0x41/0x7c
[   55.236003]  [<41003517>] sysenter_do_call+0x12/0x3c
[   55.621965] device: 'vcs4': device_add
[   55.622100] PM: Adding info for No Bus:vcs4
[   55.622125] device: 'vcsa4': device_add
[   55.622161] PM: Adding info for No Bus:vcsa4
[   55.685428] device: 'vcs5': device_add
[   55.685563] PM: Adding info for No Bus:vcs5
[   55.685589] device: 'vcsa5': device_add
[   55.685625] PM: Adding info for No Bus:vcsa5
[   55.686095] device: 'vcs8': device_add
[   55.686135] PM: Adding info for No Bus:vcs8
[   55.686154] device: 'vcsa8': device_add
[   55.686190] PM: Adding info for No Bus:vcsa8
[   55.690196] device: 'vcs6': device_add
[   55.690290] PM: Adding info for No Bus:vcs6
[   55.690314] device: 'vcsa6': device_add
[   55.690351] PM: Adding info for No Bus:vcsa6
[   55.690875] device: 'vcs9': device_add
[   55.690914] PM: Adding info for No Bus:vcs9
[   55.690931] device: 'vcsa9': device_add
[   55.690967] PM: Adding info for No Bus:vcsa9
[   55.691470] device: 'vcs2': device_add
[   55.691515] PM: Adding info for No Bus:vcs2
[   55.691535] device: 'vcsa2': device_add
[   55.691572] PM: Adding info for No Bus:vcsa2
[   55.692086] device: 'vcs3': device_add
[   55.692127] PM: Adding info for No Bus:vcs3
[   55.692145] device: 'vcsa3': device_add
[   55.692181] PM: Adding info for No Bus:vcsa3
[   55.692691] device: 'vcs11': device_add
[   55.692729] PM: Adding info for No Bus:vcs11
[   55.692747] device: 'vcsa11': device_add
[   55.692783] PM: Adding info for No Bus:vcsa11
[   55.693324] device: 'vcs10': device_add
[   55.693369] PM: Adding info for No Bus:vcs10
[   55.693389] device: 'vcsa10': device_add
[   55.693429] PM: Adding info for No Bus:vcsa10
[   55.694110] device: 'vcs7': device_add
[   55.694161] PM: Adding info for No Bus:vcs7
[   55.694178] device: 'vcsa7': device_add
[   55.694215] PM: Adding info for No Bus:vcsa7
[   57.105018] Clocksource tsc unstable (delta = -140781346 ns)
[ 6681.137315] Not activating Mandatory Access Control now since /sbin/tomoyo-init doesn't exist.
