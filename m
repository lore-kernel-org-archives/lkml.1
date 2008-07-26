Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYGZNpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYGZNpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYGZNnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:43:19 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:42093 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbYGZNnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=izQdfdbkPNTsXQcqR4udeJFSxFepDJAafwB5yELFn3sRdX1wodnoryboXpgSTim5yK
         CWplx3XNQ3flXf6wQARKVaaFyD9q4qRGfhMA8LGzsdlREqUHb1ms7CUKg3E5D+t1YenW
         QM37Pr5d7v4Y9Co0JURaXX8kigmN+WE/H5PgE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:41:12 +0200
Message-Id: <20080726134112.10589.476.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/10] ide: remove CONFIG_IDEDISK_MULTI_MODE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use multi PIO by default when available and remove no longer
needed CONFIG_IDEDISK_MULTI_MODE (it should be safe nowadays,
despite to what help entry has been saying).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig     |   23 -----------------------
 drivers/ide/ide-probe.c |    6 ++----
 2 files changed, 2 insertions(+), 27 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -141,29 +141,6 @@ config BLK_DEV_IDEDISK
 
 	  If unsure, say Y.
 
-config IDEDISK_MULTI_MODE
-	bool "Use multiple sector mode for Programmed Input/Output by default"
-	help
-	  This setting is irrelevant for most IDE disks, with direct memory
-	  access, to which multiple sector mode does not apply. Multiple sector
-	  mode is a feature of most modern IDE hard drives, permitting the
-	  transfer of multiple sectors per Programmed Input/Output interrupt,
-	  rather than the usual one sector per interrupt. When this feature is
-	  enabled, it can reduce operating system overhead for disk Programmed
-	  Input/Output. On some systems, it also can increase the data
-	  throughput of Programmed Input/Output. Some drives, however, seemed
-	  to run slower with multiple sector mode enabled. Some drives claimed
-	  to support multiple sector mode, but lost data at some settings.
-	  Under rare circumstances, such failures could result in massive
-	  filesystem corruption.
-
-	  If you get the following error, try to say Y here:
-
-	  hda: set_multmode: status=0x51 { DriveReady SeekComplete Error }
-	  hda: set_multmode: error=0x04 { DriveStatusError }
-
-	  If in doubt, say N.
-
 config BLK_DEV_IDECS
 	tristate "PCMCIA IDE support"
 	depends on PCMCIA
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -89,16 +89,14 @@ static void ide_disk_init_mult_count(ide
 	u8 max_multsect = id[ATA_ID_MAX_MULTSECT] & 0xff;
 
 	if (max_multsect) {
-#ifdef CONFIG_IDEDISK_MULTI_MODE
 		if ((max_multsect / 2) > 1)
 			id[ATA_ID_MULTSECT] = max_multsect | 0x100;
 		else
 			id[ATA_ID_MULTSECT] &= ~0x1ff;
 
 		drive->mult_req = id[ATA_ID_MULTSECT] & 0xff;
-#endif
-		if ((id[ATA_ID_MULTSECT] & 0x100) &&
-		    (id[ATA_ID_MULTSECT] & 0xff))
+
+		if (drive->mult_req)
 			drive->special.b.set_multmode = 1;
 	}
 }
