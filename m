Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbZEKShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbZEKShn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbZEKShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:37:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39633 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbZEKShW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:37:22 -0400
Date: Mon, 11 May 2009 14:37:17 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090511183717.GA4989@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c          |   18 ++++++++--
 drivers/ata/libata-core.c       |    4 ++-
 drivers/ata/libata-eh.c         |   34 +++++++++++++++++--
 drivers/ata/libata-scsi.c       |    4 +-
 drivers/ata/pata_pdc202xx_old.c |    6 ++--
 drivers/ata/sata_mv.c           |   69 +++++++++++++++++++++++++++++++++++++-
 6 files changed, 120 insertions(+), 15 deletions(-)

Alan Cox (2):
      ata_piix: ICH7 does not support correct MWDMA timings
      ata_piix: The Sony TZ90 needs the cable type hardcoding

Bartlomiej Zolnierkiewicz (1):
      pata_pdc202xx_old: fix UDMA33 handling

Borislav Petkov (1):
      libata: fix suspend/resume for ATA SEMB devices

Martin Michlmayr (1):
      sata_mv: use new sata phy register settings for new devices

Tejun Heo (2):
      libata: fix attach error handling
      libata: clear ering on resume

Vitaly Mayatskikh (1):
      Avoid world-writable sysfs files in libata driver.

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 942d14a..d51a17c 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -72,6 +72,7 @@
  *	ICH2    spec c #20	- IDE PRD must not cross a 64K boundary
  *				  and must be dword aligned
  *	ICH2    spec c #24	- UDMA mode 4,5 t85/86 should be 6ns not 3.3
+ *	ICH7	errata #16	- MWDMA1 timings are incorrect
  *
  * Should have been BIOS fixed:
  *	450NX:	errata #19	- DMA hangs on old 450NX
@@ -94,7 +95,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME	"ata_piix"
-#define DRV_VERSION	"2.12"
+#define DRV_VERSION	"2.13"
 
 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -136,6 +137,7 @@ enum piix_controller_ids {
 	ich_pata_33,		/* ICH up to UDMA 33 only */
 	ich_pata_66,		/* ICH up to 66 Mhz */
 	ich_pata_100,		/* ICH up to UDMA 100 */
+	ich_pata_100_nomwdma1,	/* ICH up to UDMA 100 but with no MWDMA1*/
 	ich5_sata,
 	ich6_sata,
 	ich6m_sata,
@@ -216,8 +218,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH6 (and 6) (i915) UDMA 100 */
 	{ 0x8086, 0x266F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 	/* ICH7/7-R (i945, i975) UDMA 100*/
-	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
-	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
+	{ 0x8086, 0x27DF, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100_nomwdma1 },
+	{ 0x8086, 0x269E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100_nomwdma1 },
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
@@ -487,6 +489,15 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &ich_pata_ops,
 	},
 
+	[ich_pata_100_nomwdma1] =
+	{
+		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2_ONLY,
+		.udma_mask	= ATA_UDMA5,
+		.port_ops	= &ich_pata_ops,
+	},
+
 	[ich5_sata] =
 	{
 		.flags		= PIIX_SATA_FLAGS,
@@ -594,6 +605,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
 	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
 	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
+	{ 0x27df, 0x104d, 0x900e },	/* ICH7 on Sony TZ-90 */
 	/* end marker */
 	{ 0, }
 };
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 17c5d48..c924230 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4091,7 +4091,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 
 	/* fail early if !ATA && !ATAPI to avoid issuing [P]IDENTIFY to PMP */
 	if (ata_class_enabled(new_class) &&
-	    new_class != ATA_DEV_ATA && new_class != ATA_DEV_ATAPI) {
+	    new_class != ATA_DEV_ATA &&
+	    new_class != ATA_DEV_ATAPI &&
+	    new_class != ATA_DEV_SEMB) {
 		ata_dev_printk(dev, KERN_INFO, "class mismatch %u != %u\n",
 			       dev->class, new_class);
 		rc = -ENODEV;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0183131..94919ad 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2783,6 +2783,12 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 		} else if (dev->class == ATA_DEV_UNKNOWN &&
 			   ehc->tries[dev->devno] &&
 			   ata_class_enabled(ehc->classes[dev->devno])) {
+			/* Temporarily set dev->class, it will be
+			 * permanently set once all configurations are
+			 * complete.  This is necessary because new
+			 * device configuration is done in two
+			 * separate loops.
+			 */
 			dev->class = ehc->classes[dev->devno];
 
 			if (dev->class == ATA_DEV_PMP)
@@ -2790,6 +2796,11 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			else
 				rc = ata_dev_read_id(dev, &dev->class,
 						     readid_flags, dev->id);
+
+			/* read_id might have changed class, store and reset */
+			ehc->classes[dev->devno] = dev->class;
+			dev->class = ATA_DEV_UNKNOWN;
+
 			switch (rc) {
 			case 0:
 				/* clear error info accumulated during probe */
@@ -2799,13 +2810,11 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			case -ENOENT:
 				/* IDENTIFY was issued to non-existent
 				 * device.  No need to reset.  Just
-				 * thaw and kill the device.
+				 * thaw and ignore the device.
 				 */
 				ata_eh_thaw_port(ap);
-				dev->class = ATA_DEV_UNKNOWN;
 				break;
 			default:
-				dev->class = ATA_DEV_UNKNOWN;
 				goto err;
 			}
 		}
@@ -2826,11 +2835,15 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 		    dev->class == ATA_DEV_PMP)
 			continue;
 
