Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbYDHQbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbYDHQbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758681AbYDHQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675AbYDHQ2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:32 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 21/28] x86: retry allocation if failed
Date: Tue,  8 Apr 2008 13:21:03 -0300
Message-Id: <12076718073024-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts in the code to retry allocation in case it fails. By its
own, it does not make much sense but making the code look like x86_64.
But later patches in this series will make we try to allocate from
zones other than DMA first, which will possibly fail.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 0d630ae..f6cf434 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -66,6 +66,8 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	struct page *page;
 	dma_addr_t bus;
 	int order = get_order(size);
+	unsigned long dma_mask = 0;
+
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
@@ -75,15 +77,37 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
+	dma_mask = dev->coherent_dma_mask;
+	if (dma_mask == 0)
+		dma_mask = DMA_32BIT_MASK;
+
+ again:
 	page = dma_alloc_pages(dev, gfp, order);
 	if (page == NULL)
 		return NULL;
 
-	ret = page_address(page);
-	bus = page_to_phys(page);
-
-	memset(ret, 0, size);
-	*dma_handle = bus;
+	{
+		int high, mmu;
+		bus = page_to_phys(page);
+		ret = page_address(page);
+		high = (bus + size) >= dma_mask;
+		mmu = high;
+		if (force_iommu && !(gfp & GFP_DMA))
+			mmu = 1;
+		else if (high) {
+			free_pages((unsigned long)ret,
+				   get_order(size));
+
+			/* Don't use the 16MB ZONE_DMA unless absolutely
+			   needed. It's better to use remapping first. */
+			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
+				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
+				goto again;
+			}
+		}
+		memset(ret, 0, size);
+		*dma_handle = bus;
+	}
 
 	return ret;
 }
-- 
1.5.0.6

