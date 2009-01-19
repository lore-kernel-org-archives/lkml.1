Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZASOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZASOxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZASOr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:29 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:39674 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZASOr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:27 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QJ-03-6AK-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/16] dma-debug: add checks for sync_single_sg_*
Date: Mon, 19 Jan 2009 15:47:01 +0100
Message-ID: <1232376423-11067-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:04.0110 (UTC) FILETIME=[CB216CE0:01C97A44]
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
index 4daaa82..8a8aae4 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -67,6 +67,14 @@ extern void debug_dma_sync_single_range_for_device(struct device *dev,
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
@@ -135,6 +143,18 @@ static inline void debug_dma_sync_single_range_for_device(struct device *dev,
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
index 125b6a2..469e5b9 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -719,3 +719,35 @@ void debug_dma_sync_single_range_for_device(struct device *dev,
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


