Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYCIRMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYCIRMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbYCIRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:25 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:25079 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYCIRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:20 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080309170929.883491000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 17/17] sched: fair: optimize the elegebility test
Content-Disposition: inline; filename=sched-fair-avg_runtime-opt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Dmitry Adamushko; trade a div for a mult.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -339,6 +339,12 @@ s64 avg_vruntime(struct cfs_root_rq *cfs
 }
 
 static inline
+int avg_vruntime_cmp(struct cfs_root_rq *cfs_r_rq, s64 vruntime)
+{
+	return (vruntime * cfs_r_rq->nr_queued) <= cfs_r_rq->avg_vruntime;
+}
+
+static inline
 s64 entity_deadline_key(struct cfs_root_rq *cfs_r_rq, struct sched_entity *se)
 {
 	return se->vruntime + se->vperiod - cfs_r_rq->min_vruntime;
@@ -430,11 +436,10 @@ static struct sched_entity *__pick_next_
  */
 static struct sched_entity *__pick_next_entity(struct cfs_root_rq *cfs_r_rq)
 {
-	struct sched_entity *next_deadline;
-	s64 avg = avg_vruntime(cfs_r_rq);
+	struct sched_entity *next_deadline = __pick_next_deadline(cfs_r_rq);
+	s64 vruntime = entity_timeline_key(cfs_r_rq, next_deadline);
 
-	next_deadline = __pick_next_deadline(cfs_r_rq);
-	if (entity_timeline_key(cfs_r_rq, next_deadline) <= avg)
+	if (avg_vruntime_cmp(cfs_r_rq, vruntime))
 		return next_deadline;
 
 	return __pick_next_timeline(cfs_r_rq);

--

