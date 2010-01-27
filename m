Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187Ab0A0WOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0A0WOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:14:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162Ab0A0WOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:14:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:52285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0A0WOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:14:00 -0500
Message-Id: <20100127221122.057507285@chello.nl>
References: <20100127220745.027096123@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 Jan 2010 23:07:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_events: x86: Clean up hw_perf_*_all() implementation
Content-Disposition: inline; filename=perf-x86-cleanup-enable-disable-all.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the recursion avoidance code in the generic hook instead of
replicating it in each implementation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1099,15 +1099,8 @@ static int __hw_perf_event_init(struct p
 
 static void p6_pmu_disable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	u64 val;
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	barrier();
-
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
 	val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -1118,12 +1111,6 @@ static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	barrier();
-
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask))
@@ -1135,17 +1122,6 @@ static void amd_pmu_disable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	if (!cpuc->enabled)
-		return;
-
-	cpuc->enabled = 0;
-	/*
-	 * ensure we write the disable before we start disabling the
-	 * events proper, so that amd_pmu_enable_event() does the
-	 * right thing.
-	 */
-	barrier();
-
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		u64 val;
 
@@ -1166,23 +1142,20 @@ void hw_perf_disable(void)
 	if (!x86_pmu_initialized())
 		return;
 
-	if (cpuc->enabled)
-		cpuc->n_added = 0;
+	if (!cpuc->enabled)
+		return;
+
+	cpuc->n_added = 0;
+	cpuc->enabled = 0;
+	barrier();
 
 	x86_pmu.disable_all();
 }
 
 static void p6_pmu_enable_all(void)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long val;
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	/* p6 only has one enable register */
 	rdmsrl(MSR_P6_EVNTSEL0, val);
 	val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
@@ -1193,12 +1166,6 @@ static void intel_pmu_enable_all(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
 
 	if (test_bit(X86_PMC_IDX_FIXED_BTS, cpuc->active_mask)) {
@@ -1217,12 +1184,6 @@ static void amd_pmu_enable_all(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx;
 
-	if (cpuc->enabled)
-		return;
-
-	cpuc->enabled = 1;
-	barrier();
-
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		struct perf_event *event = cpuc->events[idx];
 		u64 val;
@@ -1417,6 +1378,10 @@ void hw_perf_enable(void)
 
 	if (!x86_pmu_initialized())
 		return;
+
+	if (cpuc->enabled)
+		return;
+
 	if (cpuc->n_added) {
 		/*
 		 * apply assignment obtained either from
@@ -1461,6 +1426,10 @@ void hw_perf_enable(void)
 		cpuc->n_added = 0;
 		perf_events_lapic_init();
 	}
+
+	cpuc->enabled = 1;
+	barrier();
+
 	x86_pmu.enable_all();
 }
 

-- 

