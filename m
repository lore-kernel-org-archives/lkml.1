Return-Path: <linux-kernel-owner+w=401wt.eu-S932677AbZIDC4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbZIDC4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 22:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbZIDC4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 22:56:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbZIDC4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 22:56:06 -0400
Date: Thu, 3 Sep 2009 22:56:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090904025609.GC3658@infradead.org>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251880967-1136-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean bdi_start_writeback up a bit:


Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2009-09-03 23:50:12.880832607 -0300
+++ linux-2.6/fs/fs-writeback.c	2009-09-03 23:54:42.372832985 -0300
@@ -70,13 +70,6 @@ static inline void bdi_work_init(struct 
 	work->state = WS_USED;
 }
 
-static inline void bdi_work_init_on_stack(struct bdi_work *work,
-					  struct writeback_control *wbc)
-{
-	bdi_work_init(work, wbc);
-	work->state |= WS_ONSTACK;
-}
-
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -207,35 +200,26 @@ static struct bdi_work *bdi_alloc_work(s
 
 void bdi_start_writeback(struct writeback_control *wbc)
 {
-	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
-	struct bdi_work work_stack, *work = NULL;
-
-	if (!must_wait)
-		work = bdi_alloc_work(wbc);
+	struct bdi_work work;
 
-	if (!work) {
-		work = &work_stack;
-		bdi_work_init_on_stack(work, wbc);
+	if (wbc->sync_mode != WB_SYNC_ALL) {
+		struct bdi_work *w = bdi_alloc_work(wbc);
+		if (w) {
+			bdi_queue_work(wbc->bdi, w);
+			return;
+		}
 	}
 
-	bdi_queue_work(wbc->bdi, work);
+	bdi_work_init(&work, wbc);
+	work.state |= WS_ONSTACK;
+	bdi_queue_work(wbc->bdi, &work);
 
 	/*
 	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
-	 * complete. If not, we only need to wait for the work to be started,
-	 * if we allocated it on-stack. We use the same mechanism, if the
-	 * wait bit is set in the bdi_work struct, then threads will not
-	 * clear pending until after they are done.
-	 *
-	 * Note that work == &work_stack if must_wait is true, so we don't
-	 * need to do call_rcu() here ever, since the completion path will
-	 * have done that for us.
+	 * complete.
 	 */
-	if (must_wait || work == &work_stack) {
-		bdi_wait_on_work_clear(work);
-		if (work != &work_stack)
-			call_rcu(&work->rcu_head, bdi_work_free);
-	}
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		bdi_wait_on_work_clear(&work);
 }
 
 /*
