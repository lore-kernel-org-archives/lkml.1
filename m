Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026Ab0AKJQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab0AKJQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961Ab0AKJQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0AKJPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:15:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Fix gfs2_xattr_acl_chmod()
Date: Mon, 11 Jan 2010 09:11:39 +0000
Message-Id: <1263201100-6904-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1263201100-6904-3-git-send-email-swhiteho@redhat.com>
References: <1263201100-6904-1-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-2-git-send-email-swhiteho@redhat.com>
 <1263201100-6904-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ref counting for the bh returned by gfs2_ea_find() was
wrong. This patch ensures that we always drop the ref count
to that bh correctly.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/xattr.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 8a04108..c2ebdf2 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1296,6 +1296,7 @@ fail:
 
 int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 {
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_ea_location el;
 	struct buffer_head *dibh;
 	int error;
@@ -1305,16 +1306,17 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 		return error;
 
 	if (GFS2_EA_IS_STUFFED(el.el_ea)) {
-		error = gfs2_trans_begin(GFS2_SB(&ip->i_inode), RES_DINODE + RES_EATTR, 0);
-		if (error)
-			return error;
-
-		gfs2_trans_add_bh(ip->i_gl, el.el_bh, 1);
-		memcpy(GFS2_EA2DATA(el.el_ea), data,
-		       GFS2_EA_DATA_LEN(el.el_ea));
-	} else
+		error = gfs2_trans_begin(sdp, RES_DINODE + RES_EATTR, 0);
+		if (error == 0) {
+			gfs2_trans_add_bh(ip->i_gl, el.el_bh, 1);
+			memcpy(GFS2_EA2DATA(el.el_ea), data,
+			       GFS2_EA_DATA_LEN(el.el_ea));
+		}
+	} else {
 		error = ea_acl_chmod_unstuffed(ip, el.el_ea, data);
+	}
 
+	brelse(el.el_bh);
 	if (error)
 		return error;
 
@@ -1327,8 +1329,7 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 		brelse(dibh);
 	}
 
-	gfs2_trans_end(GFS2_SB(&ip->i_inode));
-
+	gfs2_trans_end(sdp);
 	return error;
 }
 
-- 
1.6.2.5

