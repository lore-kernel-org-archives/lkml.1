Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYI2SJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYI2SJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYI2SDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36477 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753974AbYI2SCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.450074000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:07 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/31] cpumask: clean cpufreq files
Content-Disposition: inline; filename=clean-cpufreq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   46 +++++++++++-----------
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    2 
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   43 ++++++++++----------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h        |    2 
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   48 +++++++++++------------
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    2 
 drivers/cpufreq/cpufreq.c                        |    4 -
 include/linux/cpufreq.h                          |    4 -
 8 files changed, 77 insertions(+), 74 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -144,7 +144,7 @@ typedef union {
 
 struct drv_cmd {
 	unsigned int type;
-	cpumask_t mask;
+	cpumask_map_t mask;
 	drv_addr_union addr;
 	u32 val;
 };
@@ -189,44 +189,46 @@ static void do_drv_write(struct drv_cmd 
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
+	cpumask_var_t saved_mask;
 	cmd->val = 0;
 
-	set_cpus_allowed(current, &cmd->mask);
+	cpus_copy(saved_mask, current->cpus_allowed);
+	set_cpus_allowed(current, cmd->mask);
 	do_drv_read(cmd);
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
+	cpumask_var_t saved_mask;
 	unsigned int i;
 
+	cpus_copy(saved_mask, current->cpus_allowed);
 	for_each_cpu(i, cmd->mask) {
 		set_cpus_allowed(current, cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
 
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 	return;
 }
 
-static u32 get_cur_val(const cpumask_t *mask)
+static u32 get_cur_val(const_cpumask_t mask)
 {
 	struct acpi_processor_performance *perf;
 	struct drv_cmd cmd;
 
-	if (unlikely(cpus_empty(*mask)))
+	if (unlikely(cpus_empty(mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, cpus_first(*mask))->cpu_feature) {
+	switch (per_cpu(drv_data, cpus_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, cpus_first(*mask))->acpi_data;
+		perf = per_cpu(drv_data, cpus_first(mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -234,7 +236,7 @@ static u32 get_cur_val(const cpumask_t *
 		return 0;
 	}
 
-	cmd.mask = *mask;
+	cpus_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
@@ -266,11 +268,11 @@ static unsigned int get_measured_perf(un
 		u64 whole;
 	} aperf_cur, mperf_cur;
 
-	cpumask_t saved_mask;
+	cpumask_var_t saved_mask;
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	saved_mask = current->cpus_allowed;
+	cpus_copy(saved_mask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
@@ -329,7 +331,7 @@ static unsigned int get_measured_perf(un
 	retval = per_cpu(drv_data, cpu)->max_freq * perf_percent / 100;
 
 	put_cpu();
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 
 	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
@@ -363,7 +365,7 @@ static unsigned int get_cur_freq_on_cpu(
 	return freq;
 }
 
-static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
+static unsigned int check_freqs(const_cpumask_t mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;
@@ -384,7 +386,7 @@ static int acpi_cpufreq_target(struct cp
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
-	cpumask_t online_policy_cpus;
+	cpumask_var_t online_policy_cpus;
 	struct drv_cmd cmd;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
@@ -410,7 +412,7 @@ static int acpi_cpufreq_target(struct cp
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
 	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
 #else
-	online_policy_cpus = policy->cpus;
+	cpus_copy(online_policy_cpus, policy->cpus);
 #endif
 
 	next_perf_state = data->freq_table[next_state].index;
@@ -445,7 +447,7 @@ static int acpi_cpufreq_target(struct cp
 	cpus_clear(cmd.mask);
 
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cmd.mask = online_policy_cpus;
+		cpus_copy(cmd.mask, online_policy_cpus);
 	else
 		cpu_set(policy->cpu, cmd.mask);
 
@@ -459,7 +461,7 @@ static int acpi_cpufreq_target(struct cp
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(&cmd.mask, freqs.new, data)) {
+		if (!check_freqs(cmd.mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
 			return -EAGAIN;
@@ -599,15 +601,15 @@ static int acpi_cpufreq_cpu_init(struct 
 	 */
 	if (policy->shared_type == CPUFREQ_SHARED_TYPE_ALL ||
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-		policy->cpus = perf->shared_cpu_map;
+		cpus_copy(policy->cpus, perf->shared_cpu_map);
 	}
-	policy->related_cpus = perf->shared_cpu_map;
+	cpus_copy(policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
 	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		policy->cpus = per_cpu(cpu_core_map, cpu);
+		cpus_copy(policy->cpus, per_cpu(cpu_core_map, cpu));
 	}
 #endif
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -200,7 +200,7 @@ static int cpufreq_p4_cpu_init(struct cp
 	unsigned int i;
 
 #ifdef CONFIG_SMP
-	policy->cpus = per_cpu(cpu_sibling_map, policy->cpu);
+	cpus_copy(policy->cpus, per_cpu(cpu_sibling_map, policy->cpu));
 #endif
 
 	/* Errata workaround */
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -57,7 +57,7 @@ static DEFINE_PER_CPU(struct powernow_k8
 static int cpu_family = CPU_OPTERON;
 
 #ifndef CONFIG_SMP
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+DEFINE_PER_CPU(cpumask_map_t, cpu_core_map);
 #endif
 
 /* Return a frequency in MHz, given an input fid */
@@ -475,11 +475,11 @@ static int core_voltage_post_transition(
 
 static int check_supported_cpu(unsigned int cpu)
 {
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
-	oldmask = current->cpus_allowed;
+	cpus_copy(oldmask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 
 	if (smp_processor_id() != cpu) {
@@ -525,7 +525,7 @@ static int check_supported_cpu(unsigned 
 	rc = 1;
 
 out:
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 	return rc;
 }
 
@@ -963,7 +963,7 @@ static int transition_frequency_fidvid(s
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -971,7 +971,7 @@ static int transition_frequency_fidvid(s
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -994,7 +994,7 @@ static int transition_frequency_pstate(s
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1002,7 +1002,7 @@ static int transition_frequency_pstate(s
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -1012,7 +1012,7 @@ static int transition_frequency_pstate(s
 /* Driver entry point to switch to the target frequency */
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1026,7 +1026,7 @@ static int powernowk8_target(struct cpuf
 	checkvid = data->currvid;
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
+	cpus_copy(oldmask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
@@ -1082,7 +1082,7 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 	return ret;
 }
 
@@ -1101,7 +1101,7 @@ static int powernowk8_verify(struct cpuf
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask;
+	cpumask_var_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1152,7 +1152,7 @@ static int __cpuinit powernowk8_cpu_init
 	}
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
+	cpus_copy(oldmask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
@@ -1172,13 +1172,13 @@ static int __cpuinit powernowk8_cpu_init
 		fidvid_msr_init();
 
 	/* run on any CPU again */
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		cpus_copy(pol->cpus, cpumask_of_cpu(pol->cpu));
 	else
-		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
-	data->available_cores = &(pol->cpus);
+		cpus_copy(pol->cpus, per_cpu(cpu_core_map, pol->cpu));
+	data->available_cores = pol->cpus;
 
 	/* Take a crude guess here.
 	 * That guess was in microseconds, so multiply with 1000 */
@@ -1213,7 +1213,7 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out:
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
@@ -1240,7 +1240,7 @@ static int __devexit powernowk8_cpu_exit
 static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_var_t oldmask;
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1250,11 +1250,12 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
+	cpus_copy(oldmask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed(current, &oldmask);
+		set_cpus_allowed(current, oldmask);
 		return 0;
 	}
 
@@ -1269,7 +1270,7 @@ static unsigned int powernowk8_get (unsi
 
 
 out:
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 	return khz;
 }
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -38,7 +38,7 @@ struct powernow_k8_data {
 	/* we need to keep track of associated cores, but let cpufreq
 	 * handle hotplug events - so just point at cpufreq pol->cpus
 	 * structure */
-	cpumask_t *available_cores;
+	const_cpumask_t available_cores;
 };
 
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>	/* current */
 #include <linux/delay.h>
 #include <linux/compiler.h>
+#include <linux/cpumask_alloc.h>
 
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -416,9 +417,9 @@ static unsigned int get_cur_freq(unsigne
 {
 	unsigned l, h;
 	unsigned clock_freq;
-	cpumask_t saved_mask;
+	cpumask_var_t saved_mask;
 
-	saved_mask = current->cpus_allowed;
+	cpus_copy(saved_mask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
@@ -437,7 +438,7 @@ static unsigned int get_cur_freq(unsigne
 		clock_freq = extract_clock(l, cpu, 1);
 	}
 
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 	return clock_freq;
 }
 
@@ -552,10 +553,10 @@ static int centrino_verify (struct cpufr
  * Sets a new CPUFreq policy.
  */
 struct allmasks {
-	cpumask_t		online_policy_cpus;
-	cpumask_t		saved_mask;
-	cpumask_t		set_mask;
-	cpumask_t		covered_cpus;
+	cpumask_var_t		online_policy_cpus;
+	cpumask_var_t		saved_mask;
+	cpumask_var_t		set_mask;
+	cpumask_var_t		covered_cpus;
 };
 
 static int centrino_target (struct cpufreq_policy *policy,
@@ -592,28 +593,28 @@ static int centrino_target (struct cpufr
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(*online_policy_cpus, cpu_online_map, policy->cpus);
+	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
 #else
-	*online_policy_cpus = policy->cpus;
+	cpus_copy(online_policy_cpus, policy->cpus);
 #endif
 
-	*saved_mask = current->cpus_allowed;
+	cpus_copy(saved_mask, current->cpus_allowed);
 	first_cpu = 1;
-	cpus_clear(*covered_cpus);
-	for_each_cpu(j, *online_policy_cpus) {
+	cpus_clear(covered_cpus);
+	for_each_cpu(j, online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
 		 */
-		cpus_clear(*set_mask);
+		cpus_clear(set_mask);
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			cpus_or(*set_mask, *set_mask, *online_policy_cpus);
+			cpus_or(set_mask, set_mask, online_policy_cpus);
 		else
-			cpu_set(j, *set_mask);
+			cpu_set(j, set_mask);
 
 		set_cpus_allowed(current, set_mask);
 		preempt_disable();
-		if (unlikely(!cpu_isset(smp_processor_id(), *set_mask))) {
+		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
@@ -641,7 +642,7 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu(k, *online_policy_cpus) {
+			for_each_cpu(k, online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -660,11 +661,11 @@ static int centrino_target (struct cpufr
 			break;
 		}
 
-		cpu_set(j, *covered_cpus);
+		cpu_set(j, covered_cpus);
 		preempt_enable();
 	}
 
-	for_each_cpu(k, *online_policy_cpus) {
+	for_each_cpu(k, online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -677,17 +678,16 @@ static int centrino_target (struct cpufr
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(*covered_cpus))
-			for_each_cpu(j, *covered_cpus) {
-				set_cpus_allowed(current,
-						     cpumask_of_cpu(j));
+		if (!cpus_empty(covered_cpus))
+			for_each_cpu(j, covered_cpus) {
+				set_cpus_allowed(current, cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
 
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu(j, *online_policy_cpus) {
+		for_each_cpu(j, online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -229,7 +229,7 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-static unsigned int _speedstep_get(const cpumask_t *cpus)
+static unsigned int _speedstep_get(const_cpumask_t cpus)
 {
 	unsigned int speed;
 	cpumask_t cpus_allowed;
--- struct-cpumasks.orig/drivers/cpufreq/cpufreq.c
+++ struct-cpumasks/drivers/cpufreq/cpufreq.c
@@ -803,7 +803,7 @@ static int cpufreq_add_dev(struct sys_de
 	}
 
 	policy->cpu = cpu;
-	policy->cpus = cpumask_of_cpu(cpu);
+	cpus_copy(policy->cpus, cpumask_of_cpu(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
 	per_cpu(policy_cpu, cpu) = cpu;
@@ -856,7 +856,7 @@ static int cpufreq_add_dev(struct sys_de
 				goto err_out_driver_exit;
 
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
-			managed_policy->cpus = policy->cpus;
+			cpus_copy(managed_policy->cpus, policy->cpus);
 			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
--- struct-cpumasks.orig/include/linux/cpufreq.h
+++ struct-cpumasks/include/linux/cpufreq.h
@@ -80,8 +80,8 @@ struct cpufreq_real_policy {
 };
 
 struct cpufreq_policy {
-	cpumask_t		cpus;	/* CPUs requiring sw coordination */
-	cpumask_t		related_cpus; /* CPUs with any coordination */
+	cpumask_map_t		cpus;	/* CPUs requiring sw coordination */
+	cpumask_map_t		related_cpus; /* CPUs with any coordination */
 	unsigned int		shared_type; /* ANY or ALL affected CPUs
 						should set cpufreq */
 	unsigned int		cpu;    /* cpu nr of registered CPU */

-- 
