Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYFXVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYFXVKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYFXVKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:10:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbYFXVJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:09:59 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] [GFS2] fix gfs2 block allocation (cleaned up)
Date: Tue, 24 Jun 2008 21:20:19 +0100
Message-Id: <12143388292091-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12143388271016-git-send-email-swhiteho@redhat.com>
References: <12143388193217-git-send-email-swhiteho@redhat.com>
 <12143388271016-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch fixes bz 450641.

This patch changes the computation for zero_metapath_length(), which it
renames to metapath_branch_start(). When you are extending the metadata
tree, The indirect blocks that point to the new data block must either
diverge from the existing tree either at the inode, or at the first
indirect block. They can diverge at the first indirect block because the
inode has room for 483 pointers while the indirect blocks have room for
509 pointers, so when the tree is grown, there is some free space in the
first indirect block. What metapath_branch_start() now computes is the
height where the first indirect block for the new data block is located.
It can either be 1 (if the indirect block diverges from the inode) or 2
(if it diverges from the first indirect block).

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c19184f..bec76b1 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -246,15 +246,11 @@ static void find_metapath(const struct gfs2_sbd *sdp, u64 block,
 
 }
 
-static inline unsigned int zero_metapath_length(const struct metapath *mp,
-						unsigned height)
+static inline unsigned int metapath_branch_start(const struct metapath *mp)
 {
-	unsigned int i;
-	for (i = 0; i < height - 1; i++) {
-		if (mp->mp_list[i] != 0)
-			return i;
-	}
-	return height;
+	if (mp->mp_list[0] == 0)
+		return 2;
+	return 1;
 }
 
 /**
@@ -436,7 +432,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct buffer_head *dibh = mp->mp_bh[0];
 	u64 bn, dblock = 0;
-	unsigned n, i, blks, alloced = 0, iblks = 0, zmpl = 0;
+	unsigned n, i, blks, alloced = 0, iblks = 0, branch_start = 0;
 	unsigned dblks = 0;
 	unsigned ptrs_per_blk;
 	const unsigned end_of_metadata = height - 1;
@@ -471,9 +467,8 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 			/* Building up tree height */
 			state = ALLOC_GROW_HEIGHT;
 			iblks = height - ip->i_height;
-			zmpl = zero_metapath_length(mp, height);
-			iblks -= zmpl;
-			iblks += height;
+			branch_start = metapath_branch_start(mp);
+			iblks += (height - branch_start);
 		}
 	}
 
@@ -509,13 +504,13 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 					sizeof(struct gfs2_meta_header));
 				*ptr = zero_bn;
 				state = ALLOC_GROW_DEPTH;
-				for(i = zmpl; i < height; i++) {
+				for(i = branch_start; i < height; i++) {
 					if (mp->mp_bh[i] == NULL)
 						break;
 					brelse(mp->mp_bh[i]);
 					mp->mp_bh[i] = NULL;
 				}
-				i = zmpl;
+				i = branch_start;
 			}
 			if (n == 0)
 				break;
-- 
1.5.1.2

