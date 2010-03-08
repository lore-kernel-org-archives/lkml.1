Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0CHWWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:22:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:61947 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab0CHWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:22:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,604,1262592000"; 
   d="scan'208";a="779050325"
Message-Id: <20100308221946.932207084@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Mar 2010 14:19:37 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v2 2/2] sched: fix select_idle_sibling() logic in select_task_rq_fair()
References: <20100308221946.842728363@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_select_idle_sibling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address these issues in the current select_idle_sibling() logic.

a) Once we select the idle sibling, we use that domain (spanning the cpu that
   the task is currently woken-up and the idle sibling that we found) in our
   wake_affine() comparisons. This domain is completely different from the
   domain(we are supposed to use) that spans the cpu that the task currently
   woken-up and the cpu where the task previously ran.

b) We do select_idle_sibling() check only for the cpu that the task is
   currently woken-up on. If select_task_rq_fair() selects the previously run
   cpu for waking the task no, doing a select_idle_sibling() check
   for that cpu also helps and we don't do this currently.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
Changes from v1:
   Drop treating the current cpu with one running task as an idle cpu in the
   presence of sync wakeup.
---
 kernel/sched_fair.c |   69 +++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1407,28 +1407,48 @@ find_idlest_cpu(struct sched_group *grou
  * Try and locate an idle CPU in the sched_domain.
  */
 static int
-select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+select_idle_sibling(struct task_struct *p, int target)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int i;
+	struct sched_domain *sd;
 
 	/*
-	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
-	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
-	 * always a better target than the current cpu.
+	 * If the task is going to be woken-up on this cpu and if it is
+	 * already idle, then it is the right target.
 	 */
-	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
+	if (target == cpu && !cpu_rq(cpu)->cfs.nr_running)
+		return cpu;
+
+	/*
+	 * If the task is going to be woken-up on the cpu where it previously
+	 * ran and if it is currently idle, then it the right target.
+	 */
+	if (target == prev_cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
 		return prev_cpu;
 
 	/*
-	 * Otherwise, iterate the domain and find an elegible idle cpu.
+	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
-	for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
-		if (!cpu_rq(i)->cfs.nr_running) {
-			target = i;
+	for_each_domain(target, sd) {
+		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
+
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (!cpu_rq(i)->cfs.nr_running) {
+				target = i;
+				break;
+			}
 		}
+
+		/*
+		 * Lets stop looking for an idle sibling when we reached
+		 * the domain that spans the current cpu and prev_cpu.
+		 */
+		if (cpumask_test_cpu(cpu, sched_domain_span(sd)) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
+			break;
 	}
 
 	return target;
@@ -1491,34 +1511,15 @@ static int select_task_rq_fair(struct ta
 				want_sd = 0;
 		}
 
-		/*
-		 * While iterating the domains looking for a spanning
-		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
-		 * in cache sharing domains along the way.
-		 */
 		if (want_affine) {
-			int target = -1;
-
 			/*
 			 * If both cpu and prev_cpu are part of this domain,
 			 * cpu is a valid SD_WAKE_AFFINE target.
 			 */
-			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp)))
-				target = cpu;
-
-			/*
-			 * If there's an idle sibling in this domain, make that
-			 * the wake_affine target instead of the current cpu.
-			 */
-			if (tmp->flags & SD_SHARE_PKG_RESOURCES)
-				target = select_idle_sibling(p, tmp, target);
-
-			if (target >= 0) {
-				if (tmp->flags & SD_WAKE_AFFINE) {
-					affine_sd = tmp;
-					want_affine = 0;
-				}
-				cpu = target;
+			if (cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))
+			    && (tmp->flags & SD_WAKE_AFFINE)) {
+				affine_sd = tmp;
+				want_affine = 0;
 			}
 		}
 
@@ -1548,7 +1549,9 @@ static int select_task_rq_fair(struct ta
 
 	if (affine_sd) {
 		if (this_cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			return cpu;
+			return select_idle_sibling(p, this_cpu);
+		else if (!sd)
+			return select_idle_sibling(p, prev_cpu);
 	}
 
 	while (sd) {


