Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbYAPBBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbYAPBBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbYAPBAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:00:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:4695 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbYAPBAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:00:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HtPWojSfySw434zxtWVe62KrAxgiPxW0EiujAMzhV9zWbOpaOedwGvR1ZFGEAV9yNH/XClXkvzmAYcSOh5VR8ZQc7RuDgjL7p5P/VzjCpV2Rc0Nwr5jUhJ9lUceAfFIRDiuu6+FddjpEpZQz1ls8vt7o0A6+m+UmnpogtKGRybk=
From: Tejun Heo <htejun@gmail.com>
To: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       randy.dunlap@oracle.com, jeff@garzik.org, linux-ide@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/4] libata: make libata use printk_header() and mprintk
Date: Wed, 16 Jan 2008 10:00:10 +0900
Message-Id: <12004452112326-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1200445210549-git-send-email-htejun@gmail.com>
References: <1200445210549-git-send-email-htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement libata printk helpers using printk_header, implement
helpers to initialize mprintk and use mprintk during device
configuration and EH reporting.

This fixes various formatting related problems of libata messages such
as misaligned multiline messages, decoded register lines with leading
headers making them difficult to tell to which error they belong to,
awkward manual indents and complex message printing logics.  More
importantly, by making message assembly flexible, this patch makes
future changes to device configuration and EH reporting easier.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 drivers/ata/libata-core.c   |  202 +++++++++++++++++++++++++++----------------
 drivers/ata/libata-eh.c     |  150 +++++++++++++++-----------------
 drivers/ata/libata-pmp.c    |    5 +-
 drivers/ata/libata-scsi.c   |    6 +-
 drivers/ata/sata_inic162x.c |    2 +-
 drivers/ata/sata_nv.c       |    4 +-
 include/linux/libata.h      |   35 ++++----
 7 files changed, 223 insertions(+), 181 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4753a18..6fac482 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -125,6 +125,79 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 
 
