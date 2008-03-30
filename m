Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYC3TcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYC3TcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 15:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYC3TbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 15:31:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:29090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYC3Tau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 15:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=S2kVIFiLECIGZidqmitthY2Dt0rufTpnLN8Gy/U0CDRptJEU5z90F+ANLanaMKlFNT7OIUFh/BgkjjmNQAARebYL2LZ0OeOo7+Ej4KDZFzg8qlOd2uvgXosecRO3wgHvR2dWp4a0bL+fbR6ml3DH4x5aExjjy2MNnfmy2IQAj3I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/6] ide: add IDE_HFLAG_MMIO host flag
Date: Sun, 30 Mar 2008 21:43:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302143.56792.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IDE_HFLAG_MMIO host flag and set it for hosts which use
default_hwif_mmiops().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c          |    2 +-
 drivers/ide/arm/palm_bk3710.c     |    1 +
 drivers/ide/arm/rapide.c          |    1 +
 drivers/ide/legacy/ide_platform.c |    4 +++-
 drivers/ide/mips/swarm.c          |    1 +
 drivers/ide/pci/sgiioc4.c         |    1 +
 drivers/ide/pci/siimage.c         |    1 +
 drivers/ide/ppc/pmac.c            |    1 +
 include/linux/ide.h               |    2 ++
 9 files changed, 12 insertions(+), 2 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -481,7 +481,7 @@ static const struct ide_port_info icside
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.dma_ops		= &icside_v6_dma_ops,
-	.host_flags		= IDE_HFLAG_SERIALIZE,
+	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2,
 	.swdma_mask		= ATA_SWDMA2,
 };
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -342,6 +342,7 @@ static const struct ide_port_ops palm_bk
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
 	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -53,6 +53,7 @@ rapide_probe(struct expansion_card *ec, 
 
 		ide_init_port_hw(hwif, &hw);
 
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -101,8 +101,10 @@ static int __devinit plat_ide_probe(stru
 
 	ide_init_port_hw(hwif, &hw);
 
-	if (mmio)
+	if (mmio) {
+		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
+	}
 
 	idx[0] = hwif->index;
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -109,6 +109,7 @@ static int __devinit swarm_ide_probe(str
 	base = ioremap(offset, size);
 
 	/* Setup MMIO ops.  */
+	hwif->host_flags = IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 
 	hwif->chipset = ide_generic;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -573,6 +573,7 @@ static const struct ide_port_info sgiioc
 	.init_dma		= ide_dma_sgiioc4,
 	.port_ops		= &sgiioc4_port_ops,
 	.dma_ops		= &sgiioc4_dma_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
 	.mwdma_mask		= ATA_MWDMA2_ONLY,
 };
 
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -630,6 +630,7 @@ static void __devinit init_mmio_iops_sii
 	 *	Fill in the basic HWIF bits
 	 */
 
+	hwif->host_flags |= IDE_HFLAG_MMIO;
 	default_hwif_mmiops(hwif);
 	hwif->hwif_data			= addr;
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -942,6 +942,7 @@ static const struct ide_port_info pmac_p
 	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
 				  IDE_HFLAG_POST_SET_MODE |
 				  IDE_HFLAG_UNMASK_IRQS,
+				  IDE_HFLAG_MMIO,
 	.pio_mask		= ATA_PIO4,
 	.mwdma_mask		= ATA_MWDMA2,
 };
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1057,6 +1057,8 @@ enum {
 	IDE_HFLAG_NO_DMA		= (1 << 14),
 	/* check if host is PCI IDE device before allowing DMA */
 	IDE_HFLAG_NO_AUTODMA		= (1 << 15),
+	/* host uses MMIO */
+	IDE_HFLAG_MMIO			= (1 << 16),
 	/* host is CS5510/CS5520 */
 	IDE_HFLAG_CS5520		= IDE_HFLAG_VDMA,
 	/* no LBA48 */
