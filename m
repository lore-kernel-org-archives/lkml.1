Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbZGBNv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbZGBNv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZGBNuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:50:37 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:42994 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027AbZGBNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:50:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: chrisv@cyberswitching.com, daniel@caiaq.de, iws@ovro.caltech.edu,
       dmitry.torokhov@gmail.com, hmh@hmh.eng.br, david-b@pacbell.net,
       khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 12/14] IIO: Periodic timer based trigger
Date: Thu,  2 Jul 2009 13:47:42 +0000
Message-Id: <1246542464-6974-13-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1246542464-6974-12-git-send-email-jic23@cam.ac.uk>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

The original posting of this driver led to a discussion in
which it was commented that a better system was needed
for dealing with the many possible periodic interrupt
sources available on some SoCs.  Unfortunately that is
a big task and as far as I know, no-one has taken it
on as yet.  So in the meantime this driver is still
in here.
---
 drivers/iio/Kconfig                         |    2 +
 drivers/iio/Makefile                        |    4 +-
 drivers/iio/trigger/Kconfig                 |   12 ++
 drivers/iio/trigger/Makefile                |    5 +
 drivers/iio/trigger/iio-trig-periodic-rtc.c |  230 +++++++++++++++++++++++++++
 include/linux/iio/prtc_trigger.h            |    7 +
 6 files changed, 259 insertions(+), 1 deletions(-)
 create mode 100644 drivers/iio/trigger/Kconfig
 create mode 100644 drivers/iio/trigger/Makefile
 create mode 100644 drivers/iio/trigger/iio-trig-periodic-rtc.c
 create mode 100644 include/linux/iio/prtc_trigger.h

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 936f954..3586984 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -38,3 +38,5 @@ config IIO_TRIGGER
 source drivers/iio/accel/Kconfig
 source drivers/iio/adc/Kconfig
 source drivers/iio/light/Kconfig
+
+source drivers/iio/trigger/Kconfig
\ No newline at end of file
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index dea4536..7ec0218 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -11,4 +11,6 @@ obj-$(CONFIG_IIO_SW_RING) += ring_sw.o
 
 obj-y += accel/
 obj-y += adc/
