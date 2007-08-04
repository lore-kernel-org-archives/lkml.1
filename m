Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbXHDDjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbXHDDjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 23:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbXHDDjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 23:39:16 -0400
Received: from qsrv03sl.mx.bigpond.com ([144.140.92.183]:42041 "EHLO
	qsrv03sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762066AbXHDDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 23:39:14 -0400
Message-ID: <46B3E4FC.2010509@bigpond.net.au>
Date: Sat, 04 Aug 2007 12:31:24 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Simplify move_tasks()
Content-Type: multipart/mixed;
 boundary="------------010906030209080800060608"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta04sl.mx.bigpond.com from [124.186.206.38] using ID pwil3058@bigpond.net.au at Sat, 4 Aug 2007 02:31:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010906030209080800060608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The move_tasks() function is currently multiplexed with two distinct 
capabilities:

1. attempt to move a specified amount of weighted load from one run 
queue to another; and
2. attempt to move a specified number of tasks from one run queue to 
another.

The first of these capabilities is used in two places, load_balance() 
and load_balance_idle(), and in both of these cases the return value of 
move_tasks() is used purely to decide if tasks/load were moved and no 
notice of the actual number of tasks moved is taken.

The second capability is used in exactly one place, 
active_load_balance(), to attempt to move exactly one task and, as 
before, the return value is only used as an indicator of success or failure.

This multiplexing of sched_task() was introduced, by me, as part of the 
smpnice patches and was motivated by the fact that the alternative, one 
function to move specified load and one to move a single task, would 
have led to two functions of roughly the same complexity as the old 
move_tasks() (or the new balance_tasks()).  However, the new modular 
design of the new CFS scheduler allows a simpler solution to be adopted 
and this patch addresses that solution by:

1. adding a new function, move_one_task(), to be used by 
active_load_balance(); and
2. making move_tasks() a single purpose function that tries to move a 
specified weighted load and returns 1 for success and 0 for failure.

One of the consequences of these changes is that neither move_one_task()
or the new move_tasks() care how many tasks sched_class.load_balance() 
moves and this enables its interface to be simplified by returning the 
amount of load moved as its result and removing the load_moved pointer 
from the argument list.  This helps simplify the new move_tasks() and 
slightly reduces the amount of work done in each of 
sched_class.load_balance()'s implementations.

Further simplification, e.g. changes to balance_tasks(), are possible 
but (slightly) complicated by the special needs of load_balance_fair() 
so I've left them to a later patch (if this one gets accepted).

NB Since move_tasks() gets called with two run queue locks held even 
small reductions in overhead are worthwhile.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce

--------------010906030209080800060608
Content-Type: text/x-patch;
 name="simplify-move_tasks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="simplify-move_tasks.patch"

diff -r b97e7dab8f7b include/linux/sched.h
--- a/include/linux/sched.h	Thu Aug 02 14:08:53 2007 -0700
+++ b/include/linux/sched.h	Fri Aug 03 15:56:41 2007 +1000
@@ -866,11 +866,11 @@ struct sched_class {
 	struct task_struct * (*pick_next_task) (struct rq *rq, u64 now);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p, u64 now);
 
-	int (*load_balance) (struct rq *this_rq, int this_cpu,
+	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, unsigned long *total_load_moved);
+			int *all_pinned);
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
diff -r b97e7dab8f7b kernel/sched.c
--- a/kernel/sched.c	Thu Aug 02 14:08:53 2007 -0700
+++ b/kernel/sched.c	Sat Aug 04 10:06:42 2007 +1000
@@ -2231,32 +2231,49 @@ out:
 }
 
 /*
- * move_tasks tries to move up to max_nr_move tasks and max_load_move weighted
- * load from busiest to this_rq, as part of a balancing operation within
- * "domain". Returns the number of tasks moved.
+ * move_tasks tries to move up to max_load_move weighted load from busiest to
+ * this_rq, as part of a balancing operation within domain "sd".
+ * Returns 1 if successful and 0 otherwise.
  *
  * Called with both runqueues locked.
  */
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_nr_move, unsigned long max_load_move,
+		      unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned)
 {
 	struct sched_class *class = sched_class_highest;
-	unsigned long load_moved, total_nr_moved = 0, nr_moved;
-	long rem_load_move = max_load_move;
+	unsigned long total_load_moved = 0;
 
 	do {
-		nr_moved = class->load_balance(this_rq, this_cpu, busiest,
-				max_nr_move, (unsigned long)rem_load_move,
-				sd, idle, all_pinned, &load_moved);
-		total_nr_moved += nr_moved;
-		max_nr_move -= nr_moved;
-		rem_load_move -= load_moved;
+		total_load_moved +=
+			class->load_balance(this_rq, this_cpu, busiest,
+				ULONG_MAX, max_load_move - total_load_moved,
+				sd, idle, all_pinned);
 		class = class->next;
-	} while (class && max_nr_move && rem_load_move > 0);
-
-	return total_nr_moved;
+	} while (class && max_load_move > total_load_moved);
+
+	return total_load_moved > 0;
+}
+
+/*
+ * move_one_task tries to move exactly one task from busiest to this_rq, as
+ * part of active balancing operations within "domain".
+ * Returns 1 if successful and 0 otherwise.
+ *
+ * Called with both runqueues locked.
+ */
+static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+			 struct sched_domain *sd, enum cpu_idle_type idle)
+{
+	struct sched_class *class;
+
+	for (class = sched_class_highest; class; class = class->next)
+		if (class->load_balance(this_rq, this_cpu, busiest,
+					1, ULONG_MAX, sd, idle, NULL))
+			return 1;
+
+	return 0;
 }
 
 /*
@@ -2588,11 +2605,6 @@ find_busiest_queue(struct sched_group *g
  */
 #define MAX_PINNED_INTERVAL	512
 
