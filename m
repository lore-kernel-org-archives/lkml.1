Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbXISDiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbXISDiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXISDgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:36:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53624 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751894AbXISDgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:36:42 -0400
Message-Id: <20070919033640.547324852@sgi.com>
From: Christoph Lameter <clameter@sgi.com>
References: <20070919033605.785839297@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 20:36:06 -0700
To: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: [01/17] Vmalloc: Move vmalloc_to_page to mm/vmalloc.
Content-Disposition: inline; filename=vcompound_move_vmalloc_to_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already have page table manipulation for vmalloc in vmalloc.c. Move the
vmalloc_to_page() function there as well. Also move the related definitions
from include/linux/mm.h.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h      |    2 --
 include/linux/vmalloc.h |    4 ++++
 mm/memory.c             |   40 ----------------------------------------
 mm/vmalloc.c            |   38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 42 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-09-18 18:33:56.000000000 -0700
+++ linux-2.6/mm/memory.c	2007-09-18 18:34:06.000000000 -0700
@@ -2727,46 +2727,6 @@ int make_pages_present(unsigned long add
 	return ret == len ? 0 : -1;
 }
 
-/* 
- * Map a vmalloc()-space virtual address to the physical page.
- */
-struct page * vmalloc_to_page(void * vmalloc_addr)
-{
-	unsigned long addr = (unsigned long) vmalloc_addr;
-	struct page *page = NULL;
-	pgd_t *pgd = pgd_offset_k(addr);
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-  
-	if (!pgd_none(*pgd)) {
-		pud = pud_offset(pgd, addr);
-		if (!pud_none(*pud)) {
-			pmd = pmd_offset(pud, addr);
-			if (!pmd_none(*pmd)) {
-				ptep = pte_offset_map(pmd, addr);
-				pte = *ptep;
-				if (pte_present(pte))
-					page = pte_page(pte);
-				pte_unmap(ptep);
-			}
-		}
-	}
-	return page;
-}
-
-EXPORT_SYMBOL(vmalloc_to_page);
-
-/*
- * Map a vmalloc()-space virtual address to the physical page frame number.
- */
-unsigned long vmalloc_to_pfn(void * vmalloc_addr)
-{
-	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
-}
-
-EXPORT_SYMBOL(vmalloc_to_pfn);
-
 #if !defined(__HAVE_ARCH_GATE_AREA)
 
 #if defined(AT_SYSINFO_EHDR)
Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c	2007-09-18 18:33:56.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-18 18:34:06.000000000 -0700
@@ -166,6 +166,44 @@ int map_vm_area(struct vm_struct *area, 
 }
 EXPORT_SYMBOL_GPL(map_vm_area);
 
+/*
+ * Map a vmalloc()-space virtual address to the physical page.
+ */
+struct page *vmalloc_to_page(void *vmalloc_addr)
+{
+	unsigned long addr = (unsigned long) vmalloc_addr;
+	struct page *page = NULL;
+	pgd_t *pgd = pgd_offset_k(addr);
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+
+	if (!pgd_none(*pgd)) {
+		pud = pud_offset(pgd, addr);
+		if (!pud_none(*pud)) {
+			pmd = pmd_offset(pud, addr);
+			if (!pmd_none(*pmd)) {
+				ptep = pte_offset_map(pmd, addr);
+				pte = *ptep;
+				if (pte_present(pte))
+					page = pte_page(pte);
+				pte_unmap(ptep);
+			}
+		}
+	}
+	return page;
+}
+EXPORT_SYMBOL(vmalloc_to_page);
+
+/*
+ * Map a vmalloc()-space virtual address to the physical page frame number.
+ */
+unsigned long vmalloc_to_pfn(void *vmalloc_addr)
+{
+	return page_to_pfn(vmalloc_to_page(vmalloc_addr));
+}
+EXPORT_SYMBOL(vmalloc_to_pfn);
+
 static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
 					    unsigned long start, unsigned long end,
 					    int node, gfp_t gfp_mask)
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-09-18 18:33:56.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-18 18:34:06.000000000 -0700
@@ -1160,8 +1160,6 @@ static inline unsigned long vma_pages(st
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
Index: linux-2.6/include/linux/vmalloc.h
===================================================================
--- linux-2.6.orig/include/linux/vmalloc.h	2007-09-18 18:33:57.000000000 -0700
+++ linux-2.6/include/linux/vmalloc.h	2007-09-18 18:34:24.000000000 -0700
@@ -81,6 +81,10 @@ extern void unmap_kernel_range(unsigned 
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
 
+/* Determine page struct from address */
+struct page *vmalloc_to_page(void *addr);
+unsigned long vmalloc_to_pfn(void *addr);
+
 /*
  *	Internals.  Dont't use..
  */

-- 
