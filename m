Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYLSACP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYLSACP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 19:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYLSAAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 19:00:36 -0500
Received: from relay1.sgi.com ([192.48.179.29]:59229 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588AbYLSAAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 19:00:31 -0500
Message-Id: <20081219000030.025808000@polaris-admin.engr.sgi.com>
References: <20081219000029.540121000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 16:00:32 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 3/8] cpumask: convert shared_cpu_map in acpi_processor* structs to cpumask_var_t From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:convert-acpi_processor-structs.patch
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
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   27 ++++++++++++++++++++++++---
 drivers/acpi/processor_core.c              |   14 ++++++++++----
 drivers/acpi/processor_perflib.c           |   14 +++++++-------
 drivers/acpi/processor_throttling.c        |   18 +++++++++---------
 include/acpi/processor.h                   |    4 ++--
 5 files changed, 52 insertions(+), 25 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ linux-2.6-for-ingo/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -517,6 +517,17 @@ acpi_cpufreq_guess_freq(struct acpi_cpuf
 	}
 }
 
+static void free_acpi_perf_data(void)
+{
+	unsigned int i;
+
+	/* Freeing a NULL pointer is OK, and alloc_percpu zeroes. */
+	for_each_possible_cpu(i)
+		free_cpumask_var(per_cpu_ptr(acpi_perf_data, i)
+				 ->shared_cpu_map);
+	free_percpu(acpi_perf_data);
+}
+
 /*
  * acpi_cpufreq_early_init - initialize ACPI P-States library
  *
@@ -527,6 +538,7 @@ acpi_cpufreq_guess_freq(struct acpi_cpuf
  */
 static int __init acpi_cpufreq_early_init(void)
 {
+	unsigned int i;
 	dprintk("acpi_cpufreq_early_init\n");
 
 	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
@@ -534,6 +546,15 @@ static int __init acpi_cpufreq_early_ini
 		dprintk("Memory allocation error for acpi_perf_data.\n");
 		return -ENOMEM;
 	}
+	for_each_possible_cpu(i) {
+		if (!alloc_cpumask_var(&per_cpu_ptr(acpi_perf_data, i)
+				       ->shared_cpu_map, GFP_KERNEL)) {
+
+			/* Freeing a NULL pointer is OK: alloc_percpu zeroes. */
+			free_acpi_perf_data();
+			return -ENOMEM;
+		}
+	}
 
 	/* Do initialization in ACPI core */
 	acpi_processor_preregister_performance(acpi_perf_data);
@@ -604,9 +625,9 @@ static int acpi_cpufreq_cpu_init(struct 
 	 */
 	if (policy->shared_type == CPUFREQ_SHARED_TYPE_ALL ||
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
-		policy->cpus = perf->shared_cpu_map;
+		cpumask_copy(&policy->cpus, perf->shared_cpu_map);
 	}
-	policy->related_cpus = perf->shared_cpu_map;
+	cpumask_copy(&policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
@@ -795,7 +816,7 @@ static int __init acpi_cpufreq_init(void
 
 	ret = cpufreq_register_driver(&acpi_cpufreq_driver);
 	if (ret)
-		free_percpu(acpi_perf_data);
+		free_acpi_perf_data();
 
 	return ret;
 }
--- linux-2.6-for-ingo.orig/drivers/acpi/processor_core.c
+++ linux-2.6-for-ingo/drivers/acpi/processor_core.c
@@ -826,6 +826,11 @@ static int acpi_processor_add(struct acp
 	if (!pr)
 		return -ENOMEM;
 
+	if (!alloc_cpumask_var(&pr->throttling.shared_cpu_map, GFP_KERNEL)) {
+		kfree(pr);
+		return -ENOMEM;
+	}
+
 	pr->handle = device->handle;
 	strcpy(acpi_device_name(device), ACPI_PROCESSOR_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PROCESSOR_CLASS);
@@ -845,10 +850,8 @@ static int acpi_processor_remove(struct 
 
 	pr = acpi_driver_data(device);
 
-	if (pr->id >= nr_cpu_ids) {
-		kfree(pr);
-		return 0;
-	}
+	if (pr->id >= nr_cpu_ids)
+		goto free;
 
 	if (type == ACPI_BUS_REMOVAL_EJECT) {
 		if (acpi_processor_handle_eject(pr))
@@ -873,6 +876,9 @@ static int acpi_processor_remove(struct 
 
 	per_cpu(processors, pr->id) = NULL;
 	per_cpu(processor_device_array, pr->id) = NULL;
+
+free:
+	free_cpumask_var(pr->throttling.shared_cpu_map);
 	kfree(pr);
 
 	return 0;
--- linux-2.6-for-ingo.orig/drivers/acpi/processor_perflib.c
+++ linux-2.6-for-ingo/drivers/acpi/processor_perflib.c
@@ -617,7 +617,7 @@ int acpi_processor_preregister_performan
 		}
 
 		pr->performance = percpu_ptr(performance, i);
-		cpu_set(i, pr->performance->shared_cpu_map);
+		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
 			continue;
@@ -660,7 +660,7 @@ int acpi_processor_preregister_performan
 			continue;
 
 		pdomain = &(pr->performance->domain_info);
-		cpu_set(i, pr->performance->shared_cpu_map);
+		cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 		cpu_set(i, covered_cpus);
 		if (pdomain->num_processors <= 1)
 			continue;
@@ -700,7 +700,7 @@ int acpi_processor_preregister_performan
 			}
 
 			cpu_set(j, covered_cpus);
-			cpu_set(j, pr->performance->shared_cpu_map);
+			cpumask_set_cpu(j, pr->performance->shared_cpu_map);
 			count++;
 		}
 
@@ -718,8 +718,8 @@ int acpi_processor_preregister_performan
 
 			match_pr->performance->shared_type = 
 					pr->performance->shared_type;
-			match_pr->performance->shared_cpu_map =
-				pr->performance->shared_cpu_map;
+			cpumask_copy(match_pr->performance->shared_cpu_map,
+				     pr->performance->shared_cpu_map);
 		}
 	}
 
@@ -731,8 +731,8 @@ err_ret:
 
 		/* Assume no coordination on any error parsing domain info */
 		if (retval) {
-			cpus_clear(pr->performance->shared_cpu_map);
-			cpu_set(i, pr->performance->shared_cpu_map);
+			cpumask_clear(pr->performance->shared_cpu_map);
+			cpumask_set_cpu(i, pr->performance->shared_cpu_map);
 			pr->performance->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 		}
 		pr->performance = NULL; /* Will be set for real in register */
--- linux-2.6-for-ingo.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6-for-ingo/drivers/acpi/processor_throttling.c
@@ -102,7 +102,7 @@ static int acpi_processor_update_tsd_coo
 		pthrottling = &pr->throttling;
 
 		pdomain = &(pthrottling->domain_info);
-		cpu_set(i, pthrottling->shared_cpu_map);
+		cpumask_set_cpu(i, pthrottling->shared_cpu_map);
 		cpu_set(i, covered_cpus);
 		/*
 		 * If the number of processor in the TSD domain is 1, it is
@@ -145,7 +145,7 @@ static int acpi_processor_update_tsd_coo
 			}
 
 			cpu_set(j, covered_cpus);
-			cpu_set(j, pthrottling->shared_cpu_map);
+			cpumask_set_cpu(j, pthrottling->shared_cpu_map);
 			count++;
 		}
 		for_each_possible_cpu(j) {
@@ -165,8 +165,8 @@ static int acpi_processor_update_tsd_coo
 			 * If some CPUS have the same domain, they
 			 * will have the same shared_cpu_map.
 			 */
-			match_pthrottling->shared_cpu_map =
-				pthrottling->shared_cpu_map;
+			cpumask_copy(match_pthrottling->shared_cpu_map,
+				     pthrottling->shared_cpu_map);
 		}
 	}
 