+		dev->class = ehc->classes[dev->devno];
+
 		ehc->i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
 		ehc->i.flags &= ~ATA_EHI_PRINTINFO;
-		if (rc)
+		if (rc) {
+			dev->class = ATA_DEV_UNKNOWN;
 			goto err;
+		}
 
 		spin_lock_irqsave(ap->lock, flags);
 		ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
@@ -3494,6 +3507,8 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
  */
 static void ata_eh_handle_port_resume(struct ata_port *ap)
 {
+	struct ata_link *link;
+	struct ata_device *dev;
 	unsigned long flags;
 	int rc = 0;
 
@@ -3508,6 +3523,17 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 
 	WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));
 
+	/*
+	 * Error timestamps are in jiffies which doesn't run while
+	 * suspended and PHY events during resume isn't too uncommon.
+	 * When the two are combined, it can lead to unnecessary speed
+	 * downs if the machine is suspended and resumed repeatedly.
+	 * Clear error history.
+	 */
+	ata_for_each_link(link, ap, HOST_FIRST)
+		ata_for_each_dev(dev, link, ALL)
+			ata_ering_clear(&dev->ering);
+
 	ata_acpi_set_state(ap, PMSG_ON);
 
 	if (ap->ops->port_resume)
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2733b0c..68d9132 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -313,7 +313,7 @@ ata_scsi_em_message_show(struct device *dev, struct device_attribute *attr,
 		return ap->ops->em_show(ap, buf);
 	return -EINVAL;
 }
-DEVICE_ATTR(em_message, S_IRUGO | S_IWUGO,
+DEVICE_ATTR(em_message, S_IRUGO | S_IWUSR,
 		ata_scsi_em_message_show, ata_scsi_em_message_store);
 EXPORT_SYMBOL_GPL(dev_attr_em_message);
 
@@ -366,7 +366,7 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
 	}
 	return -EINVAL;
 }
-DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
+DEVICE_ATTR(sw_activity, S_IWUSR | S_IRUGO, ata_scsi_activity_show,
 			ata_scsi_activity_store);
 EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 5fedb3d..2f3c9be 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,7 +2,7 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2007 Bartlomiej Zolnierkiewicz
+ *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
@@ -158,7 +158,7 @@ static void pdc2026x_bmdma_start(struct ata_queued_cmd *qc)
 	u32 len;
 
 	/* Check we keep host level locking here */
-	if (adev->dma_mode >= XFER_UDMA_2)
+	if (adev->dma_mode > XFER_UDMA_2)
 		iowrite8(ioread8(clock) | sel66, clock);
 	else
 		iowrite8(ioread8(clock) & ~sel66, clock);
@@ -212,7 +212,7 @@ static void pdc2026x_bmdma_stop(struct ata_queued_cmd *qc)
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	}
 	/* Flip back to 33Mhz for PIO */
-	if (adev->dma_mode >= XFER_UDMA_2)
+	if (adev->dma_mode > XFER_UDMA_2)
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	ata_bmdma_stop(qc);
 	pdc202xx_set_piomode(ap, adev);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 870dcfd..23714ae 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -293,6 +293,10 @@ enum {
 	FISCFG_WAIT_DEV_ERR	= (1 << 8),	/* wait for host on DevErr */
 	FISCFG_SINGLE_SYNC	= (1 << 16),	/* SYNC on DMA activation */
 
+	PHY_MODE9_GEN2		= 0x398,
+	PHY_MODE9_GEN1		= 0x39c,
+	PHYCFG_OFS		= 0x3a0,	/* only in 65n devices */
+
 	MV5_PHY_MODE		= 0x74,
 	MV5_LTMODE		= 0x30,
 	MV5_PHY_CTL		= 0x0C,
@@ -609,6 +613,8 @@ static int mv_soc_reset_hc(struct mv_host_priv *hpriv,
 static void mv_soc_reset_flash(struct mv_host_priv *hpriv,
 				      void __iomem *mmio);
 static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio);
+static void mv_soc_65n_phy_errata(struct mv_host_priv *hpriv,
+				  void __iomem *mmio, unsigned int port);
 static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio);
 static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
