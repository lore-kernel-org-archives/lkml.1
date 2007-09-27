Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbXI0WvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbXI0WvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXI0WvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:51:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbXI0WvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:51:00 -0400
Date: Thu, 27 Sep 2007 18:50:27 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kswapd should only wait on IO if there is IO
Message-ID: <20070927185027.1a1b4c13@bree.surriel.com>
In-Reply-To: <20070927152121.3f5b6830.akpm@linux-foundation.org>
References: <20070927170816.055548fd@bree.surriel.com>
	<20070927144702.a9124c7a.akpm@linux-foundation.org>
	<20070927181325.21aae460@bree.surriel.com>
	<20070927152121.3f5b6830.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 15:21:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Nope, sc.nr_io_pages will also be incremented when the code runs into
> > pages that are already PageWriteback.
> 
> yup, I didn't think of that.  Hopefully someone else will be in there
> working on that zone too.  If this caller yields and defers to kswapd
> then that's very likely.  Except we just took away the ability to do that..

                if (PageDirty(page)) {
                        if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
                                goto keep_locked;
                        if (!may_enter_fs)
                                goto keep_locked;

I think we can fix that problem by adding a sc->nr_io_pages++
between the last if and the goto keep_locked in shrink_page_list.

That way !GFP_IO or !GFP_FS tasks will cause themselves to sleep
if there are pages that need to be written out, even if those
pages are not in flight to disk yet.

I have also added the comment you wanted.

Signed-off-by: Rik van Riel <riel@redhat.com>

diff -up linux-2.6.23-rc7/mm/vmscan.c.wait linux-2.6.22/mm/vmscan.c
--- linux-2.6.23-rc7/mm/vmscan.c.wait	2007-09-27 18:45:57.000000000 -0400
+++ linux-2.6.23-rc7/mm/vmscan.c	2007-09-27 18:48:43.000000000 -0400
@@ -68,6 +68,13 @@ struct scan_control {
 	int all_unreclaimable;
 
 	int order;
+
+	/*
+	 * Pages that have (or should have) IO pending.  If we run into
+	 * a lot of these, we're better off waiting a little for IO to
+	 * finish rather than scanning more pages in the VM.
+	 */
+	int nr_io_pages;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -489,8 +496,10 @@ static unsigned long shrink_page_list(st
 			 */
 			if (sync_writeback == PAGEOUT_IO_SYNC && may_enter_fs)
 				wait_on_page_writeback(page);
-			else
+			else {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 		}
 
 		referenced = page_referenced(page, 1);
@@ -529,8 +538,10 @@ static unsigned long shrink_page_list(st
 		if (PageDirty(page)) {
 			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
 				goto keep_locked;
-			if (!may_enter_fs)
+			if (!may_enter_fs) {
+				sc->nr_io_pages++;
 				goto keep_locked;
+			}
 			if (!sc->may_writepage)
 				goto keep_locked;
 
@@ -541,8 +552,10 @@ static unsigned long shrink_page_list(st
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
-				if (PageWriteback(page) || PageDirty(page))
+				if (PageWriteback(page) || PageDirty(page)) {
+					sc->nr_io_pages++;
 					goto keep;
+				}
 				/*
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
@@ -1201,6 +1214,7 @@ unsigned long try_to_free_pages(struct z
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc.nr_scanned = 0;
+		sc.nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, &sc);
@@ -1229,7 +1243,8 @@ unsigned long try_to_free_pages(struct z
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
+		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
+				sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1315,6 +1330,7 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
+		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1398,7 +1414,8 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2 &&
+					sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 
 		/*
