Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXHOJJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXHOJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756465AbXHOJJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:09:50 -0400
Received: from qsrv01sl.mx.bigpond.com ([144.140.92.181]:52264 "EHLO
	qsrv01sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbXHOJJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:09:48 -0400
X-Greylist: delayed 8369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 05:09:47 EDT
Message-ID: <46C2842E.3010806@bigpond.net.au>
Date: Wed, 15 Aug 2007 14:42:22 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Reduce overhead in balance_tasks()
Content-Type: multipart/mixed;
 boundary="------------070809090602060102090609"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [124.179.165.153] using ID pwil3058@bigpond.net.au at Wed, 15 Aug 2007 04:42:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809090602060102090609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

At the moment, balance_tasks() provides low level functionality for both 
  move_tasks() and move_one_task() (indirectly) via the load_balance() 
function (in the sched_class interface) which also provides dual 
functionality.  This dual functionality complicates the interfaces and 
internal mechanisms and makes the run time overhead of operations that 
are called with two run queue locks held.

This patch addresses this issue and reduces the overhead of these 
operations.

This patch is not urgent and can be held back until the next merge 
window without compromising the safety of the kernel.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
    -- Ambrose Bierce



--------------070809090602060102090609
Content-Type: text/x-patch;
 name="reduce-balance_tasks-overhead.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="reduce-balance_tasks-overhead.patch"

diff -r 90691a597f06 include/linux/sched.h
--- a/include/linux/sched.h	Mon Aug 13 15:06:35 2007 +0000
+++ b/include/linux/sched.h	Tue Aug 14 11:11:47 2007 +1000
@@ -865,10 +865,13 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
-			struct rq *busiest,
-			unsigned long max_nr_move, unsigned long max_load_move,
+			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *all_pinned, int *this_best_prio);
+
+	int (*move_one_task) (struct rq *this_rq, int this_cpu,
+			      struct rq *busiest, struct sched_domain *sd,
+			      enum cpu_idle_type idle);
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
diff -r 90691a597f06 kernel/sched.c
--- a/kernel/sched.c	Mon Aug 13 15:06:35 2007 +0000
+++ b/kernel/sched.c	Tue Aug 14 16:26:24 2007 +1000
@@ -753,11 +753,35 @@ struct rq_iterator {
 	struct task_struct *(*next)(void *);
 };
 
-static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_nr_move, unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned, unsigned long *load_moved,
-		      int *this_best_prio, struct rq_iterator *iterator);
+#ifdef CONFIG_SMP
+static unsigned long
+balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+	      unsigned long max_load_move, struct sched_domain *sd,
+	      enum cpu_idle_type idle, int *all_pinned,
+	      int *this_best_prio, struct rq_iterator *iterator);
+
+static int
+iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle,
+		   struct rq_iterator *iterator);
+#else
+static inline unsigned long
+balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+	      unsigned long max_load_move, struct sched_domain *sd,
+	      enum cpu_idle_type idle, int *all_pinned,
+	      int *this_best_prio, struct rq_iterator *iterator)
+{
+	return 0;
+}
+
+static inline int
+iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle,
+		   struct rq_iterator *iterator)
+{
+	return 0;
+}
+#endif
 
 #include "sched_stats.h"
 #include "sched_rt.c"
@@ -2166,17 +2190,17 @@ int can_migrate_task(struct task_struct 
 	return 1;
 }
 
