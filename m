Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZAIQYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZAIQYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:24:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZAIQUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:20:31 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:46152 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZAIQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:19:48 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD7PCJ-03-IX3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/16] dma-debug: add checks for sync_single_*
Date: Fri, 9 Jan 2009 17:19:26 +0100
Message-ID: <1231517970-20288-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0808 (UTC) FILETIME=[0D16DF80:01C97276]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_sync_single_for_* functions

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   20 ++++++++++++++++++++
 lib/dma-debug.c           |   20 ++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index a28a701..f39c2a8 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -46,6 +46,14 @@ extern void debug_alloc_coherent(struct device *dev, size_t size,
 extern void debug_free_coherent(struct device *dev, size_t size,
 				void *virt, dma_addr_t addr);
 
+extern void debug_sync_single_for_cpu(struct device *dev,
+				      dma_addr_t dma_handle, size_t size,
+				      int direction);
+
+extern void debug_sync_single_for_device(struct device *dev,
+					 dma_addr_t dma_handle,
+					 size_t size, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -84,6 +92,18 @@ static inline void debug_free_coherent(struct device *dev, size_t size,
 {
 }
 
+static inline void debug_sync_single_for_cpu(struct device *dev,
+					     dma_addr_t dma_handle,
+					     size_t size, int direction)
+{
+}
+
+static inline void debug_sync_single_for_device(struct device *dev,
+						dma_addr_t dma_handle,
+						size_t size, int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index a4a5b0f..a7f2369 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -649,3 +649,23 @@ void debug_free_coherent(struct device *dev, size_t size,
 }
 EXPORT_SYMBOL(debug_free_coherent);
 
+void debug_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			       size_t size, int direction)
+{
+	if (global_disable)
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, true);
+}
+EXPORT_SYMBOL(debug_sync_single_for_cpu);
+
+void debug_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				  size_t size, int direction)
+{
+	if (global_disable)
+		return;
+
+	check_sync(dev, dma_handle, size, 0, direction, false);
+}
+EXPORT_SYMBOL(debug_sync_single_for_device);
+
-- 
1.5.6.4


