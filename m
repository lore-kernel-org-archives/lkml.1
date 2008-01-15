Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYAOVK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYAOVK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYAOVKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:10:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:25286 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYAOVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:10:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Lx0IIixtMKT4oZbnMH+v35f0ZKPJMveTg7YzJZ1MIISYzFxRzTrznVXgsx441l3WwKX77E/uYoJp05QK+3P7sXi9+s1XuG5UpWj22Q81zWU/z2VhIplPQN7/vPm2XCSmqJx/S76FSPQZ7gMaD1vDFsbq/uu2L6CkvjuAz1zZ7qA=
Subject: [PATCH] x86: Add dump_pagetable helper to X86_32
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 13:10:53 -0800
Message-Id: <1200431453.16794.46.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to X86_64.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, pulled this out of some unification work, Andi Kleen
sent a pretty much identical patch in his CPA queue (7/31), this
is against current x86.git

 arch/x86/mm/fault_32.c |   72 ++++++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 46ec16c..977904c 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -173,6 +173,44 @@ static void force_sig_info_fault(int si_signo, int si_code,
 	force_sig_info(si_signo, &info, tsk);
 }
 
+void dump_pagetable(unsigned long address)
+{
+	__typeof__(pte_val(__pte(0))) page;
+
+	page = read_cr3();
+	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+	printk("*pdpt = %016Lx ", page);
+	if ((page >> PAGE_SHIFT) < max_low_pfn
+	    && page & _PAGE_PRESENT) {
+		page &= PAGE_MASK;
+		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
+		                                         & (PTRS_PER_PMD - 1)];
+		printk(KERN_CONT "*pde = %016Lx ", page);
+		page &= ~_PAGE_NX;
+	}
+#else
+	printk("*pde = %08lx ", page);
+#endif
+
+	/*
+	 * We must not directly access the pte in the highpte
+	 * case if the page table is located in highmem.
+	 * And let's rather not kmap-atomic the pte, just in case
+	 * it's allocated already.
+	 */
+	if ((page >> PAGE_SHIFT) < max_low_pfn
+	    && (page & _PAGE_PRESENT)
+	    && !(page & _PAGE_PSE)) {
+		page &= PAGE_MASK;
+		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
+		                                         & (PTRS_PER_PTE - 1)];
+		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
+	}
+
+	printk("\n");
+}
+
 void do_invalid_op(struct pt_regs *, unsigned long);
 
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
@@ -572,7 +610,6 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-		__typeof__(pte_val(__pte(0))) page;
 
 #ifdef CONFIG_X86_PAE
 		if (error_code & PF_INSTR) {
@@ -593,38 +630,7 @@ no_context:
 		printk(" at virtual address %08lx\n", address);
 		printk(KERN_ALERT "printing ip: %08lx ", regs->ip);
 
-		page = read_cr3();
-		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
-#ifdef CONFIG_X86_PAE
-		printk("*pdpt = %016Lx ", page);
-		if ((page >> PAGE_SHIFT) < max_low_pfn
-		    && page & _PAGE_PRESENT) {
-			page &= PAGE_MASK;
-			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
-			                                         & (PTRS_PER_PMD - 1)];
-			printk(KERN_CONT "*pde = %016Lx ", page);
-			page &= ~_PAGE_NX;
-		}
-#else
-		printk("*pde = %08lx ", page);
-#endif
-
-		/*
-		 * We must not directly access the pte in the highpte
-		 * case if the page table is located in highmem.
-		 * And let's rather not kmap-atomic the pte, just in case
-		 * it's allocated already.
-		 */
-		if ((page >> PAGE_SHIFT) < max_low_pfn
-		    && (page & _PAGE_PRESENT)
-		    && !(page & _PAGE_PSE)) {
-			page &= PAGE_MASK;
-			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
-			                                         & (PTRS_PER_PTE - 1)];
-			printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
-		}
-
-		printk("\n");
+		dump_pagetable(address);
 	}
 
 	tsk->thread.cr2 = address;
-- 
1.5.4.rc2.1164.g6451


