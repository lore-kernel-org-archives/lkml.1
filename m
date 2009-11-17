Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZKQPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZKQPHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZKQPHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:07:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40518 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754356AbZKQPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:07:40 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/5] cmd64x: implement serialization as per notes
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:51:32 +0000
Message-ID: <20091117145122.15430.70080.stgit@localhost.localdomain>
In-Reply-To: <20091117144450.15430.83450.stgit@localhost.localdomain>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Second attempt)

Daniela Engert pointed out that there are some implementation notes for the
643 and 646 that deal with certain serialization rules. In theory we don't
need them because they apply when the motherboard decides not to retry PCI
requests for long enough and the chip is busy doing a DMA transfer on the
other channel.

The rule basically is "don't touch the taskfile of the other channel while
a DMA is in progress". To implement that we need to

- not issue a command on a channel when there is a DMA command queued
- not issue a DMA command on a channel when there are PIO commands queued
- use the alternative access to the interrupt source so that we do not
  touch altstatus or status on shared IRQ.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_cmd64x.c |  139 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 131 insertions(+), 8 deletions(-)


diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index f98dffe..48948ae 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.5"
+#define DRV_VERSION "0.3.1"
 
 /*
  * CMD64x specific registers definition.
@@ -75,6 +75,13 @@ enum {
 	DTPR1		= 0x7C
 };
 
+struct cmd_priv
+{
+	int dma_live;		/* Channel using DMA */
+	int irq_t[2];		/* Register to check for IRQ */
+	int irq_m[2];		/* Bit to check */
+};
+
 static int cmd648_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -254,17 +261,114 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 }
 
 /**
- *	cmd646r1_dma_stop	-	DMA stop callback
+ *	cmd64x_bmdma_stop	-	DMA stop callback
  *	@qc: Command in progress
  *
- *	Stub for now while investigating the r1 quirk in the old driver.
+ *	Track the completion of live DMA commands and clear the dma_live
+ *	tracking flag as we do.
  */
 
-static void cmd646r1_bmdma_stop(struct ata_queued_cmd *qc)
+static void cmd64x_bmdma_stop(struct ata_queued_cmd *qc)
 {
+	struct ata_port *ap = qc->ap;
+	struct cmd_priv *priv = ap->host->private_data;
 	ata_bmdma_stop(qc);
+	WARN_ON(priv->dma_live != ap->port_no );
+	priv->dma_live = -1;
 }
 
+/**
+ *	cmd64x_qc_defer		-	Defer logic for chip limits
+ *	@qc: queued command
+ *
+ *	Decide whether we can issue the command. Called under the host lock.
+ */
+
+static int cmd64x_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct cmd_priv *priv = host->private_data;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+	int dma = 0;
+
+	/* Apply the ATA rules first */
+	rc = ata_std_qc_defer(qc);
+	if (rc)
+		return rc;
+
+	if (qc->tf.protocol == ATAPI_PROT_DMA ||
+			qc->tf.protocol == ATA_PROT_DMA)
+		dma = 1;
+
+	/* If the other port is not live then issue the command */
+	if (alt == NULL || !alt->qc_active) {
+		if (dma)
+			priv->dma_live = qc->ap->port_no;
+		return 0;
+	}
+	/* If there is a live DMA command then wait */
+	if (priv->dma_live != -1)
+		return 	ATA_DEFER_PORT;
+	if (dma) {
+		/* Cannot overlap our DMA command */
+		if (alt->qc_active)
+			return ATA_DEFER_PORT;
+		/* Claim the DMA */
+		priv->dma_live = qc->ap->port_no;
+	}
+	return 0;
+}
+
+/**
+ *	cmd64x_interrupt - ATA host interrupt handler
+ *	@irq: irq line (unused)
+ *	@dev_instance: pointer to our ata_host information structure
+ *
+ *	Our interrupt handler for PCI IDE devices.  Calls
+ *	ata_sff_host_intr() for each port that is flagging an IRQ. We cannot
+ *	use the defaults as we need to avoid touching status/altstatus during
+ *	a DMA.
+ *
+ *	LOCKING:
+ *	Obtains host lock during operation.
+ *
+ *	RETURNS:
+ *	IRQ_NONE or IRQ_HANDLED.
+ */
+irqreturn_t cmd64x_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct cmd_priv *priv = host->private_data;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
+	spin_lock_irqsave(&host->lock, flags);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+		u8 reg;
+
+		pci_read_config_byte(pdev, priv->irq_t[i], &reg);
+		ap = host->ports[i];
+		if (ap && (reg & priv->irq_m[i]) &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_queued_cmd *qc;
+
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+			    (qc->flags & ATA_QCFLAG_ACTIVE))
+				handled |= ata_sff_host_intr(ap, qc);
+		}
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
 static struct scsi_host_template cmd64x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -273,6 +377,8 @@ static const struct ata_port_operations cmd64x_base_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 	.set_piomode	= cmd64x_set_piomode,
 	.set_dmamode	= cmd64x_set_dmamode,
+	.bmdma_stop	= cmd64x_bmdma_stop,
+	.qc_defer	= cmd64x_qc_defer,
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
@@ -282,7 +388,6 @@ static struct ata_port_operations cmd64x_port_ops = {
 
 static struct ata_port_operations cmd646r1_port_ops = {
 	.inherits	= &cmd64x_base_ops,
-	.bmdma_stop	= cmd646r1_bmdma_stop,
 	.cable_detect	= ata_cable_40wire,
 };
 
@@ -290,6 +395,7 @@ static struct ata_port_operations cmd648_port_ops = {
 	.inherits	= &cmd64x_base_ops,
 	.bmdma_stop	= cmd648_bmdma_stop,
 	.cable_detect	= cmd648_cable_detect,
+	.qc_defer	= ata_std_qc_defer
 };
 
 static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -340,6 +446,8 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
 	u8 mrdmode;
 	int rc;
+	struct ata_host *host;
+	struct cmd_priv *cpriv;
 
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -348,6 +456,17 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xFF;
 
+	cpriv = devm_kzalloc(&pdev->dev, sizeof(*cpriv), GFP_KERNEL);
+	if (cpriv == NULL)
+		return -ENOMEM;
+	cpriv->dma_live = -1;
+
+	/* Table for IRQ checking */
+	cpriv->irq_t[0] = CFR;
+	cpriv->irq_m[0] = 1 << 2;
+	cpriv->irq_t[1] = ARTTIM23;
+	cpriv->irq_m[1] = 1 << 4;
+
 	if (id->driver_data == 0)	/* 643 */
 		ata_pci_bmdma_clear_simplex(pdev);
 
@@ -360,20 +479,24 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			ppi[0] = &cmd_info[3];
 	}
 
+
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
 	pci_read_config_byte(pdev, MRDMODE, &mrdmode);
 	mrdmode &= ~ 0x30;	/* IRQ set up */
 	mrdmode |= 0x02;	/* Memory read line enable */
 	pci_write_config_byte(pdev, MRDMODE, mrdmode);
 
-	/* Force PIO 0 here.. */
-
 	/* PPC specific fixup copied from old driver */
 #ifdef CONFIG_PPC
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	host->private_data = cpriv;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
+	pci_set_master(pdev);
+	return ata_pci_sff_activate_host(host, cmd64x_interrupt, &cmd64x_sht);
 }
 
 #ifdef CONFIG_PM

