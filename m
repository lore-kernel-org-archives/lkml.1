Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZGWLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZGWLgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZGWLgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:36:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:48831 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZGWLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:36:32 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 2/2] implement uid mount option for ext3
Date: Thu, 23 Jul 2009 13:36:31 +0200
Message-Id: <1248348991-849-3-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1248348991-849-2-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
 <1248348991-849-2-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 fs/ext3/inode.c            |   11 ++++++++++-
 fs/ext3/super.c            |    8 +++++++-
 include/linux/ext3_fs_sb.h |    1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5f51fed..148a4d3 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2766,6 +2766,9 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT3_SB(sb)->s_uid && inode->i_uid == 0) {
+		inode->i_uid = EXT3_SB(sb)->s_uid;
+	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -2905,7 +2908,13 @@ static int ext3_do_update_inode(handle_t *handle,
 
 	ext3_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
-	if(!(test_opt(inode->i_sb, NO_UID32))) {
+	if (EXT3_SB(inode->i_sb)->s_uid &&
+	    inode->i_uid == EXT3_SB(inode->i_sb)->s_uid) {
+		raw_inode->i_uid_high = 0;
+		raw_inode->i_uid_low  = 0;
+		raw_inode->i_gid_high = 0;
+		raw_inode->i_gid_low  = 0;
+	} else if(!(test_opt(inode->i_sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(inode->i_uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(inode->i_gid));
 /*
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 524b349..b610242 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -779,7 +779,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_uid
 };
 
 static const match_table_t tokens = {
@@ -832,6 +832,7 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_resize, "resize"},
+	{Opt_uid, "uid=%u"},
 	{Opt_err, NULL},
 };
 
@@ -1183,6 +1184,11 @@ set_qf_format:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = option;
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index f07f34d..751058a 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -47,6 +47,7 @@ struct ext3_sb_info {
 	ext3_fsblk_t s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;                    /* map root owned files to this uid */
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
-- 
1.6.2.1

