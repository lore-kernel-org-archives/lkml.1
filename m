Return-Path: <linux-kernel-owner+w=401wt.eu-S934759AbZKYNhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759AbZKYNhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934744AbZKYNhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:37:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934733AbZKYNgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:36:22 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/30] FS2: Remove dirent_first() function
Date: Wed, 25 Nov 2009 14:30:58 +0000
Message-Id: <1259159462-28622-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-1-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-2-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-3-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-4-git-send-email-swhiteho@redhat.com>
 <1259159462-28622-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function only had one caller left, and that caller only
called it for leaf blocks, hence one branch of the "if" was
never taken. In addition the call to get_left had already
verified the metadata type, so the function can be reduced
to a single line of code in its caller.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/dir.c |   34 +---------------------------------
 1 files changed, 1 insertions(+), 33 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 297d7e5..25fddc1 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -525,38 +525,6 @@ consist_inode:
 	return ERR_PTR(-EIO);
 }
 
-
-/**
- * dirent_first - Return the first dirent
- * @dip: the directory
- * @bh: The buffer
- * @dent: Pointer to list of dirents
- *
- * return first dirent whether bh points to leaf or stuffed dinode
- *
- * Returns: IS_LEAF, IS_DINODE, or -errno
- */
-
-static int dirent_first(struct gfs2_inode *dip, struct buffer_head *bh,
-			struct gfs2_dirent **dent)
-{
-	struct gfs2_meta_header *h = (struct gfs2_meta_header *)bh->b_data;
-
-	if (be32_to_cpu(h->mh_type) == GFS2_METATYPE_LF) {
-		if (gfs2_meta_check(GFS2_SB(&dip->i_inode), bh))
-			return -EIO;
-		*dent = (struct gfs2_dirent *)(bh->b_data +
-					       sizeof(struct gfs2_leaf));
-		return IS_LEAF;
-	} else {
-		if (gfs2_metatype_check(GFS2_SB(&dip->i_inode), bh, GFS2_METATYPE_DI))
-			return -EIO;
-		*dent = (struct gfs2_dirent *)(bh->b_data +
-					       sizeof(struct gfs2_dinode));
-		return IS_DINODE;
-	}
-}
-
 static int dirent_check_reclen(struct gfs2_inode *dip,
 			       const struct gfs2_dirent *d, const void *end_p)
 {
@@ -1006,7 +974,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	divider = (start + half_len) << (32 - dip->i_depth);
 
 	/*  Copy the entries  */
-	dirent_first(dip, obh, &dent);
+	dent = (struct gfs2_dirent *)(obh->b_data + sizeof(struct gfs2_leaf));
 
 	do {
 		next = dent;
-- 
1.6.2.5

