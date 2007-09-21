Return-Path: <linux-kernel-owner+w=401wt.eu-S1762441AbXIUVBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762441AbXIUVBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764143AbXIUUsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:48:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:31121 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764141AbXIUUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:48:11 -0400
Date: Fri, 21 Sep 2007 21:48:06 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Christoph Lameter <clameter@sgi.com>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] LBS: support largeblocked swapfile
In-Reply-To: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0709212147270.13529@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0709212141220.6532@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust setup_swap_extents so as not to assume that PAGE_SIZE is a multiple
of its swapfile blocksize: blocksize might now be a multiple of PAGE_SIZE.
Not vital to support this, but LTP in ext2 -b 32768 /tmp was failing before.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc6-lbs/mm/swapfile.c	2007-08-04 07:08:50.000000000 +0100
+++ linux/mm/swapfile.c	2007-09-17 17:09:03.000000000 +0100
@@ -1057,6 +1057,7 @@ static int setup_swap_extents(struct swa
 {
 	struct inode *inode;
 	unsigned blocks_per_page;
+	unsigned pages_per_block;
 	unsigned long page_no;
 	unsigned blkbits;
 	sector_t probe_block;
@@ -1074,7 +1075,13 @@ static int setup_swap_extents(struct swa
 	}
 
 	blkbits = inode->i_blkbits;
-	blocks_per_page = PAGE_SIZE >> blkbits;
+	if (blkbits <= PAGE_SHIFT) {
+		blocks_per_page = 1 << (PAGE_SHIFT - blkbits);
+		pages_per_block = 1;
+	} else {
+		blocks_per_page = 1;
+		pages_per_block = 1 << (blkbits - PAGE_SHIFT);
+	}
 
 	/*
 	 * Map all the blocks into the extent list.  This code doesn't try
@@ -1114,28 +1121,34 @@ static int setup_swap_extents(struct swa
 			}
 		}
 
-		first_block >>= (PAGE_SHIFT - blkbits);
+		if (blkbits <= PAGE_SHIFT)
+			first_block >>= (PAGE_SHIFT - blkbits);
+		else {
+			first_block <<= (blkbits - PAGE_SHIFT);
+			if (page_no + pages_per_block > sis->max)
+				pages_per_block = sis->max - page_no;
+		}
 		if (page_no) {	/* exclude the header page */
 			if (first_block < lowest_block)
 				lowest_block = first_block;
-			if (first_block > highest_block)
-				highest_block = first_block;
+			if (first_block >= highest_block)
+				highest_block = first_block + pages_per_block;
 		}
 
 		/*
 		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
 		 */
-		ret = add_swap_extent(sis, page_no, 1, first_block);
+		ret = add_swap_extent(sis,page_no,pages_per_block,first_block);
 		if (ret < 0)
 			goto out;
 		nr_extents += ret;
-		page_no++;
+		page_no += pages_per_block;
 		probe_block += blocks_per_page;
 reprobe:
 		continue;
 	}
 	ret = nr_extents;
-	*span = 1 + highest_block - lowest_block;
+	*span = highest_block - lowest_block;
 	if (page_no == 0)
 		page_no = 1;	/* force Empty message */
 	sis->max = page_no;
