Return-Path: <linux-kernel-owner+w=401wt.eu-S1764998AbYEHUvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764998AbYEHUvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761051AbYEHUu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:50:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:61708 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbYEHUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iRh2bM/3Ye8sl/IY5kek/JV+JAjzbXlI6/ZMB1h4Msx5muGN7W05z0HM9OcmV+isb+2suEoy6jeGXy1sLb3KBkHoaGr6IQIVk96LlX4/DU9k9rgz7kNK0kYxwv72wR4OI+xiaZdQe4w3eZZxyol+bMMiXIID9+d5Y1NoVdN3h3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] alim15x3: add "wdc_udma" module parameter
Date: Thu, 8 May 2008 23:04:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082304.45583.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "wdc_udma" module parameter for allowing UDMA transfers
on M1543C-E chipset for WDC disks.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -39,6 +39,16 @@
 #include <asm/io.h>
 
 /*
+ * Allow UDMA on M1543C-E chipset for WDC disks that ignore CRC checking
+ * (this is DANGEROUS and could result in data corruption).
+ */
+static int wdc_udma;
+
+module_param(wdc_udma, bool, 0);
+MODULE_PARM_DESC(wdc_udma,
+		 "allow UDMA on M1543C-E chipset for WDC disks (DANGEROUS)");
+
+/*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
  */
@@ -116,7 +126,7 @@ static void ali_set_pio_mode(ide_drive_t
  *	The actual rules for the ALi are:
  *		No UDMA on revisions <= 0x20
  *		Disk only for revisions < 0xC2
- *		Not WDC drives for revisions < 0xC2
+ *		Not WDC drives on M1543C-E (?)
  *
  *	FIXME: WDC ifdef needs to die
  */
@@ -127,7 +137,8 @@ static u8 ali_udma_filter(ide_drive_t *d
 		if (drive->media != ide_disk)
 			return 0;
 #ifndef CONFIG_WDC_ALI15X3
-		if (chip_is_1543c_e && strstr(drive->id->model, "WDC "))
+		if (chip_is_1543c_e && strstr(drive->id->model, "WDC ") &&
+		    wdc_udma == 0)
 			return 0;
 #endif
 	}
