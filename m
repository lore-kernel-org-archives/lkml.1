Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZD2NNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZD2NNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbZD2NIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:08:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZD2NIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:08:14 -0400
Date: Wed, 29 Apr 2009 13:07:39 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1241002046-8832-24-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-24-git-send-email-robert.richter@amd.com>
Subject: [tip:perfcounters/core] perf_counter, x86: change and remove pmu initialization checks
Message-ID: <tip-85cf9dba92152bb4edec118b2f4f0be1ae7fdcab@git.kernel.org>
Git-Commit-ID: 85cf9dba92152bb4edec118b2f4f0be1ae7fdcab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 13:07:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85cf9dba92152bb4edec118b2f4f0be1ae7fdcab
Gitweb:     http://git.kernel.org/tip/85cf9dba92152bb4edec118b2f4f0be1ae7fdcab
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Apr 2009 12:47:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:51:12 +0200

perf_counter, x86: change and remove pmu initialization checks

Some functions are only called if the pmu was proper initialized. That
initalization checks can be removed. The way to check initialization
changed too. Now, the pointer to the interrupt handler is checked. If
it exists the pmu is initialized. This also removes a static variable
and uses struct x86_pmu as only data source for the check.

[ Impact: simplify code ]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1241002046-8832-24-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   34 +++++++++++++---------------------
 1 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index df9012b..2d3681b 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -23,7 +23,6 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
-static bool perf_counters_initialized __read_mostly;
 static u64 perf_counter_mask __read_mostly;
 
 struct cpu_hw_counters {
@@ -227,6 +226,11 @@ static void hw_perf_counter_destroy(struct perf_counter *counter)
 	}
 }
 
+static inline int x86_pmu_initialized(void)
+{
+	return x86_pmu.handle_irq != NULL;
+}
+
 /*
  * Setup the hardware configuration for a given hw_event_type
  */
@@ -240,8 +244,8 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return -ENOSYS;
 
-	if (unlikely(!perf_counters_initialized))
-		return -EINVAL;
+	if (!x86_pmu_initialized())
+		return -ENODEV;
 
 	err = 0;
 	if (atomic_inc_not_zero(&num_counters)) {
@@ -348,9 +352,8 @@ static u64 amd_pmu_save_disable_all(void)
 
 u64 hw_perf_save_disable(void)
 {
-	if (unlikely(!perf_counters_initialized))
+	if (!x86_pmu_initialized())
 		return 0;
-
 	return x86_pmu.save_disable_all();
 }
 /*
@@ -388,9 +391,8 @@ static void amd_pmu_restore_all(u64 ctrl)
 
 void hw_perf_restore(u64 ctrl)
 {
-	if (unlikely(!perf_counters_initialized))
+	if (!x86_pmu_initialized())
 		return;
-
 	x86_pmu.restore_all(ctrl);
 }
 /*
@@ -402,8 +404,6 @@ static inline u64 intel_pmu_get_status(u64 mask)
 {
 	u64 status;
 
-	if (unlikely(!perf_counters_initialized))
-		return 0;
 	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
 
 	return status;
@@ -417,10 +417,6 @@ static inline void intel_pmu_ack_status(u64 ack)
 static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	int err;
-
-	if (unlikely(!perf_counters_initialized))
-		return;
-
 	err = checking_wrmsrl(hwc->config_base + idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL0_ENABLE);
 }
@@ -428,10 +424,6 @@ static inline void x86_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 static inline void x86_pmu_disable_counter(struct hw_perf_counter *hwc, int idx)
 {
 	int err;
-
-	if (unlikely(!perf_counters_initialized))
-		return;
-
 	err = checking_wrmsrl(hwc->config_base + idx,
 			      hwc->config);
 }
@@ -787,10 +779,10 @@ void perf_counter_unthrottle(void)
 {
 	struct cpu_hw_counters *cpuc;
 
-	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
+	if (!x86_pmu_initialized())
 		return;
 
-	if (unlikely(!perf_counters_initialized))
+	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
 		return;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -829,8 +821,9 @@ void perf_counters_lapic_init(int nmi)
 {
 	u32 apic_val;
 
-	if (!perf_counters_initialized)
+	if (!x86_pmu_initialized())
 		return;
+
 	/*
 	 * Enable the performance counter vector in the APIC LVT:
 	 */
@@ -988,7 +981,6 @@ void __init init_hw_perf_counters(void)
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
 	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
-	perf_counters_initialized = true;
 
 	perf_counters_lapic_init(0);
 	register_die_notifier(&perf_counter_nmi_notifier);
