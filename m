Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZINHRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZINHRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZINHRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:17:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36636 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbZINHRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:17:25 -0400
Date: Mon, 14 Sep 2009 09:16:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [origin tree SLAB corruption] BUG kmalloc-64: Poison overwritten,
	INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
Message-ID: <20090914071631.GA24801@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
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


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


* Eric Paris <eparis@redhat.com> wrote:

> On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:
> > James - i did not see a security pull request email from you in my 
> > lkml folder so i created this new thread. -tip testing found the 
> > easy crash below. It reverts cleanly so i went that easy route.
> > 
> > At a really quick 10-seconds glance the crash happens because we 
> > destroy the slab cache twice, if the sysctl is toggled twice?
> 
> Something a lot worse than SELinux here.  I added this exact code and
> got this warning.  Something is wrong in the world of
> kmem_cache_destroy.....

-tip testing just triggered another type of SLAB problem (this time 
not apparently related to the security subsystem):

BUG kmalloc-64: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00

Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a «....'ÿÿZZZZZZZZ
  Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .ó.ô`<.Ákkkkkkkk
  Object 0xf498f6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf498f6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xf498f6d0:  bb bb bb bb                                     »»»»            
 Padding 0xf498f6f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 3514, comm: sync Not tainted 2.6.31-tip-02343-gb432421-dirty #14071
Call Trace:
 [<c10e5b29>] print_trailer+0xf9/0x170
 [<c10e5c95>] check_bytes_and_report+0xf5/0x120
 [<c10e7129>] check_object+0x1e9/0x230
 [<c10e848d>] alloc_debug_processing+0xfd/0x1d0
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c10e8687>] __slab_alloc+0x127/0x330
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c10e8a43>] kmem_cache_alloc+0x1b3/0x1d0
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c11148a4>] ? bdi_writeback_all+0x34/0x190
 [<c111394b>] bdi_alloc_work+0x2b/0x100
 [<c194c6b2>] ? _spin_lock+0x72/0x90
 [<c11148e2>] bdi_writeback_all+0x72/0x190
 [<c107b3db>] ? mark_held_locks+0x6b/0xb0
 [<c194ab75>] ? __mutex_unlock_slowpath+0xf5/0x160
 [<c107b76c>] ? trace_hardirqs_on_caller+0x15c/0x1c0
 [<c1114a48>] sync_inodes_sb+0x48/0x70
 [<c1118b0b>] __sync_filesystem+0x7b/0x90
 [<c1118c13>] sync_filesystems+0xf3/0x140
 [<c1118cd7>] sys_sync+0x27/0x60
 [<c100344b>] sysenter_do_call+0x12/0x36
FIX kmalloc-64: Restoring 0xf498f6a0-0xf498f6a7=0x6b

Now, this might be an extended arm of the security related slab 
troubles. (which seem to have been cured by the revert i posted 
though.)

This bug is not bisectable at all - it happened after 1000+ 
successful random bootups. The mainline base for 
2.6.31-tip-02343-gb432421 is upstream commit 86d7101.

Full bootlog and config attached.

	Ingo


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="boot.log"
Content-Transfer-Encoding: 8bit

Linux version 2.6.31-tip-02343-gb432421-dirty (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #14071 SMP PREEMPT Mon Sep 14 08:52:33 CEST 2009
console [earlyser0] enabled
debug: ignoring loglevel setting.
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
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Warning only 893MB will be used.
Use a HIGHMEM enabled kernel.
initial memory mapped : 0 - 02800000
init_memory_mapping: 0000000000000000-0000000037d56000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037c00000 page 2M
 0037c00000 - 0037d56000 page 4k
kernel direct mapping tables up to 37d56000 @ 10000-16000
893MB LOWMEM available.
  mapped low ram: 0 - 37d56000
  low ram: 0 - 37d56000
  node 0 low ram: 00000000 - 37d56000
  node 0 bootmap 00012000 - 00018fac
(8 early reservations) ==> bootmem [0000000000 - 0037d56000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0001000000 - 00025f8864]    TEXT DATA BSS ==> [0001000000 - 00025f8864]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [00025f9000 - 0002603149]              BRK ==> [00025f9000 - 0002603149]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5680] f5680
  mpc: f1400-f152c
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x00037d56
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x00037d56
On node 0 totalpages: 228581
free_area_init_node: node 0, pgdat c1c7c540, node_mem_map c26043c0
  DMA zone: 60 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3923 pages, LIFO batch:0
  Normal zone: 3291 pages used for memmap
  Normal zone: 221307 pages, LIFO batch:31
Using APIC driver default
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
  mpc: f1400-f152c
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is PCI   
Bus #6 is ISA   
I/O APIC #2 Version 17 at 0xFEC00000.
Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 2
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
nr_irqs_gsi: 24
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 335 pages at c3330000, static data 1350908 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 225230
Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep console=tty debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
debug: sysrq always enabled.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Memory: 874676k/914776k available (9547k kernel code, 39508k reserved, 3306k data, 1976k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffd58000 - 0xfffff000   (2716 kB)
    vmalloc : 0xf8556000 - 0xffd56000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7d56000   ( 893 MB)
      .init : 0xc1c8e000 - 0xc1e7c000   (1976 kB)
      .data : 0xc1952e60 - 0xc1c8d788   (3306 kB)
      .text : 0xc1000000 - 0xc1952e60   (9547 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Experimental preemptable hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:2304 nr_irqs:424
CPU 0 irqstacks, hard=c3330000 soft=c3331000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3823 kB
 per task-struct memory footprint: 1920 bytes
ODEBUG: 9 of 9 active objects replaced
ODEBUG: selftest passed
Fast TSC calibration using PIT
Detected 2010.374 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4022.27 BogoMIPS (lpj=6701246)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys debug
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 24k freed
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 2-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256355
..... delta 1256355
..... mult: 53963554
..... calibration result: 670056
..... CPU clock speed is 2010.1229 MHz.
..... host bus clock speed is 201.0123 MHz.
... verify APIC timer
... jiffies delta = 30
... jiffies result ok
calling  migration_init+0x0/0x69 @ 1
initcall migration_init+0x0/0x69 returned 0 after 3255 usecs
calling  spawn_ksoftirqd+0x0/0x69 @ 1
initcall spawn_ksoftirqd+0x0/0x69 returned 0 after 0 usecs
calling  init_call_single_data+0x0/0xb2 @ 1
initcall init_call_single_data+0x0/0xb2 returned 0 after 0 usecs
calling  relay_init+0x0/0x31 @ 1
initcall relay_init+0x0/0x31 returned 0 after 0 usecs
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=c347f000 soft=c3480000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4021.85 BogoMIPS (lpj=6700565)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (8044.13 BogoMIPS).
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
device: 'platform': device_add
khelper used greatest stack depth: 2336 bytes left
bus: 'platform': registered
Registering sysdev class 'cpu'
calling  init_mmap_min_addr+0x0/0x50 @ 1
initcall init_mmap_min_addr+0x0/0x50 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x37 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x37 returned 0 after 0 usecs
calling  net_ns_init+0x0/0x118 @ 1
initcall net_ns_init+0x0/0x118 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x25 @ 1
initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x30 @ 1
initcall pci_reboot_init+0x0/0x30 returned 0 after 0 usecs
calling  reboot_init+0x0/0x35 @ 1
initcall reboot_init+0x0/0x35 returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x50 @ 1
initcall init_smp_flush+0x0/0x50 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x35 @ 1
initcall sysctl_init+0x0/0x35 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0xc0 @ 1
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 usecs
calling  async_init+0x0/0x70 @ 1
initcall async_init+0x0/0x70 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0x34 @ 1
initcall init_jiffies_clocksource+0x0/0x34 returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x40 @ 1
initcall init_hw_breakpoint+0x0/0x40 returned 0 after 0 usecs
calling  filelock_init+0x0/0x4b @ 1
initcall filelock_init+0x0/0x4b returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x40 @ 1
initcall init_script_binfmt+0x0/0x40 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x40 @ 1
initcall init_elf_binfmt+0x0/0x40 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x7b @ 1
initcall debugfs_init+0x0/0x7b returned 0 after 0 usecs
calling  securityfs_init+0x0/0x70 @ 1
initcall securityfs_init+0x0/0x70 returned 0 after 0 usecs
calling  random32_init+0x0/0xcf @ 1
initcall random32_init+0x0/0xcf returned 0 after 0 usecs
calling  regulator_init+0x0/0x4d @ 1
regulator: core version 0.5
device class 'regulator': registering
initcall regulator_init+0x0/0x4d returned 0 after 6510 usecs
calling  cpufreq_core_init+0x0/0x79 @ 1
initcall cpufreq_core_init+0x0/0x79 returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x54 @ 1
initcall cpuidle_init+0x0/0x54 returned 0 after 0 usecs
calling  virtio_init+0x0/0x50 @ 1
bus: 'virtio': registered
initcall virtio_init+0x0/0x50 returned 0 after 3255 usecs
calling  sock_init+0x0/0x80 @ 1
initcall sock_init+0x0/0x80 returned 0 after 3255 usecs
calling  net_inuse_init+0x0/0x45 @ 1
initcall net_inuse_init+0x0/0x45 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x58 @ 1
initcall netpoll_init+0x0/0x58 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x145 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x145 returned 0 after 3255 usecs
calling  olpc_init+0x0/0x145 @ 1
initcall olpc_init+0x0/0x145 returned 0 after 0 usecs
calling  bdi_class_init+0x0/0x52 @ 1
device class 'bdi': registering
initcall bdi_class_init+0x0/0x52 returned 0 after 3255 usecs
calling  kobject_uevent_init+0x0/0x7c @ 1
initcall kobject_uevent_init+0x0/0x7c returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x3b @ 1
device class 'pci_bus': registering
initcall pcibus_class_init+0x0/0x3b returned 0 after 3255 usecs
calling  pci_driver_init+0x0/0x40 @ 1
bus: 'pci': registered
initcall pci_driver_init+0x0/0x40 returned 0 after 3255 usecs
calling  backlight_class_init+0x0/0x70 @ 1
device class 'backlight': registering
initcall backlight_class_init+0x0/0x70 returned 0 after 6510 usecs
calling  video_output_class_init+0x0/0x40 @ 1
device class 'video_output': registering
initcall video_output_class_init+0x0/0x40 returned 0 after 3255 usecs
calling  tty_class_init+0x0/0x45 @ 1
device class 'tty': registering
initcall tty_class_init+0x0/0x45 returned 0 after 3255 usecs
calling  vtconsole_class_init+0x0/0xed @ 1
device class 'vtconsole': registering
device: 'vtcon0': device_add
initcall vtconsole_class_init+0x0/0xed returned 0 after 9765 usecs
calling  i2c_init+0x0/0x84 @ 1
bus: 'i2c': registered
device class 'i2c-adapter': registering
bus: 'i2c': add driver dummy
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x84 returned 0 after 13020 usecs
calling  eisa_init+0x0/0x49 @ 1
bus: 'eisa': registered
EISA bus registered
initcall eisa_init+0x0/0x49 returned 0 after 6510 usecs
calling  amd_postcore_init+0x0/0xcb @ 1
initcall amd_postcore_init+0x0/0xcb returned 0 after 0 usecs
calling  arch_kdebugfs_init+0x0/0x53 @ 1
initcall arch_kdebugfs_init+0x0/0x53 returned 0 after 0 usecs
calling  init_pit_clocksource+0x0/0xc6 @ 1
initcall init_pit_clocksource+0x0/0xc6 returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x80 @ 1
initcall mtrr_if_init+0x0/0x80 returned 0 after 3255 usecs
calling  dma_bus_init+0x0/0x58 @ 1
device class 'dma': registering
initcall dma_bus_init+0x0/0x58 returned 0 after 3255 usecs
calling  dma_channel_table_init+0x0/0xf5 @ 1
initcall dma_channel_table_init+0x0/0xf5 returned 0 after 0 usecs
calling  pci_arch_init+0x0/0x90 @ 1
PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x90 returned 0 after 13020 usecs
calling  topology_init+0x0/0x9b @ 1
Registering sys device of class 'cpu'
Registering sys device 'cpu0'
Registering sys device of class 'cpu'
Registering sys device 'cpu1'
initcall topology_init+0x0/0x9b returned 0 after 13020 usecs
calling  mtrr_init_finialize+0x0/0x55 @ 1
initcall mtrr_init_finialize+0x0/0x55 returned 0 after 0 usecs
calling  mca_init+0x0/0x2f5 @ 1
bus: 'MCA': registered
initcall mca_init+0x0/0x2f5 returned -19 after 0 usecs
calling  param_sysfs_init+0x0/0xdd @ 1
initcall param_sysfs_init+0x0/0xdd returned 0 after 149739 usecs
calling  pm_sysrq_init+0x0/0x40 @ 1
initcall pm_sysrq_init+0x0/0x40 returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x4d @ 1
initcall audit_watch_init+0x0/0x4d returned 0 after 0 usecs
calling  init_slow_work+0x0/0x53 @ 1
initcall init_slow_work+0x0/0x53 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xd1 @ 1
device: 'default': device_add
initcall default_bdi_init+0x0/0xd1 returned 0 after 3255 usecs
calling  init_bio+0x0/0xe2 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe2 returned 0 after 3255 usecs
calling  fsnotify_init+0x0/0x35 @ 1
initcall fsnotify_init+0x0/0x35 returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0x116 @ 1
initcall fsnotify_notification_init+0x0/0x116 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0x40 @ 1
initcall cryptomgr_init+0x0/0x40 returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x40 @ 1
initcall blk_settings_init+0x0/0x40 returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x4b @ 1
initcall blk_ioc_init+0x0/0x4b returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0xae @ 1
initcall blk_softirq_init+0x0/0xae returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x72 @ 1
device class 'block': registering
initcall genhd_device_init+0x0/0x72 returned 0 after 3255 usecs
calling  blk_dev_integrity_init+0x0/0x4b @ 1
initcall blk_dev_integrity_init+0x0/0x4b returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x60 @ 1
initcall pci_slot_init+0x0/0x60 returned 0 after 0 usecs
calling  fbmem_init+0x0/0xb6 @ 1
device class 'graphics': registering
initcall fbmem_init+0x0/0xb6 returned 0 after 3255 usecs
calling  pnp_init+0x0/0x35 @ 1
bus: 'pnp': registered
initcall pnp_init+0x0/0x35 returned 0 after 3255 usecs
calling  twl4030reg_init+0x0/0x40 @ 1
bus: 'platform': add driver twl4030_reg
initcall twl4030reg_init+0x0/0x40 returned 0 after 3255 usecs
calling  misc_init+0x0/0xcb @ 1
device class 'misc': registering
initcall misc_init+0x0/0xcb returned 0 after 3255 usecs
calling  tifm_init+0x0/0xa0 @ 1
bus: 'tifm': registered
device class 'tifm_adapter': registering
initcall tifm_init+0x0/0xa0 returned 0 after 6510 usecs
calling  twl4030_init+0x0/0x35 @ 1
bus: 'i2c': add driver twl4030
i2c-core: driver [twl4030] registered
initcall twl4030_init+0x0/0x35 returned 0 after 6510 usecs
calling  init_scsi+0x0/0xc6 @ 1
device class 'scsi_host': registering
bus: 'scsi': registered
device class 'scsi_device': registering
SCSI subsystem initialized
initcall init_scsi+0x0/0xc6 returned 0 after 13020 usecs
calling  ata_init+0x0/0xb3 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0xb3 returned 0 after 3255 usecs
calling  phy_init+0x0/0x55 @ 1
device class 'mdio_bus': registering
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
initcall phy_init+0x0/0x55 returned 0 after 9765 usecs
calling  usb_init+0x0/0x170 @ 1
bus: 'usb': registered
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
usbcore: registered new device driver usb
initcall usb_init+0x0/0x170 returned 0 after 19531 usecs
calling  serio_init+0x0/0xb0 @ 1
bus: 'serio': registered
initcall serio_init+0x0/0xb0 returned 0 after 3255 usecs
calling  input_init+0x0/0x155 @ 1
device class 'input': registering
initcall input_init+0x0/0x155 returned 0 after 3255 usecs
calling  rtc_init+0x0/0x80 @ 1
device class 'rtc': registering
initcall rtc_init+0x0/0x80 returned 0 after 3255 usecs
calling  pps_init+0x0/0xcb @ 1
device class 'pps': registering
LinuxPPS API ver. 1 registered
Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
initcall pps_init+0x0/0xcb returned 0 after 9765 usecs
calling  hwmon_init+0x0/0x69 @ 1
device class 'hwmon': registering
initcall hwmon_init+0x0/0x69 returned 0 after 3255 usecs
calling  thermal_init+0x0/0x6b @ 1
device class 'thermal': registering
initcall thermal_init+0x0/0x6b returned 0 after 3255 usecs
calling  mmc_init+0x0/0xa0 @ 1
bus: 'mmc': registered
device class 'mmc_host': registering
bus: 'sdio': registered
initcall mmc_init+0x0/0xa0 returned 0 after 6510 usecs
calling  leds_init+0x0/0x60 @ 1
device class 'leds': registering
initcall leds_init+0x0/0x60 returned 0 after 3255 usecs
calling  pci_subsys_init+0x0/0x150 @ 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
device: 'pci0000:00': device_add
device: '0000:00': device_add
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [10de:005e] class 000580 header type 00
pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:01.0: found [10de:0050] class 000601 header type 00
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xe0
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:01.1: found [10de:0052] class 000c05 header type 00
pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: found [10de:005a] class 000c03 header type 00
pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: found [10de:005b] class 000c03 header type 00
pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: found [10de:0059] class 000401 header type 00
pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: found [10de:0053] class 000101 header type 00
pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:09.0: found [10de:005c] class 000604 header type 01
pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0a.0: found [10de:0057] class 000680 header type 00
pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: found [10de:005d] class 000604 header type 01
Clocksource tsc unstable (delta = 141243850 ns)
pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: found [10de:005d] class 000604 header type 01
pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: found [1022:1100] class 000600 header type 00
pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:18.1: found [1022:1101] class 000600 header type 00
pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:18.2: found [1022:1102] class 000600 header type 00
pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:00:18.3: found [1022:1103] class 000600 header type 00
pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1b4
PCI: Fixups for bus 0000:00
pci 0000:00:09.0: scanning behind bridge, config 050500, pass 0
PCI: Scanning bus 0000:05
pci 0000:05:07.0: found [10ec:8139] class 000200 header type 00
pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
PCI: Fixups for bus 0000:05
pci 0000:00:09.0: transparent bridge
pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
PCI: Bus scan for 0000:05 returning with max=05
pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 0
PCI: Scanning bus 0000:04
PCI: Fixups for bus 0000:04
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
PCI: Fixups for bus 0000:03
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
PCI: Fixups for bus 0000:02
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:00.0: found [1002:5b60] class 000300 header type 00
pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x3b
pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: found [1002:5b70] class 000380 header type 00
pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x3b
pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x1b4
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
PCI: Fixups for bus 0000:01
pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:09.0: scanning behind bridge, config 050500, pass 1
pci 0000:00:0b.0: scanning behind bridge, config 040400, pass 1
pci 0000:00:0c.0: scanning behind bridge, config 030300, pass 1
pci 0000:00:0d.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:0e.0: scanning behind bridge, config 010100, pass 1
PCI: Bus scan for 0000:00 returning with max=05
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
device: '0000:00:01.0': device_add
bus: 'pci': add device 0000:00:01.0
device: '0000:00:01.1': device_add
bus: 'pci': add device 0000:00:01.1
device: '0000:00:02.0': device_add
bus: 'pci': add device 0000:00:02.0
device: '0000:00:02.1': device_add
bus: 'pci': add device 0000:00:02.1
device: '0000:00:04.0': device_add
bus: 'pci': add device 0000:00:04.0
device: '0000:00:06.0': device_add
bus: 'pci': add device 0000:00:06.0
device: '0000:00:09.0': device_add
bus: 'pci': add device 0000:00:09.0
device: '0000:00:0a.0': device_add
bus: 'pci': add device 0000:00:0a.0
device: '0000:00:0b.0': device_add
bus: 'pci': add device 0000:00:0b.0
device: '0000:00:0c.0': device_add
bus: 'pci': add device 0000:00:0c.0
device: '0000:00:0d.0': device_add
bus: 'pci': add device 0000:00:0d.0
device: '0000:00:0e.0': device_add
bus: 'pci': add device 0000:00:0e.0
device: '0000:00:18.0': device_add
bus: 'pci': add device 0000:00:18.0
device: '0000:00:18.1': device_add
bus: 'pci': add device 0000:00:18.1
device: '0000:00:18.2': device_add
bus: 'pci': add device 0000:00:18.2
device: '0000:00:18.3': device_add
bus: 'pci': add device 0000:00:18.3
device: '0000:05:07.0': device_add
bus: 'pci': add device 0000:05:07.0
device: '0000:05': device_add
device: '0000:04': device_add
device: '0000:03': device_add
device: '0000:02': device_add
device: '0000:01:00.0': device_add
bus: 'pci': add device 0000:01:00.0
device: '0000:01:00.1': device_add
bus: 'pci': add device 0000:01:00.1
device: '0000:01': device_add
pci 0000:00:00.0: default IRQ router [10de:005e]
initcall pci_subsys_init+0x0/0x150 returned 0 after 559894 usecs
calling  proto_init+0x0/0x30 @ 1
initcall proto_init+0x0/0x30 returned 0 after 0 usecs
calling  net_dev_init+0x0/0x1b5 @ 1
device class 'net': registering
device: 'lo': device_add
initcall net_dev_init+0x0/0x1b5 returned 0 after 6510 usecs
calling  neigh_init+0x0/0x9d @ 1
initcall neigh_init+0x0/0x9d returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xca @ 1
initcall fib_rules_init+0x0/0xca returned 0 after 0 usecs
calling  genl_init+0x0/0xeb @ 1
initcall genl_init+0x0/0xeb returned 0 after 9765 usecs
calling  irda_init+0x0/0xe0 @ 1
NET: Registered protocol family 23
initcall irda_init+0x0/0xe0 returned 0 after 3255 usecs
calling  wireless_nlevent_init+0x0/0x58 @ 1
initcall wireless_nlevent_init+0x0/0x58 returned 0 after 0 usecs
calling  rfkill_init+0x0/0x99 @ 1
device class 'rfkill': registering
device: 'rfkill': device_add
initcall rfkill_init+0x0/0x99 returned 0 after 6510 usecs
calling  sysctl_init+0x0/0x6b @ 1
initcall sysctl_init+0x0/0x6b returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x4e @ 1
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
initcall pci_iommu_init+0x0/0x4e returned 0 after 296223 usecs
calling  print_all_ICs+0x0/0xc6 @ 1

printing PIC contents
... PIC  IMR: fffa
... PIC  IRR: 0001
... PIC  ISR: 0001
... PIC ELCR: 0828
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000a396
... APIC TMCCT: 00001666
... APIC TDCR: 00000003

printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010400
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000a396
... APIC TMCCT: 000097fb
... APIC TDCR: 00000003

number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 003 0    0    0   0   0    1    1    30
 01 003 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 003 1    1    0   1   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 1    1    0   1   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    0    0   0   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 1    1    0   1   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
initcall print_all_ICs+0x0/0xc6 returned 0 after 237629 usecs
calling  hpet_late_init+0x0/0xc6 @ 1
initcall hpet_late_init+0x0/0xc6 returned -19 after 0 usecs
calling  clocksource_done_booting+0x0/0x35 @ 1
Switching to clocksource jiffies
initcall clocksource_done_booting+0x0/0x35 returned 0 after 3255 usecs
calling  init_pipe_fs+0x0/0x61 @ 1
initcall init_pipe_fs+0x0/0x61 returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xf6 @ 1
initcall eventpoll_init+0x0/0xf6 returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x120 @ 1
initcall anon_inode_init+0x0/0x120 returned 0 after 0 usecs
calling  fscache_init+0x0/0xd0 @ 1
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
initcall fscache_init+0x0/0xd0 returned 0 after 6510 usecs
calling  tomoyo_initerface_init+0x0/0x177 @ 1
initcall tomoyo_initerface_init+0x0/0x177 returned 0 after 0 usecs
calling  blk_scsi_ioctl_init+0x0/0x2a8 @ 1
initcall blk_scsi_ioctl_init+0x0/0x2a8 returned 0 after 0 usecs
calling  pnpbios_init+0x0/0xe0 @ 1
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fc550
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xc580, dseg 0xf0000
device: 'pnp0': device_add
device: '00:00': device_add
bus: 'pnp': add device 00:00
device: '00:01': device_add
bus: 'pnp': add device 00:01
device: '00:02': device_add
bus: 'pnp': add device 00:02
device: '00:03': device_add
bus: 'pnp': add device 00:03
device: '00:04': device_add
bus: 'pnp': add device 00:04
device: '00:05': device_add
bus: 'pnp': add device 00:05
device: '00:06': device_add
bus: 'pnp': add device 00:06
device: '00:07': device_add
bus: 'pnp': add device 00:07
device: '00:08': device_add
bus: 'pnp': add device 00:08
device: '00:09': device_add
bus: 'pnp': add device 00:09
device: '00:0a': device_add
bus: 'pnp': add device 00:0a
device: '00:0b': device_add
bus: 'pnp': add device 00:0b
device: '00:0c': device_add
bus: 'pnp': add device 00:0c
device: '00:0e': device_add
bus: 'pnp': add device 00:0e
device: '00:0f': device_add
bus: 'pnp': add device 00:0f
device: '00:10': device_add
bus: 'pnp': add device 00:10
PnPBIOS: 16 nodes reported by PnP BIOS; 16 recorded by driver
initcall pnpbios_init+0x0/0xe0 returned 0 after 110676 usecs
calling  pnp_system_init+0x0/0x40 @ 1
bus: 'pnp': add driver system
bus: 'pnp': driver_probe_device: matched device 00:07 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:07
system 00:07: iomem range 0x0-0x9ffff could not be reserved
system 00:07: iomem range 0xfffe0000-0xffffffff has been reserved
system 00:07: iomem range 0xfec00000-0xfec0ffff could not be reserved
system 00:07: iomem range 0xfee00000-0xfeefffff has been reserved
system 00:07: iomem range 0xfefffc00-0xfeffffff has been reserved
system 00:07: iomem range 0x100000-0xffffff could not be reserved
driver: '00:07': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:07 to driver system
bus: 'pnp': driver_probe_device: matched device 00:08 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:08
system 00:08: iomem range 0xf0000-0xf3fff could not be reserved
system 00:08: iomem range 0xf4000-0xf7fff could not be reserved
system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
system 00:08: iomem range 0xfc000-0xfffff could not be reserved
driver: '00:08': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:08 to driver system
initcall pnp_system_init+0x0/0x40 returned 0 after 61848 usecs
calling  chr_dev_init+0x0/0xe0 @ 1
device class 'mem': registering
device: 'mem': device_add
device: 'kmem': device_add
device: 'null': device_add
device: 'port': device_add
device: 'zero': device_add
device: 'full': device_add
device: 'random': device_add
device: 'urandom': device_add
device: 'kmsg': device_add
initcall chr_dev_init+0x0/0xe0 returned 0 after 29296 usecs
calling  firmware_class_init+0x0/0x8c @ 1
device class 'firmware': registering
initcall firmware_class_init+0x0/0x8c returned 0 after 3255 usecs
calling  ieee1394_init+0x0/0x270 @ 1
bus: 'ieee1394': registered
device class 'ieee1394_host': registering
device class 'ieee1394_protocol': registering
device class 'ieee1394_node': registering
device class 'ieee1394': registering
bus: 'ieee1394': add driver nodemgr
initcall ieee1394_init+0x0/0x270 returned 0 after 22786 usecs
calling  cpufreq_gov_performance_init+0x0/0x40 @ 1
initcall cpufreq_gov_performance_init+0x0/0x40 returned 0 after 0 usecs
calling  ssb_modinit+0x0/0x93 @ 1
bus: 'ssb': registered
initcall ssb_modinit+0x0/0x93 returned 0 after 3255 usecs
calling  pcibios_assign_resources+0x0/0x8e @ 1
pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
pci 0000:00:09.0:   IO window: 0xc000-0xcfff
pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus [0xd8000000-0xd801ffff] flags 0x27200
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
initcall pcibios_assign_resources+0x0/0x8e returned 0 after 117187 usecs
calling  sysctl_core_init+0x0/0x60 @ 1
initcall sysctl_core_init+0x0/0x60 returned 0 after 0 usecs
calling  inet_init+0x0/0x236 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x236 returned 0 after 32552 usecs
calling  af_unix_init+0x0/0x6a @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x6a returned 0 after 3255 usecs
calling  default_rootfs+0x0/0x91 @ 1
initcall default_rootfs+0x0/0x91 returned 0 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x50 @ 1
Registering sysdev class 'i8259'
Registering sys device of class 'i8259'
Registering sys device 'i82590'
initcall i8259A_init_sysfs+0x0/0x50 returned 0 after 9765 usecs
calling  sbf_init+0x0/0x130 @ 1
initcall sbf_init+0x0/0x130 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x45 @ 1
Registering sysdev class 'i8237'
Registering sys device of class 'i8237'
Registering sys device 'i82370'
initcall i8237A_init_sysfs+0x0/0x45 returned 0 after 9765 usecs
calling  add_rtc_cmos+0x0/0xd3 @ 1
initcall add_rtc_cmos+0x0/0xd3 returned 0 after 0 usecs
calling  cache_sysfs_init+0x0/0x7b @ 1
initcall cache_sysfs_init+0x0/0x7b returned 0 after 3255 usecs
calling  cpu_debug_init+0x0/0x140 @ 1
cpu0(2) debug files 137
cpu1(2) debug files 137
initcall cpu_debug_init+0x0/0x140 returned 0 after 22786 usecs
calling  mce_init_device+0x0/0x115 @ 1
Registering sysdev class 'machinecheck'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck0'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck1'
device: 'mcelog': device_add
initcall mce_init_device+0x0/0x115 returned 0 after 19531 usecs
calling  threshold_init_device+0x0/0xa0 @ 1
initcall threshold_init_device+0x0/0xa0 returned 0 after 0 usecs
calling  powernow_k6_init+0x0/0xb0 @ 1
initcall powernow_k6_init+0x0/0xb0 returned -19 after 0 usecs
calling  speedstep_init+0x0/0x140 @ 1
initcall speedstep_init+0x0/0x140 returned -19 after 0 usecs
calling  nforce2_init+0x0/0x9b @ 1
cpufreq-nforce2: No nForce2 chipset.
initcall nforce2_init+0x0/0x9b returned -19 after 3255 usecs
calling  ioapic_init_sysfs+0x0/0xb1 @ 1
Registering sysdev class 'ioapic'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic0'
initcall ioapic_init_sysfs+0x0/0xb1 returned 0 after 9765 usecs
calling  add_pcspkr+0x0/0x51 @ 1
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
initcall add_pcspkr+0x0/0x51 returned 0 after 9765 usecs
calling  pt_dump_init+0x0/0x80 @ 1
initcall pt_dump_init+0x0/0x80 returned 0 after 0 usecs
calling  init+0x0/0x40 @ 1
initcall init+0x0/0x40 returned 0 after 0 usecs
calling  init+0x0/0x40 @ 1
initcall init+0x0/0x40 returned 0 after 0 usecs
calling  init_sched_debug_procfs+0x0/0x4c @ 1
initcall init_sched_debug_procfs+0x0/0x4c returned 0 after 0 usecs
calling  proc_schedstat_init+0x0/0x48 @ 1
initcall proc_schedstat_init+0x0/0x48 returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x50 @ 1
initcall proc_execdomains_init+0x0/0x50 returned 0 after 0 usecs
calling  ioresources_init+0x0/0x65 @ 1
initcall ioresources_init+0x0/0x65 returned 0 after 0 usecs
calling  uid_cache_init+0x0/0xb0 @ 1
initcall uid_cache_init+0x0/0xb0 returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x171 @ 1
initcall init_posix_timers+0x0/0x171 returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0xd9 @ 1
initcall init_posix_cpu_timers+0x0/0xd9 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x5b @ 1
initcall nsproxy_cache_init+0x0/0x5b returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x45 @ 1
Registering sysdev class 'timekeeping'
Registering sys device of class 'timekeeping'
Registering sys device 'timekeeping0'
initcall timekeeping_init_device+0x0/0x45 returned 0 after 13020 usecs
calling  init_clocksource_sysfs+0x0/0x6b @ 1
Registering sysdev class 'clocksource'
Registering sys device of class 'clocksource'
Registering sys device 'clocksource0'
initcall init_clocksource_sysfs+0x0/0x6b returned 0 after 9765 usecs
calling  init_timer_list_procfs+0x0/0x53 @ 1
initcall init_timer_list_procfs+0x0/0x53 returned 0 after 0 usecs
calling  init_tstats_procfs+0x0/0x4c @ 1
initcall init_tstats_procfs+0x0/0x4c returned 0 after 0 usecs
calling  lockdep_proc_init+0x0/0xad @ 1
initcall lockdep_proc_init+0x0/0xad returned 0 after 0 usecs
calling  futex_init+0x0/0x93 @ 1
initcall futex_init+0x0/0x93 returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x50 @ 1
initcall proc_dma_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_modules_init+0x0/0x50 @ 1
initcall proc_modules_init+0x0/0x50 returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x50 @ 1
initcall kallsyms_init+0x0/0x50 returned 0 after 0 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x4dd @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x4dd returned 0 after 0 usecs
calling  crash_notes_memory_init+0x0/0x50 @ 1
initcall crash_notes_memory_init+0x0/0x50 returned 0 after 0 usecs
calling  backtrace_regression_test+0x0/0x100 @ 1
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Not tainted 2.6.31-tip-02343-gb432421-dirty #14071
Call Trace:
 [<c1949133>] ? printk+0x23/0x40
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c108bf30>] ? backtrace_regression_test+0x0/0x100
 [<c108bf6b>] backtrace_regression_test+0x3b/0x100
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c106ed42>] ? ktime_get+0x72/0x110
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c108bf30>] ? backtrace_regression_test+0x0/0x100
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c108bf30>] ? backtrace_regression_test+0x0/0x100
 [<c100105e>] do_one_initcall+0x2e/0x1a0
 [<c108bf30>] ? backtrace_regression_test+0x0/0x100
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c1c8e5b5>] do_basic_setup+0x68/0x98
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c1c8e665>] kernel_init+0x80/0xdb
 [<c17b2a24>] ? m48t59_rtc_setalarm+0x94/0x250
 [<c1c8e5e5>] ? kernel_init+0x0/0xdb
 [<c1004127>] kernel_thread_helper+0x7/0x10
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 4, comm: ksoftirqd/0 Not tainted 2.6.31-tip-02343-gb432421-dirty #14071
Call Trace:
 [<c107b67f>] ? trace_hardirqs_on_caller+0x6f/0x1c0
 [<c108bf06>] backtrace_test_irq_callback+0x16/0x40
 [<c104e303>] tasklet_action+0x63/0xf0
 [<c104ef8f>] __do_softirq+0xef/0x210
 [<c104eea0>] ? __do_softirq+0x0/0x210
 <IRQ>  [<c104ead6>] ? ksoftirqd+0x86/0x1e0
 [<c104ea50>] ? ksoftirqd+0x0/0x1e0
 [<c1062fcc>] ? kthread+0x7c/0x90
 [<c1062f50>] ? kthread+0x0/0x90
 [<c1004127>] ? kernel_thread_helper+0x7/0x10
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<c100f6c6>] save_stack_trace+0x36/0x70
 [<c108bffc>] backtrace_regression_test+0xcc/0x100
 [<c100105e>] do_one_initcall+0x2e/0x1a0
 [<c1c8e5b5>] do_basic_setup+0x68/0x98
 [<c1c8e665>] kernel_init+0x80/0xdb
 [<c1004127>] kernel_thread_helper+0x7/0x10
 [<ffffffff>] 0xffffffff
====[ end of backtrace testing ]====
initcall backtrace_regression_test+0x0/0x100 returned 0 after 152994 usecs
calling  pid_namespaces_init+0x0/0x4e @ 1
initcall pid_namespaces_init+0x0/0x4e returned 0 after 0 usecs
calling  audit_init+0x0/0x16a @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1252932695.629:1): initialized
initcall audit_init+0x0/0x16a returned 0 after 6510 usecs
calling  init_kprobes+0x0/0x16e @ 1
initcall init_kprobes+0x0/0x16e returned 0 after 3255 usecs
calling  rcu_torture_init+0x0/0x6e0 @ 1
rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
initcall rcu_torture_init+0x0/0x6e0 returned 0 after 3255 usecs
calling  rcuclassic_trace_init+0x0/0x11f @ 1
initcall rcuclassic_trace_init+0x0/0x11f returned 0 after 0 usecs
calling  utsname_sysctl_init+0x0/0x35 @ 1
initcall utsname_sysctl_init+0x0/0x35 returned 0 after 0 usecs
calling  init_markers+0x0/0x40 @ 1
initcall init_markers+0x0/0x40 returned 0 after 0 usecs
calling  init_tracepoints+0x0/0x40 @ 1
initcall init_tracepoints+0x0/0x40 returned 0 after 0 usecs
calling  init_lstats_procfs+0x0/0x4d @ 1
initcall init_lstats_procfs+0x0/0x4d returned 0 after 0 usecs
calling  perf_counter_sysfs_init+0x0/0x35 @ 1
initcall perf_counter_sysfs_init+0x0/0x35 returned 0 after 0 usecs
calling  init_per_zone_wmark_min+0x0/0x8d @ 1
initcall init_per_zone_wmark_min+0x0/0x8d returned 0 after 0 usecs
calling  kswapd_init+0x0/0x3d @ 1
initcall kswapd_init+0x0/0x3d returned 0 after 0 usecs
calling  init_tmpfs+0x0/0xf3 @ 1
initcall init_tmpfs+0x0/0xf3 returned 0 after 0 usecs
calling  setup_vmstat+0x0/0xed @ 1
initcall setup_vmstat+0x0/0xed returned 0 after 0 usecs
calling  mm_sysfs_init+0x0/0x41 @ 1
initcall mm_sysfs_init+0x0/0x41 returned 0 after 0 usecs
calling  proc_vmalloc_init+0x0/0x4b @ 1
initcall proc_vmalloc_init+0x0/0x4b returned 0 after 0 usecs
calling  procswaps_init+0x0/0x4c @ 1
initcall procswaps_init+0x0/0x4c returned 0 after 0 usecs
calling  hugetlb_init+0x0/0x2ae @ 1
HugeTLB registered 4 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2ae returned 0 after 3255 usecs
calling  slab_proc_init+0x0/0x48 @ 1
initcall slab_proc_init+0x0/0x48 returned 0 after 0 usecs
calling  slab_sysfs_init+0x0/0xe3 @ 1
initcall slab_sysfs_init+0x0/0xe3 returned 0 after 94400 usecs
calling  kmemleak_test_init+0x0/0x41b @ 1
Kmemleak testing
kmemleak: kmalloc(32) = f6bc5aa0
kmemleak: kmalloc(32) = f6bc5af0
kmemleak: kmalloc(1024) = f6bdcc90
kmemleak: kmalloc(1024) = f6bdd0c0
kmemleak: kmalloc(2048) = f7821890
kmemleak: kmalloc(2048) = f78220c0
kmemleak: kmalloc(4096) = f7842060
kmemleak: kmalloc(4096) = f7843090
kmemleak: vmalloc(64) = f8556000
kmemleak: vmalloc(64) = f8559000
kmemleak: vmalloc(64) = f855c000
kmemleak: vmalloc(64) = f855f000
kmemleak: vmalloc(64) = f8562000
kmemleak: kmalloc(sizeof(*elem)) = f6bc4be0
kmemleak: kmalloc(sizeof(*elem)) = f6bc4d10
kmemleak: kmalloc(sizeof(*elem)) = f6bc4e40
kmemleak: kmalloc(sizeof(*elem)) = f7872130
kmemleak: kmalloc(sizeof(*elem)) = f62b3000
kmemleak: kmalloc(sizeof(*elem)) = f62b3130
kmemleak: kmalloc(sizeof(*elem)) = f62b3260
kmemleak: kmalloc(sizeof(*elem)) = f62b3390
kmemleak: kmalloc(sizeof(*elem)) = f62b34c0
kmemleak: kmalloc(sizeof(*elem)) = f62b35f0
kmemleak: kmalloc(129) = f6378960
kmemleak: kmalloc(129) = f6378a50
initcall kmemleak_test_init+0x0/0x41b returned 0 after 78124 usecs
calling  fasync_init+0x0/0x5a @ 1
initcall fasync_init+0x0/0x5a returned 0 after 3255 usecs
calling  proc_filesystems_init+0x0/0x45 @ 1
initcall proc_filesystems_init+0x0/0x45 returned 0 after 0 usecs
calling  dnotify_init+0x0/0x9f @ 1
initcall dnotify_init+0x0/0x9f returned 0 after 3255 usecs
calling  inotify_setup+0x0/0x2e @ 1
initcall inotify_setup+0x0/0x2e returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0xe2 @ 1
initcall inotify_user_setup+0x0/0xe2 returned 0 after 3255 usecs
calling  aio_setup+0x0/0xe0 @ 1
initcall aio_setup+0x0/0xe0 returned 0 after 9765 usecs
calling  proc_locks_init+0x0/0x45 @ 1
initcall proc_locks_init+0x0/0x45 returned 0 after 0 usecs
calling  init_mbcache+0x0/0x40 @ 1
initcall init_mbcache+0x0/0x40 returned 0 after 0 usecs
calling  dquot_init+0x0/0x110 @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x110 returned 0 after 6510 usecs
calling  init_v2_quota_format+0x0/0x40 @ 1
initcall init_v2_quota_format+0x0/0x40 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x50 @ 1
initcall proc_cmdline_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_cpuinfo_init+0x0/0x50 @ 1
initcall proc_cpuinfo_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_devices_init+0x0/0x50 @ 1
initcall proc_devices_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_interrupts_init+0x0/0x50 @ 1
initcall proc_interrupts_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_loadavg_init+0x0/0x50 @ 1
initcall proc_loadavg_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_meminfo_init+0x0/0x50 @ 1
initcall proc_meminfo_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_stat_init+0x0/0x50 @ 1
initcall proc_stat_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_uptime_init+0x0/0x50 @ 1
initcall proc_uptime_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_version_init+0x0/0x50 @ 1
initcall proc_version_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_softirqs_init+0x0/0x45 @ 1
initcall proc_softirqs_init+0x0/0x45 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x50 @ 1
initcall proc_kmsg_init+0x0/0x50 returned 0 after 0 usecs
calling  proc_page_init+0x0/0x6d @ 1
initcall proc_page_init+0x0/0x6d returned 0 after 0 usecs
calling  configfs_init+0x0/0xe0 @ 1
initcall configfs_init+0x0/0xe0 returned 0 after 0 usecs
calling  init_devpts_fs+0x0/0x6b @ 1
initcall init_devpts_fs+0x0/0x6b returned 0 after 3255 usecs
calling  init_reiserfs_fs+0x0/0x9c @ 1
initcall init_reiserfs_fs+0x0/0x9c returned 0 after 3255 usecs
calling  init_ext3_fs+0x0/0x85 @ 1
initcall init_ext3_fs+0x0/0x85 returned 0 after 3255 usecs
calling  init_ext4_fs+0x0/0xf5 @ 1
initcall init_ext4_fs+0x0/0xf5 returned 0 after 6510 usecs
calling  journal_init+0x0/0xcb @ 1
initcall journal_init+0x0/0xcb returned 0 after 3255 usecs
calling  journal_init+0x0/0xdb @ 1
initcall journal_init+0x0/0xdb returned 0 after 6510 usecs
calling  init_ramfs_fs+0x0/0x35 @ 1
initcall init_ramfs_fs+0x0/0x35 returned 0 after 0 usecs
calling  init_hugetlbfs_fs+0x0/0xc0 @ 1
initcall init_hugetlbfs_fs+0x0/0xc0 returned 0 after 0 usecs
calling  init_fat_fs+0x0/0x70 @ 1
initcall init_fat_fs+0x0/0x70 returned 0 after 0 usecs
calling  init_vfat_fs+0x0/0x40 @ 1
initcall init_vfat_fs+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp437+0x0/0x40 @ 1
initcall init_nls_cp437+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp737+0x0/0x40 @ 1
initcall init_nls_cp737+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp775+0x0/0x40 @ 1
initcall init_nls_cp775+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp852+0x0/0x40 @ 1
initcall init_nls_cp852+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp861+0x0/0x40 @ 1
initcall init_nls_cp861+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp862+0x0/0x40 @ 1
initcall init_nls_cp862+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp863+0x0/0x40 @ 1
initcall init_nls_cp863+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp864+0x0/0x40 @ 1
initcall init_nls_cp864+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp866+0x0/0x40 @ 1
initcall init_nls_cp866+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp869+0x0/0x40 @ 1
initcall init_nls_cp869+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp936+0x0/0x40 @ 1
initcall init_nls_cp936+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_iso8859_5+0x0/0x40 @ 1
initcall init_nls_iso8859_5+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_cp1255+0x0/0x40 @ 1
initcall init_nls_cp1255+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_iso8859_13+0x0/0x40 @ 1
initcall init_nls_iso8859_13+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_koi8_r+0x0/0x40 @ 1
initcall init_nls_koi8_r+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_koi8_u+0x0/0x40 @ 1
initcall init_nls_koi8_u+0x0/0x40 returned 0 after 0 usecs
calling  init_nls_koi8_ru+0x0/0x5d @ 1
initcall init_nls_koi8_ru+0x0/0x5d returned 0 after 0 usecs
calling  init_smb_fs+0x0/0x93 @ 1
initcall init_smb_fs+0x0/0x93 returned 0 after 3255 usecs
calling  init_ntfs_fs+0x0/0x270 @ 1
NTFS driver 2.1.29 [Flags: R/W DEBUG].
initcall init_ntfs_fs+0x0/0x270 returned 0 after 9765 usecs
calling  init_autofs_fs+0x0/0x35 @ 1
initcall init_autofs_fs+0x0/0x35 returned 0 after 0 usecs
calling  ocfs2_init+0x0/0x4d0 @ 1
OCFS2 1.5.0
initcall ocfs2_init+0x0/0x4d0 returned 0 after 6510 usecs
calling  ocfs2_stack_glue_init+0x0/0xa0 @ 1
initcall ocfs2_stack_glue_init+0x0/0xa0 returned 0 after 0 usecs
calling  init_o2nm+0x0/0xd0 @ 1
OCFS2 Node Manager 1.5.0
initcall init_o2nm+0x0/0xd0 returned 0 after 13020 usecs
calling  init_btrfs_fs+0x0/0xd3 @ 1
device: 'btrfs-control': device_add
Btrfs loaded
initcall init_btrfs_fs+0x0/0xd3 returned 0 after 13020 usecs
calling  init_gfs2_fs+0x0/0x220 @ 1
GFS2 (built Sep 14 2009 08:52:21) installed
initcall init_gfs2_fs+0x0/0x220 returned 0 after 9765 usecs
calling  key_proc_init+0x0/0x90 @ 1
initcall key_proc_init+0x0/0x90 returned 0 after 0 usecs
calling  selinux_nf_ip_init+0x0/0x80 @ 1
initcall selinux_nf_ip_init+0x0/0x80 returned 0 after 0 usecs
calling  init_sel_fs+0x0/0x7c @ 1
initcall init_sel_fs+0x0/0x7c returned 0 after 0 usecs
calling  selnl_init+0x0/0x79 @ 1
initcall selnl_init+0x0/0x79 returned 0 after 0 usecs
calling  sel_netif_init+0x0/0x90 @ 1
initcall sel_netif_init+0x0/0x90 returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0xa0 @ 1
initcall sel_netnode_init+0x0/0xa0 returned 0 after 0 usecs
calling  sel_netport_init+0x0/0xa0 @ 1
initcall sel_netport_init+0x0/0xa0 returned 0 after 0 usecs
calling  aurule_init+0x0/0x70 @ 1
initcall aurule_init+0x0/0x70 returned 0 after 0 usecs
calling  crypto_wq_init+0x0/0x60 @ 1
initcall crypto_wq_init+0x0/0x60 returned 0 after 0 usecs
calling  crypto_algapi_init+0x0/0x2d @ 1
initcall crypto_algapi_init+0x0/0x2d returned 0 after 0 usecs
calling  skcipher_module_init+0x0/0x53 @ 1
initcall skcipher_module_init+0x0/0x53 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0x40 @ 1
initcall chainiv_module_init+0x0/0x40 returned 0 after 0 usecs
calling  eseqiv_module_init+0x0/0x40 @ 1
initcall eseqiv_module_init+0x0/0x40 returned 0 after 0 usecs
calling  hmac_module_init+0x0/0x40 @ 1
initcall hmac_module_init+0x0/0x40 returned 0 after 0 usecs
calling  vmac_module_init+0x0/0x35 @ 1
initcall vmac_module_init+0x0/0x35 returned 0 after 0 usecs
calling  crypto_null_mod_init+0x0/0x8b @ 1
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
initcall crypto_null_mod_init+0x0/0x8b returned 0 after 19531 usecs
calling  md5_mod_init+0x0/0x40 @ 1
initcall md5_mod_init+0x0/0x40 returned 0 after 0 usecs
calling  rmd128_mod_init+0x0/0x40 @ 1
initcall rmd128_mod_init+0x0/0x40 returned 0 after 0 usecs
calling  rmd256_mod_init+0x0/0x40 @ 1
initcall rmd256_mod_init+0x0/0x40 returned 0 after 0 usecs
calling  sha1_generic_mod_init+0x0/0x40 @ 1
initcall sha1_generic_mod_init+0x0/0x40 returned 0 after 0 usecs
calling  crypto_cbc_module_init+0x0/0x40 @ 1
initcall crypto_cbc_module_init+0x0/0x40 returned 0 after 0 usecs
calling  crypto_cts_module_init+0x0/0x40 @ 1
initcall crypto_cts_module_init+0x0/0x40 returned 0 after 0 usecs
calling  aes_init+0x0/0x40 @ 1
initcall aes_init+0x0/0x40 returned 0 after 0 usecs
calling  camellia_init+0x0/0x40 @ 1
initcall camellia_init+0x0/0x40 returned 0 after 0 usecs
calling  arc4_init+0x0/0x40 @ 1
initcall arc4_init+0x0/0x40 returned 0 after 0 usecs
calling  seed_init+0x0/0x40 @ 1
initcall seed_init+0x0/0x40 returned 0 after 0 usecs
calling  deflate_mod_init+0x0/0x40 @ 1
initcall deflate_mod_init+0x0/0x40 returned 0 after 3255 usecs
calling  crc32c_mod_init+0x0/0x40 @ 1
initcall crc32c_mod_init+0x0/0x40 returned 0 after 3255 usecs
calling  krng_mod_init+0x0/0x40 @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0x40 returned 0 after 3255 usecs
calling  ghash_mod_init+0x0/0x40 @ 1
alg: No test for ghash (ghash-generic)
initcall ghash_mod_init+0x0/0x40 returned 0 after 3255 usecs
calling  proc_genhd_init+0x0/0x65 @ 1
initcall proc_genhd_init+0x0/0x65 returned 0 after 0 usecs
calling  noop_init+0x0/0x40 @ 1
io scheduler noop registered (default)
initcall noop_init+0x0/0x40 returned 0 after 3255 usecs
calling  deadline_init+0x0/0x35 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x35 returned 0 after 3255 usecs
calling  debug_objects_init_debugfs+0x0/0x83 @ 1
initcall debug_objects_init_debugfs+0x0/0x83 returned 0 after 0 usecs
calling  libcrc32c_mod_init+0x0/0x44 @ 1
initcall libcrc32c_mod_init+0x0/0x44 returned 0 after 0 usecs
calling  percpu_counter_startup+0x0/0x47 @ 1
initcall percpu_counter_startup+0x0/0x47 returned 0 after 0 usecs
calling  audit_classes_init+0x0/0x6d @ 1
initcall audit_classes_init+0x0/0x6d returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x150 @ 1
initcall dynamic_debug_init+0x0/0x150 returned 0 after 3255 usecs
calling  pci_init+0x0/0x5b @ 1
pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:00.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:01.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:01.1: calling pci_fixup_video+0x0/0xcb
pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:02.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:02.1: calling pci_fixup_video+0x0/0xcb
pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:04.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:06.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:09.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa0
pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa0
pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa0
pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0xa0
pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:18.0: calling pci_fixup_video+0x0/0xcb
pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:18.1: calling pci_fixup_video+0x0/0xcb
pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:18.2: calling pci_fixup_video+0x0/0xcb
pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:00:18.3: calling pci_fixup_video+0x0/0xcb
pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:05:07.0: calling pci_fixup_video+0x0/0xcb
pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:01:00.0: calling pci_fixup_video+0x0/0xcb
pci 0000:01:00.0: Boot video device
pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x50
pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0xe8
pci 0000:01:00.1: calling pci_fixup_video+0x0/0xcb
initcall pci_init+0x0/0x5b returned 0 after 227864 usecs
calling  pci_proc_init+0x0/0x92 @ 1
initcall pci_proc_init+0x0/0x92 returned 0 after 3255 usecs
calling  pcie_portdrv_init+0x0/0x6a @ 1
bus: 'pci_express': registered
bus: 'pci': add driver pcieport-driver
bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
bus: 'pci': driver_probe_device: matched device 0000:00:0c.0 with driver pcieport-driver
bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0c.0
bus: 'pci': driver_probe_device: matched device 0000:00:0d.0 with driver pcieport-driver
bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0d.0
bus: 'pci': driver_probe_device: matched device 0000:00:0e.0 with driver pcieport-driver
bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0e.0
initcall pcie_portdrv_init+0x0/0x6a returned 0 after 32552 usecs
calling  aer_service_init+0x0/0x50 @ 1
bus: 'pci_express': add driver aer
initcall aer_service_init+0x0/0x50 returned 0 after 16276 usecs
calling  kb3886_init+0x0/0x60 @ 1
initcall kb3886_init+0x0/0x60 returned -19 after 0 usecs
calling  pm2fb_init+0x0/0x64 @ 1
bus: 'pci': add driver pm2fb
initcall pm2fb_init+0x0/0x64 returned 0 after 3255 usecs
calling  pm3fb_init+0x0/0xf6 @ 1
bus: 'pci': add driver pm3fb
initcall pm3fb_init+0x0/0xf6 returned 0 after 6510 usecs
calling  rivafb_init+0x0/0x70 @ 1
bus: 'pci': add driver rivafb
initcall rivafb_init+0x0/0x70 returned 0 after 13020 usecs
calling  aty128fb_init+0x0/0x6d @ 1
bus: 'pci': add driver aty128fb
initcall aty128fb_init+0x0/0x6d returned 0 after 3255 usecs
calling  vt8623fb_init+0x0/0x9b @ 1
bus: 'pci': add driver vt8623fb
initcall vt8623fb_init+0x0/0x9b returned 0 after 13020 usecs
calling  hecubafb_init+0x0/0x35 @ 1
bus: 'platform': add driver hecubafb
initcall hecubafb_init+0x0/0x35 returned 0 after 19531 usecs
calling  n411_init+0x0/0xbb @ 1
no IO addresses supplied
initcall n411_init+0x0/0xbb returned -22 after 0 usecs
initcall n411_init+0x0/0xbb returned with error code -22 
calling  sstfb_init+0x0/0x6a @ 1
bus: 'pci': add driver sstfb
initcall sstfb_init+0x0/0x6a returned 0 after 3255 usecs
calling  broadsheetfb_init+0x0/0x40 @ 1
bus: 'platform': add driver broadsheetfb
initcall broadsheetfb_init+0x0/0x40 returned 0 after 3255 usecs
calling  s1d13xxxfb_init+0x0/0x50 @ 1
bus: 'platform': add driver s1d13xxxfb
initcall s1d13xxxfb_init+0x0/0x50 returned 0 after 3255 usecs
calling  mb862xxfb_init+0x0/0x30 @ 1
initcall mb862xxfb_init+0x0/0x30 returned -19 after 0 usecs
calling  pnpbios_thread_init+0x0/0x7b @ 1
initcall pnpbios_thread_init+0x0/0x7b returned 0 after 0 usecs
calling  bq24022_init+0x0/0x35 @ 1
bus: 'platform': add driver bq24022
bus: 'platform': remove driver bq24022
driver: 'bq24022': driver_release
initcall bq24022_init+0x0/0x35 returned -19 after 13020 usecs
calling  rand_initialize+0x0/0x50 @ 1
initcall rand_initialize+0x0/0x50 returned 0 after 0 usecs
calling  tty_init+0x0/0x120 @ 1
device: 'tty': device_add
device: 'console': device_add
device: 'tty0': device_add
device class 'vc': registering
device: 'vcs': device_add
device: 'vcsa': device_add
device: 'vcs1': device_add
device: 'vcsa1': device_add
device: 'tty1': device_add
device: 'tty2': device_add
device: 'tty3': device_add
device: 'tty4': device_add
device: 'tty5': device_add
device: 'tty6': device_add
device: 'tty7': device_add
device: 'tty8': device_add
device: 'tty9': device_add
device: 'tty10': device_add
device: 'tty11': device_add
device: 'tty12': device_add
device: 'tty13': device_add
device: 'tty14': device_add
device: 'tty15': device_add
device: 'tty16': device_add
device: 'tty17': device_add
device: 'tty18': device_add
device: 'tty19': device_add
device: 'tty20': device_add
device: 'tty21': device_add
device: 'tty22': device_add
device: 'tty23': device_add
device: 'tty24': device_add
device: 'tty25': device_add
device: 'tty26': device_add
device: 'tty27': device_add
device: 'tty28': device_add
device: 'tty29': device_add
device: 'tty30': device_add
device: 'tty31': device_add
device: 'tty32': device_add
device: 'tty33': device_add
device: 'tty34': device_add
device: 'tty35': device_add
device: 'tty36': device_add
device: 'tty37': device_add
device: 'tty38': device_add
device: 'tty39': device_add
device: 'tty40': device_add
device: 'tty41': device_add
device: 'tty42': device_add
device: 'tty43': device_add
device: 'tty44': device_add
device: 'tty45': device_add
device: 'tty46': device_add
device: 'tty47': device_add
device: 'tty48': device_add
device: 'tty49': device_add
device: 'tty50': device_add
device: 'tty51': device_add
device: 'tty52': device_add
device: 'tty53': device_add
device: 'tty54': device_add
device: 'tty55': device_add
device: 'tty56': device_add
device: 'tty57': device_add
device: 'tty58': device_add
device: 'tty59': device_add
device: 'tty60': device_add
device: 'tty61': device_add
device: 'tty62': device_add
device: 'tty63': device_add
initcall tty_init+0x0/0x120 returned 0 after 279947 usecs
calling  pty_init+0x0/0x38 @ 1
device: 'ptyp0': device_add
device: 'ptyp1': device_add
device: 'ptyp2': device_add
device: 'ptyp3': device_add
device: 'ptyp4': device_add
device: 'ptyp5': device_add
device: 'ptyp6': device_add
device: 'ptyp7': device_add
device: 'ptyp8': device_add
device: 'ptyp9': device_add
device: 'ptypa': device_add
device: 'ptypb': device_add
device: 'ptypc': device_add
device: 'ptypd': device_add
device: 'ptype': device_add
device: 'ptypf': device_add
device: 'ptyq0': device_add
device: 'ptyq1': device_add
device: 'ptyq2': device_add
device: 'ptyq3': device_add
device: 'ptyq4': device_add
device: 'ptyq5': device_add
device: 'ptyq6': device_add
device: 'ptyq7': device_add
device: 'ptyq8': device_add
device: 'ptyq9': device_add
device: 'ptyqa': device_add
device: 'ptyqb': device_add
device: 'ptyqc': device_add
device: 'ptyqd': device_add
device: 'ptyqe': device_add
device: 'ptyqf': device_add
device: 'ptyr0': device_add
device: 'ptyr1': device_add
device: 'ptyr2': device_add
device: 'ptyr3': device_add
device: 'ptyr4': device_add
device: 'ptyr5': device_add
device: 'ptyr6': device_add
device: 'ptyr7': device_add
device: 'ptyr8': device_add
device: 'ptyr9': device_add
device: 'ptyra': device_add
device: 'ptyrb': device_add
device: 'ptyrc': device_add
device: 'ptyrd': device_add
device: 'ptyre': device_add
device: 'ptyrf': device_add
device: 'ptys0': device_add
device: 'ptys1': device_add
device: 'ptys2': device_add
device: 'ptys3': device_add
device: 'ptys4': device_add
device: 'ptys5': device_add
device: 'ptys6': device_add
device: 'ptys7': device_add
device: 'ptys8': device_add
device: 'ptys9': device_add
device: 'ptysa': device_add
device: 'ptysb': device_add
device: 'ptysc': device_add
device: 'ptysd': device_add
device: 'ptyse': device_add
device: 'ptysf': device_add
device: 'ptyt0': device_add
device: 'ptyt1': device_add
device: 'ptyt2': device_add
device: 'ptyt3': device_add
device: 'ptyt4': device_add
device: 'ptyt5': device_add
device: 'ptyt6': device_add
device: 'ptyt7': device_add
device: 'ptyt8': device_add
device: 'ptyt9': device_add
device: 'ptyta': device_add
device: 'ptytb': device_add
device: 'ptytc': device_add
device: 'ptytd': device_add
device: 'ptyte': device_add
device: 'ptytf': device_add
device: 'ptyu0': device_add
device: 'ptyu1': device_add
device: 'ptyu2': device_add
device: 'ptyu3': device_add
device: 'ptyu4': device_add
device: 'ptyu5': device_add
device: 'ptyu6': device_add
device: 'ptyu7': device_add
device: 'ptyu8': device_add
device: 'ptyu9': device_add
device: 'ptyua': device_add
device: 'ptyub': device_add
device: 'ptyuc': device_add
device: 'ptyud': device_add
device: 'ptyue': device_add
device: 'ptyuf': device_add
device: 'ptyv0': device_add
device: 'ptyv1': device_add
device: 'ptyv2': device_add
device: 'ptyv3': device_add
device: 'ptyv4': device_add
device: 'ptyv5': device_add
device: 'ptyv6': device_add
device: 'ptyv7': device_add
device: 'ptyv8': device_add
device: 'ptyv9': device_add
device: 'ptyva': device_add
device: 'ptyvb': device_add
device: 'ptyvc': device_add
device: 'ptyvd': device_add
device: 'ptyve': device_add
device: 'ptyvf': device_add
device: 'ptyw0': device_add
device: 'ptyw1': device_add
device: 'ptyw2': device_add
device: 'ptyw3': device_add
device: 'ptyw4': device_add
device: 'ptyw5': device_add
device: 'ptyw6': device_add
device: 'ptyw7': device_add
device: 'ptyw8': device_add
device: 'ptyw9': device_add
device: 'ptywa': device_add
device: 'ptywb': device_add
device: 'ptywc': device_add
device: 'ptywd': device_add
device: 'ptywe': device_add
device: 'ptywf': device_add
device: 'ptyx0': device_add
device: 'ptyx1': device_add
device: 'ptyx2': device_add
device: 'ptyx3': device_add
device: 'ptyx4': device_add
device: 'ptyx5': device_add
device: 'ptyx6': device_add
device: 'ptyx7': device_add
device: 'ptyx8': device_add
device: 'ptyx9': device_add
device: 'ptyxa': device_add
device: 'ptyxb': device_add
device: 'ptyxc': device_add
device: 'ptyxd': device_add
device: 'ptyxe': device_add
device: 'ptyxf': device_add
device: 'ptyy0': device_add
device: 'ptyy1': device_add
device: 'ptyy2': device_add
device: 'ptyy3': device_add
device: 'ptyy4': device_add
device: 'ptyy5': device_add
device: 'ptyy6': device_add
device: 'ptyy7': device_add
device: 'ptyy8': device_add
device: 'ptyy9': device_add
device: 'ptyya': device_add
device: 'ptyyb': device_add
device: 'ptyyc': device_add
device: 'ptyyd': device_add
device: 'ptyye': device_add
device: 'ptyyf': device_add
device: 'ptyz0': device_add
device: 'ptyz1': device_add
device: 'ptyz2': device_add
device: 'ptyz3': device_add
device: 'ptyz4': device_add
device: 'ptyz5': device_add
device: 'ptyz6': device_add
device: 'ptyz7': device_add
device: 'ptyz8': device_add
device: 'ptyz9': device_add
device: 'ptyza': device_add
device: 'ptyzb': device_add
device: 'ptyzc': device_add
device: 'ptyzd': device_add
device: 'ptyze': device_add
device: 'ptyzf': device_add
device: 'ptya0': device_add
device: 'ptya1': device_add
device: 'ptya2': device_add
device: 'ptya3': device_add
device: 'ptya4': device_add
device: 'ptya5': device_add
device: 'ptya6': device_add
device: 'ptya7': device_add
device: 'ptya8': device_add
device: 'ptya9': device_add
device: 'ptyaa': device_add
device: 'ptyab': device_add
device: 'ptyac': device_add
device: 'ptyad': device_add
device: 'ptyae': device_add
device: 'ptyaf': device_add
device: 'ptyb0': device_add
device: 'ptyb1': device_add
device: 'ptyb2': device_add
device: 'ptyb3': device_add
device: 'ptyb4': device_add
device: 'ptyb5': device_add
device: 'ptyb6': device_add
device: 'ptyb7': device_add
device: 'ptyb8': device_add
device: 'ptyb9': device_add
device: 'ptyba': device_add
device: 'ptybb': device_add
device: 'ptybc': device_add
device: 'ptybd': device_add
device: 'ptybe': device_add
device: 'ptybf': device_add
device: 'ptyc0': device_add
device: 'ptyc1': device_add
device: 'ptyc2': device_add
device: 'ptyc3': device_add
device: 'ptyc4': device_add
device: 'ptyc5': device_add
device: 'ptyc6': device_add
device: 'ptyc7': device_add
device: 'ptyc8': device_add
device: 'ptyc9': device_add
device: 'ptyca': device_add
device: 'ptycb': device_add
device: 'ptycc': device_add
device: 'ptycd': device_add
device: 'ptyce': device_add
device: 'ptycf': device_add
device: 'ptyd0': device_add
device: 'ptyd1': device_add
device: 'ptyd2': device_add
device: 'ptyd3': device_add
device: 'ptyd4': device_add
device: 'ptyd5': device_add
device: 'ptyd6': device_add
device: 'ptyd7': device_add
device: 'ptyd8': device_add
device: 'ptyd9': device_add
device: 'ptyda': device_add
device: 'ptydb': device_add
device: 'ptydc': device_add
device: 'ptydd': device_add
device: 'ptyde': device_add
device: 'ptydf': device_add
device: 'ptye0': device_add
device: 'ptye1': device_add
device: 'ptye2': device_add
device: 'ptye3': device_add
device: 'ptye4': device_add
device: 'ptye5': device_add
device: 'ptye6': device_add
device: 'ptye7': device_add
device: 'ptye8': device_add
device: 'ptye9': device_add
device: 'ptyea': device_add
device: 'ptyeb': device_add
device: 'ptyec': device_add
device: 'ptyed': device_add
device: 'ptyee': device_add
device: 'ptyef': device_add
device: 'ttyp0': device_add
device: 'ttyp1': device_add
device: 'ttyp2': device_add
device: 'ttyp3': device_add
device: 'ttyp4': device_add
device: 'ttyp5': device_add
device: 'ttyp6': device_add
device: 'ttyp7': device_add
device: 'ttyp8': device_add
device: 'ttyp9': device_add
device: 'ttypa': device_add
device: 'ttypb': device_add
device: 'ttypc': device_add
device: 'ttypd': device_add
device: 'ttype': device_add
device: 'ttypf': device_add
device: 'ttyq0': device_add
device: 'ttyq1': device_add
device: 'ttyq2': device_add
device: 'ttyq3': device_add
device: 'ttyq4': device_add
device: 'ttyq5': device_add
device: 'ttyq6': device_add
device: 'ttyq7': device_add
device: 'ttyq8': device_add
device: 'ttyq9': device_add
device: 'ttyqa': device_add
device: 'ttyqb': device_add
device: 'ttyqc': device_add
device: 'ttyqd': device_add
device: 'ttyqe': device_add
device: 'ttyqf': device_add
device: 'ttyr0': device_add
device: 'ttyr1': device_add
device: 'ttyr2': device_add
device: 'ttyr3': device_add
device: 'ttyr4': device_add
device: 'ttyr5': device_add
device: 'ttyr6': device_add
device: 'ttyr7': device_add
device: 'ttyr8': device_add
device: 'ttyr9': device_add
device: 'ttyra': device_add
device: 'ttyrb': device_add
device: 'ttyrc': device_add
device: 'ttyrd': device_add
device: 'ttyre': device_add
device: 'ttyrf': device_add
device: 'ttys0': device_add
device: 'ttys1': device_add
device: 'ttys2': device_add
device: 'ttys3': device_add
device: 'ttys4': device_add
device: 'ttys5': device_add
device: 'ttys6': device_add
device: 'ttys7': device_add
device: 'ttys8': device_add
device: 'ttys9': device_add
device: 'ttysa': device_add
device: 'ttysb': device_add
device: 'ttysc': device_add
device: 'ttysd': device_add
device: 'ttyse': device_add
device: 'ttysf': device_add
device: 'ttyt0': device_add
device: 'ttyt1': device_add
device: 'ttyt2': device_add
device: 'ttyt3': device_add
device: 'ttyt4': device_add
device: 'ttyt5': device_add
device: 'ttyt6': device_add
device: 'ttyt7': device_add
device: 'ttyt8': device_add
device: 'ttyt9': device_add
device: 'ttyta': device_add
device: 'ttytb': device_add
device: 'ttytc': device_add
device: 'ttytd': device_add
device: 'ttyte': device_add
device: 'ttytf': device_add
device: 'ttyu0': device_add
device: 'ttyu1': device_add
device: 'ttyu2': device_add
device: 'ttyu3': device_add
device: 'ttyu4': device_add
device: 'ttyu5': device_add
device: 'ttyu6': device_add
device: 'ttyu7': device_add
device: 'ttyu8': device_add
device: 'ttyu9': device_add
device: 'ttyua': device_add
device: 'ttyub': device_add
device: 'ttyuc': device_add
device: 'ttyud': device_add
device: 'ttyue': device_add
device: 'ttyuf': device_add
device: 'ttyv0': device_add
device: 'ttyv1': device_add
device: 'ttyv2': device_add
device: 'ttyv3': device_add
device: 'ttyv4': device_add
device: 'ttyv5': device_add
device: 'ttyv6': device_add
device: 'ttyv7': device_add
device: 'ttyv8': device_add
device: 'ttyv9': device_add
device: 'ttyva': device_add
device: 'ttyvb': device_add
device: 'ttyvc': device_add
device: 'ttyvd': device_add
device: 'ttyve': device_add
device: 'ttyvf': device_add
device: 'ttyw0': device_add
device: 'ttyw1': device_add
device: 'ttyw2': device_add
device: 'ttyw3': device_add
device: 'ttyw4': device_add
device: 'ttyw5': device_add
device: 'ttyw6': device_add
device: 'ttyw7': device_add
device: 'ttyw8': device_add
device: 'ttyw9': device_add
device: 'ttywa': device_add
device: 'ttywb': device_add
device: 'ttywc': device_add
device: 'ttywd': device_add
device: 'ttywe': device_add
device: 'ttywf': device_add
device: 'ttyx0': device_add
device: 'ttyx1': device_add
device: 'ttyx2': device_add
device: 'ttyx3': device_add
device: 'ttyx4': device_add
device: 'ttyx5': device_add
device: 'ttyx6': device_add
device: 'ttyx7': device_add
device: 'ttyx8': device_add
device: 'ttyx9': device_add
device: 'ttyxa': device_add
device: 'ttyxb': device_add
device: 'ttyxc': device_add
device: 'ttyxd': device_add
device: 'ttyxe': device_add
device: 'ttyxf': device_add
device: 'ttyy0': device_add
device: 'ttyy1': device_add
device: 'ttyy2': device_add
device: 'ttyy3': device_add
device: 'ttyy4': device_add
device: 'ttyy5': device_add
device: 'ttyy6': device_add
device: 'ttyy7': device_add
device: 'ttyy8': device_add
device: 'ttyy9': device_add
device: 'ttyya': device_add
device: 'ttyyb': device_add
device: 'ttyyc': device_add
device: 'ttyyd': device_add
device: 'ttyye': device_add
device: 'ttyyf': device_add
device: 'ttyz0': device_add
device: 'ttyz1': device_add
device: 'ttyz2': device_add
device: 'ttyz3': device_add
device: 'ttyz4': device_add
device: 'ttyz5': device_add
device: 'ttyz6': device_add
device: 'ttyz7': device_add
device: 'ttyz8': device_add
device: 'ttyz9': device_add
device: 'ttyza': device_add
device: 'ttyzb': device_add
device: 'ttyzc': device_add
device: 'ttyzd': device_add
device: 'ttyze': device_add
device: 'ttyzf': device_add
device: 'ttya0': device_add
device: 'ttya1': device_add
device: 'ttya2': device_add
device: 'ttya3': device_add
device: 'ttya4': device_add
device: 'ttya5': device_add
device: 'ttya6': device_add
device: 'ttya7': device_add
device: 'ttya8': device_add
device: 'ttya9': device_add
device: 'ttyaa': device_add
device: 'ttyab': device_add
device: 'ttyac': device_add
device: 'ttyad': device_add
device: 'ttyae': device_add
device: 'ttyaf': device_add
device: 'ttyb0': device_add
device: 'ttyb1': device_add
device: 'ttyb2': device_add
device: 'ttyb3': device_add
device: 'ttyb4': device_add
device: 'ttyb5': device_add
device: 'ttyb6': device_add
device: 'ttyb7': device_add
device: 'ttyb8': device_add
device: 'ttyb9': device_add
device: 'ttyba': device_add
device: 'ttybb': device_add
device: 'ttybc': device_add
device: 'ttybd': device_add
device: 'ttybe': device_add
device: 'ttybf': device_add
device: 'ttyc0': device_add
device: 'ttyc1': device_add
device: 'ttyc2': device_add
device: 'ttyc3': device_add
device: 'ttyc4': device_add
device: 'ttyc5': device_add
device: 'ttyc6': device_add
device: 'ttyc7': device_add
device: 'ttyc8': device_add
device: 'ttyc9': device_add
device: 'ttyca': device_add
device: 'ttycb': device_add
device: 'ttycc': device_add
device: 'ttycd': device_add
device: 'ttyce': device_add
device: 'ttycf': device_add
device: 'ttyd0': device_add
device: 'ttyd1': device_add
device: 'ttyd2': device_add
device: 'ttyd3': device_add
device: 'ttyd4': device_add
device: 'ttyd5': device_add
device: 'ttyd6': device_add
device: 'ttyd7': device_add
device: 'ttyd8': device_add
device: 'ttyd9': device_add
device: 'ttyda': device_add
device: 'ttydb': device_add
device: 'ttydc': device_add
device: 'ttydd': device_add
device: 'ttyde': device_add
device: 'ttydf': device_add
device: 'ttye0': device_add
device: 'ttye1': device_add
device: 'ttye2': device_add
device: 'ttye3': device_add
device: 'ttye4': device_add
device: 'ttye5': device_add
device: 'ttye6': device_add
device: 'ttye7': device_add
device: 'ttye8': device_add
device: 'ttye9': device_add
device: 'ttyea': device_add
device: 'ttyeb': device_add
device: 'ttyec': device_add
device: 'ttyed': device_add
device: 'ttyee': device_add
device: 'ttyef': device_add
device: 'ptmx': device_add
initcall pty_init+0x0/0x38 returned 0 after 2226559 usecs
calling  sysrq_init+0x0/0x4b @ 1
initcall sysrq_init+0x0/0x4b returned 0 after 0 usecs
calling  stallion_module_init+0x0/0x375 @ 1
Stallion Multiport Serial Driver: version 5.6.0
bus: 'pci': add driver stallion
device class 'staliomem': registering
device: 'staliomem0': device_add
device: 'staliomem1': device_add
device: 'staliomem2': device_add
device: 'staliomem3': device_add
initcall stallion_module_init+0x0/0x375 returned 0 after 52083 usecs
calling  istallion_module_init+0x0/0x296 @ 1
Stallion Intelligent Multiport Serial Driver: version 5.6.0
istallion: failed to register serial driver
initcall istallion_module_init+0x0/0x296 returned -16 after 6510 usecs
initcall istallion_module_init+0x0/0x296 returned with error code -16 
calling  epca_module_init+0x0/0x2b @ 1
DIGI epca driver version 1.3.0.1-LK2.6 loaded.
bus: 'pci': add driver epca
device: 'ttyD0': device_add
device: 'ttyD1': device_add
device: 'ttyD2': device_add
device: 'ttyD3': device_add
device: 'ttyD4': device_add
device: 'ttyD5': device_add
device: 'ttyD6': device_add
device: 'ttyD7': device_add
device: 'ttyD8': device_add
device: 'ttyD9': device_add
device: 'ttyD10': device_add
device: 'ttyD11': device_add
device: 'ttyD12': device_add
device: 'ttyD13': device_add
device: 'ttyD14': device_add
device: 'ttyD15': device_add
device: 'ttyD16': device_add
device: 'ttyD17': device_add
device: 'ttyD18': device_add
device: 'ttyD19': device_add
device: 'ttyD20': device_add
device: 'ttyD21': device_add
device: 'ttyD22': device_add
device: 'ttyD23': device_add
device: 'ttyD24': device_add
device: 'ttyD25': device_add
device: 'ttyD26': device_add
device: 'ttyD27': device_add
device: 'ttyD28': device_add
device: 'ttyD29': device_add
device: 'ttyD30': device_add
device: 'ttyD31': device_add
device: 'ttyD32': device_add
device: 'ttyD33': device_add
device: 'ttyD34': device_add
device: 'ttyD35': device_add
device: 'ttyD36': device_add
device: 'ttyD37': device_add
device: 'ttyD38': device_add
device: 'ttyD39': device_add
device: 'ttyD40': device_add
device: 'ttyD41': device_add
device: 'ttyD42': device_add
device: 'ttyD43': device_add
device: 'ttyD44': device_add
device: 'ttyD45': device_add
device: 'ttyD46': device_add
device: 'ttyD47': device_add
device: 'ttyD48': device_add
device: 'ttyD49': device_add
device: 'ttyD50': device_add
device: 'ttyD51': device_add
device: 'ttyD52': device_add
device: 'ttyD53': device_add
device: 'ttyD54': device_add
device: 'ttyD55': device_add
device: 'ttyD56': device_add
device: 'ttyD57': device_add
device: 'ttyD58': device_add
device: 'ttyD59': device_add
device: 'ttyD60': device_add
device: 'ttyD61': device_add
device: 'ttyD62': device_add
device: 'ttyD63': device_add
device: 'ttyD64': device_add
device: 'ttyD65': device_add
device: 'ttyD66': device_add
device: 'ttyD67': device_add
device: 'ttyD68': device_add
device: 'ttyD69': device_add
device: 'ttyD70': device_add
device: 'ttyD71': device_add
device: 'ttyD72': device_add
device: 'ttyD73': device_add
device: 'ttyD74': device_add
device: 'ttyD75': device_add
device: 'ttyD76': device_add
device: 'ttyD77': device_add
device: 'ttyD78': device_add
device: 'ttyD79': device_add
device: 'ttyD80': device_add
device: 'ttyD81': device_add
device: 'ttyD82': device_add
device: 'ttyD83': device_add
device: 'ttyD84': device_add
device: 'ttyD85': device_add
device: 'ttyD86': device_add
device: 'ttyD87': device_add
device: 'ttyD88': device_add
device: 'ttyD89': device_add
device: 'ttyD90': device_add
device: 'ttyD91': device_add
device: 'ttyD92': device_add
device: 'ttyD93': device_add
device: 'ttyD94': device_add
device: 'ttyD95': device_add
device: 'ttyD96': device_add
device: 'ttyD97': device_add
device: 'ttyD98': device_add
device: 'ttyD99': device_add
device: 'ttyD100': device_add
device: 'ttyD101': device_add
device: 'ttyD102': device_add
device: 'ttyD103': device_add
device: 'ttyD104': device_add
device: 'ttyD105': device_add
device: 'ttyD106': device_add
device: 'ttyD107': device_add
device: 'ttyD108': device_add
device: 'ttyD109': device_add
device: 'ttyD110': device_add
device: 'ttyD111': device_add
device: 'ttyD112': device_add
device: 'ttyD113': device_add
device: 'ttyD114': device_add
device: 'ttyD115': device_add
device: 'ttyD116': device_add
device: 'ttyD117': device_add
device: 'ttyD118': device_add
device: 'ttyD119': device_add
device: 'ttyD120': device_add
device: 'ttyD121': device_add
device: 'ttyD122': device_add
device: 'ttyD123': device_add
device: 'ttyD124': device_add
device: 'ttyD125': device_add
device: 'ttyD126': device_add
device: 'ttyD127': device_add
device: 'ttyD128': device_add
device: 'ttyD129': device_add
device: 'ttyD130': device_add
device: 'ttyD131': device_add
device: 'ttyD132': device_add
device: 'ttyD133': device_add
device: 'ttyD134': device_add
device: 'ttyD135': device_add
device: 'ttyD136': device_add
device: 'ttyD137': device_add
device: 'ttyD138': device_add
device: 'ttyD139': device_add
device: 'ttyD140': device_add
device: 'ttyD141': device_add
device: 'ttyD142': device_add
device: 'ttyD143': device_add
device: 'ttyD144': device_add
device: 'ttyD145': device_add
device: 'ttyD146': device_add
device: 'ttyD147': device_add
device: 'ttyD148': device_add
device: 'ttyD149': device_add
device: 'ttyD150': device_add
device: 'ttyD151': device_add
device: 'ttyD152': device_add
device: 'ttyD153': device_add
device: 'ttyD154': device_add
device: 'ttyD155': device_add
device: 'ttyD156': device_add
device: 'ttyD157': device_add
device: 'ttyD158': device_add
device: 'ttyD159': device_add
device: 'ttyD160': device_add
device: 'ttyD161': device_add
device: 'ttyD162': device_add
device: 'ttyD163': device_add
device: 'ttyD164': device_add
device: 'ttyD165': device_add
device: 'ttyD166': device_add
device: 'ttyD167': device_add
device: 'ttyD168': device_add
device: 'ttyD169': device_add
device: 'ttyD170': device_add
device: 'ttyD171': device_add
device: 'ttyD172': device_add
device: 'ttyD173': device_add
device: 'ttyD174': device_add
device: 'ttyD175': device_add
device: 'ttyD176': device_add
device: 'ttyD177': device_add
device: 'ttyD178': device_add
device: 'ttyD179': device_add
device: 'ttyD180': device_add
device: 'ttyD181': device_add
device: 'ttyD182': device_add
device: 'ttyD183': device_add
device: 'ttyD184': device_add
device: 'ttyD185': device_add
device: 'ttyD186': device_add
device: 'ttyD187': device_add
device: 'ttyD188': device_add
device: 'ttyD189': device_add
device: 'ttyD190': device_add
device: 'ttyD191': device_add
device: 'ttyD192': device_add
device: 'ttyD193': device_add
device: 'ttyD194': device_add
device: 'ttyD195': device_add
device: 'ttyD196': device_add
device: 'ttyD197': device_add
device: 'ttyD198': device_add
device: 'ttyD199': device_add
device: 'ttyD200': device_add
device: 'ttyD201': device_add
device: 'ttyD202': device_add
device: 'ttyD203': device_add
device: 'ttyD204': device_add
device: 'ttyD205': device_add
device: 'ttyD206': device_add
device: 'ttyD207': device_add
device: 'ttyD208': device_add
device: 'ttyD209': device_add
device: 'ttyD210': device_add
device: 'ttyD211': device_add
device: 'ttyD212': device_add
device: 'ttyD213': device_add
device: 'ttyD214': device_add
device: 'ttyD215': device_add
device: 'ttyD216': device_add
device: 'ttyD217': device_add
device: 'ttyD218': device_add
device: 'ttyD219': device_add
device: 'ttyD220': device_add
device: 'ttyD221': device_add
device: 'ttyD222': device_add
device: 'ttyD223': device_add
device: 'ttyD224': device_add
device: 'ttyD225': device_add
device: 'ttyD226': device_add
device: 'ttyD227': device_add
device: 'ttyD228': device_add
device: 'ttyD229': device_add
device: 'ttyD230': device_add
device: 'ttyD231': device_add
device: 'ttyD232': device_add
device: 'ttyD233': device_add
device: 'ttyD234': device_add
device: 'ttyD235': device_add
device: 'ttyD236': device_add
device: 'ttyD237': device_add
device: 'ttyD238': device_add
device: 'ttyD239': device_add
device: 'ttyD240': device_add
device: 'ttyD241': device_add
device: 'ttyD242': device_add
device: 'ttyD243': device_add
device: 'ttyD244': device_add
device: 'ttyD245': device_add
device: 'ttyD246': device_add
device: 'ttyD247': device_add
device: 'ttyD248': device_add
device: 'ttyD249': device_add
device: 'ttyD250': device_add
device: 'ttyD251': device_add
device: 'ttyD252': device_add
device: 'ttyD253': device_add
device: 'ttyD254': device_add
device: 'ttyD255': device_add
device: 'digi_ctl0': device_add
device: 'digi_ctl1': device_add
device: 'digi_ctl2': device_add
device: 'digi_ctl3': device_add
device: 'digi_ctl4': device_add
device: 'digi_ctl5': device_add
device: 'digi_ctl6': device_add
device: 'digi_ctl7': device_add
device: 'digi_ctl8': device_add
device: 'digi_ctl9': device_add
device: 'digi_ctl10': device_add
device: 'digi_ctl11': device_add
device: 'digi_ctl12': device_add
device: 'digi_ctl13': device_add
device: 'digi_ctl14': device_add
device: 'digi_ctl15': device_add
device: 'digi_ctl16': device_add
device: 'digi_ctl17': device_add
device: 'digi_ctl18': device_add
device: 'digi_ctl19': device_add
device: 'digi_ctl20': device_add
device: 'digi_ctl21': device_add
device: 'digi_ctl22': device_add
device: 'digi_ctl23': device_add
device: 'digi_ctl24': device_add
device: 'digi_ctl25': device_add
device: 'digi_ctl26': device_add
device: 'digi_ctl27': device_add
device: 'digi_ctl28': device_add
device: 'digi_ctl29': device_add
device: 'digi_ctl30': device_add
device: 'digi_ctl31': device_add
device: 'digi_ctl32': device_add
device: 'digi_ctl33': device_add
device: 'digi_ctl34': device_add
device: 'digi_ctl35': device_add
device: 'digi_ctl36': device_add
device: 'digi_ctl37': device_add
device: 'digi_ctl38': device_add
device: 'digi_ctl39': device_add
device: 'digi_ctl40': device_add
device: 'digi_ctl41': device_add
device: 'digi_ctl42': device_add
device: 'digi_ctl43': device_add
device: 'digi_ctl44': device_add
device: 'digi_ctl45': device_add
device: 'digi_ctl46': device_add
device: 'digi_ctl47': device_add
device: 'digi_ctl48': device_add
device: 'digi_ctl49': device_add
device: 'digi_ctl50': device_add
device: 'digi_ctl51': device_add
device: 'digi_ctl52': device_add
device: 'digi_ctl53': device_add
device: 'digi_ctl54': device_add
device: 'digi_ctl55': device_add
device: 'digi_ctl56': device_add
device: 'digi_ctl57': device_add
device: 'digi_ctl58': device_add
device: 'digi_ctl59': device_add
device: 'digi_ctl60': device_add
device: 'digi_ctl61': device_add
device: 'digi_ctl62': device_add
device: 'digi_ctl63': device_add
device: 'digi_ctl64': device_add
device: 'digi_ctl65': device_add
device: 'digi_ctl66': device_add
device: 'digi_ctl67': device_add
device: 'digi_ctl68': device_add
device: 'digi_ctl69': device_add
device: 'digi_ctl70': device_add
device: 'digi_ctl71': device_add
device: 'digi_ctl72': device_add
device: 'digi_ctl73': device_add
device: 'digi_ctl74': device_add
device: 'digi_ctl75': device_add
device: 'digi_ctl76': device_add
device: 'digi_ctl77': device_add
device: 'digi_ctl78': device_add
device: 'digi_ctl79': device_add
device: 'digi_ctl80': device_add
device: 'digi_ctl81': device_add
device: 'digi_ctl82': device_add
device: 'digi_ctl83': device_add
device: 'digi_ctl84': device_add
device: 'digi_ctl85': device_add
device: 'digi_ctl86': device_add
device: 'digi_ctl87': device_add
device: 'digi_ctl88': device_add
device: 'digi_ctl89': device_add
device: 'digi_ctl90': device_add
device: 'digi_ctl91': device_add
device: 'digi_ctl92': device_add
device: 'digi_ctl93': device_add
device: 'digi_ctl94': device_add
device: 'digi_ctl95': device_add
device: 'digi_ctl96': device_add
device: 'digi_ctl97': device_add
device: 'digi_ctl98': device_add
device: 'digi_ctl99': device_add
device: 'digi_ctl100': device_add
device: 'digi_ctl101': device_add
device: 'digi_ctl102': device_add
device: 'digi_ctl103': device_add
device: 'digi_ctl104': device_add
device: 'digi_ctl105': device_add
device: 'digi_ctl106': device_add
device: 'digi_ctl107': device_add
device: 'digi_ctl108': device_add
device: 'digi_ctl109': device_add
device: 'digi_ctl110': device_add
device: 'digi_ctl111': device_add
device: 'digi_ctl112': device_add
device: 'digi_ctl113': device_add
device: 'digi_ctl114': device_add
device: 'digi_ctl115': device_add
device: 'digi_ctl116': device_add
device: 'digi_ctl117': device_add
device: 'digi_ctl118': device_add
device: 'digi_ctl119': device_add
device: 'digi_ctl120': device_add
device: 'digi_ctl121': device_add
device: 'digi_ctl122': device_add
device: 'digi_ctl123': device_add
device: 'digi_ctl124': device_add
device: 'digi_ctl125': device_add
device: 'digi_ctl126': device_add
device: 'digi_ctl127': device_add
device: 'digi_ctl128': device_add
device: 'digi_ctl129': device_add
device: 'digi_ctl130': device_add
device: 'digi_ctl131': device_add
device: 'digi_ctl132': device_add
device: 'digi_ctl133': device_add
device: 'digi_ctl134': device_add
device: 'digi_ctl135': device_add
device: 'digi_ctl136': device_add
device: 'digi_ctl137': device_add
device: 'digi_ctl138': device_add
device: 'digi_ctl139': device_add
device: 'digi_ctl140': device_add
device: 'digi_ctl141': device_add
device: 'digi_ctl142': device_add
device: 'digi_ctl143': device_add
device: 'digi_ctl144': device_add
device: 'digi_ctl145': device_add
device: 'digi_ctl146': device_add
device: 'digi_ctl147': device_add
device: 'digi_ctl148': device_add
device: 'digi_ctl149': device_add
device: 'digi_ctl150': device_add
device: 'digi_ctl151': device_add
device: 'digi_ctl152': device_add
device: 'digi_ctl153': device_add
device: 'digi_ctl154': device_add
device: 'digi_ctl155': device_add
device: 'digi_ctl156': device_add
device: 'digi_ctl157': device_add
device: 'digi_ctl158': device_add
device: 'digi_ctl159': device_add
device: 'digi_ctl160': device_add
device: 'digi_ctl161': device_add
device: 'digi_ctl162': device_add
device: 'digi_ctl163': device_add
device: 'digi_ctl164': device_add
device: 'digi_ctl165': device_add
device: 'digi_ctl166': device_add
device: 'digi_ctl167': device_add
device: 'digi_ctl168': device_add
device: 'digi_ctl169': device_add
device: 'digi_ctl170': device_add
device: 'digi_ctl171': device_add
device: 'digi_ctl172': device_add
device: 'digi_ctl173': device_add
device: 'digi_ctl174': device_add
device: 'digi_ctl175': device_add
device: 'digi_ctl176': device_add
device: 'digi_ctl177': device_add
device: 'digi_ctl178': device_add
device: 'digi_ctl179': device_add
device: 'digi_ctl180': device_add
device: 'digi_ctl181': device_add
device: 'digi_ctl182': device_add
device: 'digi_ctl183': device_add
device: 'digi_ctl184': device_add
device: 'digi_ctl185': device_add
device: 'digi_ctl186': device_add
device: 'digi_ctl187': device_add
device: 'digi_ctl188': device_add
device: 'digi_ctl189': device_add
device: 'digi_ctl190': device_add
device: 'digi_ctl191': device_add
device: 'digi_ctl192': device_add
device: 'digi_ctl193': device_add
device: 'digi_ctl194': device_add
device: 'digi_ctl195': device_add
device: 'digi_ctl196': device_add
device: 'digi_ctl197': device_add
device: 'digi_ctl198': device_add
device: 'digi_ctl199': device_add
device: 'digi_ctl200': device_add
device: 'digi_ctl201': device_add
device: 'digi_ctl202': device_add
device: 'digi_ctl203': device_add
device: 'digi_ctl204': device_add
device: 'digi_ctl205': device_add
device: 'digi_ctl206': device_add
device: 'digi_ctl207': device_add
device: 'digi_ctl208': device_add
device: 'digi_ctl209': device_add
device: 'digi_ctl210': device_add
device: 'digi_ctl211': device_add
device: 'digi_ctl212': device_add
device: 'digi_ctl213': device_add
device: 'digi_ctl214': device_add
device: 'digi_ctl215': device_add
device: 'digi_ctl216': device_add
device: 'digi_ctl217': device_add
device: 'digi_ctl218': device_add
device: 'digi_ctl219': device_add
device: 'digi_ctl220': device_add
device: 'digi_ctl221': device_add
device: 'digi_ctl222': device_add
device: 'digi_ctl223': device_add
device: 'digi_ctl224': device_add
device: 'digi_ctl225': device_add
device: 'digi_ctl226': device_add
device: 'digi_ctl227': device_add
device: 'digi_ctl228': device_add
device: 'digi_ctl229': device_add
device: 'digi_ctl230': device_add
device: 'digi_ctl231': device_add
device: 'digi_ctl232': device_add
device: 'digi_ctl233': device_add
device: 'digi_ctl234': device_add
device: 'digi_ctl235': device_add
device: 'digi_ctl236': device_add
device: 'digi_ctl237': device_add
device: 'digi_ctl238': device_add
device: 'digi_ctl239': device_add
device: 'digi_ctl240': device_add
device: 'digi_ctl241': device_add
device: 'digi_ctl242': device_add
device: 'digi_ctl243': device_add
device: 'digi_ctl244': device_add
device: 'digi_ctl245': device_add
device: 'digi_ctl246': device_add
device: 'digi_ctl247': device_add
device: 'digi_ctl248': device_add
device: 'digi_ctl249': device_add
device: 'digi_ctl250': device_add
device: 'digi_ctl251': device_add
device: 'digi_ctl252': device_add
device: 'digi_ctl253': device_add
device: 'digi_ctl254': device_add
device: 'digi_ctl255': device_add
initcall epca_module_init+0x0/0x2b returned 0 after 2141924 usecs
calling  moxa_init+0x0/0x158 @ 1
MOXA Intellio family driver version 6.0k
device: 'ttyMX0': device_add
device: 'ttyMX1': device_add
device: 'ttyMX2': device_add
device: 'ttyMX3': device_add
device: 'ttyMX4': device_add
device: 'ttyMX5': device_add
device: 'ttyMX6': device_add
device: 'ttyMX7': device_add
device: 'ttyMX8': device_add
device: 'ttyMX9': device_add
device: 'ttyMX10': device_add
device: 'ttyMX11': device_add
device: 'ttyMX12': device_add
device: 'ttyMX13': device_add
device: 'ttyMX14': device_add
device: 'ttyMX15': device_add
device: 'ttyMX16': device_add
device: 'ttyMX17': device_add
device: 'ttyMX18': device_add
device: 'ttyMX19': device_add
device: 'ttyMX20': device_add
device: 'ttyMX21': device_add
device: 'ttyMX22': device_add
device: 'ttyMX23': device_add
device: 'ttyMX24': device_add
device: 'ttyMX25': device_add
device: 'ttyMX26': device_add
device: 'ttyMX27': device_add
device: 'ttyMX28': device_add
device: 'ttyMX29': device_add
device: 'ttyMX30': device_add
device: 'ttyMX31': device_add
device: 'ttyMX32': device_add
device: 'ttyMX33': device_add
device: 'ttyMX34': device_add
device: 'ttyMX35': device_add
device: 'ttyMX36': device_add
device: 'ttyMX37': device_add
device: 'ttyMX38': device_add
device: 'ttyMX39': device_add
device: 'ttyMX40': device_add
device: 'ttyMX41': device_add
device: 'ttyMX42': device_add
device: 'ttyMX43': device_add
device: 'ttyMX44': device_add
device: 'ttyMX45': device_add
device: 'ttyMX46': device_add
device: 'ttyMX47': device_add
device: 'ttyMX48': device_add
device: 'ttyMX49': device_add
device: 'ttyMX50': device_add
device: 'ttyMX51': device_add
device: 'ttyMX52': device_add
device: 'ttyMX53': device_add
device: 'ttyMX54': device_add
device: 'ttyMX55': device_add
device: 'ttyMX56': device_add
device: 'ttyMX57': device_add
device: 'ttyMX58': device_add
device: 'ttyMX59': device_add
device: 'ttyMX60': device_add
device: 'ttyMX61': device_add
device: 'ttyMX62': device_add
device: 'ttyMX63': device_add
device: 'ttyMX64': device_add
device: 'ttyMX65': device_add
device: 'ttyMX66': device_add
device: 'ttyMX67': device_add
device: 'ttyMX68': device_add
device: 'ttyMX69': device_add
device: 'ttyMX70': device_add
device: 'ttyMX71': device_add
device: 'ttyMX72': device_add
device: 'ttyMX73': device_add
device: 'ttyMX74': device_add
device: 'ttyMX75': device_add
device: 'ttyMX76': device_add
device: 'ttyMX77': device_add
device: 'ttyMX78': device_add
device: 'ttyMX79': device_add
device: 'ttyMX80': device_add
device: 'ttyMX81': device_add
device: 'ttyMX82': device_add
device: 'ttyMX83': device_add
device: 'ttyMX84': device_add
device: 'ttyMX85': device_add
device: 'ttyMX86': device_add
device: 'ttyMX87': device_add
device: 'ttyMX88': device_add
device: 'ttyMX89': device_add
device: 'ttyMX90': device_add
device: 'ttyMX91': device_add
device: 'ttyMX92': device_add
device: 'ttyMX93': device_add
device: 'ttyMX94': device_add
device: 'ttyMX95': device_add
device: 'ttyMX96': device_add
device: 'ttyMX97': device_add
device: 'ttyMX98': device_add
device: 'ttyMX99': device_add
device: 'ttyMX100': device_add
device: 'ttyMX101': device_add
device: 'ttyMX102': device_add
device: 'ttyMX103': device_add
device: 'ttyMX104': device_add
device: 'ttyMX105': device_add
device: 'ttyMX106': device_add
device: 'ttyMX107': device_add
device: 'ttyMX108': device_add
device: 'ttyMX109': device_add
device: 'ttyMX110': device_add
device: 'ttyMX111': device_add
device: 'ttyMX112': device_add
device: 'ttyMX113': device_add
device: 'ttyMX114': device_add
device: 'ttyMX115': device_add
device: 'ttyMX116': device_add
device: 'ttyMX117': device_add
device: 'ttyMX118': device_add
device: 'ttyMX119': device_add
device: 'ttyMX120': device_add
device: 'ttyMX121': device_add
device: 'ttyMX122': device_add
device: 'ttyMX123': device_add
device: 'ttyMX124': device_add
device: 'ttyMX125': device_add
device: 'ttyMX126': device_add
device: 'ttyMX127': device_add
device: 'ttyMX128': device_add
bus: 'pci': add driver moxa
initcall moxa_init+0x0/0x158 returned 0 after 458983 usecs
calling  isicom_init+0x0/0x23a @ 1
bus: 'pci': add driver isicom
initcall isicom_init+0x0/0x23a returned 0 after 3255 usecs
calling  synclink_init+0x0/0x180 @ 1
SyncLink serial driver $Revision: 4.38 $
bus: 'pci': add driver synclink
device: 'ttySL0': device_add
device: 'ttySL1': device_add
device: 'ttySL2': device_add
device: 'ttySL3': device_add
device: 'ttySL4': device_add
device: 'ttySL5': device_add
device: 'ttySL6': device_add
device: 'ttySL7': device_add
device: 'ttySL8': device_add
device: 'ttySL9': device_add
device: 'ttySL10': device_add
device: 'ttySL11': device_add
device: 'ttySL12': device_add
device: 'ttySL13': device_add
device: 'ttySL14': device_add
device: 'ttySL15': device_add
device: 'ttySL16': device_add
device: 'ttySL17': device_add
device: 'ttySL18': device_add
device: 'ttySL19': device_add
device: 'ttySL20': device_add
device: 'ttySL21': device_add
device: 'ttySL22': device_add
device: 'ttySL23': device_add
device: 'ttySL24': device_add
device: 'ttySL25': device_add
device: 'ttySL26': device_add
device: 'ttySL27': device_add
device: 'ttySL28': device_add
device: 'ttySL29': device_add
device: 'ttySL30': device_add
device: 'ttySL31': device_add
device: 'ttySL32': device_add
device: 'ttySL33': device_add
device: 'ttySL34': device_add
device: 'ttySL35': device_add
device: 'ttySL36': device_add
device: 'ttySL37': device_add
device: 'ttySL38': device_add
device: 'ttySL39': device_add
device: 'ttySL40': device_add
device: 'ttySL41': device_add
device: 'ttySL42': device_add
device: 'ttySL43': device_add
device: 'ttySL44': device_add
device: 'ttySL45': device_add
device: 'ttySL46': device_add
device: 'ttySL47': device_add
device: 'ttySL48': device_add
device: 'ttySL49': device_add
device: 'ttySL50': device_add
device: 'ttySL51': device_add
device: 'ttySL52': device_add
device: 'ttySL53': device_add
device: 'ttySL54': device_add
device: 'ttySL55': device_add
device: 'ttySL56': device_add
device: 'ttySL57': device_add
device: 'ttySL58': device_add
device: 'ttySL59': device_add
device: 'ttySL60': device_add
device: 'ttySL61': device_add
device: 'ttySL62': device_add
device: 'ttySL63': device_add
device: 'ttySL64': device_add
device: 'ttySL65': device_add
device: 'ttySL66': device_add
device: 'ttySL67': device_add
device: 'ttySL68': device_add
device: 'ttySL69': device_add
device: 'ttySL70': device_add
device: 'ttySL71': device_add
device: 'ttySL72': device_add
device: 'ttySL73': device_add
device: 'ttySL74': device_add
device: 'ttySL75': device_add
device: 'ttySL76': device_add
device: 'ttySL77': device_add
device: 'ttySL78': device_add
device: 'ttySL79': device_add
device: 'ttySL80': device_add
device: 'ttySL81': device_add
device: 'ttySL82': device_add
device: 'ttySL83': device_add
device: 'ttySL84': device_add
device: 'ttySL85': device_add
device: 'ttySL86': device_add
device: 'ttySL87': device_add
device: 'ttySL88': device_add
device: 'ttySL89': device_add
device: 'ttySL90': device_add
device: 'ttySL91': device_add
device: 'ttySL92': device_add
device: 'ttySL93': device_add
device: 'ttySL94': device_add
device: 'ttySL95': device_add
device: 'ttySL96': device_add
device: 'ttySL97': device_add
device: 'ttySL98': device_add
device: 'ttySL99': device_add
device: 'ttySL100': device_add
device: 'ttySL101': device_add
device: 'ttySL102': device_add
device: 'ttySL103': device_add
device: 'ttySL104': device_add
device: 'ttySL105': device_add
device: 'ttySL106': device_add
device: 'ttySL107': device_add
device: 'ttySL108': device_add
device: 'ttySL109': device_add
device: 'ttySL110': device_add
device: 'ttySL111': device_add
device: 'ttySL112': device_add
device: 'ttySL113': device_add
device: 'ttySL114': device_add
device: 'ttySL115': device_add
device: 'ttySL116': device_add
device: 'ttySL117': device_add
device: 'ttySL118': device_add
device: 'ttySL119': device_add
device: 'ttySL120': device_add
device: 'ttySL121': device_add
device: 'ttySL122': device_add
device: 'ttySL123': device_add
device: 'ttySL124': device_add
device: 'ttySL125': device_add
device: 'ttySL126': device_add
device: 'ttySL127': device_add
SyncLink serial driver $Revision: 4.38 $, tty major#252
initcall synclink_init+0x0/0x180 returned 0 after 468749 usecs
calling  raw_init+0x0/0xfb @ 1
device class 'raw': registering
device: 'rawctl': device_add
initcall raw_init+0x0/0xfb returned 0 after 6510 usecs
calling  nvram_init+0x0/0x9b @ 1
device: 'nvram': device_add
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x9b returned 0 after 6510 usecs
calling  cs5535_gpio_init+0x0/0x1ad @ 1
cs5535_gpio: DIVIL not found
initcall cs5535_gpio_init+0x0/0x1ad returned -19 after 3255 usecs
calling  mwave_init+0x0/0x350 @ 1
smapi::smapi_init, ERROR invalid usSmapiID
mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
mwave: mwavedd::mwave_init: Error: Failed to initialize board data
mwave: mwavedd::mwave_init: Error: Failed to initialize
initcall mwave_init+0x0/0x350 returned -5 after 13020 usecs
initcall mwave_init+0x0/0x350 returned with error code -5 
calling  drm_core_init+0x0/0x160 @ 1
device class 'drm': registering
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x160 returned 0 after 6510 usecs
calling  serial8250_init+0x0/0x15a @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Registering platform device 'serial8250'. Parent at platform
device: 'serial8250': device_add
bus: 'platform': add device serial8250
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
device: 'ttyS1': device_add
device: 'ttyS2': device_add
device: 'ttyS3': device_add
bus: 'platform': add driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
driver: 'serial8250': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
initcall serial8250_init+0x0/0x15a returned 0 after 305988 usecs
calling  serial8250_pnp_init+0x0/0x40 @ 1
bus: 'pnp': add driver serial
bus: 'pnp': driver_probe_device: matched device 00:0b with driver serial
bus: 'pnp': really_probe: probing driver serial with device 00:0b
device: 'ttyS0': device_unregister
device: 'ttyS0': device_create_release
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
driver: '00:0b': driver_bound: bound to device 'serial'
bus: 'pnp': really_probe: bound device 00:0b to driver serial
initcall serial8250_pnp_init+0x0/0x40 returned 0 after 35807 usecs
calling  serial8250_pci_init+0x0/0x40 @ 1
bus: 'pci': add driver serial
initcall serial8250_pci_init+0x0/0x40 returned 0 after 6510 usecs
calling  exar_init+0x0/0x40 @ 1
Registering platform device 'serial8250.6'. Parent at platform
device: 'serial8250.6': device_add
bus: 'platform': add device serial8250.6
bus: 'platform': driver_probe_device: matched device serial8250.6 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250.6
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
driver: 'serial8250.6': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250.6 to driver serial8250
initcall exar_init+0x0/0x40 returned 0 after 71614 usecs
calling  hub6_init+0x0/0x40 @ 1
Registering platform device 'serial8250.7'. Parent at platform
device: 'serial8250.7': device_add
bus: 'platform': add device serial8250.7
bus: 'platform': driver_probe_device: matched device serial8250.7 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250.7
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
device: 'ttyS1': device_unregister
device: 'ttyS1': device_create_release
device: 'ttyS1': device_add
driver: 'serial8250.7': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250.7 to driver serial8250
initcall hub6_init+0x0/0x40 returned 0 after 169270 usecs
calling  mca_init+0x0/0x45 @ 1
initcall mca_init+0x0/0x45 returned -19 after 0 usecs
calling  parport_default_proc_register+0x0/0x3b @ 1
initcall parport_default_proc_register+0x0/0x3b returned 0 after 0 usecs
calling  isa_bus_init+0x0/0x57 @ 1
bus: 'isa': registered
device: 'isa': device_add
initcall isa_bus_init+0x0/0x57 returned 0 after 3255 usecs
calling  topology_sysfs_init+0x0/0xa0 @ 1
initcall topology_sysfs_init+0x0/0xa0 returned 0 after 0 usecs
calling  floppy_init+0x0/0x5ae @ 1
bus: 'platform': add driver floppy
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
Registering platform device 'floppy.0'. Parent at platform
device: 'floppy.0': device_add
bus: 'platform': add device floppy.0
bus: 'platform': driver_probe_device: matched device floppy.0 with driver floppy
bus: 'platform': really_probe: probing driver floppy with device floppy.0
driver: 'floppy.0': driver_bound: bound to device 'floppy'
bus: 'platform': really_probe: bound device floppy.0 to driver floppy
device: 'fd0': device_add
device: '2:0': device_add
initcall floppy_init+0x0/0x5ae returned 0 after 55338 usecs
calling  cpqarray_init+0x0/0x83 @ 1
Compaq SMART2 Driver (v 2.6.0)
bus: 'pci': add driver cpqarray
bus: 'pci': remove driver cpqarray
driver: 'cpqarray': driver_release
initcall cpqarray_init+0x0/0x83 returned -19 after 13020 usecs
calling  mm_init+0x0/0x1b0 @ 1
bus: 'pci': add driver umem
MM: desc_per_page = 128
initcall mm_init+0x0/0x1b0 returned 0 after 6510 usecs
calling  init+0x0/0x45 @ 1
bus: 'virtio': add driver virtio_blk
initcall init+0x0/0x45 returned 0 after 3255 usecs
calling  tifm_7xx1_init+0x0/0x40 @ 1
bus: 'pci': add driver tifm_7xx1
initcall tifm_7xx1_init+0x0/0x40 returned 0 after 3255 usecs
calling  init_kgdbts+0x0/0x3d @ 1
initcall init_kgdbts+0x0/0x3d returned 0 after 0 usecs
calling  ilo_init+0x0/0xa3 @ 1
device class 'iLO': registering
bus: 'pci': add driver hpilo
initcall ilo_init+0x0/0xa3 returned 0 after 6510 usecs
calling  isl29003_init+0x0/0x40 @ 1
bus: 'i2c': add driver isl29003
i2c-core: driver [isl29003] registered
initcall isl29003_init+0x0/0x40 returned 0 after 6510 usecs
calling  eeprom_init+0x0/0x40 @ 1
bus: 'i2c': add driver eeprom
i2c-core: driver [eeprom] registered
initcall eeprom_init+0x0/0x40 returned 0 after 6510 usecs
calling  max6875_init+0x0/0x40 @ 1
bus: 'i2c': add driver max6875
i2c-core: driver [max6875] registered
initcall max6875_init+0x0/0x40 returned 0 after 6510 usecs
calling  mac_hid_init+0x0/0xdb @ 1
device: 'input0': device_add
input: Macintosh mouse button emulation as /class/input/input0
initcall mac_hid_init+0x0/0xdb returned 0 after 6510 usecs
calling  spi_transport_init+0x0/0xa0 @ 1
device class 'spi_transport': registering
device class 'spi_host': registering
initcall spi_transport_init+0x0/0xa0 returned 0 after 6510 usecs
calling  fc_transport_init+0x0/0x70 @ 1
device class 'fc_host': registering
device class 'fc_vports': registering
device class 'fc_remote_ports': registering
device class 'fc_transport': registering
initcall fc_transport_init+0x0/0x70 returned 0 after 16276 usecs
calling  iscsi_transport_init+0x0/0x16a @ 1
Loading iSCSI transport class v2.0-870.
device class 'iscsi_transport': registering
device class 'iscsi_endpoint': registering
device class 'iscsi_host': registering
device class 'iscsi_connection': registering
device class 'iscsi_session': registering
initcall iscsi_transport_init+0x0/0x16a returned 0 after 19531 usecs
calling  sas_transport_init+0x0/0xc6 @ 1
device class 'sas_host': registering
device class 'sas_phy': registering
device class 'sas_port': registering
device class 'sas_device': registering
device class 'sas_end_device': registering
device class 'sas_expander': registering
initcall sas_transport_init+0x0/0xc6 returned 0 after 22786 usecs
calling  sas_class_init+0x0/0x60 @ 1
initcall sas_class_init+0x0/0x60 returned 0 after 0 usecs
calling  scsi_dh_init+0x0/0x60 @ 1
initcall scsi_dh_init+0x0/0x60 returned 0 after 0 usecs
calling  hp_sw_init+0x0/0x40 @ 1
hp_sw: device handler registered
initcall hp_sw_init+0x0/0x40 returned 0 after 3255 usecs
calling  libfc_init+0x0/0xa0 @ 1
initcall libfc_init+0x0/0xa0 returned 0 after 3255 usecs
calling  adpt_init+0x0/0xb0 @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0xb0 returned -19 after 6510 usecs
calling  ahc_linux_init+0x0/0x8d @ 1
bus: 'pci': add driver aic7xxx
bus: 'eisa': add driver aic7xxx
initcall ahc_linux_init+0x0/0x8d returned 0 after 6510 usecs
calling  init_this_scsi_driver+0x0/0x113 @ 1
initcall init_this_scsi_driver+0x0/0x113 returned -19 after 3255 usecs
calling  NCR_Q720_init+0x0/0x4d @ 1
initcall NCR_Q720_init+0x0/0x4d returned 0 after 0 usecs
calling  qlogicfas408_init+0x0/0x2c @ 1
initcall qlogicfas408_init+0x0/0x2c returned 0 after 0 usecs
calling  qlogicfas_init+0x0/0x8a @ 1
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= optionsinitcall qlogicfas_init+0x0/0x8a returned -19 after 3255 usecs
calling  qla2x00_module_init+0x0/0x146 @ 1
QLogic Fibre Channel HBA Driver: 8.03.01-k4
bus: 'pci': add driver qla2xxx
initcall qla2x00_module_init+0x0/0x146 returned 0 after 6510 usecs
calling  qla4xxx_module_init+0x0/0x100 @ 1
device: 'qla4xxx': device_add
iscsi: registered transport (qla4xxx)
bus: 'pci': add driver qla4xxx
QLogic iSCSI HBA Driver
initcall qla4xxx_module_init+0x0/0x100 returned 0 after 13020 usecs
calling  ibmmca_init+0x0/0x35 @ 1
initcall ibmmca_init+0x0/0x35 returned 0 after 0 usecs
calling  init_this_scsi_driver+0x0/0x10b @ 1
initcall init_this_scsi_driver+0x0/0x10b returned -19 after 55338 usecs
calling  dc395x_module_init+0x0/0x35 @ 1
bus: 'pci': add driver dc395x
initcall dc395x_module_init+0x0/0x35 returned 0 after 3255 usecs
calling  mraid_mm_init+0x0/0xab @ 1
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
device: 'megadev0': device_add
initcall mraid_mm_init+0x0/0xab returned 0 after 6510 usecs
calling  gdth_init+0x0/0x15c @ 1
GDT-HA: Storage RAID Controller Driver. Version: 3.05
bus: 'pci': add driver gdth
initcall gdth_init+0x0/0x15c returned 0 after 6510 usecs
calling  ipr_init+0x0/0x60 @ 1
ipr: IBM Power RAID SCSI Device Driver version: 2.4.3 (June 10, 2009)
bus: 'pci': add driver ipr
initcall ipr_init+0x0/0x60 returned 0 after 6510 usecs
calling  cxgb3i_init_module+0x0/0x60 @ 1
cxgb3i: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
device: 'cxgb3i': device_add
iscsi: registered transport (cxgb3i)
initcall cxgb3i_init_module+0x0/0x60 returned 0 after 6510 usecs
calling  init_sd+0x0/0x130 @ 1
device class 'scsi_disk': registering
bus: 'scsi': add driver sd
initcall init_sd+0x0/0x130 returned 0 after 6510 usecs
calling  ahci_init+0x0/0x40 @ 1
bus: 'pci': add driver ahci
initcall ahci_init+0x0/0x40 returned 0 after 3255 usecs
calling  piix_init+0x0/0x50 @ 1
bus: 'pci': add driver ata_piix
initcall piix_init+0x0/0x50 returned 0 after 3255 usecs
calling  qs_ata_init+0x0/0x40 @ 1
bus: 'pci': add driver sata_qstor
initcall qs_ata_init+0x0/0x40 returned 0 after 3255 usecs
calling  sil_init+0x0/0x40 @ 1
bus: 'pci': add driver sata_sil
initcall sil_init+0x0/0x40 returned 0 after 3255 usecs
calling  nv_init+0x0/0x35 @ 1
bus: 'pci': add driver sata_nv
initcall nv_init+0x0/0x35 returned 0 after 3255 usecs
calling  mv_init+0x0/0x6b @ 1
bus: 'pci': add driver sata_mv
bus: 'platform': add driver sata_mv
initcall mv_init+0x0/0x6b returned 0 after 6510 usecs
calling  inic_init+0x0/0x40 @ 1
bus: 'pci': add driver sata_inic162x
initcall inic_init+0x0/0x40 returned 0 after 3255 usecs
calling  amd_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_amd
bus: 'pci': driver_probe_device: matched device 0000:00:06.0 with driver pata_amd
bus: 'pci': really_probe: probing driver pata_amd with device 0000:00:06.0
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
device: 'host0': device_add
device: 'host0': device_add
scsi1 : pata_amd
device: 'host1': device_add
device: 'host1': device_add
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f07f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1.00: configured for UDMA/100
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
device: 'target0:0:0': device_add
device: '0:0:0:0': device_add
bus: 'scsi': add device 0:0:0:0
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
device: '0:0:0:0': device_add
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device: 'sda': device_add
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
device: 'sda1': device_add
device: 'sda2': device_add
device: 'sda3': device_add
device: 'sda5': device_add
device: 'sda6': device_add
device: 'sda7': device_add
device: 'sda8': device_add
device: 'sda9': device_add
device: 'sda10': device_add
device: '8:0': device_add
sd 0:0:0:0: [sda] Attached SCSI disk
driver: '0:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
device: '0:0:0:0': device_add
async_waiting @ 1
async_continuing @ 1 after 0 usec
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x707f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2.01: configured for UDMA/33
async_waiting @ 1
async_continuing @ 1 after 0 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
device: 'target1:0:1': device_add
device: '1:0:1:0': device_add
bus: 'scsi': add device 1:0:1:0
bus: 'scsi': driver_probe_device: matched device 1:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 1:0:1:0
device: '1:0:1:0': device_add
driver: '0000:00:06.0': driver_bound: bound to device 'pata_amd'
bus: 'pci': really_probe: bound device 0000:00:06.0 to driver pata_amd
initcall amd_init+0x0/0x40 returned 0 after 699868 usecs
calling  cmd640_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_cmd640
initcall cmd640_init+0x0/0x40 returned 0 after 3255 usecs
calling  cmd64x_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_cmd64x
initcall cmd64x_init+0x0/0x40 returned 0 after 3255 usecs
calling  cs5535_init+0x0/0x40 @ 1
bus: 'pci': add driver cs5535
initcall cs5535_init+0x0/0x40 returned 0 after 3255 usecs
calling  efar_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_efar
initcall efar_init+0x0/0x40 returned 0 after 3255 usecs
calling  hpt36x_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_hpt366
initcall hpt36x_init+0x0/0x40 returned 0 after 3255 usecs
calling  hpt37x_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_hpt37x
initcall hpt37x_init+0x0/0x40 returned 0 after 3255 usecs
calling  it821x_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_it821x
initcall it821x_init+0x0/0x40 returned 0 after 6510 usecs
calling  jmicron_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_jmicron
initcall jmicron_init+0x0/0x40 returned 0 after 3255 usecs
calling  oldpiix_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_oldpiix
initcall oldpiix_init+0x0/0x40 returned 0 after 3255 usecs
calling  pdc202xx_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_pdc202xx_old
initcall pdc202xx_init+0x0/0x40 returned 0 after 6510 usecs
calling  rdc_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_rdc
initcall rdc_init+0x0/0x40 returned 0 after 3255 usecs
calling  rz1000_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_rz1000
initcall rz1000_init+0x0/0x40 returned 0 after 3255 usecs
calling  serverworks_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_serverworks
initcall serverworks_init+0x0/0x40 returned 0 after 6510 usecs
calling  sis_init+0x0/0x40 @ 1
bus: 'pci': add driver pata_sis
initcall sis_init+0x0/0x40 returned 0 after 3255 usecs
calling  legacy_init+0x0/0x295 @ 1
initcall legacy_init+0x0/0x295 returned -19 after 3255 usecs
calling  e1000_init_module+0x0/0x9c @ 1
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
bus: 'pci': add driver e1000
initcall e1000_init_module+0x0/0x9c returned 0 after 13020 usecs
calling  e1000_init_module+0x0/0x84 @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
bus: 'pci': add driver e1000e
initcall e1000_init_module+0x0/0x84 returned 0 after 13020 usecs
calling  igb_init_module+0x0/0x80 @ 1
Intel(R) Gigabit Ethernet Network Driver - version 1.3.16-k2
Copyright (c) 2007-2009 Intel Corporation.
bus: 'pci': add driver igb
initcall igb_init_module+0x0/0x80 returned 0 after 13020 usecs
calling  ixgb_init_module+0x0/0x70 @ 1
Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
Copyright (c) 1999-2008 Intel Corporation.
bus: 'pci': add driver ixgb
initcall ixgb_init_module+0x0/0x70 returned 0 after 9765 usecs
calling  ipg_init_module+0x0/0x40 @ 1
bus: 'pci': add driver Sundance Technology IPG Triple-Speed Ethernet
initcall ipg_init_module+0x0/0x40 returned 0 after 6510 usecs
calling  cxgb3_init_module+0x0/0x40 @ 1
bus: 'pci': add driver cxgb3
initcall cxgb3_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  atl1e_init_module+0x0/0x40 @ 1
bus: 'pci': add driver ATL1E
initcall atl1e_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  atl1c_init_module+0x0/0x40 @ 1
bus: 'pci': add driver atl1c
initcall atl1c_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  bdx_module_init+0x0/0xc0 @ 1
tehuti: Tehuti Networks(R) Network Driver, 7.29.3
tehuti: Options: hw_csum 
bus: 'pci': add driver tehuti
initcall bdx_module_init+0x0/0xc0 returned 0 after 9765 usecs
calling  enic_init_module+0x0/0x60 @ 1
enic: Cisco 10G Ethernet Driver, ver 1.0.0.933
bus: 'pci': add driver enic
initcall enic_init_module+0x0/0x60 returned 0 after 6510 usecs
calling  plip_init+0x0/0x7e @ 1
initcall plip_init+0x0/0x7e returned 0 after 0 usecs
calling  happy_meal_probe+0x0/0x35 @ 1
bus: 'pci': add driver hme
initcall happy_meal_probe+0x0/0x35 returned 0 after 3255 usecs
calling  vortex_init+0x0/0xeb @ 1
bus: 'pci': add driver 3c59x
bus: 'eisa': add driver 3c59x
initcall vortex_init+0x0/0xeb returned 0 after 6510 usecs
calling  pcnet32_init_module+0x0/0x13c @ 1
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
bus: 'pci': add driver pcnet32
initcall pcnet32_init_module+0x0/0x13c returned 0 after 9765 usecs
calling  e100_init_module+0x0/0x79 @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
bus: 'pci': add driver e100
initcall e100_init_module+0x0/0x79 returned 0 after 13020 usecs
calling  sis190_init_module+0x0/0x40 @ 1
bus: 'pci': add driver sis190
initcall sis190_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  sis900_init_module+0x0/0x40 @ 1
bus: 'pci': add driver sis900
initcall sis900_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  yellowfin_init+0x0/0x40 @ 1
bus: 'pci': add driver yellowfin
initcall yellowfin_init+0x0/0x40 returned 0 after 3255 usecs
calling  acenic_init+0x0/0x40 @ 1
bus: 'pci': add driver acenic
initcall acenic_init+0x0/0x40 returned 0 after 3255 usecs
calling  natsemi_init_mod+0x0/0x40 @ 1
bus: 'pci': add driver natsemi
initcall natsemi_init_mod+0x0/0x40 returned 0 after 6510 usecs
calling  tg3_init+0x0/0x35 @ 1
bus: 'pci': add driver tg3
initcall tg3_init+0x0/0x35 returned 0 after 3255 usecs
calling  bnx2x_init+0x0/0x9e @ 1
bus: 'pci': add driver bnx2x
initcall bnx2x_init+0x0/0x9e returned 0 after 3255 usecs
calling  rhine_init+0x0/0x8d @ 1
bus: 'pci': add driver via-rhine
initcall rhine_init+0x0/0x8d returned 0 after 3255 usecs
calling  velocity_init_module+0x0/0x40 @ 1
bus: 'pci': add driver via-velocity
initcall velocity_init_module+0x0/0x40 returned 0 after 6510 usecs
calling  starfire_init+0x0/0x40 @ 1
bus: 'pci': add driver starfire
initcall starfire_init+0x0/0x40 returned 0 after 3255 usecs
calling  marvell_init+0x0/0x75 @ 1
bus: 'mdio_bus': add driver Marvell 88E1101
bus: 'mdio_bus': add driver Marvell 88E1112
bus: 'mdio_bus': add driver Marvell 88E1111
bus: 'mdio_bus': add driver Marvell 88E1118
bus: 'mdio_bus': add driver Marvell 88E1121R
bus: 'mdio_bus': add driver Marvell 88E1145
bus: 'mdio_bus': add driver Marvell 88E1240
initcall marvell_init+0x0/0x75 returned 0 after 35807 usecs
calling  lxt_init+0x0/0x5b @ 1
bus: 'mdio_bus': add driver LXT970
bus: 'mdio_bus': add driver LXT971
initcall lxt_init+0x0/0x5b returned 0 after 9765 usecs
calling  et1011c_init+0x0/0x40 @ 1
bus: 'mdio_bus': add driver ET1011C
initcall et1011c_init+0x0/0x40 returned 0 after 3255 usecs
calling  ns_init+0x0/0x40 @ 1
bus: 'mdio_bus': add driver NatSemi DP83865
initcall ns_init+0x0/0x40 returned 0 after 3255 usecs
calling  ste10Xp_init+0x0/0x50 @ 1
bus: 'mdio_bus': add driver STe100p
bus: 'mdio_bus': add driver STe101p
initcall ste10Xp_init+0x0/0x50 returned 0 after 9765 usecs
calling  net_olddevs_init+0x0/0x42 @ 1
initcall net_olddevs_init+0x0/0x42 returned 0 after 3255 usecs
calling  hp100_module_init+0x0/0x75 @ 1
bus: 'eisa': add driver hp100
bus: 'pci': add driver hp100
initcall hp100_module_init+0x0/0x75 returned 0 after 6510 usecs
calling  init_nic+0x0/0x35 @ 1
bus: 'pci': add driver forcedeth
bus: 'pci': driver_probe_device: matched device 0000:00:0a.0 with driver forcedeth
bus: 'pci': really_probe: probing driver forcedeth with device 0000:00:0a.0
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 11
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
device: 'eth0': device_add
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
driver: '0000:00:0a.0': driver_bound: bound to device 'forcedeth'
bus: 'pci': really_probe: bound device 0000:00:0a.0 to driver forcedeth
initcall init_nic+0x0/0x35 returned 0 after 576171 usecs
calling  slip_init+0x0/0xd2 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xd2 returned 0 after 16276 usecs
calling  macvlan_init_module+0x0/0x69 @ 1
initcall macvlan_init_module+0x0/0x69 returned 0 after 0 usecs
calling  rtl8139_init_module+0x0/0x40 @ 1
bus: 'pci': add driver 8139too
bus: 'pci': driver_probe_device: matched device 0000:05:07.0 with driver 8139too
bus: 'pci': really_probe: probing driver 8139too with device 0000:05:07.0
8139too Fast Ethernet driver 0.9.28
8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 11
device: 'eth1': device_add
eth1: RealTek RTL8139 at 0xf85b6000, 00:c0:df:03:68:5d, IRQ 11
driver: '0000:05:07.0': driver_bound: bound to device '8139too'
bus: 'pci': really_probe: bound device 0000:05:07.0 to driver 8139too
initcall rtl8139_init_module+0x0/0x40 returned 0 after 48828 usecs
calling  depca_module_init+0x0/0x103 @ 1
bus: 'eisa': add driver depca
bus: 'platform': add driver depca
Registering platform device 'depca.0'. Parent at platform
device: 'depca.0': device_add
bus: 'platform': add device depca.0
bus: 'platform': driver_probe_device: matched device depca.0 with driver depca
bus: 'platform': really_probe: probing driver depca with device depca.0
bus: 'platform': remove device depca.0
Registering platform device 'depca.1'. Parent at platform
device: 'depca.1': device_add
bus: 'platform': add device depca.1
bus: 'platform': driver_probe_device: matched device depca.1 with driver depca
bus: 'platform': really_probe: probing driver depca with device depca.1
bus: 'platform': remove device depca.1
initcall depca_module_init+0x0/0x103 returned 0 after 61848 usecs
calling  rio_init+0x0/0x40 @ 1
bus: 'pci': add driver dl2k
initcall rio_init+0x0/0x40 returned 0 after 3255 usecs
calling  s2io_starter+0x0/0x40 @ 1
bus: 'pci': add driver S2IO
initcall s2io_starter+0x0/0x40 returned 0 after 3255 usecs
calling  mlx4_init+0x0/0xf9 @ 1
bus: 'pci': add driver mlx4_core
initcall mlx4_init+0x0/0xf9 returned 0 after 3255 usecs
calling  mlx4_en_init+0x0/0x40 @ 1
initcall mlx4_en_init+0x0/0x40 returned 0 after 0 usecs
calling  kaweth_init+0x0/0x40 @ 1
bus: 'usb': add driver kaweth
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x40 returned 0 after 6510 usecs
calling  cdc_init+0x0/0x40 @ 1
bus: 'usb': add driver cdc_ether
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x40 returned 0 after 9765 usecs
calling  usbnet_init+0x0/0x40 @ 1
bus: 'usb': add driver gl620a
usbcore: registered new interface driver gl620a
initcall usbnet_init+0x0/0x40 returned 0 after 6510 usecs
calling  plusb_init+0x0/0x40 @ 1
bus: 'usb': add driver plusb
usbcore: registered new interface driver plusb
initcall plusb_init+0x0/0x40 returned 0 after 6510 usecs
calling  zaurus_init+0x0/0x35 @ 1
bus: 'usb': add driver zaurus
usbcore: registered new interface driver zaurus
initcall zaurus_init+0x0/0x35 returned 0 after 6510 usecs
calling  usbnet_init+0x0/0x4b @ 1
initcall usbnet_init+0x0/0x4b returned 0 after 0 usecs
calling  uli526x_init_module+0x0/0xc0 @ 1
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
bus: 'pci': add driver uli526x
initcall uli526x_init_module+0x0/0xc0 returned 0 after 9765 usecs
calling  bpq_init_driver+0x0/0x78 @ 1
AX.25: bpqether driver version 004
initcall bpq_init_driver+0x0/0x78 returned 0 after 3255 usecs
calling  init_baycompar+0x0/0xee @ 1
baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
baycom_par: version 0.9 compiled 08:52:17 Sep 14 2009
device: 'bcp0': device_add
device: 'bcp1': device_add
device: 'bcp2': device_add
device: 'bcp3': device_add
initcall init_baycompar+0x0/0xee returned 0 after 26041 usecs
calling  hdlcdrv_init_driver+0x0/0x50 @ 1
hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
hdlcdrv: version 0.8 compiled 08:52:19 Sep 14 2009
initcall hdlcdrv_init_driver+0x0/0x50 returned 0 after 6510 usecs
calling  usb_irda_init+0x0/0x60 @ 1
bus: 'usb': add driver irda-usb
usbcore: registered new interface driver irda-usb
USB IrDA support registered
initcall usb_irda_init+0x0/0x60 returned 0 after 9765 usecs
calling  ksdazzle_init+0x0/0x40 @ 1
bus: 'usb': add driver ksdazzle-sir
usbcore: registered new interface driver ksdazzle-sir
initcall ksdazzle_init+0x0/0x40 returned 0 after 6510 usecs
calling  init_netconsole+0x0/0x123 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x123 returned 0 after 6510 usecs
calling  fw_core_init+0x0/0xa0 @ 1
bus: 'firewire': registered
initcall fw_core_init+0x0/0xa0 returned 0 after 3255 usecs
calling  fw_ohci_init+0x0/0x40 @ 1
bus: 'pci': add driver firewire_ohci
initcall fw_ohci_init+0x0/0x40 returned 0 after 3255 usecs
calling  sbp2_init+0x0/0x70 @ 1
bus: 'firewire': add driver sbp2
initcall sbp2_init+0x0/0x70 returned 0 after 3255 usecs
calling  pcilynx_init+0x0/0x52 @ 1
bus: 'pci': add driver pcilynx
initcall pcilynx_init+0x0/0x52 returned 0 after 6510 usecs
calling  init_raw1394+0x0/0x104 @ 1
device: 'raw1394': device_add
ieee1394: raw1394: /dev/raw1394 device initialized
bus: 'ieee1394': add driver raw1394
initcall init_raw1394+0x0/0x104 returned 0 after 13020 usecs
calling  ether1394_init_module+0x0/0x89 @ 1
bus: 'ieee1394': add driver eth1394
initcall ether1394_init_module+0x0/0x89 returned 0 after 6510 usecs
calling  uio_init+0x0/0x30 @ 1
initcall uio_init+0x0/0x30 returned 0 after 0 usecs
calling  uio_pdrv_init+0x0/0x40 @ 1
bus: 'platform': add driver uio_pdrv
initcall uio_pdrv_init+0x0/0x40 returned 0 after 3255 usecs
calling  smx_ce_init_module+0x0/0x40 @ 1
bus: 'platform': add driver smx-ce
initcall smx_ce_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  uwb_subsys_init+0x0/0x70 @ 1
device class 'uwb_rc': registering
initcall uwb_subsys_init+0x0/0x70 returned 0 after 3255 usecs
calling  hwarc_driver_init+0x0/0x40 @ 1
bus: 'usb': add driver hwa-rc
usbcore: registered new interface driver hwa-rc
initcall hwarc_driver_init+0x0/0x40 returned 0 after 9765 usecs
calling  ehci_hcd_init+0x0/0xe0 @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
bus: 'pci': add driver ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.1 with driver ehci_hcd
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:02.1
ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall ehci_hcd_init+0x0/0xe0 returned 0 after 42317 usecs
calling  isp116x_init+0x0/0x60 @ 1
116x: driver isp116x-hcd, 03 Nov 2005
bus: 'platform': add driver isp116x-hcd
initcall isp116x_init+0x0/0x60 returned 0 after 6510 usecs
calling  ohci_hcd_mod_init+0x0/0xe0 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
bus: 'pci': add driver ohci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:02.0 with driver ohci_hcd
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:02.0
ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
bus: 'ssb': add driver ohci_hcd
initcall ohci_hcd_mod_init+0x0/0xe0 returned 0 after 42317 usecs
calling  uhci_hcd_init+0x0/0xde @ 1
uhci_hcd: USB Universal Host Controller Interface driver
bus: 'pci': add driver uhci_hcd
initcall uhci_hcd_init+0x0/0xde returned 0 after 9765 usecs
calling  xhci_hcd_init+0x0/0x52 @ 1
bus: 'pci': add driver xhci_hcd
initcall xhci_hcd_init+0x0/0x52 returned 0 after 3255 usecs
calling  sl811h_init+0x0/0x60 @ 1
sl811: driver sl811-hcd, 19 May 2005
bus: 'platform': add driver sl811-hcd
initcall sl811h_init+0x0/0x60 returned 0 after 6510 usecs
calling  u132_hcd_init+0x0/0xe0 @ 1
driver u132_hcd built at 08:52:21 on Sep 14 2009
bus: 'platform': add driver u132_hcd
initcall u132_hcd_init+0x0/0xe0 returned 0 after 6510 usecs
calling  wusbcore_init+0x0/0xa0 @ 1
initcall wusbcore_init+0x0/0xa0 returned 0 after 0 usecs
calling  cbaf_driver_init+0x0/0x40 @ 1
bus: 'usb': add driver wusb-cbaf
usbcore: registered new interface driver wusb-cbaf
initcall cbaf_driver_init+0x0/0x40 returned 0 after 6510 usecs
calling  usblp_init+0x0/0x40 @ 1
bus: 'usb': add driver usblp
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x40 returned 0 after 6510 usecs
calling  wdm_init+0x0/0x35 @ 1
bus: 'usb': add driver cdc_wdm
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x35 returned 0 after 6510 usecs
calling  usb_usual_init+0x0/0x5b @ 1
bus: 'usb': add driver libusual
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x5b returned 0 after 6510 usecs
calling  adu_init+0x0/0xae @ 1
bus: 'usb': add driver adutux
usbcore: registered new interface driver adutux
adutux adutux (see www.ontrak.net) v0.0.13
adutux is an experimental driver. Use at your own risk
initcall adu_init+0x0/0xae returned 0 after 16276 usecs
calling  appledisplay_init+0x0/0x79 @ 1
bus: 'usb': add driver appledisplay
usbcore: registered new interface driver appledisplay
initcall appledisplay_init+0x0/0x79 returned 0 after 9765 usecs
calling  cypress_init+0x0/0x54 @ 1
bus: 'usb': add driver cypress_cy7c63
usbcore: registered new interface driver cypress_cy7c63
initcall cypress_init+0x0/0x54 returned 0 after 9765 usecs
calling  usb_cytherm_init+0x0/0x65 @ 1
bus: 'usb': add driver cytherm
usbcore: registered new interface driver cytherm
cytherm: v1.0:Cypress USB Thermometer driver
initcall usb_cytherm_init+0x0/0x65 returned 0 after 9765 usecs
calling  emi26_init+0x0/0x35 @ 1
bus: 'usb': add driver emi26 - firmware loader
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x35 returned 0 after 9765 usecs
calling  ftdi_elan_init+0x0/0x186 @ 1
driver ftdi-elan built at 08:52:17 on Sep 14 2009
bus: 'usb': add driver ftdi-elan
usbcore: registered new interface driver ftdi-elan
initcall ftdi_elan_init+0x0/0x186 returned 0 after 13020 usecs
calling  usb_idmouse_init+0x0/0x65 @ 1
idmouse: 0.6:Siemens ID Mouse FingerTIP Sensor Driver
bus: 'usb': add driver idmouse
usbcore: registered new interface driver idmouse
initcall usb_idmouse_init+0x0/0x65 returned 0 after 13020 usecs
calling  iowarrior_init+0x0/0x40 @ 1
bus: 'usb': add driver iowarrior
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x40 returned 0 after 6510 usecs
calling  isight_firmware_init+0x0/0x35 @ 1
bus: 'usb': add driver isight_firmware
usbcore: registered new interface driver isight_firmware
initcall isight_firmware_init+0x0/0x35 returned 0 after 9765 usecs
calling  ld_usb_init+0x0/0x54 @ 1
bus: 'usb': add driver ldusb
usbcore: registered new interface driver ldusb
initcall ld_usb_init+0x0/0x54 returned 0 after 9765 usecs
calling  lego_usb_tower_init+0x0/0xa7 @ 1
bus: 'usb': add driver legousbtower
usbcore: registered new interface driver legousbtower
legousbtower: v0.96:LEGO USB Tower Driver
initcall lego_usb_tower_init+0x0/0xa7 returned 0 after 13020 usecs
calling  usbtest_init+0x0/0x81 @ 1
bus: 'usb': add driver usbtest
usbcore: registered new interface driver usbtest
initcall usbtest_init+0x0/0x81 returned 0 after 6510 usecs
calling  vstusb_init+0x0/0x5f @ 1
bus: 'usb': add driver vstusb
usbcore: registered new interface driver vstusb
initcall vstusb_init+0x0/0x5f returned 0 after 6510 usecs
calling  i8042_init+0x0/0x146 @ 1
bus: 'pnp': add driver i8042 kbd
bus: 'pnp': driver_probe_device: matched device 00:04 with driver i8042 kbd
bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:04
driver: '00:04': driver_bound: bound to device 'i8042 kbd'
bus: 'pnp': really_probe: bound device 00:04 to driver i8042 kbd
bus: 'pnp': add driver i8042 aux
bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 aux
bus: 'pnp': really_probe: probing driver i8042 aux with device 00:0a
driver: '00:0a': driver_bound: bound to device 'i8042 aux'
bus: 'pnp': really_probe: bound device 00:0a to driver i8042 aux
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
bus: 'platform': add driver i8042
Registering platform device 'i8042'. Parent at platform
device: 'i8042': device_add
bus: 'platform': add device i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
driver: 'i8042': driver_bound: bound to device 'i8042'
bus: 'platform': really_probe: bound device i8042 to driver i8042
initcall i8042_init+0x0/0x146 returned 0 after 107421 usecs
calling  ct82c710_init+0x0/0xd9 @ 1
initcall ct82c710_init+0x0/0xd9 returned -19 after 0 usecs
calling  pcips2_init+0x0/0x40 @ 1
bus: 'pci': add driver pcips2
device: 'serio0': device_add
bus: 'serio': add device serio0
initcall pcips2_init+0x0/0x40 returned 0 after 9765 usecs
calling  mousedev_init+0x0/0x7b @ 1
device: 'mice': device_add
device: 'serio1': device_add
bus: 'serio': add device serio1
device: 'mouse0': device_add
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x7b returned 0 after 16276 usecs
calling  atkbd_init+0x0/0x44 @ 1
bus: 'serio': add driver atkbd
initcall atkbd_init+0x0/0x44 returned 0 after 3255 usecs
calling  xtkbd_init+0x0/0x40 @ 1
bus: 'serio': add driver xtkbd
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio0
initcall xtkbd_init+0x0/0x40 returned 0 after 16276 usecs
calling  db9_init+0x0/0xcf @ 1
initcall db9_init+0x0/0xcf returned -19 after 0 usecs
calling  magellan_init+0x0/0x40 @ 1
bus: 'serio': add driver magellan
initcall magellan_init+0x0/0x40 returned 0 after 3255 usecs
calling  spaceball_init+0x0/0x40 @ 1
bus: 'serio': add driver spaceball
initcall spaceball_init+0x0/0x40 returned 0 after 3255 usecs
calling  spaceorb_init+0x0/0x40 @ 1
bus: 'serio': add driver spaceorb
initcall spaceorb_init+0x0/0x40 returned 0 after 3255 usecs
calling  tgfx_init+0x0/0xc0 @ 1
device: 'input1': device_add
initcall tgfx_init+0x0/0xc0 returned -19 after 0 usecs
calling  usb_xpad_init+0x0/0x50 @ 1
bus: 'usb': add driver xpad
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x50 returned 0 after 3255 usecs
calling  aiptek_init+0x0/0x5c @ 1
bus: 'usb': add driver aiptek
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
initcall aiptek_init+0x0/0x5c returned 0 after 0 usecs
calling  gtco_init+0x0/0x72 @ 1
bus: 'usb': add driver gtco
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x72 returned 0 after 0 usecs
calling  inexio_init+0x0/0x40 @ 1
bus: 'serio': add driver inexio
initcall inexio_init+0x0/0x40 returned 0 after 0 usecs
calling  htcpen_isa_init+0x0/0x50 @ 1
initcall htcpen_isa_init+0x0/0x50 returned -19 after 0 usecs
calling  usbtouch_init+0x0/0x40 @ 1
bus: 'usb': add driver usbtouchscreen
usbcore: registered new interface driver usbtouchscreen
initcall usbtouch_init+0x0/0x40 returned 0 after 0 usecs
calling  w8001_init+0x0/0x40 @ 1
bus: 'serio': add driver w8001
driver: 'serio0': driver_bound: bound to device 'atkbd'
bus: 'serio': really_probe: bound device serio0 to driver atkbd
initcall w8001_init+0x0/0x40 returned 0 after 9765 usecs
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
calling  apanel_init+0x0/0x1cc @ 1
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
initcall apanel_init+0x0/0x1cc returned -19 after 6510 usecs
calling  ati_remote2_init+0x0/0x60 @ 1
bus: 'usb': add driver ati_remote2
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x60 returned 0 after 13020 usecs
calling  cm109_init+0x0/0x5b @ 1
cm109: Keymap for Komunikate KIP1000 phone loaded
bus: 'usb': add driver cm109
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
initcall cm109_init+0x0/0x5b returned 0 after 16276 usecs
calling  usb_keyspan_init+0x0/0x63 @ 1
bus: 'usb': add driver keyspan_remote
usbcore: registered new interface driver keyspan_remote
initcall usb_keyspan_init+0x0/0x63 returned 0 after 9765 usecs
calling  powermate_init+0x0/0x40 @ 1
bus: 'usb': add driver powermate
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x40 returned 0 after 9765 usecs
calling  i2o_iop_init+0x0/0x72 @ 1
I2O subsystem v1.325
i2o: max drivers = 8
bus: 'i2o': registered
bus: 'i2o': add driver exec-osm
bus: 'pci': add driver PCI_I2O
initcall i2o_iop_init+0x0/0x72 returned 0 after 26041 usecs
calling  i2o_block_init+0x0/0x12e @ 1
I2O Block Device OSM v1.325
bus: 'i2o': add driver block-osm
initcall i2o_block_init+0x0/0x12e returned 0 after 26041 usecs
calling  i2o_scsi_init+0x0/0x5d @ 1
I2O SCSI Peripheral OSM v1.316
bus: 'i2o': add driver scsi-osm
initcall i2o_scsi_init+0x0/0x5d returned 0 after 6510 usecs
calling  ds1553_init+0x0/0x40 @ 1
bus: 'platform': add driver rtc-ds1553
initcall ds1553_init+0x0/0x40 returned 0 after 9765 usecs
calling  isl1208_init+0x0/0x40 @ 1
bus: 'i2c': add driver rtc-isl1208
i2c-core: driver [rtc-isl1208] registered
initcall isl1208_init+0x0/0x40 returned 0 after 9765 usecs
calling  m41t80_rtc_init+0x0/0x40 @ 1
bus: 'i2c': add driver rtc-m41t80
i2c-core: driver [rtc-m41t80] registered
initcall m41t80_rtc_init+0x0/0x40 returned 0 after 9765 usecs
calling  m48t59_rtc_init+0x0/0x40 @ 1
bus: 'platform': add driver rtc-m48t59
initcall m48t59_rtc_init+0x0/0x40 returned 0 after 6510 usecs
calling  bq4802_init+0x0/0x40 @ 1
bus: 'platform': add driver rtc-bq4802
initcall bq4802_init+0x0/0x40 returned 0 after 3255 usecs
calling  rx8581_init+0x0/0x40 @ 1
bus: 'i2c': add driver rtc-rx8581
i2c-core: driver [rtc-rx8581] registered
initcall rx8581_init+0x0/0x40 returned 0 after 6510 usecs
calling  s35390a_rtc_init+0x0/0x40 @ 1
bus: 'i2c': add driver rtc-s35390a
i2c-core: driver [rtc-s35390a] registered
initcall s35390a_rtc_init+0x0/0x40 returned 0 after 9765 usecs
calling  stk17ta8_init+0x0/0x35 @ 1
bus: 'platform': add driver stk17ta8
initcall stk17ta8_init+0x0/0x35 returned 0 after 3255 usecs
calling  test_init+0x0/0xd1 @ 1
bus: 'platform': add driver rtc-test
Registering platform device 'rtc-test.0'. Parent at platform
device: 'rtc-test.0': device_add
bus: 'platform': add device rtc-test.0
bus: 'platform': driver_probe_device: matched device rtc-test.0 with driver rtc-test
bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.0
device: 'rtc0': device_add
rtc-test rtc-test.0: rtc core: registered test as rtc0
driver: 'rtc-test.0': driver_bound: bound to device 'rtc-test'
bus: 'platform': really_probe: bound device rtc-test.0 to driver rtc-test
Registering platform device 'rtc-test.1'. Parent at platform
device: 'rtc-test.1': device_add
bus: 'platform': add device rtc-test.1
bus: 'platform': driver_probe_device: matched device rtc-test.1 with driver rtc-test
bus: 'platform': really_probe: probing driver rtc-test with device rtc-test.1
device: 'rtc1': device_add
rtc-test rtc-test.1: rtc core: registered test as rtc1
driver: 'rtc-test.1': driver_bound: bound to device 'rtc-test'
bus: 'platform': really_probe: bound device rtc-test.1 to driver rtc-test
initcall test_init+0x0/0xd1 returned 0 after 97656 usecs
calling  v3020_init+0x0/0x40 @ 1
bus: 'platform': add driver v3020
initcall v3020_init+0x0/0x40 returned 0 after 6510 usecs
calling  x1205_init+0x0/0x40 @ 1
bus: 'i2c': add driver rtc-x1205
i2c-core: driver [rtc-x1205] registered
initcall x1205_init+0x0/0x40 returned 0 after 6510 usecs
calling  ali1563_init+0x0/0x40 @ 1
bus: 'pci': add driver ali1563_smbus
initcall ali1563_init+0x0/0x40 returned 0 after 3255 usecs
calling  i2c_ali15x3_init+0x0/0x40 @ 1
bus: 'pci': add driver ali15x3_smbus
initcall i2c_ali15x3_init+0x0/0x40 returned 0 after 6510 usecs
calling  amd756_init+0x0/0x40 @ 1
bus: 'pci': add driver amd756_smbus
initcall amd756_init+0x0/0x40 returned 0 after 3255 usecs
calling  nforce2_init+0x0/0x40 @ 1
bus: 'pci': add driver nForce2_smbus
bus: 'pci': driver_probe_device: matched device 0000:00:01.1 with driver nForce2_smbus
bus: 'pci': really_probe: probing driver nForce2_smbus with device 0000:00:01.1
device: 'i2c-0': device_add
i2c-adapter i2c-0: adapter [SMBus nForce2 adapter at 4c00] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
i2c-adapter i2c-0: Creating eeprom at 0x50
device: '0-0050': device_add
bus: 'i2c': add device 0-0050
i2c 0-0050: uevent
bus: 'i2c': driver_probe_device: matched device 0-0050 with driver eeprom
bus: 'i2c': really_probe: probing driver eeprom with device 0-0050
eeprom 0-0050: probe
driver: '0-0050': driver_bound: bound to device 'eeprom'
bus: 'i2c': really_probe: bound device 0-0050 to driver eeprom
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0050
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
i2c-adapter i2c-0: Creating eeprom at 0x51
device: '0-0051': device_add
bus: 'i2c': add device 0-0051
i2c 0-0051: uevent
bus: 'i2c': driver_probe_device: matched device 0-0051 with driver eeprom
bus: 'i2c': really_probe: probing driver eeprom with device 0-0051
eeprom 0-0051: probe
driver: '0-0051': driver_bound: bound to device 'eeprom'
bus: 'i2c': really_probe: bound device 0-0051 to driver eeprom
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0051
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
device: 'i2c-1': device_add
i2c-adapter i2c-1: adapter [SMBus nForce2 adapter at 4c40] registered
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x50
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x51
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x52
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x53
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x54
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x55
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x56
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x57
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
driver: '0000:00:01.1': driver_bound: bound to device 'nForce2_smbus'
bus: 'pci': really_probe: bound device 0000:00:01.1 to driver nForce2_smbus
initcall nforce2_init+0x0/0x40 returned 0 after 423176 usecs
calling  i2c_sis5595_init+0x0/0x40 @ 1
bus: 'pci': add driver sis5595_smbus
initcall i2c_sis5595_init+0x0/0x40 returned 0 after 3255 usecs
calling  i2c_sis96x_init+0x0/0x40 @ 1
bus: 'pci': add driver sis96x_smbus
initcall i2c_sis96x_init+0x0/0x40 returned 0 after 3255 usecs
calling  i2c_vt596_init+0x0/0x35 @ 1
bus: 'pci': add driver vt596_smbus
initcall i2c_vt596_init+0x0/0x35 returned 0 after 3255 usecs
calling  i2c_parport_init+0x0/0x66 @ 1
i2c-parport: adapter type unspecified
initcall i2c_parport_init+0x0/0x66 returned -19 after 3255 usecs
calling  i2c_parport_init+0x0/0x185 @ 1
i2c-parport-light: adapter type unspecified
initcall i2c_parport_init+0x0/0x185 returned -19 after 3255 usecs
calling  i2c_voodoo3_init+0x0/0x40 @ 1
bus: 'pci': add driver voodoo3_smbus
initcall i2c_voodoo3_init+0x0/0x40 returned 0 after 3255 usecs
calling  i2c_pca_pf_init+0x0/0x40 @ 1
bus: 'platform': add driver i2c-pca-platform
initcall i2c_pca_pf_init+0x0/0x40 returned 0 after 3255 usecs
calling  pcf8575_init+0x0/0x35 @ 1
bus: 'i2c': add driver pcf8575
i2c-core: driver [pcf8575] registered
initcall pcf8575_init+0x0/0x35 returned 0 after 6510 usecs
calling  sensors_w83792d_init+0x0/0x40 @ 1
bus: 'i2c': add driver w83792d
i2c-core: driver [w83792d] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2f
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_w83792d_init+0x0/0x40 returned 0 after 139973 usecs
calling  ad7414_init+0x0/0x40 @ 1
bus: 'i2c': add driver ad7414
i2c-core: driver [ad7414] registered
initcall ad7414_init+0x0/0x40 returned 0 after 6510 usecs
calling  ad7418_init+0x0/0x40 @ 1
bus: 'i2c': add driver ad7418
i2c-core: driver [ad7418] registered
initcall ad7418_init+0x0/0x40 returned 0 after 6510 usecs
calling  sensors_adm1025_init+0x0/0x40 @ 1
bus: 'i2c': add driver adm1025
i2c-core: driver [adm1025] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_adm1025_init+0x0/0x40 returned 0 after 107421 usecs
calling  sensors_adm1029_init+0x0/0x40 @ 1
bus: 'i2c': add driver adm1029
i2c-core: driver [adm1029] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x28
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x29
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2b
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2f
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_adm1029_init+0x0/0x40 returned 0 after 266926 usecs
calling  sensors_adm1031_init+0x0/0x40 @ 1
bus: 'i2c': add driver adm1031
i2c-core: driver [adm1031] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_adm1031_init+0x0/0x40 returned 0 after 107421 usecs
calling  adt7462_init+0x0/0x40 @ 1
bus: 'i2c': add driver adt7462
i2c-core: driver [adt7462] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x58
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x5c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x58
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x5c
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall adt7462_init+0x0/0x40 returned 0 after 74869 usecs
calling  adt7473_init+0x0/0x40 @ 1
bus: 'i2c': add driver adt7473
i2c-core: driver [adt7473] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall adt7473_init+0x0/0x40 returned 0 after 123697 usecs
calling  applesmc_init+0x0/0x430 @ 1
applesmc: supported laptop not found!
applesmc: driver init failed (ret=-19)!
initcall applesmc_init+0x0/0x430 returned -19 after 6510 usecs
calling  dme1737_init+0x0/0xde @ 1
bus: 'i2c': add driver dme1737
i2c-core: driver [dme1737] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall dme1737_init+0x0/0xde returned 0 after 107421 usecs
calling  f71882fg_init+0x0/0x9e @ 1
f71882fg: Not a Fintek device
f71882fg: Not a Fintek device
initcall f71882fg_init+0x0/0x9e returned -19 after 6510 usecs
calling  sensors_fscher_init+0x0/0x40 @ 1
bus: 'i2c': add driver fscher
i2c-core: driver [fscher] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x73
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_fscher_init+0x0/0x40 returned 0 after 39062 usecs
calling  sm_fscpos_init+0x0/0x40 @ 1
bus: 'i2c': add driver fscpos
i2c-core: driver [fscpos] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x73
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sm_fscpos_init+0x0/0x40 returned 0 after 42317 usecs
calling  sensors_gl518sm_init+0x0/0x35 @ 1
bus: 'i2c': add driver gl518sm
i2c-core: driver [gl518sm] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_gl518sm_init+0x0/0x35 returned 0 after 87890 usecs
calling  i5k_amb_init+0x0/0x7b @ 1
bus: 'platform': add driver i5k_amb
Registering platform device 'i5k_amb.0'. Parent at platform
device: 'i5k_amb.0': device_add
bus: 'platform': add device i5k_amb.0
bus: 'platform': driver_probe_device: matched device i5k_amb.0 with driver i5k_amb
bus: 'platform': really_probe: probing driver i5k_amb with device i5k_amb.0
initcall i5k_amb_init+0x0/0x7b returned 0 after 35807 usecs
calling  sm_it87_init+0x0/0x7c @ 1
it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
bus: 'platform': add driver it87
Registering platform device 'it87.656'. Parent at platform
device: 'it87.656': device_add
bus: 'platform': add device it87.656
bus: 'platform': driver_probe_device: matched device it87.656 with driver it87
bus: 'platform': really_probe: probing driver it87 with device it87.656
it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
device: 'hwmon0': device_add
driver: 'it87.656': driver_bound: bound to device 'it87'
bus: 'platform': really_probe: bound device it87.656 to driver it87
initcall sm_it87_init+0x0/0x7c returned 0 after 58593 usecs
calling  sensors_lm80_init+0x0/0x40 @ 1
bus: 'i2c': add driver lm80
i2c-core: driver [lm80] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x28
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x29
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2b
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2f
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_lm80_init+0x0/0x40 returned 0 after 266926 usecs
calling  sensors_lm87_init+0x0/0x40 @ 1
bus: 'i2c': add driver lm87
i2c-core: driver [lm87] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_lm87_init+0x0/0x40 returned 0 after 104166 usecs
calling  sensors_max1619_init+0x0/0x40 @ 1
bus: 'i2c': add driver max1619
i2c-core: driver [max1619] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x18
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x19
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x1a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x29
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2a
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2b
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4d
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x4e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_max1619_init+0x0/0x40 returned 0 after 299478 usecs
calling  pc87360_init+0x0/0xd4 @ 1
pc87360: PC8736x not detected, module not inserted.
initcall pc87360_init+0x0/0xd4 returned -19 after 6510 usecs
calling  pc87427_init+0x0/0x99 @ 1
initcall pc87427_init+0x0/0x99 returned -19 after 0 usecs
calling  sm_smsc47m1_init+0x0/0x74 @ 1
initcall sm_smsc47m1_init+0x0/0x74 returned -19 after 0 usecs
calling  smsc47m192_init+0x0/0x40 @ 1
bus: 'i2c': add driver smsc47m192
i2c-core: driver [smsc47m192] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2c
i2c-adapter i2c-1: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2d
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall smsc47m192_init+0x0/0x40 returned 0 after 71614 usecs
calling  sm_vt8231_init+0x0/0x40 @ 1
bus: 'pci': add driver vt8231
initcall sm_vt8231_init+0x0/0x40 returned 0 after 3255 usecs
calling  sensors_w83627ehf_init+0x0/0x158 @ 1
initcall sensors_w83627ehf_init+0x0/0x158 returned -19 after 0 usecs
calling  sensors_w83l785ts_init+0x0/0x35 @ 1
bus: 'i2c': add driver w83l785ts
i2c-core: driver [w83l785ts] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i2c-adapter i2c-0: Transaction failed (0x10)!
i2c-adapter i2c-1: found normal entry for adapter 1, addr 0x2e
i2c-adapter i2c-1: Transaction failed (0x10)!
initcall sensors_w83l785ts_init+0x0/0x35 returned 0 after 42317 usecs
calling  telephony_init+0x0/0x80 @ 1
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x80 returned 0 after 0 usecs
calling  pci_eisa_init_module+0x0/0x35 @ 1
bus: 'pci': add driver pci_eisa
initcall pci_eisa_init_module+0x0/0x35 returned 0 after 3255 usecs
calling  init+0x0/0x9d @ 1
lguest: mapped switcher at ffc00000
device: 'lguest': device_add
initcall init+0x0/0x9d returned 0 after 6510 usecs
calling  init_ladder+0x0/0x40 @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0x40 returned 0 after 3255 usecs
calling  init_menu+0x0/0x40 @ 1
cpuidle: using governor menu
initcall init_menu+0x0/0x40 returned 0 after 3255 usecs
calling  mmc_blk_init+0x0/0x60 @ 1
bus: 'mmc': add driver mmcblk
initcall mmc_blk_init+0x0/0x60 returned 0 after 3255 usecs
calling  mmc_test_init+0x0/0x40 @ 1
bus: 'mmc': add driver mmc_test
initcall mmc_test_init+0x0/0x40 returned 0 after 3255 usecs
calling  sdhci_drv_init+0x0/0x50 @ 1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
initcall sdhci_drv_init+0x0/0x50 returned 0 after 6510 usecs
calling  sdhci_drv_init+0x0/0x35 @ 1
bus: 'platform': add driver sdhci
initcall sdhci_drv_init+0x0/0x35 returned 0 after 3255 usecs
calling  wbsd_drv_init+0x0/0xcb @ 1
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
bus: 'pnp': add driver wbsd
initcall wbsd_drv_init+0x0/0xcb returned 0 after 9765 usecs
calling  alix_led_init+0x0/0x12e @ 1
initcall alix_led_init+0x0/0x12e returned -19 after 6510 usecs
calling  lp3944_module_init+0x0/0x40 @ 1
bus: 'i2c': add driver lp3944
i2c-core: driver [lp3944] registered
initcall lp3944_module_init+0x0/0x40 returned 0 after 6510 usecs
calling  virtio_pci_init+0x0/0x70 @ 1
device: 'virtio-pci': device_add
bus: 'pci': add driver virtio-pci
initcall virtio_pci_init+0x0/0x70 returned 0 after 6510 usecs
calling  init+0x0/0x40 @ 1
bus: 'virtio': add driver virtio_balloon
initcall init+0x0/0x40 returned 0 after 6510 usecs
calling  flow_cache_init+0x0/0x17e @ 1
initcall flow_cache_init+0x0/0x17e returned 0 after 3255 usecs
calling  llc_init+0x0/0x40 @ 1
initcall llc_init+0x0/0x40 returned 0 after 0 usecs
calling  snap_init+0x0/0x50 @ 1
initcall snap_init+0x0/0x50 returned 0 after 0 usecs
calling  rif_init+0x0/0xa0 @ 1
initcall rif_init+0x0/0xa0 returned 0 after 0 usecs
calling  nfnetlink_init+0x0/0x83 @ 1
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x83 returned 0 after 3255 usecs
calling  nfnetlink_log_init+0x0/0xf0 @ 1
initcall nfnetlink_log_init+0x0/0xf0 returned 0 after 0 usecs
calling  nf_conntrack_standalone_init+0x0/0x35 @ 1
nf_conntrack version 0.5.0 (14293 buckets, 57172 max)
initcall nf_conntrack_standalone_init+0x0/0x35 returned 0 after 6510 usecs
calling  ctnetlink_init+0x0/0x87 @ 1
ctnetlink v0.93: registering with nfnetlink.
initcall ctnetlink_init+0x0/0x87 returned 0 after 3255 usecs
calling  nf_conntrack_ftp_init+0x0/0x224 @ 1
initcall nf_conntrack_ftp_init+0x0/0x224 returned 0 after 0 usecs
calling  nf_conntrack_sip_init+0x0/0x1e0 @ 1
initcall nf_conntrack_sip_init+0x0/0x1e0 returned 0 after 0 usecs
calling  sysctl_ipv4_init+0x0/0x63 @ 1
initcall sysctl_ipv4_init+0x0/0x63 returned 0 after 0 usecs
calling  ipip_init+0x0/0x87 @ 1
IPv4 over IPv4 tunneling driver
device: 'tunl0': device_add
initcall ipip_init+0x0/0x87 returned 0 after 6510 usecs
calling  ah4_init+0x0/0x90 @ 1
initcall ah4_init+0x0/0x90 returned 0 after 0 usecs
calling  ipcomp4_init+0x0/0x90 @ 1
initcall ipcomp4_init+0x0/0x90 returned 0 after 0 usecs
calling  ipip_init+0x0/0xd0 @ 1
initcall ipip_init+0x0/0xd0 returned 0 after 0 usecs
calling  tunnel4_init+0x0/0x90 @ 1
initcall tunnel4_init+0x0/0x90 returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x40 @ 1
initcall ipv4_netfilter_init+0x0/0x40 returned 0 after 0 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x140 @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x140 returned 0 after 0 usecs
calling  nf_defrag_init+0x0/0x35 @ 1
initcall nf_defrag_init+0x0/0x35 returned 0 after 0 usecs
calling  cubictcp_register+0x0/0xab @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0xab returned 0 after 0 usecs
calling  packet_init+0x0/0x60 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x60 returned 0 after 3255 usecs
calling  dsa_init_module+0x0/0x40 @ 1
initcall dsa_init_module+0x0/0x40 returned 0 after 0 usecs
calling  edsa_init_module+0x0/0x40 @ 1
initcall edsa_init_module+0x0/0x40 returned 0 after 0 usecs
calling  mv88e6123_61_65_init+0x0/0x40 @ 1
initcall mv88e6123_61_65_init+0x0/0x40 returned 0 after 0 usecs
calling  mv88e6131_init+0x0/0x40 @ 1
initcall mv88e6131_init+0x0/0x40 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0x40 @ 1
bus: 'platform': add driver dsa
initcall dsa_init_module+0x0/0x40 returned 0 after 3255 usecs
calling  x25_init+0x0/0x80 @ 1
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x80 returned 0 after 6510 usecs
calling  lapb_init+0x0/0x33 @ 1
initcall lapb_init+0x0/0x33 returned 0 after 0 usecs
calling  rose_proto_init+0x0/0x2ac @ 1
device: 'rose0': device_add
device: 'rose1': device_add
device: 'rose2': device_add
device: 'rose3': device_add
device: 'rose4': device_add
device: 'rose5': device_add
device: 'rose6': device_add
device: 'rose7': device_add
device: 'rose8': device_add
device: 'rose9': device_add
NET: Registered protocol family 11
initcall rose_proto_init+0x0/0x2ac returned 0 after 42317 usecs
calling  ax25_init+0x0/0xbc @ 1
NET: Registered protocol family 3
initcall ax25_init+0x0/0xbc returned 0 after 3255 usecs
calling  irlan_init+0x0/0xf3 @ 1
device: 'irlan0': device_add
initcall irlan_init+0x0/0xf3 returned 0 after 6510 usecs
calling  ircomm_init+0x0/0xd0 @ 1
IrCOMM protocol (Dag Brattli)
initcall ircomm_init+0x0/0xd0 returned 0 after 3255 usecs
calling  ircomm_tty_init+0x0/0x19c @ 1
device: 'ircomm0': device_add
device: 'ircomm1': device_add
device: 'ircomm2': device_add
device: 'ircomm3': device_add
device: 'ircomm4': device_add
device: 'ircomm5': device_add
device: 'ircomm6': device_add
device: 'ircomm7': device_add
device: 'ircomm8': device_add
device: 'ircomm9': device_add
device: 'ircomm10': device_add
device: 'ircomm11': device_add
device: 'ircomm12': device_add
device: 'ircomm13': device_add
device: 'ircomm14': device_add
device: 'ircomm15': device_add
device: 'ircomm16': device_add
device: 'ircomm17': device_add
device: 'ircomm18': device_add
device: 'ircomm19': device_add
device: 'ircomm20': device_add
device: 'ircomm21': device_add
device: 'ircomm22': device_add
device: 'ircomm23': device_add
device: 'ircomm24': device_add
device: 'ircomm25': device_add
device: 'ircomm26': device_add
device: 'ircomm27': device_add
device: 'ircomm28': device_add
device: 'ircomm29': device_add
device: 'ircomm30': device_add
device: 'ircomm31': device_add
initcall ircomm_tty_init+0x0/0x19c returned 0 after 117187 usecs
calling  dcbnl_init+0x0/0x55 @ 1
initcall dcbnl_init+0x0/0x55 returned 0 after 0 usecs
calling  severities_debugfs_init+0x0/0x80 @ 1
initcall severities_debugfs_init+0x0/0x80 returned 0 after 0 usecs
calling  cpufreq_p4_init+0x0/0x75 @ 1
initcall cpufreq_p4_init+0x0/0x75 returned -19 after 0 usecs
calling  update_mp_table+0x0/0x22f @ 1
initcall update_mp_table+0x0/0x22f returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x59 @ 1
initcall lapic_insert_resource+0x0/0x59 returned 0 after 0 usecs
calling  print_ipi_mode+0x0/0x50 @ 1
Using IPI Shortcut mode
initcall print_ipi_mode+0x0/0x50 returned 0 after 3255 usecs
calling  io_apic_bug_finalize+0x0/0x39 @ 1
initcall io_apic_bug_finalize+0x0/0x39 returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x96 @ 1
initcall check_early_ioremap_leak+0x0/0x96 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x50 @ 1
initcall pat_memtype_list_init+0x0/0x50 returned 0 after 0 usecs
calling  sched_init_debug+0x0/0x4d @ 1
initcall sched_init_debug+0x0/0x4d returned 0 after 3255 usecs
calling  init_oops_id+0x0/0x60 @ 1
initcall init_oops_id+0x0/0x60 returned 0 after 0 usecs
calling  disable_boot_consoles+0x0/0xdf @ 1
initcall disable_boot_consoles+0x0/0xdf returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0xe2 @ 1
device: 'cpu_dma_latency': device_add
device: 'network_latency': device_add
device: 'network_throughput': device_add
initcall pm_qos_power_init+0x0/0xe2 returned 0 after 9765 usecs
calling  debugfs_kprobe_init+0x0/0xa0 @ 1
initcall debugfs_kprobe_init+0x0/0xa0 returned 0 after 0 usecs
calling  taskstats_init+0x0/0xa2 @ 1
registered taskstats version 1
initcall taskstats_init+0x0/0xa2 returned 0 after 3255 usecs
calling  max_swapfiles_check+0x0/0x24 @ 1
initcall max_swapfiles_check+0x0/0x24 returned 0 after 0 usecs
calling  failslab_debugfs_init+0x0/0x7b @ 1
initcall failslab_debugfs_init+0x0/0x7b returned 0 after 0 usecs
calling  kmemleak_late_init+0x0/0xa3 @ 1
kmemleak: Kernel memory leak detector initialized
kmemleak: Automatic memory scanning thread started
initcall kmemleak_late_init+0x0/0xa3 returned 0 after 9765 usecs
calling  fail_make_request_debugfs+0x0/0x38 @ 1
initcall fail_make_request_debugfs+0x0/0x38 returned 0 after 0 usecs
calling  fail_io_timeout_debugfs+0x0/0x3b @ 1
initcall fail_io_timeout_debugfs+0x0/0x3b returned 0 after 0 usecs
calling  random32_reseed+0x0/0xa1 @ 1
initcall random32_reseed+0x0/0xa1 returned 0 after 0 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x35 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x35 returned 0 after 0 usecs
calling  pci_sysfs_init+0x0/0x6e @ 1
initcall pci_sysfs_init+0x0/0x6e returned 0 after 0 usecs
calling  regulator_init_complete+0x0/0x143 @ 1
initcall regulator_init_complete+0x0/0x143 returned 0 after 0 usecs
calling  seqgen_init+0x0/0x30 @ 1
initcall seqgen_init+0x0/0x30 returned 0 after 0 usecs
calling  hd_init+0x0/0x31c @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x31c returned -1 after 6510 usecs
initcall hd_init+0x0/0x31c returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x1a0 @ 1
initcall scsi_complete_async_scans+0x0/0x1a0 returned 0 after 0 usecs
calling  edd_init+0x0/0x1a0 @ 1
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
initcall edd_init+0x0/0x1a0 returned -19 after 6510 usecs
calling  memmap_init+0x0/0xcb @ 1
initcall memmap_init+0x0/0xcb returned 0 after 0 usecs
calling  init_net_drop_monitor+0x0/0x1a0 @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0x1a0 returned 0 after 3255 usecs
calling  tcp_congestion_default+0x0/0x40 @ 1
initcall tcp_congestion_default+0x0/0x40 returned 0 after 0 usecs
calling  ip_auto_config+0x0/0x326 @ 1
initcall ip_auto_config+0x0/0x326 returned 0 after 0 usecs
calling  initialize_hashrnd+0x0/0x38 @ 1
initcall initialize_hashrnd+0x0/0x38 returned 0 after 0 usecs
async_waiting @ 1
async_continuing @ 1 after 0 usec
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
async_waiting @ 1
async_continuing @ 1 after 0 usec
Freeing unused kernel memory: 1976k freed
Write protecting the kernel text: 9548k
Write protecting the kernel read-only data: 2808k
modprobe used greatest stack depth: 1708 bytes left
mount used greatest stack depth: 1312 bytes left
gzip used greatest stack depth: 1232 bytes left
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
rc.sysinit used greatest stack depth: 1144 bytes left
device: 'bpq0': device_add
Adding 3911816k swap on /dev/sda2.  Priority:-1 extents:1 across:3911816k 
device: 'vcs4': device_add
device: 'vcsa4': device_add
device: 'vcs10': device_add
device: 'vcsa10': device_add
device: 'vcs3': device_add
device: 'vcsa3': device_add
device: 'vcs8': device_add
device: 'vcsa8': device_add
device: 'vcs9': device_add
device: 'vcsa9': device_add
device: 'vcs6': device_add
device: 'vcsa6': device_add
device: 'vcs7': device_add
device: 'vcsa7': device_add
device: 'vcs5': device_add
device: 'vcsa5': device_add
device: 'vcs2': device_add
device: 'vcsa2': device_add

Fedora Core release 6 (Zod)
Kernel 2.6.31-tip-02343-gb432421-dirty on an i686

mercury login: kmemleak: 23 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
scp used greatest stack depth: 1100 bytes left
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
=============================================================================
BUG kmalloc-64: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00

Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a «....'ÿÿZZZZZZZZ
  Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .ó.ô`<.Ákkkkkkkk
  Object 0xf498f6b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf498f6c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
 Redzone 0xf498f6d0:  bb bb bb bb                                     »»»»            
 Padding 0xf498f6f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 3514, comm: sync Not tainted 2.6.31-tip-02343-gb432421-dirty #14071
