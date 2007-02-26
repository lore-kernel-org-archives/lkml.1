Return-Path: <linux-kernel-owner+w=401wt.eu-S933779AbXBZG1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779AbXBZG1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXBZG1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:27:47 -0500
Received: from havoc.gtf.org ([69.61.125.42]:38370 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933776AbXBZG1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:27:46 -0500
Date: Mon, 26 Feb 2007 01:27:45 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_mv: fix DMA boundary, 64-bit PCI DMA issues
Message-ID: <20070226062745.GA16486@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit b350d3ae0a21fd093d99644a3cfb90f4fb275cb2
Author: Jeff Garzik <jeff@garzik.org>
Date:   Mon Feb 26 01:26:06 2007 -0500

    [libata] sata_mv: clean up DMA boundary issues, turn on 64-bit DMA
    
    The chips covered by sata_mv have a 32-bit DMA boundary they must not
    cross, not a 64K boundary.  We are merely limited to a 64K maximum
    segment size.  Therefore, the DMA scatter/gather table fill code can be
    greatly simplified, and we need not cut in half the S/G table size as
    reported to the SCSI layer.
    
    Also, the driver forget to turn on 64-bit DMA at the PCI layer.  All
    other data structures (both hardware and software) have been prepped for
    64-bit PCI DMA.  It was simply never turned on.  <fingers crossed> let's
    see if it still works...
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/sata_mv.c |   84 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 208a9d8..6162668 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -253,10 +253,7 @@ enum {
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
 
 enum {
-	/* Our DMA boundary is determined by an ePRD being unable to handle
-	 * anything larger than 64KB
-	 */
-	MV_DMA_BOUNDARY		= 0xffffU,
+	MV_DMA_BOUNDARY		= 0xffffffffU,
 
 	EDMA_REQ_Q_BASE_LO_MASK	= 0xfffffc00U,
 
@@ -384,10 +381,10 @@ static struct scsi_host_template mv_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= MV_USE_Q_DEPTH,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= MV_MAX_SG_CT / 2,
+	.sg_tablesize		= MV_MAX_SG_CT,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
-	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= MV_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
@@ -585,6 +582,39 @@ static const struct mv_hw_ops mv6xxx_ops = {
 static int msi;	      /* Use PCI msi; either zero (off, default) or non-zero */
 
 
+/* move to PCI layer or libata core? */
+static int pci_go_64(struct pci_dev *pdev)
+{
+	int rc;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
 /*
  * Functions
  */
@@ -957,38 +987,30 @@ static void mv_port_stop(struct ata_port *ap)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_fill_sg(struct ata_queued_cmd *qc)
+static unsigned int mv_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct mv_port_priv *pp = qc->ap->private_data;
-	unsigned int i = 0;
+	unsigned int n_sg = 0;
 	struct scatterlist *sg;
+	struct mv_sg *mv_sg;
 
+	mv_sg = pp->sg_tbl;
 	ata_for_each_sg(sg, qc) {
-		dma_addr_t addr;
-		u32 sg_len, len, offset;
-
-		addr = sg_dma_address(sg);
-		sg_len = sg_dma_len(sg);
-
-		while (sg_len) {
-			offset = addr & MV_DMA_BOUNDARY;
-			len = sg_len;
-			if ((offset + sg_len) > 0x10000)
-				len = 0x10000 - offset;
-
-			pp->sg_tbl[i].addr = cpu_to_le32(addr & 0xffffffff);
-			pp->sg_tbl[i].addr_hi = cpu_to_le32((addr >> 16) >> 16);
-			pp->sg_tbl[i].flags_size = cpu_to_le32(len & 0xffff);
+		dma_addr_t addr = sg_dma_address(sg);
+		u32 sg_len = sg_dma_len(sg);
 
-			sg_len -= len;
-			addr += len;
+		mv_sg->addr = cpu_to_le32(addr & 0xffffffff);
+		mv_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		mv_sg->flags_size = cpu_to_le32(sg_len & 0xffff);
 
-			if (!sg_len && ata_sg_is_last(sg, qc))
-				pp->sg_tbl[i].flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
+		if (ata_sg_is_last(sg, qc))
+			mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
 
-			i++;
-		}
+		mv_sg++;
+		n_sg++;
 	}
+
+	return n_sg;
 }
 
 static inline unsigned mv_inc_q_index(unsigned index)
@@ -2327,6 +2349,10 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+	rc = pci_go_64(pdev);
+	if (rc)
+		return rc;
+
 	probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
 	if (probe_ent == NULL)
 		return -ENOMEM;
