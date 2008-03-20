Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYCTXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYCTXYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759626AbYCTXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:24:27 -0400
Received: from mail.suse.de ([195.135.220.2]:45787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759547AbYCTXY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:24:26 -0400
Subject: patch pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch added to gregkh-2.6 tree
To: stern@rowland.harvard.edu, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
From: <gregkh@suse.de>
Date: Thu, 20 Mar 2008 16:23:52 -0700
In-Reply-To: <200803192237.43123.rjw@sisk.pl>
Message-ID: <1206055432577@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PM: Make wakeup flags available whenever CONFIG_PM is set

to my gregkh-2.6 tree.  Its filename is

     pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Thu Mar 20 16:20:59 2008
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 19 Mar 2008 22:37:42 +0100
Subject: PM: Make wakeup flags available whenever CONFIG_PM is set
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
Message-ID: <200803192237.43123.rjw@sisk.pl>
Content-Disposition: inline


From: Alan Stern <stern@rowland.harvard.edu>

The various wakeup flags and their accessor macros in struct
dev_pm_info should be available whenever CONFIG_PM is enabled, not
just when CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always
be configurable for runtime power management.  This patch (as1056b)
fixes the oversight.

David Brownell adds:
	More accurately, fixes the "regression" ... as noted sometime
	last summer, after 296699de6bdc717189a331ab6bbe90e05c94db06
	introduced CONFIG_SUSPEND.  But that didn't make the regression
	list for that kernel, ergo the delay in fixing it.

[rjw: rebased]

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/main.c  |    2 --
 drivers/base/power/sysfs.c |    2 ++
 include/linux/pm.h         |   36 +++++++++++++++++++++---------------
 3 files changed, 23 insertions(+), 17 deletions(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -57,8 +57,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 /* 'true' if all devices have been suspended, protected by dpm_list_mtx */
 static bool all_sleeping;
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -183,9 +183,9 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
+	unsigned		should_wakeup:1;
 	bool			sleeping:1;	/* Owned by the PM core */
 #ifdef	CONFIG_PM_SLEEP
-	unsigned		should_wakeup:1;
 	struct list_head	entry;
 #endif
 };
@@ -198,11 +198,6 @@ extern void device_resume(void);
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -210,6 +205,24 @@ extern void __suspend_report_result(cons
 		__suspend_report_result(__FUNCTION__, fn, ret);		\
 	} while (0)
 
+#else /* !CONFIG_PM_SLEEP */
+
+static inline int device_suspend(pm_message_t state)
+{
+	return 0;
+}
+
+#define suspend_report_result(fn, ret) do { } while (0)
+
+#endif /* !CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM
+
+#define device_set_wakeup_enable(dev,val) \
+	((dev)->power.should_wakeup = !!(val))
+#define device_may_wakeup(dev) \
+	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
+
 /*
  * Platform hook to activate device wakeup capability, if that's not already
  * handled by enable_irq_wake() etc.
@@ -224,24 +237,17 @@ static inline int call_platform_enable_w
 	return 0;
 }
 
-#else /* !CONFIG_PM_SLEEP */
-
-static inline int device_suspend(pm_message_t state)
-{
-	return 0;
-}
+#else /* !CONFIG_PM */
 
 #define device_set_wakeup_enable(dev,val)	do{}while(0)
 #define device_may_wakeup(dev)			(0)
 
-#define suspend_report_result(fn, ret) do { } while (0)
-
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
 {
 	return 0;
 }
 
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* !CONFIG_PM */
 
 /* changes to device_may_wakeup take effect on the next pm state change.
  * by default, devices should wakeup if they can.


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
