Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbXJWDbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbXJWDbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXJWD3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:29:47 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64642 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbXJWD3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:29:43 -0400
Message-Id: <20071023032917.119896476@goodmis.org>
References: <20071023025900.927578809@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 22 Oct 2007 22:59:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -v2 7/7] disable CFS RT load balancing.
Content-Disposition: inline; filename=disable-CFS-rt-balance.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now take an active approach to load balancing, we don't need to
balance RT tasks via CFS. In fact, this code was found to pull RT tasks
away from CPUS that the active movement performed, resulting in
large latencies.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |   91 +-----------------------------------------------------
 1 file changed, 2 insertions(+), 89 deletions(-)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-22 22:38:04.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-22 22:38:33.000000000 -0400
@@ -576,101 +576,14 @@ static void wakeup_balance_rt(struct rq 
 # define wakeup_balance_rt(rq, p)	do { } while (0)
 #endif /* CONFIG_SMP */
 
-
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
+	/* don't touch RT tasks */
+	return 0;
 }
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)

-- 
