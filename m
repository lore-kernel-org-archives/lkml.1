Return-Path: <linux-kernel-owner+w=401wt.eu-S934287AbZLFSEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287AbZLFSEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934226AbZLFSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:17 -0500
Received: from www.tglx.de ([62.245.132.106]:33333 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934262AbZLFSEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:04:11 -0500
Message-Id: <20091206111958.183303242@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 23/23] debugobjects: Convert to raw_spinlocks
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=debugobjects-convert-to-core-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/debugobjects.c |   74 ++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

Index: linux-2.6-tip/lib/debugobjects.c
===================================================================
--- linux-2.6-tip.orig/lib/debugobjects.c
+++ linux-2.6-tip/lib/debugobjects.c
@@ -26,14 +26,14 @@
 
 struct debug_bucket {
 	struct hlist_head	list;
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 };
 
 static struct debug_bucket	obj_hash[ODEBUG_HASH_SIZE];
 
 static struct debug_obj		obj_static_pool[ODEBUG_POOL_SIZE] __initdata;
 
-static DEFINE_SPINLOCK(pool_lock);
+static DEFINE_RAW_SPINLOCK(pool_lock);
 
 static HLIST_HEAD(obj_pool);
 
@@ -96,10 +96,10 @@ static int fill_pool(void)
 		if (!new)
 			return obj_pool_free;
 
-		spin_lock_irqsave(&pool_lock, flags);
+		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
 		obj_pool_free++;
-		spin_unlock_irqrestore(&pool_lock, flags);
+		raw_spin_unlock_irqrestore(&pool_lock, flags);
 	}
 	return obj_pool_free;
 }