-static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_nr_move, unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned, unsigned long *load_moved,
-		      int *this_best_prio, struct rq_iterator *iterator)
+static unsigned long
+balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+	      unsigned long max_load_move, struct sched_domain *sd,
+	      enum cpu_idle_type idle, int *all_pinned,
+	      int *this_best_prio, struct rq_iterator *iterator)
 {
 	int pulled = 0, pinned = 0, skip_for_load;
 	struct task_struct *p;
 	long rem_load_move = max_load_move;
 
-	if (max_nr_move == 0 || max_load_move == 0)
+	if (max_load_move == 0)
 		goto out;
 
 	pinned = 1;
@@ -2209,7 +2233,7 @@ next:
 	 * We only want to steal up to the prescribed number of tasks
 	 * and the prescribed amount of weighted load.
 	 */
-	if (pulled < max_nr_move && rem_load_move > 0) {
+	if (rem_load_move > 0) {
 		if (p->prio < *this_best_prio)
 			*this_best_prio = p->prio;
 		p = iterator->next(iterator->arg);
@@ -2217,7 +2241,7 @@ next:
 	}
 out:
 	/*
-	 * Right now, this is the only place pull_task() is called,
+	 * Right now, this is one of only two places pull_task() is called,
 	 * so we can safely collect pull_task() stats here rather than
 	 * inside pull_task().
 	 */
@@ -2225,8 +2249,8 @@ out:
 
 	if (all_pinned)
 		*all_pinned = pinned;
-	*load_moved = max_load_move - rem_load_move;
-	return pulled;
+
+	return max_load_move - rem_load_move;
 }
 
 /*
@@ -2248,7 +2272,7 @@ static int move_tasks(struct rq *this_rq
 	do {
 		total_load_moved +=
 			class->load_balance(this_rq, this_cpu, busiest,
-				ULONG_MAX, max_load_move - total_load_moved,
+				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
 		class = class->next;
 	} while (class && max_load_move > total_load_moved);
@@ -2256,6 +2280,32 @@ static int move_tasks(struct rq *this_rq
 	return total_load_moved > 0;
 }
 
+static int
+iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle,
+		   struct rq_iterator *iterator)
+{
+	struct task_struct *p = iterator->start(iterator->arg);
+	int pinned = 0;
+
+	while (p) {
+		if (can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
+			pull_task(busiest, p, this_rq, this_cpu);
+			/*
+			 * Right now, this is only the second place pull_task()
+			 * is called, so we can safely collect pull_task()
+			 * stats here rather than inside pull_task().
+			 */
+			schedstat_inc(sd, lb_gained[idle]);
+
+			return 1;
+		}
+		p = iterator->next(iterator->arg);
+	}
+
+	return 0;
+}
+
 /*
  * move_one_task tries to move exactly one task from busiest to this_rq, as
  * part of active balancing operations within "domain".
@@ -2267,12 +2317,9 @@ static int move_one_task(struct rq *this
 			 struct sched_domain *sd, enum cpu_idle_type idle)
 {
 	struct sched_class *class;
-	int this_best_prio = MAX_PRIO;
 
 	for (class = sched_class_highest; class; class = class->next)
-		if (class->load_balance(this_rq, this_cpu, busiest,
-					1, ULONG_MAX, sd, idle, NULL,
-					&this_best_prio))
+		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
 			return 1;
 
 	return 0;
@@ -3184,18 +3231,6 @@ static inline void trigger_load_balance(
  */
 static inline void idle_balance(int cpu, struct rq *rq)
 {
-}
-
-/* Avoid "used but not defined" warning on UP */
-static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_nr_move, unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned, unsigned long *load_moved,
-		      int *this_best_prio, struct rq_iterator *iterator)
-{
-	*load_moved = 0;
-
-	return 0;
 }
 
 #endif
