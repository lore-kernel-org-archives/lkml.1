Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYHBAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYHBAZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYHBAZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:25:06 -0400
Received: from c-98-210-159-26.hsd1.ca.comcast.net ([98.210.159.26]:46978 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbYHBAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:25:03 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 20:25:02 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 8] x86-64: use smp_call_function_mask for SMP TLB
	invalidations
X-Mercurial-Node: ad55f33413c68f49edbb9546a4c7282be9f368b6
Message-Id: <ad55f33413c68f49edbb.1217636087@localhost>
In-Reply-To: <patchbomb.1217636085@localhost>
Date: Fri, 01 Aug 2008 17:14:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that smp_call_function_mask exists and is scalable, there's no
reason to have a special TLB flush IPI.  This saves a mass of code.

In the process, I removed a copy of a cpumask_t.  The UV tlb flush
code relies on that copy, so I propagated it down.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/entry_64.S    |   15 ----
 arch/x86/kernel/irqinit_64.c  |   10 ---
 arch/x86/kernel/tlb_64.c      |  125 ++++++-----------------------------------
 arch/x86/kernel/tlb_uv.c      |    5 -
 include/asm-x86/irq_vectors.h |    4 -
 include/asm-x86/uv/uv_bau.h   |    2
 6 files changed, 23 insertions(+), 138 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -869,21 +869,6 @@
 	apicinterrupt RESCHEDULE_VECTOR,smp_reschedule_interrupt
 END(reschedule_interrupt)
 
-	.macro INVALIDATE_ENTRY num
-ENTRY(invalidate_interrupt\num)
-	apicinterrupt INVALIDATE_TLB_VECTOR_START+\num,smp_invalidate_interrupt	
-END(invalidate_interrupt\num)
-	.endm
-
-	INVALIDATE_ENTRY 0
-	INVALIDATE_ENTRY 1
-	INVALIDATE_ENTRY 2
-	INVALIDATE_ENTRY 3
-	INVALIDATE_ENTRY 4
-	INVALIDATE_ENTRY 5
-	INVALIDATE_ENTRY 6
-	INVALIDATE_ENTRY 7
-
 ENTRY(call_function_interrupt)
 	apicinterrupt CALL_FUNCTION_VECTOR,smp_call_function_interrupt
 END(call_function_interrupt)
diff --git a/arch/x86/kernel/irqinit_64.c b/arch/x86/kernel/irqinit_64.c
--- a/arch/x86/kernel/irqinit_64.c
+++ b/arch/x86/kernel/irqinit_64.c
@@ -187,16 +187,6 @@
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
-	/* IPIs for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+0, invalidate_interrupt0);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+1, invalidate_interrupt1);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+2, invalidate_interrupt2);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+3, invalidate_interrupt3);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+4, invalidate_interrupt4);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+5, invalidate_interrupt5);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+6, invalidate_interrupt6);
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR_START+7, invalidate_interrupt7);
-
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -1,24 +1,16 @@
-#include <linux/init.h>
-
 #include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/spinlock.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
-#include <linux/mc146818rtc.h>
-#include <linux/interrupt.h>
+#include <linux/module.h>
 
-#include <asm/mtrr.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-#include <asm/proto.h>
-#include <asm/apicdef.h>
-#include <asm/idle.h>
+
+/* For UV tlb flush */
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_bau.h>
+#include <asm/genapic.h>	/* for is_uv_system */
 
-#include <mach_ipi.h>
 /*
  *	Smarter SMP flushing macros.
  *		c/o Linus Torvalds.
@@ -27,34 +19,12 @@
  *	writing to user space from interrupts. (Its not allowed anyway).
  *
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
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
  */
 
-union smp_flush_state {
-	struct {
-		cpumask_t flush_cpumask;
-		struct mm_struct *flush_mm;
-		unsigned long flush_va;
-		spinlock_t tlbstate_lock;
-	};
-	char pad[SMP_CACHE_BYTES];
-} ____cacheline_aligned;
-
-/* State is put into the per CPU data section, but padded
-   to a full cache line because other CPUs can access it and we don't
-   want false sharing in the per cpu data segment. */
-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
+struct tlb_flush {
+	struct mm_struct *mm;
+	unsigned long va;
+};
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -117,95 +87,38 @@
  * Interrupts are disabled.
  */
 
