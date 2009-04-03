Return-Path: <linux-kernel-owner+w=401wt.eu-S1765894AbZDCQCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765894AbZDCQCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbZDCPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:55:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56546 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479AbZDCPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:55:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/41] FS-Cache: Add cache management [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:55:43 +0100
Message-ID: <20090403155543.28714.58256.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the entry points by which a cache backend may initialise, add,
declare an error upon and withdraw a cache.

Further, an object is created in sysfs under which each cache added will get
an object created:

	/sys/fs/fscache/<cachetag>/

All of this is described in Documentation/filesystems/caching/backend-api.txt
added by a previous patch.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/cache.c |  249 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fscache/main.c  |    7 +
 2 files changed, 256 insertions(+), 0 deletions(-)


diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index 1a28df3..355172f 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -16,6 +16,8 @@
 
 LIST_HEAD(fscache_cache_list);
 DECLARE_RWSEM(fscache_addremove_sem);
+DECLARE_WAIT_QUEUE_HEAD(fscache_cache_cleared_wq);
+EXPORT_SYMBOL(fscache_cache_cleared_wq);
 
 static LIST_HEAD(fscache_cache_tag_list);
 
@@ -164,3 +166,250 @@ no_preference:
 	_leave(" = %p [first]", cache);
 	return cache;
 }
