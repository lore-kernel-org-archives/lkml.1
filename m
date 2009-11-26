Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZKZKOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZKZKOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbZKZKOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:14:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:37716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZKZKOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:14:30 -0500
Message-ID: <4B0E54E6.2080108@kernel.org>
Date: Thu, 26 Nov 2009 19:13:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/4 tip/sched/core] sched: refactor try_to_wake_up() and implement
 try_to_wake_up_local()
References: <20091126190018.88a6dd77.sfr@canb.auug.org.au> <20091126081237.GA31034@elte.hu> <4B0E4741.10509@kernel.org> <20091126092631.GA17253@elte.hu> <4B0E4EFB.2070705@kernel.org> <20091126095154.GE32275@elte.hu>
In-Reply-To: <20091126095154.GE32275@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor ttwu_activate() and ttwu_woken_up() out of try_to_wake_up() and
use them to implement try_to_wake_up_local().  try_to_wake_up_local()
is similar to try_to_wake_up() but it assumes the caller has this_rq()
locked and the target task is bound to this_rq().
try_to_wake_up_local() can be called from wakeup and sleep scheduler
notifiers.

The factoring out doesn't affect try_to_wake_up() much
code-generation-wise.  Depending on configuration options, it ends up
generating the same object code as before or slightly different one
due to different register assignment.

The refactoring and local wake up function implementation using
refactored functions are based on Peter Zijlstra's suggestion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 include/linux/sched.h |    2 +
 kernel/sched.c        |  166 +++++++++++++++++++++++++++++++++++--------------
 2 files changed, 120 insertions(+), 48 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e03a754..c889a58 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2057,6 +2057,8 @@ extern void release_uids(struct user_namespace *ns);
 
 extern void do_timer(unsigned long ticks);
 
+extern bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
+				 int wake_flags);
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
 extern void wake_up_new_task(struct task_struct *tsk,
diff --git a/kernel/sched.c b/kernel/sched.c
index 475da1a..bad92c0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2333,11 +2333,73 @@ void task_oncpu_function_call(struct task_struct *p,
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
+	/*
+	 * Wake up is complete, fire wake up notifier.  This allows
+	 * try_to_wake_up_local() to be called from wake up notifiers.
+	 */
+	if (success)
+		fire_sched_notifier(p, wakeup);
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
@@ -2345,7 +2407,8 @@ void task_oncpu_function_call(struct task_struct *p,
  * the simpler "current->state = TASK_RUNNING" to mark yourself
  * runnable without the overhead of this.
  *
- * returns failure only if the task is already active.
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state,
 			  int wake_flags)
@@ -2416,59 +2479,61 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
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
+out_running:
+	ttwu_woken_up(p, rq, wake_flags, success);
+out:
+	task_rq_unlock(rq, &flags);
+	put_cpu();
 
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
+	return success;
+}
 
-		se->last_wakeup = se->sum_exec_runtime;
-	}
+/**
+ * try_to_wake_up_local - try to wake up a local task with rq lock held
+ * @p: the to-be-woken-up thread
+ * @state: the mask of task states that can be woken
+ * @wake_flags: wake modifier flags (WF_*)
+ *
+ * Put @p on the run-queue if it's not alredy there.  The caller must
+ * ensure that this_rq() is locked, @p is bound to this_rq() and @p is
+ * not the current task.  this_rq() stays locked over invocation.
+ *
+ * This function can be called from wakeup and sleep scheduler
+ * notifiers.  Be careful not to create deep recursion by chaining
+ * wakeup notifiers.
+ *
+ * Returns %true if @p was woken up, %false if it was already running
+ * or @state didn't match @p's state.
+ */
+bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
+			  int wake_flags)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
 
-out_running:
-	trace_sched_wakeup(rq, p, success);
-	check_preempt_curr(rq, p, wake_flags);
+	BUG_ON(rq != this_rq());
+	BUG_ON(p == current);
+	lockdep_assert_held(&rq->lock);
 
-	p->state = TASK_RUNNING;
-#ifdef CONFIG_SMP
-	if (p->sched_class->task_wake_up)
-		p->sched_class->task_wake_up(rq, p);
+	if (!sched_feat(SYNC_WAKEUPS))
+		wake_flags &= ~WF_SYNC;
 
-	if (unlikely(rq->idle_stamp)) {
-		u64 delta = rq->clock - rq->idle_stamp;
-		u64 max = 2*sysctl_sched_migration_cost;
+	if (!(p->state & state))
+		return false;
 
-		if (delta > max)
-			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
-		rq->idle_stamp = 0;
+	if (!p->se.on_rq) {
+		if (likely(!task_running(rq, p))) {
+			schedstat_inc(rq, ttwu_count);
+			schedstat_inc(rq, ttwu_local);
+		}
+		ttwu_activate(p, rq, wake_flags & WF_SYNC, false, true);
+		success = true;
 	}
-#endif
-	if (success)
-		fire_sched_notifier(p, wakeup);
-out:
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+
+	ttwu_woken_up(p, rq, wake_flags, success);
 
 	return success;
 }
@@ -5437,6 +5502,11 @@ need_resched_nonpreemptible:
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+			/*
+			 * Fire sleep notifier before changing any scheduler
+			 * state.  This allows try_to_wake_up_local() to be
+			 * called from sleep notifiers.
+			 */
 			fire_sched_notifier(prev, sleep);
 			deactivate_task(rq, prev, 1);
 		}
-- 
1.6.5.3

