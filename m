Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXDUWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXDUWmd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXDUWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:42:33 -0400
Received: from mail.parknet.jp ([210.171.160.80]:3859 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXDUWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:42:32 -0400
X-AuthUser: hirofumi@parknet.jp
To: Juergen Beisert <juergen127@kreuzholzen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wrong free clusters count on FAT32
References: <20070419085750.GA2833@DervishD>
	<200704191352.06456.juergen127@kreuzholzen.de>
	<20070419141942.GF8287@DervishD>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Sun, 22 Apr 2007 07:42:22 +0900
In-Reply-To: <20070419141942.GF8287@DervishD> (DervishD's message of "Thu\, 19 Apr 2007 16\:19\:42 +0200")
Message-ID: <87d51xtkmp.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.98 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

DervishD <lkml@dervishd.net> writes:

>  * Juergen Beisert <juergen127@kreuzholzen.de> dixit:
>> On Thursday 19 April 2007 10:57, DervishD wrote:
>> > I have a portable device with a FAT32 formatted hard disk in it, and
>> > everytime I delete a file in the device *using the device itself to
>> > do it* the device increases its count of free space and if I plug
>> > the device in a Windows system, Windows agrees on the free space.
>> > Linux doesn't. Linux believes that the files are still there
>> > ocuppying space, and I have to run fsck.vfat to fix the problem.
>> 
>> As I remember: It needs a large amount of time to calculate the free
>> space on a big FAT32 system.
>
>     Big fat truth, I'm afraid. The thing is that I thought that Linux
> did that from time to time to update the count. Obviously, doing it for
> every statfs call would be very expensive :((
>
>> So the last free sector count is also stored. When mounting this
>> filesystem you don't need to walk through the whole FAT to calculate
>> the available space, you can use this "cached" value instead. And this
>> cached value seems not to be updated in your portable device.
>
>     It doesn't, certainly, but Windows doesn't care. Moreover, the
> device doesn't seem to recalculate the value on every run (unless it
> does it lightning fast!), so maybe the number is stored elsewhere (the
> count can be stored in many places as far as I've read, but I don't know
> the details).
>
>     A mount option to force walking the FAT and getting the real info
> could be interesting. That way, it will be only done for certain devices
> (small disks, for example).

Yes. It seems that Windows does not update the ->free_clusters correctly. 
Probably, I think the option is good for now. What do you think about
an attached patch?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=fat_ignore_free_clusters.patch


Recent Windows doesn't update ->free_clusters correctly. The "nofree"
option ignores the ->free_clusters stored on FSINFO.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/inode.c           |   13 ++++++++++---
 include/linux/msdos_fs.h |    3 ++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/fat/inode.c~fat_ignore_free_clusters fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_ignore_free_clusters	2007-04-22 07:30:13.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2007-04-22 07:30:13.000000000 +0900
@@ -825,6 +825,8 @@ static int fat_show_options(struct seq_f
 	}
 	if (opts->name_check != 'n')
 		seq_printf(m, ",check=%c", opts->name_check);
+	if (opts->nofree)
+		seq_puts(m, ",nofree");
 	if (opts->quiet)
 		seq_puts(m, ",quiet");
 	if (opts->showexec)
@@ -850,7 +852,7 @@ static int fat_show_options(struct seq_f
 
 enum {
 	Opt_check_n, Opt_check_r, Opt_check_s, Opt_uid, Opt_gid,
-	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_nocase,
+	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_nofree, Opt_nocase,
 	Opt_quiet, Opt_showexec, Opt_debug, Opt_immutable,
 	Opt_dots, Opt_nodots,
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
@@ -872,6 +874,7 @@ static match_table_t fat_tokens = {
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
 	{Opt_codepage, "codepage=%u"},
+	{Opt_nofree, "nofree"},
 	{Opt_nocase, "nocase"},
 	{Opt_quiet, "quiet"},
 	{Opt_showexec, "showexec"},
@@ -951,7 +954,7 @@ static int parse_options(char *options, 
 	opts->quiet = opts->showexec = opts->sys_immutable = opts->dotsOK =  0;
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
-	opts->nocase = 0;
+	opts->nofree = opts->nocase = 0;
 	*debug = 0;
 
 	if (!options)
@@ -979,6 +982,9 @@ static int parse_options(char *options, 
 		case Opt_check_n:
 			opts->name_check = 'n';
 			break;
+		case Opt_nofree:
+			opts->nofree = 1;
+			break;
 		case Opt_nocase:
 			if (!is_vfat)
 				opts->nocase = 1;
@@ -1352,7 +1358,8 @@ int fat_fill_super(struct super_block *s
 
 	sbi->max_cluster = total_clusters + FAT_START_ENT;
 	/* check the free_clusters, it's not necessarily correct */
-	if (sbi->free_clusters != -1 && sbi->free_clusters > total_clusters)
+	if ((sbi->free_clusters != -1 && sbi->free_clusters > total_clusters) ||
+	    sbi->options.nofree)
 		sbi->free_clusters = -1;
 	/* check the prev_free, it's not necessarily correct */
 	sbi->prev_free %= sbi->max_cluster;
diff -puN include/linux/msdos_fs.h~fat_ignore_free_clusters include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_ignore_free_clusters	2007-04-22 07:30:13.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2007-04-22 07:30:13.000000000 +0900
@@ -205,7 +205,8 @@ struct fat_mount_options {
 		 numtail:1,       /* Does first alias have a numeric '~1' type tail? */
 		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
-		 nocase:1;	  /* Does this need case conversion? 0=need case conversion*/
+		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
+		 nofree:1;	  /* Does use free_clusters */
 };
 
 #define FAT_HASH_BITS	8
_

--=-=-=--
