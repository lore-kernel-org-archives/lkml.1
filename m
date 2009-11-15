Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZKOMXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZKOMXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZKOMXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:23:03 -0500
Received: from sh.osrg.net ([192.16.179.4]:46549 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbZKOMXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:23:01 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       joerg.roedel@amd.com
Subject: [PATCH 2/3] x86: kill bad_dma_address variable
Date: Sun, 15 Nov 2009 21:19:53 +0900
Message-Id: <1258287594-8777-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1258287594-8777-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258287594-8777-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 15 Nov 2009 21:22:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kills bad_dma_address variable, the old mechanism to enable IOMMU
drivers to make dma_mapping_error() work in IOMMU's specific way.

bad_dma_address variable was introduced to enable IOMMU drivers to
make dma_mapping_error() work in IOMMU's specific way. However, it
can't handle systems that use both swiotlb and HW IOMMU. SO we
introduced dma_map_ops->mapping_error to solve that case.

Intel VT-d, GART, and swiotlb already use
dma_map_ops->mapping_error. Calgary, AMD IOMMU, and nommu use zero for
an error dma address. This adds DMA_ERROR_CODE and converts them to
use it (as SPARC and POWER does).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/dma-mapping.h |    5 +++--
 arch/x86/kernel/amd_iommu.c        |   21 ++++++++++-----------
 arch/x86/kernel/pci-calgary_64.c   |   22 ++++++++++------------
 arch/x86/kernel/pci-dma.c          |    3 ---
 arch/x86/kernel/pci-nommu.c        |    2 +-
 5 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 6a25d5d..0f6c02f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -20,7 +20,8 @@
 # define ISA_DMA_BIT_MASK DMA_BIT_MASK(32)
 #endif
 
-extern dma_addr_t bad_dma_address;
+#define DMA_ERROR_CODE	0
+
 extern int iommu_merge;
 extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
@@ -48,7 +49,7 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	if (ops->mapping_error)
 		return ops->mapping_error(dev, dma_addr);
 
-	return (dma_addr == bad_dma_address);
+	return (dma_addr == DMA_ERROR_CODE);
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 66237fd..093bd52 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -928,7 +928,7 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 	}
 
 	if (unlikely(address == -1))
-		address = bad_dma_address;
+		address = DMA_ERROR_CODE;
 
 	WARN_ON((address + (PAGE_SIZE*pages)) > dom->aperture_size);
 
@@ -1544,7 +1544,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 
 	pte  = dma_ops_get_pte(dom, address);
 	if (!pte)
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
@@ -1625,7 +1625,7 @@ static dma_addr_t __map_single(struct device *dev,
 retry:
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask,
 					  dma_mask);
