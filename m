Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZFJJmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZFJJmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZFJJif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40327 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644AbZFJJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/24] GFS2: Move gfs2_unlink_ok into ops_inode.c
Date: Wed, 10 Jun 2009 09:30:59 +0100
Message-Id: <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another function which is only called from one ops_inode.c so
we move it and make it static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 676e750..2f94bd7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1046,45 +1046,6 @@ fail:
 	return ERR_PTR(error);
 }
 
-
-/*
- * gfs2_unlink_ok - check to see that a inode is still in a directory
- * @dip: the directory
- * @name: the name of the file
- * @ip: the inode
- *
- * Assumes that the lock on (at least) @dip is held.
- *
- * Returns: 0 if the parent/child relationship is correct, errno if it isn't
- */
-
-int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
-		   const struct gfs2_inode *ip)
-{
-	int error;
-
-	if (IS_IMMUTABLE(&ip->i_inode) || IS_APPEND(&ip->i_inode))
-		return -EPERM;
-
-	if ((dip->i_inode.i_mode & S_ISVTX) &&
-	    dip->i_inode.i_uid != current_fsuid() &&
-	    ip->i_inode.i_uid != current_fsuid() && !capable(CAP_FOWNER))
-		return -EPERM;
-
-	if (IS_APPEND(&dip->i_inode))
-		return -EPERM;
-
-	error = gfs2_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
-	if (error)
-		return error;
-
-	error = gfs2_dir_check(&dip->i_inode, name, ip);
-	if (error)
-		return error;
-
-	return 0;
-}
-
 static int __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
 {
 	struct buffer_head *dibh;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index fc9a08f..c341aaf 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -96,8 +96,6 @@ extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
 				  const struct qstr *name,
 				  unsigned int mode, dev_t dev);
-extern int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
-			  const struct gfs2_inode *ip);
 extern int gfs2_permission(struct inode *inode, int mask);
 extern int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index f607f09..f8bd20b 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -262,6 +262,44 @@ out_parent:
 	return error;
 }
 
+/*
+ * gfs2_unlink_ok - check to see that a inode is still in a directory
+ * @dip: the directory
+ * @name: the name of the file
+ * @ip: the inode
+ *
+ * Assumes that the lock on (at least) @dip is held.
+ *
+ * Returns: 0 if the parent/child relationship is correct, errno if it isn't
+ */
+
+static int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
+			  const struct gfs2_inode *ip)
+{
+	int error;
+
+	if (IS_IMMUTABLE(&ip->i_inode) || IS_APPEND(&ip->i_inode))
+		return -EPERM;
+
+	if ((dip->i_inode.i_mode & S_ISVTX) &&
+	    dip->i_inode.i_uid != current_fsuid() &&
+	    ip->i_inode.i_uid != current_fsuid() && !capable(CAP_FOWNER))
+		return -EPERM;
+
+	if (IS_APPEND(&dip->i_inode))
+		return -EPERM;
+
+	error = gfs2_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
+	if (error)
+		return error;
+
+	error = gfs2_dir_check(&dip->i_inode, name, ip);
+	if (error)
+		return error;
+
+	return 0;
+}
+
 /**
  * gfs2_unlink - Unlink a file
  * @dir: The inode of the directory containing the file to unlink
-- 
1.6.0.6

