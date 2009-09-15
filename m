Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZIOSSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZIOSSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbZIOSSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:18:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59592 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbZIOSQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:16:54 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, jack@suse.cz, trond.myklebust@fys.uio.no,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/11] writeback: add comments to bdi_work structure
Date: Tue, 15 Sep 2009 20:16:57 +0200
Message-Id: <1253038617-30204-12-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.1.207.g68ea
In-Reply-To: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And document its retriever, get_next_work_item().

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3de93a9..6e199ef 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -49,15 +49,15 @@ struct wb_writeback_args {
  * Work items for the bdi_writeback threads
  */
 struct bdi_work {
-	struct list_head list;
-	struct rcu_head rcu_head;
+	struct list_head list;		/* pending work list */
+	struct rcu_head rcu_head;	/* for RCU free/clear of work */
 
-	unsigned long seen;
-	atomic_t pending;
+	unsigned long seen;		/* threads that have seen this work */
+	atomic_t pending;		/* number of threads still to do work */
 
-	struct wb_writeback_args args;
+	struct wb_writeback_args args;	/* writeback arguments */
 
-	unsigned long state;
+	unsigned long state;		/* flag bits, see WS_* */
 };
 
 enum {
@@ -758,7 +758,11 @@ static long wb_writeback(struct bdi_writeback *wb,
 
 /*
  * Return the next bdi_work struct that hasn't been processed by this
- * wb thread yet
+ * wb thread yet. ->seen is initially set for each thread that exists
+ * for this device, when a thread first notices a piece of work it
+ * clears its bit. Depending on writeback type, the thread will notify
+ * completion on either receiving the work (WB_SYNC_NONE) or after
+ * it is done (WB_SYNC_ALL).
  */
 static struct bdi_work *get_next_work_item(struct backing_dev_info *bdi,
 					   struct bdi_writeback *wb)
-- 
1.6.4.1.207.g68ea

