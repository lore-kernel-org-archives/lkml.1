Return-Path: <linux-kernel-owner+w=401wt.eu-S1761986AbYCYVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986AbYCYVmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbYCYVit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760756AbYCYVir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:47 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 08/20] x86: move dma_sync_single_range_for_cpu to common header
Date: Tue, 25 Mar 2008 18:36:27 -0300
Message-Id: <1206480999-21767-9-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-8-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 gets an empty function

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-base_32.c    |    1 +
 include/asm-x86/dma-mapping.h    |   11 +++++++++++
 include/asm-x86/dma-mapping_32.h |    7 -------
 include/asm-x86/dma-mapping_64.h |   12 ------------
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/pci-base_32.c b/arch/x86/kernel/pci-base_32.c
index 3648824..c501599 100644
--- a/arch/x86/kernel/pci-base_32.c
+++ b/arch/x86/kernel/pci-base_32.c
@@ -37,6 +37,7 @@ static const struct dma_mapping_ops pci32_dma_ops = {
 	.unmap_sg = NULL,
 	.sync_single_for_cpu = NULL,
 	.sync_single_for_device = NULL,
+	.sync_single_range_for_cpu = NULL,
 };
 
 const struct dma_mapping_ops *dma_ops = &pci32_dma_ops;
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 8ad582c..a466470 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -114,4 +114,15 @@ dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 	flush_write_buffers();
 }
 
+static inline void
+dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
+			      unsigned long offset, size_t size, int direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+	if (dma_ops->sync_single_range_for_cpu)
+		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
+						   size, direction);
+
+	flush_write_buffers();
+}
 #endif
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index b91771a..e24c59d 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -33,13 +33,6 @@ dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
 }
 
 static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-}
-
-static inline void
 dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size,
 				 enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index b539f61..6ecafad 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -29,18 +29,6 @@ extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 #define dma_unmap_page dma_unmap_single
 
 static inline void
-dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size, int direction)
-{
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_cpu) {
-		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset, size, direction);
-	}
-
-	flush_write_buffers();
-}
-
-static inline void
 dma_sync_single_range_for_device(struct device *hwdev, dma_addr_t dma_handle,
 				 unsigned long offset, size_t size, int direction)
 {
-- 
1.5.0.6

