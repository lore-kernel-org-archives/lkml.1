Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZHATTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZHATTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZHATTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 15:19:31 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:35040 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZHATTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 15:19:30 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [review] fat/nls: Fix handling of utf8 invalid char
Date: Sun, 02 Aug 2009 04:19:26 +0900
Message-ID: <87iqh7wddt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm going to send this patch at next merge window. This is including the
change of fs/nls_base.c, it's trivial though. And it seems you changed
the fs/nls_base.c last time.

So, to make sure, could you review this if you have time?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 67638e4043083cdc6f10386a75fef87ba46eecb3
Author: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date:   Sat Aug 1 21:30:31 2009 +0900

    fat/nls: Fix handling of utf8 invalid char
    
    With utf8 option, vfat allowed the duplicated filenames.
    
    Normal nls returns -EINVAL for invalid char. But utf8s_to_utf16s()
    skipped the invalid char historically.
    
    So, this changes the utf8s_to_utf16s() directly to return -EINVAL for
    invalid char, because vfat is only user of it.
    
    mkdir /mnt/fatfs
    FILENAME=`echo -ne "invalidutf8char_\\0341_endofchar"`
    echo "Using filename: $FILENAME"
    dd if=/dev/zero of=fatfs bs=512 count=128
    mkdosfs -F 32 fatfs
    mount -o loop,utf8 fatfs /mnt/fatfs
    touch "/mnt/fatfs/$FILENAME"
    umount /mnt/fatfs
    mount -o loop,utf8 fatfs /mnt/fatfs
    touch "/mnt/fatfs/$FILENAME"
    ls -l /mnt/fatfs
    umount /mnt/fatfs
    
    ----  And the output is:
    
    Using filename: invalidutf8char_\0341_endofchar
    128+0 records in
    128+0 records out
    65536 bytes (66 kB) copied, 0.000388118 s, 169 MB/s
    mkdosfs 2.11 (12 Mar 2005)
    total 0
    -rwxr-xr-x 1 root root 0 Jun 28 19:46 invalidutf8char__endofchar
    -rwxr-xr-x 1 root root 0 Jun 28 19:46 invalidutf8char__endofchar
    
    Tested-by: Marton Balint <cus@fazekas.hu>
    Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index cb6e835..f565f24 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -499,17 +499,10 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 	int charlen;
 
 	if (utf8) {
-		int name_len = strlen(name);
-
-		*outlen = utf8s_to_utf16s(name, PATH_MAX, (wchar_t *) outname);
-
-		/*
-		 * We stripped '.'s before and set len appropriately,
-		 * but utf8s_to_utf16s doesn't care about len
-		 */
-		*outlen -= (name_len - len);
-
-		if (*outlen > 255)
+		*outlen = utf8s_to_utf16s(name, len, (wchar_t *)outname);
+		if (*outlen < 0)
+			return *outlen;
+		else if (*outlen > 255)
 			return -ENAMETOOLONG;
 
 		op = &outname[*outlen * sizeof(wchar_t)];
diff --git a/fs/nls/nls_base.c b/fs/nls/nls_base.c
index 477d37d..b25c218 100644
--- a/fs/nls/nls_base.c
+++ b/fs/nls/nls_base.c
@@ -124,10 +124,10 @@ int utf8s_to_utf16s(const u8 *s, int len, wchar_t *pwcs)
 	while (*s && len > 0) {
 		if (*s & 0x80) {
 			size = utf8_to_utf32(s, len, &u);
-			if (size < 0) {
-				/* Ignore character and move on */
-				size = 1;
-			} else if (u >= PLANE_SIZE) {
+			if (size < 0)
+				return -EINVAL;
+
+			if (u >= PLANE_SIZE) {
 				u -= PLANE_SIZE;
 				*op++ = (wchar_t) (SURROGATE_PAIR |
 						((u >> 10) & SURROGATE_BITS));
