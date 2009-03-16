Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZCPERJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZCPERJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZCPEOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:52 -0400
Received: from ozlabs.org ([203.10.76.45]:57340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234AbZCPEOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:50 -0400
Subject: [PULL] cpumask updates for sparc
From: Rusty Russell <rusty@rustcorp.com.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:41 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.41621.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-sparc.git master

Rusty Russell (10):
      cpumask: Use smp_call_function_many(): sparc64
      cpumask: arch_send_call_function_ipi_mask: sparc
      cpumask: Use accessors code: sparc
      cpumask: Use accessors code.: sparc64
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc64
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc
      cpumask: remove cpu_coregroup_map: sparc
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): sparc
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: sparc
      cpumask: use mm_cpumask() wrapper: sparc

 arch/sparc/include/asm/mmu_context_64.h |    8 +++---
 arch/sparc/include/asm/smp_64.h         |    3 +-
 arch/sparc/include/asm/system_32.h      |    2 +-
 arch/sparc/include/asm/topology_64.h    |    7 +-----
 arch/sparc/kernel/ds.c                  |    2 +-
 arch/sparc/kernel/irq_64.c              |    4 +-
 arch/sparc/kernel/mdesc.c               |    2 +-
 arch/sparc/kernel/prom_64.c             |    4 +-
 arch/sparc/kernel/smp_32.c              |   36 +++++++++++++++---------------
 arch/sparc/kernel/smp_64.c              |   14 ++++++------
 arch/sparc/kernel/sun4d_smp.c           |   11 ++++-----
 arch/sparc/kernel/sun4m_smp.c           |   10 +++-----
 arch/sparc/mm/init_64.c                 |    2 +-
 arch/sparc/mm/srmmu.c                   |    2 +-
 14 files changed, 50 insertions(+), 57 deletions(-)

commit 81f1adf01224f5c0be5f90f43664f799c1f7bb2d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:39 2009 +1030

    cpumask: use mm_cpumask() wrapper: sparc
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 5693ab4..666a73f 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -121,8 +121,8 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 	 * local TLB.
 	 */
 	cpu = smp_processor_id();
-	if (!ctx_valid || !cpu_isset(cpu, mm->cpu_vm_mask)) {
-		cpu_set(cpu, mm->cpu_vm_mask);
+	if (!ctx_valid || !cpumask_test_cpu(cpu, mm_cpumask(mm))) {
+		cpumask_set_cpu(cpu, mm_cpumask(mm));
 		__flush_tlb_mm(CTX_HWBITS(mm->context),
 			       SECONDARY_CONTEXT);
 	}
@@ -141,8 +141,8 @@ static inline void activate_mm(struct mm_struct *active_mm, struct mm_struct *mm
 	if (!CTX_VALID(mm->context))
 		get_new_mmu_context(mm);
 	cpu = smp_processor_id();
-	if (!cpu_isset(cpu, mm->cpu_vm_mask))
-		cpu_set(cpu, mm->cpu_vm_mask);
+	if (!cpumask_test_cpu(cpu, mm_cpumask(mm)))
+		cpumask_set_cpu(cpu, mm_cpumask(mm));
 
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context), SECONDARY_CONTEXT);
diff --git a/arch/sparc/include/asm/system_32.h b/arch/sparc/include/asm/system_32.h
index 79c1ae2..751c8c1 100644
--- a/arch/sparc/include/asm/system_32.h
+++ b/arch/sparc/include/asm/system_32.h
@@ -126,7 +126,7 @@ extern void flushw_all(void);
 #define switch_to(prev, next, last) do {						\
 	SWITCH_ENTER(prev);								\
 	SWITCH_DO_LAZY_FPU(next);							\
