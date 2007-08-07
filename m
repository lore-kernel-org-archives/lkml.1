Return-Path: <linux-kernel-owner+w=401wt.eu-S1765180AbXHGFfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765180AbXHGFfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 01:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbXHGFfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 01:35:07 -0400
Received: from qsrv02sl.mx.bigpond.com ([144.140.93.182]:52954 "EHLO
	qsrv02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXHGFfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 01:35:05 -0400
Message-ID: <46B7F568.3040901@bigpond.net.au>
Date: Tue, 07 Aug 2007 14:30:32 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Fix bug in balance_tasks()
Content-Type: multipart/mixed;
 boundary="------------090104010106070808000001"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta02sl.mx.bigpond.com from [124.185.55.246] using ID pwil3058@bigpond.net.au at Tue, 7 Aug 2007 04:30:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090104010106070808000001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

There are two problems with balance_tasks() and how it used:

1. The variables best_prio and best_prio_seen (inherited from the old 
move_tasks()) were only required to handle problems caused by the 
active/expired arrays, the order in which they were processed and the 
possibility that the task with the highest priority could be on either. 
  These issues are no longer present and the extra overhead associated 
with their use is unnecessary (and possibly wrong).

2. In the absence of CONFIG_FAIR_GROUP_SCHED being set, the same 
this_best_prio variable needs to be used by all scheduling classes or 
there is a risk of moving too much load.  E.g. if the highest priority 
task on this at the beginning is a fairly low priority task and the rt 
class migrates a task (during its turn) then that moved task becomes the 
new highest priority task on this_rq but when the sched_fair class 
initializes its copy of this_best_prio it will get the priority of the 
original highest priority task as, due to the run queue locks being 
held, the reschedule triggered by pull_task() will not have taken place. 
  This could result in inappropriate overriding of skip_for_load and 
excessive load being moved.

The attached patch addresses these problems by deleting all reference to 
best_prio and best_prio_seen and making this_best_prio a reference 
parameter to the various functions involved.

load_balance_fair() has also been modified so that this_best_prio is 
only reset (in the loop) if CONFIG_FAIR_GROUP_SCHED is set.  This should 
preserve the effect of helping spread groups' higher priority tasks 
around the available CPUs while improving system performance when 
CONFIG_FAIR_GROUP_SCHED isn't set.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
   -- Ambrose Bierce


--------------090104010106070808000001
Content-Type: text/x-patch;
 name="fix-balance_tasks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-balance_tasks.patch"

diff -r c39ddf75cd08 include/linux/sched.h
--- a/include/linux/sched.h	Mon Aug 06 16:08:52 2007 +1000
+++ b/include/linux/sched.h	Mon Aug 06 16:13:20 2007 +1000
@@ -870,7 +870,7 @@ struct sched_class {
 			struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned);
+			int *all_pinned, int *this_best_prio);
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
diff -r c39ddf75cd08 kernel/sched.c
--- a/kernel/sched.c	Mon Aug 06 16:08:52 2007 +1000
+++ b/kernel/sched.c	Mon Aug 06 16:52:59 2007 +1000
@@ -745,8 +745,7 @@ static int balance_tasks(struct rq *this
 		      unsigned long max_nr_move, unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned, unsigned long *load_moved,
-		      int this_best_prio, int best_prio, int best_prio_seen,
-		      struct rq_iterator *iterator);
+		      int *this_best_prio, struct rq_iterator *iterator);
 
 #include "sched_stats.h"
 #include "sched_rt.c"
