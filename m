Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYKUVpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYKUVpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 16:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYKUVoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 16:44:24 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:58041 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbYKUVoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 16:44:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=OdkExD2PVCFxWkabFmkG0sNBLMTnNryhTNoC7GVArEkREapknsl/zNtyLMPt9SbsiS
         6cuMS0NnGZD3SXPZJWJQ9tG0mAPjQ1MEyUPRqaTWJAk6fB3oRTvAtGt1KGmHmEm5rg6P
         Exet9mM44ZYzBRrwJdh5I9zPkdWbx+7uHVd/w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: add ->max_sectors field to struct ide_port_info
Date: Fri, 21 Nov 2008 22:42:08 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811212242.08182.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ->max_sectors field to struct ide_port_info to allow host drivers
  to specify value used for hwif->rqsize (if smaller than the default).

* Convert pdc202xx_old to use ->max_sectors and remove no longer needed
  IDE_HFLAG_RQSIZE_256 flag.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "trm290: add IDE_HFLAG_TRM290 host flag" patch in pata-2.6 tree

 drivers/ide/ide-probe.c    |    4 ++--
 drivers/ide/pdc202xx_old.c |    9 +++++----
 include/linux/ide.h        |    5 +++--
 3 files changed, 10 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1442,8 +1442,8 @@ static void ide_init_port(ide_hwif_t *hw
 			hwif->mate->serialized = hwif->serialized = 1;
 	}
 
-	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
-		hwif->rqsize = 256;
+	if (d->max_sectors)
+		hwif->rqsize = d->max_sectors;
 
 	/* call chipset specific routine for each enabled port */
 	if (d->init_hwif)
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -350,16 +350,17 @@ static const struct ide_dma_ops pdc2026x
 	.dma_timeout		= pdc202xx_dma_timeout,
 };
 
-#define DECLARE_PDC2026X_DEV(udma, extra_flags) \
+#define DECLARE_PDC2026X_DEV(udma, sectors) \
 	{ \
 		.name		= DRV_NAME, \
 		.init_chipset	= init_chipset_pdc202xx, \
 		.port_ops	= &pdc2026x_port_ops, \
 		.dma_ops	= &pdc2026x_dma_ops, \
-		.host_flags	= IDE_HFLAGS_PDC202XX | extra_flags, \
+		.host_flags	= IDE_HFLAGS_PDC202XX, \
 		.pio_mask	= ATA_PIO4, \
 		.mwdma_mask	= ATA_MWDMA2, \
 		.udma_mask	= udma, \
+		.max_sectors	= sectors, \
 	}
 
 static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
@@ -376,8 +377,8 @@ static const struct ide_port_info pdc202
 
 	/* 1: PDC2026{2,3} */
 	DECLARE_PDC2026X_DEV(ATA_UDMA4, 0),
-	/* 2: PDC2026{5,7} */
-	DECLARE_PDC2026X_DEV(ATA_UDMA5, IDE_HFLAG_RQSIZE_256),
+	/* 2: PDC2026{5,7}: UDMA5, limit LBA48 requests to 256 sectors */
+	DECLARE_PDC2026X_DEV(ATA_UDMA5, 256),
 };
 
 /**
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1365,8 +1365,6 @@ enum {
 	IDE_HFLAG_LEGACY_IRQS		= (1 << 21),
 	/* force use of legacy IRQs */
 	IDE_HFLAG_FORCE_LEGACY_IRQS	= (1 << 22),
-	/* limit LBA48 requests to 256 sectors */
-	IDE_HFLAG_RQSIZE_256		= (1 << 23),
 	/* use 32-bit I/O ops */
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
@@ -1404,6 +1402,9 @@ struct ide_port_info {
 
 	ide_pci_enablebit_t	enablebits[2];
 	hwif_chipset_t		chipset;
+
+	u16			max_sectors;	/* if < than the default one */
+
 	u32			host_flags;
 	u8			pio_mask;
 	u8			swdma_mask;
