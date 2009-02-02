Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZBBXy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZBBXy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZBBXyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:54:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:30026 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbZBBXyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:54:19 -0500
Date: Tue, 3 Feb 2009 00:54:14 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: mingo@elte.hu
Cc: tglx@linutronix.de, ak@linux.intel.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [patch] x86_32: use 8 IPI vectors for tlb flush (as x86_64)
Message-ID: <20090202235414.GA16750@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch allows using 8 different IPI vectors on ia32 for tlb
flushes, this reduces the contention on the tlbstate_lock. It also makes
the 32 bits version closer to the 64 bits version.
Credits go to Andy Kleen who pointed that the 64 bits version could be
ported in a comment below.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 8de644b..491c034 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -102,11 +102,7 @@ extern void smp_error_interrupt(struct pt_regs *);
 extern void smp_reschedule_interrupt(struct pt_regs *);
 extern void smp_call_function_interrupt(struct pt_regs *);
 extern void smp_call_function_single_interrupt(struct pt_regs *);
-#ifdef CONFIG_X86_32
 extern void smp_invalidate_interrupt(struct pt_regs *);
-#else
-extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
-#endif
 #endif
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index f7ff650..42c7ba1 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -49,18 +49,20 @@
  *  some of the following vectors are 'rare', they are merged
  *  into a single vector (CALL_FUNCTION_VECTOR) to save vector space.
  *  TLB, reschedule and local APIC vectors are performance-critical.
- *
- *  Vectors 0xf0-0xfa are free (reserved for future Linux use).
  */
 #ifdef CONFIG_X86_32
 
-# define SPURIOUS_APIC_VECTOR		0xff
-# define ERROR_APIC_VECTOR		0xfe
-# define INVALIDATE_TLB_VECTOR		0xfd
-# define RESCHEDULE_VECTOR		0xfc
-# define CALL_FUNCTION_VECTOR		0xfb
-# define CALL_FUNCTION_SINGLE_VECTOR	0xfa
-# define THERMAL_APIC_VECTOR		0xf0
+ /*  Vectors 0xf8-0xf9 are free (reserved for future Linux use). */
+#define SPURIOUS_APIC_VECTOR		0xff
+#define ERROR_APIC_VECTOR		0xfe
+#define RESCHEDULE_VECTOR		0xfd
+#define CALL_FUNCTION_VECTOR		0xfc
+#define CALL_FUNCTION_SINGLE_VECTOR	0xfb
+#define THERMAL_APIC_VECTOR		0xfa
+#define INVALIDATE_TLB_VECTOR_END	0xf7
+#define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
+
+#define NUM_INVALIDATE_TLB_VECTORS	8
 
 #else
 
diff --git a/arch/x86/include/asm/mach-default/entry_arch.h b/arch/x86/include/asm/mach-default/entry_arch.h
index 6b1add8..bb76518 100644
--- a/arch/x86/include/asm/mach-default/entry_arch.h
+++ b/arch/x86/include/asm/mach-default/entry_arch.h
@@ -11,10 +11,33 @@
  */
 #ifdef CONFIG_X86_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
+BUILD_APIC_INTERRUPT(invalidate_interrupt0,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+0)
+BUILD_APIC_INTERRUPT(invalidate_interrupt1,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+1)
+BUILD_APIC_INTERRUPT(invalidate_interrupt2,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+2)
+BUILD_APIC_INTERRUPT(invalidate_interrupt3,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+3)
+BUILD_APIC_INTERRUPT(invalidate_interrupt4,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+4)
+BUILD_APIC_INTERRUPT(invalidate_interrupt5,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+5)
+BUILD_APIC_INTERRUPT(invalidate_interrupt6,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+6)
+BUILD_APIC_INTERRUPT(invalidate_interrupt7,
+		     smp_invalidate_interrupt,
+		     INVALIDATE_TLB_VECTOR_START+7)
 #endif
 
 /*
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4646902..c045afa 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -672,6 +672,19 @@ common_interrupt:
 ENDPROC(common_interrupt)
 	CFI_ENDPROC
 
+#define BUILD_APIC_INTERRUPT(name, fname, nr)	\
+ENTRY(name)				\
+	RING0_INT_FRAME;		\
+	pushl $~(nr);			\
+	CFI_ADJUST_CFA_OFFSET 4;	\
+	SAVE_ALL;			\
+	TRACE_IRQS_OFF			\
+	movl %esp,%eax;			\
+	call fname;			\
+	jmp ret_from_intr;		\
+	CFI_ENDPROC;			\
+ENDPROC(name)
+
 #define BUILD_INTERRUPT(name, nr)	\
 ENTRY(name)				\
 	RING0_INT_FRAME;		\
diff --git a/arch/x86/kernel/irqinit_32.c b/arch/x86/kernel/irqinit_32.c
index 1507ad4..209edd6 100644
--- a/arch/x86/kernel/irqinit_32.c
+++ b/arch/x86/kernel/irqinit_32.c
@@ -150,7 +150,14 @@ void __init native_init_IRQ(void)
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
 	/* IPI for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
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
index ce50546..4bf0d6e 100644
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -20,10 +20,18 @@ DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
  */
 
