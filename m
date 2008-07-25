Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYGYM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYGYM72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 08:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbYGYM6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 08:58:54 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43630 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271AbYGYM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:58:52 -0400
X-BigFish: VPS-3(zz1803Ozz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K4KC18-04-X3F-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86 gart: replace to_pages macro with iommu_num_pages
Date: Fri, 25 Jul 2008 14:58:00 +0200
Message-ID: <1216990680-1227-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
References: <1216990680-1227-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 12:58:00.0356 (UTC) FILETIME=[11384E40:01C8EE56]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the to_pages macro from x86 GART code and calls the generic
iommu_num_pages function instead.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 1062dc1..31bc068 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -67,9 +67,6 @@ static u32 gart_unmapped_entry;
 	(((x) & 0xfffff000) | (((x) >> 32) << 4) | GPTE_VALID | GPTE_COHERENT)
 #define GPTE_DECODE(x) (((x) & 0xfffff000) | (((u64)(x) & 0xff0) << 28))
 
-#define to_pages(addr, size) \
-	(round_up(((addr) & ~PAGE_MASK) + (size), PAGE_SIZE) >> PAGE_SHIFT)
-
 #define EMERGENCY_PAGES 32 /* = 128KB */
 
 #ifdef CONFIG_AGP
@@ -241,7 +238,7 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir)
 {
-	unsigned long npages = to_pages(phys_mem, size);
+	unsigned long npages = iommu_num_pages(phys_mem, size);
 	unsigned long iommu_page = alloc_iommu(dev, npages);
 	int i;
 
@@ -304,7 +301,7 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 		return;
 
 	iommu_page = (dma_addr - iommu_bus_base)>>PAGE_SHIFT;
-	npages = to_pages(dma_addr, size);
+	npages = iommu_num_pages(dma_addr, size);
 	for (i = 0; i < npages; i++) {
 		iommu_gatt_base[iommu_page + i] = gart_unmapped_entry;
 		CLEAR_LEAK(iommu_page + i);
@@ -387,7 +384,7 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 		}
 
 		addr = phys_addr;
-		pages = to_pages(s->offset, s->length);
+		pages = iommu_num_pages(s->offset, s->length);
 		while (pages--) {
 			iommu_gatt_base[iommu_page] = GPTE_ENCODE(addr);
 			SET_LEAK(iommu_page);
@@ -470,7 +467,7 @@ gart_map_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
 
 		seg_size += s->length;
 		need = nextneed;
-		pages += to_pages(s->offset, s->length);
+		pages += iommu_num_pages(s->offset, s->length);
 		ps = s;
 	}
 	if (dma_map_cont(dev, start_sg, i - start, sgmap, pages, need) < 0)
-- 
1.5.3.7


