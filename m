Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZCXKXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZCXKXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 06:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbZCXKXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 06:23:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46153 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757685AbZCXKXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 06:23:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/4] libata: Drain data on errors
To: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 24 Mar 2009 10:23:19 +0000
Message-ID: <20090324102230.9152.26655.stgit@localhost.localdomain>
In-Reply-To: <20090324101952.9152.30261.stgit@localhost.localdomain>
References: <20090324101952.9152.30261.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

If the device is signalling that there is data to drain after an error we
should read the bytes out and throw them away. Without this some devices
and controllers get wedged and don't recover.

Based on earlier work by Mark Lord

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/ata/libata-sff.c  |   45 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/ata/pata_pcmcia.c |   34 +++++++++++++++++++++++++++++++++-
 include/linux/libata.h    |    3 +++
 3 files changed, 79 insertions(+), 3 deletions(-)


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index f93dc02..9a10cb0 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -52,6 +52,7 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.softreset		= ata_sff_softreset,
 	.hardreset		= sata_sff_hardreset,
 	.postreset		= ata_sff_postreset,
+	.drain_fifo		= ata_sff_drain_fifo,
 	.error_handler		= ata_sff_error_handler,
 	.post_internal_cmd	= ata_sff_post_internal_cmd,
 
@@ -2199,6 +2200,39 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
 
 /**
+ *	ata_sff_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@qc: command
+ *
+ *	Drain the FIFO and device of any stuck data following a command
+ *	failing to complete. In some cases this is neccessary before a
+ *	reset will recover the device.
+ *
+ */
+
+void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
+{
+	int count;
+	struct ata_port *ap;
+
+	/* We only need to flush incoming data when a command was running */
+	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
+		return;
+
+	ap = qc->ap;
+	/* Drain up to 64K of data before we give up this recovery method */
+	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
+						&& count < 32768; count++)
+		ioread16(ap->ioaddr.data_addr);
+
+	/* Can become DEBUG later */
+	if (count)
+		ata_port_printk(ap, KERN_DEBUG,
+			"drained %d bytes to clear DRQ.\n", count);
+
+}
+EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
+
+/**
  *	ata_sff_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2239,7 +2273,8 @@ void ata_sff_error_handler(struct ata_port *ap)
 		 * really a timeout event, adjust error mask and
 		 * cancel frozen state.
 		 */
-		if (qc->err_mask == AC_ERR_TIMEOUT && (host_stat & ATA_DMA_ERR)) {
+		if (qc->err_mask == AC_ERR_TIMEOUT
+						&& (host_stat & ATA_DMA_ERR)) {
 			qc->err_mask = AC_ERR_HOST_BUS;
 			thaw = 1;
 		}
@@ -2250,6 +2285,13 @@ void ata_sff_error_handler(struct ata_port *ap)
 	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
+	/* We *MUST* do FIFO draining before we issue a reset as several
+	 * devices helpfully clear their internal state and will lock solid
+	 * if we touch the data port post reset. Pass qc in case anyone wants
+	 *  to do different PIO/DMA recovery or has per command fixups
+	 */
+	if (ap->ops->drain_fifo)
+		ap->ops->drain_fifo(qc);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -2959,4 +3001,3 @@ out:
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
-
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 64b2e22..48ac25e 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.3"
+#define DRV_VERSION "0.3.5"
 
 /*
  *	Private data structure to glue stuff together
@@ -126,6 +126,37 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
 	return buflen;
 }
 
+/**
+ *	pcmcia_8bit_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@qc: command
+ *
+ *	Drain the FIFO and device of any stuck data following a command
+ *	failing to complete. In some cases this is neccessary before a
+ *	reset will recover the device.
+ *
+ */
+ 
+void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
+{
+	int count;
+	struct ata_port *ap;
+
+	/* We only need to flush incoming data when a command was running */
+	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
+		return;
+
+	ap = qc->ap;
+
+	/* Drain up to 64K of data before we give up this recovery method */
+	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
+							&& count++ < 65536;)
+		ioread8(ap->ioaddr.data_addr);
+
+	if (count)
+		ata_port_printk(ap, KERN_WARNING, "drained %d bytes to clear DRQ.\n",
+								count);
+
+}
 
 static struct scsi_host_template pcmcia_sht = {
 	ATA_PIO_SHT(DRV_NAME),
@@ -143,6 +174,7 @@ static struct ata_port_operations pcmcia_8bit_port_ops = {
 	.sff_data_xfer	= ata_data_xfer_8bit,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= pcmcia_set_mode_8bit,
+	.drain_fifo	= pcmcia_8bit_drain_fifo,
 };
 
 #define CS_CHECK(fn, ret) \
diff --git a/include/linux/libata.h b/include/linux/libata.h
index dc18b87..ffcef1f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -836,6 +836,8 @@ struct ata_port_operations {
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
+
+	void (*drain_fifo)(struct ata_queued_cmd *qc);
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -1584,6 +1586,7 @@ extern int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 			       unsigned long deadline);
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
+extern void ata_sff_drain_fifo(struct ata_queued_cmd *qc);
 extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_sff_port_start(struct ata_port *ap);

