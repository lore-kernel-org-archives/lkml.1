Return-Path: <linux-kernel-owner+w=401wt.eu-S1763892AbXGRX2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763892AbXGRX2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936136AbXGRX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:39 -0400
Received: from ns.suse.de ([195.135.220.2]:57423 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762662AbXGRX0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/14] PM: remove deprecated dpm_runtime_* routines
Date: Wed, 18 Jul 2007 16:25:40 -0700
Message-Id: <118480116414-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011593154-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as933) removes the deprecated dpm_runtime_suspend() and
dpm_runtime_resume() routines from the PM core.  The only user of
those routines is the PCMCIA ds driver; local replacements are added.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/feature-removal-schedule.txt |    1 -
 drivers/base/power/Makefile                |    2 +-
 drivers/base/power/power.h                 |    5 --
 drivers/base/power/runtime.c               |   85 ----------------------------
 drivers/pcmcia/ds.c                        |   40 +++++++++++--
 include/linux/pm.h                         |   11 ----
 6 files changed, 35 insertions(+), 109 deletions(-)
 delete mode 100644 drivers/base/power/runtime.c

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 9cf9d83..1b5c707 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -27,7 +27,6 @@ Who:	Hans Verkuil <hverkuil@xs4all.nl> and
 ---------------------------
 
 What:	dev->power.power_state
-	dpm_runtime_{suspend,resume)()
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
 	driver-internal runtime power management with:  mechanisms to support
diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 91f2309..fff1780 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,5 +1,5 @@
 obj-y			:= shutdown.o
-obj-$(CONFIG_PM)	+= main.o suspend.o resume.o runtime.o sysfs.o
+obj-$(CONFIG_PM)	+= main.o suspend.o resume.o sysfs.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
 
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
diff --git a/drivers/base/power/power.h b/drivers/base/power/power.h
index 2760f25..591a0dd 100644
--- a/drivers/base/power/power.h
+++ b/drivers/base/power/power.h
@@ -62,11 +62,6 @@ extern int resume_device(struct device *);
  */
 extern int suspend_device(struct device *, pm_message_t);
 
