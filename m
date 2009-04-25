Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZDYIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZDYIJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZDYIJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:09:25 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:53474 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZDYIJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xwHnTnRW/BKCVHCHxCYJ6HJ2yI19GNU/PMFxrwyZlF/eBSS3jkfX3nfUP1TpqlKNDJ
         dxvHXeZCzKwOdFbMejhEt8mUDs6d/PKkwCTu6y3ALNvmKjnNHZSUeCAAvRiMFP1tS0W/
         8HDFmSdcaKBCpWsuDufA5yF95VFu1T5Z8NESU=
From: Alessio Igor Bogani <abogani@texware.it>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       Ingo Molnar <mingo@elte.hu>, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH vfs-2.6:for-next] vfs: remount_fs BKL pushdown
Date: Sat, 25 Apr 2009 10:09:05 +0200
Message-Id: <1240646945-7970-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push BKL down into ->remount_fs()

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/isdn/capi/capifs.c       |    5 +++++
 drivers/staging/pohmelfs/inode.c |   11 +++++++++--
 drivers/usb/core/inode.c         |    5 +++++
 fs/adfs/super.c                  |    9 ++++++++-
 fs/affs/super.c                  |   12 ++++++++++--
 fs/befs/linuxvfs.c               |    7 ++++++-
 fs/btrfs/super.c                 |   22 +++++++++++++++++-----
 fs/cifs/cifsfs.c                 |    2 ++
 fs/coda/inode.c                  |    2 ++
 fs/cramfs/inode.c                |    3 +++
 fs/devpts/inode.c                |   10 ++++++++--
 fs/efs/super.c                   |    3 +++
 fs/ext2/super.c                  |   18 ++++++++++++++----
 fs/ext3/super.c                  |    7 ++++++-
 fs/ext4/super.c                  |    7 ++++++-
 fs/fat/inode.c                   |    5 ++++-
 fs/freevxfs/vxfs_super.c         |    3 +++
 fs/fuse/inode.c                  |    6 +++++-
 fs/gfs2/ops_super.c              |   27 +++++++++++++++++++++------
 fs/hfs/super.c                   |    7 ++++++-
 fs/hfsplus/super.c               |   12 ++++++++++--
 fs/hpfs/super.c                  |    8 +++++++-
 fs/isofs/inode.c                 |    3 +++
 fs/jffs2/fs.c                    |   11 +++++++++--
 fs/jfs/super.c                   |   27 ++++++++++++++++++++++-----
 fs/minix/inode.c                 |   14 +++++++++++---
 fs/namespace.c                   |    2 --
 fs/ncpfs/inode.c                 |    2 ++
 fs/nfs/super.c                   |   20 +++++++++++++++-----
 fs/nilfs2/super.c                |   10 ++++++++--
 fs/ntfs/super.c                  |   18 ++++++++++++++++--
 fs/ocfs2/super.c                 |    7 ++++++-
 fs/openpromfs/inode.c            |    3 +++
 fs/qnx4/inode.c                  |    3 +++
 fs/reiserfs/super.c              |   12 ++++++++++--
 fs/romfs/super.c                 |    3 +++
 fs/smbfs/inode.c                 |    2 ++
 fs/squashfs/super.c              |    3 +++
 fs/super.c                       |    4 ----
 fs/sysv/inode.c                  |    7 ++++++-
 fs/ubifs/super.c                 |   13 +++++++++++--
 fs/udf/super.c                   |   13 ++++++++++---
 fs/ufs/super.c                   |   11 ++++++++++-
 fs/xfs/linux-2.6/xfs_super.c     |    7 ++++++-
 kernel/cgroup.c                  |    9 +++++++--
 mm/shmem.c                       |   13 ++++++++++---
 46 files changed, 336 insertions(+), 72 deletions(-)

diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index b129409..1cc98da 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>	/* current */
+#include <linux/smp_lock.h>
 
 #include "capifs.h"
 
@@ -54,6 +55,8 @@ static int capifs_remount(struct super_block *s, int *flags, char *data)
 	char *this_char;
 	char *new_opt = kstrdup(data, GFP_KERNEL);
 
+	lock_kernel();
+
 	this_char = NULL;
 	while ((this_char = strsep(&data, ",")) != NULL) {
 		int n;
@@ -71,6 +74,7 @@ static int capifs_remount(struct super_block *s, int *flags, char *data)
 		else {
 			kfree(new_opt);
 			printk("capifs: called with bogus options\n");
+			unlock_kernel();
 			return -EINVAL;
 		}
 	}
@@ -84,6 +88,7 @@ static int capifs_remount(struct super_block *s, int *flags, char *data)
 	config.gid     = gid;
 	config.mode    = mode;
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index b2eaf90..c951d7e 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -30,6 +30,7 @@
 #include <linux/statfs.h>
 #include <linux/writeback.h>
 #include <linux/quotaops.h>
