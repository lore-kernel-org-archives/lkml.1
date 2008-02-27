Return-Path: <linux-kernel-owner+w=401wt.eu-S1761288AbYB0Wuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761288AbYB0Wuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbYB0WuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:50:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:53915 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368AbYB0WuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MUKDnwkBI+iTRa9gZVdJNJ4WYqBJIZCLYBLmu/EGPcLyg44773SWV0zWzKj7y19I3RXy4REQYKz72B9oud8/b5ANxZW+gd9PXDJHkBEeEGK+7QaCk5j6BEIn66Xkh7fmDBku15vzhvQ8rLbZKXgJLTlkKJgEzZ5opjJaAS23MI8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide-pnp: manage I/O resources in driver
Date: Thu, 28 Feb 2008 00:02:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802280002.51966.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Use driver name for resources management.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-pnp.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -18,6 +18,8 @@
 #include <linux/pnp.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "ide-pnp"
+
 /* Add your devices here :)) */
 static struct pnp_device_id idepnp_devices[] = {
 	/* Generic ESDI/IDE/ATA compatible hard disk controller */
@@ -29,13 +31,29 @@ static int idepnp_probe(struct pnp_dev *
 {
 	hw_regs_t hw;
 	ide_hwif_t *hwif;
+	unsigned long base, ctl;
 
 	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) && pnp_irq_valid(dev, 0)))
 		return -1;
 
+	base = pnp_port_start(dev, 0);
+	ctl = pnp_port_start(dev, 1);
+
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
-	ide_std_init_ports(&hw, pnp_port_start(dev, 0),
-				pnp_port_start(dev, 1));
+	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = pnp_irq(dev, 0);
 
 	hwif = ide_find_port();
@@ -45,6 +63,7 @@ static int idepnp_probe(struct pnp_dev *
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
 
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev, hwif);
@@ -54,6 +73,9 @@ static int idepnp_probe(struct pnp_dev *
 		return 0;
 	}
 
+	release_region(ctl, 1);
+	release_region(base, 8);
+
 	return -1;
 }
 
@@ -65,6 +87,9 @@ static void idepnp_remove(struct pnp_dev
 		ide_unregister(hwif->index);
 	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
+
+	release_region(pnp_port_start(dev, 1), 1);
+	release_region(pnp_port_start(dev, 0), 8);
 }
 
 static struct pnp_driver idepnp_driver = {
