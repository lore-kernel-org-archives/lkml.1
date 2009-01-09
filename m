Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZAIQf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZAIQf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZAIQev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:34:51 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33581 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752504AbZAIQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:34:49 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 11:34:49 EST
X-BigFish: VPS3(zzzzzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KD7PCH-03-IWU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: mingo@redhat.com, dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/16] dma-debug: add allocator code
Date: Fri, 9 Jan 2009 17:19:18 +0100
Message-ID: <1231517970-20288-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
References: <1231517970-20288-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Jan 2009 16:19:30.0732 (UTC) FILETIME=[0D0B46C0:01C97276]
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
index 74a0f36..c5444d4 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -49,6 +49,16 @@ struct hash_bucket {
 
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
@@ -138,3 +148,50 @@ static void add_dma_entry(struct dma_debug_entry *entry)
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


