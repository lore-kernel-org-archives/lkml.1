Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbZADNTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbZADNTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZADNSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:13 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751303AbZADNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:08 -0500
Message-Id: <20090104131800.574985000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:04 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 05/11] x86: clean up speedstep-centrino and reduce cpumask_t usage From: Rusty Russell <rusty@rustcorp.com.au>
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=x86:speedstep-centrino-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

1) The #ifdef CONFIG_HOTPLUG_CPU seems unnecessary these days.
2) The loop can simply skip over offline cpus, rather than creating a tmp mask.
3) set_mask is set to either a single cpu or all online cpus in a policy.
   Since it's just used for set_cpus_allowed(), any offline cpus in a policy
   don't matter, so we can just use cpumask_of_cpu() or the policy->cpus.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   51 ++++++++++-------------
 1 file changed, 24 insertions(+), 27 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
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

