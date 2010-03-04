Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0CDOCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:02:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:39702 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0CDOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:56 -0500
Message-Id: <20100304140100.006500906@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/14] perf, x86: Remove superfluous arguments to x86_perf_event_set_period()
Content-Disposition: inline; filename=perf-x86-cleanup-args.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second and third argument to x86_perf_event_set_period() are
superfluous since they are simple expressions of the first argument.
Hence remove them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
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

