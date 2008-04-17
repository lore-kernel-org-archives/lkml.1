Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYDQJoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYDQJoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763243AbYDQJ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933690AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/48] [GFS2] Merge the rd_last_alloc_meta and rd_last_alloc_data fields
Date: Thu, 17 Apr 2008 09:38:58 +0100
Message-Id: <12084216153016-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216121811-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We don't need to keep track of when we last allocated data
and metadata separately since the only thing thats important
when searching for a free block is whether its free or not,
which is independent from what type of block it is.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index c50dcdf..898b456 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -90,8 +90,7 @@ struct gfs2_rgrpd {
 	struct mutex rd_mutex;
 	u32 rd_free_clone;
 	struct gfs2_log_element rd_le;
-	u32 rd_last_alloc_data;
-	u32 rd_last_alloc_meta;
+	u32 rd_last_alloc;
 	struct gfs2_sbd *rd_sbd;
 	unsigned char rd_flags;
 #define GFS2_RDF_CHECK        0x01      /* Need to check for unlinked inodes */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 66193b4..cc28845 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1422,11 +1422,11 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
 	else
-		goal = rgd->rd_last_alloc_data;
+		goal = rgd->rd_last_alloc;
 
 	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
 	BUG_ON(blk == BFITNOENT);
-	rgd->rd_last_alloc_data = blk;
+	rgd->rd_last_alloc = blk;
 
 	block = rgd->rd_data0 + blk;
 	ip->i_goal = block;
@@ -1467,11 +1467,11 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 	if (rgrp_contains_block(rgd, ip->i_goal))
 		goal = ip->i_goal - rgd->rd_data0;
 	else
-		goal = rgd->rd_last_alloc_meta;
+		goal = rgd->rd_last_alloc;
 
 	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
 	BUG_ON(blk == BFITNOENT);
-	rgd->rd_last_alloc_meta = blk;
+	rgd->rd_last_alloc = blk;
 
 	block = rgd->rd_data0 + blk;
 	ip->i_goal = block;
@@ -1510,11 +1510,11 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	u32 blk;
 	u64 block;
 
-	blk = rgblk_search(rgd, rgd->rd_last_alloc_meta,
+	blk = rgblk_search(rgd, rgd->rd_last_alloc,
 			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE);
 	BUG_ON(blk == BFITNOENT);
 
-	rgd->rd_last_alloc_meta = blk;
+	rgd->rd_last_alloc = blk;
 
 	block = rgd->rd_data0 + blk;
 
-- 
1.5.1.2

