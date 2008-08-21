Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbYHUChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbYHUChQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYHUCgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:36:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:29276 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYHUCgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:36:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="372421788"
Subject: [patch 1/4]pageattr: introduce APIs to change pageattr of a page
	array
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:46:06 +0800
Message-Id: <1219286766.18007.39.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add array interface APIs of pageattr. page based cache flush is quite
slow for a lot of pages. If pages are more than 1024 (4M), the patch
will use a wbinvd(). We have a simple test here (run a 3d game - open
arena), nearly all agp memory allocation are small (< 1M), so suppose
this will not impact runtime performance.

Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/pageattr.c       |  216 +++++++++++++++++++++++++++++++++----------
 include/asm-x86/cacheflush.h |    3 
 2 files changed, 169 insertions(+), 50 deletions(-)

Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c	2008-08-20 15:34:46.000000000 +0800
+++ linux/arch/x86/mm/pageattr.c	2008-08-21 10:14:47.000000000 +0800
@@ -25,15 +25,19 @@
  * The current flushing context - we pass it instead of 5 arguments:
  */
 struct cpa_data {
-	unsigned long	vaddr;
+	unsigned long	*vaddr;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
-	int		flushtlb;
+	int		flags;
 	unsigned long	pfn;
 	unsigned	force_split : 1;
+	int		curpage;
 };
 
+#define CPA_FLUSHTLB 1
+#define CPA_ARRAY 2
+
 #ifdef CONFIG_PROC_FS
 static unsigned long direct_pages_count[PG_LEVEL_NUM];
 
@@ -190,6 +194,41 @@ static void cpa_flush_range(unsigned lon
 	}
 }
 
+static void cpa_flush_array(unsigned long *start, int numpages, int cache)
+{
+	unsigned int i, level;
+	unsigned long *addr;
+
+	BUG_ON(irqs_disabled());
+
+	on_each_cpu(__cpa_flush_range, NULL, 1);
+
+	if (!cache)
+		return;
+
+	/* 4M threshold */
+	if (numpages >= 1024) {
+		if (boot_cpu_data.x86_model >= 4)
+			wbinvd();
+		return;
+	}
+	/*
+	 * We only need to flush on one CPU,
+	 * clflush is a MESI-coherent instruction that
+	 * will cause all other CPUs to flush the same
+	 * cachelines:
+	 */
+	for (i = 0, addr = start; i < numpages; i++, addr++) {
+		pte_t *pte = lookup_address(*addr, &level);
+
+		/*
+		 * Only flush present addresses:
+		 */
+		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
+			clflush_cache_range((void *) *addr, PAGE_SIZE);
+	}
+}
+
 /*
  * Certain areas of memory on x86 require very specific protection flags,
  * for example the BIOS area or kernel text. Callers don't always get this
@@ -398,7 +437,7 @@ try_preserve_large_page(pte_t *kpte, uns
 		 */
 		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
 		__set_pmd_pte(kpte, address, new_pte);
-		cpa->flushtlb = 1;
+		cpa->flags |= CPA_FLUSHTLB;
 		do_split = 0;
 	}
 
@@ -584,11 +623,16 @@ out_unlock:
 
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
-	unsigned long address = cpa->vaddr;
+	unsigned long address;
 	int do_split, err;
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
+	if (cpa->flags & CPA_ARRAY)
+		address = cpa->vaddr[cpa->curpage];
+	else
+		address = *cpa->vaddr;
+
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
@@ -600,7 +644,7 @@ repeat:
 			return 0;
 		WARN(1, KERN_WARNING "CPA: called for zero pte. "
 		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       cpa->vaddr);
+		       *cpa->vaddr);
 		return -EINVAL;
 	}
 
@@ -626,7 +670,7 @@ repeat:
 		 */
 		if (pte_val(old_pte) != pte_val(new_pte)) {
 			set_pte_atomic(kpte, new_pte);
-			cpa->flushtlb = 1;
+			cpa->flags |= CPA_FLUSHTLB;
 		}
 		cpa->numpages = 1;
 		return 0;
@@ -650,7 +694,7 @@ repeat:
 	 */
 	err = split_large_page(kpte, address);
 	if (!err) {
-		cpa->flushtlb = 1;
+		cpa->flags |= CPA_FLUSHTLB;
 		goto repeat;
 	}
 
