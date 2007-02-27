Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbXB0Tf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbXB0Tf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbXB0Tf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:35:57 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40100 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbXB0Tfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:35:55 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 4/5] lumpy: update commentry on subtle comparisons and rounding assumptions
References: <exportbomb.1172604830@kernel>
InReply-To: <exportbomb.1172604830@kernel>
Message-ID: <809581470a06dbac8c3e709828bf7e72@kernel>
Date: Tue, 27 Feb 2007 11:35:53 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We have a number of subtle comparisons when scanning a block, and
we make use of a lot of buddy mem_map guarentees.  Add commentary about
each.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2bfad79..bef7e92 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -709,7 +709,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		/*
 		 * Attempt to take all pages in the order aligned region
 		 * surrounding the tag page.  Only take those pages of
-		 * the same active state as that tag page.
+		 * the same active state as that tag page.  We may safely
+		 * round the target page pfn down to the requested order
+		 * as the mem_map is guarenteed valid out to MAX_ORDER,
+		 * where that page is in a different zone we will detect
+		 * it from its zone id and abort this block scan.
 		 */
 		zone_id = page_zone_id(page);
 		page_pfn = page_to_pfn(page);
@@ -718,12 +722,15 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		for (; pfn < end_pfn; pfn++) {
 			struct page *cursor_page;
 
+			/* The target page is in the block, ignore it. */
 			if (unlikely(pfn == page_pfn))
 				continue;
+			/* Avoid holes within the zone. */
 			if (unlikely(!pfn_valid(pfn)))
 				break;
 
 			cursor_page = pfn_to_page(pfn);
+			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
 			scan++;
