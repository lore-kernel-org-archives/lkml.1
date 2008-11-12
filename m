Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYKLXWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYKLXWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbYKLXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:43883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbYKLXUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="402946552"
Message-Id: <20081112212900.291460000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:50 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/8] x86 PAT: Add follow_pfnmp_pte routine to help tracking pfnmap pages
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

Index: tip/include/linux/mm.h
===================================================================
--- tip.orig/include/linux/mm.h	2008-11-06 15:41:43.000000000 -0800
+++ tip/include/linux/mm.h	2008-11-10 09:44:45.000000000 -0800
@@ -1223,6 +1223,9 @@ struct page *follow_page(struct vm_area_
 #define FOLL_GET	0x04	/* do get_page on page */
 #define FOLL_ANON	0x08	/* give ZERO_PAGE if no pgtable */
 
+unsigned long follow_pfnmap_pte(struct vm_area_struct *vma,
+				unsigned long address, pte_t *ret_ptep);
+
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c	2008-11-06 15:41:43.000000000 -0800
+++ tip/mm/memory.c	2008-11-10 09:44:45.000000000 -0800
@@ -1111,6 +1111,49 @@ no_page_table:
 	return page;
 }
 
+unsigned long follow_pfnmap_pte(struct vm_area_struct *vma,
+			unsigned long address, pte_t *ret_ptep)
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
+	return -1;
+}
+
 /* Can we do the FOLL_ANON optimization? */
 static inline int use_zero_page(struct vm_area_struct *vma)
 {

-- 

