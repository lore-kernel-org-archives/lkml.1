Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZKSRXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZKSRXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZKSRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:23:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbZKSRW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 27/28] CacheFiles: Catch an overly long wait for an old active
	object
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:52 +0000
Message-ID: <20091119172252.1679.82722.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catch an overly long wait for an old, dying active object when we want to
replace it with a new one.  The probability is that all the slow-work threads
are hogged, and the delete can't get a look in.

What we do instead is:

 (1) if there's nothing in the slow work queue, we sleep until either the dying
     object has finished dying or there is something in the slow work queue
     behind which we can queue our object.

 (2) if there is something in the slow work queue, we return ETIMEDOUT to
     fscache_lookup_object(), which then puts us back on the slow work queue,
     presumably behind the deletion that we're blocked by.  We are then
     deferred for a while until we work our way back through the queue -
     without blocking a slow-work thread unnecessarily.

A backtrace similar to the following may appear in the log without this patch:

	INFO: task kslowd004:5711 blocked for more than 120 seconds.
	"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
	kslowd004     D 0000000000000000     0  5711      2 0x00000080
	 ffff88000340bb80 0000000000000046 ffff88002550d000 0000000000000000
	 ffff88002550d000 0000000000000007 ffff88000340bfd8 ffff88002550d2a8
	 000000000000ddf0 00000000000118c0 00000000000118c0 ffff88002550d2a8
	Call Trace:
	 [<ffffffff81058e21>] ? trace_hardirqs_on+0xd/0xf
	 [<ffffffffa011c4d8>] ? cachefiles_wait_bit+0x0/0xd [cachefiles]
	 [<ffffffffa011c4e1>] cachefiles_wait_bit+0x9/0xd [cachefiles]
	 [<ffffffff81353153>] __wait_on_bit+0x43/0x76
	 [<ffffffff8111ae39>] ? ext3_xattr_get+0x1ec/0x270
	 [<ffffffff813531ef>] out_of_line_wait_on_bit+0x69/0x74
	 [<ffffffffa011c4d8>] ? cachefiles_wait_bit+0x0/0xd [cachefiles]
	 [<ffffffff8104c125>] ? wake_bit_function+0x0/0x2e
	 [<ffffffffa011bc79>] cachefiles_mark_object_active+0x203/0x23b [cachefiles]
	 [<ffffffffa011c209>] cachefiles_walk_to_object+0x558/0x827 [cachefiles]
	 [<ffffffffa011a429>] cachefiles_lookup_object+0xac/0x12a [cachefiles]
	 [<ffffffffa00aa1e9>] fscache_lookup_object+0x1c7/0x214 [fscache]
	 [<ffffffffa00aafc5>] fscache_object_state_machine+0xa5/0x52d [fscache]
	 [<ffffffffa00ab4ac>] fscache_object_slow_work_execute+0x5f/0xa0 [fscache]
	 [<ffffffff81082093>] slow_work_execute+0x18f/0x2d1
	 [<ffffffff8108239a>] slow_work_thread+0x1c5/0x308
	 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
	 [<ffffffff810821d5>] ? slow_work_thread+0x0/0x308
	 [<ffffffff8104be91>] kthread+0x7a/0x82
	 [<ffffffff8100beda>] child_rip+0xa/0x20
	 [<ffffffff8100b87c>] ? restore_args+0x0/0x30
	 [<ffffffff8104be17>] ? kthread+0x0/0x82
	 [<ffffffff8100bed0>] ? child_rip+0x0/0x20
	1 lock held by kslowd004/5711:
	 #0:  (&sb->s_type->i_mutex_key#7/1){+.+.+.}, at: [<ffffffffa011be64>] cachefiles_walk_to_object+0x1b3/0x827 [cachefiles]


Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |    1 
 fs/cachefiles/interface.c                     |    6 +-
 fs/cachefiles/namei.c                         |   87 ++++++++++++++++++++-----
 fs/fscache/internal.h                         |    1 
 fs/fscache/object.c                           |   10 +++
 fs/fscache/stats.c                            |    4 +
 include/linux/fscache-cache.h                 |    6 +-
 7 files changed, 90 insertions(+), 25 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 692ffef..571e989 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -235,6 +235,7 @@ proc files.
 		neg=N	Number of negative lookups made
 		pos=N	Number of positive lookups made
 		crt=N	Number of objects created by lookup
+		tmo=N	Number of lookups timed out and requeued
 	Updates	n=N	Number of update cookie requests seen
 		nul=N	Number of upd reqs given a NULL parent
 		run=N	Number of upd reqs granted CPU time
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 8e67abf..9d3c426 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -114,8 +114,9 @@ nomem_lookup_data:
 
 /*
  * attempt to look up the nominated node in this cache
+ * - return -ETIMEDOUT to be scheduled again
  */
