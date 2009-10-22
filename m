Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZJVMoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZJVMoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZJVMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:44:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46282 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZJVMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:10 -0400
Message-Id: <20091022124110.600098573@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:48 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 05/17] sched: dynamic cpu_power
Content-Disposition: inline; filename=sched-lb-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recompute the cpu_power for each cpu during load-balance
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 kernel/sched.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 09:15:34.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:35.000000000 -0400
@@ -3780,14 +3780,46 @@
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-static void update_sched_power(struct sched_domain *sd)
+unsigned long __weak arch_smt_gain(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long smt_gain = sd->smt_gain;
+
+	smt_gain /= weight;
+
+	return smt_gain;
+}
+
+static void update_cpu_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long power = SCHED_LOAD_SCALE;
+	struct sched_group *sdg = sd->groups;
+	unsigned long old = sdg->__cpu_power;
+
+	/* here we could scale based on cpufreq */
+
+	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+		power *= arch_smt_gain(sd, cpu);
+		power >>= SCHED_LOAD_SHIFT;
+	}
+
+	/* here we could scale based on RT time */
+
+	if (power != old) {
+		sdg->__cpu_power = power;
+		sdg->reciprocal_cpu_power = reciprocal_value(power);
+	}
+}
+
+static void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
 	unsigned long power = sdg->__cpu_power;
 
 	if (!child) {
-		/* compute cpu power for this cpu */
+		update_cpu_power(sd, cpu);
 		return;
 	}
 
@@ -3830,7 +3862,7 @@
 	if (local_group) {
 		balance_cpu = group_first_cpu(group);
 		if (balance_cpu == this_cpu)
-			update_sched_power(sd);
+			update_group_power(sd, this_cpu);
 	}
 
 	/* Tally up the load of all CPUs in the group */

--
