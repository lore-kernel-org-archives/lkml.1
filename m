Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbYDTKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbYDTKrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbYDTKkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56325 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYDTKkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/36] PM: Make wakeup flags available whenever CONFIG_PM is set
Date: Sun, 20 Apr 2008 03:45:52 -0700
Message-Id: <1208688366-9252-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 93a1469..5630af3 100644
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
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index f2ed179..d11f74b 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -6,6 +6,8 @@
 #include <linux/string.h>
 #include "power.h"
 
+int (*platform_enable_wakeup)(struct device *dev, int is_on);
+
 
 /*
  *	wakeup - Report/change current wakeup option for device
diff --git a/include/linux/pm.h b/include/linux/pm.h
index e6b9f29..3342627 100644
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
@@ -210,6 +205,24 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
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
@@ -224,24 +237,17 @@ static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
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
-- 
1.5.4.5

