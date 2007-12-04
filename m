Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXLDVJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXLDVJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXLDVHC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:02 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53441
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755165AbXLDVHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:00 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 07/23] Subject: SCHED - disable CFS RT load balancing.
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:01 -0500
Message-ID: <20071204204501.3567.25517.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since we now take an active approach to load balancing, we don't need to
balance RT tasks via CFS. In fact, this code was found to pull RT tasks
away from CPUS that the active movement performed, resulting in
large latencies.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   95 ++---------------------------------------------------
 1 files changed, 4 insertions(+), 91 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a0b05ff..ea07ffa 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -565,109 +565,22 @@ static void wakeup_balance_rt(struct rq *rq, struct task_struct *p)
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

