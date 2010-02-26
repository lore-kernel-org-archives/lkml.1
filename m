Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936190Ab0BZMXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:23:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:43328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899Ab0BZMO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:27 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 03/43] sched: refactor try_to_wake_up()
Date: Fri, 26 Feb 2010 21:22:40 +0900
Message-Id: <1267187000-18791-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up().
The factoring out doesn't affect try_to_wake_up() much
code-generation-wise.  Depending on configuration options, it ends up
generating the same object code as before or slightly different one
due to different register assignment.

This is to help future implementation of try_to_wake_up_local().

Mike Galbraith suggested rename to ttwu_post_activation() from
ttwu_woken_up() and comment update in try_to_wake_up().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |  114 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 64 insertions(+), 50 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 65dba66..4632b13 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2389,11 +2389,67 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 }
 #endif
 
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
+static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
+					int wake_flags, bool success)
+{
+	trace_sched_wakeup(rq, p, success);
+	check_preempt_curr(rq, p, wake_flags);
+
+	p->state = TASK_RUNNING;
+#ifdef CONFIG_SMP
+	if (p->sched_class->task_woken)
+		p->sched_class->task_woken(rq, p);
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
- * @p: the to-be-woken-up thread
+ * @p: the thread to be awakened
  * @state: the mask of task states that can be woken
- * @sync: do a synchronous wakeup?
+ * @wake_flags: wake modifier flags (WF_*)
  *
  * Put it on the run-queue if it's not already there. The "current"
  * thread is always on the run-queue (except when the actual
@@ -2401,7 +2457,8 @@ int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * returns failure only if the task is already active.
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
@@ -2473,54 +2530,11 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
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
-	if (p->sched_class->task_woken)
-		p->sched_class->task_woken(rq, p);
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
+	ttwu_post_activation(p, rq, wake_flags, success);
 out:
 	task_rq_unlock(rq, &flags);
 	put_cpu();
-- 
1.6.4.2

