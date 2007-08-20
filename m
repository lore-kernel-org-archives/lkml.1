Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbXHTVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbXHTVyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXHTVxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51607 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbXHTVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:18 -0400
Message-Id: <20070820215316.287244006@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:42 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 2/7] Move checks from pageout() to shrink_page_list
Content-Disposition: inline; filename=move_checks_to_shrink_page_list
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary because we soon will do other things than calling
pageout() from shrink_page_list().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   90 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 21:39:55.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 21:47:56.000000000 -0700
@@ -273,8 +273,6 @@ static void handle_write_error(struct ad
 
 /* possible outcome of pageout() */
 typedef enum {
-	/* failed to write page out, page is locked */
-	PAGE_KEEP,
 	/* move page to the active list, page is locked */
 	PAGE_ACTIVATE,
 	/* page has been sent to the disk successfully, page is unlocked */
@@ -289,44 +287,6 @@ typedef enum {
  */
 static pageout_t pageout(struct page *page, struct address_space *mapping)
 {
-	/*
-	 * If the page is dirty, only perform writeback if that write
-	 * will be non-blocking.  To prevent this allocation from being
-	 * stalled by pagecache activity.  But note that there may be
-	 * stalls if we need to run get_block().  We could test
-	 * PagePrivate for that.
-	 *
-	 * If this process is currently in generic_file_write() against
-	 * this page's queue, we can perform writeback even if that
-	 * will block.
-	 *
-	 * If the page is swapcache, write it back even if that would
-	 * block, for some throttling. This happens by accident, because
-	 * swap_backing_dev_info is bust: it doesn't reflect the
-	 * congestion state of the swapdevs.  Easy to fix, if needed.
-	 * See swapfile.c:page_queue_congested().
-	 */
-	if (!is_page_cache_freeable(page))
-		return PAGE_KEEP;
-	if (!mapping) {
-		/*
-		 * Some data journaling orphaned pages can have
-		 * page->mapping == NULL while being dirty with clean buffers.
-		 */
-		if (PagePrivate(page)) {
-			if (try_to_free_buffers(page)) {
-				ClearPageDirty(page);
-				printk("%s: orphaned page\n", __FUNCTION__);
-				return PAGE_CLEAN;
-			}
-		}
-		return PAGE_KEEP;
-	}
-	if (mapping->a_ops->writepage == NULL)
-		return PAGE_ACTIVATE;
-	if (!may_write_to_queue(mapping->backing_dev_info))
-		return PAGE_KEEP;
-
 	if (clear_page_dirty_for_io(page)) {
 		int res;
 		struct writeback_control wbc = {
@@ -504,18 +464,58 @@ static unsigned long shrink_page_list(st
 			if (!sc->may_writepage)
 				goto keep_locked;
 
+			/*
+			 * If the page is dirty, only perform writeback if
+			 * that write will be non-blocking.  To prevent this
+			 * allocation from being stalled by pagecache
+			 * activity.  But note that there may be stalls if
+			 * we need to run get_block().  We could test
+			 * PagePrivate for that.
+			 *
+			 * If this process is currently in
+			 * generic_file_write() against this page's queue,
+			 * we can perform writeback even if that will block.
+			 *
+			 * If the page is swapcache, write it back even if
+			 * that would block, for some throttling. This happens
+			 * by accident, because swap_backing_dev_info is bust:
+			 * it doesn't reflect the congestion state of the
+			 * swapdevs.  Easy to fix, if needed.
+			 * See swapfile.c:page_queue_congested().
+			 */
+			if (!is_page_cache_freeable(page))
+				goto keep_locked;
+			if (!mapping) {
+				/*
+				 * Some data journaling orphaned pages can
+				 * have page->mapping == NULL while being
+				 * dirty with clean buffers.
+				 */
+				if (PagePrivate(page)) {
+					if (try_to_free_buffers(page)) {
+						ClearPageDirty(page);
+						printk("%s: orphaned page\n",
+								__FUNCTION__);
+						goto release_page;
+					}
+				}
+				goto keep_locked;
+			}
+			if (mapping->a_ops->writepage == NULL)
+				goto activate_locked;
+			if (!may_write_to_queue(mapping->backing_dev_info))
+				goto keep_locked;
+
 			/* Page is dirty, try to write it out here */
 			switch(pageout(page, mapping)) {
-			case PAGE_KEEP:
-				goto keep_locked;
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
 				if (PageWriteback(page) || PageDirty(page))
 					goto keep;
 				/*
-				 * A synchronous write - probably a ramdisk.  Go
-				 * ahead and try to reclaim the page.
+				 * A synchronous write - probably a ramdisk.
+				 * Go ahead and try to reclaim the page.
 				 */
 				if (TestSetPageLocked(page))
 					goto keep;
@@ -526,7 +526,7 @@ static unsigned long shrink_page_list(st
 				; /* try to free the page below */
 			}
 		}
-
+release_page:
 		/*
 		 * If the page has buffers, try to free the buffer mappings
 		 * associated with this page. If we succeed we try to free

-- 
