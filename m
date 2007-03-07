Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbXCGQGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbXCGQGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXCGQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:06:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35778 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932404AbXCGQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:06:44 -0500
Date: Wed, 7 Mar 2007 17:08:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_hpt366: Cable detect methods
Message-ID: <20070307170822.0c7d9c77@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/drivers/ata/pata_hpt366.c linux-2.6.21-rc2-mm2/drivers/ata/pata_hpt366.c
--- linux.vanilla-2.6.21-rc2-mm2/drivers/ata/pata_hpt366.c	2007-03-06 23:09:46.000000000 +0000
+++ linux-2.6.21-rc2-mm2/drivers/ata/pata_hpt366.c	2007-03-06 23:35:15.000000000 +0000
@@ -27,7 +27,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.0"
+#define DRV_VERSION	"0.6.1"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -210,24 +209,26 @@
 	return 0xffffffffU;	/* silence compiler warning */
 }
 
+static int hpt36x_cable_detect(struct ata_port *ap)
+{
+	u8 ata66;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	pci_read_config_byte(pdev, 0x5A, &ata66);
+	if (ata66 & (1 << ap->port_no))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
 static int hpt36x_pre_reset(struct ata_port *ap)
 {
 	static const struct pci_bits hpt36x_enable_bits[] = {
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
-
-	u8 ata66;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
 	if (!pci_test_config_bits(pdev, &hpt36x_enable_bits[ap->port_no]))
 		return -ENOENT;
-
-	pci_read_config_byte(pdev, 0x5A, &ata66);
-	if (ata66 & (1 << ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
 	return ata_std_prereset(ap);
 }
 
@@ -354,6 +355,7 @@
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= hpt36x_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= hpt36x_cable_detect,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
