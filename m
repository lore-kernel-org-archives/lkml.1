Return-Path: <linux-kernel-owner+w=401wt.eu-S1763675AbZFKXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbZFKXAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbZFKW7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:59:34 -0400
Received: from ozlabs.org ([203.10.76.45]:37887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760810AbZFKW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:59:27 -0400
CC: linux-kernel@vger.kernel.org
To: davej@redhat.com
To: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 11 Jun 2009 22:59:58 +0930
Subject: [PATCH 3/6] cpumask: avoid playing with cpus_allowed in powernow-k8.c
Cc: mark.langsdorf@amd.com
Message-Id: <20090611225928.E6FF4DDDA1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

I did not replace powernowk8_target; it needs fixing, but it grabs a
mutex (so no smp_call_function_single here) but Mark points out it can
be called multiple times per second, so work_on_cpu is too heavy.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: davej@redhat.com
To: cpufreq@vger.kernel.org
Cc: mark.langsdorf@amd.com
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  156 +++++++++++++++---------------
 1 file changed, 82 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -510,41 +510,34 @@ static int core_voltage_post_transition(
 	return 0;
 }
 
-static int check_supported_cpu(unsigned int cpu)
+static void check_supported_cpu(void *_rc)
 {
-	cpumask_t oldmask;
 	u32 eax, ebx, ecx, edx;
-	unsigned int rc = 0;
+	int *rc = _rc;
 
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-	if (smp_processor_id() != cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
-		goto out;
-	}
+	*rc = -ENODEV;
 
 	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
-		goto out;
+		return;
 
 	eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
 	if (((eax & CPUID_XFAM) != CPUID_XFAM_K8) &&
 	    ((eax & CPUID_XFAM) < CPUID_XFAM_10H))
-		goto out;
+		return;
 
 	if ((eax & CPUID_XFAM) == CPUID_XFAM_K8) {
 		if (((eax & CPUID_USE_XFAM_XMOD) != CPUID_USE_XFAM_XMOD) ||
 		    ((eax & CPUID_XMOD) > CPUID_XMOD_REV_MASK)) {
 			printk(KERN_INFO PFX
 				"Processor cpuid %x not supported\n", eax);
-			goto out;
+			return;
 		}
 
 		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
 		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
 			printk(KERN_INFO PFX
 			       "No frequency change capabilities detected\n");
-			goto out;
+			return;
 		}
 
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
@@ -552,21 +545,17 @@ static int check_supported_cpu(unsigned 
 			!= P_STATE_TRANSITION_CAPABLE) {
 			printk(KERN_INFO PFX
 				"Power state transitions not supported\n");
-			goto out;
+			return;
 		}
 	} else { /* must be a HW Pstate capable processor */
 		cpuid(CPUID_FREQ_VOLT_CAPABILITIES, &eax, &ebx, &ecx, &edx);
 		if ((edx & USE_HW_PSTATE) == USE_HW_PSTATE)
 			cpu_family = CPU_HW_PSTATE;
 		else
-			goto out;
+			return;
 	}
 
-	rc = 1;
-
-out:
-	set_cpus_allowed_ptr(current, &oldmask);
-	return rc;
+	*rc = 0;
 }
 
 static int check_pst_table(struct powernow_k8_data *data, struct pst_s *pst,
@@ -1235,6 +1230,32 @@ static int powernowk8_verify(struct cpuf
 	return cpufreq_frequency_table_verify(pol, data->powernow_table);
 }
 
+struct init_on_cpu {
+	struct powernow_k8_data *data;
+	int rc;
+};
+
+static void __cpuinit powernowk8_cpu_init_on_cpu(void *_init_on_cpu)
+{
+	struct init_on_cpu *init_on_cpu = _init_on_cpu;
+
+	if (pending_bit_stuck()) {
+		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+		init_on_cpu->rc = -ENODEV;
+		return;
+	}
+
+	if (query_current_values_with_pending_wait(init_on_cpu->data)) {
+		init_on_cpu->rc = -ENODEV;
+		return;
+	}
+
+	if (cpu_family == CPU_OPTERON)
+		fidvid_msr_init();
+
+	init_on_cpu->rc = 0;
+}
+
 static const char ACPI_PSS_BIOS_BUG_MSG[] =
 	KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
 	KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
@@ -1243,13 +1264,14 @@ static const char ACPI_PSS_BIOS_BUG_MSG[
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask;
+	struct init_on_cpu init_on_cpu;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
 
-	if (!check_supported_cpu(pol->cpu))
+	smp_call_function_single(pol->cpu, check_supported_cpu, &rc, 1);
+	if (rc)
 		return -ENODEV;
 
 	data = kzalloc(sizeof(struct powernow_k8_data), GFP_KERNEL);
@@ -1289,27 +1311,12 @@ static int __cpuinit powernowk8_cpu_init
 		pol->cpuinfo.transition_latency = get_transition_latency(data);
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
-
-	if (smp_processor_id() != pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
-		goto err_out_unmask;
-	}
-
-	if (pending_bit_stuck()) {
-		printk(KERN_ERR PFX "failing init, change pending bit set\n");
-		goto err_out_unmask;
-	}
-
-	if (query_current_values_with_pending_wait(data))
-		goto err_out_unmask;
-
-	if (cpu_family == CPU_OPTERON)
-		fidvid_msr_init();
-
-	/* run on any CPU again */
-	set_cpus_allowed_ptr(current, &oldmask);
+	init_on_cpu.data = data;
+	smp_call_function_single(data->cpu, powernowk8_cpu_init_on_cpu,
+				 &init_on_cpu, 1);
+	rc = init_on_cpu.rc;
+	if (rc != 0)
+		goto err_out_exit_acpi;
 
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
@@ -1346,8 +1353,7 @@ static int __cpuinit powernowk8_cpu_init
 
 	return 0;
 
-err_out_unmask:
-	set_cpus_allowed_ptr(current, &oldmask);
+err_out_exit_acpi:
 	powernow_k8_cpu_exit_acpi(data);
 
 err_out:
@@ -1372,12 +1378,20 @@ static int __devexit powernowk8_cpu_exit
 	return 0;
 }
 
+static void query_values_on_cpu(void *_err)
+{
+	int *err = _err;
+	struct powernow_k8_data *data = __get_cpu_var(powernow_data);
+
+	*err = query_current_values_with_pending_wait(data);
+}
+
 static unsigned int powernowk8_get(unsigned int cpu)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = current->cpus_allowed;
 	unsigned int khz = 0;
 	unsigned int first;
+	int err;
 
 	first = cpumask_first(cpu_core_mask(cpu));
 	data = per_cpu(powernow_data, first);
@@ -1385,15 +1399,8 @@ static unsigned int powernowk8_get(unsig
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (smp_processor_id() != cpu) {
-		printk(KERN_ERR PFX
-			"limiting to CPU %d failed in powernowk8_get\n", cpu);
-		set_cpus_allowed_ptr(current, &oldmask);
-		return 0;
-	}
-
-	if (query_current_values_with_pending_wait(data))
+	smp_call_function_single(first, query_values_on_cpu, &err, true);
+	if (err)
 		goto out;
 
 	if (cpu_family == CPU_HW_PSTATE)
@@ -1404,7 +1411,6 @@ static unsigned int powernowk8_get(unsig
 
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return khz;
 }
 
@@ -1430,7 +1436,9 @@ static int __cpuinit powernowk8_init(voi
 	unsigned int i, supported_cpus = 0;
 
 	for_each_online_cpu(i) {
-		if (check_supported_cpu(i))
+		int rc;
+		smp_call_function_single(i, check_supported_cpu, &rc, 1);
+		if (rc == 0)
 			supported_cpus++;
 	}
 

