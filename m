Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYBYOQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYBYOQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYBYOQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:16:16 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:51920 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754139AbYBYOQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:16:13 -0500
Date: Mon, 25 Feb 2008 19:46:04 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
       serue@us.ibm.com, menage@google.com
Subject: [RFC, PATCH 1/2] sched: change the fairness model of the CFS group
	scheduler
Message-ID: <20080225141604.GA29213@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080225141504.GA27746@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225141504.GA27746@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows tasks and groups to exist in the same cfs_rq. With this
change the CFS group scheduling follows a 1/(M+N) model from a 1/(1+N)
fairness model where M tasks and N groups exist at the cfs_rq level.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched.c      |   46 +++++++++++++++++++++
 kernel/sched_fair.c |  113 +++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 137 insertions(+), 22 deletions(-)

Index: linux-2.6.25-rc2/kernel/sched.c
===================================================================
--- linux-2.6.25-rc2.orig/kernel/sched.c
+++ linux-2.6.25-rc2/kernel/sched.c
@@ -224,10 +224,13 @@ struct task_group {
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
@@ -7163,6 +7166,10 @@ static void init_tg_cfs_entry(struct rq 
 		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
 
 	tg->se[cpu] = se;
+	/* se could be NULL for init_task_group */
+	if (!se)
+		return;
+
 	se->cfs_rq = &rq->cfs;
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
@@ -7217,11 +7224,46 @@ void __init sched_init(void)
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
+		init_tg_rt_entry(rq, &init_task_group, &rq->rt, NULL, i, 1);
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
 #ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_runtime =
 			sysctl_sched_rt_runtime * NSEC_PER_USEC;
@@ -7435,6 +7477,10 @@ static int rebalance_shares(struct sched
 		unsigned long total_load = 0, total_shares;
 		struct task_group *tg = cfs_rq->tg;
 
+		/* Skip this group if there is no associated group entity */
+		if (unlikely(!tg->se[this_cpu]))
+			continue;
+
 		/* Gather total task load of this group across cpus */
 		for_each_cpu_mask(i, sdspan)
 			total_load += tg->cfs_rq[i]->load.weight;
Index: linux-2.6.25-rc2/kernel/sched_fair.c
===================================================================
--- linux-2.6.25-rc2.orig/kernel/sched_fair.c
+++ linux-2.6.25-rc2/kernel/sched_fair.c
@@ -732,6 +732,21 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
+/* return the cpu load contributed by a given group on a given cpu */
+static inline unsigned long group_cpu_load(struct task_group *tg, int cpu)
+{
+	struct sched_entity *se = tg->se[cpu], *top_se;
+	struct cfs_rq *cfs_rq = tg->cfs_rq[cpu];
+
+	if (unlikely(!se))
+		return cfs_rq->load.weight;
+
+	for_each_sched_entity(se)
+		top_se = se;
+
+	return top_se->load.weight;
+}
+
 #define GROUP_IMBALANCE_PCT	20
 
 #else	/* CONFIG_FAIR_GROUP_SCHED */
@@ -1073,6 +1088,17 @@ out_set_cpu:
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
@@ -1083,6 +1109,7 @@ static void check_preempt_wakeup(struct 
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	unsigned long gran;
+	int se_depth, pse_depth;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1100,6 +1127,27 @@ static void check_preempt_wakeup(struct 
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks untill we find their ancestors who are siblings of common
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
@@ -1166,13 +1214,22 @@ static void put_prev_task_fair(struct rq
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
@@ -1210,21 +1267,28 @@ load_balance_fair(struct rq *this_rq, in
 		struct cfs_rq *this_cfs_rq = busy_cfs_rq->tg->cfs_rq[this_cpu];
 		unsigned long maxload, task_load, group_weight;
 		unsigned long thisload, per_task_load;
-		struct sched_entity *se = busy_cfs_rq->tg->se[busiest->cpu];
+		struct task_group *tg = busy_cfs_rq->tg;
+		struct sched_entity *se = tg->se[busiest->cpu],
+				    *this_se = tg->se[this_cpu];
 
 		task_load = busy_cfs_rq->load.weight;
-		group_weight = se->load.weight;
+		if (!task_load)
+			continue;
+
+		group_weight = group_cpu_load(tg, busiest->cpu);
 
 		/*
-		 * 'group_weight' is contributed by tasks of total weight
+		 * 'group_weight' is contributed by entities of total weight
 		 * 'task_load'. To move 'rem_load_move' worth of weight only,
 		 * we need to move a maximum task load of:
 		 *
 		 * 	maxload = (remload / group_weight) * task_load;
 		 */
 		maxload = (rem_load_move * task_load) / group_weight;
+		if (!maxload)
+			continue;
 
-		if (!maxload || !task_load)
+		if (!busy_cfs_rq->nr_running)
 			continue;
 
 		per_task_load = task_load / busy_cfs_rq->nr_running;
@@ -1253,23 +1317,28 @@ load_balance_fair(struct rq *this_rq, in
 					       &cfs_rq_iterator);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		/*
-		 * load_moved holds the task load that was moved. The
-		 * effective (group) weight moved would be:
-		 * 	load_moved_eff = load_moved/task_load * group_weight;
-		 */
-		load_moved = (group_weight * load_moved) / task_load;
-
 		/* Adjust shares on both cpus to reflect load_moved */
-		group_weight -= load_moved;
-		set_se_shares(se, group_weight);
+		if (likely(se)) {
+			unsigned long load_moved_eff;
+			unsigned long se_shares;
 
-		se = busy_cfs_rq->tg->se[this_cpu];
-		if (!thisload)
-			group_weight = load_moved;
-		else
-			group_weight = se->load.weight + load_moved;
-		set_se_shares(se, group_weight);
+			/*
+			 * load_moved holds the task load that was moved. The
+			 * effective (group) weight moved would be:
+			 *	load_moved_eff = load_moved/task_load *
+			 *					group_weight;
+			 */
+			load_moved_eff = (se->load.weight *
+						 load_moved) / task_load;
+
+			set_se_shares(se, se->load.weight - load_moved_eff);
+			if (!thisload)
+				se_shares = load_moved_eff;
+			else
+				se_shares = this_se->load.weight +
+							load_moved_eff;
+			set_se_shares(this_se, se_shares);
+		}
 #endif
 
 		rem_load_move -= load_moved;
-- 
regards,
Dhaval
