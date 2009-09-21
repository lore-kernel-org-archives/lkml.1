Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZIUNCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZIUNCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZIUNCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:02:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:32738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbZIUNCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:02:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189859372"
Date: Mon, 21 Sep 2009 21:01:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fs: Fix busyloop in wb_writeback()
Message-ID: <20090921130145.GA6266@localhost>
References: <1253121768-20673-1-git-send-email-jack@suse.cz> <20090916184106.GT23126@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20090916184106.GT23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 17, 2009 at 02:41:06AM +0800, Jens Axboe wrote:
> On Wed, Sep 16 2009, Jan Kara wrote:
> > If all inodes are under writeback (e.g. in case when there's only one inode
> > with dirty pages), wb_writeback() with WB_SYNC_NONE work basically degrades
> > to busylooping until I_SYNC flags of the inode is cleared. Fix the problem by
> > waiting on I_SYNC flags of an inode on b_more_io list in case we failed to
> > write anything.
> 
> Interesting, so this will happen if the dirtier and flush thread end up
> "fighting" each other over the same inode. I'll throw this into the
> testing mix.
> 
> How did you notice?

Jens, I found another busy loop. Not sure about the solution, but here
is the quick fact.

Tested git head is 1ef7d9aa32a8ee054c4d4fdcd2ea537c04d61b2f, which
seems to be the last writeback patch in the linux-next tree. I cannot
run the plain head of linux-next because it just refuses boot up.

On top of which Jan Kara's I_SYNC waiting patch and the attached
debugging patch is applied.

Test commands are:

        # mount /mnt/test # ext4 fs
        # echo 1 > /proc/sys/fs/dirty_debug

        # cp /dev/zero /mnt/test/zero0

After that the box is locked up, the system is busy doing these:

[   54.740295] requeue_io() +457: inode=79232
[   54.740300] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
[   54.740303] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
[   54.740317] requeue_io() +457: inode=79232
[   54.740322] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
[   54.740325] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
[   54.740339] requeue_io() +457: inode=79232
[   54.740344] mm/page-writeback.c +539 balance_dirty_pages(): comm=cp pid=3327 n=0
[   54.740347] global dirty=60345 writeback=10145 nfs=0 flags=_M towrite=1536 skipped=0
......

Basically the traces show that balance_dirty_pages() is busy looping.
It cannot write anything because the inode always be requeued by this line:

        if (inode->i_state & I_SYNC) {
               if (!wait) {
                        requeue_io(inode);
                        return 0;
                }

This seem to happen when the partition is FULL.

Thanks,
Fengguang

--yrj/dFKFPuw6o+aM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="wb-debug.patch"

--- linux.orig/fs/fs-writeback.c	2009-09-21 20:09:22.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-09-21 21:00:56.000000000 +0800
@@ -68,6 +68,30 @@ enum {
 #define WS_USED (1 << WS_USED_B)
 #define WS_ONSTACK (1 << WS_ONSTACK_B)
 
+void print_writeback_control(struct writeback_control *wbc)
+{
+	printk(KERN_DEBUG
+			"global dirty=%lu writeback=%lu nfs=%lu "
+			"flags=%c%c towrite=%ld skipped=%ld\n",
+			global_page_state(NR_FILE_DIRTY),
+			global_page_state(NR_WRITEBACK),
+			global_page_state(NR_UNSTABLE_NFS),
+			wbc->encountered_congestion ? 'C':'_',
+			wbc->more_io ? 'M':'_',
+			wbc->nr_to_write,
+			wbc->pages_skipped);
+}
+
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func)
+{
+	printk(KERN_DEBUG "%s +%d %s(): comm=%s pid=%d n=%ld\n",
+			file, line, func,
+			current->comm, current->pid,
+			n);
+	print_writeback_control(wbc);
+}
+
 static inline bool bdi_work_on_stack(struct bdi_work *work)
 {
 	return test_bit(WS_ONSTACK_B, &work->state);
@@ -81,6 +105,9 @@ static inline void bdi_work_init(struct 
 	work->state = WS_USED;
 }
 
+int sysctl_dirty_debug __read_mostly;
+
+
 /**
  * writeback_in_progress - determine whether there is writeback in progress
  * @bdi: the device's backing_dev_info structure.
@@ -260,6 +287,21 @@ void bdi_start_writeback(struct backing_
 	bdi_alloc_queue_work(bdi, &args);
 }
 
+#define redirty_tail(inode)						\
+	do {								\
+		__redirty_tail(inode, __LINE__);			\
+	} while (0)
+
+#define requeue_io(inode)						\
+	do {								\
+		__requeue_io(inode, __LINE__);				\
+	} while (0)
+
+#define requeue_partial_io(wbc, inode)					\
+	do {								\
+		__requeue_partial_io(wbc, inode, __LINE__);		\
+	} while (0)
+
 /*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
@@ -269,7 +311,7 @@ void bdi_start_writeback(struct backing_
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct inode *inode)
+static void __redirty_tail(struct inode *inode, int line)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
@@ -281,16 +323,26 @@ static void redirty_tail(struct inode *i
 			inode->dirtied_when = jiffies;
 	}
 	list_move(&inode->i_list, &wb->b_dirty);
+
+	if (sysctl_dirty_debug) {
+		printk(KERN_DEBUG "redirty_tail() +%d: inode=%lu\n",
+				line, inode->i_ino);
+	}
 }
 
 /*
  * requeue inode for re-scanning after bdi->b_io list is exhausted.
  */
-static void requeue_io(struct inode *inode)
+static void __requeue_io(struct inode *inode, int line)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
 
 	list_move(&inode->i_list, &wb->b_more_io);
+
+	if (sysctl_dirty_debug) {
+		printk(KERN_DEBUG "requeue_io() +%d: inode=%lu\n",
+				line, inode->i_ino);
+	}
 }
 
 static void inode_sync_complete(struct inode *inode)
@@ -743,6 +795,7 @@ static long wb_writeback(struct bdi_writ
 		args->nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
 
+		writeback_debug_report(wrote, &wbc);
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
 		 */
--- linux.orig/include/linux/writeback.h	2009-09-21 20:09:21.000000000 +0800
+++ linux/include/linux/writeback.h	2009-09-21 20:09:37.000000000 +0800
@@ -156,5 +156,15 @@ void writeback_set_ratelimit(void);
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
 
+extern int sysctl_dirty_debug;
+
+#define writeback_debug_report(n, wbc) do {                             \
+	if(sysctl_dirty_debug)						\
+		__writeback_debug_report(n, wbc,			\
+				__FILE__, __LINE__, __FUNCTION__);	\
+} while (0)
+void __writeback_debug_report(long n, struct writeback_control *wbc,
+		const char *file, int line, const char *func);
+
 
 #endif		/* WRITEBACK_H */
--- linux.orig/kernel/sysctl.c	2009-09-21 20:07:08.000000000 +0800
+++ linux/kernel/sysctl.c	2009-09-21 20:09:24.000000000 +0800
@@ -1531,6 +1531,14 @@ static struct ctl_table fs_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "dirty_debug",
+		.data		= &sysctl_dirty_debug,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
--- linux.orig/mm/page-writeback.c	2009-09-21 20:09:29.000000000 +0800
+++ linux/mm/page-writeback.c	2009-09-21 20:54:15.000000000 +0800
@@ -536,6 +536,7 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
 
 		/*
@@ -561,7 +562,7 @@ static void balance_dirty_pages(struct a
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
 
-		schedule_timeout(1);
+		schedule_timeout(HZ/10);
 	}
 
 	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&

--yrj/dFKFPuw6o+aM--
