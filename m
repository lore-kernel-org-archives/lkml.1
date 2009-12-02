Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZLBD53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZLBD53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZLBD51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:57:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:56249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbZLBD5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:57:23 -0500
From: Tejun Heo <tj@kernel.org>
To: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, peterz@infradead.org,
       efault@gmx.de, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] sched: refactor try_to_wake_up()
Date: Wed,  2 Dec 2009 12:56:48 +0900
Message-Id: <1259726212-30259-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1259726212-30259-1-git-send-email-tj@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up().
The factoring out doesn't affect try_to_wake_up() much
code-generation-wise.  Depending on configuration options, it ends up
generating the same object code as before or slightly different one
due to different register assignment.

This is to help future implementation of try_to_wake_up_local().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  112 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 63 insertions(+), 49 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 204ca3e..dd8c91c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2361,11 +2361,67 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
-/***
+static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
+				 bool is_sync, bool is_migrate, bool is_local)
+{
+	schedstat_inc(p, se.nr_wakeups);
+	if (is_sync)
+		schedstat_inc(p, se.nr_wakeups_sync);
+	if (is_migrate)
+		schedstat_inc(p, se.nr_wakeups_migrate);
+	if (is_local)
+		schedstat_inc(p, se.nr_wakeups_local);
+	else
+		schedstat_inc(p, se.nr_wakeups_remote);
+
+	activate_task(rq, p, 1);
+
+	/*
+	 * Only attribute actual wakeups done by this task.
+	 */
+	if (!in_interrupt()) {
+		struct sched_entity *se = &current->se;
+		u64 sample = se->sum_exec_runtime;
+
+		if (se->last_wakeup)
+			sample -= se->last_wakeup;
+		else
+			sample -= se->start_runtime;
+		update_avg(&se->avg_wakeup, sample);
+
+		se->last_wakeup = se->sum_exec_runtime;
+	}
+}
+
+static inline void ttwu_woken_up(struct task_struct *p, struct rq *rq,
+				 int wake_flags, bool success)
+{
+	trace_sched_wakeup(rq, p, success);
+	check_preempt_curr(rq, p, wake_flags);
+
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_wake_up)
+		p->sched_class->task_wake_up(rq, p);
+
+	if (unlikely(rq->idle_stamp)) {
+		u64 delta = rq->clock - rq->idle_stamp;
+		u64 max = 2*sysctl_sched_migration_cost;
+
+		if (delta > max)
+			rq->avg_idle = max;
+		else
+			update_avg(&rq->avg_idle, delta);
+		rq->idle_stamp = 0;
+	}
+#endif
+}
+
+/**
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
  * @state: the mask of task states that can be woken
- * @sync: do a synchronous wakeup?
+ * @wake_flags: wake modifier flags (WF_*)
  *
  * Put it on the run-queue if it's not already there. The "current"
  * thread is always on the run-queue (except when the actual
@@ -2373,7 +2429,8 @@ void task_oncpu_function_call(struct task_struct *p,
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * returns failure only if the task is already active.
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
@@ -2444,54 +2501,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 out_activate:
 #endif /* CONFIG_SMP */
-	schedstat_inc(p, se.nr_wakeups);
-	if (wake_flags & WF_SYNC)
-		schedstat_inc(p, se.nr_wakeups_sync);
-	if (orig_cpu != cpu)
-		schedstat_inc(p, se.nr_wakeups_migrate);
-	if (cpu == this_cpu)
-		schedstat_inc(p, se.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.nr_wakeups_remote);
-	activate_task(rq, p, 1);
+	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
+		      cpu == this_cpu);
 	success = 1;
-
-	/*
-	 * Only attribute actual wakeups done by this task.
-	 */
-	if (!in_interrupt()) {
-		struct sched_entity *se = &current->se;
-		u64 sample = se->sum_exec_runtime;
-
-		if (se->last_wakeup)
-			sample -= se->last_wakeup;
-		else
-			sample -= se->start_runtime;
-		update_avg(&se->avg_wakeup, sample);
-
-		se->last_wakeup = se->sum_exec_runtime;
-	}
-
 out_running:
-	trace_sched_wakeup(rq, p, success);
-	check_preempt_curr(rq, p, wake_flags);
-
-	p->state = TASK_RUNNING;
-#ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
-
-	if (unlikely(rq->idle_stamp)) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
-
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
-	}
-#endif
+	ttwu_woken_up(p, rq, wake_flags, success);
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
-- 
1.6.4.2

