Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbYEYMLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbYEYMLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759251AbYEYMLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:11:43 -0400
Received: from india601.server4you.de ([85.25.151.105]:50534 "EHLO
	india601.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618AbYEYMLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:11:42 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 08:11:42 EDT
Subject: [PATCH] msdos fs: remove unsettable atari option
From: =?ISO-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 25 May 2008 14:04:22 +0200
Message-Id: <1211717062.5782.16.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been impossible to set the option 'atari' of the MSDOS filesystem
for several years.  Since nobody seems to have missed it, let's remove
its remains.

Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
---

 fs/msdos/namei.c         |   18 ++++++------------
 include/linux/msdos_fs.h |    1 -
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/msdos/namei.c b/fs/msdos/namei.c
index 05ff4f1..8240d22 100644
--- a/fs/msdos/namei.c
+++ b/fs/msdos/namei.c
@@ -14,12 +14,7 @@
 
 /* Characters that are undesirable in an MS-DOS file name */
 static unsigned char bad_chars[] = "*?<>|\"";
-static unsigned char bad_if_strict_pc[] = "+=,; ";
-/* GEMDOS is less restrictive */
-static unsigned char bad_if_strict_atari[] = " ";
-
-#define bad_if_strict(opts) \
-	((opts)->atari ? bad_if_strict_atari : bad_if_strict_pc)
+static unsigned char bad_if_strict[] = "+=,; ";
 
 /***** Formats an MS-DOS file name. Rejects invalid names. */
 static int msdos_format_name(const unsigned char *name, int len,
@@ -40,21 +35,20 @@ static int msdos_format_name(const unsigned char *name, int len,
 			/* Get rid of dot - test for it elsewhere */
 			name++;
 			len--;
-		} else if (!opts->atari)
+		} else
 			return -EINVAL;
 	}
 	/*
-	 * disallow names that _really_ start with a dot for MS-DOS,
-	 * GEMDOS does not care
+	 * disallow names that _really_ start with a dot
 	 */
-	space = !opts->atari;
+	space = 1;
 	c = 0;
 	for (walk = res; len && walk - res < 8; walk++) {
 		c = *name++;
 		len--;
 		if (opts->name_check != 'r' && strchr(bad_chars, c))
 			return -EINVAL;
-		if (opts->name_check == 's' && strchr(bad_if_strict(opts), c))
+		if (opts->name_check == 's' && strchr(bad_if_strict, c))
 			return -EINVAL;
 		if (c >= 'A' && c <= 'Z' && opts->name_check == 's')
 			return -EINVAL;
@@ -94,7 +88,7 @@ static int msdos_format_name(const unsigned char *name, int len,
 			if (opts->name_check != 'r' && strchr(bad_chars, c))
 				return -EINVAL;
 			if (opts->name_check == 's' &&
-			    strchr(bad_if_strict(opts), c))
+			    strchr(bad_if_strict, c))
 				return -EINVAL;
 			if (c < ' ' || c == ':' || c == '\\')
 				return -EINVAL;
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index b03b274..ceb5d16 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -208,7 +208,6 @@ struct fat_mount_options {
 		 utf8:1,	  /* Use of UTF-8 character set (Default) */
 		 unicode_xlate:1, /* create escape sequences for unhandled Unicode */
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
-		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1;	  /* Use free_clusters for FAT32 */

