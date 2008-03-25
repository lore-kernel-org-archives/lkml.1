Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbYCYVjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbYCYVjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbYCYViW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760157AbYCYViV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:21 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 03/20] x86: move dma_unmap_single to common header
Date: Tue, 25 Mar 2008 18:36:22 -0300
Message-Id: <1206480999-21767-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-3-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 base does not need it, so it gets an empty function

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |    1 +
 include/asm-x86/dma-mapping.h    |   10 ++++++++++
 include/asm-x86/dma-mapping_32.h |    7 -------
 include/asm-x86/dma-mapping_64.h |    8 --------
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index b613d73..a8a7c7f 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -14,6 +14,7 @@ static dma_addr_t pci32_map_single(struct device *dev, void *ptr,
 
 static const struct dma_mapping_ops pci32_dma_ops = {
 	.map_single = pci32_map_single,
+	.unmap_single = NULL,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index d320244..bb0378f 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -66,4 +66,14 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	return dma_ops->map_single(hwdev, ptr, size, direction);
 }
 
+static inline void
+dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
+		 int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	if (dma_ops->unmap_single)
+		dma_ops->unmap_single(dev, addr, size, direction);
+}
+
+
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index b496306..0b27cb0 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -17,13 +17,6 @@ void *dma_alloc_coherent(struct device *dev, size_t size,
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle);
 
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		 enum dma_data_direction direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-}
-
 static inline int
 dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 969a7da..5d349db 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -23,14 +23,6 @@ extern void *dma_alloc_coherent(struct device *dev, size_t size,
 extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 			      dma_addr_t dma_handle);
 
-static inline void
-dma_unmap_single(struct device *dev, dma_addr_t addr,size_t size,
-		 int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	dma_ops->unmap_single(dev, addr, size, direction);
-}
-
 #define dma_map_page(dev,page,offset,size,dir) \
 	dma_map_single((dev), page_address(page)+(offset), (size), (dir))
 
-- 
1.5.0.6

