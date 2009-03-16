Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZCPEQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZCPEQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZCPEOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:47 -0400
Received: from ozlabs.org ([203.10.76.45]:57336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZCPEOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:46 -0400
Subject: [PULL] cpumask updates for s390
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
Cc: linux390@de.ibm.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:38 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.38974.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-s390.git master

Rusty Russell (4):
      cpumask: remove cpu_coregroup_map: s390
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: s390
      cpumask: Use accessors code.: s390
      cpumask: use mm_cpumask() wrapper: s390

 arch/s390/include/asm/mmu_context.h |    2 +-
 arch/s390/include/asm/tlbflush.h    |    4 ++--
 arch/s390/include/asm/topology.h    |    1 -
 arch/s390/kernel/smp.c              |   21 ++++++++++-----------
 arch/s390/kernel/topology.c         |    2 +-
 arch/s390/mm/pgtable.c              |    2 +-
 6 files changed, 15 insertions(+), 17 deletions(-)

commit a7996abc7d90ba828601f385a3a4ba9a1300c24e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:20:43 2009 +1030

    cpumask: use mm_cpumask() wrapper: s390
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 28ec870..fc7edd6 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -74,7 +74,7 @@ static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
-	cpu_set(smp_processor_id(), next->cpu_vm_mask);
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next));
 	update_mm(next, tsk);
 }
 
diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index d60394b..1b14afe 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -51,7 +51,7 @@ static inline void __tlb_flush_full(struct mm_struct *mm)
 	 * If the process only ran on the local cpu, do a local flush.
 	 */
 	local_cpumask = cpumask_of_cpu(smp_processor_id());
-	if (cpus_equal(mm->cpu_vm_mask, local_cpumask))
+	if (cpumask_equal(mm_cpumask(mm), local_cpumask))
 		__tlb_flush_local();
 	else
 		__tlb_flush_global();
@@ -73,7 +73,7 @@ static inline void __tlb_flush_idte(unsigned long asce)
 
 static inline void __tlb_flush_mm(struct mm_struct * mm)
 {
-	if (unlikely(cpus_empty(mm->cpu_vm_mask)))
+	if (unlikely(cpumask_empty(mm_cpumask(mm))))
 		return;
 	/*
 	 * If the machine has IDTE we prefer to do a per mm flush
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 0767827..4b48ffb 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -290,7 +290,7 @@ int s390_enable_sie(void)
 	tsk->mm = tsk->active_mm = mm;
 	preempt_disable();
 	update_mm(mm, tsk);
-	cpu_set(smp_processor_id(), mm->cpu_vm_mask);
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
 	preempt_enable();
 	task_unlock(tsk);
 	mmput(old_mm);

commit 493317ecbfbe24d1b2a9d5073b3b810316f1628b
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:20:43 2009 +1030

    cpumask: Use accessors code.: s390
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index a46752b..6c7ed44 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -589,9 +589,8 @@ static int __init setup_possible_cpus(char *s)
 	int pcpus, cpu;
 
 	pcpus = simple_strtoul(s, NULL, 0);
-	cpu_possible_map = cpumask_of_cpu(0);
-	for (cpu = 1; cpu < pcpus && cpu < nr_cpu_ids; cpu++)
-		cpu_set(cpu, cpu_possible_map);
+	for (cpu = 0; cpu < pcpus && cpu < nr_cpu_ids; cpu++)
+		set_cpu_possible(cpu, true);
 	return 0;
 }
 early_param("possible_cpus", setup_possible_cpus);

commit 74b5d3675e733bb1bd405f66e1caaf319362872f
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:20:42 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: s390
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places (I also updated the immediate sites to use the new cpumask_
    operators).
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 2d337cb..a46752b 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -304,8 +304,8 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
 {
 	int cpu_id, logical_cpu;
 
-	logical_cpu = first_cpu(avail);
-	if (logical_cpu == NR_CPUS)
+	logical_cpu = cpumask_first(&avail);
+	if (logical_cpu >= nr_cpu_ids)
 		return 0;
 	for (cpu_id = 0; cpu_id <= 65535; cpu_id++) {
 		if (cpu_known(cpu_id))
@@ -316,8 +316,8 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
 			continue;
 		cpu_set(logical_cpu, cpu_present_map);
 		smp_cpu_state[logical_cpu] = CPU_STATE_CONFIGURED;
-		logical_cpu = next_cpu(logical_cpu, avail);
-		if (logical_cpu == NR_CPUS)
+		logical_cpu = cpumask_next(logical_cpu, &avail);
+		if (logical_cpu >= nr_cpu_ids)
 			break;
 	}
 	return 0;
@@ -329,8 +329,8 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
 	int cpu_id, logical_cpu, cpu;
 	int rc;
 
-	logical_cpu = first_cpu(avail);
-	if (logical_cpu == NR_CPUS)
+	logical_cpu = cpumask_first(&avail);
+	if (logical_cpu >= nr_cpu_ids)
 		return 0;
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -351,8 +351,8 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
 			smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
 		else
 			smp_cpu_state[logical_cpu] = CPU_STATE_CONFIGURED;
-		logical_cpu = next_cpu(logical_cpu, avail);
-		if (logical_cpu == NR_CPUS)
+		logical_cpu = cpumask_next(logical_cpu, &avail);
+		if (logical_cpu >= nr_cpu_ids)
 			break;
 	}
 out:
@@ -590,7 +590,7 @@ static int __init setup_possible_cpus(char *s)
 
 	pcpus = simple_strtoul(s, NULL, 0);
 	cpu_possible_map = cpumask_of_cpu(0);
-	for (cpu = 1; cpu < pcpus && cpu < NR_CPUS; cpu++)
+	for (cpu = 1; cpu < pcpus && cpu < nr_cpu_ids; cpu++)
 		cpu_set(cpu, cpu_possible_map);
 	return 0;
 }

commit bb837fbf10976c8d1cc0ec2d07ae4abd31705c44
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:20:42 2009 +1030

    cpumask: remove cpu_coregroup_map: s390
    
    Impact: cleanup
    
    cpu_coregroup_mask is the New Hotness.
    
    As S/390 uses theirs internally, so we just make it static.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index c93eb50..97c376e 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -5,7 +5,6 @@
 
 #define mc_capable()	(1)
 
-cpumask_t cpu_coregroup_map(unsigned int cpu);
 const struct cpumask *cpu_coregroup_mask(unsigned int cpu);
 
 extern cpumask_t cpu_core_map[NR_CPUS];
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index cc362c9..3c72c9c 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -74,7 +74,7 @@ static DEFINE_SPINLOCK(topology_lock);
 
 cpumask_t cpu_core_map[NR_CPUS];
 
-cpumask_t cpu_coregroup_map(unsigned int cpu)
+static cpumask_t cpu_coregroup_map(unsigned int cpu)
 {
 	struct core_info *core = &core_info;
 	unsigned long flags;

