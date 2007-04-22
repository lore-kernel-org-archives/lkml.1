Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXDVE0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXDVE0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 00:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXDVE0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 00:26:33 -0400
Received: from mail.parknet.jp ([210.171.160.80]:3892 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbXDVE0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 00:26:32 -0400
X-AuthUser: hirofumi@parknet.jp
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
References: <20070419085750.GA2833@DervishD>
	<200704191352.06456.juergen127@kreuzholzen.de>
	<20070419141942.GF8287@DervishD> <87d51xtkmp.fsf@duaron.myhome.or.jp>
	<20070421201841.85717088.akpm@linux-foundation.org>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 22 Apr 2007 13:26:24 +0900
In-Reply-To: <20070421201841.85717088.akpm@linux-foundation.org> (Andrew Morton's message of "Sat\, 21 Apr 2007 20\:18\:41 -0700")
Message-ID: <87wt05vxu7.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 22 Apr 2007 07:42:22 +0900 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>
>> Recent Windows doesn't update ->free_clusters correctly. The "nofree"
>> option ignores the ->free_clusters stored on FSINFO.
>
> It'd be better to avoid the new mount option if possible: fatfs is used by
> a *lot* of people who aren't particualrly expert, and we want to make things
> easy for them.

Ok.

> Is there some way in which we can work out what's happened and fix it up?

It seems that the recent Windows changed specification, and it's
undocumented. Windows doesn't update ->free_clusters correctly.

Probably, what we can do is to throw away speed of statfs(2) and not
using ->free_clusters. (And if possible, recover it by optimization.)

This patch doesn't use ->free_clusters by default. (instead, add
"usefree" for forcing to use it)
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=fat_dont-use_free_clusters-for-fat32.patch


It seems that the recent Windows changed specification, and it's
undocumented. Windows doesn't update ->free_clusters correctly.

This patch doesn't use ->free_clusters by default. (instead, add
"usefree" for forcing to use it)

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c           |   14 +++++++++++---
 include/linux/msdos_fs.h |    3 ++-
 2 files changed, 13 insertions(+), 4 deletions(-)

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
_

--=-=-=--
