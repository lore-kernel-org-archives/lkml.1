Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZJBOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZJBOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZJBOuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:50:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:7612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZJBOuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:50:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,494,1249282800"; 
   d="scan'208";a="194417328"
Date: Fri, 2 Oct 2009 22:46:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Steve French <sfrench@samba.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       David Howells <dhowells@redhat.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] writeback: abort writeback of the inode on wrap-around
Message-ID: <20091002144622.GA29123@localhost>
References: <20091002095050.GA12750@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002095050.GA12750@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 05:50:50PM +0800, Wu Fengguang wrote:
> 
> The new .stop_on_wrap is a quick hack to show the basic idea. Ideal
> would be to just convert the existing .range_cyclic to new behavior.
> This should simplify a lot of code.
> 
> Since this involves many filesystems. I'd like to ask if any of them
> in fact _desire_ the current .range_cyclic semantics to wrap?

Here is the more complete patch, not tested yet :)

Convert wbc.range_cyclic to new behavior: when past EOF, abort the
writeback of the current inode, which will instruct
writeback_single_inode() to redirty_tail() it. 

This is the right behavior for
- sync writeback (is already so with range_whole)
  we have scanned the inode address space, and don't care any more newly
  dirtied pages. So shall update its i_dirtied_when and exclude it from
  the todo list.
- periodic writeback
  any more newly dirtied pages should be associated with a new expire
  time. This also prevents pointless IO for busy overwriters.
- background writeback
  irrelevant because it generally don't care the dirty timestamp.

That should get rid of one ineffcient IO pattern of .range_cyclic when
writeback_index wraps, in which the submitted pages may be consisted of
two distant ranges: submit [10000-10100], (wrap), submit [0-100].

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/staging/pohmelfs/inode.c |   25 ++++++++-----------------
 fs/afs/write.c                   |   21 +++------------------
 fs/btrfs/extent_io.c             |   21 ++++++---------------
 fs/cifs/file.c                   |   15 +++------------
 fs/ext4/inode.c                  |   18 ++++--------------
 fs/gfs2/aops.c                   |   16 ++--------------
 fs/nfs/write.c                   |    6 +++---
 mm/page-writeback.c              |   25 ++++---------------------
 8 files changed, 33 insertions(+), 114 deletions(-)

--- linux.orig/mm/page-writeback.c	2009-10-02 22:06:49.000000000 +0800
+++ linux/mm/page-writeback.c	2009-10-02 22:31:26.000000000 +0800
@@ -789,29 +789,21 @@ int write_cache_pages(struct address_spa
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
-		index = writeback_index;
-		if (index == 0)
-			cycled = 1;
-		else
-			cycled = 0;
+		index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		cycled = 1; /* ignore range_cyclic tests */
 	}
 retry:
 	done_index = index;