-static void cachefiles_lookup_object(struct fscache_object *_object)
+static int cachefiles_lookup_object(struct fscache_object *_object)
 {
 	struct cachefiles_lookup_data *lookup_data;
 	struct cachefiles_object *parent, *object;
@@ -145,13 +146,14 @@ static void cachefiles_lookup_object(struct fscache_object *_object)
 	    object->fscache.cookie->def->type != FSCACHE_COOKIE_TYPE_INDEX)
 		cachefiles_attr_changed(&object->fscache);
 
-	if (ret < 0) {
+	if (ret < 0 && ret != -ETIMEDOUT) {
 		printk(KERN_WARNING "CacheFiles: Lookup failed error %d\n",
 		       ret);
 		fscache_object_lookup_error(&object->fscache);
 	}
 
 	_leave(" [%d]", ret);
+	return ret;
 }
 
 /*
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 00a0cda..14ac480 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -21,12 +21,6 @@
 #include <linux/security.h>
 #include "internal.h"
 
-static int cachefiles_wait_bit(void *flags)
-{
-	schedule();
-	return 0;
-}
-
 #define CACHEFILES_KEYBUF_SIZE 512
 
 /*
@@ -100,8 +94,8 @@ static noinline void cachefiles_printk_object(struct cachefiles_object *object,
 /*
  * record the fact that an object is now active
  */
-static void cachefiles_mark_object_active(struct cachefiles_cache *cache,
-					  struct cachefiles_object *object)
+static int cachefiles_mark_object_active(struct cachefiles_cache *cache,
+					 struct cachefiles_object *object)
 {
 	struct cachefiles_object *xobject;
 	struct rb_node **_p, *_parent = NULL;
@@ -139,8 +133,8 @@ try_again:
 	rb_insert_color(&object->active_node, &cache->active_nodes);
 
 	write_unlock(&cache->active_lock);
-	_leave("");
-	return;
+	_leave(" = 0");
+	return 0;
 
 	/* an old object from a previous incarnation is hogging the slot - we
 	 * need to wait for it to be destroyed */
@@ -155,13 +149,64 @@ wait_for_old_object:
 	atomic_inc(&xobject->usage);
 	write_unlock(&cache->active_lock);
 
-	_debug(">>> wait");
-	wait_on_bit(&xobject->flags, CACHEFILES_OBJECT_ACTIVE,
-		    cachefiles_wait_bit, TASK_UNINTERRUPTIBLE);
-	_debug("<<< waited");
+	if (test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
+		wait_queue_head_t *wq;
+
+		signed long timeout = 60 * HZ;
+		wait_queue_t wait;
+		bool requeue;
+
+		/* if the object we're waiting for is queued for processing,
+		 * then just put ourselves on the queue behind it */
+		if (slow_work_is_queued(&xobject->fscache.work)) {
+			_debug("queue OBJ%x behind OBJ%x immediately",
+			       object->fscache.debug_id,
+			       xobject->fscache.debug_id);
+			goto requeue;
+		}
+
+		/* otherwise we sleep until either the object we're waiting for
+		 * is done, or the slow-work facility wants the thread back to
+		 * do other work */
+		wq = bit_waitqueue(&xobject->flags, CACHEFILES_OBJECT_ACTIVE);
+		init_wait(&wait);
+		requeue = false;
+		do {
+			prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
+			if (!test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags))
+				break;
+			requeue = slow_work_sleep_till_thread_needed(
+				&object->fscache.work, &timeout);
+		} while (timeout > 0 && !requeue);
+		finish_wait(wq, &wait);
+
+		if (requeue &&
+		    test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
+			_debug("queue OBJ%x behind OBJ%x after wait",
+			       object->fscache.debug_id,
+			       xobject->fscache.debug_id);
+			goto requeue;
+		}
+
+		if (timeout <= 0) {
+			printk(KERN_ERR "\n");
+			printk(KERN_ERR "CacheFiles: Error: Overlong"
+			       " wait for old active object to go away\n");
+			cachefiles_printk_object(object, xobject);
+			goto requeue;
+		}
+	}
+
+	ASSERT(!test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags));
 
 	cache->cache.ops->put_object(&xobject->fscache);
 	goto try_again;
+
+requeue:
+	clear_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags);
+	cache->cache.ops->put_object(&xobject->fscache);
+	_leave(" = -ETIMEDOUT");
+	return -ETIMEDOUT;
 }
 
 /*
@@ -466,12 +511,15 @@ lookup_again:
 	}
 
 	/* note that we're now using this object */
