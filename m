Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYACPZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYACPZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYACPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:43015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbYACPYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:22 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [7/28] Extract page table dumping code from i386 fault handler into dump_pagetable()
Message-Id: <20080103152421.695B314E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Similar to x86-64. This is useful in other situations where we want
the page table dumped too.

Besides anything that makes i386 do_page_fault shorter is good.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/fault_32.c |   72 ++++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

Index: linux/arch/x86/mm/fault_32.c
===================================================================
--- linux.orig/arch/x86/mm/fault_32.c
+++ linux/arch/x86/mm/fault_32.c
@@ -28,6 +28,44 @@
 #include <asm/desc.h>
 #include <asm/segment.h>
 
+void dump_pagetable(unsigned long address)
+{
+	typeof(pte_val(__pte(0))) page;
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
 /*
  * Page fault error code bits
  *	bit 0 == 0 means no page found, 1 means protection fault
@@ -602,7 +640,6 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-		__typeof__(pte_val(__pte(0))) page;
 
 #ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
@@ -623,38 +660,7 @@ no_context:
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
