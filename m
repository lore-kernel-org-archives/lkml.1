Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXBVFMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXBVFMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXBVFMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:12:05 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:18496 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXBVFMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:12:03 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com
Subject: [PATCH 1/2] ibmebus: dynamic add/remove, uevent, root device and whitespace
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com, benh@kernel.crashing.org,
       Sylvain Munaut <tnt@246tnt.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Thu, 22 Feb 2007 06:15:50 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702220615.51332.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The first part of this patch summarizes the patches of the
previous days, namely:

- Add dynamic addition/removal of adapters
  (with spiffy error reporting)
- Implement the uevent interface using Sylvain's generic function
- Base fake root device on device instead of of_device

The first part will apply against the vanilla 2.6.20 source.
The second part is just a whitespace fix and applies on top of the first.

If nobody objects, I deem these patches ready for inclusion.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 arch/powerpc/kernel/ibmebus.c |  129 ++++++++++++++++++++++++++++++++++--------
 include/asm-powerpc/ibmebus.h |    2 


diff -wurp a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c	2007-02-22 05:26:24.971939672 +0100
+++ b/arch/powerpc/kernel/ibmebus.c	2007-02-20 23:31:39.000000000 +0100
@@ -2,6 +2,7 @@
  * IBM PowerPC IBM eBus Infrastructure Support.
  *
  * Copyright (c) 2005 IBM Corporation
+ *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
  *    
  * All rights reserved.
@@ -43,10 +44,8 @@
 #include <asm/ibmebus.h>
 #include <asm/abs_addr.h>
 
