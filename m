Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYHASgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYHASgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbYHASfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:35:16 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:7938 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbYHASfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:35:10 -0400
Message-Id: <20080801182344.785737952@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:05 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 04/19] slub: Sort slab cache list and establish maximum objects for defrag slabs
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
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-07-31 12:19:28.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-07-31 12:19:45.000000000 -0500
@@ -173,6 +173,9 @@
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
 
+/* Maximum objects in defragmentable slabs */
+static unsigned int max_defrag_slab_objects;
+
 /*
  * Tracking user of a slab.
  */
@@ -2506,7 +2509,7 @@
 								flags, NULL))
 		goto panic;
 
-	list_add(&s->list, &slab_caches);
+	list_add_tail(&s->list, &slab_caches);
 	up_write(&slub_lock);
 	if (sysfs_slab_add(s))
 		goto panic;
@@ -2736,9 +2739,23 @@
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
@@ -2746,6 +2763,11 @@
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
 
@@ -3131,7 +3153,7 @@
 	if (s) {
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
+			list_add_tail(&s->list, &slab_caches);
 			up_write(&slub_lock);
 			if (sysfs_slab_add(s))
 				goto err;

-- 
