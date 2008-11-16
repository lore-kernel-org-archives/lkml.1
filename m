Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYKPJb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYKPJb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYKPJbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:31:20 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:50195 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYKPJbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:31:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JiA4gS68VzlZgmX+GoozYDK0u1Y60Fn7Oj2rIjXAEzVEhJ+Lggp36R51BKlI48LERc
         JCBABVJO0Ak7XX+tuSGqJcKHYVSiMSxLElnI015M/GIw5meif7iOHQ2bIM/59uIN1M/d
         YjkpVRQn+0WcSZHVOhIPe38yio5eiFb0qOJcQ=
From: crquan@gmail.com
To: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org
Subject: [BLOCK] remove-kblockd_flush_work.patch
Date: Sun, 16 Nov 2008 17:31:08 +0800
Message-Id: <1226827868-13127-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

After many improvements on kblockd_flush_work, it is now identical to
cancel_work_sync, so a direct call to cancel_work_sync is suggested.

The only difference is that cancel_work_sync is a GPL symbol,
so no non-GPL modules anymore.

Signed-off-by: Cheng Renquan <crquan@gmail.com>

---

Index: linux-2.6.28-rc5/block/as-iosched.c
===================================================================
--- linux-2.6.28-rc5.orig/block/as-iosched.c
+++ linux-2.6.28-rc5/block/as-iosched.c
@@ -1344,7 +1344,7 @@ static void as_exit_queue(elevator_t *e)
 	struct as_data *ad = e->elevator_data;
 
 	del_timer_sync(&ad->antic_timer);
-	kblockd_flush_work(&ad->antic_work);
+	cancel_work_sync(&ad->antic_work);
 
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_SYNC]));
 	BUG_ON(!list_empty(&ad->fifo_list[REQ_ASYNC]));
Index: linux-2.6.28-rc5/block/blk-core.c
===================================================================
--- linux-2.6.28-rc5.orig/block/blk-core.c
+++ linux-2.6.28-rc5/block/blk-core.c
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(blk_stop_queue);
 void blk_sync_queue(struct request_queue *q)
 {
 	del_timer_sync(&q->unplug_timer);
-	kblockd_flush_work(&q->unplug_work);
+	cancel_work_sync(&q->unplug_work);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -2113,12 +2113,6 @@ int kblockd_schedule_work(struct request
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-void kblockd_flush_work(struct work_struct *work)
-{
-	cancel_work_sync(work);
-}
-EXPORT_SYMBOL(kblockd_flush_work);
-
 int __init blk_dev_init(void)
 {
 	kblockd_workqueue = create_workqueue("kblockd");
Index: linux-2.6.28-rc5/block/cfq-iosched.c
===================================================================
--- linux-2.6.28-rc5.orig/block/cfq-iosched.c
+++ linux-2.6.28-rc5/block/cfq-iosched.c
@@ -2160,7 +2160,7 @@ out_cont:
 static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 {
 	del_timer_sync(&cfqd->idle_slice_timer);
-	kblockd_flush_work(&cfqd->unplug_work);
+	cancel_work_sync(&cfqd->unplug_work);
 }
 
 static void cfq_put_async_queues(struct cfq_data *cfqd)
Index: linux-2.6.28-rc5/include/linux/blkdev.h
===================================================================
--- linux-2.6.28-rc5.orig/include/linux/blkdev.h
+++ linux-2.6.28-rc5/include/linux/blkdev.h
@@ -977,7 +977,6 @@ static inline void put_dev_sector(Sector
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-void kblockd_flush_work(struct work_struct *work);
 
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
