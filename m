Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZKYRDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZKYRDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758936AbZKYRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:35 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758943AbZKYRDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sFK6HqNaPdf0059gAzO5lCQ1UqNJk3eVHFquFTLUEvjLKSLWuF5THjHOAWfjFtQNjt
         PLFteCYtHHQxHZ64TrGExwOQXmSAwYsapE6RiannZEaPfZyVVjNE4mAkcMluLzN5X1qv
         d3wLLn//mqQQ/5Hx8grB3DTeyBiujLMbGGRxA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:02:53 +0100
Message-Id: <20091125170253.5446.62167.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 05/86] pata_artop: add Power Management support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: add Power Management support

There shouldn't be any problems with it as IDE aec62xx host driver
has been supporting Power Management for over year now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.c |   72 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 21 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -2,7 +2,7 @@
  *    pata_artop.c - ARTOP ATA controller driver
  *
  *	(C) 2006 Red Hat
- *	(C) 2007 Bartlomiej Zolnierkiewicz
+ *	(C) 2007,2009 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
  *	Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
@@ -330,6 +330,33 @@ static struct ata_port_operations atp86x
 	.prereset		= atp86x_pre_reset,
 };
 
+static void atp8xx_fixup(struct pci_dev *pdev)
+{
+	if (pdev->device == 0x0005)
+		/* BIOS may have left us in UDMA, clear it before probe */
+		pci_write_config_byte(pdev, 0x54, 0);
+	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
+		u8 reg;
+
+		/* Mac systems come up with some registers not set as we
+		   will need them */
+
+		/* Clear reset & test bits */
+		pci_read_config_byte(pdev, 0x49, &reg);
+		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);
+
+		/* PCI latency must be > 0x80 for burst mode, tweak it
+		 * if required.
+		 */
+		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
+		if (reg <= 0x80)
+			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
+
+		/* Enable IRQ output and burst mode */
+		pci_read_config_byte(pdev, 0x4a, &reg);
+		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
+	}
+}
 
 /**
  *	artop_init_one - Register ARTOP ATA PCI device with kernel services
@@ -389,41 +416,40 @@ static int artop_init_one (struct pci_de
 
 	if (id->driver_data == 0) {		/* AEC6210 */
 		ppi[0] = &atp850_info;
-		/* BIOS may have left us in UDMA, clear it before libata probe */
-		pci_write_config_byte(pdev, 0x54, 0);
 	} else if (id->driver_data == 1) {	/* AEC6260[R] */
 		ppi[0] = &atp860_info;
 	} else if (id->driver_data == 2) { 	/* AEC6280[R] */
 		unsigned long io = pci_resource_start(pdev, 4);
-		u8 reg;
 
 		ppi[0] = &atp865_info;
 		if (inb(io) & 0x10)		/* AEC6880[R] */
 			ppi[0] = &atp865_133_info;
-		/* Mac systems come up with some registers not set as we
-		   will need them */
-
-		/* Clear reset & test bits */
-		pci_read_config_byte(pdev, 0x49, &reg);
-		pci_write_config_byte(pdev, 0x49, reg & ~ 0x30);
-
-		/* PCI latency must be > 0x80 for burst mode, tweak it
-		 * if required.
-		 */
-		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &reg);
-		if (reg <= 0x80)
-			pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x90);
-
-		/* Enable IRQ output and burst mode */
-		pci_read_config_byte(pdev, 0x4a, &reg);
-		pci_write_config_byte(pdev, 0x4a, (reg & ~0x01) | 0x80);
 	}
 
 	BUG_ON(ppi[0] == NULL);
 
+	atp8xx_fixup(pdev);
+
 	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL);
 }
 
+#ifdef CONFIG_PM
+static int atp8xx_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	atp8xx_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id artop_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, 0x0005), 0 },
 	{ PCI_VDEVICE(ARTOP, 0x0006), 1 },
@@ -439,6 +465,10 @@ static struct pci_driver artop_pci_drive
 	.id_table		= artop_pci_tbl,
 	.probe			= artop_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= atp8xx_reinit_one,
+#endif
 };
 
 static int __init artop_init(void)
