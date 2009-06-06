Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbZFFVw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbZFFVw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFFVwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFFVwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:52:19 -0400
Message-ID: <4A2AE4E8.7080405@kernel.org>
Date: Sat, 06 Jun 2009 14:51:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH 2/6] cpumask: alloc zeroed cpumask for static cpumask_var_ts
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com> <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are defined as static cpumask_var_t so if MAXSMP is not used,
they are cleared already.  Avoid suprises when MAXSMP is enabled.

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k7.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    2 +-
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c                 |    2 +-
 arch/x86/kernel/tlb_uv.c                         |    2 +-
 drivers/acpi/processor_core.c                    |    2 +-
 drivers/cpufreq/cpufreq.c                        |    2 +-
 kernel/sched_cpupri.c                            |    2 +-
 kernel/sched_rt.c                                |    2 +-
 kernel/smp.c                                     |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -550,7 +550,7 @@ static int __init acpi_cpufreq_early_ini
 		return -ENOMEM;
 	}
 	for_each_possible_cpu(i) {
-		if (!alloc_cpumask_var_node(
+		if (!zalloc_cpumask_var_node(
 			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
 			GFP_KERNEL, cpu_to_node(i))) {
 
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k7.c
@@ -322,7 +322,7 @@ static int powernow_acpi_init(void)
 		goto err0;
 	}
 
-	if (!alloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
+	if (!zalloc_cpumask_var(&acpi_processor_perf->shared_cpu_map,
 								GFP_KERNEL)) {
 		retval = -ENOMEM;
 		goto err05;
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -886,7 +886,7 @@ static int powernow_k8_cpu_init_acpi(str
 	/* notify BIOS that we exist */
 	acpi_processor_notify_smm(THIS_MODULE);
 
-	if (!alloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&data->acpi_data.shared_cpu_map, GFP_KERNEL)) {
 		printk(KERN_ERR PFX
 				"unable to alloc powernow_k8_data cpumask\n");
 		ret_val = -ENOMEM;
Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -471,7 +471,7 @@ static int centrino_target (struct cpufr
 
 	if (unlikely(!alloc_cpumask_var(&saved_mask, GFP_KERNEL)))
 		return -ENOMEM;
-	if (unlikely(!alloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
+	if (unlikely(!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL))) {
 		free_cpumask_var(saved_mask);
 		return -ENOMEM;
 	}
Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1297,7 +1297,7 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
 
 	err = mce_init_banks();
 	if (err)
Index: linux-2.6/arch/x86/kernel/tlb_uv.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tlb_uv.c
+++ linux-2.6/arch/x86/kernel/tlb_uv.c
@@ -843,7 +843,7 @@ static int __init uv_bau_init(void)
 		return 0;
 
 	for_each_possible_cpu(cur_cpu)
-		alloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
+		zalloc_cpumask_var_node(&per_cpu(uv_flush_tlb_mask, cur_cpu),
 				       GFP_KERNEL, cpu_to_node(cur_cpu));
 
 	uv_bau_retry_limit = 1;
Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c
+++ linux-2.6/drivers/acpi/processor_core.c
@@ -844,7 +844,7 @@ static int acpi_processor_add(struct acp
 	if (!pr)
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
 		kfree(pr);
 		return -ENOMEM;
 	}
Index: linux-2.6/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6.orig/drivers/cpufreq/cpufreq.c
+++ linux-2.6/drivers/cpufreq/cpufreq.c
@@ -808,7 +808,7 @@ static int cpufreq_add_dev(struct sys_de
 		ret = -ENOMEM;
 		goto nomem_out;
 	}
-	if (!alloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&policy->related_cpus, GFP_KERNEL)) {
 		free_cpumask_var(policy->cpus);
 		kfree(policy);
 		ret = -ENOMEM;
Index: linux-2.6/kernel/sched_cpupri.c
===================================================================
--- linux-2.6.orig/kernel/sched_cpupri.c
+++ linux-2.6/kernel/sched_cpupri.c
@@ -165,7 +165,7 @@ int __init_refok cpupri_init(struct cpup
 		vec->count = 0;
 		if (bootmem)
 			alloc_bootmem_cpumask_var(&vec->mask);
-		else if (!alloc_cpumask_var(&vec->mask, GFP_KERNEL))
+		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
 			goto cleanup;
 	}
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -1591,7 +1591,7 @@ static inline void init_sched_rt_class(v
 	unsigned int i;
 
 	for_each_possible_cpu(i)
-		alloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
+		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
 					GFP_KERNEL, cpu_to_node(i));
 }
 #endif /* CONFIG_SMP */
Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -52,7 +52,7 @@ hotplug_cfd(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!alloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
+		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
 				cpu_to_node(cpu)))
 			return NOTIFY_BAD;
 		break;
