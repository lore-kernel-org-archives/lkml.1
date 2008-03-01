Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYCAUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYCAUo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYCAUnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbYCAUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=M5P+k1KDt+94n2zZvuR3Xcc6ocRTMWTTQ/Xa1JEYoKh3mOJ5FxkpGWT9VewA2xvKTDCUmpq9xNNtF+Or4eiJW2Sa3B6P/R0Z5UWivSYTBRp9bqm4onoYknRTyOi/MPuoCLfemqobrIfHxTpjBUPnG7oNYo7KnjPhG3BnWiNMcRY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/9] ide-4drives: manage I/O resources in driver
Date: Sat, 1 Mar 2008 19:47:43 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803011947.43296.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Use driver name for resources management.

* Remove no longer needed 'hwif->chipset == ide_4drives' handling
  from ide_device_add_all().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c          |    3 +--
 drivers/ide/legacy/ide-4drives.c |   20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1526,8 +1526,7 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
-		if ((hwif->chipset != ide_4drives || !hwif->mate ||
-		     !hwif->mate->present) && ide_hwif_request_regions(hwif)) {
+		if (ide_hwif_request_regions(hwif)) {
 			printk(KERN_ERR "%s: ports already in use, "
 					"skipping probe\n", hwif->name);
 			continue;
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -4,6 +4,8 @@
 #include <linux/module.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "ide-4drives"
+
 int probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
@@ -12,21 +14,36 @@ MODULE_PARM_DESC(probe, "probe for gener
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
+	unsigned long base = 0x1f0, ctl = 0x3f6;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 
 	if (probe_4drives == 0)
 		return -ENODEV;
 
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
 	memset(&hw, 0, sizeof(hw));
 
-	ide_std_init_ports(&hw, 0x1f0, 0x3f6);
+	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
 		idx[0] = hwif->index;
 	}
 
@@ -35,6 +52,7 @@ static int __init ide_4drives_init(void)
 		ide_init_port_hw(mate, &hw);
 		mate->drives[0].select.all ^= 0x20;
 		mate->drives[1].select.all ^= 0x20;
+		mate->mmio = 1;
 		idx[1] = mate->index;
 
 		if (hwif) {
