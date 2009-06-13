Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZFMMzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZFMMzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZFMMzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:55:17 -0400
Received: from ozlabs.org ([203.10.76.45]:38482 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZFMMzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:55:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/13] cpumask: Use accessors for cpu_*_mask: arm
Date: Sat, 13 Jun 2009 22:25:12 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
References: <20090612133100.765C2DDDA0@ozlabs.org> <20090612190303.GA7976@flint.arm.linux.org.uk>
In-Reply-To: <20090612190303.GA7976@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906132225.12855.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009 04:33:03 am Russell King wrote:
> On Fri, Jun 12, 2009 at 10:33:14PM +0930, Rusty Russell wrote:
> > Use the accessors rather than frobbing bits directly (the new versions
> > are const).
>
> Please check linux-next - there are all kinds of SMP changes currently
> queued up in the ARM tree, which include most of the updates for things
> like this.

OK, here's the revision based on latest linux-next, if you wouldn't mind
taking it.  (We should really make on_each_cpu_mask an arch-indep, too).

Thanks,
Rusty.

Subject: cpumask: use mm_cpumask() wrapper: arm

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
index 55fa7ff..03cf0d5 100644
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
@@ -600,14 +600,14 @@ void flush_tlb_all(void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-	cpumask_t mask = mm->cpu_vm_mask;
+	cpumask_t mask = *mm_cpumask(mm);
 
 	on_each_cpu_mask(ipi_flush_tlb_mm, mm, 1, mask);
 }
 
 void flush_tlb_page(struct vm_area_struct *vma, unsigned long uaddr)
 {
-	cpumask_t mask = vma->vm_mm->cpu_vm_mask;
+	cpumask_t mask = *mm_cpumask(vma->vm_mm);
 	struct tlb_args ta;
 
 	ta.ta_vma = vma;
@@ -628,7 +628,7 @@ void flush_tlb_kernel_page(unsigned long kaddr)
 void flush_tlb_range(struct vm_area_struct *vma,
                      unsigned long start, unsigned long end)
 {
-	cpumask_t mask = vma->vm_mm->cpu_vm_mask;
+	cpumask_t mask = *cpumask_mm(vma->vm_mm);
 	struct tlb_args ta;
 
 	ta.ta_vma = vma;
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

