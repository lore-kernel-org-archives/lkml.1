Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZHYJu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZHYJu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZHYJu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:50:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35784 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbZHYJu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:50:27 -0400
Date: Tue, 25 Aug 2009 15:20:28 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: [RFC v1 PATCH 4/7] sched: Enforce hard limits by throttling
Message-ID: <20090825095028.GT3663@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090825094729.GP3663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825094729.GP3663@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Enforce hard limits by throttling.

From: Bharata B Rao <bharata@linux.vnet.ibm.com>

Throttle the task-groups which exceed the runtime allocated to them.
Throttled group entities are removed from the run queue.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |   32 ++++++++++
 kernel/sched_debug.c  |    2 
 kernel/sched_fair.c   |  146 ++++++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 177 insertions(+), 4 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1124,6 +1124,7 @@ struct sched_entity {
 	u64			nr_failed_migrations_affine;
 	u64			nr_failed_migrations_running;
 	u64			nr_failed_migrations_hot;
+	u64			nr_failed_migrations_throttled;
 	u64			nr_forced_migrations;
 	u64			nr_forced2_migrations;
 
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1580,6 +1580,7 @@ update_group_shares_cpu(struct task_grou
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1597,9 +1598,11 @@ static int tg_shares_up(struct task_grou
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
 		 * run here it will not get delayed by group starvation.
+		 * Also if the group is throttled on this cpu, pretend that
+		 * it has no tasks.
 		 */
 		weight = tg->cfs_rq[i]->load.weight;
-		if (!weight)
+		if (!weight || cfs_rq_throttled(tg->cfs_rq[i]))
 			weight = NICE_0_LOAD;
 
 		tg->cfs_rq[i]->rq_weight = weight;
@@ -1623,6 +1626,7 @@ static int tg_shares_up(struct task_grou
  * Compute the cpu's hierarchical load factor for each task group.
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
+ * A throttled group's h_load is set to 0.
  */
 static int tg_load_down(struct task_group *tg, void *data)
 {
@@ -1631,6 +1635,8 @@ static int tg_load_down(struct task_grou
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
+	} else if (cfs_rq_throttled(tg->cfs_rq[cpu])) {
+		load = 0;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
 		load *= tg->cfs_rq[cpu]->shares;
@@ -1808,6 +1814,8 @@ static inline u64 global_cfs_runtime(voi
 	return RUNTIME_INF;
 }
 
+int task_group_throttled(struct task_group *tg, int cpu);
+
 static inline int cfs_bandwidth_enabled(struct task_group *tg)
 {
 	return tg->hard_limit_enabled;
@@ -1892,7 +1900,18 @@ static void init_cfs_hard_limits(struct 
 	return;
 }
 
+int task_group_throttled(struct task_group *tg, int cpu)
+{
+	return 0;
+}
+
 #endif /* CONFIG_CFS_HARD_LIMITS */
+
+#else /* CONFIG_FAIR_GROUP_SCHED */
+int task_group_throttled(struct task_group *tg, int cpu)
+{
+	return 0;
+}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #include "sched_stats.h"
@@ -3364,6 +3383,7 @@ int can_migrate_task(struct task_struct 
 	 * 1) running (obviously), or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
+	 * 4) end up in throttled task groups on this CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
 		schedstat_inc(p, se.nr_failed_migrations_affine);
@@ -3377,6 +3397,16 @@ int can_migrate_task(struct task_struct 
 	}
 
 	/*
+	 * Don't migrate the task if
+	 * - it belongs to a group which is throttled on this_cpu or
+	 * - it belongs to a group whose hierarchy is throttled on this_cpu
+	 */
+	if (task_group_throttled(task_group(p), this_cpu)) {
+		schedstat_inc(p, se.nr_failed_migrations_throttled);
+		return 0;
+	}
+
+	/*
 	 * Aggressive migration if:
 	 * 1) task is cache cold, or
 	 * 2) too many balance attempts have failed.
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -417,6 +417,7 @@ void proc_sched_show_task(struct task_st
 	P(se.nr_failed_migrations_affine);
 	P(se.nr_failed_migrations_running);
 	P(se.nr_failed_migrations_hot);
+	P(se.nr_failed_migrations_throttled);
 	P(se.nr_forced_migrations);
 	P(se.nr_forced2_migrations);
 	P(se.nr_wakeups);
@@ -491,6 +492,7 @@ void proc_sched_set_task(struct task_str
 	p->se.nr_failed_migrations_affine	= 0;
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
+	p->se.nr_failed_migrations_throttled	= 0;
 	p->se.nr_forced_migrations		= 0;
 	p->se.nr_forced2_migrations		= 0;
 	p->se.nr_wakeups			= 0;
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -186,6 +186,89 @@ find_matching_se(struct sched_entity **s
 	}
 }
 
+#ifdef CONFIG_CFS_HARD_LIMITS
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_rq->cfs_throttled;
+}
+
+/*
+ * Check if group entity exceeded its runtime. If so, mark the cfs_rq as
+ * throttled mark the current task for reschedling.
+ */
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	struct cfs_rq *cfs_rq;
+
+	cfs_rq = group_cfs_rq(se);
+
+	if (!cfs_bandwidth_enabled(cfs_rq->tg))
+		return;
+
+	if (cfs_rq->cfs_runtime == RUNTIME_INF)
+		return;
+
+	cfs_rq->cfs_time += delta_exec;
+
+	if (cfs_rq_throttled(cfs_rq))
+		return;
+
+	if (cfs_rq->cfs_time > cfs_rq->cfs_runtime) {
+		cfs_rq->cfs_throttled = 1;
+		resched_task(tsk_curr);
+	}
+}
+
+/*
+ * Check if the entity is throttled.
+ */
+static int entity_throttled(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+
+	/* Only group entities can be throttled */
+	if (entity_is_task(se))
+		return 0;
+
+	cfs_rq = group_cfs_rq(se);
+	if (cfs_rq_throttled(cfs_rq))
+		return 1;
+	return 0;
+}
+
+int task_group_throttled(struct task_group *tg, int cpu)
+{
+	struct sched_entity *se = tg->se[cpu];
+
+	for_each_sched_entity(se) {
+		if (entity_throttled(se))
+			return 1;
+	}
+	return 0;
+}
+
+#else
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	return;
+}
+
+static int entity_throttled(struct sched_entity *se)
+{
+	return 0;
+}
+
+#endif /* CONFIG_CFS_HARD_LIMITS */
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -241,6 +324,17 @@ find_matching_se(struct sched_entity **s
 {
 }
 
+static void sched_cfs_runtime_exceeded(struct sched_entity *se,
+	struct task_struct *tsk_curr, unsigned long delta_exec)
+{
+	return;
+}
+
+static int entity_throttled(struct sched_entity *se)
+{
+	return 0;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 static void add_cfs_rq_tasks_running(struct sched_entity *se,
@@ -505,7 +599,9 @@ __update_curr(struct cfs_rq *cfs_rq, str
 static void update_curr(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	struct rq *rq = rq_of(cfs_rq);
+	struct task_struct *tsk_curr = rq->curr;
+	u64 now = rq->clock;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -528,6 +624,8 @@ static void update_curr(struct cfs_rq *c
 
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
+	} else {
+		sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
 	}
 }
 
@@ -865,8 +963,40 @@ static struct sched_entity *pick_next_en
 	return se;
 }
 
+/*
+ * Called from put_prev_entity()
+ * If a group entity (@se) is found to be throttled, it will not be put back
+ * on @cfs_rq, which is equivalent to dequeing it.
+ */
+static void dequeue_throttled_entity(struct cfs_rq *cfs_rq,
+		struct sched_entity *se)
+{
+	unsigned long nr_tasks = group_cfs_rq(se)->nr_tasks_running;
+
+	__clear_buddies(cfs_rq, se);
+	account_entity_dequeue(cfs_rq, se);
+	cfs_rq->curr = NULL;
+
+	if (!nr_tasks)
+		return;
+
+	/*
+	 * Decrement the number of tasks this entity has from
+	 * all of its parent entities.
+	 */
+	sub_cfs_rq_tasks_running(se, nr_tasks);
+
+	/*
+	 * Decrement the number of tasks this entity has from
+	 * this cpu's rq.
+	 */
+	rq_of(cfs_rq)->nr_running -= nr_tasks;
+}
+
 static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 {
+	struct cfs_rq *gcfs_rq = group_cfs_rq(prev);
+
 	/*
 	 * If still on the runqueue then deactivate_task()
 	 * was not called and update_curr() has to be done:
@@ -876,6 +1006,15 @@ static void put_prev_entity(struct cfs_r
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		/*
+		 * If the group entity is throttled or if it has no
+		 * no child entities, then don't enqueue it back.
+		 */
+		if (entity_throttled(prev) ||
+			(gcfs_rq && !gcfs_rq->nr_running)) {
+			dequeue_throttled_entity(cfs_rq, prev);
+			return;
+		}
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -1541,6 +1680,7 @@ static struct task_struct *pick_next_tas
 
 	do {
 		se = pick_next_entity(cfs_rq);
+
 		/*
 		 * If se was a buddy, clear it so that it will have to earn
 		 * the favour again.
@@ -1650,9 +1790,9 @@ load_balance_fair(struct rq *this_rq, in
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or a group with no h_load (throttled)
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight || !busiest_h_load)
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
