Return-Path: <linux-kernel-owner+w=401wt.eu-S1759305AbZFKEqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbZFKEqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 00:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZFKEq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 00:46:26 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:34997 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZFKEqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 00:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GwjTIZCo6jfZ7g0qdHStTxdaC2pRUga9jqtuJqoKqndhM5kvXxQxiehELakLC7v8qx
         GVcitXMUHQRaqZ4W/IPBGc1nHvpeHK26SvUuGd66HaLverbFg5SWHP12cldm9vibMTu3
         uLnIHxSifEywWbErqpsmYCDraOPG3eMML1EyU=
MIME-Version: 1.0
In-Reply-To: <20090609152302.GA22784@Krystal>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	 <D9VoutSOyXP.A.7vF.2Y7KKB@chimera>
	 <84144f020906070621r1f480eaeief026d23662df380@mail.gmail.com>
	 <a8e1da0906080035j9f8b38drb46132de5a515915@mail.gmail.com>
	 <1244447366.13471.4.camel@penberg-laptop>
	 <20090608124844.GA17588@Krystal> <20090608143220.GC2516@redhat.com>
	 <20090608152316.GA21033@Krystal>
	 <a8e1da0906081815q68ea7741v3568d6cad5f72bb8@mail.gmail.com>
	 <20090609152302.GA22784@Krystal>
Date: Thu, 11 Jun 2009 12:46:20 +0800
Message-ID: <a8e1da0906102146h3546406fp8177450af5e126dc@mail.gmail.com>
Subject: Re: [PATCH] remove rwsem lock from CPUFREQ_GOV_STOP call (second call 
	site)
From: Dave Young <hidave.darkstar@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Dave Jones <davej@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       cpufreq@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       trenn@suse.de, sven.wegener@stealer.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, mingo@elte.hu,
       Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 11:23 PM, Mathieu
Desnoyers<mathieu.desnoyers@polymtl.ca> wrote:
> * Dave Young (hidave.darkstar@gmail.com) wrote:
>> On Mon, Jun 8, 2009 at 11:23 PM, Mathieu
>> Desnoyers<mathieu.desnoyers@polymtl.ca> wrote:
>> > * Dave Jones (davej@redhat.com) wrote:
>> >> On Mon, Jun 08, 2009 at 08:48:45AM -0400, Mathieu Desnoyers wrote:
>> >>
>> >>  > > > >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13475
>> >>  > > > >> Subject         : suspend/hibernate lockdep warning
>> >>  > > > >> References      : http://marc.info/?l=linux-kernel&m=124393723321241&w=4
>> >>  > > >
>> >>  > > > I suspect the following commit, after revert this patch I test 5 times
>> >>  > > > without lockdep warnings.
>> >>  > > >
>> >>  > > > commit b14893a62c73af0eca414cfed505b8c09efc613c
>> >>  > > > Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> >>  > > > Date:   Sun May 17 10:30:45 2009 -0400
>> >>  > > >
>> >>  > > >        [CPUFREQ] fix timer teardown in ondemand governor
>> >>  > >
>> >>  > > The patch is probably not at fault here. I suspect it's some latent bug
>> >>  > > that simply got exposed by the change to cancel_delayed_work_sync(). In
>> >>  > > any case, Mathieu, can you take a look at this please?
>> >>  >
>> >>  > Yes, it's been looked at and discussed on the cpufreq ML. The short
>> >>  > answer is that they plan to re-engineer cpufreq and remove the policy
>> >>  > rwlock taken around almost every operations at the cpufreq level.
>> >>  >
>> >>  > The short-term solution, which is recognised as ugly, would be do to the
>> >>  > following before doing the cancel_delayed_work_sync() :
>> >>  >
>> >>  > unlock policy rwlock write lock
>> >>  >
>> >>  > lock policy rwlock write lock
>> >>  >
>> >>  > It basically works because this rwlock is unneeded for teardown, hence
>> >>  > the future re-work planned.
>> >>  >
>> >>  > I'm sorry I cannot prepare a patch current... I've got quite a few pages
>> >>  > of Ph.D. thesis due for the beginning of July.
>> >>
>> >> I'm kinda scared to touch this code at all for .30 due to the number of
>> >> unexpected gotchas we seem to run into every time we touch something
>> >> locking related.  So I'm inclined to just live with the lockdep warning
>> >> for .30, and see how the real fixes look for .31, and push them back
>> >> as -stable updates if they work out.
>> >>
>> >>
>> >> Venki, what are your thoughts?
>> >>
>> >
>> > Hi Dave,
>> >
>> > I've looked through the cpufreq code, and the following patch should
>> > address the call site I've missed in commit
>> > 42a06f2166f2f6f7bf04f32b4e823eacdceafdc9. I've followed all
>> > __cpufreq_set_policy call sites within cpufreq.c to make sure they all
>> > hold the rwsem write lock. An extra round of review would be good
>> > though.
>> >
>> > Can someone try the following patch and see if it fixes the regression ?
>>
>> Bad news, I have tried the patch and It does not fix the regression.
>>
>
> Can you provide the lockdep error message you get with the patch
> applied?

