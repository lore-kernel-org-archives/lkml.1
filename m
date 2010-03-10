Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0CJNY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:24:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:53633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab0CJNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:24:48 -0500
Date: Wed, 10 Mar 2010 13:24:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Remove checking_{wr,rd}msr() usage
Message-ID: <tip-7645a24cbd01cbf4865d1273d5ddaa8d8c2ccb3a@git.kernel.org>
Git-Commit-ID: 7645a24cbd01cbf4865d1273d5ddaa8d8c2ccb3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:24:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7645a24cbd01cbf4865d1273d5ddaa8d8c2ccb3a
Gitweb:     http://git.kernel.org/tip/7645a24cbd01cbf4865d1273d5ddaa8d8c2ccb3a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 13:51:31 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:39 +0100

perf, x86: Remove checking_{wr,rd}msr() usage

We don't need checking_{wr,rd}msr() calls, since we should know what cpu
we're running on and not use blindly poke at msrs.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   24 ++++++++++++++++++------
 arch/x86/kernel/cpu/perf_event_intel.c |    5 ++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 335ee1d..e24f637 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -29,6 +29,17 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
+#if 0
+#undef wrmsrl
+#define wrmsrl(msr, val) 					\
+do {								\
+	trace_printk("wrmsrl(%lx, %lx)\n", (unsigned long)(msr),\
+			(unsigned long)(val));			\
+	native_write_msr((msr), (u32)((u64)(val)), 		\
+			(u32)((u64)(val) >> 32));		\
+} while (0)
+#endif
+
 /*
  * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
  */
@@ -821,14 +832,15 @@ void hw_perf_enable(void)
 
 static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
 {
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
+	wrmsrl(hwc->config_base + hwc->idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
 static inline void x86_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	(void)checking_wrmsrl(hwc->config_base + hwc->idx, hwc->config);
+
+	wrmsrl(hwc->config_base + hwc->idx, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -843,7 +855,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	s64 left = atomic64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
-	int err, ret = 0, idx = hwc->idx;
+	int ret = 0, idx = hwc->idx;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
 		return 0;
@@ -881,8 +893,8 @@ x86_perf_event_set_period(struct perf_event *event)
 	 */
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
-	err = checking_wrmsrl(hwc->event_base + idx,
-			     (u64)(-left) & x86_pmu.event_mask);
+	wrmsrl(hwc->event_base + idx,
+			(u64)(-left) & x86_pmu.event_mask);
 
 	perf_event_update_userpage(event);
 
@@ -987,7 +999,7 @@ void perf_event_print_debug(void)
 		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
 		pr_info("CPU#%d: pebs:       %016llx\n", cpu, pebs);
 	}
-	pr_info("CPU#%d: active:       %016llx\n", cpu, *(u64 *)cpuc->active_mask);
+	pr_info("CPU#%d: active:     %016llx\n", cpu, *(u64 *)cpuc->active_mask);
 
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		rdmsrl(x86_pmu.eventsel + idx, pmc_ctrl);
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index d3e2424..971dc6e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -525,7 +525,7 @@ static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 
 	rdmsrl(hwc->config_base, ctrl_val);
 	ctrl_val &= ~mask;
-	(void)checking_wrmsrl(hwc->config_base, ctrl_val);
+	wrmsrl(hwc->config_base, ctrl_val);
 }
 
 static void intel_pmu_disable_event(struct perf_event *event)
@@ -553,7 +553,6 @@ static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
 	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
-	int err;
 
 	/*
 	 * Enable IRQ generation (0x8),
@@ -578,7 +577,7 @@ static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 	rdmsrl(hwc->config_base, ctrl_val);
 	ctrl_val &= ~mask;
 	ctrl_val |= bits;
-	err = checking_wrmsrl(hwc->config_base, ctrl_val);
+	wrmsrl(hwc->config_base, ctrl_val);
 }
 
 static void intel_pmu_enable_event(struct perf_event *event)
