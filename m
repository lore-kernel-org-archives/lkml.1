Return-Path: <linux-kernel-owner+w=401wt.eu-S934679AbZKYNI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679AbZKYNI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934598AbZKYNI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:08:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:45124 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934597AbZKYNI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:08:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18t2T8X8JwtlfrY/+LspEtyO1R+u9UMEDaWei66c8
	pWIq+n1ypdJJLp
Subject: Re: [patch] sched: fix b5d9d734 blunder in task_new_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259142719.4027.228.camel@laptop>
References: <1258891664.14325.30.camel@marge.simson.net>
	 <1259070683.4531.1476.camel@laptop>
	 <1259082449.15249.90.camel@marge.simson.net>
	 <1259084140.4531.1710.camel@laptop>  <1259085280.4531.1730.camel@laptop>
	 <1259086901.15249.121.camel@marge.simson.net>
	 <1259087245.4531.1767.camel@laptop>
	 <1259132226.20897.22.camel@marge.simson.net>
	 <1259142719.4027.228.camel@laptop>
Content-Type: text/plain
Date: Wed, 25 Nov 2009 14:09:00 +0100
Message-Id: <1259154540.22627.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 10:51 +0100, Peter Zijlstra wrote:
> On Wed, 2009-11-25 at 07:57 +0100, Mike Galbraith wrote:
> 
> >         update_curr(cfs_rq);
> > +
> > +       if (is_same_group(se, pse)) {
> > +               se->vruntime = pse->vruntime;
> > +
> > +               /*
> > +                * If we're not sharing a runqueue, redo the child's vruntime
> > +                * offset after accounting for any yet to be booked vruntime.
> > +                */
> > +               if (this_cpu != task_cpu(p)) {
> > +                       struct cfs_rq *old_cfs_rq = cfs_rq_of(pse);
> > +                       u64 now = cpu_rq(this_cpu)->clock;
> > +                       unsigned long delta_exec = now - pse->exec_start;
> > +
> > +                       delta_exec = calc_delta_fair(delta_exec, se);
> > +                       se->vruntime += delta_exec;
> > +                       se->vruntime -= old_cfs_rq->min_vruntime -
> > +                                               cfs_rq->min_vruntime;
> > +               }
> > +       }
> > +
> >         place_entity(cfs_rq, se, 1); 
> 
> /me got his head in a twist..

The group stuff does that to me every time.

>  - is_same_group() assumes both things are on the same cpu and will
>    fail (for the group configs) when this is not so.

Gak.  (grr)  This is getting ridiculous :)  There is only one caller of
wake_up_new_task(), and that is the all fired be damned parent waking
it's child.  There is one caller of sched_class::task_new() as well, and
that is wake_up_new_task().  If I can't just copy the silly thing and be
done with it, there's something wrong.

(and if parent turns into grim reaper, heartless /me doesn't care)


sched: fix sched_fair.c::task_new_fair vruntime bug.

b5d9d734 fixed the problem of a forking task's child gaining vruntime..
IFF the child/parent shared a runqueue.  In the other case, it broke
fairness all to pieces by setting the child's vruntime to whatever task
happened to be current on the child's runqueue at wakeup time.  Fix this
by selecting a runqueue for the child at wakeup time, copying the parent's
vruntime, adding any unaccounted vruntime, and redoing cross cpu offset.

Also, since setting scheduling policy requires the tasklist lock, move
sched_fork() under the tasklist lock in copy_process();

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/fork.c       |    9 ++++++---
 kernel/sched.c      |   35 +++++++++++++++++++++++------------
 kernel/sched_fair.c |   29 +++++++++++++++++++++++------
 3 files changed, 52 insertions(+), 21 deletions(-)

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
@@ -2558,7 +2558,6 @@ static void __sched_fork(struct task_str
 void sched_fork(struct task_struct *p, int clone_flags)
 {
 	int cpu = get_cpu();
-	unsigned long flags;
 
 	__sched_fork(p);
 
@@ -2592,13 +2591,7 @@ void sched_fork(struct task_struct *p, i
 	if (!rt_prio(p->prio))
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
@@ -2625,14 +2618,31 @@ void sched_fork(struct task_struct *p, i
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
+#ifdef CONFIG_SMP
+	p->state = TASK_WAKING;
+	__task_rq_unlock(rq);
+	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_FORK, 0);
+	rq = cpu_rq(cpu);
+	if (rq != orig_rq) {
+		update_rq_clock(rq);
+		set_task_cpu(p, cpu);
+	}
+	rq = __task_rq_lock(p);
+	WARN_ON(p->state != TASK_WAKING);
+	p->state = TASK_RUNNING;
+#endif
+
+	if (!p->sched_class->task_new || !parent->se.on_rq) {
 		activate_task(rq, p, 0);
 	} else {
 		/*
@@ -2649,6 +2659,7 @@ void wake_up_new_task(struct task_struct
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
@@ -1230,6 +1227,12 @@ static struct task_struct *copy_process(
 	write_lock_irq(&tasklist_lock);
 
 	/*
+	 * Perform scheduler related setup.  Final CPU assignment will
+	 * be performed at wakeup time.
+	 */
+	sched_fork(p, clone_flags);
+
+	/*
 	 * The task hasn't been attached yet, so its cpus_allowed mask will
 	 * not be changed, nor will its assigned CPU.
 	 *


