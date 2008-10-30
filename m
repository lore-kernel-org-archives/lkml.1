Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYJ3TZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYJ3TZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYJ3TYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:24:01 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38429 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYJ3TX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=rjDqQRjEchn3yRFizwdNQNPRThjuH+9C7CaFeHdyxVMHo8yF77TKjnwAeBfXHDBCf
	9oZmR57kFSsQSTi14Jb/Q==
Date: Thu, 30 Oct 2008 12:23:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/7] mm: make page writeback obey cpuset constraints
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300310490.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

Currently dirty throttling does not work properly in a cpuset.

If, for example, a cpuset contains only 1/10th of available memory then
all of the memory of a cpuset can be dirtied without any writes being
triggered.  If all of the cpuset's memory is dirty then only 10% of total
memory is dirty.  The background writeback threshold is usually set at
10% and the synchrononous threshold at 40%.  So we are still below the
global limits while the dirty ratio in the cpuset is 100%!  Writeback
throttling and background writeout do not work at all in such scenarios.

This patch makes dirty writeout cpuset aware.  When determining the dirty
limits in get_dirty_limits(), we calculate values based on the nodes that
are reachable from the current process (that has been dirtying the page).
Then we can trigger writeout based on the dirty ratio of the memory in
the cpuset.

We trigger writeout in a a cpuset specific way.  We go through the dirty
inodes and search for inodes that have dirty pages on the nodes of the
active cpuset.  If an inode fulfills that requirement then we begin
writeout of the dirty pages of that inode.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/writeback.h |   13 +++-
 mm/backing-dev.c          |   12 ++--
 mm/page-writeback.c       |  164 ++++++++++++++++++++++++++++++---------------
 3 files changed, 126 insertions(+), 63 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -76,6 +76,15 @@ struct writeback_control {
 	nodemask_t *nodes;		/* Nodemask to writeback */
 };
 
+struct dirty_limits {
+	long thresh_background;
+	long thresh_dirty;
+	long thresh_bdi_dirty;
+	unsigned long nr_dirty;
+	unsigned long nr_unstable;
+	unsigned long nr_writeback;
+};
+
 /*
  * fs/fs-writeback.c
  */	
@@ -127,8 +136,8 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi);
+int get_dirty_limits(struct dirty_limits *dl, struct backing_dev_info *bdi,
+		     nodemask_t *nodes);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -24,11 +24,9 @@ static void bdi_debug_init(void)
 static int bdi_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	struct dirty_limits dl;
 
-	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
+	get_dirty_limits(&dl, bdi, NULL);
 
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 	seq_printf(m,
@@ -39,9 +37,9 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 		   "BackgroundThresh: %8lu kB\n",
 		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
 		   (unsigned long) K(bdi_stat(bdi, BDI_RECLAIMABLE)),
-		   K(bdi_thresh),
-		   K(dirty_thresh),
-		   K(background_thresh));
+		   K(dl.thresh_bdi_dirty),
+		   K(dl.thresh_dirty),
+		   K(dl.thresh_background));
 #undef K
 
 	return 0;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -320,13 +320,16 @@ EXPORT_SYMBOL(bdi_set_max_ratio);
  * clamping level.
  */
 
