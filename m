Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZASOsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZASOsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZASOrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:19 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38677 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbZASOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:17 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QH-03-6AG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
Date: Mon, 19 Jan 2009 15:46:56 +0100
Message-ID: <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0969 (UTC) FILETIME=[CB0BE910:01C97A44]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_{un}map_[page|single]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   23 ++++++++++++++++++++
 lib/dma-debug.c           |   51 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 345d538..ea6a283 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -28,12 +28,35 @@ struct device;
 
 extern void dma_debug_init(u32 num_entries);
 
+extern void debug_dma_map_page(struct device *dev, struct page *page,
+			       size_t offset, size_t size,
+			       int direction, dma_addr_t dma_addr,
+			       bool map_single);
+
+extern void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+				 size_t size, int direction, bool map_single);
+
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
 {
 }
 
+static inline void debug_dma_map_page(struct device *dev, struct page *page,
+				      size_t offset size_t size,
+				      int direction, dma_addr_t dma_addr,
+				      bool map_single)
+{
+}
+
+static inline void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+					size_t size, int direction,
+					bool map_single)
+{
+}
+
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 4d98811..9219c41 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -525,3 +525,54 @@ out:
 
 }
 
+void debug_dma_map_page(struct device *dev, struct page *page, size_t offset,
+			size_t size, int direction, dma_addr_t dma_addr,
+			bool map_single)
+{
+	struct dma_debug_entry *entry;
+
+	if (unlikely(global_disable))
+		return;
+
+	if (unlikely(dma_mapping_error(dev, dma_addr)))
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->dev       = dev;
+	entry->type      = dma_debug_page;
+	entry->paddr     = page_to_phys(page) + offset;
+	entry->dev_addr  = dma_addr;
+	entry->size      = size;
+	entry->direction = direction;
+
+	if (map_single)
+		entry->type = dma_debug_single;
+
+	add_dma_entry(entry);
+}
+EXPORT_SYMBOL(debug_dma_map_page);
+
+void debug_dma_unmap_page(struct device *dev, dma_addr_t addr,
+			  size_t size, int direction, bool map_single)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_page,
+		.dev            = dev,
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = direction,
+	};
+
+	if (unlikely(global_disable))
+		return;
+
+	if (map_single)
+		ref.type = dma_debug_single;
+
+	check_unmap(&ref);
+}
+EXPORT_SYMBOL(debug_dma_unmap_page);
+
-- 
1.5.6.4


