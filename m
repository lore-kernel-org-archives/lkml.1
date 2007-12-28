Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbXL1Nxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbXL1Nxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXL1Nvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:43 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44488 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752922AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849893.10768@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228135121.729972858@mail.ustc.edu.cn>
References: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] writeback: introduce s_more_io_wait for inodes to be re-synced after a while
Content-Disposition: inline; filename=writeback-more_io_wait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce super_block.s_more_io_wait and writeback_control.more_io_wait.
They are for inodes that for some reason cannot be synced immediately.

These inodes will be moved to s_more_io_wait and retried after a while(waiting
up to 0.1s).  The normal lots-of-dirty-pages inodes will be moved to more_io
and be synced after other inodes in s_io have been serviced(no sleep).

The new data flow is now simple and fair:
- to fill s_io:
		s_more_io +
		s_dirty(expired) +
		s_more_io_wait
				---> s_io
- to drain s_io:
		s_io -+--> clean inodes in inode_in_use/inode_unused
		      |
		      +--> s_more_io
		      |
		      +--> s_more_io_wait

- s_dirty is now a strict FIFO queue
- inode.dirtied_when now really means the first dirty time
- once exipired, the dirty inode will stay in s_*io* queues until made clean
- the dirty inodes in s_*io* queues will be revisted in order: no starvation

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |   22 +++++++++++---
 fs/super.c                |    1 
 include/linux/fs.h        |    1 
 include/linux/writeback.h |    1 
 mm/page-writeback.c       |   56 ++++++++++++++++++++----------------
 5 files changed, 53 insertions(+), 28 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -170,10 +170,18 @@ static void redirty_tail(struct inode *i
 static void requeue_io(struct inode *inode)
 {
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
+/*
+ * The inode should be retried after _sleeping_ for a while.
+ */
+static void requeue_io_wait(struct inode *inode)
+{
+	list_move(&inode->i_list, &inode->i_sb->s_more_io_wait);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
 	 * Prevent speculative execution through spin_unlock(&inode_lock);
 	 */
@@ -204,17 +212,19 @@ static void move_expired_inodes(struct l
 static void queue_io(struct super_block *sb,
 				unsigned long *older_than_this)
 {
 	list_splice_init(&sb->s_more_io, sb->s_io.prev);
 	move_expired_inodes(&sb->s_dirty, &sb->s_io, older_than_this);
+	list_splice_init(&sb->s_more_io_wait, sb->s_io.prev);
 }
 
 int sb_has_dirty_inodes(struct super_block *sb)
 {
-	return !list_empty(&sb->s_dirty) ||
-	       !list_empty(&sb->s_io) ||
-	       !list_empty(&sb->s_more_io);
+	return !list_empty(&sb->s_dirty)   ||
+	       !list_empty(&sb->s_io)      ||
+	       !list_empty(&sb->s_more_io) ||
+	       !list_empty(&sb->s_more_io_wait);
 }
 EXPORT_SYMBOL(sb_has_dirty_inodes);
 
 /*
  * Write a single inode's dirty pages and inode data out to disk.
@@ -470,15 +480,19 @@ int generic_sync_sb_inodes(struct super_
 		}
 		spin_unlock(&inode_lock);
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0)
+		if (wbc->nr_to_write <= 0) {
+			wbc->more_io = 1;
 			break;
+		}
 	}
 	if (!list_empty(&sb->s_more_io))
 		wbc->more_io = 1;
+	if (!list_empty(&sb->s_more_io_wait))
+		wbc->more_io_wait = 1;
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
 EXPORT_SYMBOL(generic_sync_sb_inodes);
 
--- linux-2.6.24-rc6-mm1.orig/mm/page-writeback.c
+++ linux-2.6.24-rc6-mm1/mm/page-writeback.c
@@ -541,21 +541,48 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			break;
         }
 }
 
 /*
+ * Write back up to MAX_WRITEBACK_PAGES.
+ * Return true if there's no more work.
+ */
+static int writeback_some_pages(struct writeback_control *wbc, int nr)
+{
+	int all_done = 0;
+
+	wbc->more_io = 0;
+	wbc->more_io_wait = 0;
+	wbc->encountered_congestion = 0;
+	wbc->nr_to_write = nr;
+
+	writeback_inodes(wbc);
+
+	if (wbc->encountered_congestion)
+		congestion_wait(WRITE, HZ/10);
+
+	if (wbc->more_io)
+		;
+	else if (wbc->more_io_wait)
+		congestion_wait(WRITE, HZ/10);
+	else
+		all_done = 1;
+
+	return all_done;
+}
+
+/*
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
  */
 static void background_writeout(unsigned long _min_pages)
 {
 	long min_pages = _min_pages;
 	struct writeback_control wbc = {
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = NULL,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.range_cyclic	= 1,
 	};
 
 	for ( ; ; ) {
@@ -565,23 +592,13 @@ static void background_writeout(unsigned
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
 			break;
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		wbc.pages_skipped = 0;
-		writeback_inodes(&wbc);
+		if (writeback_some_pages(&wbc, MAX_WRITEBACK_PAGES))
+			break;
 		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
-			/* Wrote less than expected */
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;
-		}
 	}
 }
 
 /*
  * Start writeback of `nr_pages' pages.  If `nr_pages' is zero, write back
@@ -625,11 +642,10 @@ static void wb_kupdate(unsigned long arg
 	long nr_to_write;
 	struct writeback_control wbc = {
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = &oldest_jif,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.for_kupdate	= 1,
 		.range_cyclic	= 1,
 	};
 
@@ -640,20 +656,12 @@ static void wb_kupdate(unsigned long arg
 	next_jif = start_jif + dirty_writeback_interval;
 	nr_to_write = global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) +
 			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
 	while (nr_to_write > 0) {
-		wbc.more_io = 0;
-		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
-		writeback_inodes(&wbc);
-		if (wbc.nr_to_write > 0) {
-			if (wbc.encountered_congestion || wbc.more_io)
-				congestion_wait(WRITE, HZ/10);
-			else
-				break;	/* All the old data is written */
-		}
+		if (writeback_some_pages(&wbc, MAX_WRITEBACK_PAGES))
+			break;
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 	}
 	if (time_before(next_jif, jiffies + HZ))
 		next_jif = jiffies + HZ;
 	if (dirty_writeback_interval)
--- linux-2.6.24-rc6-mm1.orig/fs/super.c
+++ linux-2.6.24-rc6-mm1/fs/super.c
@@ -62,10 +62,11 @@ static struct super_block *alloc_super(s
 			goto out;
 		}
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
+		INIT_LIST_HEAD(&s->s_more_io_wait);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
 		init_rwsem(&s->s_umount);
--- linux-2.6.24-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.24-rc6-mm1/include/linux/fs.h
@@ -1009,10 +1009,11 @@ struct super_block {
 
 	struct list_head	s_inodes;	/* all inodes */
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
+	struct list_head	s_more_io_wait;	/* parked for sleep-then-retry */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 
 	struct block_device	*s_bdev;
 	struct mtd_info		*s_mtd;
--- linux-2.6.24-rc6-mm1.orig/include/linux/writeback.h
+++ linux-2.6.24-rc6-mm1/include/linux/writeback.h
@@ -61,10 +61,11 @@ struct writeback_control {
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_reclaim:1;		/* Invoked from the page allocator */
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned more_io_wait:1;	/* more io to be dispatched after a while */
 };
 
 /*
  * fs/fs-writeback.c
  */	

-- 
