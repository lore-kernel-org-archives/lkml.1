Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZDNLIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZDNLIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZDNLID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:08:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:44950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbZDNLIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:08:00 -0400
Date: Tue, 14 Apr 2009 11:06:35 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de,
       muli@il.ibm.com, mingo@elte.hu
In-Reply-To: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
References: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
Subject: [tip:core/iommu] x86: calgary: remove IOMMU_DEBUG
Message-ID: <tip-7e05575c422d45f393c2d9b5900e97a30bf69bea@git.kernel.org>
Git-Commit-ID: 7e05575c422d45f393c2d9b5900e97a30bf69bea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 11:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e05575c422d45f393c2d9b5900e97a30bf69bea
Gitweb:     http://git.kernel.org/tip/7e05575c422d45f393c2d9b5900e97a30bf69bea
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Tue, 14 Apr 2009 12:12:29 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 13:03:36 +0200

x86: calgary: remove IOMMU_DEBUG

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
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: alexisb@us.ibm.com
LKML-Reference: <20090414120827G.fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
