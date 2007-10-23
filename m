Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbXJWVkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbXJWVkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXJWVj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:39:57 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:53984 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXJWVj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:39:56 -0400
From: Emil Medve <Emilian.Medve@freescale.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Emil Medve <Emilian.Medve@freescale.com>
Subject: [PATCH rebased] Use the new sg_page() helper
Date: Tue, 23 Oct 2007 12:32:25 -0500
Message-Id: <1193160745-16984-1-git-send-email-Emilian.Medve@Freescale.com>
X-Mailer: git-send-email 1.5.3.GIT
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build error messages such as this:

In file included from include/linux/dma-mapping.h:52,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/netlink.h:155,
                 from include/linux/genetlink.h:4,
                 from include/net/genetlink.h:4,
                 from include/linux/taskstats_kern.h:12,
                 from init/main.c:46:
include/asm/dma-mapping.h: In function 'dma_map_sg':
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:288: error: 'struct scatterlist' has no member named 'page'
include/asm/dma-mapping.h:290: error: 'struct scatterlist' has no member named 'page'

This change in the struct scatterlist was introduced by this commit: 18dabf473e15850c0dbc8ff13ac1e2806d542c15

Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
---

linux-2.6> scripts/checkpatch.pl 0001-Use-the-new-sg_page-helper.patch 
Your patch has no obvious style problems and is ready for submission.

 drivers/mmc/host/mmci.h          |    4 ++--
 include/asm-xtensa/dma-mapping.h |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
index 000e6a9..de3c223 100644
--- a/drivers/mmc/host/mmci.h
+++ b/drivers/mmc/host/mmci.h
@@ -112,7 +112,7 @@
  * The size of the FIFO in bytes.
  */
 #define MCI_FIFOSIZE	(16*4)
-	
+
 #define MCI_FIFOHALFSIZE (MCI_FIFOSIZE / 2)
 
 #define NR_SG		16
@@ -169,7 +169,7 @@ static inline char *mmci_kmap_atomic(struct mmci_host *host, unsigned long *flag
 	struct scatterlist *sg = host->sg_ptr;
 
 	local_irq_save(*flags);
-	return kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 }
 
 static inline void mmci_kunmap_atomic(struct mmci_host *host, void *buffer, unsigned long *flags)
diff --git a/include/asm-xtensa/dma-mapping.h b/include/asm-xtensa/dma-mapping.h
index 82b03b3..2b3e975 100644
--- a/include/asm-xtensa/dma-mapping.h
+++ b/include/asm-xtensa/dma-mapping.h
@@ -58,10 +58,10 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++ ) {
-		BUG_ON(!sg->page);
+		BUG_ON(!sg_page(sg));
 
-		sg->dma_address = page_to_phys(sg->page) + sg->offset;
-		consistent_sync(page_address(sg->page) + sg->offset,
+		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
+		consistent_sync(page_address(sg_page(sg)) + sg->offset,
 				sg->length, direction);
 	}
 
@@ -128,7 +128,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 {
 	int i;
 	for (i = 0; i < nelems; i++, sg++)
-		consistent_sync(page_address(sg->page) + sg->offset,
+		consistent_sync(page_address(sg_page(sg)) + sg->offset,
 				sg->length, dir);
 }
 
@@ -138,7 +138,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
 {
 	int i;
 	for (i = 0; i < nelems; i++, sg++)
-		consistent_sync(page_address(sg->page) + sg->offset,
+		consistent_sync(page_address(sg_page(sg)) + sg->offset,
 				sg->length, dir);
 }
 static inline int
-- 
1.5.3.GIT

