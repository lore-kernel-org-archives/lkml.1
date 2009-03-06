Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZCFNdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZCFNdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZCFNaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:55 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:38444
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754048AbZCFNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:48 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG36UW-01-JL0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [PATCH 15/18] dma-debug: add function to dump dma mappings
Date: Fri, 6 Mar 2009 14:30:26 +0100
Message-ID: <1236346229-6618-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0464 (UTC) FILETIME=[B81B2C00:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

This adds a function to dump the DMA mappings that the debugging code is
aware of -- either for a single device, or for _all_ devices.

This can be useful for debugging -- sticking a call to it in the DMA
page fault handler, for example, to see if the faulting address _should_
be mapped or not, and hence work out whether it's IOMMU bugs we're
seeing, or driver bugs.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/dma-debug.h |    6 ++++++
 lib/dma-debug.c           |   30 ++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 4985c6c..46a11c1 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -76,6 +76,8 @@ extern void debug_dma_sync_sg_for_device(struct device *dev,
 					 struct scatterlist *sg,
 					 int nelems, int direction);
 
+extern void debug_dma_dump_mappings(struct device *dev);
+
 #else /* CONFIG_DMA_API_DEBUG */
 
 static inline void dma_debug_init(u32 num_entries)
@@ -156,6 +158,10 @@ static inline void debug_dma_sync_sg_for_device(struct device *dev,
 {
 }
 
+static inline void debug_dma_dump_mappings(struct device *dev)
+{
+}
+
 #endif /* CONFIG_DMA_API_DEBUG */
 
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9d11e89..1b6b650 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -194,6 +194,36 @@ static void hash_bucket_del(struct dma_debug_entry *entry)
 }
 
 /*
+ * Dump mapping entries for debugging purposes
+ */
+void debug_dma_dump_mappings(struct device *dev)
+{
+	int idx;
+
+	for (idx = 0; idx < HASH_SIZE; idx++) {
+		struct hash_bucket *bucket = &dma_entry_hash[idx];
+		struct dma_debug_entry *entry;
+		unsigned long flags;
+
+		spin_lock_irqsave(&bucket->lock, flags);
+
+		list_for_each_entry(entry, &bucket->list, list) {
+			if (!dev || dev == entry->dev) {
+				dev_info(entry->dev,
+					 "%s idx %d P=%Lx D=%Lx L=%Lx %s\n",
+					 type2name[entry->type], idx,
+					 (unsigned long long)entry->paddr,
+					 entry->dev_addr, entry->size,
+					 dir2name[entry->direction]);
+			}
+		}
+
+			spin_unlock_irqrestore(&bucket->lock, flags);
+	}
+}
+EXPORT_SYMBOL(debug_dma_dump_mappings);
+
+/*
  * Wrapper function for adding an entry to the hash.
  * This function takes care of locking itself.
  */
-- 
1.5.6.4


