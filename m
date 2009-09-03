Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZICNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZICNXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZICNXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:52778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZICNXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:17 -0400
Message-Id: <20090903132213.413056069@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:59 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 14/14] sched: cleanup wake_idle
Content-Disposition: inline; filename=sched-lb-13.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A more readable version, with a few differences:

 - don't check against the root domain, but instead check
   SD_LOAD_BALANCE

 - don't re-iterate the cpus already iterated on the previous SD

 - use rcu_read_lock() around the sd iteration

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1053,15 +1053,10 @@ static void yield_task_fair(struct rq *r
  * not idle and an idle cpu is available.  The span of cpus to
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
- * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (rq->rd->online)
  *
  * Returns the CPU we should wake onto.
  */
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
-
-#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
-
 /*
  * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
  * are idle and this is not a kernel thread and this task's affinity
@@ -1099,7 +1094,7 @@ static int wake_idle_power_save(int cpu,
 static int wake_idle(int cpu, struct task_struct *p)
 {
 	struct rq *task_rq = task_rq(p);
-	struct sched_domain *sd;
+	struct sched_domain *sd, *child = NULL;
 	int i;
 
 	i = wake_idle_power_save(cpu, p);
@@ -1118,24 +1113,34 @@ static int wake_idle(int cpu, struct tas
 	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		if ((sd->flags & SD_WAKE_IDLE)
-		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq->clock, sd))) {
-			for_each_cpu_and(i, sched_domain_span(sd),
-					 &p->cpus_allowed) {
-				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
-					if (i != task_cpu(p)) {
-						schedstat_inc(p,
-						       se.nr_wakeups_idle);
-					}
-					return i;
-				}
-			}
-		} else {
+		if (!(sd->flags & SD_LOAD_BALANCE))
 			break;
+
+		if (!(sd->flags & SD_WAKE_IDLE) &&
+		    (task_hot(p, task_rq->clock, sd) || !(sd->flags & SD_WAKE_IDLE_FAR)))
+			break;
+
+		for_each_cpu_and(i, sched_domain_span(sd), &p->cpus_allowed) {
+			if (child && cpumask_test_cpu(i, sched_domain_span(child)))
+				continue;
+
+			if (!idle_cpu(i))
+				continue;
+
+			if (task_cpu(p) != i)
+				schedstat_inc(p, se.nr_wakeups_idle);
+
+			cpu = i;
+			goto unlock;
 		}
+
+		child = sd;
 	}
+unlock:
+	rcu_read_unlock();
+
 	return cpu;
 }
 #else /* !ARCH_HAS_SCHED_WAKE_IDLE*/

-- 

