Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYJaFuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYJaFuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 01:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYJaFtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 01:49:52 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49380 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYJaFtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 01:49:50 -0400
Date: Fri, 31 Oct 2008 01:49:49 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081031054949.GA10474@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notes:

1) 1.5TB drive fix from Roland

2) Tejun's sata_via brings a non-working via configuration thanks to a
   new facility also being used in recent (ICH9/10) ata_piix.

   Change is longer than one might like, but it accurately describes the
   hardware now, the previous stuff wasn't working, and the newly added
   support code shouldn't touch non-broken VIA controllers.



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |    1 -
 drivers/ata/libata-core.c |   11 +++-
 drivers/ata/sata_via.c    |  155 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/libata.h    |    1 +
 4 files changed, 152 insertions(+), 16 deletions(-)

Jens Axboe (1):
      libata: add whitelist for devices with known good pata-sata bridges

Randy Dunlap (1):
      ATA: remove excess kernel-doc notation

Roland Dreier (1):
      libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127

Tejun Heo (1):
      sata_via: fix support for 5287

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 52dc2d8..8e37be1 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -738,7 +738,6 @@ static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	do_pata_set_dmamode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Drive in question
- *	@udma: udma mode, 0 - 6
  *	@isich: set if the chip is an ICH device
  *
  *	Set UDMA mode for device, in host controller PCI config space.
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2ff633c..82af701 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
 
 	sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
 	sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
-	sectors |= (tf->hob_lbal & 0xff) << 24;
+	sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
 	sectors |= (tf->lbah & 0xff) << 16;
 	sectors |= (tf->lbam & 0xff) << 8;
 	sectors |= (tf->lbal & 0xff);
@@ -1602,7 +1602,6 @@ unsigned long ata_id_xfermask(const u16 *id)
 /**
  *	ata_pio_queue_task - Queue port_task
  *	@ap: The ata_port to queue port_task for
- *	@fn: workqueue function to be scheduled
  *	@data: data for @fn to use
  *	@delay: delay time in msecs for workqueue function
  *
@@ -2159,6 +2158,10 @@ retry:
 static inline u8 ata_dev_knobble(struct ata_device *dev)
 {
 	struct ata_port *ap = dev->link->ap;
+
+	if (ata_dev_blacklisted(dev) & ATA_HORKAGE_BRIDGE_OK)
+		return 0;
+
 	return ((ap->cbl == ATA_CBL_SATA) && (!ata_id_is_sata(dev->id)));
 }
 
@@ -4063,6 +4066,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "TSSTcorp CDDVDW SH-S202N", "SB00",	  ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202N", "SB01",	  ATA_HORKAGE_IVB, },
 
+	/* Devices that do not need bridging limits applied */
+	{ "MTRON MSP-SATA*",		NULL,	ATA_HORKAGE_BRIDGE_OK, },
+
 	/* End Marker */
 	{ }
 };
@@ -4648,7 +4654,6 @@ static void ata_verify_xfer(struct ata_queued_cmd *qc)
 /**
  *	ata_qc_complete - Complete an active ATA command
  *	@qc: Command to complete
- *	@err_mask: ATA Status register contents
  *
  *	Indicate to the mid and upper layers that an ATA
  *	command has completed, with either an ok or not-ok status.
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 5b72e73..62367fe 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
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
@@ -70,6 +75,8 @@ enum {
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static int svia_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
+static int vt8251_scr_read(struct ata_link *link, unsigned int scr, u32 *val);
+static int vt8251_scr_write(struct ata_link *link, unsigned int scr, u32 val);
 static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
@@ -79,12 +86,12 @@ static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
 
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
@@ -128,6 +135,13 @@ static struct ata_port_operations vt6421_sata_ops = {
 	.scr_write		= svia_scr_write,
 };
 
+static struct ata_port_operations vt8251_ops = {
+	.inherits		= &svia_base_ops,
+	.hardreset		= sata_std_hardreset,
+	.scr_read		= vt8251_scr_read,
+	.scr_write		= vt8251_scr_write,
+};
+
 static const struct ata_port_info vt6420_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
@@ -152,6 +166,15 @@ static struct ata_port_info vt6421_pport_info = {
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
@@ -174,6 +197,83 @@ static int svia_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
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
 /**
  *	svia_tf_load - send taskfile registers to host controller
  *	@ap: Port to which output is sent
@@ -396,6 +496,30 @@ static int vt6421_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
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
@@ -451,10 +575,10 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -467,12 +591,19 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 507f53e..f5441ed 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -372,6 +372,7 @@ enum {
 	ATA_HORKAGE_IPM		= (1 << 7),	/* Link PM problems */
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
+	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