-static unsigned long highmem_dirtyable_memory(unsigned long total)
+static unsigned long highmem_dirtyable_memory(nodemask_t *nodes,
+					      unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
 	int node;
 	unsigned long x = 0;
 
-	for_each_node_state(node, N_HIGH_MEMORY) {
+	if (!nodes)
+		nodes = &node_states[N_HIGH_MEMORY];
+	for_each_node_mask(node, *nodes) {
 		struct zone *z =
 			&NODE_DATA(node)->node_zones[ZONE_HIGHMEM];
 
@@ -357,21 +360,75 @@ unsigned long determine_dirtyable_memory(void)
 	x = global_page_state(NR_FREE_PAGES) + global_lru_pages();
 
 	if (!vm_highmem_is_dirtyable)
-		x -= highmem_dirtyable_memory(x);
+		x -= highmem_dirtyable_memory(NULL, x);
 
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-void
-get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi)
+static void populate_global_dirty_limits(struct dirty_limits *dl,
+					 unsigned long *dirtyable_memory,
+					 unsigned long *nr_mapped)
+{
+	dl->nr_dirty = global_page_state(NR_FILE_DIRTY);
+	dl->nr_unstable = global_page_state(NR_UNSTABLE_NFS);
+	dl->nr_writeback = global_page_state(NR_WRITEBACK);
+	*dirtyable_memory = determine_dirtyable_memory();
+	*nr_mapped = global_page_state(NR_FILE_MAPPED) +
+		     global_page_state(NR_ANON_PAGES);
+}
+
+static void populate_nodemask_dirty_limits(struct dirty_limits *dl,
+					   unsigned long *dirtyable_memory,
+					   unsigned long *nr_mapped,
+					   nodemask_t *nodes)
+{
+	int node;
+
+	/*
+	 * We do not disregard highmem because all nodes (except maybe node 0)
+	 * have either all memory in HIGHMEM (32-bit) or all memory in
+	 * non-HIGHMEM (64-bit).  If we would disregard highmem, then cpuset
+	 * throttling would not work on 32-bit.
+	 */
+	for_each_node_mask(node, *nodes) {
+		if (!node_online(node))
+			continue;
+		dl->nr_dirty += node_page_state(node, NR_FILE_DIRTY);
+		dl->nr_unstable += node_page_state(node, NR_UNSTABLE_NFS);
+		dl->nr_writeback += node_page_state(node, NR_WRITEBACK);
+		*dirtyable_memory +=
+			node_page_state(node, NR_ACTIVE_ANON) +
+			node_page_state(node, NR_ACTIVE_FILE) +
+			node_page_state(node, NR_INACTIVE_ANON) +
+			node_page_state(node, NR_INACTIVE_FILE) +
+			node_page_state(node, NR_FREE_PAGES);
+		*nr_mapped +=
+			node_page_state(node, NR_FILE_MAPPED);
+			node_page_state(node, NR_ANON_PAGES);
+	}
+	*dirtyable_memory -= highmem_dirtyable_memory(nodes, *dirtyable_memory);
+}
+
+int
+get_dirty_limits(struct dirty_limits *dl, struct backing_dev_info *bdi,
+		 nodemask_t *nodes)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
 	long background;
 	long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
+	unsigned long dirtyable_memory = 0;
+	unsigned long nr_mapped = 0;
 	struct task_struct *tsk;
+	int is_subset;
+
+	memset(dl, 0, sizeof(struct dirty_limits));
+	is_subset = nodes && !nodes_subset(node_online_map, *nodes);
+	if (unlikely(is_subset))
+		populate_nodemask_dirty_limits(dl, &dirtyable_memory,
+					       &nr_mapped, nodes);
+	else
+		populate_global_dirty_limits(dl, &dirtyable_memory, &nr_mapped);
 
 	dirty_ratio = vm_dirty_ratio;
 	if (dirty_ratio < 5)
@@ -381,15 +438,15 @@ get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 	if (background_ratio >= dirty_ratio)
 		background_ratio = dirty_ratio / 2;
 
-	background = (background_ratio * available_memory) / 100;
-	dirty = (dirty_ratio * available_memory) / 100;
+	background = (background_ratio * dirtyable_memory) / 100;
+	dirty = (dirty_ratio * dirtyable_memory) / 100;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;
 		dirty += dirty / 4;
 	}
-	*pbackground = background;
-	*pdirty = dirty;
+	dl->thresh_background = background;
+	dl->thresh_dirty = dirty;
 
 	if (bdi) {
 		u64 bdi_dirty;
@@ -407,10 +464,11 @@ get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		if (bdi_dirty > (dirty * bdi->max_ratio) / 100)
 			bdi_dirty = dirty * bdi->max_ratio / 100;
 
-		*pbdi_dirty = bdi_dirty;
-		clip_bdi_dirty_limit(bdi, dirty, pbdi_dirty);
-		task_dirty_limit(current, pbdi_dirty);
+		dl->thresh_bdi_dirty = bdi_dirty;
+		clip_bdi_dirty_limit(bdi, dirty, &dl->thresh_bdi_dirty);
+		task_dirty_limit(current, &dl->thresh_bdi_dirty);
 	}
+	return is_subset;
 }
 
 /*
@@ -424,9 +482,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	struct dirty_limits dl;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
 
@@ -441,17 +497,16 @@ static void balance_dirty_pages(struct address_space *mapping)
 			.range_cyclic	= 1,
 		};
 
-		get_dirty_limits(&background_thresh, &dirty_thresh,
-				&bdi_thresh, bdi);
-
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
-		nr_writeback = global_page_state(NR_WRITEBACK);
+		if (get_dirty_limits(&dl, bdi, &cpuset_current_mems_allowed))
+			wbc.nodes = &cpuset_current_mems_allowed;
+		nr_reclaimable = dl.nr_dirty + dl.nr_unstable;
+		nr_writeback = dl.nr_writeback;
 
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+		if (bdi_nr_reclaimable + bdi_nr_writeback <=
+							dl.thresh_bdi_dirty)
 			break;
 
 		/*
@@ -460,7 +515,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * when the bdi limits are ramping up.
 		 */
 		if (nr_reclaimable + nr_writeback <
-				(background_thresh + dirty_thresh) / 2)
+				(dl.thresh_background + dl.thresh_dirty) / 2)
 			break;
 
 		if (!bdi->dirty_exceeded)
