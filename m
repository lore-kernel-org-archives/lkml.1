Return-Path: <linux-kernel-owner+w=401wt.eu-S1751959AbXKJJYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbXKJJYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 04:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbXKJJYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 04:24:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:41104 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbXKJJYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 04:24:33 -0500
Date: Sat, 10 Nov 2007 04:24:31 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071110092431.GA27174@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c      |    7 +++
 drivers/ata/libata-acpi.c   |   10 +---
 drivers/ata/libata-core.c   |   78 ++++++++++++++++++++++-------
 drivers/ata/pata_platform.c |   35 +++++++++++---
 drivers/ata/sata_nv.c       |    2 +-
 drivers/ata/sata_qstor.c    |  114 ++++++++++++++++++++++++++++---------------
 6 files changed, 172 insertions(+), 74 deletions(-)

Fernando Luis Vázquez Cao (1):
      nv_hardreset: update dangling reference to bugzilla entry

Mark Lord (3):
      libata sata_qstor nuke idle state
      libata sata_qstor workaround for spurious interrupts
      libata sata_qstor conversion to new error handling (EH).

Matthew Garrett (1):
      libata: Don't fail device revalidation for bad _GTF methods

Paul Mundt (2):
      libata: Support PIO polling-only hosts.
      libata: pata_platform: Support polling-mode configuration.

Tejun Heo (2):
      libata: skip 0xff polling for PATA controllers
      libata: port and host should be stopped before hardware resources are released

Yann Chachkoff (1):
      ata_piix: add SATELLITE PRO U200 to broken suspend list

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index f08cca2..328ce8a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -960,6 +960,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "Satellite Pro U200",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE PRO U200"),
+			},
+		},
+		{
 			.ident = "Satellite U205",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 08a52dd..545ea86 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -312,7 +312,7 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  *
  * RETURNS:
  * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.  -errno on other errors.
+ * contain valid data.
  */
 static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			   void **ptr_to_free)
@@ -339,7 +339,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
-			rc = -EIO;
 		}
 		goto out_free;
 	}
@@ -359,7 +358,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -367,7 +365,6 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
-		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -511,10 +508,7 @@ static int ata_acpi_exec_tfs(struct ata_device *dev)
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
-	if (rc < 0)
-		return rc;
-	gtf_count = rc;
+	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
 
 	/* execute them */
 	for (i = 0, rc = 0; i < gtf_count; i++) {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ec3ce12..8189803 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3373,14 +3373,20 @@ void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline)
 	 * to clear 0xff after reset.  For example, HHD424020F7SV00
 	 * iVDR needs >= 800ms while.  Quantum GoVault needs even more
 	 * than that.
+	 *
+	 * Note that some PATA controllers (pata_ali) explode if
+	 * status register is read more than once when there's no
+	 * device attached.
 	 */
-	while (1) {
-		u8 status = ata_chk_status(ap);
+	if (ap->flags & ATA_FLAG_SATA) {
+		while (1) {
+			u8 status = ata_chk_status(ap);
 
-		if (status != 0xff || time_after(jiffies, deadline))
-			return;
+			if (status != 0xff || time_after(jiffies, deadline))
+				return;
 
-		msleep(50);
+			msleep(50);
+		}
 	}
 }
 
@@ -6821,19 +6827,6 @@ static void ata_host_release(struct device *gendev, void *res)
 		if (!ap)
 			continue;
 
-		if ((host->flags & ATA_HOST_STARTED) && ap->ops->port_stop)
-			ap->ops->port_stop(ap);
-	}
-
-	if ((host->flags & ATA_HOST_STARTED) && host->ops->host_stop)
-		host->ops->host_stop(host);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!ap)
-			continue;
-
 		if (ap->scsi_host)
 			scsi_host_put(ap->scsi_host);
 
@@ -6960,6 +6953,24 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	return host;
 }
 
