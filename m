Return-Path: <linux-kernel-owner+w=401wt.eu-S933624AbXCVQD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbXCVQD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933761AbXCVQD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:03:57 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49918 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933624AbXCVQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:03:56 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
Organization: IBM Corporation
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ibmebus: change probe/remove interface from using loc-code to DT path
Date: Thu, 22 Mar 2007 17:00:46 +0100
User-Agent: KMail/1.6.2
Cc: pmac@au1.ibm.com, hnguyen@de.ibm.com, johnrose@austin.ibm.com,
       johnrose@us.ibm.com, nfont@austin.ibm.com, paulus@samba.org,
       themann@de.ibm.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703221700.46292.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases, multiple OFDT nodes might share the same location code, so
the location code is not a unique identifier for an OFDT node. Changed the
ibmebus probe/remove interface to use the DT path of the device node instead
of the location code.

The DT path must be written into probe/remove right as it would appear in
the "devspec" attribute of the ebus device: relative to the DT root, with a
leading slash and without a trailing slash. One trailing newline will not
hurt; multiple newlines will (like perl's chomp()).

Example:

 Add a device "/proc/device-tree/foo@12345678" to ibmebus like this:
    echo /foo@12345678 > /sys/bus/ibmebus/probe

 Remove the device like this:
    echo /foo@12345678 > /sys/bus/ibmebus/remove


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


This patch applies on top of part 2/3 or 3/3 of my previous ibmebus patches,
which are already in Paul's git. Part 3/3 of that patchset will still apply
cleanly (with a little offset) after this patch.


 ibmebus.c |  118 ++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 61 insertions(+), 57 deletions(-)


diff -Nurp 03.almost-all/arch/powerpc/kernel/ibmebus.c 03b.path/arch/powerpc/kernel/ibmebus.c
--- 03.almost-all/arch/powerpc/kernel/ibmebus.c	2007-03-09 17:37:08.000000000 +0100
+++ 03b.path/arch/powerpc/kernel/ibmebus.c	2007-03-21 15:23:23.358121376 +0100
@@ -44,8 +44,6 @@
 #include <asm/ibmebus.h>
 #include <asm/abs_addr.h>
 
-#define MAX_LOC_CODE_LENGTH 80
-
 static struct device ibmebus_bus_device = { /* fake "parent" device */
 	.bus_id = "ibmebus",
 };
@@ -253,7 +251,7 @@ static void ibmebus_add_devices_by_id(st
 	return;
 }
 
-static int ibmebus_match_helper_name(struct device *dev, void *data)
+static int ibmebus_match_name(struct device *dev, void *data)
 {
 	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	char *name;
@@ -281,7 +279,7 @@ static void ibmebus_remove_devices_by_id
 	while (strlen(idt->name) > 0) {
 		while ((dev = bus_find_device(&ibmebus_bus_type, NULL,
 					      (void*)idt->name,
-					      ibmebus_match_helper_name))) {
+					      ibmebus_match_name))) {
 			ibmebus_unregister_device(dev);
 		}
 		idt++;
@@ -372,18 +370,30 @@ static struct device_attribute ibmebus_d
 	__ATTR_NULL
 };
 
-static int ibmebus_match_helper_loc_code(struct device *dev, void *data)
+static int ibmebus_match_path(struct device *dev, void *data)
 {
-	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
-	char *loc_code;
+	int rc;
+	struct device_node *dn =
+		of_node_get(to_ibmebus_dev(dev)->ofdev.node);
 
-	loc_code = (char*)get_property(
-		ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+	rc = (dn->full_name && (strcasecmp((char*)data, dn->full_name) == 0));
 
-	if (loc_code && (strcmp((char*)data, loc_code) == 0))
-		return 1;
+	of_node_put(dn);
+	return rc;
+}
 
-	return 0;
+static char *ibmebus_chomp(const char *in, size_t count)
+{
+	char *out = (char*)kmalloc(count + 1, GFP_KERNEL);
+	if (!out)
+		return NULL;
+
+	memcpy(out, in, count);
+	out[count] = '\0';
+	if (out[count - 1] == '\n')
+		out[count - 1] = '\0';
+
+	return out;
 }
 
 static ssize_t ibmebus_store_probe(struct bus_type *bus,
@@ -391,65 +401,59 @@ static ssize_t ibmebus_store_probe(struc
 {
 	struct device_node *dn = NULL;
 	struct ibmebus_dev *dev;
-	char *loc_code;
-	char parm[MAX_LOC_CODE_LENGTH];
-
-	if (count >= MAX_LOC_CODE_LENGTH)
-		return -EINVAL;
-	memcpy(parm, buf, count);
-	parm[count] = '\0';
-	if (parm[count-1] == '\n')
-		parm[count-1] = '\0';
-
-	if (bus_find_device(&ibmebus_bus_type, NULL, parm,
-			     ibmebus_match_helper_loc_code)) {
-		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
-		       __FUNCTION__, parm);
-		return -EINVAL;
-	}
+	char *path;
+	ssize_t rc;
 
-	while ((dn = of_find_all_nodes(dn))) {
-		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
-		if (loc_code && (strncmp(loc_code, parm, count) == 0)) {
-			dev = ibmebus_register_device_node(dn);
-			if (IS_ERR(dev)) {
-				of_node_put(dn);
-				return PTR_ERR(dev);
-			} else
-				return count; /* success */
-		}
+	path = ibmebus_chomp(buf, count);
+	if (!path)
+		return -ENOMEM;
+
+	if (bus_find_device(&ibmebus_bus_type, NULL, path,
+			     ibmebus_match_path)) {
+		printk(KERN_WARNING "%s: %s has already been probed\n",
+		       __FUNCTION__, path);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if ((dn = of_find_node_by_path(path))) {
+		dev = ibmebus_register_device_node(dn);
+		of_node_put(dn);
+		rc = IS_ERR(dev) ? PTR_ERR(dev) : count;
+	} else {
+		printk(KERN_WARNING "%s: no such device node: %s",
+		       __FUNCTION__, path);
+		rc = -ENODEV;
 	}
 
-	/* if we drop out of the loop, the loc code was invalid */
-	printk(KERN_WARNING "%s: no device with loc_code %s found\n",
-	       __FUNCTION__, parm);
-	return -ENODEV;
+out:
+	kfree(path);
+	return rc;
 }
 
 static ssize_t ibmebus_store_remove(struct bus_type *bus,
 				    const char *buf, size_t count)
 {
 	struct device *dev;
-	char parm[MAX_LOC_CODE_LENGTH];
+	char *path;
 
-	if (count >= MAX_LOC_CODE_LENGTH)
-		return -EINVAL;
-	memcpy(parm, buf, count);
-	parm[count] = '\0';
-	if (parm[count-1] == '\n')
-		parm[count-1] = '\0';
-
-	/* The location code is unique, so we will find one device at most */
-	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, parm,
-				   ibmebus_match_helper_loc_code))) {
+	path = ibmebus_chomp(buf, count);
+	if (!path)
+		return -ENOMEM;
+
+	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, path,
+				   ibmebus_match_path))) {
 		ibmebus_unregister_device(dev);
+
+		kfree(path);
+		return count;
 	} else {
-		printk(KERN_WARNING "%s: loc_code %s not on the bus\n",
-		       __FUNCTION__, parm);
+		printk(KERN_WARNING "%s: %s not on the bus\n",
+		       __FUNCTION__, path);
+
+		kfree(path);
 		return -ENODEV;
 	}
-
-	return count;
 }
 
 static struct bus_attribute ibmebus_bus_attrs[] = {

