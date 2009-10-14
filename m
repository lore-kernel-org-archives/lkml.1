Return-Path: <linux-kernel-owner+w=401wt.eu-S934852AbZJNQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbZJNQMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761960AbZJNQMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:12:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:21738 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761957AbZJNQMg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 14 Oct 2009 12:12:36 -0400
Message-Id: <4AD614A90200007800019E68@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 14 Oct 2009 17:12:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <beckyb@kernel.crashing.org>, <fujita.tomonori@lab.ntt.co.jp>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] fix off-by-one error in dma_capable()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_mask is, when interpreted as address, the last valid byte, and
hence comparison msut also be done using the last valid of the buffer
in question.

Also fix the open-coded instances in lib/swiotlb.c.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Becky Bruce <beckyb@kernel.crashing.org>

---
 arch/ia64/include/asm/dma-mapping.h    |    2 +-
 arch/powerpc/include/asm/dma-mapping.h |    2 +-
 arch/x86/include/asm/dma-mapping.h     |    2 +-
 lib/swiotlb.c                          |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.32-rc4/arch/ia64/include/asm/dma-mapping.h	2009-10-12 10:07:47.000000000 +0200
+++ 2.6.32-rc4-dma-capable/arch/ia64/include/asm/dma-mapping.h	2009-10-14 11:58:11.000000000 +0200
@@ -73,7 +73,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
--- linux-2.6.32-rc4/arch/powerpc/include/asm/dma-mapping.h	2009-10-12 10:07:50.000000000 +0200
+++ 2.6.32-rc4-dma-capable/arch/powerpc/include/asm/dma-mapping.h	2009-10-14 11:58:40.000000000 +0200
@@ -197,7 +197,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
--- linux-2.6.32-rc4/arch/x86/include/asm/dma-mapping.h	2009-10-12 10:07:56.000000000 +0200
+++ 2.6.32-rc4-dma-capable/arch/x86/include/asm/dma-mapping.h	2009-10-14 11:57:38.000000000 +0200
@@ -60,7 +60,7 @@ static inline bool dma_capable(struct de
 	if (!dev->dma_mask)
 		return 0;
 
-	return addr + size <= *dev->dma_mask;
+	return addr + size - 1 <= *dev->dma_mask;
 }
 
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
--- linux-2.6.32-rc4/lib/swiotlb.c	2009-10-12 10:08:48.000000000 +0200
+++ 2.6.32-rc4-dma-capable/lib/swiotlb.c	2009-10-14 11:55:26.000000000 +0200
@@ -517,7 +517,7 @@ swiotlb_alloc_coherent(struct device *hw
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size > dma_mask) {
+	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size - 1 > dma_mask) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -539,7 +539,7 @@ swiotlb_alloc_coherent(struct device *hw
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (dev_addr + size > dma_mask) {
+	if (dev_addr + size - 1 > dma_mask) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);



