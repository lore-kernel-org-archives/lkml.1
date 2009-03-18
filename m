Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZCREYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZCREYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZCREW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:22:26 -0400
Received: from ozlabs.org ([203.10.76.45]:59285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbZCREWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:22:21 -0400
CC: linux-kernel@vger.kernel.org
To: davej@redhat.com
To: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Mar 2009 10:40:25 +1030
Subject: [PATCH 7/9] cpumask: avoid cpumask games in arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090318042218.A0FB0DDF48@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't play with current's cpumask

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

Use rdmsr_on_cpu and wrmsr_on_cpu instead.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: davej@redhat.com
To: cpufreq@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   60 ++++++-----------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -323,14 +323,8 @@ static unsigned int get_cur_freq(unsigne
 {
 	unsigned l, h;
 	unsigned clock_freq;
-	cpumask_t saved_mask;
 
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (smp_processor_id() != cpu)
-		return 0;
-
-	rdmsr(MSR_IA32_PERF_STATUS, l, h);
+	rdmsr_on_cpu(cpu, MSR_IA32_PERF_STATUS, &l, &h);
 	clock_freq = extract_clock(l, cpu, 0);
 
 	if (unlikely(clock_freq == 0)) {
@@ -340,11 +334,9 @@ static unsigned int get_cur_freq(unsigne
 		 * P-state transition (like TM2). Get the last freq set 
 		 * in PERF_CTL.
 		 */
-		rdmsr(MSR_IA32_PERF_CTL, l, h);
+		rdmsr_on_cpu(cpu, MSR_IA32_PERF_CTL, &l, &h);
 		clock_freq = extract_clock(l, cpu, 1);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
 	return clock_freq;
 }
 
@@ -467,15 +459,10 @@ static int centrino_target (struct cpufr
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-	cpumask_var_t saved_mask, covered_cpus;
+	cpumask_var_t covered_cpus;
 
-	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
+	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL)))
 		return -ENOMEM;
-	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
-		free_cpumask_var(saved_mask);
-		return -ENOMEM;
-	}
-	cpumask_copy(saved_mask, &current->cpus_allowed);
 
 	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
 		retval = -ENODEV;
@@ -493,7 +480,7 @@ static int centrino_target (struct cpufr
 
 	first_cpu = 1;
 	for_each_cpu(j, policy->cpus) {
-		const struct cpumask *mask;
+		int good_cpu;
 
 		/* cpufreq holds the hotplug lock, so we are safe here */
 		if (!cpu_online(j))
@@ -504,32 +491,30 @@ static int centrino_target (struct cpufr
 		 * Make sure we are running on CPU that wants to change freq
 		 */
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			mask = policy->cpus;
+			good_cpu = cpumask_any_and(policy->cpus,
+						   cpu_online_mask);
 		else
-			mask = cpumask_of(j);
+			good_cpu = j;
 
-		set_cpus_allowed_ptr(current, mask);
-		preempt_disable();
-		if (unlikely(!cpu_isset(smp_processor_id(), *mask))) {
+		if (good_cpu >= nr_cpu_ids) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
 				/* We haven't started the transition yet. */
-				goto migrate_end;
+				goto out;
 			}
-			preempt_enable();
 			break;
 		}
 
 		msr = per_cpu(centrino_model, cpu)->op_points[newstate].index;
 
 		if (first_cpu) {
-			rdmsr(MSR_IA32_PERF_CTL, oldmsr, h);
+			rdmsr_on_cpu(good_cpu, MSR_IA32_PERF_CTL, &oldmsr, &h);
 			if (msr == (oldmsr & 0xffff)) {
 				dprintk("no change needed - msr was and needs "
 					"to be %x\n", oldmsr);
 				retval = 0;
-				goto migrate_end;
+				goto out;
 			}
 
 			freqs.old = extract_clock(oldmsr, cpu, 0);
@@ -553,14 +538,11 @@ static int centrino_target (struct cpufr
 			oldmsr |= msr;
 		}
 
-		wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
-		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-			preempt_enable();
+		wrmsr_on_cpu(good_cpu, MSR_IA32_PERF_CTL, oldmsr, h);
+		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
 			break;
-		}
 
-		cpu_set(j, *covered_cpus);
-		preempt_enable();
+		cpumask_set_cpu(j, covered_cpus);
 	}
 
 	for_each_cpu(k, policy->cpus) {
@@ -578,10 +560,8 @@ static int centrino_target (struct cpufr
 		 * Best effort undo..
 		 */
 
-		for_each_cpu_mask_nr(j, *covered_cpus) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(j));
-			wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
-		}
+		for_each_cpu(j, covered_cpus)
+			wrmsr_on_cpu(j, MSR_IA32_PERF_CTL, oldmsr, h);
 
 		tmp = freqs.new;
 		freqs.new = freqs.old;
@@ -593,15 +573,9 @@ static int centrino_target (struct cpufr
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}
 	}
-	set_cpus_allowed_ptr(current, saved_mask);
 	retval = 0;
-	goto out;
 
-migrate_end:
-	preempt_enable();
-	set_cpus_allowed_ptr(current, saved_mask);
 out:
-	free_cpumask_var(saved_mask);
 	free_cpumask_var(covered_cpus);
 	return retval;
 }

