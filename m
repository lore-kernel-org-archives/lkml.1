Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYFJW6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYFJW6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYFJW6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:58:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:23585 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbYFJW6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=js+SrjICsIimihYnlZaZ5jcne38fWCZmEVyv+e641iwLwrcKGLyg7c0/j1DFDEcQRq
         iN0fQl3EWspbhc1+mmfLVAsRpMDeM+KfR24AIHRJkoB4DgFvLKaf9QY3tZI7c1hYZMkm
         AlPJ4+NcH+XcLZbT6ACrPAianx8RLwip7ppaU=
Subject: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 11 Jun 2008 00:58:30 +0200
Message-Id: <1213138710.26530.51.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Gregory,


regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f


I think we can do it simpler. Please take a look at the patch below.

Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and twice so on x86_64),
let's add "exclusive" (the ones that are bound to this CPU) tasks to the head of the queue
and "shared" ones -- to the end.

In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not queued as now), meaning that
a task {i+1} is being placed in front of the previously woken up task {i}. But I don't think that
this behavior may cause any realistic problems.


There are a couple of changes on top of this one.

(1) in check_preempt_curr_rt()

I don't think there is a need for the "pick_next_rt_entity(rq, &rq->rt) != &rq->curr->rt" check.

enqueue_task_rt(p) and check_preempt_curr_rt() are always called one after another with rq->lock being held so
the following check "p->rt.nr_cpus_allowed == 1 && rq->curr->rt.nr_cpus_allowed != 1"
should be enough (well, just its left part) to guarantee that 'p' has been queued in front of the 'curr'.

(2) in set_cpus_allowed_rt()

I don't thinks there is a need for requeue_task_rt() here.

Perhaps, the only case when 'requeue' (+ reschedule) might be useful is as follows:

i) weight == 1 && cpu_isset(task_cpu(p), *new_mask)

i.e. a task is being bound to this CPU);

ii) 'p' != rq->curr

but here, 'p' has already been on this CPU for a while and was not migrated. i.e. it's possible that 'rq->curr'
would not have high chances to be migrated right at this particular moment (although, has chance in a bit longer term),
should we allow it to be preempted.


Anyway, I think we should not perhaps make it more complex trying to address some rare corner cases.
For instance, that's why a single queue approach would be preferable. Unless I'm missing something obvious,
this approach gives us similar functionality at lower cost.


Verified only compilation-wise.


(Almost)-Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

diff --git a/kernel/sched.c b/kernel/sched.c
index 268a850..e1c382d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -155,8 +155,7 @@ static inline int task_has_rt_policy(struct task_struct *p)
  */
 struct rt_prio_array {
 	DECLARE_BITMAP(bitmap, MAX_RT_PRIO+1); /* include 1 bit for delimiter */
-	struct list_head xqueue[MAX_RT_PRIO]; /* exclusive queue */
-	struct list_head squeue[MAX_RT_PRIO];  /* shared queue */
+	struct list_head queue[MAX_RT_PRIO];
 };
 
 struct rt_bandwidth {
@@ -7661,8 +7660,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 	array = &rt_rq->active;
 	for (i = 0; i < MAX_RT_PRIO; i++) {
-		INIT_LIST_HEAD(array->xqueue + i);
-		INIT_LIST_HEAD(array->squeue + i);
+		INIT_LIST_HEAD(array->queue + i);
 		__clear_bit(i, array->bitmap);
 	}
 	/* delimiter for bitsearch: */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 49a225e..2437504 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -576,16 +576,15 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
 	if (group_rq && rt_rq_throttled(group_rq))
 		return;
 
 	if (rt_se->nr_cpus_allowed == 1)
-		list_add_tail(&rt_se->run_list,
-			      array->xqueue + rt_se_prio(rt_se));
+		list_add(&rt_se->run_list, queue);
 	else
-		list_add_tail(&rt_se->run_list,
-			      array->squeue + rt_se_prio(rt_se));
+		list_add_tail(&rt_se->run_list, queue);
 
 	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
@@ -598,8 +597,7 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
 	struct rt_prio_array *array = &rt_rq->active;
 
 	list_del_init(&rt_se->run_list);
-	if (list_empty(array->squeue + rt_se_prio(rt_se))
-	    && list_empty(array->xqueue + rt_se_prio(rt_se)))
+	if (list_empty(array->queue + rt_se_prio(rt_se)))
 		__clear_bit(rt_se_prio(rt_se), array->bitmap);
 
 	dec_rt_tasks(rt_se, rt_rq);
@@ -666,11 +664,6 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 /*
  * Put task to the end of the run list without the overhead of dequeue
  * followed by enqueue.
- *
- * Note: We always enqueue the task to the shared-queue, regardless of its
- * previous position w.r.t. exclusive vs shared.  This is so that exclusive RR
- * tasks fairly round-robin with all tasks on the runqueue, not just other
- * exclusive tasks.
  */
 static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
@@ -678,7 +671,7 @@ void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 	struct rt_prio_array *array = &rt_rq->active;
 
 	list_del_init(&rt_se->run_list);
-	list_add_tail(&rt_se->run_list, array->squeue + rt_se_prio(rt_se));
+	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
@@ -736,9 +729,6 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 }
 #endif /* CONFIG_SMP */
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq);
-
 /*
  * Preempt the current task with a newly woken task if needed:
  */
@@ -764,8 +754,7 @@ static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
 	 */
 	if((p->prio == rq->curr->prio)
 	   && p->rt.nr_cpus_allowed == 1
-	   && rq->curr->rt.nr_cpus_allowed != 1
-	   && pick_next_rt_entity(rq, &rq->rt) != &rq->curr->rt) {
+	   && rq->curr->rt.nr_cpus_allowed != 1) {
 		cpumask_t mask;
 
 		if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
@@ -789,15 +778,8 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	idx = sched_find_first_bit(array->bitmap);
 	BUG_ON(idx >= MAX_RT_PRIO);
 
-	queue = array->xqueue + idx;
-	if (!list_empty(queue))
-		next = list_entry(queue->next, struct sched_rt_entity,
-				  run_list);
-	else {
-		queue = array->squeue + idx;
-		next = list_entry(queue->next, struct sched_rt_entity,
-				  run_list);
-	}
+	queue = array->queue + idx;
+	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
 }
@@ -867,7 +849,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 			continue;
 		if (next && next->prio < idx)
 			continue;
-		list_for_each_entry(rt_se, array->squeue + idx, run_list) {
+		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p = rt_task_of(rt_se);
 			if (pick_rt_task(rq, p, cpu)) {
 				next = p;
@@ -1249,14 +1231,6 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 		}
 
 		update_rt_migration(rq);
-
-		if (unlikely(weight == 1 || p->rt.nr_cpus_allowed == 1))
-			/*
-			 * If either the new or old weight is a "1", we need
-			 * to requeue to properly move between shared and
-			 * exclusive queues.
-			 */
-			requeue_task_rt(rq, p);
 	}
 
 	p->cpus_allowed    = *new_mask;


---

