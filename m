Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0CJNMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:12:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:59104 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab0CJNMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:12:15 -0500
Date: Wed, 10 Mar 2010 13:11:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.165166129@chello.nl>
References: <20100304140100.165166129@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Change x86_pmu.{enable,disable} calling convention
Message-ID: <tip-aff3d91a913c9ae0c2f56b65b27cbd00c7d27ee3@git.kernel.org>
Git-Commit-ID: aff3d91a913c9ae0c2f56b65b27cbd00c7d27ee3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:11:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aff3d91a913c9ae0c2f56b65b27cbd00c7d27ee3
Gitweb:     http://git.kernel.org/tip/aff3d91a913c9ae0c2f56b65b27cbd00c7d27ee3
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Mar 2010 20:32:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:28 +0100

perf, x86: Change x86_pmu.{enable,disable} calling convention

Pass the full perf_event into the x86_pmu functions so that those may
make use of more than the hw_perf_event, and while doing this, remove the
superfluous second argument.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <20100304140100.165166129@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c       |   31 +++++++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_p6.c    |   10 ++++++----
 3 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 086127b..2dd704f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -133,8 +133,8 @@ struct x86_pmu {
 	int		(*handle_irq)(struct pt_regs *);
 	void		(*disable_all)(void);
 	void		(*enable_all)(void);
-	void		(*enable)(struct hw_perf_event *, int);
-	void		(*disable)(struct hw_perf_event *, int);
+	void		(*enable)(struct perf_event *);
+	void		(*disable)(struct perf_event *);
 	unsigned	eventsel;
 	unsigned	perfctr;
 	u64		(*event_map)(int);
@@ -845,7 +845,7 @@ void hw_perf_enable(void)
 			set_bit(hwc->idx, cpuc->active_mask);
 			cpuc->events[hwc->idx] = event;
 
-			x86_pmu.enable(hwc, hwc->idx);
+			x86_pmu.enable(event);
 			perf_event_update_userpage(event);
 		}
 		cpuc->n_added = 0;
@@ -858,15 +858,16 @@ void hw_perf_enable(void)
 	x86_pmu.enable_all();
 }
 
-static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static inline void __x86_pmu_enable_event(struct hw_perf_event *hwc)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx,
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx,
 			      hwc->config | ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
-static inline void x86_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+static inline void x86_pmu_disable_event(struct perf_event *event)
 {
-	(void)checking_wrmsrl(hwc->config_base + idx, hwc->config);
+	struct hw_perf_event *hwc = &event->hw;
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, hwc->config);
 }
 
 static DEFINE_PER_CPU(u64 [X86_PMC_IDX_MAX], pmc_prev_left);
@@ -927,11 +928,11 @@ x86_perf_event_set_period(struct perf_event *event)
 	return ret;
 }
 
-static void x86_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void x86_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	if (cpuc->enabled)
-		__x86_pmu_enable_event(hwc, idx);
+		__x86_pmu_enable_event(&event->hw);
 }
 
 /*
@@ -974,13 +975,11 @@ static int x86_pmu_enable(struct perf_event *event)
 
 static int x86_pmu_start(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-
-	if (hwc->idx == -1)
+	if (event->hw.idx == -1)
 		return -EAGAIN;
 
 	x86_perf_event_set_period(event);
-	x86_pmu.enable(hwc, hwc->idx);
+	x86_pmu.enable(event);
 
 	return 0;
 }
@@ -994,7 +993,7 @@ static void x86_pmu_unthrottle(struct perf_event *event)
 				cpuc->events[hwc->idx] != event))
 		return;
 
-	x86_pmu.enable(hwc, hwc->idx);
+	x86_pmu.enable(event);
 }
 
 void perf_event_print_debug(void)
@@ -1059,7 +1058,7 @@ static void x86_pmu_stop(struct perf_event *event)
 	 * could reenable again:
 	 */
 	clear_bit(idx, cpuc->active_mask);
-	x86_pmu.disable(hwc, idx);
+	x86_pmu.disable(event);
 
 	/*
 	 * Drain the remaining delta count out of a event
@@ -1127,7 +1126,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			x86_pmu.disable(hwc, idx);
+			x86_pmu.disable(event);
 	}
 
 	if (handled)
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a4c9f16..a840948 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -548,9 +548,9 @@ static inline void intel_pmu_ack_status(u64 ack)
 }
 
 static inline void
-intel_pmu_disable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, mask;
 
 	mask = 0xfULL << (idx * 4);
@@ -621,26 +621,28 @@ static void intel_pmu_drain_bts_buffer(void)
 }
 
 static inline void
-intel_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+intel_pmu_disable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		intel_pmu_disable_bts();
 		intel_pmu_drain_bts_buffer();
 		return;
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_disable_fixed(hwc, idx);
+		intel_pmu_disable_fixed(hwc);
 		return;
 	}
 
-	x86_pmu_disable_event(hwc, idx);
+	x86_pmu_disable_event(event);
 }
 
 static inline void
-intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
+intel_pmu_enable_fixed(struct hw_perf_event *hwc)
 {
-	int idx = __idx - X86_PMC_IDX_FIXED;
+	int idx = hwc->idx - X86_PMC_IDX_FIXED;
 	u64 ctrl_val, bits, mask;
 	int err;
 
@@ -670,9 +672,11 @@ intel_pmu_enable_fixed(struct hw_perf_event *hwc, int __idx)
 	err = checking_wrmsrl(hwc->config_base, ctrl_val);
 }
 
-static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void intel_pmu_enable_event(struct perf_event *event)
 {
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
 		if (!__get_cpu_var(cpu_hw_events).enabled)
 			return;
 
@@ -681,11 +685,11 @@ static void intel_pmu_enable_event(struct hw_perf_event *hwc, int idx)
 	}
 
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
-		intel_pmu_enable_fixed(hwc, idx);
+		intel_pmu_enable_fixed(hwc);
 		return;
 	}
 
-	__x86_pmu_enable_event(hwc, idx);
+	__x86_pmu_enable_event(hwc);
 }
 
 /*
@@ -771,7 +775,7 @@ again:
 		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, 1, &data, regs))
-			intel_pmu_disable_event(&event->hw, bit);
+			intel_pmu_disable_event(event);
 	}
 
 	intel_pmu_ack_status(ack);
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index a4e67b9..a330485 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -77,27 +77,29 @@ static void p6_pmu_enable_all(void)
 }
 
 static inline void
-p6_pmu_disable_event(struct hw_perf_event *hwc, int idx)
+p6_pmu_disable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val = P6_NOP_EVENT;
 
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
-static void p6_pmu_enable_event(struct hw_perf_event *hwc, int idx)
+static void p6_pmu_enable_event(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val;
 
 	val = hwc->config;
 	if (cpuc->enabled)
 		val |= ARCH_PERFMON_EVENTSEL_ENABLE;
 
-	(void)checking_wrmsrl(hwc->config_base + idx, val);
+	(void)checking_wrmsrl(hwc->config_base + hwc->idx, val);
 }
 
 static __initconst struct x86_pmu p6_pmu = {
