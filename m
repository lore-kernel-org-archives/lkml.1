Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbXLUJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbXLUJwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 04:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXLUJwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 04:52:11 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:38919 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbXLUJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 04:52:06 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, akpm@linux-foundation.org, paulus@samba.org,
       galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 2/3] (Resend part #2) Add RapidIO memory mapping API and simple Bitmap allocation.
Date: Fri, 21 Dec 2007 18:01:15 +0800
Message-Id: <11982312752374-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.2
X-OriginalArrivalTime: 21 Dec 2007 09:51:05.0759 (UTC) FILETIME=[0128DAF0:01C843B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO memory mapping API and simple Bitmap allocation with fixed size.
Some bugs are fixed.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/rapidio/Kconfig             |   18 +-
 drivers/rapidio/Makefile            |    1 +
 drivers/rapidio/rio-access.c        |   10 +-
 drivers/rapidio/rio-scan.c          |   53 +++--
 drivers/rapidio/rio-sysfs.c         |    3 +-
 drivers/rapidio/rio.c               |  486 ++++++++++++++++++++++++++++++++++-
 drivers/rapidio/rio.h               |    9 +-
 drivers/rapidio/sallocator/Kconfig  |    9 +
 drivers/rapidio/sallocator/Makefile |   12 +
 drivers/rapidio/sallocator/bitmap.c |  383 +++++++++++++++++++++++++++
 10 files changed, 944 insertions(+), 40 deletions(-)
 create mode 100644 drivers/rapidio/sallocator/Kconfig
 create mode 100644 drivers/rapidio/sallocator/Makefile
 create mode 100644 drivers/rapidio/sallocator/bitmap.c

diff --git a/drivers/rapidio/Kconfig b/drivers/rapidio/Kconfig
index 4142115..f669108 100644
--- a/drivers/rapidio/Kconfig
+++ b/drivers/rapidio/Kconfig
@@ -1,14 +1,6 @@
 #
 # RapidIO configuration
 #
-config RAPIDIO_8_BIT_TRANSPORT
-	bool "8-bit transport addressing"
-	depends on RAPIDIO
-	---help---
-	  By default, the kernel assumes a 16-bit addressed RapidIO
-	  network. By selecting this option, the kernel will support
-	  an 8-bit addressed network.
-
 config RAPIDIO_DISC_TIMEOUT
 	int "Discovery timeout duration (seconds)"
 	depends on RAPIDIO
@@ -16,3 +8,13 @@ config RAPIDIO_DISC_TIMEOUT
 	---help---
 	  Amount of time a discovery node waits for a host to complete
 	  enumeration before giving up.
+
+config RAPIDIO_PROC_FS
+	bool "I/O and Memory resource debug"
+	depends on RAPIDIO && PROC_FS
+	default y
+	---help---
+	  Enable this option, it will create a /proc/riores node for
+	  monitoring the RapidIO I/O and Memory resource.
+
+source "drivers/rapidio/sallocator/Kconfig"
diff --git a/drivers/rapidio/Makefile b/drivers/rapidio/Makefile
index 7c0e181..e5b2f11 100644
--- a/drivers/rapidio/Makefile
+++ b/drivers/rapidio/Makefile
@@ -4,3 +4,4 @@
 obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
+obj-$(CONFIG_RAPIDIO)		+= sallocator/
diff --git a/drivers/rapidio/rio-access.c b/drivers/rapidio/rio-access.c
index 8b56bbd..a3824ba 100644
--- a/drivers/rapidio/rio-access.c
+++ b/drivers/rapidio/rio-access.c
@@ -48,7 +48,7 @@ int __rio_local_read_config_##size \
 	u32 data = 0;							\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->lcread(mport->id, offset, len, &data);	\
+	res = mport->ops->lcread(mport, mport->id, offset, len, &data);	\
 	*value = (type)data;						\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
@@ -71,7 +71,7 @@ int __rio_local_write_config_##size \
 	unsigned long flags;						\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->lcwrite(mport->id, offset, len, value);	\
+	res = mport->ops->lcwrite(mport, mport->id, offset, len, value);\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
 }
@@ -108,7 +108,7 @@ int rio_mport_read_config_##size \
 	u32 data = 0;							\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->cread(mport->id, destid, hopcount, offset, len, &data); \
+	res = mport->ops->cread(mport, mport->id, destid, hopcount, offset, len, &data); \
 	*value = (type)data;						\
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
@@ -131,7 +131,7 @@ int rio_mport_write_config_##size \
 	unsigned long flags;						\
 	if (RIO_##size##_BAD) return RIO_BAD_SIZE;			\
 	spin_lock_irqsave(&rio_config_lock, flags);			\
-	res = mport->ops->cwrite(mport->id, destid, hopcount, offset, len, value); \
+	res = mport->ops->cwrite(mport, mport->id, destid, hopcount, offset, len, value); \
 	spin_unlock_irqrestore(&rio_config_lock, flags);		\
 	return res;							\
 }
@@ -166,7 +166,7 @@ int rio_mport_send_doorbell(struct rio_mport *mport, u16 destid, u16 data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rio_doorbell_lock, flags);
-	res = mport->ops->dsend(mport->id, destid, data);
+	res = mport->ops->dsend(mport, mport->id, destid, data);
 	spin_unlock_irqrestore(&rio_doorbell_lock, flags);
 
 	return res;
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 4442072..9d52e9b 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -73,7 +73,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DID_CSR, &result);
 
