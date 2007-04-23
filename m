Return-Path: <linux-kernel-owner+w=401wt.eu-S1161382AbXDWKzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382AbXDWKzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161379AbXDWKzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:55:24 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:43893 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161369AbXDWKzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:55:22 -0400
Message-Id: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Mon, 23 Apr 2007 19:54:52 +0900
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] mm: PageLRU can be non-atomic bit operation
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

PageLRU flag operation is protected by zone->lru_lock, so SetPageLRU/ClearPageLRU
can be replaced to __SetPageLRU/__ClearPageLRU non-atomic bit operation.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.21-rc7.org/include/linux/page-flags.h 
linux-2.6.21-rc7/include/linux/page-flags.h
--- linux-2.6.21-rc7.org/include/linux/page-flags.h	2007-04-17 
16:36:05.000000000 +0900
+++ linux-2.6.21-rc7/include/linux/page-flags.h	2007-04-23 
18:28:19.000000000 +0900
@@ -148,8 +148,7 @@ static inline void SetPageUptodate(struc
  #define TestClearPageDirty(page) test_and_clear_bit(PG_dirty, &(page)->flags)

  #define PageLRU(page)		test_bit(PG_lru, &(page)->flags)
-#define SetPageLRU(page)	set_bit(PG_lru, &(page)->flags)
-#define ClearPageLRU(page)	clear_bit(PG_lru, &(page)->flags)
+#define __SetPageLRU(page)	__set_bit(PG_lru, &(page)->flags)
  #define __ClearPageLRU(page)	__clear_bit(PG_lru, &(page)->flags)

  #define PageActive(page)	test_bit(PG_active, &(page)->flags)
diff -Nrup linux-2.6.21-rc7.org/mm/migrate.c linux-2.6.21-rc7/mm/migrate.c
--- linux-2.6.21-rc7.org/mm/migrate.c	2007-04-17 16:36:05.000000000 +0900
+++ linux-2.6.21-rc7/mm/migrate.c	2007-04-23 18:30:43.000000000 +0900
@@ -52,7 +52,7 @@ int isolate_lru_page(struct page *page,
  		if (PageLRU(page)) {
  			ret = 0;
  			get_page(page);
-			ClearPageLRU(page);
+			__ClearPageLRU(page);
  			if (PageActive(page))
  				del_page_from_active_list(zone, page);
  			else
diff -Nrup linux-2.6.21-rc7.org/mm/swap.c linux-2.6.21-rc7/mm/swap.c
--- linux-2.6.21-rc7.org/mm/swap.c	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.21-rc7/mm/swap.c	2007-04-23 18:29:51.000000000 +0900
@@ -364,7 +364,7 @@ void __pagevec_lru_add(struct pagevec *p
  			spin_lock_irq(&zone->lru_lock);
  		}
  		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
+		__SetPageLRU(page);
  		add_page_to_inactive_list(zone, page);
  	}
  	if (zone)
@@ -391,7 +391,7 @@ void __pagevec_lru_add_active(struct pag
  			spin_lock_irq(&zone->lru_lock);
  		}
  		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
+		__SetPageLRU(page);
  		VM_BUG_ON(PageActive(page));
  		SetPageActive(page);
  		add_page_to_active_list(zone, page);
diff -Nrup linux-2.6.21-rc7.org/mm/vmscan.c linux-2.6.21-rc7/mm/vmscan.c
--- linux-2.6.21-rc7.org/mm/vmscan.c	2007-04-17 16:36:05.000000000 +0900
+++ linux-2.6.21-rc7/mm/vmscan.c	2007-04-23 18:30:30.000000000 +0900
@@ -642,7 +642,7 @@ static unsigned long isolate_lru_pages(u
  			 * sure the page is not being freed elsewhere -- the
  			 * page release code relies on it.
  			 */
-			ClearPageLRU(page);
+			__ClearPageLRU(page);
  			target = dst;
  			nr_taken++;
  		} /* else it is being freed elsewhere */
@@ -704,7 +704,7 @@ static unsigned long shrink_inactive_lis
  		while (!list_empty(&page_list)) {
  			page = lru_to_page(&page_list);
  			VM_BUG_ON(PageLRU(page));
-			SetPageLRU(page);
+			__SetPageLRU(page);
  			list_del(&page->lru);
  			if (PageActive(page))
  				add_page_to_active_list(zone, page);
@@ -851,7 +851,7 @@ force_reclaim_mapped:
  		page = lru_to_page(&l_inactive);
  		prefetchw_prev_lru_page(page, &l_inactive, flags);
  		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
+		__SetPageLRU(page);
  		VM_BUG_ON(!PageActive(page));
  		ClearPageActive(page);

@@ -881,7 +881,7 @@ force_reclaim_mapped:
  		page = lru_to_page(&l_active);
  		prefetchw_prev_lru_page(page, &l_active, flags);
  		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
+		__SetPageLRU(page);
  		VM_BUG_ON(!PageActive(page));
  		list_move(&page->lru, &zone->active_list);
  		pgmoved++; 

