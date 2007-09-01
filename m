Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbXIABql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbXIABql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXIABnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:43:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46104 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513AbXIABmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:22 -0400
Message-Id: <20070901014220.913587283@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:14 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 07/26] SLUB: Sort slab cache list and establish maximum objects for defrag slabs
Content-Disposition: inline; filename=0007-slab_defrag_determine_maximum_objects.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we defragmenting slabs then it is advantageous to have all
defragmentable slabs together at the beginning of the list so that we do not
have to scan the complete list. When adding a slab cache put defragmentale
caches first and others last.

Determine the maximum number of objects in defragmentable slabs. This allows
to size the allocation of arrays holding refs to these objects later.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4a64038..9006069 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -226,6 +226,9 @@ static enum {
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
 
+/* Maximum objects in defragmentable slabs */
+static unsigned int max_defrag_slab_objects = 0;
+
 /*
  * Tracking user of a slab.
  */
@@ -2385,7 +2388,7 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
 			flags, NULL))
 		goto panic;
 
-	list_add(&s->list, &slab_caches);
+	list_add_tail(&s->list, &slab_caches);
 	up_write(&slub_lock);
 	if (sysfs_slab_add(s))
 		goto panic;
@@ -2597,6 +2600,13 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+static inline void *alloc_scratch(void)
+{
+	return kmalloc(max_defrag_slab_objects * sizeof(void *) +
+	    BITS_TO_LONGS(max_defrag_slab_objects) * sizeof(unsigned long),
+								GFP_KERNEL);
+}
+
 void kmem_cache_setup_defrag(struct kmem_cache *s,
 	void *(*get)(struct kmem_cache *, int nr, void **),
 	void (*kick)(struct kmem_cache *, int nr, void **, void *private))
@@ -2608,6 +2618,11 @@ void kmem_cache_setup_defrag(struct kmem_cache *s,
 	BUG_ON(!s->ctor);
 	s->get = get;
 	s->kick = kick;
+	down_write(&slub_lock);
+	list_move(&s->list, &slab_caches);
+	if (s->objects > max_defrag_slab_objects)
+		max_defrag_slab_objects = s->objects;
+	up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_setup_defrag);
 
@@ -2878,7 +2893,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	if (s) {
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
+			list_add_tail(&s->list, &slab_caches);
 			up_write(&slub_lock);
 			if (sysfs_slab_add(s))
 				goto err;
-- 
1.5.2.4

-- 