+static void ata_host_stop(struct device *gendev, void *res)
+{
+	struct ata_host *host = dev_get_drvdata(gendev);
+	int i;
+
+	WARN_ON(!(host->flags & ATA_HOST_STARTED));
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap->ops->port_stop)
+			ap->ops->port_stop(ap);
+	}
+
+	if (host->ops->host_stop)
+		host->ops->host_stop(host);
+}
+
 /**
  *	ata_host_start - start and freeze ports of an ATA host
  *	@host: ATA host to start ports for
@@ -6978,6 +6989,8 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
  */
 int ata_host_start(struct ata_host *host)
 {
+	int have_stop = 0;
+	void *start_dr = NULL;
 	int i, rc;
 
 	if (host->flags & ATA_HOST_STARTED)
@@ -6989,6 +7002,22 @@ int ata_host_start(struct ata_host *host)
 		if (!host->ops && !ata_port_is_dummy(ap))
 			host->ops = ap->ops;
 
+		if (ap->ops->port_stop)
+			have_stop = 1;
+	}
+
+	if (host->ops->host_stop)
+		have_stop = 1;
+
+	if (have_stop) {
+		start_dr = devres_alloc(ata_host_stop, 0, GFP_KERNEL);
+		if (!start_dr)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
 		if (ap->ops->port_start) {
 			rc = ap->ops->port_start(ap);
 			if (rc) {
@@ -7001,6 +7030,8 @@ int ata_host_start(struct ata_host *host)
 		ata_eh_freeze_port(ap);
 	}
 
+	if (start_dr)
+		devres_add(host->dev, start_dr);
 	host->flags |= ATA_HOST_STARTED;
 	return 0;
 
@@ -7011,6 +7042,7 @@ int ata_host_start(struct ata_host *host)
 		if (ap->ops->port_stop)
 			ap->ops->port_stop(ap);
 	}
+	devres_free(start_dr);
 	return rc;
 }
 
@@ -7178,6 +7210,10 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
  *	request IRQ and register it.  This helper takes necessasry
  *	arguments and performs the three steps in one go.
  *
+ *	An invalid IRQ skips the IRQ registration and expects the host to
+ *	have set polling mode on the port. In this case, @irq_handler
+ *	should be NULL.
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
@@ -7194,6 +7230,12 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		return rc;
 
+	/* Special case for polling mode */
+	if (!irq) {
+		WARN_ON(irq_handler);
+		return ata_host_register(host, sht);
+	}
+
 	rc = devm_request_irq(host->dev, irq, irq_handler, irq_flags,
 			      dev_driver_string(host->dev), host);
 	if (rc)
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index fc72a96..ac03a90 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -1,7 +1,7 @@
 /*
  * Generic platform device PATA driver
  *
- * Copyright (C) 2006  Paul Mundt
+ * Copyright (C) 2006 - 2007  Paul Mundt
  *
  * Based on pata_pcmcia:
  *
@@ -22,7 +22,7 @@
 #include <linux/pata_platform.h>
 
 #define DRV_NAME "pata_platform"
-#define DRV_VERSION "1.1"
+#define DRV_VERSION "1.2"
 
 static int pio_mask = 1;
 
@@ -120,15 +120,20 @@ static void pata_platform_setup_port(struct ata_ioports *ioaddr,
  *	Register a platform bus IDE interface. Such interfaces are PIO and we
  *	assume do not support IRQ sharing.
  *
- *	Platform devices are expected to contain 3 resources per port:
+ *	Platform devices are expected to contain at least 2 resources per port:
  *
  *		- I/O Base (IORESOURCE_IO or IORESOURCE_MEM)
  *		- CTL Base (IORESOURCE_IO or IORESOURCE_MEM)
+ *
+ *	and optionally:
+ *
  *		- IRQ	   (IORESOURCE_IRQ)
  *
  *	If the base resources are both mem types, the ioremap() is handled
  *	here. For IORESOURCE_IO, it's assumed that there's no remapping
  *	necessary.
+ *
+ *	If no IRQ resource is present, PIO polling mode is used instead.
  */
 static int __devinit pata_platform_probe(struct platform_device *pdev)
 {
@@ -137,11 +142,12 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	struct ata_port *ap;
 	struct pata_platform_info *pp_info;
 	unsigned int mmio;
+	int irq;
 
 	/*
 	 * Simple resource validation ..
 	 */
-	if (unlikely(pdev->num_resources != 3)) {
+	if ((pdev->num_resources != 3) && (pdev->num_resources != 2)) {
 		dev_err(&pdev->dev, "invalid number of resources\n");
 		return -EINVAL;
 	}
@@ -173,6 +179,13 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 		(ctl_res->flags == IORESOURCE_MEM));
 
 	/*
+	 * And the IRQ
+	 */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		irq = 0;	/* no irq */
+
+	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
 	host = ata_host_alloc(&pdev->dev, 1);
@@ -185,6 +198,14 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 	ap->flags |= ATA_FLAG_SLAVE_POSS;
 
 	/*
+	 * Use polling mode if there's no IRQ
+	 */
+	if (!irq) {
+		ap->flags |= ATA_FLAG_PIO_POLLING;
+		ata_port_desc(ap, "no IRQ, using PIO polling");
+	}
+
+	/*
 	 * Handle the MMIO case
 	 */
 	if (mmio) {
@@ -213,9 +234,9 @@ static int __devinit pata_platform_probe(struct platform_device *pdev)
 		      (unsigned long long)ctl_res->start);
 
 	/* activate */
-	return ata_host_activate(host, platform_get_irq(pdev, 0),
-				 ata_interrupt, pp_info ? pp_info->irq_flags
-				 : 0, &pata_platform_sht);
+	return ata_host_activate(host, irq, irq ? ata_interrupt : NULL,
+				 pp_info ? pp_info->irq_flags : 0,
+				 &pata_platform_sht);
 }
 
 /**
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 35b2df2..44f9e5d 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1629,7 +1629,7 @@ static int nv_hardreset(struct ata_link *link, unsigned int *class,
 
 	/* SATA hardreset fails to retrieve proper device signature on
 	 * some controllers.  Don't classify on hardreset.  For more
-	 * info, see http://bugme.osdl.org/show_bug.cgi?id=3352
+	 * info, see http://bugzilla.kernel.org/show_bug.cgi?id=3352
 	 */
 	return sata_std_hardreset(link, &dummy, deadline);
 }
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 6d43ba7..2f1de6e 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -103,7 +103,7 @@ enum {
 	QS_DMA_BOUNDARY		= ~0UL
 };
 
