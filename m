Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbZCFNhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbZCFNhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZCFNbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:31:08 -0500
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:52039
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753874AbZCFNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:31:04 -0500
X-BigFish: VPS5(z523lzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UX-03-1US-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/18] dma-debug: add checking for [alloc|free]_coherent
Date: Fri, 6 Mar 2009 14:30:22 +0100
Message-ID: <1236346229-6618-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0339 (UTC) FILETIME=[B8081930:01C99E5F]
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
index ee9fdb3..cb72dfd 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -43,6 +43,12 @@ extern void debug_dma_map_sg(struct device *dev, struct scatterlist *sg,
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
@@ -73,6 +79,16 @@ static inline void debug_dma_unmap_sg(struct device *dev,
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
index 26e40e9..44af837 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -692,3 +692,48 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
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


