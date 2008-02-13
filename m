Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbYBMQz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbYBMQz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYBMQzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:55:19 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:63707 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYBMQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=MH3bbWdC7HHwsh5YLQT6Hh6h7DwKjb4ATWYErL7f4vKFxasFSRZ7BEKeTbyOGrdQizMwrxIS6K2Sd1j8OsH/L8vtOuYqdpNv8WnZlgHkhILCRKZ6dsYncsZEl1P79F/UktWQmTKViXvxQGW9fWv9rkGrey/pIsD7WhGliO2VUp8=
Message-ID: <47B3213E.1020407@gmail.com>
Date: Thu, 14 Feb 2008 00:56:30 +0800
From: Keith Mok <ek9852@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: hirofumi@mail.parknet.co.jp
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] vfat: bug fix for vfat cannot handle filename with 255 asian
 characters when mounted with utf8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the problem that the buffer allocated for convert of
unicode to utf8 in fat/dir.c is too small.
And cannot handle filename with 255 asian characters when mounted with
utf8 options.

Also it fix the filename length limitation checking in vfat/namei.c that
the filename length should be checked against the number of converted
unicode characters.
Not the length before NLS/UTF8 converted.

Any comments ?


Signed-off-by: Keith Mok <ek9852@gmail.com>

---
Keith Mok




--- linux-source-2.6.22/fs/vfat/namei.c.orig	2007-07-09 07:32:17.000000000 +0800
+++ linux-source-2.6.22/fs/vfat/namei.c	2008-02-13 22:56:14.000000000 +0800
@@ -176,15 +176,8 @@ static inline int vfat_is_used_badchars(
 	for (i = 0; i < len; i++)
 		if (vfat_bad_char(s[i]))
 			return -EINVAL;
-	return 0;
-}
-
-static int vfat_valid_longname(const unsigned char *name, unsigned int len)
-{
-	if (name[len - 1] == ' ')
+	if(s[i-1] == 0x0020) /* last character cannot be space */
 		return -EINVAL;
-	if (len >= 256)
-		return -ENAMETOOLONG;
 	return 0;
 }
 