+
+/**
+ * fscache_init_cache - Initialise a cache record
+ * @cache: The cache record to be initialised
+ * @ops: The cache operations to be installed in that record
+ * @idfmt: Format string to define identifier
+ * @...: sprintf-style arguments
+ *
+ * Initialise a record of a cache and fill in the name.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_init_cache(struct fscache_cache *cache,
+			const struct fscache_cache_ops *ops,
+			const char *idfmt,
+			...)
+{
+	va_list va;
+
+	memset(cache, 0, sizeof(*cache));
+
+	cache->ops = ops;
+
+	va_start(va, idfmt);
+	vsnprintf(cache->identifier, sizeof(cache->identifier), idfmt, va);
+	va_end(va);
+
+	INIT_WORK(&cache->op_gc, NULL);
+	INIT_LIST_HEAD(&cache->link);
+	INIT_LIST_HEAD(&cache->object_list);
+	INIT_LIST_HEAD(&cache->op_gc_list);
+	spin_lock_init(&cache->object_list_lock);
+	spin_lock_init(&cache->op_gc_list_lock);
+}
+EXPORT_SYMBOL(fscache_init_cache);
+
+/**
+ * fscache_add_cache - Declare a cache as being open for business
+ * @cache: The record describing the cache
+ * @ifsdef: The record of the cache object describing the top-level index
+ * @tagname: The tag describing this cache
+ *
+ * Add a cache to the system, making it available for netfs's to use.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+int fscache_add_cache(struct fscache_cache *cache,
+		      struct fscache_object *ifsdef,
+		      const char *tagname)
+{
+	struct fscache_cache_tag *tag;
+
+	BUG_ON(!cache->ops);
+	BUG_ON(!ifsdef);
+
+	cache->flags = 0;
+	ifsdef->event_mask = ULONG_MAX & ~(1 << FSCACHE_OBJECT_EV_CLEARED);
+	ifsdef->state = FSCACHE_OBJECT_ACTIVE;
+
+	if (!tagname)
+		tagname = cache->identifier;
+
+	BUG_ON(!tagname[0]);
+
+	_enter("{%s.%s},,%s", cache->ops->name, cache->identifier, tagname);
+
+	/* we use the cache tag to uniquely identify caches */
+	tag = __fscache_lookup_cache_tag(tagname);
+	if (IS_ERR(tag))
+		goto nomem;
+
+	if (test_and_set_bit(FSCACHE_TAG_RESERVED, &tag->flags))
+		goto tag_in_use;
+
+	cache->kobj = kobject_create_and_add(tagname, fscache_root);
+	if (!cache->kobj)
+		goto error;
+
+	ifsdef->cookie = &fscache_fsdef_index;
+	ifsdef->cache = cache;
+	cache->fsdef = ifsdef;
+
+	down_write(&fscache_addremove_sem);
+
+	tag->cache = cache;
+	cache->tag = tag;
+
+	/* add the cache to the list */
+	list_add(&cache->link, &fscache_cache_list);
+
+	/* add the cache's netfs definition index object to the cache's
+	 * list */
+	spin_lock(&cache->object_list_lock);
+	list_add_tail(&ifsdef->cache_link, &cache->object_list);
+	spin_unlock(&cache->object_list_lock);
+
+	/* add the cache's netfs definition index object to the top level index
+	 * cookie as a known backing object */
+	spin_lock(&fscache_fsdef_index.lock);
+
+	hlist_add_head(&ifsdef->cookie_link,
+		       &fscache_fsdef_index.backing_objects);
+
+	atomic_inc(&fscache_fsdef_index.usage);
+
+	/* done */
+	spin_unlock(&fscache_fsdef_index.lock);
+	up_write(&fscache_addremove_sem);
+
+	printk(KERN_NOTICE "FS-Cache: Cache \"%s\" added (type %s)\n",
+	       cache->tag->name, cache->ops->name);
+	kobject_uevent(cache->kobj, KOBJ_ADD);
+
+	_leave(" = 0 [%s]", cache->identifier);
+	return 0;
+
+tag_in_use:
+	printk(KERN_ERR "FS-Cache: Cache tag '%s' already in use\n", tagname);
+	__fscache_release_cache_tag(tag);
+	_leave(" = -EXIST");
+	return -EEXIST;
+
+error:
+	__fscache_release_cache_tag(tag);
+	_leave(" = -EINVAL");
+	return -EINVAL;
+
+nomem:
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(fscache_add_cache);
+
+/**
+ * fscache_io_error - Note a cache I/O error
+ * @cache: The record describing the cache
+ *
+ * Note that an I/O error occurred in a cache and that it should no longer be
+ * used for anything.  This also reports the error into the kernel log.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_io_error(struct fscache_cache *cache)
+{
+	set_bit(FSCACHE_IOERROR, &cache->flags);
+
+	printk(KERN_ERR "FS-Cache: Cache %s stopped due to I/O error\n",
+	       cache->ops->name);
+}
+EXPORT_SYMBOL(fscache_io_error);
+
+/*
+ * request withdrawal of all the objects in a cache
+ * - all the objects being withdrawn are moved onto the supplied list
+ */
+static void fscache_withdraw_all_objects(struct fscache_cache *cache,
+					 struct list_head *dying_objects)
+{
+	struct fscache_object *object;
+
+	spin_lock(&cache->object_list_lock);
+
+	while (!list_empty(&cache->object_list)) {
+		object = list_entry(cache->object_list.next,
+				    struct fscache_object, cache_link);
+		list_move_tail(&object->cache_link, dying_objects);
+
+		_debug("withdraw %p", object->cookie);
+
+		spin_lock(&object->lock);
+		spin_unlock(&cache->object_list_lock);
+		fscache_raise_event(object, FSCACHE_OBJECT_EV_WITHDRAW);
+		spin_unlock(&object->lock);
+
+		cond_resched();
+		spin_lock(&cache->object_list_lock);
+	}
+
+	spin_unlock(&cache->object_list_lock);
+}
+
+/**
+ * fscache_withdraw_cache - Withdraw a cache from the active service
+ * @cache: The record describing the cache
+ *
+ * Withdraw a cache from service, unbinding all its cache objects from the
+ * netfs cookies they're currently representing.
+ *
+ * See Documentation/filesystems/caching/backend-api.txt for a complete
+ * description.
+ */
+void fscache_withdraw_cache(struct fscache_cache *cache)
+{
+	LIST_HEAD(dying_objects);
+
+	_enter("");
+
+	printk(KERN_NOTICE "FS-Cache: Withdrawing cache \"%s\"\n",
+	       cache->tag->name);
+
+	/* make the cache unavailable for cookie acquisition */
+	if (test_and_set_bit(FSCACHE_CACHE_WITHDRAWN, &cache->flags))
+		BUG();
+
+	down_write(&fscache_addremove_sem);
+	list_del_init(&cache->link);
+	cache->tag->cache = NULL;
+	up_write(&fscache_addremove_sem);
+
+	/* make sure all pages pinned by operations on behalf of the netfs are
+	 * written to disk */
+	cache->ops->sync_cache(cache);
+
+	/* dissociate all the netfs pages backed by this cache from the block
+	 * mappings in the cache */
+	cache->ops->dissociate_pages(cache);
+
+	/* we now have to destroy all the active objects pertaining to this
+	 * cache - which we do by passing them off to thread pool to be
+	 * disposed of */
+	_debug("destroy");
+
+	fscache_withdraw_all_objects(cache, &dying_objects);
+
+	/* wait for all extant objects to finish their outstanding operations
+	 * and go away */
+	_debug("wait for finish");
+	wait_event(fscache_cache_cleared_wq,
+		   atomic_read(&cache->object_count) == 0);
+	_debug("wait for clearance");
+	wait_event(fscache_cache_cleared_wq,
+		   list_empty(&cache->object_list));
+	_debug("cleared");
+	ASSERT(list_empty(&dying_objects));
+
+	kobject_put(cache->kobj);
+
+	clear_bit(FSCACHE_TAG_RESERVED, &cache->tag->flags);
+	fscache_release_cache_tag(cache->tag);
+	cache->tag = NULL;
+
+	_leave("");
+}
+EXPORT_SYMBOL(fscache_withdraw_cache);
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 7c734b7..c2f3e63 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -56,9 +56,15 @@ static int __init fscache_init(void)
 	if (ret < 0)
 		goto error_proc;
 
+	fscache_root = kobject_create_and_add("fscache", kernel_kobj);
+	if (!fscache_root)
+		goto error_kobj;
+
 	printk(KERN_NOTICE "FS-Cache: Loaded\n");
 	return 0;
 
+error_kobj:
+	fscache_proc_cleanup();
 error_proc:
 	slow_work_unregister_user();
 error_slow_work:
@@ -74,6 +80,7 @@ static void __exit fscache_exit(void)
 {
 	_enter("");
 
+	kobject_put(fscache_root);
 	fscache_proc_cleanup();
 	slow_work_unregister_user();
 	printk(KERN_NOTICE "FS-Cache: Unloaded\n");

