Return-Path: <linux-kernel-owner+w=401wt.eu-S1751274AbZG2EZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbZG2EZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 00:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbZG2EZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 00:25:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZG2EZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 00:25:28 -0400
Message-Id: <20090729042526.205923666@goodmis.org>
References: <20090729042121.727652581@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 29 Jul 2009 00:21:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] sched: check for pushing rt tasks after all scheduling
Content-Disposition: inline; filename=0001-sched-check-for-pushing-rt-tasks-after-all-schedulin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The current method for pushing RT tasks after scheduling only
happens after a context switch. But we found cases where a task
is set up on a run queue to be pushed but the push never happens
because the schedule chooses the same task.

This bug was found with the help of Gregory Haskins and the use of
ftrace (trace_printk). It tooks several days for both of us analyzing
the code and the trace output to find this.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..3134ea5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2791,14 +2791,14 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static int finish_task_switch(struct rq *rq, struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
-#ifdef CONFIG_SMP
 	int post_schedule = 0;
 
+#ifdef CONFIG_SMP
 	if (current->sched_class->needs_post_schedule)
 		post_schedule = current->sched_class->needs_post_schedule(rq);
 #endif
@@ -2820,10 +2820,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
-#ifdef CONFIG_SMP
-	if (post_schedule)
-		current->sched_class->post_schedule(rq);
-#endif
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -2836,6 +2832,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+
+	return post_schedule;
 }
 
 /**
@@ -2846,8 +2844,15 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct rq *rq = this_rq();
+	int post_schedule;
+
+	post_schedule = finish_task_switch(rq, prev);
+
+#ifdef CONFIG_SMP
+	if (post_schedule)
+		current->sched_class->post_schedule(rq);
+#endif
 
-	finish_task_switch(rq, prev);
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	/* In this case, finish_task_switch does not reenable preemption */
 	preempt_enable();
@@ -2860,7 +2865,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
  * context_switch - switch to the new MM and the new
  * thread's register state.
  */
-static inline void
+static inline int
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -2907,7 +2912,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * CPUs since it called schedule(), thus the 'rq' on its stack
 	 * frame will be invalid.
 	 */
-	finish_task_switch(this_rq(), prev);
+	return finish_task_switch(this_rq(), prev);
 }
 
 /*
@@ -5318,6 +5323,7 @@ asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
+	int post_schedule = 0;
 	struct rq *rq;
 	int cpu;
 
@@ -5368,15 +5374,25 @@ need_resched_nonpreemptible:
 		rq->curr = next;
 		++*switch_count;
 
-		context_switch(rq, prev, next); /* unlocks the rq */
+		post_schedule = context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * the context switch might have flipped the stack from under
 		 * us, hence refresh the local variables.
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
-	} else
+	} else {
+#ifdef CONFIG_SMP
+		if (current->sched_class->needs_post_schedule)
+			post_schedule = current->sched_class->needs_post_schedule(rq);
+#endif
 		spin_unlock_irq(&rq->lock);
+	}
+
+#ifdef CONFIG_SMP
+	if (post_schedule)
+		current->sched_class->post_schedule(rq);
+#endif
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
-- 
1.6.3.3

-- 
