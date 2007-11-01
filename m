Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbXKAJHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbXKAJHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXKAJHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:07:36 -0400
Received: from havoc.gtf.org ([69.61.125.42]:60138 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbXKAJHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:07:35 -0400
Date: Thu, 1 Nov 2007 05:07:33 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata ATAPI transfer size cleanups
Message-ID: <20071101090733.GA9258@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is purely for comment and testing, not for merging (yet?).

A common recipe in several vendor drivers (either GPL'd, or I have NDA'd
access to use them as a documentation-like reference) for ATAPI was
slightly different from ours.  This recipe can be found in
atapi_tf_xfer_size(), and it's slightly different from Alan's.

This patch also adds some byte count checks, consolidated
ata_pio_use_silly() use, and adds a dmadir-related FIXME.

The 'xfer-size' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git xfer-size

to receive the following updates:

 drivers/ata/libata-core.c |   53 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata-eh.c   |   11 +--------
 drivers/ata/libata-scsi.c |   48 +++++++++-------------------------------
 drivers/ata/libata.h      |    7 ++++++
 4 files changed, 72 insertions(+), 47 deletions(-)

Jeff Garzik (1):
      [libata] Standardize ATAPI byte count [limit] handling

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 63035d7..5c616a8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5258,6 +5258,55 @@ next_sg:
 		goto next_sg;
 }
 
+void atapi_tf_xfer_size(struct ata_taskfile *tf,
+			unsigned int total_xfer_len,
+			bool dma)
+{
+	if (dma) {
+		tf->protocol = ATA_PROT_ATAPI_DMA;
+		tf->feature |= ATAPI_PKT_DMA;
+		tf->lbam = 0;
+		tf->lbah = 0;
+	} else {
+		tf->protocol = ATA_PROT_ATAPI;
+		tf->feature &= ~ATAPI_PKT_DMA;
+		if (total_xfer_len <= 0xffff) {
+			tf->lbam = total_xfer_len;
+			tf->lbah = total_xfer_len >> 8;
+		} else {
+			tf->lbam = 0xff;
+			tf->lbah = 0xff;
+		}
+	}
+}
+
+static bool atapi_valid_bcount(const struct ata_taskfile *tf,
+			       const struct ata_taskfile *result_tf)
+{
+	unsigned int ibyte, obyte, lo, hi;
+
+	lo = tf->lbam;
+	hi = tf->lbam;
+	ibyte = (hi << 8) | lo;
+
+	lo = result_tf->lbam;
+	hi = result_tf->lbam;
+	obyte = (hi << 8) | lo;
+
+	if (unlikely(obyte > ibyte))
+		return false;
+	if (unlikely(obyte == 0))
+		return false;
+	if (unlikely(obyte > 0xfffe))
+		return false;
+
+	/* another test, omitted due to lack of data point:
+	 * obyte should be even, if it is not the last DRQ block
+	 */
+
+	return true;
+}
+
 /**
  *	atapi_pio_bytes - Transfer data from/to the ATAPI device.
  *	@qc: Command on going
@@ -5282,6 +5331,10 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 	 * So, the correctness of qc->result_tf is not affected.
 	 */
 	ap->ops->tf_read(ap, &qc->result_tf);
+
+	if (!atapi_valid_bcount(&qc->tf, &qc->result_tf))
+		goto err_out;
+
 	ireason = qc->result_tf.nsect;
 	bc_lo = qc->result_tf.lbam;
 	bc_hi = qc->result_tf.lbah;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8d64f8f..505b2e9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1352,16 +1352,7 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
-
-	/* is it pointless to prefer PIO for "safety reasons"? */
-	if (ap->flags & ATA_FLAG_PIO_DMA) {
-		tf.protocol = ATA_PROT_ATAPI_DMA;
-		tf.feature |= ATAPI_PKT_DMA;
-	} else {
-		tf.protocol = ATA_PROT_ATAPI;
-		tf.lbam = (8 * 1024) & 0xff;
-		tf.lbah = (8 * 1024) >> 8;
-	}
+	atapi_tf_xfer_size(&tf, SCSI_SENSE_BUFFERSIZE, ata_pio_use_silly(ap));
 
 	return ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
 				 sense_buf, SCSI_SENSE_BUFFERSIZE, 0);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fc89590..bec28c2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2313,12 +2313,6 @@ static void atapi_sense_complete(struct ata_queued_cmd *qc)
 	ata_qc_free(qc);
 }
 
