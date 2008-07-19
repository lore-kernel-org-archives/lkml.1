Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbYGSBNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbYGSBNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYGSBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58452 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753856AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011128.108369000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:34 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, cpufreq@lists.linux.org.uk
Subject: [PATCH 8/8] NR_CPUS: Replace NR_CPUS in speedstep-centrino.c
Content-Disposition: inline; filename=repl-NR_CPUS-in-arch_x86_kernel_cpu_cpufreq_speedstep-centrino_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cleanups in speedstep-centrino.c for NR_CPUS=4096.

  * Use new CPUMASK_PTR (instead of old CPUMASK_VAR).

  * Replace arrays sized by NR_CPUS with percpu variables.

  * Cleanup some formatting problems (>80 chars per line)
    and other checkpatch complaints.

Applies to tip/master with following commit:

	commit 06f8d00e9eecb738c99b737ac38a585ea7583ad5
	Author: Mike Travis <travis@sgi.com>  2008-07-15 14:14:37
	Committer: Ingo Molnar <mingo@elte.hu>  2008-07-18 13:03:00
	Parent: 77586c2bdad0798cb24e35de5a878e7c6b200574 (cpumask: Provide a generic set of CPUMASK_ALLOC macros)
	Child:  06f8d00e9eecb738c99b737ac38a585ea7583ad5 (cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c, fix)
	Child:  32650cb6a8665a7635d025e52d9bf1905981ed11 (Merge branch 'cpus4096')
	Branches: -, devel, remotes/tip/cpus4096, remotes/tip/master, tip-latest

	cpumask: Use optimized CPUMASK_ALLOC macros in the centrino_target


Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: cpufreq@lists.linux.org.uk
---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   85 +++++++++++++----------
 1 file changed, 51 insertions(+), 34 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -28,7 +28,8 @@
 #define PFX		"speedstep-centrino: "
 #define MAINTAINER	"cpufreq@lists.linux.org.uk"
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
 
 #define INTEL_MSR_RANGE	(0xffff)
 
@@ -68,11 +69,12 @@ struct cpu_model
 
 	struct cpufreq_frequency_table *op_points; /* clock/voltage pairs */
 };
-static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c, const struct cpu_id *x);
+static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c,
+				  const struct cpu_id *x);
 
 /* Operating points for current CPU */
-static struct cpu_model *centrino_model[NR_CPUS];
-static const struct cpu_id *centrino_cpu[NR_CPUS];
+static DEFINE_PER_CPU(struct cpu_model *, centrino_model);
+static DEFINE_PER_CPU(const struct cpu_id *, centrino_cpu);
 
 static struct cpufreq_driver centrino_driver;
 
@@ -348,7 +350,7 @@ static int centrino_cpu_init_table(struc
 		return -ENOENT;
 	}
 
-	centrino_model[policy->cpu] = model;
+	per_cpu(centrino_model, policy->cpu) = model;
 
 	dprintk("found \"%s\": max frequency: %dkHz\n",
 	       model->model_name, model->max_freq);
@@ -357,10 +359,14 @@ static int centrino_cpu_init_table(struc
 }
 
 #else
-static inline int centrino_cpu_init_table(struct cpufreq_policy *policy) { return -ENODEV; }
+static inline int centrino_cpu_init_table(struct cpufreq_policy *policy)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE */
 