-	cpu_set(smp_processor_id(), next->active_mm->cpu_vm_mask);			\
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next->active_mm));		\
 	__asm__ __volatile__(								\
 	"sethi	%%hi(here - 0x8), %%o7\n\t"						\
 	"mov	%%g6, %%g3\n\t"								\
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index be1ae37..132d81f 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -143,7 +143,7 @@ void smp_flush_tlb_all(void)
 void smp_flush_cache_mm(struct mm_struct *mm)
 {
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask))
 			xc1((smpfunc_t) BTFIXUP_CALL(local_flush_cache_mm), (unsigned long) mm);
@@ -154,12 +154,13 @@ void smp_flush_cache_mm(struct mm_struct *mm)
 void smp_flush_tlb_mm(struct mm_struct *mm)
 {
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask)) {
 			xc1((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_mm), (unsigned long) mm);
 			if(atomic_read(&mm->mm_users) == 1 && current->active_mm == mm)
-				mm->cpu_vm_mask = cpumask_of_cpu(smp_processor_id());
+				cpumask_copy(mm_cpumask(mm),
+					     cpumask_of(smp_processor_id()));
 		}
 		local_flush_tlb_mm(mm);
 	}
@@ -171,7 +172,7 @@ void smp_flush_cache_range(struct vm_area_struct *vma, unsigned long start,
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask))
 			xc3((smpfunc_t) BTFIXUP_CALL(local_flush_cache_range), (unsigned long) vma, start, end);
@@ -185,7 +186,7 @@ void smp_flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask))
 			xc3((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_range), (unsigned long) vma, start, end);
@@ -198,7 +199,7 @@ void smp_flush_cache_page(struct vm_area_struct *vma, unsigned long page)
 	struct mm_struct *mm = vma->vm_mm;
 
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask))
 			xc2((smpfunc_t) BTFIXUP_CALL(local_flush_cache_page), (unsigned long) vma, page);
@@ -211,7 +212,7 @@ void smp_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 	struct mm_struct *mm = vma->vm_mm;
 
 	if(mm->context != NO_CONTEXT) {
-		cpumask_t cpu_mask = mm->cpu_vm_mask;
+		cpumask_t cpu_mask = *mm_cpumask(mm);
 		cpu_clear(smp_processor_id(), cpu_mask);
 		if (!cpus_empty(cpu_mask))
 			xc2((smpfunc_t) BTFIXUP_CALL(local_flush_tlb_page), (unsigned long) vma, page);
@@ -240,7 +241,7 @@ void smp_flush_page_to_ram(unsigned long page)
 
 void smp_flush_sig_insns(struct mm_struct *mm, unsigned long insn_addr)
 {
-	cpumask_t cpu_mask = mm->cpu_vm_mask;
+	cpumask_t cpu_mask = *mm_cpumask(mm);
 	cpu_clear(smp_processor_id(), cpu_mask);
 	if (!cpus_empty(cpu_mask))
 		xc2((smpfunc_t) BTFIXUP_CALL(local_flush_sig_insns), (unsigned long) mm, insn_addr);
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 4e17eec..2de937c 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -850,7 +850,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	smp_call_function_many(&mm->cpu_vm_mask, tsb_sync, mm, 1);
+	smp_call_function_many(mm_cpumask(mm), tsb_sync, mm, 1);
 }
 
 extern unsigned long xcall_flush_tlb_mm;
@@ -1055,13 +1055,13 @@ void smp_flush_tlb_mm(struct mm_struct *mm)
 	int cpu = get_cpu();
 
 	if (atomic_read(&mm->mm_users) == 1) {
-		mm->cpu_vm_mask = cpumask_of_cpu(cpu);
+		cpumask_copy(mm_cpumask(mm), cpumask_of(cpu));
 		goto local_flush_and_out;
 	}
 
 	smp_cross_call_masked(&xcall_flush_tlb_mm,
 			      ctx, 0, 0,
-			      &mm->cpu_vm_mask);
+			      mm_cpumask(mm));
 
 local_flush_and_out:
 	__flush_tlb_mm(ctx, SECONDARY_CONTEXT);
