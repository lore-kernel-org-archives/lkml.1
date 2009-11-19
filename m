Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZKSRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZKSRWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSRWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbZKSRWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/28] FS-Cache: Handle pages pending storage that get evicted
	under OOM conditions
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:06 +0000
Message-ID: <20091119172206.1679.75010.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle netfs pages that the vmscan algorithm wants to evict from the pagecache
under OOM conditions, but that are waiting for write to the cache.  Under these
conditions, vmscan calls the releasepage() function of the netfs, asking if a
page can be discarded.

The problem is typified by the following trace of a stuck process:

	kslowd005     D 0000000000000000     0  4253      2 0x00000080
	 ffff88001b14f370 0000000000000046 ffff880020d0d000 0000000000000007
	 0000000000000006 0000000000000001 ffff88001b14ffd8 ffff880020d0d2a8
	 000000000000ddf0 00000000000118c0 00000000000118c0 ffff880020d0d2a8
	Call Trace:
	 [<ffffffffa00782d8>] __fscache_wait_on_page_write+0x8b/0xa7 [fscache]
	 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
	 [<ffffffffa0078240>] ? __fscache_check_page_write+0x63/0x70 [fscache]
	 [<ffffffffa00b671d>] nfs_fscache_release_page+0x4e/0xc4 [nfs]
	 [<ffffffffa00927f0>] nfs_release_page+0x3c/0x41 [nfs]
	 [<ffffffff810885d3>] try_to_release_page+0x32/0x3b
	 [<ffffffff81093203>] shrink_page_list+0x316/0x4ac
	 [<ffffffff8109372b>] shrink_inactive_list+0x392/0x67c
	 [<ffffffff813532fa>] ? __mutex_unlock_slowpath+0x100/0x10b
	 [<ffffffff81058df0>] ? trace_hardirqs_on_caller+0x10c/0x130
	 [<ffffffff8135330e>] ? mutex_unlock+0x9/0xb
	 [<ffffffff81093aa2>] shrink_list+0x8d/0x8f
	 [<ffffffff81093d1c>] shrink_zone+0x278/0x33c
	 [<ffffffff81052d6c>] ? ktime_get_ts+0xad/0xba
	 [<ffffffff81094b13>] try_to_free_pages+0x22e/0x392
	 [<ffffffff81091e24>] ? isolate_pages_global+0x0/0x212
	 [<ffffffff8108e743>] __alloc_pages_nodemask+0x3dc/0x5cf
	 [<ffffffff81089529>] grab_cache_page_write_begin+0x65/0xaa
	 [<ffffffff8110f8c0>] ext3_write_begin+0x78/0x1eb
	 [<ffffffff81089ec5>] generic_file_buffered_write+0x109/0x28c
	 [<ffffffff8103cb69>] ? current_fs_time+0x22/0x29
	 [<ffffffff8108a509>] __generic_file_aio_write+0x350/0x385
	 [<ffffffff8108a588>] ? generic_file_aio_write+0x4a/0xae
	 [<ffffffff8108a59e>] generic_file_aio_write+0x60/0xae
	 [<ffffffff810b2e82>] do_sync_write+0xe3/0x120
	 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
	 [<ffffffff810b18e1>] ? __dentry_open+0x1a5/0x2b8
	 [<ffffffff810b1a76>] ? dentry_open+0x82/0x89
	 [<ffffffffa00e693c>] cachefiles_write_page+0x298/0x335 [cachefiles]
	 [<ffffffffa0077147>] fscache_write_op+0x178/0x2c2 [fscache]
	 [<ffffffffa0075656>] fscache_op_execute+0x7a/0xd1 [fscache]
	 [<ffffffff81082093>] slow_work_execute+0x18f/0x2d1
	 [<ffffffff8108239a>] slow_work_thread+0x1c5/0x308
	 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
	 [<ffffffff810821d5>] ? slow_work_thread+0x0/0x308
	 [<ffffffff8104be91>] kthread+0x7a/0x82
	 [<ffffffff8100beda>] child_rip+0xa/0x20
	 [<ffffffff8100b87c>] ? restore_args+0x0/0x30
	 [<ffffffff8102ef83>] ? tg_shares_up+0x171/0x227
	 [<ffffffff8104be17>] ? kthread+0x0/0x82
	 [<ffffffff8100bed0>] ? child_rip+0x0/0x20

