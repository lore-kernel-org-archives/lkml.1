Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648Ab0ARBBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0ARBBG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279Ab0ARAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:53:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:54196 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0ARAxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:04 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 35/40] fscache: convert object to use workqueue instead of slow-work
Date: Mon, 18 Jan 2010 09:57:47 +0900
Message-Id: <1263776272-382-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make fscache object state transition callbacks use workqueue instead
of slow-work.  New dedicated single CPU workqueue fscache_object_wq is
created.  get/put callbacks are renamed and modified to take @object
and called directly from the enqueue wrapper and the work function.
While at it, make all open coded instances of get/put to use
fscache_get/put_object().

* slow-work flags are no longer printed out in object debugging
  outputs.

* Max concurrency for objects is set to 99 which is the default for
  very slow works.  API to adjust cwq max concurrency limit can be
  added easily.

* In cachefiles_mark_object_active() no longer relinquishes the thread
  when a new work is queued.  This can be implemented in workqueue if
  necessary but I wasn't sure how useful it would actually be.
  Simpler way would be to shorten the requeue timeout (say 5secs) and
  warn iff the duration from the initial queueing goes over the
  original limit (60s).

* Single CPU workqueue was used to ease conversion.  If necessary,
  multi CPU one can be used by adding per-object state transition
  mutex.

