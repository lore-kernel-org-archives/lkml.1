Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYLAOcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYLAOcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYLAOcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:32:23 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:35053 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYLAOcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:32:22 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F574.70604@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:32:20 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [6/13] RFC: Proof of concept GPIO based IIO trigger
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Proof of concept GPIO based IIO trigger

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--

A very limited trigger driver using a GPIO to provide synchronization
with external devices. Things like setting polarity and interrupt
types will need to be added to make this more useful.

 drivers/industrialio/triggers/Kconfig         |   12 ++
 drivers/industrialio/triggers/Makefile        |    5 +-
 drivers/industrialio/triggers/iio-trig-gpio.c |  193 +++++++++++++++++++++++++
 include/linux/industrialio/gpio_trigger.h     |    6 +
 4 files changed, 215 insertions(+), 1 deletions(-)

diff --git a/drivers/industrialio/triggers/Kconfig b/drivers/industrialio/triggers/Kconfig
index 20e6498..e100098 100644
--- a/drivers/industrialio/triggers/Kconfig
+++ b/drivers/industrialio/triggers/Kconfig
@@ -1,6 +1,18 @@
+config IIO_GPIO_TRIGGER
+       tristate "GPIO triggers"
+          depends on INDUSTRIALIO && IIO_TRIGGERS && GENERIC_GPIO
+	  help
+	    Driver provides support for using GPIOs as the IIO
+	    triggers.
+
 config IIO_PERIODIC_RTC_TRIGGER
        tristate "Periodic RTC triggers"
           depends on INDUSTRIALIO && IIO_TRIGGERS && RTC_CLASS
 	  help
 	    Provides support for using periodic capable real time
 	    clocks as IIO triggers.

diff --git a/drivers/industrialio/triggers/Makefile b/drivers/industrialio/triggers/Makefile
index 4ae55b9..767d2cd 100644
--- a/drivers/industrialio/triggers/Makefile
+++ b/drivers/industrialio/triggers/Makefile
@@ -1,5 +1,8 @@
 #
 # Makefile for triggers not associated with iio-devices
 #
-obj-$(CONFIG_IIO_PERIODIC_RTC_TRIGGER) += iio-trig-periodic-rtc.o
 
+obj-$(CONFIG_IIO_GPIO_TRIGGER) += iio-trig-gpio.o
+
+obj-$(CONFIG_IIO_PERIODIC_RTC_TRIGGER) += iio-trig-periodic-rtc.o
+#obj-$(CONFIG_IIO_PTIMER_BOARDINFO) += iio-ptimer-boardinfo.o
diff --git a/drivers/industrialio/triggers/iio-trig-gpio.c b/drivers/industrialio/triggers/iio-trig-gpio.c
new file mode 100644
index 0000000..9718779
--- /dev/null
+++ b/drivers/industrialio/triggers/iio-trig-gpio.c
@@ -0,0 +1,193 @@
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
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/trigger.h>
+#include <linux/industrialio/gpio_trigger.h>
+
+LIST_HEAD(iio_gpio_trigger_list);
+DEFINE_MUTEX(iio_gpio_trigger_list_lock);
+
+struct iio_gpio_trigger_info {
+	struct mutex in_use;
+	int gpio;
+};
+/* Need to reference count these triggers and only enable gpio interrupts as appropriate.*/
+
+/* So what functionality do we want in here?... */
+/* set high / low as interrupt type? */
+
+static irqreturn_t iio_gpio_trigger_poll(int irq, void *private)
+{
+	//private at this stage is the iio_trig.
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
+		return -EINVAL;
+	}
+	for (i = 0; i < pdata->num_gpios; i++) {
+
+		trig = kzalloc(sizeof(*trig), GFP_KERNEL);
+		if (!trig) {
+			ret = -ENOMEM;
+			goto error_free_trigs_1;
+		}
+		iio_trigger_init(trig);
+
+		trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+		if (!trig_info) {
+			ret = -ENOMEM;
+			goto error_free_trigs_2;
+		}
+		trig->control_attrs = &iio_gpio_trigger_attr_group;
+		trig->private_data = trig_info;
+		trig_info->gpio = pdata->gpios[i];
+		trig->owner = THIS_MODULE;
+		trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
+		snprintf((char *)trig->name, IIO_TRIGGER_NAME_LENGTH, "gpiotrig%d", pdata->gpios[i]);
+
+
+		ret = gpio_request(trig_info->gpio, trig->name);
+		if (ret)
+			goto error_free_trigs_3;
+
+		ret = gpio_direction_input(trig_info->gpio);
+		if (ret)
+			goto error_free_trigs_4;
+
+		irq = gpio_to_irq(trig_info->gpio);
+		if (irq < 0)
+			goto error_free_trigs_4;
+
+		ret = request_irq(irq, iio_gpio_trigger_poll,
+				  IRQF_TRIGGER_RISING,
+				  trig->name,
+				  trig);
+		if (ret)
+			goto error_free_trigs_4;
+		ret = iio_trigger_register(trig, &dev->dev, i);
+
+		if (ret)
+			goto error_free_trigs_5;
+
+		mutex_lock(&iio_gpio_trigger_list_lock);
+		list_add_tail(&trig->alloc_list, &iio_gpio_trigger_list);
+		mutex_unlock(&iio_gpio_trigger_list_lock);
+	}
+	return 0;
+
+/* First clean up the partly allocated trigger */
+error_free_trigs_5:
+	free_irq(irq, trig);
+
+error_free_trigs_4:
+	gpio_free(trig_info->gpio);
+error_free_trigs_3:
+	kfree(trig->name);
+error_free_trigs_2:
+	kfree(trig_info);
+error_free_trigs_1:
+/* The rest should have been added to the iio_gpio_trigger_list */
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
+		kfree(trig);
+	}
+	mutex_unlock(&iio_gpio_trigger_list_lock);
+
+	return ret;
+}
+
+static int iio_gpio_trigger_remove(struct platform_device *dev)
+{
+	struct iio_trigger *trig, *trig2;
+	struct iio_gpio_trigger_info *trig_info;
+
+	mutex_lock(&iio_gpio_trigger_list_lock);
+	list_for_each_entry_safe(trig, trig2, &iio_gpio_trigger_list, alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		free_irq(gpio_to_irq(trig_info->gpio), trig);
+		gpio_free(trig_info->gpio);
+		kfree(trig->name);
+		kfree(trig_info);
+		kfree(trig);
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
diff --git a/include/linux/industrialio/gpio_trigger.h b/include/linux/industrialio/gpio_trigger.h
new file mode 100644
index 0000000..25be3da
--- /dev/null
+++ b/include/linux/industrialio/gpio_trigger.h
@@ -0,0 +1,6 @@
+
+
+struct iio_gpio_trigger_pdata {
+	int num_gpios;
+	int *gpios;
+};
