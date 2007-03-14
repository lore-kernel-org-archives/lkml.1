Return-Path: <linux-kernel-owner+w=401wt.eu-S1161250AbXCNMr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161250AbXCNMr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161252AbXCNMr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:47:56 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36579 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161250AbXCNMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:47:47 -0400
Message-ID: <45F7EDF8.8070901@hitachi.com>
Date: Wed, 14 Mar 2007 21:43:36 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: [PATCH 2/3] VM throttling: Calc dirty limit based on vm.dirty_limit_ratio
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies get_dirty_limits() to calculate the limit of dirty
pages based on vm.dirty_limit_ratio. It also changes the interface of the
function to return it.

If mapped memory become large and limit_ratio (calculated based on
vm.dirty_limit_ratio) is decreased, dirty_ratio is also decreased to
keep writeback independently among disks.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Signed-off-by: Yuji Kakutani <yuji.kakutani.uw@hitachi.com>
---
 mm/page-writeback.c |   37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

Index: linux-2.6.21-rc3-mm2/mm/page-writeback.c
===================================================================
--- linux-2.6.21-rc3-mm2.orig/mm/page-writeback.c
+++ linux-2.6.21-rc3-mm2/mm/page-writeback.c
@@ -117,6 +117,9 @@ static void background_writeout(unsigned
  * performing lots of scanning.
  *
  * We only allow 1/2 of the currently-unmapped memory to be dirtied.
+ * If vm.dirty_limit_ratio is larger than that, its setting is ignored.
+ * In this case, dirty_ratio is also decreased to keep writeback independently
+ * amoung disks.
  *
  * We don't permit the clamping level to fall below 5% - that is getting rather
  * excessive.
@@ -163,14 +166,16 @@ static unsigned long determine_dirtyable
 }

 static void
-get_dirty_limits(long *pbackground, long *pdirty,
+get_dirty_limits(long *pbackground, long *pdirty, long *plimit,
 					struct address_space *mapping)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
+	int limit_ratio;
 	int unmapped_ratio;
 	long background;
 	long dirty;
+	long limit;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;

@@ -178,10 +183,17 @@ get_dirty_limits(long *pbackground, long
 				global_page_state(NR_ANON_PAGES)) * 100) /
 					available_memory;

+	limit_ratio = dirty_limit_ratio;
+	if (limit_ratio > unmapped_ratio / 2)
+		limit_ratio = unmapped_ratio / 2;
+
 	dirty_ratio = vm_dirty_ratio;
-	if (dirty_ratio > unmapped_ratio / 2)
-		dirty_ratio = unmapped_ratio / 2;
+	if (dirty_ratio > dirty_limit_ratio)
+		dirty_ratio = dirty_limit_ratio;
+	dirty_ratio -= dirty_limit_ratio - limit_ratio;

+	if (dirty_limit_ratio < 5)
+		dirty_limit_ratio = 5;
 	if (dirty_ratio < 5)
 		dirty_ratio = 5;

@@ -191,13 +203,16 @@ get_dirty_limits(long *pbackground, long

 	background = (background_ratio * available_memory) / 100;
 	dirty = (dirty_ratio * available_memory) / 100;
+	limit = (limit_ratio * available_memory) / 100;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		background += background / 4;
 		dirty += dirty / 4;
+		limit += limit / 4;
 	}
 	*pbackground = background;
 	*pdirty = dirty;
+	*plimit = limit;
 }

 /*
@@ -212,6 +227,7 @@ static void balance_dirty_pages(struct a
 	long nr_reclaimable;
 	long background_thresh;
 	long dirty_thresh;
+	long dirty_limit;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();

@@ -226,7 +242,8 @@ static void balance_dirty_pages(struct a
 			.range_cyclic	= 1,
 		};

-		get_dirty_limits(&background_thresh, &dirty_thresh, mapping);
+		get_dirty_limits(&background_thresh, &dirty_thresh,
+							&dirty_limit, mapping);
 		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 		if (nr_reclaimable + global_page_state(NR_WRITEBACK) <=
@@ -244,8 +261,8 @@ static void balance_dirty_pages(struct a
 		 */
 		if (nr_reclaimable) {
 			writeback_inodes(&wbc);
-			get_dirty_limits(&background_thresh,
-					 	&dirty_thresh, mapping);
+			get_dirty_limits(&background_thresh, &dirty_thresh,
+					 		&dirty_limit, mapping);
 			nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
 					global_page_state(NR_UNSTABLE_NFS);
 			if (nr_reclaimable +
@@ -335,6 +352,7 @@ void throttle_vm_writeout(gfp_t gfp_mask
 {
 	long background_thresh;
 	long dirty_thresh;
+	long dirty_limit;

 	if ((gfp_mask & (__GFP_FS|__GFP_IO)) != (__GFP_FS|__GFP_IO)) {
 		/*
@@ -347,7 +365,8 @@ void throttle_vm_writeout(gfp_t gfp_mask
 	}

         for ( ; ; ) {
-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh,
+							&dirty_limit, NULL);

                 /*
                  * Boost the allowable dirty threshold a bit for page
@@ -381,8 +400,10 @@ static void background_writeout(unsigned
 	for ( ; ; ) {
 		long background_thresh;
 		long dirty_thresh;
+		long dirty_limit;

-		get_dirty_limits(&background_thresh, &dirty_thresh, NULL);
+		get_dirty_limits(&background_thresh, &dirty_thresh,
+							&dirty_limit,  NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
 			global_page_state(NR_UNSTABLE_NFS) < background_thresh
 				&& min_pages <= 0)

