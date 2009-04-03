Return-Path: <linux-kernel-owner+w=401wt.eu-S934888AbZDCQFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934888AbZDCQFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934858AbZDCP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:56:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934589AbZDCP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:56:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/41] FS-Cache: Implement data I/O part of netfs API [ver #48]
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
Date: Fri, 03 Apr 2009 16:56:19 +0100
Message-ID: <20090403155619.28714.50277.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the data I/O part of the FS-Cache netfs API.  The documentation and
API header file were added in a previous patch.

This patch implements the following functions for the netfs to call:

 (*) fscache_attr_changed().

     Indicate that the object has changed its attributes.  The only attribute
     currently recorded is the file size.  Only pages within the set file size
     will be stored in the cache.

     This operation is submitted for asynchronous processing, and will return
     immediately.  It will return -ENOMEM if an out of memory error is
     encountered, -ENOBUFS if the object is not actually cached, or 0 if the
     operation is successfully queued.

 (*) fscache_read_or_alloc_page().
 (*) fscache_read_or_alloc_pages().

     Request data be fetched from the disk, and allocate internal metadata to
     track the netfs pages and reserve disk space for unknown pages.

     These operations perform semi-asynchronous data reads.  Upon returning
     they will indicate which pages they think can be retrieved from disk, and
     will have set in progress attempts to retrieve those pages.

     These will return, in order of preference, -ENOMEM on memory allocation
     error, -ERESTARTSYS if a signal interrupted proceedings, -ENODATA if one
     or more requested pages are not yet cached, -ENOBUFS if the object is not
     actually cached or if there isn't space for future pages to be cached on
     this object, or 0 if successful.

     In the case of the multipage function, the pages for which reads are set
     in progress will be removed from the list and the page count decreased
     appropriately.

     If any read operations should fail, the completion function will be given
     an error, and will also be passed contextual information to allow the
     netfs to fall back to querying the server for the absent pages.

     For each successful read, the page completion function will also be
     called.

     Any pages subsequently tracked by the cache will have PG_fscache set upon
     them on return.  fscache_uncache_page() must be called for such pages.

     If supplied by the netfs, the mark_pages_cached() cookie op will be
     invoked for any pages now tracked.

 (*) fscache_alloc_page().

     Allocate internal metadata to track a netfs page and reserve disk space.

     This will return -ENOMEM on memory allocation error, -ERESTARTSYS on
     signal, -ENOBUFS if the object isn't cached, or there isn't enough space
     in the cache, or 0 if successful.

     Any pages subsequently tracked by the cache will have PG_fscache set upon
     them on return.  fscache_uncache_page() must be called for such pages.

     If supplied by the netfs, the mark_pages_cached() cookie op will be
     invoked for any pages now tracked.

 (*) fscache_write_page().

     Request data be stored to disk.  This may only be called on pages that
     have been read or alloc'd by the above three functions and have not yet
     been uncached.

     This will return -ENOMEM on memory allocation error, -ERESTARTSYS on
     signal, -ENOBUFS if the object isn't cached, or there isn't immediately
     enough space in the cache, or 0 if successful.

     On a successful return, this operation will have queued the page for
     asynchronous writing to the cache.  The page will be returned with
     PG_fscache_write set until the write completes one way or another.  The
     caller will not be notified if the write fails due to an I/O error.  If
     that happens, the object will become available and all pending writes will
     be aborted.

     Note that the cache may batch up page writes, and so it may take a while
     to get around to writing them out.

     The caller must assume that until PG_fscache_write is cleared the page is
     use by the cache.  Any changes made to the page may be reflected on disk.
     The page may even be under DMA.

 (*) fscache_uncache_page().

     Indicate that the cache should stop tracking a page previously read or
     alloc'd from the cache.  If the page was alloc'd only, but unwritten, it
     will not appear on disk.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Daire Byrne <Daire.Byrne@framestore.com>
---

 fs/fscache/Makefile     |    3 
 fs/fscache/internal.h   |   21 +
 fs/fscache/page.c       |  816 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fscache.h |   52 +++
 4 files changed, 886 insertions(+), 6 deletions(-)
 create mode 100644 fs/fscache/page.c


diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index 6f82da2..91571b9 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -9,7 +9,8 @@ fscache-y := \
 	main.o \
 	netfs.o \
 	object.o \
-	operation.o
+	operation.o \
+	page.o
 
 fscache-$(CONFIG_PROC_FS) += proc.o
 fscache-$(CONFIG_FSCACHE_STATS) += stats.o
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 014a830..e0cbd16 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -229,6 +229,27 @@ static inline void fscache_cookie_put(struct fscache_cookie *cookie)
 		__fscache_cookie_put(cookie);
 }
 
