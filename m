Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZCFNft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZCFNft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:35:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZCFNbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:31:03 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25466 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbZCFNav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:51 -0500
X-BigFish: VPS1(zzzzzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KG36UX-01-JL3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/18] dma-debug: add checks for sync_single_range_*
Date: Fri, 6 Mar 2009 14:30:24 +0100
Message-ID: <1236346229-6618-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0401 (UTC) FILETIME=[B8118F10:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_sync_single_range_for_* functions

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   27 +++++++++++++++++++++++++++
 lib/dma-debug.c           |   24 ++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 0eee7af..e9b9035 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -57,6 +57,17 @@ extern void debug_dma_sync_single_for_device(struct device *dev,
 					     dma_addr_t dma_handle,
 					     size_t size, int direction);
 
+extern void debug_dma_sync_single_range_for_cpu(struct device *dev,
+						dma_addr_t dma_handle,
+						unsigned long offset,
+						size_t size,
+						int direction);
+
+extern void debug_dma_sync_single_range_for_device(struct device *dev,
+						   dma_addr_t dma_handle,
+						   unsigned long offset,
+						   size_t size, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -109,6 +120,22 @@ static inline void debug_dma_sync_single_for_device(struct device *dev,
 {
 }
 
+static inline void debug_dma_sync_single_range_for_cpu(struct device *dev,
+						       dma_addr_t dma_handle,
+						       unsigned long offset,
+						       size_t size,
+						       int direction)
+{
+}
+
+static inline void debug_dma_sync_single_range_for_device(struct device *dev,
+							  dma_addr_t dma_handle,
+							  unsigned long offset,
+							  size_t size,
+							  int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 714cfb6..d1c0ac1 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -758,3 +758,27 @@ void debug_dma_sync_single_for_device(struct device *dev,
 }
 EXPORT_SYMBOL(debug_dma_sync_single_for_device);
 
+void debug_dma_sync_single_range_for_cpu(struct device *dev,
+					 dma_addr_t dma_handle,
+					 unsigned long offset, size_t size,
+					 int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, true);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_range_for_cpu);
+
+void debug_dma_sync_single_range_for_device(struct device *dev,
+					    dma_addr_t dma_handle,
+					    unsigned long offset,
+					    size_t size, int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, offset, direction, false);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_range_for_device);
+
-- 
1.5.6.4


