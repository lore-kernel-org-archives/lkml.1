Return-Path: <linux-kernel-owner+w=401wt.eu-S1764823AbYAUKQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764823AbYAUKQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbYAUKDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981AbYAUKC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:02:58 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 40/58] [GFS2] Only fetch the dinode once in block_map
Date: Mon, 21 Jan 2008 09:21:58 +0000
Message-Id: <12009074103982-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074082286-git-send-email-swhiteho@redhat.com>
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
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
Message-Id: <c5ea4a39fe373c8baa74e7a85942d2b959b8f190.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_block_map was often looking up the disk inode twice.
This optimizes it so that only does it once.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 4948602..2241141 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -469,6 +469,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	unsigned int maxlen = bh_map->b_size >> inode->i_blkbits;
 	struct metapath mp;
 	u64 size;
+	struct buffer_head *dibh = NULL;
 
 	BUG_ON(maxlen == 0);
 
@@ -499,6 +500,8 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	error = gfs2_meta_inode_buffer(ip, &bh);
 	if (error)
 		goto out_fail;
+	dibh = bh;
+	get_bh(dibh);
 
 	for (x = 0; x < end_of_metadata; x++) {
 		lookup_block(ip, bh, x, &mp, create, &new, &dblock);
@@ -517,13 +520,8 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 		if (boundary)
 			set_buffer_boundary(bh_map);
 		if (new) {
-			struct buffer_head *dibh;
-			error = gfs2_meta_inode_buffer(ip, &dibh);
-			if (!error) {
-				gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-				gfs2_dinode_out(ip, dibh->b_data);
-				brelse(dibh);
-			}
+			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+			gfs2_dinode_out(ip, dibh->b_data);
 			set_buffer_new(bh_map);
 			goto out_brelse;
 		}
@@ -544,6 +542,8 @@ out_brelse:
 out_ok:
 	error = 0;
 out_fail:
+	if (dibh)
+		brelse(dibh);
 	bmap_unlock(inode, create);
 	return error;
 }
-- 
1.5.1.2

