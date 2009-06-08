Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZFHTdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZFHTdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZFHTX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:56 -0400
Received: from thunk.org ([69.25.196.29]:39616 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbZFHTXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Curt Wohlgemuth <curtw@google.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 21/49] ext4: Make the length of the mb_history file tunable
Date: Mon,  8 Jun 2009 15:22:39 -0400
Message-Id: <1244488987-32564-22-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-21-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Curt Wohlgemuth <curtw@google.com>

In memory-constrained systems with many partitions, the ~68K for each
partition for the mb_history buffer can be excessive.

This patch adds a new mount option, mb_history_length, as well as a
way of setting the default via a module parameter (or via a sysfs
parameter in /sys/module/ext4/parameter/default_mb_history_length).
If the mb_history_length is set to zero, the mb_history facility is
disabled entirely.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   13 +++++++------
 fs/ext4/super.c   |   18 +++++++++++++++++-
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dbd47ea..df75855 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2413,7 +2413,8 @@ static void ext4_mb_history_release(struct super_block *sb)
 
 	if (sbi->s_proc != NULL) {
 		remove_proc_entry("mb_groups", sbi->s_proc);
-		remove_proc_entry("mb_history", sbi->s_proc);
+		if (sbi->s_mb_history_max)
+			remove_proc_entry("mb_history", sbi->s_proc);
 	}
 	kfree(sbi->s_mb_history);
 }
@@ -2424,17 +2425,17 @@ static void ext4_mb_history_init(struct super_block *sb)
 	int i;
 
 	if (sbi->s_proc != NULL) {
-		proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
-				 &ext4_mb_seq_history_fops, sb);
+		if (sbi->s_mb_history_max)
+			proc_create_data("mb_history", S_IRUGO, sbi->s_proc,
+					 &ext4_mb_seq_history_fops, sb);
 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
 				 &ext4_mb_seq_groups_fops, sb);
 	}
 
-	sbi->s_mb_history_max = 1000;
 	sbi->s_mb_history_cur = 0;
 	spin_lock_init(&sbi->s_mb_history_lock);
 	i = sbi->s_mb_history_max * sizeof(struct ext4_mb_history);
-	sbi->s_mb_history = kzalloc(i, GFP_KERNEL);
+	sbi->s_mb_history = i ? kzalloc(i, GFP_KERNEL) : NULL;
 	/* if we can't allocate history, then we simple won't use it */
 }
 
@@ -2444,7 +2445,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_mb_history h;
 
-	if (unlikely(sbi->s_mb_history == NULL))
+	if (sbi->s_mb_history == NULL)
 		return;
 
 	if (!(ac->ac_op & sbi->s_mb_history_filter))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7903f20..39223a5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -47,6 +47,13 @@
 #include "xattr.h"
 #include "acl.h"
 
+static int default_mb_history_length = 1000;
+
+module_param_named(default_mb_history_length, default_mb_history_length,
+		   int, 0644);
+MODULE_PARM_DESC(default_mb_history_length,
+		 "Default number of entries saved for mb_history");
+
 struct proc_dir_entry *ext4_proc_root;
 static struct kset *ext4_kset;
 
@@ -1042,7 +1049,7 @@ enum {
 	Opt_journal_update, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
-	Opt_data_err_abort, Opt_data_err_ignore,
+	Opt_data_err_abort, Opt_data_err_ignore, Opt_mb_history_length,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_resize,
@@ -1088,6 +1095,7 @@ static const match_table_t tokens = {
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_data_err_abort, "data_err=abort"},
 	{Opt_data_err_ignore, "data_err=ignore"},
+	{Opt_mb_history_length, "mb_history_length=%u"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -1329,6 +1337,13 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_data_err_ignore:
 			clear_opt(sbi->s_mount_opt, DATA_ERR_ABORT);
 			break;
+		case Opt_mb_history_length:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0)
+				return 0;
+			sbi->s_mb_history_max = option;
+			break;
 #ifdef CONFIG_QUOTA
 		case Opt_usrjquota:
 			qtype = USRQUOTA;
@@ -2345,6 +2360,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
 	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
 	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
+	sbi->s_mb_history_max = default_mb_history_length;
 
 	set_opt(sbi->s_mount_opt, BARRIER);
 
-- 
1.6.3.2.1.gb9f7d.dirty

