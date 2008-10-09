Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYJIQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYJIQo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYJIQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:44:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49622 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752156AbYJIQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:44:16 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH] libata: Better timeout recovery
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Thu, 09 Oct 2008 17:44:15 +0100
Message-ID: <20081009164351.26205.50193.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for completed commands on a timeout, also implement data draining as
Mark Lord suggested. The former should help a lot on various promise
controllers which show random IRQ loss now and then, the latter at least for
me fixes the hanging DRQ cases I can test.

To get the lost IRQ recovery working better we really need to short circuit a
lot fo the recovery paths we trigger needlessly when EH finds that actually
all was well.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/ata/libata-eh.c   |   19 +++++++++-
 drivers/ata/libata-sff.c  |   88 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/pata_isapnp.c |   12 +++++-
 drivers/ata/pata_pcmcia.c |   35 +++++++++++++++++-
 include/linux/libata.h    |    5 +++
 5 files changed, 153 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c1db2f2..fa48031 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -515,7 +515,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 
 	/* For new EH, all qcs are finished in one of three ways -
 	 * normal completion, error completion, and SCSI timeout.
-	 * Both cmpletions can race against SCSI timeout.  When normal
+	 * Both completions can race against SCSI timeout.  When normal
 	 * completion wins, the qc never reaches EH.  When error
 	 * completion wins, the qc has ATA_QCFLAG_FAILED set.
 	 *
@@ -530,7 +530,19 @@ void ata_scsi_error(struct Scsi_Host *host)
 		int nr_timedout = 0;
 
 		spin_lock_irqsave(ap->lock, flags);
-
+		
+		/* This must occur under the ap->lock as we don't want
+		   a polled recovery to race the real interrupt handler
+		   
+		   The lost_interrupt handler checks for any completed but
+		   non-notified command and completes much like an IRQ handler.
+		   
+		   We then fall into the error recovery code which will treat
+		   this as if normal completion won the race */
+
+		if (ap->ops->lost_interrupt)
+			ap->ops->lost_interrupt(ap);
+			
 		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
@@ -574,6 +586,9 @@ void ata_scsi_error(struct Scsi_Host *host)
 		ap->eh_tries = ATA_EH_MAX_TRIES;
 	} else
 		spin_unlock_wait(ap->lock);
+		
+	/* If we timed raced normal completion and there is nothing to
+	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
 
  repeat:
 	/* invoke error handler */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2a4c516..ea7f0e1 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -52,6 +52,7 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.softreset		= ata_sff_softreset,
 	.hardreset		= sata_sff_hardreset,
 	.postreset		= ata_sff_postreset,
+	.drain_fifo		= ata_sff_drain_fifo,
 	.error_handler		= ata_sff_error_handler,
 	.post_internal_cmd	= ata_sff_post_internal_cmd,
 
@@ -64,6 +65,8 @@ const struct ata_port_operations ata_sff_port_ops = {
 	.sff_irq_on		= ata_sff_irq_on,
 	.sff_irq_clear		= ata_sff_irq_clear,
 
+	.lost_interrupt		= ata_sff_lost_interrupt,
+
 	.port_start		= ata_sff_port_start,
 };
 
@@ -1533,7 +1536,7 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
  *	RETURNS:
  *	One if interrupt was handled, zero if not (shared irq).
  */