NOT_SIGNED_OFF_YET
Cc: David Howells <dhowells@redhat.com>
---
 fs/cachefiles/namei.c         |   28 ++++-------------
 fs/fscache/internal.h         |    1 +
 fs/fscache/main.c             |   10 ++++++
 fs/fscache/object-list.c      |   12 +++----
 fs/fscache/object.c           |   67 +++++++++-------------------------------
 include/linux/fscache-cache.h |    7 ++--
 6 files changed, 42 insertions(+), 83 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 14ac480..bb5c680 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -36,10 +36,9 @@ void __cachefiles_printk_object(struct cachefiles_object *object,
 
 	printk(KERN_ERR "%sobject: OBJ%x\n",
 	       prefix, object->fscache.debug_id);
-	printk(KERN_ERR "%sobjstate=%s fl=%lx swfl=%lx ev=%lx[%lx]\n",
+	printk(KERN_ERR "%sobjstate=%s fl=%lx ev=%lx[%lx]\n",
 	       prefix, fscache_object_states[object->fscache.state],
-	       object->fscache.flags, object->fscache.work.flags,
-	       object->fscache.events,
+	       object->fscache.flags, object->fscache.events,
 	       object->fscache.event_mask & FSCACHE_OBJECT_EVENTS_MASK);
 	printk(KERN_ERR "%sops=%u inp=%u exc=%u\n",
 	       prefix, object->fscache.n_ops, object->fscache.n_in_progress,
@@ -150,15 +149,13 @@ wait_for_old_object:
 	write_unlock(&cache->active_lock);
 
 	if (test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
-		wait_queue_head_t *wq;
-
 		signed long timeout = 60 * HZ;
+		wait_queue_head_t *wq;
 		wait_queue_t wait;
-		bool requeue;
 
 		/* if the object we're waiting for is queued for processing,
 		 * then just put ourselves on the queue behind it */
-		if (slow_work_is_queued(&xobject->fscache.work)) {
+		if (work_pending(&xobject->fscache.work)) {
 			_debug("queue OBJ%x behind OBJ%x immediately",
 			       object->fscache.debug_id,
 			       xobject->fscache.debug_id);
@@ -166,28 +163,17 @@ wait_for_old_object:
 		}
 
 		/* otherwise we sleep until either the object we're waiting for
-		 * is done, or the slow-work facility wants the thread back to
-		 * do other work */
+		 * is done */
 		wq = bit_waitqueue(&xobject->flags, CACHEFILES_OBJECT_ACTIVE);
 		init_wait(&wait);
-		requeue = false;
 		do {
 			prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
 			if (!test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags))
 				break;
-			requeue = slow_work_sleep_till_thread_needed(
-				&object->fscache.work, &timeout);
-		} while (timeout > 0 && !requeue);
+			timeout = schedule_timeout(timeout);
+		} while (timeout > 0);
 		finish_wait(wq, &wait);
 
-		if (requeue &&
-		    test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
-			_debug("queue OBJ%x behind OBJ%x after wait",
-			       object->fscache.debug_id,
-			       xobject->fscache.debug_id);
-			goto requeue;
-		}
-
 		if (timeout <= 0) {
 			printk(KERN_ERR "\n");
 			printk(KERN_ERR "CacheFiles: Error: Overlong"
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index edd7434..f9da2fc 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -82,6 +82,7 @@ extern unsigned fscache_defer_lookup;
 extern unsigned fscache_defer_create;
 extern unsigned fscache_debug;
 extern struct kobject *fscache_root;
+extern struct workqueue_struct *fscache_object_wq;
 
 extern int fscache_wait_bit(void *);
 extern int fscache_wait_bit_interruptible(void *);
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index add6bdb..a676a86 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -40,6 +40,7 @@ MODULE_PARM_DESC(fscache_debug,
 		 "FS-Cache debugging mask");
 
 struct kobject *fscache_root;
+struct workqueue_struct *fscache_object_wq;
 
 /*
  * initialise the fs caching module
@@ -52,6 +53,12 @@ static int __init fscache_init(void)
 	if (ret < 0)
 		goto error_slow_work;
 
+	ret = -ENOMEM;
+	fscache_object_wq =
+		__create_workqueue("fscache_object", WQ_SINGLE_CPU, 99);
+	if (!fscache_object_wq)
+		goto error_object_wq;
+
 	ret = fscache_proc_init();
 	if (ret < 0)
 		goto error_proc;
@@ -80,6 +87,8 @@ error_kobj:
 error_cookie_jar:
 	fscache_proc_cleanup();
 error_proc:
+	destroy_workqueue(fscache_object_wq);
+error_object_wq:
 	slow_work_unregister_user(THIS_MODULE);
 error_slow_work:
 	return ret;
@@ -97,6 +106,7 @@ static void __exit fscache_exit(void)
 	kobject_put(fscache_root);
 	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
+	destroy_workqueue(fscache_object_wq);
 	slow_work_unregister_user(THIS_MODULE);
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");
 }
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index 3221a0c..d4164f8 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -33,8 +33,8 @@ struct fscache_objlist_data {
 #define FSCACHE_OBJLIST_CONFIG_NOREADS	0x00000200	/* show objects without active reads */
 #define FSCACHE_OBJLIST_CONFIG_EVENTS	0x00000400	/* show objects with events */
 #define FSCACHE_OBJLIST_CONFIG_NOEVENTS	0x00000800	/* show objects without no events */
-#define FSCACHE_OBJLIST_CONFIG_WORK	0x00001000	/* show objects with slow work */
-#define FSCACHE_OBJLIST_CONFIG_NOWORK	0x00002000	/* show objects without slow work */
+#define FSCACHE_OBJLIST_CONFIG_WORK	0x00001000	/* show objects with work */
+#define FSCACHE_OBJLIST_CONFIG_NOWORK	0x00002000	/* show objects without work */
 
 	u8		buf[512];	/* key and aux data buffer */
 };
@@ -230,12 +230,11 @@ static int fscache_objlist_show(struct seq_file *m, void *v)
 		       READS, NOREADS);
 		FILTER(obj->events & obj->event_mask,
 		       EVENTS, NOEVENTS);
-		FILTER(obj->work.flags & ~(1UL << SLOW_WORK_VERY_SLOW),
-		       WORK, NOWORK);
+		FILTER(work_busy(&obj->work), WORK, NOWORK);
 	}
 
 	seq_printf(m,
-		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx %1lx | ",
+		   "%8x %8x %s %5u %3u %3u %3u %2u %5u %2lx %2lx %1lx | ",
 		   obj->debug_id,
 		   obj->parent ? obj->parent->debug_id : -1,
 		   fscache_object_states_short[obj->state],
@@ -247,8 +246,7 @@ static int fscache_objlist_show(struct seq_file *m, void *v)
 		   atomic_read(&obj->n_reads),
 		   obj->event_mask & FSCACHE_OBJECT_EVENTS_MASK,
 		   obj->events,
-		   obj->flags,
-		   obj->work.flags);
+		   obj->flags);
 
 	no_cookie = true;
 	keylen = auxlen = 0;
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index e513ac5..3b44f06 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -50,12 +50,8 @@ const char fscache_object_states_short[FSCACHE_OBJECT__NSTATES][5] = {
 	[FSCACHE_OBJECT_DEAD]		= "DEAD",
 };
 
-static void fscache_object_slow_work_put_ref(struct slow_work *);
-static int  fscache_object_slow_work_get_ref(struct slow_work *);
-static void fscache_object_slow_work_execute(struct slow_work *);
-#ifdef CONFIG_SLOW_WORK_PROC
-static void fscache_object_slow_work_desc(struct slow_work *, struct seq_file *);
-#endif
+static int  fscache_get_object(struct fscache_object *);
+static void fscache_put_object(struct fscache_object *);
 static void fscache_initialise_object(struct fscache_object *);
 static void fscache_lookup_object(struct fscache_object *);
 static void fscache_object_available(struct fscache_object *);
@@ -64,17 +60,6 @@ static void fscache_withdraw_object(struct fscache_object *);
 static void fscache_enqueue_dependents(struct fscache_object *);
 static void fscache_dequeue_object(struct fscache_object *);
 
-const struct slow_work_ops fscache_object_slow_work_ops = {
-	.owner		= THIS_MODULE,
-	.get_ref	= fscache_object_slow_work_get_ref,
-	.put_ref	= fscache_object_slow_work_put_ref,
-	.execute	= fscache_object_slow_work_execute,
-#ifdef CONFIG_SLOW_WORK_PROC
-	.desc		= fscache_object_slow_work_desc,
-#endif
-};
-EXPORT_SYMBOL(fscache_object_slow_work_ops);
-
 /*
  * we need to notify the parent when an op completes that we had outstanding
  * upon it
@@ -345,7 +330,7 @@ unsupported_event:
 /*
  * execute an object
  */
-static void fscache_object_slow_work_execute(struct slow_work *work)
+void fscache_object_work_func(struct work_struct *work)
 {
 	struct fscache_object *object =
 		container_of(work, struct fscache_object, work);
@@ -359,23 +344,9 @@ static void fscache_object_slow_work_execute(struct slow_work *work)
 	if (object->events & object->event_mask)
 		fscache_enqueue_object(object);
 	clear_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	fscache_put_object(object);
 }
-
-/*
- * describe an object for slow-work debugging
- */
-#ifdef CONFIG_SLOW_WORK_PROC
-static void fscache_object_slow_work_desc(struct slow_work *work,
-					  struct seq_file *m)
-{
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
-
-	seq_printf(m, "FSC: OBJ%x: %s",
-		   object->debug_id,
-		   fscache_object_states_short[object->state]);
-}
-#endif
+EXPORT_SYMBOL(fscache_object_work_func);
 
 /*
  * initialise an object
@@ -393,7 +364,6 @@ static void fscache_initialise_object(struct fscache_object *object)
 	_enter("");
 	ASSERT(object->cookie != NULL);
 	ASSERT(object->cookie->parent != NULL);
-	ASSERT(list_empty(&object->work.link));
 
 	if (object->events & ((1 << FSCACHE_OBJECT_EV_ERROR) |
 			      (1 << FSCACHE_OBJECT_EV_RELEASE) |
@@ -671,10 +641,8 @@ static void fscache_drop_object(struct fscache_object *object)
 		object->parent = NULL;
 	}
 
-	/* this just shifts the object release to the slow work processor */
-	fscache_stat(&fscache_n_cop_put_object);
-	object->cache->ops->put_object(object);
-	fscache_stat_d(&fscache_n_cop_put_object);
+	/* this just shifts the object release to the work processor */
+	fscache_put_object(object);
 
 	_leave("");
 }
