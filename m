Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbXJEPbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbXJEPbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXJEPb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:31:29 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43898 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298AbXJEPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:31:26 -0400
Subject: [PATCH 2/2]  i_version update - ext4 part
From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Reply-To: jean-noel.cordenner@bull.net
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Organization: BULL S.A.
Date: Fri, 05 Oct 2007 17:28:13 +0200
Message-Id: <1191598093.24615.46.camel@frecb002711.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 17:37:39,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 17:37:40,
	Serialize complete at 05/10/2007 17:37:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update the i_version field of the inode and add a mount
option to enable this feature. The other condition to enable this
feature is that the inode size should be 256-bytes.

Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
--- 
 fs/ext4/inode.c         |    4 +++-
 fs/ext4/super.c         |    7 ++++++-
 include/linux/ext4_fs.h |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.23-rc8-ext4-i_version/fs/ext4/inode.c
===================================================================
--- linux-2.6.23-rc8-ext4-i_version.orig/fs/ext4/inode.c	2007-10-03
18:11:17.000000000 +0200
+++ linux-2.6.23-rc8-ext4-i_version/fs/ext4/inode.c	2007-10-05
10:26:42.000000000 +0200
@@ -3173,7 +3173,9 @@
 {
 	int err = 0;
 
-	inode->i_version++;
+	if (test_opt(inode->i_sb, I_VERSION))
+		inode_inc_iversion(inode);
+
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
 
Index: linux-2.6.23-rc8-ext4-i_version/fs/ext4/super.c
===================================================================
--- linux-2.6.23-rc8-ext4-i_version.orig/fs/ext4/super.c	2007-10-03
18:11:17.000000000 +0200
+++ linux-2.6.23-rc8-ext4-i_version/fs/ext4/super.c	2007-10-03
18:17:44.000000000 +0200
@@ -742,7 +742,7 @@
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_delalloc,
-	Opt_mballoc, Opt_nomballoc, Opt_stripe,
+	Opt_mballoc, Opt_nomballoc, Opt_stripe, Opt_i_version,
 };
 
 static match_table_t tokens = {
@@ -800,6 +800,7 @@
 	{Opt_mballoc, "mballoc"},
 	{Opt_nomballoc, "nomballoc"},
 	{Opt_stripe, "stripe=%u"},
+	{Opt_i_version, "i_version"},
 	{Opt_err, NULL},
 	{Opt_resize, "resize"},
 };
@@ -1161,6 +1162,10 @@
 				return 0;
 			sbi->s_stripe = option;
 			break;
+		case Opt_i_version:
+			set_opt (sbi->s_mount_opt, I_VERSION);
+			sb->s_flags |= MS_I_VERSION;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT4-fs: Unrecognized mount option \"%s\" "
Index: linux-2.6.23-rc8-ext4-i_version/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.23-rc8-ext4-i_version.orig/include/linux/ext4_fs.h
2007-10-03 18:11:17.000000000 +0200
+++ linux-2.6.23-rc8-ext4-i_version/include/linux/ext4_fs.h	2007-10-03
18:11:54.000000000 +0200
@@ -500,6 +500,7 @@
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async
Commit */
 #define EXT4_MOUNT_DELALLOC		0x2000000 /* Delalloc support */
 #define EXT4_MOUNT_MBALLOC		0x4000000 /* Buddy allocation support */
+#define EXT4_MOUNT_I_VERSION		0x8000000 /* i_version support */
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at
once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt


