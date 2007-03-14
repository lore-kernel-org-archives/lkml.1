Return-Path: <linux-kernel-owner+w=401wt.eu-S1161260AbXCNNS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161260AbXCNNS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 09:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161262AbXCNNS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 09:18:28 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:9877 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161260AbXCNNS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 09:18:27 -0400
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl,
       Dave Chinner <dgc@sgi.com>
In-Reply-To: <45F7EDC6.5090303@hitachi.com>
References: <45F7EDC6.5090303@hitachi.com>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 14:18:22 +0100
Message-Id: <1173878302.25356.15.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been working on an alternative solution (see patch below). However
I haven't posted yet because I'm not quite satisfied and haven't done a
lot of testing.

The patch relies on the per backing dev dirty/writeback counts currently
in -mm to which David Chinner objected. I plan to rework those as percpu
counters.

I think my solution might behave better because it fully decouples the
device throttling.

---

Scale writeback cache per backing device, proportional to its writeout speed.

akpm sayeth:
> Which problem are we trying to solve here?  afaik our two uppermost
> problems are:
> 
> a) Heavy write to queue A causes light writer to queue B to blok for a long
> time in balance_dirty_pages().  Even if the devices have the same speed.  

This one; esp when not the same speed. The - my usb stick makes my
computer suck - problem. But even on similar speed, the separation of
device should avoid blocking dev B when dev A is being throttled.

The writeout speed is measure dynamically, so when it doesn't have
anything to write out for a while its writeback cache size goes to 0.

Conversely, when starting up it will in the beginning act almost
synchronous but will quickly build up a 'fair' share of the writeback
cache.

> b) heavy write to device A causes light write to device A to block for a
> long time in balance_dirty_pages(), occasionally.  Harder to fix.

This will indeed take more. I've thought about it though. But one
quickly ends up with per task state.


How it all works:

We pick a 2^n value based on the vm_dirty_ratio and total vm size to act as a
period - vm_cycle_shift. This period measures 'time' in writeout events.

Each writeout increases time and adds to a per bdi counter. This counter is 
halved when a period expires. So per bdi speed is:

  0.5 * (previous cycle speed) + this cycle's events.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/ll_rw_blk.c           |    3 +
 include/linux/backing-dev.h |    7 +++
 include/linux/writeback.h   |   10 ++++
 kernel/sysctl.c             |   10 +++-
 mm/page-writeback.c         |  102 ++++++++++++++++++++++++++++++++++++++------
 5 files changed, 119 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/backing-dev.h
===================================================================
--- linux-2.6.orig/include/linux/backing-dev.h
+++ linux-2.6/include/linux/backing-dev.h
@@ -34,6 +34,13 @@ struct backing_dev_info {
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
+
+	/*
+	 * data used for scaling the writeback cache
+	 */
+	spinlock_t lock;		/* protect the cycle count */
+	atomic_long_t nr_writeout;	/* writeout scale */
+	unsigned long cycles;		/* writeout cycles */
 };
 
 
Index: linux-2.6/include/linux/writeback.h
===================================================================
--- linux-2.6.orig/include/linux/writeback.h
+++ linux-2.6/include/linux/writeback.h
@@ -4,6 +4,8 @@
 #ifndef WRITEBACK_H
 #define WRITEBACK_H
 
+#include <linux/log2.h>
+
 struct backing_dev_info;
 
 extern spinlock_t inode_lock;
