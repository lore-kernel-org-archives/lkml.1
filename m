Return-Path: <linux-kernel-owner+w=401wt.eu-S1761803AbYEPVCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761803AbYEPVCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761917AbYEPVBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:01:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53782 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761763AbYEPVBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:01:53 -0400
Subject: [PATCH] JBD2: Fix DIO EIO error caused by race between free buffer
	and commit trasanction
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Jan Kara <jack@suse.cz>, akpm@linux-foundation.org,
       Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1210957976.4231.31.camel@badari-desktop>
References: <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
	 <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
	 <1210947250.3608.18.camel@localhost.localdomain>
	 <1210957976.4231.31.camel@badari-desktop>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 16 May 2008 14:01:41 -0700
Message-Id: <1210971701.3608.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JBD2: fix DIO error caused by race with DIO free_buffers and jbd2 commit transaction

From: Mingming Cao <cmm@us.ibm.com>

This patch fixed a few races between direct IO and kjournlad commit transaction.
An unexpected EIO error gets returned to direct IO caller when it failed to
free those data buffers. This could be reproduced easily with parallel 
direct write and buffered write to the same file

More specific, those races could cause jbd2_journal_try_to_free_buffers()
fail to free the data buffers, when jbd is committing the transaction that has
those data buffers on its t_syncdata_list or t_locked_list. 
jbd2_journal_commit_transaction() still holds the reference to those buffers
 before data reach to disk and buffers are removed from the 
t_syncdata_list of t_locked_list. This prevent the concurrent 
jbd2_journal_try_to_free_buffers() to free those buffers at the same time, but cause
EIO error returns back to direct IO.

With this patch, in case of direct IO and when try_to_free_buffers() failed,
let's waiting for jbd2_journal_commit_transaction() to finish
flushing the current committing transaction's data buffers to disk, 
then try to free those buffers again.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
---
 fs/jbd2/transaction.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc2/fs/jbd2/transaction.c
===================================================================
--- linux-2.6.26-rc2.orig/fs/jbd2/transaction.c	2008-05-16 11:16:56.000000000 -0700
+++ linux-2.6.26-rc2/fs/jbd2/transaction.c	2008-05-16 13:52:04.000000000 -0700
@@ -1656,12 +1656,39 @@ out:
 	return;
 }
 
+/*
+ * jbd2_journal_try_to_free_buffers() could race with jbd2_journal_commit_transaction()
+ * The later might still hold the reference count to the buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ *
+ * jbd2_journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * try to free that buffer.
+ *
+ * Called with journal->j_state_lock hold.
+ */
+static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+	transaction_t *transaction = NULL;
+	tid_t tid;
+
+	transaction = journal->j_committing_transaction;
+
+	if (!transaction)
+		return;
+
+	tid = transaction->t_tid;
+	spin_unlock(&journal->j_state_lock);
+	jbd2_log_wait_commit(journal, tid);
+	spin_lock(&journal->j_state_lock);
+}
 
 /**
  * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: unused for allocation purpose. Here is used
+ * 	      as a flag to tell if direct IO is attemping to free buffers.
  *
  *
  * For all the buffers on this page,
@@ -1690,9 +1717,11 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int jbd2_journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1721,7 +1750,31 @@ int jbd2_journal_try_to_free_buffers(jou
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+ 	/*
+	 * In the case of concurrent direct IO and buffered IO,
+	 * There are a number of places where we
+	 * could race with jbd2_journal_commit_transaction(), the later still
+	 * holds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers,
+	 * resulting in an unexpected EIO error
+	 * returns back to the generic_file_direct_IO()
+	 *
+	 * So let's wait for the current transaction to finish flush of
+	 * dirty data buffers before we try to free those buffers
+	 * again. This wait is needed by direct IO code path only,
+	 * gfp_mask __GFP_REPEAT is passed from the direct IO code
+	 * path to flag if we need to wait and retry free buffers.
+	 */
+	if (ret == 0 && gfp_mask & __GFP_REPEAT) {
+        	spin_lock(&journal->j_state_lock);
+		jbd2_journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+		spin_unlock(&journal->j_state_lock);
+	}
+
 busy:
 	return ret;
 }



