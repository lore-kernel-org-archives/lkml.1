Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbYAYH4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbYAYH4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761278AbYAYHgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761772AbYAYHgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 103/196] driver core: clean up device_shutdown
Date: Thu, 24 Jan 2008 23:32:12 -0800
Message-Id: <1201246425-5058-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_shutdown does not need to be in a separate file.  Move it into
the driver core file where it belongs.

This also moves us one more step closer to making devices_kset static,
now only the crazy sysdevs are keeping that from happening...

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c           |   20 ++++++++++++++++++-
 drivers/base/power/Makefile   |    1 -
 drivers/base/power/shutdown.c |   43 -----------------------------------------
 3 files changed, 19 insertions(+), 45 deletions(-)
 delete mode 100644 drivers/base/power/shutdown.c

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d2de2d5..b3a931f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1415,5 +1415,23 @@ out:
 	put_device(dev);
 	return error;
 }
-
 EXPORT_SYMBOL_GPL(device_move);
+
+/**
+ * device_shutdown - call ->shutdown() on each device to shutdown.
+ */
+void device_shutdown(void)
+{
+	struct device * dev, *devn;
+
+	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
+				kobj.entry) {
+		if (dev->bus && dev->bus->shutdown) {
+			dev_dbg(dev, "shutdown\n");
+			dev->bus->shutdown(dev);
+		} else if (dev->driver && dev->driver->shutdown) {
+			dev_dbg(dev, "shutdown\n");
+			dev->driver->shutdown(dev);
+		}
+	}
+}
diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 44504e6..06a86fe 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,4 +1,3 @@
-obj-y			:= shutdown.o
 obj-$(CONFIG_PM)	+= sysfs.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o
 obj-$(CONFIG_PM_TRACE)	+= trace.o
diff --git a/drivers/base/power/shutdown.c b/drivers/base/power/shutdown.c
deleted file mode 100644
index 5b6bc16..0000000
--- a/drivers/base/power/shutdown.c
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * shutdown.c - power management functions for the device tree.
- *
- * Copyright (c) 2002-3 Patrick Mochel
- *		 2002-3 Open Source Development Lab
- *
- * This file is released under the GPLv2
- *
- */
-
-#include <linux/device.h>
-#include <asm/semaphore.h>
-
-#include "../base.h"
-
-/**
- * We handle system devices differently - we suspend and shut them
- * down last and resume them first. That way, we don't do anything stupid like
- * shutting down the interrupt controller before any devices..
- *
- * Note that there are not different stages for power management calls -
- * they only get one called once when interrupts are disabled.
- */
-
-
-/**
- * device_shutdown - call ->shutdown() on each device to shutdown.
- */
-void device_shutdown(void)
-{
-	struct device * dev, *devn;
-
-	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
-		if (dev->bus && dev->bus->shutdown) {
-			dev_dbg(dev, "shutdown\n");
-			dev->bus->shutdown(dev);
-		} else if (dev->driver && dev->driver->shutdown) {
-			dev_dbg(dev, "shutdown\n");
-			dev->driver->shutdown(dev);
-		}
-	}
-}
-- 
1.5.3.8

