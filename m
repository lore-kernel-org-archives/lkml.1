Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZCFNbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZCFNbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZCFNas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:48 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:42635
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896AbZCFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:46 -0500
X-BigFish: VPS11(zz9321rzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG36UV-01-JKZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/18] dma-debug: add initialization code
Date: Fri, 6 Mar 2009 14:30:16 +0100
Message-ID: <1236346229-6618-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0089 (UTC) FILETIME=[B7E1F390:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add code to initialize dma-debug core data structures

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/dma-debug.h |   14 +++++++++
 lib/dma-debug.c           |   66 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index ce4ace7..345d538 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -20,6 +20,20 @@
 #ifndef __DMA_DEBUG_H
 #define __DMA_DEBUG_H
 
+#include <linux/types.h>
+
 struct device;
 
+#ifdef CONFIG_DMA_API_DEBUG
+
+extern void dma_debug_init(u32 num_entries);
+
+#else /* CONFIG_DMA_API_DEBUG */
+
+static inline void dma_debug_init(u32 num_entries)
+{
+}
+
+#endif /* CONFIG_DMA_API_DEBUG */
+
 #endif /* __DMA_DEBUG_H */
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index b609146..5b50bb3 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -21,6 +21,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 #define HASH_SIZE       1024ULL
 #define HASH_FN_SHIFT   13
@@ -198,3 +199,68 @@ static void dma_entry_free(struct dma_debug_entry *entry)
 	spin_unlock_irqrestore(&free_entries_lock, flags);
 }
 
+/*
+ * DMA-API debugging init code
+ *
+ * The init code does two things:
+ *   1. Initialize core data structures
+ *   2. Preallocate a given number of dma_debug_entry structs
+ */
+
+static int prealloc_memory(u32 num_entries)
+{
+	struct dma_debug_entry *entry, *next_entry;
+	int i;
+
+	for (i = 0; i < num_entries; ++i) {
+		entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+		if (!entry)
+			goto out_err;
+
+		list_add_tail(&entry->list, &free_entries);
+	}
+
+	num_free_entries = num_entries;
+	min_free_entries = num_entries;
+
+	printk(KERN_INFO "DMA-API: preallocated %d debug entries\n",
+			num_entries);
+
+	return 0;
+
+out_err:
+
+	list_for_each_entry_safe(entry, next_entry, &free_entries, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+
+	return -ENOMEM;
+}
+
+/*
+ * Let the architectures decide how many entries should be preallocated.
+ */
+void dma_debug_init(u32 num_entries)
+{
+	int i;
+
+	if (global_disable)
+		return;
+
+	for (i = 0; i < HASH_SIZE; ++i) {
+		INIT_LIST_HEAD(&dma_entry_hash[i].list);
+		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
+	}
+
+	if (prealloc_memory(num_entries) != 0) {
+		printk(KERN_ERR "DMA-API: debugging out of memory error "
+				"- disabled\n");
+		global_disable = true;
+
+		return;
+	}
+
+	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
+}
+
-- 
1.5.6.4


