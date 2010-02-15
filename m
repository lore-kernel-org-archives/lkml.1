Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0BONsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 08:48:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:43184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0BONsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 08:48:40 -0500
Subject: [PATCH] sched: Fix race between ttwu() and task_rq_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <alpine.LFD.2.00.1002142036260.2811@localhost.localdomain>
References: <alpine.LFD.2.00.1002142036260.2811@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 14:48:32 +0100
Message-ID: <1266241712.15770.420.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 20:45 +0100, Thomas Gleixner wrote:
> rt_mutex_setprio() can race with try_to_wake_up():
> 
> CPU 0                           CPU 1
> try_to_wake_up(p)
>   task_rq_lock(p)	
>   p->state = TASK_WAKING;
>   task_rq_unlock()              rt_mutex_setprio(p)
>                                 task_rq_lock(p)	<- succeeds (old CPU)
>   newcpu = select_task_rq(p)	
>   set_task_cpu(p)
> 
>   task_rq_lock(p) <- succeeds (new CPU)
> 
>   activate_task(p)              change sched_class(p)
> 
> That way we end up with the task enqueued in the wrong sched class.
> 
> Solve this by waiting for p->state != TASK_WAKING in rt_mutex_setprio().
> 
> Debugged and tested in the preempt-rt tree.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Yes, very good find.

How about the below fix?


---
Subject: sched: Fix race between ttwu() and task_rq_lock()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Feb 15 14:45:54 CET 2010

Thomas found that due to ttwu() changing a task's cpu without holding
the rq->lock, task_rq_lock() might end up locking the wrong rq.

Avoid this by serializing against TASK_WAKING.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   73 +++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 27 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -898,16 +898,33 @@ static inline void finish_lock_switch(st
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
+ * Check whether the task is waking, we use this to synchronize against
+ * ttwu() so that task_cpu() reports a stable number.
+ *
+ * We need to make an exception for PF_STARTING tasks because the fork
+ * path might require task_rq_lock() to work, eg. it can call
+ * set_cpus_allowed_ptr() from the cpuset clone_ns code.
+ */
+static inline int task_is_waking(struct task_struct *p)
+{
+	return unlikely((p->state == TASK_WAKING) && !(p->flags & PF_STARTING));
+}
+
+/*
  * __task_rq_lock - lock the runqueue a given task resides on.
  * Must be called interrupts disabled.
  */
 static inline struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
+	struct rq *rq;
+
 	for (;;) {
-		struct rq *rq = task_rq(p);
+		while (task_is_waking(p))
+			cpu_relax();
+		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -924,10 +941,12 @@ static struct rq *task_rq_lock(struct ta
 	struct rq *rq;
 
 	for (;;) {
+		while (task_is_waking(p))
+			cpu_relax();
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p)))
+		if (likely(rq == task_rq(p) && !task_is_waking(p)))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -2374,14 +2393,27 @@ static int try_to_wake_up(struct task_st
 	__task_rq_unlock(rq);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
+		/*
+		 * Since we migrate the task without holding any rq->lock,
+		 * we need to be careful with task_rq_lock(), since that
+		 * might end up locking an invalid rq.
+		 */
 		set_task_cpu(p, cpu);
+	}
 
-	rq = __task_rq_lock(p);
+	rq = cpu_rq(cpu);
+	raw_spin_lock(&rq->lock);
 	update_rq_clock(rq);
 
+	/*
+	 * We migrated the task without holding either rq->lock, however
+	 * since the task is not on the task list itself, nobody else
+	 * will try and migrate the task, hence the rq should match the
+	 * cpu we just moved it to.
+	 */
+	WARN_ON(task_cpu(p) != cpu);
 	WARN_ON(p->state != TASK_WAKING);
-	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
@@ -2613,7 +2645,7 @@ void wake_up_new_task(struct task_struct
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
+	int cpu = get_cpu();
 
 #ifdef CONFIG_SMP
 	/*
@@ -2629,7 +2661,13 @@ void wake_up_new_task(struct task_struct
 	set_task_cpu(p, cpu);
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	/*
+	 * Since the task is not on the rq and we still have TASK_WAKING set
+	 * nobody else will migrate this task.
+	 */
+	rq = cpu_rq(cpu);
+	raw_spin_lock_irqsave(&rq->lock, flags);
+
 	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
 	update_rq_clock(rq);
@@ -5308,27 +5346,8 @@ int set_cpus_allowed_ptr(struct task_str
 	struct rq *rq;
 	int ret = 0;
 
-	/*
-	 * Since we rely on wake-ups to migrate sleeping tasks, don't change
-	 * the ->cpus_allowed mask from under waking tasks, which would be
-	 * possible when we change rq->lock in ttwu(), so synchronize against
-	 * TASK_WAKING to avoid that.
-	 *
-	 * Make an exception for freshly cloned tasks, since cpuset namespaces
-	 * might move the task about, we have to validate the target in
-	 * wake_up_new_task() anyway since the cpu might have gone away.
-	 */
-again:
-	while (p->state == TASK_WAKING && !(p->flags & PF_STARTING))
-		cpu_relax();
-
 	rq = task_rq_lock(p, &flags);
 
-	if (p->state == TASK_WAKING && !(p->flags & PF_STARTING)) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
-
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;


