Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYIWVXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYIWVXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYIWVVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:21:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:37400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbYIWVVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,295,1220252400"; 
   d="scan'208";a="50419299"
Message-Id: <20080923211444.512868000@linux-os.sc.intel.com>
References: <20080923210035.413932000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Sep 2008 14:00:39 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/7] x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
Content-Disposition: inline; filename=no_lp_identity_mapping_debug_pgalloc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use large pages for kernel identity mapping with DEBUG_PAGEALLOC.
This will remove the need to split the large page for the
allocated kernel page in the interrupt context.

This will simplify cpa code(as we don't do the split any more from the
interrupt context). cpa code simplication in the subsequent patches.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/init_32.c
===================================================================
--- tip.orig/arch/x86/mm/init_32.c	2008-09-22 15:59:37.000000000 -0700
+++ tip/arch/x86/mm/init_32.c	2008-09-22 15:59:39.000000000 -0700
@@ -775,7 +775,7 @@
 	after_init_bootmem = 1;
 }
 
-static void __init find_early_table_space(unsigned long end)
+static void __init find_early_table_space(unsigned long end, int use_pse)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
@@ -785,7 +785,7 @@
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
 
-	if (cpu_has_pse) {
+	if (use_pse) {
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
@@ -825,12 +825,22 @@
 	pgd_t *pgd_base = swapper_pg_dir;
 	unsigned long start_pfn, end_pfn;
 	unsigned long big_page_start;
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	int use_pse = 0;
+#else
+	int use_pse = cpu_has_pse;
+#endif
 
 	/*
 	 * Find space for the kernel direct mapping tables.
 	 */
 	if (!after_init_bootmem)
-		find_early_table_space(end);
+		find_early_table_space(end, use_pse);
 
 #ifdef CONFIG_X86_PAE
 	set_nx();
@@ -876,7 +886,7 @@
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
 	if (start_pfn < end_pfn)
 		kernel_physical_mapping_init(pgd_base, start_pfn, end_pfn,
-						cpu_has_pse);
+					     use_pse);
 
 	/* tail is not big page alignment ? */
 	start_pfn = end_pfn;
Index: tip/arch/x86/mm/init_64.c
===================================================================
--- tip.orig/arch/x86/mm/init_64.c	2008-09-22 15:59:37.000000000 -0700
+++ tip/arch/x86/mm/init_64.c	2008-09-22 15:59:39.000000000 -0700
@@ -509,13 +509,14 @@
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-static void __init find_early_table_space(unsigned long end)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
-	if (direct_gbpages) {
+	if (use_gbpages) {
 		unsigned long extra;
 		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
 		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
@@ -523,7 +524,7 @@
 		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
-	if (cpu_has_pse) {
+	if (use_pse) {
 		unsigned long extra;
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -693,6 +694,7 @@
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
+	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping\n");
 
@@ -706,9 +708,21 @@
 	if (!after_bootmem)
 		init_gbpages();
 
-	if (direct_gbpages)
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
+	 * This will simplify cpa(), which otherwise needs to support splitting
+	 * large pages into small in interrupt context, etc.
+	 */
+	use_pse = use_gbpages = 0;
+#else
+	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
+#endif
+
+	if (use_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
-	if (cpu_has_pse)
+	if (use_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
 	memset(mr, 0, sizeof(mr));
@@ -769,7 +783,7 @@
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
 	if (!after_bootmem)
-		find_early_table_space(end);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		last_map_addr = kernel_physical_mapping_init(

-- 

