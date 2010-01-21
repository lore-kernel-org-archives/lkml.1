Return-Path: <linux-kernel-owner+w=401wt.eu-S1754314Ab0AUNxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0AUNxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986Ab0AUNxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:53:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:46281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab0AUNxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:53:05 -0500
Date: Thu, 21 Jan 2010 13:52:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move load balance code into sched_fair.c
Message-ID: <tip-1e3c88bdeb1260edc341e45c9fb8efd182a5c511@git.kernel.org>
Git-Commit-ID: 1e3c88bdeb1260edc341e45c9fb8efd182a5c511
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jan 2010 13:52:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e3c88bdeb1260edc341e45c9fb8efd182a5c511
Gitweb:     http://git.kernel.org/tip/1e3c88bdeb1260edc341e45c9fb8efd182a5c511
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 17:00:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jan 2010 13:40:08 +0100

sched: Move load balance code into sched_fair.c

Straight fwd code movement.

Since non of the load-balance abstractions are used anymore, do away with
them and simplify the code some. In preparation move the code around.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      | 1919 +++------------------------------------------------
 kernel/sched_fair.c | 1765 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1844 insertions(+), 1840 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 64298a5..13a2acf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1805,6 +1805,51 @@ static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	raw_spin_unlock(&busiest->lock);
 	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
 }
+
+/*
+ * double_rq_lock - safely lock two runqueues
+ *
+ * Note this does not disable interrupts like task_rq_lock,
+ * you need to do so manually before calling.
+ */
+static void double_rq_lock(struct rq *rq1, struct rq *rq2)
+	__acquires(rq1->lock)
+	__acquires(rq2->lock)
+{
+	BUG_ON(!irqs_disabled());
+	if (rq1 == rq2) {
+		raw_spin_lock(&rq1->lock);
+		__acquire(rq2->lock);	/* Fake it out ;) */
+	} else {
+		if (rq1 < rq2) {
+			raw_spin_lock(&rq1->lock);
+			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
+		} else {
+			raw_spin_lock(&rq2->lock);
+			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
+		}
+	}
+	update_rq_clock(rq1);
+	update_rq_clock(rq2);
+}
+
+/*
+ * double_rq_unlock - safely unlock two runqueues
+ *
+ * Note this does not restore interrupts like task_rq_unlock,
+ * you need to do so manually after calling.
+ */
+static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
+	__releases(rq1->lock)
+	__releases(rq2->lock)
+{
+	raw_spin_unlock(&rq1->lock);
+	if (rq1 != rq2)
+		raw_spin_unlock(&rq2->lock);
+	else
+		__release(rq2->lock);
+}
+
 #endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1834,18 +1879,14 @@ static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
-#include "sched_stats.h"
-#include "sched_idletask.c"
-#include "sched_fair.c"
-#include "sched_rt.c"
-#ifdef CONFIG_SCHED_DEBUG
-# include "sched_debug.c"
-#endif
+static const struct sched_class rt_sched_class;
 
 #define sched_class_highest (&rt_sched_class)
 #define for_each_class(class) \
    for (class = sched_class_highest; class; class = class->next)
 
+#include "sched_stats.h"
+
 static void inc_nr_running(struct rq *rq)
 {
 	rq->nr_running++;
@@ -1912,6 +1953,37 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 }
 
 /*
+ * activate_task - move a task to the runqueue.
+ */
+static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	if (task_contributes_to_load(p))
+		rq->nr_uninterruptible--;
+
+	enqueue_task(rq, p, wakeup);
+	inc_nr_running(rq);
+}
+
+/*
+ * deactivate_task - remove a task from the runqueue.
+ */
+static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
+{
+	if (task_contributes_to_load(p))
+		rq->nr_uninterruptible++;
+
+	dequeue_task(rq, p, sleep);
+	dec_nr_running(rq);
+}
+
+#include "sched_idletask.c"
+#include "sched_fair.c"
+#include "sched_rt.c"
+#ifdef CONFIG_SCHED_DEBUG
+# include "sched_debug.c"
+#endif
+
+/*
  * __normal_prio - return the priority that is based on the static prio
  */
 static inline int __normal_prio(struct task_struct *p)
@@ -1957,30 +2029,6 @@ static int effective_prio(struct task_struct *p)
 	return p->prio;
 }
 
-/*
- * activate_task - move a task to the runqueue.
- */
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup)
-{
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible--;
-
-	enqueue_task(rq, p, wakeup);
-	inc_nr_running(rq);
-}
-
-/*
- * deactivate_task - remove a task from the runqueue.
- */
-static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
-{
-	if (task_contributes_to_load(p))
-		rq->nr_uninterruptible++;
-
-	dequeue_task(rq, p, sleep);
-	dec_nr_running(rq);
-}
-
 /**
  * task_curr - is this task currently executing on a CPU?
  * @p: the task in question.
@@ -3088,50 +3136,6 @@ static void update_cpu_load(struct rq *this_rq)
 #ifdef CONFIG_SMP
 
 /*
- * double_rq_lock - safely lock two runqueues
- *
- * Note this does not disable interrupts like task_rq_lock,
- * you need to do so manually before calling.
- */
-static void double_rq_lock(struct rq *rq1, struct rq *rq2)
-	__acquires(rq1->lock)
-	__acquires(rq2->lock)
-{
-	BUG_ON(!irqs_disabled());
-	if (rq1 == rq2) {
-		raw_spin_lock(&rq1->lock);
-		__acquire(rq2->lock);	/* Fake it out ;) */
-	} else {
-		if (rq1 < rq2) {
-			raw_spin_lock(&rq1->lock);
-			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
-		} else {
-			raw_spin_lock(&rq2->lock);
-			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
-		}
-	}
-	update_rq_clock(rq1);
-	update_rq_clock(rq2);
-}
-
-/*
- * double_rq_unlock - safely unlock two runqueues
- *
- * Note this does not restore interrupts like task_rq_unlock,
- * you need to do so manually after calling.
- */
-static void double_rq_unlock(struct rq *rq1, struct rq *rq2)
-	__releases(rq1->lock)
-	__releases(rq2->lock)
-{
-	raw_spin_unlock(&rq1->lock);
-	if (rq1 != rq2)
-		raw_spin_unlock(&rq2->lock);
-	else
-		__release(rq2->lock);
-}
-
-/*
  * sched_exec - execve() is a valuable balancing opportunity, because at
  * this point the task has the smallest effective memory and cache footprint.
  */
@@ -3179,1771 +3183,6 @@ again:
 	task_rq_unlock(rq, &flags);
 }
 
