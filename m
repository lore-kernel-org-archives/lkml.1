Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbYF0MEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbYF0MEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbYF0L6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:19 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:44590 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628AbYF0L6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:58:06 -0400
Message-Id: <20080627115211.850085065@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 18/30] sched: hierarchical load vs affine wakeups
Content-Disposition: inline; filename=sched-wake_affine.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With hierarchical grouping we can't just compare task weight to rq weight - we
need to scale the weight appropriately.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1071,6 +1071,25 @@ static inline int wake_idle(int cpu, str
 
 static const struct sched_class fair_sched_class;
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static unsigned long task_h_load(struct task_struct *p)
+{
+	unsigned long h_load = p->se.load.weight;
+	struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
+
+	update_h_load(task_cpu(p));
+
+	h_load = calc_delta_mine(h_load, cfs_rq->h_load, &cfs_rq->load);
+
+	return h_load;
+}
+#else
+static unsigned long task_h_load(struct task_struct *p)
+{
+	return p->se.load.weight;
+}
+#endif
+
 static int
 wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
@@ -1091,9 +1110,9 @@ wake_affine(struct rq *rq, struct sched_
 	 * of the current CPU:
 	 */
 	if (sync)
-		tl -= current->se.load.weight;
+		tl -= task_h_load(current);
 
-	balanced = 100*(tl + p->se.load.weight) <= imbalance*load;
+	balanced = 100*(tl + task_h_load(p)) <= imbalance*load;
 
 	/*
 	 * If the currently running task will sleep within

-- 

