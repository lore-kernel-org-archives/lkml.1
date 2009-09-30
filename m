Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZI3Mya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZI3Mya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 08:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZI3My3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 08:54:29 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48362 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbZI3My2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 08:54:28 -0400
Date: Wed, 30 Sep 2009 18:22:52 +0530
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
Subject: [RFC v2 PATCH 4/8] sched: Enforce hard limits by throttling
Message-ID: <20090930125252.GE19951@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090930124919.GA19951@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930124919.GA19951@in.ibm.com>
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
 include/linux/sched.h |    3 -
 kernel/sched.c        |   72 ++++++++++++++---
 kernel/sched_debug.c  |    2 
 kernel/sched_fair.c   |  210 ++++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sched_rt.c     |    3 -
 5 files changed, 265 insertions(+), 25 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..77ace43 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1024,7 +1024,7 @@ struct sched_domain;
 struct sched_class {
 	const struct sched_class *next;
 
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
+	int (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
@@ -1124,6 +1124,7 @@ struct sched_entity {
 	u64			nr_failed_migrations_affine;
 	u64			nr_failed_migrations_running;
 	u64			nr_failed_migrations_hot;
+	u64			nr_failed_migrations_throttled;
 	u64			nr_forced_migrations;
 	u64			nr_forced2_migrations;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 0147f6f..04c505f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1585,6 +1585,7 @@ update_group_shares_cpu(struct task_group *tg, int cpu,
 	}
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq);
 /*
  * Re-compute the task group their per cpu shares over the given domain.
  * This needs to be done in a bottom-up fashion because the rq weight of a
@@ -1602,9 +1603,11 @@ static int tg_shares_up(struct task_group *tg, void *data)
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
@@ -1628,6 +1631,7 @@ static int tg_shares_up(struct task_group *tg, void *data)
  * Compute the cpu's hierarchical load factor for each task group.
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
+ * A throttled group's h_load is set to 0.
  */
 static int tg_load_down(struct task_group *tg, void *data)
 {
@@ -1636,6 +1640,8 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
+	} else if (cfs_rq_throttled(tg->cfs_rq[cpu])) {
+		load = 0;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
 		load *= tg->cfs_rq[cpu]->shares;
@@ -1813,6 +1819,8 @@ static inline u64 global_cfs_runtime(void)
 	return RUNTIME_INF;
 }
 
+int task_group_throttled(struct task_group *tg, int cpu);
+
 static inline int cfs_bandwidth_enabled(struct task_group *tg)
 {
 	return tg->hard_limit_enabled;
@@ -1930,6 +1938,16 @@ static inline void rq_runtime_unlock(struct rq *rq)
 	return;
 }
 
+int task_group_throttled(struct task_group *tg, int cpu)
+{
+	return 0;
+}
+
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #include "sched_stats.h"
@@ -1981,14 +1999,17 @@ static void update_avg(u64 *avg, u64 sample)
 	*avg += diff >> 3;
 }
 
-static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
+static int enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
+	int ret;
+
 	if (wakeup)
 		p->se.start_runtime = p->se.sum_exec_runtime;
 
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup);
+	ret = p->sched_class->enqueue_task(rq, p, wakeup);
 	p->se.on_rq = 1;
+	return ret;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
@@ -2063,8 +2084,15 @@ static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 
-	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
+	/*
+	 * Increment rq->nr_running only if enqueue_task() succeeds.
+	 * enqueue_task() can fail when the task being activated belongs
+	 * to a throttled group. In this case, the task gets enqueued to
+	 * throttled group and the group will be enqueued later when it
+	 * gets unthrottled. rq->nr_running gets incremented at that time.
+	 */
+	if (!enqueue_task(rq, p, wakeup))
+		inc_nr_running(rq);
 }
 
 /*
@@ -3401,6 +3429,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 * 1) running (obviously), or
 	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
 	 * 3) are cache-hot on their current CPU.
+	 * 4) end up in throttled task groups on this CPU.
 	 */
 	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
 		schedstat_inc(p, se.nr_failed_migrations_affine);
