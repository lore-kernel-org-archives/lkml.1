Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0CCQqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:46:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:46192 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0CCQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:24 -0500
Message-Id: <20100303164306.146651942@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:40 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 04/11] perf, x86: Use unlocked bitops
Content-Disposition: inline; filename=perf-x86-unlocked-bitops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no concurrency on these variables, so don't use LOCK'ed ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c       |    8 ++++----
 arch/x86/kernel/cpu/perf_event_amd.c   |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -638,7 +638,7 @@ static int x86_schedule_events(struct cp
 		if (test_bit(hwc->idx, used_mask))
 			break;
 
-		set_bit(hwc->idx, used_mask);
+		__set_bit(hwc->idx, used_mask);
 		if (assign)
 			assign[i] = hwc->idx;
 	}
@@ -687,7 +687,7 @@ static int x86_schedule_events(struct cp
 			if (j == X86_PMC_IDX_MAX)
 				break;
 
-			set_bit(j, used_mask);
+			__set_bit(j, used_mask);
 
 			if (assign)
 				assign[i] = j;
@@ -837,7 +837,7 @@ void hw_perf_enable(void)
 			 * clear active_mask and events[] yet it preserves
 			 * idx
 			 */
-			set_bit(hwc->idx, cpuc->active_mask);
+			__set_bit(hwc->idx, cpuc->active_mask);
 			cpuc->events[hwc->idx] = event;
 
 			x86_pmu.enable(event);
@@ -1052,7 +1052,7 @@ static void x86_pmu_stop(struct perf_eve
 	 * Must be done before we disable, otherwise the nmi handler
 	 * could reenable again:
 	 */
-	clear_bit(idx, cpuc->active_mask);
+	__clear_bit(idx, cpuc->active_mask);
 	x86_pmu.disable(event);
 
 	/*
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_amd.c
@@ -309,7 +309,7 @@ static struct amd_nb *amd_alloc_nb(int c
 	 * initialize all possible NB constraints
 	 */
 	for (i = 0; i < x86_pmu.num_events; i++) {
-		set_bit(i, nb->event_constraints[i].idxmsk);
+		__set_bit(i, nb->event_constraints[i].idxmsk);
 		nb->event_constraints[i].weight = 1;
 	}
 	return nb;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -768,7 +768,7 @@ again:
 	for_each_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
-		clear_bit(bit, (unsigned long *) &status);
+		__clear_bit(bit, (unsigned long *) &status);
 		if (!test_bit(bit, cpuc->active_mask))
 			continue;
 

-- 

