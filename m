Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbZKPGJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbZKPGJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 01:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbZKPGI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 01:08:59 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33236 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZKPGI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 01:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=uNYVxhcWLXVhhvmk1AbVi0atJHQxROw0x0GqyZ5aGob3Y7D+zEbRPqCLGBMhEhdBwL
         FfSGlj/rjq4eOUTMI9nmU+tA00QlYzC5pI1S70+qMiYQfOmafPlhkhqVZyfGWraAs3FD
         AG+h2dc28zaR2/ba5oD5sxkifWCK+DW/+3smU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4/5] mfd: pcf50633 - fix error handling during probe
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
       Balaji Rao <balajirrao@openmoko.org>
Date: Sun, 15 Nov 2009 22:08:59 -0800
Message-ID: <20091116060859.20162.49497.stgit@localhost.localdomain>
In-Reply-To: <20091116060611.20162.81714.stgit@localhost.localdomain>
References: <20091116060611.20162.81714.stgit@localhost.localdomain>
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

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/mfd/pcf50633-adc.c        |    2 -
 drivers/mfd/pcf50633-core.c       |  124 +++++++++++++++++++++++--------------
 drivers/power/pcf50633-charger.c  |    6 +-
 include/linux/mfd/pcf50633/core.h |   12 ++--
 4 files changed, 90 insertions(+), 54 deletions(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 6d2e846..d86e7b0 100644
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
index 474a76c..2126563 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -469,7 +469,7 @@ static int pcf50633_regulator_dev_register(struct pcf50633 *pcf,
 		goto err_free_dev;
 	}
 
-	pcf->regulator_pdev[num] = pdev;
+	pcf->pdevs[num] = pdev;
 	return 0;
 
  err_free_dev:
@@ -477,26 +477,47 @@ static int pcf50633_regulator_dev_register(struct pcf50633 *pcf,
 	return error;
 }
 
-static void
-pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
-						struct platform_device **pdev)
+static int pcf50633_client_dev_register(struct pcf50633 *pcf,
+					const char *name, unsigned int num)
 {
-	int ret;
+	struct platform_device *pdev;
+	int error;
 
-	*pdev = platform_device_alloc(name, -1);
-	if (!*pdev) {
+	pdev = platform_device_alloc(name, -1);
+	if (!pdev) {
 		dev_err(pcf->dev, "Falied to allocate %s\n", name);
-		return;
+		return -ENOMEM;
 	}
 
-	(*pdev)->dev.parent = pcf->dev;
+	pdev->dev.parent = pcf->dev;
 
-	ret = platform_device_add(*pdev);
-	if (ret) {
-		dev_err(pcf->dev, "Failed to register %s: %d\n", name, ret);
-		platform_device_put(*pdev);
-		*pdev = NULL;
+	/*
+	 * We reference these platform devices from sub-drivers so they
+	 * need to be set up before registering device.
+	 */
+	pcf->pdevs[num] = pdev;
+
+	error = platform_device_add(pdev);
+	if (error) {
+		dev_err(pcf->dev, "Failed to register %s: %d\n", name, error);
+		goto err_free_dev;
 	}
+
+	return 0;
+
+ err_free_dev:
+	platform_device_put(pdev);
+	pcf->pdevs[num] = pdev;
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
@@ -569,7 +590,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 {
 	struct pcf50633 *pcf;
 	struct pcf50633_platform_data *pdata = client->dev.platform_data;
-	int i, ret;
+	int i, error;
 	int version, variant;
 
 	if (!client->irq) {
@@ -585,7 +606,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 	mutex_init(&pcf->lock);
 
-	i2c_set_clientdata(client, pcf);
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
 	pcf->irq = client->irq;
@@ -594,7 +614,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	variant = pcf50633_reg_read(pcf, 1);
 	if (version < 0 || variant < 0) {
 		dev_err(pcf->dev, "Unable to probe pcf50633\n");
-		ret = -ENODEV;
+		error = -ENODEV;
 		goto err_free;
 	}
 
@@ -609,62 +629,74 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
 	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
 
-	ret = request_threaded_irq(client->irq, NULL, pcf50633_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   "pcf50633", pcf);
-	if (ret) {
-		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+	error = request_threaded_irq(client->irq, NULL, pcf50633_irq,
+				     IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				     "pcf50633", pcf);
+	if (error) {
+		dev_err(pcf->dev, "Failed to request IRQ %d\n", error);
 		goto err_free;
 	}
 
 	/* Create sub devices */
-	pcf50633_client_dev_register(pcf, "pcf50633-input",
-						&pcf->input_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-rtc",
-						&pcf->rtc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-mbc",
-						&pcf->mbc_pdev);
-	pcf50633_client_dev_register(pcf, "pcf50633-adc",
-						&pcf->adc_pdev);
-
-	for (i = 0; i < PCF50633_NUM_REGULATORS; i++)
-		pcf50633_regulator_dev_register(pcf, i);
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
+
+	for (i = 0; i < PCF50633_NUM_REGULATORS; i++) {
+		error = pcf50633_regulator_dev_register(pcf, i);
+		if (error)
+			goto err_free_pdevs;
+	}
 
 	if (enable_irq_wake(client->irq) < 0)
 		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
 			"in this hardware revision", client->irq);
 
-	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
-	if (ret)
+	error = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
+	if (error) {
 		dev_err(pcf->dev, "error creating sysfs entries\n");
+		goto err_free_pdevs;
+	}
 
 	if (pdata->probe_done)
 		pdata->probe_done(pcf);
 
+	i2c_set_clientdata(client, pcf);
 	return 0;
 
+err_free_pdevs:
+	pcf50633_unregister_sub_devices(pcf);
+	free_irq(pcf->irq, pcf);
 err_free:
-	i2c_set_clientdata(client, NULL);
 	kfree(pcf);
-
-	return ret;
+	return error;
 }
 
 static int __devexit pcf50633_remove(struct i2c_client *client)
 {
 	struct pcf50633 *pcf = i2c_get_clientdata(client);
-	int i;
 
 	free_irq(pcf->irq, pcf);
 
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
index 6a84a8e..02e1183 100644
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
index fef4bda..b8e7eed 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -124,6 +124,12 @@ enum {
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
@@ -141,11 +147,7 @@ struct pcf50633 {
 
 	int onkey1s_held;
 
-	struct platform_device *rtc_pdev;
-	struct platform_device *mbc_pdev;
-	struct platform_device *adc_pdev;
-	struct platform_device *input_pdev;
-	struct platform_device *regulator_pdev[PCF50633_NUM_REGULATORS];
+	struct platform_device *pdevs[PCF50633_NUM_PLATFORM_DEVICES];
 };
 
 enum pcf50633_reg_int1 {

