Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbXKFAwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbXKFAwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbXKFAuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:39 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25187 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755525AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/8] RT: Remove some CFS specific code from the wakeup path of
	RT tasks
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:48:42 -0700
Message-ID: <20071105234842.25451.12740.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current wake-up code path tries to determine if it can optimize the
wake-up to "this_cpu" by computing load calculations.  The problem is that
these calculations are only relevant to CFS tasks where load is king.  For RT
tasks, priority is king.  So the load calculation is completely wasted
bandwidth.

Therefore, we create a new sched_class interface to help with
pre-wakeup routing decisions and move the load calculation as a function
of CFS task's class.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h   |    1 
 kernel/sched.c          |  135 ++++-------------------------------------------
 kernel/sched_fair.c     |  134 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_idletask.c |    9 +++
 kernel/sched_rt.c       |   10 +++
 5 files changed, 165 insertions(+), 124 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fe3fd1d..cfef8fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1033,6 +1033,7 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq, struct task_struct *p);
+	int  (*select_task_rq)(struct task_struct *p, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 49e68be..d16c686 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -859,6 +859,10 @@ static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      int *all_pinned, unsigned long *load_moved,
 		      int *this_best_prio, struct rq_iterator *iterator);
 
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static unsigned long cpu_avg_load_per_task(int cpu);
+
 #include "sched_stats.h"
 #include "sched_rt.c"
 #include "sched_fair.c"
@@ -1266,7 +1270,7 @@ void kick_process(struct task_struct *p)
  * We want to under-estimate the load of migration sources, to
  * balance conservatively.
  */
-static inline unsigned long source_load(int cpu, int type)
+static unsigned long source_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1281,7 +1285,7 @@ static inline unsigned long source_load(int cpu, int type)
  * Return a high guess at the load of a migration-target cpu weighted
  * according to the scheduling class and "nice" value.
  */
-static inline unsigned long target_load(int cpu, int type)
+static unsigned long target_load(int cpu, int type)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1295,7 +1299,7 @@ static inline unsigned long target_load(int cpu, int type)
 /*
  * Return the average load per task on the cpu's run queue
  */
-static inline unsigned long cpu_avg_load_per_task(int cpu)
+static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long total = weighted_cpuload(cpu);
@@ -1454,53 +1458,6 @@ static int sched_balance_self(int cpu, int flag)
 
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
-				if (idle_cpu(i))
-					return i;
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
@@ -1523,8 +1480,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int sync, int mutex)
 	long old_state;
 	struct rq *rq;
 #ifdef CONFIG_SMP
-	struct sched_domain *sd, *this_sd = NULL;
-	unsigned long load, this_load;
 	int new_cpu;
 #endif
 
@@ -1551,81 +1506,13 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int sync, int mutex)
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	new_cpu = cpu;
-
 	schedstat_inc(rq, ttwu_cnt);
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
-				goto out_set_cpu;
-			}
-		}
-
-		/*
-		 * Start passive balancing when half the imbalance_pct
-		 * limit is reached.
-		 */
-		if (this_sd->flags & SD_WAKE_BALANCE) {
-			if (imbalance*this_load <= 100*load) {
-				schedstat_inc(this_sd, ttwu_move_balance);
-				goto out_set_cpu;
-			}
-		}
-	}
+	else
+		schedstat_inc(rq->sd, ttwu_wake_remote);
 
-	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
-out_set_cpu:
-	new_cpu = wake_idle(new_cpu, p);
+	new_cpu = p->sched_class->select_task_rq(p, sync);
 	if (new_cpu != cpu) {
 		set_task_cpu(p, new_cpu);
 		task_rq_unlock(rq, &flags);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 67c67a8..4a5af80 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -974,6 +974,137 @@ static void yield_task_fair(struct rq *rq, struct task_struct *p)
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
 static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
@@ -1219,6 +1350,9 @@ struct sched_class fair_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_fair,
+#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_fair,
 
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 3503fb2..6fc6ead 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
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
@@ -58,6 +64,9 @@ static struct sched_class idle_sched_class __read_mostly = {
 
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		= dequeue_task_idle,
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_idle,
+#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_idle,
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0348423..f1fc1b4 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -202,6 +202,13 @@ yield_task_rt(struct rq *rq, struct task_struct *p)
 	requeue_task_rt(rq, p);
 }
 
+#ifdef CONFIG_SMP
+static int select_task_rq_rt(struct task_struct *p, int sync)
+{
+	return task_cpu(p);
+}
+#endif /* CONFIG_SMP */
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -718,6 +725,9 @@ static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
+#ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_rt,
+#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 

