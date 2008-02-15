Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbYBOLXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbYBOLXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760279AbYBOLWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:22:54 -0500
Received: from viefep32-int.chello.at ([62.179.121.50]:44481 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbYBOLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:22:52 -0500
Message-Id: <20080215112055.571410000@chello.nl>
References: <20080215111819.978881000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:18:21 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: fair: virtual deadline scheduling
Content-Disposition: inline; filename=sched-fair-deadline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change CFS into a virtual deadline scheduler.

By flattening the grouping hierarchy into a single level we now end up with
tasks that have varying latency requirements. Tasks from group A might have a
larger latency period than those from group B as the period depends on the
number of runnable tasks within a group.

The current scheduling criteria does not take that into account - it assumes a
single latency period. In order to accommodate these varying latencies in the
scheduling decision, move to EDF [*] scheduling. We treat the tasks need + its
latency period as the deadline it has to meet. This includes the latency into
the scheduling decision.

[*] - EDF is correct up until load 1, after that it is not a closed system so
improvement is possible here. It is usable because the system strives to
generate the load 1 situation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    1 +
 kernel/sched_fair.c   |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -925,6 +925,7 @@ struct sched_entity {
 	u64			exec_start;
 	u64			sum_exec_runtime;
 	u64			vruntime;
+	u64			vperiod;
 	u64			prev_sum_exec_runtime;
 
 #ifdef CONFIG_SCHEDSTATS
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -220,9 +220,11 @@ static inline u64 min_vruntime(u64 min_v
 
 static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return se->vruntime - cfs_rq->min_vruntime;
+	return se->vruntime + se->vperiod - cfs_rq->min_vruntime;
 }
 
+static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se);
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -240,6 +242,8 @@ static void __enqueue_entity(struct cfs_
 	if (se == cfs_rq->curr)
 		return;
 
+	se->vperiod = sched_vslice_add(cfs_rq, se);
+
 	cfs_rq = &rq_of(cfs_rq)->cfs;
 
 	link = &cfs_rq->tasks_timeline.rb_node;

--

