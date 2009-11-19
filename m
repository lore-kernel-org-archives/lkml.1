Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZKSRVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZKSRVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZKSRVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:21:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbZKSRVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:21:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/28] FS-Cache: Add counters for entry/exit to/from cache
	operation functions
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:21:25 +0000
Message-ID: <20091119172125.1679.49293.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Count entries to and exits from cache operation table functions.  Maintain
these as a single counter that's added to or removed from as appropriate.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt |   16 +++++++++++
 fs/fscache/cache.c                            |    4 +++
 fs/fscache/cookie.c                           |    9 +++++-
 fs/fscache/internal.h                         |   22 +++++++++++++++
 fs/fscache/object.c                           |   26 ++++++++++++++++--
 fs/fscache/page.c                             |   29 ++++++++++++++++----
 fs/fscache/stats.c                            |   37 +++++++++++++++++++++++++
 7 files changed, 134 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index cf13cd3..472398f 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -274,6 +274,22 @@ proc files.
 		dfr=N	Number of async ops queued for deferred release
 		rel=N	Number of async ops released
 		gc=N	Number of deferred-release async ops garbage collected
+	CacheOp	alo=N	Number of in-progress alloc_object() cache ops
+		luo=N	Number of in-progress lookup_object() cache ops
+		luc=N	Number of in-progress lookup_complete() cache ops
+		gro=N	Number of in-progress grab_object() cache ops
+		upo=N	Number of in-progress update_object() cache ops
+		dro=N	Number of in-progress drop_object() cache ops
+		pto=N	Number of in-progress put_object() cache ops
+		syn=N	Number of in-progress sync_cache() cache ops
+		atc=N	Number of in-progress attr_changed() cache ops
+		rap=N	Number of in-progress read_or_alloc_page() cache ops
+		ras=N	Number of in-progress read_or_alloc_pages() cache ops
+		alp=N	Number of in-progress allocate_page() cache ops
+		als=N	Number of in-progress allocate_pages() cache ops
+		wrp=N	Number of in-progress write_page() cache ops
+		ucp=N	Number of in-progress uncache_page() cache ops
+		dsp=N	Number of in-progress dissociate_pages() cache ops
 
 
  (*) /proc/fs/fscache/histogram
diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index 724384e..6a3c48a 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -381,11 +381,15 @@ void fscache_withdraw_cache(struct fscache_cache *cache)
 
 	/* make sure all pages pinned by operations on behalf of the netfs are
 	 * written to disk */
+	fscache_stat(&fscache_n_cop_sync_cache);
 	cache->ops->sync_cache(cache);
+	fscache_stat_d(&fscache_n_cop_sync_cache);
 
 	/* dissociate all the netfs pages backed by this cache from the block
 	 * mappings in the cache */
+	fscache_stat(&fscache_n_cop_dissociate_pages);
 	cache->ops->dissociate_pages(cache);
+	fscache_stat_d(&fscache_n_cop_dissociate_pages);
 
 	/* we now have to destroy all the active objects pertaining to this
 	 * cache - which we do by passing them off to thread pool to be
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 9b51873..432482e 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -249,7 +249,9 @@ static int fscache_alloc_object(struct fscache_cache *cache,
 
 	/* ask the cache to allocate an object (we may end up with duplicate
 	 * objects at this stage, but we sort that out later) */
+	fscache_stat(&fscache_n_cop_alloc_object);
 	object = cache->ops->alloc_object(cache, cookie);
