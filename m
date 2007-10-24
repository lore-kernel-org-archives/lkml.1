Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbXJXOIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbXJXOIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbXJXOH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:26 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49074
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757955AbXJXOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/9] RT: Fixes for push-rt patch
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:52:43 -0400
Message-ID: <20071024135243.7960.31298.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Steve found these errors in the original patch

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |   15 ++++++++-
 kernel/sched_rt.c |   90 +----------------------------------------------------
 2 files changed, 15 insertions(+), 90 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0dabf89..821f115 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1505,7 +1505,7 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 		for_each_cpu_mask(cpu, *cpu_mask) {
 			struct rq *rq = &per_cpu(runqueues, cpu);
 
-			if (cpu == smp_processor_id())
+			if (cpu == this_rq->cpu)
 				continue;
 
 			/* We look for lowest RT prio or non-rt CPU */
@@ -1533,7 +1533,8 @@ static struct rq *find_lock_lowest_rq(cpumask_t *cpu_mask,
 			 * the mean time, task could have
 			 * migrated already or had its affinity changed.
 			 */
-			if (unlikely(task_rq(task) != this_rq ||
+			if (unlikely(task_running(this_rq, task) ||
+				     task_rq(task) != this_rq ||
 				     !cpu_isset(dst_cpu, task->cpus_allowed))) {
 				spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -2342,6 +2343,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		spin_unlock(&rq->lock);
 	}
 #endif
+
 	fire_sched_in_preempt_notifiers(current);
 	trace_stop_sched_switched(current);
 	/*
@@ -4064,6 +4066,15 @@ asmlinkage void __sched __schedule(void)
 		context_switch(rq, prev, next); /* unlocks the rq */
 		__preempt_enable_no_resched();
 	} else {
+#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
+		/*
+		 * If we hit the condition where we do not need to actually
+		 * reschedule, we need to check if there are any tasks that
+		 * should be pushed away
+		 */
+		if (unlikely(rq->rt_nr_running > 1))
+			push_rt_tasks(rq);
+#endif
 		__preempt_enable_no_resched();
 		spin_unlock(&rq->lock);
 		trace_stop_sched_switched(next);
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 8d59e62..546526b 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -146,100 +146,14 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 	p->se.exec_start = 0;
 }
 
-/*
- * Load-balancing iterator. Note: while the runqueue stays locked
- * during the whole iteration, the current task might be
- * dequeued so the iterator has to be dequeue-safe. Here we
- * achieve that by always pre-iterating before returning
- * the current task:
- */
-static struct task_struct *load_balance_start_rt(void *arg)
-{
-	struct rq *rq = arg;
-	struct rt_prio_array *array = &rq->rt.active;
-	struct list_head *head, *curr;
-	struct task_struct *p;
-	int idx;
-
-	idx = sched_find_first_bit(array->bitmap);
-	if (idx >= MAX_RT_PRIO)
-		return NULL;
-
-	head = array->queue + idx;
-	curr = head->prev;
-
-	p = list_entry(curr, struct task_struct, run_list);
-
-	curr = curr->prev;
-
-	rq->rt.rt_load_balance_idx = idx;
-	rq->rt.rt_load_balance_head = head;
-	rq->rt.rt_load_balance_curr = curr;
-
-	return p;
-}
-
-static struct task_struct *load_balance_next_rt(void *arg)
-{
-	struct rq *rq = arg;
-	struct rt_prio_array *array = &rq->rt.active;
-	struct list_head *head, *curr;
-	struct task_struct *p;
-	int idx;
-
-	idx = rq->rt.rt_load_balance_idx;
-	head = rq->rt.rt_load_balance_head;
-	curr = rq->rt.rt_load_balance_curr;
-
-	/*
-	 * If we arrived back to the head again then
-	 * iterate to the next queue (if any):
-	 */
-	if (unlikely(head == curr)) {
-		int next_idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-
-		if (next_idx >= MAX_RT_PRIO)
-			return NULL;
-
-		idx = next_idx;
-		head = array->queue + idx;
-		curr = head->prev;
-
-		rq->rt.rt_load_balance_idx = idx;
-		rq->rt.rt_load_balance_head = head;
-	}
-
-	p = list_entry(curr, struct task_struct, run_list);
-
-	curr = curr->prev;
-
-	rq->rt.rt_load_balance_curr = curr;
-
-	return p;
-}
-
 static unsigned long
 load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *all_pinned, int *this_best_prio)
 {
-	int nr_moved;
-	struct rq_iterator rt_rq_iterator;
-	unsigned long load_moved;
-
-	rt_rq_iterator.start = load_balance_start_rt;
-	rt_rq_iterator.next = load_balance_next_rt;
-	/* pass 'busiest' rq argument into
-	 * load_balance_[start|next]_rt iterators
-	 */
-	rt_rq_iterator.arg = busiest;
-
-	nr_moved = balance_tasks(this_rq, this_cpu, busiest, max_nr_move,
-			max_load_move, sd, idle, all_pinned, &load_moved,
-			this_best_prio, &rt_rq_iterator);
-
-	return load_moved;
+	/* No passive migration for RT */
+	return 0;
 }
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)

