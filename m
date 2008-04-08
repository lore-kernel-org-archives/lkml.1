Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbYDHQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbYDHQcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbYDHQ27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:28:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbYDHQ26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:58 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 19/28] x86: remove virt_to_bus in pci-dma_64.c
Date: Tue,  8 Apr 2008 13:21:01 -0300
Message-Id: <12076717951181-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_bus() is deprecated according to the docs, and moreover,
won't return the right thing in i386 if we're dealing with high memory mappings.
So we make our allocation function return a page, and then use page_address() (for
virtual addr) and page_to_phys() (for physical addr) instead.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_64.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index 5f03e41..13a31a4 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -28,13 +28,11 @@ struct device fallback_dev = {
 noinline static void *
 dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
 {
-	struct page *page;
 	int node;
 
 	node = dev_to_node(dev);
 
-	page = alloc_pages_node(node, gfp, order);
-	return page ? page_address(page) : NULL;
+	return alloc_pages_node(node, gfp, order);
 }
 
 #define dma_alloc_from_coherent_mem(dev, size, handle, ret) (0)
@@ -47,6 +45,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t gfp)
 {
 	void *memory;
+	struct page *page;
 	unsigned long dma_mask = 0;
 	u64 bus;
 
@@ -79,13 +78,14 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp |= GFP_DMA32;
 
  again:
-	memory = dma_alloc_pages(dev, gfp, get_order(size));
-	if (memory == NULL)
+	page = dma_alloc_pages(dev, gfp, get_order(size));
+	if (page == NULL)
 		return NULL;
 
 	{
 		int high, mmu;
-		bus = virt_to_bus(memory);
+		bus = page_to_phys(page);
+		memory = page_address(page);
 	        high = (bus + size) >= dma_mask;
 		mmu = high;
 		if (force_iommu && !(gfp & GFP_DMA))
@@ -112,7 +112,7 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 
 		memset(memory, 0, size);
 		if (!mmu) {
-			*dma_handle = virt_to_bus(memory);
+			*dma_handle = bus;
 			return memory;
 		}
 	}
-- 
1.5.0.6

