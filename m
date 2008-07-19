Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYGSMbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYGSMbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYGSMbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:31:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbYGSMbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:31:13 -0400
Date: Sat, 19 Jul 2008 15:31:01 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 4/8] slub: Sort slab cache list and establish maximum objects
 for defrag slabs
Message-ID: <Pine.LNX.4.64.0807191530410.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

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
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 1c256e2..f455765 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -205,6 +205,9 @@ static enum {
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
 
+/* Maximum objects in defragmentable slabs */
+static unsigned int max_defrag_slab_objects;
+
 /*
  * Tracking user of a slab.
  */
@@ -2545,7 +2548,7 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
 								flags, NULL))
 		goto panic;
 
-	list_add(&s->list, &slab_caches);
+	list_add_tail(&s->list, &slab_caches);
 	up_write(&slub_lock);
 	if (sysfs_slab_add(s))
 		goto panic;
@@ -2775,9 +2778,23 @@ void kfree(const void *x)
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
@@ -2785,6 +2802,11 @@ void kmem_cache_setup_defrag(struct kmem_cache *s,
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
 
@@ -3171,7 +3193,7 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	if (s) {
 		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			list_add(&s->list, &slab_caches);
+			list_add_tail(&s->list, &slab_caches);
 			up_write(&slub_lock);
 			if (sysfs_slab_add(s))
 				goto err;
-- 
1.5.4.3

