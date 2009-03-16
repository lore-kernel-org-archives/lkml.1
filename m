Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbZCPEQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbZCPEQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZCPEOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:45 -0400
Received: from ozlabs.org ([203.10.76.45]:57329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZCPEOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:42 -0400
Subject: [PULL] cpumask updates for mips
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:32 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.33255.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-mips.git master

Rusty Russell (6):
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): mips
      cpumask: arch_send_call_function_ipi_mask: mips
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: mips
      cpumask: Use accessors code.: mips
      cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: mips
      cpumask: use mm_cpumask() wrapper: mips

 arch/mips/alchemy/common/time.c            |    2 +-
 arch/mips/include/asm/mach-ip27/topology.h |    1 -
 arch/mips/include/asm/mmu_context.h        |   10 +++++-----
 arch/mips/include/asm/smp-ops.h            |    2 +-
 arch/mips/include/asm/smp.h                |    3 ++-
 arch/mips/kernel/irq-gic.c                 |    2 +-
 arch/mips/kernel/proc.c                    |    2 +-
 arch/mips/kernel/smp-cmp.c                 |   11 +++++++----
 arch/mips/kernel/smp-mt.c                  |    4 ++--
 arch/mips/kernel/smp-up.c                  |    3 ++-
 arch/mips/kernel/smp.c                     |    4 ++--
 arch/mips/kernel/smtc.c                    |    6 +++---
 arch/mips/mipssim/sim_smtc.c               |    5 +++--
 arch/mips/mm/c-octeon.c                    |    2 +-
 arch/mips/mti-malta/malta-smtc.c           |    4 ++--
 arch/mips/pmc-sierra/yosemite/smp.c        |    4 ++--
 arch/mips/sgi-ip27/ip27-smp.c              |    4 ++--
 arch/mips/sibyte/bcm1480/irq.c             |    2 +-
 arch/mips/sibyte/bcm1480/smp.c             |    7 ++++---
 arch/mips/sibyte/sb1250/smp.c              |    7 ++++---
 20 files changed, 46 insertions(+), 39 deletions(-)

commit 0656e33655680d82e06a5fb2941d5cce8b959b17
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:24 2009 +1030

    cpumask: use mm_cpumask() wrapper: mips
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
index d7f3eb0..7f8204c 100644
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -177,8 +177,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	 * Mark current->active_mm as not "active" anymore.
 	 * We don't want to mislead possible IPI tlb flush routines.
 	 */
-	cpu_clear(cpu, prev->cpu_vm_mask);
-	cpu_set(cpu, next->cpu_vm_mask);
+	cpumask_clear_cpu(cpu, mm_cpumask(prev));
+	cpumask_set_cpu(cpu, mm_cpumask(next));
 
 	local_irq_restore(flags);
 }
@@ -234,8 +234,8 @@ activate_mm(struct mm_struct *prev, struct mm_struct *next)
 	TLBMISS_HANDLER_SETUP_PGD(next->pgd);
 
 	/* mark mmu ownership change */
-	cpu_clear(cpu, prev->cpu_vm_mask);
-	cpu_set(cpu, next->cpu_vm_mask);
+	cpumask_clear_cpu(cpu, mm_cpumask(prev));
+	cpumask_set_cpu(cpu, mm_cpumask(next));
 
 	local_irq_restore(flags);
 }
@@ -257,7 +257,7 @@ drop_mmu_context(struct mm_struct *mm, unsigned cpu)
 
 	local_irq_save(flags);
 
