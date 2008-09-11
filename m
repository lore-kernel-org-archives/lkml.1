Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYIKOLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYIKOLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIKOLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:11:12 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:49263 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYIKOLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:11:11 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] x86: gart alloc_coherent does virtual mapppings only when necessary
Date: Thu, 11 Sep 2008 23:08:48 +0900
Message-Id: <1221142128-28350-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1221142128-28350-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1221142128-28350-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gart alloc_coherent need to do virtual mapppings only when an
allocated buffer is not DMA-capable for a device.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 1b0c412..47abe43 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -488,15 +488,23 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 		    gfp_t flag)
 {
 	void *vaddr;
+	dma_addr_t paddr;
 	unsigned long align_mask;
+	u64 dma_mask = dma_alloc_coherent_mask(dev, flag);
 
 	vaddr = (void *)__get_free_pages(flag | __GFP_ZERO, get_order(size));
 	if (!vaddr)
 		return NULL;
 
+	paddr = virt_to_phys(vaddr);
+	if (is_buffer_dma_capable(dma_mask, paddr, size)) {
+		*dma_addr = paddr;
+		return vaddr;
+	}
+
 	align_mask = (1UL << get_order(size)) - 1;
 
-	*dma_addr = dma_map_area(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL,
+	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
 				 align_mask);
 	flush_gart();
 
-- 
1.5.4.2

