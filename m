Return-Path: <linux-kernel-owner+w=401wt.eu-S1764105AbYD3PJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764105AbYD3PJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761711AbYD3PGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:06:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:36445 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762188AbYD3PGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:25 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH] reiserfs: Correct mount option parsing to detect when quota options can be changed
Date: Wed, 30 Apr 2008 17:06:21 +0200
Message-Id: <12095679823857-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12095679822135-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
 <12095679812452-git-send-email-jack@suse.cz>
 <1209567981639-git-send-email-jack@suse.cz>
 <1209567981323-git-send-email-jack@suse.cz>
 <12095679812717-git-send-email-jack@suse.cz>
 <12095679824183-git-send-email-jack@suse.cz>
 <12095679822696-git-send-email-jack@suse.cz>
 <12095679822135-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not allow user to change quota mount options when quota is just
suspended. It would make mount options and internal quota state inconsistent.
Also we should not allow user to change quota format when quota is turned on.
On the other hand we can just silently ignore when some option is set to the
value it already has (some mount versions do this on remount). Finally, we should
not discard current quota options if parsing of mount options fails.

Cc: reiserfs-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   83 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 118b059..2c3aa5f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -876,7 +876,9 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 				     mount options were selected. */
 				  unsigned long *blocks,	/* strtol-ed from NNN of resize=NNN */
 				  char **jdev_name,
