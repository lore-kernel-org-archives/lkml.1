Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYDYJUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYDYJUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbYDYJTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:19:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:44307 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbYDYJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67112907"
From: Bryan Wu <cooloney@kernel.org>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [libata/BF54x]: Fix bug - Implement bfin ata interrupt handler to avoid "irq 68 nobody cared" (v2)
Date: Fri, 25 Apr 2008 17:19:25 +0800
Message-Id: <1209115165-24995-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Return IRQ_HANDLED when bfin ata device is busy.
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3513

v1-v2:
 - fold api breakage fixing patch together.
 - mark 'static', not 'inline'.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/ata/pata_bf54x.c |  124 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index f334ba5..54473b3 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1272,8 +1272,8 @@ static void bfin_freeze(struct ata_port *ap)
 
 void bfin_thaw(struct ata_port *ap)
 {
+	dev_dbg(ap->dev, "in atapi dma thaw\n");
 	bfin_check_status(ap);
-	bfin_irq_clear(ap);
 	bfin_irq_on(ap);
 }
 
@@ -1339,13 +1339,130 @@ static int bfin_port_start(struct ata_port *ap)
 	return 0;
 }
 
+static unsigned int bfin_ata_host_intr(struct ata_port *ap,
+				   struct ata_queued_cmd *qc)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u8 status, host_stat = 0;
+
+	VPRINTK("ata%u: protocol %d task_state %d\n",
+		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
+
+	/* Check whether we are expecting interrupt in this state */
+	switch (ap->hsm_task_state) {
+	case HSM_ST_FIRST:
+		/* Some pre-ATAPI-4 devices assert INTRQ
+		 * at this state when ready to receive CDB.
+		 */
+
+		/* Check the ATA_DFLAG_CDB_INTR flag is enough here.
+		 * The flag was turned on only for atapi devices.
+		 * No need to check is_atapi_taskfile(&qc->tf) again.
+		 */
+		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
+			goto idle_irq;
+		break;
+	case HSM_ST_LAST:
+		if (qc->tf.protocol == ATA_PROT_DMA ||
+		    qc->tf.protocol == ATAPI_PROT_DMA) {
+			/* check status of DMA engine */
+			host_stat = ap->ops->bmdma_status(ap);
+			VPRINTK("ata%u: host_stat 0x%X\n",
+				ap->print_id, host_stat);
+
+			/* if it's not our irq... */
+			if (!(host_stat & ATA_DMA_INTR))
+				goto idle_irq;
+
+			/* before we do anything else, clear DMA-Start bit */
+			ap->ops->bmdma_stop(qc);
+
+			if (unlikely(host_stat & ATA_DMA_ERR)) {
+				/* error when transfering data to/from memory */
+				qc->err_mask |= AC_ERR_HOST_BUS;
+				ap->hsm_task_state = HSM_ST_ERR;
+			}
+		}
+		break;
+	case HSM_ST:
+		break;
+	default:
+		goto idle_irq;
+	}
+
+	/* check altstatus */
+	status = ap->ops->sff_check_altstatus(ap);
+	if (status & ATA_BUSY)
+		goto busy_ata;
+
+	/* check main status, clearing INTRQ */
+	status = ap->ops->sff_check_status(ap);
+	if (unlikely(status & ATA_BUSY))
+		goto busy_ata;
+
+	/* ack bmdma irq events */
+	ap->ops->sff_irq_clear(ap);
+
+	ata_sff_hsm_move(ap, qc, status, 0);
+
+	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
+				       qc->tf.protocol == ATAPI_PROT_DMA))
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+
+busy_ata:
+	return 1;	/* irq handled */
+
+idle_irq:
+	ap->stats.idle_irq++;
+
+#ifdef ATA_IRQ_TRAP
+	if ((ap->stats.idle_irq % 1000) == 0) {
+		ap->ops->irq_ack(ap, 0); /* debug trap */
+		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		return 1;
+	}
+#endif
+	return 0;	/* irq not handled */
+}
+
+static irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
+	spin_lock_irqsave(&host->lock, flags);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		ap = host->ports[i];
+		if (ap &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_queued_cmd *qc;
+
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+			    (qc->flags & ATA_QCFLAG_ACTIVE))
+				handled |= bfin_ata_host_intr(ap, qc);
+		}
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+
 static struct scsi_host_template bfin_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= SG_NONE,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 };
 
-static const struct ata_port_operations bfin_pata_ops = {
+static struct ata_port_operations bfin_pata_ops = {
 	.inherits		= &ata_sff_port_ops,
 
 	.set_piomode		= bfin_set_piomode,
@@ -1370,7 +1487,6 @@ static const struct ata_port_operations bfin_pata_ops = {
 	.thaw			= bfin_thaw,
 	.softreset		= bfin_softreset,
 	.postreset		= bfin_postreset,
-	.post_internal_cmd	= bfin_bmdma_stop,
 
 	.sff_irq_clear		= bfin_irq_clear,
 	.sff_irq_on		= bfin_irq_on,
@@ -1507,7 +1623,7 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	}
 
 	if (ata_host_activate(host, platform_get_irq(pdev, 0),
-		ata_sff_interrupt, IRQF_SHARED, &bfin_sht) != 0) {
+		bfin_ata_interrupt, IRQF_SHARED, &bfin_sht) != 0) {
 		peripheral_free_list(atapi_io_port);
 		dev_err(&pdev->dev, "Fail to attach ATAPI device\n");
 		return -ENODEV;
-- 
1.5.5
