Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbXKZExm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbXKZExm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 23:53:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXKZExd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 23:53:33 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47560 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbXKZExc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 23:53:32 -0500
Date: Mon, 26 Nov 2007 10:36:25 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [Patch 3/4 v2] sched: change how cpu load is calculated
Message-ID: <20071126050625.GE5304@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119122713.GA28777@linux.vnet.ibm.com> <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126050044.GA5304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch changes how the cpu load exerted by fair_sched_class tasks
is calculated. Load exerted by fair_sched_class tasks on a cpu is now a
summation of the group weights, rather than summation of task weights.
Weight exerted by a group on a cpu is dependent on the shares allocated
to it.

This version of patch (v2 of Patch 3/4) has a minor impact on code size
(but should have no runtime/functional impact) for !CONFIG_FAIR_GROUP_SCHED 
case, but the overall code, IMHO, is neater compared to v1 of Patch 3/4
(because of lesser #ifdefs).

I prefer v2 of Patch 3/4.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

---
 kernel/sched.c      |   27 +++++++++++----------------
 kernel/sched_fair.c |   31 +++++++++++++++++++++++++++----
 kernel/sched_rt.c   |    2 ++
 3 files changed, 40 insertions(+), 20 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -869,6 +869,16 @@
 		   struct rq_iterator *iterator);
 #endif
 
+static inline void inc_cpu_load(struct rq *rq, unsigned long load)
+{
+	update_load_add(&rq->load, load);
+}
+
+static inline void dec_cpu_load(struct rq *rq, unsigned long load)
+{
+	update_load_sub(&rq->load, load);
+}
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -879,26 +889,14 @@
 
 #define sched_class_highest (&rt_sched_class)
 
-static inline void inc_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_add(&rq->load, p->se.load.weight);
-}
-
-static inline void dec_load(struct rq *rq, const struct task_struct *p)
-{
-	update_load_sub(&rq->load, p->se.load.weight);
-}
-
 static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running++;
-	inc_load(rq, p);
 }
 
 static void dec_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running--;
-	dec_load(rq, p);
 }
 
 static void set_load_weight(struct task_struct *p)
@@ -4070,10 +4068,8 @@
 		goto out_unlock;
 	}
 	on_rq = p->se.on_rq;
-	if (on_rq) {
+	if (on_rq)
 		dequeue_task(rq, p, 0);
-		dec_load(rq, p);
-	}
 
 	p->static_prio = NICE_TO_PRIO(nice);
 	set_load_weight(p);
@@ -4083,7 +4079,6 @@
 
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		inc_load(rq, p);
 		/*
 		 * If the task increased its priority or is running and
 		 * lowered its priority, then reschedule its CPU:
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -755,15 +755,26 @@
 static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se;
+	struct sched_entity *se = &p->se,
+			    *topse = NULL;	/* Highest schedulable entity */
+	int incload = 1;
 
 	for_each_sched_entity(se) {
-		if (se->on_rq)
+		topse = se;
+		if (se->on_rq) {
+			incload = 0;
 			break;
+		}
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, wakeup);
 		wakeup = 1;
 	}
+	/* Increment cpu load if we just enqueued the first task of a group on
+	 * 'rq->cpu'. 'topse' represents the group to which task 'p' belongs
+	 * at the highest grouping level.
+	 */
+	if (incload)
+		inc_cpu_load(rq, topse->load.weight);
 }
 
 /*
@@ -774,16 +785,28 @@
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se;
+	struct sched_entity *se = &p->se,
+			    *topse = NULL; 	/* Highest schedulable entity */
+	int decload = 1;
 
 	for_each_sched_entity(se) {
+		topse = se;
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, sleep);
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			if (parent_entity(se))
+				decload = 0;
 			break;
+		}
 		sleep = 1;
 	}
+	/* Decrement cpu load if we just dequeued the last task of a group on
+	 * 'rq->cpu'. 'topse' represents the group to which task 'p' belongs
+	 * at the highest grouping level.
+	 */
+	if (decload)
+		dec_cpu_load(rq, topse->load.weight);
 }
 
 /*
Index: current/kernel/sched_rt.c
===================================================================
--- current.orig/kernel/sched_rt.c
+++ current/kernel/sched_rt.c
@@ -31,6 +31,7 @@
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+	inc_cpu_load(rq, p->se.load.weight);
 }
 
 /*
@@ -45,6 +46,7 @@
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*

-- 
Regards,
vatsa
