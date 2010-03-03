Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0CCQr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:46190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0CCQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:24 -0500
Message-Id: <20100303164306.602529559@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:46 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
Content-Disposition: inline; filename=perf-pebs-lbr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS always reports the IP+1, that is the instruction after the one
that got sampled, cure this by using the LBR to reliably rewind the
instruction stream.

CC: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event.c          |   70 ++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 -
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   81 +++++++++++++++++++++++++++++-
 3 files changed, 116 insertions(+), 39 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -29,6 +29,41 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
+/*
+ * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
+ */
+static unsigned long
+copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long offset, addr = (unsigned long)from;
+	int type = in_nmi() ? KM_NMI : KM_IRQ0;
+	unsigned long size, len = 0;
+	struct page *page;
+	void *map;
+	int ret;
+
+	do {
+		ret = __get_user_pages_fast(addr, 1, 0, &page);
+		if (!ret)
+			break;
+
+		offset = addr & (PAGE_SIZE - 1);
+		size = min(PAGE_SIZE - offset, n - len);
+
+		map = kmap_atomic(page, type);
+		memcpy(to, map+offset, size);
+		kunmap_atomic(map, type);
+		put_page(page);
+
+		len  += size;
+		to   += size;
+		addr += size;
+
+	} while (len < n);
+
+	return len;
+}
+
 static u64 perf_event_mask __read_mostly;
 
 struct event_constraint {
@@ -1516,41 +1551,6 @@ perf_callchain_kernel(struct pt_regs *re
 	dump_trace(NULL, regs, NULL, regs->bp, &backtrace_ops, entry);
 }
 
-/*
- * best effort, GUP based copy_from_user() that assumes IRQ or NMI context
- */
-static unsigned long
-copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long offset, addr = (unsigned long)from;
-	int type = in_nmi() ? KM_NMI : KM_IRQ0;
-	unsigned long size, len = 0;
-	struct page *page;
-	void *map;
-	int ret;
-
-	do {
-		ret = __get_user_pages_fast(addr, 1, 0, &page);
-		if (!ret)
-			break;
-
-		offset = addr & (PAGE_SIZE - 1);
-		size = min(PAGE_SIZE - offset, n - len);
-
-		map = kmap_atomic(page, type);
-		memcpy(to, map+offset, size);
-		kunmap_atomic(map, type);
-		put_page(page);
-
-		len  += size;
-		to   += size;
-		addr += size;
-
-	} while (len < n);
-
-	return len;
-}
-
 static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
 {
 	unsigned long bytes;
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel.c
@@ -547,7 +547,7 @@ static void intel_pmu_disable_event(stru
 	x86_pmu_disable_event(event);
 
 	if (unlikely(event->attr.precise))
-		intel_pmu_pebs_disable(hwc);
+		intel_pmu_pebs_disable(event);
 
 	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
 		intel_pmu_lbr_disable(event);
@@ -603,7 +603,7 @@ static void intel_pmu_enable_event(struc
 	}
 
 	if (unlikely(event->attr.precise))
-		intel_pmu_pebs_enable(hwc);
+		intel_pmu_pebs_enable(event);
 
 	if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK)
 		intel_pmu_lbr_enable(event);
Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -331,26 +331,32 @@ intel_pebs_constraints(struct perf_event
 	return &emptyconstraint;
 }
 
-static void intel_pmu_pebs_enable(struct hw_perf_event *hwc)
+static void intel_pmu_pebs_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val = cpuc->pebs_enabled;
 
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	val |= 1ULL << hwc->idx;
 	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
+
+	intel_pmu_lbr_enable(event);
 }
 
-static void intel_pmu_pebs_disable(struct hw_perf_event *hwc)
+static void intel_pmu_pebs_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
 	u64 val = cpuc->pebs_enabled;
 
 	val &= ~(1ULL << hwc->idx);
 	wrmsrl(MSR_IA32_PEBS_ENABLE, val);
 
 	hwc->config |= ARCH_PERFMON_EVENTSEL_INT;
+
+	intel_pmu_lbr_disable(event);
 }
 
 static void intel_pmu_pebs_enable_all(void)
@@ -415,6 +421,74 @@ do {						\
 
 #endif
 
+#include <asm/insn.h>
+
+#define MAX_INSN_SIZE	16
+
+static void intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
+{
+#if 0
+	/*
+	 * Borken, makes the machine expode at times trying to
+	 * derefence funny userspace addresses.
+	 *
+	 * Should we always fwd decode from @to, instead of trying
+	 * to rewind as implemented?
+	 */
+
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long from = cpuc->lbr_entries[0].from;
+	unsigned long to = cpuc->lbr_entries[0].to;
+	unsigned long ip = regs->ip;
+	u8 buf[2*MAX_INSN_SIZE];
+	u8 *kaddr;
+	int i;
+
+	if (from && to) {
+		/*
+		 * We sampled a branch insn, rewind using the LBR stack
+		 */
+		if (ip == to) {
+			regs->ip = from;
+			return;
+		}
+	}
+
+	if (user_mode(regs)) {
+		int bytes = copy_from_user_nmi(buf,
+				(void __user *)(ip - MAX_INSN_SIZE),
+				2*MAX_INSN_SIZE);
+
+		/*
+		 * If we fail to copy the insn stream, give up
+		 */
+		if (bytes != 2*MAX_INSN_SIZE)
+			return;
+
+		kaddr = buf;
+	} else
+		kaddr = (void *)(ip - MAX_INSN_SIZE);
+
+	/*
+	 * Try to find the longest insn ending up at the given IP
+	 */
+	for (i = MAX_INSN_SIZE; i > 0; i--) {
+		struct insn insn;
+
+		kernel_insn_init(&insn, kaddr + MAX_INSN_SIZE - i);
+		insn_get_length(&insn);
+		if (insn.length == i) {
+			regs->ip -= i;
+			return;
+		}
+	}
+
+	/*
+	 * We failed to find a match for the previous insn.. give up
+	 */
+#endif
+}
+
 static int intel_pmu_save_and_restart(struct perf_event *event);
 static void intel_pmu_disable_event(struct perf_event *event);
 
@@ -458,6 +532,8 @@ static void intel_pmu_drain_pebs_core(st
 
 	PEBS_TO_REGS(at, &regs);
 
+	intel_pmu_pebs_fixup_ip(&regs);
+
 	if (perf_event_overflow(event, 1, data, &regs))
 		intel_pmu_disable_event(event);
 
@@ -519,6 +595,7 @@ static void intel_pmu_drain_pebs_nhm(str
 		data->period = event->hw.last_period;
 
 		PEBS_TO_REGS(at, &regs);
+		intel_pmu_pebs_fixup_ip(&regs);
 
 		if (perf_event_overflow(event, 1, data, &regs))
 			intel_pmu_disable_event(event);

-- 

