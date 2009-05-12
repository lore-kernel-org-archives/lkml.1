Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZELDza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZELDza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 23:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZELDzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 23:55:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:42979 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZELDzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 23:55:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,179,1241420400"; 
   d="scan'208";a="141727521"
Subject: [PATCH]X86: make sparse mem work in non-NUMA mode
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Yang, Sheng" <sheng.yang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 11:55:17 +0800
Message-Id: <1242100517.10593.7.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With sparse, memory holes should not be marked present for memmap.
This patch makes sparse really works on non-NUMA mode.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Sheng Yang <sheng.yang@intel.com>

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..bc95c7a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -761,15 +761,15 @@ void __init initmem_init(unsigned long start_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memory_present(0, 0, highend_pfn);
 	e820_register_active_regions(0, 0, highend_pfn);
+	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memory_present(0, 0, max_low_pfn);
 	e820_register_active_regions(0, 0, max_low_pfn);
+	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..dcf099c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -638,7 +638,7 @@ void __init paging_init(void)
 	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 
-	memory_present(0, 0, max_pfn);
+	sparse_memory_present_with_active_regions(0);
 	sparse_init();
 	free_area_init_nodes(max_zone_pfns);
 }


