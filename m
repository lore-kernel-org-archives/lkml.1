Return-Path: <linux-kernel-owner+w=401wt.eu-S1765872AbZFOTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765872AbZFOTHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbZFOTHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:07:33 -0400
Received: from ms01.sssup.it ([193.205.80.99]:58723 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752436AbZFOTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:07:32 -0400
Date: Mon, 15 Jun 2009 21:08:34 +0200
From: Fabio Checconi <fchecconi@gmail.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] Use EDF to throttle RT tasks hierarchically
Message-ID: <20090615190834.GO21741@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1245092261.git.fabio@helm.retis>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to EDF to implement throttling in sched_rt.  This patch:

  - introduces a struct task_rt_group to abstract an EDF runqueue,
    capable to hold both tasks and groups;
  - adds two task_rt_groups to each task_group, one to store tasks,
    and another to store subgroups;
  - modifies the sched_rt class hooks in order to use the two
    task_rt_groups;
  - modifies the admission control code, in order to take into account
    of the new task-only subgroup.

Using two different runqueues is necessary because tasks have no deadlines
and cannot be mixed with groups, that now are scheduled by deadline
(assigned implicitly by the throttling algorithm).
---
 kernel/sched.c       |  508 ++++++++++++++++++++++++++++++++++----------------
 kernel/sched_debug.c |    4 +-
 kernel/sched_rt.c    |  288 +++++++++++++++++++++--------
 3 files changed, 559 insertions(+), 241 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 675ea96..bdae263 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -169,34 +169,10 @@ struct rt_bandwidth {
 	spinlock_t		rt_runtime_lock;
 	ktime_t			rt_period;
 	u64			rt_runtime;
-	struct hrtimer		rt_period_timer;
 };
 
 static struct rt_bandwidth def_rt_bandwidth;
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
-
-static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
-{
-	struct rt_bandwidth *rt_b =
-		container_of(timer, struct rt_bandwidth, rt_period_timer);
-	ktime_t now;
-	int overrun;
-	int idle = 0;
-
-	for (;;) {
-		now = hrtimer_cb_get_time(timer);
-		overrun = hrtimer_forward(timer, now, rt_b->rt_period);
-
-		if (!overrun)
-			break;
-
-		idle = do_sched_rt_period_timer(rt_b, overrun);
-	}
-
-	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
-}
-
 static
 void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 {
@@ -204,10 +180,6 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	rt_b->rt_runtime = runtime;
 
 	spin_lock_init(&rt_b->rt_runtime_lock);
-
-	hrtimer_init(&rt_b->rt_period_timer,
-			CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	rt_b->rt_period_timer.function = sched_rt_period_timer;
 }
 
 static inline int rt_bandwidth_enabled(void)
@@ -215,43 +187,6 @@ static inline int rt_bandwidth_enabled(void)
 	return sysctl_sched_rt_runtime >= 0;
 }
 
-static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	ktime_t now;
-
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
-		return;
-
-	if (hrtimer_active(&rt_b->rt_period_timer))
-		return;
-
-	spin_lock(&rt_b->rt_runtime_lock);
-	for (;;) {
-		unsigned long delta;
-		ktime_t soft, hard;
-
-		if (hrtimer_active(&rt_b->rt_period_timer))
-			break;
-
-		now = hrtimer_cb_get_time(&rt_b->rt_period_timer);
-		hrtimer_forward(&rt_b->rt_period_timer, now, rt_b->rt_period);
-
-		soft = hrtimer_get_softexpires(&rt_b->rt_period_timer);
-		hard = hrtimer_get_expires(&rt_b->rt_period_timer);
-		delta = ktime_to_ns(ktime_sub(hard, soft));
-		__hrtimer_start_range_ns(&rt_b->rt_period_timer, soft, delta,
-				HRTIMER_MODE_ABS_PINNED, 0);
-	}
-	spin_unlock(&rt_b->rt_runtime_lock);
-}
-
-#ifdef CONFIG_RT_GROUP_SCHED
-static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
-{
-	hrtimer_cancel(&rt_b->rt_period_timer);
-}
-#endif
-
 /*
  * sched_domains_mutex serializes calls to arch_init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
@@ -266,6 +201,18 @@ struct cfs_rq;
 
 static LIST_HEAD(task_groups);
 
+#ifdef CONFIG_RT_GROUP_SCHED
+struct task_group;
+
+struct task_rt_group {
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	struct rt_bandwidth rt_bandwidth;
+	struct task_group *tg;
+};
+#endif
+
 /* task group related information */
 struct task_group {
 #ifdef CONFIG_CGROUP_SCHED
@@ -285,10 +232,8 @@ struct task_group {
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity **rt_se;
-	struct rt_rq **rt_rq;
-
-	struct rt_bandwidth rt_bandwidth;
+	struct task_rt_group rt_rq_group;
+	struct task_rt_group rt_task_group;
 #endif
 
 	struct rcu_head rcu;
@@ -324,9 +269,17 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_task_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_task_rq) \
+			____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
+#ifdef CONFIG_RT_GROUP_SCHED
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_task_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_task_rq) \
+			____cacheline_aligned_in_smp;
+#endif
 #endif /* CONFIG_USER_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
@@ -394,8 +347,8 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
-	p->rt.parent = task_group(p)->rt_se[cpu];
+	p->rt.rt_rq  = task_group(p)->rt_task_group.rt_rq[cpu];
+	p->rt.parent = task_group(p)->rt_task_group.rt_se[cpu];
 #endif
 }
 
