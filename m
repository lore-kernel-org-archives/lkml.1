Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbXCNWJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbXCNWJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXCNWJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:09:29 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47948 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXCNWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:09:27 -0400
To: dgc@sgi.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070313221236.GY6095633@melbourne.sgi.com> (message from David
	Chinner on Wed, 14 Mar 2007 09:12:36 +1100)
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com> <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu> <20070312214405.GQ6095633@melbourne.sgi.com> <E1HQt7o-00042r-00@dorka.pomaz.szeredi.hu> <20070312231256.GT6095633@melbourne.sgi.com> <E1HR2Gd-0004oR-00@dorka.pomaz.szeredi.hu> <20070313221236.GY6095633@melbourne.sgi.com>
Message-Id: <E1HRbec-0001uK-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Mar 2007 23:09:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Only if the queue depth is not bound. Queue depths are bound and so
> the distance we can go over the threshold is limited.  This is the
> fundamental principle on which the throttling is based.....
> 
> Hence, if the queue is not full, then we will have either written
> dirty pages to it (i.e wbc->nr_write != write_chunk so we will throttle
> or continue normally if write_chunk was written) or we have no more
> dirty pages left.
> 
> Having no dirty pages left on the bdi and it not being congested
> means we effectively have a clean, idle bdi. We should not be trying
> to throttle writeback here - we can't do anything to improve the
> situation by continuing to try to do writeback on this bdi, so we
> may as well give up and let the writer continue. Once we have dirty
> pages on the bdi, we'll get throttled appropriately.

OK, you convinced me.

How about this patch?  I introduced a new wbc counter, that sums the
number of dirty pages encountered, including ones already under
writeback.

Dave, big thanks for your insights.

Miklos

Index: linux/include/linux/writeback.h
===================================================================
--- linux.orig/include/linux/writeback.h	2007-03-14 22:43:42.000000000 +0100
+++ linux/include/linux/writeback.h	2007-03-14 22:58:56.000000000 +0100
@@ -44,6 +44,7 @@ struct writeback_control {
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
+	long nr_dirty;			/* Number of dirty pages encountered */
 
 	/*
 	 * For a_ops->writepages(): is start or end are non-zero then this is
Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2007-03-14 22:41:01.000000000 +0100
+++ linux/mm/page-writeback.c	2007-03-14 23:00:20.000000000 +0100
@@ -220,6 +220,17 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
+
+			/*
+			 * If just a few dirty pages were encountered, and
+			 * the queue is not congested, then allow this dirty
+			 * producer to continue.  This resolves the deadlock
+			 * that happens when one filesystem writes back data
+			 * through another.  It should also help when a slow
+			 * device is completely blocking other writes.
+			 */
+			if (wbc.nr_dirty < 8 && !bdi_write_congested(bdi))
+				break;
 		}
 		congestion_wait(WRITE, HZ/10);
 	}
@@ -612,6 +623,7 @@ retry:
 					      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
 		unsigned i;
 
+		wbc->nr_dirty += nr_pages;
 		scanned = 1;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
