Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbYGFRjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbYGFRjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYGFRfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbYGFRez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=JaXY5L5TV3nsKNjb1I7dodtXw1JKnPxuuOICOBhizxFWMPwN6urzhb0Vhe/0J8LcPx
         7GdhIjFAkPU/x3aOZN6IxqNSBfx7eW/0g1HvJV0NJp5zeA2jGTPCmoDvkXCvNu/s3rek
         9mq7deICHSi+kMWIwAzKA6KIECER5jJDYD+Ks=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:24 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 14/50] tc86c001: remove ->init_chipset method
Content-Disposition: inline; filename=tc86c001-remove-init_chipset-method.patch
Message-ID: <4871023e.1ade660a.3458.6288@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Reserve PCI BAR 5 in tc86c001_init_one() and remove no longer needed
  init_chipset_tc86c001().

While at it:

* Add & use DRV_NAME define.

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/tc86c001.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -11,6 +11,8 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
+#define DRV_NAME "TC86C001"
+
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -173,16 +175,6 @@ static void __devinit init_hwif_tc86c001
 	hwif->rqsize	 = 0xffff;
 }
 
-static unsigned int __devinit init_chipset_tc86c001(struct pci_dev *dev,
-							const char *name)
-{
-	int err = pci_request_region(dev, 5, name);
-
-	if (err)
-		printk(KERN_ERR "%s: system control regs already in use", name);
-	return err;
-}
-
 static const struct ide_port_ops tc86c001_port_ops = {
 	.set_pio_mode		= tc86c001_set_pio_mode,
 	.set_dma_mode		= tc86c001_set_mode,
@@ -202,7 +194,6 @@ static const struct ide_dma_ops tc86c001
 
 static const struct ide_port_info tc86c001_chipset __devinitdata = {
 	.name		= "TC86C001",
-	.init_chipset	= init_chipset_tc86c001,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
 	.dma_ops	= &tc86c001_dma_ops,
@@ -215,7 +206,30 @@ static const struct ide_port_info tc86c0
 static int __devinit tc86c001_init_one(struct pci_dev *dev,
 				       const struct pci_device_id *id)
 {
-	return ide_pci_init_one(dev, &tc86c001_chipset, NULL);
+	int rc;
+
+	rc = pci_enable_device(dev);
+	if (rc)
+		goto out;
+
+	rc = pci_request_region(dev, 5, DRV_NAME);
+	if (rc) {
+		printk(KERN_ERR DRV_NAME ": system control regs already in use");
+		goto out_disable;
+	}
+
+	rc = ide_pci_init_one(dev, &tc86c001_chipset, NULL);
+	if (rc)
+		goto out_release;
+
+	goto out;
+
+out_release:
+	pci_release_region(dev, 5);
+out_disable:
+	pci_disable_device(dev);
+out:
+	return rc;
 }
 
 static const struct pci_device_id tc86c001_pci_tbl[] = {

-- 

