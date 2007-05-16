Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXEPFgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXEPFgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 01:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbXEPFgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 01:36:31 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59547 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760617AbXEPFg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 01:36:29 -0400
Date: Wed, 16 May 2007 01:36:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070516053628.GA17870@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


All bug fixes.  The two things that do not seem like bugfixes ("separate
out..." and "add ATA_FLAG_ACPI_SATA") are not as they seem.  The former
is a prep patch for a fix, and the latter fixes what ACPI considers a
legacy IDE interface.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |    3 +-
 drivers/ata/libata-acpi.c |   10 +++---
 drivers/ata/libata-core.c |   80 +++++++++++++++++++++++++++-----------------
 drivers/ata/libata-scsi.c |   44 ++++++++++++++++++++----
 drivers/ata/libata.h      |    3 +-
 drivers/ata/pata_scc.c    |    4 +-
 drivers/ata/sata_sil24.c  |    3 +-
 include/linux/libata.h    |    3 +-
 8 files changed, 100 insertions(+), 50 deletions(-)

Al Viro (1):
      pata_scc had been missed by ata_std_prereset() switch

Tejun Heo (5):
      libata: separate out ata_dev_reread_id()
      libata: during revalidation, check n_sectors after device is configured
      libata-acpi: add ATA_FLAG_ACPI_SATA port flag
      libata: fix shutdown warning message printing
      libata: track spindown status and skip spindown_compat if possible

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1ae443d..e00e1b9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -173,7 +173,8 @@ enum {
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_SKIP_D2H_BSY,
+					  ATA_FLAG_SKIP_D2H_BSY |
+					  ATA_FLAG_ACPI_SATA,
 };
 
 struct ahci_cmd_hdr {
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ed4138e..0223673 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -321,7 +321,7 @@ static int do_drive_get_GTF(struct ata_device *dev, unsigned int *gtf_length,
 
 	/* Don't continue if device has no _ADR method.
 	 * _GTF is intended for known motherboard devices. */
-	if (!(ap->cbl == ATA_CBL_SATA)) {
+	if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
 		err = pata_get_dev_handle(gdev, &dev_handle, &pcidevfn);
 		if (err < 0) {
 			if (ata_msg_probe(ap))
@@ -343,7 +343,7 @@ static int do_drive_get_GTF(struct ata_device *dev, unsigned int *gtf_length,
 
 	/* Get this drive's _ADR info. if not already known. */
 	if (!dev->obj_handle) {
-		if (!(ap->cbl == ATA_CBL_SATA)) {
+		if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
 			/* get child objects of dev_handle == channel objects,
 	 		 * + _their_ children == drive objects */
 			/* channel is ap->port_no */
@@ -528,7 +528,7 @@ static int do_drive_set_taskfiles(struct ata_device *dev,
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
 			       __FUNCTION__, ap->port_no);
 
-	if (libata_noacpi || !(ap->cbl == ATA_CBL_SATA))
+	if (libata_noacpi || !(ap->flags & ATA_FLAG_ACPI_SATA))
 		return 0;
 
 	if (!ata_dev_enabled(dev) || (ap->flags & ATA_FLAG_DISABLED))
@@ -578,7 +578,7 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
 	 * we should not run GTF on PATA devices since some
 	 * PATA require execution of GTM/STM before GTF.
 	 */
-	if (!(ap->cbl == ATA_CBL_SATA))
+	if (!(ap->flags & ATA_FLAG_ACPI_SATA))
 		return 0;
 
 	for (ix = 0; ix < ATA_MAX_DEVICES; ix++) {
@@ -641,7 +641,7 @@ int ata_acpi_push_id(struct ata_device *dev)
 			       __FUNCTION__, dev->devno, ap->port_no);
 
 	/* Don't continue if not a SATA device. */
-	if (!(ap->cbl == ATA_CBL_SATA)) {
+	if (!(ap->flags & ATA_FLAG_ACPI_SATA)) {
 		if (ata_msg_probe(ap))
 			ata_dev_printk(dev, KERN_DEBUG,
 				"%s: Not a SATA device\n", __FUNCTION__);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4166407..d5939e6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1919,7 +1919,6 @@ int ata_dev_configure(struct ata_device *dev)
 			snprintf(revbuf, 7, "ATA-%d",  ata_id_major_version(id));
 
 		dev->n_sectors = ata_id_n_sectors(id);
-		dev->n_sectors_boot = dev->n_sectors;
 
 		/* SCSI only uses 4-char revisions, dump full 8 chars from ATA */
 		ata_id_c_string(dev->id, fwrevbuf, ATA_ID_FW_REV,
@@ -3632,7 +3631,6 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	const u16 *old_id = dev->id;
 	unsigned char model[2][ATA_ID_PROD_LEN + 1];
 	unsigned char serial[2][ATA_ID_SERNO_LEN + 1];
-	u64 new_n_sectors;
 
 	if (dev->class != new_class) {
 		ata_dev_printk(dev, KERN_INFO, "class mismatch %d != %d\n",
@@ -3644,7 +3642,6 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 	ata_id_c_string(new_id, model[1], ATA_ID_PROD, sizeof(model[1]));
 	ata_id_c_string(old_id, serial[0], ATA_ID_SERNO, sizeof(serial[0]));
 	ata_id_c_string(new_id, serial[1], ATA_ID_SERNO, sizeof(serial[1]));
-	new_n_sectors = ata_id_n_sectors(new_id);
 
 	if (strcmp(model[0], model[1])) {
 		ata_dev_printk(dev, KERN_INFO, "model number mismatch "
@@ -3658,25 +3655,12 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
 		return 0;
 	}
 
-	if (dev->class == ATA_DEV_ATA && dev->n_sectors != new_n_sectors) {
-		ata_dev_printk(dev, KERN_INFO, "n_sectors mismatch "
-			       "%llu != %llu\n",
-			       (unsigned long long)dev->n_sectors,
-			       (unsigned long long)new_n_sectors);
-		/* Are we the boot time size - if so we appear to be the
-		   same disk at this point and our HPA got reapplied */
-		if (ata_ignore_hpa && dev->n_sectors_boot == new_n_sectors 
-		    && ata_id_hpa_enabled(new_id))
-			return 1;
-		return 0;
-	}
-
 	return 1;
 }
 
 /**
- *	ata_dev_revalidate - Revalidate ATA device
- *	@dev: device to revalidate
+ *	ata_dev_reread_id - Re-read IDENTIFY data
+ *	@adev: target ATA device
  *	@readid_flags: read ID flags
  *
  *	Re-read IDENTIFY page and make sure @dev is still attached to
@@ -3688,34 +3672,68 @@ static int ata_dev_same_device(struct ata_device *dev, unsigned int new_class,
  *	RETURNS:
  *	0 on success, negative errno otherwise
  */
-int ata_dev_revalidate(struct ata_device *dev, unsigned int readid_flags)
+int ata_dev_reread_id(struct ata_device *dev, unsigned int readid_flags)
 {
 	unsigned int class = dev->class;
 	u16 *id = (void *)dev->ap->sector_buf;
 	int rc;
 
-	if (!ata_dev_enabled(dev)) {
-		rc = -ENODEV;
-		goto fail;
-	}
-
 	/* read ID data */
 	rc = ata_dev_read_id(dev, &class, readid_flags, id);
 	if (rc)
-		goto fail;
+		return rc;
 
 	/* is the device still there? */
-	if (!ata_dev_same_device(dev, class, id)) {
-		rc = -ENODEV;
-		goto fail;
-	}
+	if (!ata_dev_same_device(dev, class, id))
+		return -ENODEV;
 
 	memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
+	return 0;
+}
+
+/**
+ *	ata_dev_revalidate - Revalidate ATA device
+ *	@dev: device to revalidate
+ *	@readid_flags: read ID flags
+ *
+ *	Re-read IDENTIFY page, make sure @dev is still attached to the
+ *	port and reconfigure it according to the new IDENTIFY page.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep)
+ *
+ *	RETURNS:
+ *	0 on success, negative errno otherwise
+ */
+int ata_dev_revalidate(struct ata_device *dev, unsigned int readid_flags)
+{
+	u64 n_sectors = dev->n_sectors;
+	int rc;
+
+	if (!ata_dev_enabled(dev))
+		return -ENODEV;
+
+	/* re-read ID */
+	rc = ata_dev_reread_id(dev, readid_flags);
+	if (rc)
+		goto fail;
 
 	/* configure device according to the new ID */
 	rc = ata_dev_configure(dev);
-	if (rc == 0)
-		return 0;
+	if (rc)
+		goto fail;
+
+	/* verify n_sectors hasn't changed */
+	if (dev->class == ATA_DEV_ATA && dev->n_sectors != n_sectors) {
+		ata_dev_printk(dev, KERN_INFO, "n_sectors mismatch "
+			       "%llu != %llu\n",
+			       (unsigned long long)n_sectors,
+			       (unsigned long long)dev->n_sectors);
+		rc = -ENODEV;
+		goto fail;
+	}
+
+	return 0;
 
  fail:
 	ata_dev_printk(dev, KERN_ERR, "revalidation failed (errno=%d)\n", rc);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index dd81fa7..b6a1de8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -893,6 +893,23 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 	return queue_depth;
 }
 
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done_timerfn(unsigned long arg)
+{
+	struct scsi_cmnd *scmd = (void *)arg;
+
+	scmd->scsi_done(scmd);
+}
+
+/* XXX: for ata_spindown_compat */
+static void ata_delayed_done(struct scsi_cmnd *scmd)
+{
+	static struct timer_list timer;
+
+	setup_timer(&timer, ata_delayed_done_timerfn, (unsigned long)scmd);
+	mod_timer(&timer, jiffies + 5 * HZ);
+}
+
 /**
  *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
  *	@qc: Storage for translated ATA taskfile
@@ -950,21 +967,24 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		 * for more info.
 		 */
 		if (ata_spindown_compat &&
+		    (qc->dev->flags & ATA_DFLAG_SPUNDOWN) &&
 		    (system_state == SYSTEM_HALT ||
 		     system_state == SYSTEM_POWER_OFF)) {
-			static int warned = 0;
+			static unsigned long warned = 0;
 
-			if (!warned) {
-				spin_unlock_irq(qc->ap->lock);
+			if (!test_and_set_bit(0, &warned)) {
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
 					"UPDATE SHUTDOWN UTILITY\n");
 				ata_dev_printk(qc->dev, KERN_WARNING,
 					"For more info, visit "
 					"http://linux-ata.org/shutdown.html\n");
-				warned = 1;
-				ssleep(5);
-				spin_lock_irq(qc->ap->lock);
+
+				/* ->scsi_done is not used, use it for
+				 * delayed completion.
+				 */
+				scmd->scsi_done = qc->scsidone;
+				qc->scsidone = ata_delayed_done;
 			}
 			scmd->result = SAM_STAT_GOOD;
 			return 1;
@@ -1375,6 +1395,14 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 		}
 	}
 
+	/* XXX: track spindown state for spindown_compat */
+	if (unlikely(qc->tf.command == ATA_CMD_STANDBY ||
+		     qc->tf.command == ATA_CMD_STANDBYNOW1))
+		qc->dev->flags |= ATA_DFLAG_SPUNDOWN;
+	else if (likely(system_state != SYSTEM_HALT &&
+			system_state != SYSTEM_POWER_OFF))
+		qc->dev->flags &= ~ATA_DFLAG_SPUNDOWN;
+
 	if (need_sense && !ap->ops->error_handler)
 		ata_dump_status(ap->print_id, &qc->result_tf);
 
@@ -1488,14 +1516,14 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 early_finish:
         ata_qc_free(qc);
-	done(cmd);
+	qc->scsidone(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	done(cmd);
+	qc->scsidone(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 8b71b73..13cb0c9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -76,7 +76,8 @@ extern unsigned ata_exec_internal_sg(struct ata_device *dev,
 extern unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd);
 extern int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			   unsigned int flags, u16 *id);
-extern int ata_dev_revalidate(struct ata_device *dev, unsigned int flags);
+extern int ata_dev_reread_id(struct ata_device *dev, unsigned int readid_flags);
+extern int ata_dev_revalidate(struct ata_device *dev, unsigned int readid_flags);
 extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_port *ap);
 extern int sata_set_spd_needed(struct ata_port *ap);
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index cca3aa2..844e53b 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -864,10 +864,10 @@ static void scc_bmdma_freeze (struct ata_port *ap)
  *	@ap: ATA port to be reset
  */
 
-static int scc_pata_prereset (struct ata_port *ap)
+static int scc_pata_prereset (struct ata_port *ap, unsigned long deadline)
 {
 	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
+	return ata_std_prereset(ap, deadline);
 }
 
 /**
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index a69d78c..0cb6618 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -237,7 +237,8 @@ enum {
 	/* host flags */
 	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				  ATA_FLAG_NCQ | ATA_FLAG_SKIP_D2H_BSY,
+				  ATA_FLAG_NCQ | ATA_FLAG_SKIP_D2H_BSY |
+				  ATA_FLAG_ACPI_SATA,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
 
 	IRQ_STAT_4PORTS		= 0xf,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 27d9362..666592e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -140,6 +140,7 @@ enum {
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
@@ -173,6 +174,7 @@ enum {
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
+	ATA_FLAG_ACPI_SATA	= (1 << 17), /* need native SATA ACPI layout */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -431,7 +433,6 @@ struct ata_device {
 	struct scsi_device	*sdev;		/* attached SCSI device */
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
-	u64			n_sectors_boot;	/* size of ATA device at startup */
 	unsigned int		class;		/* ATA_DEV_xxx */
 	u16			id[ATA_ID_WORDS]; /* IDENTIFY xxx DEVICE data */
 	u8			pio_mode;
