Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXHBSMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXHBSMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXHBSMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:12:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:17882 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbXHBSMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:12:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,214,1183359600"; 
   d="scan'208";a="275910500"
Date: Thu, 2 Aug 2007 11:06:38 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, venkatesh.pallipadi@intel.com,
       Arjan <arjan.van.de.ven@intel.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Subject: [PATCH] Fix some x86/x86-64 acpi-cpufreq driver issues
Message-ID: <20070802180638.GA3050@linux-os.sc.intel.com>
References: <20070613102541.7d58dafe.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613102541.7d58dafe.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch addresses some issues in x86/x86-64 acpi-cpufreq driver:

1. Current memory allocation for acpi_perf_data is actually open-coded
alloc_percpu(). The patch defines and handles acpi_perf_data as percpu data. The
code will be cleaner and easier to be maintained with this change.
2. Won't load driver in acpi_cpufreq_early_init() failure case.
3. Add __init for acpi_cpufreq_early_init().

Thanks.

-Fenghua


Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |   39 ++++++++++------------------
 drivers/acpi/processor_perflib.c            |    6 ++--
 include/acpi/processor.h                    |    2 -
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 32d04b0..705e13a 100644
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -68,7 +68,8 @@ struct acpi_cpufreq_data {
 };
 
 static struct acpi_cpufreq_data *drv_data[NR_CPUS];
-static struct acpi_processor_performance *acpi_perf_data[NR_CPUS];
+/* acpi_perf_data is a pointer to percpu data. */
+static struct acpi_processor_performance *acpi_perf_data;
 
 static struct cpufreq_driver acpi_cpufreq_driver;
 
@@ -508,24 +509,14 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
  * do _PDC and _PSD and find out the processor dependency for the
  * actual init that will happen later...
  */
-static int acpi_cpufreq_early_init(void)
+static int __init acpi_cpufreq_early_init(void)
 {
-	struct acpi_processor_performance *data;
-	unsigned int i, j;
-
 	dprintk("acpi_cpufreq_early_init\n");
 
-	for_each_possible_cpu(i) {
-		data = kzalloc(sizeof(struct acpi_processor_performance),
-			       GFP_KERNEL);
-		if (!data) {
-			for_each_possible_cpu(j) {
-				kfree(acpi_perf_data[j]);
-				acpi_perf_data[j] = NULL;
-			}
-			return -ENOMEM;
-		}
-		acpi_perf_data[i] = data;
+	acpi_perf_data = alloc_percpu(struct acpi_processor_performance);
+	if (!acpi_perf_data) {
+		dprintk("Memory allocation error for acpi_perf_data.\n");
+		return -ENOMEM;
 	}
 
 	/* Do initialization in ACPI core */
@@ -574,14 +565,11 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 
 	dprintk("acpi_cpufreq_cpu_init\n");
 
-	if (!acpi_perf_data[cpu])
-		return -ENODEV;
-
 	data = kzalloc(sizeof(struct acpi_cpufreq_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = acpi_perf_data[cpu];
+	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
 	drv_data[cpu] = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
@@ -778,24 +766,25 @@ static struct cpufreq_driver acpi_cpufreq_driver = {
 
 static int __init acpi_cpufreq_init(void)
 {
+	int ret;
+
 	dprintk("acpi_cpufreq_init\n");
 
-	acpi_cpufreq_early_init();
+	ret = acpi_cpufreq_early_init();
+	if (ret)
+		return ret;
 
 	return cpufreq_register_driver(&acpi_cpufreq_driver);
 }
 
 static void __exit acpi_cpufreq_exit(void)
 {
-	unsigned int i;
 	dprintk("acpi_cpufreq_exit\n");
 
 	cpufreq_unregister_driver(&acpi_cpufreq_driver);
 
-	for_each_possible_cpu(i) {
-		kfree(acpi_perf_data[i]);
-		acpi_perf_data[i] = NULL;
-	}
+	free_percpu(acpi_perf_data);
+
 	return;
 }
 
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index c4efc0c..463b024 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -539,7 +539,7 @@ end:
 }
 
 int acpi_processor_preregister_performance(
-		struct acpi_processor_performance **performance)
+		struct acpi_processor_performance *performance)
 {
 	int count, count_target;
 	int retval = 0;
@@ -567,12 +567,12 @@ int acpi_processor_preregister_performance(
 			continue;
 		}
 
-		if (!performance || !performance[i]) {
+		if (!performance || !percpu_ptr(performance, i)) {
 			retval = -EINVAL;
 			continue;
 		}
 
-		pr->performance = performance[i];
+		pr->performance = percpu_ptr(performance, i);
 		cpu_set(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index f9f987f..ec3ffda 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -232,7 +232,7 @@ struct acpi_processor_errata {
 
 extern int acpi_processor_preregister_performance(struct
 						  acpi_processor_performance
-						  **performance);
+						  *performance);
 
 extern int acpi_processor_register_performance(struct acpi_processor_performance
 					       *performance, unsigned int cpu);
