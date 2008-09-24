Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYIXLxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYIXLxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYIXLwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:52:19 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43003 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbYIXLwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:52:17 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 3/3] x86: restore old GART alloc_coherent behavior
Date: Wed, 24 Sep 2008 20:48:37 +0900
Message-Id: <1222256917-14321-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1222256917-14321-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
for a device having dma_masks > 24bit < 32bits. If GART gets an
address that a device can't access to, GART try to map the address to
a virtual I/O address that the device can access to.

But Andi pointed out, "The GART is somewhere in the 4GB range so you
cannot use it to map anything < 4GB. Also GART is pretty small."

http://lkml.org/lkml/2008/9/12/43

That is, it's possible that GART doesn't have virtual I/O address
space that a device can access to. The above behavior doesn't work for
a device having dma_masks > 24bit < 32bits.

This patch restores old GART alloc_coherent behavior (before the
alloc_coherent rewrite).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |   43 +++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 7e08e46..25c94fb 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -487,31 +487,28 @@ static void *
 gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 		    gfp_t flag)
 {
-	void *vaddr;
 	dma_addr_t paddr;
 	unsigned long align_mask;
-	u64 dma_mask = dma_alloc_coherent_mask(dev, flag);
-
-	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
-	if (!vaddr)
-		return NULL;
-
-	paddr = virt_to_phys(vaddr);
-	if (is_buffer_dma_capable(dma_mask, paddr, size)) {
-		*dma_addr = paddr;
-		return vaddr;
-	}
-
-	align_mask = (1UL << get_order(size)) - 1;
-
-	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
-				 align_mask);
-	flush_gart();
-
-	if (*dma_addr != bad_dma_address)
-		return vaddr;
-
-	free_pages((unsigned long)vaddr, get_order(size));
+	struct page *page;
+
+	if (force_iommu && !(flag & GFP_DMA)) {
+		flag &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+		page = alloc_pages(flag | __GFP_ZERO, get_order(size));
+		if (!page)
+			return NULL;
+
+		align_mask = (1UL << get_order(size)) - 1;
+		paddr = dma_map_area(dev, page_to_phys(page), size,
+				     DMA_BIDIRECTIONAL, align_mask);
+
+		flush_gart();
+		if (paddr != bad_dma_address) {
+			*dma_addr = paddr;
+			return page_address(page);
+		}
+		__free_pages(page, get_order(size));
+	} else
+		return dma_generic_alloc_coherent(dev, size, dma_addr, flag);
 
 	return NULL;
 }
-- 
1.5.4.2

