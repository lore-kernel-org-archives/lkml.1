Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbXJDJUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbXJDJUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbXJDJRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbXJDJR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:28 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/51] [GFS2] Prevent infinite loop in try_rgrp_unlink()
Date: Thu,  4 Oct 2007 09:49:01 +0100
Message-Id: <11914878043598-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1191487802255-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is patch three of five for bug #248176.

The try_rgrp_unlink code in rgrp.c had an infinite loop.  This was
caused because the bitmap function rgblk_search can return a block
less than the "goal" block, in which case it was looping.  The fix is
to make it always march forward as needed.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index ce48c45..b93ac45 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -31,6 +31,7 @@
 #include "inode.h"
 
 #define BFITNOENT ((u32)~0)
+#define NO_BLOCK ((u64)~0)
 
 /*
  * These routines are used by the resource group routines (rgrp.c)
@@ -116,8 +117,7 @@ static unsigned char gfs2_testbit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
  * @buffer: the buffer that holds the bitmaps
  * @buflen: the length (in bytes) of the buffer
  * @goal: start search at this block's bit-pair (within @buffer)
- * @old_state: GFS2_BLKST_XXX the state of the block we're looking for;
- *       bit 0 = alloc(1)/free(0), bit 1 = meta(1)/data(0)
+ * @old_state: GFS2_BLKST_XXX the state of the block we're looking for.
  *
  * Scope of @goal and returned block number is only within this bitmap buffer,
  * not entire rgrp or filesystem.  @buffer will be offset from the actual
@@ -137,9 +137,13 @@ static u32 gfs2_bitfit(struct gfs2_rgrpd *rgd, unsigned char *buffer,
 	byte = buffer + (goal / GFS2_NBBY);
 	bit = (goal % GFS2_NBBY) * GFS2_BIT_SIZE;
 	end = buffer + buflen;
-	alloc = (old_state & 1) ? 0 : 0x55;
+	alloc = (old_state == GFS2_BLKST_FREE) ? 0x55 : 0;
 
 	while (byte < end) {
+		/* If we're looking for a free block we can eliminate all
+		   bitmap settings with 0x55, which represents four data
+		   blocks in a row.  If we're looking for a data block, we can
+		   eliminate 0x00 which corresponds to four free blocks. */
 		if ((*byte & 0x55) == alloc) {
 			blk += (8 - bit) >> 1;
 
@@ -859,19 +863,21 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 {
 	struct inode *inode;
-	u32 goal = 0;
+	u32 goal = 0, block;
 	u64 no_addr;
 
 	for(;;) {
 		if (goal >= rgd->rd_data)
 			break;
-		goal = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
-				    GFS2_BLKST_UNLINKED);
-		if (goal == BFITNOENT)
+		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
+				     GFS2_BLKST_UNLINKED);
+		if (block == BFITNOENT)
 			break;
-		no_addr = goal + rgd->rd_data0;
+		/* rgblk_search can return a block < goal, so we need to
+		   keep it marching forward. */
+		no_addr = block + rgd->rd_data0;
 		goal++;
-		if (no_addr < *last_unlinked)
+		if (*last_unlinked != NO_BLOCK && no_addr <= *last_unlinked)
 			continue;
 		*last_unlinked = no_addr;
 		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
@@ -1152,7 +1158,7 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 	struct gfs2_alloc *al = &ip->i_alloc;
 	struct inode *inode;
 	int error = 0;
-	u64 last_unlinked = 0;
+	u64 last_unlinked = NO_BLOCK;
 
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
@@ -1305,9 +1311,7 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 		goal = 0;
 	}
 
-	if (old_state != new_state) {
-		gfs2_assert_withdraw(rgd->rd_sbd, blk != BFITNOENT);
-
+	if (blk != BFITNOENT && old_state != new_state) {
 		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
 		gfs2_setbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
 			    bi->bi_len, blk, new_state);
-- 
1.5.1.2