-inline unsigned int ata_sff_host_intr(struct ata_port *ap,
+unsigned int ata_sff_host_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc)
 {
 	struct ata_eh_info *ehi = &ap->link.eh_info;
@@ -1660,6 +1663,47 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 }
 
 /**
+ *	ata_sff_lost_interrupt	-	Check for an apparent lost interrupt
+ *	@ap: port that appears to have timed out
+ *
+ *	Called from the libata error handlers when the core code suspects
+ *	an interrupt has been lost. If it has complete anything we can and
+ *	then return. Interface must support altstatus for this faster
+ *	recovery to occur.
+ *
+ *	Locking:
+ *	Caller holds host lock
+ */
+
+void ata_sff_lost_interrupt(struct ata_port *ap)
+{
+	u8 status;
+	struct ata_queued_cmd *qc;
+
+	/* Only one outstanding command per SFF channel */
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	/* Check we have a live one.. */
+	if (qc == NULL ||  !(qc->flags & ATA_QCFLAG_ACTIVE))
+		return;
+	/* We cannot lose an interrupt on a polled command */
+	if (qc->tf.flags & ATA_TFLAG_POLLING)
+		return;
+	/* See if the controller thinks it is still busy - if so the command
+	   isn't a lost IRQ but is still in progress */
+	status = ata_sff_altstatus(ap);
+	if (!(status & ATA_BUSY))
+		return;
+		
+	/* There was a command running, we are no longer busy and we have
+	   no interrupt. */
+	ata_port_printk(ap, KERN_WARNING, "lost interrupt (Status 0x%x)\n",
+								status);
+	/* Run the host interrupt logic as if the interrupt had not been
+	   lost */
+	ata_sff_host_intr(ap, qc);
+}
+
+/**
  *	ata_sff_freeze - Freeze SFF controller port
  *	@ap: port to freeze
  *
@@ -2073,6 +2117,39 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
 }
 
 /**
+ *	ata_sff_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@ap: port to drain
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
+		ata_port_printk(ap, KERN_WARNING,
+			"drained %d bytes to clear DRQ.\n", count);
+
+}
+
+/**
  *	ata_sff_error_handler - Stock error handler for BMDMA controller
  *	@ap: port to handle error for
  *
@@ -2124,6 +2201,12 @@ void ata_sff_error_handler(struct ata_port *ap)
 	ata_sff_sync(ap);		/* FIXME: We don't need this */
 	ap->ops->sff_check_status(ap);
 	ap->ops->sff_irq_clear(ap);
+	/* We *MUST* do FIFO draining before we issue a reset as several
+	   devices helpfully clear their internal state and will lock solid
+	   if we touch the data port post reset. Pass qc in case anyone wants
+	   to do different PIO/DMA recovery or has per command fixups */
+	if (ap->ops->drain_fifo)
+		ap->ops->drain_fifo(qc);
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
@@ -2131,6 +2214,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 		ata_eh_thaw_port(ap);
 
 	/* PIO and DMA engines have been stopped, perform recovery */
