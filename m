Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbZHGOaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbZHGOaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZHGOaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:30:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48492 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbZHGOaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:30:08 -0400
Date: Fri, 7 Aug 2009 07:29:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, manfred@colorfullife.com
Subject: Re: [BUG] race of RCU vs NOHU
Message-ID: <20090807142957.GB6700@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090807151529.2806b8b4@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807151529.2806b8b4@skybase>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 03:15:29PM +0200, Martin Schwidefsky wrote:
> Hi Paul,
> I analysed a dump of a hanging 2.6.30 system and found what I think is
> a bug of RCU vs NOHZ. There are a number of patches ontop of that
> kernel but they should be independent of the bug.
> 
> The systems has 4 cpus and uses classic RCU. cpus #0, #2 and #3 woke up
> recently, cpu #1 has been sleeping for 5 minutes, but there is a pending
> rcu batch. The timer wheel for cpu #1 is empty, it will continue to
> sleep for NEXT_TIMER_MAX_DELTA ticks.

Congratulations, Martin!  You have exercised what to date has been a
theoretical bug identified last year by Manfred Spraul.  The fix is to
switch from CONFIG_RCU_CLASSIC to CONFIG_RCU_TREE, which was added in
2.6.29.

Of course, if you need to work with an old kernel version, you might
still need a patch, perhaps for the various -stable versions.  If so,
please let me know -- otherwise, I will focus forward on CONFIG_RCU_TREE
rather than backwards on CONFIG_RCU_CLASSIC.

							Thanx, Paul

> Now if I look at the RCU data structures I find this:
> 
> rcu_ctrlblk
> >> px *(struct rcu_ctrlblk *) 0x810000
> struct rcu_ctrlblk {
>         cur = 0xffffffffffffff99
>         completed = 0xffffffffffffff98
>         pending = 0xffffffffffffff99
>         signaled = 0x0
>         lock = spinlock_t {
>                 raw_lock = raw_spinlock_t {
>                         owner_cpu = 0x0
>                 }
>                 break_lock = 0x0
>                 magic = 0xdead4ead
>                 owner_cpu = 0xffffffff
>                 owner = 0xffffffffffffffff
>                 dep_map = struct lockdep_map {
>                         key = 0x810118
>                         class_cache = 0xcbcff0
>                         name = 0x63e944
>                         cpu = 0x0
>                         ip = 0x1a7f64
>                 }
>         }
>         cpumask = {
>                 [0] 0x2
>         }
> }
> 
> rcu_data cpu #0
> >> px *(struct rcu_data *) 0x872f8430
> struct rcu_data {
>         quiescbatch = 0xffffffffffffff99
>         passed_quiesc = 0x1
>         qs_pending = 0x0
>         batch = 0xffffffffffffff97
>         nxtlist = (nil)
>         nxttail = {
>                 [0]         0x872f8448
>                 [1]         0x872f8448
>                 [2]         0x872f8448
>         }
>         qlen = 0x0
>         donelist = (nil)
>         donetail = 0x872f8470
>         blimit = 0xa
>         cpu = 0x0
>         barrier = struct rcu_head {
>                 next = (nil)
>                 func = 0x0
>         }
> }
> 
> rcu_data cpu #1
> >> px *(struct rcu_data *) 0x874be430
> struct rcu_data {
>         quiescbatch = 0xffffffffffffff98
>         passed_quiesc = 0x1
>         qs_pending = 0x0
>         batch = 0xffffffffffffff97
>         nxtlist = (nil)
>         nxttail = {
>                 [0]         0x874be448
>                 [1]         0x874be448
>                 [2]         0x874be448
>         }
>         qlen = 0x0
>         donelist = (nil)
>         donetail = 0x874be470
>         blimit = 0xa
>         cpu = 0x1
>         barrier = struct rcu_head {
>                 next = (nil)
>                 func = 0x0
>         }
> }
> 
> rcu_data cpu #2
> >> px *(struct rcu_data *) 0x87684430
> struct rcu_data {
>         quiescbatch = 0xffffffffffffff99
>         passed_quiesc = 0x1
>         qs_pending = 0x0
>         batch = 0xffffffffffffff99
>         nxtlist = 0xffc1fc18
>         nxttail = {
>                 [0]         0x87684448
>                 [1]         0x87684448
>                 [2]         0xffc1fc18
>         }
>         qlen = 0x1
>         donelist = (nil)
>         donetail = 0x87684470
>         blimit = 0xa
>         cpu = 0x2
>         barrier = struct rcu_head {
>                 next = (nil)
>                 func = 0x0
>         }
> }
> 
> rcu_data cpu #3
> >> px *(struct rcu_data *) 0x8784a430
> struct rcu_data {
>         quiescbatch = 0xffffffffffffff99
>         passed_quiesc = 0x1
>         qs_pending = 0x0
>         batch = 0xffffffffffffff63
>         nxtlist = (nil)
>         nxttail = {
>                 [0]         0x8784a448
>                 [1]         0x8784a448
>                 [2]         0x8784a448
>         }
>         qlen = 0x0
>         donelist = (nil)
>         donetail = 0x8784a470
>         blimit = 0xa
>         cpu = 0x3
>         barrier = struct rcu_head {
>                 next = (nil)
>                 func = 0x0
>         }
> }
> 
> At the time cpu #1 went to sleep rcu_needs_cpu must have answered false,
> otherwise a 1 tick delay would have been programmed. rcu_pending compares
> rcu_ctrlblk.cur with rcu_data.quiescbatch for cpu #1. So these two must
> have been equal otherwise rcu_needs_cpu would have answered true.
> That means that the rcu_needs_cpu check has been completed before
> rcu_start_batch for batch 0xffffffffffffff99. The bit for cpu #1 is
> still set in the rcu_ctrlblk.cpumask, therefore the bit for cpu #1
> in nohz_cpu_mask can not have been set at the time rcu_start_batch has
> completed. That gives the following race (cpu 0 is starting the batch,
> cpu 1 is going to sleep):
> 
> cpu 1: tick_nohz_stop_sched_tick: rcu_needs_cpu();
> cpu 0: rcu_start_batch: rcp->cur++;
> cpu 0: rcu_start_batch: cpumask_andnot(to_cpumask(rcp->cpumask),
> 					cpu_online_mask, nonz_cpu_mask);
> cpu 1: tick_nohz_stop_schedk_tick: cpumask_set_cpu(1, nohz_cpu_mask);
> 
> The order of i) setting the bit in nohz_cpu_mask and ii) the rcu_needs_cpu()
> check in tick_nohz_stop_sched_tick is wrong, no? Or did I miss some suble
> check that comes afterwards ?
> 
> -- 
> blue skies,
>    Martin.
> 
> "Reality continues to ruin my life." - Calvin.
> 
