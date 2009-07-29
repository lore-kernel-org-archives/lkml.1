Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZG2PJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZG2PJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZG2PI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:08:59 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58586 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZG2PI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:08:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: enhance the pre/post scheduling logic
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org,
       akpm@linux-foundation.org, tglx@linutronix.de
Date: Wed, 29 Jul 2009 11:08:47 -0400
Message-ID: <20090729150422.17691.55590.stgit@dev.haskins.net>
In-Reply-To: <1248856884.6987.3043.camel@twins>
References: <1248856884.6987.3043.camel@twins>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Applies to Steve's linux-2.6-trace.git/update:c8cab1dd)

This patch applies on top of Steven's recent submission to address the
feedback from Peter, as well as fix a different race that was not
previously noticed.

It should be noted that all three of these patches should be considered
for any kernel that includes our push/pull scheduler design, which I believe
includes 24-rt and newer, as well as roughly 2.6.27 mainline.

Kind Regards,
-Greg

---------------------------

From: Gregory Haskins <ghaskins@novell.com>
sched: enhance the pre/post scheduling logic

We currently have an explicit "needs_post" vtable method which returns
a stack variable for whether we should later run post-schedule.  This
leads to an awkward exchange of the variable as it bubbles back up
out of the context switch.  Peter Zijlstra observed that this information
could be stored in the run-queue itself instead of handled on the stack.

Therefore, we revert to the method of having context_switch return void,
and update an internal rq->post_schedule variable when we require further
processing.

In addition, we fix a race condition where we try to access
current->sched_class without holding the rq->lock.  This is technically
racy, as the sched-class could change out from under us.  Instead,
we reference the per-rq post_schedule variable with the runqueue unlocked,
but with preemption disabled to see if we need to reacquire the rq->lock.

Finally, we clean the code up slightly by removing the #ifdef CONFIG_SMP
conditionals from the schedule() call, and implement some inline helper
functions instead.

This patch passes checkpatch, and rt-migrate

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    1 -
 kernel/sched.c        |   82 ++++++++++++++++++++++++++++++-------------------
 kernel/sched_rt.c     |   31 +++++++------------
 3 files changed, 61 insertions(+), 53 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3ab08e4..df14cae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1045,7 +1045,6 @@ struct sched_class {
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
-	int (*needs_post_schedule) (struct rq *this_rq);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 3134ea5..1a104e6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -616,6 +616,7 @@ struct rq {
 
 	unsigned char idle_at_tick;
 	/* For active balancing */
+	int post_schedule;
 	int active_balance;
 	int push_cpu;
 	/* cpu of this runqueue: */
@@ -2791,17 +2792,11 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static int finish_task_switch(struct rq *rq, struct task_struct *prev)
+static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
-	int post_schedule = 0;
-
-#ifdef CONFIG_SMP
-	if (current->sched_class->needs_post_schedule)
-		post_schedule = current->sched_class->needs_post_schedule(rq);
-#endif
 
 	rq->prev_mm = NULL;
 
@@ -2832,10 +2827,44 @@ static int finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+}
+
+#ifdef CONFIG_SMP
+
+/* assumes rq->lock is held */
+static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->sched_class->pre_schedule)
+		prev->sched_class->pre_schedule(rq, prev);
+}
+
+/* rq->lock is NOT held, but preemption is disabled */
+static inline void post_schedule(struct rq *rq)
+{
+	if (rq->post_schedule) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->curr->sched_class->post_schedule)
+			rq->curr->sched_class->post_schedule(rq);
+		spin_unlock_irqrestore(&rq->lock, flags);
+
+		rq->post_schedule = 0;
+	}
+}
+
+#else
 
-	return post_schedule;
+static inline void pre_schedule(struct rq *rq, struct task_struct *p)
+{
+}
+
+static inline void post_schedule(struct rq *rq)
+{
 }
 
