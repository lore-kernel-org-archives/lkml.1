Return-Path: <linux-kernel-owner+w=401wt.eu-S936465AbXGRX1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465AbXGRX1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936090AbXGRX0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:35 -0400
Received: from ns.suse.de ([195.135.220.2]:57414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761968AbXGRX0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/14] PM: Remove deprecated sysfs files
Date: Wed, 18 Jul 2007 16:25:39 -0700
Message-Id: <11848011593154-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011551094-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as932) removes the deprecated sysfs .../power/state
attribute files.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/feature-removal-schedule.txt |    3 +-
 drivers/base/power/sysfs.c                 |   66 ----------------------------
 kernel/power/Kconfig                       |   12 -----
 3 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d05e624..9cf9d83 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -26,8 +26,7 @@ Who:	Hans Verkuil <hverkuil@xs4all.nl> and
 
 ---------------------------
 
-What:	/sys/devices/.../power/state
-	dev->power.power_state
+What:	dev->power.power_state
 	dpm_runtime_{suspend,resume)()
 When:	July 2007
 Why:	Broken design for runtime control over driver power states, confusing
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index 2d47517..f2ed179 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -7,69 +7,6 @@
 #include "power.h"
 
 
-#ifdef	CONFIG_PM_SYSFS_DEPRECATED
-
-/**
- *	state - Control current power state of device
- *
- *	show() returns the current power state of the device. '0' indicates
- *	the device is on. Other values (2) indicate the device is in some low
- *	power state.
- *
- *	store() sets the current power state, which is an integer valued
- *	0, 2, or 3.  Devices with bus.suspend_late(), or bus.resume_early()
- *	methods fail this operation; those methods couldn't be called.
- *	Otherwise,
- *
- *	- If the recorded dev->power.power_state.event matches the
- *	  target value, nothing is done.
- *	- If the recorded event code is nonzero, the device is reactivated
- *	  by calling bus.resume() and/or class.resume().
- *	- If the target value is nonzero, the device is suspended by
- *	  calling class.suspend() and/or bus.suspend() with event code
- *	  PM_EVENT_SUSPEND.
- *
- *	This mechanism is DEPRECATED and should only be used for testing.
- */
-
-static ssize_t state_show(struct device * dev, struct device_attribute *attr, char * buf)
-{
-	if (dev->power.power_state.event)
-		return sprintf(buf, "2\n");
-	else
-		return sprintf(buf, "0\n");
-}
-
-static ssize_t state_store(struct device * dev, struct device_attribute *attr, const char * buf, size_t n)
-{
-	pm_message_t state;
-	int error = -EINVAL;
-
-	/* disallow incomplete suspend sequences */
-	if (dev->bus && (dev->bus->suspend_late || dev->bus->resume_early))
-		return error;
-
-	state.event = PM_EVENT_SUSPEND;
-	/* Older apps expected to write "3" here - confused with PCI D3 */
-	if ((n == 1) && !strcmp(buf, "3"))
-		error = dpm_runtime_suspend(dev, state);
-
-	if ((n == 1) && !strcmp(buf, "2"))
-		error = dpm_runtime_suspend(dev, state);
-
-	if ((n == 1) && !strcmp(buf, "0")) {
-		dpm_runtime_resume(dev);
-		error = 0;
-	}
-
-	return error ? error : n;
-}
-
-static DEVICE_ATTR(state, 0644, state_show, state_store);
-
-
-#endif	/* CONFIG_PM_SYSFS_DEPRECATED */
-
 /*
  *	wakeup - Report/change current wakeup option for device
  *
@@ -143,9 +80,6 @@ static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
 
 static struct attribute * power_attrs[] = {
-#ifdef	CONFIG_PM_SYSFS_DEPRECATED
-	&dev_attr_state.attr,
-#endif
 	&dev_attr_wakeup.attr,
 	NULL,
 };
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 495b7d4..7332847 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -65,18 +65,6 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
-config PM_SYSFS_DEPRECATED
-	bool "Driver model /sys/devices/.../power/state files (DEPRECATED)"
-	depends on PM && SYSFS
-	default n
-	help
-	  The driver model started out with a sysfs file intended to provide
-	  a userspace hook for device power management.  This feature has never
-	  worked very well, except for limited testing purposes, and so it will
-	  be removed.   It's not clear that a generic mechanism could really
-	  handle the wide variability of device power states; any replacements
-	  are likely to be bus or driver specific.
-
 config SOFTWARE_SUSPEND
 	bool "Software Suspend (Hibernation)"
 	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
-- 
1.5.2.2

