Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXGNISf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXGNISf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXGNISW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:18:22 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54688 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbXGNIST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:18:19 -0400
Date: Sat, 14 Jul 2007 04:18:18 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] libata: replace ATA_FLAG_{NCQ,NO_ATAPI} using ->proto_mask
Message-ID: <20070714081818.GC27006@havoc.gtf.org>
References: <20070714081526.GA26878@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714081526.GA26878@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit a02791c8298bc0c2202a49c5e781ed2c68132dc8
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 14 04:10:11 2007 -0400

    [libata] Use ->proto_mask to replace NCQ and NO_ATAPI flags
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/ahci.c           |    2 +-
 drivers/ata/libata-core.c    |    2 +-
 drivers/ata/libata-scsi.c    |    2 +-
 drivers/ata/pata_ixp4xx_cf.c |    4 ++--
 drivers/ata/sata_mv.c        |   19 ++++++++++---------
 drivers/ata/sata_nv.c        |    4 ++--
 drivers/ata/sata_sil24.c     |    8 ++++----
 drivers/ata/sata_sx4.c       |    5 +++--
 include/linux/ata.h          |    2 ++
 include/linux/libata.h       |    2 --
 10 files changed, 26 insertions(+), 24 deletions(-)

a02791c8298bc0c2202a49c5e781ed2c68132dc8
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9043642..676aa6c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1801,7 +1801,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* prepare host */
 	if (!(pi.flags & AHCI_FLAG_NO_NCQ) && (hpriv->cap & HOST_CAP_NCQ))
-		pi.flags |= ATA_FLAG_NCQ;
+		pi.proto_mask |= ATA_PMASK_NCQ;
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, fls(hpriv->port_map));
 	if (!host)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5cffca8..5036e83 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1789,7 +1789,7 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 		snprintf(desc, desc_sz, "NCQ (not used)");
 		return;
 	}
