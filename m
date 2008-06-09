Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYFIEMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYFIEMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 00:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYFIEMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 00:12:46 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:42224 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYFIEMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 00:12:45 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>,
       =?iso-2022-jp-2?B?Uy4bJChEKi4bKEJh?=
	 =?iso-2022-jp-2?B?GyQoRCs7GyhCbGFyIE9udXI=?= 
	<caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       Onur =?iso-8859-1?Q?K=FC=E7=FCk?= <onur@pardus.org.tr>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.26 patch] fat_valid_media() isn't for userspace
References: <200806082116.50355.caglar@pardus.org.tr>
	<20080608184310.GD4048@cs181133002.pp.htv.fi>
	<87prqrn4d8.fsf@duaron.myhome.or.jp> <484C83D9.2020402@kernel.org>
Date: Mon, 09 Jun 2008 13:12:37 +0900
In-Reply-To: <484C83D9.2020402@kernel.org> (H. Peter Anvin's message of "Sun,
	08 Jun 2008 18:14:01 -0700")
Message-ID: <87iqwjmekq.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@kernel.org> writes:

> The other thing about this header that needs to be fixed is the 
> definition of the following ioctls:
>
> #define VFAT_IOCTL_READDIR_BOTH         _IOR('r', 1, struct dirent [2])
> #define VFAT_IOCTL_READDIR_SHORT        _IOR('r', 2, struct dirent [2])
>
> "struct dirent" is a kernel type here, but is a **different type** in 
> userspace!  This means both the structure and the IOCTL number is wrong!
>
> We need to make this either __kernel_dirent_t[*] or something like 
> struct __msdos_fs_dirent.

I see. "struct dirent" in linux/dirent.h has very few users in kernel,
and probably userland doesn't use it, so it seems it should be renamed.

Well, the patch is like this (sorry, other cleanup is in this patch)?
BTW, does typedef help it in this case?

Thanks.

> 	-hpa
>
> [*] Yes, typedefs suck, but unfortunately C doesn't allow aliases in the 
> structure tag namespace.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 include/linux/msdos_fs.h |   47 ++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff -puN include/linux/msdos_fs.h~fat_msdos_fs_h-cleanup include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_msdos_fs_h-cleanup	2008-06-09 12:59:42.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-06-09 13:06:21.000000000 +0900
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
@@ -92,21 +92,19 @@
 /*
  * ioctl commands
  */
-#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct dirent [2])
-#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct dirent [2])
+/* Copy of struct dirent in <linux/dirent.h> for userland. */
+struct __fat_fs_dirent {
+	long		d_ino;
+	__kernel_off_t	d_off;
+	unsigned short	d_reclen;
+	char		d_name[256]; /* We must not include limits.h! */
+};
+#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct __fat_fs_dirent[2])
+#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct __fat_fs_dirent[2])
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
