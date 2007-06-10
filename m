Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXFJQrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXFJQrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbXFJQr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:47:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51861 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbXFJQrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RpVwI8nOa5y+ax+QaGQPccvg5D6tDYTj3zm60TQjowZU+ZWHWMrqGQEjQUdQsFFPkytEX4zxWjGSSvKuzizUlyCnfiJwwRKnSN6ZHU7QL7PuC7Nmumfc6Ozn53l2w3uYbPRyLOwmPWNeYHEVUKMyClI4iO5EJqNW4EBPMkxetfA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] pata_it821x: (partially) fix DMA in RAID mode
Date: Sun, 10 Jun 2007 18:43:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706101843.20947.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
Cc: Tejun Heo <htejun@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ata/pata_it821x.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

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
@@ -460,14 +461,8 @@ static unsigned int it821x_passthru_qc_i
 
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
@@ -476,7 +471,7 @@ static int it821x_smart_set_mode(struct 
 			dev->dma_mode = XFER_MW_DMA_0;
 			/* We do need the right mode information for DMA or PIO
 			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + i))) {
+			if (ata_id_has_dma(dev->id)) {
 				ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
 				dev->xfer_mode = XFER_MW_DMA_0;
 				dev->xfer_shift = ATA_SHIFT_MWDMA;
