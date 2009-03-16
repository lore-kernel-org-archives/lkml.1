Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbZCPEPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbZCPEPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZCPEOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:40 -0400
Received: from ozlabs.org ([203.10.76.45]:57323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZCPEOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:38 -0400
Subject: [PULL] cpumask updates for m32r
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:29 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.30227.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-m32r.git master

Rusty Russell (4):
      cpumask: arch_send_call_function_ipi_mask: m32r
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: m32r
      cpumask: Use accessors code.: m32r
      cpumask: use mm_cpumask() wrapper: m32r

 arch/m32r/kernel/setup.c       |    2 +-
 arch/m32r/kernel/smp.c         |   30 +++++++++++++++---------------
 arch/m32r/kernel/smpboot.c     |    2 +-
 include/asm-m32r/mmu_context.h |    4 ++--
 include/asm-m32r/smp.h         |    3 ++-
 5 files changed, 21 insertions(+), 20 deletions(-)

commit 159a7579964b51bb11437a83935eab6ca2656e2a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:14:40 2009 +1030

    cpumask: use mm_cpumask() wrapper: m32r
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 45c512b..e6ec3cc 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -264,7 +264,7 @@ void smp_flush_tlb_mm(struct mm_struct *mm)
 	preempt_disable();
 	cpu_id = smp_processor_id();
 	mmc = &mm->context[cpu_id];
-	cpu_mask = mm->cpu_vm_mask;
+	cpu_mask = *mm_cpumask(mm);
 	cpu_clear(cpu_id, cpu_mask);
 
 	if (*mmc != NO_CONTEXT) {
@@ -273,7 +273,7 @@ void smp_flush_tlb_mm(struct mm_struct *mm)
 		if (mm == current->mm)
 			activate_context(mm);
 		else
-			cpu_clear(cpu_id, mm->cpu_vm_mask);
+			cpumask_clear_cpu(cpu_id, mm_cpumask(mm));
 		local_irq_restore(flags);
 	}
 	if (!cpus_empty(cpu_mask))
@@ -334,7 +334,7 @@ void smp_flush_tlb_page(struct vm_area_struct *vma, unsigned long va)
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
 
diff --git a/include/asm-m32r/mmu_context.h b/include/asm-m32r/mmu_context.h
index 91909e5..a735cc5 100644
--- a/include/asm-m32r/mmu_context.h
+++ b/include/asm-m32r/mmu_context.h
@@ -127,7 +127,7 @@ static inline void switch_mm(struct mm_struct *prev,
 
 	if (prev != next) {
 #ifdef CONFIG_SMP
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 #endif /* CONFIG_SMP */
 		/* Set MPTB = next->pgd */
 		*(volatile unsigned long *)MPTB = (unsigned long)next->pgd;
@@ -135,7 +135,7 @@ static inline void switch_mm(struct mm_struct *prev,
 	}
 #ifdef CONFIG_SMP
 	else
-		if (!cpu_test_and_set(cpu, next->cpu_vm_mask))
+		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))
 			activate_context(next);
 #endif /* CONFIG_SMP */
 }

commit 961a0229106f860cc024a5bb4cc84cbcd9676409
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:14:39 2009 +1030

    cpumask: Use accessors code.: m32r
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 2547d6c..ffc3bbc 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -178,7 +178,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	for (phys_id = 0 ; phys_id < nr_cpu ; phys_id++)
 		physid_set(phys_id, phys_cpu_present_map);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 
 	show_mp_info(nr_cpu);

commit 6d3a98781fb054cbdbd6836ce6839dadc2e7a953
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:14:39 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: m32r
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 0392112..f48e727 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -356,7 +356,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos < NR_CPUS ? cpu_data + *pos : NULL;
+	return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)

