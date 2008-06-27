Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYF0MA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYF0MA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYF0L6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:00 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60314 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754456AbYF0L5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:53 -0400
Message-Id: <20080627115211.057968925@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/30] sched: revert the revert of: weight calculations
Content-Disposition: inline; filename=sched-revert-revert-sched-weight-calc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try again..

initial commit: 8f1bc385cfbab474db6c27b5af1e439614f3025c
revert: f9305d4a0968201b2818dbed0dc8cb0d4ee7aeb3

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

---
 kernel/sched.c          |    9 +---
 kernel/sched_fair.c     |  105 ++++++++++++++++++++++++++++++++----------------
 kernel/sched_features.h |    1 
 3 files changed, 76 insertions(+), 39 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1342,6 +1342,9 @@ static void __resched_task(struct task_s
  */
 #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
 
+/*
+ * delta *= weight / lw
+ */
 static unsigned long
 calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 		struct load_weight *lw)
@@ -1369,12 +1372,6 @@ calc_delta_mine(unsigned long delta_exec
 	return (unsigned long)min(tmp, (u64)(unsigned long)LONG_MAX);
 }
 
-static inline unsigned long
-calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
-{
-	return calc_delta_mine(delta_exec, NICE_0_LOAD, lw);
-}
-
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -334,6 +334,34 @@ int sched_nr_latency_handler(struct ctl_
 #endif
 
 /*
+ * delta *= w / rw
+ */
+static inline unsigned long
+calc_delta_weight(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				se->load.weight, &cfs_rq_of(se)->load);
+	}
+
+	return delta;
+}
+
+/*
+ * delta *= rw / w
+ */
+static inline unsigned long
+calc_delta_fair(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, &se->load);
+	}
+
+	return delta;
+}
+
+/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -362,47 +390,54 @@ static u64 __sched_period(unsigned long 
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running);
-
-	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
-
-		slice *= se->load.weight;
-		do_div(slice, cfs_rq->load.weight);
-	}
-
-
-	return slice;
+	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s/w = p/rw
+ * vs = s*rw/w = p
  */
 static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	unsigned long nr_running = cfs_rq->nr_running;
-	unsigned long weight;
-	u64 vslice;
 
 	if (!se->on_rq)
 		nr_running++;
 
-	vslice = __sched_period(nr_running);
+	return __sched_period(nr_running);
+}
+
+/*
+ * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
+ * that it favours >=0 over <0.
+ *
+ *   -20         |
+ *               |
+ *     0 --------+-------
+ *             .'
+ *    19     .'
+ *
+ */
+static unsigned long
+calc_delta_asym(unsigned long delta, struct sched_entity *se)
+{
+	struct load_weight lw = {
+		.weight = NICE_0_LOAD,
+		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
+	};
 
 	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
+		struct load_weight *se_lw = &se->load;
 
-		weight = cfs_rq->load.weight;
-		if (!se->on_rq)
-			weight += se->load.weight;
+		if (se->load.weight < NICE_0_LOAD)
+			se_lw = &lw;
 
-		vslice *= NICE_0_LOAD;
-		do_div(vslice, weight);
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, se_lw);
 	}
 
-	return vslice;
+	return delta;
 }
 
 /*
@@ -419,11 +454,7 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	curr->sum_exec_runtime += delta_exec;
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
-	delta_exec_weighted = delta_exec;
-	if (unlikely(curr->load.weight != NICE_0_LOAD)) {
-		delta_exec_weighted = calc_delta_fair(delta_exec_weighted,
-							&curr->load);
-	}
+	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
 }
 
@@ -609,8 +640,17 @@ place_entity(struct cfs_rq *cfs_rq, stru
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
+		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+			unsigned long thresh = sysctl_sched_latency;
+
+			/*
+			 * convert the sleeper threshold into virtual time
+			 */
+			if (sched_feat(NORMALIZED_SLEEPER))
+				thresh = calc_delta_fair(thresh, se);
+
+			vruntime -= thresh;
+		}
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -1111,11 +1151,10 @@ static unsigned long wakeup_gran(struct 
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
 	/*
-	 * More easily preempt - nice tasks, while not making
-	 * it harder for + nice tasks.
+	 * More easily preempt - nice tasks, while not making it harder for
+	 * + nice tasks.
 	 */
-	if (unlikely(se->load.weight > NICE_0_LOAD))
-		gran = calc_delta_fair(gran, &se->load);
+	gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -1,4 +1,5 @@
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
+SCHED_FEAT(NORMALIZED_SLEEPER, 1)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)

-- 