+	
 
 	/* Ignore ata_sff_softreset if ctl isn't accessible and
 	 * built-in hardresets if SCR access isn't available.
@@ -2830,6 +2914,7 @@ EXPORT_SYMBOL_GPL(ata_sff_qc_issue);
 EXPORT_SYMBOL_GPL(ata_sff_qc_fill_rtf);
 EXPORT_SYMBOL_GPL(ata_sff_host_intr);
 EXPORT_SYMBOL_GPL(ata_sff_interrupt);
+EXPORT_SYMBOL_GPL(ata_sff_lost_interrupt);
 EXPORT_SYMBOL_GPL(ata_sff_freeze);
 EXPORT_SYMBOL_GPL(ata_sff_thaw);
 EXPORT_SYMBOL_GPL(ata_sff_prereset);
@@ -2838,6 +2923,7 @@ EXPORT_SYMBOL_GPL(ata_sff_wait_after_reset);
 EXPORT_SYMBOL_GPL(ata_sff_softreset);
 EXPORT_SYMBOL_GPL(sata_sff_hardreset);
 EXPORT_SYMBOL_GPL(ata_sff_postreset);
+EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
 EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 EXPORT_SYMBOL_GPL(ata_sff_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_sff_port_start);
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 15cdb91..eb50be8 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -17,7 +17,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_isapnp"
-#define DRV_VERSION "0.2.2"
+#define DRV_VERSION "0.2.5"
 
 static struct scsi_host_template isapnp_sht = {
 	ATA_PIO_SHT(DRV_NAME),
@@ -28,6 +28,13 @@ static struct ata_port_operations isapnp_port_ops = {
 	.cable_detect	= ata_cable_40wire,
 };
 
+static struct ata_port_operations isapnp_noalt_port_ops = {
+	.inherits	= &ata_sff_port_ops,
+	.cable_detect	= ata_cable_40wire,
+	/* No altstatus so we don't want to use the lost interrupt poll */
+	.lost_interrupt = ATA_OP_NULL,
+};
+
 /**
  *	isapnp_init_one		-	attach an isapnp interface
  *	@idev: PnP device
@@ -65,7 +72,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 
 	ap = host->ports[0];
 
-	ap->ops = &isapnp_port_ops;
+	ap->ops = &isapnp_noalt_port_ops;
 	ap->pio_mask = 1;
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
@@ -76,6 +83,7 @@ static int isapnp_init_one(struct pnp_dev *idev, const struct pnp_device_id *dev
 					   pnp_port_start(idev, 1), 1);
 		ap->ioaddr.altstatus_addr = ctl_addr;
 		ap->ioaddr.ctl_addr = ctl_addr;
+		ap->ops = &isapnp_port_ops;
 	}
 
 	ata_sff_std_ports(&ap->ioaddr);
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index d3f2c0d..d240d08 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.3"
+#define DRV_VERSION "0.3.5"
 
 /*
  *	Private data structure to glue stuff together
@@ -126,6 +126,38 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
 	return buflen;
 }
 
+/**
+ *	pcmcia_8bit_drain_fifo - Stock FIFO drain logic for SFF controllers
+ *	@ap: port to drain
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
+							&& count < 65536;)
+		ioread8(ap->ioaddr.data_addr);
+
+	/* Can become DEBUG later */
+	ata_port_printk(ap, KERN_WARNING, "drained %d bytes to clear DRQ.\n",
+								count);
+
+}
 
 static struct scsi_host_template pcmcia_sht = {
 	ATA_PIO_SHT(DRV_NAME),
@@ -143,6 +175,7 @@ static struct ata_port_operations pcmcia_8bit_port_ops = {
 	.sff_data_xfer	= ata_data_xfer_8bit,
 	.cable_detect	= ata_cable_40wire,
 	.set_mode	= pcmcia_set_mode_8bit,
+	.drain_fifo	= pcmcia_8bit_drain_fifo,
 };
 
 #define CS_CHECK(fn, ret) \
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 225bfc5..e4a72f6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -767,6 +767,7 @@ struct ata_port_operations {
 	ata_reset_fn_t		pmp_hardreset;
 	ata_postreset_fn_t	pmp_postreset;
 	void (*error_handler)(struct ata_port *ap);
+	void (*lost_interrupt)(struct ata_port *ap);
 	void (*post_internal_cmd)(struct ata_queued_cmd *qc);
 
 	/*
@@ -808,6 +809,8 @@ struct ata_port_operations {
 	void (*bmdma_start)(struct ata_queued_cmd *qc);
 	void (*bmdma_stop)(struct ata_queued_cmd *qc);
 	u8   (*bmdma_status)(struct ata_port *ap);
+
+	void (*drain_fifo)(struct ata_queued_cmd *qc);
 #endif /* CONFIG_ATA_SFF */
 
 	ssize_t (*em_show)(struct ata_port *ap, char *buf);
@@ -1516,6 +1519,7 @@ extern bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc);
 extern unsigned int ata_sff_host_intr(struct ata_port *ap,
 				      struct ata_queued_cmd *qc);
 extern irqreturn_t ata_sff_interrupt(int irq, void *dev_instance);
+extern void ata_sff_lost_interrupt(struct ata_port *ap);
 extern void ata_sff_freeze(struct ata_port *ap);
 extern void ata_sff_thaw(struct ata_port *ap);
 extern int ata_sff_prereset(struct ata_link *link, unsigned long deadline);
@@ -1528,6 +1532,7 @@ extern int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 extern int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
 			       unsigned long deadline);
 extern void ata_sff_postreset(struct ata_link *link, unsigned int *classes);
+extern void ata_sff_drain_fifo(struct ata_queued_cmd *qc);
 extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_post_internal_cmd(struct ata_queued_cmd *qc);
 extern int ata_sff_port_start(struct ata_port *ap);