-obj-y += light/
\ No newline at end of file
+obj-y += light/
+
+obj-y += trigger/
\ No newline at end of file
diff --git a/drivers/iio/trigger/Kconfig b/drivers/iio/trigger/Kconfig
new file mode 100644
index 0000000..0c73ccc
--- /dev/null
+++ b/drivers/iio/trigger/Kconfig
@@ -0,0 +1,12 @@
+#
+# Industrial I/O standalone triggers
+#
+comment "Triggers - standalone"
+	depends on IIO
+
+config IIO_PERIODIC_RTC_TRIGGER
+	tristate "Periodic RTC triggers"
+	depends on IIO && IIO_TRIGGER && RTC_CLASS
+	help
+	    Provides support for using periodic capable real time
+	    clocks as IIO triggers.
diff --git a/drivers/iio/trigger/Makefile b/drivers/iio/trigger/Makefile
new file mode 100644
index 0000000..4ae55b9
--- /dev/null
+++ b/drivers/iio/trigger/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for triggers not associated with iio-devices
+#
+obj-$(CONFIG_IIO_PERIODIC_RTC_TRIGGER) += iio-trig-periodic-rtc.o
+
diff --git a/drivers/iio/trigger/iio-trig-periodic-rtc.c b/drivers/iio/trigger/iio-trig-periodic-rtc.c
new file mode 100644
index 0000000..feac4f3
--- /dev/null
+++ b/drivers/iio/trigger/iio-trig-periodic-rtc.c
@@ -0,0 +1,230 @@
+/* The industrial I/O periodic RTC trigger driver
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This is a heavily rewritten version of the periodic timer system in
+ * earlier version of industrialio.  It supplies the same functionality
+ * but via a trigger rather than a specific periodic timer system.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/prtc_trigger.h>
+
+LIST_HEAD(iio_prtc_trigger_list);
+DEFINE_MUTEX(iio_prtc_trigger_list_lock);
+
+struct iio_prtc_trigger_info {
+	struct rtc_device *rtc;
+	int frequency;
+	char *name;
+	struct rtc_task task;
+};
+
+static int iio_trig_periodic_rtc_set_state(struct iio_trigger *trig, bool state)
+{
+	struct iio_prtc_trigger_info *trig_info = trig->private_data;
+	if (trig_info->frequency == 0)
+		return -EINVAL;
+	printk(KERN_INFO "trigger frequency is %d\n", trig_info->frequency);
+	return rtc_irq_set_state(trig_info->rtc, &trig_info->task, state);
+}
+
+static ssize_t iio_trig_periodic_read_freq(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct iio_trigger *trig = dev_get_drvdata(dev);
+	struct iio_prtc_trigger_info *trig_info = trig->private_data;
+	return sprintf(buf, "%u\n", trig_info->frequency);
+}
+
+static ssize_t iio_trig_periodic_write_freq(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf,
+					    size_t len)
+{
+	struct iio_trigger *trig = dev_get_drvdata(dev);
+	struct iio_prtc_trigger_info *trig_info = trig->private_data;
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		goto error_ret;
+
+	ret = rtc_irq_set_freq(trig_info->rtc, &trig_info->task, val);
+	if (ret)
+		goto error_ret;
+
+	trig_info->frequency = val;
+
+	return len;
+
+error_ret:
+	return ret;
+}
+
+static ssize_t iio_trig_periodic_read_name(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct iio_trigger *trig = dev_get_drvdata(dev);
+	struct iio_prtc_trigger_info *trig_info = trig->private_data;
+	return sprintf(buf, "%s\n", trig_info->name);
+}
+
+DEVICE_ATTR(name, S_IRUGO,
+	    iio_trig_periodic_read_name,
+	    NULL);
+DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
+	    iio_trig_periodic_read_freq,
+	    iio_trig_periodic_write_freq);
+
+static struct attribute *iio_trig_prtc_attrs[] = {
+	&dev_attr_frequency.attr,
+	&dev_attr_name.attr,
+	NULL,
+};
+static const struct attribute_group iio_trig_prtc_attr_group = {
+	.attrs = iio_trig_prtc_attrs,
+};
+
+static void iio_prtc_trigger_poll(void *private_data)
+{
+	iio_trigger_poll(private_data);
+}
+
+
+
+static int iio_trig_periodic_rtc_probe(struct platform_device *dev)
+{
+	struct iio_prtc_trigger_group *pdata = dev->dev.platform_data;
+	struct iio_prtc_trigger_info *trig_info;
+	struct iio_trigger *trig, *trig2;
+
+	int i, ret;
+	for (i = 0; i < pdata->num_triggers; i++) {
+		trig = iio_allocate_trigger();
+		if (!trig) {
+			ret = -ENOMEM;
+			goto error_free_completed_registrations;
+		}
+		list_add(&trig->alloc_list, &iio_prtc_trigger_list);
+
+		trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+		if (!trig_info) {
+			ret = -ENOMEM;
+			goto error_put_trigger_and_remove_from_list;
+		}
+		trig->private_data = trig_info;
+		trig->owner = THIS_MODULE;
+		trig->set_trigger_state = &iio_trig_periodic_rtc_set_state;
+		trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
+		if (trig->name == NULL) {
+			ret = -ENOMEM;
+			goto error_free_trig_info;
+		}
+		snprintf((char *)trig->name,
+			 IIO_TRIGGER_NAME_LENGTH,
+			 "periodic%s",
+			 pdata->triggers[i].name);
+		trig_info->name = (char *)trig->name;
+		/* RTC access */
+		trig_info->rtc
+			= rtc_class_open((char *)(pdata->triggers[i].name));
+		if (trig_info->rtc == NULL) {
+			ret = -EINVAL;
+			goto error_free_name;
+		}
+		trig_info->task.func = iio_prtc_trigger_poll;
+		trig_info->task.private_data = trig;
+		ret = rtc_irq_register(trig_info->rtc, &trig_info->task);
+		if (ret)
+			goto error_close_rtc;
+		trig->control_attrs = &iio_trig_prtc_attr_group;
+		ret = iio_trigger_register(trig);
+		if (ret)
+			goto error_unregister_rtc_irq;
+	}
+	return 0;
+error_unregister_rtc_irq:
+	rtc_irq_unregister(trig_info->rtc, &trig_info->task);
+error_close_rtc:
+	rtc_class_close(trig_info->rtc);
+error_free_name:
+	kfree(trig->name);
+error_free_trig_info:
+	kfree(trig_info);
+error_put_trigger_and_remove_from_list:
+	list_del(&trig->alloc_list);
+	iio_put_trigger(trig);
+error_free_completed_registrations:
+	list_for_each_entry_safe(trig,
+				 trig2,
+				 &iio_prtc_trigger_list,
+				 alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		rtc_irq_unregister(trig_info->rtc, &trig_info->task);
+		rtc_class_close(trig_info->rtc);
+		kfree(trig->name);
+		kfree(trig_info);
+		iio_put_trigger(trig);
+	}
+	return ret;
+}
+
+static int iio_trig_periodic_rtc_remove(struct platform_device *dev)
+{
+	struct iio_trigger *trig, *trig2;
+	struct iio_prtc_trigger_info *trig_info;
+	mutex_lock(&iio_prtc_trigger_list_lock);
+	list_for_each_entry_safe(trig,
+				 trig2,
+				 &iio_prtc_trigger_list,
+				 alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		rtc_irq_unregister(trig_info->rtc, &trig_info->task);
+		rtc_class_close(trig_info->rtc);
+		kfree(trig->name);
+		kfree(trig_info);
+		iio_put_trigger(trig);
+	}
+	mutex_unlock(&iio_prtc_trigger_list_lock);
+	return 0;
+}
+
+static struct platform_driver iio_trig_periodic_rtc_driver = {
+	.probe = iio_trig_periodic_rtc_probe,
+	.remove = iio_trig_periodic_rtc_remove,
+	.driver = {
+		.name = "iio_prtc_trigger",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init iio_trig_periodic_rtc_init(void)
+{
+	return platform_driver_register(&iio_trig_periodic_rtc_driver);
+}
+
+static void __exit iio_trig_periodic_rtc_exit(void)
+{
+	return platform_driver_unregister(&iio_trig_periodic_rtc_driver);
+}
+
+module_init(iio_trig_periodic_rtc_init);
+module_exit(iio_trig_periodic_rtc_exit);
+MODULE_AUTHOR("Jonathan Cameron <jic23@cam.ac.uk>");
+MODULE_DESCRIPTION("Periodic realtime clock  trigger for the iio subsystem");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/iio/prtc_trigger.h b/include/linux/iio/prtc_trigger.h
new file mode 100644
index 0000000..9dabc19
--- /dev/null
+++ b/include/linux/iio/prtc_trigger.h
@@ -0,0 +1,7 @@
+struct iio_prtc_trigger {
+	const char *name;
+};
+struct iio_prtc_trigger_group {
+	int num_triggers;
+	struct iio_prtc_trigger *triggers;
+};
-- 
1.6.2

