Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZCENHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZCENHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbZCENGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:06:39 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:37717 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZCENGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:06:37 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/17] x86: add gbpages support to 32-bit init_memory_mapping()
Date: Thu,  5 Mar 2009 14:54:53 +0200
Message-Id: <1236257708-27269-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

To reduce the diff between the 32-bit and 64-bit versions of
init_memory_mapping(), add gbpages support to the 32-bit version.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ad4e03c..5fad0f9 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -65,6 +65,8 @@ static unsigned long __meminitdata table_top;
 
 static int __initdata after_init_bootmem;
 
+int direct_gbpages;
+
 static __init void *alloc_low_page(void)
 {
 	unsigned long pfn = table_end++;
@@ -831,14 +833,22 @@ void __init setup_bootmem_allocator(void)
 	after_init_bootmem = 1;
 }
 
-static void __init find_early_table_space(unsigned long end, int use_pse)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 
-	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+	if (use_gbpages) {
+		unsigned long extra;
+
+		extra = end - ((end>>PUD_SHIFT) << PUD_SHIFT);
+		pmds = (extra + PMD_SIZE - 1) >> PMD_SHIFT;
+	} else
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 
 	if (use_pse) {
@@ -913,7 +923,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-	int use_pse;
+	int use_pse, use_gbpages;
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
@@ -923,9 +933,10 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * This will simplify cpa(), which otherwise needs to support splitting
 	 * large pages into small in interrupt context, etc.
 	 */
-	use_pse = 0;
+	use_pse = use_gbpages = 0;
 #else
 	use_pse = cpu_has_pse;
+	use_gbpages = direct_gbpages;
 #endif
 
 #ifdef CONFIG_X86_PAE
@@ -944,6 +955,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 		__supported_pte_mask |= _PAGE_GLOBAL;
 	}
 
+	if (use_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (use_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
@@ -1015,7 +1028,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_init_bootmem)
-		find_early_table_space(end, use_pse);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		kernel_physical_mapping_init(pgd_base,
-- 
1.5.4.3

