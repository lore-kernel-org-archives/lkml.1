Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab0CAS6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:58:24 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:44608
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751533Ab0CAS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:58:22 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zz936eM8d0K655Lab9bhzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYMA06-01-CV8-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: <linux-kernel@vger.kernel.org>, <joachim.deguara@amd.com>,
       <bhavna.sarathy@amd.com>
Subject: [PATCH] [cpufreq] Add APERF/MPERF support for AMD processors
Date: Mon, 1 Mar 2010 13:10:09 -0600
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc6-tip; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <201003011310.10023.mark.langsdorf@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with model 10 of Family 0x10, AMD processors may have
support for APERF/MPERF.  Add support for identifying it and using
it within cpufreq.  Move the APERF/MPERF functions out of the
acpi-cpufreq code and into their own file so they can easily be
shared.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/amd.c                  |    6 +++
 arch/x86/kernel/cpu/cpufreq/Makefile       |    4 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   42 +-----------------------
 arch/x86/kernel/cpu/cpufreq/mperf.c        |   50 
++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 +++++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    4 ++-
 arch/x86/kernel/cpu/perf_event_amd.c       |    2 +-
 7 files changed, 72 insertions(+), 45 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.c
 create mode 100644 arch/x86/kernel/cpu/cpufreq/mperf.h

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e485825..796f662 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -537,6 +537,12 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
+	if (c->cpuid_level >= 6) {
+		unsigned ecx = cpuid_ecx(6);
+		if (ecx & 0x01)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile 
b/arch/x86/kernel/cpu/cpufreq/Makefile
index 509296d..39cc160 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,8 +2,8 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
 obj-$(CONFIG_X86_LONGHAUL)		+= longhaul.o
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c 
b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 1b1920f..b3bd6b3 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -45,6 +45,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include "mperf.h"
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, \
 		"acpi-cpufreq", msg)
@@ -70,8 +71,6 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -239,45 +238,6 @@ static u32 get_cur_val(const struct cpumask *mask)
 	return cmd.val;
 }
 
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-static unsigned int get_measured_perf(struct cpufreq_policy *policy,
-				      unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.c 
b/arch/x86/kernel/cpu/cpufreq/mperf.c
new file mode 100644
index 0000000..7a0a753
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.c
@@ -0,0 +1,50 @@
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/slab.h>
+
+#include "mperf.h"
+
+static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
+
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
+{
+	struct aperfmperf *am = _cur;
+
+	get_aperfmperf(am);
+}
+
+/*
+ * Return the measured active (C0) frequency on this CPU since last call
+ * to this function.
+ * Input: cpu number
+ * Return: Average CPU frequency in terms of max frequency (zero on error)
+ *
+ * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
+ * over a period of time, while CPU is in C0 state.
+ * IA32_MPERF counts at the rate of max advertised frequency
+ * IA32_APERF counts at the rate of actual CPU frequency
+ * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
+ * no meaning should be associated with absolute values of these MSRs.
+ */
+unsigned int get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu)
+{
+	struct aperfmperf perf;
+	unsigned long ratio;
+	unsigned int retval;
+
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
+		return 0;
+
+	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
+	per_cpu(acfreq_old_perf, cpu) = perf;
+
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(get_measured_perf);
diff --git a/arch/x86/kernel/cpu/cpufreq/mperf.h 
b/arch/x86/kernel/cpu/cpufreq/mperf.h
new file mode 100644
index 0000000..67a7b64
--- /dev/null
+++ b/arch/x86/kernel/cpu/cpufreq/mperf.h
@@ -0,0 +1,9 @@
+/*
+ *  (c) 2003-2006 Advanced Micro Devices, Inc.
+ *  Your use of this code is subject to the terms and conditions of the
+ *  GNU general public license version 2. See "COPYING" or
+ *  http://www.gnu.org/licenses/gpl.html
+ */
+
+unsigned int get_measured_perf(struct cpufreq_policy *policy,
+				unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c 
b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 6e44519..ed9c4c2 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -46,6 +46,7 @@
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
+#include "mperf.h"
 
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
@@ -929,7 +930,8 @@ static int fill_powernow_table_pstate(struct 
powernow_k8_data *data,
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c 
b/arch/x86/kernel/cpu/perf_event_amd.c
index 6d28e08..8f3dbfd 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,6 +1,6 @@
 #ifdef CONFIG_CPU_SUP_AMD
 
-static raw_spinlock_t amd_nb_lock;
+static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
-- 
1.6.0.2
3

