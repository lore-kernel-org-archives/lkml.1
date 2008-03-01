Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbYCAUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbYCAUoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbYCAUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbYCAUne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=vTnkt0veiX3DjhNATJOHtODhN84FDjNBmZAMyc5rM8ib5mPsaXA5OT/ukAfHA69oCM9BWcR64UAbPAvUl4oxXkdMSvz6jln1NHfrsF1+4/6A6oXY7sDkW/HiOVnL4C95IY9t1ZSvGhHPmL6UTdiwvI/n/mYiUKgWqGuaPe7ddHY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: register ports with non-present devices (for warm-plug)
Date: Sat, 1 Mar 2008 19:12:18 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803011912.19329.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: remove ide_hwif_release_regions()" patch

 drivers/ide/ide-probe.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1533,18 +1533,15 @@ int ide_device_add_all(u8 *idx, const st
 			continue;
 		}
 
-		if (ide_probe_port(hwif) < 0) {
-			ide_hwif_release_regions(hwif);
-			continue;
-		}
-
-		hwif->present = 1;
+		if (ide_probe_port(hwif) == 0)
+			hwif->present = 1;
 
 		if (hwif->chipset != ide_4drives || !hwif->mate ||
 		    !hwif->mate->present)
 			ide_register_port(hwif);
 
-		ide_port_tune_devices(hwif);
+		if (hwif->present)
+			ide_port_tune_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1553,9 +1550,6 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (!hwif->present)
-			continue;
-
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
@@ -1564,10 +1558,13 @@ int ide_device_add_all(u8 *idx, const st
 			continue;
 		}
 
-		ide_port_setup_devices(hwif);
+		if (hwif->present)
+			ide_port_setup_devices(hwif);
 
 		ide_acpi_init(hwif);
-		ide_acpi_port_init_devices(hwif);
+
+		if (hwif->present)
+			ide_acpi_port_init_devices(hwif);
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1576,11 +1573,11 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (hwif->present) {
-			if (hwif->chipset == ide_unknown)
-				hwif->chipset = ide_generic;
+		if (hwif->chipset == ide_unknown)
+			hwif->chipset = ide_generic;
+
+		if (hwif->present)
 			hwif_register_devices(hwif);
-		}
 	}
 
 	for (i = 0; i < MAX_HWIFS; i++) {
@@ -1589,11 +1586,11 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if (hwif->present) {
-			ide_sysfs_register_port(hwif);
-			ide_proc_register_port(hwif);
+		ide_sysfs_register_port(hwif);
+		ide_proc_register_port(hwif);
+
+		if (hwif->present)
 			ide_proc_port_register_devices(hwif);
-		}
 	}
 
 	return rc;
