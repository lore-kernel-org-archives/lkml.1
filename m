Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbZDFMtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbZDFMtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZDFMsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50492 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbZDFMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:14 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/8] jbd: use WRITE_SYNC_PLUG instead of WRITE_SYNC
Date: Mon,  6 Apr 2009 14:48:04 +0200
Message-Id: <1239022088-29002-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you are going to be submitting several sync writes, we want to
give the IO scheduler a chance to merge some of them. Instead of
using the implicitly unplugging WRITE_SYNC variant, use WRITE_SYNC_PLUG
and rely on sync_buffer() doing the unplug when someone does a
wait_on_buffer()/lock_buffer().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/jbd/commit.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index f8077b9..a8e8513 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -351,8 +351,13 @@ void journal_commit_transaction(journal_t *journal)
 	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_LOCKED;
 
+	/*
+	 * Use plugged writes here, since we want to submit several before
+	 * we unplug the device. We don't do explicit unplugging in here,
+	 * instead we rely on sync_buffer() doing the unplug for us.
+	 */
 	if (commit_transaction->t_synchronous_commit)
-		write_op = WRITE_SYNC;
+		write_op = WRITE_SYNC_PLUG;
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
-- 
1.6.2.1.423.g442d

