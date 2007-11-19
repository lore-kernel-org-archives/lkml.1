Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbXKSPBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbXKSPBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:01:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXKSPAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:00:55 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48921 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbXKSPAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:00:54 -0500
Date: Tue, 20 Nov 2007 00:00:41 +0900
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix sg_page breakage
From: FUJITA Tomonori <tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071120000231O.tomof@acm.org>
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/alpha/kernel/pci-noop.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/alpha/kernel/pci-noop.c b/arch/alpha/kernel/pci-noop.c
index 174b729..468b76c 100644
--- a/arch/alpha/kernel/pci-noop.c
+++ b/arch/alpha/kernel/pci-noop.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
 
 #include "proto.h"
 
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
+		sg_dma_address(sg) = (dma_addr_t)virt_to_bus(va);
+		sg_dma_len(sg) = sg->length;
 	}
 
 	return nents;
-- 
1.5.3.4

