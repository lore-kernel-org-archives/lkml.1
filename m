Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZFDIue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZFDIue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZFDItI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:49:08 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19353 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbZFDItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:49:05 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       reiserfs-devel@vger.kernel.org
Subject: [PATCH v2 12/17] reiserfs: do not manipulate s_dirt directly
Date: Thu,  4 Jun 2009 13:41:49 +0300
Message-Id: <1244112114-23144-13-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
References: <1244112114-23144-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 04 Jun 2009 08:48:42.0560 (UTC) FILETIME=[43634400:01C9E4F1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/journal.c |    6 +++---
 fs/reiserfs/resize.c  |    2 +-
 fs/reiserfs/super.c   |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 77f5bb7..1d2fb0e 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3259,7 +3259,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 			       th->t_trans_id, journal->j_trans_id);
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	prepared = test_clear_buffer_journal_prepared(bh);
 	clear_buffer_journal_restore_dirty(bh);
@@ -3554,7 +3554,7 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 			do_journal_end(&th, sb, 1, COMMIT_NOW | WAIT);
 		}
 	}
-	return sb->s_dirt;
+	return sb_is_dirty(sb);
 }
 
 /*
@@ -3984,7 +3984,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 ** it tells us if we should continue with the journal_end, or just return
 	 */
 	if (!check_journal_end(th, sb, nblocks, flags)) {
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		wake_queued_writers(sb);
 		reiserfs_async_progress_wait(sb);
 		goto out;
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 238e9d9..9157d38 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -202,7 +202,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
 	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new);
-	s->s_dirt = 1;
+	mark_sb_dirty(s);
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 90dcb7b..f45c78f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -70,8 +70,8 @@ static int reiserfs_sync_fs(struct super_block *s, int wait)
 	if (!journal_begin(&th, s, 1))
 		if (!journal_end_sync(&th, s, 1))
 			reiserfs_flush_old_commits(s);
-	s->s_dirt = 0;	/* Even if it's not true.
-			 * We'll loop forever in sync_supers otherwise */
+	mark_sb_clean(s); /* Even if it's not true.
+			   * We'll loop forever in sync_supers otherwise */
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -97,7 +97,7 @@ static int reiserfs_freeze(struct super_block *s)
 			journal_end_sync(&th, s, 1);
 		}
 	}
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -467,7 +467,7 @@ static void reiserfs_put_super(struct super_block *s)
 
 	lock_kernel();
 
-	if (s->s_dirt)
+	if (sb_is_dirty(s))
 		reiserfs_write_super(s);
 
 	/* change file system state to current state if it was mounted with read-write permissions */
@@ -1309,7 +1309,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	err = journal_end(&th, s, 10);
 	if (err)
 		goto out_err;
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 
 	if (!(*mount_flags & MS_RDONLY)) {
 		finish_unfinished(s);
-- 
1.6.0.6

