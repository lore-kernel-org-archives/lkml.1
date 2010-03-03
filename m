Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0CCQpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:45:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42729 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab0CCQp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:28 -0500
Message-Id: <20100303164305.914283692@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:37 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 01/11] perf, x86: Remove superfluous arguments to x86_perf_event_set_period()
Content-Disposition: inline; filename=perf-x86-cleanup-args.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second and third argument to x86_perf_event_set_period() are
superfluous since they are simple expressions of the first argument.
Hence remove them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |   15 +++++++--------
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -165,8 +165,7 @@ static DEFINE_PER_CPU(struct cpu_hw_even
 	.enabled = 1,
 };
 
-static int x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx);
+static int x86_perf_event_set_period(struct perf_event *event);
 
 /*
  * Generalized hw caching related hw_event table, filled
@@ -830,7 +829,7 @@ void hw_perf_enable(void)
 
 			if (hwc->idx == -1) {
 				x86_assign_hw_event(event, cpuc, i);
-				x86_perf_event_set_period(event, hwc, hwc->idx);
+				x86_perf_event_set_period(event);
 			}
 			/*
 			 * need to mark as active because x86_pmu_disable()
@@ -871,12 +870,12 @@ static DEFINE_PER_CPU(u64 [X86_PMC_IDX_M
  * To be called with the event disabled in hw:
  */
 static int
-x86_perf_event_set_period(struct perf_event *event,
-			     struct hw_perf_event *hwc, int idx)
+x86_perf_event_set_period(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	s64 left = atomic64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
-	int err, ret = 0;
+	int err, ret = 0, idx = hwc->idx;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
 		return 0;
@@ -974,7 +973,7 @@ static int x86_pmu_start(struct perf_eve
 	if (hwc->idx == -1)
 		return -EAGAIN;
 
-	x86_perf_event_set_period(event, hwc, hwc->idx);
+	x86_perf_event_set_period(event);
 	x86_pmu.enable(hwc, hwc->idx);
 
 	return 0;
@@ -1119,7 +1118,7 @@ static int x86_pmu_handle_irq(struct pt_
 		handled		= 1;
 		data.period	= event->hw.last_period;
 
-		if (!x86_perf_event_set_period(event, hwc, idx))
+		if (!x86_perf_event_set_period(event))
 			continue;
 
 		if (perf_event_overflow(event, 1, &data, regs))
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -700,7 +700,7 @@ static int intel_pmu_save_and_restart(st
 	int ret;
 
 	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event, hwc, idx);
+	ret = x86_perf_event_set_period(event);
 
 	return ret;
 }

-- 

