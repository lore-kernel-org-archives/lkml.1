Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZCFNbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZCFNbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCFNat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:49 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:19962 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753864AbZCFNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:46 -0500
X-BigFish: VPS1(zzzzzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG36US-02-TL2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/18] dma-debug: add hash functions for dma_debug_entries
Date: Fri, 6 Mar 2009 14:30:14 +0100
Message-ID: <1236346229-6618-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0073 (UTC) FILETIME=[B7DF8290:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: implement necessary functions for the core hash

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 3109971..5ff7d2e 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -18,9 +18,14 @@
  */
 
 #include <linux/dma-debug.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/list.h>
 
+#define HASH_SIZE       1024ULL
+#define HASH_FN_SHIFT   13
+#define HASH_FN_MASK    (HASH_SIZE - 1)
+
 enum {
 	dma_debug_single,
 	dma_debug_page,
@@ -40,3 +45,99 @@ struct dma_debug_entry {
 	int		 sg_mapped_ents;
 };
 
+struct hash_bucket {
+	struct list_head list;
+	spinlock_t lock;
+} __cacheline_aligned_in_smp;
+
+/* Hash list to save the allocated dma addresses */
+static struct hash_bucket dma_entry_hash[HASH_SIZE];
+
+/*
+ * Hash related functions
+ *
+ * Every DMA-API request is saved into a struct dma_debug_entry. To
+ * have quick access to these structs they are stored into a hash.
+ */
+static int hash_fn(struct dma_debug_entry *entry)
+{
+	/*
+	 * Hash function is based on the dma address.
+	 * We use bits 20-27 here as the index into the hash
+	 */
+	return (entry->dev_addr >> HASH_FN_SHIFT) & HASH_FN_MASK;
+}
+
+/*
+ * Request exclusive access to a hash bucket for a given dma_debug_entry.
+ */
+static struct hash_bucket *get_hash_bucket(struct dma_debug_entry *entry,
+					   unsigned long *flags)
+{
+	int idx = hash_fn(entry);
+	unsigned long __flags;
+
+	spin_lock_irqsave(&dma_entry_hash[idx].lock, __flags);
+	*flags = __flags;
+	return &dma_entry_hash[idx];
+}
+
+/*
+ * Give up exclusive access to the hash bucket
+ */
+static void put_hash_bucket(struct hash_bucket *bucket,
+			    unsigned long *flags)
+{
+	unsigned long __flags = *flags;
+
+	spin_unlock_irqrestore(&bucket->lock, __flags);
+}
+
+/*
+ * Search a given entry in the hash bucket list
+ */
+static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
+						struct dma_debug_entry *ref)
+{
+	struct dma_debug_entry *entry;
+
+	list_for_each_entry(entry, &bucket->list, list) {
+		if ((entry->dev_addr == ref->dev_addr) &&
+		    (entry->dev == ref->dev))
+			return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ * Add an entry to a hash bucket
+ */
+static void hash_bucket_add(struct hash_bucket *bucket,
+			    struct dma_debug_entry *entry)
+{
+	list_add_tail(&entry->list, &bucket->list);
+}
+
+/*
+ * Remove entry from a hash bucket list
+ */
+static void hash_bucket_del(struct dma_debug_entry *entry)
+{
+	list_del(&entry->list);
+}
+
+/*
+ * Wrapper function for adding an entry to the hash.
+ * This function takes care of locking itself.
+ */
+static void add_dma_entry(struct dma_debug_entry *entry)
+{
+	struct hash_bucket *bucket;
+	unsigned long flags;
+
+	bucket = get_hash_bucket(entry, &flags);
+	hash_bucket_add(bucket, entry);
+	put_hash_bucket(bucket, &flags);
+}
+
-- 
1.5.6.4