-	return RIO_GET_DID(result);
+	return RIO_GET_DID(port->sys_size, result);
 }
 
 /**
@@ -88,7 +88,7 @@ static u16 rio_get_device_id(struct rio_mport *port, u16 destid, u8 hopcount)
 static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u16 did)
 {
 	rio_mport_write_config_32(port, destid, hopcount, RIO_DID_CSR,
-				  RIO_SET_DID(did));
+				  RIO_SET_DID(port->sys_size, did));
 }
 
 /**
@@ -100,7 +100,8 @@ static void rio_set_device_id(struct rio_mport *port, u16 destid, u8 hopcount, u
  */
 static void rio_local_set_device_id(struct rio_mport *port, u16 did)
 {
-	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(did));
+	rio_local_write_config_32(port, RIO_DID_CSR, RIO_SET_DID(port->sys_size,
+				did));
 }
 
 /**
@@ -350,8 +351,17 @@ static struct rio_dev *rio_setup_device(struct rio_net *net,
 		rswitch->switchid = next_switchid;
 		rswitch->hopcount = hopcount;
 		rswitch->destid = destid;
+		if (!(rswitch->route_table = kzalloc(sizeof(u16)*
+					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
+					GFP_KERNEL))) {
+			kfree(rdev);
+			rdev = NULL;
+			kfree(rswitch);
+			goto out;
+		}
 		/* Initialize switch route table */
-		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES; rdid++)
+		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES(port->sys_size);
+				rdid++)
 			rswitch->route_table[rdid] = RIO_INVALID_ROUTE;
 		rdev->rswitch = rswitch;
 		sprintf(rio_name(rdev), "%02x:s:%04x", rdev->net->id,
@@ -480,7 +490,7 @@ static u16 rio_get_host_deviceid_lock(struct rio_mport *port, u8 hopcount)
 {
 	u32 result;
 
-	rio_mport_read_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_read_config_32(port, RIO_ANY_DESTID(port->sys_size), hopcount,
 				 RIO_HOST_DID_LOCK_CSR, &result);
 
 	return (u16) (result & 0xffff);
@@ -571,14 +581,16 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Attempt to acquire device lock */
-	rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+	rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+				  hopcount,
 				  RIO_HOST_DID_LOCK_CSR, port->host_deviceid);
 	while ((tmp = rio_get_host_deviceid_lock(port, hopcount))
 	       < port->host_deviceid) {
 		/* Delay a bit */
 		mdelay(1);
 		/* Attempt to acquire device lock again */
-		rio_mport_write_config_32(port, RIO_ANY_DESTID, hopcount,
+		rio_mport_write_config_32(port, RIO_ANY_DESTID(port->sys_size),
+					  hopcount,
 					  RIO_HOST_DID_LOCK_CSR,
 					  port->host_deviceid);
 	}
@@ -590,7 +602,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 	}
 
 	/* Setup new RIO device */
-	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID, hopcount, 1))) {
+	if ((rdev = rio_setup_device(net, port, RIO_ANY_DESTID(port->sys_size),
+					hopcount, 1))) {
 		/* Add device to the global and bus/net specific list. */
 		list_add_tail(&rdev->net_list, &net->devices);
 	} else
@@ -598,7 +611,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 
 	if (rio_is_switch(rdev)) {
 		next_switchid++;
-		sw_inport = rio_get_swpinfo_inport(port, RIO_ANY_DESTID, hopcount);
+		sw_inport = rio_get_swpinfo_inport(port,
+				RIO_ANY_DESTID(port->sys_size), hopcount);
 		rio_route_add_entry(port, rdev->rswitch, RIO_GLOBAL_TABLE,
 				    port->host_deviceid, sw_inport);
 		rdev->rswitch->route_table[port->host_deviceid] = sw_inport;
@@ -612,7 +626,8 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 		}
 
 		num_ports =
-		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID, hopcount);
+		    rio_get_swpinfo_tports(port, RIO_ANY_DESTID(port->sys_size),
+						hopcount);
 		pr_debug(
 		    "RIO: found %s (vid %4.4x did %4.4x) with %d ports\n",
 		    rio_name(rdev), rdev->vid, rdev->did, num_ports);
