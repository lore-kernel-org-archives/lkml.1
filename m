Return-Path: <linux-kernel-owner+w=401wt.eu-S1761346AbZC1Wyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbZC1Wyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZC1Wyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:54:44 -0400
Received: from www.tglx.de ([62.245.132.106]:39459 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZC1Wyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:54:43 -0400
Date: Sat, 28 Mar 2009 23:52:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] debugobjects updates for 2.6.30
Message-ID: <alpine.LFD.2.00.0903282350190.3397@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core/debugobjects git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/debugobjects

Main change:

     deferred free of debugobjects internal reference objects to avoid
     a callback into the memory allocator code in the free checks.

Thanks,

	tglx

------------------>
Kyle McMartin (1):
      debug_objects: add boot-parameter toggle to turn object debugging off again

Thomas Gleixner (2):
      debugobjects: replace static objects when slab cache becomes available
      debugobjects: delay free of internal objects


 Documentation/kernel-parameters.txt |    3 +
 lib/debugobjects.c                  |  127 ++++++++++++++++++++++++++++++----
 2 files changed, 115 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..1a328f3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -604,6 +604,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	debug_objects	[KNL] Enable object debugging
 
+	no_debug_objects
+			[KNL] Disable object debugging
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 5d99be1..2755a3b 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -30,7 +30,7 @@ struct debug_bucket {
 
 static struct debug_bucket	obj_hash[ODEBUG_HASH_SIZE];
 
-static struct debug_obj		obj_static_pool[ODEBUG_POOL_SIZE];
+static struct debug_obj		obj_static_pool[ODEBUG_POOL_SIZE] __initdata;
 
 static DEFINE_SPINLOCK(pool_lock);
 
@@ -50,12 +50,23 @@ static int			debug_objects_enabled __read_mostly
 
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
+static void free_obj_work(struct work_struct *work);
+static DECLARE_WORK(debug_obj_work, free_obj_work);
+
 static int __init enable_object_debug(char *str)
 {
 	debug_objects_enabled = 1;
 	return 0;
 }
+
+static int __init disable_object_debug(char *str)
+{
+	debug_objects_enabled = 0;
+	return 0;
+}
+
 early_param("debug_objects", enable_object_debug);
+early_param("no_debug_objects", disable_object_debug);
 
 static const char *obj_states[ODEBUG_STATE_MAX] = {
 	[ODEBUG_STATE_NONE]		= "none",
@@ -146,25 +157,51 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
 }
 
 /*
- * Put the object back into the pool or give it back to kmem_cache:
+ * workqueue function to free objects.
  */
-static void free_object(struct debug_obj *obj)
+static void free_obj_work(struct work_struct *work)
 {
-	unsigned long idx = (unsigned long)(obj - obj_static_pool);
+	struct debug_obj *obj;
 	unsigned long flags;
 
-	if (obj_pool_free < ODEBUG_POOL_SIZE || idx < ODEBUG_POOL_SIZE) {
-		spin_lock_irqsave(&pool_lock, flags);
-		hlist_add_head(&obj->node, &obj_pool);
-		obj_pool_free++;
-		obj_pool_used--;
-		spin_unlock_irqrestore(&pool_lock, flags);
-	} else {
-		spin_lock_irqsave(&pool_lock, flags);
-		obj_pool_used--;
+	spin_lock_irqsave(&pool_lock, flags);
+	while (obj_pool_free > ODEBUG_POOL_SIZE) {
+		obj = hlist_entry(obj_pool.first, typeof(*obj), node);
+		hlist_del(&obj->node);
+		obj_pool_free--;
+		/*
+		 * We release pool_lock across kmem_cache_free() to
+		 * avoid contention on pool_lock.
+		 */
 		spin_unlock_irqrestore(&pool_lock, flags);
 		kmem_cache_free(obj_cache, obj);
+		spin_lock_irqsave(&pool_lock, flags);
 	}
+	spin_unlock_irqrestore(&pool_lock, flags);
+}
+
+/*
+ * Put the object back into the pool and schedule work to free objects
+ * if necessary.
+ */
+static void free_object(struct debug_obj *obj)
+{
+	unsigned long flags;
+	int sched = 0;
+
+	spin_lock_irqsave(&pool_lock, flags);
+	/*
+	 * schedule work when the pool is filled and the cache is
+	 * initialized:
+	 */
+	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
+		sched = !work_pending(&debug_obj_work);
+	hlist_add_head(&obj->node, &obj_pool);
+	obj_pool_free++;
+	obj_pool_used--;
+	spin_unlock_irqrestore(&pool_lock, flags);
+	if (sched)
+		schedule_work(&debug_obj_work);
 }
 
 /*
@@ -876,6 +913,63 @@ void __init debug_objects_early_init(void)
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
@@ -890,8 +984,11 @@ void __init debug_objects_mem_init(void)
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
