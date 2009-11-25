Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbZKYNa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbZKYNa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934722AbZKYNa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:30:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964835AbZKYN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:19 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/30] GFS2: Alter arguments of gfs2_quota/statfs_sync
Date: Wed, 25 Nov 2009 14:22:35 +0000
Message-Id: <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two functions are altered so that gfs2_quota_sync may
in future be called directly from the VFS. The GFS2 superblock
changes to a VFS super block and there is an addition of an int
argument which is currently ignored.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |    7 ++++---
 fs/gfs2/quota.h |    2 +-
 fs/gfs2/super.c |    7 ++++---
 fs/gfs2/super.h |    2 +-
 fs/gfs2/sys.c   |    4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 2e9b932..ed9e197 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1069,8 +1069,9 @@ void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 	}
 }
 
-int gfs2_quota_sync(struct gfs2_sbd *sdp)
+int gfs2_quota_sync(struct super_block *sb, int type)
 {
+	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_quota_data **qda;
 	unsigned int max_qd = gfs2_tune_get(sdp, gt_quota_simul_sync);
 	unsigned int num_qd;
@@ -1298,12 +1299,12 @@ static void quotad_error(struct gfs2_sbd *sdp, const char *msg, int error)
 }
 
 static void quotad_check_timeo(struct gfs2_sbd *sdp, const char *msg,
-			       int (*fxn)(struct gfs2_sbd *sdp),
+			       int (*fxn)(struct super_block *sb, int type),
 			       unsigned long t, unsigned long *timeo,
 			       unsigned int *new_timeo)
 {
 	if (t >= *timeo) {
-		int error = fxn(sdp);
+		int error = fxn(sdp->sd_vfs, 0);
 		quotad_error(sdp, msg, error);
 		*timeo = gfs2_tune_get_i(&sdp->sd_tune, new_timeo) * HZ;
 	} else {
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 0fa5fa6..437afa7 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -25,7 +25,7 @@ extern int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid);
 extern void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
 			      u32 uid, u32 gid);
 
-extern int gfs2_quota_sync(struct gfs2_sbd *sdp);
+extern int gfs2_quota_sync(struct super_block *sb, int type);
 extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
 
 extern int gfs2_quota_init(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 42e5458..e7b24d5 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -484,8 +484,9 @@ void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
 	gfs2_statfs_change_out(m_sc, m_bh->b_data + sizeof(struct gfs2_dinode));
 }
 
-int gfs2_statfs_sync(struct gfs2_sbd *sdp)
+int gfs2_statfs_sync(struct super_block *sb, int type)
 {
+	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 	struct gfs2_inode *l_ip = GFS2_I(sdp->sd_sc_inode);
 	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
@@ -712,8 +713,8 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	int error;
 
 	flush_workqueue(gfs2_delete_workqueue);
-	gfs2_quota_sync(sdp);
-	gfs2_statfs_sync(sdp);
+	gfs2_quota_sync(sdp->sd_vfs, 0);
+	gfs2_statfs_sync(sdp->sd_vfs, 0);
 
 	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, GL_NOCACHE,
 				   &t_gh);
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index ed962ea..3df60f2 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -44,7 +44,7 @@ extern void gfs2_statfs_change_in(struct gfs2_statfs_change_host *sc,
 				  const void *buf);
 extern void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
 			  struct buffer_head *l_bh);
-extern int gfs2_statfs_sync(struct gfs2_sbd *sdp);
+extern int gfs2_statfs_sync(struct super_block *sb, int type);
 
 extern int gfs2_freeze_fs(struct gfs2_sbd *sdp);
 extern void gfs2_unfreeze_fs(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 4463297..be1b8ac 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -158,7 +158,7 @@ static ssize_t statfs_sync_store(struct gfs2_sbd *sdp, const char *buf,
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
 
-	gfs2_statfs_sync(sdp);
+	gfs2_statfs_sync(sdp->sd_vfs, 0);
 	return len;
 }
 
@@ -171,7 +171,7 @@ static ssize_t quota_sync_store(struct gfs2_sbd *sdp, const char *buf,
 	if (simple_strtol(buf, NULL, 0) != 1)
 		return -EINVAL;
 
-	gfs2_quota_sync(sdp);
+	gfs2_quota_sync(sdp->sd_vfs, 0);
 	return len;
 }
 
-- 
1.6.2.5

