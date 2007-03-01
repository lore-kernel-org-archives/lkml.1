Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXCAQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXCAQ4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965397AbXCAQ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:56:01 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45872 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965388AbXCAQ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:56:00 -0500
Date: Thu, 1 Mar 2007 17:59:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_cmd64x - various fixes
Message-ID: <20070301175939.3dfc25e6@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This driver still needs more work but for the moment

- It's a CMD not ATI driver
- Clean up code by using cable method

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_cmd64x.c linux-2.6.21-rc2/drivers/ata/pata_cmd64x.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_cmd64x.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_cmd64x.c	2007-03-01 14:49:51.491226440 +0000
@@ -1,5 +1,5 @@
 /*
- * pata_cmd64x.c 	- ATI PATA for new ATA layer
+ * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
  *
@@ -75,13 +75,7 @@
 	DTPR1		= 0x7C
 };
 
-static int cmd64x_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-static int cmd648_pre_reset(struct ata_port *ap)
+static int cmd648_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 r;
@@ -89,21 +83,8 @@
 	/* Check cable detect bits */
 	pci_read_config_byte(pdev, BMIDECSR, &r);
 	if (r & (1 << ap->port_no))
-		ap->cbl = ATA_CBL_PATA80;
-	else
-		ap->cbl = ATA_CBL_PATA40;
-
-	return ata_std_prereset(ap);
-}
-
-static void cmd64x_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, cmd64x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-static void cmd648_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, cmd648_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
+		return ATA_CBL_PATA80;
+	return ATA_CBL_PATA40;
 }
 
 /**
@@ -302,8 +283,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -336,8 +318,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd64x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -370,8 +353,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= cmd648_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= cmd648_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
