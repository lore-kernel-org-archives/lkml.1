Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZGAAj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZGAAj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760850AbZGAAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:39 -0400
Received: from kroah.org ([198.145.64.141]:59733 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760821AbZGAAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:48 2009
Message-Id: <20090701001548.636200762@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>
Subject: [patch 04/35] jbd: fix race in buffer processing in commit code
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=jbd-fix-race-in-buffer-processing-in-commit-code.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit a61d90d75d0f9e86432c45b496b4b0fbf0fd03dc upstream.

In commit code, we scan buffers attached to a transaction.  During this
scan, we sometimes have to drop j_list_lock and then we recheck whether
the journal buffer head didn't get freed by journal_try_to_free_buffers().
 But checking for buffer_jbd(bh) isn't enough because a new journal head
could get attached to our buffer head.  So add a check whether the journal
head remained the same and whether it's still at the same transaction and
list.

This is a nasty bug and can cause problems like memory corruption (use after
free) or trigger various assertions in JBD code (observed).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -238,7 +238,7 @@ write_out_data:
 			spin_lock(&journal->j_list_lock);
 		}
 		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
+		if (!buffer_jbd(bh) || bh2jh(bh) != jh
 			|| jh->b_transaction != commit_transaction
 			|| jh->b_jlist != BJ_SyncData) {
 			jbd_unlock_bh_state(bh);
@@ -466,7 +466,9 @@ void journal_commit_transaction(journal_
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
+		if (buffer_jbd(bh) && bh2jh(bh) == jh &&
+		    jh->b_transaction == commit_transaction &&
+		    jh->b_jlist == BJ_Locked) {
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);


