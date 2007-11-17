Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbXKQH5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbXKQH5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 02:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXKQH5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 02:57:00 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55134 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbXKQH47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 02:56:59 -0500
Message-Id: <200711170752.lAH7qlRg003441@mbox.iij4u.or.jp>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: alpha: fix sg_page breakage
From: FUJITA Tomonori <tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Date: Sat, 17 Nov 2007 16:52:44 +0900
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/alpha/kernel/pci-noop.c:167: warning: 'virt_to_bus' is deprecated (declared at include2/asm/io.h:117)
arch/alpha/kernel/pci-noop.c: In function 'dma_map_sg':
arch/alpha/kernel/pci-noop.c:183: error: 'struct scatterlist' has no member named 'page'
arch/alpha/kernel/pci-noop.c:184: error: 'struct scatterlist' has no member named 'page'
arch/alpha/kernel/pci-noop.c:185: warning: 'virt_to_bus' is deprecated (declared at include2/asm/io.h:11)

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/kernel/pci-noop.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index 174b729..8ac0831 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
 
 #include "proto.h"
 
@@ -164,7 +165,7 @@ dma_alloc_coherent(struct device *dev, size_t size,
 	ret = (void *)__get_free_pages(gfp, get_order(size));
 	if (ret) {
 		memset(ret, 0, size);
-		*dma_handle = virt_to_bus(ret);
+		*dma_handle = virt_to_phys(ret);
 	}
 	return ret;
 }
@@ -172,18 +173,19 @@ dma_alloc_coherent(struct device *dev, size_t size,
 EXPORT_SYMBOL(dma_alloc_coherent);
 
 int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	   enum dma_data_direction direction)
 {
 	int i;
+	struct scatterlist *sg;
 
-	for (i = 0; i < nents; i++ ) {
+	for_each_sg(sgl, sg, nents, i) {
 		void *va;
 
-		BUG_ON(!sg[i].page);
-		va = page_address(sg[i].page) + sg[i].offset;
-		sg_dma_address(sg + i) = (dma_addr_t)virt_to_bus(va);
-		sg_dma_len(sg + i) = sg[i].length;
+		BUG_ON(!sg_page(sg));
+		va = sg_virt(sg);
+		sg_dma_address(sg) = (dma_addr_t)virt_to_phys(va);
+		sg_dma_len(sg) = sg->length;
 	}
 
 	return nents;
-- 
1.5.2.4

