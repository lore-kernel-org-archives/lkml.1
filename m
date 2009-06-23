Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZFWVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZFWVeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbZFWVcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:41 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35567 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152AbZFWVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=MERP1UC06u+Gsxtgq2tnJgZAR3AoRwrcKUig8QfYwW0SXGf0V0XTun293IXZjCP/f/
         YbTlO7qXeNvNNoXNaQ6gt9k+VCPrK1rlKW3eigWO1wYHargDMBpO8J3PRJTMAC7ypSlk
         TKd6/1VbdQWp60Y284s1PD/aj1f/I7fdQSerg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 6/6] ide: improve handling of Power Management requests
Date: Tue, 23 Jun 2009 23:35:56 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906232335.57161.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: improve handling of Power Management requests

Make hwif->rq point to PM request during PM sequence and do not allow
any other types of requests to slip in (the old comment was never correct
as there should be no such requests generated during PM sequence).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This was tested in the past (with an additional testing from Borislav)
however there were block layer changes in the meantime so you may want
to give it some more testing time just to be sure.

 drivers/ide/ide-io.c |   54 ++++++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -466,10 +466,14 @@ void do_ide_request(struct request_queue
 
 	if (!ide_lock_port(hwif)) {
 		ide_hwif_t *prev_port;
-
-		WARN_ON_ONCE(hwif->rq);
 repeat:
 		prev_port = hwif->host->cur_port;
+
+		if (drive->dev_flags & IDE_DFLAG_BLOCKED)
+			rq = hwif->rq;
+		else
+			WARN_ON_ONCE(hwif->rq);
+
 		if (drive->dev_flags & IDE_DFLAG_SLEEPING &&
 		    time_after(drive->sleep, jiffies)) {
 			ide_unlock_port(hwif);
@@ -496,43 +500,29 @@ repeat:
 		hwif->cur_dev = drive;
 		drive->dev_flags &= ~(IDE_DFLAG_SLEEPING | IDE_DFLAG_PARKED);
 
-		spin_unlock_irq(&hwif->lock);
-		spin_lock_irq(q->queue_lock);
-		/*
-		 * we know that the queue isn't empty, but this can happen
-		 * if the q->prep_rq_fn() decides to kill a request
-		 */
-		if (!rq)
+		if (rq == NULL) {
+			spin_unlock_irq(&hwif->lock);
+			spin_lock_irq(q->queue_lock);
+			/*
+			 * we know that the queue isn't empty, but this can
+			 * happen if ->prep_rq_fn() decides to kill a request
+			 */
 			rq = blk_fetch_request(drive->queue);
+			spin_unlock_irq(q->queue_lock);
+			spin_lock_irq(&hwif->lock);
 
-		spin_unlock_irq(q->queue_lock);
-		spin_lock_irq(&hwif->lock);
-
-		if (!rq) {
-			ide_unlock_port(hwif);
-			goto out;
+			if (rq == NULL) {
+				ide_unlock_port(hwif);
+				goto out;
+			}
 		}
 
 		/*
 		 * Sanity: don't accept a request that isn't a PM request
-		 * if we are currently power managed. This is very important as
-		 * blk_stop_queue() doesn't prevent the blk_fetch_request()
-		 * above to return us whatever is in the queue. Since we call
-		 * ide_do_request() ourselves, we end up taking requests while
-		 * the queue is blocked...
-		 * 
-		 * We let requests forced at head of queue with ide-preempt
-		 * though. I hope that doesn't happen too much, hopefully not
-		 * unless the subdriver triggers such a thing in its own PM
-		 * state machine.
+		 * if we are currently power managed.
 		 */
-		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
-		    blk_pm_request(rq) == 0 &&
-		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
-			/* there should be no pending command at this point */
-			ide_unlock_port(hwif);
-			goto plug_device;
-		}
+		BUG_ON((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
+		       blk_pm_request(rq) == 0);
 
 		hwif->rq = rq;
 
