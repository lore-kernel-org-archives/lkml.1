Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbYAVDNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbYAVDNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbYAVDGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:06:48 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32924 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759256AbYAVDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:06:45 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 37/49] ext4: Fix ext4_show_options to show the correct mount options.
Date: Mon, 21 Jan 2008 22:02:16 -0500
Message-Id: <1200970948-17903-38-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-37-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
 <1200970948-17903-35-git-send-email-tytso@mit.edu>
 <1200970948-17903-36-git-send-email-tytso@mit.edu>
 <1200970948-17903-37-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We need to look at the default value and make sure
the mount options are not set via default value
before showing them via ext4_show_options

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa22acd..64fc7f1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -665,18 +665,20 @@ static inline void ext4_show_quota_options(struct seq_file *seq, struct super_bl
  */
 static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
+	int def_errors;
+	unsigned long def_mount_opts;
 	struct super_block *sb = vfs->mnt_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	unsigned long def_mount_opts;
 
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+	def_errors     = le16_to_cpu(es->s_errors);
 
 	if (sbi->s_sb_block != 1)
 		seq_printf(seq, ",sb=%llu", sbi->s_sb_block);
 	if (test_opt(sb, MINIX_DF))
 		seq_puts(seq, ",minixdf");
-	if (test_opt(sb, GRPID))
+	if (test_opt(sb, GRPID) && !(def_mount_opts & EXT4_DEFM_BSDGROUPS))
 		seq_puts(seq, ",grpid");
 	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT4_DEFM_BSDGROUPS))
 		seq_puts(seq, ",nogrpid");
@@ -689,25 +691,24 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
 	if (test_opt(sb, ERRORS_RO)) {
-		int def_errors = le16_to_cpu(es->s_errors);
-
 		if (def_errors == EXT4_ERRORS_PANIC ||
 		    def_errors == EXT4_ERRORS_CONTINUE) {
 			seq_puts(seq, ",errors=remount-ro");
 		}
 	}
-	if (test_opt(sb, ERRORS_CONT))
+	if (test_opt(sb, ERRORS_CONT) && def_errors != EXT4_ERRORS_CONTINUE)
 		seq_puts(seq, ",errors=continue");
-	if (test_opt(sb, ERRORS_PANIC))
+	if (test_opt(sb, ERRORS_PANIC) && def_errors != EXT4_ERRORS_PANIC)
 		seq_puts(seq, ",errors=panic");
-	if (test_opt(sb, NO_UID32))
+	if (test_opt(sb, NO_UID32) && !(def_mount_opts & EXT4_DEFM_UID16))
 		seq_puts(seq, ",nouid32");
-	if (test_opt(sb, DEBUG))
+	if (test_opt(sb, DEBUG) && !(def_mount_opts & EXT4_DEFM_DEBUG))
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
 #ifdef CONFIG_EXT4DEV_FS_XATTR
-	if (test_opt(sb, XATTR_USER))
+	if (test_opt(sb, XATTR_USER) &&
+		!(def_mount_opts & EXT4_DEFM_XATTR_USER))
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
 	    (def_mount_opts & EXT4_DEFM_XATTR_USER)) {
@@ -715,7 +716,7 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	}
 #endif
 #ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
-	if (test_opt(sb, POSIX_ACL))
+	if (test_opt(sb, POSIX_ACL) && !(def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
 		seq_puts(seq, ",noacl");
@@ -735,6 +736,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, I_VERSION))
 		seq_puts(seq, ",i_version");
 
+	/*
+	 * journal mode get enabled in different ways
+	 * So just print the value even if we didn't specify it
+	 */
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
 	else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
@@ -743,7 +748,6 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",data=writeback");
 
 	ext4_show_quota_options(seq, sb);
-
 	return 0;
 }
 
-- 
1.5.4.rc3.31.g1271-dirty

