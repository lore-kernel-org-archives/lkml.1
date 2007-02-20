Return-Path: <linux-kernel-owner+w=401wt.eu-S1161053AbXBTW5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161053AbXBTW5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161051AbXBTW5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:57:33 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:47344 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161065AbXBTW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:57:32 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com
Subject: [PATCH 2.6.21-rc1] ibmebus: more error reporting in dynamic add/remove code
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 21 Feb 2007 00:01:21 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702210001.21273.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Writing the ibmebus probe and remove attributes now throws an appropriate
error if something goes wrong. This way, userspace tools can check for
success or failure of an addition or removal. The write will block until
the probe/remove operation completes, so, when the write operation returns
without an error, you can be sure the probe was successful and the device
is present in the system.

As an added bonus, an eventual trailing newline is now removed from the
written string.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 ibmebus.c |   54 ++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 36 insertions(+), 18 deletions(-)


diff -urp a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c	2007-02-20 21:54:22.366443424 +0100
+++ b/arch/powerpc/kernel/ibmebus.c	2007-02-20 23:31:39.950486616 +0100
@@ -167,7 +167,7 @@ static ssize_t ibmebusdev_show_name(stru
 static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name,
 		   NULL);
 
-static struct ibmebus_dev* __devinit ibmebus_register_device_common(
+static int __devinit ibmebus_register_device_common(
 	struct ibmebus_dev *dev, const char *name)
 {
 	int err = 0;
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
@@ -390,30 +389,40 @@ static int ibmebus_match_helper_loc_code
 	return 0;
 }
 
-static ssize_t ibmebus_store_probe(struct bus_type *dev,
+static ssize_t ibmebus_store_probe(struct bus_type *bus,
 				   const char *buf, size_t count)
 {
 	struct device_node *dn = NULL;
+	struct ibmebus_dev *dev;
 	char *loc_code;
 
+	buf[count] = '\0';
+	if (buf[count-1] == '\n')
+		buf[count-1] = '\0';
+
 	if (bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
 			     ibmebus_match_helper_loc_code)) {
 		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
 		       __FUNCTION__, buf);
-		return count;
+		return -EINVAL;
 	}
 
 	while ((dn = of_find_all_nodes(dn))) {
 		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
 		if (loc_code && (strncmp(loc_code, buf, count) == 0)) {
-			if (ibmebus_register_device_node(dn) == NULL) {
+			dev = ibmebus_register_device_node(dn);
+			if (IS_ERR(dev)) {
 				of_node_put(dn);
-				break;
-			}
+				return PTR_ERR(dev);
+			} else
+				return count; /* success */
 		}
 	}
 
-	return count;
+	/* if we drop out of the loop, the loc code was invalid */
+	printk(KERN_WARNING "%s: no device with loc_code %s found\n",
+	       __FUNCTION__, buf);
+	return -ENODEV;
 }
 static BUS_ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe);
 
@@ -422,9 +431,18 @@ static ssize_t ibmebus_store_remove(stru
 {
 	struct device *dev;
 
-	while ((dev = bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
-				      ibmebus_match_helper_loc_code))) {
+	buf[count] = '\0';
+	if (buf[count-1] == '\n')
+		buf[count-1] = '\0';
+
+	/* The location code is unique, so we will find one device at most */
+	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, (char*)buf,
+				   ibmebus_match_helper_loc_code))) {
 		ibmebus_unregister_device(dev);
+	} else {
+		printk(KERN_WARNING "%s: loc_code %s not on the bus\n",
+		       __FUNCTION__, buf);
+		return -ENODEV;
 	}
 
 	return count;