+int ata_port_printk(struct ata_port *ap, const char *lv, const char *fmt, ...)
+{
+	va_list args;
+	char hbuf[16];
+	int ret;
+
+	snprintf(hbuf, sizeof(hbuf), "%sata%u: ", lv, ap->print_id);
+
+	va_start(args, fmt);
+	ret = vprintk_header(hbuf, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+
+int ata_link_printk(struct ata_link *link, const char *lv, const char *fmt, ...)
+{
+	va_list args;
+	char hbuf[16];
+	int ret;
+
+	if (link->ap->nr_pmp_links)
+		snprintf(hbuf, sizeof(hbuf), "%sata%u.%02u: ",
+			 lv, link->ap->print_id, link->pmp);
+	else
+		snprintf(hbuf, sizeof(hbuf), "%sata%u: ",
+			 lv, link->ap->print_id);
+
+	va_start(args, fmt);
+	ret = vprintk_header(hbuf, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+
+int ata_dev_printk(struct ata_device *dev, const char *lv, const char *fmt, ...)
+{
+	va_list args;
+	char hbuf[16];
+	int ret;
+
+	snprintf(hbuf, sizeof(hbuf), "%sata%u.%02u: ",
+		 lv, dev->link->ap->print_id, dev->link->pmp + dev->devno);
+
+	va_start(args, fmt);
+	ret = vprintk_header(hbuf, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+
+void ata_port_mp_header(struct ata_port *ap, const char *lv, struct mprintk *mp)
+{
+	mprintk_set_header(mp, "%sata%u: ", lv, ap->print_id);
+}
+
+void ata_link_mp_header(struct ata_link *link, const char *lv,
+			struct mprintk *mp)
+{
+	if (link->ap->nr_pmp_links)
+		mprintk_set_header(mp, "%sata%u.%02u: ",
+				   lv, link->ap->print_id, link->pmp);
+	else
+		mprintk_set_header(mp, "%sata%u: ", lv, link->ap->print_id);
+}
+
+void ata_dev_mp_header(struct ata_device *dev, const char *lv,
+		       struct mprintk *mp)
+{
+	mprintk_set_header(mp, "%sata%u.%02u: ", lv, dev->link->ap->print_id,
+			   dev->link->pmp + dev->devno);
+}
+
 /**
  *	ata_tf_to_fis - Convert ATA taskfile to SATA FIS structure
  *	@tf: Taskfile to convert
@@ -2046,18 +2119,16 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
-static void ata_dev_config_ncq(struct ata_device *dev,
-			       char *desc, size_t desc_sz)
+static void ata_dev_config_ncq(struct ata_device *dev, struct mprintk *mp)
 {
 	struct ata_port *ap = dev->link->ap;
 	int hdepth = 0, ddepth = ata_id_queue_depth(dev->id);
 
-	if (!ata_id_has_ncq(dev->id)) {
-		desc[0] = '\0';
+	if (!ata_id_has_ncq(dev->id))
 		return;
-	}
+
 	if (dev->horkage & ATA_HORKAGE_NONCQ) {
-		snprintf(desc, desc_sz, "NCQ (not used)");
+		mprintk_push(mp, ", NCQ (not used)");
 		return;
 	}
 	if (ap->flags & ATA_FLAG_NCQ) {
@@ -2066,9 +2137,9 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 	}
 
 	if (hdepth >= ddepth)
-		snprintf(desc, desc_sz, "NCQ (depth %d)", ddepth);
+		mprintk_push(mp, ", NCQ (depth %d)", ddepth);
 	else
-		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
+		mprintk_push(mp, ", NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
 /**
@@ -2090,8 +2161,8 @@ int ata_dev_configure(struct ata_device *dev)
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	const u16 *id = dev->id;
+	struct mprintk mp = MPRINTK_INITIALIZER(ap->sector_buf, ATA_SECT_SIZE);
 	unsigned int xfer_mask;
-	char revbuf[7];		/* XYZ-99\0 */
 	char fwrevbuf[ATA_ID_FW_REV_LEN+1];
 	char modelbuf[ATA_ID_PROD_LEN+1];
 	int rc;
@@ -2105,6 +2176,8 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
+	ata_dev_mp_header(dev, KERN_INFO, &mp);
+
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
 
@@ -2153,51 +2226,44 @@ int ata_dev_configure(struct ata_device *dev)
 	ata_id_c_string(dev->id, modelbuf, ATA_ID_PROD,
 			sizeof(modelbuf));
 
-	/* ATA-specific feature tests */
 	if (dev->class == ATA_DEV_ATA) {
+		/* ATA-specific feature tests */
 		if (ata_id_is_cfa(id)) {
-			if (id[162] & 1) /* CPRM may make this media unusable */
+			/* CPRM may make this media unusable */
+			if ((id[162] & 1) && print_info)
 				ata_dev_printk(dev, KERN_WARNING,
 					       "supports DRM functions and may "
 					       "not be fully accessable.\n");
-			snprintf(revbuf, 7, "CFA");
+			mprintk_push(&mp, "CFA: ");
 		} else
-			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
+			mprintk_push(&mp, "ATA-%d: ", ata_id_major_version(id));
+
+		mprintk_push(&mp, "%s, %s, max %s\n",
+			     modelbuf, fwrevbuf, ata_mode_string(xfer_mask));
 
 		dev->n_sectors = ata_id_n_sectors(id);
+		mprintk_push(&mp, "%Lu sectors",
+			     (unsigned long long)dev->n_sectors);
 
-		if (dev->id[59] & 0x100)
+		if (dev->id[59] & 0x100) {
 			dev->multi_count = dev->id[59] & 0xff;
+			mprintk_push(&mp, ", multi %u", dev->multi_count);
+		}
 
 		if (ata_id_has_lba(id)) {
-			const char *lba_desc;
-			char ncq_desc[20];
-
-			lba_desc = "LBA";
 			dev->flags |= ATA_DFLAG_LBA;
+			mprintk_push(&mp, ", LBA");
+
 			if (ata_id_has_lba48(id)) {
 				dev->flags |= ATA_DFLAG_LBA48;
-				lba_desc = "LBA48";
-
+				mprintk_push(&mp, "48");
 				if (dev->n_sectors >= (1UL << 28) &&
 				    ata_id_has_flush_ext(id))
 					dev->flags |= ATA_DFLAG_FLUSH_EXT;
 			}
 
 			/* config NCQ */
-			ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
-
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf, modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u: %s %s\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, lba_desc, ncq_desc);
-			}
+			ata_dev_config_ncq(dev, &mp);
 		} else {
 			/* CHS */
 
@@ -2213,27 +2279,13 @@ int ata_dev_configure(struct ata_device *dev)
 				dev->sectors   = id[56];
 			}
 
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_printk(dev, KERN_INFO,
-					"%s: %s, %s, max %s\n",
-					revbuf,	modelbuf, fwrevbuf,
-					ata_mode_string(xfer_mask));
-				ata_dev_printk(dev, KERN_INFO,
-					"%Lu sectors, multi %u, CHS %u/%u/%u\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, dev->cylinders,
-					dev->heads, dev->sectors);
-			}
+			mprintk_push(&mp, ", CHS %u/%u/%u",
+				     dev->cylinders, dev->heads, dev->sectors);
 		}
 
 		dev->cdb_len = 16;
-	}
-
-	/* ATAPI-specific feature tests */
-	else if (dev->class == ATA_DEV_ATAPI) {
-		const char *cdb_intr_string = "";
-		const char *atapi_an_string = "";
+	} else if (dev->class == ATA_DEV_ATAPI) {
+		/* ATAPI-specific feature tests */
 		u32 sntf;
 
 		rc = atapi_cdb_len(id);
@@ -2246,6 +2298,14 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 		dev->cdb_len = (unsigned int) rc;
 
+		mprintk_push(&mp, "ATAPI: %s, %s, max %s", modelbuf, fwrevbuf,
+			     ata_mode_string(xfer_mask));
+
+		if (ata_id_cdb_intr(dev->id)) {
+			dev->flags |= ATA_DFLAG_CDB_INTR;
+			mprintk_push(&mp, ", CDB intr");
+		}
+
 		/* Enable ATAPI AN if both the host and device have
 		 * the support.  If PMP is attached, SNTF is required
 		 * to enable ATAPI AN to discern between PHY status
@@ -2265,22 +2325,9 @@ int ata_dev_configure(struct ata_device *dev)
 					"(err_mask=0x%x)\n", err_mask);
 			else {
 				dev->flags |= ATA_DFLAG_AN;
-				atapi_an_string = ", ATAPI AN";
+				mprintk_push(&mp, ", ATAPI AN");
 			}
 		}
-
-		if (ata_id_cdb_intr(dev->id)) {
-			dev->flags |= ATA_DFLAG_CDB_INTR;
-			cdb_intr_string = ", CDB intr";
-		}
-
-		/* print device info to dmesg */
-		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "ATAPI: %s, %s, max %s%s%s\n",
-				       modelbuf, fwrevbuf,
-				       ata_mode_string(xfer_mask),
-				       cdb_intr_string, atapi_an_string);
 	}
 
 	/* determine max_sectors */
@@ -2295,23 +2342,18 @@ int ata_dev_configure(struct ata_device *dev)
 			dev->flags |= ATA_DFLAG_DIPM;
 	}
 
