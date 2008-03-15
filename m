Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYCOBsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYCOBsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 21:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbYCOBrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 21:47:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45226 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbYCOBrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 21:47:52 -0400
Date: Sat, 15 Mar 2008 02:47:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler fixes
Message-ID: <20080315014741.GA18964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git for-linus

this fixes a number of bugs and regressions. Thanks,

	Ingo

------------------>
Hiroshi Shimamoto (1):
      sched: fix race in schedule()

Ingo Molnar (4):
      sched: fix update_load_add()/sub()
      sched: fix calc_delta_mine()
      sched: fix fair sleepers
      sched: simplify sched_slice()

Peter Zijlstra (2):
      sched: min_vruntime fix
      sched: fix overload performance: buddy wakeups

 kernel/sched.c      |   44 ++++++++++++--------------
 kernel/sched_fair.c |   86 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 80 insertions(+), 50 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1cb53fb..d1ad69b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -301,7 +301,7 @@ struct cfs_rq {
 	/* 'curr' points to currently running entity on this cfs_rq.
 	 * It is set to NULL otherwise (i.e when none are currently running).
 	 */
-	struct sched_entity *curr;
+	struct sched_entity *curr, *next;
 
 	unsigned long nr_spread_over;
 
@@ -1084,7 +1084,7 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 	u64 tmp;
 
 	if (unlikely(!lw->inv_weight))
-		lw->inv_weight = (WMULT_CONST - lw->weight/2) / lw->weight + 1;
+		lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
 
 	tmp = (u64)delta_exec * weight;
 	/*
@@ -1108,11 +1108,13 @@ calc_delta_fair(unsigned long delta_exec, struct load_weight *lw)
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
+	lw->inv_weight = 0;
 }
 
 static inline void update_load_sub(struct load_weight *lw, unsigned long dec)
 {
 	lw->weight -= dec;
+	lw->inv_weight = 0;
 }
 
 /*
@@ -4268,11 +4270,10 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	oldprio = p->prio;
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	if (rt_prio(prio))
 		p->sched_class = &rt_sched_class;
@@ -4281,10 +4282,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	p->prio = prio;
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
-
 		enqueue_task(rq, p, 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
@@ -4581,19 +4581,17 @@ recheck:
 	update_rq_clock(rq);
 	on_rq = p->se.on_rq;
 	running = task_current(rq, p);
-	if (on_rq) {
+	if (on_rq)
 		deactivate_task(rq, p, 0);
-		if (running)
-			p->sched_class->put_prev_task(rq, p);
-	}
+	if (running)
+		p->sched_class->put_prev_task(rq, p);
 
 	oldprio = p->prio;
 	__setscheduler(rq, p, policy, param->sched_priority);
 
+	if (running)
+		p->sched_class->set_curr_task(rq);
 	if (on_rq) {
-		if (running)
-			p->sched_class->set_curr_task(rq);
-
 		activate_task(rq, p, 0);
 
 		check_class_changed(rq, p, prev_class, oldprio, running);
@@ -7618,11 +7616,10 @@ void sched_move_task(struct task_struct *tsk)
 	running = task_current(rq, tsk);
 	on_rq = tsk->se.on_rq;
 
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, tsk, 0);
-		if (unlikely(running))
-			tsk->sched_class->put_prev_task(rq, tsk);
-	}
+	if (unlikely(running))
+		tsk->sched_class->put_prev_task(rq, tsk);
 
 	set_task_rq(tsk, task_cpu(tsk));
 
@@ -7631,11 +7628,10 @@ void sched_move_task(struct task_struct *tsk)
 		tsk->sched_class->moved_group(tsk);
 #endif
 
-	if (on_rq) {
-		if (unlikely(running))
-			tsk->sched_class->set_curr_task(rq);
+	if (unlikely(running))
+		tsk->sched_class->set_curr_task(rq);
+	if (on_rq)
 		enqueue_task(rq, tsk, 0);
-	}
 
 	task_rq_unlock(rq, &flags);
 }
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index e2a5305..f2cc590 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -175,8 +175,15 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * Maintain a cache of leftmost tree entries (it is frequently
 	 * used):
 	 */
-	if (leftmost)
+	if (leftmost) {
 		cfs_rq->rb_leftmost = &se->run_node;
+		/*
+		 * maintain cfs_rq->min_vruntime to be a monotonic increasing
+		 * value tracking the leftmost vruntime in the tree.
+		 */
+		cfs_rq->min_vruntime =
+			max_vruntime(cfs_rq->min_vruntime, se->vruntime);
+	}
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
@@ -184,8 +191,24 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (cfs_rq->rb_leftmost == &se->run_node)
-		cfs_rq->rb_leftmost = rb_next(&se->run_node);
+	if (cfs_rq->rb_leftmost == &se->run_node) {
+		struct rb_node *next_node;
+		struct sched_entity *next;
+
+		next_node = rb_next(&se->run_node);
+		cfs_rq->rb_leftmost = next_node;
+
+		if (next_node) {
+			next = rb_entry(next_node,
+					struct sched_entity, run_node);
+			cfs_rq->min_vruntime =
+				max_vruntime(cfs_rq->min_vruntime,
+					     next->vruntime);
+		}
+	}
+
+	if (cfs_rq->next == se)
+		cfs_rq->next = NULL;
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 }
@@ -260,12 +283,8 @@ static u64 __sched_period(unsigned long nr_running)
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running);
-
-	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
-
-	return slice;
+	return calc_delta_mine(__sched_period(cfs_rq->nr_running),
+			       se->load.weight, &cfs_rq->load);
 }
 
 /*
@@ -303,7 +322,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	      unsigned long delta_exec)
 {
 	unsigned long delta_exec_weighted;
-	u64 vruntime;
 
 	schedstat_set(curr->exec_max, max((u64)delta_exec, curr->exec_max));
 
@@ -315,19 +333,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 							&curr->load);
 	}
 	curr->vruntime += delta_exec_weighted;
-
-	/*
-	 * maintain cfs_rq->min_vruntime to be a monotonic increasing
-	 * value tracking the leftmost vruntime in the tree.
-	 */
-	if (first_fair(cfs_rq)) {
-		vruntime = min_vruntime(curr->vruntime,
-				__pick_next_entity(cfs_rq)->vruntime);
-	} else
-		vruntime = curr->vruntime;
-
-	cfs_rq->min_vruntime =
-		max_vruntime(cfs_rq->min_vruntime, vruntime);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -493,7 +498,11 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
 	u64 vruntime;
 