-				  unsigned int *commit_max_age)
+				  unsigned int *commit_max_age,
+				  char **qf_names,
+				  unsigned int *qfmt)
 {
 	int c;
 	char *arg = NULL;
@@ -992,7 +994,9 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 		if (c == 'u' || c == 'g') {
 			int qtype = c == 'u' ? USRQUOTA : GRPQUOTA;
 
-			if (sb_any_quota_enabled(s)) {
+			if ((sb_any_quota_enabled(s) ||
+			     sb_any_quota_suspended(s)) &&
+			    (!*arg != !REISERFS_SB(s)->s_qf_names[qtype])) {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
 				return 0;
@@ -1011,30 +1015,39 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 							 "reiserfs_parse_options: quotafile must be on filesystem root.");
 					return 0;
 				}
-				REISERFS_SB(s)->s_qf_names[qtype] =
+				qf_names[qtype] =
 				    kmalloc(strlen(arg) + 1, GFP_KERNEL);
-				if (!REISERFS_SB(s)->s_qf_names[qtype]) {
+				if (!qf_names[qtype]) {
 					reiserfs_warning(s,
 							 "reiserfs_parse_options: not enough memory for storing quotafile name.");
 					return 0;
 				}
-				strcpy(REISERFS_SB(s)->s_qf_names[qtype], arg);
+				strcpy(qf_names[qtype], arg);
 				*mount_options |= 1 << REISERFS_QUOTA;
 			} else {
-				kfree(REISERFS_SB(s)->s_qf_names[qtype]);
-				REISERFS_SB(s)->s_qf_names[qtype] = NULL;
+				if (qf_names[qtype] !=
+				    REISERFS_SB(s)->s_qf_names[qtype])
+					kfree(qf_names[qtype]);
+				qf_names[qtype] = NULL;
 			}
 		}
 		if (c == 'f') {
 			if (!strcmp(arg, "vfsold"))
-				REISERFS_SB(s)->s_jquota_fmt = QFMT_VFS_OLD;
+				*qfmt = QFMT_VFS_OLD;
 			else if (!strcmp(arg, "vfsv0"))
-				REISERFS_SB(s)->s_jquota_fmt = QFMT_VFS_V0;
+				*qfmt = QFMT_VFS_V0;
 			else {
 				reiserfs_warning(s,
 						 "reiserfs_parse_options: unknown quota format specified.");
 				return 0;
 			}
+			if ((sb_any_quota_enabled(s) ||
+			     sb_any_quota_suspended(s)) &&
+			    *qfmt != REISERFS_SB(s)->s_jquota_fmt) {
+				reiserfs_warning(s,
+						 "reiserfs_parse_options: cannot change journaled quota options when quota turned on.");
+				return 0;
+			}
 		}
 #else
 		if (c == 'u' || c == 'g' || c == 'f') {
@@ -1046,9 +1059,8 @@ static int reiserfs_parse_options(struct super_block *s, char *options,	/* strin
 	}
 
 #ifdef CONFIG_QUOTA
-	if (!REISERFS_SB(s)->s_jquota_fmt
-	    && (REISERFS_SB(s)->s_qf_names[USRQUOTA]
-		|| REISERFS_SB(s)->s_qf_names[GRPQUOTA])) {
+	if (!REISERFS_SB(s)->s_jquota_fmt && !*qfmt
+	    && (qf_names[USRQUOTA] || qf_names[GRPQUOTA])) {
 		reiserfs_warning(s,
 				 "reiserfs_parse_options: journaled quota format not specified.");
 		return 0;
@@ -1130,6 +1142,21 @@ static void handle_attrs(struct super_block *s)
 	}
 }
 
+#ifdef CONFIG_QUOTA
+static void handle_quota_files(struct super_block *s, char **qf_names,
+			       unsigned int *qfmt)
+{
+	int i;
+
+	for (i = 0; i < MAXQUOTAS; i++) {
+		if (qf_names[i] != REISERFS_SB(s)->s_qf_names[i])
+			kfree(REISERFS_SB(s)->s_qf_names[i]);
+		REISERFS_SB(s)->s_qf_names[i] = qf_names[i];
+	}
+	REISERFS_SB(s)->s_jquota_fmt = *qfmt;
+}
+#endif
+
 static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 {
 	struct reiserfs_super_block *rs;
@@ -1141,23 +1168,30 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
 	char *new_opts = kstrdup(arg, GFP_KERNEL);
 	int err;
+	char *qf_names[MAXQUOTAS];
+	unsigned int qfmt = 0;
 #ifdef CONFIG_QUOTA
 	int i;
+
+	memcpy(qf_names, REISERFS_SB(s)->s_qf_names, sizeof(qf_names));
 #endif
 
 	rs = SB_DISK_SUPER_BLOCK(s);
 
 	if (!reiserfs_parse_options
-	    (s, arg, &mount_options, &blocks, NULL, &commit_max_age)) {
+	    (s, arg, &mount_options, &blocks, NULL, &commit_max_age,
+	    qf_names, &qfmt)) {
 #ifdef CONFIG_QUOTA
-		for (i = 0; i < MAXQUOTAS; i++) {
-			kfree(REISERFS_SB(s)->s_qf_names[i]);
-			REISERFS_SB(s)->s_qf_names[i] = NULL;
-		}
+		for (i = 0; i < MAXQUOTAS; i++)
+			if (qf_names[i] != REISERFS_SB(s)->s_qf_names[i])
+				kfree(qf_names[i]);
 #endif
 		err = -EINVAL;
 		goto out_err;
 	}
+#ifdef CONFIG_QUOTA
+	handle_quota_files(s, qf_names, &qfmt);
+#endif
 
 	handle_attrs(s);
 
@@ -1570,6 +1604,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	char *jdev_name;
 	struct reiserfs_sb_info *sbi;
 	int errval = -EINVAL;
+	char *qf_names[MAXQUOTAS] = {};
+	unsigned int qfmt = 0;
 
 	save_mount_options(s, data);
 
@@ -1597,9 +1633,12 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 	jdev_name = NULL;
 	if (reiserfs_parse_options
 	    (s, (char *)data, &(sbi->s_mount_opt), &blocks, &jdev_name,
-	     &commit_max_age) == 0) {
+	     &commit_max_age, qf_names, &qfmt) == 0) {
 		goto error;
 	}
+#ifdef CONFIG_QUOTA
+	handle_quota_files(s, qf_names, &qfmt);
+#endif
 
 	if (blocks) {
 		SWARN(silent, s, "jmacd-7: reiserfs_fill_super: resize option "
@@ -1819,7 +1858,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 
 	return (0);
 
-      error:
+error:
 	if (jinit_done) {	/* kill the commit thread, free journal ram */
 		journal_release_error(NULL, s);
 	}
@@ -1830,10 +1869,8 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 #ifdef CONFIG_QUOTA
 	{
 		int j;
-		for (j = 0; j < MAXQUOTAS; j++) {
-			kfree(sbi->s_qf_names[j]);
-			sbi->s_qf_names[j] = NULL;
-		}
+		for (j = 0; j < MAXQUOTAS; j++)
+			kfree(qf_names[j]);
 	}
 #endif
 	kfree(sbi);
-- 
1.5.2.4

