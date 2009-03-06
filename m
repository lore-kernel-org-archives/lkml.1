Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZCFNcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZCFNcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZCFNav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:51 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:7263 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754004AbZCFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:46 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UW-03-1UR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/18] dma-debug: add checking for map/unmap_page/single
Date: Fri, 6 Mar 2009 14:30:20 +0100
Message-ID: <1236346229-6618-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0292 (UTC) FILETIME=[B800ED40:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_{un}map_[page|single]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   23 +++++++++++++++++++
 lib/dma-debug.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 345d538..65f7352 100644
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
+				      size_t offset, size_t size,
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
index d0cb47a..a2ed2b7 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -566,3 +566,56 @@ out:
 
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
+	if (map_single) {
+		entry->type = dma_debug_single;
+		check_for_stack(dev, page_address(page) + offset);
+	}
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


