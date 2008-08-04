Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYHDQFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYHDQFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYHDQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:04 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:50364 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYHDQFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:02 -0400
X-BigFish: VPS4(z1039oz1803Ozz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K533C1-04-0UB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/10] x86: convert GART driver to generic iommu_num_pages function
Date: Mon, 4 Aug 2008 18:04:45 +0200
Message-ID: <1217865890-3593-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0636 (UTC) FILETIME=[D3CB5F40:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index cdf1c00..fa313d4 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -238,7 +238,7 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir)
 {
-	unsigned long npages = iommu_nr_pages(phys_mem, size);
+	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
 	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
@@ -301,7 +301,7 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = iommu_nr_pages(dma_addr, size);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -384,7 +384,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		}
 
 		addr = phys_addr;
-		pages = iommu_nr_pages(s->offset, s->length);
+		pages = iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -467,7 +467,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += iommu_nr_pages(s->offset, s->length);
+		pages += iommu_num_pages(s->offset, s->length, PAGE_SIZE);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
-- 
1.5.3.7


