Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXLRCAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXLRCAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 21:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXLRCAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 21:00:25 -0500
Received: from havoc.gtf.org ([69.61.125.42]:37191 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLRCAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 21:00:22 -0500
Date: Mon, 17 Dec 2007 21:00:20 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071218020020.GA1455@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In 2.6.24, we turned on ACPI support in libata.  This is needed in order
to support suspend/resume and BIOS passworded drives, but it inevitably
brought with it a host of new regressions -- which is what happens
anytime you blindly accept ATA commands the BIOS has decided to toss
your way.  :)

It is bigger than I would like for -rc5, but the bulk of these
changes are Tejun addressing regressions from 2.6.23, most of which
are ACPI-related.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-acpi.c |  387 +++++++++++++++++++++++++++++++--------------
 drivers/ata/libata-core.c |  101 +++++++++----
 drivers/ata/libata-eh.c   |    4 +-
 drivers/ata/libata.h      |    8 +-
 drivers/ata/sata_mv.c     |   30 +++-
 drivers/ata/sata_sil.c    |   18 +--
 include/linux/ata.h       |   15 ++
 include/linux/libata.h    |   29 +++-
 8 files changed, 419 insertions(+), 173 deletions(-)

Mark Lord (1):
      sata_mv: improve warnings about Highpoint RocketRAID 23xx cards

Tejun Heo (15):
      sata_sil: fix spurious IRQ handling
      libata: clear link->eh_info.serror from ata_std_postreset()
      libata: add ST3160023AS / 3.42 to NCQ blacklist
      libata-acpi: adjust constness in ata_acpi_gtm/stm() parameters
      libata: update ata_*_printk() macros such that level can be a variable
      libata: add more opcodes to ata.h
      libata: ata_dev_disable() should be called from EH context
      libata-acpi: add new hooks ata_acpi_dissociate() and ata_acpi_on_disable()
      libata-acpi: implement and use ata_acpi_init_gtm()
      libata-acpi: implement dev->gtf_cache and evaluate _GTF right after _STM during resume
      libata-acpi: improve ACPI disabling
      libata-acpi: improve _GTF execution error handling and reporting
      libata-acpi: implement _GTF command filtering
      libata: update atapi_eh_request_sense() such that lbam/lbah contains buffer size
      libata: fix ATAPI draining

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 545ea86..7bf4bef 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2006 Randy Dunlap
  */
 
+#include <linux/module.h>
 #include <linux/ata.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -25,6 +26,18 @@
 #include <acpi/acmacros.h>
 #include <acpi/actypes.h>
 
+enum {
+	ATA_ACPI_FILTER_SETXFER	= 1 << 0,
+	ATA_ACPI_FILTER_LOCK	= 1 << 1,
+
+	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_SETXFER |
+				  ATA_ACPI_FILTER_LOCK,
+};
+
+static unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
+module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
+MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=set xfermode, 0x2=lock/freeze lock)");
+
 #define NO_PORT_MULT		0xffff
 #define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
 
@@ -41,6 +54,12 @@ static int is_pci_dev(struct device *dev)
 	return (dev->bus == &pci_bus_type);
 }
 
+static void ata_acpi_clear_gtf(struct ata_device *dev)
+{
+	kfree(dev->gtf_cache);
+	dev->gtf_cache = NULL;
+}
+
 /**
  * ata_acpi_associate_sata_port - associate SATA port with ACPI objects
  * @ap: target SATA port
@@ -94,6 +113,9 @@ static void ata_acpi_associate_ide_port(struct ata_port *ap)
 
 		dev->acpi_handle = acpi_get_child(ap->acpi_handle, i);
 	}
+
+	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
+		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
 }
 
 static void ata_acpi_handle_hotplug(struct ata_port *ap, struct kobject *kobj,
@@ -188,6 +210,32 @@ void ata_acpi_associate(struct ata_host *host)
 }
 
 /**
+ * ata_acpi_dissociate - dissociate ATA host from ACPI objects
+ * @host: target ATA host
+ *
+ * This function is called during driver detach after the whole host
+ * is shut down.
+ *
+ * LOCKING:
+ * EH context.
+ */
+void ata_acpi_dissociate(struct ata_host *host)
+{
+	int i;
+
+	/* Restore initial _GTM values so that driver which attaches
+	 * afterward can use them too.
+	 */
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
+
+		if (ap->acpi_handle && gtm)
+			ata_acpi_stm(ap, gtm);
+	}
+}
+
+/**
  * ata_acpi_gtm - execute _GTM
  * @ap: target ATA port
  * @gtm: out parameter for _GTM result
@@ -200,7 +248,7 @@ void ata_acpi_associate(struct ata_host *host)
  * RETURNS:
  * 0 on success, -ENOENT if _GTM doesn't exist, -errno on failure.
  */
