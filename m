Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZDFMtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZDFMtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZDFMsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50495 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZDFMsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:15 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 5/8] jbd2: use WRITE_SYNC_PLUG instead of WRITE_SYNC
Date: Mon,  6 Apr 2009 14:48:05 +0200
Message-Id: <1239022088-29002-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you are going to be submitting several sync writes, we want to
give the IO scheduler a chance to merge some of them. Instead of
using the implicitly unplugging WRITE_SYNC variant, use WRITE_SYNC_PLUG
and rely on sync_buffer() doing the unplug when someone does a
wait_on_buffer()/lock_buffer().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/jbd2/commit.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 4ea7237..073c8c3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -138,7 +138,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		set_buffer_ordered(bh);
 		barrier_done = 1;
 	}
-	ret = submit_bh(WRITE_SYNC, bh);
+	ret = submit_bh(WRITE_SYNC_PLUG, bh);
 	if (barrier_done)
 		clear_buffer_ordered(bh);
 
@@ -159,7 +159,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		lock_buffer(bh);
 		set_buffer_uptodate(bh);
 		clear_buffer_dirty(bh);
-		ret = submit_bh(WRITE_SYNC, bh);
+		ret = submit_bh(WRITE_SYNC_PLUG, bh);
 	}
 	*cbh = bh;
 	return ret;
@@ -190,7 +190,7 @@ retry:
 		set_buffer_uptodate(bh);
 		bh->b_end_io = journal_end_buffer_io_sync;
 
-		ret = submit_bh(WRITE_SYNC, bh);
+		ret = submit_bh(WRITE_SYNC_PLUG, bh);
 		if (ret) {
 			unlock_buffer(bh);
 			return ret;
@@ -402,8 +402,13 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_LOCKED;
 
+	/*
+	 * Use plugged writes here, since we want to submit several before
+	 * we unplug the device. We don't do explicit unplugging in here,
+	 * instead we rely on sync_buffer() doing the unplug for us.
+	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC;
+		write_op = WRITE_SYNC_PLUG;
 	stats.u.run.rs_wait = commit_transaction->t_max_wait;
 	stats.u.run.rs_locked = jiffies;
 	stats.u.run.rs_running = jbd2_time_diff(commit_transaction->t_start,
-- 
1.6.2.1.423.g442d

