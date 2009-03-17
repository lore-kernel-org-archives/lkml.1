Return-Path: <linux-kernel-owner+w=401wt.eu-S1763324AbZCQLbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763324AbZCQLbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZCQLau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:30:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:60915 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZCQLat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:30:49 -0400
Date: Tue, 17 Mar 2009 11:30:23 GMT
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <200903162049.58058.nickpiggin@yahoo.com.au>
References: <200903162049.58058.nickpiggin@yahoo.com.au>
Subject: [tip:core/debugobjects] debugobjects: replace static objects when slab cache becomes available
Message-ID: <tip-1be1cb7b47f0744141ed61cdb25648819ae1a56f@git.kernel.org>
Git-Commit-ID: 1be1cb7b47f0744141ed61cdb25648819ae1a56f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 11:30:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1be1cb7b47f0744141ed61cdb25648819ae1a56f
Gitweb:     http://git.kernel.org/tip/1be1cb7b47f0744141ed61cdb25648819ae1a56f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 16 Mar 2009 18:53:18 +0100
Commit:     Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 17 Mar 2009 12:28:30 +0100

debugobjects: replace static objects when slab cache becomes available

Impact: refactor/consolidate object management, prepare for delayed free

debugobjects allocates static reference objects to track objects which
are initialized or activated before the slab cache becomes
available. These static reference objects have to be handled
seperately in free_object(). The handling of these objects is in the
way of implementing a delayed free functionality. The delayed free is
required to avoid callbacks into the mm code from
debug_check_no_obj_freed().

Replace the static object references with dynamic ones after the slab
cache has been initialized. The static objects are now marked initdata.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <200903162049.58058.nickpiggin@yahoo.com.au>



---
 lib/debugobjects.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 90e46fa..fdcda3d 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -30,7 +30,7 @@ struct debug_bucket {
 
 static struct debug_bucket	obj_hash[ODEBUG_HASH_SIZE];
 
-static struct debug_obj		obj_static_pool[ODEBUG_POOL_SIZE];
+static struct debug_obj		obj_static_pool[ODEBUG_POOL_SIZE] __initdata;
 
 static DEFINE_SPINLOCK(pool_lock);
 
@@ -884,6 +884,63 @@ void __init debug_objects_early_init(void)
 }
 
 /*
+ * Convert the statically allocated objects to dynamic ones:
+ */
+static int debug_objects_replace_static_objects(void)
+{
+	struct debug_bucket *db = obj_hash;
+	struct hlist_node *node, *tmp;
+	struct debug_obj *obj, *new;
+	HLIST_HEAD(objects);
+	int i, cnt = 0;
+
+	for (i = 0; i < ODEBUG_POOL_SIZE; i++) {
+		obj = kmem_cache_zalloc(obj_cache, GFP_KERNEL);
+		if (!obj)
+			goto free;
+		hlist_add_head(&obj->node, &objects);
+	}
+
+	/*
+	 * When debug_objects_mem_init() is called we know that only
+	 * one CPU is up, so disabling interrupts is enough
+	 * protection. This avoids the lockdep hell of lock ordering.
+	 */
+	local_irq_disable();
+
+	/* Remove the statically allocated objects from the pool */
+	hlist_for_each_entry_safe(obj, node, tmp, &obj_pool, node)
+		hlist_del(&obj->node);
+	/* Move the allocated objects to the pool */
+	hlist_move_list(&objects, &obj_pool);
+
+	/* Replace the active object references */
+	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
+		hlist_move_list(&db->list, &objects);
+
+		hlist_for_each_entry(obj, node, &objects, node) {
+			new = hlist_entry(obj_pool.first, typeof(*obj), node);
+			hlist_del(&new->node);
+			/* copy object data */
+			*new = *obj;
+			hlist_add_head(&new->node, &db->list);
+			cnt++;
+		}
+	}
+
+	printk(KERN_DEBUG "ODEBUG: %d of %d active objects replaced\n", cnt,
+	       obj_pool_used);
+	local_irq_enable();
+	return 0;
+free:
+	hlist_for_each_entry_safe(obj, node, tmp, &objects, node) {
+		hlist_del(&obj->node);
+		kmem_cache_free(obj_cache, obj);
+	}
+	return -ENOMEM;
+}
+
+/*
  * Called after the kmem_caches are functional to setup a dedicated
  * cache pool, which has the SLAB_DEBUG_OBJECTS flag set. This flag
  * prevents that the debug code is called on kmem_cache_free() for the
@@ -898,8 +955,11 @@ void __init debug_objects_mem_init(void)
 				      sizeof (struct debug_obj), 0,
 				      SLAB_DEBUG_OBJECTS, NULL);
 
-	if (!obj_cache)
+	if (!obj_cache || debug_objects_replace_static_objects()) {
 		debug_objects_enabled = 0;
-	else
+		if (obj_cache)
+			kmem_cache_destroy(obj_cache);
+		printk(KERN_WARNING "ODEBUG: out of memory.\n");
+	} else
 		debug_objects_selftest();
 }
