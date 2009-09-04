Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZIDI42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZIDI42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbZIDI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:56:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:36669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbZIDI4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:56:24 -0400
Date: Fri, 4 Sep 2009 08:55:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083826.162033479@chello.nl>
References: <20090901083826.162033479@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Implement dynamic cpu_power
Message-ID: <tip-ab29230e673c646292c90c8b9d378b9562145af0@git.kernel.org>
Git-Commit-ID: ab29230e673c646292c90c8b9d378b9562145af0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:55:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab29230e673c646292c90c8b9d378b9562145af0
Gitweb:     http://git.kernel.org/tip/ab29230e673c646292c90c8b9d378b9562145af0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:54 +0200

sched: Implement dynamic cpu_power

Recompute the cpu_power for each cpu during load-balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083826.162033479@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   38 +++++++++++++++++++++++++++++++++++---
 1 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5511226..036600f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3699,14 +3699,46 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
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
 
@@ -3749,7 +3781,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	if (local_group) {
 		balance_cpu = group_first_cpu(group);
 		if (balance_cpu == this_cpu)
-			update_sched_power(sd);
+			update_group_power(sd, this_cpu);
 	}
 
 	/* Tally up the load of all CPUs in the group */
