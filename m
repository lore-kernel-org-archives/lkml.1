Return-Path: <linux-kernel-owner+w=401wt.eu-S1764177AbZAUItp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764177AbZAUItp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181AbZAUIqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:38081 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbZAUIqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:40 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] x86: rename tlb_64.c to tlb.c
Date: Wed, 21 Jan 2009 17:46:18 +0900
Message-Id: <1232527578-1960-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: file rename

tlb_64.c is now the tlb code for both 32 and 64.  Rename it to tlb.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/Makefile |    2 +-
 arch/x86/kernel/tlb.c    |  296 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/tlb_64.c |  296 ----------------------------------------------
 3 files changed, 297 insertions(+), 297 deletions(-)
 create mode 100644 arch/x86/kernel/tlb.c
 delete mode 100644 arch/x86/kernel/tlb_64.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index a62a15c..0626a88 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,7 +58,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_64.o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/tlb.c b/arch/x86/kernel/tlb.c
new file mode 100644
index 0000000..b3ca1b9
--- /dev/null
+++ b/arch/x86/kernel/tlb.c
@@ -0,0 +1,296 @@
+#include <linux/init.h>
+
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+#include <asm/apic.h>
+#include <asm/uv/uv.h>
+
+DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
+			= { &init_mm, 0, };
+
+#include <mach_ipi.h>
+/*
+ *	Smarter SMP flushing macros.
+ *		c/o Linus Torvalds.
+ *
+ *	These mean you can really definitely utterly forget about
+ *	writing to user space from interrupts. (Its not allowed anyway).
+ *
+ *	Optimizations Manfred Spraul <manfred@colorfullife.com>
+ *
+ *	More scalable flush, from Andi Kleen
+ *
+ *	To avoid global state use 8 different call vectors.
+ *	Each CPU uses a specific vector to trigger flushes on other
+ *	CPUs. Depending on the received vector the target CPUs look into
+ *	the right per cpu variable for the flush data.
+ *
+ *	With more than 8 CPUs they are hashed to the 8 available
+ *	vectors. The limited global vector space forces us to this right now.
+ *	In future when interrupts are split into per CPU domains this could be
+ *	fixed, at the cost of triggering multiple IPIs in some cases.
+ */
+
+union smp_flush_state {
+	struct {
+		struct mm_struct *flush_mm;
+		unsigned long flush_va;
+		spinlock_t tlbstate_lock;
+		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
+	};
+	char pad[SMP_CACHE_BYTES];
+} ____cacheline_aligned;
+
+/* State is put into the per CPU data section, but padded
+   to a full cache line because other CPUs can access it and we don't
+   want false sharing in the per cpu data segment. */
+static DEFINE_PER_CPU(union smp_flush_state, flush_state);
+
+/*
+ * We cannot call mmdrop() because we are in interrupt context,
+ * instead update mm->cpu_vm_mask.
+ */
+void leave_mm(int cpu)
+{
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
+		BUG();
+	cpu_clear(cpu, percpu_read(cpu_tlbstate.active_mm)->cpu_vm_mask);
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
+ *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
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
+/*
+ * FIXME: use of asmlinkage is not consistent.  On x86_64 it's noop
+ * but still used for documentation purpose but the usage is slightly
+ * inconsistent.  On x86_32, asmlinkage is regparm(0) but interrupt
+ * entry calls in with the first parameter in %eax.  Maybe define
+ * intrlinkage?
+ */
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
+void smp_invalidate_interrupt(struct pt_regs *regs)
+{
+	unsigned int cpu;
+	unsigned int sender;
+	union smp_flush_state *f;
+
+	cpu = smp_processor_id();
+	/*
+	 * orig_rax contains the negated interrupt vector.
+	 * Use that to determine where the sender put the data.
+	 */
+	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
+	f = &per_cpu(flush_state, sender);
+
+	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
+		goto out;
+		/*
+		 * This was a BUG() but until someone can quote me the
+		 * line from the intel manual that guarantees an IPI to
+		 * multiple CPUs is retried _only_ on the erroring CPUs
+		 * its staying as a return
+		 *
+		 * BUG();
+		 */
+
+	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
+		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
+			if (f->flush_va == TLB_FLUSH_ALL)
+				local_flush_tlb();
+			else
+				__flush_tlb_one(f->flush_va);
+		} else
+			leave_mm(cpu);
+	}
+out:
+	ack_APIC_irq();
+	smp_mb__before_clear_bit();
+	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
+	smp_mb__after_clear_bit();
+	inc_irq_stat(irq_tlb_count);
+}
+
+static void flush_tlb_others_ipi(const struct cpumask *cpumask,
+				 struct mm_struct *mm, unsigned long va)
+{
+	unsigned int sender;
+	union smp_flush_state *f;
+
+	/* Caller has disabled preemption */
+	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	f = &per_cpu(flush_state, sender);
+
+	/*
+	 * Could avoid this lock when
+	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
+	 * probably not worth checking this for a cache-hot lock.
+	 */
+	spin_lock(&f->tlbstate_lock);
+
+	f->flush_mm = mm;
+	f->flush_va = va;
+	cpumask_andnot(to_cpumask(f->flush_cpumask),
+		       cpumask, cpumask_of(smp_processor_id()));
+
+	/*
+	 * Make the above memory operations globally visible before
+	 * sending the IPI.
+	 */
+	smp_mb();
+	/*
+	 * We have to send the IPI only to
+	 * CPUs affected.
+	 */
+	send_IPI_mask(to_cpumask(f->flush_cpumask),
+		      INVALIDATE_TLB_VECTOR_START + sender);
+
+	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
+		cpu_relax();
+
+	f->flush_mm = NULL;
+	f->flush_va = 0;
+	spin_unlock(&f->tlbstate_lock);
+}
+
+void native_flush_tlb_others(const struct cpumask *cpumask,
+			     struct mm_struct *mm, unsigned long va)
+{
+	if (is_uv_system()) {
+		unsigned int cpu;
+
+		cpu = get_cpu();
+		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
+		if (cpumask)
+			flush_tlb_others_ipi(cpumask, mm, va);
+		put_cpu();
+		return;
+	}
+	flush_tlb_others_ipi(cpumask, mm, va);
+}
+
+static int __cpuinit init_smp_flush(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
+
+	return 0;
+}
+core_initcall(init_smp_flush);
+
+void flush_tlb_current_task(void)
+{
+	struct mm_struct *mm = current->mm;
+
+	preempt_disable();
+
+	local_flush_tlb();
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
+	preempt_enable();
+}
+
+void flush_tlb_mm(struct mm_struct *mm)
+{
+	preempt_disable();
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			local_flush_tlb();
+		else
+			leave_mm(smp_processor_id());
+	}
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
+
+	preempt_enable();
+}
+
+void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
+{
+	struct mm_struct *mm = vma->vm_mm;
+
+	preempt_disable();
+
+	if (current->active_mm == mm) {
+		if (current->mm)
+			__flush_tlb_one(va);
+		else
+			leave_mm(smp_processor_id());
+	}
+
+	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
+
+	preempt_enable();
+}
+
+static void do_flush_tlb_all(void *info)
+{
+	unsigned long cpu = smp_processor_id();
+
+	__flush_tlb_all();
+	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
+		leave_mm(cpu);
+}
+
+void flush_tlb_all(void)
+{
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
+}
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
deleted file mode 100644
index b3ca1b9..0000000
--- a/arch/x86/kernel/tlb_64.c
+++ /dev/null
@@ -1,296 +0,0 @@
-#include <linux/init.h>
-
-#include <linux/mm.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-
-#include <asm/tlbflush.h>
-#include <asm/mmu_context.h>
-#include <asm/apic.h>
-#include <asm/uv/uv.h>
-
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
-			= { &init_mm, 0, };
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
- *
- *	More scalable flush, from Andi Kleen
- *
- *	To avoid global state use 8 different call vectors.
- *	Each CPU uses a specific vector to trigger flushes on other
- *	CPUs. Depending on the received vector the target CPUs look into
- *	the right per cpu variable for the flush data.
- *
- *	With more than 8 CPUs they are hashed to the 8 available
- *	vectors. The limited global vector space forces us to this right now.
- *	In future when interrupts are split into per CPU domains this could be
- *	fixed, at the cost of triggering multiple IPIs in some cases.
- */
-
-union smp_flush_state {
-	struct {
-		struct mm_struct *flush_mm;
-		unsigned long flush_va;
-		spinlock_t tlbstate_lock;
-		DECLARE_BITMAP(flush_cpumask, NR_CPUS);
-	};
-	char pad[SMP_CACHE_BYTES];
-} ____cacheline_aligned;
-
-/* State is put into the per CPU data section, but padded
-   to a full cache line because other CPUs can access it and we don't
-   want false sharing in the per cpu data segment. */
-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
-
-/*
- * We cannot call mmdrop() because we are in interrupt context,
- * instead update mm->cpu_vm_mask.
- */
-void leave_mm(int cpu)
-{
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
-		BUG();
-	cpu_clear(cpu, percpu_read(cpu_tlbstate.active_mm)->cpu_vm_mask);
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
- *	the other cpus, but smp_invalidate_interrupt ignore flush ipis
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
-/*
- * FIXME: use of asmlinkage is not consistent.  On x86_64 it's noop
- * but still used for documentation purpose but the usage is slightly
- * inconsistent.  On x86_32, asmlinkage is regparm(0) but interrupt
- * entry calls in with the first parameter in %eax.  Maybe define
- * intrlinkage?
- */
-#ifdef CONFIG_X86_64
-asmlinkage
-#endif
-void smp_invalidate_interrupt(struct pt_regs *regs)
-{
-	unsigned int cpu;
-	unsigned int sender;
-	union smp_flush_state *f;
-
-	cpu = smp_processor_id();
-	/*
-	 * orig_rax contains the negated interrupt vector.
-	 * Use that to determine where the sender put the data.
-	 */
-	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &per_cpu(flush_state, sender);
-
-	if (!cpumask_test_cpu(cpu, to_cpumask(f->flush_cpumask)))
-		goto out;
-		/*
-		 * This was a BUG() but until someone can quote me the
-		 * line from the intel manual that guarantees an IPI to
-		 * multiple CPUs is retried _only_ on the erroring CPUs
-		 * its staying as a return
-		 *
-		 * BUG();
-		 */
-
-	if (f->flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(f->flush_va);
-		} else
-			leave_mm(cpu);
-	}
-out:
-	ack_APIC_irq();
-	smp_mb__before_clear_bit();
-	cpumask_clear_cpu(cpu, to_cpumask(f->flush_cpumask));
-	smp_mb__after_clear_bit();
-	inc_irq_stat(irq_tlb_count);
-}
-
-static void flush_tlb_others_ipi(const struct cpumask *cpumask,
-				 struct mm_struct *mm, unsigned long va)
-{
-	unsigned int sender;
-	union smp_flush_state *f;
-
-	/* Caller has disabled preemption */
-	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
-	f = &per_cpu(flush_state, sender);
-
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	spin_lock(&f->tlbstate_lock);
-
-	f->flush_mm = mm;
-	f->flush_va = va;
-	cpumask_andnot(to_cpumask(f->flush_cpumask),
-		       cpumask, cpumask_of(smp_processor_id()));
-
-	/*
-	 * Make the above memory operations globally visible before
-	 * sending the IPI.
-	 */
-	smp_mb();
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	send_IPI_mask(to_cpumask(f->flush_cpumask),
-		      INVALIDATE_TLB_VECTOR_START + sender);
-
-	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
-		cpu_relax();
-
-	f->flush_mm = NULL;
-	f->flush_va = 0;
-	spin_unlock(&f->tlbstate_lock);
-}
-
-void native_flush_tlb_others(const struct cpumask *cpumask,
-			     struct mm_struct *mm, unsigned long va)
-{
-	if (is_uv_system()) {
-		unsigned int cpu;
-
-		cpu = get_cpu();
-		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
-		if (cpumask)
-			flush_tlb_others_ipi(cpumask, mm, va);
-		put_cpu();
-		return;
-	}
-	flush_tlb_others_ipi(cpumask, mm, va);
-}
-
-static int __cpuinit init_smp_flush(void)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		spin_lock_init(&per_cpu(flush_state, i).tlbstate_lock);
-
-	return 0;
-}
-core_initcall(init_smp_flush);
-
-void flush_tlb_current_task(void)
-{
-	struct mm_struct *mm = current->mm;
-
-	preempt_disable();
-
-	local_flush_tlb();
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
-	preempt_enable();
-}
-
-void flush_tlb_mm(struct mm_struct *mm)
-{
-	preempt_disable();
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			local_flush_tlb();
-		else
-			leave_mm(smp_processor_id());
-	}
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
-
-	preempt_enable();
-}
-
-void flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
-{
-	struct mm_struct *mm = vma->vm_mm;
-
-	preempt_disable();
-
-	if (current->active_mm == mm) {
-		if (current->mm)
-			__flush_tlb_one(va);
-		else
-			leave_mm(smp_processor_id());
-	}
-
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
-
-	preempt_enable();
-}
-
-static void do_flush_tlb_all(void *info)
-{
-	unsigned long cpu = smp_processor_id();
-
-	__flush_tlb_all();
-	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_LAZY)
-		leave_mm(cpu);
-}
-
-void flush_tlb_all(void)
-{
-	on_each_cpu(do_flush_tlb_all, NULL, 1);
-}
-- 
1.6.0.2

