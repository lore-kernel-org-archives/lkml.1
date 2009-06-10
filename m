Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZFJJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZFJJmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758797AbZFJJic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbZFJJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/24] GFS2: Move gfs2_rmdiri into ops_inode.c
Date: Wed, 10 Jun 2009 09:30:57 +0100
Message-Id: <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move gfs2_rmdiri() into ops_inode.c and make it static.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c03a1a3..9b17447 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1046,58 +1046,6 @@ fail:
 	return ERR_PTR(error);
 }
 
-/**
- * gfs2_rmdiri - Remove a directory
- * @dip: The parent directory of the directory to be removed
- * @name: The name of the directory to be removed
- * @ip: The GFS2 inode of the directory to be removed
- *
- * Assumes Glocks on dip and ip are held
- *
- * Returns: errno
- */
-
-int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
-		struct gfs2_inode *ip)
-{
-	struct qstr dotname;
-	int error;
-
-	if (ip->i_entries != 2) {
-		if (gfs2_consist_inode(ip))
-			gfs2_dinode_print(ip);
-		return -EIO;
-	}
-
-	error = gfs2_dir_del(dip, name);
-	if (error)
-		return error;
-
-	error = gfs2_change_nlink(dip, -1);
-	if (error)
-		return error;
-
-	gfs2_str2qstr(&dotname, ".");
-	error = gfs2_dir_del(ip, &dotname);
-	if (error)
-		return error;
-
-	gfs2_str2qstr(&dotname, "..");
-	error = gfs2_dir_del(ip, &dotname);
-	if (error)
-		return error;
-
-	/* It looks odd, but it really should be done twice */
-	error = gfs2_change_nlink(ip, -1);
-	if (error)
-		return error;
-
-	error = gfs2_change_nlink(ip, -1);
-	if (error)
-		return error;
-
-	return error;
-}
 
 /*
  * gfs2_unlink_ok - check to see that a inode is still in a directory
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 2c3ec07..6cd3928 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -96,8 +96,6 @@ extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 extern struct inode *gfs2_createi(struct gfs2_holder *ghs,
 				  const struct qstr *name,
 				  unsigned int mode, dev_t dev);
-extern int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
-		       struct gfs2_inode *ip);
 extern int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 			  const struct gfs2_inode *ip);
 extern int gfs2_permission(struct inode *inode, int mask);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 1c70fa5..5dacd64 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -473,6 +473,59 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 }
 
 /**
+ * gfs2_rmdiri - Remove a directory
+ * @dip: The parent directory of the directory to be removed
+ * @name: The name of the directory to be removed
+ * @ip: The GFS2 inode of the directory to be removed
+ *
+ * Assumes Glocks on dip and ip are held
+ *
+ * Returns: errno
+ */
+
+static int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
+		       struct gfs2_inode *ip)
+{
+	struct qstr dotname;
+	int error;
+
+	if (ip->i_entries != 2) {
+		if (gfs2_consist_inode(ip))
+			gfs2_dinode_print(ip);
+		return -EIO;
+	}
+
+	error = gfs2_dir_del(dip, name);
+	if (error)
+		return error;
+
+	error = gfs2_change_nlink(dip, -1);
+	if (error)
+		return error;
+
+	gfs2_str2qstr(&dotname, ".");
+	error = gfs2_dir_del(ip, &dotname);
+	if (error)
+		return error;
+
+	gfs2_str2qstr(&dotname, "..");
+	error = gfs2_dir_del(ip, &dotname);
+	if (error)
+		return error;
+
+	/* It looks odd, but it really should be done twice */
+	error = gfs2_change_nlink(ip, -1);
+	if (error)
+		return error;
+
+	error = gfs2_change_nlink(ip, -1);
+	if (error)
+		return error;
+
+	return error;
+}
+
+/**
  * gfs2_rmdir - Remove a directory
  * @dir: The parent directory of the directory to be removed
  * @dentry: The dentry of the directory to remove
-- 
1.6.0.6

