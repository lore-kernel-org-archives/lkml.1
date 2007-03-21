Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXCUDLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXCUDLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbXCUDLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:11:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933279AbXCUDLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:11:53 -0400
Date: Wed, 21 Mar 2007 00:12:07 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, andi@redhat.com
Subject: [PATCH] Yet another function to load cr3 register
Message-ID: <20070321031207.GA9768@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There is (was) yet another function to load something into
the cr3 register. We don't need it.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="load_cr3.patch"

diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index af1ec4d..f338fc5 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -76,7 +76,7 @@ static inline void leave_mm(int cpu)
 	if (read_pda(mmu_state) == TLBSTATE_OK)
 		BUG();
 	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
-	load_cr3(swapper_pg_dir);
+	write_cr3(__pa(swapper_pg_dir));
 }
 
 /*
diff --git a/include/asm-x86_64/mmu_context.h b/include/asm-x86_64/mmu_context.h
index 09add28..7781e99 100644
--- a/include/asm-x86_64/mmu_context.h
+++ b/include/asm-x86_64/mmu_context.h
@@ -22,11 +22,6 @@ static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 #endif
 }
 
-static inline void load_cr3(pgd_t *pgd)
-{
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
-}
-
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
 			     struct task_struct *tsk)
 {
@@ -39,7 +34,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		write_pda(active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
-		load_cr3(next->pgd);
+		write_cr3(__pa(next->pgd));
 
 		if (unlikely(next->context.ldt != prev->context.ldt)) 
 			load_LDT_nolock(&next->context);
@@ -54,7 +49,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			 * tlb flush IPI delivery. We must reload CR3
 			 * to make sure to use no freed page tables.
 			 */
-			load_cr3(next->pgd);
+			write_cr3(__pa(next->pgd));
 			load_LDT_nolock(&next->context);
 		}
 	}

--nFreZHaLTZJo0R7j--
