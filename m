Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJBBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJBBp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJBBpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:45:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:33073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYJBBpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:45:07 -0400
Message-ID: <48E4272A.1090105@kernel.org>
Date: Thu, 02 Oct 2008 10:43:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Scott Pitcher <scottpitcher@netspace.net.au>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Joseph Chan <JosephChan@via.com.tw>
Subject: Re: VIA SATA id 5372 & Pioneer DVR-215 DVD burner problem
References: <loom.20080902T014408-4@post.gmane.org> <20080903095359.27961778.akpm@linux-foundation.org> <48E4270A.5030107@kernel.org>
In-Reply-To: <48E4270A.5030107@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060203020708050306060109"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Oct 2008 01:44:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060203020708050306060109
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Hello,
> 
> Can you please test the attached patch?  It's on top of the upstream
> branch of Jeff's libata-dev tree.
> 
>   http://www.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>   git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
> 
> If you're unfamiliar with git, just lemme know.  I'll send you a patch
> against 2.6.27-rc8.

And I of course forgot to actually attach the patch.

-- 
tejun

--------------060203020708050306060109
Content-Type: text/x-patch;
 name="via.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="via.patch"

Index: work/drivers/ata/sata_via.c
===================================================================
--- work.orig/drivers/ata/sata_via.c
+++ work/drivers/ata/sata_via.c
@@ -44,11 +44,16 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.3"
+#define DRV_VERSION	"2.4"
 
+/*
+ * vt8251 is different from other sata controllers of VIA.  It has two
+ * channels, each channel has both Master and Slave slot.
+ */
 enum board_ids_enum {
 	vt6420,
 	vt6421,
+	vt8251,
 };
 
 enum {
@@ -70,6 +75,9 @@ enum {
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+static int vt8251_scr_read(struct ata_link *link, unsigned int scr, u32 *val);
+static int vt8251_scr_write(struct ata_link *link, unsigned int scr, u32 val);
+static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
@@ -78,12 +86,12 @@ static void vt6421_set_dma_mode(struct a
 
 static const struct pci_device_id svia_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x5337), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x0591), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x3149), vt6420 },
-	{ PCI_VDEVICE(VIA, 0x3249), vt6421 },
-	{ PCI_VDEVICE(VIA, 0x5287), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x0591), vt6420 }, /* 2 sata chnls (Master) */
+	{ PCI_VDEVICE(VIA, 0x3149), vt6420 }, /* 2 sata chnls (Master) */
+	{ PCI_VDEVICE(VIA, 0x3249), vt6421 }, /* 2 sata chnls, 1 pata chnl */
 	{ PCI_VDEVICE(VIA, 0x5372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
+	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls (Master/Slave) */
 
 	{ }	/* terminate list */
 };
@@ -103,25 +111,36 @@ static struct scsi_host_template svia_sh
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct ata_port_operations vt6420_sata_ops = {
+static struct ata_port_operations svia_base_ops = {
 	.inherits		= &ata_bmdma_port_ops,
+	.sff_tf_load		= svia_tf_load,
+};
+
+static struct ata_port_operations vt6420_sata_ops = {
+	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &svia_base_ops,
 	.cable_detect		= vt6421_pata_cable_detect,
 	.set_piomode		= vt6421_set_pio_mode,
 	.set_dmamode		= vt6421_set_dma_mode,
 };
 
 static struct ata_port_operations vt6421_sata_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &svia_base_ops,
 	.scr_read		= svia_scr_read,
 	.scr_write		= svia_scr_write,
 };
 
+static struct ata_port_operations vt8251_ops = {
+	.inherits		= &svia_base_ops,
+	.scr_read		= vt8251_scr_read,
+	.scr_write		= vt8251_scr_write,
+};
+
 static const struct ata_port_info vt6420_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
@@ -146,6 +165,15 @@ static struct ata_port_info vt6421_pport
 	.port_ops	= &vt6421_pata_ops,
 };
 
+static struct ata_port_info vt8251_port_info = {
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
+			  ATA_FLAG_NO_LEGACY,
+	.pio_mask	= 0x1f,
+	.mwdma_mask	= 0x07,
+	.udma_mask	= ATA_UDMA6,
+	.port_ops	= &vt8251_ops,
+};
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("SCSI low-level driver for VIA SATA controllers");
 MODULE_LICENSE("GPL");
@@ -168,6 +196,106 @@ static int svia_scr_write(struct ata_lin
 	return 0;
 }
 
