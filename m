Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZG1LBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZG1LBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZG1LBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:01:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:54127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbZG1LBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:01:44 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 1/2] implement uid and gid mount options for ext2
Date: Tue, 28 Jul 2009 13:01:42 +0200
Message-Id: <1248778903-3596-2-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248778903-3596-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 Documentation/filesystems/ext2.txt |    6 ++++++
 fs/ext2/inode.c                    |   12 ++++++++++++
 fs/ext2/super.c                    |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/ext2_fs_sb.h         |    4 ++++
 4 files changed, 56 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 67639f9..5501ae0 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -42,6 +42,12 @@ orlov			(*)	Use the Orlov block allocator.
 resuid=n			The user ID which may use the reserved blocks.
 resgid=n			The group ID which may use the reserved blocks.
 
+uid=n[:m]			make all files appear to belong to this is uid.
+				The optional second uid is actually written do disk.
+
+gid=n[:m]			make all files appear to belong to this is gid.
+				The optional second gid is actually written do disk.
+
 sb=n				Use alternate superblock at this location.
 
 user_xattr			Enable "user." POSIX Extended Attributes
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..7ceb73c 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1239,6 +1239,12 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT2_SB(sb)->s_uid) {
+		inode->i_uid = EXT2_SB(sb)->s_uid;
+	}
+	if (EXT2_SB(sb)->s_gid) {
+		inode->i_gid = EXT2_SB(sb)->s_gid;
+	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -1353,6 +1359,12 @@ int ext2_write_inode(struct inode *inode, int do_sync)
 
 	ext2_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
+	if (EXT2_SB(sb)->s_uid) {
+		uid = EXT2_SB(sb)->s_diskuid;
+	}
+	if (EXT2_SB(sb)->s_gid) {
+		gid = EXT2_SB(sb)->s_diskgid;
+	}
 	if (!(test_opt(sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(gid));
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..f89b407 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -382,7 +382,8 @@ enum {
 	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
 	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
 	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
-	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
+	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
+	Opt_uid, Opt_diskuid, Opt_gid, Opt_diskgid
 };
 
 static const match_table_t tokens = {
@@ -416,6 +417,10 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_reservation, "reservation"},
 	{Opt_noreservation, "noreservation"},
+	{Opt_uid, "uid=%u"},
+	{Opt_diskuid, "uid=%u:%u"},
+	{Opt_gid, "gid=%u"},
+	{Opt_diskgid, "gid=%u:%u"},
 	{Opt_err, NULL}
 };
 
@@ -556,6 +561,34 @@ static int parse_options (char * options,
 			clear_opt(sbi->s_mount_opt, RESERVATION);
 			printk("reservations OFF\n");
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
 		case Opt_ignore:
 			break;
 		default:
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 1cdb663..062e8a9 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -88,6 +88,10 @@ struct ext2_sb_info {
 	unsigned long s_sb_block;
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

