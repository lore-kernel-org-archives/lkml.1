Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYF0MDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYF0MDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbYF0L6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:13 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:51816 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734AbYF0L5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:55 -0400
Message-Id: <20080627115212.348345824@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:37 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 28/30] sched: correct wakeup weight calculations
Content-Disposition: inline; filename=sched-effective_load.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rw_i = {2, 4, 1, 0}
s_i = {2/7, 4/7, 1/7, 0}

wakeup on cpu0, weight=1

rw'_i = {3, 4, 1, 0}
s'_i = {3/8, 4/8, 1/8, 0}

s_0 = S * rw_0 / \Sum rw_j ->
  \Sum rw_j = S*rw_0/s_0 = 1*2*7/2 = 7 (correct)

s'_0 = S * (rw_0 + 1) / (\Sum rw_j + 1) =
       1 * (2+1) / (7+1) = 3/8 (correct

so we find that adding 1 to cpu0 gains 5/56 in weight
if say the other cpu were, cpu1, we'd also have to calculate its 4/56 loss

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1074,10 +1074,10 @@ static inline int wake_idle(int cpu, str
 static const struct sched_class fair_sched_class;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static unsigned long effective_load(struct task_group *tg, long wl, int cpu)
+static unsigned long effective_load(struct task_group *tg, int cpu,
+		unsigned long wl, unsigned long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
-	long wg = wl;
 
 	for_each_sched_entity(se) {
 #define D(n) (likely(n) ? (n) : 1)
@@ -1092,6 +1092,13 @@ static unsigned long effective_load(stru
 		b = S*rw + s*wg;
 
 		wl = s*(a-b)/D(b);
+		/*
+		 * Assume the group is already running and will
+		 * thus already be accounted for in the weight.
+		 *
+		 * That is, moving shares between CPUs, does not
+		 * alter the group weight.
+		 */
 		wg = 0;
 #undef D
 	}
@@ -1099,26 +1106,12 @@ static unsigned long effective_load(stru
 	return wl;
 }
 
-static unsigned long task_load_sub(struct task_struct *p)
-{
-	return effective_load(task_group(p), -(long)p->se.load.weight, task_cpu(p));
-}
-
-static unsigned long task_load_add(struct task_struct *p, int cpu)
-{
-	return effective_load(task_group(p), p->se.load.weight, cpu);
-}
-
 #else
 
-static unsigned long task_load_sub(struct task_struct *p)
+static inline unsigned long effective_load(struct task_group *tg, int cpu,
+		unsigned long wl, unsigned long wg)
 {
-	return -p->se.load.weight;
-}
-
-static unsigned long task_load_add(struct task_struct *p, int cpu)
-{
-	return p->se.load.weight;
+	return wl;
 }
 
 #endif
@@ -1130,8 +1123,10 @@ wake_affine(struct rq *rq, struct sched_
 	    unsigned int imbalance)
 {
 	struct task_struct *curr = this_rq->curr;
+	struct task_group *tg;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
+	unsigned long weight;
 	int balanced;
 
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
@@ -1142,10 +1137,19 @@ wake_affine(struct rq *rq, struct sched_
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	if (sync)
-		tl += task_load_sub(current);
+	if (sync) {
+		tg = task_group(current);
+		weight = current->se.load.weight;
+
+		tl += effective_load(tg, this_cpu, -weight, -weight);
+		load += effective_load(tg, prev_cpu, 0, -weight);
+	}
+
+	tg = task_group(p);
+	weight = p->se.load.weight;
 
-	balanced = 100*(tl + task_load_add(p, this_cpu)) <= imbalance*load;
+	balanced = 100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
 	 * If the currently running task will sleep within
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -363,6 +363,10 @@ static inline void set_task_rq(struct ta
 #else
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
+static inline struct task_group *task_group(struct task_struct *p)
+{
+	return NULL;
+}
 
 #endif	/* CONFIG_GROUP_SCHED */
 

-- 