diff -r 90691a597f06 kernel/sched_fair.c
--- a/kernel/sched_fair.c	Mon Aug 13 15:06:35 2007 +0000
+++ b/kernel/sched_fair.c	Tue Aug 14 20:04:17 2007 +1000
@@ -944,24 +944,23 @@ static int cfs_rq_best_prio(struct cfs_r
 
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_nr_move, unsigned long max_load_move,
+		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
 		  int *all_pinned, int *this_best_prio)
 {
-	struct cfs_rq *busy_cfs_rq;
-	unsigned long load_moved, total_nr_moved = 0, nr_moved;
 	long rem_load_move = max_load_move;
 	struct rq_iterator cfs_rq_iterator;
 
 	cfs_rq_iterator.start = load_balance_start_fair;
 	cfs_rq_iterator.next = load_balance_next_fair;
 
-	for_each_leaf_cfs_rq(busiest, busy_cfs_rq) {
+	for_each_leaf_cfs_rq(busiest, cfs_rq_iterator.arg) {
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		struct cfs_rq *this_cfs_rq;
+		struct cfs_rq *busy_cfs_rq, *this_cfs_rq;
 		long imbalance;
 		unsigned long maxload;
 
+		busy_cfs_rq = cfs_rq_iterator.arg;
 		this_cfs_rq = cpu_cfs_rq(busy_cfs_rq, this_cpu);
 
 		imbalance = busy_cfs_rq->load.weight - this_cfs_rq->load.weight;
@@ -977,23 +976,33 @@ load_balance_fair(struct rq *this_rq, in
 #else
 # define maxload rem_load_move
 #endif
-		/* pass busy_cfs_rq argument into
-		 * load_balance_[start|next]_fair iterators
-		 */
-		cfs_rq_iterator.arg = busy_cfs_rq;
-		nr_moved = balance_tasks(this_rq, this_cpu, busiest,
-				max_nr_move, maxload, sd, idle, all_pinned,
-				&load_moved, this_best_prio, &cfs_rq_iterator);
-
-		total_nr_moved += nr_moved;
-		max_nr_move -= nr_moved;
-		rem_load_move -= load_moved;
-
-		if (max_nr_move <= 0 || rem_load_move <= 0)
+		rem_load_move -= balance_tasks(this_rq, this_cpu, busiest,
+					       maxload, sd, idle, all_pinned,
+					       this_best_prio,
+					       &cfs_rq_iterator);
+
+		if (rem_load_move <= 0)
 			break;
 	}
 
 	return max_load_move - rem_load_move;
+}
+
+static int
+move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	struct rq_iterator cfs_rq_iterator;
+
+	cfs_rq_iterator.start = load_balance_start_fair;
+	cfs_rq_iterator.next = load_balance_next_fair;
+
+	for_each_leaf_cfs_rq(busiest, cfs_rq_iterator.arg)
+		if (iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
+				       &cfs_rq_iterator))
+		    return 1;
+
+	return 0;
 }
 
 /*
@@ -1082,6 +1091,7 @@ struct sched_class fair_sched_class __re
 	.put_prev_task		= put_prev_task_fair,
 
 	.load_balance		= load_balance_fair,
+	.move_one_task		= move_one_task_fair,
 
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
diff -r 90691a597f06 kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Mon Aug 13 15:06:35 2007 +0000
+++ b/kernel/sched_idletask.c	Tue Aug 14 11:11:47 2007 +1000
@@ -39,9 +39,16 @@ static void put_prev_task_idle(struct rq
 
 static unsigned long
 load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
-			unsigned long max_nr_move, unsigned long max_load_move,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, int *this_best_prio)
+		  unsigned long max_load_move,
+		  struct sched_domain *sd, enum cpu_idle_type idle,
+		  int *all_pinned, int *this_best_prio)
+{
+	return 0;
+}
+
+static int
+move_one_task_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		   struct sched_domain *sd, enum cpu_idle_type idle)
 {
 	return 0;
 }
@@ -65,6 +72,7 @@ static struct sched_class idle_sched_cla
 	.put_prev_task		= put_prev_task_idle,
 
 	.load_balance		= load_balance_idle,
+	.move_one_task		= move_one_task_idle,
 
 	.task_tick		= task_tick_idle,
 	/* no .task_new for idle tasks */
diff -r 90691a597f06 kernel/sched_rt.c
--- a/kernel/sched_rt.c	Mon Aug 13 15:06:35 2007 +0000
+++ b/kernel/sched_rt.c	Tue Aug 14 11:11:47 2007 +1000
@@ -172,13 +172,11 @@ static struct task_struct *load_balance_
 
 static unsigned long
 load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
-			unsigned long max_nr_move, unsigned long max_load_move,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, int *this_best_prio)
-{
-	int nr_moved;
+		unsigned long max_load_move,
+		struct sched_domain *sd, enum cpu_idle_type idle,
+		int *all_pinned, int *this_best_prio)
+{
 	struct rq_iterator rt_rq_iterator;
-	unsigned long load_moved;
 
 	rt_rq_iterator.start = load_balance_start_rt;
 	rt_rq_iterator.next = load_balance_next_rt;
@@ -187,11 +185,22 @@ load_balance_rt(struct rq *this_rq, int 
 	 */
 	rt_rq_iterator.arg = busiest;
 
-	nr_moved = balance_tasks(this_rq, this_cpu, busiest, max_nr_move,
-			max_load_move, sd, idle, all_pinned, &load_moved,
-			this_best_prio, &rt_rq_iterator);
-
-	return load_moved;
+	return balance_tasks(this_rq, this_cpu, busiest, max_load_move, sd,
+			     idle, all_pinned, this_best_prio, &rt_rq_iterator);
+}
+
+static int
+move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		 struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	struct rq_iterator rt_rq_iterator;
+
+	rt_rq_iterator.start = load_balance_start_rt;
+	rt_rq_iterator.next = load_balance_next_rt;
+	rt_rq_iterator.arg = busiest;
+
+	return iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
+				  &rt_rq_iterator);
 }
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
@@ -224,6 +233,7 @@ static struct sched_class rt_sched_class
 	.put_prev_task		= put_prev_task_rt,
 
 	.load_balance		= load_balance_rt,
+	.move_one_task		= move_one_task_rt,
 
 	.task_tick		= task_tick_rt,
 };

--------------070809090602060102090609--
