Return-Path: <linux-kernel-owner+w=401wt.eu-S933478AbZFLNlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478AbZFLNlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764500AbZFLNbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:13 -0400
Received: from ozlabs.org ([203.10.76.45]:55296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764569AbZFLNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:06 -0400
CC: linux-kernel@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 13/13] cpumask: use mm_cpumask() wrapper: x86
Message-Id: <20090612133107.2FEE1DDDE1@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask (to be a pointer).

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/include/asm/mmu_context.h |    6 +++---
 arch/x86/kernel/ldt.c              |    4 ++--
 arch/x86/mm/tlb.c                  |   15 ++++++++-------
 arch/x86/xen/mmu.c                 |    4 ++--
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -37,12 +37,12 @@ static inline void switch_mm(struct mm_s
 
 	if (likely(prev != next)) {
 		/* stop flush ipis for the previous mm */
-		cpu_clear(cpu, prev->cpu_vm_mask);
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 #ifdef CONFIG_SMP
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		percpu_write(cpu_tlbstate.active_mm, next);
 #endif
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 
 		/* Re-load page tables */
 		load_cr3(next->pgd);
@@ -58,7 +58,7 @@ static inline void switch_mm(struct mm_s
 		percpu_write(cpu_tlbstate.state, TLBSTATE_OK);
 		BUG_ON(percpu_read(cpu_tlbstate.active_mm) != next);
 
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
+		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
 			/* We were in lazy tlb mode and leave_mm disabled
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -67,8 +67,8 @@ static int alloc_ldt(mm_context_t *pc, i
 #ifdef CONFIG_SMP
 		preempt_disable();
 		load_LDT(pc);
-		if (!cpus_equal(current->mm->cpu_vm_mask,
-				cpumask_of_cpu(smp_processor_id())))
+		if (!cpumask_equal(mm_cpumask(current->mm),
+				   cpumask_of(smp_processor_id())))
 			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -59,7 +59,8 @@ void leave_mm(int cpu)
 {
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpu_clear(cpu, percpu_read(cpu_tlbstate.active_mm)->cpu_vm_mask);
+	cpumask_clear_cpu(cpu,
+			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
 	load_cr3(swapper_pg_dir);
 }
 EXPORT_SYMBOL_GPL(leave_mm);
@@ -240,8 +241,8 @@ void flush_tlb_current_task(void)
 	preempt_disable();
 
 	local_flush_tlb();
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL);
 	preempt_enable();
 }
 
@@ -255,8 +256,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 		else
 			leave_mm(smp_processor_id());
 	}
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
+	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm_cpumask(mm), mm, TLB_FLUSH_ALL);
 
 	preempt_enable();
 }
@@ -274,8 +275,8 @@ void flush_tlb_page(struct vm_area_struc
 			leave_mm(smp_processor_id());
 	}
 
-	if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
-		flush_tlb_others(&mm->cpu_vm_mask, mm, va);
+	if (cpumask_any_but(mm_cpumask(mm), smp_processor_id()) < nr_cpu_ids)
+		flush_tlb_others(mm_cpumask(mm), mm, va);
 
 	preempt_enable();
 }
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1141,14 +1141,14 @@ static void xen_drop_mm_ref(struct mm_st
 	/* Get the "official" set of cpus referring to our pagetable. */
 	if (!alloc_cpumask_var(&mask, GFP_ATOMIC)) {
 		for_each_online_cpu(cpu) {
-			if (!cpumask_test_cpu(cpu, &mm->cpu_vm_mask)
+			if (!cpumask_test_cpu(cpu, mm_cpumask(mm))
 			    && per_cpu(xen_current_cr3, cpu) != __pa(mm->pgd))
 				continue;
 			smp_call_function_single(cpu, drop_other_mm_ref, mm, 1);
 		}
 		return;
 	}
-	cpumask_copy(mask, &mm->cpu_vm_mask);
+	cpumask_copy(mask, mm_cpumask(mm));
 
 	/* It's possible that a vcpu may have a stale reference to our
 	   cr3, because its in lazy mode, and it hasn't yet flushed

