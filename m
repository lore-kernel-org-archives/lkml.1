Return-Path: <linux-kernel-owner+w=401wt.eu-S1758316AbYJWCTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316AbYJWCTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbYJWCJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:09:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43366 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754976AbYJWCId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:33 -0400
Message-Id: <20081023020833.302361000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:09:01 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 35/35] x86: clean up speedctep-centrino and reduce cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=x86:speedstep-centrino-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
2) The loop can simply skip over offline cpus, rather than creating a tmp mask.
3) set_mask is set to either a single cpu or all online cpus in a policy.
   Since it's just used for set_cpus_allowed(), any offline cpus in a policy
   don't matter, so we can just use cpumask_of_cpu() or the policy->cpus.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   51 ++++++++++-------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- linux-2.6.28.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.28/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -552,9 +552,7 @@ static int centrino_verify (struct cpufr
  * Sets a new CPUFreq policy.
  */
 struct allmasks {
-	cpumask_t		online_policy_cpus;
 	cpumask_t		saved_mask;
-	cpumask_t		set_mask;
 	cpumask_t		covered_cpus;
 };
 
@@ -568,9 +566,7 @@ static int centrino_target (struct cpufr
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
 	CPUMASK_ALLOC(allmasks);
-	CPUMASK_PTR(online_policy_cpus, allmasks);
 	CPUMASK_PTR(saved_mask, allmasks);
-	CPUMASK_PTR(set_mask, allmasks);
 	CPUMASK_PTR(covered_cpus, allmasks);
 
 	if (unlikely(allmasks == NULL))
@@ -590,30 +586,28 @@ static int centrino_target (struct cpufr
 		goto out;
 	}
 
-#ifdef CONFIG_HOTPLUG_CPU
-	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(*online_policy_cpus, cpu_online_map, policy->cpus);
-#else
-	*online_policy_cpus = policy->cpus;
-#endif
-
 	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
 	cpus_clear(*covered_cpus);
-	for_each_cpu_mask_nr(j, *online_policy_cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
+		const cpumask_t *mask;
+
+		/* cpufreq holds the hotplug lock, so we are safe here */
+		if (!cpu_online(j))
+			continue;
+
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
 		 */
-		cpus_clear(*set_mask);
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			cpus_or(*set_mask, *set_mask, *online_policy_cpus);
+			mask = &policy->cpus;
 		else
-			cpu_set(j, *set_mask);
+			mask = &cpumask_of_cpu(j);
 
-		set_cpus_allowed_ptr(current, set_mask);
+		set_cpus_allowed_ptr(current, mask);
 		preempt_disable();
-		if (unlikely(!cpu_isset(smp_processor_id(), *set_mask))) {
+		if (unlikely(!cpu_isset(smp_processor_id(), *mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
@@ -641,7 +635,9 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, *online_policy_cpus) {
+			for_each_cpu_mask_nr(k, policy->cpus) {
+				if (!cpu_online(k))
+					continue;
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -664,7 +660,9 @@ static int centrino_target (struct cpufr
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, *online_policy_cpus) {
+	for_each_cpu_mask_nr(k, policy->cpus) {
+		if (!cpu_online(k))
+			continue;
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -677,18 +675,17 @@ static int centrino_target (struct cpufr
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(*covered_cpus))
-			for_each_cpu_mask_nr(j, *covered_cpus) {
-				set_cpus_allowed_ptr(current,
-						     &cpumask_of_cpu(j));
-				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
-			}
+		for_each_cpu_mask_nr(j, *covered_cpus) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(j));
+			wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
+		}
 
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask_nr(j, *online_policy_cpus) {
-			freqs.cpu = j;
+		for_each_cpu_mask_nr(j, policy->cpus) {
+			if (!cpu_online(j))
+				continue;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}

-- 
