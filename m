Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYJCDrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYJCDrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 23:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbYJCDrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 23:47:32 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:39667 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754177AbYJCDrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 23:47:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=nsoorn36l6QzWlzaN+yl3t5q3YTGPkI/DzZPpJ1R4IENaJUw1lvovLKQAT7m/LojLfnEnPl+meveAp23DJ1c22OmYz0ALrIiggfnVeI34YewfbBapNSnIMvKAAafQ9HybzMfCOaOicJ9k3tJNv37n0pGGOceKvdWNcd6fYT85vo=  ;
X-YMail-OSG: pIxyBKcVM1l6mOUUpWPFuc9Cri1eL5Y4Xhf1fMFP8L4uzYZGhWz_hLCNhrd.XtXS08cR0eW7W9IiGgmvcuQTpraLl.3d7U.DBBNcdqbDq07BMmaHIPvjZ4CIW7i4yOK9uo8UR5tSkUqzqy2GQEJePYw1LcdSZ3W4hsRJ.WCoLDv7f7d2ffI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 13:47:21 +1000
User-Agent: KMail/1.9.5
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <200810031259.17527.nickpiggin@yahoo.com.au> <20081002201410.07afff73.akpm@linux-foundation.org>
In-Reply-To: <20081002201410.07afff73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JXZ5InMqCvH+Rq2"
Message-Id: <200810031347.21586.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JXZ5InMqCvH+Rq2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 03 October 2008 13:14, Andrew Morton wrote:
> On Fri, 3 Oct 2008 12:59:17 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Friday 03 October 2008 12:40, Andrew Morton wrote:

> > > That can cause fsync to wait arbitrarily long if some other process is
> > > writing the file.
> >
> > It can be fixed without touching non-fsync paths (see my next email for
> > the way to fix it without touching fastpaths).
>
> yup.
>
> > > This happens.
> >
> > What does such a thing?
>
> I forget.  People do all sorts of weird stuff.

Damn people...

I guess they also do non-weird stuff like expecting fsync to really fsync.


> > It would have been nicer to ask them to not do
> > that then, or get them to use range syncs or something. Now that's much
> > harder because we've accepted the crappy workaround for so long.
> >
> > It's far far worse to just ignore data integrity of fsync because of the
> > problem. Should at least have returned an error from fsync in that case,
> > or make it interruptible or something.
>
> If a file has one dirty page at offset 1000000000000000 then someone
> does an fsync() and someone else gets in first and starts madly writing
> pages at offset 0, we want to write that page at 1000000000000000.
> Somehow.
>
> I expect there's no solution which avoids blocking the writers at some
> stage.

See my other email. Something roughly like this would do the trick
(hey, it actually boots and runs and does fix the problem too).

It's ugly because we don't have quite the right radix tree operations 
yet (eg. lookup multiple tags, set tag X if tag Y was set, proper range
lookups). But the theory is to up-front tag the pages that we need to
get to disk.

Completely no impact or slowdown to any writers (although it does add
8 bytes of tags to the radix tree node... but doesn't increase memory
footprint as such due to slab).

