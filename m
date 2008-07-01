Return-Path: <linux-kernel-owner+w=401wt.eu-S1751245AbYGAC5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbYGAC5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGAC5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52173 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYGAC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:06 -0400
Subject: [PATCH 6/7] fat: small optimaize __fat_readdir()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:03 +0900
Message-ID: <670df4283e848699cff611608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
	<555b858b3e848699cff511608.ps@mail.parknet.co.jp>
In-Reply-To: <555b858b3e848699cff511608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This removes unnecessary parsing for directory entries.

If short_only, we don't need to parse longname. And if !both and it
found the longname, we don't need shortname.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |   71 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff -puN fs/fat/dir.c~fat_dir-optimize fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_dir-optimize	2008-07-01 10:12:23.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-07-01 10:12:23.000000000 +0900
@@ -481,11 +481,11 @@ static int __fat_readdir(struct inode *i
 	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
 	int nocase = sbi->options.nocase;
-	const char *fill_name;
+	const char *fill_name = NULL;
 	unsigned long inum;
 	unsigned long lpos, dummy, *furrfu = &lpos;
 	loff_t cpos;
-	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len;
+	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len = 0;
 	int ret = 0;
 
 	lock_kernel();
@@ -516,8 +516,11 @@ get_new:
 		goto end_of_dir;
 parse_record:
 	nr_slots = 0;
-	/* Check for long filename entry */
-	if (isvfat) {
+	/*
+	 * Check for long filename entry, but if short_only, we don't
+	 * need to parse long filename.
+	 */
+	if (isvfat && !short_only) {
 		if (de->name[0] == DELETED_FLAG)
 			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
@@ -542,6 +545,18 @@ parse_record:
 			goto parse_record;
 		else if (status == PARSE_EOF)
 			goto end_of_dir;
+
+		if (nr_slots) {
+			void *longname = unicode + FAT_MAX_UNI_CHARS;
+			int size = PATH_MAX - FAT_MAX_UNI_SIZE;
+			int len = fat_uni_to_x8(sbi, unicode, longname, size);
+
+			fill_name = longname;
+			fill_len = len;
+			/* !both && !short_only, so we don't need shortname. */
+			if (!both)
+				goto start_filldir;
+		}
 	}
 
 	if (sbi->options.dotsOK) {
@@ -608,6 +623,26 @@ parse_record:
 	i = last + dotoffset;
 	j = last_u;
 
+	if (isvfat) {
+		bufuname[j] = 0x0000;
+		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
+	}
+	if (nr_slots) {
+		/* hack for fat_ioctl_filldir() */
+		struct fat_ioctl_filldir_callback *p = dirent;
+
+		p->longname = fill_name;
+		p->long_len = fill_len;
+		p->shortname = bufname;
+		p->short_len = i;
+		fill_name = NULL;
+		fill_len = 0;
+	} else {
+		fill_name = bufname;
+		fill_len = i;
+	}
+
+start_filldir:
 	lpos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME))
 		inum = inode->i_ino;
@@ -623,34 +658,6 @@ parse_record:
 			inum = iunique(sb, MSDOS_ROOT_INO);
 	}
 
-	if (isvfat) {
-		bufuname[j] = 0x0000;
-		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
-	}
-
-	fill_name = bufname;
-	fill_len = i;
-	if (!short_only && nr_slots) {
-		void *longname = unicode + FAT_MAX_UNI_CHARS;
-		int long_len, size = PATH_MAX - FAT_MAX_UNI_SIZE;
-
-		long_len = fat_uni_to_x8(sbi, unicode, longname, size);
-
-		if (!both) {
-			fill_name = longname;
-			fill_len = long_len;
-		} else {
-			/* hack for fat_ioctl_filldir() */
-			struct fat_ioctl_filldir_callback *p = dirent;
-
-			p->longname = longname;
-			p->long_len = long_len;
-			p->shortname = bufname;
-			p->short_len = i;
-			fill_name = NULL;
-			fill_len = 0;
-		}
-	}
 	if (filldir(dirent, fill_name, fill_len, *furrfu, inum,
 		    (de->attr & ATTR_DIR) ? DT_DIR : DT_REG) < 0)
 		goto fill_failed;
_