@@ -496,22 +449,31 @@ struct rt_rq {
 	int overloaded;
 	struct plist_head pushable_tasks;
 #endif
-	int rt_throttled;
+	int rt_flags;
+
+	u64 rt_deadline;
 	u64 rt_time;
 	u64 rt_runtime;
+	ktime_t rt_period;
+
+	struct hrtimer rt_period_timer;
+
 	/* Nests inside the rq lock: */
 	spinlock_t rt_runtime_lock;
 
-#ifdef CONFIG_RT_GROUP_SCHED
 	unsigned long rt_nr_boosted;
 
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct rq *rq;
 	struct list_head leaf_rt_rq_list;
-	struct task_group *tg;
+	struct task_rt_group *rt_tg;
 	struct sched_rt_entity *rt_se;
 #endif
 };
 
+#define RT_RQ_THROTTLED		1
+#define RT_RQ_NEEDS_UPDATE	2
+
 #ifdef CONFIG_SMP
 
 /*
@@ -6176,7 +6138,7 @@ recheck:
 		 * assigned.
 		 */
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
-				task_group(p)->rt_bandwidth.rt_runtime == 0)
+		    task_group(p)->rt_task_group.rt_bandwidth.rt_runtime == 0)
 			return -EPERM;
 #endif
 
@@ -9084,7 +9046,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 #endif
 
 	rt_rq->rt_time = 0;
-	rt_rq->rt_throttled = 0;
+	rt_rq->rt_flags = 0;
 	rt_rq->rt_runtime = 0;
 	spin_lock_init(&rt_rq->rt_runtime_lock);
 
@@ -9124,21 +9086,57 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
-		struct sched_rt_entity *rt_se, int cpu, int add,
-		struct sched_rt_entity *parent)
+static void init_tg_rt_rq(struct rt_rq *rt_rq, struct task_rt_group *rt_tg,
+			  int cpu, struct sched_rt_entity *rt_se,
+			  struct sched_rt_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
 
-	tg->rt_rq[cpu] = rt_rq;
+	rt_tg->rt_rq[cpu] = rt_rq;
 	init_rt_rq(rt_rq, rq);
-	rt_rq->tg = tg;
+	rt_rq->rt_tg = rt_tg;
 	rt_rq->rt_se = rt_se;
-	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
+
+	rt_rq->rt_runtime = rt_tg->rt_bandwidth.rt_runtime;
+	rt_rq->rt_period = rt_tg->rt_bandwidth.rt_period;
+
+	hrtimer_init(&rt_rq->rt_period_timer,
+		     CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	rt_rq->rt_period_timer.function = sched_rt_period_timer;
+
+	if (!rt_se)
+		return;
+
+	rt_tg->rt_se[cpu] = rt_se;
+	rt_se->parent = parent;
+	rt_se->my_q = rt_rq;
+	RB_CLEAR_NODE(&rt_se->rb_node);
+}
+
+static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
+		struct sched_rt_entity *rt_se, struct rt_rq *rt_task_rq,
+		struct sched_rt_entity *rt_task_se, int cpu, int add,
+		struct sched_rt_entity *parent)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	init_tg_rt_rq(rt_rq, &tg->rt_rq_group, cpu, rt_se, parent);
+
 	if (add)
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
-	tg->rt_se[cpu] = rt_se;
+	if (rt_task_rq) {
+		init_tg_rt_rq(rt_task_rq, &tg->rt_task_group,
+			      cpu, rt_task_se, rt_se);
+
+		if (add) {
+			list_add(&rt_task_rq->leaf_rt_rq_list,
+				 &rq->leaf_rt_rq_list);
+		}
+
+		rt_task_se->rt_rq = rt_rq;
+	}
+
 	if (!rt_se)
 		return;
 
@@ -9147,9 +9145,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	else
 		rt_se->rt_rq = parent->my_q;
 
-	rt_se->my_q = rt_rq;
-	rt_se->parent = parent;
-	RB_CLEAR_NODE(&rt_se->rb_node);
 }
 #endif
 
@@ -9162,7 +9157,7 @@ void __init sched_init(void)
 	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
-	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+	alloc_size += 4 * nr_cpu_ids * sizeof(void **);
 #endif
 #ifdef CONFIG_USER_SCHED
 	alloc_size *= 2;
