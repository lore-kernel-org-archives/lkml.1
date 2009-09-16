Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZIPN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZIPN0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZIPNZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57934 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZIPNYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:49 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 16/16] writeback: fix possible bdi writeback refcounting problem
Date: Wed, 16 Sep 2009 15:24:54 +0200
Message-Id: <1253107494-20160-17-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

wb_clear_pending AFAIKS should not be called after the item has been
put on the list, except by the worker threads. It could lead to the
situation where the refcount is decremented below 0 and cause lots of
problems.

Presumably the !wb_has_dirty_io case is not a common one, so it can
be discovered when the thread wakes up to check?

Also add a comment in bdi_work_clear.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7eba732..8e1e5e1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -97,6 +97,11 @@ static void bdi_work_clear(struct bdi_work *work)
 {
 	clear_bit(WS_USED_B, &work->state);
 	smp_mb__after_clear_bit();
+	/*
+	 * work can have disappeared at this point. bit waitq functions
+	 * should be able to tolerate this, provided bdi_sched_wait does
+	 * not dereference it's pointer argument.
+	*/
 	wake_up_bit(&work->state, WS_USED_B);
 }
 
@@ -169,13 +174,7 @@ static void bdi_queue_work(struct backing_dev_info *bdi, struct bdi_work *work)
 	else {
 		struct bdi_writeback *wb = &bdi->wb;
 
-		/*
-		 * End work now if this wb has no dirty IO pending. Otherwise
-		 * wakeup the handling thread
-		 */
-		if (!wb_has_dirty_io(wb))
-			wb_clear_pending(wb, work);
-		else if (wb->task)
+		if (wb->task)
 			wake_up_process(wb->task);
 	}
 }
-- 
1.6.4.1.207.g68ea

