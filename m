Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbYBOWsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbYBOWsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765621AbYBOWh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:58 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36171 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764179AbYBOWhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:50 -0500
Subject: [PATCH 19/30] r/o bind mounts: elevate write count for ioctls()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:46 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223746.9E889068@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some ioctl()s can cause writes to the filesystem.  Take these, and make them
use mnt_want/drop_write() instead.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/ext2/ioctl.c              |   49 +++++++----
 linux-2.6.git-dave/fs/ext3/ioctl.c              |  103 +++++++++++++++---------
 linux-2.6.git-dave/fs/fat/file.c                |   12 +-
 linux-2.6.git-dave/fs/hfsplus/ioctl.c           |   40 +++++----
 linux-2.6.git-dave/fs/jfs/ioctl.c               |   35 +++++---
 linux-2.6.git-dave/fs/ocfs2/ioctl.c             |   11 +-
 linux-2.6.git-dave/fs/reiserfs/ioctl.c          |   65 +++++++++------
 linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_ioctl.c |   15 ++-
 8 files changed, 213 insertions(+), 117 deletions(-)

diff -puN fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ext2/ioctl.c
--- linux-2.6.git/fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/ext2/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/compat.h>
+#include <linux/mount.h>
 #include <linux/smp_lock.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -23,6 +24,7 @@ long ext2_ioctl(struct file *filp, unsig
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	int ret;
 
 	ext2_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
@@ -34,14 +36,19 @@ long ext2_ioctl(struct file *filp, unsig
 	case EXT2_IOC_SETFLAGS: {
 		unsigned int oldflags;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+
+		if (!is_owner_or_cap(inode)) {
+			ret = -EACCES;
+			goto setflags_out;
+		}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if (get_user(flags, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto setflags_out;
+		}
 
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT2_DIRSYNC_FL;
@@ -50,7 +57,8 @@ long ext2_ioctl(struct file *filp, unsig
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
-			return -EPERM;
+			ret = -EPERM;
+			goto setflags_out;
 		}
 		oldflags = ei->i_flags;
 
@@ -63,7 +71,8 @@ long ext2_ioctl(struct file *filp, unsig
 		if ((flags ^ oldflags) & (EXT2_APPEND_FL | EXT2_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				ret = -EPERM;
+				goto setflags_out;
 			}
 		}
 
@@ -75,20 +84,26 @@ long ext2_ioctl(struct file *filp, unsig
 		ext2_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	case EXT2_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT2_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *) arg))
-			return -EFAULT;	
-		inode->i_ctime = CURRENT_TIME_SEC;
-		mark_inode_dirty(inode);
-		return 0;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+		if (get_user(inode->i_generation, (int __user *) arg)) {
+			ret = -EFAULT;
+		} else {
+			inode->i_ctime = CURRENT_TIME_SEC;
+			mark_inode_dirty(inode);
+		}
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	case EXT2_IOC_GETRSVSZ:
 		if (test_opt(inode->i_sb, RESERVATION)
 			&& S_ISREG(inode->i_mode)
diff -puN fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ext3/ioctl.c
--- linux-2.6.git/fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/ext3/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -12,6 +12,7 @@
 #include <linux/capability.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
@@ -38,14 +39,19 @@ int ext3_ioctl (struct inode * inode, st
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto flags_out;
+		}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto flags_out;
+		}
 
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT3_DIRSYNC_FL;
@@ -54,7 +60,8 @@ int ext3_ioctl (struct inode * inode, st
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
-			return -EPERM;
+			err = -EPERM;
+			goto flags_out;
 		}
 		oldflags = ei->i_flags;
 
@@ -70,7 +77,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -81,7 +89,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -89,7 +98,8 @@ int ext3_ioctl (struct inode * inode, st
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
+			err = PTR_ERR(handle);
+			goto flags_out;
 		}
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -115,6 +125,8 @@ flags_err:
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL))
 			err = ext3_change_inode_journal_flag(inode, jflag);
 		mutex_unlock(&inode->i_mutex);
+flags_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GETVERSION:
@@ -129,14 +141,18 @@ flags_err:
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(generation, (int __user *) arg))
-			return -EFAULT;
-
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+		if (get_user(generation, (int __user *) arg)) {
+			err = -EFAULT;
+			goto setversion_out;
+		}
 		handle = ext3_journal_start(inode, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto setversion_out;
+		}
 		err = ext3_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = CURRENT_TIME_SEC;
