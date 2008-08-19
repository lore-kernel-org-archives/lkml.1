Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYHSKpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYHSKpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYHSKoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:44:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbYHSKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:44:17 -0400
Message-Id: <20080819103844.376888858@chello.nl>
References: <20080819103301.787700742@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 12:33:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, Dario Faggioli <raistlin@linux.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] sched: rt-bandwidth fixes
Content-Disposition: inline; filename=sched-rt-bw-disable.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last patch allows sysctl_sched_rt_runtime to disable bandwidth accounting
for the group scheduler - however it doesn't deal with sched_setscheduler(),
which will keep tasks out of groups that have no assigned runtime.

If we relax this, we get into the situation where RT tasks can get into a group
when we disable bandwidth control, and then starve them by enabling it again.

Rework the schedulability code to check for this condition and fail to turn
on bandwidth control with -EBUSY when this situation is found.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |  125 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 63 insertions(+), 62 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -300,9 +300,9 @@ static DEFINE_PER_CPU(struct cfs_rq, ini
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_USER_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -1387,7 +1387,7 @@ static inline void dec_cpu_load(struct r
 	update_load_sub(&rq->load, load);
 }
 
-#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED))
+#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(SCHED_RT_GROUP_SCHED)
 typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
@@ -5082,7 +5082,8 @@ recheck:
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
 		 */
-		if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
+		if (rt_bandwidth_enabled() && rt_policy(policy) &&
+				task_group(p)->rt_bandwidth.rt_runtime == 0)
 			return -EPERM;
 #endif
 
@@ -8707,73 +8708,77 @@ static DEFINE_MUTEX(rt_constraints_mutex
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
-		return 1ULL << 16;
+		return 1ULL << 20;
 
-	return div64_u64(runtime << 16, period);
+	return div64_u64(runtime << 20, period);
 }
 
-#ifdef CONFIG_CGROUP_SCHED
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
+/* Must be called with tasklist_lock held */
+static inline int tg_has_rt_tasks(struct task_group *tg)
 {
-	struct task_group *tgi, *parent = tg->parent;
-	unsigned long total = 0;
+	struct task_struct *g, *p;
 
-	if (!parent) {
-		if (global_rt_period() < period)
-			return 0;
+	do_each_thread(g, p) {
+		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+			return 1;
+	} while_each_thread(g, p);
 
-		return to_ratio(period, runtime) <
-			to_ratio(global_rt_period(), global_rt_runtime());
-	}
+	return 0;
+}
 
-	if (ktime_to_ns(parent->rt_bandwidth.rt_period) < period)
-		return 0;
+struct rt_schedulable_data {
+	struct task_group *tg;
+	u64 rt_period;
+	u64 rt_runtime;
+};
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &parent->children, siblings) {
-		if (tgi == tg)
-			continue;
+static int tg_schedulable(struct task_group *tg, void *data)
+{
+	struct rt_schedulable_data *d = data;
+	struct task_group *child;
+	unsigned long total, sum = 0;
+	u64 period, runtime;
+
+	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	runtime = tg->rt_bandwidth.rt_runtime;
 
-		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
-				tgi->rt_bandwidth.rt_runtime);
+	if (tg == d->tg) {
+		period = d->rt_period;
+		runtime = d->rt_runtime;
 	}
-	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) <=
-		to_ratio(ktime_to_ns(parent->rt_bandwidth.rt_period),
-				parent->rt_bandwidth.rt_runtime);
-}
-#elif defined CONFIG_USER_SCHED
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
-{
-	struct task_group *tgi;
-	unsigned long total = 0;
-	unsigned long global_ratio =
-		to_ratio(global_rt_period(), global_rt_runtime());
+	if (rt_bandwidth_enabled() && !runtime && tg_has_rt_tasks(tg))
+		return -EBUSY;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &task_groups, list) {
-		if (tgi == tg)
-			continue;
+	total = to_ratio(period, runtime);
 
-		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
-				tgi->rt_bandwidth.rt_runtime);
+	list_for_each_entry_rcu(child, &tg->children, siblings) {
+		period = ktime_to_ns(child->rt_bandwidth.rt_period);
+		runtime = child->rt_bandwidth.rt_runtime;
+
+		if (child == d->tg) {
+			period = d->rt_period;
+			runtime = d->rt_runtime;
+		}
+
+		sum += to_ratio(period, runtime);
 	}
-	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) < global_ratio;
+	if (sum > total)
+		return -EINVAL;
+
+	return 0;
 }
-#endif
 
-/* Must be called with tasklist_lock held */
-static inline int tg_has_rt_tasks(struct task_group *tg)
+static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_struct *g, *p;
-	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
-			return 1;
-	} while_each_thread(g, p);
-	return 0;
+	struct rt_schedulable_data data = {
+		.tg = tg,
+		.rt_period = period,
+		.rt_runtime = runtime,
+	};
+
+	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
 static int tg_set_bandwidth(struct task_group *tg,
@@ -8783,14 +8788,9 @@ static int tg_set_bandwidth(struct task_
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	if (rt_runtime == 0 && tg_has_rt_tasks(tg)) {
-		err = -EBUSY;
+	err = __rt_schedulable(tg, rt_period, rt_runtime);
+	if (err)
 		goto unlock;
-	}
-	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
-		err = -EINVAL;
-		goto unlock;
-	}
 
 	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
@@ -8867,8 +8867,9 @@ static int sched_rt_global_constraints(v
 	rt_runtime = tg->rt_bandwidth.rt_runtime;
 
 	mutex_lock(&rt_constraints_mutex);
-	if (!__rt_schedulable(tg, rt_period, rt_runtime))
-		ret = -EINVAL;
+	read_lock(&tasklist_lock);
+	ret = __rt_schedulable(tg, rt_period, rt_runtime);
+	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
 	return ret;

-- 

