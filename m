Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZA3CcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZA3CcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:32:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZA3Cbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:31:55 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:57259 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZA3Cby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jNrVTs7idFr7dJVxk/ETLNXTfT5ZlZ1XqURTKglcwJJVXr/86QIPTF7NKCUcJn/Ztm
         6iv+AjVJFWPqdGyts4LG76DZrlhb9usk5d762/ifcVoqsgw0BEnUP6igBDypkYRajL4R
         QkXLtMydDNaBwmfDf3GCDjvpM9NT7DntquxNw=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: remove polling for driver_probe_done(v2)
Date: Fri, 30 Jan 2009 10:31:42 +0800
Message-Id: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch renames driver_probe_done to driver_wait_probe_done,
and make it wait on condition of probing done to remove
polling for it in fs initialization. Also add
driver_wait_probe_done_and_dev_appear(name) to allow callers
to wait until all probing is done AND until the device @name
exists.

Removing polling in fs initialization may lead to a faster boot.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/dd.c      |   26 +++++++++++++++++++-------
 include/linux/device.h |    3 ++-
 init/do_mounts.c       |    9 ++++-----
 init/do_mounts_md.c    |    5 +++--
 4 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9b721d3..ab8c30f 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/wait.h>
+#include <linux/mount.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -153,21 +154,32 @@ done:
 }
 
 /**
- * driver_probe_done
- * Determine if the probe sequence is finished or not.
+ * driver_probe_wait_done
+ * wait until the probe sequence is finished.
  *
- * Should somehow figure out how to use a semaphore, not an atomic variable...
  */
-int driver_probe_done(void)
+void driver_wait_probe_done(void)
 {
 	pr_debug("%s: probe_count = %d\n", __func__,
 		 atomic_read(&probe_count));
-	if (atomic_read(&probe_count))
-		return -EBUSY;
-	return 0;
+
+	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 }
 
 /**
+ * driver_wait_probe_done_and_dev_appear
+ * wait until the probe sequence is finished _and_ the dev @name appears.
+ *
+ */
+void driver_wait_probe_done_and_dev_appear(char *name)
+{
+	pr_debug("%s: probe_count = %d\n", __func__,
+		 atomic_read(&probe_count));
+
+	wait_event(probe_waitqueue, (atomic_read(&probe_count) == 0) &&
+		  name_to_dev_t(name));
+}
+/**
  * driver_probe_device - attempt to bind device & driver together
  * @drv: driver to bind a device to
  * @dev: device to try to bind to the driver
diff --git a/include/linux/device.h b/include/linux/device.h
index 45e5b19..7e2e138 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -146,7 +146,8 @@ extern struct device_driver *get_driver(struct device_driver *drv);
 extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
-extern int driver_probe_done(void);
+extern void driver_wait_probe_done(void);
+extern void driver_wait_probe_done_and_dev_appear(char *name);
 
 /* sysfs interface for exporting driver attributes */
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 708105e..1bf34fc 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -371,8 +371,8 @@ void __init prepare_namespace(void)
 	}
 
 	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
+	driver_wait_probe_done();
+
 	async_synchronize_full();
 
 	md_run_setup();
@@ -396,9 +396,8 @@ void __init prepare_namespace(void)
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
 			saved_root_name);
-		while (driver_probe_done() != 0 ||
-			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(100);
+		driver_wait_probe_done_and_dev_appear(saved_root_name);
+		ROOT_DEV = name_to_dev_t(saved_root_name);
 	}
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index ff95e31..bcea03b 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -281,8 +281,9 @@ static void __init autodetect_raid(void)
 	 */
 	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
-	while (driver_probe_done() < 0)
-		msleep(100);
+
+	driver_wait_probe_done();
+
 	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-- 
1.6.0

