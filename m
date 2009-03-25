Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZCYApt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZCYApt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbZCYAa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:28 -0400
Received: from kroah.org ([198.145.64.141]:54167 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755461AbZCYAaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/61] driver core: remove polling for driver_probe_done(v5)
Date: Tue, 24 Mar 2009 17:26:47 -0700
Message-Id: <1237940825-22904-43-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/dd.c      |    8 ++------
 include/linux/device.h |    2 +-
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3f32df7..0dfd08c 100644
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
index d5706c4..c56b154 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -147,7 +147,7 @@ extern void put_driver(struct device_driver *drv);
 extern struct device_driver *driver_find(const char *name,
 					 struct bus_type *bus);
 extern int driver_probe_done(void);
-extern int wait_for_device_probe(void);
+extern void wait_for_device_probe(void);
 
 
 /* sysfs interface for exporting driver attributes */
-- 
1.6.2