Please see the dmesg dump:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc8-00073-g3af968e-dirty
(dave@darkstar) (gcc version 4.2.4) #61 SMP Wed Jun 10 10:23:04 CST
2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003d38d400 (usable)
[    0.000000]  BIOS-e820: 000000003d38d400 - 000000003d38f400 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003d38f400 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3d38d max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 03DC00000 mask FFFC00000 uncachable
[    0.000000]   3 base 03E000000 mask FFE000000 uncachable
[    0.000000]   4 base 03DB00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 000000003db00000 - 0000000040000000
(usable) ==> (reserved)
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000fbd10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 3d391e00 0006C (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: FACP 3d391c9c 000F4 (v04 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: DSDT 3d392400 06357 (v02 INT430 SYSFexxx 00001001
INTL 20050624)
[    0.000000] ACPI: FACS 3d3a0c00 00040
[    0.000000] ACPI: HPET 3d391f00 00038 (v01 DELL    M09     00000001
ASL  00000061)
[    0.000000] ACPI: DMAR 3d3a0400 000F8 (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: APIC 3d392000 00068 (v01 DELL    M09     27D90219
ASL  00000047)
[    0.000000] ACPI: ASF! 3d391c00 00076 (v32 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: MCFG 3d391fc0 0003E (v16 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: TCPA 3d392300 00032 (v01                 00000000
ASL  00000000)
[    0.000000] ACPI: BOOT 3d391bc0 00028 (v01 DELL    M09     27D90219
ASL  00000061)
[    0.000000] ACPI: SSDT 3d3902eb 0066C (v01  PmRef    CpuPm 00003000
INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 91MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001b09e54]    TEXT DATA BSS ==>
[0001000000 - 0001b09e54]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [0001b0a000 - 0001b1217c]              BRK ==>
[0001b0a000 - 0001b1217c]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003d38d
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003d38d
[    0.000000] On node 0 totalpages: 250668
[    0.000000] free_area_init_node: node 0, pgdat c154ac80,
node_mem_map c1b13000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 184 pages used for memmap
[    0.000000]   HighMem zone: 23255 pages, LIFO batch:3
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b8000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c22c6000, static data 25052 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 248708
[    0.000000] Kernel command line: BOOT_IMAGE=dirty ro root=802
vt.default_utf8=0 resume=/dev/sda1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1995.186 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.003333] ... MAX_LOCKDEP_CHAINS:      32768
[    0.003333] ... CHAINHASH_SIZE:          16384
[    0.003333]  memory used by lock dependency info: 3487 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Initializing HighMem for node 0 (000377fe:0003d38d)
[    0.003333] Memory: 982232k/1003060k available (3378k kernel code,
20148k reserved, 2152k data, 352k init, 93756k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.003333]       .init : 0xc156d000 - 0xc15c5000   ( 352 kB)
[    0.003333]       .data : 0xc134c8a5 - 0xc1566974   (2152 kB)
[    0.003333]       .text : 0xc1000000 - 0xc134c8a5   (3378 kB)
[    0.003333] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated
using timer frequency.. 3991.63 BogoMIPS (lpj=6650620)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] using mwait in idle threads.
[    0.003333] Checking 'hlt' instruction... OK.
[    0.014575] ACPI: Core revision 20090320
[    0.030585] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.064121] CPU0: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.066666] lockdep: fixing up alternatives.
[    0.066666] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine..
3991.23 BogoMIPS (lpj=6649981)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.158284] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[    0.158328] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.160064] Brought up 2 CPUs
[    0.160070] Total of 2 processors activated (7983.87 BogoMIPS).
[    0.160416] khelper used greatest stack depth: 6832 bytes left
[    0.160487] net_namespace: 636 bytes
[    0.160487] Booting paravirtualized kernel on bare hardware
[    0.163499] regulator: core version 0.5
[    0.163499] Time: 13:52:52  Date: 06/10/09
[    0.163546] NET: Registered protocol family 16
[    0.163628] ACPI: bus type pci registered
[    0.163628] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.163628] PCI: MCFG area at f8000000 reserved in E820
[    0.163628] PCI: Using MMCONFIG for extended config space
[    0.163628] PCI: Using configuration type 1 for base access
[    0.176761] bio: create slab <bio-0> at 0
[    0.184114] ACPI: EC: Look up EC in DSDT
[    0.184462] ACPI: BIOS _OSI(Linux) query ignored
[    0.224002] ACPI: SSDT 3d3a0c80 00043 (v01  LMPWR  DELLLOM 00001001
INTL 20050624)
[    0.253401] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.270327] ACPI: Interpreter enabled
[    0.270336] ACPI: (supports S0 S3 S4 S5)
[    0.270399] ACPI: Using IOAPIC for interrupt routing
[    0.380756] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
[    0.380756] ACPI: EC: driver started in interrupt mode
[    0.385239] ACPI: No dock devices found.
[    0.385270] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.385374] pci 0000:00:02.0: reg 10 64bit mmio: [0xf6c00000-0xf6ffffff]
[    0.385374] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.385374] pci 0000:00:02.0: reg 20 io port: [0xefe8-0xefef]
[    0.385374] pci 0000:00:02.1: reg 10 64bit mmio: [0xf6b00000-0xf6bfffff]
[    0.385374] pci 0000:00:1a.0: reg 20 io port: [0x6f60-0x6f7f]
[    0.385374] pci 0000:00:1a.1: reg 20 io port: [0x6f80-0x6f9f]
[    0.385374] pci 0000:00:1a.2: reg 20 io port: [0x6fa0-0x6fbf]
[    0.386670] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfed1c400-0xfed1c7ff]
[    0.386778] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.386790] pci 0000:00:1a.7: PME# disabled
[    0.386883] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf6afc000-0xf6afffff]
[    0.386976] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.386987] pci 0000:00:1b.0: PME# disabled
[    0.387119] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.387130] pci 0000:00:1c.0: PME# disabled
[    0.387266] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.387277] pci 0000:00:1c.1: PME# disabled
[    0.387417] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.387428] pci 0000:00:1c.4: PME# disabled
[    0.387547] pci 0000:00:1d.0: reg 20 io port: [0x6f00-0x6f1f]
[    0.387692] pci 0000:00:1d.1: reg 20 io port: [0x6f20-0x6f3f]
[    0.387836] pci 0000:00:1d.2: reg 20 io port: [0x6f40-0x6f5f]
[    0.387983] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfed1c000-0xfed1c3ff]
[    0.388089] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.388100] pci 0000:00:1d.7: PME# disabled
[    0.388481] pci 0000:00:1f.2: reg 10 io port: [0x6e70-0x6e77]
[    0.388493] pci 0000:00:1f.2: reg 14 io port: [0x6e78-0x6e7b]
[    0.388504] pci 0000:00:1f.2: reg 18 io port: [0x6e80-0x6e87]
[    0.388516] pci 0000:00:1f.2: reg 1c io port: [0x6e88-0x6e8b]
[    0.388528] pci 0000:00:1f.2: reg 20 io port: [0x6ea0-0x6ebf]
[    0.388540] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfed1c800-0xfed1cfff]
[    0.388613] pci 0000:00:1f.2: PME# supported from D3hot
[    0.388623] pci 0000:00:1f.2: PME# disabled
[    0.388688] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf6afbf00-0xf6afbfff]
[    0.388718] pci 0000:00:1f.3: reg 20 io port: [0x1100-0x111f]
[    0.389260] pci 0000:0c:00.0: reg 10 64bit mmio: [0xf69fc000-0xf69fffff]
[    0.389514] pci 0000:0c:00.0: supports D1 D2
[    0.389517] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    0.389535] pci 0000:0c:00.0: PME# disabled
[    0.389706] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6900000-0xf69fffff]
[    0.389875] pci 0000:09:00.0: reg 10 64bit mmio: [0xf68f0000-0xf68fffff]
[    0.390026] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.390038] pci 0000:09:00.0: PME# disabled
[    0.390158] pci 0000:00:1c.4: bridge 32bit mmio: [0xf6800000-0xf68fffff]
[    0.390235] pci 0000:02:01.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.390272] pci 0000:02:01.0: supports D1 D2
[    0.390274] pci 0000:02:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.390285] pci 0000:02:01.0: PME# disabled
[    0.390351] pci 0000:02:01.1: reg 10 32bit mmio: [0xf67ff800-0xf67fffff]
[    0.390440] pci 0000:02:01.1: supports D1 D2
[    0.390443] pci 0000:02:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.390454] pci 0000:02:01.1: PME# disabled
[    0.390522] pci 0000:02:01.2: reg 10 32bit mmio: [0xf67ff600-0xf67ff6ff]
[    0.390613] pci 0000:02:01.2: supports D1 D2
[    0.390616] pci 0000:02:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.390627] pci 0000:02:01.2: PME# disabled
[    0.390693] pci 0000:02:01.3: reg 10 32bit mmio: [0xf67ff700-0xf67ff7ff]
[    0.390783] pci 0000:02:01.3: supports D1 D2
[    0.390785] pci 0000:02:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.390796] pci 0000:02:01.3: PME# disabled
[    0.390906] pci 0000:00:1e.0: transparent bridge
[    0.390921] pci 0000:00:1e.0: bridge 32bit mmio: [0xf6700000-0xf67fffff]
[    0.391000] pci_bus 0000:00: on NUMA node 0
[    0.391010] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.391715] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.391969] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.392106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.392250] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.420761] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 *11)
[    0.420761] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
[    0.420761] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *3
[    0.423493] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 *10 11)
[    0.423722] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.423957] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.424192] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.424398] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11
12 14 15) *0, disabled.
[    0.424519] SCSI subsystem initialized
[    0.424519] libata version 3.00 loaded.
[    0.424519] usbcore: registered new interface driver usbfs
[    0.424519] usbcore: registered new interface driver hub
[    0.424519] usbcore: registered new device driver usb
[    0.426752] PCI: Using ACPI for IRQ routing
[    0.486723] cfg80211: Using static regulatory domain info
[    0.486723] cfg80211: Regulatory domain: US
[    0.486723] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    0.486730] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.486737] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486744] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486751] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486758] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.486766] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.486865] cfg80211: Calling CRDA for country: US
[    0.486975] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.486975] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.501757] Switched to high resolution mode on CPU 1
[    0.503336] Switched to high resolution mode on CPU 0
[    0.503359] pnp: PnP ACPI init
[    0.503393] ACPI: bus type pnp registered
[    0.583232] pnp: PnP ACPI: found 13 devices
[    0.583239] ACPI: ACPI bus type pnp unregistered
[    0.583264] system 00:05: ioport range 0xc80-0xcaf has been reserved
[    0.583273] system 00:05: ioport range 0xcc0-0xcff could not be reserved
[    0.583294] system 00:08: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.583312] system 00:09: ioport range 0xcb0-0xcbb has been reserved
[    0.583320] system 00:09: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.583346] system 00:0a: ioport range 0x900-0x92f has been reserved
[    0.583354] system 00:0a: ioport range 0x931-0x933 has been reserved
[    0.583362] system 00:0a: ioport range 0x935-0x97f has been reserved
[    0.583371] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.583379] system 00:0a: ioport range 0x1000-0x1005 has been reserved
[    0.583387] system 00:0a: ioport range 0x1008-0x100f has been reserved
[    0.583405] system 00:0b: ioport range 0xf400-0xf4fe has been reserved
[    0.583414] system 00:0b: ioport range 0x1006-0x1007 has been reserved
[    0.583423] system 00:0b: ioport range 0x100a-0x1059 could not be reserved
[    0.583431] system 00:0b: ioport range 0x1060-0x107f has been reserved
[    0.583439] system 00:0b: ioport range 0x1080-0x10bf has been reserved
[    0.583447] system 00:0b: ioport range 0x1100-0x111f has been reserved
[    0.583455] system 00:0b: ioport range 0x1010-0x102f has been reserved
[    0.583463] system 00:0b: ioport range 0x809-0x809 has been reserved
[    0.583482] system 00:0c: iomem range 0x0-0x9efff could not be reserved
[    0.583490] system 00:0c: iomem range 0x9f000-0x9ffff could not be reserved
[    0.583499] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.583508] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.583516] system 00:0c: iomem range 0x100000-0x3d38d3ff could not
be reserved
[    0.583526] system 00:0c: iomem range 0x3d38d400-0x3dafffff could
not be reserved
[    0.583535] system 00:0c: iomem range 0x3db00000-0x3dbfffff has been reserved
[    0.583544] system 00:0c: iomem range 0xffe80000-0xffffffff has been reserved
[    0.583553] system 00:0c: iomem range 0xffa00000-0xffb7ffff has been reserved
[    0.583561] system 00:0c: iomem range 0xfec00000-0xfec0ffff has been reserved
[    0.583569] system 00:0c: iomem range 0xfee00000-0xfee0ffff has been reserved
[    0.583578] system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.583586] system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.583595] system 00:0c: iomem range 0xfeda0000-0xfeda3fff has been reserved
[    0.583604] system 00:0c: iomem range 0xfeda4000-0xfeda4fff has been reserved
[    0.583612] system 00:0c: iomem range 0xfeda5000-0xfeda5fff has been reserved
[    0.583621] system 00:0c: iomem range 0xfeda6000-0xfeda6fff has been reserved
[    0.583630] system 00:0c: iomem range 0xfed1c800-0xfed1cfff has been reserved
[    0.583638] system 00:0c: iomem range 0xfed18000-0xfed1bfff has been reserved
[    0.583647] system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.619907] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
[    0.619914] pci 0000:00:1c.0:   IO window: disabled
[    0.619927] pci 0000:00:1c.0:   MEM window: disabled
[    0.619937] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.619952] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:0c
[    0.619958] pci 0000:00:1c.1:   IO window: disabled
[    0.619970] pci 0000:00:1c.1:   MEM window: 0xf6900000-0xf69fffff
[    0.619981] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.619995] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:09
[    0.620009] pci 0000:00:1c.4:   IO window: disabled
[    0.620021] pci 0000:00:1c.4:   MEM window: 0xf6800000-0xf68fffff
[    0.620032] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.620058] pci 0000:02:01.0: CardBus bridge, secondary bus 0000:03
[    0.620065] pci 0000:02:01.0:   IO window: 0x002000-0x0020ff
[    0.620075] pci 0000:02:01.0:   IO window: 0x002400-0x0024ff
[    0.620086] pci 0000:02:01.0:   PREFETCH window: 0x50000000-0x53ffffff
[    0.620098] pci 0000:02:01.0:   MEM window: 0x54000000-0x57ffffff
[    0.620109] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.620118] pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
[    0.620130] pci 0000:00:1e.0:   MEM window: 0xf6700000-0xf67fffff
[    0.620142] pci 0000:00:1e.0:   PREFETCH window:
0x00000050000000-0x00000053ffffff
[    0.620174] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.620187] pci 0000:00:1c.0: setting latency timer to 64
[    0.620203] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.620215] pci 0000:00:1c.1: setting latency timer to 64
[    0.620228] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.620240] pci 0000:00:1c.4: setting latency timer to 64
[    0.620252] pci 0000:00:1e.0: setting latency timer to 64
[    0.620270] pci 0000:02:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.620283] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.620286] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.620289] pci_bus 0000:0c: resource 1 mem: [0xf6900000-0xf69fffff]
[    0.620293] pci_bus 0000:09: resource 1 mem: [0xf6800000-0xf68fffff]
[    0.620296] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.620299] pci_bus 0000:02: resource 1 mem: [0xf6700000-0xf67fffff]
[    0.620302] pci_bus 0000:02: resource 2 pref mem [0x50000000-0x53ffffff]
[    0.620305] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.620308] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.620311] pci_bus 0000:03: resource 0 io:  [0x2000-0x20ff]
[    0.620314] pci_bus 0000:03: resource 1 io:  [0x2400-0x24ff]
[    0.620317] pci_bus 0000:03: resource 2 pref mem [0x50000000-0x53ffffff]
[    0.620321] pci_bus 0000:03: resource 3 mem: [0x54000000-0x57ffffff]
[    0.620402] NET: Registered protocol family 2
[    0.663526] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.664358] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.664808] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.673228] TCP: Hash tables configured (established 131072 bind 65536)
[    0.673258] TCP reno registered
[    0.680222] NET: Registered protocol family 1
[    0.680737] Simple Boot Flag at 0x79 set to 0x1
[    0.683287] Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.683870] audit: initializing netlink socket (disabled)
[    0.683910] type=2000 audit(1244641972.683:1): initialized
[    0.691604] highmem bounce pool size: 64 pages
[    0.691617] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.699044] VFS: Disk quotas dquot_6.5.2
[    0.699279] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.701249] msgmni has been set to 1735
[    0.702239] alg: No test for stdrng (krng)
[    0.702504] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.702529] io scheduler noop registered
[    0.702535] io scheduler anticipatory registered
[    0.702541] io scheduler deadline registered
[    0.702701] io scheduler cfq registered (default)
[    0.702724] pci 0000:00:02.0: Boot video device
[    0.703438] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.703467] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.703969] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.703997] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.704627] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.704654] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.705212] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.705990] ALI M7101 PMU not found.
[    0.706288] vesafb: framebuffer at 0xe0000000, mapped to
0xf8080000, using 3072k, total 32704k
[    0.706298] vesafb: mode is 1024x768x16, linelength=2048, pages=20
[    0.706304] vesafb: scrolling: redraw
[    0.706310] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.719349] Console: switching to colour frame buffer device 128x48
[    0.731754] fb0: VESA VGA frame buffer device
[    0.732444] ACPI: AC Adapter [AC] (on-line)
[    0.733001] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    0.735290] ACPI: Lid Switch [LID]
[    0.735777] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.735979] ACPI: Power Button [PBTN]
[    0.736251] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.736450] ACPI: Sleep Button [SBTN]
[    0.739007] ACPI: SSDT 3d390957 002C3 (v01  PmRef   BspIst 00003000
INTL 20050624)
[    0.740265] ACPI: SSDT 3d390df1 005C6 (v01  PmRef   BspCst 00003001
INTL 20050624)
[    0.742690] Monitor-Mwait will be used to enter C-1 state
[    0.742748] Monitor-Mwait will be used to enter C-2 state
[    0.742803] Monitor-Mwait will be used to enter C-3 state
[    0.742824] Marking TSC unstable due to TSC halts in idle
[    0.743212] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.743626] processor ACPI_CPU:00: registered as cooling_device0
[    0.743776] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.744662] ACPI: SSDT 3d390c1a 001D7 (v01  PmRef    ApIst 00003000
INTL 20050624)
[    0.745954] ACPI: SSDT 3d3913b7 0008D (v01  PmRef    ApCst 00003000
INTL 20050624)
[    0.747684] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.747950] processor ACPI_CPU:01: registered as cooling_device1
[    0.748103] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.779251] thermal LNXTHERM:01: registered as thermal_zone0
[    0.779407] ACPI: Thermal Zone [THM] (40 C)
[    0.789324] Non-volatile memory driver v1.3
[    0.789924] i8k: unable to get SMM BIOS version
[    0.795389] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal
Zotto (dz@debian.org)
[    0.801496] Linux agpgart interface v0.103
[    0.807223] agpgart-intel 0000:00:00.0: Intel Mobile Intel® GM45
Express Chipset
[    0.813615] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    0.823157] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    0.828783] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[    0.834449] Hangcheck: Using get_cycles().
[    0.840129] [drm] Initialized drm 1.1.0 20060810
[    0.845900] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.851510] pci 0000:00:02.0: setting latency timer to 64
[    0.853393] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[    0.859094] [drm] MTRR allocation failed.  Graphics performance may suffer.
[    0.864847] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[    0.899636] acpi device:36: registered as cooling_device2
[    0.909181] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:33/input/input3
[    0.915032] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.921668] ACPI Warning (nspredef-0437): \_SB_.PCI0.VID2._DOD:
Return Package has no elements (empty) [20090320]
[    0.928086] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:3b/input/input4
[    0.934343] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
[    0.940746] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    0.947172] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.959945] brd: module loaded
[    0.966931] ACPI: Battery Slot [BAT0] (battery present)
[    0.968480] loop: module loaded
[    0.968818] Loading iSCSI transport class v2.0-870.
[    0.985627] Driver 'sd' needs updating - please use bus_type methods
[    0.992894] Driver 'sr' needs updating - please use bus_type methods
[    0.999559] ahci 0000:00:1f.2: version 3.0
[    0.999580] ahci 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.005879] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.006004] ahci: SSS flag set, parallel bus scan disabled
[    1.012188] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3
Gbps 0x33 impl SATA mode
[    1.018355] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led
clo pio slum part ems
[    1.024482] ahci 0000:00:1f.2: setting latency timer to 64
[    1.027788] scsi0 : ahci
[    1.034390] scsi1 : ahci
[    1.040551] scsi2 : ahci
[    1.046571] scsi3 : ahci
[    1.052412] scsi4 : ahci
[    1.058238] scsi5 : ahci
[    1.064654] ata1: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c900 irq 28
[    1.070202] ata2: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1c980 irq 28
[    1.075644] ata3: DUMMY
[    1.081001] ata4: DUMMY
[    1.086245] ata5: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb00 irq 28
[    1.091691] ata6: SATA max UDMA/133 abar m2048@0xfed1c800 port
0xfed1cb80 irq 28
[    1.097768] tg3.c:v3.98 (February 25, 2009)
[    1.103116] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.108517] tg3 0000:09:00.0: setting latency timer to 64
[    1.114294] tg3 0000:09:00.0: PME# disabled
[    1.129403] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express)
MAC address 00:21:9b:f5:60:0f
[    1.134860] eth0: attached PHY is 5722/5756 (10/100/1000Base-T
Ethernet) (WireSpeed[1])
[    1.140372] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.145913] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.151626] sky2 driver version 1.22
[    1.157864] PPP generic driver version 2.4.2
[    1.163510] PPP Deflate Compression module registered
[    1.168869] PPP BSD Compression module registered
[    1.174635] PPP MPPE Compression module registered
[    1.179906] NET: Registered protocol family 24
[    1.185131] PPPoL2TP kernel driver, V1.0
[    1.190305] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
max=256) (6 bit encapsulation enabled).
[    1.195684] CSLIP: code copyright 1989 Regents of the University of
California.
[    1.201037] SLIP linefill/keepalive option.
[    1.206650] console [netcon0] enabled
[    1.211843] netconsole: network logging started
[    1.217088] yenta_cardbus 0000:02:01.0: CardBus bridge found [1028:0262]
[    1.420039] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.426291] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
[    1.431217] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    1.437590] ata1.00: configured for UDMA/133
[    1.453911] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS
  DE04 PQ: 0 ANSI: 5
