Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbZDCBLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbZDCBLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZDCBLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:11:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbZDCBLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:11:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030514.42687.nickpiggin@yahoo.com.au>
References: <200904030514.42687.nickpiggin@yahoo.com.au> <200904030431.04079.nickpiggin@yahoo.com.au> <7249.1238692155@redhat.com> <7516.1238694057@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache management [ver #46]
Date: Fri, 03 Apr 2009 02:11:10 +0100
Message-ID: <31146.1238721070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Besides, as I said NFS uses PG_private for its own purposes, and entangling
> > the two wasn't the most fun I've had.  Trond didn't like it either.
> 
> IMO that is quite OK to make them go through the pain of that if it
> avoids resulting in a new page flag that is probably unusable to most
> other filesystems.
> 
> But... I guess I won't get hung up on it. If you avoid at least one of
> these flags it would be a good start.

Okay, the attached patch allows PageFsCacheWrite to be dispensed with.  I have
a radix tree already to track pages that need writing, so I just extend the
use of that.

It does make waiting for a page to be written more tricky, though, as I can't
now just wait on a page flag.  It's also theoretically slower as I now have to
take extra spinlocks.

I've benchmarked it three times:

	Fri Apr  3 01:42:16 BST 2009
	Fri Apr  3 01:44:25 BST 2009	2m 9s

	Fri Apr  3 01:46:45 BST 2009
	Fri Apr  3 01:48:24 BST 2009	1m 39s

	Fri Apr  3 01:50:28 BST 2009
	Fri Apr  3 01:52:40 BST 2009	2m 12s

using the same benchmark as for the patch to use the write() file op.

David
---
commit 9a10592512b01b42eb65f32c1028c57a1a6c864e
Author: David Howells <dhowells@redhat.com>
Date:   Fri Apr 3 02:04:15 2009 +0100

FS-Cache: Use a radix tree to track pages being written rather than a page flag

Use a radix tree attached to struct fscache_cookie to track what pages are
undergoing write, rather than using a page flag.

The radix tree that was resident in struct fscache_object to track pages that
need writing is moved to fscache_cookie.  Pages that need writing and pages
that are being written are both held in there.  The difference being that the
former are tagged with FSCACHE_COOKIE_PENDING_TAG.

Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
index da8f92f..4db125b 100644
--- a/Documentation/filesystems/caching/netfs-api.txt
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -640,7 +640,18 @@ Note that pages can't be explicitly deleted from the a data file.  The whole
 data file must be retired (see the relinquish cookie function below).
 
 Furthermore, note that this does not cancel the asynchronous read or write
-operation started by the read/alloc and write functions.
+operation started by the read/alloc and write functions, so the page
+invalidation and release functions must use:
+
+	bool fscache_check_page_write(struct fscache_cookie *cookie,
+				      struct page *page);
+
+to see if a page is being written to the cache, and:
+
+	void fscache_wait_on_page_write(struct fscache_cookie *cookie,
+					struct page *page);
+
+to wait for it to finish if it is.
 
 
 ==========================
@@ -730,52 +741,32 @@ this, the caller should relinquish and retire the cookie they have, and then
 acquire a new one.
 
 
-============================
-FS-CACHE SPECIFIC PAGE FLAGS
-============================
-
-FS-Cache makes use of two page flags, PG_private_2 and PG_owner_priv_2, for
-its own purpose.  The first is given the alternative name PG_fscache and the
-second PG_fscache_write.
-
-FS-Cache uses these flags to keep track of two bits of information per cached
-netfs page:
+===========================
+FS-CACHE SPECIFIC PAGE FLAG
+===========================
 
- (1) PG_fscache.
+FS-Cache makes use of a page flag, PG_private_2, for its own purpose.  This is
+given the alternative name PG_fscache.
 
-     This indicates that the page is known by the cache, and that the cache
-     must be informed if the page is going to go away.  It's an indication to
-     the netfs that the cache has an interest in this page, where an interest
-     may be a pointer to it, resources allocated or reserved for it, or I/O in
-     progress upon it.
+PG_fscache is used to indicate that the page is known by the cache, and that
+the cache must be informed if the page is going to go away.  It's an indication
+to the netfs that the cache has an interest in this page, where an interest may
+be a pointer to it, resources allocated or reserved for it, or I/O in progress
+upon it.
 
-     The netfs can use this information in methods such as releasepage() to
-     determine whether it needs to uncache a page or update it.
+The netfs can use this information in methods such as releasepage() to
+determine whether it needs to uncache a page or update it.
 
-     Furthermore, if this bit is set, releasepage() and invalidatepage()
-     operations will be called on a page to get rid of it, even if PG_private
-     is not set.  This allows caching to attempted on a page before
-     read_cache_pages() to be called after fscache_read_or_alloc_pages() as
-     the former will try and release pages it was given under certain
-     circumstances.
+Furthermore, if this bit is set, releasepage() and invalidatepage() operations
+will be called on a page to get rid of it, even if PG_private is not set.  This
+allows caching to attempted on a page before read_cache_pages() to be called
+after fscache_read_or_alloc_pages() as the former will try and release pages it
+was given under certain circumstances.
 
- (2) PG_fscache_write.
+This bit does not overlap with such as PG_private.  This means that FS-Cache
+can be used with a filesystem that uses the block buffering code.
 
-     This indicates that the page is being written to disk by the cache, and
-     that it cannot be released until completion.  Ideally it shouldn't be
-     changed until completion either so as to maintain the known state of the
-     cache.  This cannot be unified with PG_writeback as the page may be being
-     written to both the server and the cache at the same time or at different
-     times.
-
-     This can be used by the netfs to wait for a page to be written out to the
-     cache before, say, releasing or invalidating it, or before allowing
-     someone to modify it in page_mkwrite(), say.
-
-Neither of these two bits overlaps with such as PG_private.  This means that
-FS-Cache can be used with a filesystem that uses the block buffering code.
-
-There are a number of operations defined on these two bits:
+There are a number of operations defined on this flag:
 
 	int PageFsCache(struct page *page);
 	void SetPageFsCache(struct page *page)
@@ -783,18 +774,5 @@ There are a number of operations defined on these two bits:
 	int TestSetPageFsCache(struct page *page)
 	int TestClearPageFsCache(struct page *page)
 
-	int PageFsCacheWrite(struct page *page)
-	void SetPageFsCacheWrite(struct page *page)
-	void ClearPageFsCacheWrite(struct page *page)
-	int TestSetPageFsCacheWrite(struct page *page)
-	int TestClearPageFsCacheWrite(struct page *page)
-
 These functions are bit test, bit set, bit clear, bit test and set and bit
-test and clear operations on PG_fscache and PG_fscache_write.
-
-	void wait_on_page_fscache_write(struct page *page)
-	void end_page_fscache_write(struct page *page)
-
-The first of these two functions waits uninterruptibly for PG_fscache_write to
-become clear, if it isn't already so.  The second clears PG_fscache_write and
-wakes up anyone waiting for it.
+test and clear operations on PG_fscache.
diff --git a/fs/afs/file.c b/fs/afs/file.c
index aeb6cdd..7a1d942 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -299,7 +299,7 @@ static void afs_invalidatepage(struct page *page, unsigned long offset)
 #ifdef CONFIG_AFS_FSCACHE
 		if (PageFsCache(page)) {
 			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
-			wait_on_page_fscache_write(page);
+			fscache_wait_on_page_write(vnode->cache, page);
 			fscache_uncache_page(vnode->cache, page);
 			ClearPageFsCache(page);
 		}
@@ -336,12 +336,12 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 	 * elected to wait */
 #ifdef CONFIG_AFS_FSCACHE
 	if (PageFsCache(page)) {
-		if (PageFsCacheWrite(page)) {
+		if (fscache_check_page_write(vnode->cache, page)) {
 			if (!(gfp_flags & __GFP_WAIT)) {
 				_leave(" = F [cache busy]");
 				return 0;
 			}
-			wait_on_page_fscache_write(page);
+			fscache_wait_on_page_write(vnode->cache, page);
 		}
 
 		fscache_uncache_page(vnode->cache, page);
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 7884518..c2e7a7f 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -795,7 +795,7 @@ int afs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	/* wait for the page to be written to the cache before we allow it to
 	 * be modified */
 #ifdef CONFIG_AFS_FSCACHE
-	wait_on_page_fscache_write(page);
+	fscache_wait_on_page_write(vnode->cache, page);
 #endif
 
 	_leave(" = 0");
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index cd9d065..72fd18f 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -102,6 +102,8 @@ struct fscache_cookie *__fscache_acquire_cookie(
 	cookie->netfs_data	= netfs_data;
 	cookie->flags		= 0;
 
+	INIT_RADIX_TREE(&cookie->stores, GFP_NOFS);
+
 	switch (cookie->def->type) {
 	case FSCACHE_COOKIE_TYPE_INDEX:
 		fscache_stat(&fscache_n_cookie_index);
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 512ec2c..2568e0e 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -17,6 +17,47 @@
 #include "internal.h"
 
 /*
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
  * actually apply the changed attributes to a cache object
  */
 static void fscache_attr_changed_op(struct fscache_operation *op)
@@ -480,6 +521,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	struct fscache_storage *op =
 		container_of(_op, struct fscache_storage, op);
 	struct fscache_object *object = op->op.object;
+	struct fscache_cookie *cookie = object->cookie;
 	struct page *page;
 	unsigned n;
 	void *results[1];
@@ -487,10 +529,12 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
 
+	spin_lock(&cookie->lock);
 	spin_lock(&object->lock);
 
 	if (!fscache_object_is_active(object)) {
 		spin_unlock(&object->lock);
+		spin_unlock(&cookie->lock);
 		_leave("");
 		return;
 	}
@@ -499,23 +543,24 @@ static void fscache_write_op(struct fscache_operation *_op)
 
 	/* find a page to store */
 	page = NULL;
-	n = radix_tree_gang_lookup(&object->stores, results, 0, 1);
-	if (n == 1) {
-		page = results[0];
-		_debug("gang %d [%lx]", n, page->index);
-		if (page->index <= op->store_limit)
-			radix_tree_delete(&object->stores, page->index);
-		else
-			goto superseded;
-	} else {
+	n = radix_tree_gang_lookup_tag(&cookie->stores, results, 0, 1,
+				       FSCACHE_COOKIE_PENDING_TAG);
+	if (n != 1)
+		goto superseded;
+	page = results[0];
+	_debug("gang %d [%lx]", n, page->index);
+	if (page->index > op->store_limit)
 		goto superseded;
-	}
+
+	radix_tree_tag_clear(&cookie->stores, page->index,
+			     FSCACHE_COOKIE_PENDING_TAG);
 
 	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
 
 	if (page) {
 		ret = object->cache->ops->write_page(op, page);
-		end_page_fscache_write(page);
+		fscache_end_page_write(cookie, page);
 		page_cache_release(page);
 		if (ret < 0)
 			fscache_abort_object(object);
@@ -532,6 +577,7 @@ superseded:
 	_debug("cease");
 	clear_bit(FSCACHE_OBJECT_PENDING_WRITE, &object->flags);
 	spin_unlock(&object->lock);
+	spin_unlock(&cookie->lock);
 	_leave("");
 }
 
@@ -609,7 +655,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 
 	_debug("store limit %llx", (unsigned long long) object->store_limit);
 
-	ret = radix_tree_insert(&object->stores, page->index, page);
+	ret = radix_tree_insert(&cookie->stores, page->index, page);
 	if (ret < 0) {
 		if (ret == -EEXIST)
 			goto already_queued;
@@ -617,9 +663,9 @@ int __fscache_write_page(struct fscache_cookie *cookie,
 		goto nobufs_unlock_obj;
 	}
 
+	radix_tree_tag_set(&cookie->stores, page->index,
+			   FSCACHE_COOKIE_PENDING_TAG);
 	page_cache_get(page);
-	if (TestSetPageFsCacheWrite(page))
-		BUG();
 
 	/* we only want one writer at a time, but we do need to queue new
 	 * writers after exclusive ops */
@@ -656,8 +702,7 @@ already_pending:
 	return 0;
 
 submit_failed:
-	radix_tree_delete(&object->stores, page->index);
-	end_page_fscache_write(page);
+	radix_tree_delete(&cookie->stores, page->index);
 	page_cache_release(page);
 	ret = -ENOBUFS;
 	goto nobufs;
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index d3060c4..3523b89 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -456,11 +456,12 @@ static int nfs_release_page(struct page *page, gfp_t gfp)
 static int nfs_launder_page(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
+	struct nfs_inode *nfsi = NFS_I(inode);
 
 	dfprintk(PAGECACHE, "NFS: launder_page(%ld, %llu)\n",
 		inode->i_ino, (long long)page_offset(page));
 
-	wait_on_page_fscache_write(page);
+	nfs_fscache_wait_on_page_write(nfsi, page);
 	return nfs_wb_page(inode, page);
 }
 
@@ -498,7 +499,7 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		(long long)page_offset(page));
 
 	/* make sure the cache has finished storing the page */
-	wait_on_page_fscache_write(page);
+	nfs_fscache_wait_on_page_write(NFS_I(dentry->d_inode), page);
 
 	lock_page(page);
 	mapping = page->mapping;
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 968cf5d..379be67 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -337,21 +337,22 @@ void nfs_fscache_reset_inode_cookie(struct inode *inode)
  */
 int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 {
-	if (PageFsCacheWrite(page)) {
+	struct nfs_inode *nfsi = NFS_I(page->mapping->host);
+	struct fscache_cookie *cookie = nfsi->fscache;
+
+	BUG_ON(!cookie);
+
+	if (fscache_check_page_write(cookie, page)) {
 		if (!(gfp & __GFP_WAIT))
 			return 0;
-		wait_on_page_fscache_write(page);
+		fscache_wait_on_page_write(cookie, page);
 	}
 
 	if (PageFsCache(page)) {
-		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
-
-		BUG_ON(!nfsi->fscache);
-
 		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
-			 nfsi->fscache, page, nfsi);
+			 cookie, page, nfsi);
 
-		fscache_uncache_page(nfsi->fscache, page);
+		fscache_uncache_page(cookie, page);
 		nfs_add_fscache_stats(page->mapping->host,
 				      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
 	}
@@ -366,16 +367,17 @@ int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 void __nfs_fscache_invalidate_page(struct page *page, struct inode *inode)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
+	struct fscache_cookie *cookie = nfsi->fscache;
 
-	BUG_ON(!nfsi->fscache);
+	BUG_ON(!cookie);
 
 	dfprintk(FSCACHE, "NFS: fscache invalidatepage (0x%p/0x%p/0x%p)\n",
-		 nfsi->fscache, page, nfsi);
+		 cookie, page, nfsi);
 
-	wait_on_page_fscache_write(page);
+	fscache_wait_on_page_write(cookie, page);
 
 	BUG_ON(!PageLocked(page));
-	fscache_uncache_page(nfsi->fscache, page);
+	fscache_uncache_page(cookie, page);
 	nfs_add_fscache_stats(page->mapping->host,
 			      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
 }
diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 2d43b67..6e809bb 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -94,6 +94,16 @@ extern int __nfs_readpages_from_fscache(struct nfs_open_context *,
 extern void __nfs_readpage_to_fscache(struct inode *, struct page *, int);
 
 /*
+ * wait for a page to complete writing to the cache
+ */
+static inline void nfs_fscache_wait_on_page_write(struct nfs_inode *nfsi,
+						  struct page *page)
+{
+	if (PageFsCache(page))
+		fscache_wait_on_page_write(nfsi->fscache, page);
+}
+
+/*
  * release the caching state associated with a page if undergoing complete page
  * invalidation
  */
@@ -181,6 +191,8 @@ static inline int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 }
 static inline void nfs_fscache_invalidate_page(struct page *page,
 					       struct inode *inode) {}
+static inline void nfs_fscache_wait_on_page_write(struct nfs_inode *nfsi,
+						  struct page *page) {}
 
 static inline int nfs_readpage_from_fscache(struct nfs_open_context *ctx,
 					    struct inode *inode,
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 0410bd9..84d3532 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -301,6 +301,9 @@ struct fscache_cookie {
 	const struct fscache_cookie_def	*def;		/* definition */
 	struct fscache_cookie		*parent;	/* parent of this entry */
 	void				*netfs_data;	/* back pointer to netfs */
+	struct radix_tree_root		stores;		/* pages to be stored on this cookie */
+#define FSCACHE_COOKIE_PENDING_TAG	0		/* pages tag: pending write to cache */
+
 	unsigned long			flags;
 #define FSCACHE_COOKIE_LOOKING_UP	0	/* T if non-index cookie being looked up still */
 #define FSCACHE_COOKIE_CREATING		1	/* T if non-index object being created still */
@@ -370,7 +373,6 @@ struct fscache_object {
 	struct list_head	dependents;	/* FIFO of dependent objects */
 	struct list_head	dep_link;	/* link in parent's dependents list */
 	struct list_head	pending_ops;	/* unstarted operations on this object */
-	struct radix_tree_root	stores;		/* data to be stored */
 	pgoff_t			store_limit;	/* current storage limit */
 };
 
@@ -407,7 +409,6 @@ void fscache_object_init(struct fscache_object *object,
 	INIT_LIST_HEAD(&object->dependents);
 	INIT_LIST_HEAD(&object->dep_link);
 	INIT_LIST_HEAD(&object->pending_ops);
-	INIT_RADIX_TREE(&object->stores, GFP_NOFS);
 	object->n_children = 0;
 	object->n_ops = object->n_in_progress = object->n_exclusive = 0;
 	object->events = object->event_mask = 0;
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 006c919..6d8ee46 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -42,20 +42,6 @@
 #define TestSetPageFsCache(page)	TestSetPagePrivate2((page))
 #define TestClearPageFsCache(page)	TestClearPagePrivate2((page))
 
-/*
- * overload PG_owner_priv_2 to give us PG_fscache_write - this is used to
- * indicate that a page is currently being written to a local disk cache
- */
-#define PageFsCacheWrite(page)		PageOwnerPriv2((page))
-#define SetPageFsCacheWrite(page)	SetPageOwnerPriv2((page))
-#define ClearPageFsCacheWrite(page)	ClearPageOwnerPriv2((page))
-#define TestSetPageFsCacheWrite(page)	TestSetPageOwnerPriv2((page))
-#define TestClearPageFsCacheWrite(page)	TestClearPageOwnerPriv2((page))
-
-#define wait_on_page_fscache_write(page) wait_on_page_owner_priv_2((page))
-#define end_page_fscache_write(page)	end_page_owner_priv_2((page))
-
-
 /* pattern used to fill dead space in an index entry */
 #define FSCACHE_INDEX_DEADFILL_PATTERN 0x79
 
@@ -214,6 +200,8 @@ extern int __fscache_read_or_alloc_pages(struct fscache_cookie *,
 extern int __fscache_alloc_page(struct fscache_cookie *, struct page *, gfp_t);
 extern int __fscache_write_page(struct fscache_cookie *, struct page *, gfp_t);
 extern void __fscache_uncache_page(struct fscache_cookie *, struct page *);
+extern bool __fscache_check_page_write(struct fscache_cookie *, struct page *);
+extern void __fscache_wait_on_page_write(struct fscache_cookie *, struct page *);
 
 /**
  * fscache_register_netfs - Register a filesystem as desiring caching services
@@ -589,4 +577,42 @@ void fscache_uncache_page(struct fscache_cookie *cookie,
 		__fscache_uncache_page(cookie, page);
 }
 
+/**
+ * fscache_check_page_write - Ask if a page is being writing to the cache
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that is being cached.
+ *
+ * Ask the cache if a page is being written to the cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+bool fscache_check_page_write(struct fscache_cookie *cookie,
+			      struct page *page)
+{
+	if (fscache_cookie_valid(cookie))
+		return __fscache_check_page_write(cookie, page);
+	return false;
+}
+
+/**
+ * fscache_wait_on_page_write - Wait for a page to complete writing to the cache
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that is being cached.
+ *
+ * Ask the cache to wake us up when a page is no longer being written to the
+ * cache.
+ *
+ * See Documentation/filesystems/caching/netfs-api.txt for a complete
+ * description.
+ */
+static inline
+void fscache_wait_on_page_write(struct fscache_cookie *cookie,
+				struct page *page)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_wait_on_page_write(cookie, page);
+}
+
 #endif /* _LINUX_FSCACHE_H */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0633e06..62214c7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -79,7 +79,6 @@ enum pageflags {
 	PG_active,
 	PG_slab,
 	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
-	PG_owner_priv_2,	/* Owner use. fs may use in pagecache */
 	PG_arch_1,
 	PG_reserved,
 	PG_private,		/* If pagecache, has fs-private data */
@@ -115,7 +114,6 @@ enum pageflags {
 	 * when those inodes are being locally cached.
 	 */
 	PG_fscache = PG_private_2,	/* page backed by cache */
-	PG_fscache_write = PG_owner_priv_2, /* page being written to cache */
 
 	/* XEN */
 	PG_pinned = PG_owner_priv_1,
@@ -220,7 +218,6 @@ PAGEFLAG(Private, private) __SETPAGEFLAG(Private, private)
 	__CLEARPAGEFLAG(Private, private)
 PAGEFLAG(Private2, private_2) TESTSCFLAG(Private2, private_2)
 PAGEFLAG(OwnerPriv1, owner_priv_1) TESTCLEARFLAG(OwnerPriv1, owner_priv_1)
-PAGEFLAG(OwnerPriv2, owner_priv_2) TESTSCFLAG(OwnerPriv2, owner_priv_2)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 135028e..fc8a67f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -379,22 +379,6 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 
-/**
- * wait_on_page_owner_priv_2 - Wait for PG_owner_priv_2 to become clear
- * @page: The page to monitor
- *
- * Wait for a PG_owner_priv_2 to become clear on the specified page.  This is
- * also used to monitor PG_fscache_write (which is an alternate name for the
- * same bit).
- */
-static inline void wait_on_page_owner_priv_2(struct page *page)
-{
-	if (PageOwnerPriv2(page))
-		wait_on_page_bit(page, PG_owner_priv_2);
-}
-
-extern void end_page_owner_priv_2(struct page *page);
-
 /*
  * Add an arbitrary waiter to a page's wait queue
  */
diff --git a/mm/filemap.c b/mm/filemap.c
index 15dda3c..9eb70e5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -621,23 +621,6 @@ void end_page_writeback(struct page *page)
 EXPORT_SYMBOL(end_page_writeback);
 
 /**
- * end_page_owner_priv_2 - Clear PG_owner_priv_2 and wake up any waiters
- * @page: the page
- *
- * Clear PG_owner_priv_2 and wake up any processes waiting for that event.
- * This is used to indicate - using PG_fscache_write (an alternate name for the
- * same bit) - that a page has finished being written to the local disk cache.
- */
-void end_page_owner_priv_2(struct page *page)
-{
-	if (!TestClearPageOwnerPriv2(page))
-		BUG();
-	smp_mb__after_clear_bit();
-	wake_up_page(page, PG_owner_priv_2);
-}
-EXPORT_SYMBOL(end_page_owner_priv_2);
-
-/**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
  *
