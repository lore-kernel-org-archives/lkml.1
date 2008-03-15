Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbYCOVx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbYCOVx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYCOVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:53:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2892 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753438AbYCOVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:53:43 -0400
Date: Sat, 15 Mar 2008 17:53:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <apw@shadowen.org>, Len Brown <lenb@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/3] PM: make wakeup flags available whenever CONFIG_PM is
 set (ver 2)
In-Reply-To: <200803142337.12605.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803151715300.28007-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various wakeup flags and their accessor macros in struct
dev_pm_info should be available whenever CONFIG_PM is enabled, not
just when CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always
be configurable for runtime power management.  This patch (as1056b)
fixes the oversight.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/include/linux/pm.h
===================================================================
--- usb-2.6.orig/include/linux/pm.h
+++ usb-2.6/include/linux/pm.h
@@ -183,8 +183,8 @@ typedef struct pm_message {
 struct dev_pm_info {
 	pm_message_t		power_state;
 	unsigned		can_wakeup:1;
-#ifdef	CONFIG_PM_SLEEP
 	unsigned		should_wakeup:1;
+#ifdef	CONFIG_PM_SLEEP
 	struct list_head	entry;
 #endif
 };
@@ -197,11 +197,6 @@ extern void device_resume(void);
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);
 
-#define device_set_wakeup_enable(dev,val) \
-	((dev)->power.should_wakeup = !!(val))
-#define device_may_wakeup(dev) \
-	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
-
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -209,6 +204,24 @@ extern void __suspend_report_result(cons
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
@@ -223,24 +236,17 @@ static inline int call_platform_enable_w
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
Index: usb-2.6/drivers/base/power/main.c
===================================================================
--- usb-2.6.orig/drivers/base/power/main.c
+++ usb-2.6/drivers/base/power/main.c
@@ -56,8 +56,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 
 static DECLARE_RWSEM(pm_sleep_rwsem);
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
Index: usb-2.6/drivers/base/power/sysfs.c
===================================================================
--- usb-2.6.orig/drivers/base/power/sysfs.c
+++ usb-2.6/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device

