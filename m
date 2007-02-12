Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXBLFsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXBLFsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXBLFsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:48:04 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:40305 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbXBLFsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:48:03 -0500
Date: Sun, 11 Feb 2007 23:47:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libata FUA revisited
In-reply-to: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Cc: edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net, htejun@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-id: <45CFFF82.4030301@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Given the above, what I'm proposing to do is:
> 
> -Remove the blacklisting of Maxtor BANC1G10 firmware for FUA. If we need 
> to FUA-blacklist any drives this should likely be added to the existing 
> "horkage" mechanism we now have. However, at this point I don't think 
> that's needed, considering that I've seen no conclusive evidence that 
> any drive has ever been established to have broken FUA.
> 
> -Add a new port flag ATA_FLAG_NO_FUA to indicate that a controller can't 
> handle FUA commands, and add that flag to sata_sil. Force FUA off on any 
> drive connected to a controller with this bit set.
> 
> There was some talk that sata_mv might have this problem, but I believe 
> the conclusion was that it didn't. The only controllers that would are 
> ones that actually try to interpret the ATA command codes and don't know 
> about WRITE DMA FUA.
> 
> -Change the fua module option to control FUA enable/disable to have a 
> third value, "enable for NCQ-supporting drives only", which would become 
> the new default. That case seems less likely to cause problems since FUA 
> on NCQ is just another bit in the command whereas FUA on non-NCQ is an 
> entirely different, potentially unsupported command.

OK, here's what I've got to implement the above, and a few other things -
not submitted for inclusion yet as I'd like to get a few comments.

This centralizes the logic in one place for deciding whether to use FUA
or not. It also modifies the logic to account for the fact that when
NCQ is enabled we should always be able to use FUA, since it's inherent
in the definition of the NCQ commands. Since enabling and disabling NCQ
can thus also enable/disable FUA (if the drive doesn't support non-NCQ
FUA) we need to revalidate the device when doing this on change_queue_depth
so that the SCSI layer sees the change.

(I tried to test this, but wasn't able to actually change the queue depth
using the /sys/block/sda/device/queue_depth file. The queue_depth attribute
started out as r--r--r--, I tried chmod u+w and writing it but just got an
"Input/output error". Did somebody break or disable this functionality?)

Also, as well as setting ATA_FLAG_NO_FUA in sata_sil it appears that
pata_it821x also needs FUA disabled when in smart mode as the firmware can't
handle that command.

diff -rup linux-2.6.20-git6/drivers/ata/libata-core.c linux-2.6.20-git6edit/drivers/ata/libata-core.c
--- linux-2.6.20-git6/drivers/ata/libata-core.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/libata-core.c	2007-02-11 21:43:11.000000000 -0600
@@ -85,9 +85,9 @@ int atapi_dmadir = 0;
 module_param(atapi_dmadir, int, 0444);
 MODULE_PARM_DESC(atapi_dmadir, "Enable ATAPI DMADIR bridge support (0=off, 1=on)");
 
-int libata_fua = 0;
+int libata_fua = 1;
 module_param_named(fua, libata_fua, int, 0444);
-MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on)");
+MODULE_PARM_DESC(fua, "FUA support (0=off, 1=on for NCQ drives only, 2=on)");
 
 static int ata_probe_timeout = ATA_TMOUT_INTERNAL / HZ;
 module_param(ata_probe_timeout, int, 0444);
diff -rup linux-2.6.20-git6/drivers/ata/libata-scsi.c linux-2.6.20-git6edit/drivers/ata/libata-scsi.c
--- linux-2.6.20-git6/drivers/ata/libata-scsi.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/libata-scsi.c	2007-02-11 23:07:35.000000000 -0600
@@ -1002,6 +1002,16 @@ int ata_scsi_change_queue_depth(struct s
 
 	scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
 
+	/* Note: NCQ is switched off if queue depth is set to 1.
+	   Thus changing the depth may also enable/disable FUA,
+	   which the SCSI layer needs to know about, so we trigger
+	   a revalidate. */
+	if((queue_depth == 1 && !(dev->flags & ATA_DFLAG_NCQ_OFF)) ||
+	   (queue_depth > 1 && (dev->flags & ATA_DFLAG_NCQ_OFF))) {
+		ap->eh_info.action |= ATA_EH_REVALIDATE;
+		ata_port_schedule_eh(ap);
+	}
+
 	spin_lock_irqsave(ap->lock, flags);
 	if (queue_depth > 1)
 		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
@@ -1990,27 +2000,46 @@ static unsigned int ata_msense_rw_recove
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
@@ -2030,7 +2059,6 @@ static int ata_dev_supports_fua(u16 *id)
 unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
 				  unsigned int buflen)
 {
-	struct ata_device *dev = args->dev;
 	u8 *scsicmd = args->cmd->cmnd, *p, *last;
 	const u8 sat_blk_desc[] = {
 		0, 0, 0, 0,	/* number of blocks: sat unspecified */
@@ -2110,8 +2138,7 @@ unsigned int ata_scsiop_mode_sense(struc
 		return 0;
 
 	dpofua = 0;
-	if (ata_dev_supports_fua(args->id) && (dev->flags & ATA_DFLAG_LBA48) &&
-	    (!(dev->flags & ATA_DFLAG_PIO) || dev->multi_count))
+	if (ata_dev_supports_fua(args->dev))
 		dpofua = 1 << 4;
 
 	if (six_byte) {
diff -rup linux-2.6.20-git6/drivers/ata/pata_it821x.c linux-2.6.20-git6edit/drivers/ata/pata_it821x.c
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
diff -rup linux-2.6.20-git6/drivers/ata/sata_sil.c linux-2.6.20-git6edit/drivers/ata/sata_sil.c
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
--- linux-2.6.20-git6/include/linux/libata.h	2007-02-11 22:13:00.000000000 -0600
+++ linux-2.6.20-git6edit/include/linux/libata.h	2007-02-11 22:13:29.000000000 -0600
@@ -172,6 +172,7 @@ enum {
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
 	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
+	ATA_FLAG_NO_FUA		= (1 << 16), /* doesn't support FUA commands */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
