Return-Path: <linux-kernel-owner+w=401wt.eu-S965657AbXBTDy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657AbXBTDy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965659AbXBTDy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:54:58 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:19654 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965657AbXBTDy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:54:57 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       johnrose@us.ibm.com
Subject: [PATCH 2.6.21-rc1] ibmebus: make root device not of_device-based
User-Agent: KMail/1.8.2
Cc: pmac@au1.ibm.com, fenkes@de.ibm.com, benh@kernel.crashing.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 20 Feb 2007 04:58:39 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200702200458.39304.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The fake root device doesn't have an associated device tree node,
so it should not be an of_device. This patch makes it a normal,
bus-less device and thus saves a lot of checks later on.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---


 ibmebus.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)


diff -urp a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c	2007-02-20 01:35:54.000000000 +0100
+++ b/arch/powerpc/kernel/ibmebus.c	2007-02-20 01:39:24.000000000 +0100
@@ -44,9 +44,8 @@
 #include <asm/ibmebus.h>
 #include <asm/abs_addr.h>
 
-static struct ibmebus_dev ibmebus_bus_device = { /* fake "parent" device */
-	.ofdev.dev.bus_id = "ibmebus",
-	.ofdev.dev.bus    = &ibmebus_bus_type,
+static struct device ibmebus_bus_device = { /* fake "parent" device */
+	.bus_id = "ibmebus",
 };
 
 static void *ibmebus_alloc_coherent(struct device *dev,
@@ -173,7 +172,7 @@ static struct ibmebus_dev* __devinit ibm
 {
 	int err = 0;
 
-	dev->ofdev.dev.parent  = &ibmebus_bus_device.ofdev.dev;
+	dev->ofdev.dev.parent  = &ibmebus_bus_device;
 	dev->ofdev.dev.bus     = &ibmebus_bus_type;
 	dev->ofdev.dev.release = ibmebus_dev_release;
 
@@ -268,14 +267,12 @@ static int ibmebus_match_helper_name(str
 	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	char *name;
 
-	/* parent device has no of_device node, so skip it */
-	if (ebus_dev != &ibmebus_bus_device) {
-		name = (char*)get_property(
-			ebus_dev->ofdev.node, "name", NULL);
+	name = (char*)get_property(
+		ebus_dev->ofdev.node, "name", NULL);
+
+	if (name && (strcmp((char*)data, name) == 0))
+		return 1;
 
-		if (name && (strcmp((char*)data, name) == 0))
-			return 1;
-	}
 	return 0;
 }
 
@@ -384,14 +381,12 @@ static int ibmebus_match_helper_loc_code
 	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
 	char *loc_code;
 
-	/* parent device has no of_device node, so skip it */
-	if (ebus_dev != &ibmebus_bus_device) {
-		loc_code = (char*)get_property(
-			ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+	loc_code = (char*)get_property(
+		ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+
+	if (loc_code && (strcmp((char*)data, loc_code) == 0))
+		return 1;
 
-		if (loc_code && (strcmp((char*)data, loc_code) == 0))
-			return 1;
-	}
 	return 0;
 }
 
@@ -449,7 +444,7 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 
-	err = device_register(&ibmebus_bus_device.ofdev.dev);
+	err = device_register(&ibmebus_bus_device);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
 		       __FUNCTION__, err);

