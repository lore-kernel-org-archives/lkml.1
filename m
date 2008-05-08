Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbYEGBw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbYEGBw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYEGBv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:51:27 -0400
Received: from cpe-74-67-183-96.rochester.res.rr.com ([74.67.183.96]:38032
	"EHLO sled2.internal.unixthugs.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754079AbYEGBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:51:23 -0400
Message-Id: <20080508063651.715221085@suse.com>
User-Agent: quilt/0.46_cvs20080326-8
Date: Thu, 08 May 2008 02:35:59 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [patch 2/3] [PATCH] reiserfs: convert j_flush_sem to mutex
References: <20080508063557.757413878@suse.com>
Content-Disposition: inline; filename=reiserfs-j_flush_sem-mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 j_flush_sem is a semaphore but uses it as if it were a mutex. This
 patch converts it to a mutex.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/journal.c           |   14 +++++++-------
 include/linux/reiserfs_fs_sb.h  |    2 +-
 include/linux/reiserfs_fs_sb.h~ |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1411,8 +1411,8 @@ static int flush_journal_list(struct sup
 
 	/* if flushall == 0, the lock is already held */
 	if (flushall) {
-		down(&journal->j_flush_sem);
-	} else if (!down_trylock(&journal->j_flush_sem)) {
+		mutex_lock(&journal->j_flush_mutex);
+	} else if (!mutex_trylock(&journal->j_flush_mutex)) {
 		BUG();
 	}
 
@@ -1642,7 +1642,7 @@ static int flush_journal_list(struct sup
 	jl->j_state = 0;
 	put_journal_list(s, jl);
 	if (flushall)
-		up(&journal->j_flush_sem);
+		mutex_unlock(&journal->j_flush_mutex);
 	put_fs_excl();
 	return err;
 }
@@ -1772,12 +1772,12 @@ static int kupdate_transactions(struct s
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
 	chunk.nr = 0;
 
-	down(&journal->j_flush_sem);
+	mutex_lock(&journal->j_flush_mutex);
 	if (!journal_list_still_alive(s, orig_trans_id)) {
 		goto done;
 	}
 
-	/* we've got j_flush_sem held, nobody is going to delete any
+	/* we've got j_flush_mutex held, nobody is going to delete any
 	 * of these lists out from underneath us
 	 */
 	while ((num_trans && transactions_flushed < num_trans) ||
@@ -1812,7 +1812,7 @@ static int kupdate_transactions(struct s
 	}
 
       done:
-	up(&journal->j_flush_sem);
+	mutex_unlock(&journal->j_flush_mutex);
 	return ret;
 }
 
@@ -2842,7 +2842,7 @@ int journal_init(struct super_block *p_s
 	journal->j_first = NULL;
 	init_waitqueue_head(&(journal->j_join_wait));
 	mutex_init(&journal->j_mutex);
-	sema_init(&journal->j_flush_sem, 1);
+	mutex_init(&journal->j_flush_mutex);
 
 	journal->j_trans_id = 10;
 	journal->j_mount_id = 10;
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -195,7 +195,7 @@ struct reiserfs_journal {
 
 	time_t j_trans_start_time;	/* time this transaction started */
 	struct mutex j_mutex;
-	struct semaphore j_flush_sem;
+	struct mutex j_flush_mutex;
 	wait_queue_head_t j_join_wait;	/* wait for current transaction to finish before starting new one */
 	atomic_t j_jlock;	/* lock for j_join_wait */
 	int j_list_bitmap_index;	/* number of next list bitmap to use */

