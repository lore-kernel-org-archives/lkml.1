Return-Path: <linux-kernel-owner+w=401wt.eu-S1751232AbXAXLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbXAXLhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXAXLhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:37:23 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbXAXLhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:37:22 -0500
Date: Wed, 24 Jan 2007 11:47:07 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: [PATCH]: set_mode, Fix the FIXME
Message-ID: <20070124114707.42370540@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When set_mode() changed ->set_mode didn't adapt. This makes the needed
changes and removes the relevant FIXME case.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/ata_generic.c linux-2.6.20-rc4-mm1/drivers/ata/ata_generic.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/ata_generic.c	2007-01-22 16:25:32.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/ata_generic.c	2007-01-22 16:46:02.000000000 +0000
@@ -64,6 +64,7 @@
 /**
  *	generic_set_mode	-	mode setting
  *	@ap: interface to set up
+ *	@unused: returned device on error
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *	The BIOS configured everything. Our job is not to fiddle. We
@@ -71,7 +72,7 @@
  *	and respect them.
  */
 
-static void generic_set_mode(struct ata_port *ap)
+static int generic_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int dma_enabled = 0;
 	int i;
@@ -82,7 +83,7 @@
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->dma_mode = XFER_MW_DMA_0;
@@ -99,6 +100,7 @@
 			}
 		}
 	}
+	return 0;
 }
 
 static struct scsi_host_template generic_sht = {
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-core.c linux-2.6.20-rc4-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-core.c	2007-01-22 16:26:50.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/libata-core.c	2007-01-24 00:13:00.000000000 +0000
@@ -2445,18 +2445,8 @@
 	int i, rc = 0, used_dma = 0, found = 0;
 
 	/* has private set_mode? */
-	if (ap->ops->set_mode) {
-		/* FIXME: make ->set_mode handle no device case and
-		 * return error code and failing device on failure.
-		 */
-		for (i = 0; i < ATA_MAX_DEVICES; i++) {
-			if (ata_dev_ready(&ap->device[i])) {
-				ap->ops->set_mode(ap);
-				break;
-			}
-		}
-		return 0;
-	}
+	if (ap->ops->set_mode)
+		return ap->ops->set_mode(ap, r_failed_dev);
 
 	/* step 1: calculate xfer_mask */
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_it821x.c linux-2.6.20-rc4-mm1/drivers/ata/pata_it821x.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_it821x.c	2007-01-22 16:26:50.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/pata_it821x.c	2007-01-22 16:48:00.000000000 +0000
@@ -476,6 +476,7 @@
 /**
  *	it821x_smart_set_mode	-	mode setting
  *	@ap: interface to set up
+ *	@unused: device that failed (error only)
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *	The BIOS configured everything. Our job is not to fiddle. We
@@ -483,7 +484,7 @@
  *	and respect them.
  */
 
-static void it821x_smart_set_mode(struct ata_port *ap)
+static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int dma_enabled = 0;
 	int i;
@@ -512,6 +513,7 @@
 			}
 		}
 	}
+	return 0;
 }
 
 /**
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_ixp4xx_cf.c linux-2.6.20-rc4-mm1/drivers/ata/pata_ixp4xx_cf.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_ixp4xx_cf.c	2007-01-22 16:25:32.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/pata_ixp4xx_cf.c	2007-01-22 16:48:16.000000000 +0000
@@ -23,9 +23,9 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.1"
+#define DRV_VERSION	"0.1.1ac1"
 
-static void ixp4xx_set_mode(struct ata_port *ap)
+static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	int i;
 
@@ -38,6 +38,7 @@
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static void ixp4xx_phy_reset(struct ata_port *ap)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_legacy.c linux-2.6.20-rc4-mm1/drivers/ata/pata_legacy.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_legacy.c	2007-01-22 16:25:32.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/pata_legacy.c	2007-01-22 16:48:16.000000000 +0000
@@ -96,6 +96,7 @@
 /**
  *	legacy_set_mode		-	mode setting
  *	@ap: IDE interface
+ *	@unused: Device that failed when error is returned
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *
@@ -105,7 +106,7 @@
  *	expand on this as per hdparm in the base kernel.
  */
 
-static void legacy_set_mode(struct ata_port *ap)
+static int legacy_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int i;
 
@@ -118,6 +119,7 @@
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static struct scsi_host_template legacy_sht = {
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_rz1000.c linux-2.6.20-rc4-mm1/drivers/ata/pata_rz1000.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_rz1000.c	2007-01-22 16:25:32.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/pata_rz1000.c	2007-01-22 16:49:36.000000000 +0000
@@ -52,19 +52,20 @@
 /**
  *	rz1000_set_mode		-	mode setting function
  *	@ap: ATA interface
+ *	@unused: returned device on set_mode failure
  *
  *	Use a non standard set_mode function. We don't want to be tuned. We
  *	would prefer to be BIOS generic but for the fact our hardware is
  *	whacked out.
  */
 
-static void rz1000_set_mode(struct ata_port *ap)
+static int rz1000_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int i;
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
@@ -72,6 +73,7 @@
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/include/linux/libata.h linux-2.6.20-rc4-mm1/include/linux/libata.h
--- linux.vanilla-2.6.20-rc4-mm1/include/linux/libata.h	2007-01-22 16:26:52.000000000 +0000
+++ linux-2.6.20-rc4-mm1/include/linux/libata.h	2007-01-22 16:53:47.000000000 +0000
@@ -613,11 +613,11 @@
 	void (*dev_select)(struct ata_port *ap, unsigned int device);
 
 	void (*phy_reset) (struct ata_port *ap); /* obsolete */
-	void (*set_mode) (struct ata_port *ap);
+	int  (*set_mode) (struct ata_port *ap, struct ata_device **r_failed_dev);
 
 	void (*post_set_mode) (struct ata_port *ap);
 
-	int (*check_atapi_dma) (struct ata_queued_cmd *qc);
+	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
 
 	void (*bmdma_setup) (struct ata_queued_cmd *qc);
 	void (*bmdma_start) (struct ata_queued_cmd *qc);
