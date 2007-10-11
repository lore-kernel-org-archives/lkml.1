Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbXJKGgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbXJKGgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbXJKGgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:36:42 -0400
Received: from qsrv03ps.mx.bigpond.com ([144.140.82.183]:19737 "EHLO
	qsrv03ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXJKGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:36:41 -0400
X-Greylist: delayed 22014 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 02:36:40 EDT
Message-ID: <470D6E76.3070604@bigpond.net.au>
Date: Thu, 11 Oct 2007 10:29:42 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Exclude SMP code from non SMP builds
Content-Type: multipart/mixed;
 boundary="------------030409070105080708010504"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [121.222.199.46] using ID pwil3058@bigpond.net.au at Thu, 11 Oct 2007 00:29:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030409070105080708010504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

At the moment, a lot of load balancing code that is irrelevant to non 
SMP systems gets included during non SMP builds.

This patch addresses this issue and should reduce the binary size on non 
SMP systems.

This patch assumes that the "sched: Reduce overhead in balance_tasks()" 
(non urgent) patch that I sent on the 15th of August has been applied.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
     -- Ambrose Bierce




--------------030409070105080708010504
Content-Type: text/x-patch;
 name="isolate-sched-smp-code.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="isolate-sched-smp-code.patch"

diff -r df69cb019596 include/linux/sched.h
--- a/include/linux/sched.h	Thu Aug 16 12:12:18 2007 +1000
+++ b/include/linux/sched.h	Fri Aug 17 13:54:28 2007 +1000
@@ -864,6 +864,7 @@ struct sched_class {
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
+#ifdef CONFIG_SMP
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
@@ -872,6 +873,7 @@ struct sched_class {
 	int (*move_one_task) (struct rq *this_rq, int this_cpu,
 			      struct rq *busiest, struct sched_domain *sd,
 			      enum cpu_idle_type idle);
+#endif
 
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
diff -r df69cb019596 kernel/sched.c
--- a/kernel/sched.c	Thu Aug 16 12:12:18 2007 +1000
+++ b/kernel/sched.c	Fri Aug 17 16:03:11 2007 +1000
@@ -764,23 +764,6 @@ iter_move_one_task(struct rq *this_rq, i
 iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		   struct sched_domain *sd, enum cpu_idle_type idle,
 		   struct rq_iterator *iterator);
-#else
-static inline unsigned long
-balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
-	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct rq_iterator *iterator)
-{
-	return 0;
-}
-
-static inline int
-iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		   struct sched_domain *sd, enum cpu_idle_type idle,
-		   struct rq_iterator *iterator)
-{
-	return 0;
-}
 #endif
 
 #include "sched_stats.h"
diff -r df69cb019596 kernel/sched_fair.c
--- a/kernel/sched_fair.c	Thu Aug 16 12:12:18 2007 +1000
+++ b/kernel/sched_fair.c	Fri Aug 17 16:00:21 2007 +1000
@@ -887,6 +887,7 @@ static void put_prev_task_fair(struct rq
 	}
 }
 
+#ifdef CONFIG_SMP
 /**************************************************
  * Fair scheduling class load-balancing methods:
  */
@@ -1004,6 +1005,7 @@ move_one_task_fair(struct rq *this_rq, i
 
 	return 0;
 }
+#endif
 
 /*
  * scheduler tick hitting a task of our scheduling class:
@@ -1090,8 +1092,10 @@ struct sched_class fair_sched_class __re
 	.pick_next_task		= pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
 
+#ifdef CONFIG_SMP
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
+#endif
 
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
diff -r df69cb019596 kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Thu Aug 16 12:12:18 2007 +1000
+++ b/kernel/sched_idletask.c	Fri Aug 17 15:58:59 2007 +1000
@@ -37,6 +37,7 @@ static void put_prev_task_idle(struct rq
 {
 }
 
+#ifdef CONFIG_SMP
 static unsigned long
 load_balance_idle(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -52,6 +53,7 @@ move_one_task_idle(struct rq *this_rq, i
 {
 	return 0;
 }
+#endif
 
 static void task_tick_idle(struct rq *rq, struct task_struct *curr)
 {
@@ -71,8 +73,10 @@ static struct sched_class idle_sched_cla
 	.pick_next_task		= pick_next_task_idle,
 	.put_prev_task		= put_prev_task_idle,
 
+#ifdef CONFIG_SMP
 	.load_balance		= load_balance_idle,
 	.move_one_task		= move_one_task_idle,
+#endif
 
 	.task_tick		= task_tick_idle,
 	/* no .task_new for idle tasks */
diff -r df69cb019596 kernel/sched_rt.c
--- a/kernel/sched_rt.c	Thu Aug 16 12:12:18 2007 +1000
+++ b/kernel/sched_rt.c	Fri Aug 17 15:53:20 2007 +1000
@@ -98,6 +98,7 @@ static void put_prev_task_rt(struct rq *
 	p->se.exec_start = 0;
 }
 
+#ifdef CONFIG_SMP
 /*
  * Load-balancing iterator. Note: while the runqueue stays locked
  * during the whole iteration, the current task might be
@@ -202,6 +203,7 @@ move_one_task_rt(struct rq *this_rq, int
 	return iter_move_one_task(this_rq, this_cpu, busiest, sd, idle,
 				  &rt_rq_iterator);
 }
+#endif
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
@@ -232,8 +234,10 @@ static struct sched_class rt_sched_class
 	.pick_next_task		= pick_next_task_rt,
 	.put_prev_task		= put_prev_task_rt,
 
+#ifdef CONFIG_SMP
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
+#endif
 
 	.task_tick		= task_tick_rt,
 };

--------------030409070105080708010504--
