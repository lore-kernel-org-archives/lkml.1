Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZLQS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZLQS7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZLQS6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:58:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:60915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZLQS6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:58:51 -0500
Message-Id: <20091217185430.347235894@chello.nl>
References: <20091217185021.684424629@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 19:50:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/6] sched: Remove the sched_class load_balance methods
Content-Disposition: inline; filename=sched-lb-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take out the sched_class methods for load-balancing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h   |    8 -----
 kernel/sched.c          |   26 ------------------
 kernel/sched_fair.c     |   66 ++++++++++++++++++++++++++----------------------
 kernel/sched_idletask.c |   21 ---------------
 kernel/sched_rt.c       |   20 --------------
 5 files changed, 37 insertions(+), 104 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1087,14 +1087,6 @@ struct sched_class {
 #ifdef CONFIG_SMP
 	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
-	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
-			struct rq *busiest, unsigned long max_load_move,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, int *this_best_prio);
-
-	int (*move_one_task) (struct rq *this_rq, int this_cpu,
-			      struct rq *busiest, struct sched_domain *sd,
-			      enum cpu_idle_type idle);
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1392,32 +1392,6 @@ static const u32 prio_to_wmult[40] = {
  /*  15 */ 119304647, 148102320, 186737708, 238609294, 286331153,
 };
 
-static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
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
-#ifdef CONFIG_SMP
-static unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator);
-
-static int
-iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle,
-		   struct rq_iterator *iterator);
-#endif
-
 /* Time spent by the tasks of the cpu accounting group executing in ... */
 enum cpuacct_stat_index {
 	CPUACCT_STAT_USER,	/* ... user mode */
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1851,6 +1851,24 @@ static struct task_struct *load_balance_
 	return __load_balance_iterator(cfs_rq, cfs_rq->balance_iterator);
 }
 
+/*
+ * runqueue iterator, to support SMP load-balancing between different
+ * scheduling classes, without having to expose their internal data
+ * structures to the load-balancing proper:
+ */
+struct rq_iterator {
+	void *arg;
+	struct task_struct *(*start)(void *);
+	struct task_struct *(*next)(void *);
+};
+
+static unsigned long
+balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		unsigned long max_load_move, struct sched_domain *sd,
+		enum cpu_idle_type idle, int *all_pinned,
+		int *this_best_prio, struct rq_iterator *iterator);
+
+
 static unsigned long
 __load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		unsigned long max_load_move, struct sched_domain *sd,
@@ -1929,8 +1947,20 @@ load_balance_fair(struct rq *this_rq, in
 #endif
 
 static int
-move_one_task_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle)
+iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
+		struct sched_domain *sd, enum cpu_idle_type idle,
+		struct rq_iterator *iterator);
+
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
 {
 	struct cfs_rq *busy_cfs_rq;
 	struct rq_iterator cfs_rq_iterator;
@@ -2094,16 +2124,15 @@ static int move_tasks(struct rq *this_rq
 		      struct sched_domain *sd, enum cpu_idle_type idle,
 		      int *all_pinned)
 {
-	const struct sched_class *class = sched_class_highest;
-	unsigned long total_load_moved = 0;
+	unsigned long total_load_moved = 0, load_moved;
 	int this_best_prio = this_rq->curr->prio;
 
 	do {
-		total_load_moved +=
-			class->load_balance(this_rq, this_cpu, busiest,
+		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
 				sd, idle, all_pinned, &this_best_prio);
-		class = class->next;
+
+		total_load_moved += load_moved;
 
 #ifdef CONFIG_PREEMPT
 		/*
@@ -2114,7 +2143,7 @@ static int move_tasks(struct rq *this_rq
 		if (idle == CPU_NEWLY_IDLE && this_rq->nr_running)
 			break;
 #endif
-	} while (class && max_load_move > total_load_moved);
+	} while (load_moved && max_load_move > total_load_moved);
 
 	return total_load_moved > 0;
 }
@@ -2145,25 +2174,6 @@ iter_move_one_task(struct rq *this_rq, i
 	return 0;
 }
 
-/*
- * move_one_task tries to move exactly one task from busiest to this_rq, as
- * part of active balancing operations within "domain".
- * Returns 1 if successful and 0 otherwise.
- *
- * Called with both runqueues locked.
- */
-static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-			 struct sched_domain *sd, enum cpu_idle_type idle)
-{
-	const struct sched_class *class;
-
-	for_each_class(class) {
-		if (class->move_one_task(this_rq, this_cpu, busiest, sd, idle))
-			return 1;
-	}
-
-	return 0;
-}
 /********** Helpers for find_busiest_group ************************/
 /*
  * sd_lb_stats - Structure to store the statistics of a sched_domain
@@ -3873,8 +3883,6 @@ static const struct sched_class fair_sch
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_fair,
 
-	.load_balance		= load_balance_fair,
-	.move_one_task		= move_one_task_fair,
 	.rq_online		= rq_online_fair,
 	.rq_offline		= rq_offline_fair,
 
Index: linux-2.6/kernel/sched_idletask.c
===================================================================
--- linux-2.6.orig/kernel/sched_idletask.c
+++ linux-2.6/kernel/sched_idletask.c
@@ -44,24 +44,6 @@ static void put_prev_task_idle(struct rq
 {
 }
 
-#ifdef CONFIG_SMP
-static unsigned long
-load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
-{
-	return 0;
-}
-
-static int
-move_one_task_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle)
-{
-	return 0;
-}
-#endif
-
 static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
 {
 }
@@ -119,9 +101,6 @@ static const struct sched_class idle_sch
 
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_idle,
-
-	.load_balance		= load_balance_idle,
-	.move_one_task		= move_one_task_idle,
 #endif
 
 	.set_curr_task          = set_curr_task_idle,
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1481,24 +1481,6 @@ static void task_woken_rt(struct rq *rq,
 		push_rt_tasks(rq);
 }
 
-static unsigned long
-load_balance_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		unsigned long max_load_move,
-		struct sched_domain *sd, enum cpu_idle_type idle,
-		int *all_pinned, int *this_best_prio)
-{
-	/* don't touch RT tasks */
-	return 0;
-}
-
-static int
-move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		 struct sched_domain *sd, enum cpu_idle_type idle)
-{
-	/* don't touch RT tasks */
-	return 0;
-}
-
 static void set_cpus_allowed_rt(struct task_struct *p,
 				const struct cpumask *new_mask)
 {
@@ -1746,8 +1728,6 @@ static const struct sched_class rt_sched
 #ifdef CONFIG_SMP
 	.select_task_rq		= select_task_rq_rt,
 
-	.load_balance		= load_balance_rt,
-	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
 	.rq_online              = rq_online_rt,
 	.rq_offline             = rq_offline_rt,

-- 

