Return-Path: <linux-kernel-owner+w=401wt.eu-S1751960AbXHTVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbXHTVxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXHTVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59775 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbXHTVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:17 -0400
Message-Id: <20070820215316.526397437@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:43 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 3/7] shrink_page_list: Support isolating dirty pages on laundry list
Content-Disposition: inline; filename=shrink_modes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a laundry list is specified then do not write out pages but put
dirty pages on a laundry list for later processing.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:13:28.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:27:00.000000000 -0700
@@ -380,16 +380,22 @@ cannot_free:
 }
 
 /*
- * shrink_page_list() returns the number of reclaimed pages
+ * shrink_page_list() returns the number of reclaimed pages.
+ *
+ * If laundry is specified then dirty pages are put onto the
+ * laundry list and no writes are triggered.
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
-					struct scan_control *sc)
+		struct scan_control *sc, struct list_head *laundry)
 {
 	LIST_HEAD(ret_pages);
 	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
 
+	if (list_empty(page_list))
+		return 0;
+
 	cond_resched();
 
 	pagevec_init(&freed_pvec, 1);
@@ -407,10 +413,11 @@ static unsigned long shrink_page_list(st
 		if (TestSetPageLocked(page))
 			goto keep;
 
-		VM_BUG_ON(PageActive(page));
-
 		sc->nr_scanned++;
 
+		if (PageActive(page))
+			goto keep_locked;
+
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
@@ -506,6 +513,12 @@ static unsigned long shrink_page_list(st
 			if (!may_write_to_queue(mapping->backing_dev_info))
 				goto keep_locked;
 
+			if (laundry) {
+				list_add(&page->lru, laundry);
+				unlock_page(page);
+				continue;
+			}
+
 			/* Page is dirty, try to write it out here */
 			switch(pageout(page, mapping)) {
 			case PAGE_ACTIVATE:
@@ -817,7 +830,7 @@ static unsigned long shrink_inactive_lis
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
-		nr_freed = shrink_page_list(&page_list, sc);
+		nr_freed = shrink_page_list(&page_list, sc, NULL);
 		nr_reclaimed += nr_freed;
 		local_irq_disable();
 		if (current_is_kswapd()) {

-- 
