Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYHRVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYHRVuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYHRVuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:50:11 -0400
Received: from adsl-69-107-80-255.dsl.pltn13.pacbell.net ([69.107.80.255]:45348
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752968AbYHRVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:07 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 17:50:06 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 5 of 9] x86: unify tlb.c
X-Mercurial-Node: 55a64f4154b4dfb26f6f0a8017ffb77797813d1f
Message-Id: <55a64f4154b4dfb26f6f.1219083822@localhost>
In-Reply-To: <patchbomb.1219083817@localhost>
Date: Mon, 18 Aug 2008 11:23:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/tlb_*.c are functionally identical, so unify them.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/Makefile |    2
 arch/x86/kernel/tlb.c    |  268 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tlb_32.c |  190 --------------------------------
 arch/x86/kernel/tlb_64.c |  235 ----------------------------------------
 4 files changed, 269 insertions(+), 426 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -60,7 +60,7 @@
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/tlb.c b/arch/x86/kernel/tlb.c
new file mode 100644
--- /dev/null
+++ b/arch/x86/kernel/tlb.c
@@ -0,0 +1,268 @@
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+
+#include <asm/tlbflush.h>
+#include <asm/timer.h>
+
+/* For UV tlb flush */
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_bau.h>
+#include <asm/genapic.h>	/* for is_uv_system */
+
+/*
+ *	Smarter SMP flushing macros.
+ *		c/o Linus Torvalds.
+ *
+ *	These mean you can really definitely utterly forget about
+ *	writing to user space from interrupts. (Its not allowed anyway).
+ *
+ *	Optimizations Manfred Spraul <manfred@colorfullife.com>
+ */
+
+#ifdef CONFIG_X86_32
+DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
+			____cacheline_aligned = { &init_mm, 0, };
+
+static inline short get_mmu_state(void)
+{
+	return __get_cpu_var(cpu_tlbstate).state;
+}
+
+static inline struct mm_struct *get_active_mm(void)
+{
+	return __get_cpu_var(cpu_tlbstate).active_mm;
+}
+
+static inline void inc_irq_count(void)
+{
+	__get_cpu_var(irq_stat).irq_tlb_count++;
+}
+#else
+static inline short get_mmu_state(void)
+{
+	return read_pda(mmu_state);
+}
+
+static inline struct mm_struct *get_active_mm(void)
+{
+	return read_pda(active_mm);
+}
+
+static inline void inc_irq_count(void)
+{
+	add_pda(irq_tlb_count, 1);
+}
+#endif
+
+struct tlb_flush {
+	struct mm_struct *mm;
+	unsigned long va;
+};
+
+/*
+ * We cannot call mmdrop() because we are in interrupt context,
+ * instead update mm->cpu_vm_mask.
+ *
+ * We need to reload %cr3 since the page tables may be going
+ * away from under us..
+ */
+void leave_mm(int cpu)
+{
+	if (get_mmu_state() == TLBSTATE_OK)
+		BUG();
+	cpu_clear(cpu, get_active_mm()->cpu_vm_mask);
+	load_cr3(swapper_pg_dir);
+}
+EXPORT_SYMBOL_GPL(leave_mm);
+
+/*
+ *
+ * The flush IPI assumes that a thread switch happens in this order:
+ * [cpu0: the cpu that switches]
+ * 1) switch_mm() either 1a) or 1b)
+ * 1a) thread switch to a different mm
+ * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
+ *	Stop ipi delivery for the old mm. This is not synchronized with
+ *	the other cpus, but tlb_invalidate() ignores flush ipis
+ *	for the wrong mm, and in the worst case we perform a superfluous
+ *	tlb flush.
+ * 1a2) set cpu mmu_state to TLBSTATE_OK
+ *	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
+ *	was in lazy tlb mode.
+ * 1a3) update cpu active_mm
+ *	Now cpu0 accepts tlb flushes for the new mm.
+ * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
+ *	Now the other cpus will send tlb flush ipis.
+ * 1a4) change cr3.
+ * 1b) thread switch without mm change
+ *	cpu active_mm is correct, cpu0 already handles
+ *	flush ipis.
+ * 1b1) set cpu mmu_state to TLBSTATE_OK
+ * 1b2) test_and_set the cpu bit in cpu_vm_mask.
+ *	Atomically set the bit [other cpus will start sending flush ipis],
+ *	and test the bit.
+ * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
+ * 2) switch %%esp, ie current
+ *
+ * The interrupt must handle 2 special cases:
+ * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
+ * - the cpu performs speculative tlb reads, i.e. even if the cpu only
+ *   runs in kernel space, the cpu could load tlb entries for user space
+ *   pages.
+ *
+ * The good news is that cpu mmu_state is local to each cpu, no
+ * write/read ordering problems.
+ */
+
+/*
+ * TLB flush IPI:
+ *
+ * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
+ * 2) Leave the mm if we are in the lazy tlb mode.
+ *
+ * Interrupts are disabled.
+ */
+
+static void tlb_invalidate(void *arg)
+{
+	struct tlb_flush *f = arg;
+	int cpu;
+
+	cpu = smp_processor_id();
+
+	if (f->mm == get_active_mm()) {
+		if (get_mmu_state() == TLBSTATE_OK) {
+			if (f->va == TLB_FLUSH_ALL)
+				local_flush_tlb();
+			else
+				__flush_tlb_one(f->va);
+		} else
+			leave_mm(cpu);
+	}
+
+	inc_irq_count();
+}
+
+#ifdef CONFIG_DEBUG_FS
+static spinlock_t tlbflush_others_lock = __SPIN_LOCK_UNLOCKED(tlb_flush_others_lock);
+static u32 tlbflush_others_count;
+static u64 tlbflush_others_accum;
+static u8 tlbflush_others_enable;
+#else
+#define tlbflush_others_enable 0
+#endif
+
+void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
+			     unsigned long va)
+{
+	struct tlb_flush flush = {
+		.mm = mm,
+		.va = va
+	};
+	u8 timing_enabled = tlbflush_others_enable;
+	u64 uninitialized_var(start), end;
+
+	if (is_uv_system() && uv_flush_tlb_others(cpumaskp, mm, va))
+		return;
+
+	if (timing_enabled)
+		rdtscll(start);
+
+	smp_call_function_mask(*cpumaskp, tlb_invalidate, &flush, 1);
+
+#ifdef CONFIG_DEBUG_FS
+	if (timing_enabled) {
+		rdtscll(end);
+
+		spin_lock(&tlbflush_others_lock);
+		tlbflush_others_count++;
+		tlbflush_others_accum += cycles_2_ns(end - start);
+		spin_unlock(&tlbflush_others_lock);
+	}
+#endif
+}
+
+void flush_tlb_current_task(void)
+{
+	struct mm_struct *mm = current->mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	local_flush_tlb();
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+	preempt_enable();
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			local_flush_tlb();
+		else
+			leave_mm(smp_processor_id());
+	}
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
+
+	preempt_enable();
+}
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	cpumask_t cpu_mask;
+
+	preempt_disable();
+	cpu_mask = mm->cpu_vm_mask;
+	cpu_clear(smp_processor_id(), cpu_mask);
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			__flush_tlb_one(va);
+		else
+			leave_mm(smp_processor_id());
+	}
+
+	if (!cpus_empty(cpu_mask))
+		flush_tlb_others(cpu_mask, mm, va);
+
+	preempt_enable();
+}
+
+static void do_flush_tlb_all(void *info)
+{
+	unsigned long cpu = smp_processor_id();
+
+	__flush_tlb_all();
+	if (get_mmu_state() == TLBSTATE_LAZY)
+		leave_mm(cpu);
+}
+
+void flush_tlb_all(void)
+{
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int __init init_tlbflush_time(void)
+{
+	debugfs_create_u8("tlbflush_others_enable", 0644, NULL, &tlbflush_others_enable);
+	debugfs_create_u32("tlbflush_others_count", 0644, NULL, &tlbflush_others_count);
+	debugfs_create_u64("tlbflush_others_accum", 0644, NULL, &tlbflush_others_accum);
+
+	return 0;
+}
+fs_initcall(init_tlbflush_time);
+#endif
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
deleted file mode 100644
--- a/arch/x86/kernel/tlb_32.c
+++ /dev/null
@@ -1,190 +0,0 @@
-#include <linux/smp.h>
-#include <linux/interrupt.h>
-#include <linux/percpu.h>
-#include <linux/module.h>
-
-#include <asm/tlbflush.h>
-
-DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
-			____cacheline_aligned = { &init_mm, 0, };
-
-/*
- *	Smarter SMP flushing macros.
- *		c/o Linus Torvalds.
- *
- *	These mean you can really definitely utterly forget about
- *	writing to user space from interrupts. (Its not allowed anyway).
- *
- *	Optimizations Manfred Spraul <manfred@colorfullife.com>
- */
-
-struct tlb_flush {
-	struct mm_struct *mm;
-	unsigned long va;
-};
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- *
- * We need to reload %cr3 since the page tables may be going
- * away from under us..
- */
-void leave_mm(int cpu)
-{
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, per_cpu(cpu_tlbstate, cpu).active_mm->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
-}
-EXPORT_SYMBOL_GPL(leave_mm);
-
-/*
- *
- * The flush IPI assumes that a thread switch happens in this order:
- * [cpu0: the cpu that switches]
- * 1) switch_mm() either 1a) or 1b)
- * 1a) thread switch to a different mm
- * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- *	Stop ipi delivery for the old mm. This is not synchronized with
- *	the other cpus, but tlb_invalidate() ignores flush ipis
- *	for the wrong mm, and in the worst case we perform a superfluous
- *	tlb flush.
- * 1a2) set cpu_tlbstate to TLBSTATE_OK
- * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu_tlbstate[].active_mm
- *	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- *	Now the other cpus will send tlb flush ipis.
- * 1a4) change cr3.
- * 1b) thread switch without mm change
- *	cpu_tlbstate[].active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu_tlbstate to TLBSTATE_OK
- * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- *	Atomically set the bit [other cpus will start sending flush ipis],
- *	and test the bit.
- * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
- * 2) switch %%esp, ie current
- *
- * The interrupt must handle 2 special cases:
- * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
- * - the cpu performs speculative tlb reads, i.e. even if the cpu only
- *   runs in kernel space, the cpu could load tlb entries for user space
- *   pages.
- *
- * The good news is that cpu_tlbstate is local to each cpu, no
- * write/read ordering problems.
- */
-
-/*
- * TLB flush IPI:
- *
- * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
- * 2) Leave the mm if we are in the lazy tlb mode.
- *
- * Interrupts are disabled.
- */
-
-static void tlb_invalidate(void *arg)
-{
-	struct tlb_flush *f = arg;
-	int cpu;
-
-	cpu = smp_processor_id();
-
-	if (f->mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
-		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (f->va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(f->va);
-		} else
-			leave_mm(cpu);
-	}
-
-	__get_cpu_var(irq_stat).irq_tlb_count++;
-}
-
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
-{
-	struct tlb_flush flush = {
-		.mm = mm,
-		.va = va
-	};
-
-	smp_call_function_mask(*cpumaskp, tlb_invalidate, &flush, 1);
-}
-
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
-}
-
-void flush_tlb_mm(struct mm_struct *mm)
-{
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
-
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
-	preempt_enable();
-}
-
-static void do_flush_tlb_all(void *info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
-}
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
deleted file mode 100644
--- a/arch/x86/kernel/tlb_64.c
+++ /dev/null
@@ -1,235 +0,0 @@
-#include <linux/init.h>
-
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/interrupt.h>
-#include <linux/debugfs.h>
-#include <linux/module.h>
-
-#include <asm/tlbflush.h>
-#include <asm/timer.h>
-
-/* For UV tlb flush */
-#include <asm/uv/uv_hub.h>
-#include <asm/uv/uv_bau.h>
-#include <asm/genapic.h>	/* for is_uv_system */
-
-#include <mach_ipi.h>
-/*
- *	Smarter SMP flushing macros.
- *		c/o Linus Torvalds.
- *
- *	These mean you can really definitely utterly forget about
- *	writing to user space from interrupts. (Its not allowed anyway).
- *
- *	Optimizations Manfred Spraul <manfred@colorfullife.com>
- */
-
-struct tlb_flush {
-	struct mm_struct *mm;
-	unsigned long va;
-};
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- *
- * We need to reload %cr3 since the page tables may be going
- * away from under us..
- */
-void leave_mm(int cpu)
-{
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
-}
-EXPORT_SYMBOL_GPL(leave_mm);
-
-/*
- *
- * The flush IPI assumes that a thread switch happens in this order:
- * [cpu0: the cpu that switches]
- * 1) switch_mm() either 1a) or 1b)
- * 1a) thread switch to a different mm
- * 1a1) cpu_clear(cpu, old_mm->cpu_vm_mask);
- *	Stop ipi delivery for the old mm. This is not synchronized with
- *	the other cpus, but tlb_invalidate() ignores flush ipis
- *	for the wrong mm, and in the worst case we perform a superfluous
- *	tlb flush.
- * 1a2) set cpu mmu_state to TLBSTATE_OK
- *	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu active_mm
- *	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- *	Now the other cpus will send tlb flush ipis.
- * 1a4) change cr3.
- * 1b) thread switch without mm change
- *	cpu active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu mmu_state to TLBSTATE_OK
- * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- *	Atomically set the bit [other cpus will start sending flush ipis],
- *	and test the bit.
- * 1b3) if the bit was 0: leave_mm was called, flush the tlb.
- * 2) switch %%esp, ie current
- *
- * The interrupt must handle 2 special cases:
- * - cr3 is changed before %%esp, ie. it cannot use current->{active_,}mm.
- * - the cpu performs speculative tlb reads, i.e. even if the cpu only
- *   runs in kernel space, the cpu could load tlb entries for user space
- *   pages.
- *
- * The good news is that cpu mmu_state is local to each cpu, no
- * write/read ordering problems.
- */
-
-/*
- * TLB flush IPI:
- *
- * 1) Flush the tlb entries if the cpu uses the mm that's being flushed.
- * 2) Leave the mm if we are in the lazy tlb mode.
- *
- * Interrupts are disabled.
- */
-
-static void tlb_invalidate(void *arg)
-{
-	struct tlb_flush *f = arg;
-	int cpu;
-
-	cpu = smp_processor_id();
-
-	if (f->mm == read_pda(active_mm)) {
-		if (read_pda(mmu_state) == TLBSTATE_OK) {
-			if (f->va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(f->va);
-		} else
-			leave_mm(cpu);
-	}
-
-	add_pda(irq_tlb_count, 1);
-}
-
-#ifdef CONFIG_DEBUG_FS
-static spinlock_t tlbflush_others_lock = __SPIN_LOCK_UNLOCKED(tlb_flush_others_lock);
-static u32 tlbflush_others_count;
-static u64 tlbflush_others_accum;
-static u8 tlbflush_others_enable;
-#else
-#define tlbflush_others_enable 0
-#endif
-
-void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
-			     unsigned long va)
-{
-	struct tlb_flush flush = {
-		.mm = mm,
-		.va = va
-	};
-	u8 timing_enabled = tlbflush_others_enable;
-	u64 uninitialized_var(start), end;
-
-	if (is_uv_system() && uv_flush_tlb_others(cpumaskp, mm, va))
-		return;
-
-	if (timing_enabled)
-		rdtscll(start);
-
-	smp_call_function_mask(*cpumaskp, tlb_invalidate, &flush, 1);
-
-	if (timing_enabled) {
-		rdtscll(end);
-
-		spin_lock(&tlbflush_others_lock);
-		tlbflush_others_count++;
-		tlbflush_others_accum += cycles_2_ns(end - start);
-		spin_unlock(&tlbflush_others_lock);
-	}
-}
-
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	local_flush_tlb();
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
-}
-
-void flush_tlb_mm(struct mm_struct *mm)
-{
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	cpumask_t cpu_mask;
-
-	preempt_disable();
-	cpu_mask = mm->cpu_vm_mask;
-	cpu_clear(smp_processor_id(), cpu_mask);
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
-
-	if (!cpus_empty(cpu_mask))
-		flush_tlb_others(cpu_mask, mm, va);
-
-	preempt_enable();
-}
-
-static void do_flush_tlb_all(void *info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (read_pda(mmu_state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
-}
-
-#ifdef CONFIG_DEBUG_FS
-static int __init init_tlbflush_time(void)
-{
-	debugfs_create_u8("tlbflush_others_enable", 0644, NULL, &tlbflush_others_enable);
-	debugfs_create_u32("tlbflush_others_count", 0644, NULL, &tlbflush_others_count);
-	debugfs_create_u64("tlbflush_others_accum", 0644, NULL, &tlbflush_others_accum);
-
-	return 0;
-}
-fs_initcall(init_tlbflush_time);
-#endif


