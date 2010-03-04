Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0CDODK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:03:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab0CDOCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:02:03 -0500
Message-Id: <20100304140100.089468871@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:48 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/14] perf, x86: Remove superfluous arguments to x86_perf_event_update()
Content-Disposition: inline; filename=perf-x86-cleanup-args1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second and third argument to x86_perf_event_update() are
superfluous since they are simple expressions of the first argument.
Hence remove them.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c       |   11 ++++++-----
 arch/x86/kernel/cpu/perf_event_intel.c |   10 ++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -188,11 +188,12 @@ static u64 __read_mostly hw_cache_event_
  * Returns the delta events processed.
  */
 static u64
-x86_perf_event_update(struct perf_event *event,
-			struct hw_perf_event *hwc, int idx)
+x86_perf_event_update(struct perf_event *event)
 {
+	struct hw_perf_event *hwc = &event->hw;
 	int shift = 64 - x86_pmu.event_bits;
 	u64 prev_raw_count, new_raw_count;
+	int idx = hwc->idx;
 	s64 delta;
 
 	if (idx == X86_PMC_IDX_FIXED_BTS)
@@ -1059,7 +1060,7 @@ static void x86_pmu_stop(struct perf_eve
 	 * Drain the remaining delta count out of a event
 	 * that we are disabling:
 	 */
-	x86_perf_event_update(event, hwc, idx);
+	x86_perf_event_update(event);
 
 	cpuc->events[idx] = NULL;
 }
@@ -1108,7 +1109,7 @@ static int x86_pmu_handle_irq(struct pt_
 		event = cpuc->events[idx];
 		hwc = &event->hw;
 
-		val = x86_perf_event_update(event, hwc, idx);
+		val = x86_perf_event_update(event);
 		if (val & (1ULL << (x86_pmu.event_bits - 1)))
 			continue;
 
@@ -1419,7 +1420,7 @@ void __init init_hw_perf_events(void)
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
-	x86_perf_event_update(event, &event->hw, event->hw.idx);
+	x86_perf_event_update(event);
 }
 
 static const struct pmu pmu = {
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -695,14 +695,8 @@ static void intel_pmu_enable_event(struc
  */
 static int intel_pmu_save_and_restart(struct perf_event *event)
 {
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-	int ret;
-
-	x86_perf_event_update(event, hwc, idx);
-	ret = x86_perf_event_set_period(event);
-
-	return ret;
+	x86_perf_event_update(event);
+	return x86_perf_event_set_period(event);
 }
 
 static void intel_pmu_reset(void)

-- 

