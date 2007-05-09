Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbXEIPu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbXEIPu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbXEIPut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:50:49 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51181 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbXEIPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:50:48 -0400
Date: Wed, 9 May 2007 16:50:31 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Srinivasa Ds <srinivasa@in.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <clameter@sgi.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel expection generated with 2.6.21-mm1 kernel boot up
In-Reply-To: <464185CF.8010800@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0705091644340.21630@blonde.wat.veritas.com>
References: <463F196C.9070501@linux.vnet.ibm.com> <46406816.8030106@in.ibm.com>
 <Pine.LNX.4.64.0705081119590.10126@schroedinger.engr.sgi.com>
 <464185CF.8010800@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 09 May 2007 15:50:47.0242 (UTC) FILETIME=[CF5E52A0:01C79251]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZwBiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmcAY2xhbWV0ZXJAc2dpLmNvbQBrYW1hbGVzaEBsaW51eC52bmV0LmlibS5jb20AYmFsYmlyQGxpbnV4LnZuZXQuaWJtLmNvbQBzcmluaXZhc2FAaW4uaWJtLmNvbQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007, Srinivasa Ds wrote:
> Christoph Lameter wrote:
> > On Tue, 8 May 2007, Srinivasa Ds wrote:
> > 
> >> Looks like there is a bug in SLUB implementaion for ppc64 in 2.6.21-mm1.
> >> I unmarked CONFIG_SLUB and build the kernel, its booting cleary now.
> > 
> > This is a known issue for PPC with more than 4 processors. Work is in 
> > progress for a general fix.
> 
> That would be good. Incase if you have fix, please let us know so that
> we can test it on ppc64.

Here's Ben's & my patch, on its way from PowerPC git to Linus' git.
If you're an oldconfig user, you'll probably find you need to delete
your CONFIG_SLAB=y to get Kconfig to offer you the choice of SLUB now.

powerpc: Don't use SLAB/SLUB for PTE pages

From: Hugh Dickins <hugh@veritas.com>

The SLUB allocator relies on struct page fields first_page and slab,
overwritten by ptl when SPLIT_PTLOCK: so the SLUB allocator cannot then
be used for the lowest level of pagetable pages.  This was obstructing
SLUB on PowerPC, which uses kmem_caches for its pagetables.  So convert
its pte level to use normal gfp pages (whereas pmd, pud and 64k-page pgd
want partpages, so continue to use kmem_caches for pmd, pud and pgd).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This version uses __GFP_ZERO instead of clear_page() and re-enables
SLUB on powerpc.

Index: linux-cell/arch/powerpc/mm/init_64.c
===================================================================
--- linux-cell.orig/arch/powerpc/mm/init_64.c	2007-05-08 16:47:48.000000000 +1000
+++ linux-cell/arch/powerpc/mm/init_64.c	2007-05-09 12:15:22.000000000 +1000
@@ -146,21 +146,16 @@ static void zero_ctor(void *addr, struct
 	memset(addr, 0, kmem_cache_size(cache));
 }
 
-#ifdef CONFIG_PPC_64K_PAGES
-static const unsigned int pgtable_cache_size[3] = {
-	PTE_TABLE_SIZE, PMD_TABLE_SIZE, PGD_TABLE_SIZE
-};
-static const char *pgtable_cache_name[ARRAY_SIZE(pgtable_cache_size)] = {
-	"pte_pmd_cache", "pmd_cache", "pgd_cache",
-};
-#else
 static const unsigned int pgtable_cache_size[2] = {
-	PTE_TABLE_SIZE, PMD_TABLE_SIZE
+	PGD_TABLE_SIZE, PMD_TABLE_SIZE
 };
 static const char *pgtable_cache_name[ARRAY_SIZE(pgtable_cache_size)] = {
-	"pgd_pte_cache", "pud_pmd_cache",
-};
+#ifdef CONFIG_PPC_64K_PAGES
+	"pgd_cache", "pmd_cache",
+#else
+	"pgd_cache", "pud_pmd_cache",
 #endif /* CONFIG_PPC_64K_PAGES */
