Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYLTBCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYLTBCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYLTBA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:00:58 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40113 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753302AbYLTBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:55 -0500
Message-Id: <20081220010044.445374000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:47 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 4/8] cpumask: convert struct cpufreq_policy to cpumask_var_t. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:convert-drivers_acpi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce memory usage, use new API.

This is part of an effort to reduce structure sizes for machines
configured with large NR_CPUS.  cpumask_t gets replaced by
cpumask_var_t, which is either struct cpumask[1] (small NR_CPUS) or
struct cpumask * (large NR_CPUS).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   10 ++---
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    8 ++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    6 +--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h        |    2 -
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   14 +++----
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |   18 ++++-----
 drivers/acpi/processor_perflib.c                 |   13 ++++---
 drivers/acpi/processor_throttling.c              |   34 ++++++++++--------
 drivers/cpufreq/cpufreq.c                        |   42 +++++++++++++++--------
 drivers/cpufreq/cpufreq_conservative.c           |    2 -
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 include/linux/cpufreq.h                          |    4 +-
 12 files changed, 89 insertions(+), 68 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -411,7 +411,7 @@ static int acpi_cpufreq_target(struct cp
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
+	cpumask_and(&online_policy_cpus, cpu_online_mask, policy->cpus);
 #else
 	online_policy_cpus = policy->cpus;
 #endif
@@ -625,15 +625,15 @@ static int acpi_cpufreq_cpu_init(struct 
 	 */
 	if (policy->shared_type == CPUFREQ_SHARED_TYPE_ALL ||
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-		cpumask_copy(&policy->cpus, perf->shared_cpu_map);
+		cpumask_copy(policy->cpus, perf->shared_cpu_map);
 	}
-	cpumask_copy(&policy->related_cpus, perf->shared_cpu_map);
+	cpumask_copy(policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
-	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) == 1) {
+	if (bios_with_sw_any_bug && cpumask_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		policy->cpus = per_cpu(cpu_core_map, cpu);
+		cpumask_copy(policy->cpus, &per_cpu(cpu_core_map, cpu));
 	}
 #endif
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpuf
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpuf
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask_nr(i, policy->cpus)
+	for_each_cpu(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -200,7 +200,7 @@ static int cpufreq_p4_cpu_init(struct cp
 	unsigned int i;
 
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	/* Errata workaround */
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1193,10 +1193,10 @@ static int __cpuinit powernowk8_cpu_init
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
 	else
-		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
-	data->available_cores = &(pol->cpus);
+		cpumask_copy(pol->cpus, &per_cpu(cpu_core_map, pol->cpu));
+	data->available_cores = pol->cpus;
 
 	/* Take a crude guess here.
 	 * That guess was in microseconds, so multiply with 1000 */
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -53,7 +53,7 @@ struct powernow_k8_data {
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
-	cpumask_t *available_cores;
+	struct cpumask *available_cores;
 };
 
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -492,8 +492,8 @@ static int centrino_target (struct cpufr
 	}
 
 	first_cpu = 1;
-	for_each_cpu_mask_nr(j, policy->cpus) {
-		const cpumask_t *mask;
+	for_each_cpu(j, policy->cpus) {
+		const struct cpumask *mask;
 
 		/* cpufreq holds the hotplug lock, so we are safe here */
 		if (!cpu_online(j))
@@ -504,9 +504,9 @@ static int centrino_target (struct cpufr
 		 * Make sure we are running on CPU that wants to change freq
 		 */
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			mask = &policy->cpus;
+			mask = policy->cpus;
 		else
-			mask = &cpumask_of_cpu(j);
+			mask = cpumask_of(j);
 
 		set_cpus_allowed_ptr(current, mask);
 		preempt_disable();
@@ -538,7 +538,7 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, policy->cpus) {
+			for_each_cpu(k, policy->cpus) {
 				if (!cpu_online(k))
 					continue;
 				freqs.cpu = k;
@@ -563,7 +563,7 @@ static int centrino_target (struct cpufr
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, policy->cpus) {
+	for_each_cpu(k, policy->cpus) {
 		if (!cpu_online(k))
 			continue;
 		freqs.cpu = k;
@@ -586,7 +586,7 @@ static int centrino_target (struct cpufr
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			if (!cpu_online(j))
 				continue;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -229,7 +229,7 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-static unsigned int _speedstep_get(const cpumask_t *cpus)
+static unsigned int _speedstep_get(const struct cpumask *cpus)
 {
 	unsigned int speed;
 	cpumask_t cpus_allowed;
@@ -244,7 +244,7 @@ static unsigned int _speedstep_get(const
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	return _speedstep_get(cpumask_of(cpu));
 }
 
 /**
@@ -267,7 +267,7 @@ static int speedstep_target (struct cpuf
 	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0], target_freq, relation, &newstate))
 		return -EINVAL;
 
-	freqs.old = _speedstep_get(&policy->cpus);
+	freqs.old = _speedstep_get(policy->cpus);
 	freqs.new = speedstep_freqs[newstate].frequency;
 	freqs.cpu = policy->cpu;
 
@@ -279,20 +279,20 @@ static int speedstep_target (struct cpuf
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
 
 	/* switch to physical CPU where state is to be changed */
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed_ptr(current, policy->cpus);
 
 	speedstep_set_state(newstate);
 
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -322,11 +322,11 @@ static int speedstep_cpu_init(struct cpu
 
 	/* only run on CPU to be set, or on its sibling */
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpumask_copy(policy->cpus, &per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	cpus_allowed = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &policy->cpus);
+	set_cpus_allowed_ptr(current, policy->cpus);
 
 	/* detect low and high frequency and transition latency */
 	result = speedstep_get_freqs(speedstep_processor,
@@ -339,7 +339,7 @@ static int speedstep_cpu_init(struct cpu
 		return result;
 
 	/* get current speed setting */
-	speed = _speedstep_get(&policy->cpus);
+	speed = _speedstep_get(policy->cpus);
 	if (!speed)
 		return -EIO;
 
--- linux-2.6-for-ingo.orig/drivers/acpi/processor_perflib.c
+++ linux-2.6-for-ingo/drivers/acpi/processor_perflib.c
@@ -588,12 +588,15 @@ int acpi_processor_preregister_performan
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr;
 	struct acpi_psd_package *pdomain;
 	struct acpi_processor *match_pr;
 	struct acpi_psd_package *match_pdomain;
 
+	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	mutex_lock(&performance_mutex);
 
 	retval = 0;
@@ -650,18 +653,18 @@ int acpi_processor_preregister_performan
 		}
 	}
 
-	cpus_clear(covered_cpus);
+	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
 			continue;
 
-		if (cpu_isset(i, covered_cpus))
+		if (cpumask_test_cpu(i, covered_cpus))
 			continue;
 
 		pdomain = &(pr->performance->domain_info);
 		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
-		cpu_set(i, covered_cpus);
+		cpumask_set_cpu(i, covered_cpus);
 		if (pdomain->num_processors <= 1)
 			continue;
 
@@ -699,7 +702,7 @@ int acpi_processor_preregister_performan
 				goto err_ret;
 			}
 
-			cpu_set(j, covered_cpus);
+			cpumask_set_cpu(j, covered_cpus);
 			cpumask_set_cpu(j, pr->performance->shared_cpu_map);
 			count++;
 		}
--- linux-2.6-for-ingo.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6-for-ingo/drivers/acpi/processor_throttling.c
@@ -61,11 +61,14 @@ static int acpi_processor_update_tsd_coo
 	int count, count_target;
 	int retval = 0;
 	unsigned int i, j;
-	cpumask_t covered_cpus;
+	cpumask_var_t covered_cpus;
 	struct acpi_processor *pr, *match_pr;
 	struct acpi_tsd_package *pdomain, *match_pdomain;
 	struct acpi_processor_throttling *pthrottling, *match_pthrottling;
 
+	if (!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))
+		return -ENOMEM;
+
 	/*
 	 * Now that we have _TSD data from all CPUs, lets setup T-state
 	 * coordination between all CPUs.
@@ -91,19 +94,19 @@ static int acpi_processor_update_tsd_coo
 	if (retval)
 		goto err_ret;
 
-	cpus_clear(covered_cpus);
+	cpumask_clear(covered_cpus);
 	for_each_possible_cpu(i) {
 		pr = per_cpu(processors, i);
 		if (!pr)
 			continue;
 
-		if (cpu_isset(i, covered_cpus))
+		if (cpumask_test_cpu(i, covered_cpus))
 			continue;
 		pthrottling = &pr->throttling;
 
 		pdomain = &(pthrottling->domain_info);
 		cpumask_set_cpu(i, pthrottling->shared_cpu_map);
-		cpu_set(i, covered_cpus);
+		cpumask_set_cpu(i, covered_cpus);
 		/*
 		 * If the number of processor in the TSD domain is 1, it is
 		 * unnecessary to parse the coordination for this CPU.
@@ -144,7 +147,7 @@ static int acpi_processor_update_tsd_coo
 				goto err_ret;
 			}
 
-			cpu_set(j, covered_cpus);
+			cpumask_set_cpu(j, covered_cpus);
 			cpumask_set_cpu(j, pthrottling->shared_cpu_map);
 			count++;
 		}
@@ -171,16 +174,16 @@ static int acpi_processor_update_tsd_coo
 	}
 
 err_ret:
-	for_each_possible_cpu(i) {
-		pr = per_cpu(processors, i);
-		if (!pr)
-			continue;
+	if (retval) {
+		for_each_possible_cpu(i) {
+			pr = per_cpu(processors, i);
+			if (!pr)
+				continue;
 
-		/*
-		 * Assume no coordination on any error parsing domain info.
-		 * The coordination type will be forced as SW_ALL.
-		 */
-		if (retval) {
+			/*
+			 * Assume no coordination on any error parsing domain
+			 * info. The coordination type will be forced as SW_ALL.
+			 */
 			pthrottling = &(pr->throttling);
 			cpumask_clear(pthrottling->shared_cpu_map);
 			cpumask_set_cpu(i, pthrottling->shared_cpu_map);
@@ -188,6 +191,7 @@ err_ret:
 		}
 	}
 
+	free_cpumask_var(covered_cpus);
 	return retval;
 }
 
@@ -1120,7 +1124,7 @@ int acpi_processor_get_throttling_info(s
 	if (acpi_processor_get_tsd(pr)) {
 		pthrottling = &pr->throttling;
 		pthrottling->tsd_valid_flag = 0;
-		cpumask_set_cpu(pr->id, &pthrottling->shared_cpu_map);
+		cpumask_set_cpu(pr->id, pthrottling->shared_cpu_map);
 		pthrottling->shared_type = DOMAIN_COORD_TYPE_SW_ALL;
 	}
 
--- linux-2.6-for-ingo.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6-for-ingo/drivers/cpufreq/cpufreq.c
@@ -584,12 +584,12 @@ out:
 	return i;
 }
 
-static ssize_t show_cpus(cpumask_t mask, char *buf)
+static ssize_t show_cpus(const struct cpumask *mask, char *buf)
 {
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -606,7 +606,7 @@ static ssize_t show_cpus(cpumask_t mask,
  */
 static ssize_t show_related_cpus(struct cpufreq_policy *policy, char *buf)
 {
-	if (cpus_empty(policy->related_cpus))
+	if (cpumask_empty(policy->related_cpus))
 		return show_cpus(policy->cpus, buf);
 	return show_cpus(policy->related_cpus, buf);
 }
@@ -801,9 +801,20 @@ static int cpufreq_add_dev(struct sys_de
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
+	if (!alloc_cpumask_var(&policy->cpus, GFP_KERNEL)) {
+		kfree(policy);
+		ret = -ENOMEM;
+		goto nomem_out;
+	}
+	if (!alloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
+		free_cpumask_var(policy->cpus);
+		kfree(policy);
+		ret = -ENOMEM;
+		goto nomem_out;
+	}
 
 	policy->cpu = cpu;
-	policy->cpus = cpumask_of_cpu(cpu);
+	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
 	per_cpu(policy_cpu, cpu) = cpu;
@@ -838,7 +849,7 @@ static int cpufreq_add_dev(struct sys_de
 	}
 #endif
 
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -856,7 +867,7 @@ static int cpufreq_add_dev(struct sys_de
 				goto err_out_driver_exit;
 
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
-			managed_policy->cpus = policy->cpus;
+			cpumask_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -901,14 +912,14 @@ static int cpufreq_add_dev(struct sys_de
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))
@@ -948,7 +959,7 @@ static int cpufreq_add_dev(struct sys_de
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus)
+	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1009,7 +1020,7 @@ static int __cpufreq_remove_dev(struct s
 	 */
 	if (unlikely(cpu != data->cpu)) {
 		dprintk("removing link\n");
-		cpu_clear(cpu, data->cpus);
+		cpumask_clear_cpu(cpu, data->cpus);
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		sysfs_remove_link(&sys_dev->kobj, "cpufreq");
 		cpufreq_cpu_put(data);
@@ -1030,8 +1041,8 @@ static int __cpufreq_remove_dev(struct s
 	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove
 	 * the sysfs links afterwards.
 	 */
-	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			per_cpu(cpufreq_cpu_data, j) = NULL;
@@ -1040,8 +1051,8 @@ static int __cpufreq_remove_dev(struct s
 
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+	if (unlikely(cpumask_weight(data->cpus) > 1)) {
+		for_each_cpu(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
@@ -1075,7 +1086,10 @@ static int __cpufreq_remove_dev(struct s
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(data);
 
+	free_cpumask_var(data->related_cpus);
+	free_cpumask_var(data->cpus);
 	kfree(data);
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 	cpufreq_debug_enable_ratelimit();
 	return 0;
--- linux-2.6-for-ingo.orig/drivers/cpufreq/cpufreq_conservative.c
+++ linux-2.6-for-ingo/drivers/cpufreq/cpufreq_conservative.c
@@ -498,7 +498,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- linux-2.6-for-ingo.orig/drivers/cpufreq/cpufreq_ondemand.c
+++ linux-2.6-for-ingo/drivers/cpufreq/cpufreq_ondemand.c
@@ -400,7 +400,7 @@ static void dbs_check_cpu(struct cpu_dbs
 	/* Get Absolute Load - in terms of freq */
 	max_load_freq = 0;
 
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu(j, policy->cpus) {
 		struct cpu_dbs_info_s *j_dbs_info;
 		cputime64_t cur_wall_time, cur_idle_time;
 		unsigned int idle_time, wall_time;
@@ -568,7 +568,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- linux-2.6-for-ingo.orig/include/linux/cpufreq.h
+++ linux-2.6-for-ingo/include/linux/cpufreq.h
@@ -80,8 +80,8 @@ struct cpufreq_real_policy {
 };
 
 struct cpufreq_policy {
-	cpumask_t		cpus;	/* CPUs requiring sw coordination */
-	cpumask_t		related_cpus; /* CPUs with any coordination */
+	cpumask_var_t		cpus;	/* CPUs requiring sw coordination */
+	cpumask_var_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
 	unsigned int		cpu;    /* cpu nr of registered CPU */

-- 
