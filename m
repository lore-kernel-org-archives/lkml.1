Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZASOuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZASOuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZASOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:23 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54331 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZASOrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:19 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KDQ3QI-03-6AI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/16] dma-debug: add checks for sync_single_*
Date: Mon, 19 Jan 2009 15:46:59 +0100
Message-ID: <1232376423-11067-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0063 (UTC) FILETIME=[CB1A40F0:01C97A44]
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
index 15fa361..fea15f3 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -48,6 +48,14 @@ extern void debug_dma_alloc_coherent(struct device *dev, size_t size,
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
@@ -88,6 +96,18 @@ static inline void debug_dma_free_coherent(struct device *dev, size_t size,
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
index 01a79d1..9715f40 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -674,3 +674,24 @@ void debug_dma_free_coherent(struct device *dev, size_t size,
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


