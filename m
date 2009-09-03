Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbZICNZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbZICNZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZICNZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:25:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:52782 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZICNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:20 -0400
Message-Id: <20090903132213.100322684@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:56 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 11/14] sched: provide arch_scale_freq_power
Content-Disposition: inline; filename=sched-lb-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an ach specific hook for cpufreq based scaling of cpu_power.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3712,7 +3712,18 @@ static inline int check_power_save_busie
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return SCHED_LOAD_SCALE;
+}
+
+unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_freq_power(sd, cpu);
+}
+
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long smt_gain = sd->smt_gain;
@@ -3722,6 +3733,11 @@ unsigned long __weak arch_scale_smt_powe
 	return smt_gain;
 }
 
+unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
+{
+	return default_scale_smt_power(sd, cpu);
+}
+
 unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -3746,7 +3762,8 @@ static void update_cpu_power(struct sche
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	/* here we could scale based on cpufreq */
+	power *= arch_scale_freq_power(sd, cpu);
+	power >> SCHED_LOAD_SHIFT;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		power *= arch_scale_smt_power(sd, cpu);

-- 

