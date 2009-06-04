Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZFDVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZFDVCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZFDVCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:02:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:53406 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZFDVCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:02:10 -0400
Message-ID: <4A28362B.7040804@kernel.org>
Date: Thu, 04 Jun 2009 14:01:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org>
In-Reply-To: <4A2835D8.6040903@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


avoid suprise when MAXSMP is enabled

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 54b6de2..71fe451 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -552,7 +552,7 @@ static int __init acpi_cpufreq_early_init(void)
 	for_each_possible_cpu(i) {
 		if (!alloc_cpumask_var_node(
 			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
-			GFP_KERNEL, cpu_to_node(i))) {
+			GFP_KERNEL | __GFP_ZERO, cpu_to_node(i))) {
 
 			/* Freeing a NULL pointer is OK: alloc_percpu zeroes. */
 			free_acpi_perf_data();
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
index a8363e5..17940ed 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -323,7 +323,7 @@ static int powernow_acpi_init(void)
 	}
 
 	if (!alloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
-								GFP_KERNEL)) {
+							GFP_KERNEL | __GFP_ZERO)) {
 		retval = -ENOMEM;
 		goto err05;
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index f6b32d1..2e9428a 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -886,7 +886,8 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map,
+	                         GFP_KERNEL | __GFP_ZERO)) {
 		printk(KERN_ERR PFX
 				"unable to alloc powernow_k8_data cpumask\n");
 		ret_val = -ENOMEM;
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index c9f1fdc..3a6a559 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -471,7 +471,8 @@ static int centrino_target (struct cpufreq_policy *policy,
 
 	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
-	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+	if (unlikely(!alloc_cpumask_var(&covered_cpus,
+					 GFP_KERNEL | __GFP_ZERO))) {
 		free_cpumask_var(saved_mask);
 		return -ENOMEM;
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1d0aa9c..3dbfd3a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1297,7 +1297,7 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL | __GFP_ZERO);
 
 	err = mce_init_banks();
 	if (err)
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 16f0fd4..2f718e2 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -844,7 +844,8 @@ static int __init uv_bau_init(void)
 
 	for_each_possible_cpu(cur_cpu)
 		alloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
-				       GFP_KERNEL, cpu_to_node(cur_cpu));
+				       GFP_KERNEL | __GFP_ZERO,
+				       cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
 	uv_nshift = uv_hub_info->n_val;
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 45ad328..62b854d 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -844,7 +844,8 @@ static int acpi_processor_add(struct acpi_device *device)
 	if (!pr)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map,
+			       GFP_KERNEL | __GFP_ZERO)) {
 		kfree(pr);
 		return -ENOMEM;
 	}
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 47d2ad0..28648a2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -808,7 +808,8 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
-	if (!alloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
+	if (!alloc_cpumask_var(&policy->related_cpus,
+				 GFP_KERNEL | __GFP_ZERO)) {
 		free_cpumask_var(policy->cpus);
 		kfree(policy);
 		ret = -ENOMEM;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index cdd3c89..ce7cec8 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -165,7 +165,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
 		vec->count = 0;
 		if (bootmem)
 			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL | __GFP_ZERO))
 			goto cleanup;
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f2c66f8..181cbe5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1592,7 +1592,8 @@ static inline void init_sched_rt_class(void)
 
 	for_each_possible_cpu(i)
 		alloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
-					GFP_KERNEL, cpu_to_node(i));
+					GFP_KERNEL | __GFP_ZERO,
+					cpu_to_node(i));
 }
 #endif /* CONFIG_SMP */
 
diff --git a/kernel/smp.c b/kernel/smp.c
index 858baac..0c7b82f 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -52,8 +52,9 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
+		if (!alloc_cpumask_var_node(&cfd->cpumask,
+					    GFP_KERNEL | __GFP_ZERO,
+					    cpu_to_node(cpu)))
 			return NOTIFY_BAD;
 		break;
 
