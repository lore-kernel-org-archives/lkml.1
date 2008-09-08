Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbYIHTub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbYIHTub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYIHTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:50:19 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48288 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbYIHTuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:50:16 -0400
Date: Mon, 8 Sep 2008 15:50:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes, new ids
Message-ID: <20080908195012.GA24945@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Main thing is Alan's commit, rightly taking me to task, and cleaning
up the mess in the Marvell dual-mode controller (legacy or AHCI) case.

Plus some new ids and fixes from Tejun (see commits for more info).

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig        |    6 +++-
 drivers/ata/ahci.c         |   21 +++++++++++++++++-
 drivers/ata/libata-sff.c   |    5 ----
 drivers/ata/pata_marvell.c |   51 ++++++++++++++++++++++++++++++++-----------
 drivers/ata/pata_sil680.c  |    3 --
 drivers/ata/sata_mv.c      |    3 +-
 drivers/ata/sata_nv.c      |   19 +---------------
 7 files changed, 65 insertions(+), 43 deletions(-)

Alan Cox (1):
      ahci, pata_marvell: play nicely together

David Milburn (1):
      pata_sil680: remove duplicate pcim_enable_device

Mark Lord (1):
      sata_mv: add RocketRaid 1720 PCI ID to driver

Seth Heasley (1):
      ahci: RAID mode SATA patch for Intel Ibex Peak DeviceIDs

Tejun Heo (3):
      ahci: disable PMP for marvell ahcis
      sata_nv: disable hardreset for generic
      libata-sff: kill spurious WARN_ON() in ata_hsm_move()

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ae84949..11c8c19 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -448,8 +448,10 @@ config PATA_MARVELL
 	tristate "Marvell PATA support via legacy mode"
 	depends on PCI
 	help
-	  This option enables limited support for the Marvell 88SE6145 ATA
-	  controller.
+	  This option enables limited support for the Marvell 88SE61xx ATA
+	  controllers. If you wish to use only the SATA ports then select
+	  the AHCI driver alone. If you wish to the use the PATA port or
+	  both SATA and PATA include this driver.
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c729e69..2e1a7cb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -420,7 +420,7 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_mv */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_MV_PATA),
+				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -487,7 +487,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
 	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -610,6 +612,15 @@ module_param(ahci_em_messages, int, 0444);
 MODULE_PARM_DESC(ahci_em_messages,
 	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");
 
+#if defined(CONFIG_PATA_MARVELL) || defined(CONFIG_PATA_MARVELL_MODULE)
+static int marvell_enable;
+#else
+static int marvell_enable = 1;
+#endif
+module_param(marvell_enable, int, 0644);
+MODULE_PARM_DESC(marvell_enable, "Marvell SATA via AHCI (1 = enabled)");
+
+
 static inline int ahci_nr_ports(u32 cap)
 {
 	return (cap & 0x1f) + 1;
@@ -732,6 +743,8 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 			   "MV_AHCI HACK: port_map %x -> %x\n",
 			   port_map,
 			   port_map & mv);
+		dev_printk(KERN_ERR, &pdev->dev,
+			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
 
 		port_map &= mv;
 	}
@@ -2533,6 +2546,12 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
 
+	/* The AHCI driver can only drive the SATA ports, the PATA driver
+	   can drive them all so if both drivers are selected make sure
+	   AHCI stays out of the way */
+	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
+		return -ENODEV;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 304fdc6..2a4c516 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1315,11 +1315,6 @@ fsm_start:
 		break;
 
 	case HSM_ST_ERR:
-		/* make sure qc->err_mask is available to
-		 * know what's wrong and recover
-		 */
-		WARN_ON(!(qc->err_mask & (AC_ERR_DEV | AC_ERR_HSM)));
-
 		ap->hsm_task_state = HSM_ST_IDLE;
 
 		/* complete taskfile transaction */
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 24a011b..0d87eec 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -20,29 +20,30 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_marvell"
-#define DRV_VERSION	"0.1.4"
+#define DRV_VERSION	"0.1.6"
 
 /**
- *	marvell_pre_reset	-	check for 40/80 pin
- *	@link: link
- *	@deadline: deadline jiffies for the operation
+ *	marvell_pata_active	-	check if PATA is active
+ *	@pdev: PCI device
  *
- *	Perform the PATA port setup we need.
+ *	Returns 1 if the PATA port may be active. We know how to check this
+ *	for the 6145 but not the other devices
  */
 
-static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
+static int marvell_pata_active(struct pci_dev *pdev)
 {
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int i;
 	u32 devices;
 	void __iomem *barp;
-	int i;
 
-	/* Check if our port is enabled */
+	/* We don't yet know how to do this for other devices */
+	if (pdev->device != 0x6145)
+		return 1;	
 
 	barp = pci_iomap(pdev, 5, 0x10);
 	if (barp == NULL)
 		return -ENOMEM;
+
 	printk("BAR5:");
 	for(i = 0; i <= 0x0F; i++)
 		printk("%02X:%02X ", i, ioread8(barp + i));
@@ -51,9 +52,27 @@ static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
 	devices = ioread32(barp + 0x0C);
 	pci_iounmap(pdev, barp);
 
-	if ((pdev->device == 0x6145) && (ap->port_no == 0) &&
-	    (!(devices & 0x10)))	/* PATA enable ? */
-		return -ENOENT;
+	if (devices & 0x10)
+		return 1;
+	return 0;
+}
+
+/**
+ *	marvell_pre_reset	-	check for 40/80 pin
+ *	@link: link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Perform the PATA port setup we need.
+ */
+
+static int marvell_pre_reset(struct ata_link *link, unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (pdev->device == 0x6145 && ap->port_no == 0 &&
+		!marvell_pata_active(pdev))	/* PATA enable ? */
+			return -ENOENT;
 
 	return ata_sff_prereset(link, deadline);
 }
@@ -128,6 +147,12 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	if (pdev->device == 0x6101)
 		ppi[1] = &ata_dummy_port_info;
 
+#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
+	if (!marvell_pata_active(pdev)) {
+		printk(KERN_INFO DRV_NAME ": PATA port not active, deferring to AHCI driver.\n");
+		return -ENODEV;
+	}
+#endif
 	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL);
 }
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 720b864..e970b22 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -322,9 +322,6 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 	/* Try to acquire MMIO resources and fallback to PIO if
 	 * that fails
 	 */
-	rc = pcim_enable_device(pdev);
-	if (rc)
-		return rc;
 	rc = pcim_iomap_regions(pdev, 1 << SIL680_MMIO_BAR, DRV_NAME);
 	if (rc)
 		goto use_ioports;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 13c1d2a..c815f8e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -667,7 +667,8 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
 	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
-	/* RocketRAID 1740/174x have different identifiers */
+	/* RocketRAID 1720/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1720), chip_6042 },
 	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
 	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 858f706..1e1f3f3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -309,8 +309,6 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
@@ -407,7 +405,7 @@ static struct scsi_host_template nv_swncq_sht = {
 
 static struct ata_port_operations nv_generic_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.hardreset		= nv_hardreset,
+	.hardreset		= ATA_OP_NULL,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 };
@@ -1588,21 +1586,6 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 	ata_sff_thaw(ap);
 }
 
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline)
-{
-	int rc;
-
-	/* SATA hardreset fails to retrieve proper device signature on
-	 * some controllers.  Request follow up SRST.  For more info,
-	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3352
-	 */
-	rc = sata_sff_hardreset(link, class, deadline);
-	if (rc)
-		return rc;
-	return -EAGAIN;
-}
-
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
