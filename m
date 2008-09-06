Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYIFXwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYIFXwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYIFXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38045 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753072AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235038.017894000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:44 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 08/13] cpufreq: Reduce stack size requirements in acpi-cpufreq.c
Content-Disposition: inline; filename=stack-hogs-acpi-cpufreq_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Make the following changes to acpi-cpufreq.c functions:

    - use node_to_cpumask_ptr in place of node_to_cpumask
    - use get_cpumask_var for temporary cpumask_t variables
    - use alloc_cpumask_ptr where available
    - use a per_cpu temp variable for drv_cmd which contains an
	embedded cpumask_t variable.

  * The resultant stack savings are:

    ====== Stack (-l 100)

	1 - initial
	2 - stack-hogs-acpi-cpufreq_c
	'.' is less than the limit(100)

       .1.    .2.    ..final..
      1608  -1024 584   -63%  acpi_cpufreq_target
      1096  -1096   .  -100%  sched_balance_self
      1048   -536 512   -51%  get_cur_val
       520   -520   .  -100%  get_measured_perf

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   93 +++++++++++++++++------------
 1 file changed, 57 insertions(+), 36 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,6 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
+#include <linux/cpumask_ptr.h>
 
 #include <linux/acpi.h>
 #include <acpi/processor.h>
@@ -68,6 +69,8 @@ struct acpi_cpufreq_data {
 };
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
+static DEFINE_PER_CPU(struct drv_cmd, temp_cmd);
+static DEFINE_PER_CPUMASK(temp_cpumask);
 
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
@@ -214,33 +217,39 @@ static void drv_write(struct drv_cmd *cm
 static u32 get_cur_val(const cpumask_t *mask)
 {
 	struct acpi_processor_performance *perf;
-	struct drv_cmd cmd;
+	struct drv_cmd *cmd;
+	u32 temp_val;
 
 	if (unlikely(cpus_empty(*mask)))
 		return 0;
 
+	cmd = &get_cpu_var(temp_cmd);
 	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
-		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
+		cmd->type = SYSTEM_INTEL_MSR_CAPABLE;
+		cmd->addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
-		cmd.type = SYSTEM_IO_CAPABLE;
+		cmd->type = SYSTEM_IO_CAPABLE;
 		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
-		cmd.addr.io.port = perf->control_register.address;
-		cmd.addr.io.bit_width = perf->control_register.bit_width;
+		cmd->addr.io.port = perf->control_register.address;
+		cmd->addr.io.bit_width = perf->control_register.bit_width;
 		break;
 	default:
+		put_cpu_var(temp_cmd);
 		return 0;
 	}
 
-	cmd.mask = *mask;
+	cmd->mask = *mask;
 
-	drv_read(&cmd);
+	drv_read(cmd);
 
-	dprintk("get_cur_val = %u\n", cmd.val);
+	temp_val = cmd->val;
+	put_cpu_var(temp_cmd);
 
-	return cmd.val;
+	dprintk("get_cur_val = %u\n", temp_val);
+
+	return temp_val;
 }
 
 /*
@@ -266,11 +275,12 @@ static unsigned int get_measured_perf(un
 		u64 whole;
 	} aperf_cur, mperf_cur;
 
-	cpumask_t saved_mask;
+	cpumask_ptr saved_mask;
 	unsigned int perf_percent;
 	unsigned int retval;
 
-	saved_mask = current->cpus_allowed;
+	get_cpumask_var(saved_mask, temp_cpumask);
+	*saved_mask = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
@@ -329,7 +339,8 @@ static unsigned int get_measured_perf(un
 	retval = per_cpu(drv_data, cpu)->max_freq * perf_percent / 100;
 
 	put_cpu();
-	set_cpus_allowed_ptr(current, &saved_mask);
+	set_cpus_allowed_ptr(current, saved_mask);
+	put_cpumask_var(saved_mask, temp_cpumask);
 
 	dprintk("cpu %d: performance percent %d\n", cpu, perf_percent);
 	return retval;
@@ -384,8 +395,8 @@ static int acpi_cpufreq_target(struct cp
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
-	cpumask_t online_policy_cpus;
-	struct drv_cmd cmd;
+	cpumask_ptr online_policy_cpus;
+	struct drv_cmd *cmd;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
@@ -394,9 +405,8 @@ static int acpi_cpufreq_target(struct cp
 	dprintk("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
 
 	if (unlikely(data == NULL ||
-	     data->acpi_data == NULL || data->freq_table == NULL)) {
+	     data->acpi_data == NULL || data->freq_table == NULL))
 		return -ENODEV;
-	}
 
 	perf = data->acpi_data;
 	result = cpufreq_frequency_table_target(policy,
@@ -406,11 +416,15 @@ static int acpi_cpufreq_target(struct cp
 	if (unlikely(result))
 		return -ENODEV;
 
+	/* obtain temp variables */
+	get_cpumask_var(online_policy_cpus, temp_cpumask);
+	cmd = &get_cpu_var(temp_cmd);
+
 #ifdef CONFIG_HOTPLUG_CPU
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
+	cpus_and(*online_policy_cpus, cpu_online_map, policy->cpus);
 #else
-	online_policy_cpus = policy->cpus;
+	*online_policy_cpus = policy->cpus;
 #endif
 
 	next_perf_state = data->freq_table[next_state].index;
@@ -422,56 +436,63 @@ static int acpi_cpufreq_target(struct cp
 		} else {
 			dprintk("Already at target state (P%d)\n",
 				next_perf_state);
-			return 0;
+			result = 0;
+			goto out;
 		}
 	}
 
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
-		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
-		cmd.addr.msr.reg = MSR_IA32_PERF_CTL;
-		cmd.val = (u32) perf->states[next_perf_state].control;
+		cmd->type = SYSTEM_INTEL_MSR_CAPABLE;
+		cmd->addr.msr.reg = MSR_IA32_PERF_CTL;
+		cmd->val = (u32) perf->states[next_perf_state].control;
 		break;
 	case SYSTEM_IO_CAPABLE:
-		cmd.type = SYSTEM_IO_CAPABLE;
-		cmd.addr.io.port = perf->control_register.address;
-		cmd.addr.io.bit_width = perf->control_register.bit_width;
-		cmd.val = (u32) perf->states[next_perf_state].control;
+		cmd->type = SYSTEM_IO_CAPABLE;
+		cmd->addr.io.port = perf->control_register.address;
+		cmd->addr.io.bit_width = perf->control_register.bit_width;
+		cmd->val = (u32) perf->states[next_perf_state].control;
 		break;
 	default:
-		return -ENODEV;
+		result = -ENODEV;
+		goto out;
 	}
 
-	cpus_clear(cmd.mask);
+	cpus_clear(cmd->mask);
 
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cmd.mask = online_policy_cpus;
+		cmd->mask = *online_policy_cpus;
 	else
-		cpu_set(policy->cpu, cmd.mask);
+		cpu_set(policy->cpu, cmd->mask);
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd->mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
 
-	drv_write(&cmd);
+	drv_write(cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(&cmd.mask, freqs.new, data)) {
+		if (!check_freqs(&cmd->mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
-			return -EAGAIN;
+			result = -EAGAIN;
+			goto out;
 		}
 	}
 
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd->mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
 	perf->state = next_perf_state;
 
+out:
+	put_cpumask_var(online_policy_cpus, temp_cpumask);
+	put_cpu_var(temp_cmd);
+
 	return result;
 }
 

-- 
