Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYCYViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYCYViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbYCYViT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760066AbYCYViS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:18 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 04/20] x86: move dma_map_sg to common header
Date: Tue, 25 Mar 2008 18:36:23 -0300
Message-Id: <1206480999-21767-5-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-4-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the old i386 implementation is moved to pci-base_32.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |   19 +++++++++++++++++++
 include/asm-x86/dma-mapping.h    |    8 +++++++-
 include/asm-x86/dma-mapping_32.h |   20 --------------------
 include/asm-x86/dma-mapping_64.h |    7 -------
 4 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index a8a7c7f..2474152 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -12,9 +12,28 @@ static dma_addr_t pci32_map_single(struct device *dev, void *ptr,
 	return virt_to_phys(ptr);
 }
 
+static int pci32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
+			    int nents, int direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	WARN_ON(nents == 0 || sglist[0].length == 0);
+
+	for_each_sg(sglist, sg, nents, i) {
+		BUG_ON(!sg_page(sg));
+
+		sg->dma_address = sg_phys(sg);
+	}
+
+	flush_write_buffers();
+	return nents;
+}
+
 static const struct dma_mapping_ops pci32_dma_ops = {
 	.map_single = pci32_map_single,
 	.unmap_single = NULL,
+	.map_sg = pci32_dma_map_sg,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index bb0378f..0901154 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -75,5 +75,11 @@ dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 		dma_ops->unmap_single(dev, addr, size, direction);
 }
 
-
+static inline int
+dma_map_sg(struct device *hwdev, struct scatterlist *sg,
+	   int nents, int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	return dma_ops->map_sg(hwdev, sg, nents, direction);
+}
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 0b27cb0..cdcdeff 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -17,26 +17,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle);
 
-static inline int
-dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
-	   enum dma_data_direction direction)
-{
-	struct scatterlist *sg;
-	int i;
-
-	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nents == 0 || sglist[0].length == 0);
-
-	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg_page(sg));
-
-		sg->dma_address = sg_phys(sg);
-	}
-
-	flush_write_buffers();
-	return nents;
-}
-
 static inline dma_addr_t
 dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 	     size_t size, enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 5d349db..b27527a 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -96,13 +96,6 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 	flush_write_buffers();
 }
 
-static inline int
-dma_map_sg(struct device *hwdev, struct scatterlist *sg, int nents, int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_sg(hwdev, sg, nents, direction);
-}
-
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 	     int direction)
-- 
1.5.0.6

