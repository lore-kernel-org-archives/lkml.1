Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXCAQ0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXCAQ0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:26:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965334AbXCAQ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:26:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49493 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965330AbXCAQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:26:11 -0500
Date: Thu, 1 Mar 2007 17:30:03 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org,
       jgarzik@pobox.com, torvalds@osdl.org
Subject: [PATCH] libata: Cable detection fixes
Message-ID: <20070301173003.5d5ab4a6@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.21-rc has horrible problems with libata and PATA cable types (and
thus speeds). This occurs because Tejun fixed a pile of other bugs and
we now do cable detect enforcement for drive side detection properly.

Unfortunately we don't do the process around cable detection right. Tejun
identified the problem and pointed to the right Annex in the spec, this patch
implements the needed changes.

The basic requirement is that we have to identify the slave before the
master.

The patch switches the identify order so that we can do the drive side
detection correctly. 

Secondly we add a ->cable_detect() method called after the identify
sequence which allows a host to do host side detection at this point
should it wish, or to modify the results of the drive side identify.

This separate ->cable_detect method also cleans up a lot of code because
many drivers have their own error_handler methods which really just set
the cable type.

If there is no ->cable_detect method the cable type is left alone so a
driver setting it earlier (eg because it has the SATA flags set or
because it uses the old error_handler approach) will still do the right
thing (or at least the same thing) as before.

This patch simply adds the cable_detect method and helpers it doesn't use
them but other follow up patches will (ie Adrian please don't submit
patches to unexport them ;))

Alan


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c linux-2.6.21-rc2/drivers/ata/libata-core.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 15:49:21.853448880 +0000
@@ -1800,6 +1800,56 @@
 }
 
 /**
+ *	ata_cable_40wire	-	return 40pin cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which want to hardwire 40 pin cable
+ *	detection.
+ */
+ 
+int ata_cable_40wire(struct ata_port *ap)
+{
+	return ATA_CBL_PATA40;
+}
+
+/**
+ *	ata_cable_80wire	-	return 40pin cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which want to hardwire 80 pin cable
+ *	detection.
+ */
+ 
+int ata_cable_80wire(struct ata_port *ap)
+{
+	return ATA_CBL_PATA80;
+}
+
+/**
+ *	ata_cable_unknown	-	return unknown PATA cable.
+ *	@ap: port
+ *
+ *	Helper method for drivers which have no PATA cable detection.
+ */
+ 
+int ata_cable_unknown(struct ata_port *ap)
+{
+	return ATA_CBL_PATA_UNK;
+}
+
+/**
+ *	ata_cable_sata	-	return SATA cable type
+ *	@ap: port
+ *
+ *	Helper method for drivers which have SATA cables
+ */
+ 
+int ata_cable_sata(struct ata_port *ap)
+{
+	return ATA_CBL_SATA;
+}
+
+/**
  *	ata_bus_probe - Reset and probe ATA bus
  *	@ap: Bus to probe
  *
@@ -1850,8 +1900,11 @@
 	for (i = 0; i < ATA_MAX_DEVICES; i++)
 		ap->device[i].pio_mode = XFER_PIO_0;
 
-	/* read IDENTIFY page and configure devices */
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
+	/* read IDENTIFY page and configure devices. We have to do the identify
+	   specific sequence bass-ackwards so that PDIAG- is released by
+	   the slave device */
+
+	for (i = ATA_MAX_DEVICES - 1; i >=  0; i--) {
 		dev = &ap->device[i];
 
 		if (tries[i])
@@ -1864,6 +1917,19 @@
 				     dev->id);
 		if (rc)
 			goto fail;
+	}
+
+	/* Now ask for the cable type as PDIAG- should have been released */
+	if (ap->ops->cable_detect)
+		ap->cbl = ap->ops->cable_detect(ap);
+
+	/* After the identify sequence we can now set up the devices. We do
+	   this in the normal order so that the user doesn't get confused */
+
+	for(i = 0; i < ATA_MAX_DEVICES; i++) {
+		dev = &ap->device[i];
+		if (!ata_dev_enabled(dev))
+			continue;
 
 		ap->eh_context.i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
@@ -6391,3 +6456,8 @@
 EXPORT_SYMBOL_GPL(ata_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dummy_irq_ack);
 EXPORT_SYMBOL_GPL(ata_dev_try_classify);
+
+EXPORT_SYMBOL_GPL(ata_cable_40wire);
+EXPORT_SYMBOL_GPL(ata_cable_80wire);
+EXPORT_SYMBOL_GPL(ata_cable_unknown);
+EXPORT_SYMBOL_GPL(ata_cable_sata);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/include/linux/libata.h linux-2.6.21-rc2/include/linux/libata.h
--- linux.vanilla-2.6.21-rc2/include/linux/libata.h	2007-03-01 13:36:13.000000000 +0000
+++ linux-2.6.21-rc2/include/linux/libata.h	2007-03-01 14:27:53.363612296 +0000
@@ -615,6 +614,8 @@
 
 	void (*post_set_mode) (struct ata_port *ap);
 
+	int (*cable_detect) (struct ata_port *ap);
+
 	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
 
 	void (*bmdma_setup) (struct ata_queued_cmd *qc);
@@ -828,6 +829,11 @@
 extern u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq);
 extern u8 ata_dummy_irq_ack(struct ata_port *ap, unsigned int chk_drq);
 
+extern int ata_cable_40wire(struct ata_port *ap);
+extern int ata_cable_80wire(struct ata_port *ap);
+extern int ata_cable_sata(struct ata_port *ap);
+extern int ata_cable_unknown(struct ata_port *ap);
+
 /*
  * Timing helpers
  */
