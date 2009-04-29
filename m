Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZD2K6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZD2K6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbZD2Kve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:34 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:46162
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755846AbZD2KvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:16 -0400
X-BigFish: VPS10(z1039ozzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGU-03-8M7-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 16/29] x86/perfcounters: make pmu version generic
Date: Wed, 29 Apr 2009 12:47:13 +0200
Message-ID: <1241002046-8832-17-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0508 (UTC) FILETIME=[5BB7CE40:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the use of the version variable generic. Also, some debug
messages have been generalized.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 75dbb1f..15d2c03 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -39,6 +39,8 @@ struct cpu_hw_counters {
  * struct x86_pmu - generic x86 pmu
  */
 struct x86_pmu {
+	const char	*name;
+	int		version;
 	int		(*handle_irq)(struct pt_regs *, int);
 	u64		(*save_disable_all)(void);
 	void		(*restore_all)(u64);
@@ -61,8 +63,6 @@ static DEFINE_PER_CPU(struct cpu_hw_counters, cpu_hw_counters) = {
 	.enabled = 1,
 };
 
-static __read_mostly int intel_perfmon_version;
-
 /*
  * Intel PerfMon v3. Used on Core2 and later.
  */
@@ -658,7 +658,7 @@ void perf_counter_print_debug(void)
 	cpu = smp_processor_id();
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
-	if (intel_perfmon_version >= 2) {
+	if (x86_pmu.version >= 2) {
 		rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
 		rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 		rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
@@ -884,6 +884,7 @@ static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
 };
 
 static struct x86_pmu intel_pmu = {
+	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
 	.save_disable_all	= intel_pmu_save_disable_all,
 	.restore_all		= intel_pmu_restore_all,
@@ -897,6 +898,7 @@ static struct x86_pmu intel_pmu = {
 };
 
 static struct x86_pmu amd_pmu = {
+	.name			= "AMD",
 	.handle_irq		= amd_pmu_handle_irq,
 	.save_disable_all	= amd_pmu_save_disable_all,
 	.restore_all		= amd_pmu_restore_all,
@@ -918,6 +920,7 @@ static int intel_pmu_init(void)
 	union cpuid10_eax eax;
 	unsigned int unused;
 	unsigned int ebx;
+	int version;
 
 	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return -ENODEV;
@@ -930,16 +933,12 @@ static int intel_pmu_init(void)
 	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
 		return -ENODEV;
 
-	intel_perfmon_version = eax.split.version_id;
-	if (intel_perfmon_version < 2)
+	version = eax.split.version_id;
+	if (version < 2)
 		return -ENODEV;
 
-	pr_info("Intel Performance Monitoring support detected.\n");
-	pr_info("... version:         %d\n", intel_perfmon_version);
-	pr_info("... bit width:       %d\n", eax.split.bit_width);
-	pr_info("... mask length:     %d\n", eax.split.mask_length);
-
 	x86_pmu = intel_pmu;
+	x86_pmu.version = version;
 	x86_pmu.num_counters = eax.split.num_counters;
 	x86_pmu.num_counters_fixed = edx.split.num_counters_fixed;
 	x86_pmu.counter_bits = eax.split.bit_width;
@@ -951,7 +950,6 @@ static int intel_pmu_init(void)
 static int amd_pmu_init(void)
 {
 	x86_pmu = amd_pmu;
-	pr_info("AMD Performance Monitoring support detected.\n");
 	return 0;
 }
 
@@ -972,6 +970,10 @@ void __init init_hw_perf_counters(void)
 	if (err != 0)
 		return;
 
+	pr_info("%s Performance Monitoring support detected.\n", x86_pmu.name);
+	pr_info("... version:         %d\n", x86_pmu.version);
+	pr_info("... bit width:       %d\n", x86_pmu.counter_bits);
+
 	pr_info("... num counters:    %d\n", x86_pmu.num_counters);
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
-- 
1.6.1.3


