Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXGFJXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXGFJXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbXGFJX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:23:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXGFJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:23:26 -0400
Date: Fri, 6 Jul 2007 18:24:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, mel@csn.ul.ie
Subject: [PATCH] memory unplug v7 [2/6] - isolate_lru_page fix
Message-Id: <20070706182420.d7d3b615.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070706181903.428c3713.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

release_pages() in mm/swap.c changes page_count() to be 0
without removing PageLRU flag...

This means isolate_lru_page() can see a page, PageLRU() && page_count(page)==0..
This is BUG. (get_page() will be called against count=0 page.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm1/mm/migrate.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/migrate.c
+++ linux-2.6.22-rc6-mm1/mm/migrate.c
@@ -49,9 +49,8 @@ int isolate_lru_page(struct page *page, 
 		struct zone *zone = page_zone(page);
 
 		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page)) {
+		if (PageLRU(page) && get_page_unless_zero(page)) {
 			ret = 0;
-			get_page(page);
 			ClearPageLRU(page);
 			if (PageActive(page))
 				del_page_from_active_list(zone, page);

