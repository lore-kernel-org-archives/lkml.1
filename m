Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZELNLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZELNLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZELNLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:11:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61450 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZELNLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=S6al92hXKQayw6a/ulqfBZM9Er/vWBnhBv4dHXKEbx8MDjwo/OOAjqDMbkbbMtUAj+
         7MPD3otZI+bRNG6Zz2HJEWdIi7qEHU1Pd6kDsUDKCJLkQYlSl+qrsEVs7QQXo4yqhDzG
         nnRApAh5d7uk1Yr2TJ4nJpj63RgoYQrTmqY7A=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: FSDEV <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH vfs-2.6:for-next] Push BKL down into ->remount_fs()
Date: Tue, 12 May 2009 15:10:54 +0200
Message-Id: <1242133854-4872-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242133854-4872-1-git-send-email-abogani@texware.it>
References: <1242133854-4872-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/isdn/capi/capifs.c   |    4 ++++
 drivers/usb/core/inode.c     |    5 +++++
 fs/affs/super.c              |    7 ++++++-
 fs/btrfs/super.c             |   10 ++++++++--
 fs/ext2/super.c              |   12 ++++++++++--
 fs/ext3/super.c              |    4 ++++
 fs/ext4/super.c              |    4 ++++
 fs/hpfs/super.c              |    4 ++++
 fs/jffs2/fs.c                |    3 +++
 fs/jfs/super.c               |   22 ++++++++++++++++++----
 fs/nfs/super.c               |    2 ++
 fs/nilfs2/super.c            |    4 ++++
 fs/ntfs/super.c              |   15 ++++++++++++++-
 fs/ocfs2/super.c             |    4 ++++
 fs/reiserfs/super.c          |    4 ++++
 fs/super.c                   |    2 --
 fs/ubifs/super.c             |    9 ++++++++-
 fs/udf/super.c               |    6 +++++-
 fs/ufs/super.c               |   11 ++++++++++-
 fs/xfs/linux-2.6/xfs_super.c |    4 ++++
 kernel/cgroup.c              |    3 +++
 mm/shmem.c                   |    3 +++
 22 files changed, 127 insertions(+), 15 deletions(-)

diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index bff72d8..46c89bf 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>	/* current */
+#include <linux/smp_lock.h>
 
 #include "capifs.h"
 
@@ -75,6 +76,8 @@ static int capifs_remount(struct super_block *s, int *flags, char *data)
 		}
 	}
 
+	lock_kernel();
+
 	mutex_lock(&s->s_root->d_inode->i_mutex);
 
 	replace_mount_options(s, new_opt);
@@ -86,6 +89,7 @@ static int capifs_remount(struct super_block *s, int *flags, char *data)
 
 	mutex_unlock(&s->s_root->d_inode->i_mutex);
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index dff5760..ffe75e8 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -39,6 +39,7 @@
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <asm/byteorder.h>
 #include "usb.h"
 #include "hcd.h"
@@ -265,9 +266,13 @@ static int remount(struct super_block *sb, int *flags, char *data)
 		return -EINVAL;
 	}
 
+	lock_kernel();
+
 	if (usbfs_mount && usbfs_mount->mnt_sb)
 		update_sb(usbfs_mount->mnt_sb);
 
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d738646..a35eb35 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -16,6 +16,7 @@
 #include <linux/parser.h>
 #include <linux/magic.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
@@ -510,6 +511,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 		kfree(new_opts);
 		return -EINVAL;
 	}
+	lock_kernel();
 	replace_mount_options(sb, new_opts);
 
 	sbi->s_flags = mount_flags;
@@ -517,8 +519,10 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->s_uid   = uid;
 	sbi->s_gid   = gid;
 
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (*flags & MS_RDONLY) {
 		sb->s_dirt = 1;
 		while (sb->s_dirt)
@@ -527,6 +531,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	} else
 		res = affs_init_bitmap(sb, flags);
 
+	unlock_kernel();
 	return res;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d455dfe..73f1312 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -566,17 +566,22 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
 		return 0;
 
+	lock_kernel();
 	if (*flags & MS_RDONLY) {
 		sb->s_flags |= MS_RDONLY;
 
 		ret =  btrfs_commit_super(root);
 		WARN_ON(ret);
 	} else {
-		if (root->fs_info->fs_devices->rw_devices == 0)
+		if (root->fs_info->fs_devices->rw_devices == 0) {
+			unlock_kernel();
 			return -EACCES;
+		}
 
-		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
+		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0) {
+			unlock_kernel();
 			return -EINVAL;
+		}
 
 		ret = btrfs_cleanup_reloc_trees(root);
 		WARN_ON(ret);