@@ -1075,11 +1075,11 @@ void smp_flush_tlb_pending(struct mm_struct *mm, unsigned long nr, unsigned long
 	int cpu = get_cpu();
 
 	if (mm == current->active_mm && atomic_read(&mm->mm_users) == 1)
-		mm->cpu_vm_mask = cpumask_of_cpu(cpu);
+		cpumask_copy(mm_cpumask(mm), cpumask_of(cpu));
 	else
 		smp_cross_call_masked(&xcall_flush_tlb_pending,
 				      ctx, nr, (unsigned long) vaddrs,
-				      &mm->cpu_vm_mask);
+				      mm_cpumask(mm));
 
 	__flush_tlb_pending(ctx, nr, vaddrs);
 

commit e9b375120b593d3081c2f63e8ccf350cccc8fd68
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:38 2009 +1030

    cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: sparc
    
    Impact: cleanup
    
    (Thanks to Al Viro for reminding me of this, via Ingo)
    
    CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:
    
    	#define CPU_MASK_ALL (cpumask_t) { { ... } }
    
    Taking the address of such a temporary is questionable at best,
    unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
    CPU_MASK_ALL_PTR:
    
    	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)
    
    Which formalizes this practice.  One day gcc could bite us over this
    usage (though we seem to have gotten away with it so far).
    
    So replace everywhere which used &CPU_MASK_ALL or CPU_MASK_ALL_PTR
    with the modern "cpu_all_mask" (a real struct cpumask *), and remove
    CPU_MASK_ALL_PTR altogether.
    
    Also remove the confusing and deprecated large-NR_CPUS-only
    "cpu_mask_all".
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Reported-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Mike Travis <travis@sgi.com>

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index a5ba4ad..39624ab 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -45,7 +45,7 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 
 #define cpumask_of_pcibus(bus)	\
 	(pcibus_to_node(bus) == -1 ? \
-	 CPU_MASK_ALL_PTR : \
+	 cpu_all_mask : \
 	 cpumask_of_node(pcibus_to_node(bus)))
 
 #define SD_NODE_INIT (struct sched_domain) {		\

commit cc301d261f5d49cbff66b2f459f58f2652899cdb
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:28 2009 +1030

    cpumask: remove the now-obsoleted pcibus_to_cpumask(): sparc
    
    Impact: reduce stack usage for large NR_CPUS
    
    cpumask_of_pcibus() is the new version.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 430ce39..a5ba4ad 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -43,10 +43,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 }
 #endif
 
