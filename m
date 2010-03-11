Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab0CKJxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:53:30 -0500
Received: from mail.gmx.net ([213.165.64.20]:55305 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755512Ab0CKJx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:53:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19+0kxkg+F+1iIjs1iPbh/piCJwewDNwtzeguvq/C
	/eYUT0cAQSRg3+
Subject: Re: [patch 4/12] sched: cleanup/optimize clock updates
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1268300950.6785.27.camel@marge.simson.net>
References: <1268300950.6785.27.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 10:53:19 +0100
Message-Id: <1268301199.6785.32.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.41999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: cleanup and optimize clock updates

Now that we no longer depend on the clock being updated prior to enqueueing
on migratory wakeup, we can clean up a bit, placing calls to update_rq_clock()
exactly where they are needed, ie on enqueue, dequeue and schedule events.

In the case of a freshly enqueued task immediately preempting, we can skip the
update during preemption, as the clock was just updated by the enqueue event.
We also save an unneeded call during a migratory wakeup by not updating the
previous runqueue, where update_curr() won't be invoked.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c      |   32 ++++++++++++++++----------------
 kernel/sched_fair.c |    2 --
 2 files changed, 16 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -495,6 +495,8 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned char in_nohz_recently;
 #endif
+	unsigned int skip_clock_update;
+
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
 	unsigned long nr_load_updates;
@@ -592,6 +594,13 @@ static inline
 void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 {
 	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+
+	/*
+	 * A queue event has occurred, and we're going to schedule.  In
+	 * this case, we can save a useless back to back clock update.
+	 */
+	if (test_tsk_need_resched(p))
+		rq->skip_clock_update = 1;
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -626,7 +635,8 @@ static inline int cpu_of(struct rq *rq)
 
 inline void update_rq_clock(struct rq *rq)
 {
-	rq->clock = sched_clock_cpu(cpu_of(rq));
+	if (!rq->skip_clock_update)
+		rq->clock = sched_clock_cpu(cpu_of(rq));
 }
 
 /*
@@ -1782,8 +1792,6 @@ static void double_rq_lock(struct rq *rq
 			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
-	update_rq_clock(rq1);
-	update_rq_clock(rq2);
 }
 
 /*
@@ -1880,6 +1888,7 @@ static void update_avg(u64 *avg, u64 sam
 static void
 enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
+	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
@@ -1887,6 +1896,7 @@ enqueue_task(struct rq *rq, struct task_
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2366,7 +2376,6 @@ static int try_to_wake_up(struct task_st
 
 	smp_wmb();
 	rq = orig_rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
 
@@ -2407,7 +2416,6 @@ static int try_to_wake_up(struct task_st
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
-	update_rq_clock(rq);
 
 	/*
 	 * We migrated the task without holding either rq->lock, however
@@ -2653,7 +2661,6 @@ void wake_up_new_task(struct task_struct
 
 	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
-	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -3607,6 +3614,9 @@ static inline void schedule_debug(struct
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
+	if (prev->se.on_rq)
+		update_rq_clock(rq);
+	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3669,7 +3679,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -4226,7 +4235,6 @@ void rt_mutex_setprio(struct task_struct
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -4269,7 +4277,6 @@ void set_user_nice(struct task_struct *p
 	 * the task might be in the middle of scheduling on another CPU.
 	 */
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	/*
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
@@ -4552,7 +4559,6 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -5559,7 +5565,6 @@ void sched_idle_next(void)
 
 	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 
-	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -5614,7 +5619,6 @@ static void migrate_dead_tasks(unsigned
 	for ( ; ; ) {
 		if (!rq->nr_running)
 			break;
-		update_rq_clock(rq);
 		next = pick_next_task(rq);
 		if (!next)
 			break;
@@ -5898,7 +5902,6 @@ migration_call(struct notifier_block *nf
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
-		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
@@ -7848,7 +7851,6 @@ static void normalize_task(struct rq *rq
 {
 	int on_rq;
 
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -8210,8 +8212,6 @@ void sched_move_task(struct task_struct
 
 	rq = task_rq_lock(tsk, &flags);
 
-	update_rq_clock(rq);
-
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -3063,8 +3063,6 @@ static void active_load_balance(struct r
 
 	/* move a task from busiest_rq to target_rq */
 	double_lock_balance(busiest_rq, target_rq);
-	update_rq_clock(busiest_rq);
-	update_rq_clock(target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {


