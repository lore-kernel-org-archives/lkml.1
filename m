Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0CDAyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:54:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44991 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0CDAyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:54:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH] PM: add dpm_use_runtime_{suspend, resume} helper functions
Date: Thu, 4 Mar 2010 01:56:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Mark Brown <broonie@sirena.org.uk>, LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003031140210.2821-100000@iolanthe.rowland.org> <201003032233.14971.rjw@sisk.pl>
In-Reply-To: <201003032233.14971.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003040156.58763.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 March 2010, Rafael J. Wysocki wrote:
> On Wednesday 03 March 2010, Alan Stern wrote:
> > On Tue, 2 Mar 2010, Rafael J. Wysocki wrote:
...
> > 
> > You didn't add this to the documentation file.

Added that and a changelog.  Updated patch is appended.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Provide generic subsystem-level callbacks

There are subsystems whose power management callbacks only need to
invoke the callbacks provided by device drivers.  Still, their system
sleep PM callbacks should play well with the runtime PM callbacks,
so that devices suspended at run time can be left in that state for
a system sleep transition.

Provide a set of generic PM callbacks for such subsystems and
define convenience macros for populating dev_pm_ops structures.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   64 ++++++++++
 drivers/base/power/Makefile        |    1 
 drivers/base/power/generic_ops.c   |  233 +++++++++++++++++++++++++++++++++++++
 include/linux/pm.h                 |   51 +++++++-
 include/linux/pm_runtime.h         |    6 
 5 files changed, 349 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/base/power/generic_ops.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/base/power/generic_ops.c
