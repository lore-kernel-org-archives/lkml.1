Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZDFMs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZDFMs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZDFMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:48:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50487 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbZDFMsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:48:14 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, torvalds@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 3/8] block: fsync_buffers_list() should use SWRITE_SYNC_PLUG
Date: Mon,  6 Apr 2009 14:48:03 +0200
Message-Id: <1239022088-29002-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.1.423.g442d
In-Reply-To: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then it can submit all the buffers without unplugging for each one.
We will kick off the pending IO if we come across a new address space.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 5d55a89..43afaa5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -737,7 +737,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct list_head tmp;
-	struct address_space *mapping;
+	struct address_space *mapping, *prev_mapping = NULL;
 	int err = 0, err2;
 
 	INIT_LIST_HEAD(&tmp);
@@ -762,7 +762,18 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 				 * contents - it is a noop if I/O is still in
 				 * flight on potentially older contents.
 				 */
-				ll_rw_block(SWRITE_SYNC, 1, &bh);
+				ll_rw_block(SWRITE_SYNC_PLUG, 1, &bh);
+
+				/*
+				 * Kick off IO for the previous mapping. Note
+				 * that we will not run the very last mapping,
+				 * wait_on_buffer() will do that for us
+				 * through sync_buffer().
+				 */
+				if (prev_mapping && prev_mapping != mapping)
+					blk_run_address_space(prev_mapping);
+				prev_mapping = mapping;
+
 				brelse(bh);
 				spin_lock(lock);
 			}
@@ -2957,12 +2968,13 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 	for (i = 0; i < nr; i++) {
 		struct buffer_head *bh = bhs[i];
 
-		if (rw == SWRITE || rw == SWRITE_SYNC)
+		if (rw == SWRITE || rw == SWRITE_SYNC || rw == SWRITE_SYNC_PLUG)
 			lock_buffer(bh);
 		else if (!trylock_buffer(bh))
 			continue;
 
-		if (rw == WRITE || rw == SWRITE || rw == SWRITE_SYNC) {
+		if (rw == WRITE || rw == SWRITE || rw == SWRITE_SYNC ||
+		    rw == SWRITE_SYNC_PLUG) {
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-- 
1.6.2.1.423.g442d

