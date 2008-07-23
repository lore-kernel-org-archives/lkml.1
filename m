Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYGWJeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYGWJeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYGWJeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:34:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51987 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbYGWJeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:34:01 -0400
Date: Wed, 23 Jul 2008 11:33:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [lockdep warning] INFO: inconsistent lock state,
	serial8250_interrupt(), &port_lock_key
Message-ID: <20080723093332.GA22109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-tip testing found this fresh lockdep warning on 64-bit x86:

=================================
[ INFO: inconsistent lock state ]
2.6.26-tip-06509-gb4ebc67-dirty #13600
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
agetty/7133 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&port_lock_key){+-..}, at: [<ffffffff804ed9a9>] serial8250_interrupt+0x79/0x160
{hardirq-on-W} state was registered at:
  [<ffffffff80265398>] __lock_acquire+0x388/0x1380
  [<ffffffff80266436>] lock_acquire+0xa6/0xe0
  [<ffffffff807dcb0a>] _spin_lock+0x2a/0x40
  [<ffffffff804ed4a7>] serial8250_startup+0x2f7/0x6b0
  [<ffffffff804e80cd>] uart_startup+0x6d/0x1a0
  [<ffffffff804e9ec9>] uart_open+0x129/0x4c0
  [<ffffffff804a8cf9>] tty_open+0x179/0x340
  [<ffffffff802b3ba5>] chrdev_open+0x95/0x180
  [<ffffffff802aee65>] __dentry_open+0xc5/0x270
  [<ffffffff802af054>] nameidata_to_filp+0x44/0x60
  [<ffffffff802bd244>] do_filp_open+0x1d4/0x960
  [<ffffffff802aecbd>] do_sys_open+0x5d/0xb0
  [<ffffffff802aed50>] sys_open+0x20/0x30
  [<ffffffff8020c93a>] system_call_after_swapgs+0x9a/0x9f
  [<ffffffffffffffff>] 0xffffffffffffffff
irq event stamp: 3734
hardirqs last  enabled at (3733): [<ffffffff80264b2d>] trace_hardirqs_on+0xd/0x10
hardirqs last disabled at (3734): [<ffffffff807dc6b2>] trace_hardirqs_off_thunk+0x3a/0x3c
softirqs last  enabled at (3008): [<ffffffff80246b9e>] __do_softirq+0xce/0xe0
softirqs last disabled at (2999): [<ffffffff8020dcbc>] call_softirq+0x1c/0x30

other info that might help us debug this:
1 lock held by agetty/7133:
 #0:  (&irq_lists[i].lock){+...}, at: [<ffffffff804ed954>] serial8250_interrupt+0x24/0x160

stack backtrace:
Pid: 7133, comm: agetty Not tainted 2.6.26-tip-06509-gb4ebc67-dirty #13600

Call Trace:
 <IRQ>  [<ffffffff8026383b>] print_usage_bug+0x18b/0x190
 [<ffffffff802647d4>] mark_lock+0x5a4/0x610
 [<ffffffff8026527f>] ? __lock_acquire+0x26f/0x1380
 [<ffffffff8026591a>] __lock_acquire+0x90a/0x1380
 [<ffffffff802808fc>] ? ftrace_record_ip+0xfc/0x260
 [<ffffffff804ed9a9>] ? serial8250_interrupt+0x79/0x160
 [<ffffffff80266436>] lock_acquire+0xa6/0xe0
 [<ffffffff804ed9a9>] ? serial8250_interrupt+0x79/0x160
 [<ffffffff807dcf4a>] _spin_lock_irqsave+0x4a/0x60
 [<ffffffff804ed9a9>] serial8250_interrupt+0x79/0x160
 [<ffffffff80277ee5>] handle_IRQ_event+0x35/0x80
 [<ffffffff802795e3>] handle_edge_irq+0xc3/0x130
 [<ffffffff8021035c>] do_IRQ+0x5c/0xc0
 [<ffffffff8020d003>] ret_from_intr+0x0/0x2e
 <EOI>  [<ffffffff8022b2a8>] ? do_page_fault+0xa8/0xd10
 [<ffffffff8022b2a0>] ? do_page_fault+0xa0/0xd10
 [<ffffffff807dc673>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff807dd1ca>] ? error_exit+0x0/0xc8

with this config:

  http://redhat.com/~mingo/misc/config-Wed_Jul_23_10_20_21_CEST_2008.bad

find the full bootlog below.

	Ingo

-------------------->
Initializing cgroup subsys cpu
Linux version 2.6.26-tip-06509-gb4ebc67-dirty (mingo@titan) (gcc version 4.2.3) #13600 Wed Jul 23 10:39:54 CEST 2008
Command line: root=/dev/sda1 earlyprintk=vga console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nosmp hpet=disable idle=mwait highmem=512m nopat pci=nomsi
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data)
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
console [earlyvga0] enabled
debug: ignoring loglevel setting.
last_pfn = 0x3ff00 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 003fe00000 page 2M
 003fe00000 - 003ff00000 page 4k
