Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZIOT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZIOT0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZIOTZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:51722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915192243.099602430@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:07 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 4/5] fs: fix possible bdi writeback refcounting problem
References: <20090915191903.290006007@suse.de>
Content-Disposition: inline; filename=fs-bdiwb-refcount-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wb_clear_pending AFAIKS should not be called after the item has been
put on the list, except by the worker threads. It could lead to the
situation where the refcount is decremented below 0 and cause lots of
problems.

Presumably the !wb_has_dirty_io case is not a common one, so it can
be discovered when the thread wakes up to check?

Also add a comment in bdi_work_clear.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -98,6 +98,11 @@ static void bdi_work_clear(struct bdi_wo
 {
 	clear_bit(WS_USED_B, &work->state);
 	smp_mb__after_clear_bit();
+	/*
+	 * work can have disappeared at this point. bit waitq functions
+	 * should be able to tolerate this, provided bdi_sched_wait does
+	 * not dereference it's pointer argument.
+	 */
 	wake_up_bit(&work->state, WS_USED_B);
 }
 
@@ -172,10 +177,7 @@ static void bdi_queue_work(struct backin
 		 * thread always. As a safety precaution, it'll flush out
 		 * everything
 		 */
-		if (!wb_has_dirty_io(wb)) {
-			if (work)
-				wb_clear_pending(wb, work);
-		} else if (wb->task)
+		if (wb->task)
 			wake_up_process(wb->task);
 	}
 }


