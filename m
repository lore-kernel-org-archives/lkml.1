Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZIJK3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZIJK3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZIJK3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZIJK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:39 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/15] GFS2: Add online uevent to GFS2
Date: Thu, 10 Sep 2009 12:27:53 +0100
Message-Id: <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have an offline uevent (used when a withdraw occurs)
but no online uevent. This adds an online uevent so that userspace
will be able to detect a successful mount by means other than
not receiving a remove event after the add & recovery (change)
uevents.

It has also been added to the remount path as well - we can't use
a change uevent there as older GFS2 userspace acts on change uevents
according to the state that it thinks the fs is in, so we can't
easily add any new ones.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/ops_fstype.c |   13 ++++++++++++-
 fs/gfs2/super.c      |    1 +
 fs/gfs2/super.h      |    4 ++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 7bc3c45..39021c0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1133,6 +1133,17 @@ void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 		lm->lm_unmount(sdp);
 }
 
+void gfs2_online_uevent(struct gfs2_sbd *sdp)
+{
+	struct super_block *sb = sdp->sd_vfs;
+	char ro[20];
+	char spectator[20];
+	char *envp[] = { ro, spectator, NULL };
+	sprintf(ro, "RDONLY=%d", (sb->s_flags & MS_RDONLY) ? 1 : 0);
+	sprintf(spectator, "SPECTATOR=%d", sdp->sd_args.ar_spectator ? 1 : 0);
+	kobject_uevent_env(&sdp->sd_kobj, KOBJ_ONLINE, envp);
+}
+
 /**
  * fill_super - Read in superblock
  * @sb: The VFS superblock
@@ -1236,7 +1247,7 @@ static int fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	gfs2_glock_dq_uninit(&mount_gh);
-
+	gfs2_online_uevent(sdp);
 	return 0;
 
 fail_threads:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index f522bb0..85bd2bc 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1084,6 +1084,7 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 	gt->gt_log_flush_secs = args.ar_commit;
 	spin_unlock(&gt->gt_spin);
 
+	gfs2_online_uevent(sdp);
 	return 0;
 }
 
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index 22e0417..911c954 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -25,7 +25,7 @@ static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 	return x;
 }
 
-void gfs2_jindex_free(struct gfs2_sbd *sdp);
+extern void gfs2_jindex_free(struct gfs2_sbd *sdp);
 
 extern int gfs2_mount_args(struct gfs2_sbd *sdp, struct gfs2_args *args, char *data);
 
@@ -36,7 +36,7 @@ extern int gfs2_lookup_in_master_dir(struct gfs2_sbd *sdp, char *filename,
 				     struct gfs2_inode **ipp);
 
 extern int gfs2_make_fs_rw(struct gfs2_sbd *sdp);
-
+extern void gfs2_online_uevent(struct gfs2_sbd *sdp);
 extern int gfs2_statfs_init(struct gfs2_sbd *sdp);
 extern void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 			       s64 dinodes);
-- 
1.6.2.5

