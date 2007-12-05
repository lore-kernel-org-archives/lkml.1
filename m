Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbXLEH71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbXLEH71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXLEHzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:37 -0500
Received: from ns.suse.de ([195.135.220.2]:38671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbXLEHzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:12 -0500
Message-Id: <20071205071628.484654000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:16:03 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 16/18] mm: special mapping nopage
Content-Disposition: inline; filename=special-mapping-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert special mapping install from nopage to fault. This requires a
small special case in the do_linear_fault calculation in order to handle
vmas without ->vm_file set.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memory.c |   10 +++++++---
 mm/mmap.c   |   19 +++++++++----------
 2 files changed, 16 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -2352,9 +2352,13 @@ static int do_linear_fault(struct mm_str
 		unsigned long address, pte_t *page_table, pmd_t *pmd,
 		int write_access, pte_t orig_pte)
 {
-	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
+	pgoff_t pgoff;
+	unsigned int flags;
+
+	pgoff = (((address) - vma->vm_start) >> PAGE_SHIFT);
+	if (likely(vma->vm_file))
+		pgoff += vma->vm_pgoff;
+	flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	pte_unmap(page_table);
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -2149,24 +2149,23 @@ int may_expand_vm(struct mm_struct *mm, 
 }
 
 
-static struct page *special_mapping_nopage(struct vm_area_struct *vma,
-					   unsigned long address, int *type)
+static int special_mapping_fault(struct vm_area_struct *vma,
+				struct vm_fault *vmf)
 {
+	pgoff_t pgoff = vmf->pgoff;
 	struct page **pages;
 
-	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-
-	address -= vma->vm_start;
-	for (pages = vma->vm_private_data; address > 0 && *pages; ++pages)
-		address -= PAGE_SIZE;
+	for (pages = vma->vm_private_data; pgoff && *pages; ++pages)
+		pgoff--;
 
 	if (*pages) {
 		struct page *page = *pages;
 		get_page(page);
-		return page;
+		vmf->page = page;
+		return 0;
 	}
 
-	return NOPAGE_SIGBUS;
+	return VM_FAULT_SIGBUS;
 }
 
 /*
@@ -2178,7 +2177,7 @@ static void special_mapping_close(struct
 
 static struct vm_operations_struct special_mapping_vmops = {
 	.close = special_mapping_close,
-	.nopage	= special_mapping_nopage,
+	.fault = special_mapping_fault,
 };
 
 /*

-- 

