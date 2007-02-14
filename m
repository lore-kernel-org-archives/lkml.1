Return-Path: <linux-kernel-owner+w=401wt.eu-S932165AbXBNHjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbXBNHjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 02:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbXBNHjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 02:39:13 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:50126
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932165AbXBNHjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 02:39:12 -0500
Message-Id: <45D2CAE5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 14 Feb 2007 07:40:05 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@osdl.org>, "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: adjustments to page table dump during oops (v3)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- make the page table contents printing PAE capable
- make sure the address stored in current->thread.cr2 is unmodified from
  what was read from CR2
- don't call oops_may_print() multiple times, when one time suffices
- print pte even in highpte case, as long as the pte page isn't in
  actually in high memory (which is specifically the case for all page
  tables covering kernel space)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.20/arch/i386/mm/fault.c	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.20-i386-page-fault-dump/arch/i386/mm/fault.c	2007-02-14 08:31:38.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/tty.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 #include <linux/highmem.h>
+#include <linux/bootmem.h>		/* for max_low_pfn */
 #include <linux/module.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -327,7 +328,6 @@ fastcall void __kprobes do_page_fault(st
 	struct mm_struct *mm;
 	struct vm_area_struct * vma;
 	unsigned long address;
-	unsigned long page;
 	int write, si_code;
 
 	/* get the address */
@@ -538,7 +538,9 @@ no_context:
 	bust_spinlocks(1);
 
 	if (oops_may_print()) {
-	#ifdef CONFIG_X86_PAE
+		__typeof__(pte_val(__pte(0))) page;
+
+#ifdef CONFIG_X86_PAE
 		if (error_code & 16) {
 			pte_t *pte = lookup_address(address);
 
@@ -547,7 +549,7 @@ no_context:
 					"NX-protected page - exploit attempt? "
 					"(uid: %d)\n", current->uid);
 		}
-	#endif
+#endif
 		if (address < PAGE_SIZE)
 			printk(KERN_ALERT "BUG: unable to handle kernel NULL "
 					"pointer dereference");
@@ -557,25 +559,37 @@ no_context:
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
+		printk(KERN_ALERT "*pdpt = %0*Lx\n", sizeof(page)*4, (u64)page);
+		if (page & _PAGE_PRESENT) {
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
+			printk(KERN_ALERT "*pte = %0*Lx\n", sizeof(page)*4, (u64)page);
+		}
+	}
+
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;


