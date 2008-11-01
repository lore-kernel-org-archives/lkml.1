Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYKAQi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYKAQi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 12:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYKAQij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 12:38:39 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55258 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbYKAQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 12:38:38 -0400
Date: Sat, 1 Nov 2008 12:38:29 -0400
From: Theodore Tso <tytso@mit.edu>
To: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
Message-ID: <20081101163829.GD8134@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Meelis Roos <mroos@linux.ee>,
	Andrew Morton <akpm@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081031235459.055c35d7.akpm@linux-foundation.org> <Pine.SOC.4.64.0811011058240.18925@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0811011058240.18925@math.ut.ee>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 10:59:11AM +0200, Meelis Roos wrote:
> > > __log_wait_for_space: no transactions
> > > Aborting journal on device sda3.
> > > ext3_abort called.
> > > EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> > > Remounting filesystem read-only
> > 
> > ug.  Was 2.6.27 OK?
> 
> Yes, no known problems and it ran from 2.6.27 release until sometime 
> between 28-rc1 and 28-rc2 without problems.

Ok, I think see the problem.  I'm pretty sure the problem is this
commit:

commit be07c4ed4043ab8c26f222348136141335e47a2f
Author: Duane Griffin <duaneg@dghda.com>
Date:   Wed Oct 22 14:15:03 2008 -0700

    jbd: abort instead of waiting for nonexistent transactions
    
    The __log_wait_for_space function sits in a loop checkpointing
    transactions until there is sufficient space free in the journal.
    However, if there are no transactions to be processed (e.g.  because the
    free space calculation is wrong due to a corrupted filesystem) it will
    never progress.
    
    Check for space being required when no transactions are outstanding and
    abort the journal instead of endlessly looping.
    
    This patch fixes the bug reported by Sami Liedes at:
    http://bugzilla.kernel.org/show_bug.cgi?id=10976

The problem is that for small journals, you can run out of space even
when there is a single transaction in the journal which is in the
process of being committed, and no transactions ready to be
checkpointed.  So the logic in the above patch will cause a journal
abort too aggressively.

My advice to increase the journal size still applies, since it will
improve performance considerably; but hopefully this patch will make
things work correctly even with legacy filesystems with very small
journals.  (Hmm, I wonder if it's worth adding an e2fsck warning
telling users that they're running with a small journal and they would
get better performance if they increased their journal size.)

Can you try this patch and see if it fixes things for you?

    	    	       	       	     	   	      - Ted

>From fc329ed8e05ea0d6deebde096e1d29201f82f990 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sat, 1 Nov 2008 12:36:41 -0400
Subject: [PATCH] jbd: Make __log_wait_for_space wait for the committing transaction to finish

Commit be07c4ed introducd a regression because it assumed that if
there were no transactions ready to be checkpointed, that no progress
could be made on making space available in the journal, and so the
journal should be aborted.  This assumption is false; for small
journals, the currently committing transaction could be responsible
for chewing up the required space in the log, so we need to wait for
the currently committing transaction to finish before trying to force
a checkpoint operation.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Duane Griffin <duaneg@dghda.com>

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 1bd8d4a..89faee1 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -128,25 +128,36 @@ void __log_wait_for_space(journal_t *journal)
 		/*
 		 * Test again, another process may have checkpointed while we
 		 * were waiting for the checkpoint lock. If there are no
-		 * outstanding transactions there is nothing to checkpoint and
-		 * we can't make progress. Abort the journal in this case.
+		 * transactions ready to be checkpointed, we may need to
+		 * wait for the currently committing transaction to complete
+		 * first.  If there are no outstanding transactions we can't
+		 * make progress.  This should never happen, so call trigger
+		 * a BUG so we can debug the situation.
 		 */
 		spin_lock(&journal->j_state_lock);
 		spin_lock(&journal->j_list_lock);
 		nblocks = jbd_space_needed(journal);
 		if (__log_space_left(journal) < nblocks) {
 			int chkpt = journal->j_checkpoint_transactions != NULL;
+			int tid = 0;
 
+			if (journal->j_committing_transaction)
+				tid = journal->j_committing_transaction->t_tid;
 			spin_unlock(&journal->j_list_lock);
 			spin_unlock(&journal->j_state_lock);
 			if (chkpt) {
 				log_do_checkpoint(journal);
+			} else if (tid) {
+				log_wait_commit(journal, tid);
 			} else {
-				printk(KERN_ERR "%s: no transactions\n",
-				       __func__);
-				journal_abort(journal, 0);
+				printk(KERN_ALERT "%s: needed %d blocks and "
+				       "only had %d space available\n",
+				       __func__, nblocks,
+				       __log_space_left(journal));
+				printk(KERN_ALERT "%s: no way to get more "
+				       "journal space\n", __func__);
+				BUG();
 			}
-
 			spin_lock(&journal->j_state_lock);
 		} else {
 			spin_unlock(&journal->j_list_lock);
