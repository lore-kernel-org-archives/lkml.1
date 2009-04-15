Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZDOJYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZDOJYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 05:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZDOJYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 05:24:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:35108 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZDOJYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 05:24:12 -0400
Date: Wed, 15 Apr 2009 18:22:41 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] dma-debug: add dma_debug_resize_entries() to
	adjust the number of dma_debug_entries
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090414105823.GL3558@elte.hu>
References: <1239669799-23579-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20090414105823.GL3558@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090415182234R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 15 Apr 2009 18:22:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 12:58:23 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > +int dma_debug_resize_entries(u32 num_entries)
> > +{
> > +	int i, delta, ret = 0;
> > +	unsigned long flags;
> > +	struct dma_debug_entry *entry;
> > +
> > +	spin_lock_irqsave(&free_entries_lock, flags);
> > +
> > +	if (nr_total_entries < num_entries) {
> > +		delta = num_entries - nr_total_entries;
> > +
> > +		for (i = 0; i < delta; i++) {
> > +			entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
> > +			if (!entry)
> > +				break;
> 
> hm, using GFP_ATOMIC within a spinlock is not a very nice thing to 
> do in general. While this is boot-only and the GFP_ATOMIC will 
> likely succeed, this could become non-boot functionality and then 
> it's exposed to the momentary VM pressure situation that might make 
> GFP_ATOMIC fail.
> 
> Please fix this to be GFP_KERNEL.

Ok, fixed though I'm not sure it matters. It's unlikely that this could
become non-boot functionality so I chose a simple way.

I've attached a fixed patch. It's unlikely that this function is
called concurrently so I don't try hard.


> a small detail:
> 
> > +		delta = nr_total_entries - num_entries;
> > +
> > +		for (i = 0; i < delta && !list_empty(&free_entries); i++) {
> > +			entry = __dma_entry_alloc();
> > +			kfree(entry);
> > +		}
> > +
> > +		nr_total_entries -= i;
> > +	}
> 
> Can i != delta ever happen? It would suggest the list length being 
> out of sync with the nr_total_entries counter.

Yes, it can happen because only free entries are linked to
free_entries list. If some entries are already used, then it's
possible that we can't find enough entries in free_entries list here.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] dma-debug: add dma_debug_resize_entries() to adjust the number of dma_debug_entries

We use a static value for the number of dma_debug_entries. It can be
overwritten by a kernel command line option.

Some IOMMUs (e.g. GART) can't set an appropriate value by a kernel
command line option because they can't know such value until they
finish initializing up their hardware.

This patch adds dma_debug_resize_entries() enables IOMMUs to adjust
the number of dma_debug_entries anytime.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-debug.h |    7 ++++
 lib/dma-debug.c           |   72 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 73 insertions(+), 6 deletions(-)

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
index d3da7ed..5d61019 100644
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
@@ -310,6 +321,53 @@ static void dma_entry_free(struct dma_debug_entry *entry)
 	spin_unlock_irqrestore(&free_entries_lock, flags);
 }
 
+int dma_debug_resize_entries(u32 num_entries)
+{
+	int i, delta, ret = 0;
+	unsigned long flags;
+	struct dma_debug_entry *entry;
+	LIST_HEAD(tmp);
+
+	spin_lock_irqsave(&free_entries_lock, flags);
+
+	if (nr_total_entries < num_entries) {
+		delta = num_entries - nr_total_entries;
+
+		spin_unlock_irqrestore(&free_entries_lock, flags);
+
+		for (i = 0; i < delta; i++) {
+			entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+			if (!entry)
+				break;
+
+			list_add_tail(&entry->list, &tmp);
+		}
+
+		spin_lock_irqsave(&free_entries_lock, flags);
+
+		list_splice(&tmp, &free_entries);
+		nr_total_entries += i;
+		num_free_entries += i;
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
@@ -490,6 +548,8 @@ void dma_debug_init(u32 num_entries)
 		return;
 	}
 
+	nr_total_entries = num_free_entries;
+
 	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
 }
 
-- 
1.6.0.6

