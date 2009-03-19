Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZCSVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZCSVzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbZCSVz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:55:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:61334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbZCSVz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:55:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,391,1233561600"; 
   d="scan'208";a="674391767"
Message-Id: <20090319215358.758513000@intel.com>
References: <20090319215112.636641000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 14:51:14 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com
Cc: arjan@infradead.org, eric@anholt.net, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/3] x86, PAT: Add support for struct page pointer array in cpa set_clr
Content-Disposition: inline; filename=change_page_attr_set_clr_struct_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct page array pointer to cpa struct and CPA_PAGES_ARRAY.
With that we can add change_page_attr_set_clr() a parameter to pass sruct page
array pointer and that can be handled by the underlying cpa code.

cpa_flush_array() is also changed to support both addr array or struct page
pointer array, depending on the flag.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pageattr.c |   79 +++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 29 deletions(-)

Index: tip/arch/x86/mm/pageattr.c
===================================================================
--- tip.orig/arch/x86/mm/pageattr.c	2009-03-17 11:03:31.000000000 -0700
+++ tip/arch/x86/mm/pageattr.c	2009-03-17 11:03:51.000000000 -0700
@@ -33,6 +33,7 @@ struct cpa_data {
 	unsigned long	pfn;
 	unsigned	force_split : 1;
 	int		curpage;
+	struct page	**pages;
 };
 
 /*
@@ -45,6 +46,7 @@ static DEFINE_SPINLOCK(cpa_lock);
 
 #define CPA_FLUSHTLB 1
 #define CPA_ARRAY 2
+#define CPA_PAGES_ARRAY 4
 
 #ifdef CONFIG_PROC_FS
 static unsigned long direct_pages_count[PG_LEVEL_NUM];
@@ -201,10 +203,10 @@ static void cpa_flush_range(unsigned lon
 	}
 }
 
-static void cpa_flush_array(unsigned long *start, int numpages, int cache)
+static void cpa_flush_array(unsigned long *start, int numpages, int cache,
+			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
-	unsigned long *addr;
 
 	BUG_ON(irqs_disabled());
 
@@ -225,14 +227,22 @@ static void cpa_flush_array(unsigned lon
 	 * will cause all other CPUs to flush the same
 	 * cachelines:
 	 */
-	for (i = 0, addr = start; i < numpages; i++, addr++) {
-		pte_t *pte = lookup_address(*addr, &level);
+	for (i = 0; i < numpages; i++) {
+		unsigned long addr;
+		pte_t *pte;
+
+		if (in_flags & CPA_PAGES_ARRAY)
+			addr = (unsigned long)page_address(pages[i]);
+		else
+			addr = start[i];
+
+		pte = lookup_address(addr, &level);
 
 		/*
 		 * Only flush present addresses:
 		 */
 		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
-			clflush_cache_range((void *) *addr, PAGE_SIZE);
+			clflush_cache_range((void *)addr, PAGE_SIZE);
 	}
 }
 
@@ -584,7 +594,9 @@ static int __change_page_attr(struct cpa
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
-	if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY)
+		address = (unsigned long)page_address(cpa->pages[cpa->curpage]);
+	else if (cpa->flags & CPA_ARRAY)
 		address = cpa->vaddr[cpa->curpage];
 	else
 		address = *cpa->vaddr;
@@ -687,7 +699,9 @@ static int cpa_process_alias(struct cpa_
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY)
+		vaddr = (unsigned long)page_address(cpa->pages[cpa->curpage]);
+	else if (cpa->flags & CPA_ARRAY)
 		vaddr = cpa->vaddr[cpa->curpage];
 	else
 		vaddr = *cpa->vaddr;
