Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbXJLWSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbXJLWSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbXJLWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:17:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:49583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760777AbXJLWRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:17:46 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/75] Driver core: make sysfs uevent-attributes static
Date: Fri, 12 Oct 2007 15:16:07 -0700
Message-Id: <11922274503271-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274441634-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Attributes do not have an owner(module) anymore, so there is no need
to carry the attributes in every single bus instance.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c     |   21 +++++++++------------
 include/linux/device.h |    2 --
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 61c6752..ff850d1 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -568,32 +568,29 @@ static void remove_bind_files(struct device_driver *drv)
 	driver_remove_file(drv, &driver_attr_unbind);
 }
 
+static BUS_ATTR(drivers_probe, S_IWUSR, NULL, store_drivers_probe);
+static BUS_ATTR(drivers_autoprobe, S_IWUSR | S_IRUGO,
+		show_drivers_autoprobe, store_drivers_autoprobe);
+
 static int add_probe_files(struct bus_type *bus)
 {
 	int retval;
 
-	bus->drivers_probe_attr.attr.name = "drivers_probe";
-	bus->drivers_probe_attr.attr.mode = S_IWUSR;
-	bus->drivers_probe_attr.store = store_drivers_probe;
-	retval = bus_create_file(bus, &bus->drivers_probe_attr);
+	retval = bus_create_file(bus, &bus_attr_drivers_probe);
 	if (retval)
 		goto out;
 
-	bus->drivers_autoprobe_attr.attr.name = "drivers_autoprobe";
-	bus->drivers_autoprobe_attr.attr.mode = S_IWUSR | S_IRUGO;
-	bus->drivers_autoprobe_attr.show = show_drivers_autoprobe;
-	bus->drivers_autoprobe_attr.store = store_drivers_autoprobe;
-	retval = bus_create_file(bus, &bus->drivers_autoprobe_attr);
+	retval = bus_create_file(bus, &bus_attr_drivers_autoprobe);
 	if (retval)
-		bus_remove_file(bus, &bus->drivers_probe_attr);
+		bus_remove_file(bus, &bus_attr_drivers_probe);
 out:
 	return retval;
 }
 
 static void remove_probe_files(struct bus_type *bus)
 {
-	bus_remove_file(bus, &bus->drivers_autoprobe_attr);
-	bus_remove_file(bus, &bus->drivers_probe_attr);
+	bus_remove_file(bus, &bus_attr_drivers_autoprobe);
+	bus_remove_file(bus, &bus_attr_drivers_probe);
 }
 #else
 static inline int add_bind_files(struct device_driver *drv) { return 0; }
diff --git a/include/linux/device.h b/include/linux/device.h
index 3a38d1f..5d97ca6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -64,8 +64,6 @@ struct bus_type {
 	struct bus_attribute	* bus_attrs;
 	struct device_attribute	* dev_attrs;
 	struct driver_attribute	* drv_attrs;
-	struct bus_attribute drivers_autoprobe_attr;
-	struct bus_attribute drivers_probe_attr;
 
 	int		(*match)(struct device * dev, struct device_driver * drv);
 	int		(*uevent)(struct device *dev, char **envp,
-- 
1.5.3.4