-
-/*
- * runtime.c
- */
-
 #else /* CONFIG_PM */
 
 
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
deleted file mode 100644
index df6174d..0000000
--- a/drivers/base/power/runtime.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * drivers/base/power/runtime.c - Handling dynamic device power management.
- *
- * Copyright (c) 2003 Patrick Mochel
- * Copyright (c) 2003 Open Source Development Lab
- *
- */
-
-#include <linux/device.h>
-#include "power.h"
-
-
-static void runtime_resume(struct device * dev)
-{
-	dev_dbg(dev, "resuming\n");
-	if (!dev->power.power_state.event)
-		return;
-	if (!resume_device(dev))
-		dev->power.power_state = PMSG_ON;
-}
-
-
-/**
- *	dpm_runtime_resume - Power one device back on.
- *	@dev:	Device.
- *
- *	Bring one device back to the on state by first powering it
- *	on, then restoring state. We only operate on devices that aren't
- *	already on.
- *	FIXME: We need to handle devices that are in an unknown state.
- */
-
-void dpm_runtime_resume(struct device * dev)
-{
-	mutex_lock(&dpm_mtx);
-	runtime_resume(dev);
-	mutex_unlock(&dpm_mtx);
-}
-EXPORT_SYMBOL(dpm_runtime_resume);
-
-
-/**
- *	dpm_runtime_suspend - Put one device in low-power state.
- *	@dev:	Device.
- *	@state:	State to enter.
- */
-
-int dpm_runtime_suspend(struct device * dev, pm_message_t state)
-{
-	int error = 0;
-
-	mutex_lock(&dpm_mtx);
-	if (dev->power.power_state.event == state.event)
-		goto Done;
-
-	if (dev->power.power_state.event)
-		runtime_resume(dev);
-
-	if (!(error = suspend_device(dev, state)))
-		dev->power.power_state = state;
- Done:
-	mutex_unlock(&dpm_mtx);
-	return error;
-}
-EXPORT_SYMBOL(dpm_runtime_suspend);
-
-
-#if 0
-/**
- *	dpm_set_power_state - Update power_state field.
- *	@dev:	Device.
- *	@state:	Power state device is in.
- *
- *	This is an update mechanism for drivers to notify the core
- *	what power state a device is in. Device probing code may not
- *	always be able to tell, but we need accurate information to
- *	work reliably.
- */
-void dpm_set_power_state(struct device * dev, pm_message_t state)
-{
-	mutex_lock(&dpm_mtx);
-	dev->power.power_state = state;
-	mutex_unlock(&dpm_mtx);
-}
-#endif  /*  0  */
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 143c6ef..a996071 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1127,6 +1127,34 @@ static int pcmcia_bus_uevent(struct device *dev, char **envp, int num_envp,
 
 #endif
 
+/************************ runtime PM support ***************************/
+
+static int pcmcia_dev_suspend(struct device *dev, pm_message_t state);
+static int pcmcia_dev_resume(struct device *dev);
+
+static int runtime_suspend(struct device *dev)
+{
+	int rc;
+
+	down(&dev->sem);
+	rc = pcmcia_dev_suspend(dev, PMSG_SUSPEND);
+	up(&dev->sem);
+	if (!rc)
+		dev->power.power_state.event = PM_EVENT_SUSPEND;
+	return rc;
+}
+
+static void runtime_resume(struct device *dev)
+{
+	int rc;
+
+	down(&dev->sem);
+	rc = pcmcia_dev_resume(dev);
+	up(&dev->sem);
+	if (!rc)
+		dev->power.power_state.event = PM_EVENT_ON;
+}
+
 /************************ per-device sysfs output ***************************/
 
 #define pcmcia_device_attr(field, test, format)				\
@@ -1173,9 +1201,9 @@ static ssize_t pcmcia_store_pm_state(struct device *dev, struct device_attribute
                 return -EINVAL;
 
 	if ((!p_dev->suspended) && !strncmp(buf, "off", 3))
-		ret = dpm_runtime_suspend(dev, PMSG_SUSPEND);
+		ret = runtime_suspend(dev);
 	else if (p_dev->suspended && !strncmp(buf, "on", 2))
-		dpm_runtime_resume(dev);
+		runtime_resume(dev);
 
 	return ret ? ret : count;
 }
@@ -1312,10 +1340,10 @@ static int pcmcia_bus_suspend_callback(struct device *dev, void * _data)
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 
-	if (p_dev->socket != skt)
+	if (p_dev->socket != skt || p_dev->suspended)
 		return 0;
 
-	return dpm_runtime_suspend(dev, PMSG_SUSPEND);
+	return runtime_suspend(dev);
 }
 
 static int pcmcia_bus_resume_callback(struct device *dev, void * _data)
@@ -1323,10 +1351,10 @@ static int pcmcia_bus_resume_callback(struct device *dev, void * _data)
 	struct pcmcia_socket *skt = _data;
 	struct pcmcia_device *p_dev = to_pcmcia_dev(dev);
 
-	if (p_dev->socket != skt)
+	if (p_dev->socket != skt || !p_dev->suspended)
 		return 0;
 
-	dpm_runtime_resume(dev);
+	runtime_resume(dev);
 
 	return 0;
 }
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 273781c..2735b7c 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -284,8 +284,6 @@ extern int device_prepare_suspend(pm_message_t state);
 #define device_may_wakeup(dev) \
 	(device_can_wakeup(dev) && (dev)->power.should_wakeup)
 
-extern int dpm_runtime_suspend(struct device *, pm_message_t);
-extern void dpm_runtime_resume(struct device *);
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
@@ -317,15 +315,6 @@ static inline int device_suspend(pm_message_t state)
 #define device_set_wakeup_enable(dev,val)	do{}while(0)
 #define device_may_wakeup(dev)			(0)
 
-static inline int dpm_runtime_suspend(struct device * dev, pm_message_t state)
-{
-	return 0;
-}
-
-static inline void dpm_runtime_resume(struct device * dev)
-{
-}
-
 #define suspend_report_result(fn, ret) do { } while (0)
 
 static inline int call_platform_enable_wakeup(struct device *dev, int is_on)
-- 
1.5.2.2

