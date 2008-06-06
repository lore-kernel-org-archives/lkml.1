Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYFFOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYFFOJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYFFOJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:09:11 -0400
Received: from pecan.exetel.com.au ([220.233.0.17]:38640 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859AbYFFOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:09:10 -0400
X-Greylist: delayed 1527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2008 10:09:10 EDT
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 2/3] memstick: add "start" and "stop" methods to memstick device
Date: Fri,  6 Jun 2008 23:30:31 +1000
Message-Id: <1212759032-11793-3-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1212759032-11793-2-git-send-email-oakad@exemail.com.au>
References: <1212759032-11793-1-git-send-email-oakad@exemail.com.au>
 <1212759032-11793-2-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

In some cases it may be desirable to ensure that associated driver is not going
to access the media in some period of time. "start" and "stop" methods are
provided therefore to allow it.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/memstick.c    |   11 ++++++++---
 drivers/memstick/core/mspro_block.c |   33 +++++++++++++++++++++++++++++++++
 include/linux/memstick.h            |    4 ++++
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index 3c7d9a7..7162f77 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -433,8 +433,11 @@ static void memstick_check(struct work_struct *work)
 
 	dev_dbg(&host->dev, "memstick_check started\n");
 	mutex_lock(&host->lock);
-	if (!host->card)
-		memstick_power_on(host);
+	if (!host->card) {
+		if (memstick_power_on(host))
+			goto out_power_off;
+	} else
+		host->card->stop(host->card);
 
 	card = memstick_alloc_card(host);
 
@@ -452,7 +455,8 @@ static void memstick_check(struct work_struct *work)
 			    || !(host->card->check(host->card))) {
 				device_unregister(&host->card->dev);
 				host->card = NULL;
-			}
+			} else
+				host->card->start(host->card);
 		}
 
 		if (!host->card) {
@@ -465,6 +469,7 @@ static void memstick_check(struct work_struct *work)
 			kfree(card);
 	}
 
+out_power_off:
 	if (!host->card)
 		host->set_param(host, MEMSTICK_POWER, MEMSTICK_POWER_OFF);
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 477d0fb..004ac4d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -752,6 +752,37 @@ static int mspro_block_has_request(struct mspro_block_data *msb)
 	return rc;
 }
 
+static void mspro_block_stop(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	int rc = 0;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&msb->q_lock, flags);
+		if (!msb->has_request) {
+			blk_stop_queue(msb->queue);
+			rc = 1;
+		}
+		spin_unlock_irqrestore(&msb->q_lock, flags);
+
+		if (rc)
+			break;
+
+		wait_for_completion(&card->mrq_complete);
+	}
+}
+
+static void mspro_block_start(struct memstick_dev *card)
+{
+	struct mspro_block_data *msb = memstick_get_drvdata(card);
+	unsigned long flags;
+
+	spin_lock_irqsave(&msb->q_lock, flags);
+	blk_start_queue(msb->queue);
+	spin_unlock_irqrestore(&msb->q_lock, flags);
+}
+
 static int mspro_block_queue_thread(void *data)
 {
 	struct memstick_dev *card = data;
@@ -1272,6 +1303,8 @@ static int mspro_block_probe(struct memstick_dev *card)
 	rc = mspro_block_init_disk(card);
 	if (!rc) {
 		card->check = mspro_block_check_card;
+		card->stop = mspro_block_stop;
+		card->start = mspro_block_start;
 		return 0;
 	}
 
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 2fe599c..a9f998a 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -263,6 +263,10 @@ struct memstick_dev {
 	/* Get next request from the media driver.                         */
 	int                      (*next_request)(struct memstick_dev *card,
 						 struct memstick_request **mrq);
+	/* Tell the media driver to stop doing things                      */
+	void                     (*stop)(struct memstick_dev *card);
+	/* Allow the media driver to continue                              */
+	void                     (*start)(struct memstick_dev *card);
 
 	struct device            dev;
 };
-- 
1.5.3.6

