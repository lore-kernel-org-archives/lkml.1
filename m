Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZADNSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZADNSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZADNSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:09 -0500
Received: from relay3.sgi.com ([192.48.171.31]:38604 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750803AbZADNSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:08 -0500
Message-Id: <20090104131801.097814000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:08 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 09/11] cpumask: use cpumask_var_t in acpi-cpufreq.c
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:use-cpumask_var_t-in-acpi-cpufreq_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API.

Replace the cpumask_t in struct drv_cmd with a cpumask_var_t.  Remove unneeded
online_policy_cpus cpumask_t in acpi_cpufreq_target.  Update refs to use
new cpumask API.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   58 ++++++++++++++---------------
 1 file changed, 29 insertions(+), 29 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -145,7 +145,7 @@ typedef union {
 
 struct drv_cmd {
 	unsigned int type;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	drv_addr_union addr;
 	u32 val;
 };
@@ -193,7 +193,7 @@ static void drv_read(struct drv_cmd *cmd
 	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, &cmd->mask);
+	set_cpus_allowed_ptr(current, cmd->mask);
 	do_drv_read(cmd);
 	set_cpus_allowed_ptr(current, &saved_mask);
 }
@@ -203,8 +203,8 @@ static void drv_write(struct drv_cmd *cm
 	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
-	for_each_cpu_mask_nr(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+	for_each_cpu(i, cmd->mask) {
+		set_cpus_allowed_ptr(current, cpumask_of(i));
 		do_drv_write(cmd);
 	}
 
@@ -212,22 +212,22 @@ static void drv_write(struct drv_cmd *cm
 	return;
 }
 
-static u32 get_cur_val(const cpumask_t *mask)
+static u32 get_cur_val(const struct cpumask *mask)
 {
 	struct acpi_processor_performance *perf;
 	struct drv_cmd cmd;
 
-	if (unlikely(cpus_empty(*mask)))
+	if (unlikely(cpumask_empty(mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
+	switch (per_cpu(drv_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
+		perf = per_cpu(drv_data, cpumask_first(mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -235,7 +235,7 @@ static u32 get_cur_val(const cpumask_t *
 		return 0;
 	}
 
-	cmd.mask = *mask;
+	cpumask_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
@@ -386,7 +386,6 @@ static int acpi_cpufreq_target(struct cp
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
-	cpumask_t online_policy_cpus;
 	struct drv_cmd cmd;
 	unsigned int next_state = 0; /* Index into freq_table */
 	unsigned int next_perf_state = 0; /* Index into perf table */
@@ -401,20 +400,18 @@ static int acpi_cpufreq_target(struct cp
 		return -ENODEV;
 	}
 
+	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
+		return -ENOMEM;
+
 	perf = data->acpi_data;
 	result = cpufreq_frequency_table_target(policy,
 						data->freq_table,
 						target_freq,
 						relation, &next_state);
-	if (unlikely(result))
-		return -ENODEV;
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpumask_and(&online_policy_cpus, cpu_online_mask, policy->cpus);
-#else
-	online_policy_cpus = policy->cpus;
-#endif
+	if (unlikely(result)) {
+		result = -ENODEV;
+		goto out;
+	}
 
 	next_perf_state = data->freq_table[next_state].index;
 	if (perf->state == next_perf_state) {
@@ -425,7 +422,7 @@ static int acpi_cpufreq_target(struct cp
 		} else {
 			dprintk("Already at target state (P%d)\n",
 				next_perf_state);
-			return 0;
+			goto out;
 		}
 	}
 
@@ -444,19 +441,19 @@ static int acpi_cpufreq_target(struct cp
 		cmd.val = (u32) perf->states[next_perf_state].control;
 		break;
 	default:
-		return -ENODEV;
+		result = -ENODEV;
+		goto out;
 	}
 
-	cpus_clear(cmd.mask);
-
+	/* cpufreq holds the hotplug lock, so we are safe from here on */
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cmd.mask = online_policy_cpus;
+		cpumask_and(cmd.mask, cpu_online_mask, policy->cpus);
 	else
-		cpu_set(policy->cpu, cmd.mask);
+		cpumask_copy(cmd.mask, cpumask_of(policy->cpu));
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -464,19 +461,22 @@ static int acpi_cpufreq_target(struct cp
 	drv_write(&cmd);
 
 	if (acpi_pstate_strict) {
-		if (!check_freqs(&cmd.mask, freqs.new, data)) {
+		if (!check_freqs(cmd.mask, freqs.new, data)) {
 			dprintk("acpi_cpufreq_target failed (%d)\n",
 				policy->cpu);
-			return -EAGAIN;
+			result = -EAGAIN;
+			goto out;
 		}
 	}
 
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
 	perf->state = next_perf_state;
 
+out:
+	free_cpumask_var(cmd.mask);
 	return result;
 }
 

