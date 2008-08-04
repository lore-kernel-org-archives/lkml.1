Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYHDQGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYHDQGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYHDQFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:05:07 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21813 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753802AbYHDQFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:05:04 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0K533C2-04-0UE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net,
       paulus@samba.org, benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/10] alpha: use iommu_num_pages function in IOMMU code
Date: Mon, 4 Aug 2008 18:04:49 +0200
Message-ID: <1217865890-3593-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Aug 2008 16:04:51.0761 (UTC) FILETIME=[D3DE7210:01C8F64B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/alpha/kernel/pci_iommu.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 2179c60..b9094da 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -41,13 +41,6 @@ mk_iommu_pte(unsigned long paddr)
 	return (paddr >> (PAGE_SHIFT-1)) | 1;
 }
 
-static inline long
-calc_npages(long bytes)
-{
-	return (bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
-}
-
-
 /* Return the minimum of MAX or the first power of two larger
    than main memory.  */
 
@@ -287,7 +280,7 @@ pci_map_single_1(struct pci_dev *pdev, void *cpu_addr, size_t size,
 	if (!arena || arena->dma_base + arena->size - 1 > max_dma)
 		arena = hose->sg_isa;
 
-	npages = calc_npages((paddr & ~PAGE_MASK) + size);
+	npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 
 	/* Force allocation to 64KB boundary for ISA bridges. */
 	if (pdev && pdev == isa_bridge)
@@ -387,7 +380,7 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t dma_addr, size_t size,
 		BUG();
 	}
 
-	npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 
 	spin_lock_irqsave(&arena->lock, flags);
 
@@ -580,7 +573,7 @@ sg_fill(struct device *dev, struct scatterlist *leader, struct scatterlist *end,
 	   contiguous.  */
 
 	paddr &= ~PAGE_MASK;
-	npages = calc_npages(paddr + size);
+	npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	dma_ofs = iommu_arena_alloc(dev, arena, npages, 0);
 	if (dma_ofs < 0) {
 		/* If we attempted a direct map above but failed, die.  */
@@ -616,7 +609,7 @@ sg_fill(struct device *dev, struct scatterlist *leader, struct scatterlist *end,
 			sg++;
 		}
 
-		npages = calc_npages((paddr & ~PAGE_MASK) + size);
+		npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 
 		paddr &= PAGE_MASK;
 		for (i = 0; i < npages; ++i, paddr += PAGE_SIZE)
@@ -775,7 +768,7 @@ pci_unmap_sg(struct pci_dev *pdev, struct scatterlist *sg, int nents,
 		DBGA("    (%ld) sg [%lx,%lx]\n",
 		     sg - end + nents, addr, size);
 
-		npages = calc_npages((addr & ~PAGE_MASK) + size);
+		npages = iommu_num_pages(addr, size, PAGE_SIZE);
 		ofs = (addr - arena->dma_base) >> PAGE_SHIFT;
 		iommu_arena_free(arena, ofs, npages);
 
-- 
1.5.3.7


