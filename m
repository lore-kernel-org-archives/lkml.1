Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbYAXTmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbYAXTmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbYAXTfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:35:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46581 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbYAXTez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:55 -0500
Message-Id: <20080124193451.012194162@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:34:03 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 22/26] mount options: fix reiserfs
Content-Disposition: inline; filename=reiserfs_opts.patch
Cc: Jeff Mahoney <jeffm@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to reiserfs.

Use generic_show_options() and save the complete option string in
reiserfs_fill_super() and reiserfs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/reiserfs/super.c
===================================================================
--- linux.orig/fs/reiserfs/super.c	2008-01-17 19:00:55.000000000 +0100
+++ linux/fs/reiserfs/super.c	2008-01-22 21:20:33.000000000 +0100
@@ -617,6 +617,7 @@ static const struct super_operations rei
 	.unlockfs = reiserfs_unlockfs,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
+	.show_options = generic_show_options,
 #ifdef CONFIG_QUOTA
 	.quota_read = reiserfs_quota_read,
 	.quota_write = reiserfs_quota_write,
@@ -1138,6 +1139,7 @@ static int reiserfs_remount(struct super
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
+	char *new_opts = kstrdup(arg, GFP_KERNEL);
 	int err;
 #ifdef CONFIG_QUOTA
 	int i;
@@ -1153,7 +1155,8 @@ static int reiserfs_remount(struct super
 			REISERFS_SB(s)->s_qf_names[i] = NULL;
 		}
 #endif
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_err;
 	}
 
 	handle_attrs(s);
@@ -1191,9 +1194,9 @@ static int reiserfs_remount(struct super
 	}
 
 	if (blocks) {
-		int rc = reiserfs_resize(s, blocks);
-		if (rc != 0)
-			return rc;
+		err = reiserfs_resize(s, blocks);
+		if (err != 0)
+			goto out_err;
 	}
 
 	if (*mount_flags & MS_RDONLY) {
@@ -1201,16 +1204,16 @@ static int reiserfs_remount(struct super
 		/* remount read-only */
 		if (s->s_flags & MS_RDONLY)
 			/* it is read-only already */
-			return 0;
+			goto out_ok;
 		/* try to remount file system with read-only permissions */
 		if (sb_umount_state(rs) == REISERFS_VALID_FS
 		    || REISERFS_SB(s)->s_mount_state != REISERFS_VALID_FS) {
-			return 0;
+			goto out_ok;
 		}
 
 		err = journal_begin(&th, s, 10);
 		if (err)
-			return err;
+			goto out_err;
 
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1220,11 +1223,13 @@ static int reiserfs_remount(struct super
 		/* remount read-write */
 		if (!(s->s_flags & MS_RDONLY)) {
 			reiserfs_xattr_init(s, *mount_flags);
-			return 0;	/* We are read-write already */
+			goto out_ok;	/* We are read-write already */
 		}
 
-		if (reiserfs_is_journal_aborted(journal))
-			return journal->j_errno;
+		if (reiserfs_is_journal_aborted(journal)) {
+			err = journal->j_errno;
+			goto out_err;
+		}
 
 		handle_data_mode(s, mount_options);
 		handle_barrier_mode(s, mount_options);
@@ -1232,7 +1237,7 @@ static int reiserfs_remount(struct super
 		s->s_flags &= ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err = journal_begin(&th, s, 10);
 		if (err)
-			return err;
+			goto out_err;
 
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1247,7 +1252,7 @@ static int reiserfs_remount(struct super
 	SB_JOURNAL(s)->j_must_wait = 1;
 	err = journal_end(&th, s, 10);
 	if (err)
-		return err;
+		goto out_err;
 	s->s_dirt = 0;
 
 	if (!(*mount_flags & MS_RDONLY)) {
@@ -1255,7 +1260,14 @@ static int reiserfs_remount(struct super
 		reiserfs_xattr_init(s, *mount_flags);
 	}
 
+out_ok:
+	kfree(s->s_options);
+	s->s_options = new_opts;
 	return 0;
+
+out_err:
+	kfree(new_opts);
+	return err;
 }
 
 static int read_super_block(struct super_block *s, int offset)
@@ -1559,6 +1571,8 @@ static int reiserfs_fill_super(struct su
 	struct reiserfs_sb_info *sbi;
 	int errval = -EINVAL;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
 	if (!sbi) {
 		errval = -ENOMEM;

--
