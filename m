Return-Path: <linux-kernel-owner+w=401wt.eu-S966126AbXBOQvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966126AbXBOQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966127AbXBOQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:51:48 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:42339 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966126AbXBOQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:51:47 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com
Subject: [PATCH 2.6.21-rc1] ibmebus: Support dynamic addition and removal of adapters
Date: Thu, 15 Feb 2007 17:55:12 +0100
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151755.13009.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will add two sysfs attributes to /sys/bus/ibmebus which can be used
to notify the ebus driver of added / removed ebus devices in the OF device
tree.

Echoing the device's location code (as found in the OFDT "ibm,loc-code"
property) into the "probe" attribute will notify ebus of addition of the device
and cause the appropriate device driver's probe function to be called on the
device.

Likewise, echoing the location code into the "remove" attribute will cause
the device to be removed from the system.

Additionally, the uevent interface is now implemented in the driver.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 arch/powerpc/kernel/ibmebus.c |  121 +++++++++++++++++++++++++++++++++++++++---
 include/asm-powerpc/ibmebus.h |    2 
 2 files changed, 114 insertions(+), 9 deletions(-)


diff -wurp linux-2.6.20/arch/powerpc/kernel/ibmebus.c linux-2.6.20-ebus/arch/powerpc/kernel/ibmebus.c
--- linux-2.6.20/arch/powerpc/kernel/ibmebus.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-ebus/arch/powerpc/kernel/ibmebus.c	2007-02-14 17:58:00.000000000 +0100
@@ -2,6 +2,7 @@
  * IBM PowerPC IBM eBus Infrastructure Support.
  *
  * Copyright (c) 2005 IBM Corporation
+ *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
  *    
  * All rights reserved.
@@ -44,7 +45,6 @@
 #include <asm/abs_addr.h>
 
 static struct ibmebus_dev ibmebus_bus_device = { /* fake "parent" device */
-	.name = ibmebus_bus_device.ofdev.dev.bus_id,
 	.ofdev.dev.bus_id = "ibmebus",
 	.ofdev.dev.bus    = &ibmebus_bus_type,
 };
@@ -161,7 +161,9 @@ static void __devinit ibmebus_dev_releas
 static ssize_t ibmebusdev_show_name(struct device *dev, 
 				    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%s\n", to_ibmebus_dev(dev)->name);
+	struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name = (char*)get_property(ebus_dev->ofdev.node, "name", NULL);
+	return sprintf(buf, "%s\n", name);
 }
 static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name, 
 		   NULL);
@@ -171,7 +173,6 @@ static struct ibmebus_dev* __devinit ibm
 {
 	int err = 0;
 
-	dev->name = name;
 	dev->ofdev.dev.parent  = &ibmebus_bus_device.ofdev.dev;
 	dev->ofdev.dev.bus     = &ibmebus_bus_type;
 	dev->ofdev.dev.release = ibmebus_dev_release;
@@ -262,11 +263,19 @@ static void ibmebus_add_devices_by_id(st
 	return;
 }
 
-static int ibmebus_match_helper(struct device *dev, void *data)
+static int ibmebus_match_helper_name(struct device *dev, void *data)
 {
-	if (strcmp((char*)data, to_ibmebus_dev(dev)->name) == 0)
-		return 1;
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name;
 	
+	/* parent device has no of_device node, so skip it */
+	if (ebus_dev != &ibmebus_bus_device) {
+		name = (char*)get_property(
+			ebus_dev->ofdev.node, "name", NULL);
+	
+		if (name && (strcmp((char*)data, name) == 0))
+			return 1;
+	}
 	return 0;
 }
 
@@ -285,11 +294,10 @@ static void ibmebus_remove_devices_by_id
 	while (strlen(idt->name) > 0) {
 		while ((dev = bus_find_device(&ibmebus_bus_type, NULL, 
 					      (void*)idt->name,
-					      ibmebus_match_helper))) {
+					      ibmebus_match_helper_name))) {
 			ibmebus_unregister_device(dev);
 		}
 		idt++;
-		
 	}
 	
 	return;
