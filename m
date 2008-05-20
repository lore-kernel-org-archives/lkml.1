Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYETSDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYETSDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbYETSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:03:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51771 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbYETSDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:03:13 -0400
Subject: [PATCH-v2] JBD: Fix race between free buffer and commit trasanction
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jack@suse.cz, pbadari@us.ibm.com, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1211234829.3663.39.camel@localhost.localdomain>
References: <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
	 <1210717389.3638.24.camel@localhost.localdomain>
	 <20080514170856.GH24363@duck.suse.cz>
	 <1210786872.3657.48.camel@localhost.localdomain>
	 <20080514181444.GI24363@duck.suse.cz>
	 <1210947250.3608.18.camel@localhost.localdomain>
	 <1210957976.4231.31.camel@badari-desktop>
	 <1210971693.3608.46.camel@localhost.localdomain>
	 <20080518223739.GB11006@atrey.karlin.mff.cuni.cz>
	 <1211227158.3663.25.camel@localhost.localdomain>
	 <20080519132553.de9b78b0.akpm@linux-foundation.org>
	 <1211234829.3663.39.camel@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 20 May 2008 11:02:55 -0700
Message-Id: <1211306575.3664.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch to use existing GFP_KERNEL mask to indicating synchornous
wait in journal_try_to_free_buffers() to resolve the race with
journal_commit_transaction().

JBD: fix race between journal_try_to_free_buffers() and jbd commit transaction

From: Mingming Cao <cmm@us.ibm.com>

journal_try_to_free_buffers() could race with jbd commit transaction when
the later is holding the buffer reference while waiting for the data buffer
to flush to disk. If the caller of journal_try_to_free_buffers() request
tries hard to release the buffers, it will treat the failure as error and return
back to the caller. We have seen the directo IO failed due to this race. 
Some of the caller of releasepage() also expecting the buffer to be dropped
when passed with GFP_KERNEL mask to the releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the GFP_KERNEL to indicating this
call could wait, in case of try_to_free_buffers() failed, let's waiting for
journal_commit_transaction() to finish commit the current committing transaction
, then try to free those buffers again with journal locked.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com> 
---
 fs/jbd/transaction.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/filemap.c         |    3 --
 2 files changed, 54 insertions(+), 4 deletions(-)

Index: linux-2.6.26-rc2/fs/jbd/transaction.c
===================================================================
--- linux-2.6.26-rc2.orig/fs/jbd/transaction.c	2008-05-11 17:09:41.000000000 -0700
+++ linux-2.6.26-rc2/fs/jbd/transaction.c	2008-05-19 16:16:41.000000000 -0700
@@ -1648,12 +1648,39 @@ out:
 	return;
 }
 
+/*
+ * journal_try_to_free_buffers() could race with journal_commit_transaction()
+ * The later might still hold the reference count to the buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ *
+ * Journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * try to free that buffer.
+ *
+ * Called with journal->j_state_lock hold.
+ */
+static void journal_wait_for_transaction_sync_data(journal_t *journal)
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
+	log_wait_commit(journal, tid);
+	spin_lock(&journal->j_state_lock);
+}
 
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: specifies whether the call may block
+ * 		(__GFP_WAIT & __GFP_FS via GFP_KERNEL)
  *
  *
  * For all the buffers on this page,
@@ -1682,9 +1709,11 @@ out:
  * journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
+ *
+ * Return 0 on failure, 1 on success
  */
 int journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t unused_gfp_mask)
+				struct page *page, gfp_t gfp_mask)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1713,7 +1742,30 @@ int journal_try_to_free_buffers(journal_
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+ 	/*
+	 * There are a number of places where journal_try_to_free_buffers()
+	 * could race with journal_commit_transaction(), the later still
+	 * holds the reference to the buffers to free while processing them.
+	 * try_to_free_buffers() failed to free those buffers. Some of the
+	 * caller of releasepage() request page buffers to be dropped, otherwise
+	 * treat the fail-to-free as errors (such as generic_file_direct_IO())
+	 *
+	 * So, if the caller of try_to_release_page() wants the synchronous
+	 * behaviour(i.e make sure buffers are dropped upon return),
+	 * let's wait for the current transaction to finish flush of
+	 * dirty data buffers, then try to free those buffers again,
+	 * with the journal locked.
+	 */
+	if (ret == 0 && gfp_mask & GFP_KERNEL) {
+        	spin_lock(&journal->j_state_lock);
+		journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+		spin_unlock(&journal->j_state_lock);
+	}
+
 busy:
 	return ret;
 }
Index: linux-2.6.26-rc2/mm/filemap.c
===================================================================
--- linux-2.6.26-rc2.orig/mm/filemap.c	2008-05-19 16:00:01.000000000 -0700
+++ linux-2.6.26-rc2/mm/filemap.c	2008-05-19 16:01:34.000000000 -0700
@@ -2581,9 +2581,8 @@ out:
  * Otherwise return zero.
  *
  * The @gfp_mask argument specifies whether I/O may be performed to release
- * this page (__GFP_IO), and whether the call may block (__GFP_WAIT).
+ * this page (__GFP_IO), and whether the call may block (__GFP_WAIT & __GFP_FS).
  *
- * NOTE: @gfp_mask may go away, and this function may become non-blocking.
  */
 int try_to_release_page(struct page *page, gfp_t gfp_mask)
 {


