Return-Path: <linux-kernel-owner+w=401wt.eu-S1764976AbXKUA5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764976AbXKUA5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXKUA5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:57:16 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3433 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbXKUA5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:57:15 -0500
Date: Tue, 20 Nov 2007 18:56:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v2)
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <47438248.7030704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some problems with ATAPI devices on nForce4 controllers in ADMA
mode on systems with memory located above 4GB. We need to delay setting the
64-bit DMA mask until the PRD table and padding buffer are allocated so that
they don't get allocated above 4GB and break legacy mode (which is needed for
ATAPI devices). Also, explicitly set a 32-bit DMA mask before allocating the
legacy buffers since setting the DMA mask affects both ports and we need to
ensure the second port's buffers are allocated properly (fixes a problem
with the previous version of this patch).

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24-rc3-git1edit/drivers/ata/sata_nv.c.before2	2007-11-20 17:47:46.000000000 -0600
+++ linux-2.6.24-rc3-git1edit/drivers/ata/sata_nv.c	2007-11-20 17:50:30.000000000 -0600
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
@@ -1134,10 +1135,16 @@
 	void *mem;
 	dma_addr_t mem_dma;
 	void __iomem *mmio;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	u16 tmp;
 
 	VPRINTK("ENTER\n");
 
+	/* Ensure DMA mask is set to 32-bit before allocating legacy PRD and
+	   pad buffers */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+
 	rc = ata_port_start(ap);
 	if (rc)
 		return rc;
@@ -1153,6 +1160,14 @@
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
 
+	/* Now that the legacy PRD and padding buffer are allocated we can
+	   safely raise the DMA mask to allocate the CPB/APRD table. */
+	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	/* Store the mask that was actually used so we can restore it as
+	   the bounce limit later if needed */
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

