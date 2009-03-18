Return-Path: <linux-kernel-owner+w=401wt.eu-S1751761AbZCREWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbZCREWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZCREWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:22:21 -0400
Received: from ozlabs.org ([203.10.76.45]:59271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbZCREWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:22:19 -0400
CC: linux-kernel@vger.kernel.org
To: davej@redhat.com
To: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Mar 2009 10:40:25 +1030
Subject: [PATCH 6/9] cpumask: avoid playing with cpus_allowed in powernow-k8.c
Cc: mark.langsdorf@amd.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090318042217.8194ADDF31@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: don't play with current's cpumask

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

I use work_on_cpu, which is slightly less efficient than the old code,
but the code is complex enough that using smp_call_function_single()
is not trivial.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: davej@redhat.com
To: cpufreq@vger.kernel.org
Cc: mark.langsdorf@amd.com
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  130 +++++++++++++++---------------
 1 file changed, 66 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -483,19 +483,10 @@ static int core_voltage_post_transition(
 	return 0;
 }
 
-static int check_supported_cpu(unsigned int cpu)
+static long check_supported_cpu(void *unused)
 {
-	cpumask_t oldmask;
 	u32 eax, ebx, ecx, edx;
-	unsigned int rc = 0;
-
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-	if (smp_processor_id() != cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
-		goto out;
-	}
+	unsigned int rc = -ENODEV;
 
 	if (current_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		goto out;
@@ -532,10 +523,9 @@ static int check_supported_cpu(unsigned 
 			goto out;
 	}
 
-	rc = 1;
+	rc = 0;
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return rc;
 }
 
@@ -1047,10 +1037,16 @@ static int transition_frequency_pstate(s
 	return res;
 }
 
-/* Driver entry point to switch to the target frequency */
-static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
+struct target_data {
+	struct cpufreq_policy *pol;
+	unsigned targfreq;
+	unsigned relation;
+};
+
+static long powernowk8_target_on_cpu(void *_tdata)
 {
-	cpumask_t oldmask;
+	struct target_data *tdata = _tdata;
+	struct cpufreq_policy *pol = tdata->pol;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1063,22 +1059,13 @@ static int powernowk8_target(struct cpuf
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
-	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
-
-	if (smp_processor_id() != pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
-		goto err_out;
-	}
-
 	if (pending_bit_stuck()) {
 		printk(KERN_ERR PFX "failing targ, change pending bit set\n");
 		goto err_out;
 	}
 
 	dprintk("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
-		pol->cpu, targfreq, pol->min, pol->max, relation);
+		pol->cpu, tdata->targfreq, pol->min, pol->max, tdata->relation);
 
 	if (query_current_values_with_pending_wait(data))
 		goto err_out;
@@ -1094,7 +1081,9 @@ static int powernowk8_target(struct cpuf
 		}
 	}
 
-	if (cpufreq_frequency_table_target(pol, data->powernow_table, targfreq, relation, &newstate))
+	if (cpufreq_frequency_table_target(pol, data->powernow_table,
+					   tdata->targfreq, tdata->relation,
+					   &newstate))
 		goto err_out;
 
 	mutex_lock(&fidvid_mutex);
@@ -1120,8 +1109,17 @@ static int powernowk8_target(struct cpuf
 	ret = 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return ret;
+}
+
+/* Driver entry point to switch to the target frequency */
+static int powernowk8_target(struct cpufreq_policy *pol,
+			     unsigned targfreq, unsigned relation)
+{
+	struct target_data tdata = { .pol = pol,
+				     .targfreq = targfreq,
+				     .relation = relation };
+	return work_on_cpu(pol->cpu, powernowk8_target_on_cpu, &tdata);
 }
 
 /* Driver entry point to verify the policy and range of frequencies */
@@ -1135,18 +1133,41 @@ static int powernowk8_verify(struct cpuf
 	return cpufreq_frequency_table_verify(pol, data->powernow_table);
 }
 
+static long __cpuinit powernowk8_cpu_init_on_cpu(void *_data)
+{
+	struct powernow_k8_data *data = _data;
+
+	if (smp_processor_id() != data->cpu) {
+		printk(KERN_ERR PFX "limiting to cpu %u failed\n", data->cpu);
+		return -EIO;
+	}
+
+	if (pending_bit_stuck()) {
+		printk(KERN_ERR PFX "failing init, change pending bit set\n");
+		return -ENODEV;
+	}
+
+	if (query_current_values_with_pending_wait(data))
+		return -ENODEV;
+
+	if (cpu_family == CPU_OPTERON)
+		fidvid_msr_init();
+
+	return 0;
+}
+
 /* per CPU init entry point to the driver */
 static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask;
 	int rc;
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
 
-	if (!check_supported_cpu(pol->cpu))
-		return -ENODEV;
+	rc = work_on_cpu(pol->cpu, check_supported_cpu, NULL);
+	if (rc != 0)
+		return rc;
 
 	data = kzalloc(sizeof(struct powernow_k8_data), GFP_KERNEL);
 	if (!data) {
@@ -1199,27 +1220,9 @@ static int __cpuinit powernowk8_cpu_init
 		pol->cpuinfo.transition_latency = get_transition_latency(data);
 
 	/* only run on specific CPU from here on */
-	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
-
-	if (smp_processor_id() != pol->cpu) {
-		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
+	rc = work_on_cpu(data->cpu, powernowk8_cpu_init_on_cpu, data);
+	if (rc != 0)
 		goto err_out;
-	}
-
-	if (pending_bit_stuck()) {
-		printk(KERN_ERR PFX "failing init, change pending bit set\n");
-		goto err_out;
-	}
-
-	if (query_current_values_with_pending_wait(data))
-		goto err_out;
-
-	if (cpu_family == CPU_OPTERON)
-		fidvid_msr_init();
-
-	/* run on any CPU again */
-	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
 		cpumask_copy(pol->cpus, cpumask_of(pol->cpu));
@@ -1255,7 +1258,6 @@ static int __cpuinit powernowk8_cpu_init
 	return 0;
 
 err_out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	powernow_k8_cpu_exit_acpi(data);
 
 	kfree(data);
@@ -1279,12 +1281,20 @@ static int __devexit powernowk8_cpu_exit
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
 static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
-	cpumask_t oldmask = current->cpus_allowed;
 	unsigned int khz = 0;
 	unsigned int first;
+	int err;
 
 	first = first_cpu(per_cpu(cpu_core_map, cpu));
 	data = per_cpu(powernow_data, first);
@@ -1292,15 +1302,8 @@ static unsigned int powernowk8_get (unsi
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
@@ -1311,7 +1314,6 @@ static unsigned int powernowk8_get (unsi
 
 
 out:
-	set_cpus_allowed_ptr(current, &oldmask);
 	return khz;
 }
 
@@ -1337,7 +1339,7 @@ static int __cpuinit powernowk8_init(voi
 	unsigned int i, supported_cpus = 0;
 
 	for_each_online_cpu(i) {
-		if (check_supported_cpu(i))
+		if (work_on_cpu(i, check_supported_cpu, NULL) == 0)
 			supported_cpus++;
 	}
 