@@ -2166,8 +2165,7 @@ static int balance_tasks(struct rq *this
 		      unsigned long max_nr_move, unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned, unsigned long *load_moved,
-		      int this_best_prio, int best_prio, int best_prio_seen,
-		      struct rq_iterator *iterator)
+		      int *this_best_prio, struct rq_iterator *iterator)
 {
 	int pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
@@ -2192,12 +2190,8 @@ next:
 	 */
 	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
 							 SCHED_LOAD_SCALE_FUZZ;
-	if (skip_for_load && p->prio < this_best_prio)
-		skip_for_load = !best_prio_seen && p->prio == best_prio;
-	if (skip_for_load ||
+	if ((skip_for_load && p->prio >= *this_best_prio) ||
 	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
-
-		best_prio_seen |= p->prio == best_prio;
 		p = iterator->next(iterator->arg);
 		goto next;
 	}
@@ -2211,8 +2205,8 @@ next:
 	 * and the prescribed amount of weighted load.
 	 */
 	if (pulled < max_nr_move && rem_load_move > 0) {
-		if (p->prio < this_best_prio)
-			this_best_prio = p->prio;
+		if (p->prio < *this_best_prio)
+			*this_best_prio = p->prio;
 		p = iterator->next(iterator->arg);
 		goto next;
 	}
@@ -2244,12 +2238,13 @@ static int move_tasks(struct rq *this_rq
 {
 	struct sched_class *class = sched_class_highest;
 	unsigned long total_load_moved = 0;
+	int this_best_prio = this_rq->curr->prio;
 
 	do {
 		total_load_moved +=
 			class->load_balance(this_rq, this_cpu, busiest,
 				ULONG_MAX, max_load_move - total_load_moved,
-				sd, idle, all_pinned);
+				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
 	} while (class && max_load_move > total_load_moved);
 
@@ -2267,10 +2262,12 @@ static int move_one_task(struct rq *this
 			 struct sched_domain *sd, enum cpu_idle_type idle)
 {
 	struct sched_class *class;
+	int this_best_prio = MAX_PRIO;
 
 	for (class = sched_class_highest; class; class = class->next)
 		if (class->load_balance(this_rq, this_cpu, busiest,
-					1, ULONG_MAX, sd, idle, NULL))
+					1, ULONG_MAX, sd, idle, NULL,
+					&this_best_prio))
 			return 1;
 
 	return 0;
@@ -3185,8 +3182,7 @@ static int balance_tasks(struct rq *this
 		      unsigned long max_nr_move, unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned, unsigned long *load_moved,
-		      int this_best_prio, int best_prio, int best_prio_seen,
-		      struct rq_iterator *iterator)
+		      int *this_best_prio, struct rq_iterator *iterator)
 {
 	*load_moved = 0;
 
diff -r c39ddf75cd08 kernel/sched_fair.c
--- a/kernel/sched_fair.c	Mon Aug 06 16:08:52 2007 +1000
+++ b/kernel/sched_fair.c	Mon Aug 06 17:03:26 2007 +1000
@@ -930,6 +930,7 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->rb_load_balance_curr);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static int cfs_rq_best_prio(struct cfs_rq *cfs_rq)
 {
 	struct sched_entity *curr;
@@ -943,12 +944,13 @@ static int cfs_rq_best_prio(struct cfs_r
 
 	return p->prio;
 }
+#endif
 
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-			unsigned long max_nr_move, unsigned long max_load_move,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned)
+		  unsigned long max_nr_move, unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
 {
 	struct cfs_rq *busy_cfs_rq;
 	unsigned long load_moved, total_nr_moved = 0, nr_moved;
@@ -959,10 +961,10 @@ load_balance_fair(struct rq *this_rq, in
 	cfs_rq_iterator.next = load_balance_next_fair;
 
 	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 		struct cfs_rq *this_cfs_rq;
-		long imbalance;
+		long imbalances;
 		unsigned long maxload;
-		int this_best_prio, best_prio, best_prio_seen = 0;
 
 		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
 
@@ -976,27 +978,17 @@ load_balance_fair(struct rq *this_rq, in
 		imbalance /= 2;
 		maxload = min(rem_load_move, imbalance);
 
-		this_best_prio = cfs_rq_best_prio(this_cfs_rq);
-		best_prio = cfs_rq_best_prio(busy_cfs_rq);
-
-		/*
-		 * Enable handling of the case where there is more than one task
-		 * with the best priority. If the current running task is one
-		 * of those with prio==best_prio we know it won't be moved
-		 * and therefore it's safe to override the skip (based on load)
-		 * of any task we find with that prio.
-		 */
-		if (cfs_rq_curr(busy_cfs_rq) == &busiest->curr->se)
-			best_prio_seen = 1;
-
+		*this_best_prio = cfs_rq_best_prio(this_cfs_rq);
+#else
+#define maxload rem_load_move
+#endif
 		/* pass busy_cfs_rq argument into
 		 * load_balance_[start|next]_fair iterators
 		 */
 		cfs_rq_iterator.arg = busy_cfs_rq;
 		nr_moved = balance_tasks(this_rq, this_cpu, busiest,
 				max_nr_move, maxload, sd, idle, all_pinned,
-				&load_moved, this_best_prio, best_prio,
-				best_prio_seen, &cfs_rq_iterator);
+				&load_moved, this_best_prio, &cfs_rq_iterator);
 
 		total_nr_moved += nr_moved;
 		max_nr_move -= nr_moved;
diff -r c39ddf75cd08 kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Mon Aug 06 16:08:52 2007 +1000
+++ b/kernel/sched_idletask.c	Mon Aug 06 16:19:21 2007 +1000
@@ -41,7 +41,7 @@ load_balance_idle(struct rq *this_rq, in
 load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned)
+			int *all_pinned, int *this_best_prio)
 {
 	return 0;
 }
diff -r c39ddf75cd08 kernel/sched_rt.c
--- a/kernel/sched_rt.c	Mon Aug 06 16:08:52 2007 +1000
+++ b/kernel/sched_rt.c	Mon Aug 06 16:18:34 2007 +1000
@@ -176,25 +176,11 @@ load_balance_rt(struct rq *this_rq, int 
 load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned)
-{
-	int this_best_prio, best_prio, best_prio_seen = 0;
+			int *all_pinned, int *this_best_prio)
+{
 	int nr_moved;
 	struct rq_iterator rt_rq_iterator;
 	unsigned long load_moved;
-
-	best_prio = sched_find_first_bit(busiest->rt.active.bitmap);
-	this_best_prio = sched_find_first_bit(this_rq->rt.active.bitmap);
-
-	/*
-	 * Enable handling of the case where there is more than one task
-	 * with the best priority.   If the current running task is one
-	 * of those with prio==best_prio we know it won't be moved
-	 * and therefore it's safe to override the skip (based on load)
-	 * of any task we find with that prio.
-	 */
-	if (busiest->curr->prio == best_prio)
-		best_prio_seen = 1;
 
 	rt_rq_iterator.start = load_balance_start_rt;
 	rt_rq_iterator.next = load_balance_next_rt;
@@ -205,8 +191,7 @@ load_balance_rt(struct rq *this_rq, int 
 
 	nr_moved = balance_tasks(this_rq, this_cpu, busiest, max_nr_move,
 			max_load_move, sd, idle, all_pinned, &load_moved,
-			this_best_prio, best_prio, best_prio_seen,
-			&rt_rq_iterator);
+			this_best_prio, &rt_rq_iterator);
 
 	return load_moved;
 }

--------------090104010106070808000001--
