Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZEYHeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZEYHeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZEYHcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:32:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38725 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbZEYHbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:16 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/12] writeback: include default_backing_dev_info in writeback
Date: Mon, 25 May 2009 09:30:59 +0200
Message-Id: <1243236668-3398-17-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see dirty inodes there occasionally, so better be safe and write them
out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |   16 +++++++++++-----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 563860c..47f5ace 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -364,7 +364,7 @@ static void wb_writeback(struct bdi_writeback *wb)
  * This will be inlined in bdi_writeback_task() once we get rid of any
  * dirty inodes on the default_backing_dev_info
  */
-static void wb_do_writeback(struct bdi_writeback *wb)
+void wb_do_writeback(struct bdi_writeback *wb)
 {
 	/*
 	 * We get here in two cases:
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index baf04a9..e414702 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -69,6 +69,7 @@ void writeback_inodes(struct writeback_control *wbc);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
 void sync_inodes(int wait);
+void wb_do_writeback(struct bdi_writeback *wb);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 3e74041..3a032be 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -388,12 +388,14 @@ static int bdi_forker_task(void *ptr)
 		struct bdi_writeback *wb;
 
 		/*
-		 * Should never trigger on the default bdi
+		 * Ideally we'd like not to see any dirty inodes on the
+		 * default_backing_dev_info. Until these are tracked down,
+		 * perform the same writeback here that bdi_writeback_task
+		 * does. For logic, see comment in
+		 * fs/fs-writeback.c:bdi_writeback_task()
 		 */
-		if (wb_has_dirty_io(me)) {
-			bdi_flush_io(me->bdi);
-			WARN_ON(1);
-		}
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+			wb_do_writeback(me);
 
 		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
 
@@ -420,6 +422,10 @@ static int bdi_forker_task(void *ptr)
 			continue;
 		}
 
+		/*
+		 * This is our real job - check for pending entries in
+		 * bdi_pending_list, and create the tasks that got added
+		 */
 		bdi = list_entry(bdi_pending_list.next, struct backing_dev_info,
 				 bdi_list);
 		list_del_init(&bdi->bdi_list);
-- 
1.6.3.rc0.1.gf800

