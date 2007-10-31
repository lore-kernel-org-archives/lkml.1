Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbXJaVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbXJaVOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXJaVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077AbXJaVOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:07 -0400
Message-Id: <20071031211248.796653000@chello.nl>
References: <20071031211030.310581000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 22:10:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: [PATCH 2/6] sched: make sched_slice() group scheduling savvy
Content-Disposition: inline; filename=sched-slice-group.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the ideal slice length does not take group scheduling into account.
Change it so that it properly takes all the runnable tasks on this cpu into
account and caluclate the weight according to the grouping hierarchy.

Also fixes a bug in vslice which missed a factor NICE_0_LOAD.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -331,10 +331,15 @@ static u64 __sched_period(unsigned long 
  */
 static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	u64 slice = __sched_period(cfs_rq->nr_running);
+	unsigned long nr_running = rq_of(cfs_rq)->nr_running;
+	u64 slice = __sched_period(nr_running);
 
-	slice *= se->load.weight;
-	do_div(slice, cfs_rq->load.weight);
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		slice *= se->load.weight;
+		do_div(slice, cfs_rq->load.weight);
+	}
 
 	return slice;
 }
@@ -344,24 +349,39 @@ static u64 sched_slice(struct cfs_rq *cf
  *
  * vs = s/w = p/rw
  */
-static u64 __sched_vslice(unsigned long rq_weight, unsigned long nr_running)
+static u64 __sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *new)
 {
-	u64 vslice = __sched_period(nr_running);
+	struct sched_entity *se = cfs_rq->curr;
+	unsigned long nr_running = rq_of(cfs_rq)->nr_running;
+	unsigned long weight = 0;
+	u64 vslice;
+
+	if (new) {
+		nr_running++;
+		weight = new->load.weight;
+	}
 
-	do_div(vslice, rq_weight);
+	vslice = __sched_period(nr_running);
+
+	for_each_sched_entity(se) {
+		cfs_rq = cfs_rq_of(se);
+
+		vslice *= NICE_0_LOAD;
+		do_div(vslice, cfs_rq->load.weight + weight);
+		weight = 0;
+	}
 
 	return vslice;
 }
 
-static u64 sched_vslice(struct cfs_rq *cfs_rq)
+static inline u64 sched_vslice(struct cfs_rq *cfs_rq)
 {
-	return __sched_vslice(cfs_rq->load.weight, cfs_rq->nr_running);
+	return __sched_vslice(cfs_rq, NULL);
 }
 
-static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static inline u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *new)
 {
-	return __sched_vslice(cfs_rq->load.weight + se->load.weight,
-			cfs_rq->nr_running + 1);
+	return __sched_vslice(cfs_rq, new);
 }
 
 /*

--

