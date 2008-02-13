Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbYBMJM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbYBMJM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbYBMJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:10:19 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:45852 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYBMJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ebUMHMUTPKw5wHzwO5wD3YPfX9K2XVAELTfWiloD4UkGRm68m8c2tJi+B++T4FukAcAR6Ki3yGNP5YSl+OecdArii8oumMPt6035sJKoizf6nsaqKkX0VeNfDwsPbmYcLXiOcIrA6LdrxW/2gClIUp2FGuhCB59hGYUrwDw4KJY=
From: Tejun Heo <htejun@gmail.com>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 5/5] libata: make libata use printk_header() and mprintk
Date: Wed, 13 Feb 2008 18:09:33 +0900
Message-Id: <12028937743798-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12028937731333-git-send-email-htejun@gmail.com>
References: <12028937731333-git-send-email-htejun@gmail.com>
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
 drivers/ata/libata-core.c   |  204 +++++++++++++++++++++++++++----------------
 drivers/ata/libata-eh.c     |  182 ++++++++++++++++++--------------------
 drivers/ata/libata-pmp.c    |    5 +-
 drivers/ata/libata-scsi.c   |    6 +-
 drivers/ata/sata_inic162x.c |    2 +-
 drivers/ata/sata_nv.c       |    4 +-
 include/linux/libata.h      |   35 ++++----
 7 files changed, 237 insertions(+), 201 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 004dae4..da670c0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -129,6 +129,79 @@ MODULE_LICENSE("GPL");
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
@@ -2006,18 +2079,16 @@ static inline u8 ata_dev_knobble(struct ata_device *dev)
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
+		mprintk(mp, ", NCQ (not used)");
 		return;
 	}
 	if (ap->flags & ATA_FLAG_NCQ) {
@@ -2026,9 +2097,9 @@ static void ata_dev_config_ncq(struct ata_device *dev,
 	}
 
 	if (hdepth >= ddepth)
-		snprintf(desc, desc_sz, "NCQ (depth %d)", ddepth);
+		mprintk(mp, ", NCQ (depth %d)", ddepth);
 	else
-		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
+		mprintk(mp, ", NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
 /**
@@ -2050,8 +2121,8 @@ int ata_dev_configure(struct ata_device *dev)
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	const u16 *id = dev->id;
+	struct mprintk mp = MPRINTK_INITIALIZER(ap->sector_buf, ATA_SECT_SIZE);
 	unsigned long xfer_mask;
-	char revbuf[7];		/* XYZ-99\0 */
 	char fwrevbuf[ATA_ID_FW_REV_LEN+1];
 	char modelbuf[ATA_ID_PROD_LEN+1];
 	int rc;
@@ -2065,6 +2136,8 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
+	ata_dev_mp_header(dev, KERN_INFO, &mp);
+
 	/* set horkage */
 	dev->horkage |= ata_dev_blacklisted(dev);
 
@@ -2113,57 +2186,49 @@ int ata_dev_configure(struct ata_device *dev)
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
+			mprintk(&mp, "CFA: ");
 		} else {
-			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
+			mprintk(&mp, "ATA-%d: ", ata_id_major_version(id));
 			/* Warn the user if the device has TPM extensions */
-			if (ata_id_has_tpm(id))
+			if (ata_id_has_tpm(id) && print_info)
 				ata_dev_printk(dev, KERN_WARNING,
 					       "supports DRM functions and may "
 					       "not be fully accessable.\n");
 		}
 
+		mprintk(&mp, "%s, %s, max %s\n",
+			modelbuf, fwrevbuf, ata_mode_string(xfer_mask));
+
 		dev->n_sectors = ata_id_n_sectors(id);
+		mprintk(&mp, "%Lu sectors", (unsigned long long)dev->n_sectors);
 
-		if (dev->id[59] & 0x100)
+		if (dev->id[59] & 0x100) {
 			dev->multi_count = dev->id[59] & 0xff;
+			mprintk(&mp, ", multi %u", dev->multi_count);
+		}
 
 		if (ata_id_has_lba(id)) {
-			const char *lba_desc;
-			char ncq_desc[20];
-
-			lba_desc = "LBA";
 			dev->flags |= ATA_DFLAG_LBA;
+			mprintk(&mp, ", LBA");
+
 			if (ata_id_has_lba48(id)) {
 				dev->flags |= ATA_DFLAG_LBA48;
-				lba_desc = "LBA48";
-
+				mprintk(&mp, "48");
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
 
@@ -2179,27 +2244,13 @@ int ata_dev_configure(struct ata_device *dev)
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
+			mprintk(&mp, ", CHS %u/%u/%u",
+				dev->cylinders, dev->heads, dev->sectors);
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
@@ -2212,6 +2263,14 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 		dev->cdb_len = (unsigned int) rc;
 
+		mprintk(&mp, "ATAPI: %s, %s, max %s", modelbuf, fwrevbuf,
+			ata_mode_string(xfer_mask));
+
+		if (ata_id_cdb_intr(dev->id)) {
+			dev->flags |= ATA_DFLAG_CDB_INTR;
+			mprintk(&mp, ", CDB intr");
+		}
+
 		/* Enable ATAPI AN if both the host and device have
 		 * the support.  If PMP is attached, SNTF is required
 		 * to enable ATAPI AN to discern between PHY status
@@ -2231,22 +2290,9 @@ int ata_dev_configure(struct ata_device *dev)
 					"(err_mask=0x%x)\n", err_mask);
 			else {
 				dev->flags |= ATA_DFLAG_AN;
-				atapi_an_string = ", ATAPI AN";
+				mprintk(&mp, ", ATAPI AN");
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
@@ -2264,9 +2310,7 @@ int ata_dev_configure(struct ata_device *dev)
 	/* Limit PATA drive on SATA cable bridge transfers to udma5,
 	   200 sectors */
 	if (ata_dev_knobble(dev)) {
-		if (ata_msg_drv(ap) && print_info)
-			ata_dev_printk(dev, KERN_INFO,
-				       "applying bridge limits\n");
+		mprintk(&mp, ", applying bridge limits");
 		dev->udma_mask &= ATA_UDMA5;
 		dev->max_sectors = ATA_MAX_SECTORS;
 	}
@@ -2291,21 +2335,21 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
-	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
+	if ((dev->horkage & ATA_HORKAGE_DIAGNOSTIC) && print_info) {
 		/* Let the user know. We don't want to disallow opens for
 		   rescue purposes, or in case the vendor is just a blithering
 		   idiot. Do this after the dev_config call as some controllers
 		   with buggy firmware may want to avoid reporting false device
 		   bugs */
-
-		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
-"Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
-"fault or invalid emulation. Contact drive vendor for information.\n");
-		}
+		ata_dev_printk(dev, KERN_WARNING,
+		  "Drive reports diagnostics failure. This may indicate a drive\n"
+		  "fault or invalid emulation. Contact drive vendor for information.\n");
 	}
 
+	/* print device info to dmesg */
+	if (ata_msg_drv(ap) && print_info)
+		mprintk_flush(&mp, "\n");
+
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
 			__FUNCTION__, ata_chk_status(ap));
@@ -7544,6 +7588,12 @@ EXPORT_SYMBOL_GPL(sata_deb_timing_hotplug);
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
index 4e31071..2af7755 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1884,17 +1884,12 @@ static void ata_eh_link_report(struct ata_link *link)
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
 
@@ -1911,101 +1906,89 @@ static void ata_eh_link_report(struct ata_link *link)
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
+	mprintk(&mp, "exception Emask 0x%x SAct 0x%x SErr 0x%x action 0x%x",
+		ehc->i.err_mask, link->sactive, ehc->i.serror, ehc->i.action);
+	if (ap->pflags & ATA_PFLAG_FROZEN)
+		mprintk(&mp, " frozen");
 	if (ap->eh_tries < ATA_EH_MAX_TRIES)
-		snprintf(tries_buf, sizeof(tries_buf) - 1, " t%d",
-			 ap->eh_tries);
+		mprintk(&mp, " t%d", ap->eh_tries);
+	mprintk(&mp, "\n");
 
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
+		mprintk(&mp, "%s\n", ehc->i.desc);
 
 	if (ehc->i.serror)
-		ata_port_printk(ap, KERN_ERR,
-		  "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
-		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
-		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
-		  ehc->i.serror & SERR_DATA ? "UnrecovData " : "",
-		  ehc->i.serror & SERR_PERSISTENT ? "Persist " : "",
-		  ehc->i.serror & SERR_PROTOCOL ? "Proto " : "",
-		  ehc->i.serror & SERR_INTERNAL ? "HostInt " : "",
-		  ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
-		  ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInt " : "",
-		  ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
-		  ehc->i.serror & SERR_10B_8B_ERR ? "10B8B " : "",
-		  ehc->i.serror & SERR_DISPARITY ? "Dispar " : "",
-		  ehc->i.serror & SERR_CRC ? "BadCRC " : "",
-		  ehc->i.serror & SERR_HANDSHAKE ? "Handshk " : "",
-		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeq " : "",
-		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
-		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
-		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
+		mprintk(&mp, "SError: { %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
+			ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
+			ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
+			ehc->i.serror & SERR_DATA ? "UnrecovData " : "",
+			ehc->i.serror & SERR_PERSISTENT ? "Persist " : "",
+			ehc->i.serror & SERR_PROTOCOL ? "Proto " : "",
+			ehc->i.serror & SERR_INTERNAL ? "HostInt " : "",
+			ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
+			ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInt " : "",
+			ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
+			ehc->i.serror & SERR_10B_8B_ERR ? "10B8B " : "",
+			ehc->i.serror & SERR_DISPARITY ? "Dispar " : "",
+			ehc->i.serror & SERR_CRC ? "BadCRC " : "",
+			ehc->i.serror & SERR_HANDSHAKE ? "Handshk " : "",
+			ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeq " : "",
+			ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
+			ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
+			ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
+
+	mprintk_flush(&mp, NULL); /* flush link / device wide messages */
 
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
+			[ATAPI_PROT_PIO]	= "pio",
+			[ATAPI_PROT_DMA]	= "dma",
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
-				[ATAPI_PROT_PIO]	= "pio",
-				[ATAPI_PROT_DMA]	= "dma",
-			};
-
-			snprintf(data_buf, sizeof(data_buf), " %s %u %s",
-				 prot_str[qc->tf.protocol], qc->nbytes,
-				 dma_str[qc->dma_dir]);
-		}
-
-		if (ata_is_atapi(qc->tf.protocol))
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
+		mprintk(&mp, "cmd %02x/%02x:%02x:%02x:%02x:%02x/"
+			"%02x:%02x:%02x:%02x:%02x/%02x tag %d",
 			cmd->command, cmd->feature, cmd->nsect,
 			cmd->lbal, cmd->lbam, cmd->lbah,
 			cmd->hob_feature, cmd->hob_nsect,
 			cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
-			cmd->device, qc->tag, data_buf, cdb_buf,
+			cmd->device, qc->tag);
+
+		if (qc->dma_dir != DMA_NONE)
+			mprintk(&mp, " %s %u %s", prot_str[qc->tf.protocol],
+				qc->nbytes, dma_str[qc->dma_dir]);
+		mprintk(&mp, "\n");
+
+		if (ata_is_atapi(qc->tf.protocol))
+			mprintk(&mp, "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
+				"%02x %02x %02x %02x %02x %02x %02x %02x\n",
+				cdb[0], cdb[1], cdb[2], cdb[3],
+				cdb[4], cdb[5], cdb[6], cdb[7],
+				cdb[8], cdb[9], cdb[10], cdb[11],
+				cdb[12], cdb[13], cdb[14], cdb[15]);
+
+		mprintk(&mp, "res %02x/%02x:%02x:%02x:%02x:%02x/"
+			"%02x:%02x:%02x:%02x:%02x/%02x Emask 0x%x (%s)%s\n",
 			res->command, res->feature, res->nsect,
 			res->lbal, res->lbam, res->lbah,
 			res->hob_feature, res->hob_nsect,
@@ -2016,26 +1999,31 @@ static void ata_eh_link_report(struct ata_link *link)
 		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
 				    ATA_ERR)) {
 			if (res->command & ATA_BUSY)
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { Busy }\n");
+				mprintk(&mp, "status: { Busy } ");
 			else
-				ata_dev_printk(qc->dev, KERN_ERR,
-				  "status: { %s%s%s%s}\n",
-				  res->command & ATA_DRDY ? "DRDY " : "",
-				  res->command & ATA_DF ? "DF " : "",
-				  res->command & ATA_DRQ ? "DRQ " : "",
-				  res->command & ATA_ERR ? "ERR " : "");
+				mprintk(&mp, "status: { %s%s%s%s} ",
+					res->command & ATA_DRDY ? "DRDY " : "",
+					res->command & ATA_DF ? "DF " : "",
+					res->command & ATA_DRQ ? "DRQ " : "",
+					res->command & ATA_ERR ? "ERR " : "");
+			need_newline = 1;
 		}
 
 		if (cmd->command != ATA_CMD_PACKET &&
 		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
-				     ATA_ABORTED)))
-			ata_dev_printk(qc->dev, KERN_ERR,
-			  "error: { %s%s%s%s}\n",
-			  res->feature & ATA_ICRC ? "ICRC " : "",
-			  res->feature & ATA_UNC ? "UNC " : "",
-			  res->feature & ATA_IDNF ? "IDNF " : "",
-			  res->feature & ATA_ABORTED ? "ABRT " : "");
+				     ATA_ABORTED))) {
+			mprintk(&mp, "error: { %s%s%s%s}",
+				res->feature & ATA_ICRC ? "ICRC " : "",
+				res->feature & ATA_UNC ? "UNC " : "",
+				res->feature & ATA_IDNF ? "IDNF " : "",
+				res->feature & ATA_ABORTED ? "ABRT " : "");
+			need_newline = 1;
+		}
+
+		if (need_newline)
+			mprintk_flush(&mp, "\n");
+		else
+			mprintk_flush(&mp, NULL);
 	}
 }
 
diff --git a/drivers/ata/libata-pmp.c b/drivers/ata/libata-pmp.c
index caef2bb..cc6e4ca 100644
--- a/drivers/ata/libata-pmp.c
+++ b/drivers/ata/libata-pmp.c
@@ -408,9 +408,8 @@ static int sata_pmp_configure(struct ata_device *dev, int print_info)
 
 		if (!(dev->flags & ATA_DFLAG_AN))
 			ata_dev_printk(dev, KERN_INFO,
-				"Asynchronous notification not supported, "
-				"hotplug won't\n         work on fan-out "
-				"ports. Use warm-plug instead.\n");
+			  "Asynchronous notification not supported, hotplug won't\n"
+			  "work on fan-out ports. Use warm-plug instead.\n");
 	}
 
 	return 0;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c02c490..bcf0a3d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3234,9 +3234,9 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			goto repeat;
 		}
 
-		ata_port_printk(ap, KERN_ERR, "WARNING: synchronous SCSI scan "
-				"failed without making any progress,\n"
-				"                  switching to async\n");
+		ata_port_printk(ap, KERN_ERR,
+		  "WARNING: synchronous SCSI scan failed without making any \n"
+		  "         progress, switching to async\n");
 	}
 
 	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 59e65ed..4ba8534 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -491,7 +491,7 @@ static void inic_dev_config(struct ata_device *dev)
 	if (dev->n_sectors >= 1 << 28) {
 		ata_dev_printk(dev, KERN_ERR,
 	"ERROR: This driver doesn't support LBA48 yet and may cause\n"
-	"                data corruption on such devices.  Disabling.\n");
+	"       data corruption on such devices.  Disabling.\n");
 		ata_dev_disable(dev);
 	}
 }
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5473b..85bcfca 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1849,8 +1849,8 @@ static void nv_swncq_ncq_stop(struct ata_port *ap)
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
index bc5a8d0..168170c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -787,6 +787,23 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
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
@@ -1074,24 +1091,6 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
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