-	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
+	if ((dev->horkage & ATA_HORKAGE_DIAGNOSTIC) && print_info) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
 		   idiot */
-		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
-"Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
-"fault or invalid emulation. Contact drive vendor for information.\n");
-		}
+		ata_dev_printk(dev, KERN_WARNING,
+		"Drive reports diagnostics failure. This may indicate a drive\n"
+		"fault or invalid emulation. Contact drive vendor for information.\n");
 	}
 
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(dev)) {
-		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "applying bridge limits\n");
+		mprintk_push(&mp, ", applying bridge limits");
 		dev->udma_mask &= ATA_UDMA5;
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
@@ -2336,6 +2378,10 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
+	/* print device info to dmesg */
+	if (ata_msg_drv(ap) && print_info)
+		mprintk(&mp, "\n");
+
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
 			__FUNCTION__, ata_chk_status(ap));
@@ -7577,6 +7623,12 @@ EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
 EXPORT_SYMBOL_GPL(sata_deb_timing_long);
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 EXPORT_SYMBOL_GPL(ata_dummy_port_info);
+EXPORT_SYMBOL_GPL(ata_port_printk);
+EXPORT_SYMBOL_GPL(ata_link_printk);
+EXPORT_SYMBOL_GPL(ata_dev_printk);
+EXPORT_SYMBOL_GPL(ata_port_mp_header);
+EXPORT_SYMBOL_GPL(ata_link_mp_header);
+EXPORT_SYMBOL_GPL(ata_dev_mp_header);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_std_ports);
 EXPORT_SYMBOL_GPL(ata_host_init);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 21a81cd..ee2dcea 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1786,17 +1786,12 @@ static void ata_eh_link_report(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
-	const char *frozen, *desc;
-	char tries_buf[6];
+	struct mprintk mp = MPRINTK_INITIALIZER(ap->sector_buf, ATA_SECT_SIZE);
 	int tag, nr_failed = 0;
 
 	if (ehc->i.flags & ATA_EHI_QUIET)
 		return;
 
-	desc = NULL;
-	if (ehc->i.desc[0] != '\0')
-		desc = ehc->i.desc;
-
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
@@ -1813,33 +1808,25 @@ static void ata_eh_link_report(struct ata_link *link)
 	if (!nr_failed && !ehc->i.err_mask)
 		return;
 
-	frozen = "";
-	if (ap->pflags & ATA_PFLAG_FROZEN)
-		frozen = " frozen";
+	if (ehc->i.dev)
+		ata_dev_mp_header(ehc->i.dev, KERN_ERR, &mp);
+	else
+		ata_link_mp_header(link, KERN_ERR, &mp);
 
-	memset(tries_buf, 0, sizeof(tries_buf));
+	mprintk_push(&mp, "exception Emask 0x%x SAct 0x%x SErr 0x%x action 0x%x",
+		     ehc->i.err_mask, link->sactive, ehc->i.serror,
+		     ehc->i.action);
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		mprintk_push(&mp, " frozen");
 	if (ap->eh_tries < ATA_EH_MAX_TRIES)
-		snprintf(tries_buf, sizeof(tries_buf) - 1, " t%d",
-			 ap->eh_tries);
+		mprintk_push(&mp, " t%d", ap->eh_tries);
+	mprintk_push(&mp, "\n");
 
-	if (ehc->i.dev) {
-		ata_dev_printk(ehc->i.dev, KERN_ERR, "exception Emask 0x%x "
-			       "SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-			       ehc->i.err_mask, link->sactive, ehc->i.serror,
-			       ehc->i.action, frozen, tries_buf);
-		if (desc)
-			ata_dev_printk(ehc->i.dev, KERN_ERR, "%s\n", desc);
-	} else {
-		ata_link_printk(link, KERN_ERR, "exception Emask 0x%x "
-				"SAct 0x%x SErr 0x%x action 0x%x%s%s\n",
-				ehc->i.err_mask, link->sactive, ehc->i.serror,
-				ehc->i.action, frozen, tries_buf);
-		if (desc)
-			ata_link_printk(link, KERN_ERR, "%s\n", desc);
-	}
+	if (ehc->i.desc[0] != '\0')
+		mprintk_push(&mp, "%s\n", ehc->i.desc);
 
 	if (ehc->i.serror)
-		ata_port_printk(ap, KERN_ERR,
+		mprintk_push(&mp,
 		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
 		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
 		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
@@ -1859,85 +1846,90 @@ static void ata_eh_link_report(struct ata_link *link)
 		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
 		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
 
+	mprintk(&mp, NULL); /* flush link / device wide messages */
+
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
+		static const char *dma_str[] = {
+			[DMA_BIDIRECTIONAL]	= "bidi",
+			[DMA_TO_DEVICE]		= "out",
+			[DMA_FROM_DEVICE]	= "in",
+		};
+		static const char *prot_str[] = {
+			[ATA_PROT_PIO]		= "pio",
+			[ATA_PROT_DMA]		= "dma",
+			[ATA_PROT_NCQ]		= "ncq",
+			[ATA_PROT_ATAPI]	= "pio",
+			[ATA_PROT_ATAPI_DMA]	= "dma",
+		};
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
 		const u8 *cdb = qc->cdb;
-		char data_buf[20] = "";
-		char cdb_buf[70] = "";
+		int need_newline = 0;
 
 		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
 		    qc->dev->link != link || !qc->err_mask)
 			continue;
 
-		if (qc->dma_dir != DMA_NONE) {
-			static const char *dma_str[] = {
-				[DMA_BIDIRECTIONAL]	= "bidi",
-				[DMA_TO_DEVICE]		= "out",
-				[DMA_FROM_DEVICE]	= "in",
-			};
-			static const char *prot_str[] = {
-				[ATA_PROT_PIO]		= "pio",
-				[ATA_PROT_DMA]		= "dma",
-				[ATA_PROT_NCQ]		= "ncq",
-				[ATA_PROT_ATAPI]	= "pio",
-				[ATA_PROT_ATAPI_DMA]	= "dma",
-			};
-
-			snprintf(data_buf, sizeof(data_buf), " %s %u %s",
-				 prot_str[qc->tf.protocol], qc->nbytes,
-				 dma_str[qc->dma_dir]);
-		}
+		mprintk_push(&mp, "cmd %02x/%02x:%02x:%02x:%02x:%02x/"
+			     "%02x:%02x:%02x:%02x:%02x/%02x tag %d",
+			     cmd->command, cmd->feature, cmd->nsect,
+			     cmd->lbal, cmd->lbam, cmd->lbah,
+			     cmd->hob_feature, cmd->hob_nsect,
+			     cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
+			     cmd->device, qc->tag);
+
+		if (qc->dma_dir != DMA_NONE)
+			mprintk_push(&mp, " %s %u %s",
+				     prot_str[qc->tf.protocol],
+				     qc->nbytes, dma_str[qc->dma_dir]);
+		mprintk_push(&mp, "\n");
 
 		if (is_atapi_taskfile(&qc->tf))
-			snprintf(cdb_buf, sizeof(cdb_buf),
-				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
-				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
-				 cdb[0], cdb[1], cdb[2], cdb[3],
-				 cdb[4], cdb[5], cdb[6], cdb[7],
-				 cdb[8], cdb[9], cdb[10], cdb[11],
-				 cdb[12], cdb[13], cdb[14], cdb[15]);
-
-		ata_dev_printk(qc->dev, KERN_ERR,
-			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
-			"tag %d%s\n         %s"
-			"res %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
-			"Emask 0x%x (%s)%s\n",
-			cmd->command, cmd->feature, cmd->nsect,
-			cmd->lbal, cmd->lbam, cmd->lbah,
-			cmd->hob_feature, cmd->hob_nsect,
-			cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
-			cmd->device, qc->tag, data_buf, cdb_buf,
-			res->command, res->feature, res->nsect,
-			res->lbal, res->lbam, res->lbah,
-			res->hob_feature, res->hob_nsect,
-			res->hob_lbal, res->hob_lbam, res->hob_lbah,
-			res->device, qc->err_mask, ata_err_string(qc->err_mask),
-			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
+			mprintk_push(&mp, "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
+				     "%02x %02x %02x %02x %02x %02x %02x %02x\n",
+				     cdb[0], cdb[1], cdb[2], cdb[3],
+				     cdb[4], cdb[5], cdb[6], cdb[7],
+				     cdb[8], cdb[9], cdb[10], cdb[11],
+				     cdb[12], cdb[13], cdb[14], cdb[15]);
+
+		mprintk_push(&mp, "res %02x/%02x:%02x:%02x:%02x:%02x/"
+			     "%02x:%02x:%02x:%02x:%02x/%02x Emask 0x%x (%s)%s\n",
+			     res->command, res->feature, res->nsect,
+			     res->lbal, res->lbam, res->lbah,
+			     res->hob_feature, res->hob_nsect,
+			     res->hob_lbal, res->hob_lbam, res->hob_lbah,
+			     res->device, qc->err_mask,
+			     ata_err_string(qc->err_mask),
+			     qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
 
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
 				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { Busy }\n");
+				mprintk_push(&mp, "status: { Busy } ");
 			else
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { %s%s%s%s}\n",
+				mprintk_push(&mp, "status: { %s%s%s%s} ",
 				  res->command & ATA_DRDY ? "DRDY " : "",
 				  res->command & ATA_DF ? "DF " : "",
 				  res->command & ATA_DRQ ? "DRQ " : "",
 				  res->command & ATA_ERR ? "ERR " : "");
+			need_newline = 1;
 		}
 
 		if (cmd->command != ATA_CMD_PACKET &&
 		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
-				     ATA_ABORTED)))
-			ata_dev_printk(qc->dev, KERN_ERR,
-			  "error: { %s%s%s%s}\n",
+				     ATA_ABORTED))) {
+			mprintk_push(&mp, "error: { %s%s%s%s}",
 			  res->feature & ATA_ICRC ? "ICRC " : "",
 			  res->feature & ATA_UNC ? "UNC " : "",
 			  res->feature & ATA_IDNF ? "IDNF " : "",
 			  res->feature & ATA_ABORTED ? "ABRT " : "");
+			need_newline = 1;
+		}
+
+		if (need_newline)
+			mprintk(&mp, "\n");
+		else
+			mprintk(&mp, NULL);
 	}
 }
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index caef2bb..80bfa50 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -408,9 +408,8 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 
 		if (!(dev->flags & ATA_DFLAG_AN))
 			ata_dev_printk(dev, KERN_INFO,
-				"Asynchronous notification not supported, "
-				"hotplug won't\n         work on fan-out "
-				"ports. Use warm-plug instead.\n");
+			"Asynchronous notification not supported, hotplug won't\n"
+			"work on fan-out ports. Use warm-plug instead.\n");
 	}
 
 	return 0;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 264ae60..7c13663 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3207,9 +3207,9 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			goto repeat;
 		}
 
