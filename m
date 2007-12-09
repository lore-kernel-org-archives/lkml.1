Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbXLIGrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbXLIGrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXLIGq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:46:59 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:33443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLIGq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:46:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=JW7CfqkgCkO3x3gqoudwO2DZy1owIa86dYRZdgwdrjB10aj1TzPcW7bNICQt/hAGw9V2O+XQG95x/R6JEtJZ2g4cfEhMG0BHGHQvsacgM04SPeka0Yn0hSR1gYQdMPp4dbNiNS/bPidOti3LLmHYFCK9yv/5x46u1SJLCNRtUoc=
Message-ID: <475B8F51.8030605@gmail.com>
Date: Sun, 09 Dec 2007 15:46:41 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Kjartan Maraas <kmaraas@broadpark.no>
CC: Tomas Carnecky <tom@dbservice.com>, Pavel Machek <pavel@ucw.cz>,
       linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz> <4740692E.7010801@dbservice.com> <47409DA3.7070909@dbservice.com> <1195551141.2792.3.camel@localhost.localdomain> <474CBFB6.4020105@gmail.com> <1196253340.2884.1.camel@localhost.localdomain> <474FE862.4040700@gmail.com> <1196458627.4106.1.camel@localhost.localdomain> <47565738.1050003@gmail.com> <1196874547.3700.0.camel@localhost.localdomain> <4757608D.8020005@gmail.com> <1196959657.2661.0.camel@localhost.localdomain>
In-Reply-To: <1196959657.2661.0.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------010507030608030707090502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010507030608030707090502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Kjartan Maraas wrote:
> to., 06.12.2007 kl. 11.38 +0900, skrev Tejun Heo:
>> Thanks.  Almost there.  Can you please try the attached two patches and
>> report the boot log?
>>
> Here we go again.

Hmmm... Ah.. okay.  Wrongly splitted patch.  Can you please do it one
more time?

Thanks.

-- 
tejun

--------------010507030608030707090502
Content-Type: text/x-patch;
 name="acpi-device-rej-no-filter-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi-device-rej-no-filter-1.patch"

Index: work/include/linux/libata.h
===================================================================
--- work.orig/include/linux/libata.h
+++ work/include/linux/libata.h
@@ -1013,18 +1013,18 @@ extern void ata_do_eh(struct ata_port *a
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
Index: work/include/linux/ata.h
===================================================================
--- work.orig/include/linux/ata.h
+++ work/include/linux/ata.h
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
Index: work/drivers/ata/libata-acpi.c
===================================================================
--- work.orig/drivers/ata/libata-acpi.c
+++ work/drivers/ata/libata-acpi.c
@@ -311,8 +311,8 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  * EH context.
  *
  * RETURNS:
- * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.
+ * Number of taskfiles on success, 0 if _GTF doesn't exist.  -EINVAL
+ * if _GTF is invalid.
  */
 static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			   void **ptr_to_free)
@@ -339,6 +339,7 @@ static int ata_dev_get_GTF(struct ata_de
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
+			rc = -EINVAL;
 		}
 		goto out_free;
 	}
