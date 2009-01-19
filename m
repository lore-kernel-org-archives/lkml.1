Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbZASOyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbZASOyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbZASOrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:33 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:55491 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZASOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:32 -0500
X-BigFish: VPS7(z523lzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QH-04-LQ3-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/16] dma-debug: add checking for [alloc|free]_coherent
Date: Mon, 19 Jan 2009 15:46:58 +0100
Message-ID: <1232376423-11067-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0032 (UTC) FILETIME=[CB158600:01C97A44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_[alloc|free]_coherent

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   16 ++++++++++++++++
 lib/dma-debug.c           |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 61f559d..15fa361 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -42,6 +42,12 @@ extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
 extern void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			       int nelems, int dir);
 
+extern void debug_dma_alloc_coherent(struct device *dev, size_t size,
+				     dma_addr_t dma_addr, void *virt);
+
+extern void debug_dma_free_coherent(struct device *dev, size_t size,
+				    void *virt, dma_addr_t addr);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -72,6 +78,16 @@ static inline void debug_dma_unmap_sg(struct device *dev,
 {
 }
 
+static inline void debug_dma_alloc_coherent(struct device *dev, size_t size,
+					    dma_addr_t dma_addr, void *virt)
+{
+}
+
+static inline void debug_dma_free_coherent(struct device *dev, size_t size,
+					   void *virt, dma_addr_t addr)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index f3e0145..01a79d1 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -629,3 +629,48 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 }
 EXPORT_SYMBOL(debug_dma_unmap_sg);
 
+void debug_dma_alloc_coherent(struct device *dev, size_t size,
+			      dma_addr_t dma_addr, void *virt)
+{
+	struct dma_debug_entry *entry;
+
+	if (unlikely(global_disable))
+		return;
+
+	if (unlikely(virt == NULL))
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->type      = dma_debug_coherent;
+	entry->dev       = dev;
+	entry->paddr     = virt_to_phys(virt);
+	entry->size      = size;
+	entry->dev_addr  = dma_addr;
+	entry->direction = DMA_BIDIRECTIONAL;
+
+	add_dma_entry(entry);
+}
+EXPORT_SYMBOL(debug_dma_alloc_coherent);
+
+void debug_dma_free_coherent(struct device *dev, size_t size,
+			 void *virt, dma_addr_t addr)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_coherent,
+		.dev            = dev,
+		.paddr          = virt_to_phys(virt),
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = DMA_BIDIRECTIONAL,
+	};
+
+	if (unlikely(global_disable))
+		return;
+
+	check_unmap(&ref);
+}
+EXPORT_SYMBOL(debug_dma_free_coherent);
+
-- 
1.5.6.4


