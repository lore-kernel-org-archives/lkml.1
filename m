Return-Path: <linux-kernel-owner+w=401wt.eu-S1763413AbZCQLbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763413AbZCQLbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 07:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763306AbZCQLbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 07:31:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:60919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763341AbZCQLa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 07:30:59 -0400
Date: Tue, 17 Mar 2009 11:30:31 GMT
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <200903162049.58058.nickpiggin@yahoo.com.au>
References: <200903162049.58058.nickpiggin@yahoo.com.au>
Subject: [tip:core/debugobjects] debugobjects: delay free of internal objects
Message-ID: <tip-337fff8b5ed0573ea106491c6de47bd7fe623500@git.kernel.org>
Git-Commit-ID: 337fff8b5ed0573ea106491c6de47bd7fe623500
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 11:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  337fff8b5ed0573ea106491c6de47bd7fe623500
Gitweb:     http://git.kernel.org/tip/337fff8b5ed0573ea106491c6de47bd7fe623500
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 16 Mar 2009 10:04:53 +0100
Commit:     Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 17 Mar 2009 12:28:30 +0100

debugobjects: delay free of internal objects

Impact: avoid recursive kfree calls, less slab activity on heavy load

debugobjects checks on kfree whether tracked objects are freed. When a
tracked object is freed debugobjects frees the internal reference
object as well. The debug object slab cache is marked to not recurse
into debugobjects when a slab objects is freed, but the recursive call
can be problematic versus locking in the memory allocator.

Defer the freeing of debug slab objects via schedule_work. The reasons
not to use RCU are:

1) rcu makes the data structure larger
2) there is no real need for rcu as nothing references the obj after
   we freed it
3) under heavy load it is easier to reuse the to be freed objects instead
   of allocating new objects from the slab. This lowered the slab activity
   significantly in a heavy load networking test where lots of timers are
   created/destroyed. The workqueue based delayed free allows us just to
   put the to be freed objects back into the object pool and reuse them
   right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <200903162049.58058.nickpiggin@yahoo.com.au>


---
 lib/debugobjects.c |   53 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index fdcda3d..2755a3b 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -50,6 +50,9 @@ static int			debug_objects_enabled __read_mostly
 
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
+static void free_obj_work(struct work_struct *work);
+static DECLARE_WORK(debug_obj_work, free_obj_work);
+
 static int __init enable_object_debug(char *str)
 {
 	debug_objects_enabled = 1;
@@ -154,25 +157,51 @@ alloc_object(void *addr, struct debug_bucket *b, struct debug_obj_descr *descr)
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
