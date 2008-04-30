Return-Path: <linux-kernel-owner+w=401wt.eu-S1762970AbYD3PG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762970AbYD3PG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762273AbYD3PG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:06:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:36420 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762118AbYD3PGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:06:22 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH] reiserfs: Fix synchronization of quota files in journal=data mode
Date: Wed, 30 Apr 2008 17:06:14 +0200
Message-Id: <12095679812452-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12095679812375-git-send-email-jack@suse.cz>
References: y
 <12095679813226-git-send-email-jack@suse.cz>
 <12095679812375-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In journal=data mode, it is not enough to do write_inode_now() as done in
vfs_quota_on() to write all data to their final location (which is needed for
quota_read to work correctly). Calling journal_end_sync() before calling
vfs_quota_on() does it's job because transactions are committed to the journal
and data marked as dirty in memory so write_inode_now() writes them to their
final locations.

Cc: reiserfs-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index ed424d7..072116a 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2026,6 +2026,7 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 	int err;
 	struct nameidata nd;
 	struct inode *inode;
+	struct reiserfs_transaction_handle th;
 
 	if (!(REISERFS_SB(sb)->s_mount_opt & (1 << REISERFS_QUOTA)))
 		return -EINVAL;
@@ -2053,17 +2054,28 @@ static int reiserfs_quota_on(struct super_block *sb, int type, int format_id,
 		}
 		mark_inode_dirty(inode);
 	}
-	/* Not journalling quota? No more tests needed... */
-	if (!REISERFS_SB(sb)->s_qf_names[USRQUOTA] &&
-	    !REISERFS_SB(sb)->s_qf_names[GRPQUOTA]) {
-		path_put(&nd.path);
-		return vfs_quota_on(sb, type, format_id, path, 0);
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
 	return vfs_quota_on(sb, type, format_id, path, 0);
 }
-- 
1.5.2.4

