Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZKLO5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZKLO5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZKLO5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:57:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:58871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbZKLO5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:57:03 -0500
Message-Id: <20091112145610.909723612@chello.nl>
References: <20091112145527.808885617@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 15:55:29 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/2] sched: More generic WAKE_AFFINE vs select_idle_sibling()
Content-Disposition: inline; filename=sched-idle-sibling-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of only considering SD_WAKE_AFFINE | SD_PREFER_SIBLING domains
also allow all SD_PREFER_SIBLING domains below a SD_WAKE_AFFINE domain
to change the affinity target.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched_fair.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1359,20 +1359,16 @@ select_idle_sibling(struct task_struct *
 	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
 	 * always a better target than the current cpu.
 	 */
-	if (target == cpu) {
-		if (!cpu_rq(prev_cpu)->cfs.nr_running)
-			target = prev_cpu;
-	}
+	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+		return prev_cpu;
 
 	/*
 	 * Otherwise, iterate the domain and find an elegible idle cpu.
 	 */
-	if (target == -1 || target == cpu) {
-		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-			if (!cpu_rq(i)->cfs.nr_running) {
-				target = i;
-				break;
-			}
+	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+		if (!cpu_rq(i)->cfs.nr_running) {
+			target = i;
+			break;
 		}
 	}
 
@@ -1433,7 +1429,12 @@ static int select_task_rq_fair(struct ta
 				want_sd = 0;
 		}
 
-		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
+		/*
+		 * While iterating the domains looking for a spanning
+		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
+		 * in cache sharing domains along the way.
+		 */
+		if (want_affine) {
 			int target = -1;
 
 			/*
@@ -1446,17 +1447,15 @@ static int select_task_rq_fair(struct ta
 			/*
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
-			 *
-			 * XXX: should we possibly do this outside of
-			 * WAKE_AFFINE, in case the shared cache domain is
-			 * smaller than the WAKE_AFFINE domain?
 			 */
 			if (tmp->flags & SD_PREFER_SIBLING)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
-				affine_sd = tmp;
-				want_affine = 0;
+				if (tmp->flags & SD_WAKE_AFFINE) {
+					affine_sd = tmp;
+					want_affine = 0;
+				}
 				cpu = target;
 			}
 		}

-- 

