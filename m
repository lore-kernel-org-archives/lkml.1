Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZLIJy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZLIJy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZLIJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:54:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:45111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbZLIJyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:54:50 -0500
Date: Wed, 9 Dec 2009 09:54:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Sanitize fork() handling
Message-ID: <tip-cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6@git.kernel.org>
Git-Commit-ID: cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6
Gitweb:     http://git.kernel.org/tip/cd29fe6f2637cc2ccbda5ac65f5332d6bf5fa3c6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 27 Nov 2009 17:32:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:03:05 +0100

sched: Sanitize fork() handling

Currently we try to do task placement in wake_up_new_task() after we do
the load-balance pass in sched_fork(). This yields complicated semantics
in that we have to deal with tasks on different RQs and the
set_task_cpu() calls in copy_process() and sched_fork()

Rename ->task_new() to ->task_fork() and call it from sched_fork()
before the balancing, this gives the policy a clear point to place the
task.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +-
 kernel/sched.c        |   47 ++++++++++++++++++-----------------------------
 kernel/sched_fair.c   |   28 +++++++++++++++-------------
 3 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ca72ed4..31d9dec 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1102,7 +1102,7 @@ struct sched_class {
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*task_fork) (struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched.c b/kernel/sched.c
index c92670f..33c9035 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1811,6 +1811,20 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 
 static void calc_load_account_active(struct rq *this_rq);
 
+static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
+{
+	set_task_rq(p, cpu);
+#ifdef CONFIG_SMP
+	/*
+	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
+	task_thread_info(p)->cpu = cpu;
+#endif
+}
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -1967,20 +1981,6 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
-static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
-{
-	set_task_rq(p, cpu);
-#ifdef CONFIG_SMP
-	/*
-	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
-	 * successfuly executed on another CPU. We must ensure that updates of
-	 * per-task data have been completed by this moment.
-	 */
-	smp_wmb();
-	task_thread_info(p)->cpu = cpu;
-#endif
-}
-
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio, int running)
@@ -2552,7 +2552,6 @@ static void __sched_fork(struct task_struct *p)
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
-	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2586,13 +2585,13 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	if (!rt_prio(p->prio))
 		p->sched_class = &fair_sched_class;
 
+	if (p->sched_class->task_fork)
+		p->sched_class->task_fork(p);
+
 #ifdef CONFIG_SMP
 	cpu = select_task_rq(p, SD_BALANCE_FORK, 0);
 #endif
-	local_irq_save(flags);
-	update_rq_clock(cpu_rq(cpu));
 	set_task_cpu(p, cpu);
-	local_irq_restore(flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2625,17 +2624,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
-
-	if (!p->sched_class->task_new || !current->se.on_rq) {
-		activate_task(rq, p, 0);
-	} else {
-		/*
-		 * Let the scheduling class do new task startup
-		 * management (if any):
-		 */
-		p->sched_class->task_new(rq, p);
-		inc_nr_running(rq);
-	}
+	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 613c1c7..44ec80c 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1922,28 +1922,30 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 }
 
 /*
- * Share the fairness runtime between parent and child, thus the
- * total amount of pressure for CPU stays equal - new tasks
- * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * called on fork with the child task as argument from the parent's context
+ *  - child not yet on the tasklist
+ *  - preemption disabled
  */
-static void task_new_fair(struct rq *rq, struct task_struct *p)
+static void task_fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct cfs_rq *cfs_rq = task_cfs_rq(current);
 	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
 	int this_cpu = smp_processor_id();
+	struct rq *rq = this_rq();
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
 
-	sched_info_queued(p);
+	if (unlikely(task_cpu(p) != this_cpu))
+		__set_task_cpu(p, this_cpu);
 
 	update_curr(cfs_rq);
+
 	if (curr)
 		se->vruntime = curr->vruntime;
 	place_entity(cfs_rq, se, 1);
 
-	/* 'curr' will be NULL if the child belongs to a different group */
-	if (sysctl_sched_child_runs_first && this_cpu == task_cpu(p) &&
-			curr && entity_before(curr, se)) {
+	if (sysctl_sched_child_runs_first && curr && entity_before(curr, se)) {
 		/*
 		 * Upon rescheduling, sched_class::put_prev_task() will place
 		 * 'current' within the tree based on its new key value.
@@ -1952,7 +1954,7 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 		resched_task(rq->curr);
 	}
 
-	enqueue_task_fair(rq, p, 0);
+	spin_unlock_irqrestore(&rq->lock, flags);
 }
 
 /*
@@ -2052,7 +2054,7 @@ static const struct sched_class fair_sched_class = {
 
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
-	.task_new		= task_new_fair,
+	.task_fork		= task_fork_fair,
 
 	.prio_changed		= prio_changed_fair,
 	.switched_to		= switched_to_fair,
