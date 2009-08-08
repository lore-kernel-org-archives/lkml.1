Return-Path: <linux-kernel-owner+w=401wt.eu-S933959AbZHHKK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959AbZHHKK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZHHKK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:10:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52707 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZHHKK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:10:57 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fat: Read buffer overflow
References: <4A7CAF28.8020908@gmail.com> <87y6pvi5qp.fsf@devron.myhome.or.jp>
	<84144f020908072356r5cc3100dp79a6a508bafec7c7@mail.gmail.com>
Date: Sat, 08 Aug 2009 19:10:53 +0900
In-Reply-To: <84144f020908072356r5cc3100dp79a6a508bafec7c7@mail.gmail.com>
	(Pekka Enberg's message of "Sat, 8 Aug 2009 09:56:21 +0300")
Message-ID: <87prb6pqdu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg <penberg@cs.helsinki.fi> writes:

> Yes, but we pass "ulen" to vfat_is_used_badchars(). The value of
> "ulen" is a returned in the "longlen" argument of xlate_to_uni() which
> in turn is calculated as follows for the UTF-8 case:
>
>   int name_len = strlen(name);
>   *outlen = utf8s_to_utf16s(name, PATH_MAX, (wchar_t *) outname);
>   *outlen -= (name_len - len);
>   *longlen = *outlen;
>
> Maybe "*outlen" can never be negative because of some invariants that
> I don't see but it's so non-obvious to me that I'd like to see the
> explicit check in vfat_is_used_badchars().

Ah, good point. Sorry, I was looking my tree. I'm going to submit the
attached patch on next merge window.

Is this enough for it?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


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
---

 fs/fat/namei_vfat.c |   15 ++++-----------
 fs/nls/nls_base.c   |    8 ++++----
 2 files changed, 8 insertions(+), 15 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-utf8-invalid-char fs/fat/namei_vfat.c
--- linux-2.6/fs/fat/namei_vfat.c~vfat-utf8-invalid-char	2009-08-01 15:25:36.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_vfat.c	2009-08-01 21:26:42.000000000 +0900
@@ -499,17 +499,10 @@ xlate_to_uni(const unsigned char *name, 
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
diff -puN fs/nls/nls_base.c~vfat-utf8-invalid-char fs/nls/nls_base.c
--- linux-2.6/fs/nls/nls_base.c~vfat-utf8-invalid-char	2009-08-01 15:25:36.000000000 +0900
+++ linux-2.6-hirofumi/fs/nls/nls_base.c	2009-08-01 15:25:36.000000000 +0900
@@ -124,10 +124,10 @@ int utf8s_to_utf16s(const u8 *s, int len
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
_