@@ -587,6 +592,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f5b7fad..8b58ae9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1161,6 +1161,8 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	unsigned long old_sb_flags;
 	int err;
 
+	lock_kernel();
+
 	/* Store the old options */
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
@@ -1196,12 +1198,16 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		sbi->s_mount_opt &= ~EXT2_MOUNT_XIP;
 		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
 	}
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
-		    !(sbi->s_mount_state & EXT2_VALID_FS))
+		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
+			unlock_kernel();
 			return 0;
+		}
 		/*
 		 * OK, we are remounting a valid rw partition rdonly, so set
 		 * the rdonly flag and then mark the partition as valid again.
@@ -1228,12 +1234,14 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 			sb->s_flags &= ~MS_RDONLY;
 	}
 	ext2_sync_super(sb, es);
+	unlock_kernel();
 	return 0;
 restore_opts:
 	sbi->s_mount_opt = old_opts.s_mount_opt;
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 0ca949d..75cccbf 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2489,6 +2489,8 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	int i;
 #endif
 
+	lock_kernel();
+
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -2599,6 +2601,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
+	unlock_kernel();
 	return 0;
 restore_opts:
 	sb->s_flags = old_sb_flags;
@@ -2616,6 +2619,7 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b0bff67..78b7e88 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3373,6 +3373,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 
+	lock_kernel();
+
 	/* Store the original options */
 	lock_super(sb);
 	old_sb_flags = sb->s_flags;
@@ -3518,6 +3520,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			kfree(old_opts.s_qf_names[i]);
 #endif
 	unlock_super(sb);
+	unlock_kernel();
 	return 0;
 restore_opts:
 	sb->s_flags = old_sb_flags;
@@ -3537,6 +3540,7 @@ restore_opts:
 	}
 #endif
 	unlock_super(sb);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index f68193c..f2feaa0 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -13,6 +13,7 @@
 #include <linux/statfs.h>
 #include <linux/magic.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
@@ -398,6 +399,7 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	
 	*flags |= MS_NOATIME;
 	
+	lock_kernel();
 	lock_super(s);
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
 	umask = 0777 & ~sbi->sb_mode;
@@ -432,10 +434,12 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	replace_mount_options(s, new_opts);
 
 	unlock_super(s);
+	unlock_kernel();
 	return 0;
 
 out_err:
 	unlock_super(s);
+	unlock_kernel();
 	kfree(new_opts);
 	return -EINVAL;
 }
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 249305d..1edbe6a 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 #include <linux/crc32.h>
+#include <linux/smp_lock.h>
 #include "nodelist.h"
 
 static int jffs2_flash_setup(struct jffs2_sb_info *c);
@@ -387,6 +388,7 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 	   This also catches the case where it was stopped and this
 	   is just a remount to restart it.
 	   Flush the writebuffer, if neccecary, else we loose it */
+	lock_kernel();
 	if (!(sb->s_flags & MS_RDONLY)) {
 		jffs2_stop_garbage_collect_thread(c);
 		mutex_lock(&c->alloc_sem);
@@ -399,6 +401,7 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 
 	*flags |= MS_NOATIME;
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 15d0456..280ba12 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -32,6 +32,7 @@
 #include <linux/crc32.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -375,19 +376,24 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 	s64 newLVSize = 0;
 	int rc = 0;
 	int flag = JFS_SBI(sb)->flag;
+	int ret;
 
 	if (!parse_options(data, sb, &newLVSize, &flag)) {
 		return -EINVAL;
 	}
+	lock_kernel();
 	if (newLVSize) {
 		if (sb->s_flags & MS_RDONLY) {
 			printk(KERN_ERR
 		  "JFS: resize requires volume to be mounted read-write\n");
+			unlock_kernel();
 			return -EROFS;
 		}
 		rc = jfs_extendfs(sb, newLVSize, 0);
-		if (rc)
+		if (rc) {
+			unlock_kernel();
 			return rc;
+		}
 	}
 
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
@@ -398,23 +404,31 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 		truncate_inode_pages(JFS_SBI(sb)->direct_inode->i_mapping, 0);
 
 		JFS_SBI(sb)->flag = flag;
-		return jfs_mount_rw(sb, 1);
+		ret = jfs_mount_rw(sb, 1);
+		unlock_kernel();
+		return ret;
 	}
 	if ((!(sb->s_flags & MS_RDONLY)) && (*flags & MS_RDONLY)) {
 		rc = jfs_umount_rw(sb);
 		JFS_SBI(sb)->flag = flag;
+		unlock_kernel();
 		return rc;
 	}
 	if ((JFS_SBI(sb)->flag & JFS_NOINTEGRITY) != (flag & JFS_NOINTEGRITY))
 		if (!(sb->s_flags & MS_RDONLY)) {
 			rc = jfs_umount_rw(sb);
-			if (rc)
+			if (rc) {
+				unlock_kernel();
 				return rc;
+			}
 			JFS_SBI(sb)->flag = flag;
-			return jfs_mount_rw(sb, 1);
+			ret = jfs_mount_rw(sb, 1);
+			unlock_kernel();
+			return ret;
 		}
 	JFS_SBI(sb)->flag = flag;
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index d2d6778..26127b6 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1813,6 +1813,7 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	if (data == NULL)
 		return -ENOMEM;
 
