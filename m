Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZKIJZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZKIJZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZKIJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:25:21 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52019 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZKIJZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=iyPxnBjqwsfQBJegGhZOZ+OGfXWjST+ZJt6ZSAdSA1N9cMYM/oSnEwscfhVEopyHpH
         GPcFi8Ma2PPPRPIXn+ned9DZIise9zT25IdRsstYm2jQvaD2UaqhA/FxVLJhwkfdaEFl
         3fFBxH01kNQ/pPlelj7E7XQ1i41CKeY4UbVkw=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/2] mfd: pcf50633 - fix error handling during probe
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Nov 2009 01:25:16 -0800
Message-ID: <20091109092516.29634.32640.stgit@localhost.localdomain>
In-Reply-To: <20091109092447.29634.79364.stgit@localhost.localdomain>
References: <20091109092447.29634.79364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcf50633 is very naive - it assumes that all driver core
operations will succeed and will fail badly if one of them
errors out. Implement proper error handling and make sure we
release any and all resources that have been allocated prior
to failure.

Also avoid memory leak when using platform_device_add_data()
which clones the supplied data structure for use by the device.
The original copy, if allocated dynamically, needs to be freed
by the caller; switch to using on-stack variable (the size of
the structure in question is quite small) instead.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-adc.c        |    2 
 drivers/mfd/pcf50633-core.c       |  200 +++++++++++++++++++++++--------------
 drivers/power/pcf50633-charger.c  |    6 +
 include/linux/mfd/pcf50633/core.h |   12 +-
 4 files changed, 139 insertions(+), 81 deletions(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 3d31e97..851b014 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -52,7 +52,7 @@ struct pcf50633_adc {
 
 static inline struct pcf50633_adc *__to_adc(struct pcf50633 *pcf)
 {
-	return platform_get_drvdata(pcf->adc_pdev);
+	return platform_get_drvdata(pcf->pdevs[PCF50633_PDEV_ADC_IDX]);
 }
 
 static void adc_setup(struct pcf50633 *pcf, int channel, int avg)
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index d26d774..a3d0226 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -2,7 +2,7 @@
  *
  * (C) 2006-2008 by Openmoko, Inc.
  * Author: Harald Welte <laforge@openmoko.org>
- * 	   Balaji Rao <balajirrao@openmoko.org>
+ *	   Balaji Rao <balajirrao@openmoko.org>
  * All rights reserved.
  *
  *  This program is free software; you can redistribute  it and/or modify it
@@ -28,7 +28,7 @@
 /* Two MBCS registers used during cold start */
 #define PCF50633_REG_MBCS1		0x4b
 #define PCF50633_REG_MBCS2		0x4c
-#define PCF50633_MBCS1_USBPRES 		0x01
+#define PCF50633_MBCS1_USBPRES		0x01
 #define PCF50633_MBCS1_ADAPTPRES	0x01
 
 static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
@@ -449,36 +449,84 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void
-pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
-						struct platform_device **pdev)
+static int pcf50633_regulator_dev_register(struct pcf50633 *pcf,
+					   unsigned int num)
 {
-	struct pcf50633_subdev_pdata *subdev_pdata;
-	int ret;
+	struct platform_device *pdev;
+	int error;
 
-	*pdev = platform_device_alloc(name, -1);
-	if (!*pdev) {
-		dev_err(pcf->dev, "Falied to allocate %s\n", name);
-		return;
+	pdev = platform_device_alloc("pcf50633-regltr", num);
+	if (!pdev) {
+		dev_err(pcf->dev,
+			"Not enough memory for regulator device %d\n", num);
+		return -ENOMEM;
 	}
 
-	subdev_pdata = kmalloc(sizeof(*subdev_pdata), GFP_KERNEL);
-	if (!subdev_pdata) {
-		dev_err(pcf->dev, "Error allocating subdev pdata\n");
-		platform_device_put(*pdev);
+	pdev->dev.parent = pcf->dev;
+	pdev->dev.platform_data = &pcf->pdata->reg_init_data[num];
+	platform_set_drvdata(pdev, pcf);
+
+	error = platform_device_add(pdev);
+	if (error) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n",
+			dev_name(&pdev->dev), error);
+		goto err_free_dev;
 	}
 
-	subdev_pdata->pcf = pcf;
-	platform_device_add_data(*pdev, subdev_pdata, sizeof(*subdev_pdata));
+	pcf->pdevs[num] = pdev;
+	return 0;
+
+ err_free_dev:
+	platform_device_put(pdev);
+	return error;
+}
 
-	(*pdev)->dev.parent = pcf->dev;
+static int pcf50633_client_dev_register(struct pcf50633 *pcf,
+					const char *name, unsigned int num)
+{
+	struct pcf50633_subdev_pdata subdev_pdata = { /* small enough to be on stack */
+		.pcf = pcf,
+	};
+	struct platform_device *pdev;
+	int error;
 
-	ret = platform_device_add(*pdev);
-	if (ret) {
-		dev_err(pcf->dev, "Failed to register %s: %d\n", name, ret);
-		platform_device_put(*pdev);
-		*pdev = NULL;
+	pdev = platform_device_alloc(name, -1);
+	if (!pdev) {
+		dev_err(pcf->dev, "Falied to allocate %s\n", name);
+		return -ENOMEM;
 	}
+
+	error = platform_device_add_data(pdev,
+					 &subdev_pdata, sizeof(subdev_pdata));
+	if (error) {
+		dev_err(pcf->dev, "Failed to add platform data for %s: %d\n",
+			name, error);
+		goto err_free_dev;
+	}
+
+	pdev->dev.parent = pcf->dev;
+
+	error = platform_device_add(pdev);
+	if (error) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n", name, error);
+		goto err_free_dev;
+	}
+
+	pcf->pdevs[num] = pdev;
+	return 0;
+
+ err_free_dev:
+	platform_device_put(pdev);
+	return error;
+}
+
+static void pcf50633_unregister_sub_devices(struct pcf50633 *pcf)
+{
+	int i;
+
+	for (i = 0; i < PCF50633_NUM_PLATFORM_DEVICES; i++)
+		if (pcf->pdevs[i])
+			platform_device_unregister(pcf->pdevs[i]);
 }
 
 #ifdef CONFIG_PM
@@ -560,9 +608,14 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 {
 	struct pcf50633 *pcf;
 	struct pcf50633_platform_data *pdata = client->dev.platform_data;
-	int i, ret = 0;
+	int i, error;
 	int version, variant;
 
+	if (client->irq) {
+		dev_err(&client->dev, "No IRQ configured\n");
+		return -EINVAL;
+	}
+
 	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
@@ -571,11 +624,16 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	mutex_init(&pcf->lock);
 
-	i2c_set_clientdata(client, pcf);
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
 	pcf->irq = client->irq;
+
 	pcf->work_queue = create_singlethread_workqueue("pcf50633");
+	if (!pcf->work_queue) {
+		dev_err(pcf->dev, "Failed to create workqueue\n");
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
 
 	INIT_WORK(&pcf->irq_work, pcf50633_irq_worker);
 
@@ -583,13 +641,12 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
-		ret = -ENODEV;
-		goto err;
+		error = -ENODEV;
+		goto err_destroy_wq;
 	}
 
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
 							version, variant);
-
 	/* Enable all interrupts except RTC SECOND */
 	pcf->mask_regs[0] = 0x80;
 	pcf50633_reg_write(pcf, PCF50633_REG_INT1M, pcf->mask_regs[0]);
@@ -599,80 +656,77 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
 	/* Create sub devices */
-	pcf50633_client_dev_register(pcf, "pcf50633-input",
-						&pcf->input_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
-						&pcf->rtc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
-						&pcf->mbc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-adc",
-						&pcf->adc_pdev);
+	error = pcf50633_client_dev_register(pcf, "pcf50633-input",
+						PCF50633_PDEV_INPUT_IDX);
+	if (error)
+		goto err_free_pdevs;
+
+	error = pcf50633_client_dev_register(pcf, "pcf50633-rtc",
+						PCF50633_PDEV_RTC_IDX);
+	if (error)
+		goto err_free_pdevs;
+
+	error = pcf50633_client_dev_register(pcf, "pcf50633-mbc",
+						PCF50633_PDEV_MBC_IDX);
+	if (error)
+		goto err_free_pdevs;
+
+	error = pcf50633_client_dev_register(pcf, "pcf50633-adc",
+						PCF50633_PDEV_ADC_IDX);
+	if (error)
+		goto err_free_pdevs;
 
 	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
-		struct platform_device *pdev;
-
-		pdev = platform_device_alloc("pcf50633-regltr", i);
-		if (!pdev) {
-			dev_err(pcf->dev, "Cannot create regulator\n");
-			continue;
-		}
-
-		pdev->dev.parent = pcf->dev;
-		pdev->dev.platform_data = &pdata->reg_init_data[i];
-		dev_set_drvdata(&pdev->dev, pcf);
-		pcf->regulator_pdev[i] = pdev;
-
-		platform_device_add(pdev);
+		error = pcf50633_regulator_dev_register(pcf, i);
+		if (error)
+			goto err_free_pdevs;
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
+	error = request_irq(client->irq, pcf50633_irq,
+			    IRQF_TRIGGER_LOW, "pcf50633", pcf);
+	if (error) {
+		dev_err(pcf->dev, "Failed to request IRQ %d\n", error);
+		goto err_free_pdevs;
 	}
 
 	if (enable_irq_wake(client->irq) < 0)
 		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
 			"in this hardware revision", client->irq);
 
