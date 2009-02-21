Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZBUIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZBUIp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 03:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZBUIpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 03:45:15 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:15352 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZBUIpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 03:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CIQO0xJ/A4TkLvt9VuFmojA7jrixp9FWqPG7f8+PwmyuhXmwsAdck3vZ/iN8nUikY/
         OmFKFsaTYRSwlHTcw0Sz136LghSgs12eSS2AhDreL6qo5gQdmeuBCExBXg1lYpP7y33+
         cxe2JT8m2O6Y6maAGm5/xp3C3JxZ7N5SALnic=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: cornelia.huck@de.ibm.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core: remove polling for driver_probe_done(v5)
Date: Sat, 21 Feb 2009 16:45:07 +0800
Message-Id: <1235205907-4420-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch removes 100ms polling for driver_probe_done in
wait_for_device_probe(), and uses wait_event() instead.
Removing polling in fs initialization may lead to
a faster boot.

This patch also changes the return type of wait_for_device_done()
from int to void.

This patch is against Arjan's patch in linux-next tree.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/dd.c      |    8 ++------
 include/linux/device.h |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 62a31b9..f17c326 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -172,16 +172,12 @@ int driver_probe_done(void)
 /**
  * wait_for_device_probe
  * Wait for device probing to be completed.
- *
- * Note: this function polls at 100 msec intervals.
  */
-int wait_for_device_probe(void)
+void wait_for_device_probe(void)
 {
 	/* wait for the known devices to complete their probing */
-	while (driver_probe_done() != 0)
-		msleep(100);
+	wait_event(probe_waitqueue, atomic_read(&probe_count) == 0);
 	async_synchronize_full();
-	return 0;
 }
 
 /**
diff --git a/include/linux/device.h b/include/linux/device.h
index f6d6270..723e7b2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -148,7 +148,7 @@ extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
-extern int wait_for_device_probe(void);
+extern void wait_for_device_probe(void);
 
 
 /* sysfs interface for exporting driver attributes */
-- 
1.6.0.GIT

