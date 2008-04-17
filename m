Return-Path: <linux-kernel-owner+w=401wt.eu-S934780AbYDQJjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780AbYDQJjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933542AbYDQJZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523AbYDQJZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:40 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/48] [GFS2] Move part of gfs2_block_map into a separate function
Date: Thu, 17 Apr 2008 09:38:49 +0100
Message-Id: <12084215961690-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084215931509-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This is required to enable future changes to the block
mapping code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e84e384..08d1be4 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -384,6 +384,35 @@ static int lookup_block(struct gfs2_inode *ip, struct buffer_head *bh,
 	return 0;
 }
 
+static int lookup_metapath(struct inode *inode, struct metapath *mp,
+			   int create, int *new, u64 *dblock,
+			   struct buffer_head **dibh, struct buffer_head **bh)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	unsigned int end_of_metadata = ip->i_height - 1;
+	unsigned int x;
+	int ret = gfs2_meta_inode_buffer(ip, bh);
+	if (ret)
+		return ret;
+
+	*dibh = *bh;
+	get_bh(*dibh);
+
+	for (x = 0; x < end_of_metadata; x++) {
+		lookup_block(ip, *bh, x, mp, create, new, dblock);
+		brelse(*bh);
+		*bh = NULL;
+		if (!dblock)
+			return 0;
+
+		ret = gfs2_meta_indirect_buffer(ip, x+1, *dblock, *new, bh);
+		if (ret)
+			return ret;
+	}
+
+	return lookup_block(ip, *bh, end_of_metadata, mp, create, new, dblock);
+}
+
 static inline void bmap_lock(struct inode *inode, int create)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -419,10 +448,8 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	struct buffer_head *bh;
 	unsigned int bsize = sdp->sd_sb.sb_bsize;
-	unsigned int end_of_metadata;
-	unsigned int x;
+	struct buffer_head *bh = NULL;
 	int error = 0;
 	int new = 0;
 	u64 dblock = 0;
@@ -459,25 +486,11 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	}
 
 	find_metapath(ip, lblock, &mp);
-	end_of_metadata = ip->i_height - 1;
-	error = gfs2_meta_inode_buffer(ip, &bh);
-	if (error)
+	error = lookup_metapath(inode, &mp, create, &new, &dblock, &dibh, &bh);
+	if (error < 0)
 		goto out_fail;
-	dibh = bh;
-	get_bh(dibh);
-
-	for (x = 0; x < end_of_metadata; x++) {
-		lookup_block(ip, bh, x, &mp, create, &new, &dblock);
-		brelse(bh);
-		if (!dblock)
-			goto out_ok;
+	boundary = error;
 
-		error = gfs2_meta_indirect_buffer(ip, x+1, dblock, new, &bh);
-		if (error)
-			goto out_fail;
-	}
-
-	boundary = lookup_block(ip, bh, end_of_metadata, &mp, create, &new, &dblock);
 	if (dblock) {
 		map_bh(bh_map, inode->i_sb, dblock);
 		if (boundary)
@@ -489,6 +502,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 			goto out_brelse;
 		}
 		while(--maxlen && !buffer_boundary(bh_map)) {
+			unsigned int end_of_metadata = ip->i_height - 1;
 			u64 eblock;
 
 			mp.mp_list[end_of_metadata]++;
@@ -501,7 +515,8 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 		}
 	}
 out_brelse:
-	brelse(bh);
+	if (bh)
+		brelse(bh);
 out_ok:
 	error = 0;
 out_fail:
-- 
1.5.1.2