-#define pcibus_to_cpumask(bus)	\
-	(pcibus_to_node(bus) == -1 ? \
-	 CPU_MASK_ALL : \
-	 node_to_cpumask(pcibus_to_node(bus)))
 #define cpumask_of_pcibus(bus)	\
 	(pcibus_to_node(bus) == -1 ? \
 	 CPU_MASK_ALL_PTR : \

commit 7b45101d09ab13eafc0c3a5232e1606654d122ea
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:25 2009 +1030

    cpumask: remove cpu_coregroup_map: sparc
    
    Impact: cleanup
    
    cpu_coregroup_mask is the New Hotness.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 5bc0b8f..430ce39 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -89,7 +89,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
-#define cpu_coregroup_map(cpu)			(cpu_core_map[cpu])
 #define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */

commit ec7c14bde80a11e325f26b339b8570a929e87223
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:24 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 88f43c5..be1ae37 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -70,13 +70,12 @@ void __init smp_cpus_done(unsigned int max_cpus)
 	extern void smp4m_smp_done(void);
 	extern void smp4d_smp_done(void);
 	unsigned long bogosum = 0;
-	int cpu, num;
+	int cpu, num = 0;
 
-	for (cpu = 0, num = 0; cpu < NR_CPUS; cpu++)
-		if (cpu_online(cpu)) {
-			num++;
-			bogosum += cpu_data(cpu).udelay_val;
-		}
+	for_each_online_cpu(cpu) {
+		num++;
+		bogosum += cpu_data(cpu).udelay_val;
+	}
 
 	printk("Total of %d processors activated (%lu.%02lu BogoMIPS).\n",
 		num, bogosum/(500000/HZ),
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index e85e6aa..54fb024 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -228,11 +228,10 @@ void __init smp4d_smp_done(void)
 	/* setup cpu list for irq rotation */
 	first = 0;
 	prev = &first;
-	for (i = 0; i < NR_CPUS; i++)
-		if (cpu_online(i)) {
-			*prev = i;
-			prev = &cpu_data(i).next;
-		}
+	for_each_online_cpu(i) {
+		*prev = i;
+		prev = &cpu_data(i).next;
+	}
 	*prev = first;
 	local_flush_cache_all();
 
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 2a8f4fc..960b113 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -186,11 +186,9 @@ void __init smp4m_smp_done(void)
 	/* setup cpu list for irq rotation */
 	first = 0;
 	prev = &first;
-	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_online(i)) {
-			*prev = i;
-			prev = &cpu_data(i).next;
-		}
+	for_each_online_cpu(i) {
+		*prev = i;
+		prev = &cpu_data(i).next;
 	}
 	*prev = first;
 	local_flush_cache_all();
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index fe7ed08..06c9a7d 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1425,7 +1425,7 @@ static void __init init_vac_layout(void)
 				min_line_size = vac_line_size;
 			//FIXME: cpus not contiguous!!
 			cpu++;
-			if (cpu >= NR_CPUS || !cpu_online(cpu))
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 				break;
 #else
 			break;

commit e305cb8f09b6e51940f78516f962ea819bc30ccd
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:23 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc64
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/sparc/kernel/ds.c b/arch/sparc/kernel/ds.c
index 57c3984..90350f8 100644
--- a/arch/sparc/kernel/ds.c
+++ b/arch/sparc/kernel/ds.c
@@ -653,7 +653,7 @@ static void __cpuinit dr_cpu_data(struct ds_info *dp,
 		if (cpu_list[i] == CPU_SENTINEL)
 			continue;
 
-		if (cpu_list[i] < NR_CPUS)
+		if (cpu_list[i] < nr_cpu_ids)
 			cpu_set(cpu_list[i], mask);
 	}
 
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 1c378d8..640631b 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -265,12 +265,12 @@ static int irq_choose_cpu(unsigned int virt_irq)
 		spin_lock_irqsave(&irq_rover_lock, flags);
 
 		while (!cpu_online(irq_rover)) {
-			if (++irq_rover >= NR_CPUS)
+			if (++irq_rover >= nr_cpu_ids)
 				irq_rover = 0;
 		}
 		cpuid = irq_rover;
 		do {
-			if (++irq_rover >= NR_CPUS)
+			if (++irq_rover >= nr_cpu_ids)
 				irq_rover = 0;
 		} while (!cpu_online(irq_rover));
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 00373ce..2c8dfeb 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1092,7 +1092,7 @@ static void __init numa_parse_mdesc_group_cpus(struct mdesc_handle *md,
 		if (strcmp(name, "cpu"))
 			continue;
 		id = mdesc_get_property(md, target, "id", NULL);
-		if (*id < NR_CPUS)
+		if (*id < nr_cpu_ids)
 			cpu_set(*id, *mask);
 	}
 }

commit 89229071c049e518668e34b234167d5ed9c94534
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:23 2009 +1030

    cpumask: Use accessors code.: sparc64
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 3f79f0c..f0e6ed2 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -567,7 +567,7 @@ static void __init report_platform_properties(void)
 			max_cpu = NR_CPUS;
 		}
 		for (i = 0; i < max_cpu; i++)
-			cpu_set(i, cpu_possible_map);
+			set_cpu_possible(i, true);
 	}
 #endif
 