+static int vt8251_scr_read(struct ata_link *link, unsigned int scr, u32 *val)
+{
+	static const u8 ipm_tbl[] = { 1, 2, 6, 0 };
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	int slot = 2 * link->ap->port_no + link->pmp;
+	u32 v = 0;
+	u8 raw;
+
+	switch (scr) {
+	case SCR_STATUS:
+		pci_read_config_byte(pdev, 0xA0 + slot, &raw);
+
+		/* read the DET field, bit0 and 1 of the config byte */
+		v |= raw & 0x03;
+
+		/* read the SPD field, bit4 of the configure byte */
+		if (raw & (1 << 4))
+			v |= 0x02 << 4;
+		else
+			v |= 0x01 << 4;
+
+		/* read the IPM field, bit2 and 3 of the config byte */
+		v |= ipm_tbl[(raw >> 2) & 0x3];
+		break;
+
+	case SCR_ERROR:
+		/* devices other than 5287 uses 0xA8 as base */
+		WARN_ON(pdev->device != 0x5287);
+		pci_read_config_dword(pdev, 0xB0 + slot * 4, &v);
+		break;
+
+	case SCR_CONTROL:
+		pci_read_config_byte(pdev, 0xA4 + slot, &raw);
+
+		/* read the DET field, bit0 and bit1 */
+		v |= ((raw & 0x02) << 1) | (raw & 0x01);
+
+		/* read the IPM field, bit2 and bit3 */
+		v |= ((raw >> 2) & 0x03) << 8;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	*val = v;
+	return 0;
+}
+
+static int vt8251_scr_write(struct ata_link *link, unsigned int scr, u32 val)
+{
+	struct pci_dev *pdev = to_pci_dev(link->ap->host->dev);
+	int slot = 2 * link->ap->port_no + link->pmp;
+	u32 v = 0;
+
+	switch (scr) {
+	case SCR_ERROR:
+		/* devices other than 5287 uses 0xA8 as base */
+		WARN_ON(pdev->device != 0x5287);
+		pci_write_config_dword(pdev, 0xB0 + slot * 4, val);
+		return 0;
+
+	case SCR_CONTROL:
+		/* set the DET field */
+		v |= ((val & 0x4) >> 1) | (val & 0x1);
+
+		/* set the IPM field */
+		v |= ((val >> 8) & 0x3) << 2;
+
+		pci_write_config_byte(pdev, 0xA4 + slot, v);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+/**
+ *	svia_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller.
+ *
+ *	This is to fix the internal bug of via chipsets, which will
+ *	reset the device register after changing the IEN bit on ctl
+ *	register.
+ */
+static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_taskfile ttf;
+
+	if (tf->ctl != ap->last_ctl)  {
+		ttf = *tf;
+		ttf.flags |= ATA_TFLAG_DEVICE;
+		tf = &ttf;
+	}
+	ata_sff_tf_load(ap, tf);
+}
+
 static void svia_noop_freeze(struct ata_port *ap)
 {
 	/* Some VIA controllers choke if ATA_NIEN is manipulated in
@@ -367,6 +495,30 @@ static int vt6421_prepare_host(struct pc
 	return 0;
 }
 
+static int vt8251_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
+{
+	const struct ata_port_info *ppi[] = { &vt8251_port_info, NULL };
+	struct ata_host *host;
+	int i, rc;
+
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	*r_host = host;
+
+	rc = pcim_iomap_regions(pdev, 1 << 5, DRV_NAME);
+	if (rc) {
+		dev_printk(KERN_ERR, &pdev->dev, "failed to iomap PCI BAR 5\n");
+		return rc;
+	}
+
+	/* 8251 hosts four sata ports as M/S of the two channels */
+	for (i = 0; i < host->n_ports; i++)
+		ata_slave_link_init(host->ports[i]);
+
+	return 0;
+}
+
 static void svia_configure(struct pci_dev *pdev)
 {
 	u8 tmp8;
@@ -422,10 +574,10 @@ static int svia_init_one(struct pci_dev
 	if (rc)
 		return rc;
 
-	if (board_id == vt6420)
-		bar_sizes = &svia_bar_sizes[0];
-	else
+	if (board_id == vt6421)
 		bar_sizes = &vt6421_bar_sizes[0];
+	else
+		bar_sizes = &svia_bar_sizes[0];
 
 	for (i = 0; i < ARRAY_SIZE(svia_bar_sizes); i++)
 		if ((pci_resource_start(pdev, i) == 0) ||
@@ -438,12 +590,19 @@ static int svia_init_one(struct pci_dev
 			return -ENODEV;
 		}
 
-	if (board_id == vt6420)
+	switch (board_id) {
+	case vt6420:
 		rc = vt6420_prepare_host(pdev, &host);
-	else
+		break;
+	case vt6421:
 		rc = vt6421_prepare_host(pdev, &host);
-	if (rc)
-		return rc;
+		break;
+	case vt8251:
+		rc = vt8251_prepare_host(pdev, &host);
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	svia_configure(pdev);
 

--------------060203020708050306060109--
