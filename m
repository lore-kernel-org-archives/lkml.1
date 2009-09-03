Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZICNXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZICNXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZICNX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZICNXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:21 -0400
Message-Id: <20090903132213.321860421@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 13/14] sched: cleanup wake_idle power saving
Content-Disposition: inline; filename=sched-lb-12.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully a more readable version of the same.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched_fair.c |   58 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 19 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1062,29 +1062,49 @@ static void yield_task_fair(struct rq *r
 
 #define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
 
+/*
+ * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
+ * are idle and this is not a kernel thread and this task's affinity
+ * allows it to be moved to preferred cpu, then just move!
+ *
+ * XXX - can generate significant overload on perferred_wakeup_cpu
+ *       with plenty of idle cpus, leading to a significant loss in
+ *       throughput.
+ *
+ * Returns: <  0 - no placement decision made
+ *          >= 0 - place on cpu
+ */
+static int wake_idle_power_save(int cpu, struct task_struct *p)
+{
+	int this_cpu = smp_processor_id();
+	int wakeup_cpu;
+
+	if (sched_mc_power_savings < POWERSAVINGS_BALANCE_WAKEUP)
+		return -1;
+
+	if (!idle_cpu(cpu) || !idle_cpu(this_cpu))
+		return -1;
+
+	if (!p->mm || (p->flags & PF_KTHREAD))
+		return -1;
+
+	wakeup_cpu = cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
+
+	if (!cpu_isset(wakeup_cpu, p->cpus_allowed))
+		return -1;
+
+	return wakeup_cpu;
+}
+
 static int wake_idle(int cpu, struct task_struct *p)
 {
+	struct rq *task_rq = task_rq(p);
 	struct sched_domain *sd;
 	int i;
-	unsigned int chosen_wakeup_cpu;
-	int this_cpu;
-	struct rq *task_rq = task_rq(p);
-
-	/*
-	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
-	 * are idle and this is not a kernel thread and this task's affinity
-	 * allows it to be moved to preferred cpu, then just move!
-	 */
 
-	this_cpu = smp_processor_id();
-	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
-
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
-		idle_cpu(cpu) && idle_cpu(this_cpu) &&
-		p->mm && !(p->flags & PF_KTHREAD) &&
-		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
-		return chosen_wakeup_cpu;
+	i = wake_idle_power_save(cpu, p);
+	if (i >= 0)
+		return i;
 
 	/*
 	 * If it is idle, then it is the best cpu to run this task.
@@ -1093,7 +1113,7 @@ static int wake_idle(int cpu, struct tas
 	 * Siblings must be also busy(in most cases) as they didn't already
 	 * pickup the extra load from this cpu and hence we need not check
 	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
+	 * penalties associated with that.
 	 */
 	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;

-- 