-static inline unsigned long minus_1_or_zero(unsigned long n)
-{
-	return n > 0 ? n - 1 : 0;
-}
-
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -2601,7 +2613,7 @@ static int load_balance(int this_cpu, st
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance)
 {
-	int nr_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
+	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
@@ -2642,18 +2654,17 @@ redo:
 
 	schedstat_add(sd, lb_imbalance[idle], imbalance);
 
-	nr_moved = 0;
+	ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
 		 * an imbalance but busiest->nr_running <= 1, the group is
-		 * still unbalanced. nr_moved simply stays zero, so it is
+		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		nr_moved = move_tasks(this_rq, this_cpu, busiest,
-				      minus_1_or_zero(busiest->nr_running),
+		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 				      imbalance, sd, idle, &all_pinned);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
@@ -2661,7 +2672,7 @@ redo:
 		/*
 		 * some other cpu did the load balance for us.
 		 */
-		if (nr_moved && this_cpu != smp_processor_id())
+		if (ld_moved && this_cpu != smp_processor_id())
 			resched_cpu(this_cpu);
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
@@ -2673,7 +2684,7 @@ redo:
 		}
 	}
 
-	if (!nr_moved) {
+	if (!ld_moved) {
 		schedstat_inc(sd, lb_failed[idle]);
 		sd->nr_balance_failed++;
 
@@ -2722,10 +2733,10 @@ redo:
 			sd->balance_interval *= 2;
 	}
 
-	if (!nr_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
+	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		return -1;
-	return nr_moved;
+	return ld_moved;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
@@ -2757,7 +2768,7 @@ load_balance_newidle(int this_cpu, struc
 	struct sched_group *group;
 	struct rq *busiest = NULL;
 	unsigned long imbalance;
-	int nr_moved = 0;
+	int ld_moved = 0;
 	int sd_idle = 0;
 	int all_pinned = 0;
 	cpumask_t cpus = CPU_MASK_ALL;
@@ -2792,12 +2803,11 @@ redo:
 
 	schedstat_add(sd, lb_imbalance[CPU_NEWLY_IDLE], imbalance);
 
-	nr_moved = 0;
+	ld_moved = 0;
 	if (busiest->nr_running > 1) {
 		/* Attempt to move tasks */
 		double_lock_balance(this_rq, busiest);
-		nr_moved = move_tasks(this_rq, this_cpu, busiest,
-					minus_1_or_zero(busiest->nr_running),
+		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
 		spin_unlock(&busiest->lock);
@@ -2809,7 +2819,7 @@ redo:
 		}
 	}
 
-	if (!nr_moved) {
+	if (!ld_moved) {
 		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
 		if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
@@ -2817,7 +2827,7 @@ redo:
 	} else
 		sd->nr_balance_failed = 0;
 
-	return nr_moved;
+	return ld_moved;
 
 out_balanced:
 	schedstat_inc(sd, lb_balanced[CPU_NEWLY_IDLE]);
@@ -2905,8 +2915,8 @@ static void active_load_balance(struct r
 	if (likely(sd)) {
 		schedstat_inc(sd, alb_cnt);
 
-		if (move_tasks(target_rq, target_cpu, busiest_rq, 1,
-			       ULONG_MAX, sd, CPU_IDLE, NULL))
+		if (move_one_task(target_rq, target_cpu, busiest_rq,
+				  sd, CPU_IDLE))
 			schedstat_inc(sd, alb_pushed);
 		else
 			schedstat_inc(sd, alb_failed);
diff -r b97e7dab8f7b kernel/sched_fair.c
--- a/kernel/sched_fair.c	Thu Aug 02 14:08:53 2007 -0700
+++ b/kernel/sched_fair.c	Fri Aug 03 16:28:59 2007 +1000
@@ -944,11 +944,11 @@ static int cfs_rq_best_prio(struct cfs_r
 	return p->prio;
 }
 
-static int
+static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, unsigned long *total_load_moved)
+			int *all_pinned)
 {
 	struct cfs_rq *busy_cfs_rq;
 	unsigned long load_moved, total_nr_moved = 0, nr_moved;
@@ -1006,9 +1006,7 @@ load_balance_fair(struct rq *this_rq, in
 			break;
 	}
 
-	*total_load_moved = max_load_move - rem_load_move;
-
-	return total_nr_moved;
+	return max_load_move - rem_load_move;
 }
 
 /*
diff -r b97e7dab8f7b kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Thu Aug 02 14:08:53 2007 -0700
+++ b/kernel/sched_idletask.c	Fri Aug 03 16:31:09 2007 +1000
@@ -37,11 +37,11 @@ static void put_prev_task_idle(struct rq
 {
 }
 
-static int
+static unsigned long
 load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, unsigned long *total_load_moved)
+			int *all_pinned)
 {
 	return 0;
 }
diff -r b97e7dab8f7b kernel/sched_rt.c
--- a/kernel/sched_rt.c	Thu Aug 02 14:08:53 2007 -0700
+++ b/kernel/sched_rt.c	Fri Aug 03 16:25:14 2007 +1000
@@ -172,15 +172,16 @@ static struct task_struct *load_balance_
 	return p;
 }
 
-static int
+static unsigned long
 load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 			unsigned long max_nr_move, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, unsigned long *load_moved)
+			int *all_pinned)
 {
 	int this_best_prio, best_prio, best_prio_seen = 0;
 	int nr_moved;
 	struct rq_iterator rt_rq_iterator;
+	unsigned long load_moved;
 
 	best_prio = sched_find_first_bit(busiest->rt.active.bitmap);
 	this_best_prio = sched_find_first_bit(this_rq->rt.active.bitmap);
@@ -203,11 +204,11 @@ load_balance_rt(struct rq *this_rq, int 
 	rt_rq_iterator.arg = busiest;
 
 	nr_moved = balance_tasks(this_rq, this_cpu, busiest, max_nr_move,
-			max_load_move, sd, idle, all_pinned, load_moved,
+			max_load_move, sd, idle, all_pinned, &load_moved,
 			this_best_prio, best_prio, best_prio_seen,
 			&rt_rq_iterator);
 
-	return nr_moved;
+	return load_moved;
 }
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)

--------------010906030209080800060608--
