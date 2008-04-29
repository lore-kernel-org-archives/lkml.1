Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYD2KAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYD2KAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYD2KAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:00:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:57318 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751840AbYD2KAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:00:35 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: [PATCH] reiserfs: Fix synchronization of quota files in journal=data mode
Date: Tue, 29 Apr 2008 12:00:34 +0200
Message-Id: <12094632341766-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In journal=data mode, it is not enough to do write_inode_now() as done in
vfs_quota_on() to write all data to their final location (which is needed for
quota_read to work correctly). Calling journal_end_sync() before calling
vfs_quota_on() does it's job because transactions are committed to the journal
and data marked as dirty in memory so write_inode_now() writes them to their
final locations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 1dfbc7d..0ca04f2 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2026,6 +2026,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	int err;
 	struct nameidata nd;
 	struct inode *inode;
+	struct reiserfs_transaction_handle th;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2050,17 +2051,28 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		}
 		mark_inode_dirty(inode);
 	}
-	/* Not journalling quota? No more tests needed... */
-	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_put(&nd.path);
-		return vfs_quota_on(sb, type, format_id, path);
-	}
-	/* Quotafile not of fs root? */
-	if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
-		reiserfs_warning(sb,
+	/* Journaling quota? */
+	if (REISERFS_SB(sb)->s_qf_names[type]) {
+		/* Quotafile not of fs root? */
+		if (nd.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
+			reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
+	}
+
+	/*
+	 * When we journal data on quota file, we have to flush journal to see
+	 * all updates to the file when we bypass pagecache...
+	 */
+	if (reiserfs_file_data_log(inode)) {
+		/* Just start temporary transaction and finish it */
+		err = journal_begin(&th, sb, 1);
+		if (err)
+			return err;
+		err = journal_end_sync(&th, sb, 1);
+		if (err)
+			return err;
+	}
 	path_put(&nd.path);
 	return vfs_quota_on(sb, type, format_id, path);
 }
-- 
1.5.2.4

