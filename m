Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbYIPCys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbYIPCys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 22:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYIPCyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 22:54:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49331 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbYIPCyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 22:54:36 -0400
Date: Mon, 15 Sep 2008 16:54:31 -1000
From: Joshua Hoblitt <josh@hoblitt.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, bugme-daemon@bugzilla.kernel.org,
       j_kernel@hoblitt.com
Subject: Re: [Bugme-new] [Bug 11543] New: kernel panic: softlockup in
	tick_periodic() ???
Message-ID: <20080916025431.GB16764@hoblitt.com>
References: <bug-11543-10286@http.bugzilla.kernel.org/> <20080911170258.aa0bea0d.akpm@linux-foundation.org> <20080912091308.GA10305@elte.hu> <20080913001306.GA9610@hoblitt.com> <20080915210635.GA16764@hoblitt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915210635.GA16764@hoblitt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the deadlocks, we still have the watchdog warning:

[    0.460034] Testing NMI watchdog ... 
[    0.532557] WARNING: CPU#0: NMI appears to be stuck (0->0)!
[    0.533301] Please report this to bugzilla.kernel.org,
[    0.536635] and attach the output of the 'dmesg' command.

Perhaps an HPET problem:

[    0.993800] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.999969] hpet0: 3 32-bit timers, 25000000 Hz
[    1.004396] ACPI: RTC can wake from S4
[    1.006637] Clockevents: could not switch to one-shot
mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
[    1.009844] Could not switch to high resolution mode on CPU 3
[    1.009848] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    1.009852] Could not switch to high resolution mode on CPU 2
[    1.009855] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    1.009858] Could not switch to high resolution mode on CPU 1
[    1.009969]  lapic is not functional.
[    1.056944] Could not switch to high resolution mode on CPU 0

And a failure to create a /dev/rtc[0] device with udev 115 or 119 and
this entry in the dmesg.

[    7.498900] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)

-J

