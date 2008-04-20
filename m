Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbYDTKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbYDTKrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbYDTKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:40:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56329 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116AbYDTKko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:40:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/36] PM: Convert wakeup flag accessors to inline functions
Date: Sun, 20 Apr 2008 03:45:53 -0700
Message-Id: <1208688366-9252-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080420104516.GA9225@suse.de>
References: <20080420104516.GA9225@suse.de>
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 include/linux/pm.h        |   46 +----------------------
 include/linux/pm_wakeup.h |   90 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 45 deletions(-)
 create mode 100644 include/linux/pm_wakeup.h

diff --git a/include/linux/device.h b/include/linux/device.h
index d576611..d7a1ae0 100644
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
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 3342627..1de72cb 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -212,54 +212,10 @@ static inline int device_suspend(pm_message_t state)
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
diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
new file mode 100644
index 0000000..f0d0b2c
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
-- 
1.5.4.5

