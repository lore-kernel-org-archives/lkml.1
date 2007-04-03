Return-Path: <linux-kernel-owner+w=401wt.eu-S966157AbXDCKuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966157AbXDCKuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966156AbXDCKuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:50:25 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:33276 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966157AbXDCKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:50:24 -0400
Message-ID: <4612306C.2040600@hitachi.com>
Date: Tue, 03 Apr 2007 19:46:04 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com
Subject: [PATCH 1/2] VM throttling: Start writeback at dirty_writeback_start_ratio
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com> <46026B78.3080401@tmr.com> <4607A01D.1060401@hitachi.com> <4607FECD.1090101@tmr.com>
In-Reply-To: <4607FECD.1090101@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to avoid the problem that write(2) can be blocked for a
long time if a system has several disks with different speed and is
under heavy I/O pressure.

-Description of the problem:
While Dirty+Writeback pages get more than 40%(`dirty_ratio') of memory,
generators of dirty pages are blocked in balance_dirty_pages() until
they start writeback of a specific number (`write_chunk', typically=1536)
of dirty pages on the disks they write to.

Under this rule, if a process writes to the disk which has only a few
(less than 1536) dirty pages, that process will be blocked until
writeback of the other disks is completed and % of Dirty+Writeback goes
below 40%.

Thus, if a slow device (such as a USB disk) has many dirty pages, the
processes which write small data to the other disks can be blocked for
quite a long time.

-Solution:
This patch introduces high/low-watermark algorithm in
balance_dirty_pages() in order to throttle only the processes which
write to disks with heavy load.

This patch adds `dirty_start_writeback_ratio' for the low-watermark,
and modifies get_dirty_limits() to calculate and return the writeback
starting level of dirty pages based on `dirty_start_writeback_ratio'.

If % of Dirty+Writeback > `dirty_writeback_start_ratio', generators of
dirty pages start writeback of dirty pages by themselves. At that time,
these processes are not blocked in balance_dirty_pages(), but they may
be blocked if the write-requests-queue of the written disk is full
(that is, the length of the queue > `nr_requests'). By this behavior,
we can throttle only processes which write to the disks with heavy load,
and can allow processes to write to the other disks without blocking.

If % of Dirty+Writeback > `dirty_ratio', generators of dirty pages
are throttled as current Linux does, not to fill up memory with dirty
pages.

Thanks,

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
---
 include/linux/writeback.h |    1
 mm/page-writeback.c       |   52 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 11 deletions(-)

Index: linux-2.6.21-rc5-mm3-writeback/include/linux/writeback.h
===================================================================
--- linux-2.6.21-rc5-mm3-writeback.orig/include/linux/writeback.h
+++ linux-2.6.21-rc5-mm3-writeback/include/linux/writeback.h
@@ -94,6 +94,7 @@ static inline int laptop_spinned_down(vo

 /* These are exported to sysctl. */
 extern int dirty_background_ratio;
+extern int dirty_start_writeback_ratio;
 extern int vm_dirty_ratio;
 extern int dirty_writeback_interval;
 extern int dirty_expire_interval;
Index: linux-2.6.21-rc5-mm3-writeback/mm/page-writeback.c
===================================================================
--- linux-2.6.21-rc5-mm3-writeback.orig/mm/page-writeback.c
+++ linux-2.6.21-rc5-mm3-writeback/mm/page-writeback.c
@@ -72,6 +72,11 @@ int dirty_background_ratio = 10;
 /*
  * The generator of dirty data starts writeback at this percentage
  */
+int dirty_start_writeback_ratio = 35;
+
+/*
+ * The generator of dirty data is blocked at this percentage
+ */
 int vm_dirty_ratio = 40;

 /*
@@ -112,12 +117,16 @@ static void background_writeout(unsigned
  * performing lots of scanning.
  *
  * We only allow 1/2 of the currently-unmapped memory to be dirtied.
+ * `vm.dirty_ratio' is ignored if it is larger than that.
+ * In this case, `vm.dirty_start_writeback_ratio' is also decreased to keep
+ * writeback independently among disks.
  *
  * We don't permit the clamping level to fall below 5% - that is getting rather
  * excessive.
  *
- * We make sure that the background writeout level is below the adjusted
- * clamping level.
+ * We make sure that the active writeout level is below the adjusted clamping
+ * leve, and that the background writeout level is below the active writeout
+ * level.
  */

 static unsigned long highmem_dirtyable_memory(unsigned long total)
@@ -158,13 +167,15 @@ static unsigned long determine_dirtyable
 }

 static void
-get_dirty_limits(long *pbackground, long *pdirty,
+get_dirty_limits(long *pbackground, long *pstart_writeback, long *pdirty,
 					struct address_space *mapping)
 {
 	int background_ratio;		/* Percentages */
+	int start_writeback_ratio;
 	int dirty_ratio;
 	int unmapped_ratio;
 	long background;
+	long start_writeback;
 	long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
@@ -177,28 +188,40 @@ get_dirty_limits(long *pbackground, long
 	if (dirty_ratio > unmapped_ratio / 2)
 		dirty_ratio = unmapped_ratio / 2;

+	start_writeback_ratio = dirty_start_writeback_ratio;
+	if (start_writeback_ratio > dirty_ratio)
+		start_writeback_ratio = dirty_ratio;
+	start_writeback_ratio -= vm_dirty_ratio - dirty_ratio;
+
 	if (dirty_ratio < 5)
 		dirty_ratio = 5;
+	if (start_writeback_ratio < 2)
+		start_writeback_ratio = 2;

 	background_ratio = dirty_background_ratio;
-	if (background_ratio >= dirty_ratio)
-		background_ratio = dirty_ratio / 2;
+	if (background_ratio >= start_writeback_ratio)
+		background_ratio = start_writeback_ratio / 2;

 	background = (background_ratio * available_memory) / 100;
+	start_writeback = (start_writeback_ratio * available_memory) / 100;
 	dirty = (dirty_ratio * available_memory) / 100;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;
+		start_writeback += start_writeback / 4;
 		dirty += dirty / 4;
 	}
 	*pbackground = background;
+	*pstart_writeback = start_writeback;
 	*pdirty = dirty;
 }

 /*
  * balance_dirty_pages() must be called by processes which are generating dirty
  * data.  It looks at the number of dirty pages in the machine and will force
- * the caller to perform writeback if the system is over `vm_dirty_ratio'.
+ * the caller to perform writeback if the system is over
+ * `start_writeback_thresh'. If the system is over `dirty_thresh' then the
+ * caller will be blocked unless it cannot writeback enough pages.
  * If we're over `background_thresh' then pdflush is woken to perform some
  * writeout.
  */
@@ -206,6 +229,7 @@ static void balance_dirty_pages(struct a
 {
 	long nr_reclaimable;
 	long background_thresh;
+	long start_writeback_thresh;
 	long dirty_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
@@ -221,11 +245,12 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};

-		get_dirty_limits(&background_thresh, &dirty_thresh, mapping);
+		get_dirty_limits(&background_thresh, &start_writeback_thresh,
+				 &dirty_thresh, mapping);
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
-			dirty_thresh)
+			start_writeback_thresh)
 				break;

 		if (!dirty_exceeded)
@@ -240,7 +265,8 @@ static void balance_dirty_pages(struct a
 		if (nr_reclaimable) {
 			writeback_inodes(&wbc);
 			get_dirty_limits(&background_thresh,
-					 	&dirty_thresh, mapping);
+					 &start_writeback_thresh,
+					 &dirty_thresh, mapping);
 			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 			if (nr_reclaimable +
@@ -329,6 +355,7 @@ EXPORT_SYMBOL(balance_dirty_pages_rateli
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
 	long background_thresh;
+	long writeback_thresh;
 	long dirty_thresh;

 	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
@@ -342,7 +369,8 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}

         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &writeback_thresh,
+				 &dirty_thresh, NULL);

                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -375,9 +403,11 @@ static void background_writeout(unsigned

 	for ( ; ; ) {
 		long background_thresh;
+		long writeback_thresh;
 		long dirty_thresh;

-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &writeback_thresh,
+				 &dirty_thresh,  NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)
