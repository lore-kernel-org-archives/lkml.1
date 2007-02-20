Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXBTRFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXBTRFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXBTRFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:05:12 -0500
Received: from [81.2.110.250] ([81.2.110.250]:35793 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030313AbXBTRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:05:08 -0500
Date: Tue, 20 Feb 2007 18:06:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: Expose set_mode method so it can be wrapped
Message-ID: <20070220180652.6f019b67@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This splits set_mode into do_set_mode and the wrapper so that a driver
can call the standard method inside its own. This in theory also
obsoletes ->post_set_mode().

Needed for ACPI driver.

Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/libata-core.c linux-2.6.20-mm2/drivers/ata/libata-core.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/libata-core.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/libata-core.c	2007-02-20 14:28:14.000000000 +0000
@@ -2381,12 +2437,13 @@
 }
 
 /**
- *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	ata_do_set_mode - Program timings and issue SET FEATURES - XFER
  *	@ap: port on which timings will be programmed
  *	@r_failed_dev: out paramter for failed device
  *
- *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
- *	ata_set_mode() fails, pointer to the failing device is
+ *	Standard implementation of the function used to tune and set 
+ *	ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
+ *	ata_dev_set_mode() fails, pointer to the failing device is
  *	returned in @r_failed_dev.
  *
  *	LOCKING:
@@ -2395,14 +2452,12 @@
  *	RETURNS:
  *	0 on success, negative errno otherwise
  */
-int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
+
+int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 {
 	struct ata_device *dev;
 	int i, rc = 0, used_dma = 0, found = 0;
 
-	/* has private set_mode? */
-	if (ap->ops->set_mode)
-		return ap->ops->set_mode(ap, r_failed_dev);
 
 	/* step 1: calculate xfer_mask */
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
@@ -2488,6 +2543,29 @@
 }
 
 /**
+ *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	@ap: port on which timings will be programmed
+ *	@r_failed_dev: out paramter for failed device
+ *
+ *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
+ *	ata_set_mode() fails, pointer to the failing device is
+ *	returned in @r_failed_dev.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, negative errno otherwise
+ */
+int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
+{
+	/* has private set_mode? */
+	if (ap->ops->set_mode)
+		return ap->ops->set_mode(ap, r_failed_dev);
+	return ata_do_set_mode(ap, r_failed_dev);
+}
+
+/**
  *	ata_tf_to_host - issue ATA taskfile to host controller
  *	@ap: port to which command is being issued
  *	@tf: ATA taskfile register set
@@ -6241,6 +6348,7 @@
 EXPORT_SYMBOL_GPL(ata_exec_command);
 EXPORT_SYMBOL_GPL(ata_port_start);
 EXPORT_SYMBOL_GPL(ata_interrupt);
+EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_data_xfer);
 EXPORT_SYMBOL_GPL(ata_data_xfer_noirq);
 EXPORT_SYMBOL_GPL(ata_qc_prep);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/include/linux/libata.h linux-2.6.20-mm2/include/linux/libata.h
--- linux.vanilla-2.6.20-mm2/include/linux/libata.h	2007-02-20 13:38:11.000000000 +0000
+++ linux-2.6.20-mm2/include/linux/libata.h	2007-02-20 14:03:24.000000000 +0000
@@ -819,6 +822,7 @@
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
+extern int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev);
 extern u8 ata_irq_on(struct ata_port *ap);
 extern u8 ata_dummy_irq_on(struct ata_port *ap);
 extern u8 ata_irq_ack(struct ata_port *ap, unsigned int chk_drq);
