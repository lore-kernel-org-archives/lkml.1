Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYEZObb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYEZObb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYEZObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:31:22 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:44191 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbYEZObV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:31:21 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 1/3] General framework for APERF/MPERF access and
	accounting
To: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Date: Mon, 26 May 2008 20:01:38 +0530
Message-ID: <20080526143138.24680.99086.stgit@drishya.in.ibm.com>
In-Reply-To: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

General framework for low level APERF/MPERF access.
* Avoid resetting APERF/MPERF in acpi-cpufreq.c
* Implement functions that will calculate the scaled stats
* acpi_get_pm_msrs_delta() will give delta values after reading the current values
* Change get_measured_perf() to use acpi_get_pm_msrs_delta()
* scaled_stats_init() detect availability of APERF/MPERF using cpuid
* reset_for_scaled_stats() called when a process occupies the CPU
* account_scaled_stats() is called when the process leaves the CPU

Signed-off-by: Amit K. Arora <aarora@linux.vnet.ibm.com>
Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   21 +++
 arch/x86/kernel/time_32.c                  |  171 ++++++++++++++++++++++++++++
 2 files changed, 188 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index b0c8208..761beec 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -59,6 +59,13 @@ enum {
 #define INTEL_MSR_RANGE		(0xffff)
 #define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
 
+/* Buffer to store old snapshot values */
+DEFINE_PER_CPU(u64, cpufreq_old_aperf);
+DEFINE_PER_CPU(u64, cpufreq_old_mperf);
+
+extern void acpi_get_pm_msrs_delta(u64 *aperf_delta, u64 *mperf_delta,
+				   u64 *aperf_old, u64 *mperf_old, int reset);
+
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
 	struct cpufreq_frequency_table *freq_table;
@@ -265,6 +272,7 @@ static unsigned int get_measured_perf(unsigned int cpu)
 		} split;
 		u64 whole;
 	} aperf_cur, mperf_cur;
+	u64 *aperf_old, *mperf_old;
 
 	cpumask_t saved_mask;
 	unsigned int perf_percent;
@@ -278,11 +286,16 @@ static unsigned int get_measured_perf(unsigned int cpu)
 		return 0;
 	}
 
-	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
-	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
+	/*
+	 * Get the old APERF/MPERF values for this cpu and pass it to
+	 * acpi_get_pm_msrs_delta() which will read the current values
+	 * and return the delta.
+	 */
+	aperf_old = &(per_cpu(cpufreq_old_aperf, smp_processor_id()));
+	mperf_old = &(per_cpu(cpufreq_old_mperf, smp_processor_id()));
 