commit 6b72c3446e7af10acb7a32c0bbd7fb4871d61205
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:14:37 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: m32r
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask(), and by defining
    it, the old arch_send_call_function_ipi is defined by the core code.
    
    We also take the chance to wean the implementations off the
    obsolescent for_each_cpu_mask(): making send_ipi_mask take the pointer
    seemed the most natural way to ensure all implementations used
    for_each_cpu.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 929e5c9..45c512b 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -85,7 +85,7 @@ void smp_ipi_timer_interrupt(struct pt_regs *);
 void smp_local_timer_interrupt(void);
 
 static void send_IPI_allbutself(int, int);
-static void send_IPI_mask(cpumask_t, int, int);
+static void send_IPI_mask(const struct cpumask *, int, int);
 unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 /*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
@@ -113,7 +113,7 @@ unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 void smp_send_reschedule(int cpu_id)
 {
 	WARN_ON(cpu_is_offline(cpu_id));
-	send_IPI_mask(cpumask_of_cpu(cpu_id), RESCHEDULE_IPI, 1);
+	send_IPI_mask(cpumask_of(cpu_id), RESCHEDULE_IPI, 1);
 }
 
 /*==========================================================================*
@@ -168,7 +168,7 @@ void smp_flush_cache_all(void)
 	spin_lock(&flushcache_lock);
 	mask=cpus_addr(cpumask);
 	atomic_set_mask(*mask, (atomic_t *)&flushcache_cpumask);
-	send_IPI_mask(cpumask, INVALIDATE_CACHE_IPI, 0);
+	send_IPI_mask(&cpumask, INVALIDATE_CACHE_IPI, 0);
 	_flush_cache_copyback_all();
 	while (flushcache_cpumask)
 		mb();
@@ -424,7 +424,7 @@ static void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_IPI, 0);
+	send_IPI_mask(&cpumask, INVALIDATE_TLB_IPI, 0);
 
 	while (!cpus_empty(flush_cpumask)) {
 		/* nothing. lockup detection does not belong here */
@@ -546,14 +546,14 @@ static void stop_this_cpu(void *dummy)
 	for ( ; ; );
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	send_IPI_mask(mask, CALL_FUNCTION_IPI, 0);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNC_SINGLE_IPI, 0);
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI, 0);
 }
 
 /*==========================================================================*
@@ -729,7 +729,7 @@ static void send_IPI_allbutself(int ipi_num, int try)
 	cpumask = cpu_online_map;
 	cpu_clear(smp_processor_id(), cpumask);
 
-	send_IPI_mask(cpumask, ipi_num, try);
+	send_IPI_mask(&cpumask, ipi_num, try);
 }
 
 /*==========================================================================*
@@ -752,7 +752,7 @@ static void send_IPI_allbutself(int ipi_num, int try)
  * ---------- --- --------------------------------------------------------
  *
  *==========================================================================*/
-static void send_IPI_mask(cpumask_t cpumask, int ipi_num, int try)
+static void send_IPI_mask(const struct cpumask *cpumask, int ipi_num, int try)
 {
 	cpumask_t physid_mask, tmp;
 	int cpu_id, phys_id;
@@ -761,11 +761,11 @@ static void send_IPI_mask(cpumask_t cpumask, int ipi_num, int try)
 	if (num_cpus <= 1)	/* NO MP */
 		return;
 
-	cpus_and(tmp, cpumask, cpu_online_map);
-	BUG_ON(!cpus_equal(cpumask, tmp));
+	cpumask_and(&tmp, cpumask, cpu_online_mask);
+	BUG_ON(!cpumask_equal(cpumask, &tmp));
 
 	physid_mask = CPU_MASK_NONE;
-	for_each_cpu_mask(cpu_id, cpumask){
+	for_each_cpu(cpu_id, cpumask) {
 		if ((phys_id = cpu_to_physid(cpu_id)) != -1)
 			cpu_set(phys_id, physid_mask);
 	}
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index b96a6d2..c2be49d 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -88,7 +88,8 @@ extern void smp_send_timer(void);
 extern unsigned long send_IPI_mask_phys(cpumask_t, int, int);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif	/* not __ASSEMBLY__ */
 

