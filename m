Return-Path: <linux-kernel-owner+w=401wt.eu-S1761013AbZEOJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013AbZEOJj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 05:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZEOJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 05:39:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57795 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907AbZEOJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 05:39:47 -0400
Date: Fri, 15 May 2009 11:39:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] small bits for 2.6.30
Message-ID: <20090515093948.GY4140@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Three small patches for 2.6.30-rc5. One is a build error for !BLOCK, one
is a bug fix for bio indexing, and the last one is the recently
discussed revert of the pdflush extra knob exposure. Please pull:


  git://git.kernel.dk/linux-2.6-block.git for-linus

Alexander Beregalov (1):
      viocd: needs to depend on BLOCK

Jens Axboe (1):
      Revert "mm: add /proc controls for pdflush threads"

Kazuhisa Ichikawa (1):
      block: fix the bio_vec array index out-of-bounds test

 Documentation/sysctl/vm.txt            |   28 ----------------------------
 arch/powerpc/platforms/iseries/Kconfig |    1 +
 block/blk-core.c                       |    4 ++--
 include/linux/writeback.h              |    2 --
 kernel/sysctl.c                        |   23 -----------------------
 mm/pdflush.c                           |   31 ++++++++++++-------------------
 6 files changed, 15 insertions(+), 74 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index b716d33..c302ddf 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -39,8 +39,6 @@ Currently, these files are in /proc/sys/vm:
 - nr_hugepages
 - nr_overcommit_hugepages
 - nr_pdflush_threads
-- nr_pdflush_threads_min
-- nr_pdflush_threads_max
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
 - oom_dump_tasks
@@ -469,32 +467,6 @@ The default value is 0.
 
 ==============================================================
 
-nr_pdflush_threads_min
-
-This value controls the minimum number of pdflush threads.
-
-At boot time, the kernel will create and maintain 'nr_pdflush_threads_min'
-threads for the kernel's lifetime.
-
-The default value is 2.  The minimum value you can specify is 1, and
-the maximum value is the current setting of 'nr_pdflush_threads_max'.
-
-See 'nr_pdflush_threads_max' below for more information.
-
-==============================================================
-
-nr_pdflush_threads_max
-
-This value controls the maximum number of pdflush threads that can be
-created.  The pdflush algorithm will create a new pdflush thread (up to
-this maximum) if no pdflush threads have been available for >= 1 second.
-
-The default value is 8.  The minimum value you can specify is the
-current value of 'nr_pdflush_threads_min' and the
-maximum is 1000.
-
-==============================================================
-
 overcommit_memory:
 
 This value contains a flag that enables memory overcommitment.
diff --git a/arch/powerpc/platforms/iseries/Kconfig b/arch/powerpc/platforms/iseries/Kconfig
index 647e877..47a20cf 100644
--- a/arch/powerpc/platforms/iseries/Kconfig
+++ b/arch/powerpc/platforms/iseries/Kconfig
@@ -17,6 +17,7 @@ config VIODASD
 
 config VIOCD
 	tristate "iSeries Virtual I/O CD support"
+	depends on BLOCK
 	select VIOPATH
 	help
 	  If you are running Linux on an IBM iSeries system and you want to
diff --git a/block/blk-core.c b/block/blk-core.c
index 2998fe3..c89883b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1768,10 +1768,10 @@ static int __end_that_request_first(struct request *req, int error,
 		} else {
 			int idx = bio->bi_idx + next_idx;
 
-			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			if (unlikely(idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-				       __func__, bio->bi_idx, bio->bi_vcnt);
+				       __func__, idx, bio->bi_vcnt);
 				break;
 			}
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 9c1ed1f..9344547 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -168,8 +168,6 @@ void writeback_set_ratelimit(void);
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */
-extern int nr_pdflush_threads_max; /* Global so it can be exported to sysctl */
-extern int nr_pdflush_threads_min; /* Global so it can be exported to sysctl */
 
 
 #endif		/* WRITEBACK_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ea78fa1..b2970d5 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -101,7 +101,6 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
