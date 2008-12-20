Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYLTBB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYLTBB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYLTBA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:00:56 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45021 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbYLTBAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:53 -0500
Message-Id: <20081220010044.181078000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:45 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 2/8] cpumask: Replace CPUMASK_ALLOC etc with cpumask_var_t. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:get-rid-of-CPUMASK_ALLOC-x86.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There's only one user, and it's a fairly easy conversion.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -458,11 +458,6 @@ static int centrino_verify (struct cpufr
  *
  * Sets a new CPUFreq policy.
  */
-struct allmasks {
-	cpumask_t		saved_mask;
-	cpumask_t		covered_cpus;
-};
-
 static int centrino_target (struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -472,12 +467,15 @@ static int centrino_target (struct cpufr
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-	CPUMASK_ALLOC(allmasks);
-	CPUMASK_PTR(saved_mask, allmasks);
-	CPUMASK_PTR(covered_cpus, allmasks);
+	cpumask_var_t saved_mask, covered_cpus;
 
-	if (unlikely(allmasks == NULL))
+	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
+	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+		free_cpumask_var(saved_mask);
+		return -ENOMEM;
+	}
+	cpumask_copy(saved_mask, &current->cpus_allowed);
 
 	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
 		retval = -ENODEV;
@@ -493,9 +491,7 @@ static int centrino_target (struct cpufr
 		goto out;
 	}
 
-	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
-	cpus_clear(*covered_cpus);
 	for_each_cpu_mask_nr(j, policy->cpus) {
 		const cpumask_t *mask;
 
@@ -605,7 +601,8 @@ migrate_end:
 	preempt_enable();
 	set_cpus_allowed_ptr(current, saved_mask);
 out:
-	CPUMASK_FREE(allmasks);
+	free_cpumask_var(saved_mask);
+	free_cpumask_var(covered_cpus);
 	return retval;
 }
 

-- 
