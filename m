Return-Path: <linux-kernel-owner+w=401wt.eu-S1032669AbXFIAJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032669AbXFIAJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969612AbXFIAJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:09:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60233 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968865AbXFIAJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:09:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fdq+9QLqjFqk8XExrY7NKIYu2QwbeNXDiw9JtCOUFgVvIH0R4ooV2NAFN/BaiAQTQvNI4kEkesIJ2aW4RwWYMobGsXaAfOppNeEoWQxjAdcYsaWesN1+N+hi+aBo+N8WPu97BGSSTHJfLuNzumlJnJicxBf5buu5TQkG88QTORw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] pata_it821x: sync with IDE it821x driver
Date: Sat, 9 Jun 2007 02:23:20 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706090223.20933.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* fix PIO setup for devices with different PIO speeds in passthru mode

  IT821x allows one PIO setting per port se we have to limit maximum
  PIO mode to the one of the slowest device on the port.

* (partially) fix DMA in RAID mode

  Code intended to check DMA status was checking DMA command register.
  Moreover firmware seems to "forget" to set DMA capable bit for the
  slave device (at least in RAID mode but without ITE RAID volumes) so
  check device ID for DMA capable bit when deciding whether to use DMA
  and remove DMA status check completely.

  Thanks to Pavol ©imo for the bugreport and testing the initial fix.

  This change unfortunately still doesn't fix DMA in RAID mode (which
  works fine with IDE it821x) but Alan is working on the missing pieces
  (pata_it821x vs libata EH issues).

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ata/pata_it821x.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: b/drivers/ata/pata_it821x.c
===================================================================
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -2,6 +2,7 @@
  * pata_it821x.c 	- IT821x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * based upon
  *
@@ -79,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.6"
+#define DRV_VERSION "0.3.7"
 
 struct it821x_dev
 {
@@ -258,8 +259,14 @@ static void it821x_passthru_set_piomode(
 	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
 
 	struct it821x_dev *itdev = ap->private_data;
+	struct ata_device *pair = ata_dev_pair(adev);
 	int unit = adev->devno;
-	int mode_wanted = adev->pio_mode - XFER_PIO_0;
+	int mode_wanted = adev->pio_mode;
+
+	if (pair && adev->pio_mode > pair->pio_mode)
+		mode_wanted = pair->pio_mode;
+
+	mode_wanted -= XFER_PIO_0;
 
 	/* We prefer 66Mhz clock for PIO 0-3, don't care for PIO4 */
 	itdev->want[unit][1] = pio_want[mode_wanted];
@@ -460,14 +467,8 @@ static unsigned int it821x_passthru_qc_i
 
 static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
-	int dma_enabled = 0;
 	int i;
 
-	/* Bits 5 and 6 indicate if DMA is active on master/slave */
-	/* It is possible that BMDMA isn't allocated */
-	if (ap->ioaddr.bmdma_addr)
-		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
-
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
 		if (ata_dev_enabled(dev)) {
@@ -476,7 +477,7 @@ static int it821x_smart_set_mode(struct 
 			dev->dma_mode = XFER_MW_DMA_0;
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + i))) {
+			if (ata_id_has_dma(dev->id)) {
 				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
