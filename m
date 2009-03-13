Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbZCMLZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbZCMLZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 07:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZCMLXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 07:23:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:42377 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZCMLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 07:23:44 -0400
Message-Id: <20090313112301.668614497@chello.nl>
References: <20090313112125.886730125@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 13 Mar 2009 12:21:33 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/11] perf_counter: provide pagefault software events
Content-Disposition: inline; filename=perf_swcounter_pgfault.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the generic software counter infrastructure to provide page fault
events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/powerpc/mm/fault.c |    3 ++
 arch/x86/mm/fault.c     |    3 ++
 kernel/perf_counter.c   |   53 ++----------------------------------------------
 3 files changed, 9 insertions(+), 50 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1601,57 +1601,10 @@ static const struct hw_perf_counter_ops 
  * Software counter: page faults
  */
 
-#ifdef CONFIG_VM_EVENT_COUNTERS
-#define cpu_page_faults()	__get_cpu_var(vm_event_states).event[PGFAULT]
-#else
-#define cpu_page_faults()	0
-#endif
-
-static u64 get_page_faults(struct perf_counter *counter)
-{
-	struct task_struct *curr = counter->ctx->task;
-
-	if (curr)
-		return curr->maj_flt + curr->min_flt;
-	return cpu_page_faults();
-}
-
-static void page_faults_perf_counter_update(struct perf_counter *counter)
-{
-	u64 prev, now;
-	s64 delta;
-
-	prev = atomic64_read(&counter->hw.prev_count);
-	now = get_page_faults(counter);
-
-	atomic64_set(&counter->hw.prev_count, now);
-
-	delta = now - prev;
-
-	atomic64_add(delta, &counter->count);
-}
-
-static void page_faults_perf_counter_read(struct perf_counter *counter)
-{
-	page_faults_perf_counter_update(counter);
-}
-
-static int page_faults_perf_counter_enable(struct perf_counter *counter)
-{
-	if (counter->prev_state <= PERF_COUNTER_STATE_OFF)
-		atomic64_set(&counter->hw.prev_count, get_page_faults(counter));
-	return 0;
-}
-
-static void page_faults_perf_counter_disable(struct perf_counter *counter)
-{
-	page_faults_perf_counter_update(counter);
-}
-
 static const struct hw_perf_counter_ops perf_ops_page_faults = {
-	.enable		= page_faults_perf_counter_enable,
-	.disable	= page_faults_perf_counter_disable,
-	.read		= page_faults_perf_counter_read,
+	.enable		= perf_swcounter_enable,
+	.disable	= perf_swcounter_disable,
+	.read		= perf_swcounter_read,
 };
 
 /*
Index: linux-2.6/arch/powerpc/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/powerpc/mm/fault.c
+++ linux-2.6/arch/powerpc/mm/fault.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/perf_counter.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -170,6 +171,8 @@ int __kprobes do_page_fault(struct pt_re
 		die("Weird page fault", regs, SIGSEGV);
 	}
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
Index: linux-2.6/arch/x86/mm/fault.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/fault.c
+++ linux-2.6/arch/x86/mm/fault.c
@@ -27,6 +27,7 @@
 #include <linux/tty.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/perf_counter.h>
 
 #include <asm-generic/sections.h>
 
@@ -1056,6 +1057,8 @@ do_page_fault(struct pt_regs *regs, unsi
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/*
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:

-- 

