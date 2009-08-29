Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZH2TTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZH2TTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 15:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZH2TTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 15:19:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZH2TTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 15:19:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 8 update] PM: Allow user space to change the power.async_suspend flag of devices
Date: Sat, 29 Aug 2009 21:20:03 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-rjw; KDE/4.3.0; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200908262217.19609.rjw@sisk.pl> <200908280024.06082.rjw@sisk.pl> <20090828070124.GB27928@elf.ucw.cz>
In-Reply-To: <20090828070124.GB27928@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908292120.03267.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 August 2009, Pavel Machek wrote:
> On Fri 2009-08-28 00:24:06, Rafael J. Wysocki wrote:
> > On Thursday 27 August 2009, Dmitry Torokhov wrote:
> > > Hi Rafael,
> > > 
> > > On Thu, Aug 27, 2009 at 09:20:55PM +0200, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Add sysfs attribute power/async for every device allowing the user
> > > > space to access the device's power.async_suspend flag and modify it,
> > > > if necessary.
> > > > 
> > > 
> > > I don't think we should let users meddle with individual devices;
> > > one global flag should be enough to work around "broken-at-the-moment"
> > > issues.
> > 
> > Well, this patch is handy for testing if anyone is interested, so I posted it.
> > 
> > It isn't exactly safe, though, you're right.
> 
> I guess it would be acceptable to let the users disable it
> per-driver... but if we can get without that, it would be better.
> 
> (it is obviously ok for debugging).

Hmm.  What about the appended patch, then?

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Add facility for advanced testing of async suspend/resume

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
+ *	attribute is set to "enabled" by the kernel and in that cases it should
+ *	be safe to leave the default value.
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
