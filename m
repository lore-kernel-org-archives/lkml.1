Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbYHDQGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbYHDQGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYHDQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53699 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754396AbYHDQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:09 -0400
X-BigFish: VPS-3(zz1803Ozz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K533C2-04-0UG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/10] x86: rename iommu_num_pages function to iommu_nr_pages
Date: Mon, 4 Aug 2008 18:04:41 +0200
Message-ID: <1217865890-3593-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0474 (UTC) FILETIME=[D3B2A720:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation patch for introducing a generic iommu_num_pages function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c   |    8 ++++----
 arch/x86/kernel/pci-dma.c     |    4 ++--
 arch/x86/kernel/pci-gart_64.c |    8 ++++----
 include/asm-x86/iommu.h       |    2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 22d7d05..f211341 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -182,7 +182,7 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		u64 address, size_t size)
 {
 	int s = 0;
-	unsigned pages = iommu_num_pages(address, size);
+	unsigned pages = iommu_nr_pages(address, size);
 
 	address &= PAGE_MASK;
 
@@ -554,7 +554,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
 		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
+		int pages = iommu_nr_pages(iommu->exclusion_start,
 					    iommu->exclusion_length);
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
@@ -764,7 +764,7 @@ static dma_addr_t __map_single(struct device *dev,
 	unsigned int pages;
 	int i;
 
-	pages = iommu_num_pages(paddr, size);
+	pages = iommu_nr_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
 	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
@@ -799,7 +799,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	if ((dma_addr == 0) || (dma_addr + size > dma_dom->aperture_size))
 		return;
 
-	pages = iommu_num_pages(dma_addr, size);
+	pages = iommu_nr_pages(dma_addr, size);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 87d4d69..9e46c71 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -124,13 +124,13 @@ void __init pci_iommu_alloc(void)
 	pci_swiotlb_init();
 }
 
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
+unsigned long iommu_nr_pages(unsigned long addr, unsigned long len)
 {
 	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
 
 	return size >> PAGE_SHIFT;
 }
-EXPORT_SYMBOL(iommu_num_pages);
+EXPORT_SYMBOL(iommu_nr_pages);
 #endif
 
 /*
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 49285f8..cdf1c00 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -238,7 +238,7 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir)
 {
-	unsigned long npages = iommu_num_pages(phys_mem, size);
+	unsigned long npages = iommu_nr_pages(phys_mem, size);
 	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
@@ -301,7 +301,7 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_num_pages(dma_addr, size);
+	npages = iommu_nr_pages(dma_addr, size);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -384,7 +384,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		}
 
 		addr = phys_addr;
-		pages = iommu_num_pages(s->offset, s->length);
+		pages = iommu_nr_pages(s->offset, s->length);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -467,7 +467,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += iommu_num_pages(s->offset, s->length);
+		pages += iommu_nr_pages(s->offset, s->length);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index 5f888cc..61d64e4 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -7,7 +7,7 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len);
+extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
 
 #ifdef CONFIG_GART_IOMMU
 extern int gart_iommu_aperture;
-- 
1.5.3.7


