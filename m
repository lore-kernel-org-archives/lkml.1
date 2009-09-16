Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbZIPKYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbZIPKYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbZIPKYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:24:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:46650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749AbZIPKYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:24:30 -0400
Date: Wed, 16 Sep 2009 10:24:02 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Rename sync arguments
Message-ID: <tip-7d47872146398dbede13223299fe1cb368ebc781@git.kernel.org>
Git-Commit-ID: 7d47872146398dbede13223299fe1cb368ebc781
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:24:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d47872146398dbede13223299fe1cb368ebc781
Gitweb:     http://git.kernel.org/tip/7d47872146398dbede13223299fe1cb368ebc781
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Sep 2009 19:55:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:30 +0200

sched: Rename sync arguments

In order to extend the functions to have more than 1 flag (sync),
rename the argument to flags, and explicitly define a WF_ space for
individual flags.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h   |    9 +++++++--
 include/linux/wait.h    |    4 ++--
 kernel/sched.c          |   30 ++++++++++++++++--------------
 kernel/sched_fair.c     |    6 ++++--
 kernel/sched_idletask.c |    4 ++--
 kernel/sched_rt.c       |    4 ++--
 6 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c116f0..3b07168 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1024,6 +1024,11 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
+/*
+ * wake flags
+ */
+#define WF_SYNC		0x01		/* waker goes to sleep after wakup */
+
 struct sched_class {
 	const struct sched_class *next;
 
@@ -1031,13 +1036,13 @@ struct sched_class {
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
 
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int flags);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int sync);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
diff --git a/include/linux/wait.h b/include/linux/wait.h
index cf3c2f5..a48e16b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -26,8 +26,8 @@
 #include <asm/current.h>
 
 typedef struct __wait_queue wait_queue_t;
-typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int sync, void *key);
-int default_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
+typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
+int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
 struct __wait_queue {
 	unsigned int flags;
diff --git a/kernel/sched.c b/kernel/sched.c
index e8e603b..4da335c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -636,9 +636,10 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
+static inline
+void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
-	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
+	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -2318,14 +2319,15 @@ void task_oncpu_function_call(struct task_struct *p,
  *
  * returns failure only if the task is already active.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
+static int try_to_wake_up(struct task_struct *p, unsigned int state,
+			  int wake_flags)
 {
 	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
 	struct rq *rq;
 
 	if (!sched_feat(SYNC_WAKEUPS))
-		sync = 0;
+		wake_flags &= ~WF_SYNC;
 
 	this_cpu = get_cpu();
 
@@ -2352,7 +2354,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	p->state = TASK_WAKING;
 	task_rq_unlock(rq, &flags);
 
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, sync);
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
 	if (cpu != orig_cpu)
 		set_task_cpu(p, cpu);
 
@@ -2378,7 +2380,7 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 out_activate:
 #endif /* CONFIG_SMP */
 	schedstat_inc(p, se.nr_wakeups);
-	if (sync)
+	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.nr_wakeups_sync);
 	if (orig_cpu != cpu)
 		schedstat_inc(p, se.nr_wakeups_migrate);
@@ -2407,7 +2409,7 @@ out_activate:
 
 out_running:
 	trace_sched_wakeup(rq, p, success);
-	check_preempt_curr(rq, p, sync);
+	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -5562,10 +5564,10 @@ asmlinkage void __sched preempt_schedule_irq(void)
 
 #endif /* CONFIG_PREEMPT */
 
-int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,
+int default_wake_function(wait_queue_t *curr, unsigned mode, int flags,
 			  void *key)
 {
-	return try_to_wake_up(curr->private, mode, sync);
+	return try_to_wake_up(curr->private, mode, flags);
 }
 EXPORT_SYMBOL(default_wake_function);
 
@@ -5579,14 +5581,14 @@ EXPORT_SYMBOL(default_wake_function);
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
 static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int sync, void *key)
+			int nr_exclusive, int flags, void *key)
 {
 	wait_queue_t *curr, *next;
 
 	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
 		unsigned flags = curr->flags;
 
-		if (curr->func(curr, mode, sync, key) &&
+		if (curr->func(curr, mode, flags, key) &&
 				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
 			break;
 	}
@@ -5647,16 +5649,16 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
 {
 	unsigned long flags;
-	int sync = 1;
+	int wake_flags = WF_SYNC;
 
 	if (unlikely(!q))
 		return;
 
 	if (unlikely(!nr_exclusive))
-		sync = 0;
+		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_common(q, mode, nr_exclusive, sync, key);
+	__wake_up_common(q, mode, nr_exclusive, wake_flags, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync_key);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index b554e63..007958e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,13 +1331,14 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  *
  * preempt must be disabled.
  */
-static int select_task_rq_fair(struct task_struct *p, int sd_flag, int sync)
+static int select_task_rq_fair(struct task_struct *p, int sd_flag, int flags)
 {
 	struct sched_domain *tmp, *sd = NULL;
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
+	int sync = flags & WF_SYNC;
 
 	if (sd_flag & SD_BALANCE_WAKE) {
 		if (sched_feat(AFFINE_WAKEUPS))
@@ -1548,11 +1549,12 @@ static void set_next_buddy(struct sched_entity *se)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct task_struct *curr = rq->curr;
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
+	int sync = flags & WF_SYNC;
 
 	update_curr(cfs_rq);
 
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 9ff7697..a8b448a 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -6,7 +6,7 @@
  */
 
 #ifdef CONFIG_SMP
-static int select_task_rq_idle(struct task_struct *p, int sd_flag, int sync)
+static int select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
@@ -14,7 +14,7 @@ static int select_task_rq_idle(struct task_struct *p, int sd_flag, int sync)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int flags)
 {
 	resched_task(rq->idle);
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97c53f3..13de712 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -938,7 +938,7 @@ static void yield_task_rt(struct rq *rq)
 #ifdef CONFIG_SMP
 static int find_lowest_rq(struct task_struct *task);
 
-static int select_task_rq_rt(struct task_struct *p, int sd_flag, int sync)
+static int select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
 	struct rq *rq = task_rq(p);
 
@@ -1002,7 +1002,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