[    1.459880] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors:
(160 GB/149 GiB)
[    1.464818] sd 0:0:0:0: [sda] Write Protect is off
[    1.469676] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.469738] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.475201]  sda:<5>sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.739158]  sda1 sda2 sda3 sda4 < sda5 sda6 >
[    1.810125] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.200038] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.218017] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
[    2.223086] ata2.00: applying bridge limits
[    2.242814] ata2.00: configured for UDMA/100
[    2.265712] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW
TS-L633A D500 PQ: 0 ANSI: 5
[    2.278295] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[    2.283424] Uniform CD-ROM driver Revision: 3.20
[    2.289119] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.289353] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    2.480042] async/0 used greatest stack depth: 6432 bytes left
[    2.613368] ata5: SATA link down (SStatus 0 SControl 300)
[    2.950033] ata6: SATA link down (SStatus 4 SControl 300)
[    3.094412] yenta_cardbus 0000:02:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[    3.099887] yenta_cardbus 0000:02:01.0: Socket status: 30000006
[    3.105290] pci_bus 0000:02: Raising subordinate bus# of parent bus
(#02) from #03 to #06
[    3.110927] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
I/O window: 0x2000 - 0x2fff
[    3.116611] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0xf6700000 - 0xf67fffff
[    3.122347] yenta_cardbus 0000:02:01.0: pcmcia: parent PCI bridge
Memory window: 0x50000000 - 0x53ffffff
[    3.380380] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.386060] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.391755] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    3.391761] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    3.397946] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    3.407399] ehci_hcd 0000:00:1a.7: debug port 1
[    3.412810] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    3.412838] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    3.430867] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    3.436333] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.441769] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.447216] usb usb1: Product: EHCI Host Controller
[    3.452641] usb usb1: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty ehci_hcd
[    3.458176] usb usb1: SerialNumber: 0000:00:1a.7
[    3.463986] usb usb1: configuration #1 chosen from 1 choice
[    3.469861] hub 1-0:1.0: USB hub found
[    3.475349] hub 1-0:1.0: 6 ports detected
[    3.481725] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.487066] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.487072] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.493677] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    3.502980] ehci_hcd 0000:00:1d.7: debug port 1
[    3.508247] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.508275] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    3.527520] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.532729] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.537949] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.543159] usb usb2: Product: EHCI Host Controller
[    3.548303] usb usb2: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty ehci_hcd
[    3.553493] usb usb2: SerialNumber: 0000:00:1d.7
[    3.558817] usb usb2: configuration #1 chosen from 1 choice
[    3.564088] hub 2-0:1.0: USB hub found
[    3.569102] hub 2-0:1.0: 6 ports detected
[    3.574486] uhci_hcd: USB Universal Host Controller Interface driver
[    3.579565] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.584744] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.584749] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    3.589988] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    3.595042] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
[    3.600132] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.605155] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.610124] usb usb3: Product: UHCI Host Controller
[    3.615033] usb usb3: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.620036] usb usb3: SerialNumber: 0000:00:1a.0
[    3.625181] usb usb3: configuration #1 chosen from 1 choice
[    3.630272] hub 3-0:1.0: USB hub found
[    3.635304] hub 3-0:1.0: 2 ports detected
[    3.640579] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.645605] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    3.645610] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    3.650633] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    3.655559] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
[    3.660486] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.665468] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.670368] usb usb4: Product: UHCI Host Controller
[    3.675217] usb usb4: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.680167] usb usb4: SerialNumber: 0000:00:1a.1
[    3.685275] usb usb4: configuration #1 chosen from 1 choice
[    3.690338] hub 4-0:1.0: USB hub found
[    3.695260] hub 4-0:1.0: 2 ports detected
[    3.700504] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.705491] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    3.705496] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    3.710540] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    3.715516] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
[    3.720450] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.725352] usb usb5: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.730268] usb usb5: Product: UHCI Host Controller
[    3.735162] usb usb5: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.740207] usb usb5: SerialNumber: 0000:00:1a.2
[    3.745368] usb usb5: configuration #1 chosen from 1 choice
[    3.750528] hub 5-0:1.0: USB hub found
[    3.755487] hub 5-0:1.0: 2 ports detected
[    3.760728] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.765767] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.765773] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.770917] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    3.775975] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
[    3.781036] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.786061] usb usb6: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.791057] usb usb6: Product: UHCI Host Controller
[    3.796000] usb usb6: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.801057] usb usb6: SerialNumber: 0000:00:1d.0
[    3.806266] usb usb6: configuration #1 chosen from 1 choice
[    3.811481] hub 6-0:1.0: USB hub found
[    3.816494] hub 6-0:1.0: 2 ports detected
[    3.821763] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    3.826806] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.826811] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.831918] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    3.836995] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
[    3.842019] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    3.847174] usb usb7: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.852174] usb usb7: Product: UHCI Host Controller
[    3.857110] usb usb7: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.862122] usb usb7: SerialNumber: 0000:00:1d.1
[    3.867296] usb usb7: configuration #1 chosen from 1 choice
[    3.872424] hub 7-0:1.0: USB hub found
[    3.877435] hub 7-0:1.0: 2 ports detected
[    3.882693] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    3.887738] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.887744] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.892839] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    3.897908] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    3.902934] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    3.907957] usb usb8: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.912955] usb usb8: Product: UHCI Host Controller
[    3.917894] usb usb8: Manufacturer: Linux
2.6.30-rc8-00073-g3af968e-dirty uhci_hcd
[    3.922908] usb usb8: SerialNumber: 0000:00:1d.2
[    3.928083] usb usb8: configuration #1 chosen from 1 choice
[    3.933213] hub 8-0:1.0: USB hub found
[    3.938223] hub 8-0:1.0: 2 ports detected
[    3.943574] Initializing USB Mass Storage driver...
[    3.948646] usbcore: registered new interface driver usb-storage
[    3.953624] USB Mass Storage support registered.
[    3.958924] usbcore: registered new interface driver libusual
[    3.964124] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[    3.969644] i8042.c: Warning: Keylock active.
[    3.978461] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.983475] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.988577] mice: PS/2 mouse device common for all mice
[    3.994798] rtc_cmos 00:03: RTC can wake from S4
[    3.999955] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.004941] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    4.009999] i2c /dev entries driver
[    4.015177] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    4.020702] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input5
[    4.026007] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
[    4.031435] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    4.036943] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
[    4.042286] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.047439] iTCO_vendor_support: vendor-support=0
[    4.053016] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    4.059280] cpuidle: using governor ladder
[    4.066054] cpuidle: using governor menu
[    4.071475] sdhci: Secure Digital Host Controller Interface driver
[    4.076735] sdhci: Copyright(c) Pierre Ossman
[    4.081993] sdhci-pci 0000:02:01.2: SDHCI controller found
[1180:0822] (rev 21)
[    4.087335] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[    4.095018] Registered led device: mmc0::
[    4.101502] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
[    4.106968] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    4.112274] wbsd: Copyright(c) Pierre Ossman
[    4.118134] dcdbas dcdbas: Dell Systems Management Base Driver
(version 5.6.0-3.2)
[    4.125975] usbcore: registered new interface driver hiddev
[    4.131469] usbcore: registered new interface driver usbhid
[    4.136749] usbhid: v2.6:USB HID core driver
[    4.142286] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    4.147621] ALSA device list:
[    4.152969]   No soundcards found.
[    4.158271] Netfilter messages via NETLINK v0.30.
[    4.163634] nf_conntrack version 0.5.0 (15672 buckets, 62688 max)
[    4.169742] ctnetlink v0.93: registering with nfnetlink.
[    4.177022] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.182390] TCP cubic registered
[    4.187603] NET: Registered protocol family 17
[    4.192810] lib80211: common routines for IEEE802.11 drivers
[    4.198050] lib80211_crypt: registered algorithm 'NULL'
[    4.200165] Using IPI No-Shortcut mode
[    4.205899] PM: Checking image partition /dev/sda1
[    4.205945] PM: Resume from partition 8:1
[    4.205947] PM: Checking hibernation image.
[    4.206469] PM: Resume from disk failed.
[    4.206525] registered taskstats version 1
[    4.212064]   Magic number: 13:467:887
[    4.217301] graphics fb0: hash matches
[    4.222468] pci 0000:00:1f.0: hash matches
[    4.227611] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    4.358041] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
[    4.385850] input: AlpsPS/2 ALPS GlidePoint as
/devices/platform/i8042/serio1/input/input7
[    4.401122] md: Waiting for all devices to be available before autodetect
[    4.411896] md: If you don't use raid, use raid=noautodetect
[    4.425489] md: Autodetecting RAID arrays.
[    4.436302] md: Scanned 0 and added 0 devices.
[    4.447071] md: autorun ...
[    4.457748] md: ... autorun DONE.
[    4.500170] Clocksource tsc unstable (delta = -145677310 ns)
[    4.746988] kjournald starting.  Commit interval 5 seconds
[    4.758301] EXT3-fs: mounted filesystem with writeback data mode.
[    4.768973] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    4.779485] Freeing unused kernel memory: 352k freed
[    4.790942] Write protecting the kernel text: 3380k
[    4.801727] Write protecting the kernel read-only data: 1812k
[    5.899973] mount used greatest stack depth: 5948 bytes left
[    7.978308] ACPI: WMI: Mapper loaded
[    8.186011] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    8.265705] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[    8.674803] modprobe used greatest stack depth: 5944 bytes left
[    8.828771] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[    8.839561] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.567091] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
[    9.984187] hda_intel: azx_get_response timeout, switching to
polling mode: last cmd=0x00af0900
[    9.990814] input: HDA Intel Mic at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input8
[    9.996429] input: HDA Intel Line Out at Sep Left Jack as
/devices/pci0000:00/0000:00:1b.0/input/input9
[   10.002010] input: HDA Intel HP Out at Ext Right Jack as
/devices/pci0000:00/0000:00:1b.0/input/input10
[   10.392541] Adding 1004020k swap on /dev/sda1.  Priority:-1
extents:1 across:1004020k
[   12.184854] EXT3 FS on sda2, internal journal
[   16.740574] kjournald starting.  Commit interval 5 seconds
[   16.752927] EXT3 FS on sda3, internal journal
[   16.764614] EXT3-fs: mounted filesystem with writeback data mode.
[   17.122130] EXT4-fs: barriers enabled
[   17.150008] kjournald2 starting: pid 1591, dev sda5:8, commit
interval 5 seconds
[   17.161686] EXT4 FS on sda5, internal journal on sda5:8
[   17.173313] EXT4-fs: delayed allocation enabled
[   17.184967] EXT4-fs: file extents enabled
[   17.202993] EXT4-fs: mballoc enabled
[   17.214770] EXT4-fs: mounted filesystem sda5 with ordered data mode
[   17.957655] rc.S used greatest stack depth: 5860 bytes left
[   26.878033] Bluetooth: Core ver 2.15
[   26.878286] NET: Registered protocol family 31
[   26.878293] Bluetooth: HCI device and connection manager initialized
[   26.878480] Bluetooth: HCI socket layer initialized
[   26.970122] Bluetooth: L2CAP ver 2.13
[   26.970130] Bluetooth: L2CAP socket layer initialized
[   27.376654] Bluetooth: SCO (Voice Link) ver 0.6
[   27.376662] Bluetooth: SCO socket layer initialized
[   27.600955] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.600964] Bluetooth: BNEP filters: protocol multicast
[   29.672484] smbd used greatest stack depth: 5636 bytes left
[   42.089890] EXT4-fs: mballoc: 0 blocks 0 reqs (0 success)
[   42.089900] EXT4-fs: mballoc: 0 extents scanned, 0 goal hits, 0 2^N
hits, 0 breaks, 0 lost
[   42.089907] EXT4-fs: mballoc: 0 generated and it took 0
[   42.089914] EXT4-fs: mballoc: 0 preallocated, 0 discarded
[   66.478950] mtrr: type mismatch for e0000000,10000000 old:
write-back new: write-combining
[  148.258364]
[  148.258365] =======================================================
[  148.258558] [ INFO: possible circular locking dependency detected ]
[  148.258707] 2.6.30-rc8-00073-g3af968e-dirty #61
[  148.258815] -------------------------------------------------------
[  148.258970] 94cpufreq/2095 is trying to acquire lock:
[  148.259090]  (&(&dbs_info->work)->work){+.+...}, at: [<c10365c6>]
__cancel_work_timer+0x8c/0x18c
[  148.259320]
[  148.259320] but task is already holding lock:
[  148.259459]  (dbs_mutex){+.+.+.}, at: [<c1276243>]
cpufreq_governor_dbs+0x1ee/0x267
[  148.259659]
[  148.259660] which lock already depends on the new lock.
[  148.259661]
[  148.259856]
[  148.259856] the existing dependency chain (in reverse order) is:
[  148.260040]
[  148.260041] -> #2 (dbs_mutex){+.+.+.}:
[  148.260183]        [<c1047cfb>] __lock_acquire+0x91e/0xaa9
[  148.260321]        [<c1047f21>] lock_acquire+0x9b/0xbe
[  148.260450]        [<c1347d3c>] __mutex_lock_common+0x35/0x2d2
[  148.260596]        [<c1348071>] mutex_lock_nested+0x2e/0x36
[  148.260737]        [<c12760c5>] cpufreq_governor_dbs+0x70/0x267
[  148.260837]        [<c12738b7>] __cpufreq_governor+0x66/0x9d
[  148.260837]        [<c127403c>] __cpufreq_set_policy+0x16f/0x1dd
[  148.260837]        [<c1274965>] cpufreq_add_dev+0x4d4/0x5f6
[  148.260837]        [<c11c4619>] sysdev_driver_register+0x96/0xe5
[  148.260837]        [<c1274ca9>] cpufreq_register_driver+0xa1/0x168
[  148.260837]        [<c15758cf>] acpi_cpufreq_init+0x99/0xab
[  148.260837]        [<c1001137>] do_one_initcall+0x4a/0x11a
[  148.260837]        [<c156d50a>] kernel_init+0xfe/0x14f
[  148.260837]        [<c1003d1f>] kernel_thread_helper+0x7/0x10
[  148.260837]        [<ffffffff>] 0xffffffff
[  148.260837]
[  148.260837] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  148.260837]        [<c1047cfb>] __lock_acquire+0x91e/0xaa9
[  148.260837]        [<c1047f21>] lock_acquire+0x9b/0xbe
[  148.260837]        [<c134824b>] down_write+0x2f/0x4b
[  148.260837]        [<c1273ea5>] lock_policy_rwsem_write+0x33/0x5b
[  148.260837]        [<c1275e5f>] do_dbs_timer+0x45/0x23b
[  148.260837]        [<c1036b9e>] worker_thread+0x170/0x23c
[  148.260837]        [<c10393e1>] kthread+0x45/0x6c
[  148.260837]        [<c1003d1f>] kernel_thread_helper+0x7/0x10
[  148.260837]        [<ffffffff>] 0xffffffff
[  148.260837]
[  148.260837] -> #0 (&(&dbs_info->work)->work){+.+...}:
[  148.260837]        [<c1047c0b>] __lock_acquire+0x82e/0xaa9
[  148.260837]        [<c1047f21>] lock_acquire+0x9b/0xbe
[  148.260837]        [<c10365f1>] __cancel_work_timer+0xb7/0x18c
[  148.260837]        [<c10366d1>] cancel_delayed_work_sync+0xb/0xd
[  148.260837]        [<c1276252>] cpufreq_governor_dbs+0x1fd/0x267
[  148.260837]        [<c12738b7>] __cpufreq_governor+0x66/0x9d
[  148.260837]        [<c127401b>] __cpufreq_set_policy+0x14e/0x1dd
[  148.260837]        [<c1274334>] store_scaling_governor+0x159/0x188
[  148.260837]        [<c1274ac9>] store+0x42/0x5b
[  148.260837]        [<c10cce91>] sysfs_write_file+0xb8/0xe3
[  148.260837]        [<c1090478>] vfs_write+0x82/0xdc
[  148.260837]        [<c1090567>] sys_write+0x3b/0x5d
[  148.260837]        [<c10032dd>] syscall_call+0x7/0xb
[  148.260837]        [<ffffffff>] 0xffffffff
[  148.260837]
[  148.260837] other info that might help us debug this:
[  148.260837]
[  148.260837] 2 locks held by 94cpufreq/2095:
[  148.260837]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10ccdfe>]
sysfs_write_file+0x25/0xe3
[  148.260837]  #1:  (dbs_mutex){+.+.+.}, at: [<c1276243>]
cpufreq_governor_dbs+0x1ee/0x267
[  148.260837]
[  148.260837] stack backtrace:
[  148.260837] Pid: 2095, comm: 94cpufreq Not tainted
2.6.30-rc8-00073-g3af968e-dirty #61
[  148.260837] Call Trace:
[  148.260837]  [<c1046881>] print_circular_bug_tail+0x5d/0x68
[  148.260837]  [<c1047c0b>] __lock_acquire+0x82e/0xaa9
[  148.260837]  [<c1046401>] ? mark_lock+0x1e/0x1c7
[  148.260837]  [<c1047f21>] lock_acquire+0x9b/0xbe
[  148.260837]  [<c10365c6>] ? __cancel_work_timer+0x8c/0x18c
[  148.260837]  [<c10365f1>] __cancel_work_timer+0xb7/0x18c
[  148.260837]  [<c10365c6>] ? __cancel_work_timer+0x8c/0x18c
[  148.260837]  [<c104670f>] ? trace_hardirqs_on_caller+0x10a/0x146
[  148.260837]  [<c1347fcf>] ? __mutex_lock_common+0x2c8/0x2d2
[  148.260837]  [<c10366d1>] cancel_delayed_work_sync+0xb/0xd
[  148.260837]  [<c1276252>] cpufreq_governor_dbs+0x1fd/0x267
[  148.260837]  [<c12738b7>] __cpufreq_governor+0x66/0x9d
[  148.260837]  [<c127401b>] __cpufreq_set_policy+0x14e/0x1dd
[  148.260837]  [<c12741db>] ? store_scaling_governor+0x0/0x188
[  148.260837]  [<c1274334>] store_scaling_governor+0x159/0x188
[  148.260837]  [<c12741b3>] ? handle_update+0x0/0x28
[  148.260837]  [<c1273ea5>] ? lock_policy_rwsem_write+0x33/0x5b
[  148.260837]  [<c12741db>] ? store_scaling_governor+0x0/0x188
[  148.260837]  [<c1274ac9>] store+0x42/0x5b
[  148.260837]  [<c10cce91>] sysfs_write_file+0xb8/0xe3
[  148.260837]  [<c1090478>] vfs_write+0x82/0xdc
[  148.260837]  [<c10ccdd9>] ? sysfs_write_file+0x0/0xe3
[  148.260837]  [<c1090567>] sys_write+0x3b/0x5d
[  148.260837]  [<c10032dd>] syscall_call+0x7/0xb
[  148.797693] PM: Syncing filesystems ... done.
[  148.799360] PM: Preparing system for mem sleep
[  148.799373] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  148.799690] Freezing remaining freezable tasks ... (elapsed 0.00
seconds) done.
[  148.799748] PM: Entering mem sleep
[  148.799762] Suspending console(s) (use no_console_suspend to debug)
[  149.307030] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  149.307259] sd 0:0:0:0: [sda] Stopping disk
[  149.668140] ACPI handle has no context!
[  149.668147] sdhci-pci 0000:02:01.2: PME# disabled
[  149.668154] sdhci-pci 0000:02:01.2: PCI INT C disabled
[  149.668162] ACPI handle has no context!
[  149.685306] ACPI handle has no context!
[  149.763578] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  149.763658] ehci_hcd 0000:00:1d.7: PME# disabled
[  149.776892] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  149.776967] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  149.777039] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  149.803584] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  149.816892] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  149.816972] ehci_hcd 0000:00:1a.7: PME# disabled
[  149.830241] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  149.830316] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  149.830385] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  149.838864] ACPI: Preparing to enter system sleep state S3
[  149.880668] Disabling non-boot CPUs ...
[  149.983338] CPU 1 is now offline
[  149.983340] lockdep: fixing up alternatives.
[  149.983343] SMP alternatives: switching to UP code
[  149.987218] CPU1 is down
[  149.987275] Extended CMOS year: 2000
[  149.987275] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  149.987275] Back to C!
[  149.987275] Extended CMOS year: 2000
[  149.987275] Enabling non-boot CPUs ...
[  149.987275] lockdep: fixing up alternatives.
[  149.987275] SMP alternatives: switching to SMP code
[  149.990636] Booting processor 1 APIC 0x1 ip 0x6000
[  149.986895] Initializing CPU#1
[  149.986895] Calibrating delay using timer specific routine..
3991.29 BogoMIPS (lpj=6650077)
[  149.986895] CPU: L1 I cache: 32K, L1 D cache: 32K
[  149.986895] CPU: L2 cache: 2048K
[  149.986895] CPU: Physical Processor ID: 0
[  149.986895] CPU: Processor Core ID: 1
[  149.986895] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  150.085030] CPU1: Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
[  150.087499] Switched to high resolution mode on CPU 1
[  150.096815] microcode: failed to init CPU1
[  150.097503] CPU1 is up
[  150.097506] ACPI: Waking up from system sleep state S3
[  150.287126] pci 0000:00:02.0: restoring config space at offset 0xf
(was 0x100, writing 0x10b)
[  150.287137] pci 0000:00:02.0: restoring config space at offset 0x8
(was 0x1, writing 0xefe9)
[  150.287143] pci 0000:00:02.0: restoring config space at offset 0x6
(was 0xc, writing 0xe000000c)
[  150.287152] pci 0000:00:02.0: restoring config space at offset 0x1
(was 0x900007, writing 0x900403)
[  150.287188] pci 0000:00:02.1: restoring config space at offset 0x4
(was 0x4, writing 0xf6b00004)
[  150.287195] pci 0000:00:02.1: restoring config space at offset 0x1
(was 0x900000, writing 0x900007)
[  150.287213] uhci_hcd 0000:00:1a.0: restoring config space at offset
0xf (was 0x100, writing 0x10a)
[  150.287231] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x8 (was 0x1, writing 0x6f61)
[  150.287248] uhci_hcd 0000:00:1a.0: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[  150.287271] uhci_hcd 0000:00:1a.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[  150.287288] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f81)
[  150.287305] uhci_hcd 0000:00:1a.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[  150.287329] uhci_hcd 0000:00:1a.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[  150.287346] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x8 (was 0x1, writing 0x6fa1)
[  150.287363] uhci_hcd 0000:00:1a.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[  150.287420] ehci_hcd 0000:00:1a.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[  150.287461] HDA Intel 0000:00:1b.0: restoring config space at
offset 0xf (was 0x100, writing 0x107)
[  150.287485] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x4 (was 0xfebfc004, writing 0xf6afc004)
[  150.287492] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x3 (was 0x0, writing 0x10)
[  150.287500] HDA Intel 0000:00:1b.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100102)
[  150.287538] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[  150.287554] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[  150.287560] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x8 (was 0x0, writing 0xfff0)
[  150.287567] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[  150.287574] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0b00)
[  150.287584] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[  150.287593] pcieport-driver 0000:00:1c.0: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[  150.287659] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0xf (was 0x200, writing 0x20200)
[  150.287675] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[  150.287681] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x8 (was 0x0, writing 0xf690f690)
[  150.287688] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[  150.287695] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x6 (was 0x0, writing 0xc0c00)
[  150.287706] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[  150.287714] pcieport-driver 0000:00:1c.1: restoring config space at
offset 0x1 (was 0x100000, writing 0x100507)
[  150.287780] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0xf (was 0x100, writing 0x20100)
[  150.287795] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x9 (was 0x10001, writing 0x1fff1)
[  150.287802] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x8 (was 0x0, writing 0xf680f680)
[  150.287809] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x7 (was 0x20000000, writing 0x200000f0)
[  150.287816] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x6 (was 0x0, writing 0x90900)
[  150.287826] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x3 (was 0x810000, writing 0x810010)
[  150.287835] pcieport-driver 0000:00:1c.4: restoring config space at
offset 0x1 (was 0x100000, writing 0x100407)
[  150.287917] uhci_hcd 0000:00:1d.0: restoring config space at offset
0x1 (was 0x2900005, writing 0x2900001)
[  150.287940] uhci_hcd 0000:00:1d.1: restoring config space at offset
0xf (was 0x200, writing 0x207)
[  150.287957] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x8 (was 0x1, writing 0x6f21)
[  150.287974] uhci_hcd 0000:00:1d.1: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[  150.287998] uhci_hcd 0000:00:1d.2: restoring config space at offset
0xf (was 0x300, writing 0x305)
[  150.288015] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x8 (was 0x1, writing 0x6f41)
[  150.288032] uhci_hcd 0000:00:1d.2: restoring config space at offset
0x1 (was 0x2900000, writing 0x2900001)
[  150.288088] ehci_hcd 0000:00:1d.7: restoring config space at offset
0x1 (was 0x2900106, writing 0x2900102)
[  150.288129] pci 0000:00:1e.0: restoring config space at offset 0x9
(was 0x1fff1, writing 0x53f15001)
[  150.288138] pci 0000:00:1e.0: restoring config space at offset 0x7
(was 0x2280e0f0, writing 0x22802020)
[  150.288144] pci 0000:00:1e.0: restoring config space at offset 0x6
(was 0x20020200, writing 0x20060200)
[  150.288209] pci 0000:00:1f.0: restoring config space at offset 0x1
(was 0x2100007, writing 0x2100107)
[  150.288247] ahci 0000:00:1f.2: restoring config space at offset 0xf
(was 0x400, writing 0x40a)
[  150.288276] ahci 0000:00:1f.2: restoring config space at offset 0x1
(was 0x2b00007, writing 0x2b00407)
[  150.288325] i801_smbus 0000:00:1f.3: restoring config space at
offset 0xf (was 0x200, writing 0x204)
[  150.288349] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x4 (was 0x4, writing 0xf6afbf04)
[  150.288359] i801_smbus 0000:00:1f.3: restoring config space at
offset 0x1 (was 0x2800001, writing 0x2800103)
[  150.288629] pci 0000:0c:00.0: restoring config space at offset 0xf
(was 0x100, writing 0x104)
[  150.288694] pci 0000:0c:00.0: restoring config space at offset 0x4
(was 0x4, writing 0xf69fc004)
[  150.288707] pci 0000:0c:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[  150.288726] pci 0000:0c:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[  150.288895] tg3 0000:09:00.0: restoring config space at offset 0x3
(was 0x0, writing 0x10)
[  150.288906] tg3 0000:09:00.0: restoring config space at offset 0x1
(was 0x100000, writing 0x100106)
[  150.288954] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xf (was 0x7000100, writing 0x580010a)
[  150.288961] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xe (was 0x0, writing 0x24fc)
[  150.288967] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xd (was 0x0, writing 0x2400)
[  150.288974] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xc (was 0x0, writing 0x20fc)
[  150.288980] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xb (was 0x0, writing 0x2000)
[  150.288987] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0xa (was 0x0, writing 0x57fff000)
[  150.288994] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x9 (was 0x0, writing 0x54000000)
[  150.289001] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x8 (was 0x0, writing 0x53fff000)
[  150.289008] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x7 (was 0x0, writing 0x50000000)
[  150.289014] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x6 (was 0x0, writing 0xb0060302)
[  150.289023] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x4 (was 0x0, writing 0xf6700000)
[  150.289030] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x3 (was 0x820000, writing 0x82a800)
[  150.289039] yenta_cardbus 0000:02:01.0: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100007)
[  150.289067] ohci1394 0000:02:01.1: restoring config space at offset
0xf (was 0x4020200, writing 0x4020204)
[  150.289096] ohci1394 0000:02:01.1: restoring config space at offset
0x3 (was 0x800000, writing 0x804010)
[  150.289105] ohci1394 0000:02:01.1: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100106)
[  150.289131] sdhci-pci 0000:02:01.2: restoring config space at
offset 0xf (was 0x300, writing 0x303)
[  150.289157] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x4 (was 0x0, writing 0xf67ff600)
[  150.289164] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x3 (was 0x800000, writing 0x804010)
[  150.289172] sdhci-pci 0000:02:01.2: restoring config space at
offset 0x1 (was 0x2100000, writing 0x2100106)
[  150.289198] pci 0000:02:01.3: restoring config space at offset 0xf
(was 0x300, writing 0x303)
[  150.289224] pci 0000:02:01.3: restoring config space at offset 0x4
(was 0x0, writing 0xf67ff700)
[  150.289231] pci 0000:02:01.3: restoring config space at offset 0x3
(was 0x800000, writing 0x804010)
[  150.289240] pci 0000:02:01.3: restoring config space at offset 0x1
(was 0x2100000, writing 0x2100106)
[  150.388775] pci 0000:00:02.0: PME# disabled
[  150.388783] pci 0000:00:02.1: PME# disabled
[  150.388835] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  150.388843] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  150.388871] usb usb3: root hub lost power or was reset
[  150.388933] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  150.388940] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  150.388968] usb usb4: root hub lost power or was reset
[  150.389028] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  150.389035] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  150.389061] usb usb5: root hub lost power or was reset
[  150.389137] ehci_hcd 0000:00:1a.7: PME# disabled
[  150.389142] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  150.389149] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  150.389158] ehci_hcd 0000:00:1a.7: PME# disabled
[  150.389223] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level,
low) -> IRQ 21
[  150.389230] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  150.389305] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  150.389312] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  150.389341] usb usb6: root hub lost power or was reset
[  150.389402] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[  150.389409] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  150.389435] usb usb7: root hub lost power or was reset
[  150.389496] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  150.389503] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  150.389530] usb usb8: root hub lost power or was reset
[  150.389607] ehci_hcd 0000:00:1d.7: PME# disabled
[  150.389612] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  150.389619] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  150.389627] ehci_hcd 0000:00:1d.7: PME# disabled
[  150.389639] pci 0000:00:1e.0: setting latency timer to 64
[  150.389735] ahci 0000:00:1f.2: setting latency timer to 64
[  150.393274] pci 0000:0c:00.0: PME# disabled
[  150.585588] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]
MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[  150.591698] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level,
low) -> IRQ 18
[  150.592725] pci 0000:02:01.3: PME# disabled
[  150.592877] pci 0000:00:02.0: setting latency timer to 64
[  150.593937] sd 0:0:0:0: [sda] Starting disk
[  150.706892] ata5: SATA link down (SStatus 0 SControl 300)
[  150.706923] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  150.706962] ata6: SATA link down (SStatus 4 SControl 300)
[  150.780108] ata2.00: configured for UDMA/100
[  150.843555] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  150.843560] ata2: irq_stat 0x40000001
[  150.907765] ata2.00: configured for UDMA/100
[  150.907769] ata2: EH complete
[  152.093558] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  152.097390] ata1.00: configured for UDMA/133
[  152.110220] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  152.110224] ata1: irq_stat 0x00400040, connection status changed
[  152.113980] ata1.00: configured for UDMA/133
[  152.113985] ata1: EH complete
[  152.226974] PM: Finishing wakeup.
[  152.226979] Restarting tasks ... done.