-int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *gtm)
+int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *gtm)
 {
 	struct acpi_buffer output = { .length = ACPI_ALLOCATE_BUFFER };
 	union acpi_object *out_obj;
@@ -259,15 +307,16 @@ EXPORT_SYMBOL_GPL(ata_acpi_gtm);
  * RETURNS:
  * 0 on success, -ENOENT if _STM doesn't exist, -errno on failure.
  */
-int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm)
+int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm)
 {
 	acpi_status status;
+	struct ata_acpi_gtm		stm_buf = *stm;
 	struct acpi_object_list         input;
 	union acpi_object               in_params[3];
 
 	in_params[0].type = ACPI_TYPE_BUFFER;
 	in_params[0].buffer.length = sizeof(struct ata_acpi_gtm);
-	in_params[0].buffer.pointer = (u8 *)stm;
+	in_params[0].buffer.pointer = (u8 *)&stm_buf;
 	/* Buffers for id may need byteswapping ? */
 	in_params[1].type = ACPI_TYPE_BUFFER;
 	in_params[1].buffer.length = 512;
@@ -297,7 +346,6 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  * ata_dev_get_GTF - get the drive bootup default taskfile settings
  * @dev: target ATA device
  * @gtf: output parameter for buffer containing _GTF taskfile arrays
- * @ptr_to_free: pointer which should be freed
  *
  * This applies to both PATA and SATA drives.
  *
@@ -311,11 +359,10 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  * EH context.
  *
  * RETURNS:
- * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.
+ * Number of taskfiles on success, 0 if _GTF doesn't exist.  -EINVAL
+ * if _GTF is invalid.
  */
-static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
-			   void **ptr_to_free)
+static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 {
 	struct ata_port *ap = dev->link->ap;
 	acpi_status status;
@@ -323,6 +370,12 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 	union acpi_object *out_obj;
 	int rc = 0;
 
+	/* if _GTF is cached, use the cached value */
+	if (dev->gtf_cache) {
+		out_obj = dev->gtf_cache;
+		goto done;
+	}
+
 	/* set up output buffer */
 	output.length = ACPI_ALLOCATE_BUFFER;
 	output.pointer = NULL;	/* ACPI-CA sets this; save/free it later */
@@ -333,12 +386,14 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 
 	/* _GTF has no input parameters */
 	status = acpi_evaluate_object(dev->acpi_handle, "_GTF", NULL, &output);
+	out_obj = dev->gtf_cache = output.pointer;
 
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND) {
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
+			rc = -EINVAL;
 		}
 		goto out_free;
 	}
@@ -350,14 +405,15 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 				__FUNCTION__,
 				(unsigned long long)output.length,
 				output.pointer);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
-	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -365,21 +421,23 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
-	*ptr_to_free = out_obj;
-	*gtf = (void *)out_obj->buffer.pointer;
+ done:
 	rc = out_obj->buffer.length / REGS_PER_GTF;
-
-	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "%s: returning "
-			"gtf=%p, gtf_count=%d, ptr_to_free=%p\n",
-			__FUNCTION__, *gtf, rc, *ptr_to_free);
+	if (gtf) {
+		*gtf = (void *)out_obj->buffer.pointer;
+		if (ata_msg_probe(ap))
+			ata_dev_printk(dev, KERN_DEBUG,
+				       "%s: returning gtf=%p, gtf_count=%d\n",
+				       __FUNCTION__, *gtf, rc);
+	}
 	return rc;
 
  out_free:
-	kfree(output.pointer);
+	ata_acpi_clear_gtf(dev);
 	return rc;
 }
 
