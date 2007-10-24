Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXJXOI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXJXOI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXJXOHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:31 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49082
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758720AbXJXOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/9] RT: Clean up some of the push-rt logic
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:52:48 -0400
Message-ID: <20071024135248.7960.54006.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the superfluous dst_cpu, move the cpu_mask inside the search
function, and collapse the two redundant pick-next-rt() functions.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |   27 ++++++++++++---------------
 kernel/sched_rt.c |   44 --------------------------------------------
 2 files changed, 12 insertions(+), 59 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 821f115..de5fc1c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1471,9 +1471,10 @@ next_in_queue:
 	 * Return the highest-prio non-running RT task (if task
 	 * may run on this CPU):
 	 */
-	if (!task_running(src_rq, tmp) &&
-				cpu_isset(this_cpu, tmp->cpus_allowed))
-		return tmp;
+	if (!task_running(src_rq, tmp)) {
+		if ((this_cpu == -1) || cpu_isset(this_cpu, tmp->cpus_allowed))
+			return tmp;
+	}
 
 	curr = curr->next;
 	if (curr != head)
@@ -1489,20 +1490,21 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 #define RT_PUSH_MAX_TRIES 3
 
 /* Will lock the rq it finds */
-static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
-				      struct task_struct *task,
+static struct rq *find_lock_lowest_rq(struct task_struct *task,
 				      struct rq *this_rq)
 {
 	struct rq *lowest_rq = NULL;
-	int dst_cpu = -1;
 	int cpu;
 	int tries;
+	cpumask_t cpu_mask;
+
+	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
 
 	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
 		/*
 		 * Scan each rq for the lowest prio.
 		 */
-		for_each_cpu_mask(cpu, *cpu_mask) {
+		for_each_cpu_mask(cpu, cpu_mask) {
 			struct rq *rq = &per_cpu(runqueues, cpu);
 
 			if (cpu == this_rq->cpu)
@@ -1511,7 +1513,6 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			/* We look for lowest RT prio or non-rt CPU */
 			if (rq->curr_prio >= MAX_RT_PRIO) {
 				lowest_rq = rq;
-				dst_cpu = cpu;
 				break;
 			}
 
@@ -1519,7 +1520,6 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			if (rq->curr_prio > task->prio &&
 			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
 				lowest_rq = rq;
-				dst_cpu = cpu;
 			}
 		}
 
@@ -1535,7 +1535,7 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			 */
 			if (unlikely(task_running(this_rq, task) ||
 				     task_rq(task) != this_rq ||
-				     !cpu_isset(dst_cpu, task->cpus_allowed))) {
+				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed))) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
 				break;
@@ -1566,21 +1566,18 @@ static int push_rt_task(struct rq *this_rq)
 	struct rq *lowest_rq;
 	int dst_cpu;
 	int ret = 0;
-	cpumask_t cpu_mask;
 
 	assert_spin_locked(&this_rq->lock);
 
-	next_task = rt_next_highest_task(this_rq);
+	next_task = pick_rt_task(this_rq, -1);
 	if (!next_task)
 		return 0;
 
-	cpus_and(cpu_mask, cpu_online_map, next_task->cpus_allowed);
-
 	/* We might release this_rq lock */
 	get_task_struct(next_task);
 
 	/* find_lock_lowest_rq locks the rq if found */
-	lowest_rq = find_lock_lowest_rq(&cpu_mask, next_task, this_rq);
+	lowest_rq = find_lock_lowest_rq(next_task, this_rq);
 	if (!lowest_rq)
 		goto out;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 546526b..9b677c1 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -96,50 +96,6 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
 	return next;
 }
 
-#ifdef CONFIG_PREEMPT_RT
-static struct task_struct *rt_next_highest_task(struct rq *rq)
-{
-	struct rt_prio_array *array = &rq->rt.active;
-	struct task_struct *next;
-	struct list_head *queue;
-	int idx;
-
-	if (likely (rq->rt_nr_running < 2))
-		return NULL;
-
-	idx = sched_find_first_bit(array->bitmap);
-	if (idx >= MAX_RT_PRIO) {
-		WARN_ON(1); /* rt_nr_running is bad */
-		return NULL;
-	}
-
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
-	if (unlikely(next != current))
-		return next;
-
-	if (queue->next->next != queue) {
-		/* same prio task */
-		next = list_entry(queue->next->next, struct task_struct, run_list);
-		goto out;
-	}
-
-	/* slower, but more flexible */
-	idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-	if (idx >= MAX_RT_PRIO) {
-		WARN_ON(1); /* rt_nr_running was 2 and above! */
-		return NULL;
-	}
-
-	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, run_list);
-
- out:
-	return next;
-
-}
-#endif /* CONFIG_PREEMPT_RT */
-
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);