-	if (cpu_isset(cpu, mm->cpu_vm_mask))  {
+	if (cpumask_test_cpu(cpu, mm_cpumask(mm)))  {
 		get_new_mmu_context(mm, cpu);
 #ifdef CONFIG_MIPS_MT_SMTC
 		/* See comments for similar code above */
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index 44d01a0..9e06a31 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -78,7 +78,7 @@ static void octeon_flush_icache_all_cores(struct vm_area_struct *vma)
 	 * cores it has been used on
 	 */
 	if (vma)
-		mask = vma->vm_mm->cpu_vm_mask;
+		mask = *mm_cpumask(vma->vm_mm);
 	else
 		mask = cpu_online_map;
 	cpu_clear(cpu, mask);

commit 3c2f65bfe709f6cc9290a181c6fd55560c2105a3
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:23 2009 +1030

    cpumask: remove dangerous CPU_MASK_ALL_PTR, &CPU_MASK_ALL.: mips
    
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
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Reported-by: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Mike Travis <travis@sgi.com>

diff --git a/arch/mips/alchemy/common/time.c b/arch/mips/alchemy/common/time.c
index f58d4ff..e653513 100644
--- a/arch/mips/alchemy/common/time.c
+++ b/arch/mips/alchemy/common/time.c
@@ -89,7 +89,7 @@ static struct clock_event_device au1x_rtcmatch2_clockdev = {
 	.irq		= AU1000_RTC_MATCH2_INT,
 	.set_next_event	= au1x_rtcmatch2_set_next_event,
 	.set_mode	= au1x_rtcmatch2_set_mode,
-	.cpumask	= CPU_MASK_ALL_PTR,
+	.cpumask	= cpu_all_mask,
 };
 
 static struct irqaction au1x_rtcmatch2_irqaction = {

commit 982de1f1ed0908953a115bb1f45abd7c10e0e218
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:23 2009 +1030

    cpumask: Use accessors code.: mips
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index 725e455..efa2016 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -53,7 +53,10 @@ static int __init allowcpus(char *str)
 	cpus_clear(cpu_allow_map);
 	if (cpulist_parse(str, &cpu_allow_map) == 0) {
 		cpu_set(0, cpu_allow_map);
-		cpus_and(cpu_possible_map, cpu_possible_map, cpu_allow_map);
+		unsigned int i;
+		for (i = 1; i < nr_cpu_ids; i++)
+			if (!cpumask_test_cpu(i, cpu_allow_map))
+				set_cpu_possible(i, false);
 		len = cpulist_scnprintf(buf, sizeof(buf)-1, &cpu_possible_map);
 		buf[len] = '\0';
 		pr_debug("Allowable CPUs: %s\n", buf);
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 664ba8c..5b97ca3 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -183,7 +183,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
-	cpu_present_map = cpu_possible_map;
+	init_cpu_present(&cpu_possible_map);
 #endif
 }
 

commit 9e1d1737d800c4d90a64804b5eb2798cbcc5e114
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:22 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: mips
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 494a49a..232f8fb 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -182,7 +182,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		_intrmap[irq].cpunum = first_cpu(tmp);
 
 		/* Update the pcpu_masks */
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = 0; i < nr_cpu_ids; i++)
 			clear_bit(irq, pcpu_masks[i].pcpu_mask);
 		set_bit(irq, pcpu_masks[first_cpu(tmp)].pcpu_mask);
 
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index 26760ca..f362c95 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -86,7 +86,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	unsigned long i = *pos;
 
-	return i < NR_CPUS ? (void *) (i + 1) : NULL;
+	return i < nr_cpu_ids ? (void *) (i + 1) : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index 44b25cf..725e455 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -224,7 +224,7 @@ void __init cmp_smp_setup(void)
 		cpu_set(0, mt_fpu_cpumask);
 #endif /* CONFIG_MIPS_MT_FPAFF */
 
-	for (i = 1; i < NR_CPUS; i++) {
+	for (i = 1; i < nr_cpu_ids; i++) {
 		if (amon_cpu_avail(i)) {
 			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i]	= ++ncpu;
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index b6cca01..047cefd 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -422,8 +422,8 @@ void smtc_prepare_cpus(int cpus)
 	if (vpelimit > 0 && nvpe > vpelimit)
 		nvpe = vpelimit;
 	ntc = ((val & MVPCONF0_PTC) >> MVPCONF0_PTC_SHIFT) + 1;
-	if (ntc > NR_CPUS)
-		ntc = NR_CPUS;
+	if (ntc > nr_cpu_ids)
+		ntc = nr_cpu_ids;
 	if (tclimit > 0 && ntc > tclimit)
 		ntc = tclimit;
 	slop = ntc % nvpe;
@@ -701,7 +701,7 @@ void smtc_forward_irq(unsigned int irq)
 	 */
 
 	/* If no one is eligible, service locally */
-	if (target >= NR_CPUS) {
+	if (target >= nr_cpu_ids) {
 		do_IRQ_no_affinity(irq);
 		return;
 	}
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 12b465d..e89ae4c 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -195,7 +195,7 @@ static void ack_bcm1480_irq(unsigned int irq)
 		if (pending) {
 #ifdef CONFIG_SMP
 			int i;
-			for (i=0; i<NR_CPUS; i++) {
+			for (i = 0; i < nr_cpu_ids; i++) {
 				/*
 				 * Clear for all CPUs so an affinity switch
 				 * doesn't find an old status
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index 48ef140..5268db7 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -151,7 +151,7 @@ static void __init bcm1480_smp_setup(void)
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
-	for (i = 1, num = 0; i < NR_CPUS; i++) {
+	for (i = 1, num = 0; i < nr_cpu_ids; i++) {
 		if (cfe_cpu_stop(i) == 0) {
 			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 7fda6d2..51686a8 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -139,7 +139,7 @@ static void __init sb1250_smp_setup(void)
 	__cpu_number_map[0] = 0;
 	__cpu_logical_map[0] = 0;
 
-	for (i = 1, num = 0; i < NR_CPUS; i++) {
+	for (i = 1, num = 0; i < nr_cpu_ids; i++) {
 		if (cfe_cpu_stop(i) == 0) {
 			cpu_set(i, cpu_possible_map);
 			__cpu_number_map[i] = ++num;

commit 3002c1d977215675b9211d9980914e1f1179c58a
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:21 2009 +1030

    cpumask: arch_send_call_function_ipi_mask: mips
    
    We're weaning the core code off handing cpumask's around on-stack.
    This introduces arch_send_call_function_ipi_mask(), and by defining
    it, the old arch_send_call_function_ipi is defined by the core code.
    
    We also take the chance to wean the implementations off the
    obsolescent for_each_cpu_mask(): making send_ipi_mask take the pointer
    seemed the most natural way to ensure all implementations used
    for_each_cpu.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/mips/include/asm/smp-ops.h b/arch/mips/include/asm/smp-ops.h
index 43c207e..5f28881 100644
--- a/arch/mips/include/asm/smp-ops.h
+++ b/arch/mips/include/asm/smp-ops.h
@@ -17,7 +17,7 @@
 
 struct plat_smp_ops {
 	void (*send_ipi_single)(int cpu, unsigned int action);
-	void (*send_ipi_mask)(cpumask_t mask, unsigned int action);
+	void (*send_ipi_mask)(const struct cpumask *mask, unsigned int action);
 	void (*init_secondary)(void);
 	void (*smp_finish)(void);
 	void (*cpus_done)(void);
diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
index 40e5ef1..0483444 100644
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -58,6 +58,7 @@ static inline void smp_send_reschedule(int cpu)
 extern asmlinkage void smp_call_function_interrupt(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASM_SMP_H */
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index f27beca..44b25cf 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -135,11 +135,11 @@ void cmp_send_ipi_single(int cpu, unsigned int action)
 	local_irq_restore(flags);
 }
 
-static void cmp_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void cmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		cmp_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index 6f7ee5a..9538ca4 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -141,11 +141,11 @@ static void vsmp_send_ipi_single(int cpu, unsigned int action)
 	local_irq_restore(flags);
 }
 
-static void vsmp_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void vsmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		vsmp_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/kernel/smp-up.c b/arch/mips/kernel/smp-up.c
index ead6c30..dace5d7 100644
--- a/arch/mips/kernel/smp-up.c
+++ b/arch/mips/kernel/smp-up.c
@@ -18,7 +18,8 @@ void up_send_ipi_single(int cpu, unsigned int action)
 	panic(KERN_ERR "%s called", __func__);
 }
 
-static inline void up_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void up_send_ipi_mask(const struct cpumask *mask,
+				    unsigned int action)
 {
 	panic(KERN_ERR "%s called", __func__);
 }
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 3da9470..664ba8c 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -128,7 +128,7 @@ asmlinkage __cpuinit void start_secondary(void)
 	cpu_idle();
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
 }
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
index d6e4f65..5da30b6 100644
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -43,11 +43,12 @@ static void ssmtc_send_ipi_single(int cpu, unsigned int action)
 	/* "CPU" may be TC of same VPE, VPE of same CPU, or different CPU */
 }
 
-static inline void ssmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void ssmtc_send_ipi_mask(const struct cpumask *mask,
+				       unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		ssmtc_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index aabd727..9f3ab5f 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -21,11 +21,11 @@ static void msmtc_send_ipi_single(int cpu, unsigned int action)
 	smtc_send_ipi(cpu, LINUX_SMP_IPI, action);
 }
 
-static void msmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void msmtc_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		msmtc_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index f78c29b..bb4779e 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -96,11 +96,11 @@ static void yos_send_ipi_single(int cpu, unsigned int action)
 	}
 }
 
-static void yos_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void yos_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		yos_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
index 5b47d6b..4ffb255 100644
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -165,11 +165,11 @@ static void ip27_send_ipi_single(int destid, unsigned int action)
 	REMOTE_HUB_SEND_INTR(COMPACT_TO_NASID_NODEID(cpu_to_node(destid)), irq);
 }
 
