Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYLSVuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYLSVuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYLSVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:28552 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbYLSVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="416028216"
Message-Id: <20081219214837.269727000@intel.com>
References: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:28 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/5] x86 PAT: remove follow_pfnmap_pte in favor of follow_phys
Content-Disposition: inline; filename=reuse_follow_phys_in_pat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace follow_pfnmap_pte in pat code with follow_phys. follow_phys lso
returns protection eliminating the need of pte_pgprot call. Using follow_phys
also eliminates the need for pte_pa.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/include/asm/pgtable.h |    5 ----
 arch/x86/mm/pat.c              |   30 ++++++++++------------------
 include/linux/mm.h             |    3 --
 mm/memory.c                    |   43 -----------------------------------------
 4 files changed, 11 insertions(+), 70 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-19 09:56:08.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-19 09:58:16.000000000 -0800
@@ -1239,9 +1239,6 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
 
-int follow_pfnmap_pte(struct vm_area_struct *vma,
-				unsigned long address, pte_t *ret_ptep);
-
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-12-19 09:56:08.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-12-19 09:58:16.000000000 -0800
@@ -1168,49 +1168,6 @@ no_page_table:
 	return page;
 }
 
-int follow_pfnmap_pte(struct vm_area_struct *vma, unsigned long address,
-			pte_t *ret_ptep)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep, pte;
-	spinlock_t *ptl;
-	struct page *page;
-	struct mm_struct *mm = vma->vm_mm;
-
-	if (!is_pfn_mapping(vma))
-		goto err;
-
-	page = NULL;
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto err;
-
-	pud = pud_offset(pgd, address);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto err;
-
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
-		goto err;
-
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-
-	pte = *ptep;
-	if (!pte_present(pte))
-		goto err_unlock;
-
-	*ret_ptep = pte;
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-
-err_unlock:
-	pte_unmap_unlock(ptep, ptl);
-err:
-	return -EINVAL;
-}
-
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
 {
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-12-19 09:55:25.000000000 -0800
+++ linux-2.6/arch/x86/mm/pat.c	2008-12-19 09:58:16.000000000 -0800
@@ -685,8 +685,7 @@ int track_pfn_vma_copy(struct vm_area_st
 	int retval = 0;
 	unsigned long i, j;
 	u64 paddr;
-	pgprot_t prot;
-	pte_t pte;
+	unsigned long prot;
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
@@ -696,26 +695,22 @@ int track_pfn_vma_copy(struct vm_area_st
 
 	if (is_linear_pfn_mapping(vma)) {
 		/*
-		 * reserve the whole chunk starting from vm_pgoff,
-		 * But, we have to get the protection from pte.
+		 * reserve the whole chunk covered by vma. We need the
+		 * starting address and protection from pte.
 		 */
-		if (follow_pfnmap_pte(vma, vma_start, &pte)) {
+		if (follow_phys(vma, vma_start, 0, &prot, &paddr)) {
 			WARN_ON_ONCE(1);
-			return -1;
+			return -EINVAL;
 		}
-		prot = pte_pgprot(pte);
-		paddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
-		return reserve_pfn_range(paddr, vma_size, prot);
+		return reserve_pfn_range(paddr, vma_size, __pgprot(prot));
 	}
 
 	/* reserve entire vma page by page, using pfn and prot from pte */
 	for (i = 0; i < vma_size; i += PAGE_SIZE) {
-		if (follow_pfnmap_pte(vma, vma_start + i, &pte))
+		if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 			continue;
 
-		paddr = pte_pa(pte);
-		prot = pte_pgprot(pte);
-		retval = reserve_pfn_range(paddr, PAGE_SIZE, prot);
+		retval = reserve_pfn_range(paddr, PAGE_SIZE, __pgprot(prot));
 		if (retval)
 			goto cleanup_ret;
 	}
@@ -724,10 +719,9 @@ int track_pfn_vma_copy(struct vm_area_st
 cleanup_ret:
 	/* Reserve error: Cleanup partial reservation and return error */
 	for (j = 0; j < i; j += PAGE_SIZE) {
-		if (follow_pfnmap_pte(vma, vma_start + j, &pte))
+		if (follow_phys(vma, vma_start + j, 0, &prot, &paddr))
 			continue;
 
-		paddr = pte_pa(pte);
 		free_pfn_range(paddr, PAGE_SIZE);
 	}
 
@@ -797,6 +791,7 @@ void untrack_pfn_vma(struct vm_area_stru
 {
 	unsigned long i;
 	u64 paddr;
+	unsigned long prot;
 	unsigned long vma_start = vma->vm_start;
 	unsigned long vma_end = vma->vm_end;
 	unsigned long vma_size = vma_end - vma_start;
@@ -821,12 +816,9 @@ void untrack_pfn_vma(struct vm_area_stru
 	} else {
 		/* free entire vma, page by page, using the pfn from pte */
 		for (i = 0; i < vma_size; i += PAGE_SIZE) {
-			pte_t pte;
-
-			if (follow_pfnmap_pte(vma, vma_start + i, &pte))
+			if (follow_phys(vma, vma_start + i, 0, &prot, &paddr))
 				continue;
 
-			paddr = pte_pa(pte);
 			free_pfn_range(paddr, PAGE_SIZE);
 		}
 	}
Index: linux-2.6/arch/x86/include/asm/pgtable.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pgtable.h	2008-12-19 09:55:25.000000000 -0800
+++ linux-2.6/arch/x86/include/asm/pgtable.h	2008-12-19 09:58:16.000000000 -0800
@@ -230,11 +230,6 @@ static inline unsigned long pte_pfn(pte_
 	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
-static inline u64 pte_pa(pte_t pte)
-{
-	return pte_val(pte) & PTE_PFN_MASK;
-}
-
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)

-- 

