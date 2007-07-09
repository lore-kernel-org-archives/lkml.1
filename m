Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbXGIR7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbXGIR7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXGIR7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:59:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:41816 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754469AbXGIR7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:59:40 -0400
Date: Mon, 9 Jul 2007 20:14:43 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill Korotaev <dev@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Lost JBD fix
Message-ID: <20070709181443.GF30433@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Andrew,

  it seems we've accidentally lost one JBD fix (probably it was my mistake
when rediffing some checkpointing changes) as Kirill has noted. A transaction
can currently be released when there are still some buffers on one of its
checkpointing lists. Attached patch should fix it (it still seems to apply
fine). Please apply it. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--rwEMma7ioTxnRzrJ
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="jbd-2.6.16-rc1-2-commit_remove_trans_fix.diff"

We have to check that also the second checkpoint list is non-empty before
dropping the transaction.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.16-rc1/fs/jbd/commit.c linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c
--- linux-2.6.16-rc1/fs/jbd/commit.c	2006-01-15 00:20:12.000000000 +0100
+++ linux-2.6.16-rc1-1-checkpoint-fix/fs/jbd/commit.c	2006-01-17 23:35:19.000000000 +0100
@@ -829,7 +829,8 @@ restart_loop:
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL) {
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {

--rwEMma7ioTxnRzrJ--
