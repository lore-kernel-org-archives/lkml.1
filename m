Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbZDHMHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbZDHMHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764621AbZDHMAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:00:40 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48914 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385AbZDHMAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:00:21 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/13] writeback get rid of pdflush completely
Date: Wed,  8 Apr 2009 14:00:07 +0200
Message-Id: <1239192016-19857-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.2.2.446.gfbdc0
In-Reply-To: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
References: <1239192016-19857-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is now unused, so kill it off.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |    5 +
 include/linux/writeback.h |   12 --
 mm/Makefile               |    2 +-
 mm/pdflush.c              |  276 ---------------------------------------------
 4 files changed, 6 insertions(+), 289 deletions(-)
 delete mode 100644 mm/pdflush.c

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index bc188cb..816cf8e 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -29,6 +29,11 @@
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
 
+/*
+ * We don't actually have pdflush, but this one is exported though /proc...
+ */
+int nr_pdflush_threads = 0;
+
 /**
  * writeback_acquire - attempt to get exclusive writeback access to a device
  * @bdi: the device's backing_dev_info structure
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 0bc5af3..f241794 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -14,17 +14,6 @@ extern struct list_head inode_in_use;
 extern struct list_head inode_unused;
 
 /*
- * Yes, writeback.h requires sched.h
- * No, sched.h is not included from here.
- */
-static inline int task_is_pdflush(struct task_struct *task)
-{
-	return task->flags & PF_FLUSHER;
-}
-
-#define current_is_pdflush()	task_is_pdflush(current)
-
-/*
  * fs/fs-writeback.c
  */
 enum writeback_sync_modes {
@@ -151,7 +140,6 @@ balance_dirty_pages_ratelimited(struct address_space *mapping)
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
 
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0);
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
 int write_cache_pages(struct address_space *mapping,
diff --git a/mm/Makefile b/mm/Makefile
index ec73c68..2adb811 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   maccess.o page_alloc.o page-writeback.o pdflush.o \
+			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
diff --git a/mm/pdflush.c b/mm/pdflush.c
deleted file mode 100644
index f2caf96..0000000
--- a/mm/pdflush.c
+++ /dev/null
@@ -1,276 +0,0 @@
-/*
- * mm/pdflush.c - worker threads for writing back filesystem data
- *
- * Copyright (C) 2002, Linus Torvalds.
- *
- * 09Apr2002	Andrew Morton
- *		Initial version
- * 29Feb2004	kaos@sgi.com
- *		Move worker thread creation to kthread to avoid chewing
- *		up stack space with nested calls to kernel_thread.
- */
-
-#include <linux/sched.h>
-#include <linux/list.h>
-#include <linux/signal.h>
-#include <linux/spinlock.h>
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/fs.h>		/* Needed by writeback.h	  */
-#include <linux/writeback.h>	/* Prototypes pdflush_operation() */
-#include <linux/kthread.h>
-#include <linux/cpuset.h>
-#include <linux/freezer.h>
-
-
-/*
- * Minimum and maximum number of pdflush instances
- */
-#define MIN_PDFLUSH_THREADS	2
-#define MAX_PDFLUSH_THREADS	8
-
-static void start_one_pdflush_thread(void);
-
-
-/*
- * The pdflush threads are worker threads for writing back dirty data.
- * Ideally, we'd like one thread per active disk spindle.  But the disk
- * topology is very hard to divine at this level.   Instead, we take
- * care in various places to prevent more than one pdflush thread from
- * performing writeback against a single filesystem.  pdflush threads
- * have the PF_FLUSHER flag set in current->flags to aid in this.
- */
-
-/*
- * All the pdflush threads.  Protected by pdflush_lock
- */
-static LIST_HEAD(pdflush_list);
-static DEFINE_SPINLOCK(pdflush_lock);
-
-/*
- * The count of currently-running pdflush threads.  Protected
- * by pdflush_lock.
- *
- * Readable by sysctl, but not writable.  Published to userspace at
- * /proc/sys/vm/nr_pdflush_threads.
- */
-int nr_pdflush_threads = 0;
-
-/*
- * The max/min number of pdflush threads. R/W by sysctl at
- * /proc/sys/vm/nr_pdflush_threads_max/min
- */
-int nr_pdflush_threads_max __read_mostly = MAX_PDFLUSH_THREADS;
-int nr_pdflush_threads_min __read_mostly = MIN_PDFLUSH_THREADS;
-
-
-/*
- * The time at which the pdflush thread pool last went empty
- */
-static unsigned long last_empty_jifs;
-
-/*
- * The pdflush thread.
- *
- * Thread pool management algorithm:
- * 
- * - The minimum and maximum number of pdflush instances are bound
- *   by nr_pdflush_threads_min and nr_pdflush_threads_max.
- * 
- * - If there have been no idle pdflush instances for 1 second, create
- *   a new one.
- * 
- * - If the least-recently-went-to-sleep pdflush thread has been asleep
- *   for more than one second, terminate a thread.
- */
-
-/*
- * A structure for passing work to a pdflush thread.  Also for passing
- * state information between pdflush threads.  Protected by pdflush_lock.
- */
-struct pdflush_work {
-	struct task_struct *who;	/* The thread */
-	void (*fn)(unsigned long);	/* A callback function */
-	unsigned long arg0;		/* An argument to the callback */
-	struct list_head list;		/* On pdflush_list, when idle */
-	unsigned long when_i_went_to_sleep;
-};
-
-static int __pdflush(struct pdflush_work *my_work)
-{
-	current->flags |= PF_FLUSHER | PF_SWAPWRITE;
-	set_freezable();
-	my_work->fn = NULL;
-	my_work->who = current;
-	INIT_LIST_HEAD(&my_work->list);
-
-	spin_lock_irq(&pdflush_lock);
-	for ( ; ; ) {
-		struct pdflush_work *pdf;
-
-		set_current_state(TASK_INTERRUPTIBLE);
-		list_move(&my_work->list, &pdflush_list);
-		my_work->when_i_went_to_sleep = jiffies;
-		spin_unlock_irq(&pdflush_lock);
-		schedule();
-		try_to_freeze();
-		spin_lock_irq(&pdflush_lock);
-		if (!list_empty(&my_work->list)) {
-			/*
-			 * Someone woke us up, but without removing our control
-			 * structure from the global list.  swsusp will do this
-			 * in try_to_freeze()->refrigerator().  Handle it.
-			 */
-			my_work->fn = NULL;
-			continue;
-		}
-		if (my_work->fn == NULL) {
-			printk("pdflush: bogus wakeup\n");
-			continue;
-		}
-		spin_unlock_irq(&pdflush_lock);
-
-		(*my_work->fn)(my_work->arg0);
-
-		spin_lock_irq(&pdflush_lock);
-
-		/*
-		 * Thread creation: For how long have there been zero
-		 * available threads?
-		 *
-		 * To throttle creation, we reset last_empty_jifs.
-		 */
-		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			if (list_empty(&pdflush_list) &&
-			    nr_pdflush_threads < nr_pdflush_threads_max) {
-				last_empty_jifs = jiffies;
-				nr_pdflush_threads++;
-				spin_unlock_irq(&pdflush_lock);
-				start_one_pdflush_thread();
-				spin_lock_irq(&pdflush_lock);
-			}
-		}
-
-		my_work->fn = NULL;
-
-		/*
-		 * Thread destruction: For how long has the sleepiest
-		 * thread slept?
-		 */
-		if (list_empty(&pdflush_list))
-			continue;
-		if (nr_pdflush_threads <= nr_pdflush_threads_min)
-			continue;
-		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
-		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
-			/* Limit exit rate */
-			pdf->when_i_went_to_sleep = jiffies;
-			break;					/* exeunt */
-		}
-	}
-	nr_pdflush_threads--;
-	spin_unlock_irq(&pdflush_lock);
-	return 0;
-}
-
-/*
- * Of course, my_work wants to be just a local in __pdflush().  It is
- * separated out in this manner to hopefully prevent the compiler from
- * performing unfortunate optimisations against the auto variables.  Because
- * these are visible to other tasks and CPUs.  (No problem has actually
- * been observed.  This is just paranoia).
- */
-static int pdflush(void *dummy)
-{
-	struct pdflush_work my_work;
-	cpumask_var_t cpus_allowed;
-
-	/*
-	 * Since the caller doesn't even check kthread_run() worked, let's not
-	 * freak out too much if this fails.
-	 */
-	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL)) {
-		printk(KERN_WARNING "pdflush failed to allocate cpumask\n");
-		return 0;
-	}
-
-	/*
-	 * pdflush can spend a lot of time doing encryption via dm-crypt.  We
-	 * don't want to do that at keventd's priority.
-	 */
-	set_user_nice(current, 0);
-
-	/*
-	 * Some configs put our parent kthread in a limited cpuset,
-	 * which kthread() overrides, forcing cpus_allowed == cpu_all_mask.
-	 * Our needs are more modest - cut back to our cpusets cpus_allowed.
-	 * This is needed as pdflush's are dynamically created and destroyed.
-	 * The boottime pdflush's are easily placed w/o these 2 lines.
-	 */
-	cpuset_cpus_allowed(current, cpus_allowed);
-	set_cpus_allowed_ptr(current, cpus_allowed);
-	free_cpumask_var(cpus_allowed);
-
-	return __pdflush(&my_work);
-}
-
-/*
- * Attempt to wake up a pdflush thread, and get it to do some work for you.
- * Returns zero if it indeed managed to find a worker thread, and passed your
- * payload to it.
- */
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	BUG_ON(fn == NULL);	/* Hard to diagnose if it's deferred */
-
-	spin_lock_irqsave(&pdflush_lock, flags);
-	if (list_empty(&pdflush_list)) {
-		ret = -1;
-	} else {
-		struct pdflush_work *pdf;
-
-		pdf = list_entry(pdflush_list.next, struct pdflush_work, list);
-		list_del_init(&pdf->list);
-		if (list_empty(&pdflush_list))
-			last_empty_jifs = jiffies;
-		pdf->fn = fn;
-		pdf->arg0 = arg0;
-		wake_up_process(pdf->who);
-	}
-	spin_unlock_irqrestore(&pdflush_lock, flags);
-
-	return ret;
-}
-
-static void start_one_pdflush_thread(void)
-{
-	struct task_struct *k;
-
-	k = kthread_run(pdflush, NULL, "pdflush");
-	if (unlikely(IS_ERR(k))) {
-		spin_lock_irq(&pdflush_lock);
-		nr_pdflush_threads--;
-		spin_unlock_irq(&pdflush_lock);
-	}
-}
-
-static int __init pdflush_init(void)
-{
-	int i;
-
-	/*
-	 * Pre-set nr_pdflush_threads...  If we fail to create,
-	 * the count will be decremented.
-	 */
-	nr_pdflush_threads = nr_pdflush_threads_min;
-
-	for (i = 0; i < nr_pdflush_threads_min; i++)
-		start_one_pdflush_thread();
-	return 0;
-}
-
-module_init(pdflush_init);
-- 
1.6.2.2.446.gfbdc0

