Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZAJFN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZAJFN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZAJFM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:12:56 -0500
Received: from casper.infradead.org ([85.118.1.10]:44961 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbZAJFMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:12:55 -0500
Date: Fri, 9 Jan 2009 21:13:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH 1/2] consolidate driver_probe_done() loops into one place
Message-ID: <20090109211346.3ccc36e3@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 11b47973023398ecdb933c442bab120906946762 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 9 Jan 2009 21:04:53 -0800
Subject: [PATCH] consolidate driver_probe_done() loops into one place

there's a few places that currently loop over driver_probe_done(), and
I'm about to add another one. This patch abstracts it into a helper
to reduce duplication.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/dd.c      |   16 ++++++++++++++++
 include/linux/device.h |    2 ++
 init/do_mounts.c       |   13 +++++++++----
 init/do_mounts_md.c    |    5 +++--
 4 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 315bed8..b911fab 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
+#include <linux/async.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -168,6 +169,21 @@ int driver_probe_done(void)
 }
 
 /**
+ * wait_for_device_probe
+ * Wait for device probing to be completed.
+ *
+ * Note: this function polls at 100 msec intervals.
+ */
+int wait_for_device_probe(void)
+{
+	/* wait for the known devices to complete their probing */
+	while (driver_probe_done() != 0)
+		msleep(100);
+	async_synchronize_full();
+	return 0;
+}
+
+/**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
diff --git a/include/linux/device.h b/include/linux/device.h
index 45e5b19..47f343c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -147,6 +147,8 @@ extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
+extern int wait_for_device_probe(void);
+
 
 /* sysfs interface for exporting driver attributes */
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 708105e..2c80113 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -370,10 +370,14 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
-	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
-	async_synchronize_full();
+	/* 
+	 * wait for the known devices to complete their probing 
+	 *
+	 * Note: this is a potential source of long boot delays.
+	 * For example, it is not atypical to wait 5 seconds here
+	 * for the touchpad of a laptop to initialize.
+	 */
+	wait_for_device_probe();
 
 	md_run_setup();
 
@@ -399,6 +403,7 @@ void __init prepare_namespace(void)
 		while (driver_probe_done() != 0 ||
 			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
 			msleep(100);
+		async_synchronize_full();
 	}
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index ff95e31..9bdddbc 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -281,8 +281,9 @@ static void __init autodetect_raid(void)
 	 */
 	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
-	while (driver_probe_done() < 0)
-		msleep(100);
+
+	wait_for_device_probe();
+
 	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
