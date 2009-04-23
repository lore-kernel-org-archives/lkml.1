Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZDWKWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZDWKWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZDWKWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:22:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44435 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbZDWKWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:22:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] GFS2: Ensure that the inode goal block settings are updated
Date: Thu, 23 Apr 2009 10:16:56 +0100
Message-Id: <1240478216-2594-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1240478216-2594-3-git-send-email-swhiteho@redhat.com>
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
 <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
 <1240478216-2594-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GFS2 has a goal block associated with each inode indicating the
search start position for future block allocations (in fact there
are two, but thats for backward compatibility with GFS1 as they
are set to identical locations in GFS2).

In some circumstances, depending on the ordering of updates to
the inode it was possible for the goal block settings to not
be updated on disk. This patch ensures that the goal block will
always get updated, thus reducing the potential for searching
the same (already allocated) blocks again when looking for free
space during block allocation.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c9786a4..5650382 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1444,10 +1444,12 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct buffer_head *dibh;
 	struct gfs2_alloc *al = ip->i_alloc;
 	struct gfs2_rgrpd *rgd = al->al_rgd;
 	u32 goal, blk;
 	u64 block;
+	int error;
 
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
@@ -1460,7 +1462,13 @@ u64 gfs2_alloc_block(struct gfs2_inode *ip, unsigned int *n)
 	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
 	ip->i_goal = block;
-
+	error = gfs2_meta_inode_buffer(ip, &dibh);
+	if (error == 0) {
+		struct gfs2_dinode *di = (struct gfs2_dinode *)dibh->b_data;
+		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		di->di_goal_meta = di->di_goal_data = cpu_to_be64(ip->i_goal);
+		brelse(dibh);
+	}
 	gfs2_assert_withdraw(sdp, rgd->rd_free >= *n);
 	rgd->rd_free -= *n;
 
-- 
1.6.0.6

