Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbYDDIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbYDDIXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756194AbYDDIXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:23:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35889 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYDDIXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:23:06 -0400
Date: Fri, 4 Apr 2008 04:23:03 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20080404082303.GA17822@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 drivers/ata/pata_ali.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 include/linux/libata.h    |   25 +++----------------------
 3 files changed, 83 insertions(+), 23 deletions(-)

Bartlomiej Zolnierkiewicz (1):
      libata: fix IDENTIFY order in ata_bus_probe()

Tejun Heo (3):
      libata: uninline atapi_cmd_type()
      libata: ATA_12/16 doesn't fall into ATAPI_MISC
      pata_ali: disable ATAPI DMA

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4851988..be95fdb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -326,6 +326,44 @@ static void ata_force_horkage(struct ata_device *dev)
 }
 
 /**
+ *	atapi_cmd_type - Determine ATAPI command type from SCSI opcode
+ *	@opcode: SCSI opcode
+ *
+ *	Determine ATAPI command type from @opcode.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	ATAPI_{READ|WRITE|READ_CD|PASS_THRU|MISC}
+ */
+int atapi_cmd_type(u8 opcode)
+{
+	switch (opcode) {
+	case GPCMD_READ_10:
+	case GPCMD_READ_12:
+		return ATAPI_READ;
+
+	case GPCMD_WRITE_10:
+	case GPCMD_WRITE_12:
+	case GPCMD_WRITE_AND_VERIFY_10:
+		return ATAPI_WRITE;
+
+	case GPCMD_READ_CD:
+	case GPCMD_READ_CD_MSF:
+		return ATAPI_READ_CD;
+
+	case ATA_16:
+	case ATA_12:
+		if (atapi_passthru16)
+			return ATAPI_PASS_THRU;
+		/* fall thru */
+	default:
+		return ATAPI_MISC;
+	}
+}
+
+/**
  *	ata_tf_to_fis - Convert ATA taskfile to SATA FIS structure
  *	@tf: Taskfile to convert
  *	@pmp: Port multiplier port
@@ -2660,7 +2698,7 @@ int ata_bus_probe(struct ata_port *ap)
 	   specific sequence bass-ackwards so that PDIAG- is released by
 	   the slave device */
 
-	ata_link_for_each_dev(dev, &ap->link) {
+	ata_link_for_each_dev_reverse(dev, &ap->link) {
 		if (tries[dev->devno])
 			dev->class = classes[dev->devno];
 
@@ -7774,6 +7812,7 @@ EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
 EXPORT_SYMBOL_GPL(ata_std_dev_select);
 EXPORT_SYMBOL_GPL(sata_print_link_status);
+EXPORT_SYMBOL_GPL(atapi_cmd_type);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 EXPORT_SYMBOL_GPL(ata_tf_from_fis);
 EXPORT_SYMBOL_GPL(ata_pack_xfermask);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 8786455..ce830fe 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -36,6 +36,10 @@
 #define DRV_NAME "pata_ali"
 #define DRV_VERSION "0.7.5"
 
+int ali_atapi_dma = 0;
+module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
+MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
+
 /*
  *	Cable special cases
  */
@@ -270,6 +274,27 @@ static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 }
 
 /**
+ *	ali_warn_atapi_dma	-	Warn about ATAPI DMA disablement
+ *	@adev: Device
+ *
+ *	Whine about ATAPI DMA disablement if @adev is an ATAPI device.
+ *	Can be used as ->dev_config.
+ */
+
+static void ali_warn_atapi_dma(struct ata_device *adev)
+{
+	struct ata_eh_context *ehc = &adev->link->eh_context;
+	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
+
+	if (print_info && adev->class == ATA_DEV_ATAPI && !ali_atapi_dma) {
+		ata_dev_printk(adev, KERN_WARNING,
+			       "WARNING: ATAPI DMA disabled for reliablity issues.  It can be enabled\n");
+		ata_dev_printk(adev, KERN_WARNING,
+			       "WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.\n");
+	}
+}
+
+/**
  *	ali_lock_sectors	-	Keep older devices to 255 sector mode
  *	@adev: Device
  *
@@ -283,6 +308,7 @@ static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 static void ali_lock_sectors(struct ata_device *adev)
 {
 	adev->max_sectors = 255;
+	ali_warn_atapi_dma(adev);
 }
 
 /**
@@ -294,6 +320,18 @@ static void ali_lock_sectors(struct ata_device *adev)
 
 static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
 {
+	if (!ali_atapi_dma) {
+		/* FIXME: pata_ali can't do ATAPI DMA reliably but the
+		 * IDE alim15x3 driver can.  I tried lots of things
+		 * but couldn't find what the actual difference was.
+		 * If you got an idea, please write it to
+		 * linux-ide@vger.kernel.org and cc htejun@gmail.com.
+		 *
+		 * Disable ATAPI DMA for now.
+		 */
+		return -EOPNOTSUPP;
+	}
+
 	/* If its not a media command, its not worth it */
 	if (atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC)
 		return -EOPNOTSUPP;
@@ -359,6 +397,7 @@ static struct ata_port_operations ali_20_port_ops = {
 
 	.tf_load	= ata_tf_load,
 	.tf_read	= ata_tf_read,
+	.check_atapi_dma = ali_check_atapi_dma,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
@@ -438,6 +477,7 @@ static struct ata_port_operations ali_c5_port_ops = {
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
+	.dev_config	= ali_warn_atapi_dma,
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b064bfe..37ee881 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -350,7 +350,8 @@ enum {
 	ATAPI_READ		= 0,		/* READs */
 	ATAPI_WRITE		= 1,		/* WRITEs */
 	ATAPI_READ_CD		= 2,		/* READ CD [MSF] */
-	ATAPI_MISC		= 3,		/* the rest */
+	ATAPI_PASS_THRU		= 3,		/* SAT pass-thru */
+	ATAPI_MISC		= 4,		/* the rest */
 };
 
 enum ata_xfer_mask {
@@ -849,6 +850,7 @@ extern unsigned int ata_dev_try_classify(struct ata_device *dev, int present,
  */
 extern void ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 extern void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
+extern int atapi_cmd_type(u8 opcode);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
 extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
@@ -1379,27 +1381,6 @@ static inline int ata_try_flush_cache(const struct ata_device *dev)
 	       ata_id_has_flush_ext(dev->id);
 }
 
-static inline int atapi_cmd_type(u8 opcode)
-{
-	switch (opcode) {
-	case GPCMD_READ_10:
-	case GPCMD_READ_12:
-		return ATAPI_READ;
-
-	case GPCMD_WRITE_10:
-	case GPCMD_WRITE_12:
-	case GPCMD_WRITE_AND_VERIFY_10:
-		return ATAPI_WRITE;
-
-	case GPCMD_READ_CD:
-	case GPCMD_READ_CD_MSF:
-		return ATAPI_READ_CD;
-
-	default:
-		return ATAPI_MISC;
-	}
-}
-
 static inline unsigned int ac_err_mask(u8 status)
 {
 	if (status & (ATA_BUSY | ATA_DRQ))
