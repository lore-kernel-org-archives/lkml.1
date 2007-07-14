Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXGNIQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXGNIQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbXGNIQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:16:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54682 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbXGNIQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:16:34 -0400
Date: Sat, 14 Jul 2007 04:16:34 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] libata: add ->proto_mask
Message-ID: <20070714081633.GA27006@havoc.gtf.org>
References: <20070714081526.GA26878@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714081526.GA26878@havoc.gtf.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit c7baac44f3a02b895873cce48c6e426ddbea06b9
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 14 03:27:11 2007 -0400

    [libata] Introduce per-port taskfile protocol masks
    
    One ATA_PMASK_$name bitmapped value exists for each ATA_PROT_$name
    value.
    
    ->proto_mask member added to ata_port and ata_port_info for holding
    this data.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/libata-core.c |    3 +++
 drivers/ata/libata-scsi.c |    1 +
 include/linux/ata.h       |   20 ++++++++++++++++++++
 include/linux/libata.h    |    7 +++++++
 4 files changed, 31 insertions(+)

c7baac44f3a02b895873cce48c6e426ddbea06b9
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 88e2dd0..5cffca8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6007,6 +6007,7 @@ void ata_dev_init(struct ata_device *dev)
 	dev->pio_mask = UINT_MAX;
 	dev->mwdma_mask = UINT_MAX;
 	dev->udma_mask = UINT_MAX;
+	dev->proto_mask = UINT_MAX;
 }
 
 /**
@@ -6211,6 +6212,8 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 		ap->pio_mask = pi->pio_mask;
 		ap->mwdma_mask = pi->mwdma_mask;
 		ap->udma_mask = pi->udma_mask;
+		ap->proto_mask = pi->proto_mask;
+
 		ap->flags |= pi->flags;
 		ap->ops = pi->port_ops;
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cfde22d..f6da0cb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3234,6 +3234,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 	ap->pio_mask = port_info->pio_mask;
 	ap->mwdma_mask = port_info->mwdma_mask;
 	ap->udma_mask = port_info->udma_mask;
+	ap->proto_mask = port_info->proto_mask;
 	ap->flags |= port_info->flags;
 	ap->ops = port_info->port_ops;
 	ap->cbl = ATA_CBL_SATA;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b5a2016..c5c4780 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -283,6 +283,26 @@ enum ata_tf_protocols {
 	ATA_PROT_ATAPI_DMA,	/* packet command with special DMA sauce */
 };
 
+#define DEF(x) \
+	ATA_PMASK_##x = (1 << ATA_PROT_##x)
+enum ata_tf_proto_masks {
+	DEF(NODATA),
+	DEF(PIO),
+	DEF(DMA),
+	DEF(NCQ),
+	DEF(ATAPI),
+	DEF(ATAPI_NODATA),
+	DEF(ATAPI_DMA),
+};
+#undef DEF
+
+enum ata_standard_proto_masks {
+	ATA_PMASK_SFF		= ATA_PMASK_NODATA | ATA_PMASK_PIO |
+				  ATA_PMASK_ATAPI | ATA_PMASK_ATAPI_NODATA,
+	ATA_PMASK_SFF_DMA	= ATA_PMASK_SFF |
+				  ATA_PMASK_DMA | ATA_PMASK_ATAPI_DMA,
+};
+
 enum ata_ioctls {
 	ATA_IOC_GET_IO32	= 0x309,
 	ATA_IOC_SET_IO32	= 0x324,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 47cd2a1..2f9174c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -457,6 +457,7 @@ struct ata_device {
 	unsigned int		pio_mask;
 	unsigned int		mwdma_mask;
 	unsigned int		udma_mask;
+	unsigned int		proto_mask;
 
 	/* for CHS addressing */
 	u16			cylinders;	/* Number of cylinders */
@@ -524,9 +525,12 @@ struct ata_port {
 
 	u8			ctl;	/* cache of ATA control register */
 	u8			last_ctl;	/* Cache last written value */
+
 	unsigned int		pio_mask;
 	unsigned int		mwdma_mask;
 	unsigned int		udma_mask;
+	unsigned int		proto_mask;
+
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 	unsigned int		hw_sata_spd_limit;
 	unsigned int		sata_spd_limit;	/* SATA PHY speed limit */
@@ -638,9 +642,12 @@ struct ata_port_operations {
 struct ata_port_info {
 	struct scsi_host_template	*sht;
 	unsigned long		flags;
+
 	unsigned long		pio_mask;
 	unsigned long		mwdma_mask;
 	unsigned long		udma_mask;
+	unsigned long		proto_mask;
+
 	const struct ata_port_operations *port_ops;
 	irq_handler_t		irq_handler;
 	void 			*private_data;