-static void ip27_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void ip27_send_ipi(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		ip27_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index dddfda8..48ef140 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -82,11 +82,12 @@ static void bcm1480_send_ipi_single(int cpu, unsigned int action)
 	__raw_writeq((((u64)action)<< 48), mailbox_0_set_regs[cpu]);
 }
 
-static void bcm1480_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void bcm1480_send_ipi_mask(const struct cpumask *mask,
+				  unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		bcm1480_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index 5950a28..7fda6d2 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -70,11 +70,12 @@ static void sb1250_send_ipi_single(int cpu, unsigned int action)
 	__raw_writeq((((u64)action) << 48), mailbox_set_regs[cpu]);
 }
 
-static inline void sb1250_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void sb1250_send_ipi_mask(const struct cpumask *mask,
+					unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		sb1250_send_ipi_single(i, action);
 }
 

commit faad087e648decd8a7e4ae7bc04cc802a0100a81
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:17:19 2009 +1030

    cpumask: remove the now-obsoleted pcibus_to_cpumask(): mips
    
    Impact: reduce stack usage for large NR_CPUS
    
    cpumask_of_pcibus() is the new version.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 55d4815..b9b933b 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -30,7 +30,6 @@ extern struct cpuinfo_ip27 sn_cpu_info[NR_CPUS];
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
 
-#define pcibus_to_cpumask(bus)	(cpu_online_map)
 #define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];