In the above backtrace, the following is happening:

 (1) A page storage operation is being executed by a slow-work thread
     (fscache_write_op()).

 (2) FS-Cache farms the operation out to the cache to perform
     (cachefiles_write_page()).

 (3) CacheFiles is then calling Ext3 to perform the actual write, using Ext3's
     standard write (do_sync_write()) under KERNEL_DS directly from the netfs
     page.

 (4) However, for Ext3 to perform the write, it must allocate some memory, in
     particular, it must allocate at least one page cache page into which it
     can copy the data from the netfs page.

 (5) Under OOM conditions, the memory allocator can't immediately come up with
     a page, so it uses vmscan to find something to discard
     (try_to_free_pages()).

 (6) vmscan finds a clean netfs page it might be able to discard (possibly the
     one it's trying to write out).

 (7) The netfs is called to throw the page away (nfs_release_page()) - but it's
     called with __GFP_WAIT, so the netfs decides to wait for the store to
     complete (__fscache_wait_on_page_write()).

 (8) This blocks a slow-work processing thread - possibly against itself.

The system ends up stuck because it can't write out any netfs pages to the
cache without allocating more memory.

To avoid this, we make FS-Cache cancel some writes that aren't in the middle of
actually being performed.  This means that some data won't make it into the
cache this time.  To support this, a new FS-Cache function is added
fscache_maybe_release_page() that replaces what the netfs releasepage()
functions used to do with respect to the cache.

The decisions fscache_maybe_release_page() makes are counted and displayed
through /proc/fs/fscache/stats on a line labelled "VmScan".  There are four
counters provided: "nos=N" - pages that weren't pending storage; "gon=N" -
pages that were pending storage when we first looked, but weren't by the time
we got the object lock; "bsy=N" - pages that we ignored as they were actively
being written when we looked; and "can=N" - pages that we cancelled the storage
of.


What I'd really like to do is alter the behaviour of the cancellation
heuristics, depending on how necessary it is to expel pages.  If there are
plenty of other pages that aren't waiting to be written to the cache that
could be ejected first, then it would be nice to hold up on immediate
cancellation of cache writes - but I don't see a way of doing that.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/caching/fscache.txt   |    4 +
 Documentation/filesystems/caching/netfs-api.txt |   21 ++++++
 fs/9p/cache.c                                   |   14 ----
 fs/afs/file.c                                   |   15 +---
 fs/fscache/internal.h                           |    5 +
 fs/fscache/page.c                               |   79 ++++++++++++++++++++++-
 fs/fscache/stats.c                              |   11 +++
 fs/nfs/fscache.c                                |   10 +--
 include/linux/fscache-cache.h                   |    1 
 include/linux/fscache.h                         |   27 ++++++++
 10 files changed, 152 insertions(+), 35 deletions(-)

diff --git a/Documentation/filesystems/caching/fscache.txt b/Documentation/filesystems/caching/fscache.txt
index 8889d6a..655569e 100644
--- a/Documentation/filesystems/caching/fscache.txt
+++ b/Documentation/filesystems/caching/fscache.txt
@@ -272,6 +272,10 @@ proc files.
 		pgs=N	Number of pages given store req processing time
 		rxd=N	Number of store reqs deleted from tracking tree
 		olm=N	Number of store reqs over store limit
+	VmScan	nos=N	Number of release reqs against pages with no pending store
+		gon=N	Number of release reqs against pages stored by time lock granted
+		bsy=N	Number of release reqs ignored due to in-progress store
+		can=N	Number of page stores cancelled due to release req
 	Ops	pend=N	Number of times async ops added to pending queues
 		run=N	Number of times async ops given CPU time
 		enq=N	Number of times async ops queued for processing
diff --git a/Documentation/filesystems/caching/netfs-api.txt b/Documentation/filesystems/caching/netfs-api.txt
index 2666b1e..1902c57 100644
--- a/Documentation/filesystems/caching/netfs-api.txt
+++ b/Documentation/filesystems/caching/netfs-api.txt
@@ -641,7 +641,7 @@ data file must be retired (see the relinquish cookie function below).
 
 Furthermore, note that this does not cancel the asynchronous read or write
 operation started by the read/alloc and write functions, so the page
-invalidation and release functions must use:
+invalidation functions must use:
 
 	bool fscache_check_page_write(struct fscache_cookie *cookie,
 				      struct page *page);
@@ -654,6 +654,25 @@ to see if a page is being written to the cache, and:
 to wait for it to finish if it is.
 
 
+When releasepage() is being implemented, a special FS-Cache function exists to
+manage the heuristics of coping with vmscan trying to eject pages, which may
+conflict with the cache trying to write pages to the cache (which may itself
+need to allocate memory):
+
+	bool fscache_maybe_release_page(struct fscache_cookie *cookie,
+					struct page *page,
+					gfp_t gfp);
+
+This takes the netfs cookie, and the page and gfp arguments as supplied to
+releasepage().  It will return false if the page cannot be released yet for
+some reason and if it returns true, the page has been uncached and can now be
+released.
+
+To make a page available for release, this function may wait for an outstanding
+storage request to complete, or it may attempt to cancel the storage request -
+in which case the page will not be stored in the cache this time.
+
+
 ==========================
 INDEX AND DATA FILE UPDATE
 ==========================
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 51c94e2..bcc5357 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -343,18 +343,7 @@ int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
 
 	BUG_ON(!vcookie->fscache);
 
-	if (PageFsCache(page)) {
-		if (fscache_check_page_write(vcookie->fscache, page)) {
-			if (!(gfp & __GFP_WAIT))
-				return 0;
-			fscache_wait_on_page_write(vcookie->fscache, page);
-		}
-
-		fscache_uncache_page(vcookie->fscache, page);
-		ClearPageFsCache(page);
-	}
-
-	return 1;
+	return fscache_maybe_release_page(vnode->cache, page, gfp);
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
@@ -368,7 +357,6 @@ void __v9fs_fscache_invalidate_page(struct page *page)
 		fscache_wait_on_page_write(vcookie->fscache, page);
 		BUG_ON(!PageLocked(page));
 		fscache_uncache_page(vcookie->fscache, page);
-		ClearPageFsCache(page);
 	}
 }
 
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 681c2a7..39b3016 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -315,7 +315,6 @@ static void afs_invalidatepage(struct page *page, unsigned long offset)
 			struct afs_vnode *vnode = AFS_FS_I(page->mapping->host);
 			fscache_wait_on_page_write(vnode->cache, page);
 			fscache_uncache_page(vnode->cache, page);
