Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYCQRhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYCQRhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYCQRhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:37:12 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5952 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756047AbYCQRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:37:10 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: grant.likely@secretlab.ca, git-dev@xilinx.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Subject: [PATCH 3/3] Xilinx: hwicap: Use fixed device major.
Date: Mon, 17 Mar 2008 10:36:32 -0700
X-Mailer: git-send-email 1.5.3.4-dirty
In-Reply-To: <1205775392-32222-3-git-send-email-stephen.neuendorffer@xilinx.com>
References: <1205775392-32222-1-git-send-email-stephen.neuendorffer@xilinx.com>
 <1205775392-32222-2-git-send-email-stephen.neuendorffer@xilinx.com>
 <1205775392-32222-3-git-send-email-stephen.neuendorffer@xilinx.com>
Message-Id: <20080317173641.C8BE6640069@mail113-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major 259 has been assigned by lanana.  Use it.  Also, publish
/dev/icap[0-k] as the device entries, and register platform devices
named 'icap' to be consistent.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   43 +++++++++-------------------
 1 files changed, 14 insertions(+), 29 deletions(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 5b8d646..016f905 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -36,7 +36,7 @@
  *****************************************************************************/
 
 /*
- * This is the code behind /dev/xilinx_icap -- it allows a user-space
+ * This is the code behind /dev/icap* -- it allows a user-space
  * application to use the Xilinx ICAP subsystem.
  *
  * The following operations are possible:
@@ -67,7 +67,7 @@
  * user-space application code that uses this device.  The simplest
  * way to use this interface is simply:
  *
- * cp foo.bit /dev/xilinx_icap
+ * cp foo.bit /dev/icap0
  *
  * Note that unless foo.bit is an appropriately constructed partial
  * bitstream, this has a high likelyhood of overwriting the design
@@ -105,18 +105,14 @@
 #include "buffer_icap.h"
 #include "fifo_icap.h"
 
-#define DRIVER_NAME "xilinx_icap"
+#define DRIVER_NAME "icap"
 
 #define HWICAP_REGS   (0x10000)
 
-/* dynamically allocate device number */
-static int xhwicap_major;
-static int xhwicap_minor;
+#define XHWICAP_MAJOR 259
+#define XHWICAP_MINOR 0
 #define HWICAP_DEVICES 1
 
-module_param(xhwicap_major, int, S_IRUGO);
-module_param(xhwicap_minor, int, S_IRUGO);
-
 /* An array, which is set to true when the device is registered. */
 static bool probed_devices[HWICAP_DEVICES];
 static struct mutex icap_sem;
@@ -605,7 +601,7 @@ static int __devinit hwicap_setup(struct device *dev, int id,
 	probed_devices[id] = 1;
 	mutex_unlock(&icap_sem);
 
-	devt = MKDEV(xhwicap_major, xhwicap_minor + id);
+	devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR + id);
 
 	drvdata = kzalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
 	if (!drvdata) {
@@ -710,7 +706,7 @@ static int __devexit hwicap_remove(struct device *dev)
 	dev_set_drvdata(dev, NULL);
 
 	mutex_lock(&icap_sem);
-	probed_devices[MINOR(dev->devt)-xhwicap_minor] = 0;
+	probed_devices[MINOR(dev->devt)-XHWICAP_MINOR] = 0;
 	mutex_unlock(&icap_sem);
 	return 0;		/* success */
 }
@@ -850,23 +846,12 @@ static int __init hwicap_module_init(void)
 	icap_class = class_create(THIS_MODULE, "xilinx_config");
 	mutex_init(&icap_sem);
 
-	if (xhwicap_major) {
-		devt = MKDEV(xhwicap_major, xhwicap_minor);
-		retval = register_chrdev_region(
-				devt,
-				HWICAP_DEVICES,
-				DRIVER_NAME);
-		if (retval < 0)
-			return retval;
-	} else {
-		retval = alloc_chrdev_region(&devt,
-				xhwicap_minor,
-				HWICAP_DEVICES,
-				DRIVER_NAME);
-		if (retval < 0)
-			return retval;
-		xhwicap_major = MAJOR(devt);
-	}
+	devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR);
+	retval = register_chrdev_region(devt,
+					HWICAP_DEVICES,
+					DRIVER_NAME);
+	if (retval < 0)
+		return retval;
 
 	retval = platform_driver_register(&hwicap_platform_driver);
 
@@ -891,7 +876,7 @@ static int __init hwicap_module_init(void)
 
 static void __exit hwicap_module_cleanup(void)
 {
-	dev_t devt = MKDEV(xhwicap_major, xhwicap_minor);
+	dev_t devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR);
 
 	class_destroy(icap_class);
 
-- 
1.5.3.4-dirty