-typedef enum { qs_state_idle, qs_state_pkt, qs_state_mmio } qs_state_t;
+typedef enum { qs_state_mmio, qs_state_pkt } qs_state_t;
 
 struct qs_port_priv {
 	u8			*pkt;
@@ -116,14 +116,15 @@ static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 static int qs_ata_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
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
@@ -150,11 +151,12 @@ static const struct ata_port_operations qs_ata_ops = {
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
 	.scr_read		= qs_scr_read,
@@ -169,8 +171,6 @@ static const struct ata_port_info qs_port_info[] = {
 	/* board_2068_idx */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_SATA_RESET |
-				  //FIXME ATA_FLAG_SRST |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= 0x10, /* pio4 */
 		.udma_mask	= ATA_UDMA6,
@@ -219,7 +219,9 @@ static void qs_irq_clear(struct ata_port *ap)
 static inline void qs_enter_reg_mode(struct ata_port *ap)
 {
 	u8 __iomem *chan = qs_mmio_base(ap->host) + (ap->port_no * 0x4000);
+	struct qs_port_priv *pp = ap->private_data;
 
+	pp->state = qs_state_mmio;
 	writeb(QS_CTR0_REG, chan + QS_CCT_CTR0);
 	readb(chan + QS_CCT_CTR0);        /* flush */
 }
@@ -233,23 +235,28 @@ static inline void qs_reset_channel_logic(struct ata_port *ap)
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
+	qs_enter_reg_mode(ap);
 }
 
-static void qs_eng_timeout(struct ata_port *ap)
+static void qs_thaw(struct ata_port *ap)
 {
-	struct qs_port_priv *pp = ap->private_data;
+	u8 __iomem *mmio_base = qs_mmio_base(ap->host);
+
+	qs_enter_reg_mode(ap);
+	writeb(1, mmio_base + QS_HCT_CTRL); /* enable host interrupts */
+}
+
+static int qs_prereset(struct ata_link *link, unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
 
-	if (pp->state != qs_state_idle) /* healthy paranoia */
-		pp->state = qs_state_mmio;
 	qs_reset_channel_logic(ap);
-	ata_eng_timeout(ap);
+	return ata_std_prereset(link, deadline);
 }
 
 static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
@@ -260,6 +267,13 @@ static int qs_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val)
 	return 0;
 }
 
