Return-Path: <linux-kernel-owner+w=401wt.eu-S2992697AbXDDGjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992697AbXDDGjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXDDGjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:39:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37622 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXDDGjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:39:53 -0400
Date: Wed, 4 Apr 2007 02:39:52 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070404063952.GA23791@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   33 ++++++++++++++++++++++++++++++++-
 drivers/ata/libata-eh.c   |   22 +++++++++++-----------
 drivers/ata/libata-scsi.c |    2 +-
 include/linux/ata.h       |    1 +
 include/linux/libata.h    |    6 ++++--
 5 files changed, 49 insertions(+), 15 deletions(-)

Albert Lee (4):
      libata: reorder HSM_ST_FIRST for easier decoding (take 3)
      libata: Clear tf before doing request sense (take 3)
      libata: Limit max sector to 128 for TORiSAN DVD drives (take 3)
      libata: Limit ATAPI DMA to R/W commands only for TORiSAN DVD drives (take 3)

Mark Lord (2):
      2.6.21 fix lba48 bug in libata fill_result_tf()
      libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ddb3909..cf2338c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1784,6 +1784,13 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
 
+	if (ata_device_blacklisted(dev) & ATA_HORKAGE_MAX_SEC_128)
+		dev->max_sectors = min(ATA_MAX_SECTORS_128, dev->max_sectors);
+
+	/* limit ATAPI DMA to R/W commands only */
+	if (ata_device_blacklisted(dev) & ATA_HORKAGE_DMA_RW_ONLY)
+		dev->horkage |= ATA_HORKAGE_DMA_RW_ONLY;
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(ap, dev);
 
@@ -3352,6 +3359,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
 
+	/* Weird ATAPI devices */
+	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
+						ATA_HORKAGE_DMA_RW_ONLY },
+
 	/* Devices we expect to fail diagnostics */
 
 	/* Devices where NCQ should be avoided */
@@ -3674,6 +3685,26 @@ int ata_check_atapi_dma(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	int rc = 0; /* Assume ATAPI DMA is OK by default */
 
+	/* some drives can only do ATAPI DMA on read/write */
+	if (unlikely(qc->dev->horkage & ATA_HORKAGE_DMA_RW_ONLY)) {
+		struct scsi_cmnd *cmd = qc->scsicmd;
+		u8 *scsicmd = cmd->cmnd;
+
+		switch (scsicmd[0]) {
+		case READ_10:
+		case WRITE_10:
+		case READ_12:
+		case WRITE_12:
+		case READ_6:
+		case WRITE_6:
+			/* atapi dma maybe ok */
+			break;
+		default:
+			/* turn off atapi dma */
+			return 1;
+		}
+	}
+
 	if (ap->ops->check_atapi_dma)
 		rc = ap->ops->check_atapi_dma(qc);
 
@@ -4717,8 +4748,8 @@ static void fill_result_tf(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
-	ap->ops->tf_read(ap, &qc->result_tf);
 	qc->result_tf.flags = qc->tf.flags;
+	ap->ops->tf_read(ap, &qc->result_tf);
 }
 
 /**
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c89664a..39f556c 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -982,26 +982,27 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-static unsigned int atapi_eh_request_sense(struct ata_device *dev,
-					   unsigned char *sense_buf)
+static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 {
+	struct ata_device *dev = qc->dev;
+	unsigned char *sense_buf = qc->scsicmd->sense_buffer;
 	struct ata_port *ap = dev->ap;
 	struct ata_taskfile tf;
 	u8 cdb[ATAPI_CDB_LEN];
 
 	DPRINTK("ATAPI request sense\n");
 
-	ata_tf_init(dev, &tf);
-
 	/* FIXME: is this needed? */
 	memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);
 
-	/* XXX: why tf_read here? */
-	ap->ops->tf_read(ap, &tf);
-
-	/* fill these in, for the case where they are -not- overwritten */
+	/* initialize sense_buf with the error register,
+	 * for the case where they are -not- overwritten
+	 */
 	sense_buf[0] = 0x70;
-	sense_buf[2] = tf.feature >> 4;
+	sense_buf[2] = qc->result_tf.feature >> 4;
+
+	/* some devices time out if garbage left in tf */ 
+	ata_tf_init(dev, &tf);
 
 	memset(cdb, 0, ATAPI_CDB_LEN);
 	cdb[0] = REQUEST_SENSE;
@@ -1165,8 +1166,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 
 	case ATA_DEV_ATAPI:
 		if (!(qc->ap->pflags & ATA_PFLAG_FROZEN)) {
-			tmp = atapi_eh_request_sense(qc->dev,
-						     qc->scsicmd->sense_buffer);
+			tmp = atapi_eh_request_sense(qc);
 			if (!tmp) {
 				/* ATA_QCFLAG_SENSE_VALID is used to
 				 * tell atapi_qc_complete() that sense
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6cc817a..e936443 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -333,7 +333,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	scsi_cmd[8]  = args[3];
 	scsi_cmd[10] = args[4];
 	scsi_cmd[12] = args[5];
-	scsi_cmd[13] = args[6] & 0x0f;
+	scsi_cmd[13] = args[6] & 0x4f;
 	scsi_cmd[14] = args[0];
 
 	/* Good values for timeout and retries?  Values below
diff --git a/include/linux/ata.h b/include/linux/ata.h
index c331da2..6caeb98 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -40,6 +40,7 @@ enum {
 	ATA_MAX_DEVICES		= 2,	/* per bus/port */
 	ATA_MAX_PRD		= 256,	/* we could make these 256/256 */
 	ATA_SECT_SIZE		= 512,
+	ATA_MAX_SECTORS_128	= 128,
 	ATA_MAX_SECTORS		= 256,
 	ATA_MAX_SECTORS_LBA48	= 65535,/* TODO: 65536? */
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e3f32f3..0cfbcb6 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -311,15 +311,17 @@ enum {
 	ATA_HORKAGE_DIAGNOSTIC	= (1 << 0),	/* Failed boot diag */
 	ATA_HORKAGE_NODMA	= (1 << 1),	/* DMA problems */
 	ATA_HORKAGE_NONCQ	= (1 << 2),	/* Don't use NCQ */
+	ATA_HORKAGE_MAX_SEC_128	= (1 << 3),	/* Limit max sects to 128 */
+	ATA_HORKAGE_DMA_RW_ONLY	= (1 << 4),	/* ATAPI DMA for RW only */
 };
 
 enum hsm_task_states {
 	HSM_ST_IDLE,		/* no command on going */
+	HSM_ST_FIRST,		/* (waiting the device to)
+				   write CDB or first data block */
 	HSM_ST,			/* (waiting the device to) transfer data */
 	HSM_ST_LAST,		/* (waiting the device to) complete command */
 	HSM_ST_ERR,		/* error */
-	HSM_ST_FIRST,		/* (waiting the device to)
-				   write CDB or first data block */
 };
 
 enum ata_completion_errors {
