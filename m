Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbXEPIiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbXEPIiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760516AbXEPIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:16 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6620 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761420AbXEPIeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:06 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/19] i386 dma_map_sg: convert to using sg helpers
Date: Wed, 16 May 2007 10:32:21 +0200
Message-Id: <1179304354703-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The dma mapping helpers need to be converted to using
sg helpers as well, so they will work with a chained
sglist setup.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/asm-i386/dma-mapping.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/asm-i386/dma-mapping.h b/include/asm-i386/dma-mapping.h
index 183eebe..a956ec1 100644
--- a/include/asm-i386/dma-mapping.h
+++ b/include/asm-i386/dma-mapping.h
@@ -2,10 +2,10 @@
 #define _ASM_I386_DMA_MAPPING_H
 
 #include <linux/mm.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cache.h>
 #include <asm/io.h>
-#include <asm/scatterlist.h>
 #include <asm/bug.h>
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -35,18 +35,19 @@ dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 }
 
 static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sg[0].length == 0);
+	WARN_ON(nents == 0 || sglist[0].length == 0);
 
-	for (i = 0; i < nents; i++ ) {
-		BUG_ON(!sg[i].page);
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg->page);
 
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg->dma_address = page_to_phys(sg->page) + sg->offset;
 	}
 
 	flush_write_buffers();
-- 
1.5.2.rc1