@@ -393,22 +451,21 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 
 int ata_acpi_cbl_80wire(struct ata_port *ap)
 {
-	struct ata_acpi_gtm gtm;
+	const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
 	int valid = 0;
 
-	/* No _GTM data, no information */
-	if (ata_acpi_gtm(ap, &gtm) < 0)
+	if (!gtm)
 		return 0;
 
 	/* Split timing, DMA enabled */
-	if ((gtm.flags & 0x11) == 0x11 && gtm.drive[0].dma < 55)
+	if ((gtm->flags & 0x11) == 0x11 && gtm->drive[0].dma < 55)
 		valid |= 1;
-	if ((gtm.flags & 0x14) == 0x14 && gtm.drive[1].dma < 55)
+	if ((gtm->flags & 0x14) == 0x14 && gtm->drive[1].dma < 55)
 		valid |= 2;
 	/* Shared timing, DMA enabled */
-	if ((gtm.flags & 0x11) == 0x01 && gtm.drive[0].dma < 55)
+	if ((gtm->flags & 0x11) == 0x01 && gtm->drive[0].dma < 55)
 		valid |= 1;
-	if ((gtm.flags & 0x14) == 0x04 && gtm.drive[0].dma < 55)
+	if ((gtm->flags & 0x14) == 0x04 && gtm->drive[0].dma < 55)
 		valid |= 2;
 
 	/* Drive check */
@@ -421,8 +478,62 @@ int ata_acpi_cbl_80wire(struct ata_port *ap)
 
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
+static void ata_acpi_gtf_to_tf(struct ata_device *dev,
+			       const struct ata_acpi_gtf *gtf,
+			       struct ata_taskfile *tf)
+{
+	ata_tf_init(dev, tf);
+
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->feature = gtf->tf[0];	/* 0x1f1 */
+	tf->nsect   = gtf->tf[1];	/* 0x1f2 */
+	tf->lbal    = gtf->tf[2];	/* 0x1f3 */
+	tf->lbam    = gtf->tf[3];	/* 0x1f4 */
+	tf->lbah    = gtf->tf[4];	/* 0x1f5 */
+	tf->device  = gtf->tf[5];	/* 0x1f6 */
+	tf->command = gtf->tf[6];	/* 0x1f7 */
+}
+
+static int ata_acpi_filter_tf(const struct ata_taskfile *tf,
+			      const struct ata_taskfile *ptf)
+{
+	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_SETXFER) {
+		/* libata doesn't use ACPI to configure transfer mode.
+		 * It will only confuse device configuration.  Skip.
+		 */
+		if (tf->command == ATA_CMD_SET_FEATURES &&
+		    tf->feature == SETFEATURES_XFER)
+			return 1;
+	}
+
+	if (ata_acpi_gtf_filter & ATA_ACPI_FILTER_LOCK) {
+		/* BIOS writers, sorry but we don't wanna lock
+		 * features unless the user explicitly said so.
+		 */
+
+		/* DEVICE CONFIGURATION FREEZE LOCK */
+		if (tf->command == ATA_CMD_CONF_OVERLAY &&
+		    tf->feature == ATA_DCO_FREEZE_LOCK)
+			return 1;
+
+		/* SECURITY FREEZE LOCK */
+		if (tf->command == ATA_CMD_SEC_FREEZE_LOCK)
+			return 1;
+
+		/* SET MAX LOCK and SET MAX FREEZE LOCK */
+		if ((!ptf || ptf->command != ATA_CMD_READ_NATIVE_MAX) &&
+		    tf->command == ATA_CMD_SET_MAX &&
+		    (tf->feature == ATA_SET_MAX_LOCK ||
+		     tf->feature == ATA_SET_MAX_FREEZE_LOCK))
+			return 1;
+	}
+
+	return 0;
+}
+
 /**
- * taskfile_load_raw - send taskfile registers to host controller
+ * ata_acpi_run_tf - send taskfile registers to host controller
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
  *
@@ -441,56 +552,77 @@ EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
  * EH context.
  *
  * RETURNS:
- * 0 on success, -errno on failure.
+ * 1 if command is executed successfully.  0 if ignored, rejected or
+ * filtered out, -errno on other errors.
  */
-static int taskfile_load_raw(struct ata_device *dev,
-			      const struct ata_acpi_gtf *gtf)
+static int ata_acpi_run_tf(struct ata_device *dev,
+			   const struct ata_acpi_gtf *gtf,
+			   const struct ata_acpi_gtf *prev_gtf)
 {
-	struct ata_port *ap = dev->link->ap;
-	struct ata_taskfile tf, rtf;
+	struct ata_taskfile *pptf = NULL;
+	struct ata_taskfile tf, ptf, rtf;
 	unsigned int err_mask;
+	const char *level;
+	char msg[60];
+	int rc;
 
 	if ((gtf->tf[0] == 0) && (gtf->tf[1] == 0) && (gtf->tf[2] == 0)
 	    && (gtf->tf[3] == 0) && (gtf->tf[4] == 0) && (gtf->tf[5] == 0)
 	    && (gtf->tf[6] == 0))
 		return 0;
 
-	ata_tf_init(dev, &tf);
+	ata_acpi_gtf_to_tf(dev, gtf, &tf);
+	if (prev_gtf) {
+		ata_acpi_gtf_to_tf(dev, prev_gtf, &ptf);
+		pptf = &ptf;
+	}
 
-	/* convert gtf to tf */
-	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE; /* TBD */
-	tf.protocol = ATA_PROT_NODATA;
-	tf.feature = gtf->tf[0];	/* 0x1f1 */
-	tf.nsect   = gtf->tf[1];	/* 0x1f2 */
-	tf.lbal    = gtf->tf[2];	/* 0x1f3 */
-	tf.lbam    = gtf->tf[3];	/* 0x1f4 */
-	tf.lbah    = gtf->tf[4];	/* 0x1f5 */
-	tf.device  = gtf->tf[5];	/* 0x1f6 */
-	tf.command = gtf->tf[6];	/* 0x1f7 */
+	if (!ata_acpi_filter_tf(&tf, pptf)) {
+		rtf = tf;
+		err_mask = ata_exec_internal(dev, &rtf, NULL,
+					     DMA_NONE, NULL, 0, 0);
 
-	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "executing ACPI cmd "
-			       "%02x/%02x:%02x:%02x:%02x:%02x:%02x\n",
-			       tf.command, tf.feature, tf.nsect,
-			       tf.lbal, tf.lbam, tf.lbah, tf.device);
-
-	rtf = tf;
-	err_mask = ata_exec_internal(dev, &rtf, NULL, DMA_NONE, NULL, 0, 0);
-	if (err_mask) {
-		ata_dev_printk(dev, KERN_ERR,
-			"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x failed "
-			"(Emask=0x%x Stat=0x%02x Err=0x%02x)\n",
-			tf.command, tf.feature, tf.nsect, tf.lbal, tf.lbam,
-			tf.lbah, tf.device, err_mask, rtf.command, rtf.feature);
-		return -EIO;
+		switch (err_mask) {
+		case 0:
+			level = KERN_DEBUG;
+			snprintf(msg, sizeof(msg), "succeeded");
+			rc = 1;
+			break;
+
+		case AC_ERR_DEV:
+			level = KERN_INFO;
+			snprintf(msg, sizeof(msg),
+				 "rejected by device (Stat=0x%02x Err=0x%02x)",
+				 rtf.command, rtf.feature);
+			rc = 0;
+			break;
+
+		default:
+			level = KERN_ERR;
+			snprintf(msg, sizeof(msg),
+				 "failed (Emask=0x%x Stat=0x%02x Err=0x%02x)",
+				 err_mask, rtf.command, rtf.feature);
+			rc = -EIO;
+			break;
+		}
+	} else {
+		level = KERN_INFO;
+		snprintf(msg, sizeof(msg), "filtered out");
+		rc = 0;
 	}
 
-	return 0;
+	ata_dev_printk(dev, level,
+		       "ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x %s\n",
+		       tf.command, tf.feature, tf.nsect, tf.lbal,
+		       tf.lbam, tf.lbah, tf.device, msg);
+
+	return rc;
 }
 
 /**
  * ata_acpi_exec_tfs - get then write drive taskfile settings
  * @dev: target ATA device
+ * @nr_executed: out paramter for the number of executed commands
  *
  * Evaluate _GTF and excute returned taskfiles.
  *
@@ -498,35 +630,36 @@ static int taskfile_load_raw(struct ata_device *dev,
  * EH context.
  *
  * RETURNS:
- * Number of executed taskfiles on success, 0 if _GTF doesn't exist or
- * doesn't contain valid data.  -errno on other errors.
+ * Number of executed taskfiles on success, 0 if _GTF doesn't exist.
+ * -errno on other errors.
  */
