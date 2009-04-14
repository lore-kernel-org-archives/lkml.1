Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZDNApd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZDNApd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZDNAo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:44:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:49852 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZDNAo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:44:56 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/2] dma-debug: add dma_debug_resize_entries() to adjust the number of dma_debug_entries
Date: Tue, 14 Apr 2009 09:43:18 +0900
Message-Id: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 14 Apr 2009 09:44:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use a static value for the number of dma_debug_entries. It can be
overwritten by a kernel command line option.

Some IOMMUs (e.g. GART) can't set an appropriate value by a kernel
command line option because they can't know such value until they
finish initializing up their hardware.

This patch adds dma_debug_resize_entries() enables IOMMUs to adjust
the number of dma_debug_entries anytime.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-debug.h |    7 +++++
 lib/dma-debug.c           |   67 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
index 28d53cb..171ad8a 100644
--- a/include/linux/dma-debug.h
+++ b/include/linux/dma-debug.h
@@ -32,6 +32,8 @@ extern void dma_debug_add_bus(struct bus_type *bus);
 
 extern void dma_debug_init(u32 num_entries);
 
+extern int dma_debug_resize_entries(u32 num_entries);
+
 extern void debug_dma_map_page(struct device *dev, struct page *page,
 			       size_t offset, size_t size,
 			       int direction, dma_addr_t dma_addr,
@@ -91,6 +93,11 @@ static inline void dma_debug_init(u32 num_entries)
 {
 }
 
+static inline int dma_debug_resize_entries(u32 num_entries)
+{
+	return 0;
+}
+
 static inline void debug_dma_map_page(struct device *dev, struct page *page,
 				      size_t offset, size_t size,
 				      int direction, dma_addr_t dma_addr,
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index d3da7ed..01439e6 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -85,6 +85,7 @@ static u32 show_num_errors = 1;
 
 static u32 num_free_entries;
 static u32 min_free_entries;
+static u32 nr_total_entries;
 
 /* number of preallocated entries requested by kernel cmdline */
 static u32 req_entries;
@@ -257,6 +258,21 @@ static void add_dma_entry(struct dma_debug_entry *entry)
 	put_hash_bucket(bucket, &flags);
 }
 
+static struct dma_debug_entry *__dma_entry_alloc(void)
+{
+	struct dma_debug_entry *entry;
+
+	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
+	list_del(&entry->list);
+	memset(entry, 0, sizeof(*entry));
+
+	num_free_entries -= 1;
+	if (num_free_entries < min_free_entries)
+		min_free_entries = num_free_entries;
+
+	return entry;
+}
+
 /* struct dma_entry allocator
  *
  * The next two functions implement the allocator for
@@ -276,9 +292,7 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 		goto out;
 	}
 
-	entry = list_entry(free_entries.next, struct dma_debug_entry, list);
-	list_del(&entry->list);
-	memset(entry, 0, sizeof(*entry));
+	entry = __dma_entry_alloc();
 
 #ifdef CONFIG_STACKTRACE
 	entry->stacktrace.max_entries = DMA_DEBUG_STACKTRACE_ENTRIES;
@@ -286,9 +300,6 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	entry->stacktrace.skip = 2;
 	save_stack_trace(&entry->stacktrace);
 #endif
-	num_free_entries -= 1;
-	if (num_free_entries < min_free_entries)
-		min_free_entries = num_free_entries;
 
 out:
 	spin_unlock_irqrestore(&free_entries_lock, flags);
@@ -310,6 +321,48 @@ static void dma_entry_free(struct dma_debug_entry *entry)
 	spin_unlock_irqrestore(&free_entries_lock, flags);
 }
 
+int dma_debug_resize_entries(u32 num_entries)
+{
+	int i, delta, ret = 0;
+	unsigned long flags;
+	struct dma_debug_entry *entry;
+
+	spin_lock_irqsave(&free_entries_lock, flags);
+
+	if (nr_total_entries < num_entries) {
+		delta = num_entries - nr_total_entries;
+
+		for (i = 0; i < delta; i++) {
+			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+			if (!entry)
+				break;
+
+			list_add_tail(&entry->list, &free_entries);
+		}
+
+		nr_total_entries += i;
+		num_free_entries += i;
+
+	} else {
+		delta = nr_total_entries - num_entries;
+
+		for (i = 0; i < delta && !list_empty(&free_entries); i++) {
+			entry = __dma_entry_alloc();
+			kfree(entry);
+		}
+
+		nr_total_entries -= i;
+	}
+
+	if (nr_total_entries != num_entries)
+		ret = 1;
+
+	spin_unlock_irqrestore(&free_entries_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(dma_debug_resize_entries);
+
 /*
  * DMA-API debugging init code
  *
@@ -490,6 +543,8 @@ void dma_debug_init(u32 num_entries)
 		return;
 	}
 
+	nr_total_entries = num_free_entries;
+
 	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
 }
 
-- 
1.6.0.6

