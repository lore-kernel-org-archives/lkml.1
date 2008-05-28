Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYE1B25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYE1B25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758004AbYE1B14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:27:56 -0400
Received: from lsg.lsg.lab.novell.com ([151.155.230.1]:3891 "EHLO
	lsg.lsg.lab.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYE1B1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:27:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] sched: prioritize non-migratable tasks over migratable
	ones
To: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Date: Tue, 27 May 2008 18:59:44 -0600
Message-ID: <20080528005944.4146.43831.stgit@lsg.lsg.lab.novell.com>
In-Reply-To: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
References: <20080528005647.4146.13252.stgit@lsg.lsg.lab.novell.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko pointed out a known flaw in the rt-balancing algorithm
that could allow suboptimal balancing if a non-migratable task gets
queued behind a running migratable one.  It is discussed in this thread:

http://lkml.org/lkml/2008/4/22/296

This issue has been further exacerbated by a recent checkin to
sched-devel (git-id 5eee63a5ebc19a870ac40055c0be49457f3a89a3).

>From a pure priority standpoint, the run-queue is doing the "right"
thing. Using Dmitry's nomenclature, if T0 is on cpu1 first, and T1
wakes up at equal or lower priority (affined only to cpu1) later, it
*should* wait for T0 to finish.  However, in reality that is likely
suboptimal from a system perspective if there are other cores that
could allow T0 and T1 to run concurrently.  Since T1 can not migrate,
the only choice for higher concurrency is to try to move T0.  This is
not something we addessed in the recent rt-balancing re-work.

This patch tries to enhance the balancing algorithm by accomodating this
scenario.  It accomplishes this by incorporating the migratability of a
task into its priority calculation.  Within a numerical tsk->prio, a
non-migratable task is logically higher than a migratable one.  We
maintain this by introducing a new per-priority queue (xqueue, or
exclusive-queue) for holding non-migratable tasks.  The scheduler will
draw from the xqueue over the standard shared-queue (squeue) when
available.

There are several details for utilizing this properly.

1) During task-wake-up, we not only need to check if the priority
   preempts the current task, but we also need to check for this
   non-migratable condition.  Therefore, if a non-migratable task wakes
   up and sees an equal priority migratable task already running, it
   will attempt to preempt it *if* there is a likelyhood that the
   current task will find an immediate home.

2) Tasks only get this non-migratable "priority boost" on wake-up.  Any
   requeuing will result in the non-migratable task being queued to the
   end of the shared queue.  This is an attempt to prevent the system
   from being completely unfair to migratable tasks during things like
   SCHED_RR timeslicing.

I am sure this patch introduces potentially "odd" behavior if you
concoct a scenario where a bunch of non-migratable threads could starve
migratable ones given the right pattern.  I am not yet convinced that
this is a problem since we are talking about tasks of equal RT priority
anyway, and there never is much in the way of guarantees against
starvation under that scenario anyway. (e.g. you could come up with a
similar scenario with a specific timing environment verses an affinity
environment).  I can be convinced otherwise, but for now I think this is
"ok".

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---

 kernel/sched.c    |    6 +++-
 kernel/sched_rt.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 4428916..6f876e8 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -198,7 +198,8 @@ static inline int task_has_rt_policy(struct task_struct *p)
  */
 struct rt_prio_array {
 	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head queue[MAX_RT_PRIO];
+	struct list_head xqueue[MAX_RT_PRIO];  /* exclusive queue */
+	struct list_head squeue[MAX_RT_PRIO];  /* shared queue */
 };
 
 #ifdef CONFIG_GROUP_SCHED
@@ -7567,7 +7568,8 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 	array = &rt_rq->active;
 	for (i = 0; i < MAX_RT_PRIO; i++) {
-		INIT_LIST_HEAD(array->queue + i);
+		INIT_LIST_HEAD(array->xqueue + i);
+		INIT_LIST_HEAD(array->squeue + i);
 		__clear_bit(i, array->bitmap);
 	}
 	/* delimiter for bitsearch: */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 80ef2ee..425cf01 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -352,7 +352,13 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