@@ -3414,6 +3443,18 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	}
 
 	/*
+	 * Don't migrate the task if it belongs to a
+	 * - throttled group on its current cpu
+	 * - throttled group on this_cpu
+	 * - group whose hierarchy is throttled on this_cpu
+	 */
+	if (cfs_rq_throttled(cfs_rq_of(&p->se)) ||
+		task_group_throttled(task_group(p), this_cpu)) {
+		schedstat_inc(p, se.nr_failed_migrations_throttled);
+		return 0;
+	}
+
+	/*
 	 * Aggressive migration if:
 	 * 1) task is cache cold, or
 	 * 2) too many balance attempts have failed.
@@ -6096,8 +6137,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
-	if (on_rq)
+	if (on_rq) {
 		dequeue_task(rq, p, 0);
+		dec_nr_running(rq);
+	}
 	if (running)
 		p->sched_class->put_prev_task(rq, p);
 
@@ -6111,7 +6154,8 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	if (running)
 		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		if (!enqueue_task(rq, p, 0))
+			inc_nr_running(rq);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
@@ -6145,8 +6189,10 @@ void set_user_nice(struct task_struct *p, long nice)
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq)
+	if (on_rq) {
 		dequeue_task(rq, p, 0);
+		dec_nr_running(rq);
+	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -6155,7 +6201,8 @@ void set_user_nice(struct task_struct *p, long nice)
 	delta = p->prio - old_prio;
 
 	if (on_rq) {
-		enqueue_task(rq, p, 0);
+		if (!enqueue_task(rq, p, 0))
+			inc_nr_running(rq);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
@@ -10003,8 +10050,10 @@ void sched_move_task(struct task_struct *tsk)
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
-	if (on_rq)
+	if (on_rq) {
 		dequeue_task(rq, tsk, 0);
+		dec_nr_running(rq);
+	}
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
@@ -10018,7 +10067,8 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
 	if (on_rq)
-		enqueue_task(rq, tsk, 0);
+		if (!enqueue_task(rq, tsk, 0))
+			inc_nr_running(rq);
 
 	task_rq_unlock(rq, &flags);
 }
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index f4c30bc..8ce525f 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -417,6 +417,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.nr_failed_migrations_affine);
 	P(se.nr_failed_migrations_running);
 	P(se.nr_failed_migrations_hot);
+	P(se.nr_failed_migrations_throttled);
 	P(se.nr_forced_migrations);
 	P(se.nr_forced2_migrations);
 	P(se.nr_wakeups);
@@ -491,6 +492,7 @@ void proc_sched_set_task(struct task_struct *p)
 	p->se.nr_failed_migrations_affine	= 0;
 	p->se.nr_failed_migrations_running	= 0;
 	p->se.nr_failed_migrations_hot		= 0;
+	p->se.nr_failed_migrations_throttled	= 0;
 	p->se.nr_forced_migrations		= 0;
 	p->se.nr_forced2_migrations		= 0;
 	p->se.nr_wakeups			= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eeeddb8..f98c1c8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -186,6 +186,94 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
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
+int task_group_throttled(struct task_group *tg, int cpu)
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
@@ -241,6 +329,17 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
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
@@ -502,10 +601,12 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	update_min_vruntime(cfs_rq);
 }
 
-static void update_curr(struct cfs_rq *cfs_rq)
+static void update_curr_common(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr = cfs_rq->curr;
-	u64 now = rq_of(cfs_rq)->clock;
+	struct rq *rq = rq_of(cfs_rq);
+	struct task_struct *tsk_curr = rq->curr;
+	u64 now = rq->clock;
 	unsigned long delta_exec;
 
 	if (unlikely(!curr))
@@ -528,9 +629,23 @@ static void update_curr(struct cfs_rq *cfs_rq)
 
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
+	} else {
+		sched_cfs_runtime_exceeded(curr, tsk_curr, delta_exec);
 	}
 }
 
+static void update_curr(struct cfs_rq *cfs_rq)
+{
+	rq_runtime_lock(rq_of(cfs_rq));
+	update_curr_common(cfs_rq);
+	rq_runtime_unlock(rq_of(cfs_rq));
+}
+
+static inline void update_curr_locked(struct cfs_rq *cfs_rq)
+{
+	update_curr_common(cfs_rq);
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -734,13 +849,9 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	se->vruntime = vruntime;
 }
 
-static void
-enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
+static void enqueue_entity_common(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup)
 {
-	/*
-	 * Update run-time statistics of the 'current'.
-	 */
-	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
 
 	if (wakeup) {
@@ -754,6 +865,26 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int wakeup)
 		__enqueue_entity(cfs_rq, se);
 }
 
