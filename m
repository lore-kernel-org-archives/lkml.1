Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197Ab0ARA3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0ARA3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154Ab0ARA3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:29:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab0ARA3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:29:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM / Runtime: Add sysfs switch for disabling device run-time PM
Date: Mon, 18 Jan 2010 01:29:55 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001180129.55219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM

Add new device sysfs attribute, power/runtime, allowing the user
space to block the run-time power management of the device.  If this
attribute is set to "disabled", the driver of the device won't be
able to enable run-time power management for it (without breaking the
rules).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/power.h   |    4 +
 drivers/base/power/runtime.c |  107 +++++++++++++++++++++++++++++++++----------
 drivers/base/power/sysfs.c   |   46 ++++++++++++++++++
 include/linux/pm.h           |    1 
 include/linux/pm_runtime.h   |   11 +---
 5 files changed, 139 insertions(+), 30 deletions(-)

Index: linux-2.6/drivers/base/power/power.h
===================================================================
--- linux-2.6.orig/drivers/base/power/power.h
+++ linux-2.6/drivers/base/power/power.h
@@ -2,11 +2,15 @@
 
 extern void pm_runtime_init(struct device *dev);
 extern void pm_runtime_remove(struct device *dev);
+extern void pm_runtime_allow(struct device *dev);
+extern void pm_runtime_forbid(struct device *dev);
 
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline void pm_runtime_init(struct device *dev) {}
 static inline void pm_runtime_remove(struct device *dev) {}
