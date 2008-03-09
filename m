Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYCIRLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYCIRLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYCIRJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:22 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14961 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752060AbYCIRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:18 -0400
Message-Id: <20080309170928.883496000@chello.nl>
References: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:09:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 13/17] sched: fair: calc_delta_weight()
Content-Disposition: inline; filename=sched-calc_delta_weight.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Little cleanup..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

Index: linux-2.6-2/kernel/sched_fair.c
===================================================================
--- linux-2.6-2.orig/kernel/sched_fair.c
+++ linux-2.6-2/kernel/sched_fair.c
@@ -342,6 +342,34 @@ int sched_nr_latency_handler(struct ctl_
 #endif
 
 /*
+ * delta *= w / rw
+ */
+static inline unsigned long
+calc_delta_weight(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				se->load.weight, &cfs_rq_of(se)->load);
+	}
+
+	return delta;
+}
+
+/*
+ * delta *= rw / w
+ */
+static inline unsigned long
+calc_delta_fair(unsigned long delta, struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		delta = calc_delta_mine(delta,
+				cfs_rq_of(se)->load.weight, &se->load);
+	}
+
+	return delta;
+}
+
+/*
  * The idea is to set a period in which each task runs once.
  *
  * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
@@ -379,10 +407,7 @@ static u64 sched_slice(struct cfs_rq *cf
 	if (unlikely(rq_of(cfs_rq)->load.weight <= se->load.weight))
 		goto out;
 
-	for_each_sched_entity(se) {
-		slice = calc_delta_mine(slice,
-				se->load.weight, &cfs_rq_of(se)->load);
-	}
+	slice = calc_delta_weight(slice, se);
 
 out:
 	return slice;
@@ -403,17 +428,6 @@ static u64 sched_vslice_add(struct cfs_r
 	return __sched_period(nr_running);
 }
 
-static inline unsigned long
-calc_delta_fair(unsigned long delta, struct sched_entity *se)
-{
-	for_each_sched_entity(se) {
-		delta = calc_delta_mine(delta,
-				cfs_rq_of(se)->load.weight, &se->load);
-	}
-
-	return delta;
-}
-
 /*
  * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
  * that it favours >=0 over <0.

--