@@ -350,6 +351,7 @@ static int ata_dev_get_GTF(struct ata_de
 				__FUNCTION__,
 				(unsigned long long)output.length,
 				output.pointer);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -358,6 +360,7 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -365,6 +368,7 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -397,7 +401,7 @@ int ata_acpi_cbl_80wire(struct ata_port 
 	int valid = 0;
 
 	/* No _GTM data, no information */
-	if (ata_acpi_gtm(ap, &gtm) < 0)
+	if (!ap->acpi_handle || ata_acpi_gtm(ap, &gtm) < 0)
 		return 0;
 
 	/* Split timing, DMA enabled */
@@ -422,7 +426,7 @@ int ata_acpi_cbl_80wire(struct ata_port 
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
 /**
- * taskfile_load_raw - send taskfile registers to host controller
+ * ata_acpi_run_tf - send taskfile registers to host controller
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
  *
@@ -441,14 +445,17 @@ EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
  * EH context.
  *
  * RETURNS:
- * 0 on success, -errno on failure.
+ * 1 if command is executed successfully.  0 if ignored or rejected,
+ * -errno on other errors.
  */
-static int taskfile_load_raw(struct ata_device *dev,
-			      const struct ata_acpi_gtf *gtf)
+static int ata_acpi_run_tf(struct ata_device *dev,
+			   const struct ata_acpi_gtf *gtf)
 {
-	struct ata_port *ap = dev->link->ap;
 	struct ata_taskfile tf, rtf;
 	unsigned int err_mask;
+	const char *level;
+	char msg[60];
+	int rc;
 
 	if ((gtf->tf[0] == 0) && (gtf->tf[1] == 0) && (gtf->tf[2] == 0)
 	    && (gtf->tf[3] == 0) && (gtf->tf[4] == 0) && (gtf->tf[5] == 0)
@@ -468,29 +475,45 @@ static int taskfile_load_raw(struct ata_
 	tf.device  = gtf->tf[5];	/* 0x1f6 */
 	tf.command = gtf->tf[6];	/* 0x1f7 */
 
-	if (ata_msg_probe(ap))
-		ata_dev_printk(dev, KERN_DEBUG, "executing ACPI cmd "
-			       "%02x/%02x:%02x:%02x:%02x:%02x:%02x\n",
-			       tf.command, tf.feature, tf.nsect,
-			       tf.lbal, tf.lbam, tf.lbah, tf.device);
-
 	rtf = tf;
 	err_mask = ata_exec_internal(dev, &rtf, NULL, DMA_NONE, NULL, 0, 0);
-	if (err_mask) {
-		ata_dev_printk(dev, KERN_ERR,
-			"ACPI cmd %02x/%02x:%02x:%02x:%02x:%02x:%02x failed "
-			"(Emask=0x%x Stat=0x%02x Err=0x%02x)\n",
-			tf.command, tf.feature, tf.nsect, tf.lbal, tf.lbam,
-			tf.lbah, tf.device, err_mask, rtf.command, rtf.feature);
-		return -EIO;
+
+	switch (err_mask) {
+	case 0:
+		level = KERN_DEBUG;
+		snprintf(msg, sizeof(msg), "succeeded");
+		rc = 1;
+		break;
+
+	case AC_ERR_DEV:
+		level = KERN_INFO;
+		snprintf(msg, sizeof(msg),
+			 "rejected by device (Stat=0x%02x Err=0x%02x)",
+			 rtf.command, rtf.feature);
+		rc = 0;
+		break;
+
+	default:
+		level = KERN_ERR;
+		snprintf(msg, sizeof(msg),
+			 "failed (Emask=0x%x Stat=0x%02x Err=0x%02x)",
+			 err_mask, rtf.command, rtf.feature);
+		rc = -EIO;
+		break;
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
@@ -498,35 +521,35 @@ static int taskfile_load_raw(struct ata_
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
 	struct ata_acpi_gtf *gtf = NULL;
 	void *ptr_to_free = NULL;
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
+	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
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
+	for (i = 0; i < gtf_count; i++) {
+		rc = ata_acpi_run_tf(dev, gtf++);
+		if (rc < 0)
+			break;
+		if (rc)
+			(*nr_executed)++;
 	}
 
 	kfree(ptr_to_free);
 
-	if (rc == 0)
-		return gtf_count;
-	return rc;
+	if (rc < 0)
+		return rc;
+	return 0;
 }
 
 /**
@@ -664,6 +687,8 @@ int ata_acpi_on_devcfg(struct ata_device
 	struct ata_port *ap = dev->link->ap;
 	struct ata_eh_context *ehc = &ap->link.eh_context;
 	int acpi_sata = ap->flags & ATA_FLAG_ACPI_SATA;
+	int nr_executed = 0;
+	const char *reason;
 	int rc;
 
 	if (!dev->acpi_handle)
@@ -682,14 +707,14 @@ int ata_acpi_on_devcfg(struct ata_device
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
@@ -701,17 +726,25 @@ int ata_acpi_on_devcfg(struct ata_device
 	return 0;
 
  acpi_err:
-	/* let EH retry on the first failure, disable ACPI on the second */
-	if (dev->flags & ATA_DFLAG_ACPI_FAILED) {
-		ata_dev_printk(dev, KERN_WARNING, "ACPI on devcfg failed the "
-			       "second time, disabling (errno=%d)\n", rc);
-
-		dev->acpi_handle = NULL;
-
-		/* if port is working, request IDENTIFY reload and continue */
-		if (!(ap->pflags & ATA_PFLAG_FROZEN))
-			rc = 1;
+	/* fail and let EH retry once more for unknown IO errors */
+	if (rc != -EINVAL && !(dev->flags & ATA_DFLAG_ACPI_FAILED)) {
+		dev->flags |= ATA_DFLAG_ACPI_FAILED;
+		return rc;
 	}
-	dev->flags |= ATA_DFLAG_ACPI_FAILED;
+
+	if (rc == -EINVAL)
+		reason = "_GTF invalid";
+	else
+		reason = "failed the second time";
+
+	ata_dev_printk(dev, KERN_WARNING, "ACPI: %s, disabled\n", reason);
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

--------------010507030608030707090502
Content-Type: text/x-patch;
 name="acpi-device-rej-filter-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi-device-rej-filter-1.patch"

Index: work/include/linux/libata.h
===================================================================
--- work.orig/include/linux/libata.h
+++ work/include/linux/libata.h
@@ -1013,18 +1013,18 @@ extern void ata_do_eh(struct ata_port *a
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
Index: work/include/linux/ata.h
===================================================================
--- work.orig/include/linux/ata.h
+++ work/include/linux/ata.h
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
Index: work/drivers/ata/libata-acpi.c
===================================================================
--- work.orig/drivers/ata/libata-acpi.c
+++ work/drivers/ata/libata-acpi.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2006 Randy Dunlap
  */
 
+#include <linux/module.h>
 #include <linux/ata.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -25,6 +26,16 @@
 #include <acpi/acmacros.h>
 #include <acpi/actypes.h>
 
+enum {
+	ATA_ACPI_FILTER_LOCK	= 1 << 0,
+
+	ATA_ACPI_FILTER_DEFAULT	= ATA_ACPI_FILTER_LOCK,
+};
+
+static unsigned int ata_acpi_gtf_filter = ATA_ACPI_FILTER_DEFAULT;
+module_param_named(acpi_gtf_filter, ata_acpi_gtf_filter, int, 0644);
+MODULE_PARM_DESC(acpi_gtf_filter, "filter mask for ACPI _GTF commands, set to filter out (0x1=lock/freeze lock)");
+
 #define NO_PORT_MULT		0xffff
 #define SATA_ADR(root, pmp)	(((root) << 16) | (pmp))
 
@@ -311,8 +322,8 @@ EXPORT_SYMBOL_GPL(ata_acpi_stm);
  * EH context.
  *
  * RETURNS:
- * Number of taskfiles on success, 0 if _GTF doesn't exist or doesn't
- * contain valid data.
+ * Number of taskfiles on success, 0 if _GTF doesn't exist.  -EINVAL
+ * if _GTF is invalid.
  */
 static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf,
 			   void **ptr_to_free)
@@ -339,6 +350,7 @@ static int ata_dev_get_GTF(struct ata_de
 			ata_dev_printk(dev, KERN_WARNING,
 				       "_GTF evaluation failed (AE 0x%x)\n",
 				       status);
+			rc = -EINVAL;
 		}
 		goto out_free;
 	}
@@ -350,6 +362,7 @@ static int ata_dev_get_GTF(struct ata_de
 				__FUNCTION__,
 				(unsigned long long)output.length,
 				output.pointer);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -358,6 +371,7 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "_GTF unexpected object type 0x%x\n",
 			       out_obj->type);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -365,6 +379,7 @@ static int ata_dev_get_GTF(struct ata_de
 		ata_dev_printk(dev, KERN_WARNING,
 			       "unexpected _GTF length (%d)\n",
 			       out_obj->buffer.length);
+		rc = -EINVAL;
 		goto out_free;
 	}
 
@@ -397,7 +412,7 @@ int ata_acpi_cbl_80wire(struct ata_port 
 	int valid = 0;
 
 	/* No _GTM data, no information */
-	if (ata_acpi_gtm(ap, &gtm) < 0)
+	if (!ap->acpi_handle || ata_acpi_gtm(ap, &gtm) < 0)
 		return 0;
 
 	/* Split timing, DMA enabled */
@@ -421,8 +436,53 @@ int ata_acpi_cbl_80wire(struct ata_port 
 
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
@@ -441,56 +501,77 @@ EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
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
+
+		switch (err_mask) {
+		case 0:
+			level = KERN_DEBUG;
+			snprintf(msg, sizeof(msg), "succeeded");
+			rc = 1;
+			break;
 
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
+ 		level = KERN_INFO;
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
@@ -498,35 +579,37 @@ static int taskfile_load_raw(struct ata_
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
+	struct ata_acpi_gtf *gtf = NULL, *pgtf = NULL;
 	void *ptr_to_free = NULL;
 	int gtf_count, i, rc;
 
 	/* get taskfiles */
-	gtf_count = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
+	rc = ata_dev_get_GTF(dev, &gtf, &ptr_to_free);
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
 
 	kfree(ptr_to_free);
 
-	if (rc == 0)
-		return gtf_count;
-	return rc;
+	if (rc < 0)
+		return rc;
+	return 0;
 }
 
 /**
@@ -664,6 +747,8 @@ int ata_acpi_on_devcfg(struct ata_device
 	struct ata_port *ap = dev->link->ap;
 	struct ata_eh_context *ehc = &ap->link.eh_context;
 	int acpi_sata = ap->flags & ATA_FLAG_ACPI_SATA;
+	int nr_executed = 0;
+	const char *reason;
 	int rc;
 
 	if (!dev->acpi_handle)
@@ -682,14 +767,14 @@ int ata_acpi_on_devcfg(struct ata_device
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
@@ -701,17 +786,25 @@ int ata_acpi_on_devcfg(struct ata_device
 	return 0;
 
  acpi_err:
-	/* let EH retry on the first failure, disable ACPI on the second */
-	if (dev->flags & ATA_DFLAG_ACPI_FAILED) {
-		ata_dev_printk(dev, KERN_WARNING, "ACPI on devcfg failed the "
-			       "second time, disabling (errno=%d)\n", rc);
+	/* fail and let EH retry once more for unknown IO errors */
+	if (rc != -EINVAL && !(dev->flags & ATA_DFLAG_ACPI_FAILED)) {
+		dev->flags |= ATA_DFLAG_ACPI_FAILED;
+		return rc;
+	}
 
-		dev->acpi_handle = NULL;
+	if (rc == -EINVAL)
+		reason = "_GTF invalid";
+	else
+		reason = "failed the second time";
+
+	ata_dev_printk(dev, KERN_WARNING, "ACPI: %s, disabled\n", reason);
+	dev->acpi_handle = NULL;
+
+	/* We can safely continue if no _GTF command has been executed
+	 * and port is not frozen.
+	 */
+	if (!nr_executed && !(ap->pflags & ATA_PFLAG_FROZEN))
+		return 0;
 
-		/* if port is working, request IDENTIFY reload and continue */
-		if (!(ap->pflags & ATA_PFLAG_FROZEN))
-			rc = 1;
-	}
-	dev->flags |= ATA_DFLAG_ACPI_FAILED;
 	return rc;
 }

--------------010507030608030707090502--
