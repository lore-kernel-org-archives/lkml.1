Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbZCFNdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbZCFNdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZCFNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:53 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42799 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753399AbZCFNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:48 -0500
X-BigFish: VPS1(zzzzzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UV-01-JKY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/18] dma-debug: add allocator code
Date: Fri, 6 Mar 2009 14:30:15 +0100
Message-ID: <1236346229-6618-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0073 (UTC) FILETIME=[B7DF8290:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add allocator code for struct dma_debug_entry

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 5ff7d2e..b609146 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -52,6 +52,16 @@ struct hash_bucket {
 
 /* Hash list to save the allocated dma addresses */
 static struct hash_bucket dma_entry_hash[HASH_SIZE];
+/* List of pre-allocated dma_debug_entry's */
+static LIST_HEAD(free_entries);
+/* Lock for the list above */
+static DEFINE_SPINLOCK(free_entries_lock);
+
+/* Global disable flag - will be set in case of an error */
+static bool global_disable __read_mostly;
+
+static u32 num_free_entries;
+static u32 min_free_entries;
 
 /*
  * Hash related functions
@@ -141,3 +151,50 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 	put_hash_bucket(bucket, &flags);
 }
 
+/* struct dma_entry allocator
+ *
+ * The next two functions implement the allocator for
+ * struct dma_debug_entries.
+ */
+static struct dma_debug_entry *dma_entry_alloc(void)
+{
+	struct dma_debug_entry *entry = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_entries_lock, flags);
+
+	if (list_empty(&free_entries)) {
+		printk(KERN_ERR "DMA-API: debugging out of memory "
+				"- disabling\n");
+		global_disable = true;
+		goto out;
+	}
+
+	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
+	list_del(&entry->list);
+	memset(entry, 0, sizeof(*entry));
+
+	num_free_entries -= 1;
+	if (num_free_entries < min_free_entries)
+		min_free_entries = num_free_entries;
+
+out:
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+
+	return entry;
+}
+
+static void dma_entry_free(struct dma_debug_entry *entry)
+{
+	unsigned long flags;
+
+	/*
+	 * add to beginning of the list - this way the entries are
+	 * more likely cache hot when they are reallocated.
+	 */
+	spin_lock_irqsave(&free_entries_lock, flags);
+	list_add(&entry->list, &free_entries);
+	num_free_entries += 1;
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+}
+
-- 
1.5.6.4


