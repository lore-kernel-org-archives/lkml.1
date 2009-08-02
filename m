Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZHBNNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZHBNNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZHBNNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:13:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:33819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZHBNNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:13:35 -0400
Date: Sun, 2 Aug 2009 13:12:47 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090729042526.205923666@goodmis.org>
References: <20090729042526.205923666@goodmis.org>
Subject: [tip:sched/core] sched: Check for pushing rt tasks after all scheduling
Message-ID: <tip-da19ab510343c6496fe8b8f890091296032025c9@git.kernel.org>
Git-Commit-ID: da19ab510343c6496fe8b8f890091296032025c9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da19ab510343c6496fe8b8f890091296032025c9
Gitweb:     http://git.kernel.org/tip/da19ab510343c6496fe8b8f890091296032025c9
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 29 Jul 2009 00:21:22 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:26:08 +0200

sched: Check for pushing rt tasks after all scheduling

The current method for pushing RT tasks after scheduling only
happens after a context switch. But we found cases where a task
is set up on a run queue to be pushed but the push never
happens because the schedule chooses the same task.

This bug was found with the help of Gregory Haskins and the use
of ftrace (trace_printk). It tooks several days for both of us
analyzing the code and the trace output to find this.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090729042526.205923666@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ca1f76b..a030d45 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2839,14 +2839,14 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
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
@@ -2868,10 +2868,6 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	perf_counter_task_sched_in(current, cpu_of(rq));
 	finish_lock_switch(rq, prev);
-#ifdef CONFIG_SMP
-	if (post_schedule)
-		current->sched_class->post_schedule(rq);
-#endif
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
@@ -2884,6 +2880,8 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+
+	return post_schedule;
 }
 
 /**
@@ -2894,8 +2892,15 @@ asmlinkage void schedule_tail(struct task_struct *prev)
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
@@ -2908,7 +2913,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
  * context_switch - switch to the new MM and the new
  * thread's register state.
  */
-static inline void
+static inline int
 context_switch(struct rq *rq, struct task_struct *prev,
 	       struct task_struct *next)
 {
@@ -2955,7 +2960,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 * CPUs since it called schedule(), thus the 'rq' on its stack
 	 * frame will be invalid.
 	 */
-	finish_task_switch(this_rq(), prev);
+	return finish_task_switch(this_rq(), prev);
 }
 
 /*
@@ -5366,6 +5371,7 @@ asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
+	int post_schedule = 0;
 	struct rq *rq;
 	int cpu;
 
@@ -5416,15 +5422,25 @@ need_resched_nonpreemptible:
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