@@ -758,12 +726,10 @@ void fscache_withdrawing_object(struct fscache_cache *cache,
 }
 
 /*
- * allow the slow work item processor to get a ref on an object
+ * get a ref on an object
  */
-static int fscache_object_slow_work_get_ref(struct slow_work *work)
+static int fscache_get_object(struct fscache_object *object)
 {
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
 	int ret;
 
 	fscache_stat(&fscache_n_cop_grab_object);
@@ -773,13 +739,10 @@ static int fscache_object_slow_work_get_ref(struct slow_work *work)
 }
 
 /*
- * allow the slow work item processor to discard a ref on a work item
+ * discard a ref on a work item
  */
-static void fscache_object_slow_work_put_ref(struct slow_work *work)
+static void fscache_put_object(struct fscache_object *object)
 {
-	struct fscache_object *object =
-		container_of(work, struct fscache_object, work);
-
 	fscache_stat(&fscache_n_cop_put_object);
 	object->cache->ops->put_object(object);
 	fscache_stat_d(&fscache_n_cop_put_object);
@@ -792,7 +755,9 @@ void fscache_enqueue_object(struct fscache_object *object)
 {
 	_enter("{OBJ%x}", object->debug_id);
 
-	slow_work_enqueue(&object->work);
+	if (fscache_get_object(object) >= 0)
+		if (!queue_work(fscache_object_wq, &object->work))
+			fscache_put_object(object);
 }
 
 /*
@@ -819,9 +784,7 @@ static void fscache_enqueue_dependents(struct fscache_object *object)
 
 		/* sort onto appropriate lists */
 		fscache_enqueue_object(dep);
-		fscache_stat(&fscache_n_cop_put_object);
-		dep->cache->ops->put_object(dep);
-		fscache_stat_d(&fscache_n_cop_put_object);
+		fscache_put_object(dep);
 
 		if (!list_empty(&object->dependents))
 			cond_resched_lock(&object->lock);
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 7be0c6f..63b7f76 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -21,6 +21,7 @@
 #include <linux/fscache.h>
 #include <linux/sched.h>
 #include <linux/slow-work.h>
+#include <linux/workqueue.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
 
@@ -389,7 +390,7 @@ struct fscache_object {
 	struct fscache_cache	*cache;		/* cache that supplied this object */
 	struct fscache_cookie	*cookie;	/* netfs's file/index object */
 	struct fscache_object	*parent;	/* parent object */
-	struct slow_work	work;		/* attention scheduling record */
+	struct work_struct	work;		/* attention scheduling record */
 	struct list_head	dependents;	/* FIFO of dependent objects */
 	struct list_head	dep_link;	/* link in parent's dependents list */
 	struct list_head	pending_ops;	/* unstarted operations on this object */
@@ -411,7 +412,7 @@ extern const char *fscache_object_states[];
 	(test_bit(FSCACHE_IOERROR, &(obj)->cache->flags) &&	\
 	 (obj)->state >= FSCACHE_OBJECT_DYING)
 
-extern const struct slow_work_ops fscache_object_slow_work_ops;
+extern void fscache_object_work_func(struct work_struct *work);
 
 /**
  * fscache_object_init - Initialise a cache object description
@@ -433,7 +434,7 @@ void fscache_object_init(struct fscache_object *object,
 	spin_lock_init(&object->lock);
 	INIT_LIST_HEAD(&object->cache_link);
 	INIT_HLIST_NODE(&object->cookie_link);
-	vslow_work_init(&object->work, &fscache_object_slow_work_ops);
+	INIT_WORK(&object->work, fscache_object_work_func);
 	INIT_LIST_HEAD(&object->dependents);
 	INIT_LIST_HEAD(&object->dep_link);
 	INIT_LIST_HEAD(&object->pending_ops);
-- 
1.6.4.2

