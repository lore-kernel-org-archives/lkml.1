Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab0BWSss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:48:48 -0500
Received: from ms01.sssup.it ([193.205.80.99]:56181 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753496Ab0BWSsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:48:35 -0500
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fchecconi@gmail.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>
Subject: [PATCH 3/3] sched: make runtime balancing code more EDF-friendly
Date: Tue, 23 Feb 2010 19:56:35 +0100
Message-Id: <61a4579f9c15818ee9c878d21b9db90480f16261.1266931410.git.fabio@helm.retis>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
In-Reply-To: <cover.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old runtime balancing code logic does not work too well when using
EDF to schedule runqueues.  One of the problems is that the old throttling
code had only one timer to handle budget replenishments; EDF needs per-cpu
timers, not in sync among themselves.

This patch changes balance_runtime() to work in push or pull mode: 1) when
an rt_rq needs extra runtime, it tries to borrow it from its siblings, and
2) when an rt_rq has some borroewed runtime, it tries to distribute it
among the rt_rq's needing it.  This change improves things a little bit,
making easier to redistribute bandwidth when the load on the various
rt_rq's changes; anyway this is far from being an optimal solution.
I think we need (intependently from this patchset) to make the balancing
logic cooperate with (or at least aware of) task push/pulls and define
more formally the objectives of the runtime migration policy.

Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
---
 kernel/sched_rt.c |  152 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 116 insertions(+), 36 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 27768bd..fa0ad58 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -498,6 +498,20 @@ static u64 from_ratio(unsigned long ratio, u64 period)
 	return (ratio * period) >> 20;
 }
 
+static inline bool runtime_push_needed(struct rt_rq *src, struct rt_rq *dst)
+{
+	if (!rt_rq_throttled(dst))
+		return false;
+
+	if (!dst->rt_nr_running)
+		return false;
+
+	if (src->rt_runtime <= dst->rt_runtime)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to move *diff units of runtime from src to dst, checking
  * that the utilization does not exceed the global limits on the
@@ -505,14 +519,14 @@ static u64 from_ratio(unsigned long ratio, u64 period)
  * in *diff the actual amount of runtime moved, false on failure, which
  * means that no more bandwidth can be migrated to rt_rq.
  */
-static int rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
+static bool rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
 		       s64 *diff, u64 rt_period)
 {
 	struct rq *rq = rq_of_rt_rq(dst), *src_rq = rq_of_rt_rq(src);
 	struct rt_edf_tree *dtree = &rq->rt.rt_edf_tree;
 	struct rt_edf_tree *stree = &src_rq->rt.rt_edf_tree;
 	unsigned long bw_to_move;
-	int ret = 0;
+	bool ret = false;
 
 	double_spin_lock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
 
@@ -525,7 +539,7 @@ static int rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
 
 		stree->rt_free_bw -= bw_to_move;
 		dtree->rt_free_bw += bw_to_move;
-		ret = 1;
+		ret = true;
 	}
 
 	double_spin_unlock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
@@ -533,18 +547,85 @@ static int rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
 	return ret;
 }
 
+static inline bool stop_runtime_balancing(bool pull, bool moved, s64 diff)
+{
+	if (pull && !moved) {
+		/* No more available bw on our cpu while pulling. */
+		return true;
+	}
+
+	if (!pull && diff < 0) {
+		/* No more bandwidth to give back while pushing. */
+		return true;
+	}
+
+	return false;
+}
+
 /*
- * Handle runtime rebalancing: try to push our bandwidth to
- * runqueues that need it.
+ * Try to move runtime between rt_rq and iter, in the direction specified
+ * by pull.  Return true if balancing should stop.
  */
