Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZKPGIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZKPGIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZKPGIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:08:52 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58393 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZKPGIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:08:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=aldGEEKgXFd/lnPj29hYoqHOWyrf/+BWVMY9x5a1X5heY6OxKPv0L8eacYc+8VAiIQ
         k3T9xZ/tozYQ7bUhXo1Mqy/z/WfXffEHYI28i3QznquIT8udBAQDJUmFqpefXTXiO1gS
         ky2Fgdg6mt2Q3LjrhURBez1nFJwM5WRMezCmI=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 2/5] mfd: pcf50633 - use threaded interrupts
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:08:48 -0800
Message-ID: <20091116060848.20162.64939.stgit@localhost.localdomain>
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using theraded IRQs instead of implementing custom solution
with regular inettrupt handler and a custom workqueue.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-core.c       |   57 +++++++------------------------------
 include/linux/mfd/pcf50633/core.h |    3 --
 2 files changed, 11 insertions(+), 49 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index fb44e4d..ff43f34 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -324,13 +324,13 @@ static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
 /* Maximum amount of time ONKEY is held before emergency action is taken */
 #define PCF50633_ONKEY1S_TIMEOUT 8
 
-static void pcf50633_irq_worker(struct work_struct *work)
+static irqreturn_t pcf50633_irq(int irq, void *data)
 {
-	struct pcf50633 *pcf;
+	struct pcf50633 *pcf = data;
 	int ret, i, j;
 	u8 pcf_int[5], chgstat;
 
-	pcf = container_of(work, struct pcf50633, irq_work);
+	dev_dbg(pcf->dev, "pcf50633_irq\n");
 
 	/* Read the 5 INT regs in one transaction */
 	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
@@ -435,20 +435,6 @@ static void pcf50633_irq_worker(struct work_struct *work)
 	}
 
 out:
-	put_device(pcf->dev);
-	enable_irq(pcf->irq);
-}
-
-static irqreturn_t pcf50633_irq(int irq, void *data)
-{
-	struct pcf50633 *pcf = data;
-
-	dev_dbg(pcf->dev, "pcf50633_irq\n");
-
-	get_device(pcf->dev);
-	disable_irq_nosync(pcf->irq);
-	queue_work(pcf->work_queue, &pcf->irq_work);
-
 	return IRQ_HANDLED;
 }
 
@@ -483,13 +469,9 @@ static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
 
 	pcf = i2c_get_clientdata(client);
 
-	/* Make sure our interrupt handlers are not called
-	 * henceforth */
+	/* Make sure our interrupt handlers are not called henceforth. */
 	disable_irq(pcf->irq);
 
-	/* Make sure that any running IRQ worker has quit */
-	cancel_work_sync(&pcf->irq_work);
-
 	/* Save the masks */
 	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
 				ARRAY_SIZE(pcf->suspend_irq_masks),
@@ -530,16 +512,11 @@ static int pcf50633_resume(struct i2c_client *client)
 	if (ret < 0)
 		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
 
-	/* Restore regulators' state */
-
-
-	get_device(pcf->dev);
-
 	/*
 	 * Clear any pending interrupts and set resume reason if any.
-	 * This will leave with enable_irq()
 	 */
-	pcf50633_irq_worker(&pcf->irq_work);
+	pcf50633_irq(pcf->irq, pcf);
+	enable_irq(pcf->irq);
 
 	return 0;
 }
@@ -573,22 +550,13 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
 	pcf->irq = client->irq;
-	pcf->work_queue = create_singlethread_workqueue("pcf50633");
-
-	if (!pcf->work_queue) {
-		dev_err(&client->dev, "Failed to alloc workqueue\n");
-		ret = -ENOMEM;
-		goto err_free;
-	}
-
-	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
 	version = pcf50633_reg_read(pcf, 0);
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err_destroy_workqueue;
+		goto err_free;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -602,12 +570,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
-	ret = request_irq(client->irq, pcf50633_irq,
-					IRQF_TRIGGER_LOW, "pcf50633", pcf);
-
+	ret = request_threaded_irq(client->irq, NULL, pcf50633_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "pcf50633", pcf);
 	if (ret) {
 		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
-		goto err_destroy_workqueue;
+		goto err_free;
 	}
 
 	/* Create sub devices */
@@ -650,8 +618,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	return 0;
 
-err_destroy_workqueue:
-	destroy_workqueue(pcf->work_queue);
 err_free:
 	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
@@ -665,7 +631,6 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	int i;
 
 	free_irq(pcf->irq, pcf);
-	destroy_workqueue(pcf->work_queue);
 
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 43bb2ac..fef4bda 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -15,7 +15,6 @@
 
 #include <linux/types.h>
 #include <linux/i2c.h>
-#include <linux/workqueue.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
 #include <linux/power_supply.h>
@@ -132,8 +131,6 @@ struct pcf50633 {
 	struct pcf50633_platform_data *pdata;
 	int irq;
 	struct pcf50633_irq irq_handler[PCF50633_NUM_IRQ];
-	struct work_struct irq_work;
-	struct workqueue_struct *work_queue;
 	struct mutex lock;
 
 	u8 mask_regs[5];