+	fscache_stat_d(&fscache_n_cop_alloc_object);
 	if (IS_ERR(object)) {
 		fscache_stat(&fscache_n_object_no_alloc);
 		ret = PTR_ERR(object);
@@ -270,8 +272,11 @@ static int fscache_alloc_object(struct fscache_cache *cache,
 	/* only attach if we managed to allocate all we needed, otherwise
 	 * discard the object we just allocated and instead use the one
 	 * attached to the cookie */
-	if (fscache_attach_object(cookie, object) < 0)
+	if (fscache_attach_object(cookie, object) < 0) {
+		fscache_stat(&fscache_n_cop_put_object);
 		cache->ops->put_object(object);
+		fscache_stat_d(&fscache_n_cop_put_object);
+	}
 
 	_leave(" = 0");
 	return 0;
@@ -287,7 +292,9 @@ object_already_extant:
 	return 0;
 
 error_put:
+	fscache_stat(&fscache_n_cop_put_object);
 	cache->ops->put_object(object);
+	fscache_stat_d(&fscache_n_cop_put_object);
 error:
 	_leave(" = %d", ret);
 	return ret;
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index fe02973..b85cc89 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -208,11 +208,33 @@ extern atomic_t fscache_n_checkaux_okay;
 extern atomic_t fscache_n_checkaux_update;
 extern atomic_t fscache_n_checkaux_obsolete;
 
+extern atomic_t fscache_n_cop_alloc_object;
+extern atomic_t fscache_n_cop_lookup_object;
+extern atomic_t fscache_n_cop_lookup_complete;
+extern atomic_t fscache_n_cop_grab_object;
+extern atomic_t fscache_n_cop_update_object;
+extern atomic_t fscache_n_cop_drop_object;
+extern atomic_t fscache_n_cop_put_object;
+extern atomic_t fscache_n_cop_sync_cache;
+extern atomic_t fscache_n_cop_attr_changed;
+extern atomic_t fscache_n_cop_read_or_alloc_page;
+extern atomic_t fscache_n_cop_read_or_alloc_pages;
+extern atomic_t fscache_n_cop_allocate_page;
+extern atomic_t fscache_n_cop_allocate_pages;
+extern atomic_t fscache_n_cop_write_page;
+extern atomic_t fscache_n_cop_uncache_page;
+extern atomic_t fscache_n_cop_dissociate_pages;
+
 static inline void fscache_stat(atomic_t *stat)
 {
 	atomic_inc(stat);
 }
 
+static inline void fscache_stat_d(atomic_t *stat)
+{
+	atomic_dec(stat);
+}
+
 extern const struct file_operations fscache_stats_fops;
 #else
 
diff --git a/fs/fscache/object.c b/fs/fscache/object.c
index ad1644f..0d65c0c 100644
--- a/fs/fscache/object.c
+++ b/fs/fscache/object.c
@@ -144,13 +144,17 @@ static void fscache_object_state_machine(struct fscache_object *object)
 	case FSCACHE_OBJECT_UPDATING:
 		clear_bit(FSCACHE_OBJECT_EV_UPDATE, &object->events);
 		fscache_stat(&fscache_n_updates_run);
+		fscache_stat(&fscache_n_cop_update_object);
 		object->cache->ops->update_object(object);
+		fscache_stat_d(&fscache_n_cop_update_object);
 		goto active_transit;
 
 		/* handle an object dying during lookup or creation */
 	case FSCACHE_OBJECT_LC_DYING:
 		object->event_mask &= ~(1 << FSCACHE_OBJECT_EV_UPDATE);
+		fscache_stat(&fscache_n_cop_lookup_complete);
 		object->cache->ops->lookup_complete(object);
+		fscache_stat_d(&fscache_n_cop_lookup_complete);
 
 		spin_lock(&object->lock);
 		object->state = FSCACHE_OBJECT_DYING;
@@ -416,7 +420,9 @@ static void fscache_initialise_object(struct fscache_object *object)
 			 * binding on to us, so we need to make sure we don't
 			 * add ourself to the list multiple times */
 			if (list_empty(&object->dep_link)) {
+				fscache_stat(&fscache_n_cop_grab_object);
 				object->cache->ops->grab_object(object);
+				fscache_stat_d(&fscache_n_cop_grab_object);
 				list_add(&object->dep_link,
 					 &parent->dependents);
 
@@ -478,7 +484,9 @@ static void fscache_lookup_object(struct fscache_object *object)
 	       object->cache->tag->name);
 
 	fscache_stat(&fscache_n_object_lookups);
+	fscache_stat(&fscache_n_cop_lookup_object);
 	object->cache->ops->lookup_object(object);
+	fscache_stat_d(&fscache_n_cop_lookup_object);
 
 	if (test_bit(FSCACHE_OBJECT_EV_ERROR, &object->events))
 		set_bit(FSCACHE_COOKIE_UNAVAILABLE, &cookie->flags);
@@ -602,7 +610,9 @@ static void fscache_object_available(struct fscache_object *object)
 	}
 	spin_unlock(&object->lock);
 
+	fscache_stat(&fscache_n_cop_lookup_complete);
 	object->cache->ops->lookup_complete(object);
+	fscache_stat_d(&fscache_n_cop_lookup_complete);
 	fscache_enqueue_dependents(object);
 
 	fscache_hist(fscache_obj_instantiate_histogram, object->lookup_jif);
@@ -625,7 +635,9 @@ static void fscache_drop_object(struct fscache_object *object)
 	list_del_init(&object->cache_link);
 	spin_unlock(&cache->object_list_lock);
 
+	fscache_stat(&fscache_n_cop_drop_object);
 	cache->ops->drop_object(object);
+	fscache_stat_d(&fscache_n_cop_drop_object);
 
 	if (parent) {
 		_debug("release parent OBJ%x {%d}",
@@ -640,7 +652,9 @@ static void fscache_drop_object(struct fscache_object *object)
 	}
 
 	/* this just shifts the object release to the slow work processor */
+	fscache_stat(&fscache_n_cop_put_object);
 	object->cache->ops->put_object(object);
+	fscache_stat_d(&fscache_n_cop_put_object);
 
 	_leave("");
 }
@@ -730,8 +744,12 @@ static int fscache_object_slow_work_get_ref(struct slow_work *work)
 {
 	struct fscache_object *object =
 		container_of(work, struct fscache_object, work);
+	int ret;
 
-	return object->cache->ops->grab_object(object) ? 0 : -EAGAIN;
+	fscache_stat(&fscache_n_cop_grab_object);
+	ret = object->cache->ops->grab_object(object) ? 0 : -EAGAIN;
+	fscache_stat_d(&fscache_n_cop_grab_object);
+	return ret;
 }
 
 /*
@@ -742,7 +760,9 @@ static void fscache_object_slow_work_put_ref(struct slow_work *work)
 	struct fscache_object *object =
 		container_of(work, struct fscache_object, work);
 
-	return object->cache->ops->put_object(object);
+	fscache_stat(&fscache_n_cop_put_object);
+	object->cache->ops->put_object(object);
+	fscache_stat_d(&fscache_n_cop_put_object);
 }
 
 /*
@@ -779,7 +799,9 @@ static void fscache_enqueue_dependents(struct fscache_object *object)
 
 		/* sort onto appropriate lists */
 		fscache_enqueue_object(dep);
+		fscache_stat(&fscache_n_cop_put_object);
 		dep->cache->ops->put_object(dep);
+		fscache_stat_d(&fscache_n_cop_put_object);
 
 		if (!list_empty(&object->dependents))
 			cond_resched_lock(&object->lock);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c5973e3..250dfd3 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -71,7 +71,9 @@ static void fscache_attr_changed_op(struct fscache_operation *op)
 
 	if (fscache_object_is_active(object)) {
 		fscache_set_op_state(op, "CallFS");
+		fscache_stat(&fscache_n_cop_attr_changed);
 		ret = object->cache->ops->attr_changed(object);
+		fscache_stat_d(&fscache_n_cop_attr_changed);
 		fscache_set_op_state(op, "Done");
 		if (ret < 0)
 			fscache_abort_object(object);
@@ -300,11 +302,15 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 
 	/* ask the cache to honour the operation */
 	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
+		fscache_stat(&fscache_n_cop_allocate_page);
 		ret = object->cache->ops->allocate_page(op, page, gfp);
+		fscache_stat_d(&fscache_n_cop_allocate_page);
 		if (ret == 0)
 			ret = -ENODATA;
 	} else {
+		fscache_stat(&fscache_n_cop_read_or_alloc_page);
 		ret = object->cache->ops->read_or_alloc_page(op, page, gfp);
+		fscache_stat_d(&fscache_n_cop_read_or_alloc_page);
 	}
 
 	if (ret == -ENOMEM)
@@ -358,7 +364,6 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 				  void *context,
 				  gfp_t gfp)
 {
-	fscache_pages_retrieval_func_t func;
 	struct fscache_retrieval *op;
 	struct fscache_object *object;
 	int ret;
@@ -413,11 +418,17 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 	}
 
 	/* ask the cache to honour the operation */
