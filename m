Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbYCTXYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbYCTXYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYCTXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:24:09 -0400
Received: from ns.suse.de ([195.135.220.2]:45740 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYCTXYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:24:07 -0400
Subject: patch pm-convert-wakeup-flag-accessors-to-inline-functions.patch added to gregkh-2.6 tree
To: stern@rowland.harvard.edu, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
From: <gregkh@suse.de>
Date: Thu, 20 Mar 2008 16:23:46 -0700
In-Reply-To: <200803192239.14091.rjw@sisk.pl>
Message-ID: <12060554251269@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PM: Convert wakeup flag accessors to inline functions

to my gregkh-2.6 tree.  Its filename is

     pm-convert-wakeup-flag-accessors-to-inline-functions.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Thu Mar 20 16:21:39 2008
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 19 Mar 2008 22:39:13 +0100
Subject: PM: Convert wakeup flag accessors to inline functions
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
Message-ID: <200803192239.14091.rjw@sisk.pl>
Content-Disposition: inline

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1058) improves the wakeup macros in include/linux/pm.h.
All but the trivial ones are converted to inline routines, which
requires moving them to a separate header file since they depend on
the definition of struct device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/device.h    |    3 +
 include/linux/pm.h        |   46 -----------------------
 include/linux/pm_wakeup.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 45 deletions(-)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -475,6 +475,9 @@ struct device {
 	void	(*release)(struct device *dev);
 };
 
+/* Get the wakeup routines, which depend on struct device */
+#include <linux/pm_wakeup.h>
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -212,54 +212,10 @@ static inline int device_suspend(pm_mess
 	return 0;
 }
 
-#define suspend_report_result(fn, ret) do { } while (0)
+#define suspend_report_result(fn, ret)		do {} while (0)
 
 #endif /* !CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_PM
-
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
-/*
- * Platform hook to activate device wakeup capability, if that's not already
- * handled by enable_irq_wake() etc.
- * Returns zero on success, else negative errno
- */
-extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
-static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
-{
-	if (platform_enable_wakeup)
-		return (*platform_enable_wakeup)(dev, is_on);
-	return 0;
-}
-
-#else /* !CONFIG_PM */
-
-#define device_set_wakeup_enable(dev,val)	do{}while(0)
-#define device_may_wakeup(dev)			(0)
-
-static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
-{
-	return 0;
-}
-
-#endif /* !CONFIG_PM */
-
-/* changes to device_may_wakeup take effect on the next pm state change.
- * by default, devices should wakeup if they can.
- */
-#define device_can_wakeup(dev) \
-	((dev)->power.can_wakeup)
-#define device_init_wakeup(dev,val) \
-	do { \
-		device_can_wakeup(dev) = !!(val); \
-		device_set_wakeup_enable(dev,val); \
-	} while(0)
-
 /*
  * Global Power Management flags
  * Used to keep APM and ACPI from both being active
--- /dev/null
+++ b/include/linux/pm_wakeup.h
@@ -0,0 +1,90 @@
+/*
+ *  pm_wakeup.h - Power management wakeup interface
+ *
+ *  Copyright (C) 2008 Alan Stern
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef _LINUX_PM_WAKEUP_H
+#define _LINUX_PM_WAKEUP_H
+
+#ifndef _DEVICE_H_
+# error "please don't include this file directly"
+#endif
+
+#ifdef CONFIG_PM
+
+/* changes to device_may_wakeup take effect on the next pm state change.
+ * by default, devices should wakeup if they can.
+ */
+static inline void device_init_wakeup(struct device *dev, int val)
+{
+	dev->power.can_wakeup = dev->power.should_wakeup = !!val;
+}
+
+static inline int device_can_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup;
+}
+
+static inline void device_set_wakeup_enable(struct device *dev, int val)
+{
+	dev->power.should_wakeup = !!val;
+}
+
+static inline int device_may_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup & dev->power.should_wakeup;
+}
+
+/*
+ * Platform hook to activate device wakeup capability, if that's not already
+ * handled by enable_irq_wake() etc.
+ * Returns zero on success, else negative errno
+ */
+extern int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	if (platform_enable_wakeup)
+		return (*platform_enable_wakeup)(dev, is_on);
+	return 0;
+}
+
+#else /* !CONFIG_PM */
+
+/* For some reason the next two routines work even without CONFIG_PM */
+static inline void device_init_wakeup(struct device *dev, int val)
+{
+	dev->power.can_wakeup = !!val;
+}
+
+static inline int device_can_wakeup(struct device *dev)
+{
+	return dev->power.can_wakeup;
+}
+
+#define device_set_wakeup_enable(dev, val)	do {} while (0)
+#define device_may_wakeup(dev)			0
+
+static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_PM */
+
+#endif /* _LINUX_PM_WAKEUP_H */


Patches currently in gregkh-2.6 which might be from stern@rowland.harvard.edu are

usb/usb-convert-usb.h-struct-usb_device-to-kernel-doc.patch
usb/usb-make-usb_storage_onetouch-available-with-pm.patch
usb/usb-usb-ohci-sm501-driver-use-the-conventional-convention-for-suspend-and-resume.patch
usb/usb-reorganize-code-in-hub.c.patch
usb/usb-ehci-carry-out-port-handover-during-each-root-hub-resume.patch
usb/usb-new-quirk-flag-to-avoid-set-interface.patch
usb/drivers-usb-core-devio.c-suppress-warning-with-64k-page_size.patch
usb/usb-make-usb-persist-work-after-every-system-sleep.patch
usb/usb-remove-config_usb_persist-setting.patch
usb/usb-check-serial-number-string-after-device-reset.patch
usb/usb-enable-usb-persist-by-default.patch
usb/usb-remove-dev-power.power_state.patch
usb/usb-isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch
usb/usb-remove-experimental-tags-from-some-usb-gadget-kconfig-entries.patch
driver-core/pm-handle-device-registrations-during-suspend-resume.patch
driver-core/pm-convert-wakeup-flag-accessors-to-inline-functions.patch
driver-core/driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
driver-core/pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
