Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXL2Che@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXL2Che (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbXL2ChT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:37:19 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54827 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756227AbXL2ChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:37:12 -0500
Message-ID: <398895838.07478@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 29 Dec 2007 10:37:06 +0800
From: WU Fengguang <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sascha Warner <prx@cinatas.ath.cx>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
References: <47742268.8040302@cinatas.ath.cx> <20071228150111.e9451632.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228150111.e9451632.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8RZS-0005kk-TI@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 03:01:11PM -0800, Andrew Morton wrote:
> On Thu, 27 Dec 2007 23:08:40 +0100 Sascha Warner <prx@cinatas.ath.cx> wrote:
> 
> > Hi,
> > 
> > I applied your patches to 2.6.24-rc6-mm1, but now I am faced with one
> > pdflush often using 100% CPU for a long time. There seem to be some rare
> > pauses from its 100% usage, however.
> > 
> > On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> > 
> > This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo ~x64_64
> > 
> > Let me know if you need more info.

Sascha, Thank you for the testing.

Replace the first patch with this one should help:

---
Subject: writeback: introduce s_more_io_wait for inodes to be re-synced after a while

Introduce super_block.s_more_io_wait and writeback_control.more_io_wait.
They are for inodes that for some reason cannot be synced immediately.

These inodes will be moved to s_more_io_wait and retried after a while(waiting
up to 0.1s).  The normal lots-of-dirty-pages inodes will be moved to more_io
and be synced after other inodes in s_io have been serviced(no sleep).

The data flow is made more simple:

s_dirty --> s_io --> s_more_io/s_more_io_wait --+
             ^                                  |
	     |                                  |
	     +----------------------------------+

- to fill s_io:
		s_more_io +
		s_dirty(expired) +
		s_more_io_wait
				---> s_io
- to drain s_io:
		s_io -+--> clean inodes goto inode_in_use/inode_unused
		      |
		      +--> s_more_io
		      |
		      +--> s_more_io_wait

Obviously there's no ordering or starvation problems in the queues:
- s_dirty is now a strict FIFO queue
- inode.dirtied_when now really means the first dirty time
- once exipired, the dirty inode will stay in s_*io* queues until made clean
- the dirty inodes in s_*io* queues will be revisted in order: no starvation

Cc: Michael Rubin <mrubin@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/fs-writeback.c         |   26 ++++++++++++----
 fs/super.c                |    1 
 include/linux/fs.h        |    1 
 include/linux/writeback.h |    1 
 mm/page-writeback.c       |   56 ++++++++++++++++++++----------------
 5 files changed, 55 insertions(+), 30 deletions(-)

--- linux-2.6.24-rc6-mm1.orig/fs/fs-writeback.c
+++ linux-2.6.24-rc6-mm1/fs/fs-writeback.c
@@ -172,6 +172,14 @@ static void requeue_io(struct inode *ino
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
@@ -206,13 +214,15 @@ static void queue_io(struct super_block 
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
 
@@ -472,11 +482,15 @@ int generic_sync_sb_inodes(struct super_
 		iput(inode);
 		cond_resched();
 		spin_lock(&inode_lock);
-		if (wbc->nr_to_write <= 0)
+		if (wbc->nr_to_write <= 0) {
+			wbc->more_io = 1;
 			break;
+		}
+		if (!list_empty(&sb->s_more_io))
+			wbc->more_io = 1;
+		if (!list_empty(&sb->s_more_io_wait))
+			wbc->more_io_wait = 1;
 	}
-	if (!list_empty(&sb->s_more_io))
-		wbc->more_io = 1;
 	spin_unlock(&inode_lock);
 	return ret;		/* Leave any unwritten inodes on s_io */
 }
--- linux-2.6.24-rc6-mm1.orig/mm/page-writeback.c
+++ linux-2.6.24-rc6-mm1/mm/page-writeback.c
@@ -543,6 +543,34 @@ void throttle_vm_writeout(gfp_t gfp_mask
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
@@ -553,7 +581,6 @@ static void background_writeout(unsigned
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = NULL,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.range_cyclic	= 1,
 	};
@@ -567,19 +594,9 @@ static void background_writeout(unsigned
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
 
@@ -627,7 +644,6 @@ static void wb_kupdate(unsigned long arg
 		.bdi		= NULL,
 		.sync_mode	= WB_SYNC_NONE,
 		.older_than_this = &oldest_jif,
-		.nr_to_write	= 0,
 		.nonblocking	= 1,
 		.for_kupdate	= 1,
 		.range_cyclic	= 1,
@@ -642,16 +658,8 @@ static void wb_kupdate(unsigned long arg
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
--- linux-2.6.24-rc6-mm1.orig/fs/super.c
+++ linux-2.6.24-rc6-mm1/fs/super.c
@@ -64,6 +64,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
+		INIT_LIST_HEAD(&s->s_more_io_wait);
 		INIT_LIST_HEAD(&s->s_files);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
--- linux-2.6.24-rc6-mm1.orig/include/linux/fs.h
+++ linux-2.6.24-rc6-mm1/include/linux/fs.h
@@ -1011,6 +1011,7 @@ struct super_block {
 	struct list_head	s_dirty;	/* dirty inodes */
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
+	struct list_head	s_more_io_wait;	/* parked for sleep-then-retry */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
 
--- linux-2.6.24-rc6-mm1.orig/include/linux/writeback.h
+++ linux-2.6.24-rc6-mm1/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned more_io_wait:1;	/* more io to be dispatched after a while */
 };
 
 /*

