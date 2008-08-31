Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbYHaJJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbYHaJJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYHaJJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:09:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33065 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYHaJJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:09:16 -0400
Date: Sun, 31 Aug 2008 18:14:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: mingo@elte.hu
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for August 29
Message-Id: <20080831181410.1894289c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080829194010.5ca53e33.sfr@canb.auug.org.au>
References: <20080829194010.5ca53e33.sfr@canb.auug.org.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 19:40:10 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> Changes since next-20080828:
> 
> The block tree lost 3 conflicts but gained a build fix patch.
> 
> The firmware tree lost its 2 conflicts.
> 
> The pcmcia tree gained a build fix patch.
> 
> The creds tree gained a conflict against the security-testing tree.
> 

Hi, I got boot trouble on x86_64.

I'm now trying recent mmtom tree but megaraid_sas get "page allocation failure"
at megasas_probe_one() in boot because of __GFP_DMA.

It seems dma_alloc_xxx patch set (in linux-next) changes the logic of pci_alloc_consistent().

For quick workaround, I'm now using this patch.

This patch just tries to make use of usual pages before using __GFP_DMA.
(But I don't think this is a correct patch. )

new dma_alloc_coherent() seems to drop almost all logics used in
old /arch/x86/kernel/pci-dma.c::dma_alloc_coherent().

Thanks,
-Kame

---
 arch/x86/kernel/pci-swiotlb_64.c     |   34 +++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.c |    1 +
 mm/page_alloc.c                      |    3 ++-
 3 files changed, 36 insertions(+), 2 deletions(-)

Index: mmtom-2.6.27-rc5+/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- mmtom-2.6.27-rc5+.orig/drivers/scsi/megaraid/megaraid_sas.c
+++ mmtom-2.6.27-rc5+/drivers/scsi/megaraid/megaraid_sas.c
@@ -2501,6 +2501,7 @@ megasas_set_dma_mask(struct pci_dev *pde
 			if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
 				goto fail_set_dma_mask;
 		}
+		pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	} else {
 		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
 			goto fail_set_dma_mask;
Index: mmtom-2.6.27-rc5+/arch/x86/kernel/pci-swiotlb_64.c
===================================================================
--- mmtom-2.6.27-rc5+.orig/arch/x86/kernel/pci-swiotlb_64.c
+++ mmtom-2.6.27-rc5+/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,9 +18,41 @@ swiotlb_map_single_phys(struct device *h
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
+/*
+ * We're only architecture which has DMA32.
+ */
+void *x86_64_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
+				dma_addr_t *dma_handle, gfp_t flags)
+{
+	unsigned long dma_mask;
+	struct page *page;
+	int node = node = dev_to_node(hwdev);
+	int myflags = flags | __GFP_ZERO;
+
+	dma_mask = hwdev->coherent_dma_mask;
+	if (!dma_mask)
+		return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
+	if (dma_mask >= (max_pfn << PAGE_SHIFT)) {
+		page = alloc_pages_node(node, myflags, get_order(size));
+		if (page) {
+			*dma_handle = page_to_phys(page);
+			return page_address(page);
+		}
+	}
+	if (dma_mask >= DMA_32BIT_MASK) {
+		page = alloc_pages_node(node,
+				myflags | GFP_DMA32, get_order(size));
+		if (page) {
+			*dma_handle = page_to_phys(page);
+			return page_address(page);
+		}
+	}
+	return swiotlb_alloc_coherent(hwdev, size, dma_handle, flags);
+}
+
 struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
-	.alloc_coherent = swiotlb_alloc_coherent,
+	.alloc_coherent = x86_64_swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
 	.map_single = swiotlb_map_single_phys,
 	.unmap_single = swiotlb_unmap_single,

