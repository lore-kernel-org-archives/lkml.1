Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZCMNIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZCMNIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759149AbZCMNHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:07:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:36721 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758716AbZCMNHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:07:53 -0400
Date: Fri, 13 Mar 2009 13:07:10 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090313112301.668614497@chello.nl>
References: <20090313112301.668614497@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: provide pagefault software events
Message-ID: <tip-f26827045743f2e12c885980da54306534a87a67@git.kernel.org>
Git-Commit-ID: f26827045743f2e12c885980da54306534a87a67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 13:07:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f26827045743f2e12c885980da54306534a87a67
Gitweb:     http://git.kernel.org/tip/f26827045743f2e12c885980da54306534a87a67
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 13 Mar 2009 12:21:33 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 14:02:45 +0100

perf_counter: provide pagefault software events

We use the generic software counter infrastructure to provide
page fault events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090313112301.668614497@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/mm/fault.c |    3 ++
 arch/x86/mm/fault.c     |    3 ++
 kernel/perf_counter.c   |   53 ++--------------------------------------------
 3 files changed, 9 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 91c7b86..b044dc7 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/perf_counter.h>
 
 #include <asm/firmware.h>
 #include <asm/page.h>
@@ -170,6 +171,8 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 		die("Weird page fault", regs, SIGSEGV);
 	}
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/* When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..c872575 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -27,6 +27,7 @@
 #include <linux/tty.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/perf_counter.h>
 
 #include <asm-generic/sections.h>
 
@@ -1044,6 +1045,8 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	if (unlikely(error_code & PF_RSVD))
 		pgtable_bad(regs, error_code, address);
 
+	perf_swcounter_event(PERF_COUNT_PAGE_FAULTS, 1, 0, regs);
+
 	/*
 	 * If we're in an interrupt, have no user context or are running
 	 * in an atomic region then we must not take the fault:
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index eeb1b46..1773c5d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1607,57 +1607,10 @@ static const struct hw_perf_counter_ops perf_ops_task_clock = {
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
