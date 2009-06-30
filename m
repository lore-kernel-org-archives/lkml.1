Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZF3CY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZF3CY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZF3CYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:24:48 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:53053 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZF3CYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:24:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: vfat creates multiple files with the same filename
References: <Pine.LNX.4.64.0906281935490.20945@cinke.fazekas.hu>
Date: Tue, 30 Jun 2009 11:24:47 +0900
In-Reply-To: <Pine.LNX.4.64.0906281935490.20945@cinke.fazekas.hu> (Marton
	Balint's message of "Sun, 28 Jun 2009 20:26:09 +0200 (CEST)")
Message-ID: <87tz1ylaq8.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marton Balint <cus@fazekas.hu> writes:

> I don't know if removing the invalid characters silently instead of 
> returning EINVAL is a good practice, but allowing two files with identical 
> filenames is definitely wrong. 

The utf8 function seems didn't return the error for invalid char.

> Could someone please have a look at the problem? Unfortunately I am not 
> qualified enough to track it down...
>
> I've run the testcase on both 2.6.30 and 2.6.31-rc1 kernels, but this bug 
> is probably not very new, since I remember having it also in 2.6.27.

This is quick hack though, this should return -EINVAL for invalid char
like nls.  Can you try this?

Um..., probably, if utf8s_to_utf16s() returned the both of the error and
converted length to handle invalid char by caller, it would be better.
However, the user of it seems to be only vfat.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/namei_vfat.c |   15 ++++-----------
 fs/nls/nls_base.c   |    8 ++++----
 2 files changed, 8 insertions(+), 15 deletions(-)

diff -puN fs/fat/namei_vfat.c~vfat-utf8-invalid-char fs/fat/namei_vfat.c
--- linux-2.6/fs/fat/namei_vfat.c~vfat-utf8-invalid-char	2009-06-30 10:09:32.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/namei_vfat.c	2009-06-30 10:24:48.000000000 +0900
@@ -500,17 +500,10 @@ xlate_to_uni(const unsigned char *name, 
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
--- linux-2.6/fs/nls/nls_base.c~vfat-utf8-invalid-char	2009-06-30 10:10:04.000000000 +0900
+++ linux-2.6-hirofumi/fs/nls/nls_base.c	2009-06-30 10:10:54.000000000 +0900
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

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
