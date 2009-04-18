Return-Path: <linux-kernel-owner+w=401wt.eu-S1751790AbZDRK4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbZDRK4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZDRKzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:55:49 -0400
Received: from ppp-110-141.adsl.restena.lu ([158.64.110.141]:42976 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZDRKzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:55:48 -0400
Date: Sat, 18 Apr 2009 12:47:43 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jeff Garzik <jeff@garzik.org>, Linux SCSI <linux-scsi@vger.kernel.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] sd: Stop disks on reboot for laptop which cuts power
Message-ID: <20090418124743.408cb37c@neptune.home>
In-Reply-To: <20090418124415.1dc82273@neptune.home>
References: <20090418124415.1dc82273@neptune.home>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My laptop (Acer Travelmate 660) always cuts the power when rebooting
which causes the disk to emergency-park it's head.

Add a dmi check to stop disk as for shutdown on this laptop.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3fcb64b..fdad8bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <linux/dmi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -2127,6 +2128,20 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	return res;
 }
 
+static const struct dmi_system_id sd_coldreboot_table[] = {
+	{
+		/* Acer TravelMate 66x cuts power during reboot */
+		.ident   = "Acer TravelMate 660",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+
+	{ }	/* terminate list */
+};
+
+
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
@@ -2144,7 +2159,9 @@ static void sd_shutdown(struct device *dev)
 		sd_sync_cache(sdkp);
 	}
 
-	if (system_state != SYSTEM_RESTART && sdkp->device->manage_start_stop) {
+	if (sdkp->device->manage_start_stop &&
+	    (system_state != SYSTEM_RESTART ||
+	    dmi_check_system(sd_coldreboot_table))) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
