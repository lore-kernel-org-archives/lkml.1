Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYJOOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYJOOGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbYJOOEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:52 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45116 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYJOOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:48 -0400
Subject: [PATCH 15/21] fat: Fix ATTR_RO in the case of (~umask & S_WUGO) == 0
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:00 +0900
Message-ID: <cd30496c3e848f5f6e81522369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
	<6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
In-Reply-To: <6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If inode->i_mode doesn't have S_WUGO, current code assumes it means
ATTR_RO.  However, if (~[ufd]mask & S_WUGO) == 0, inode->i_mode can't
hold S_WUGO. Therefore the updated directory entry will always have
ATTR_RO.

This adds fat_mode_can_hold_ro() to check it. And if inode->i_mode
can't hold, uses -i_attrs to hold ATTR_RO instead.

With this, we don't set ATTR_RO unless users change it via ioctl() if
(~[ufd]mask & S_WUGO) == 0.

And on FAT_IOCTL_GET_ATTRIBUTES path, this adds ->i_mutex to it for
not returning the partially updated attributes by FAT_IOCTL_SET_ATTRIBUTES
to userland.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fat.h  |   33 +++++++++++++++++++++++++++++----
 fs/fat/file.c |    7 ++++++-
 2 files changed, 35 insertions(+), 5 deletions(-)

diff -puN fs/fat/fat.h~fat-attrs-fixes fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-attrs-fixes	2008-10-13 01:49:49.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-10-13 01:49:49.000000000 +0900
@@ -117,6 +117,25 @@ static inline struct msdos_inode_info *M
 	return container_of(inode, struct msdos_inode_info, vfs_inode);
 }
 
+/*
+ * If ->i_mode can't hold S_IWUGO (i.e. ATTR_RO), we use ->i_attrs to
+ * save ATTR_RO instead of ->i_mode.
+ */
+static inline int fat_mode_can_hold_ro(struct inode *inode)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	mode_t mask;
+
+	if (S_ISDIR(inode->i_mode))
+		mask = ~sbi->options.fs_dmask;
+	else
+		mask = ~sbi->options.fs_fmask;
+
+	if (!(mask & S_IWUGO))
+		return 0;
+	return 1;
+}
+
 /* Convert attribute bits and a mask to the UNIX mode. */
 static inline mode_t fat_make_mode(struct msdos_sb_info *sbi,
 				   u8 attrs, mode_t mode)
@@ -133,14 +152,20 @@ static inline mode_t fat_make_mode(struc
 /* Return the FAT attribute byte for this inode */
 static inline u8 fat_make_attrs(struct inode *inode)
 {
-	return ((inode->i_mode & S_IWUGO) ? ATTR_NONE : ATTR_RO) |
-		(S_ISDIR(inode->i_mode) ? ATTR_DIR : ATTR_NONE) |
-		MSDOS_I(inode)->i_attrs;
+	u8 attrs = MSDOS_I(inode)->i_attrs;
+	if (S_ISDIR(inode->i_mode))
+		attrs |= ATTR_DIR;
+	if (fat_mode_can_hold_ro(inode) && !(inode->i_mode & S_IWUGO))
+		attrs |= ATTR_RO;
+	return attrs;
 }
 
 static inline void fat_save_attrs(struct inode *inode, u8 attrs)
 {
-	MSDOS_I(inode)->i_attrs = attrs & ATTR_UNUSED;
+	if (fat_mode_can_hold_ro(inode))
+		MSDOS_I(inode)->i_attrs = attrs & ATTR_UNUSED;
+	else
+		MSDOS_I(inode)->i_attrs = attrs & (ATTR_UNUSED | ATTR_RO);
 }
 
 static inline unsigned char fat_checksum(const __u8 *name)
diff -puN fs/fat/file.c~fat-attrs-fixes fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat-attrs-fixes	2008-10-13 01:49:49.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-10-13 01:49:49.000000000 +0900
@@ -27,7 +27,12 @@ int fat_generic_ioctl(struct inode *inod
 	switch (cmd) {
 	case FAT_IOCTL_GET_ATTRIBUTES:
 	{
-		u32 attr = fat_make_attrs(inode);
+		u32 attr;
+
+		mutex_lock(&inode->i_mutex);
+		attr = fat_make_attrs(inode);
+		mutex_unlock(&inode->i_mutex);
+
 		return put_user(attr, user_attr);
 	}
 	case FAT_IOCTL_SET_ATTRIBUTES:
_
