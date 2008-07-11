Return-Path: <linux-kernel-owner+w=401wt.eu-S1758194AbYGKLIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194AbYGKLIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYGKLCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbYGKLCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:00 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miklos Szeredi <mszeredi@suse.cz>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/18] [GFS2] don't call permission()
Date: Fri, 11 Jul 2008 11:11:14 +0100
Message-Id: <12157711093284-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157711073280-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
 <12157711073280-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>

GFS2 calls permission() to verify permissions after locks on the files
have been taken.

For this it's sufficient to call gfs2_permission() instead.  This
results in the following changes:

  - IS_RDONLY() check is not performed
  - IS_IMMUTABLE() check is not performed
  - devcgroup_inode_permission() is not called
  - security_inode_permission() is not called

IS_RDONLY() should be unnecessary anyway, as the per-mount read-only
flag should provide protection against read-only remounts during
operations.  do_gfs2_set_flags() has been fixed to perform
mnt_want_write()/mnt_drop_write() to protect against remounting
read-only.

IS_IMMUTABLE has been added to gfs2_permission()

Repeating the security checks seems to be pointless, as they don't
normally change, and if they do, it's independent of the filesystem
state.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 09453d0..caf4090 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -504,7 +504,7 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 	}
 
 	if (!is_root) {
-		error = permission(dir, MAY_EXEC, NULL);
+		error = gfs2_permission(dir, MAY_EXEC);
 		if (error)
 			goto out;
 	}
@@ -667,7 +667,7 @@ static int create_ok(struct gfs2_inode *dip, const struct qstr *name,
 {
 	int error;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
@@ -1134,7 +1134,7 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	if (IS_APPEND(&dip->i_inode))
 		return -EPERM;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 580da45..04e9fef 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -91,6 +91,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 		struct gfs2_inode *ip);
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
+int gfs2_permission(struct inode *inode, int mask);
 int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 0ff512a..1737af9 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -15,6 +15,7 @@
 #include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
@@ -220,10 +221,14 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	int error;
 	u32 new_flags, flags;
 
-	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	error = mnt_want_write(filp->f_path.mnt);
 	if (error)
 		return error;
 
+	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	if (error)
+		goto out_drop_write;
+
 	flags = ip->i_di.di_flags;
 	new_flags = (flags & ~mask) | (reqflags & mask);
 	if ((new_flags ^ flags) == 0)
@@ -242,7 +247,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	    !capable(CAP_LINUX_IMMUTABLE))
 		goto out;
 	if (!IS_IMMUTABLE(inode)) {
-		error = permission(inode, MAY_WRITE, NULL);
+		error = gfs2_permission(inode, MAY_WRITE);
 		if (error)
 			goto out;
 	}
@@ -272,6 +277,8 @@ out_trans_end:
 	gfs2_trans_end(sdp);
 out:
 	gfs2_glock_dq_uninit(&gh);
+out_drop_write:
+	mnt_drop_write(filp->f_path.mnt);
 	return error;
 }
 
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 2686ad4..1e252df 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -163,7 +163,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out;
 
-	error = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
 		goto out_gunlock;
 
@@ -669,7 +669,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			}
 		}
 	} else {
-		error = permission(ndir, MAY_WRITE | MAY_EXEC, NULL);
+		error = gfs2_permission(ndir, MAY_WRITE | MAY_EXEC);
 		if (error)
 			goto out_gunlock;
 
@@ -704,7 +704,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	/* Check out the dir to be renamed */
 
 	if (dir_rename) {
-		error = permission(odentry->d_inode, MAY_WRITE, NULL);
+		error = gfs2_permission(odentry->d_inode, MAY_WRITE);
 		if (error)
 			goto out_gunlock;
 	}
@@ -891,7 +891,7 @@ static void *gfs2_follow_link(struct dentry *dentry, struct nameidata *nd)
  * Returns: errno
  */
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int gfs2_permission(struct inode *inode, int mask)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder i_gh;
@@ -905,13 +905,22 @@ static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
 		unlock = 1;
 	}
 
-	error = generic_permission(inode, mask, gfs2_check_acl);
+	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
+		error = -EACCES;
+	else
+		error = generic_permission(inode, mask, gfs2_check_acl);
 	if (unlock)
 		gfs2_glock_dq_uninit(&i_gh);
 
 	return error;
 }
 
+static int gfs2_iop_permission(struct inode *inode, int mask,
+			       struct nameidata *nd)
+{
+	return gfs2_permission(inode, mask);
+}
+
 static int setattr_size(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1141,7 +1150,7 @@ static int gfs2_removexattr(struct dentry *dentry, const char *name)
 }
 
 const struct inode_operations gfs2_file_iops = {
-	.permission = gfs2_permission,
+	.permission = gfs2_iop_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
@@ -1160,7 +1169,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.rmdir = gfs2_rmdir,
 	.mknod = gfs2_mknod,
 	.rename = gfs2_rename,
-	.permission = gfs2_permission,
+	.permission = gfs2_iop_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
@@ -1172,7 +1181,7 @@ const struct inode_operations gfs2_dir_iops = {
 const struct inode_operations gfs2_symlink_iops = {
 	.readlink = gfs2_readlink,
 	.follow_link = gfs2_follow_link,
-	.permission = gfs2_permission,
+	.permission = gfs2_iop_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
 	.setxattr = gfs2_setxattr,
-- 
1.5.1.2

