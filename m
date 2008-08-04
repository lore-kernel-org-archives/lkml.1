Return-Path: <linux-kernel-owner+w=401wt.eu-S1762751AbYHDUXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751AbYHDUXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762362AbYHDUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:22:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:48598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758693AbYHDUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:22:51 -0400
Date: Mon, 4 Aug 2008 13:15:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mingming Cao <cmm@us.ibm.com>,
       Jan Kara <jack@suse.cz>
Subject: [patch 08/33] jbd: fix race between free buffer and commit
	transaction
Message-ID: <20080804201500.GI1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="jbd-fix-race-between-free-buffer-and-commit-transaction.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Mingming Cao <cmm@us.ibm.com>

commit 3f31fddfa26b7594b44ff2b34f9a04ba409e0f91 upstream

journal_try_to_free_buffers() could race with jbd commit transaction when
the later is holding the buffer reference while waiting for the data
buffer to flush to disk.  If the caller of journal_try_to_free_buffers()
request tries hard to release the buffers, it will treat the failure as
error and return back to the caller.  We have seen the directo IO failed
due to this race.  Some of the caller of releasepage() also expecting the
buffer to be dropped when passed with GFP_KERNEL mask to the
releasepage()->journal_try_to_free_buffers().

With this patch, if the caller is passing the __GFP_WAIT and __GFP_FS to
indicating this call could wait, in case of try_to_free_buffers() failed,
let's waiting for journal_commit_transaction() to finish commit the
current committing transaction, then try to free those buffers again.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/transaction.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/filemap.c         |    3 --
 2 files changed, 56 insertions(+), 4 deletions(-)

--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1633,12 +1633,42 @@ out:
 	return;
 }
 
+/*
+ * journal_try_to_free_buffers() could race with journal_commit_transaction()
+ * The latter might still hold the a count on buffers when inspecting
+ * them on t_syncdata_list or t_locked_list.
+ *
+ * journal_try_to_free_buffers() will call this function to
+ * wait for the current transaction to finish syncing data buffers, before
+ * tryinf to free that buffer.
+ *
+ * Called with journal->j_state_lock held.
+ */
+static void journal_wait_for_transaction_sync_data(journal_t *journal)
+{
+	transaction_t *transaction = NULL;
+	tid_t tid;
+
+	spin_lock(&journal->j_state_lock);
+	transaction = journal->j_committing_transaction;
+
+	if (!transaction) {
+		spin_unlock(&journal->j_state_lock);
+		return;
+	}
+
+	tid = transaction->t_tid;
+	spin_unlock(&journal->j_state_lock);
+	log_wait_commit(journal, tid);
+}
 
 /**
  * int journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
- * @unused_gfp_mask: unused
+ * @gfp_mask: we use the mask to detect how hard should we try to release
+ * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
+ * release the buffers.
  *
  *
  * For all the buffers on this page,
@@ -1667,9 +1697,11 @@ out:
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
@@ -1698,7 +1730,28 @@ int journal_try_to_free_buffers(journal_
 		if (buffer_jbd(bh))
 			goto busy;
 	} while ((bh = bh->b_this_page) != head);
+
 	ret = try_to_free_buffers(page);
+
+	/*
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
+	if (ret == 0 && (gfp_mask & __GFP_WAIT) && (gfp_mask & __GFP_FS)) {
+		journal_wait_for_transaction_sync_data(journal);
+		ret = try_to_free_buffers(page);
+	}
+
 busy:
 	return ret;
 }
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2574,9 +2574,8 @@ out:
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

-- 
