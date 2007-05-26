Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbXEZXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbXEZXIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbXEZXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:08:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60496 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXEZXIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:08:34 -0400
Date: Sat, 26 May 2007 19:08:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, liml@rtr.ca
Subject: [PATCH] convert pdc_adma to new libata EH
Message-ID: <20070526230828.GA13434@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is an attempt to convert pdc_adma over to new EH.  It
compiles, but I have not tested it.  If anyone is willing to give it an
"it talks to the disks" test that would be great.

This hardware is -mostly- compatible with the docs on
http://www.T13.org/ (look for d1510r1) according to Mark, IIRC.

This is checked into the 'new-eh' branch of libata.  Review requested.

 drivers/ata/pdc_adma.c |   98 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index f12c2b6..5195f3f 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -92,6 +92,8 @@ enum {
 
 	/* CPB bits */
 	cDONE			= (1 << 0),
+	cATERR			= (1 << 3),
+
 	cVLD			= (1 << 0),
 	cDAT			= (1 << 2),
 	cIEN			= (1 << 3),
@@ -131,46 +133,48 @@ static int adma_ata_init_one (struct pci_dev *pdev,
 static int adma_port_start(struct ata_port *ap);
 static void adma_host_stop(struct ata_host *host);
 static void adma_port_stop(struct ata_port *ap);
-static void adma_phy_reset(struct ata_port *ap);
 static void adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int adma_qc_issue(struct ata_queued_cmd *qc);
 static int adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void adma_bmdma_stop(struct ata_queued_cmd *qc);
 static u8 adma_bmdma_status(struct ata_port *ap);
 static void adma_irq_clear(struct ata_port *ap);
-static void adma_eng_timeout(struct ata_port *ap);
+static void adma_freeze(struct ata_port *ap);
+static void adma_thaw(struct ata_port *ap);
+static void adma_error_handler(struct ata_port *ap);
 
 static struct scsi_host_template adma_ata_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+	.proc_name		= DRV_NAME,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
+	.dma_boundary		= ADMA_DMA_BOUNDARY,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
-	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ENABLE_CLUSTERING,
-	.proc_name		= DRV_NAME,
-	.dma_boundary		= ADMA_DMA_BOUNDARY,
-	.slave_configure	= ata_scsi_slave_config,
-	.slave_destroy		= ata_scsi_slave_destroy,
-	.bios_param		= ata_std_bios_param,
+	.emulated		= ATA_SHT_EMULATED,
 };
 
 static const struct ata_port_operations adma_ata_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
-	.check_status		= ata_check_status,
-	.check_atapi_dma	= adma_check_atapi_dma,
 	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= adma_phy_reset,
+	.check_atapi_dma	= adma_check_atapi_dma,
+	.data_xfer		= ata_data_xfer,
 	.qc_prep		= adma_qc_prep,
 	.qc_issue		= adma_qc_issue,
-	.eng_timeout		= adma_eng_timeout,
-	.data_xfer		= ata_data_xfer,
+	.freeze			= adma_freeze,
+	.thaw			= adma_thaw,
+	.error_handler		= adma_error_handler,
 	.irq_clear		= adma_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -273,24 +277,41 @@ static inline void adma_enter_reg_mode(struct ata_port *ap)
 	readb(chan + ADMA_STATUS);	/* flush */
 }
 
-static void adma_phy_reset(struct ata_port *ap)
+static void adma_freeze(struct ata_port *ap)
 {
-	struct adma_port_priv *pp = ap->private_data;
+	void __iomem *chan = ADMA_PORT_REGS(ap);
+
+	/* mask/clear ATA interrupts */
+	writeb(ATA_NIEN, ap->ioaddr.ctl_addr);
+	ata_check_status(ap);
+
+	/* reset ADMA to idle state */
+	writew(aPIOMD4 | aNIEN | aRSTADM, chan + ADMA_CONTROL);
+	udelay(2);
+	writew(aPIOMD4 | aNIEN, chan + ADMA_CONTROL);
+	udelay(2);
+}
 
-	pp->state = adma_state_idle;
+static void adma_thaw(struct ata_port *ap)
+{
 	adma_reinit_engine(ap);
-	ata_port_probe(ap);
-	ata_bus_reset(ap);
 }
 
-static void adma_eng_timeout(struct ata_port *ap)
+static int adma_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct adma_port_priv *pp = ap->private_data;
 
 	if (pp->state != adma_state_idle) /* healthy paranoia */
 		pp->state = adma_state_mmio;
 	adma_reinit_engine(ap);
-	ata_eng_timeout(ap);
+
+	return ata_std_prereset(ap, deadline);
+}
+
+static void adma_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, adma_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static int adma_fill_sg(struct ata_queued_cmd *qc)
@@ -466,12 +487,31 @@ static inline unsigned int adma_intr_pkt(struct ata_host *host)
 			continue;
 		qc = ata_qc_from_tag(ap, ap->active_tag);
 		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-			if ((status & (aPERR | aPSD | aUIRQ)))
+			if (status & aPERR)
+				qc->err_mask |= AC_ERR_HOST_BUS;
+			else if ((status & (aPSD | aUIRQ)))
 				qc->err_mask |= AC_ERR_OTHER;
+
+			if (pp->pkt[0] & cATERR)
+				qc->err_mask |= AC_ERR_DEV;
 			else if (pp->pkt[0] != cDONE)
 				qc->err_mask |= AC_ERR_OTHER;
 
-			ata_qc_complete(qc);
+			if (!qc->err_mask)
+				ata_qc_complete(qc);
+			else {
+				struct ata_eh_info *ehi = &ap->eh_info;
+				ata_ehi_clear_desc(ehi);
+				ata_ehi_push_desc(ehi,
+					"ADMA-status 0x%02X", status);
+				ata_ehi_push_desc(ehi,
+					"pkt[0] 0x%02X", pp->pkt[0]);
+
+				if (qc->err_mask == AC_ERR_DEV)
+					ata_port_abort(ap);
+				else
+					ata_port_freeze(ap);
+			}
 		}
 	}
 	return handled;
@@ -502,7 +542,19 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 				/* complete taskfile transaction */
 				pp->state = adma_state_idle;
 				qc->err_mask |= ac_err_mask(status);
-				ata_qc_complete(qc);
+				if (!qc->err_mask)
+					ata_qc_complete(qc);
+				else {
+					struct ata_eh_info *ehi = &ap->eh_info;
+					ata_ehi_clear_desc(ehi);
+					ata_ehi_push_desc(ehi,
+						"status 0x%02X", status);
+
+					if (qc->err_mask == AC_ERR_DEV)
+						ata_port_abort(ap);
+					else
+						ata_port_freeze(ap);
+				}
 				handled = 1;
 			}
 		}
