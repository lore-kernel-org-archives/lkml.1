Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYIZM4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYIZM4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYIZMya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57606 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbYIZMy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:28 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/12] GFS2: GFS2 will panic if you misspell any mount options
Date: Fri, 26 Sep 2008 13:00:51 +0100
Message-Id: <1222430455-4632-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-6-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-7-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-8-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

The gfs2 superblock pointer is NULL after a failed mount. When control
eventually goes to gfs2_kill_sb, we dereference this NULL pointer. This
patch ensures that the gfs2 superblock pointer is not NULL before being
dereferenced in gfs2_kill_sb.

Signed-off-by:   Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a6225cc..ae35f09 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1237,14 +1237,17 @@ static int gfs2_get_sb_meta(struct file_system_type *fs_type, int flags,
 static void gfs2_kill_sb(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	gfs2_meta_syncfs(sdp);
-	dput(sdp->sd_root_dir);
-	dput(sdp->sd_master_dir);
-	sdp->sd_root_dir = NULL;
-	sdp->sd_master_dir = NULL;
+	if (sdp) {
+		gfs2_meta_syncfs(sdp);
+		dput(sdp->sd_root_dir);
+		dput(sdp->sd_master_dir);
+		sdp->sd_root_dir = NULL;
+		sdp->sd_master_dir = NULL;
+	}
 	shrink_dcache_sb(sb);
 	kill_block_super(sb);
-	gfs2_delete_debugfs_file(sdp);
+	if (sdp)
+		gfs2_delete_debugfs_file(sdp);
 }
 
 struct file_system_type gfs2_fs_type = {
-- 
1.5.5.1