@@ -182,8 +182,8 @@ err_ret:
 		 */
 		if (retval) {
 			pthrottling = &(pr->throttling);
-			cpus_clear(pthrottling->shared_cpu_map);
-			cpu_set(i, pthrottling->shared_cpu_map);
+			cpumask_clear(pthrottling->shared_cpu_map);
+			cpumask_set_cpu(i, pthrottling->shared_cpu_map);
 			pthrottling->shared_type = DOMAIN_COORD_TYPE_SW_ALL;
 		}
 	}
@@ -567,7 +567,7 @@ static int acpi_processor_get_tsd(struct
 	pthrottling = &pr->throttling;
 	pthrottling->tsd_valid_flag = 1;
 	pthrottling->shared_type = pdomain->coord_type;
-	cpu_set(pr->id, pthrottling->shared_cpu_map);
+	cpumask_set_cpu(pr->id, pthrottling->shared_cpu_map);
 	/*
 	 * If the coordination type is not defined in ACPI spec,
 	 * the tsd_valid_flag will be clear and coordination type
@@ -1006,7 +1006,7 @@ int acpi_processor_set_throttling(struct
 	saved_mask = current->cpus_allowed;
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
-	cpus_and(online_throttling_cpus, cpu_online_map,
+	cpumask_and(&online_throttling_cpus, cpu_online_mask,
 			p_throttling->shared_cpu_map);
 	/*
 	 * The throttling notifier will be called for every
@@ -1120,7 +1120,7 @@ int acpi_processor_get_throttling_info(s
 	if (acpi_processor_get_tsd(pr)) {
 		pthrottling = &pr->throttling;
 		pthrottling->tsd_valid_flag = 0;
-		cpu_set(pr->id, pthrottling->shared_cpu_map);
+		cpumask_set_cpu(pr->id, &pthrottling->shared_cpu_map);
 		pthrottling->shared_type = DOMAIN_COORD_TYPE_SW_ALL;
 	}
 
--- linux-2.6-for-ingo.orig/include/acpi/processor.h
+++ linux-2.6-for-ingo/include/acpi/processor.h
@@ -127,7 +127,7 @@ struct acpi_processor_performance {
 	unsigned int state_count;
 	struct acpi_processor_px *states;
 	struct acpi_psd_package domain_info;
-	cpumask_t shared_cpu_map;
+	cpumask_var_t shared_cpu_map;
 	unsigned int shared_type;
 };
 
@@ -172,7 +172,7 @@ struct acpi_processor_throttling {
 	unsigned int state_count;
 	struct acpi_processor_tx_tss *states_tss;
 	struct acpi_tsd_package domain_info;
-	cpumask_t shared_cpu_map;
+	cpumask_var_t shared_cpu_map;
 	int (*acpi_processor_get_throttling) (struct acpi_processor * pr);
 	int (*acpi_processor_set_throttling) (struct acpi_processor * pr,
 					      int state);

-- 