-static cpumask_t flush_cpumask;
-static struct mm_struct *flush_mm;
-static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
+union smp_flush_state {
+	struct {
+		cpumask_t flush_cpumask;
+		struct mm_struct *flush_mm;
+		unsigned long flush_va;
+		spinlock_t tlbstate_lock;
+	};
+	char pad[L1_CACHE_BYTES];
+} ____cacheline_internodealigned_in_smp;
+
+static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];
+
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -88,11 +96,17 @@ EXPORT_SYMBOL_GPL(leave_mm);
 
 void smp_invalidate_interrupt(struct pt_regs *regs)
 {
+	int sender;
 	unsigned long cpu;
+	union smp_flush_state *f;
 
 	cpu = get_cpu();
 
-	if (!cpu_isset(cpu, flush_cpumask))
+	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
+
+	f = &flush_state[sender];
+
+	if (!cpu_isset(cpu, f->flush_cpumask))
 		goto out;
 		/*
 		 * This was a BUG() but until someone can quote me the
@@ -103,18 +117,18 @@ void smp_invalidate_interrupt(struct pt_regs *regs)
 		 * BUG();
 		 */
 
-	if (flush_mm == x86_read_percpu(cpu_tlbstate.active_mm)) {
+	if (f->flush_mm == x86_read_percpu(cpu_tlbstate.active_mm)) {
 		if (x86_read_percpu(cpu_tlbstate.state) == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
+			if (f->flush_va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(flush_va);
+				__flush_tlb_one(f->flush_va);
 		} else
 			leave_mm(cpu);
 	}
 	ack_APIC_irq();
 	smp_mb__before_clear_bit();
-	cpu_clear(cpu, flush_cpumask);
+	cpu_clear(cpu, f->flush_cpumask);
 	smp_mb__after_clear_bit();
 out:
 	put_cpu_no_resched();
@@ -124,7 +138,9 @@ out:
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
+	int sender;
 	cpumask_t cpumask = *cpumaskp;
+	union smp_flush_state *f;
 
 	/*
 	 * A couple of (to be removed) sanity checks:
@@ -136,6 +152,9 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
 	BUG_ON(!mm);
 
+	sender = smp_processor_id() % NUM_INVALIDATE_TLB_VECTORS;
+	f = &flush_state[sender];
+
 #ifdef CONFIG_HOTPLUG_CPU
 	/* If a CPU which we ran on has gone down, OK. */
 	cpus_and(cpumask, cpumask, cpu_online_map);
@@ -143,36 +162,43 @@ void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 		return;
 #endif
 
-	/*
-	 * i'm not happy about this global shared spinlock in the
-	 * MM hot path, but we'll see how contended it is.
-	 * AK: x86-64 has a faster method that could be ported.
-	 */
-	spin_lock(&tlbstate_lock);
+	spin_lock(&f->tlbstate_lock);
 
-	flush_mm = mm;
-	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
+	f->flush_mm = mm;
+	f->flush_va = va;
+	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
 
 	/*
 	 * Make the above memory operations globally visible before
 	 * sending the IPI.
 	 */
 	smp_mb();
+
 	/*
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
-	while (!cpus_empty(flush_cpumask))
+	while (!cpus_empty(f->flush_cpumask))
 		/* nothing. lockup detection does not belong here */
 		cpu_relax();
 
-	flush_mm = NULL;
-	flush_va = 0;
-	spin_unlock(&tlbstate_lock);
+	f->flush_mm = NULL;
+	f->flush_va = 0;
+	spin_unlock(&f->tlbstate_lock);
+}
+
+static int __cpuinit init_smp_flush(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
+		spin_lock_init(&flush_state[i].tlbstate_lock);
+
+	return 0;
 }
+core_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {
