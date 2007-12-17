Return-Path: <linux-kernel-owner+w=401wt.eu-S935853AbXLQMNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935853AbXLQMNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXLQMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:13:29 -0500
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:3463 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027AbXLQMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:13:28 -0500
Subject: Possible fix for lockup in drop_caches
From: richard <richard@rsk.demon.co.uk>
To: akpm@linux-foundation.org
Cc: den@openvz.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 12:13:22 +0000
Message-Id: <1197893602.2866.13.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 3 Dec 2007 16:52:47 +0300
> "Denis V. Lunev" <den@openvz.org> wrote:
> 
>> There is a AB-BA deadlock regarding drop_caches sysctl. Here are the
code
>> paths:

snip...

> One way to fix jbd (and jbd2) would be:
> 
> static void __journal_temp_unlink_buffer(struct journal_head *jh,
> 					struct buffer_head **bh_to_dirty)
> {
> 	*bh_to_dirty = NULL;
> 	...
> 	if (test_clear_buffer_jbddirty(bh))
> 		*bh_to_dirty = bh;
> }
> 
> {
> 	struct buffer_head *bh_to_dirty;	/* probably needs
uninitialized_var() */
> 
> 	...
> 	__journal_temp_unlink_buffer(jh, &bh_to_dirty);
> 	...
> 	jbd_mark_buffer_dirty(bh_to_dirty);
> 	brelse(bh_to_dirty);
> 	...
> }
> 
> static inline void jbd_mark_buffer_dirty(struct buffer_head *bh)
> {
> 	if (bh)
> 		mark_buffer_dirty(bh);
> }
> 
> 
> --
Hi Andrew,
here's an implementation of your suggested approach for jbd.

Without this patch my test-case will lockup in 3 to 5 iterations, with
the patch I have completed 96+ runs.

I don't see any significant difference in write performance with this
patch applied. Subjectively I feel that my system is more responsive
when under heavy write loads but I don't have data to back that up, so
it might just be wishful thinking on my part!   

I've tested this on AMD 64x2 SMP 2.6.24-rc*

the patch is against 2.6.24-rc5.

Cheers
Richard

 fs/jbd/commit.c      |   19 +++++++++++---
 fs/jbd/transaction.c |   66 +++++++++++++++++++++++++++++++++++----------------
 include/linux/jbd.h  |   11 ++++++--
 3 files changed, 70 insertions(+), 26 deletions(-)
