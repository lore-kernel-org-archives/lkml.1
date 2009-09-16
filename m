Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZIPNZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZIPNZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZIPNZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:25:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57965 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZIPNYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:50 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/16] writeback: Fix bdi use after free in wb_work_complete()
Date: Wed, 16 Sep 2009 15:24:53 +0200
Message-Id: <1253107494-20160-16-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

By the time bdi_work_on_stack gets evaluated again in bdi_work_free, it
can already have been deallocated and used for something else in the
!on stack case, giving a false positive in this test and causing
corruption.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6bca6f8..7eba732 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -113,6 +113,7 @@ static void bdi_work_free(struct rcu_head *head)
 static void wb_work_complete(struct bdi_work *work)
 {
 	const enum writeback_sync_modes sync_mode = work->args.sync_mode;
+	int onstack = bdi_work_on_stack(work);
 
 	/*
 	 * For allocated work, we can clear the done/seen bit right here.
@@ -120,9 +121,9 @@ static void wb_work_complete(struct bdi_work *work)
 	 * to after the RCU grace period, since the stack could be invalidated
 	 * as soon as bdi_work_clear() has done the wakeup.
 	 */
-	if (!bdi_work_on_stack(work))
+	if (!onstack)
 		bdi_work_clear(work);
-	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
+	if (sync_mode == WB_SYNC_NONE || onstack)
 		call_rcu(&work->rcu_head, bdi_work_free);
 }
 
-- 
1.6.4.1.207.g68ea

