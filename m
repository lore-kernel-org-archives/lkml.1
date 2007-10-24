Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbXJXOfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbXJXOfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759929AbXJXOdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:33:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:46172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbXJXOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:33:17 -0400
Subject: [Fwd: [PATCH 4/5] Check for ACPI resource conflicts in hwmon
	drivers]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=UTF-8
Organization: Novell/SUSE
Date: Wed, 24 Oct 2007 16:33:15 +0200
Message-Id: <1193236395.4590.231.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Check for ACPI resource conflicts in hwmon drivers. I've included
all Super-I/O and PCI drivers.

I've voluntarily left out:
* Laptop specific and vendor-specific drivers: if they conflicted
  on any system, this would pretty much mean that they conflict on all
  systems, and we would know by now.
* Legacy ISA drivers (lm78 and w83781d): they only support chips found
  on old designs were ACPI either wasn't supported or didn't deal with
  thermal management.
* Drivers accessing the I/O resources indirectly (e.g. through SMBus):
  the check will be added where it belongs, i.e. in the bus drivers.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/hwmon/dme1737.c    |    5 +++++
 drivers/hwmon/f71805f.c    |    5 +++++
 drivers/hwmon/f71882fg.c   |    5 +++++
 drivers/hwmon/it87.c       |    5 +++++
 drivers/hwmon/pc87360.c    |    6 ++++++
 drivers/hwmon/pc87427.c    |    5 +++++
 drivers/hwmon/sis5595.c    |    5 +++++
 drivers/hwmon/smsc47b397.c |    5 +++++
 drivers/hwmon/smsc47m1.c   |    5 +++++
 drivers/hwmon/via686a.c    |    5 +++++
 drivers/hwmon/vt1211.c     |    5 +++++
 drivers/hwmon/vt8231.c     |    5 +++++
 drivers/hwmon/w83627ehf.c  |    6 ++++++
 drivers/hwmon/w83627hf.c   |    5 +++++
 14 files changed, 72 insertions(+)

--- linux-2.6.24-rc0.orig/drivers/hwmon/dme1737.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/dme1737.c	2007-10-21 14:35:29.000000000 +0200
@@ -34,6 +34,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* ISA device, if found */
@@ -2227,6 +2228,10 @@ static int __init dme1737_isa_device_add
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	if (!(pdev = platform_device_alloc("dme1737", addr))) {
 		printk(KERN_ERR "dme1737: Failed to allocate device.\n");
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/f71805f.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/f71805f.c	2007-10-21 14:35:29.000000000 +0200
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -1451,6 +1452,10 @@ static int __init f71805f_device_add(uns
 	}
 
 	res.name = pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit_device_put;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
--- linux-2.6.24-rc0.orig/drivers/hwmon/it87.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/it87.c	2007-10-21 14:35:29.000000000 +0200
@@ -38,6 +38,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 #define DRVNAME "it87"
@@ -1409,6 +1410,10 @@ static int __init it87_device_add(unsign
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/pc87360.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/pc87360.c	2007-10-21 14:35:29.000000000 +0200
@@ -43,6 +43,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static u8 devid;
@@ -1421,6 +1422,11 @@ static int __init pc87360_device_add(uns
 			continue;
 		res.start = extra_isa[i];
 		res.end = extra_isa[i] + PC87360_EXTENT - 1;
+
+		err = acpi_check_resource_conflict(&res);
+		if (err)
+			goto exit_device_put;
+
 		err = platform_device_add_resources(pdev, &res, 1);
 		if (err) {
 			printk(KERN_ERR "pc87360: Device resource[%d] "
--- linux-2.6.24-rc0.orig/drivers/hwmon/pc87427.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/pc87427.c	2007-10-21 14:35:29.000000000 +0200
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -520,6 +521,10 @@ static int __init pc87427_device_add(uns
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/sis5595.c	2007-10-21 14:21:51.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/sis5595.c	2007-10-21 14:35:29.000000000 +0200
@@ -62,6 +62,7 @@
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 

@@ -702,6 +703,10 @@ static int __devinit sis5595_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("sis5595", address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/smsc47b397.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/smsc47b397.c	2007-10-21 14:35:29.000000000 +0200
@@ -36,6 +36,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -299,6 +300,10 @@ static int __init smsc47b397_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/smsc47m1.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/smsc47m1.c	2007-10-21 14:35:29.000000000 +0200
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct platform_device *pdev;
@@ -682,6 +683,10 @@ static int __init smsc47m1_device_add(un
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/via686a.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/via686a.c	2007-10-21 14:35:29.000000000 +0200
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 

@@ -755,6 +756,10 @@ static int __devinit via686a_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("via686a", address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/vt1211.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/vt1211.c	2007-10-21 14:35:29.000000000 +0200
@@ -32,6 +32,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int uch_config = -1;
@@ -1255,6 +1256,10 @@ static int __init vt1211_device_add(unsi
 	}
 
 	res.name = pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto EXIT;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
--- linux-2.6.24-rc0.orig/drivers/hwmon/vt8231.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/vt8231.c	2007-10-21 14:35:29.000000000 +0200
@@ -35,6 +35,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int force_addr;
@@ -858,6 +859,10 @@ static int __devinit vt8231_device_add(u
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("vt8231", address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/w83627ehf.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/w83627ehf.c	2007-10-21 14:35:29.000000000 +0200
@@ -48,6 +48,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -1531,6 +1532,11 @@ static int __init sensors_w83627ehf_init
 	res.start = address + IOREGION_OFFSET;
 	res.end = address + IOREGION_OFFSET + IOREGION_LENGTH - 1;
 	res.flags = IORESOURCE_IO;
+
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
--- linux-2.6.24-rc0.orig/drivers/hwmon/w83627hf.c	2007-10-21 14:21:51.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/w83627hf.c	2007-10-21 14:35:29.000000000 +0200
@@ -50,6 +50,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -1668,6 +1669,10 @@ static int __init w83627hf_device_add(un
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
--- linux-2.6.24-rc0.orig/drivers/hwmon/f71882fg.c	2007-10-21 14:21:50.000000000 +0200
+++ linux-2.6.24-rc0/drivers/hwmon/f71882fg.c	2007-10-21 14:35:29.000000000 +0200
@@ -27,6 +27,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 #define DRVNAME "f71882fg"
@@ -894,6 +895,10 @@ static int __init f71882fg_device_add(un
 		return -ENOMEM;
 
 	res.name = f71882fg_pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		return err;
+
 	err = platform_device_add_resources(f71882fg_pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed\n");

-- 
Thomas Renninger

Research and Developement Departement
SUSE LINUX Products GmbH,
Maxfeldstr. 5, D - 90409 Nürnberg
Phone: +49 (0)911 - 740 53 675
e-mail: trenn@suse.de

SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)

