Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZASOxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZASOxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZASOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:30 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4032 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZASOr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:28 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KDQ3QF-04-LPY-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/16] dma-debug: add allocator code
Date: Mon, 19 Jan 2009 15:46:51 +0100
Message-ID: <1232376423-11067-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0844 (UTC) FILETIME=[CAF8D640:01C97A44]
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
index a90f9c4..c9e44e8 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -50,6 +50,16 @@ struct hash_bucket {
 
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
@@ -139,3 +149,50 @@ static void add_dma_entry(struct dma_debug_entry *entry)
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


