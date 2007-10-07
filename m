Return-Path: <linux-kernel-owner+w=401wt.eu-S1757202AbXJGVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbXJGVBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXJGVAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:00:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbXJGU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 16:59:57 -0400
From: Andi Kleen <ak@suse.de>
References: <200710071059.126674000@suse.de>
In-Reply-To: <200710071059.126674000@suse.de>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: [PATCH] [3/6] scheduler: Do devirtualization for sched_fair
Message-Id: <20071007205956.5C4E71474B@wotan.suse.de>
Date: Sun,  7 Oct 2007 22:59:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some CPUs like K8 cannot predict indirect calls. A common
optimization in object oriented languages is to check 
for the most common call target and then call it directly;
otherwise do an indirect call. This patch does this manually
for sched_fair calls in sched.c

In theory -- it doesn't seem to happen currently -- this 
would allow the compiler to even inline parts of sched_fair.c
into the callers.

I only did it only for fast paths (wake up and schedule) because the
generated code is little larger.  This enlarges sched.o again by about 
150 bytes.

Also I unlined check_preempt_curr()

I unfortunately wasn't able to measure a consistent difference in lmbench3 
lat_ctx -- the change seems to be below its (large) instability.

Still seems like a nice optimization and it's not too ugly.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -348,11 +348,6 @@ struct rq {
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 static DEFINE_MUTEX(sched_hotcpu_mutex);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
-{
-	rq->curr->sched_class->check_preempt_curr(rq, p);
-}
-
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -833,6 +828,18 @@ static int balance_tasks(struct rq *this
 #define sched_class_highest (&rt_sched_class)
 
 /*
+ * Simple devirtualization:
+ * Most tasks are fair tasks. Avoid the overhead of
+ * doing indirect calls for them by checking for the fair case and doing
+ * a direct call. Use only in real fast paths since it generates larger code.
+ */
+#define __CLASS_CALL(class, name, args) \
+	((class) == &fair_sched_class ? \
+		name ## _fair args : (class)->name args)
+#define CLASS_CALL(p, name, args) \
+	__CLASS_CALL((p)->sched_class, name, args)
+
+/*
  * Update delta_exec, delta_fair fields for rq.
  *
  * delta_fair clock advances at a rate inversely proportional to
@@ -893,7 +900,7 @@ static void set_load_weight(struct task_
 static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	sched_info_queued(p);
-	p->sched_class->enqueue_task(rq, p, wakeup);
+	CLASS_CALL(p, enqueue_task, (rq, p, wakeup));
 	p->se.on_rq = 1;
 }
 
@@ -1402,6 +1409,11 @@ static inline int wake_idle(int cpu, str
 }
 #endif
 
+static void check_preempt_curr(struct rq *rq, struct task_struct *p)
+{
+	CLASS_CALL(rq->curr, check_preempt_curr, (rq, p));
+}
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -1669,7 +1681,7 @@ void fastcall wake_up_new_task(struct ta
 		 * Let the scheduling class do new task startup
 		 * management (if any):
 		 */
-		p->sched_class->task_new(rq, p);
+		CLASS_CALL(p, task_new, (rq, p));
 		inc_nr_running(p, rq);
 	}
 	check_preempt_curr(rq, p);
@@ -3398,14 +3410,14 @@ pick_next_task(struct rq *rq, struct tas
 	 * the fair class we can call that function directly:
 	 */
 	if (likely(rq->nr_running == rq->cfs.nr_running)) {
-		p = fair_sched_class.pick_next_task(rq);
+		p = pick_next_task_fair(rq);
 		if (likely(p))
 			return p;
 	}
 
 	class = sched_class_highest;
 	for ( ; ; ) {
-		p = class->pick_next_task(rq);
+		p = __CLASS_CALL(class, pick_next_task, (rq));
 		if (p)
 			return p;
 		/*
@@ -3460,7 +3472,7 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
+	CLASS_CALL(prev, put_prev_task, (rq, prev));
 	next = pick_next_task(rq, prev);
 
 	sched_info_switch(prev, next);
@@ -4436,7 +4448,7 @@ asmlinkage long sys_sched_yield(void)
 	struct rq *rq = this_rq_lock();
 
 	schedstat_inc(rq, yld_count);
-	current->sched_class->yield_task(rq);
+	CLASS_CALL(current, yield_task, (rq));
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
Index: linux-2.6-sched-devel/kernel/sched_fair.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched_fair.c
+++ linux-2.6-sched-devel/kernel/sched_fair.c
@@ -814,7 +814,7 @@ static void yield_task_fair(struct rq *r
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_fair(struct rq *rq, struct task_struct *p)
 {
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
@@ -1050,6 +1050,9 @@ static void set_curr_task_fair(struct rq
 
 /*
  * All the scheduling class methods:
+ *
+ * sched.c knows about the naming conventions of this class.
+ * Always name all methods methodname_fair.
  */
 static const struct sched_class fair_sched_class = {
 	.next			= &idle_sched_class,
@@ -1057,7 +1060,7 @@ static const struct sched_class fair_sch
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
 
-	.check_preempt_curr	= check_preempt_wakeup,
+	.check_preempt_curr	= check_preempt_curr_fair,
 
 	.pick_next_task		= pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
