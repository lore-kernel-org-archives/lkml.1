Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbZE0LQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbZE0LQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbZE0LMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54618 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632AbZE0LMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:33 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Wed, 27 May 2009 16:06:21 +0300
Message-Id: <20090527130621.4913.55045.sendpatchset@localhost.localdomain>
In-Reply-To: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
References: <20090527130503.4913.62042.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/19] reiserfs: do not manipulate s_dirt directly
X-OriginalArrivalTime: 27 May 2009 11:12:20.0513 (UTC) FILETIME=[00C88910:01C9DEBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCH] reiserfs: do not manipulate s_dirt directly

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Christoph Hellwig <hch@infradead.org>
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