+};
 
 #ifdef CONFIG_HUGETLB_PAGE
 /* Hugepages need one extra cache, initialized in hugetlbpage.c.  We
Index: linux-cell/include/asm-powerpc/pgalloc.h
===================================================================
--- linux-cell.orig/include/asm-powerpc/pgalloc.h	2007-05-08 16:47:48.000000000 +1000
+++ linux-cell/include/asm-powerpc/pgalloc.h	2007-05-09 12:17:11.000000000 +1000
@@ -13,18 +13,11 @@
 
 extern struct kmem_cache *pgtable_cache[];
 
-#ifdef CONFIG_PPC_64K_PAGES
-#define PTE_CACHE_NUM	0
-#define PMD_CACHE_NUM	1
-#define PGD_CACHE_NUM	2
-#define HUGEPTE_CACHE_NUM 3
-#else
-#define PTE_CACHE_NUM	0
-#define PMD_CACHE_NUM	1
-#define PUD_CACHE_NUM	1
-#define PGD_CACHE_NUM	0
-#define HUGEPTE_CACHE_NUM 2
-#endif
+#define PGD_CACHE_NUM		0
+#define PUD_CACHE_NUM		1
+#define PMD_CACHE_NUM		1
+#define HUGEPTE_CACHE_NUM	2
+#define PTE_NONCACHE_NUM	3  /* from GFP rather than kmem_cache */
 
 /*
  * This program is free software; you can redistribute it and/or
@@ -97,8 +90,7 @@ static inline void pmd_free(pmd_t *pmd)
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	return kmem_cache_alloc(pgtable_cache[PTE_CACHE_NUM],
-				GFP_KERNEL|__GFP_REPEAT);
+        return (pte_t *)__get_free_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
 }
 
 static inline struct page *pte_alloc_one(struct mm_struct *mm,
@@ -109,12 +101,12 @@ static inline struct page *pte_alloc_one
 		
 static inline void pte_free_kernel(pte_t *pte)
 {
-	kmem_cache_free(pgtable_cache[PTE_CACHE_NUM], pte);
+	free_page((unsigned long)pte);
 }
 
 static inline void pte_free(struct page *ptepage)
 {
-	pte_free_kernel(page_address(ptepage));
+	__free_page(ptepage);
 }
 
 #define PGF_CACHENUM_MASK	0x3
@@ -136,14 +128,17 @@ static inline void pgtable_free(pgtable_
 	void *p = (void *)(pgf.val & ~PGF_CACHENUM_MASK);
 	int cachenum = pgf.val & PGF_CACHENUM_MASK;
 
-	kmem_cache_free(pgtable_cache[cachenum], p);
+	if (cachenum == PTE_NONCACHE_NUM)
+		free_page((unsigned long)p);
+	else
+		kmem_cache_free(pgtable_cache[cachenum], p);
 }
 
 extern void pgtable_free_tlb(struct mmu_gather *tlb, pgtable_free_t pgf);
 
 #define __pte_free_tlb(tlb, ptepage)	\
 	pgtable_free_tlb(tlb, pgtable_free_cache(page_address(ptepage), \
-		PTE_CACHE_NUM, PTE_TABLE_SIZE-1))
+		PTE_NONCACHE_NUM, PTE_TABLE_SIZE-1))
 #define __pmd_free_tlb(tlb, pmd) 	\
 	pgtable_free_tlb(tlb, pgtable_free_cache(pmd, \
 		PMD_CACHE_NUM, PMD_TABLE_SIZE-1))
Index: linux-cell/arch/powerpc/Kconfig
===================================================================
--- linux-cell.orig/arch/powerpc/Kconfig	2007-05-09 12:17:50.000000000 +1000
+++ linux-cell/arch/powerpc/Kconfig	2007-05-09 12:18:02.000000000 +1000
@@ -117,19 +117,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-#
-# Powerpc uses the slab allocator to manage its ptes and the
-# page structs of ptes are used for splitting the page table
-# lock for configurations supporting more than SPLIT_PTLOCK_CPUS.
-#
-# In that special configuration the page structs of slabs are modified.
-# This setting disables the selection of SLUB as a slab allocator.
-#
-config ARCH_USES_SLAB_PAGE_STRUCT
-	bool
-	default y
-	depends on SPLIT_PTLOCK_CPUS <= NR_CPUS
-
 config DEFAULT_UIMAGE
 	bool
 	help
     A. 
