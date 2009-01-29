Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbZA2PPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbZA2PPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZA2PPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:15:19 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:53191 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbZA2PPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NaGAGvoJVHIncB5ckFhqQ5bdgTZqDKqwikRH4++sDgh3dxhAejvp7damDgnHGYvTGP
         U1JgehGnO1nc6IKI6yQB1HcpHnwI0e5MqzE7QplEErEjXvqzfYA5fdoYQDbV9SSonr2T
         a+n3hIry+dg3h8Ap/kG1jjRcw9sFYO2WEl9mo=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: remove polling for driver_probe_done
Date: Thu, 29 Jan 2009 23:15:10 +0800
Message-Id: <1233242110-5422-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch renames driver_probe_done to driver_probe_wait_done,
and make it wait on condition variable of probe done to remove
polling for it in fs initialization.

Removing polling in fs initialization may lead to a faster boot.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/base/dd.c      |   12 +++++-------
 include/linux/device.h |    2 +-
 init/do_mounts.c       |   10 +++++-----
 init/do_mounts_md.c    |    5 +++--
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9b721d3..ee998ca 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -153,18 +153,16 @@ done:
 }
 
 /**
- * driver_probe_done
- * Determine if the probe sequence is finished or not.
+ * driver_probe_wait_done
+ * wait the probe sequence to be finished.
  *
- * Should somehow figure out how to use a semaphore, not an atomic variable...
  */
-int driver_probe_done(void)
+void driver_probe_wait_done(void)
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
diff --git a/include/linux/device.h b/include/linux/device.h
index 45e5b19..20b50c4 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -146,7 +146,7 @@ extern struct device_driver *get_driver(struct device_driver *drv);
 extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
-extern int driver_probe_done(void);
+extern void driver_probe_wait_done(void);
 
 /* sysfs interface for exporting driver attributes */
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 708105e..ce46c38 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -371,8 +371,8 @@ void __init prepare_namespace(void)
 	}
 
 	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
+	driver_probe_wait_done();
+
 	async_synchronize_full();
 
 	md_run_setup();
@@ -396,9 +396,9 @@ void __init prepare_namespace(void)
 	if ((ROOT_DEV == 0) && root_wait) {
 		printk(KERN_INFO "Waiting for root device %s...\n",
 			saved_root_name);
-		while (driver_probe_done() != 0 ||
-			(ROOT_DEV = name_to_dev_t(saved_root_name)) == 0)
-			msleep(100);
+		ROOT_DEV = name_to_dev_t(saved_root_name);
+		if (ROOT_DEV)
+			driver_probe_wait_done();
 	}
 
 	is_floppy = MAJOR(ROOT_DEV) == FLOPPY_MAJOR;
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index ff95e31..e9a4e54 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -281,8 +281,9 @@ static void __init autodetect_raid(void)
 	 */
 	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
-	while (driver_probe_done() < 0)
-		msleep(100);
+
+	driver_probe_wait_done();
+
 	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-- 
1.6.0

