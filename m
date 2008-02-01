Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYBAJ4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYBAJ4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYBAJx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:26 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:7576 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbYBAJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:25 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/12] GBPAGES: Remove now unused clear_kernel_mapping
Message-Id: <20080201095323.5A1D31B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:23 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:05.0858 (UTC) FILETIME=[67845E20:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c        |   43 -------------------------------------------
 include/asm-x86/pgtable_64.h |    1 -
 2 files changed, 44 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -456,49 +456,6 @@ void __init paging_init(void)
 #endif
 
 /*
- * Unmap a kernel mapping if it exists. This is useful to avoid
- * prefetches from the CPU leading to inconsistent cache lines.
- * address and size must be aligned to 2MB boundaries.
- * Does nothing when the mapping doesn't exist.
- */
-void __init clear_kernel_mapping(unsigned long address, unsigned long size)
-{
-	unsigned long end = address + size;
-
-	BUG_ON(address & ~PMD_PAGE_MASK);
-	BUG_ON(size & ~PMD_PAGE_MASK);
-
-	for (; address < end; address += PMD_PAGE_SIZE) {
-		pgd_t *pgd = pgd_offset_k(address);
-		pud_t *pud;
-		pmd_t *pmd;
-
-		if (pgd_none(*pgd))
-			continue;
-
-		pud = pud_offset(pgd, address);
-		if (pud_none(*pud))
-			continue;
-
-		pmd = pmd_offset(pud, address);
-		if (!pmd || pmd_none(*pmd))
-			continue;
-
-		if (!(pmd_val(*pmd) & _PAGE_PSE)) {
-			/*
-			 * Could handle this, but it should not happen
-			 * currently:
-			 */
-			printk(KERN_ERR "clear_kernel_mapping: "
-				"mapping has been split. will leak memory\n");
-			pmd_ERROR(*pmd);
-		}
-		set_pmd(pmd, __pmd(0));
-	}
-	__flush_tlb_all();
-}
-
-/*
  * Memory hotplug specific functions
  */
 void online_page(struct page *page)
Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -21,7 +21,6 @@ extern pgd_t init_level4_pgt[];
 #define swapper_pg_dir init_level4_pgt
 
 extern void paging_init(void);
-extern void clear_kernel_mapping(unsigned long addr, unsigned long size);
 
 #endif /* !__ASSEMBLY__ */
 