diff --git a/arch/sparc/kernel/prom_64.c b/arch/sparc/kernel/prom_64.c
index edecca7..ca55c70 100644
--- a/arch/sparc/kernel/prom_64.c
+++ b/arch/sparc/kernel/prom_64.c
@@ -518,8 +518,8 @@ void __init of_fill_in_cpu_data(void)
 		}
 
 #ifdef CONFIG_SMP
-		cpu_set(cpuid, cpu_present_map);
-		cpu_set(cpuid, cpu_possible_map);
+		set_cpu_present(cpuid, true);
+		set_cpu_possible(cpuid, true);
 #endif
 	}
 

commit fe73971cdd9287eba5f834eb3794768c22718581
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:22 2009 +1030

    cpumask: Use accessors code: sparc
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but it is mostly straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 1e5ac4e..88f43c5 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -332,8 +332,8 @@ void __init smp_setup_cpu_possible_map(void)
 	instance = 0;
 	while (!cpu_find_by_instance(instance, NULL, &mid)) {
 		if (mid < NR_CPUS) {
-			cpu_set(mid, cpu_possible_map);
-			cpu_set(mid, cpu_present_map);
+			set_cpu_possible(mid, true);
+			set_cpu_present(mid, true);
 		}
 		instance++;
 	}
@@ -351,8 +351,8 @@ void __init smp_prepare_boot_cpu(void)
 		printk("boot cpu id != 0, this could work but is untested\n");
 
 	current_thread_info()->cpu = cpuid;
-	cpu_set(cpuid, cpu_online_map);
-	cpu_set(cpuid, cpu_possible_map);
+	set_cpu_online(cpuid, true);
+	set_cpu_possible(cpuid, true);
 }
 
 int __cpuinit __cpu_up(unsigned int cpu)
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 50afaed..e85e6aa 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -150,7 +150,7 @@ void __cpuinit smp4d_callin(void)
 	spin_lock_irqsave(&sun4d_imsk_lock, flags);
 	cc_set_imsk(cc_get_imsk() & ~0x4000); /* Allow PIL 14 as well */
 	spin_unlock_irqrestore(&sun4d_imsk_lock, flags);
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 
 }
 
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 8040376..2a8f4fc 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -113,7 +113,7 @@ void __cpuinit smp4m_callin(void)
 
 	local_irq_enable();
 
-	cpu_set(cpuid, cpu_online_map);
+	set_cpu_online(cpuid, true);
 }
 
 /*

commit f46df02a5799460e74bcb5a3875d4245978f3bd2
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:22 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: sparc
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask(), and by defining
    it, the old arch_send_call_function_ipi is defined by the core code.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/sparc/include/asm/smp_64.h b/arch/sparc/include/asm/smp_64.h
index 57224dd..becb6bf 100644
--- a/arch/sparc/include/asm/smp_64.h
+++ b/arch/sparc/include/asm/smp_64.h
@@ -35,7 +35,8 @@ extern cpumask_t cpu_core_map[NR_CPUS];
 extern int sparc64_multi_core;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 /*
  *	General functions that each host system must provide.
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index a4713e7..4e17eec 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -808,9 +808,9 @@ static void smp_start_sync_tick_client(int cpu)
 
 extern unsigned long xcall_call_function;
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
-	xcall_deliver((u64) &xcall_call_function, 0, 0, &mask);
+	xcall_deliver((u64) &xcall_call_function, 0, 0, mask);
 }
 
 extern unsigned long xcall_call_function_single;

commit fd8e18e9f486bcbdd8e0d817e6aa8622a5034540
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:40:22 2009 +1030

    cpumask: Use smp_call_function_many(): sparc64
    
    Impact: Use new API
    
    Change smp_call_function_mask() callers to smp_call_function_many().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 6cd1a5b..a4713e7 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -850,7 +850,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	smp_call_function_mask(mm->cpu_vm_mask, tsb_sync, mm, 1);
+	smp_call_function_many(&mm->cpu_vm_mask, tsb_sync, mm, 1);
 }
 
 extern unsigned long xcall_flush_tlb_mm;