>
> Thanks,
>
> Mathieu
>
>
>> > My test machine is currently busy running long formal verifications, and
>> > therefore unavailable for kernel patch testing. It compiles fine on a
>> > 2.6.30-rc5 kernel with my (now mainlined) cpufreq patches applied.
>> >
>> > Mathieu
>> >
>> >
>> > remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)
>> >
>> > commit  42a06f2166f2f6f7bf04f32b4e823eacdceafdc9
>> >
>> > Missed a call site for CPUFREQ_GOV_STOP to remove the rwlock taken around the
>> > teardown. To make a long story short, the rwlock write-lock causes a circular
>> > dependency with cancel_delayed_work_sync(), because the timer handler takes the
>> > read lock.
>> >
>> > Note that all callers to __cpufreq_set_policy are taking the rwsem. All sysfs
>> > callers (writers) hold the write rwsem at the earliest sysfs calling stage.
>> >
>> > However, the rwlock write-lock is not needed upon governor stop.
>> >
>> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> > CC: rjw@sisk.pl
>> > CC: mingo@elte.hu
>> > CC: Shaohua Li <shaohua.li@intel.com>
>> > CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> > CC: Dave Young <hidave.darkstar@gmail.com>
>> > CC: "Rafael J. Wysocki" <rjw@sisk.pl>
>> > CC: Rusty Russell <rusty@rustcorp.com.au>
>> > CC: trenn@suse.de
>> > CC: sven.wegener@stealer.net
>> > CC: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> > CC: cpufreq@vger.kernel.org
>> > ---
>> >  drivers/cpufreq/cpufreq.c |   11 ++++++++++-
>> >  1 file changed, 10 insertions(+), 1 deletion(-)
>> >
>> > Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
>> > ===================================================================
>> > --- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c      2009-06-08 10:20:48.000000000 -0400
>> > +++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c   2009-06-08 10:48:52.000000000 -0400
>> > @@ -1697,8 +1697,17 @@ static int __cpufreq_set_policy(struct c
>> >                        dprintk("governor switch\n");
>> >
>> >                        /* end old governor */
>> > -                       if (data->governor)
>> > +                       if (data->governor) {
>> > +                               /*
>> > +                                * Need to release the rwsem around governor
>> > +                                * stop due to lock dependency between
>> > +                                * cancel_delayed_work_sync and the read lock
>> > +                                * taken in the delayed work handler.
>> > +                                */
>> > +                               unlock_policy_rwsem_write(data->cpu);
>> >                                __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>> > +                               lock_policy_rwsem_write(data->cpu);
>> > +                       }
>> >
>> >                        /* start new governor */
>> >                        data->governor = policy->governor;
>> >
>> >
>> > --
>> > Mathieu Desnoyers
>> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>>
>>
>> --
>> Regards
>> dave
>>
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>



-- 
Regards
dave