+#include <linux/smp_lock.h>
 
 #include "netfs.h"
 
@@ -1475,8 +1476,12 @@ static int pohmelfs_parse_options(char *options, struct pohmelfs_sb *psb, int re
 static int pohmelfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	int err;
-	struct pohmelfs_sb *psb = POHMELFS_SB(sb);
-	unsigned long old_sb_flags = sb->s_flags;
+	struct pohmelfs_sb *psb;
+	unsigned long old_sb_flags;
+
+	lock_kernel();
+	psb = POHMELFS_SB(sb);
+	old_sb_flags = sb->s_flags;
 
 	err = pohmelfs_parse_options(data, psb, 1);
 	if (err)
@@ -1484,10 +1489,12 @@ static int pohmelfs_remount(struct super_block *sb, int *flags, char *data)
 
 	if (!(*flags & MS_RDONLY))
 		sb->s_flags &= ~MS_RDONLY;
+	unlock_kernel();
 	return 0;
 
 err_out_restore:
 	sb->s_flags = old_sb_flags;
+	unlock_kernel();
 	return err;
 }
 
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index dff5760..2e8ca41 100644
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
@@ -260,14 +261,18 @@ static int remount(struct super_block *sb, int *flags, char *data)
 	if (ignore_mount)
 		return 0;
 
+	lock_kernel();
+
 	if (parse_options(sb, data)) {
 		printk(KERN_WARNING "usbfs: mount parameter error.\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 
 	if (usbfs_mount && usbfs_mount->mnt_sb)
 		update_sb(usbfs_mount->mnt_sb);
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index dd9becc..4cd1c9d 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -22,6 +22,7 @@
 #include <linux/bitops.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -213,8 +214,14 @@ static int parse_options(struct super_block *sb, char *options)
 
 static int adfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	int ret;
+
+	lock_kernel();
 	*flags |= MS_NODIRATIME;
-	return parse_options(sb, data);
+	ret = parse_options(sb, data);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int adfs_statfs(struct dentry *dentry, struct kstatfs *buf)
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 5ce695e..a0d0a38 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -16,6 +16,7 @@
 #include <linux/parser.h>
 #include <linux/magic.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
@@ -486,7 +487,7 @@ out_error_noinode:
 static int
 affs_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct affs_sb_info	*sbi = AFFS_SB(sb);
+	struct affs_sb_info	*sbi;
 	int			 blocksize;
 	uid_t			 uid;
 	gid_t			 gid;
@@ -499,12 +500,16 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
+	lock_kernel();
+
+	sbi = AFFS_SB(sb);
 	*flags |= MS_NODIRATIME;
 
 	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
 			   &blocksize, &sbi->s_prefix, sbi->s_volume,
 			   &mount_flags)) {
 		kfree(new_opts);
+		unlock_kernel();
 		return -EINVAL;
 	}
 	kfree(sb->s_options);
@@ -515,8 +520,10 @@ affs_remount(struct super_block *sb, int *flags, char *data)
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
@@ -525,6 +532,7 @@ affs_remount(struct super_block *sb, int *flags, char *data)
 	} else
 		res = affs_init_bitmap(sb, flags);
 
+	unlock_kernel();
 	return res;
 }
 
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 76afd0d..6046286 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -15,6 +15,7 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>
 
 #include "befs.h"
 #include "btree.h"