-	if (ap->flags & ATA_FLAG_NCQ) {
+	if (ap->proto_mask & ATA_PMASK_NCQ) {
 		hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
 		dev->flags |= ATA_DFLAG_NCQ;
 	}
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f6da0cb..60ccf12 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2458,7 +2458,7 @@ static int ata_scsi_dev_enabled(struct ata_device *dev)
 	if (unlikely(!ata_dev_enabled(dev)))
 		return 0;
 
-	if (!atapi_enabled || (dev->ap->flags & ATA_FLAG_NO_ATAPI)) {
+	if (!atapi_enabled || (!(dev->ap->proto_mask & ATA_PMASK_ALL_ATAPI))) {
 		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
 			ata_dev_printk(dev, KERN_WARNING,
 				       "WARNING: ATAPI is %s, device ignored.\n",
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 121e7af..cb81a43 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -201,8 +201,8 @@ static __devinit int ixp4xx_pata_probe(struct platform_device *pdev)
 
 	ap->ops	= &ixp4xx_port_ops;
 	ap->pio_mask = 0x1f; /* PIO4 */
-	ap->proto_mask = ATA_PMASK_SFF;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
+	ap->proto_mask = ATA_PMASK_NODATA | ATA_PMASK_PIO;
+	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY;
 
 	ixp4xx_setup_port(&ap->ioaddr, data);
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index f45867e..8cd4384 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -127,9 +127,10 @@ enum {
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 	MV_FLAG_IRQ_COALESCE	= (1 << 29),  /* IRQ coalescing capability */
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
-				  ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 	MV_6XXX_FLAGS		= MV_FLAG_IRQ_COALESCE,
+	MV_PMASK		= ATA_PMASK_NODATA | ATA_PMASK_PIO |
+				  ATA_PMASK_DMA,
 
 	CRQB_FLAG_READ		= (1 << 0),
 	CRQB_TAG_SHIFT		= 1,
@@ -574,28 +575,28 @@ static const struct ata_port_info mv_port_info[] = {
 		.flags		= MV_COMMON_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
 		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
 		.flags		= MV_COMMON_FLAGS | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
@@ -603,21 +604,21 @@ static const struct ata_port_info mv_port_info[] = {
 				  MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= MV_PMASK,
 		.port_ops	= &mv_iie_ops,
 	},
 };
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index af1035b..3b634d7 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -493,11 +493,11 @@ static const struct ata_port_info nv_port_info[] = {
 		.sht		= &nv_adma_sht,
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_HRST_TO_RESUME |
-				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
+				  ATA_FLAG_MMIO,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= ATA_PMASK_SFF_DMA | ATA_PMASK_NCQ,
 		.port_ops	= &nv_adma_ops,
 		.irq_handler	= nv_adma_interrupt,
 	},
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 614e3bf..2869cc4 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -237,7 +237,7 @@ enum {
 	/* host flags */
 	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				  ATA_FLAG_NCQ | ATA_FLAG_SKIP_D2H_BSY |
+				  ATA_FLAG_SKIP_D2H_BSY |
 				  ATA_FLAG_ACPI_SATA,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
 
@@ -427,7 +427,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= ATA_PMASK_SFF_DMA | ATA_PMASK_NCQ,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3132 */
@@ -436,7 +436,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= ATA_PMASK_SFF_DMA | ATA_PMASK_NCQ,
 		.port_ops	= &sil24_ops,
 	},
 	/* sil_3131/sil_3531 */
@@ -445,7 +445,7 @@ static const struct ata_port_info sil24_port_info[] = {
 		.pio_mask	= 0x1f,			/* pio0-4 */
 		.mwdma_mask	= 0x07,			/* mwdma0-2 */
 		.udma_mask	= ATA_UDMA5,		/* udma0-5 */
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= ATA_PMASK_SFF_DMA | ATA_PMASK_NCQ,
 		.port_ops	= &sil24_ops,
 	},
 };
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 4aeaa36..5817a8c 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -276,11 +276,12 @@ static const struct ata_port_info pdc_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_SRST | ATA_FLAG_MMIO |
-				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
-		.proto_mask	= ATA_PMASK_SFF_DMA,
+		.proto_mask	= ATA_PMASK_NODATA | ATA_PMASK_PIO |
+				  ATA_PMASK_DMA,
 		.port_ops	= &pdc_20621_ops,
 	},
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index c5c4780..30afb66 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -301,6 +301,8 @@ enum ata_standard_proto_masks {
 				  ATA_PMASK_ATAPI | ATA_PMASK_ATAPI_NODATA,
 	ATA_PMASK_SFF_DMA	= ATA_PMASK_SFF |
 				  ATA_PMASK_DMA | ATA_PMASK_ATAPI_DMA,
+	ATA_PMASK_ALL_ATAPI	= ATA_PMASK_ATAPI | ATA_PMASK_ATAPI_NODATA |
+				  ATA_PMASK_ATAPI_DMA,
 };
 
 enum ata_ioctls {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2f9174c..c1239d4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -164,12 +164,10 @@ enum {
 	ATA_FLAG_MMIO		= (1 << 3), /* use MMIO, not PIO */
 	ATA_FLAG_SRST		= (1 << 4), /* (obsolete) use ATA SRST, not E.D.D. */
 	ATA_FLAG_SATA_RESET	= (1 << 5), /* (obsolete) use COMRESET */
-	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */
 	ATA_FLAG_PIO_POLLING	= (1 << 9), /* use polling PIO if LLD
 					     * doesn't handle PIO interrupts */
-	ATA_FLAG_NCQ		= (1 << 10), /* host supports NCQ */
 	ATA_FLAG_HRST_TO_RESUME	= (1 << 11), /* hardreset to resume phy */
 	ATA_FLAG_SKIP_D2H_BSY	= (1 << 12), /* can't wait for the first D2H
 					      * Register FIS clearing BSY */