@@ -144,6 +160,8 @@ flags_err:
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext3_journal_stop(handle);
+setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 #ifdef CONFIG_JBD_DEBUG
@@ -179,18 +197,24 @@ flags_err:
 		}
 		return -ENOTTY;
 	case EXT3_IOC_SETRSVSZ: {
+		int err;
 
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setrsvsz_out;
+		}
 
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setrsvsz_out;
+		}
 
 		if (rsv_window_size > EXT3_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT3_MAX_RESERVE_BLOCKS;
@@ -208,7 +232,9 @@ flags_err:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
@@ -218,17 +244,20 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (get_user(n_blocks_count, (__u32 __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
+		if (get_user(n_blocks_count, (__u32 __user *)arg)) {
+			err = -EFAULT;
+			goto group_extend_out;
+		}
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-
+group_extend_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GROUP_ADD: {
@@ -239,18 +268,22 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
 		if (copy_from_user(&input, (struct ext3_new_group_input __user *)arg,
-				sizeof(input)))
-			return -EFAULT;
+				sizeof(input))) {
+			err = -EFAULT;
+			goto group_add_out;
+		}
 
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-
+group_add_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 
diff -puN fs/fat/file.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/fat/file.c
--- linux-2.6.git/fs/fat/file.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/fat/file.c	2008-02-15 13:25:52.000000000 -0800
@@ -8,6 +8,7 @@
 
 #include <linux/capability.h>
 #include <linux/module.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
 #include <linux/smp_lock.h>
@@ -46,10 +47,9 @@ int fat_generic_ioctl(struct inode *inod
 
 		mutex_lock(&inode->i_mutex);
 
-		if (IS_RDONLY(inode)) {
-			err = -EROFS;
-			goto up;
-		}
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			goto up_no_drop_write;
 
 		/*
 		 * ATTR_VOLUME and ATTR_DIR cannot be changed; this also
@@ -105,7 +105,9 @@ int fat_generic_ioctl(struct inode *inod
 
 		MSDOS_I(inode)->i_attrs = attr & ATTR_UNUSED;
 		mark_inode_dirty(inode);
-	up:
+up:
+		mnt_drop_write(filp->f_vfsmnt);
+up_no_drop_write:
 		mutex_unlock(&inode->i_mutex);
 		return err;
 	}
diff -puN fs/hfsplus/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/hfsplus/ioctl.c
--- linux-2.6.git/fs/hfsplus/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/hfsplus/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -14,6 +14,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/xattr.h>
 #include <asm/uaccess.h>
@@ -35,25 +36,32 @@ int hfsplus_ioctl(struct inode *inode, s
 			flags |= FS_NODUMP_FL; /* EXT2_NODUMP_FL */
 		return put_user(flags, (int __user *)arg);
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
-
-		if (get_user(flags, (int __user *)arg))
-			return -EFAULT;
-
+		int err = 0;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setflags_out;
+		}
+		if (get_user(flags, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setflags_out;
+		}
 		if (flags & (FS_IMMUTABLE_FL|FS_APPEND_FL) ||
 		    HFSPLUS_I(inode).rootflags & (HFSPLUS_FLG_IMMUTABLE|HFSPLUS_FLG_APPEND)) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 		}
 
 		/* don't silently ignore unsupported ext2 flags */
-		if (flags & ~(FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NODUMP_FL))
-			return -EOPNOTSUPP;
-
+		if (flags & ~(FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NODUMP_FL)) {
+			err = -EOPNOTSUPP;
+			goto setflags_out;
+		}
 		if (flags & FS_IMMUTABLE_FL) { /* EXT2_IMMUTABLE_FL */
 			inode->i_flags |= S_IMMUTABLE;
 			HFSPLUS_I(inode).rootflags |= HFSPLUS_FLG_IMMUTABLE;
@@ -75,7 +83,9 @@ int hfsplus_ioctl(struct inode *inode, s
 
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/jfs/ioctl.c
--- linux-2.6.git/fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/jfs/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/capability.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <asm/current.h>
@@ -65,23 +66,30 @@ long jfs_ioctl(struct file *filp, unsign
 		return put_user(flags, (int __user *) arg);
 	case JFS_IOC_SETFLAGS: {
 		unsigned int oldflags;
+		int err;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
-
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setflags_out;
+		}
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto setflags_out;
+		}
 
 		flags = jfs_map_ext2(flags, 1);
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
 		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode))
-			return -EPERM;
+		if (IS_NOQUOTA(inode)) {
+			err = -EPERM;
+			goto setflags_out;
+		}
 
 		/* Lock against other parallel changes of flags */
 		mutex_lock(&inode->i_mutex);
@@ -98,7 +106,8 @@ long jfs_ioctl(struct file *filp, unsign
 			(JFS_APPEND_FL | JFS_IMMUTABLE_FL))) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto setflags_out;
 			}
 		}
 