+static inline void pm_runtime_allow(struct device *dev) {}
+static inline void pm_runtime_forbid(struct device *dev) {}
 
 #endif /* !CONFIG_PM_RUNTIME */
 
Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -7,6 +7,20 @@
 #include "power.h"
 
 /*
+ *	runtime - Report/change current runtime PM setting of the device
+ *
+ *	Runtime power management of a device can be disabled with the help of
+ *	this attribute.  All devices have one of the following two values for
+ *	the power/runtime file:
+ *
+ *	 + "enabled\n" to allow the device to be power managed at run time;
+ *	 + "disabled\n" to disable this feature for the device;
+ *
+ *	The default for all devices is "enabled\n", but the runtime power
+ *	management of the device has to be enabled by its driver to be actually
+ *	used.  Changing this attribute to "disabled\n" while the device is
+ *	suspended causes it to be woken up.
+ *
  *	wakeup - Report/change current wakeup option for device
  *
  *	Some devices support "wakeup" events, which are hardware signals
@@ -59,6 +73,35 @@
 static const char enabled[] = "enabled";
 static const char disabled[] = "disabled";
 
+#ifdef CONFIG_PM_RUNTIME
+static ssize_t runtime_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%s\n",
+			dev->power.runtime_forbidden ? disabled : enabled);
+}
+
+static ssize_t runtime_store(struct device * dev, struct device_attribute *attr,
+			     const char * buf, size_t n)
+{
+	char *cp;
+	int len = n;
+
+	cp = memchr(buf, '\n', n);
+	if (cp)
+		len = cp - buf;
+	if (len == sizeof enabled - 1 && strncmp(buf, enabled, len) == 0)
+		pm_runtime_allow(dev);
+	else if (len == sizeof disabled - 1 && strncmp(buf, disabled, len) == 0)
+		pm_runtime_forbid(dev);
+	else
+		return -EINVAL;
+	return n;
+}
+
+static DEVICE_ATTR(runtime, 0644, runtime_show, runtime_store);
+#endif
+
 static ssize_t
 wake_show(struct device * dev, struct device_attribute *attr, char * buf)
 {
@@ -123,6 +166,9 @@ static DEVICE_ATTR(async, 0644, async_sh
 #endif /* CONFIG_PM_SLEEP_ADVANCED_DEBUG */
 
 static struct attribute * power_attrs[] = {
+#ifdef CONFIG_PM_RUNTIME
+	&dev_attr_runtime.attr,
+#endif
 	&dev_attr_wakeup.attr,
 #ifdef CONFIG_PM_SLEEP_ADVANCED_DEBUG
 	&dev_attr_async.attr,
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -433,6 +433,7 @@ struct dev_pm_info {
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
 	unsigned int		run_wake:1;
+	unsigned int		runtime_forbidden:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -943,35 +943,26 @@ int pm_runtime_barrier(struct device *de
 EXPORT_SYMBOL_GPL(pm_runtime_barrier);
 
 /**
- * __pm_runtime_disable - Disable run-time PM of a device.
+ * __pm_runtime_disable - Disable run-time PM of a device, no locking.
  * @dev: Device to handle.
- * @check_resume: If set, check if there's a resume request for the device.
+ * @resume: If set, resume the device before disabling its run-time PM.
  *
  * Increment power.disable_depth for the device and if was zero previously,
  * cancel all pending run-time PM requests for the device and wait for all
  * operations in progress to complete.  The device can be either active or
  * suspended after its run-time PM has been disabled.
  *
- * If @check_resume is set and there's a resume request pending when
- * __pm_runtime_disable() is called and power.disable_depth is zero, the
- * function will wake up the device before disabling its run-time PM.
+ * If @resume is set, the function will wake up the device before disabling its
+ * run-time PM.
  */
-void __pm_runtime_disable(struct device *dev, bool check_resume)
+static void __pm_runtime_disable(struct device *dev, bool resume)
 {
-	spin_lock_irq(&dev->power.lock);
-
 	if (dev->power.disable_depth > 0) {
 		dev->power.disable_depth++;
-		goto out;
+		return;
 	}
 
-	/*
-	 * Wake up the device if there's a resume request pending, because that
-	 * means there probably is some I/O to process and disabling run-time PM
-	 * shouldn't prevent the device from processing the I/O.
-	 */
-	if (check_resume && dev->power.request_pending
-	    && dev->power.request == RPM_REQ_RESUME) {
+	if (resume) {
 		/*
 		 * Prevent suspends and idle notifications from being carried
 		 * out after we have woken up the device.
@@ -985,32 +976,101 @@ void __pm_runtime_disable(struct device 
 
 	if (!dev->power.disable_depth++)
 		__pm_runtime_barrier(dev);
+}
 
- out:
+/**
+ * pm_runtime_disable_resume - Disable run-time PM of a device and resume it.
+ * @dev: Device to handle.
+ *
+ * Execute __pm_raw_runtime_disable() for the device in such a way that the
+ * device will be woken up if there's a resume request pending for it.
+ */
+void pm_runtime_disable_resume(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	/*
+	 * Wake up the device if there's a resume request pending, because that
+	 * means there probably is some I/O to process and disabling run-time PM
+	 * shouldn't prevent the device from processing the I/O.
+	 */
+	__pm_runtime_disable(dev, dev->power.request_pending
+				&& dev->power.request == RPM_REQ_RESUME);
 	spin_unlock_irq(&dev->power.lock);
 }
-EXPORT_SYMBOL_GPL(__pm_runtime_disable);
+EXPORT_SYMBOL_GPL(pm_runtime_disable_resume);
 
 /**
- * pm_runtime_enable - Enable run-time PM of a device.
+ * pm_runtime_disable - Disable run-time PM of a device.
  * @dev: Device to handle.
  */
-void pm_runtime_enable(struct device *dev)
+void pm_runtime_disable(struct device *dev)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->power.lock, flags);
+	spin_lock_irq(&dev->power.lock);
+	__pm_runtime_disable(dev, false);
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
 
+/**
+ * __pm_runtime_enable - Enable run-time PM of a device, no locking.
+ * @dev: Device to handle.
+ */
+static void __pm_runtime_enable(struct device *dev)
+{
 	if (dev->power.disable_depth > 0)
 		dev->power.disable_depth--;
 	else
 		dev_warn(dev, "Unbalanced %s!\n", __func__);
+}
+
+/**
+ * pm_runtime_enable - Enable run-time PM of a device.
+ * @dev: Device to handle.
+ */
+void pm_runtime_enable(struct device *dev)
+{
+	unsigned long flags;
 
+	spin_lock_irqsave(&dev->power.lock, flags);
+	__pm_runtime_enable(dev);
 	spin_unlock_irqrestore(&dev->power.lock, flags);
 }
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
 /**
+ * pm_runtime_forbid - Block run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Increase the device's disable count and set its power.runtime_forbidden flag,
+ * so that it's not enabled until pm_runtime_allow() is called for @dev.
+ */
+void pm_runtime_forbid(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	if (!dev->power.runtime_forbidden) {
+		dev->power.runtime_forbidden = true;
+		__pm_runtime_disable(dev, true);
+	}
+	spin_unlock_irq(&dev->power.lock);
+}
+
+/**
+ * pm_runtime_allow - Unblock run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Decrease the device's disable count and set its power.runtime_forbidden flag.
+ */
+void pm_runtime_allow(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.runtime_forbidden) {
+		dev->power.runtime_forbidden = false;
+		__pm_runtime_enable(dev);
+	}
+	spin_unlock_irq(&dev->power.lock);
+}
+
+/**
  * pm_runtime_init - Initialize run-time PM fields in given device object.
  * @dev: Device object to initialize.
  */
@@ -1023,6 +1083,7 @@ void pm_runtime_init(struct device *dev)
 
 	dev->power.disable_depth = 1;
 	atomic_set(&dev->power.usage_count, 0);
+	dev->power.runtime_forbidden = false;
 
 	dev->power.runtime_error = 0;
 
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -27,7 +27,8 @@ extern int __pm_runtime_put(struct devic
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
-extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern void pm_runtime_disable_resume(struct device *dev);
+extern void pm_runtime_disable(struct device *dev);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -77,7 +78,8 @@ static inline int __pm_runtime_set_statu
 					    unsigned int status) { return 0; }
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
 static inline void pm_runtime_enable(struct device *dev) {}
-static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline void pm_runtime_disable_resume(struct device *dev) {}
+static inline void pm_runtime_disable(struct device *dev) {}
 
 static inline bool pm_children_suspended(struct device *dev) { return false; }
 static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
@@ -118,9 +120,4 @@ static inline void pm_runtime_set_suspen
 	__pm_runtime_set_status(dev, RPM_SUSPENDED);
 }
 
-static inline void pm_runtime_disable(struct device *dev)
-{
-	__pm_runtime_disable(dev, true);
-}
-
 #endif
