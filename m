Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYIWNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYIWNhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYIWNgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:36:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:34026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYIWNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:36:31 -0400
Message-Id: <20080923133459.915171588@programming.kicks-ass.net>
References: <20080923133340.929758093@programming.kicks-ass.net>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 15:33:43 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/6] sched: add some comments to the bandwidth code
Content-Disposition: inline; filename=sched-rt-bw-comment.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully clarify some of this code a little.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_rt.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -231,6 +231,9 @@ static inline struct rt_bandwidth *sched
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
+/*
+ * We ran out of runtime, see if we can borrow some from our neighbours.
+ */
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
@@ -250,9 +253,18 @@ static int do_balance_runtime(struct rt_
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
@@ -289,17 +304,33 @@ static void __disable_runtime(struct rq 
 
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
 
@@ -319,8 +350,16 @@ static void __disable_runtime(struct rq 
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
@@ -343,6 +382,9 @@ static void __enable_runtime(struct rq *
 	if (unlikely(!scheduler_running))
 		return;
 
+	/*
+	 * Reset each runqueue's bandwidth settings
+	 */
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 

-- 

