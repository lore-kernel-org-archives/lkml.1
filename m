Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbZERMYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbZERMYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZERMU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:20:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38053 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZERMT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:19:56 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/11] writeback: include default_backing_dev_info in writeback
Date: Mon, 18 May 2009 14:19:47 +0200
Message-Id: <1242649192-16263-7-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see dirty inodes there occasionally, so better be safe and write them
out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |   30 ++++++++++++++++++------------
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index efdce88..d9cd3b7 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -335,7 +335,7 @@ static void wb_writeback(struct bdi_writeback *wb)
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
index b4bcb14..89d6eea 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -386,20 +386,26 @@ static int bdi_forker_task(void *ptr)
 		struct backing_dev_info *bdi;
 		struct bdi_writeback *wb;
 
-		/*
-		 * Should never trigger on the default bdi
-		 */
-		if (wb_has_dirty_io(me)) {
-			bdi_flush_io(me->bdi);
-			WARN_ON(1);
-		}
-
 		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
 
 		smp_mb();
 		if (list_empty(&bdi_pending_list))
 			schedule();
 
+		/*
+		 * Ideally we'd like not to see any dirty inodes on the
+		 * default_backing_dev_info. Until these are tracked down,
+		 * perform the same writeback here that bdi_writeback_task
+		 * does. For logic, see comment in
+		 * fs/fs-writeback.c:bdi_writeback_task()
+		 */
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+			wb_do_writeback(me);
+
+		/*
+		 * This is our real job - check for pending entries in
+		 * bdi_pending_list, and create the tasks that got added
+		 */
 repeat:
 		bdi = NULL;
 		spin_lock_bh(&bdi_lock);
@@ -567,12 +573,12 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 			ret = -ENOMEM;
 			goto exit;
 		}
-	} else {
-		spin_lock_bh(&bdi_lock);
-		list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-		spin_unlock_bh(&bdi_lock);
 	}
 
+	spin_lock_bh(&bdi_lock);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	spin_unlock_bh(&bdi_lock);
+
 	bdi->dev = dev;
 	bdi_debug_register(bdi, dev_name(dev));
 
-- 
1.6.3.rc0.1.gf800

