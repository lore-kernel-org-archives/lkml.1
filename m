Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751561AbYLQMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbYLQMeo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYLQM32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53745 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754893AbYLQM3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:23 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/24] GFS2: Move gfs2_recoverd into recovery.c
Date: Wed, 17 Dec 2008 11:30:15 +0000
Message-Id: <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

By moving gfs2_recoverd, we can make an additional function static
and it also leaves only (the already scheduled for removal) gfs2_glockd
in daemon.c.

At the same time the declaration of gfs2_quotad is moved to quota.h
to reflect the new location of gfs2_quotad in a previous patch. Also
the recovery.h and quota.h headers are cleaned up.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/daemon.c b/fs/gfs2/daemon.c
index 5668aa7..2662df0 100644
--- a/fs/gfs2/daemon.c
+++ b/fs/gfs2/daemon.c
@@ -59,25 +59,3 @@ int gfs2_glockd(void *data)
 	return 0;
 }
 
-/**
- * gfs2_recoverd - Recover dead machine's journals
- * @sdp: Pointer to GFS2 superblock
- *
- */
-
-int gfs2_recoverd(void *data)
-{
-	struct gfs2_sbd *sdp = data;
-	unsigned long t;
-
-	while (!kthread_should_stop()) {
-		gfs2_check_journals(sdp);
-		t = gfs2_tune_get(sdp,  gt_recoverd_secs) * HZ;
-		if (freezing(current))
-			refrigerator();
-		schedule_timeout_interruptible(t);
-	}
-
-	return 0;
-}
-
diff --git a/fs/gfs2/daemon.h b/fs/gfs2/daemon.h
index 4be084f..5258954 100644
--- a/fs/gfs2/daemon.h
+++ b/fs/gfs2/daemon.h
@@ -11,7 +11,5 @@
 #define __DAEMON_DOT_H__
 
 int gfs2_glockd(void *data);
-int gfs2_recoverd(void *data);
-int gfs2_quotad(void *data);
 
 #endif /* __DAEMON_DOT_H__ */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index a9a8380..d159e7e 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -33,6 +33,7 @@
 #include "sys.h"
 #include "util.h"
 #include "log.h"
+#include "quota.h"
 
 #define DO 0
 #define UNDO 1
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index 1d08aee..cec9032 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -15,21 +15,22 @@ struct gfs2_sbd;
 
 #define NO_QUOTA_CHANGE ((u32)-1)
 
-int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid);
-void gfs2_quota_unhold(struct gfs2_inode *ip);
+extern int gfs2_quota_hold(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern void gfs2_quota_unhold(struct gfs2_inode *ip);
 
-int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid);
-void gfs2_quota_unlock(struct gfs2_inode *ip);
+extern int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern void gfs2_quota_unlock(struct gfs2_inode *ip);
 
-int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid);
-void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
-		       u32 uid, u32 gid);
+extern int gfs2_quota_check(struct gfs2_inode *ip, u32 uid, u32 gid);
+extern void gfs2_quota_change(struct gfs2_inode *ip, s64 change,
+			      u32 uid, u32 gid);
 
-int gfs2_quota_sync(struct gfs2_sbd *sdp);
-int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
+extern int gfs2_quota_sync(struct gfs2_sbd *sdp);
+extern int gfs2_quota_refresh(struct gfs2_sbd *sdp, int user, u32 id);
 
-int gfs2_quota_init(struct gfs2_sbd *sdp);
-void gfs2_quota_cleanup(struct gfs2_sbd *sdp);
+extern int gfs2_quota_init(struct gfs2_sbd *sdp);
+extern void gfs2_quota_cleanup(struct gfs2_sbd *sdp);
+extern int gfs2_quotad(void *data);
 
 static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
 {
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index d5e91f4..b56ba3d 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -14,6 +14,8 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/lm_interface.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -589,7 +591,7 @@ fail:
  *
  */
 
-void gfs2_check_journals(struct gfs2_sbd *sdp)
+static void gfs2_check_journals(struct gfs2_sbd *sdp)
 {
 	struct gfs2_jdesc *jd;
 
@@ -603,3 +605,25 @@ void gfs2_check_journals(struct gfs2_sbd *sdp)
 	}
 }
 
+/**
+ * gfs2_recoverd - Recover dead machine's journals
+ * @sdp: Pointer to GFS2 superblock
+ *
+ */
+
+int gfs2_recoverd(void *data)
+{
+	struct gfs2_sbd *sdp = data;
+	unsigned long t;
+
+	while (!kthread_should_stop()) {
+		gfs2_check_journals(sdp);
+		t = gfs2_tune_get(sdp,  gt_recoverd_secs) * HZ;
+		if (freezing(current))
+			refrigerator();
+		schedule_timeout_interruptible(t);
+	}
+
+	return 0;
+}
+
diff --git a/fs/gfs2/recovery.h b/fs/gfs2/recovery.h
index f7235e6..a8218ea 100644
--- a/fs/gfs2/recovery.h
+++ b/fs/gfs2/recovery.h
@@ -18,17 +18,17 @@ static inline void gfs2_replay_incr_blk(struct gfs2_sbd *sdp, unsigned int *blk)
 	        *blk = 0;
 }
 
-int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
+extern int gfs2_replay_read_block(struct gfs2_jdesc *jd, unsigned int blk,
 			   struct buffer_head **bh);
 
-int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
-int gfs2_revoke_check(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
-void gfs2_revoke_clean(struct gfs2_sbd *sdp);
+extern int gfs2_revoke_add(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
+extern int gfs2_revoke_check(struct gfs2_sbd *sdp, u64 blkno, unsigned int where);
+extern void gfs2_revoke_clean(struct gfs2_sbd *sdp);
 
-int gfs2_find_jhead(struct gfs2_jdesc *jd,
+extern int gfs2_find_jhead(struct gfs2_jdesc *jd,
 		    struct gfs2_log_header_host *head);
-int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
-void gfs2_check_journals(struct gfs2_sbd *sdp);
+extern int gfs2_recover_journal(struct gfs2_jdesc *gfs2_jd);
+extern int gfs2_recoverd(void *data);
 
 #endif /* __RECOVERY_DOT_H__ */
 
-- 
1.6.0.3

