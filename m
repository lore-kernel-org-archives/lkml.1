Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKLO5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKLO5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZKLO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:57:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZKLO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:57:07 -0500
Message-Id: <20091112145610.832503781@chello.nl>
References: <20091112145527.808885617@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 15:55:28 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/2] sched: cleanup select_task_rq_fair()
Content-Disposition: inline; filename=sched-idle-sibling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the new affine to idle sibling bits while trying to grok
them. Should not have any function differences.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched_fair.c |   73 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 51 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1345,6 +1345,41 @@ find_idlest_cpu(struct sched_group *grou
 }
 
 /*
+ * Try and locate an idle CPU in the sched_domain.
+ */
+static int
+select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+{
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int i;
+
+	/*
+	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
+	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
+	 * always a better target than the current cpu.
+	 */
+	if (target == cpu) {
+		if (!cpu_rq(prev_cpu)->cfs.nr_running)
+			target = prev_cpu;
+	}
+
+	/*
+	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 */
+	if (target == -1 || target == cpu) {
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (!cpu_rq(i)->cfs.nr_running) {
+				target = i;
+				break;
+			}
+		}
+	}
+
+	return target;
+}
+
+/*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
@@ -1399,36 +1434,30 @@ static int select_task_rq_fair(struct ta
 		}
 
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE)) {
-			int candidate = -1, i;
+			int target = -1;
 
+			/*
+			 * If both cpu and prev_cpu are part of this domain,
+			 * cpu is a valid SD_WAKE_AFFINE target.
+			 */
 			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				candidate = cpu;
+				target = cpu;
 
 			/*
-			 * Check for an idle shared cache.
+			 * If there's an idle sibling in this domain, make that
+			 * the wake_affine target instead of the current cpu.
+			 *
+			 * XXX: should we possibly do this outside of
+			 * WAKE_AFFINE, in case the shared cache domain is
+			 * smaller than the WAKE_AFFINE domain?
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING) {
-				if (candidate == cpu) {
-					if (!cpu_rq(prev_cpu)->cfs.nr_running)
-						candidate = prev_cpu;
-				}
-
-				if (candidate == -1 || candidate == cpu) {
-					for_each_cpu(i, sched_domain_span(tmp)) {
-						if (!cpumask_test_cpu(i, &p->cpus_allowed))
-							continue;
-						if (!cpu_rq(i)->cfs.nr_running) {
-							candidate = i;
-							break;
-						}
-					}
-				}
-			}
+			if (tmp->flags & SD_PREFER_SIBLING)
+				target = select_idle_sibling(p, tmp, target);
 
-			if (candidate >= 0) {
+			if (target >= 0) {
 				affine_sd = tmp;
 				want_affine = 0;
-				cpu = candidate;
+				cpu = target;
 			}
 		}
 

-- 

