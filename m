Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYHDQGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYHDQGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYHDQFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:08 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21994 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754289AbYHDQFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:06 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K533C4-03-PIW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/10] x86: convert Calgary IOMMU driver to generic iommu_num_pages function
Date: Mon, 4 Aug 2008 18:04:47 +0200
Message-ID: <1217865890-3593-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0714 (UTC) FILETIME=[D3D74620:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-calgary_64.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index b67a4b1..1fbba8a 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -217,16 +217,6 @@ static inline unsigned long verify_bit_range(unsigned long* bitmap,
 
 #endif /* CONFIG_IOMMU_DEBUG */
 
-static inline unsigned int num_dma_pages(unsigned long dma, unsigned int dmalen)
-{
-	unsigned int npages;
-
-	npages = PAGE_ALIGN(dma + dmalen) - (dma & PAGE_MASK);
-	npages >>= PAGE_SHIFT;
-
-	return npages;
-}
-
 static inline int translation_enabled(struct iommu_table *tbl)
 {
 	/* only PHBs with translation enabled have an IOMMU table */
@@ -409,7 +399,7 @@ static void calgary_unmap_sg(struct device *dev,
 		if (dmalen == 0)
 			break;
 
-		npages = num_dma_pages(dma, dmalen);
+		npages = iommu_num_pages(dma, dmalen, PAGE_SIZE);
 		iommu_free(tbl, dma, npages);
 	}
 }
@@ -428,7 +418,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		BUG_ON(!sg_page(s));
 
 		vaddr = (unsigned long) sg_virt(s);
-		npages = num_dma_pages(vaddr, s->length);
+		npages = iommu_num_pages(vaddr, s->length, PAGE_SIZE);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
@@ -465,7 +455,7 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
-	npages = num_dma_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size, PAGE_SIZE);
 
 	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
@@ -476,7 +466,7 @@ static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = num_dma_pages(dma_handle, size);
+	npages = iommu_num_pages(dma_handle, size, PAGE_SIZE);
 	iommu_free(tbl, dma_handle, npages);
 }
 
-- 
1.5.3.7


