Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZJNGDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZJNGDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZJNGDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:58667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbZJNGDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:21 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/16] percpu: make percpu symbols in cpufreq unique
Date: Wed, 14 Oct 2009 15:01:56 +0900
Message-Id: <1255500125-3210-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in cpufreq such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* drivers/cpufreq/cpufreq.c: s/policy_cpu/cpufreq_policy_cpu/
* drivers/cpufreq/freq_table.c: s/show_table/cpufreq_show_table/
* arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: s/drv_data/acfreq_data/
  					      s/old_perf/acfreq_old_perf/

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   28 ++++++++++++++--------------
 drivers/cpufreq/cpufreq.c                  |   16 ++++++++--------
 drivers/cpufreq/freq_table.c               |   12 ++++++------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 7d5c3b0..43eb346 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -68,9 +68,9 @@ struct acpi_cpufreq_data {
 	unsigned int cpu_feature;
 };
 
-static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
+static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
-static DEFINE_PER_CPU(struct aperfmperf, old_perf);
+static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
 
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
@@ -214,14 +214,14 @@ static u32 get_cur_val(const struct cpumask *mask)
 	if (unlikely(cpumask_empty(mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, cpumask_first(mask))->cpu_feature) {
+	switch (per_cpu(acfreq_data, cpumask_first(mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, cpumask_first(mask))->acpi_data;
+		perf = per_cpu(acfreq_data, cpumask_first(mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
@@ -268,8 +268,8 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
 		return 0;
 
-	ratio = calc_aperfmperf_ratio(&per_cpu(old_perf, cpu), &perf);
-	per_cpu(old_perf, cpu) = perf;
+	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
+	per_cpu(acfreq_old_perf, cpu) = perf;
 
 	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
 
@@ -278,7 +278,7 @@ static unsigned int get_measured_perf(struct cpufreq_policy *policy,
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
-	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
 
@@ -322,7 +322,7 @@ static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 			       unsigned int target_freq, unsigned int relation)
 {
-	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 	struct acpi_processor_performance *perf;
 	struct cpufreq_freqs freqs;
 	struct drv_cmd cmd;
@@ -416,7 +416,7 @@ out:
 
 static int acpi_cpufreq_verify(struct cpufreq_policy *policy)
 {
-	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 
 	dprintk("acpi_cpufreq_verify\n");
 
@@ -563,7 +563,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return -ENOMEM;
 
 	data->acpi_data = per_cpu_ptr(acpi_perf_data, cpu);
-	per_cpu(drv_data, cpu) = data;
+	per_cpu(acfreq_data, cpu) = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
 		acpi_cpufreq_driver.flags |= CPUFREQ_CONST_LOOPS;
@@ -714,20 +714,20 @@ err_unreg:
 	acpi_processor_unregister_performance(perf, cpu);
 err_free:
 	kfree(data);
-	per_cpu(drv_data, cpu) = NULL;
+	per_cpu(acfreq_data, cpu) = NULL;
 
 	return result;
 }
 
 static int acpi_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
-	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 
 	dprintk("acpi_cpufreq_cpu_exit\n");
 
 	if (data) {
 		cpufreq_frequency_table_put_attr(policy->cpu);
-		per_cpu(drv_data, policy->cpu) = NULL;
+		per_cpu(acfreq_data, policy->cpu) = NULL;
 		acpi_processor_unregister_performance(data->acpi_data,
 						      policy->cpu);
 		kfree(data);
@@ -738,7 +738,7 @@ static int acpi_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 
 static int acpi_cpufreq_resume(struct cpufreq_policy *policy)
 {
-	struct acpi_cpufreq_data *data = per_cpu(drv_data, policy->cpu);
+	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, policy->cpu);
 
 	dprintk("acpi_cpufreq_resume\n");
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3938c78..af93a81 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -64,14 +64,14 @@ static DEFINE_SPINLOCK(cpufreq_driver_lock);
  * - Lock should not be held across
  *     __cpufreq_governor(data, CPUFREQ_GOV_STOP);
  */
-static DEFINE_PER_CPU(int, policy_cpu);
+static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
 int lock_policy_rwsem_##mode						\
 (int cpu)								\
 {									\
-	int policy_cpu = per_cpu(policy_cpu, cpu);			\
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
 	BUG_ON(policy_cpu == -1);					\
 	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 	if (unlikely(!cpu_online(cpu))) {				\
@@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(lock_policy_rwsem_write);
 
 void unlock_policy_rwsem_read(int cpu)
 {
-	int policy_cpu = per_cpu(policy_cpu, cpu);
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
@@ -98,7 +98,7 @@ EXPORT_SYMBOL_GPL(unlock_policy_rwsem_read);
 
 void unlock_policy_rwsem_write(int cpu)
 {
-	int policy_cpu = per_cpu(policy_cpu, cpu);
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
 	BUG_ON(policy_cpu == -1);
 	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
 }
@@ -799,7 +799,7 @@ int cpufreq_add_dev_policy(unsigned int cpu, struct cpufreq_policy *policy,
 
 			/* Set proper policy_cpu */
 			unlock_policy_rwsem_write(cpu);
-			per_cpu(policy_cpu, cpu) = managed_policy->cpu;
+			per_cpu(cpufreq_policy_cpu, cpu) = managed_policy->cpu;
 
 			if (lock_policy_rwsem_write(cpu) < 0) {
 				/* Should not go through policy unlock path */
@@ -906,7 +906,7 @@ int cpufreq_add_dev_interface(unsigned int cpu, struct cpufreq_policy *policy,
 	if (!cpu_online(j))
 		continue;
 		per_cpu(cpufreq_cpu_data, j) = policy;
-		per_cpu(policy_cpu, j) = policy->cpu;
+		per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -991,7 +991,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
-	per_cpu(policy_cpu, cpu) = cpu;
+	per_cpu(cpufreq_policy_cpu, cpu) = cpu;
 	ret = (lock_policy_rwsem_write(cpu) < 0);
 	WARN_ON(ret);
 
@@ -1946,7 +1946,7 @@ static int __init cpufreq_core_init(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		per_cpu(policy_cpu, cpu) = -1;
+		per_cpu(cpufreq_policy_cpu, cpu) = -1;
 		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
 	}
 
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index a9bd3a0..0543221 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -174,7 +174,7 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
-static DEFINE_PER_CPU(struct cpufreq_frequency_table *, show_table);
+static DEFINE_PER_CPU(struct cpufreq_frequency_table *, cpufreq_show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
@@ -185,10 +185,10 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf)
 	ssize_t count = 0;
 	struct cpufreq_frequency_table *table;
 
-	if (!per_cpu(show_table, cpu))
+	if (!per_cpu(cpufreq_show_table, cpu))
 		return -ENODEV;
 
-	table = per_cpu(show_table, cpu);
+	table = per_cpu(cpufreq_show_table, cpu);
 
 	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
@@ -217,20 +217,20 @@ void cpufreq_frequency_table_get_attr(struct cpufreq_frequency_table *table,
 				      unsigned int cpu)
 {
 	dprintk("setting show_table for cpu %u to %p\n", cpu, table);
-	per_cpu(show_table, cpu) = table;
+	per_cpu(cpufreq_show_table, cpu) = table;
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_attr);
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu)
 {
 	dprintk("clearing show_table for cpu %u\n", cpu);
-	per_cpu(show_table, cpu) = NULL;
+	per_cpu(cpufreq_show_table, cpu) = NULL;
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);
 
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu)
 {
-	return per_cpu(show_table, cpu);
+	return per_cpu(cpufreq_show_table, cpu);
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_get_table);
 
-- 
1.6.4.2

