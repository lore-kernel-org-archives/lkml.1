Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZCFNeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZCFNeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZCFNa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:56 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:7263 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754042AbZCFNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:48 -0500
X-BigFish: VPS1(zzzzzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UW-02-TL4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/18] dma-debug: add checks for sync_single_*
Date: Fri, 6 Mar 2009 14:30:23 +0100
Message-ID: <1236346229-6618-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0370 (UTC) FILETIME=[B80CD420:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_sync_single_for_* functions

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   20 ++++++++++++++++++++
 lib/dma-debug.c           |   21 +++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index cb72dfd..0eee7af 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -49,6 +49,14 @@ extern void debug_dma_alloc_coherent(struct device *dev, size_t size,
 extern void debug_dma_free_coherent(struct device *dev, size_t size,
 				    void *virt, dma_addr_t addr);
 
+extern void debug_dma_sync_single_for_cpu(struct device *dev,
+					  dma_addr_t dma_handle, size_t size,
+					  int direction);
+
+extern void debug_dma_sync_single_for_device(struct device *dev,
+					     dma_addr_t dma_handle,
+					     size_t size, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -89,6 +97,18 @@ static inline void debug_dma_free_coherent(struct device *dev, size_t size,
 {
 }
 
+static inline void debug_dma_sync_single_for_cpu(struct device *dev,
+						 dma_addr_t dma_handle,
+						 size_t size, int direction)
+{
+}
+
+static inline void debug_dma_sync_single_for_device(struct device *dev,
+						    dma_addr_t dma_handle,
+						    size_t size, int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 44af837..714cfb6 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -737,3 +737,24 @@ void debug_dma_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(debug_dma_free_coherent);
 
+void debug_dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   size_t size, int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, true);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_for_cpu);
+
+void debug_dma_sync_single_for_device(struct device *dev,
+				      dma_addr_t dma_handle, size_t size,
+				      int direction)
+{
+	if (unlikely(global_disable))
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, false);
+}
+EXPORT_SYMBOL(debug_dma_sync_single_for_device);
+
-- 
1.5.6.4