-	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (rt_se->nr_cpus_allowed == 1)
+		list_add_tail(&rt_se->run_list,
+			      array->xqueue + rt_se_prio(rt_se));
+	else
+		list_add_tail(&rt_se->run_list,
+			      array->squeue + rt_se_prio(rt_se));
+
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
 	inc_rt_tasks(rt_se, rt_rq);
@@ -364,7 +370,8 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 	struct rt_prio_array *array = &rt_rq->active;
 
 	list_del_init(&rt_se->run_list);
-	if (list_empty(array->queue + rt_se_prio(rt_se)))
+	if (list_empty(array->squeue + rt_se_prio(rt_se))
+	    && list_empty(array->xqueue + rt_se_prio(rt_se)))
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
@@ -492,13 +499,19 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 /*
  * Put task to the end of the run list without the overhead of dequeue
  * followed by enqueue.
+ *
+ * Note: We always enqueue the task to the shared-queue, regardless of its
+ * previous position w.r.t. exclusive vs shared.  This is so that exclusive RR
+ * tasks fairly round-robin with all tasks on the runqueue, not just other
+ * exclusive tasks.
  */
 static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 
-	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	list_del_init(&rt_se->run_list);
+	list_add_tail(&rt_se->run_list, array->squeue + rt_se_prio(rt_se));
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
@@ -556,13 +569,46 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 }
 #endif /* CONFIG_SMP */
 
+static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
+						   struct rt_rq *rt_rq);
+
 /*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
 {
-	if (p->prio < rq->curr->prio)
+	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
+		return;
+	}
+
+#ifdef CONFIG_SMP
+	/*
+	 * If:
+	 *
+	 * - the newly woken task is of equal priority to the current task
+	 * - the newly woken task is non-migratable while current is migratable
+	 * - current will be preempted on the next reschedule
+	 *
+	 * we should check to see if current can readily move to a different
+	 * cpu.  If so, we will reschedule to allow the push logic to try
+	 * to move current somewhere else, making room for our non-migratable
+	 * task.
+	 */
+	if((p->prio == rq->curr->prio)
+	   && p->rt.nr_cpus_allowed == 1
+	   && rq->curr->rt.nr_cpus_allowed != 1
+	   && pick_next_rt_entity(rq, &rq->rt) != &rq->curr->rt) {
+		cpumask_t mask;
+
+		if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
+			/*
+			 * There appears to be other cpus that can accept
+			 * current, so lets reschedule to try and push it away
+			 */
+			resched_task(rq->curr);
+	}
+#endif
 }
 
 static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
@@ -576,8 +622,15 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	idx = sched_find_first_bit(array->bitmap);
 	BUG_ON(idx >= MAX_RT_PRIO);
 
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct sched_rt_entity, run_list);
+	queue = array->xqueue + idx;
+	if (!list_empty(queue))
+		next = list_entry(queue->next, struct sched_rt_entity,
+				  run_list);
+	else {
+		queue = array->squeue + idx;
+		next = list_entry(queue->next, struct sched_rt_entity,
+				  run_list);
+	}
 
 	return next;
 }
@@ -647,7 +700,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 			continue;
 		if (next && next->prio < idx)
 			continue;
-		list_for_each_entry(rt_se, array->queue + idx, run_list) {
+		list_for_each_entry(rt_se, array->squeue + idx, run_list) {
 			struct task_struct *p = rt_task_of(rt_se);
 			if (pick_rt_task(rq, p, cpu)) {
 				next = p;
@@ -1033,6 +1086,14 @@ static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t *new_mask)
 		}
 
 		update_rt_migration(rq);
+
+		if (unlikely(weight == 1 || p->rt.nr_cpus_allowed == 1))
+			/*
+			 * If either the new or old weight is a "1", we need
+			 * to requeue to properly move between shared and
+			 * exclusive queues.
+			 */
+			requeue_task_rt(rq, p);
 	}
 
 	p->cpus_allowed    = *new_mask;

