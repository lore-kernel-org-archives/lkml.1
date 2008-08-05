Return-Path: <linux-kernel-owner+w=401wt.eu-S1764020AbYHEBH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764020AbYHEBH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbYHEBFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:05:25 -0400
Received: from kumera.dghda.com ([80.68.90.171]:4441 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbYHEBFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:05:25 -0400
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sct@redhat.com, linux-ext4@vger.kernel.org,
       Sami Liedes <sliedes@cc.hut.fi>, Duane Griffin <duaneg@dghda.com>
Subject: [PATCH] jbd: abort instead of waiting for nonexistent transactions
Date: Tue,  5 Aug 2008 02:05:20 +0100
Message-Id: <1217898321-3514-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __log_wait_for_space function sits in a loop checkpointing transactions
until there is sufficient space free in the journal. However, if there are
no transactions to be processed (e.g. because the free space calculation is
wrong due to a corrupted filesystem) it will never progress.

Check for space being required when no transactions are outstanding and
abort the journal instead of endlessly looping.

This patch fixes the bug reported by Sami Liedes at:
http://bugzilla.kernel.org/show_bug.cgi?id=10976

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index a5432bb..af2b554 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -126,13 +126,24 @@ void __log_wait_for_space(journal_t *journal)
 
 		/*
 		 * Test again, another process may have checkpointed while we
-		 * were waiting for the checkpoint lock
+		 * were waiting for the checkpoint lock. If there are no
+		 * outstanding transactions there is nothing to checkpoint and
+		 * we can't make progress. Abort the journal in this case.
 		 */
 		spin_lock(&journal->j_state_lock);
 		nblocks = jbd_space_needed(journal);
 		if (__log_space_left(journal) < nblocks) {
+			int chkpt = journal->j_checkpoint_transactions != NULL;
+
 			spin_unlock(&journal->j_state_lock);
-			log_do_checkpoint(journal);
+			if (chkpt) {
+				log_do_checkpoint(journal);
+			} else {
+				printk(KERN_ERR "%s: no transactions\n",
+				       __func__);
+				journal_abort(journal, 0);
+			}
+
 			spin_lock(&journal->j_state_lock);
 		}
 		mutex_unlock(&journal->j_checkpoint_mutex);
