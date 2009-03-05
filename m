Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZCENNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZCENNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZCENIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:49 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39716 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbZCENIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:39 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/17] x86: unify kernel_physical_mapping_init() function signatures
Date: Thu,  5 Mar 2009 14:55:07 +0200
Message-Id: <1236257708-27269-16-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

In preparation for moving the function declaration to a header file, unify
32-bit and 64-bit signatures.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c    |   13 +++----------
 arch/x86/mm/init_32.c |   13 ++++++++++---
 arch/x86/mm/init_64.c |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5bbdfe7..6475693 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -11,17 +11,12 @@
 
 #ifdef CONFIG_X86_32
 extern void __init early_ioremap_page_table_range_init(void);
-extern void __init kernel_physical_mapping_init(unsigned long start_pfn,
-						unsigned long end_pfn,
-						int use_pse);
 #endif
 
-#ifdef CONFIG_X86_64
-extern unsigned long __meminit
+extern unsigned long __init
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask);
-#endif
 
 unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
@@ -301,10 +296,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 #ifdef CONFIG_X86_32
 	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(
-				mr[i].start >> PAGE_SHIFT,
-				mr[i].end >> PAGE_SHIFT,
-				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
+		kernel_physical_mapping_init(mr[i].start, mr[i].end,
+					     mr[i].page_size_mask);
 	ret = end;
 #else /* CONFIG_X86_64 */
 	for (i = 0; i < nr_range; i++)
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index e9df0d9..5ca9c6c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -223,10 +223,13 @@ static inline int is_kernel_text(unsigned long addr)
  * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET:
  */
-void __init kernel_physical_mapping_init(unsigned long start_pfn,
-					 unsigned long end_pfn,
-					 int use_pse)
+unsigned long __init
+kernel_physical_mapping_init(unsigned long start,
+			     unsigned long end,
+			     unsigned long page_size_mask)
 {
+	int use_pse = page_size_mask == (1<<PG_LEVEL_2M);
+	unsigned long start_pfn, end_pfn;
 	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
 	unsigned long pfn;
@@ -236,6 +239,9 @@ void __init kernel_physical_mapping_init(unsigned long start_pfn,
 	unsigned pages_2m, pages_4k;
 	int mapping_iter;
 
+	start_pfn = start >> PAGE_SHIFT;
+	end_pfn = end >> PAGE_SHIFT;
+
 	/*
 	 * First iteration will setup identity mapping using large/small pages
 	 * based on use_pse, with other attributes same as set by
@@ -350,6 +356,7 @@ repeat:
 		mapping_iter = 2;
 		goto repeat;
 	}
+	return 0;
 }
 
 pte_t *kmap_pte;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a1d33c5..f441ae3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -539,7 +539,7 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-unsigned long __meminit
+unsigned long __init
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
-- 
1.5.4.3

