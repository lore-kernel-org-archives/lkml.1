Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYBEBkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYBEBkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYBEBkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:40:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12716 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbYBEBko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:40:44 -0500
Date: Mon, 04 Feb 2008 19:39:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: fix ATAPI issues with memory over 4GB (v7)
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <47A7BE36.1010902@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
on systems with memory located above 4GB. We need to delay setting the 64-bit
DMA mask until the PRD table and padding buffer are allocated so that they don't
get allocated above 4GB and break legacy mode (which is needed for ATAPI
devices). Also, if either port is in ATAPI mode we need to set the DMA mask
for the PCI device to 32-bit to ensure that the IOMMU code properly bounces
requests above 4GB, as it appears setting the bounce limit does not guarantee
that we will not try to map requests above this point.

Reported to fix https://bugzilla.redhat.com/show_bug.cgi?id=351451

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24/drivers/ata/sata_nv.c	2008-01-24 16:58:37.000000000 -0600
+++ linux-2.6.24edit/drivers/ata/sata_nv.c	2008-01-29 18:39:37.000000000 -0600
@@ -247,6 +247,7 @@ struct nv_adma_port_priv {
 	void __iomem		*ctl_block;
 	void __iomem		*gen_block;
 	void __iomem		*notifier_clear_block;
+	u64			adma_dma_mask;
 	u8			flags;
 	int			last_issue_ncq;
 };
@@ -715,9 +716,10 @@ static int nv_adma_slave_config(struct s
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct nv_adma_port_priv *pp = ap->private_data;
+	struct nv_adma_port_priv *port0, *port1;
+	struct scsi_device *sdev0, *sdev1;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u64 bounce_limit;
-	unsigned long segment_boundary;
+	unsigned long segment_boundary, flags;
 	unsigned short sg_tablesize;
 	int rc;
 	int adma_enable;
@@ -729,6 +731,8 @@ static int nv_adma_slave_config(struct s
 		/* Not a proper libata device, ignore */
 		return rc;
 
+	spin_lock_irqsave(ap->lock, flags);
+
 	if (ap->link.device[sdev->id].class == ATA_DEV_ATAPI) {
 		/*
 		 * NVIDIA reports that ADMA mode does not support ATAPI commands.
@@ -737,7 +741,6 @@ static int nv_adma_slave_config(struct s
 		 * Restrict DMA parameters as required by the legacy interface
 		 * when an ATAPI device is connected.
 		 */
-		bounce_limit = ATA_DMA_MASK;
 		segment_boundary = ATA_DMA_BOUNDARY;
 		/* Subtract 1 since an extra entry may be needed for padding, see
 		   libata-scsi.c */
@@ -748,7 +751,6 @@ static int nv_adma_slave_config(struct s
 		adma_enable = 0;
 		nv_adma_register_mode(ap);
 	} else {
-		bounce_limit = *ap->dev->dma_mask;
 		segment_boundary = NV_ADMA_DMA_BOUNDARY;
 		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
 		adma_enable = 1;
@@ -774,12 +776,49 @@ static int nv_adma_slave_config(struct s
 	if (current_reg != new_reg)
 		pci_write_config_dword(pdev, NV_MCP_SATA_CFG_20, new_reg);
 
-	blk_queue_bounce_limit(sdev->request_queue, bounce_limit);
+	port0 = ap->host->ports[0]->private_data;
+	port1 = ap->host->ports[1]->private_data;
+	sdev0 = ap->host->ports[0]->link.device[0].sdev;
+	sdev1 = ap->host->ports[1]->link.device[0].sdev;
+	if ((port0->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
+	    (port1->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+		/** We have to set the DMA mask to 32-bit if either port is in
+		    ATAPI mode, since they are on the same PCI device which is
+		    used for DMA mapping. If we set the mask we also need to set
+		    the bounce limit on both ports to ensure that the block
+		    layer doesn't feed addresses that cause DMA mapping to
+		    choke. If either SCSI device is not allocated yet, it's OK
+		    since that port will discover its correct setting when it
+		    does get allocated.
+		    Note: Setting 32-bit mask should not fail. */
+		if (sdev0)
+			blk_queue_bounce_limit(sdev0->request_queue,
+					       ATA_DMA_MASK);
+		if (sdev1)
+			blk_queue_bounce_limit(sdev1->request_queue,
+					       ATA_DMA_MASK);
+
+		pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	} else {
+		/** This shouldn't fail as it was set to this value before */
+		pci_set_dma_mask(pdev, pp->adma_dma_mask);
+		if (sdev0)
+			blk_queue_bounce_limit(sdev0->request_queue,
+					       pp->adma_dma_mask);
+		if (sdev1)
+			blk_queue_bounce_limit(sdev1->request_queue,
+					       pp->adma_dma_mask);
+	}
+
 	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
 	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
 	ata_port_printk(ap, KERN_INFO,
-		"bounce limit 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
-		(unsigned long long)bounce_limit, segment_boundary, sg_tablesize);
+		"DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
+		(unsigned long long)*ap->host->dev->dma_mask,
+		segment_boundary, sg_tablesize);
+
+	spin_unlock_irqrestore(ap->lock, flags);
+
 	return rc;
 }
 
@@ -1134,10 +1173,20 @@ static int nv_adma_port_start(struct ata
 	void *mem;
 	dma_addr_t mem_dma;
 	void __iomem *mmio;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 tmp;
 
 	VPRINTK("ENTER\n");
 
+	/* Ensure DMA mask is set to 32-bit before allocating legacy PRD and
+	   pad buffers */
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (rc)
+		return rc;
+
 	rc = ata_port_start(ap);
 	if (rc)
 		return rc;
@@ -1153,6 +1202,15 @@ static int nv_adma_port_start(struct ata
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
 
+	/* Now that the legacy PRD and padding buffer are allocated we can
+	   safely raise the DMA mask to allocate the CPB/APRD table.
+	   These are allowed to fail since we store the value that ends up
+	   being used to set as the bounce limit in slave_config later if
+	   needed. */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	pp->adma_dma_mask = *dev->dma_mask;
+
 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
 				  &mem_dma, GFP_KERNEL);
 	if (!mem)
@@ -2418,12 +2476,6 @@ static int nv_init_one(struct pci_dev *p
 	hpriv->type = type;
 	host->private_data = hpriv;
 
-	/* set 64bit dma masks, may fail */
-	if (type == ADMA) {
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0)
-			pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-	}
-
 	/* request and iomap NV_MMIO_BAR */
 	rc = pcim_iomap_regions(pdev, 1 << NV_MMIO_BAR, DRV_NAME);
 	if (rc)

