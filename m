Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYEGBvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYEGBvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYEGBvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:51:24 -0400
Received: from cpe-74-67-183-96.rochester.res.rr.com ([74.67.183.96]:38033
	"EHLO sled2.internal.unixthugs.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990AbYEGBvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:51:23 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 21:51:22 EDT
Message-Id: <20080508063650.394334212@suse.com>
User-Agent: quilt/0.46_cvs20080326-8
Date: Thu, 08 May 2008 02:35:58 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: [patch 1/3] [PATCH] reiserfs: convert j_lock to mutex
References: <20080508063557.757413878@suse.com>
Content-Disposition: inline; filename=reiserfs-j_lock-mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 j_lock is a semaphore but uses it as if it were a mutex. This
 patch converts it to a mutex.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/journal.c          |    6 +++---
 include/linux/reiserfs_fs_sb.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -558,13 +558,13 @@ static inline void insert_journal_hash(s
 static inline void lock_journal(struct super_block *p_s_sb)
 {
 	PROC_INFO_INC(p_s_sb, journal.lock_journal);
-	down(&SB_JOURNAL(p_s_sb)->j_lock);
+	mutex_lock(&SB_JOURNAL(p_s_sb)->j_mutex);
 }
 
 /* unlock the current transaction */
 static inline void unlock_journal(struct super_block *p_s_sb)
 {
-	up(&SB_JOURNAL(p_s_sb)->j_lock);
+	mutex_unlock(&SB_JOURNAL(p_s_sb)->j_mutex);
 }
 
 static inline void get_journal_list(struct reiserfs_journal_list *jl)
@@ -2841,7 +2841,7 @@ int journal_init(struct super_block *p_s
 	journal->j_last = NULL;
 	journal->j_first = NULL;
 	init_waitqueue_head(&(journal->j_join_wait));
-	sema_init(&journal->j_lock, 1);
+	mutex_init(&journal->j_mutex);
 	sema_init(&journal->j_flush_sem, 1);
 
 	journal->j_trans_id = 10;
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -194,7 +194,7 @@ struct reiserfs_journal {
 	struct buffer_head *j_header_bh;
 
 	time_t j_trans_start_time;	/* time this transaction started */
-	struct semaphore j_lock;
+	struct mutex j_mutex;
 	struct semaphore j_flush_sem;
 	wait_queue_head_t j_join_wait;	/* wait for current transaction to finish before starting new one */
 	atomic_t j_jlock;	/* lock for j_join_wait */

