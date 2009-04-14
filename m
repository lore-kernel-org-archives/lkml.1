Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZDNApK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZDNApK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZDNAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:44:56 -0400
Received: from sh.osrg.net ([192.16.179.4]:49851 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZDNAo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:44:56 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/2] gart: reimplement IOMMU_LEAK feature by using DMA_API_DEBUG
Date: Tue, 14 Apr 2009 09:43:19 +0900
Message-Id: <1239669799-23579-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Apr 2009 09:44:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU_LEAK, GART's own feature, dumps the used IOMMU entries when
IOMMU entries is full, which might be useful to find a bad driver that
eats IOMMU entries.

DMA_API_DEBUG provides the similar feature, debug_dma_dump_mappings,
and it's better than GART's IOMMU_LEAK feature. GART's IOMMU_LEAK
feature doesn't say who uses IOMMU entries so it's hard to find a bad
driver.

This patch reimplements the GART's IOMMU_LEAK feature by using
DMA_API_DEBUG.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/Kconfig.debug        |    3 +-
 arch/x86/kernel/pci-gart_64.c |   45 +++++++---------------------------------
 2 files changed, 9 insertions(+), 39 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index d8359e7..5865712 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -161,8 +161,7 @@ config IOMMU_DEBUG
 
 config IOMMU_LEAK
 	bool "IOMMU leak tracing"
-	depends on DEBUG_KERNEL
-	depends on IOMMU_DEBUG
+	depends on IOMMU_DEBUG && DMA_API_DEBUG
 	---help---
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index b284b58..1e8920d 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -144,48 +144,21 @@ static void flush_gart(void)
 }
 
 #ifdef CONFIG_IOMMU_LEAK
-
-#define SET_LEAK(x)							\
-	do {								\
-		if (iommu_leak_tab)					\
-			iommu_leak_tab[x] = __builtin_return_address(0);\
-	} while (0)
-
-#define CLEAR_LEAK(x)							\
-	do {								\
-		if (iommu_leak_tab)					\
-			iommu_leak_tab[x] = NULL;			\
-	} while (0)
-
 /* Debugging aid for drivers that don't free their IOMMU tables */
-static void **iommu_leak_tab;
 static int leak_trace;
 static int iommu_leak_pages = 20;
 
 static void dump_leak(void)
 {
-	int i;
 	static int dump;
 
-	if (dump || !iommu_leak_tab)
+	if (dump)
 		return;
 	dump = 1;
-	show_stack(NULL, NULL);
 
-	/* Very crude. dump some from the end of the table too */
-	printk(KERN_DEBUG "Dumping %d pages from end of IOMMU:\n",
-	       iommu_leak_pages);
-	for (i = 0; i < iommu_leak_pages; i += 2) {
-		printk(KERN_DEBUG "%lu: ", iommu_pages-i);
-		printk_address((unsigned long) iommu_leak_tab[iommu_pages-i],
-				0);
-		printk(KERN_CONT "%c", (i+1)%2 == 0 ? '\n' : ' ');
-	}
-	printk(KERN_DEBUG "\n");
+	show_stack(NULL, NULL);
+	debug_dma_dump_mappings(NULL);
 }
-#else
-# define SET_LEAK(x)
-# define CLEAR_LEAK(x)
 #endif
 
 static void iommu_full(struct device *dev, size_t size, int dir)
@@ -248,7 +221,6 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = GPTE_ENCODE(phys_mem);
-		SET_LEAK(iommu_page + i);
 		phys_mem += PAGE_SIZE;
 	}
 	return iommu_bus_base + iommu_page*PAGE_SIZE + (phys_mem & ~PAGE_MASK);
@@ -294,7 +266,6 @@ static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
 	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
-		CLEAR_LEAK(iommu_page + i);
 	}
 	free_iommu(iommu_page, npages);
 }
@@ -377,7 +348,6 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
-			SET_LEAK(iommu_page);
 			addr += PAGE_SIZE;
 			iommu_page++;
 		}
@@ -801,11 +771,12 @@ void __init gart_iommu_init(void)
 
 #ifdef CONFIG_IOMMU_LEAK
 	if (leak_trace) {
-		iommu_leak_tab = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
-				  get_order(iommu_pages*sizeof(void *)));
-		if (!iommu_leak_tab)
+		int ret;
+
+		ret = dma_debug_resize_entries(iommu_pages);
+		if (ret)
 			printk(KERN_DEBUG
-			       "PCI-DMA: Cannot allocate leak trace area\n");
+			       "PCI-DMA: Cannot trace all the entries\n");
 	}
 #endif
 
-- 
1.6.0.6

