Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYJXJ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYJXJ7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYJXJ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:58:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:36224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYJXJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:58:44 -0400
Message-Id: <20081024091109.912152294@chello.nl>
References: <20081024090611.936552213@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 24 Oct 2008 11:06:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 7/8] sched: non-zero lag renice
Content-Disposition: inline; filename=sched-non-zero-lag-renice.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then renicing, esp when lowering nice value (getting heavier), its possible
to get into a starvation scenario. If you got too much runtime as a very
light task, you get shot way far too the right, which means you'll have to
wait for a long time in order to run again.

If during that wait you get reniced down, fairness would suggest you get run
earlier, because you deserve more time.

This can be solved by scaling the vruntime so that we keep the real-time
lag invariant.

So under transformation(w->w') keep dt == dt':

   dv = dt/w -> w dv = dt
   w dv = w' dv' -> dv' = w/w' dv

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |   14 +++++++-------
 kernel/sched_fair.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4984,12 +4984,9 @@ void set_user_nice(struct task_struct *p
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		/*
-		 * If the task increased its priority or is running and
-		 * lowered its priority, then reschedule its CPU:
-		 */
-		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+
+		check_class_changed(rq, p, p->sched_class, old_prio,
+				    task_running(rq, p));
 	}
 out_unlock:
 	task_rq_unlock(rq, &flags);
@@ -8744,6 +8741,7 @@ void sched_move_task(struct task_struct 
 static void __set_se_shares(struct sched_entity *se, unsigned long shares)
 {
 	struct cfs_rq *cfs_rq = se->cfs_rq;
+	unsigned long old_weight = se->load.weight;
 	int on_rq;
 
 	on_rq = se->on_rq;
@@ -8753,8 +8751,10 @@ static void __set_se_shares(struct sched
 	se->load.weight = shares;
 	se->load.inv_weight = 0;
 
-	if (on_rq)
+	if (on_rq) {
 		enqueue_entity(cfs_rq, se, 0);
+		prio_changed_entity(cfs_rq, se, old_weight, shares);
+	}
 }
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1671,6 +1671,41 @@ static void task_new_fair(struct rq *rq,
 	enqueue_task_fair(rq, p, 0);
 }
 
+static void prio_changed_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
+		unsigned long old_weight, unsigned long new_weight)
+{
+	u64 avg;
+	s64 lag;
+
+	if (old_weight == new_weight)
+		return;
+
+	/*
+	 * XXX very likely we just did a dequeue/enqueue cycle already
+	 * optimize this...
+	 */
+	update_curr(cfs_rq);
+	avg = avg_vruntime(cfs_rq);
+	if (se != cfs_rq->curr)
+		__dequeue_entity(cfs_rq, se);
+
+	/*
+	 * When changing weight, keep the lag invariant under real time.
+	 * So under transformation(w->w') keep dt == dt':
+	 *
+	 *   dv = dt/w -> w dv = dt
+	 *   w dv = w' dv' -> dv' = w/w' dv
+	 */
+	lag = (s64)(se->vruntime - avg);
+	lag *= old_weight;
+	lag = div_s64(lag, new_weight);
+
+	se->vruntime = avg + lag;
+	if (se != cfs_rq->curr)
+		__enqueue_entity(cfs_rq, se);
+	update_min_vruntime(cfs_rq);
+}
+
 /*
  * Priority of the task has changed. Check to see if we preempt
  * the current task.
@@ -1678,6 +1713,11 @@ static void task_new_fair(struct rq *rq,
 static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 			      int oldprio, int running)
 {
+	if (!rt_prio(oldprio))
+		prio_changed_entity(&rq->cfs, &p->se,
+				prio_to_weight[USER_PRIO(oldprio)],
+				prio_to_weight[USER_PRIO(p->prio)]);
+
 	/*
 	 * Reschedule if we are currently running on this runqueue and
 	 * our priority decreased, or if we are not currently running on

-- 

