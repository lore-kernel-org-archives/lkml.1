Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbZAUIvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbZAUIvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbZAUIqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:38091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbZAUIqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:47 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/10] x86: make x86_32 use tlb_64.c
Date: Wed, 21 Jan 2009 17:46:17 +0900
Message-Id: <1232527578-1960-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: less contention when issuing invalidate IPI, cleanup

Make x86_32 use the same tlb code as 64bit.  The 64bit code uses
multiple IPI vectors for tlb shootdown to reduce contention.  This
patch makes x86_32 allocate the same 8 IPIs as x86_64 and share the
code paths.

Note that the usage of asmlinkage is inconsistent for x86_32 and 64
and calls for further cleanup.  This has been noted with a FIXME
comment in tlb_64.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/irq_vectors.h             |    7 +-
 arch/x86/include/asm/mach-default/entry_arch.h |   18 ++-
 arch/x86/kernel/Makefile                       |    2 +-
 arch/x86/kernel/entry_32.S                     |    6 +-
 arch/x86/kernel/irqinit_32.c                   |   11 +-
 arch/x86/kernel/tlb_32.c                       |  239 ------------------------
 arch/x86/kernel/tlb_64.c                       |   12 +-
 7 files changed, 47 insertions(+), 248 deletions(-)
 delete mode 100644 arch/x86/kernel/tlb_32.c

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 4ee8f80..9a83a10 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -58,8 +58,11 @@
 # define CALL_FUNCTION_VECTOR		0xfc
 # define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 # define THERMAL_APIC_VECTOR		0xfa
-/* 0xf1 - 0xf9 : free */
-# define INVALIDATE_TLB_VECTOR		0xf0
+/* 0xf8 - 0xf9 : free */
+# define INVALIDATE_TLB_VECTOR_END	0xf7
+# define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
+
+# define NUM_INVALIDATE_TLB_VECTORS	8
 
 #else
 
diff --git a/arch/x86/include/asm/mach-default/entry_arch.h b/arch/x86/include/asm/mach-default/entry_arch.h
index 6b1add8..6fa399a 100644
--- a/arch/x86/include/asm/mach-default/entry_arch.h
+++ b/arch/x86/include/asm/mach-default/entry_arch.h
@@ -11,10 +11,26 @@
  */
 #ifdef CONFIG_X86_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
