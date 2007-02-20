Return-Path: <linux-kernel-owner+w=401wt.eu-S1030254AbXBTQsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbXBTQsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030277AbXBTQsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:48:08 -0500
Received: from [81.2.110.250] ([81.2.110.250]:45925 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030254AbXBTQsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:48:07 -0500
Date: Tue, 20 Feb 2007 17:51:51 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] pata_sl82c105: remove un-needed code paths
Message-ID: <20070220175151.4fcaa326@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the DMA setup function. As pointed out by Sergey we set the actual
DMA clock timing in set_dmamode so we don't actually need to do anything
with it at set up time, but just leave the PIO timings loaded.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_sl82c105.c linux-2.6.20-mm2/drivers/ata/pata_sl82c105.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_sl82c105.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_sl82c105.c	2007-02-20 13:58:10.000000000 +0000
@@ -7,6 +7,13 @@
  * 		SL82C105/Winbond 553 IDE driver
  *
  * and in part on the documentation and errata sheet
+ *
+ *
+ * Note: The controller like many controllers has shared timings for
+ * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
+ * in the dma_stop function. Thus we actually don't need a set_dmamode
+ * method as the PIO method is always called and will set the right PIO
+ * timing parameters.
  */
 
 #include <linux/kernel.h>
@@ -19,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sl82c105"
-#define DRV_VERSION "0.2.3"
+#define DRV_VERSION "0.2.5"
 
 enum {
 	/*
@@ -126,33 +133,6 @@
 }
 
 /**
- *	sl82c105_set_dmamode	-	set initial DMA mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Called to do the DMA mode setup. This replaces the PIO timings
- *	for the device in question. Set appropriate PIO timings not DMA
- *	timings at this point.
- */
-
-static void sl82c105_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	switch(adev->dma_mode) {
-		case XFER_MW_DMA_0:
-			sl82c105_configure_piomode(ap, adev, 0);
-			break;
-		case XFER_MW_DMA_1:
-			sl82c105_configure_piomode(ap, adev, 3);
-			break;
-		case XFER_MW_DMA_2:
-			sl82c105_configure_piomode(ap, adev, 4);
-			break;
-		default:
-			BUG();
-	}
-}
-
-/**
  *	sl82c105_reset_engine	-	Reset the DMA engine
  *	@ap: ATA interface
  *
@@ -222,7 +202,7 @@
 
 	/* This will redo the initial setup of the DMA device to matching
 	   PIO timings */
-	sl82c105_set_dmamode(ap, qc->dev);
+	sl82c105_set_piomode(ap, qc->dev);
 }
 
 static struct scsi_host_template sl82c105_sht = {
@@ -246,7 +226,6 @@
 static struct ata_port_operations sl82c105_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= sl82c105_set_piomode,
-	.set_dmamode	= sl82c105_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
 
 	.tf_load	= ata_tf_load,