-	if (unlikely(address == bad_dma_address)) {
+	if (unlikely(address == DMA_ERROR_CODE)) {
 		/*
 		 * setting next_address here will let the address
 		 * allocator only scan the new allocated range in the
@@ -1646,7 +1646,7 @@ retry:
 	start = address;
 	for (i = 0; i < pages; ++i) {
 		ret = dma_ops_domain_map(iommu, dma_dom, start, paddr, dir);
-		if (ret == bad_dma_address)
+		if (ret == DMA_ERROR_CODE)
 			goto out_unmap;
 
 		paddr += PAGE_SIZE;
@@ -1674,7 +1674,7 @@ out_unmap:
 
 	dma_ops_free_addresses(dma_dom, address, pages);
 
-	return bad_dma_address;
+	return DMA_ERROR_CODE;
 }
 
 /*
@@ -1690,7 +1690,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_addr_t i, start;
 	unsigned int pages;
 
-	if ((dma_addr == bad_dma_address) ||
+	if ((dma_addr == DMA_ERROR_CODE) ||
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
@@ -1732,7 +1732,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 	INC_STATS_COUNTER(cnt_map_single);
 
 	if (!check_device(dev))
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 
 	dma_mask = *dev->dma_mask;
 
@@ -1743,12 +1743,12 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 		return (dma_addr_t)paddr;
 
 	if (!dma_ops_domain(domain))
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 
 	spin_lock_irqsave(&domain->lock, flags);
 	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
 			    dma_mask);
-	if (addr == bad_dma_address)
+	if (addr == DMA_ERROR_CODE)
 		goto out;
 
 	iommu_completion_wait(iommu);
@@ -1957,7 +1957,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
-	if (*dma_addr == bad_dma_address) {
+	if (*dma_addr == DMA_ERROR_CODE) {
 		spin_unlock_irqrestore(&domain->lock, flags);
 		goto out_free;
 	}
@@ -2110,7 +2110,6 @@ int __init amd_iommu_init_dma_ops(void)
 		prealloc_protection_domains();
 
 	iommu_detected = 1;
-	bad_dma_address = 0;
 	swiotlb = 0;
 #ifdef CONFIG_GART_IOMMU
 	gart_iommu_aperture_disabled = 1;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index c84ad03..af9f436 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -245,7 +245,7 @@ static unsigned long iommu_range_alloc(struct device *dev,
 			if (panic_on_overflow)
 				panic("Calgary: fix the allocator.\n");
 			else
-				return bad_dma_address;
+				return DMA_ERROR_CODE;
 		}
 	}
 
@@ -261,11 +261,11 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 			      void *vaddr, unsigned int npages, int direction)
 {
 	unsigned long entry;
-	dma_addr_t ret = bad_dma_address;
+	dma_addr_t ret = DMA_ERROR_CODE;
 
 	entry = iommu_range_alloc(dev, tbl, npages);
 
-	if (unlikely(entry == bad_dma_address))
+	if (unlikely(entry == DMA_ERROR_CODE))
 		goto error;
 
 	/* set the return dma address */
@@ -280,7 +280,7 @@ static dma_addr_t iommu_alloc(struct device *dev, struct iommu_table *tbl,
 error:
 	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
 	       "iommu %p\n", npages, tbl);
-	return bad_dma_address;
+	return DMA_ERROR_CODE;
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
@@ -291,8 +291,8 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned long flags;
 
 	/* were we called with bad_dma_address? */
-	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
-	if (unlikely((dma_addr >= bad_dma_address) && (dma_addr < badend))) {
+	badend = DMA_ERROR_CODE + (EMERGENCY_PAGES * PAGE_SIZE);
+	if (unlikely((dma_addr >= DMA_ERROR_CODE) && (dma_addr < badend))) {
 		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
 		       "address 0x%Lx\n", dma_addr);
 		return;
@@ -374,7 +374,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		npages = iommu_num_pages(vaddr, s->length, PAGE_SIZE);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
-		if (entry == bad_dma_address) {
+		if (entry == DMA_ERROR_CODE) {
 			/* makes sure unmap knows to stop */
 			s->dma_length = 0;
 			goto error;
@@ -392,7 +392,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 error:
 	calgary_unmap_sg(dev, sg, nelems, dir, NULL);
 	for_each_sg(sg, s, nelems, i) {
-		sg->dma_address = bad_dma_address;
+		sg->dma_address = DMA_ERROR_CODE;
 		sg->dma_length = 0;
 	}
 	return 0;
@@ -447,7 +447,7 @@ static void* calgary_alloc_coherent(struct device *dev, size_t size,
 
 	/* set up tces to cover the allocated range */
 	mapping = iommu_alloc(dev, tbl, ret, npages, DMA_BIDIRECTIONAL);
-	if (mapping == bad_dma_address)
+	if (mapping == DMA_ERROR_CODE)
 		goto free;
 	*dma_handle = mapping;
 	return ret;
@@ -728,7 +728,7 @@ static void __init calgary_reserve_regions(struct pci_dev *dev)
 	struct iommu_table *tbl = pci_iommu(dev->bus);
 
 	/* reserve EMERGENCY_PAGES from bad_dma_address and up */
-	iommu_range_reserve(tbl, bad_dma_address, EMERGENCY_PAGES);
+	iommu_range_reserve(tbl, DMA_ERROR_CODE, EMERGENCY_PAGES);
 
 	/* avoid the BIOS/VGA first 640KB-1MB region */
 	/* for CalIOC2 - avoid the entire first MB */
@@ -1359,8 +1359,6 @@ static int __init calgary_iommu_init(void)
 		return ret;
 	}
 
-	bad_dma_address = 0x0;
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index bf621b9..afcc58b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -43,9 +43,6 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
-dma_addr_t bad_dma_address __read_mostly = 0;
-EXPORT_SYMBOL(bad_dma_address);
-
 /* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 875e382..22be12b 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -33,7 +33,7 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
 	dma_addr_t bus = page_to_phys(page) + offset;
 	WARN_ON(size == 0);
 	if (!check_addr("map_single", dev, bus, size))
-		return bad_dma_address;
+		return DMA_ERROR_CODE;
 	flush_write_buffers();
 	return bus;
 }
-- 
1.5.6.5

