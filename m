Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZHRIfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZHRIfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbZHRIfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:35:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34373 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbZHRIfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:35:03 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: zach.brown@oracle.com, hch@infradead.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/4] direct-io: get rid of irq flag saving where it isn't needed
Date: Tue, 18 Aug 2009 10:35:01 +0200
Message-Id: <1250584501-31140-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.53.g3f55e
In-Reply-To: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
References: <1250584501-31140-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use the flags saving variant of the spin lock functions everywhere
in fs/direct-io.c, even in places where we otherwise block. Get rid
of that except for the end_io path, which may indeed be called with
irqs disabled.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/direct-io.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e923f2..2f73593 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -259,13 +259,12 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 static void dio_bio_submit(struct dio *dio)
 {
 	struct bio *bio = dio->bio;
-	unsigned long flags;
 
 	bio->bi_private = dio;
 
-	spin_lock_irqsave(&dio->bio_lock, flags);
+	spin_lock_irq(&dio->bio_lock);
 	dio->refcount++;
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
+	spin_unlock_irq(&dio->bio_lock);
 
 	if (dio->is_async && dio->rw == READ)
 		bio_set_pages_dirty(bio);
@@ -295,10 +294,9 @@ static void dio_cleanup(struct dio *dio)
  */
 static struct bio *dio_await_one(struct dio *dio)
 {
-	unsigned long flags;
 	struct bio *bio = NULL;
 
-	spin_lock_irqsave(&dio->bio_lock, flags);
+	spin_lock_irq(&dio->bio_lock);
 
 	/*
 	 * Wait as long as the list is empty and there are bios in flight.  bio
@@ -309,17 +307,17 @@ static struct bio *dio_await_one(struct dio *dio)
 	while (dio->refcount > 1 && dio->bio_list == NULL) {
 		__set_current_state(TASK_UNINTERRUPTIBLE);
 		dio->waiter = current;
-		spin_unlock_irqrestore(&dio->bio_lock, flags);
+		spin_unlock_irq(&dio->bio_lock);
 		io_schedule();
 		/* wake up sets us TASK_RUNNING */
-		spin_lock_irqsave(&dio->bio_lock, flags);
+		spin_lock_irq(&dio->bio_lock);
 		dio->waiter = NULL;
 	}
 	if (dio->bio_list) {
 		bio = dio->bio_list;
 		dio->bio_list = bio->bi_private;
 	}
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
+	spin_unlock_irq(&dio->bio_lock);
 	return bio;
 }
 
@@ -388,14 +386,13 @@ static int dio_bio_reap(struct dio *dio)
 
 	if (dio->reap_counter++ >= 64) {
 		while (dio->bio_list) {
-			unsigned long flags;
 			struct bio *bio;
 			int ret2;
 
-			spin_lock_irqsave(&dio->bio_lock, flags);
+			spin_lock_irq(&dio->bio_lock);
 			bio = dio->bio_list;
 			dio->bio_list = bio->bi_private;
-			spin_unlock_irqrestore(&dio->bio_lock, flags);
+			spin_unlock_irq(&dio->bio_lock);
 			ret2 = dio_bio_complete(dio, bio);
 			if (ret == 0)
 				ret = ret2;
@@ -870,7 +867,6 @@ direct_io_worker(struct kiocb *iocb, struct inode *inode,
 	struct dio_args *args, unsigned blkbits, get_block_t get_block,
 	dio_iodone_t end_io, struct dio *dio)
 {
-	unsigned long flags;
 	int rw = args->rw;
 	ssize_t ret = 0;
 	ssize_t ret2;
@@ -984,9 +980,9 @@ direct_io_worker(struct kiocb *iocb, struct inode *inode,
 	 * completion paths can drop their ref and use the remaining count to
 	 * decide to wake the submission path atomically.
 	 */
-	spin_lock_irqsave(&dio->bio_lock, flags);
+	spin_lock_irq(&dio->bio_lock);
 	ret2 = --dio->refcount;
-	spin_unlock_irqrestore(&dio->bio_lock, flags);
+	spin_unlock_irq(&dio->bio_lock);
 
 	if (ret2 == 0) {
 		ret = dio_complete(dio, args->offset, ret);
-- 
1.6.4.53.g3f55e

