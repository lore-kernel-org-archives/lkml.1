Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYF0MBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYF0MBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756461AbYF0L6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:03 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:20908 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115212.397950477@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 29/30] sched: incremental effective_load()
Content-Disposition: inline; filename=sched-incremental-wake_affine.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the accuracy of the effective_load values.

Not only consider the current increment (as per the attempted wakeup), but
also consider the delta between when we last adjusted the shares and the
current situation.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c      |    6 ++++++
 kernel/sched_fair.c |   18 +++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1074,10 +1074,22 @@ static inline int wake_idle(int cpu, str
 static const struct sched_class fair_sched_class;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static unsigned long effective_load(struct task_group *tg, int cpu,
-		unsigned long wl, unsigned long wg)
+static long effective_load(struct task_group *tg, int cpu,
+		long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
+	long more_w;
+
+	if (!tg->parent)
+		return wl;
+
+	/*
+	 * Instead of using this increment, also add the difference
+	 * between when the shares were last updated and now.
+	 */
+	more_w = se->my_q->load.weight - se->my_q->rq_weight;
+	wl += more_w;
+	wg += more_w;
 
 	for_each_sched_entity(se) {
 #define D(n) (likely(n) ? (n) : 1)
@@ -1086,7 +1098,7 @@ static unsigned long effective_load(stru
 
 		S = se->my_q->tg->shares;
 		s = se->my_q->shares;
-		rw = se->my_q->load.weight;
+		rw = se->my_q->rq_weight;
 
 		a = S*(rw + wl);
 		b = S*rw + s*wg;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -427,6 +427,11 @@ struct cfs_rq {
 	 * this cpu's part of tg->shares
 	 */
 	unsigned long shares;
+
+	/*
+	 * load.weight at the time we set shares
+	 */
+	unsigned long rq_weight;
 #endif
 #endif
 };
@@ -1527,6 +1532,7 @@ __update_group_shares_cpu(struct task_gr
 	 * record the actual number of shares, not the boosted amount.
 	 */
 	tg->cfs_rq[cpu]->shares = boost ? 0 : shares;
+	tg->cfs_rq[cpu]->rq_weight = rq_weight;
 
 	if (shares < MIN_SHARES)
 		shares = MIN_SHARES;

-- 

