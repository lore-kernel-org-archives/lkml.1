Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbZASOvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbZASOvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZASOrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:25 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:19022 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752374AbZASOrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:20 -0500
X-BigFish: VPS3(zzzzzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QF-02-0BC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/16] dma-debug: add checks for sync_single_range_*
Date: Mon, 19 Jan 2009 15:47:00 +0100
Message-ID: <1232376423-11067-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0094 (UTC) FILETIME=[CB1EFBE0:01C97A44]
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
index fea15f3..4daaa82 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -56,6 +56,17 @@ extern void debug_dma_sync_single_for_device(struct device *dev,
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
@@ -108,6 +119,22 @@ static inline void debug_dma_sync_single_for_device(struct device *dev,
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
index 9715f40..125b6a2 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -695,3 +695,27 @@ void debug_dma_sync_single_for_device(struct device *dev,
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


