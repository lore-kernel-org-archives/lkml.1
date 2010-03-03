Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab0CCUp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:45:59 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53827
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756162Ab0CCUpy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:45:54 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz8d0K655Lab9bha4b1kzz1202hzzz32i6bh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYQ4C7-02-MVY-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <bhavna.sarathy@amd.com>, <joachim.deguara@amd.com>,
       <borislav.petkov@amd.com>
Subject: [PATCH 2/3] [cpufreq] powernow-k8: add core performance boost support
Date: Wed, 3 Mar 2010 14:58:27 -0600
User-Agent: KMail/1.12.2 (Linux/2.6.31-rc6-tip; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201003031458.27538.mark.langsdorf@amd.com>
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b1c9670d8f04d67cde9f810ef462ec8a8d3adbf Mon Sep 17 00:00:00 2001
From: Mark Langsdorf <mark.langsdorf@amd.com>
Date: Wed, 3 Mar 2010 14:33:43 -0600
Subject: [PATCH 1/2] powernow-k8: add core performance boost support

Add CPUID check for hardware CPB support

Also, update copyright while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   41 ++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
 include/linux/cpufreq.h                   |    4 +++
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 07f18a4..0a6f1f8 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,6 +1,5 @@
-
 /*
- *   (c) 2003-2006 Advanced Micro Devices, Inc.
+ *   (c) 2003-2009 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
@@ -57,6 +56,9 @@ static int cpu_family = CPU_OPTERON;
 
 static struct cpufreq_driver cpufreq_amd64_driver;
 
+/* core performance boost */
+static bool cpb_capable;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -511,6 +513,24 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
 	return 0;
 }
 
+/* CPB 0=disable, 1=enable. */
+static void cpb_toggle(u32 t)
+{
+	if (cpb_capable) {
+		u32 lo, hi;
+		rdmsr(MSR_K7_HWCR, lo, hi);
+
+		if (t)
+			lo &= ~(1 << 25);
+		else
+			lo |= (1 << 25);
+
+		wrmsr(MSR_K7_HWCR, lo, hi);
+
+		printk(KERN_ERR "CPB: %s.\n", (t ? "on" : "off"));
+	}
+}
+
 static void check_supported_cpu(void *_rc)
 {
 	u32 eax, ebx, ecx, edx;
@@ -1173,8 +1193,8 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 		}
 	}
 
-	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
+	if (cpufreq_frequency_table_target(pol, data->powernow_table, targfreq,
+					   relation, &newstate))
 		goto err_out;
 
 	mutex_lock(&fidvid_mutex);
@@ -1191,6 +1211,9 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 		mutex_unlock(&fidvid_mutex);
 		goto err_out;
 	}
+
+	cpb_toggle(pol->flags.cpb);
+
 	mutex_unlock(&fidvid_mutex);
 
 	if (cpu_family == CPU_HW_PSTATE)
@@ -1330,6 +1353,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	/* Check for APERF/MPERF support in hardware */
 	if (cpu_has(c, X86_FEATURE_APERFMPERF))
 		cpufreq_amd64_driver.getavg = get_measured_perf;
+	pol->flags.cpb = cpb_capable;
 
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
@@ -1419,11 +1443,20 @@ static struct cpufreq_driver cpufreq_amd64_driver = {
 	.attr		= powernow_k8_attr,
 };
 
+static bool __cpuinit check_cpb_capable(void)
+{
+	u32 tmp = cpuid_edx(CPUID_FREQ_VOLT_CAPABILITIES);
+
+	return (tmp & CPB_CAPABLE);
+}
+
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
 
+	cpb_capable = check_cpb_capable();
+
 	for_each_online_cpu(i) {
 		int rc;
 		smp_call_function_single(i, check_supported_cpu, &rc, 1);
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
index 02ce824..3be308e 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -5,7 +5,6 @@
  *  http://www.gnu.org/licenses/gpl.html
  */
 
-
 enum pstate {
 	HW_PSTATE_INVALID = 0xff,
 	HW_PSTATE_0 = 0,
@@ -55,7 +54,6 @@ struct powernow_k8_data {
 	struct cpumask *available_cores;
 };
 
-
 /* processor's cpuid instruction support */
 #define CPUID_PROCESSOR_SIGNATURE	1	/* function 1 */
 #define CPUID_XFAM			0x0ff00000	/* extended family */
@@ -67,6 +65,7 @@ struct powernow_k8_data {
 #define CPUID_GET_MAX_CAPABILITIES	0x80000000
 #define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007
 #define P_STATE_TRANSITION_CAPABLE	6
+#define CPB_CAPABLE			0x00000200
 
 /* Model Specific Registers for p-state transitions. MSRs are 64-bit. For     */
 /* writes (wrmsr - opcode 0f 30), the register number is placed in ecx, and   */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4de02b1..e738576 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -104,6 +104,10 @@ struct cpufreq_policy {
 
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+
+	struct flags {
+		unsigned long cpb:1;	/* toggle CPB on this cpu */
+	} flags;
 };
 
 #define CPUFREQ_ADJUST		(0)
-- 
1.6.0.2


