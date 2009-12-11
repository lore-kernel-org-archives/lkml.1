Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbZLKEgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbZLKEgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758980AbZLKEgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:02 -0500
Received: from kroah.org ([198.145.64.141]:52878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759073AbZLKEfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:39 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:29 2009
Message-Id: <20091211042728.672704124@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [08/90] jbd2: Annotate transaction start also for jbd2_journal_restart()
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0008-jbd2-Annotate-transaction-start-also-for-jbd2_journa.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit 9599b0e597d810be9b8f759ea6e9619c4f983c5e)

lockdep annotation for a transaction start has been at the end of
jbd2_journal_start(). But a transaction is also started from
jbd2_journal_restart(). Move the lockdep annotation to start_this_handle()
which covers both cases.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd2/transaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -238,6 +238,8 @@ repeat_locked:
 		  __jbd2_log_space_left(journal));
 	spin_unlock(&transaction->t_handle_lock);
 	spin_unlock(&journal->j_state_lock);
+
+	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
 		kfree(new_transaction);
@@ -303,8 +305,6 @@ handle_t *jbd2_journal_start(journal_t *
 		handle = ERR_PTR(err);
 		goto out;
 	}
-
-	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	return handle;
 }
@@ -426,6 +426,7 @@ int jbd2_journal_restart(handle_t *handl
 	__jbd2_log_start_commit(journal, transaction->t_tid);
 	spin_unlock(&journal->j_state_lock);
 
+	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
 	ret = start_this_handle(journal, handle);
 	return ret;


