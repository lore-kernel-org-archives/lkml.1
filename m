Return-Path: <linux-kernel-owner+w=401wt.eu-S1759201AbYHDQH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbYHDQH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbYHDQFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:17 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:51332 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755827AbYHDQFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:15 -0400
X-BigFish: VPS7(zz853kzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K533C3-03-PIV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU code
Date: Mon, 4 Aug 2008 18:04:50 +0200
Message-ID: <1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0792 (UTC) FILETIME=[D3E32D00:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/sparc64/kernel/iommu.c        |    7 ++++---
 arch/sparc64/kernel/iommu_common.h |   14 ++------------
 arch/sparc64/kernel/pci_sun4v.c    |    7 ++++---
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index f73b238..1cc1995 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -575,7 +575,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_nr_pages(paddr, slen);
+		npages = iommu_num_pages(paddr, slen, IO_PAGE_SIZE);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -647,7 +647,8 @@ iommu_map_failed:
 			iopte_t *base;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IO_PAGE_SIZE);
 			iommu_range_free(iommu, vaddr, npages);
 
 			entry = (vaddr - iommu->page_table_map_base)
@@ -715,7 +716,7 @@ static void dma_4u_unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 		if (!len)
 			break;
-		npages = iommu_nr_pages(dma_handle, len);
+		npages = iommu_num_pages(dma_handle, len, IO_PAGE_SIZE);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base)
diff --git a/arch/sparc64/kernel/iommu_common.h b/arch/sparc64/kernel/iommu_common.h
index 202d8ae..591f587 100644
--- a/arch/sparc64/kernel/iommu_common.h
+++ b/arch/sparc64/kernel/iommu_common.h
@@ -35,17 +35,6 @@
 
 #define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
-static inline unsigned long iommu_nr_pages(unsigned long vaddr,
-					    unsigned long slen)
-{
-	unsigned long npages;
-
-	npages = IO_PAGE_ALIGN(vaddr + slen) - (vaddr & IO_PAGE_MASK);
-	npages >>= IO_PAGE_SHIFT;
-
-	return npages;
-}
-
 static inline int is_span_boundary(unsigned long entry,
 				   unsigned long shift,
 				   unsigned long boundary_size,
@@ -53,7 +42,8 @@ static inline int is_span_boundary(unsigned long entry,
 				   struct scatterlist *sg)
 {
 	unsigned long paddr = SG_ENT_PHYS_ADDRESS(outs);
-	int nr = iommu_nr_pages(paddr, outs->dma_length + sg->length);
+	int nr = iommu_num_pages(paddr, outs->dma_length + sg->length,
+				 IO_PAGE_SIZE);
 
 	return iommu_is_span_boundary(entry, nr, shift, boundary_size);
 }
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 6a53c31..2e2a03c 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -382,7 +382,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 		}
 		/* Allocate iommu entries for that segment */
 		paddr = (unsigned long) SG_ENT_PHYS_ADDRESS(s);
-		npages = iommu_nr_pages(paddr, slen);
+		npages = iommu_num_pages(paddr, slen, IO_PAGE_SIZE);
 		entry = iommu_range_alloc(dev, iommu, npages, &handle);
 
 		/* Handle failure */
@@ -459,7 +459,8 @@ iommu_map_failed:
 			unsigned long vaddr, npages;
 
 			vaddr = s->dma_address & IO_PAGE_MASK;
-			npages = iommu_nr_pages(s->dma_address, s->dma_length);
+			npages = iommu_num_pages(s->dma_address, s->dma_length,
+						 IO_PAGE_SIZE);
 			iommu_range_free(iommu, vaddr, npages);
 			/* XXX demap? XXX */
 			s->dma_address = DMA_ERROR_CODE;
@@ -498,7 +499,7 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 
 		if (!len)
 			break;
-		npages = iommu_nr_pages(dma_handle, len);
+		npages = iommu_num_pages(dma_handle, len, IO_PAGE_SIZE);
 		iommu_range_free(iommu, dma_handle, npages);
 
 		entry = ((dma_handle - iommu->page_table_map_base) >> IO_PAGE_SHIFT);
-- 
1.5.3.7