-asmlinkage void smp_invalidate_interrupt(struct pt_regs *regs)
+static void tlb_invalidate(void *arg)
 {
+	struct tlb_flush *f = arg;
 	int cpu;
-	int sender;
-	union smp_flush_state *f;
 
 	cpu = smp_processor_id();
-	/*
-	 * orig_rax contains the negated interrupt vector.
-	 * Use that to determine where the sender put the data.
-	 */
-	sender = ~regs->orig_ax - INVALIDATE_TLB_VECTOR_START;
-	f = &per_cpu(flush_state, sender);
 
-	if (!cpu_isset(cpu, f->flush_cpumask))
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
-	if (f->flush_mm == read_pda(active_mm)) {
+	if (f->mm == read_pda(active_mm)) {
 		if (read_pda(mmu_state) == TLBSTATE_OK) {
-			if (f->flush_va == TLB_FLUSH_ALL)
+			if (f->va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(f->flush_va);
+				__flush_tlb_one(f->va);
 		} else
 			leave_mm(cpu);
 	}
-out:
-	ack_APIC_irq();
-	cpu_clear(cpu, f->flush_cpumask);
 	add_pda(irq_tlb_count, 1);
 }
 
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
-	int sender;
-	union smp_flush_state *f;
-	cpumask_t cpumask = *cpumaskp;
+	struct tlb_flush flush = {
+		.mm = mm,
+		.va = va,
+	};
 
-	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
+	if (is_uv_system() && uv_flush_tlb_others(cpumaskp, mm, va))
 		return;
 
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
-	cpus_or(f->flush_cpumask, cpumask, f->flush_cpumask);
-
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
-
-	while (!cpus_empty(f->flush_cpumask))
-		cpu_relax();
-
-	f->flush_mm = NULL;
-	f->flush_va = 0;
-	spin_unlock(&f->tlbstate_lock);
+	smp_call_function_mask(*cpumaskp, tlb_invalidate, &flush, 1);
 }
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
 
 void flush_tlb_current_task(void)
 {
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -295,7 +295,7 @@
  * Returns 1 if all remote flushing was done.
  * Returns 0 if some remote flushing remains to be done.
  */
-int uv_flush_tlb_others(cpumask_t *cpumaskp, struct mm_struct *mm,
+int uv_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 			unsigned long va)
 {
 	int i;
@@ -305,6 +305,7 @@
 	int this_blade;
 	int locals = 0;
 	struct bau_desc *bau_desc;
+	cpumask_t cpumask = *cpumaskp;
 
 	cpu = uv_blade_processor_id();
 	this_blade = uv_numa_blade_id();
@@ -339,7 +340,7 @@
 	bau_desc->payload.address = va;
 	bau_desc->payload.sending_cpu = smp_processor_id();
 
-	return uv_flush_send_and_wait(cpu, this_blade, bau_desc, cpumaskp);
+	return uv_flush_send_and_wait(cpu, this_blade, bau_desc, &cpumask);
 }
 
 /*
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -75,10 +75,6 @@
 #define CALL_FUNCTION_SINGLE_VECTOR	0xfb
 #define THERMAL_APIC_VECTOR		0xfa
 #define THRESHOLD_APIC_VECTOR		0xf9
-#define INVALIDATE_TLB_VECTOR_END	0xf7
-#define INVALIDATE_TLB_VECTOR_START	0xf0	/* f0-f7 used for TLB flush */
-
-#define NUM_INVALIDATE_TLB_VECTORS	8
 
 #endif
 
diff --git a/include/asm-x86/uv/uv_bau.h b/include/asm-x86/uv/uv_bau.h
--- a/include/asm-x86/uv/uv_bau.h
+++ b/include/asm-x86/uv/uv_bau.h
@@ -330,7 +330,7 @@
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern int uv_flush_tlb_others(const cpumask_t *, struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 


