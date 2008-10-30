Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYJ3TZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYJ3TZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYJ3TX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:23:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbYJ3TX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=hz3pJtLVqq2oa61fGW4bLinnN3rM3aWkgwNNnOdycWJzcEAjA2ZHv5I75pwB7MImN
	qR4pzdjqKJYX15NKMoEmw==
Date: Thu, 30 Oct 2008 12:23:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/7] pdflush: allow the passing of a nodemask parameter
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300310340.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

If we want to support nodemask specific writeout, then we need a way to
communicate the set of nodes that an operation should affect.

So add a nodemask_t parameter to the pdflush functions and also store
the nodemask in the pdflush control structure.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/buffer.c               |    2 +-
 fs/super.c                |    4 ++--
 fs/sync.c                 |    8 ++++----
 include/linux/writeback.h |    5 +++--
 mm/page-writeback.c       |   18 +++++++++---------
 mm/pdflush.c              |   15 ++++++++++++---
 mm/vmscan.c               |    2 +-
 7 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -364,7 +364,7 @@ static void free_more_memory(void)
 	struct zone *zone;
 	int nid;
 
-	wakeup_pdflush(1024);
+	wakeup_pdflush(1024, NULL);
 	yield();
 
 	for_each_online_node(nid) {
diff --git a/fs/super.c b/fs/super.c
--- a/fs/super.c
+++ b/fs/super.c
@@ -646,7 +646,7 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	return 0;
 }
 