@@ -133,7 +133,7 @@ alloc_object(void *addr, struct debug_bu
 {
 	struct debug_obj *obj = NULL;
 
-	spin_lock(&pool_lock);
+	raw_spin_lock(&pool_lock);
 	if (obj_pool.first) {
 		obj	    = hlist_entry(obj_pool.first, typeof(*obj), node);
 
@@ -152,7 +152,7 @@ alloc_object(void *addr, struct debug_bu
 		if (obj_pool_free < obj_pool_min_free)
 			obj_pool_min_free = obj_pool_free;
 	}
-	spin_unlock(&pool_lock);
+	raw_spin_unlock(&pool_lock);
 
 	return obj;
 }
@@ -165,7 +165,7 @@ static void free_obj_work(struct work_st
 	struct debug_obj *obj;
 	unsigned long flags;
 
-	spin_lock_irqsave(&pool_lock, flags);
+	raw_spin_lock_irqsave(&pool_lock, flags);
 	while (obj_pool_free > ODEBUG_POOL_SIZE) {
 		obj = hlist_entry(obj_pool.first, typeof(*obj), node);
 		hlist_del(&obj->node);
@@ -174,11 +174,11 @@ static void free_obj_work(struct work_st
 		 * We release pool_lock across kmem_cache_free() to
 		 * avoid contention on pool_lock.
 		 */
-		spin_unlock_irqrestore(&pool_lock, flags);
+		raw_spin_unlock_irqrestore(&pool_lock, flags);
 		kmem_cache_free(obj_cache, obj);
-		spin_lock_irqsave(&pool_lock, flags);
+		raw_spin_lock_irqsave(&pool_lock, flags);
 	}
-	spin_unlock_irqrestore(&pool_lock, flags);
+	raw_spin_unlock_irqrestore(&pool_lock, flags);
 }
 
 /*
@@ -190,7 +190,7 @@ static void free_object(struct debug_obj
 	unsigned long flags;
 	int sched = 0;
 
-	spin_lock_irqsave(&pool_lock, flags);
+	raw_spin_lock_irqsave(&pool_lock, flags);
 	/*
 	 * schedule work when the pool is filled and the cache is
 	 * initialized:
@@ -200,7 +200,7 @@ static void free_object(struct debug_obj
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
-	spin_unlock_irqrestore(&pool_lock, flags);
+	raw_spin_unlock_irqrestore(&pool_lock, flags);
 	if (sched)
 		schedule_work(&debug_obj_work);
 }
@@ -221,9 +221,9 @@ static void debug_objects_oom(void)
 	printk(KERN_WARNING "ODEBUG: Out of memory. ODEBUG disabled\n");
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++, db++) {
-		spin_lock_irqsave(&db->lock, flags);
+		raw_spin_lock_irqsave(&db->lock, flags);
 		hlist_move_list(&db->list, &freelist);
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 
 		/* Now free them */
 		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
@@ -303,14 +303,14 @@ __debug_object_init(void *addr, struct d
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (!obj) {
 		obj = alloc_object(addr, db, descr);
 		if (!obj) {
 			debug_objects_enabled = 0;
-			spin_unlock_irqrestore(&db->lock, flags);
+			raw_spin_unlock_irqrestore(&db->lock, flags);
 			debug_objects_oom();
 			return;
 		}
@@ -327,7 +327,7 @@ __debug_object_init(void *addr, struct d
 	case ODEBUG_STATE_ACTIVE:
 		debug_print_object(obj, "init");
 		state = obj->state;
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		debug_object_fixup(descr->fixup_init, addr, state);
 		return;
 
@@ -338,7 +338,7 @@ __debug_object_init(void *addr, struct d
 		break;
 	}
 
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
 /**
@@ -385,7 +385,7 @@ void debug_object_activate(void *addr, s
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (obj) {
@@ -398,7 +398,7 @@ void debug_object_activate(void *addr, s
 		case ODEBUG_STATE_ACTIVE:
 			debug_print_object(obj, "activate");
 			state = obj->state;
-			spin_unlock_irqrestore(&db->lock, flags);
+			raw_spin_unlock_irqrestore(&db->lock, flags);
 			debug_object_fixup(descr->fixup_activate, addr, state);
 			return;
 
@@ -408,11 +408,11 @@ void debug_object_activate(void *addr, s
 		default:
 			break;
 		}
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		return;
 	}
 
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 	/*
 	 * This happens when a static object is activated. We
 	 * let the type specific code decide whether this is
@@ -438,7 +438,7 @@ void debug_object_deactivate(void *addr,
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (obj) {
@@ -463,7 +463,7 @@ void debug_object_deactivate(void *addr,
 		debug_print_object(&o, "deactivate");
 	}
 
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
 /**
@@ -483,7 +483,7 @@ void debug_object_destroy(void *addr, st
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (!obj)
@@ -498,7 +498,7 @@ void debug_object_destroy(void *addr, st
 	case ODEBUG_STATE_ACTIVE:
 		debug_print_object(obj, "destroy");
 		state = obj->state;
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		debug_object_fixup(descr->fixup_destroy, addr, state);
 		return;
 
@@ -509,7 +509,7 @@ void debug_object_destroy(void *addr, st
 		break;
 	}
 out_unlock:
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
 /**
@@ -529,7 +529,7 @@ void debug_object_free(void *addr, struc
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (!obj)
@@ -539,17 +539,17 @@ void debug_object_free(void *addr, struc
 	case ODEBUG_STATE_ACTIVE:
 		debug_print_object(obj, "free");
 		state = obj->state;
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		debug_object_fixup(descr->fixup_free, addr, state);
 		return;
 	default:
 		hlist_del(&obj->node);
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 		free_object(obj);
 		return;
 	}
 out_unlock:
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
 #ifdef CONFIG_DEBUG_OBJECTS_FREE
@@ -575,7 +575,7 @@ static void __debug_check_no_obj_freed(c
 
 repeat:
 		cnt = 0;
-		spin_lock_irqsave(&db->lock, flags);
+		raw_spin_lock_irqsave(&db->lock, flags);
 		hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
 			cnt++;
 			oaddr = (unsigned long) obj->object;
@@ -587,7 +587,7 @@ repeat:
 				debug_print_object(obj, "free");
 				descr = obj->descr;
 				state = obj->state;
-				spin_unlock_irqrestore(&db->lock, flags);
+				raw_spin_unlock_irqrestore(&db->lock, flags);
 				debug_object_fixup(descr->fixup_free,
 						   (void *) oaddr, state);
 				goto repeat;
@@ -597,7 +597,7 @@ repeat:
 				break;
 			}
 		}
-		spin_unlock_irqrestore(&db->lock, flags);
+		raw_spin_unlock_irqrestore(&db->lock, flags);
 
 		/* Now free them */
 		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
@@ -783,7 +783,7 @@ check_results(void *addr, enum debug_obj
 
 	db = get_bucket((unsigned long) addr);
 
-	spin_lock_irqsave(&db->lock, flags);
+	raw_spin_lock_irqsave(&db->lock, flags);
 
 	obj = lookup_object(addr, db);
 	if (!obj && state != ODEBUG_STATE_NONE) {
@@ -807,7 +807,7 @@ check_results(void *addr, enum debug_obj
 	}
 	res = 0;
 out:
-	spin_unlock_irqrestore(&db->lock, flags);
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 	if (res)
 		debug_objects_enabled = 0;
 	return res;
@@ -907,7 +907,7 @@ void __init debug_objects_early_init(voi
 	int i;
 
 	for (i = 0; i < ODEBUG_HASH_SIZE; i++)
-		spin_lock_init(&obj_hash[i].lock);
+		raw_spin_lock_init(&obj_hash[i].lock);
 
 	for (i = 0; i < ODEBUG_POOL_SIZE; i++)
 		hlist_add_head(&obj_static_pool[i].node, &obj_pool);