@@ -698,7 +712,7 @@ static int cpa_process_alias(struct cpa_
 		alias_cpa = *cpa;
 		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
 		alias_cpa.vaddr = &temp_cpa_vaddr;
-		alias_cpa.flags &= ~CPA_ARRAY;
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
@@ -724,7 +738,7 @@ static int cpa_process_alias(struct cpa_
 	alias_cpa = *cpa;
 	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
 	alias_cpa.vaddr = &temp_cpa_vaddr;
-	alias_cpa.flags &= ~CPA_ARRAY;
+	alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -745,7 +759,7 @@ static int __change_page_attr_set_clr(st
 		 */
 		cpa->numpages = numpages;
 		/* for array changes, we can't use large page */
-		if (cpa->flags & CPA_ARRAY)
+		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
 		if (!debug_pagealloc)
@@ -769,7 +783,7 @@ static int __change_page_attr_set_clr(st
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		if (cpa->flags & CPA_ARRAY)
+		if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY))
 			cpa->curpage++;
 		else
 			*cpa->vaddr += cpa->numpages * PAGE_SIZE;
@@ -786,7 +800,8 @@ static inline int cache_attr(pgprot_t at
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split, int in_flag)
+				    int force_split, int in_flag,
+				    struct page **pages)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -801,15 +816,7 @@ static int change_page_attr_set_clr(unsi
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (!(in_flag & CPA_ARRAY)) {
-		if (*addr & ~PAGE_MASK) {
-			*addr &= PAGE_MASK;
-			/*
-			 * People should not be passing in unaligned addresses:
-			 */
-			WARN_ON_ONCE(1);
-		}
-	} else {
+	if (in_flag & CPA_ARRAY) {
 		int i;
 		for (i = 0; i < numpages; i++) {
 			if (addr[i] & ~PAGE_MASK) {
@@ -817,6 +824,18 @@ static int change_page_attr_set_clr(unsi
 				WARN_ON_ONCE(1);
 			}
 		}
+	} else if (!(in_flag & CPA_PAGES_ARRAY)) {
+		/*
+		 * in_flag of CPA_PAGES_ARRAY implies it is aligned.
+		 * No need to cehck in that case
+		 */
+		if (*addr & ~PAGE_MASK) {
+			*addr &= PAGE_MASK;
+			/*
+			 * People should not be passing in unaligned addresses:
+			 */
+			WARN_ON_ONCE(1);
+		}
 	}
 
 	/* Must avoid aliasing mappings in the highmem code */
@@ -832,6 +851,7 @@ static int change_page_attr_set_clr(unsi
 	arch_flush_lazy_mmu_mode();
 
 	cpa.vaddr = addr;
+	cpa.pages = pages;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
@@ -839,8 +859,8 @@ static int change_page_attr_set_clr(unsi
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	if (in_flag & CPA_ARRAY)
-		cpa.flags |= CPA_ARRAY;
+	if (in_flag & (CPA_ARRAY | CPA_PAGES_ARRAY))
+		cpa.flags |= in_flag;
 
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
@@ -866,9 +886,10 @@ static int change_page_attr_set_clr(unsi
 	 * wbindv):
 	 */
 	if (!ret && cpu_has_clflush) {
-		if (cpa.flags & CPA_ARRAY)
-			cpa_flush_array(addr, numpages, cache);
-		else
+		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
+			cpa_flush_array(addr, numpages, cache,
+					cpa.flags, pages);
+		} else
 			cpa_flush_range(*addr, numpages, cache);
 	} else
 		cpa_flush_all(cache);
@@ -888,14 +909,14 @@ static inline int change_page_attr_set(u
 				       pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
-		(array ? CPA_ARRAY : 0));
+		(array ? CPA_ARRAY : 0), NULL);
 }
 
 static inline int change_page_attr_clear(unsigned long *addr, int numpages,
 					 pgprot_t mask, int array)
 {
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
-		(array ? CPA_ARRAY : 0));
+		(array ? CPA_ARRAY : 0), NULL);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
@@ -1043,7 +1064,7 @@ int set_memory_np(unsigned long addr, in
 int set_memory_4k(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
-					__pgprot(0), 1, 0);
+					__pgprot(0), 1, 0, NULL);
 }
 
 int set_pages_uc(struct page *page, int numpages)

-- 

