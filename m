Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZH0TYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZH0TYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZH0TYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:24:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbZH0TXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:23:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "linux-pm" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 8] PM: Allow user space to change the power.async_suspend flag of devices
Date: Thu, 27 Aug 2009 21:20:55 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908270025.34821.rjw@sisk.pl> <200908272117.52931.rjw@sisk.pl>
In-Reply-To: <200908272117.52931.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908272120.56021.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add sysfs attribute power/async for every device allowing the user
space to access the device's power.async_suspend flag and modify it,
if necessary.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/sysfs.c |   47 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h     |    5 ++++
 2 files changed, 52 insertions(+)

Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -38,6 +38,22 @@
  *	wakeup events internally (unless they are disabled), keeping
  *	their hardware in low power modes whenever they're unused.  This
  *	saves runtime power, without requiring system-wide sleep states.
+ *
+ *	async - Report/change current async suspend setting for the device
+ *
+ *	If set, the PM core will attempt to suspend and resume the device during
+ *	system power transitions (e.g. suspend to RAM, hibernation) in parallel
+ *	with other devices it doesn't appear to depend on (to the PM core's
+ *	knowledge).
+ *
+ *	 + "enabled\n" to permit the asynchronous suspend/resume of the device
+ *	 + "disabled\n" to forbid it
+ *
+ *	NOTE: It generally is unsafe to permit the asynchronous suspend/resume
+ *	of a device unless it is certain that all of the PM dependencies of the
+ *	device are known to the PM core.  However, for some devices this
+ *	attribute is set to "enabled" by the kernel and in that cases it should
+ *	be safe to leave the default value.
  */
 
 static const char enabled[] = "enabled";
@@ -77,9 +93,40 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+#ifdef CONFIG_PM_SLEEP
+static ssize_t async_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	return sprintf(buf, "%s\n",
+			device_async_suspend_enabled(dev) ? enabled : disabled);
+}
+
+static ssize_t async_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t n)
+{
+	char *cp;
+	int len = n;
+
+	cp = memchr(buf, '\n', n);
+	if (cp)
+		len = cp - buf;
+	if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
+		device_enable_async_suspend(dev, true);
+	else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
+		device_enable_async_suspend(dev, false);
+	else
+		return -EINVAL;
+	return n;
+}
+
+static DEVICE_ATTR(async, 0644, async_show, async_store);
+#endif /* CONFIG_PM_SLEEP */
 
 static struct attribute * power_attrs[] = {
 	&dev_attr_wakeup.attr,
+#ifdef CONFIG_PM_SLEEP
+	&dev_attr_async.attr,
+#endif
 	NULL,
 };
 static struct attribute_group pm_attr_group = {
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -478,6 +478,11 @@ static inline void device_enable_async_s
 		dev->power.async_suspend = enable;
 }
 
+static inline bool device_async_suspend_enabled(struct device *dev)
+{
+	return !!dev->power.async_suspend;
+}
+
 void driver_init(void);
 
 /*