--Boundary-00=_JXZ5InMqCvH+Rq2
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="mm-fsync-snapshot-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mm-fsync-snapshot-fix.patch"

Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -578,10 +578,12 @@ struct block_device {
 
 /*
  * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
- * radix trees
+ * radix trees. Also, to snapshot all pages required to be fsync'ed in order
+ * to obey data integrity semantics.
  */
 #define PAGECACHE_TAG_DIRTY	0
 #define PAGECACHE_TAG_WRITEBACK	1
+#define PAGECACHE_TAG_FSYNC	2
 
 int mapping_tagged(struct address_space *mapping, int tag);
 
Index: linux-2.6/include/linux/radix-tree.h
===================================================================
--- linux-2.6.orig/include/linux/radix-tree.h
+++ linux-2.6/include/linux/radix-tree.h
@@ -55,7 +55,7 @@ static inline int radix_tree_is_indirect
 
 /*** radix-tree API starts here ***/
 
-#define RADIX_TREE_MAX_TAGS 2
+#define RADIX_TREE_MAX_TAGS 3
 
 /* root tags are stored in gfp_mask, shifted by __GFP_BITS_SHIFT */
 struct radix_tree_root {
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -848,22 +848,7 @@ void __init page_writeback_init(void)
 	prop_descriptor_init(&vm_dirties, shift);
 }
 
-/**
- * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- * @writepage: function called for each page
- * @data: data passed to writepage function
- *
- * If a page is already under I/O, write_cache_pages() skips it, even
- * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
- * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
- * and msync() need to guarantee that all the data which was dirty at the time
- * the call was made get new I/O started against them.  If wbc->sync_mode is
- * WB_SYNC_ALL then we were called for data integrity and we must wait for
- * existing IO to complete.
- */
-int write_cache_pages(struct address_space *mapping,
+static int __write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data)
 {
@@ -947,10 +932,7 @@ done_release:
 					goto continue_unlock;
 				} else {
 					/* hmm, but it has been dirtied again */
-					if (wbc->sync_mode != WB_SYNC_NONE)
-						wait_on_page_writeback(page);
-					else
-						goto continue_unlock;
+					goto continue_unlock;
 				}
 			}
 
@@ -970,11 +952,9 @@ done_release:
 				}
 				goto done;
 			}
-			if (wbc->sync_mode == WB_SYNC_NONE) {
-				wbc->nr_to_write--;
-				if (wbc->nr_to_write <= 0)
-					goto done_release;
-			}
+			wbc->nr_to_write--;
+			if (wbc->nr_to_write <= 0)
+				goto done_release;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {
 				wbc->encountered_congestion = 1;
 				goto done_release;
@@ -1002,6 +982,183 @@ done:
 
 	return ret;
 }
