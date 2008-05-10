Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbYEJDMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbYEJDMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYEJDJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:09:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55014 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbYEJDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:17 -0400
Message-Id: <20080510030915.473160456@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:35 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Subject: [patch 04/21] slub: Sort slab cache list and establish maximum objects for defrag slabs
Content-Disposition: inline; filename=0004-SLUB-Sort-slab-cache-list-and-establish-maximum-obj.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When defragmenting slabs then it is advantageous to have all
defragmentable slabs together at the beginning of the list so that there is
no need to scan the complete list. Put defragmentable caches first when adding
a slab cache and others last.

Determine the maximum number of objects in defragmentable slabs. This allows
to size the allocation of arrays holding refs to these objects later.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-05-05 18:48:53.261409952 -0700
+++ linux-2.6/mm/slub.c	2008-05-05 18:48:56.662660182 -0700
@@ -205,6 +205,9 @@ static enum {
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
 
+/* Maximum objects in defragmentable slabs */
+static unsigned int max_defrag_slab_objects;
+
 /*
  * Tracking user of a slab.
  */
@@ -2544,7 +2547,7 @@ static struct kmem_cache *create_kmalloc
 								flags, NULL))
 		goto panic;
 
-	list_add(&s->list, &slab_caches);
+	list_add_tail(&s->list, &slab_caches);
 	up_write(&slub_lock);
 	if (sysfs_slab_add(s))
 		goto panic;
@@ -2772,9 +2775,23 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+/*
+ * Allocate a slab scratch space that is sufficient to keep at least
+ * max_defrag_slab_objects pointers to individual objects and also a bitmap
+ * for max_defrag_slab_objects.
+ */
+static inline void *alloc_scratch(void)
+{
+	return kmalloc(max_defrag_slab_objects * sizeof(void *) +
+		BITS_TO_LONGS(max_defrag_slab_objects) * sizeof(unsigned long),
+		GFP_KERNEL);
+}
+
 void kmem_cache_setup_defrag(struct kmem_cache *s,
 	kmem_defrag_get_func get, kmem_defrag_kick_func kick)
 {
+	int max_objects = oo_objects(s->max);
+
 	/*
 	 * Defragmentable slabs must have a ctor otherwise objects may be
 	 * in an undetermined state after they are allocated.
@@ -2782,6 +2799,11 @@ void kmem_cache_setup_defrag(struct kmem
 	BUG_ON(!s->ctor);
 	s->get = get;
 	s->kick = kick;
+	down_write(&slub_lock);
+	list_move(&s->list, &slab_caches);
+	if (max_objects > max_defrag_slab_objects)
+		max_defrag_slab_objects = max_objects;
+	up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_setup_defrag);
 
@@ -3160,7 +3182,7 @@ struct kmem_cache *kmem_cache_create(con
 	if (s) {
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
+			list_add_tail(&s->list, &slab_caches);
 			up_write(&slub_lock);
 			if (sysfs_slab_add(s))
 				goto err;

-- 