-	cachefiles_mark_object_active(cache, object);
+	ret = cachefiles_mark_object_active(cache, object);
 
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(dir);
 	dir = NULL;
 
+	if (ret == -ETIMEDOUT)
+		goto mark_active_timed_out;
+
 	_debug("=== OBTAINED_OBJECT ===");
 
 	if (object->new) {
@@ -515,6 +563,10 @@ create_error:
 		cachefiles_io_error(cache, "Create/mkdir failed");
 	goto error;
 
+mark_active_timed_out:
+	_debug("mark active timed out");
+	goto release_dentry;
+
 check_error:
 	_debug("check error %d", ret);
 	write_lock(&cache->active_lock);
@@ -522,7 +574,7 @@ check_error:
 	clear_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags);
 	wake_up_bit(&object->flags, CACHEFILES_OBJECT_ACTIVE);
 	write_unlock(&cache->active_lock);
-
+release_dentry:
 	dput(object->dentry);
 	object->dentry = NULL;
 	goto error_out;
@@ -543,9 +595,6 @@ error:
 error_out2:
 	dput(dir);
 error_out:
-	if (ret == -ENOSPC)
-		ret = -ENOBUFS;
-
 	_leave(" = error %d", -ret);
 	return ret;
 }
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 5b49a37..0ca2566 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -215,6 +215,7 @@ extern atomic_t fscache_n_object_no_alloc;
 extern atomic_t fscache_n_object_lookups;
 extern atomic_t fscache_n_object_lookups_negative;
 extern atomic_t fscache_n_object_lookups_positive;
+extern atomic_t fscache_n_object_lookups_timed_out;
 extern atomic_t fscache_n_object_created;
 extern atomic_t fscache_n_object_avail;
 extern atomic_t fscache_n_object_dead;
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index f3f952c..e513ac5 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -468,6 +468,7 @@ static void fscache_lookup_object(struct fscache_object *object)
 {
 	struct fscache_cookie *cookie = object->cookie;
 	struct fscache_object *parent;
+	int ret;
 
 	_enter("");
 
@@ -493,12 +494,19 @@ static void fscache_lookup_object(struct fscache_object *object)
 
 	fscache_stat(&fscache_n_object_lookups);
 	fscache_stat(&fscache_n_cop_lookup_object);
-	object->cache->ops->lookup_object(object);
+	ret = object->cache->ops->lookup_object(object);
 	fscache_stat_d(&fscache_n_cop_lookup_object);
 
 	if (test_bit(FSCACHE_OBJECT_EV_ERROR, &object->events))
 		set_bit(FSCACHE_COOKIE_UNAVAILABLE, &cookie->flags);
 
+	if (ret == -ETIMEDOUT) {
+		/* probably stuck behind another object, so move this one to
+		 * the back of the queue */
+		fscache_stat(&fscache_n_object_lookups_timed_out);
+		set_bit(FSCACHE_OBJECT_EV_REQUEUE, &object->events);
+	}
+
 	_leave("");
 }
 
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 05f77ca..46435f3 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -98,6 +98,7 @@ atomic_t fscache_n_object_no_alloc;
 atomic_t fscache_n_object_lookups;
 atomic_t fscache_n_object_lookups_negative;
 atomic_t fscache_n_object_lookups_positive;
+atomic_t fscache_n_object_lookups_timed_out;
 atomic_t fscache_n_object_created;
 atomic_t fscache_n_object_avail;
 atomic_t fscache_n_object_dead;
@@ -160,10 +161,11 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_acquires_nobufs),
 		   atomic_read(&fscache_n_acquires_oom));
 
-	seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u\n",
+	seq_printf(m, "Lookups: n=%u neg=%u pos=%u crt=%u tmo=%u\n",
 		   atomic_read(&fscache_n_object_lookups),
 		   atomic_read(&fscache_n_object_lookups_negative),
 		   atomic_read(&fscache_n_object_lookups_positive),
+		   atomic_read(&fscache_n_object_lookups_timed_out),
 		   atomic_read(&fscache_n_object_created));
 
 	seq_printf(m, "Updates: n=%u nul=%u run=%u\n",
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 5db5000..7be0c6f 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -234,8 +234,10 @@ struct fscache_cache_ops {
 	struct fscache_object *(*alloc_object)(struct fscache_cache *cache,
 					       struct fscache_cookie *cookie);
 
-	/* look up the object for a cookie */
-	void (*lookup_object)(struct fscache_object *object);
+	/* look up the object for a cookie
+	 * - return -ETIMEDOUT to be requeued
+	 */
+	int (*lookup_object)(struct fscache_object *object);
 
 	/* finished looking up */
 	void (*lookup_complete)(struct fscache_object *object);

