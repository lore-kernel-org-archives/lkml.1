Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbYCSXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbYCSXOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937931AbYCSVkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:40:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937922AbYCSVkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:40:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 2/3] PM: Make wakeup flags available whenever CONFIG_PM is set (ver 2)
Date: Wed, 19 Mar 2008 22:37:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
References: <200803190315.m2J3FXnK029022@imap1.linux-foundation.org> <20080319185755.GA18464@kroah.com> <200803192233.55313.rjw@sisk.pl>
In-Reply-To: <200803192233.55313.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192237.43123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

The various wakeup flags and their accessor macros in struct
dev_pm_info should be available whenever CONFIG_PM is enabled, not
just when CONFIG_PM_SLEEP is on.  Otherwise remote wakeup won't always
be configurable for runtime power management.  This patch (as1056b)
fixes the oversight.

[rjw: rebased]

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c  |    2 --
 drivers/base/power/sysfs.c |    2 ++
 include/linux/pm.h         |   36 +++++++++++++++++++++---------------
 3 files changed, 23 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
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
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -57,8 +57,6 @@ static DEFINE_MUTEX(dpm_list_mtx);
 /* 'true' if all devices have been suspended, protected by dpm_list_mtx */
 static bool all_sleeping;
 
-int (*platform_enable_wakeup)(struct device *dev, int is_on);
-
 /**
  *	device_pm_add - add a device to the list of active devices
  *	@dev:	Device to be added to the list
Index: linux-2.6/drivers/base/power/sysfs.c
===================================================================
--- linux-2.6.orig/drivers/base/power/sysfs.c
+++ linux-2.6/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device

