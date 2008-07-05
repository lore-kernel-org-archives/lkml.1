Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYGERir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYGERir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYGERga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:36:30 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33017 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753174AbYGERgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 12/52] jbd2: Add commit time into the commit block
Date: Sat,  5 Jul 2008 13:35:38 -0400
Message-Id: <1215279378-30504-13-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-12-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood has demonstrated that it's possible to recover deleted
files from the journal.  Something that will make this easier is if we
can put the time of the commit into commit block.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/commit.c     |    3 +++
 include/linux/jbd2.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index a2ed72f..92b6ac3 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -112,6 +112,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	struct buffer_head *bh;
 	int ret;
 	int barrier_done = 0;
+	struct timespec now = current_kernel_time();
 
 	if (is_journal_aborted(journal))
 		return 0;
@@ -126,6 +127,8 @@ static int journal_submit_commit_record(journal_t *journal,
 	tmp->h_magic = cpu_to_be32(JBD2_MAGIC_NUMBER);
 	tmp->h_blocktype = cpu_to_be32(JBD2_COMMIT_BLOCK);
 	tmp->h_sequence = cpu_to_be32(commit_transaction->t_tid);
+	tmp->h_commit_sec = cpu_to_be64(now.tv_sec);
+	tmp->h_commit_nsec = cpu_to_be32(now.tv_nsec);
 
 	if (JBD2_HAS_COMPAT_FEATURE(journal,
 				    JBD2_FEATURE_COMPAT_CHECKSUM)) {
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index d147f0f..ec9cadf 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -168,6 +168,8 @@ struct commit_header {
 	unsigned char   h_chksum_size;
 	unsigned char 	h_padding[2];
 	__be32 		h_chksum[JBD2_CHECKSUM_BYTES];
+	__be64		h_commit_sec;
+	__be32		h_commit_nsec;
 };
 
 /*
-- 
1.5.6.rc3.1.g36b7.dirty