kernel direct mapping tables up to 3ff00000 @ 8000-b000
last_map_addr: 3ff00000 end: 3ff00000
DMI 2.3 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3FEFDE48, 0050 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACP 3FEFCF10, 0074 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: DSDT 3FEF8010, 3E70 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: FACS 3FEDFC40, 0040
ACPI: APIC 3FEFCE10, 0078 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: WDDT 3FEF7F90, 0040 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: MCFG 3FEF7F10, 003C (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: ASF! 3FEFCD10, 00A6 (r32 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: HPET 3FEF7E90, 0038 (r1 INTEL  D975XBX       4B9 MSFT  1000013)
ACPI: SSDT 3FEFDC10, 01BC (r1 INTEL     CpuPm      4B9 MSFT  1000013)
ACPI: SSDT 3FEFDA10, 01B7 (r1 INTEL   Cpu0Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD810, 01B7 (r1 INTEL   Cpu1Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD610, 01B7 (r1 INTEL   Cpu2Ist      4B9 MSFT  1000013)
ACPI: SSDT 3FEFD410, 01B7 (r1 INTEL   Cpu3Ist      4B9 MSFT  1000013)
Entering add_active_range(0, 0x0, 0x9f) 0 entries of 256 used
Entering add_active_range(0, 0x100, 0x3ed94) 1 entries of 256 used
Entering add_active_range(0, 0x3ee4e, 0x3fea2) 2 entries of 256 used
Entering add_active_range(0, 0x3fee9, 0x3feed) 3 entries of 256 used
Entering add_active_range(0, 0x3feff, 0x3ff00) 4 entries of 256 used
(5 early reservations) ==> bootmem [0000000000 - 003ff00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00010fa688]    TEXT DATA BSS ==> [0000200000 - 00010fa688]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 - 0000009000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000fe680] 000fe680
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003ed94
    0: 0x0003ee4e -> 0x0003fea2
    0: 0x0003fee9 -> 0x0003feed
    0: 0x0003feff -> 0x0003ff00
On node 0 totalpages: 261516
  DMA zone: 56 pages used for memmap
  DMA zone: 102 pages reserved
  DMA zone: 3841 pages, LIFO batch:0
  DMA32 zone: 3525 pages used for memmap
  DMA32 zone: 253992 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
WARNING: NR_CPUS limit of 1 reached. Processor ignored.
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffffffff5fc000 (        fee00000)
mapped IOAPIC to ffffffffff5fb000 (00000000fec00000)
Allocating PCI resources starting at 40000000 (gap: 3ff00000:c0100000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257833
Kernel command line: root=/dev/sda1 earlyprintk=vga console=ttyS0,115200 console=tty 5 profile=0 debug initcall_debug apic=debug apic=verbose ignore_loglevel sysrq_always_enabled pci=nomsi nosmp hpet=disable idle=mwait highmem=512m nopat pci=nomsi
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 2933.329 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [earlyvga0] -> real [tty0]
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1776 kB
 per task-struct memory footprint: 2688 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 990028k/1047552k available (6017k kernel code, 55308k reserved, 3166k data, 420k init)
CPA: page pool initialized 16 of 16 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>5866.65 BogoMIPS (lpj=2933329)
Security Framework initialized
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
using mwait in idle threads.
CPU: Intel(R) Core(TM)2 CPU         E6800  @ 2.93GHz stepping 05
ACPI: Core revision 20080609
Setting APIC routing to flat
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
APIC timer calibration result 16666623
Detected 16.666 MHz APIC timer.
device: 'platform': device_add
PM: Adding info for No Bus:platform
bus: 'platform': registered
Registering sysdev class 'cpu'
calling  net_ns_init+0x0/0x180
net_namespace: 912 bytes
initcall net_ns_init+0x0/0x180 returned 0 after 0 msecs
calling  print_banner+0x0/0x10
Booting paravirtualized kernel on bare hardware
initcall print_banner+0x0/0x10 returned 0 after 0 msecs
calling  sysctl_init+0x0/0x40
initcall sysctl_init+0x0/0x40 returned 0 after 0 msecs
calling  ksysfs_init+0x0/0xc0
initcall ksysfs_init+0x0/0xc0 returned 0 after 0 msecs
calling  init_jiffies_clocksource+0x0/0x20
initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 msecs
calling  pm_init+0x0/0x40
initcall pm_init+0x0/0x40 returned 0 after 0 msecs
calling  ftrace_dynamic_init+0x0/0x100
initcall ftrace_dynamic_init+0x0/0x100 returned 0 after 0 msecs
calling  filelock_init+0x0/0x40
initcall filelock_init+0x0/0x40 returned 0 after 0 msecs
calling  init_misc_binfmt+0x0/0x60
initcall init_misc_binfmt+0x0/0x60 returned 0 after 0 msecs
calling  init_script_binfmt+0x0/0x20
initcall init_script_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  init_elf_binfmt+0x0/0x20
initcall init_elf_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  init_compat_elf_binfmt+0x0/0x20
initcall init_compat_elf_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  debugfs_init+0x0/0x70
initcall debugfs_init+0x0/0x70 returned 0 after 0 msecs
calling  securityfs_init+0x0/0x70
initcall securityfs_init+0x0/0x70 returned 0 after 0 msecs
calling  random32_init+0x0/0x20
initcall random32_init+0x0/0x20 returned 0 after 0 msecs
calling  cpuidle_init+0x0/0x30
initcall cpuidle_init+0x0/0x30 returned 0 after 0 msecs
calling  virtio_init+0x0/0x30
bus: 'virtio': registered
initcall virtio_init+0x0/0x30 returned 0 after 0 msecs
calling  sock_init+0x0/0x60
initcall sock_init+0x0/0x60 returned 0 after 0 msecs
calling  netpoll_init+0x0/0x50
initcall netpoll_init+0x0/0x50 returned 0 after 0 msecs
calling  netlink_proto_init+0x0/0x180
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x180 returned 0 after 0 msecs
calling  bdi_class_init+0x0/0x50
device class 'bdi': registering
initcall bdi_class_init+0x0/0x50 returned 0 after 0 msecs
calling  kobject_uevent_init+0x0/0x50
initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 msecs
calling  pcibus_class_init+0x0/0x20
device class 'pci_bus': registering
initcall pcibus_class_init+0x0/0x20 returned 0 after 0 msecs
calling  pci_driver_init+0x0/0x20
bus: 'pci': registered
initcall pci_driver_init+0x0/0x20 returned 0 after 0 msecs
calling  lcd_class_init+0x0/0x60
device class 'lcd': registering
initcall lcd_class_init+0x0/0x60 returned 0 after 0 msecs
calling  backlight_class_init+0x0/0x60
device class 'backlight': registering
initcall backlight_class_init+0x0/0x60 returned 0 after 0 msecs
calling  video_output_class_init+0x0/0x1e
device class 'video_output': registering
initcall video_output_class_init+0x0/0x1e returned 0 after 0 msecs
calling  tty_class_init+0x0/0x40
device class 'tty': registering
initcall tty_class_init+0x0/0x40 returned 0 after 0 msecs
calling  vtconsole_class_init+0x0/0xf0
device class 'vtconsole': registering
device: 'vtcon0': device_add
PM: Adding info for No Bus:vtcon0
initcall vtconsole_class_init+0x0/0xf0 returned 0 after 2 msecs
calling  enable_pci_io_ecs+0x0/0xb0
initcall enable_pci_io_ecs+0x0/0xb0 returned 0 after 0 msecs
calling  early_fill_mp_bus_info+0x0/0x8f0
initcall early_fill_mp_bus_info+0x0/0x8f0 returned 0 after 0 msecs
calling  arch_kdebugfs_init+0x0/0x1f0
initcall arch_kdebugfs_init+0x0/0x1f0 returned 0 after 0 msecs
calling  mtrr_if_init+0x0/0x90
initcall mtrr_if_init+0x0/0x90 returned 0 after 0 msecs
calling  ffh_cstate_init+0x0/0x40
initcall ffh_cstate_init+0x0/0x40 returned 0 after 0 msecs
calling  acpi_pci_init+0x0/0x50
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x50 returned 0 after 0 msecs
calling  init_acpi_device_notify+0x0/0x50
initcall init_acpi_device_notify+0x0/0x50 returned 0 after 0 msecs
calling  dmi_id_init+0x0/0x320
device class 'dmi': registering
device: 'id': device_add
PM: Adding info for No Bus:id
initcall dmi_id_init+0x0/0x320 returned 0 after 3 msecs
calling  pci_arch_init+0x0/0x60
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x60 returned 0 after 2 msecs
calling  topology_init+0x0/0x20
Registering sys device of class 'cpu'
Registering sys device 'cpu0'
initcall topology_init+0x0/0x20 returned 0 after 1 msecs
calling  mtrr_init_finialize+0x0/0x50
initcall mtrr_init_finialize+0x0/0x50 returned 0 after 0 msecs
calling  param_sysfs_init+0x0/0x250
initcall param_sysfs_init+0x0/0x250 returned 0 after 5 msecs
calling  pm_sysrq_init+0x0/0x20
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 msecs
calling  readahead_init+0x0/0x40
device: 'default': device_add
PM: Adding info for No Bus:default
initcall readahead_init+0x0/0x40 returned 0 after 1 msecs
calling  init_bio+0x0/0x110
initcall init_bio+0x0/0x110 returned 0 after 0 msecs
calling  integrity_init+0x0/0x40
initcall integrity_init+0x0/0x40 returned 0 after 0 msecs
calling  blk_settings_init+0x0/0x40
initcall blk_settings_init+0x0/0x40 returned 0 after 0 msecs
calling  blk_ioc_init+0x0/0x30
initcall blk_ioc_init+0x0/0x30 returned 0 after 0 msecs
calling  genhd_device_init+0x0/0x60
device class 'block': registering
initcall genhd_device_init+0x0/0x60 returned 0 after 0 msecs
calling  blk_dev_integrity_init+0x0/0x30
initcall blk_dev_integrity_init+0x0/0x30 returned 0 after 0 msecs
calling  pci_slot_init+0x0/0x50
initcall pci_slot_init+0x0/0x50 returned 0 after 0 msecs
calling  fbmem_init+0x0/0xa0
device class 'graphics': registering
initcall fbmem_init+0x0/0xa0 returned 0 after 0 msecs
calling  acpi_init+0x0/0x226
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
initcall acpi_init+0x0/0x226 returned 0 after 23 msecs
calling  acpi_scan_init+0x0/0x115
bus: 'acpi': registered
device: 'LNXSYSTM:00': device_add
bus: 'acpi': add device LNXSYSTM:00
PM: Adding info for acpi:LNXSYSTM:00
device: 'LNXPWRBN:00': device_add
bus: 'acpi': add device LNXPWRBN:00
PM: Adding info for acpi:LNXPWRBN:00
device: 'ACPI0007:00': device_add
bus: 'acpi': add device ACPI0007:00
PM: Adding info for acpi:ACPI0007:00
device: 'ACPI0007:01': device_add
bus: 'acpi': add device ACPI0007:01
PM: Adding info for acpi:ACPI0007:01
device: 'ACPI0007:02': device_add
bus: 'acpi': add device ACPI0007:02
PM: Adding info for acpi:ACPI0007:02
device: 'ACPI0007:03': device_add
bus: 'acpi': add device ACPI0007:03
PM: Adding info for acpi:ACPI0007:03
device: 'device:00': device_add
bus: 'acpi': add device device:00
PM: Adding info for acpi:device:00
device: 'device:00': dev_uevent: bus uevent() returned -12
device: 'PNP0C0E:00': device_add
bus: 'acpi': add device PNP0C0E:00
PM: Adding info for acpi:PNP0C0E:00
device: 'PNP0A03:00': device_add
bus: 'acpi': add device PNP0A03:00
PM: Adding info for acpi:PNP0A03:00
device: 'PNP0C02:00': device_add
bus: 'acpi': add device PNP0C02:00
PM: Adding info for acpi:PNP0C02:00
device: 'device:01': device_add
bus: 'acpi': add device device:01
PM: Adding info for acpi:device:01
device: 'device:01': dev_uevent: bus uevent() returned -12
device: 'device:02': device_add
bus: 'acpi': add device device:02
PM: Adding info for acpi:device:02
device: 'device:02': dev_uevent: bus uevent() returned -12
device: 'PNP0C0F:00': device_add
bus: 'acpi': add device PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:00
device: 'PNP0C0F:01': device_add
bus: 'acpi': add device PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:01
device: 'PNP0C0F:02': device_add
bus: 'acpi': add device PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:02
device: 'PNP0C0F:03': device_add
bus: 'acpi': add device PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:03
device: 'PNP0C0F:04': device_add
bus: 'acpi': add device PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:04
device: 'PNP0C0F:05': device_add
bus: 'acpi': add device PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:05
device: 'PNP0C0F:06': device_add
bus: 'acpi': add device PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:06
device: 'PNP0C0F:07': device_add
bus: 'acpi': add device PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:07
device: 'PNP0200:00': device_add
bus: 'acpi': add device PNP0200:00
PM: Adding info for acpi:PNP0200:00
device: 'PNP0B00:00': device_add
bus: 'acpi': add device PNP0B00:00
PM: Adding info for acpi:PNP0B00:00
device: 'PNP0000:00': device_add
bus: 'acpi': add device PNP0000:00
PM: Adding info for acpi:PNP0000:00
device: 'PNP0C04:00': device_add
bus: 'acpi': add device PNP0C04:00
PM: Adding info for acpi:PNP0C04:00
device: 'PNP0100:00': device_add
bus: 'acpi': add device PNP0100:00
PM: Adding info for acpi:PNP0100:00
device: 'PNP0800:00': device_add
bus: 'acpi': add device PNP0800:00
PM: Adding info for acpi:PNP0800:00
device: 'PNP0C02:01': device_add
bus: 'acpi': add device PNP0C02:01
PM: Adding info for acpi:PNP0C02:01
device: 'PNP0700:00': device_add
bus: 'acpi': add device PNP0700:00
PM: Adding info for acpi:PNP0700:00
device: 'PNP0401:00': device_add
bus: 'acpi': add device PNP0401:00
PM: Adding info for acpi:PNP0401:00
device: 'PNP0F03:00': device_add
bus: 'acpi': add device PNP0F03:00
PM: Adding info for acpi:PNP0F03:00
device: 'PNP0303:00': device_add
bus: 'acpi': add device PNP0303:00
PM: Adding info for acpi:PNP0303:00
device: 'PNP0501:00': device_add
bus: 'acpi': add device PNP0501:00
PM: Adding info for acpi:PNP0501:00
device: 'device:03': device_add
bus: 'acpi': add device device:03
PM: Adding info for acpi:device:03
device: 'device:03': dev_uevent: bus uevent() returned -12
device: 'device:04': device_add
bus: 'acpi': add device device:04
PM: Adding info for acpi:device:04
device: 'device:04': dev_uevent: bus uevent() returned -12
device: 'device:05': device_add
bus: 'acpi': add device device:05
PM: Adding info for acpi:device:05
device: 'device:05': dev_uevent: bus uevent() returned -12
device: 'device:06': device_add
bus: 'acpi': add device device:06
PM: Adding info for acpi:device:06
device: 'device:06': dev_uevent: bus uevent() returned -12
device: 'device:07': device_add
bus: 'acpi': add device device:07
PM: Adding info for acpi:device:07
device: 'device:07': dev_uevent: bus uevent() returned -12
device: 'device:08': device_add
bus: 'acpi': add device device:08
PM: Adding info for acpi:device:08
device: 'device:08': dev_uevent: bus uevent() returned -12
device: 'PNP0003:00': device_add
bus: 'acpi': add device PNP0003:00
PM: Adding info for acpi:PNP0003:00
device: 'device:09': device_add
bus: 'acpi': add device device:09
PM: Adding info for acpi:device:09
device: 'device:09': dev_uevent: bus uevent() returned -12
device: 'device:0a': device_add
bus: 'acpi': add device device:0a
PM: Adding info for acpi:device:0a
device: 'device:0a': dev_uevent: bus uevent() returned -12
device: 'device:0b': device_add
bus: 'acpi': add device device:0b
PM: Adding info for acpi:device:0b
device: 'device:0b': dev_uevent: bus uevent() returned -12
device: 'device:0c': device_add
bus: 'acpi': add device device:0c
PM: Adding info for acpi:device:0c
device: 'device:0c': dev_uevent: bus uevent() returned -12
device: 'device:0d': device_add
bus: 'acpi': add device device:0d
PM: Adding info for acpi:device:0d
device: 'device:0d': dev_uevent: bus uevent() returned -12
device: 'device:0e': device_add
bus: 'acpi': add device device:0e
PM: Adding info for acpi:device:0e
device: 'device:0e': dev_uevent: bus uevent() returned -12
device: 'device:0f': device_add
bus: 'acpi': add device device:0f
PM: Adding info for acpi:device:0f
device: 'device:0f': dev_uevent: bus uevent() returned -12
device: 'device:10': device_add
bus: 'acpi': add device device:10
PM: Adding info for acpi:device:10
device: 'device:10': dev_uevent: bus uevent() returned -12
device: 'device:11': device_add
bus: 'acpi': add device device:11
PM: Adding info for acpi:device:11
device: 'device:11': dev_uevent: bus uevent() returned -12
device: 'device:12': device_add
bus: 'acpi': add device device:12
PM: Adding info for acpi:device:12
device: 'device:12': dev_uevent: bus uevent() returned -12
device: 'device:13': device_add
bus: 'acpi': add device device:13
PM: Adding info for acpi:device:13
device: 'device:13': dev_uevent: bus uevent() returned -12
device: 'device:14': device_add
bus: 'acpi': add device device:14
PM: Adding info for acpi:device:14
device: 'device:14': dev_uevent: bus uevent() returned -12
device: 'device:15': device_add
bus: 'acpi': add device device:15
PM: Adding info for acpi:device:15
device: 'device:15': dev_uevent: bus uevent() returned -12
device: 'device:16': device_add
bus: 'acpi': add device device:16
PM: Adding info for acpi:device:16
device: 'device:16': dev_uevent: bus uevent() returned -12
device: 'device:17': device_add
bus: 'acpi': add device device:17
PM: Adding info for acpi:device:17
device: 'device:17': dev_uevent: bus uevent() returned -12
device: 'device:18': device_add
bus: 'acpi': add device device:18
PM: Adding info for acpi:device:18
device: 'device:18': dev_uevent: bus uevent() returned -12
device: 'device:19': device_add
bus: 'acpi': add device device:19
PM: Adding info for acpi:device:19
device: 'device:19': dev_uevent: bus uevent() returned -12
device: 'device:1a': device_add
bus: 'acpi': add device device:1a
PM: Adding info for acpi:device:1a
device: 'device:1a': dev_uevent: bus uevent() returned -12
device: 'LNXTHERM:00': device_add
bus: 'acpi': add device LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:00
initcall acpi_scan_init+0x0/0x115 returned 0 after 202 msecs
calling  acpi_ec_init+0x0/0x66
bus: 'acpi': add driver ec
initcall acpi_ec_init+0x0/0x66 returned 0 after 0 msecs
calling  acpi_pci_root_init+0x0/0x2d
bus: 'acpi': add driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:00 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:00
ACPI: PCI Root Bridge [PCI0] (0000:00)
device: 'pci0000:00': device_add
PM: Adding info for No Bus:pci0000:00
device: '0000:00': device_add
PM: Adding info for No Bus:0000:00
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [50400000, 50403fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [4080, 409f]
PCI: 0000:00:1d.1 reg 20 io port: [4060, 407f]
PCI: 0000:00:1d.2 reg 20 io port: [4040, 405f]
PCI: 0000:00:1d.3 reg 20 io port: [4020, 403f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [50404400, 504047ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
PCI: 0000:00:1f.1 reg 20 io port: [40b0, 40bf]
PCI: 0000:00:1f.2 reg 10 io port: [40c8, 40cf]
PCI: 0000:00:1f.2 reg 14 io port: [40e4, 40e7]
PCI: 0000:00:1f.2 reg 18 io port: [40c0, 40c7]
PCI: 0000:00:1f.2 reg 1c io port: [40e0, 40e3]
PCI: 0000:00:1f.2 reg 20 io port: [40a0, 40af]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [50404000, 504043ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [4000, 401f]
PCI: 0000:01:00.0 reg 10 64bit mmio: [40000000, 4fffffff]
PCI: 0000:01:00.0 reg 18 64bit mmio: [50300000, 5030ffff]
PCI: 0000:01:00.0 reg 20 io port: [3000, 30ff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
PCI: 0000:01:00.1 reg 10 64bit mmio: [50310000, 5031ffff]
pci 0000:01:00.1: supports D1
pci 0000:01:00.1: supports D2
PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
PCI: bridge 0000:00:01.0 32bit mmio: [50300000, 503fffff]
PCI: bridge 0000:00:01.0 64bit mmio pref: [40000000, 4fffffff]
PCI: 0000:02:00.0 reg 10 64bit mmio: [50200000, 502fffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:1c.0 32bit mmio: [50200000, 502fffff]
PCI: 0000:04:00.0 reg 10 32bit mmio: [50100000, 5011ffff]
PCI: 0000:04:00.0 reg 18 io port: [2000, 201f]
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
PCI: bridge 0000:00:1c.5 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.5 32bit mmio: [50100000, 501fffff]
PCI: 0000:05:02.0 reg 10 32bit mmio: [50000000, 50007fff]
PCI: 0000:05:04.0 reg 10 32bit mmio: [5000c000, 5000c7ff]
PCI: 0000:05:04.0 reg 14 32bit mmio: [50008000, 5000bfff]
pci 0000:05:04.0: supports D1
pci 0000:05:04.0: supports D2
pci 0000:05:04.0: PME# supported from D0 D1 D2 D3hot
pci 0000:05:04.0: PME# disabled
PCI: 0000:05:05.0 reg 10 io port: [1018, 101f]
PCI: 0000:05:05.0 reg 14 io port: [1024, 1027]
PCI: 0000:05:05.0 reg 18 io port: [1010, 1017]
PCI: 0000:05:05.0 reg 1c io port: [1020, 1023]
PCI: 0000:05:05.0 reg 20 io port: [1000, 100f]
PCI: 0000:05:05.0 reg 24 32bit mmio: [5000c800, 5000cbff]
pci 0000:05:05.0: supports D1
pci 0000:05:05.0: supports D2
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [1000, 1fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [50000000, 500fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
PM: Adding info for pci:0000:00:00.0
device: '0000:00:01.0': device_add
bus: 'pci': add device 0000:00:01.0
PM: Adding info for pci:0000:00:01.0
device: '0000:00:1b.0': device_add
bus: 'pci': add device 0000:00:1b.0
PM: Adding info for pci:0000:00:1b.0
device: '0000:00:1c.0': device_add
bus: 'pci': add device 0000:00:1c.0
PM: Adding info for pci:0000:00:1c.0
device: '0000:00:1c.4': device_add
bus: 'pci': add device 0000:00:1c.4
PM: Adding info for pci:0000:00:1c.4
device: '0000:00:1c.5': device_add
bus: 'pci': add device 0000:00:1c.5
PM: Adding info for pci:0000:00:1c.5
device: '0000:00:1d.0': device_add
bus: 'pci': add device 0000:00:1d.0
PM: Adding info for pci:0000:00:1d.0
device: '0000:00:1d.1': device_add
bus: 'pci': add device 0000:00:1d.1
PM: Adding info for pci:0000:00:1d.1
device: '0000:00:1d.2': device_add
bus: 'pci': add device 0000:00:1d.2
PM: Adding info for pci:0000:00:1d.2
device: '0000:00:1d.3': device_add
bus: 'pci': add device 0000:00:1d.3
PM: Adding info for pci:0000:00:1d.3
device: '0000:00:1d.7': device_add
bus: 'pci': add device 0000:00:1d.7
PM: Adding info for pci:0000:00:1d.7
device: '0000:00:1e.0': device_add
bus: 'pci': add device 0000:00:1e.0
PM: Adding info for pci:0000:00:1e.0
device: '0000:00:1f.0': device_add
bus: 'pci': add device 0000:00:1f.0
PM: Adding info for pci:0000:00:1f.0
device: '0000:00:1f.1': device_add
bus: 'pci': add device 0000:00:1f.1
PM: Adding info for pci:0000:00:1f.1
device: '0000:00:1f.2': device_add
bus: 'pci': add device 0000:00:1f.2
PM: Adding info for pci:0000:00:1f.2
device: '0000:00:1f.3': device_add
bus: 'pci': add device 0000:00:1f.3
PM: Adding info for pci:0000:00:1f.3
device: '0000:01:00.0': device_add
bus: 'pci': add device 0000:01:00.0
PM: Adding info for pci:0000:01:00.0
device: '0000:01:00.1': device_add
bus: 'pci': add device 0000:01:00.1
PM: Adding info for pci:0000:01:00.1
device: '0000:01': device_add
PM: Adding info for No Bus:0000:01
device: '0000:02:00.0': device_add
bus: 'pci': add device 0000:02:00.0
PM: Adding info for pci:0000:02:00.0
device: '0000:02': device_add
PM: Adding info for No Bus:0000:02
device: '0000:03': device_add
PM: Adding info for No Bus:0000:03
device: '0000:04:00.0': device_add
bus: 'pci': add device 0000:04:00.0
PM: Adding info for pci:0000:04:00.0
device: '0000:04': device_add
PM: Adding info for No Bus:0000:04
device: '0000:05:02.0': device_add
bus: 'pci': add device 0000:05:02.0
PM: Adding info for pci:0000:05:02.0
device: '0000:05:04.0': device_add
bus: 'pci': add device 0000:05:04.0
PM: Adding info for pci:0000:05:04.0
device: '0000:05:05.0': device_add
bus: 'pci': add device 0000:05:05.0
PM: Adding info for pci:0000:05:05.0
device: '0000:05': device_add
PM: Adding info for No Bus:0000:05
driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
initcall acpi_pci_root_init+0x0/0x2d returned 0 after 170 msecs
calling  acpi_pci_link_init+0x0/0x4d
bus: 'acpi': add driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
initcall acpi_pci_link_init+0x0/0x4d returned 0 after 61 msecs
calling  acpi_power_init+0x0/0x7c
bus: 'acpi': add driver power
initcall acpi_power_init+0x0/0x7c returned 0 after 0 msecs
calling  acpi_system_init+0x0/0x1ab
initcall acpi_system_init+0x0/0x1ab returned 0 after 0 msecs
calling  acpi_wmi_init+0x0/0x54
bus: 'acpi': add driver wmi
ACPI: WMI: Mapper loaded
initcall acpi_wmi_init+0x0/0x54 returned 0 after 1 msecs
calling  acpi_cm_sbs_init+0x0/0x11
initcall acpi_cm_sbs_init+0x0/0x11 returned 0 after 0 msecs
calling  pnp_init+0x0/0x30
Linux Plug and Play Support v0.97 (c) Adam Belay
bus: 'pnp': registered
initcall pnp_init+0x0/0x30 returned 0 after 1 msecs
calling  pnpacpi_init+0x0/0xa0
pnp: PnP ACPI init
device: 'pnp0': device_add
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
device: '00:00': device_add
bus: 'pnp': add device 00:00
PM: Adding info for pnp:00:00
device: '00:01': device_add
bus: 'pnp': add device 00:01
PM: Adding info for pnp:00:01
device: '00:02': device_add
bus: 'pnp': add device 00:02
PM: Adding info for pnp:00:02
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
device: '00:03': device_add
bus: 'pnp': add device 00:03
PM: Adding info for pnp:00:03
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
device: '00:04': device_add
bus: 'pnp': add device 00:04
PM: Adding info for pnp:00:04
device: '00:05': device_add
bus: 'pnp': add device 00:05
PM: Adding info for pnp:00:05
device: '00:06': device_add
bus: 'pnp': add device 00:06
PM: Adding info for pnp:00:06
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
device: '00:07': device_add
bus: 'pnp': add device 00:07
PM: Adding info for pnp:00:07
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
device: '00:08': device_add
bus: 'pnp': add device 00:08
PM: Adding info for pnp:00:08
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
device: '00:09': device_add
bus: 'pnp': add device 00:09
PM: Adding info for pnp:00:09
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
device: '00:0a': device_add
bus: 'pnp': add device 00:0a
PM: Adding info for pnp:00:0a
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
device: '00:0b': device_add
bus: 'pnp': add device 00:0b
PM: Adding info for pnp:00:0b
device: '00:0c': device_add
bus: 'pnp': add device 00:0c
PM: Adding info for pnp:00:0c
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0xa0 returned 0 after 55 msecs
calling  misc_init+0x0/0xb0
device class 'misc': registering
initcall misc_init+0x0/0xb0 returned 0 after 0 msecs
calling  tifm_init+0x0/0x90
bus: 'tifm': registered
device class 'tifm_adapter': registering
initcall tifm_init+0x0/0x90 returned 0 after 2 msecs
calling  phy_init+0x0/0x50
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
initcall phy_init+0x0/0x50 returned 0 after 1 msecs
calling  init_dvbdev+0x0/0xe0
device class 'dvb': registering
initcall init_dvbdev+0x0/0xe0 returned 0 after 0 msecs
calling  init_scsi+0x0/0xb0
device class 'scsi_host': registering
bus: 'scsi': registered
device class 'scsi_device': registering
SCSI subsystem initialized
initcall init_scsi+0x0/0xb0 returned 0 after 3 msecs
calling  ata_init+0x0/0x3a0
libata version 3.00 loaded.
initcall ata_init+0x0/0x3a0 returned 0 after 0 msecs
calling  usb_init+0x0/0x120
bus: 'usb': registered
device class 'usb_host': registering
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
usbcore: registered new device driver usb
initcall usb_init+0x0/0x120 returned 0 after 8 msecs
calling  serio_init+0x0/0xb0
bus: 'serio': registered
initcall serio_init+0x0/0xb0 returned 0 after 0 msecs
calling  gameport_init+0x0/0xb0
bus: 'gameport': registered
initcall gameport_init+0x0/0xb0 returned 0 after 1 msecs
calling  input_init+0x0/0x130
device class 'input': registering
initcall input_init+0x0/0x130 returned 0 after 0 msecs
calling  power_supply_class_init+0x0/0x40
device class 'power_supply': registering
initcall power_supply_class_init+0x0/0x40 returned 0 after 0 msecs
calling  thermal_init+0x0/0x60
device class 'thermal': registering
initcall thermal_init+0x0/0x60 returned 0 after 0 msecs
calling  mmc_init+0x0/0x90
bus: 'mmc': registered
device class 'mmc_host': registering
bus: 'sdio': registered
initcall mmc_init+0x0/0x90 returned 0 after 2 msecs
calling  ac97_bus_init+0x0/0x20
bus: 'ac97': registered
initcall ac97_bus_init+0x0/0x20 returned 0 after 0 msecs
calling  pci_subsys_init+0x0/0x130
PCI: Using ACPI for IRQ routing
number of MP IRQ sources: 15.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.... register #01: 00170020
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0020
.... register #02: 00170020
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 001 0    0    0   0   0    1    1    31
 02 001 0    0    0   0   0    1    1    30
 03 001 0    0    0   0   0    1    1    33
 04 001 0    0    0   0   0    1    1    34
 05 001 0    0    0   0   0    1    1    35
 06 001 0    0    0   0   0    1    1    36
 07 001 0    0    0   0   0    1    1    37
 08 001 0    0    0   0   0    1    1    38
 09 001 0    1    0   0   0    1    1    39
 0a 001 0    0    0   0   0    1    1    3A
 0b 001 0    0    0   0   0    1    1    3B
 0c 001 0    0    0   0   0    1    1    3C
 0d 001 0    0    0   0   0    1    1    3D
 0e 001 0    0    0   0   0    1    1    3E
 0f 001 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
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
initcall pci_subsys_init+0x0/0x130 returned 0 after 73 msecs
calling  proto_init+0x0/0x40
initcall proto_init+0x0/0x40 returned 0 after 0 msecs
calling  net_dev_init+0x0/0x140
device class 'net': registering
initcall net_dev_init+0x0/0x140 returned 0 after 0 msecs
calling  neigh_init+0x0/0x80
initcall neigh_init+0x0/0x80 returned 0 after 0 msecs
calling  fib_rules_init+0x0/0xc0
initcall fib_rules_init+0x0/0xc0 returned 0 after 0 msecs
calling  genl_init+0x0/0xe0
initcall genl_init+0x0/0xe0 returned 0 after 4 msecs
calling  cipso_v4_init+0x0/0xa0
initcall cipso_v4_init+0x0/0xa0 returned 0 after 0 msecs
calling  wanrouter_init+0x0/0x60
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x60 returned 0 after 1 msecs
calling  wireless_nlevent_init+0x0/0x50
initcall wireless_nlevent_init+0x0/0x50 returned 0 after 0 msecs
calling  netlbl_init+0x0/0x90
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x90 returned 0 after 3 msecs
calling  sysctl_init+0x0/0x50
initcall sysctl_init+0x0/0x50 returned 0 after 0 msecs
calling  pci_iommu_init+0x0/0x30
PCI-GART: No AMD northbridge found.
initcall pci_iommu_init+0x0/0x30 returned 0 after 0 msecs
calling  hpet_late_init+0x0/0x140
initcall hpet_late_init+0x0/0x140 returned -19 after 0 msecs
calling  init_kmmio+0x0/0x40
initcall init_kmmio+0x0/0x40 returned 0 after 0 msecs
calling  clocksource_done_booting+0x0/0x20
initcall clocksource_done_booting+0x0/0x20 returned 0 after 0 msecs
calling  ftrace_init_debugfs+0x0/0x130
initcall ftrace_init_debugfs+0x0/0x130 returned 0 after 0 msecs
calling  tracer_alloc_buffers+0x0/0x590
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
initcall tracer_alloc_buffers+0x0/0x590 returned 0 after 10 msecs
calling  init_pipe_fs+0x0/0x60
initcall init_pipe_fs+0x0/0x60 returned 0 after 0 msecs
calling  init_mnt_writers+0x0/0x50
initcall init_mnt_writers+0x0/0x50 returned 0 after 0 msecs
calling  eventpoll_init+0x0/0xa0
initcall eventpoll_init+0x0/0xa0 returned 0 after 0 msecs
calling  anon_inode_init+0x0/0x130
initcall anon_inode_init+0x0/0x130 returned 0 after 0 msecs
calling  acpi_event_init+0x0/0x57
initcall acpi_event_init+0x0/0x57 returned 0 after 2 msecs
calling  pnp_system_init+0x0/0x20
bus: 'pnp': add driver system
bus: 'pnp': driver_probe_device: matched device 00:01 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:01
system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
Clocksource tsc unstable (delta = 973466304 ns)
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff has been reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
driver: '00:01': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:01 to driver system
bus: 'pnp': driver_probe_device: matched device 00:06 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:06
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
driver: '00:06': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:06 to driver system
initcall pnp_system_init+0x0/0x20 returned 0 after 64 msecs
calling  chr_dev_init+0x0/0xe0
device class 'mem': registering
device: 'mem': device_add
PM: Adding info for No Bus:mem
device: 'null': device_add
PM: Adding info for No Bus:null
device: 'port': device_add
PM: Adding info for No Bus:port
device: 'zero': device_add
PM: Adding info for No Bus:zero
device: 'full': device_add
PM: Adding info for No Bus:full
device: 'random': device_add
PM: Adding info for No Bus:random
device: 'urandom': device_add
PM: Adding info for No Bus:urandom
device: 'kmsg': device_add
PM: Adding info for No Bus:kmsg
device: 'oldmem': device_add
PM: Adding info for No Bus:oldmem
initcall chr_dev_init+0x0/0xe0 returned 0 after 18 msecs
calling  firmware_class_init+0x0/0x90
device class 'firmware': registering
initcall firmware_class_init+0x0/0x90 returned 0 after 0 msecs
calling  loopback_init+0x0/0x20
device: 'lo': device_add
PM: Adding info for No Bus:lo
initcall loopback_init+0x0/0x20 returned 0 after 3 msecs
calling  init_acpi_pm_clocksource+0x0/0xc0
initcall init_acpi_pm_clocksource+0x0/0xc0<6>Switched to NOHz mode on CPU #0
 returned 0 after 0 msecs
calling  ssb_modinit+0x0/0x70
bus: 'ssb': registered
initcall ssb_modinit+0x0/0x70 returned 0 after 2 msecs
calling  pcibios_assign_resources+0x0/0xa0
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x0000004fffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: disabled
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
pci 0000:00:1c.5:   MEM window: 0x50100000-0x501fffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
pci 0000:00:1e.0:   MEM window: 0x50000000-0x500fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
IOAPIC[0]: Set routing entry (2-16 -> 0x49 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
IOAPIC[0]: Set routing entry (2-17 -> 0x51 -> IRQ 17 Mode:1 Active:1)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [3000, 3fff]
bus: 01 index 1 mmio: [50300000, 503fffff]
bus: 01 index 2 mmio: [40000000, 4fffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [50200000, 502fffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [0, 0]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [2000, 2fff]
bus: 04 index 1 mmio: [50100000, 501fffff]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 io port: [1000, 1fff]
bus: 05 index 1 mmio: [50000000, 500fffff]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffffffffffff]
initcall pcibios_assign_resources+0x0/0xa0 returned 0 after 213 msecs
calling  inet_init+0x0/0x230
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x230 returned 0 after 42 msecs
calling  af_unix_init+0x0/0x70
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x70 returned 0 after 2 msecs
calling  populate_rootfs+0x0/0x130
initcall populate_rootfs+0x0/0x130 returned 0 after 0 msecs
calling  calgary_fixup_tce_spaces+0x0/0x120
initcall calgary_fixup_tce_spaces+0x0/0x120 returned -19 after 0 msecs
calling  pci_init+0x0/0x40
pci 0000:01:00.0: Boot video device
initcall pci_init+0x0/0x40 returned 0 after 3 msecs
calling  ehci_hcd_init+0x0/0x20
bus: 'pci': add driver ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with driver ehci_hcd
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:1d.7
IOAPIC[0]: Set routing entry (2-23 -> 0x59 -> IRQ 23 Mode:1 Active:1)
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
device: 'usb_host1': device_add
PM: Adding info for No Bus:usb_host1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50404400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
device: 'usb1': device_add
bus: 'usb': add device usb1
PM: Adding info for usb:usb1
bus: 'usb': driver_probe_device: matched device usb1 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb1
usb usb1: configuration #1 chosen from 1 choice
device: '1-0:1.0': device_add
bus: 'usb': add device 1-0:1.0
PM: Adding info for usb:1-0:1.0
bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
driver: '1-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
device class 'usb_endpoint': registering
device: 'usbdev1.1_ep81': device_add
PM: Adding info for No Bus:usbdev1.1_ep81
driver: 'usb1': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb1 to driver usb
device: 'usbdev1.1_ep00': device_add
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-tip-06509-gb4ebc67-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd
initcall ehci_hcd_init+0x0/0x20 returned 0 after 295 msecs
calling  ohci_hcd_mod_init+0x0/0x80
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
bus: 'pci': add driver ohci_hcd
bus: 'platform': add driver sm501-usb
initcall ohci_hcd_mod_init+0x0/0x80 returned 0 after 12 msecs
calling  uhci_hcd_init+0x0/0xd0
USB Universal Host Controller Interface driver v3.0
bus: 'pci': add driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.0 with driver uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
device: 'usb_host2': device_add
PM: Adding info for No Bus:usb_host2
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
device: 'usb2': device_add
bus: 'usb': add device usb2
PM: Adding info for usb:usb2
bus: 'usb': driver_probe_device: matched device usb2 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb2
usb usb2: configuration #1 chosen from 1 choice
device: '2-0:1.0': device_add
bus: 'usb': add device 2-0:1.0
PM: Adding info for usb:2-0:1.0
bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
driver: '2-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
device: 'usbdev2.1_ep81': device_add
PM: Adding info for No Bus:usbdev2.1_ep81
driver: 'usb2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb2 to driver usb
device: 'usbdev2.1_ep00': device_add
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26-tip-06509-gb4ebc67-dirty uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
driver: '0000:00:1d.0': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.0 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.1 with driver uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.1
IOAPIC[0]: Set routing entry (2-19 -> 0x61 -> IRQ 19 Mode:1 Active:1)
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
device: 'usb_host3': device_add
PM: Adding info for No Bus:usb_host3
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
device: 'usb3': device_add
bus: 'usb': add device usb3
PM: Adding info for usb:usb3
bus: 'usb': driver_probe_device: matched device usb3 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb3
usb usb3: configuration #1 chosen from 1 choice
device: '3-0:1.0': device_add
bus: 'usb': add device 3-0:1.0
PM: Adding info for usb:3-0:1.0
bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
driver: '3-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
device: 'usbdev3.1_ep81': device_add
PM: Adding info for No Bus:usbdev3.1_ep81
driver: 'usb3': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb3 to driver usb
device: 'usbdev3.1_ep00': device_add
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26-tip-06509-gb4ebc67-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with driver uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.2
IOAPIC[0]: Set routing entry (2-18 -> 0x69 -> IRQ 18 Mode:1 Active:1)
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
device: 'usb_host4': device_add
PM: Adding info for No Bus:usb_host4
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
device: 'usb4': device_add
bus: 'usb': add device usb4
PM: Adding info for usb:usb4
bus: 'usb': driver_probe_device: matched device usb4 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb4
usb usb4: configuration #1 chosen from 1 choice
device: '4-0:1.0': device_add
bus: 'usb': add device 4-0:1.0
PM: Adding info for usb:4-0:1.0
bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
driver: '4-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
device: 'usbdev4.1_ep81': device_add
PM: Adding info for No Bus:usbdev4.1_ep81
driver: 'usb4': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb4 to driver usb
device: 'usbdev4.1_ep00': device_add
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26-tip-06509-gb4ebc67-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with driver uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.3
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
device: 'usb_host5': device_add
PM: Adding info for No Bus:usb_host5
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
device: 'usb5': device_add
bus: 'usb': add device usb5
PM: Adding info for usb:usb5
bus: 'usb': driver_probe_device: matched device usb5 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb5
usb usb5: configuration #1 chosen from 1 choice
device: '5-0:1.0': device_add
bus: 'usb': add device 5-0:1.0
PM: Adding info for usb:5-0:1.0
bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
driver: '5-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
device: 'usbdev5.1_ep81': device_add
PM: Adding info for No Bus:usbdev5.1_ep81
driver: 'usb5': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb5 to driver usb
device: 'usbdev5.1_ep00': device_add
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26-tip-06509-gb4ebc67-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd
initcall uhci_hcd_init+0x0/0xd0 returned 0 after 1040 msecs
calling  i8259A_init_sysfs+0x0/0x30
Registering sysdev class 'i8259'
Registering sys device of class 'i8259'
Registering sys device 'i82590'
initcall i8259A_init_sysfs+0x0/0x30 returned 0 after 9 msecs
calling  vsyscall_init+0x0/0xd0
initcall vsyscall_init+0x0/0xd0 returned 0 after 0 msecs
calling  sbf_init+0x0/0xf0
initcall sbf_init+0x0/0xf0 returned 0 after 0 msecs
calling  i8237A_init_sysfs+0x0/0x30
Registering sysdev class 'i8237'
Registering sys device of class 'i8237'
Registering sys device 'i82370'
initcall i8237A_init_sysfs+0x0/0x30 returned 0 after 9 msecs
calling  add_rtc_cmos+0x0/0x20
initcall add_rtc_cmos+0x0/0x20 returned 0 after 0 msecs
calling  cache_sysfs_init+0x0/0x250
initcall cache_sysfs_init+0x0/0x250 returned 0 after 0 msecs
calling  mce_init_device+0x0/0x130
Registering sysdev class 'machinecheck'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck0'
device: 'mcelog': device_add
PM: Adding info for No Bus:mcelog
initcall mce_init_device+0x0/0x130 returned 0 after 16 msecs
calling  periodic_mcheck_init+0x0/0x50
initcall periodic_mcheck_init+0x0/0x50 returned 0 after 0 msecs
calling  thermal_throttle_init_device+0x0/0x50
initcall thermal_throttle_init_device+0x0/0x50 returned 0 after 0 msecs
calling  threshold_init_device+0x0/0x110
initcall threshold_init_device+0x0/0x110 returned 0 after 0 msecs
calling  msr_init+0x0/0xd0
device class 'msr': registering
device: 'msr0': device_add
PM: Adding info for No Bus:msr0
initcall msr_init+0x0/0xd0 returned 0 after 8 msecs
calling  init_lapic_sysfs+0x0/0x40
Registering sysdev class 'lapic'
Registering sys device of class 'lapic'
Registering sys device 'lapic0'
initcall init_lapic_sysfs+0x0/0x40 returned 0 after 9 msecs
calling  ioapic_init_sysfs+0x0/0xe0
Registering sysdev class 'ioapic'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic0'
initcall ioapic_init_sysfs+0x0/0xe0 returned 0 after 9 msecs
calling  add_pcspkr+0x0/0x60
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
PM: Adding info for platform:pcspkr
initcall add_pcspkr+0x0/0x60 returned 0 after 13 msecs
calling  uv_ptc_init+0x0/0x80
initcall uv_ptc_init+0x0/0x80 returned 0 after 0 msecs
calling  uv_bau_init+0x0/0x460
initcall uv_bau_init+0x0/0x460 returned 0 after 0 msecs
calling  debug_pagealloc_proc_init+0x0/0x30
initcall debug_pagealloc_proc_init+0x0/0x30 returned 0 after 0 msecs
calling  pt_dump_init+0x0/0x30
initcall pt_dump_init+0x0/0x30 returned 0 after 0 msecs
calling  init+0x0/0x20
initcall init+0x0/0x20 returned 0 after 0 msecs
calling  init+0x0/0x20
initcall init+0x0/0x20 returned 0 after 0 msecs
calling  init_vdso_vars+0x0/0x250
initcall init_vdso_vars+0x0/0x250 returned 0 after 0 msecs
calling  ia32_binfmt_init+0x0/0x20
initcall ia32_binfmt_init+0x0/0x20 returned 0 after 0 msecs
calling  sysenter_setup+0x0/0x3b0
initcall sysenter_setup+0x0/0x3b0 returned 0 after 0 msecs
calling  init_aout_binfmt+0x0/0x20
initcall init_aout_binfmt+0x0/0x20 returned 0 after 0 msecs
calling  init_sched_debug_procfs+0x0/0x30
initcall init_sched_debug_procfs+0x0/0x30 returned 0 after 0 msecs
calling  create_proc_profile+0x0/0x60
initcall create_proc_profile+0x0/0x60 returned 0 after 0 msecs
calling  ioresources_init+0x0/0x50
initcall ioresources_init+0x0/0x50 returned 0 after 0 msecs
calling  uid_cache_init+0x0/0x90
initcall uid_cache_init+0x0/0x90 returned 0 after 0 msecs
calling  init_posix_timers+0x0/0xd0
initcall init_posix_timers+0x0/0xd0 returned 0 after 0 msecs
calling  init_posix_cpu_timers+0x0/0xe0
initcall init_posix_cpu_timers+0x0/0xe0 returned 0 after 0 msecs
calling  nsproxy_cache_init+0x0/0x40
initcall nsproxy_cache_init+0x0/0x40 returned 0 after 0 msecs
calling  timekeeping_init_device+0x0/0x30
Registering sysdev class 'timekeeping'
Registering sys device of class 'timekeeping'
Registering sys device 'timekeeping0'
initcall timekeeping_init_device+0x0/0x30 returned 0 after 10 msecs
calling  init_clocksource_sysfs+0x0/0x60
Registering sysdev class 'clocksource'
Registering sys device of class 'clocksource'
Registering sys device 'clocksource0'
initcall init_clocksource_sysfs+0x0/0x60 returned 0 after 10 msecs
calling  init_timer_list_procfs+0x0/0x40
initcall init_timer_list_procfs+0x0/0x40 returned 0 after 0 msecs
calling  lockdep_proc_init+0x0/0x60
initcall lockdep_proc_init+0x0/0x60 returned 0 after 0 msecs
calling  futex_init+0x0/0x110
initcall futex_init+0x0/0x110 returned 0 after 0 msecs
calling  proc_dma_init+0x0/0x30
initcall proc_dma_init+0x0/0x30 returned 0 after 0 msecs
calling  kallsyms_init+0x0/0x30
initcall kallsyms_init+0x0/0x30 returned 0 after 0 msecs
calling  crash_save_vmcoreinfo_init+0x0/0x470
initcall crash_save_vmcoreinfo_init+0x0/0x470 returned 0 after 0 msecs
calling  crash_notes_memory_init+0x0/0x40
initcall crash_notes_memory_init+0x0/0x40 returned 0 after 0 msecs
calling  backtrace_regression_test+0x0/0x100
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Not tainted 2.6.26-tip-06509-gb4ebc67-dirty #13600

Call Trace:
 [<ffffffff802719fd>] backtrace_regression_test+0x3d/0x100
 [<ffffffff8025d3bf>] ? getnstimeofday+0x3f/0xc0
 [<ffffffff8025a8bf>] ? ktime_get_ts+0x4f/0x60
 [<ffffffff8025aa56>] ? ktime_get+0x16/0x50
 [<ffffffff80209045>] do_one_initcall+0x45/0x190
 [<ffffffff802535ee>] ? start_workqueue_thread+0x2e/0x40
 [<ffffffff8025374f>] ? __create_workqueue_key+0x14f/0x170
 [<ffffffff80b02140>] ? early_idt_handler+0x0/0x73
 [<ffffffff80b02aaf>] kernel_init+0xff/0x1c0
 [<ffffffff8020d7d9>] child_rip+0xa/0x11
 [<ffffffff8020d12e>] ? restore_args+0x0/0x30
 [<ffffffff80b029b0>] ? kernel_init+0x0/0x1c0
 [<ffffffff8020d7cf>] ? child_rip+0x0/0x11

Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.26-tip-06509-gb4ebc67-dirty #13600

Call Trace:
 <IRQ>  [<ffffffff802719ae>] backtrace_test_irq_callback+0xe/0x20
 [<ffffffff80246783>] tasklet_action+0x63/0xc0
 [<ffffffff80246b44>] __do_softirq+0x74/0xe0
 [<ffffffff802468a0>] ? ksoftirqd+0x0/0xe0
 [<ffffffff8020dcbc>] call_softirq+0x1c/0x30
 <EOI>  [<ffffffff8020ffbc>] do_softirq+0x8c/0xd0
 [<ffffffff802468fc>] ksoftirqd+0x5c/0xe0
 [<ffffffff80257073>] kthread+0x53/0x80
 [<ffffffff8020d7d9>] child_rip+0xa/0x11
 [<ffffffff8020d12e>] ? restore_args+0x0/0x30
 [<ffffffff80257020>] ? kthread+0x0/0x80
 [<ffffffff8020d7cf>] ? child_rip+0x0/0x11

Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<ffffffff80218f4f>] save_stack_trace+0x2f/0x50
 [<ffffffff80271a9a>] backtrace_regression_test+0xda/0x100
 [<ffffffff80209045>] do_one_initcall+0x45/0x190
 [<ffffffff80b02aaf>] kernel_init+0xff/0x1c0
 [<ffffffff8020d7d9>] child_rip+0xa/0x11
 [<ffffffffffffffff>] 0xffffffffffffffff
====[ end of backtrace testing ]====
initcall backtrace_regression_test+0x0/0x100 returned 0 after 172 msecs
calling  rcu_torture_init+0x0/0x6c0
rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
initcall rcu_torture_init+0x0/0x6c0 returned 0 after 12 msecs
calling  utsname_sysctl_init+0x0/0x20
initcall utsname_sysctl_init+0x0/0x20 returned 0 after 0 msecs
calling  init_lstats_procfs+0x0/0x30
initcall init_lstats_procfs+0x0/0x30 returned 0 after 0 msecs
calling  init_sched_switch_trace+0x0/0x50
Testing tracer sched_switch: PASSED
initcall init_sched_switch_trace+0x0/0x50 returned 0 after 107 msecs
calling  init_stack_trace+0x0/0x20
Testing tracer sysprof: PASSED
initcall init_stack_trace+0x0/0x20 returned 0 after 98 msecs
calling  init_function_trace+0x0/0x20
Testing tracer ftrace: PASSED
Testing dynamic ftrace: PASSED
initcall init_function_trace+0x0/0x20 returned 0 after 314 msecs
calling  init_irqsoff_tracer+0x0/0x20
Testing tracer irqsoff: PASSED
initcall init_irqsoff_tracer+0x0/0x20 returned 0 after 3 msecs
calling  init_mmio_trace+0x0/0x20
initcall init_mmio_trace+0x0/0x20 returned 0 after 0 msecs
calling  init_per_zone_pages_min+0x0/0x60
initcall init_per_zone_pages_min+0x0/0x60 returned 0 after 0 msecs
calling  pdflush_init+0x0/0x20
initcall pdflush_init+0x0/0x20 returned 0 after 0 msecs
calling  kswapd_init+0x0/0x20
initcall kswapd_init+0x0/0x20 returned 0 after 0 msecs
calling  init_tmpfs+0x0/0xf0
initcall init_tmpfs+0x0/0xf0 returned 0 after 0 msecs
calling  slab_sysfs_init+0x0/0x100
initcall slab_sysfs_init+0x0/0x100 returned 0 after 3 msecs
calling  fasync_init+0x0/0x30
initcall fasync_init+0x0/0x30 returned 0 after 0 msecs
calling  aio_setup+0x0/0x80
initcall aio_setup+0x0/0x80 returned 0 after 0 msecs
calling  init_sys32_ioctl+0x0/0x90
initcall init_sys32_ioctl+0x0/0x90 returned 0 after 0 msecs
calling  init_mbcache+0x0/0x20
initcall init_mbcache+0x0/0x20 returned 0 after 0 msecs
calling  vmcore_init+0x0/0xa20
initcall vmcore_init+0x0/0xa20 returned 0 after 0 msecs
calling  init_devpts_fs+0x0/0x50
initcall init_devpts_fs+0x0/0x50 returned 0 after 0 msecs
calling  init_reiserfs_fs+0x0/0x90
initcall init_reiserfs_fs+0x0/0x90 returned 0 after 0 msecs
calling  init_ext3_fs+0x0/0x80
initcall init_ext3_fs+0x0/0x80 returned 0 after 0 msecs
calling  init_ext4_fs+0x0/0x80
initcall init_ext4_fs+0x0/0x80 returned 0 after 0 msecs
calling  journal_init+0x0/0xf0
initcall journal_init+0x0/0xf0 returned 0 after 0 msecs
calling  journal_init+0x0/0x120
initcall journal_init+0x0/0x120 returned 0 after 0 msecs
calling  init_ext2_fs+0x0/0x70
initcall init_ext2_fs+0x0/0x70 returned 0 after 0 msecs
calling  init_ramfs_fs+0x0/0x20
initcall init_ramfs_fs+0x0/0x20 returned 0 after 0 msecs
calling  init_coda+0x0/0x1a0
device class 'coda': registering
device: 'cfs0': device_add
PM: Adding info for No Bus:cfs0
device: 'cfs1': device_add
PM: Adding info for No Bus:cfs1
device: 'cfs2': device_add
PM: Adding info for No Bus:cfs2
device: 'cfs3': device_add
PM: Adding info for No Bus:cfs3
device: 'cfs4': device_add
PM: Adding info for No Bus:cfs4
initcall init_coda+0x0/0x1a0 returned 0 after 29 msecs
calling  init_fat_fs+0x0/0x60
initcall init_fat_fs+0x0/0x60 returned 0 after 0 msecs
calling  init_msdos_fs+0x0/0x20
initcall init_msdos_fs+0x0/0x20 returned 0 after 0 msecs
calling  init_bfs_fs+0x0/0x70
initcall init_bfs_fs+0x0/0x70 returned 0 after 0 msecs
calling  init_nls_cp860+0x0/0x20
initcall init_nls_cp860+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp861+0x0/0x20
initcall init_nls_cp861+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp862+0x0/0x20
initcall init_nls_cp862+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp864+0x0/0x20
initcall init_nls_cp864+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp865+0x0/0x20
initcall init_nls_cp865+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp866+0x0/0x20
initcall init_nls_cp866+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_cp1251+0x0/0x20
initcall init_nls_cp1251+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_iso8859_1+0x0/0x20
initcall init_nls_iso8859_1+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_iso8859_3+0x0/0x20
initcall init_nls_iso8859_3+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_iso8859_5+0x0/0x20
initcall init_nls_iso8859_5+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_iso8859_7+0x0/0x20
initcall init_nls_iso8859_7+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_iso8859_9+0x0/0x20
initcall init_nls_iso8859_9+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_koi8_u+0x0/0x20
initcall init_nls_koi8_u+0x0/0x20 returned 0 after 0 msecs
calling  init_nls_koi8_ru+0x0/0x50
initcall init_nls_koi8_ru+0x0/0x50 returned 0 after 0 msecs
calling  init_cifs+0x0/0x570
initcall init_cifs+0x0/0x570 returned 0 after 0 msecs
calling  init_ufs_fs+0x0/0x70
initcall init_ufs_fs+0x0/0x70 returned 0 after 0 msecs
calling  init_efs_fs+0x0/0x80
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x80 returned 0 after 3 msecs
calling  init_affs_fs+0x0/0x70
initcall init_affs_fs+0x0/0x70 returned 0 after 0 msecs
calling  init_romfs_fs+0x0/0x70
initcall init_romfs_fs+0x0/0x70 returned 0 after 0 msecs
calling  init_autofs_fs+0x0/0x20
initcall init_autofs_fs+0x0/0x20 returned 0 after 0 msecs
calling  init_autofs4_fs+0x0/0x20
initcall init_autofs4_fs+0x0/0x20 returned -16 after 0 msecs
initcall init_autofs4_fs+0x0/0x20 returned with error code -16 
calling  init_jfs_fs+0x0/0x270
JFS: nTxBlock = 7740, nTxLock = 61922
initcall init_jfs_fs+0x0/0x270 returned 0 after 8 msecs
calling  init_befs_fs+0x0/0xa0
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0xa0 returned 0 after 1 msecs
calling  ipc_init+0x0/0x30
msgmni has been set to 1935
initcall ipc_init+0x0/0x30 returned 0 after 2 msecs
calling  ipc_sysctl_init+0x0/0x20
initcall ipc_sysctl_init+0x0/0x20 returned 0 after 0 msecs
calling  init_mqueue_fs+0x0/0xf0
initcall init_mqueue_fs+0x0/0xf0 returned 0 after 0 msecs
calling  key_proc_init+0x0/0x40
initcall key_proc_init+0x0/0x40 returned 0 after 0 msecs
calling  crypto_algapi_init+0x0/0x20
initcall crypto_algapi_init+0x0/0x20 returned 0 after 0 msecs
calling  blkcipher_module_init+0x0/0x40
initcall blkcipher_module_init+0x0/0x40 returned 0 after 0 msecs
calling  seqiv_module_init+0x0/0x20
initcall seqiv_module_init+0x0/0x20 returned 0 after 0 msecs
calling  cryptomgr_init+0x0/0x20
initcall cryptomgr_init+0x0/0x20 returned 0 after 0 msecs
calling  crypto_xcbc_module_init+0x0/0x20
initcall crypto_xcbc_module_init+0x0/0x20 returned 0 after 0 msecs
calling  crypto_null_mod_init+0x0/0x90
initcall crypto_null_mod_init+0x0/0x90 returned 0 after 0 msecs
calling  md5_mod_init+0x0/0x20
initcall md5_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  sha1_generic_mod_init+0x0/0x20
initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  sha512_generic_mod_init+0x0/0x60
initcall sha512_generic_mod_init+0x0/0x60 returned 0 after 0 msecs
calling  crypto_ecb_module_init+0x0/0x20
initcall crypto_ecb_module_init+0x0/0x20 returned 0 after 0 msecs
calling  crypto_cts_module_init+0x0/0x20
initcall crypto_cts_module_init+0x0/0x20 returned 0 after 0 msecs
calling  crypto_module_init+0x0/0x20
initcall crypto_module_init+0x0/0x20 returned 0 after 0 msecs
calling  crypto_ctr_module_init+0x0/0x60
initcall crypto_ctr_module_init+0x0/0x60 returned 0 after 0 msecs
calling  crypto_ccm_module_init+0x0/0x80
initcall crypto_ccm_module_init+0x0/0x80 returned 0 after 0 msecs
calling  cryptd_init+0x0/0xc0
initcall cryptd_init+0x0/0xc0 returned 0 after 0 msecs
calling  des_generic_mod_init+0x0/0x60
initcall des_generic_mod_init+0x0/0x60 returned 0 after 0 msecs
calling  fcrypt_mod_init+0x0/0x20
initcall fcrypt_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  serpent_mod_init+0x0/0x60
initcall serpent_mod_init+0x0/0x60 returned 0 after 0 msecs
calling  arc4_init+0x0/0x20
initcall arc4_init+0x0/0x20 returned 0 after 0 msecs
calling  anubis_mod_init+0x0/0x20
initcall anubis_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  seed_init+0x0/0x20
initcall seed_init+0x0/0x20 returned 0 after 0 msecs
calling  deflate_mod_init+0x0/0x20
initcall deflate_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  michael_mic_init+0x0/0x20
initcall michael_mic_init+0x0/0x20 returned 0 after 0 msecs
calling  crc32c_mod_init+0x0/0x60
initcall crc32c_mod_init+0x0/0x60 returned 0 after 0 msecs
calling  crypto_authenc_module_init+0x0/0x20
initcall crypto_authenc_module_init+0x0/0x20 returned 0 after 0 msecs
calling  lzo_mod_init+0x0/0x20
initcall lzo_mod_init+0x0/0x20 returned 0 after 0 msecs
calling  noop_init+0x0/0x20
io scheduler noop registered
initcall noop_init+0x0/0x20 returned 0 after 2 msecs
calling  cfq_init+0x0/0xb0
io scheduler cfq registered (default)
initcall cfq_init+0x0/0xb0 returned 0 after 3 msecs
calling  pci_proc_init+0x0/0x80
initcall pci_proc_init+0x0/0x80 returned 0 after 0 msecs
calling  pci_hotplug_init+0x0/0x30
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x30 returned 0 after 4 msecs
calling  cr_backlight_init+0x0/0x90
bus: 'platform': add driver cr_backlight
Registering platform device 'cr_backlight'. Parent at platform
device: 'cr_backlight': device_add
bus: 'platform': add device cr_backlight
PM: Adding info for platform:cr_backlight
bus: 'platform': driver_probe_device: matched device cr_backlight with driver cr_backlight
bus: 'platform': really_probe: probing driver cr_backlight with device cr_backlight
INTEL CARILLO RANCH LPC not found.
Carillo Ranch Backlight Driver Initialized.
initcall cr_backlight_init+0x0/0x90 returned 0 after 40 msecs
calling  arcfb_init+0x0/0x80
initcall arcfb_init+0x0/0x80 returned -6 after 0 msecs
initcall arcfb_init+0x0/0x80 returned with error code -6 
calling  atyfb_init+0x0/0x210
bus: 'pci': add driver atyfb
bus: 'pci': driver_probe_device: matched device 0000:01:00.0 with driver atyfb
bus: 'pci': really_probe: probing driver atyfb with device 0000:01:00.0
bus: 'pci': driver_probe_device: matched device 0000:01:00.1 with driver atyfb
bus: 'pci': really_probe: probing driver atyfb with device 0000:01:00.1
initcall atyfb_init+0x0/0x210 returned 0 after 28 msecs
calling  gxfb_init+0x0/0x90
bus: 'pci': add driver gxfb
initcall gxfb_init+0x0/0x90 returned 0 after 2 msecs
calling  lxfb_init+0x0/0x120
bus: 'pci': add driver lxfb
initcall lxfb_init+0x0/0x120 returned 0 after 2 msecs
calling  imsttfb_init+0x0/0x120
bus: 'pci': add driver imsttfb
initcall imsttfb_init+0x0/0x120 returned 0 after 2 msecs
calling  vt8623fb_init+0x0/0x60
bus: 'pci': add driver vt8623fb
initcall vt8623fb_init+0x0/0x60 returned 0 after 2 msecs
calling  vmlfb_init+0x0/0xa0
vmlfb: initializing
bus: 'pci': add driver vmlfb
initcall vmlfb_init+0x0/0xa0 returned 0 after 4 msecs
calling  arkfb_init+0x0/0x60
bus: 'pci': add driver arkfb
initcall arkfb_init+0x0/0x60 returned 0 after 2 msecs
calling  hecubafb_init+0x0/0x20
bus: 'platform': add driver hecubafb
initcall hecubafb_init+0x0/0x20 returned 0 after 3 msecs
calling  s1d13xxxfb_init+0x0/0x40
bus: 'platform': add driver s1d13806fb
initcall s1d13xxxfb_init+0x0/0x40 returned 0 after 3 msecs
calling  imacfb_init+0x0/0x210
initcall imacfb_init+0x0/0x210 returned -19 after 0 msecs
calling  efifb_init+0x0/0x60
initcall efifb_init+0x0/0x60 returned -19 after 0 msecs
calling  acpi_reserve_resources+0x0/0xf0
initcall acpi_reserve_resources+0x0/0xf0 returned 0 after 0 msecs
calling  irqrouter_init_sysfs+0x0/0x3d
Registering sysdev class 'irqrouter'
Registering sys device of class 'irqrouter'
Registering sys device 'irqrouter0'
initcall irqrouter_init_sysfs+0x0/0x3d returned 0 after 10 msecs
calling  acpi_pci_slot_init+0x0/0x25
initcall acpi_pci_slot_init+0x0/0x25 returned 0 after 0 msecs
calling  rand_initialize+0x0/0x40
initcall rand_initialize+0x0/0x40 returned 0 after 0 msecs
calling  tty_init+0x0/0x200
device: 'tty': device_add
PM: Adding info for No Bus:tty
device: 'console': device_add
PM: Adding info for No Bus:console
device: 'ptmx': device_add
PM: Adding info for No Bus:ptmx
device: 'tty0': device_add
PM: Adding info for No Bus:tty0
device class 'vc': registering
device: 'vcs': device_add
PM: Adding info for No Bus:vcs
device: 'vcsa': device_add
PM: Adding info for No Bus:vcsa
device: 'tty1': device_add
PM: Adding info for No Bus:tty1
device: 'tty2': device_add
PM: Adding info for No Bus:tty2
device: 'tty3': device_add
PM: Adding info for No Bus:tty3
device: 'tty4': device_add
PM: Adding info for No Bus:tty4
device: 'tty5': device_add
PM: Adding info for No Bus:tty5
device: 'tty6': device_add
PM: Adding info for No Bus:tty6
device: 'tty7': device_add
PM: Adding info for No Bus:tty7
device: 'tty8': device_add
PM: Adding info for No Bus:tty8
device: 'tty9': device_add
PM: Adding info for No Bus:tty9
device: 'tty10': device_add
PM: Adding info for No Bus:tty10
device: 'tty11': device_add
PM: Adding info for No Bus:tty11
device: 'tty12': device_add
PM: Adding info for No Bus:tty12
device: 'tty13': device_add
PM: Adding info for No Bus:tty13
device: 'tty14': device_add
PM: Adding info for No Bus:tty14
device: 'tty15': device_add
PM: Adding info for No Bus:tty15
device: 'tty16': device_add
PM: Adding info for No Bus:tty16
device: 'tty17': device_add
PM: Adding info for No Bus:tty17
device: 'tty18': device_add
PM: Adding info for No Bus:tty18
device: 'tty19': device_add
PM: Adding info for No Bus:tty19
device: 'tty20': device_add
PM: Adding info for No Bus:tty20
device: 'tty21': device_add
PM: Adding info for No Bus:tty21
device: 'tty22': device_add
PM: Adding info for No Bus:tty22
device: 'tty23': device_add
PM: Adding info for No Bus:tty23
device: 'tty24': device_add
PM: Adding info for No Bus:tty24
device: 'tty25': device_add
PM: Adding info for No Bus:tty25
device: 'tty26': device_add
PM: Adding info for No Bus:tty26
device: 'tty27': device_add
PM: Adding info for No Bus:tty27
device: 'tty28': device_add
PM: Adding info for No Bus:tty28
device: 'tty29': device_add
PM: Adding info for No Bus:tty29
device: 'tty30': device_add
PM: Adding info for No Bus:tty30
device: 'tty31': device_add
PM: Adding info for No Bus:tty31
device: 'tty32': device_add
PM: Adding info for No Bus:tty32
device: 'tty33': device_add
PM: Adding info for No Bus:tty33
device: 'tty34': device_add
PM: Adding info for No Bus:tty34
device: 'tty35': device_add
PM: Adding info for No Bus:tty35
device: 'tty36': device_add
PM: Adding info for No Bus:tty36
device: 'tty37': device_add
PM: Adding info for No Bus:tty37
device: 'tty38': device_add
PM: Adding info for No Bus:tty38
device: 'tty39': device_add
PM: Adding info for No Bus:tty39
device: 'tty40': device_add
PM: Adding info for No Bus:tty40
device: 'tty41': device_add
PM: Adding info for No Bus:tty41
device: 'tty42': device_add
PM: Adding info for No Bus:tty42
device: 'tty43': device_add
PM: Adding info for No Bus:tty43
device: 'tty44': device_add
PM: Adding info for No Bus:tty44
device: 'tty45': device_add
PM: Adding info for No Bus:tty45
device: 'tty46': device_add
PM: Adding info for No Bus:tty46
device: 'tty47': device_add
PM: Adding info for No Bus:tty47
device: 'tty48': device_add
PM: Adding info for No Bus:tty48
device: 'tty49': device_add
PM: Adding info for No Bus:tty49
device: 'tty50': device_add
PM: Adding info for No Bus:tty50
device: 'tty51': device_add
PM: Adding info for No Bus:tty51
device: 'tty52': device_add
PM: Adding info for No Bus:tty52
device: 'tty53': device_add
PM: Adding info for No Bus:tty53
device: 'tty54': device_add
PM: Adding info for No Bus:tty54
device: 'tty55': device_add
PM: Adding info for No Bus:tty55
device: 'tty56': device_add
PM: Adding info for No Bus:tty56
device: 'tty57': device_add
PM: Adding info for No Bus:tty57
device: 'tty58': device_add
PM: Adding info for No Bus:tty58
device: 'tty59': device_add
PM: Adding info for No Bus:tty59
device: 'tty60': device_add
PM: Adding info for No Bus:tty60
device: 'tty61': device_add
PM: Adding info for No Bus:tty61
device: 'tty62': device_add
PM: Adding info for No Bus:tty62
device: 'tty63': device_add
PM: Adding info for No Bus:tty63
initcall tty_init+0x0/0x200 returned 0 after 371 msecs
calling  pty_init+0x0/0x550
device: 'ptyp0': device_add
PM: Adding info for No Bus:ptyp0
device: 'ptyp1': device_add
PM: Adding info for No Bus:ptyp1
device: 'ptyp2': device_add
PM: Adding info for No Bus:ptyp2
device: 'ptyp3': device_add
PM: Adding info for No Bus:ptyp3
device: 'ptyp4': device_add
PM: Adding info for No Bus:ptyp4
device: 'ptyp5': device_add
PM: Adding info for No Bus:ptyp5
device: 'ptyp6': device_add
PM: Adding info for No Bus:ptyp6
device: 'ptyp7': device_add
PM: Adding info for No Bus:ptyp7
device: 'ptyp8': device_add
PM: Adding info for No Bus:ptyp8
device: 'ptyp9': device_add
PM: Adding info for No Bus:ptyp9
device: 'ptypa': device_add
PM: Adding info for No Bus:ptypa
device: 'ptypb': device_add
PM: Adding info for No Bus:ptypb
device: 'ptypc': device_add
PM: Adding info for No Bus:ptypc
device: 'ptypd': device_add
PM: Adding info for No Bus:ptypd
device: 'ptype': device_add
PM: Adding info for No Bus:ptype
device: 'ptypf': device_add
PM: Adding info for No Bus:ptypf
device: 'ptyq0': device_add
PM: Adding info for No Bus:ptyq0
device: 'ptyq1': device_add
PM: Adding info for No Bus:ptyq1
device: 'ptyq2': device_add
PM: Adding info for No Bus:ptyq2
device: 'ptyq3': device_add
PM: Adding info for No Bus:ptyq3
device: 'ptyq4': device_add
PM: Adding info for No Bus:ptyq4
device: 'ptyq5': device_add
PM: Adding info for No Bus:ptyq5
device: 'ptyq6': device_add
PM: Adding info for No Bus:ptyq6
device: 'ptyq7': device_add
PM: Adding info for No Bus:ptyq7
device: 'ptyq8': device_add
PM: Adding info for No Bus:ptyq8
device: 'ptyq9': device_add
PM: Adding info for No Bus:ptyq9
device: 'ptyqa': device_add
PM: Adding info for No Bus:ptyqa
device: 'ptyqb': device_add
PM: Adding info for No Bus:ptyqb
device: 'ptyqc': device_add
PM: Adding info for No Bus:ptyqc
device: 'ptyqd': device_add
PM: Adding info for No Bus:ptyqd
device: 'ptyqe': device_add
PM: Adding info for No Bus:ptyqe
device: 'ptyqf': device_add
PM: Adding info for No Bus:ptyqf
device: 'ptyr0': device_add
PM: Adding info for No Bus:ptyr0
device: 'ptyr1': device_add
PM: Adding info for No Bus:ptyr1
device: 'ptyr2': device_add
PM: Adding info for No Bus:ptyr2
device: 'ptyr3': device_add
PM: Adding info for No Bus:ptyr3
device: 'ptyr4': device_add
PM: Adding info for No Bus:ptyr4
device: 'ptyr5': device_add
PM: Adding info for No Bus:ptyr5
device: 'ptyr6': device_add
PM: Adding info for No Bus:ptyr6
device: 'ptyr7': device_add
PM: Adding info for No Bus:ptyr7
device: 'ptyr8': device_add
PM: Adding info for No Bus:ptyr8
device: 'ptyr9': device_add
PM: Adding info for No Bus:ptyr9
device: 'ptyra': device_add
PM: Adding info for No Bus:ptyra
device: 'ptyrb': device_add
PM: Adding info for No Bus:ptyrb
device: 'ptyrc': device_add
PM: Adding info for No Bus:ptyrc
device: 'ptyrd': device_add
PM: Adding info for No Bus:ptyrd
device: 'ptyre': device_add
PM: Adding info for No Bus:ptyre
device: 'ptyrf': device_add
PM: Adding info for No Bus:ptyrf
device: 'ptys0': device_add
PM: Adding info for No Bus:ptys0
device: 'ptys1': device_add
PM: Adding info for No Bus:ptys1
device: 'ptys2': device_add
PM: Adding info for No Bus:ptys2
device: 'ptys3': device_add
PM: Adding info for No Bus:ptys3
device: 'ptys4': device_add
PM: Adding info for No Bus:ptys4
device: 'ptys5': device_add
PM: Adding info for No Bus:ptys5
device: 'ptys6': device_add
PM: Adding info for No Bus:ptys6
device: 'ptys7': device_add
PM: Adding info for No Bus:ptys7
device: 'ptys8': device_add
PM: Adding info for No Bus:ptys8
device: 'ptys9': device_add
PM: Adding info for No Bus:ptys9
device: 'ptysa': device_add
PM: Adding info for No Bus:ptysa
device: 'ptysb': device_add
PM: Adding info for No Bus:ptysb
device: 'ptysc': device_add
PM: Adding info for No Bus:ptysc
device: 'ptysd': device_add
PM: Adding info for No Bus:ptysd
device: 'ptyse': device_add
PM: Adding info for No Bus:ptyse
device: 'ptysf': device_add
PM: Adding info for No Bus:ptysf
device: 'ptyt0': device_add
PM: Adding info for No Bus:ptyt0
device: 'ptyt1': device_add
PM: Adding info for No Bus:ptyt1
device: 'ptyt2': device_add
PM: Adding info for No Bus:ptyt2
device: 'ptyt3': device_add
PM: Adding info for No Bus:ptyt3
device: 'ptyt4': device_add
PM: Adding info for No Bus:ptyt4
device: 'ptyt5': device_add
PM: Adding info for No Bus:ptyt5
device: 'ptyt6': device_add
PM: Adding info for No Bus:ptyt6
device: 'ptyt7': device_add
PM: Adding info for No Bus:ptyt7
device: 'ptyt8': device_add
PM: Adding info for No Bus:ptyt8
device: 'ptyt9': device_add
PM: Adding info for No Bus:ptyt9
device: 'ptyta': device_add
PM: Adding info for No Bus:ptyta
device: 'ptytb': device_add
PM: Adding info for No Bus:ptytb
device: 'ptytc': device_add
PM: Adding info for No Bus:ptytc
device: 'ptytd': device_add
PM: Adding info for No Bus:ptytd
device: 'ptyte': device_add
PM: Adding info for No Bus:ptyte
device: 'ptytf': device_add
PM: Adding info for No Bus:ptytf
device: 'ptyu0': device_add
PM: Adding info for No Bus:ptyu0
device: 'ptyu1': device_add
PM: Adding info for No Bus:ptyu1
device: 'ptyu2': device_add
PM: Adding info for No Bus:ptyu2
device: 'ptyu3': device_add
PM: Adding info for No Bus:ptyu3
device: 'ptyu4': device_add
PM: Adding info for No Bus:ptyu4
device: 'ptyu5': device_add
PM: Adding info for No Bus:ptyu5
device: 'ptyu6': device_add
PM: Adding info for No Bus:ptyu6
device: 'ptyu7': device_add
PM: Adding info for No Bus:ptyu7
device: 'ptyu8': device_add
PM: Adding info for No Bus:ptyu8
device: 'ptyu9': device_add
PM: Adding info for No Bus:ptyu9
device: 'ptyua': device_add
PM: Adding info for No Bus:ptyua
device: 'ptyub': device_add
PM: Adding info for No Bus:ptyub
device: 'ptyuc': device_add
PM: Adding info for No Bus:ptyuc
device: 'ptyud': device_add
PM: Adding info for No Bus:ptyud
device: 'ptyue': device_add
PM: Adding info for No Bus:ptyue
device: 'ptyuf': device_add
PM: Adding info for No Bus:ptyuf
device: 'ptyv0': device_add
PM: Adding info for No Bus:ptyv0
device: 'ptyv1': device_add
PM: Adding info for No Bus:ptyv1
device: 'ptyv2': device_add
PM: Adding info for No Bus:ptyv2
device: 'ptyv3': device_add
PM: Adding info for No Bus:ptyv3
device: 'ptyv4': device_add
PM: Adding info for No Bus:ptyv4
device: 'ptyv5': device_add
PM: Adding info for No Bus:ptyv5
device: 'ptyv6': device_add
PM: Adding info for No Bus:ptyv6
device: 'ptyv7': device_add
PM: Adding info for No Bus:ptyv7
device: 'ptyv8': device_add
PM: Adding info for No Bus:ptyv8
device: 'ptyv9': device_add
PM: Adding info for No Bus:ptyv9
device: 'ptyva': device_add
PM: Adding info for No Bus:ptyva
device: 'ptyvb': device_add
PM: Adding info for No Bus:ptyvb
device: 'ptyvc': device_add
PM: Adding info for No Bus:ptyvc
device: 'ptyvd': device_add
PM: Adding info for No Bus:ptyvd
device: 'ptyve': device_add
PM: Adding info for No Bus:ptyve
device: 'ptyvf': device_add
PM: Adding info for No Bus:ptyvf
device: 'ptyw0': device_add
PM: Adding info for No Bus:ptyw0
device: 'ptyw1': device_add
PM: Adding info for No Bus:ptyw1
device: 'ptyw2': device_add
PM: Adding info for No Bus:ptyw2
device: 'ptyw3': device_add
PM: Adding info for No Bus:ptyw3
device: 'ptyw4': device_add
PM: Adding info for No Bus:ptyw4
device: 'ptyw5': device_add
PM: Adding info for No Bus:ptyw5
device: 'ptyw6': device_add
PM: Adding info for No Bus:ptyw6
device: 'ptyw7': device_add
PM: Adding info for No Bus:ptyw7
device: 'ptyw8': device_add
PM: Adding info for No Bus:ptyw8
device: 'ptyw9': device_add
PM: Adding info for No Bus:ptyw9
device: 'ptywa': device_add
PM: Adding info for No Bus:ptywa
device: 'ptywb': device_add
PM: Adding info for No Bus:ptywb
device: 'ptywc': device_add
PM: Adding info for No Bus:ptywc
device: 'ptywd': device_add
PM: Adding info for No Bus:ptywd
device: 'ptywe': device_add
PM: Adding info for No Bus:ptywe
device: 'ptywf': device_add
PM: Adding info for No Bus:ptywf
device: 'ptyx0': device_add
PM: Adding info for No Bus:ptyx0
device: 'ptyx1': device_add
PM: Adding info for No Bus:ptyx1
device: 'ptyx2': device_add
PM: Adding info for No Bus:ptyx2
device: 'ptyx3': device_add
PM: Adding info for No Bus:ptyx3
device: 'ptyx4': device_add
PM: Adding info for No Bus:ptyx4
device: 'ptyx5': device_add
PM: Adding info for No Bus:ptyx5
device: 'ptyx6': device_add
PM: Adding info for No Bus:ptyx6
device: 'ptyx7': device_add
PM: Adding info for No Bus:ptyx7
device: 'ptyx8': device_add
PM: Adding info for No Bus:ptyx8
device: 'ptyx9': device_add
PM: Adding info for No Bus:ptyx9
device: 'ptyxa': device_add
PM: Adding info for No Bus:ptyxa
device: 'ptyxb': device_add
PM: Adding info for No Bus:ptyxb
device: 'ptyxc': device_add
PM: Adding info for No Bus:ptyxc
device: 'ptyxd': device_add
PM: Adding info for No Bus:ptyxd
device: 'ptyxe': device_add
PM: Adding info for No Bus:ptyxe
device: 'ptyxf': device_add
PM: Adding info for No Bus:ptyxf
device: 'ptyy0': device_add
PM: Adding info for No Bus:ptyy0
device: 'ptyy1': device_add
PM: Adding info for No Bus:ptyy1
device: 'ptyy2': device_add
PM: Adding info for No Bus:ptyy2
device: 'ptyy3': device_add
PM: Adding info for No Bus:ptyy3
device: 'ptyy4': device_add
PM: Adding info for No Bus:ptyy4
device: 'ptyy5': device_add
PM: Adding info for No Bus:ptyy5
device: 'ptyy6': device_add
PM: Adding info for No Bus:ptyy6
device: 'ptyy7': device_add
PM: Adding info for No Bus:ptyy7
device: 'ptyy8': device_add
PM: Adding info for No Bus:ptyy8
device: 'ptyy9': device_add
PM: Adding info for No Bus:ptyy9
device: 'ptyya': device_add
PM: Adding info for No Bus:ptyya
device: 'ptyyb': device_add
PM: Adding info for No Bus:ptyyb
device: 'ptyyc': device_add
PM: Adding info for No Bus:ptyyc
device: 'ptyyd': device_add
PM: Adding info for No Bus:ptyyd
device: 'ptyye': device_add
PM: Adding info for No Bus:ptyye
device: 'ptyyf': device_add
PM: Adding info for No Bus:ptyyf
device: 'ptyz0': device_add
PM: Adding info for No Bus:ptyz0
device: 'ptyz1': device_add
PM: Adding info for No Bus:ptyz1
device: 'ptyz2': device_add
PM: Adding info for No Bus:ptyz2
device: 'ptyz3': device_add
PM: Adding info for No Bus:ptyz3
device: 'ptyz4': device_add
PM: Adding info for No Bus:ptyz4
device: 'ptyz5': device_add
PM: Adding info for No Bus:ptyz5
device: 'ptyz6': device_add
PM: Adding info for No Bus:ptyz6
device: 'ptyz7': device_add
PM: Adding info for No Bus:ptyz7
device: 'ptyz8': device_add
PM: Adding info for No Bus:ptyz8
device: 'ptyz9': device_add
PM: Adding info for No Bus:ptyz9
device: 'ptyza': device_add
PM: Adding info for No Bus:ptyza
device: 'ptyzb': device_add
PM: Adding info for No Bus:ptyzb
device: 'ptyzc': device_add
PM: Adding info for No Bus:ptyzc
device: 'ptyzd': device_add
PM: Adding info for No Bus:ptyzd
device: 'ptyze': device_add
PM: Adding info for No Bus:ptyze
device: 'ptyzf': device_add
PM: Adding info for No Bus:ptyzf
device: 'ptya0': device_add
PM: Adding info for No Bus:ptya0
device: 'ptya1': device_add
PM: Adding info for No Bus:ptya1
device: 'ptya2': device_add
PM: Adding info for No Bus:ptya2
device: 'ptya3': device_add
PM: Adding info for No Bus:ptya3
device: 'ptya4': device_add
PM: Adding info for No Bus:ptya4
device: 'ptya5': device_add
PM: Adding info for No Bus:ptya5
device: 'ptya6': device_add
PM: Adding info for No Bus:ptya6
device: 'ptya7': device_add
PM: Adding info for No Bus:ptya7
device: 'ptya8': device_add
PM: Adding info for No Bus:ptya8
device: 'ptya9': device_add
PM: Adding info for No Bus:ptya9
device: 'ptyaa': device_add
PM: Adding info for No Bus:ptyaa
device: 'ptyab': device_add
PM: Adding info for No Bus:ptyab
device: 'ptyac': device_add
PM: Adding info for No Bus:ptyac
device: 'ptyad': device_add
PM: Adding info for No Bus:ptyad
device: 'ptyae': device_add
PM: Adding info for No Bus:ptyae
device: 'ptyaf': device_add
PM: Adding info for No Bus:ptyaf
device: 'ptyb0': device_add
PM: Adding info for No Bus:ptyb0
device: 'ptyb1': device_add
PM: Adding info for No Bus:ptyb1
device: 'ptyb2': device_add
PM: Adding info for No Bus:ptyb2
device: 'ptyb3': device_add
PM: Adding info for No Bus:ptyb3
device: 'ptyb4': device_add
PM: Adding info for No Bus:ptyb4
device: 'ptyb5': device_add
PM: Adding info for No Bus:ptyb5
device: 'ptyb6': device_add
PM: Adding info for No Bus:ptyb6
device: 'ptyb7': device_add
PM: Adding info for No Bus:ptyb7
device: 'ptyb8': device_add
PM: Adding info for No Bus:ptyb8
device: 'ptyb9': device_add
PM: Adding info for No Bus:ptyb9
device: 'ptyba': device_add
PM: Adding info for No Bus:ptyba
device: 'ptybb': device_add
PM: Adding info for No Bus:ptybb
device: 'ptybc': device_add
PM: Adding info for No Bus:ptybc
device: 'ptybd': device_add
PM: Adding info for No Bus:ptybd
device: 'ptybe': device_add
PM: Adding info for No Bus:ptybe
device: 'ptybf': device_add
PM: Adding info for No Bus:ptybf
device: 'ptyc0': device_add
PM: Adding info for No Bus:ptyc0
device: 'ptyc1': device_add
PM: Adding info for No Bus:ptyc1
device: 'ptyc2': device_add
PM: Adding info for No Bus:ptyc2
device: 'ptyc3': device_add
PM: Adding info for No Bus:ptyc3
device: 'ptyc4': device_add
PM: Adding info for No Bus:ptyc4
device: 'ptyc5': device_add
PM: Adding info for No Bus:ptyc5
device: 'ptyc6': device_add
PM: Adding info for No Bus:ptyc6
device: 'ptyc7': device_add
PM: Adding info for No Bus:ptyc7
device: 'ptyc8': device_add
PM: Adding info for No Bus:ptyc8
device: 'ptyc9': device_add
PM: Adding info for No Bus:ptyc9
device: 'ptyca': device_add
PM: Adding info for No Bus:ptyca
device: 'ptycb': device_add
PM: Adding info for No Bus:ptycb
device: 'ptycc': device_add
PM: Adding info for No Bus:ptycc
device: 'ptycd': device_add
PM: Adding info for No Bus:ptycd
device: 'ptyce': device_add
PM: Adding info for No Bus:ptyce
device: 'ptycf': device_add
PM: Adding info for No Bus:ptycf
device: 'ptyd0': device_add
PM: Adding info for No Bus:ptyd0
device: 'ptyd1': device_add
PM: Adding info for No Bus:ptyd1
device: 'ptyd2': device_add
PM: Adding info for No Bus:ptyd2
device: 'ptyd3': device_add
PM: Adding info for No Bus:ptyd3
device: 'ptyd4': device_add
PM: Adding info for No Bus:ptyd4
device: 'ptyd5': device_add
PM: Adding info for No Bus:ptyd5
device: 'ptyd6': device_add
PM: Adding info for No Bus:ptyd6
device: 'ptyd7': device_add
PM: Adding info for No Bus:ptyd7
device: 'ptyd8': device_add
PM: Adding info for No Bus:ptyd8
device: 'ptyd9': device_add
PM: Adding info for No Bus:ptyd9
device: 'ptyda': device_add
PM: Adding info for No Bus:ptyda
device: 'ptydb': device_add
PM: Adding info for No Bus:ptydb
device: 'ptydc': device_add
PM: Adding info for No Bus:ptydc
device: 'ptydd': device_add
PM: Adding info for No Bus:ptydd
device: 'ptyde': device_add
PM: Adding info for No Bus:ptyde
device: 'ptydf': device_add
PM: Adding info for No Bus:ptydf
device: 'ptye0': device_add
PM: Adding info for No Bus:ptye0
device: 'ptye1': device_add
PM: Adding info for No Bus:ptye1
device: 'ptye2': device_add
PM: Adding info for No Bus:ptye2
device: 'ptye3': device_add
PM: Adding info for No Bus:ptye3
device: 'ptye4': device_add
PM: Adding info for No Bus:ptye4
device: 'ptye5': device_add
PM: Adding info for No Bus:ptye5
device: 'ptye6': device_add
PM: Adding info for No Bus:ptye6
device: 'ptye7': device_add
PM: Adding info for No Bus:ptye7
device: 'ptye8': device_add
PM: Adding info for No Bus:ptye8
device: 'ptye9': device_add
PM: Adding info for No Bus:ptye9
device: 'ptyea': device_add
PM: Adding info for No Bus:ptyea
device: 'ptyeb': device_add
PM: Adding info for No Bus:ptyeb
device: 'ptyec': device_add
PM: Adding info for No Bus:ptyec
device: 'ptyed': device_add
PM: Adding info for No Bus:ptyed
device: 'ptyee': device_add
PM: Adding info for No Bus:ptyee
device: 'ptyef': device_add
PM: Adding info for No Bus:ptyef
device: 'ttyp0': device_add
PM: Adding info for No Bus:ttyp0
device: 'ttyp1': device_add
PM: Adding info for No Bus:ttyp1
device: 'ttyp2': device_add
PM: Adding info for No Bus:ttyp2
device: 'ttyp3': device_add
PM: Adding info for No Bus:ttyp3
device: 'ttyp4': device_add
PM: Adding info for No Bus:ttyp4
device: 'ttyp5': device_add
PM: Adding info for No Bus:ttyp5
device: 'ttyp6': device_add
PM: Adding info for No Bus:ttyp6
device: 'ttyp7': device_add
PM: Adding info for No Bus:ttyp7
device: 'ttyp8': device_add
PM: Adding info for No Bus:ttyp8
device: 'ttyp9': device_add
PM: Adding info for No Bus:ttyp9
device: 'ttypa': device_add
PM: Adding info for No Bus:ttypa
device: 'ttypb': device_add
PM: Adding info for No Bus:ttypb
device: 'ttypc': device_add
PM: Adding info for No Bus:ttypc
device: 'ttypd': device_add
PM: Adding info for No Bus:ttypd
device: 'ttype': device_add
PM: Adding info for No Bus:ttype
device: 'ttypf': device_add
PM: Adding info for No Bus:ttypf
device: 'ttyq0': device_add
PM: Adding info for No Bus:ttyq0
device: 'ttyq1': device_add
PM: Adding info for No Bus:ttyq1
device: 'ttyq2': device_add
PM: Adding info for No Bus:ttyq2
device: 'ttyq3': device_add
PM: Adding info for No Bus:ttyq3
device: 'ttyq4': device_add
PM: Adding info for No Bus:ttyq4
device: 'ttyq5': device_add
PM: Adding info for No Bus:ttyq5
device: 'ttyq6': device_add
PM: Adding info for No Bus:ttyq6
device: 'ttyq7': device_add
PM: Adding info for No Bus:ttyq7
device: 'ttyq8': device_add
PM: Adding info for No Bus:ttyq8
device: 'ttyq9': device_add
PM: Adding info for No Bus:ttyq9
device: 'ttyqa': device_add
PM: Adding info for No Bus:ttyqa
device: 'ttyqb': device_add
PM: Adding info for No Bus:ttyqb
device: 'ttyqc': device_add
PM: Adding info for No Bus:ttyqc
device: 'ttyqd': device_add
PM: Adding info for No Bus:ttyqd
device: 'ttyqe': device_add
PM: Adding info for No Bus:ttyqe
device: 'ttyqf': device_add
PM: Adding info for No Bus:ttyqf
device: 'ttyr0': device_add
PM: Adding info for No Bus:ttyr0
device: 'ttyr1': device_add
PM: Adding info for No Bus:ttyr1
device: 'ttyr2': device_add
PM: Adding info for No Bus:ttyr2
device: 'ttyr3': device_add
PM: Adding info for No Bus:ttyr3
device: 'ttyr4': device_add
PM: Adding info for No Bus:ttyr4
device: 'ttyr5': device_add
PM: Adding info for No Bus:ttyr5
device: 'ttyr6': device_add
PM: Adding info for No Bus:ttyr6
device: 'ttyr7': device_add
PM: Adding info for No Bus:ttyr7
device: 'ttyr8': device_add
PM: Adding info for No Bus:ttyr8
device: 'ttyr9': device_add
PM: Adding info for No Bus:ttyr9
device: 'ttyra': device_add
PM: Adding info for No Bus:ttyra
device: 'ttyrb': device_add
PM: Adding info for No Bus:ttyrb
device: 'ttyrc': device_add
PM: Adding info for No Bus:ttyrc
device: 'ttyrd': device_add
PM: Adding info for No Bus:ttyrd
device: 'ttyre': device_add
PM: Adding info for No Bus:ttyre
device: 'ttyrf': device_add
PM: Adding info for No Bus:ttyrf
device: 'ttys0': device_add
PM: Adding info for No Bus:ttys0
device: 'ttys1': device_add
PM: Adding info for No Bus:ttys1
device: 'ttys2': device_add
PM: Adding info for No Bus:ttys2
device: 'ttys3': device_add
PM: Adding info for No Bus:ttys3
device: 'ttys4': device_add
PM: Adding info for No Bus:ttys4
device: 'ttys5': device_add
PM: Adding info for No Bus:ttys5
device: 'ttys6': device_add
PM: Adding info for No Bus:ttys6
device: 'ttys7': device_add
PM: Adding info for No Bus:ttys7
device: 'ttys8': device_add
PM: Adding info for No Bus:ttys8
device: 'ttys9': device_add
PM: Adding info for No Bus:ttys9
device: 'ttysa': device_add
PM: Adding info for No Bus:ttysa
device: 'ttysb': device_add
PM: Adding info for No Bus:ttysb
device: 'ttysc': device_add
PM: Adding info for No Bus:ttysc
device: 'ttysd': device_add
PM: Adding info for No Bus:ttysd
device: 'ttyse': device_add
PM: Adding info for No Bus:ttyse
device: 'ttysf': device_add
PM: Adding info for No Bus:ttysf
device: 'ttyt0': device_add
PM: Adding info for No Bus:ttyt0
device: 'ttyt1': device_add
PM: Adding info for No Bus:ttyt1
device: 'ttyt2': device_add
PM: Adding info for No Bus:ttyt2
device: 'ttyt3': device_add
PM: Adding info for No Bus:ttyt3
device: 'ttyt4': device_add
PM: Adding info for No Bus:ttyt4
device: 'ttyt5': device_add
PM: Adding info for No Bus:ttyt5
device: 'ttyt6': device_add
PM: Adding info for No Bus:ttyt6
device: 'ttyt7': device_add
PM: Adding info for No Bus:ttyt7
device: 'ttyt8': device_add
PM: Adding info for No Bus:ttyt8
device: 'ttyt9': device_add
PM: Adding info for No Bus:ttyt9
device: 'ttyta': device_add
PM: Adding info for No Bus:ttyta
device: 'ttytb': device_add
PM: Adding info for No Bus:ttytb
device: 'ttytc': device_add
PM: Adding info for No Bus:ttytc
device: 'ttytd': device_add
PM: Adding info for No Bus:ttytd
device: 'ttyte': device_add
PM: Adding info for No Bus:ttyte
device: 'ttytf': device_add
PM: Adding info for No Bus:ttytf
device: 'ttyu0': device_add
PM: Adding info for No Bus:ttyu0
device: 'ttyu1': device_add
PM: Adding info for No Bus:ttyu1
device: 'ttyu2': device_add
PM: Adding info for No Bus:ttyu2
device: 'ttyu3': device_add
PM: Adding info for No Bus:ttyu3
device: 'ttyu4': device_add
PM: Adding info for No Bus:ttyu4
device: 'ttyu5': device_add
PM: Adding info for No Bus:ttyu5
device: 'ttyu6': device_add
PM: Adding info for No Bus:ttyu6
device: 'ttyu7': device_add
PM: Adding info for No Bus:ttyu7
device: 'ttyu8': device_add
PM: Adding info for No Bus:ttyu8
device: 'ttyu9': device_add
PM: Adding info for No Bus:ttyu9
device: 'ttyua': device_add
PM: Adding info for No Bus:ttyua
device: 'ttyub': device_add
PM: Adding info for No Bus:ttyub
device: 'ttyuc': device_add
PM: Adding info for No Bus:ttyuc
device: 'ttyud': device_add
PM: Adding info for No Bus:ttyud
device: 'ttyue': device_add
PM: Adding info for No Bus:ttyue
device: 'ttyuf': device_add
PM: Adding info for No Bus:ttyuf
device: 'ttyv0': device_add
PM: Adding info for No Bus:ttyv0
device: 'ttyv1': device_add
PM: Adding info for No Bus:ttyv1
device: 'ttyv2': device_add
PM: Adding info for No Bus:ttyv2
device: 'ttyv3': device_add
PM: Adding info for No Bus:ttyv3
device: 'ttyv4': device_add
PM: Adding info for No Bus:ttyv4
device: 'ttyv5': device_add
PM: Adding info for No Bus:ttyv5
device: 'ttyv6': device_add
PM: Adding info for No Bus:ttyv6
device: 'ttyv7': device_add
PM: Adding info for No Bus:ttyv7
device: 'ttyv8': device_add
PM: Adding info for No Bus:ttyv8
device: 'ttyv9': device_add
PM: Adding info for No Bus:ttyv9
device: 'ttyva': device_add
PM: Adding info for No Bus:ttyva
device: 'ttyvb': device_add
PM: Adding info for No Bus:ttyvb
device: 'ttyvc': device_add
PM: Adding info for No Bus:ttyvc
device: 'ttyvd': device_add
PM: Adding info for No Bus:ttyvd
device: 'ttyve': device_add
PM: Adding info for No Bus:ttyve
device: 'ttyvf': device_add
PM: Adding info for No Bus:ttyvf
device: 'ttyw0': device_add
PM: Adding info for No Bus:ttyw0
device: 'ttyw1': device_add
PM: Adding info for No Bus:ttyw1
device: 'ttyw2': device_add
PM: Adding info for No Bus:ttyw2
device: 'ttyw3': device_add
PM: Adding info for No Bus:ttyw3
device: 'ttyw4': device_add
PM: Adding info for No Bus:ttyw4
device: 'ttyw5': device_add
PM: Adding info for No Bus:ttyw5
device: 'ttyw6': device_add
PM: Adding info for No Bus:ttyw6
device: 'ttyw7': device_add
PM: Adding info for No Bus:ttyw7
device: 'ttyw8': device_add
PM: Adding info for No Bus:ttyw8
device: 'ttyw9': device_add
PM: Adding info for No Bus:ttyw9
device: 'ttywa': device_add
PM: Adding info for No Bus:ttywa
device: 'ttywb': device_add
PM: Adding info for No Bus:ttywb
device: 'ttywc': device_add
PM: Adding info for No Bus:ttywc
device: 'ttywd': device_add
PM: Adding info for No Bus:ttywd
device: 'ttywe': device_add
PM: Adding info for No Bus:ttywe
device: 'ttywf': device_add
PM: Adding info for No Bus:ttywf
device: 'ttyx0': device_add
PM: Adding info for No Bus:ttyx0
device: 'ttyx1': device_add
PM: Adding info for No Bus:ttyx1
device: 'ttyx2': device_add
PM: Adding info for No Bus:ttyx2
device: 'ttyx3': device_add
PM: Adding info for No Bus:ttyx3
device: 'ttyx4': device_add
PM: Adding info for No Bus:ttyx4
device: 'ttyx5': device_add
PM: Adding info for No Bus:ttyx5
device: 'ttyx6': device_add
PM: Adding info for No Bus:ttyx6
device: 'ttyx7': device_add
PM: Adding info for No Bus:ttyx7
device: 'ttyx8': device_add
PM: Adding info for No Bus:ttyx8
device: 'ttyx9': device_add
PM: Adding info for No Bus:ttyx9
device: 'ttyxa': device_add
PM: Adding info for No Bus:ttyxa
device: 'ttyxb': device_add
PM: Adding info for No Bus:ttyxb
device: 'ttyxc': device_add
PM: Adding info for No Bus:ttyxc
device: 'ttyxd': device_add
PM: Adding info for No Bus:ttyxd
device: 'ttyxe': device_add
PM: Adding info for No Bus:ttyxe
device: 'ttyxf': device_add
PM: Adding info for No Bus:ttyxf
device: 'ttyy0': device_add
PM: Adding info for No Bus:ttyy0
device: 'ttyy1': device_add
PM: Adding info for No Bus:ttyy1
device: 'ttyy2': device_add
PM: Adding info for No Bus:ttyy2
device: 'ttyy3': device_add
PM: Adding info for No Bus:ttyy3
device: 'ttyy4': device_add
PM: Adding info for No Bus:ttyy4
device: 'ttyy5': device_add
PM: Adding info for No Bus:ttyy5
device: 'ttyy6': device_add
PM: Adding info for No Bus:ttyy6
device: 'ttyy7': device_add
PM: Adding info for No Bus:ttyy7
device: 'ttyy8': device_add
PM: Adding info for No Bus:ttyy8
device: 'ttyy9': device_add
PM: Adding info for No Bus:ttyy9
device: 'ttyya': device_add
PM: Adding info for No Bus:ttyya
device: 'ttyyb': device_add
PM: Adding info for No Bus:ttyyb
device: 'ttyyc': device_add
PM: Adding info for No Bus:ttyyc
device: 'ttyyd': device_add
PM: Adding info for No Bus:ttyyd
device: 'ttyye': device_add
PM: Adding info for No Bus:ttyye
device: 'ttyyf': device_add
PM: Adding info for No Bus:ttyyf
device: 'ttyz0': device_add
PM: Adding info for No Bus:ttyz0
device: 'ttyz1': device_add
PM: Adding info for No Bus:ttyz1
device: 'ttyz2': device_add
PM: Adding info for No Bus:ttyz2
device: 'ttyz3': device_add
PM: Adding info for No Bus:ttyz3
device: 'ttyz4': device_add
PM: Adding info for No Bus:ttyz4
device: 'ttyz5': device_add
PM: Adding info for No Bus:ttyz5
device: 'ttyz6': device_add
PM: Adding info for No Bus:ttyz6
device: 'ttyz7': device_add
PM: Adding info for No Bus:ttyz7
device: 'ttyz8': device_add
PM: Adding info for No Bus:ttyz8
device: 'ttyz9': device_add
PM: Adding info for No Bus:ttyz9
device: 'ttyza': device_add
PM: Adding info for No Bus:ttyza
device: 'ttyzb': device_add
PM: Adding info for No Bus:ttyzb
device: 'ttyzc': device_add
PM: Adding info for No Bus:ttyzc
device: 'ttyzd': device_add
PM: Adding info for No Bus:ttyzd
device: 'ttyze': device_add
PM: Adding info for No Bus:ttyze
device: 'ttyzf': device_add
PM: Adding info for No Bus:ttyzf
device: 'ttya0': device_add
PM: Adding info for No Bus:ttya0
device: 'ttya1': device_add
PM: Adding info for No Bus:ttya1
device: 'ttya2': device_add
PM: Adding info for No Bus:ttya2
device: 'ttya3': device_add
PM: Adding info for No Bus:ttya3
device: 'ttya4': device_add
PM: Adding info for No Bus:ttya4
device: 'ttya5': device_add
PM: Adding info for No Bus:ttya5
device: 'ttya6': device_add
PM: Adding info for No Bus:ttya6
device: 'ttya7': device_add
PM: Adding info for No Bus:ttya7
device: 'ttya8': device_add
PM: Adding info for No Bus:ttya8
device: 'ttya9': device_add
PM: Adding info for No Bus:ttya9
device: 'ttyaa': device_add
PM: Adding info for No Bus:ttyaa
device: 'ttyab': device_add
PM: Adding info for No Bus:ttyab
device: 'ttyac': device_add
PM: Adding info for No Bus:ttyac
device: 'ttyad': device_add
PM: Adding info for No Bus:ttyad
device: 'ttyae': device_add
PM: Adding info for No Bus:ttyae
device: 'ttyaf': device_add
PM: Adding info for No Bus:ttyaf
device: 'ttyb0': device_add
PM: Adding info for No Bus:ttyb0
device: 'ttyb1': device_add
PM: Adding info for No Bus:ttyb1
device: 'ttyb2': device_add
PM: Adding info for No Bus:ttyb2
device: 'ttyb3': device_add
PM: Adding info for No Bus:ttyb3
device: 'ttyb4': device_add
PM: Adding info for No Bus:ttyb4
device: 'ttyb5': device_add
PM: Adding info for No Bus:ttyb5
device: 'ttyb6': device_add
PM: Adding info for No Bus:ttyb6
device: 'ttyb7': device_add
PM: Adding info for No Bus:ttyb7
device: 'ttyb8': device_add
PM: Adding info for No Bus:ttyb8
device: 'ttyb9': device_add
PM: Adding info for No Bus:ttyb9
device: 'ttyba': device_add
PM: Adding info for No Bus:ttyba
device: 'ttybb': device_add
PM: Adding info for No Bus:ttybb
device: 'ttybc': device_add
PM: Adding info for No Bus:ttybc
device: 'ttybd': device_add
PM: Adding info for No Bus:ttybd
device: 'ttybe': device_add
PM: Adding info for No Bus:ttybe
device: 'ttybf': device_add
PM: Adding info for No Bus:ttybf
device: 'ttyc0': device_add
PM: Adding info for No Bus:ttyc0
device: 'ttyc1': device_add
PM: Adding info for No Bus:ttyc1
device: 'ttyc2': device_add
PM: Adding info for No Bus:ttyc2
device: 'ttyc3': device_add
PM: Adding info for No Bus:ttyc3
device: 'ttyc4': device_add
PM: Adding info for No Bus:ttyc4
device: 'ttyc5': device_add
PM: Adding info for No Bus:ttyc5
device: 'ttyc6': device_add
PM: Adding info for No Bus:ttyc6
device: 'ttyc7': device_add
PM: Adding info for No Bus:ttyc7
device: 'ttyc8': device_add
PM: Adding info for No Bus:ttyc8
device: 'ttyc9': device_add
PM: Adding info for No Bus:ttyc9
device: 'ttyca': device_add
PM: Adding info for No Bus:ttyca
device: 'ttycb': device_add
PM: Adding info for No Bus:ttycb
device: 'ttycc': device_add
PM: Adding info for No Bus:ttycc
device: 'ttycd': device_add
PM: Adding info for No Bus:ttycd
device: 'ttyce': device_add
PM: Adding info for No Bus:ttyce
device: 'ttycf': device_add
PM: Adding info for No Bus:ttycf
device: 'ttyd0': device_add
PM: Adding info for No Bus:ttyd0
device: 'ttyd1': device_add
PM: Adding info for No Bus:ttyd1
device: 'ttyd2': device_add
PM: Adding info for No Bus:ttyd2
device: 'ttyd3': device_add
PM: Adding info for No Bus:ttyd3
device: 'ttyd4': device_add
PM: Adding info for No Bus:ttyd4
device: 'ttyd5': device_add
PM: Adding info for No Bus:ttyd5
device: 'ttyd6': device_add
PM: Adding info for No Bus:ttyd6
device: 'ttyd7': device_add
PM: Adding info for No Bus:ttyd7
device: 'ttyd8': device_add
PM: Adding info for No Bus:ttyd8
device: 'ttyd9': device_add
PM: Adding info for No Bus:ttyd9
device: 'ttyda': device_add
PM: Adding info for No Bus:ttyda
device: 'ttydb': device_add
PM: Adding info for No Bus:ttydb
device: 'ttydc': device_add
PM: Adding info for No Bus:ttydc
device: 'ttydd': device_add
PM: Adding info for No Bus:ttydd
device: 'ttyde': device_add
PM: Adding info for No Bus:ttyde
device: 'ttydf': device_add
PM: Adding info for No Bus:ttydf
device: 'ttye0': device_add
PM: Adding info for No Bus:ttye0
device: 'ttye1': device_add
PM: Adding info for No Bus:ttye1
device: 'ttye2': device_add
PM: Adding info for No Bus:ttye2
device: 'ttye3': device_add
PM: Adding info for No Bus:ttye3
device: 'ttye4': device_add
PM: Adding info for No Bus:ttye4
device: 'ttye5': device_add
PM: Adding info for No Bus:ttye5
device: 'ttye6': device_add
PM: Adding info for No Bus:ttye6
device: 'ttye7': device_add
PM: Adding info for No Bus:ttye7
device: 'ttye8': device_add
PM: Adding info for No Bus:ttye8
device: 'ttye9': device_add
PM: Adding info for No Bus:ttye9
device: 'ttyea': device_add
PM: Adding info for No Bus:ttyea
device: 'ttyeb': device_add
PM: Adding info for No Bus:ttyeb
device: 'ttyec': device_add
PM: Adding info for No Bus:ttyec
device: 'ttyed': device_add
PM: Adding info for No Bus:ttyed
device: 'ttyee': device_add
PM: Adding info for No Bus:ttyee
device: 'ttyef': device_add
PM: Adding info for No Bus:ttyef
initcall pty_init+0x0/0x550 returned 0 after 2758 msecs
calling  epca_module_init+0x0/0x590
DIGI epca driver version 1.3.0.1-LK2.6 loaded.
bus: 'pci': add driver epca
device: 'ttyD0': device_add
PM: Adding info for No Bus:ttyD0
device: 'ttyD1': device_add
PM: Adding info for No Bus:ttyD1
device: 'ttyD2': device_add
PM: Adding info for No Bus:ttyD2
device: 'ttyD3': device_add
PM: Adding info for No Bus:ttyD3
device: 'ttyD4': device_add
PM: Adding info for No Bus:ttyD4
device: 'ttyD5': device_add
PM: Adding info for No Bus:ttyD5
device: 'ttyD6': device_add
PM: Adding info for No Bus:ttyD6
device: 'ttyD7': device_add
PM: Adding info for No Bus:ttyD7
device: 'ttyD8': device_add
PM: Adding info for No Bus:ttyD8
device: 'ttyD9': device_add
PM: Adding info for No Bus:ttyD9
device: 'ttyD10': device_add
PM: Adding info for No Bus:ttyD10
device: 'ttyD11': device_add
PM: Adding info for No Bus:ttyD11
device: 'ttyD12': device_add
PM: Adding info for No Bus:ttyD12
device: 'ttyD13': device_add
PM: Adding info for No Bus:ttyD13
device: 'ttyD14': device_add
PM: Adding info for No Bus:ttyD14
device: 'ttyD15': device_add
PM: Adding info for No Bus:ttyD15
device: 'ttyD16': device_add
PM: Adding info for No Bus:ttyD16
device: 'ttyD17': device_add
PM: Adding info for No Bus:ttyD17
device: 'ttyD18': device_add
PM: Adding info for No Bus:ttyD18
device: 'ttyD19': device_add
PM: Adding info for No Bus:ttyD19
device: 'ttyD20': device_add
PM: Adding info for No Bus:ttyD20
device: 'ttyD21': device_add
PM: Adding info for No Bus:ttyD21
device: 'ttyD22': device_add
PM: Adding info for No Bus:ttyD22
device: 'ttyD23': device_add
PM: Adding info for No Bus:ttyD23
device: 'ttyD24': device_add
PM: Adding info for No Bus:ttyD24
device: 'ttyD25': device_add
PM: Adding info for No Bus:ttyD25
device: 'ttyD26': device_add
PM: Adding info for No Bus:ttyD26
device: 'ttyD27': device_add
PM: Adding info for No Bus:ttyD27
device: 'ttyD28': device_add
PM: Adding info for No Bus:ttyD28
device: 'ttyD29': device_add
PM: Adding info for No Bus:ttyD29
device: 'ttyD30': device_add
PM: Adding info for No Bus:ttyD30
device: 'ttyD31': device_add
PM: Adding info for No Bus:ttyD31
device: 'ttyD32': device_add
PM: Adding info for No Bus:ttyD32
device: 'ttyD33': device_add
PM: Adding info for No Bus:ttyD33
device: 'ttyD34': device_add
PM: Adding info for No Bus:ttyD34
device: 'ttyD35': device_add
PM: Adding info for No Bus:ttyD35
device: 'ttyD36': device_add
PM: Adding info for No Bus:ttyD36
device: 'ttyD37': device_add
PM: Adding info for No Bus:ttyD37
device: 'ttyD38': device_add
PM: Adding info for No Bus:ttyD38
device: 'ttyD39': device_add
PM: Adding info for No Bus:ttyD39
device: 'ttyD40': device_add
PM: Adding info for No Bus:ttyD40
device: 'ttyD41': device_add
PM: Adding info for No Bus:ttyD41
device: 'ttyD42': device_add
PM: Adding info for No Bus:ttyD42
device: 'ttyD43': device_add
PM: Adding info for No Bus:ttyD43
device: 'ttyD44': device_add
PM: Adding info for No Bus:ttyD44
device: 'ttyD45': device_add
PM: Adding info for No Bus:ttyD45
device: 'ttyD46': device_add
PM: Adding info for No Bus:ttyD46
device: 'ttyD47': device_add
PM: Adding info for No Bus:ttyD47
device: 'ttyD48': device_add
PM: Adding info for No Bus:ttyD48
device: 'ttyD49': device_add
PM: Adding info for No Bus:ttyD49
device: 'ttyD50': device_add
PM: Adding info for No Bus:ttyD50
device: 'ttyD51': device_add
PM: Adding info for No Bus:ttyD51
device: 'ttyD52': device_add
PM: Adding info for No Bus:ttyD52
device: 'ttyD53': device_add
PM: Adding info for No Bus:ttyD53
device: 'ttyD54': device_add
PM: Adding info for No Bus:ttyD54
device: 'ttyD55': device_add
PM: Adding info for No Bus:ttyD55
device: 'ttyD56': device_add
PM: Adding info for No Bus:ttyD56
device: 'ttyD57': device_add
PM: Adding info for No Bus:ttyD57
device: 'ttyD58': device_add
PM: Adding info for No Bus:ttyD58
device: 'ttyD59': device_add
PM: Adding info for No Bus:ttyD59
device: 'ttyD60': device_add
PM: Adding info for No Bus:ttyD60
device: 'ttyD61': device_add
PM: Adding info for No Bus:ttyD61
device: 'ttyD62': device_add
PM: Adding info for No Bus:ttyD62
device: 'ttyD63': device_add
PM: Adding info for No Bus:ttyD63
device: 'ttyD64': device_add
PM: Adding info for No Bus:ttyD64
device: 'ttyD65': device_add
PM: Adding info for No Bus:ttyD65
device: 'ttyD66': device_add
PM: Adding info for No Bus:ttyD66
device: 'ttyD67': device_add
PM: Adding info for No Bus:ttyD67
device: 'ttyD68': device_add
PM: Adding info for No Bus:ttyD68
device: 'ttyD69': device_add
PM: Adding info for No Bus:ttyD69
device: 'ttyD70': device_add
PM: Adding info for No Bus:ttyD70
device: 'ttyD71': device_add
PM: Adding info for No Bus:ttyD71
device: 'ttyD72': device_add
PM: Adding info for No Bus:ttyD72
device: 'ttyD73': device_add
PM: Adding info for No Bus:ttyD73
device: 'ttyD74': device_add
PM: Adding info for No Bus:ttyD74
device: 'ttyD75': device_add
PM: Adding info for No Bus:ttyD75
device: 'ttyD76': device_add
PM: Adding info for No Bus:ttyD76
device: 'ttyD77': device_add
PM: Adding info for No Bus:ttyD77
device: 'ttyD78': device_add
PM: Adding info for No Bus:ttyD78
device: 'ttyD79': device_add
PM: Adding info for No Bus:ttyD79
device: 'ttyD80': device_add
PM: Adding info for No Bus:ttyD80
device: 'ttyD81': device_add
PM: Adding info for No Bus:ttyD81
device: 'ttyD82': device_add
PM: Adding info for No Bus:ttyD82
device: 'ttyD83': device_add
PM: Adding info for No Bus:ttyD83
device: 'ttyD84': device_add
PM: Adding info for No Bus:ttyD84
device: 'ttyD85': device_add
PM: Adding info for No Bus:ttyD85
device: 'ttyD86': device_add
PM: Adding info for No Bus:ttyD86
device: 'ttyD87': device_add
PM: Adding info for No Bus:ttyD87
device: 'ttyD88': device_add
PM: Adding info for No Bus:ttyD88
device: 'ttyD89': device_add
PM: Adding info for No Bus:ttyD89
device: 'ttyD90': device_add
PM: Adding info for No Bus:ttyD90
device: 'ttyD91': device_add
PM: Adding info for No Bus:ttyD91
device: 'ttyD92': device_add
PM: Adding info for No Bus:ttyD92
device: 'ttyD93': device_add
PM: Adding info for No Bus:ttyD93
device: 'ttyD94': device_add
PM: Adding info for No Bus:ttyD94
device: 'ttyD95': device_add
PM: Adding info for No Bus:ttyD95
device: 'ttyD96': device_add
PM: Adding info for No Bus:ttyD96
device: 'ttyD97': device_add
PM: Adding info for No Bus:ttyD97
device: 'ttyD98': device_add
PM: Adding info for No Bus:ttyD98
device: 'ttyD99': device_add
PM: Adding info for No Bus:ttyD99
device: 'ttyD100': device_add
PM: Adding info for No Bus:ttyD100
device: 'ttyD101': device_add
PM: Adding info for No Bus:ttyD101
device: 'ttyD102': device_add
PM: Adding info for No Bus:ttyD102
device: 'ttyD103': device_add
PM: Adding info for No Bus:ttyD103
device: 'ttyD104': device_add
PM: Adding info for No Bus:ttyD104
device: 'ttyD105': device_add
PM: Adding info for No Bus:ttyD105
device: 'ttyD106': device_add
PM: Adding info for No Bus:ttyD106
device: 'ttyD107': device_add
PM: Adding info for No Bus:ttyD107
device: 'ttyD108': device_add
PM: Adding info for No Bus:ttyD108
device: 'ttyD109': device_add
PM: Adding info for No Bus:ttyD109
device: 'ttyD110': device_add
PM: Adding info for No Bus:ttyD110
device: 'ttyD111': device_add
PM: Adding info for No Bus:ttyD111
device: 'ttyD112': device_add
PM: Adding info for No Bus:ttyD112
device: 'ttyD113': device_add
PM: Adding info for No Bus:ttyD113
device: 'ttyD114': device_add
PM: Adding info for No Bus:ttyD114
device: 'ttyD115': device_add
PM: Adding info for No Bus:ttyD115
device: 'ttyD116': device_add
PM: Adding info for No Bus:ttyD116
device: 'ttyD117': device_add
PM: Adding info for No Bus:ttyD117
device: 'ttyD118': device_add
PM: Adding info for No Bus:ttyD118
device: 'ttyD119': device_add
PM: Adding info for No Bus:ttyD119
device: 'ttyD120': device_add
PM: Adding info for No Bus:ttyD120
device: 'ttyD121': device_add
PM: Adding info for No Bus:ttyD121
device: 'ttyD122': device_add
PM: Adding info for No Bus:ttyD122
device: 'ttyD123': device_add
PM: Adding info for No Bus:ttyD123
device: 'ttyD124': device_add
PM: Adding info for No Bus:ttyD124
device: 'ttyD125': device_add
PM: Adding info for No Bus:ttyD125
device: 'ttyD126': device_add
PM: Adding info for No Bus:ttyD126
device: 'ttyD127': device_add
PM: Adding info for No Bus:ttyD127
device: 'ttyD128': device_add
PM: Adding info for No Bus:ttyD128
device: 'ttyD129': device_add
PM: Adding info for No Bus:ttyD129
device: 'ttyD130': device_add
PM: Adding info for No Bus:ttyD130
device: 'ttyD131': device_add
PM: Adding info for No Bus:ttyD131
device: 'ttyD132': device_add
PM: Adding info for No Bus:ttyD132
device: 'ttyD133': device_add
PM: Adding info for No Bus:ttyD133
device: 'ttyD134': device_add
PM: Adding info for No Bus:ttyD134
device: 'ttyD135': device_add
PM: Adding info for No Bus:ttyD135
device: 'ttyD136': device_add
PM: Adding info for No Bus:ttyD136
device: 'ttyD137': device_add
PM: Adding info for No Bus:ttyD137
device: 'ttyD138': device_add
PM: Adding info for No Bus:ttyD138
device: 'ttyD139': device_add
PM: Adding info for No Bus:ttyD139
device: 'ttyD140': device_add
PM: Adding info for No Bus:ttyD140
device: 'ttyD141': device_add
PM: Adding info for No Bus:ttyD141
device: 'ttyD142': device_add
PM: Adding info for No Bus:ttyD142
device: 'ttyD143': device_add
PM: Adding info for No Bus:ttyD143
device: 'ttyD144': device_add
PM: Adding info for No Bus:ttyD144
device: 'ttyD145': device_add
PM: Adding info for No Bus:ttyD145
device: 'ttyD146': device_add
PM: Adding info for No Bus:ttyD146
device: 'ttyD147': device_add
PM: Adding info for No Bus:ttyD147
device: 'ttyD148': device_add
PM: Adding info for No Bus:ttyD148
device: 'ttyD149': device_add
PM: Adding info for No Bus:ttyD149
device: 'ttyD150': device_add
PM: Adding info for No Bus:ttyD150
device: 'ttyD151': device_add
PM: Adding info for No Bus:ttyD151
device: 'ttyD152': device_add
PM: Adding info for No Bus:ttyD152
device: 'ttyD153': device_add
PM: Adding info for No Bus:ttyD153
device: 'ttyD154': device_add
PM: Adding info for No Bus:ttyD154
device: 'ttyD155': device_add
PM: Adding info for No Bus:ttyD155
device: 'ttyD156': device_add
PM: Adding info for No Bus:ttyD156
device: 'ttyD157': device_add
PM: Adding info for No Bus:ttyD157
device: 'ttyD158': device_add
PM: Adding info for No Bus:ttyD158
device: 'ttyD159': device_add
PM: Adding info for No Bus:ttyD159
device: 'ttyD160': device_add
PM: Adding info for No Bus:ttyD160
device: 'ttyD161': device_add
PM: Adding info for No Bus:ttyD161
device: 'ttyD162': device_add
PM: Adding info for No Bus:ttyD162
device: 'ttyD163': device_add
PM: Adding info for No Bus:ttyD163
device: 'ttyD164': device_add
PM: Adding info for No Bus:ttyD164
device: 'ttyD165': device_add
PM: Adding info for No Bus:ttyD165
device: 'ttyD166': device_add
PM: Adding info for No Bus:ttyD166
device: 'ttyD167': device_add
PM: Adding info for No Bus:ttyD167
device: 'ttyD168': device_add
PM: Adding info for No Bus:ttyD168
device: 'ttyD169': device_add
PM: Adding info for No Bus:ttyD169
device: 'ttyD170': device_add
PM: Adding info for No Bus:ttyD170
device: 'ttyD171': device_add
PM: Adding info for No Bus:ttyD171
device: 'ttyD172': device_add
PM: Adding info for No Bus:ttyD172
device: 'ttyD173': device_add
PM: Adding info for No Bus:ttyD173
device: 'ttyD174': device_add
PM: Adding info for No Bus:ttyD174
device: 'ttyD175': device_add
PM: Adding info for No Bus:ttyD175
device: 'ttyD176': device_add
PM: Adding info for No Bus:ttyD176
device: 'ttyD177': device_add
PM: Adding info for No Bus:ttyD177
device: 'ttyD178': device_add
PM: Adding info for No Bus:ttyD178
device: 'ttyD179': device_add
PM: Adding info for No Bus:ttyD179
device: 'ttyD180': device_add
PM: Adding info for No Bus:ttyD180
device: 'ttyD181': device_add
PM: Adding info for No Bus:ttyD181
device: 'ttyD182': device_add
PM: Adding info for No Bus:ttyD182
device: 'ttyD183': device_add
PM: Adding info for No Bus:ttyD183
device: 'ttyD184': device_add
PM: Adding info for No Bus:ttyD184
device: 'ttyD185': device_add
PM: Adding info for No Bus:ttyD185
device: 'ttyD186': device_add
PM: Adding info for No Bus:ttyD186
device: 'ttyD187': device_add
PM: Adding info for No Bus:ttyD187
device: 'ttyD188': device_add
PM: Adding info for No Bus:ttyD188
device: 'ttyD189': device_add
PM: Adding info for No Bus:ttyD189
device: 'ttyD190': device_add
PM: Adding info for No Bus:ttyD190
device: 'ttyD191': device_add
PM: Adding info for No Bus:ttyD191
device: 'ttyD192': device_add
PM: Adding info for No Bus:ttyD192
device: 'ttyD193': device_add
PM: Adding info for No Bus:ttyD193
device: 'ttyD194': device_add
PM: Adding info for No Bus:ttyD194
device: 'ttyD195': device_add
PM: Adding info for No Bus:ttyD195
device: 'ttyD196': device_add
PM: Adding info for No Bus:ttyD196
device: 'ttyD197': device_add
PM: Adding info for No Bus:ttyD197
device: 'ttyD198': device_add
PM: Adding info for No Bus:ttyD198
device: 'ttyD199': device_add
PM: Adding info for No Bus:ttyD199
device: 'ttyD200': device_add
PM: Adding info for No Bus:ttyD200
device: 'ttyD201': device_add
PM: Adding info for No Bus:ttyD201
device: 'ttyD202': device_add
PM: Adding info for No Bus:ttyD202
device: 'ttyD203': device_add
PM: Adding info for No Bus:ttyD203
device: 'ttyD204': device_add
PM: Adding info for No Bus:ttyD204
device: 'ttyD205': device_add
PM: Adding info for No Bus:ttyD205
device: 'ttyD206': device_add
PM: Adding info for No Bus:ttyD206
device: 'ttyD207': device_add
PM: Adding info for No Bus:ttyD207
device: 'ttyD208': device_add
PM: Adding info for No Bus:ttyD208
device: 'ttyD209': device_add
PM: Adding info for No Bus:ttyD209
device: 'ttyD210': device_add
PM: Adding info for No Bus:ttyD210
device: 'ttyD211': device_add
PM: Adding info for No Bus:ttyD211
device: 'ttyD212': device_add
PM: Adding info for No Bus:ttyD212
device: 'ttyD213': device_add
PM: Adding info for No Bus:ttyD213
device: 'ttyD214': device_add
PM: Adding info for No Bus:ttyD214
device: 'ttyD215': device_add
PM: Adding info for No Bus:ttyD215
device: 'ttyD216': device_add
PM: Adding info for No Bus:ttyD216
device: 'ttyD217': device_add
PM: Adding info for No Bus:ttyD217
device: 'ttyD218': device_add
PM: Adding info for No Bus:ttyD218
device: 'ttyD219': device_add
PM: Adding info for No Bus:ttyD219
device: 'ttyD220': device_add
PM: Adding info for No Bus:ttyD220
device: 'ttyD221': device_add
PM: Adding info for No Bus:ttyD221
device: 'ttyD222': device_add
PM: Adding info for No Bus:ttyD222
device: 'ttyD223': device_add
PM: Adding info for No Bus:ttyD223
device: 'ttyD224': device_add
PM: Adding info for No Bus:ttyD224
device: 'ttyD225': device_add
PM: Adding info for No Bus:ttyD225
device: 'ttyD226': device_add
PM: Adding info for No Bus:ttyD226
device: 'ttyD227': device_add
PM: Adding info for No Bus:ttyD227
device: 'ttyD228': device_add
PM: Adding info for No Bus:ttyD228
device: 'ttyD229': device_add
PM: Adding info for No Bus:ttyD229
device: 'ttyD230': device_add
PM: Adding info for No Bus:ttyD230
device: 'ttyD231': device_add
PM: Adding info for No Bus:ttyD231
device: 'ttyD232': device_add
PM: Adding info for No Bus:ttyD232
device: 'ttyD233': device_add
PM: Adding info for No Bus:ttyD233
device: 'ttyD234': device_add
PM: Adding info for No Bus:ttyD234
device: 'ttyD235': device_add
PM: Adding info for No Bus:ttyD235
device: 'ttyD236': device_add
PM: Adding info for No Bus:ttyD236
device: 'ttyD237': device_add
PM: Adding info for No Bus:ttyD237
device: 'ttyD238': device_add
PM: Adding info for No Bus:ttyD238
device: 'ttyD239': device_add
PM: Adding info for No Bus:ttyD239
device: 'ttyD240': device_add
PM: Adding info for No Bus:ttyD240
device: 'ttyD241': device_add
PM: Adding info for No Bus:ttyD241
device: 'ttyD242': device_add
PM: Adding info for No Bus:ttyD242
device: 'ttyD243': device_add
PM: Adding info for No Bus:ttyD243
device: 'ttyD244': device_add
PM: Adding info for No Bus:ttyD244
device: 'ttyD245': device_add
PM: Adding info for No Bus:ttyD245
device: 'ttyD246': device_add
PM: Adding info for No Bus:ttyD246
device: 'ttyD247': device_add
PM: Adding info for No Bus:ttyD247
device: 'ttyD248': device_add
PM: Adding info for No Bus:ttyD248
device: 'ttyD249': device_add
PM: Adding info for No Bus:ttyD249
device: 'ttyD250': device_add
PM: Adding info for No Bus:ttyD250
device: 'ttyD251': device_add
PM: Adding info for No Bus:ttyD251
device: 'ttyD252': device_add
PM: Adding info for No Bus:ttyD252
device: 'ttyD253': device_add
PM: Adding info for No Bus:ttyD253
device: 'ttyD254': device_add
PM: Adding info for No Bus:ttyD254
device: 'ttyD255': device_add
PM: Adding info for No Bus:ttyD255
device: 'digi_ctl0': device_add
PM: Adding info for No Bus:digi_ctl0
device: 'digi_ctl1': device_add
PM: Adding info for No Bus:digi_ctl1
device: 'digi_ctl2': device_add
PM: Adding info for No Bus:digi_ctl2
device: 'digi_ctl3': device_add
PM: Adding info for No Bus:digi_ctl3
device: 'digi_ctl4': device_add
PM: Adding info for No Bus:digi_ctl4
device: 'digi_ctl5': device_add
PM: Adding info for No Bus:digi_ctl5
device: 'digi_ctl6': device_add
PM: Adding info for No Bus:digi_ctl6
device: 'digi_ctl7': device_add
PM: Adding info for No Bus:digi_ctl7
device: 'digi_ctl8': device_add
PM: Adding info for No Bus:digi_ctl8
device: 'digi_ctl9': device_add
PM: Adding info for No Bus:digi_ctl9
device: 'digi_ctl10': device_add
PM: Adding info for No Bus:digi_ctl10
device: 'digi_ctl11': device_add
PM: Adding info for No Bus:digi_ctl11
device: 'digi_ctl12': device_add
PM: Adding info for No Bus:digi_ctl12
device: 'digi_ctl13': device_add
PM: Adding info for No Bus:digi_ctl13
device: 'digi_ctl14': device_add
PM: Adding info for No Bus:digi_ctl14
device: 'digi_ctl15': device_add
PM: Adding info for No Bus:digi_ctl15
device: 'digi_ctl16': device_add
PM: Adding info for No Bus:digi_ctl16
device: 'digi_ctl17': device_add
PM: Adding info for No Bus:digi_ctl17
device: 'digi_ctl18': device_add
PM: Adding info for No Bus:digi_ctl18
device: 'digi_ctl19': device_add
PM: Adding info for No Bus:digi_ctl19
device: 'digi_ctl20': device_add
PM: Adding info for No Bus:digi_ctl20
device: 'digi_ctl21': device_add
PM: Adding info for No Bus:digi_ctl21
device: 'digi_ctl22': device_add
PM: Adding info for No Bus:digi_ctl22
device: 'digi_ctl23': device_add
PM: Adding info for No Bus:digi_ctl23
device: 'digi_ctl24': device_add
PM: Adding info for No Bus:digi_ctl24
device: 'digi_ctl25': device_add
PM: Adding info for No Bus:digi_ctl25
device: 'digi_ctl26': device_add
PM: Adding info for No Bus:digi_ctl26
device: 'digi_ctl27': device_add
PM: Adding info for No Bus:digi_ctl27
device: 'digi_ctl28': device_add
PM: Adding info for No Bus:digi_ctl28
device: 'digi_ctl29': device_add
PM: Adding info for No Bus:digi_ctl29
device: 'digi_ctl30': device_add
PM: Adding info for No Bus:digi_ctl30
device: 'digi_ctl31': device_add
PM: Adding info for No Bus:digi_ctl31
device: 'digi_ctl32': device_add
PM: Adding info for No Bus:digi_ctl32
device: 'digi_ctl33': device_add
PM: Adding info for No Bus:digi_ctl33
device: 'digi_ctl34': device_add
PM: Adding info for No Bus:digi_ctl34
device: 'digi_ctl35': device_add
PM: Adding info for No Bus:digi_ctl35
device: 'digi_ctl36': device_add
PM: Adding info for No Bus:digi_ctl36
device: 'digi_ctl37': device_add
PM: Adding info for No Bus:digi_ctl37
device: 'digi_ctl38': device_add
PM: Adding info for No Bus:digi_ctl38
device: 'digi_ctl39': device_add
PM: Adding info for No Bus:digi_ctl39
device: 'digi_ctl40': device_add
PM: Adding info for No Bus:digi_ctl40
device: 'digi_ctl41': device_add
PM: Adding info for No Bus:digi_ctl41
device: 'digi_ctl42': device_add
PM: Adding info for No Bus:digi_ctl42
device: 'digi_ctl43': device_add
PM: Adding info for No Bus:digi_ctl43
device: 'digi_ctl44': device_add
PM: Adding info for No Bus:digi_ctl44
device: 'digi_ctl45': device_add
PM: Adding info for No Bus:digi_ctl45
device: 'digi_ctl46': device_add
PM: Adding info for No Bus:digi_ctl46
device: 'digi_ctl47': device_add
PM: Adding info for No Bus:digi_ctl47
device: 'digi_ctl48': device_add
PM: Adding info for No Bus:digi_ctl48
device: 'digi_ctl49': device_add
PM: Adding info for No Bus:digi_ctl49
device: 'digi_ctl50': device_add
PM: Adding info for No Bus:digi_ctl50
device: 'digi_ctl51': device_add
PM: Adding info for No Bus:digi_ctl51
device: 'digi_ctl52': device_add
PM: Adding info for No Bus:digi_ctl52
device: 'digi_ctl53': device_add
PM: Adding info for No Bus:digi_ctl53
device: 'digi_ctl54': device_add
PM: Adding info for No Bus:digi_ctl54
device: 'digi_ctl55': device_add
PM: Adding info for No Bus:digi_ctl55
device: 'digi_ctl56': device_add
PM: Adding info for No Bus:digi_ctl56
device: 'digi_ctl57': device_add
PM: Adding info for No Bus:digi_ctl57
device: 'digi_ctl58': device_add
PM: Adding info for No Bus:digi_ctl58
device: 'digi_ctl59': device_add
PM: Adding info for No Bus:digi_ctl59
device: 'digi_ctl60': device_add
PM: Adding info for No Bus:digi_ctl60
device: 'digi_ctl61': device_add
PM: Adding info for No Bus:digi_ctl61
device: 'digi_ctl62': device_add
PM: Adding info for No Bus:digi_ctl62
device: 'digi_ctl63': device_add
PM: Adding info for No Bus:digi_ctl63
device: 'digi_ctl64': device_add
PM: Adding info for No Bus:digi_ctl64
device: 'digi_ctl65': device_add
PM: Adding info for No Bus:digi_ctl65
device: 'digi_ctl66': device_add
PM: Adding info for No Bus:digi_ctl66
device: 'digi_ctl67': device_add
PM: Adding info for No Bus:digi_ctl67
device: 'digi_ctl68': device_add
PM: Adding info for No Bus:digi_ctl68
device: 'digi_ctl69': device_add
PM: Adding info for No Bus:digi_ctl69
device: 'digi_ctl70': device_add
PM: Adding info for No Bus:digi_ctl70
device: 'digi_ctl71': device_add
PM: Adding info for No Bus:digi_ctl71
device: 'digi_ctl72': device_add
PM: Adding info for No Bus:digi_ctl72
device: 'digi_ctl73': device_add
PM: Adding info for No Bus:digi_ctl73
device: 'digi_ctl74': device_add
PM: Adding info for No Bus:digi_ctl74
device: 'digi_ctl75': device_add
PM: Adding info for No Bus:digi_ctl75
device: 'digi_ctl76': device_add
PM: Adding info for No Bus:digi_ctl76
device: 'digi_ctl77': device_add
PM: Adding info for No Bus:digi_ctl77
device: 'digi_ctl78': device_add
PM: Adding info for No Bus:digi_ctl78
device: 'digi_ctl79': device_add
PM: Adding info for No Bus:digi_ctl79
device: 'digi_ctl80': device_add
PM: Adding info for No Bus:digi_ctl80
device: 'digi_ctl81': device_add
PM: Adding info for No Bus:digi_ctl81
device: 'digi_ctl82': device_add
PM: Adding info for No Bus:digi_ctl82
device: 'digi_ctl83': device_add
PM: Adding info for No Bus:digi_ctl83
device: 'digi_ctl84': device_add
PM: Adding info for No Bus:digi_ctl84
device: 'digi_ctl85': device_add
PM: Adding info for No Bus:digi_ctl85
device: 'digi_ctl86': device_add
PM: Adding info for No Bus:digi_ctl86
device: 'digi_ctl87': device_add
PM: Adding info for No Bus:digi_ctl87
device: 'digi_ctl88': device_add
PM: Adding info for No Bus:digi_ctl88
device: 'digi_ctl89': device_add
PM: Adding info for No Bus:digi_ctl89
device: 'digi_ctl90': device_add
PM: Adding info for No Bus:digi_ctl90
device: 'digi_ctl91': device_add
PM: Adding info for No Bus:digi_ctl91
device: 'digi_ctl92': device_add
PM: Adding info for No Bus:digi_ctl92
device: 'digi_ctl93': device_add
PM: Adding info for No Bus:digi_ctl93
device: 'digi_ctl94': device_add
PM: Adding info for No Bus:digi_ctl94
device: 'digi_ctl95': device_add
PM: Adding info for No Bus:digi_ctl95
device: 'digi_ctl96': device_add
PM: Adding info for No Bus:digi_ctl96
device: 'digi_ctl97': device_add
PM: Adding info for No Bus:digi_ctl97
device: 'digi_ctl98': device_add
PM: Adding info for No Bus:digi_ctl98
device: 'digi_ctl99': device_add
PM: Adding info for No Bus:digi_ctl99
device: 'digi_ctl100': device_add
PM: Adding info for No Bus:digi_ctl100
device: 'digi_ctl101': device_add
PM: Adding info for No Bus:digi_ctl101
device: 'digi_ctl102': device_add
PM: Adding info for No Bus:digi_ctl102
device: 'digi_ctl103': device_add
PM: Adding info for No Bus:digi_ctl103
device: 'digi_ctl104': device_add
PM: Adding info for No Bus:digi_ctl104
device: 'digi_ctl105': device_add
PM: Adding info for No Bus:digi_ctl105
device: 'digi_ctl106': device_add
PM: Adding info for No Bus:digi_ctl106
device: 'digi_ctl107': device_add
PM: Adding info for No Bus:digi_ctl107
device: 'digi_ctl108': device_add
PM: Adding info for No Bus:digi_ctl108
device: 'digi_ctl109': device_add
PM: Adding info for No Bus:digi_ctl109
device: 'digi_ctl110': device_add
PM: Adding info for No Bus:digi_ctl110
device: 'digi_ctl111': device_add
PM: Adding info for No Bus:digi_ctl111
device: 'digi_ctl112': device_add
PM: Adding info for No Bus:digi_ctl112
device: 'digi_ctl113': device_add
PM: Adding info for No Bus:digi_ctl113
device: 'digi_ctl114': device_add
PM: Adding info for No Bus:digi_ctl114
device: 'digi_ctl115': device_add
PM: Adding info for No Bus:digi_ctl115
device: 'digi_ctl116': device_add
PM: Adding info for No Bus:digi_ctl116
device: 'digi_ctl117': device_add
PM: Adding info for No Bus:digi_ctl117
device: 'digi_ctl118': device_add
PM: Adding info for No Bus:digi_ctl118
device: 'digi_ctl119': device_add
PM: Adding info for No Bus:digi_ctl119
device: 'digi_ctl120': device_add
PM: Adding info for No Bus:digi_ctl120
device: 'digi_ctl121': device_add
PM: Adding info for No Bus:digi_ctl121
device: 'digi_ctl122': device_add
PM: Adding info for No Bus:digi_ctl122
device: 'digi_ctl123': device_add
PM: Adding info for No Bus:digi_ctl123
device: 'digi_ctl124': device_add
PM: Adding info for No Bus:digi_ctl124
device: 'digi_ctl125': device_add
PM: Adding info for No Bus:digi_ctl125
device: 'digi_ctl126': device_add
PM: Adding info for No Bus:digi_ctl126
device: 'digi_ctl127': device_add
PM: Adding info for No Bus:digi_ctl127
device: 'digi_ctl128': device_add
PM: Adding info for No Bus:digi_ctl128
device: 'digi_ctl129': device_add
PM: Adding info for No Bus:digi_ctl129
device: 'digi_ctl130': device_add
PM: Adding info for No Bus:digi_ctl130
device: 'digi_ctl131': device_add
PM: Adding info for No Bus:digi_ctl131
device: 'digi_ctl132': device_add
PM: Adding info for No Bus:digi_ctl132
device: 'digi_ctl133': device_add
PM: Adding info for No Bus:digi_ctl133
device: 'digi_ctl134': device_add
PM: Adding info for No Bus:digi_ctl134
device: 'digi_ctl135': device_add
PM: Adding info for No Bus:digi_ctl135
device: 'digi_ctl136': device_add
PM: Adding info for No Bus:digi_ctl136
device: 'digi_ctl137': device_add
PM: Adding info for No Bus:digi_ctl137
device: 'digi_ctl138': device_add
PM: Adding info for No Bus:digi_ctl138
device: 'digi_ctl139': device_add
PM: Adding info for No Bus:digi_ctl139
device: 'digi_ctl140': device_add
PM: Adding info for No Bus:digi_ctl140
device: 'digi_ctl141': device_add
PM: Adding info for No Bus:digi_ctl141
device: 'digi_ctl142': device_add
PM: Adding info for No Bus:digi_ctl142
device: 'digi_ctl143': device_add
PM: Adding info for No Bus:digi_ctl143
device: 'digi_ctl144': device_add
PM: Adding info for No Bus:digi_ctl144
device: 'digi_ctl145': device_add
PM: Adding info for No Bus:digi_ctl145
device: 'digi_ctl146': device_add
PM: Adding info for No Bus:digi_ctl146
device: 'digi_ctl147': device_add
PM: Adding info for No Bus:digi_ctl147
device: 'digi_ctl148': device_add
PM: Adding info for No Bus:digi_ctl148
device: 'digi_ctl149': device_add
PM: Adding info for No Bus:digi_ctl149
device: 'digi_ctl150': device_add
PM: Adding info for No Bus:digi_ctl150
device: 'digi_ctl151': device_add
PM: Adding info for No Bus:digi_ctl151
device: 'digi_ctl152': device_add
PM: Adding info for No Bus:digi_ctl152
device: 'digi_ctl153': device_add
PM: Adding info for No Bus:digi_ctl153
device: 'digi_ctl154': device_add
PM: Adding info for No Bus:digi_ctl154
device: 'digi_ctl155': device_add
PM: Adding info for No Bus:digi_ctl155
device: 'digi_ctl156': device_add
PM: Adding info for No Bus:digi_ctl156
device: 'digi_ctl157': device_add
PM: Adding info for No Bus:digi_ctl157
device: 'digi_ctl158': device_add
PM: Adding info for No Bus:digi_ctl158
device: 'digi_ctl159': device_add
PM: Adding info for No Bus:digi_ctl159
device: 'digi_ctl160': device_add
PM: Adding info for No Bus:digi_ctl160
device: 'digi_ctl161': device_add
PM: Adding info for No Bus:digi_ctl161
device: 'digi_ctl162': device_add
PM: Adding info for No Bus:digi_ctl162
device: 'digi_ctl163': device_add
PM: Adding info for No Bus:digi_ctl163
device: 'digi_ctl164': device_add
PM: Adding info for No Bus:digi_ctl164
device: 'digi_ctl165': device_add
PM: Adding info for No Bus:digi_ctl165
device: 'digi_ctl166': device_add
PM: Adding info for No Bus:digi_ctl166
device: 'digi_ctl167': device_add
PM: Adding info for No Bus:digi_ctl167
device: 'digi_ctl168': device_add
PM: Adding info for No Bus:digi_ctl168
device: 'digi_ctl169': device_add
PM: Adding info for No Bus:digi_ctl169
device: 'digi_ctl170': device_add
PM: Adding info for No Bus:digi_ctl170
device: 'digi_ctl171': device_add
PM: Adding info for No Bus:digi_ctl171
device: 'digi_ctl172': device_add
PM: Adding info for No Bus:digi_ctl172
device: 'digi_ctl173': device_add
PM: Adding info for No Bus:digi_ctl173
device: 'digi_ctl174': device_add
PM: Adding info for No Bus:digi_ctl174
device: 'digi_ctl175': device_add
PM: Adding info for No Bus:digi_ctl175
device: 'digi_ctl176': device_add
PM: Adding info for No Bus:digi_ctl176
device: 'digi_ctl177': device_add
PM: Adding info for No Bus:digi_ctl177
device: 'digi_ctl178': device_add
PM: Adding info for No Bus:digi_ctl178
device: 'digi_ctl179': device_add
PM: Adding info for No Bus:digi_ctl179
device: 'digi_ctl180': device_add
PM: Adding info for No Bus:digi_ctl180
device: 'digi_ctl181': device_add
PM: Adding info for No Bus:digi_ctl181
device: 'digi_ctl182': device_add
PM: Adding info for No Bus:digi_ctl182
device: 'digi_ctl183': device_add
PM: Adding info for No Bus:digi_ctl183
device: 'digi_ctl184': device_add
PM: Adding info for No Bus:digi_ctl184
device: 'digi_ctl185': device_add
PM: Adding info for No Bus:digi_ctl185
device: 'digi_ctl186': device_add
PM: Adding info for No Bus:digi_ctl186
device: 'digi_ctl187': device_add
PM: Adding info for No Bus:digi_ctl187
device: 'digi_ctl188': device_add
PM: Adding info for No Bus:digi_ctl188
device: 'digi_ctl189': device_add
PM: Adding info for No Bus:digi_ctl189
device: 'digi_ctl190': device_add
PM: Adding info for No Bus:digi_ctl190
device: 'digi_ctl191': device_add
PM: Adding info for No Bus:digi_ctl191
device: 'digi_ctl192': device_add
PM: Adding info for No Bus:digi_ctl192
device: 'digi_ctl193': device_add
PM: Adding info for No Bus:digi_ctl193
device: 'digi_ctl194': device_add
PM: Adding info for No Bus:digi_ctl194
device: 'digi_ctl195': device_add
PM: Adding info for No Bus:digi_ctl195
device: 'digi_ctl196': device_add
PM: Adding info for No Bus:digi_ctl196
device: 'digi_ctl197': device_add
PM: Adding info for No Bus:digi_ctl197
device: 'digi_ctl198': device_add
PM: Adding info for No Bus:digi_ctl198
device: 'digi_ctl199': device_add
PM: Adding info for No Bus:digi_ctl199
device: 'digi_ctl200': device_add
PM: Adding info for No Bus:digi_ctl200
device: 'digi_ctl201': device_add
PM: Adding info for No Bus:digi_ctl201
device: 'digi_ctl202': device_add
PM: Adding info for No Bus:digi_ctl202
device: 'digi_ctl203': device_add
PM: Adding info for No Bus:digi_ctl203
device: 'digi_ctl204': device_add
PM: Adding info for No Bus:digi_ctl204
device: 'digi_ctl205': device_add
PM: Adding info for No Bus:digi_ctl205
device: 'digi_ctl206': device_add
PM: Adding info for No Bus:digi_ctl206
device: 'digi_ctl207': device_add
PM: Adding info for No Bus:digi_ctl207
device: 'digi_ctl208': device_add
PM: Adding info for No Bus:digi_ctl208
device: 'digi_ctl209': device_add
PM: Adding info for No Bus:digi_ctl209
device: 'digi_ctl210': device_add
PM: Adding info for No Bus:digi_ctl210
device: 'digi_ctl211': device_add
PM: Adding info for No Bus:digi_ctl211
device: 'digi_ctl212': device_add
PM: Adding info for No Bus:digi_ctl212
device: 'digi_ctl213': device_add
PM: Adding info for No Bus:digi_ctl213
device: 'digi_ctl214': device_add
PM: Adding info for No Bus:digi_ctl214
device: 'digi_ctl215': device_add
PM: Adding info for No Bus:digi_ctl215
device: 'digi_ctl216': device_add
PM: Adding info for No Bus:digi_ctl216
device: 'digi_ctl217': device_add
PM: Adding info for No Bus:digi_ctl217
device: 'digi_ctl218': device_add
PM: Adding info for No Bus:digi_ctl218
device: 'digi_ctl219': device_add
PM: Adding info for No Bus:digi_ctl219
device: 'digi_ctl220': device_add
PM: Adding info for No Bus:digi_ctl220
device: 'digi_ctl221': device_add
PM: Adding info for No Bus:digi_ctl221
device: 'digi_ctl222': device_add
PM: Adding info for No Bus:digi_ctl222
device: 'digi_ctl223': device_add
PM: Adding info for No Bus:digi_ctl223
device: 'digi_ctl224': device_add
PM: Adding info for No Bus:digi_ctl224
device: 'digi_ctl225': device_add
PM: Adding info for No Bus:digi_ctl225
device: 'digi_ctl226': device_add
PM: Adding info for No Bus:digi_ctl226
device: 'digi_ctl227': device_add
PM: Adding info for No Bus:digi_ctl227
device: 'digi_ctl228': device_add
PM: Adding info for No Bus:digi_ctl228
device: 'digi_ctl229': device_add
PM: Adding info for No Bus:digi_ctl229
device: 'digi_ctl230': device_add
PM: Adding info for No Bus:digi_ctl230
device: 'digi_ctl231': device_add
PM: Adding info for No Bus:digi_ctl231
device: 'digi_ctl232': device_add
PM: Adding info for No Bus:digi_ctl232
device: 'digi_ctl233': device_add
PM: Adding info for No Bus:digi_ctl233
device: 'digi_ctl234': device_add
PM: Adding info for No Bus:digi_ctl234
device: 'digi_ctl235': device_add
PM: Adding info for No Bus:digi_ctl235
device: 'digi_ctl236': device_add
PM: Adding info for No Bus:digi_ctl236
device: 'digi_ctl237': device_add
PM: Adding info for No Bus:digi_ctl237
device: 'digi_ctl238': device_add
PM: Adding info for No Bus:digi_ctl238
device: 'digi_ctl239': device_add
PM: Adding info for No Bus:digi_ctl239
device: 'digi_ctl240': device_add
PM: Adding info for No Bus:digi_ctl240
device: 'digi_ctl241': device_add
PM: Adding info for No Bus:digi_ctl241
device: 'digi_ctl242': device_add
PM: Adding info for No Bus:digi_ctl242
device: 'digi_ctl243': device_add
PM: Adding info for No Bus:digi_ctl243
device: 'digi_ctl244': device_add
PM: Adding info for No Bus:digi_ctl244
device: 'digi_ctl245': device_add
PM: Adding info for No Bus:digi_ctl245
device: 'digi_ctl246': device_add
PM: Adding info for No Bus:digi_ctl246
device: 'digi_ctl247': device_add
PM: Adding info for No Bus:digi_ctl247
device: 'digi_ctl248': device_add
PM: Adding info for No Bus:digi_ctl248
device: 'digi_ctl249': device_add
PM: Adding info for No Bus:digi_ctl249
device: 'digi_ctl250': device_add
PM: Adding info for No Bus:digi_ctl250
device: 'digi_ctl251': device_add
PM: Adding info for No Bus:digi_ctl251
device: 'digi_ctl252': device_add
PM: Adding info for No Bus:digi_ctl252
device: 'digi_ctl253': device_add
PM: Adding info for No Bus:digi_ctl253
device: 'digi_ctl254': device_add
PM: Adding info for No Bus:digi_ctl254
device: 'digi_ctl255': device_add
PM: Adding info for No Bus:digi_ctl255
initcall epca_module_init+0x0/0x590 returned 0 after 3073 msecs
calling  mxser_module_init+0x0/0x7a0
MOXA Smartio/Industio family driver version 2.0.4
bus: 'pci': add driver mxser
initcall mxser_module_init+0x0/0x7a0 returned 0 after 6 msecs
calling  ip2_init+0x0/0x50
Computone IntelliPort Plus multiport driver version 1.2.14
device class 'ip2': registering
initcall ip2_init+0x0/0x50 returned 0 after 7 msecs
calling  riscom8_init_module+0x0/0x450
rc: SDL RISCom/8 card driver v1.1, (c) D.Gorodchanin 1994-1996.
device: 'ttyL0': device_add
PM: Adding info for No Bus:ttyL0
device: 'ttyL1': device_add
PM: Adding info for No Bus:ttyL1
device: 'ttyL2': device_add
PM: Adding info for No Bus:ttyL2
device: 'ttyL3': device_add
PM: Adding info for No Bus:ttyL3
device: 'ttyL4': device_add
PM: Adding info for No Bus:ttyL4
device: 'ttyL5': device_add
PM: Adding info for No Bus:ttyL5
device: 'ttyL6': device_add
PM: Adding info for No Bus:ttyL6
device: 'ttyL7': device_add
PM: Adding info for No Bus:ttyL7
device: 'ttyL8': device_add
PM: Adding info for No Bus:ttyL8
device: 'ttyL9': device_add
PM: Adding info for No Bus:ttyL9
device: 'ttyL10': device_add
PM: Adding info for No Bus:ttyL10
device: 'ttyL11': device_add
PM: Adding info for No Bus:ttyL11
device: 'ttyL12': device_add
PM: Adding info for No Bus:ttyL12
device: 'ttyL13': device_add
PM: Adding info for No Bus:ttyL13
device: 'ttyL14': device_add
PM: Adding info for No Bus:ttyL14
device: 'ttyL15': device_add
PM: Adding info for No Bus:ttyL15
device: 'ttyL16': device_add
PM: Adding info for No Bus:ttyL16
device: 'ttyL17': device_add
PM: Adding info for No Bus:ttyL17
device: 'ttyL18': device_add
PM: Adding info for No Bus:ttyL18
device: 'ttyL19': device_add
PM: Adding info for No Bus:ttyL19
device: 'ttyL20': device_add
PM: Adding info for No Bus:ttyL20
device: 'ttyL21': device_add
PM: Adding info for No Bus:ttyL21
device: 'ttyL22': device_add
PM: Adding info for No Bus:ttyL22
device: 'ttyL23': device_add
PM: Adding info for No Bus:ttyL23
device: 'ttyL24': device_add
PM: Adding info for No Bus:ttyL24
device: 'ttyL25': device_add
PM: Adding info for No Bus:ttyL25
device: 'ttyL26': device_add
PM: Adding info for No Bus:ttyL26
device: 'ttyL27': device_add
PM: Adding info for No Bus:ttyL27
device: 'ttyL28': device_add
PM: Adding info for No Bus:ttyL28
device: 'ttyL29': device_add
PM: Adding info for No Bus:ttyL29
device: 'ttyL30': device_add
PM: Adding info for No Bus:ttyL30
device: 'ttyL31': device_add
PM: Adding info for No Bus:ttyL31
rc0: RISCom/8 Board at 0x220 not found.
rc1: RISCom/8 Board at 0x240 not found.
rc2: RISCom/8 Board at 0x250 not found.
rc3: RISCom/8 Board at 0x260 not found.
device: 'ttyL0': device_unregister
PM: Removing info for No Bus:ttyL0
device: 'ttyL0': device_create_release
device: 'ttyL1': device_unregister
PM: Removing info for No Bus:ttyL1
device: 'ttyL1': device_create_release
device: 'ttyL2': device_unregister
PM: Removing info for No Bus:ttyL2
device: 'ttyL2': device_create_release
device: 'ttyL3': device_unregister
PM: Removing info for No Bus:ttyL3
device: 'ttyL3': device_create_release
device: 'ttyL4': device_unregister
PM: Removing info for No Bus:ttyL4
device: 'ttyL4': device_create_release
device: 'ttyL5': device_unregister
PM: Removing info for No Bus:ttyL5
device: 'ttyL5': device_create_release
device: 'ttyL6': device_unregister
PM: Removing info for No Bus:ttyL6
device: 'ttyL6': device_create_release
device: 'ttyL7': device_unregister
PM: Removing info for No Bus:ttyL7
device: 'ttyL7': device_create_release
device: 'ttyL8': device_unregister
PM: Removing info for No Bus:ttyL8
device: 'ttyL8': device_create_release
device: 'ttyL9': device_unregister
PM: Removing info for No Bus:ttyL9
device: 'ttyL9': device_create_release
device: 'ttyL10': device_unregister
PM: Removing info for No Bus:ttyL10
device: 'ttyL10': device_create_release
device: 'ttyL11': device_unregister
PM: Removing info for No Bus:ttyL11
device: 'ttyL11': device_create_release
device: 'ttyL12': device_unregister
PM: Removing info for No Bus:ttyL12
device: 'ttyL12': device_create_release
device: 'ttyL13': device_unregister
PM: Removing info for No Bus:ttyL13
device: 'ttyL13': device_create_release
device: 'ttyL14': device_unregister
PM: Removing info for No Bus:ttyL14
device: 'ttyL14': device_create_release
device: 'ttyL15': device_unregister
PM: Removing info for No Bus:ttyL15
device: 'ttyL15': device_create_release
device: 'ttyL16': device_unregister
PM: Removing info for No Bus:ttyL16
device: 'ttyL16': device_create_release
device: 'ttyL17': device_unregister
PM: Removing info for No Bus:ttyL17
device: 'ttyL17': device_create_release
device: 'ttyL18': device_unregister
PM: Removing info for No Bus:ttyL18
device: 'ttyL18': device_create_release
device: 'ttyL19': device_unregister
PM: Removing info for No Bus:ttyL19
device: 'ttyL19': device_create_release
device: 'ttyL20': device_unregister
PM: Removing info for No Bus:ttyL20
device: 'ttyL20': device_create_release
device: 'ttyL21': device_unregister
PM: Removing info for No Bus:ttyL21
device: 'ttyL21': device_create_release
device: 'ttyL22': device_unregister
PM: Removing info for No Bus:ttyL22
device: 'ttyL22': device_create_release
device: 'ttyL23': device_unregister
PM: Removing info for No Bus:ttyL23
device: 'ttyL23': device_create_release
device: 'ttyL24': device_unregister
PM: Removing info for No Bus:ttyL24
device: 'ttyL24': device_create_release
device: 'ttyL25': device_unregister
PM: Removing info for No Bus:ttyL25
device: 'ttyL25': device_create_release
device: 'ttyL26': device_unregister
PM: Removing info for No Bus:ttyL26
device: 'ttyL26': device_create_release
device: 'ttyL27': device_unregister
PM: Removing info for No Bus:ttyL27
device: 'ttyL27': device_create_release
device: 'ttyL28': device_unregister
PM: Removing info for No Bus:ttyL28
device: 'ttyL28': device_create_release
device: 'ttyL29': device_unregister
PM: Removing info for No Bus:ttyL29
device: 'ttyL29': device_create_release
device: 'ttyL30': device_unregister
PM: Removing info for No Bus:ttyL30
device: 'ttyL30': device_create_release
device: 'ttyL31': device_unregister
PM: Removing info for No Bus:ttyL31
device: 'ttyL31': device_create_release
rc: No RISCom/8 boards detected.
initcall riscom8_init_module+0x0/0x450 returned -5 after 509 msecs
initcall riscom8_init_module+0x0/0x450 returned with error code -5 
calling  isicom_init+0x0/0x270
bus: 'pci': add driver isicom
initcall isicom_init+0x0/0x270 returned 0 after 2 msecs
calling  synclinkmp_init+0x0/0x1f0
SyncLink MultiPort driver $Revision: 4.38 $
bus: 'pci': add driver synclinkmp
device: 'ttySLM0': device_add
PM: Adding info for No Bus:ttySLM0
device: 'ttySLM1': device_add
PM: Adding info for No Bus:ttySLM1
device: 'ttySLM2': device_add
PM: Adding info for No Bus:ttySLM2
device: 'ttySLM3': device_add
PM: Adding info for No Bus:ttySLM3
device: 'ttySLM4': device_add
PM: Adding info for No Bus:ttySLM4
device: 'ttySLM5': device_add
PM: Adding info for No Bus:ttySLM5
device: 'ttySLM6': device_add
PM: Adding info for No Bus:ttySLM6
device: 'ttySLM7': device_add
PM: Adding info for No Bus:ttySLM7
device: 'ttySLM8': device_add
PM: Adding info for No Bus:ttySLM8
device: 'ttySLM9': device_add
PM: Adding info for No Bus:ttySLM9
device: 'ttySLM10': device_add
PM: Adding info for No Bus:ttySLM10
device: 'ttySLM11': device_add
PM: Adding info for No Bus:ttySLM11
device: 'ttySLM12': device_add
PM: Adding info for No Bus:ttySLM12
device: 'ttySLM13': device_add
PM: Adding info for No Bus:ttySLM13
device: 'ttySLM14': device_add
PM: Adding info for No Bus:ttySLM14
device: 'ttySLM15': device_add
PM: Adding info for No Bus:ttySLM15
device: 'ttySLM16': device_add
PM: Adding info for No Bus:ttySLM16
device: 'ttySLM17': device_add
PM: Adding info for No Bus:ttySLM17
device: 'ttySLM18': device_add
PM: Adding info for No Bus:ttySLM18
device: 'ttySLM19': device_add
PM: Adding info for No Bus:ttySLM19
device: 'ttySLM20': device_add
PM: Adding info for No Bus:ttySLM20
device: 'ttySLM21': device_add
PM: Adding info for No Bus:ttySLM21
device: 'ttySLM22': device_add
PM: Adding info for No Bus:ttySLM22
device: 'ttySLM23': device_add
PM: Adding info for No Bus:ttySLM23
device: 'ttySLM24': device_add
PM: Adding info for No Bus:ttySLM24
device: 'ttySLM25': device_add
PM: Adding info for No Bus:ttySLM25
device: 'ttySLM26': device_add
PM: Adding info for No Bus:ttySLM26
device: 'ttySLM27': device_add
PM: Adding info for No Bus:ttySLM27
device: 'ttySLM28': device_add
PM: Adding info for No Bus:ttySLM28
device: 'ttySLM29': device_add
PM: Adding info for No Bus:ttySLM29
device: 'ttySLM30': device_add
PM: Adding info for No Bus:ttySLM30
device: 'ttySLM31': device_add
PM: Adding info for No Bus:ttySLM31
device: 'ttySLM32': device_add
PM: Adding info for No Bus:ttySLM32
device: 'ttySLM33': device_add
PM: Adding info for No Bus:ttySLM33
device: 'ttySLM34': device_add
PM: Adding info for No Bus:ttySLM34
device: 'ttySLM35': device_add
PM: Adding info for No Bus:ttySLM35
device: 'ttySLM36': device_add
PM: Adding info for No Bus:ttySLM36
device: 'ttySLM37': device_add
PM: Adding info for No Bus:ttySLM37
device: 'ttySLM38': device_add
PM: Adding info for No Bus:ttySLM38
device: 'ttySLM39': device_add
PM: Adding info for No Bus:ttySLM39
device: 'ttySLM40': device_add
PM: Adding info for No Bus:ttySLM40
device: 'ttySLM41': device_add
PM: Adding info for No Bus:ttySLM41
device: 'ttySLM42': device_add
PM: Adding info for No Bus:ttySLM42
device: 'ttySLM43': device_add
PM: Adding info for No Bus:ttySLM43
device: 'ttySLM44': device_add
PM: Adding info for No Bus:ttySLM44
device: 'ttySLM45': device_add
PM: Adding info for No Bus:ttySLM45
device: 'ttySLM46': device_add
PM: Adding info for No Bus:ttySLM46
device: 'ttySLM47': device_add
PM: Adding info for No Bus:ttySLM47
device: 'ttySLM48': device_add
PM: Adding info for No Bus:ttySLM48
device: 'ttySLM49': device_add
PM: Adding info for No Bus:ttySLM49
device: 'ttySLM50': device_add
PM: Adding info for No Bus:ttySLM50
device: 'ttySLM51': device_add
PM: Adding info for No Bus:ttySLM51
device: 'ttySLM52': device_add
PM: Adding info for No Bus:ttySLM52
device: 'ttySLM53': device_add
PM: Adding info for No Bus:ttySLM53
device: 'ttySLM54': device_add
PM: Adding info for No Bus:ttySLM54
device: 'ttySLM55': device_add
PM: Adding info for No Bus:ttySLM55
device: 'ttySLM56': device_add
PM: Adding info for No Bus:ttySLM56
device: 'ttySLM57': device_add
PM: Adding info for No Bus:ttySLM57
device: 'ttySLM58': device_add
PM: Adding info for No Bus:ttySLM58
device: 'ttySLM59': device_add
PM: Adding info for No Bus:ttySLM59
device: 'ttySLM60': device_add
PM: Adding info for No Bus:ttySLM60
device: 'ttySLM61': device_add
PM: Adding info for No Bus:ttySLM61
device: 'ttySLM62': device_add
PM: Adding info for No Bus:ttySLM62
device: 'ttySLM63': device_add
PM: Adding info for No Bus:ttySLM63
device: 'ttySLM64': device_add
PM: Adding info for No Bus:ttySLM64
device: 'ttySLM65': device_add
PM: Adding info for No Bus:ttySLM65
device: 'ttySLM66': device_add
PM: Adding info for No Bus:ttySLM66
device: 'ttySLM67': device_add
PM: Adding info for No Bus:ttySLM67
device: 'ttySLM68': device_add
PM: Adding info for No Bus:ttySLM68
device: 'ttySLM69': device_add
PM: Adding info for No Bus:ttySLM69
device: 'ttySLM70': device_add
PM: Adding info for No Bus:ttySLM70
device: 'ttySLM71': device_add
PM: Adding info for No Bus:ttySLM71
device: 'ttySLM72': device_add
PM: Adding info for No Bus:ttySLM72
device: 'ttySLM73': device_add
PM: Adding info for No Bus:ttySLM73
device: 'ttySLM74': device_add
PM: Adding info for No Bus:ttySLM74
device: 'ttySLM75': device_add
PM: Adding info for No Bus:ttySLM75
device: 'ttySLM76': device_add
PM: Adding info for No Bus:ttySLM76
device: 'ttySLM77': device_add
PM: Adding info for No Bus:ttySLM77
device: 'ttySLM78': device_add
PM: Adding info for No Bus:ttySLM78
device: 'ttySLM79': device_add
PM: Adding info for No Bus:ttySLM79
device: 'ttySLM80': device_add
PM: Adding info for No Bus:ttySLM80
device: 'ttySLM81': device_add
PM: Adding info for No Bus:ttySLM81
device: 'ttySLM82': device_add
PM: Adding info for No Bus:ttySLM82
device: 'ttySLM83': device_add
PM: Adding info for No Bus:ttySLM83
device: 'ttySLM84': device_add
PM: Adding info for No Bus:ttySLM84
device: 'ttySLM85': device_add
PM: Adding info for No Bus:ttySLM85
device: 'ttySLM86': device_add
PM: Adding info for No Bus:ttySLM86
device: 'ttySLM87': device_add
PM: Adding info for No Bus:ttySLM87
device: 'ttySLM88': device_add
PM: Adding info for No Bus:ttySLM88
device: 'ttySLM89': device_add
PM: Adding info for No Bus:ttySLM89
device: 'ttySLM90': device_add
PM: Adding info for No Bus:ttySLM90
device: 'ttySLM91': device_add
PM: Adding info for No Bus:ttySLM91
device: 'ttySLM92': device_add
PM: Adding info for No Bus:ttySLM92
device: 'ttySLM93': device_add
PM: Adding info for No Bus:ttySLM93
device: 'ttySLM94': device_add
PM: Adding info for No Bus:ttySLM94
device: 'ttySLM95': device_add
PM: Adding info for No Bus:ttySLM95
device: 'ttySLM96': device_add
PM: Adding info for No Bus:ttySLM96
device: 'ttySLM97': device_add
PM: Adding info for No Bus:ttySLM97
device: 'ttySLM98': device_add
PM: Adding info for No Bus:ttySLM98
device: 'ttySLM99': device_add
PM: Adding info for No Bus:ttySLM99
device: 'ttySLM100': device_add
PM: Adding info for No Bus:ttySLM100
device: 'ttySLM101': device_add
PM: Adding info for No Bus:ttySLM101
device: 'ttySLM102': device_add
PM: Adding info for No Bus:ttySLM102
device: 'ttySLM103': device_add
PM: Adding info for No Bus:ttySLM103
device: 'ttySLM104': device_add
PM: Adding info for No Bus:ttySLM104
device: 'ttySLM105': device_add
PM: Adding info for No Bus:ttySLM105
device: 'ttySLM106': device_add
PM: Adding info for No Bus:ttySLM106
device: 'ttySLM107': device_add
PM: Adding info for No Bus:ttySLM107
device: 'ttySLM108': device_add
PM: Adding info for No Bus:ttySLM108
device: 'ttySLM109': device_add
PM: Adding info for No Bus:ttySLM109
device: 'ttySLM110': device_add
PM: Adding info for No Bus:ttySLM110
device: 'ttySLM111': device_add
PM: Adding info for No Bus:ttySLM111
device: 'ttySLM112': device_add
PM: Adding info for No Bus:ttySLM112
device: 'ttySLM113': device_add
PM: Adding info for No Bus:ttySLM113
device: 'ttySLM114': device_add
PM: Adding info for No Bus:ttySLM114
device: 'ttySLM115': device_add
PM: Adding info for No Bus:ttySLM115
device: 'ttySLM116': device_add
PM: Adding info for No Bus:ttySLM116
device: 'ttySLM117': device_add
PM: Adding info for No Bus:ttySLM117
device: 'ttySLM118': device_add
PM: Adding info for No Bus:ttySLM118
device: 'ttySLM119': device_add
PM: Adding info for No Bus:ttySLM119
device: 'ttySLM120': device_add
PM: Adding info for No Bus:ttySLM120
device: 'ttySLM121': device_add
PM: Adding info for No Bus:ttySLM121
device: 'ttySLM122': device_add
PM: Adding info for No Bus:ttySLM122
device: 'ttySLM123': device_add
PM: Adding info for No Bus:ttySLM123
device: 'ttySLM124': device_add
PM: Adding info for No Bus:ttySLM124
device: 'ttySLM125': device_add
PM: Adding info for No Bus:ttySLM125
device: 'ttySLM126': device_add
PM: Adding info for No Bus:ttySLM126
device: 'ttySLM127': device_add
PM: Adding info for No Bus:ttySLM127
SyncLink MultiPort driver $Revision: 4.38 $, tty major#253
initcall synclinkmp_init+0x0/0x1f0 returned 0 after 770 msecs
calling  slgt_init+0x0/0x220
SyncLink GT $Revision: 4.50 $
SyncLink GT $Revision: 4.50 $, tty major#252
bus: 'pci': add driver synclink_gt
SyncLink GT no devices found
initcall slgt_init+0x0/0x220 returned 0 after 12 msecs
calling  sx_init+0x0/0x120
device: 'sxctl': device_add
PM: Adding info for No Bus:sxctl
bus: 'pci': add driver sx
initcall sx_init+0x0/0x120 returned 0 after 7 msecs
calling  hpet_init+0x0/0x80
device: 'hpet': device_add
PM: Adding info for No Bus:hpet
bus: 'acpi': add driver hpet
initcall hpet_init+0x0/0x80 returned 0 after 7 msecs
calling  nvram_init+0x0/0xa0
device: 'nvram': device_add
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
initcall nvram_init+0x0/0xa0 returned 0 after 8 msecs
calling  tlclk_init+0x0/0x1f0
telclk_interrup = 0xf non-mcpbl0010 hw.
initcall tlclk_init+0x0/0x1f0 returned -6 after 3 msecs
initcall tlclk_init+0x0/0x1f0 returned with error code -6 
calling  agp_init+0x0/0x30
Linux agpgart interface v0.103
initcall agp_init+0x0/0x30 returned 0 after 2 msecs
calling  hangcheck_init+0x0/0xb0
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
initcall hangcheck_init+0x0/0xb0 returned 0 after 10 msecs
calling  serial8250_init+0x0/0x1a0
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
Registering platform device 'serial8250'. Parent at platform
device: 'serial8250': device_add
bus: 'platform': add device serial8250
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
device: 'ttyS1': device_add
PM: Adding info for No Bus:ttyS1
device: 'ttyS2': device_add
PM: Adding info for No Bus:ttyS2
device: 'ttyS3': device_add
PM: Adding info for No Bus:ttyS3
bus: 'platform': add driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
driver: 'serial8250': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
initcall serial8250_init+0x0/0x1a0 returned 0 after 75 msecs
calling  serial8250_pnp_init+0x0/0x20
bus: 'pnp': add driver serial
bus: 'pnp': driver_probe_device: matched device 00:0b with driver serial
bus: 'pnp': really_probe: probing driver serial with device 00:0b
device: 'ttyS0': device_unregister
PM: Removing info for No Bus:ttyS0
device: 'ttyS0': device_create_release
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
driver: '00:0b': driver_bound: bound to device 'serial'
bus: 'pnp': really_probe: bound device 00:0b to driver serial
initcall serial8250_pnp_init+0x0/0x20 returned 0 after 43 msecs
calling  serial8250_pci_init+0x0/0x20
bus: 'pci': add driver serial
initcall serial8250_pci_init+0x0/0x20 returned 0 after 2 msecs
calling  loop_init+0x0/0x1f0
device: 'loop0': device_add
PM: Adding info for No Bus:loop0
device: '7:0': device_add
PM: Adding info for No Bus:7:0
device: 'loop1': device_add
PM: Adding info for No Bus:loop1
device: '7:1': device_add
PM: Adding info for No Bus:7:1
device: 'loop2': device_add
PM: Adding info for No Bus:loop2
device: '7:2': device_add
PM: Adding info for No Bus:7:2
device: 'loop3': device_add
PM: Adding info for No Bus:loop3
device: '7:3': device_add
PM: Adding info for No Bus:7:3
device: 'loop4': device_add
PM: Adding info for No Bus:loop4
device: '7:4': device_add
PM: Adding info for No Bus:7:4
device: 'loop5': device_add
PM: Adding info for No Bus:loop5
device: '7:5': device_add
PM: Adding info for No Bus:7:5
device: 'loop6': device_add
PM: Adding info for No Bus:loop6
device: '7:6': device_add
PM: Adding info for No Bus:7:6
device: 'loop7': device_add
PM: Adding info for No Bus:loop7
device: '7:7': device_add
PM: Adding info for No Bus:7:7
loop: module loaded
initcall loop_init+0x0/0x1f0 returned 0 after 85 msecs
calling  cpqarray_init+0x0/0x2a0
Compaq SMART2 Driver (v 2.6.0)
bus: 'pci': add driver cpqarray
initcall cpqarray_init+0x0/0x2a0 returned 0 after 5 msecs
calling  pkt_init+0x0/0x1d0
device class 'pktcdvd': registering
device: 'pktcdvd': device_add
PM: Adding info for No Bus:pktcdvd
initcall pkt_init+0x0/0x1d0 returned 0 after 8 msecs
calling  nbd_init+0x0/0x390
nbd: registered device at major 43
device: 'nbd0': device_add
PM: Adding info for No Bus:nbd0
device: '43:0': device_add
PM: Adding info for No Bus:43:0
device: 'nbd1': device_add
PM: Adding info for No Bus:nbd1
device: '43:1': device_add
PM: Adding info for No Bus:43:1
device: 'nbd2': device_add
PM: Adding info for No Bus:nbd2
device: '43:2': device_add
PM: Adding info for No Bus:43:2
device: 'nbd3': device_add
PM: Adding info for No Bus:nbd3
device: '43:3': device_add
PM: Adding info for No Bus:43:3
device: 'nbd4': device_add
PM: Adding info for No Bus:nbd4
device: '43:4': device_add
PM: Adding info for No Bus:43:4
device: 'nbd5': device_add
PM: Adding info for No Bus:nbd5
device: '43:5': device_add
PM: Adding info for No Bus:43:5
device: 'nbd6': device_add
PM: Adding info for No Bus:nbd6
device: '43:6': device_add
PM: Adding info for No Bus:43:6
device: 'nbd7': device_add
PM: Adding info for No Bus:nbd7
device: '43:7': device_add
PM: Adding info for No Bus:43:7
device: 'nbd8': device_add
PM: Adding info for No Bus:nbd8
device: '43:8': device_add
PM: Adding info for No Bus:43:8
device: 'nbd9': device_add
PM: Adding info for No Bus:nbd9
device: '43:9': device_add
PM: Adding info for No Bus:43:9
device: 'nbd10': device_add
PM: Adding info for No Bus:nbd10
device: '43:10': device_add
PM: Adding info for No Bus:43:10
device: 'nbd11': device_add
PM: Adding info for No Bus:nbd11
device: '43:11': device_add
PM: Adding info for No Bus:43:11
device: 'nbd12': device_add
PM: Adding info for No Bus:nbd12
device: '43:12': device_add
PM: Adding info for No Bus:43:12
device: 'nbd13': device_add
PM: Adding info for No Bus:nbd13
device: '43:13': device_add
PM: Adding info for No Bus:43:13
device: 'nbd14': device_add
PM: Adding info for No Bus:nbd14
device: '43:14': device_add
PM: Adding info for No Bus:43:14
device: 'nbd15': device_add
PM: Adding info for No Bus:nbd15
device: '43:15': device_add
PM: Adding info for No Bus:43:15
initcall nbd_init+0x0/0x390 returned 0 after 173 msecs
calling  carm_init+0x0/0x20
bus: 'pci': add driver sx8
initcall carm_init+0x0/0x20 returned 0 after 2 msecs
calling  sm501_base_init+0x0/0x30
bus: 'platform': add driver sm501
bus: 'pci': add driver sm501
initcall sm501_base_init+0x0/0x30 returned 0 after 5 msecs
calling  e1000_init_module+0x0/0xa0
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
bus: 'pci': add driver e1000
initcall e1000_init_module+0x0/0xa0 returned 0 after 11 msecs
calling  e1000_init_module+0x0/0x80
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
bus: 'pci': add driver e1000e
bus: 'pci': driver_probe_device: matched device 0000:04:00.0 with driver e1000e
bus: 'pci': really_probe: probing driver e1000e with device 0000:04:00.0
vendor=8086 device=27e2
e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
device: 'eth0': device_add
PM: Adding info for No Bus:eth0
eth0: (PCI Express:2.5GB/s:Width x1) 00:16:76:ab:6e:84
eth0: Intel(R) PRO/1000 Network Connection
eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
driver: '0000:04:00.0': driver_bound: bound to device 'e1000e'
bus: 'pci': really_probe: bound device 0000:04:00.0 to driver e1000e
initcall e1000_init_module+0x0/0x80 returned 0 after 144 msecs
calling  igb_init_module+0x0/0x60
Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
Copyright (c) 2008 Intel Corporation.
bus: 'pci': add driver igb
initcall igb_init_module+0x0/0x60 returned 0 after 10 msecs
calling  atl1e_init_module+0x0/0x20
bus: 'pci': add driver ATL1E
initcall atl1e_init_module+0x0/0x20 returned 0 after 2 msecs
calling  vortex_init+0x0/0xe0
bus: 'pci': add driver 3c59x
initcall vortex_init+0x0/0xe0 returned 0 after 2 msecs
calling  typhoon_init+0x0/0x20
bus: 'pci': add driver typhoon
initcall typhoon_init+0x0/0x20 returned 0 after 2 msecs
calling  pcnet32_init_module+0x0/0x150
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
bus: 'pci': add driver pcnet32
initcall pcnet32_init_module+0x0/0x150 returned 0 after 7 msecs
calling  e100_init_module+0x0/0x70
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
bus: 'pci': add driver e100
initcall e100_init_module+0x0/0x70 returned 0 after 11 msecs
calling  epic_init+0x0/0x20
bus: 'pci': add driver epic100
initcall epic_init+0x0/0x20 returned 0 after 2 msecs
calling  sis190_init_module+0x0/0x20
bus: 'pci': add driver sis190
initcall sis190_init_module+0x0/0x20 returned 0 after 2 msecs
calling  yellowfin_init+0x0/0x20
bus: 'pci': add driver yellowfin
initcall yellowfin_init+0x0/0x20 returned 0 after 2 msecs
calling  acenic_init+0x0/0x20
bus: 'pci': add driver acenic
initcall acenic_init+0x0/0x20 returned 0 after 2 msecs
calling  ns83820_init+0x0/0x30
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
bus: 'pci': add driver ns83820
initcall ns83820_init+0x0/0x30 returned 0 after 8 msecs
calling  tg3_init+0x0/0x20
bus: 'pci': add driver tg3
initcall tg3_init+0x0/0x20 returned 0 after 2 msecs
calling  sky2_init_module+0x0/0x20
bus: 'pci': add driver sky2
initcall sky2_init_module+0x0/0x20 returned 0 after 2 msecs
calling  velocity_init_module+0x0/0x50
bus: 'pci': add driver via-velocity
initcall velocity_init_module+0x0/0x50 returned 0 after 3 msecs
calling  marvell_init+0x0/0xa0
bus: 'mdio_bus': add driver Marvell 88E1101
bus: 'mdio_bus': add driver Marvell 88E1112
bus: 'mdio_bus': add driver Marvell 88E1111
bus: 'mdio_bus': add driver Marvell 88E1145
bus: 'mdio_bus': add driver Marvell 88E1240
initcall marvell_init+0x0/0xa0 returned 0 after 19 msecs
calling  lxt_init+0x0/0x60
bus: 'mdio_bus': add driver LXT970
bus: 'mdio_bus': add driver LXT971
initcall lxt_init+0x0/0x60 returned 0 after 6 msecs
calling  qs6612_init+0x0/0x20
bus: 'mdio_bus': add driver QS6612
initcall qs6612_init+0x0/0x20 returned 0 after 3 msecs
calling  smsc_init+0x0/0x80
bus: 'mdio_bus': add driver SMSC LAN83C185
bus: 'mdio_bus': add driver SMSC LAN8187
bus: 'mdio_bus': add driver SMSC LAN8700
initcall smsc_init+0x0/0x80 returned 0 after 10 msecs
calling  vsc8244_init+0x0/0x20
bus: 'mdio_bus': add driver Vitesse VSC8244
initcall vsc8244_init+0x0/0x20 returned 0 after 3 msecs
calling  realtek_init+0x0/0x20
bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
initcall realtek_init+0x0/0x20 returned 0 after 4 msecs
calling  fixed_mdio_bus_init+0x0/0xc0
Registering platform device 'Fixed MDIO bus.0'. Parent at platform
device: 'Fixed MDIO bus.0': device_add
bus: 'platform': add device Fixed MDIO bus.0
PM: Adding info for platform:Fixed MDIO bus.0
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xc0 returned 0 after 18 msecs
calling  hamachi_init+0x0/0x20
bus: 'pci': add driver hamachi
initcall hamachi_init+0x0/0x20 returned 0 after 2 msecs
calling  net_olddevs_init+0x0/0xb0
initcall net_olddevs_init+0x0/0xb0 returned 0 after 0 msecs
calling  b44_init+0x0/0x80
bus: 'pci': add driver b44
bus: 'ssb': add driver b44
initcall b44_init+0x0/0x80 returned 0 after 4 msecs
calling  init_nic+0x0/0x20
bus: 'pci': add driver forcedeth
initcall init_nic+0x0/0x20 returned 0 after 2 msecs
calling  ppp_init+0x0/0xc0
PPP generic driver version 2.4.2
device class 'ppp': registering
device: 'ppp': device_add
PM: Adding info for No Bus:ppp
initcall ppp_init+0x0/0xc0 returned 0 after 10 msecs
calling  deflate_init+0x0/0x50
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x50 returned 0 after 3 msecs
calling  bsdcomp_init+0x0/0x40
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x40 returned 0 after 3 msecs
calling  ppp_mppe_init+0x0/0x120
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0x120 returned 0 after 3 msecs
calling  dummy_init_module+0x0/0xf0
device: 'dummy0': device_add
PM: Adding info for No Bus:dummy0
initcall dummy_init_module+0x0/0xf0 returned 0 after 5 msecs
calling  rtl8139_init_module+0x0/0x20
bus: 'pci': add driver 8139too
initcall rtl8139_init_module+0x0/0x20 returned 0 after 2 msecs
calling  tun_init+0x0/0xb0
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
device: 'tun': device_add
PM: Adding info for No Bus:tun
initcall tun_init+0x0/0xb0 returned 0 after 13 msecs
calling  arcnet_init+0x0/0x80
arcnet loaded.
initcall arcnet_init+0x0/0x80 returned 0 after 1 msecs
calling  com90xx_init+0x0/0x12c0
arcnet: COM90xx chipset support
S3: No ARCnet cards found.
initcall com90xx_init+0x0/0x12c0 returned -5 after 291 msecs
initcall com90xx_init+0x0/0x12c0 returned with error code -5 
calling  com20020pci_init+0x0/0x40
arcnet: COM20020 PCI support
bus: 'pci': add driver com20020
initcall com20020pci_init+0x0/0x40 returned 0 after 5 msecs
calling  usb_rtl8150_init+0x0/0x30
rtl8150: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
bus: 'usb': add driver rtl8150
usbcore: registered new interface driver rtl8150
initcall usb_rtl8150_init+0x0/0x30 returned 0 after 12 msecs
calling  usbnet_init+0x0/0x20
bus: 'usb': add driver gl620a
usbcore: registered new interface driver gl620a
initcall usbnet_init+0x0/0x20 returned 0 after 6 msecs
calling  cdc_subset_init+0x0/0x20
bus: 'usb': add driver cdc_subset
usbcore: registered new interface driver cdc_subset
initcall cdc_subset_init+0x0/0x20 returned 0 after 7 msecs
calling  mcs7830_init+0x0/0x20
bus: 'usb': add driver MOSCHIP usb-ethernet driver
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall mcs7830_init+0x0/0x20 returned 0 after 10 msecs
calling  usbnet_init+0x0/0x40
initcall usbnet_init+0x0/0x40 returned 0 after 0 msecs
calling  hostap_init+0x0/0x50
initcall hostap_init+0x0/0x50 returned 0 after 0 msecs
calling  init_prism2_pci+0x0/0x20
bus: 'pci': add driver hostap_pci
initcall init_prism2_pci+0x0/0x20 returned 0 after 3 msecs
calling  lbs_init_module+0x0/0x50
initcall lbs_init_module+0x0/0x50 returned 0 after 0 msecs
calling  if_sdio_init_module+0x0/0x40
libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
bus: 'sdio': add driver libertas_sdio
initcall if_sdio_init_module+0x0/0x40 returned 0 after 9 msecs
calling  init_netconsole+0x0/0x210
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x210 returned 0 after 5 msecs
calling  init+0x0/0x20
bus: 'virtio': add driver virtio_net
initcall init+0x0/0x20 returned 0 after 3 msecs
calling  dabusb_init+0x0/0xf0
bus: 'usb': add driver dabusb
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
initcall dabusb_init+0x0/0xf0 returned 0 after 11 msecs
calling  mac_hid_init+0x0/0xf0
device: 'input0': device_add
PM: Adding info for No Bus:input0
input: Macintosh mouse button emulation as /class/input/input0
initcall mac_hid_init+0x0/0xf0 returned 0 after 10 msecs
calling  scsi_tgt_init+0x0/0xa0
device: 'tgt': device_add
PM: Adding info for No Bus:tgt
initcall scsi_tgt_init+0x0/0xa0 returned 0 after 5 msecs
calling  spi_transport_init+0x0/0x40
device class 'spi_transport': registering
device class 'spi_host': registering
initcall spi_transport_init+0x0/0x40 returned 0 after 6 msecs
calling  fc_transport_init+0x0/0x60
device class 'fc_host': registering
device class 'fc_vports': registering
device class 'fc_remote_ports': registering
device class 'fc_transport': registering
initcall fc_transport_init+0x0/0x60 returned 0 after 13 msecs
calling  srp_transport_init+0x0/0x60
device class 'srp_host': registering
device class 'srp_remote_ports': registering
initcall srp_transport_init+0x0/0x60 returned 0 after 7 msecs
calling  ahc_linux_init+0x0/0x70
bus: 'pci': add driver aic7xxx
initcall ahc_linux_init+0x0/0x70 returned 0 after 2 msecs
calling  aac_init+0x0/0x80
Adaptec aacraid driver 1.1-5[2456]-ms
bus: 'pci': add driver aacraid
initcall aac_init+0x0/0x80 returned 0 after 6 msecs
calling  ips_module_init+0x0/0x230
bus: 'pci': add driver ips
bus: 'pci': remove driver ips
driver: 'ips': driver_release
initcall ips_module_init+0x0/0x230 returned -19 after 7 msecs
calling  init_this_scsi_driver+0x0/0x110
scsi: <fdomain> Detection failed (no card)
initcall init_this_scsi_driver+0x0/0x110 returned -19 after 3 msecs
calling  qla2x00_module_init+0x0/0x1b0
QLogic Fibre Channel HBA Driver: 8.02.01-k4
bus: 'pci': add driver qla2xxx
initcall qla2x00_module_init+0x0/0x1b0 returned 0 after 6 msecs
calling  lpfc_init+0x0/0xe0
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
Copyright(c) 2004-2008 Emulex.  All rights reserved.
bus: 'pci': add driver lpfc
initcall lpfc_init+0x0/0xe0 returned 0 after 11 msecs
calling  megasas_init+0x0/0x180
megasas: 00.00.03.20-rc1 Mon. March 10 11:02:31 PDT 2008
bus: 'pci': add driver megaraid_sas
initcall megasas_init+0x0/0x180 returned 0 after 8 msecs
calling  initio_init_driver+0x0/0x20
bus: 'pci': add driver initio
initcall initio_init_driver+0x0/0x20 returned 0 after 2 msecs
calling  tw_init+0x0/0x40
3ware Storage Controller device driver for Linux v1.26.02.002.
bus: 'pci': add driver 3w-xxxx
initcall tw_init+0x0/0x40 returned 0 after 8 msecs
calling  init_sd+0x0/0x100
device class 'scsi_disk': registering
Driver 'sd' needs updating - please use bus_type methods
bus: 'scsi': add driver sd
initcall init_sd+0x0/0x100 returned 0 after 10 msecs
calling  init_sr+0x0/0x60
Driver 'sr' needs updating - please use bus_type methods
bus: 'scsi': add driver sr
initcall init_sr+0x0/0x60 returned 0 after 7 msecs
calling  init_sg+0x0/0x180
device class 'scsi_generic': registering
initcall init_sg+0x0/0x180 returned 0 after 3 msecs
calling  init_ch_module+0x0/0xc0
SCSI Media Changer driver v0.25 
device class 'scsi_changer': registering
Driver 'ch' needs updating - please use bus_type methods
bus: 'scsi': add driver ch
initcall init_ch_module+0x0/0xc0 returned 0 after 13 msecs
calling  ahci_init+0x0/0x20
bus: 'pci': add driver ahci
initcall ahci_init+0x0/0x20 returned 0 after 2 msecs
calling  piix_init+0x0/0x30
bus: 'pci': add driver ata_piix
bus: 'pci': driver_probe_device: matched device 0000:00:1f.1 with driver ata_piix
bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.1
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
device: 'host0': device_add
PM: Adding info for No Bus:host0
device: 'host0': device_add
PM: Adding info for No Bus:host0
scsi1 : ata_piix
device: 'host1': device_add
PM: Adding info for No Bus:host1
device: 'host1': device_add
PM: Adding info for No Bus:host1
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
ata2: port disabled. ignoring.
driver: '0000:00:1f.1': driver_bound: bound to device 'ata_piix'
bus: 'pci': really_probe: bound device 0000:00:1f.1 to driver ata_piix
bus: 'pci': driver_probe_device: matched device 0000:00:1f.2 with driver ata_piix
bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:1f.2
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
device: 'host2': device_add
PM: Adding info for No Bus:host2
device: 'host2': device_add
PM: Adding info for No Bus:host2
scsi3 : ata_piix
device: 'host3': device_add
PM: Adding info for No Bus:host3
device: 'host3': device_add
PM: Adding info for No Bus:host3
ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
ata3.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata3.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: ATA-7: HDT722516DLA380, V43OA96A, max UDMA/133
ata4.00: 321672960 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATAPI: PLEXTOR DVDR   PX-755A, 1.03, max UDMA/66
ata4.00: configured for UDMA/133
ata4.01: configured for UDMA/66
isa bounce pool size: 16 pages
scsi 2:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
device: 'target2:0:0': device_add
PM: Adding info for No Bus:target2:0:0
device: '2:0:0:0': device_add
bus: 'scsi': add device 2:0:0:0
PM: Adding info for scsi:2:0:0:0
bus: 'scsi': driver_probe_device: matched device 2:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 2:0:0:0
device: '2:0:0:0': device_add
PM: Adding info for No Bus:2:0:0:0
sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device: 'sda': device_add
PM: Adding info for No Bus:sda
sd 2:0:0:0: [sda] 321672960 512-byte hardware sectors (164697 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
device: 'sda1': device_add
PM: Adding info for No Bus:sda1
device: 'sda2': device_add
PM: Adding info for No Bus:sda2
device: '8:0': device_add
PM: Adding info for No Bus:8:0
sd 2:0:0:0: [sda] Attached SCSI disk
driver: '2:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 2:0:0:0 to driver sd
device: '2:0:0:0': device_add
PM: Adding info for No Bus:2:0:0:0
device: 'sg0': device_add
PM: Adding info for No Bus:sg0
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: Direct-Access     ATA      HDT722516DLA380  V43O PQ: 0 ANSI: 5
device: 'target3:0:0': device_add
PM: Adding info for No Bus:target3:0:0
device: '3:0:0:0': device_add
bus: 'scsi': add device 3:0:0:0
PM: Adding info for scsi:3:0:0:0
bus: 'scsi': driver_probe_device: matched device 3:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 3:0:0:0
device: '3:0:0:0': device_add
PM: Adding info for No Bus:3:0:0:0
sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
device: 'sdb': device_add
PM: Adding info for No Bus:sdb
sd 3:0:0:0: [sdb] 321672960 512-byte hardware sectors (164697 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
device: 'sdb1': device_add
PM: Adding info for No Bus:sdb1
device: '8:16': device_add
PM: Adding info for No Bus:8:16
sd 3:0:0:0: [sdb] Attached SCSI disk
driver: '3:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 3:0:0:0 to driver sd
device: '3:0:0:0': device_add
PM: Adding info for No Bus:3:0:0:0
device: 'sg1': device_add
PM: Adding info for No Bus:sg1
sd 3:0:0:0: Attached scsi generic sg1 type 0
scsi 3:0:1:0: CD-ROM            PLEXTOR  DVDR   PX-755A   1.03 PQ: 0 ANSI: 5
device: 'target3:0:1': device_add
PM: Adding info for No Bus:target3:0:1
device: '3:0:1:0': device_add
bus: 'scsi': add device 3:0:1:0
PM: Adding info for scsi:3:0:1:0
bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 3:0:1:0
bus: 'scsi': driver_probe_device: matched device 3:0:1:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 3:0:1:0
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
device: 'sr0': device_add
PM: Adding info for No Bus:sr0
device: '11:0': device_add
PM: Adding info for No Bus:11:0
sr 3:0:1:0: Attached scsi CD-ROM sr0
driver: '3:0:1:0': driver_bound: bound to device 'sr'
bus: 'scsi': really_probe: bound device 3:0:1:0 to driver sr
device: '3:0:1:0': device_add
PM: Adding info for No Bus:3:0:1:0
device: 'sg2': device_add
PM: Adding info for No Bus:sg2
sr 3:0:1:0: Attached scsi generic sg2 type 5
driver: '0000:00:1f.2': driver_bound: bound to device 'ata_piix'
bus: 'pci': really_probe: bound device 0000:00:1f.2 to driver ata_piix
initcall piix_init+0x0/0x30 returned 0 after 1025 msecs
calling  sil_init+0x0/0x20
bus: 'pci': add driver sata_sil
bus: 'pci': driver_probe_device: matched device 0000:05:05.0 with driver sata_sil
bus: 'pci': really_probe: probing driver sata_sil with device 0000:05:05.0
sata_sil 0000:05:05.0: version 2.3
vendor=8086 device=244e
sata_sil 0000:05:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sata_sil 0000:05:05.0: Applying R_ERR on DMA activate FIS errata fix
scsi4 : sata_sil
device: 'host4': device_add
PM: Adding info for No Bus:host4
device: 'host4': device_add
PM: Adding info for No Bus:host4
scsi5 : sata_sil
device: 'host5': device_add
PM: Adding info for No Bus:host5
device: 'host5': device_add
PM: Adding info for No Bus:host5
scsi6 : sata_sil
device: 'host6': device_add
PM: Adding info for No Bus:host6
device: 'host6': device_add
PM: Adding info for No Bus:host6
scsi7 : sata_sil
device: 'host7': device_add
PM: Adding info for No Bus:host7
device: 'host7': device_add
PM: Adding info for No Bus:host7
ata5: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c880 irq 17
ata6: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000c8c0 irq 17
ata7: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000ca80 irq 17
ata8: SATA max UDMA/100 mmio m1024@0x5000c800 tf 0x5000cac0 irq 17
ata5: SATA link down (SStatus 0 SControl 310)
ata6: SATA link down (SStatus 0 SControl 310)
ata7: SATA link down (SStatus 0 SControl 310)
ata8: SATA link down (SStatus 0 SControl 310)
driver: '0000:05:05.0': driver_bound: bound to device 'sata_sil'
bus: 'pci': really_probe: bound device 0000:05:05.0 to driver sata_sil
initcall sil_init+0x0/0x20 returned 0 after 1294 msecs
calling  sil24_init+0x0/0x20
bus: 'pci': add driver sata_sil24
initcall sil24_init+0x0/0x20 returned 0 after 3 msecs
calling  pdc_sata_init+0x0/0x20
bus: 'pci': add driver sata_sx4
initcall pdc_sata_init+0x0/0x20 returned 0 after 2 msecs
calling  nv_init+0x0/0x20
bus: 'pci': add driver sata_nv
initcall nv_init+0x0/0x20 returned 0 after 2 msecs
calling  ali_init+0x0/0x20
bus: 'pci': add driver pata_ali
initcall ali_init+0x0/0x20 returned 0 after 2 msecs
calling  amd_init+0x0/0x20
bus: 'pci': add driver pata_amd
initcall amd_init+0x0/0x20 returned 0 after 2 msecs
calling  atiixp_init+0x0/0x20
bus: 'pci': add driver pata_atiixp
initcall atiixp_init+0x0/0x20 returned 0 after 3 msecs
calling  cmd640_init+0x0/0x20
bus: 'pci': add driver pata_cmd640
initcall cmd640_init+0x0/0x20 returned 0 after 3 msecs
calling  ns87415_init+0x0/0x20
bus: 'pci': add driver pata_ns87415
initcall ns87415_init+0x0/0x20 returned 0 after 3 msecs
calling  mpiix_init+0x0/0x20
bus: 'pci': add driver pata_mpiix
initcall mpiix_init+0x0/0x20 returned 0 after 3 msecs
calling  oldpiix_init+0x0/0x20
bus: 'pci': add driver pata_oldpiix
initcall oldpiix_init+0x0/0x20 returned 0 after 3 msecs
calling  sc1200_init+0x0/0x20
bus: 'pci': add driver sc1200
initcall sc1200_init+0x0/0x20 returned 0 after 2 msecs
calling  sil680_init+0x0/0x20
bus: 'pci': add driver pata_sil680
initcall sil680_init+0x0/0x20 returned 0 after 3 msecs
calling  ata_generic_init+0x0/0x20
bus: 'pci': add driver ata_generic
initcall ata_generic_init+0x0/0x20 returned 0 after 3 msecs
calling  cdrom_init+0x0/0x20
initcall cdrom_init+0x0/0x20 returned 0 after 0 msecs
calling  mon_init+0x0/0x140
device class 'usbmon': registering
device: 'usbmon0': device_add
PM: Adding info for No Bus:usbmon0
device: 'usbmon5': device_add
PM: Adding info for No Bus:usbmon5
device: 'usbmon4': device_add
PM: Adding info for No Bus:usbmon4
device: 'usbmon3': device_add
PM: Adding info for No Bus:usbmon3
device: 'usbmon2': device_add
PM: Adding info for No Bus:usbmon2
device: 'usbmon1': device_add
PM: Adding info for No Bus:usbmon1
initcall mon_init+0x0/0x140 returned 0 after 37 msecs
calling  isp116x_init+0x0/0x50
116x: driver isp116x-hcd, 03 Nov 2005
bus: 'platform': add driver isp116x-hcd
initcall isp116x_init+0x0/0x50 returned 0 after 6 msecs
calling  sl811h_init+0x0/0x50
sl811: driver sl811-hcd, 19 May 2005
bus: 'platform': add driver sl811-hcd
initcall sl811h_init+0x0/0x50 returned 0 after 6 msecs
calling  isp1760_init+0x0/0x20
initcall isp1760_init+0x0/0x20 returned -19 after 0 msecs
calling  microtek_drv_init+0x0/0x20
bus: 'usb': add driver microtekX6
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x20 returned 0 after 7 msecs
calling  auerswald_init+0x0/0x40
bus: 'usb': add driver auerswald
usbcore: registered new interface driver auerswald
initcall auerswald_init+0x0/0x40 returned 0 after 7 msecs
calling  emi26_init+0x0/0x20
bus: 'usb': add driver emi26 - firmware loader
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x20 returned 0 after 9 msecs
calling  iowarrior_init+0x0/0x20
bus: 'usb': add driver iowarrior
usbcore: registered new interface driver iowarrior
initcall iowarrior_init+0x0/0x20 returned 0 after 7 msecs
calling  isight_firmware_init+0x0/0x20
bus: 'usb': add driver isight_firmware
usbcore: registered new interface driver isight_firmware
initcall isight_firmware_init+0x0/0x20 returned 0 after 8 msecs
calling  ld_usb_init+0x0/0x50
bus: 'usb': add driver ldusb
usbcore: registered new interface driver ldusb
initcall ld_usb_init+0x0/0x50 returned 0 after 6 msecs
calling  i8042_init+0x0/0x430
bus: 'pnp': add driver i8042 kbd
bus: 'pnp': driver_probe_device: matched device 00:0a with driver i8042 kbd
bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:0a
driver: '00:0a': driver_bound: bound to device 'i8042 kbd'
bus: 'pnp': really_probe: bound device 00:0a to driver i8042 kbd
bus: 'pnp': add driver i8042 aux
bus: 'pnp': driver_probe_device: matched device 00:09 with driver i8042 aux
bus: 'pnp': really_probe: probing driver i8042 aux with device 00:09
driver: '00:09': driver_bound: bound to device 'i8042 aux'
bus: 'pnp': really_probe: bound device 00:09 to driver i8042 aux
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
bus: 'platform': add driver i8042
Registering platform device 'i8042'. Parent at platform
device: 'i8042': device_add
bus: 'platform': add device i8042
PM: Adding info for platform:i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
driver: 'i8042': driver_bound: bound to device 'i8042'
bus: 'platform': really_probe: bound device i8042 to driver i8042
initcall i8042_init+0x0/0x430 returned 0 after 106 msecs
calling  fm801_gp_init+0x0/0x20
bus: 'pci': add driver FM801_gameport
device: 'serio0': device_add
bus: 'serio': add device serio0
PM: Adding info for serio:serio0
device: 'serio1': device_add
bus: 'serio': add device serio1
PM: Adding info for serio:serio1
initcall fm801_gp_init+0x0/0x20 returned 0 after 19 msecs
calling  l4_init+0x0/0x2b0
initcall l4_init+0x0/0x2b0 returned -19 after 0 msecs
calling  ns558_init+0x0/0x340
bus: 'pnp': add driver ns558
initcall ns558_init+0x0/0x340 returned 0 after 13 msecs
calling  mousedev_init+0x0/0xb0
device: 'mice': device_add
PM: Adding info for No Bus:mice
device: 'mouse0': device_add
PM: Adding info for No Bus:mouse0
device: 'psaux': device_add
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0xb0 returned 0 after 23 msecs
calling  joydev_init+0x0/0x20
initcall joydev_init+0x0/0x20 returned 0 after 0 msecs
calling  atkbd_init+0x0/0x30
bus: 'serio': add driver atkbd
initcall atkbd_init+0x0/0x30 returned 0 after 2 msecs
calling  sunkbd_init+0x0/0x20
bus: 'serio': add driver sunkbd
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio0
initcall sunkbd_init+0x0/0x20 returned 0 after 15 msecs
calling  xtkbd_init+0x0/0x20
bus: 'serio': add driver xtkbd
device: 'input1': device_add
PM: Adding info for No Bus:input1
input: AT Translated Set 2 keyboard as /class/input/input1
driver: 'serio0': driver_bound: bound to device 'atkbd'
bus: 'serio': really_probe: bound device serio0 to driver atkbd
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
initcall xtkbd_init+0x0/0x20 returned 0 after 59 msecs
calling  gf2k_init+0x0/0x20
initcall gf2k_init+0x0/0x20 returned 0 after 0 msecs
calling  interact_init+0x0/0x20
initcall interact_init+0x0/0x20 returned 0 after 0 msecs
calling  sw_init+0x0/0x20
initcall sw_init+0x0/0x20 returned 0 after 0 msecs
calling  tmdc_init+0x0/0x20
initcall tmdc_init+0x0/0x20 returned 0 after 0 msecs
calling  usb_xpad_init+0x0/0x40
bus: 'usb': add driver xpad
bus: 'gameport': add driver gf2k
bus: 'gameport': add driver interact
bus: 'gameport': add driver sidewinder
bus: 'gameport': add driver tmdc
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x40 returned 0 after 21 msecs
calling  zhenhua_init+0x0/0x20
bus: 'serio': add driver zhenhua
initcall zhenhua_init+0x0/0x20 returned 0 after 2 msecs
calling  gunze_init+0x0/0x20
bus: 'serio': add driver gunze
initcall gunze_init+0x0/0x20 returned 0 after 2 msecs
calling  inexio_init+0x0/0x20
bus: 'serio': add driver inexio
initcall inexio_init+0x0/0x20 returned 0 after 2 msecs
calling  mk712_init+0x0/0x1f0
mk712: device not present
initcall mk712_init+0x0/0x1f0 returned -19 after 2 msecs
calling  ucb1400_ts_init+0x0/0x20
bus: 'ac97': add driver ucb1400_ts
initcall ucb1400_ts_init+0x0/0x20 returned 0 after 3 msecs
calling  w1_init+0x0/0x110
Driver for 1-wire Dallas network protocol.
bus: 'w1': registered
bus: 'w1': add driver w1_master_driver
bus: 'w1': add driver w1_slave_driver
initcall w1_init+0x0/0x110 returned 0 after 12 msecs
calling  w1_therm_init+0x0/0x40
initcall w1_therm_init+0x0/0x40 returned 0 after 0 msecs
calling  pda_power_init+0x0/0x20
bus: 'platform': add driver pda-power
initcall pda_power_init+0x0/0x20 returned 0 after 3 msecs
calling  acq_init+0x0/0x70
WDT driver for Acquire single board computer initialising.
bus: 'platform': add driver acquirewdt
Registering platform device 'acquirewdt'. Parent at platform
device: 'acquirewdt': device_add
bus: 'platform': add device acquirewdt
PM: Adding info for platform:acquirewdt
bus: 'platform': driver_probe_device: matched device acquirewdt with driver acquirewdt
bus: 'platform': really_probe: probing driver acquirewdt with device acquirewdt
acquirewdt: I/O address 0x0043 already in use
acquirewdt: probe of acquirewdt failed with error -5
initcall acq_init+0x0/0x70 returned 0 after 45 msecs
calling  ibmasr_init+0x0/0x270
initcall ibmasr_init+0x0/0x270 returned -19 after 0 msecs
calling  iTCO_wdt_init_module+0x0/0x80
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
bus: 'platform': add driver iTCO_wdt
Registering platform device 'iTCO_wdt'. Parent at platform
device: 'iTCO_wdt': device_add
bus: 'platform': add device iTCO_wdt
PM: Adding info for platform:iTCO_wdt
bus: 'platform': driver_probe_device: matched device iTCO_wdt with driver iTCO_wdt
bus: 'platform': really_probe: probing driver iTCO_wdt with device iTCO_wdt
iTCO_wdt: No card detected
initcall iTCO_wdt_init_module+0x0/0x80 returned 0 after 38 msecs
calling  iTCO_vendor_init_module+0x0/0x30
iTCO_vendor_support: vendor-support=0
initcall iTCO_vendor_init_module+0x0/0x30 returned 0 after 3 msecs
calling  sbc60xxwdt_init+0x0/0x1b0
device: 'watchdog': device_add
PM: Adding info for No Bus:watchdog
sbc60xxwdt: WDT driver for 60XX single board computer initialised. timeout=30 sec (nowayout=0)
initcall sbc60xxwdt_init+0x0/0x1b0 returned 0 after 13 msecs
calling  sbc8360_init+0x0/0x1f0
sbc8360: failed to register misc device
initcall sbc8360_init+0x0/0x1f0 returned -16 after 3 msecs
initcall sbc8360_init+0x0/0x1f0 returned with error code -16 
calling  wdt_init+0x0/0x220
w83697hf/hg WDT: WDT driver for W83697HF/HG initializing
w83697hf/hg WDT: Looking for watchdog at address 0x2e
w83697hf/hg WDT: watchdog not found at address 0x2e
w83697hf/hg WDT: No W83697HF/HG could be found
initcall wdt_init+0x0/0x220 returned -5 after 17 msecs
initcall wdt_init+0x0/0x220 returned with error code -5 
calling  w83977f_wdt_init+0x0/0x140
W83977F WDT: W83977F WDT driver, v1.00
W83977F WDT: cannot register miscdev on minor=130 (err=-16)
initcall w83977f_wdt_init+0x0/0x140 returned -16 after 8 msecs
initcall w83977f_wdt_init+0x0/0x140 returned with error code -16 
calling  watchdog_init+0x0/0xd0
epx_c3: cannot register miscdev on minor=130 (err=-16)
initcall watchdog_init+0x0/0xd0 returned -16 after 4 msecs
initcall watchdog_init+0x0/0xd0 returned with error code -16 
calling  telephony_init+0x0/0x60
Linux telephony interface: v1.00
initcall telephony_init+0x0/0x60 returned 0 after 2 msecs
calling  init_ladder+0x0/0x20
cpuidle: using governor ladder
initcall init_ladder+0x0/0x20 returned 0 after 2 msecs
calling  init_menu+0x0/0x20
cpuidle: using governor menu
initcall init_menu+0x0/0x20 returned 0 after 2 msecs
calling  mmc_test_init+0x0/0x20
bus: 'mmc': add driver mmc_test
initcall mmc_test_init+0x0/0x20 returned 0 after 2 msecs
calling  tifm_sd_init+0x0/0x20
bus: 'tifm': add driver tifm_sd
initcall tifm_sd_init+0x0/0x20 returned 0 after 2 msecs
calling  memstick_init+0x0/0xa0
bus: 'memstick': registered
device class 'memstick_host': registering
initcall memstick_init+0x0/0xa0 returned 0 after 6 msecs
calling  jmb38x_ms_init+0x0/0x20
bus: 'pci': add driver jmb38x_ms
initcall jmb38x_ms_init+0x0/0x20 returned 0 after 2 msecs
calling  efivars_init+0x0/0x210
initcall efivars_init+0x0/0x210 returned -19 after 0 msecs
calling  virtio_pci_init+0x0/0x60
device: 'virtio-pci': device_add
PM: Adding info for No Bus:virtio-pci
bus: 'pci': add driver virtio-pci
initcall virtio_pci_init+0x0/0x60 returned 0 after 9 msecs
calling  oprofile_init+0x0/0x60
Registering sysdev class 'oprofile'
Registering sys device of class 'oprofile'
Registering sys device 'oprofile0'
oprofile: using NMI interrupt.
initcall oprofile_init+0x0/0x60 returned 0 after 12 msecs
calling  sysctl_core_init+0x0/0x30
initcall sysctl_core_init+0x0/0x30 returned 0 after 0 msecs
calling  flow_cache_init+0x0/0x140
initcall flow_cache_init+0x0/0x140 returned 0 after 0 msecs
calling  pg_init+0x0/0x2c0
pktgen v2.69: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x2c0 returned 0 after 5 msecs
calling  llc_init+0x0/0x30
initcall llc_init+0x0/0x30 returned 0 after 0 msecs
calling  llc2_init+0x0/0xe0
NET: Registered protocol family 26
initcall llc2_init+0x0/0xe0 returned 0 after 3 msecs
calling  snap_init+0x0/0x40
initcall snap_init+0x0/0x40 returned 0 after 0 msecs
calling  sysctl_ipv4_init+0x0/0x60
initcall sysctl_ipv4_init+0x0/0x60 returned 0 after 0 msecs
calling  ipip_init+0x0/0x80
IPv4 over IPv4 tunneling driver
device: 'tunl0': device_add
PM: Adding info for No Bus:tunl0
initcall ipip_init+0x0/0x80 returned 0 after 8 msecs
calling  init_syncookies+0x0/0x20
initcall init_syncookies+0x0/0x20 returned 0 after 0 msecs
calling  tunnel4_init+0x0/0x80
initcall tunnel4_init+0x0/0x80 returned 0 after 0 msecs
calling  xfrm4_transport_init+0x0/0x20
initcall xfrm4_transport_init+0x0/0x20 returned 0 after 0 msecs
calling  inet_diag_init+0x0/0x70
initcall inet_diag_init+0x0/0x70 returned 0 after 0 msecs
calling  tcp_diag_init+0x0/0x20
initcall tcp_diag_init+0x0/0x20 returned 0 after 0 msecs
calling  cubictcp_register+0x0/0x80
TCP cubic registered
initcall cubictcp_register+0x0/0x80 returned 0 after 1 msecs
calling  xfrm_user_init+0x0/0x60
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x60 returned 0 after 2 msecs
calling  packet_init+0x0/0x50
NET: Registered protocol family 17
initcall packet_init+0x0/0x50 returned 0 after 3 msecs
calling  br_init+0x0/0xc0
initcall br_init+0x0/0xc0 returned 0 after 0 msecs
calling  x25_init+0x0/0x70
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x70 returned 0 after 5 msecs
calling  lapb_init+0x0/0x10
initcall lapb_init+0x0/0x10 returned 0 after 0 msecs
calling  can_init+0x0/0x120
can: controller area network core (rev 20071116 abi 8)
NET: Registered protocol family 29
initcall can_init+0x0/0x120 returned 0 after 7 msecs
calling  af_rxrpc_init+0x0/0x1d0
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x1d0 returned 0 after 3 msecs
calling  ieee80211_init+0x0/0x30
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
initcall ieee80211_init+0x0/0x30 returned 0 after 11 msecs
calling  ieee80211_crypto_init+0x0/0x20
ieee80211_crypt: registered algorithm 'NULL'
initcall ieee80211_crypto_init+0x0/0x20 returned 0 after 3 msecs
calling  ieee80211_crypto_wep_init+0x0/0x20
ieee80211_crypt: registered algorithm 'WEP'
initcall ieee80211_crypto_wep_init+0x0/0x20 returned 0 after 3 msecs
calling  ieee80211_crypto_tkip_init+0x0/0x20
ieee80211_crypt: registered algorithm 'TKIP'
initcall ieee80211_crypto_tkip_init+0x0/0x20 returned 0 after 3 msecs
calling  init_p9+0x0/0x30
Installing 9P2000 support
initcall init_p9+0x0/0x30 returned 0 after 2 msecs
calling  p9_virtio_init+0x0/0x30
bus: 'virtio': add driver 9pnet_virtio
initcall p9_virtio_init+0x0/0x30 returned 0 after 3 msecs
calling  hpet_insert_resource+0x0/0x30
initcall hpet_insert_resource+0x0/0x30 returned 0 after 0 msecs
calling  update_mp_table+0x0/0x520
initcall update_mp_table+0x0/0x520 returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x50
initcall lapic_insert_resource+0x0/0x50 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x40
initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 msecs
calling  ioapic_insert_resources+0x0/0x70
initcall ioapic_insert_resources+0x0/0x70 returned 0 after 0 msecs
calling  check_early_ioremap_leak+0x0/0x50
initcall check_early_ioremap_leak+0x0/0x50 returned 0 after 0 msecs
calling  pat_memtype_list_init+0x0/0x30
initcall pat_memtype_list_init+0x0/0x30 returned 0 after 0 msecs
calling  sched_init_debug+0x0/0x30
initcall sched_init_debug+0x0/0x30 returned 0 after 0 msecs
calling  init_oops_id+0x0/0x30
initcall init_oops_id+0x0/0x30 returned 0 after 0 msecs
calling  disable_boot_consoles+0x0/0x40
initcall disable_boot_consoles+0x0/0x40 returned 0 after 0 msecs
calling  pm_qos_power_init+0x0/0xa0
device: 'cpu_dma_latency': device_add
PM: Adding info for No Bus:cpu_dma_latency
device: 'network_latency': device_add
PM: Adding info for No Bus:network_latency
device: 'network_throughput': device_add
PM: Adding info for No Bus:network_throughput
initcall pm_qos_power_init+0x0/0xa0 returned 0 after 21 msecs
calling  taskstats_init+0x0/0xb0
registered taskstats version 1
initcall taskstats_init+0x0/0xb0 returned 0 after 2 msecs
calling  fail_make_request_debugfs+0x0/0x10
initcall fail_make_request_debugfs+0x0/0x10 returned -19 after 0 msecs
calling  random32_reseed+0x0/0x30
initcall random32_reseed+0x0/0x30 returned 0 after 0 msecs
calling  pci_sysfs_init+0x0/0x60
initcall pci_sysfs_init+0x0/0x60 returned 0 after 0 msecs
calling  acpi_wakeup_device_init+0x0/0xb6
initcall acpi_wakeup_device_init+0x0/0xb6 returned 0 after 0 msecs
calling  acpi_sleep_proc_init+0x0/0x83
initcall acpi_sleep_proc_init+0x0/0x83 returned 0 after 0 msecs
calling  seqgen_init+0x0/0x20
initcall seqgen_init+0x0/0x20 returned 0 after 0 msecs
calling  scsi_complete_async_scans+0x0/0x110
initcall scsi_complete_async_scans+0x0/0x110 returned 0 after 0 msecs
calling  memmap_init+0x0/0xb0
initcall memmap_init+0x0/0xb0 returned 0 after 0 msecs
calling  pci_mmcfg_late_insert_resources+0x0/0x50
initcall pci_mmcfg_late_insert_resources+0x0/0x50 returned 0 after 0 msecs
calling  tcp_congestion_default+0x0/0x20
initcall tcp_congestion_default+0x0/0x20 returned 0 after 0 msecs
driver_probe_done: probe_count = 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory ffffffff80b02000..ffffffff80b6b000
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'device:00': dev_uevent: bus uevent() returned -12
device: 'device:01': dev_uevent: bus uevent() returned -12
device: 'device:02': dev_uevent: bus uevent() returned -12
device: 'device:03': dev_uevent: bus uevent() returned -12
device: 'device:04': dev_uevent: bus uevent() returned -12
device: 'device:05': dev_uevent: bus uevent() returned -12
device: 'device:06': dev_uevent: bus uevent() returned -12
device: 'device:07': dev_uevent: bus uevent() returned -12
device: 'device:08': dev_uevent: bus uevent() returned -12
device: 'device:09': dev_uevent: bus uevent() returned -12
device: 'device:0a': dev_uevent: bus uevent() returned -12
device: 'device:0b': dev_uevent: bus uevent() returned -12
device: 'device:0c': dev_uevent: bus uevent() returned -12
device: 'device:0d': dev_uevent: bus uevent() returned -12
device: 'device:0e': dev_uevent: bus uevent() returned -12
device: 'device:0f': dev_uevent: bus uevent() returned -12
device: 'device:10': dev_uevent: bus uevent() returned -12
device: 'device:11': dev_uevent: bus uevent() returned -12
device: 'device:12': dev_uevent: bus uevent() returned -12
device: 'device:13': dev_uevent: bus uevent() returned -12
device: 'device:14': dev_uevent: bus uevent() returned -12
device: 'device:15': dev_uevent: bus uevent() returned -12
device: 'device:16': dev_uevent: bus uevent() returned -12
device: 'device:17': dev_uevent: bus uevent() returned -12
device: 'device:18': dev_uevent: bus uevent() returned -12
device: 'device:19': dev_uevent: bus uevent() returned -12
device: 'device:1a': dev_uevent: bus uevent() returned -12
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
device: 'vcs5': device_add
PM: Adding info for No Bus:vcs5
device: 'vcsa5': device_add
PM: Adding info for No Bus:vcsa5
device: 'vcs6': device_add
PM: Adding info for No Bus:vcs6
device: 'vcsa6': device_add
PM: Adding info for No Bus:vcsa6
device: 'vcs4': device_add
PM: Adding info for No Bus:vcs4
device: 'vcsa4': device_add
PM: Adding info for No Bus:vcsa4
device: 'vcs7': device_add
PM: Adding info for No Bus:vcs7
device: 'vcsa7': device_add
PM: Adding info for No Bus:vcsa7
device: 'vcs8': device_add
PM: Adding info for No Bus:vcs8
device: 'vcsa8': device_add
PM: Adding info for No Bus:vcsa8
device: 'vcs3': device_add
PM: Adding info for No Bus:vcs3
device: 'vcsa3': device_add
PM: Adding info for No Bus:vcsa3
device: 'vcs9': device_add
PM: Adding info for No Bus:vcs9
device: 'vcsa9': device_add
PM: Adding info for No Bus:vcsa9
device: 'vcs10': device_add
PM: Adding info for No Bus:vcs10
device: 'vcsa10': device_add
PM: Adding info for No Bus:vcsa10
device: 'vcs5': device_unregister
PM: Removing info for No Bus:vcs5
device: 'vcs5': device_create_release
device: 'vcsa5': device_unregister
PM: Removing info for No Bus:vcsa5
device: 'vcsa5': device_create_release
device: 'vcs2': device_add
PM: Adding info for No Bus:vcs2
device: 'vcsa2': device_add
PM: Adding info for No Bus:vcsa2
device: 'vcs11': device_add
PM: Adding info for No Bus:vcs11
device: 'vcsa11': device_add
PM: Adding info for No Bus:vcsa11
device: 'vcs6': device_unregister
PM: Removing info for No Bus:vcs6
device: 'vcs6': device_create_release
device: 'vcsa6': device_unregister
PM: Removing info for No Bus:vcsa6
device: 'vcsa6': device_create_release
device: 'vcs4': device_unregister
PM: Removing info for No Bus:vcs4
device: 'vcs4': device_create_release
device: 'vcsa4': device_unregister
PM: Removing info for No Bus:vcsa4
device: 'vcsa4': device_create_release
device: 'vcs7': device_unregister
PM: Removing info for No Bus:vcs7
device: 'vcs7': device_create_release
device: 'vcsa7': device_unregister
PM: Removing info for No Bus:vcsa7
device: 'vcsa7': device_create_release
device: 'vcs8': device_unregister
PM: Removing info for No Bus:vcs8
device: 'vcs8': device_create_release
device: 'vcsa8': device_unregister
PM: Removing info for No Bus:vcsa8
device: 'vcsa8': device_create_release
device: 'vcs9': device_unregister
PM: Removing info for No Bus:vcs9
device: 'vcs9': device_create_release
device: 'vcsa9': device_unregister
PM: Removing info for No Bus:vcsa9
device: 'vcsa9': device_create_release
device: 'vcs3': device_unregister
PM: Removing info for No Bus:vcs3
device: 'vcs3': device_create_release
device: 'vcsa3': device_unregister
PM: Removing info for No Bus:vcsa3
device: 'vcsa3': device_create_release
device: 'vcs10': device_unregister
PM: Removing info for No Bus:vcs10
device: 'vcs10': device_create_release
device: 'vcsa10': device_unregister
PM: Removing info for No Bus:vcsa10
device: 'vcsa10': device_create_release
device: 'vcs2': device_unregister
PM: Removing info for No Bus:vcs2
device: 'vcs2': device_create_release
device: 'vcsa2': device_unregister
PM: Removing info for No Bus:vcsa2
device: 'vcsa2': device_create_release
device: 'vcs11': device_unregister
PM: Removing info for No Bus:vcs11
device: 'vcs11': device_create_release
device: 'vcsa11': device_unregister
PM: Removing info for No Bus:vcsa11
device: 'vcsa11': device_create_release
device: 'vcs5': device_add
PM: Adding info for No Bus:vcs5
device: 'vcsa5': device_add
PM: Adding info for No Bus:vcsa5
device: 'vcs6': device_add
PM: Adding info for No Bus:vcs6
device: 'vcsa6': device_add
PM: Adding info for No Bus:vcsa6
device: 'vcs7': device_add
PM: Adding info for No Bus:vcs7
device: 'vcsa7': device_add
PM: Adding info for No Bus:vcsa7
device: 'vcs8': device_add
PM: Adding info for No Bus:vcs8
device: 'vcsa8': device_add
PM: Adding info for No Bus:vcsa8
device: 'vcs4': device_add
PM: Adding info for No Bus:vcs4
device: 'vcsa4': device_add
PM: Adding info for No Bus:vcsa4
device: 'vcs9': device_add
PM: Adding info for No Bus:vcs9
device: 'vcsa9': device_add
PM: Adding info for No Bus:vcsa9
device: 'vcs3': device_add
PM: Adding info for No Bus:vcs3
device: 'vcsa3': device_add
PM: Adding info for No Bus:vcsa3
device: 'vcs2': device_add
PM: Adding info for No Bus:vcs2
device: 'vcsa2': device_add
PM: Adding info for No Bus:vcsa2
device: 'vcs11': device_add
PM: Adding info for No Bus:vcs11
device: 'vcsa11': device_add
PM: Adding info for No Bus:vcsa11
device: 'vcs10': device_add
PM: Adding info for No Bus:vcs10
device: 'vcsa10': device_add
