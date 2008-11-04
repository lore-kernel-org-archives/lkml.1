Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYKDSkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYKDSkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKDSkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:40:00 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:30485 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYKDSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:39:59 -0500
Message-ID: <491096D7.10808@natemccallum.com>
Date: Tue, 04 Nov 2008 13:39:19 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] Loaded driver modalias
Content-Type: multipart/mixed;
 boundary="------------080803050700080300000909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080803050700080300000909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please CC me to responses as I'm not subscribed to LKML.  Also, this is 
my first kernel patch, advise is certainly welcome.

For something I'm working on I have the need to answer the question, 
"given a hardware ID, does Linux distro X have a driver to support this 
hardware?" and more specifically, "which drivers support this hardware?" 
I can, generally speaking, get this data from files like 
/lib/modules/*/modules.alias.  However, this does not work for drivers 
built into the kernel.  With that in mind, I've cooked up a little proof 
of concept. Basically, its a sysfs file 
/sys/modules/$module/drivers/$driver/modalias that, when read, contains 
modalias-style filters for this driver.

The attached patch only does this for PCI drivers, each subsystem would 
need a patch like this.  Is this idea crazy?  Is there a better 
implementation?

Thanks!

Nathaniel McCallum

--------------080803050700080300000909
Content-Type: text/x-patch;
 name="linux-2.6-pci-driver-modalias.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6-pci-driver-modalias.patch"

diff -Nru linux-2.6.27.orig/drivers/pci/pci-driver.c linux-2.6.27/drivers/pci/pci-driver.c
--- linux-2.6.27.orig/drivers/pci/pci-driver.c	2008-10-09 18:13:53.000000000 -0400
+++ linux-2.6.27/drivers/pci/pci-driver.c	2008-11-04 08:24:29.000000000 -0500
@@ -118,6 +118,70 @@
 static inline void pci_remove_newid_file(struct pci_driver *drv) {}
 #endif
 
+#define ADD(buf, size, cond, wdata, data, wodata)				\
+{										\
+	if (cond) {								\
+		if (snprintf(buf, size, "%s" wdata, buf, data) >= size)		\
+			return -ENOMEM;						\
+	}									\
+	else {									\
+		if (snprintf(buf, size, "%s" wodata, buf) >= size)		\
+			return -ENOMEM;						\
+	}									\
+}
+
+#define PCI_MODALIAS(buf, size, v, d, sv, sd, c, cm) \
+{											\
+ADD(buf, size, 1, "%s", "pci:", "")							\
+ADD(buf, size,  v != PCI_ANY_ID, "v%08X",  v,  "v*")					\
+ADD(buf, size,  d != PCI_ANY_ID, "d%08X",  d,  "d*")					\
+ADD(buf, size, sv != PCI_ANY_ID, "sv%08X", sv, "sv*")					\
+ADD(buf, size, sd != PCI_ANY_ID, "sd%08X", sd, "sd*")					\
+ADD(buf, size, ((cm >> 16) & 0xFF) == 0xFF, "bc%02X", ((c >> 16) & 0xFF), "bc*")	\
+ADD(buf, size, ((cm >>  8) & 0xFF) == 0xFF, "sc%02X", ((c >>  8) & 0xFF), "sc*")	\
+ADD(buf, size, ((cm >>  0) & 0xFF) == 0xFF, "i%02X*", ((c >>  0) & 0xFF), "i*")		\
+ADD(buf, size, 1, "%s", "\n", "")							\
+}
+
+static ssize_t
+show_modaliases(struct device_driver *driver, char *buf)
+{
+	struct pci_driver *pdrv = to_pci_driver(driver);
+	struct list_head *pos;
+	struct pci_dynid *dynid;
+	int i;
+
+	/* Reset the buffer to be blank */
+	buf[0] = '\0';
+
+	/* List the static ids */
+	for (i=0 ; pdrv->id_table[i].vendor != 0 &&
+                   pdrv->id_table[i].device != 0; i++) {
+		PCI_MODALIAS(buf, PAGE_SIZE,
+				pdrv->id_table[i].vendor,
+				pdrv->id_table[i].device,
+				pdrv->id_table[i].subvendor,
+				pdrv->id_table[i].subdevice,
+				pdrv->id_table[i].class,
+				pdrv->id_table[i].class_mask)
+	}
+	
+	/* List the dynamic ids */
+	list_for_each(pos, &pdrv->dynids.list) {
+		dynid = list_entry(pos, struct pci_dynid, node);
+		PCI_MODALIAS(buf, PAGE_SIZE,
+				dynid->id.vendor,
+				dynid->id.device,
+				dynid->id.subvendor,
+				dynid->id.subdevice,
+				dynid->id.class,
+				dynid->id.class_mask)
+	}
+
+	return strlen(buf);
+}
+static DRIVER_ATTR(modaliases, S_IRUGO, show_modaliases, NULL);
+
 /**
  * pci_match_id - See if a pci device matches a given pci_id table
  * @ids: array of PCI device id structures to search in
@@ -702,9 +766,11 @@
 		return error;
 
 	error = pci_create_newid_file(drv);
-	if (error)
-		driver_unregister(&drv->driver);
+	if (!error)
+		error = driver_create_file(&drv->driver, &driver_attr_modaliases);
 
+	if (error)
+		pci_unregister_driver(drv);
 	return error;
 }
 
@@ -722,6 +788,7 @@
 pci_unregister_driver(struct pci_driver *drv)
 {
 	pci_remove_newid_file(drv);
+	driver_remove_file(&drv->driver, &driver_attr_modaliases);
 	driver_unregister(&drv->driver);
 	pci_free_dynids(drv);
 }

--------------080803050700080300000909--