-/*
- * pull_task - move a task from a remote runqueue to the local runqueue.
- * Both runqueues must be locked.
- */
-static void pull_task(struct rq *src_rq, struct task_struct *p,
-		      struct rq *this_rq, int this_cpu)
-{
-	deactivate_task(src_rq, p, 0);
-	set_task_cpu(p, this_cpu);
-	activate_task(this_rq, p, 0);
-	check_preempt_curr(this_rq, p, 0);
-}
-
-/*
- * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
- */
-static
-int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
-		     struct sched_domain *sd, enum cpu_idle_type idle,
-		     int *all_pinned)
-{
-	int tsk_cache_hot = 0;
-	/*
-	 * We do not migrate tasks that are:
-	 * 1) running (obviously), or
-	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
-	 * 3) are cache-hot on their current CPU.
-	 */
-	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
-		schedstat_inc(p, se.nr_failed_migrations_affine);
-		return 0;
-	}
-	*all_pinned = 0;
-
-	if (task_running(rq, p)) {
-		schedstat_inc(p, se.nr_failed_migrations_running);
-		return 0;
-	}
-
-	/*
-	 * Aggressive migration if:
-	 * 1) task is cache cold, or
-	 * 2) too many balance attempts have failed.
-	 */
-
-	tsk_cache_hot = task_hot(p, rq->clock, sd);
-	if (!tsk_cache_hot ||
-		sd->nr_balance_failed > sd->cache_nice_tries) {
-#ifdef CONFIG_SCHEDSTATS
-		if (tsk_cache_hot) {
-			schedstat_inc(sd, lb_hot_gained[idle]);
-			schedstat_inc(p, se.nr_forced_migrations);
-		}
-#endif
-		return 1;
-	}
-
-	if (tsk_cache_hot) {
-		schedstat_inc(p, se.nr_failed_migrations_hot);
-		return 0;
-	}
-	return 1;
-}
-
-static unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator)
-{
-	int loops = 0, pulled = 0, pinned = 0;
-	struct task_struct *p;
-	long rem_load_move = max_load_move;
-
-	if (max_load_move == 0)
-		goto out;
-
-	pinned = 1;
-
-	/*
-	 * Start the load-balancing iterator:
-	 */
-	p = iterator->start(iterator->arg);
-next:
-	if (!p || loops++ > sysctl_sched_nr_migrate)
-		goto out;
-
-	if ((p->se.load.weight >> 1) > rem_load_move ||
-	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
-		p = iterator->next(iterator->arg);
-		goto next;
-	}
-
-	pull_task(busiest, p, this_rq, this_cpu);
-	pulled++;
-	rem_load_move -= p->se.load.weight;
-
-#ifdef CONFIG_PREEMPT
-	/*
-	 * NEWIDLE balancing is a source of latency, so preemptible kernels
-	 * will stop after the first task is pulled to minimize the critical
-	 * section.
-	 */
-	if (idle == CPU_NEWLY_IDLE)
-		goto out;
-#endif
-
-	/*
-	 * We only want to steal up to the prescribed amount of weighted load.
-	 */
-	if (rem_load_move > 0) {
-		if (p->prio < *this_best_prio)
-			*this_best_prio = p->prio;
-		p = iterator->next(iterator->arg);
-		goto next;
-	}
-out:
-	/*
-	 * Right now, this is one of only two places pull_task() is called,
-	 * so we can safely collect pull_task() stats here rather than
-	 * inside pull_task().
-	 */
-	schedstat_add(sd, lb_gained[idle], pulled);
-
-	if (all_pinned)
-		*all_pinned = pinned;
-
-	return max_load_move - rem_load_move;
-}
-
-/*
- * move_tasks tries to move up to max_load_move weighted load from busiest to
- * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
-{
-	const struct sched_class *class = sched_class_highest;
-	unsigned long total_load_moved = 0;
-	int this_best_prio = this_rq->curr->prio;
-
-	do {
-		total_load_moved +=
-			class->load_balance(this_rq, this_cpu, busiest,
-				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
-		class = class->next;
-
-#ifdef CONFIG_PREEMPT
-		/*
-		 * NEWIDLE balancing is a source of latency, so preemptible
-		 * kernels will stop after the first task is pulled to minimize
-		 * the critical section.
-		 */
-		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
-			break;
-#endif
-	} while (class && max_load_move > total_load_moved);
-
-	return total_load_moved > 0;
-}
-
-static int
-iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle,
-		   struct rq_iterator *iterator)
-{
-	struct task_struct *p = iterator->start(iterator->arg);
-	int pinned = 0;
-
-	while (p) {
-		if (can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
-			pull_task(busiest, p, this_rq, this_cpu);
-			/*
-			 * Right now, this is only the second place pull_task()
-			 * is called, so we can safely collect pull_task()
-			 * stats here rather than inside pull_task().
-			 */
-			schedstat_inc(sd, lb_gained[idle]);
-
-			return 1;
-		}
-		p = iterator->next(iterator->arg);
-	}
-
-	return 0;
-}
-
-/*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
- * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-			 struct sched_domain *sd, enum cpu_idle_type idle)
-{
-	const struct sched_class *class;
-
-	for_each_class(class) {
-		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
-			return 1;
-	}
-
-	return 0;
-}
-/********** Helpers for find_busiest_group ************************/
-/*
- * sd_lb_stats - Structure to store the statistics of a sched_domain
- * 		during load balancing.
- */
-struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
-
-	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
-	unsigned long this_nr_running;
-
-	/* Statistics of the busiest group */
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
-	unsigned long busiest_nr_running;
-
-	int group_imb; /* Is there imbalance in this sd */
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance; /* Is powersave balance needed for this sd */
-	struct sched_group *group_min; /* Least loaded group in sd */
-	struct sched_group *group_leader; /* Group which relieves group_min */
-	unsigned long min_load_per_task; /* load_per_task in group_min */
-	unsigned long leader_nr_running; /* Nr running of group_leader */
-	unsigned long min_nr_running; /* Nr running of group_min */
-#endif
-};
-
-/*
- * sg_lb_stats - stats of a sched_group required for load_balancing
- */
-struct sg_lb_stats {
-	unsigned long avg_load; /*Avg load across the CPUs of the group */
-	unsigned long group_load; /* Total load over the CPUs of the group */
-	unsigned long sum_nr_running; /* Nr tasks running in the group */
-	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
-	unsigned long group_capacity;
-	int group_imb; /* Is there an imbalance in the group ? */
-};
-
-/**
- * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
- * @group: The group whose first cpu is to be returned.
- */
-static inline unsigned int group_first_cpu(struct sched_group *group)
-{
-	return cpumask_first(sched_group_cpus(group));
-}
-
-/**
- * get_sd_load_idx - Obtain the load index for a given sched domain.
- * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
- */
-static inline int get_sd_load_idx(struct sched_domain *sd,
-					enum cpu_idle_type idle)
-{
-	int load_idx;
-
-	switch (idle) {
-	case CPU_NOT_IDLE:
-		load_idx = sd->busy_idx;
-		break;
-
-	case CPU_NEWLY_IDLE:
-		load_idx = sd->newidle_idx;
-		break;
-	default:
-		load_idx = sd->idle_idx;
-		break;
-	}
-
-	return load_idx;
-}
-
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * init_sd_power_savings_stats - Initialize power savings statistics for
- * the given sched_domain, during load balancing.
- *
- * @sd: Sched domain whose power-savings statistics are to be initialized.
- * @sds: Variable containing the statistics for sd.
- * @idle: Idle status of the CPU at which we're performing load-balancing.
- */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	/*
-	 * Busy processors will not participate in power savings
-	 * balance.
-	 */
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		sds->power_savings_balance = 0;
-	else {
-		sds->power_savings_balance = 1;
-		sds->min_nr_running = ULONG_MAX;
-		sds->leader_nr_running = 0;
-	}
-}
-
-/**
- * update_sd_power_savings_stats - Update the power saving stats for a
- * sched_domain while performing load balancing.
- *
- * @group: sched_group belonging to the sched_domain under consideration.
- * @sds: Variable containing the statistics of the sched_domain
- * @local_group: Does group contain the CPU for which we're performing
- * 		load balancing ?
- * @sgs: Variable containing the statistics of the group.
- */
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-
-	if (!sds->power_savings_balance)
-		return;
-
-	/*
-	 * If the local group is idle or completely loaded
-	 * no need to do power savings balance at this domain
-	 */
-	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
-				!sds->this_nr_running))
-		sds->power_savings_balance = 0;
-
-	/*
-	 * If a group is already running at full capacity or idle,
-	 * don't include that group in power savings calculations
-	 */
-	if (!sds->power_savings_balance ||
-		sgs->sum_nr_running >= sgs->group_capacity ||
-		!sgs->sum_nr_running)
-		return;
-
-	/*
-	 * Calculate the group which has the least non-idle load.
-	 * This is the group from where we need to pick up the load
-	 * for saving power
-	 */
-	if ((sgs->sum_nr_running < sds->min_nr_running) ||
-	    (sgs->sum_nr_running == sds->min_nr_running &&
-	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
-		sds->group_min = group;
-		sds->min_nr_running = sgs->sum_nr_running;
-		sds->min_load_per_task = sgs->sum_weighted_load /
-						sgs->sum_nr_running;
-	}
-
-	/*
-	 * Calculate the group which is almost near its
-	 * capacity but still has some space to pick up some load
-	 * from other group and save more power
-	 */
-	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
-		return;
-
-	if (sgs->sum_nr_running > sds->leader_nr_running ||
-	    (sgs->sum_nr_running == sds->leader_nr_running &&
-	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
-		sds->group_leader = group;
-		sds->leader_nr_running = sgs->sum_nr_running;
-	}
-}
-
-/**
- * check_power_save_busiest_group - see if there is potential for some power-savings balance
- * @sds: Variable containing the statistics of the sched_domain
- *	under consideration.
- * @this_cpu: Cpu at which we're currently performing load-balancing.
- * @imbalance: Variable to store the imbalance.
- *
- * Description:
- * Check if we have potential to perform some power-savings balance.
- * If yes, set the busiest group to be the least loaded group in the
- * sched_domain, so that it's CPUs can be put to idle.
- *
- * Returns 1 if there is potential to perform power-savings balance.
- * Else returns 0.
- */
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
-{
-	if (!sds->power_savings_balance)
-		return 0;
-
-	if (sds->this != sds->group_leader ||
-			sds->group_leader == sds->group_min)
-		return 0;
-
-	*imbalance = sds->min_load_per_task;
-	sds->busiest = sds->group_min;
-
-	return 1;
-
-}
-#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-static inline void init_sd_power_savings_stats(struct sched_domain *sd,
-	struct sd_lb_stats *sds, enum cpu_idle_type idle)
-{
-	return;
-}
-
-static inline void update_sd_power_savings_stats(struct sched_group *group,
-	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
-{
-	return;
-}
-
-static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
-					int this_cpu, unsigned long *imbalance)
-{
-	return 0;
-}
-#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
-
-
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
-{
-	return SCHED_LOAD_SCALE;
-}
-
-unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
-{
-	return default_scale_freq_power(sd, cpu);
-}
-
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
-{
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
-	unsigned long smt_gain = sd->smt_gain;
-
-	smt_gain /= weight;
-
-	return smt_gain;
-}
-
-unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
-{
-	return default_scale_smt_power(sd, cpu);
-}
-
-unsigned long scale_rt_power(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	u64 total, available;
-
-	sched_avg_update(rq);
-
-	total = sched_avg_period() + (rq->clock - rq->age_stamp);
-	available = total - rq->rt_avg;
-
-	if (unlikely((s64)total < SCHED_LOAD_SCALE))
-		total = SCHED_LOAD_SCALE;
-
-	total >>= SCHED_LOAD_SHIFT;
-
-	return div_u64(available, total);
-}
-
-static void update_cpu_power(struct sched_domain *sd, int cpu)
-{
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
-	unsigned long power = SCHED_LOAD_SCALE;
-	struct sched_group *sdg = sd->groups;
-
-	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
-	else
-		power *= default_scale_freq_power(sd, cpu);
-
-	power >>= SCHED_LOAD_SHIFT;
-
-	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-		if (sched_feat(ARCH_POWER))
-			power *= arch_scale_smt_power(sd, cpu);
-		else
-			power *= default_scale_smt_power(sd, cpu);
-
-		power >>= SCHED_LOAD_SHIFT;
-	}
-
-	power *= scale_rt_power(cpu);
-	power >>= SCHED_LOAD_SHIFT;
-
-	if (!power)
-		power = 1;
-
-	sdg->cpu_power = power;
-}
-
-static void update_group_power(struct sched_domain *sd, int cpu)
-{
-	struct sched_domain *child = sd->child;
-	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power;
-
-	if (!child) {
-		update_cpu_power(sd, cpu);
-		return;
-	}
-
-	power = 0;
-
-	group = child->groups;
-	do {
-		power += group->cpu_power;
-		group = group->next;
-	} while (group != child->groups);
-
-	sdg->cpu_power = power;
-}
-
-/**
- * update_sg_lb_stats - Update sched_group's statistics for load balancing.
- * @sd: The sched_domain whose statistics are to be updated.
- * @group: sched_group whose statistics are to be updated.
- * @this_cpu: Cpu for which load balance is currently performed.
- * @idle: Idle status of this_cpu
- * @load_idx: Load index of sched_domain of this_cpu for load calc.
- * @sd_idle: Idle status of the sched_domain containing group.
- * @local_group: Does group contain this_cpu.
- * @cpus: Set of cpus considered for load balancing.
- * @balance: Should we balance.
- * @sgs: variable to hold the statistics for this group.
- */
-static inline void update_sg_lb_stats(struct sched_domain *sd,
-			struct sched_group *group, int this_cpu,
-			enum cpu_idle_type idle, int load_idx, int *sd_idle,
-			int local_group, const struct cpumask *cpus,
-			int *balance, struct sg_lb_stats *sgs)
-{
-	unsigned long load, max_cpu_load, min_cpu_load;
-	int i;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
-	unsigned long sum_avg_load_per_task;
-	unsigned long avg_load_per_task;
-
-	if (local_group) {
-		balance_cpu = group_first_cpu(group);
-		if (balance_cpu == this_cpu)
-			update_group_power(sd, this_cpu);
-	}
-
-	/* Tally up the load of all CPUs in the group */
-	sum_avg_load_per_task = avg_load_per_task = 0;
-	max_cpu_load = 0;
-	min_cpu_load = ~0UL;
-
-	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
-		struct rq *rq = cpu_rq(i);
-
-		if (*sd_idle && rq->nr_running)
-			*sd_idle = 0;
-
-		/* Bias balancing toward cpus of our domain */
-		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
-				first_idle_cpu = 1;
-				balance_cpu = i;
-			}
-
-			load = target_load(i, load_idx);
-		} else {
-			load = source_load(i, load_idx);
-			if (load > max_cpu_load)
-				max_cpu_load = load;
-			if (min_cpu_load > load)
-				min_cpu_load = load;
-		}
-
-		sgs->group_load += load;
-		sgs->sum_nr_running += rq->nr_running;
-		sgs->sum_weighted_load += weighted_cpuload(i);
-
-		sum_avg_load_per_task += cpu_avg_load_per_task(i);
-	}
-
-	/*
-	 * First idle cpu or the first cpu(busiest) in this sched group
-	 * is eligible for doing load balancing at this and above
-	 * domains. In the newly idle case, we will allow all the cpu's
-	 * to do the newly idle load balance.
-	 */
-	if (idle != CPU_NEWLY_IDLE && local_group &&
-	    balance_cpu != this_cpu && balance) {
-		*balance = 0;
-		return;
-	}
-
-	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
-
-
-	/*
-	 * Consider the group unbalanced when the imbalance is larger
-	 * than the average weight of two tasks.
-	 *
-	 * APZ: with cgroup the avg task weight can vary wildly and
-	 *      might not be a suitable number - should we keep a
-	 *      normalized nr_running number somewhere that negates
-	 *      the hierarchy?
-	 */
-	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
-		group->cpu_power;
-
-	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
-		sgs->group_imb = 1;
-
-	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
-}
-
-/**
- * update_sd_lb_stats - Update sched_group's statistics for load balancing.
- * @sd: sched_domain whose statistics are to be updated.
- * @this_cpu: Cpu for which load balance is currently performed.
- * @idle: Idle status of this_cpu
- * @sd_idle: Idle status of the sched_domain containing group.
- * @cpus: Set of cpus considered for load balancing.
- * @balance: Should we balance.
- * @sds: variable to hold the statistics for this sched_domain.
- */
-static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
-			enum cpu_idle_type idle, int *sd_idle,
-			const struct cpumask *cpus, int *balance,
-			struct sd_lb_stats *sds)
-{
-	struct sched_domain *child = sd->child;
-	struct sched_group *group = sd->groups;
-	struct sg_lb_stats sgs;
-	int load_idx, prefer_sibling = 0;
-
-	if (child && child->flags & SD_PREFER_SIBLING)
-		prefer_sibling = 1;
-
-	init_sd_power_savings_stats(sd, sds, idle);
-	load_idx = get_sd_load_idx(sd, idle);
-
-	do {
-		int local_group;
-
-		local_group = cpumask_test_cpu(this_cpu,
-					       sched_group_cpus(group));
-		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
-				local_group, cpus, balance, &sgs);
-
-		if (local_group && balance && !(*balance))
-			return;
-
-		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->cpu_power;
-
-		/*
-		 * In case the child domain prefers tasks go to siblings
-		 * first, lower the group capacity to one so that we'll try
-		 * and move all the excess tasks away.
-		 */
-		if (prefer_sibling)
-			sgs.group_capacity = min(sgs.group_capacity, 1UL);
-
-		if (local_group) {
-			sds->this_load = sgs.avg_load;
-			sds->this = group;
-			sds->this_nr_running = sgs.sum_nr_running;
-			sds->this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > sds->max_load &&
-			   (sgs.sum_nr_running > sgs.group_capacity ||
-				sgs.group_imb)) {
-			sds->max_load = sgs.avg_load;
-			sds->busiest = group;
-			sds->busiest_nr_running = sgs.sum_nr_running;
-			sds->busiest_load_per_task = sgs.sum_weighted_load;
-			sds->group_imb = sgs.group_imb;
-		}
-
-		update_sd_power_savings_stats(group, sds, local_group, &sgs);
-		group = group->next;
-	} while (group != sd->groups);
-}
-
-/**
- * fix_small_imbalance - Calculate the minor imbalance that exists
- *			amongst the groups of a sched_domain, during
- *			load balancing.
- * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
- * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
- * @imbalance: Variable to store the imbalance.
- */
-static inline void fix_small_imbalance(struct sd_lb_stats *sds,
-				int this_cpu, unsigned long *imbalance)
-{
-	unsigned long tmp, pwr_now = 0, pwr_move = 0;
-	unsigned int imbn = 2;
-
-	if (sds->this_nr_running) {
-		sds->this_load_per_task /= sds->this_nr_running;
-		if (sds->busiest_load_per_task >
-				sds->this_load_per_task)
-			imbn = 1;
-	} else
-		sds->this_load_per_task =
-			cpu_avg_load_per_task(this_cpu);
-
-	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
-			sds->busiest_load_per_task * imbn) {
-		*imbalance = sds->busiest_load_per_task;
-		return;
-	}
-
-	/*
-	 * OK, we don't have enough imbalance to justify moving tasks,
-	 * however we may be able to increase total CPU power used by
-	 * moving them.
-	 */
-
-	pwr_now += sds->busiest->cpu_power *
-			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->cpu_power *
-			min(sds->this_load_per_task, sds->this_load);
-	pwr_now /= SCHED_LOAD_SCALE;
-
-	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
-		sds->busiest->cpu_power;
-	if (sds->max_load > tmp)
-		pwr_move += sds->busiest->cpu_power *
-			min(sds->busiest_load_per_task, sds->max_load - tmp);
-
-	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->cpu_power <
-		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
-		tmp = (sds->max_load * sds->busiest->cpu_power) /
-			sds->this->cpu_power;
-	else
-		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
-			sds->this->cpu_power;
-	pwr_move += sds->this->cpu_power *
-			min(sds->this_load_per_task, sds->this_load + tmp);
-	pwr_move /= SCHED_LOAD_SCALE;
-
-	/* Move if we gain throughput */
-	if (pwr_move > pwr_now)
-		*imbalance = sds->busiest_load_per_task;
-}
-
-/**
- * calculate_imbalance - Calculate the amount of imbalance present within the
- *			 groups of a given sched_domain during load balance.
- * @sds: statistics of the sched_domain whose imbalance is to be calculated.
- * @this_cpu: Cpu for which currently load balance is being performed.
- * @imbalance: The variable to store the imbalance.
- */
-static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
-		unsigned long *imbalance)
-{
-	unsigned long max_pull;
-	/*
-	 * In the presence of smp nice balancing, certain scenarios can have
-	 * max load less than avg load(as we skip the groups at or below
-	 * its cpu_power, while calculating max_load..)
-	 */
-	if (sds->max_load < sds->avg_load) {
-		*imbalance = 0;
-		return fix_small_imbalance(sds, this_cpu, imbalance);
-	}
-
-	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(sds->max_load - sds->avg_load,
-			sds->max_load - sds->busiest_load_per_task);
-
-	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
-			/ SCHED_LOAD_SCALE;
-
-	/*
-	 * if *imbalance is less than the average load per runnable task
-	 * there is no gaurantee that any tasks will be moved so we'll have
-	 * a think about bumping its value to force at least one task to be
-	 * moved
-	 */
-	if (*imbalance < sds->busiest_load_per_task)
-		return fix_small_imbalance(sds, this_cpu, imbalance);
-
-}
-/******* find_busiest_group() helpers end here *********************/
-
-/**
- * find_busiest_group - Returns the busiest group within the sched_domain
- * if there is an imbalance. If there isn't an imbalance, and
- * the user has opted for power-savings, it returns a group whose
- * CPUs can be put to idle by rebalancing those tasks elsewhere, if
- * such a group exists.
- *
- * Also calculates the amount of weighted load which should be moved
- * to restore balance.
- *
- * @sd: The sched_domain whose busiest group is to be returned.
- * @this_cpu: The cpu for which load balancing is currently being performed.
- * @imbalance: Variable which stores amount of weighted load which should
- *		be moved to restore balance/put a group to idle.
- * @idle: The idle status of this_cpu.
- * @sd_idle: The idleness of sd
- * @cpus: The set of CPUs under consideration for load-balancing.
- * @balance: Pointer to a variable indicating if this_cpu
- *	is the appropriate cpu to perform load balancing at this_level.
- *
- * Returns:	- the busiest group if imbalance exists.
- *		- If no imbalance and user has opted for power-savings balance,
- *		   return the least loaded group whose CPUs can be
- *		   put to idle by rebalancing its tasks onto our group.
- */
-static struct sched_group *
-find_busiest_group(struct sched_domain *sd, int this_cpu,
-		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const struct cpumask *cpus, int *balance)
-{
-	struct sd_lb_stats sds;
-
-	memset(&sds, 0, sizeof(sds));
-
-	/*
-	 * Compute the various statistics relavent for load balancing at
-	 * this level.
-	 */
-	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
-					balance, &sds);
-
-	/* Cases where imbalance does not exist from POV of this_cpu */
-	/* 1) this_cpu is not the appropriate cpu to perform load balancing
-	 *    at this level.
-	 * 2) There is no busy sibling group to pull from.
-	 * 3) This group is the busiest group.
-	 * 4) This group is more busy than the avg busieness at this
-	 *    sched_domain.
-	 * 5) The imbalance is within the specified limit.
-	 * 6) Any rebalance would lead to ping-pong
-	 */
-	if (balance && !(*balance))
-		goto ret;
-
-	if (!sds.busiest || sds.busiest_nr_running == 0)
-		goto out_balanced;
-
-	if (sds.this_load >= sds.max_load)
-		goto out_balanced;
-
-	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
-
-	if (sds.this_load >= sds.avg_load)
-		goto out_balanced;
-
-	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
-		goto out_balanced;
-
-	sds.busiest_load_per_task /= sds.busiest_nr_running;
-	if (sds.group_imb)
-		sds.busiest_load_per_task =
-			min(sds.busiest_load_per_task, sds.avg_load);
-
-	/*
-	 * We're trying to get all the cpus to the average_load, so we don't
-	 * want to push ourselves above the average load, nor do we wish to
-	 * reduce the max loaded cpu below the average load, as either of these
-	 * actions would just result in more rebalancing later, and ping-pong
-	 * tasks around. Thus we look for the minimum possible imbalance.
-	 * Negative imbalances (*we* are more loaded than anyone else) will
-	 * be counted as no imbalance for these purposes -- we can't fix that
-	 * by pulling tasks to us. Be careful of negative numbers as they'll
-	 * appear as very large values with unsigned longs.
-	 */
-	if (sds.max_load <= sds.busiest_load_per_task)
-		goto out_balanced;
-
-	/* Looks like there is an imbalance. Compute it */
-	calculate_imbalance(&sds, this_cpu, imbalance);
-	return sds.busiest;
-
-out_balanced:
-	/*
-	 * There is no obvious imbalance. But check if we can do some balancing
-	 * to save power.
-	 */
-	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
-		return sds.busiest;
-ret:
-	*imbalance = 0;
-	return NULL;
-}
-
-/*
- * find_busiest_queue - find the busiest runqueue among the cpus in group.
- */
-static struct rq *
-find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const struct cpumask *cpus)
-{
-	struct rq *busiest = NULL, *rq;
-	unsigned long max_load = 0;
-	int i;
-
-	for_each_cpu(i, sched_group_cpus(group)) {
-		unsigned long power = power_of(i);
-		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
-		unsigned long wl;
-
-		if (!cpumask_test_cpu(i, cpus))
-			continue;
-
-		rq = cpu_rq(i);
-		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
-		wl /= power;
-
-		if (capacity && rq->nr_running == 1 && wl > imbalance)
-			continue;
-
-		if (wl > max_load) {
-			max_load = wl;
-			busiest = rq;
-		}
-	}
-
-	return busiest;
-}
-
-/*
- * Max backoff if we encounter pinned tasks. Pretty arbitrary value, but
- * so long as it is large enough.
- */
-#define MAX_PINNED_INTERVAL	512
-
-/* Working cpumask for load_balance and load_balance_newidle. */
-static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
-
-/*
- * Check this_cpu to ensure it is balanced within domain. Attempt to move
- * tasks if there is an imbalance.
- */
-static int load_balance(int this_cpu, struct rq *this_rq,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance)
-{
-	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
-	struct sched_group *group;
-	unsigned long imbalance;
-	struct rq *busiest;
-	unsigned long flags;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
-
-	cpumask_copy(cpus, cpu_active_mask);
-
-	/*
-	 * When power savings policy is enabled for the parent domain, idle
-	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as CPU_IDLE, instead of
-	 * portraying it as CPU_NOT_IDLE.
-	 */
-	if (idle != CPU_NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		sd_idle = 1;
-
-	schedstat_inc(sd, lb_count[idle]);
-
-redo:
-	update_shares(sd);
-	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-				   cpus, balance);
-
-	if (*balance == 0)
-		goto out_balanced;
-
-	if (!group) {
-		schedstat_inc(sd, lb_nobusyg[idle]);
-		goto out_balanced;
-	}
-
-	busiest = find_busiest_queue(group, idle, imbalance, cpus);
-	if (!busiest) {
-		schedstat_inc(sd, lb_nobusyq[idle]);
-		goto out_balanced;
-	}
-
-	BUG_ON(busiest == this_rq);
-
-	schedstat_add(sd, lb_imbalance[idle], imbalance);
-
-	ld_moved = 0;
-	if (busiest->nr_running > 1) {
-		/*
-		 * Attempt to move tasks. If find_busiest_group has found
-		 * an imbalance but busiest->nr_running <= 1, the group is
-		 * still unbalanced. ld_moved simply stays zero, so it is
-		 * correctly treated as an imbalance.
-		 */
-		local_irq_save(flags);
-		double_rq_lock(this_rq, busiest);
-		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &all_pinned);
-		double_rq_unlock(this_rq, busiest);
-		local_irq_restore(flags);
-
-		/*
-		 * some other cpu did the load balance for us.
-		 */
-		if (ld_moved && this_cpu != smp_processor_id())
-			resched_cpu(this_cpu);
-
-		/* All tasks on this runqueue were pinned by CPU affinity */
-		if (unlikely(all_pinned)) {
-			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus))
-				goto redo;
-			goto out_balanced;
-		}
-	}
-
-	if (!ld_moved) {
-		schedstat_inc(sd, lb_failed[idle]);
-		sd->nr_balance_failed++;
-
-		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
-
-			raw_spin_lock_irqsave(&busiest->lock, flags);
-
-			/* don't kick the migration_thread, if the curr
-			 * task on busiest cpu can't be moved to this_cpu
-			 */
-			if (!cpumask_test_cpu(this_cpu,
-					      &busiest->curr->cpus_allowed)) {
-				raw_spin_unlock_irqrestore(&busiest->lock,
-							    flags);
-				all_pinned = 1;
-				goto out_one_pinned;
-			}
-
-			if (!busiest->active_balance) {
-				busiest->active_balance = 1;
-				busiest->push_cpu = this_cpu;
-				active_balance = 1;
-			}
-			raw_spin_unlock_irqrestore(&busiest->lock, flags);
-			if (active_balance)
-				wake_up_process(busiest->migration_thread);
-
-			/*
-			 * We've kicked active balancing, reset the failure
-			 * counter.
-			 */
-			sd->nr_balance_failed = sd->cache_nice_tries+1;
-		}
-	} else
-		sd->nr_balance_failed = 0;
-
-	if (likely(!active_balance)) {
-		/* We were unbalanced, so reset the balancing interval */
-		sd->balance_interval = sd->min_interval;
-	} else {
-		/*
-		 * If we've begun active balancing, start to back off. This
-		 * case may not be covered by the all_pinned logic if there
-		 * is only 1 task on the busy runqueue (because we don't call
-		 * move_tasks).
-		 */
-		if (sd->balance_interval < sd->max_interval)
-			sd->balance_interval *= 2;
-	}
-
-	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-
-	goto out;
-
-out_balanced:
-	schedstat_inc(sd, lb_balanced[idle]);
-
-	sd->nr_balance_failed = 0;
-
-out_one_pinned:
-	/* tune up the balancing interval */
-	if ((all_pinned && sd->balance_interval < MAX_PINNED_INTERVAL) ||
-			(sd->balance_interval < sd->max_interval))
-		sd->balance_interval *= 2;
-
-	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		ld_moved = -1;
-	else
-		ld_moved = 0;
-out:
-	if (ld_moved)
-		update_shares(sd);
-	return ld_moved;
-}
-
-/*
- * Check this_cpu to ensure it is balanced within domain. Attempt to move
- * tasks if there is an imbalance.
- *
- * Called from schedule when this_rq is about to become idle (CPU_NEWLY_IDLE).
- * this_rq is locked.
- */
-static int
-load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
-{
-	struct sched_group *group;
-	struct rq *busiest = NULL;
-	unsigned long imbalance;
-	int ld_moved = 0;
-	int sd_idle = 0;
-	int all_pinned = 0;
-	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
-
-	cpumask_copy(cpus, cpu_active_mask);
-
-	/*
-	 * When power savings policy is enabled for the parent domain, idle
-	 * sibling can pick up load irrespective of busy siblings. In this case,
-	 * let the state of idle sibling percolate up as IDLE, instead of
-	 * portraying it as CPU_NOT_IDLE.
-	 */
-	if (sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		sd_idle = 1;
-
-	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
-redo:
-	update_shares_locked(this_rq, sd);
-	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
-				   &sd_idle, cpus, NULL);
-	if (!group) {
-		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
-		goto out_balanced;
-	}
-
-	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance, cpus);
-	if (!busiest) {
-		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
-		goto out_balanced;
-	}
-
-	BUG_ON(busiest == this_rq);
-
-	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
-
-	ld_moved = 0;
-	if (busiest->nr_running > 1) {
-		/* Attempt to move tasks */
-		double_lock_balance(this_rq, busiest);
-		/* this_rq->clock is already updated */
-		update_rq_clock(busiest);
-		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-					imbalance, sd, CPU_NEWLY_IDLE,
-					&all_pinned);
-		double_unlock_balance(this_rq, busiest);
-
-		if (unlikely(all_pinned)) {
-			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus))
-				goto redo;
-		}
-	}
-
-	if (!ld_moved) {
-		int active_balance = 0;
-
-		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
-		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-			return -1;
-
-		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
-			return -1;
-
-		if (sd->nr_balance_failed++ < 2)
-			return -1;
-
-		/*
-		 * The only task running in a non-idle cpu can be moved to this
-		 * cpu in an attempt to completely freeup the other CPU
-		 * package. The same method used to move task in load_balance()
-		 * have been extended for load_balance_newidle() to speedup
-		 * consolidation at sched_mc=POWERSAVINGS_BALANCE_WAKEUP (2)
-		 *
-		 * The package power saving logic comes from
-		 * find_busiest_group().  If there are no imbalance, then
-		 * f_b_g() will return NULL.  However when sched_mc={1,2} then
-		 * f_b_g() will select a group from which a running task may be
-		 * pulled to this cpu in order to make the other package idle.
-		 * If there is no opportunity to make a package idle and if
-		 * there are no imbalance, then f_b_g() will return NULL and no
-		 * action will be taken in load_balance_newidle().
-		 *
-		 * Under normal task pull operation due to imbalance, there
-		 * will be more than one task in the source run queue and
-		 * move_tasks() will succeed.  ld_moved will be true and this
-		 * active balance code will not be triggered.
-		 */
-
-		/* Lock busiest in correct order while this_rq is held */
-		double_lock_balance(this_rq, busiest);
-
-		/*
-		 * don't kick the migration_thread, if the curr
-		 * task on busiest cpu can't be moved to this_cpu
-		 */
-		if (!cpumask_test_cpu(this_cpu, &busiest->curr->cpus_allowed)) {
-			double_unlock_balance(this_rq, busiest);
-			all_pinned = 1;
-			return ld_moved;
-		}
-
-		if (!busiest->active_balance) {
-			busiest->active_balance = 1;
-			busiest->push_cpu = this_cpu;
-			active_balance = 1;
-		}
-
-		double_unlock_balance(this_rq, busiest);
-		/*
-		 * Should not call ttwu while holding a rq->lock
-		 */
-		raw_spin_unlock(&this_rq->lock);
-		if (active_balance)
-			wake_up_process(busiest->migration_thread);
-		raw_spin_lock(&this_rq->lock);
-
-	} else
-		sd->nr_balance_failed = 0;
-
-	update_shares_locked(this_rq, sd);
-	return ld_moved;
-
-out_balanced:
-	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
-	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
-		return -1;
-	sd->nr_balance_failed = 0;
-
-	return 0;
-}
-
-/*
- * idle_balance is called by schedule() if this_cpu is about to become
- * idle. Attempts to pull tasks from other CPUs.
- */
-static void idle_balance(int this_cpu, struct rq *this_rq)
-{
-	struct sched_domain *sd;
-	int pulled_task = 0;
-	unsigned long next_balance = jiffies + HZ;
-
-	this_rq->idle_stamp = this_rq->clock;
-
-	if (this_rq->avg_idle < sysctl_sched_migration_cost)
-		return;
-
-	for_each_domain(this_cpu, sd) {
-		unsigned long interval;
-
-		if (!(sd->flags & SD_LOAD_BALANCE))
-			continue;
-
-		if (sd->flags & SD_BALANCE_NEWIDLE)
-			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd);
-
-		interval = msecs_to_jiffies(sd->balance_interval);
-		if (time_after(next_balance, sd->last_balance + interval))
-			next_balance = sd->last_balance + interval;
-		if (pulled_task) {
-			this_rq->idle_stamp = 0;
-			break;
-		}
-	}
-	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
-		/*
-		 * We are going idle. next_balance may be set based on
-		 * a busy processor. So reset next_balance.
-		 */
-		this_rq->next_balance = next_balance;
-	}
-}
-
-/*
- * active_load_balance is run by migration threads. It pushes running tasks
- * off the busiest CPU onto idle CPUs. It requires at least 1 task to be
- * running on each physical CPU where possible, and avoids physical /
- * logical imbalances.
- *
- * Called with busiest_rq locked.
- */
-static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
-{
-	int target_cpu = busiest_rq->push_cpu;
-	struct sched_domain *sd;
-	struct rq *target_rq;
-
-	/* Is there any task to move? */
-	if (busiest_rq->nr_running <= 1)
-		return;
-
-	target_rq = cpu_rq(target_cpu);
-
-	/*
-	 * This condition is "impossible", if it occurs
-	 * we need to fix it. Originally reported by
-	 * Bjorn Helgaas on a 128-cpu setup.
-	 */
-	BUG_ON(busiest_rq == target_rq);
-
-	/* move a task from busiest_rq to target_rq */
-	double_lock_balance(busiest_rq, target_rq);
-	update_rq_clock(busiest_rq);
-	update_rq_clock(target_rq);
-
-	/* Search for an sd spanning us and the target CPU. */
-	for_each_domain(target_cpu, sd) {
-		if ((sd->flags & SD_LOAD_BALANCE) &&
-		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
-				break;
-	}
-
-	if (likely(sd)) {
-		schedstat_inc(sd, alb_count);
-
-		if (move_one_task(target_rq, target_cpu, busiest_rq,
-				  sd, CPU_IDLE))
-			schedstat_inc(sd, alb_pushed);
-		else
-			schedstat_inc(sd, alb_failed);
-	}
-	double_unlock_balance(busiest_rq, target_rq);
-}
-
-#ifdef CONFIG_NO_HZ
-static struct {
-	atomic_t load_balancer;
-	cpumask_var_t cpu_mask;
-	cpumask_var_t ilb_grp_nohz_mask;
-} nohz ____cacheline_aligned = {
-	.load_balancer = ATOMIC_INIT(-1),
-};
-
-int get_nohz_load_balancer(void)
-{
-	return atomic_read(&nohz.load_balancer);
-}
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-/**
- * lowest_flag_domain - Return lowest sched_domain containing flag.
- * @cpu:	The cpu whose lowest level of sched domain is to
- *		be returned.
- * @flag:	The flag to check for the lowest sched_domain
- *		for the given cpu.
- *
- * Returns the lowest sched_domain of a cpu which contains the given flag.
- */
-static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
-{
-	struct sched_domain *sd;
-
-	for_each_domain(cpu, sd)
-		if (sd && (sd->flags & flag))
-			break;
-
-	return sd;
-}
-
-/**
- * for_each_flag_domain - Iterates over sched_domains containing the flag.
- * @cpu:	The cpu whose domains we're iterating over.
- * @sd:		variable holding the value of the power_savings_sd
- *		for cpu.
- * @flag:	The flag to filter the sched_domains to be iterated.
- *
- * Iterates over all the scheduler domains for a given cpu that has the 'flag'
- * set, starting from the lowest sched_domain to the highest.
- */
-#define for_each_flag_domain(cpu, sd, flag) \
-	for (sd = lowest_flag_domain(cpu, flag); \
-		(sd && (sd->flags & flag)); sd = sd->parent)
-
-/**
- * is_semi_idle_group - Checks if the given sched_group is semi-idle.
- * @ilb_group:	group to be checked for semi-idleness
- *
- * Returns:	1 if the group is semi-idle. 0 otherwise.
- *
- * We define a sched_group to be semi idle if it has atleast one idle-CPU
- * and atleast one non-idle CPU. This helper function checks if the given
- * sched_group is semi-idle or not.
- */
-static inline int is_semi_idle_group(struct sched_group *ilb_group)
-{
-	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
-					sched_group_cpus(ilb_group));
-
-	/*
-	 * A sched_group is semi-idle when it has atleast one busy cpu
-	 * and atleast one idle cpu.
-	 */
-	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
-		return 0;
-
-	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
-		return 0;
-
-	return 1;
-}
-/**
- * find_new_ilb - Finds the optimum idle load balancer for nomination.
- * @cpu:	The cpu which is nominating a new idle_load_balancer.
- *
- * Returns:	Returns the id of the idle load balancer if it exists,
- *		Else, returns >= nr_cpu_ids.
- *
- * This algorithm picks the idle load balancer such that it belongs to a
- * semi-idle powersavings sched_domain. The idea is to try and avoid
- * completely idle packages/cores just for the purpose of idle load balancing
- * when there are other idle cpu's which are better suited for that job.
- */
-static int find_new_ilb(int cpu)
-{
-	struct sched_domain *sd;
-	struct sched_group *ilb_group;
-
-	/*
-	 * Have idle load balancer selection from semi-idle packages only
-	 * when power-aware load balancing is enabled
-	 */
-	if (!(sched_smt_power_savings || sched_mc_power_savings))
-		goto out_done;
-
-	/*
-	 * Optimize for the case when we have no idle CPUs or only one
-	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
-	 */
-	if (cpumask_weight(nohz.cpu_mask) < 2)
-		goto out_done;
-
-	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
-		ilb_group = sd->groups;
-
-		do {
-			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.ilb_grp_nohz_mask);
-
-			ilb_group = ilb_group->next;
-
-		} while (ilb_group != sd->groups);
-	}
-
-out_done:
-	return cpumask_first(nohz.cpu_mask);
-}
-#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-static inline int find_new_ilb(int call_cpu)
-{
-	return cpumask_first(nohz.cpu_mask);
-}
-#endif
-
-/*
- * This routine will try to nominate the ilb (idle load balancing)
- * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus. If all the cpus in the system
- * go into this tickless mode, then there will be no ilb owner (as there is
- * no need for one) and all the cpus will sleep till the next wakeup event
- * arrives...
- *
- * For the ilb owner, tick is not stopped. And this tick will be used
- * for idle load balancing. ilb owner will still be part of
- * nohz.cpu_mask..
- *
- * While stopping the tick, this cpu will become the ilb owner if there
- * is no other owner. And will be the owner till that cpu becomes busy
- * or if all cpus in the system stop their ticks at which point
- * there is no need for ilb owner.
- *
- * When the ilb owner becomes busy, it nominates another owner, during the
- * next busy scheduler_tick()
- */
-int select_nohz_load_balancer(int stop_tick)
-{
-	int cpu = smp_processor_id();
-
-	if (stop_tick) {
-		cpu_rq(cpu)->in_nohz_recently = 1;
-
-		if (!cpu_active(cpu)) {
-			if (atomic_read(&nohz.load_balancer) != cpu)
-				return 0;
-
-			/*
-			 * If we are going offline and still the leader,
-			 * give up!
-			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
-				BUG();
-
-			return 0;
-		}
-
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
-
-		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
-			if (atomic_read(&nohz.load_balancer) == cpu)
-				atomic_set(&nohz.load_balancer, -1);
-			return 0;
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
-				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu) {
-			int new_ilb;
-
-			if (!(sched_smt_power_savings ||
-						sched_mc_power_savings))
-				return 1;
-			/*
-			 * Check to see if there is a more power-efficient
-			 * ilb.
-			 */
-			new_ilb = find_new_ilb(cpu);
-			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, -1);
-				resched_cpu(new_ilb);
-				return 0;
-			}
-			return 1;
-		}
-	} else {
-		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
-			return 0;
-
-		cpumask_clear_cpu(cpu, nohz.cpu_mask);
-
-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
-				BUG();
-	}
-	return 0;
-}
-#endif
-
-static DEFINE_SPINLOCK(balancing);
-
-/*
- * It checks each scheduling domain to see if it is due to be balanced,
- * and initiates a balancing operation if so.
- *
- * Balancing parameters are set up in arch_init_sched_domains.
- */
-static void rebalance_domains(int cpu, enum cpu_idle_type idle)
-{
-	int balance = 1;
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long interval;
-	struct sched_domain *sd;
-	/* Earliest time when we have to do rebalance again */
-	unsigned long next_balance = jiffies + 60*HZ;
-	int update_next_balance = 0;
-	int need_serialize;
-
-	for_each_domain(cpu, sd) {
-		if (!(sd->flags & SD_LOAD_BALANCE))
-			continue;
-
-		interval = sd->balance_interval;
-		if (idle != CPU_IDLE)
-			interval *= sd->busy_factor;
-
-		/* scale ms to jiffies */
-		interval = msecs_to_jiffies(interval);
-		if (unlikely(!interval))
-			interval = 1;
-		if (interval > HZ*NR_CPUS/10)
-			interval = HZ*NR_CPUS/10;
-
-		need_serialize = sd->flags & SD_SERIALIZE;
-
-		if (need_serialize) {
-			if (!spin_trylock(&balancing))
-				goto out;
-		}
-
-		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
-				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle, or one of our SMT siblings is
-				 * not idle.
-				 */
-				idle = CPU_NOT_IDLE;
-			}
-			sd->last_balance = jiffies;
-		}
-		if (need_serialize)
-			spin_unlock(&balancing);
-out:
-		if (time_after(next_balance, sd->last_balance + interval)) {
-			next_balance = sd->last_balance + interval;
-			update_next_balance = 1;
-		}
-
-		/*
-		 * Stop the load balance at this level. There is another
-		 * CPU in our sched group which is doing load balancing more
-		 * actively.
-		 */
-		if (!balance)
-			break;
-	}
-
-	/*
-	 * next_balance will be updated only when there is a need.
-	 * When the cpu is attached to null domain for ex, it will not be
-	 * updated.
-	 */
-	if (likely(update_next_balance))
-		rq->next_balance = next_balance;
-}
-
-/*
- * run_rebalance_domains is triggered when needed from the scheduler tick.
- * In CONFIG_NO_HZ case, the idle load balance owner will do the
- * rebalancing for all the cpus for whom scheduler ticks are stopped.
- */
-static void run_rebalance_domains(struct softirq_action *h)
-{
-	int this_cpu = smp_processor_id();
-	struct rq *this_rq = cpu_rq(this_cpu);
-	enum cpu_idle_type idle = this_rq->idle_at_tick ?
-						CPU_IDLE : CPU_NOT_IDLE;
-
-	rebalance_domains(this_cpu, idle);
-
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If this cpu is the owner for idle load balancing, then do the
-	 * balancing on behalf of the other idle cpus whose ticks are
-	 * stopped.
-	 */
-	if (this_rq->idle_at_tick &&
-	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		struct rq *rq;
-		int balance_cpu;
-
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
-			if (balance_cpu == this_cpu)
-				continue;
-
-			/*
-			 * If this cpu gets work to do, stop the load balancing
-			 * work being done for other cpus. Next load
-			 * balancing owner will pick it up.
-			 */
-			if (need_resched())
-				break;
-
-			rebalance_domains(balance_cpu, CPU_IDLE);
-
-			rq = cpu_rq(balance_cpu);
-			if (time_after(this_rq->next_balance, rq->next_balance))
-				this_rq->next_balance = rq->next_balance;
-		}
-	}
-#endif
-}
-
-static inline int on_null_domain(int cpu)
-{
-	return !rcu_dereference(cpu_rq(cpu)->sd);
-}
-
-/*
- * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
- */
-static inline void trigger_load_balance(struct rq *rq, int cpu)
-{
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpumask_clear_cpu(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			int ilb = find_new_ilb(cpu);
-
-			if (ilb < nr_cpu_ids)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpumask_test_cpu(cpu, nohz.cpu_mask))
-		return;
-#endif
-	/* Don't need to rebalance while attached to NULL domain */
-	if (time_after_eq(jiffies, rq->next_balance) &&
-	    likely(!on_null_domain(cpu)))
-		raise_softirq(SCHED_SOFTIRQ);
-}
-
-#else	/* CONFIG_SMP */
-
-/*
- * on UP we do not need to balance between CPUs:
- */
-static inline void idle_balance(int cpu, struct rq *rq)
-{
-}
-
 #endif
 
 DEFINE_PER_CPU(struct kernel_stat, kstat);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 7177860..5116b81 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1952,6 +1952,1762 @@ move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
