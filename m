Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbZKYR1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbZKYR1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbZKYR1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:27:33 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061AbZKYREP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UFNYk/MOTq/PAsIjVW/zQpoFiJfgzTP9+BudJvwQKOXykHLE2+IdWXVKTtZQkQtB9m
         AaEI0Fb4Ilw/YbGxs/Q2b5UhO5k/JOZDppth2yoIcZhrJOGRNZP4KMuNL31zlp5NTLxE
         ZeE89ESaNyL2FhVDwj9qtitZLK/dMjkLMfdXI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:37 +0100
Message-Id: <20091125170337.5446.40572.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 11/86] pata_atiixp: remove custom BMDMA methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: remove custom BMDMA methods

Enable/disable UDMA bit only once in ->set_dmamode method
and then remove custom ->bmdma_[start,stop] methods.

There shouldn't be any problems with it as IDE atiixp host driver
has been doing it this way for last two years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   58 ++++------------------------------------------
 1 file changed, 6 insertions(+), 52 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -107,6 +107,9 @@ static void atiixp_set_dmamode(struct at
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int dma = adev->dma_mode;
 	int dn = 2 * ap->port_no + adev->devno;
+	u16 tmp16;
+
+	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		u16 udma_mode_data;
@@ -117,6 +120,8 @@ static void atiixp_set_dmamode(struct at
 		udma_mode_data &= ~(0x7 << (4 * dn));
 		udma_mode_data |= dma << (4 * dn);
 		pci_write_config_word(pdev, ATIIXP_IDE_UDMA_MODE, udma_mode_data);
+
+		tmp16 |= (1 << dn);
 	} else {
 		int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
 		u32 mwdma_timing_data;
@@ -129,60 +134,11 @@ static void atiixp_set_dmamode(struct at
 		mwdma_timing_data |= (mwdma_timings[dma] << timing_shift);
 		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
 				       mwdma_timing_data);
-	}
-}
-
-/**
- *	atiixp_bmdma_start	-	DMA start callback
- *	@qc: Command in progress
- *
- *	When DMA begins we need to ensure that the UDMA control
- *	register for the channel is correctly set.
- *
- *	Note: The host lock held by the libata layer protects
- *	us from two channels both trying to set DMA bits at once
- */
-
-static void atiixp_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ata_device *adev = qc->dev;
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int dn = (2 * ap->port_no) + adev->devno;
-	u16 tmp16;
 
-	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
-	if (ata_using_udma(adev))
-		tmp16 |= (1 << dn);
-	else
 		tmp16 &= ~(1 << dn);
-	pci_write_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
-	ata_bmdma_start(qc);
-}
-
-/**
- *	atiixp_dma_stop	-	DMA stop callback
- *	@qc: Command in progress
- *
- *	DMA has completed. Clear the UDMA flag as the next operations will
- *	be PIO ones not UDMA data transfer.
- *
- *	Note: The host lock held by the libata layer protects
- *	us from two channels both trying to set DMA bits at once
- */
-
-static void atiixp_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int dn = (2 * ap->port_no) + qc->dev->devno;
-	u16 tmp16;
+	}
 
-	pci_read_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, &tmp16);
-	tmp16 &= ~(1 << dn);
 	pci_write_config_word(pdev, ATIIXP_IDE_UDMA_CONTROL, tmp16);
-	ata_bmdma_stop(qc);
 }
 
 static struct scsi_host_template atiixp_sht = {
@@ -194,8 +150,6 @@ static struct ata_port_operations atiixp
 	.inherits	= &ata_bmdma32_port_ops,
 
 	.qc_prep 	= ata_sff_dumb_qc_prep,
-	.bmdma_start 	= atiixp_bmdma_start,
-	.bmdma_stop	= atiixp_bmdma_stop,
 
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
