Return-Path: <linux-kernel-owner+w=401wt.eu-S1760748AbYCYVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748AbYCYVkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbYCYVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760449AbYCYVi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:26 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 05/20] x86: move dma_unmap_sg to common header
Date: Tue, 25 Mar 2008 18:36:24 -0300
Message-Id: <1206480999-21767-6-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-5-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 gets an empty function

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |    1 +
 include/asm-x86/dma-mapping.h    |    9 +++++++++
 include/asm-x86/dma-mapping_32.h |    8 --------
 include/asm-x86/dma-mapping_64.h |    8 --------
 4 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index 2474152..9205304 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -34,6 +34,7 @@ static const struct dma_mapping_ops pci32_dma_ops = {
 	.map_single = pci32_map_single,
 	.unmap_single = NULL,
 	.map_sg = pci32_dma_map_sg,
+	.unmap_sg = NULL,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 0901154..6e7747a 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -82,4 +82,13 @@ dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 	BUG_ON(!valid_dma_direction(direction));
 	return dma_ops->map_sg(hwdev, sg, nents, direction);
 }
+
+static inline void
+dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
+	     int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	if (dma_ops->unmap_sg)
+		dma_ops->unmap_sg(hwdev, sg, nents, direction);
+}
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index cdcdeff..55445e3 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -32,14 +32,6 @@ dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
 	BUG_ON(!valid_dma_direction(direction));
 }
 
-
-static inline void
-dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
 static inline void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
 			enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index b27527a..ce37efb 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -96,14 +96,6 @@ dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 	flush_write_buffers();
 }
 
-static inline void
-dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	     int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	dma_ops->unmap_sg(hwdev, sg, nents, direction);
-}
-
 extern int dma_supported(struct device *hwdev, u64 mask);
 
 /* same for gart, swiotlb, and nommu */
-- 
1.5.0.6

