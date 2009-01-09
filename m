Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZAIQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZAIQYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZAIQUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:20:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:45975 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZAIQTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:19:48 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KD7PCI-03-IX1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/16] dma-debug: add checking for map/unmap_single
Date: Fri, 9 Jan 2009 17:19:23 +0100
Message-ID: <1231517970-20288-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0795 (UTC) FILETIME=[0D14E3B0:01C97276]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_{un}map_single

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   19 +++++++++++++++++++
 lib/dma-debug.c           |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 345d538..82ae9ca 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -28,12 +28,31 @@ struct device;
 
 extern void dma_debug_init(u32 num_entries);
 
+extern void debug_map_single(struct device *dev, void *ptr, size_t size,
+			     int direction, dma_addr_t dma_addr);
+
+extern void debug_unmap_single(struct device *dev, dma_addr_t addr,
+			       size_t size, int direction);
+
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
 {
 }
 
+static inline void debug_map_single(struct device *dev, void *ptr,
+				    size_t size, int direction,
+				    dma_addr_t dma_addr)
+{
+}
+
+static inline void debug_unmap_single(struct device *dev, dma_addr_t addr,
+				      size_t size, int direction)
+{
+}
+
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9f730a4..d4d14e5 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -510,3 +510,44 @@ out:
 
 }
 
+void debug_map_single(struct device *dev, void *ptr, size_t size,
+		      int direction, dma_addr_t dma_addr)
+{
+	struct dma_debug_entry *entry;
+
+	if (global_disable)
+		return;
+
+	entry = dma_entry_alloc();
+	if (!entry)
+		return;
+
+	entry->dev       = dev;
+	entry->type      = dma_debug_single;
+	entry->cpu_addr  = ptr;
+	entry->dev_addr  = dma_addr;
+	entry->size      = size;
+	entry->direction = direction;
+
+	add_dma_entry(entry);
+}
+EXPORT_SYMBOL(debug_map_single);
+
+void debug_unmap_single(struct device *dev, dma_addr_t addr,
+			size_t size, int direction)
+{
+	struct dma_debug_entry ref = {
+		.type           = dma_debug_single,
+		.dev            = dev,
+		.dev_addr       = addr,
+		.size           = size,
+		.direction      = direction,
+	};
+
+	if (global_disable)
+		return;
+
+	check_unmap(&ref);
+}
+EXPORT_SYMBOL(debug_unmap_single);
+
-- 
1.5.6.4


