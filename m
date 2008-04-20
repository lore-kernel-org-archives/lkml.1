Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbYDTSZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbYDTSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYDTSYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:39 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45909 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbYDTSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:34 -0400
Subject: [PATCH 9/9] fat: use __getname()
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:29 +0900
Message-ID: <d0eb645f3e8480b87c995695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
	<954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
	<f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
	<89121f633e8480b87c755695.ps@mail.parknet.co.jp>
	<dedb5bd83e8480b87c765695.ps@mail.parknet.co.jp>
	<cef36f873e8480b87c875695.ps@mail.parknet.co.jp>
	<10ca9ccd3e8480b87c985695.ps@mail.parknet.co.jp>
In-Reply-To: <10ca9ccd3e8480b87c985695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__getname() is faster than __get_free_page(). Use it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c    |   20 ++++++++++----------
 fs/vfat/namei.c |   10 ++++------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN fs/vfat/namei.c~fat_use-__getname fs/vfat/namei.c
--- linux-2.6/fs/vfat/namei.c~fat_use-__getname	2008-04-21 01:36:07.000000000 +0900
+++ linux-2.6-hirofumi/fs/vfat/namei.c	2008-04-21 01:36:07.000000000 +0900
@@ -472,7 +472,7 @@ xlate_to_uni(const unsigned char *name, 
 	if (utf8) {
 		int name_len = strlen(name);
 
-		*outlen = utf8_mbstowcs((wchar_t *)outname, name, PAGE_SIZE);
+		*outlen = utf8_mbstowcs((wchar_t *)outname, name, PATH_MAX);
 
 		/*
 		 * We stripped '.'s before and set len appropriately,
@@ -565,7 +565,6 @@ static int vfat_build_slots(struct inode
 	struct fat_mount_options *opts = &sbi->options;
 	struct msdos_dir_slot *ps;
 	struct msdos_dir_entry *de;
-	unsigned long page;
 	unsigned char cksum, lcase;
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
@@ -575,11 +574,10 @@ static int vfat_build_slots(struct inode
 
 	*nr_slots = 0;
 
-	page = __get_free_page(GFP_KERNEL);
-	if (!page)
+	uname = __getname();
+	if (!uname)
 		return -ENOMEM;
 
-	uname = (wchar_t *)page;
 	err = xlate_to_uni(name, len, (unsigned char *)uname, &ulen, &usize,
 			   opts->unicode_xlate, opts->utf8, sbi->nls_io);
 	if (err)
@@ -631,7 +629,7 @@ shortname:
 	de->starthi = cpu_to_le16(cluster >> 16);
 	de->size = 0;
 out_free:
-	free_page(page);
+	__putname(uname);
 	return err;
 }
 
diff -puN fs/fat/dir.c~fat_use-__getname fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_use-__getname	2008-04-21 01:36:07.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-04-21 01:36:07.000000000 +0900
@@ -247,7 +247,7 @@ static int fat_parse_long(struct inode *
 	unsigned char id, slot, slots, alias_checksum;
 
 	if (!*unicode) {
-		*unicode = (wchar_t *)__get_free_page(GFP_KERNEL);
+		*unicode = __getname();
 		if (!*unicode) {
 			brelse(*bh);
 			return -ENOMEM;
@@ -327,7 +327,7 @@ int fat_search_long(struct inode *inode,
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err;
 
-	bufname = (unsigned char*)__get_free_page(GFP_KERNEL);
+	bufname = __getname();
 	if (!bufname)
 		return -ENOMEM;
 
@@ -396,8 +396,8 @@ parse_record:
 
 		bufuname[last_u] = 0x0000;
 		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, PAGE_SIZE)
-			:uni16_to_x8(bufname, bufuname, PAGE_SIZE, uni_xlate, nls_io);
+			?utf8_wcstombs(bufname, bufuname, PATH_MAX)
+			:uni16_to_x8(bufname, bufuname, PATH_MAX, uni_xlate, nls_io);
 		if (xlate_len == name_len)
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
 			    (anycase && !nls_strnicmp(nls_io, name, bufname,
@@ -406,8 +406,8 @@ parse_record:
 
 		if (nr_slots) {
 			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, PAGE_SIZE)
-				:uni16_to_x8(bufname, unicode, PAGE_SIZE, uni_xlate, nls_io);
+				?utf8_wcstombs(bufname, unicode, PATH_MAX)
+				:uni16_to_x8(bufname, unicode, PATH_MAX, uni_xlate, nls_io);
 			if (xlate_len != name_len)
 				continue;
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
@@ -427,9 +427,9 @@ Found:
 	err = 0;
 EODir:
 	if (bufname)
-		free_page((unsigned long)bufname);
+		__putname(bufname);
 	if (unicode)
-		free_page((unsigned long)unicode);
+		__putname(unicode);
 
 	return err;
 }
@@ -619,7 +619,7 @@ parse_record:
 		/* convert the unicode long name. 261 is maximum size
 		 * of unicode buffer. (13 * slots + nul) */
 		void *longname = unicode + 261;
-		int buf_size = PAGE_SIZE - (261 * sizeof(unicode[0]));
+		int buf_size = PATH_MAX - (261 * sizeof(unicode[0]));
 		int long_len = utf8
 			? utf8_wcstombs(longname, unicode, buf_size)
 			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
@@ -652,7 +652,7 @@ EODir:
 FillFailed:
 	brelse(bh);
 	if (unicode)
-		free_page((unsigned long)unicode);
+		__putname(unicode);
 out:
 	unlock_kernel();
 	return ret;
_
