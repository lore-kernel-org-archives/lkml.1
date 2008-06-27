Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYF0MHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYF0MHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbYF0L6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:25 -0400
Received: from viefep26-int.chello.at ([62.179.121.46]:2680 "EHLO
	viefep26-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbYF0L6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:08 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115211.310911560@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/30] sched: fix wakeup granularity and buddy granularity
Content-Disposition: inline; filename=sched-fix-buddy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncouple buddy selection from wakeup granularity.

The initial idea was that buddies could run ahead as far as a normal task
can - do this by measuring a pair 'slice' just as we do for a normal task.

This means we can drop the wakeup_granularity back to 5ms.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c      |    1 +
 kernel/sched_fair.c |   11 +++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-05-12 00:42:40.000000000 +0200
+++ linux-2.6/kernel/sched.c	2008-05-12 00:43:54.000000000 +0200
@@ -370,6 +370,7 @@
 
 	u64 exec_clock;
 	u64 min_vruntime;
+	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c	2008-05-12 00:42:41.000000000 +0200
+++ linux-2.6/kernel/sched_fair.c	2008-05-12 00:47:05.000000000 +0200
@@ -63,13 +63,13 @@ unsigned int __read_mostly sysctl_sched_
 
 /*
  * SCHED_OTHER wake-up granularity.
- * (default: 10 msec * (1 + ilog(ncpus)), units: nanoseconds)
+ * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
  *
  * This option delays the preemption effects of decoupled workloads
  * and reduces their over-scheduling. Synchronous workloads will still
  * have immediate wakeup/sleep latencies.
  */
-unsigned int sysctl_sched_wakeup_granularity = 10000000UL;
+unsigned int sysctl_sched_wakeup_granularity = 5000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
 
@@ -787,17 +787,16 @@
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
-
 static struct sched_entity *
 pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (!cfs_rq->next)
-		return se;
+	struct rq *rq = rq_of(cfs_rq);
+	u64 pair_slice = rq->clock - cfs_rq->pair_start;
 
-	if (wakeup_preempt_entity(cfs_rq->next, se) != 0)
+	if (!cfs_rq->next || pair_slice > sched_slice(cfs_rq, cfs_rq->next)) {
+		cfs_rq->pair_start = rq->clock;
 		return se;
+	}
 
 	return cfs_rq->next;
 }

-- 

