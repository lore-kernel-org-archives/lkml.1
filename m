Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZCFNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZCFNbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZCFNar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:47 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25116 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbZCFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:46 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KG36UZ-03-1UU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/18] dma-debug: add checks for sync_single_sg_*
Date: Fri, 6 Mar 2009 14:30:25 +0100
Message-ID: <1236346229-6618-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0433 (UTC) FILETIME=[B8167110:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debug callbacks for dma_sync_sg_* functions

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   20 ++++++++++++++++++++
 lib/dma-debug.c           |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index e9b9035..4985c6c 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -68,6 +68,14 @@ extern void debug_dma_sync_single_range_for_device(struct device *dev,
 						   unsigned long offset,
 						   size_t size, int direction);
 
+extern void debug_dma_sync_sg_for_cpu(struct device *dev,
+				      struct scatterlist *sg,
+				      int nelems, int direction);
+
+extern void debug_dma_sync_sg_for_device(struct device *dev,
+					 struct scatterlist *sg,
+					 int nelems, int direction);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -136,6 +144,18 @@ static inline void debug_dma_sync_single_range_for_device(struct device *dev,
 {
 }
 
+static inline void debug_dma_sync_sg_for_cpu(struct device *dev,
+					     struct scatterlist *sg,
+					     int nelems, int direction)
+{
+}
+
+static inline void debug_dma_sync_sg_for_device(struct device *dev,
+						struct scatterlist *sg,
+						int nelems, int direction)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d1c0ac1..9d11e89 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -782,3 +782,35 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
 }
 EXPORT_SYMBOL(debug_dma_sync_single_range_for_device);
 
+void debug_dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+			       int nelems, int direction)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, nelems, i) {
+		check_sync(dev, s->dma_address, s->dma_length, 0,
+				direction, true);
+	}
+}
+EXPORT_SYMBOL(debug_dma_sync_sg_for_cpu);
+
+void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				  int nelems, int direction)
+{
+	struct scatterlist *s;
+	int i;
+
+	if (unlikely(global_disable))
+		return;
+
+	for_each_sg(sg, s, nelems, i) {
+		check_sync(dev, s->dma_address, s->dma_length, 0,
+				direction, false);
+	}
+}
+EXPORT_SYMBOL(debug_dma_sync_sg_for_device);
+
-- 
1.5.6.4


