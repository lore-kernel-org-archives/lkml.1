Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYLAOaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYLAOaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYLAOao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:30:44 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:51991 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYLAOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:30:43 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F511.4060305@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:30:41 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [5/13] RFC: IIO Periodic real time clock based trigger.
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Periodic real time clock based trigger.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
--

Quite a few real time clock implementations provide configurable
periodic interrupts.  This module allows these to be used as triggers
for filling IIO ring buffers at regular intervals.

As has been discussed a number of times on LKML and elsewhere, it
would be nice to have a generic timer system to handle the many
timers that are available and make use of their periodic capabilities.
Until this is available the RTC subsystem provides the easiest way
of doing this.

Whilst this is in of itself a useful implementation, the principal
reason for including it here is to illustrate how IIO trigger drivers
work.

 drivers/industrialio/Kconfig                       |    2 +
 drivers/industrialio/Makefile                      |    2 +
 drivers/industrialio/triggers/Kconfig              |    6 +
 drivers/industrialio/triggers/Makefile             |    5 +
 .../industrialio/triggers/iio-trig-periodic-rtc.c  |  197 ++++++++++++++++++++
 include/linux/industrialio/prtc_trigger.h          |    7 +
 6 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/drivers/industrialio/Kconfig b/drivers/industrialio/Kconfig
index 9bf6a36..c20ca2f 100644
--- a/drivers/industrialio/Kconfig
+++ b/drivers/industrialio/Kconfig
@@ -19,6 +19,8 @@ config IIO_TRIGGERS
 	   ring buffers.  The triggers are effectively a 'capture
 	   data now' interrupt.
 
+source drivers/industrialio/triggers/Kconfig
+
 config IIO_RING_BUFFER
        bool "Enable ring buffer support within iio"
 	  depends on INDUSTRIALIO
diff --git a/drivers/industrialio/Makefile b/drivers/industrialio/Makefile
index 15ef75f..518849a 100644
--- a/drivers/industrialio/Makefile
+++ b/drivers/industrialio/Makefile
@@ -8,3 +8,5 @@ industrialio-$(CONFIG_IIO_RING_BUFFER) += industrialio-ring.o
 industrialio-$(CONFIG_IIO_TRIGGERS) += industrialio-trigger.o
 
 obj-$(CONFIG_IIO_SW_RING) += ring_sw.o
