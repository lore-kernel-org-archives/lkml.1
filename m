Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0CESr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:47:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:50815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0CESr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:47:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,588,1262592000"; 
   d="scan'208";a="498142257"
Message-Id: <20100305184213.922106492@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Mar 2010 10:39:26 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>
Cc: Arjan van de Ven <arjan@linux.jf.intel.com>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Yanmin Zhang <yanmin_zhang@linux.jf.intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] sched: fix select_idle_sibling() logic in select_task_rq_fair()
References: <20100305184213.829832580@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_lat_ctx.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performance improvements with this patch:
"lat_ctx -s 0 2" ~22usec (before-this-patch)	~5usec (after-this-patch)

There are number of things wrong with the select_idle_sibling() logic

a) Once we select the idle sibling, we use that domain (spanning the cpu that
   the task is currently woken-up and the idle sibling that we found) in our
   wake_affine() comparisons. This domain is completely different from the
   domain(we are supposed to use) that spans the cpu that the task currently
   woken-up and the cpu where the task previously ran.

b) We do select_idle_sibling() check only for the cpu that the task is
   currently woken-up on. If the wake_affine makes the decision of selecting
   the cpu where the task previously ran, doing a select_idle_sibling() check
   for that cpu also helps and we don't do this currently.
 
c) Also, selelct_idle_sibling() should also treat the current cpu as an idle
   cpu if it is a sync wakeup and we have only one task running.

Fixing all this improves the lat_ctx performance. Also, there might be
other workloads where select_idle_sibling() check on previously ran cpu
will also help.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched_fair.c |   73 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

Index: tip/kernel/sched_fair.c
===================================================================
--- tip.orig/kernel/sched_fair.c
+++ tip/kernel/sched_fair.c
@@ -1411,28 +1411,49 @@ find_idlest_cpu(struct sched_group *grou
  * Try and locate an idle CPU in the sched_domain.
  */
 static int
-select_idle_sibling(struct task_struct *p, struct sched_domain *sd, int target)
+select_idle_sibling(struct task_struct *p, int target, int sync)
 {
 	int cpu = smp_processor_id();
 	int prev_cpu = task_cpu(p);
 	int i;
+	struct sched_domain *sd;
+
+	/*
+	 * If the task is going to be woken-up on this cpu and if it is
+	 * already idle or going to be idle, then it is the right target.
+	 */
+	if (target == cpu && (!cpu_rq(cpu)->cfs.nr_running ||
+			      (sync && cpu_rq(cpu)->cfs.nr_running == 1)))
+		return cpu;
 
 	/*
-	 * If this domain spans both cpu and prev_cpu (see the SD_WAKE_AFFINE
-	 * test in select_task_rq_fair) and the prev_cpu is idle then that's
-	 * always a better target than the current cpu.
+	 * If the task is going to be woken-up on the cpu where it previously
+	 * ran and if it is currently idle, then it the right target.
 	 */
-	if (target == cpu && !cpu_rq(prev_cpu)->cfs.nr_running)
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
@@ -1496,32 +1517,17 @@ static int select_task_rq_fair(struct ta
 
 		/*
 		 * While iterating the domains looking for a spanning
-		 * WAKE_AFFINE domain, adjust the affine target to any idle cpu
-		 * in cache sharing domains along the way.
+		 * WAKE_AFFINE domain.
 		 */
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
 
@@ -1549,8 +1555,13 @@ static int select_task_rq_fair(struct ta
 			update_shares(tmp);
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync))
-		return cpu;
+	if (affine_sd) {
+		int target;
+
+		target = wake_affine(affine_sd, p, sync) ? cpu : prev_cpu;
+
+		return select_idle_sibling(p, target, sync);
+	}
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;


