Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbZIALTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbZIALTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZIALTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:19:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbZIALTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:19:41 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org, jack@suse.cz,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_pages
Date: Tue,  1 Sep 2009 13:19:06 +0200
Message-Id: <1251803946-9243-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
concern of not holding I_SYNC for too long.  (At least, that was the
comment previously.)  This doesn't make sense now because the only
time we wait for I_SYNC is if we are calling sync or fsync, and in
that case we need to write out all of the data anyway.  Previously
there may have been other code paths that waited on I_SYNC, but not
any more.

According to Christoph, the current writeback size is way too small,
and XFS had a hack that bumped out nr_to_write to four times the value
sent by the VM to be able to saturate medium-sized RAID arrays.  This
value was also problematic for ext4 as well, as it caused large files
to be come interleaved on disk by in 8 megabyte chunks (we bumped up
the nr_to_write by a factor of two).

So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable, and
change the default to be 32768 blocks.

http://bugzilla.kernel.org/show_bug.cgi?id=13930

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |   15 +++------------
 include/linux/writeback.h |    1 +
 kernel/sysctl.c           |    8 ++++++++
 mm/page-writeback.c       |    6 ++++++
 4 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 38cb758..9703136 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -585,15 +585,6 @@ void generic_sync_bdi_inodes(struct writeback_control *wbc)
 	generic_sync_wb_inodes(&bdi->wb, wbc);
 }
 
-/*
- * The maximum number of pages to writeout in a single bdi flush/kupdate
- * operation.  We do this so we don't hold I_SYNC against an inode for
- * enormous amounts of time, which would block a userspace task which has
- * been forced to throttle against that inode.  Also, the code reevaluates
- * the dirty each time it has written this many pages.
- */
-#define MAX_WRITEBACK_PAGES     1024
-
 static inline bool over_bground_thresh(void)
 {
 	unsigned long background_thresh, dirty_thresh;
@@ -647,11 +638,11 @@ static long wb_writeback(struct bdi_writeback *wb, long nr_pages,
 
 		wbc.more_io = 0;
 		wbc.encountered_congestion = 0;
-		wbc.nr_to_write = MAX_WRITEBACK_PAGES;
+		wbc.nr_to_write = max_writeback_pages;
 		wbc.pages_skipped = 0;
 		generic_sync_wb_inodes(wb, &wbc);
-		nr_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
-		wrote += MAX_WRITEBACK_PAGES - wbc.nr_to_write;
+		nr_pages -= max_writeback_pages - wbc.nr_to_write;
+		wrote += max_writeback_pages - wbc.nr_to_write;
 
 		/*
 		 * If we ran out of stuff to write, bail unless more_io got set
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 34c59f9..c5b54e2 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -103,6 +103,7 @@ extern int vm_dirty_ratio;
 extern unsigned long vm_dirty_bytes;
 extern unsigned int dirty_writeback_interval;
 extern unsigned int dirty_expire_interval;
+extern unsigned int max_writeback_pages;
 extern int vm_highmem_is_dirtyable;
 extern int block_dump;
 extern int laptop_mode;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 58be760..06d1c4c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1104,6 +1104,14 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "max_writeback_pages",
+		.data		= &max_writeback_pages,
+		.maxlen		= sizeof(max_writeback_pages),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0fce7df..40b7e0a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -55,6 +55,12 @@ static inline long sync_writeback_pages(void)
 /* The following parameters are exported via /proc/sys/vm */
 
 /*
+ * The maximum number of pages to write out in a single bdflush/kupdate
+ * operation.
+ */
+unsigned int max_writeback_pages = 32768;
+
+/*
  * Start background writeback (via pdflush) at this percentage
  */
 int dirty_background_ratio = 10;
-- 
1.6.4.1.207.g68ea

