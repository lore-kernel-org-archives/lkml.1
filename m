Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbXKNESP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbXKNESP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXKNER7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:17:59 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:25682 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbXKNER6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:17:58 -0500
Date: Tue, 13 Nov 2007 22:15:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 2/2] sata_nv: fix ATAPI issues with memory over 4GB (v3)
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <473A7677.6080007@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
on systems with memory located above 4GB. We need to delay setting the 64-bit
DMA mask until the PRD table and padding buffer are allocated so that they don't
get allocated above 4GB and break legacy mode (which is needed for ATAPI
devices).

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24-rc1-git10edit/drivers/ata/sata_nv.c.before	2007-11-13 19:04:18.000000000 -0600
+++ linux-2.6.24-rc1-git10edit/drivers/ata/sata_nv.c	2007-11-13 19:02:34.000000000 -0600
@@ -247,6 +247,7 @@
 	void __iomem		*ctl_block;
 	void __iomem		*gen_block;
 	void __iomem		*notifier_clear_block;
+	u64			adma_dma_mask;
 	u8			flags;
 	int			last_issue_ncq;
 };
@@ -748,7 +749,7 @@
 		adma_enable = 0;
 		nv_adma_register_mode(ap);
 	} else {
-		bounce_limit = *ap->dev->dma_mask;
+		bounce_limit = pp->adma_dma_mask;
 		segment_boundary = NV_ADMA_DMA_BOUNDARY;
 		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
 		adma_enable = 1;
@@ -763,6 +764,11 @@
 		config_mask = NV_MCP_SATA_CFG_20_PORT0_EN |
 			      NV_MCP_SATA_CFG_20_PORT0_PWB_EN;
 
+	/* Set appropriate DMA mask. */
+	rc = pci_set_dma_mask(pdev, bounce_limit);
+	if (rc)
+		return rc;
+
 	if (adma_enable) {
 		new_reg = current_reg | config_mask;
 		pp->flags &= ~NV_ADMA_ATAPI_SETUP_COMPLETE;
@@ -1134,6 +1140,7 @@
 	void *mem;
 	dma_addr_t mem_dma;
 	void __iomem *mmio;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 tmp;
 
 	VPRINTK("ENTER\n");
@@ -1153,6 +1160,14 @@
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
 
+	/* Now that the legacy PRD and padding buffer are allocated we can
+	   safely raise the DMA mask to allocate the CPB/APRD table. */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	/* Store the mask that was actually used so we can restore it later
+	   if needed */
+	pp->adma_dma_mask = *dev->dma_mask;
+
 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
 				  &mem_dma, GFP_KERNEL);
 	if (!mem)
@@ -2408,12 +2423,6 @@
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

