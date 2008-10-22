Return-Path: <linux-kernel-owner+w=401wt.eu-S1759167AbYJVRt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbYJVRt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758504AbYJVRiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:38:17 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:48424 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbYJVRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:38:14 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/4] pending scheduler updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224671528.7511.11.camel@marge.simson.net>
References: <20081017172701.047939625@chello.nl>
	 <20081020120538.GD10594@elte.hu>
	 <20081021173529.GG11679@linux.vnet.ibm.com>
	 <20081022094019.GG12453@elte.hu>
	 <1224669821.6871.16.camel@marge.simson.net>
	 <1224671528.7511.11.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 19:38:14 +0200
Message-Id: <1224697094.20069.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 12:32 +0200, Mike Galbraith wrote:
> On Wed, 2008-10-22 at 12:03 +0200, Mike Galbraith wrote:
> 
> > It has positive effects too, but IMHO, the bad outweigh the good.
> 
> BTW, most dramatic on the other end of the spectrum is pgsql+oltp.  With
> preemption as is, it collapses as load climbs to heavy with preemption
> knobs at stock.  Postgres uses user-land spinlocks and _appears_ to wake
> others while these are still held.  For this load, there is such a thing
> as too much short-term fairness, preempting lock holder creates nasty
> gaggle of contended lock spinners.  It's curable with knobs, and I think
> it's postgres's own fault, but may be wrong.
> 
> With that patch, pgsql+oltp scales perfectly.

Are we talking about this patch, which re-instates the vruntime based
wakeup-preemption ?

---
Subject: sched: fix wakeup preemption
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 92 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -143,6 +143,49 @@ static inline struct sched_entity *paren
 	return se->parent;
 }
 
+/* return depth at which a sched entity is present in the hierarchy */
+static inline int depth_se(struct sched_entity *se)
+{
+	int depth = 0;
+
+	for_each_sched_entity(se)
+		depth++;
+
+	return depth;
+}
+
+static void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+	int se_depth, pse_depth;
+
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks until we find their ancestors who are siblings of common
+	 * parent.
+	 */
+
+	/* First walk up until both entities are at same depth */
+	se_depth = depth_se(*se);
+	pse_depth = depth_se(*pse);
+
+	while (se_depth > pse_depth) {
+		se_depth--;
+		*se = parent_entity(*se);
+	}
+
+	while (pse_depth > se_depth) {
+		pse_depth--;
+		*pse = parent_entity(*pse);
+	}
+
+	while (!is_same_group(*se, *pse)) {
+		*se = parent_entity(*se);
+		*pse = parent_entity(*pse);
+	}
+}
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -193,6 +236,11 @@ static inline struct sched_entity *paren
 	return NULL;
 }
 
+static inline void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -1244,13 +1292,42 @@ static unsigned long wakeup_gran(struct 
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	if (sched_feat(ASYM_GRAN))
-		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
+	if (!sched_feat(ASYM_GRAN) || se->load.weight > NICE_0_LOAD)
+		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
 
 /*
+ * Should 'se' preempt 'curr'.
+ *
+ *             |s1
+ *        |s2
+ *   |s3
+ *         g
+ *      |<--->|c
+ *
+ *  w(c, s1) = -1
+ *  w(c, s2) =  0
+ *  w(c, s3) =  1
+ *
+ */
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
+{
+	s64 gran, vdiff = curr->vruntime - se->vruntime;
+
+	if (vdiff < 0)
+		return -1;
+
+	gran = wakeup_gran(curr);
+	if (vdiff > gran)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
@@ -1258,7 +1335,6 @@ static void check_preempt_wakeup(struct 
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
-	s64 delta_exec;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1296,9 +1372,19 @@ static void check_preempt_wakeup(struct 
 		return;
 	}
 
-	delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
-	if (delta_exec > wakeup_gran(pse))
-		resched_task(curr);
+	find_matching_se(&se, &pse);
+
+	while (se) {
+		BUG_ON(!pse);
+
+		if (wakeup_preempt_entity(se, pse) == 1) {
+			resched_task(curr);
+			break;
+		}
+
+		se = parent_entity(se);
+		pse = parent_entity(pse);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)


