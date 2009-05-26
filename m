Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZEZJfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZEZJfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZEZJd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:33:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:54791 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbZEZJdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:33:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/12] writeback: include default_backing_dev_info in writeback
Date: Tue, 26 May 2009 11:33:46 +0200
Message-Id: <1243330430-9964-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see dirty inodes there occasionally, so better be safe and write them
out.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c         |    2 +-
 include/linux/writeback.h |    1 +
 mm/backing-dev.c          |    8 ++++++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8e0902e..e4f96b9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -432,7 +432,7 @@ static void wb_writeback(struct bdi_writeback *wb)
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
index 57e44e3..977c171 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -396,8 +396,8 @@ static int bdi_forker_task(void *ptr)
 		 * Temporary measure, we want to make sure we don't see
 		 * dirty data on the default backing_dev_info
 		 */
-		if (wb_has_dirty_io(me))
-			bdi_flush_io(me->bdi);
+		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
+			wb_do_writeback(me);
 
 		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
 
@@ -424,6 +424,10 @@ static int bdi_forker_task(void *ptr)
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

