Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXFDWby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXFDWby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759015AbXFDWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:30:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:60576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698AbXFDWaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:30:46 -0400
X-ExtLoopCount2: 2 from 172.25.110.8
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="93439502"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="235457428"
Message-Id: <20070604210644.316205000@askeshav-devel.jf.intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jun 2007 14:02:46 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 04/10] clflush_cache_range now takes size param
Content-Disposition: inline; filename=clflush_cache_range.patch
X-OriginalArrivalTime: 04 Jun 2007 21:23:57.0977 (UTC) FILETIME=[A983E890:01C7A6EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Introduce the size param for clflush_cache_range().

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 arch/x86_64/mm/pageattr.c       |    6 +++---
 include/asm-x86_64/cacheflush.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc3/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/mm/pageattr.c	2007-06-04 12:27:33.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/mm/pageattr.c	2007-06-04 12:37:30.000000000 -0700
@@ -61,10 +61,10 @@
 	return base;
 } 
 
-static void cache_flush_page(void *adr)
+void clflush_cache_range(void *adr, int size)
 {
 	int i;
-	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
 		asm volatile("clflush (%0)" :: "r" (adr + i));
 }
 
@@ -80,7 +80,7 @@
 	list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		if (cpu_has_clflush)
-			cache_flush_page(adr);
+ 			clflush_cache_range(adr, PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
Index: linux-2.6.22-rc3/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6.22-rc3.orig/include/asm-x86_64/cacheflush.h	2007-06-04 12:27:33.000000000 -0700
+++ linux-2.6.22-rc3/include/asm-x86_64/cacheflush.h	2007-06-04 12:37:30.000000000 -0700
@@ -27,6 +27,7 @@
 void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);

-- 
