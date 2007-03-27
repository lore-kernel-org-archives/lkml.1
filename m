Return-Path: <linux-kernel-owner+w=401wt.eu-S933701AbXC0Q7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbXC0Q7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXC0Q7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:59:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37645 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933326AbXC0Q7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:59:05 -0400
Date: Tue, 27 Mar 2007 19:02:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Testing patch for ALi PATA - fixes hopefully for the problems with
 ATAPI DMA
Message-ID: <20070327190248.01bc7e5c@the-village.bc.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This implements two things at driver level which are implemented
implicitly by the old IDE layer

- Only doing sector sized ATAPI I/O via DMA
- Alway writing the size values

Hopefully this will make CD devices behave better for those with the
problems. If you can test both the detection and mounting/reading of a CD
works nicely that would be great, and then if you can see whether it is
the size check or the use of ali_tf_load v ata_tf_load that fixes it this
would be ideal.

Currently I don't have an ALi device with the problem so its a bit hard
to debug.

Alan

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_ali.c linux-2.6.21-rc4-mm1/drivers/ata/pata_ali.c
--- linux.vanilla-2.6.21-rc4-mm1/drivers/ata/pata_ali.c	2007-03-23 11:49:49.000000000 +0000
+++ linux-2.6.21-rc4-mm1/drivers/ata/pata_ali.c	2007-03-27 17:42:30.759952688 +0100
@@ -233,8 +233,8 @@
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x08);
+/*	if (adev->class == ATA_DEV_ATA)
+		ali_fifo_control(ap, adev, 0x08); */
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		ali_program_modes(ap, adev, NULL, udma_timing[adev->dma_mode - XFER_UDMA_0]);
@@ -275,6 +275,77 @@
 	adev->max_sectors = 255;
 }
 
+/**
+ *	ali_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller. We can't
+ *	use the default one as the onboard FIFO logic requires that we
+ *	write all the registers (see 1535 BIOS programming guide)
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+void ali_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	iowrite8(tf->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = tf->ctl;
+	ata_wait_idle(ap);
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		iowrite8(tf->hob_feature, ioaddr->feature_addr);
+		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+	if (is_addr) {
+		iowrite8(tf->feature, ioaddr->feature_addr);
+		iowrite8(tf->nsect, ioaddr->nsect_addr);
+		iowrite8(tf->lbal, ioaddr->lbal_addr);
+		iowrite8(tf->lbam, ioaddr->lbam_addr);
+		iowrite8(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	} else {
+		iowrite8(0, ioaddr->feature_addr);
+		iowrite8(0, ioaddr->nsect_addr);
+		iowrite8(0, ioaddr->lbal_addr);
+		iowrite8(0, ioaddr->lbam_addr);
+		iowrite8(0, ioaddr->lbah_addr);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite8(tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
+static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	/* Don't do DMA except for whole blocks */
+	if (qc->nbytes & 511)
+		return -1;
+	return 0;
+}
+
 static struct scsi_host_template ali_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -304,7 +375,7 @@
 static struct ata_port_operations ali_early_port_ops = {
 	.port_disable	= ata_port_disable,
 	.set_piomode	= ali_set_piomode,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -318,6 +389,7 @@
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -340,7 +412,7 @@
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ali_20_filter,
 
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -360,6 +432,7 @@
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -379,7 +452,7 @@
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -399,6 +472,7 @@
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
@@ -418,7 +492,7 @@
 	.set_piomode	= ali_set_piomode,
 	.set_dmamode	= ali_set_dmamode,
 	.mode_filter	= ata_pci_default_filter,
-	.tf_load	= ata_tf_load,
+	.tf_load	= ali_tf_load,
 	.tf_read	= ata_tf_read,
 	.check_status 	= ata_check_status,
 	.exec_command	= ata_exec_command,
@@ -437,6 +511,7 @@
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
+	.check_atapi_dma= ali_check_atapi_dma,
 
 	.data_xfer	= ata_data_xfer,
 
