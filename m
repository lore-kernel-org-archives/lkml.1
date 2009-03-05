Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZCENHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZCENHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZCENGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:06:39 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:37759 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbZCENGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:06:37 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/17] x86: find_early_table_space() unification
Date: Thu,  5 Mar 2009 14:54:54 +0200
Message-Id: <1236257708-27269-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

There are some minor differences between the 32-bit and 64-bit
find_early_table_space() functions. This patch wraps those differences under
CONFIG_X86_32 to make the function identical on both configurations.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    9 +++++++++
 arch/x86/mm/init_64.c |   14 ++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5fad0f9..86a9994 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -855,24 +855,33 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
+#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
+#ifdef CONFIG_X86_32
 	/* for fixmap */
 	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables
 	 * need roughly 0.5KB per GB.
 	 */
+#ifdef CONFIG_X86_32
 	start = 0x7000;
 	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
 					tables, PAGE_SIZE);
+#else /* CONFIG_X86_64 */
+	start = 0x8000;
+	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+#endif
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index cdb3be1..151e5ba 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -569,19 +569,33 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 		unsigned long extra;
 
 		extra = end - ((end>>PMD_SHIFT) << PMD_SHIFT);
+#ifdef CONFIG_X86_32
+		extra += PMD_SIZE;
+#endif
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
 
+#ifdef CONFIG_X86_32
+	/* for fixmap */
+	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
+#endif
+
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables
 	 * need roughly 0.5KB per GB.
 	 */
+#ifdef CONFIG_X86_32
+	start = 0x7000;
+	table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+					tables, PAGE_SIZE);
+#else /* CONFIG_X86_64 */
 	start = 0x8000;
 	table_start = find_e820_area(start, end, tables, PAGE_SIZE);
+#endif
 	if (table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
-- 
1.5.4.3

