Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbZASOwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbZASOwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZASOr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:29 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54871 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZASOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:25 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QE-04-LPV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/16] dma-debug: add hash functions for dma_debug_entries
Date: Mon, 19 Jan 2009 15:46:50 +0100
Message-ID: <1232376423-11067-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0860 (UTC) FILETIME=[CAFB4740:01C97A44]
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
index c944b8c..a90f9c4 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -18,9 +18,14 @@
  */
 
 #include <linux/dma-debug.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/list.h>
 
+#define HASH_SIZE       256
+#define HASH_FN_SHIFT   13
+#define HASH_FN_MASK    0xffULL
+
 enum {
 	dma_debug_single,
 	dma_debug_page,
@@ -38,3 +43,99 @@ struct dma_debug_entry {
 	int              direction;
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