@@ -891,8 +892,12 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 static int
 befs_remount(struct super_block *sb, int *flags, char *data)
 {
-	if (!(*flags & MS_RDONLY))
+	lock_kernel();
+	if (!(*flags & MS_RDONLY)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index a7acfe6..9b0f51f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -553,15 +553,22 @@ error_free_subvol_name:
 
 static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct btrfs_root *root = btrfs_sb(sb);
+	struct btrfs_root *root;
 	int ret;
 
+	lock_kernel();
+	root = btrfs_sb(sb);
+
 	ret = btrfs_parse_options(root, data);
-	if (ret)
+	if (ret) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 
 	if (*flags & MS_RDONLY) {
 		sb->s_flags |= MS_RDONLY;
@@ -569,11 +576,15 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
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
@@ -584,6 +595,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		sb->s_flags &= ~MS_RDONLY;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 355e0ef..9bb69a4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -564,7 +564,9 @@ static int cifs_show_stats(struct seq_file *s, struct vfsmount *mnt)
 
 static int cifs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_NODIRATIME;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 830f51a..34de212 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -83,7 +83,9 @@ void coda_destroy_inodecache(void)
 
 static int coda_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_NOATIME;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index dd3634e..5626166 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -215,7 +216,9 @@ static void cramfs_put_super(struct super_block *sb)
 
 static int cramfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 63a4a59..a7e5b83 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -23,6 +23,7 @@
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
@@ -221,8 +222,12 @@ static inline void update_ptmx_mode(struct pts_fs_info *fsi)
 static int devpts_remount(struct super_block *sb, int *flags, char *data)
 {
 	int err;
-	struct pts_fs_info *fsi = DEVPTS_SB(sb);
-	struct pts_mount_opts *opts = &fsi->mount_opts;
+	struct pts_fs_info *fsi;
+	struct pts_mount_opts *opts;
+
+	lock_kernel();
+	fsi = DEVPTS_SB(sb);
+	opts = &fsi->mount_opts;
 
 	err = parse_mount_options(data, PARSE_REMOUNT, opts);
 
@@ -233,6 +238,7 @@ static int devpts_remount(struct super_block *sb, int *flags, char *data)
 	 * so do this even on error return.
 	 */
 	update_ptmx_mode(fsi);
+	unlock_kernel();
 
 	return err;
 }
diff --git a/fs/efs/super.c b/fs/efs/super.c
index f049428..5cc624d 100644
--- a/fs/efs/super.c
+++ b/fs/efs/super.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
+#include <linux/smp_lock.h>
 
 #include "efs.h"
 #include <linux/efs_vh.h>
@@ -101,7 +102,9 @@ static void efs_put_super(struct super_block *s)
 
 static int efs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f983225..33ad910 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1149,13 +1149,17 @@ void ext2_write_super (struct super_block * sb)
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
 {
-	struct ext2_sb_info * sbi = EXT2_SB(sb);
+	struct ext2_sb_info * sbi;
 	struct ext2_super_block * es;
-	unsigned long old_mount_opt = sbi->s_mount_opt;
+	unsigned long old_mount_opt;
 	struct ext2_mount_options old_opts;
 	unsigned long old_sb_flags;
 	int err;
 
+	lock_kernel();
+	sbi = EXT2_SB(sb);
+	old_mount_opt = sbi->s_mount_opt;
+
 	/* Store the old options */
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
@@ -1191,12 +1195,16 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
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
@@ -1223,12 +1231,14 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
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
index 599dbfe..981fdbf 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2499,7 +2499,7 @@ static int ext3_unfreeze(struct super_block *sb)
 static int ext3_remount (struct super_block * sb, int * flags, char * data)
 {
 	struct ext3_super_block * es;
-	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	struct ext3_sb_info *sbi;
 	ext3_fsblk_t n_blocks_count = 0;
 	unsigned long old_sb_flags;
 	struct ext3_mount_options old_opts;
@@ -2508,6 +2508,9 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 	int i;
 #endif
 
+	lock_kernel();
+	sbi = EXT3_SB(sb);
+
 	/* Store the original options */
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
@@ -2616,6 +2619,7 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
 			kfree(old_opts.s_qf_names[i]);
 #endif
+	unlock_kernel();
 	return 0;
 restore_opts:
 	sb->s_flags = old_sb_flags;
@@ -2632,6 +2636,7 @@ restore_opts:
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..3164151 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3360,7 +3360,7 @@ static int ext4_unfreeze(struct super_block *sb)
 static int ext4_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ext4_super_block *es;
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_sb_info *sbi;
 	ext4_fsblk_t n_blocks_count = 0;
 	unsigned long old_sb_flags;
 	struct ext4_mount_options old_opts;
@@ -3371,6 +3371,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	int i;
 #endif
 
+	lock_kernel();
+	sbi = EXT4_SB(sb);
+
 	/* Store the original options */
 	old_sb_flags = sb->s_flags;
 	old_opts.s_mount_opt = sbi->s_mount_opt;
@@ -3514,6 +3517,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		    old_opts.s_qf_names[i] != sbi->s_qf_names[i])
 			kfree(old_opts.s_qf_names[i]);
 #endif
+	unlock_kernel();
 	return 0;
 restore_opts:
 	sb->s_flags = old_sb_flags;
@@ -3532,6 +3536,7 @@ restore_opts:
 		sbi->s_qf_names[i] = old_opts.s_qf_names[i];
 	}
 #endif
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 296785a..5e266e5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -516,8 +516,11 @@ static void __exit fat_destroy_inodecache(void)
 
 static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct msdos_sb_info *sbi;
+	lock_kernel();
+	sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 1dacda8..ae4b2de 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -41,6 +41,7 @@
 #include <linux/stat.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/smp_lock.h>
 
 #include "vxfs.h"
 #include "vxfs_extern.h"
@@ -125,7 +126,9 @@ vxfs_statfs(struct dentry *dentry, struct kstatfs *bufp)
 
 static int vxfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index d1bc4d3..e284486 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -110,9 +110,13 @@ static void fuse_clear_inode(struct inode *inode)
 
 static int fuse_remount_fs(struct super_block *sb, int *flags, char *data)
 {
-	if (*flags & MS_MANDLOCK)
+	lock_kernel();
+	if (*flags & MS_MANDLOCK) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/gfs2/ops_super.c b/fs/gfs2/ops_super.c
index 4580195..22e7bd3 100644
--- a/fs/gfs2/ops_super.c
+++ b/fs/gfs2/ops_super.c
@@ -20,6 +20,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
+#include <linux/smp_lock.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -434,27 +435,37 @@ static int gfs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 {
-	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_args args = sdp->sd_args; /* Default to current settings */
+	struct gfs2_sbd *sdp;
+	struct gfs2_args args;
 	int error;
 
+	lock_kernel();
+	sdp = sb->s_fs_info;
+	args = sdp->sd_args; /* Default to current settings */
+
 	error = gfs2_mount_args(sdp, &args, data);
-	if (error)
+	if (error) {
+		unlock_kernel();
 		return error;
+	}
 
 	/* Not allowed to change locking details */
 	if (strcmp(args.ar_lockproto, sdp->sd_args.ar_lockproto) ||
 	    strcmp(args.ar_locktable, sdp->sd_args.ar_locktable) ||
-	    strcmp(args.ar_hostdata, sdp->sd_args.ar_hostdata))
+	    strcmp(args.ar_hostdata, sdp->sd_args.ar_hostdata)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	/* Some flags must not be changed */
 	if (args_neq(&args, &sdp->sd_args, spectator) ||
 	    args_neq(&args, &sdp->sd_args, ignore_local_fs) ||
 	    args_neq(&args, &sdp->sd_args, localflocks) ||
 	    args_neq(&args, &sdp->sd_args, localcaching) ||
-	    args_neq(&args, &sdp->sd_args, meta))
+	    args_neq(&args, &sdp->sd_args, meta)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	if (sdp->sd_args.ar_spectator)
 		*flags |= MS_RDONLY;
@@ -464,8 +475,10 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 			error = gfs2_make_fs_ro(sdp);
 		else
 			error = gfs2_make_fs_rw(sdp);
-		if (error)
+		if (error) {
+			unlock_kernel();
 			return error;
+		}
 	}
 
 	sdp->sd_args = args;
@@ -473,6 +486,8 @@ static int gfs2_remount_fs(struct super_block *sb, int *flags, char *data)
 		sb->s_flags |= MS_POSIXACL;
 	else
 		sb->s_flags &= ~MS_POSIXACL;
+
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index a36bb74..b411d0b 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -20,6 +20,7 @@
 #include <linux/parser.h>
 #include <linux/seq_file.h>
 #include <linux/vfs.h>
+#include <linux/smp_lock.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
@@ -100,9 +101,12 @@ static int hfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static int hfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_NODIRATIME;
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (!(*flags & MS_RDONLY)) {
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
 			printk(KERN_WARNING "hfs: filesystem was not cleanly unmounted, "
@@ -115,6 +119,7 @@ static int hfs_remount(struct super_block *sb, int *flags, char *data)
 			*flags |= MS_RDONLY;
 		}
 	}
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index f2a6402..0872080 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
+#include <linux/smp_lock.h>
 
 static struct inode *hfsplus_alloc_inode(struct super_block *sb);
 static void hfsplus_destroy_inode(struct inode *inode);
@@ -241,16 +242,22 @@ static int hfsplus_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 {
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	lock_kernel();
+
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (!(*flags & MS_RDONLY)) {
 		struct hfsplus_vh *vhdr = HFSPLUS_SB(sb).s_vhdr;
 		struct hfsplus_sb_info sbi;
 
 		memset(&sbi, 0, sizeof(struct hfsplus_sb_info));
 		sbi.nls = HFSPLUS_SB(sb).nls;
-		if (!hfsplus_parse_options(data, &sbi))
+		if (!hfsplus_parse_options(data, &sbi)) {
+			unlock_kernel();
 			return -EINVAL;
+		}
 
 		if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {
 			printk(KERN_WARNING "hfs: filesystem was not cleanly unmounted, "
@@ -269,6 +276,7 @@ static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 			*flags |= MS_RDONLY;
 		}
 	}
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index fecf402..35afe67 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -13,6 +13,7 @@
 #include <linux/statfs.h>
 #include <linux/magic.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 /* Mark the filesystem dirty, so that chkdsk checks it when os/2 booted */
 
@@ -388,9 +389,12 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	umode_t umask;
 	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
 	int o;
-	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	struct hpfs_sb_info *sbi;
 	char *new_opts = kstrdup(data, GFP_KERNEL);
 	
+	lock_kernel();
+	sbi = hpfs_sb(s);
+
 	*flags |= MS_NOATIME;
 	
 	uid = sbi->sb_uid; gid = sbi->sb_gid;
@@ -426,10 +430,12 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 	kfree(s->s_options);
 	s->s_options = new_opts;
 
+	unlock_kernel();
 	return 0;
 
 out_err:
 	kfree(new_opts);
+	unlock_kernel();
 	return -EINVAL;
 }
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index b4cbe96..dae0676 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -21,6 +21,7 @@
 #include <linux/statfs.h>
 #include <linux/cdrom.h>
 #include <linux/parser.h>
+#include <linux/smp_lock.h>
 
 #include "isofs.h"
 #include "zisofs.h"
@@ -99,8 +100,10 @@ static void destroy_inodecache(void)
 
 static int isofs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	/* we probably want a lot more here */
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 249305d..a5162b3 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 #include <linux/crc32.h>
+#include <linux/smp_lock.h>
 #include "nodelist.h"
 
 static int jffs2_flash_setup(struct jffs2_sb_info *c);
@@ -378,10 +379,15 @@ void jffs2_dirty_inode(struct inode *inode)
 
 int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 {
-	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
+	struct jffs2_sb_info *c;
 
-	if (c->flags & JFFS2_SB_FLAG_RO && !(sb->s_flags & MS_RDONLY))
+	lock_kernel();
+	c = JFFS2_SB_INFO(sb);
+
+	if (c->flags & JFFS2_SB_FLAG_RO && !(sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return -EROFS;
+	}
 
 	/* We stop if it was running, then restart if it needs to.
 	   This also catches the case where it was stopped and this
@@ -399,6 +405,7 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 
 	*flags |= MS_NOATIME;
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 6f21adf..8c87e95 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -32,6 +32,7 @@
 #include <linux/crc32.h>
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 
 #include "jfs_incore.h"
 #include "jfs_filsys.h"
@@ -369,20 +370,28 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	s64 newLVSize = 0;
 	int rc = 0;
-	int flag = JFS_SBI(sb)->flag;
+	int flag;
+	int ret;
+
+	lock_kernel();
+	flag = JFS_SBI(sb)->flag;
 
 	if (!parse_options(data, sb, &newLVSize, &flag)) {
+		unlock_kernel();
 		return -EINVAL;
 	}
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
@@ -393,23 +402,31 @@ static int jfs_remount(struct super_block *sb, int *flags, char *data)
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
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index daad3c2..3ea2a5a 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/highuid.h>
 #include <linux/vfs.h>
+#include <linux/smp_lock.h>
 
 static int minix_write_inode(struct inode * inode, int wait);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
@@ -104,16 +105,22 @@ static const struct super_operations minix_sops = {
 
 static int minix_remount (struct super_block * sb, int * flags, char * data)
 {
-	struct minix_sb_info * sbi = minix_sb(sb);
+	struct minix_sb_info * sbi;
 	struct minix_super_block * ms;
 
+	lock_kernel();
+	sbi = minix_sb(sb);
 	ms = sbi->s_ms;
-	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		unlock_kernel();
 		return 0;
+	}
 	if (*flags & MS_RDONLY) {
 		if (ms->s_state & MINIX_VALID_FS ||
-		    !(sbi->s_mount_state & MINIX_VALID_FS))
+		    !(sbi->s_mount_state & MINIX_VALID_FS)) {
+			unlock_kernel();
 			return 0;
+		}
 		/* Mounting a rw partition read-only. */
 		if (sbi->s_version != MINIX_V3)
 			ms->s_state = sbi->s_mount_state;
@@ -135,6 +142,7 @@ static int minix_remount (struct super_block * sb, int * flags, char * data)
 			printk("MINIX-fs warning: remounting fs with errors, "
 				"running fsck is recommended\n");
 	}
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 2b55ed3..3a4615b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1092,9 +1092,7 @@ static int do_umount(struct vfsmount *mnt, int flags)
 		 */
 		down_write(&sb->s_umount);
 		if (!(sb->s_flags & MS_RDONLY)) {
-			lock_kernel();
 			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
-			unlock_kernel();
 		}
 		up_write(&sb->s_umount);
 		return retval;
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d642f0e..5b6c11e 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -91,7 +91,9 @@ static void destroy_inodecache(void)
 
 static int ncp_remount(struct super_block *sb, int *flags, char* data)
 {
+	lock_kernel();
 	*flags |= MS_NODIRATIME;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 1679a16..0a54d02 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1792,10 +1792,15 @@ static int
 nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 {
 	int error;
-	struct nfs_server *nfss = sb->s_fs_info;
+	struct nfs_server *nfss;
 	struct nfs_parsed_mount_data *data;
-	struct nfs_mount_data *options = (struct nfs_mount_data *)raw_data;
-	struct nfs4_mount_data *options4 = (struct nfs4_mount_data *)raw_data;
+	struct nfs_mount_data *options;
+	struct nfs4_mount_data *options4;
+
+	lock_kernel();
+	nfss = sb->s_fs_info;
+	options = (struct nfs_mount_data *)raw_data;
+	options4 = (struct nfs4_mount_data *)raw_data;
 	u32 nfsvers = nfss->nfs_client->rpc_ops->version;
 
 	/*
@@ -1806,12 +1811,16 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	 */
 	if ((nfsvers == 4 && (!options4 || options4->version == 1)) ||
 	    (nfsvers <= 3 && (!options || (options->version >= 1 &&
-					   options->version <= 6))))
+					   options->version <= 6)))) {
+		unlock_kernel();
 		return 0;
+	}
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (data == NULL)
+	if (data == NULL) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	/* fill out struct with values from existing mount */
 	data->flags = nfss->flags;
@@ -1837,6 +1846,7 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	error = nfs_compare_remount_data(nfss, data);
 out:
 	kfree(data);
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6989b03..5082ae2 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -891,13 +891,17 @@ nilfs_fill_super(struct super_block *sb, void *data, int silent,
 
 static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct nilfs_sb_info *sbi = NILFS_SB(sb);
+	struct nilfs_sb_info *sbi;
 	struct nilfs_super_block *sbp;
-	struct the_nilfs *nilfs = sbi->s_nilfs;
+	struct the_nilfs *nilfs;
 	unsigned long old_sb_flags;
 	struct nilfs_mount_options old_opts;
 	int err;
 
+	lock_kernel();
+	sbi = NILFS_SB(sb);
+	nilfs = sbi->s_nilfs;
+
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
 	old_opts.snapshot_cno = sbi->s_snapshot_cno;
@@ -977,6 +981,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 		up(&sb->s_bdev->bd_mount_sem);
 	}
  out:
+	unlock_kernel();
 	return 0;
 
  rw_remount_failed:
@@ -985,6 +990,7 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sb->s_flags = old_sb_flags;
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index f76951d..8c8f5e4 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -440,9 +440,12 @@ static inline int ntfs_clear_volume_flags(ntfs_volume *vol, VOLUME_FLAGS flags)
  */
 static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 {
-	ntfs_volume *vol = NTFS_SB(sb);
+	ntfs_volume *vol;
 
 	ntfs_debug("Entering with remount options string: %s", opt);
+
+	lock_kernel();
+	vol = NTFS_SB(sb);
 #ifndef NTFS_RW
 	/* For read-only compiled driver, enforce read-only flag. */
 	*flags |= MS_RDONLY;
@@ -466,15 +469,18 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
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
@@ -482,11 +488,13 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
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
@@ -506,18 +514,21 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
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
@@ -533,8 +544,11 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 
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
index 79ff8d9..bee1336 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -42,6 +42,7 @@
 #include <linux/mount.h>
 #include <linux/seq_file.h>
 #include <linux/quotaops.h>
+#include <linux/smp_lock.h>
 
 #define MLOG_MASK_PREFIX ML_SUPER
 #include <cluster/masklog.h>
@@ -593,7 +594,10 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	int incompat_features;
 	int ret = 0;
 	struct mount_options parsed_options;
-	struct ocfs2_super *osb = OCFS2_SB(sb);
+	struct ocfs2_super *osb;
+
+	lock_kernel();
+	osb = OCFS2_SB(sb);
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 1)) {
 		ret = -EINVAL;
@@ -698,6 +702,7 @@ unlock_osb:
 			ocfs2_set_journal_params(osb);
 	}
 out:
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index ffcd04f..6552755 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h>
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
@@ -369,7 +370,9 @@ static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
 
 static int openprom_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_NOATIME;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index fe1f0f3..6ad86a7 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -146,17 +146,20 @@ static int qnx4_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct qnx4_sb_info *qs;
 
+	lock_kernel();
 	qs = qnx4_sb(sb);
 	qs->Version = QNX4_VERSION;
 #ifndef CONFIG_QNX4FS_RW
 	*flags |= MS_RDONLY;
 #endif
 	if (*flags & MS_RDONLY) {
+		unlock_kernel();
 		return 0;
 	}
 
 	mark_buffer_dirty(qs->sb_buf);
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 0ae6486..d8a6843 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/crc32.h>
+#include <linux/smp_lock.h>
 
 struct file_system_type reiserfs_fs_type;
 
@@ -1181,17 +1182,22 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	struct reiserfs_super_block *rs;
 	struct reiserfs_transaction_handle th;
 	unsigned long blocks;
-	unsigned long mount_options = REISERFS_SB(s)->s_mount_opt;
+	unsigned long mount_options;
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
-	struct reiserfs_journal *journal = SB_JOURNAL(s);
+	struct reiserfs_journal *journal;
 	char *new_opts = kstrdup(arg, GFP_KERNEL);
 	int err;
 	char *qf_names[MAXQUOTAS];
 	unsigned int qfmt = 0;
 #ifdef CONFIG_QUOTA
 	int i;
+#endif
 
+	lock_kernel();
+	mount_options = REISERFS_SB(s)->s_mount_opt;
+	journal = SB_JOURNAL(s);
+#ifdef CONFIG_QUOTA
 	memcpy(qf_names, REISERFS_SB(s)->s_qf_names, sizeof(qf_names));
 #endif
 
@@ -1318,10 +1324,12 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 out_ok:
 	kfree(s->s_options);
 	s->s_options = new_opts;
+	unlock_kernel();
 	return 0;
 
 out_err:
 	kfree(new_opts);
+	unlock_kernel();
 	return err;
 }
 
diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index 10ca7d9..a35fc9f 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -72,6 +72,7 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 #include <linux/uaccess.h>
+#include <linux/smp_lock.h>
 #include "internal.h"
 
 static struct kmem_cache *romfs_inode_cachep;
@@ -427,7 +428,9 @@ static int romfs_statfs(struct dentry *dentry, struct kstatfs *buf)
  */
 static int romfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/smbfs/inode.c b/fs/smbfs/inode.c
index fc27fbf..e26eeb6 100644
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -93,7 +93,9 @@ static void destroy_inodecache(void)
 
 static int smb_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_NODIRATIME;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index ffa6edc..40a3610 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/zlib.h>
 #include <linux/magic.h>
+#include <linux/smp_lock.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -321,7 +322,9 @@ static int squashfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 static int squashfs_remount(struct super_block *sb, int *flags, char *data)
 {
+	lock_kernel();
 	*flags |= MS_RDONLY;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/super.c b/fs/super.c
index 786fe7d..29d9343 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -686,13 +686,9 @@ static void do_emergency_remount(struct work_struct *work)
 		down_read(&sb->s_umount);
 		if (sb->s_root && sb->s_bdev && !(sb->s_flags & MS_RDONLY)) {
 			/*
-			 * ->remount_fs needs lock_kernel().
-			 *
 			 * What lock protects sb->s_flags??
 			 */
-			lock_kernel();
 			do_remount_sb(sb, MS_RDONLY, NULL, 1);
-			unlock_kernel();
 		}
 		drop_super(sb);
 		spin_lock(&sb_lock);
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index da20b48..41c3c10 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -28,6 +28,7 @@
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>
 #include <asm/byteorder.h>
 #include "sysv.h"
 
@@ -60,11 +61,15 @@ clean:
 
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
-	struct sysv_sb_info *sbi = SYSV_SB(sb);
+	struct sysv_sb_info *sbi;
+
+	lock_kernel();
+	sbi = SYSV_SB(sb);
 	if (sbi->s_forced_ro)
 		*flags |= MS_RDONLY;
 	if (!(*flags & MS_RDONLY))
 		sb->s_dirt = 1;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index faa44f9..5c74c4d 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -36,6 +36,7 @@
 #include <linux/mount.h>
 #include <linux/math64.h>
 #include <linux/writeback.h>
+#include <linux/smp_lock.h>
 #include "ubifs.h"
 
 /*
@@ -1758,27 +1759,34 @@ static void ubifs_put_super(struct super_block *sb)
 static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 {
 	int err;
-	struct ubifs_info *c = sb->s_fs_info;
+	struct ubifs_info *c;
 
 	dbg_gen("old flags %#lx, new flags %#x", sb->s_flags, *flags);
 
+	lock_kernel();
+	c = sb->s_fs_info;
 	err = ubifs_parse_options(c, data, 1);
 	if (err) {
 		ubifs_err("invalid or unknown remount parameter");
+		unlock_kernel();
 		return err;
 	}
 
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
@@ -1793,6 +1801,7 @@ static int ubifs_remount_fs(struct super_block *sb, int *flags, char *data)
 	}
 
 	ubifs_assert(c->lst.taken_empty_lebs > 0);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 72348cc..ae50550 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -556,8 +556,10 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 {
 	struct udf_options uopt;
-	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_sb_info *sbi;
 
+	lock_kernel();
+	sbi = UDF_SB(sb);
 	uopt.flags = sbi->s_flags;
 	uopt.uid   = sbi->s_uid;
 	uopt.gid   = sbi->s_gid;
@@ -565,8 +567,10 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	uopt.fmode = sbi->s_fmode;
 	uopt.dmode = sbi->s_dmode;
 
-	if (!udf_parse_options(options, &uopt, true))
+	if (!udf_parse_options(options, &uopt, true)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	sbi->s_flags = uopt.flags;
 	sbi->s_uid   = uopt.uid;
@@ -581,13 +585,16 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
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
index 6035929..faaebd6 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1172,6 +1172,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	unsigned new_mount_opt, ufstype;
 	unsigned flags;
 	
+	lock_kernel();
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
 	usb1 = ubh_get_usb_first(uspi);
@@ -1184,17 +1185,21 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	ufstype = UFS_SB(sb)->s_mount_opt & UFS_MOUNT_UFSTYPE;
 	new_mount_opt = 0;
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
-	if (!ufs_parse_options (data, &new_mount_opt))
+	if (!ufs_parse_options (data, &new_mount_opt)) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 	if (!(new_mount_opt & UFS_MOUNT_UFSTYPE)) {
 		new_mount_opt |= ufstype;
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
+		unlock_kernel();
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
+		unlock_kernel();
 		return 0;
 	}
 	
@@ -1219,6 +1224,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 #ifndef CONFIG_UFS_FS_WRITE
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
+		unlock_kernel();
 		return -EINVAL;
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
@@ -1227,16 +1233,19 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		    ufstype != UFS_MOUNT_UFSTYPE_SUNx86 &&
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
+			unlock_kernel();
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
+			unlock_kernel();
 			return -EPERM;
 		}
 		sb->s_flags &= ~MS_RDONLY;
 #endif
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index bb68526..1b5660b 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -67,6 +67,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/parser.h>
+#include <linux/smp_lock.h>
 
 static struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
@@ -1206,11 +1207,13 @@ xfs_fs_remount(
 	int			*flags,
 	char			*options)
 {
-	struct xfs_mount	*mp = XFS_M(sb);
+	struct xfs_mount	*mp;
 	substring_t		args[MAX_OPT_ARGS];
 	char			*p;
 	int			error;
 
+	lock_kernel();
+	mp = XFS_M(sb);
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 
@@ -1275,6 +1278,7 @@ xfs_fs_remount(
 			if (error) {
 				cmn_err(CE_WARN,
 					"XFS: failed to write sb changes");
+				unlock_kernel();
 				return error;
 			}
 			mp->m_update_flags = 0;
@@ -1288,6 +1292,7 @@ xfs_fs_remount(
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 382109b..5510422 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -46,6 +46,7 @@
 #include <linux/cgroupstats.h>
 #include <linux/hash.h>
 #include <linux/namei.h>
+#include <linux/smp_lock.h>
 
 #include <asm/atomic.h>
 
@@ -896,10 +897,13 @@ static int parse_cgroupfs_options(char *data,
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 {
 	int ret = 0;
-	struct cgroupfs_root *root = sb->s_fs_info;
-	struct cgroup *cgrp = &root->top_cgroup;
+	struct cgroupfs_root *root;
+	struct cgroup *cgrp;
 	struct cgroup_sb_opts opts;
 
+	lock_kernel();
+	root = sb->s_fs_info;
+	cgrp = &root->top_cgroup;
 	mutex_lock(&cgrp->dentry->d_inode->i_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -927,6 +931,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
 	kfree(opts.release_agent);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/mm/shmem.c b/mm/shmem.c
index f9cb20e..863cb5b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/swap.h>
 #include <linux/ima.h>
+#include <linux/smp_lock.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -2227,14 +2228,19 @@ bad_val:
 
 static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 {
-	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
-	struct shmem_sb_info config = *sbinfo;
+	struct shmem_sb_info *sbinfo;
+	struct shmem_sb_info config;
 	unsigned long blocks;
 	unsigned long inodes;
 	int error = -EINVAL;
 
-	if (shmem_parse_options(data, &config, true))
+	lock_kernel();
+	sbinfo = SHMEM_SB(sb);
+	config = *sbinfo;
+	if (shmem_parse_options(data, &config, true)) {
+		unlock_kernel();
 		return error;
+	}
 
 	spin_lock(&sbinfo->stat_lock);
 	blocks = sbinfo->max_blocks - sbinfo->free_blocks;
@@ -2264,6 +2270,7 @@ static int shmem_remount_fs(struct super_block *sb, int *flags, char *data)
 	sbinfo->mpol        = config.mpol;	/* transfers initial ref */
 out:
 	spin_unlock(&sbinfo->stat_lock);
+	unlock_kernel();
 	return error;
 }
 
-- 
1.6.0.4

