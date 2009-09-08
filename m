Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbZIHSoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbZIHSoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZIHSol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:44:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbZIHSok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:44:40 -0400
Date: Tue, 8 Sep 2009 14:44:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, tytso@mit.edu, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 2/8] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090908184442.GB5956@infradead.org>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-3-git-send-email-jens.axboe@oracle.com> <20090904025609.GC3658@infradead.org> <20090904065357.GP18599@kernel.dk> <20090904154305.GA10002@infradead.org> <20090906184358.GM18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906184358.GM18599@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 06, 2009 at 08:43:59PM +0200, Jens Axboe wrote:
> On Fri, Sep 04 2009, Christoph Hellwig wrote:
> > On Fri, Sep 04, 2009 at 08:53:57AM +0200, Jens Axboe wrote:
> > > > +	if (wbc->sync_mode == WB_SYNC_ALL)
> > > > +		bdi_wait_on_work_clear(&work);
> > > >  }
> > > 
> > > That doesn't work, you have to wait for on-stack work. So either we just
> > > punt and not do anything for WB_SYNC_NONE if the allocation fails, or we
> > > punt to stack and do the wait. Since it's a cleaning action and
> > > allocation fails, falling back to the stack and waiting seems like the
> > > most appropriate choice.
> > 
> > True, the wait needs to be unconditional.  Updated version below.
> 
> (did you forget that patch? it's not there).

Here we go, sorry:


Index: linux-2.6/fs/fs-writeback.c
===================================================================
--- linux-2.6.orig/fs/fs-writeback.c	2009-09-04 12:37:27.022522276 -0300
+++ linux-2.6/fs/fs-writeback.c	2009-09-04 12:37:50.618022253 -0300
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
@@ -207,35 +200,21 @@ static struct bdi_work *bdi_alloc_work(s
 
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
 
-	/*
-	 * If the sync mode is WB_SYNC_ALL, block waiting for the work to
-	 * complete. If not, we only need to wait for the work to be started,
-	 * if we allocated it on-stack. We use the same mechanism, if the
-	 * wait bit is set in the bdi_work struct, then threads will not
-	 * clear pending until after they are done.
-	 *
-	 * Note that work == &work_stack if must_wait is true, so we don't
-	 * need to do call_rcu() here ever, since the completion path will
-	 * have done that for us.
-	 */
-	if (must_wait || work == &work_stack) {
-		bdi_wait_on_work_clear(work);
-		if (work != &work_stack)
-			call_rcu(&work->rcu_head, bdi_work_free);
-	}
+	bdi_queue_work(wbc->bdi, &work);
+	bdi_wait_on_work_clear(&work);
 }
 
 /*