-static void do_balance_runtime(struct rt_rq *rt_rq)
+static inline bool move_runtime(struct rt_rq *rt_rq, struct rt_rq *iter,
+			       int weight, u64 rt_period, bool pull)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+	struct rt_rq *src, *dst;
+	u64 leave;
+	s64 diff = 0;
+	bool moved = true;
+
+	if (pull) {
+		/*
+		 * From runqueues with spare time, take 1/n part of their
+		 * spare time, but no more than our period.  In case we are
+		 * stealing from an active rt_rq, make sure we steal only
+		 * from the runtime it borrowed, to avoid instability.
+		 */
+		if (iter->rt_nr_running)
+			leave = max(rt_b->rt_runtime, iter->rt_time);
+		else
+			leave = iter->rt_time;
+		diff = iter->rt_runtime - leave;
+		src = iter;
+		dst = rt_rq;
+	} else if (runtime_push_needed(rt_rq, iter)) {
+		/*
+		 * Try to give 1/n part of our borrowed runtime to the
+		 * runqueues needing it.
+		 */
+		diff = rt_rq->rt_runtime - rt_rq->rt_time - rt_b->rt_runtime;
+		src = rt_rq;
+		dst = iter;
+	}
+
+	if (diff > 0) {
+		diff = div_u64((u64)diff, weight);
+		if (dst->rt_runtime + diff > rt_period)
+			diff = rt_period - dst->rt_runtime;
+
+		moved = rt_move_bw(src, dst, &diff, rt_period);
+		if (moved) {
+			src->rt_runtime -= diff;
+			dst->rt_runtime += diff;
+		}
+	}
+
+	return stop_runtime_balancing(pull, moved, diff);
+}
+
+/*
+ * Handle runtime rebalancing: either try to push our bandwidth to
+ * runqueues that need it, or pull from those that can lend some.
+ */
+static void do_balance_runtime(struct rt_rq *rt_rq, bool pull)
 {
 	struct rq *rq = cpu_rq(smp_processor_id());
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd = rq->rd;
-	int i, weight, ret;
+	int i, weight;
 	u64 rt_period, prev_runtime;
-	s64 diff;
+	bool stop;
 
 	weight = cpumask_weight(rd->span);
 
@@ -581,26 +662,10 @@ static void do_balance_runtime(struct rt_rq *rt_rq)
 		if (iter->rt_runtime == RUNTIME_INF)
 			goto next;
 
-		/*
-		 * From runqueues with spare time, take 1/n part of their
-		 * spare time, but no more than our period.
-		 */
-		diff = iter->rt_runtime - iter->rt_time;
-		if (diff > 0) {
-			diff = div_u64((u64)diff, weight);
-			if (rt_rq->rt_runtime + diff > rt_period)
-				diff = rt_period - rt_rq->rt_runtime;
-
-			ret = rt_move_bw(iter, rt_rq, &diff, rt_period);
-			if (ret) {
-				iter->rt_runtime -= diff;
-				rt_rq->rt_runtime += diff;
-			}
-
-			if (!ret || rt_rq->rt_runtime == rt_period) {
-				raw_spin_unlock(&iter->rt_runtime_lock);
-				break;
-			}
+		stop = move_runtime(rt_rq, iter, weight, rt_period, pull);
+		if (stop) {
+			raw_spin_unlock(&iter->rt_runtime_lock);
+			break;
 		}
 next:
 		raw_spin_unlock(&iter->rt_runtime_lock);
@@ -756,16 +821,27 @@ static void enable_runtime(struct rq *rq)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static inline void balance_runtime(struct rt_rq *rt_rq)
+static inline void balance_runtime(struct rt_rq *rt_rq, int pull)
 {
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		do_balance_runtime(rt_rq);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-	}
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	do_balance_runtime(rt_rq, pull);
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
 }
 
+static void pull_runtime(struct rt_rq *rt_rq)
+{
+	if (rt_rq->rt_time > rt_rq->rt_runtime)
+		balance_runtime(rt_rq, true);
+}
+
+static void push_runtime(struct rt_rq *rt_rq)
+{
+	if (rt_rq->rt_time < rt_rq->rt_runtime)
+		balance_runtime(rt_rq, false);
+}
 #else /* !CONFIG_SMP */
+static inline void pull_runtime(struct rt_rq *rt_rq) {}
+static inline void push_runtime(struct rt_rq *rt_rq) {}
 
 static void rt_reset_runtime(void)
 {
@@ -828,6 +904,9 @@ static int __do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
 	} else if (rt_rq->rt_nr_running)
 		idle = 0;
 
+	/* Try to give back what we borrowed from rt_rq's in need. */
+	push_runtime(rt_rq);
+
 	return idle && !rt_rq_needs_recharge(rt_rq);
 }
 
@@ -843,7 +922,7 @@ static int do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
 	raw_spin_lock(&rt_rq->rt_runtime_lock);
 
 	if (rt_rq->rt_throttled)
-		balance_runtime(rt_rq);
+		pull_runtime(rt_rq);
 
 	idle = __do_sched_rt_period_timer(rt_rq, overrun);
 
@@ -919,7 +998,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
 		return 0;
 
-	balance_runtime(rt_rq);
+	pull_runtime(rt_rq);
 	runtime = sched_rt_runtime(rt_rq);
 	if (runtime == RUNTIME_INF)
 		return 0;
@@ -1261,6 +1340,7 @@ update:
 			rt_rq->rt_deadline += period;
 			rt_rq->rt_time -= runtime;
 		}
+		push_runtime(rt_rq);
 	}
 	raw_spin_unlock(&rt_rq->rt_runtime_lock);
 }
-- 
1.6.5.7

