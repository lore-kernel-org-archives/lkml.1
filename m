Return-Path: <linux-kernel-owner+w=401wt.eu-S1751726AbYGAC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbYGAC6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 22:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYGAC5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 22:57:12 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52167 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYGAC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 22:57:06 -0400
Subject: [PATCH 4/7] fat: cleanup fs/fat/dir.c
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 01 Jul 2008 11:57:03 +0900
Message-ID: <5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
In-Reply-To: <d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is no logic changes, just cleans fs/fat/dir.c up.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |  131 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 67 insertions(+), 64 deletions(-)

diff -puN fs/fat/dir.c~fat_dir-cleanup fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_dir-cleanup	2008-07-01 09:55:52.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-07-01 09:55:52.000000000 +0900
@@ -123,10 +123,11 @@ static inline int fat_get_entry(struct i
  * but ignore that right now.
  * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
  */
-static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len,
+static int uni16_to_x8(unsigned char *ascii, const wchar_t *uni, int len,
 		       int uni_xlate, struct nls_table *nls)
 {
-	wchar_t *ip, ec;
+	const wchar_t *ip;
+	wchar_t ec;
 	unsigned char *op, nc;
 	int charlen;
 	int k;
@@ -166,6 +167,16 @@ static int uni16_to_x8(unsigned char *as
 	return (op - ascii);
 }
 
+static inline int fat_uni_to_x8(struct msdos_sb_info *sbi, const wchar_t *uni,
+				unsigned char *buf, int size)
+{
+	if (sbi->options.utf8)
+		return utf8_wcstombs(buf, uni, size);
+	else
+		return uni16_to_x8(buf, uni, size, sbi->options.unicode_xlate,
+				   sbi->nls_io);
+}
+
 static inline int
 fat_short2uni(struct nls_table *t, unsigned char *c, int clen, wchar_t *uni)
 {
@@ -226,6 +237,19 @@ fat_shortname2uni(struct nls_table *nls,
 	return len;
 }
 
+static inline int fat_name_match(struct msdos_sb_info *sbi,
+				 const unsigned char *a, int a_len,
+				 const unsigned char *b, int b_len)
+{
+	if (a_len != b_len)
+		return 0;
+
+	if (sbi->options.name_check != 's')
+		return !nls_strnicmp(sbi->nls_io, a, b, a_len);
+	else
+		return !memcmp(a, b, a_len);
+}
+
 enum { PARSE_INVALID = 1, PARSE_NOT_LONGNAME, PARSE_EOF, };
 
 /**
@@ -311,29 +335,24 @@ int fat_search_long(struct inode *inode,
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
-	wchar_t bufuname[14];
 	unsigned char nr_slots;
-	int xlate_len;
+	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char work[MSDOS_NAME];
 	unsigned char *bufname = NULL;
-	int uni_xlate = sbi->options.unicode_xlate;
-	int utf8 = sbi->options.utf8;
-	int anycase = (sbi->options.name_check != 's');
 	unsigned short opt_shortname = sbi->options.shortname;
 	loff_t cpos = 0;
-	int chl, i, j, last_u, err;
+	int chl, i, j, last_u, err, len;
 
 	bufname = __getname();
 	if (!bufname)
 		return -ENOMEM;
 
 	err = -ENOENT;
-	while(1) {
+	while (1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
-			goto EODir;
+			goto end_of_dir;
 parse_record:
 		nr_slots = 0;
 		if (de->name[0] == DELETED_FLAG)
@@ -352,7 +371,7 @@ parse_record:
 			else if (status == PARSE_NOT_LONGNAME)
 				goto parse_record;
 			else if (status == PARSE_EOF)
-				goto EODir;
+				goto end_of_dir;
 		}
 
 		memcpy(work, de->name, sizeof(de->name));
@@ -393,30 +412,21 @@ parse_record:
 		if (!last_u)
 			continue;
 
+		/* Compare shortname */
 		bufuname[last_u] = 0x0000;
-		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, PATH_MAX)
-			:uni16_to_x8(bufname, bufuname, PATH_MAX, uni_xlate, nls_io);
-		if (xlate_len == name_len)
-			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
-			    (anycase && !nls_strnicmp(nls_io, name, bufname,
-								xlate_len)))
-				goto Found;
+		len = fat_uni_to_x8(sbi, bufuname, bufname, PATH_MAX);
+		if (fat_name_match(sbi, name, name_len, bufname, len))
+			goto found;
 
 		if (nr_slots) {
-			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, PATH_MAX)
-				:uni16_to_x8(bufname, unicode, PATH_MAX, uni_xlate, nls_io);
-			if (xlate_len != name_len)
-				continue;
-			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
-			    (anycase && !nls_strnicmp(nls_io, name, bufname,
-								xlate_len)))
-				goto Found;
+			/* Compare longname */
+			len = fat_uni_to_x8(sbi, unicode, bufname, PATH_MAX);
+			if (fat_name_match(sbi, name, name_len, bufname, len))
+				goto found;
 		}
 	}
 
-Found:
+found:
 	nr_slots++;	/* include the de */
 	sinfo->slot_off = cpos - nr_slots * sizeof(*de);
 	sinfo->nr_slots = nr_slots;