-		ata_port_printk(ap, KERN_ERR, "WARNING: synchronous SCSI scan "
-				"failed without making any progress,\n"
-				"                  switching to async\n");
+		ata_port_printk(ap, KERN_ERR,
+		"WARNING: synchronous SCSI scan failed without making any \n"
+		"         progress, switching to async\n");
 	}
 
 	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 323c087..c45bd38 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -502,7 +502,7 @@ static void inic_dev_config(struct ata_device *dev)
 	if (dev->n_sectors >= 1 << 28) {
 		ata_dev_printk(dev, KERN_ERR,
 	"ERROR: This driver doesn't support LBA48 yet and may cause\n"
-	"                data corruption on such devices.  Disabling.\n");
+	"       data corruption on such devices.  Disabling.\n");
 		ata_dev_disable(dev);
 	}
 }
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5dc7c..7874f61 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1788,8 +1788,8 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
 			"EH in SWNCQ mode,QC:qc_active 0x%X sactive 0x%X\n",
 			ap->qc_active, ap->link.sactive);
 	ata_port_printk(ap, KERN_ERR,
-		"SWNCQ:qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n  "
-		"dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
+		"SWNCQ: qc_active 0x%X defer_bits 0x%X last_issue_tag 0x%x\n"
+		"       dhfis 0x%X dmafis 0x%X sdbfis 0x%X\n",
 		pp->qc_active, pp->defer_queue.defer_bits, pp->last_issue_tag,
 		pp->dhfis_bits, pp->dmafis_bits, pp->sdbfis_bits);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 124033c..c31ea05 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -773,6 +773,23 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 	return ap->ops == &ata_dummy_port_ops;
 }
 
