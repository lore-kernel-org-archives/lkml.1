Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0ARRQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0ARRQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0ARRQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:45 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44245 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0ARRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=xO0wt/D7usu7i2vyB1mlyBQgQrT8nZPbOJueg91zqoEhbI+6uUEP6cKpcG/Zm34K+z
         H9JGrDnrzD2KWJtsLQ+pf7fj7EWNWXbfOAsxfFEERO+NcSk1GRx/V2HgnyGbsjpaqRnF
         ygWt61EL7jEwOdWX2RTcjoTHXTGx8KEywb7gc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:15:28 +0100
Message-Id: <20100118171528.14623.44156.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 12/64] pata_cs5520: convert to use ->init_host method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5520: convert to use ->init_host method

Remove bogus kernel warning while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5520.c |   55 +++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

Index: b/drivers/ata/pata_cs5520.c
===================================================================
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -115,6 +115,25 @@ static struct ata_port_operations cs5520
 	.set_piomode		= cs5520_set_piomode,
 };
 
+/**
+ *	cs5520_fixup	-	device fixup
+ *	@dev: device
+ *
+ *	We need to restore DMA mode support on BIOSen which disabled it.
+ */
+
+static int cs5520_fixup(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	u8 pcicfg;
+
+	pci_read_config_byte(pdev, 0x60, &pcicfg);
+	if ((pcicfg & 0x40) == 0)
+		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
+
+	return 0;
+}
+
 static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const unsigned int cmd_port[] = { 0x1F0, 0x170 };
@@ -148,11 +167,7 @@ static int __devinit cs5520_init_one(str
 	if (pcicfg & 2)
 		ppi[1] = &pi;
 
-	if ((pcicfg & 0x40) == 0) {
-		dev_printk(KERN_WARNING, &pdev->dev,
-			   "DMA mode disabled. Enabling.\n");
-		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
-	}
+	cs5520_fixup(&pdev->dev);
 
 	pi.mwdma_mask = id->driver_data;
 
@@ -160,6 +175,8 @@ static int __devinit cs5520_init_one(str
 	if (!host)
 		return -ENOMEM;
 
+	host->init_host = cs5520_fixup;
+
 	/* Perform set up for DMA */
 	if (pci_enable_device_io(pdev)) {
 		printk(KERN_ERR DRV_NAME ": unable to configure BAR2.\n");
@@ -233,32 +250,6 @@ static int __devinit cs5520_init_one(str
 
 #ifdef CONFIG_PM
 /**
- *	cs5520_reinit_one	-	device resume
- *	@pdev: PCI device
- *
- *	Do any reconfiguration work needed by a resume from RAM. We need
- *	to restore DMA mode support on BIOSen which disabled it
- */
-
-static int cs5520_reinit_one(struct pci_dev *pdev)
-{
-	struct ata_host *host = dev_get_drvdata(&pdev->dev);
-	u8 pcicfg;
-	int rc;
-
-	rc = ata_pci_device_do_resume(pdev);
-	if (rc)
-		return rc;
-
-	pci_read_config_byte(pdev, 0x60, &pcicfg);
-	if ((pcicfg & 0x40) == 0)
-		pci_write_config_byte(pdev, 0x60, pcicfg | 0x40);
-
-	ata_host_resume(host);
-	return 0;
-}
-
-/**
  *	cs5520_pci_device_suspend	-	device suspend
  *	@pdev: PCI device
  *
@@ -299,7 +290,7 @@ static struct pci_driver cs5520_pci_driv
 	.remove		= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend	= cs5520_pci_device_suspend,
-	.resume		= cs5520_reinit_one,
+	.resume		= ata_pci_device_resume,
 #endif
 };
 
