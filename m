Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbYAUKQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbYAUKQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbYAUKC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:02:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981AbYAUKCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:54 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 38/58] [GFS2] Run through full bitmaps quicker in gfs2_bitfit
Date: Mon, 21 Jan 2008 09:21:56 +0000
Message-Id: <12009074074196-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1200907405414-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
Message-Id: <b9c762a12de432548486e9b3ec0a5b657d3fd00a.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

I eliminated the passing of an unused parameter into gfs2_bitfit called rgd.

This also changes the gfs2_bitfit code that searches for free (or used) blocks.
Before, the code was trying to check for bytes that indicated 4 blocks in
the undesired state.  The problem is, it was spending more time trying to
do this than it actually was saving.  This version only optimizes the case
where we're looking for free blocks, and it checks a machine word at a time.
So on 32-bit machines, it will check 32-bits (16 blocks) and on 64-bit
machines, it will check 64-bits (32 blocks) at a time.  The compiler
optimizes that quite well and we save some time, especially when running
through full bitmaps (like the bitmaps allocated for the journals).

There's probably a more elegant or optimized way to do this, but I haven't
thought of it yet.  I'm open to suggestions.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e0ee195..d7ff9cf 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -126,41 +126,46 @@ static unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
  * Return: the block number (bitmap buffer scope) that was found
  */
 
-static u32 gfs2_bitfit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
-			    unsigned int buflen, u32 goal,
-			    unsigned char old_state)
+static u32 gfs2_bitfit(unsigned char *buffer, unsigned int buflen, u32 goal,
+		       unsigned char old_state)
 {
-	unsigned char *byte, *end, alloc;
+	unsigned char *byte;
 	u32 blk = goal;
-	unsigned int bit;
+	unsigned int bit, bitlong;
+	unsigned long *plong, plong55;
+	static int c = 0;
 
 	byte = buffer + (goal / GFS2_NBBY);
+	plong = buffer + (goal / GFS2_NBBY);
 	bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
-	end = buffer + buflen;
-	alloc = (old_state == GFS2_BLKST_FREE) ? 0x55 : 0;
-
-	while (byte < end) {
-		/* If we're looking for a free block we can eliminate all
-		   bitmap settings with 0x55, which represents four data
-		   blocks in a row.  If we're looking for a data block, we can
-		   eliminate 0x00 which corresponds to four free blocks. */
-		if ((*byte & 0x55) == alloc) {
-			blk += (8 - bit) >> 1;
-
-			bit = 0;
-			byte++;
-
+	bitlong = bit;
+#if BITS_PER_LONG == 32
+	plong55 = 0x55555555;
+#else
+	plong55 = 0x5555555555555555;
+#endif
+	while (byte < buffer + buflen) {
+
+		if (bitlong == 0 && old_state == 0 && *plong == plong55) {
+			plong++;
+			byte += sizeof(unsigned long);
+			blk += sizeof(unsigned long) * GFS2_NBBY;
 			continue;
 		}
-
-		if (((*byte >> bit) & GFS2_BIT_MASK) == old_state)
+		if (((*byte >> bit) & GFS2_BIT_MASK) == old_state) {
+			c++;
 			return blk;
-
+		}
 		bit += GFS2_BIT_SIZE;
 		if (bit >= 8) {
 			bit = 0;
 			byte++;
 		}
+		bitlong += GFS2_BIT_SIZE;
+		if (bitlong >= sizeof(unsigned long) * 8) {
+			bitlong = 0;
+			plong++;
+		}
 
 		blk++;
 	}
@@ -1318,11 +1323,10 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
 		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
-			blk = gfs2_bitfit(rgd, bi->bi_clone + bi->bi_offset,
+			blk = gfs2_bitfit(bi->bi_clone + bi->bi_offset,
 					  bi->bi_len, goal, old_state);
 		else
-			blk = gfs2_bitfit(rgd,
-					  bi->bi_bh->b_data + bi->bi_offset,
+			blk = gfs2_bitfit(bi->bi_bh->b_data + bi->bi_offset,
 					  bi->bi_len, goal, old_state);
 		if (blk != BFITNOENT)
 			break;
-- 
1.5.1.2