--
On Mon, Sep 15, 2008 at 11:06:35AM -1000, Joshua Hoblitt wrote:
> Since Friday 2 different machines have experienced crashes.  One was a total
> deadlock with no response on the console.  The other one reported the trace
> below on the console and stopped responding to ssh but I was able to loging via
> the serial console and reboot the system.  This particular system has had a
> number of "odd" kernel traces over the last year and I'm starting to actually
> wonder if it may have a bad DIMM in it as occasionally the failure mode seems
> to be different then the deadlocks/etc. we see in the other 15 nodes with
> identical hardware.
> 
> [30712.654542] general protection fault: 0000 [1] SMP 
> <Sep/12 09:25 pm>[30712.657678] CPU 3 
> <Sep/12 09:25 pm>[30712.657678] Modules linked in: w83627hf hwmon_vid autofs4 smsc37b787_wdt k8temp i2c_nforce2 i2c_core forcedeth tg3 libphy e1000 xfs dm_snapshot dm_mirror dm_log aacraid 3w_9xxx 3w_xxxx atp870u arcmsr aic7xxx scsi_wait_scan
> <Sep/12 09:25 pm>[30712.657678] Pid: 1178, comm: rpciod/3 Not tainted 2.6.27-rc5-22033-gd26acd9-dirty #2
> <Sep/12 09:25 pm>[30712.657678] RIP: 0010:[<ffffffff805ac57d>]  [<ffffffff805ac57d>] rpc_count_iostats+0x35/0xb8
> <Sep/12 09:25 pm>[30712.657678] RSP: 0018:ffff88012e5d1e08  EFLAGS: 00010206
> <Sep/12 09:25 pm>[30712.657678] RAX: ffffffff807adb48 RBX: ffff880126d61088 RCX: 0400000000000000
> <Sep/12 09:25 pm>[30712.657678] RDX: ffff88022bcc0380 RSI: ffff88022bcc0000 RDI: ffff880126d61088
> <Sep/12 09:25 pm>[30712.657678] RBP: ffff88022bc88000 R08: 0000000000000003 R09: ffff88022e038f10
> <Sep/12 09:25 pm>[30712.657678] R10: 0000000000000001 R11: ffff88012e4a0048 R12: 0400000000000000
> <Sep/12 09:25 pm>[30712.657678] R13: ffffffff8059f7a8 R14: ffff88022bc88610 R15: 0000000000000000
> <Sep/12 09:25 pm>[30712.657678] FS:  00007f006fb306f0(0000) GS:ffff88022fa0d780(0000) knlGS:0000000000000000
> 
> <Sep/12 09:25 pm>[30712.657678] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> <Sep/12 09:25 pm>[30712.657678] CR2: 00000000011e3018 CR3: 00000001f3527000 CR4:<Sep/12 09:25 pm>
>                  <Sep/12 09:25 pm>[30712.657678] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <Sep/12 09:25 pm>[30712.657678] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <Sep/12 09:25 pm>[30712.657678] Process rpciod/3 (pid: 1178, threadinfo ffff88012e5d0000, task ffff88012e5acb50)
> <Sep/12 09:25 pm>[30712.657678] Stack:  ffffffff8059b996 ffff880126d61088 00000000fffffff5 ffff880126d61118
> <Sep/12 09:25 pm>[30712.657678]  ffffffff8059f7a8 ffffffff808a4b20 ffffffff80599aa1 ffffffff8059f7a8
> <Sep/12 09:25 pm>[30712.657678]  0000000000000000 ffff880126d61088 ffffffff8059f5f3 ffff88012e5d1e90
> <Sep/12 09:25 pm>[30712.657678] Call Trace:
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8059b996>] ? xprt_release+0x2c/0x172
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8059f7a8>] ? rpc_async_schedule+0x0/0xc
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80599aa1>] ? call_reserveresult+0x95/0xd1
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8059f7a8>] ? rpc_async_schedule+0x0/0xc
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8059f5f3>] ? __rpc_execute+0x73/0x228
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80244394>] ? run_workqueue+0xed/0x1ed
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8024433e>] ? run_workqueue+0x97/0x1ed
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80244ef7>] ? worker_thread+0xd8/0xe3
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8024791a>] ? autoremove_wake_function+0x0/0x2e
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80244e1f>] ? worker_thread+0x0/0xe3
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80247805>] ? kthread+0x47/0x76
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff80230223>] ? schedule_tail+0x27/0x5f
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8020ce09>] ? child_rip+0xa/0x11
> 
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8024767c>] ? kthreadd+0x167/0x18c
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff802477be>] ? kthread+0x0/0x76
> <Sep/12 09:25 pm>[30712.657678]  [<ffffffff8020cdff>] ? child_rip+0x0/0x11
> <Sep/12 09:25 pm>[30712.657678] 
> <Sep/12 09:25 pm>[30712.657678] 
> <Sep/12 09:25 pm>[30712.657678] Code: b0 98 00 00 00 48 85 f6 0f 94 c2 48 85 c9 0f 94 c0 08 c2 0f 85 94 00 00 00 48 8b 47 38 8b 50 28 48 c1 e2 07 48 8d 14 16 48 ff 02 <48> 63 81 50 01 00 00 48 01 42 08 0f b7 87 e0 00 00 00 48 01 42 
> <Sep/12 09:25 pm>[30712.657678] RIP  [<ffffffff805ac57d>] rpc_count_iostats+0x35/0xb8
> <Sep/12 09:25 pm>[30712.657678]  RSP <ffff88012e5d1e08>
> <Sep/12 09:25 pm>[30712.951578] ---[ end trace e646bef2de7f0b20 ]---
> 
> -J
> 
> --
> On Fri, Sep 12, 2008 at 02:13:06PM -1000, Joshua Hoblitt wrote:
> > I just rolled out -rc5 from netdev + Andrew's debug patch + the HPET
> > patch Thomas pointed me at.  I'll let it roast on these 14 machine is
> > production over the weekend to see if we get another panic.
> > 
> > I'm attaching the dmesg from this kernel.  We're still getting the NMI
> > watchdog warning and the rtc is [still] hosed (I think it was last
> > working around -rc3).
> > 
> > -J
> > 
> > --
> > On Fri, Sep 12, 2008 at 11:13:08AM +0200, Ingo Molnar wrote:
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > I can't work out who called panic(), nor why.
> > > > 
> > > > The panic code called the kexec code which called mutex_trylock() 
> > > > which called spin_lock_mutex() which then stupidly went and blurted a 
> > > > load of debug stuff because of in_interrupt().
> > > 
> > > agreed - applied your fix in the form below to tip/master - thanks 
> > > Andrew.
> > > 
> > > J, you might want to try tip/master, it includes all known fixes for 
> > > this area and this debug improvement as well. You can pick it up via:
> > > 
> > >   http://people.redhat.com/mingo/tip.git/README
> > > 
> > > 	Ingo
> > > 
> > > ---------->
> > > >From 53b9d87f41a3d8838210ad7cdef02d814817ce85 Mon Sep 17 00:00:00 2001
> > > From: Andrew Morton <akpm@linux-foundation.org>
> > > Date: Thu, 11 Sep 2008 17:02:58 -0700
> > > Subject: [PATCH] lock debug: sit tight when we are already in a panic
> > > 
> > > in:
> > > 
> > >   > http://bugzilla.kernel.org/show_bug.cgi?id=11543
> > > 
> > > The panic code called the kexec code which called mutex_trylock() which
> > > called spin_lock_mutex() which then stupidly went and blurted a load of
> > > debug stuff because of in_interrupt().
> > > 
> > > Keep the lock debug code from escallating an already crappy situation.
> > > 
> > > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >  include/linux/debug_locks.h |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
> > > index 4aaa4af..096476f 100644
> > > --- a/include/linux/debug_locks.h
> > > +++ b/include/linux/debug_locks.h
> > > @@ -17,7 +17,7 @@ extern int debug_locks_off(void);
> > >  ({									\
> > >  	int __ret = 0;							\
> > >  									\
> > > -	if (unlikely(c)) {						\
> > > +	if (!oops_in_progress && unlikely(c)) {				\
> > >  		if (debug_locks_off() && !debug_locks_silent)		\
> > >  			WARN_ON(1);					\
> > >  		__ret = 1;						\
> 
> > [    0.000000] Initializing cgroup subsys cpuset
> > [    0.000000] Linux version 2.6.27-rc4-21704-gd25e26b (root@ipp000) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #1 SMP Tue Sep 2 16:05:45 HST 2008
> > [    0.000000] Command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc nmi_watchdog=1 show_msr=1 console=tty0 console=ttyS0,115200n8
> > [    0.000000] KERNEL supported cpus:
> > [    0.000000]   Intel GenuineIntel
> > [    0.000000]   AMD AuthenticAMD
> > [    0.000000]   Centaur CentaurHauls
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
> > [    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000000ce000 - 0000000000100000 (reserved)
> > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
> > [    0.000000]  BIOS-e820: 00000000cff60000 - 00000000cff6a000 (ACPI data)
> > [    0.000000]  BIOS-e820: 00000000cff6a000 - 00000000cff80000 (ACPI NVS)
> > [    0.000000]  BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> > [    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
> > [    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x3ffffffff
> > [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> > [    0.000000] last_pfn = 0xcff60 max_arch_pfn = 0x3ffffffff
> > [    0.000000] init_memory_mapping
> > [    0.000000]  0000000000 - 00cfe00000 page 2M
> > [    0.000000]  00cfe00000 - 00cff60000 page 4k
> > [    0.000000] kernel direct mapping tables up to cff60000 @ 8000-e000
> > [    0.000000] last_map_addr: cff60000 end: cff60000
> > [    0.000000] init_memory_mapping
> > [    0.000000]  0100000000 - 0230000000 page 2M
> > [    0.000000] kernel direct mapping tables up to 230000000 @ c000-16000
> > [    0.000000] last_map_addr: 230000000 end: 230000000
> > [    0.000000] RAMDISK: 37e0f000 - 37fef7dc
> > [    0.000000] DMI present.
> > [    0.000000] ACPI: RSDP 000F75D0, 0024 (r2 PTLTD )
> > [    0.000000] ACPI: XSDT CFF656FA, 0064 (r1 PTLTD  	 XSDT    6040000  LTP        0)
> > [    0.000000] ACPI: FACP CFF6970E, 00F4 (r3 NVIDIA CK8S      6040000 PTL_    F4240)
> > [    0.000000] ACPI: DSDT CFF6575E, 3F3C (r1 NVIDIA      CK8  6040000 MSFT  3000000)
> > [    0.000000] ACPI: FACS CFF6AFC0, 0040
> > [    0.000000] ACPI: SSDT CFF69802, 0574 (r1 AMD    POWERNOW  6040000 AMD         1)
> > [    0.000000] ACPI: SRAT CFF69D76, 0110 (r1 AMD    HAMMER    6040000 AMD         1)
> > [    0.000000] ACPI: SPCR CFF69E86, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
> > [    0.000000] ACPI: MCFG CFF69ED6, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
> > [    0.000000] ACPI: HPET CFF69F12, 0038 (r1 PTLTD  HPETTBL   6040000  LTP        1)
> > [    0.000000] ACPI: APIC CFF69F4A, 008E (r1 PTLTD  	 APIC    6040000  LTP        0)
> > [    0.000000] ACPI: BOOT CFF69FD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
> > [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> > [    0.000000] SRAT: PXM 0 -> APIC 1 -> Node 0
> > [    0.000000] SRAT: PXM 1 -> APIC 2 -> Node 1
> > [    0.000000] SRAT: PXM 1 -> APIC 3 -> Node 1
> > [    0.000000] SRAT: Node 0 PXM 0 0-a0000
> > [    0.000000] SRAT: Node 0 PXM 0 100000-d0000000
> > [    0.000000] SRAT: Node 0 PXM 0 100000000-130000000
> > [    0.000000] SRAT: Node 1 PXM 1 130000000-230000000
> > [    0.000000] NUMA: Allocated memnodemap from 11000 - 15680
> > [    0.000000] NUMA: Using 20 for the hash shift.
> > [    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
> > [    0.000000]   NODE_DATA [0000000000015680 - 000000000002067f]
> > [    0.000000]   bootmap [0000000000021000 -  0000000000046fff] pages 26
> > [    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
> > [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
> > [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
> > [    0.000000]   #2 [0000200000 - 0000f96890]    TEXT DATA BSS ==> [0000200000 - 0000f96890]
> > [    0.000000]   #3 [0037e0f000 - 0037fef7dc]          RAMDISK ==> [0037e0f000 - 0037fef7dc]
> > [    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
> > [    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
> > [    0.000000]   #6 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
> > [    0.000000]   #7 [0000011000 - 0000015680]       MEMNODEMAP ==> [0000011000 - 0000015680]
> > [    0.000000] Bootmem setup node 1 0000000130000000-0000000230000000
> > [    0.000000]   NODE_DATA [0000000130000000 - 000000013000afff]
> > [    0.000000]   bootmap [000000013000b000 -  000000013002afff] pages 20
> > [    0.000000] (8 early reservations) ==> bootmem [0130000000 - 0230000000]
> > [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page
> > [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE
> > [    0.000000]   #2 [0000200000 - 0000f96890]    TEXT DATA BSS
> > [    0.000000]   #3 [0037e0f000 - 0037fef7dc]          RAMDISK
> > [    0.000000]   #4 [000009dc00 - 0000100000]    BIOS reserved
> > [    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE
> > [    0.000000]   #6 [000000c000 - 0000011000]          PGTABLE
> > [    0.000000]   #7 [0000011000 - 0000015680]       MEMNODEMAP
> > [    0.000000] found SMP MP-table at [ffff8800000f7600] 000f7600
> > [    0.000000]  [ffffe20000000000-ffffe200071fffff] PMD -> [ffff880028200000-ffff88002e1fffff] on node 0
> > [    0.000000]  [ffffe20007200000-ffffe2000d1fffff] PMD -> [ffff880130200000-ffff8801361fffff] on node 1
> > [    0.000000] Zone PFN ranges:
> > [    0.000000]   DMA      0x00000000 -> 0x00001000
> > [    0.000000]   DMA32    0x00001000 -> 0x00100000
> > [    0.000000]   Normal   0x00100000 -> 0x00230000
> > [    0.000000] Movable zone start PFN for each node
> > [    0.000000] early_node_map[4] active PFN ranges
> > [    0.000000]     0: 0x00000000 -> 0x0000009d
> > [    0.000000]     0: 0x00000100 -> 0x000cff60
> > [    0.000000]     0: 0x00100000 -> 0x00130000
> > [    0.000000]     1: 0x00130000 -> 0x00230000
> > [    0.000000] On node 0 totalpages: 1048317
> > [    0.000000]   DMA zone: 307 pages, LIFO batch:0
> > [    0.000000]   DMA32 zone: 823232 pages, LIFO batch:31
> > [    0.000000]   Normal zone: 192000 pages, LIFO batch:31
> > [    0.000000] On node 1 totalpages: 1048576
> > [    0.000000]   Normal zone: 1024000 pages, LIFO batch:31
> > [    0.000000] Detected use of extended apic ids on hypertransport bus
> > [    0.000000] Detected use of extended apic ids on hypertransport bus
> > [    0.000000] ACPI: PM-Timer IO Port: 0x1008
> > [    0.000000] ACPI: Local APIC address 0xfee00000
> > [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> > [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> > [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> > [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> > [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> > [    0.000000] ACPI: IRQ0 used by override.
> > [    0.000000] ACPI: IRQ2 used by override.
> > [    0.000000] ACPI: IRQ9 used by override.
> > [    0.000000] Setting APIC routing to flat
> > [    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
> > [    0.000000] Using ACPI (MADT) for SMP configuration information
> > [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> > [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> > [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> > [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ce000
> > [    0.000000] PM: Registered nosave memory: 00000000000ce000 - 0000000000100000
> > [    0.000000] PM: Registered nosave memory: 00000000cff60000 - 00000000cff6a000
> > [    0.000000] PM: Registered nosave memory: 00000000cff6a000 - 00000000cff80000
> > [    0.000000] PM: Registered nosave memory: 00000000cff80000 - 00000000d0000000
> > [    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
> > [    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
> > [    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
> > [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
> > [    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
> > [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> > [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000fff80000
> > [    0.000000] PM: Registered nosave memory: 00000000fff80000 - 0000000100000000
> > [    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
> > [    0.000000] PERCPU: Allocating 51872 bytes of per cpu data
> > [    0.000000] NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 2
> > [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2039539
> > [    0.000000] Policy zone: Normal
> > [    0.000000] Kernel command line: root=/dev/ram0 real_root=/dev/sda3 init=/linuxrc nmi_watchdog=1 show_msr=1 console=tty0 console=ttyS0,115200n8
> > [    0.000000] Initializing CPU#0
> > [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> > [    0.000000] Extended CMOS year: 2000
> > [    0.000000] TSC calibrated against PM_TIMER
> > [    0.000000] Detected 2800.009 MHz processor.
> > [    0.003333] spurious 8259A interrupt: IRQ7.
> > [    0.003333] Console: colour VGA+ 80x25
> > [    0.003333] console [tty0] enabled
> > [    0.003333] console [ttyS0] enabled
> > [    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> > [    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
> > [    0.003333] ... MAX_LOCK_DEPTH:          48
> > [    0.003333] ... MAX_LOCKDEP_KEYS:        8191
> > [    0.003333] ... CLASSHASH_SIZE:           4096
> > [    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
> > [    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
> > [    0.003333] ... CHAINHASH_SIZE:          8192
> > [    0.003333]  memory used by lock dependency info: 3839 kB
> > [    0.003333]  per task-struct memory footprint: 1920 bytes
> > [    0.003333] Checking aperture...
> > [    0.003333] No AGP bridge found
> > [    0.003333] Node 0: aperture @ 0 size 32 MB
> > [    0.003333] Your BIOS doesn't leave a aperture memory hole
> > [    0.003333] Please enable the IOMMU option in the BIOS setup
> > [    0.003333] This costs you 64 MB of RAM
> > [    0.003333] Mapping aperture over 65536 KB of RAM @ 20000000
> > [    0.003333] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
> > [    0.003333] Memory: 8108304k/9175040k available (3896k kernel code, 279268k reserved, 2243k data, 676k init)
> > [    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
> > [    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
> > [    0.003333] hpet clockevent registered
> > [    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 5602.35 BogoMIPS (lpj=9333363)
> > [    0.006698] Security Framework initialized
> > [    0.010737] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> > [    0.018937] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
> > [    0.025421] Mount-cache hash table entries: 256
> > [    0.026974] Initializing cgroup subsys ns
> > [    0.030010] Initializing cgroup subsys cpuacct
> > [    0.033335] Initializing cgroup subsys memory
> > [    0.036674] Initializing cgroup subsys devices
> > [    0.040006] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > [    0.043332] CPU: L2 Cache: 1024K (64 bytes/line)
> > [    0.046666] CPU 0/0 -> Node 0
> > [    0.049999] tseg: 00cff80000
> > [    0.050000] CPU: Physical Processor ID: 0
> > [    0.053331] CPU: Processor Core ID: 0
> > [    0.056670] using C1E aware idle routine
> > [    0.060018] ACPI: Core revision 20080609
> > [    0.070530] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > [    0.108872] activating NMI Watchdog ... done.
> > [    0.109994] CPU0: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
> > [    0.116660] Using local APIC timer interrupts.
> > [    0.123326] APIC timer calibration result 12500076
> > [    0.123328] Detected 12.500 MHz APIC timer.
> > [    0.126660] APIC timer registered as dummy, due to nmi_watchdog=1!
> > [    0.130154] lockdep: fixing up alternatives.
> > [    0.133347] Booting processor 1/1 ip 6000
> > [    0.003333] Initializing CPU#1
> > [    0.003333] Calibrating delay using timer specific routine.. 5602.36 BogoMIPS (lpj=9333385)
> > [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > [    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
> > [    0.003333] CPU 1/1 -> Node 0
> > [    0.003333] CPU: Physical Processor ID: 0
> > [    0.003333] CPU: Processor Core ID: 1
> > [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> > [    0.230372] CPU1: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
> > [    0.238145] lockdep: fixing up alternatives.
> > [    0.239999] Booting processor 2/2 ip 6000
> > [    0.003333] Initializing CPU#2
> > [    0.003333] Calibrating delay using timer specific routine.. 5602.44 BogoMIPS (lpj=9333513)
> > [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > [    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
> > [    0.003333] CPU 2/2 -> Node 1
> > [    0.003333] CPU: Physical Processor ID: 1
> > [    0.003333] CPU: Processor Core ID: 0
> > [    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
> > [    0.340530] CPU2: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
> > [    0.348138] lockdep: fixing up alternatives.
> > [    0.349997] Booting processor 3/3 ip 6000
> > [    0.003333] Initializing CPU#3
> > [    0.003333] Calibrating delay using timer specific routine.. 5602.48 BogoMIPS (lpj=9333575)
> > [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> > [    0.003333] CPU: L2 Cache: 1024K (64 bytes/line)
> > [    0.003333] CPU 3/3 -> Node 1
> > [    0.003333] CPU: Physical Processor ID: 1
> > [    0.003333] CPU: Processor Core ID: 1
> > [    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
> > [    0.447118] CPU3: Dual-Core AMD Opteron(tm) Processor 2220 stepping 03
> > [    0.454734] Brought up 4 CPUs
> > [    0.456640] Total of 4 processors activated (22409.64 BogoMIPS).
> > [    0.460033] Testing NMI watchdog ... 
> > [    0.532432] WARNING: CPU#0: NMI appears to be stuck (0->0)!
> > [    0.533301] Please report this to bugzilla.kernel.org,
> > [    0.536635] and attach the output of the 'dmesg' command.
> > [    0.539968] 
> > [    0.543302] WARNING: CPU#1: NMI appears to be stuck (0->0)!
> > [    0.546635] Please report this to bugzilla.kernel.org,
> > [    0.549968] and attach the output of the 'dmesg' command.
> > [    0.553301] 
> > [    0.554980] WARNING: CPU#2: NMI appears to be stuck (0->0)!
> > [    0.556635] Please report this to bugzilla.kernel.org,
> > [    0.559968] and attach the output of the 'dmesg' command.
> > [    0.563301] 
> > [    0.566635] WARNING: CPU#3: NMI appears to be stuck (0->0)!
> > [    0.569968] Please report this to bugzilla.kernel.org,
> > [    0.573301] and attach the output of the 'dmesg' command.
> > [    0.577183] net_namespace: 968 bytes
> > [    0.580160] xor: automatically using best checksumming function: generic_sse
> > [    0.599969]    generic_sse:  8630.400 MB/sec
> > [    0.603302] xor: using function: generic_sse (8630.400 MB/sec)
> > [    0.606692] NET: Registered protocol family 16
> > [    0.610254] No dock devices found.
> > [    0.613503] node 0 link 2: io port [1000, 3fff]
> > [    0.613506] TOM: 00000000d0000000 aka 3328M
> > [    0.616636] node 0 link 2: mmio [d0000000, dfffffff]
> > [    0.616638] node 0 link 2: mmio [a0000, bffff]
> > [    0.616640] node 0 link 2: mmio [e0000000, e7ffffff]
> > [    0.616643] TOM2: 0000000230000000 aka 8960M
> > [    0.619969] bus: [00,ff] on node 0 link 2
> > [    0.619970] bus: 00 index 0 io port: [0, ffff]
> > [    0.619972] bus: 00 index 1 mmio: [d0000000, ffffffff]
> > [    0.619974] bus: 00 index 2 mmio: [a0000, bffff]
> > [    0.619975] bus: 00 index 3 mmio: [230000000, fcffffffff]
> > [    0.619989] ACPI: bus type pci registered
> > [    0.623448] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 4
> > [    0.626636] PCI: MCFG area at e0000000 reserved in E820
> > [    0.630065] PCI: Using MMCONFIG at e0000000 - e04fffff
> > [    0.633302] PCI: Using configuration type 1 for base access
> > [    0.643980] ACPI: EC: Look up EC in DSDT
> > [    0.648409] ACPI: Interpreter enabled
> > [    0.649969] ACPI: (supports S0 S1 S3 S4 S5)
> > [    0.656635] ACPI: Using IOAPIC for interrupt routing
> > [    0.670034] ACPI: PCI Root Bridge [PCI0] (0000:00)
> > [    0.673616] pci 0000:00:01.1: PME# supported from D3hot D3cold
> > [    0.676644] pci 0000:00:01.1: PME# disabled
> > [    0.680009] pci 0000:00:02.0: supports D1
> > [    0.680010] pci 0000:00:02.0: supports D2
> > [    0.680012] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.683303] pci 0000:00:02.0: PME# disabled
> > [    0.686672] pci 0000:00:02.1: supports D1
> > [    0.686673] pci 0000:00:02.1: supports D2
> > [    0.686675] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.689969] pci 0000:00:02.1: PME# disabled
> > [    0.693535] pci 0000:00:08.0: supports D1
> > [    0.693537] pci 0000:00:08.0: supports D2
> > [    0.693538] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.696637] pci 0000:00:08.0: PME# disabled
> > [    0.700017] pci 0000:00:09.0: supports D1
> > [    0.700019] pci 0000:00:09.0: supports D2
> > [    0.700020] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.703304] pci 0000:00:09.0: PME# disabled
> > [    0.706664] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.709969] pci 0000:00:0a.0: PME# disabled
> > [    0.713331] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.716636] pci 0000:00:0d.0: PME# disabled
> > [    0.719997] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
> > [    0.723302] pci 0000:00:0f.0: PME# disabled
> > [    0.726878] pci 0000:01:04.0: supports D1
> > [    0.726879] pci 0000:01:04.0: supports D2
> > [    0.726904] pci 0000:00:06.0: transparent bridge
> > [    0.729969] PCI: bridge 0000:00:06.0 io port: [3000, 3fff]
> > [    0.733303] PCI: bridge 0000:00:06.0 32bit mmio: [d0100000, d01fffff]
> > [    0.736636] PCI: bridge 0000:00:06.0 32bit mmio pref: [d8000000, dfffffff]
> > [    0.740034] pci 0000:02:00.0: supports D1
> > [    0.740064] PCI: bridge 0000:00:0a.0 32bit mmio: [d0200000, d02fffff]
> > [    0.743388] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> > [    0.743462] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
> > [    0.743486] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
> > [    0.743513] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR2._PRT]
> > [    0.743540] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR5._PRT]
> > [    0.769795] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.777165] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
> > [    0.786790] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.797164] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.808626] ACPI: PCI Interrupt Link [LK1E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.816220] ACPI: PCI Interrupt Link [LK2E] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
> > [    0.822660] ACPI: PCI Interrupt Link [LK3E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.830122] ACPI: PCI Interrupt Link [LK4E] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.840505] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.851950] ACPI: PCI Interrupt Link [LUS0] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
> > [    0.858235] ACPI: PCI Interrupt Link [LMA2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
> > [    0.867922] ACPI: PCI Interrupt Link [LUS2] (IRQs *5 7 10 11 14 15 16 17 18 19 20 21 22 23)
> > [    0.877614] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
> > [    0.887303] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.898166] ACPI: PCI Interrupt Link [LPID] (IRQs 5 7 10 11 14 15 16 17 18 19 20 21 22 23) *0, disabled.
> > [    0.909241] ACPI: PCI Interrupt Link [LTID] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
> > [    0.915682] ACPI: PCI Interrupt Link [LSI1] (IRQs 5 7 *10 11 14 15 16 17 18 19 20 21 22 23)
> > [    0.921892] ACPI: PCI Interrupt Link [LSI2] (IRQs 5 7 10 *11 14 15 16 17 18 19 20 21 22 23)
> > [    0.928367] Linux Plug and Play Support v0.97 (c) Adam Belay
> > [    0.930030] pnp: PnP ACPI init
> > [    0.933313] ACPI: bus type pnp registered
> > [    0.942967] pnp: PnP ACPI: found 15 devices
> > [    0.943302] ACPI: ACPI bus type pnp unregistered
> > [    0.946899] SCSI subsystem initialized
> > [    0.950132] libata version 3.00 loaded.
> > [    0.953483] usbcore: registered new interface driver usbfs
> > [    0.956699] usbcore: registered new interface driver hub
> > [    0.960060] usbcore: registered new device driver usb
> > [    0.963671] PCI: Using ACPI for IRQ routing
> > [    0.980227] PCI-DMA: Disabling AGP.
> > [    0.984431] PCI-DMA: aperture base @ 20000000 size 65536 KB
> > [    0.986635] PCI-DMA: using GART IOMMU.
> > [    0.989971] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> > [    0.993870] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> > [    1.000341] hpet0: 3 32-bit timers, 25000000 Hz
> > [    1.004395] ACPI: RTC can wake from S4
> > [    1.006637] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode: lapic is not functional.
> > [    1.009524] Could not switch to high resolution mode on CPU 3
> > [    1.009528] Clockevents: could not switch to one-shot mode: lapic is not functional.
> > [    1.009531] Could not switch to high resolution mode on CPU 1
> > [    1.009534] Clockevents: could not switch to one-shot mode: lapic is not functional.
> > [    1.009538] Could not switch to high resolution mode on CPU 2
> > [    1.009969]  lapic is not functional.
> > [    1.056944] Could not switch to high resolution mode on CPU 0
> > [    1.076221] system 00:00: iomem range 0xffc00000-0xffffffff could not be reserved
> > [    1.084054] system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
> > [    1.091883] system 00:00: iomem range 0xfee00000-0xfeefffff could not be reserved
> > [    1.099719] system 00:00: iomem range 0xfed00000-0xfed00fff has been reserved
> > [    1.107052] system 00:03: iomem range 0xd0000000-0xd0007fff has been reserved
> > [    1.114383] system 00:04: ioport range 0x1000-0x107f has been reserved
> > [    1.121101] system 00:04: ioport range 0x1080-0x10ff has been reserved
> > [    1.127817] system 00:04: ioport range 0x1400-0x147f has been reserved
> > [    1.134537] system 00:04: ioport range 0x1480-0x14ff has been reserved
> > [    1.141258] system 00:04: ioport range 0x1800-0x187f has been reserved
> > [    1.147976] system 00:04: ioport range 0x1880-0x18ff has been reserved
> > [    1.154698] system 00:04: ioport range 0x2440-0x247f has been reserved
> > [    1.161420] system 00:04: ioport range 0x2400-0x243f has been reserved
> > [    1.168151] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
> > [    1.174695] system 00:07: ioport range 0xc05-0xc06 has been reserved
> > [    1.182277] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
> > [    1.188388] pci 0000:00:06.0:   IO window: 0x3000-0x3fff
> > [    1.193889] pci 0000:00:06.0:   MEM window: 0xd0100000-0xd01fffff
> > [    1.200176] pci 0000:00:06.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
> > [    1.208089] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
> > [    1.214205] pci 0000:00:0a.0:   IO window: disabled
> > [    1.219275] pci 0000:00:0a.0:   MEM window: 0xd0200000-0xd02fffff
> > [    1.225558] pci 0000:00:0a.0:   PREFETCH window: 0x000000d1000000-0x000000d10fffff
> > [    1.233474] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:03
> > [    1.239598] pci 0000:00:0d.0:   IO window: disabled
> > [    1.244666] pci 0000:00:0d.0:   MEM window: disabled
> > [    1.249825] pci 0000:00:0d.0:   PREFETCH window: disabled
> > [    1.255416] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:04
> > [    1.261525] pci 0000:00:0f.0:   IO window: disabled
> > [    1.266594] pci 0000:00:0f.0:   MEM window: disabled
> > [    1.271751] pci 0000:00:0f.0:   PREFETCH window: disabled
> > [    1.277347] pci 0000:00:06.0: setting latency timer to 64
> > [    1.277352] pci 0000:00:0a.0: setting latency timer to 64
> > [    1.277357] pci 0000:00:0d.0: setting latency timer to 64
> > [    1.277363] pci 0000:00:0f.0: setting latency timer to 64
> > [    1.277365] bus: 00 index 0 io port: [0, ffff]
> > [    1.282004] bus: 00 index 1 mmio: [0, ffffffffffffffff]
> > [    1.292287] bus: 01 index 0 io port: [3000, 3fff]
> > [    1.297187] bus: 01 index 1 mmio: [d0100000, d01fffff]
> > [    1.302519] bus: 01 index 2 mmio: [d8000000, dfffffff]
> > [    1.307849] bus: 01 index 3 io port: [0, ffff]
> > [    1.312483] bus: 01 index 4 mmio: [0, ffffffffffffffff]
> > [    1.317900] bus: 02 index 0 mmio: [0, 0]
> > [    1.322017] bus: 02 index 1 mmio: [d0200000, d02fffff]
> > [    1.327349] bus: 02 index 2 mmio: [d1000000, d10fffff]
> > [    1.332678] bus: 02 index 3 mmio: [0, 0]
> > [    1.336793] bus: 03 index 0 mmio: [0, 0]
> > [    1.340910] bus: 03 index 1 mmio: [0, 0]
> > [    1.345025] bus: 03 index 2 mmio: [0, 0]
> > [    1.349142] bus: 03 index 3 mmio: [0, 0]
> > [    1.353256] bus: 04 index 0 mmio: [0, 0]
> > [    1.357374] bus: 04 index 1 mmio: [0, 0]
> > [    1.361490] bus: 04 index 2 mmio: [0, 0]
> > [    1.365609] bus: 04 index 3 mmio: [0, 0]
> > [    1.369739] NET: Registered protocol family 2
> > [    1.413137] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
> > [    1.423160] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> > [    1.436206] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
> > [    1.445874] TCP: Hash tables configured (established 524288 bind 65536)
> > [    1.452716] TCP reno registered
> > [    1.466350] NET: Registered protocol family 1
> > [    1.471023] checking if image is initramfs... it is
> > [    1.572646] Freeing initrd memory: 1921k freed
> > [    1.578336] Simple Boot Flag at 0x37 set to 0x80
> > [    1.585905] audit: initializing netlink socket (disabled)
> > [    1.591560] type=2000 audit(1221176947.589:1): initialized
> > [    1.602577] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> > [    1.613210] VFS: Disk quotas dquot_6.5.1
> > [    1.617471] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> > [    1.625780] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > [    1.632809] msgmni has been set to 15840
> > [    1.637191] async_tx: api initialized (async)
> > [    1.641747] io scheduler noop registered
> > [    1.645871] io scheduler anticipatory registered
> > [    1.650694] io scheduler deadline registered
> > [    1.655347] io scheduler cfq registered (default)
> > [    1.660281] pci 0000:00:00.0: Enabling HT MSI Mapping
> > [    1.879582] pci 0000:00:05.0: Enabling HT MSI Mapping
> > [    1.884851] pci 0000:00:05.1: Enabling HT MSI Mapping
> > [    1.890123] pci 0000:00:05.2: Enabling HT MSI Mapping
> > [    1.895393] pci 0000:00:06.0: Enabling HT MSI Mapping
> > [    1.900669] pci 0000:00:08.0: Enabling HT MSI Mapping
> > [    1.905945] pci 0000:00:09.0: Enabling HT MSI Mapping
> > [    1.911213] pci 0000:00:0a.0: Enabling HT MSI Mapping
> > [    1.916486] pci 0000:00:0d.0: Enabling HT MSI Mapping
> > [    1.921761] pci 0000:00:0f.0: Enabling HT MSI Mapping
> > [    1.927029] pci 0000:01:04.0: Boot video device
> > [    1.927212] pcieport-driver 0000:00:0a.0: setting latency timer to 64
> > [    1.927241] pcieport-driver 0000:00:0a.0: found MSI capability
> > [    1.933324] pci_express 0000:00:0a.0:pcie00: allocate port service
> > [    1.933414] pci_express 0000:00:0a.0:pcie01: allocate port service
> > [    1.933475] pci_express 0000:00:0a.0:pcie03: allocate port service
> > [    1.933576] pcieport-driver 0000:00:0d.0: setting latency timer to 64
> > [    1.933604] pcieport-driver 0000:00:0d.0: found MSI capability
> > [    1.939667] pci_express 0000:00:0d.0:pcie00: allocate port service
> > [    1.939741] pci_express 0000:00:0d.0:pcie01: allocate port service
> > [    1.939801] pci_express 0000:00:0d.0:pcie03: allocate port service
> > [    1.939898] pcieport-driver 0000:00:0f.0: setting latency timer to 64
> > [    1.939925] pcieport-driver 0000:00:0f.0: found MSI capability
> > [    1.945977] pci_express 0000:00:0f.0:pcie00: allocate port service
> > [    1.946048] pci_express 0000:00:0f.0:pcie01: allocate port service
> > [    1.946108] pci_express 0000:00:0f.0:pcie03: allocate port service
> > [    1.947934] aer 0000:00:0a.0:pcie01: AER service couldn't init device: no _OSC support
> > [    1.949554] aer 0000:00:0d.0:pcie01: AER service couldn't init device: no _OSC support
> > [    1.951148] aer 0000:00:0f.0:pcie01: AER service couldn't init device: no _OSC support
> > [    1.951606] input: Power Button (FF) as /class/input/input0
> > [    1.957384] ACPI: Power Button (FF) [PWRF]
> > [    1.961801] input: Power Button (CM) as /class/input/input1
> > [    1.967565] ACPI: Power Button (CM) [PWRB]
> > [    1.972294] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > [    1.978363] processor ACPI0007:00: registered as cooling_device0
> > [    1.984576] ACPI: Processor [C000] (supports 2 throttling states)
> > [    1.991063] processor ACPI0007:01: registered as cooling_device1
> > [    1.997366] processor ACPI0007:02: registered as cooling_device2
> > [    2.003684] processor ACPI0007:03: registered as cooling_device3
> > [    2.079999] hpet_resources: 0xfed00000 is busy
> > [    2.080193] Non-volatile memory driver v1.2
> > [    2.084715] Linux agpgart interface v0.103
> > [    2.089107] Serial: 8250/16550 driver4 ports, IRQ sharing disabled
> > [    2.095680] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > [    2.102659] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > [    2.108789] Floppy drive(s): fd0 is 1.44M
> > [    2.130069] FDC 0 is a post-1991 82077
> > [    2.137592] brd: module loaded
> > [    2.142041] loop: module loaded
> > [    2.145379] tun: Universal TUN/TAP device driver, 1.6
> > [    2.150619] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> > [    2.157181] console [netcon0] enabled
> > [    2.161035] netconsole: network logging started
> > [    2.165762] Uniform Multi-Platform E-IDE driver
> > [    2.170615] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
> > [    2.180715] Probing IDE interface ide0...
> > [    3.149712] hdb: CD-224E-N, ATAPI CD/DVD-ROM drive
> > [    3.206282] Probing IDE interface ide1...
> > [    3.739617] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> > [    3.744443] ide1 at 0x170-0x177,0x376 on irq 15
> > [    3.751258] hdb: ATAPI 24X CD-ROM drive, 256kB Cache
> > [    3.756646] Uniform CD-ROM driver Revision: 3.20
> > [    3.771462] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> > [    3.779263] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> > [    3.786512] megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2008
> > [    3.792690] Driver 'sd' needs updating - please use bus_type methods
> > [    3.799315] Driver 'sr' needs updating - please use bus_type methods
> > [    3.806449] sata_nv 0000:00:05.0: version 3.5
> > [    3.806741] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 23
> > [    3.812700] sata_nv 0000:00:05.0: PCI INT A -> Link[LTID] -> GSI 23 (level, low) -> IRQ 23
> > [    3.821311] sata_nv 0000:00:05.0: Using SWNCQ mode
> > [    3.826430] sata_nv 0000:00:05.0: setting latency timer to 64
> > [    3.826613] scsi0 : sata_nv
> > [    3.829796] scsi1 : sata_nv
> > [    3.832986] ata1: SATA max UDMA/133 cmd 0x24d0 ctl 0x24c4 bmdma 0x2490 irq 23
> > [    3.840314] ata2: SATA max UDMA/133 cmd 0x24c8 ctl 0x24c0 bmdma 0x2498 irq 23
> > [    4.179871] ata1: SATA link down (SStatus 0 SControl 300)
> > [    4.516536] ata2: SATA link down (SStatus 0 SControl 300)
> > [    4.522429] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
> > [    4.528388] sata_nv 0000:00:05.1: PCI INT B -> Link[LSI1] -> GSI 22 (level, low) -> IRQ 22
> > [    4.536997] sata_nv 0000:00:05.1: Using SWNCQ mode
> > [    4.542083] sata_nv 0000:00:05.1: setting latency timer to 64
> > [    4.542220] scsi2 : sata_nv
> > [    4.545334] scsi3 : sata_nv
> > [    4.548512] ata3: SATA max UDMA/133 cmd 0x24e8 ctl 0x24dc bmdma 0x24a0 irq 22
> > [    4.555840] ata4: SATA max UDMA/133 cmd 0x24e0 ctl 0x24d8 bmdma 0x24a8 irq 22
> > [    4.896535] ata3: SATA link down (SStatus 0 SControl 300)
> > [    5.233200] ata4: SATA link down (SStatus 0 SControl 300)
> > [    5.239087] ACPI: PCI Interrupt Link [LSI2] enabled at IRQ 21
> > [    5.245047] sata_nv 0000:00:05.2: PCI INT C -> Link[LSI2] -> GSI 21 (level, low) -> IRQ 21
> > [    5.253654] sata_nv 0000:00:05.2: Using SWNCQ mode
> > [    5.258744] sata_nv 0000:00:05.2: setting latency timer to 64
> > [    5.258881] scsi4 : sata_nv
> > [    5.261998] scsi5 : sata_nv
> > [    5.265174] ata5: SATA max UDMA/133 cmd 0x2800 ctl 0x24f4 bmdma 0x24b0 irq 21
> > [    5.272504] ata6: SATA max UDMA/133 cmd 0x24f8 ctl 0x24f0 bmdma 0x24b8 irq 21
> > [    5.613197] ata5: SATA link down (SStatus 0 SControl 300)
> > [    5.949864] ata6: SATA link down (SStatus 0 SControl 300)
> > [    5.955612] pata_amd 0000:00:04.0: version 0.3.10
> > [    5.955640] pata_amd 0000:00:04.0: BAR 0: can't reserve I/O region [0x1f0-0x1f7]
> > [    5.963385] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 0 (errno=-16)
> > [    5.971653] pata_amd 0000:00:04.0: BAR 2: can't reserve I/O region [0x170-0x177]
> > [    5.979396] pata_amd 0000:00:04.0: failed to request/iomap BARs for port 1 (errno=-16)
> > [    5.987656] pata_amd 0000:00:04.0: no available native port
> > [    5.993731] Fusion MPT base driver 3.04.07
> > [    5.998021] Copyright (c) 1999-2008 LSI Corporation
> > [    6.003109] Fusion MPT SPI Host driver 3.04.07
> > [    6.007833] Fusion MPT SAS Host driver 3.04.07
> > [    6.013164] ieee1394: raw1394: /dev/raw1394 device initialized
> > [    6.019695] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
> > [    6.025650] ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUS2] -> GSI 20 (level, low) -> IRQ 20
> > [    6.034353] ehci_hcd 0000:00:02.1: setting latency timer to 64
> > [    6.034355] ehci_hcd 0000:00:02.1: EHCI Host Controller
> > [    6.040002] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
> > [    6.047776] ehci_hcd 0000:00:02.1: debug port 1
> > [    6.052503] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
> > [    6.052521] ehci_hcd 0000:00:02.1: irq 20, io mem 0xd0041000
> > [    6.066176] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> > [    6.074154] usb usb1: configuration #1 chosen from 1 choice
> > [    6.080016] hub 1-0:1.0: USB hub found
> > [    6.083976] hub 1-0:1.0: 10 ports detected
> > [    6.189886] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> > [    6.190142] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 19
> > [    6.196100] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUS0] -> GSI 19 (level, low) -> IRQ 19
> > [    6.204801] ohci_hcd 0000:00:02.0: setting latency timer to 64
> > [    6.204804] ohci_hcd 0000:00:02.0: OHCI Host Controller
> > [    6.210376] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> > [    6.218132] ohci_hcd 0000:00:02.0: irq 19, io mem 0xd0040000
> > [    6.278315] usb usb2: configuration #1 chosen from 1 choice
> > [    6.284165] hub 2-0:1.0: USB hub found
> > [    6.288118] hub 2-0:1.0: 10 ports detected
> > [    6.393142] USB Universal Host Controller Interface driver v3.0
> > [    6.399423] usbcore: registered new interface driver usblp
> > [    6.405107] Initializing USB Mass Storage driver...
> > [    6.410243] usbcore: registered new interface driver usb-storage
> > [    6.416443] USB Mass Storage support registered.
> > [    6.421406] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
> > [    6.679856] serio: i8042 KBD port at 0x60,0x64 irq 1
> > [    6.685238] mice: PS/2 mouse device common for all mice
> > [    6.877983] md: linear personality registered for level -1
> > [    6.883663] md: raid0 personality registered for level 0
> > [    6.889166] md: raid1 personality registered for level 1
> > [    6.894669] md: raid10 personality registered for level 10
> > [    6.956180] raid6: int64x1   2587 MB/s
> > [    7.016180] raid6: int64x2   3291 MB/s
> > [    7.076168] raid6: int64x4   3160 MB/s
> > [    7.136168] raid6: int64x8   2360 MB/s
> > [    7.196178] raid6: sse2x1    3858 MB/s
> > [    7.256175] raid6: sse2x2    5139 MB/s
> > [    7.316176] raid6: sse2x4    5262 MB/s
> > [    7.320122] raid6: using algorithm sse2x4 (5262 MB/s)
> > [    7.325365] md: raid6 personality registered for level 6
> > [    7.335744] md: raid5 personality registered for level 5
> > [    7.341252] md: raid4 personality registered for level 4
> > [    7.346753] md: multipath personality registered for level -4
> > [    7.352960] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
> > [    7.361877] cpuidle: using governor ladder
> > [    7.366402] cpuidle: using governor menu
> > [    7.370591] usbcore: registered new interface driver usbhid
> > [    7.376362] usbhid: v2.6:USB HID core driver
> > [    7.380936] oprofile: using NMI interrupt.
> > [    7.385695] TCP cubic registered
> > [    7.389332] NET: Registered protocol family 10
> > [    7.394985] IPv6 over IPv4 tunneling driver
> > [    7.400135] NET: Registered protocol family 17
> > [    7.405122] RPC: Registered udp transport module.
> > [    7.410021] RPC: Registered tcp transport module.
> > [    7.415002] powernow-k8: Found 2 Dual-Core AMD Opteron(tm) Processor 2220 processors (4 cpu cores) (version 2.20.00)
> > [    7.425975] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
> > [    7.431831] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
> > [    7.437687] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
> > [    7.443537] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
> > [    7.449301] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
> > [    7.455149] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
> > [    7.460999] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
> > [    7.467050] powernow-k8:    0 : fid 0x14 (2800 MHz), vid 0x8
> > [    7.472929] powernow-k8:    1 : fid 0x12 (2600 MHz), vid 0xa
> > [    7.478785] powernow-k8:    2 : fid 0x10 (2400 MHz), vid 0xc
> > [    7.484637] powernow-k8:    3 : fid 0xe (2200 MHz), vid 0xe
> > [    7.490411] powernow-k8:    4 : fid 0xc (2000 MHz), vid 0x10
> > [    7.496279] powernow-k8:    5 : fid 0xa (1800 MHz), vid 0x10
> > [    7.502134] powernow-k8:    6 : fid 0x2 (1000 MHz), vid 0x12
> > [    7.508739] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> > [    7.515289] Freeing unused kernel memory: 676k freed
> > [    7.520818] Write protecting the kernel read-only data: 5672k
> > [    7.742843] Clocksource tsc unstable (delta = -111149082 ns)
> > [    8.177545] ACPI: PCI Interrupt Link [LK3E] enabled at IRQ 18
> > [    8.177654] arcmsr 0000:02:00.0: PCI INT A -> Link[LK3E] -> GSI 18 (level, low) -> IRQ 18
> > [    8.177666] arcmsr 0000:02:00.0: setting latency timer to 64
> > [    8.189529] ARECA RAID ADAPTER6: FIRMWARE VERSION V1.44 2008-1-31  
> > [    8.202850] scsi6 : Areca SATA Host Adapter RAID Controller( RAID6 capable)
> > [    8.202853]  Driver Version 1.20.00.15 2008/02/27
> > [    8.205018] scsi 6:0:0:0: Direct-Access     Areca    ARC-1280-VOL#00  R001 PQ: 0 ANSI: 5
> > [    8.207052] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
> > [    8.207117] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
> > [    8.207182] sd 6:0:0:0: [sda] Write Protect is off
> > [    8.207188] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
> > [    8.207298] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    8.207560] sd 6:0:0:0: [sda] Very big device. Trying to use READ CAPACITY(16).
> > [    8.207621] sd 6:0:0:0: [sda] 21484367872 512-byte hardware sectors (10999996 MB)
> > [    8.207685] sd 6:0:0:0: [sda] Write Protect is off
> > [    8.207692] sd 6:0:0:0: [sda] Mode Sense: cb 00 00 08
> > [    8.207802] sd 6:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [    8.207811]  sda: sda1 sda2 sda3 sda4
> > [    8.245400] sd 6:0:0:0: [sda] Attached SCSI disk
> > [    8.247390] sd 6:0:0:0: Attached scsi generic sg0 type 0
> > [    8.249720] scsi 6:0:16:0: Processor         Areca    RAID controller  R001 PQ: 0 ANSI: 0
> > [    8.252259] scsi 6:0:16:0: Attached scsi generic sg1 type 3
> > [    8.504889] 3ware Storage Controller device driver for Linux v1.26.02.002.
> > [    8.542592] 3ware 9000 Storage Controller device driver for Linux v2.26.02.011.
> > [    8.601009] Adaptec aacraid driver 1.1-5[2456]-ms
> > [    8.993029] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> > [    8.998828] SGI XFS Quota Management subsystem
> > [    9.048982] Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> > [    9.048990] Copyright (c) 1999-2006 Intel Corporation.
> > [   12.346739] EXT3-fs: INFO: recovery required on readonly filesystem.
> > [   12.346748] EXT3-fs: write access will be enabled during recovery.
> > [   13.161202] kjournald starting.  Commit interval 5 seconds
> > [   13.161240] EXT3-fs: sda3: orphan cleanup on readonly fs
> > [   13.161256] ext3_orphan_cleanup: deleting unreferenced inode 2501876
> > [   13.161508] ext3_orphan_cleanup: deleting unreferenced inode 2501875
> > [   13.161529] ext3_orphan_cleanup: deleting unreferenced inode 2501874
> > [   13.161549] ext3_orphan_cleanup: deleting unreferenced inode 2501873
> > [   13.161565] EXT3-fs: sda3: 4 orphan inodes deleted
> > [   13.161570] EXT3-fs: recovery complete.
> > [   13.162085] EXT3-fs: mounted filesystem with ordered data mode.
> > [   15.634222] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2440
> > [   15.634257] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2400
> > [   15.660203] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
> > [   15.660582] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 17
> > [   15.660659] forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 17 (level, low) -> IRQ 17
> > [   15.660663] forcedeth 0000:00:08.0: setting latency timer to 64
> > [   15.663568] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 0, addr 00:e0:81:76:8b:be
> > [   15.663571] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
> > [   15.663876] ACPI: PCI Interrupt Link [LMA2] enabled at IRQ 16
> > [   15.663898] forcedeth 0000:00:09.0: PCI INT A -> Link[LMA2] -> GSI 16 (level, low) -> IRQ 16
> > [   15.663923] forcedeth 0000:00:09.0: setting latency timer to 64
> > [   15.665255] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:76:8b:bf
> > [   15.665257] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
> > [   18.107517] EXT3 FS on sda3, internal journal
> > [   18.380032] SMsC 37B787 watchdog component driver 1.1 initialising...
> > [   18.381424] smsc37b787_wdt: Timeout set to 60 second(s).
> > [   18.381429] smsc37b787_wdt: Watchdog initialized and sleeping (nowayout=0)...
> > [   21.417259] kjournald starting.  Commit interval 5 seconds
> > [   21.417297] EXT3-fs warning: checktime reached, running e2fsck is recommended
> > [   21.422349] EXT3 FS on sda4, internal journal
> > [   21.422359] EXT3-fs: recovery complete.
> > [   21.422430] EXT3-fs: mounted filesystem with ordered data mode.
> > [   21.501039] Adding 15999992k swap on /dev/sda2.  Priority:-1 extents:1 across:15999992k
> > [   42.038582] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> > [   42.045903] NFSD: starting 90-second grace period
> > [   45.396027] eth0: no IPv6 routers present
> > [   49.761642] w83627hf: Found W83627HF chip at 0xc00
> 
