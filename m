Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXCAXwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXCAXwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161256AbXCAXwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:52:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52989 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161184AbXCAXwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:52:23 -0500
Date: Fri, 2 Mar 2007 00:56:15 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: [PATCH] libata: dev_config does not need ap and adev passing
Message-ID: <20070302005615.4f53acb8@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It used to be impossible to get from ata_device to ata_port but that is
no longer true. Various methods have been cleaned up over time but
dev_config still takes both and most users don't need both anyway. Tidy
this one up

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c linux-2.6.21-rc2/drivers/ata/libata-core.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/libata-core.c	2007-03-01 23:26:21.000000000 +0000
@@ -1785,7 +1785,7 @@
 	}
 
 	if (ap->ops->dev_config)
-		ap->ops->dev_config(ap, dev);
+		ap->ops->dev_config(dev);
 
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_ali.c linux-2.6.21-rc2/drivers/ata/pata_ali.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_ali.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_ali.c	2007-03-01 23:24:22.000000000 +0000
@@ -324,7 +270,7 @@
  *	slower PIO methods
  */
 
-static void ali_lock_sectors(struct ata_port *ap, struct ata_device *adev)
+static void ali_lock_sectors(struct ata_device *adev)
 {
 	adev->max_sectors = 255;
 }
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_it821x.c linux-2.6.21-rc2/drivers/ata/pata_it821x.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_it821x.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_it821x.c	2007-03-01 23:24:04.000000000 +0000
@@ -520,7 +495,6 @@
 
 /**
  *	it821x_dev_config	-	Called each device identify
- *	@ap: ATA port
  *	@adev: Device that has just been identified
  *
  *	Perform the initial setup needed for each device that is chip
@@ -531,7 +505,7 @@
  *	basically we need to filter commands for this chip.
  */
 
-static void it821x_dev_config(struct ata_port *ap, struct ata_device *adev)
+static void it821x_dev_config(struct ata_device *adev)
 {
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_pdc202xx_old.c linux-2.6.21-rc2/drivers/ata/pata_pdc202xx_old.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_pdc202xx_old.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_pdc202xx_old.c	2007-03-01 23:24:42.000000000 +0000
@@ -238,7 +210,6 @@
 
 /**
  *	pdc2026x_dev_config	-	device setup hook
- *	@ap: ATA port
  *	@adev: newly found device
  *
  *	Perform chip specific early setup. We need to lock the transfer
@@ -246,7 +217,7 @@
  *	barf.
  */
 
-static void pdc2026x_dev_config(struct ata_port *ap, struct ata_device *adev)
+static void pdc2026x_dev_config(struct ata_device *adev)
 {
 	adev->max_sectors = 256;
 }
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/sata_inic162x.c linux-2.6.21-rc2/drivers/ata/sata_inic162x.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/sata_inic162x.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/sata_inic162x.c	2007-03-01 23:25:02.000000000 +0000
@@ -490,7 +490,7 @@
 		inic_reset_port(inic_port_base(qc->ap));
 }
 
-static void inic_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void inic_dev_config(struct ata_device *dev)
 {
 	/* inic can only handle upto LBA28 max sectors */
 	if (dev->max_sectors > ATA_MAX_SECTORS)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/sata_sil24.c linux-2.6.21-rc2/drivers/ata/sata_sil24.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/sata_sil24.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/sata_sil24.c	2007-03-01 23:25:23.000000000 +0000
@@ -323,7 +323,7 @@
 	struct ata_taskfile tf;			/* Cached taskfile registers */
 };
 
-static void sil24_dev_config(struct ata_port *ap, struct ata_device *dev);
+static void sil24_dev_config(struct ata_device *dev);
 static u8 sil24_check_status(struct ata_port *ap);
 static u32 sil24_scr_read(struct ata_port *ap, unsigned sc_reg);
 static void sil24_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val);
@@ -459,9 +459,9 @@
 	return tag;
 }
 
-static void sil24_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void sil24_dev_config(struct ata_device *dev)
 {
-	void __iomem *port = ap->ioaddr.cmd_addr;
+	void __iomem *port = dev->ap->ioaddr.cmd_addr;
 
 	if (dev->cdb_len == 16)
 		writel(PORT_CS_CDB16, port + PORT_CTRL_STAT);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/sata_sil.c linux-2.6.21-rc2/drivers/ata/sata_sil.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/sata_sil.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/sata_sil.c	2007-03-01 23:26:52.000000000 +0000
@@ -114,7 +114,7 @@
 #ifdef CONFIG_PM
 static int sil_pci_device_resume(struct pci_dev *pdev);
 #endif
-static void sil_dev_config(struct ata_port *ap, struct ata_device *dev);
+static void sil_dev_config(struct ata_device *dev);
 static u32 sil_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void sil_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 static void sil_post_set_mode (struct ata_port *ap);
@@ -519,7 +519,6 @@
 
 /**
  *	sil_dev_config - Apply device/host-specific errata fixups
- *	@ap: Port containing device to be examined
  *	@dev: Device to be examined
  *
  *	After the IDENTIFY [PACKET] DEVICE step is complete, and a
@@ -546,8 +545,9 @@
  *	appreciated.
  *	- But then again UDMA5 is hardly anything to complain about
  */
-static void sil_dev_config(struct ata_port *ap, struct ata_device *dev)
+static void sil_dev_config(struct ata_device *dev)
 {
+	struct ata_port *ap = dev->ap;
 	int print_info = ap->eh_context.i.flags & ATA_EHI_PRINTINFO;
 	unsigned int n, quirks = 0;
 	unsigned char model_num[ATA_ID_PROD_LEN + 1];
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/include/linux/libata.h linux-2.6.21-rc2/include/linux/libata.h
--- linux.vanilla-2.6.21-rc2/include/linux/libata.h	2007-03-01 13:36:13.000000000 +0000
+++ linux-2.6.21-rc2/include/linux/libata.h	2007-03-01 23:23:36.000000000 +0000
@@ -596,7 +595,7 @@
 struct ata_port_operations {
 	void (*port_disable) (struct ata_port *);
 
-	void (*dev_config) (struct ata_port *, struct ata_device *);
+	void (*dev_config) (struct ata_device *);
 
 	void (*set_piomode) (struct ata_port *, struct ata_device *);
 	void (*set_dmamode) (struct ata_port *, struct ata_device *);
