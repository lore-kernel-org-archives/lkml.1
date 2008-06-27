Return-Path: <linux-kernel-owner+w=401wt.eu-S1760595AbYF0P7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760595AbYF0P7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYF0P6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:58:10 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:43671 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbYF0P6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:58:08 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 5/6] avr32: Use a quicklist for PGD allocation
Date: Fri, 27 Jun 2008 17:57:55 +0200
Message-Id: <1214582276-10889-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214582276-10889-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214582276-10889-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214582276-10889-4-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 27 Jun 2008 15:57:42.0263 (UTC) FILETIME=[882BC070:01C8D86E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a quicklist to allocate process PGDs. This is expected to be
slightly faster since we need to copy entries from swapper_pg_dir,
which can stay around for pages on the PGD quick list.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/Kconfig          |    3 +++
 include/asm-avr32/pgalloc.h |   32 ++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 09ad799..a5793c1 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -147,6 +147,9 @@ config PHYS_OFFSET
 
 source "kernel/Kconfig.preempt"
 
+config QUICKLIST
+	def_bool y
+
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool n
 
diff --git a/include/asm-avr32/pgalloc.h b/include/asm-avr32/pgalloc.h
index e9636d1..a291f59 100644
--- a/include/asm-avr32/pgalloc.h
+++ b/include/asm-avr32/pgalloc.h
@@ -8,7 +8,11 @@
 #ifndef __ASM_AVR32_PGALLOC_H
 #define __ASM_AVR32_PGALLOC_H
 
-#include <linux/mm.h>
+#include <linux/quicklist.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#define QUICK_PGD	0	/* Preserve kernel mappings over free */
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
 				       pmd_t *pmd, pte_t *pte)
@@ -23,25 +27,26 @@ static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
 }
 #define pmd_pgtable(pmd) pmd_page(pmd)
 
+static inline void pgd_ctor(void *x)
+{
+	pgd_t *pgd = x;
+
+	memcpy(pgd + USER_PTRS_PER_PGD,
+		swapper_pg_dir + USER_PTRS_PER_PGD,
+		(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
+}
+
 /*
  * Allocate and free page tables
  */
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd;
-
-	pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL | __GFP_REPEAT);
-	if (likely(pgd))
-		memcpy(pgd + USER_PTRS_PER_PGD,
-			swapper_pg_dir + USER_PTRS_PER_PGD,
-			(PTRS_PER_PGD - USER_PTRS_PER_PGD) * sizeof(pgd_t));
-
-	return pgd;
+	return quicklist_alloc(QUICK_PGD, GFP_KERNEL | __GFP_REPEAT, pgd_ctor);
 }
 
 static inline void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
-	free_page((unsigned long)pgd);
+	quicklist_free(QUICK_PGD, NULL, pgd);
 }
 
 static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm,
@@ -83,6 +88,9 @@ do {							\
 	tlb_remove_page((tlb), pte);			\
 } while (0)
 
-#define check_pgt_cache() do { } while(0)
+static inline void check_pgt_cache(void)
+{
+	quicklist_trim(QUICK_PGD, NULL, 25, 16);
+}
 
 #endif /* __ASM_AVR32_PGALLOC_H */
-- 
1.5.5.4