@@ -424,7 +434,7 @@ Found:
 	sinfo->bh = bh;
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
-EODir:
+end_of_dir:
 	if (bufname)
 		__putname(bufname);
 	if (unicode)
@@ -452,23 +462,19 @@ static int __fat_readdir(struct inode *i
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct buffer_head *bh;
 	struct msdos_dir_entry *de;
-	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
-	unsigned char long_slots;
-	const char *fill_name;
-	int fill_len;
+	unsigned char nr_slots;
 	wchar_t bufuname[14];
 	wchar_t *unicode = NULL;
 	unsigned char c, work[MSDOS_NAME], bufname[56], *ptname = bufname;
-	unsigned long lpos, dummy, *furrfu = &lpos;
-	int uni_xlate = sbi->options.unicode_xlate;
+	unsigned short opt_shortname = sbi->options.shortname;
 	int isvfat = sbi->options.isvfat;
-	int utf8 = sbi->options.utf8;
 	int nocase = sbi->options.nocase;
-	unsigned short opt_shortname = sbi->options.shortname;
+	const char *fill_name;
 	unsigned long inum;
-	int chi, chl, i, i2, j, last, last_u, dotoffset = 0;
+	unsigned long lpos, dummy, *furrfu = &lpos;
 	loff_t cpos;
+	int chi, chl, i, i2, j, last, last_u, dotoffset = 0, fill_len;
 	int ret = 0;
 
 	lock_kernel();
@@ -488,43 +494,43 @@ static int __fat_readdir(struct inode *i
 			cpos = 0;
 		}
 	}
-	if (cpos & (sizeof(struct msdos_dir_entry)-1)) {
+	if (cpos & (sizeof(struct msdos_dir_entry) - 1)) {
 		ret = -ENOENT;
 		goto out;
 	}
 
 	bh = NULL;
-GetNew:
+get_new:
 	if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
-		goto EODir;
+		goto end_of_dir;
 parse_record:
-	long_slots = 0;
+	nr_slots = 0;
 	/* Check for long filename entry */
 	if (isvfat) {
 		if (de->name[0] == DELETED_FLAG)
-			goto RecEnd;
+			goto record_end;
 		if (de->attr != ATTR_EXT && (de->attr & ATTR_VOLUME))
-			goto RecEnd;
+			goto record_end;
 		if (de->attr != ATTR_EXT && IS_FREE(de->name))
-			goto RecEnd;
+			goto record_end;
 	} else {
 		if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
-			goto RecEnd;
+			goto record_end;
 	}
 
 	if (isvfat && de->attr == ATTR_EXT) {
 		int status = fat_parse_long(inode, &cpos, &bh, &de,
-					    &unicode, &long_slots);
+					    &unicode, &nr_slots);
 		if (status < 0) {
 			filp->f_pos = cpos;
 			ret = status;
 			goto out;
 		} else if (status == PARSE_INVALID)
-			goto RecEnd;
+			goto record_end;
 		else if (status == PARSE_NOT_LONGNAME)
 			goto parse_record;
 		else if (status == PARSE_EOF)
-			goto EODir;
+			goto end_of_dir;
 	}
 
 	if (sbi->options.dotsOK) {
@@ -586,12 +592,12 @@ parse_record:
 		}
 	}
 	if (!last)
-		goto RecEnd;
+		goto record_end;
 
 	i = last + dotoffset;
 	j = last_u;
 
-	lpos = cpos - (long_slots+1)*sizeof(struct msdos_dir_entry);
+	lpos = cpos - (nr_slots + 1) * sizeof(struct msdos_dir_entry);
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME))
 		inum = inode->i_ino;
 	else if (!memcmp(de->name, MSDOS_DOTDOT, MSDOS_NAME)) {
@@ -608,20 +614,17 @@ parse_record:
 
 	if (isvfat) {
 		bufuname[j] = 0x0000;
-		i = utf8 ? utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			 : uni16_to_x8(bufname, bufuname, sizeof(bufname), uni_xlate, nls_io);
+		i = fat_uni_to_x8(sbi, bufuname, bufname, sizeof(bufname));
 	}
 
 	fill_name = bufname;
 	fill_len = i;
-	if (!short_only && long_slots) {
+	if (!short_only && nr_slots) {
 		/* convert the unicode long name. 261 is maximum size
 		 * of unicode buffer. (13 * slots + nul) */
 		void *longname = unicode + 261;
 		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
-		int long_len = utf8
-			? utf8_wcstombs(longname, unicode, buf_size)
-			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
+		int long_len = fat_uni_to_x8(sbi, unicode, longname, buf_size);
 
 		if (!both) {
 			fill_name = longname;
@@ -640,15 +643,15 @@ parse_record:
 	}
 	if (filldir(dirent, fill_name, fill_len, *furrfu, inum,
 		    (de->attr & ATTR_DIR) ? DT_DIR : DT_REG) < 0)
-		goto FillFailed;
+		goto fill_failed;
 
-RecEnd:
+record_end:
 	furrfu = &lpos;
 	filp->f_pos = cpos;
-	goto GetNew;
-EODir:
+	goto get_new;
+end_of_dir:
 	filp->f_pos = cpos;
-FillFailed:
+fill_failed:
 	brelse(bh);
 	if (unicode)
 		__putname(unicode);
_
