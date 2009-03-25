Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbZCYAoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbZCYAoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZCYAaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:24 -0400
Received: from kroah.org ([198.145.64.141]:54155 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756825AbZCYAaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/61] driver-core: do not register a driver with bus_type not registered
Date: Tue, 24 Mar 2009 17:26:44 -0700
Message-Id: <1237940825-22904-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

If the bus_type is not registerd, driver_register to that bus will cause oops.

I found this bug when test built-in usb serial drivers (ie. aircable driver)
with 'nousb' cmdline params.

In this patch:
1. set the bus->p=NULL when bus_register failed and unregisterd.
2. if bus->p is NULL, driver_register BUG_ON will be triggered.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c    |    2 ++
 drivers/base/driver.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 8547b78..11463c0 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -932,6 +932,7 @@ bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
 	kfree(bus->p);
 out:
+	bus->p = NULL;
 	return retval;
 }
 EXPORT_SYMBOL_GPL(bus_register);
@@ -953,6 +954,7 @@ void bus_unregister(struct bus_type *bus)
 	bus_remove_file(bus, &bus_attr_uevent);
 	kset_unregister(&bus->p->subsys);
 	kfree(bus->p);
+	bus->p = NULL;
 }
 EXPORT_SYMBOL_GPL(bus_unregister);
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 1e2bda7..2889ad5 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -216,6 +216,8 @@ int driver_register(struct device_driver *drv)
 	int ret;
 	struct device_driver *other;
 
+	BUG_ON(!drv->bus->p);
+
 	if ((drv->bus->probe && drv->probe) ||
 	    (drv->bus->remove && drv->remove) ||
 	    (drv->bus->shutdown && drv->shutdown))
-- 
1.6.2

