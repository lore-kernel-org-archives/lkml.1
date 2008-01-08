Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYAHVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYAHVOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYAHVKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:10:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbYAHVKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:10:37 -0500
Message-Id: <20080108210005.558041779@redhat.com>
References: <20080108205939.323955454@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 15:59:46 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [patch 07/19] (NEW) add some sanity checks to get_scan_ratio
Content-Disposition: inline; filename=rvr-04-linux-2.6-scan-ratio-fixes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access ratio based scan rate determination in get_scan_ratio
works ok in most situations, but needs to be corrected in some
corner cases:
- if we run out of swap space, do not bother scanning the anon LRUs
- if we have already freed all of the page cache, we need to scan
  the anon LRUs

Signed-off-by: Rik van Riel <riel@redhat.com>

Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
===================================================================
--- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-01-07 17:33:50.000000000 -0500
+++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-01-07 17:57:49.000000000 -0500
@@ -1182,7 +1182,7 @@ static unsigned long shrink_list(enum lr
 static void get_scan_ratio(struct zone *zone, struct scan_control * sc,
 					unsigned long *percent)
 {
-	unsigned long anon, file;
+	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long rotate_sum;
 	unsigned long ap, fp;
@@ -1230,6 +1230,20 @@ static void get_scan_ratio(struct zone *
 	else if (fp > 100)
 		fp = 100;
 	percent[1] = fp;
+
+	free = zone_page_state(zone, NR_FREE_PAGES);
+
+	/*
+	 * If we have no swap space, do not bother scanning anon pages
+	 */
+	if (nr_swap_pages <= 0)
+		percent[0] = 0;
+	/*
+	 * If we already freed most file pages, scan the anon pages
+	 * regardless of the page access ratios or swappiness setting.
+	 */
+	else if (file + free <= zone->pages_high)
+		percent[0] = 100;
 }
 
 

-- 
All Rights Reversed

