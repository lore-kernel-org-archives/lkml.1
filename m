Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXK0E6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXK0E6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 23:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXK0E6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 23:58:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46693 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbXK0E6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 23:58:11 -0500
Date: Tue, 27 Nov 2007 10:41:03 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       skumar@linux.vnet.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       Dipankar <dipankar@in.ibm.com>
Subject: [Patch 3/5 v1] sched: change how cpu load is calculated
Message-ID: <20071127051103.GD20083@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071119123051.GC28777@linux.vnet.ibm.com> <20071119131201.GB31491@elte.hu> <20071119150312.GA2365@linux.vnet.ibm.com> <20071119152258.GB31426@elte.hu> <20071119160647.GV3359@linux.vnet.ibm.com> <20071119190057.GA12650@elte.hu> <20071126050044.GA5304@linux.vnet.ibm.com> <20071126050905.GF5304@linux.vnet.ibm.com> <20071126202836.GA17012@elte.hu> <20071127050652.GA20083@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127050652.GA20083@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes how the cpu load exerted by fair_sched_class tasks
is calculated. Load exerted by fair_sched_class tasks on a cpu is now a
summation of the group weights, rather than summation of task weights.
Weight exerted by a group on a cpu is dependent on the shares allocated
to it.

This version of patch (v1 of Patch 3/5) has zero impact for
!CONFIG_FAIR_GROUP_SCHED case.

Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>


---
 kernel/sched.c      |   38 ++++++++++++++++++++++++++++++--------
 kernel/sched_fair.c |   31 +++++++++++++++++++++++++++----
 kernel/sched_rt.c   |    2 ++
 3 files changed, 59 insertions(+), 12 deletions(-)

Index: current/kernel/sched.c
===================================================================
--- current.orig/kernel/sched.c
+++ current/kernel/sched.c
@@ -870,15 +870,25 @@ iter_move_one_task(struct rq *this_rq, i
 		   struct rq_iterator *iterator);
 #endif
 
-#include "sched_stats.h"
-#include "sched_idletask.c"
-#include "sched_fair.c"
-#include "sched_rt.c"
-#ifdef CONFIG_SCHED_DEBUG
-# include "sched_debug.c"
-#endif
+#ifdef CONFIG_FAIR_GROUP_SCHED
 
-#define sched_class_highest (&rt_sched_class)
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
+static inline void inc_load(struct rq *rq, const struct task_struct *p) { }
+static inline void dec_load(struct rq *rq, const struct task_struct *p) { }
+
+#else	/* CONFIG_FAIR_GROUP_SCHED */
+
+static inline void inc_cpu_load(struct rq *rq, unsigned long load) { }
+static inline void dec_cpu_load(struct rq *rq, unsigned long load) { }
 
 static inline void inc_load(struct rq *rq, const struct task_struct *p)
 {
@@ -890,6 +900,18 @@ static inline void dec_load(struct rq *r
 	update_load_sub(&rq->load, p->se.load.weight);
 }
 
+#endif	/* CONFIG_FAIR_GROUP_SCHED */
+
+#include "sched_stats.h"
+#include "sched_idletask.c"
+#include "sched_fair.c"
+#include "sched_rt.c"
+#ifdef CONFIG_SCHED_DEBUG
+# include "sched_debug.c"
+#endif
+
+#define sched_class_highest (&rt_sched_class)
+
 static void inc_nr_running(struct task_struct *p, struct rq *rq)
 {
 	rq->nr_running++;
Index: current/kernel/sched_fair.c
===================================================================
--- current.orig/kernel/sched_fair.c
+++ current/kernel/sched_fair.c
@@ -755,15 +755,26 @@ static inline struct sched_entity *paren
 static void enqueue_task_fair(struct rq *rq, struct task_struct *p, int wakeup)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se;
+	struct sched_entity *se = &p->se, *topse = NULL;
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
+	/*
+	 * Increment cpu load if we just enqueued the first task of a group on
+	 * 'rq->cpu'. 'topse' represents the group to which task 'p' belongs
+	 * at the highest grouping level.
+	 */
+	if (incload)
+		inc_cpu_load(rq, topse->load.weight);
 }
 
 /*
@@ -774,16 +785,28 @@ static void enqueue_task_fair(struct rq 
 static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct cfs_rq *cfs_rq;
-	struct sched_entity *se = &p->se;
+	struct sched_entity *se = &p->se, *topse = NULL;
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
+	/*
+	 * Decrement cpu load if we just dequeued the last task of a group on
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
@@ -31,6 +31,7 @@ static void enqueue_task_rt(struct rq *r
 
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+	inc_cpu_load(rq, p->se.load.weight);
 }
 
 /*
@@ -45,6 +46,7 @@ static void dequeue_task_rt(struct rq *r
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*

-- 
Regards,
vatsa
