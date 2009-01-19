Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZASOrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZASOrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZASOrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:17 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:53989 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZASOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:15 -0500
X-BigFish: VPS13(zz9321rzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QC-02-0B4-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/16] dma-debug: add initialization code
Date: Mon, 19 Jan 2009 15:46:52 +0100
Message-ID: <1232376423-11067-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0844 (UTC) FILETIME=[CAF8D640:01C97A44]
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
index c9e44e8..d46c76e 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -21,6 +21,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 #define HASH_SIZE       256
 #define HASH_FN_SHIFT   13
@@ -196,3 +197,68 @@ static void dma_entry_free(struct dma_debug_entry *entry)
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


