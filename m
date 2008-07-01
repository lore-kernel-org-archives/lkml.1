Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYGAC7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYGAC7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYGAC5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:15 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52182 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYGAC5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:11 -0400
Subject: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for userland
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:03 +0900
Message-ID: <129170883e848699cff211608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
In-Reply-To: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"struct dirent" is a kernel type here, but is a **different type** in 
userspace!  This means both the structure and the IOCTL number is wrong!

So, this adds new "struct __fat_dirent" to generate correct IOCTL
number.  And kernel stuff moves to under __KERNEL__.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 include/linux/msdos_fs.h |   47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff -puN include/linux/msdos_fs.h~fat_msdos_fs_h-cleanup include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_msdos_fs_h-cleanup	2008-06-30 12:47:40.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-07-01 11:37:03.000000000 +0900
@@ -2,11 +2,11 @@
 #define _LINUX_MSDOS_FS_H
 
 #include <linux/magic.h>
+#include <asm/byteorder.h>
 
 /*
  * The MS-DOS filesystem constants/structures
  */
-#include <asm/byteorder.h>
 
 #define SECTOR_SIZE	512		/* sector size (bytes) */
 #define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
@@ -89,24 +89,22 @@
 #define IS_FSINFO(x)	(le32_to_cpu((x)->signature1) == FAT_FSINFO_SIG1 \
 			 && le32_to_cpu((x)->signature2) == FAT_FSINFO_SIG2)
 
+struct __fat_dirent {
+	long		d_ino;
+	__kernel_off_t	d_off;
+	unsigned short	d_reclen;
+	char		d_name[256]; /* We must not include limits.h! */
+};
+
 /*
  * ioctl commands
  */
-#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct dirent [2])
-#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct dirent [2])
+#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct __fat_dirent[2])
+#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct __fat_dirent[2])
 /* <linux/videotext.h> has used 0x72 ('r') in collision, so skip a few */
 #define FAT_IOCTL_GET_ATTRIBUTES	_IOR('r', 0x10, __u32)
 #define FAT_IOCTL_SET_ATTRIBUTES	_IOW('r', 0x11, __u32)
 
-/*
- * vfat shortname flags
- */
-#define VFAT_SFN_DISPLAY_LOWER	0x0001 /* convert to lowercase for display */
-#define VFAT_SFN_DISPLAY_WIN95	0x0002 /* emulate win95 rule for display */
-#define VFAT_SFN_DISPLAY_WINNT	0x0004 /* emulate winnt rule for display */
-#define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
-#define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
-
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
 	__u8	system_id[8];	/* Name - can be used to special case
@@ -168,14 +166,6 @@ struct msdos_dir_slot {
 	__u8    name11_12[4];	/* last 2 characters in name */
 };
 
-struct fat_slot_info {
-	loff_t i_pos;		/* on-disk position of directory entry */
-	loff_t slot_off;	/* offset for slot or de start */
-	int nr_slots;		/* number of slots + 1(de) in filename */
-	struct msdos_dir_entry *de;
-	struct buffer_head *bh;
-};
-
 #ifdef __KERNEL__
 
 #include <linux/buffer_head.h>
@@ -184,6 +174,15 @@ struct fat_slot_info {
 #include <linux/fs.h>
 #include <linux/mutex.h>
 
+/*
+ * vfat shortname flags
+ */
+#define VFAT_SFN_DISPLAY_LOWER	0x0001 /* convert to lowercase for display */
+#define VFAT_SFN_DISPLAY_WIN95	0x0002 /* emulate win95 rule for display */
+#define VFAT_SFN_DISPLAY_WINNT	0x0004 /* emulate winnt rule for display */
+#define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
+#define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -267,6 +266,14 @@ struct msdos_inode_info {
 	struct inode vfs_inode;
 };
 
+struct fat_slot_info {
+	loff_t i_pos;		/* on-disk position of directory entry */
+	loff_t slot_off;	/* offset for slot or de start */
+	int nr_slots;		/* number of slots + 1(de) in filename */
+	struct msdos_dir_entry *de;
+	struct buffer_head *bh;
+};
+
 static inline struct msdos_sb_info *MSDOS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
_
