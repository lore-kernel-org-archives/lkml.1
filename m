Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbXKLXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbXKLXOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbXKLXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:14:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12806 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbXKLXOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:14:35 -0500
Date: Mon, 12 Nov 2007 17:13:37 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <4738DE21.8090702@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
on systems with memory located above 4GB. We need to make sure that the legacy
PRD table and padding buffer are appropriately allocated according to the
DMA mask requirements of the current operating mode (ADMA or legacy).

Also, we should run any DMA command with result taskfile requested in ADMA mode
when the port is in ADMA mode, otherwise it may try to use the legacy DMA engine
in ADMA mode which is not allowed.

Fixes Red Hat Bugzilla #351451: https://bugzilla.redhat.com/show_bug.cgi?id=351451

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24-rc1-git10/drivers/ata/sata_nv.c	2007-11-01 20:01:32.000000000 -0600
+++ linux-2.6.24-rc1-git10edit/drivers/ata/sata_nv.c	2007-11-10 19:57:47.000000000 -0600
@@ -247,6 +247,7 @@
 	void __iomem		*ctl_block;
 	void __iomem		*gen_block;
 	void __iomem		*notifier_clear_block;
+	u64			adma_dma_mask;
 	u8			flags;
 	int			last_issue_ncq;
 };
@@ -747,11 +748,29 @@
 		   on the port. */
 		adma_enable = 0;
 		nv_adma_register_mode(ap);
+		if (!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+			/* Transitioning to legacy mode. Free the pad buffer. */
+			ata_pad_free(ap, ap->host->dev);
+			ap->pad = NULL;
+			ap->pad_dma = 0;
+		}
 	} else {
-		bounce_limit = *ap->dev->dma_mask;
+		bounce_limit = pp->adma_dma_mask;
 		segment_boundary = NV_ADMA_DMA_BOUNDARY;
 		sg_tablesize = NV_ADMA_SGTBL_TOTAL_LEN;
 		adma_enable = 1;
+
+		if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+			/* Transitioning to ADMA mode. Free legacy PRD table
+			   and the pad buffer. */
+			ata_pad_free(ap, ap->host->dev);
+			ap->pad = NULL;
+			ap->pad_dma = 0;
+			dmam_free_coherent(ap->host->dev, ATA_PRD_TBL_SZ,
+				ap->prd, ap->prd_dma);
+			ap->prd = NULL;
+			ap->prd_dma = 0;
+		}
 	}
 
 	pci_read_config_dword(pdev, NV_MCP_SATA_CFG_20, &current_reg);
@@ -763,23 +782,45 @@
 		config_mask = NV_MCP_SATA_CFG_20_PORT0_EN |
 			      NV_MCP_SATA_CFG_20_PORT0_PWB_EN;
 
+	/* Set appropriate DMA mask. */
+	pci_set_dma_mask(pdev, bounce_limit);
+	pci_set_consistent_dma_mask(pdev, bounce_limit);
+
+	blk_queue_bounce_limit(sdev->request_queue, bounce_limit);
+	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
+	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
+	ata_port_printk(ap, KERN_INFO,
+		"bounce limit 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
+		(unsigned long long)bounce_limit, segment_boundary,
+		sg_tablesize);
+
 	if (adma_enable) {
 		new_reg = current_reg | config_mask;
-		pp->flags &= ~NV_ADMA_ATAPI_SETUP_COMPLETE;
+		if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+			/* Transition to ADMA mode.
+			   Reallocate the pad buffer. */
+			rc = ata_pad_alloc(ap, ap->host->dev);
+			pp->flags &= ~NV_ADMA_ATAPI_SETUP_COMPLETE;
+		}
 	} else {
 		new_reg = current_reg & ~config_mask;
-		pp->flags |= NV_ADMA_ATAPI_SETUP_COMPLETE;
+		if (!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE)) {
+			/* Transition to legacy mode.
+			   Reallocate the legacy PRD and pad buffer. */
+			ap->prd = dmam_alloc_coherent(ap->host->dev,
+				ATA_PRD_TBL_SZ, &ap->prd_dma, GFP_KERNEL);
+			if (!ap->prd)
+				rc = -ENOMEM;
+			else
+				rc = ata_pad_alloc(ap, ap->host->dev);
+
+			pp->flags |= NV_ADMA_ATAPI_SETUP_COMPLETE;
+		}
 	}
 
 	if (current_reg != new_reg)
 		pci_write_config_dword(pdev, NV_MCP_SATA_CFG_20, new_reg);
 
-	blk_queue_bounce_limit(sdev->request_queue, bounce_limit);
-	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
-	blk_queue_max_hw_segments(sdev->request_queue, sg_tablesize);
-	ata_port_printk(ap, KERN_INFO,
-		"bounce limit 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
-		(unsigned long long)bounce_limit, segment_boundary, sg_tablesize);
 	return rc;
 }
 
@@ -791,11 +832,13 @@
 
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
-	/* Since commands where a result TF is requested are not
-	   executed in ADMA mode, the only time this function will be called
-	   in ADMA mode will be if a command fails. In this case we
-	   don't care about going into register mode with ADMA commands
-	   pending, as the commands will all shortly be aborted anyway. */
+	/* Other than when internal or pass-through commands are executed,
+	   the only time this function will be called in ADMA mode will be
+	   if a command fails. In the failure case we don't care about going
+	   into register mode with ADMA commands pending, as the commands will
+	   all shortly be aborted anyway. We assume that NCQ commands are not
+	   issued via passthrough and so this will not abort any commands in
+	   that case. */
 	nv_adma_register_mode(ap);
 
 	ata_tf_read(ap, tf);
@@ -1136,7 +1179,9 @@
 
 	VPRINTK("ENTER\n");
 
-	rc = ata_port_start(ap);
+	/* Do not allocate standard ATA PRD buffer here. Only do this if
+	   an ATAPI device is connected (in slave_config). */
+	rc = ata_pad_alloc(ap, dev);
 	if (rc)
 		return rc;
 
@@ -1150,6 +1195,7 @@
 	pp->gen_block = ap->host->iomap[NV_MMIO_BAR] + NV_ADMA_GEN;
 	pp->notifier_clear_block = pp->gen_block +
 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
+	pp->adma_dma_mask = *dev->dma_mask & dev->coherent_dma_mask;
 
 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
 				  &mem_dma, GFP_KERNEL);
@@ -1359,11 +1405,9 @@
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
-	   or interrupt-driven no-data commands, where a result taskfile
-	   is not required. */
+	   or interrupt-driven no-data commands. */
 	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
-	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
-	   (qc->flags & ATA_QCFLAG_RESULT_TF))
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
 		return 1;
 
 	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||

