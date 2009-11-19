Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZKSRV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZKSRV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZKSRV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZKSRVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/28] FS-Cache: Fix lock misorder in fscache_write_op()
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:51 +0000
Message-ID: <20091119172150.1679.52797.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FS-Cache has two structs internally for keeping track of the internal state of
a cached file: the fscache_cookie struct, which represents the netfs's state,
and fscache_object struct, which represents the cache's state.  Each has a
pointer that points to the other (when both are in existence), and each has a
spinlock for pointer maintenance.

Since netfs operations approach these structures from the cookie side, they get
the cookie lock first, then the object lock.  Cache operations, on the other
hand, approach from the object side, and get the object lock first.  It is not
then permitted for a cache operation to get the cookie lock whilst it is
holding the object lock lest deadlock occur; instead, it must do one of two
things:

 (1) increment the cookie usage counter, drop the object lock and then get both
     locks in order, or

 (2) simply hold the object lock as certain parts of the cookie may not be
     altered whilst the object lock is held.

It is also not permitted to follow either pointer without holding the lock at
the end you start with.  To break the pointers between the cookie and the
object, both locks must be held.


fscache_write_op(), however, violates the locking rules: It attempts to get the
cookie lock without (a) checking that the cookie pointer is a valid pointer,
and (b) holding the object lock to protect the cookie pointer whilst it follows
it.  This is so that it can access the pending page store tree without
interference from __fscache_write_page().

This is fixed by splitting the cookie lock, such that the page store tracking
tree is protected by its own lock, and checking that the cookie pointer is
non-NULL before we attempt to follow it whilst holding the object lock.

The new lock is subordinate to both the cookie lock and the object lock, and so
should be taken after those.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |    3 +
 fs/fscache/cookie.c                           |    1 
 fs/fscache/internal.h                         |    4 ++
 fs/fscache/page.c                             |   52 +++++++++++++++++--------
 fs/fscache/stats.c                            |   10 ++++-
 include/linux/fscache-cache.h                 |    1 
 6 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 21d20bf..cd2b4c9 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -269,6 +269,9 @@ proc files.
 		oom=N	Number of store reqs failed -ENOMEM
 		ops=N	Number of store reqs submitted
 		run=N	Number of store reqs granted CPU time
+		pgs=N	Number of pages given store req processing time
+		rxd=N	Number of store reqs deleted from tracking tree
+		olm=N	Number of store reqs over store limit
 	Ops	pend=N	Number of times async ops added to pending queues
 		run=N	Number of times async ops given CPU time
 		enq=N	Number of times async ops queued for processing
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index e6854f5..f979659 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -36,6 +36,7 @@ void fscache_cookie_init_once(void *_cookie)
 
 	memset(cookie, 0, sizeof(*cookie));
 	spin_lock_init(&cookie->lock);
+	spin_lock_init(&cookie->stores_lock);
 	INIT_HLIST_HEAD(&cookie->backing_objects);
 }
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 50324ad..ba1853f 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -17,6 +17,7 @@
  * - cache->object_list_lock
  * - object->lock
  * - object->parent->lock
+ * - cookie->stores_lock
  * - fscache_thread_lock
  *
  */
@@ -174,6 +175,9 @@ extern atomic_t fscache_n_stores_nobufs;
 extern atomic_t fscache_n_stores_oom;
 extern atomic_t fscache_n_store_ops;
 extern atomic_t fscache_n_store_calls;
+extern atomic_t fscache_n_store_pages;
+extern atomic_t fscache_n_store_radix_deletes;
+extern atomic_t fscache_n_store_pages_over_limit;
 
 extern atomic_t fscache_n_marks;
 extern atomic_t fscache_n_uncaches;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index e6f2e61..3ea8897 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -45,16 +45,26 @@ EXPORT_SYMBOL(__fscache_wait_on_page_write);
 /*
  * note that a page has finished being written to the cache
  */
-static void fscache_end_page_write(struct fscache_cookie *cookie, struct page *page)
+static void fscache_end_page_write(struct fscache_object *object,
+				   struct page *page)
 {
-	struct page *xpage;
+	struct fscache_cookie *cookie;
+	struct page *xpage = NULL;
 
-	spin_lock(&cookie->lock);
-	xpage = radix_tree_delete(&cookie->stores, page->index);
-	spin_unlock(&cookie->lock);
-	ASSERT(xpage != NULL);
-
-	wake_up_bit(&cookie->flags, 0);
+	spin_lock(&object->lock);
+	cookie = object->cookie;
+	if (cookie) {
+		/* delete the page from the tree if it is now no longer
+		 * pending */
+		spin_lock(&cookie->stores_lock);
+		fscache_stat(&fscache_n_store_radix_deletes);
+		xpage = radix_tree_delete(&cookie->stores, page->index);
+		spin_unlock(&cookie->stores_lock);
+		wake_up_bit(&cookie->flags, 0);
+	}
+	spin_unlock(&object->lock);
+	if (xpage)
+		page_cache_release(xpage);
 }
 
 /*
@@ -591,7 +601,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	struct fscache_storage *op =
 		container_of(_op, struct fscache_storage, op);
 	struct fscache_object *object = op->op.object;
-	struct fscache_cookie *cookie = object->cookie;
+	struct fscache_cookie *cookie;
 	struct page *page;
 	unsigned n;
 	void *results[1];
@@ -601,16 +611,17 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	fscache_set_op_state(&op->op, "GetPage");
 
-	spin_lock(&cookie->lock);
 	spin_lock(&object->lock);
+	cookie = object->cookie;
 
-	if (!fscache_object_is_active(object)) {
+	if (!fscache_object_is_active(object) || !cookie) {
 		spin_unlock(&object->lock);
-		spin_unlock(&cookie->lock);
 		_leave("");
 		return;
 	}
 
+	spin_lock(&cookie->stores_lock);
+
 	fscache_stat(&fscache_n_store_calls);
 
 	/* find a page to store */
