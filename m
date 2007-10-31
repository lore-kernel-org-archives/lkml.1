Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbXJaVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbXJaVOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXJaVOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:14:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbXJaVOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:14:05 -0400
Message-Id: <20071031211249.676129000@chello.nl>
References: <20071031211030.310581000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 31 Oct 2007 22:10:36 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/6] sched: place_entity() comments
Content-Disposition: inline; filename=sched-place-entity.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few comments to place_entity().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -582,19 +582,26 @@ place_entity(struct cfs_rq *cfs_rq, stru
 	} else if (sched_feat(APPROX_AVG) && cfs_rq->nr_running)
 		vruntime += sched_vslice(cfs_rq)/2;
 
+	/*
+	 * The 'current' period is already promised to the current tasks,
+	 * however the extra weight of the new task will slow them down a
+	 * little, place the new task so that it fits in the slot that
+	 * stays open at the end.
+	 */
 	if (initial && sched_feat(START_DEBIT))
 		vruntime += sched_vslice_add(cfs_rq, se);
 
 	if (!initial) {
+		/* sleeps upto a single latency don't count. */
 		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
 				task_of(se)->policy != SCHED_BATCH)
 			vruntime -= sysctl_sched_latency;
 
-		vruntime = max_t(s64, vruntime, se->vruntime);
+		/* ensure we never gain time by being placed backwards. */
+		vruntime = max_vruntime(se->vruntime, vruntime);
 	}
 
 	se->vruntime = vruntime;
-
 }
 
 static void

--