@@ -307,6 +315,9 @@ int ibmebus_register_driver(struct ibmeb
 	if ((err = driver_register(&drv->driver) != 0))
 		return err;
 
+	/* remove all supported devices first, in case someone
+	 * probed them manually before registering the driver */
+	ibmebus_remove_devices_by_id(drv->id_table);
 	ibmebus_add_devices_by_id(drv->id_table);
 	
 	return 0;
@@ -361,12 +372,101 @@ static int ibmebus_bus_match(struct devi
 	return 0;
 }
 
+static int ibmebus_uevent(struct device *dev, char **envp, int num_envp,
+			char *buffer, int buffer_size)
+{
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name, *cp, *loc_code;
+	int length;
+
+	if (!num_envp)
+		return -ENOMEM;
+
+	if (!ebus_dev->ofdev.node)
+		return -ENODEV;
+
+	name = (char *)get_property(ebus_dev->ofdev.node, "name", NULL);
+	cp = (char *)get_property(ebus_dev->ofdev.node, "compatible", NULL);
+	loc_code = (char *)get_property(ebus_dev->ofdev.node,
+					"ibm,loc-code", NULL);
+	if (!(name && cp && loc_code))
+		return -ENODEV;
+
+	envp[0] = buffer;
+	length = scnprintf(buffer, buffer_size,
+			   "MODALIAS=ibmebus:T%s:S%s:L%s",
+			   name, cp, loc_code);
+	if (buffer_size - length <= 0)
+		return -ENOMEM;
+	envp[1] = NULL;
+
+	return 0;
+}
+
 struct bus_type ibmebus_bus_type = {
 	.name = "ibmebus",
+	.uevent = ibmebus_uevent,
 	.match = ibmebus_bus_match,
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 
+static int ibmebus_match_helper_loc_code(struct device *dev, void *data)
+{
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *loc_code;
+
+	/* parent device has no of_device node, so skip it */
+	if (ebus_dev != &ibmebus_bus_device) {
+		loc_code = (char*)get_property(
+			ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+
+		if (loc_code && (strcmp((char*)data, loc_code) == 0))
+			return 1;
+	}
+	return 0;
+}
+
+static ssize_t ibmebus_store_probe(struct bus_type *dev,
+				   const char *buf, size_t count)
+{
+	struct device_node *dn = NULL;
+	char *loc_code;
+
+	if (bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
+			     ibmebus_match_helper_loc_code)) {
+		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
+		       __FUNCTION__, buf);
+		return count;
+	}
+
+	while ((dn = of_find_all_nodes(dn))) {
+		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
+		if (loc_code && (strncmp(loc_code, buf, count) == 0)) {
+			if (ibmebus_register_device_node(dn) == NULL) {
+				of_node_put(dn);
+				break;
+			}
+		}
+	}
+
+	return count;
+}
+static BUS_ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe);
+
+static ssize_t ibmebus_store_remove(struct bus_type *bus,
+				    const char *buf, size_t count)
+{
+	struct device *dev;
+
+	while ((dev = bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
+				      ibmebus_match_helper_loc_code))) {
+		ibmebus_unregister_device(dev);
+	}
+
+	return count;
+}
+static BUS_ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove);
+
 static int __init ibmebus_bus_init(void)
 {
 	int err;
@@ -389,6 +489,9 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 	
+	bus_create_file(&ibmebus_bus_type, &bus_attr_probe);
+	bus_create_file(&ibmebus_bus_type, &bus_attr_remove);
+
 	return 0;
 }
 __initcall(ibmebus_bus_init);
diff -wurp linux-2.6.20/include/asm-powerpc/ibmebus.h linux-2.6.20-ebus/include/asm-powerpc/ibmebus.h
--- linux-2.6.20/include/asm-powerpc/ibmebus.h	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20-ebus/include/asm-powerpc/ibmebus.h	2007-02-14 17:58:55.000000000 +0100
@@ -2,6 +2,7 @@
  * IBM PowerPC eBus Infrastructure Support.
  *
  * Copyright (c) 2005 IBM Corporation
+ *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
  *    
  * All rights reserved.
@@ -47,7 +48,6 @@
 extern struct bus_type ibmebus_bus_type;
 
 struct ibmebus_dev {	
-	const char *name;
 	struct of_device ofdev;
 };
 

