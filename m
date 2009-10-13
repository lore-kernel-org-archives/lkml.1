Return-Path: <linux-kernel-owner+w=401wt.eu-S934483AbZJMWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbZJMWOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934474AbZJMWOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:14:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:32268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472AbZJMWOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P1XVEmogR7PX6L70cGcasKsnG3yFNZ3cAiiR5HDnH7q4OzsjJXAjRd//ZotQd72Aj3
         zTkQUjwgC3hP28nad2BeAROU6aCqHdi+d7FPYaDxUvviMVSj+3V7AmoKqL8uAoU3zNZA
         Vmt0EehmL7sKyw6v1jaV/YbnzpN5JyK1SPXnU=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 5/7] mfd: pcf50633: Cleanup pcf50633_probe error handling
Date: Wed, 14 Oct 2009 02:12:34 +0400
Message-Id: <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Currently the child devices were not freed if the irq could not be requested.
This patch restructures the function, that in case of an error all previously
allocated resources are freed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |   47 +++++++++++++++++++++++++-----------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 69cdbdc..2e7f903 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -553,9 +553,14 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 {
 	struct pcf50633 *pcf;
 	struct pcf50633_platform_data *pdata = client->dev.platform_data;
-	int i, ret = 0;
+	int i, ret;
 	int version, variant;
 
+	if (!client->irq) {
+		dev_err(&client->dev, "Missing IRQ\n");
+		return -ENOENT;
+	}
+
 	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
@@ -570,6 +575,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf->irq = client->irq;
 	pcf->work_queue = create_singlethread_workqueue("pcf50633");
 
+	if (!pcf->work_queue) {
+		dev_err(&client->dev, "Failed to alloc workqueue\n");
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
 	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
 	version = pcf50633_reg_read(pcf, 0);
@@ -577,7 +588,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
 		ret = -ENODEV;
-		goto err;
+		goto err_destroy_workqueue;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
@@ -591,6 +602,14 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
+	ret = request_irq(client->irq, pcf50633_irq,
+					IRQF_TRIGGER_LOW, "pcf50633", pcf);
+
+	if (ret) {
+		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+		goto err_destroy_workqueue;
+	}
+
 	/* Create sub devices */
 	pcf50633_client_dev_register(pcf, "pcf50633-input",
 						&pcf->input_pdev);
@@ -606,7 +625,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 		pdev = platform_device_alloc("pcf50633-regltr", i);
 		if (!pdev) {
-			dev_err(pcf->dev, "Cannot create regulator\n");
+			dev_err(pcf->dev, "Cannot create regulator %d\n", i);
 			continue;
 		}
 
@@ -618,35 +637,25 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		platform_device_add(pdev);
 	}
 
-	if (client->irq) {
-		ret = request_irq(client->irq, pcf50633_irq,
-				IRQF_TRIGGER_LOW, "pcf50633", pcf);
-
-		if (ret) {
-			dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
-			goto err;
-		}
-	} else {
-		dev_err(pcf->dev, "No IRQ configured\n");
-		goto err;
-	}
-
 	if (enable_irq_wake(client->irq) < 0)
-		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
+		dev_info(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
 			"in this hardware revision", client->irq);
 
 	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
 	if (ret)
-		dev_err(pcf->dev, "error creating sysfs entries\n");
+		dev_info(pcf->dev, "Failed to create sysfs entries\n");
 
 	if (pdata->probe_done)
 		pdata->probe_done(pcf);
 
 	return 0;
 
-err:
+err_destroy_workqueue:
 	destroy_workqueue(pcf->work_queue);
+err_free:
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
+
 	return ret;
 }
 
-- 
1.6.0.6