-static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c, const struct cpu_id *x)
+static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c,
+				  const struct cpu_id *x)
 {
 	if ((c->x86 == x->x86) &&
 	    (c->x86_model == x->x86_model) &&
@@ -379,23 +385,28 @@ static unsigned extract_clock(unsigned m
 	 * for centrino, as some DSDTs are buggy.
 	 * Ideally, this can be done using the acpi_data structure.
 	 */
-	if ((centrino_cpu[cpu] == &cpu_ids[CPU_BANIAS]) ||
-	    (centrino_cpu[cpu] == &cpu_ids[CPU_DOTHAN_A1]) ||
-	    (centrino_cpu[cpu] == &cpu_ids[CPU_DOTHAN_B0])) {
+	if ((per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_BANIAS]) ||
+	    (per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_DOTHAN_A1]) ||
+	    (per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_DOTHAN_B0])) {
 		msr = (msr >> 8) & 0xff;
 		return msr * 100000;
 	}
 
-	if ((!centrino_model[cpu]) || (!centrino_model[cpu]->op_points))
+	if ((!per_cpu(centrino_model, cpu)) ||
+	    (!per_cpu(centrino_model, cpu)->op_points))
 		return 0;
 
 	msr &= 0xffff;
-	for (i=0;centrino_model[cpu]->op_points[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (msr == centrino_model[cpu]->op_points[i].index)
-			return centrino_model[cpu]->op_points[i].frequency;
+	for (i = 0;
+		per_cpu(centrino_model, cpu)->op_points[i].frequency
+							!= CPUFREQ_TABLE_END;
+	     i++) {
+		if (msr == per_cpu(centrino_model, cpu)->op_points[i].index)
+			return per_cpu(centrino_model, cpu)->
+							op_points[i].frequency;
 	}
 	if (failsafe)
-		return centrino_model[cpu]->op_points[i-1].frequency;
+		return per_cpu(centrino_model, cpu)->op_points[i-1].frequency;
 	else
 		return 0;
 }
@@ -441,7 +452,8 @@ static int centrino_cpu_init(struct cpuf
 	int i;
 
 	/* Only Intel makes Enhanced Speedstep-capable CPUs */
-	if (cpu->x86_vendor != X86_VENDOR_INTEL || !cpu_has(cpu, X86_FEATURE_EST))
+	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
+	    !cpu_has(cpu, X86_FEATURE_EST))
 		return -ENODEV;
 
 	if (cpu_has(cpu, X86_FEATURE_CONSTANT_TSC))
@@ -455,9 +467,9 @@ static int centrino_cpu_init(struct cpuf
 			break;
 
 	if (i != N_IDS)
-		centrino_cpu[policy->cpu] = &cpu_ids[i];
+		per_cpu(centrino_cpu, policy->cpu) = &cpu_ids[i];
 
-	if (!centrino_cpu[policy->cpu]) {
+	if (!per_cpu(centrino_cpu, policy->cpu)) {
 		dprintk("found unsupported CPU with "
 		"Enhanced SpeedStep: send /proc/cpuinfo to "
 		MAINTAINER "\n");
@@ -480,23 +492,26 @@ static int centrino_cpu_init(struct cpuf
 		/* check to see if it stuck */
 		rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 		if (!(l & (1<<16))) {
-			printk(KERN_INFO PFX "couldn't enable Enhanced SpeedStep\n");
+			printk(KERN_INFO PFX
+				"couldn't enable Enhanced SpeedStep\n");
 			return -ENODEV;
 		}
 	}
 
 	freq = get_cur_freq(policy->cpu);
-
-	policy->cpuinfo.transition_latency = 10000; /* 10uS transition latency */
+	policy->cpuinfo.transition_latency = 10000;
+						/* 10uS transition latency */
 	policy->cur = freq;
 
 	dprintk("centrino_cpu_init: cur=%dkHz\n", policy->cur);
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, centrino_model[policy->cpu]->op_points);
+	ret = cpufreq_frequency_table_cpuinfo(policy,
+		per_cpu(centrino_model, policy->cpu)->op_points);
 	if (ret)
 		return (ret);
 
-	cpufreq_frequency_table_get_attr(centrino_model[policy->cpu]->op_points, policy->cpu);
+	cpufreq_frequency_table_get_attr(
+		per_cpu(centrino_model, policy->cpu)->op_points, policy->cpu);
 
 	return 0;
 }
@@ -505,12 +520,12 @@ static int centrino_cpu_exit(struct cpuf
 {
 	unsigned int cpu = policy->cpu;
 
-	if (!centrino_model[cpu])
+	if (!per_cpu(centrino_model, cpu))
 		return -ENODEV;
 
 	cpufreq_frequency_table_put_attr(cpu);
 
-	centrino_model[cpu] = NULL;
+	per_cpu(centrino_model, cpu) = NULL;
 
 	return 0;
 }
@@ -524,14 +539,16 @@ static int centrino_cpu_exit(struct cpuf
  */
 static int centrino_verify (struct cpufreq_policy *policy)
 {
-	return cpufreq_frequency_table_verify(policy, centrino_model[policy->cpu]->op_points);
+	return cpufreq_frequency_table_verify(policy,
+			per_cpu(centrino_model, policy->cpu)->op_points);
 }
 
 /**
  * centrino_setpolicy - set a new CPUFreq policy
  * @policy: new policy
  * @target_freq: the target frequency
- * @relation: how that frequency relates to achieved frequency (CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
+ * @relation: how that frequency relates to achieved frequency
+ *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
  *
  * Sets a new CPUFreq policy.
  */
@@ -552,21 +569,21 @@ static int centrino_target (struct cpufr
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
 	CPUMASK_ALLOC(allmasks);
-	CPUMASK_VAR(online_policy_cpus, allmasks);
-	CPUMASK_VAR(saved_mask, allmasks);
-	CPUMASK_VAR(set_mask, allmasks);
-	CPUMASK_VAR(covered_cpus, allmasks);
+	CPUMASK_PTR(online_policy_cpus, allmasks);
+	CPUMASK_PTR(saved_mask, allmasks);
+	CPUMASK_PTR(set_mask, allmasks);
+	CPUMASK_PTR(covered_cpus, allmasks);
 
 	if (unlikely(allmasks == NULL))
 		return -ENOMEM;
 
-	if (unlikely(centrino_model[cpu] == NULL)) {
+	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
 		retval = -ENODEV;
 		goto out;
 	}
 
 	if (unlikely(cpufreq_frequency_table_target(policy,
-			centrino_model[cpu]->op_points,
+			per_cpu(centrino_model, cpu)->op_points,
 			target_freq,
 			relation,
 			&newstate))) {
@@ -608,7 +625,7 @@ static int centrino_target (struct cpufr
 			break;
 		}
 
-		msr = centrino_model[cpu]->op_points[newstate].index;
+		msr = per_cpu(centrino_model, cpu)->op_points[newstate].index;
 
 		if (first_cpu) {
 			rdmsr(MSR_IA32_PERF_CTL, oldmsr, h);

-- 
