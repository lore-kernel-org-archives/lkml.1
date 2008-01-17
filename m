Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYAQMoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYAQMoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYAQMoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:44:13 -0500
Received: from bde.crans.org ([138.231.137.76]:58726 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYAQMoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:44:10 -0500
From: Mathieu Segaud <mathieu.segaud@regala.cx>
To: reiserfs-devel@vger.kernel.org
Cc: reiserfs-devel@namesys.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] Convert reiserfs_ioctl() to an unlocked_ioctl
Date: Thu, 17 Jan 2008 13:44:07 +0100
Message-Id: <1200573848-1382-1-git-send-email-mathieu.segaud@regala.cx>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/reiserfs/dir.c           |    2 +-
 fs/reiserfs/file.c          |    2 +-
 fs/reiserfs/ioctl.c         |   96 +++++++++++++++++++++++++++---------------
 include/linux/reiserfs_fs.h |    2 +-
 4 files changed, 65 insertions(+), 37 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index e6b03d2..f267cf9 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -20,7 +20,7 @@ const struct file_operations reiserfs_dir_operations = {
 	.read = generic_read_dir,
 	.readdir = reiserfs_readdir,
 	.fsync = reiserfs_dir_fsync,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index a804903..e4d415c 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -284,7 +284,7 @@ static ssize_t reiserfs_file_write(struct file *file,	/* the file we are going t
 const struct file_operations reiserfs_file_operations = {
 	.read = do_sync_read,
 	.write = reiserfs_file_write,
-	.ioctl = reiserfs_ioctl,
+	.unlocked_ioctl = reiserfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = reiserfs_compat_ioctl,
 #endif
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index e0f0f09..691008d 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -21,80 +21,110 @@ static int reiserfs_unpack(struct inode *inode, struct file *filp);
 **  2) REISERFS_IOC_[GS]ETFLAGS, REISERFS_IOC_[GS]ETVERSION
 **  3) That's all for a while ...
 */
-int reiserfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		   unsigned long arg)
+long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int flags;
+	struct inode *inode;
+	long retval = 0;
+
+	lock_kernel();
+	inode = filp->f_dentry->d_inode;
 
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
 		if (S_ISREG(inode->i_mode)) {
 			if (arg)
-				return reiserfs_unpack(inode, filp);
-			else
-				return 0;
+				retval = reiserfs_unpack(inode, filp);
 		} else
-			return -ENOTTY;
+			retval = -ENOTTY;
+		goto out;
 		/* following two cases are taken from fs/ext2/ioctl.c by Remy
 		   Card (card@masi.ibp.fr) */
 	case REISERFS_IOC_GETFLAGS:
-		if (!reiserfs_attrs(inode->i_sb))
-			return -ENOTTY;
+		if (!reiserfs_attrs(inode->i_sb)) {
+			retval = -ENOTTY;
+			goto out;
+		}
 
 		flags = REISERFS_I(inode)->i_attrs;
 		i_attrs_to_sd_attrs(inode, (__u16 *) & flags);
-		return put_user(flags, (int __user *)arg);
+		retval = put_user(flags, (int __user *)arg);
+		goto out;
 	case REISERFS_IOC_SETFLAGS:{
-			if (!reiserfs_attrs(inode->i_sb))
-				return -ENOTTY;
+			if (!reiserfs_attrs(inode->i_sb)) {
+				retval = -ENOTTY;
+				goto out;
+			}
 
-			if (IS_RDONLY(inode))
-				return -EROFS;
+			if (IS_RDONLY(inode)) {
+				retval = -EROFS;
+				goto out;
+			}
 
-			if (!is_owner_or_cap(inode))
-				return -EPERM;
+			if (!is_owner_or_cap(inode)) {
+				retval = -EPERM;
+				goto out;
+			}
 
-			if (get_user(flags, (int __user *)arg))
-				return -EFAULT;
+			if (get_user(flags, (int __user *)arg)) {
+				retval = -EFAULT;
+				goto out;
+			}
 
 			/* Is it quota file? Do not allow user to mess with it. */
-			if (IS_NOQUOTA(inode))
-				return -EPERM;
+			if (IS_NOQUOTA(inode)) {
+				retval = -EPERM;
+				goto out;
+			}
 			if (((flags ^ REISERFS_I(inode)->
 			      i_attrs) & (REISERFS_IMMUTABLE_FL |
 					  REISERFS_APPEND_FL))
-			    && !capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
+			    && !capable(CAP_LINUX_IMMUTABLE)) {
+				retval = -EPERM;
+				goto out;
+			}
 
 			if ((flags & REISERFS_NOTAIL_FL) &&
 			    S_ISREG(inode->i_mode)) {
 				int result;
 
 				result = reiserfs_unpack(inode, filp);
-				if (result)
+				if (result) {
+					unlock_kernel();
 					return result;
+				}
 			}
 			sd_attrs_to_i_attrs(flags, inode);
 			REISERFS_I(inode)->i_attrs = flags;
 			inode->i_ctime = CURRENT_TIME_SEC;
 			mark_inode_dirty(inode);
-			return 0;
+			goto out;
 		}
 	case REISERFS_IOC_GETVERSION:
-		return put_user(inode->i_generation, (int __user *)arg);
+		retval = put_user(inode->i_generation, (int __user *)arg);
+		goto out;
 	case REISERFS_IOC_SETVERSION:
-		if (!is_owner_or_cap(inode))
-			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *)arg))
-			return -EFAULT;
+		if (!is_owner_or_cap(inode)) {
+			retval = -EPERM;
+			goto out;
+		}
+		if (IS_RDONLY(inode)) {
+			retval = -EROFS;
+			goto out;
+		}
+		if (get_user(inode->i_generation, (int __user *)arg)) {
+			retval = -EFAULT;
+			goto out;
+		}
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+		goto out;
 	default:
-		return -ENOTTY;
+		retval = -ENOTTY;
 	}
+out:
+	unlock_kernel();
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -124,9 +154,7 @@ long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 	default:
 		return -ENOIOCTLCMD;
 	}
-	lock_kernel();
 	ret = reiserfs_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
-	unlock_kernel();
 	return ret;
 }
 #endif
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 422eab4..4994327 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2172,7 +2172,7 @@ __u32 r5_hash(const signed char *msg, int len);
 #define SPARE_SPACE 500
 
 /* prototypes from ioctl.c */
-int reiserfs_ioctl(struct inode *inode, struct file *filp,
+long reiserfs_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
-- 
1.5.3.8

