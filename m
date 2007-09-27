Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbXI0VJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbXI0VJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXI0VIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:08:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbXI0VIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:08:54 -0400
Date: Thu, 27 Sep 2007 17:08:16 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] kswapd should only wait on IO if there is IO
Message-ID: <20070927170816.055548fd@bree.surriel.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current kswapd (and try_to_free_pages) code has an oddity where the
code will wait on IO, even if there is no IO in flight.  This problem is
notable especially when the system scans through many unfreeable pages,
causing unnecessary stalls in the VM.

Signed-off-by: Rik van Riel <riel@surriel.com>

diff -up linux-2.6.22.x86_64/mm/vmscan.c.wait linux-2.6.22.x86_64/mm/vmscan.c
--- linux-2.6.22.x86_64/mm/vmscan.c.wait	2007-09-25 11:33:30.000000000 -0400
+++ linux-2.6.22.x86_64/mm/vmscan.c	2007-09-25 21:27:08.000000000 -0400
@@ -68,6 +68,8 @@ struct scan_control {
 	int all_unreclaimable;
 
 	int order;
+
+	int nr_io_pages;
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -489,8 +491,10 @@ static unsigned long shrink_page_list(st
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
@@ -541,8 +545,10 @@ static unsigned long shrink_page_list(st
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
@@ -1201,6 +1207,7 @@ unsigned long try_to_free_pages(struct z
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc.nr_scanned = 0;
+		sc.nr_io_pages = 0;
 		if (!priority)
 			disable_swap_token();
 		nr_reclaimed += shrink_zones(priority, zones, &sc);
@@ -1229,7 +1236,8 @@ unsigned long try_to_free_pages(struct z
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc.nr_scanned && priority < DEF_PRIORITY - 2)
+		if (sc.nr_scanned && priority < DEF_PRIORITY - 2 &&
+				sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_caches still had more to do? don't OOM, then */
@@ -1315,6 +1323,7 @@ loop_again:
 		if (!priority)
 			disable_swap_token();
 
+		sc.nr_io_pages = 0;
 		all_zones_ok = 1;
 
 		/*
@@ -1398,7 +1407,8 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
-		if (total_scanned && priority < DEF_PRIORITY - 2)
+		if (total_scanned && priority < DEF_PRIORITY - 2 &&
+					sc.nr_io_pages > sc.swap_cluster_max)
 			congestion_wait(WRITE, HZ/10);
 
 		/*

