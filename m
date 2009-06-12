Return-Path: <linux-kernel-owner+w=401wt.eu-S1764032AbZFLB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764032AbZFLB2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbZFLB2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:28:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45862 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760070AbZFLB2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:28:16 -0400
Date: Fri, 12 Jun 2009 10:26:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mel@csn.ul.ie
Subject: [BUGFIX][PATCH] fix lumpy reclaim lru handiling at
 isolate_lru_pages v2
Message-Id: <20090612102644.a3e7ad3a.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for noisy posts. I hope this should be the last trial.
Thank you for all helps.

-Kame
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

At lumpy reclaim, a page failed to be taken by __isolate_lru_page() can
be pushed back to "src" list by list_move(). But the page may not be from
"src" list. This pushes the page back to wrong LRU.
And list_move() itself is unnecessary because the page is
not on top of LRU. Then, leave it as it is if __isolate_lru_page() fails.

Changelog: v1->v2
 - removed buggy break.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

Index: lumpy-reclaim-trial/mm/vmscan.c
===================================================================
--- lumpy-reclaim-trial.orig/mm/vmscan.c
+++ lumpy-reclaim-trial/mm/vmscan.c
@@ -936,18 +936,10 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			switch (__isolate_lru_page(cursor_page, mode, file)) {
-			case 0:
+			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
 				scan++;
-				break;
-
-			case -EBUSY:
-				/* else it is being freed elsewhere */
-				list_move(&cursor_page->lru, src);
-			default:
-				break;	/* ! on LRU or wrong list */
 			}
 		}
 	}

