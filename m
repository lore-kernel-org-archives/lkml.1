Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbZCPERc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbZCPERc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZCPEOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:14:53 -0400
Received: from ozlabs.org ([203.10.76.45]:57346 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbZCPEOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:14:51 -0400
Subject: [PULL] cpumask updates for um
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       mingo@redhat.com, travis@sgi.com
CC: linux-kernel@vger.kernel.org
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Mon, 16 Mar 2009 14:44:44 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161444.44432.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5bee17f18b595937e6beafeee5197868a3f74a06:
  Kyle McMartin (1):
        parisc: sba_iommu: fix build bug when CONFIG_PARISC_AGP=y

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-um.git master

Rusty Russell (3):
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: um
      cpumask: Use accessors code.: um
      cpumask: use mm_cpumask() wrapper: um

 arch/um/include/asm/mmu_context.h |    4 ++--
 arch/um/kernel/smp.c              |    2 +-
 arch/um/kernel/um_arch.c          |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

commit 9ca79a68564459385c0a8db903ec6ffe6b00c50c
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:27:41 2009 +1030

    cpumask: use mm_cpumask() wrapper: um
    
    Makes code futureproof against the impending change to mm->cpu_vm_mask.
    
    It's also a chance to use the new cpumask_ ops which take a pointer
    (the older ones are deprecated, but there's no hurry for arch code).
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index 54f42e8..edd719e 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -35,8 +35,8 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	unsigned cpu = smp_processor_id();
 
 	if(prev != next){
-		cpu_clear(cpu, prev->cpu_vm_mask);
-		cpu_set(cpu, next->cpu_vm_mask);
+		cpumask_clear(cpu, mm_cpumask(prev));
+		cpumask_set_cpu(cpu, mm_cpumask(next));
 		if(next != &init_mm)
 			__switch_mm(&next->context.id);
 	}

commit 577e3b46d67a0dc236a9eb89c06861a8b4580a02
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:27:41 2009 +1030

    cpumask: Use accessors code.: um
    
    Impact: use new API
    
    Use the accessors rather than frobbing bits directly.  Most of this is
    in arch code I haven't even compiled, but is straightforward.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 98351c7..106bf27 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -111,7 +111,7 @@ void smp_prepare_cpus(unsigned int maxcpus)
 	int i;
 
 	for (i = 0; i < ncpus; ++i)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 
 	cpu_clear(me, cpu_online_map);
 	cpu_set(me, cpu_online_map);

commit 816a1c29fc3d9bb95dde5806c29629d16947bfe7
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Mon Mar 16 14:27:40 2009 +1030

    cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: um
    
    Impact: cleanup, futureproof
    
    In fact, all cpumask ops will only be valid (in general) for bit
    numbers < nr_cpu_ids.  So use that instead of NR_CPUS in various
    places.
    
    This is always safe: no cpu number can be >= nr_cpu_ids, and
    nr_cpu_ids is initialized to NR_CPUS at boot.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 8d84250..bbf96ab 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -80,7 +80,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
-	return *pos < NR_CPUS ? cpu_data + *pos : NULL;
+	return *pos < nr_cpu_ids ? cpu_data + *pos : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)

