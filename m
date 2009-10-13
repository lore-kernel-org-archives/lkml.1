Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbZJMWNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbZJMWNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761118AbZJMWNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:13:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:46808 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760930AbZJMWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TXw8NB9HHK5a3wKFFX8r6LQHOp1am9tsb5t940pAWuU3Nn1xhy5jX4X7nTqCD7q1+w
         yrtK38hAXFCGhJ1zh1J2FQpbMgRbdP7sNmjwjmttAUTGLes1cIfza1ZH1GpF5Id2o/b8
         U2q/q+DE1RiuvO2eCzPiGOHeuFyOnRtXje7VM=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 4/7] mfd: pcf50633: Fix memleak in pcf50633_client_dev_register
Date: Wed, 14 Oct 2009 02:12:33 +0400
Message-Id: <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Since platform_device_add_data copies the passed data, the allocated
subdev_pdata is never freed. A simple fix would be to either free subdev_pdata
or put it onto the stack. But since the pcf50633 child devices can rely on
beeing children of the pcf50633 core device it's much more elegant to get access
to pcf50633 core structure through that link. This allows to get completly rid
of pcf5033_subdev_pdata.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/input/misc/pcf50633-input.c |    7 +++----
 drivers/mfd/pcf50633-adc.c          |    5 ++---
 drivers/mfd/pcf50633-core.c         |   10 ----------
 drivers/power/pcf50633-charger.c    |    3 +--
 drivers/rtc/rtc-pcf50633.c          |    5 +----
 include/linux/mfd/pcf50633/core.h   |   10 +++++-----
 6 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
index 039dcb0..008de0c 100644
--- a/drivers/input/misc/pcf50633-input.c
+++ b/drivers/input/misc/pcf50633-input.c
@@ -55,7 +55,6 @@ pcf50633_input_irq(int irq, void *data)
 static int __devinit pcf50633_input_probe(struct platform_device *pdev)
 {
 	struct pcf50633_input *input;
-	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
 	struct input_dev *input_dev;
 	int ret;
 
@@ -71,7 +70,7 @@ static int __devinit pcf50633_input_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, input);
-	input->pcf = pdata->pcf;
+	input->pcf = dev_to_pcf50633(pdev->dev.parent);
 	input->input_dev = input_dev;
 
 	input_dev->name = "PCF50633 PMU events";
@@ -85,9 +84,9 @@ static int __devinit pcf50633_input_probe(struct platform_device *pdev)
 		kfree(input);
 		return ret;
 	}
-	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ONKEYR,
+	pcf50633_register_irq(input->pcf, PCF50633_IRQ_ONKEYR,
 				pcf50633_input_irq, input);
-	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ONKEYF,
+	pcf50633_register_irq(input->pcf, PCF50633_IRQ_ONKEYF,
 				pcf50633_input_irq, input);
 
 	return 0;
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 3d31e97..6d2e846 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -209,17 +209,16 @@ static void pcf50633_adc_irq(int irq, void *data)
 
 static int __devinit pcf50633_adc_probe(struct platform_device *pdev)
 {
-	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
 	struct pcf50633_adc *adc;
 
 	adc = kzalloc(sizeof(*adc), GFP_KERNEL);
 	if (!adc)
 		return -ENOMEM;
 
-	adc->pcf = pdata->pcf;
+	adc->pcf = dev_to_pcf50633(pdev->dev.parent);
 	platform_set_drvdata(pdev, adc);
 
-	pcf50633_register_irq(pdata->pcf, PCF50633_IRQ_ADCRDY,
+	pcf50633_register_irq(adc->pcf, PCF50633_IRQ_ADCRDY,
 					pcf50633_adc_irq, adc);
 
 	mutex_init(&adc->queue_mutex);
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 48776d3..69cdbdc 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -456,7 +456,6 @@ static void
 pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 						struct platform_device **pdev)
 {
-	struct pcf50633_subdev_pdata *subdev_pdata;
 	int ret;
 
 	*pdev = platform_device_alloc(name, -1);
@@ -465,15 +464,6 @@ pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 		return;
 	}
 
-	subdev_pdata = kmalloc(sizeof(*subdev_pdata), GFP_KERNEL);
-	if (!subdev_pdata) {
-		dev_err(pcf->dev, "Error allocating subdev pdata\n");
-		platform_device_put(*pdev);
-	}
-
-	subdev_pdata->pcf = pcf;
-	platform_device_add_data(*pdev, subdev_pdata, sizeof(*subdev_pdata));
-
 	(*pdev)->dev.parent = pcf->dev;
 
 	ret = platform_device_add(*pdev);
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index e8b278f..6a84a8e 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -303,7 +303,6 @@ static const u8 mbc_irq_handlers[] = {
 static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 {
 	struct pcf50633_mbc *mbc;
-	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
 	int ret;
 	int i;
 	u8 mbcs1;
@@ -313,7 +312,7 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, mbc);
-	mbc->pcf = pdata->pcf;
+	mbc->pcf = dev_to_pcf50633(pdev->dev.parent);
 
 	/* Set up IRQ handlers */
 	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index f4dd87e..0f045d7 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -276,16 +276,13 @@ static void pcf50633_rtc_irq(int irq, void *data)
 
 static int __devinit pcf50633_rtc_probe(struct platform_device *pdev)
 {
-	struct pcf50633_subdev_pdata *pdata;
 	struct pcf50633_rtc *rtc;
 
-
 	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
-	pdata = pdev->dev.platform_data;
-	rtc->pcf = pdata->pcf;
+	rtc->pcf = dev_to_pcf50633(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
 	rtc->rtc_dev = rtc_device_register("pcf50633-rtc", &pdev->dev,
 				&pcf50633_rtc_ops, THIS_MODULE);
diff --git a/include/linux/mfd/pcf50633/core.h b/include/linux/mfd/pcf50633/core.h
index 9aba7b7..d9034cc 100644
--- a/include/linux/mfd/pcf50633/core.h
+++ b/include/linux/mfd/pcf50633/core.h
@@ -40,10 +40,6 @@ struct pcf50633_platform_data {
 	u8 resumers[5];
 };
 
-struct pcf50633_subdev_pdata {
-	struct pcf50633 *pcf;
-};
-
 struct pcf50633_irq {
 	void (*handler) (int, void *);
 	void *data;
@@ -217,5 +213,9 @@ enum pcf50633_reg_int5 {
 #define PCF50633_REG_LEDCTL 0x2a
 #define PCF50633_REG_LEDDIM 0x2b
 
-#endif
+static inline struct pcf50633 *dev_to_pcf50633(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
 
+#endif
-- 
1.6.0.6

