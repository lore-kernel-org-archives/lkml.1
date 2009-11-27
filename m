Return-Path: <linux-kernel-owner+w=401wt.eu-S1752957AbZK0Lze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbZK0Lze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 06:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZK0LzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 06:55:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:54506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751995AbZK0LzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 06:55:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19OKwECkXNOI5qI0L2pqBoIGh+4CmdbmLiArk4pa1
	b7as7B8uj7Brz8
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259252785.31676.216.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259252785.31676.216.camel@laptop>
Content-Type: text/plain
Date: Fri, 27 Nov 2009 12:55:21 +0100
Message-Id: <1259322921.3878.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 17:26 +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-22 at 13:07 +0100, Mike Galbraith wrote:
> > @@ -2589,16 +2588,10 @@ void sched_fork(struct task_struct *p, i
> >          */
> >         p->prio = current->normal_prio;
> >  
> > -       if (!rt_prio(p->prio))
> > +       if (!task_has_rt_policy(p))
> >                 p->sched_class = &fair_sched_class;
> >  
> > -#ifdef CONFIG_SMP
> > -       cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
> > -#endif
> > -       local_irq_save(flags);
> > -       update_rq_clock(cpu_rq(cpu));
> > -       set_task_cpu(p, cpu);
> > -       local_irq_restore(flags);
> > +       __set_task_cpu(p, cpu); 
> 
> OK, so I figured out why it was in sched_fork() and not in
> wake_up_new_task().
> 
> It is because in sched_fork() the new task isn't in the tasklist yet and
> can therefore not race with any other migration logic.

With no regard to other issues, real or imagined, I can squash my bug in
three ways.

1. double lock runqueues and update both in the migration case, copy
parent and adjust child.  Maximally correct, though it's use of
double_lock_balance() looks a little odd. (below)

2. only lock the child, copy the parent, and manually add any unbooked
vruntime before adjusting the child.  Not 100% correct, but doesn't add
a double lock, and should also ensure no vruntime gain over the fork.
The child gets a fresh copy, not some dusty old thing that was copied
who knows when, and been who knows where (below 1)

3. ??

sched: fix sched_fair.c::task_new_fair vruntime bug.

b5d9d734 fixed the problem of a forking task's child gaining vruntime..
IFF the child/parent shared a runqueue.  In the other case, it broke
fairness all to pieces by setting the child's vruntime to whatever task
happened to be current on the child's runqueue at wakeup time.  Fix this
by copying the parent's vruntime after adding any unaccounted vruntime,
and adjust for cross cpu offset in the migration case.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c      |    8 +++++++-
 kernel/sched_fair.c |   25 +++++++++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1925,20 +1925,31 @@ static void task_tick_fair(struct rq *rq
  * Share the fairness runtime between parent and child, thus the
  * total amount of pressure for CPU stays equal - new tasks
  * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * monopolize the CPU. Note: both child and parent's runqueues are
+ * locked in the migration case, the child is not yet running.
  */
 static void task_new_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct sched_entity *pse = &current->se;
+	struct cfs_rq *old_cfs_rq = cfs_rq_of(pse);
 	int this_cpu = smp_processor_id();
 
-	sched_info_queued(p);
-
 	update_curr(cfs_rq);
-	if (curr)
-		se->vruntime = curr->vruntime;
+
+	/*
+	 * If we're not sharing a runqueue, copy the parent's vruntime
+	 * after accounting for any yet to be booked vruntime.
+	 */
+	if (cfs_rq != old_cfs_rq)
+		update_curr(old_cfs_rq);
+
+	se->vruntime = pse->vruntime;
+
+	if (cfs_rq != old_cfs_rq)
+		se->vruntime -= old_cfs_rq->min_vruntime - cfs_rq->min_vruntime;
+
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
@@ -1953,6 +1964,8 @@ static void task_new_fair(struct rq *rq,
 	}
 
 	enqueue_task_fair(rq, p, 0);
+
+	sched_info_queued(p);
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2626,11 +2626,15 @@ void sched_fork(struct task_struct *p, i
 void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 {
 	unsigned long flags;
-	struct rq *rq;
+	struct rq *rq, *this_rq = this_rq();;
 
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
+	if (rq != this_rq) {
+		double_lock_balance(rq, this_rq);
+		update_rq_clock(this_rq);
+	}
 
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);
@@ -2648,6 +2652,8 @@ void wake_up_new_task(struct task_struct
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
 #endif
+	if (rq != this_rq)
+		double_unlock_balance(rq, this_rq);
 	task_rq_unlock(rq, &flags);
 }
 

sched: fix sched_fair.c::task_new_fair vruntime bug.

b5d9d734 fixed the problem of a forking task's child gaining vruntime..
IFF the child/parent shared a runqueue.  In the other case, it broke
fairness all to pieces by setting the child's vruntime to whatever task
happened to be current on the child's runqueue at wakeup time.  Fix this
by copying the parent's vruntime, adding any unaccounted vruntime, and
redoing cross cpu offset.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c      |    2 ++
 kernel/sched_fair.c |   29 +++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1925,20 +1925,35 @@ static void task_tick_fair(struct rq *rq
  * Share the fairness runtime between parent and child, thus the
  * total amount of pressure for CPU stays equal - new tasks
  * get a chance to run but frequent forkers are not allowed to
- * monopolize the CPU. Note: the parent runqueue is locked,
- * the child is not running yet.
+ * monopolize the CPU. Note: the child's runqueue is locked, the
+ * child is not yet running, and the parent is not preemptible.
  */
 static void task_new_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct sched_entity *pse = &current->se;
 	int this_cpu = smp_processor_id();
 
-	sched_info_queued(p);
-
 	update_curr(cfs_rq);
-	if (curr)
-		se->vruntime = curr->vruntime;
+
+	se->vruntime = pse->vruntime;
+
+	/*
+	 * If we're not sharing a runqueue, redo the child's vruntime
+	 * offset after accounting for any yet to be booked vruntime.
+	 */
+	if (this_cpu != task_cpu(p)) {
+		struct cfs_rq *old_cfs_rq = cfs_rq_of(pse);
+		u64 now = cpu_rq(this_cpu)->clock;
+		unsigned long delta_exec = now - pse->exec_start;
+
+		delta_exec = calc_delta_fair(delta_exec, se);
+		se->vruntime += delta_exec;
+		se->vruntime -= old_cfs_rq->min_vruntime -
+					cfs_rq->min_vruntime;
+	}
+
 	place_entity(cfs_rq, se, 1);
 
 	/* 'curr' will be NULL if the child belongs to a different group */
@@ -1953,6 +1968,8 @@ static void task_new_fair(struct rq *rq,
 	}
 
 	enqueue_task_fair(rq, p, 0);
+
+	sched_info_queued(p);
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2631,6 +2631,8 @@ void wake_up_new_task(struct task_struct
 	rq = task_rq_lock(p, &flags);
 	BUG_ON(p->state != TASK_RUNNING);
 	update_rq_clock(rq);
+	if (rq != this_rq())
+		update_rq_clock(this_rq());
 
 	if (!p->sched_class->task_new || !current->se.on_rq) {
 		activate_task(rq, p, 0);



