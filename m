Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZCML0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZCML0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZCMLXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbZCMLXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:47 -0400
Message-Id: <20090313112301.770243471@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:34 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/11] perf_counter: provide major/minor page fault software events
Content-Disposition: inline; filename=perf_swcounter_majmin.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide separate sw counters for major and minor page faults.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/mm/fault.c      |    5 ++++-
 arch/x86/mm/fault.c          |    7 +++++--
 include/linux/perf_counter.h |    4 +++-
 kernel/perf_counter.c        |   22 +++++++++-------------
 4 files changed, 21 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/powerpc/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/fault.c
+++ linux-2.6/arch/powerpc/mm/fault.c
@@ -324,6 +324,7 @@ good_area:
 	}
 	if (ret & VM_FAULT_MAJOR) {
 		current->maj_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
 #ifdef CONFIG_PPC_SMLPAR
 		if (firmware_has_feature(FW_FEATURE_CMO)) {
 			preempt_disable();
@@ -331,8 +332,10 @@ good_area:
 			preempt_enable();
 		}
 #endif
-	} else
+	} else {
 		current->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 	up_read(&mm->mmap_sem);
 	return 0;
 
Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -1152,10 +1152,13 @@ good_area:
 		return;
 	}
 
-	if (fault & VM_FAULT_MAJOR)
+	if (fault & VM_FAULT_MAJOR) {
 		tsk->maj_flt++;
-	else
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MAJ, 1, 0, regs);
+	} else {
 		tsk->min_flt++;
+		perf_swcounter_event(PERF_COUNT_PAGE_FAULTS_MIN, 1, 0, regs);
+	}
 
 	check_v8086_mode(regs, address, tsk);
 
Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -49,8 +49,10 @@ enum hw_event_types {
 	PERF_COUNT_PAGE_FAULTS		= -3,
 	PERF_COUNT_CONTEXT_SWITCHES	= -4,
 	PERF_COUNT_CPU_MIGRATIONS	= -5,
+	PERF_COUNT_PAGE_FAULTS_MIN	= -6,
+	PERF_COUNT_PAGE_FAULTS_MAJ	= -7,
 
-	PERF_SW_EVENTS_MIN		= -6,
+	PERF_SW_EVENTS_MIN		= -8,
 };
 
 /*
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1513,6 +1513,12 @@ static void perf_swcounter_disable(struc
 	perf_swcounter_update(counter);
 }
 
+static const struct hw_perf_counter_ops perf_ops_generic = {
+	.enable		= perf_swcounter_enable,
+	.disable	= perf_swcounter_disable,
+	.read		= perf_swcounter_read,
+};
+
 /*
  * Software counter: cpu wall time clock
  */
@@ -1614,16 +1620,6 @@ static const struct hw_perf_counter_ops 
 };
 
 /*
- * Software counter: page faults
- */
-
-static const struct hw_perf_counter_ops perf_ops_page_faults = {
-	.enable		= perf_swcounter_enable,
-	.disable	= perf_swcounter_disable,
-	.read		= perf_swcounter_read,
-};
-
-/*
  * Software counter: context switches
  */
 
@@ -1763,9 +1759,9 @@ sw_perf_counter_init(struct perf_counter
 			hw_ops = &perf_ops_cpu_clock;
 		break;
 	case PERF_COUNT_PAGE_FAULTS:
-		if (!(counter->hw_event.exclude_user ||
-		      counter->hw_event.exclude_kernel))
-			hw_ops = &perf_ops_page_faults;
+	case PERF_COUNT_PAGE_FAULTS_MIN:
+	case PERF_COUNT_PAGE_FAULTS_MAJ:
+		hw_ops = &perf_ops_generic;
 		break;
 	case PERF_COUNT_CONTEXT_SWITCHES:
 		if (!counter->hw_event.exclude_kernel)

-- 

