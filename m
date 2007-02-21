Return-Path: <linux-kernel-owner+w=401wt.eu-S965326AbXBUDvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326AbXBUDvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 22:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965324AbXBUDvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 22:51:47 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:23494 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965126AbXBUDvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 22:51:46 -0500
Date: Tue, 20 Feb 2007 21:49:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: kill old private BMDMA helper functions
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45DBC136.9060103@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sata_nv implemented its own copies of the BMDMA helper functions for ADMA,
since the ADMA BMDMA status registers are PIO while the other registers
are MMIO, and this was the only way to handle this previously. Now that
we have iomap support, the standard routines should just work, so use them.
The only thing we need to override as far as ADMA and BMDMA is the
post_internal_cmd callback, where we should only call ata_post_internal_cmd
if we are in port-register mode.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git14edit/drivers/ata/sata_nv.c.before_cleanup	2007-02-20 19:42:32.000000000 -0600
+++ linux-2.6.20-git14edit/drivers/ata/sata_nv.c	2007-02-20 19:45:44.000000000 -0600
@@ -255,10 +255,7 @@
 static int nv_adma_port_resume(struct ata_port *ap);
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc);
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc);
-static u8 nv_adma_bmdma_status(struct ata_port *ap);
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
 
 enum nv_host_type
 {
@@ -433,16 +430,16 @@
 	.exec_command		= ata_exec_command,
 	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
-	.bmdma_setup		= nv_adma_bmdma_setup,
-	.bmdma_start		= nv_adma_bmdma_start,
-	.bmdma_stop		= nv_adma_bmdma_stop,
-	.bmdma_status		= nv_adma_bmdma_status,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= nv_adma_qc_prep,
 	.qc_issue		= nv_adma_qc_issue,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
 	.error_handler		= nv_adma_error_handler,
-	.post_internal_cmd	= nv_adma_bmdma_stop,
+	.post_internal_cmd	= nv_adma_post_internal_cmd,
 	.data_xfer		= ata_data_xfer,
 	.irq_handler		= nv_adma_interrupt,
 	.irq_clear		= nv_adma_irq_clear,
@@ -899,73 +896,12 @@
 	iowrite8(ioread8(dma_stat_addr), dma_stat_addr);
 }
 
-static void nv_adma_bmdma_setup(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	unsigned int rw = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* load PRD table addr. */
-	iowrite32(ap->prd_dma, ap->ioaddr.bmdma_addr + ATA_DMA_TABLE_OFS);
-
-	/* specify data direction, triple-check start bit is clear */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	dmactl &= ~(ATA_DMA_WR | ATA_DMA_START);
-	if (!rw)
-		dmactl |= ATA_DMA_WR;
-
-	iowrite8(dmactl, ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* issue r/w command */
-	ata_exec_command(ap, &qc->tf);
-}
-
-static void nv_adma_bmdma_start(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-	u8 dmactl;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE)) {
-		WARN_ON(1);
-		return;
-	}
-
-	/* start host DMA transaction */
-	dmactl = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-	iowrite8(dmactl | ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-}
-
-static void nv_adma_bmdma_stop(struct ata_queued_cmd *qc)
+static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	struct ata_port *ap = qc->ap;
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	if(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE))
-		return;
-
-	/* clear start/stop bit */
-	iowrite8(ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD) & ~ATA_DMA_START,
-		 ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
-	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
-	ata_altstatus(ap);        /* dummy read */
-}
-
-static u8 nv_adma_bmdma_status(struct ata_port *ap)
-{
-	struct nv_adma_port_priv *pp = ap->private_data;
-
-	WARN_ON(!(pp->flags & NV_ADMA_PORT_REGISTER_MODE));
+	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
-	return ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+	if(pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+		ata_bmdma_post_internal_cmd(qc);
 }
 
 static int nv_adma_port_start(struct ata_port *ap)

