Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbXHNKRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbXHNKRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbXHNKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXHNKKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:52 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Fix incorrect return code in rgrp.c
Date: Tue, 14 Aug 2007 10:47:13 +0100
Message-Id: <11870848572998-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The following patch fixes a bug where 0 was being used as a return code
to indicate "nothing to do" when in fact 0 was a valid block location
which might be returned by the function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index bb58e69..ce48c45 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -867,7 +867,7 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 			break;
 		goal = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
 				    GFS2_BLKST_UNLINKED);
-		if (goal == 0)
+		if (goal == BFITNOENT)
 			break;
 		no_addr = goal + rgd->rd_data0;
 		goal++;
@@ -1316,7 +1316,7 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 				    bi->bi_len, blk, new_state);
 	}
 
-	return (blk == BFITNOENT) ? 0 : (bi->bi_start * GFS2_NBBY) + blk;
+	return (blk == BFITNOENT) ? blk : (bi->bi_start * GFS2_NBBY) + blk;
 }
 
 /**
@@ -1396,6 +1396,7 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 		goal = rgd->rd_last_alloc_data;
 
 	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
+	BUG_ON(blk == BFITNOENT);
 	rgd->rd_last_alloc_data = blk;
 
 	block = rgd->rd_data0 + blk;
@@ -1440,6 +1441,7 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 		goal = rgd->rd_last_alloc_meta;
 
 	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
+	BUG_ON(blk == BFITNOENT);
 	rgd->rd_last_alloc_meta = blk;
 
 	block = rgd->rd_data0 + blk;
@@ -1481,6 +1483,7 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 
 	blk = rgblk_search(rgd, rgd->rd_last_alloc_meta,
 			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE);
+	BUG_ON(blk == BFITNOENT);
 
 	rgd->rd_last_alloc_meta = blk;
 
-- 
1.5.1.2