+static void enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		int wakeup)
+{
+	/*
+	 * Update run-time statistics of the 'current'.
+	 */
+	update_curr(cfs_rq);
+	enqueue_entity_common(cfs_rq, se, wakeup);
+}
+
+static void enqueue_entity_locked(struct cfs_rq *cfs_rq,
+		struct sched_entity *se, int wakeup)
+{
+	/*
+	 * Update run-time statistics of the 'current'.
+	 */
+	update_curr_locked(cfs_rq);
+	enqueue_entity_common(cfs_rq, se, wakeup);
+}
+
 static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->last == se)
@@ -865,8 +996,40 @@ static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
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
@@ -876,6 +1039,18 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
 
 	check_spread(cfs_rq, prev);
 	if (prev->on_rq) {
+		/*
+		 * If the group entity is throttled or if it has no
+		 * no child entities, then don't enqueue it back.
+		 */
+		rq_runtime_lock(rq_of(cfs_rq));
+		if (entity_throttled(prev) ||
+			(gcfs_rq && !gcfs_rq->nr_running)) {
+			dequeue_throttled_entity(cfs_rq, prev);
+			rq_runtime_unlock(rq_of(cfs_rq));
+			return;
+		}
+		rq_runtime_unlock(rq_of(cfs_rq));
 		update_stats_wait_start(cfs_rq, prev);
 		/* Put 'current' back into the tree. */
 		__enqueue_entity(cfs_rq, prev);
@@ -976,22 +1151,32 @@ static inline void hrtick_update(struct rq *rq)
  * The enqueue_task method is called before nr_running is
  * increased. Here we update the fair scheduling stats and
  * then put the task into the rbtree:
+ * Don't enqueue a throttled entity further into the hierarchy.
  */
-static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
+static int enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int throttled = 0;
 
+	rq_runtime_lock(rq);
 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
+		if (entity_throttled(se)) {
+			throttled = 1;
+			break;
+		}
 		cfs_rq = cfs_rq_of(se);
-		enqueue_entity(cfs_rq, se, wakeup);
+		enqueue_entity_locked(cfs_rq, se, wakeup);
 		wakeup = 1;
 	}
 
 	add_cfs_rq_tasks_running(&p->se, 1);
+	rq_runtime_unlock(rq);
+
 	hrtick_update(rq);
+	return throttled;
 }
 
 /*
@@ -1541,6 +1726,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 
 	do {
 		se = pick_next_entity(cfs_rq);
+
 		/*
 		 * If se was a buddy, clear it so that it will have to earn
 		 * the favour again.
@@ -1650,9 +1836,9 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		u64 rem_load, moved_load;
 
 		/*
-		 * empty group
+		 * empty group or a group with no h_load (throttled)
 		 */
-		if (!busiest_cfs_rq->task_weight)
+		if (!busiest_cfs_rq->task_weight || !busiest_h_load)
 			continue;
 
 		rem_load = (u64)rem_load_move * busiest_weight;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 478fff9..477d3b7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -846,7 +846,7 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 /*
  * Adding/removing a task to/from a priority array:
  */
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static int enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
 
@@ -859,6 +859,7 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 		enqueue_pushable_task(rq, p);
 
 	inc_cpu_load(rq, p->se.load.weight);
+	return 0;
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
