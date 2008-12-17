Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759361AbYLQMgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbYLQMgf (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYLQM3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53749 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbYLQM31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:27 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/24] GFS2: Fix bug in gfs2_lock_fs_check_clean()
Date: Wed, 17 Dec 2008 11:30:18 +0000
Message-Id: <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
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
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

gfs2_lock_fs_check_clean() should not be calling gfs2_jindex_hold()
since it doesn't work like rindex hold, despite the comment. That
allows gfs2_jindex_hold() to be moved into ops_fstype.c where it
can be made static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.h b/fs/gfs2/dir.h
index 8a468ca..4f91944 100644
--- a/fs/gfs2/dir.h
+++ b/fs/gfs2/dir.h
@@ -11,6 +11,7 @@
 #define __DIR_DOT_H__
 
 #include <linux/dcache.h>
+#include <linux/crc32.h>
 
 struct inode;
 struct gfs2_inode;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index fc300ea..4cae60f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -33,6 +33,7 @@
 #include "util.h"
 #include "log.h"
 #include "quota.h"
+#include "dir.h"
 
 #define DO 0
 #define UNDO 1
@@ -638,6 +639,72 @@ static void gfs2_lm_others_may_mount(struct gfs2_sbd *sdp)
 					sdp->sd_lockstruct.ls_lockspace);
 }
 
+/**
+ * gfs2_jindex_hold - Grab a lock on the jindex
+ * @sdp: The GFS2 superblock
+ * @ji_gh: the holder for the jindex glock
+ *
+ * Returns: errno
+ */
+
+static int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
+{
+	struct gfs2_inode *dip = GFS2_I(sdp->sd_jindex);
+	struct qstr name;
+	char buf[20];
+	struct gfs2_jdesc *jd;
+	int error;
+
+	name.name = buf;
+
+	mutex_lock(&sdp->sd_jindex_mutex);
+
+	for (;;) {
+		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, ji_gh);
+		if (error)
+			break;
+
+		name.len = sprintf(buf, "journal%u", sdp->sd_journals);
+		name.hash = gfs2_disk_hash(name.name, name.len);
+
+		error = gfs2_dir_check(sdp->sd_jindex, &name, NULL);
+		if (error == -ENOENT) {
+			error = 0;
+			break;
+		}
+
+		gfs2_glock_dq_uninit(ji_gh);
+
+		if (error)
+			break;
+
+		error = -ENOMEM;
+		jd = kzalloc(sizeof(struct gfs2_jdesc), GFP_KERNEL);
+		if (!jd)
+			break;
+
+		INIT_LIST_HEAD(&jd->extent_list);
+		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
+		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
+			if (!jd->jd_inode)
+				error = -ENOENT;
+			else
+				error = PTR_ERR(jd->jd_inode);
+			kfree(jd);
+			break;
+		}
+
+		spin_lock(&sdp->sd_jindex_spin);
+		jd->jd_jid = sdp->sd_journals++;
+		list_add_tail(&jd->jd_list, &sdp->sd_jindex_list);
+		spin_unlock(&sdp->sd_jindex_spin);
+	}
+
+	mutex_unlock(&sdp->sd_jindex_mutex);
+
+	return error;
+}
+
 static int init_journal(struct gfs2_sbd *sdp, int undo)
 {
 	struct inode *master = sdp->sd_master_dir->d_inode;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b858770..3dd9f57 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -34,76 +34,6 @@
 #include "util.h"
 
 /**
- * gfs2_jindex_hold - Grab a lock on the jindex
- * @sdp: The GFS2 superblock
- * @ji_gh: the holder for the jindex glock
- *
- * This is very similar to the gfs2_rindex_hold() function, except that
- * in general we hold the jindex lock for longer periods of time and
- * we grab it far less frequently (in general) then the rgrp lock.
- *
- * Returns: errno
- */
-
-int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh)
-{
-	struct gfs2_inode *dip = GFS2_I(sdp->sd_jindex);
-	struct qstr name;
-	char buf[20];
-	struct gfs2_jdesc *jd;
-	int error;
-
-	name.name = buf;
-
-	mutex_lock(&sdp->sd_jindex_mutex);
-
-	for (;;) {
-		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, ji_gh);
-		if (error)
-			break;
-
-		name.len = sprintf(buf, "journal%u", sdp->sd_journals);
-		name.hash = gfs2_disk_hash(name.name, name.len);
-
-		error = gfs2_dir_check(sdp->sd_jindex, &name, NULL);
-		if (error == -ENOENT) {
-			error = 0;
-			break;
-		}
-
-		gfs2_glock_dq_uninit(ji_gh);
-
-		if (error)
-			break;
-
-		error = -ENOMEM;
-		jd = kzalloc(sizeof(struct gfs2_jdesc), GFP_KERNEL);
-		if (!jd)
-			break;
-
-		INIT_LIST_HEAD(&jd->extent_list);
-		jd->jd_inode = gfs2_lookupi(sdp->sd_jindex, &name, 1);
-		if (!jd->jd_inode || IS_ERR(jd->jd_inode)) {
-			if (!jd->jd_inode)
-				error = -ENOENT;
-			else
-				error = PTR_ERR(jd->jd_inode);
-			kfree(jd);
-			break;
-		}
-
-		spin_lock(&sdp->sd_jindex_spin);
-		jd->jd_jid = sdp->sd_journals++;
-		list_add_tail(&jd->jd_list, &sdp->sd_jindex_list);
-		spin_unlock(&sdp->sd_jindex_spin);
-	}
-
-	mutex_unlock(&sdp->sd_jindex_mutex);
-
-	return error;
-}
-
-/**
  * gfs2_jindex_free - Clear all the journal index information
  * @sdp: The GFS2 superblock
  *
@@ -580,10 +510,6 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp,
 	struct gfs2_log_header_host lh;
 	int error;
 
-	error = gfs2_jindex_hold(sdp, &ji_gh);
-	if (error)
-		return error;
-
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		lfcc = kmalloc(sizeof(struct lfcc), GFP_KERNEL);
 		if (!lfcc) {
diff --git a/fs/gfs2/super.h b/fs/gfs2/super.h
index 1848dad..c625459 100644
--- a/fs/gfs2/super.h
+++ b/fs/gfs2/super.h
@@ -25,7 +25,6 @@ static inline unsigned int gfs2_jindex_size(struct gfs2_sbd *sdp)
 	return x;
 }
 
-int gfs2_jindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ji_gh);
 void gfs2_jindex_free(struct gfs2_sbd *sdp);
 
 struct gfs2_jdesc *gfs2_jdesc_find(struct gfs2_sbd *sdp, unsigned int jid);
-- 
1.6.0.3

