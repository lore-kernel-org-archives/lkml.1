Return-Path: <linux-kernel-owner+w=401wt.eu-S1761852AbZCTKZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852AbZCTKZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbZCTKZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:25:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:35148 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759787AbZCTKZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:25:09 -0400
Date: Fri, 20 Mar 2009 10:24:33 GMT
From: "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090319215358.758513000@intel.com>
References: <20090319215358.758513000@intel.com>
Subject: [tip:x86/mm] x86, PAT: Add support for struct page pointer array in cpa set_clr
Message-ID: <tip-9ae2847591c857bed44bc094b908b412bfa1b244@git.kernel.org>
Git-Commit-ID: 9ae2847591c857bed44bc094b908b412bfa1b244
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 10:24:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ae2847591c857bed44bc094b908b412bfa1b244
Gitweb:     http://git.kernel.org/tip/9ae2847591c857bed44bc094b908b412bfa1b244
Author:     venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 19 Mar 2009 14:51:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 10:34:48 +0100

x86, PAT: Add support for struct page pointer array in cpa set_clr

Add struct page array pointer to cpa struct and CPA_PAGES_ARRAY.

With that we can add change_page_attr_set_clr() a parameter to pass
struct page array pointer and that can be handled by the underlying
cpa code.

cpa_flush_array() is also changed to support both addr array or
struct page pointer array, depending on the flag.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@infradead.org
Cc: eric@anholt.net
Cc: airlied@redhat.com
LKML-Reference: <20090319215358.758513000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pageattr.c |   79 ++++++++++++++++++++++++++++++-----------------
 1 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 69009af..e5c257f 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -34,6 +34,7 @@ struct cpa_data {
 	unsigned long	pfn;
 	unsigned	force_split : 1;
 	int		curpage;
+	struct page	**pages;
 };
 
 /*
@@ -46,6 +47,7 @@ static DEFINE_SPINLOCK(cpa_lock);
 
 #define CPA_FLUSHTLB 1
 #define CPA_ARRAY 2
+#define CPA_PAGES_ARRAY 4
 
 #ifdef CONFIG_PROC_FS
 static unsigned long direct_pages_count[PG_LEVEL_NUM];
@@ -202,10 +204,10 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
-static void cpa_flush_array(unsigned long *start, int numpages, int cache)
+static void cpa_flush_array(unsigned long *start, int numpages, int cache,
+			    int in_flags, struct page **pages)
 {
 	unsigned int i, level;
-	unsigned long *addr;
 
 	BUG_ON(irqs_disabled());
 
@@ -226,14 +228,22 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache)
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
 
@@ -585,7 +595,9 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	unsigned int level;
 	pte_t *kpte, old_pte;
 
-	if (cpa->flags & CPA_ARRAY)
+	if (cpa->flags & CPA_PAGES_ARRAY)
+		address = (unsigned long)page_address(cpa->pages[cpa->curpage]);
+	else if (cpa->flags & CPA_ARRAY)
 		address = cpa->vaddr[cpa->curpage];
 	else
 		address = *cpa->vaddr;
@@ -688,7 +700,9 @@ static int cpa_process_alias(struct cpa_data *cpa)
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
@@ -699,7 +713,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa = *cpa;
 		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
 		alias_cpa.vaddr = &temp_cpa_vaddr;
-		alias_cpa.flags &= ~CPA_ARRAY;
+		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
 
 		ret = __change_page_attr_set_clr(&alias_cpa, 0);
@@ -725,7 +739,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	alias_cpa = *cpa;
 	temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
 	alias_cpa.vaddr = &temp_cpa_vaddr;
-	alias_cpa.flags &= ~CPA_ARRAY;
+	alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
 
 	/*
 	 * The high mapping range is imprecise, so ignore the return value.
@@ -746,7 +760,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 */
 		cpa->numpages = numpages;
 		/* for array changes, we can't use large page */
-		if (cpa->flags & CPA_ARRAY)
+		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
 		if (!debug_pagealloc)
@@ -770,7 +784,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 */
 		BUG_ON(cpa->numpages > numpages);
 		numpages -= cpa->numpages;
-		if (cpa->flags & CPA_ARRAY)
+		if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY))
 			cpa->curpage++;
 		else
 			*cpa->vaddr += cpa->numpages * PAGE_SIZE;
@@ -787,7 +801,8 @@ static inline int cache_attr(pgprot_t attr)
 
 static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int force_split, int in_flag)
+				    int force_split, int in_flag,
+				    struct page **pages)
 {
 	struct cpa_data cpa;
 	int ret, cache, checkalias;
@@ -802,15 +817,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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
@@ -818,6 +825,18 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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
@@ -833,6 +852,7 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	arch_flush_lazy_mmu_mode();
 
 	cpa.vaddr = addr;
+	cpa.pages = pages;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
@@ -840,8 +860,8 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	if (in_flag & CPA_ARRAY)
-		cpa.flags |= CPA_ARRAY;
+	if (in_flag & (CPA_ARRAY | CPA_PAGES_ARRAY))
+		cpa.flags |= in_flag;
 
 	/* No alias checking for _NX bit modifications */
 	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
@@ -867,9 +887,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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
@@ -889,14 +910,14 @@ static inline int change_page_attr_set(unsigned long *addr, int numpages,
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
@@ -1044,7 +1065,7 @@ int set_memory_np(unsigned long addr, int numpages)
 int set_memory_4k(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(&addr, numpages, __pgprot(0),
-					__pgprot(0), 1, 0);
+					__pgprot(0), 1, 0, NULL);
 }
 
 int set_pages_uc(struct page *page, int numpages)
