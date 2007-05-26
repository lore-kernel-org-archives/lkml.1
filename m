Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbXEZXtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbXEZXtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXEZXtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:49:24 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60559 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbXEZXtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:49:23 -0400
Date: Sat, 26 May 2007 19:49:22 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, liml@rtr.ca
Subject: [PATCH] convert sata_qstor to new libata EH
Message-ID: <20070526234922.GA14434@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is an attempt to convert sata_qstor over to new EH.
It compiles, but I have not tested it.  If anyone is willing to give
it an "it talks to the disks" test that would be great.

This is checked into the 'new-eh' branch of libata.  Review requested.

 drivers/ata/sata_qstor.c |   65 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 6688ccb..76ab39e 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -116,14 +116,15 @@ static void qs_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static int qs_port_start(struct ata_port *ap);
 static void qs_host_stop(struct ata_host *host);
-static void qs_phy_reset(struct ata_port *ap);
 static void qs_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int qs_qc_issue(struct ata_queued_cmd *qc);
 static int qs_check_atapi_dma(struct ata_queued_cmd *qc);
 static void qs_bmdma_stop(struct ata_queued_cmd *qc);
 static u8 qs_bmdma_status(struct ata_port *ap);
 static void qs_irq_clear(struct ata_port *ap);
-static void qs_eng_timeout(struct ata_port *ap);
+static void qs_freeze(struct ata_port *ap);
+static void qs_thaw(struct ata_port *ap);
+static void qs_error_handler(struct ata_port *ap);
 
 static struct scsi_host_template qs_ata_sht = {
 	.module			= THIS_MODULE,
@@ -152,11 +153,12 @@ static const struct ata_port_operations qs_ata_ops = {
 	.check_atapi_dma	= qs_check_atapi_dma,
 	.exec_command		= ata_exec_command,
 	.dev_select		= ata_std_dev_select,
-	.phy_reset		= qs_phy_reset,
 	.qc_prep		= qs_qc_prep,
 	.qc_issue		= qs_qc_issue,
 	.data_xfer		= ata_data_xfer,
-	.eng_timeout		= qs_eng_timeout,
+	.freeze			= qs_freeze,
+	.thaw			= qs_thaw,
+	.error_handler		= qs_error_handler,
 	.irq_clear		= qs_irq_clear,
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
@@ -172,8 +174,6 @@ static const struct ata_port_info qs_port_info[] = {
 	/* board_2068_idx */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_SATA_RESET |
-				  //FIXME ATA_FLAG_SRST |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
 		.udma_mask	= 0x7f, /* udma0-6 */
@@ -236,23 +236,35 @@ static inline void qs_reset_channel_logic(struct ata_port *ap)
 	qs_enter_reg_mode(ap);
 }
 
-static void qs_phy_reset(struct ata_port *ap)
+static void qs_freeze(struct ata_port *ap)
 {
-	struct qs_port_priv *pp = ap->private_data;
+	u8 __iomem *mmio_base = qs_mmio_base(ap->host);
 
-	pp->state = qs_state_idle;
-	qs_reset_channel_logic(ap);
-	sata_phy_reset(ap);
+	writeb(0, mmio_base + QS_HCT_CTRL); /* disable host interrupts */
+}
+
+static void qs_thaw(struct ata_port *ap)
+{
+	u8 __iomem *mmio_base = qs_mmio_base(ap->host);
+
+	writeb(1, mmio_base + QS_HCT_CTRL); /* enable host interrupts */
 }
 
-static void qs_eng_timeout(struct ata_port *ap)
+static int qs_prereset(struct ata_port *ap, unsigned long deadline)
 {
 	struct qs_port_priv *pp = ap->private_data;
 
 	if (pp->state != qs_state_idle) /* healthy paranoia */
 		pp->state = qs_state_mmio;
 	qs_reset_channel_logic(ap);
-	ata_eng_timeout(ap);
+
+	return ata_std_prereset(ap, deadline);
+}
+
+static void qs_error_handler(struct ata_port *ap)
+{
+	ata_do_eh(ap, qs_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
 }
 
 static u32 qs_scr_read (struct ata_port *ap, unsigned int sc_reg)
@@ -359,7 +371,6 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-
 		pp->state = qs_state_pkt;
 		qs_packet_start(qc);
 		return 0;
@@ -376,6 +387,26 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 	return ata_qc_issue_prot(qc);
 }
 
+static void qs_do_or_die(struct ata_queued_cmd *qc, u8 status)
+{
+	qc->err_mask |= ac_err_mask(status);
+
+	if (!qc->err_mask)
+		ata_qc_complete(qc);
+	else {
+		struct ata_port *ap = qc->ap;
+		struct ata_eh_info *ehi = &ap->eh_info;
+
+		ata_ehi_clear_desc(ehi);
+		ata_ehi_push_desc(ehi, "status 0x%02X", status);
+
+		if (qc->err_mask == AC_ERR_DEV)
+			ata_port_abort(ap);
+		else
+			ata_port_freeze(ap);
+	}
+}
+
 static inline unsigned int qs_intr_pkt(struct ata_host *host)
 {
 	unsigned int handled = 0;
@@ -409,8 +440,7 @@ static inline unsigned int qs_intr_pkt(struct ata_host *host)
 					case 3: /* device error */
 						pp->state = qs_state_idle;
 						qs_enter_reg_mode(qc->ap);
-						qc->err_mask |= ac_err_mask(sDST);
-						ata_qc_complete(qc);
+						qs_do_or_die(qc, sDST);
 						break;
 					default:
 						break;
@@ -447,8 +477,7 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 
 				/* complete taskfile transaction */
 				pp->state = qs_state_idle;
-				qc->err_mask |= ac_err_mask(status);
-				ata_qc_complete(qc);
+				qs_do_or_die(qc, status);
 				handled = 1;
 			}
 		}
