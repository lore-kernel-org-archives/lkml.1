Return-Path: <linux-kernel-owner+w=401wt.eu-S934417AbYDQJes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417AbYDQJes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765465AbYDQJZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:25:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759578AbYDQJZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:25:14 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/48] [GFS2] Speed up gfs2_write_alloc_required, deprecate gfs2_extent_map
Date: Thu, 17 Apr 2008 09:38:37 +0100
Message-Id: <12084215642582-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: 12084214272083-git-send-email-swhiteho@redhat.com
References: 12084214272083-git-send-email-swhiteho@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch removes the call to gfs2_extent_map from gfs2_write_alloc_required,
instead we call gfs2_block_map directly. This results in fewer overall calls
to gfs2_block_map in the multi-block case.

Also, gfs2_extent_map is marked as deprecated so that people know that its
going away as soon as all the callers have been converted.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e9456eb..a25444a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -548,6 +548,9 @@ out_fail:
 	return error;
 }
 
+/*
+ * Deprecated: do not use in new code
+ */
 int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsigned *extlen)
 {
 	struct buffer_head bh = { .b_state = 0, .b_blocknr = 0 };
@@ -1197,10 +1200,9 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 			      unsigned int len, int *alloc_required)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	u64 lblock, lblock_stop, dblock;
-	u32 extlen;
-	int new = 0;
-	int error = 0;
+	struct buffer_head bh;
+	unsigned int shift;
+	u64 lblock, lblock_stop, size;
 
 	*alloc_required = 0;
 
@@ -1214,6 +1216,8 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 		return 0;
 	}
 
+	*alloc_required = 1;
+	shift = sdp->sd_sb.sb_bsize_shift;
 	if (gfs2_is_dir(ip)) {
 		unsigned int bsize = sdp->sd_jbsize;
 		lblock = offset;
@@ -1221,27 +1225,25 @@ int gfs2_write_alloc_required(struct gfs2_inode *ip, u64 offset,
 		lblock_stop = offset + len + bsize - 1;
 		do_div(lblock_stop, bsize);
 	} else {
-		unsigned int shift = sdp->sd_sb.sb_bsize_shift;
 		u64 end_of_file = (ip->i_di.di_size + sdp->sd_sb.sb_bsize - 1) >> shift;
 		lblock = offset >> shift;
 		lblock_stop = (offset + len + sdp->sd_sb.sb_bsize - 1) >> shift;
-		if (lblock_stop > end_of_file) {
-			*alloc_required = 1;
+		if (lblock_stop > end_of_file)
 			return 0;
-		}
 	}
 
-	for (; lblock < lblock_stop; lblock += extlen) {
-		error = gfs2_extent_map(&ip->i_inode, lblock, &new, &dblock, &extlen);
-		if (error)
-			return error;
-
-		if (!dblock) {
-			*alloc_required = 1;
+	size = (lblock_stop - lblock) << shift;
+	do {
+		bh.b_state = 0;
+		bh.b_size = size;
+		gfs2_block_map(&ip->i_inode, lblock, &bh, 0);
+		if (!buffer_mapped(&bh))
 			return 0;
-		}
-	}
+		size -= bh.b_size;
+		lblock += (bh.b_size >> ip->i_inode.i_blkbits);
+	} while(size > 0);
 
+	*alloc_required = 0;
 	return 0;
 }
 
-- 
1.5.1.2

