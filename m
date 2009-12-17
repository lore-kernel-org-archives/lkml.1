Return-Path: <linux-kernel-owner+w=401wt.eu-S936694AbZLQS7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936694AbZLQS7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbZLQS7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:59:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59020 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615AbZLQS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:59:08 -0500
Message-Id: <20091217185430.502721509@chello.nl>
References: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:25 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] sched: Remove rq_iterator from move_one_task
Content-Disposition: inline; filename=sched-lb-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, since we only iterate the fair class, remove the abstraction.

Since this is the last user of the rq_iterator, remove all that too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |  146 ++++++++++++----------------------------------------
 1 file changed, 36 insertions(+), 110 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1814,54 +1814,6 @@ static void put_prev_task_fair(struct rq
  * Fair scheduling class load-balancing methods:
  */
 
-/*
- * Load-balancing iterator. Note: while the runqueue stays locked
- * during the whole iteration, the current task might be
- * dequeued so the iterator has to be dequeue-safe. Here we
- * achieve that by always pre-iterating before returning
- * the current task:
- */
-static struct task_struct *
-__load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
-{
-	struct task_struct *p = NULL;
-	struct sched_entity *se;
-
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	se = list_entry(next, struct sched_entity, group_node);
-	p = task_of(se);
-	cfs_rq->balance_iterator = next->next;
-
-	return p;
-}
-
-static struct task_struct *load_balance_start_fair(void *arg)
-{
-	struct cfs_rq *cfs_rq = arg;
-
-	return __load_balance_iterator(cfs_rq, cfs_rq->tasks.next);
-}
-
-static struct task_struct *load_balance_next_fair(void *arg)
-{
-	struct cfs_rq *cfs_rq = arg;
-
-	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
-}
-
-/*
- * runqueue iterator, to support SMP load-balancing between different
- * scheduling classes, without having to expose their internal data
- * structures to the load-balancing proper:
- */
-struct rq_iterator {
-	void *arg;
-	struct task_struct *(*start)(void *);
-	struct task_struct *(*next)(void *);
-};
-
 static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move, struct sched_domain *sd,
@@ -1929,42 +1881,6 @@ load_balance_fair(struct rq *this_rq, in
 }
 #endif
 
-static int
-iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		struct sched_domain *sd, enum cpu_idle_type idle,
-		struct rq_iterator *iterator);
-
-/*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
- * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int
-move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      struct sched_domain *sd, enum cpu_idle_type idle)
-{
-	struct cfs_rq *busy_cfs_rq;
-	struct rq_iterator cfs_rq_iterator;
-
-	cfs_rq_iterator.start = load_balance_start_fair;
-	cfs_rq_iterator.next = load_balance_next_fair;
-
-	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
-		/*
-		 * pass busy_cfs_rq argument into
-		 * load_balance_[start|next]_fair iterators
-		 */
-		cfs_rq_iterator.arg = busy_cfs_rq;
-		if (iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
-				       &cfs_rq_iterator))
-		    return 1;
-	}
-
-	return 0;
-}
-
 /*
  * pull_task - move a task from a remote runqueue to the local runqueue.
  * Both runqueues must be locked.
@@ -2029,6 +1945,42 @@ int can_migrate_task(struct task_struct 
 	return 1;
 }
 
+/*
+ * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * part of active balancing operations within "domain".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int
+move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+	      struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	struct task_struct *p, *n;
+	struct cfs_rq *cfs_rq;
+	int pinned = 0;
+
+	for_each_leaf_cfs_rq(busiest, cfs_rq) {
+		list_for_each_entry_safe(p, n, &cfs_rq->tasks, se.group_node) {
+
+			if (!can_migrate_task(p, busiest, this_cpu,
+						sd, idle, &pinned))
+				continue;
+
+			pull_task(busiest, p, this_rq, this_cpu);
+			/*
+			 * Right now, this is only the second place pull_task()
+			 * is called, so we can safely collect pull_task()
+			 * stats here rather than inside pull_task().
+			 */
+			schedstat_inc(sd, lb_gained[idle]);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
@@ -2125,32 +2077,6 @@ static int move_tasks(struct rq *this_rq
 	return total_load_moved > 0;
 }
 
-static int
-iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle,
-		   struct rq_iterator *iterator)
-{
-	struct task_struct *p = iterator->start(iterator->arg);
-	int pinned = 0;
-
-	while (p) {
-		if (can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
-			pull_task(busiest, p, this_rq, this_cpu);
-			/*
-			 * Right now, this is only the second place pull_task()
-			 * is called, so we can safely collect pull_task()
-			 * stats here rather than inside pull_task().
-			 */
-			schedstat_inc(sd, lb_gained[idle]);
-
-			return 1;
-		}
-		p = iterator->next(iterator->arg);
-	}
-
-	return 0;
-}
-
 /********** Helpers for find_busiest_group ************************/
 /*
  * sd_lb_stats - Structure to store the statistics of a sched_domain

-- 

