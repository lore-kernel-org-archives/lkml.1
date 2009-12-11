Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbZLKEfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbZLKEfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbZLKEfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:35:44 -0500
Received: from kroah.org ([198.145.64.141]:52856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856AbZLKEfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:36 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:26 2009
Message-Id: <20091211042726.354254054@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Alex Zhuravlev (Tomas)" <alex.zhuravlev@sun.com>,
       Andreas Dilger <adilger@sun.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [04/90] jbd2: round commit timer up to avoid uncommitted transaction
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0004-jbd2-round-commit-timer-up-to-avoid-uncommitted-tran.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit b1f485f20eb9b02cc7d2009556287f3939d480cc)

fix jiffie rounding in jbd commit timer setup code.  Rounding down
could cause the timer to be fired before the corresponding transaction
has expired.  That transaction can stay not committed forever if no
new transaction is created or expicit sync/umount happens.

Signed-off-by: Alex Zhuravlev (Tomas) <alex.zhuravlev@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -57,7 +57,7 @@ jbd2_get_transaction(journal_t *journal,
 	INIT_LIST_HEAD(&transaction->t_private_list);
 
 	/* Set up the commit timer for the new transaction. */
-	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
+	journal->j_commit_timer.expires = round_jiffies_up(transaction->t_expires);
 	add_timer(&journal->j_commit_timer);
 
 	J_ASSERT(journal->j_running_transaction == NULL);


