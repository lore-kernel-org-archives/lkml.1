Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZF2N3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZF2N3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF2N24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:28:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:10577 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZF2N2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:28:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,309,1243839600"; 
   d="scan'208";a="159586062"
Date: Mon, 29 Jun 2009 21:28:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
Message-ID: <20090629132841.GA26171@localhost>
References: <20090606224538.GA6173@localhost> <20090618120436.ad3196e3.akpm@linux-foundation.org> <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net> <20090629131326.GA23668@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20090629131326.GA23668@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 29, 2009 at 09:13:27PM +0800, Wu Fengguang wrote:
> On Mon, Jun 29, 2009 at 09:04:57PM +0800, Vladislav Bolkhovitin wrote:
> > Wu Fengguang, on 06/29/2009 04:54 PM wrote:
> > > 
> > > Why not 2.6.30? :)
> > 
> > We started with 2.6.29, so why not complete with it (to save additional 
> > Ronald's effort to move on 2.6.30)?
> 
> OK, that's fair enough.

btw, I backported the 2.6.31 context readahead patches to 2.6.29, just
in case it will help the SCST performance.

Ronald, if you run context readahead, please make sure that the server
side readahead size is bigger than the client side readahead size.

Thanks,
Fengguang

--uAKRQypu60I7Lcqm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="readahead-context-2.6.29.patch"

--- linux.orig/mm/readahead.c
+++ linux/mm/readahead.c
@@ -337,6 +337,59 @@ static unsigned long get_next_ra_size(st
  */
 
 /*
+ * Count contiguously cached pages from @offset-1 to @offset-@max,
+ * this count is a conservative estimation of
+ * 	- length of the sequential read sequence, or
+ * 	- thrashing threshold in memory tight systems
+ */
+static pgoff_t count_history_pages(struct address_space *mapping,
+				   struct file_ra_state *ra,
+				   pgoff_t offset, unsigned long max)
+{
+	pgoff_t head;
+
+	rcu_read_lock();
+	head = radix_tree_prev_hole(&mapping->page_tree, offset - 1, max);
+	rcu_read_unlock();
+
+	return offset - 1 - head;
+}
+
+/*
+ * page cache context based read-ahead
+ */
+static int try_context_readahead(struct address_space *mapping,
+				 struct file_ra_state *ra,
+				 pgoff_t offset,
+				 unsigned long req_size,
+				 unsigned long max)
+{
+	pgoff_t size;
+
+	size = count_history_pages(mapping, ra, offset, max);
+
+	/*
+	 * no history pages:
+	 * it could be a random read
+	 */
+	if (!size)
+		return 0;
+
+	/*
+	 * starts from beginning of file:
+	 * it is a strong indication of long-run stream (or whole-file-read)
+	 */
+	if (size >= offset)
+		size *= 2;
+
+	ra->start = offset;
+	ra->size = get_init_ra_size(size + req_size, max);
+	ra->async_size = ra->size;
+
+	return 1;
+}
+
+/*
  * A minimal readahead algorithm for trivial sequential/random reads.
  */
 static unsigned long
@@ -345,34 +398,26 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	int	max = ra->ra_pages;	/* max readahead pages */
-	pgoff_t prev_offset;
-	int	sequential;
+	unsigned long max = max_sane_readahead(ra->ra_pages);
+
+	/*
+	 * start of file
+	 */
+	if (!offset)
+		goto initial_readahead;
 
 	/*
 	 * It's the expected callback offset, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	if (offset && (offset == (ra->start + ra->size - ra->async_size) ||
-			offset == (ra->start + ra->size))) {
+	if ((offset == (ra->start + ra->size - ra->async_size) ||
+	     offset == (ra->start + ra->size))) {
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
 	}
 
-	prev_offset = ra->prev_pos >> PAGE_CACHE_SHIFT;
-	sequential = offset - prev_offset <= 1UL || req_size > max;
-
-	/*
-	 * Standalone, small read.
-	 * Read as is, and do not pollute the readahead state.
-	 */
-	if (!hit_readahead_marker && !sequential) {
-		return __do_page_cache_readahead(mapping, filp,
-						offset, req_size, 0);
-	}
-
 	/*
 	 * Hit a marked page without valid readahead state.
 	 * E.g. interleaved reads.
@@ -383,7 +428,7 @@ ondemand_readahead(struct address_space 
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = radix_tree_next_hole(&mapping->page_tree, offset,max+1);
+		start = radix_tree_next_hole(&mapping->page_tree, offset+1,max);
 		rcu_read_unlock();
 
 		if (!start || start - offset > max)
@@ -391,23 +436,53 @@ ondemand_readahead(struct address_space 
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
+		ra->size += req_size;
 		ra->size = get_next_ra_size(ra, max);
 		ra->async_size = ra->size;
 		goto readit;
 	}
 
 	/*
-	 * It may be one of
-	 * 	- first read on start of file
-	 * 	- sequential cache miss
-	 * 	- oversize random read
-	 * Start readahead for it.
+	 * oversize read
+	 */
+	if (req_size > max)
+		goto initial_readahead;
+
+	/*
+	 * sequential cache miss
 	 */
+	if (offset - (ra->prev_pos >> PAGE_CACHE_SHIFT) <= 1UL)
+		goto initial_readahead;
+
+	/*
+	 * Query the page cache and look for the traces(cached history pages)
+	 * that a sequential stream would leave behind.
+	 */
+	if (try_context_readahead(mapping, ra, offset, req_size, max))
+		goto readit;
+
+	/*
+	 * standalone, small random read
+	 * Read as is, and do not pollute the readahead state.
+	 */
+	return __do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+
+initial_readahead:
 	ra->start = offset;
 	ra->size = get_init_ra_size(req_size, max);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 readit:
+	/*
+	 * Will this read hit the readahead marker made by itself?
+	 * If so, trigger the readahead marker hit now, and merge
+	 * the resulted next readahead window into the current one.
+	 */
+	if (offset == ra->start && ra->size == ra->async_size) {
+		ra->async_size = get_next_ra_size(ra, max);
+		ra->size += ra->async_size;
+	}
+
 	return ra_submit(ra, mapping, filp);
 }
 
--- linux.orig/lib/radix-tree.c
+++ linux/lib/radix-tree.c
@@ -666,6 +666,43 @@ unsigned long radix_tree_next_hole(struc
 }
 EXPORT_SYMBOL(radix_tree_next_hole);
 
+/**
+ *	radix_tree_prev_hole    -    find the prev hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search backwards in the range [max(index-max_scan+1, 0), index]
+ *	for the first hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'index - return >= max_scan'
+ *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of
+ *	the tree at a single point in time. For example, if a hole is created
+ *	at index 10, then subsequently a hole is created at index 5,
+ *	radix_tree_prev_hole covering both indexes may return 5 if called under
+ *	rcu_read_lock.
+ */
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				   unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index--;
+		if (index == LONG_MAX)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_prev_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
--- linux.orig/include/linux/radix-tree.h
+++ linux/include/linux/radix-tree.h
@@ -167,6 +167,8 @@ radix_tree_gang_lookup_slot(struct radix
 			unsigned long first_index, unsigned int max_items);
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,

--uAKRQypu60I7Lcqm--
