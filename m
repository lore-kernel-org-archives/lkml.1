Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbXDZFMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbXDZFMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXDZFL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:11:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59447 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754713AbXDZFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:09:35 -0400
Message-Id: <20070426050934.716067781@sgi.com>
References: <20070426050743.867613938@sgi.com>
User-Agent: quilt/0.45-1
Date: Wed, 25 Apr 2007 22:07:49 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/7] SLUB: Free slabs and sort partial slab lists in kmem_cache_shrink
Content-Disposition: inline; filename=slab_shrink_cache
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At kmem_cache_shrink check if we have any empty slabs on the partial
if so then remove them.

Also--as an anti-fragmentation measure--sort the partial slabs so that
the most fully allocated ones come first and the least allocated last.

The next allocations may fill up the nearly full slabs. Having the
least allocated slabs last gives them the maximum chance that their
remaining objects may be freed. Thus we can hopefully minimize the
partial slabs.

I think this is the best one can do in terms antifragmentation
measures. Real defragmentation (meaning moving objects out of slabs with
the least free objects to those that are almost full) can be implemted
by reverse scanning through the list produced here but that would mean
that we need to provide a callback at slab cache creation that allows
the deletion or moving of an object. This will involve slab API
changes so defer for now.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 104 insertions(+), 14 deletions(-)

Index: linux-2.6.21-rc7-mm1/mm/slub.c
===================================================================
--- linux-2.6.21-rc7-mm1.orig/mm/slub.c	2007-04-25 21:25:48.000000000 -0700
+++ linux-2.6.21-rc7-mm1/mm/slub.c	2007-04-25 21:27:07.000000000 -0700
@@ -109,9 +109,19 @@
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST
 
-/* Mininum number of partial slabs */
+/*
+ * Mininum number of partial slabs. These will be left on the partial
+ * lists even if they are empty. kmem_cache_shrink may reclaim them.
+ */
 #define MIN_PARTIAL 2
 
+/*
+ * Maximum number of desirable partial slabs.
+ * The existence of more partial slabs makes kmem_cache_shrink
+ * sort the partial list by the number of objects in the.
+ */
+#define MAX_PARTIAL 10
+
 #define DEBUG_DEFAULT_FLAGS (SLAB_DEBUG_FREE | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
 /*
@@ -2163,6 +2173,78 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+/*
+ *  kmem_cache_shrink removes empty slabs from the partial lists
+ *  and then sorts the partially allocated slabs by the number
+ *  of items in use. The slabs with the most items in use
+ *  come first. New allocations will remove these from the
+ *  partial list because they are full. The slabs with the
+ *  least items are placed last. If it happens that the objects
+ *  are freed then the page can be returned to the page allocator.
+ */
+int kmem_cache_shrink(struct kmem_cache *s)
+{
+	int node;
+	int i;
+	struct kmem_cache_node *n;
+	struct page *page;
+	struct page *t;
+	struct list_head *slabs_by_inuse =
+		kmalloc(sizeof(struct list_head) * s->objects, GFP_KERNEL);
+	unsigned long flags;
+
+	if (!slabs_by_inuse)
+		return -ENOMEM;
+
+	flush_all(s);
+	for_each_online_node(node) {
+		n = get_node(s, node);
+
+		if (n->nr_partial <= MIN_PARTIAL)
+			continue;
+
+		for (i = 0; i < s->objects; i++)
+			INIT_LIST_HEAD(slabs_by_inuse + i);
+
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		/*
+		 * Build lists indexed by the items in use in
+		 * each slab or free slabs if empty.
+		 *
+		 * Note that concurrent frees may occur while
+		 * we hold the list_lock. page->inuse here is
+		 * the upper limit.
+		 */
+		list_for_each_entry_safe(page, t, &n->partial, lru) {
+			if (!page->inuse) {
+				list_del(&page->lru);
+				discard_slab(s, page);
+			} else
+			if (n->nr_partial > MAX_PARTIAL)
+				list_move(&page->lru,
+					slabs_by_inuse + page->inuse);
+		}
+
+		if (n->nr_partial <= MAX_PARTIAL)
+			goto out;
+
+		/*
+		 * Rebuild the partial list with the slabs filled up
+		 * most first and the least used slabs at the end.
+		 */
+		for (i = s->objects - 1; i > 0; i--)
+			list_splice(slabs_by_inuse + i, n->partial.prev);
+
+	out:
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	kfree(slabs_by_inuse);
+	return 0;
+}
+EXPORT_SYMBOL(kmem_cache_shrink);
+
 /**
  * krealloc - reallocate memory. The contents will remain unchanged.
  *
@@ -2408,17 +2490,6 @@ static struct notifier_block __cpuinitda
 
 #endif
 
-/***************************************************************
- *	Compatiblility definitions
- **************************************************************/
-
-int kmem_cache_shrink(struct kmem_cache *s)
-{
-	flush_all(s);
-	return 0;
-}
-EXPORT_SYMBOL(kmem_cache_shrink);
-
 #ifdef CONFIG_NUMA
 
 /*****************************************************************
@@ -3194,6 +3265,25 @@ static ssize_t validate_store(struct kme
 }
 SLAB_ATTR(validate);
 
+static ssize_t shrink_show(struct kmem_cache *s, char *buf)
+{
+	return 0;
+}
+
+static ssize_t shrink_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	if (buf[0] == '1') {
+		int rc = kmem_cache_shrink(s);
+
+		if (rc)
+			return rc;
+	} else
+		return -EINVAL;
+	return length;
+}
+SLAB_ATTR(shrink);
+
 static ssize_t alloc_calls_show(struct kmem_cache *s, char *buf)
 {
 	if (!(s->flags & SLAB_STORE_USER))
@@ -3250,6 +3340,7 @@ static struct attribute * slab_attrs[] =
 	&poison_attr.attr,
 	&store_user_attr.attr,
 	&validate_attr.attr,
+	&shrink_attr.attr,
 	&alloc_calls_attr.attr,
 	&free_calls_attr.attr,
 #ifdef CONFIG_ZONE_DMA

--
