Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYKPTxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYKPTxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 14:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYKPTxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 14:53:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:38480 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYKPTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 14:53:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cZxySJJp1Vonv75R4vpLb2HEdmILBba8YiymB6kgqRx90gzNbIbU1A8m+WW83Qs1o7
         gKFrUHAZH7OhZ2RQdKqWipA/6SMv6hEIEAunqKCLnug+DiOebwx0GMgWxpxIpza0SFH2
         uvsyWt5dMQlMdNCqN3kduPe1k9xqIOiAMOT2c=
Date: Sun, 16 Nov 2008 20:52:19 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] udf: implement mode and dmode mounting options
Message-ID: <20081116195129.GA5920@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dmode" allows overriding permissions of directories and
"mode" allows overriding permissions of files.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/udf.txt |    2 ++
 fs/udf/inode.c                    |   11 +++++++++--
 fs/udf/super.c                    |   31 ++++++++++++++++++++++++++++++-
 fs/udf/udf_sb.h                   |    2 ++
 4 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/udf.txt b/Documentation/filesystems/udf.txt
index fde829a..902b95d 100644
--- a/Documentation/filesystems/udf.txt
+++ b/Documentation/filesystems/udf.txt
@@ -24,6 +24,8 @@ The following mount options are supported:
 
 	gid=		Set the default group.
 	umask=		Set the default umask.
+	mode=		Set the default file permissions.
+	dmode=		Set the default directory permissions.
 	uid=		Set the default user.
 	bs=		Set the block size.
 	unhide		Show otherwise hidden files.
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6e74b11..6612a27 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1221,8 +1221,15 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 	inode->i_size = le64_to_cpu(fe->informationLength);
 	iinfo->i_lenExtents = inode->i_size;
 
-	inode->i_mode = udf_convert_permissions(fe);
-	inode->i_mode &= ~UDF_SB(inode->i_sb)->s_umask;
+	if (fe->icbTag.fileType != ICBTAG_FILE_TYPE_DIRECTORY &&
+			sbi->s_fmode != -1)
+		inode->i_mode = sbi->s_fmode;
+	else if (fe->icbTag.fileType == ICBTAG_FILE_TYPE_DIRECTORY &&
+			sbi->s_dmode != -1)
+		inode->i_mode = sbi->s_dmode;
+	else
+		inode->i_mode = udf_convert_permissions(fe);
+	inode->i_mode &= ~sbi->s_umask;
 
 	if (iinfo->i_efe == 0) {
 		inode->i_blocks = le64_to_cpu(fe->logicalBlocksRecorded) <<
diff --git a/fs/udf/super.c b/fs/udf/super.c
index dfe0277..e5d121d 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -201,6 +201,8 @@ struct udf_options {
 	mode_t umask;
 	gid_t gid;
 	uid_t uid;
+	mode_t fmode;
+	mode_t dmode;
 	struct nls_table *nls_map;
 };
 
@@ -282,6 +284,10 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
 		seq_printf(seq, ",gid=%u", sbi->s_gid);
 	if (sbi->s_umask != 0)
 		seq_printf(seq, ",umask=%o", sbi->s_umask);
+	if (sbi->s_fmode != -1)
+		seq_printf(seq, ",mode=%o", sbi->s_fmode);
+	if (sbi->s_dmode != -1)
+		seq_printf(seq, ",dmode=%o", sbi->s_dmode);
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
 		seq_printf(seq, ",session=%u", sbi->s_session);
 	if (UDF_QUERY_FLAG(sb, UDF_FLAG_LASTBLOCK_SET))
@@ -317,6 +323,8 @@ static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
  *
  *	gid=		Set the default group.
  *	umask=		Set the default umask.
+ *	mode=		Set the default file permissions.
+ *	dmode=		Set the default directory permissions.
  *	uid=		Set the default user.
  *	bs=		Set the block size.
  *	unhide		Show otherwise hidden files.
@@ -366,7 +374,8 @@ enum {
 	Opt_gid, Opt_uid, Opt_umask, Opt_session, Opt_lastblock,
 	Opt_anchor, Opt_volume, Opt_partition, Opt_fileset,
 	Opt_rootdir, Opt_utf8, Opt_iocharset,
-	Opt_err, Opt_uforget, Opt_uignore, Opt_gforget, Opt_gignore
+	Opt_err, Opt_uforget, Opt_uignore, Opt_gforget, Opt_gignore,
+	Opt_fmode, Opt_dmode
 };
 
 static const match_table_t tokens = {
@@ -395,6 +404,8 @@ static const match_table_t tokens = {
 	{Opt_rootdir,	"rootdir=%u"},
 	{Opt_utf8,	"utf8"},
 	{Opt_iocharset,	"iocharset=%s"},
+	{Opt_fmode,     "mode=%o"},
+	{Opt_dmode,     "dmode=%o"},
 	{Opt_err,	NULL}
 };
 
@@ -531,6 +542,16 @@ static int udf_parse_options(char *options, struct udf_options *uopt,
 		case Opt_gforget:
 			uopt->flags |= (1 << UDF_FLAG_GID_FORGET);
 			break;
+		case Opt_fmode:
+			if (match_octal(args, &option))
+				return 0;
+			uopt->fmode = option & 0777;
+			break;
+		case Opt_dmode:
+			if (match_octal(args, &option))
+				return 0;
+			uopt->dmode = option & 0777;
+			break;
 		default:
 			printk(KERN_ERR "udf: bad mount option \"%s\" "
 			       "or missing value\n", p);
@@ -560,6 +581,8 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	uopt.uid   = sbi->s_uid;
 	uopt.gid   = sbi->s_gid;
 	uopt.umask = sbi->s_umask;
+	uopt.fmode = sbi->s_fmode;
+	uopt.dmode = sbi->s_dmode;
 
 	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
@@ -568,6 +591,8 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	sbi->s_uid   = uopt.uid;
 	sbi->s_gid   = uopt.gid;
 	sbi->s_umask = uopt.umask;
+	sbi->s_fmode = uopt.fmode;
+	sbi->s_dmode = uopt.dmode;
 
 	if (sbi->s_lvid_bh) {
 		int write_rev = le16_to_cpu(udf_sb_lvidiu(sbi)->minUDFWriteRev);
@@ -1869,6 +1894,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	uopt.uid = -1;
 	uopt.gid = -1;
 	uopt.umask = 0;
+	uopt.fmode = -1;
+	uopt.dmode = -1;
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -1906,6 +1933,8 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	sbi->s_uid = uopt.uid;
 	sbi->s_gid = uopt.gid;
 	sbi->s_umask = uopt.umask;
+	sbi->s_fmode = uopt.fmode;
+	sbi->s_dmode = uopt.dmode;
 	sbi->s_nls_map = uopt.nls_map;
 
 	/* Set the block size for all transfers */
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 1c1c514..5d32c60 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -123,6 +123,8 @@ struct udf_sb_info {
 	mode_t			s_umask;
 	gid_t			s_gid;
 	uid_t			s_uid;
+	mode_t			s_fmode;
+	mode_t			s_dmode;
 
 	/* Root Info */
 	struct timespec		s_record_time;
-- 
1.5.6.4