Call Trace:
 [<c10e5b29>] print_trailer+0xf9/0x170
 [<c10e5c95>] check_bytes_and_report+0xf5/0x120
 [<c10e7129>] check_object+0x1e9/0x230
 [<c10e848d>] alloc_debug_processing+0xfd/0x1d0
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c10e8687>] __slab_alloc+0x127/0x330
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c10e8a43>] kmem_cache_alloc+0x1b3/0x1d0
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c111394b>] ? bdi_alloc_work+0x2b/0x100
 [<c11148a4>] ? bdi_writeback_all+0x34/0x190
 [<c111394b>] bdi_alloc_work+0x2b/0x100
 [<c194c6b2>] ? _spin_lock+0x72/0x90
 [<c11148e2>] bdi_writeback_all+0x72/0x190
 [<c107b3db>] ? mark_held_locks+0x6b/0xb0
 [<c194ab75>] ? __mutex_unlock_slowpath+0xf5/0x160
 [<c107b76c>] ? trace_hardirqs_on_caller+0x15c/0x1c0
 [<c1114a48>] sync_inodes_sb+0x48/0x70
 [<c1118b0b>] __sync_filesystem+0x7b/0x90
 [<c1118c13>] sync_filesystems+0xf3/0x140
 [<c1118cd7>] sys_sync+0x27/0x60
 [<c100344b>] sysenter_do_call+0x12/0x36
