Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbZG1Sq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbZG1Sq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZG1Sqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:46:55 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:42036 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbZG1Sqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:subject:to:cc;
        b=C4jaN/zRDyCJeidJXkP1Cg/NhrKZqEVjHR6VGyYtqs2Q+TpkLg3FJV4Q9+i8c5aPcS
         SQz+A4EtGHGtxiLd/Ykh8R6DDs1aFSKZwPz4308xPS/Dgr/Xijw0H8hYjFPhYlOoUsqS
         tCYtew2tdqu/z2TG2pnvzv5cW3ejEcUgEXhMQ=
Message-Id: <200907281845.n6SIjIlf025081@home.pavel.comp>
From: Paul Fertser <fercerpav@gmail.com>
Date: Tue, 28 Jul 2009 00:41:15 +0400
Subject: [PATCH] pcf50633: use a dedicated workqueue for irq processing
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the default kernel "events" workqueue causes problems with
synchronous adc readings if initiated from some task on the same
workqueue.

I had a deadlock trying to use pcf50633_adc_sync_read from a
power_supply class driver because the reading was initiated from the
workqueue and it waited for the irq processing to complete (to get the
result) and that was put on the same workqueue.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c       |    5 ++++-
 include/linux/mfd/pcf50633/core.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 8d3c38b..d26d774 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -444,7 +444,7 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 
 	get_device(pcf->dev);
 	disable_irq_nosync(pcf->irq);
-	schedule_work(&pcf->irq_work);
+	queue_work(pcf->work_queue, &pcf->irq_work);
 
 	return IRQ_HANDLED;
 }
@@ -575,6 +575,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
 	pcf->irq = client->irq;
+	pcf->work_queue = create_singlethread_workqueue("pcf50633");
 
 	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
@@ -651,6 +652,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	return 0;
 
 err:
+	destroy_workqueue(pcf->work_queue);
 	kfree(pcf);
 	return ret;
 }
@@ -661,6 +663,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	int i;
 
 	free_irq(pcf->irq, pcf);
+	destroy_workqueue(pcf->work_queue);
 
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index c8f51c3..9aba7b7 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -136,6 +136,7 @@ struct pcf50633 {
 	int irq;
 	struct pcf50633_irq irq_handler[PCF50633_NUM_IRQ];
 	struct work_struct irq_work;
+	struct workqueue_struct *work_queue;
 	struct mutex lock;
 
 	u8 mask_regs[5];
-- 
1.6.0.6

