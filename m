Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXCXVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXCXVz7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 17:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbXCXVz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 17:55:58 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48536 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXCXVz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 17:55:57 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-Id: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 24 Mar 2007 22:55:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a slightly different take on the fix for the deadlock in fuse
with dirty balancing.  David Chinner convinced me, that per-bdi
counters are too expensive, and that it's not worth trying to account
the number of pages under writeback, as they will be limited by the
queue anyway.

----
From: Miklos Szeredi <mszeredi@suse.cz>

Current behavior of balance_dirty_pages() is to try to start writeout
into the specified queue for at least "write_chunk" number of pages.
If "write_chunk" pages have been submitted, then return.

However if there are less than "write_chunk" dirty pages for this
queue, then it doesn't return, waiting for the global dirty+writeback
counters to subside, but without doing any actual work.

This is illogical behavior: it allows more dirtyings while there are
dirty pages, but stops further dirtying completely if there are no
more dirty pages.

It also makes a deadlock possible when one filesystem is writing data
through another, and the balance_dirty_pages() for the lower
filesystem is stalling the writeback for the upper filesystem's
data (*).

So the exit condition should instead be:

  submitted at least "write_chunk" number of pages
OR
    submitted ALL the dirty pages destined for this backing dev
  AND
    backing dev is not congested

To do this, introduce a new counter in writeback_control, which counts
the number of dirty pages encountered during writeback.  This includes
all dirty pages, even those which are already under writeback but have
been dirtied again, and those which have been skipped due to having
locked buffers.

If this counter is zero after trying to submit some pages for
writeback, and the backing dev is uncongested, then don't wait any
more.  After this, newly dirtied pages can quickly be written back to
this backing dev.

If there are globally no more pages to submit for writeback
(nr_reclaimable == 0), then also don't wait for ever, only while this
backing dev is congested.

(*) For more info on this deadlock, see the following discussions:

  http://lkml.org/lkml/2007/3/1/9
  http://lkml.org/lkml/2007/3/12/16

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/writeback.h
===================================================================
--- linux.orig/include/linux/writeback.h	2007-03-24 22:06:56.000000000 +0100
+++ linux/include/linux/writeback.h	2007-03-24 22:29:02.000000000 +0100
@@ -44,6 +44,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long nr_dirty;			/* Number of dirty pages encountered */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-03-24 22:06:56.000000000 +0100
+++ linux/mm/page-writeback.c	2007-03-24 22:29:02.000000000 +0100
@@ -207,7 +207,15 @@ static void balance_dirty_pages(struct a
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
 		 */
-		if (nr_reclaimable) {
+		if (!nr_reclaimable) {
+			/*
+			 * If there's nothing more to write back and this queue
+			 * is uncongested,  then it is possible to quickly
+			 * write out some more data, so let's not wait
+			 */
+			if (!bdi_write_congested(bdi))
+				break;
+		} else {
 			writeback_inodes(&wbc);
 			get_dirty_limits(&background_thresh,
 					 	&dirty_thresh, mapping);
@@ -220,6 +228,14 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+
+			/*
+			 * If there are no more dirty pages for this backing
+			 * backing dev, and the queue is not congested, then
+			 * it is possible to quickly write out some more data
+			 */
+			if (!wbc.nr_dirty && !bdi_write_congested(bdi))
+				break;
 		}
 		congestion_wait(WRITE, HZ/10);
 	}
@@ -619,6 +635,7 @@ retry:
 					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
+		wbc->nr_dirty += nr_pages;
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
