Return-Path: <linux-kernel-owner+w=401wt.eu-S1161182AbXCNMOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161182AbXCNMOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161201AbXCNMOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:14:48 -0400
Received: from ns2.suse.de ([195.135.220.15]:43533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161182AbXCNMOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:14:47 -0400
Date: Wed, 14 Mar 2007 13:14:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: [patch 1/2] splice: dont steal
Message-ID: <20070314121440.GA926@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple of splice patches I found when digging in the area.
I could be wrong, so I'd appreciate confirmation.

Untested other than compile, because I don't have a good splice test
setup.

Considering these are data corruption / information leak issues, then
we could do worse than to merge them in 2.6.21 and earlier stable
trees.

Does anyone really use splice stealing?

--

Stealing pages with splice is problematic because we cannot just insert
an uptodate page into the pagecache and hope the filesystem can take care
of it later.

We also cannot just ClearPageUptodate, then hope prepare_write does not
write anything into the page, because I don't think prepare_write gives
that guarantee.

Remove support for SPLICE_F_MOVE for now. If we really want to bring it
back, we might be able to do so with a the new filesystem buffered write
aops APIs I'm working on. If we really don't want to bring it back, then
we should decide that sooner rather than later, and remove the flag and
all the stealing infrastructure before anybody starts using it.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c
+++ linux-2.6/fs/splice.c
@@ -576,76 +576,51 @@ static int pipe_to_file(struct pipe_inod
 	if (this_len + offset > PAGE_CACHE_SIZE)
 		this_len = PAGE_CACHE_SIZE - offset;
 
-	/*
-	 * Reuse buf page, if SPLICE_F_MOVE is set and we are doing a full
-	 * page.
-	 */
-	if ((sd->flags & SPLICE_F_MOVE) && this_len == PAGE_CACHE_SIZE) {
+find_page:
+	page = find_lock_page(mapping, index);
+	if (!page) {
+		ret = -ENOMEM;
+		page = page_cache_alloc_cold(mapping);
+		if (unlikely(!page))
+			goto out_ret;
+
 		/*
-		 * If steal succeeds, buf->page is now pruned from the
-		 * pagecache and we can reuse it. The page will also be
-		 * locked on successful return.
+		 * This will also lock the page
 		 */
-		if (buf->ops->steal(pipe, buf))
-			goto find_page;
-
-		page = buf->page;
-		if (add_to_page_cache(page, mapping, index, GFP_KERNEL)) {
-			unlock_page(page);
-			goto find_page;
-		}
-
-		page_cache_get(page);
+		ret = add_to_page_cache_lru(page, mapping, index,
+					    GFP_KERNEL);
+		if (unlikely(ret))
+			goto out;
+	}
 
-		if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-			lru_cache_add(page);
-	} else {
-find_page:
-		page = find_lock_page(mapping, index);
-		if (!page) {
-			ret = -ENOMEM;
-			page = page_cache_alloc_cold(mapping);
-			if (unlikely(!page))
-				goto out_ret;
-
-			/*
-			 * This will also lock the page
-			 */
-			ret = add_to_page_cache_lru(page, mapping, index,
-						    GFP_KERNEL);
+	/*
+	 * We get here with the page locked. If the page is also
+	 * uptodate, we don't need to do more. If it isn't, we
+	 * may need to bring it in if we are not going to overwrite
+	 * the full page.
+	 */
+	if (!PageUptodate(page)) {
+		if (this_len < PAGE_CACHE_SIZE) {
+			ret = mapping->a_ops->readpage(file, page);
 			if (unlikely(ret))
 				goto out;
-		}
 
-		/*
-		 * We get here with the page locked. If the page is also
-		 * uptodate, we don't need to do more. If it isn't, we
-		 * may need to bring it in if we are not going to overwrite
-		 * the full page.
-		 */
-		if (!PageUptodate(page)) {
-			if (this_len < PAGE_CACHE_SIZE) {
-				ret = mapping->a_ops->readpage(file, page);
-				if (unlikely(ret))
-					goto out;
-
-				lock_page(page);
-
-				if (!PageUptodate(page)) {
-					/*
-					 * Page got invalidated, repeat.
-					 */
-					if (!page->mapping) {
-						unlock_page(page);
-						page_cache_release(page);
-						goto find_page;
-					}
-					ret = -EIO;
-					goto out;
+			lock_page(page);
+
+			if (!PageUptodate(page)) {
+				/*
+				 * Page got invalidated, repeat.
+				 */
+				if (!page->mapping) {
+					unlock_page(page);
+					page_cache_release(page);
+					goto find_page;
 				}
-			} else
-				SetPageUptodate(page);
-		}
+				ret = -EIO;
+				goto out;
+			}
+		} else
+			SetPageUptodate(page);
 	}
 
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
