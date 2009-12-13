Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZLMWnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZLMWnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZLMWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42412 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZLMWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/5] PM: Add facility for advanced testing of async suspend/resume
Date: Sun, 13 Dec 2009 23:42:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132342.25029.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add configuration switch CONFIG_PM_ADVANCED_DEBUG for compiling in
extra PM debugging/testing code allowing one to access some
PM-related attributes of devices from the user space via sysfs.

If CONFIG_PM_ADVANCED_DEBUG is set, add sysfs attribute power/async
for every device allowing the user space to access the device's
power.async_suspend flag and modify it, if desired.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/sysfs.c |   47 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h     |    5 ++++
 kernel/power/Kconfig       |   14 +++++++++++++
 3 files changed, 66 insertions(+)

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
+ *	attribute is set to "enabled" by bus type code or device drivers and in
+ *	that cases it should be safe to leave the default value.
  */
 
 static const char enabled[] = "enabled";
@@ -77,9 +93,40 @@ wake_store(struct device * dev, struct d
 
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
+#ifdef CONFIG_PM_SLEEP_ADVANCED_DEBUG
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
+#endif /* CONFIG_PM_SLEEP_ADVANCED_DEBUG */
 
 static struct attribute * power_attrs[] = {
 	&dev_attr_wakeup.attr,
+#ifdef CONFIG_PM_SLEEP_ADVANCED_DEBUG
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
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -27,6 +27,15 @@ config PM_DEBUG
 	code. This is helpful when debugging and reporting PM bugs, like
 	suspend support.
 
+config PM_ADVANCED_DEBUG
+	bool "Extra PM attributes in sysfs for low-level debugging/testing"
+	depends on PM_DEBUG
+	default n
+	---help---
+	Add extra sysfs attributes allowing one to access some Power Management
+	fields of device objects from user space.  If you are not a kernel
+	developer interested in debugging/testing Power Management, say "no".
+
 config PM_VERBOSE
 	bool "Verbose Power Management debugging"
 	depends on PM_DEBUG
@@ -85,6 +94,11 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
+config PM_SLEEP_ADVANCED_DEBUG
+	bool
+	depends on PM_ADVANCED_DEBUG
+	default n
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM && ARCH_SUSPEND_POSSIBLE

