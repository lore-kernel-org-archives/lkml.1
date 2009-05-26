Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbZEZVLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbZEZVLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZEZVLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:11:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59203 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbZEZVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:11:19 -0400
Date: Tue, 26 May 2009 23:11:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090526211119.GO11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <20090526152501.GA20968@localhost.localdomain> <20090526164117.GJ11363@kernel.dk> <20090526170845.GA3226@localhost.localdomain> <20090526204703.GM11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526204703.GM11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26 2009, Jens Axboe wrote:
> On Tue, May 26 2009, Damien Wyart wrote:
> > > > I have been playing with v7 since your sending and after a while
> > > > (short on laptop, longer on desktop, a few hours), writeback doesn't
> > > > seem to work anymore. Manual call to sync hangs (process in D state)
> > > > and Dirty value in meminfo gets growing. As previous versions had
> > > > been heavily tested, I guess there is some regression in v7.
> > 
> > > Not good, the prime suspect is the sync notification stuff. I'll take
> > > a look and get that fixed. You didn't happen to catch any sysrq-t back
> > > traces or anything like that? Would be interesting to see where
> > > bdi-default and the bdi-* threads are stuck.
> > 
> > No, as I was doing many things at the same time and not exclusively
> > debugging, I just rebooted hard and went back to an upatched kernel when
> > the problems occured. But I noticed only bdi-default was alive, the
> > other bdi-* threads had disappeared and the sync commands I had tried
> > were all in D state. Also I tried to reinstall a kernel .deb (these
> > systems are Debian) and this got stuck guring installation, when probing
> > grub config (do not know if there is some sync syscall inthere).
> > 
> > Can try to go further tomorrow but will not have a lot of time...
> 
> OK, I spotted the problem. If we fallback to the on-stack allocation in
> bdi_writeback_all(), then we do the wait for the work completion with
> the bdi_lock mutex held. This can deadlock with bdi_forker_task(), so if
> we require that to be invoked to make progress (happens if a thread
> needs to be restarted), then we have a deadlock on that mutex.
> 
> I'll cook up a fix for this, but probably not before the morning.

Untested fix. I think it should work, but I haven't run it here yet.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a185a16..1662ede 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -122,12 +122,11 @@ static void bdi_work_free(struct rcu_head *head)
 
 static void wb_work_complete(struct bdi_work *work)
 {
-	if (!bdi_work_on_stack(work)) {
-		bdi_work_clear(work);
+	const enum writeback_sync_modes sync_mode = work->sync_mode;
 
-		if (work->sync_mode == WB_SYNC_NONE)
-			call_rcu(&work->rcu_head, bdi_work_free);
-	} else
+	if (!bdi_work_on_stack(work))
+		bdi_work_clear(work);
+	if (sync_mode == WB_SYNC_NONE || bdi_work_on_stack(work))
 		call_rcu(&work->rcu_head, bdi_work_free);
 }
 
@@ -272,7 +271,7 @@ void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 	 */
 	if (work == &work_stack || must_wait) {
 		bdi_wait_on_work_clear(work);
-		if (must_wait)
+		if (must_wait && work != &work_stack)
 			call_rcu(&work->rcu_head, bdi_work_free);
 	}
 }
@@ -511,10 +510,9 @@ int bdi_writeback_task(struct bdi_writeback *wb)
  * we are simply called for WB_SYNC_NONE, then writeback will merely be
  * scheduled to run.
  */
-void bdi_writeback_all(struct super_block *sb, long nr_pages,
-		       enum writeback_sync_modes sync_mode)
+void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc)
 {
-	const bool must_wait = sync_mode == WB_SYNC_ALL;
+	const bool must_wait = wbc->sync_mode == WB_SYNC_ALL;
 	struct backing_dev_info *bdi, *tmp;
 	struct bdi_work *work;
 	LIST_HEAD(list);
@@ -522,31 +520,21 @@ void bdi_writeback_all(struct super_block *sb, long nr_pages,
 	mutex_lock(&bdi_lock);
 
 	list_for_each_entry_safe(bdi, tmp, &bdi_list, bdi_list) {
-		struct bdi_work *work, work_stack;
+		struct bdi_work *work;
 
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		work = bdi_alloc_work(sb, nr_pages, sync_mode);
+		work = bdi_alloc_work(sb, wbc->nr_to_write, wbc->sync_mode);
 		if (!work) {
-			work = &work_stack;
-			bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
-		} else if (must_wait)
+			generic_sync_bdi_inodes(sb, wbc);
+			continue;
+		}
+		if (must_wait)
 			list_add_tail(&work->wait_list, &list);
 
 		bdi_queue_work(bdi, work);
 		__bdi_start_work(bdi, work);
-
-		/*
-		 * Do the wait inline if this came from the stack. This
-		 * only happens if we ran out of memory, so should very
-		 * rarely trigger.
-		 */
-		if (work == &work_stack) {
-			bdi_wait_on_work_clear(work);
-			if (must_wait)
-				call_rcu(&work->rcu_head, bdi_work_free);
-		}
 	}
 
 	mutex_unlock(&bdi_lock);
@@ -1082,7 +1070,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
 	if (wbc->bdi)
 		bdi_start_writeback(wbc->bdi, sb, wbc->nr_to_write, wbc->sync_mode);
 	else
-		bdi_writeback_all(sb, wbc->nr_to_write, wbc->sync_mode);
+		bdi_writeback_all(sb, wbc);
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index dee38ec..679cfb8 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -107,8 +107,7 @@ void bdi_unregister(struct backing_dev_info *bdi);
 void bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages, enum writeback_sync_modes sync_mode);
 int bdi_writeback_task(struct bdi_writeback *wb);
-void bdi_writeback_all(struct super_block *sb, long nr_pages,
-			enum writeback_sync_modes sync_mode);
+void bdi_writeback_all(struct super_block *sb, struct writeback_control *wbc);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7dd7de7..dd403cf 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -669,10 +669,18 @@ void throttle_vm_writeout(gfp_t gfp_mask)
  */
 void wakeup_flusher_threads(long nr_pages)
 {
+	struct writeback_control wbc = {
+		.sync_mode	= WB_SYNC_NONE,
+		.older_than_this = NULL,
+		.range_cyclic	= 1,
+	};
+
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
+
+	wbc.nr_to_write = nr_pages;
+	bdi_writeback_all(NULL, &wbc);
 }
 
 static void laptop_timer_fn(unsigned long unused);

-- 
Jens Axboe

