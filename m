Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYAQHsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYAQHsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYAQHqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:46:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:29318 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbYAQHqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:46:12 -0500
X-ExtLoop1: 1
Subject: [PATCH 5/10] ACPI: register ACPI Processor as generic thermal
	cooling device
From: Zhang Rui <rui.zhang@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, rui.zhang@intel.com,
       sujith.thomas@intel.com, yakui.zhao@intel.com
Content-Type: text/plain
Date: Thu, 17 Jan 2008 15:51:23 +0800
Message-Id: <1200556283.2935.123.camel@acpi-sony.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

Register ACPI processor as thermal cooling devices.
A combination of processor T-state and P-state are used for thermal throttling.
the processor will reduce the frequency first and then set the T-state.

we use cpufreq_thermal_reduction_pctg to calculate the cpufreq limit,
and call cpufreq_verify_with_limit to set the cpufreq limit.
if cpufreq driver is loaded, then we have four cooling state for cpufreq control.
cooling state 0: cpufreq limit == max_freq
cooling state 1: cpufreq limit == max_freq * 80%
cooling state 2: cpufreq limit == max_freq * 60%
cooling state 3: cpufreq limit == max_freq * 40%

after the cpufreq limit is set to 40 percentage of the max_freq,
we use T-state for cooling.

eg. a processor has P-state support, and it has 8 T-state (T0-T7),
the max_state of the proceesor is 10:

state	cpufreq-limit  T-state
0:	max_freq	T0
1:	max_freq * 80%	T0
2:	max_freq * 60%	T0
3:	max_freq * 40%	T0
4:	max_freq * 40%	T1
5:	max_freq * 40%	T2
6:	max_freq * 40%	T3
7:	max_freq * 40%	T4
8:	max_freq * 40%	T5
9:	max_freq * 40%	T6
10:	max_freq * 40%	T7

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Thomas Sujith <sujith.thomas@intel.com>
---
 drivers/acpi/processor_core.c    |   23 ++++++
 drivers/acpi/processor_thermal.c |  134 +++++++++++++++++++++++++++++++++++++--
 include/acpi/processor.h         |    6 -
 3 files changed, 155 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/acpi/processor_thermal.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_thermal.c
+++ linux-2.6/drivers/acpi/processor_thermal.c
@@ -32,6 +32,7 @@
 #include <linux/cpufreq.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/sysdev.h>
 
 #include <asm/uaccess.h>
 
@@ -93,6 +94,9 @@ static int acpi_processor_apply_limit(st
  * _any_ cpufreq driver and not only the acpi-cpufreq driver.
  */
 
+#define CPUFREQ_THERMAL_MIN_STEP 0
+#define CPUFREQ_THERMAL_MAX_STEP 3
+
 static unsigned int cpufreq_thermal_reduction_pctg[NR_CPUS];
 static unsigned int acpi_thermal_cpufreq_is_init = 0;
 
@@ -109,8 +113,9 @@ static int acpi_thermal_cpufreq_increase
 	if (!cpu_has_cpufreq(cpu))
 		return -ENODEV;
 
-	if (cpufreq_thermal_reduction_pctg[cpu] < 60) {
-		cpufreq_thermal_reduction_pctg[cpu] += 20;
+	if (cpufreq_thermal_reduction_pctg[cpu] <
+		CPUFREQ_THERMAL_MAX_STEP) {
+		cpufreq_thermal_reduction_pctg[cpu]++;
 		cpufreq_update_policy(cpu);
 		return 0;
 	}
@@ -123,8 +128,9 @@ static int acpi_thermal_cpufreq_decrease
 	if (!cpu_has_cpufreq(cpu))
 		return -ENODEV;
 
-	if (cpufreq_thermal_reduction_pctg[cpu] > 20)
-		cpufreq_thermal_reduction_pctg[cpu] -= 20;
+	if (cpufreq_thermal_reduction_pctg[cpu] >
+		(CPUFREQ_THERMAL_MIN_STEP + 1))
+		cpufreq_thermal_reduction_pctg[cpu]--;
 	else
 		cpufreq_thermal_reduction_pctg[cpu] = 0;
 	cpufreq_update_policy(cpu);
@@ -143,7 +149,7 @@ static int acpi_thermal_cpufreq_notifier
 
 	max_freq =
 	    (policy->cpuinfo.max_freq *
-	     (100 - cpufreq_thermal_reduction_pctg[policy->cpu])) / 100;
+	     (100 - cpufreq_thermal_reduction_pctg[policy->cpu] * 20)) / 100;
 
 	cpufreq_verify_within_limits(policy, 0, max_freq);
 
@@ -155,6 +161,32 @@ static struct notifier_block acpi_therma
 	.notifier_call = acpi_thermal_cpufreq_notifier,
 };
 
+static int cpufreq_get_max_state(unsigned int cpu)
+{
+	if (!cpu_has_cpufreq(cpu))
+		return 0;
+
+	return CPUFREQ_THERMAL_MAX_STEP;
+}
+
+static int cpufreq_get_cur_state(unsigned int cpu)
+{
+	if (!cpu_has_cpufreq(cpu))
+		return 0;
+
+	return cpufreq_thermal_reduction_pctg[cpu];
+}
+
+static int cpufreq_set_cur_state(unsigned int cpu, int state)
+{
+	if (!cpu_has_cpufreq(cpu))
+		return 0;
+
+	cpufreq_thermal_reduction_pctg[cpu] = state;
+	cpufreq_update_policy(cpu);
+	return 0;
+}
+
 void acpi_thermal_cpufreq_init(void)
 {
 	int i;
@@ -179,6 +211,20 @@ void acpi_thermal_cpufreq_exit(void)
 }
 
 #else				/* ! CONFIG_CPU_FREQ */