@@ -0,0 +1,233 @@
+/*
+ * drivers/base/power/generic_ops.c - Generic PM callbacks for subsystems
+ *
+ * Copyright (c) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#ifdef CONFIG_PM_RUNTIME
+/**
+ * pm_generic_runtime_idle - Generic runtime idle callback for subsystems.
+ * @dev: Device to handle.
+ *
+ * If PM operations are defined for the driver of @dev and they include
+ * ->runtime_idle(), execute it and return the error code returned by it if
+ * nonzero.  Otherwise, execute pm_runtime_suspend() for the device.
+ */
+int pm_generic_runtime_idle(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm && pm->runtime_idle) {
+		int ret = pm->runtime_idle(dev);
+		if (ret)
+			return ret;
+	}
+
+	pm_runtime_suspend(dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pm_generic_runtime_idle);
+
+/**
+ * pm_generic_runtime_suspend - Generic runtime suspend callback for subsystems.
+ * @dev: Device to suspend.
+ *
+ * If PM operations are defined for the driver of @dev and they include
+ * ->runtime_suspend(), execute it and return the error code returned by it.
+ * Otherwise, return zero.
+ */
+int pm_generic_runtime_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int ret;
+
+	ret = pm && pm->runtime_suspend ? pm->runtime_suspend(dev) : -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_generic_runtime_suspend);
+
+/**
+ * pm_generic_runtime_resume - Generic runtime resume callback for subsystems.
+ * @dev: Device to resume.
+ *
+ * If PM operations are defined for the driver of @dev and they include
+ * ->runtime_resume(), execute it and return the error code returned by it.
+ * Otherwise, return zero.
+ */
+int pm_generic_runtime_resume(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int ret;
+
+	ret = pm && pm->runtime_resume ? pm->runtime_resume(dev) : -EINVAL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_generic_runtime_resume);
+#endif /* CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ * __pm_generic_call - Generic suspend/freeze/poweroff/thaw subsystem callback.
+ * @dev: Device to handle.
+ * @event: PM transition of the system under way.
+ *
+ * If the device has not been suspended at run time, execute the
+ * suspend/freeze/poweroff/thaw callback provided by its driver, if defined, and
+ * return the error code returned by it.  Otherwise, return zero.
+ */
+static int __pm_generic_call(struct device *dev, int event)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int (*callback)(struct device *);
+
+	if (!pm || pm_runtime_suspended(dev))
+		return 0;
+
+	switch (event) {
+	case PM_EVENT_SUSPEND:
+		callback = pm->suspend;
+		break;
+	case PM_EVENT_FREEZE:
+		callback = pm->freeze;
+		break;
+	case PM_EVENT_HIBERNATE:
+		callback = pm->poweroff;
+		break;
+	case PM_EVENT_THAW:
+		callback = pm->thaw;
+		break;
+	default:
+		callback = NULL;
+		break;
+	}
+
+	return callback ? callback(dev) : 0;
+}
+
+/**
+ * pm_generic_suspend - Generic suspend callback for subsystems.
+ * @dev: Device to suspend.
+ */
+int pm_generic_suspend(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_SUSPEND);
+}
+EXPORT_SYMBOL_GPL(pm_generic_suspend);
+
+/**
+ * pm_generic_freeze - Generic freeze callback for subsystems.
+ * @dev: Device to freeze.
+ */
+int pm_generic_freeze(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_FREEZE);
+}
+EXPORT_SYMBOL_GPL(pm_generic_freeze);
+
+/**
+ * pm_generic_poweroff - Generic poweroff callback for subsystems.
+ * @dev: Device to handle.
+ */
+int pm_generic_poweroff(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_HIBERNATE);
+}
+EXPORT_SYMBOL_GPL(pm_generic_poweroff);
+
+/**
+ * pm_generic_thaw - Generic thaw callback for subsystems.
+ * @dev: Device to thaw.
+ */
+int pm_generic_thaw(struct device *dev)
+{
+	return __pm_generic_call(dev, PM_EVENT_THAW);
+}
+EXPORT_SYMBOL_GPL(pm_generic_thaw);
+
+/**
+ * __pm_generic_resume - Generic resume/restore callback for subsystems.
+ * @dev: Device to handle.
+ * @event: PM transition of the system under way.
+ *
+ * Execute the resume/resotre callback provided by the driver of @dev, if
+ * defined.  If it returns 0, change the device's runtime PM status to 'active'.
+ * Return the error code returned by it.
+ */
+static int __pm_generic_resume(struct device *dev, int event)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int (*callback)(struct device *);
+	int ret;
+
+	if (!pm)
+		return 0;
+
+	switch (event) {
+	case PM_EVENT_RESUME:
+		callback = pm->resume;
+		break;
+	case PM_EVENT_RESTORE:
+		callback = pm->restore;
+		break;
+	default:
+		callback = NULL;
+		break;
+	}
+
+	if (!callback)
+		return 0;
+
+	ret = callback(dev);
+	if (!ret) {
+		pm_runtime_disable(dev);
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
+}
+
+/**
+ * pm_generic_resume - Generic resume callback for subsystems.
+ * @dev: Device to resume.
+ */
+int pm_generic_resume(struct device *dev)
+{
+	return __pm_generic_resume(dev, PM_EVENT_RESUME);
+}
+EXPORT_SYMBOL_GPL(pm_generic_resume);
+
+/**
+ * pm_generic_restore - Generic restore callback for subsystems.
+ * @dev: Device to restore.
+ */
+int pm_generic_restore(struct device *dev)
+{
+	return __pm_generic_resume(dev, PM_EVENT_RESTORE);
+}
+EXPORT_SYMBOL_GPL(pm_generic_restore);
+#endif /* CONFIG_PM_SLEEP */
+
+struct dev_pm_ops generic_subsys_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.suspend = pm_generic_suspend,
+	.resume = pm_generic_resume,
+	.freeze = pm_generic_freeze,
+	.thaw = pm_generic_thaw,
+	.poweroff = pm_generic_poweroff,
+	.restore = pm_generic_restore,
+#endif
+#ifdef CONFIG_PM_RUNTIME
+	.runtime_suspend = pm_generic_runtime_suspend,
+	.runtime_resume = pm_generic_runtime_resume,
+	.runtime_idle = pm_generic_runtime_idle,
+#endif
+};
+EXPORT_SYMBOL_GPL(generic_subsys_pm_ops);
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_PM)	+= sysfs.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
+obj-$(CONFIG_PM_OPS)	+= generic_ops.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -215,20 +215,59 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+#ifdef CONFIG_PM_SLEEP
+#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend = suspend_fn, \
+	.resume = resume_fn, \
+	.freeze = suspend_fn, \
+	.thaw = resume_fn, \
+	.poweroff = suspend_fn, \
+	.restore = resume_fn,
+#else
+#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+#define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = suspend_fn, \
+	.runtime_resume = resume_fn, \
+	.runtime_idle = idle_fn,
+#else
+#define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
+#endif
+
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
  */
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
 const struct dev_pm_ops name = { \
-	.suspend = suspend_fn, \
-	.resume = resume_fn, \
-	.freeze = suspend_fn, \
-	.thaw = resume_fn, \
-	.poweroff = suspend_fn, \
-	.restore = resume_fn, \
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+}
+
+/*
+ * Use this for defining a set of PM operations to be used in all situations
+ * (sustem suspend, hibernation or runtime PM).
+ */
+#define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
+const struct dev_pm_ops name = { \
+	SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
 }
 
