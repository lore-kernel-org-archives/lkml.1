Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZDNDNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZDNDNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZDNDMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:12:50 -0400
Received: from sh.osrg.net ([192.16.179.4]:44010 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809AbZDNDMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:12:49 -0400
Date: Tue, 14 Apr 2009 12:12:29 +0900
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: muli@il.ibm.com, alexisb@us.ibm.com
Subject: [PATCH] calgary: remove IOMMU_DEBUG
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Apr 2009 12:12:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_IOMMU_DEBUG has depends on CONFIG_GART_IOMMU:

config IOMMU_DEBUG
	bool "Enable IOMMU debugging"
	depends on GART_IOMMU && DEBUG_KERNEL
	depends on X86_64

So it's not useful to have CONFIG_IOMMU_DEBUG in Calgary IOMMU code,
which does the extra checking of the bitmap space management.

And Calgary uses the iommu helper for the bitmap space management now
so it would be better to have the extra checking feature in the iommu
helper rather than Calgary code (if necessary).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-calgary_64.c |   54 +------------------------------------
 1 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 755c21e..971a3be 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -186,37 +186,6 @@ static struct cal_chipset_ops calioc2_chip_ops = {
 
 static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
-/* enable this to stress test the chip's TCE cache */
-#ifdef CONFIG_IOMMU_DEBUG
-static int debugging = 1;
-
-static inline unsigned long verify_bit_range(unsigned long* bitmap,
-	int expected, unsigned long start, unsigned long end)
-{
-	unsigned long idx = start;
-
-	BUG_ON(start >= end);
-
-	while (idx < end) {
-		if (!!test_bit(idx, bitmap) != expected)
-			return idx;
-		++idx;
-	}
-
-	/* all bits have the expected value */
-	return ~0UL;
-}
-#else /* debugging is disabled */
-static int debugging;
-
-static inline unsigned long verify_bit_range(unsigned long* bitmap,
-	int expected, unsigned long start, unsigned long end)
-{
-	return ~0UL;
-}
-
-#endif /* CONFIG_IOMMU_DEBUG */
-
 static inline int translation_enabled(struct iommu_table *tbl)
 {
 	/* only PHBs with translation enabled have an IOMMU table */
@@ -228,7 +197,6 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 {
 	unsigned long index;
 	unsigned long end;
-	unsigned long badbit;
 	unsigned long flags;
 
 	index = start_addr >> PAGE_SHIFT;
@@ -243,14 +211,6 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	badbit = verify_bit_range(tbl->it_map, 0, index, end);
-	if (badbit != ~0UL) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "Calgary: entry already allocated at "
-			       "0x%lx tbl %p dma 0x%lx npages %u\n",
-			       badbit, tbl, start_addr, npages);
-	}
-
 	iommu_area_reserve(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -326,7 +286,6 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
 	unsigned long entry;
-	unsigned long badbit;
 	unsigned long badend;
 	unsigned long flags;
 
@@ -346,14 +305,6 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	badbit = verify_bit_range(tbl->it_map, 1, entry, entry + npages);
-	if (badbit != ~0UL) {
-		if (printk_ratelimit())
-			printk(KERN_ERR "Calgary: bit is off at 0x%lx "
-			       "tbl %p dma 0x%Lx entry 0x%lx npages %u\n",
-			       badbit, tbl, dma_addr, entry, npages);
-	}
-
 	iommu_area_free(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
@@ -1488,9 +1439,8 @@ void __init detect_calgary(void)
 		iommu_detected = 1;
 		calgary_detected = 1;
 		printk(KERN_INFO "PCI-DMA: Calgary IOMMU detected.\n");
-		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d, "
-		       "CONFIG_IOMMU_DEBUG is %s.\n", specified_table_size,
-		       debugging ? "enabled" : "disabled");
+		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d\n",
+		       specified_table_size);
 
 		/* swiotlb for devices that aren't behind the Calgary. */
 		if (max_pfn > MAX_DMA32_PFN)
-- 
1.6.0.6

