Return-Path: <linux-kernel-owner+w=401wt.eu-S936006AbYEURSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936006AbYEURSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933436AbYEURPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:15:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33056 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398AbYEURPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:15:52 -0400
Message-Id: <20080521171546.697638614@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:02 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [patch 04/14] gfs2: dont call permission()
Content-Disposition: inline; filename=gfs2_permission_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

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

IS_IMMUTABLE has beed added to gfs2_do_permission()

Repeating the security checks seems to be pointless, as they don't
normally change, and if they do, it's independent of the filesystem
state.

I also suspect the conditional locking in gfs2_do_permission() could
be cleaned up, due to the removal of the implicit recursion.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/inode.c     |    6 +++---
 fs/gfs2/inode.h     |    1 +
 fs/gfs2/ops_file.c  |   11 +++++++++--
 fs/gfs2/ops_inode.c |   18 +++++++++++++-----
 4 files changed, 26 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/gfs2/inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/inode.c	2008-05-21 15:45:11.000000000 +0200
+++ linux-2.6/fs/gfs2/inode.c	2008-05-21 15:45:45.000000000 +0200
@@ -504,7 +504,7 @@ struct inode *gfs2_lookupi(struct inode 
 	}
 
 	if (!is_root) {
-		error = permission(dir, MAY_EXEC, NULL);
+		error = gfs2_do_permission(dir, MAY_EXEC);
 		if (error)
 			goto out;
 	}
@@ -667,7 +667,7 @@ static int create_ok(struct gfs2_inode *
 {
 	int error;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
@@ -1134,7 +1134,7 @@ int gfs2_unlink_ok(struct gfs2_inode *di
 	if (IS_APPEND(&dip->i_inode))
 		return -EPERM;
 
-	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
 	if (error)
 		return error;
 
Index: linux-2.6/fs/gfs2/inode.h
===================================================================
--- linux-2.6.orig/fs/gfs2/inode.h	2008-05-21 15:45:11.000000000 +0200
+++ linux-2.6/fs/gfs2/inode.h	2008-05-21 15:45:45.000000000 +0200
@@ -91,6 +91,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, 
 		struct gfs2_inode *ip);
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
+int gfs2_do_permission(struct inode *inode, int mask);
 int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
Index: linux-2.6/fs/gfs2/ops_file.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_file.c	2008-05-21 15:45:11.000000000 +0200
+++ linux-2.6/fs/gfs2/ops_file.c	2008-05-21 15:45:45.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/uio.h>
 #include <linux/blkdev.h>
 #include <linux/mm.h>
+#include <linux/mount.h>
 #include <linux/fs.h>
 #include <linux/gfs2_ondisk.h>
 #include <linux/ext2_fs.h>
@@ -220,10 +221,14 @@ static int do_gfs2_set_flags(struct file
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
@@ -242,7 +247,7 @@ static int do_gfs2_set_flags(struct file
 	    !capable(CAP_LINUX_IMMUTABLE))
 		goto out;
 	if (!IS_IMMUTABLE(inode)) {
-		error = permission(inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(inode, MAY_WRITE);
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
 
Index: linux-2.6/fs/gfs2/ops_inode.c
===================================================================
--- linux-2.6.orig/fs/gfs2/ops_inode.c	2008-05-21 15:45:11.000000000 +0200
+++ linux-2.6/fs/gfs2/ops_inode.c	2008-05-21 15:55:15.000000000 +0200
@@ -163,7 +163,7 @@ static int gfs2_link(struct dentry *old_
 	if (error)
 		goto out;
 
-	error = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
+	error = gfs2_do_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
 		goto out_gunlock;
 
@@ -669,7 +669,7 @@ static int gfs2_rename(struct inode *odi
 			}
 		}
 	} else {
-		error = permission(ndir, MAY_WRITE | MAY_EXEC, NULL);
+		error = gfs2_do_permission(ndir, MAY_WRITE | MAY_EXEC);
 		if (error)
 			goto out_gunlock;
 
@@ -704,7 +704,7 @@ static int gfs2_rename(struct inode *odi
 	/* Check out the dir to be renamed */
 
 	if (dir_rename) {
-		error = permission(odentry->d_inode, MAY_WRITE, NULL);
+		error = gfs2_do_permission(odentry->d_inode, MAY_WRITE);
 		if (error)
 			goto out_gunlock;
 	}
@@ -891,7 +891,7 @@ static void *gfs2_follow_link(struct den
  * Returns: errno
  */
 
-static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+int gfs2_do_permission(struct inode *inode, int mask)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder i_gh;
@@ -905,13 +905,21 @@ static int gfs2_permission(struct inode 
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
 
+static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	return gfs2_do_permission(inode, mask);
+}
+
 static int setattr_size(struct inode *inode, struct iattr *attr)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);

--
