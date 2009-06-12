Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbZFLNkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbZFLNkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbZFLNbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:10 -0400
Received: from ozlabs.org ([203.10.76.45]:55292 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760133AbZFLNbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:05 -0400
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 10/13] cpumask: use mm_cpumask() wrapper: mips
Message-Id: <20090612133106.A6F1FDDDB6@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Makes code futureproof against the impending change to mm->cpu_vm_mask.

It's also a chance to use the new cpumask_ ops which take a pointer
(the older ones are deprecated, but there's no hurry for arch code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/mips/include/asm/mmu_context.h |   10 +++++-----
 arch/mips/mm/c-octeon.c             |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -177,8 +177,8 @@ static inline void switch_mm(struct mm_s
 	 * Mark current->active_mm as not "active" anymore.
 	 * We don't want to mislead possible IPI tlb flush routines.
 	 */
-	cpu_clear(cpu, prev->cpu_vm_mask);
-	cpu_set(cpu, next->cpu_vm_mask);
+	cpumask_clear_cpu(cpu, mm_cpumask(prev));
+	cpumask_set_cpu(cpu, mm_cpumask(next));
 
 	local_irq_restore(flags);
 }
@@ -234,8 +234,8 @@ activate_mm(struct mm_struct *prev, stru
 	TLBMISS_HANDLER_SETUP_PGD(next->pgd);
 
 	/* mark mmu ownership change */
-	cpu_clear(cpu, prev->cpu_vm_mask);
-	cpu_set(cpu, next->cpu_vm_mask);
+	cpumask_clear_cpu(cpu, mm_cpumask(prev));
+	cpumask_set_cpu(cpu, mm_cpumask(next));
 
 	local_irq_restore(flags);
 }
@@ -257,7 +257,7 @@ drop_mmu_context(struct mm_struct *mm, u
 
 	local_irq_save(flags);
 
-	if (cpu_isset(cpu, mm->cpu_vm_mask))  {
+	if (cpumask_test_cpu(cpu, mm_cpumask(mm)))  {
 		get_new_mmu_context(mm, cpu);
 #ifdef CONFIG_MIPS_MT_SMTC
 		/* See comments for similar code above */
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -78,7 +78,7 @@ static void octeon_flush_icache_all_core
 	 * cores it has been used on
 	 */
 	if (vma)
-		mask = vma->vm_mm->cpu_vm_mask;
+		mask = *mm_cpumask(vma->vm_mm);
 	else
 		mask = cpu_online_map;
 	cpu_clear(cpu, mask);

