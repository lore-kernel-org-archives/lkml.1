Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYLAAbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYLAAbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYLAAbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:31:23 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33347 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYLAAbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:31:22 -0500
Date: Mon, 1 Dec 2008 00:29:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Woodhouse <dwmw2@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Joern Engel <joern@logfs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Donjun Shin <djshin90@gmail.com>, Tejun Heo <teheo@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/9] swapfile: change discard pgoff_t to sector_t
In-Reply-To: <Pine.LNX.4.64.0811252145190.20455@blonde.site>
Message-ID: <Pine.LNX.4.64.0812010028040.10131@blonde.site>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
 <Pine.LNX.4.64.0811252140230.17555@blonde.site> <Pine.LNX.4.64.0811252145190.20455@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change pgoff_t nr_blocks in discard_swap() and discard_swap_cluster() to
sector_t: given the constraints on swap offsets (in particular, the 5 bits
of swap type accommodated in the same unsigned long), pgoff_t was actually
safe as is, but it certainly looked worrying when shifted left.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
To follow 9/9 swapfile-swap-allocation-cycle-if-nonrot.patch

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- swapfile9/mm/swapfile.c	2008-11-26 12:19:00.000000000 +0000
+++ swapfile10/mm/swapfile.c	2008-11-28 20:36:44.000000000 +0000
@@ -96,7 +96,7 @@ static int discard_swap(struct swap_info
 
 	list_for_each_entry(se, &si->extent_list, list) {
 		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
-		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
+		sector_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
 
 		if (se->start_page == 0) {
 			/* Do not discard the swap header page! */
@@ -133,7 +133,7 @@ static void discard_swap_cluster(struct 
 		    start_page < se->start_page + se->nr_pages) {
 			pgoff_t offset = start_page - se->start_page;
 			sector_t start_block = se->start_block + offset;
-			pgoff_t nr_blocks = se->nr_pages - offset;
+			sector_t nr_blocks = se->nr_pages - offset;
 
 			if (nr_blocks > nr_pages)
 				nr_blocks = nr_pages;
