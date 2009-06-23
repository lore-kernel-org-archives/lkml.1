Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZFWMUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZFWMUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZFWMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:20:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37197 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZFWMUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:20:07 -0400
Date: Tue, 23 Jun 2009 14:20:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: merging the per-bdi writeback patchset
Message-ID: <20090623122009.GC31415@kernel.dk>
References: <20090623081156.GT31415@kernel.dk> <20090623110933.GA16565@infradead.org> <20090623111209.GZ31415@kernel.dk> <20090623111752.GA23813@infradead.org> <20090623115224.GB31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623115224.GB31415@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23 2009, Jens Axboe wrote:
> On Tue, Jun 23 2009, Christoph Hellwig wrote:
> > On Tue, Jun 23, 2009 at 01:12:10PM +0200, Jens Axboe wrote:
> > > > Last time we discussed this you said you're happy with 2.6.32.  I really
> > > > want to take a more detailed look and put that on the not so urgent list
> > > > because ou didn't seem to rush for .31.  So my vote goes for waiting a
> > > > bit longer.
> > > 
> > > Yeah, 2.6.32 works for me too, .31 would have been nice though so I
> > > don't have to carry it around anymore. But either is fine, if you and
> > > Andrew want more time to review this stuff, then lets just settle for
> > > .32.
> > 
> > Yes, I'd really prefer more time.  I also expect to come up with some
> > more changes in that area.  Your patch makes the differences between
> > kupdate and pdflush-stye writeback look even more ugly then it already
> > is, so I want to see i there's some nicer way to handle it.  I also want
> 
> Good point, should be easy enough to fold the two together.

Something like the below, untested except for checking that it compiles.
So this doesn't dual-path the two reasons we wake up to flush data
anymore, rather it just flushes kupdated style if we didn't have any
work to do (or did any work).

 fs-writeback.c |  111 +++++++++++++++----------------------------------
 1 file changed, 36 insertions(+), 75 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d589db3..c5996e5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -269,8 +269,18 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  */
 #define MAX_WRITEBACK_PAGES     1024
 
+static inline bool over_bground_thresh(void)
+{
+	unsigned long background_thresh, dirty_thresh;
+
+	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+
+	return (global_page_state(NR_FILE_DIRTY) +
+		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
+}
+
 /*
- * Periodic writeback of "old" data.
+ * Retrieve work items queued, or perform periodic writeback of "old" data.
  *
  * Define "old": the first time one of an inode's pages is dirtied, we mark the
  * dirtying-time in the inode's address_space.  So this periodic writeback code
@@ -284,61 +294,26 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static long wb_kupdated(struct bdi_writeback *wb)
-{
-	unsigned long oldest_jif;
-	long nr_to_write, wrote = 0;
-	struct writeback_control wbc = {
-		.bdi			= wb->bdi,
-		.sync_mode		= WB_SYNC_NONE,
-		.older_than_this	= &oldest_jif,
-		.nr_to_write		= 0,
-		.for_kupdate		= 1,
-		.range_cyclic		= 1,
-	};
-
-	oldest_jif = jiffies - msecs_to_jiffies(dirty_expire_interval * 10);
-
-	nr_to_write = global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) +
-			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
-
-	while (nr_to_write > 0) {
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		generic_sync_wb_inodes(wb, NULL, &wbc);
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		if (wbc.nr_to_write > 0)
-			break;	/* All the old data is written */
-		nr_to_write -= MAX_WRITEBACK_PAGES;
-	}
-
-	return wrote;
-}
-
-static inline bool over_bground_thresh(void)
-{
-	unsigned long background_thresh, dirty_thresh;
-
-	get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
-
-	return (global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) >= background_thresh);
-}
-
-static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
-			   struct super_block *sb,
-			   enum writeback_sync_modes sync_mode)
+static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
+			 struct super_block *sb,
+			 enum writeback_sync_modes sync_mode, int for_kupdate)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
 		.sync_mode		= sync_mode,
 		.older_than_this	= NULL,
+		.for_kupdate		= for_kupdate,
 		.range_cyclic		= 1,
 	};
+	unsigned long oldest_jif;
 	long wrote = 0;
 
+	if (wbc.for_kupdate) {
+		wbc.older_than_this = &oldest_jif;
+		oldest_jif = jiffies -
+				msecs_to_jiffies(dirty_expire_interval * 10);
+	}
+
 	for (;;) {
 		if (sync_mode == WB_SYNC_NONE && nr_pages <= 0 &&
 		    !over_bground_thresh())
@@ -355,7 +330,7 @@ static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
 		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			if (wbc.more_io)
+			if (wbc.more_io && !wbc.for_kupdate)
 				continue;
 			break;
 		}
@@ -390,17 +365,18 @@ static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 /*
  * Retrieve work items and do the writeback they describe
  */
-static long wb_writeback(struct bdi_writeback *wb, int force_wait)
+long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct bdi_work *work;
-	long wrote = 0;
+	long nr_pages, wrote = 0;
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct super_block *sb = bdi_work_sb(work);
-		long nr_pages = work->nr_pages;
 		enum writeback_sync_modes sync_mode;
 
+		nr_pages = work->nr_pages;
+
 		/*
 		 * Override sync mode, in case we must wait for completion
 		 */
@@ -416,7 +392,7 @@ static long wb_writeback(struct bdi_writeback *wb, int force_wait)
 		if (sync_mode == WB_SYNC_NONE)
 			wb_clear_pending(wb, work);
 
-		wrote += __wb_writeback(wb, nr_pages, sb, sync_mode);
+		wrote += wb_writeback(wb, nr_pages, sb, sync_mode, 0);
 
 		/*
 		 * This is a data integrity writeback, so only do the
@@ -426,31 +402,16 @@ static long wb_writeback(struct bdi_writeback *wb, int force_wait)
 			wb_clear_pending(wb, work);
 	}
 
-	return wrote;
-}
-
-/*
- * This will be inlined in bdi_writeback_task() once we get rid of any
- * dirty inodes on the default_backing_dev_info
- */
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
-{
-	long wrote;
-
 	/*
-	 * We get here in two cases:
-	 *
-	 *  schedule_timeout() returned because the dirty writeback
-	 *  interval has elapsed. If that happens, the work item list
-	 *  will be empty and we will proceed to do kupdated style writeout.
-	 *
-	 *  Someone called bdi_start_writeback(), which put one/more work
-	 *  items on the work_list. Process those.
+	 * Check for periodic writeback, kupdated() style
 	 */
-	if (list_empty(&wb->bdi->work_list))
-		wrote = wb_kupdated(wb);
-	else
-		wrote = wb_writeback(wb, force_wait);
+	if (!wrote) {
+		nr_pages = global_page_state(NR_FILE_DIRTY) +
+				global_page_state(NR_UNSTABLE_NFS) +
+				(inodes_stat.nr_inodes - inodes_stat.nr_unused);
+
+		wrote = wb_writeback(wb, nr_pages, NULL, WB_SYNC_NONE, 1);
+	}
 
 	return wrote;
 }

-- 
Jens Axboe