-	vruntime = cfs_rq->min_vruntime;
+	if (first_fair(cfs_rq)) {
+		vruntime = min_vruntime(cfs_rq->min_vruntime,
+				__pick_next_entity(cfs_rq)->vruntime);
+	} else
+		vruntime = cfs_rq->min_vruntime;
 
 	if (sched_feat(TREE_AVG)) {
 		struct sched_entity *last = __pick_last_entity(cfs_rq);
@@ -515,8 +524,10 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */
-		if (sched_feat(NEW_FAIR_SLEEPERS))
-			vruntime -= sysctl_sched_latency;
+		if (sched_feat(NEW_FAIR_SLEEPERS)) {
+			vruntime -= calc_delta_fair(sysctl_sched_latency,
+						    &cfs_rq->load);
+		}
 
 		/* ensure we never gain time by being placed backwards. */
 		vruntime = max_vruntime(se->vruntime, vruntime);
@@ -616,12 +627,32 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
+static struct sched_entity *
+pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	s64 diff, gran;
+
+	if (!cfs_rq->next)
+		return se;
+
+	diff = cfs_rq->next->vruntime - se->vruntime;
+	if (diff < 0)
+		return se;
+
+	gran = calc_delta_fair(sysctl_sched_wakeup_granularity, &cfs_rq->load);
+	if (diff > gran)
+		return se;
+
+	return cfs_rq->next;
+}
+
 static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *se = NULL;
 
 	if (first_fair(cfs_rq)) {
 		se = __pick_next_entity(cfs_rq);
+		se = pick_next(cfs_rq, se);
 		set_next_entity(cfs_rq, se);
 	}
 
@@ -1060,6 +1091,9 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 		resched_task(curr);
 		return;
 	}
+
+	cfs_rq_of(pse)->next = pse;
+
 	/*
 	 * Batch tasks do not preempt (their preemption is driven by
 	 * the tick):
