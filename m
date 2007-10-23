Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbXJWECv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbXJWECv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbXJWECp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:02:45 -0400
Received: from lixom.net ([66.141.50.11]:57695 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbXJWECo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:02:44 -0400
Date: Mon, 22 Oct 2007 23:09:48 -0500
From: Olof Johansson <olof@lixom.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linuxppc-dev@ozlabs.org
Subject: powerpc: Fix fallout from sg_page() changes
Message-ID: <20071023040948.GA19699@lixom.net>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix fallout from 18dabf473e15850c0dbc8ff13ac1e2806d542c15:

In file included from include/linux/dma-mapping.h:52,
                 from drivers/base/dma-mapping.c:10:
include/asm/dma-mapping.h: In function 'dma_map_sg':
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:289: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:290: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h: In function 'dma_sync_sg_for_cpu':
include/asm/dma-mapping.h:331: error: 'struct scatterlist' has no member named 'page'

drivers/scsi/ps3rom.c: In function 'fetch_to_dev_buffer':
drivers/scsi/ps3rom.c:150: error: 'struct scatterlist' has no member named 'page'



Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 65be95d..ff52013 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i) {
-		BUG_ON(!sg->page);
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
-		sg->dma_address = page_to_bus(sg->page) + sg->offset;
+		BUG_ON(!sg_page(sg));
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
 	}
 
 	return nents;
@@ -328,7 +328,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline void dma_sync_sg_for_device(struct device *dev,
@@ -341,7 +341,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 03f19b8..17b4a7c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -147,7 +147,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
 
 	req_len = fin = 0;
 	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		kaddr = kmap_atomic(sg_page(sgpnt->page), KM_IRQ0);
+		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
 			len = buflen - req_len;
