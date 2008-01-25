Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYAYHVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYAYHVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYAYHPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:52505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbYAYHPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:20 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Russell King <rmk@arm.linux.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 023/196] MCP_UCB1200: Convert from class_device to device
Date: Thu, 24 Jan 2008 23:09:21 -0800
Message-Id: <1201245134-4876-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

struct class_device is going away, this converts the code to use struct
device instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mfd/ucb1x00-assabet.c |   17 +++++++++--------
 drivers/mfd/ucb1x00-core.c    |   14 +++++++-------
 drivers/mfd/ucb1x00.h         |    4 ++--
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/ucb1x00-assabet.c b/drivers/mfd/ucb1x00-assabet.c
index e325fa7..b7c8e78 100644
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
@@ -29,7 +30,7 @@ static ssize_t name##_show(struct class_device *dev, char *buf)	\
 	ucb1x00_adc_disable(ucb);				\
 	return sprintf(buf, "%d\n", val);			\
 }								\
-static CLASS_DEVICE_ATTR(name,0444,name##_show,NULL)
+static DEVICE_ATTR(name,0444,name##_show,NULL)
 
 UCB1X00_ATTR(vbatt, UCB_ADC_INP_AD1);
 UCB1X00_ATTR(vcharger, UCB_ADC_INP_AD0);
@@ -37,17 +38,17 @@ UCB1X00_ATTR(batt_temp, UCB_ADC_INP_AD2);
 
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
diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index e03f1bc..f6b10dd 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -458,7 +458,7 @@ static int ucb1x00_detect_irq(struct ucb1x00 *ucb)
 	return probe_irq_off(mask);
 }
 
-static void ucb1x00_release(struct class_device *dev)
+static void ucb1x00_release(struct device *dev)
 {
 	struct ucb1x00 *ucb = classdev_to_ucb1x00(dev);
 	kfree(ucb);
@@ -466,7 +466,7 @@ static void ucb1x00_release(struct class_device *dev)
 
 static struct class ucb1x00_class = {
 	.name		= "ucb1x00",
-	.release	= ucb1x00_release,
+	.dev_release	= ucb1x00_release,
 };
 
 static int ucb1x00_probe(struct mcp *mcp)
@@ -490,9 +490,9 @@ static int ucb1x00_probe(struct mcp *mcp)
 		goto err_disable;
 
 
-	ucb->cdev.class = &ucb1x00_class;
-	ucb->cdev.dev = &mcp->attached_device;
-	strlcpy(ucb->cdev.class_id, "ucb1x00", sizeof(ucb->cdev.class_id));
+	ucb->dev.class = &ucb1x00_class;
+	ucb->dev.parent = &mcp->attached_device;
+	strlcpy(ucb->dev.bus_id, "ucb1x00", sizeof(ucb->dev.bus_id));
 
 	spin_lock_init(&ucb->lock);
 	spin_lock_init(&ucb->io_lock);
@@ -517,7 +517,7 @@ static int ucb1x00_probe(struct mcp *mcp)
 
 	mcp_set_drvdata(mcp, ucb);
 
-	ret = class_device_register(&ucb->cdev);
+	ret = device_register(&ucb->dev);
 	if (ret)
 		goto err_irq;
 
@@ -554,7 +554,7 @@ static void ucb1x00_remove(struct mcp *mcp)
 	mutex_unlock(&ucb1x00_mutex);
 
 	free_irq(ucb->irq, ucb);
-	class_device_unregister(&ucb->cdev);
+	device_unregister(&ucb->dev);
 }
 
 int ucb1x00_register_driver(struct ucb1x00_driver *drv)
diff --git a/drivers/mfd/ucb1x00.h b/drivers/mfd/ucb1x00.h
index ca8df80..a8ad8a0 100644
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
1.5.3.8

