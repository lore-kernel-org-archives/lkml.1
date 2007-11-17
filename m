Return-Path: <linux-kernel-owner+w=401wt.eu-S933136AbXKQG1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933136AbXKQG1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759675AbXKQGYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:42 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:45568 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863AbXKQGYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:40 -0500
Message-Id: <20071117062404.185726295@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 07/17] disable CFS RT load balancing.
Content-Disposition: inline; filename=disable-CFS-rt-balance.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now take an active approach to load balancing, we don't need to
balance RT tasks via CFS. In fact, this code was found to pull RT tasks
away from CPUS that the active movement performed, resulting in
large latencies.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/sched_rt.c |   95 ++----------------------------------------------------
 1 file changed, 4 insertions(+), 91 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:12:17.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:12:19.000000000 -0500
@@ -571,109 +571,22 @@ static void wakeup_balance_rt(struct rq 
 		push_rt_tasks(rq);
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
 		unsigned long max_load_move,
 		struct sched_domain *sd, enum cpu_idle_type idle,
 		int *all_pinned, int *this_best_prio)
 {
-	struct rq_iterator rt_rq_iterator;
-
-	rt_rq_iterator.start = load_balance_start_rt;
-	rt_rq_iterator.next = load_balance_next_rt;
-	/* pass 'busiest' rq argument into
-	 * load_balance_[start|next]_rt iterators
-	 */
-	rt_rq_iterator.arg = busiest;
-
-	return balance_tasks(this_rq, this_cpu, busiest, max_load_move, sd,
-			     idle, all_pinned, this_best_prio, &rt_rq_iterator);
+	/* don't touch RT tasks */
+	return 0;
 }
 
 static int
 move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 struct sched_domain *sd, enum cpu_idle_type idle)
 {
-	struct rq_iterator rt_rq_iterator;
-
-	rt_rq_iterator.start = load_balance_start_rt;
-	rt_rq_iterator.next = load_balance_next_rt;
-	rt_rq_iterator.arg = busiest;
-
-	return iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
-				  &rt_rq_iterator);
+	/* don't touch RT tasks */
+	return 0;
 }
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)

-- 
