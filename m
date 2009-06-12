Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbZFLNjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbZFLNjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764950AbZFLNbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:08 -0400
Received: from ozlabs.org ([203.10.76.45]:55281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762131AbZFLNbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:04 -0400
CC: linux-kernel@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 7/13] cpumask: use mm_cpumask() wrapper: arm
Message-Id: <20090612133103.C87AFDDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/include/asm/cacheflush.h  |    8 ++++----
 arch/arm/include/asm/mmu_context.h |    7 ++++---
 arch/arm/include/asm/tlbflush.h    |    4 ++--
 arch/arm/kernel/smp.c              |   10 +++++-----
 arch/arm/mm/context.c              |    2 +-
 arch/arm/mm/flush.c                |   10 +++++-----
 6 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -318,14 +318,14 @@ static inline void outer_flush_range(uns
 #ifndef CONFIG_CPU_CACHE_VIPT
 static inline void flush_cache_mm(struct mm_struct *mm)
 {
-	if (cpu_isset(smp_processor_id(), mm->cpu_vm_mask))
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm)))
 		__cpuc_flush_user_all();
 }
 
 static inline void
 flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask))
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
 		__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
 					vma->vm_flags);
 }
@@ -333,7 +333,7 @@ static inline void
 static inline void
 flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn)
 {
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		unsigned long addr = user_addr & PAGE_MASK;
 		__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
 	}
@@ -344,7 +344,7 @@ flush_ptrace_access(struct vm_area_struc
 			 unsigned long uaddr, void *kaddr,
 			 unsigned long len, int write)
 {
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		unsigned long addr = (unsigned long)kaddr;
 		__cpuc_coherent_kern_range(addr, addr + len);
 	}
diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -101,14 +101,15 @@ switch_mm(struct mm_struct *prev, struct
 
 #ifdef CONFIG_SMP
 	/* check for possible thread migration */
-	if (!cpus_empty(next->cpu_vm_mask) && !cpu_isset(cpu, next->cpu_vm_mask))
+	if (!cpumask_empty(mm_cpumask(next)) &&
+	    !cpumask_test_cpu(cpu, mm_cpumask(next)))
 		__flush_icache_all();
 #endif
-	if (!cpu_test_and_set(cpu, next->cpu_vm_mask) || prev != next) {
+	if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next)) || prev != next) {
 		check_context(next);
 		cpu_switch_mm(next->pgd, next);
 		if (cache_is_vivt())
-			cpu_clear(cpu, prev->cpu_vm_mask);
+			cpumask_clear_cpu(cpu, mm_cpumask(prev));
 	}
 #endif
 }
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -316,7 +316,7 @@ static inline void local_flush_tlb_mm(st
 	if (tlb_flag(TLB_WB))
 		dsb();
 
-	if (cpu_isset(smp_processor_id(), mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm))) {
 		if (tlb_flag(TLB_V3_FULL))
 			asm("mcr p15, 0, %0, c6, c0, 0" : : "r" (zero) : "cc");
 		if (tlb_flag(TLB_V4_U_FULL))
@@ -354,7 +354,7 @@ local_flush_tlb_page(struct vm_area_stru
 	if (tlb_flag(TLB_WB))
 		dsb();
 
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		if (tlb_flag(TLB_V3_PAGE))
 			asm("mcr p15, 0, %0, c6, c0, 0" : : "r" (uaddr) : "cc");
 		if (tlb_flag(TLB_V4_U_PAGE))
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -183,7 +183,7 @@ int __cpuexit __cpu_disable(void)
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		if (p->mm)
-			cpu_clear(cpu, p->mm->cpu_vm_mask);
+			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
 	}
 	read_unlock(&tasklist_lock);
 
@@ -251,7 +251,7 @@ asmlinkage void __cpuinit secondary_star
 	atomic_inc(&mm->mm_users);
 	atomic_inc(&mm->mm_count);
 	current->active_mm = mm;
-	cpu_set(cpu, mm->cpu_vm_mask);
+	cpumask_set_cpu(cpu, mm_cpumask(mm));
 	cpu_switch_mm(mm->pgd, mm);
 	enter_lazy_tlb(mm, current);
 	local_flush_tlb_all();
@@ -597,7 +597,7 @@ void flush_tlb_all(void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, &mm->cpu_vm_mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mm_cpumask(mm));
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
@@ -607,7 +607,7 @@ void flush_tlb_page(struct vm_area_struc
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, &vma->vm_mm->cpu_vm_mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -628,7 +628,7 @@ void flush_tlb_range(struct vm_area_stru
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, &vma->vm_mm->cpu_vm_mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mm_cpumask(vma->vm_mm));
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -59,6 +59,6 @@ void __new_context(struct mm_struct *mm)
 	}
 	spin_unlock(&cpu_asid_lock);
 
-	mm->cpu_vm_mask = cpumask_of_cpu(smp_processor_id());
+	cpumask_copy(mm_cpumask(mm), cpumask_of(smp_processor_id()));
 	mm->context.id = asid;
 }
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -41,7 +41,7 @@ void flush_cache_mm(struct mm_struct *mm
 void flush_cache_mm(struct mm_struct *mm)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), mm->cpu_vm_mask))
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm)))
 			__cpuc_flush_user_all();
 		return;
 	}
@@ -59,7 +59,7 @@ void flush_cache_range(struct vm_area_st
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask))
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
 			__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
 						vma->vm_flags);
 		return;
@@ -78,7 +78,7 @@ void flush_cache_page(struct vm_area_str
 void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 			unsigned long addr = user_addr & PAGE_MASK;
 			__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
 		}
@@ -94,7 +94,7 @@ void flush_ptrace_access(struct vm_area_
 			 unsigned long len, int write)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 			unsigned long addr = (unsigned long)kaddr;
 			__cpuc_coherent_kern_range(addr, addr + len);
 		}
@@ -107,7 +107,7 @@ void flush_ptrace_access(struct vm_area_
 	}
 
 	/* VIPT non-aliasing cache */
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask) &&
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)) &&
 	    vma->vm_flags & VM_EXEC) {
 		unsigned long addr = (unsigned long)kaddr;
 		/* only flushing the kernel mapping on non-aliasing VIPT */

