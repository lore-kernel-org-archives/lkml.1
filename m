Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXF0Hfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXF0Hfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 03:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbXF0Hfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 03:35:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50150 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760601AbXF0Hf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 03:35:27 -0400
Date: Wed, 27 Jun 2007 03:35:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070627073526.GA18787@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   56 +++++++++++++++-----------------------------
 drivers/ata/libata-eh.c   |    7 +----
 drivers/ata/libata-scsi.c |   20 ++++++---------
 drivers/ata/pata_hpt37x.c |    4 +-
 drivers/ata/pata_it821x.c |    2 +-
 include/linux/libata.h    |    9 ++-----
 6 files changed, 35 insertions(+), 63 deletions(-)

Alan Cox (1):
      HPT374 is UDMA100 not UDMA133

Randy Dunlap (1):
      pata_it821x: fix section mismatch warning

Tejun Heo (9):
      libata: kill the infamous abnormal status message
      libata: kill non-sense warning message
      libata: be less verbose about hpa
      libata: remove unused variable from ata_eh_reset()
      libata: fix ata_dev_disable()
      libata: fix infinite EH waiting bug
      libata: call ata_check_atapi_dma() with qc better prepared
      libata: use PIO for non-16 byte aligned ATAPI commands
      libata: kill ATA_HORKAGE_DMA_RW_ONLY

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index adfae9d..bfc59a1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -600,8 +600,9 @@ static const char *sata_spd_string(unsigned int spd)
 
 void ata_dev_disable(struct ata_device *dev)
 {
-	if (ata_dev_enabled(dev) && ata_msg_drv(dev->ap)) {
-		ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+	if (ata_dev_enabled(dev)) {
+		if (ata_msg_drv(dev->ap))
+			ata_dev_printk(dev, KERN_WARNING, "disabled\n");
 		ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 |
 					     ATA_DNXFER_QUIET);
 		dev->class++;
@@ -983,11 +984,6 @@ static u64 ata_hpa_resize(struct ata_device *dev)
 	else
 		hpa_sectors = ata_read_native_max_address(dev);
 
-	/* if no hpa, both should be equal */
-	ata_dev_printk(dev, KERN_INFO, "%s 1: sectors = %lld, "
-				"hpa_sectors = %lld\n",
-		__FUNCTION__, (long long)sectors, (long long)hpa_sectors);
-
 	if (hpa_sectors > sectors) {
 		ata_dev_printk(dev, KERN_INFO,
 			"Host Protected Area detected:\n"
@@ -1009,7 +1005,11 @@ static u64 ata_hpa_resize(struct ata_device *dev)
 				return hpa_sectors;
 			}
 		}
-	}
+	} else if (hpa_sectors < sectors)
+		ata_dev_printk(dev, KERN_WARNING, "%s 1: hpa sectors (%lld) "
+			       "is smaller than sectors (%lld)\n", __FUNCTION__,
+			       (long long)hpa_sectors, (long long)sectors);
+
 	return sectors;
 }
 
@@ -2046,10 +2046,6 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
-	/* limit ATAPI DMA to R/W commands only */
-	if (ata_device_blacklisted(dev) & ATA_HORKAGE_DMA_RW_ONLY)
-		dev->horkage |= ATA_HORKAGE_DMA_RW_ONLY;
-
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -3780,8 +3776,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "IOMEGA  ZIP 250       ATAPI", NULL,	ATA_HORKAGE_NODMA }, /* temporary fix */
 
 	/* Weird ATAPI devices */
-	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
-						ATA_HORKAGE_DMA_RW_ONLY },
+	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 
 	/* Devices we expect to fail diagnostics */
 
@@ -4109,6 +4104,7 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 	if (idx)
 		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
+
 /**
  *	ata_check_atapi_dma - Check whether ATAPI DMA can be supported
  *	@qc: Metadata associated with taskfile to check
@@ -4126,33 +4122,19 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 int ata_check_atapi_dma(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	int rc = 0; /* Assume ATAPI DMA is OK by default */
-
-	/* some drives can only do ATAPI DMA on read/write */
-	if (unlikely(qc->dev->horkage & ATA_HORKAGE_DMA_RW_ONLY)) {
-		struct scsi_cmnd *cmd = qc->scsicmd;
-		u8 *scsicmd = cmd->cmnd;
-
-		switch (scsicmd[0]) {
-		case READ_10:
-		case WRITE_10:
-		case READ_12:
-		case WRITE_12:
-		case READ_6:
-		case WRITE_6:
-			/* atapi dma maybe ok */
-			break;
-		default:
-			/* turn off atapi dma */
-			return 1;
-		}
-	}
+
+	/* Don't allow DMA if it isn't multiple of 16 bytes.  Quite a
+	 * few ATAPI devices choke on such DMA requests.
+	 */
+	if (unlikely(qc->nbytes & 15))
+		return 1;
 
 	if (ap->ops->check_atapi_dma)