@@ -807,6 +813,14 @@ static const struct mv_hw_ops mv_soc_ops = {
 	.reset_bus		= mv_soc_reset_bus,
 };
 
+static const struct mv_hw_ops mv_soc_65n_ops = {
+	.phy_errata		= mv_soc_65n_phy_errata,
+	.enable_leds		= mv_soc_enable_leds,
+	.reset_hc		= mv_soc_reset_hc,
+	.reset_flash		= mv_soc_reset_flash,
+	.reset_bus		= mv_soc_reset_bus,
+};
+
 /*
  * Functions
  */
@@ -3397,6 +3411,53 @@ static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio)
 	return;
 }
 
+static void mv_soc_65n_phy_errata(struct mv_host_priv *hpriv,
+				  void __iomem *mmio, unsigned int port)
+{
+	void __iomem *port_mmio = mv_port_base(mmio, port);
+	u32	reg;
+
+	reg = readl(port_mmio + PHY_MODE3);
+	reg &= ~(0x3 << 27);	/* SELMUPF (bits 28:27) to 1 */
+	reg |= (0x1 << 27);
+	reg &= ~(0x3 << 29);	/* SELMUPI (bits 30:29) to 1 */
+	reg |= (0x1 << 29);
+	writel(reg, port_mmio + PHY_MODE3);
+
+	reg = readl(port_mmio + PHY_MODE4);
+	reg &= ~0x1;	/* SATU_OD8 (bit 0) to 0, reserved bit 16 must be set */
+	reg |= (0x1 << 16);
+	writel(reg, port_mmio + PHY_MODE4);
+
+	reg = readl(port_mmio + PHY_MODE9_GEN2);
+	reg &= ~0xf;	/* TXAMP[3:0] (bits 3:0) to 8 */
+	reg |= 0x8;
+	reg &= ~(0x1 << 14);	/* TXAMP[4] (bit 14) to 0 */
+	writel(reg, port_mmio + PHY_MODE9_GEN2);
+
+	reg = readl(port_mmio + PHY_MODE9_GEN1);
+	reg &= ~0xf;	/* TXAMP[3:0] (bits 3:0) to 8 */
+	reg |= 0x8;
+	reg &= ~(0x1 << 14);	/* TXAMP[4] (bit 14) to 0 */
+	writel(reg, port_mmio + PHY_MODE9_GEN1);
+}
+
+/**
+ *	soc_is_65 - check if the soc is 65 nano device
+ *
+ *	Detect the type of the SoC, this is done by reading the PHYCFG_OFS
+ *	register, this register should contain non-zero value and it exists only
+ *	in the 65 nano devices, when reading it from older devices we get 0.
+ */
+static bool soc_is_65n(struct mv_host_priv *hpriv)
+{
+	void __iomem *port0_mmio = mv_port_base(hpriv->base, 0);
+
+	if (readl(port0_mmio + PHYCFG_OFS))
+		return true;
+	return false;
+}
+
 static void mv_setup_ifcfg(void __iomem *port_mmio, int want_gen2i)
 {
 	u32 ifcfg = readl(port_mmio + SATA_IFCFG);
@@ -3737,7 +3798,10 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		}
 		break;
 	case chip_soc:
-		hpriv->ops = &mv_soc_ops;
+		if (soc_is_65n(hpriv))
+			hpriv->ops = &mv_soc_65n_ops;
+		else
+			hpriv->ops = &mv_soc_ops;
 		hp_flags |= MV_HP_FLAG_SOC | MV_HP_GEN_IIE |
 			MV_HP_ERRATA_60X1C0;
 		break;
@@ -3800,7 +3864,8 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	n_hc = mv_get_hc_count(host->ports[0]->flags);
 
 	for (port = 0; port < host->n_ports; port++)
-		hpriv->ops->read_preamp(hpriv, port, mmio);
+		if (hpriv->ops->read_preamp)
+			hpriv->ops->read_preamp(hpriv, port, mmio);
 
 	rc = hpriv->ops->reset_hc(hpriv, mmio, n_hc);
 	if (rc)
