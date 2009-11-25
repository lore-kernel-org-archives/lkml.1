Return-Path: <linux-kernel-owner+w=401wt.eu-S964842AbZKYN2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842AbZKYN2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbZKYN2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964803AbZKYN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:13 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/30] GFS2: Use gfs2_set_mode() instead of munge_mode()
Date: Wed, 25 Nov 2009 14:22:31 +0000
Message-Id: <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions do the same thing, so lets only use
one of them.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/acl.c |   46 +++++++++++-----------------------------------
 1 files changed, 11 insertions(+), 35 deletions(-)

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 2168da1..1be3148 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -104,29 +104,20 @@ int gfs2_check_acl(struct inode *inode, int mask)
 	return -EAGAIN;
 }
 
-static int munge_mode(struct gfs2_inode *ip, mode_t mode)
+static int gfs2_set_mode(struct inode *inode, mode_t mode)
 {
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct buffer_head *dibh;
-	int error;
+	int error = 0;
 
-	error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		return error;
+	if (mode != inode->i_mode) {
+		struct iattr iattr;
 
-	error = gfs2_meta_inode_buffer(ip, &dibh);
-	if (!error) {
-		gfs2_assert_withdraw(sdp,
-				(ip->i_inode.i_mode & S_IFMT) == (mode & S_IFMT));
-		ip->i_inode.i_mode = mode;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-		gfs2_dinode_out(ip, dibh->b_data);
-		brelse(dibh);
-	}
+		iattr.ia_valid = ATTR_MODE;
+		iattr.ia_mode = mode;
 
-	gfs2_trans_end(sdp);
+		error = gfs2_setattr_simple(GFS2_I(inode), &iattr);
+	}
 
-	return 0;
+	return error;
 }
 
 int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
@@ -151,7 +142,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	if (!acl) {
 		mode &= ~current_umask();
 		if (mode != ip->i_inode.i_mode)
-			error = munge_mode(ip, mode);
+			error = gfs2_set_mode(&ip->i_inode, mode);
 		return error;
 	}
 
@@ -181,7 +172,7 @@ int gfs2_acl_create(struct gfs2_inode *dip, struct gfs2_inode *ip)
 	if (error)
 		goto out;
 munge:
-	error = munge_mode(ip, mode);
+	error = gfs2_set_mode(&ip->i_inode, mode);
 out:
 	posix_acl_release(acl);
 	kfree(data);
@@ -244,21 +235,6 @@ static int gfs2_xattr_system_get(struct inode *inode, const char *name,
 	return gfs2_xattr_get(inode, GFS2_EATYPE_SYS, name, buffer, size);
 }
 
-static int gfs2_set_mode(struct inode *inode, mode_t mode)
-{
-	int error = 0;
-
-	if (mode != inode->i_mode) {
-		struct iattr iattr;
-
-		iattr.ia_valid = ATTR_MODE;
-		iattr.ia_mode = mode;
-
-		error = gfs2_setattr_simple(GFS2_I(inode), &iattr);
-	}
-
-	return error;
-}
 
 static int gfs2_xattr_system_set(struct inode *inode, const char *name,
 				 const void *value, size_t size, int flags)
-- 
1.6.2.5

