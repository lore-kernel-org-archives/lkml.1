Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXFSWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXFSWT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXFSWS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:21824 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXFSWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="241009863"
Message-Id: <20070619213808.558492000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:04 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [Intel IOMMU 03/10] clflush_cache_range now takes size param
Content-Disposition: inline; filename=clflush_cache_range.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Introduce the size param for clflush_cache_range().

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 arch/x86_64/mm/pageattr.c       |    6 +++---
 include/asm-x86_64/cacheflush.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4-mm2/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/mm/pageattr.c	2007-06-18 15:45:39.000000000 -0700
+++ linux-2.6.22-rc4-mm2/arch/x86_64/mm/pageattr.c	2007-06-18 15:45:46.000000000 -0700
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
+			clflush_cache_range(adr, PAGE_SIZE);
 	}
 	__flush_tlb_all();
 }
Index: linux-2.6.22-rc4-mm2/include/asm-x86_64/cacheflush.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/asm-x86_64/cacheflush.h	2007-06-18 15:45:39.000000000 -0700
+++ linux-2.6.22-rc4-mm2/include/asm-x86_64/cacheflush.h	2007-06-18 15:45:46.000000000 -0700
@@ -27,6 +27,7 @@
 void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);

-- 