-	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags))
-		func = object->cache->ops->allocate_pages;
-	else
-		func = object->cache->ops->read_or_alloc_pages;
-	ret = func(op, pages, nr_pages, gfp);
+	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
+		fscache_stat(&fscache_n_cop_allocate_pages);
+		ret = object->cache->ops->allocate_pages(
+			op, pages, nr_pages, gfp);
+		fscache_stat_d(&fscache_n_cop_allocate_pages);
+	} else {
+		fscache_stat(&fscache_n_cop_read_or_alloc_pages);
+		ret = object->cache->ops->read_or_alloc_pages(
+			op, pages, nr_pages, gfp);
+		fscache_stat_d(&fscache_n_cop_read_or_alloc_pages);
+	}
 
 	if (ret == -ENOMEM)
 		fscache_stat(&fscache_n_retrievals_nomem);
@@ -500,7 +511,9 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
 	}
 
 	/* ask the cache to honour the operation */
+	fscache_stat(&fscache_n_cop_allocate_page);
 	ret = object->cache->ops->allocate_page(op, page, gfp);
+	fscache_stat_d(&fscache_n_cop_allocate_page);
 
 	if (ret < 0)
 		fscache_stat(&fscache_n_allocs_nobufs);
@@ -578,7 +591,9 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	if (page) {
 		fscache_set_op_state(&op->op, "Store");
+		fscache_stat(&fscache_n_cop_write_page);
 		ret = object->cache->ops->write_page(op, page);
+		fscache_stat_d(&fscache_n_cop_write_page);
 		fscache_set_op_state(&op->op, "EndWrite");
 		fscache_end_page_write(cookie, page);
 		page_cache_release(page);
@@ -786,7 +801,9 @@ void __fscache_uncache_page(struct fscache_cookie *cookie, struct page *page)
 	if (TestClearPageFsCache(page) &&
 	    object->cache->ops->uncache_page) {
 		/* the cache backend releases the cookie lock */
+		fscache_stat(&fscache_n_cop_uncache_page);
 		object->cache->ops->uncache_page(object, page);
+		fscache_stat_d(&fscache_n_cop_uncache_page);
 		goto done;
 	}
 
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 65deb99..20233fb 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -93,6 +93,23 @@ atomic_t fscache_n_checkaux_okay;
 atomic_t fscache_n_checkaux_update;
 atomic_t fscache_n_checkaux_obsolete;
 
+atomic_t fscache_n_cop_alloc_object;
+atomic_t fscache_n_cop_lookup_object;
+atomic_t fscache_n_cop_lookup_complete;
+atomic_t fscache_n_cop_grab_object;
+atomic_t fscache_n_cop_update_object;
+atomic_t fscache_n_cop_drop_object;
+atomic_t fscache_n_cop_put_object;
+atomic_t fscache_n_cop_sync_cache;
+atomic_t fscache_n_cop_attr_changed;
+atomic_t fscache_n_cop_read_or_alloc_page;
+atomic_t fscache_n_cop_read_or_alloc_pages;
+atomic_t fscache_n_cop_allocate_page;
+atomic_t fscache_n_cop_allocate_pages;
+atomic_t fscache_n_cop_write_page;
+atomic_t fscache_n_cop_uncache_page;
+atomic_t fscache_n_cop_dissociate_pages;
+
 /*
  * display the general statistics
  */
@@ -192,6 +209,26 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_op_deferred_release),
 		   atomic_read(&fscache_n_op_release),
 		   atomic_read(&fscache_n_op_gc));
