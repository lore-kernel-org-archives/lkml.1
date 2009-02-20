Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZBTORq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZBTORq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBTORe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:17:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:62365 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZBTORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:17:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xiYHu4gjBhxfTTlXgFIMsHE5CrsAzyty5fPhCCIH+Ut93qvcMwVZGG/WidTX8EwV4Q
         VN/UchO7LEzC/qp+Rd+k5w8J9Bj/0U4dIqa34mjE/BOXVQCtesOVI1Hx7yeTP3JC2emQ
         jQPhBUTv5SQ/FfAvt0NvbYedoetmynWzGubs0=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: cornelia.huck@de.ibm.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] [PATCH/RESEND] driver core: remove polling for driver_probe_done(v4)
Date: Fri, 20 Feb 2009 22:17:27 +0800
Message-Id: <1235139447-5829-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch adds a function : driver_wait_probe_done,
which waits on condition of probing done to replace
polling for driver_probe_done in fs initialization.

There is no better way to avoid polling for
driver_probe_done _and_ existence of the root device,
so we does not replace the driver_probe_done with
driver_wait_probe_done in such special case.

Removing polling in fs initialization may lead to
a faster boot.

This patch is against the latest linux-next tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/dd.c      |   15 ++++++---------
 include/linux/device.h |    2 +-
 init/do_mounts.c       |    2 +-
 init/do_mounts_md.c    |    2 +-
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 62a31b9..fef201c 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -170,18 +170,15 @@ int driver_probe_done(void)
 }
 
 /**
- * wait_for_device_probe
- * Wait for device probing to be completed.
+ * driver_wait_probe_done
+ * Wait until the probe sequence is finished.
  *
- * Note: this function polls at 100 msec intervals.
  */
-int wait_for_device_probe(void)
+void driver_wait_probe_done(void)
 {
-	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
-	async_synchronize_full();
-	return 0;
+	pr_debug("%s: probe_count = %d\n", __func__,
+		 atomic_read(&probe_count));
+	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 }
 
 /**
diff --git a/include/linux/device.h b/include/linux/device.h
index f6d6270..4527064 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -148,7 +148,7 @@ extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
-extern int wait_for_device_probe(void);
+extern void driver_wait_probe_done(void);
 
 
 /* sysfs interface for exporting driver attributes */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 8d4ff5a..01be2cd 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -377,7 +377,7 @@ void __init prepare_namespace(void)
 	 * For example, it is not atypical to wait 5 seconds here
 	 * for the touchpad of a laptop to initialize.
 	 */
-	wait_for_device_probe();
+	driver_wait_probe_done();
 
 	md_run_setup();
 
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 9bdddbc..bcea03b 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -282,7 +282,7 @@ static void __init autodetect_raid(void)
 	printk(KERN_INFO "md: Waiting for all devices to be available before autodetect\n");
 	printk(KERN_INFO "md: If you don't use raid, use raid=noautodetect\n");
 
-	wait_for_device_probe();
+	driver_wait_probe_done();
 
 	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
-- 
1.6.0.GIT

