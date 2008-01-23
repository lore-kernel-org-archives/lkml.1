Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYAWSsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYAWSsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYAWSry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:47:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49891 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYAWSrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:47:53 -0500
Date: Wed, 23 Jan 2008 19:47:52 +0100
From: Jan Kara <jack@suse.cz>
To: "Ilya N. Golubev" <gin@mo.msk.ru>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Implement dmode option for isofs
Message-ID: <20080123184752.GE23304@atrey.karlin.mff.cuni.cz>
References: <518x2n9jgn.fsf@mo.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518x2n9jgn.fsf@mo.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> Versions: `2.6.17-1.2142_FC4' (fedora core) for x86_64;
> `kernel-syms-2.6.22.5-31' (opensuse 10.3) for i586.
> 
> File system may contain data not to let any logged in user read.  Wish
> to specify more restrictive mode of files in it - files of all types,
> including not only regular ones, but also directories, even root one
> of the file system.  This certainly must occur on mount itself, not in
> subsequent `chmod' calls.  There is at least one obvious reason to
> avoid explicit `chmod', just as many other uses of it: possible race
> condition between it and other process opening the file.
  I'd say the main reason is that iso9660 filesystem is usually mounted
read-only so that rules out chmod ;). But whatever...

> When mounting read- only iso9660 file system, `mount' ignores
> `mode=0400' file system option, at least for directories.  More
> precisely,
> 
> mount -nv -t iso9660 -o ro,norock,mode=0400,uid=ID_OF_REGULAR_USER DEVICE DIR
> 
> completes without error messages and leaves DIR mounted, but with mode
> `r-xr-xr-x'.  DIR uid is as specified.
  It doesn't ignore it. But 'mode' option affects only regular files.

> Also ran that command in `strace -emount'.  Its outputs:
> 
> mount("DEVICE", "DIR", "iso9660", MS_RDONLY|MS_POSIXACL|MS_ACTIVE|MS_NOUSER|0xec0000, 0x50fe60) = 0
> 
> suggesting that data converted from `-o' argument are actually passed
> to the kernel.  Permissions of regular files in mounted file system
> are `0400', that is, restricted properly.  This suggests that the
> request to restrict permissions, or at least part of it, is passed to
> kernel.  However, kernel does not honor the request wrt directories in
> mounted file system - or at best needs a separate request for
> permissions of directories, which `mount' program does not make.
  Hmm, maybe we could do it the similar way as FAT does it. Introduce
option dmode which would influence directories.
  The patch below does that. Andrew, we don't seem to have a maintainer
for isofs, can you include the patch? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
---

Implement dmode option for iso9660 filesystem to allow setting of access
rights for directories on the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 09e3d30..2368067 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -145,7 +145,8 @@ struct iso9660_options{
 	char nocompress;
 	unsigned char check;
 	unsigned int blocksize;
-	mode_t mode;
+	mode_t fmode;
+	mode_t dmode;
 	gid_t gid;
 	uid_t uid;
 	char *iocharset;
@@ -306,7 +307,7 @@ enum {
 	Opt_block, Opt_check_r, Opt_check_s, Opt_cruft, Opt_gid, Opt_ignore,
 	Opt_iocharset, Opt_map_a, Opt_map_n, Opt_map_o, Opt_mode, Opt_nojoliet,
 	Opt_norock, Opt_sb, Opt_session, Opt_uid, Opt_unhide, Opt_utf8, Opt_err,
-	Opt_nocompress, Opt_hide, Opt_showassoc,
+	Opt_nocompress, Opt_hide, Opt_showassoc, Opt_dmode,
 };
 
 static match_table_t tokens = {
@@ -333,6 +334,7 @@ static match_table_t tokens = {
 	{Opt_uid, "uid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_mode, "mode=%u"},
+	{Opt_dmode, "dmode=%u"},
 	{Opt_block, "block=%u"},
 	{Opt_ignore, "conv=binary"},
 	{Opt_ignore, "conv=b"},
@@ -360,7 +362,7 @@ static int parse_options(char *options, struct iso9660_options *popt)
 	popt->check = 'u';		/* unset */
 	popt->nocompress = 0;
 	popt->blocksize = 1024;
-	popt->mode = S_IRUGO | S_IXUGO; /*
+	popt->fmode = popt->dmode = S_IRUGO | S_IXUGO; /*
 					 * r-x for all.  The disc could
 					 * be shared with DOS machines so
 					 * virtually anything could be
@@ -452,7 +454,12 @@ static int parse_options(char *options, struct iso9660_options *popt)
 		case Opt_mode:
 			if (match_int(&args[0], &option))
 				return 0;
-			popt->mode = option;
+			popt->fmode = option;
+			break;
+		case Opt_dmode:
+			if (match_int(&args[0], &option))
+				return 0;
+			popt->dmode = option;
 			break;
 		case Opt_block:
 			if (match_int(&args[0], &option))
@@ -802,7 +809,8 @@ root_found:
 	 * on the disk as suid, so we merely allow them to set the default
 	 * permissions.
 	 */
-	sbi->s_mode = opt.mode & 0777;
+	sbi->s_fmode = opt.fmode & 0777;
+	sbi->s_dmode = opt.dmode & 0777;
 
 	/*
 	 * Read the root inode, which _may_ result in changing
@@ -1235,7 +1243,7 @@ static void isofs_read_inode(struct inode *inode)
 	ei->i_file_format = isofs_file_normal;
 
 	if (de->flags[-high_sierra] & 2) {
-		inode->i_mode = S_IRUGO | S_IXUGO | S_IFDIR;
+		inode->i_mode = sbi->s_dmode | S_IFDIR;
 		inode->i_nlink = 1;	/*
 					 * Set to 1.  We know there are 2, but
 					 * the find utility tries to optimize
@@ -1245,9 +1253,8 @@ static void isofs_read_inode(struct inode *inode)
 					 */
 	} else {
 		/* Everybody gets to read the file. */
-		inode->i_mode = sbi->s_mode;
+		inode->i_mode = sbi->s_fmode | S_IFREG;
 		inode->i_nlink = 1;
-		inode->i_mode |= S_IFREG;
 	}
 	inode->i_uid = sbi->s_uid;
 	inode->i_gid = sbi->s_gid;
diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
index f3213f9..d1bdf8a 100644
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -51,7 +51,8 @@ struct isofs_sb_info {
 	unsigned char s_hide;
 	unsigned char s_showassoc;
 
-	mode_t s_mode;
+	mode_t s_fmode;
+	mode_t s_dmode;
 	gid_t s_gid;
 	uid_t s_uid;
 	struct nls_table *s_nls_iocharset; /* Native language support table */