+/*
+ * Use this for subsystems (bus types, device types, device classes) that don't
+ * need any special suspend/resume handling in addition to invoking the PM
+ * callbacks provided by device drivers supporting both the system sleep PM and
+ * runtime PM, make the pm member point to generic_subsys_pm_ops.
+ */
+#ifdef CONFIG_PM_OPS
+extern struct dev_pm_ops generic_subsys_pm_ops;
+#define GENERIC_SUBSYS_PM_OPS	(&generic_subsys_pm_ops)
+#else
+#define GENERIC_SUBSYS_PM_OPS	NULL
+#endif
+
 /**
  * PM_EVENT_ messages
  *
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -62,6 +62,11 @@ static inline void device_set_run_wake(s
 	dev->power.run_wake = enable;
 }
 
+static inline bool pm_runtime_suspended(struct device *dev)
+{
+	return dev->power.runtime_status == RPM_SUSPENDED;
+}
+
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int pm_runtime_idle(struct device *dev) { return -ENOSYS; }
@@ -89,6 +94,7 @@ static inline void pm_runtime_get_noresu
 static inline void pm_runtime_put_noidle(struct device *dev) {}
 static inline bool device_run_wake(struct device *dev) { return false; }
 static inline void device_set_run_wake(struct device *dev, bool enable) {}
+static inline bool pm_runtime_suspended(struct device *dev) { return false; }
 
 #endif /* !CONFIG_PM_RUNTIME */
 
Index: linux-2.6/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6/Documentation/power/runtime_pm.txt
@@ -335,6 +335,10 @@ drivers/base/power/runtime.c and include
       'power.runtime_error' is set or 'power.disable_depth' is greater than
       zero)
 
+  bool pm_runtime_suspended(struct device *dev);
+    - return true if the devices runtime PM status is 'suspended' or false
+      otherwise
+
   void pm_runtime_allow(struct device *dev);
     - set the power.runtime_auto flag for the device and decrease its usage
       counter (used by the /sys/devices/.../power/control interface to
@@ -459,3 +463,63 @@ The PM core always increments the run-ti
 ->prepare() callback and decrements it after calling the ->complete() callback.
 Hence disabling run-time PM temporarily like this will not cause any run-time
 suspend callbacks to be lost.
+
+7. Generic subsystem callbacks
+
+Subsystems may wish to conserve code space by using the set of generic power
+management callbacks provided by the PM core, defined in
+driver/base/power/generic_ops.c:
+
+  int pm_generic_runtime_idle(struct device *dev);
+    - invoke the ->runtime_idle() callback provided by the driver of this
+      device, if defined, and execute pm_runtime_suspend() for it
+
+  int pm_generic_runtime_suspend(struct device *dev);
+    - invoke the ->runtime_suspend() callback provided by the driver of this
+      device and return its result, or return -EINVAL if not defined
+
+  int pm_generic_runtime_resume(struct device *dev);
+    - invoke the ->runtime_resume() callback provided by the driver of this
+      device and return its result, or return -EINVAL if not defined
+
+  int pm_generic_suspend(struct device *dev);
+    - if the device has not been suspended at run time, invoke the ->suspend()
+      callback provided by its driver and return the result returned by it, or
+      return 0 if not defined
+
+  int pm_generic_resume(struct device *dev);
+    - invoke the ->resume() callback provided by the driver of this device and,
+      if successful, change the device's runtime PM status to 'active'
+
+  int pm_generic_freeze(struct device *dev);
+    - if the device has not been suspended at run time, invoke the ->freeze()
+      callback provided by its driver and return the result returned by it, or
+      return 0 if not defined
+
+  int pm_generic_thaw(struct device *dev);
+    - if the device has not been suspended at run time, invoke the ->thaw()
+      callback provided by its driver and return the result returned by it, or
+      return 0 if not defined
+
+  int pm_generic_poweroff(struct device *dev);
+    - if the device has not been suspended at run time, invoke the ->poweroff()
+      callback provided by its driver and return the result returned by it, or
+      return 0 if not defined
+
+  int pm_generic_restore(struct device *dev);
+    - invoke the ->restore() callback provided by the driver of this device and,
+      if successful, change the device's runtime PM status to 'active'
+
+These functions can be assigned to the ->runtime_idle(), ->runtime_suspend(),
+->runtime_resume(), ->suspend(), ->resume(), ->freeze(), ->thaw(), ->poweroff(),
+or ->restore() callback pointers in the subsystem-level dev_pm_ops structures.
+
+If a subsystem wishes to use all of them at the same time, it can simply assign
+the GENERIC_SUBSYS_PM_OPS macro, defined in include/linux/pm.h, to its
+dev_pm_ops structure pointer.
+
+Device drivers that wish to use the same function as a system suspend, freeze,
+poweroff and run-time suspend callback, and similarly for system resume, thaw,
+restore, and run-time resume, can achieve this with the help of the
+UNIVERSAL_DEV_PM_OPS macro defined in include/linux/pm.h, possibly passing NULL
+as the last argument of it.