+/*
+ * get an extra reference to a netfs retrieval context
+ */
+static inline
+void *fscache_get_context(struct fscache_cookie *cookie, void *context)
+{
+	if (cookie->def->get_context)
+		cookie->def->get_context(cookie->netfs_data, context);
+	return context;
+}
+
+/*
+ * release a reference to a netfs retrieval context
+ */
+static inline
+void fscache_put_context(struct fscache_cookie *cookie, void *context)
+{
+	if (cookie->def->put_context)
+		cookie->def->put_context(cookie->netfs_data, context);
+}
+
 /*****************************************************************************/
 /*
  * debug tracing
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
new file mode 100644
index 0000000..2568e0e
--- /dev/null
+++ b/fs/fscache/page.c
@@ -0,0 +1,816 @@
+/* Cache page management and data I/O routines
+ *
+ * Copyright (C) 2004-2008 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#define FSCACHE_DEBUG_LEVEL PAGE
+#include <linux/module.h>
+#include <linux/fscache-cache.h>
+#include <linux/buffer_head.h>
+#include <linux/pagevec.h>
+#include "internal.h"
+
+/*
+ * check to see if a page is being written to the cache
+ */
+bool __fscache_check_page_write(struct fscache_cookie *cookie, struct page *page)
+{
+	void *val;
+
+	rcu_read_lock();
+	val = radix_tree_lookup(&cookie->stores, page->index);
+	rcu_read_unlock();
+
+	return val != NULL;
+}
+EXPORT_SYMBOL(__fscache_check_page_write);
+
+/*
+ * wait for a page to finish being written to the cache
+ */
+void __fscache_wait_on_page_write(struct fscache_cookie *cookie, struct page *page)
+{
+	wait_queue_head_t *wq = bit_waitqueue(&cookie->flags, 0);
+
+	wait_event(*wq, !__fscache_check_page_write(cookie, page));
+}
+EXPORT_SYMBOL(__fscache_wait_on_page_write);
+
+/*
+ * note that a page has finished being written to the cache
+ */
+static void fscache_end_page_write(struct fscache_cookie *cookie, struct page *page)
+{
+	struct page *xpage;
+
+	spin_lock(&cookie->lock);
+	xpage = radix_tree_delete(&cookie->stores, page->index);
+	spin_unlock(&cookie->lock);
+	ASSERT(xpage != NULL);
+
+	wake_up_bit(&cookie->flags, 0);
+}
+
+/*
+ * actually apply the changed attributes to a cache object
+ */
+static void fscache_attr_changed_op(struct fscache_operation *op)
+{
+	struct fscache_object *object = op->object;
+
+	_enter("{OBJ%x OP%x}", object->debug_id, op->debug_id);
+
+	fscache_stat(&fscache_n_attr_changed_calls);
+
+	if (fscache_object_is_active(object) &&
+	    object->cache->ops->attr_changed(object) < 0)
+		fscache_abort_object(object);
+
+	_leave("");
+}
+
+/*
+ * notification that the attributes on an object have changed
+ */
+int __fscache_attr_changed(struct fscache_cookie *cookie)
+{
+	struct fscache_operation *op;
+	struct fscache_object *object;
+
+	_enter("%p", cookie);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+
+	fscache_stat(&fscache_n_attr_changed);
+
+	op = kzalloc(sizeof(*op), GFP_KERNEL);
+	if (!op) {
+		fscache_stat(&fscache_n_attr_changed_nomem);
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	fscache_operation_init(op, NULL);
+	fscache_operation_init_slow(op, fscache_attr_changed_op);
+	op->flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_EXCLUSIVE);
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_exclusive_op(object, op) < 0)
+		goto nobufs;
+	spin_unlock(&cookie->lock);
+	fscache_stat(&fscache_n_attr_changed_ok);
+	fscache_put_operation(op);
+	_leave(" = 0");
+	return 0;
+
+nobufs:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+	fscache_stat(&fscache_n_attr_changed_nobufs);
+	_leave(" = %d", -ENOBUFS);
+	return -ENOBUFS;
+}
+EXPORT_SYMBOL(__fscache_attr_changed);
+
+/*
+ * handle secondary execution given to a retrieval op on behalf of the
+ * cache
+ */
+static void fscache_retrieval_work(struct work_struct *work)
+{
+	struct fscache_retrieval *op =
+		container_of(work, struct fscache_retrieval, op.fast_work);
+	unsigned long start;
+
+	_enter("{OP%x}", op->op.debug_id);
+
+	start = jiffies;
+	op->op.processor(&op->op);
+	fscache_hist(fscache_ops_histogram, start);
+	fscache_put_operation(&op->op);
+}
+
+/*
+ * release a retrieval op reference
+ */
+static void fscache_release_retrieval_op(struct fscache_operation *_op)
+{
+	struct fscache_retrieval *op =
+		container_of(_op, struct fscache_retrieval, op);
+
+	_enter("{OP%x}", op->op.debug_id);
+
+	fscache_hist(fscache_retrieval_histogram, op->start_time);
+	if (op->context)
+		fscache_put_context(op->op.object->cookie, op->context);
+
+	_leave("");
+}
+
+/*
+ * allocate a retrieval op
+ */
+static struct fscache_retrieval *fscache_alloc_retrieval(
+	struct address_space *mapping,
+	fscache_rw_complete_t end_io_func,
+	void *context)
+{
+	struct fscache_retrieval *op;
+
+	/* allocate a retrieval operation and attempt to submit it */
+	op = kzalloc(sizeof(*op), GFP_NOIO);
+	if (!op) {
+		fscache_stat(&fscache_n_retrievals_nomem);
+		return NULL;
+	}
+
+	fscache_operation_init(&op->op, fscache_release_retrieval_op);
+	op->op.flags	= FSCACHE_OP_MYTHREAD | (1 << FSCACHE_OP_WAITING);
+	op->mapping	= mapping;
+	op->end_io_func	= end_io_func;
+	op->context	= context;
+	op->start_time	= jiffies;
+	INIT_WORK(&op->op.fast_work, fscache_retrieval_work);
+	INIT_LIST_HEAD(&op->to_do);
+	return op;
+}
+
+/*
+ * wait for a deferred lookup to complete
+ */
+static int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
+{
+	unsigned long jif;
+
+	_enter("");
+
+	if (!test_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags)) {
+		_leave(" = 0 [imm]");
+		return 0;
+	}
+
+	fscache_stat(&fscache_n_retrievals_wait);
+
+	jif = jiffies;
+	if (wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
+			fscache_wait_bit_interruptible,
+			TASK_INTERRUPTIBLE) != 0) {
+		fscache_stat(&fscache_n_retrievals_intr);
+		_leave(" = -ERESTARTSYS");
+		return -ERESTARTSYS;
+	}
+
+	ASSERT(!test_bit(FSCACHE_COOKIE_LOOKING_UP, &cookie->flags));
+
+	smp_rmb();
+	fscache_hist(fscache_retrieval_delay_histogram, jif);
+	_leave(" = 0 [dly]");
+	return 0;
+}
+
+/*
+ * read a page from the cache or allocate a block in which to store it
+ * - we return:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ERESTARTSYS - interrupted
+ *   -ENOBUFS	- no backing object available in which to cache the block
+ *   -ENODATA	- no data available in the backing object for this block
+ *   0		- dispatched a read - it'll call end_io_func() when finished
+ */
+int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
+				 struct page *page,
+				 fscache_rw_complete_t end_io_func,
+				 void *context,
+				 gfp_t gfp)
+{
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%p,,,", cookie, page);
+
+	fscache_stat(&fscache_n_retrievals);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(page->mapping, end_io_func, context);
+	if (!op) {
+		_leave(" = -ENOMEM");
+		return -ENOMEM;
+	}
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	ASSERTCMP(object->state, >, FSCACHE_OBJECT_LOOKING_UP);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_retrieval_ops);
+
+	/* pin the netfs read context in case we need to do the actual netfs
+	 * read because we've encountered a cache read failure */
+	fscache_get_context(object->cookie, op->context);
+
+	/* we wait for the operation to become active, and then process it
+	 * *here*, in this thread, and not in the thread pool */
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_retrieval_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags)) {
+		ret = object->cache->ops->allocate_page(op, page, gfp);
+		if (ret == 0)
+			ret = -ENODATA;
+	} else {
+		ret = object->cache->ops->read_or_alloc_page(op, page, gfp);
+	}
+
+	if (ret == -ENOMEM)
+		fscache_stat(&fscache_n_retrievals_nomem);
+	else if (ret == -ERESTARTSYS)
+		fscache_stat(&fscache_n_retrievals_intr);
+	else if (ret == -ENODATA)
+		fscache_stat(&fscache_n_retrievals_nodata);
+	else if (ret < 0)
+		fscache_stat(&fscache_n_retrievals_nobufs);
+	else
+		fscache_stat(&fscache_n_retrievals_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_retrievals_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+EXPORT_SYMBOL(__fscache_read_or_alloc_page);
+
+/*
+ * read a list of page from the cache or allocate a block in which to store
+ * them
+ * - we return:
+ *   -ENOMEM	- out of memory, some pages may be being read
+ *   -ERESTARTSYS - interrupted, some pages may be being read
+ *   -ENOBUFS	- no backing object or space available in which to cache any
+ *                pages not being read
+ *   -ENODATA	- no data available in the backing object for some or all of
+ *                the pages
+ *   0		- dispatched a read on all pages
+ *
+ * end_io_func() will be called for each page read from the cache as it is
+ * finishes being read
+ *
+ * any pages for which a read is dispatched will be removed from pages and
+ * nr_pages
+ */
+int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
+				  struct address_space *mapping,
+				  struct list_head *pages,
+				  unsigned *nr_pages,
+				  fscache_rw_complete_t end_io_func,
+				  void *context,
+				  gfp_t gfp)
+{
+	fscache_pages_retrieval_func_t func;
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,,%d,,,", cookie, *nr_pages);
+
+	fscache_stat(&fscache_n_retrievals);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(*nr_pages, >, 0);
+	ASSERT(!list_empty(pages));
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(mapping, end_io_func, context);
+	if (!op)
+		return -ENOMEM;
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_retrieval_ops);
+
+	/* pin the netfs read context in case we need to do the actual netfs
+	 * read because we've encountered a cache read failure */
+	fscache_get_context(object->cookie, op->context);
+
+	/* we wait for the operation to become active, and then process it
+	 * *here*, in this thread, and not in the thread pool */
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_retrieval_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	if (test_bit(FSCACHE_COOKIE_NO_DATA_YET, &object->cookie->flags))
+		func = object->cache->ops->allocate_pages;
+	else
+		func = object->cache->ops->read_or_alloc_pages;
+	ret = func(op, pages, nr_pages, gfp);
+
+	if (ret == -ENOMEM)
+		fscache_stat(&fscache_n_retrievals_nomem);
+	else if (ret == -ERESTARTSYS)
+		fscache_stat(&fscache_n_retrievals_intr);
+	else if (ret == -ENODATA)
+		fscache_stat(&fscache_n_retrievals_nodata);
+	else if (ret < 0)
+		fscache_stat(&fscache_n_retrievals_nobufs);
+	else
+		fscache_stat(&fscache_n_retrievals_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_retrievals_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+EXPORT_SYMBOL(__fscache_read_or_alloc_pages);
+
+/*
+ * allocate a block in the cache on which to store a page
+ * - we return:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ERESTARTSYS - interrupted
+ *   -ENOBUFS	- no backing object available in which to cache the block
+ *   0		- block allocated
+ */
+int __fscache_alloc_page(struct fscache_cookie *cookie,
+			 struct page *page,
+			 gfp_t gfp)
+{
+	struct fscache_retrieval *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%p,,,", cookie, page);
+
+	fscache_stat(&fscache_n_allocs);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	if (fscache_wait_for_deferred_lookup(cookie) < 0)
+		return -ERESTARTSYS;
+
+	op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
+	if (!op)
+		return -ENOMEM;
+
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs_unlock;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto nobufs_unlock;
+	spin_unlock(&cookie->lock);
+
+	fscache_stat(&fscache_n_alloc_ops);
+
+	if (test_bit(FSCACHE_OP_WAITING, &op->op.flags)) {
+		_debug(">>> WT");
+		fscache_stat(&fscache_n_alloc_op_waits);
+		wait_on_bit(&op->op.flags, FSCACHE_OP_WAITING,
+			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+		_debug("<<< GO");
+	}
+
+	/* ask the cache to honour the operation */
+	ret = object->cache->ops->allocate_page(op, page, gfp);
+
+	if (ret < 0)
+		fscache_stat(&fscache_n_allocs_nobufs);
+	else
+		fscache_stat(&fscache_n_allocs_ok);
+
+	fscache_put_retrieval(op);
+	_leave(" = %d", ret);
+	return ret;
+
+nobufs_unlock:
+	spin_unlock(&cookie->lock);
+	kfree(op);
+nobufs:
+	fscache_stat(&fscache_n_allocs_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+}
+EXPORT_SYMBOL(__fscache_alloc_page);
+
+/*
+ * release a write op reference
+ */
+static void fscache_release_write_op(struct fscache_operation *_op)
+{
+	_enter("{OP%x}", _op->debug_id);
+}
+
+/*
+ * perform the background storage of a page into the cache
+ */
+static void fscache_write_op(struct fscache_operation *_op)
+{
+	struct fscache_storage *op =
+		container_of(_op, struct fscache_storage, op);
+	struct fscache_object *object = op->op.object;
+	struct fscache_cookie *cookie = object->cookie;
+	struct page *page;
+	unsigned n;
+	void *results[1];
+	int ret;
+
+	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
+
+	spin_lock(&cookie->lock);
+	spin_lock(&object->lock);
+
+	if (!fscache_object_is_active(object)) {
+		spin_unlock(&object->lock);
+		spin_unlock(&cookie->lock);
+		_leave("");
+		return;
+	}
+
+	fscache_stat(&fscache_n_store_calls);
+
+	/* find a page to store */
+	page = NULL;
+	n = radix_tree_gang_lookup_tag(&cookie->stores, results, 0, 1,
+				       FSCACHE_COOKIE_PENDING_TAG);
+	if (n != 1)
+		goto superseded;
+	page = results[0];
+	_debug("gang %d [%lx]", n, page->index);
+	if (page->index > op->store_limit)
+		goto superseded;
+
+	radix_tree_tag_clear(&cookie->stores, page->index,
+			     FSCACHE_COOKIE_PENDING_TAG);
+
+	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
+
+	if (page) {
+		ret = object->cache->ops->write_page(op, page);
+		fscache_end_page_write(cookie, page);
+		page_cache_release(page);
+		if (ret < 0)
+			fscache_abort_object(object);
+		else
+			fscache_enqueue_operation(&op->op);
+	}
+
+	_leave("");
+	return;
+
+superseded:
+	/* this writer is going away and there aren't any more things to
+	 * write */
+	_debug("cease");
+	clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
+	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
+	_leave("");
+}
+
+/*
+ * request a page be stored in the cache
+ * - returns:
+ *   -ENOMEM	- out of memory, nothing done
+ *   -ENOBUFS	- no backing object available in which to cache the page
+ *   0		- dispatched a write - it'll call end_io_func() when finished
+ *
+ * if the cookie still has a backing object at this point, that object can be
+ * in one of a few states with respect to storage processing:
+ *
+ *  (1) negative lookup, object not yet created (FSCACHE_COOKIE_CREATING is
+ *      set)
+ *
+ *	(a) no writes yet (set FSCACHE_COOKIE_PENDING_FILL and queue deferred
+ *	    fill op)
+ *
+ *	(b) writes deferred till post-creation (mark page for writing and
+ *	    return immediately)
+ *
+ *  (2) negative lookup, object created, initial fill being made from netfs
+ *      (FSCACHE_COOKIE_INITIAL_FILL is set)
+ *
+ *	(a) fill point not yet reached this page (mark page for writing and
+ *          return)
+ *
+ *	(b) fill point passed this page (queue op to store this page)
+ *
+ *  (3) object extant (queue op to store this page)
+ *
+ * any other state is invalid
+ */
+int __fscache_write_page(struct fscache_cookie *cookie,
+			 struct page *page,
+			 gfp_t gfp)
+{
+	struct fscache_storage *op;
+	struct fscache_object *object;
+	int ret;
+
+	_enter("%p,%x,", cookie, (u32) page->flags);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERT(PageFsCache(page));
+
+	fscache_stat(&fscache_n_stores);
+
+	op = kzalloc(sizeof(*op), GFP_NOIO);
+	if (!op)
+		goto nomem;
+
+	fscache_operation_init(&op->op, fscache_release_write_op);
+	fscache_operation_init_slow(&op->op, fscache_write_op);
+	op->op.flags = FSCACHE_OP_SLOW | (1 << FSCACHE_OP_WAITING);
+
+	ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
+	if (ret < 0)
+		goto nomem_free;
+
+	ret = -ENOBUFS;
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects))
+		goto nobufs;
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+	if (test_bit(FSCACHE_IOERROR, &object->cache->flags))
+		goto nobufs;
+
+	/* add the page to the pending-storage radix tree on the backing
+	 * object */
+	spin_lock(&object->lock);
+
+	_debug("store limit %llx", (unsigned long long) object->store_limit);
+
+	ret = radix_tree_insert(&cookie->stores, page->index, page);
+	if (ret < 0) {
+		if (ret == -EEXIST)
+			goto already_queued;
+		_debug("insert failed %d", ret);
+		goto nobufs_unlock_obj;
+	}
+
+	radix_tree_tag_set(&cookie->stores, page->index,
+			   FSCACHE_COOKIE_PENDING_TAG);
+	page_cache_get(page);
+
+	/* we only want one writer at a time, but we do need to queue new
+	 * writers after exclusive ops */
+	if (test_and_set_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags))
+		goto already_pending;
+
+	spin_unlock(&object->lock);
+
+	op->op.debug_id	= atomic_inc_return(&fscache_op_debug_id);
+	op->store_limit = object->store_limit;
+
+	if (fscache_submit_op(object, &op->op) < 0)
+		goto submit_failed;
+
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	fscache_stat(&fscache_n_store_ops);
+	fscache_stat(&fscache_n_stores_ok);
+
+	/* the slow work queue now carries its own ref on the object */
+	fscache_put_operation(&op->op);
+	_leave(" = 0");
+	return 0;
+
+already_queued:
+	fscache_stat(&fscache_n_stores_again);
+already_pending:
+	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	kfree(op);
+	fscache_stat(&fscache_n_stores_ok);
+	_leave(" = 0");
+	return 0;
+
+submit_failed:
+	radix_tree_delete(&cookie->stores, page->index);
+	page_cache_release(page);
+	ret = -ENOBUFS;
+	goto nobufs;
+
+nobufs_unlock_obj:
+	spin_unlock(&object->lock);
+nobufs:
+	spin_unlock(&cookie->lock);
+	radix_tree_preload_end();
+	kfree(op);
+	fscache_stat(&fscache_n_stores_nobufs);
+	_leave(" = -ENOBUFS");
+	return -ENOBUFS;
+
+nomem_free:
+	kfree(op);
+nomem:
+	fscache_stat(&fscache_n_stores_oom);
+	_leave(" = -ENOMEM");
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(__fscache_write_page);
+
+/*
+ * remove a page from the cache
+ */
+void __fscache_uncache_page(struct fscache_cookie *cookie, struct page *page)
+{
+	struct fscache_object *object;
+
+	_enter(",%p", page);
+
+	ASSERTCMP(cookie->def->type, !=, FSCACHE_COOKIE_TYPE_INDEX);
+	ASSERTCMP(page, !=, NULL);
+
+	fscache_stat(&fscache_n_uncaches);
+
+	/* cache withdrawal may beat us to it */
+	if (!PageFsCache(page))
+		goto done;
+
+	/* get the object */
+	spin_lock(&cookie->lock);
+
+	if (hlist_empty(&cookie->backing_objects)) {
+		ClearPageFsCache(page);
+		goto done_unlock;
+	}
+
+	object = hlist_entry(cookie->backing_objects.first,
+			     struct fscache_object, cookie_link);
+
+	/* there might now be stuff on disk we could read */
+	clear_bit(FSCACHE_COOKIE_NO_DATA_YET, &cookie->flags);
+
+	/* only invoke the cache backend if we managed to mark the page
+	 * uncached here; this deals with synchronisation vs withdrawal */
+	if (TestClearPageFsCache(page) &&
+	    object->cache->ops->uncache_page) {
+		/* the cache backend releases the cookie lock */
+		object->cache->ops->uncache_page(object, page);
+		goto done;
+	}
+
+done_unlock:
+	spin_unlock(&cookie->lock);
+done:
+	_leave("");
+}
+EXPORT_SYMBOL(__fscache_uncache_page);
+
+/**
+ * fscache_mark_pages_cached - Mark pages as being cached
+ * @op: The retrieval op pages are being marked for
+ * @pagevec: The pages to be marked
+ *
+ * Mark a bunch of netfs pages as being cached.  After this is called,
+ * the netfs must call fscache_uncache_page() to remove the mark.
+ */
+void fscache_mark_pages_cached(struct fscache_retrieval *op,
+			       struct pagevec *pagevec)
+{
+	struct fscache_cookie *cookie = op->op.object->cookie;
+	unsigned long loop;
+
+#ifdef CONFIG_FSCACHE_STATS
+	atomic_add(pagevec->nr, &fscache_n_marks);
+#endif
+
+	for (loop = 0; loop < pagevec->nr; loop++) {
+		struct page *page = pagevec->pages[loop];
+
+		_debug("- mark %p{%lx}", page, page->index);
+		if (TestSetPageFsCache(page)) {
+			static bool once_only;
+			if (!once_only) {
+				once_only = true;
+				printk(KERN_WARNING "FS-Cache:"
+				       " Cookie type %s marked page %lx"
+				       " multiple times\n",
+				       cookie->def->name, page->index);
+			}
+		}
+	}
+
+	if (cookie->def->mark_pages_cached)
+		cookie->def->mark_pages_cached(cookie->netfs_data,
+					       op->mapping, pagevec);
+	pagevec_reinit(pagevec);
+}
+EXPORT_SYMBOL(fscache_mark_pages_cached);
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 245b486..6d8ee46 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -184,6 +184,24 @@ extern struct fscache_cookie *__fscache_acquire_cookie(
 	void *);
 extern void __fscache_relinquish_cookie(struct fscache_cookie *, int);
 extern void __fscache_update_cookie(struct fscache_cookie *);
+extern int __fscache_attr_changed(struct fscache_cookie *);
+extern int __fscache_read_or_alloc_page(struct fscache_cookie *,
+					struct page *,
+					fscache_rw_complete_t,
+					void *,
+					gfp_t);
+extern int __fscache_read_or_alloc_pages(struct fscache_cookie *,
+					 struct address_space *,
+					 struct list_head *,
+					 unsigned *,
+					 fscache_rw_complete_t,
+					 void *,
+					 gfp_t);
+extern int __fscache_alloc_page(struct fscache_cookie *, struct page *, gfp_t);
+extern int __fscache_write_page(struct fscache_cookie *, struct page *, gfp_t);
+extern void __fscache_uncache_page(struct fscache_cookie *, struct page *);
+extern bool __fscache_check_page_write(struct fscache_cookie *, struct page *);
+extern void __fscache_wait_on_page_write(struct fscache_cookie *, struct page *);
 
 /**
  * fscache_register_netfs - Register a filesystem as desiring caching services
@@ -361,7 +379,10 @@ void fscache_unpin_cookie(struct fscache_cookie *cookie)
 static inline
 int fscache_attr_changed(struct fscache_cookie *cookie)
 {
-	return -ENOBUFS;
+	if (fscache_cookie_valid(cookie))
+		return __fscache_attr_changed(cookie);
+	else
+		return -ENOBUFS;
 }
 
 /**
@@ -418,7 +439,11 @@ int fscache_read_or_alloc_page(struct fscache_cookie *cookie,
 			       void *context,
 			       gfp_t gfp)
 {
-	return -ENOBUFS;
+	if (fscache_cookie_valid(cookie))
+		return __fscache_read_or_alloc_page(cookie, page, end_io_func,
+						    context, gfp);
+	else
+		return -ENOBUFS;
 }
 
 /**
@@ -464,7 +489,12 @@ int fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
 				void *context,
 				gfp_t gfp)
 {
-	return -ENOBUFS;
+	if (fscache_cookie_valid(cookie))
+		return __fscache_read_or_alloc_pages(cookie, mapping, pages,
+						     nr_pages, end_io_func,
+						     context, gfp);
+	else
+		return -ENOBUFS;
 }
 
 /**
@@ -490,7 +520,10 @@ int fscache_alloc_page(struct fscache_cookie *cookie,
 		       struct page *page,
 		       gfp_t gfp)
 {
-	return -ENOBUFS;
+	if (fscache_cookie_valid(cookie))
+		return __fscache_alloc_page(cookie, page, gfp);
+	else
+		return -ENOBUFS;
 }
 
 /**
@@ -516,7 +549,10 @@ int fscache_write_page(struct fscache_cookie *cookie,
 		       struct page *page,
 		       gfp_t gfp)
 {
-	return -ENOBUFS;
+	if (fscache_cookie_valid(cookie))
+		return __fscache_write_page(cookie, page, gfp);
+	else
+		return -ENOBUFS;
 }
 
 /**
@@ -537,6 +573,8 @@ static inline
 void fscache_uncache_page(struct fscache_cookie *cookie,
 			  struct page *page)
 {
+	if (fscache_cookie_valid(cookie))
+		__fscache_uncache_page(cookie, page);
 }
 
 /**
@@ -553,6 +591,8 @@ static inline
 bool fscache_check_page_write(struct fscache_cookie *cookie,
 			      struct page *page)
 {
+	if (fscache_cookie_valid(cookie))
+		return __fscache_check_page_write(cookie, page);
 	return false;
 }
 
@@ -571,6 +611,8 @@ static inline
 void fscache_wait_on_page_write(struct fscache_cookie *cookie,
 				struct page *page)
 {
+	if (fscache_cookie_valid(cookie))
+		__fscache_wait_on_page_write(cookie, page);
 }
 
 #endif /* _LINUX_FSCACHE_H */

