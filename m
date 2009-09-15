Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbZIOTZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbZIOTZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbZIOTZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:25:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbZIOTZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:25:39 -0400
Message-Id: <20090915192242.897829798@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Wed, 16 Sep 2009 05:19:06 +1000
From: npiggin@suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch 3/5] fs: fix bdi writeback use after free 1
References: <20090915191903.290006007@suse.de>
Content-Disposition: inline; filename=fs-bdiwb-rcu-fix-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the time bdi_work_on_stack gets evaluated again in bdi_work_free, it
cna already have been deallocated and used for something else in the
!on stack case, giving a false positive in this test and causing corruption.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/fs-writeback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c
+++ linux-2.6/fs/fs-writeback.c
@@ -114,6 +114,7 @@ static void bdi_work_free(struct rcu_hea
 static void wb_work_complete(struct bdi_work *work)
 {
 	const enum writeback_sync_modes sync_mode = work->sync_mode;
+	int onstack = bdi_work_on_stack(work);
 
 	/*
 	 * For allocated work, we can clear the done/seen bit right here.
@@ -121,9 +122,9 @@ static void wb_work_complete(struct bdi_
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
 