+/*
+ * pull_task - move a task from a remote runqueue to the local runqueue.
+ * Both runqueues must be locked.
+ */
+static void pull_task(struct rq *src_rq, struct task_struct *p,
+		      struct rq *this_rq, int this_cpu)
+{
+	deactivate_task(src_rq, p, 0);
+	set_task_cpu(p, this_cpu);
+	activate_task(this_rq, p, 0);
+	check_preempt_curr(this_rq, p, 0);
+}
+
+/*
+ * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
+ */
+static
+int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
+		     struct sched_domain *sd, enum cpu_idle_type idle,
+		     int *all_pinned)
+{
+	int tsk_cache_hot = 0;
+	/*
+	 * We do not migrate tasks that are:
+	 * 1) running (obviously), or
+	 * 2) cannot be migrated to this CPU due to cpus_allowed, or
+	 * 3) are cache-hot on their current CPU.
+	 */
+	if (!cpumask_test_cpu(this_cpu, &p->cpus_allowed)) {
+		schedstat_inc(p, se.nr_failed_migrations_affine);
+		return 0;
+	}
+	*all_pinned = 0;
+
+	if (task_running(rq, p)) {
+		schedstat_inc(p, se.nr_failed_migrations_running);
+		return 0;
+	}
+
+	/*
+	 * Aggressive migration if:
+	 * 1) task is cache cold, or
+	 * 2) too many balance attempts have failed.
+	 */
+
+	tsk_cache_hot = task_hot(p, rq->clock, sd);
+	if (!tsk_cache_hot ||
+		sd->nr_balance_failed > sd->cache_nice_tries) {
+#ifdef CONFIG_SCHEDSTATS
+		if (tsk_cache_hot) {
+			schedstat_inc(sd, lb_hot_gained[idle]);
+			schedstat_inc(p, se.nr_forced_migrations);
+		}
+#endif
+		return 1;
+	}
+
+	if (tsk_cache_hot) {
+		schedstat_inc(p, se.nr_failed_migrations_hot);
+		return 0;
+	}
+	return 1;
+}
+
+static unsigned long
+balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+	      unsigned long max_load_move, struct sched_domain *sd,
+	      enum cpu_idle_type idle, int *all_pinned,
+	      int *this_best_prio, struct rq_iterator *iterator)
+{
+	int loops = 0, pulled = 0, pinned = 0;
+	struct task_struct *p;
+	long rem_load_move = max_load_move;
+
+	if (max_load_move == 0)
+		goto out;
+
+	pinned = 1;
+
+	/*
+	 * Start the load-balancing iterator:
+	 */
+	p = iterator->start(iterator->arg);
+next:
+	if (!p || loops++ > sysctl_sched_nr_migrate)
+		goto out;
+
+	if ((p->se.load.weight >> 1) > rem_load_move ||
+	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
+		p = iterator->next(iterator->arg);
+		goto next;
+	}
+
+	pull_task(busiest, p, this_rq, this_cpu);
+	pulled++;
+	rem_load_move -= p->se.load.weight;
+
+#ifdef CONFIG_PREEMPT
+	/*
+	 * NEWIDLE balancing is a source of latency, so preemptible kernels
+	 * will stop after the first task is pulled to minimize the critical
+	 * section.
+	 */
+	if (idle == CPU_NEWLY_IDLE)
+		goto out;
+#endif
+
+	/*
+	 * We only want to steal up to the prescribed amount of weighted load.
+	 */
+	if (rem_load_move > 0) {
+		if (p->prio < *this_best_prio)
+			*this_best_prio = p->prio;
+		p = iterator->next(iterator->arg);
+		goto next;
+	}
+out:
+	/*
+	 * Right now, this is one of only two places pull_task() is called,
+	 * so we can safely collect pull_task() stats here rather than
+	 * inside pull_task().
+	 */
+	schedstat_add(sd, lb_gained[idle], pulled);
+
+	if (all_pinned)
+		*all_pinned = pinned;
+
+	return max_load_move - rem_load_move;
+}
+
+/*
+ * move_tasks tries to move up to max_load_move weighted load from busiest to
+ * this_rq, as part of a balancing operation within domain "sd".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		      unsigned long max_load_move,
+		      struct sched_domain *sd, enum cpu_idle_type idle,
+		      int *all_pinned)
+{
+	const struct sched_class *class = sched_class_highest;
+	unsigned long total_load_moved = 0;
+	int this_best_prio = this_rq->curr->prio;
+
+	do {
+		total_load_moved +=
+			class->load_balance(this_rq, this_cpu, busiest,
+				max_load_move - total_load_moved,
+				sd, idle, all_pinned, &this_best_prio);
+		class = class->next;
+
+#ifdef CONFIG_PREEMPT
+		/*
+		 * NEWIDLE balancing is a source of latency, so preemptible
+		 * kernels will stop after the first task is pulled to minimize
+		 * the critical section.
+		 */
+		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
+			break;
+#endif
+	} while (class && max_load_move > total_load_moved);
+
+	return total_load_moved > 0;
+}
+
+static int
+iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle,
+		   struct rq_iterator *iterator)
+{
+	struct task_struct *p = iterator->start(iterator->arg);
+	int pinned = 0;
+
+	while (p) {
+		if (can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
+			pull_task(busiest, p, this_rq, this_cpu);
+			/*
+			 * Right now, this is only the second place pull_task()
+			 * is called, so we can safely collect pull_task()
+			 * stats here rather than inside pull_task().
+			 */
+			schedstat_inc(sd, lb_gained[idle]);
+
+			return 1;
+		}
+		p = iterator->next(iterator->arg);
+	}
+
+	return 0;
+}
+
+/*
+ * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * part of active balancing operations within "domain".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+			 struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	const struct sched_class *class;
+
+	for_each_class(class) {
+		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
+			return 1;
+	}
+
+	return 0;
+}
+/********** Helpers for find_busiest_group ************************/
+/*
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ * 		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+
+	/* Statistics of the busiest group */
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+
+	int group_imb; /* Is there imbalance in this sd */
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+	int power_savings_balance; /* Is powersave balance needed for this sd */
+	struct sched_group *group_min; /* Least loaded group in sd */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned long leader_nr_running; /* Nr running of group_leader */
+	unsigned long min_nr_running; /* Nr running of group_min */
+#endif
+};
+
+/*
+ * sg_lb_stats - stats of a sched_group required for load_balancing
+ */
+struct sg_lb_stats {
+	unsigned long avg_load; /*Avg load across the CPUs of the group */
+	unsigned long group_load; /* Total load over the CPUs of the group */
+	unsigned long sum_nr_running; /* Nr tasks running in the group */
+	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
+	unsigned long group_capacity;
+	int group_imb; /* Is there an imbalance in the group ? */
+};
+
+/**
+ * group_first_cpu - Returns the first cpu in the cpumask of a sched_group.
+ * @group: The group whose first cpu is to be returned.
+ */
+static inline unsigned int group_first_cpu(struct sched_group *group)
+{
+	return cpumask_first(sched_group_cpus(group));
+}
+
+/**
+ * get_sd_load_idx - Obtain the load index for a given sched domain.
+ * @sd: The sched_domain whose load_idx is to be obtained.
+ * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ */
+static inline int get_sd_load_idx(struct sched_domain *sd,
+					enum cpu_idle_type idle)
+{
+	int load_idx;
+
+	switch (idle) {
+	case CPU_NOT_IDLE:
+		load_idx = sd->busy_idx;
+		break;
+
+	case CPU_NEWLY_IDLE:
+		load_idx = sd->newidle_idx;
+		break;
+	default:
+		load_idx = sd->idle_idx;
+		break;
+	}
+
+	return load_idx;
+}
+
+
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * init_sd_power_savings_stats - Initialize power savings statistics for
+ * the given sched_domain, during load balancing.
+ *
+ * @sd: Sched domain whose power-savings statistics are to be initialized.
+ * @sds: Variable containing the statistics for sd.
+ * @idle: Idle status of the CPU at which we're performing load-balancing.
+ */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	/*
+	 * Busy processors will not participate in power savings
+	 * balance.
+	 */
+	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+		sds->power_savings_balance = 0;
+	else {
+		sds->power_savings_balance = 1;
+		sds->min_nr_running = ULONG_MAX;
+		sds->leader_nr_running = 0;
+	}
+}
+
+/**
+ * update_sd_power_savings_stats - Update the power saving stats for a
+ * sched_domain while performing load balancing.
+ *
+ * @group: sched_group belonging to the sched_domain under consideration.
+ * @sds: Variable containing the statistics of the sched_domain
+ * @local_group: Does group contain the CPU for which we're performing
+ * 		load balancing ?
+ * @sgs: Variable containing the statistics of the group.
+ */
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
+
+	if (!sds->power_savings_balance)
+		return;
+
+	/*
+	 * If the local group is idle or completely loaded
+	 * no need to do power savings balance at this domain
+	 */
+	if (local_group && (sds->this_nr_running >= sgs->group_capacity ||
+				!sds->this_nr_running))
+		sds->power_savings_balance = 0;
+
+	/*
+	 * If a group is already running at full capacity or idle,
+	 * don't include that group in power savings calculations
+	 */
+	if (!sds->power_savings_balance ||
+		sgs->sum_nr_running >= sgs->group_capacity ||
+		!sgs->sum_nr_running)
+		return;
+
+	/*
+	 * Calculate the group which has the least non-idle load.
+	 * This is the group from where we need to pick up the load
+	 * for saving power
+	 */
+	if ((sgs->sum_nr_running < sds->min_nr_running) ||
+	    (sgs->sum_nr_running == sds->min_nr_running &&
+	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
+		sds->group_min = group;
+		sds->min_nr_running = sgs->sum_nr_running;
+		sds->min_load_per_task = sgs->sum_weighted_load /
+						sgs->sum_nr_running;
+	}
+
+	/*
+	 * Calculate the group which is almost near its
+	 * capacity but still has some space to pick up some load
+	 * from other group and save more power
+	 */
+	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
+		return;
+
+	if (sgs->sum_nr_running > sds->leader_nr_running ||
+	    (sgs->sum_nr_running == sds->leader_nr_running &&
+	     group_first_cpu(group) < group_first_cpu(sds->group_leader))) {
+		sds->group_leader = group;
+		sds->leader_nr_running = sgs->sum_nr_running;
+	}
+}
+
+/**
+ * check_power_save_busiest_group - see if there is potential for some power-savings balance
+ * @sds: Variable containing the statistics of the sched_domain
+ *	under consideration.
+ * @this_cpu: Cpu at which we're currently performing load-balancing.
+ * @imbalance: Variable to store the imbalance.
+ *
+ * Description:
+ * Check if we have potential to perform some power-savings balance.
+ * If yes, set the busiest group to be the least loaded group in the
+ * sched_domain, so that it's CPUs can be put to idle.
+ *
+ * Returns 1 if there is potential to perform power-savings balance.
+ * Else returns 0.
+ */
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	if (!sds->power_savings_balance)
+		return 0;
+
+	if (sds->this != sds->group_leader ||
+			sds->group_leader == sds->group_min)
+		return 0;
+
+	*imbalance = sds->min_load_per_task;
+	sds->busiest = sds->group_min;
+
+	return 1;
+
+}
+#else /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+static inline void init_sd_power_savings_stats(struct sched_domain *sd,
+	struct sd_lb_stats *sds, enum cpu_idle_type idle)
+{
+	return;
+}
+
+static inline void update_sd_power_savings_stats(struct sched_group *group,
+	struct sd_lb_stats *sds, int local_group, struct sg_lb_stats *sgs)
+{
+	return;
+}
+
+static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
+					int this_cpu, unsigned long *imbalance)
+{
+	return 0;
+}
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+
+
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return SCHED_LOAD_SCALE;
+}
+
+unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_freq_power(sd, cpu);
+}
+
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long smt_gain = sd->smt_gain;
+
+	smt_gain /= weight;
+
+	return smt_gain;
+}
+
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_smt_power(sd, cpu);
+}
+
+unsigned long scale_rt_power(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	u64 total, available;
+
+	sched_avg_update(rq);
+
+	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	available = total - rq->rt_avg;
+
+	if (unlikely((s64)total < SCHED_LOAD_SCALE))
+		total = SCHED_LOAD_SCALE;
+
+	total >>= SCHED_LOAD_SHIFT;
+
+	return div_u64(available, total);
+}
+
+static void update_cpu_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long power = SCHED_LOAD_SCALE;
+	struct sched_group *sdg = sd->groups;
+
+	if (sched_feat(ARCH_POWER))
+		power *= arch_scale_freq_power(sd, cpu);
+	else
+		power *= default_scale_freq_power(sd, cpu);
+
+	power >>= SCHED_LOAD_SHIFT;
+
+	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+		if (sched_feat(ARCH_POWER))
+			power *= arch_scale_smt_power(sd, cpu);
+		else
+			power *= default_scale_smt_power(sd, cpu);
+
+		power >>= SCHED_LOAD_SHIFT;
+	}
+
+	power *= scale_rt_power(cpu);
+	power >>= SCHED_LOAD_SHIFT;
+
+	if (!power)
+		power = 1;
+
+	sdg->cpu_power = power;
+}
+
+static void update_group_power(struct sched_domain *sd, int cpu)
+{
+	struct sched_domain *child = sd->child;
+	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power;
+
+	if (!child) {
+		update_cpu_power(sd, cpu);
+		return;
+	}
+
+	power = 0;
+
+	group = child->groups;
+	do {
+		power += group->cpu_power;
+		group = group->next;
+	} while (group != child->groups);
+
+	sdg->cpu_power = power;
+}
+
+/**
+ * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: The sched_domain whose statistics are to be updated.
+ * @group: sched_group whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @load_idx: Load index of sched_domain of this_cpu for load calc.
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @local_group: Does group contain this_cpu.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sgs: variable to hold the statistics for this group.
+ */
+static inline void update_sg_lb_stats(struct sched_domain *sd,
+			struct sched_group *group, int this_cpu,
+			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			int local_group, const struct cpumask *cpus,
+			int *balance, struct sg_lb_stats *sgs)
+{
+	unsigned long load, max_cpu_load, min_cpu_load;
+	int i;
+	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned long sum_avg_load_per_task;
+	unsigned long avg_load_per_task;
+
+	if (local_group) {
+		balance_cpu = group_first_cpu(group);
+		if (balance_cpu == this_cpu)
+			update_group_power(sd, this_cpu);
+	}
+
+	/* Tally up the load of all CPUs in the group */
+	sum_avg_load_per_task = avg_load_per_task = 0;
+	max_cpu_load = 0;
+	min_cpu_load = ~0UL;
+
+	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+		struct rq *rq = cpu_rq(i);
+
+		if (*sd_idle && rq->nr_running)
+			*sd_idle = 0;
+
+		/* Bias balancing toward cpus of our domain */
+		if (local_group) {
+			if (idle_cpu(i) && !first_idle_cpu) {
+				first_idle_cpu = 1;
+				balance_cpu = i;
+			}
+
+			load = target_load(i, load_idx);
+		} else {
+			load = source_load(i, load_idx);
+			if (load > max_cpu_load)
+				max_cpu_load = load;
+			if (min_cpu_load > load)
+				min_cpu_load = load;
+		}
+
+		sgs->group_load += load;
+		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_weighted_load += weighted_cpuload(i);
+
+		sum_avg_load_per_task += cpu_avg_load_per_task(i);
+	}
+
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above
+	 * domains. In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (idle != CPU_NEWLY_IDLE && local_group &&
+	    balance_cpu != this_cpu && balance) {
+		*balance = 0;
+		return;
+	}
+
+	/* Adjust by relative CPU power of the group */
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
+
+
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of two tasks.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
+		group->cpu_power;
+
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+		sgs->group_imb = 1;
+
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
+}
+
+/**
+ * update_sd_lb_stats - Update sched_group's statistics for load balancing.
+ * @sd: sched_domain whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sds: variable to hold the statistics for this sched_domain.
+ */
+static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
+			enum cpu_idle_type idle, int *sd_idle,
+			const struct cpumask *cpus, int *balance,
+			struct sd_lb_stats *sds)
+{
+	struct sched_domain *child = sd->child;
+	struct sched_group *group = sd->groups;
+	struct sg_lb_stats sgs;
+	int load_idx, prefer_sibling = 0;
+
+	if (child && child->flags & SD_PREFER_SIBLING)
+		prefer_sibling = 1;
+
+	init_sd_power_savings_stats(sd, sds, idle);
+	load_idx = get_sd_load_idx(sd, idle);
+
+	do {
+		int local_group;
+
+		local_group = cpumask_test_cpu(this_cpu,
+					       sched_group_cpus(group));
+		memset(&sgs, 0, sizeof(sgs));
+		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
+				local_group, cpus, balance, &sgs);
+
+		if (local_group && balance && !(*balance))
+			return;
+
+		sds->total_load += sgs.group_load;
+		sds->total_pwr += group->cpu_power;
+
+		/*
+		 * In case the child domain prefers tasks go to siblings
+		 * first, lower the group capacity to one so that we'll try
+		 * and move all the excess tasks away.
+		 */
+		if (prefer_sibling)
+			sgs.group_capacity = min(sgs.group_capacity, 1UL);
+
+		if (local_group) {
+			sds->this_load = sgs.avg_load;
+			sds->this = group;
+			sds->this_nr_running = sgs.sum_nr_running;
+			sds->this_load_per_task = sgs.sum_weighted_load;
+		} else if (sgs.avg_load > sds->max_load &&
+			   (sgs.sum_nr_running > sgs.group_capacity ||
+				sgs.group_imb)) {
+			sds->max_load = sgs.avg_load;
+			sds->busiest = group;
+			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->group_imb = sgs.group_imb;
+		}
+
+		update_sd_power_savings_stats(group, sds, local_group, &sgs);
+		group = group->next;
+	} while (group != sd->groups);
+}
+
+/**
+ * fix_small_imbalance - Calculate the minor imbalance that exists
+ *			amongst the groups of a sched_domain, during
+ *			load balancing.
+ * @sds: Statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: The cpu at whose sched_domain we're performing load-balance.
+ * @imbalance: Variable to store the imbalance.
+ */
+static inline void fix_small_imbalance(struct sd_lb_stats *sds,
+				int this_cpu, unsigned long *imbalance)
+{
+	unsigned long tmp, pwr_now = 0, pwr_move = 0;
+	unsigned int imbn = 2;
+
+	if (sds->this_nr_running) {
+		sds->this_load_per_task /= sds->this_nr_running;
+		if (sds->busiest_load_per_task >
+				sds->this_load_per_task)
+			imbn = 1;
+	} else
+		sds->this_load_per_task =
+			cpu_avg_load_per_task(this_cpu);
+
+	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
+			sds->busiest_load_per_task * imbn) {
+		*imbalance = sds->busiest_load_per_task;
+		return;
+	}
+
+	/*
+	 * OK, we don't have enough imbalance to justify moving tasks,
+	 * however we may be able to increase total CPU power used by
+	 * moving them.
+	 */
+
+	pwr_now += sds->busiest->cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load);
+	pwr_now += sds->this->cpu_power *
+			min(sds->this_load_per_task, sds->this_load);
+	pwr_now /= SCHED_LOAD_SCALE;
+
+	/* Amount of load we'd subtract */
+	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+		sds->busiest->cpu_power;
+	if (sds->max_load > tmp)
+		pwr_move += sds->busiest->cpu_power *
+			min(sds->busiest_load_per_task, sds->max_load - tmp);
+
+	/* Amount of load we'd add */
+	if (sds->max_load * sds->busiest->cpu_power <
+		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
+		tmp = (sds->max_load * sds->busiest->cpu_power) /
+			sds->this->cpu_power;
+	else
+		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+			sds->this->cpu_power;
+	pwr_move += sds->this->cpu_power *
+			min(sds->this_load_per_task, sds->this_load + tmp);
+	pwr_move /= SCHED_LOAD_SCALE;
+
+	/* Move if we gain throughput */
+	if (pwr_move > pwr_now)
+		*imbalance = sds->busiest_load_per_task;
+}
+
+/**
+ * calculate_imbalance - Calculate the amount of imbalance present within the
+ *			 groups of a given sched_domain during load balance.
+ * @sds: statistics of the sched_domain whose imbalance is to be calculated.
+ * @this_cpu: Cpu for which currently load balance is being performed.
+ * @imbalance: The variable to store the imbalance.
+ */
+static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
+		unsigned long *imbalance)
+{
+	unsigned long max_pull;
+	/*
+	 * In the presence of smp nice balancing, certain scenarios can have
+	 * max load less than avg load(as we skip the groups at or below
+	 * its cpu_power, while calculating max_load..)
+	 */
+	if (sds->max_load < sds->avg_load) {
+		*imbalance = 0;
+		return fix_small_imbalance(sds, this_cpu, imbalance);
+	}
+
+	/* Don't want to pull so many tasks that a group would go idle */
+	max_pull = min(sds->max_load - sds->avg_load,
+			sds->max_load - sds->busiest_load_per_task);
+
+	/* How much load to actually move to equalise the imbalance */
+	*imbalance = min(max_pull * sds->busiest->cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
+			/ SCHED_LOAD_SCALE;
+
+	/*
+	 * if *imbalance is less than the average load per runnable task
+	 * there is no gaurantee that any tasks will be moved so we'll have
+	 * a think about bumping its value to force at least one task to be
+	 * moved
+	 */
+	if (*imbalance < sds->busiest_load_per_task)
+		return fix_small_imbalance(sds, this_cpu, imbalance);
+
+}
+/******* find_busiest_group() helpers end here *********************/
+
+/**
+ * find_busiest_group - Returns the busiest group within the sched_domain
+ * if there is an imbalance. If there isn't an imbalance, and
+ * the user has opted for power-savings, it returns a group whose
+ * CPUs can be put to idle by rebalancing those tasks elsewhere, if
+ * such a group exists.
+ *
+ * Also calculates the amount of weighted load which should be moved
+ * to restore balance.
+ *
+ * @sd: The sched_domain whose busiest group is to be returned.
+ * @this_cpu: The cpu for which load balancing is currently being performed.
+ * @imbalance: Variable which stores amount of weighted load which should
+ *		be moved to restore balance/put a group to idle.
+ * @idle: The idle status of this_cpu.
+ * @sd_idle: The idleness of sd
+ * @cpus: The set of CPUs under consideration for load-balancing.
+ * @balance: Pointer to a variable indicating if this_cpu
+ *	is the appropriate cpu to perform load balancing at this_level.
+ *
+ * Returns:	- the busiest group if imbalance exists.
+ *		- If no imbalance and user has opted for power-savings balance,
+ *		   return the least loaded group whose CPUs can be
+ *		   put to idle by rebalancing its tasks onto our group.
+ */
+static struct sched_group *
+find_busiest_group(struct sched_domain *sd, int this_cpu,
+		   unsigned long *imbalance, enum cpu_idle_type idle,
+		   int *sd_idle, const struct cpumask *cpus, int *balance)
+{
+	struct sd_lb_stats sds;
+
+	memset(&sds, 0, sizeof(sds));
+
+	/*
+	 * Compute the various statistics relavent for load balancing at
+	 * this level.
+	 */
+	update_sd_lb_stats(sd, this_cpu, idle, sd_idle, cpus,
+					balance, &sds);
+
+	/* Cases where imbalance does not exist from POV of this_cpu */
+	/* 1) this_cpu is not the appropriate cpu to perform load balancing
+	 *    at this level.
+	 * 2) There is no busy sibling group to pull from.
+	 * 3) This group is the busiest group.
+	 * 4) This group is more busy than the avg busieness at this
+	 *    sched_domain.
+	 * 5) The imbalance is within the specified limit.
+	 * 6) Any rebalance would lead to ping-pong
+	 */
+	if (balance && !(*balance))
+		goto ret;
+
+	if (!sds.busiest || sds.busiest_nr_running == 0)
+		goto out_balanced;
+
+	if (sds.this_load >= sds.max_load)
+		goto out_balanced;
+
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
+
+	if (sds.this_load >= sds.avg_load)
+		goto out_balanced;
+
+	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
+		goto out_balanced;
+
+	sds.busiest_load_per_task /= sds.busiest_nr_running;
+	if (sds.group_imb)
+		sds.busiest_load_per_task =
+			min(sds.busiest_load_per_task, sds.avg_load);
+
+	/*
+	 * We're trying to get all the cpus to the average_load, so we don't
+	 * want to push ourselves above the average load, nor do we wish to
+	 * reduce the max loaded cpu below the average load, as either of these
+	 * actions would just result in more rebalancing later, and ping-pong
+	 * tasks around. Thus we look for the minimum possible imbalance.
+	 * Negative imbalances (*we* are more loaded than anyone else) will
+	 * be counted as no imbalance for these purposes -- we can't fix that
+	 * by pulling tasks to us. Be careful of negative numbers as they'll
+	 * appear as very large values with unsigned longs.
+	 */
+	if (sds.max_load <= sds.busiest_load_per_task)
+		goto out_balanced;
+
+	/* Looks like there is an imbalance. Compute it */
+	calculate_imbalance(&sds, this_cpu, imbalance);
+	return sds.busiest;
+
+out_balanced:
+	/*
+	 * There is no obvious imbalance. But check if we can do some balancing
+	 * to save power.
+	 */
+	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
+		return sds.busiest;
+ret:
+	*imbalance = 0;
+	return NULL;
+}
+
+/*
+ * find_busiest_queue - find the busiest runqueue among the cpus in group.
+ */
+static struct rq *
+find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
+		   unsigned long imbalance, const struct cpumask *cpus)
+{
+	struct rq *busiest = NULL, *rq;
+	unsigned long max_load = 0;
+	int i;
+
+	for_each_cpu(i, sched_group_cpus(group)) {
+		unsigned long power = power_of(i);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
+		unsigned long wl;
+
+		if (!cpumask_test_cpu(i, cpus))
+			continue;
+
+		rq = cpu_rq(i);
+		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
+		wl /= power;
+
+		if (capacity && rq->nr_running == 1 && wl > imbalance)
+			continue;
+
+		if (wl > max_load) {
+			max_load = wl;
+			busiest = rq;
+		}
+	}
+
+	return busiest;
+}
+
+/*
+ * Max backoff if we encounter pinned tasks. Pretty arbitrary value, but
+ * so long as it is large enough.
+ */
+#define MAX_PINNED_INTERVAL	512
+
+/* Working cpumask for load_balance and load_balance_newidle. */
+static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
+
+/*
+ * Check this_cpu to ensure it is balanced within domain. Attempt to move
+ * tasks if there is an imbalance.
+ */
+static int load_balance(int this_cpu, struct rq *this_rq,
+			struct sched_domain *sd, enum cpu_idle_type idle,
+			int *balance)
+{
+	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
+	struct sched_group *group;
+	unsigned long imbalance;
+	struct rq *busiest;
+	unsigned long flags;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+
+	cpumask_copy(cpus, cpu_active_mask);
+
+	/*
+	 * When power savings policy is enabled for the parent domain, idle
+	 * sibling can pick up load irrespective of busy siblings. In this case,
+	 * let the state of idle sibling percolate up as CPU_IDLE, instead of
+	 * portraying it as CPU_NOT_IDLE.
+	 */
+	if (idle != CPU_NOT_IDLE && sd->flags & SD_SHARE_CPUPOWER &&
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+		sd_idle = 1;
+
+	schedstat_inc(sd, lb_count[idle]);
+
+redo:
+	update_shares(sd);
+	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
+				   cpus, balance);
+
+	if (*balance == 0)
+		goto out_balanced;
+
+	if (!group) {
+		schedstat_inc(sd, lb_nobusyg[idle]);
+		goto out_balanced;
+	}
+
+	busiest = find_busiest_queue(group, idle, imbalance, cpus);
+	if (!busiest) {
+		schedstat_inc(sd, lb_nobusyq[idle]);
+		goto out_balanced;
+	}
+
+	BUG_ON(busiest == this_rq);
+
+	schedstat_add(sd, lb_imbalance[idle], imbalance);
+
+	ld_moved = 0;
+	if (busiest->nr_running > 1) {
+		/*
+		 * Attempt to move tasks. If find_busiest_group has found
+		 * an imbalance but busiest->nr_running <= 1, the group is
+		 * still unbalanced. ld_moved simply stays zero, so it is
+		 * correctly treated as an imbalance.
+		 */
+		local_irq_save(flags);
+		double_rq_lock(this_rq, busiest);
+		ld_moved = move_tasks(this_rq, this_cpu, busiest,
+				      imbalance, sd, idle, &all_pinned);
+		double_rq_unlock(this_rq, busiest);
+		local_irq_restore(flags);
+
+		/*
+		 * some other cpu did the load balance for us.
+		 */
+		if (ld_moved && this_cpu != smp_processor_id())
+			resched_cpu(this_cpu);
+
+		/* All tasks on this runqueue were pinned by CPU affinity */
+		if (unlikely(all_pinned)) {
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
+				goto redo;
+			goto out_balanced;
+		}
+	}
+
+	if (!ld_moved) {
+		schedstat_inc(sd, lb_failed[idle]);
+		sd->nr_balance_failed++;
+
+		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
+
+			raw_spin_lock_irqsave(&busiest->lock, flags);
+
+			/* don't kick the migration_thread, if the curr
+			 * task on busiest cpu can't be moved to this_cpu
+			 */
+			if (!cpumask_test_cpu(this_cpu,
+					      &busiest->curr->cpus_allowed)) {
+				raw_spin_unlock_irqrestore(&busiest->lock,
+							    flags);
+				all_pinned = 1;
+				goto out_one_pinned;
+			}
+
+			if (!busiest->active_balance) {
+				busiest->active_balance = 1;
+				busiest->push_cpu = this_cpu;
+				active_balance = 1;
+			}
+			raw_spin_unlock_irqrestore(&busiest->lock, flags);
+			if (active_balance)
+				wake_up_process(busiest->migration_thread);
+
+			/*
+			 * We've kicked active balancing, reset the failure
+			 * counter.
+			 */
+			sd->nr_balance_failed = sd->cache_nice_tries+1;
+		}
+	} else
+		sd->nr_balance_failed = 0;
+
+	if (likely(!active_balance)) {
+		/* We were unbalanced, so reset the balancing interval */
+		sd->balance_interval = sd->min_interval;
+	} else {
+		/*
+		 * If we've begun active balancing, start to back off. This
+		 * case may not be covered by the all_pinned logic if there
+		 * is only 1 task on the busy runqueue (because we don't call
+		 * move_tasks).
+		 */
+		if (sd->balance_interval < sd->max_interval)
+			sd->balance_interval *= 2;
+	}
+
+	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+		ld_moved = -1;
+
+	goto out;
+
+out_balanced:
+	schedstat_inc(sd, lb_balanced[idle]);
+
+	sd->nr_balance_failed = 0;
+
+out_one_pinned:
+	/* tune up the balancing interval */
+	if ((all_pinned && sd->balance_interval < MAX_PINNED_INTERVAL) ||
+			(sd->balance_interval < sd->max_interval))
+		sd->balance_interval *= 2;
+
+	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+		ld_moved = -1;
+	else
+		ld_moved = 0;
+out:
+	if (ld_moved)
+		update_shares(sd);
+	return ld_moved;
+}
+
+/*
+ * Check this_cpu to ensure it is balanced within domain. Attempt to move
+ * tasks if there is an imbalance.
+ *
+ * Called from schedule when this_rq is about to become idle (CPU_NEWLY_IDLE).
+ * this_rq is locked.
+ */
+static int
+load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
+{
+	struct sched_group *group;
+	struct rq *busiest = NULL;
+	unsigned long imbalance;
+	int ld_moved = 0;
+	int sd_idle = 0;
+	int all_pinned = 0;
+	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
+
+	cpumask_copy(cpus, cpu_active_mask);
+
+	/*
+	 * When power savings policy is enabled for the parent domain, idle
+	 * sibling can pick up load irrespective of busy siblings. In this case,
+	 * let the state of idle sibling percolate up as IDLE, instead of
+	 * portraying it as CPU_NOT_IDLE.
+	 */
+	if (sd->flags & SD_SHARE_CPUPOWER &&
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+		sd_idle = 1;
+
+	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
+redo:
+	update_shares_locked(this_rq, sd);
+	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
+				   &sd_idle, cpus, NULL);
+	if (!group) {
+		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
+		goto out_balanced;
+	}
+
+	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance, cpus);
+	if (!busiest) {
+		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
+		goto out_balanced;
+	}
+
+	BUG_ON(busiest == this_rq);
+
+	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
+
+	ld_moved = 0;
+	if (busiest->nr_running > 1) {
+		/* Attempt to move tasks */
+		double_lock_balance(this_rq, busiest);
+		/* this_rq->clock is already updated */
+		update_rq_clock(busiest);
+		ld_moved = move_tasks(this_rq, this_cpu, busiest,
+					imbalance, sd, CPU_NEWLY_IDLE,
+					&all_pinned);
+		double_unlock_balance(this_rq, busiest);
+
+		if (unlikely(all_pinned)) {
+			cpumask_clear_cpu(cpu_of(busiest), cpus);
+			if (!cpumask_empty(cpus))
+				goto redo;
+		}
+	}
+
+	if (!ld_moved) {
+		int active_balance = 0;
+
+		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
+		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+			return -1;
+
+		if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+			return -1;
+
+		if (sd->nr_balance_failed++ < 2)
+			return -1;
+
+		/*
+		 * The only task running in a non-idle cpu can be moved to this
+		 * cpu in an attempt to completely freeup the other CPU
+		 * package. The same method used to move task in load_balance()
+		 * have been extended for load_balance_newidle() to speedup
+		 * consolidation at sched_mc=POWERSAVINGS_BALANCE_WAKEUP (2)
+		 *
+		 * The package power saving logic comes from
+		 * find_busiest_group().  If there are no imbalance, then
+		 * f_b_g() will return NULL.  However when sched_mc={1,2} then
+		 * f_b_g() will select a group from which a running task may be
+		 * pulled to this cpu in order to make the other package idle.
+		 * If there is no opportunity to make a package idle and if
+		 * there are no imbalance, then f_b_g() will return NULL and no
+		 * action will be taken in load_balance_newidle().
+		 *
+		 * Under normal task pull operation due to imbalance, there
+		 * will be more than one task in the source run queue and
+		 * move_tasks() will succeed.  ld_moved will be true and this
+		 * active balance code will not be triggered.
+		 */
+
+		/* Lock busiest in correct order while this_rq is held */
+		double_lock_balance(this_rq, busiest);
+
+		/*
+		 * don't kick the migration_thread, if the curr
+		 * task on busiest cpu can't be moved to this_cpu
+		 */
+		if (!cpumask_test_cpu(this_cpu, &busiest->curr->cpus_allowed)) {
+			double_unlock_balance(this_rq, busiest);
+			all_pinned = 1;
+			return ld_moved;
+		}
+
+		if (!busiest->active_balance) {
+			busiest->active_balance = 1;
+			busiest->push_cpu = this_cpu;
+			active_balance = 1;
+		}
+
+		double_unlock_balance(this_rq, busiest);
+		/*
+		 * Should not call ttwu while holding a rq->lock
+		 */
+		raw_spin_unlock(&this_rq->lock);
+		if (active_balance)
+			wake_up_process(busiest->migration_thread);
+		raw_spin_lock(&this_rq->lock);
+
+	} else
+		sd->nr_balance_failed = 0;
+
+	update_shares_locked(this_rq, sd);
+	return ld_moved;
+
+out_balanced:
+	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
+	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+		return -1;
+	sd->nr_balance_failed = 0;
+
+	return 0;
+}
+
+/*
+ * idle_balance is called by schedule() if this_cpu is about to become
+ * idle. Attempts to pull tasks from other CPUs.
+ */
+static void idle_balance(int this_cpu, struct rq *this_rq)
+{
+	struct sched_domain *sd;
+	int pulled_task = 0;
+	unsigned long next_balance = jiffies + HZ;
+
+	this_rq->idle_stamp = this_rq->clock;
+
+	if (this_rq->avg_idle < sysctl_sched_migration_cost)
+		return;
+
+	for_each_domain(this_cpu, sd) {
+		unsigned long interval;
+
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+
+		if (sd->flags & SD_BALANCE_NEWIDLE)
+			/* If we've pulled tasks over stop searching: */
+			pulled_task = load_balance_newidle(this_cpu, this_rq,
+							   sd);
+
+		interval = msecs_to_jiffies(sd->balance_interval);
+		if (time_after(next_balance, sd->last_balance + interval))
+			next_balance = sd->last_balance + interval;
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
+			break;
+		}
+	}
+	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
+		/*
+		 * We are going idle. next_balance may be set based on
+		 * a busy processor. So reset next_balance.
+		 */
+		this_rq->next_balance = next_balance;
+	}
+}
+
+/*
+ * active_load_balance is run by migration threads. It pushes running tasks
+ * off the busiest CPU onto idle CPUs. It requires at least 1 task to be
+ * running on each physical CPU where possible, and avoids physical /
+ * logical imbalances.
+ *
+ * Called with busiest_rq locked.
+ */
+static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
+{
+	int target_cpu = busiest_rq->push_cpu;
+	struct sched_domain *sd;
+	struct rq *target_rq;
+
+	/* Is there any task to move? */
+	if (busiest_rq->nr_running <= 1)
+		return;
+
+	target_rq = cpu_rq(target_cpu);
+
+	/*
+	 * This condition is "impossible", if it occurs
+	 * we need to fix it. Originally reported by
+	 * Bjorn Helgaas on a 128-cpu setup.
+	 */
+	BUG_ON(busiest_rq == target_rq);
+
+	/* move a task from busiest_rq to target_rq */
+	double_lock_balance(busiest_rq, target_rq);
+	update_rq_clock(busiest_rq);
+	update_rq_clock(target_rq);
+
+	/* Search for an sd spanning us and the target CPU. */
+	for_each_domain(target_cpu, sd) {
+		if ((sd->flags & SD_LOAD_BALANCE) &&
+		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
+				break;
+	}
+
+	if (likely(sd)) {
+		schedstat_inc(sd, alb_count);
+
+		if (move_one_task(target_rq, target_cpu, busiest_rq,
+				  sd, CPU_IDLE))
+			schedstat_inc(sd, alb_pushed);
+		else
+			schedstat_inc(sd, alb_failed);
+	}
+	double_unlock_balance(busiest_rq, target_rq);
+}
+
+#ifdef CONFIG_NO_HZ
+static struct {
+	atomic_t load_balancer;
+	cpumask_var_t cpu_mask;
+	cpumask_var_t ilb_grp_nohz_mask;
+} nohz ____cacheline_aligned = {
+	.load_balancer = ATOMIC_INIT(-1),
+};
+
+int get_nohz_load_balancer(void)
+{
+	return atomic_read(&nohz.load_balancer);
+}
+
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * lowest_flag_domain - Return lowest sched_domain containing flag.
+ * @cpu:	The cpu whose lowest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the lowest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the lowest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd)
+		if (sd && (sd->flags & flag))
+			break;
+
+	return sd;
+}
+
+/**
+ * for_each_flag_domain - Iterates over sched_domains containing the flag.
+ * @cpu:	The cpu whose domains we're iterating over.
+ * @sd:		variable holding the value of the power_savings_sd
+ *		for cpu.
+ * @flag:	The flag to filter the sched_domains to be iterated.
+ *
+ * Iterates over all the scheduler domains for a given cpu that has the 'flag'
+ * set, starting from the lowest sched_domain to the highest.
+ */
+#define for_each_flag_domain(cpu, sd, flag) \
+	for (sd = lowest_flag_domain(cpu, flag); \
+		(sd && (sd->flags & flag)); sd = sd->parent)
+
+/**
+ * is_semi_idle_group - Checks if the given sched_group is semi-idle.
+ * @ilb_group:	group to be checked for semi-idleness
+ *
+ * Returns:	1 if the group is semi-idle. 0 otherwise.
+ *
+ * We define a sched_group to be semi idle if it has atleast one idle-CPU
+ * and atleast one non-idle CPU. This helper function checks if the given
+ * sched_group is semi-idle or not.
+ */
+static inline int is_semi_idle_group(struct sched_group *ilb_group)
+{
+	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+					sched_group_cpus(ilb_group));
+
+	/*
+	 * A sched_group is semi-idle when it has atleast one busy cpu
+	 * and atleast one idle cpu.
+	 */
+	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+		return 0;
+
+	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+		return 0;
+
+	return 1;
+}
+/**
+ * find_new_ilb - Finds the optimum idle load balancer for nomination.
+ * @cpu:	The cpu which is nominating a new idle_load_balancer.
+ *
+ * Returns:	Returns the id of the idle load balancer if it exists,
+ *		Else, returns >= nr_cpu_ids.
+ *
+ * This algorithm picks the idle load balancer such that it belongs to a
+ * semi-idle powersavings sched_domain. The idea is to try and avoid
+ * completely idle packages/cores just for the purpose of idle load balancing
+ * when there are other idle cpu's which are better suited for that job.
+ */
+static int find_new_ilb(int cpu)
+{
+	struct sched_domain *sd;
+	struct sched_group *ilb_group;
+
+	/*
+	 * Have idle load balancer selection from semi-idle packages only
+	 * when power-aware load balancing is enabled
+	 */
+	if (!(sched_smt_power_savings || sched_mc_power_savings))
+		goto out_done;
+
+	/*
+	 * Optimize for the case when we have no idle CPUs or only one
+	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
+	 */
+	if (cpumask_weight(nohz.cpu_mask) < 2)
+		goto out_done;
+
+	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
+		ilb_group = sd->groups;
+
+		do {
+			if (is_semi_idle_group(ilb_group))
+				return cpumask_first(nohz.ilb_grp_nohz_mask);
+
+			ilb_group = ilb_group->next;
+
+		} while (ilb_group != sd->groups);
+	}
+
+out_done:
+	return cpumask_first(nohz.cpu_mask);
+}
+#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
+static inline int find_new_ilb(int call_cpu)
+{
+	return cpumask_first(nohz.cpu_mask);
+}
+#endif
+
+/*
+ * This routine will try to nominate the ilb (idle load balancing)
+ * owner among the cpus whose ticks are stopped. ilb owner will do the idle
+ * load balancing on behalf of all those cpus. If all the cpus in the system
+ * go into this tickless mode, then there will be no ilb owner (as there is
+ * no need for one) and all the cpus will sleep till the next wakeup event
+ * arrives...
+ *
+ * For the ilb owner, tick is not stopped. And this tick will be used
+ * for idle load balancing. ilb owner will still be part of
+ * nohz.cpu_mask..
+ *
+ * While stopping the tick, this cpu will become the ilb owner if there
+ * is no other owner. And will be the owner till that cpu becomes busy
+ * or if all cpus in the system stop their ticks at which point
+ * there is no need for ilb owner.
+ *
+ * When the ilb owner becomes busy, it nominates another owner, during the
+ * next busy scheduler_tick()
+ */
+int select_nohz_load_balancer(int stop_tick)
+{
+	int cpu = smp_processor_id();
+
+	if (stop_tick) {
+		cpu_rq(cpu)->in_nohz_recently = 1;
+
+		if (!cpu_active(cpu)) {
+			if (atomic_read(&nohz.load_balancer) != cpu)
+				return 0;
+
+			/*
+			 * If we are going offline and still the leader,
+			 * give up!
+			 */
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+
+			return 0;
+		}
+
+		cpumask_set_cpu(cpu, nohz.cpu_mask);
+
+		/* time for ilb owner also to sleep */
+		if (cpumask_weight(nohz.cpu_mask) == num_active_cpus()) {
+			if (atomic_read(&nohz.load_balancer) == cpu)
+				atomic_set(&nohz.load_balancer, -1);
+			return 0;
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
+				return 1;
+		} else if (atomic_read(&nohz.load_balancer) == cpu) {
+			int new_ilb;
+
+			if (!(sched_smt_power_savings ||
+						sched_mc_power_savings))
+				return 1;
+			/*
+			 * Check to see if there is a more power-efficient
+			 * ilb.
+			 */
+			new_ilb = find_new_ilb(cpu);
+			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
+				atomic_set(&nohz.load_balancer, -1);
+				resched_cpu(new_ilb);
+				return 0;
+			}
+			return 1;
+		}
+	} else {
+		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
+			return 0;
+
+		cpumask_clear_cpu(cpu, nohz.cpu_mask);
+
+		if (atomic_read(&nohz.load_balancer) == cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+	}
+	return 0;
+}
+#endif
+
+static DEFINE_SPINLOCK(balancing);
+
+/*
+ * It checks each scheduling domain to see if it is due to be balanced,
+ * and initiates a balancing operation if so.
+ *
+ * Balancing parameters are set up in arch_init_sched_domains.
+ */
+static void rebalance_domains(int cpu, enum cpu_idle_type idle)
+{
+	int balance = 1;
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long interval;
+	struct sched_domain *sd;
+	/* Earliest time when we have to do rebalance again */
+	unsigned long next_balance = jiffies + 60*HZ;
+	int update_next_balance = 0;
+	int need_serialize;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & SD_LOAD_BALANCE))
+			continue;
+
+		interval = sd->balance_interval;
+		if (idle != CPU_IDLE)
+			interval *= sd->busy_factor;
+
+		/* scale ms to jiffies */
+		interval = msecs_to_jiffies(interval);
+		if (unlikely(!interval))
+			interval = 1;
+		if (interval > HZ*NR_CPUS/10)
+			interval = HZ*NR_CPUS/10;
+
+		need_serialize = sd->flags & SD_SERIALIZE;
+
+		if (need_serialize) {
+			if (!spin_trylock(&balancing))
+				goto out;
+		}
+
+		if (time_after_eq(jiffies, sd->last_balance + interval)) {
+			if (load_balance(cpu, rq, sd, idle, &balance)) {
+				/*
+				 * We've pulled tasks over so either we're no
+				 * longer idle, or one of our SMT siblings is
+				 * not idle.
+				 */
+				idle = CPU_NOT_IDLE;
+			}
+			sd->last_balance = jiffies;
+		}
+		if (need_serialize)
+			spin_unlock(&balancing);
+out:
+		if (time_after(next_balance, sd->last_balance + interval)) {
+			next_balance = sd->last_balance + interval;
+			update_next_balance = 1;
+		}
+
+		/*
+		 * Stop the load balance at this level. There is another
+		 * CPU in our sched group which is doing load balancing more
+		 * actively.
+		 */
+		if (!balance)
+			break;
+	}
+
+	/*
+	 * next_balance will be updated only when there is a need.
+	 * When the cpu is attached to null domain for ex, it will not be
+	 * updated.
+	 */
+	if (likely(update_next_balance))
+		rq->next_balance = next_balance;
+}
+
+/*
+ * run_rebalance_domains is triggered when needed from the scheduler tick.
+ * In CONFIG_NO_HZ case, the idle load balance owner will do the
+ * rebalancing for all the cpus for whom scheduler ticks are stopped.
+ */
+static void run_rebalance_domains(struct softirq_action *h)
+{
+	int this_cpu = smp_processor_id();
+	struct rq *this_rq = cpu_rq(this_cpu);
+	enum cpu_idle_type idle = this_rq->idle_at_tick ?
+						CPU_IDLE : CPU_NOT_IDLE;
+
+	rebalance_domains(this_cpu, idle);
+
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If this cpu is the owner for idle load balancing, then do the
+	 * balancing on behalf of the other idle cpus whose ticks are
+	 * stopped.
+	 */
+	if (this_rq->idle_at_tick &&
+	    atomic_read(&nohz.load_balancer) == this_cpu) {
+		struct rq *rq;
+		int balance_cpu;
+
+		for_each_cpu(balance_cpu, nohz.cpu_mask) {
+			if (balance_cpu == this_cpu)
+				continue;
+
+			/*
+			 * If this cpu gets work to do, stop the load balancing
+			 * work being done for other cpus. Next load
+			 * balancing owner will pick it up.
+			 */
+			if (need_resched())
+				break;
+
+			rebalance_domains(balance_cpu, CPU_IDLE);
+
+			rq = cpu_rq(balance_cpu);
+			if (time_after(this_rq->next_balance, rq->next_balance))
+				this_rq->next_balance = rq->next_balance;
+		}
+	}
+#endif
+}
+
+static inline int on_null_domain(int cpu)
+{
+	return !rcu_dereference(cpu_rq(cpu)->sd);
+}
+
+/*
+ * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
+ *
+ * In case of CONFIG_NO_HZ, this is the place where we nominate a new
+ * idle load balancing owner or decide to stop the periodic load balancing,
+ * if the whole system is idle.
+ */
+static inline void trigger_load_balance(struct rq *rq, int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	/*
+	 * If we were in the nohz mode recently and busy at the current
+	 * scheduler tick, then check if we need to nominate new idle
+	 * load balancer.
+	 */
+	if (rq->in_nohz_recently && !rq->idle_at_tick) {
+		rq->in_nohz_recently = 0;
+
+		if (atomic_read(&nohz.load_balancer) == cpu) {
+			cpumask_clear_cpu(cpu, nohz.cpu_mask);
+			atomic_set(&nohz.load_balancer, -1);
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
+			int ilb = find_new_ilb(cpu);
+
+			if (ilb < nr_cpu_ids)
+				resched_cpu(ilb);
+		}
+	}
+
+	/*
+	 * If this cpu is idle and doing idle load balancing for all the
+	 * cpus with ticks stopped, is it time for that to stop?
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
+	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
+		resched_cpu(cpu);
+		return;
+	}
+
+	/*
+	 * If this cpu is idle and the idle load balancing is done by
+	 * someone else, then no need raise the SCHED_SOFTIRQ
+	 */
+	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
+	    cpumask_test_cpu(cpu, nohz.cpu_mask))
+		return;
+#endif
+	/* Don't need to rebalance while attached to NULL domain */
+	if (time_after_eq(jiffies, rq->next_balance) &&
+	    likely(!on_null_domain(cpu)))
+		raise_softirq(SCHED_SOFTIRQ);
+}
+
 static void rq_online_fair(struct rq *rq)
 {
 	update_sysctl();
@@ -1962,6 +3718,15 @@ static void rq_offline_fair(struct rq *rq)
 	update_sysctl();
 }
 
+#else	/* CONFIG_SMP */
+
+/*
+ * on UP we do not need to balance between CPUs:
+ */
+static inline void idle_balance(int cpu, struct rq *rq)
+{
+}
+
 #endif /* CONFIG_SMP */
 
 /*
