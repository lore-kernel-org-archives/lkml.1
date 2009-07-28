Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbZG1LBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbZG1LBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZG1LBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:01:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZG1LBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:01:46 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 2/2] implement uid and gid mount options for ext3
Date: Tue, 28 Jul 2009 13:01:43 +0200
Message-Id: <1248778903-3596-3-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1248778903-3596-2-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
 <1248778903-3596-2-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 Documentation/filesystems/ext3.txt |    6 ++++++
 fs/ext3/inode.c                    |   26 ++++++++++++++++++++------
 fs/ext3/super.c                    |   34 +++++++++++++++++++++++++++++++++-
 include/linux/ext3_fs_sb.h         |    4 ++++
 4 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 570f9bd..84e0254 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -121,6 +121,12 @@ resgid=n		The group ID which may use the reserved blocks.
 
 resuid=n		The user ID which may use the reserved blocks.
 
+uid=n[:m]		make all files appear to belong to this is uid.
+			The optional second uid is actually written do disk.
+
+gid=n[:m]		make all files appear to belong to this is gid.
+			The optional second gid is actually written do disk.
+
 sb=n			Use alternate superblock at this location.
 
 quota
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5f51fed..afb5c53 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2766,6 +2766,12 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT3_SB(sb)->s_uid) {
+		inode->i_uid = EXT3_SB(sb)->s_uid;
+	}
+	if (EXT3_SB(sb)->s_gid) {
+		inode->i_gid = EXT3_SB(sb)->s_gid;
+	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -2895,6 +2901,8 @@ static int ext3_do_update_inode(handle_t *handle,
 {
 	struct ext3_inode *raw_inode = ext3_raw_inode(iloc);
 	struct ext3_inode_info *ei = EXT3_I(inode);
+	uid_t uid = inode->i_uid;
+	gid_t gid = inode->i_gid;
 	struct buffer_head *bh = iloc->bh;
 	int err = 0, rc, block;
 
@@ -2905,27 +2913,33 @@ static int ext3_do_update_inode(handle_t *handle,
 
 	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	if (EXT3_SB(inode->i_sb)->s_uid) {
+		uid = EXT3_SB(inode->i_sb)->s_diskuid;
+	}
+	if (EXT3_SB(inode->i_sb)->s_gid) {
+		gid = EXT3_SB(inode->i_sb)->s_diskgid;
+	}
 	if(!(test_opt(inode->i_sb, NO_UID32))) {
-		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
-		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
+		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
+		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(gid));
 /*
  * Fix up interoperability with old kernels. Otherwise, old inodes get
  * re-used with the upper 16 bits of the uid/gid intact
  */
 		if(!ei->i_dtime) {
 			raw_inode->i_uid_high =
-				cpu_to_le16(high_16_bits(inode->i_uid));
+				cpu_to_le16(high_16_bits(uid));
 			raw_inode->i_gid_high =
-				cpu_to_le16(high_16_bits(inode->i_gid));
+				cpu_to_le16(high_16_bits(gid));
 		} else {
 			raw_inode->i_uid_high = 0;
 			raw_inode->i_gid_high = 0;
 		}
 	} else {
 		raw_inode->i_uid_low =
-			cpu_to_le16(fs_high2lowuid(inode->i_uid));
+			cpu_to_le16(fs_high2lowuid(uid));
 		raw_inode->i_gid_low =
-			cpu_to_le16(fs_high2lowgid(inode->i_gid));
+			cpu_to_le16(fs_high2lowgid(gid));
 		raw_inode->i_uid_high = 0;
 		raw_inode->i_gid_high = 0;
 	}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 524b349..eb22c82 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -779,7 +779,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid
 };
 
 static const match_table_t tokens = {
@@ -832,6 +832,10 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_resize, "resize"},
+	{Opt_uid, "uid=%u"},
+	{Opt_diskuid, "uid=%u:%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_diskgid, "gid=%u:%u"},
 	{Opt_err, NULL},
 };
 
@@ -1183,6 +1187,34 @@ set_qf_format:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = sbi->s_diskuid = option;
+			break;
+		case Opt_diskuid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = option;
+
+			if (match_int(&args[1], &option))
+				return 0;
+			sbi->s_diskuid = option;
+			break;
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_gid = sbi->s_diskgid = option;
+			break;
+		case Opt_diskgid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_gid = option;
+
+			if (match_int(&args[1], &option))
+				return 0;
+			sbi->s_diskgid = option;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index f07f34d..2fa2b49 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -47,6 +47,10 @@ struct ext3_sb_info {
 	ext3_fsblk_t s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;                    /* make all files appear to belong to this uid */
+	uid_t s_diskuid;                /* write this uid to disk (if s_uid != 0) */
+	gid_t s_gid;                    /* make all files appear to belong to this gid */
+	gid_t s_diskgid;                /* write this gid to disk (if s_gid != 0) */
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
-- 
1.6.2.1

