Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbYF0MBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbYF0MBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbYF0L6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:01 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:22625 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYF0L5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:54 -0400
X-SourceIP: 62.163.52.83
Message-Id: <20080627115211.998006060@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:30 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 21/30] sched: fix task_h_load()
Content-Disposition: inline; filename=sched-fix-task_h_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently task_h_load() computes the load of a task and uses that to either
subtract it from the total, or add to it.

However, removing or adding a task need not have any effect on the total load
at all. Imagine adding a task to a group that is local to one cpu - in that
case the total load of that cpu is unaffected.

So properly compute addition/removal:

 s_i = S * rw_i / \Sum_j rw_j
 s'_i = S * (rw_i + wl) / (\Sum_j rw_j + wg)

then s'_i - s_i gives the change in load.

Where s_i is the shares for cpu i, S the group weight, rw_i the runqueue weight
for that cpu, wl the weight we add (subtract) and wg the weight contribution to
the runqueue.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched_fair.c |   49 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1071,22 +1071,53 @@ static inline int wake_idle(int cpu, str
 static const struct sched_class fair_sched_class;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static unsigned long task_h_load(struct task_struct *p)
+static unsigned long effective_load(struct task_group *tg, long wl, int cpu)
 {
-	unsigned long h_load = p->se.load.weight;
-	struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
+	struct sched_entity *se = tg->se[cpu];
+	long wg = wl;
 
-	update_h_load(task_cpu(p));
+	for_each_sched_entity(se) {
+#define D(n) (likely(n) ? (n) : 1)
+
+		long S, Srw, rw, s, sn;
+
+		S = se->my_q->tg->shares;
+		s = se->my_q->shares;
+		rw = se->my_q->load.weight;
 
-	h_load = calc_delta_mine(h_load, cfs_rq->h_load, &cfs_rq->load);
+		Srw = S * rw / D(s);
+		sn = S * (rw + wl) / D(Srw + wg);
+
+		wl = sn - s;
+		wg = 0;
+#undef D
+	}
 
-	return h_load;
+	return wl;
 }
+
+static unsigned long task_load_sub(struct task_struct *p)
+{
+	return effective_load(task_group(p), -(long)p->se.load.weight, task_cpu(p));
+}
+
+static unsigned long task_load_add(struct task_struct *p, int cpu)
+{
+	return effective_load(task_group(p), p->se.load.weight, cpu);
+}
+
 #else
-static unsigned long task_h_load(struct task_struct *p)
+
+static unsigned long task_load_sub(struct task_struct *p)
+{
+	return -p->se.load.weight;
+}
+
+static unsigned long task_load_add(struct task_struct *p, int cpu)
 {
 	return p->se.load.weight;
 }
+
 #endif
 
 static int
@@ -1109,9 +1140,9 @@ wake_affine(struct rq *rq, struct sched_
 	 * of the current CPU:
 	 */
 	if (sync)
-		tl -= task_h_load(current);
+		tl += task_load_sub(current);
 
-	balanced = 100*(tl + task_h_load(p)) <= imbalance*load;
+	balanced = 100*(tl + task_load_add(p, this_cpu)) <= imbalance*load;
 
 	/*
 	 * If the currently running task will sleep within

-- 