@@ -663,6 +707,7 @@ static int cpa_process_alias(struct cpa_
 {
 	struct cpa_data alias_cpa;
 	int ret = 0;
+	unsigned long temp_cpa_vaddr, vaddr;
 
 	if (cpa->pfn >= max_pfn_mapped)
 		return 0;
@@ -675,16 +720,24 @@ static int cpa_process_alias(struct cpa_
 	 * No need to redo, when the primary call touched the direct
 	 * mapping already:
 	 */
-	if (!(within(cpa->vaddr, PAGE_OFFSET,
+	if (cpa->flags & CPA_ARRAY)
+		vaddr = cpa->vaddr[cpa->curpage];
+	else
+		vaddr = *cpa->vaddr;
+
+	if (!(within(vaddr, PAGE_OFFSET,
 		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
 #ifdef CONFIG_X86_64
-		|| within(cpa->vaddr, PAGE_OFFSET + (1UL<<32),
+		|| within(vaddr, PAGE_OFFSET + (1UL<<32),
 		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
 #endif
 	)) {
 
 		alias_cpa = *cpa;
-		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
+		alias_cpa.vaddr = &temp_cpa_vaddr;
+		alias_cpa.flags &= ~CPA_ARRAY;
+
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
 	}
@@ -696,7 +749,7 @@ static int cpa_process_alias(struct cpa_
 	 * No need to redo, when the primary call touched the high
 	 * mapping already:
 	 */
-	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+	if (within(vaddr, (unsigned long) _text, (unsigned long) _end))
 		return 0;
 
 	/*
@@ -707,8 +760,9 @@ static int cpa_process_alias(struct cpa_
 		return 0;
 
 	alias_cpa = *cpa;
-	alias_cpa.vaddr =
-		(cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+	alias_cpa.vaddr = &temp_cpa_vaddr;
+	alias_cpa.flags &= ~CPA_ARRAY;
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -728,6 +782,9 @@ static int __change_page_attr_set_clr(st
 		 * preservation check.
 		 */
 		cpa->numpages = numpages;
+		/* for array changes, we can't use large page */
+		if (cpa->flags & CPA_ARRAY)
+			cpa->numpages = 1;
 
 		ret = __change_page_attr(cpa, checkalias);
 		if (ret)
@@ -746,7 +803,11 @@ static int __change_page_attr_set_clr(st
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		cpa->vaddr += cpa->numpages * PAGE_SIZE;
+		if (cpa->flags & CPA_ARRAY)
+			cpa->curpage++;
+		else
+			*cpa->vaddr += cpa->numpages * PAGE_SIZE;
+
 	}
 	return 0;
 }
@@ -757,9 +818,9 @@ static inline int cache_attr(pgprot_t at
 		(_PAGE_PAT | _PAGE_PAT_LARGE | _PAGE_PWT | _PAGE_PCD);
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
+static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split)
+				    int force_split, int array)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -774,12 +835,22 @@ static int change_page_attr_set_clr(unsi
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (addr & ~PAGE_MASK) {
-		addr &= PAGE_MASK;
-		/*
-		 * People should not be passing in unaligned addresses:
-		 */
-		WARN_ON_ONCE(1);
+	if (!array) {
+		if (*addr & ~PAGE_MASK) {
+			*addr &= PAGE_MASK;
+			/*
+			 * People should not be passing in unaligned addresses:
+			 */
+			WARN_ON_ONCE(1);
+		}
+	} else {
+		int i;
+		for (i = 0; i < numpages; i++) {
+			if (addr[i] & ~PAGE_MASK) {
+				addr[i] &= PAGE_MASK;
+				WARN_ON_ONCE(1);
+			}
+		}
 	}
 
 	/* Must avoid aliasing mappings in the highmem code */
@@ -789,9 +860,13 @@ static int change_page_attr_set_clr(unsi
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
-	cpa.flushtlb = 0;
+	cpa.flags = 0;
+	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
+	if (array)
+		cpa.flags |= CPA_ARRAY;
+
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
 
@@ -800,7 +875,7 @@ static int change_page_attr_set_clr(unsi
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!cpa.flushtlb)
+	if (!(cpa.flags & CPA_FLUSHTLB))
 		goto out;
 
 	/*
@@ -815,9 +890,12 @@ static int change_page_attr_set_clr(unsi
 	 * error case we fall back to cpa_flush_all (which uses
 	 * wbindv):
 	 */
-	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages, cache);
-	else
+	if (!ret && cpu_has_clflush) {
+		if (cpa.flags & CPA_ARRAY)
+			cpa_flush_array(addr, numpages, cache);
+		else
+			cpa_flush_range(*addr, numpages, cache);
+	} else
 		cpa_flush_all(cache);
 
 out:
@@ -826,16 +904,18 @@ out:
 	return ret;
 }
 
-static inline int change_page_attr_set(unsigned long addr, int numpages,
-				       pgprot_t mask)
+static inline int change_page_attr_set(unsigned long *addr, int numpages,
+				       pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0);
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
+		array);
 }
 
-static inline int change_page_attr_clear(unsigned long addr, int numpages,
-					 pgprot_t mask)
+static inline int change_page_attr_clear(unsigned long *addr, int numpages,
+					 pgprot_t mask, int array)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
+		array);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
@@ -843,8 +923,8 @@ int _set_memory_uc(unsigned long addr, i
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_UC_MINUS));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 0);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)
@@ -860,10 +940,31 @@ int set_memory_uc(unsigned long addr, in
 }
 EXPORT_SYMBOL(set_memory_uc);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray)
+{
+	int i;
+	/*
+	 * for now UC MINUS. see comments in ioremap_nocache()
+	 */
+	for (i = 0; i < addrinarray; i++) {
+		if (reserve_memtype(addr[i], addr[i] + PAGE_SIZE,
+			    _PAGE_CACHE_UC_MINUS, NULL))
+			goto out;
+	}
+
+	return change_page_attr_set(addr, addrinarray,
+				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
+out:
+	while (--i >= 0)
+		free_memtype(addr[i], addr[i] + PAGE_SIZE);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(set_memory_array_uc);
+
 int _set_memory_wc(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages,
-				    __pgprot(_PAGE_CACHE_WC));
+	return change_page_attr_set(&addr, numpages,
+				    __pgprot(_PAGE_CACHE_WC), 0);
 }
 
 int set_memory_wc(unsigned long addr, int numpages)
@@ -881,8 +982,8 @@ EXPORT_SYMBOL(set_memory_wc);
 
 int _set_memory_wb(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
-				      __pgprot(_PAGE_CACHE_MASK));
+	return change_page_attr_clear(&addr, numpages,
+				      __pgprot(_PAGE_CACHE_MASK), 0);
 }
 
 int set_memory_wb(unsigned long addr, int numpages)
@@ -893,37 +994,48 @@ int set_memory_wb(unsigned long addr, in
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+int set_memory_array_wb(unsigned long *addr, int addrinarray)
+{
+	int i;
+	for (i = 0; i < addrinarray; i++)
+		free_memtype(addr[i], addr[i] + PAGE_SIZE);
+
+	return change_page_attr_clear(addr, addrinarray,
+				      __pgprot(_PAGE_CACHE_MASK), 1);
+}
+EXPORT_SYMBOL(set_memory_array_wb);
+
 int set_memory_x(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_NX), 0);
 }
 EXPORT_SYMBOL(set_memory_nx);
 
 int set_memory_ro(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_RW), 0);
 }
 
 int set_memory_np(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_PRESENT));