-			ClearPageFsCache(page);
 		}
 #endif
 
@@ -349,17 +348,9 @@ static int afs_releasepage(struct page *page, gfp_t gfp_flags)
 	/* deny if page is being written to the cache and the caller hasn't
 	 * elected to wait */
 #ifdef CONFIG_AFS_FSCACHE
-	if (PageFsCache(page)) {
-		if (fscache_check_page_write(vnode->cache, page)) {
-			if (!(gfp_flags & __GFP_WAIT)) {
-				_leave(" = F [cache busy]");
-				return 0;
-			}
-			fscache_wait_on_page_write(vnode->cache, page);
-		}
-
-		fscache_uncache_page(vnode->cache, page);
-		ClearPageFsCache(page);
+	if (!fscache_maybe_release_page(vnode->cache, page, gfp_flags)) {
+		_leave(" = F [cache busy]");
+		return 0;
 	}
 #endif
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index a076987..e504651 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -180,6 +180,11 @@ extern atomic_t fscache_n_store_pages;
 extern atomic_t fscache_n_store_radix_deletes;
 extern atomic_t fscache_n_store_pages_over_limit;
 
+extern atomic_t fscache_n_store_vmscan_not_storing;
+extern atomic_t fscache_n_store_vmscan_gone;
+extern atomic_t fscache_n_store_vmscan_busy;
+extern atomic_t fscache_n_store_vmscan_cancelled;
+
 extern atomic_t fscache_n_marks;
 extern atomic_t fscache_n_uncaches;
 
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 022a5da..fc76798 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -43,6 +43,75 @@ void __fscache_wait_on_page_write(struct fscache_cookie *cookie, struct page *pa
 EXPORT_SYMBOL(__fscache_wait_on_page_write);
 
 /*
+ * decide whether a page can be released, possibly by cancelling a store to it
+ * - we're allowed to sleep if __GFP_WAIT is flagged
+ */
+bool __fscache_maybe_release_page(struct fscache_cookie *cookie,
+				  struct page *page,
+				  gfp_t gfp)
+{
+	struct page *xpage;
+	void *val;
+
+	_enter("%p,%p,%x", cookie, page, gfp);
+
+	rcu_read_lock();
+	val = radix_tree_lookup(&cookie->stores, page->index);
+	if (!val) {
+		rcu_read_unlock();
+		fscache_stat(&fscache_n_store_vmscan_not_storing);
+		__fscache_uncache_page(cookie, page);
+		return true;
+	}
+
+	/* see if the page is actually undergoing storage - if so we can't get
+	 * rid of it till the cache has finished with it */
+	if (radix_tree_tag_get(&cookie->stores, page->index,
+			       FSCACHE_COOKIE_STORING_TAG)) {
+		rcu_read_unlock();
+		goto page_busy;
+	}
+
+	/* the page is pending storage, so we attempt to cancel the store and
+	 * discard the store request so that the page can be reclaimed */
+	spin_lock(&cookie->stores_lock);
+	rcu_read_unlock();
+
+	if (radix_tree_tag_get(&cookie->stores, page->index,
+			       FSCACHE_COOKIE_STORING_TAG)) {
+		/* the page started to undergo storage whilst we were looking,
+		 * so now we can only wait or return */
+		spin_unlock(&cookie->stores_lock);
+		goto page_busy;
+	}
+
+	xpage = radix_tree_delete(&cookie->stores, page->index);
+	spin_unlock(&cookie->stores_lock);
+
+	if (xpage) {
+		fscache_stat(&fscache_n_store_vmscan_cancelled);
+		fscache_stat(&fscache_n_store_radix_deletes);
+		ASSERTCMP(xpage, ==, page);
+	} else {
+		fscache_stat(&fscache_n_store_vmscan_gone);
+	}
+
+	wake_up_bit(&cookie->flags, 0);
+	if (xpage)
+		page_cache_release(xpage);
+	__fscache_uncache_page(cookie, page);
+	return true;
+
+page_busy:
+	/* we might want to wait here, but that could deadlock the allocator as
+	 * the slow-work threads writing to the cache may all end up sleeping
+	 * on memory allocation */
+	fscache_stat(&fscache_n_store_vmscan_busy);
+	return false;
+}
+EXPORT_SYMBOL(__fscache_maybe_release_page);
+
+/*
  * note that a page has finished being written to the cache
  */
 static void fscache_end_page_write(struct fscache_object *object,
@@ -57,6 +126,8 @@ static void fscache_end_page_write(struct fscache_object *object,
 		/* delete the page from the tree if it is now no longer
 		 * pending */
 		spin_lock(&cookie->stores_lock);
+		radix_tree_tag_clear(&cookie->stores, page->index,
+				     FSCACHE_COOKIE_STORING_TAG);
 		if (!radix_tree_tag_get(&cookie->stores, page->index,
 					FSCACHE_COOKIE_PENDING_TAG)) {
 			fscache_stat(&fscache_n_store_radix_deletes);
@@ -640,8 +711,12 @@ static void fscache_write_op(struct fscache_operation *_op)
 		goto superseded;
 	}
 
-	radix_tree_tag_clear(&cookie->stores, page->index,
-			     FSCACHE_COOKIE_PENDING_TAG);
+	if (page) {
+		radix_tree_tag_set(&cookie->stores, page->index,
+				   FSCACHE_COOKIE_STORING_TAG);
+		radix_tree_tag_clear(&cookie->stores, page->index,
+				     FSCACHE_COOKIE_PENDING_TAG);
+	}
 
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index 045ba39..cda6999 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -63,6 +63,11 @@ atomic_t fscache_n_store_pages;
 atomic_t fscache_n_store_radix_deletes;
 atomic_t fscache_n_store_pages_over_limit;
 
+atomic_t fscache_n_store_vmscan_not_storing;
+atomic_t fscache_n_store_vmscan_gone;
+atomic_t fscache_n_store_vmscan_busy;
+atomic_t fscache_n_store_vmscan_cancelled;
+
 atomic_t fscache_n_marks;
 atomic_t fscache_n_uncaches;
 
@@ -211,6 +216,12 @@ static int fscache_stats_show(struct seq_file *m, void *v)
 		   atomic_read(&fscache_n_store_radix_deletes),
 		   atomic_read(&fscache_n_store_pages_over_limit));
 
+	seq_printf(m, "VmScan : nos=%u gon=%u bsy=%u can=%u\n",
+		   atomic_read(&fscache_n_store_vmscan_not_storing),
+		   atomic_read(&fscache_n_store_vmscan_gone),
+		   atomic_read(&fscache_n_store_vmscan_busy),
+		   atomic_read(&fscache_n_store_vmscan_cancelled));
+
 	seq_printf(m, "Ops    : pend=%u run=%u enq=%u can=%u rej=%u\n",
 		   atomic_read(&fscache_n_op_pend),
 		   atomic_read(&fscache_n_op_run),
diff --git a/fs/nfs/fscache.c b/fs/nfs/fscache.c
index 70fad69..fa58800 100644
--- a/fs/nfs/fscache.c
+++ b/fs/nfs/fscache.c
@@ -359,17 +359,13 @@ int nfs_fscache_release_page(struct page *page, gfp_t gfp)
 
 	BUG_ON(!cookie);
 
-	if (fscache_check_page_write(cookie, page)) {
-		if (!(gfp & __GFP_WAIT))
-			return 0;
-		fscache_wait_on_page_write(cookie, page);
-	}
-
 	if (PageFsCache(page)) {
 		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
 			 cookie, page, nfsi);
 
-		fscache_uncache_page(cookie, page);
+		if (!fscache_maybe_release_page(cookie, page, gfp))
+			return 0;
+
 		nfs_add_fscache_stats(page->mapping->host,
 				      NFSIOS_FSCACHE_PAGES_UNCACHED, 1);
 	}
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index f3aa4bd..4750d5f 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -317,6 +317,7 @@ struct fscache_cookie {
 	void				*netfs_data;	/* back pointer to netfs */
 	struct radix_tree_root		stores;		/* pages to be stored on this cookie */
 #define FSCACHE_COOKIE_PENDING_TAG	0		/* pages tag: pending write to cache */
+#define FSCACHE_COOKIE_STORING_TAG	1		/* pages tag: writing to cache */
 
 	unsigned long			flags;
 #define FSCACHE_COOKIE_LOOKING_UP	0	/* T if non-index cookie being looked up still */
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index 6d8ee46..595ce49 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -202,6 +202,8 @@ extern int __fscache_write_page(struct fscache_cookie *, struct page *, gfp_t);
 extern void __fscache_uncache_page(struct fscache_cookie *, struct page *);
 extern bool __fscache_check_page_write(struct fscache_cookie *, struct page *);
 extern void __fscache_wait_on_page_write(struct fscache_cookie *, struct page *);
+extern bool __fscache_maybe_release_page(struct fscache_cookie *, struct page *,
+					 gfp_t);
 
 /**
  * fscache_register_netfs - Register a filesystem as desiring caching services
@@ -615,4 +617,29 @@ void fscache_wait_on_page_write(struct fscache_cookie *cookie,
 		__fscache_wait_on_page_write(cookie, page);
 }
 
+/**
+ * fscache_maybe_release_page - Consider releasing a page, cancelling a store
+ * @cookie: The cookie representing the cache object
+ * @page: The netfs page that is being cached.
+ * @gfp: The gfp flags passed to releasepage()
+ *
+ * Consider releasing a page for the vmscan algorithm, on behalf of the netfs's
+ * releasepage() call.  A storage request on the page may cancelled if it is
+ * not currently being processed.
+ *
+ * The function returns true if the page no longer has a storage request on it,
+ * and false if a storage request is left in place.  If true is returned, the
+ * page will have been passed to fscache_uncache_page().  If false is returned
+ * the page cannot be freed yet.
+ */
+static inline
+bool fscache_maybe_release_page(struct fscache_cookie *cookie,
+				struct page *page,
+				gfp_t gfp)
+{
+	if (fscache_cookie_valid(cookie) && PageFsCache(page))
+		return __fscache_maybe_release_page(cookie, page, gfp);
+	return false;
+}
+
 #endif /* _LINUX_FSCACHE_H */