+static void qs_error_handler(struct ata_port *ap)
+{
+	qs_enter_reg_mode(ap);
+	ata_do_eh(ap, qs_prereset, ata_std_softreset, NULL,
+		  ata_std_postreset);
+}
+
 static int qs_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val)
 {
 	if (sc_reg > SCR_CONTROL)
@@ -358,7 +372,6 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-
 		pp->state = qs_state_pkt;
 		qs_packet_start(qc);
 		return 0;
@@ -375,6 +388,26 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 	return ata_qc_issue_prot(qc);
 }
 
+static void qs_do_or_die(struct ata_queued_cmd *qc, u8 status)
+{
+	qc->err_mask |= ac_err_mask(status);
+
+	if (!qc->err_mask) {
+		ata_qc_complete(qc);
+	} else {
+		struct ata_port    *ap  = qc->ap;
+		struct ata_eh_info *ehi = &ap->link.eh_info;
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
@@ -406,10 +439,8 @@ static inline unsigned int qs_intr_pkt(struct ata_host *host)
 					switch (sHST) {
 					case 0: /* successful CPB */
 					case 3: /* device error */
-						pp->state = qs_state_idle;
 						qs_enter_reg_mode(qc->ap);
-						qc->err_mask |= ac_err_mask(sDST);
-						ata_qc_complete(qc);
+						qs_do_or_die(qc, sDST);
 						break;
 					default:
 						break;
@@ -431,25 +462,27 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 		if (ap &&
 		    !(ap->flags & ATA_FLAG_DISABLED)) {
 			struct ata_queued_cmd *qc;
-			struct qs_port_priv *pp = ap->private_data;
-			if (!pp || pp->state != qs_state_mmio)
-				continue;
+			struct qs_port_priv *pp;
 			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-
-				/* check main status, clearing INTRQ */
-				u8 status = ata_check_status(ap);
-				if ((status & ATA_BUSY))
-					continue;
-				DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
-					ap->print_id, qc->tf.protocol, status);
-
-				/* complete taskfile transaction */
-				pp->state = qs_state_idle;
-				qc->err_mask |= ac_err_mask(status);
-				ata_qc_complete(qc);
+			if (!qc || !(qc->flags & ATA_QCFLAG_ACTIVE)) {
+				/*
+				 * The qstor hardware generates spurious
+				 * interrupts from time to time when switching
+				 * in and out of packet mode.
+				 * There's no obvious way to know if we're
+				 * here now due to that, so just ack the irq
+				 * and pretend we knew it was ours.. (ugh).
+				 * This does not affect packet mode.
+				 */
+				ata_check_status(ap);
 				handled = 1;
+				continue;
 			}
+			pp = ap->private_data;
+			if (!pp || pp->state != qs_state_mmio)
+				continue;
+			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
+				handled |= ata_host_intr(ap, qc);
 		}
 	}
 	return handled;
@@ -459,12 +492,13 @@ static irqreturn_t qs_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int handled = 0;
+	unsigned long flags;
 
 	VPRINTK("ENTER\n");
 
-	spin_lock(&host->lock);
+	spin_lock_irqsave(&host->lock, flags);
 	handled  = qs_intr_pkt(host) | qs_intr_mmio(host);
-	spin_unlock(&host->lock);
+	spin_unlock_irqrestore(&host->lock, flags);
 
 	VPRINTK("EXIT\n");
 
@@ -501,7 +535,6 @@ static int qs_port_start(struct ata_port *ap)
 	rc = ata_port_start(ap);
 	if (rc)
 		return rc;
-	qs_enter_reg_mode(ap);
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
@@ -512,6 +545,7 @@ static int qs_port_start(struct ata_port *ap)
 	memset(pp->pkt, 0, QS_PKT_BYTES);
 	ap->private_data = pp;
 
+	qs_enter_reg_mode(ap);
 	addr = (u64)pp->pkt_dma;
 	writel((u32) addr,        chan + QS_CCF_CPBA);
 	writel((u32)(addr >> 32), chan + QS_CCF_CPBA + 4);
