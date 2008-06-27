Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYF0P6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYF0P6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYF0P5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:57:54 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43666 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYF0P5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:57:53 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 6/6] avr32: Use a quicklist for PTE allocation as well
Date: Fri, 27 Jun 2008 17:57:56 +0200
Message-Id: <1214582276-10889-6-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214582276-10889-5-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-5-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0341 (UTC) FILETIME=[8837A750:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a quicklist to allocate PTEs might be slightly faster than using
the page allocator directly since we might avoid zeroing the page
after each allocation.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 include/asm-avr32/pgalloc.h |   28 +++++++++++++++-------------
 mm/Kconfig                  |    2 +-
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/asm-avr32/pgalloc.h b/include/asm-avr32/pgalloc.h
index a291f59..6408213 100644
--- a/include/asm-avr32/pgalloc.h
+++ b/include/asm-avr32/pgalloc.h
@@ -13,6 +13,7 @@
 #include <asm/pgtable.h>
 
 #define QUICK_PGD	0	/* Preserve kernel mappings over free */
+#define QUICK_PT	1	/* Zero on free */
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)
@@ -52,34 +53,34 @@ static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
 					  unsigned long address)
 {
-	pte_t *pte;
-
-	pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
-
-	return pte;
+	return quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
 }
 
-static inline struct page *pte_alloc_one(struct mm_struct *mm,
+static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 					 unsigned long address)
 {
-	struct page *pte;
+	struct page *page;
+	void *pg;
 
-	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
-	if (!pte)
+	pg = quicklist_alloc(QUICK_PT, GFP_KERNEL | __GFP_REPEAT, NULL);
+	if (!pg)
 		return NULL;
-	pgtable_page_ctor(pte);
-	return pte;
+
+	page = virt_to_page(pg);
+	pgtable_page_ctor(page);
+
+	return page;
 }
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	free_page((unsigned long)pte);
+	quicklist_free(QUICK_PT, NULL, pte);
 }
 
 static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	pgtable_page_dtor(pte);
-	__free_page(pte);
+	quicklist_free_page(QUICK_PT, NULL, pte);
 }
 
 #define __pte_free_tlb(tlb,pte)				\
@@ -91,6 +92,7 @@ do {							\
 static inline void check_pgt_cache(void)
 {
 	quicklist_trim(QUICK_PGD, NULL, 25, 16);
+	quicklist_trim(QUICK_PT, NULL, 25, 16);
 }
 
 #endif /* __ASM_AVR32_PGALLOC_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 3aa819d..60b2619 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -199,7 +199,7 @@ config BOUNCE
 config NR_QUICK
 	int
 	depends on QUICKLIST
-	default "2" if SUPERH
+	default "2" if SUPERH || AVR32
 	default "1"
 
 config VIRT_TO_BUS
-- 
1.5.5.4

