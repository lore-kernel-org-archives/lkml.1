Return-Path: <linux-kernel-owner+w=401wt.eu-S1163292AbXD1SRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163292AbXD1SRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXD1SQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:16:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:34414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163292AbXD1Rwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:34 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] [9/35] i386: adjustments to page table dump during oops (v4)
Message-Id: <20070428175233.6BA21151D1@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified
  from what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices
- print pte even in highpte case, as long as the pte page isn't in
  actually in high memory (which is specifically the case for all page
  tables covering kernel space)

(Changes to v3: Use sizeof()*2 rather than the suggested sizeof()*4 for
printing width, use fixed 16-nibble width for PAE, and also apply the
max_low_pfn range check to the middle level lookup on PAE.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/mm/fault.c |   55 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 20 deletions(-)

Index: linux/arch/i386/mm/fault.c
===================================================================
--- linux.orig/arch/i386/mm/fault.c
+++ linux/arch/i386/mm/fault.c
@@ -20,6 +20,7 @@
 #include <linux/tty.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/highmem.h>
+#include <linux/bootmem.h>		/* for max_low_pfn */
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -301,7 +302,6 @@ fastcall void __kprobes do_page_fault(st
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	unsigned long page;
 	int write, si_code;
 
 	/* get the address */
@@ -510,7 +510,9 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-	#ifdef CONFIG_X86_PAE
+		__typeof__(pte_val(__pte(0))) page;
+
+#ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
 			pte_t *pte = lookup_address(address);
 
@@ -519,7 +521,7 @@ no_context:
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
 		}
-	#endif
+#endif
 		if (address < PAGE_SIZE)
 			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
 					"pointer dereference");
@@ -529,25 +531,38 @@ no_context:
 		printk(" at virtual address %08lx\n",address);
 		printk(KERN_ALERT " printing eip:\n");
 		printk("%08lx\n", regs->eip);
-	}
-	page = read_cr3();
-	page = ((unsigned long *) __va(page))[address >> 22];
-	if (oops_may_print())
+
+		page = read_cr3();
+		page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+#ifdef CONFIG_X86_PAE
+		printk(KERN_ALERT "*pdpt = %016Lx\n", page);
+		if ((page >> PAGE_SHIFT) < max_low_pfn
+		    && page & _PAGE_PRESENT) {
+			page &= PAGE_MASK;
+			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
+			                                         & (PTRS_PER_PMD - 1)];
+			printk(KERN_ALERT "*pde = %016Lx\n", page);
+			page &= ~_PAGE_NX;
+		}
+#else
 		printk(KERN_ALERT "*pde = %08lx\n", page);
-	/*
-	 * We must not directly access the pte in the highpte
-	 * case, the page table might be allocated in highmem.
-	 * And lets rather not kmap-atomic the pte, just in case
-	 * it's allocated already.
-	 */
-#ifndef CONFIG_HIGHPTE
-	if ((page & 1) && oops_may_print()) {
-		page &= PAGE_MASK;
-		address &= 0x003ff000;
-		page = ((unsigned long *) __va(page))[address >> PAGE_SHIFT];
-		printk(KERN_ALERT "*pte = %08lx\n", page);
-	}
 #endif
+
+		/*
+		 * We must not directly access the pte in the highpte
+		 * case if the page table is located in highmem.
+		 * And let's rather not kmap-atomic the pte, just in case
+		 * it's allocated already.
+		 */
+		if ((page >> PAGE_SHIFT) < max_low_pfn
+		    && (page & _PAGE_PRESENT)) {
+			page &= PAGE_MASK;
+			page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
+			                                         & (PTRS_PER_PTE - 1)];
+			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*2, (u64)page);
+		}
+	}
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