+
+BUILD_INTERRUPT3(invalidate_interrupt0,INVALIDATE_TLB_VECTOR_START+0,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt1,INVALIDATE_TLB_VECTOR_START+1,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt2,INVALIDATE_TLB_VECTOR_START+2,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt3,INVALIDATE_TLB_VECTOR_START+3,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt4,INVALIDATE_TLB_VECTOR_START+4,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt5,INVALIDATE_TLB_VECTOR_START+5,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt6,INVALIDATE_TLB_VECTOR_START+6,
+		 smp_invalidate_interrupt)
+BUILD_INTERRUPT3(invalidate_interrupt7,INVALIDATE_TLB_VECTOR_START+7,
+		 smp_invalidate_interrupt)
 #endif
 
 /*
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index eb07453..a62a15c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -58,7 +58,7 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o
-obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_$(BITS).o
+obj-$(CONFIG_X86_SMP)		+= smpboot.o tsc_sync.o ipi.o tlb_64.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4646902..a0b91aa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -672,7 +672,7 @@ common_interrupt:
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
-#define BUILD_INTERRUPT(name, nr)	\
+#define BUILD_INTERRUPT3(name, nr, fn)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
 	pushl $~(nr);			\
@@ -680,11 +680,13 @@ ENTRY(name)				\
 	SAVE_ALL;			\
 	TRACE_IRQS_OFF			\
 	movl %esp,%eax;			\
-	call smp_##name;		\
+	call fn;			\
 	jmp ret_from_intr;		\
 	CFI_ENDPROC;			\
 ENDPROC(name)
 
+#define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
+
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
 
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 1507ad4..bf629ca 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -149,8 +149,15 @@ void __init native_init_IRQ(void)
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
-	/* IPI for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
+	/* IPIs for invalidation */
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
+	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
 
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
deleted file mode 100644
index 93fcb05..0000000
--- a/arch/x86/kernel/tlb_32.c
+++ /dev/null
@@ -1,239 +0,0 @@
-#include <linux/spinlock.h>
-#include <linux/cpu.h>
-#include <linux/interrupt.h>
-
-#include <asm/tlbflush.h>
-
-DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
-			= { &init_mm, 0, };
-
-/* must come after the send_IPI functions above for inlining */
-#include <mach_ipi.h>
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
-static cpumask_var_t flush_cpumask;
-static struct mm_struct *flush_mm;
-static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
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
-	BUG_ON(percpu_read(cpu_tlbstate.state) == TLBSTATE_OK);
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
- * 	Stop ipi delivery for the old mm. This is not synchronized with
- * 	the other cpus, but smp_invalidate_interrupt ignore flush ipis
- * 	for the wrong mm, and in the worst case we perform a superfluous
- * 	tlb flush.
- * 1a2) set cpu_tlbstate to TLBSTATE_OK
- * 	Now the smp_invalidate_interrupt won't call leave_mm if cpu0
- *	was in lazy tlb mode.
- * 1a3) update cpu_tlbstate[].active_mm
- * 	Now cpu0 accepts tlb flushes for the new mm.
- * 1a4) cpu_set(cpu, new_mm->cpu_vm_mask);
- * 	Now the other cpus will send tlb flush ipis.
- * 1a4) change cr3.
- * 1b) thread switch without mm change
- *	cpu_tlbstate[].active_mm is correct, cpu0 already handles
- *	flush ipis.
- * 1b1) set cpu_tlbstate to TLBSTATE_OK
- * 1b2) test_and_set the cpu bit in cpu_vm_mask.
- * 	Atomically set the bit [other cpus will start sending flush ipis],
- * 	and test the bit.
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
-void smp_invalidate_interrupt(struct pt_regs *regs)
-{
-	unsigned int cpu;
-
-	cpu = smp_processor_id();
-
-	if (!cpumask_test_cpu(cpu, flush_cpumask))
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
-	if (flush_mm == percpu_read(cpu_tlbstate.active_mm)) {
-		if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
-				local_flush_tlb();
-			else
-				__flush_tlb_one(flush_va);
-		} else
-			leave_mm(cpu);
-	}
-out:
-	ack_APIC_irq();
-	smp_mb__before_clear_bit();
-	cpumask_clear_cpu(cpu, flush_cpumask);
-	smp_mb__after_clear_bit();
-	inc_irq_stat(irq_tlb_count);
-}
-
-void native_flush_tlb_others(const struct cpumask *cpumask,
-			     struct mm_struct *mm, unsigned long va)
-{
-	/*
-	 * - mask must exist :)
-	 */
-	BUG_ON(cpumask_empty(cpumask));
-	BUG_ON(!mm);
-
-	/*
-	 * i'm not happy about this global shared spinlock in the
-	 * MM hot path, but we'll see how contended it is.
-	 * AK: x86-64 has a faster method that could be ported.
-	 */
-	spin_lock(&tlbstate_lock);
-
-	cpumask_andnot(flush_cpumask, cpumask, cpumask_of(smp_processor_id()));
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
-	cpumask_and(flush_cpumask, flush_cpumask, cpu_online_mask);
-	if (unlikely(cpumask_empty(flush_cpumask))) {
-		spin_unlock(&tlbstate_lock);
-		return;
-	}
-#endif
-	flush_mm = mm;
-	flush_va = va;
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
-	send_IPI_mask(flush_cpumask, INVALIDATE_TLB_VECTOR);
-
-	while (!cpumask_empty(flush_cpumask))
-		/* nothing. lockup detection does not belong here */
-		cpu_relax();
-
-	flush_mm = NULL;
-	flush_va = 0;
-	spin_unlock(&tlbstate_lock);
-}
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
-
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
-		 else
-			leave_mm(smp_processor_id());
-	}
-
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
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
-
-static int init_flush_cpumask(void)
-{
-	alloc_cpumask_var(&flush_cpumask, GFP_KERNEL);
-	return 0;
-}
-early_initcall(init_flush_cpumask);
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 19ac661..b3ca1b9 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -113,7 +113,17 @@ EXPORT_SYMBOL_GPL(leave_mm);
  * Interrupts are disabled.
  */
 
-asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
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
 {
 	unsigned int cpu;
 	unsigned int sender;
-- 
1.6.0.2

