Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYGOVRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYGOVRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYGOVOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33447 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755896AbYGOVOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:32 -0400
Message-Id: <20080715211430.580740000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:37 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Paul Jackson <pj@sgi.com>
Subject: [PATCH 8/8] cpumask: Use optimized CPUMASK_ALLOC macros in the centrino_target
Content-Disposition: inline; filename=optimize-cpumasks-in-arch_x86_kernel_cpu_cpufreq_speedstep-centrino_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Use the CPUMASK_ALLOC macros in the centrino_target() function.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Paul Jackson <pj@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   73 ++++++++++++++---------
 1 file changed, 45 insertions(+), 28 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -535,6 +535,13 @@ static int centrino_verify (struct cpufr
  *
  * Sets a new CPUFreq policy.
  */
+struct allmasks {
+	cpumask_t		online_policy_cpus;
+	cpumask_t		saved_mask;
+	cpumask_t		set_mask;
+	cpumask_t		covered_cpus;
+};
+
 static int centrino_target (struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -542,48 +549,55 @@ static int centrino_target (struct cpufr
 	unsigned int    newstate = 0;
 	unsigned int	msr, oldmsr = 0, h = 0, cpu = policy->cpu;
 	struct cpufreq_freqs	freqs;
-	cpumask_t		online_policy_cpus;
-	cpumask_t		saved_mask;
-	cpumask_t		set_mask;
-	cpumask_t		covered_cpus;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-
-	if (unlikely(centrino_model[cpu] == NULL))
-		return -ENODEV;
+	CPUMASK_ALLOC(allmasks);
+	CPUMASK_VAR(online_policy_cpus, allmasks);
+	CPUMASK_VAR(saved_mask, allmasks);
+	CPUMASK_VAR(set_mask, allmasks);
+	CPUMASK_VAR(covered_cpus, allmasks);
+
+	if (unlikely(allmasks == NULL))
+		return -ENOMEM;
+
+	if (unlikely(centrino_model[cpu] == NULL)) {
+		retval = -ENODEV;
+		goto out;
+	}
 
 	if (unlikely(cpufreq_frequency_table_target(policy,
 			centrino_model[cpu]->op_points,
 			target_freq,
 			relation,
 			&newstate))) {
-		return -EINVAL;
+		retval = -EINVAL;
+		goto out;
 	}
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
+	cpus_and(*online_policy_cpus, cpu_online_map, policy->cpus);
 #else
-	online_policy_cpus = policy->cpus;
+	*online_policy_cpus = policy->cpus;
 #endif
 
-	saved_mask = current->cpus_allowed;
+	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
-	cpus_clear(covered_cpus);
-	for_each_cpu_mask_nr(j, online_policy_cpus) {
+	cpus_clear(*covered_cpus);
+	for_each_cpu_mask_nr(j, *online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
 		 */
-		cpus_clear(set_mask);
+		cpus_clear(*set_mask);
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			cpus_or(set_mask, set_mask, online_policy_cpus);
+			cpus_or(*set_mask, *set_mask, *online_policy_cpus);
 		else
-			cpu_set(j, set_mask);
+			cpu_set(j, *set_mask);
 
-		set_cpus_allowed_ptr(current, &set_mask);
+		set_cpus_allowed_ptr(current, set_mask);
 		preempt_disable();
-		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
+		if (unlikely(!cpu_isset(smp_processor_id(), *set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
@@ -611,7 +625,7 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, online_policy_cpus) {
+			for_each_cpu_mask_nr(k, *online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -630,11 +644,11 @@ static int centrino_target (struct cpufr
 			break;
 		}
 
-		cpu_set(j, covered_cpus);
+		cpu_set(j, *covered_cpus);
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, online_policy_cpus) {
+	for_each_cpu_mask_nr(k, *online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -647,10 +661,10 @@ static int centrino_target (struct cpufr
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(covered_cpus)) {
+		if (!cpus_empty(*covered_cpus)) {
 			cpumask_of_cpu_ptr_declare(new_mask);
 
-			for_each_cpu_mask_nr(j, covered_cpus) {
+			for_each_cpu_mask_nr(j, *covered_cpus) {
 				cpumask_of_cpu_ptr_next(new_mask, j);
 				set_cpus_allowed_ptr(current, new_mask);
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
@@ -660,19 +674,22 @@ static int centrino_target (struct cpufr
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask_nr(j, online_policy_cpus) {
+		for_each_cpu_mask_nr(j, *online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}
 	}
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return 0;
+	set_cpus_allowed_ptr(current, saved_mask);
+	retval = 0;
+	goto out;
 
 migrate_end:
 	preempt_enable();
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return 0;
+	set_cpus_allowed_ptr(current, saved_mask);
+out:
+	CPUMASK_FREE(allmasks);
+	return retval;
 }
 
 static struct freq_attr* centrino_attr[] = {

-- 