+extern int ata_port_printk(struct ata_port *ap, const char *lv,
+			   const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int ata_link_printk(struct ata_link *link, const char *lv,
+			   const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+extern int ata_dev_printk(struct ata_device *dev, const char *lv,
+			  const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4)));
+
+extern void ata_port_mp_header(struct ata_port *ap, const char *lv,
+			       struct mprintk *mp);
+extern void ata_link_mp_header(struct ata_link *link, const char *lv,
+			       struct mprintk *mp);
+extern void ata_dev_mp_header(struct ata_device *dev, const char *lv,
+			      struct mprintk *mp);
+
 extern void sata_print_link_status(struct ata_link *link);
 extern void ata_port_probe(struct ata_port *);
 extern void ata_bus_reset(struct ata_port *ap);
@@ -1023,24 +1040,6 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 		      ata_postreset_fn_t postreset);
 
 /*
- * printk helpers
- */
-#define ata_port_printk(ap, lv, fmt, args...) \
-	printk("%sata%u: "fmt, lv, (ap)->print_id , ##args)
-
-#define ata_link_printk(link, lv, fmt, args...) do { \
-	if ((link)->ap->nr_pmp_links) \
-		printk("%sata%u.%02u: "fmt, lv, (link)->ap->print_id,	\
-		       (link)->pmp , ##args); \
-	else \
-		printk("%sata%u: "fmt, lv, (link)->ap->print_id , ##args); \
-	} while(0)
-
-#define ata_dev_printk(dev, lv, fmt, args...) \
-	printk("%sata%u.%02u: "fmt, lv, (dev)->link->ap->print_id,	\
-	       (dev)->link->pmp + (dev)->devno , ##args)
-
-/*
  * ata_eh_info helpers
  */
 extern void __ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...)
-- 
1.5.2.4