----
commit 5b3824aa42a07682777836814fc7d1882416c6d3
Author: Richard Kennedy <richard@rsk.demon.co.uk>
Date:   Mon Dec 17 12:05:36 2007 +0000

    fix lockup in when calling drop_caches
    
    calling /proc/sys/vm/drop_caches can hang due to a AB/BA lock dependency
    between j_list_lock and the inode_lock. This patch moves the redirtying of the buffer head out
    from under the j_list_lock.
    
    based on a suggestion by Andrew Morton.
    
    Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 610264b..9115b5d 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -181,6 +181,7 @@ static void journal_submit_data_buffers(journal_t *journal,
 	int locked;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
+	struct buffer_head *dirty_bh;
 
 	/*
 	 * Whenever we unlock the journal and sleep, things can get added
@@ -254,7 +255,8 @@ write_out_data:
 			put_bh(bh);
 		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(jh, &dirty_bh);
+			jbd_mark_buffer_dirty(dirty_bh);
 			jbd_unlock_bh_state(bh);
 			if (locked)
 				unlock_buffer(bh);
@@ -296,6 +298,7 @@ void journal_commit_transaction(journal_t *journal)
 	int first_tag = 0;
 	int tag_flag;
 	int i;
+	struct buffer_head *dirty_bh;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -453,7 +456,9 @@ void journal_commit_transaction(journal_t *journal)
 			continue;
 		}
 		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
-			__journal_unfile_buffer(jh);
+			struct buffer_head *dirty_bh;
+			__journal_unfile_buffer(jh, &dirty_bh);
+			jbd_mark_buffer_dirty(dirty_bh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);
 			put_bh(bh);
@@ -833,7 +838,12 @@ restart_loop:
 			JBUFFER_TRACE(jh, "add to new checkpointing trans");
 			__journal_insert_checkpoint(jh, commit_transaction);
 			JBUFFER_TRACE(jh, "refile for checkpoint writeback");
-			__journal_refile_buffer(jh);
+			__journal_refile_buffer(jh, &dirty_bh);
+			if (dirty_bh) {
+				spin_unlock(&journal->j_list_lock);
+				jbd_mark_buffer_dirty(dirty_bh);
+				spin_lock(&journal->j_list_lock);
+			}
 			jbd_unlock_bh_state(bh);
 		} else {
 			J_ASSERT_BH(bh, !buffer_dirty(bh));
@@ -845,7 +855,8 @@ restart_loop:
 			 * disk and before we process the buffer on BJ_Forget
 			 * list. */
 			JBUFFER_TRACE(jh, "refile or unfile freed buffer");
-			__journal_refile_buffer(jh);
+			/* As !jbddirty dirty_bh will always be null so we can ignore it */
+			__journal_refile_buffer(jh, &dirty_bh);
 			if (!jh->b_transaction) {
 				jbd_unlock_bh_state(bh);
 				 /* needs a brelse */
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 08ff6c7..5bf6202 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -26,7 +26,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
-static void __journal_temp_unlink_buffer(struct journal_head *jh);
+static void __journal_temp_unlink_buffer(struct journal_head *jh,
+		struct buffer_head **bh);
 
 /*
  * get_transaction: obtain a new transaction_t object.
@@ -938,6 +939,7 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	struct buffer_head *dirty_bh = NULL;
 
 	if (is_handle_aborted(handle))
 		return 0;
@@ -1054,7 +1056,7 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 			/* journal_clean_data_list() may have got there first */
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
-				__journal_temp_unlink_buffer(jh);
+				__journal_temp_unlink_buffer(jh, &dirty_bh);
 				/* It still points to the committing
 				 * transaction; move it to this one so
 				 * that the refile assert checks are
@@ -1073,7 +1075,7 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
 			JBUFFER_TRACE(jh, "not on correct data list: unfile");
 			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
-			__journal_temp_unlink_buffer(jh);
+			__journal_temp_unlink_buffer(jh, &dirty_bh);
 			jh->b_transaction = handle->h_transaction;
 			JBUFFER_TRACE(jh, "file as data");
 			__journal_file_buffer(jh, handle->h_transaction,
@@ -1085,6 +1087,7 @@ int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 	}
 no_journal:
 	spin_unlock(&journal->j_list_lock);
+	jbd_mark_buffer_dirty(dirty_bh);
 	jbd_unlock_bh_state(bh);
 	if (need_brelse) {
 		BUFFER_TRACE(bh, "brelse");
@@ -1217,6 +1220,7 @@ int journal_forget (handle_t *handle, struct buffer_head *bh)
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
 	struct journal_head *jh;
+	struct buffer_head *dirty_bh = NULL;
 	int drop_reserve = 0;
 	int err = 0;
 
@@ -1269,10 +1273,12 @@ int journal_forget (handle_t *handle, struct buffer_head *bh)
 		 */
 
 		if (jh->b_cp_transaction) {
-			__journal_temp_unlink_buffer(jh);
+			__journal_temp_unlink_buffer(jh, &dirty_bh);
+			jbd_mark_buffer_dirty(dirty_bh);
 			__journal_file_buffer(jh, transaction, BJ_Forget);
 		} else {
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(jh, &dirty_bh);
+			jbd_mark_buffer_dirty(dirty_bh);
 			journal_remove_journal_head(bh);
 			__brelse(bh);
 			if (!buffer_jbd(bh)) {
@@ -1507,8 +1513,10 @@ __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
  * Generally the caller needs to re-read the pointer from the transaction_t.
  *
  * Called under j_list_lock.  The journal may not be locked.
+ * returns a buffer head that needs to be marked dirty
  */
-static void __journal_temp_unlink_buffer(struct journal_head *jh)
+static void __journal_temp_unlink_buffer(struct journal_head *jh,
+		struct buffer_head **dirty_bh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
@@ -1523,6 +1531,7 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	if (jh->b_jlist != BJ_None)
 		J_ASSERT_JH(jh, transaction != NULL);
 
+	*dirty_bh = NULL;
 	switch (jh->b_jlist) {
 	case BJ_None:
 		return;
@@ -1557,21 +1566,24 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	__blist_del_buffer(list, jh);
 	jh->b_jlist = BJ_None;
 	if (test_clear_buffer_jbddirty(bh))
-		mark_buffer_dirty(bh);	/* Expose it to the VM */
+		*dirty_bh = bh; /* bh needs to be dirtied to expose it to the vm */
 }
 
-void __journal_unfile_buffer(struct journal_head *jh)
+void __journal_unfile_buffer(struct journal_head *jh,
+		struct buffer_head **dirty_bh)
 {
-	__journal_temp_unlink_buffer(jh);
+	__journal_temp_unlink_buffer(jh, dirty_bh);
 	jh->b_transaction = NULL;
 }
 
 void journal_unfile_buffer(journal_t *journal, struct journal_head *jh)
 {
+	struct buffer_head *bh;
 	jbd_lock_bh_state(jh2bh(jh));
 	spin_lock(&journal->j_list_lock);
-	__journal_unfile_buffer(jh);
+	__journal_unfile_buffer(jh, &bh);
 	spin_unlock(&journal->j_list_lock);
+	jbd_mark_buffer_dirty(bh);
 	jbd_unlock_bh_state(jh2bh(jh));
 }
 
@@ -1584,6 +1596,8 @@ static void
 __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 {
 	struct journal_head *jh;
+	int need_brelse = 0;
+	struct buffer_head *dirty_bh = NULL;
 
 	jh = bh2jh(bh);
 
@@ -1598,9 +1612,9 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
-			__journal_unfile_buffer(jh);
+			__journal_unfile_buffer(jh, &dirty_bh);
 			journal_remove_journal_head(bh);
-			__brelse(bh);
+			need_brelse = 1;
 		}
 	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
@@ -1608,10 +1622,13 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
 			__journal_remove_checkpoint(jh);
 			journal_remove_journal_head(bh);
-			__brelse(bh);
+			need_brelse = 1;
 		}
 	}
 	spin_unlock(&journal->j_list_lock);
+	jbd_mark_buffer_dirty(dirty_bh);
+	if (need_brelse)
+		__brelse(bh);
 out:
 	return;
 }
@@ -1702,8 +1719,10 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
 {
 	int may_free = 1;
 	struct buffer_head *bh = jh2bh(jh);
+	struct buffer_head *dirty_bh;
 
-	__journal_unfile_buffer(jh);
+	__journal_unfile_buffer(jh, &dirty_bh);
+	jbd_mark_buffer_dirty(dirty_bh);
 
 	if (jh->b_cp_transaction) {
 		JBUFFER_TRACE(jh, "on running+cp transaction");
@@ -1956,6 +1975,7 @@ void __journal_file_buffer(struct journal_head *jh,
 	struct journal_head **list = NULL;
 	int was_dirty = 0;
 	struct buffer_head *bh = jh2bh(jh);
+	struct buffer_head *dirty_bh;
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
 	assert_spin_locked(&transaction->t_journal->j_list_lock);
@@ -1978,8 +1998,10 @@ void __journal_file_buffer(struct journal_head *jh,
 			was_dirty = 1;
 	}
 
-	if (jh->b_transaction)
-		__journal_temp_unlink_buffer(jh);
+	if (jh->b_transaction) {
+		__journal_temp_unlink_buffer(jh, &dirty_bh);
+		jbd_mark_buffer_dirty(dirty_bh);
+	}
 	jh->b_transaction = transaction;
 
 	switch (jlist) {
@@ -2041,7 +2063,8 @@ void journal_file_buffer(struct journal_head *jh,
  *
  * Called under jbd_lock_bh_state(jh2bh(jh))
  */
-void __journal_refile_buffer(struct journal_head *jh)
+void __journal_refile_buffer(struct journal_head *jh,
+		struct buffer_head **dirty_bh)
 {
 	int was_dirty;
 	struct buffer_head *bh = jh2bh(jh);
@@ -2052,7 +2075,7 @@ void __journal_refile_buffer(struct journal_head *jh)
 
 	/* If the buffer is now unused, just drop it. */
 	if (jh->b_next_transaction == NULL) {
-		__journal_unfile_buffer(jh);
+		__journal_unfile_buffer(jh, dirty_bh);
 		return;
 	}
 
@@ -2062,7 +2085,8 @@ void __journal_refile_buffer(struct journal_head *jh)
 	 */
 
 	was_dirty = test_clear_buffer_jbddirty(bh);
-	__journal_temp_unlink_buffer(jh);
+	/* as we just cleared jbddirty we could safely ignore dirty_bh */
+	__journal_temp_unlink_buffer(jh, dirty_bh);
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
 	__journal_file_buffer(jh, jh->b_transaction,
@@ -2090,14 +2114,16 @@ void __journal_refile_buffer(struct journal_head *jh)
 void journal_refile_buffer(journal_t *journal, struct journal_head *jh)
 {
 	struct buffer_head *bh = jh2bh(jh);
+	struct buffer_head *dirty_bh;
 
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
 
-	__journal_refile_buffer(jh);
+	__journal_refile_buffer(jh, &dirty_bh);
 	jbd_unlock_bh_state(bh);
 	journal_remove_journal_head(bh);
 
 	spin_unlock(&journal->j_list_lock);
+	jbd_mark_buffer_dirty(dirty_bh);
 	__brelse(bh);
 }
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index d9ecd13..8c22a33 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -835,14 +835,21 @@ struct journal_s
 
 /* Filing buffers */
 extern void journal_unfile_buffer(journal_t *, struct journal_head *);
-extern void __journal_unfile_buffer(struct journal_head *);
-extern void __journal_refile_buffer(struct journal_head *);
+extern void __journal_unfile_buffer(struct journal_head *,
+		struct buffer_head **dirty_bh);
+extern void __journal_refile_buffer(struct journal_head *,
+		struct buffer_head **dirty_bh);
 extern void journal_refile_buffer(journal_t *, struct journal_head *);
 extern void __journal_file_buffer(struct journal_head *, transaction_t *, int);
 extern void __journal_free_buffer(struct journal_head *bh);
 extern void journal_file_buffer(struct journal_head *, transaction_t *, int);
 extern void __journal_clean_data_list(transaction_t *transaction);
 
+static inline void jbd_mark_buffer_dirty(struct buffer_head *bh)
+{
+	if (bh)
+		mark_buffer_dirty(bh);
+}
 /* Log buffer allocation */
 extern struct journal_head * journal_get_descriptor_buffer(journal_t *);
 int journal_next_log_block(journal_t *, unsigned long *);


