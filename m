Return-Path: <linux-kernel-owner+w=401wt.eu-S1751274AbZCPEOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbZCPEOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZCPEOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:18 -0400
Received: from ozlabs.org ([203.10.76.45]:57306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbZCPEOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:16 -0400
Subject: [PULL] cpumask updates for arm
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:08 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.09281.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-arm.git master

Rusty Russell (4):
      cpumask: Use smp_call_function_many(): arm
      cpumask: arch_send_call_function_ipi_mask: arm
      cpumask: Use accessors code.: arm
      cpumask: use mm_cpumask() wrapper: arm

 arch/arm/include/asm/cacheflush.h  |    8 ++++----
 arch/arm/include/asm/mmu_context.h |    7 ++++---
 arch/arm/include/asm/smp.h         |    3 ++-
 arch/arm/include/asm/tlbflush.h    |    4 ++--
 arch/arm/kernel/smp.c              |   31 ++++++++++++-------------------
 arch/arm/mach-realview/platsmp.c   |    2 +-
 arch/arm/mm/context.c              |    2 +-
 arch/arm/mm/flush.c                |   10 +++++-----
 8 files changed, 31 insertions(+), 36 deletions(-)

commit c2cadab1d993bb0efb97e24d2cad6398d8148baa
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:05:38 2009 +1030

    cpumask: use mm_cpumask() wrapper: arm
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 6cbd8fd..b425fb2 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -318,14 +318,14 @@ static inline void outer_flush_range(unsigned long start, unsigned long end)
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
@@ -333,7 +333,7 @@ flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long
 static inline void
 flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn)
 {
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		unsigned long addr = user_addr & PAGE_MASK;
 		__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
 	}
@@ -344,7 +344,7 @@ flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 			 unsigned long uaddr, void *kaddr,
 			 unsigned long len, int write)
 {
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		unsigned long addr = (unsigned long)kaddr;
 		__cpuc_coherent_kern_range(addr, addr + len);
 	}
diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 263fed0..c3fe09f 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -101,14 +101,15 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 
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
index b543a05..5d0fbb0 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -316,7 +316,7 @@ static inline void local_flush_tlb_mm(struct mm_struct *mm)
 	if (tlb_flag(TLB_WB))
 		dsb();
 
-	if (cpu_isset(smp_processor_id(), mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm))) {
 		if (tlb_flag(TLB_V3_FULL))
 			asm("mcr p15, 0, %0, c6, c0, 0" : : "r" (zero) : "cc");
 		if (tlb_flag(TLB_V4_U_FULL))
@@ -354,7 +354,7 @@ local_flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	if (tlb_flag(TLB_WB))
 		dsb();
 
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 		if (tlb_flag(TLB_V3_PAGE))
 			asm("mcr p15, 0, %0, c6, c0, 0" : : "r" (uaddr) : "cc");
 		if (tlb_flag(TLB_V4_U_PAGE))
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 6d3c5f7..8875e5b 100644
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
 
@@ -251,7 +251,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
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
@@ -607,7 +607,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, &vma->vm_mm->cpu_vm_mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -628,7 +628,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, &vma->vm_mm->cpu_vm_mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mm_cpumask(vma->vm_mm));
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index fc84fcc..6bda76a 100644
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
index 0fa9bf3..527d816 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -41,7 +41,7 @@ static void flush_pfn_alias(unsigned long pfn, unsigned long vaddr)
 void flush_cache_mm(struct mm_struct *mm)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), mm->cpu_vm_mask))
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(mm)))
 			__cpuc_flush_user_all();
 		return;
 	}
@@ -59,7 +59,7 @@ void flush_cache_mm(struct mm_struct *mm)
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask))
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)))
 			__cpuc_flush_user_range(start & PAGE_MASK, PAGE_ALIGN(end),
 						vma->vm_flags);
 		return;
@@ -78,7 +78,7 @@ void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned
 void flush_cache_page(struct vm_area_struct *vma, unsigned long user_addr, unsigned long pfn)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 			unsigned long addr = user_addr & PAGE_MASK;
 			__cpuc_flush_user_range(addr, addr + PAGE_SIZE, vma->vm_flags);
 		}
