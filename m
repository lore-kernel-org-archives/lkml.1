Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZCPEO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZCPEO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZCPEOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:24 -0400
Received: from ozlabs.org ([203.10.76.45]:57311 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZCPEOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:23 -0400
Subject: [PULL] cpumask updates for cris
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>, dev-etrax@axis.com,
       linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
Cc: dev-etrax@axis.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:15 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.15684.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-cris.git master

Rusty Russell (3):
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: cris
      cpumask: Use accessors code.: cris
      cpumask: use mm_cpumask() wrapper: cris

 arch/cris/arch-v32/kernel/smp.c |   10 +++++-----
 arch/cris/arch-v32/mm/tlb.c     |    2 +-
 arch/cris/kernel/setup.c        |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

commit b9d65c04773850ff3a82f69d43981be650e658a1
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:11:47 2009 +1030

    cpumask: use mm_cpumask() wrapper: cris
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index b47764c..dc31b04 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -232,7 +232,7 @@ void flush_tlb_common(struct mm_struct* mm, struct vm_area_struct* vma, unsigned
 	cpumask_t cpu_mask;
 
 	spin_lock_irqsave(&tlbstate_lock, flags);
-	cpu_mask = (mm == FLUSH_ALL ? CPU_MASK_ALL : mm->cpu_vm_mask);
+	cpu_mask = (mm == FLUSH_ALL ? cpu_all_mask : *mm_cpumask(mm));
 	cpu_clear(smp_processor_id(), cpu_mask);
 	flush_mm = mm;
 	flush_vma = vma;
@@ -252,8 +252,8 @@ void flush_tlb_mm(struct mm_struct *mm)
 	__flush_tlb_mm(mm);
 	flush_tlb_common(mm, FLUSH_ALL, 0);
 	/* No more mappings in other CPUs */
-	cpus_clear(mm->cpu_vm_mask);
-	cpu_set(smp_processor_id(), mm->cpu_vm_mask);
+	cpumask_clear(mm_cpumask(mm));
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(mm));
 }
 
 void flush_tlb_page(struct vm_area_struct *vma,
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index 55ade36..6779bcb 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -185,7 +185,7 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		/* Make sure there is a MMU context. */
 		spin_lock(&mmu_context_lock);
 		get_mmu_context(next);
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 		spin_unlock(&mmu_context_lock);
 
 		/*

commit afc6ca01f6da831ff09f4dabdef3b50f114e9e1e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:11:47 2009 +1030

    cpumask: Use accessors code.: cris
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 9dac173..b47764c 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -98,9 +98,9 @@ void __devinit smp_prepare_boot_cpu(void)
 	SUPP_BANK_SEL(2);
 	SUPP_REG_WR(RW_MM_TLB_PGD, pgd);
 
-	cpu_set(0, cpu_online_map);
+	set_cpu_online(0, true);
 	cpu_set(0, phys_cpu_present_map);
-	cpu_set(0, cpu_possible_map);
+	set_cpu_possible(0, true);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)

commit 3e7be3fb40296aab48a91ec599f22d2c5e8a4351
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:11:46 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: cris
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
index 04d48dd..b712f49 100644
--- a/arch/cris/kernel/setup.c
+++ b/arch/cris/kernel/setup.c
@@ -166,7 +166,7 @@ void __init setup_arch(char **cmdline_p)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos < NR_CPUS ? (void *)(int)(*pos + 1): NULL;
+	return *pos < nr_cpu_ids ? (void *)(int)(*pos + 1) : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)

