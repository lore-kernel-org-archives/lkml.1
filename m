Return-Path: <linux-kernel-owner+w=401wt.eu-S1759366AbYF0MGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366AbYF0MGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYF0L6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:20 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:40181 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYF0L6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:07 -0400
Message-Id: <20080627115211.457521910@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:19 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/30] sched: update aggregate when holding the RQs
Content-Disposition: inline; filename=sched-agg-update-move_tasks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was observed that in __update_group_shares_cpu() 

  rq_weight > aggregate()->rq_weight

This is caused by forks/wakeups in between the initial aggregate pass and
locking of the RQs for load balance. To avoid this situation partially re-do
the aggregation once we have the RQs locked (which avoids new tasks from
appearing).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1703,6 +1703,11 @@ aggregate_get_up(struct task_group *tg, 
 	aggregate_group_set_shares(tg, cpu, sd);
 }
 
+static void
+aggregate_get_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
+{
+}
+
 static DEFINE_PER_CPU(spinlock_t, aggregate_lock);
 
 static void __init init_aggregate(void)
@@ -1722,6 +1727,11 @@ static int get_aggregate(int cpu, struct
 	return 1;
 }
 
+static void update_aggregate(int cpu, struct sched_domain *sd)
+{
+	aggregate_walk_tree(aggregate_get_down, aggregate_get_nop, cpu, sd);
+}
+
 static void put_aggregate(int cpu, struct sched_domain *sd)
 {
 	spin_unlock(&per_cpu(aggregate_lock, cpu));
@@ -1743,6 +1753,10 @@ static inline int get_aggregate(int cpu,
 	return 0;
 }
 
+static inline void update_aggregate(int cpu, struct sched_domain *sd)
+{
+}
+
 static inline void put_aggregate(int cpu, struct sched_domain *sd)
 {
 }
@@ -2180,6 +2194,12 @@ find_idlest_group(struct sched_domain *s
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
+	/*
+	 * now that we have both rqs locked the rq weight won't change
+	 * anymore - so update the stats.
+	 */
+	update_aggregate(this_cpu, sd);
+
 	do {
 		unsigned long load, avg_load;
 		int local_group;

-- 

