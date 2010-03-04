Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0CDOCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:02:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:39712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0CDOCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:02:07 -0500
Message-Id: <20100304140100.619375431@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH 09/14] perf, x86: use LBR for PEBS IP+1 fixup
Content-Disposition: inline; filename=perf-pebs-lbr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PEBS always reports the IP+1, that is the instruction after the one
that got sampled, cure this by using the LBR to reliably rewind the
instruction stream.

CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/include/asm/perf_event.h         |   19 ++++++
 arch/x86/kernel/cpu/perf_event.c          |   70 ++++++++++++-------------
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 -
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   84 +++++++++++++++++++++++++++++-
 include/linux/perf_event.h                |    6 ++
 5 files changed, 144 insertions(+), 39 deletions(-)

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
 }
 
 static void intel_pmu_enable_fixed(struct hw_perf_event *hwc)
@@ -600,7 +600,7 @@ static void intel_pmu_enable_event(struc
 	}
 
 	if (unlikely(event->attr.precise))
-		intel_pmu_pebs_enable(hwc);
+		intel_pmu_pebs_enable(event);
 
 	__x86_pmu_enable_event(hwc);
 }
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
@@ -369,6 +375,70 @@ static void intel_pmu_pebs_disable_all(v
 		wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
 }
 
+#include <asm/insn.h>
+
+#define MAX_INSN_SIZE	16
+
+static inline bool kernel_ip(unsigned long ip)
+{
+#ifdef CONFIG_X86_32
+	return ip > PAGE_OFFSET;
+#else
+	return (long)ip < 0;
+#endif
+}
+
+static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long from = cpuc->lbr_entries[0].from;
+	unsigned long old_to, to = cpuc->lbr_entries[0].to;
+	unsigned long ip = regs->ip;
+
+	if (!cpuc->lbr_stack.nr || !from || !to)
+		return 0;
+
+	if (ip < to)
+		return 0;
+
+	/*
+	 * We sampled a branch insn, rewind using the LBR stack
+	 */
+	if (ip == to) {
+		regs->ip = from;
+		return 1;
+	}
+
+	do {
+		struct insn insn;
+		u8 buf[MAX_INSN_SIZE];
+		void *kaddr;
+
+		old_to = to;
+		if (!kernel_ip(ip)) {
+			int bytes, size = min_t(int, MAX_INSN_SIZE, ip - to);
+
+			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
+			if (bytes != size)
+				return 0;
+
+			kaddr = buf;
+		} else
+			kaddr = (void *)to;
+
+		kernel_insn_init(&insn, kaddr);
+		insn_get_length(&insn);
+		to += insn.length;
+	} while (to < ip);
+
+	if (to == ip) {
+		regs->ip = old_to;
+		return 1;
+	}
+
+	return 0;
+}
+
 static int intel_pmu_save_and_restart(struct perf_event *event);
 static void intel_pmu_disable_event(struct perf_event *event);
 
@@ -427,6 +497,11 @@ static void intel_pmu_drain_pebs_core(st
 	regs.bp = at->bp;
 	regs.sp = at->sp;
 
+	if (intel_pmu_pebs_fixup_ip(&regs))
+		regs.flags |= PERF_EFLAGS_EXACT;
+	else
+		regs.flags &= ~PERF_EFLAGS_EXACT;
+
 	if (perf_event_overflow(event, 1, &data, &regs))
 		intel_pmu_disable_event(event);
 
@@ -497,6 +572,11 @@ static void intel_pmu_drain_pebs_nhm(str
 		regs.bp = at->bp;
 		regs.sp = at->sp;
 
+		if (intel_pmu_pebs_fixup_ip(&regs))
+			regs.flags |= PERF_EFLAGS_EXACT;
+		else
+			regs.flags &= ~PERF_EFLAGS_EXACT;
+
 		if (perf_event_overflow(event, 1, &data, &regs))
 			intel_pmu_disable_event(event);
 	}
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -136,6 +136,25 @@ extern void perf_events_lapic_init(void)
 
 #define PERF_EVENT_INDEX_OFFSET			0
 
+/*
+ * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fixups.
+ * This flag is otherwise unused and ABI specified to be 0, so nobody should
+ * care what we do with it.
+ */
+#define PERF_EFLAGS_EXACT	(1UL << 3)
+
+#define perf_misc_flags(regs)				\
+({	int misc = 0;					\
+	if (user_mode(regs))				\
+		misc |= PERF_RECORD_MISC_USER;		\
+	else						\
+		misc |= PERF_RECORD_MISC_KERNEL;	\
+	if (regs->flags & PERF_EFLAGS_EXACT)		\
+		misc |= PERF_RECORD_MISC_EXACT;		\
+	misc; })
+
+#define perf_instruction_pointer(regs)	((regs)->ip)
+
 #else
 static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -294,6 +294,12 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_USER			(2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR		(3 << 0)
 
+#define PERF_RECORD_MISC_EXACT			(1 << 14)
+/*
+ * Reserve the last bit to indicate some extended misc field
+ */
+#define PERF_RECORD_MISC_EXT_RESERVED		(1 << 15)
+
 struct perf_event_header {
 	__u32	type;
 	__u16	misc;

-- 

