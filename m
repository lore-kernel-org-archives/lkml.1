Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXAXLoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXAXLoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXAXLoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:44:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41966 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbXAXLoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:44:04 -0500
Date: Wed, 24 Jan 2007 11:49:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] cmd64x: whack into a shape that looks like the
 documentation
Message-ID: <20070124114903.5ba01a93@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c linux-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c	2007-01-22 16:25:32.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c	2007-01-23 16:01:18.000000000 +0000
@@ -197,7 +198,7 @@
 static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u8 udma_data[] = {
-		0x31, 0x21, 0x11, 0x25, 0x15, 0x05
+		0x30, 0x20, 0x10, 0x20, 0x10, 0x00
 	};
 	static const u8 mwdma_data[] = {
 		0x30, 0x20, 0x10
@@ -213,12 +214,21 @@
 	pci_read_config_byte(pdev, pciD, &regD);
 	pci_read_config_byte(pdev, pciU, &regU);
 
-	regD &= ~(0x20 << shift);
-	regU &= ~(0x35 << shift);
+	/* DMA bits off */
+	regD &= ~(0x20 << adev->devno);
+	/* DMA control bits */
+	regU &= ~(0x30 << shift);
+	/* DMA timing bits */
+	regU &= ~(0x05 << adev->devno);
 
-	if (adev->dma_mode >= XFER_UDMA_0)
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		/* Merge thge timing value */
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
-	else
+		/* Merge the control bits */
+		regU |= 1 << adev->devno; /* UDMA on */
+		if (adev->dma_mode > 2)	/* 15nS timing */
+			regU |= 4 << adev->devno;
+	} else
 		regD |= mwdma_data[adev->dma_mode - XFER_MW_DMA_0] << shift;
 
 	regD |= 0x20 << adev->devno;
@@ -239,8 +249,8 @@
 	struct ata_port *ap = qc->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 dma_intr;
-	int dma_reg = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_mask = ap->port_no ? ARTTIM2 : CFR;
+	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
+	int dma_reg = ap->port_no ? ARTTIM2 : CFR;
 
 	ata_bmdma_stop(qc);
 
