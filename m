Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYHBA1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYHBA1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 20:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYHBAZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 20:25:12 -0400
Received: from c-98-210-159-26.hsd1.ca.comcast.net ([98.210.159.26]:46994 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbYHBAZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:25:05 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 1 of 8] x86-32: use smp_call_function_mask for SMP TLB
	invalidations
X-Mercurial-Node: 9eff6b2f9ff361b073473d30e09edc711a1afeac
Message-Id: <9eff6b2f9ff361b07347.1217636086@localhost>
In-Reply-To: <patchbomb.1217636085@localhost>
Date: Fri, 01 Aug 2008 17:14:46 -0700
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

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic_32.c                 |    3 -
 arch/x86/kernel/tlb_32.c                  |   86 +++++------------------------
 include/asm-x86/irq_vectors.h             |    1
 include/asm-x86/mach-default/entry_arch.h |    1
 4 files changed, 17 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1381,9 +1381,6 @@
 	 */
 	alloc_intr_gate(RESCHEDULE_VECTOR, reschedule_interrupt);
 
-	/* IPI for invalidation */
-	alloc_intr_gate(INVALIDATE_TLB_VECTOR, invalidate_interrupt);
-
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
--- a/arch/x86/kernel/tlb_32.c
+++ b/arch/x86/kernel/tlb_32.c
@@ -1,14 +1,12 @@
-#include <linux/spinlock.h>
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
+#include <linux/smp.h>
+#include <linux/percpu.h>
 
 #include <asm/tlbflush.h>
 
 DEFINE_PER_CPU(struct tlb_state, cpu_tlbstate)
 			____cacheline_aligned = { &init_mm, 0, };
-
-/* must come after the send_IPI functions above for inlining */
-#include <mach_ipi.h>
 
 /*
  *	Smarter SMP flushing macros.
@@ -20,10 +18,10 @@
  *	Optimizations Manfred Spraul <manfred@colorfullife.com>
  */
 
-static cpumask_t flush_cpumask;
-static struct mm_struct *flush_mm;
-static unsigned long flush_va;
-static DEFINE_SPINLOCK(tlbstate_lock);
+struct tlb_flush {
+	struct mm_struct *mm;
+	unsigned long va;
+};
 
 /*
  * We cannot call mmdrop() because we are in interrupt context,
@@ -87,37 +85,23 @@
  * 2) Leave the mm if we are in the lazy tlb mode.
  */
 
-void smp_invalidate_interrupt(struct pt_regs *regs)
+static void tlb_invalidate(void *arg)
 {
+	struct tlb_flush *flush = arg;
 	unsigned long cpu;
 
 	cpu = get_cpu();
 
-	if (!cpu_isset(cpu, flush_cpumask))
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
-	if (flush_mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
+	if (flush->mm == per_cpu(cpu_tlbstate, cpu).active_mm) {
 		if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK) {
-			if (flush_va == TLB_FLUSH_ALL)
+			if (flush->va == TLB_FLUSH_ALL)
 				local_flush_tlb();
 			else
-				__flush_tlb_one(flush_va);
+				__flush_tlb_one(flush->va);
 		} else
 			leave_mm(cpu);
 	}
-	ack_APIC_irq();
-	smp_mb__before_clear_bit();
-	cpu_clear(cpu, flush_cpumask);
-	smp_mb__after_clear_bit();
-out:
+
 	put_cpu_no_resched();
 	__get_cpu_var(irq_stat).irq_tlb_count++;
 }
@@ -125,48 +109,12 @@
 void native_flush_tlb_others(const cpumask_t *cpumaskp, struct mm_struct *mm,
 			     unsigned long va)
 {
-	cpumask_t cpumask = *cpumaskp;
+	struct tlb_flush flush = {
+		.mm = mm,
+		.va = va
+	};
 
-	/*
-	 * A couple of (to be removed) sanity checks:
-	 *
-	 * - current CPU must not be in mask
-	 * - mask must exist :)
-	 */
-	BUG_ON(cpus_empty(cpumask));
-	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
-	BUG_ON(!mm);
-
-#ifdef CONFIG_HOTPLUG_CPU
-	/* If a CPU which we ran on has gone down, OK. */
-	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (unlikely(cpus_empty(cpumask)))
-		return;
-#endif
-
-	/*
-	 * i'm not happy about this global shared spinlock in the
-	 * MM hot path, but we'll see how contended it is.
-	 * AK: x86-64 has a faster method that could be ported.
-	 */
-	spin_lock(&tlbstate_lock);
-
-	flush_mm = mm;
-	flush_va = va;
-	cpus_or(flush_cpumask, cpumask, flush_cpumask);
-	/*
-	 * We have to send the IPI only to
-	 * CPUs affected.
-	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR);
-
-	while (!cpus_empty(flush_cpumask))
-		/* nothing. lockup detection does not belong here */
-		cpu_relax();
-
-	flush_mm = NULL;
-	flush_va = 0;
-	spin_unlock(&tlbstate_lock);
+	smp_call_function_mask(*cpumaskp, tlb_invalidate, &flush, 1);
 }
 
 void flush_tlb_current_task(void)
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -61,7 +61,6 @@
 
 # define SPURIOUS_APIC_VECTOR		0xff
 # define ERROR_APIC_VECTOR		0xfe
-# define INVALIDATE_TLB_VECTOR		0xfd
 # define RESCHEDULE_VECTOR		0xfc
 # define CALL_FUNCTION_VECTOR		0xfb
 # define CALL_FUNCTION_SINGLE_VECTOR	0xfa
diff --git a/include/asm-x86/mach-default/entry_arch.h b/include/asm-x86/mach-default/entry_arch.h
--- a/include/asm-x86/mach-default/entry_arch.h
+++ b/include/asm-x86/mach-default/entry_arch.h
@@ -11,7 +11,6 @@
  */
 #ifdef CONFIG_X86_SMP
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
-BUILD_INTERRUPT(invalidate_interrupt,INVALIDATE_TLB_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
 #endif