+static int cpufreq_get_max_state(unsigned int cpu)
+{
+	return 0;
+}
+
+static int cpufreq_get_cur_state(unsigned int cpu)
+{
+	return 0;
+}
+
+static int cpufreq_set_cur_state(unsigned int cpu, int state)
+{
+	return 0;
+}
 
 static int acpi_thermal_cpufreq_increase(unsigned int cpu)
 {
@@ -310,6 +356,84 @@ int acpi_processor_get_limit_info(struct
 	return 0;
 }
 
+/* thermal coolign device callbacks */
+static int acpi_processor_max_state(struct acpi_processor *pr)
+{
+	int max_state = 0;
+
+	/*
+	 * There exists four states according to
+	 * cpufreq_thermal_reduction_ptg. 0, 1, 2, 3
+	 */
+	max_state += cpufreq_get_max_state(pr->id);
+	if (pr->flags.throttling)
+		max_state += (pr->throttling.state_count -1);
+
+	return max_state;
+}
+static int
+processor_get_max_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_processor *pr = acpi_driver_data(device);
+
+	if (!device || !pr)
+		return -EINVAL;
+
+	return sprintf(buf, "%d\n", acpi_processor_max_state(pr));
+}
+
+static int
+processor_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_processor *pr = acpi_driver_data(device);
+	int cur_state;
+
+	if (!device || !pr)
+		return -EINVAL;
+
+	cur_state = cpufreq_get_cur_state(pr->id);
+	if (pr->flags.throttling)
+		cur_state += pr->throttling.state;
+
+	return sprintf(buf, "%d\n", cur_state);
+}
+
+static int
+processor_set_cur_state(struct thermal_cooling_device *cdev, unsigned int state)
+{
+	struct acpi_device *device = cdev->devdata;
+	struct acpi_processor *pr = acpi_driver_data(device);
+	int result = 0;
+	int max_pstate;
+
+	if (!device || !pr)
+		return -EINVAL;
+
+	max_pstate = cpufreq_get_max_state(pr->id);
+
+	if (state > acpi_processor_max_state(pr))
+		return -EINVAL;
+
+	if (state <= max_pstate) {
+		if (pr->flags.throttling && pr->throttling.state)
+			result = acpi_processor_set_throttling(pr, 0);
+		cpufreq_set_cur_state(pr->id, state);
+	} else {
+		cpufreq_set_cur_state(pr->id, max_pstate);
+		result = acpi_processor_set_throttling(pr,
+				state - max_pstate);
+	}
+	return result;
+}
+
+struct thermal_cooling_device_ops processor_cooling_ops = {
+	.get_max_state = processor_get_max_state,
+	.get_cur_state = processor_get_cur_state,
+	.set_cur_state = processor_set_cur_state,
+};
+
 /* /proc interface */
 
 static int acpi_processor_limit_seq_show(struct seq_file *seq, void *offset)
Index: linux-2.6/include/acpi/processor.h
===================================================================
--- linux-2.6.orig/include/acpi/processor.h
+++ linux-2.6/include/acpi/processor.h
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
-
+#include <linux/thermal.h>
 #include <asm/acpi.h>
 
 #define ACPI_PROCESSOR_BUSY_METRIC	10
@@ -218,7 +218,7 @@ struct acpi_processor {
 	struct acpi_processor_performance *performance;
 	struct acpi_processor_throttling throttling;
 	struct acpi_processor_limit limit;
-
+	struct thermal_cooling_device *cdev;
 	/* the _PDC objects for this processor, if any */
 	struct acpi_object_list *pdc;
 };
@@ -330,7 +330,7 @@ extern struct cpuidle_driver acpi_idle_d
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);
 extern struct file_operations acpi_processor_limit_fops;
-
+extern struct thermal_cooling_device_ops processor_cooling_ops;
 #ifdef CONFIG_CPU_FREQ
 void acpi_thermal_cpufreq_init(void);
 void acpi_thermal_cpufreq_exit(void);
Index: linux-2.6/drivers/acpi/processor_core.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_core.c
+++ linux-2.6/drivers/acpi/processor_core.c
@@ -668,6 +668,24 @@ static int __cpuinit acpi_processor_star
 
 	acpi_processor_power_init(pr, device);
 
+	pr->cdev = thermal_cooling_device_register("Processor", device,
+						&processor_cooling_ops);
+	if (pr->cdev)
+		printk(KERN_INFO PREFIX
+			"%s is registered as cooling_device%d\n",
+			device->dev.bus_id, pr->cdev->id);
+	else
+		goto end;
+
+	result = sysfs_create_link(&device->dev.kobj, &pr->cdev->device.kobj,
+					"thermal_cooling");
+	if (result)
+		return result;
+	result = sysfs_create_link(&pr->cdev->device.kobj, &device->dev.kobj,
+					"device");
+	if (result)
+		return result;
+
 	if (pr->flags.throttling) {
 		printk(KERN_INFO PREFIX "%s [%s] (supports",
 		       acpi_device_name(device), acpi_device_bid(device));
@@ -791,6 +809,11 @@ static int acpi_processor_remove(struct 
 
 	acpi_processor_remove_fs(device);
 
+	sysfs_remove_link(&device->dev.kobj, "thermal_cooling");
+	sysfs_remove_link(&pr->cdev->device.kobj, "device");
+	thermal_cooling_device_unregister(pr->cdev);
+	pr->cdev = NULL;
+
 	processors[pr->id] = NULL;
 
 	kfree(pr);


