Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYKWSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYKWSzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYKWSzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:55:35 -0500
Received: from smtp-out.google.com ([216.239.45.13]:10214 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYKWSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:55:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=VabOObGqbm0vmizrIyz3iOjftI0/tdHxTHmz4cWPzuULyD6qHuP425knpligzpWmn
	pN3ZbCOBkJpedMdXDqYBQ==
Date: Sun, 23 Nov 2008 10:55:16 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: change dirty limit type specifiers to unsigned
 long
Message-ID: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The background dirty and dirty limits are better defined with type
specifiers of unsigned long since negative writeback thresholds are not
possible.

These values, as returned by get_dirty_limits(), are normally compared
with ZVC values to determine whether writeback shall commence or be
throttled.  Such page counts cannot be negative, so declaring the page
limits as signed is unnecessary.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/writeback.h |    4 ++--
 mm/backing-dev.c          |    6 +++---
 mm/page-writeback.c       |   22 +++++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -125,8 +125,8 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi);
+void get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
+		      unsigned long *pbdi_dirty, struct backing_dev_info *bdi);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -24,9 +24,9 @@ static void bdi_debug_init(void)
 static int bdi_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long bdi_thresh;
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -362,13 +362,13 @@ unsigned long determine_dirtyable_memory(void)
 }
 
 void
-get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi)
+get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
+		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
-	long background;
-	long dirty;
+	unsigned long background;
+	unsigned long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
@@ -423,9 +423,9 @@ static void balance_dirty_pages(struct address_space *mapping)
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
 
@@ -580,8 +580,8 @@ EXPORT_SYMBOL(balance_dirty_pages_ratelimited_nr);
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
-	long background_thresh;
-	long dirty_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
 
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
@@ -624,8 +624,8 @@ static void background_writeout(unsigned long _min_pages)
 	};
 
 	for ( ; ; ) {
-		long background_thresh;
-		long dirty_thresh;
+		unsigned long background_thresh;
+		unsigned long dirty_thresh;
 
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
