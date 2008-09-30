Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYI3XDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYI3XDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYI3XDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:03:05 -0400
Received: from ozlabs.org ([203.10.76.45]:44374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYI3XDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:03:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: clean up speedctep-centrino and reduce cpumask_t usage
Date: Wed, 1 Oct 2008 09:01:54 +1000
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810010901.55127.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
2) The loop can simply skip over offline cpus, rather than creating a tmp mask.
3) set_mask is set to either a single cpu or all online cpus in a policy.
   Since it's just used for set_cpus_allowed(), any offline cpus in a policy
   don't matter, so we can just use cpumask_of_cpu() or the policy->cpus.

Note: untested, since I don't have such a system.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r dc205c205c8a arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28 18:04:20 2008 +1000
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c	Sun Sep 28 18:05:58 2008 +1000
@@ -459,9 +459,7 @@ static int centrino_verify (struct cpufr
  * Sets a new CPUFreq policy.
  */
 struct allmasks {
-	cpumask_t		online_policy_cpus;
 	cpumask_t		saved_mask;
-	cpumask_t		set_mask;
 	cpumask_t		covered_cpus;
 };
 
@@ -475,9 +473,7 @@ static int centrino_target (struct cpufr
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
 	CPUMASK_ALLOC(allmasks);
-	CPUMASK_PTR(online_policy_cpus, allmasks);
 	CPUMASK_PTR(saved_mask, allmasks);
-	CPUMASK_PTR(set_mask, allmasks);
 	CPUMASK_PTR(covered_cpus, allmasks);
 
 	if (unlikely(allmasks == NULL))
@@ -497,30 +493,28 @@ static int centrino_target (struct cpufr
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
@@ -548,7 +542,9 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, *online_policy_cpus) {
+			for_each_cpu_mask_nr(k, policy->cpus) {
+				if (!cpu_online(k))
+					continue;
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -571,7 +567,9 @@ static int centrino_target (struct cpufr
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, *online_policy_cpus) {
+	for_each_cpu_mask_nr(k, policy->cpus) {
+		if (!cpu_online(k))
+			continue;
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -584,18 +582,17 @@ static int centrino_target (struct cpufr
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
