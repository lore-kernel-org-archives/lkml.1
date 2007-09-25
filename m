Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbXIYXnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbXIYXnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXIYXmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:42:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57656 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbXIYXmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:42:49 -0400
Message-Id: <20070925234249.395249001@sgi.com>
References: <20070925234204.546836393@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 16:42:05 -0700
From: Christoph Lameter <clameter@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [01/17] Vmalloc: Move vmalloc_to_page to mm/vmalloc.
Content-Disposition: inline; filename=vcompound_move_vmalloc_to_page
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We already have page table manipulation for vmalloc in vmalloc.c. Move the
vmalloc_to_page() function there as well.

Move the definitions for vmalloc related functions in mm.h to before the
functions dealing with compound pages because they will soon need to use
them.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h |    5 +++--
 mm/memory.c        |   40 ----------------------------------------
 mm/vmalloc.c       |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 42 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-09-24 16:55:28.000000000 -0700
+++ linux-2.6/mm/memory.c	2007-09-24 16:55:32.000000000 -0700
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
--- linux-2.6.orig/mm/vmalloc.c	2007-09-24 16:55:28.000000000 -0700
+++ linux-2.6/mm/vmalloc.c	2007-09-24 16:55:32.000000000 -0700
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
--- linux-2.6.orig/include/linux/mm.h	2007-09-24 16:55:28.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2007-09-24 16:57:23.000000000 -0700
@@ -294,6 +294,9 @@ static inline int get_page_unless_zero(s
 	return atomic_inc_not_zero(&page->_count);
 }
 
+struct page *vmalloc_to_page(void *addr);
+unsigned long vmalloc_to_pfn(void *addr);
+
 static inline struct page *compound_head(struct page *page)
 {
 	if (unlikely(PageTail(page)))
@@ -1160,8 +1163,6 @@ static inline unsigned long vma_pages(st
 
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
-struct page *vmalloc_to_page(void *addr);
-unsigned long vmalloc_to_pfn(void *addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);

-- 
