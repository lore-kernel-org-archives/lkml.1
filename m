Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZGWLg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZGWLg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZGWLge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:36:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZGWLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:36:32 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH 1/2] implement uid mount option for ext2
Date: Thu, 23 Jul 2009 13:36:30 +0200
Message-Id: <1248348991-849-2-git-send-email-ludwig.nussel@suse.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
---
 fs/ext2/inode.c            |   11 ++++++++++-
 fs/ext2/super.c            |    9 ++++++++-
 include/linux/ext2_fs_sb.h |    1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e271303..7324f45 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1239,6 +1239,9 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
 		inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
 	}
+	if (EXT2_SB(sb)->s_uid && inode->i_uid == 0) {
+		inode->i_uid = EXT2_SB(sb)->s_uid;
+	}
 	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
 	inode->i_size = le32_to_cpu(raw_inode->i_size);
 	inode->i_atime.tv_sec = (signed)le32_to_cpu(raw_inode->i_atime);
@@ -1353,7 +1356,13 @@ int ext2_write_inode(struct inode *inode, int do_sync)
 
 	ext2_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
-	if (!(test_opt(sb, NO_UID32))) {
+	if (EXT2_SB(sb)->s_uid &&
+	    inode->i_uid == EXT2_SB(sb)->s_uid) {
+		raw_inode->i_uid_high = 0;
+		raw_inode->i_uid_low  = 0;
+		raw_inode->i_gid_high = 0;
+		raw_inode->i_gid_low  = 0;
+	} else if (!(test_opt(sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
 		raw_inode->i_gid_low = cpu_to_le16(low_16_bits(gid));
 /*
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1a9ffee..b2ce1c4 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -382,7 +382,8 @@ enum {
 	Opt_err_ro, Opt_nouid32, Opt_nocheck, Opt_debug,
 	Opt_oldalloc, Opt_orlov, Opt_nobh, Opt_user_xattr, Opt_nouser_xattr,
 	Opt_acl, Opt_noacl, Opt_xip, Opt_ignore, Opt_err, Opt_quota,
-	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation
+	Opt_usrquota, Opt_grpquota, Opt_reservation, Opt_noreservation,
+	Opt_uid
 };
 
 static const match_table_t tokens = {
@@ -416,6 +417,7 @@ static const match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_reservation, "reservation"},
 	{Opt_noreservation, "noreservation"},
+	{Opt_uid, "uid=%u"},
 	{Opt_err, NULL}
 };
 
@@ -556,6 +558,11 @@ static int parse_options (char * options,
 			clear_opt(sbi->s_mount_opt, RESERVATION);
 			printk("reservations OFF\n");
 			break;
+		case Opt_uid:
+			if (match_int(&args[0], &option))
+				return 0;
+			sbi->s_uid = option;
+			break;
 		case Opt_ignore:
 			break;
 		default:
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 1cdb663..a4b0b79 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -88,6 +88,7 @@ struct ext2_sb_info {
 	unsigned long s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
+	uid_t s_uid;                    /* map root owned files to this uid */
 	unsigned short s_mount_state;
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
-- 
1.6.2.1

