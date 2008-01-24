Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbYAXTll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbYAXTll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbYAXTff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:35 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46596 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYAXTfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:35:01 -0500
Message-Id: <20080124193456.220272889@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:06 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 25/26] mount options: fix udf
Content-Disposition: inline; filename=udf_opts.patch
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to udf.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/udf/super.c
===================================================================
--- linux.orig/fs/udf/super.c	2008-01-24 13:48:37.000000000 +0100
+++ linux/fs/udf/super.c	2008-01-24 15:58:21.000000000 +0100
@@ -53,6 +53,8 @@
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
 #include <linux/errno.h>
+#include <linux/mount.h>
+#include <linux/seq_file.h>
 #include <asm/byteorder.h>
 
 #include <linux/udf_fs.h>
@@ -71,6 +73,8 @@
 #define VDS_POS_TERMINATING_DESC	6
 #define VDS_POS_LENGTH			7
 
+#define UDF_DEFAULT_BLOCKSIZE 2048
+
 static char error_buf[1024];
 
 /* These are the "meat" - everything else is stuffing */
@@ -95,6 +99,7 @@ static void udf_open_lvid(struct super_b
 static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
 static int udf_statfs(struct dentry *, struct kstatfs *);
+static int udf_show_options(struct seq_file *, struct vfsmount *);
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
 {
@@ -181,6 +186,7 @@ static const struct super_operations udf
 	.write_super	= udf_write_super,
 	.statfs		= udf_statfs,
 	.remount_fs	= udf_remount_fs,
+	.show_options	= udf_show_options,
 };
 
 struct udf_options {
@@ -247,6 +253,56 @@ static int udf_sb_alloc_partition_maps(s
 	return 0;
 }
 
+static int udf_show_options(struct seq_file *seq, struct vfsmount *mnt)
+{
+	struct super_block *sb = mnt->mnt_sb;
+	struct udf_sb_info *sbi = UDF_SB(sb);
+
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT))
+		seq_puts(seq, ",nostrict");
+	if (sb->s_blocksize != UDF_DEFAULT_BLOCKSIZE)
+		seq_printf(seq, ",bs=%lu", sb->s_blocksize);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNHIDE))
+		seq_puts(seq, ",unhide");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UNDELETE))
+		seq_puts(seq, ",undelete");
+	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_USE_AD_IN_ICB))
+		seq_puts(seq, ",noadinicb");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_USE_SHORT_AD))
+		seq_puts(seq, ",shortad");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_FORGET))
+		seq_puts(seq, ",uid=forget");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_IGNORE))
+		seq_puts(seq, ",uid=ignore");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_FORGET))
+		seq_puts(seq, ",gid=forget");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_IGNORE))
+		seq_puts(seq, ",gid=ignore");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UID_SET))
+		seq_printf(seq, ",uid=%u", sbi->s_uid);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_GID_SET))
+		seq_printf(seq, ",gid=%u", sbi->s_gid);
+	if (sbi->s_umask != 0)
+		seq_printf(seq, ",umask=%o", sbi->s_umask);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_SESSION_SET))
+		seq_printf(seq, ",session=%u", sbi->s_session);
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_LASTBLOCK_SET))
+		seq_printf(seq, ",lastblock=%u", sbi->s_last_block);
+	/* is this correct? */
+	if (sbi->s_anchor[2] != 0)
+		seq_printf(seq, ",anchor=%u", sbi->s_anchor[2]);
+	/*
+	 * volume, partition, fileset and rootdir seem to be ignored
+	 * currently
+	 */
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_UTF8))
+		seq_puts(seq, ",utf8");
+	if (UDF_QUERY_FLAG(sb, UDF_FLAG_NLS_MAP) && sbi->s_nls_map)
+		seq_printf(seq, ",iocharset=%s", sbi->s_nls_map->charset);
+
+	return 0;
+}
+
 /*
  * udf_parse_options
  *
@@ -339,13 +395,14 @@ static match_table_t tokens = {
 	{Opt_err,	NULL}
 };
 
-static int udf_parse_options(char *options, struct udf_options *uopt)
+static int udf_parse_options(char *options, struct udf_options *uopt,
+			     bool remount)
 {
 	char *p;
 	int option;
 
 	uopt->novrs = 0;
-	uopt->blocksize = 2048;
+	uopt->blocksize = UDF_DEFAULT_BLOCKSIZE;
 	uopt->partition = 0xFFFF;
 	uopt->session = 0xFFFFFFFF;
 	uopt->lastblock = 0;
@@ -415,11 +472,15 @@ static int udf_parse_options(char *optio
 			if (match_int(args, &option))
 				return 0;
 			uopt->session = option;
+			if (!remount)
+				uopt->flags |= (1 << UDF_FLAG_SESSION_SET);
 			break;
 		case Opt_lastblock:
 			if (match_int(args, &option))
 				return 0;
 			uopt->lastblock = option;
+			if (!remount)
+				uopt->flags |= (1 << UDF_FLAG_LASTBLOCK_SET);
 			break;
 		case Opt_anchor:
 			if (match_int(args, &option))
@@ -497,7 +558,7 @@ static int udf_remount_fs(struct super_b
 	uopt.gid   = sbi->s_gid;
 	uopt.umask = sbi->s_umask;
 
-	if (!udf_parse_options(options, &uopt))
+	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
 
 	sbi->s_flags = uopt.flags;
@@ -1679,7 +1740,7 @@ static int udf_fill_super(struct super_b
 
 	mutex_init(&sbi->s_alloc_mutex);
 
-	if (!udf_parse_options((char *)options, &uopt))
+	if (!udf_parse_options((char *)options, &uopt, false))
 		goto error_out;
 
 	if (uopt.flags & (1 << UDF_FLAG_UTF8) &&
Index: linux/fs/udf/udf_sb.h
===================================================================
--- linux.orig/fs/udf/udf_sb.h	2008-01-24 13:48:37.000000000 +0100
+++ linux/fs/udf/udf_sb.h	2008-01-24 13:51:08.000000000 +0100
@@ -26,6 +26,8 @@
 #define UDF_FLAG_GID_IGNORE     14
 #define UDF_FLAG_UID_SET	15
 #define UDF_FLAG_GID_SET	16
+#define UDF_FLAG_SESSION_SET	17
+#define UDF_FLAG_LASTBLOCK_SET	18
 
 #define UDF_PART_FLAG_UNALLOC_BITMAP	0x0001
 #define UDF_PART_FLAG_UNALLOC_TABLE	0x0002

--
