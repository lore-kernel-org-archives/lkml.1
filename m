Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864Ab0AWMOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0AWMOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334Ab0AWMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:14:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab0AWMO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:14:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] PM / Runtime: Add sysfs switch for disabling device run-time PM (rev. 2)
Date: Sat, 23 Jan 2010 13:14:54 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.1001222202400.23929-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1001222202400.23929-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001231314.54926.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 January 2010, Alan Stern wrote:
> On Fri, 22 Jan 2010, Rafael J. Wysocki wrote:
> 
> > > For example, we disable runtime PM for most USB devices by default.  
> > > But a few drivers may know that their devices are able to handle it, so 
> > > they want to change the default setting when they are bound.
> > 
> > Runtime PM is disabled for all devices by default unless the driver enables
> > it.  The setting in power/control is to override the driver's choice, so that
> > it can be disabled even if the driver tries to enable it.
> > 
> > IOW, the user space is the owner of the power.runtime_auto flag and I don't
> > think we should allow drivers to modify it.
> 
> After more thought, I changed my mind about this.  The ability to 
> override the driver's choice means that the user should be able to 
> enable runtime PM even if the driver tries to disable it, as well as 
> the other way 'round.
> 
> In other words, it's not productive to say the user is the owner of the
> runtime_auto flag.  What we _really_ want is to put the user in charge
> of whether or not a device is subject to runtime PM.
> 
> First of all, note that if the driver doesn't support runtime PM then
> it makes no difference what value runtime_auto has.  The issue is moot.
> 
> So suppose the driver does support runtime PM.  In this case, it's
> irrelevant that runtime PM starts out disabled by default when the
> device structure is initialized.  The bus subsystem and driver will
> reinitialize the settings in the way they think best.
> 
> But if the driver decides to disable runtime PM and pm_runtime_forbid()
> isn't EXPORTed, then the driver will be forced to implement its
> decision by leaving disable_depth > 0 -- which means there's nothing
> the user can do.  The power/control attribute won't help.  On the other
> hand, if the driver decides to disable runtime PM and it can do so by
> calling pm_runtime_forbid(), then the user can override the decision.

Hmm, OK.

Of course, if the driver decides to leave disable_depth > 0, the user still
won't be able to do anything about that, but if I understand correctly, you
want drivers to have the option to use pm_runtime_forbid() initially, right
after pm_runtime_enable(), so that the user space can turn the runtime PM
on if desired via sysfs.

That makes sense.  I have a usage case for that myself. :-)

Updated patch is appended.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Add sysfs switch for disabling device run-time PM

Add new device sysfs attribute, power/control, allowing the user
space to block the run-time power management of the devices.  If this
attribute is set to "on", the driver of the device won't be able to power
manage it at run time (without breaking the rules) and the device will
always be in the full power state (except when the entire system goes
into a sleep state).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |   45 +++++++++++++++++++++++++++++++++++++
 drivers/base/power/sysfs.c   |   51 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |    1 
 include/linux/pm_runtime.h   |    4 +++
 4 files changed, 101 insertions(+)

Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -4,9 +4,25 @@
 
 #include <linux/device.h>
 #include <linux/string.h>