-		rc = ap->ops->check_atapi_dma(qc);
+		return ap->ops->check_atapi_dma(qc);
 
-	return rc;
+	return 0;
 }
+
 /**
  *	ata_qc_prep - Prepare taskfile for submission
  *	@qc: Metadata associated with taskfile to be prepared
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index d807098..f7582c9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -336,6 +336,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 			}
 			ata_port_printk(ap, KERN_ERR, "EH pending after %d "
 					"tries, giving up\n", ATA_EH_MAX_REPEAT);
+			ap->pflags &= ~ATA_PFLAG_EH_PENDING;
 		}
 
 		/* this run is complete, make sure EH info is clear */
@@ -1616,7 +1617,7 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 	unsigned long deadline;
 	unsigned int action;
 	ata_reset_fn_t reset;
-	int i, did_followup_srst, rc;
+	int i, rc;
 
 	/* about to reset */
 	ata_eh_about_to_do(ap, NULL, ehc->i.action & ATA_EH_RESET_MASK);
@@ -1665,8 +1666,6 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 
 	/* did prereset() screw up?  if so, fix up to avoid oopsing */
 	if (!reset) {
-		ata_port_printk(ap, KERN_ERR, "BUG: prereset() requested "
-				"invalid reset type\n");
 		if (softreset)
 			reset = softreset;
 		else
@@ -1689,11 +1688,9 @@ static int ata_eh_reset(struct ata_port *ap, int classify,
 
 	rc = ata_do_reset(ap, reset, classes, deadline);
 
-	did_followup_srst = 0;
 	if (reset == hardreset &&
 	    ata_eh_followup_srst_needed(rc, classify, classes)) {
 		/* okay, let's do follow-up softreset */
-		did_followup_srst = 1;
 		reset = softreset;
 
 		if (!reset) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c228df2..4ddf00c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2384,11 +2384,6 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
 	int nodata = (scmd->sc_data_direction == DMA_NONE);
 
-	if (!using_pio)
-		/* Check whether ATAPI DMA is safe */
-		if (ata_check_atapi_dma(qc))
-			using_pio = 1;
-
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
 
@@ -2401,19 +2396,22 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	}
 
 	qc->tf.command = ATA_CMD_PACKET;
+	qc->nbytes = scmd->request_bufflen;
+
+	/* check whether ATAPI DMA is safe */
+	if (!using_pio && ata_check_atapi_dma(qc))
+		using_pio = 1;
 
-	/* no data, or PIO data xfer */
 	if (using_pio || nodata) {
+		/* no data, or PIO data xfer */
 		if (nodata)
 			qc->tf.protocol = ATA_PROT_ATAPI_NODATA;
 		else
 			qc->tf.protocol = ATA_PROT_ATAPI;
 		qc->tf.lbam = (8 * 1024) & 0xff;
 		qc->tf.lbah = (8 * 1024) >> 8;
-	}
-
-	/* DMA data xfer */
-	else {
+	} else {
+		/* DMA data xfer */
 		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
 
@@ -2422,8 +2420,6 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 			qc->tf.feature |= ATAPI_DMADIR;
 	}
 
-	qc->nbytes = scmd->request_bufflen;
-
 	return 0;
 }
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 6446735..a8c0cbe 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -931,13 +931,13 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,
 		.port_ops = &hpt372_port_ops
 	};
-	/* HPT374 - UDMA133 */
+	/* HPT374 - UDMA100 */
 	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
-		.udma_mask = 0x7f,
+		.udma_mask = 0x3f,
 		.port_ops = &hpt374_port_ops
 	};
 
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index dab4e7c..12c6e08 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -690,7 +690,7 @@ static struct ata_port_operations it821x_passthru_port_ops = {
 	.port_start	= it821x_port_start,
 };
 
-static void __devinit it821x_disable_raid(struct pci_dev *pdev)
+static void it821x_disable_raid(struct pci_dev *pdev)
 {
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(pdev, 0x5E, 0x01);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 745c4f9..620da7b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -298,7 +298,6 @@ enum {
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
 	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
-	ATA_HORKAGE_DMA_RW_ONLY	= (1 << 4),	/* ATAPI DMA for RW only */
 };
 
 enum hsm_task_states {
@@ -1088,11 +1087,9 @@ static inline u8 ata_wait_idle(struct ata_port *ap)
 {
 	u8 status = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
 
-	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ))) {
-		if (ata_msg_warn(ap))
-			printk(KERN_WARNING "ATA: abnormal status 0x%X on port 0x%p\n",
-				status, ap->ioaddr.status_addr);
-	}
+	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ)))
+		DPRINTK("ATA: abnormal status 0x%X on port 0x%p\n",
+			status, ap->ioaddr.status_addr);
 
 	return status;
 }