+#endif
+
 /**
  * schedule_tail - first thing a freshly forked thread must call.
  * @prev: the thread we just switched away from.
@@ -2844,14 +2873,14 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct rq *rq = this_rq();
-	int post_schedule;
 
-	post_schedule = finish_task_switch(rq, prev);
+	finish_task_switch(rq, prev);
 
-#ifdef CONFIG_SMP
-	if (post_schedule)
-		current->sched_class->post_schedule(rq);
-#endif
+	/*
+	 * FIXME: do we need to worry about rq being invalidated by the
+	 * task_switch?
+	 */
+	post_schedule(rq);
 
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	/* In this case, finish_task_switch does not reenable preemption */
@@ -2865,7 +2894,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
  * context_switch - switch to the new MM and the new
  * thread's register state.
  */
-static inline int
+static inline void
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -2912,7 +2941,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * CPUs since it called schedule(), thus the 'rq' on its stack
 	 * frame will be invalid.
 	 */
-	return finish_task_switch(this_rq(), prev);
+	finish_task_switch(this_rq(), prev);
 }
 
 /*
@@ -5323,7 +5352,6 @@ asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
-	int post_schedule = 0;
 	struct rq *rq;
 	int cpu;
 
@@ -5355,10 +5383,7 @@ need_resched_nonpreemptible:
 		switch_count = &prev->nvcsw;
 	}
 
-#ifdef CONFIG_SMP
-	if (prev->sched_class->pre_schedule)
-		prev->sched_class->pre_schedule(rq, prev);
-#endif
+	pre_schedule(rq, prev);
 
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
@@ -5374,25 +5399,17 @@ need_resched_nonpreemptible:
 		rq->curr = next;
 		++*switch_count;
 
-		post_schedule = context_switch(rq, prev, next); /* unlocks the rq */
+		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * the context switch might have flipped the stack from under
 		 * us, hence refresh the local variables.
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
-	} else {
-#ifdef CONFIG_SMP
-		if (current->sched_class->needs_post_schedule)
-			post_schedule = current->sched_class->needs_post_schedule(rq);
-#endif
+	} else
 		spin_unlock_irq(&rq->lock);
-	}
 
-#ifdef CONFIG_SMP
-	if (post_schedule)
-		current->sched_class->post_schedule(rq);
-#endif
+	post_schedule(rq);
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
@@ -9350,6 +9367,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 		rq->sd = NULL;
 		rq->rd = NULL;
+		rq->post_schedule = 0;
 		rq->active_balance = 0;
 		rq->next_balance = jiffies;
 		rq->push_cpu = 0;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3918e01..a8f89bc 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1056,6 +1056,11 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	return p;
 }
 
+static inline int has_pushable_tasks(struct rq *rq)
+{
+	return !plist_head_empty(&rq->rt.pushable_tasks);
+}
+
 static struct task_struct *pick_next_task_rt(struct rq *rq)
 {
 	struct task_struct *p = _pick_next_task_rt(rq);
@@ -1064,6 +1069,12 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	if (p)
 		dequeue_pushable_task(rq, p);
 
+	/*
+	 * We detect this state here so that we can avoid taking the RQ
+	 * lock again later if there is no need to push
+	 */
+	rq->post_schedule = has_pushable_tasks(rq);
+
 	return p;
 }
 
@@ -1262,11 +1273,6 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 	return lowest_rq;
 }
 
-static inline int has_pushable_tasks(struct rq *rq)
-{
-	return !plist_head_empty(&rq->rt.pushable_tasks);
-}
-
 static struct task_struct *pick_next_pushable_task(struct rq *rq)
 {
 	struct task_struct *p;
@@ -1466,23 +1472,9 @@ static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 		pull_rt_task(rq);
 }
 
-/*
- * assumes rq->lock is held
- */
-static int needs_post_schedule_rt(struct rq *rq)
-{
-	return has_pushable_tasks(rq);
-}
-
 static void post_schedule_rt(struct rq *rq)
 {
-	/*
-	 * This is only called if needs_post_schedule_rt() indicates that
-	 * we need to push tasks away
-	 */
-	spin_lock_irq(&rq->lock);
 	push_rt_tasks(rq);
-	spin_unlock_irq(&rq->lock);
 }
 
 /*
@@ -1758,7 +1750,6 @@ static const struct sched_class rt_sched_class = {
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,
 	.pre_schedule		= pre_schedule_rt,
-	.needs_post_schedule	= needs_post_schedule_rt,
 	.post_schedule		= post_schedule_rt,
 	.task_wake_up		= task_wake_up_rt,
 	.switched_from		= switched_from_rt,

