Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbZFOTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbZFOTFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765333AbZFOTFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:05:33 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37790 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763544AbZFOTFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:05:32 -0400
Date: Mon, 15 Jun 2009 21:06:35 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] Remove the balancing logic
Message-ID: <20090615190635.GN21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The balancing logic would require to run an admission test on each step
it takes trying to balance the bandwidths assigned to each group.  Now it
is not doing so, and it can produce unschedulable assignments, which in
turn would make EDF scheduling on each single cpu pointless.
Temporarily remove it; we can add it back later, once the system proves
to be stable enough.
---
 kernel/sched_rt.c |  142 -----------------------------------------------------
 1 files changed, 0 insertions(+), 142 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 7ae1212..c23f3ad 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -287,137 +287,16 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 #ifdef CONFIG_SMP
 /*
- * We ran out of runtime, see if we can borrow some from our neighbours.
- */
-static int do_balance_runtime(struct rt_rq *rt_rq)
-{
-	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
-	int i, weight, more = 0;
-	u64 rt_period;
-
-	weight = cpumask_weight(rd->span);
-
-	spin_lock(&rt_b->rt_runtime_lock);
-	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu(i, rd->span) {
-		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-		s64 diff;
-
-		if (iter == rt_rq)
-			continue;
-
-		spin_lock(&iter->rt_runtime_lock);
-		/*
-		 * Either all rqs have inf runtime and there's nothing to steal
-		 * or __disable_runtime() below sets a specific rq to inf to
-		 * indicate its been disabled and disalow stealing.
-		 */
-		if (iter->rt_runtime == RUNTIME_INF)
-			goto next;
-
-		/*
-		 * From runqueues with spare time, take 1/n part of their
-		 * spare time, but no more than our period.
-		 */
-		diff = iter->rt_runtime - iter->rt_time;
-		if (diff > 0) {
-			diff = div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
-			iter->rt_runtime -= diff;
-			rt_rq->rt_runtime += diff;
-			more = 1;
-			if (rt_rq->rt_runtime == rt_period) {
-				spin_unlock(&iter->rt_runtime_lock);
-				break;
-			}
-		}
-next:
-		spin_unlock(&iter->rt_runtime_lock);
-	}
-	spin_unlock(&rt_b->rt_runtime_lock);
-
-	return more;
-}
-
-/*
  * Ensure this RQ takes back all the runtime it lend to its neighbours.
  */
 static void __disable_runtime(struct rq *rq)
 {
-	struct root_domain *rd = rq->rd;
 	struct rt_rq *rt_rq;
 
-	if (unlikely(!scheduler_running))
-		return;
-
 	for_each_leaf_rt_rq(rt_rq, rq) {
-		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
-		s64 want;
-		int i;
-
-		spin_lock(&rt_b->rt_runtime_lock);
-		spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * Either we're all inf and nobody needs to borrow, or we're
-		 * already disabled and thus have nothing to do, or we have
-		 * exactly the right amount of runtime to take out.
-		 */
-		if (rt_rq->rt_runtime == RUNTIME_INF ||
-				rt_rq->rt_runtime == rt_b->rt_runtime)
-			goto balanced;
-		spin_unlock(&rt_rq->rt_runtime_lock);
-
-		/*
-		 * Calculate the difference between what we started out with
-		 * and what we current have, that's the amount of runtime
-		 * we lend and now have to reclaim.
-		 */
-		want = rt_b->rt_runtime - rt_rq->rt_runtime;
-
-		/*
-		 * Greedy reclaim, take back as much as we can.
-		 */
-		for_each_cpu(i, rd->span) {
-			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
-			s64 diff;
-
-			/*
-			 * Can't reclaim from ourselves or disabled runqueues.
-			 */
-			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
-				continue;
-
-			spin_lock(&iter->rt_runtime_lock);
-			if (want > 0) {
-				diff = min_t(s64, iter->rt_runtime, want);
-				iter->rt_runtime -= diff;
-				want -= diff;
-			} else {
-				iter->rt_runtime -= want;
-				want -= want;
-			}
-			spin_unlock(&iter->rt_runtime_lock);
-
-			if (!want)
-				break;
-		}
-
 		spin_lock(&rt_rq->rt_runtime_lock);
-		/*
-		 * We cannot be left wanting - that would mean some runtime
-		 * leaked out of the system.
-		 */
-		BUG_ON(want);
-balanced:
-		/*
-		 * Disable all the borrow logic by pretending we have inf
-		 * runtime - in which case borrowing doesn't make sense.
-		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
 		spin_unlock(&rt_rq->rt_runtime_lock);
-		spin_unlock(&rt_b->rt_runtime_lock);
 	}
 }
 
@@ -461,24 +340,6 @@ static void enable_runtime(struct rq *rq)
 	__enable_runtime(rq);
 	spin_unlock_irqrestore(&rq->lock, flags);
 }
-
-static int balance_runtime(struct rt_rq *rt_rq)
-{
-	int more = 0;
-
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		spin_unlock(&rt_rq->rt_runtime_lock);
-		more = do_balance_runtime(rt_rq);
-		spin_lock(&rt_rq->rt_runtime_lock);
-	}
-
-	return more;
-}
-#else /* !CONFIG_SMP */
-static inline int balance_runtime(struct rt_rq *rt_rq)
-{
-	return 0;
-}
 #endif /* CONFIG_SMP */
 
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
@@ -500,8 +361,6 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			u64 runtime;
 
 			spin_lock(&rt_rq->rt_runtime_lock);
-			if (rt_rq->rt_throttled)
-				balance_runtime(rt_rq);
 			runtime = rt_rq->rt_runtime;
 			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
@@ -544,7 +403,6 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
 		return 0;
 
-	balance_runtime(rt_rq);
 	runtime = sched_rt_runtime(rt_rq);
 	if (runtime == RUNTIME_INF)
 		return 0;
-- 
1.6.2.2