@@ -475,8 +530,12 @@ static void balance_dirty_pages(struct address_space *mapping)
 		if (bdi_nr_reclaimable) {
 			writeback_inodes(&wbc);
 			pages_written += write_chunk - wbc.nr_to_write;
-			get_dirty_limits(&background_thresh, &dirty_thresh,
-				       &bdi_thresh, bdi);
+			get_dirty_limits(&dl, bdi,
+					 &cpuset_current_mems_allowed);
+			nr_reclaimable = dl.nr_dirty + dl.nr_unstable;
+			if (nr_reclaimable + dl.nr_writeback <=
+							dl.thresh_dirty)
+				break;
 		}
 
 		/*
@@ -489,7 +548,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 		 * actually dirty; with m+n sitting in the percpu
 		 * deltas.
 		 */
-		if (bdi_thresh < 2*bdi_stat_error(bdi)) {
+		if (dl.thresh_bdi_dirty < 2*bdi_stat_error(bdi)) {
 			bdi_nr_reclaimable = bdi_stat_sum(bdi, BDI_RECLAIMABLE);
 			bdi_nr_writeback = bdi_stat_sum(bdi, BDI_WRITEBACK);
 		} else if (bdi_nr_reclaimable) {
@@ -497,7 +556,8 @@ static void balance_dirty_pages(struct address_space *mapping)
 			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
 		}
 
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+		if (bdi_nr_reclaimable + bdi_nr_writeback <=
+							dl.thresh_bdi_dirty)
 			break;
 		if (pages_written >= write_chunk)
 			break;		/* We've done our duty */
@@ -505,8 +565,8 @@ static void balance_dirty_pages(struct address_space *mapping)
 		congestion_wait(WRITE, HZ/10);
 	}
 
-	if (bdi_nr_reclaimable + bdi_nr_writeback < bdi_thresh &&
-			bdi->dirty_exceeded)
+	if (bdi->dirty_exceeded && nr_reclaimable + dl.nr_writeback <=
+							dl.thresh_dirty)
 		bdi->dirty_exceeded = 0;
 
 	if (writeback_in_progress(bdi))
@@ -521,10 +581,9 @@ static void balance_dirty_pages(struct address_space *mapping)
 	 * background_thresh, to keep the amount of dirty memory low.
 	 */
 	if ((laptop_mode && pages_written) ||
-			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
-					  + global_page_state(NR_UNSTABLE_NFS)
-					  > background_thresh)))
-		pdflush_operation(background_writeout, 0, NULL);
+		(!laptop_mode && (nr_reclaimable > dl.thresh_background)))
+		pdflush_operation(background_writeout, 0,
+				  &cpuset_current_mems_allowed);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -581,22 +640,20 @@ EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
-	long background_thresh;
-	long dirty_thresh;
+	struct dirty_limits dl;
 
         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
+		get_dirty_limits(&dl, NULL, &node_states[N_HIGH_MEMORY]);
 
-                /*
-                 * Boost the allowable dirty threshold a bit for page
-                 * allocators so they don't get DoS'ed by heavy writers
-                 */
-                dirty_thresh += dirty_thresh / 10;      /* wheeee... */
+		/*
+		 * Boost the allowable dirty threshold a bit for page
+		 * allocators so they don't get DoS'ed by heavy writers
+		 */
+		dl.thresh_dirty += dl.thresh_dirty / 10; /* wheeee... */
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
-                        	break;
-                congestion_wait(WRITE, HZ/10);
+		if (dl.nr_unstable + dl.nr_writeback <= dl.thresh_dirty)
+			break;
+		congestion_wait(WRITE, HZ/10);
 
 		/*
 		 * The caller might hold locks which can prevent IO completion
@@ -612,7 +669,7 @@ void throttle_vm_writeout(gfp_t gfp_mask)
  * writeback at least _min_pages, and keep writing until the amount of dirty
  * memory is less than the background threshold, or until we're all clean.
  */
-static void background_writeout(unsigned long _min_pages, nodemask_t *unused)
+static void background_writeout(unsigned long _min_pages, nodemask_t *nodes)
 {
 	long min_pages = _min_pages;
 	struct writeback_control wbc = {
@@ -625,13 +682,12 @@ static void background_writeout(unsigned long _min_pages, nodemask_t *unused)
 	};
 
 	for ( ; ; ) {
-		long background_thresh;
-		long dirty_thresh;
+		struct dirty_limits dl;
 
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
-		if (global_page_state(NR_FILE_DIRTY) +
-			global_page_state(NR_UNSTABLE_NFS) < background_thresh
-				&& min_pages <= 0)
+		if (get_dirty_limits(&dl, NULL, nodes))
+			wbc.nodes = nodes;
+		if (dl.nr_dirty + dl.nr_unstable < dl.thresh_background &&
+		    min_pages <= 0)
 			break;
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