-	wrmsr(MSR_IA32_APERF, 0,0);
-	wrmsr(MSR_IA32_MPERF, 0,0);
+	acpi_get_pm_msrs_delta(&aperf_cur.whole, &mperf_cur.whole, 
+				aperf_old, mperf_old, 1);
 
 #ifdef __i386__
 	/*
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 2ff21f3..5131e01 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -32,10 +32,13 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/processor.h>
+#include <asm/cputime.h>
 
 #include "do_timer.h"
 
@@ -136,3 +139,171 @@ void __init time_init(void)
 	tsc_init();
 	late_time_init = choose_time_init();
 }
+
+/*
+ * This function should be used to get the APERF/MPERF MSRS delta from the cpu.
+ * We let the individual users of this function store the old values of APERF
+ * and MPERF registers in per cpu variables. They pass these old values as 3rd
+ * and 4th arguments. 'reset' tells if the old values should be reset or not.
+ * Mostly, users of this function will like to reset the old values.
+ */
+void acpi_get_pm_msrs_delta(u64 *aperf_delta, u64 *mperf_delta, u64 *aperf_old,
+				u64 *mperf_old, int reset)
+{
+	union {
+		struct {
+			u32 lo;
+			u32 hi;
+		} split;
+		u64 whole;
+	} aperf_cur, mperf_cur;
+	unsigned long flags;
+
+	/* Read current values of APERF and MPERF MSRs*/
+	local_irq_save(flags);
+	rdmsr(MSR_IA32_MPERF, mperf_cur.split.lo, mperf_cur.split.hi);
+	rdmsr(MSR_IA32_APERF, aperf_cur.split.lo, aperf_cur.split.hi);
+	local_irq_restore(flags);
+
+	/*
+	 * If the new values are less than the previous values, there has
+	 * been an overflow and both APERF and MPERF have been reset to
+	 * zero. In this case consider absolute value as diff/delta.
+	 * Note that we do not check for 'reset' here, since resetting here
+	 * is no more optional and has to be done for values to make sense.
+	 */
+	if (unlikely((mperf_cur.whole <= *mperf_old) ||
+			(aperf_cur.whole <= *aperf_old)))
+	{
+		*aperf_old = 0;
+		*mperf_old = 0;
+	}
+
+	/* Calculate the delta from the current and per cpu old values */
+	*mperf_delta = mperf_cur.whole - *mperf_old;
+	*aperf_delta = aperf_cur.whole - *aperf_old;
+
+	/* Set the per cpu variables to current readings */
+	if (reset) {
+		*mperf_old = mperf_cur.whole;
+		*aperf_old = aperf_cur.whole;
+	}
+}
+EXPORT_SYMBOL(acpi_get_pm_msrs_delta);
+
+
+DEFINE_PER_CPU(u64, cputime_old_aperf);
+DEFINE_PER_CPU(u64, cputime_old_mperf);
+
+DEFINE_PER_CPU(cputime_t, task_utime_old);
+DEFINE_PER_CPU(cputime_t, task_stime_old);
+
+
+#define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
+
+static int cpu_supports_freq_scaling;
+
+/* Initialize scaled stat functions */
+void scaled_stats_init(void)
+{
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	/* Check for APERF/MPERF support in hardware */
+	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
+		unsigned int ecx;
+		ecx = cpuid_ecx(6);
+		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
+			cpu_supports_freq_scaling = 1;
+		else
+			cpu_supports_freq_scaling = -1;
+	}
+}
+	
+/*
+ * Reset the old utime and stime (percpu) value to the new task
+ * that we are going to switch to.
+ */
+void reset_for_scaled_stats(struct task_struct *tsk)
+{
+	u64 aperf_delta, mperf_delta;
+	u64 *aperf_old, *mperf_old;
+
+	if (cpu_supports_freq_scaling < 0)
+		return;
+
+	if(!cpu_supports_freq_scaling) {
+		scaled_stats_init();
+		if(cpu_supports_freq_scaling < 0)
+			return;
+	}
+
+	aperf_old = &(per_cpu(cputime_old_aperf, smp_processor_id()));
+	mperf_old = &(per_cpu(cputime_old_mperf, smp_processor_id()));
+	acpi_get_pm_msrs_delta(&aperf_delta, &mperf_delta, aperf_old,
+				mperf_old, 1);
+
+	per_cpu(task_utime_old, smp_processor_id()) = tsk->utime;
+	per_cpu(task_stime_old, smp_processor_id()) = tsk->stime;
+}
+
+
+/* Account scaled statistics for a task on context switch */
+void account_scaled_stats(struct task_struct *tsk)
+{
+	u64 aperf_delta, mperf_delta;
+	u64 *aperf_old, *mperf_old;
+	cputime_t time;
+	u64 time_msec;
+	int readmsrs = 1;
+
+	if(!cpu_supports_freq_scaling)
+		scaled_stats_init();
+
+	/*
+	 * Get the old APERF/MPERF values for this cpu and pass it to
+	 * acpi_get_pm_msrs_delta() which will read the current values
+	 * and return the delta.
+	 */
+	aperf_old = &(per_cpu(cputime_old_aperf, smp_processor_id()));
+	mperf_old = &(per_cpu(cputime_old_mperf, smp_processor_id()));
+
+	if (cputime_gt(tsk->utime, per_cpu(task_utime_old,
+					   smp_processor_id()))) {
+		acpi_get_pm_msrs_delta(&aperf_delta, &mperf_delta, aperf_old,
+					mperf_old, 1);
+		readmsrs = 0;
+		time = cputime_sub(tsk->utime, per_cpu(task_utime_old,
+							smp_processor_id()));
+		time_msec = cputime_to_msecs(time);
+		time_msec *= 1000; /* Scale it to hold fractional values */
+		if (cpu_supports_freq_scaling == 1) {
+			time_msec *= aperf_delta;
+			time_msec = div64_u64(time_msec, mperf_delta);
+		}
+		time = msecs_to_cputime(time_msec);
+		account_user_time_scaled(tsk, time);
+		per_cpu(task_utime_old, smp_processor_id()) = tsk->utime;
+	}
+
+	if (cputime_gt(tsk->stime, per_cpu(task_stime_old,
+					   smp_processor_id()))) {
+		if (readmsrs)
+			acpi_get_pm_msrs_delta(&aperf_delta, &mperf_delta,
+						aperf_old, mperf_old, 1);
+		time = cputime_sub(tsk->stime, per_cpu(task_stime_old,
+							smp_processor_id()));
+
+		time_msec = cputime_to_msecs(time);
+		time_msec *= 1000; /* Scale it to hold fractional values */
+		if (cpu_supports_freq_scaling == 1) {
+			time_msec *= aperf_delta;
+			time_msec = div64_u64(time_msec, mperf_delta);
+		}
+		time = msecs_to_cputime(time_msec);
+		account_system_time_scaled(tsk, time);
+		per_cpu(task_stime_old, smp_processor_id()) = tsk->stime; 
+	}
+
+}	
+EXPORT_SYMBOL(account_scaled_stats);
+