@@ -94,7 +94,7 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 			 unsigned long len, int write)
 {
 	if (cache_is_vivt()) {
-		if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask)) {
+		if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm))) {
 			unsigned long addr = (unsigned long)kaddr;
 			__cpuc_coherent_kern_range(addr, addr + len);
 		}
@@ -107,7 +107,7 @@ void flush_ptrace_access(struct vm_area_struct *vma, struct page *page,
 	}
 
 	/* VIPT non-aliasing cache */
-	if (cpu_isset(smp_processor_id(), vma->vm_mm->cpu_vm_mask) &&
+	if (cpumask_test_cpu(smp_processor_id(), mm_cpumask(vma->vm_mm)) &&
 	    vma->vm_flags & VM_EXEC) {
 		unsigned long addr = (unsigned long)kaddr;
 		/* only flushing the kernel mapping on non-aliasing VIPT */

commit 05b251458fb50d6358f8fd9e32faeffb982f2ec8
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:05:37 2009 +1030

    cpumask: Use accessors code.: arm
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index ea3c755..8f437c0 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -191,7 +191,7 @@ void __init smp_init_cpus(void)
 	unsigned int i, ncores = get_core_count();
 
 	for (i = 0; i < ncores; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)

commit 6587664d18f0488124dbfe20355b1aa04e615afd
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:05:37 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: arm
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index fad70da..748afba 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -102,7 +102,8 @@ extern int platform_cpu_kill(unsigned int cpu);
 extern void platform_cpu_enable(unsigned int cpu);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 /*
  * Local timer interrupt handling function (can be IPI'ed).
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8994fa7..6d3c5f7 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -347,9 +347,9 @@ static void send_ipi_message(cpumask_t callmap, enum ipi_msg_type msg)
 	local_irq_restore(flags);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	send_ipi_message(mask, IPI_CALL_FUNC);
+	send_ipi_message(*mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)

commit 677dc1c1d389d74ed39032b84b0573d3b516f5d4
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:05:36 2009 +1030

    cpumask: Use smp_call_function_many(): arm
    
    Change smp_call_function_mask() callers to smp_call_function_many().
    
    I chose to make on_each_cpu_mask() take a cpumask pointer; for the small
    cpumasks on arm this is probably a slight pessimization, but it sets
    a good example for generic code which is being weaned off on-stack
    cpumasks.  I can simplify this patch further if you wish.
    
    Compile-tested only.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 55fa7ff..8994fa7 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -526,20 +526,17 @@ int setup_profiling_timer(unsigned int multiplier)
 	return -EINVAL;
 }
 
-static int
-on_each_cpu_mask(void (*func)(void *), void *info, int wait, cpumask_t mask)
+static void
+on_each_cpu_mask(void (*func)(void *), void *info, int wait,
+		 const struct cpumask *mask)
 {
-	int ret = 0;
-
 	preempt_disable();
 
-	ret = smp_call_function_mask(mask, func, info, wait);
-	if (cpu_isset(smp_processor_id(), mask))
+	smp_call_function_many(mask, func, info, wait);
+	if (cpumask_test_cpu(smp_processor_id(), mask))
 		func(info);
 
 	preempt_enable();
-
-	return ret;
 }
 
 /**********************************************************************/
@@ -600,20 +597,17 @@ void flush_tlb_all(void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t mask = mm->cpu_vm_mask;
-
-	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, &mm->cpu_vm_mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 {
-	cpumask_t mask = vma->vm_mm->cpu_vm_mask;
 	struct tlb_args ta;
 
 	ta.ta_vma = vma;
 	ta.ta_start = uaddr;
 
-	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, &vma->vm_mm->cpu_vm_mask);
 }
 
 void flush_tlb_kernel_page(unsigned long kaddr)
@@ -628,14 +622,13 @@ void flush_tlb_kernel_page(unsigned long kaddr)
 void flush_tlb_range(struct vm_area_struct *vma,
                      unsigned long start, unsigned long end)
 {
-	cpumask_t mask = vma->vm_mm->cpu_vm_mask;
 	struct tlb_args ta;
 
 	ta.ta_vma = vma;
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, mask);
+	on_each_cpu_mask(ipi_flush_tlb_range, &ta, 1, &vma->vm_mm->cpu_vm_mask);
 }
 
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)