-static void do_emergency_remount(unsigned long foo)
+static void do_emergency_remount(unsigned long foo, nodemask_t *bar)
 {
 	struct super_block *sb;
 
@@ -674,7 +674,7 @@ static void do_emergency_remount(unsigned long foo)
 
 void emergency_remount(void)
 {
-	pdflush_operation(do_emergency_remount, 0);
+	pdflush_operation(do_emergency_remount, 0, NULL);
 }
 
 /*
diff --git a/fs/sync.c b/fs/sync.c
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -21,9 +21,9 @@
  * sync everything.  Start out by waking pdflush, because that writes back
  * all queues in parallel.
  */
-static void do_sync(unsigned long wait)
+static void do_sync(unsigned long wait, nodemask_t *unused)
 {
-	wakeup_pdflush(0);
+	wakeup_pdflush(0, NULL);
 	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
 	DQUOT_SYNC(NULL);
 	sync_supers();		/* Write the superblocks */
@@ -38,13 +38,13 @@ static void do_sync(unsigned long wait)
 
 asmlinkage long sys_sync(void)
 {
-	do_sync(1);
+	do_sync(1, NULL);
 	return 0;
 }
 
 void emergency_sync(void)
 {
-	pdflush_operation(do_sync, 0);
+	pdflush_operation(do_sync, 0, NULL);
 }
 
 /*
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -102,7 +102,7 @@ static inline void inode_sync_wait(struct inode *inode)
 /*
  * mm/page-writeback.c
  */
-int wakeup_pdflush(long nr_pages);
+int wakeup_pdflush(long nr_pages, nodemask_t *nodes);
 void laptop_io_completion(void);
 void laptop_sync_completion(void);
 void throttle_vm_writeout(gfp_t gfp_mask);
@@ -143,7 +143,8 @@ balance_dirty_pages_ratelimited(struct address_space *mapping)
 typedef int (*writepage_t)(struct page *page, struct writeback_control *wbc,
 				void *data);
 
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0);
+int pdflush_operation(void (*fn)(unsigned long, nodemask_t *nodes),
+		      unsigned long arg0, nodemask_t *nodes);
 int generic_writepages(struct address_space *mapping,
 		       struct writeback_control *wbc);
 int write_cache_pages(struct address_space *mapping,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -106,7 +106,7 @@ EXPORT_SYMBOL(laptop_mode);
 /* End of sysctl-exported parameters */
 
 
-static void background_writeout(unsigned long _min_pages);
+static void background_writeout(unsigned long _min_pages, nodemask_t *nodes);
 
 /*
  * Scale the writeback cache size proportional to the relative writeout speeds.
@@ -528,7 +528,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		pdflush_operation(background_writeout, 0);
+		pdflush_operation(background_writeout, 0, NULL);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -616,7 +616,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
  */
-static void background_writeout(unsigned long _min_pages)
+static void background_writeout(unsigned long _min_pages, nodemask_t *unused)
 {
 	long min_pages = _min_pages;
 	struct writeback_control wbc = {
@@ -658,12 +658,12 @@ static void background_writeout(unsigned long _min_pages)
  * the whole world.  Returns 0 if a pdflush thread was dispatched.  Returns
  * -1 if all pdflush threads were busy.
  */
-int wakeup_pdflush(long nr_pages)
+int wakeup_pdflush(long nr_pages, nodemask_t *nodes)
 {
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	return pdflush_operation(background_writeout, nr_pages);
+	return pdflush_operation(background_writeout, nr_pages, nodes);
 }
 
 static void wb_timer_fn(unsigned long unused);
@@ -687,7 +687,7 @@ static DEFINE_TIMER(laptop_mode_wb_timer, laptop_timer_fn, 0, 0);
  * older_than_this takes precedence over nr_to_write.  So we'll only write back
  * all dirty pages if they are all attached to "old" mappings.
  */
-static void wb_kupdate(unsigned long arg)
+static void wb_kupdate(unsigned long arg, nodemask_t *unused)
 {
 	unsigned long oldest_jif;
 	unsigned long start_jif;
@@ -746,18 +746,18 @@ int dirty_writeback_centisecs_handler(ctl_table *table, int write,
 
 static void wb_timer_fn(unsigned long unused)
 {
-	if (pdflush_operation(wb_kupdate, 0) < 0)
+	if (pdflush_operation(wb_kupdate, 0, NULL) < 0)
 		mod_timer(&wb_timer, jiffies + HZ); /* delay 1 second */
 }
 
-static void laptop_flush(unsigned long unused)
+static void laptop_flush(unsigned long unused, nodemask_t *unused2)
 {
 	sys_sync();
 }
 
 static void laptop_timer_fn(unsigned long unused)
 {
-	pdflush_operation(laptop_flush, 0);
+	pdflush_operation(laptop_flush, 0, NULL);
 }
 
 /*
diff --git a/mm/pdflush.c b/mm/pdflush.c
--- a/mm/pdflush.c
+++ b/mm/pdflush.c
@@ -83,10 +83,12 @@ static unsigned long last_empty_jifs;
  */
 struct pdflush_work {
 	struct task_struct *who;	/* The thread */
-	void (*fn)(unsigned long);	/* A callback function */
+	void (*fn)(unsigned long, nodemask_t *); /* A callback function */
 	unsigned long arg0;		/* An argument to the callback */
 	struct list_head list;		/* On pdflush_list, when idle */
 	unsigned long when_i_went_to_sleep;
+	int have_nodes;			/* Nodes were specified */
+	nodemask_t nodes;		/* Nodes to writeback */
 };
 
 static int __pdflush(struct pdflush_work *my_work)
@@ -124,7 +126,8 @@ static int __pdflush(struct pdflush_work *my_work)
 		}
 		spin_unlock_irq(&pdflush_lock);
 
-		(*my_work->fn)(my_work->arg0);
+		(*my_work->fn)(my_work->arg0,
+			       my_work->have_nodes ? &my_work->nodes : NULL);
 
 		/*
 		 * Thread creation: For how long have there been zero
@@ -198,7 +201,8 @@ static int pdflush(void *dummy)
  * Returns zero if it indeed managed to find a worker thread, and passed your
  * payload to it.
  */
-int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
+int pdflush_operation(void (*fn)(unsigned long, nodemask_t *),
+		      unsigned long arg0, nodemask_t *nodes)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -217,6 +221,11 @@ int pdflush_operation(void (*fn)(unsigned long), unsigned long arg0)
 			last_empty_jifs = jiffies;
 		pdf->fn = fn;
 		pdf->arg0 = arg0;
+		if (nodes) {
+			pdf->nodes = *nodes;
+			pdf->have_nodes = 1;
+		} else
+			pdf->have_nodes = 0;
 		wake_up_process(pdf->who);
 	}
 	spin_unlock_irqrestore(&pdflush_lock, flags);
diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1400,7 +1400,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 */
 		if (total_scanned > sc->swap_cluster_max +
 					sc->swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned);
+			wakeup_pdflush(laptop_mode ? 0 : total_scanned, NULL);
 			sc->may_writepage = 1;
 		}
 
