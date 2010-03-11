Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0CKScK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:32:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:40822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab0CKSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:31:51 -0500
Date: Thu, 11 Mar 2010 18:31:28 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268301199.6785.32.camel@marge.simson.net>
References: <1268301199.6785.32.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cleanup/optimize clock updates
Message-ID: <tip-a64692a3afd85fe048551ab89142fd5ca99a0dbd@git.kernel.org>
Git-Commit-ID: a64692a3afd85fe048551ab89142fd5ca99a0dbd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 18:31:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a64692a3afd85fe048551ab89142fd5ca99a0dbd
Gitweb:     http://git.kernel.org/tip/a64692a3afd85fe048551ab89142fd5ca99a0dbd
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 11 Mar 2010 17:16:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 18:32:50 +0100

sched: Cleanup/optimize clock updates

Now that we no longer depend on the clock being updated prior to enqueueing
on migratory wakeup, we can clean up a bit, placing calls to update_rq_clock()
exactly where they are needed, ie on enqueue, dequeue and schedule events.

In the case of a freshly enqueued task immediately preempting, we can skip the
update during preemption, as the clock was just updated by the enqueue event.
We also save an unneeded call during a migratory wakeup by not updating the
previous runqueue, where update_curr() won't be invoked.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1268301199.6785.32.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |   32 ++++++++++++++++----------------
 kernel/sched_fair.c |    2 --
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 68ed6f4..16559de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
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
@@ -1782,8 +1792,6 @@ static void double_rq_lock(struct rq *rq1, struct rq *rq2)
 			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
 		}
 	}
-	update_rq_clock(rq1);
-	update_rq_clock(rq2);
 }
 
 /*
@@ -1880,6 +1888,7 @@ static void update_avg(u64 *avg, u64 sample)
 static void
 enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 {
+	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, wakeup, head);
 	p->se.on_rq = 1;
@@ -1887,6 +1896,7 @@ enqueue_task(struct rq *rq, struct task_struct *p, int wakeup, bool head)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
@@ -2366,7 +2376,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 	smp_wmb();
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	if (!(p->state & state))
 		goto out;
 
@@ -2407,7 +2416,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
-	update_rq_clock(rq);
 
 	/*
 	 * We migrated the task without holding either rq->lock, however
@@ -2624,7 +2632,6 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 
 	BUG_ON(p->state != TASK_WAKING);
 	p->state = TASK_RUNNING;
-	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 	trace_sched_wakeup_new(rq, p, 1);
 	check_preempt_curr(rq, p, WF_FORK);
@@ -3578,6 +3585,9 @@ static inline void schedule_debug(struct task_struct *prev)
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
+	if (prev->se.on_rq)
+		update_rq_clock(rq);
+	rq->skip_clock_update = 0;
 	prev->sched_class->put_prev_task(rq, prev);
 }
 
@@ -3640,7 +3650,6 @@ need_resched_nonpreemptible:
 		hrtick_clear(rq);
 
 	raw_spin_lock_irq(&rq->lock);
-	update_rq_clock(rq);
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -4197,7 +4206,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 
 	oldprio = p->prio;
 	prev_class = p->sched_class;
@@ -4240,7 +4248,6 @@ void set_user_nice(struct task_struct *p, long nice)
 	 * the task might be in the middle of scheduling on another CPU.
 	 */
 	rq = task_rq_lock(p, &flags);
-	update_rq_clock(rq);
 	/*
 	 * The RT priorities are set via sched_setscheduler(), but we still
 	 * allow the 'normal' nice value to be set - but as expected
@@ -4523,7 +4530,6 @@ recheck:
 		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
@@ -5530,7 +5536,6 @@ void sched_idle_next(void)
 
 	__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
 
-	update_rq_clock(rq);
 	activate_task(rq, p, 0);
 
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
@@ -5585,7 +5590,6 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 	for ( ; ; ) {
 		if (!rq->nr_running)
 			break;
-		update_rq_clock(rq);
 		next = pick_next_task(rq);
 		if (!next)
 			break;
@@ -5869,7 +5873,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		rq->migration_thread = NULL;
 		/* Idle task back to normal (off runqueue, low prio) */
 		raw_spin_lock_irq(&rq->lock);
-		update_rq_clock(rq);
 		deactivate_task(rq, rq->idle, 0);
 		__setscheduler(rq, rq->idle, SCHED_NORMAL, 0);
 		rq->idle->sched_class = &idle_sched_class;
@@ -7815,7 +7818,6 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 {
 	int on_rq;
 
-	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -8177,8 +8179,6 @@ void sched_move_task(struct task_struct *tsk)
 
 	rq = task_rq_lock(tsk, &flags);
 
-	update_rq_clock(rq);
-
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c3b69d4..69e5820 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3064,8 +3064,6 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 
 	/* move a task from busiest_rq to target_rq */
 	double_lock_balance(busiest_rq, target_rq);
-	update_rq_clock(busiest_rq);
-	update_rq_clock(target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {
