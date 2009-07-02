Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZGBNwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZGBNwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbZGBNum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:50:42 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:43047 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbZGBNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:50:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: chrisv@cyberswitching.com, daniel@caiaq.de, iws@ovro.caltech.edu,
       dmitry.torokhov@gmail.com, hmh@hmh.eng.br, david-b@pacbell.net,
       khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 13/14] IIO: Proof of concept gpio trigger
Date: Thu,  2 Jul 2009 13:47:43 +0000
Message-Id: <1246542464-6974-14-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1246542464-6974-13-git-send-email-jic23@cam.ac.uk>
References: <1246542464-6974-1-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-2-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-3-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-4-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-5-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-6-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-7-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-8-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-9-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-10-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-11-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-12-git-send-email-jic23@cam.ac.uk>
 <1246542464-6974-13-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

Simple example of how a gpio trigger driver would work.
Things to be added include interupt type control (high, low).
---
 drivers/iio/trigger/Kconfig         |    6 +
 drivers/iio/trigger/Makefile        |    2 +-
 drivers/iio/trigger/iio-trig-gpio.c |  203 +++++++++++++++++++++++++++++++++++
 include/linux/iio/gpio_trigger.h    |    6 +
 4 files changed, 216 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iio/trigger/iio-trig-gpio.c
 create mode 100644 include/linux/iio/gpio_trigger.h

diff --git a/drivers/iio/trigger/Kconfig b/drivers/iio/trigger/Kconfig
index 0c73ccc..e7e1b6e 100644
--- a/drivers/iio/trigger/Kconfig
+++ b/drivers/iio/trigger/Kconfig
@@ -10,3 +10,9 @@ config IIO_PERIODIC_RTC_TRIGGER
 	help
 	    Provides support for using periodic capable real time
 	    clocks as IIO triggers.
+
+config IIO_GPIO_TRIGGER
+	tristate "GPIO trigger"
+	depends on IIO && IIO_TRIGGER && GENERIC_GPIO
+	help
+	    Provides support for using GPIO pins as IIO triggers.
\ No newline at end of file
diff --git a/drivers/iio/trigger/Makefile b/drivers/iio/trigger/Makefile
index 4ae55b9..e5f96d2 100644
--- a/drivers/iio/trigger/Makefile
+++ b/drivers/iio/trigger/Makefile
@@ -2,4 +2,4 @@
 # Makefile for triggers not associated with iio-devices
 #
 obj-$(CONFIG_IIO_PERIODIC_RTC_TRIGGER) += iio-trig-periodic-rtc.o
