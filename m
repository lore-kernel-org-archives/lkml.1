Return-Path: <linux-kernel-owner+w=401wt.eu-S1760542AbYDHQdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542AbYDHQdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbYDHQ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931AbYDHQ27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:28:59 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 20/28] x86: use numa allocation function in i386
Date: Tue,  8 Apr 2008 13:21:02 -0300
Message-Id: <12076718013215-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can do it here to, in the same way x86_64 does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 5ae3470..0d630ae 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -48,10 +48,23 @@ static int dma_release_coherent(struct device *dev, int order, void *vaddr)
 	return 0;
 }
 
+/* Allocate DMA memory on node near device */
+noinline struct page *
+dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
+{
+	int node;
+
+	node = dev_to_node(dev);
+
+	return alloc_pages_node(node, gfp, order);
+}
+
 void *dma_alloc_coherent(struct device *dev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret = NULL;
+	struct page *page;
+	dma_addr_t bus;
 	int order = get_order(size);
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
@@ -62,12 +75,16 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
 
-	ret = (void *)__get_free_pages(gfp, order);
+	page = dma_alloc_pages(dev, gfp, order);
+	if (page == NULL)
+		return NULL;
+
+	ret = page_address(page);
+	bus = page_to_phys(page);
+
+	memset(ret, 0, size);
+	*dma_handle = bus;
 
-	if (ret != NULL) {
-		memset(ret, 0, size);
-		*dma_handle = virt_to_phys(ret);
-	}
 	return ret;
 }
 EXPORT_SYMBOL(dma_alloc_coherent);
-- 
1.5.0.6

