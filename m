Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZIVKt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZIVKt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZIVKt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:49:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:57933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZIVKt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,431,1249282800"; 
   d="scan'208";a="190257404"
Date: Tue, 22 Sep 2009 18:49:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, richard@rsk.demon.co.uk,
       a.p.zijlstra@chello.nl, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090922104915.GA1649@localhost>
References: <20090922054913.GA27260@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20090922054913.GA27260@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Shaohua,

On Tue, Sep 22, 2009 at 01:49:13PM +0800, Li, Shaohua wrote:
> Hi,
> Commit d7831a0bdf06b9f722b947bb0c205ff7d77cebd8 causes disk io regression
> in my test.
> My system has 12 disks, each disk has two partitions. System runs fio sequence
> write on all partitions, each partion has 8 jobs.
> 2.6.31-rc1, fio gives 460m/s disk io
> 2.6.31-rc2, fio gives about 400m/s disk io. Revert the patch, speed back to
> 460m/s
> 
> Under latest git: fio gives 450m/s disk io; If reverting the patch, the speed
> is 484m/s.
> 
> With the patch, fio reports less io merge and more interrupts. My naive
> analysis is the patch makes balance_dirty_pages_ratelimited_nr() limits
> write chunk to 8 pages and then soon go to sleep in balance_dirty_pages(),
> because most time the bdi_nr_reclaimable < bdi_thresh, and so when write
> the pages out, the chunk is 8 pages long instead of 4M long. Without the patch,
> thread can write 8 pages and then move some pages to writeback, and then
> continue doing write. The patch seems to break this.

Do you have trace/numbers for above descriptions?

> Unfortunatelly I can't figure out a fix for this issue, hopefully
> you have more ideas.

Attached is a very verbose writeback debug patch, hope it helps and
won't disturb the workload a lot :)

Thanks,
Fengguang


--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-debug-2.6.31.patch"

--- linux-2.6.orig/fs/fs-writeback.c	2009-08-23 14:44:22.000000000 +0800
+++ linux-2.6/fs/fs-writeback.c	2009-09-22 18:45:06.000000000 +0800
@@ -26,6 +26,9 @@
 #include "internal.h"
 
 
+int sysctl_dirty_debug __read_mostly;
+
+
 /**
  * writeback_acquire - attempt to get exclusive writeback access to a device
  * @bdi: the device's backing_dev_info structure
@@ -186,6 +189,11 @@ static int write_inode(struct inode *ino
 	return 0;
 }
 
+#define redirty_tail(inode)						\
+	do {								\
+		__redirty_tail(inode, __LINE__);			\
+	} while (0)
+
 /*
  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
  * furthest end of its superblock's dirty-inode list.
@@ -195,10 +203,15 @@ static int write_inode(struct inode *ino
  * the case then the inode must have been redirtied while it was being written
  * out and we don't reset its dirtied_when.
  */
-static void redirty_tail(struct inode *inode)
+static void __redirty_tail(struct inode *inode, int line)
 {
 	struct super_block *sb = inode->i_sb;
 
+	if (sysctl_dirty_debug) {
+		printk(KERN_DEBUG "redirty_tail +%d: inode %lu\n",
+				line, inode->i_ino);
+	}
+
 	if (!list_empty(&sb->s_dirty)) {
 		struct inode *tail_inode;
 
@@ -210,12 +223,22 @@ static void redirty_tail(struct inode *i
 	list_move(&inode->i_list, &sb->s_dirty);
 }
 
+#define requeue_io(inode)						\
+	do {								\
+		__requeue_io(inode, __LINE__);				\
+	} while (0)
+
 /*
  * requeue inode for re-scanning after sb->s_io list is exhausted.
  */
-static void requeue_io(struct inode *inode)
+static void __requeue_io(struct inode *inode, int line)
 {
 	list_move(&inode->i_list, &inode->i_sb->s_more_io);
+
+	if (sysctl_dirty_debug) {
+		printk(KERN_DEBUG "requeue_io +%d: inode %lu\n",
+				line, inode->i_ino);
+	}
 }
 
 static void inode_sync_complete(struct inode *inode)
--- linux-2.6.orig/include/linux/writeback.h	2009-08-23 14:44:23.000000000 +0800
+++ linux-2.6/include/linux/writeback.h	2009-09-22 18:29:05.000000000 +0800
@@ -168,5 +168,6 @@ void writeback_set_ratelimit(void);
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
 
+extern int sysctl_dirty_debug;
 
 #endif		/* WRITEBACK_H */
--- linux-2.6.orig/kernel/sysctl.c	2009-08-23 14:44:23.000000000 +0800
+++ linux-2.6/kernel/sysctl.c	2009-09-22 18:29:05.000000000 +0800
@@ -1516,6 +1516,14 @@ static struct ctl_table fs_table[] = {
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
--- linux-2.6.orig/mm/page-writeback.c	2009-08-23 14:44:23.000000000 +0800
+++ linux-2.6/mm/page-writeback.c	2009-09-22 18:45:50.000000000 +0800
@@ -116,6 +116,35 @@ EXPORT_SYMBOL(laptop_mode);
 
 /* End of sysctl-exported parameters */
 
+#define writeback_debug_report(n, wbc) do {                             \
+	if(sysctl_dirty_debug)						\
+		__writeback_debug_report(n, wbc,			\
+				__FILE__, __LINE__, __FUNCTION__);	\
+} while (0)
+
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
+	printk(KERN_DEBUG "%s %d %s: comm=%s pid=%d n=%ld\n",
+			file, line, func,
+			current->comm, current->pid,
+			n);
+	print_writeback_control(wbc);
+}
 
 static void background_writeout(unsigned long _min_pages);
 
@@ -550,7 +579,12 @@ static void balance_dirty_pages(struct a
 			pages_written += write_chunk - wbc.nr_to_write;
 			get_dirty_limits(&background_thresh, &dirty_thresh,
 				       &bdi_thresh, bdi);
+			writeback_debug_report(pages_written, &wbc);
 		}
+		printk("bdi_nr_reclaimable=%lu, bdi_thresh=%lu, "
+		       "background_thresh=%lu, dirty_thresh=%lu\n",
+		       bdi_nr_reclaimable, bdi_thresh,
+		       background_thresh, dirty_thresh);
 
 		/*
 		 * In order to avoid the stacked BDI deadlock we need
@@ -670,6 +704,11 @@ void throttle_vm_writeout(gfp_t gfp_mask
 			global_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
+		printk(KERN_DEBUG "throttle_vm_writeout: "
+				"congestion_wait on %lu+%lu > %lu\n",
+				global_page_state(NR_UNSTABLE_NFS),
+				global_page_state(NR_WRITEBACK),
+				dirty_thresh);
 
 		/*
 		 * The caller might hold locks which can prevent IO completion
@@ -719,7 +758,9 @@ static void background_writeout(unsigned
 			else
 				break;
 		}
+		writeback_debug_report(min_pages, &wbc);
 	}
+	writeback_debug_report(min_pages, &wbc);
 }
 
 /*
@@ -792,7 +833,9 @@ static void wb_kupdate(unsigned long arg
 				break;	/* All the old data is written */
 		}
 		nr_to_write -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		writeback_debug_report(nr_to_write, &wbc);
 	}
+	writeback_debug_report(nr_to_write, &wbc);
 	if (time_before(next_jif, jiffies + HZ))
 		next_jif = jiffies + HZ;
 	if (dirty_writeback_interval)

--17pEHd4RhPHOinZp--
