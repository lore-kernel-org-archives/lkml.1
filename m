Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517Ab0BNMI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:08:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60562 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758502Ab0BNMIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=KEJAze8tWb3opuf33h6tZCfCuHYPVIInZDWo4QpaCHOuijaxXuSMZaRMLadCFY6Ein
         uTTrlhPUdH7XnXcmS+UQcn171iNFzZyrpki9g6Ihq4lBrukNXU3tQYkOSmJ0eOhI/qe3
         gyLpBq8hobJnEoKmEMXUWZX++3jyz0NsEOoDc=
Message-Id: <20100214120819.947320201@gmail.com>
References: <20100214120449.503204189@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 14 Feb 2010 13:04:50 +0100
From: Bart Hartgers <bart.hartgers@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Bart Hartgers <bart.hartgers@gmail.com>
Subject: [patch 1/1] Delay on vt6420 when starting ATAPI DMA write
Content-Disposition: inline; filename=sata_via/vt6420-atapi-dma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writing a disc on certain lite-on dvd-writers (also rebadged 
as optiarc/LG/...) connected to a vt6420, the ATAPI CDB ends
up in the datastream and on the disc, causing silent corruption. 
Delaying between sending the CDB and starting DMA seems to 
prevent this.

I do not know if there are burners that do not suffer from
this, but the patch should be safe for those as well.

There are many reports of this issue, but AFAICT no solution was 
found before. For example:
http://lkml.indiana.edu/hypermail/linux/kernel/0802.3/0561.html

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.33-rc4/drivers/ata/sata_via.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/ata/sata_via.c	2010-02-14 11:54:15.000000000 +0100
+++ linux-2.6.33-rc4/drivers/ata/sata_via.c	2010-02-14 11:55:42.000000000 +0100
@@ -40,11 +40,13 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.5"
+#define DRV_VERSION	"2.6"
 
 /*
  * vt8251 is different from other sata controllers of VIA.  It has two
@@ -80,6 +82,7 @@ static int vt8251_scr_write(struct ata_l
 static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
@@ -121,6 +124,7 @@ static struct ata_port_operations vt6420
 	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
+	.bmdma_start		= vt6420_bmdma_start,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
@@ -377,6 +381,17 @@ static int vt6420_prereset(struct ata_li
 	return 0;
 }
 
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	if ((qc->tf.command == ATA_CMD_PACKET) &&
+	    (qc->scsicmd->sc_data_direction == DMA_TO_DEVICE)) {
+		/* Prevents corruption on some ATAPI burners */
+		ata_sff_pause(ap);
+	}
+	ata_bmdma_start(qc);
+}
+
 static int vt6421_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);

-- 