-/* is it pointless to prefer PIO for "safety reasons"? */
-static inline int ata_pio_use_silly(struct ata_port *ap)
-{
-	return (ap->flags & ATA_FLAG_PIO_DMA);
-}
-
 static void atapi_request_sense(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
@@ -2346,15 +2340,9 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	qc->tf.command = ATA_CMD_PACKET;
+	atapi_tf_xfer_size(&qc->tf, SCSI_SENSE_BUFFERSIZE,
+			   ata_pio_use_silly(ap));
 
-	if (ata_pio_use_silly(ap)) {
-		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
-		qc->tf.feature |= ATAPI_PKT_DMA;
-	} else {
-		qc->tf.protocol = ATA_PROT_ATAPI;
-		qc->tf.lbam = SCSI_SENSE_BUFFERSIZE;
-		qc->tf.lbah = 0;
-	}
 	qc->nbytes = SCSI_SENSE_BUFFERSIZE;
 
 	qc->complete_fn = atapi_sense_complete;
@@ -2462,7 +2450,6 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	struct ata_device *dev = qc->dev;
 	int using_pio = (dev->flags & ATA_DFLAG_PIO);
 	int nodata = (scmd->sc_data_direction == DMA_NONE);
-	unsigned int nbytes;
 
 	memset(qc->cdb, 0, dev->cdb_len);
 	memcpy(qc->cdb, scmd->cmnd, scmd->cmd_len);
@@ -2482,31 +2469,18 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	if (!using_pio && ata_check_atapi_dma(qc))
 		using_pio = 1;
 
-	/* Some controller variants snoop this value for Packet transfers
-	   to do state machine and FIFO management. Thus we want to set it
-	   properly, and for DMA where it is effectively meaningless */
-	nbytes = min(qc->nbytes, (unsigned int)63 * 1024);
-
-	qc->tf.lbam = (nbytes & 0xFF);
-	qc->tf.lbah = (nbytes >> 8);
-
-	if (using_pio || nodata) {
-		/* no data, or PIO data xfer */
-		if (nodata)
-			qc->tf.protocol = ATA_PROT_ATAPI_NODATA;
-		else
-			qc->tf.protocol = ATA_PROT_ATAPI;
-	} else {
-		/* DMA data xfer */
-		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
-		qc->tf.feature |= ATAPI_PKT_DMA;
+	if (nodata)
+		qc->tf.protocol = ATA_PROT_ATAPI_NODATA;
+	else
+		atapi_tf_xfer_size(&qc->tf, qc->nbytes, !using_pio);
 
-		if (atapi_dmadir && (scmd->sc_data_direction != DMA_TO_DEVICE))
-			/* some SATA bridges need us to indicate data xfer direction */
-			qc->tf.feature |= ATAPI_DMADIR;
+	/* FIXME: also check dmadir capability bit added in ATA-7 */
+	if (atapi_dmadir && (qc->tf.protocol == ATA_PROT_ATAPI_DMA) &&
+	    (scmd->sc_data_direction != DMA_TO_DEVICE)) {
+		/* some SATA bridges need us to indicate data xfer direction */
+		qc->tf.feature |= ATAPI_DMADIR;
 	}
 
-
 	/* FIXME: We need to translate 0x05 READ_BLOCK_LIMITS to a MODE_SENSE
 	   as ATAPI tape drives don't get this right otherwise */
 	return 0;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0e6cf3a..f62029a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -103,6 +103,8 @@ extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
 extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
+extern void atapi_tf_xfer_size(struct ata_taskfile *tf,
+				unsigned int total_xfer_len, bool dma);
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
@@ -188,5 +190,10 @@ extern void ata_eh_finish(struct ata_port *ap);
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
+/* is it pointless to prefer PIO for "safety reasons"? */
+static inline int ata_pio_use_silly(struct ata_port *ap)
+{
+	return (ap->flags & ATA_FLAG_PIO_DMA);
+}
 
 #endif /* __LIBATA_H__ */