FIX kmalloc-64: Restoring 0xf498f6a0-0xf498f6a7=0x6b

FIX kmalloc-64: Marking all objects used
BUG: unable to handle kernel paging request at 6b6b6b6b
IP: [<6b6b6b6b>] 0x6b6b6b6b
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/net/eth0/address
Modules linked in:

Pid: 6, comm: ksoftirqd/1 Not tainted (2.6.31-tip-02343-gb432421-dirty #14071) System Product Name
EIP: 0060:[<6b6b6b6b>] EFLAGS: 00010206 CPU: 1
EIP is at 0x6b6b6b6b
EAX: f498f6a0 EBX: 6b6b6b6b ECX: 00000000 EDX: c35c5380
ESI: f498f6a0 EDI: 00000005 EBP: c3480f8c ESP: c3480f6c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process ksoftirqd/1 (pid: 6, ti=c3480000 task=f78a0000 task.ti=f787f000)
Stack:
 c10a4034 f5afe61c c35c5380 c35c5398 e1b95cbb c35c5380 c1c213a0 00000020
<0> c3480fa4 c10a41c0 fffffed4 e1b95cbb 00000100 c1c14a20 c3480fb0 c10a42bb
<0> e1b95cbb c3480ff8 c104ef8f 00000000 00000000 00000000 00000000 00000000
Call Trace:
 [<c10a4034>] ? rcu_do_batch+0xb4/0x1d0
 [<c10a41c0>] ? __rcu_process_callbacks+0x70/0x110
 [<c10a42bb>] ? rcu_process_callbacks+0x5b/0x80
 [<c104ef8f>] ? __do_softirq+0xef/0x210
 [<c104eea0>] ? __do_softirq+0x0/0x210
 <IRQ> 
 [<c104ead6>] ? ksoftirqd+0x86/0x1e0
 [<c104ea50>] ? ksoftirqd+0x0/0x1e0
 [<c1062fcc>] ? kthread+0x7c/0x90
 [<c1062f50>] ? kthread+0x0/0x90
 [<c1004127>] ? kernel_thread_helper+0x7/0x10
Code:  Bad EIP value.
EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:c3480f6c
CR2: 000000006b6b6b6b
---[ end trace 576cbee0829d5c9c ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 6, comm: ksoftirqd/1 Tainted: G      D    2.6.31-tip-02343-gb432421-dirty #14071
Call Trace:
 [<c1949133>] ? printk+0x23/0x40
 [<c194905b>] panic+0x5b/0x110
 [<c194e353>] oops_end+0xd3/0xe0
 [<c1029e9e>] no_context+0xce/0xf0
 [<c1029f43>] __bad_area_nosemaphore+0x83/0x1a0
 [<c13e9cfa>] ? __debug_check_no_obj_freed+0x7a/0x1b0
 [<c10e7009>] ? check_object+0xc9/0x230
 [<c195003d>] ? do_page_fault+0x2bd/0x400
 [<c102a07f>] bad_area_nosemaphore+0x1f/0x40
 [<c19500cc>] do_page_fault+0x34c/0x400
 [<c10e823d>] ? kmem_cache_free+0x11d/0x180
 [<c194fd80>] ? do_page_fault+0x0/0x400
 [<c194d6a8>] error_code+0x78/0x80
 [<c10a4034>] ? rcu_do_batch+0xb4/0x1d0
 [<c10a41c0>] __rcu_process_callbacks+0x70/0x110
 [<c10a42bb>] rcu_process_callbacks+0x5b/0x80
 [<c104ef8f>] __do_softirq+0xef/0x210
 [<c104eea0>] ? __do_softirq+0x0/0x210
 <IRQ>  [<c104ead6>] ? ksoftirqd+0x86/0x1e0
 [<c104ea50>] ? ksoftirqd+0x0/0x1e0
 [<c1062fcc>] ? kthread+0x7c/0x90
 [<c1062f50>] ? kthread+0x0/0x90
 [<c1004127>] ? kernel_thread_helper+0x7/0x10

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-Mon_Sep_14_08_54_02_CEST_2009.bad"

# b432421f
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Mon Sep 14 08:54:02 2009
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
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
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
# CONFIG_KTIME_SCALAR is not set
# CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED is not set
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
CONFIG_BROKEN_BOOT_DISALLOWED=y
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_MM_OWNER=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
# CONFIG_BUG is not set
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP_SUPPORT is not set
CONFIG_SPARSE_IRQ=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS=4096
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_CPU_DEBUG=y
CONFIG_UP_WANTED_1=y
# CONFIG_UP_WANTED_2 is not set
CONFIG_SMP=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
# CONFIG_PCIEAER is not set
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=m
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=m
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=m
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=y
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=m
# CONFIG_YAM is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=m
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
# CONFIG_WIRELESS is not set
CONFIG_WIRELESS_EXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set

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
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_OSD=m
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_BLK_DEV_HD=y
# CONFIG_MISC_DEVICES is not set
CONFIG_TIFM_CORE=m
CONFIG_DELL_LAPTOP=m
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=m
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=m
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_SRP=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_QLOGIC=m
# CONFIG_PCMCIA_SYM53C500 is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=y
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=m
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=m
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=y
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_SCH=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=m
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LAN is not set
# CONFIG_FUSION_LOGGING is not set

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
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=y
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_IFB is not set
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=m
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=m
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=y
CONFIG_ETHOC=m
CONFIG_DNET=m
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
# CONFIG_FEALNX is not set
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
CONFIG_SIS900=y
CONFIG_EPIC100=m
CONFIG_SMSC9420=y
# CONFIG_SUNDANCE is not set
CONFIG_TLAN=y
CONFIG_KS8842=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
# CONFIG_DE620 is not set
CONFIG_ATL2=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=y
CONFIG_IGBVF=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=m
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
CONFIG_ENIC=y
CONFIG_IXGBE=y
# CONFIG_IXGB is not set
CONFIG_S2IO=m
CONFIG_MYRI10GE=y
# CONFIG_NIU is not set
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
CONFIG_TEHUTI=y
# CONFIG_BNX2X is not set
CONFIG_QLGE=y
# CONFIG_SFC is not set
CONFIG_BE2NET=y
CONFIG_TR=m
CONFIG_IBMOL=m
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=y
CONFIG_PCMCIA_WAVELAN=m
# CONFIG_PCMCIA_NETWAVE is not set
CONFIG_WLAN_80211=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
# CONFIG_LIBERTAS_CS is not set
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
# CONFIG_USB_ZD1201 is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_HERMES=y
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
CONFIG_TMD_HERMES=y
CONFIG_NORTEL_HERMES=y
CONFIG_PCI_HERMES=y
# CONFIG_PCMCIA_HERMES is not set
CONFIG_PCMCIA_SPECTRUM=m

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=m
# CONFIG_WANXL is not set
CONFIG_PC300TOO=m
CONFIG_FARSYNC=m
# CONFIG_DSCC4 is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
CONFIG_CYCLOMX_X25=y
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
CONFIG_ATM_LANAI=m
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PLIP=m
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
CONFIG_PHONE=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
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
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=m
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_DA9034=m
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
# CONFIG_TOUCHSCREEN_WM9713 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=m
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=y
# CONFIG_SYNCLINK is not set
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=y
CONFIG_RISCOM8=y
CONFIG_SPECIALIX=m
CONFIG_SX=m
# CONFIG_RIO is not set
CONFIG_STALDRV=y
CONFIG_STALLION=m
# CONFIG_ISTALLION is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
# CONFIG_GEN_RTC_X is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=y
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set

#
# PPS support
#
CONFIG_PPS=y
CONFIG_PPS_DEBUG=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCF857X=m

#
# PCI GPIO expanders:
#

#
# SPI GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7473=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHER=y
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=y
CONFIG_UCB1400_CORE=m
CONFIG_TPS65010=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_AB3100_CORE=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_BQ24022=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
# CONFIG_MEDIA_TUNER_MC44S803 is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=m

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TDA9875 is not set
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_ADV7343=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
# CONFIG_VIDEO_ZORAN is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_TW9910=m
# CONFIG_SOC_CAMERA_PLATFORM is not set
# CONFIG_SOC_CAMERA_OV772X is not set
# CONFIG_V4L_USB_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=y
# CONFIG_FB_IMSTT is not set
CONFIG_FB_UVESA=m
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MULTIHEAD is not set
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=m
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=m
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_DA903X=m
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=m

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
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTS64=m
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_SB_COMMON=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
# CONFIG_SND_CS46XX_NEW_DSP is not set
# CONFIG_SND_CS5530 is not set
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
CONFIG_SND_HDA_CODEC_CA0110=y
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
CONFIG_SND_HDA_CODEC_SI3054=y
# CONFIG_SND_HDA_GENERIC is not set
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
# CONFIG_SND_MIXART is not set
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WM8400=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_SSCAPE=m
CONFIG_SOUND_VMIDI=m
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
# CONFIG_SOUND_PSS is not set
CONFIG_SOUND_SB=m
# CONFIG_SOUND_YM3812 is not set
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
# CONFIG_SOUND_KAHLUA is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y
CONFIG_USB_MOUSE=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_APPLE=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=m
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_NTRIG=m
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
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
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=m
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=y
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_BERRY_CHARGE is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_SISUSBVGA_CON is not set
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=m
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=m
CONFIG_UWB_HWA=m
# CONFIG_UWB_WHCI is not set
CONFIG_UWB_WLP=m
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_ALIX2=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_BD2802=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_DEBUG_VERBOSE is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set

#
# TI VLYNQ
#
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_OCFS2_FS_POSIX_ACL=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
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
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_NFS_FSCACHE=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
# CONFIG_NCPFS_EXTRAS is not set
CONFIG_CODA_FS=y
CONFIG_AFS_FS=m
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ALLOW_WARNINGS is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_BACKTRACE_SELF_TEST=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
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
# CONFIG_SECURITY_NETWORK_XFRM is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
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
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

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
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set
CONFIG_CRYPTO_FPU=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_64=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y

--wac7ysb48OaltWcw--