+
+	seq_printf(m, "CacheOp: alo=%d luo=%d luc=%d gro=%d\n",
+		   atomic_read(&fscache_n_cop_alloc_object),
+		   atomic_read(&fscache_n_cop_lookup_object),
+		   atomic_read(&fscache_n_cop_lookup_complete),
+		   atomic_read(&fscache_n_cop_grab_object));
+	seq_printf(m, "CacheOp: upo=%d dro=%d pto=%d atc=%d syn=%d\n",
+		   atomic_read(&fscache_n_cop_update_object),
+		   atomic_read(&fscache_n_cop_drop_object),
+		   atomic_read(&fscache_n_cop_put_object),
+		   atomic_read(&fscache_n_cop_attr_changed),
+		   atomic_read(&fscache_n_cop_sync_cache));
+	seq_printf(m, "CacheOp: rap=%d ras=%d alp=%d als=%d wrp=%d ucp=%d dsp=%d\n",
+		   atomic_read(&fscache_n_cop_read_or_alloc_page),
+		   atomic_read(&fscache_n_cop_read_or_alloc_pages),
+		   atomic_read(&fscache_n_cop_allocate_page),
+		   atomic_read(&fscache_n_cop_allocate_pages),
+		   atomic_read(&fscache_n_cop_write_page),
+		   atomic_read(&fscache_n_cop_uncache_page),
+		   atomic_read(&fscache_n_cop_dissociate_pages));
 	return 0;
 }
 