@@ -821,8 +813,10 @@ retry:
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			      PAGECACHE_TAG_DIRTY,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
+		if (nr_pages == 0) {
+			done_index = 0;
 			break;
+		}
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -919,17 +913,6 @@ continue_unlock:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled && !done) {
-		/*
-		 * range_cyclic:
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		cycled = 1;
-		index = 0;
-		end = writeback_index - 1;
-		goto retry;
-	}
 	if (!wbc->no_nrwrite_index_update) {
 		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
 			mapping->writeback_index = done_index;
--- linux.orig/drivers/staging/pohmelfs/inode.c	2009-10-02 22:06:45.000000000 +0800
+++ linux/drivers/staging/pohmelfs/inode.c	2009-10-02 22:17:41.000000000 +0800
@@ -149,7 +149,6 @@ static int pohmelfs_writepages(struct ad
 	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
 	int range_whole = 0;
 
 	if (wbc->range_cyclic) {
@@ -160,17 +159,18 @@ static int pohmelfs_writepages(struct ad
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && (index <= end)) {
 		unsigned int i = min(end - index, (pgoff_t)psb->trans_max_pages);
 		int path_len;
 		struct netfs_trans *trans;
 
 		err = pohmelfs_inode_has_dirty_pages(mapping, index);
-		if (!err)
+		if (!err) {
+			index = 0;
 			break;
+		}
 
 		err = pohmelfs_path_length(pi);
 		if (err < 0)
@@ -197,15 +197,16 @@ retry:
 		dprintk("%s: t: %p, nr_pages: %u, end: %lu, index: %lu, max: %u.\n",
 				__func__, trans, nr_pages, end, index, trans->page_num);
 
-		if (!nr_pages)
+		if (!nr_pages) {
+			index = 0;
 			goto err_out_reset;
+		}
 
 		err = pohmelfs_write_inode_create(inode, trans);
 		if (err)
 			goto err_out_reset;
 
 		err = 0;
-		scanned = 1;
 
 		for (i = 0; i < trans->page_num; i++) {
 			struct page *page = trans->pages[i];
@@ -215,7 +216,7 @@ retry:
 			if (unlikely(page->mapping != mapping))
 				goto out_continue;
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				goto out_continue;
 			}
@@ -263,16 +264,6 @@ err_out_reset:
 		break;
 	}
 
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
-
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
--- linux.orig/fs/afs/write.c	2009-10-02 22:11:40.000000000 +0800
+++ linux/fs/afs/write.c	2009-10-02 22:12:06.000000000 +0800
@@ -455,8 +455,6 @@ int afs_writepage(struct page *page, str
 	}
 
 	wbc->nr_to_write -= ret;
-	if (wbc->nonblocking && bdi_write_congested(bdi))
-		wbc->encountered_congestion = 1;
 
 	_leave(" = 0");
 	return 0;
@@ -479,8 +477,10 @@ static int afs_writepages_region(struct 
 	do {
 		n = find_get_pages_tag(mapping, &index, PAGECACHE_TAG_DIRTY,
 				       1, &page);
-		if (!n)
+		if (!n) {
+			index = 0;
 			break;
+		}
 
 		_debug("wback %lx", page->index);
 
@@ -529,11 +529,6 @@ static int afs_writepages_region(struct 
 
 		wbc->nr_to_write -= ret;
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			break;
-		}
-
 		cond_resched();
 	} while (index < end && wbc->nr_to_write > 0);
 
@@ -554,20 +549,10 @@ int afs_writepages(struct address_space 
 
 	_enter("");
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		_leave(" = 0 [congest]");
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		start = mapping->writeback_index;
 		end = -1;
 		ret = afs_writepages_region(mapping, wbc, start, end, &next);
-		if (start > 0 && wbc->nr_to_write > 0 && ret == 0 &&
-		    !(wbc->nonblocking && wbc->encountered_congestion))
-			ret = afs_writepages_region(mapping, wbc, 0, start,
-						    &next);
 		mapping->writeback_index = next;
 	} else if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX) {
 		end = (pgoff_t)(LLONG_MAX >> PAGE_CACHE_SHIFT);
--- linux.orig/fs/btrfs/extent_io.c	2009-10-02 22:06:37.000000000 +0800
+++ linux/fs/btrfs/extent_io.c	2009-10-02 22:25:29.000000000 +0800
@@ -2402,10 +2402,9 @@ static int extent_write_cache_pages(stru
 	int done = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
-	int nr_pages;
+	int nr_pages = 1;
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
-	int scanned = 0;
 	int range_whole = 0;
 
 	pagevec_init(&pvec, 0);
@@ -2417,16 +2416,14 @@ static int extent_write_cache_pages(stru
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			      PAGECACHE_TAG_DIRTY, min(end - index,
 				  (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
-		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
@@ -2447,7 +2444,7 @@ retry:
 				continue;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				unlock_page(page);
 				continue;
@@ -2484,15 +2481,9 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
-		index = 0;
-		goto retry;
-	}
+	if (!nr_pages)
+		mapping->writeback_index = 0;
+
 	return ret;
 }
 
--- linux.orig/fs/cifs/file.c	2009-10-02 22:06:45.000000000 +0800
+++ linux/fs/cifs/file.c	2009-10-02 22:24:52.000000000 +0800
@@ -1356,7 +1356,6 @@ static int cifs_writepages(struct addres
 	struct page *page;
 	struct pagevec pvec;
 	int rc = 0;
-	int scanned = 0;
 	int xid, long_op;
 
 	cifs_sb = CIFS_SB(mapping->host->i_sb);
@@ -1390,9 +1389,8 @@ static int cifs_writepages(struct addres
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
-retry:
+
 	while (!done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			PAGECACHE_TAG_DIRTY,
@@ -1425,7 +1423,7 @@ retry:
 				break;
 			}
 
-			if (!wbc->range_cyclic && page->index > end) {
+			if (page->index > end) {
 				done = 1;
 				unlock_page(page);
 				break;
@@ -1537,15 +1535,8 @@ retry:
 
 		pagevec_release(&pvec);
 	}
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
+	if (!nr_pages)
 		index = 0;
-		goto retry;
-	}
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 
--- linux.orig/fs/ext4/inode.c	2009-10-02 22:06:45.000000000 +0800
+++ linux/fs/ext4/inode.c	2009-10-02 22:33:57.000000000 +0800
@@ -2805,7 +2805,7 @@ static int ext4_da_writepages(struct add
 	int pages_written = 0;
 	long pages_skipped;
 	unsigned int max_pages;
-	int range_cyclic, cycled = 1, io_done = 0;
+	int range_cyclic, io_done = 0;
 	int needed_blocks, ret = 0;
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
@@ -2840,8 +2840,6 @@ static int ext4_da_writepages(struct add
 	range_cyclic = wbc->range_cyclic;
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-		if (index)
-			cycled = 0;
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
 		wbc->range_end  = LLONG_MAX;
 		wbc->range_cyclic = 0;
@@ -2889,7 +2887,6 @@ static int ext4_da_writepages(struct add
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
-retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2963,20 +2960,13 @@ retry:
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
 			io_done = 1;
-		} else if (wbc->nr_to_write)
+		} else if (wbc->nr_to_write <= 0) {
 			/*
 			 * There is no more writeout needed
-			 * or we requested for a noblocking writeout
-			 * and we found the device congested
 			 */
+			index = 0;
 			break;
-	}
-	if (!io_done && !cycled) {
-		cycled = 1;
-		index = 0;
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
-		wbc->range_end  = mapping->writeback_index - 1;
-		goto retry;
+		}
 	}
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,
--- linux.orig/fs/gfs2/aops.c	2009-10-02 22:06:45.000000000 +0800
+++ linux/fs/gfs2/aops.c	2009-10-02 22:36:09.000000000 +0800
@@ -287,7 +287,7 @@ static int gfs2_write_jdata_pagevec(stru
 			continue;
 		}
 
-		if (!wbc->range_cyclic && page->index > end) {
+		if (page->index > end) {
 			ret = 1;
 			unlock_page(page);
 			continue;
@@ -340,7 +340,6 @@ static int gfs2_write_cache_jdata(struct
 	int nr_pages;
 	pgoff_t index;
 	pgoff_t end;
-	int scanned = 0;
 	int range_whole = 0;
 
 	pagevec_init(&pvec, 0);
@@ -352,15 +351,12 @@ static int gfs2_write_cache_jdata(struct
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		scanned = 1;
 	}
 
-retry:
 	 while (!done && (index <= end) &&
 		(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 					       PAGECACHE_TAG_DIRTY,
 					       min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
-		scanned = 1;
 		ret = gfs2_write_jdata_pagevec(mapping, wbc, &pvec, nr_pages, end);
 		if (ret)
 			done = 1;
@@ -371,16 +367,8 @@ retry:
 		cond_resched();
 	}
 
-	if (!scanned && !done) {
-		/*
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		scanned = 1;
+	if (!nr_pages)
 		index = 0;
-		goto retry;
-	}
-
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = index;
 	return ret;
