Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZKKKR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZKKKR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZKKKR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:17:58 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:56787 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZKKKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:17:57 -0500
Date: Wed, 11 Nov 2009 11:18:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [BUG] sched_rt_periodic_timer vs cpu hotplug
Message-ID: <20091111101801.GA19103@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

we've seen a crash on s390 which seems to be related to sched_rt_period_timer vs.
cpu hotplug:

    <1>Unable to handle kernel pointer dereference at virtual kernel address 00000000ff5ec000
    <4>Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    <4>Modules linked in: sunrpc qeth_l2 dm_multipath dm_mod chsc_sch qeth ccwgroup
    <4>CPU: 9 Not tainted 2.6.31-39.x.20090916-s390xdefault #1
    <4>Process swapper (pid: 0, task: 00000000ffc8ca40, ksp: 00000000ffc93d48)
    <4>Krnl PSW : 0404200180000000 000000000013952c (sched_rt_period_timer+0x188/0x3d8)
    <4>           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
    <4>Krnl GPRS: ffffffffffffffff ffffffffffffff80 00000000ff5ec000 0000000000000008
    <4>           0000000000000000 0000000000000040 0000000000000001 0000000000a7db58
    <4>           0000000087139db8 0000000087da6500 0000000000000000 0000000000000007
    <4>           00000000ff5ec008 0000000000598cc8 00000000001394d0 00000000ff7b7968
    <4>Krnl Code: 000000000013951c: a709ffff            lghi    %r0,-1
    <4>           0000000000139520: eb102000000d        sllg    %r1,%r0,0(%r2)
    <4>           0000000000139526: e320f0b80004        lg      %r2,184(%r15)
    <4>          >000000000013952c: e31320000080        ng      %r1,0(%r3,%r2)
    <4>           0000000000139532: 1211                ltr     %r1,%r1
    <4>           0000000000139534: a78400ff            brc     8,139732
    <4>           0000000000139538: a7290000            lghi    %r2,0
    <4>           000000000013953c: a711ffff            tmll    %r1,65535
    <4>Call Trace:
    <4>([<00000000001394d0>] sched_rt_period_timer+0x12c/0x3d8)
    <4> [<0000000000173db0>] __run_hrtimer+0xb0/0x110
    <4> [<00000000001740b2>] hrtimer_interrupt+0xf2/0x1e8
    <4> [<000000000010770c>] clock_comparator_work+0x68/0x70
    <4> [<000000000010dbc0>] do_extint+0x18c/0x190
    <4> [<0000000000117f9e>] ext_no_vtime+0x1e/0x22
    <4> [<000000000058ea04>] _spin_unlock_irq+0x48/0x80
    <4>([<000000000058ea00>] _spin_unlock_irq+0x44/0x80)
    <4> [<000000000043c190>] dasd_block_tasklet+0x1b8/0x2b0
    <4> [<0000000000155b0e>] tasklet_hi_action+0xfe/0x1f4
    <4> [<00000000001570d4>] __do_softirq+0x184/0x2e8
    <4> [<0000000000110b34>] do_softirq+0xe4/0xe8
    <4> [<0000000000156ac4>] irq_exit+0xc0/0xe0
    <4> [<000000000010db7a>] do_extint+0x146/0x190
    <4> [<0000000000117f9e>] ext_no_vtime+0x1e/0x22
    <4> [<0000000000115040>] vtime_stop_cpu+0xac/0x100
    <4>([<0000000000114fe6>] vtime_stop_cpu+0x52/0x100)
    <4> [<000000000010a324>] cpu_idle+0xfc/0x198
    <4> [<0000000000584a64>] start_secondary+0xb4/0xc0

sched_rt_period_timer tried to access a memory region which was unmapped from
the kernel 1:1 mapping. So we seem to have a use-after-free bug.

The C code snippet in question, which seems to cause the addressing exception is:

static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
{
	int i, idle = 1;
	const struct cpumask *span;

	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
		return 1;

	span = sched_rt_period_mask();
	for_each_cpu(i, span) {   <------ read access to root_domain of runqueue
		int enqueue = 0;
...

with

static inline const struct cpumask *sched_rt_period_mask(void)
{
	return cpu_rq(smp_processor_id())->rd->span;
}

The read access to the span cpumask within the root_domain caused the exception.

Now since DEBUG_PAGEALLOC is turned on we can easily see who freed the piece of
memory since it contains a backtrace:

0x13caca <cpu_attach_domain+482>
0x1418fe <partition_sched_domains+350>
0x141d90 <update_sched_domains+100>
0x5915a6 <notifier_call_chain+150>
0x17666c <raw_notifier_call_chain+44>
0x585b74 <_cpu_up+436>
0x585c3a <cpu_up+186>
0x58336a <store_online+146>
0x29cfa4 <sysfs_write_file+248>
0x228b60 <SyS_write>

cpu_attach_domain calls (inlined) rq_attach_root. That function replaces a
runqueue's root_domain while holding its lock (&rq->lock).

Now the code snippet above from do_sched_rt_period_timer does access a
runqueue's root_domain _without_ holding its lock.
That way a concurrent cpu_up operation can easily change a runqueue's
root_domain pointer while it is still in use. Which is what happened here.

Just grabbing and releasing the lock for each iteration is probably not the
real fix, since the span mask could change between iterations. Which might
lead to strange effects.
