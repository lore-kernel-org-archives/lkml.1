Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYJIFH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYJIFH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYJIFHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:07:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45501 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYJIFHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:07:18 -0400
Subject: Re: kernel BUG at kernel/sched_rt.c:322!
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
In-Reply-To: <20081009011456.GB10188@linux.vnet.ibm.com>
References: <20081009011456.GB10188@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 07:06:38 +0200
Message-Id: <1223528798.7382.27.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 18:14 -0700, Paul E. McKenney wrote:
> When I enable:
> 
> 	CONFIG_GROUP_SCHED=y
> 	CONFIG_FAIR_GROUP_SCHED=y
> 	CONFIG_USER_SCHED=y
> 
> and run a bash script onlining and offlining CPUs in an infinite loop
> on x86 using 2.6.27-rc9, after about 1.5 hours I get the following.
> 
> On the off-chance that this is new news...

Hmm, yes. I thought I had all those fixed :-(

> 	[ 5538.091011] kernel BUG at kernel/sched_rt.c:322!
> 	[ 5538.091011] invalid opcode: 0000 [#1] SMP 
> 	[ 5538.091011] Modules linked in:
> 	[ 5538.091011] 
> 	[ 5538.091011] Pid: 2819, comm: sh Not tainted (2.6.27-rc9-autokern1 #1)
> 	[ 5538.091011] EIP: 0060:[<c011c287>] EFLAGS: 00010002 CPU: 7
> 	[ 5538.091011] EIP is at __disable_runtime+0x1c7/0x1d0
> 	[ 5538.091011] EAX: c9056eec EBX: 00000001 ECX: 00000008 EDX: 00006060
> 	[ 5538.091011] ESI: 02faf080 EDI: 00000000 EBP: f6df7cd0 ESP: f6df7ca8
> 	[ 5538.091011]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> 	[ 5538.091011] Process sh (pid: 2819, ti=f6df6000 task=f6cbdc00 task.ti=f6df6000)
> 	[ 5538.091011] Stack: f68c8004 c9056eec f68c8000 c9056b98 00000008 5d353631 c04d0020 c9056b00 
> 	[ 5538.091011]        c9056b00 c9056b00 f6df7cdc c011d151 c037dfc0 f6df7cec c011aedb f68c8000 
> 	[ 5538.091011]        c04d2200 f6df7d04 c011f967 00000282 00000000 00000000 00000000 f6df7e48 
> 	[ 5538.091011] Call Trace:
> 	[ 5538.091011]  [<c011d151>] ? rq_offline_rt+0x21/0x60
> 	[ 5538.091011]  [<c011aedb>] ? set_rq_offline+0x2b/0x50
> 	[ 5538.091011]  [<c011f967>] ? rq_attach_root+0xa7/0xb0
> 	[ 5538.091011]  [<c0120bbf>] ? cpu_attach_domain+0x30f/0x490

At the very least we're doing part of the offline process twice it
seems, once through set_rq_offline()/set_rq_online() and once through
disable_runtime()/enabled_runtime().

But seeing as we set an offlined cpu's runtime to RUNTIME_INF and skip
cpus with RUNTIME_INF runtime that should be harmless.

Modifications to rt_rq->rt_runtime are all done while holding
rt_b->rt_runtime_lock and rt_rq->rt_runtime_lock (do_balance_runtime()
and __disable_runtime() and __enable_runtime()). Which means its enough
to hold either of those locks in order to get a stable reading of the
value.

Which leaves me puzzled for the moment...

tip/master has the following commit to clarify the code somewhat:


commit 78333cdd0e472180743d35988e576d6ecc6f6ddb
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Sep 23 15:33:43 2008 +0200

    sched: add some comments to the bandwidth code
    
    Hopefully clarify some of this code a little.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 2e228bd..d570a8c 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -231,6 +231,9 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
+/*
+ * We ran out of runtime, see if we can borrow some from our neighbours.
+ */
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
@@ -250,9 +253,18 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 			continue;
 
 		spin_lock(&iter->rt_runtime_lock);
+		/*
+		 * Either all rqs have inf runtime and there's nothing to steal
+		 * or __disable_runtime() below sets a specific rq to inf to
+		 * indicate its been disabled and disalow stealing.
+		 */
 		if (iter->rt_runtime == RUNTIME_INF)
 			goto next;
 
+		/*
+		 * From runqueues with spare time, take 1/n part of their
+		 * spare time, but no more than our period.
+		 */
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			diff = div_u64((u64)diff, weight);
@@ -274,6 +286,9 @@ next:
 	return more;
 }
 
+/*
+ * Ensure this RQ takes back all the runtime it lend to its neighbours.
+ */
 static void __disable_runtime(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
@@ -289,17 +304,33 @@ static void __disable_runtime(struct rq *rq)
 
 		spin_lock(&rt_b->rt_runtime_lock);
 		spin_lock(&rt_rq->rt_runtime_lock);
+		/*
+		 * Either we're all inf and nobody needs to borrow, or we're
+		 * already disabled and thus have nothing to do, or we have
+		 * exactly the right amount of runtime to take out.
+		 */
 		if (rt_rq->rt_runtime == RUNTIME_INF ||
 				rt_rq->rt_runtime == rt_b->rt_runtime)
 			goto balanced;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 
+		/*
+		 * Calculate the difference between what we started out with
+		 * and what we current have, that's the amount of runtime
+		 * we lend and now have to reclaim.
+		 */
 		want = rt_b->rt_runtime - rt_rq->rt_runtime;
 
+		/*
+		 * Greedy reclaim, take back as much as we can.
+		 */
 		for_each_cpu_mask(i, rd->span) {
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
+			/*
+			 * Can't reclaim from ourselves or disabled runqueues.
+			 */
 			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
 				continue;
 
@@ -319,8 +350,16 @@ static void __disable_runtime(struct rq *rq)
 		}
 
 		spin_lock(&rt_rq->rt_runtime_lock);
+		/*
+		 * We cannot be left wanting - that would mean some runtime
+		 * leaked out of the system.
+		 */
 		BUG_ON(want);
 balanced:
+		/*
+		 * Disable all the borrow logic by pretending we have inf
+		 * runtime - in which case borrowing doesn't make sense.
+		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
@@ -343,6 +382,9 @@ static void __enable_runtime(struct rq *rq)
 	if (unlikely(!scheduler_running))
 		return;
 
+	/*
+	 * Reset each runqueue's bandwidth settings
+	 */
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 



