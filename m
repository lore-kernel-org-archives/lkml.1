Return-Path: <linux-kernel-owner+w=401wt.eu-S1765039AbZFLNih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765039AbZFLNih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763683AbZFLNbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:02 -0400
Received: from ozlabs.org ([203.10.76.45]:55274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbZFLNa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:59 -0400
CC: linux-kernel@vger.kernel.org
To: Hirokazu Takata <takata@linux-m32r.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 8/13] cpumask: use mm_cpumask() wrapper: m32r
Message-Id: <20090612133101.0FF8BDDD0C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/m32r/include/asm/mmu_context.h |    4 ++--
 arch/m32r/kernel/smp.c              |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -264,7 +264,7 @@ void smp_flush_tlb_mm(struct mm_struct *
 	preempt_disable();
 	cpu_id = smp_processor_id();
 	mmc = &mm->context[cpu_id];
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = *mm_cpumask(mm);
 	cpu_clear(cpu_id, cpu_mask);
 
 	if (*mmc != NO_CONTEXT) {
@@ -273,7 +273,7 @@ void smp_flush_tlb_mm(struct mm_struct *
 		if (mm == current->mm)
 			activate_context(mm);
 		else
-			cpu_clear(cpu_id, mm->cpu_vm_mask);
+			cpumask_clear_cpu(cpu_id, mm_cpumask(mm));
 		local_irq_restore(flags);
 	}
 	if (!cpus_empty(cpu_mask))
@@ -334,7 +334,7 @@ void smp_flush_tlb_page(struct vm_area_s
 	preempt_disable();
 	cpu_id = smp_processor_id();
 	mmc = &mm->context[cpu_id];
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = *mm_cpumask(mm);
 	cpu_clear(cpu_id, cpu_mask);
 
 #ifdef DEBUG_SMP
@@ -469,7 +469,7 @@ void smp_invalidate_interrupt(void)
 		if (flush_mm == current->active_mm)
 			activate_context(flush_mm);
 		else
-			cpu_clear(cpu_id, flush_mm->cpu_vm_mask);
+			cpumask_clear(cpu_id, mm_cpumask(flush_mm));
 	} else {
 		unsigned long va = flush_va;
 
diff --git a/arch/m32r/include/asm/mmu_context.h b/arch/m32r/include/asm/mmu_context.h
--- a/arch/m32r/include/asm/mmu_context.h
+++ b/arch/m32r/include/asm/mmu_context.h
@@ -127,7 +127,7 @@ static inline void switch_mm(struct mm_s
 
 	if (prev != next) {
 #ifdef CONFIG_SMP
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 #endif /* CONFIG_SMP */
 		/* Set MPTB = next->pgd */
 		*(volatile unsigned long *)MPTB = (unsigned long)next->pgd;
@@ -135,7 +135,7 @@ static inline void switch_mm(struct mm_s
 	}
 #ifdef CONFIG_SMP
 	else
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask))
+		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))
 			activate_context(next);
 #endif /* CONFIG_SMP */
 }

