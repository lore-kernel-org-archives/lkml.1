Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752307AbYLRUCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbYLRUCV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYLRUBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:27331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbYLRUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="475173569"
Message-Id: <20081218194617.247280000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:28 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/7] x86 PAT: Add follow_pfnmp_pte routine to help tracking pfnmap pages - v3
Content-Disposition: inline; filename=follow_pfn.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic interface to follow pfn in a pfnmap vma range. This is used by
one of the subsequent x86 PAT related patch to keep track of memory types
for vma regions across vma copy and free.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    3 +++
 mm/memory.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-11-25 13:56:46.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-11-25 14:20:23.000000000 -0800
@@ -1223,6 +1223,9 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
 
+int follow_pfnmap_pte(struct vm_area_struct *vma,
+				unsigned long address, pte_t *ret_ptep);
+
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2008-11-25 14:07:42.000000000 -0800
+++ linux-2.6/mm/memory.c	2008-11-25 14:18:35.000000000 -0800
@@ -1111,6 +1111,49 @@ no_page_table:
 	return page;
 }
 
+int follow_pfnmap_pte(struct vm_area_struct *vma, unsigned long address,
+			pte_t *ret_ptep)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	struct page *page;
+	struct mm_struct *mm = vma->vm_mm;
+
+	if (!is_pfn_mapping(vma))
+		goto err;
+
+	page = NULL;
+	pgd = pgd_offset(mm, address);
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		goto err;
+
+	pud = pud_offset(pgd, address);
+	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
+		goto err;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+		goto err;
+
+	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+
+	pte = *ptep;
+	if (!pte_present(pte))
+		goto err_unlock;
+
+	*ret_ptep = pte;
+	pte_unmap_unlock(ptep, ptl);
+	return 0;
+
+err_unlock:
+	pte_unmap_unlock(ptep, ptl);
+err:
+	return -EINVAL;
+}
+
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
 {

-- 

