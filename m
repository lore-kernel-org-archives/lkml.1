Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYLPHsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYLPHsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYLPHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:47:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYLPHrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:47:51 -0500
Message-Id: <20081216074636.176935879@chello.nl>
References: <20081216074529.570706654@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 16 Dec 2008 08:45:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] sched: prefer wakers
Content-Disposition: inline; filename=wakeup-preempt-fiddle.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefer tasks that wake other tasks to preempt quickly. This improves
performance because more work is available sooner.

The workload that prompted this patch was a kernel build over NFS4 (for some
curious and not understood reason we had to revert commit:
18de9735300756e3ca9c361ef58409d8561dfe0d to make any progress at all)

Without this patch a make -j8 bzImage (of x86-64 defconfig) would take
3m30-ish, with this patch we're down to 2m50-ish.

psql-sysbench/mysql-sysbench show a slight improvement in peak performance as
well, tbench and vmark seemed to not care.

It is possible to improve upon the build time (to 2m20-ish) but that seriously
destroys other benchmarks (just shows that there's more room for tinkering).

Much thanks to Mike who put in a lot of effort to benchmark things and proved
a worthy opponent with a competing patch.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mike Galbraith <efault@gmx.de>
---
 include/linux/sched.h   |    2 +
 kernel/sched.c          |   30 +++++++++++++++++++++---
 kernel/sched_debug.c    |    1 
 kernel/sched_fair.c     |   59 +++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sched_features.h |    3 +-
 5 files changed, 84 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1690,17 +1690,35 @@ static void update_avg(u64 *avg, u64 sam
 
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	if (wakeup)
+		p->se.start_runtime = p->se.sum_exec_runtime;
+
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
 }
 
+static void update_avg_wakeup(struct sched_entity *se)
+{
+	u64 sample = se->sum_exec_runtime;
+	if (se->last_wakeup)
+		sample -= se->last_wakeup;
+	else
+		sample -= se->start_runtime;
+	update_avg(&se->avg_wakeup, sample);
+}
+
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
-	if (sleep && p->se.last_wakeup) {
-		update_avg(&p->se.avg_overlap,
-			   p->se.sum_exec_runtime - p->se.last_wakeup);
-		p->se.last_wakeup = 0;
+	if (sleep) {
+		if (p->se.last_wakeup) {
+			update_avg(&p->se.avg_overlap,
+				p->se.sum_exec_runtime - p->se.last_wakeup);
+			p->se.last_wakeup = 0;
+		} else {
+			update_avg(&p->se.avg_wakeup,
+				sysctl_sched_wakeup_granularity);
+		}
 	}
 
 	sched_info_dequeued(p);
@@ -2327,6 +2345,8 @@ out_activate:
 		schedstat_inc(p, se.nr_wakeups_remote);
 	activate_task(rq, p, 1);
 	success = 1;
+	if (!in_interrupt())
+		update_avg_wakeup(&current->se);
 
 out_running:
 	trace_sched_wakeup(rq, p);
@@ -2369,6 +2389,8 @@ static void __sched_fork(struct task_str
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
+	p->se.start_runtime		= 0;
+	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start		= 0;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1283,16 +1283,63 @@ out:
 }
 #endif /* CONFIG_SMP */
 
-static unsigned long wakeup_gran(struct sched_entity *se)
+/*
+ * Adaptive granularity
+ *
+ * se->avg_wakeup gives the average time a task runs until it does a wakeup,
+ * with the limit of wakeup_gran -- when it never does a wakeup.
+ *
+ * So the smaller avg_wakeup is the faster we want this task to preempt,
+ * but we don't want to treat the preemptee unfairly and therefore allow it
+ * to run for at least the amount of time we'd like to run.
+ *
+ * NOTE: we use 2*avg_wakeup to increase the probability of actually doing one
+ *
+ * NOTE: we use *nr_running to scale with load, this nicely matches the
+ *       degrading latency on load.
+ */
+static unsigned long
+adaptive_gran(struct sched_entity *curr, struct sched_entity *se)
+{
+	u64 this_run = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
+	u64 expected_wakeup = 2*se->avg_wakeup * cfs_rq_of(se)->nr_running;
+	u64 gran = 0;
+
+	if (this_run < expected_wakeup)
+		gran = expected_wakeup - this_run;
+
+	return min_t(s64, gran, sysctl_sched_wakeup_granularity);
+}
+
+static unsigned long
+wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 {
 	unsigned long gran = sysctl_sched_wakeup_granularity;
 
+	if (cfs_rq_of(curr)->curr && sched_feat(ADAPTIVE_GRAN))
+		gran = adaptive_gran(curr, se);
+
 	/*
-	 * More easily preempt - nice tasks, while not making it harder for
-	 * + nice tasks.
+	 * Since its curr running now, convert the gran from real-time
+	 * to virtual-time in his units.
 	 */
-	if (!sched_feat(ASYM_GRAN) || se->load.weight > NICE_0_LOAD)
-		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
+	if (sched_feat(ASYM_GRAN)) {
+		/*
+		 * By using 'se' instead of 'curr' we penalize light tasks, so
+		 * they get preempted easier. That is, if 'se' < 'curr' then
+		 * the resulting gran will be larger, therefore penalizing the
+		 * lighter, if otoh 'se' > 'curr' then the resulting gran will
+		 * be smaller, again penalizing the lighter task.
+		 *
+		 * This is especially important for buddies when the leftmost
+		 * task is higher priority than the buddy.
+		 */
+		if (unlikely(se->load.weight != NICE_0_LOAD))
+			gran = calc_delta_fair(gran, se);
+	} else {
+		if (unlikely(curr->load.weight != NICE_0_LOAD))
+			gran = calc_delta_fair(gran, curr);
+	}
 
 	return gran;
 }
@@ -1319,7 +1366,7 @@ wakeup_preempt_entity(struct sched_entit
 	if (vdiff <= 0)
 		return -1;
 
-	gran = wakeup_gran(curr);
+	gran = wakeup_gran(curr, se);
 	if (vdiff > gran)
 		return 1;
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1024,6 +1024,8 @@ struct sched_entity {
 
 	u64			last_wakeup;
 	u64			avg_overlap;
+	u64			start_runtime;
+	u64			avg_wakeup;
 
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
Index: linux-2.6/kernel/sched_features.h
===================================================================
--- linux-2.6.orig/kernel/sched_features.h
+++ linux-2.6/kernel/sched_features.h
@@ -1,5 +1,5 @@
 SCHED_FEAT(NEW_FAIR_SLEEPERS, 1)
-SCHED_FEAT(NORMALIZED_SLEEPER, 1)
+SCHED_FEAT(NORMALIZED_SLEEPER, 0)
 SCHED_FEAT(WAKEUP_PREEMPT, 1)
 SCHED_FEAT(START_DEBIT, 1)
 SCHED_FEAT(AFFINE_WAKEUPS, 1)
@@ -13,3 +13,4 @@ SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
 SCHED_FEAT(WAKEUP_OVERLAP, 0)
 SCHED_FEAT(LAST_BUDDY, 1)
+SCHED_FEAT(ADAPTIVE_GRAN, 1)
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -384,6 +384,7 @@ void proc_sched_show_task(struct task_st
 	PN(se.vruntime);
 	PN(se.sum_exec_runtime);
 	PN(se.avg_overlap);
+	PN(se.avg_wakeup);
 
 	nr_switches = p->nvcsw + p->nivcsw;
 

-- 