-	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
-	if (ret)
+	error = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
+	if (error) {
 		dev_err(pcf->dev, "error creating sysfs entries\n");
+		goto err_free_irq;
+	}
 
 	if (pdata->probe_done)
 		pdata->probe_done(pcf);
 
+	i2c_set_clientdata(client, pcf);
 	return 0;
 
-err:
+err_free_irq:
+	free_irq(pcf->irq, pcf);
+err_free_pdevs:
+	pcf50633_unregister_sub_devices(pcf);
+err_destroy_wq:
 	destroy_workqueue(pcf->work_queue);
+err_free_mem:
 	kfree(pcf);
-	return ret;
+	return error;
 }
 
 static int __devexit pcf50633_remove(struct i2c_client *client)
 {
 	struct pcf50633 *pcf = i2c_get_clientdata(client);
-	int i;
+
 
 	free_irq(pcf->irq, pcf);
 	destroy_workqueue(pcf->work_queue);
 
-	platform_device_unregister(pcf->input_pdev);
-	platform_device_unregister(pcf->rtc_pdev);
-	platform_device_unregister(pcf->mbc_pdev);
-	platform_device_unregister(pcf->adc_pdev);
-
-	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
-		platform_device_unregister(pcf->regulator_pdev[i]);
+	pcf50633_unregister_sub_devices(pcf);
 
+	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
 
 	return 0;
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index e8b278f..8dbf3f1 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -42,7 +42,8 @@ struct pcf50633_mbc {
 
 int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
 {
-	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
+	struct pcf50633_mbc *mbc =
+		platform_get_drvdata(pcf->pdevs[PCF50633_PDEV_ADC_IDX]);
 	int ret = 0;
 	u8 bits;
 	int charging_start = 1;
@@ -90,7 +91,8 @@ EXPORT_SYMBOL_GPL(pcf50633_mbc_usb_curlim_set);
 
 int pcf50633_mbc_get_status(struct pcf50633 *pcf)
 {
-	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
+	struct pcf50633_mbc *mbc =
+		platform_get_drvdata(pcf->pdevs[PCF50633_PDEV_ADC_IDX]);
 	int status = 0;
 
 	if (mbc->usb_online)
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 9aba7b7..0c21222 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -128,6 +128,12 @@ enum {
 	PCF50633_NUM_IRQ,
 };
 
+#define PCF50633_PDEV_INPUT_IDX		(PCF50633_NUM_REGULATORS + 0)
+#define PCF50633_PDEV_RTC_IDX		(PCF50633_NUM_REGULATORS + 1)
+#define PCF50633_PDEV_MBC_IDX		(PCF50633_NUM_REGULATORS + 2)
+#define PCF50633_PDEV_ADC_IDX		(PCF50633_NUM_REGULATORS + 3)
+#define PCF50633_NUM_PLATFORM_DEVICES	(PCF50633_NUM_REGULATORS + 4)
+
 struct pcf50633 {
 	struct device *dev;
 	struct i2c_client *i2c_client;
@@ -147,11 +153,7 @@ struct pcf50633 {
 
 	int onkey1s_held;
 
-	struct platform_device *rtc_pdev;
-	struct platform_device *mbc_pdev;
-	struct platform_device *adc_pdev;
-	struct platform_device *input_pdev;
-	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
+	struct platform_device *pdevs[PCF50633_NUM_PLATFORM_DEVICES];
 };
 
 enum pcf50633_reg_int1 {

