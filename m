Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYAVNDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYAVNDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYAVNCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:02:53 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:6713 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYAVNCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:02:52 -0500
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 08:02:52 EST
Date: Tue, 22 Jan 2008 07:44:52 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon update against v2.6.24-rc8+
Message-ID: <20080122124452.GI2896@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get one patch (attached) which fixes a regression for it87.
See below for details.

Thanks & regards,


commit 87b4b6634ac112ddfe7b92aae50eb4bf7b128d1a
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Jan 22 07:21:03 2008 -0500

    hwmon: (it87) request only Environment Controller ports
    
    The IT8705F and related parts are Super I/O controllers that contain
    many separate devices.
    
    Some BIOSes describe IT8705F I/O port usage under a motherboard device
    (PNP0C02) with overlapping regions, e.g., 0x290-0x29f and 0x290-0x294.
    
    The it87 driver supports only the Environment Controller, which requires
    only two ISA ports, but it used to request an eight-port range.  If that
    range exceeds a range reported by the BIOS, as 0x290-0x297 would, the
    request fails, and the it87 driver cannot claim the device.
    
    This patch makes the it87 driver request only the two ports used for the
    Environment Controller device.
    
    Systems where this problem has been reported:
        Gigabyte GA-K8N Ultra 9
        Gigabyte M56S-S3
        Gigabyte GA-965G-DS3
    
    Kernel bug reports:
        http://bugzilla.kernel.org/show_bug.cgi?id=9514
        http://lkml.org/lkml/2007/12/4/466
    
    Related change:
        http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a7839e960675b549f06209d18283d5cee2ce9261
    
        The patch above increases the number of PNP port resources we support.
        Prior to this patch, we ignored some port resources, which masked the
        it87 problem.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index 6a182e1..ad6c8a3 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -2,6 +2,14 @@
     it87.c - Part of lm_sensors, Linux kernel modules for hardware
              monitoring.
 
+    The IT8705F is an LPC-based Super I/O part that contains UARTs, a
+    parallel port, an IR port, a MIDI port, a floppy controller, etc., in
+    addition to an Environment Controller (Enhanced Hardware Monitor and
+    Fan Controller)
+
+    This driver supports only the Environment Controller in the IT8705F and
+    similar parts.  The other devices are supported by different drivers.
+
     Supports: IT8705F  Super I/O chip w/LPC interface
               IT8712F  Super I/O chip w/LPC interface
               IT8716F  Super I/O chip w/LPC interface
@@ -118,9 +126,15 @@ static int fix_pwm_polarity;
 /* Length of ISA address segment */
 #define IT87_EXTENT 8
 
-/* Where are the ISA address/data registers relative to the base address */
-#define IT87_ADDR_REG_OFFSET 5
-#define IT87_DATA_REG_OFFSET 6
+/* Length of ISA address segment for Environmental Controller */
+#define IT87_EC_EXTENT 2
+
+/* Offset of EC registers from ISA base address */
+#define IT87_EC_OFFSET 5
+
+/* Where are the ISA address/data registers relative to the EC base address */
+#define IT87_ADDR_REG_OFFSET 0
+#define IT87_DATA_REG_OFFSET 1
 
 /*----- The IT87 registers -----*/
 
@@ -968,10 +982,10 @@ static int __devinit it87_probe(struct platform_device *pdev)
 	};
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-	if (!request_region(res->start, IT87_EXTENT, DRVNAME)) {
+	if (!request_region(res->start, IT87_EC_EXTENT, DRVNAME)) {
 		dev_err(dev, "Failed to request region 0x%lx-0x%lx\n",
 			(unsigned long)res->start,
-			(unsigned long)(res->start + IT87_EXTENT - 1));
+			(unsigned long)(res->start + IT87_EC_EXTENT - 1));
 		err = -EBUSY;
 		goto ERROR0;
 	}
@@ -1124,7 +1138,7 @@ ERROR2:
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 ERROR1:
-	release_region(res->start, IT87_EXTENT);
+	release_region(res->start, IT87_EC_EXTENT);
 ERROR0:
 	return err;
 }
@@ -1137,7 +1151,7 @@ static int __devexit it87_remove(struct platform_device *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &it87_group);
 	sysfs_remove_group(&pdev->dev.kobj, &it87_group_opt);
 
-	release_region(data->addr, IT87_EXTENT);
+	release_region(data->addr, IT87_EC_EXTENT);
 	platform_set_drvdata(pdev, NULL);
 	kfree(data);
 
@@ -1402,8 +1416,8 @@ static int __init it87_device_add(unsigned short address,
 				  const struct it87_sio_data *sio_data)
 {
 	struct resource res = {
-		.start	= address ,
-		.end	= address + IT87_EXTENT - 1,
+		.start	= address + IT87_EC_OFFSET,
+		.end	= address + IT87_EC_OFFSET + IT87_EC_EXTENT - 1,
 		.name	= DRVNAME,
 		.flags	= IORESOURCE_IO,
 	};

-- 
Mark M. Hoffman
mhoffman@lightlink.com

