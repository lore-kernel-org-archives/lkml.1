Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZD1Dwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZD1Dwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZD1Dwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:52:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:46124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbZD1Dwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:52:35 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] hd: fix locking
Date: Tue, 28 Apr 2009 12:52:19 +0900
Message-Id: <1240890740-3462-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240890740-3462-1-git-send-email-tj@kernel.org>
References: <1240890740-3462-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 03:52:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hd dance around local irq and HD_IRQ enable without achieving much.
It ends up transferring data from irq handler with both local irq and
HD_IRQ disabled.  The only place it actually does something is while
transferring the first block of a request which it does with HD_IRQ
disabled but local irq enabled.

Unfortunately, the dancing is horribly broken from locking POV.  IRQ
and timeout handlers access block queue without grabbing the queue
lock and running the driver in SMP configuration crashes the whole
machine pretty quickly.

Remove meaningless irq enable/disable dancing and add proper locking
in issue, irq and timeout paths.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/hd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 3c11f06..baaa9e4 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -509,7 +509,6 @@ ok_to_write:
 	if (i > 0) {
 		SET_HANDLER(&write_intr);
 		outsw(HD_DATA, req->buffer, 256);
-		local_irq_enable();
 	} else {
 #if (HD_DELAY > 0)
 		last_req = read_timer();
@@ -541,8 +540,7 @@ static void hd_times_out(unsigned long dummy)
 	if (!CURRENT)
 		return;
 
-	disable_irq(HD_IRQ);
-	local_irq_enable();
+	spin_lock_irq(hd_queue->queue_lock);
 	reset = 1;
 	name = CURRENT->rq_disk->disk_name;
 	printk("%s: timeout\n", name);
@@ -552,9 +550,8 @@ static void hd_times_out(unsigned long dummy)
 #endif
 		end_request(CURRENT, 0);
 	}
-	local_irq_disable();
 	hd_request();
-	enable_irq(HD_IRQ);
+	spin_unlock_irq(hd_queue->queue_lock);
 }
 
 static int do_special_op(struct hd_i_struct *disk, struct request *req)
@@ -592,7 +589,6 @@ static void hd_request(void)
 		return;
 repeat:
 	del_timer(&device_timer);
-	local_irq_enable();
 
 	req = CURRENT;
 	if (!req) {
@@ -601,7 +597,6 @@ repeat:
 	}
 
 	if (reset) {
-		local_irq_disable();
 		reset_hd();
 		return;
 	}
@@ -660,9 +655,7 @@ repeat:
 
 static void do_hd_request(struct request_queue *q)
 {
-	disable_irq(HD_IRQ);
 	hd_request();
-	enable_irq(HD_IRQ);
 }
 
 static int hd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
@@ -684,12 +677,16 @@ static irqreturn_t hd_interrupt(int irq, void *dev_id)
 {
 	void (*handler)(void) = do_hd;
 
+	spin_lock(hd_queue->queue_lock);
+
 	do_hd = NULL;
 	del_timer(&device_timer);
 	if (!handler)
 		handler = unexpected_hd_interrupt;
 	handler();
-	local_irq_enable();
+
+	spin_unlock(hd_queue->queue_lock);
+
 	return IRQ_HANDLED;
 }
 
-- 
1.6.0.2

