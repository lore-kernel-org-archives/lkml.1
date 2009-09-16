Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbZIPKXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbZIPKXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZIPKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:23:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:46519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640AbZIPKW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:22:59 -0400
Date: Wed, 16 Sep 2009 10:22:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Provide arch_scale_freq_power
Message-ID: <tip-d6a59aa3a2b1ca8411884c833a313b33b5f76e20@git.kernel.org>
Git-Commit-ID: d6a59aa3a2b1ca8411884c833a313b33b5f76e20
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:22:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6a59aa3a2b1ca8411884c833a313b33b5f76e20
Gitweb:     http://git.kernel.org/tip/d6a59aa3a2b1ca8411884c833a313b33b5f76e20
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 2 Sep 2009 13:28:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:24 +0200

sched: Provide arch_scale_freq_power

Provide an ach specific hook for cpufreq based scaling of
cpu_power.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[ego@in.ibm.com: spotting bugs]
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f0ccb8b..c210321 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3552,7 +3552,18 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
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
@@ -3562,6 +3573,11 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
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
@@ -3586,7 +3602,8 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
-	/* here we could scale based on cpufreq */
+	power *= arch_scale_freq_power(sd, cpu);
+	power >>= SCHED_LOAD_SHIFT;
 
 	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
 		power *= arch_scale_smt_power(sd, cpu);
