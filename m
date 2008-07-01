Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYGAC5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYGAC5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYGAC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:09 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52170 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYGAC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:06 -0400
Subject: [PATCH 5/7] fat: use same logic in fat_search_long() and __fat_readdir()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:03 +0900
Message-ID: <555b858b3e848699cff511608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
In-Reply-To: <5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This uses uses stack for shortname, and uses __getname() for longname
in fat_search_long() and __fat_readdir(). By this, it removes
unneeded __getname() for shortname.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff -puN fs/fat/dir.c~fat_dir-mem-cleanup fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_dir-mem-cleanup	2008-07-01 10:01:52.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-07-01 10:01:52.000000000 +0900
@@ -325,6 +325,19 @@ parse_long:
 }
 
 /*
+ * Maximum buffer size of short name.
+ * [(MSDOS_NAME + '.') * max one char + nul]
+ * For msdos style, ['.' (hidden) + MSDOS_NAME + '.' + nul]
+ */
+#define FAT_MAX_SHORT_SIZE	((MSDOS_NAME + 1) * NLS_MAX_CHARSET_SIZE + 1)
+/*
+ * Maximum buffer size of unicode chars from slots.
+ * [(max longname slots * 13 (size in a slot) + nul) * sizeof(wchar_t)]
+ */
+#define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
+#define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
+
+/*
  * Return values: negative -> error, 0 -> not found, positive -> found,
  * value is the total amount of slots, including the shortname entry.
  */
@@ -340,15 +353,11 @@ int fat_search_long(struct inode *inode,
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char work[MSDOS_NAME];
-	unsigned char *bufname = NULL;
+	unsigned char bufname[FAT_MAX_SHORT_SIZE];
 	unsigned short opt_shortname = sbi->options.shortname;
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err, len;
 
-	bufname = __getname();
-	if (!bufname)
-		return -ENOMEM;
-
 	err = -ENOENT;
 	while (1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
@@ -414,14 +423,17 @@ parse_record:
 
 		/* Compare shortname */
 		bufuname[last_u] = 0x0000;
-		len = fat_uni_to_x8(sbi, bufuname, bufname, PATH_MAX);
+		len = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
 		if (fat_name_match(sbi, name, name_len, bufname, len))
 			goto found;
 
 		if (nr_slots) {
+			void *longname = unicode + FAT_MAX_UNI_CHARS;
+			int size = PATH_MAX - FAT_MAX_UNI_SIZE;
+
 			/* Compare longname */
-			len = fat_uni_to_x8(sbi, unicode, bufname, PATH_MAX);
-			if (fat_name_match(sbi, name, name_len, bufname, len))
+			len = fat_uni_to_x8(sbi, unicode, longname, size);
+			if (fat_name_match(sbi, name, name_len, longname, len))
 				goto found;
 		}
 	}
@@ -435,8 +447,6 @@ found:
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
 end_of_dir:
-	if (bufname)
-		__putname(bufname);
 	if (unicode)
 		__putname(unicode);
 
@@ -466,7 +476,8 @@ static int __fat_readdir(struct inode *i
 	unsigned char nr_slots;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
-	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
+	unsigned char c, work[MSDOS_NAME];
+	unsigned char bufname[FAT_MAX_SHORT_SIZE], *ptname = bufname;
 	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
 	int nocase = sbi->options.nocase;
@@ -620,11 +631,10 @@ parse_record:
 	fill_name = bufname;
 	fill_len = i;
 	if (!short_only && nr_slots) {
-		/* convert the unicode long name. 261 is maximum size
-		 * of unicode buffer. (13 * slots + nul) */
-		void *longname = unicode + 261;
-		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
-		int long_len = fat_uni_to_x8(sbi, unicode, longname, buf_size);
+		void *longname = unicode + FAT_MAX_UNI_CHARS;
+		int long_len, size = PATH_MAX - FAT_MAX_UNI_SIZE;
+
+		long_len = fat_uni_to_x8(sbi, unicode, longname, size);
 
 		if (!both) {
 			fill_name = longname;
_
