Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZJVMoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZJVMoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZJVMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:44:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60734 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbZJVMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:10 -0400
Message-Id: <20091022124112.573285272@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:57 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 14/17] sched: cleanup wake_idle 
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
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 kernel/sched_fair.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

Index: linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/kernel/sched_fair.c	2009-10-21 10:49:01.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c	2009-10-21 10:49:02.000000000 -0400
@@ -1080,14 +1080,13 @@
  * not idle and an idle cpu is available.  The span of cpus to
  * search starts with cpus closest then further out as needed,
  * so we always favor a closer, idle cpu.
- * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (cpu_active_mask)
  *
  * Returns the CPU we should wake onto.
  */
 static int wake_idle(int cpu, struct task_struct *p)
 {
-	struct sched_domain *sd;
+	struct rq *task_rq = task_rq(p);
+	struct sched_domain *sd, *child = NULL;
 	int i;
 
 	i = wake_idle_power_save(cpu, p);
@@ -1106,24 +1105,34 @@
 	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;
 
-	for_each_domain(cpu, sd) {
-		if ((sd->flags & SD_WAKE_IDLE)
-		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq(p)->clock, sd))) {
-			for_each_cpu_and(i, sched_domain_span(sd),
-					 &p->cpus_allowed) {
-				if (cpu_active(i) && idle_cpu(i)) {
-					if (i != task_cpu(p)) {
-						schedstat_inc(p,
-						       se.nr_wakeups_idle);
-					}
-					return i;
-				}
-			}
-		} else {
+	rcu_read_lock();
+ 	for_each_domain(cpu, sd) {
+		if (!(sd->flags & SD_LOAD_BALANCE))
+ 			break;
+
+		if (!(sd->flags & SD_WAKE_IDLE) &&
+		    (task_hot(p, task_rq->clock, sd) || !(sd->flags & SD_WAKE_IDLE_FAR)))
 			break;
-		}
-	}
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
+ 		}
+
+		child = sd;
+ 	}
+unlock:
+	rcu_read_unlock();
+
 	return cpu;
 }
 #else /* !ARCH_HAS_SCHED_WAKE_IDLE*/

--
