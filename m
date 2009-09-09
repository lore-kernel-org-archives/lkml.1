Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZIIDxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZIIDxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZIIDxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:53:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:62029 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbZIIDxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:53:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185537839"
Date: Wed, 9 Sep 2009 11:52:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "hch@infradead.org" <hch@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909035248.GA21494@localhost>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins> <20090909015359.GC7146@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909015359.GC7146@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 09:53:59AM +0800, Dave Chinner wrote:
> On Tue, Sep 08, 2009 at 06:56:23PM +0200, Peter Zijlstra wrote:
> > On Tue, 2009-09-08 at 12:29 -0400, Chris Mason wrote:
> > > Either way, if pdflush or the bdi thread or whoever ends up switching to
> > > another file during a big streaming write, the end result is that we
> > > fragment.  We may fragment the file (ext4) or we may fragment the
> > > writeback (xfs), but the end result isn't good.
> > 
> > OK, so what we want is for a way to re-enter the whole
> > writeback_inodes() path onto the same file, right?
> 
> No, that would take use back to the Bad Old Days where one large
> file write can starve out the other 10,000 small files that need to
> be written. The old writeback code used to end up in this way
> because it didn't rotate large files to the back of the dirty inode
> queue once wbc->nr_to_write was exhausted. This could cause files
> not to be written back for tens of minutes....

Problem is, there is no per-file writeback quota.

Here is a quick demo of idea to continue writeback of the last file if
its quota has not been exceeded. It also fixes the premature abortion
on congestions problem. The end result is, writeback of big files
won't reduce to small chunks because of intermixing small files or
congestion condition.

Thanks,
Fengguang
---

writeback: ensure big files are written in MAX_WRITEBACK_PAGES chunks

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c         |   39 ++++++++++++++++++++++++++++++++++--
 include/linux/writeback.h |   11 ++++++++++
 mm/page-writeback.c       |    9 --------
 3 files changed, 48 insertions(+), 11 deletions(-)

--- linux.orig/fs/fs-writeback.c	2009-09-09 10:02:30.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-09 11:42:19.000000000 +0800
@@ -218,6 +218,19 @@ static void requeue_io(struct inode *ino
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
 }
 
+/*
+ * continue io on this inode on next writeback if
+ * it has not accumulated large enough writeback io chunk
+ */
+static void requeue_partial_io(struct writeback_control *wbc, struct inode *inode)
+{
+	if (wbc->last_file_written == 0 ||
+	    wbc->last_file_written >= MAX_WRITEBACK_PAGES)
+		return requeue_io(inode);
+
+	list_move_tail(&inode->i_list, &inode->i_sb->s_io);
+}
+
 static void inode_sync_complete(struct inode *inode)
 {
 	/*
@@ -311,6 +324,8 @@ writeback_single_inode(struct inode *ino
 {
 	struct address_space *mapping = inode->i_mapping;
 	int wait = wbc->sync_mode == WB_SYNC_ALL;
+	long last_file_written;
+	long nr_to_write;
 	unsigned dirty;
 	int ret;
 
@@ -348,8 +363,21 @@ writeback_single_inode(struct inode *ino
 
 	spin_unlock(&inode_lock);
 
+	if (wbc->last_file != inode->i_ino)
+		last_file_written = 0;
+	else
+		last_file_written = wbc->last_file_written;
+	wbc->nr_to_write -= last_file_written;
+	nr_to_write = wbc->nr_to_write;
+
 	ret = do_writepages(mapping, wbc);
 
+	if (wbc->last_file != inode->i_ino) {
+		wbc->last_file = inode->i_ino;
+		wbc->last_file_written = nr_to_write - wbc->nr_to_write;
+	} else
+		wbc->last_file_written += nr_to_write - wbc->nr_to_write;
+
 	/* Don't write the inode if only I_DIRTY_PAGES was set */
 	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
 		int err = write_inode(inode, wait);
@@ -378,11 +406,16 @@ writeback_single_inode(struct inode *ino
 			 * sometimes bales out without doing anything.
 			 */
 			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
+			if (wbc->encountered_congestion) {
+				/*
+				 * keep and retry after congestion
+				 */
+				requeue_partial_io(wbc, inode);
+			} else if (wbc->nr_to_write <= 0) {
 				/*
 				 * slice used up: queue for next turn
 				 */
-				requeue_io(inode);
+				requeue_partial_io(wbc, inode);
 			} else {
 				/*
 				 * somehow blocked: retry later
@@ -402,6 +435,8 @@ writeback_single_inode(struct inode *ino
 		}
 	}
 	inode_sync_complete(inode);
+	wbc->nr_to_write += last_file_written;
+
 	return ret;
 }
 
--- linux.orig/include/linux/writeback.h	2009-09-09 11:13:43.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-09 11:41:40.000000000 +0800
@@ -25,6 +25,15 @@ static inline int task_is_pdflush(struct
 #define current_is_pdflush()	task_is_pdflush(current)
 
 /*
+ * The maximum number of pages to writeout in a single bdflush/kupdate
+ * operation.  We do this so we don't hold I_SYNC against an inode for
+ * enormous amounts of time, which would block a userspace task which has
+ * been forced to throttle against that inode.  Also, the code reevaluates
+ * the dirty each time it has written this many pages.
+ */
+#define MAX_WRITEBACK_PAGES	1024
+
+/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
@@ -45,6 +54,8 @@ struct writeback_control {
 					   older than this */
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
+	unsigned long last_file;	/* Inode number of last written file */
+	long last_file_written;		/* Total pages written for last file */
 	long pages_skipped;		/* Pages which were not written */
 
 	/*
--- linux.orig/mm/page-writeback.c	2009-09-09 10:05:02.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-09 11:41:01.000000000 +0800
@@ -36,15 +36,6 @@
 #include <linux/pagevec.h>
 
 /*
- * The maximum number of pages to writeout in a single bdflush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES	1024
-
-/*
  * After a CPU has dirtied this many pages, balance_dirty_pages_ratelimited
  * will look to see if it needs to force writeback or throttling.
  */
