Return-Path: <linux-kernel-owner+w=401wt.eu-S1763597AbYDQJrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763597AbYDQJrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933657AbYDQJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933680AbYDQJ0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:12 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/48] [GFS2] Get inode buffer only once per block map call
Date: Thu, 17 Apr 2008 09:39:05 +0100
Message-Id: <12084216281152-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216262937-git-send-email-swhiteho@redhat.com>
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
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

In the case that we needed to grow the height of the metadata tree
we were looking up the inode buffer and then brelse()ing it despite
the fact that it is needed later in the block map process.

This patch ensures that we look up the inode's buffer once and only
once during the block map process.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e27e660..f1f38ca 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -188,50 +188,45 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned new_height = height - ip->i_height;
-	struct buffer_head *dibh;
+	struct buffer_head *dibh = mp->mp_bh[0];
 	struct gfs2_dinode *di;
-	int error;
 	__be64 *bp;
 	u64 bn;
 	unsigned n, i = 0;
 
-	if (height <= ip->i_height)
-		return 0;
-
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (error)
-		return error;
+	BUG_ON(height <= ip->i_height);
 
 	do {
 		n = new_height - i;
 		bn = gfs2_alloc_block(ip, &n);
 		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, n);
 		do {
-			mp->mp_bh[i] = gfs2_meta_new(ip->i_gl, bn++);
-			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i], 1);
+			mp->mp_bh[i + 1] = gfs2_meta_new(ip->i_gl, bn++);
+			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i + 1], 1);
 			i++;
 		} while(i < n);
 	} while(i < new_height);
 
 	n = 0;
-	bn = mp->mp_bh[0]->b_blocknr;
+	bn = mp->mp_bh[1]->b_blocknr;
 	if (new_height > 1) {
 		for(; n < new_height-1; n++) {
-			gfs2_metatype_set(mp->mp_bh[n], GFS2_METATYPE_IN,
+			gfs2_metatype_set(mp->mp_bh[n + 1], GFS2_METATYPE_IN,
 					  GFS2_FORMAT_IN);
-			gfs2_buffer_clear_tail(mp->mp_bh[n],
+			gfs2_buffer_clear_tail(mp->mp_bh[n + 1],
 					       sizeof(struct gfs2_meta_header));
-			bp = (__be64 *)(mp->mp_bh[n]->b_data +
+			bp = (__be64 *)(mp->mp_bh[n + 1]->b_data +
 				     sizeof(struct gfs2_meta_header));
-			*bp = cpu_to_be64(mp->mp_bh[n+1]->b_blocknr);
-			brelse(mp->mp_bh[n]);
-			mp->mp_bh[n] = NULL;
+			*bp = cpu_to_be64(mp->mp_bh[n+2]->b_blocknr);
+			brelse(mp->mp_bh[n+1]);
+			mp->mp_bh[n+1] = NULL;
 		}
 	}
-	gfs2_metatype_set(mp->mp_bh[n], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
-	gfs2_buffer_copy_tail(mp->mp_bh[n], sizeof(struct gfs2_meta_header),
+	gfs2_metatype_set(mp->mp_bh[n+1], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
+	gfs2_buffer_copy_tail(mp->mp_bh[n+1], sizeof(struct gfs2_meta_header),
 			      dibh, sizeof(struct gfs2_dinode));
-	brelse(mp->mp_bh[n]);
+	brelse(mp->mp_bh[n+1]);
+	mp->mp_bh[n+1] = NULL;
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
@@ -240,8 +235,7 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 	gfs2_add_inode_blocks(&ip->i_inode, new_height);
 	di->di_height = cpu_to_be16(ip->i_height);
 	di->di_blocks = cpu_to_be64(gfs2_get_inode_blocks(&ip->i_inode));
-	brelse(dibh);
-	return error;
+	return 0;
 }
 
 /**
@@ -391,11 +385,7 @@ static int lookup_metapath(struct inode *inode, struct metapath *mp,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	unsigned int end_of_metadata = ip->i_height - 1;
 	unsigned int x;
-	int ret = gfs2_meta_inode_buffer(ip, &bh);
-	if (ret)
-		return ret;
-
-	mp->mp_bh[0] = bh;
+	int ret;
 
 	for (x = 0; x < end_of_metadata; x++) {
 		lookup_block(ip, x, mp, create, new, dblock);
@@ -515,6 +505,10 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	}
 	size = (lblock + 1) * bsize;
 
+	error = gfs2_meta_inode_buffer(ip, &mp.mp_bh[0]);
+	if (error)
+		goto out_fail;
+
 	if (size > arr[ip->i_height]) {
 		u8 height = ip->i_height;
 		if (!create)
-- 
1.5.1.2