@@ -110,7 +119,9 @@ long jfs_ioctl(struct file *filp, unsign
 		mutex_unlock(&inode->i_mutex);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/ocfs2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ocfs2/ioctl.c
--- linux-2.6.git/fs/ocfs2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/ocfs2/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -59,10 +59,6 @@ static int ocfs2_set_inode_attr(struct i
 		goto bail;
 	}
 
-	status = -EROFS;
-	if (IS_RDONLY(inode))
-		goto bail_unlock;
-
 	status = -EACCES;
 	if (!is_owner_or_cap(inode))
 		goto bail_unlock;
@@ -133,8 +129,13 @@ int ocfs2_ioctl(struct inode * inode, st
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		return ocfs2_set_inode_attr(inode, flags,
+		status = mnt_want_write(filp->f_vfsmnt);
+		if (status)
+			return status;
+		status = ocfs2_set_inode_attr(inode, flags,
 			OCFS2_FL_MODIFIABLE);
+		mnt_drop_write(filp->f_vfsmnt);
+		return status;
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
 	case OCFS2_IOC_UNRESVSP:
diff -puN fs/reiserfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/reiserfs/ioctl.c
--- linux-2.6.git/fs/reiserfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/reiserfs/ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -4,6 +4,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/time.h>
 #include <asm/uaccess.h>
@@ -25,6 +26,7 @@ int reiserfs_ioctl(struct inode *inode, 
 		   unsigned long arg)
 {
 	unsigned int flags;
+	int err = 0;
 
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
@@ -48,50 +50,67 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (!reiserfs_attrs(inode->i_sb))
 				return -ENOTTY;
 
-			if (IS_RDONLY(inode))
-				return -EROFS;
-
-			if (!is_owner_or_cap(inode))
-				return -EPERM;
-
-			if (get_user(flags, (int __user *)arg))
-				return -EFAULT;
-
-			/* Is it quota file? Do not allow user to mess with it. */
-			if (IS_NOQUOTA(inode))
-				return -EPERM;
+			err = mnt_want_write(filp->f_vfsmnt);
+			if (err)
+				return err;
+
+			if (!is_owner_or_cap(inode)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
+			if (get_user(flags, (int __user *)arg)) {
+				err = -EFAULT;
+				goto setflags_out;
+			}
+			/*
+			 * Is it quota file? Do not allow user to mess with it
+			 */
+			if (IS_NOQUOTA(inode)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 			if (((flags ^ REISERFS_I(inode)->
 			      i_attrs) & (REISERFS_IMMUTABLE_FL |
 					  REISERFS_APPEND_FL))
-			    && !capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
-
+			    && !capable(CAP_LINUX_IMMUTABLE)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 			if ((flags & REISERFS_NOTAIL_FL) &&
 			    S_ISREG(inode->i_mode)) {
 				int result;
 
 				result = reiserfs_unpack(inode, filp);
-				if (result)
-					return result;
+				if (result) {
+					err = result;
+					goto setflags_out;
+				}
 			}
 			sd_attrs_to_i_attrs(flags, inode);
 			REISERFS_I(inode)->i_attrs = flags;
 			inode->i_ctime = CURRENT_TIME_SEC;
 			mark_inode_dirty(inode);
-			return 0;
+setflags_out:
+			mnt_drop_write(filp->f_vfsmnt);
+			return err;
 		}
 	case REISERFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
 	case REISERFS_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+		if (get_user(inode->i_generation, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setversion_out;
+		}
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	default:
 		return -ENOTTY;
 	}
diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.git/fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/xfs/linux-2.6/xfs_ioctl.c	2008-02-15 13:25:52.000000000 -0800
@@ -535,8 +535,6 @@ xfs_attrmulti_attr_set(
 	char			*kbuf;
 	int			error = EFAULT;
 
-	if (IS_RDONLY(inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
 	if (len > XATTR_SIZE_MAX)
@@ -562,8 +560,6 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags)
 {
-	if (IS_RDONLY(inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
 	return xfs_attr_remove(XFS_I(inode), name, flags);
@@ -573,6 +569,7 @@ STATIC int
 xfs_attrmulti_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
+	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -626,13 +623,21 @@ xfs_attrmulti_by_handle(
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_set(inode,
 					attr_name, ops[i].am_attrvalue,
 					ops[i].am_length, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
 					attr_name, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		default:
 			ops[i].am_error = EINVAL;
@@ -811,7 +816,7 @@ xfs_ioctl(
 		return xfs_attrlist_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, inode);
+		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_SWAPEXT: {
 		error = xfs_swapext((struct xfs_swapext __user *)arg);
_
