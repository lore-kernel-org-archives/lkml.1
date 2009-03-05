Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbZCENJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbZCENJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZCENIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:40 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39609 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZCENIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:38 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/17] x86: move pgd_base out of init_memory_mapping()
Date: Thu,  5 Mar 2009 14:54:55 +0200
Message-Id: <1236257708-27269-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

This patch moves pgd_base out of init_memory_mapping() to reduce the diff
between the 32-bit version and the 64-bit version of the function.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 86a9994..cfc68d6 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -227,11 +227,11 @@ static inline int is_kernel_text(unsigned long addr)
  * of max_low_pfn pages, by creating page tables starting from address
  * PAGE_OFFSET:
  */
-static void __init kernel_physical_mapping_init(pgd_t *pgd_base,
-						unsigned long start_pfn,
+static void __init kernel_physical_mapping_init(unsigned long start_pfn,
 						unsigned long end_pfn,
 						int use_pse)
 {
+	pgd_t *pgd_base = swapper_pg_dir;
 	int pgd_idx, pmd_idx, pte_ofs;
 	unsigned long pfn;
 	pgd_t *pgd;
@@ -509,8 +509,9 @@ void __init native_pagetable_setup_done(pgd_t *base)
  * be partially populated, and so it avoids stomping on any existing
  * mappings.
  */
-static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
+static void __init early_ioremap_page_table_range_init(void)
 {
+	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long vaddr, end;
 
 	/*
@@ -925,7 +926,6 @@ static int save_mr(struct map_range *mr, int nr_range,
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 	unsigned long pos;
@@ -1040,12 +1040,12 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
-		kernel_physical_mapping_init(pgd_base,
+		kernel_physical_mapping_init(
 				mr[i].start >> PAGE_SHIFT,
 				mr[i].end >> PAGE_SHIFT,
 				mr[i].page_size_mask == (1<<PG_LEVEL_2M));
 
-	early_ioremap_page_table_range_init(pgd_base);
+	early_ioremap_page_table_range_init();
 
 	load_cr3(swapper_pg_dir);
 
-- 
1.5.4.3

