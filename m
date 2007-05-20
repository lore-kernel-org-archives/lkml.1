Return-Path: <linux-kernel-owner+w=401wt.eu-S1759059AbXETPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059AbXETPES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbXETPEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:04:09 -0400
Received: from mail.parknet.jp ([210.171.160.80]:3016 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbXETPEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:04:07 -0400
X-AuthUser: hirofumi@parknet.jp
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fat: gcc 4.3 warning fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 May 2007 00:03:58 +0900
Message-ID: <871whby1sx.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the following warnings.

fs/fat/dir.c: In function 'fat_parse_long':
include/linux/msdos_fs.h:294: warning: array subscript is above array bounds
include/linux/msdos_fs.h:295: warning: array subscript is above array bounds
include/linux/msdos_fs.h:295: warning: array subscript is above array bounds

The ->name is defined as "name[8], ext[3]", but fat_checksum() uses
those as name[11]. There is no actual problem, but it's not a good manner.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c             |   31 ++++++++++++++++++-------------
 fs/fat/inode.c           |    3 +--
 include/linux/msdos_fs.h |    2 +-
 3 files changed, 20 insertions(+), 16 deletions(-)

diff -puN include/linux/msdos_fs.h~fat-gcc43-warning-fix include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat-gcc43-warning-fix	2007-05-20 18:58:42.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2007-05-20 18:59:04.000000000 +0900
@@ -146,7 +146,7 @@ struct fat_boot_fsinfo {
 };
 
 struct msdos_dir_entry {
-	__u8	name[8],ext[3];	/* name and extension */
+	__u8	name[MSDOS_NAME];/* name and extension */
 	__u8	attr;		/* attribute bits */
 	__u8    lcase;		/* Case for base and extension */
 	__u8	ctime_cs;	/* Creation time, centiseconds (0-199) */
diff -puN fs/fat/dir.c~fat-gcc43-warning-fix fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat-gcc43-warning-fix	2007-05-20 18:59:28.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2007-05-20 22:23:40.000000000 +0900
@@ -313,7 +313,7 @@ int fat_search_long(struct inode *inode,
 	wchar_t bufuname[14];
 	unsigned char xlate_len, nr_slots;
 	wchar_t *unicode = NULL;
-	unsigned char work[8], bufname[260];	/* 256 + 4 */
+	unsigned char work[MSDOS_NAME], bufname[260];	/* 256 + 4 */
 	int uni_xlate = sbi->options.unicode_xlate;
 	int utf8 = sbi->options.utf8;
 	int anycase = (sbi->options.name_check != 's');
@@ -351,7 +351,8 @@ parse_record:
 		if (work[0] == 0x05)
 			work[0] = 0xE5;
 		for (i = 0, j = 0, last_u = 0; i < 8;) {
-			if (!work[i]) break;
+			if (!work[i])
+				break;
 			chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
 						&bufuname[j++], opt_shortname,
 						de->lcase & CASE_LOWER_BASE);
@@ -365,13 +366,15 @@ parse_record:
 		}
 		j = last_u;
 		fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
-		for (i = 0; i < 3;) {
-			if (!de->ext[i]) break;
-			chl = fat_shortname2uni(nls_disk, &de->ext[i], 3 - i,
+		for (i = 8; i < MSDOS_NAME;) {
+			if (!work[i])
+				break;
+			chl = fat_shortname2uni(nls_disk, &work[i],
+						MSDOS_NAME - i,
 						&bufuname[j++], opt_shortname,
 						de->lcase & CASE_LOWER_EXT);
 			if (chl <= 1) {
-				if (de->ext[i] != ' ')
+				if (work[i] != ' ')
 					last_u = j;
 			} else {
 				last_u = j;
@@ -445,7 +448,7 @@ static int __fat_readdir(struct inode *i
 	int fill_len;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char c, work[8], bufname[56], *ptname = bufname;
+	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
 	unsigned long lpos, dummy, *furrfu = &lpos;
 	int uni_xlate = sbi->options.unicode_xlate;
 	int isvfat = sbi->options.isvfat;
@@ -527,7 +530,8 @@ parse_record:
 	if (work[0] == 0x05)
 		work[0] = 0xE5;
 	for (i = 0, j = 0, last = 0, last_u = 0; i < 8;) {
-		if (!(c = work[i])) break;
+		if (!(c = work[i]))
+			break;
 		chl = fat_shortname2uni(nls_disk, &work[i], 8 - i,
 					&bufuname[j++], opt_shortname,
 					de->lcase & CASE_LOWER_BASE);
@@ -549,9 +553,10 @@ parse_record:
 	j = last_u;
 	fat_short2uni(nls_disk, ".", 1, &bufuname[j++]);
 	ptname[i++] = '.';
-	for (i2 = 0; i2 < 3;) {
-		if (!(c = de->ext[i2])) break;
-		chl = fat_shortname2uni(nls_disk, &de->ext[i2], 3 - i2,
+	for (i2 = 8; i2 < MSDOS_NAME;) {
+		if (!(c = work[i2]))
+			break;
+		chl = fat_shortname2uni(nls_disk, &work[i2], MSDOS_NAME - i2,
 					&bufuname[j++], opt_shortname,
 					de->lcase & CASE_LOWER_EXT);
 		if (chl <= 1) {
@@ -563,8 +568,8 @@ parse_record:
 			}
 		} else {
 			last_u = j;
-			for (chi = 0; chi < chl && i2 < 3; chi++) {
-				ptname[i++] = de->ext[i2++];
+			for (chi = 0; chi < chl && i2 < MSDOS_NAME; chi++) {
+				ptname[i++] = work[i2++];
 				last = i;
 			}
 		}
diff -puN fs/fat/inode.c~fat-gcc43-warning-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-gcc43-warning-fix	2007-05-20 19:03:46.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2007-05-20 19:05:08.000000000 +0900
@@ -354,8 +354,7 @@ static int fat_fill_inode(struct inode *
 	} else { /* not a directory */
 		inode->i_generation |= 1;
 		inode->i_mode = MSDOS_MKMODE(de->attr,
-		    ((sbi->options.showexec &&
-			!is_exec(de->ext))
+		    ((sbi->options.showexec && !is_exec(de->name + 8))
 			? S_IRUGO|S_IWUGO : S_IRWXUGO)
 		    & ~sbi->options.fs_fmask) | S_IFREG;
 		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
