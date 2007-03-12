Return-Path: <linux-kernel-owner+w=401wt.eu-S1751222AbXCLSY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbXCLSY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXCLSY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:24:26 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1587 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbXCLSYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:24:25 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/3] lumpy: only count taken pages as scanned
References: <exportbomb.1173723760@pinky>
InReply-To: <exportbomb.1173723760@pinky>
Message-ID: <f1e5ef335bb5a202c7b18faaa0e97b83@pinky>
Date: Mon, 12 Mar 2007 18:24:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When scanning the order sized area around the tag page we pull all
pages of the matching active state; the non-matching pages are not
otherwise affected.  We currently count these as scanned increasing
the apparent scan rates.  Previously we would only count a page
scanned if it was actually removed from the LRU, either then being
reclaimed or rotated back onto the head of the LRU.

The effect of this is to cause reclaim to terminate artificially
early when the scan count is reached, reducing effectivness.  Move to
counting only those pages we actually remove from the LRU as scanned.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d7a0860..c3dc544 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -732,11 +732,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			scan++;
 			switch (__isolate_lru_page(cursor_page, active)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
+				scan++;
 				break;
 
 			case -EBUSY:
