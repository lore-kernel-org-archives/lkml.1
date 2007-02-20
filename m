Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXBTB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXBTB0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXBTB0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:26:20 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:64134 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794AbXBTB0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:26:14 -0500
Date: Mon, 19 Feb 2007 19:25:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH RFC] libata: FUA updates
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Message-id: <45DA4E13.10700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updates libata FUA support to be more more in line with reality.
FUA support remains off by default.

Add a setting for the fua command-line parameter on libata which enables
FUA only on NCQ-supporting disks.

Update the ata_dev_supports_fua function to remove the blacklisting of
Maxtor BANC1G10 firmware, as there is no conclusive evidence it was ever
needed.

Centralize all of the FUA on/off decisions in this function.

Bypass the checks for FUA command support bit for NCQ disks, since that
bit only applies to non-NCQ FUA, and FUA is part of the spec for NCQ
commands.

When queue depth is set by the user resulting in enabling/disabling
NCQ, trigger a revalidate so that the FUA state will be rechecked,
since disabling/enabling NCQ may also affect FUA support on some disks.

Add a controller flag to indicate it doesn't support FUA commands, and
set this flag for Silicon Image 311x (since that one is known to have
problems) as well as for ITE821x when in smart mode.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

---

Any comments on this version? It's essentially what I posted previously
in "libata FUA revisited", except that the default for FUA support remains
off, so this shouldn't break anything for anyone that doesn't explicitly
enable it.

diff -urp linux-2.6.20-git6/drivers/ata/libata-core.c linux-2.6.20-git6edit/drivers/ata/libata-core.c
--- linux-2.6.20-git6/drivers/ata/libata-core.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/libata-core.c	2007-02-19 16:55:49.000000000 -0600
@@ -87,7 +87,7 @@ MODULE_PARM_DESC(atapi_dmadir, "Enable A
 
 int libata_fua = 0;
 module_param_named(fua, libata_fua, int, 0444);
-MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
+MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on for NCQ drives only, 2=on)");
 
 static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
diff -urp linux-2.6.20-git6/drivers/ata/libata-scsi.c linux-2.6.20-git6edit/drivers/ata/libata-scsi.c
--- linux-2.6.20-git6/drivers/ata/libata-scsi.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/libata-scsi.c	2007-02-19 16:47:46.000000000 -0600
@@ -986,7 +986,7 @@ int ata_scsi_change_queue_depth(struct s
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev;
 	unsigned long flags;
-	int max_depth;
+	int max_depth, revalidate;
 
 	if (queue_depth < 1)
 		return sdev->queue_depth;
@@ -1003,10 +1003,22 @@ int ata_scsi_change_queue_depth(struct s
 	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
 
 	spin_lock_irqsave(ap->lock, flags);
-	if (queue_depth > 1)
+	if (queue_depth > 1 && (dev->flags & ATA_DFLAG_NCQ_OFF)) {
 		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
-	else
+		revalidate = 1;
+	} else if(!(dev->flags & ATA_DFLAG_NCQ_OFF)) {
 		dev->flags |= ATA_DFLAG_NCQ_OFF;
+		revalidate = 1;
+	}
+	/* Note: NCQ is switched off if queue depth is set to 1.
+	   Thus changing the depth may also enable/disable FUA,
+	   which the SCSI layer needs to know about, so we trigger
+	   a revalidate. */
+	if(revalidate) {
+		ap->eh_info.action |= ATA_EH_REVALIDATE;
+		ata_port_schedule_eh(ap);
+	}
+
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	return queue_depth;
@@ -1990,27 +2002,46 @@ static unsigned int ata_msense_rw_recove
 }
 
 /*
- * We can turn this into a real blacklist if it's needed, for now just
- * blacklist any Maxtor BANC1G10 revision firmware
+ *	ata_dev_supports_fua - Determine if this device supports FUA.
+ *	@dev: Device to check
+ *
+ *	Determine if this device supports FUA based on drive and
+ *	controller capabilities.
+ *
+ *	LOCKING:
+ *	None.
  */
-static int ata_dev_supports_fua(u16 *id)
+static int ata_dev_supports_fua(struct ata_device* dev)
 {
-	unsigned char model[ATA_ID_PROD_LEN + 1], fw[ATA_ID_FW_REV_LEN + 1];
-
+	/* Is FUA completely disabled? */
 	if (!libata_fua)
 		return 0;
-	if (!ata_id_has_fua(id))
+		
+	/* Does the drive support FUA?
+	   NCQ-enabled drives always support FUA, otherwise
+	   check if the drive indicates support for FUA commands. */
+	if((dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
+			  ATA_DFLAG_NCQ)) != ATA_DFLAG_NCQ) {
+		if(libata_fua == 1)
+			/* FUA enabled only for NCQ */
+			return 0;
+	
+		/* Does the drive support FUA commands? */
+		if (!(dev->flags & ATA_DFLAG_LBA48) ||
+		    !ata_id_has_fua(dev->id))
+			return 0;
+		
+		/* Can't use FUA if we can only use PIO and can't use
+		   WRITE MULTIPLE FUA EXT */
+		if((dev->flags & ATA_DFLAG_PIO) && !dev->multi_count)
+			return 0;
+	}
+	   
+	/* Does the controller support FUA? */
+	if(dev->ap->flags & ATA_FLAG_NO_FUA)
 		return 0;
-
-	ata_id_c_string(id, model, ATA_ID_PROD, sizeof(model));
-	ata_id_c_string(id, fw, ATA_ID_FW_REV, sizeof(fw));
-
-	if (strcmp(model, "Maxtor"))
-		return 1;
-	if (strcmp(fw, "BANC1G10"))
-		return 1;
-
-	return 0; /* blacklisted */
+	
+	return 1;
 }
 
 /**
@@ -2030,7 +2061,6 @@ static int ata_dev_supports_fua(u16 *id)
 unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
 				  unsigned int buflen)
 {
-	struct ata_device *dev = args->dev;
 	u8 *scsicmd = args->cmd->cmnd, *p, *last;
 	const u8 sat_blk_desc[] = {
 		0, 0, 0, 0,	/* number of blocks: sat unspecified */
@@ -2110,8 +2140,7 @@ unsigned int ata_scsiop_mode_sense(struc
 		return 0;
 
 	dpofua = 0;
-	if (ata_dev_supports_fua(args->id) && (dev->flags & ATA_DFLAG_LBA48) &&
-	    (!(dev->flags & ATA_DFLAG_PIO) || dev->multi_count))
+	if (ata_dev_supports_fua(args->dev))
 		dpofua = 1 << 4;
 
 	if (six_byte) {
diff -urp linux-2.6.20-git6/drivers/ata/pata_it821x.c linux-2.6.20-git6edit/drivers/ata/pata_it821x.c
--- linux-2.6.20-git6/drivers/ata/pata_it821x.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/pata_it821x.c	2007-02-11 21:55:38.000000000 -0600
@@ -525,8 +525,7 @@ static int it821x_smart_set_mode(struct 
  *	special. In our case we need to lock the sector count to avoid
  *	blowing the brains out of the firmware with large LBA48 requests
  *
- *	FIXME: When FUA appears we need to block FUA too. And SMART and
- *	basically we need to filter commands for this chip.
+ *	FIXME: We need to filter commands for this chip (ex: SMART)
  */
 
 static void it821x_dev_config(struct ata_port *ap, struct ata_device *adev)
@@ -744,7 +743,7 @@ static int it821x_init_one(struct pci_de
 
 	static struct ata_port_info info_smart = {
 		.sht = &it821x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_NO_FUA,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &it821x_smart_port_ops
diff -urp linux-2.6.20-git6/drivers/ata/sata_sil.c linux-2.6.20-git6edit/drivers/ata/sata_sil.c
--- linux-2.6.20-git6/drivers/ata/sata_sil.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_sil.c	2007-02-11 21:54:33.000000000 -0600
@@ -59,7 +59,9 @@ enum {
 	SIL_FLAG_MOD15WRITE	= (1 << 30),
 
 	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_HRST_TO_RESUME,
+				  ATA_FLAG_MMIO | ATA_FLAG_HRST_TO_RESUME |
+				/* See http://bugzilla.kernel.org/show_bug.cgi?id=5914 */
+				  ATA_FLAG_NO_FUA,
 
 	/*
 	 * Controller IDs
--- linux-2.6.20-git14/include/linux/libata.h	2007-02-19 16:51:23.000000000 -0600
+++ linux-2.6.20-git14edit/include/linux/libata.h	2007-02-19 17:47:25.000000000 -0600
@@ -173,7 +173,8 @@ enum {
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 	ATA_FLAG_NO_IORDY	= (1 << 16), /* controller lacks iordy */
-
+	ATA_FLAG_NO_FUA		= (1 << 17), /* doesn't support FUA commands */
+ 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
 	 * removed in not-too-distant future.

