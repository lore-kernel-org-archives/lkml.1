Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYLVV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYLVV43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbYLVVtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:38630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbYLVVtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:20 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 20/56] ocfs2: Support nested transactions
Date: Mon, 22 Dec 2008 13:48:01 -0800
Message-Id: <1229982517-3455-21-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

OCFS2 can easily support nested transactions. We just have to
take care and not spoil statistics acquire semaphore unnecessarily.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/journal.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 12b62a3..11a1178 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -256,11 +256,9 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 	BUG_ON(osb->journal->j_state == OCFS2_JOURNAL_FREE);
 	BUG_ON(max_buffs <= 0);
 
-	/* JBD might support this, but our journalling code doesn't yet. */
-	if (journal_current_handle()) {
-		mlog(ML_ERROR, "Recursive transaction attempted!\n");
-		BUG();
-	}
+	/* Nested transaction? Just return the handle... */
+	if (journal_current_handle())
+		return jbd2_journal_start(journal, max_buffs);
 
 	down_read(&osb->journal->j_trans_barrier);
 
@@ -285,16 +283,18 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)
 int ocfs2_commit_trans(struct ocfs2_super *osb,
 		       handle_t *handle)
 {
-	int ret;
+	int ret, nested;
 	struct ocfs2_journal *journal = osb->journal;
 
 	BUG_ON(!handle);
 
+	nested = handle->h_ref > 1;
 	ret = jbd2_journal_stop(handle);
 	if (ret < 0)
 		mlog_errno(ret);
 
-	up_read(&journal->j_trans_barrier);
+	if (!nested)
+		up_read(&journal->j_trans_barrier);
 
 	return ret;
 }
-- 
1.5.6

