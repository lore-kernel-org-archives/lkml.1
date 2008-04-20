Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYDTSYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYDTSYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYDTSYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:24:35 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45906 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbYDTSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:24:34 -0400
X-Greylist: delayed 665 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 14:24:34 EDT
Subject: [PATCH 4/9] fat: Add allow_utime option
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:26 +0900
Message-ID: <f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
	<954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
In-Reply-To: <954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Normally utime(2) checks current process is owner of the file, or it
has CAP_FOWNER capability.  But FAT filesystem doesn't have uid/gid as
on disk info, so normal check is too unflexible.

With this option you can relax it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 Documentation/filesystems/vfat.txt |   15 +++++++++++++++
 fs/fat/file.c                      |   24 ++++++++++++++++++++++++
 fs/fat/inode.c                     |   18 +++++++++++++++---
 include/linux/msdos_fs.h           |    1 +
 4 files changed, 55 insertions(+), 3 deletions(-)

diff -puN fs/fat/file.c~fat_allow_utime fs/fat/file.c
--- linux-2.6/fs/fat/file.c~fat_allow_utime	2008-03-14 05:02:22.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/file.c	2008-03-14 05:36:19.000000000 +0900
@@ -278,11 +278,27 @@ static int fat_check_mode(const struct m
 	return 0;
 }
 
+static int fat_allow_set_time(struct msdos_sb_info *sbi, struct inode *inode)
+{
+	mode_t allow_utime = sbi->options.allow_utime;
+
+	if (current->fsuid != inode->i_uid) {
+		if (in_group_p(inode->i_gid))
+			allow_utime >>= 3;
+		if (allow_utime & MAY_WRITE)
+			return 1;
+	}
+
+	/* use a default check */
+	return 0;
+}
+
 int fat_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
 	int mask, error = 0;
+	unsigned int ia_valid;
 
 	lock_kernel();
 
@@ -300,7 +316,15 @@ int fat_setattr(struct dentry *dentry, s
 		}
 	}
 
+	/* Check for setting the inode time. */
+	ia_valid = attr->ia_valid;
+	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET)) {
+		if (fat_allow_set_time(sbi, inode))
+			attr->ia_valid &= ~(ATTR_MTIME_SET | ATTR_ATIME_SET);
+	}
+
 	error = inode_change_ok(inode, attr);
+	attr->ia_valid = ia_valid;
 	if (error) {
 		if (sbi->options.quiet)
 			error = 0;
diff -puN fs/fat/inode.c~fat_allow_utime fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_allow_utime	2008-03-14 05:02:22.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-03-14 05:35:37.000000000 +0900
@@ -785,6 +785,8 @@ static int fat_show_options(struct seq_f
 		seq_printf(m, ",gid=%u", opts->fs_gid);
 	seq_printf(m, ",fmask=%04o", opts->fs_fmask);
 	seq_printf(m, ",dmask=%04o", opts->fs_dmask);
+	if (opts->allow_utime)
+		seq_printf(m, ",allow_utime=%04o", opts->allow_utime);
 	if (sbi->nls_disk)
 		seq_printf(m, ",codepage=%s", sbi->nls_disk->charset);
 	if (isvfat) {
@@ -840,9 +842,9 @@ static int fat_show_options(struct seq_f
 
 enum {
 	Opt_check_n, Opt_check_r, Opt_check_s, Opt_uid, Opt_gid,
-	Opt_umask, Opt_dmask, Opt_fmask, Opt_codepage, Opt_usefree, Opt_nocase,
-	Opt_quiet, Opt_showexec, Opt_debug, Opt_immutable,
-	Opt_dots, Opt_nodots,
+	Opt_umask, Opt_dmask, Opt_fmask, Opt_allow_utime, Opt_codepage,
+	Opt_usefree, Opt_nocase, Opt_quiet, Opt_showexec, Opt_debug,
+	Opt_immutable, Opt_dots, Opt_nodots,
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
@@ -861,6 +863,7 @@ static match_table_t fat_tokens = {
 	{Opt_umask, "umask=%o"},
 	{Opt_dmask, "dmask=%o"},
 	{Opt_fmask, "fmask=%o"},
+	{Opt_allow_utime, "allow_utime=%o"},
 	{Opt_codepage, "codepage=%u"},
 	{Opt_usefree, "usefree"},
 	{Opt_nocase, "nocase"},
@@ -932,6 +935,7 @@ static int parse_options(char *options, 
 	opts->fs_uid = current->uid;
 	opts->fs_gid = current->gid;
 	opts->fs_fmask = opts->fs_dmask = current->fs->umask;
+	opts->allow_utime = -1;
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
 	if (is_vfat)
@@ -1019,6 +1023,11 @@ static int parse_options(char *options, 
 				return 0;
 			opts->fs_fmask = option;
 			break;
+		case Opt_allow_utime:
+			if (match_octal(&args[0], &option))
+				return 0;
+			opts->allow_utime = option & (S_IWGRP | S_IWOTH);
+			break;
 		case Opt_codepage:
 			if (match_int(&args[0], &option))
 				return 0;
@@ -1101,6 +1110,9 @@ static int parse_options(char *options, 
 		       " for FAT filesystems, filesystem will be case sensitive!\n");
 	}
 
+	/* If user doesn't specify allow_utime, it's initialized from dmask. */
+	if (opts->allow_utime == (unsigned short)-1)
+		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
 
diff -puN include/linux/msdos_fs.h~fat_allow_utime include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_allow_utime	2008-03-14 05:02:22.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-03-14 05:35:37.000000000 +0900
@@ -195,6 +195,7 @@ struct fat_mount_options {
 	char *iocharset;          /* Charset used for filename input/display */
 	unsigned short shortname; /* flags for shortname display/create rule */
 	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
+	unsigned short allow_utime;/* permission for setting the [am]time */
 	unsigned quiet:1,         /* set = fake successful chmods and chowns */
 		 showexec:1,      /* set = only set x bit for com/exe/bat */
 		 sys_immutable:1, /* set = system files are immutable */
diff -puN Documentation/filesystems/vfat.txt~fat_allow_utime Documentation/filesystems/vfat.txt
--- linux-2.6/Documentation/filesystems/vfat.txt~fat_allow_utime	2008-03-14 05:02:22.000000000 +0900
+++ linux-2.6-hirofumi/Documentation/filesystems/vfat.txt	2008-03-14 05:02:22.000000000 +0900
@@ -17,6 +17,21 @@ dmask=###     -- The permission mask for
 fmask=###     -- The permission mask for files.
                  The default is the umask of current process.
 
+allow_utime=### -- This option controls the permission check of mtime/atime.
+
+                  20 - If current process is in group of file's group ID,
+                       you can change timestamp.
+                   2 - Other users can change timestamp.
+
+                 The default is set from `dmask' option. (If the directory is
+                 writable, utime(2) is also allowed. I.e. ~dmask & 022)
+
+                 Normally utime(2) checks current process is owner of
+                 the file, or it has CAP_FOWNER capability.  But FAT
+                 filesystem doesn't have uid/gid on disk, so normal
+                 check is too unflexible. With this option you can
+                 relax it.
+
 codepage=###  -- Sets the codepage number for converting to shortname
 		 characters on FAT filesystem.
 		 By default, FAT_DEFAULT_CODEPAGE setting is used.
_
