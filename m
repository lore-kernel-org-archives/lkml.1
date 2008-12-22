Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYLVWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYLVWHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbYLVVuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:21 -0500
Received: from mail.suse.de ([195.135.220.2]:41775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYLVVuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:19 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 51/56] ocfs2: Start using buckets in ocfs2_adjust_xattr_cross_cluster().
Date: Mon, 22 Dec 2008 13:48:32 -0800
Message-Id: <1229982517-3455-52-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

We want to be passing around buckets instead of buffer_heads.  Let's get
them into ocfs2_adjust_xattr_cross_cluster.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index c318928..975ba36 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4111,28 +4111,54 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 					    u32 *v_start,
 					    int *extend)
 {
-	int ret = 0;
-	int bpc = ocfs2_clusters_to_blocks(inode->i_sb, 1);
+	int ret;
+	struct ocfs2_xattr_bucket *first, *target;
 
 	mlog(0, "adjust xattrs from cluster %llu len %u to %llu\n",
 	     (unsigned long long)prev_blk, prev_clusters,
 	     (unsigned long long)new_blk);
 
+	/* The first bucket of the original extent */
+	first = ocfs2_xattr_bucket_new(inode);
+	/* The target bucket for insert */
+	target = ocfs2_xattr_bucket_new(inode);
+	if (!first || !target) {
+		ret = -ENOMEM;
+		mlog_errno(ret);
+		goto out;
+	}
+
+	BUG_ON(prev_blk != (*first_bh)->b_blocknr);
+	ret = ocfs2_read_xattr_bucket(first, prev_blk);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
+	ret = ocfs2_read_xattr_bucket(target, (*header_bh)->b_blocknr);
+	if (ret) {
+		mlog_errno(ret);
+		goto out;
+	}
+
 	if (ocfs2_xattr_buckets_per_cluster(OCFS2_SB(inode->i_sb)) > 1)
 		ret = ocfs2_mv_xattr_bucket_cross_cluster(inode,
 							  handle,
 							  first_bh,
 							  header_bh,
 							  new_blk,
-							  prev_blk,
+							  bucket_blkno(first),
 							  prev_clusters,
 							  v_start);
 	else {
-		u64 last_blk = prev_blk + bpc * (prev_clusters - 1);
+		/* The start of the last cluster in the first extent */
+		u64 last_blk = bucket_blkno(first) +
+			((prev_clusters - 1) *
+			 ocfs2_clusters_to_blocks(inode->i_sb, 1));
 
-		if (prev_clusters > 1 && (*header_bh)->b_blocknr != last_blk)
+		if (prev_clusters > 1 && bucket_blkno(target) != last_blk)
 			ret = ocfs2_mv_xattr_buckets(inode, handle,
-						     (*first_bh)->b_blocknr,
+						     bucket_blkno(first),
 						     last_blk, new_blk, 0,
 						     v_start);
 		else {
@@ -4140,11 +4166,15 @@ static int ocfs2_adjust_xattr_cross_cluster(struct inode *inode,
 							 last_blk, new_blk,
 							 v_start);
 
-			if ((*header_bh)->b_blocknr == last_blk && extend)
+			if ((bucket_blkno(target) == last_blk) && extend)
 				*extend = 0;
 		}
 	}
 
+out:
+	ocfs2_xattr_bucket_free(first);
+	ocfs2_xattr_bucket_free(target);
+
 	return ret;
 }
 
-- 
1.5.6

