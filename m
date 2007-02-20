Return-Path: <linux-kernel-owner+w=401wt.eu-S1030288AbXBTRAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288AbXBTRAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030292AbXBTRAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:00:50 -0500
Received: from [81.2.110.250] ([81.2.110.250]:54280 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030291AbXBTRAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:00:48 -0500
Date: Tue, 20 Feb 2007 18:01:59 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: Add id_to_dma_mode function for printing DMA modes
Message-ID: <20070220180159.632d33bc@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also export dev_disable as this is needed by drivers doing slave decode
filtering, which will follow shortly

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/libata-core.c linux-2.6.20-mm2/drivers/ata/libata-core.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/libata-core.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/libata-core.c	2007-02-20 14:28:14.000000000 +0000
@@ -824,6 +824,48 @@
 }
 
 /**
+ *	ata_id_to_dma_mode	-	Identify DMA mode from id block
+ *	@dev: device to identify
+ *	@mode: mode to assume if we cannot tell
+ *
+ *	Set up the timing values for the device based upon the identify
+ *	reported values for the DMA mode. This function is used by drivers
+ *	which rely upon firmware configured modes, but wish to report the
+ *	mode correctly when possible.
+ *
+ *	In addition we emit similarly formatted messages to the default
+ *	ata_dev_set_mode handler, in order to provide consistency of
+ *	presentation.
+ */
+
+void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown)
+{
+	unsigned int mask;
+	u8 mode;
+
+	/* Pack the DMA modes */
+	mask = ((dev->id[63] >> 8) << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA;
+	if (dev->id[53] & 0x04)
+		mask |= ((dev->id[88] >> 8) << ATA_SHIFT_UDMA) & ATA_MASK_UDMA;
+
+	/* Select the mode in use */
+	mode = ata_xfer_mask2mode(mask);
+
+	if (mode != 0) {
+		ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
+		       ata_mode_string(mask));
+	} else {
+		/* SWDMA perhaps ? */
+		mode = unknown;
+		ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
+	}
+
+	/* Configure the device reporting */
+	dev->xfer_mode = mode;
+	dev->xfer_shift = ata_xfer_mode2shift(mode);
+}
+
+/**
  *	ata_noop_dev_select - Select device 0/1 on ATA bus
  *	@ap: ATA channel to manipulate
  *	@device: ATA device (numbered from zero) to select
@@ -6290,6 +6399,7 @@
 EXPORT_SYMBOL_GPL(ata_host_resume);
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
+EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
 EXPORT_SYMBOL_GPL(ata_device_blacklisted);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
@@ -6256,6 +6364,7 @@
 EXPORT_SYMBOL_GPL(ata_bmdma_error_handler);
 EXPORT_SYMBOL_GPL(ata_bmdma_post_internal_cmd);
 EXPORT_SYMBOL_GPL(ata_port_probe);
+EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(sata_phy_debounce);
 EXPORT_SYMBOL_GPL(sata_phy_resume);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/include/linux/libata.h linux-2.6.20-mm2/include/linux/libata.h
--- linux.vanilla-2.6.20-mm2/include/linux/libata.h	2007-02-20 13:38:11.000000000 +0000
+++ linux-2.6.20-mm2/include/linux/libata.h	2007-02-20 14:03:24.000000000 +0000
@@ -786,10 +787,12 @@
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
+extern void ata_dev_disable(struct ata_device *adev);
 extern void ata_id_string(const u16 *id, unsigned char *s,
 			  unsigned int ofs, unsigned int len);
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
+extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
 extern unsigned long ata_device_blacklisted(const struct ata_device *dev);
 extern void ata_bmdma_setup (struct ata_queued_cmd *qc);
 extern void ata_bmdma_start (struct ata_queued_cmd *qc);