-static int ata_acpi_exec_tfs(struct ata_device *dev)
+static int ata_acpi_exec_tfs(struct ata_device *dev, int *nr_executed)
 {
-	struct ata_acpi_gtf *gtf = NULL;
-	void *ptr_to_free = NULL;
+	struct ata_acpi_gtf *gtf = NULL, *pgtf = NULL;
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
+	rc = ata_dev_get_GTF(dev, &gtf);
+	if (rc < 0)
+		return rc;
+	gtf_count = rc;
 
 	/* execute them */
-	for (i = 0, rc = 0; i < gtf_count; i++) {
-		int tmp;
-
-		/* ACPI errors are eventually ignored.  Run till the
-		 * end even after errors.
-		 */
-		tmp = taskfile_load_raw(dev, gtf++);
-		if (!rc)
-			rc = tmp;
+	for (i = 0; i < gtf_count; i++, gtf++) {
+		rc = ata_acpi_run_tf(dev, gtf, pgtf);
+		if (rc < 0)
+			break;
+		if (rc) {
+			(*nr_executed)++;
+			pgtf = gtf;
+		}
 	}
 
-	kfree(ptr_to_free);
+	ata_acpi_clear_gtf(dev);
 
-	if (rc == 0)
-		return gtf_count;
-	return rc;
+	if (rc < 0)
+		return rc;
+	return 0;
 }
 
 /**
@@ -596,27 +729,8 @@ static int ata_acpi_push_id(struct ata_device *dev)
  */
 int ata_acpi_on_suspend(struct ata_port *ap)
 {
-	unsigned long flags;
-	int rc;
-
-	/* proceed iff per-port acpi_handle is valid */
-	if (!ap->acpi_handle)
-		return 0;
-	BUG_ON(ap->flags & ATA_FLAG_ACPI_SATA);
-
-	/* store timing parameters */
-	rc = ata_acpi_gtm(ap, &ap->acpi_gtm);
-
-	spin_lock_irqsave(ap->lock, flags);
-	if (rc == 0)
-		ap->pflags |= ATA_PFLAG_GTM_VALID;
-	else
-		ap->pflags &= ~ATA_PFLAG_GTM_VALID;
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	if (rc == -ENOENT)
-		rc = 0;
-	return rc;
+	/* nada */
+	return 0;
 }
 
 /**
@@ -631,18 +745,34 @@ int ata_acpi_on_suspend(struct ata_port *ap)
  */
 void ata_acpi_on_resume(struct ata_port *ap)
 {
+	const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
 	struct ata_device *dev;
 
-	if (ap->acpi_handle && (ap->pflags & ATA_PFLAG_GTM_VALID)) {
-		BUG_ON(ap->flags & ATA_FLAG_ACPI_SATA);
+	if (ap->acpi_handle && gtm) {
+		/* _GTM valid */
 
 		/* restore timing parameters */
-		ata_acpi_stm(ap, &ap->acpi_gtm);
-	}
+		ata_acpi_stm(ap, gtm);
 
-	/* schedule _GTF */
-	ata_link_for_each_dev(dev, &ap->link)
-		dev->flags |= ATA_DFLAG_ACPI_PENDING;
+		/* _GTF should immediately follow _STM so that it can
+		 * use values set by _STM.  Cache _GTF result and
+		 * schedule _GTF.
+		 */
+		ata_link_for_each_dev(dev, &ap->link) {
+			ata_acpi_clear_gtf(dev);
+			if (ata_dev_get_GTF(dev, NULL) >= 0)
+				dev->flags |= ATA_DFLAG_ACPI_PENDING;
+		}
+	} else {
+		/* SATA _GTF needs to be evaulated after _SDD and
+		 * there's no reason to evaluate IDE _GTF early
+		 * without _STM.  Clear cache and schedule _GTF.
+		 */
+		ata_link_for_each_dev(dev, &ap->link) {
+			ata_acpi_clear_gtf(dev);
+			dev->flags |= ATA_DFLAG_ACPI_PENDING;
+		}
+	}
 }
 
 /**
@@ -664,6 +794,7 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	struct ata_port *ap = dev->link->ap;
 	struct ata_eh_context *ehc = &ap->link.eh_context;
 	int acpi_sata = ap->flags & ATA_FLAG_ACPI_SATA;
+	int nr_executed = 0;
 	int rc;
 
 	if (!dev->acpi_handle)
@@ -682,14 +813,14 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	}
 
 	/* do _GTF */
-	rc = ata_acpi_exec_tfs(dev);
-	if (rc < 0)
+	rc = ata_acpi_exec_tfs(dev, &nr_executed);
+	if (rc)
 		goto acpi_err;
 
 	dev->flags &= ~ATA_DFLAG_ACPI_PENDING;
 
 	/* refresh IDENTIFY page if any _GTF command has been executed */
-	if (rc > 0) {
+	if (nr_executed) {
 		rc = ata_dev_reread_id(dev, 0);
 		if (rc < 0) {
 			ata_dev_printk(dev, KERN_ERR, "failed to IDENTIFY "
@@ -701,17 +832,39 @@ int ata_acpi_on_devcfg(struct ata_device *dev)
 	return 0;
 
  acpi_err:
-	/* let EH retry on the first failure, disable ACPI on the second */
-	if (dev->flags & ATA_DFLAG_ACPI_FAILED) {
-		ata_dev_printk(dev, KERN_WARNING, "ACPI on devcfg failed the "
-			       "second time, disabling (errno=%d)\n", rc);
-
-		dev->acpi_handle = NULL;
+	/* ignore evaluation failure if we can continue safely */
+	if (rc == -EINVAL && !nr_executed && !(ap->pflags & ATA_PFLAG_FROZEN))
+		return 0;
 
-		/* if port is working, request IDENTIFY reload and continue */
-		if (!(ap->pflags & ATA_PFLAG_FROZEN))
-			rc = 1;
+	/* fail and let EH retry once more for unknown IO errors */
+	if (!(dev->flags & ATA_DFLAG_ACPI_FAILED)) {
+		dev->flags |= ATA_DFLAG_ACPI_FAILED;
+		return rc;
 	}
-	dev->flags |= ATA_DFLAG_ACPI_FAILED;
+
+	ata_dev_printk(dev, KERN_WARNING,
+		       "ACPI: failed the second time, disabled\n");
+	dev->acpi_handle = NULL;
+
+	/* We can safely continue if no _GTF command has been executed
+	 * and port is not frozen.
+	 */
+	if (!nr_executed && !(ap->pflags & ATA_PFLAG_FROZEN))
+		return 0;
+
 	return rc;
 }
+
+/**
+ * ata_acpi_on_disable - ATA ACPI hook called when a device is disabled
+ * @dev: target ATA device
+ *
+ * This function is called when @dev is about to be disabled.
+ *
+ * LOCKING:
+ * EH context.
+ */
+void ata_acpi_on_disable(struct ata_device *dev)
+{
+	ata_acpi_clear_gtf(dev);
+}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e4dea86..4753a18 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -64,6 +64,7 @@
 #include <linux/libata.h>
 #include <asm/semaphore.h>
 #include <asm/byteorder.h>
+#include <linux/cdrom.h>
 
 #include "libata.h"
 
@@ -622,6 +623,7 @@ void ata_dev_disable(struct ata_device *dev)
 	if (ata_dev_enabled(dev)) {
 		if (ata_msg_drv(dev->link->ap))
 			ata_dev_printk(dev, KERN_WARNING, "disabled\n");
+		ata_acpi_on_disable(dev);
 		ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO0 |
 					     ATA_DNXFER_QUIET);
 		dev->class++;
@@ -3923,6 +3925,7 @@ void ata_std_postreset(struct ata_link *link, unsigned int *classes)
 	/* clear SError */
 	if (sata_scr_read(link, SCR_ERROR, &serror) == 0)
 		sata_scr_write(link, SCR_ERROR, serror);
+	link->eh_info.serror = 0;
 
 	/* is double-select really necessary? */
 	if (classes[0] != ATA_DEV_NONE)
@@ -4149,6 +4152,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HITACHI HDS7250SASUN500G*", NULL,    ATA_HORKAGE_NONCQ },
 	{ "HITACHI HDS7225SBSUN250G*", NULL,    ATA_HORKAGE_NONCQ },
 	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
+	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132
 	   Windows driver .inf file - also several Linux problem reports */
@@ -4649,6 +4653,43 @@ int ata_check_atapi_dma(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	atapi_qc_may_overflow - Check whether data transfer may overflow
+ *	@qc: ATA command in question
+ *
+ *	ATAPI commands which transfer variable length data to host
+ *	might overflow due to application error or hardare bug.  This
+ *	function checks whether overflow should be drained and ignored
+ *	for @qc.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	1 if @qc may overflow; otherwise, 0.
+ */
+static int atapi_qc_may_overflow(struct ata_queued_cmd *qc)
+{
+	if (qc->tf.protocol != ATA_PROT_ATAPI &&
+	    qc->tf.protocol != ATA_PROT_ATAPI_DMA)
+		return 0;
+
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		return 0;
+
+	switch (qc->cdb[0]) {
+	case READ_10:
+	case READ_12:
+	case WRITE_10:
+	case WRITE_12:
+	case GPCMD_READ_CD:
+	case GPCMD_READ_CD_MSF:
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
  *	ata_std_qc_defer - Check whether a qc needs to be deferred
  *	@qc: ATA command in question
  *
@@ -5136,23 +5177,19 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
  *	Inherited from caller.
  *
  */
-
-static void __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
+static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
 {
 	int do_write = (qc->tf.flags & ATA_TFLAG_WRITE);
-	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
 	struct ata_port *ap = qc->ap;
+	struct ata_eh_info *ehi = &qc->dev->link->eh_info;
+	struct scatterlist *sg;
 	struct page *page;
 	unsigned char *buf;
 	unsigned int offset, count;
-	int no_more_sg = 0;
-
-	if (qc->curbytes + bytes >= qc->nbytes)
-		ap->hsm_task_state = HSM_ST_LAST;
 
 next_sg:
-	if (unlikely(no_more_sg)) {
+	sg = qc->cursg;
+	if (unlikely(!sg)) {
 		/*
 		 * The end of qc->sg is reached and the device expects
 		 * more data to transfer. In order not to overrun qc->sg
@@ -5161,21 +5198,28 @@ next_sg:
 		 *    - for write case, padding zero data to the device
 		 */
 		u16 pad_buf[1] = { 0 };
-		unsigned int words = bytes >> 1;
 		unsigned int i;
 
-		if (words) /* warning if bytes > 1 */
-			ata_dev_printk(qc->dev, KERN_WARNING,
-				       "%u bytes trailing data\n", bytes);
+		if (bytes > qc->curbytes - qc->nbytes + ATAPI_MAX_DRAIN) {
+			ata_ehi_push_desc(ehi, "too much trailing data "
+					  "buf=%u cur=%u bytes=%u",
+					  qc->nbytes, qc->curbytes, bytes);
+			return -1;
+		}
 
-		for (i = 0; i < words; i++)
+		 /* overflow is exptected for misc ATAPI commands */
+		if (bytes && !atapi_qc_may_overflow(qc))
+			ata_dev_printk(qc->dev, KERN_WARNING, "ATAPI %u bytes "
+				       "trailing data (cdb=%02x nbytes=%u)\n",
+				       bytes, qc->cdb[0], qc->nbytes);
+
+		for (i = 0; i < (bytes + 1) / 2; i++)
 			ap->ops->data_xfer(qc->dev, (unsigned char *)pad_buf, 2, do_write);
 
-		ap->hsm_task_state = HSM_ST_LAST;
-		return;
-	}
+		qc->curbytes += bytes;
 
-	sg = qc->cursg;
+		return 0;
+	}
 
 	page = sg_page(sg);
 	offset = sg->offset + qc->cursg_ofs;
@@ -5210,19 +5254,20 @@ next_sg:
 	}
 
 	bytes -= count;
+	if ((count & 1) && bytes)
+		bytes--;
 	qc->curbytes += count;
 	qc->cursg_ofs += count;
 
 	if (qc->cursg_ofs == sg->length) {
-		if (qc->cursg == lsg)
-			no_more_sg = 1;
-
 		qc->cursg = sg_next(qc->cursg);
 		qc->cursg_ofs = 0;
 	}
 
 	if (bytes)
 		goto next_sg;
+
+	return 0;
 }
 
 /**
@@ -5265,7 +5310,8 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 
 	VPRINTK("ata%u: xfering %d bytes\n", ap->print_id, bytes);
 
-	__atapi_pio_bytes(qc, bytes);
+	if (__atapi_pio_bytes(qc, bytes))
+		goto err_out;
 	ata_altstatus(ap); /* flush */
 
 	return;
@@ -7208,18 +7254,14 @@ static void ata_port_detach(struct ata_port *ap)
 
 	ata_port_wait_eh(ap);
 
-	/* EH is now guaranteed to see UNLOADING, so no new device
-	 * will be attached.  Disable all existing devices.
+	/* EH is now guaranteed to see UNLOADING - EH context belongs
+	 * to us.  Disable all existing devices.
 	 */
-	spin_lock_irqsave(ap->lock, flags);
-
 	ata_port_for_each_link(link, ap) {
 		ata_link_for_each_dev(dev, link)
 			ata_dev_disable(dev);
 	}
 
-	spin_unlock_irqrestore(ap->lock, flags);
-
 	/* Final freeze & EH.  All in-flight commands are aborted.  EH
 	 * will be skipped and retrials will be terminated with bad
 	 * target.
@@ -7251,6 +7293,9 @@ void ata_host_detach(struct ata_host *host)
 
 	for (i = 0; i < host->n_ports; i++)
 		ata_port_detach(host->ports[i]);
+
+	/* the host is dead now, dissociate ACPI */
+	ata_acpi_dissociate(host);
 }
 
 /**
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e6605f0..f0124a8 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1264,8 +1264,8 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 		tf.feature |= ATAPI_PKT_DMA;
 	} else {
 		tf.protocol = ATA_PROT_ATAPI;
-		tf.lbam = (8 * 1024) & 0xff;
-		tf.lbah = (8 * 1024) >> 8;
+		tf.lbam = SCSI_SENSE_BUFFERSIZE;
+		tf.lbah = 0;
 	}
 
 	return ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0e6cf3a..bbe59c2 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -108,15 +108,19 @@ extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
 #ifdef CONFIG_ATA_ACPI
 extern void ata_acpi_associate_sata_port(struct ata_port *ap);
 extern void ata_acpi_associate(struct ata_host *host);
+extern void ata_acpi_dissociate(struct ata_host *host);
 extern int ata_acpi_on_suspend(struct ata_port *ap);
 extern void ata_acpi_on_resume(struct ata_port *ap);
-extern int ata_acpi_on_devcfg(struct ata_device *adev);
+extern int ata_acpi_on_devcfg(struct ata_device *dev);
+extern void ata_acpi_on_disable(struct ata_device *dev);
 #else
 static inline void ata_acpi_associate_sata_port(struct ata_port *ap) { }
 static inline void ata_acpi_associate(struct ata_host *host) { }
+static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
 static inline void ata_acpi_on_resume(struct ata_port *ap) { }
-static inline int ata_acpi_on_devcfg(struct ata_device *adev) { return 0; }
+static inline int ata_acpi_on_devcfg(struct ata_device *dev) { return 0; }
+static inline void ata_acpi_on_disable(struct ata_device *dev) { }
 #endif
 
 /* libata-scsi.c */
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index fe0105d..37b850a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2506,11 +2506,31 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		if (pdev->vendor == PCI_VENDOR_ID_TTI &&
 		    (pdev->device == 0x2300 || pdev->device == 0x2310))
 		{
-			printk(KERN_WARNING "sata_mv: Highpoint RocketRAID BIOS"
-				" will CORRUPT DATA on attached drives when"
-				" configured as \"Legacy\".  BEWARE!\n");
-			printk(KERN_WARNING "sata_mv: Use BIOS \"JBOD\" volumes"
-				" instead for safety.\n");
+			/*
+			 * Highpoint RocketRAID PCIe 23xx series cards:
+			 *
+			 * Unconfigured drives are treated as "Legacy"
+			 * by the BIOS, and it overwrites sector 8 with
+			 * a "Lgcy" metadata block prior to Linux boot.
+			 *
+			 * Configured drives (RAID or JBOD) leave sector 8
+			 * alone, but instead overwrite a high numbered
+			 * sector for the RAID metadata.  This sector can
+			 * be determined exactly, by truncating the physical
+			 * drive capacity to a nice even GB value.
+			 *
+			 * RAID metadata is at: (dev->n_sectors & ~0xfffff)
+			 *
+			 * Warn the user, lest they think we're just buggy.
+			 */
+			printk(KERN_WARNING DRV_NAME ": Highpoint RocketRAID"
+				" BIOS CORRUPTS DATA on all attached drives,"
+				" regardless of if/how they are configured."
+				" BEWARE!\n");
+			printk(KERN_WARNING DRV_NAME ": For data safety, do not"
+				" use sectors 8-9 on \"Legacy\" drives,"
+				" and avoid the final two gigabytes on"
+				" all RocketRAID BIOS initialized drives.\n");
 		}
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 4e6e381..f5119bf 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -390,23 +390,19 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		sil_scr_read(ap, SCR_ERROR, &serror);
 		sil_scr_write(ap, SCR_ERROR, serror);
 
-		/* Trigger hotplug and accumulate SError only if the
-		 * port isn't already frozen.  Otherwise, PHY events
-		 * during hardreset makes controllers with broken SIEN
-		 * repeat probing needlessly.
+		/* Sometimes spurious interrupts occur, double check
+		 * it's PHYRDY CHG.
 		 */
-		if (!(ap->pflags & ATA_PFLAG_FROZEN)) {
-			ata_ehi_hotplugged(&ap->link.eh_info);
+		if (serror & SERR_PHYRDY_CHG) {
 			ap->link.eh_info.serror |= serror;
+			goto freeze;
 		}
 
-		goto freeze;
+		if (!(bmdma2 & SIL_DMA_COMPLETE))
+			return;
 	}
 
-	if (unlikely(!qc))
-		goto freeze;
-
-	if (unlikely(qc->tf.flags & ATA_TFLAG_POLLING)) {
+	if (unlikely(!qc || (qc->tf.flags & ATA_TFLAG_POLLING))) {
 		/* this sometimes happens, just clear IRQ */
 		ata_chk_status(ap);
 		return;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 5c4e54a..72ab808 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -190,6 +190,8 @@ enum {
 	ATA_CMD_READ_LOG_EXT	= 0x2f,
 	ATA_CMD_PMP_READ	= 0xE4,
 	ATA_CMD_PMP_WRITE	= 0xE8,
+	ATA_CMD_CONF_OVERLAY	= 0xB1,
+	ATA_CMD_SEC_FREEZE_LOCK	= 0xF5,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
@@ -239,6 +241,19 @@ enum {
 	SATA_AN			= 0x05,  /* Asynchronous Notification */
 	SATA_DIPM		= 0x03,  /* Device Initiated Power Management */
 
+	/* feature values for SET_MAX */
+	ATA_SET_MAX_ADDR	= 0x00,
+	ATA_SET_MAX_PASSWD	= 0x01,
+	ATA_SET_MAX_LOCK	= 0x02,
+	ATA_SET_MAX_UNLOCK	= 0x03,
+	ATA_SET_MAX_FREEZE_LOCK	= 0x04,
+
+	/* feature values for DEVICE CONFIGURATION OVERLAY */
+	ATA_DCO_RESTORE		= 0xC0,
+	ATA_DCO_FREEZE_LOCK	= 0xC1,
+	ATA_DCO_IDENTIFY	= 0xC2,
+	ATA_DCO_SET		= 0xC3,
+
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
 	ATAPI_DMADIR		= (1 << 2),	/* ATAPI data dir:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ef52a07..124033c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -119,6 +119,8 @@ enum {
 	ATA_DEF_BUSY_WAIT	= 10000,
 	ATA_SHORT_PAUSE		= (HZ >> 6) + 1,
 
+	ATAPI_MAX_DRAIN		= 16 << 10,
+
 	ATA_SHT_EMULATED	= 1,
 	ATA_SHT_CMD_PER_LUN	= 1,
 	ATA_SHT_THIS_ID		= -1,
@@ -211,7 +213,7 @@ enum {
 
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
 	ATA_PFLAG_PM_PENDING	= (1 << 18), /* PM operation pending */
-	ATA_PFLAG_GTM_VALID	= (1 << 19), /* acpi_gtm data valid */
+	ATA_PFLAG_INIT_GTM_VALID = (1 << 19), /* initial gtm data valid */
 
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
@@ -498,6 +500,7 @@ struct ata_device {
 	struct scsi_device	*sdev;		/* attached SCSI device */
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
+	union acpi_object	*gtf_cache;
 #endif
 	/* n_sector is used as CLEAR_OFFSET, read comment above CLEAR_OFFSET */
 	u64			n_sectors;	/* size of device, if ATA */
@@ -653,7 +656,7 @@ struct ata_port {
 
 #ifdef CONFIG_ATA_ACPI
 	acpi_handle		acpi_handle;
-	struct ata_acpi_gtm	acpi_gtm;
+	struct ata_acpi_gtm	__acpi_init_gtm; /* use ata_acpi_init_gtm() */
 #endif
 	u8			sector_buf[ATA_SECT_SIZE]; /* owned by EH */
 };
@@ -939,10 +942,20 @@ enum {
 
 /* libata-acpi.c */
 #ifdef CONFIG_ATA_ACPI
+static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
+{
+	if (ap->pflags & ATA_PFLAG_INIT_GTM_VALID)
+		return &ap->__acpi_init_gtm;
+	return NULL;
+}
 extern int ata_acpi_cbl_80wire(struct ata_port *ap);
-int ata_acpi_stm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
-int ata_acpi_gtm(const struct ata_port *ap, struct ata_acpi_gtm *stm);
+int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm);
+int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *stm);
 #else
+static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
+{
+	return NULL;
+}
 static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
 #endif
 
@@ -1013,18 +1026,18 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
  * printk helpers
  */
 #define ata_port_printk(ap, lv, fmt, args...) \
-	printk(lv"ata%u: "fmt, (ap)->print_id , ##args)
+	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
 
 #define ata_link_printk(link, lv, fmt, args...) do { \
 	if ((link)->ap->nr_pmp_links) \
-		printk(lv"ata%u.%02u: "fmt, (link)->ap->print_id, \
+		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
 		       (link)->pmp , ##args); \
 	else \
-		printk(lv"ata%u: "fmt, (link)->ap->print_id , ##args); \
+		printk("%sata%u: "fmt, lv, (link)->ap->print_id , ##args); \
 	} while(0)
 
 #define ata_dev_printk(dev, lv, fmt, args...) \
-	printk(lv"ata%u.%02u: "fmt, (dev)->link->ap->print_id, \
+	printk("%sata%u.%02u: "fmt, lv, (dev)->link->ap->print_id,	\
 	       (dev)->link->pmp + (dev)->devno , ##args)
 
 /*
