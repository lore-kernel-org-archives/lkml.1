Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZJVMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZJVMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZJVMnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:43:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46285 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbZJVMlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:11 -0400
Message-Id: <20091022124112.378859379@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:56 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 13/17] sched: cleanup wake_idle power saving
Content-Disposition: inline; filename=sched-lb-12.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully a more readable version of the same.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 kernel/sched_fair.c |   58 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 19 deletions(-)

Index: linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c
===================================================================
--- linux-2.6.31.4-rt14-lb1.orig/kernel/sched_fair.c	2009-10-21 10:47:14.000000000 -0400
+++ linux-2.6.31.4-rt14-lb1/kernel/sched_fair.c	2009-10-21 10:49:01.000000000 -0400
@@ -1040,6 +1040,41 @@
 	se->vruntime = rightmost->vruntime + 1;
 }
 
+#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
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
 /*
  * wake_idle() will wake a task on an idle cpu if task->cpu is
  * not idle and an idle cpu is available.  The span of cpus to
@@ -1050,29 +1085,14 @@
  *
  * Returns the CPU we should wake onto.
  */
-#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
 static int wake_idle(int cpu, struct task_struct *p)
 {
 	struct sched_domain *sd;
 	int i;
-	unsigned int chosen_wakeup_cpu;
-	int this_cpu;
-
-	/*
-	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
-	 * are idle and this is not a kernel thread and this task's affinity
-	 * allows it to be moved to preferred cpu, then just move!
-	 */
-
-	this_cpu = smp_processor_id();
-	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
 
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
@@ -1081,7 +1101,7 @@
 	 * Siblings must be also busy(in most cases) as they didn't already
 	 * pickup the extra load from this cpu and hence we need not check
 	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
+	 * penalties associated with that.
 	 */
 	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
 		return cpu;

--
