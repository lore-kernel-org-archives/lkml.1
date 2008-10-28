Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYJ1Bwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYJ1Bwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYJ1Bwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:52:33 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44090 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752914AbYJ1Bwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:52:32 -0400
Date: Mon, 27 Oct 2008 21:52:28 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: general protection fault:  from release_blocks_on_commit
Message-ID: <20081028015228.GA8320@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1224612181.19719.20.camel@paris-laptop> <20081027181928.GB23111@mit.edu> <49064027.9010509@redhat.com> <20081027232843.GA9797@mit.edu> <49065805.1080303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49065805.1080303@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 07:08:37PM -0500, Eric Sandeen wrote:
> Theodore Tso wrote:
> > On Mon, Oct 27, 2008 at 05:26:47PM -0500, Eric Sandeen wrote:
> >> Ted, you probably need some slab debugging on to hit it.
> > 
> > I had slab debugging enabled, but haven't been able to replicate it
> > yet.  I'll do some more work to try to replicate it.
> > 
> >> I think the problem is that jbd2_journal_commit_transaction may call
> >> __jbd2_journal_drop_transaction(journal, commit_transaction) if the
> >> checkpoint lists are NULL, and this frees the commit_transaction.
> > 
> > I think you're right.  I would probably change the patch around so
> > that after calling __jbd2_jurnal_drop_transaction(), we set
> > commit_transaction to NULL, and then adding an "if
> > (commit_transaction)" to the lines in questions; that way we keep the
> > commit callback outside of the j_list_lock() spinlock.
> 
> Ok, I thought about that; sounds good.  will resend.

I looked at this some more, and at least in theory it could happen
that we could not have any buffers that need to be checkpointed (so
t_checkpoint_list and t_checkpoint_io_list are NULL), but there are
still blocks to be released (or some other users of the jbd2 layer
still wants to have the callback be called).  So I'm currently testing
this patch (see below).

							- Ted

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 8b119e1..ebc667b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -974,6 +974,9 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
+	if (journal->j_commit_callback)
+		journal->j_commit_callback(journal, commit_transaction);
+
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
@@ -995,11 +998,8 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	if (journal->j_commit_callback)
-		journal->j_commit_callback(journal, commit_transaction);
-
 	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
-		   journal->j_devname, commit_transaction->t_tid,
+		   journal->j_devname, journal->j_commit_sequence,
 		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
