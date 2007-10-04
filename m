Return-Path: <linux-kernel-owner+w=401wt.eu-S1760364AbXJDJWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364AbXJDJWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759469AbXJDJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:17:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658AbXJDJRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:17:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/51] [GFS2] invalid metadata block - REVISED
Date: Thu,  4 Oct 2007 09:49:07 +0100
Message-Id: <1191487815172-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878141625-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is for bugzilla bug #248176: GFS2: invalid metadata block

Patches 1 thru 3 were accepted upstream, but there were problems
with 4 and 5.  Those issues have been resolved and now the recovery
tests are passing without errors.  This code has gone through
41 * 3 successful gfs2 recovery tests before it hit an
unrelated (openais) problem.

This is a complete rewrite of patch 4 for bug #248176.

Part of the problem was that inodes were being recycled
before their buffers were flushed to the journal logs.
Another problem was that the clone bitmaps were being
searched for deleted inodes to recycle, but only the
"real" bitmaps should be searched for that purpose.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b93ac45..2d7f7ea 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -865,12 +865,15 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 	struct inode *inode;
 	u32 goal = 0, block;
 	u64 no_addr;
+	struct gfs2_sbd *sdp = rgd->rd_sbd;
 
 	for(;;) {
 		if (goal >= rgd->rd_data)
 			break;
+		down_write(&sdp->sd_log_flush_lock);
 		block = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
 				     GFS2_BLKST_UNLINKED);
+		up_write(&sdp->sd_log_flush_lock);
 		if (block == BFITNOENT)
 			break;
 		/* rgblk_search can return a block < goal, so we need to
@@ -1295,7 +1298,9 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 	   allocatable block anywhere else, we want to be able wrap around and
 	   search in the first part of our first-searched bit block.  */
 	for (x = 0; x <= length; x++) {
-		if (bi->bi_clone)
+		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
+		   bitmaps, so we must search the originals for that. */
+		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
 			blk = gfs2_bitfit(rgd, bi->bi_clone + bi->bi_offset,
 					  bi->bi_len, goal, old_state);
 		else
-- 
1.5.1.2

