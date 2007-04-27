Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXD0OMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXD0OMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXD0OGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:54 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:14919 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbXD0OE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:58 -0400
Message-Id: <20070427140516.754337135@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 21/38] No execute support cleanup.
Content-Disposition: inline; filename=124-nx-cleanup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Simplify the signal_return function that checks for the two special
system calls sigreturn and rt_sigreturn. No need to do a page table
walk, a call to copy_from_user while disabled page faults will work
as well.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/mm/fault.c |   72 ++++++++++++++-------------------------------------
 1 files changed, 21 insertions(+), 51 deletions(-)

Index: quilt-2.6/arch/s390/mm/fault.c
===================================================================
--- quilt-2.6.orig/arch/s390/mm/fault.c	2007-04-27 16:04:57.000000000 +0200
+++ quilt-2.6/arch/s390/mm/fault.c	2007-04-27 16:04:57.000000000 +0200
@@ -26,9 +26,9 @@
 #include <linux/module.h>
 #include <linux/hardirq.h>
 #include <linux/kprobes.h>
+#include <linux/uaccess.h>
 
 #include <asm/system.h>
-#include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/kdebug.h>
 #include <asm/s390_ext.h>
@@ -263,68 +263,38 @@
 extern long sys32_sigreturn(struct pt_regs *regs);
 extern long sys32_rt_sigreturn(struct pt_regs *regs);
 
-static inline void do_sigreturn(struct mm_struct *mm, struct pt_regs *regs,
-				int rt)
+static int signal_return(struct mm_struct *mm, struct pt_regs *regs,
+			 unsigned long address, unsigned long error_code)
 {
+	u16 instruction;
+	int rc, compat;
+
+	pagefault_disable();
+	rc = __get_user(instruction, (u16 __user *) regs->psw.addr);
+	pagefault_enable();
+	if (rc)
+		return -EFAULT;
+
 	up_read(&mm->mmap_sem);
 	clear_tsk_thread_flag(current, TIF_SINGLE_STEP);
 #ifdef CONFIG_COMPAT
-	if (test_tsk_thread_flag(current, TIF_31BIT)) {
-		if (rt)
-			sys32_rt_sigreturn(regs);
-		else
-			sys32_sigreturn(regs);
-		return;
-	}
-#endif /* CONFIG_COMPAT */
-	if (rt)
-		sys_rt_sigreturn(regs);
+	compat = test_tsk_thread_flag(current, TIF_31BIT);
+	if (compat && instruction == 0x0a77)
+		sys32_sigreturn(regs);
+	else if (compat && instruction == 0x0aad)
+		sys32_rt_sigreturn(regs);
 	else
+#endif
+	if (instruction == 0x0a77)
 		sys_sigreturn(regs);
-	return;
-}
-
-static int signal_return(struct mm_struct *mm, struct pt_regs *regs,
-			 unsigned long address, unsigned long error_code)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
-	u16 *instruction;
-	unsigned long pfn, uaddr = regs->psw.addr;
-
-	spin_lock(&mm->page_table_lock);
-	pgd = pgd_offset(mm, uaddr);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto out_fault;
-	pmd = pmd_offset(pgd, uaddr);
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto out_fault;
-	pte = pte_offset_map(pmd_offset(pgd_offset(mm, uaddr), uaddr), uaddr);
-	if (!pte || !pte_present(*pte))
-		goto out_fault;
-	pfn = pte_pfn(*pte);
-	if (!pfn_valid(pfn))
-		goto out_fault;
-	spin_unlock(&mm->page_table_lock);
-
-	instruction = (u16 *) ((pfn << PAGE_SHIFT) + (uaddr & (PAGE_SIZE-1)));
-	if (*instruction == 0x0a77)
-		do_sigreturn(mm, regs, 0);
-	else if (*instruction == 0x0aad)
-		do_sigreturn(mm, regs, 1);
+	else if (instruction == 0x0aad)
+		sys_rt_sigreturn(regs);
 	else {
-		printk("- XXX - do_exception: task = %s, primary, NO EXEC "
-		       "-> SIGSEGV\n", current->comm);
-		up_read(&mm->mmap_sem);
 		current->thread.prot_addr = address;
 		current->thread.trap_no = error_code;
 		do_sigsegv(regs, error_code, SEGV_MAPERR, address);
 	}
 	return 0;
-out_fault:
-	spin_unlock(&mm->page_table_lock);
-	return -EFAULT;
 }
 #endif /* CONFIG_S390_EXEC_PROTECT */
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

