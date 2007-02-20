Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXBTBBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXBTBBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965861AbXBTBBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:01:22 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:14504 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbXBTBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:01:19 -0500
Date: Mon, 19 Feb 2007 18:45:40 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] libata: warn if speed limited due to 40-wire cable (v2)
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-id: <45DA44B4.6000209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a revised version of my previous patch to warn the user if a
drive's transfer rate is limited because of a 40-wire cable detection.
This one hopefully addresses Alan's previous comments - we now do this
at the very end of the function, and the ugly if condition has been
cleaned up somewhat. Also, it's been inadvertently tested (it seems that
pata_amd Nvidia cable detection is broken in current -git..)

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6/drivers/ata/libata-core.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/libata-core.c	2007-02-13 19:15:58.000000000 -0600
@@ -3305,19 +3305,7 @@ static void ata_dev_xfermask(struct ata_
 	xfer_mask = ata_pack_xfermask(ap->pio_mask,
 				      ap->mwdma_mask, ap->udma_mask);
 
-	/* Apply cable rule here.  Don't apply it early because when
-	 * we handle hot plug the cable type can itself change.
-	 */
-	if (ap->cbl == ATA_CBL_PATA40)
-		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-	/* Apply drive side cable rule. Unknown or 80 pin cables reported
-	 * host side are checked drive side as well. Cases where we know a
-	 * 40wire cable is used safely for 80 are not checked here.
-	 */
-        if (ata_drive_40wire(dev->id) && (ap->cbl == ATA_CBL_PATA_UNK || ap->cbl == ATA_CBL_PATA80))
-		xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
-
-
+	/* drive modes available */
 	xfer_mask &= ata_pack_xfermask(dev->pio_mask,
 				       dev->mwdma_mask, dev->udma_mask);
 	xfer_mask &= ata_id_xfermask(dev->id);
@@ -3348,6 +3336,25 @@ static void ata_dev_xfermask(struct ata_
 	if (ap->ops->mode_filter)
 		xfer_mask = ap->ops->mode_filter(ap, dev, xfer_mask);
 
+	/* Apply cable rule here.  Don't apply it early because when
+	 * we handle hot plug the cable type can itself change.
+	 * Check this last so that we know if the transfer rate was
+	 * solely limited by the cable.
+	 * Unknown or 80 wire cables reported host side are checked
+	 * drive side as well. Cases where we know a 40wire cable
+	 * is used safely for 80 are not checked here.
+	 */
+	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
+		/* UDMA/44 or higher would be available */
+		if((ap->cbl == ATA_CBL_PATA40) ||
+   		    (ata_drive_40wire(dev->id) &&
+		     (ap->cbl == ATA_CBL_PATA_UNK ||
+                     ap->cbl == ATA_CBL_PATA80))) {
+		      	ata_dev_printk(dev, KERN_WARNING,
+				 "limited to UDMA/33 due to 40-wire cable\n");
+			xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
+		}
+
 	ata_unpack_xfermask(xfer_mask, &dev->pio_mask,
 			    &dev->mwdma_mask, &dev->udma_mask);
 }

