Return-Path: <linux-kernel-owner+w=401wt.eu-S1162993AbYCSXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162993AbYCSXNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbYCSVkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:40:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58042 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937921AbYCSVkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:40:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 3/3] PM: Convert wakeup flag accessors to inline functions
Date: Wed, 19 Mar 2008 22:39:13 +0100
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
Message-Id: <200803192239.14091.rjw@sisk.pl>
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
---
 include/linux/device.h    |    3 +
 include/linux/pm.h        |   46 -----------------------
 include/linux/pm_wakeup.h |   90 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 45 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
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
Index: linux-2.6/include/linux/device.h
===================================================================
--- linux-2.6.orig/include/linux/device.h
+++ linux-2.6/include/linux/device.h
@@ -475,6 +475,9 @@ struct device {
 	void	(*release)(struct device *dev);
 };
 
+/* Get the wakeup routines, which depend on struct device */
+#include <linux/pm_wakeup.h>
+
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
 {
Index: linux-2.6/include/linux/pm_wakeup.h
===================================================================
--- /dev/null
+++ linux-2.6/include/linux/pm_wakeup.h
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