+
+obj-y += triggers/
\ No newline at end of file
diff --git a/drivers/industrialio/triggers/Kconfig b/drivers/industrialio/triggers/Kconfig
new file mode 100644
index 0000000..20e6498
--- /dev/null
+++ b/drivers/industrialio/triggers/Kconfig
@@ -0,0 +1,6 @@
+config IIO_PERIODIC_RTC_TRIGGER
+       tristate "Periodic RTC triggers"
+          depends on INDUSTRIALIO && IIO_TRIGGERS && RTC_CLASS
+	  help
+	    Provides support for using periodic capable real time
+	    clocks as IIO triggers.
diff --git a/drivers/industrialio/triggers/Makefile b/drivers/industrialio/triggers/Makefile
new file mode 100644
index 0000000..4ae55b9
--- /dev/null
+++ b/drivers/industrialio/triggers/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for triggers not associated with iio-devices
+#
+obj-$(CONFIG_IIO_PERIODIC_RTC_TRIGGER) += iio-trig-periodic-rtc.o
+
diff --git a/drivers/industrialio/triggers/iio-trig-periodic-rtc.c b/drivers/industrialio/triggers/iio-trig-periodic-rtc.c
new file mode 100644
index 0000000..c395722
--- /dev/null
+++ b/drivers/industrialio/triggers/iio-trig-periodic-rtc.c
@@ -0,0 +1,197 @@
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
+#include <linux/industrialio/iio.h>
+#include <linux/industrialio/trigger.h>
+#include <linux/industrialio/prtc_trigger.h>
+
+LIST_HEAD(iio_prtc_trigger_list);
+DEFINE_MUTEX(iio_prtc_trigger_list_lock);
+
+struct iio_prtc_trigger_info {
+	struct rtc_device *rtc;
+	int frequency;
+	struct rtc_task task;
+};
+
+static int iio_trig_periodic_rtc_set_state(struct iio_trigger *trig, bool state)
+{
+	struct iio_prtc_trigger_info *trig_info = trig->private_data;
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
+	ret = strict_strtoul(buf,10, &val);
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
+DEVICE_ATTR(frequency, S_IRUGO | S_IWUSR,
+	    iio_trig_periodic_read_freq,
+	    iio_trig_periodic_write_freq);
+
+static struct attribute *iio_trig_prtc_attrs[] = {
+	&dev_attr_frequency.attr,
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
+		trig = kzalloc(sizeof(*trig), GFP_KERNEL);
+		if (!trig) {
+			ret = -ENOMEM;
+			goto error_free_trigs_1;
+		}
+		iio_trigger_init(trig);
+		trig_info = kzalloc(sizeof(*trig_info), GFP_KERNEL);
+		if (!trig_info) {
+			ret = -ENOMEM;
+			goto error_free_trigs_2;
+		}
+		trig->private_data = trig_info;
+		trig->owner = THIS_MODULE;
+		trig->set_trigger_state = &iio_trig_periodic_rtc_set_state;
+		trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
+		if (trig->name == NULL) {
+			ret = -ENOMEM;
+			goto error_free_trigs_3;
+		}
+		snprintf((char *)trig->name, IIO_TRIGGER_NAME_LENGTH, "periodic%s", pdata->triggers[i].name);
+
+		/* RTC access */
+		trig_info->rtc = rtc_class_open((char *)(pdata->triggers[i].name));
+		if (trig_info->rtc == NULL) {
+			ret = -EINVAL;
+			goto error_free_trigs_4;
+		}
+		trig_info->task.func = iio_prtc_trigger_poll;
+		trig_info->task.private_data = trig;
+		ret = rtc_irq_register(trig_info->rtc, &trig_info->task);
+		if (ret)
+			printk("failed on reg\n");
+		trig->control_attrs = &iio_trig_prtc_attr_group;
+		ret = iio_trigger_register(trig, &dev->dev, i);
+		if (ret)
+			goto error_free_trigs_5;
+	}
+	return 0;
+error_free_trigs_5:
+	rtc_class_close(trig_info->rtc);
+error_free_trigs_4:
+	kfree(trig->name);
+error_free_trigs_3:
+	kfree(trig_info);
+error_free_trigs_2:
+	kfree(trig);
+error_free_trigs_1:
+	list_for_each_entry_safe(trig, trig2, &iio_prtc_trigger_list, alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		//FREE RTC STUFF
+		kfree(trig->name);
+		kfree(trig_info);
+		kfree(trig);
+	}
+	return ret;
+}
+
+static int iio_trig_periodic_rtc_remove(struct platform_device *dev)
+{
+	struct iio_trigger *trig, *trig2;
+	struct iio_prtc_trigger_info *trig_info;
+	mutex_lock(&iio_prtc_trigger_list_lock);
+	list_for_each_entry_safe(trig, trig2, &iio_prtc_trigger_list, alloc_list) {
+		trig_info = trig->private_data;
+		iio_trigger_unregister(trig);
+		//FREE RTC STUFF
+		kfree(trig->name);
+		kfree(trig_info);
+		kfree(trig);
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
diff --git a/include/linux/industrialio/prtc_trigger.h b/include/linux/industrialio/prtc_trigger.h
new file mode 100644
index 0000000..9dabc19
--- /dev/null
+++ b/include/linux/industrialio/prtc_trigger.h
@@ -0,0 +1,7 @@
+struct iio_prtc_trigger {
+	const char *name;
+};
+struct iio_prtc_trigger_group {
+	int num_triggers;
+	struct iio_prtc_trigger *triggers;
+};