+
+static int __write_cache_pages_sync(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
+{
+	int ret = 0;
+	struct pagevec pvec;
+	int nr_pages;
+	pgoff_t index;
+	pgoff_t end;		/* Inclusive */
+
+	pagevec_init(&pvec, 0);
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+	do {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1);
+		if (!nr_pages)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			lock_page(page);
+			if (unlikely(page->mapping != mapping)) {
+				unlock_page(page);
+				continue;
+			}
+			if (page->index > end) {
+				unlock_page(page);
+				break;
+			}
+			spin_lock_irq(&mapping->tree_lock);
+			radix_tree_tag_set(&mapping->page_tree, page->index, PAGECACHE_TAG_FSYNC);
+			spin_unlock_irq(&mapping->tree_lock);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	} while (index <= end);
+
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+	do {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_WRITEBACK,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1);
+		if (!nr_pages)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			lock_page(page);
+			if (unlikely(page->mapping != mapping)) {
+				unlock_page(page);
+				continue;
+			}
+			if (page->index > end) {
+				unlock_page(page);
+				break;
+			}
+			spin_lock_irq(&mapping->tree_lock);
+			radix_tree_tag_set(&mapping->page_tree, page->index, PAGECACHE_TAG_FSYNC);
+			spin_unlock_irq(&mapping->tree_lock);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	} while (index <= end);
+
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+	do {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_FSYNC,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1);
+		if (!nr_pages)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/*
+			 * At this point we hold neither mapping->tree_lock nor
+			 * lock on the page itself: the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or even
+			 * swizzled back from swapper_space to tmpfs file
+			 * mapping
+			 */
+again:
+			lock_page(page);
+
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
+			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+				unlock_page(page);
+				continue;
+			}
+
+			if (page->index > end) {
+				unlock_page(page);
+				break;
+			}
+
+			if (PageWriteback(page)) {
+				/* someone else wrote it for us */
+				if (!PageDirty(page)) {
+					goto continue_unlock;
+				} else {
+					/* hmm, but it has been dirtied again */
+					wait_on_page_writeback(page);
+				}
+			}
+
+			BUG_ON(PageWriteback(page));
+
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
+			ret = (*writepage)(page, wbc, data);
+
+			if (unlikely(ret)) {
+				/* Must retry the write, esp. for integrity */
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+					goto again;
+				}
+				break;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	} while (index <= end);
+
+	if (wbc->range_cont)
+		wbc->range_start = (loff_t)index << PAGE_CACHE_SHIFT;
+
+	return ret;
+}
+
+/**
+ * write_cache_pages - walk the list of dirty pages of the given address space and write all of them.
+ * @mapping: address space structure to write
+ * @wbc: subtract the number of written pages from *@wbc->nr_to_write
+ * @writepage: function called for each page
+ * @data: data passed to writepage function
+ *
+ * If a page is already under I/O, write_cache_pages() skips it, even
+ * if it's dirty.  This is desirable behaviour for memory-cleaning writeback,
+ * but it is INCORRECT for data-integrity system calls such as fsync().  fsync()
+ * and msync() need to guarantee that all the data which was dirty at the time
+ * the call was made get new I/O started against them.  If wbc->sync_mode is
+ * WB_SYNC_ALL then we were called for data integrity and we must wait for
+ * existing IO to complete.
+ */
+int write_cache_pages(struct address_space *mapping,
+		      struct writeback_control *wbc, writepage_t writepage,
+		      void *data)
+{
+	if (wbc->sync_mode == WB_SYNC_NONE)
+		return __write_cache_pages(mapping, wbc, writepage, data);
+	else
+		return __write_cache_pages_sync(mapping, wbc, writepage, data);
+}
 EXPORT_SYMBOL(write_cache_pages);
 
 /*
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -305,6 +305,53 @@ int wait_on_page_writeback_range(struct 
 	return ret;
 }
 
+int wait_on_page_writeback_range_fsync(struct address_space *mapping,
+				pgoff_t start, pgoff_t end)
+{
+	struct pagevec pvec;
+	int nr_pages;
+	int ret = 0;
+	pgoff_t index;
+
+	if (end < start)
+		return 0;
+
+	pagevec_init(&pvec, 0);
+	index = start;
+	while ((index <= end) &&
+			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			PAGECACHE_TAG_FSYNC,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
+		unsigned i;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/* until radix tree lookup accepts end_index */
+			if (page->index > end)
+				continue;
+
+			spin_lock_irq(&mapping->tree_lock);
+			radix_tree_tag_clear(&mapping->page_tree, page->index, PAGECACHE_TAG_FSYNC);
+			spin_unlock_irq(&mapping->tree_lock);
+
+			wait_on_page_writeback(page);
+			if (PageError(page))
+				ret = -EIO;
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+
+	/* Check for outstanding write errors */
+	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+		ret = -ENOSPC;
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		ret = -EIO;
+
+	return ret;
+}
+
 /**
  * sync_page_range - write and wait on all pages in the passed range
  * @inode:	target inode
@@ -388,6 +435,17 @@ int filemap_fdatawait(struct address_spa
 }
 EXPORT_SYMBOL(filemap_fdatawait);
 
+int filemap_fdatawait_fsync(struct address_space *mapping)
+{
+	loff_t i_size = i_size_read(mapping->host);
+
+	if (i_size == 0)
+		return 0;
+
+	return wait_on_page_writeback_range_fsync(mapping, 0,
+				(i_size - 1) >> PAGE_CACHE_SHIFT);
+}
+
 int filemap_write_and_wait(struct address_space *mapping)
 {
 	int err = 0;
@@ -401,7 +459,7 @@ int filemap_write_and_wait(struct addres
 		 * thing (e.g. bug) happened, so we avoid waiting for it.
 		 */
 		if (err != -EIO) {
-			int err2 = filemap_fdatawait(mapping);
+			int err2 = filemap_fdatawait_fsync(mapping);
 			if (!err)
 				err = err2;
 		}

--Boundary-00=_JXZ5InMqCvH+Rq2--