@@ -624,13 +639,15 @@ static int rio_enum_peer(struct rio_net *net, struct rio_mport *port,
 			cur_destid = next_destid;
 
 			if (rio_sport_is_active
-			    (port, RIO_ANY_DESTID, hopcount, port_num)) {
+			    (port, RIO_ANY_DESTID(port->sys_size), hopcount,
+			     port_num)) {
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
 				rio_route_add_entry(port, rdev->rswitch,
 						    RIO_GLOBAL_TABLE,
-						    RIO_ANY_DESTID, port_num);
+						    RIO_ANY_DESTID(port->sys_size),
+						    port_num);
 
 				if (rio_enum_peer(net, port, hopcount + 1) < 0)
 					return -1;
@@ -735,7 +752,8 @@ rio_disc_peer(struct rio_net *net, struct rio_mport *port, u16 destid,
 				pr_debug(
 				    "RIO: scanning device on port %d\n",
 				    port_num);
-				for (ndestid = 0; ndestid < RIO_ANY_DESTID;
+				for (ndestid = 0;
+				     ndestid < RIO_ANY_DESTID(port->sys_size);
 				     ndestid++) {
 					rio_route_get_entry(port, rdev->rswitch,
 							    RIO_GLOBAL_TABLE,
@@ -796,7 +814,7 @@ static int rio_mport_is_active(struct rio_mport *port)
  * network list of associated master ports. Returns a
  * RIO network pointer on success or %NULL on failure.
  */
-static struct rio_net __devinit *rio_alloc_net(struct rio_mport *port)
+static struct rio_net *rio_alloc_net(struct rio_mport *port)
 {
 	struct rio_net *net;
 
@@ -917,7 +935,9 @@ static void rio_build_route_tables(void)
 
 	list_for_each_entry(rdev, &rio_devices, global_list)
 	    if (rio_is_switch(rdev))
-		for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+		for (i = 0;
+		     i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+		     i++) {
 			if (rio_route_get_entry
 			    (rdev->net->hport, rdev->rswitch, RIO_GLOBAL_TABLE,
 			     i, &sport) < 0)
@@ -981,7 +1001,8 @@ int rio_disc_mport(struct rio_mport *mport)
 		del_timer_sync(&rio_enum_timer);
 
 		pr_debug("done\n");
-		if (rio_disc_peer(net, mport, RIO_ANY_DESTID, 0) < 0) {
+		if (rio_disc_peer(net, mport, RIO_ANY_DESTID(mport->sys_size),
+					0) < 0) {
 			printk(KERN_INFO
 			       "RIO: master port %d device has failed discovery\n",
 			       mport->id);
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 659e311..97a147f 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -43,7 +43,8 @@ static ssize_t routes_show(struct device *dev, struct device_attribute *attr, ch
 	if (!rdev->rswitch)
 		goto out;
 
-	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES; i++) {
+	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
+			i++) {
 		if (rdev->rswitch->route_table[i] == RIO_INVALID_ROUTE)
 			continue;
 		str +=
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index f644807..c3b3c7e 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -2,9 +2,16 @@
  * RapidIO interconnect services
  * (RapidIO Interconnect Specification, http://www.rapidio.org)
  *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
+ * Changelog:
+ * Jun 2007 Zhang Wei <wei.zhang@freescale.com>
+ * - Add memory mapping support.
+ *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
@@ -23,10 +30,22 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/dma-mapping.h>
+#include <linux/hardirq.h>
 
 #include "rio.h"
 
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "%s:%s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+
 static LIST_HEAD(rio_mports);
+static LIST_HEAD(rio_inb_mems);
+static LIST_HEAD(rio_outb_mems);
+
+static DEFINE_SPINLOCK(rio_config_lock);
 
 /**
  * rio_local_get_device_id - Get the base/extended device id for a port
@@ -42,7 +61,7 @@ u16 rio_local_get_device_id(struct rio_mport *port)
 
 	rio_local_read_config_32(port, RIO_DID_CSR, &result);
 
-	return (RIO_GET_DID(result));
+	return (RIO_GET_DID(port->sys_size, result));
 }
 
 /**
@@ -332,6 +351,350 @@ int rio_release_outb_dbell(struct rio_dev *rdev, struct resource *res)
 }
 
 /**
+ * rio_request_io_region -- request resource in RapidIO IO region
+ * @mport: Master port
+ * @devid: Device specific pointer to pass
+ * @start: IO resource start address
+ * @size: IO resource size
+ * @name: Resource name
+ * @flag: Flag for resource
+ * @res: Return resource which has been allocated. If res == NULL,
+ *       the function will alloc the memory for return resource.
+ *
+ * Return: The resource which has been allocated.
+ */
+struct resource *rio_request_io_region(struct rio_mport *mport, void *devid,
+		resource_size_t start, resource_size_t size,
+		const char *name, unsigned long flags,
+		struct resource *res)
+{
+	if (!res && !(res = kmalloc(sizeof(struct resource), GFP_KERNEL))) {
+		ERR("No free memory for res alloc!\n");
+		goto err;
+	}
+	memset(res, 0, sizeof(struct resource));
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* if start == 0 then auto locate the start address */
+	if (!start) {
+		if (allocate_resource(&mport->iores, res, size,
+				mport->iores.start, mport->iores.end,
+				size, NULL, NULL) < 0) {
+			ERR("allocte resource error!\n");
+			goto err;
+		}
+		res->name = name;
+		res->flags = flags;
+	} else {
+		rio_init_io_res(res, start, start + size - 1, name, flags);
+		if (request_resource(&mport->iores, res) < 0) {
+			ERR("Can't get SRIO IO resource!\n");
+			goto err;
+		}
+	}
+	return res;
+
+err:
+	if (res)
+		kfree(res);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(rio_request_io_region);
+
+/**
+ * rio_map_inb_region -- Mapping inbound memory region.
+ * @mport: Master port.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from the mem->riores to mem->iores.
+ */
+int rio_map_inb_region(struct rio_mport *mport, struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_inb(mport, mem->iores.start, mem->riores.start, mem->size, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_map_outb_region -- Mapping outbound memory region.
+ * @mport: Master port.
+ * @tid: Target RapidIO device id.
+ * @mem: Memory struction for mapping.
+ * @rflags: Flags for mapping.
+ *
+ * Return: 0 -- Success.
+ *
+ * This function will create the mapping from the mem->iores to mem->riores.
+ */
+int rio_map_outb_region(struct rio_mport *mport, u16 tid,
+		struct rio_mem *mem, u32 rflags)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	if (!mport->mops)
+		return -1;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	rc = mport->mops->map_outb(mport, mem->iores.start, mem->riores.start, mem->size, tid, rflags);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+	return rc;
+}
+
+/**
+ * rio_unmap_inb_region -- Unmap the inbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_inb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_unmap_outb_region -- Unmap the outbound memory region
+ * @mport: Master port
+ * @mem: Memory struction for unmapping.
+ */
+void rio_unmap_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	unsigned long flags;
+	if (!mport->mops)
+		return;
+	spin_lock_irqsave(&rio_config_lock, flags);
+	mport->mops->unmap_outb(mport, mem->iores.start);
+	spin_unlock_irqrestore(&rio_config_lock, flags);
+}
+
+/**
+ * rio_release_inb_region -- Release the inbound region resource.
+ * @mport: Master port
+ * @mem: Inbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_inb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_inb_region(mport, mem);
+	if (mem->virt)
+		dma_free_coherent(NULL, mem->size, mem->virt, mem->iores.start);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/**
+ * rio_request_inb_region -- Request inbound memory region
+ * @mport: Master port
+ * @dev_id: Device specific pointer to pass
+ * @size: The request memory windows size
+ * @name: The region name
+ * @owner: The region owner driver id
+ *
+ * Retrun: The rio_mem struction for inbound memory descriptor.
+ *
+ * This function is used for request RapidIO space inbound region. If the size
+ * less than 4096 or not aligned to 2^N, it will be adjusted. The function will
+ * alloc a block of local DMA memory of the size for inbound region target and
+ * request a RapidIO region for inbound region source. Then the inbound region
+ * will be claimed in RapidIO space and the local DMA memory will be added to
+ * local inbound memory list. The rio_mem with the inbound relationship will
+ * be returned.
+ */
+struct rio_mem *rio_request_inb_region(struct rio_mport *mport, void *dev_id,
+		resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	int ret;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Alloc the RapidIO space */
+	ret = rio_space_request(mport, size, &rmem->riores);
+	if (ret) {
+		printk(KERN_ERR "RIO space request error! ret = %d\n", ret);
+		goto err;
+	}
+
+	rmem->riores.name = name;
+	rmem->size = rmem->riores.end - rmem->riores.start + 1;
+
+	/* Initialize inbound memory */
+	if (!(rmem->virt = dma_alloc_coherent(NULL, rmem->size,
+				&rmem->iores.start, GFP_KERNEL))) {
+		ERR("Inbound memory alloc error\n");
+		goto err;
+	}
+	rmem->iores.end = rmem->iores.start + rmem->size - 1;
+	rmem->owner = owner;
+
+	/* Map RIO space to local DMA memory */
+	if ((ret = rio_map_inb_region(mport, rmem, 0))) {
+		printk(KERN_ERR "RIO map inbound mem error, ret = %d\n", ret);
+		goto err;
+	}
+
+	/* Claim the region */
+	if ((ret = rio_space_claim(rmem))) {
+		printk(KERN_ERR "RIO inbound mem claim error, ret = %d\n", ret);
+		goto err;
+	}
+	list_add(&rmem->node, &rio_inb_mems);
+
+	return rmem;
+
+err:
+	rio_release_inb_region(mport, rmem);
+	return NULL;
+}
+
+/**
+ * rio_release_outb_region -- Release the outbound region resource.
+ * @mport: Master port
+ * @mem: Outbound region descriptor
+ *
+ * Return 0 is successed.
+ */
+int rio_release_outb_region(struct rio_mport *mport, struct rio_mem *mem)
+{
+	int rc = 0;
+	if (!mem)
+		return rc;
+	rio_unmap_outb_region(mport, mem);
+	rio_space_release(mem);
+	if (mem->virt)
+		iounmap(mem->virt);
+
+	if (mem->iores.parent)
+		rc = release_resource(&mem->iores);
+	if (mem->riores.parent && !rc)
+		rc = release_resource(&mem->riores);
+
+	if (mem->node.prev)
+		list_del(&mem->node);
+
+	kfree(mem);
+
+	return rc;
+}
+
+/** rio_prepare_io_mem -- Prepare IO region for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. The function do not map the outbound region
+ * because ioremap can not located at the interrupt action function.
+ * The function can be called in the initialization for just prepared.
+ */
+struct rio_mem *rio_prepare_io_mem(struct rio_mport *mport,
+		struct rio_dev *dev, resource_size_t size, const char *name)
+{
+	struct rio_mem *rmem = NULL;
+
+	rmem = kzalloc(sizeof(struct rio_mem), GFP_KERNEL);
+	if (!rmem)
+		goto err;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	/* Request RapidIO IO region */
+	if (!(rio_request_io_region(mport, dev, 0, size,
+				name, RIO_RESOURCE_MEM, &rmem->iores))) {
+		ERR("RIO io region request error!\n");
+		goto err;
+	}
+
+	rmem->virt = ioremap((phys_addr_t)(rmem->iores.start), size);
+	rmem->size = size;
+
+	list_add(&rmem->node, &rio_outb_mems);
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/** rio_request_outb_region -- Request IO region and get outbound region
+ *                             for RapidIO outbound mapping
+ * @mport: Master port
+ * @dev_id: RIO device specific pointer to pass
+ * @size: Request IO size
+ * @name: The request IO resource name
+ * @owner: The outbound region owned driver
+ *
+ * Return: The rio_mem descriptor with IO region resource.
+ *
+ * This function request IO region firstly and ioremap it for preparing
+ * outbound window mapping. And it will find the RapidIO region owned by
+ * the driver id. Then map it. Be careful about that the ioremap can not
+ * be called in the interrupt event action function.
+ */
+struct rio_mem *rio_request_outb_region(struct rio_mport *mport, void *dev_id,
+			resource_size_t size, const char *name, u32 owner)
+{
+	struct rio_mem *rmem = NULL;
+	struct rio_dev *dev = dev_id;
+
+	if (!dev)
+		goto err;
+
+	rmem = rio_prepare_io_mem(mport, dev, size, name);
+	if (!rmem)
+		goto err;
+
+	if (rio_space_find_mem(mport, dev->destid, owner, &rmem->riores)) {
+		ERR("Can not find RIO region meet the ownerid %x\n", owner);
+		goto err;
+	}
+
+	/* Map the rio space to local */
+	if (rio_map_outb_region(mport, dev->destid, rmem, 0)) {
+		ERR("RIO map outb error!\n");
+		goto err;
+	}
+	return rmem;
+err:
+	rio_release_outb_region(mport, rmem);
+	return NULL;
+}
+
+/**
  * rio_mport_get_feature - query for devices' extended features
  * @port: Master port to issue transaction
  * @local: Indicate a local master port or remote device access
@@ -476,8 +839,8 @@ int rio_init_mports(void)
 					port->iores.end - port->iores.start,
 					port->name)) {
 			printk(KERN_ERR
-			       "RIO: Error requesting master port region %8.8lx-%8.8lx\n",
-			       port->iores.start, port->iores.end - 1);
+			       "RIO: Error requesting master port region %016llx-%016llx\n",
+			       (u64)port->iores.start, (u64)port->iores.end - 1);
 			rc = -ENOMEM;
 			goto out;
 		}
@@ -486,6 +849,7 @@ int rio_init_mports(void)
 			rio_enum_mport(port);
 		else
 			rio_disc_mport(port);
+		rio_space_init(port);
 	}
 
       out:
@@ -508,3 +872,119 @@ EXPORT_SYMBOL_GPL(rio_request_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_request_outb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_outb_mbox);
+
+#ifdef CONFIG_RAPIDIO_PROC_FS
+enum { MAX_IORES_LEVEL = 5 };
+
+struct riors {
+	struct rio_mport *mp;
+	int res;
+	struct resource *p;
+} riomres;
+
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct resource *p = v;
+	struct riors *rs = m->private;
+
+	(*pos)++;
+	if (p->child)
+		return p->child;
+	while (!p->sibling && p->parent)
+		p = p->parent;
+	if (p->sibling)
+		return p->sibling;
+	else {
+		rs->res++;
+		if(rs->res >= RIO_MAX_MPORT_RESOURCES) {
+			rs->mp = list_entry(rs->mp->node.next, struct rio_mport, node);
+			rs->res = 0;
+			if (&rs->mp->node == &rio_mports)
+				return NULL;
+		}
+		seq_printf(m, "%2d: ", rs->res);
+		rs->p = &rs->mp->riores[rs->res];
+		p = rs->p;
+
+		return p;
+	}
+}
+
+static void *r_start(struct seq_file *m, loff_t *pos)
+{
+	struct riors *rs = m->private;
+	struct resource *p;
+
+	if (*pos) {
+		*pos = 0;
+		return NULL;
+	}
+
+	rs->mp = list_entry(rio_mports.next, struct rio_mport, node);
+	rs->res = -1;
+	rs->p = &rs->mp->iores;
+	p = rs->p;
+
+	seq_printf(m, "IO: ");
+
+	return p;
+}
+
+static void r_stop(struct seq_file *m, void *v)
+{
+}
+
+static int r_show(struct seq_file *m, void *v)
+{
+	struct riors *rs = m->private;
+	struct resource *root = rs->p;
+	struct resource *r = v, *p;
+	int width = root->end < 0x10000 ? 4 : 8;
+	int depth;
+
+	for (depth = 0, p = r; p->parent && depth < MAX_IORES_LEVEL; depth++, p = p->parent)
+		if (p == root)
+			break;
+	seq_printf(m, "%*s%0*llx-%0*llx : %s\n",
+			depth * 2, "",
+			width, (unsigned long long) r->start,
+			width, (unsigned long long) r->end,
+			r->name ? r->name : "<BAD>");
+	return 0;
+}
+
+static const struct seq_operations resource_op = {
+	.start	= r_start,
+	.next	= r_next,
+	.stop	= r_stop,
+	.show	= r_show,
+};
+
+static int riores_open(struct inode *inode, struct file *file)
+{
+	int res = seq_open(file, &resource_op);
+	if (!res) {
+		struct seq_file *m = file->private_data;
+		m->private = &riomres;
+	}
+	return res;
+}
+
+static const struct file_operations proc_riores_operations = {
+	.open		= riores_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init rioresources_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("riores", 0, NULL);
+	if (entry)
+		entry->proc_fops = &proc_riores_operations;
+	return 0;
+}
+__initcall(rioresources_init);
+#endif
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index b242cee..7a3b62e 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -51,10 +51,5 @@ extern struct rio_route_ops __end_rio_route_ops[];
 	DECLARE_RIO_ROUTE_SECTION(.rio_route_ops,			\
 			vid, did, add_hook, get_hook)
 
-#ifdef CONFIG_RAPIDIO_8_BIT_TRANSPORT
-#define RIO_GET_DID(x)	((x & 0x00ff0000) >> 16)
-#define RIO_SET_DID(x)	((x & 0x000000ff) << 16)
-#else
-#define RIO_GET_DID(x)	(x & 0xffff)
-#define RIO_SET_DID(x)	(x & 0xffff)
-#endif
+#define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
+#define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff --git a/drivers/rapidio/sallocator/Kconfig b/drivers/rapidio/sallocator/Kconfig
new file mode 100644
index 0000000..a33a1b8
--- /dev/null
+++ b/drivers/rapidio/sallocator/Kconfig
@@ -0,0 +1,9 @@
+choice
+	prompt "Default RapidIO Space Allocator"
+	depends on RAPIDIO
+	default RIO_SA_DEFAULT_BITMAP
+
+	config RIO_SA_DEFAULT_BITMAP
+		bool "Bitmap"
+
+endchoice
diff --git a/drivers/rapidio/sallocator/Makefile b/drivers/rapidio/sallocator/Makefile
new file mode 100644
index 0000000..437201c
--- /dev/null
+++ b/drivers/rapidio/sallocator/Makefile
@@ -0,0 +1,12 @@
+#
+# Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+#
+# Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+#
+# This is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+
+obj-$(CONFIG_RIO_SA_DEFAULT_BITMAP) += bitmap.o
diff --git a/drivers/rapidio/sallocator/bitmap.c b/drivers/rapidio/sallocator/bitmap.c
new file mode 100644
index 0000000..d10bbf9
--- /dev/null
+++ b/drivers/rapidio/sallocator/bitmap.c
@@ -0,0 +1,383 @@
+/*
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
+ * Description:
+ * RapidIO space allocator bitmap arithmetic.
+ * The Bitmap allocator make the whole RapidIO device have the same fixed
+ * inbound memory window. And on the top of each device inbound window,
+ * there is a sect0 area, which will use for recording the individual
+ * driver owned memory space in device.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/rio.h>
+#include <linux/rio_drv.h>
+#include <linux/rio_ids.h>
+#include <linux/rio_regs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include <linux/fs.h>
+#include <linux/proc_fs.h>
+#include <linux/dma-mapping.h>
+
+#include "../rio.h"
+
+#undef DEBUG
+
+#define RIO_SBLOCK_SIZE	4096
+
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "ERROR %s - %s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+#ifdef DEBUG
+#define DBG(fmt...) printk(fmt)
+#else
+#define DBG(fmt...) do {} while (0)
+#endif
+
+#define IS_64BIT_RES ((sizeof(resource_size_t) == 8) ? 1 : 0)
+#define SA_BITMAP_DRV_ID	0x4249544d
+#define SA_RIO_RESERVE_SPACE	0x4000000
+
+/* Definition for struct rio_res:ctrl */
+#define SA_RIO_RES_CTRL_EN	0x80000000
+struct rio_res {
+	u32 ctrl;	/* Control words
+			 * Bit 31: Enable bit.
+			 */
+	u32 addr;	/* The start addr bits [0-31] of RapidIO window */
+	u32 extaddr;	/* The start addr bits [32-63] of RapidIO window */
+	u32 size;	/* The size bits [0-31] of RapidIO window */
+	u32 extsize;	/* The size bits [32-63] of RapidIO window */
+	u32 owner;	/* The owner driver id */
+	u32 rev[2];	/* For align 32 bytes */
+};
+
+#define SA_BITMAP_MAX_INB_RES	32
+struct rio_sect0 {
+	u32	id;		/* ID for Bitmap space allocater driver */
+	u32	rioid;		/* RapidIO device id */
+	u32	width;		/* The resource width for RIO space, 32 or 64 */
+	u8	rev1[56];	/* Align to 64 bytes */
+	struct rio_res inb_res[SA_BITMAP_MAX_INB_RES];
+	u8	rev2[4096 - 64 - SA_BITMAP_MAX_INB_RES * 32];
+				/* Fill for 4096 bytes */
+};
+
+/* if select 64bit resource, we can use 34-bit rio address, otherwise 32-bit */
+static int rio_addr_size;
+static struct resource *root;
+static struct rio_mem sect0mem;		/* Sect 0 memory data */
+static struct rio_sect0	*sect0 = NULL;
+static struct rio_mem *sblock_buf = NULL;
+
+/**
+ * get_rio_addr_size -- get the RapidIO space address size.
+ *
+ * If it's a 64-bit system, the RapidIO space address size could be 34bit,
+ * otherwise, it should be 32 bit.
+ */
+static inline int get_rio_addr_size(void)
+{
+	return (sizeof(resource_size_t) == 8) ? 34 : 32;
+}
+
+/**
+ * rio_space_request -- request RapidIO space.
+ * @mport: RIO master port.
+ * @size: The request space size, must >= 4096.
+ * @new: The resource which required.
+ *
+ * Return:
+ *	0 -- Success
+ *	-EINVAL -- size is wrong (<4096)
+ *	-EFAULT -- new is NULL
+ *	others -- return from allocate_resource()
+ *
+ * This function request a memory from RapidIO space.
+ */
+int rio_space_request(struct rio_mport *mport, resource_size_t size,
+			struct resource *new)
+{
+	int ret = 0;
+
+	/* Align the size to 2^N */
+	size = (size < 0x1000) ? 0x1000 : 1 << (__ilog2(size - 1) + 1);
+
+	memset(new, 0, sizeof(struct resource));
+
+	ret = allocate_resource(root, new, size, root->start, root->end,
+			size, NULL, 0);
+	if (ret) {
+		ERR("No more resource for size 0x%08x!\n", size);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+#ifdef DEBUG
+/**
+ * rio_sa_dump_sect0 -- Dump the sect0 content.
+ * @psect0: The point of sect0
+ */
+static void rio_sa_dump_sect0(struct rio_sect0 *psect0)
+{
+	int i;
+
+	if (!psect0)
+		return;
+
+	printk("Rio Sect0 %p dump:\n", psect0);
+	printk("...id = 0x%08x, width = %d, rioid = %d \n",
+			psect0->id, psect0->width, psect0->rioid);
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (psect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)
+			printk("...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       psect0->inb_res[i].ctrl,
+			       psect0->inb_res[i].owner,
+			       psect0->inb_res[i].extaddr,
+			       psect0->inb_res[i].addr,
+			       psect0->inb_res[i].extsize,
+			       psect0->inb_res[i].size);
+}
+#endif
+
+/**
+ * rio_space_claim -- Claim the memory in RapidIO space
+ * @mem: The memory should be claimed.
+ *
+ * When you get a memory space and get ready of it, you should claim it in
+ * RapidIO space. Then, the other device could get the memory by calling
+ * rio_space_find_mem().
+ */
+int rio_space_claim(struct rio_mem *mem)
+{
+	int i;
+
+	if (!sect0) {
+		ERR("Sect0 is NULL!\n");
+		return -EINVAL;
+	}
+#ifdef DEBUG
+	rio_sa_dump_sect0(sect0);
+#endif
+
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if (!(sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN)) {
+			sect0->inb_res[i].ctrl |= SA_RIO_RES_CTRL_EN;
+			sect0->inb_res[i].addr = (u32)(mem->riores.start);
+			sect0->inb_res[i].size = (u32)(mem->riores.end
+					- mem->riores.start + 1);
+			if (IS_64BIT_RES) {
+				sect0->inb_res[i].extaddr =
+					(u64)mem->riores.start >> 32;
+				sect0->inb_res[i].extsize =
+					(u64)(mem->riores.end
+						- mem->riores.start + 1) >> 32;
+			}
+			sect0->inb_res[i].owner = mem->owner;
+			DBG("The new inbound rio mem added:\n");
+			DBG("...inb_res[%d]: ctrl 0x%08x, owner 0x%08x\n"
+				"\t\textaddr 0x%08x, addr 0x%08x\n"
+				"\t\textsize 0x%08x, size 0x%08x\n", i,
+			       sect0->inb_res[i].ctrl,
+			       sect0->inb_res[i].owner,
+			       sect0->inb_res[i].extaddr,
+			       sect0->inb_res[i].addr,
+			       sect0->inb_res[i].extsize,
+			       sect0->inb_res[i].size);
+			return 0;
+		}
+
+	ERR("No free inbound window!\n");
+	return -EBUSY;
+}
+
+/**
+ * rio_space_release -- remove the memory record from RapidIO space.
+ *		        It's the pair function of rio_space_claim().
+ *
+ * @inbmem: The memory should be release.
+ */
+void rio_space_release(struct rio_mem *inbmem)
+{
+	int i;
+
+	/* Remove it from sect0 inb_res array */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((sect0->inb_res[i].ctrl & SA_RIO_RES_CTRL_EN) &&
+				(((u64)sect0->inb_res[i].extaddr << 32 |
+				  sect0->inb_res[i].addr)
+				== (u64)inbmem->riores.start)) {
+			sect0->inb_res[i].ctrl = 0;
+			sect0->inb_res[i].addr = 0;
+			sect0->inb_res[i].extaddr = 0;
+			sect0->inb_res[i].size = 0;
+			sect0->inb_res[i].extsize = 0;
+		}
+}
+
+/**
+ * rio_space_get_dev_mem -- get the whole owned inbound space of
+ *			    RapidIO device with did.
+ */
+static struct resource *rio_space_get_dev_mem(struct rio_mport *mport,
+		u16 did, struct resource *res)
+{
+	if(!res && !(res = kmalloc(sizeof(struct resource), GFP_KERNEL))) {
+		ERR("resource alloc error!\n");
+		return NULL;
+	}
+	memset(res, 0, sizeof(struct resource));
+
+	res->start = SA_RIO_RESERVE_SPACE + (did
+		<< (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1)));
+	res->end = res->start +
+		(1 << (rio_addr_size - __ilog2(RIO_ANY_DESTID(mport->sys_size)
+						+ 1))) - 1;
+	res->flags = RIO_RESOURCE_MEM;
+
+	return res;
+}
+
+/**
+ * rio_space_find_mem -- Find the memory space (RIO) of the rio driver owned.
+ * @mport: RIO master port.
+ * @tid: The target RapidIO device id which will be searched.
+ * @owner: The driver id as the search keyword.
+ * @res: The result of finding.
+ *
+ * return:
+ *	0 -- Success
+ *	-EFAULT -- Remote sect0 is a bad address
+ *	-EPROTONOSUPPORT -- The remote space allocator protocol is not support
+ *
+ * This function will find the memory located in RapidIO space, which is owned
+ * by the driver. If the remote RapidIO device use the diffrent space allocator,
+ * it will return -EPROTONOSUPPORT.
+ */
+int rio_space_find_mem(struct rio_mport *mport, u16 tid,
+			u32 owner, struct resource *res)
+{
+	volatile struct rio_sect0 __iomem *rsect0;
+	int i;
+	int ret = 0;
+	u32 width;
+
+	rio_space_get_dev_mem(mport, tid, &sblock_buf->riores);
+	sblock_buf->size = RIO_SBLOCK_SIZE;
+	rio_map_outb_region(mport, tid, sblock_buf, 0);
+
+	if (!sblock_buf->virt) {
+		ERR("Sect0 block buffer is NULL!\n");
+		ret = -EFAULT;
+		goto out;
+	}
+	rsect0 = sblock_buf->virt;
+
+	if (in_be32(&rsect0->id) != SA_BITMAP_DRV_ID) {
+		DBG("The target RapidIO space allocator is not rio_sa_bitmap! "
+				"id = 0x%x\n", rsect0->id);
+		ret = -EPROTONOSUPPORT;
+		goto out;
+	}
+
+#ifdef DEBUG
+	/* Dump remote sect0 for debug */
+	DBG("Dump the remote RIO dev %d sect0\n", tid);
+	rio_sa_dump_sect0(rsect0);
+#endif
+
+	width = in_be32(&rsect0->width);
+	if (sizeof(resource_size_t) * 8 < width)
+		printk(KERN_WARNING "WARNING: The system width %d is smaller "
+			"than the remote RapidIO space address width %d!",
+			sizeof(resource_size_t) * 8, width);
+
+	/* Find the rio space block */
+	for (i = 0; i < SA_BITMAP_MAX_INB_RES; i++)
+		if ((in_be32(&rsect0->inb_res[i].ctrl) & SA_RIO_RES_CTRL_EN)
+			  && (in_be32(&rsect0->inb_res[i].owner) == owner )) {
+			if (!res) {
+				ERR("Resource NULL error!\n");
+				ret = -EFAULT;
+				goto out;
+			}
+			memset(res, 0, sizeof(struct resource));
+			res->start = (IS_64BIT_RES && (width > 32)) ?
+				in_be32(&rsect0->inb_res[i].extaddr) << 32 : 0
+				| rsect0->inb_res[i].addr;
+			res->end = res->start - 1 +
+				  ((in_be32(&rsect0->inb_res[i].size)) |
+				  ((IS_64BIT_RES && (width > 32)) ?
+				  ((u64)(in_be32(&rsect0->inb_res[i].extsize))
+				   << 32) : 0));
+			goto out;
+		}
+
+out:
+	rio_unmap_outb_region(mport, sblock_buf);
+	return ret;
+}
+
+/**
+ * rio_space_init -- RapidIO space allocator initialization function.
+ * @mport: The master port.
+ */
+int rio_space_init(struct rio_mport *mport)
+{
+	root = &mport->riores[RIO_INB_MEM_RESOURCE];
+	memset(root, 0, sizeof(struct resource));
+
+	rio_addr_size = get_rio_addr_size();
+
+	rio_space_get_dev_mem(mport, rio_get_mport_id(mport), root);
+	root->name = "rio_space_inb";
+
+	/* Alloc the sect 0 for space managerment */
+	memset(&sect0mem, 0, sizeof(struct rio_mem));
+	if(!(sect0mem.virt = dma_alloc_coherent(NULL, RIO_SBLOCK_SIZE,
+					&sect0mem.iores.start, GFP_KERNEL))) {
+		ERR("sect0 memory alloc error!\n");
+		return -ENOMEM;
+	}
+	sect0mem.iores.end = sect0mem.iores.start + RIO_SBLOCK_SIZE - 1;
+	sect0mem.size = RIO_SBLOCK_SIZE;
+
+	if(rio_space_request(mport, RIO_SBLOCK_SIZE, &sect0mem.riores))
+		return -ENOMEM;
+
+	sect0mem.riores.name = "sect 0";
+	sect0 = sect0mem.virt;
+	sect0->id = SA_BITMAP_DRV_ID;
+	sect0->rioid = rio_get_mport_id(mport);
+	sect0->width = rio_addr_size;
+
+	/* map outbond window to access rio inb */
+	rio_map_inb_region(mport, &sect0mem, 0);
+
+	/* Init sblock buffer for block seeking */
+	sblock_buf = rio_prepare_io_mem(mport, NULL, RIO_SBLOCK_SIZE,
+			"sblock_buf");
+	if (!sblock_buf)
+		return -ENOMEM;
+
+	return 0;
+}
-- 
1.5.2