-static int one_thousand = 1000;
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -1034,28 +1033,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "nr_pdflush_threads_min",
-		.data		= &nr_pdflush_threads_min,
-		.maxlen		= sizeof nr_pdflush_threads_min,
-		.mode		= 0644 /* read-write */,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &one,
-		.extra2		= &nr_pdflush_threads_max,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "nr_pdflush_threads_max",
-		.data		= &nr_pdflush_threads_max,
-		.maxlen		= sizeof nr_pdflush_threads_max,
-		.mode		= 0644 /* read-write */,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &nr_pdflush_threads_min,
-		.extra2		= &one_thousand,
-	},
-	{
 		.ctl_name	= VM_SWAPPINESS,
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
diff --git a/mm/pdflush.c b/mm/pdflush.c
index f2caf96..235ac44 100644
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -58,14 +58,6 @@ static DEFINE_SPINLOCK(pdflush_lock);
 int nr_pdflush_threads = 0;
 
 /*
- * The max/min number of pdflush threads. R/W by sysctl at
- * /proc/sys/vm/nr_pdflush_threads_max/min
- */
-int nr_pdflush_threads_max __read_mostly = MAX_PDFLUSH_THREADS;
-int nr_pdflush_threads_min __read_mostly = MIN_PDFLUSH_THREADS;
-
-
-/*
  * The time at which the pdflush thread pool last went empty
  */
 static unsigned long last_empty_jifs;
@@ -76,7 +68,7 @@ static unsigned long last_empty_jifs;
  * Thread pool management algorithm:
  * 
  * - The minimum and maximum number of pdflush instances are bound
- *   by nr_pdflush_threads_min and nr_pdflush_threads_max.
+ *   by MIN_PDFLUSH_THREADS and MAX_PDFLUSH_THREADS.
  * 
  * - If there have been no idle pdflush instances for 1 second, create
  *   a new one.
@@ -142,13 +134,14 @@ static int __pdflush(struct pdflush_work *my_work)
 		 * To throttle creation, we reset last_empty_jifs.
 		 */
 		if (time_after(jiffies, last_empty_jifs + 1 * HZ)) {
-			if (list_empty(&pdflush_list) &&
-			    nr_pdflush_threads < nr_pdflush_threads_max) {
-				last_empty_jifs = jiffies;
-				nr_pdflush_threads++;
-				spin_unlock_irq(&pdflush_lock);
-				start_one_pdflush_thread();
-				spin_lock_irq(&pdflush_lock);
+			if (list_empty(&pdflush_list)) {
+				if (nr_pdflush_threads < MAX_PDFLUSH_THREADS) {
+					last_empty_jifs = jiffies;
+					nr_pdflush_threads++;
+					spin_unlock_irq(&pdflush_lock);
+					start_one_pdflush_thread();
+					spin_lock_irq(&pdflush_lock);
+				}
 			}
 		}
 
@@ -160,7 +153,7 @@ static int __pdflush(struct pdflush_work *my_work)
 		 */
 		if (list_empty(&pdflush_list))
 			continue;
-		if (nr_pdflush_threads <= nr_pdflush_threads_min)
+		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
 			continue;
 		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
 		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
@@ -266,9 +259,9 @@ static int __init pdflush_init(void)
 	 * Pre-set nr_pdflush_threads...  If we fail to create,
 	 * the count will be decremented.
 	 */
-	nr_pdflush_threads = nr_pdflush_threads_min;
+	nr_pdflush_threads = MIN_PDFLUSH_THREADS;
 
-	for (i = 0; i < nr_pdflush_threads_min; i++)
+	for (i = 0; i < MIN_PDFLUSH_THREADS; i++)
 		start_one_pdflush_thread();
 	return 0;
 }

-- 
Jens Axboe