@@ -621,23 +632,25 @@ static void fscache_write_op(struct fscache_operation *_op)
 		goto superseded;
 	page = results[0];
 	_debug("gang %d [%lx]", n, page->index);
-	if (page->index > op->store_limit)
+	if (page->index > op->store_limit) {
+		fscache_stat(&fscache_n_store_pages_over_limit);
 		goto superseded;
+	}
 
 	radix_tree_tag_clear(&cookie->stores, page->index,
 			     FSCACHE_COOKIE_PENDING_TAG);
 
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
-	spin_unlock(&cookie->lock);
 
 	if (page) {
 		fscache_set_op_state(&op->op, "Store");
+		fscache_stat(&fscache_n_store_pages);
 		fscache_stat(&fscache_n_cop_write_page);
 		ret = object->cache->ops->write_page(op, page);
 		fscache_stat_d(&fscache_n_cop_write_page);
 		fscache_set_op_state(&op->op, "EndWrite");
-		fscache_end_page_write(cookie, page);
-		page_cache_release(page);
+		fscache_end_page_write(object, page);
 		if (ret < 0) {
 			fscache_set_op_state(&op->op, "Abort");
 			fscache_abort_object(object);
@@ -653,9 +666,9 @@ superseded:
 	/* this writer is going away and there aren't any more things to
 	 * write */
 	_debug("cease");
+	spin_unlock(&cookie->stores_lock);
 	clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
 	spin_unlock(&object->lock);
-	spin_unlock(&cookie->lock);
 	_leave("");
 }
 
@@ -731,6 +744,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	/* add the page to the pending-storage radix tree on the backing
 	 * object */
 	spin_lock(&object->lock);
+	spin_lock(&cookie->stores_lock);
 
 	_debug("store limit %llx", (unsigned long long) object->store_limit);
 
@@ -751,6 +765,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 	if (test_and_set_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags))
 		goto already_pending;
 
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
 	op->op.debug_id	= atomic_inc_return(&fscache_op_debug_id);
@@ -772,6 +787,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 already_queued:
 	fscache_stat(&fscache_n_stores_again);
 already_pending:
+	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 	spin_unlock(&cookie->lock);
 	radix_tree_preload_end();
@@ -781,7 +797,9 @@ already_pending:
 	return 0;
 
 submit_failed:
+	spin_lock(&cookie->stores_lock);
 	radix_tree_delete(&cookie->stores, page->index);
+	spin_unlock(&cookie->stores_lock);
 	page_cache_release(page);
 	ret = -ENOBUFS;
 	goto nobufs;
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 4c07439..1d53ea6 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -58,6 +58,9 @@ atomic_t fscache_n_stores_nobufs;
 atomic_t fscache_n_stores_oom;
 atomic_t fscache_n_store_ops;
 atomic_t fscache_n_store_calls;
+atomic_t fscache_n_store_pages;
+atomic_t fscache_n_store_radix_deletes;
+atomic_t fscache_n_store_pages_over_limit;
 
 atomic_t fscache_n_marks;
 atomic_t fscache_n_uncaches;
@@ -200,9 +203,12 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_stores_again),
 		   atomic_read(&fscache_n_stores_nobufs),
 		   atomic_read(&fscache_n_stores_oom));
-	seq_printf(m, "Stores : ops=%u run=%u\n",
+	seq_printf(m, "Stores : ops=%u run=%u pgs=%u rxd=%u olm=%u\n",
 		   atomic_read(&fscache_n_store_ops),
-		   atomic_read(&fscache_n_store_calls));
+		   atomic_read(&fscache_n_store_calls),
+		   atomic_read(&fscache_n_store_pages),
+		   atomic_read(&fscache_n_store_radix_deletes),
+		   atomic_read(&fscache_n_store_pages_over_limit));
 
 	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u\n",
 		   atomic_read(&fscache_n_op_pend),
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 184cbdf..f3aa4bd 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -310,6 +310,7 @@ struct fscache_cookie {
 	atomic_t			usage;		/* number of users of this cookie */
 	atomic_t			n_children;	/* number of children of this cookie */
 	spinlock_t			lock;
+	spinlock_t			stores_lock;	/* lock on page store tree */
 	struct hlist_head		backing_objects; /* object(s) backing this file/index */
 	const struct fscache_cookie_def	*def;		/* definition */
 	struct fscache_cookie		*parent;	/* parent of this entry */

