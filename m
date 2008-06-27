Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYF0MJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYF0MJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYF0L6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:31 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:37421 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbYF0L5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:54 -0400
Message-Id: <20080627115211.799975306@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 17/30] sched: persistent average load per task
Content-Disposition: inline; filename=sched-avg_load_per_task.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the fall-back to SCHED_LOAD_SCALE by remembering the previous value of
cpu_avg_load_per_task() - this is useful because of the hierarchical group
model in which task weight can be much smaller.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -554,6 +554,8 @@ struct rq {
 	int cpu;
 	int online;
 
+	unsigned long avg_load_per_task;
+
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
 #endif
@@ -1427,9 +1429,18 @@ static inline void dec_cpu_load(struct r
 #ifdef CONFIG_SMP
 static unsigned long source_load(int cpu, int type);
 static unsigned long target_load(int cpu, int type);
-static unsigned long cpu_avg_load_per_task(int cpu);
 static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
 
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->nr_running)
+		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+
+	return rq->avg_load_per_task;
+}
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
@@ -2011,18 +2022,6 @@ static unsigned long target_load(int cpu
 }
 
 /*
- * Return the average load per task on the cpu's run queue
- */
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-	unsigned long total = weighted_cpuload(cpu);
-	unsigned long n = rq->nr_running;
-
-	return n ? total / n : SCHED_LOAD_SCALE;
-}
-
-/*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
  */

-- 