+#include <linux/pm_runtime.h>
 #include "power.h"
 
 /*
+ *	control - Report/change current runtime PM setting of the device
+ *
+ *	Runtime power management of a device can be blocked with the help of
+ *	this attribute.  All devices have one of the following two values for
+ *	the power/control file:
+ *
+ *	 + "auto\n" to allow the device to be power managed at run time;
+ *	 + "on\n" to prevent the device from being power managed at run time;
+ *
+ *	The default for all devices is "auto", which means that devices may be
+ *	subject to automatic power management, depending on their drivers.
+ *	Changing this attribute to "on" prevents the driver from power managing
+ *	the device at run time.  Doing that while the device is suspended causes
+ *	it to be woken up.
+ *
  *	wakeup - Report/change current wakeup option for device
  *
  *	Some devices support "wakeup" events, which are hardware signals
@@ -43,6 +59,38 @@
 static const char enabled[] = "enabled";
 static const char disabled[] = "disabled";
 
+#ifdef CONFIG_PM_RUNTIME
+static const char ctrl_auto[] = "auto";
+static const char ctrl_on[] = "on";
+
+static ssize_t control_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%s\n",
+				dev->power.runtime_auto ? ctrl_auto : ctrl_on);
+}
+
+static ssize_t control_store(struct device * dev, struct device_attribute *attr,
+			     const char * buf, size_t n)
+{
+	char *cp;
+	int len = n;
+
+	cp = memchr(buf, '\n', n);
+	if (cp)
+		len = cp - buf;
+	if (len == sizeof ctrl_auto - 1 && strncmp(buf, ctrl_auto, len) == 0)
+		pm_runtime_allow(dev);
+	else if (len == sizeof ctrl_on - 1 && strncmp(buf, ctrl_on, len) == 0)
+		pm_runtime_forbid(dev);
+	else
+		return -EINVAL;
+	return n;
+}
+
+static DEVICE_ATTR(control, 0644, control_show, control_store);
+#endif
+
 static ssize_t
 wake_show(struct device * dev, struct device_attribute *attr, char * buf)
 {
@@ -79,6 +127,9 @@ static DEVICE_ATTR(wakeup, 0644, wake_sh
 
 
 static struct attribute * power_attrs[] = {
+#ifdef CONFIG_PM_RUNTIME
+	&dev_attr_control.attr,
+#endif
 	&dev_attr_wakeup.attr,
 	NULL,
 };
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -430,6 +430,7 @@ struct dev_pm_info {
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
 	unsigned int		run_wake:1;
+	unsigned int		runtime_auto:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -1011,6 +1011,50 @@ void pm_runtime_enable(struct device *de
 EXPORT_SYMBOL_GPL(pm_runtime_enable);
 
 /**
+ * pm_runtime_forbid - Block run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Increase the device's usage count and clear its power.runtime_auto flag,
+ * so that it cannot be suspended at run time until pm_runtime_allow() is called
+ * for it.
+ */
+void pm_runtime_forbid(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	if (!dev->power.runtime_auto)
+		goto out;
+
+	dev->power.runtime_auto = false;
+	atomic_inc(&dev->power.usage_count);
+	__pm_runtime_resume(dev, false);
+
+ out:
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_forbid);
+
+/**
+ * pm_runtime_allow - Unblock run-time PM of a device.
+ * @dev: Device to handle.
+ *
+ * Decrease the device's usage count and set its power.runtime_auto flag.
+ */
+void pm_runtime_allow(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	if (dev->power.runtime_auto)
+		goto out;
+
+	dev->power.runtime_auto = true;
+	if (atomic_dec_and_test(&dev->power.usage_count))
+		__pm_runtime_idle(dev);
+
+ out:
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_allow);
+
+/**
  * pm_runtime_init - Initialize run-time PM fields in given device object.
  * @dev: Device object to initialize.
  */
@@ -1028,6 +1072,7 @@ void pm_runtime_init(struct device *dev)
 
 	atomic_set(&dev->power.child_count, 0);
 	pm_suspend_ignore_children(dev, false);
+	dev->power.runtime_auto = true;
 
 	dev->power.request_pending = false;
 	dev->power.request = RPM_REQ_NONE;
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -28,6 +28,8 @@ extern int __pm_runtime_set_status(struc
 extern int pm_runtime_barrier(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern void pm_runtime_allow(struct device *dev);
+extern void pm_runtime_forbid(struct device *dev);
 
 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -78,6 +80,8 @@ static inline int __pm_runtime_set_statu
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
 static inline void pm_runtime_enable(struct device *dev) {}
 static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline void pm_runtime_allow(struct device *dev) {}
+static inline void pm_runtime_forbid(struct device *dev) {}
 
 static inline bool pm_children_suspended(struct device *dev) { return false; }
 static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