-static struct ibmebus_dev ibmebus_bus_device = { /* fake "parent" device */
-	.name = ibmebus_bus_device.ofdev.dev.bus_id,
-	.ofdev.dev.bus_id = "ibmebus",
-	.ofdev.dev.bus    = &ibmebus_bus_type,
+static struct device ibmebus_bus_device = { /* fake "parent" device */
+	.bus_id = "ibmebus",
 };
 
 static void *ibmebus_alloc_coherent(struct device *dev,
@@ -161,18 +160,19 @@ static void __devinit ibmebus_dev_releas
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
 
-static struct ibmebus_dev* __devinit ibmebus_register_device_common(
+static int __devinit ibmebus_register_device_common(
 	struct ibmebus_dev *dev, const char *name)
 {
 	int err = 0;
 
-	dev->name = name;
-	dev->ofdev.dev.parent  = &ibmebus_bus_device.ofdev.dev;
+	dev->ofdev.dev.parent  = &ibmebus_bus_device;
 	dev->ofdev.dev.bus     = &ibmebus_bus_type;
 	dev->ofdev.dev.release = ibmebus_dev_release;
 
@@ -186,12 +186,12 @@ static struct ibmebus_dev* __devinit ibm
 	if ((err = of_device_register(&dev->ofdev)) != 0) {
 		printk(KERN_ERR "%s: failed to register device (%d).\n",
 		       __FUNCTION__, err);
-		return NULL;
+		return -ENODEV;
 	}
 	
 	device_create_file(&dev->ofdev.dev, &dev_attr_name);
 	
-	return dev;
+	return 0;
 }
 
 static struct ibmebus_dev* __devinit ibmebus_register_device_node(
@@ -205,18 +205,18 @@ static struct ibmebus_dev* __devinit ibm
 	if (!loc_code) {
                 printk(KERN_WARNING "%s: node %s missing 'ibm,loc-code'\n",
 		       __FUNCTION__, dn->name ? dn->name : "<unknown>");
-		return NULL;
+		return ERR_PTR(-EINVAL);
         }
 	
 	if (strlen(loc_code) == 0) {
 	        printk(KERN_WARNING "%s: 'ibm,loc-code' is invalid\n",
 		       __FUNCTION__);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	dev = kzalloc(sizeof(struct ibmebus_dev), GFP_KERNEL);
 	if (!dev) {
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	dev->ofdev.node = of_node_get(dn);
@@ -227,9 +227,9 @@ static struct ibmebus_dev* __devinit ibm
 		min(length, BUS_ID_SIZE - 1));
 
 	/* Register with generic device framework. */
-	if (ibmebus_register_device_common(dev, dn->name) == NULL) {
+	if (ibmebus_register_device_common(dev, dn->name) != 0) {
 		kfree(dev);
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	}
 
 	return dev;
@@ -240,9 +240,8 @@ static void ibmebus_probe_of_nodes(char*
 	struct device_node *dn = NULL;
 	
 	while ((dn = of_find_node_by_name(dn, name))) {
-		if (ibmebus_register_device_node(dn) == NULL) {
+		if (IS_ERR(ibmebus_register_device_node(dn))) {
 			of_node_put(dn);
-			
 			return;
 		}
 	}
@@ -262,9 +261,15 @@ static void ibmebus_add_devices_by_id(st
 	return;
 }
 
-static int ibmebus_match_helper(struct device *dev, void *data)
+static int ibmebus_match_helper_name(struct device *dev, void *data)
 {
-	if (strcmp((char*)data, to_ibmebus_dev(dev)->name) == 0)
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name;
+
+	name = (char*)get_property(
+		ebus_dev->ofdev.node, "name", NULL);
+
+	if (name && (strcmp((char*)data, name) == 0))
 		return 1;
 	
 	return 0;
@@ -285,11 +290,10 @@ static void ibmebus_remove_devices_by_id
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
@@ -307,6 +311,9 @@ int ibmebus_register_driver(struct ibmeb
 	if ((err = driver_register(&drv->driver) != 0))
 		return err;
 
+	/* remove all supported devices first, in case someone
+	 * probed them manually before registering the driver */
+	ibmebus_remove_devices_by_id(drv->id_table);
 	ibmebus_add_devices_by_id(drv->id_table);
 	
 	return 0;
@@ -363,10 +370,85 @@ static int ibmebus_bus_match(struct devi
 
 struct bus_type ibmebus_bus_type = {
 	.name = "ibmebus",
+	.uevent = of_device_uevent,
 	.match = ibmebus_bus_match,
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 
+static int ibmebus_match_helper_loc_code(struct device *dev, void *data)
+{
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *loc_code;
+
+	loc_code = (char*)get_property(
+		ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+
+	if (loc_code && (strcmp((char*)data, loc_code) == 0))
+		return 1;
+
+	return 0;
+}
+
+static ssize_t ibmebus_store_probe(struct bus_type *bus,
+				   const char *buf, size_t count)
+{
+	struct device_node *dn = NULL;
+	struct ibmebus_dev *dev;
+	char *loc_code;
+
+	buf[count] = '\0';
+	if (buf[count-1] == '\n')
+		buf[count-1] = '\0';
+
+	if (bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
+			     ibmebus_match_helper_loc_code)) {
+		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
+		       __FUNCTION__, buf);
+		return -EINVAL;
+	}
+
+	while ((dn = of_find_all_nodes(dn))) {
+		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
+		if (loc_code && (strncmp(loc_code, buf, count) == 0)) {
+			dev = ibmebus_register_device_node(dn);
+			if (IS_ERR(dev)) {
+				of_node_put(dn);
+				return PTR_ERR(dev);
+			} else
+				return count; /* success */
+		}
+	}
+
+	/* if we drop out of the loop, the loc code was invalid */
+	printk(KERN_WARNING "%s: no device with loc_code %s found\n",
+	       __FUNCTION__, buf);
+	return -ENODEV;
+}
+static BUS_ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe);
+
+static ssize_t ibmebus_store_remove(struct bus_type *bus,
+				    const char *buf, size_t count)
+{
+	struct device *dev;
+
+	buf[count] = '\0';
+	if (buf[count-1] == '\n')
+		buf[count-1] = '\0';
+
+	/* The location code is unique, so we will find one device at most */
+	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
+				   ibmebus_match_helper_loc_code))) {
+		ibmebus_unregister_device(dev);
+	} else {
+		printk(KERN_WARNING "%s: loc_code %s not on the bus\n",
+		       __FUNCTION__, buf);
+		return -ENODEV;
+	}
+
+	return count;
+}
+static BUS_ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove);
+
 static int __init ibmebus_bus_init(void)
 {
 	int err;
@@ -380,7 +462,7 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 	
-	err = device_register(&ibmebus_bus_device.ofdev.dev);
+	err = device_register(&ibmebus_bus_device);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n", 
 		       __FUNCTION__, err);
@@ -389,6 +471,9 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 	
+	bus_create_file(&ibmebus_bus_type, &bus_attr_probe);
+	bus_create_file(&ibmebus_bus_type, &bus_attr_remove);
+
 	return 0;
 }
 __initcall(ibmebus_bus_init);
diff -wurp a/include/asm-powerpc/ibmebus.h b/include/asm-powerpc/ibmebus.h
--- a/include/asm-powerpc/ibmebus.h	2007-02-22 05:27:57.392999408 +0100
+++ b/include/asm-powerpc/ibmebus.h	2007-02-22 05:28:09.244928272 +0100
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
 