@@ -489,7 +482,7 @@ xlate_to_uni(const unsigned char *name, 
 	} else {
 		if (nls) {
 			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= 260;
+			     i < len && *outlen <= 255;
 			     *outlen += 1)
 			{
 				if (escape && (*ip == ':')) {
@@ -527,7 +520,7 @@ xlate_to_uni(const unsigned char *name, 
 			}
 		} else {
 			for (i = 0, ip = name, op = outname, *outlen = 0;
-			     i < len && *outlen <= 260;
+			     i < len && *outlen <= 255;
 			     i++, *outlen += 1)
 			{
 				*op++ = *ip++;
@@ -535,7 +528,7 @@ xlate_to_uni(const unsigned char *name, 
 			}
 		}
 	}
-	if (*outlen > 260)
+	if (*outlen > 255)
 		return -ENAMETOOLONG;
 
 	*longlen = *outlen;
@@ -574,9 +567,6 @@ static int vfat_build_slots(struct inode
 	loff_t offset;
 
 	*nr_slots = 0;
-	err = vfat_valid_longname(name, len);
-	if (err)
-		return err;
 
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
--- linux-source-2.6.22/fs/fat/dir.c.orig	2007-07-09 07:32:17.000000000 +0800
+++ linux-source-2.6.22/fs/fat/dir.c	2008-02-14 00:42:52.000000000 +0800
@@ -124,7 +124,7 @@ static inline int fat_get_entry(struct i
  * but ignore that right now.
  * Ahem... Stack smashing in ring 0 isn't fun. Fixed.
  */
-static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int uni_xlate,
+static int uni16_to_x8(unsigned char *ascii, wchar_t *uni, int len, int uni_xlate,
 		       struct nls_table *nls)
 {
 	wchar_t *ip, ec;
@@ -135,10 +135,13 @@ static int uni16_to_x8(unsigned char *as
 	ip = uni;
 	op = ascii;
 
-	while (*ip) {
+	BUG_ON(len <= NLS_MAX_CHARSET_SIZE);
+
+	while (*ip && (len-NLS_MAX_CHARSET_SIZE)>0) {
 		ec = *ip++;
 		if ( (charlen = nls->uni2char(ec, op, NLS_MAX_CHARSET_SIZE)) > 0) {
 			op += charlen;
+			len -= charlen;
 		} else {
 			if (uni_xlate == 1) {
 				*op = ':';
@@ -149,15 +152,18 @@ static int uni16_to_x8(unsigned char *as
 					ec >>= 4;
 				}
 				op += 5;
+				len -= 5;
 			} else {
 				*op++ = '?';
+				len--;
 			}
 		}
-		/* We have some slack there, so it's OK */
-		if (op>ascii+256) {
-			op = ascii + 256;
-			break;
-		}
+	}
+	
+	if(unlikely(*ip)) {
+		printk(KERN_WARNING
+			"FAT: truncated while convert unicode characters in %s\n",
+			__FUNCTION__);
 	}
 	*op = 0;
 	return (op - ascii);
@@ -311,9 +317,11 @@ int fat_search_long(struct inode *inode,
 	struct nls_table *nls_io = sbi->nls_io;
 	struct nls_table *nls_disk = sbi->nls_disk;
 	wchar_t bufuname[14];
-	unsigned char xlate_len, nr_slots;
+	int xlate_len;
+	unsigned char nr_slots;
 	wchar_t *unicode = NULL;
-	unsigned char work[8], bufname[260];	/* 256 + 4 */
+	unsigned char work[8];
+	unsigned char *bufname = NULL;
 	int uni_xlate = sbi->options.unicode_xlate;
 	int utf8 = sbi->options.utf8;
 	int anycase = (sbi->options.name_check != 's');
@@ -321,6 +329,10 @@ int fat_search_long(struct inode *inode,
 	loff_t cpos = 0;
 	int chl, i, j, last_u, err;
 
+	bufname = (unsigned char*)__get_free_page(GFP_KERNEL);
+	if (!bufname) {
+		return -ENOMEM;
+	}
 	err = -ENOENT;
 	while(1) {
 		if (fat_get_entry(inode, &cpos, &bh, &de) == -1)
@@ -383,8 +395,8 @@ parse_record:
 
 		bufuname[last_u] = 0x0000;
 		xlate_len = utf8
-			?utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			:uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
+			?utf8_wcstombs(bufname, bufuname, PAGE_SIZE)
+			:uni16_to_x8(bufname, bufuname, PAGE_SIZE, uni_xlate, nls_io);
 		if (xlate_len == name_len)
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
 			    (anycase && !nls_strnicmp(nls_io, name, bufname,
@@ -393,8 +405,8 @@ parse_record:
 
 		if (nr_slots) {
 			xlate_len = utf8
-				?utf8_wcstombs(bufname, unicode, sizeof(bufname))
-				:uni16_to_x8(bufname, unicode, uni_xlate, nls_io);
+				?utf8_wcstombs(bufname, unicode, PAGE_SIZE)
+				:uni16_to_x8(bufname, unicode, PAGE_SIZE, uni_xlate, nls_io);
 			if (xlate_len != name_len)
 				continue;
 			if ((!anycase && !memcmp(name, bufname, xlate_len)) ||
@@ -413,6 +425,8 @@ Found:
 	sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
 	err = 0;
 EODir:
+	if (bufname)
+		free_page((unsigned long)bufname);
 	if (unicode)
 		free_page((unsigned long)unicode);
 
@@ -593,7 +607,7 @@ parse_record:
 	if (isvfat) {
 		bufuname[j] = 0x0000;
 		i = utf8 ? utf8_wcstombs(bufname, bufuname, sizeof(bufname))
-			 : uni16_to_x8(bufname, bufuname, uni_xlate, nls_io);
+			 : uni16_to_x8(bufname, bufuname, sizeof(bufname), uni_xlate, nls_io);
 	}
 
 	fill_name = bufname;
@@ -605,7 +619,7 @@ parse_record:
 		int buf_size = PAGE_SIZE - (261 * sizeof(unicode[0]));
 		int long_len = utf8
 			? utf8_wcstombs(longname, unicode, buf_size)
-			: uni16_to_x8(longname, unicode, uni_xlate, nls_io);
+			: uni16_to_x8(longname, unicode, buf_size, uni_xlate, nls_io);
 
 		if (!both) {
 			fill_name = longname;


