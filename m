Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXBEOVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXBEOVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBEOVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:21:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812AbXBEOVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:21:24 -0500
Subject: [GFS2] make gfs2_change_nlink_i() static [22/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:27:27 +0000
Message-Id: <1170685647.11001.315.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5c98f86d6ac69688a53e96f294a1b7a8e33c6070 Mon Sep 17 00:00:00 2001
From: Adrian Bunk <bunk@stusta.de>
Date: Sat, 13 Jan 2007 10:56:41 +0100
Subject: [PATCH] [GFS2] make gfs2_change_nlink_i() static

On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc3-mm1:
>...
>  git-gfs2-nmw.patch
>...
>  git trees
>...

This patch makes the needlessly globlal gfs2_change_nlink_i() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 58c2ce7..2603169 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -280,6 +280,50 @@ out:
 	return error;
 }
 
+static int gfs2_change_nlink_i(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
+	struct gfs2_inode *rindex = GFS2_I(sdp->sd_rindex);
+	struct gfs2_glock *ri_gl = rindex->i_gl;
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder ri_gh, rg_gh;
+	int existing, error;
+
+	/* if we come from rename path, we could have the lock already */
+	existing = gfs2_glock_is_locked_by_me(ri_gl);
+	if (!existing) {
+		error = gfs2_rindex_hold(sdp, &ri_gh);
+		if (error)
+			goto out;
+	}
+
+	/* find the matching rgd */
+	error = -EIO;
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	if (!rgd)
+		goto out_norgrp;
+
+	/*
+	 * Eventually we may want to move rgd(s) to a linked list
+	 * and piggyback the free logic into one of gfs2 daemons
+	 * to gain some performance.
+	 */
+	if (!rgd->rd_gl || !gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
+		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &rg_gh);
+		if (error)
+			goto out_norgrp;
+
+		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
+		gfs2_glock_dq_uninit(&rg_gh);
+	}
+
+out_norgrp:
+	if (!existing)
+		gfs2_glock_dq_uninit(&ri_gh);
+out:
+	return error;
+}
+
 /**
  * gfs2_change_nlink - Change nlink count on inode
  * @ip: The GFS2 inode
@@ -326,50 +370,6 @@ int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
 	return error;
 }
 
-int gfs2_change_nlink_i(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
-	struct gfs2_inode *rindex = GFS2_I(sdp->sd_rindex);
-	struct gfs2_glock *ri_gl = rindex->i_gl;
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder ri_gh, rg_gh;
-	int existing, error;
-
-	/* if we come from rename path, we could have the lock already */
-	existing = gfs2_glock_is_locked_by_me(ri_gl);
-	if (!existing) {
-		error = gfs2_rindex_hold(sdp, &ri_gh);
-		if (error)
-			goto out;
-	}
-
-	/* find the matching rgd */
-	error = -EIO;
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
-	if (!rgd)
-		goto out_norgrp;
-
-	/*
-	 * Eventually we may want to move rgd(s) to a linked list
-	 * and piggyback the free logic into one of gfs2 daemons
-	 * to gain some performance.
-	 */
-	if (!rgd->rd_gl || !gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
-		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &rg_gh);
-		if (error)
-			goto out_norgrp;
-
-		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
-		gfs2_glock_dq_uninit(&rg_gh);
-	}
-
-out_norgrp:
-	if (!existing)
-		gfs2_glock_dq_uninit(&ri_gh);
-out:
-	return error;
-}
-
 struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
 {
 	struct qstr qstr;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index cee281b..b57f448 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -40,7 +40,6 @@ int gfs2_inode_refresh(struct gfs2_inode *ip);
 
 int gfs2_dinode_dealloc(struct gfs2_inode *inode);
 int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
-int gfs2_change_nlink_i(struct gfs2_inode *ip);
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			   int is_root, struct nameidata *nd);
 struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
-- 
1.4.4.2



