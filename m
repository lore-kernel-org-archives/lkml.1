Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbXHTW5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbXHTW5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbXHTWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:53:19 -0400
Received: from mx1.suse.de ([195.135.220.2]:60214 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761486AbXHTWxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:53:17 -0400
Message-Id: <20070820225140.739434000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:19 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: rmk@arm.linux.org.uk, kay.sievers@vrfy.org
Subject: [patch 13/14] Convert from class_device to device for UCB1x00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=mfd.patch

Convert from class_device to device for drivers/mfd/ucb1x00.  This is
part of the work to eliminate struct class_device.

---
 drivers/mfd/ucb1x00-assabet.c |   17 +++++++++--------
 drivers/mfd/ucb1x00-core.c    |   14 +++++++-------
 drivers/mfd/ucb1x00.h         |    4 ++--
 3 files changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/mfd/ucb1x00-assabet.c
+++ b/drivers/mfd/ucb1x00-assabet.c
@@ -20,7 +20,8 @@
 #include "ucb1x00.h"
 
 #define UCB1X00_ATTR(name,input)\
-static ssize_t name##_show(struct class_device *dev, char *buf)	\
+static ssize_t name##_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)	\
 {								\
 	struct ucb1x00 *ucb = classdev_to_ucb1x00(dev);		\
 	int val;						\
@@ -29,7 +30,7 @@ static ssize_t name##_show(struct class_
 	ucb1x00_adc_disable(ucb);				\
 	return sprintf(buf, "%d\n", val);			\
 }								\
-static CLASS_DEVICE_ATTR(name,0444,name##_show,NULL)
+static DEVICE_ATTR(name,0444,name##_show,NULL)
 
 UCB1X00_ATTR(vbatt, UCB_ADC_INP_AD1);
 UCB1X00_ATTR(vcharger, UCB_ADC_INP_AD0);
@@ -37,17 +38,17 @@ UCB1X00_ATTR(batt_temp, UCB_ADC_INP_AD2)
 
 static int ucb1x00_assabet_add(struct ucb1x00_dev *dev)
 {
-	class_device_create_file(&dev->ucb->cdev, &class_device_attr_vbatt);
-	class_device_create_file(&dev->ucb->cdev, &class_device_attr_vcharger);
-	class_device_create_file(&dev->ucb->cdev, &class_device_attr_batt_temp);
+	device_create_file(&dev->ucb->dev, &device_attr_vbatt);
+	device_create_file(&dev->ucb->dev, &device_attr_vcharger);
+	device_create_file(&dev->ucb->dev, &device_attr_batt_temp);
 	return 0;
 }
 
 static void ucb1x00_assabet_remove(struct ucb1x00_dev *dev)
 {
-	class_device_remove_file(&dev->ucb->cdev, &class_device_attr_batt_temp);
-	class_device_remove_file(&dev->ucb->cdev, &class_device_attr_vcharger);
-	class_device_remove_file(&dev->ucb->cdev, &class_device_attr_vbatt);
+	device_remove_file(&dev->ucb->cdev, &device_attr_batt_temp);
+	device_remove_file(&dev->ucb->cdev, &device_attr_vcharger);
+	device_remove_file(&dev->ucb->cdev, &device_attr_vbatt);
 }
 
 static struct ucb1x00_driver ucb1x00_assabet_driver = {
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -458,7 +458,7 @@ static int ucb1x00_detect_irq(struct ucb
 	return probe_irq_off(mask);
 }
 
-static void ucb1x00_release(struct class_device *dev)
+static void ucb1x00_release(struct device *dev)
 {
 	struct ucb1x00 *ucb = classdev_to_ucb1x00(dev);
 	kfree(ucb);
@@ -466,7 +466,7 @@ static void ucb1x00_release(struct class
 
 static struct class ucb1x00_class = {
 	.name		= "ucb1x00",
-	.release	= ucb1x00_release,
+	.dev_release	= ucb1x00_release,
 };
 
 static int ucb1x00_probe(struct mcp *mcp)
@@ -490,9 +490,9 @@ static int ucb1x00_probe(struct mcp *mcp
 		goto err_disable;
 
 
-	ucb->cdev.class = &ucb1x00_class;
-	ucb->cdev.dev = &mcp->attached_device;
-	strlcpy(ucb->cdev.class_id, "ucb1x00", sizeof(ucb->cdev.class_id));
+	ucb->dev.class = &ucb1x00_class;
+	ucb->dev.parent = &mcp->attached_device;
+	strlcpy(ucb->dev.bus_id, "ucb1x00", sizeof(ucb->dev.bus_id));
 
 	spin_lock_init(&ucb->lock);
 	spin_lock_init(&ucb->io_lock);
@@ -517,7 +517,7 @@ static int ucb1x00_probe(struct mcp *mcp
 
 	mcp_set_drvdata(mcp, ucb);
 
-	ret = class_device_register(&ucb->cdev);
+	ret = device_register(&ucb->dev);
 	if (ret)
 		goto err_irq;
 
@@ -554,7 +554,7 @@ static void ucb1x00_remove(struct mcp *m
 	mutex_unlock(&ucb1x00_mutex);
 
 	free_irq(ucb->irq, ucb);
-	class_device_unregister(&ucb->cdev);
+	device_unregister(&ucb->dev);
 }
 
 int ucb1x00_register_driver(struct ucb1x00_driver *drv)
--- a/drivers/mfd/ucb1x00.h
+++ b/drivers/mfd/ucb1x00.h
@@ -120,7 +120,7 @@ struct ucb1x00 {
 	u16			irq_fal_enbl;
 	u16			irq_ris_enbl;
 	struct ucb1x00_irq	irq_handler[16];
-	struct class_device	cdev;
+	struct device		dev;
 	struct list_head	node;
 	struct list_head	devs;
 };
@@ -144,7 +144,7 @@ struct ucb1x00_driver {
 	int	(*resume)(struct ucb1x00_dev *dev);
 };
 
-#define classdev_to_ucb1x00(cd)	container_of(cd, struct ucb1x00, cdev)
+#define classdev_to_ucb1x00(cd)	container_of(cd, struct ucb1x00, dev)
 
 int ucb1x00_register_driver(struct ucb1x00_driver *);
 void ucb1x00_unregister_driver(struct ucb1x00_driver *);

-- 
