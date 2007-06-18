Return-Path: <linux-kernel-owner+w=401wt.eu-S1761671AbXFRKFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761671AbXFRKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbXFRJ7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:59:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47938 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760149AbXFRJ7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:59:19 -0400
Message-Id: <20070618095918.872887071@sgi.com>
References: <20070618095838.238615343@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jun 2007 02:59:01 -0700
From: clameter@sgi.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: suresh.b.siddha@intel.com
Subject: [patch 23/26] SLUB: Move sysfs operations outside of slub_lock
Content-Disposition: inline; filename=slub_lock_cleanup
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs can do a gazillion things when called. Make sure that we do
not call any sysfs functions while holding the slub_lock.

Just protect the essentials:

1. The list of all slab caches
2. The kmalloc_dma array
3. The ref counters of the slabs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-17 18:12:37.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-17 18:12:44.000000000 -0700
@@ -2217,12 +2217,13 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		up_write(&slub_lock);
 		if (kmem_cache_close(s))
 			WARN_ON(1);
 		sysfs_slab_remove(s);
 		kfree(s);
-	}
-	up_write(&slub_lock);
+	} else
+		up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -3027,26 +3028,33 @@ struct kmem_cache *kmem_cache_create(con
 		 */
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
+		up_write(&slub_lock);
+
 		if (sysfs_slab_alias(s, name))
 			goto err;
-	} else {
-		s = kmalloc(kmem_size, GFP_KERNEL);
-		if (s && kmem_cache_open(s, GFP_KERNEL, name,
+
+		return s;
+	}
+
+	s = kmalloc(kmem_size, GFP_KERNEL);
+	if (s) {
+		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor, ops)) {
-			if (sysfs_slab_add(s)) {
-				kfree(s);
-				goto err;
-			}
 			list_add(&s->list, &slab_caches);
+			up_write(&slub_lock);
 			raise_kswapd_order(s->order);
-		} else
-			kfree(s);
+
+			if (sysfs_slab_add(s))
+				goto err;
+
+			return s;
+
+		}
+		kfree(s);
 	}
 	up_write(&slub_lock);
-	return s;
 
 err:
-	up_write(&slub_lock);
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slabcache %s\n", name);
 	else

-- 