+	return change_page_attr_clear(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
 }
 
 int set_memory_4k(unsigned long addr, int numpages)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0),
-					__pgprot(0), 1);
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
+					__pgprot(0), 1, 0);
 }
 
 int set_pages_uc(struct page *page, int numpages)
@@ -976,20 +1088,24 @@ int set_pages_rw(struct page *page, int 
 
 static int __set_pages_p(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long) page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
-				.mask_clr = __pgprot(0)};
+				.mask_clr = __pgprot(0),
+				.flags = 0};
 
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 static int __set_pages_np(struct page *page, int numpages)
 {
-	struct cpa_data cpa = { .vaddr = (unsigned long) page_address(page),
+	unsigned long tempaddr = (unsigned long) page_address(page);
+	struct cpa_data cpa = { .vaddr = &tempaddr,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
-				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW)};
+				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
+				.flags = 0};
 
 	return __change_page_attr_set_clr(&cpa, 1);
 }
Index: linux/include/asm-x86/cacheflush.h
===================================================================
--- linux.orig/include/asm-x86/cacheflush.h	2008-08-20 15:34:46.000000000 +0800
+++ linux/include/asm-x86/cacheflush.h	2008-08-20 15:58:40.000000000 +0800
@@ -66,6 +66,9 @@ int set_memory_rw(unsigned long addr, in
 int set_memory_np(unsigned long addr, int numpages);
 int set_memory_4k(unsigned long addr, int numpages);
 
+int set_memory_array_uc(unsigned long *addr, int addrinarray);
+int set_memory_array_wb(unsigned long *addr, int addrinarray);
+
 /*
  * For legacy compatibility with the old APIs, a few functions
  * are provided that work on a "struct page".


