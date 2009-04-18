Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbZDRK42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbZDRK42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 06:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZDRKzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 06:55:52 -0400
Received: from ppp-110-141.adsl.restena.lu ([158.64.110.141]:36082 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZDRKzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 06:55:48 -0400
Date: Sat, 18 Apr 2009 12:45:58 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
Message-ID: <20090418124558.0426f74c@neptune.home>
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
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1aebdf1..4b6b71e 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
+#include <linux/dmi.h>
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		(1 << PARTN_BITS)
@@ -99,6 +100,19 @@ static void ide_gd_resume(ide_drive_t *drive)
 		(void)drive->disk_ops->get_capacity(drive);
 }
 
+static const struct dmi_system_id ide_coldreboot_table[] = {
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
 static void ide_gd_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -115,7 +129,8 @@ static void ide_gd_shutdown(ide_drive_t *drive)
 	   the disk to expire its write cache. */
 	if (system_state != SYSTEM_POWER_OFF) {
 #else
-	if (system_state == SYSTEM_RESTART) {
+	if (system_state == SYSTEM_RESTART &&
+		!dmi_check_system(ide_coldreboot_table)) {
 #endif
 		drive->disk_ops->flush(drive);
 		return;