-
+obj-$(CONFIG_IIO_GPIO_TRIGGER) += iio-trig-gpio.o
\ No newline at end of file
diff --git a/drivers/iio/trigger/iio-trig-gpio.c b/drivers/iio/trigger/iio-trig-gpio.c
new file mode 100644
index 0000000..80c7a54
--- /dev/null
+++ b/drivers/iio/trigger/iio-trig-gpio.c
@@ -0,0 +1,203 @@
+/*
+ * Industrial I/O - gpio based trigger support
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Currently this is more of a functioning proof of concept that a fully
+ * fledged trigger driver.
+ *
+ * TODO:
+ *
+ * Add board config elements to allow specification of startup settings.
+ * Add configuration settings (irq type etc)
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/gpio_trigger.h>
+
+LIST_HEAD(iio_gpio_trigger_list);
+DEFINE_MUTEX(iio_gpio_trigger_list_lock);
+
+struct iio_gpio_trigger_info {
+	struct mutex in_use;
+	int gpio;
+};
+/*
+ * Need to reference count these triggers and only enable gpio interrupts
+ * as appropriate.
+ */
+
+/* So what functionality do we want in here?... */
+/* set high / low as interrupt type? */
+
+static irqreturn_t iio_gpio_trigger_poll(int irq, void *private)
+{
+	iio_trigger_poll(private);
+	return IRQ_HANDLED;
+}
+
+DEVICE_ATTR(name, S_IRUGO, iio_trigger_read_name, NULL);
+
+static struct attribute *iio_gpio_trigger_attrs[] = {
+	&dev_attr_name.attr,
+	NULL,
+};
+
+static const struct attribute_group iio_gpio_trigger_attr_group = {
+	.attrs = iio_gpio_trigger_attrs,
+};
+
+static int iio_gpio_trigger_probe(struct platform_device *dev)
+{
+	struct iio_gpio_trigger_pdata *pdata = dev->dev.platform_data;
+	struct iio_gpio_trigger_info *trig_info;
+	struct iio_trigger *trig, *trig2;
+	int i, irq, ret = 0;
+	if (!pdata) {
+		printk(KERN_ERR "No IIO gpio trigger platform data found\n");
+		goto error_ret;
+	}
+	for (i = 0; i < pdata->num_gpios; i++) {
+
+		trig = iio_allocate_trigger();
+		if (!trig) {
+			ret = -ENOMEM;
+			goto error_free_completed_registrations;
+		}
+
+		trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+		if (!trig_info) {
+			ret = -ENOMEM;
+			goto error_put_trigger;
+		}
+		trig->control_attrs = &iio_gpio_trigger_attr_group;
+		trig->private_data = trig_info;
+		trig_info->gpio = pdata->gpios[i];
+		trig->owner = THIS_MODULE;
+		trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
+		if (!trig->name) {
+			ret = -ENOMEM;
+			goto error_free_trig_info;
+		}
+		snprintf((char *)trig->name,
+			 IIO_TRIGGER_NAME_LENGTH,
+			 "gpiotrig%d",
+			 pdata->gpios[i]);
+		ret = gpio_request(trig_info->gpio, trig->name);
+		if (ret)
+			goto error_free_name;
+
+		ret = gpio_direction_input(trig_info->gpio);
+		if (ret)
+			goto error_release_gpio;
+
+		irq = gpio_to_irq(trig_info->gpio);
+		if (irq < 0) {
+			ret = irq;
+			goto error_release_gpio;
+		}
+
+		ret = request_irq(irq, iio_gpio_trigger_poll,
+				  IRQF_TRIGGER_RISING,
+				  trig->name,
+				  trig);
+		if (ret)
+			goto error_release_gpio;
+
+		ret = iio_trigger_register(trig);
+		if (ret)
+			goto error_release_irq;
+
+		list_add_tail(&trig->alloc_list, &iio_gpio_trigger_list);
+
+	}
+	return 0;
+
+/* First clean up the partly allocated trigger */
+error_release_irq:
+	free_irq(irq, trig);
+error_release_gpio:
+	gpio_free(trig_info->gpio);
+error_free_name:
+	kfree(trig->name);
+error_free_trig_info:
+	kfree(trig_info);
+error_put_trigger:
+	iio_put_trigger(trig);
+error_free_completed_registrations:
+	/* The rest should have been added to the iio_gpio_trigger_list */
+	list_for_each_entry_safe(trig,
+				 trig2,
+				 &iio_gpio_trigger_list,
+				 alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		free_irq(gpio_to_irq(trig_info->gpio), trig);
+		gpio_free(trig_info->gpio);
+		kfree(trig->name);
+		kfree(trig_info);
+		iio_put_trigger(trig);
+	}
+
+error_ret:
+	return ret;
+}
+
+static int iio_gpio_trigger_remove(struct platform_device *dev)
+{
+	struct iio_trigger *trig, *trig2;
+	struct iio_gpio_trigger_info *trig_info;
+
+	mutex_lock(&iio_gpio_trigger_list_lock);
+	list_for_each_entry_safe(trig,
+				 trig2,
+				 &iio_gpio_trigger_list,
+				 alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		free_irq(gpio_to_irq(trig_info->gpio), trig);
+		gpio_free(trig_info->gpio);
+		kfree(trig->name);
+		kfree(trig_info);
+		iio_put_trigger(trig);
+	}
+	mutex_unlock(&iio_gpio_trigger_list_lock);
+
+	return 0;
+}
+
+static struct platform_driver iio_gpio_trigger_driver = {
+	.probe = iio_gpio_trigger_probe,
+	.remove = iio_gpio_trigger_remove,
+	.driver = {
+		.name = "iio_gpio_trigger",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init iio_gpio_trig_init(void)
+{
+	return platform_driver_register(&iio_gpio_trigger_driver);
+}
+module_init(iio_gpio_trig_init);
+
+static void __exit iio_gpio_trig_exit(void)
+{
+	platform_driver_unregister(&iio_gpio_trigger_driver);
+}
+module_exit(iio_gpio_trig_exit);
+
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Example gpio trigger for the iio subsystem");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/iio/gpio_trigger.h b/include/linux/iio/gpio_trigger.h
new file mode 100644
index 0000000..25be3da
--- /dev/null
+++ b/include/linux/iio/gpio_trigger.h
@@ -0,0 +1,6 @@
+
+
+struct iio_gpio_trigger_pdata {
+	int num_gpios;
+	int *gpios;
+};
-- 
1.6.2