+	lock_kernel();
 	/* fill out struct with values from existing mount */
 	data->flags = nfss->flags;
 	data->rsize = nfss->rsize;
@@ -1837,6 +1838,7 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	error = nfs_compare_remount_data(nfss, data);
 out:
 	kfree(data);
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 7262e84..11151ea 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -906,6 +906,8 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_mount_options old_opts;
 	int err;
 
+	lock_kernel();
+
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
 	old_opts.snapshot_cno = sbi->s_snapshot_cno;
@@ -985,6 +987,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		up(&sb->s_bdev->bd_mount_sem);
 	}
  out:
+	unlock_kernel();
 	return 0;
 
  rw_remount_failed:
@@ -993,6 +996,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 8013eb3..10f6263 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -443,6 +443,8 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 	ntfs_volume *vol = NTFS_SB(sb);
 
 	ntfs_debug("Entering with remount options string: %s", opt);
+
+	lock_kernel();
 #ifndef NTFS_RW
 	/* For read-only compiled driver, enforce read-only flag. */
 	*flags |= MS_RDONLY;
@@ -466,15 +468,18 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 		if (NVolErrors(vol)) {
 			ntfs_error(sb, "Volume has errors and is read-only%s",
 					es);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_IS_DIRTY) {
 			ntfs_error(sb, "Volume is dirty and read-only%s", es);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_MODIFIED_BY_CHKDSK) {
 			ntfs_error(sb, "Volume has been modified by chkdsk "
 					"and is read-only%s", es);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (vol->vol_flags & VOLUME_MUST_MOUNT_RO_MASK) {
@@ -482,11 +487,13 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 					"(0x%x) and is read-only%s",
 					(unsigned)le16_to_cpu(vol->vol_flags),
 					es);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (ntfs_set_volume_flags(vol, VOLUME_IS_DIRTY)) {
 			ntfs_error(sb, "Failed to set dirty bit in volume "
 					"information flags%s", es);
+			unlock_kernel();
 			return -EROFS;
 		}
 #if 0
@@ -506,18 +513,21 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 			ntfs_error(sb, "Failed to empty journal $LogFile%s",
 					es);
 			NVolSetErrors(vol);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (!ntfs_mark_quotas_out_of_date(vol)) {
 			ntfs_error(sb, "Failed to mark quotas out of date%s",
 					es);
 			NVolSetErrors(vol);
+			unlock_kernel();
 			return -EROFS;
 		}
 		if (!ntfs_stamp_usnjrnl(vol)) {
 			ntfs_error(sb, "Failed to stamp transation log "
 					"($UsnJrnl)%s", es);
 			NVolSetErrors(vol);
+			unlock_kernel();
 			return -EROFS;
 		}
 	} else if (!(sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY)) {
@@ -533,8 +543,11 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 
 	// TODO: Deal with *flags.
 
-	if (!parse_options(vol, opt))
+	if (!parse_options(vol, opt)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
+	unlock_kernel();
 	ntfs_debug("Done.");
 	return 0;
 }
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 4a79de1..d5172ba 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
+#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -581,6 +582,8 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	struct mount_options parsed_options;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
+	lock_kernel();
+
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 1)) {
 		ret = -EINVAL;
 		goto out;
@@ -684,6 +687,7 @@ unlock_osb:
 			ocfs2_set_journal_params(osb);
 	}
 out:
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 83a2571..8accbc0 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/crc32.h>
+#include <linux/smp_lock.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1197,6 +1198,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	memcpy(qf_names, REISERFS_SB(s)->s_qf_names, sizeof(qf_names));
 #endif
 
