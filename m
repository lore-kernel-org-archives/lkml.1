Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZKVMHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZKVMHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZKVMHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:07:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:56081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754646AbZKVMHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:07:46 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19GOWpZ7bZGvTd9+NJDaqP99DagomH2AA/x33zPaf
	GpsNudB6U471UK
Subject: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 13:07:44 +0100
Message-Id: <1258891664.14325.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: fix b5d9d734 blunder in task_new_fair()

b5d9d734 fixed the problem of a forking task's child gaining vruntime..
IFF the child/parent shared a runqueue.  In the other case, it broke
fairness all to pieces by setting the child's vruntime to whatever task
happened to be current on the child's runqueue at wakeup time.  Fix this
by adding a sched_class::task_new parameter to give the class a chance to
prepare the child for wakeup.

At child wakeup time, call task_new() with the parent's rq locked as the
comment in task new states, update the parent's stats (which must be done
with the rq locked), call task_new() to prepare the child, unlock parent rq,
select a runqueue a runqueue for the child, _then_ set_task_cpu() with the
child's vruntime set properly and both runqueue clocks updated to get the
current offset.  Lock child's rq and proceed with wakeup.

Also, since setting scheduling policy requires the tasklist lock, move
sched_fork() under the tasklist lock in copy_process();

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/sched.h |    2 +-
 kernel/fork.c         |    6 +++---
 kernel/sched.c        |   43 ++++++++++++++++++++++++++++---------------
 kernel/sched_fair.c   |   17 +++++++++++------
 4 files changed, 43 insertions(+), 25 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1925,20 +1925,23 @@ static void task_tick_fair(struct rq *rq
  * Share the fairness runtime between parent and child, thus the
  * total amount of pressure for CPU stays equal - new tasks
  * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * monopolize the CPU. Note: the parent runqueue is locked at
+ * prep time, the child is not running yet.  At wakeup time,
+ * the clild's runqueue is locked.
  */
-static void task_new_fair(struct rq *rq, struct task_struct *p)
+static void task_new_fair(struct rq *rq, struct task_struct *p, int prep)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
 	int this_cpu = smp_processor_id();
 
-	sched_info_queued(p);
-
 	update_curr(cfs_rq);
-	if (curr)
+
+	if (prep && curr) {
 		se->vruntime = curr->vruntime;
+		return;
+	}
+
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
@@ -1953,6 +1956,8 @@ static void task_new_fair(struct rq *rq,
 	}
 
 	enqueue_task_fair(rq, p, 0);
+
+	sched_info_queued(p);
 }
 
 /*
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1099,7 +1099,7 @@ struct sched_class {
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*task_new) (struct rq *rq, struct task_struct *p, int prep);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2558,7 +2558,6 @@ static void __sched_fork(struct task_str
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
-	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2566,7 +2565,7 @@ void sched_fork(struct task_struct *p, i
 	 * Revert to default priority/policy on fork if requested.
 	 */
 	if (unlikely(p->sched_reset_on_fork)) {
-		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
+		if (task_has_rt_policy(p)) {
 			p->policy = SCHED_NORMAL;
 			p->normal_prio = p->static_prio;
 		}
@@ -2589,16 +2588,10 @@ void sched_fork(struct task_struct *p, i
 	 */
 	p->prio = current->normal_prio;
 
-	if (!rt_prio(p->prio))
+	if (!task_has_rt_policy(p))
 		p->sched_class = &fair_sched_class;
 
-#ifdef CONFIG_SMP
-	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
-#endif
-	local_irq_save(flags);
-	update_rq_clock(cpu_rq(cpu));
-	set_task_cpu(p, cpu);
-	local_irq_restore(flags);
+	__set_task_cpu(p, cpu);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
@@ -2625,21 +2618,40 @@ void sched_fork(struct task_struct *p, i
  */
 void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
+	int cpu = get_cpu();
 	unsigned long flags;
-	struct rq *rq;
+	struct task_struct *parent = current;
+	struct rq *rq, *orig_rq;
 
-	rq = task_rq_lock(p, &flags);
+	smp_wmb();
+	rq = orig_rq = task_rq_lock(parent, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
-	update_rq_clock(rq);
+	update_rq_clock(orig_rq);
 
-	if (!p->sched_class->task_new || !current->se.on_rq) {
+	if (p->sched_class->task_new)
+		p->sched_class->task_new(orig_rq, p, 1);
+#ifdef CONFIG_SMP
+	p->state = TASK_WAKING;
+	__task_rq_unlock(orig_rq);
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+	rq = cpu_rq(cpu);
+	if (rq != orig_rq) {
+		update_rq_clock(rq);
+		set_task_cpu(p, cpu);
+	}
+	__task_rq_lock(p);
+	WARN_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
+#endif
+
+	if (!p->sched_class->task_new || !parent->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
 		/*
 		 * Let the scheduling class do new task startup
 		 * management (if any):
 		 */
-		p->sched_class->task_new(rq, p);
+		p->sched_class->task_new(rq, p, 0);
 		inc_nr_running(rq);
 	}
 	trace_sched_wakeup_new(rq, p, 1);
@@ -2649,6 +2661,7 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_wake_up(rq, p);
 #endif
 	task_rq_unlock(rq, &flags);
+	put_cpu();
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1125,9 +1125,6 @@ static struct task_struct *copy_process(
 
 	p->stack_start = stack_start;
 
-	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p, clone_flags);
-
 	retval = perf_event_init_task(p);
 	if (retval)
 		goto bad_fork_cleanup_policy;
@@ -1229,6 +1226,9 @@ static struct task_struct *copy_process(
 	/* Need tasklist lock for parent etc handling! */
 	write_lock_irq(&tasklist_lock);
 
+	/* Perform scheduler related setup. Assign this task to a CPU. */
+	sched_fork(p, clone_flags);
+
 	/*
 	 * The task hasn't been attached yet, so its cpus_allowed mask will
 	 * not be changed, nor will its assigned CPU.