@@ -9193,17 +9188,32 @@ void __init sched_init(void)
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
-		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		init_task_group.rt_rq_group.rt_se =
+					(struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		init_task_group.rt_rq = (struct rt_rq **)ptr;
+		init_task_group.rt_rq_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
+		init_task_group.rt_task_group.rt_se =
+					(struct sched_rt_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		init_task_group.rt_task_group.rt_rq = (struct rt_rq **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
 #ifdef CONFIG_USER_SCHED
-		root_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		root_task_group.rt_rq_group.rt_se =
+					(struct sched_rt_entity **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 
-		root_task_group.rt_rq = (struct rt_rq **)ptr;
+		root_task_group.rt_rq_group.rt_rq = (struct rt_rq **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		root_task_group.rt_task_group.rt_se =
+					(struct sched_rt_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		root_task_group.rt_task_group.rt_rq = (struct rt_rq **)ptr;
 		ptr += nr_cpu_ids * sizeof(void **);
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
@@ -9223,11 +9233,19 @@ void __init sched_init(void)
 			global_rt_period(), global_rt_runtime());
 
 #ifdef CONFIG_RT_GROUP_SCHED
-	init_rt_bandwidth(&init_task_group.rt_bandwidth,
+	init_rt_bandwidth(&init_task_group.rt_rq_group.rt_bandwidth,
+			global_rt_period(), global_rt_runtime());
+	init_rt_bandwidth(&init_task_group.rt_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
+	init_task_group.rt_rq_group.tg = &init_task_group;
+	init_task_group.rt_task_group.tg = &init_task_group;
 #ifdef CONFIG_USER_SCHED
-	init_rt_bandwidth(&root_task_group.rt_bandwidth,
+	init_rt_bandwidth(&root_task_group.rt_rq_group.rt_bandwidth,
+			global_rt_period(), RUNTIME_INF);
+	init_rt_bandwidth(&root_task_group.rt_task_group.rt_bandwidth,
 			global_rt_period(), RUNTIME_INF);
+	root_task_group.rt_rq_group.tg = &root_task_group;
+	root_task_group.rt_task_group.tg = &root_task_group;
 #endif /* CONFIG_USER_SCHED */
 #endif /* CONFIG_RT_GROUP_SCHED */
 
@@ -9302,13 +9320,19 @@ void __init sched_init(void)
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
 #ifdef CONFIG_CGROUP_SCHED
-		init_tg_rt_entry(&init_task_group, &rq->rt, NULL, i, 1, NULL);
+		init_tg_rt_entry(&init_task_group, &rq->rt, NULL,
+				 &per_cpu(init_rt_task_rq, i),
+				 &per_cpu(init_sched_rt_task_entity, i),
+				 i, 1, NULL);
 #elif defined CONFIG_USER_SCHED
-		init_tg_rt_entry(&root_task_group, &rq->rt, NULL, i, 0, NULL);
+		init_tg_rt_entry(&root_task_group, &rq->rt, NULL,
+				 NULL, NULL, i, 0, NULL);
 		init_tg_rt_entry(&init_task_group,
-				&per_cpu(init_rt_rq, i),
-				&per_cpu(init_sched_rt_entity, i), i, 1,
-				root_task_group.rt_se[i]);
+				 &per_cpu(init_rt_rq, i),
+				 &per_cpu(init_sched_rt_entity, i),
+				 &per_cpu(init_rt_task_rq, i),
+				 &per_cpu(init_sched_rt_task_entity, i),
+				 i, 1, root_task_group.rt_rq_group.rt_se[i]);
 #endif
 #endif
 
@@ -9601,40 +9625,61 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
-static void free_rt_sched_group(struct task_group *tg)
+
+static void free_rt_task_group(struct task_rt_group *rt_tg)
 {
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
-
 	for_each_possible_cpu(i) {
-		if (tg->rt_rq)
-			kfree(tg->rt_rq[i]);
-		if (tg->rt_se)
-			kfree(tg->rt_se[i]);
+		if (rt_tg->rt_rq[i]) {
+			hrtimer_cancel(&rt_tg->rt_rq[i]->rt_period_timer);
+			kfree(rt_tg->rt_rq[i]);
+		}
+		if (rt_tg->rt_se[i])
+			kfree(rt_tg->rt_se[i]);
 	}
 
-	kfree(tg->rt_rq);
-	kfree(tg->rt_se);
+	kfree(rt_tg->rt_rq);
+	kfree(rt_tg->rt_se);
+}
+
+static void free_rt_sched_group(struct task_group *tg)
+{
+	free_rt_task_group(&tg->rt_rq_group);
+	free_rt_task_group(&tg->rt_task_group);
 }
 
 static
 int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
-	struct rt_rq *rt_rq;
-	struct sched_rt_entity *rt_se;
+	struct rt_rq *rt_rq, *rt_task_rq;
+	struct sched_rt_entity *rt_se, *rt_task_se;
 	struct rq *rq;
 	int i;
 
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_rq)
+	tg->rt_rq_group.rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_rq_group.rt_rq)
+		goto err;
+	tg->rt_rq_group.rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
+	if (!tg->rt_rq_group.rt_se)
+		goto err;
+
+	tg->rt_task_group.rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids,
+					  GFP_KERNEL);
+	if (!tg->rt_task_group.rt_rq)
 		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
-	if (!tg->rt_se)
+	tg->rt_task_group.rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids,
+					  GFP_KERNEL);
+	if (!tg->rt_task_group.rt_se)
 		goto err;
 
-	init_rt_bandwidth(&tg->rt_bandwidth,
+	init_rt_bandwidth(&tg->rt_rq_group.rt_bandwidth,
+			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+	tg->rt_rq_group.tg = tg;
+
+	init_rt_bandwidth(&tg->rt_task_group.rt_bandwidth,
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
+	tg->rt_task_group.tg = tg;
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
@@ -9647,26 +9692,49 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		rt_se = kzalloc_node(sizeof(struct sched_rt_entity),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_se)
-			goto err;
+			goto free_rt_rq;
+
+		rt_task_rq = kzalloc_node(sizeof(struct rt_rq),
+					  GFP_KERNEL, cpu_to_node(i));
+		if (!rt_task_rq)
+			goto free_rt_se;
+
+		rt_task_se = kzalloc_node(sizeof(struct sched_rt_entity),
+					  GFP_KERNEL, cpu_to_node(i));
+		if (!rt_task_se)
+			goto free_rt_task_rq;
 
-		init_tg_rt_entry(tg, rt_rq, rt_se, i, 0, parent->rt_se[i]);
+		init_tg_rt_entry(tg, rt_rq, rt_se, rt_task_rq, rt_task_se,
+				 i, 0, parent->rt_rq_group.rt_se[i]);
 	}
 
 	return 1;
 
+ free_rt_task_rq:
+	kfree(rt_task_rq);
+
+ free_rt_se:
+	kfree(rt_se);
+
+ free_rt_rq:
+	kfree(rt_rq);
+
  err:
 	return 0;
 }
 
 static inline void register_rt_sched_group(struct task_group *tg, int cpu)
 {
-	list_add_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list,
+	list_add_rcu(&tg->rt_rq_group.rt_rq[cpu]->leaf_rt_rq_list,
+			&cpu_rq(cpu)->leaf_rt_rq_list);
+	list_add_rcu(&tg->rt_task_group.rt_rq[cpu]->leaf_rt_rq_list,
 			&cpu_rq(cpu)->leaf_rt_rq_list);
 }
 
 static inline void unregister_rt_sched_group(struct task_group *tg, int cpu)
 {
-	list_del_rcu(&tg->rt_rq[cpu]->leaf_rt_rq_list);
+	list_del_rcu(&tg->rt_rq_group.rt_rq[cpu]->leaf_rt_rq_list);
+	list_del_rcu(&tg->rt_task_group.rt_rq[cpu]->leaf_rt_rq_list);
 }
 #else /* !CONFIG_RT_GROUP_SCHED */
 static inline void free_rt_sched_group(struct task_group *tg)
@@ -9911,7 +9979,7 @@ static inline int tg_has_rt_tasks(struct task_group *tg)
 	struct task_struct *g, *p;
 
 	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+		if (rt_task(p) && rt_rq_of_se(&p->rt)->rt_tg->tg == tg)
 			return 1;
 	} while_each_thread(g, p);
 
@@ -9922,19 +9990,58 @@ struct rt_schedulable_data {
 	struct task_group *tg;
 	u64 rt_period;
 	u64 rt_runtime;
+	int rt_task_group;
 };
 
+static inline void rt_tg_parameters(struct task_rt_group *rt_tg,
+				    u64 *period, u64 *runtime)
+{
+	struct rt_bandwidth *rt_b = &rt_tg->rt_bandwidth;
+
+	*period = ktime_to_ns(rt_b->rt_period);
+	*runtime = rt_b->rt_runtime;
+
+}
+
+static unsigned long tg_utilization(struct task_group *tg,
+				    struct rt_schedulable_data *d)
+{
+	struct task_group *child;
+	unsigned long sum;
+	u64 period, runtime;
+
+	if (d && tg == d->tg && d->rt_task_group) {
+		period = d->rt_period;
+		runtime = d->rt_runtime;
+	} else
+		rt_tg_parameters(&tg->rt_task_group, &period, &runtime);
+
+	sum = to_ratio(period, runtime);
+
+	list_for_each_entry_rcu(child, &tg->children, siblings) {
+		if (d && child == d->tg && !d->rt_task_group) {
+			period = d->rt_period;
+			runtime = d->rt_runtime;
+		} else
+			rt_tg_parameters(&child->rt_rq_group,
+					 &period, &runtime);
+
+		sum += to_ratio(period, runtime);
+	}
+
+	return sum;
+}
+
 static int tg_schedulable(struct task_group *tg, void *data)
 {
 	struct rt_schedulable_data *d = data;
-	struct task_group *child;
-	unsigned long total, sum = 0;
+	unsigned long total, sum;
 	u64 period, runtime;
 
-	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	runtime = tg->rt_bandwidth.rt_runtime;
+	period = ktime_to_ns(tg->rt_rq_group.rt_bandwidth.rt_period);
+	runtime = tg->rt_rq_group.rt_bandwidth.rt_runtime;
 
-	if (tg == d->tg) {
+	if (tg == d->tg && !d->rt_task_group) {
 		period = d->rt_period;
 		runtime = d->rt_runtime;
 	}
@@ -9949,7 +10056,7 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	/*
 	 * Cannot have more runtime than the period.
 	 */
-	if (runtime > period && runtime != RUNTIME_INF)
+	if (runtime > period)
 		return -EINVAL;
 
 	/*
@@ -9969,17 +10076,7 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	/*
 	 * The sum of our children's runtime should not exceed our own.
 	 */
-	list_for_each_entry_rcu(child, &tg->children, siblings) {
-		period = ktime_to_ns(child->rt_bandwidth.rt_period);
-		runtime = child->rt_bandwidth.rt_runtime;
-
-		if (child == d->tg) {
-			period = d->rt_period;
-			runtime = d->rt_runtime;
-		}
-
-		sum += to_ratio(period, runtime);
-	}
+	sum = tg_utilization(tg, d);
 
 	if (sum > total)
 		return -EINVAL;
@@ -9987,40 +10084,54 @@ static int tg_schedulable(struct task_group *tg, void *data)
 	return 0;
 }
 
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
+static int __rt_schedulable(struct task_group *tg, u64 period,
+			    u64 runtime, int rt_task_group)
 {
 	struct rt_schedulable_data data = {
 		.tg = tg,
 		.rt_period = period,
 		.rt_runtime = runtime,
+		.rt_task_group = rt_task_group,
 	};
 
 	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
-static int tg_set_bandwidth(struct task_group *tg,
-		u64 rt_period, u64 rt_runtime)
+static void rt_rq_set_bandwidth(struct task_rt_group *rt_tg, int cpu,
+				u64 rt_period, u64 rt_runtime)
 {
+	struct rt_rq *rt_rq = rt_tg->rt_rq[cpu];
+
+	spin_lock(&rt_rq->rt_runtime_lock);
+	rt_rq->rt_runtime = rt_runtime;
+	rt_rq->rt_period = ns_to_ktime(rt_period);
+	spin_unlock(&rt_rq->rt_runtime_lock);
+}
+
+static int tg_set_bandwidth(struct task_group *tg, u64 rt_period,
+			    u64 rt_runtime, int rt_task_group)
+{
+	struct task_rt_group *rt_tg;
 	int i, err = 0;
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	err = __rt_schedulable(tg, rt_period, rt_runtime);
+	err = __rt_schedulable(tg, rt_period, rt_runtime, rt_task_group);
 	if (err)
 		goto unlock;
 
-	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
-	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
-	tg->rt_bandwidth.rt_runtime = rt_runtime;
+	if (rt_task_group)
+		rt_tg = &tg->rt_task_group;
+	else
+		rt_tg = &tg->rt_rq_group;
 
-	for_each_possible_cpu(i) {
-		struct rt_rq *rt_rq = tg->rt_rq[i];
+	spin_lock_irq(&rt_tg->rt_bandwidth.rt_runtime_lock);
+	rt_tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
+	rt_tg->rt_bandwidth.rt_runtime = rt_runtime;
 
-		spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_runtime = rt_runtime;
-		spin_unlock(&rt_rq->rt_runtime_lock);
-	}
-	spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
+	for_each_possible_cpu(i)
+		rt_rq_set_bandwidth(rt_tg, i, rt_period, rt_runtime);
+	spin_unlock_irq(&rt_tg->rt_bandwidth.rt_runtime_lock);
  unlock:
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
@@ -10032,22 +10143,22 @@ int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us)
 {
 	u64 rt_runtime, rt_period;
 
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period = ktime_to_ns(tg->rt_rq_group.rt_bandwidth.rt_period);
 	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
 	if (rt_runtime_us < 0)
 		rt_runtime = RUNTIME_INF;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_bandwidth(tg, rt_period, rt_runtime, 0);
 }
 
 long sched_group_rt_runtime(struct task_group *tg)
 {
 	u64 rt_runtime_us;
 
-	if (tg->rt_bandwidth.rt_runtime == RUNTIME_INF)
+	if (tg->rt_rq_group.rt_bandwidth.rt_runtime == RUNTIME_INF)
 		return -1;
 
-	rt_runtime_us = tg->rt_bandwidth.rt_runtime;
+	rt_runtime_us = tg->rt_rq_group.rt_bandwidth.rt_runtime;
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
@@ -10057,19 +10168,65 @@ int sched_group_set_rt_period(struct task_group *tg, long rt_period_us)
 	u64 rt_runtime, rt_period;
 
 	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
+	rt_runtime = tg->rt_rq_group.rt_bandwidth.rt_runtime;
 
 	if (rt_period == 0)
 		return -EINVAL;
 
-	return tg_set_bandwidth(tg, rt_period, rt_runtime);
+	return tg_set_bandwidth(tg, rt_period, rt_runtime, 0);
 }
 
 long sched_group_rt_period(struct task_group *tg)
 {
 	u64 rt_period_us;
 
-	rt_period_us = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	rt_period_us = ktime_to_ns(tg->rt_rq_group.rt_bandwidth.rt_period);
+	do_div(rt_period_us, NSEC_PER_USEC);
+	return rt_period_us;
+}
+
+int sched_group_set_task_rt_runtime(struct task_group *tg, long rt_runtime_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = ktime_to_ns(tg->rt_task_group.rt_bandwidth.rt_period);
+	rt_runtime = (u64)rt_runtime_us * NSEC_PER_USEC;
+	if (rt_runtime_us < 0)
+		rt_runtime = RUNTIME_INF;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime, 1);
+}
+
+long sched_group_task_rt_runtime(struct task_group *tg)
+{
+	u64 rt_runtime_us;
+
+	if (tg->rt_task_group.rt_bandwidth.rt_runtime == RUNTIME_INF)
+		return -1;
+
+	rt_runtime_us = tg->rt_task_group.rt_bandwidth.rt_runtime;
+	do_div(rt_runtime_us, NSEC_PER_USEC);
+	return rt_runtime_us;
+}
+
+int sched_group_set_task_rt_period(struct task_group *tg, long rt_period_us)
+{
+	u64 rt_runtime, rt_period;
+
+	rt_period = (u64)rt_period_us * NSEC_PER_USEC;
+	rt_runtime = tg->rt_task_group.rt_bandwidth.rt_runtime;
+
+	if (rt_period == 0)
+		return -EINVAL;
+
+	return tg_set_bandwidth(tg, rt_period, rt_runtime, 1);
+}
+
+long sched_group_task_rt_period(struct task_group *tg)
+{
+	u64 rt_period_us;
+
+	rt_period_us = ktime_to_ns(tg->rt_task_group.rt_bandwidth.rt_period);
 	do_div(rt_period_us, NSEC_PER_USEC);
 	return rt_period_us;
 }
@@ -10093,7 +10250,7 @@ static int sched_rt_global_constraints(void)
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	ret = __rt_schedulable(NULL, 0, 0);
+	ret = __rt_schedulable(NULL, 0, 0, 0);
 	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
@@ -10103,7 +10260,7 @@ static int sched_rt_global_constraints(void)
 int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
 {
 	/* Don't accept realtime tasks when there is no way for them to run */
-	if (rt_task(tsk) && tg->rt_bandwidth.rt_runtime == 0)
+	if (rt_task(tsk) && tg->rt_task_group.rt_bandwidth.rt_runtime == 0)
 		return 0;
 
 	return 1;
@@ -10131,6 +10288,7 @@ static int sched_rt_global_constraints(void)
 
 		spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = global_rt_runtime();
+		rt_rq->rt_period = ns_to_ktime(global_rt_period());
 		spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 	spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
@@ -10254,6 +10412,17 @@ static s64 cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft)
 	return sched_group_rt_runtime(cgroup_tg(cgrp));
 }
 
+static int cpu_rt_task_runtime_write(struct cgroup *cgrp, struct cftype *cft,
+				     s64 val)
+{
+	return sched_group_set_task_rt_runtime(cgroup_tg(cgrp), val);
+}
+
+static s64 cpu_rt_task_runtime_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_task_rt_runtime(cgroup_tg(cgrp));
+}
+
 static int cpu_rt_period_write_uint(struct cgroup *cgrp, struct cftype *cftype,
 		u64 rt_period_us)
 {
@@ -10264,6 +10433,17 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 {
 	return sched_group_rt_period(cgroup_tg(cgrp));
 }
+
+static int cpu_rt_task_period_write_uint(struct cgroup *cgrp,
+			struct cftype *cftype, u64 rt_period_us)
+{
+	return sched_group_set_task_rt_period(cgroup_tg(cgrp), rt_period_us);
+}
+
+static u64 cpu_rt_task_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_task_rt_period(cgroup_tg(cgrp));
+}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static struct cftype cpu_files[] = {
@@ -10285,6 +10465,16 @@ static struct cftype cpu_files[] = {
 		.read_u64 = cpu_rt_period_read_uint,
 		.write_u64 = cpu_rt_period_write_uint,
 	},
+	{
+		.name = "rt_task_runtime_us",
+		.read_s64 = cpu_rt_task_runtime_read,
+		.write_s64 = cpu_rt_task_runtime_write,
+	},
+	{
+		.name = "rt_task_period_us",
+		.read_u64 = cpu_rt_task_period_read_uint,
+		.write_u64 = cpu_rt_task_period_write_uint,
+	},
 #endif
 };
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 467ca72..895b2c7 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -222,7 +222,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 {
 #if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
 	char path[128];
-	struct task_group *tg = rt_rq->tg;
+	struct task_group *tg = rt_rq->rt_tg->tg;
 
 	task_group_path(tg, path, sizeof(path));
 
@@ -238,7 +238,7 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", #x, SPLIT_NS(rt_rq->x))
 
 	P(rt_nr_running);
-	P(rt_throttled);
+	P(rt_flags);
 	PN(rt_time);
 	PN(rt_runtime);
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index c23f3ad..5d2353f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -143,7 +143,7 @@ static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
-	if (!rt_rq->tg)
+	if (!rt_rq->rt_tg->tg)
 		return RUNTIME_INF;
 
 	return rt_rq->rt_runtime;
@@ -151,7 +151,7 @@ static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 
 static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 {
-	return ktime_to_ns(rt_rq->tg->rt_bandwidth.rt_period);
+	return ktime_to_ns(rt_rq->rt_tg->rt_bandwidth.rt_period);
 }
 
 #define for_each_leaf_rt_rq(rt_rq, rq) \
@@ -191,19 +191,7 @@ static void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 {
-	return rt_rq->rt_throttled && !rt_rq->rt_nr_boosted;
-}
-
-static int rt_se_boosted(struct sched_rt_entity *rt_se)
-{
-	struct rt_rq *rt_rq = group_rt_rq(rt_se);
-	struct task_struct *p;
-
-	if (rt_rq)
-		return !!rt_rq->rt_nr_boosted;
-
-	p = rt_task_of(rt_se);
-	return p->prio != p->normal_prio;
+	return (rt_rq->rt_flags & RT_RQ_THROTTLED) && !rt_rq->rt_nr_boosted;
 }
 
 #ifdef CONFIG_SMP
@@ -221,12 +209,13 @@ static inline const struct cpumask *sched_rt_period_mask(void)
 static inline
 struct rt_rq *sched_rt_period_rt_rq(struct rt_bandwidth *rt_b, int cpu)
 {
-	return container_of(rt_b, struct task_group, rt_bandwidth)->rt_rq[cpu];
+	return container_of(rt_b, struct task_rt_group,
+			    rt_bandwidth)->rt_rq[cpu];
 }
 
 static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 {
-	return &rt_rq->tg->rt_bandwidth;
+	return &rt_rq->rt_tg->rt_bandwidth;
 }
 
 #else /* !CONFIG_RT_GROUP_SCHED */
@@ -264,7 +253,7 @@ static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
 
 static inline int rt_rq_throttled(struct rt_rq *rt_rq)
 {
-	return rt_rq->rt_throttled;
+	return rt_rq->rt_flags & RT_RQ_THROTTLED;
 }
 
 static inline const struct cpumask *sched_rt_period_mask(void)
@@ -285,6 +274,18 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+static int rt_se_boosted(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+	struct task_struct *p;
+
+	if (rt_rq)
+		return !!rt_rq->rt_nr_boosted;
+
+	p = rt_task_of(rt_se);
+	return p->prio != p->normal_prio;
+}
+
 #ifdef CONFIG_SMP
 /*
  * Ensure this RQ takes back all the runtime it lend to its neighbours.
@@ -326,7 +327,7 @@ static void __enable_runtime(struct rq *rq)
 		spin_lock(&rt_rq->rt_runtime_lock);
 		rt_rq->rt_runtime = rt_b->rt_runtime;
 		rt_rq->rt_time = 0;
-		rt_rq->rt_throttled = 0;
+		rt_rq->rt_flags = 0;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
 	}
@@ -342,43 +343,97 @@ static void enable_runtime(struct rq *rq)
 }
 #endif /* CONFIG_SMP */
 
-static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
+static int __do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
+{
+	int idle = 1, enqueue = 0;
+
+	if (rt_rq->rt_time) {
+		u64 runtime;
+
+		runtime = rt_rq->rt_runtime;
+		rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
+		rt_rq->rt_deadline += overrun*ktime_to_ns(rt_rq->rt_period);
+		if ((rt_rq->rt_flags & RT_RQ_THROTTLED) &&
+		    rt_rq->rt_time < runtime) {
+			rt_rq->rt_flags &= ~RT_RQ_THROTTLED;
+			enqueue = 1;
+		}
+		if (rt_rq->rt_time || rt_rq->rt_nr_running)
+			idle = 0;
+	} else if (rt_rq->rt_nr_running)
+		idle = 0;
+
+	if (enqueue)
+		sched_rt_rq_enqueue(rt_rq);
+
+	return idle;
+}
+
+static int do_sched_rt_period_timer(struct rt_rq *rt_rq, int overrun)
 {
-	int i, idle = 1;
-	const struct cpumask *span;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	int idle;
 
-	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_rq->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
-	for_each_cpu(i, span) {
-		int enqueue = 0;
-		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
-		struct rq *rq = rq_of_rt_rq(rt_rq);
+	spin_lock(&rq->lock);
+	spin_lock(&rt_rq->rt_runtime_lock);
+	idle = __do_sched_rt_period_timer(rt_rq, overrun);
+	spin_unlock(&rt_rq->rt_runtime_lock);
+	spin_unlock(&rq->lock);
 
-		spin_lock(&rq->lock);
-		if (rt_rq->rt_time) {
-			u64 runtime;
+	return idle;
+}
 
-			spin_lock(&rt_rq->rt_runtime_lock);
-			runtime = rt_rq->rt_runtime;
-			rt_rq->rt_time -= min(rt_rq->rt_time, overrun*runtime);
-			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
-				rt_rq->rt_throttled = 0;
-				enqueue = 1;
-			}
-			if (rt_rq->rt_time || rt_rq->rt_nr_running)
-				idle = 0;
-			spin_unlock(&rt_rq->rt_runtime_lock);
-		} else if (rt_rq->rt_nr_running)
-			idle = 0;
+static enum hrtimer_restart sched_rt_period_timer(struct hrtimer *timer)
+{
+	struct rt_rq *rt_rq = container_of(timer, struct rt_rq,
+					   rt_period_timer);
+	int overrun;
+	int idle = 0;
+
+	for (;;) {
+		overrun = hrtimer_forward_now(timer, rt_rq->rt_period);
+
+		if (!overrun)
+			break;
 
-		if (enqueue)
-			sched_rt_rq_enqueue(rt_rq);
-		spin_unlock(&rq->lock);
+		idle = do_sched_rt_period_timer(rt_rq, overrun);
 	}
 
-	return idle;
+	return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
+}
+
+static void start_rt_period_timer(struct rt_rq *rt_rq)
+{
+	ktime_t now, delta, soft, hard, dline = ns_to_ktime(rt_rq->rt_deadline);
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	unsigned long range;
+	int overrun;
+
+	now = hrtimer_cb_get_time(&rt_rq->rt_period_timer);
+	delta = ktime_sub_ns(now, rq->clock);
+	dline = ktime_add(dline, delta);
+
+	hrtimer_set_expires(&rt_rq->rt_period_timer, dline);
+
+	for (;;) {
+		if (hrtimer_active(&rt_rq->rt_period_timer))
+			return;
+
+		overrun = hrtimer_forward_now(&rt_rq->rt_period_timer,
+					      rt_rq->rt_period);
+
+		if (overrun)
+			__do_sched_rt_period_timer(rt_rq, overrun);
+
+		soft = hrtimer_get_softexpires(&rt_rq->rt_period_timer);
+		hard = hrtimer_get_expires(&rt_rq->rt_period_timer);
+		range = ktime_to_ns(ktime_sub(hard, soft));
+		__hrtimer_start_range_ns(&rt_rq->rt_period_timer, soft,
+					 range, HRTIMER_MODE_ABS, 0);
+	}
 }
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -397,7 +452,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (rt_rq->rt_throttled)
+	if (rt_rq->rt_flags & RT_RQ_THROTTLED)
 		return rt_rq_throttled(rt_rq);
 
 	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
@@ -408,7 +463,8 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		return 0;
 
 	if (rt_rq->rt_time > runtime) {
-		rt_rq->rt_throttled = 1;
+		rt_rq->rt_flags |= RT_RQ_THROTTLED;
+		start_rt_period_timer(rt_rq);
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
@@ -460,6 +516,24 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
+static inline struct sched_rt_entity *__rt_edf_first(struct rt_edf_tree *tree)
+{
+	if (!tree->rb_leftmost)
+		return NULL;
+
+	return rb_entry(tree->rb_leftmost, struct sched_rt_entity, rb_node);
+}
+
+static inline struct sched_rt_entity *__rt_edf_next(struct sched_rt_entity *se)
+{
+	struct rb_node *next = rb_next(&se->rb_node);
+
+	if (!next)
+		return NULL;
+
+	return rb_entry(next, struct sched_rt_entity, rb_node);
+}
+
 #if defined CONFIG_SMP
 
 static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
@@ -526,14 +600,6 @@ void dec_rt_prio_smp(struct rt_rq *rt_rq, int prio, int prev_prio) {}
 
 #endif /* CONFIG_SMP */
 
-static inline struct sched_rt_entity *__rt_edf_first(struct rt_edf_tree *tree)
-{
-	if (!tree->rb_leftmost)
-		return NULL;
-
-	return rb_entry(tree->rb_leftmost, struct sched_rt_entity, rb_node);
-}
-
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 static void
 inc_rt_prio(struct rt_rq *rt_rq, int prio)
@@ -578,16 +644,11 @@ static inline void dec_rt_prio(struct rt_rq *rt_rq, int prio) {}
 
 #endif /* CONFIG_SMP || CONFIG_RT_GROUP_SCHED */
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
 static void
 inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted++;
-
-	if (rt_rq->tg)
-		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
 }
 
 static void
@@ -599,19 +660,6 @@ dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	WARN_ON(!rt_rq->rt_nr_running && rt_rq->rt_nr_boosted);
 }
 
-#else /* CONFIG_RT_GROUP_SCHED */
-
-static void
-inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
-{
-	start_rt_bandwidth(&def_rt_bandwidth);
-}
-
-static inline
-void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
-
-#endif /* CONFIG_RT_GROUP_SCHED */
-
 static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
@@ -637,10 +685,36 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 	dec_rt_group(rt_se, rt_rq);
 }
 
+static inline int rt_time_before(u64 a, u64 b)
+{
+	return (s64)(a - b) < 0;
+}
+
 static inline int rt_entity_before(struct sched_rt_entity *a,
 				   struct sched_rt_entity *b)
 {
-	return rt_se_prio(a) < rt_se_prio(b);
+	struct rt_rq *rqa = group_rt_rq(a), *rqb = group_rt_rq(b);
+
+	/*
+	 * Schedule by priority if:
+	 * - both a and b are tasks;
+	 * - both a and b are boosted;
+	 * - throttling is disabled system-wide.
+	 */
+	if ((!rqa && !rqb) || (rqa->rt_nr_boosted && rqb->rt_nr_boosted) ||
+	    global_rt_runtime() == RUNTIME_INF)
+		return rt_se_prio(a) < rt_se_prio(b);
+
+	/* Only a is boosted, choose it. */
+	if (rqa->rt_nr_boosted)
+		return 1;
+
+	/* Only b is boosted, choose it. */
+	if (rqb->rt_nr_boosted)
+		return 0;
+
+	/* Use the deadlines to order entities. */
+	return rt_time_before(rqa->rt_deadline, rqb->rt_deadline);
 }
 
 static void __rt_entity_insert(struct rt_edf_tree *tree,
@@ -698,6 +772,44 @@ static int __rt_entity_insert_head(struct rt_edf_tree *tree,
 	return 0;
 }
 
+static void rt_rq_update_deadline(struct rt_rq *rt_rq)
+{
+	struct rq *rq = rq_of_rt_rq(rt_rq);
+	u64 period = ktime_to_ns(rt_rq->rt_period);
+	u64 runtime = sched_rt_runtime(rt_rq);
+	u64 left, right;
+
+	/*
+	 * Update the deadline to the current time only if:
+	 * - it is in the past;
+	 * - using it would lead to a timeframe during which the
+	 *   group would exceed ist allocated bandwidth.
+	 *
+	 * For the second condition to hold, we check that in the
+	 * time left before the deadline, using the residual budget,
+	 * the group would exceed its runtime / period share.
+	 * In formula:
+	 *   rt_time / (deadline - rq->clock) >= runtime / period
+	 *
+	 * left and right are the two sides of the equation, after a bit
+	 * of shuffling to use multiplications instead of divisions.
+	 */
+	left = period * rt_rq->rt_time;
+	right = (rt_rq->rt_deadline - rq->clock) * rt_rq->rt_runtime;
+
+	if (rt_time_before(rt_rq->rt_deadline, rq->clock) ||
+	    rt_time_before(right, left)) {
+		rt_rq->rt_deadline = rq->clock;
+
+		while (rt_rq->rt_time > period) {
+			rt_rq->rt_deadline += period;
+			rt_rq->rt_time -= min(rt_rq->rt_time, runtime);
+		}
+	}
+
+	rt_rq->rt_flags &= ~RT_RQ_NEEDS_UPDATE;
+}
+
 static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
@@ -709,8 +821,13 @@ static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	 * get throttled and the current group doesn't have any other
 	 * active members.
 	 */
-	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
-		return;
+	if (group_rq) {
+		if (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running)
+			return;
+
+		if (group_rq->rt_flags & RT_RQ_NEEDS_UPDATE)
+			rt_rq_update_deadline(group_rq);
+	}
 
 	__rt_entity_insert(&rt_rq->active, rt_se);
 	inc_rt_tasks(rt_se, rt_rq);
@@ -734,6 +851,14 @@ static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 	dec_rt_tasks(rt_se, rt_rq);
 }
 
+static inline void __rt_entity_update_flags(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+	if (rt_rq && !on_rt_rq(rt_se))
+		rt_rq->rt_flags |= RT_RQ_NEEDS_UPDATE;
+}
+
 /*
  * Because the prio of an upper entry depends on the lower
  * entries, we must remove entries top - down.
@@ -748,6 +873,8 @@ static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 	}
 
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
+		__rt_entity_update_flags(rt_se);
+
 		if (on_rt_rq(rt_se))
 			__dequeue_rt_entity(rt_se);
 	}
@@ -899,9 +1026,10 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p,
+				  int sync)
 {
-	if (p->prio < rq->curr->prio) {
+	if (rt_entity_before(&p->rt, &rq->curr->rt)) {
 		resched_task(rq->curr);
 		return;
 	}
-- 
1.6.2.2

