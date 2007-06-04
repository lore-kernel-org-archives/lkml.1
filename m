Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbXFDPi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbXFDPi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbXFDPiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:38:05 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44976 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbXFDPiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:38:03 -0400
Subject: [PATCH -mm 5/5] swap: Catch pages with errors and mark as bad
From: Richard Purdie <rpurdie@openedhand.com>
To: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 16:37:07 +0100
Message-Id: <1180971427.6313.77.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check for pages with errors within shrink_page_list() and if found, try
to unuse them which will trigger the functions to mark the page bad. The
page will then be allocated a new swap page.

If a swap page write error occurs, don't disable page reclaim.

Based on a patch by Nick Piggin and some of my own changes as discussed
on LKML.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 mm/page_io.c |    3 ---
 mm/vmscan.c  |    9 +++++++++
 2 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.21/mm/page_io.c
===================================================================
--- linux-2.6.21.orig/mm/page_io.c	2007-06-04 09:49:06.000000000 +0100
+++ linux-2.6.21/mm/page_io.c	2007-06-04 11:40:24.000000000 +0100
@@ -60,15 +60,12 @@ static int end_swap_bio_write(struct bio
 		 * Re-dirty the page in order to avoid it being reclaimed.
 		 * Also print a dire warning that things will go BAD (tm)
 		 * very quickly.
-		 *
-		 * Also clear PG_reclaim to avoid rotate_reclaimable_page()
 		 */
 		set_page_dirty(page);
 		printk(KERN_ALERT "Write-error on swap-device (%u:%u:%Lu)\n",
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_sector);
-		ClearPageReclaim(page);
 	}
 	end_page_writeback(page);
 	bio_put(bio);
Index: linux-2.6.21/mm/vmscan.c
===================================================================
--- linux-2.6.21.orig/mm/vmscan.c	2007-06-04 11:39:23.000000000 +0100
+++ linux-2.6.21/mm/vmscan.c	2007-06-04 11:40:24.000000000 +0100
@@ -477,6 +477,15 @@ static unsigned long shrink_page_list(st
 
 #ifdef CONFIG_SWAP
 		/*
+		 * Encountered an error last time? Try to remove the
+		 * page from its current position, which will notice
+		 * the error and mark that swap entry bad. Then we can
+		 * try allocating another swap entry.
+		 */
+		if (PageSwapCache(page) && unlikely(PageError(page)))
+			try_to_unuse_page_entry(page);
+
+		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */

