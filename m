Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbYCYVlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbYCYVlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbYCYVic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760513AbYCYVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:31 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 09/20] x86: move dma_sync_single_range_for_device to common header
Date: Tue, 25 Mar 2008 18:36:28 -0300
Message-Id: <1206480999-21767-10-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-9-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 gets an empty function

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |    1 +
 include/asm-x86/dma-mapping.h    |   14 ++++++++++++++
 include/asm-x86/dma-mapping_32.h |    8 --------
 include/asm-x86/dma-mapping_64.h |   12 ------------
 4 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index c501599..4512c30 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -38,6 +38,7 @@ static const struct dma_mapping_ops pci32_dma_ops = {
 	.sync_single_for_cpu = NULL,
 	.sync_single_for_device = NULL,
 	.sync_single_range_for_cpu = NULL,
+	.sync_single_range_for_device = NULL,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a466470..260538b 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -125,4 +125,18 @@ dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 
 	flush_write_buffers();
 }
+
+static inline void
+dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
+				 unsigned long offset, size_t size,
+				 int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	if (dma_ops->sync_single_range_for_device)
+		dma_ops->sync_single_range_for_device(hwdev, dma_handle,
+						      offset, size, direction);
+
+	flush_write_buffers();
+}
+
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index e24c59d..60d5371 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -33,14 +33,6 @@ dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
 }
 
 static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-static inline void
 dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 		    enum dma_data_direction direction)
 {
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 6ecafad..dfa66cc 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -29,18 +29,6 @@ extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 #define dma_unmap_page dma_unmap_single
 
 static inline void
-dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size, int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_device)
-		dma_ops->sync_single_range_for_device(hwdev, dma_handle,
-						      offset, size, direction);
-
-	flush_write_buffers();
-}
-
-static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 		    int nelems, int direction)
 {
-- 
1.5.0.6

