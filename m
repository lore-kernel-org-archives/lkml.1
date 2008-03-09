Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYCIRJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYCIRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYCIRJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:17 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:59689 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818AbYCIRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:16 -0400
Message-Id: <20080309170925.857156000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:51 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 01/17] sched: mix tasks and groups
Content-Disposition: inline; filename=dhaval-fairness-model.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows tasks and groups to exist in the same cfs_rq. With this
change the CFS group scheduling follows a 1/(M+N) model from a 1/(1+N)
fairness model where M tasks and N groups exist at the cfs_rq level.

[a.p.zijlstra@chello.nl: rt bits]
Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched_fair.c |   48 +++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_rt.c   |   15 ++++++++------
 3 files changed, 106 insertions(+), 11 deletions(-)

Index: linux-2.6-2/kernel/sched.c
===================================================================
--- linux-2.6-2.orig/kernel/sched.c
+++ linux-2.6-2/kernel/sched.c
@@ -273,18 +273,23 @@ struct task_group {
 };
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
+
+#ifdef CONFIG_USER_SCHED
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+#endif
 
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
+#ifdef CONFIG_USER_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+#endif
 
 static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
 static struct rt_rq *init_rt_rq_p[NR_CPUS];
@@ -7279,6 +7284,10 @@ static void init_tg_cfs_entry(struct rq 
 		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
 	tg->se[cpu] = se;
+	/* se could be NULL for init_task_group */
+	if (!se)
+		return;
+
 	se->cfs_rq = &rq->cfs;
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
@@ -7301,6 +7310,9 @@ static void init_tg_rt_entry(struct rq *
 		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 
 	tg->rt_se[cpu] = rt_se;
+	if (!rt_se)
+		return;
+
 	rt_se->rt_rq = &rq->rt;
 	rt_se->my_q = rt_rq;
 	rt_se->parent = NULL;
@@ -7343,18 +7355,56 @@ void __init sched_init(void)
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.shares = init_task_group_load;
 		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
+#ifdef CONFIG_CGROUP_SCHED
+		/*
+		 * How much cpu bandwidth does init_task_group get?
+		 *
+		 * In case of task-groups formed thr' the cgroup filesystem, it
+		 * gets 100% of the cpu resources in the system. This overall
+		 * system cpu resource is divided among the tasks of
+		 * init_task_group and its child task-groups in a fair manner,
+		 * based on each entity's (task or task-group's) weight
+		 * (se->load.weight).
+		 *
+		 * In other words, if init_task_group has 10 tasks of weight
+		 * 1024) and two child groups A0 and A1 (of weight 1024 each),
+		 * then A0's share of the cpu resource is:
+		 *
+		 * 	A0's bandwidth = 1024 / (10*1024 + 1024 + 1024) = 8.33%
+		 *
+		 * We achieve this by letting init_task_group's tasks sit
+		 * directly in rq->cfs (i.e init_task_group->se[] = NULL).
+		 */
+		init_tg_cfs_entry(rq, &init_task_group, &rq->cfs, NULL, i, 1);
+#elif defined CONFIG_USER_SCHED
+		/*
+		 * In case of task-groups formed thr' the user id of tasks,
+		 * init_task_group represents tasks belonging to root user.
+		 * Hence it forms a sibling of all subsequent groups formed.
+		 * In this case, init_task_group gets only a fraction of overall
+		 * system cpu resource, based on the weight assigned to root
+		 * user's cpu share (INIT_TASK_GROUP_LOAD). This is accomplished
+		 * by letting tasks of init_task_group sit in a separate cfs_rq
+		 * (init_cfs_rq) and having one entity represent this group of
+		 * tasks in rq->cfs (i.e init_task_group->se[] != NULL).
+		 */
 		init_tg_cfs_entry(rq, &init_task_group,
 				&per_cpu(init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1);
 
 #endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
+		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
 #ifdef CONFIG_RT_GROUP_SCHED
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
+#ifdef CONFIG_CGROUP_SCHED
+		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
+#elif defined CONFIG_USER_SCHED
 		init_tg_rt_entry(rq, &init_task_group,
 				&per_cpu(init_rt_rq, i),
 				&per_cpu(init_sched_rt_entity, i), i, 1);
-#else
-		rq->rt.rt_runtime = def_rt_bandwidth.rt_runtime;
+#endif
 #endif
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -1029,6 +1029,17 @@ out_set_cpu:
 }
 #endif /* CONFIG_SMP */
 
+/* return depth at which a sched entity is present in the hierarchy */
+static inline int depth_se(struct sched_entity *se)
+{
+	int depth = 0;
+
+	for_each_sched_entity(se)
+		depth++;
+
+	return depth;
+}
+
 
 /*
  * Preempt the current task with a newly woken task if needed:
@@ -1039,6 +1050,7 @@ static void check_preempt_wakeup(struct 
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	unsigned long gran;
+	int se_depth, pse_depth;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1056,6 +1068,27 @@ static void check_preempt_wakeup(struct 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks until we find their ancestors who are siblings of common
+	 * parent.
+	 */
+
+	/* First walk up until both entities are at same depth */
+	se_depth = depth_se(se);
+	pse_depth = depth_se(pse);
+
+	while (se_depth > pse_depth) {
+		se_depth--;
+		se = parent_entity(se);
+	}
+
+	while (pse_depth > se_depth) {
+		pse_depth--;
+		pse = parent_entity(pse);
+	}
+
 	while (!is_same_group(se, pse)) {
 		se = parent_entity(se);
 		pse = parent_entity(pse);
@@ -1122,13 +1155,22 @@ static void put_prev_task_fair(struct rq
 static struct task_struct *
 __load_balance_iterator(struct cfs_rq *cfs_rq, struct rb_node *curr)
 {
-	struct task_struct *p;
+	struct task_struct *p = NULL;
+	struct sched_entity *se;
 
 	if (!curr)
 		return NULL;
 
-	p = rb_entry(curr, struct task_struct, se.run_node);
-	cfs_rq->rb_load_balance_curr = rb_next(curr);
+	/* Skip over entities that are not tasks */
+	do {
+		se = rb_entry(curr, struct sched_entity, run_node);
+		curr = rb_next(curr);
+	} while (curr && !entity_is_task(se));
+
+	cfs_rq->rb_load_balance_curr = curr;
+
+	if (entity_is_task(se))
+		p = task_of(se);
 
 	return p;
 }
Index: linux-2.6-2/kernel/sched_rt.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_rt.c
+++ linux-2.6-2/kernel/sched_rt.c
@@ -374,11 +374,15 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
-	spin_lock(&rt_rq->rt_runtime_lock);
-	rt_rq->rt_time += delta_exec;
-	if (sched_rt_runtime_exceeded(rt_rq))
-		resched_task(curr);
-	spin_unlock(&rt_rq->rt_runtime_lock);
+	for_each_sched_rt_entity(rt_se) {
+		rt_rq = rt_rq_of_se(rt_se);
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_time += delta_exec;
+		if (sched_rt_runtime_exceeded(rt_rq))
+			resched_task(curr);
+		spin_unlock(&rt_rq->rt_runtime_lock);
+	}
 }
 
 static inline
@@ -477,7 +481,6 @@ static void dequeue_rt_entity(struct sch
  * entries, we must remove entries top - down.
  *
  * XXX: O(1/2 h^2) because we can only walk up, not down the chain.
- *      doesn't matter much for now, as h=2 for GROUP_SCHED.
  */
 static void dequeue_rt_stack(struct task_struct *p)
 {

--