+	lock_kernel();
 	rs = SB_DISK_SUPER_BLOCK(s);
 
 	if (!reiserfs_parse_options
@@ -1319,10 +1321,12 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 
 out_ok:
 	replace_mount_options(s, new_opts);
+	unlock_kernel();
 	return 0;
 
 out_err:
 	kfree(new_opts);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/super.c b/fs/super.c
index e4a0c5b..4c9038b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -542,7 +542,6 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	shrink_dcache_sb(sb);
 	sync_filesystem(sb);
 
-	lock_kernel();
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
 	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
@@ -562,7 +561,6 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			return retval;
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
-	unlock_kernel();
 	if (remount_rw)
 		vfs_dq_quota_on_remount(sb);
 	return 0;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 522c3fd..3589eab 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -36,6 +36,7 @@
 #include <linux/mount.h>
 #include <linux/math64.h>
 #include <linux/writeback.h>
+#include <linux/smp_lock.h>
 #include "ubifs.h"
 
 /*
@@ -1770,17 +1771,22 @@ static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 		return err;
 	}
 
+	lock_kernel();
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
 		if (c->ro_media) {
 			ubifs_msg("cannot re-mount due to prior errors");
+			unlock_kernel();
 			return -EROFS;
 		}
 		err = ubifs_remount_rw(c);
-		if (err)
+		if (err) {
+			unlock_kernel();
 			return err;
+		}
 	} else if (!(sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY)) {
 		if (c->ro_media) {
 			ubifs_msg("cannot re-mount due to prior errors");
+			unlock_kernel();
 			return -EROFS;
 		}
 		ubifs_remount_ro(c);
@@ -1795,6 +1801,7 @@ static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 	}
 
 	ubifs_assert(c->lst.taken_empty_lebs > 0);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e2e06b0..cf62c6e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -568,6 +568,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
 
+	lock_kernel();
 	sbi->s_flags = uopt.flags;
 	sbi->s_uid   = uopt.uid;
 	sbi->s_gid   = uopt.gid;
@@ -581,13 +582,16 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 			*flags |= MS_RDONLY;
 	}
 
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (*flags & MS_RDONLY)
 		udf_close_lvid(sb);
 	else
 		udf_open_lvid(sb);
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index a5ecabf..0d87a0f 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -263,6 +263,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	struct ufs_super_block_first * usb1;
 	va_list args;
 	
+	lock_kernel();
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
@@ -1180,7 +1181,8 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	struct ufs_super_block_third * usb3;
 	unsigned new_mount_opt, ufstype;
 	unsigned flags;
-	
+
+	lock_kernel();
 	lock_super(sb);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
@@ -1196,6 +1198,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
 		unlock_super(sb);
+		unlock_kernel();
 		return -EINVAL;
 	}
 	if (!(new_mount_opt & UFS_MOUNT_UFSTYPE)) {
@@ -1203,12 +1206,14 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
 		unlock_super(sb);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
 		unlock_super(sb);
+		unlock_kernel();
 		return 0;
 	}
 	
@@ -1234,6 +1239,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
 		unlock_super(sb);
+		unlock_kernel();
 		return -EINVAL;
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
@@ -1243,11 +1249,13 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
 			unlock_super(sb);
+			unlock_kernel();
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
 			unlock_super(sb);
+			unlock_kernel();
 			return -EPERM;
 		}
 		sb->s_flags &= ~MS_RDONLY;
@@ -1255,6 +1263,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
 	unlock_super(sb);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index d29218e..b08bc7a 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -67,6 +67,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/smp_lock.h>
 
 static struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
@@ -1215,6 +1216,7 @@ xfs_fs_remount(
 	char			*p;
 	int			error;
 
+	lock_kernel();
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 
@@ -1279,6 +1281,7 @@ xfs_fs_remount(
 			if (error) {
 				cmn_err(CE_WARN,
 					"XFS: failed to write sb changes");
+				unlock_kernel();
 				return error;
 			}
 			mp->m_update_flags = 0;
@@ -1292,6 +1295,7 @@ xfs_fs_remount(
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a7267bf..3fb789f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -46,6 +46,7 @@
 #include <linux/cgroupstats.h>
 #include <linux/hash.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>
 
 #include <asm/atomic.h>
 
@@ -900,6 +901,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	struct cgroup *cgrp = &root->top_cgroup;
 	struct cgroup_sb_opts opts;
 
+	lock_kernel();
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -927,6 +929,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	kfree(opts.release_agent);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index b25f95c..6daaa54 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/ima.h>
+#include <linux/smp_lock.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -2240,6 +2241,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	if (shmem_parse_options(data, &config, true))
 		return error;
 
+	lock_kernel();
 	spin_lock(&sbinfo->stat_lock);
 	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
 	inodes = sbinfo->max_inodes - sbinfo->free_inodes;
@@ -2268,6 +2270,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	sbinfo->mpol        = config.mpol;	/* transfers initial ref */
 out:
 	spin_unlock(&sbinfo->stat_lock);
+	unlock_kernel();
 	return error;
 }
 
-- 
1.6.0.4

