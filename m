Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbXKQG1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbXKQG1H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758640AbXKQGYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:39 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45530 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbXKQGYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:35 -0500
Message-Id: <20071117062404.672976284@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 10/17] Remove some CFS specific code from the wakeup path of RT tasks
Content-Disposition: inline; filename=0002-remove-CFS-from-wakeup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

The current wake-up code path tries to determine if it can optimize the
wake-up to "this_cpu" by computing load calculations.  The problem is that
these calculations are only relevant to CFS tasks where load is king.  For RT
tasks, priority is king.  So the load calculation is completely wasted
bandwidth.

Therefore, we create a new sched_class interface to help with
pre-wakeup routing decisions and move the load calculation as a function
of CFS task's class.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 include/linux/sched.h   |    1 
 kernel/sched.c          |  144 +++---------------------------------------------
 kernel/sched_fair.c     |  132 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_idletask.c |    9 +++
 kernel/sched_rt.c       |    8 ++
 5 files changed, 159 insertions(+), 135 deletions(-)

Index: linux-compile.git/include/linux/sched.h
===================================================================
--- linux-compile.git.orig/include/linux/sched.h	2007-11-16 22:12:34.000000000 -0500
+++ linux-compile.git/include/linux/sched.h	2007-11-16 22:23:39.000000000 -0500
@@ -823,6 +823,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
+	int  (*select_task_rq)(struct task_struct *p, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 22:12:34.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 22:23:39.000000000 -0500
@@ -860,6 +860,10 @@ iter_move_one_task(struct rq *this_rq, i
 		   struct rq_iterator *iterator);
 #endif
 
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static unsigned long cpu_avg_load_per_task(int cpu);
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -1270,7 +1274,7 @@ static unsigned long target_load(int cpu
 /*
  * Return the average load per task on the cpu's run queue
  */
-static inline unsigned long cpu_avg_load_per_task(int cpu)
+static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1427,58 +1431,6 @@ static int sched_balance_self(int cpu, i
 
 #endif /* CONFIG_SMP */
 
-/*
- * wake_idle() will wake a task on an idle cpu if task->cpu is
- * not idle and an idle cpu is available.  The span of cpus to
- * search starts with cpus closest then further out as needed,
- * so we always favor a closer, idle cpu.
- *
- * Returns the CPU we should wake onto.
- */
-#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
-static int wake_idle(int cpu, struct task_struct *p)
-{
-	cpumask_t tmp;
-	struct sched_domain *sd;
-	int i;
-
-	/*
-	 * If it is idle, then it is the best cpu to run this task.
-	 *
-	 * This cpu is also the best, if it has more than one task already.
-	 * Siblings must be also busy(in most cases) as they didn't already
-	 * pickup the extra load from this cpu and hence we need not check
-	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
-	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
-		return cpu;
-
-	for_each_domain(cpu, sd) {
-		if (sd->flags & SD_WAKE_IDLE) {
-			cpus_and(tmp, sd->span, p->cpus_allowed);
-			for_each_cpu_mask(i, tmp) {
-				if (idle_cpu(i)) {
-					if (i != task_cpu(p)) {
-						schedstat_inc(p,
-							se.nr_wakeups_idle);
-					}
-					return i;
-				}
-			}
-		} else {
-			break;
-		}
-	}
-	return cpu;
-}
-#else
-static inline int wake_idle(int cpu, struct task_struct *p)
-{
-	return cpu;
-}
-#endif
-
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -1500,8 +1452,6 @@ static int try_to_wake_up(struct task_st
 	long old_state;
 	struct rq *rq;
 #ifdef CONFIG_SMP
-	struct sched_domain *sd, *this_sd = NULL;
-	unsigned long load, this_load;
 	int new_cpu;
 #endif
 
@@ -1521,90 +1471,14 @@ static int try_to_wake_up(struct task_st
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	new_cpu = cpu;
-
 	schedstat_inc(rq, ttwu_count);
-	if (cpu == this_cpu) {
+	if (cpu == this_cpu)
 		schedstat_inc(rq, ttwu_local);
-		goto out_set_cpu;
-	}
-
-	for_each_domain(this_cpu, sd) {
-		if (cpu_isset(cpu, sd->span)) {
-			schedstat_inc(sd, ttwu_wake_remote);
-			this_sd = sd;
-			break;
-		}
-	}
-
-	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
-		goto out_set_cpu;
-
-	/*
-	 * Check for affine wakeup and passive balancing possibilities.
-	 */
-	if (this_sd) {
-		int idx = this_sd->wake_idx;
-		unsigned int imbalance;
-
-		imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
-
-		load = source_load(cpu, idx);
-		this_load = target_load(this_cpu, idx);
-
-		new_cpu = this_cpu; /* Wake to this CPU if we can */
-
-		if (this_sd->flags & SD_WAKE_AFFINE) {
-			unsigned long tl = this_load;
-			unsigned long tl_per_task;
-
-			/*
-			 * Attract cache-cold tasks on sync wakeups:
-			 */
-			if (sync && !task_hot(p, rq->clock, this_sd))
-				goto out_set_cpu;
-
-			schedstat_inc(p, se.nr_wakeups_affine_attempts);
-			tl_per_task = cpu_avg_load_per_task(this_cpu);
-
-			/*
-			 * If sync wakeup then subtract the (maximum possible)
-			 * effect of the currently running task from the load
-			 * of the current CPU:
-			 */
-			if (sync)
-				tl -= current->se.load.weight;
-
-			if ((tl <= load &&
-				tl + target_load(cpu, idx) <= tl_per_task) ||
-			       100*(tl + p->se.load.weight) <= imbalance*load) {
-				/*
-				 * This domain has SD_WAKE_AFFINE and
-				 * p is cache cold in this domain, and
-				 * there is no bad imbalance.
-				 */
-				schedstat_inc(this_sd, ttwu_move_affine);
-				schedstat_inc(p, se.nr_wakeups_affine);
-				goto out_set_cpu;
-			}
-		}
+	else
+		schedstat_inc(rq->sd, ttwu_wake_remote);
 
-		/*
-		 * Start passive balancing when half the imbalance_pct
-		 * limit is reached.
-		 */
-		if (this_sd->flags & SD_WAKE_BALANCE) {
-			if (imbalance*this_load <= 100*load) {
-				schedstat_inc(this_sd, ttwu_move_balance);
-				schedstat_inc(p, se.nr_wakeups_passive);
-				goto out_set_cpu;
-			}
-		}
-	}
+	new_cpu = p->sched_class->select_task_rq(p, sync);
 
-	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
-out_set_cpu:
-	new_cpu = wake_idle(new_cpu, p);
 	if (new_cpu != cpu) {
 		set_task_cpu(p, new_cpu);
 		task_rq_unlock(rq, &flags);
Index: linux-compile.git/kernel/sched_fair.c
===================================================================
--- linux-compile.git.orig/kernel/sched_fair.c	2007-11-16 11:16:38.000000000 -0500
+++ linux-compile.git/kernel/sched_fair.c	2007-11-16 22:23:39.000000000 -0500
@@ -564,6 +564,137 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 }
 
 /*
+ * wake_idle() will wake a task on an idle cpu if task->cpu is
+ * not idle and an idle cpu is available.  The span of cpus to
+ * search starts with cpus closest then further out as needed,
+ * so we always favor a closer, idle cpu.
+ *
+ * Returns the CPU we should wake onto.
+ */
+#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
+static int wake_idle(int cpu, struct task_struct *p)
+{
+	cpumask_t tmp;
+	struct sched_domain *sd;
+	int i;
+
+	/*
+	 * If it is idle, then it is the best cpu to run this task.
+	 *
+	 * This cpu is also the best, if it has more than one task already.
+	 * Siblings must be also busy(in most cases) as they didn't already
+	 * pickup the extra load from this cpu and hence we need not check
+	 * sibling runqueue info. This will avoid the checks and cache miss
+	 * penalities associated with that.
+	 */
+	if (idle_cpu(cpu) || cpu_rq(cpu)->nr_running > 1)
+		return cpu;
+
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_IDLE) {
+			cpus_and(tmp, sd->span, p->cpus_allowed);
+			for_each_cpu_mask(i, tmp) {
+				if (idle_cpu(i))
+					return i;
+			}
+		} else {
+			break;
+		}
+	}
+	return cpu;
+}
+#else
+static inline int wake_idle(int cpu, struct task_struct *p)
+{
+	return cpu;
+}
+#endif
+
+#ifdef CONFIG_SMP
+static int select_task_rq_fair(struct task_struct *p, int sync)
+{
+	int cpu, this_cpu;
+	struct rq *rq;
+	struct sched_domain *sd, *this_sd = NULL;
+	int new_cpu;
+
+	cpu      = task_cpu(p);
+	rq       = task_rq(p);
+	this_cpu = smp_processor_id();
+	new_cpu  = cpu;
+
+	for_each_domain(this_cpu, sd) {
+		if (cpu_isset(cpu, sd->span)) {
+			this_sd = sd;
+			break;
+		}
+	}
+
+	if (unlikely(!cpu_isset(this_cpu, p->cpus_allowed)))
+		goto out_set_cpu;
+
+	/*
+	 * Check for affine wakeup and passive balancing possibilities.
+	 */
+	if (this_sd) {
+		int idx = this_sd->wake_idx;
+		unsigned int imbalance;
+		unsigned long load, this_load;
+
+		imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
+
+		load = source_load(cpu, idx);
+		this_load = target_load(this_cpu, idx);
+
+		new_cpu = this_cpu; /* Wake to this CPU if we can */
+
+		if (this_sd->flags & SD_WAKE_AFFINE) {
+			unsigned long tl = this_load;
+			unsigned long tl_per_task;
+
+			tl_per_task = cpu_avg_load_per_task(this_cpu);
+
+			/*
+			 * If sync wakeup then subtract the (maximum possible)
+			 * effect of the currently running task from the load
+			 * of the current CPU:
+			 */
+			if (sync)
+				tl -= current->se.load.weight;
+
+			if ((tl <= load &&
+				tl + target_load(cpu, idx) <= tl_per_task) ||
+			       100*(tl + p->se.load.weight) <= imbalance*load) {
+				/*
+				 * This domain has SD_WAKE_AFFINE and
+				 * p is cache cold in this domain, and
+				 * there is no bad imbalance.
+				 */
+				schedstat_inc(this_sd, ttwu_move_affine);
+				goto out_set_cpu;
+			}
+		}
+
+		/*
+		 * Start passive balancing when half the imbalance_pct
+		 * limit is reached.
+		 */
+		if (this_sd->flags & SD_WAKE_BALANCE) {
+			if (imbalance*this_load <= 100*load) {
+				schedstat_inc(this_sd, ttwu_move_balance);
+				goto out_set_cpu;
+			}
+		}
+	}
+
+	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
+out_set_cpu:
+	return wake_idle(new_cpu, p);
+}
+#endif /* CONFIG_SMP */
+
+
+/*
  * Preempt the current task with a newly woken task if needed:
  */
 static void
@@ -1111,6 +1242,7 @@ static const struct sched_class fair_sch
 #ifdef CONFIG_SMP
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+	.select_task_rq		= select_task_rq_fair,
 #endif
 
 	.set_curr_task          = set_curr_task_fair,
Index: linux-compile.git/kernel/sched_idletask.c
===================================================================
--- linux-compile.git.orig/kernel/sched_idletask.c	2007-11-16 11:15:54.000000000 -0500
+++ linux-compile.git/kernel/sched_idletask.c	2007-11-16 22:23:39.000000000 -0500
@@ -5,6 +5,12 @@
  *  handled in sched_fair.c)
  */
 
+#ifdef CONFIG_SMP
+static int select_task_rq_idle(struct task_struct *p, int sync)
+{
+	return task_cpu(p); /* IDLE tasks as never migrated */
+}
+#endif /* CONFIG_SMP */
 /*
  * Idle tasks are unconditionally rescheduled:
  */
@@ -72,6 +78,9 @@ const struct sched_class idle_sched_clas
 
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		= dequeue_task_idle,
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_idle,
+#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_idle,
 
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:23:35.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:23:39.000000000 -0500
@@ -41,6 +41,11 @@ static void update_rt_migration(struct r
 	else
 		rt_clear_overload(rq);
 }
+
+static int select_task_rq_rt(struct task_struct *p, int sync)
+{
+	return task_cpu(p);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -669,6 +674,9 @@ const struct sched_class rt_sched_class 
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_rt,
+#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 

-- 
