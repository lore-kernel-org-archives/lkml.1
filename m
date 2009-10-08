Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZJHG3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZJHG3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZJHG3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:29:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:27290 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZJHG3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:29:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,524,1249282800"; 
   d="scan'208";a="196420804"
Date: Thu, 8 Oct 2009 14:28:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Myklebust Trond <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/45] writeback: introduce wait queue for
	balance_dirty_pages()
Message-ID: <20091008062808.GA24939@localhost>
References: <20091007073818.318088777@intel.com> <20091007074903.422089703@intel.com> <20091008100159.fb6770cf.kamezawa.hiroyu@jp.fujitsu.com> <20091008015822.GB14224@localhost> <20091008114037.56f78b0e.kamezawa.hiroyu@jp.fujitsu.com> <20091008040136.GA30292@localhost> <20091008145907.7f1799ca.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008145907.7f1799ca.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 01:59:07PM +0800, KAMEZAWA Hiroyuki wrote:
> On Thu, 8 Oct 2009 12:01:36 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Thu, Oct 08, 2009 at 10:40:37AM +0800, KAMEZAWA Hiroyuki wrote:
> > > Thank you for clarification.
> > > Then, hmm, %iotwait (which 'top' shows) didn't work as desgined and we need
> > > to update throttle_vm_writeout() and some in vmscan.c. Thanks for input.
> > 
> > Thanks, you also reminds me to do io_schedule() in the nfs writeback
> > wait queue :)
> > 
> good side effect ;)
> 
> > > BTW, I'm glad if I can know "how many threads/ios are throttoled now" per bdi.
> > 
> > Good suggestion. How about this patch?
> > 
> 
> Seems attractive. 
> Hmm..
> ==
> struct dirty_throttle_task {
> +	pid_t	owner_pid;
> ==
> and show it ? (too verbose ?

Not all all, added comm too :)

---
writeback: show per-bdi throttled tasks

All currently throttled tasks will be listed, showing the pages to
writeback for them, and total wait time since blocked.

	# cat /debug/bdi/0:16/throttle_list
	goal=768kb      waited=36ms     pid=3551        comm=cp


CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c           |    6 +++--
 include/linux/backing-dev.h |    3 ++
 mm/backing-dev.c            |   35 ++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)

--- linux.orig/include/linux/backing-dev.h	2009-10-08 12:37:13.000000000 +0800
+++ linux/include/linux/backing-dev.h	2009-10-08 14:10:44.000000000 +0800
@@ -101,6 +101,7 @@ struct backing_dev_info {
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_dir;
 	struct dentry *debug_stats;
+	struct dentry *debug_throttle;
 #endif
 };
 
@@ -116,6 +117,8 @@ struct backing_dev_info {
 #define DIRTY_THROTTLE_PAGES_STOP	(1 << 22)
 
 struct dirty_throttle_task {
+	struct task_struct	*sleeper;
+	unsigned long		start_time;
 	long			nr_pages;
 	struct list_head	list;
 	struct completion	complete;
--- linux.orig/mm/backing-dev.c	2009-10-08 12:37:42.000000000 +0800
+++ linux/mm/backing-dev.c	2009-10-08 14:12:35.000000000 +0800
@@ -115,6 +115,25 @@ static int bdi_debug_stats_show(struct s
 	return 0;
 }
 
+static int bdi_debug_throttle_show(struct seq_file *m, void *v)
+{
+	struct backing_dev_info *bdi = m->private;
+	struct dirty_throttle_task *tt;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdi->throttle_lock, flags);
+	list_for_each_entry(tt, &bdi->throttle_list, list) {
+		seq_printf(m, "goal=%lukb\twaited=%lums\tpid=%d\tcomm=%s\n",
+			   tt->nr_pages << (PAGE_SHIFT - 10),
+			   (jiffies - tt->start_time) * 1000 / HZ,
+			   tt->sleeper->pid,
+			   tt->sleeper->comm);
+	}
+	spin_unlock_irqrestore(&bdi->throttle_lock, flags);
+
+	return 0;
+}
+
 static int bdi_debug_stats_open(struct inode *inode, struct file *file)
 {
 	return single_open(file, bdi_debug_stats_show, inode->i_private);
@@ -127,15 +146,31 @@ static const struct file_operations bdi_
 	.release	= single_release,
 };
 
+static int bdi_debug_throttle_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, bdi_debug_throttle_show, inode->i_private);
+}
+
+static const struct file_operations bdi_debug_throttle_fops = {
+	.open		= bdi_debug_throttle_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static void bdi_debug_register(struct backing_dev_info *bdi, const char *name)
 {
 	bdi->debug_dir = debugfs_create_dir(name, bdi_debug_root);
 	bdi->debug_stats = debugfs_create_file("stats", 0444, bdi->debug_dir,
 					       bdi, &bdi_debug_stats_fops);
+	bdi->debug_throttle = debugfs_create_file("throttle_list", 0444,
+						  bdi->debug_dir, bdi,
+						  &bdi_debug_throttle_fops);
 }
 
 static void bdi_debug_unregister(struct backing_dev_info *bdi)
 {
+	debugfs_remove(bdi->debug_throttle);
 	debugfs_remove(bdi->debug_stats);
 	debugfs_remove(bdi->debug_dir);
 }
--- linux.orig/fs/fs-writeback.c	2009-10-08 12:37:24.000000000 +0800
+++ linux/fs/fs-writeback.c	2009-10-08 14:10:51.000000000 +0800
@@ -284,8 +284,10 @@ static void bdi_calc_write_bandwidth(str
 void bdi_writeback_wait(struct backing_dev_info *bdi, long nr_pages)
 {
 	struct dirty_throttle_task tt = {
-		.nr_pages = nr_pages,
-		.complete = COMPLETION_INITIALIZER_ONSTACK(tt.complete),
+		.sleeper	= current,
+		.start_time	= jiffies,
+		.nr_pages	= nr_pages,
+		.complete	= COMPLETION_INITIALIZER_ONSTACK(tt.complete),
 	};
 	unsigned long flags;
 