@@ -89,11 +91,19 @@ void throttle_vm_writeout(gfp_t gfp_mask
 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
 extern int vm_dirty_ratio;
+extern int vm_cycle_shift;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
 extern int block_dump;
 extern int laptop_mode;
 
+extern long vm_total_pages; /* reduce dependancy stuff */
+static inline void update_cycle_shift(void)
+{
+	unsigned long dirty_pages = (vm_dirty_ratio * vm_total_pages) / 100;
+	vm_cycle_shift = 2 + ilog2_up(int_sqrt(dirty_pages));
+}
+
 struct ctl_table;
 struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -612,6 +612,14 @@ static ctl_table kern_table[] = {
 static int zero;
 static int one_hundred = 100;
 
+static int proc_dointvec_vm_dirty_ratio(ctl_table *table, int write,
+		struct file *filp, void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret = proc_dointvec_minmax(table, write, filp, buffer, lenp, ppos);
+	update_cycle_shift();
+	return ret;
+}
 
 static ctl_table vm_table[] = {
 	{
@@ -663,7 +671,7 @@ static ctl_table vm_table[] = {
 		.data		= &vm_dirty_ratio,
 		.maxlen		= sizeof(vm_dirty_ratio),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= &proc_dointvec_vm_dirty_ratio,
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -73,6 +73,9 @@ int dirty_background_ratio = 10;
  * The generator of dirty data starts writeback at this percentage
  */
 int vm_dirty_ratio = 40;
+int vm_cycle_shift;
+
+static DEFINE_PER_CPU(unsigned long, vm_writeout) = {0};
 
 /*
  * The interval between `kupdate'-style writebacks, in jiffies
@@ -102,6 +105,55 @@ EXPORT_SYMBOL(laptop_mode);
 
 static void background_writeout(unsigned long _min_pages);
 
+static unsigned long bdi_total_writeout(void)
+{
+	int cpu;
+	unsigned long sum = 0;
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(vm_writeout, cpu);
+	return sum;
+}
+
+static void bdi_writeout_norm(struct backing_dev_info *bdi)
+{
+	int bits = vm_cycle_shift;
+	unsigned long cycle = 1UL << bits;
+	unsigned long mask = ~(cycle - 1);
+	unsigned long total = bdi_total_writeout() << 1;
+
+	if ((bdi->cycles & mask) == (total & mask))
+		return;
+
+	spin_lock(&bdi->lock);
+	while ((bdi->cycles & mask) != (total & mask)) {
+		atomic_long_sub(atomic_long_read(&bdi->nr_writeout) / 2,
+				&bdi->nr_writeout);
+		bdi->cycles += cycle;
+	}
+	spin_unlock(&bdi->lock);
+}
+
+static void bdi_writeout_inc(struct backing_dev_info *bdi)
+{
+	get_cpu_var(vm_writeout)++;
+	put_cpu();
+
+	if (!(atomic_long_inc_return(&bdi->nr_writeout) & 0x7))
+		bdi_writeout_norm(bdi);
+}
+
+static void
+get_writeout_scale(struct address_space *mapping, int *scale, int *div)
+{
+	int bits = vm_cycle_shift - 1;
+	unsigned long total = bdi_total_writeout();
+	unsigned long cycle = 1UL << bits;
+	unsigned long mask = cycle - 1;
+
+	*scale = atomic_long_read(&mapping->backing_dev_info->nr_writeout);
+	*div = cycle + (total & mask);
+}
+
 /*
  * Work out the current dirty-memory clamping and background writeout
  * thresholds.
@@ -120,7 +172,7 @@ static void background_writeout(unsigned
  * clamping level.
  */
 static void
-get_dirty_limits(long *pbackground, long *pdirty,
+get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 					struct address_space *mapping)
 {
 	int background_ratio;		/* Percentages */
@@ -163,6 +215,21 @@ get_dirty_limits(long *pbackground, long
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+
+	if (mapping) {
+		long long tmp = dirty;
+		int scale, div;
+
+		get_writeout_scale(mapping, &scale, &div);
+
+		if (scale > div)
+			scale = div;
+
+		tmp = (tmp * 122) >> 7; /* take ~95% of total dirty value */
+		tmp *= scale;
+		do_div(tmp, div);
+		*pbdi_dirty = (long)tmp;
+	}
 }
 
 /*
@@ -177,6 +244,7 @@ static void balance_dirty_pages(struct a
 	long nr_reclaimable;
 	long background_thresh;
 	long dirty_thresh;
+	long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
 
@@ -191,11 +259,15 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, mapping);
+		get_dirty_limits(&background_thresh, &dirty_thresh,
+				&bdi_thresh, mapping);
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
-			dirty_thresh)
+		if ((nr_reclaimable + global_page_state(NR_WRITEBACK) <=
+			dirty_thresh) &&
+		    (atomic_long_read(&bdi->nr_dirty) +
+		     atomic_long_read(&bdi->nr_writeback) <=
+		     	bdi_thresh))
 				break;
 
 		if (!dirty_exceeded)
@@ -209,14 +281,18 @@ static void balance_dirty_pages(struct a
 		 */
 		if (nr_reclaimable) {
 			writeback_inodes(&wbc);
-			get_dirty_limits(&background_thresh,
-					 	&dirty_thresh, mapping);
+
+			get_dirty_limits(&background_thresh, &dirty_thresh,
+				       &bdi_thresh, mapping);
 			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
-			if (nr_reclaimable +
-				global_page_state(NR_WRITEBACK)
-					<= dirty_thresh)
-						break;
+			if ((nr_reclaimable + global_page_state(NR_WRITEBACK) <=
+				dirty_thresh) &&
+			    (atomic_long_read(&bdi->nr_dirty) +
+			     atomic_long_read(&bdi->nr_writeback) <=
+				 bdi_thresh))
+				break;
+
 			pages_written += write_chunk - wbc.nr_to_write;
 			if (pages_written >= write_chunk)
 				break;		/* We've done our duty */
@@ -312,7 +388,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 
                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -347,7 +423,7 @@ static void background_writeout(unsigned
 		long background_thresh;
 		long dirty_thresh;
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
@@ -555,6 +631,7 @@ void __init page_writeback_init(void)
 	mod_timer(&wb_timer, jiffies + dirty_writeback_interval);
 	writeback_set_ratelimit();
 	register_cpu_notifier(&ratelimit_nb);
+	update_cycle_shift();
 }
 
 /**
@@ -935,6 +1012,7 @@ int test_clear_page_writeback(struct pag
 						PAGECACHE_TAG_WRITEBACK);
 			atomic_long_dec(&mapping->backing_dev_info->
 					nr_writeback);
+			bdi_writeout_inc(mapping->backing_dev_info);
 		}
 		write_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c
+++ linux-2.6/block/ll_rw_blk.c
@@ -215,6 +215,9 @@ void blk_queue_make_request(request_queu
 	bdi->capabilities = BDI_CAP_MAP_COPY;
 	atomic_long_set(&bdi->nr_dirty, 0);
 	atomic_long_set(&bdi->nr_writeback, 0);
+	spin_lock_init(&bdi->lock);
+	atomic_long_set(&bdi->nr_writeout, 0);
+	bdi->cycles = 0;
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);



