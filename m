Return-Path: <linux-kernel-owner+w=401wt.eu-S1030938AbXDVPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030938AbXDVPNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030940AbXDVPNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 11:13:20 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4010 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030938AbXDVPNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 11:13:19 -0400
X-AuthUser: hirofumi@parknet.jp
To: Andreas Schwab <schwab@suse.de>
Cc: 7eggert@gmx.de, Juergen Beisert <juergen127@kreuzholzen.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wrong free clusters count on FAT32
References: <8bAF0-3Yj-29@gated-at.bofh.it> <8bDta-8rc-31@gated-at.bofh.it>
	<8bFEr-3B4-1@gated-at.bofh.it> <8cwz8-2fE-13@gated-at.bofh.it>
	<E1Hfc7X-00010D-09@be1.lrz> <87wt04sdyb.fsf@duaron.myhome.or.jp>
	<877is4scre.fsf@duaron.myhome.or.jp> <jewt04e9zn.fsf@sykes.suse.de>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 23 Apr 2007 00:13:11 +0900
In-Reply-To: <jewt04e9zn.fsf@sykes.suse.de> (Andreas Schwab's message of "Sun\, 22 Apr 2007 16\:53\:32 +0200")
Message-ID: <873b2ssarc.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab <schwab@suse.de> writes:

> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>
>> diff -puN Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32 Documentation/filesystems/vfat.txt
>> --- linux-2.6/Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32	2007-04-22 23:06:21.000000000 +0900
>> +++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2007-04-22 23:28:19.000000000 +0900
>> @@ -34,6 +34,13 @@ iocharset=name -- Character set to use f
>>  		 NOTE: "iocharset=utf8" is not recommended. If unsure,
>>  		 you should consider the following option instead.
>
> "the following option" is no longer correct.

Whoops. Thanks for correcting it.
The patch was fixed.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



It seems that the recent Windows changed specification, and it's
undocumented. Windows doesn't update ->free_clusters correctly.

This patch doesn't use ->free_clusters by default. (instead, add
"usefree" for forcing to use it)

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 Documentation/filesystems/vfat.txt |    7 +++++++
 fs/fat/inode.c                     |   14 +++++++++++---
 include/linux/msdos_fs.h           |    3 ++-
 3 files changed, 20 insertions(+), 4 deletions(-)

diff -puN fs/fat/inode.c~fat_dont-use_free_clusters-for-fat32 fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_dont-use_free_clusters-for-fat32	2007-04-22 13:07:05.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2007-04-22 13:18:07.000000000 +0900
@@ -825,6 +825,8 @@ static int fat_show_options(struct seq_f
 	}
 	if (opts->name_check != 'n')
 		seq_printf(m, ",check=%c", opts->name_check);
+	if (opts->usefree)
+		seq_puts(m, ",usefree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
 	if (opts->showexec)
@@ -850,7 +852,7 @@ static int fat_show_options(struct seq_f
 
 enum {
 	Opt_check_n, Opt_check_r, Opt_check_s, Opt_uid, Opt_gid,
-	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_nocase,
+	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_usefree, Opt_nocase,
 	Opt_quiet, Opt_showexec, Opt_debug, Opt_immutable,
 	Opt_dots, Opt_nodots,
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
@@ -872,6 +874,7 @@ static match_table_t fat_tokens = {
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
 	{Opt_codepage, "codepage=%u"},
+	{Opt_usefree, "usefree"},
 	{Opt_nocase, "nocase"},
 	{Opt_quiet, "quiet"},
 	{Opt_showexec, "showexec"},
@@ -951,7 +954,7 @@ static int parse_options(char *options, 
 	opts->quiet = opts->showexec = opts->sys_immutable = opts->dotsOK =  0;
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
-	opts->nocase = 0;
+	opts->usefree = opts->nocase = 0;
 	*debug = 0;
 
 	if (!options)
@@ -979,6 +982,9 @@ static int parse_options(char *options, 
 		case Opt_check_n:
 			opts->name_check = 'n';
 			break;
+		case Opt_usefree:
+			opts->usefree = 1;
+			break;
 		case Opt_nocase:
 			if (!is_vfat)
 				opts->nocase = 1;
@@ -1306,7 +1312,9 @@ int fat_fill_super(struct super_block *s
 			       le32_to_cpu(fsinfo->signature2),
 			       sbi->fsinfo_sector);
 		} else {
-			sbi->free_clusters = le32_to_cpu(fsinfo->free_clusters);
+			if (sbi->options.usefree)
+				sbi->free_clusters =
+					le32_to_cpu(fsinfo->free_clusters);
 			sbi->prev_free = le32_to_cpu(fsinfo->next_cluster);
 		}
 
diff -puN include/linux/msdos_fs.h~fat_dont-use_free_clusters-for-fat32 include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_dont-use_free_clusters-for-fat32	2007-04-22 13:07:05.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2007-04-22 13:09:14.000000000 +0900
@@ -205,7 +205,8 @@ struct fat_mount_options {
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
 		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
-		 nocase:1;	  /* Does this need case conversion? 0=need case conversion*/
+		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
+		 usefree:1;	  /* Use free_clusters for FAT32 */
 };
 
 #define FAT_HASH_BITS	8
diff -puN Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32 Documentation/filesystems/vfat.txt
--- linux-2.6/Documentation/filesystems/vfat.txt~fat_dont-use_free_clusters-for-fat32	2007-04-22 23:06:21.000000000 +0900
+++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2007-04-23 00:09:35.000000000 +0900
@@ -57,6 +57,13 @@ nonumtail=<bool> -- When creating 8.3 al
                  currently exist in the directory, 'longfile.txt' will
                  be the short alias instead of 'longfi~1.txt'. 
                   
+usefree       -- Use the "free clusters" value stored on FSINFO. It'll
+                 be used to determine number of free clusters without
+                 scanning disk. But it's not used by default, because
+                 recent Windows don't update it correctly in some
+                 case. If you are sure the "free clusters" on FSINFO is
+                 correct, by this option you can avoid scanning disk.
+
 quiet         -- Stops printing certain warning messages.
 
 check=s|r|n   -- Case sensitivity checking setting.
_
