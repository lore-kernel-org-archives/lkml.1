Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYJQRaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYJQRaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYJQR3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:29:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbYJQR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:29:45 -0400
Message-Id: <20081017172829.701687899@chello.nl>
References: <20081017172701.047939625@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 17 Oct 2008 19:27:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] sched: revert back to per-rq vruntime
Content-Disposition: inline; filename=sched-opt-weight.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vatsa rightly points out that having the runqueue weight in the vruntime
calculations can cause unfairness in the face of task joins/leaves.

Suppose: dv = dt * rw / w

Then take 10 tasks t_n, each of similar weight. If the first will run 1
then its vruntime will increase by 10. Now, if the next 8 tasks leave after
having run their 1, then the last task will get a vruntime increase of 2
after having run 1.

Which will leave us with 2 tasks of equal weight and equal runtime, of which
one will not be scheduled for 8/2=4 units of time.

Ergo, we cannot do that and must use: dv = dt / w.

This means we cannot have a global vruntime based on effective priority, but
must instead go back to the vruntime per rq model we started out with.

This patch was lightly tested by doing starting while loops on each nice level
and observing their execution time, and a simple group scenario of 1:2:3 pinned
to a single cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -336,7 +336,7 @@ int sched_nr_latency_handler(struct ctl_
 #endif
 
 /*
- * delta *= w / rw
+ * delta *= P[w / rw]
  */
 static inline unsigned long
 calc_delta_weight(unsigned long delta, struct sched_entity *se)
@@ -350,15 +350,13 @@ calc_delta_weight(unsigned long delta, s
 }
 
 /*
- * delta *= rw / w
+ * delta /= w
  */
 static inline unsigned long
 calc_delta_fair(unsigned long delta, struct sched_entity *se)
 {
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
+	if (unlikely(se->load.weight != NICE_0_LOAD))
+		delta = calc_delta_mine(delta, NICE_0_LOAD, &se->load);
 
 	return delta;
 }
@@ -388,26 +386,26 @@ static u64 __sched_period(unsigned long 
  * We calculate the wall-time slice from the period by taking a part
  * proportional to the weight.
  *
- * s = p*w/rw
+ * s = p*P[w/rw]
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	return calc_delta_weight(__sched_period(cfs_rq->nr_running), se);
+	unsigned long nr_running = cfs_rq->nr_running;
+
+	if (unlikely(!se->on_rq))
+		nr_running++;
+
+	return calc_delta_weight(__sched_period(nr_running), se);
 }
 
 /*
  * We calculate the vruntime slice of a to be inserted task
  *
- * vs = s*rw/w = p
+ * vs = s/w
  */
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	unsigned long nr_running = cfs_rq->nr_running;
-
-	if (!se->on_rq)
-		nr_running++;
-
-	return __sched_period(nr_running);
+	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
 /*
@@ -630,7 +628,7 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	 * stays open at the end.
 	 */
 	if (initial && sched_feat(START_DEBIT))
-		vruntime += sched_vslice_add(cfs_rq, se);
+		vruntime += sched_vslice(cfs_rq, se);
 
 	if (!initial) {
 		/* sleeps upto a single latency don't count. */

-- 

