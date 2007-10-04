Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXJDFxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXJDFxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXJDFvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:51:21 -0400
Received: from THUNK.ORG ([69.25.196.29]:44803 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbXJDFvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:09 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] jbd2: fix commit code to properly abort journal
Date: Thu,  4 Oct 2007 01:50:40 -0400
Message-Id: <1191477059-5357-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.2.81.g17ed
In-Reply-To: <1191477059-5357-5-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

We should really call journal_abort() and not __journal_abort_hard() in
case of errors.  The latter call does not record the error in the journal
superblock and thus filesystem won't be marked as with errors later (and
user could happily mount it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/jbd2/commit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index b898ee4..6986f33 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -475,7 +475,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	spin_unlock(&journal->j_list_lock);
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
@@ -533,7 +533,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 
 			descriptor = jbd2_journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
-				__jbd2_journal_abort_hard(journal);
+				jbd2_journal_abort(journal, -EIO);
 				continue;
 			}
 
@@ -566,7 +566,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		   and repeat this loop: we'll fall into the
 		   refile-on-abort condition above. */
 		if (err) {
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 			continue;
 		}
 
@@ -757,7 +757,7 @@ wait_for_iobuf:
 		err = -EIO;
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
-- 
1.5.3.2.81.g17ed

