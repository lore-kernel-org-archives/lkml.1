Return-Path: <linux-kernel-owner+w=401wt.eu-S1764314AbYEFPtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764314AbYEFPtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758350AbYEFPsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:48:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55057 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbYEFPss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:48:48 -0400
Date: Tue, 6 May 2008 11:48:47 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080506154847.GA15299@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- sata_mv: continued fixing
- sata_inic: make it actually work
- new driver from Intel
- misc fixes from Tejun

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig         |   13 +-
 drivers/ata/Makefile        |    1 +
 drivers/ata/ahci.c          |    4 +-
 drivers/ata/ata_generic.c   |    6 +
 drivers/ata/ata_piix.c      |   25 ++
 drivers/ata/libata-core.c   |    1 +
 drivers/ata/libata-eh.c     |    2 +-
 drivers/ata/libata-sff.c    |    6 +-
 drivers/ata/pata_acpi.c     |    6 +
 drivers/ata/pata_sch.c      |  206 +++++++++++++
 drivers/ata/sata_inic162x.c |  646 ++++++++++++++++++++++++++--------------
 drivers/ata/sata_mv.c       |  688 +++++++++++++++++++++++++++++++++----------
 include/linux/libata.h      |   16 +
 13 files changed, 1222 insertions(+), 398 deletions(-)
 create mode 100644 drivers/ata/pata_sch.c

Alan Cox (1):
      pata_atiixp: Don't disable

Alek Du (1):
      libata: Add Intel SCH PATA driver

Mark Lord (13):
      sata_mv more cosmetic changes
      sata_mv pci features
      sata_mv wait for empty+idle
      sata_mv new mv_qc_defer method
      sata_mv errata workaround for sata25 part 1
      sata_mv rearrange mv_config_fbs
      sata_mv NCQ and SError fixes for mv_err_intr
      sata_mv fix mv_host_intr bug for hc_irq_cause
      sata_mv new mv_port_intr function
      libata: export ata_eh_analyze_ncq_error
      sata_mv delayed eh handling
      sata_mv NCQ-EH for FIS-based switching
      sata_mv use hweight16() for bit counting (V2)

Tejun Heo (12):
      libata: improve post-reset device ready test
      ata_piix: verify SIDPR access before enabling it
      sata_inic162x: misc clean ups
      sata_inic162x: add / update constants
      sata_inic162x: update TF read handling
      sata_inic162x: use IDMA for ATA_PROT_DMA
      sata_inic162x: kill now unused bmdma related stuff
      sata_inic162x: use IDMA for non DMA ATA commands
      sata_inic162x: use IDMA for ATAPI commands
      sata_inic162x: kill now unused SFF related stuff
      sata_inic162x: add cardbus support
      sata_inic162x: update intro comment, up the version and drop EXPERIMENTAL

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 1c11df9..9bf2986 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -205,8 +205,8 @@ config SATA_VITESSE
 	  If unsure, say N.
 
 config SATA_INIC162X
-	tristate "Initio 162x SATA support (HIGHLY EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Initio 162x SATA support"
+	depends on PCI
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
@@ -697,6 +697,15 @@ config PATA_SCC
 
 	  If unsure, say N.
 
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	depends on PCI
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
+
 config PATA_BF54X
 	tristate "Blackfin 54x ATAPI support"
 	depends on BF542 || BF548 || BF549
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index b693d82..674965f 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
 obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
 obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
+obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
 obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8cace9a..97f83fb 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1267,9 +1267,7 @@ static int ahci_check_ready(struct ata_link *link)
 	void __iomem *port_mmio = ahci_port_base(link->ap);
 	u8 status = readl(port_mmio + PORT_TFDATA) & 0xFF;
 
-	if (!(status & ATA_BUSY))
-		return 1;
-	return 0;
+	return ata_check_ready(status);
 }
 
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 47aeccd..75a406f 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -152,6 +152,12 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 		ata_pci_bmdma_clear_simplex(dev);
 
+	if (dev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(dev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(dev);
+	}
 	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
 }
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ea2c764..a9027b8 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1348,6 +1348,8 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	struct piix_host_priv *hpriv = host->private_data;
+	struct ata_device *dev0 = &host->ports[0]->link.device[0];
+	u32 scontrol;
 	int i;
 
 	/* check for availability */
@@ -1366,6 +1368,29 @@ static void __devinit piix_init_sidpr(struct ata_host *host)
 		return;
 
 	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
+
+	/* SCR access via SIDPR doesn't work on some configurations.
+	 * Give it a test drive by inhibiting power save modes which
+	 * we'll do anyway.
+	 */
+	scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+	/* if IPM is already 3, SCR access is probably working.  Don't
+	 * un-inhibit power save modes as BIOS might have inhibited
+	 * them for a reason.
+	 */
+	if ((scontrol & 0xf00) != 0x300) {
+		scontrol |= 0x300;
+		piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
+		scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
+
+		if ((scontrol & 0xf00) != 0x300) {
+			dev_printk(KERN_INFO, host->dev, "SCR access via "
+				   "SIDPR is available but doesn't work\n");
+			return;
+		}
+	}
+
 	host->ports[0]->ops = &piix_sidpr_sata_ops;
 	host->ports[1]->ops = &piix_sidpr_sata_ops;
 }
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3bc4885..927b692 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6292,6 +6292,7 @@ EXPORT_SYMBOL_GPL(ata_eh_freeze_port);
 EXPORT_SYMBOL_GPL(ata_eh_thaw_port);
 EXPORT_SYMBOL_GPL(ata_eh_qc_complete);
 EXPORT_SYMBOL_GPL(ata_eh_qc_retry);
+EXPORT_SYMBOL_GPL(ata_eh_analyze_ncq_error);
 EXPORT_SYMBOL_GPL(ata_do_eh);
 EXPORT_SYMBOL_GPL(ata_std_error_handler);
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 61dcd00..62e0331 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1357,7 +1357,7 @@ static void ata_eh_analyze_serror(struct ata_link *link)
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-static void ata_eh_analyze_ncq_error(struct ata_link *link)
+void ata_eh_analyze_ncq_error(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 2ec65a8..3c2d228 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -314,11 +314,7 @@ static int ata_sff_check_ready(struct ata_link *link)
 {
 	u8 status = link->ap->ops->sff_check_status(link->ap);
 
-	if (!(status & ATA_BUSY))
-		return 1;
-	if (status == 0xff)
-		return -ENODEV;
-	return 0;
+	return ata_check_ready(status);
 }
 
 /**
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index c5f91e6..fbe6057 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -259,6 +259,12 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops	= &pacpi_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
+	if (pdev->vendor == PCI_VENDOR_ID_ATI) {
+		int rc = pcim_enable_device(pdev);
+		if (rc < 0)
+			return rc;
+		pcim_pin_device(pdev);
+	}
 	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
 }
 
diff --git a/drivers/ata/pata_sch.c b/drivers/ata/pata_sch.c
new file mode 100644
index 0000000..c8cc027
--- /dev/null
+++ b/drivers/ata/pata_sch.c
@@ -0,0 +1,206 @@
+/*
+ *  pata_sch.c - Intel SCH PATA controllers
+ *
+ *  Copyright (c) 2008 Alek Du <alek.du@intel.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+/*
+ *  Supports:
+ *    Intel SCH (AF82US15W, AF82US15L, AF82UL11L) chipsets -- see spec at:
+ *    http://download.intel.com/design/chipsets/embedded/datashts/319537.pdf
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+#include <linux/dmi.h>
+
+#define DRV_NAME	"pata_sch"
+#define DRV_VERSION	"0.2"
+
+/* see SCH datasheet page 351 */
+enum {
+	D0TIM	= 0x80,		/* Device 0 Timing Register */
+	D1TIM	= 0x84,		/* Device 1 Timing Register */
+	PM	= 0x07,		/* PIO Mode Bit Mask */
+	MDM	= (0x03 << 8),	/* Multi-word DMA Mode Bit Mask */
+	UDM	= (0x07 << 16), /* Ultra DMA Mode Bit Mask */
+	PPE	= (1 << 30),	/* Prefetch/Post Enable */
+	USD	= (1 << 31),	/* Use Synchronous DMA */
+};
+
+static int sch_init_one(struct pci_dev *pdev,
+			 const struct pci_device_id *ent);
+static void sch_set_piomode(struct ata_port *ap, struct ata_device *adev);
+static void sch_set_dmamode(struct ata_port *ap, struct ata_device *adev);
+
+static const struct pci_device_id sch_pci_tbl[] = {
+	/* Intel SCH PATA Controller */
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_SCH_IDE), 0 },
+	{ }	/* terminate list */
+};
+
+static struct pci_driver sch_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= sch_pci_tbl,
+	.probe			= sch_init_one,
+	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= ata_pci_device_resume,
+#endif
+};
+
+static struct scsi_host_template sch_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations sch_pata_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+	.cable_detect		= ata_cable_unknown,
+	.set_piomode		= sch_set_piomode,
+	.set_dmamode		= sch_set_dmamode,
+};
+
+static struct ata_port_info sch_port_info = {
+	.flags		= 0,
+	.pio_mask	= ATA_PIO4,   /* pio0-4 */
+	.mwdma_mask	= ATA_MWDMA2, /* mwdma0-2 */
+	.udma_mask	= ATA_UDMA5,  /* udma0-5 */
+	.port_ops	= &sch_pata_ops,
+};
+
+MODULE_AUTHOR("Alek Du <alek.du@intel.com>");
+MODULE_DESCRIPTION("SCSI low-level driver for Intel SCH PATA controllers");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, sch_pci_tbl);
+MODULE_VERSION(DRV_VERSION);
+
+/**
+ *	sch_set_piomode - Initialize host controller PATA PIO timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: ATA device
+ *
+ *	Set PIO mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void sch_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int port	= adev->devno ? D1TIM : D0TIM;
+	unsigned int data;
+
+	pci_read_config_dword(dev, port, &data);
+	/* see SCH datasheet page 351 */
+	/* set PIO mode */
+	data &= ~(PM | PPE);
+	data |= pio;
+	/* enable PPE for block device */
+	if (adev->class == ATA_DEV_ATA)
+		data |= PPE;
+	pci_write_config_dword(dev, port, data);
+}
+
+/**
+ *	sch_set_dmamode - Initialize host controller PATA DMA timings
+ *	@ap: Port whose timings we are configuring
+ *	@adev: ATA device
+ *
+ *	Set MW/UDMA mode for device, in host controller PCI config space.
+ *
+ *	LOCKING:
+ *	None (inherited from caller).
+ */
+
+static void sch_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	unsigned int dma_mode	= adev->dma_mode;
+	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned int port	= adev->devno ? D1TIM : D0TIM;
+	unsigned int data;
+
+	pci_read_config_dword(dev, port, &data);
+	/* see SCH datasheet page 351 */
+	if (dma_mode >= XFER_UDMA_0) {
+		/* enable Synchronous DMA mode */
+		data |= USD;
+		data &= ~UDM;
+		data |= (dma_mode - XFER_UDMA_0) << 16;
+	} else { /* must be MWDMA mode, since we masked SWDMA already */
+		data &= ~(USD | MDM);
+		data |= (dma_mode - XFER_MW_DMA_0) << 8;
+	}
+	pci_write_config_dword(dev, port, data);
+}
+
+/**
+ *	sch_init_one - Register SCH ATA PCI device with kernel services
+ *	@pdev: PCI device to register
+ *	@ent: Entry in sch_pci_tbl matching with @pdev
+ *
+ *	LOCKING:
+ *	Inherited from PCI layer (may sleep).
+ *
+ *	RETURNS:
+ *	Zero on success, or -ERRNO value.
+ */
+
+static int __devinit sch_init_one(struct pci_dev *pdev,
+				   const struct pci_device_id *ent)
+{
+	static int printed_version;
+	const struct ata_port_info *ppi[] = { &sch_port_info, NULL };
+	struct ata_host *host;
+	int rc;
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev,
+			   "version " DRV_VERSION "\n");
+
+	/* enable device and prepare host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+	rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	pci_set_master(pdev);
+	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &sch_sht);
+}
+
+static int __init sch_init(void)
+{
+	return pci_register_driver(&sch_pci_driver);
+}
+
+static void __exit sch_exit(void)
+{
+	pci_unregister_driver(&sch_pci_driver);
+}
+
+module_init(sch_init);
+module_exit(sch_exit);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index d27bb9a..3ead02f 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -10,13 +10,33 @@
  * right.  Documentation is available at initio's website but it only
  * documents registers (not programming model).
  *
- * - ATA disks work.
- * - Hotplug works.
- * - ATAPI read works but burning doesn't.  This thing is really
- *   peculiar about ATAPI and I couldn't figure out how ATAPI PIO and
- *   ATAPI DMA WRITE should be programmed.  If you've got a clue, be
- *   my guest.
- * - Both STR and STD work.
+ * This driver has interesting history.  The first version was written
+ * from the documentation and a 2.4 IDE driver posted on a Taiwan
+ * company, which didn't use any IDMA features and couldn't handle
+ * LBA48.  The resulting driver couldn't handle LBA48 devices either
+ * making it pretty useless.
+ *
+ * After a while, initio picked the driver up, renamed it to
+ * sata_initio162x, updated it to use IDMA for ATA DMA commands and
+ * posted it on their website.  It only used ATA_PROT_DMA for IDMA and
+ * attaching both devices and issuing IDMA and !IDMA commands
+ * simultaneously broke it due to PIRQ masking interaction but it did
+ * show how to use the IDMA (ADMA + some initio specific twists)
+ * engine.
+ *
+ * Then, I picked up their changes again and here's the usable driver
+ * which uses IDMA for everything.  Everything works now including
+ * LBA48, CD/DVD burning, suspend/resume and hotplug.  There are some
+ * issues tho.  Result Tf is not resported properly, NCQ isn't
+ * supported yet and CD/DVD writing works with DMA assisted PIO
+ * protocol (which, for native SATA devices, shouldn't cause any
+ * noticeable difference).
+ *
+ * Anyways, so, here's finally a working driver for inic162x.  Enjoy!
+ *
+ * initio: If you guys wanna improve the driver regarding result TF
+ * access and other stuff, please feel free to contact me.  I'll be
+ * happy to assist.
  */
 
 #include <linux/kernel.h>
@@ -28,13 +48,19 @@
 #include <scsi/scsi_device.h>
 
 #define DRV_NAME	"sata_inic162x"
-#define DRV_VERSION	"0.3"
+#define DRV_VERSION	"0.4"
 
 enum {
-	MMIO_BAR		= 5,
+	MMIO_BAR_PCI		= 5,
+	MMIO_BAR_CARDBUS	= 1,
 
 	NR_PORTS		= 2,
 
+	IDMA_CPB_TBL_SIZE	= 4 * 32,
+
+	INIC_DMA_BOUNDARY	= 0xffffff,
+
+	HOST_ACTRL		= 0x08,
 	HOST_CTL		= 0x7c,
 	HOST_STAT		= 0x7e,
 	HOST_IRQ_STAT		= 0xbc,
@@ -43,22 +69,37 @@ enum {
 	PORT_SIZE		= 0x40,
 
 	/* registers for ATA TF operation */
-	PORT_TF			= 0x00,
-	PORT_ALT_STAT		= 0x08,
+	PORT_TF_DATA		= 0x00,
+	PORT_TF_FEATURE		= 0x01,
+	PORT_TF_NSECT		= 0x02,
+	PORT_TF_LBAL		= 0x03,
+	PORT_TF_LBAM		= 0x04,
+	PORT_TF_LBAH		= 0x05,
+	PORT_TF_DEVICE		= 0x06,
+	PORT_TF_COMMAND		= 0x07,
+	PORT_TF_ALT_STAT	= 0x08,
 	PORT_IRQ_STAT		= 0x09,
 	PORT_IRQ_MASK		= 0x0a,
 	PORT_PRD_CTL		= 0x0b,
 	PORT_PRD_ADDR		= 0x0c,
 	PORT_PRD_XFERLEN	= 0x10,
+	PORT_CPB_CPBLAR		= 0x18,
+	PORT_CPB_PTQFIFO	= 0x1c,
 
 	/* IDMA register */
 	PORT_IDMA_CTL		= 0x14,
+	PORT_IDMA_STAT		= 0x16,
+
+	PORT_RPQ_FIFO		= 0x1e,
+	PORT_RPQ_CNT		= 0x1f,
 
 	PORT_SCR		= 0x20,
 
 	/* HOST_CTL bits */
 	HCTL_IRQOFF		= (1 << 8),  /* global IRQ off */
-	HCTL_PWRDWN		= (1 << 13), /* power down PHYs */
+	HCTL_FTHD0		= (1 << 10), /* fifo threshold 0 */
+	HCTL_FTHD1		= (1 << 11), /* fifo threshold 1*/
+	HCTL_PWRDWN		= (1 << 12), /* power down PHYs */
 	HCTL_SOFTRST		= (1 << 13), /* global reset (no phy reset) */
 	HCTL_RPGSEL		= (1 << 15), /* register page select */
 
@@ -81,9 +122,7 @@ enum {
 	PIRQ_PENDING		= (1 << 7),  /* port IRQ pending (STAT only) */
 
 	PIRQ_ERR		= PIRQ_OFFLINE | PIRQ_ONLINE | PIRQ_FATAL,
-
-	PIRQ_MASK_DMA_READ	= PIRQ_REPLY | PIRQ_ATA,
-	PIRQ_MASK_OTHER		= PIRQ_REPLY | PIRQ_COMPLETE,
+	PIRQ_MASK_DEFAULT	= PIRQ_REPLY | PIRQ_ATA,
 	PIRQ_MASK_FREEZE	= 0xff,
 
 	/* PORT_PRD_CTL bits */
@@ -96,20 +135,104 @@ enum {
 	IDMA_CTL_RST_IDMA	= (1 << 5),  /* reset IDMA machinary */
 	IDMA_CTL_GO		= (1 << 7),  /* IDMA mode go */
 	IDMA_CTL_ATA_NIEN	= (1 << 8),  /* ATA IRQ disable */
+
+	/* PORT_IDMA_STAT bits */
+	IDMA_STAT_PERR		= (1 << 0),  /* PCI ERROR MODE */
+	IDMA_STAT_CPBERR	= (1 << 1),  /* ADMA CPB error */
+	IDMA_STAT_LGCY		= (1 << 3),  /* ADMA legacy */
+	IDMA_STAT_UIRQ		= (1 << 4),  /* ADMA unsolicited irq */
+	IDMA_STAT_STPD		= (1 << 5),  /* ADMA stopped */
+	IDMA_STAT_PSD		= (1 << 6),  /* ADMA pause */
+	IDMA_STAT_DONE		= (1 << 7),  /* ADMA done */
+
+	IDMA_STAT_ERR		= IDMA_STAT_PERR | IDMA_STAT_CPBERR,
+
+	/* CPB Control Flags*/
+	CPB_CTL_VALID		= (1 << 0),  /* CPB valid */
+	CPB_CTL_QUEUED		= (1 << 1),  /* queued command */
+	CPB_CTL_DATA		= (1 << 2),  /* data, rsvd in datasheet */
+	CPB_CTL_IEN		= (1 << 3),  /* PCI interrupt enable */
+	CPB_CTL_DEVDIR		= (1 << 4),  /* device direction control */
+
+	/* CPB Response Flags */
+	CPB_RESP_DONE		= (1 << 0),  /* ATA command complete */
+	CPB_RESP_REL		= (1 << 1),  /* ATA release */
+	CPB_RESP_IGNORED	= (1 << 2),  /* CPB ignored */
+	CPB_RESP_ATA_ERR	= (1 << 3),  /* ATA command error */
+	CPB_RESP_SPURIOUS	= (1 << 4),  /* ATA spurious interrupt error */
+	CPB_RESP_UNDERFLOW	= (1 << 5),  /* APRD deficiency length error */
+	CPB_RESP_OVERFLOW	= (1 << 6),  /* APRD exccess length error */
+	CPB_RESP_CPB_ERR	= (1 << 7),  /* CPB error flag */
+
+	/* PRD Control Flags */
+	PRD_DRAIN		= (1 << 1),  /* ignore data excess */
+	PRD_CDB			= (1 << 2),  /* atapi packet command pointer */
+	PRD_DIRECT_INTR		= (1 << 3),  /* direct interrupt */
+	PRD_DMA			= (1 << 4),  /* data transfer method */
+	PRD_WRITE		= (1 << 5),  /* data dir, rsvd in datasheet */
+	PRD_IOM			= (1 << 6),  /* io/memory transfer */
+	PRD_END			= (1 << 7),  /* APRD chain end */
 };
 
+/* Comman Parameter Block */
+struct inic_cpb {
+	u8		resp_flags;	/* Response Flags */
+	u8		error;		/* ATA Error */
+	u8		status;		/* ATA Status */
+	u8		ctl_flags;	/* Control Flags */
+	__le32		len;		/* Total Transfer Length */
+	__le32		prd;		/* First PRD pointer */
+	u8		rsvd[4];
+	/* 16 bytes */
+	u8		feature;	/* ATA Feature */
+	u8		hob_feature;	/* ATA Ex. Feature */
+	u8		device;		/* ATA Device/Head */
+	u8		mirctl;		/* Mirror Control */
+	u8		nsect;		/* ATA Sector Count */
+	u8		hob_nsect;	/* ATA Ex. Sector Count */
+	u8		lbal;		/* ATA Sector Number */
+	u8		hob_lbal;	/* ATA Ex. Sector Number */
+	u8		lbam;		/* ATA Cylinder Low */
+	u8		hob_lbam;	/* ATA Ex. Cylinder Low */
+	u8		lbah;		/* ATA Cylinder High */
+	u8		hob_lbah;	/* ATA Ex. Cylinder High */
+	u8		command;	/* ATA Command */
+	u8		ctl;		/* ATA Control */
+	u8		slave_error;	/* Slave ATA Error */
+	u8		slave_status;	/* Slave ATA Status */
+	/* 32 bytes */
+} __packed;
+
+/* Physical Region Descriptor */
+struct inic_prd {
+	__le32		mad;		/* Physical Memory Address */
+	__le16		len;		/* Transfer Length */
+	u8		rsvd;
+	u8		flags;		/* Control Flags */
+} __packed;
+
+struct inic_pkt {
+	struct inic_cpb	cpb;
+	struct inic_prd	prd[LIBATA_MAX_PRD + 1];	/* + 1 for cdb */
+	u8		cdb[ATAPI_CDB_LEN];
+} __packed;
+
 struct inic_host_priv {
-	u16	cached_hctl;
+	void __iomem	*mmio_base;
+	u16		cached_hctl;
 };
 
 struct inic_port_priv {
-	u8	dfl_prdctl;
-	u8	cached_prdctl;
-	u8	cached_pirq_mask;
+	struct inic_pkt	*pkt;
+	dma_addr_t	pkt_dma;
+	u32		*cpb_tbl;
+	dma_addr_t	cpb_tbl_dma;
 };
 
 static struct scsi_host_template inic_sht = {
-	ATA_BMDMA_SHT(DRV_NAME),
+	ATA_BASE_SHT(DRV_NAME),
+	.sg_tablesize	= LIBATA_MAX_PRD,	/* maybe it can be larger? */
+	.dma_boundary	= INIC_DMA_BOUNDARY,
 };
 
 static const int scr_map[] = {
@@ -120,54 +243,34 @@ static const int scr_map[] = {
 
 static void __iomem *inic_port_base(struct ata_port *ap)
 {
-	return ap->host->iomap[MMIO_BAR] + ap->port_no * PORT_SIZE;
-}
-
-static void __inic_set_pirq_mask(struct ata_port *ap, u8 mask)
-{
-	void __iomem *port_base = inic_port_base(ap);
-	struct inic_port_priv *pp = ap->private_data;
+	struct inic_host_priv *hpriv = ap->host->private_data;
 
-	writeb(mask, port_base + PORT_IRQ_MASK);
-	pp->cached_pirq_mask = mask;
-}
-
-static void inic_set_pirq_mask(struct ata_port *ap, u8 mask)
-{
-	struct inic_port_priv *pp = ap->private_data;
-
-	if (pp->cached_pirq_mask != mask)
-		__inic_set_pirq_mask(ap, mask);
+	return hpriv->mmio_base + ap->port_no * PORT_SIZE;
 }
 
 static void inic_reset_port(void __iomem *port_base)
 {
 	void __iomem *idma_ctl = port_base + PORT_IDMA_CTL;
-	u16 ctl;
 
-	ctl = readw(idma_ctl);
-	ctl &= ~(IDMA_CTL_RST_IDMA | IDMA_CTL_ATA_NIEN | IDMA_CTL_GO);
+	/* stop IDMA engine */
+	readw(idma_ctl); /* flush */
+	msleep(1);
 
 	/* mask IRQ and assert reset */
-	writew(ctl | IDMA_CTL_RST_IDMA | IDMA_CTL_ATA_NIEN, idma_ctl);
+	writew(IDMA_CTL_RST_IDMA, idma_ctl);
 	readw(idma_ctl); /* flush */
-
-	/* give it some time */
 	msleep(1);
 
 	/* release reset */
-	writew(ctl | IDMA_CTL_ATA_NIEN, idma_ctl);
+	writew(0, idma_ctl);
 
 	/* clear irq */
 	writeb(0xff, port_base + PORT_IRQ_STAT);
-
-	/* reenable ATA IRQ, turn off IDMA mode */
-	writew(ctl, idma_ctl);
 }
 
 static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 {
-	void __iomem *scr_addr = ap->ioaddr.scr_addr;
+	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
 	void __iomem *addr;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
@@ -184,120 +287,126 @@ static int inic_scr_read(struct ata_port *ap, unsigned sc_reg, u32 *val)
 
 static int inic_scr_write(struct ata_port *ap, unsigned sc_reg, u32 val)
 {
-	void __iomem *scr_addr = ap->ioaddr.scr_addr;
-	void __iomem *addr;
+	void __iomem *scr_addr = inic_port_base(ap) + PORT_SCR;
 
 	if (unlikely(sc_reg >= ARRAY_SIZE(scr_map)))
 		return -EINVAL;
 
-	addr = scr_addr + scr_map[sc_reg] * 4;
 	writel(val, scr_addr + scr_map[sc_reg] * 4);
 	return 0;
 }
 
-/*
- * In TF mode, inic162x is very similar to SFF device.  TF registers
- * function the same.  DMA engine behaves similary using the same PRD
- * format as BMDMA but different command register, interrupt and event
- * notification methods are used.  The following inic_bmdma_*()
- * functions do the impedance matching.
- */
-static void inic_bmdma_setup(struct ata_queued_cmd *qc)
+static void inic_stop_idma(struct ata_port *ap)
 {
-	struct ata_port *ap = qc->ap;
-	struct inic_port_priv *pp = ap->private_data;
 	void __iomem *port_base = inic_port_base(ap);
-	int rw = qc->tf.flags & ATA_TFLAG_WRITE;
-
-	/* make sure device sees PRD table writes */
-	wmb();
-
-	/* load transfer length */
-	writel(qc->nbytes, port_base + PORT_PRD_XFERLEN);
-
-	/* turn on DMA and specify data direction */
-	pp->cached_prdctl = pp->dfl_prdctl | PRD_CTL_DMAEN;
-	if (!rw)
-		pp->cached_prdctl |= PRD_CTL_WR;
-	writeb(pp->cached_prdctl, port_base + PORT_PRD_CTL);
 
-	/* issue r/w command */
-	ap->ops->sff_exec_command(ap, &qc->tf);
+	readb(port_base + PORT_RPQ_FIFO);
+	readb(port_base + PORT_RPQ_CNT);
+	writew(0, port_base + PORT_IDMA_CTL);
 }
 
-static void inic_bmdma_start(struct ata_queued_cmd *qc)
+static void inic_host_err_intr(struct ata_port *ap, u8 irq_stat, u16 idma_stat)
 {
-	struct ata_port *ap = qc->ap;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
 	struct inic_port_priv *pp = ap->private_data;
-	void __iomem *port_base = inic_port_base(ap);
+	struct inic_cpb *cpb = &pp->pkt->cpb;
+	bool freeze = false;
 
-	/* start host DMA transaction */
-	pp->cached_prdctl |= PRD_CTL_START;
-	writeb(pp->cached_prdctl, port_base + PORT_PRD_CTL);
-}
+	ata_ehi_clear_desc(ehi);
+	ata_ehi_push_desc(ehi, "irq_stat=0x%x idma_stat=0x%x",
+			  irq_stat, idma_stat);
 
-static void inic_bmdma_stop(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct inic_port_priv *pp = ap->private_data;
-	void __iomem *port_base = inic_port_base(ap);
+	inic_stop_idma(ap);
 
-	/* stop DMA engine */
-	writeb(pp->dfl_prdctl, port_base + PORT_PRD_CTL);
-}
+	if (irq_stat & (PIRQ_OFFLINE | PIRQ_ONLINE)) {
+		ata_ehi_push_desc(ehi, "hotplug");
+		ata_ehi_hotplugged(ehi);
+		freeze = true;
+	}
 
-static u8 inic_bmdma_status(struct ata_port *ap)
-{
-	/* event is already verified by the interrupt handler */
-	return ATA_DMA_INTR;
+	if (idma_stat & IDMA_STAT_PERR) {
+		ata_ehi_push_desc(ehi, "PCI error");
+		freeze = true;
+	}
+
+	if (idma_stat & IDMA_STAT_CPBERR) {
+		ata_ehi_push_desc(ehi, "CPB error");
+
+		if (cpb->resp_flags & CPB_RESP_IGNORED) {
+			__ata_ehi_push_desc(ehi, " ignored");
+			ehi->err_mask |= AC_ERR_INVALID;
+			freeze = true;
+		}
+
+		if (cpb->resp_flags & CPB_RESP_ATA_ERR)
+			ehi->err_mask |= AC_ERR_DEV;
+
+		if (cpb->resp_flags & CPB_RESP_SPURIOUS) {
+			__ata_ehi_push_desc(ehi, " spurious-intr");
+			ehi->err_mask |= AC_ERR_HSM;
+			freeze = true;
+		}
+
+		if (cpb->resp_flags &
+		    (CPB_RESP_UNDERFLOW | CPB_RESP_OVERFLOW)) {
+			__ata_ehi_push_desc(ehi, " data-over/underflow");
+			ehi->err_mask |= AC_ERR_HSM;
+			freeze = true;
+		}
+	}
+
+	if (freeze)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
 }
 
 static void inic_host_intr(struct ata_port *ap)
 {
 	void __iomem *port_base = inic_port_base(ap);
-	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
 	u8 irq_stat;
+	u16 idma_stat;
 
-	/* fetch and clear irq */
+	/* read and clear IRQ status */
 	irq_stat = readb(port_base + PORT_IRQ_STAT);
 	writeb(irq_stat, port_base + PORT_IRQ_STAT);
+	idma_stat = readw(port_base + PORT_IDMA_STAT);
 
-	if (likely(!(irq_stat & PIRQ_ERR))) {
-		struct ata_queued_cmd *qc =
-			ata_qc_from_tag(ap, ap->link.active_tag);
+	if (unlikely((irq_stat & PIRQ_ERR) || (idma_stat & IDMA_STAT_ERR)))
+		inic_host_err_intr(ap, irq_stat, idma_stat);
 
-		if (unlikely(!qc || (qc->tf.flags & ATA_TFLAG_POLLING))) {
-			ap->ops->sff_check_status(ap); /* clear ATA interrupt */
-			return;
-		}
+	if (unlikely(!qc))
+		goto spurious;
 
-		if (likely(ata_sff_host_intr(ap, qc)))
-			return;
+	if (likely(idma_stat & IDMA_STAT_DONE)) {
+		inic_stop_idma(ap);
 
-		ap->ops->sff_check_status(ap); /* clear ATA interrupt */
-		ata_port_printk(ap, KERN_WARNING, "unhandled "
-				"interrupt, irq_stat=%x\n", irq_stat);
+		/* Depending on circumstances, device error
+		 * isn't reported by IDMA, check it explicitly.
+		 */
+		if (unlikely(readb(port_base + PORT_TF_COMMAND) &
+			     (ATA_DF | ATA_ERR)))
+			qc->err_mask |= AC_ERR_DEV;
+
+		ata_qc_complete(qc);
 		return;
 	}
 
-	/* error */
-	ata_ehi_push_desc(ehi, "irq_stat=0x%x", irq_stat);
-
-	if (irq_stat & (PIRQ_OFFLINE | PIRQ_ONLINE)) {
-		ata_ehi_hotplugged(ehi);
-		ata_port_freeze(ap);
-	} else
-		ata_port_abort(ap);
+ spurious:
+	ata_port_printk(ap, KERN_WARNING, "unhandled interrupt: "
+			"cmd=0x%x irq_stat=0x%x idma_stat=0x%x\n",
+			qc ? qc->tf.command : 0xff, irq_stat, idma_stat);
 }
 
 static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
-	void __iomem *mmio_base = host->iomap[MMIO_BAR];
+	struct inic_host_priv *hpriv = host->private_data;
 	u16 host_irq_stat;
 	int i, handled = 0;;
 
-	host_irq_stat = readw(mmio_base + HOST_IRQ_STAT);
+	host_irq_stat = readw(hpriv->mmio_base + HOST_IRQ_STAT);
 
 	if (unlikely(!(host_irq_stat & HIRQ_GLOBAL)))
 		goto out;
@@ -327,60 +436,173 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 	return IRQ_RETVAL(handled);
 }
 
+static int inic_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	/* For some reason ATAPI_PROT_DMA doesn't work for some
+	 * commands including writes and other misc ops.  Use PIO
+	 * protocol instead, which BTW is driven by the DMA engine
+	 * anyway, so it shouldn't make much difference for native
+	 * SATA devices.
+	 */
+	if (atapi_cmd_type(qc->cdb[0]) == READ)
+		return 0;
+	return 1;
+}
+
+static void inic_fill_sg(struct inic_prd *prd, struct ata_queued_cmd *qc)
+{
+	struct scatterlist *sg;
+	unsigned int si;
+	u8 flags = 0;
+
+	if (qc->tf.flags & ATA_TFLAG_WRITE)
+		flags |= PRD_WRITE;
+
+	if (ata_is_dma(qc->tf.protocol))
+		flags |= PRD_DMA;
+
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		prd->mad = cpu_to_le32(sg_dma_address(sg));
+		prd->len = cpu_to_le16(sg_dma_len(sg));
+		prd->flags = flags;
+		prd++;
+	}
+
+	WARN_ON(!si);
+	prd[-1].flags |= PRD_END;
+}
+
+static void inic_qc_prep(struct ata_queued_cmd *qc)
+{
+	struct inic_port_priv *pp = qc->ap->private_data;
+	struct inic_pkt *pkt = pp->pkt;
+	struct inic_cpb *cpb = &pkt->cpb;
+	struct inic_prd *prd = pkt->prd;
+	bool is_atapi = ata_is_atapi(qc->tf.protocol);
+	bool is_data = ata_is_data(qc->tf.protocol);
+	unsigned int cdb_len = 0;
+
+	VPRINTK("ENTER\n");
+
+	if (is_atapi)
+		cdb_len = qc->dev->cdb_len;
+
+	/* prepare packet, based on initio driver */
+	memset(pkt, 0, sizeof(struct inic_pkt));
+
+	cpb->ctl_flags = CPB_CTL_VALID | CPB_CTL_IEN;
+	if (is_atapi || is_data)
+		cpb->ctl_flags |= CPB_CTL_DATA;
+
+	cpb->len = cpu_to_le32(qc->nbytes + cdb_len);
+	cpb->prd = cpu_to_le32(pp->pkt_dma + offsetof(struct inic_pkt, prd));
+
+	cpb->device = qc->tf.device;
+	cpb->feature = qc->tf.feature;
+	cpb->nsect = qc->tf.nsect;
+	cpb->lbal = qc->tf.lbal;
+	cpb->lbam = qc->tf.lbam;
+	cpb->lbah = qc->tf.lbah;
+
+	if (qc->tf.flags & ATA_TFLAG_LBA48) {
+		cpb->hob_feature = qc->tf.hob_feature;
+		cpb->hob_nsect = qc->tf.hob_nsect;
+		cpb->hob_lbal = qc->tf.hob_lbal;
+		cpb->hob_lbam = qc->tf.hob_lbam;
+		cpb->hob_lbah = qc->tf.hob_lbah;
+	}
+
+	cpb->command = qc->tf.command;
+	/* don't load ctl - dunno why.  it's like that in the initio driver */
+
+	/* setup PRD for CDB */
+	if (is_atapi) {
+		memcpy(pkt->cdb, qc->cdb, ATAPI_CDB_LEN);
+		prd->mad = cpu_to_le32(pp->pkt_dma +
+				       offsetof(struct inic_pkt, cdb));
+		prd->len = cpu_to_le16(cdb_len);
+		prd->flags = PRD_CDB | PRD_WRITE;
+		if (!is_data)
+			prd->flags |= PRD_END;
+		prd++;
+	}
+
+	/* setup sg table */
+	if (is_data)
+		inic_fill_sg(prd, qc);
+
+	pp->cpb_tbl[0] = pp->pkt_dma;
+}
+
 static unsigned int inic_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	void __iomem *port_base = inic_port_base(ap);
 
-	/* ATA IRQ doesn't wait for DMA transfer completion and vice
-	 * versa.  Mask IRQ selectively to detect command completion.
-	 * Without it, ATA DMA read command can cause data corruption.
-	 *
-	 * Something similar might be needed for ATAPI writes.  I
-	 * tried a lot of combinations but couldn't find the solution.
-	 */
-	if (qc->tf.protocol == ATA_PROT_DMA &&
-	    !(qc->tf.flags & ATA_TFLAG_WRITE))
-		inic_set_pirq_mask(ap, PIRQ_MASK_DMA_READ);
-	else
-		inic_set_pirq_mask(ap, PIRQ_MASK_OTHER);
+	/* fire up the ADMA engine */
+	writew(HCTL_FTHD0, port_base + HOST_CTL);
+	writew(IDMA_CTL_GO, port_base + PORT_IDMA_CTL);
+	writeb(0, port_base + PORT_CPB_PTQFIFO);
+
+	return 0;
+}
+
+static void inic_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	void __iomem *port_base = inic_port_base(ap);
+
+	tf->feature	= readb(port_base + PORT_TF_FEATURE);
+	tf->nsect	= readb(port_base + PORT_TF_NSECT);
+	tf->lbal	= readb(port_base + PORT_TF_LBAL);
+	tf->lbam	= readb(port_base + PORT_TF_LBAM);
+	tf->lbah	= readb(port_base + PORT_TF_LBAH);
+	tf->device	= readb(port_base + PORT_TF_DEVICE);
+	tf->command	= readb(port_base + PORT_TF_COMMAND);
+}
 
-	/* Issuing a command to yet uninitialized port locks up the
-	 * controller.  Most of the time, this happens for the first
-	 * command after reset which are ATA and ATAPI IDENTIFYs.
-	 * Fast fail if stat is 0x7f or 0xff for those commands.
+static bool inic_qc_fill_rtf(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *rtf = &qc->result_tf;
+	struct ata_taskfile tf;
+
+	/* FIXME: Except for status and error, result TF access
+	 * doesn't work.  I tried reading from BAR0/2, CPB and BAR5.
+	 * None works regardless of which command interface is used.
+	 * For now return true iff status indicates device error.
+	 * This means that we're reporting bogus sector for RW
+	 * failures.  Eeekk....
 	 */
-	if (unlikely(qc->tf.command == ATA_CMD_ID_ATA ||
-		     qc->tf.command == ATA_CMD_ID_ATAPI)) {
-		u8 stat = ap->ops->sff_check_status(ap);
-		if (stat == 0x7f || stat == 0xff)
-			return AC_ERR_HSM;
-	}
+	inic_tf_read(qc->ap, &tf);
 
-	return ata_sff_qc_issue(qc);
+	if (!(tf.command & ATA_ERR))
+		return false;
+
+	rtf->command = tf.command;
+	rtf->feature = tf.feature;
+	return true;
 }
 
 static void inic_freeze(struct ata_port *ap)
 {
 	void __iomem *port_base = inic_port_base(ap);
 
-	__inic_set_pirq_mask(ap, PIRQ_MASK_FREEZE);
-
-	ap->ops->sff_check_status(ap);
+	writeb(PIRQ_MASK_FREEZE, port_base + PORT_IRQ_MASK);
 	writeb(0xff, port_base + PORT_IRQ_STAT);
-
-	readb(port_base + PORT_IRQ_STAT); /* flush */
 }
 
 static void inic_thaw(struct ata_port *ap)
 {
 	void __iomem *port_base = inic_port_base(ap);
 
-	ap->ops->sff_check_status(ap);
 	writeb(0xff, port_base + PORT_IRQ_STAT);
+	writeb(PIRQ_MASK_DEFAULT, port_base + PORT_IRQ_MASK);
+}
 
-	__inic_set_pirq_mask(ap, PIRQ_MASK_OTHER);
+static int inic_check_ready(struct ata_link *link)
+{
+	void __iomem *port_base = inic_port_base(link->ap);
 
-	readb(port_base + PORT_IRQ_STAT); /* flush */
+	return ata_check_ready(readb(port_base + PORT_TF_COMMAND));
 }
 
 /*
@@ -394,17 +616,15 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 	void __iomem *port_base = inic_port_base(ap);
 	void __iomem *idma_ctl = port_base + PORT_IDMA_CTL;
 	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
-	u16 val;
 	int rc;
 
 	/* hammer it into sane state */
 	inic_reset_port(port_base);
 
-	val = readw(idma_ctl);
-	writew(val | IDMA_CTL_RST_ATA, idma_ctl);
+	writew(IDMA_CTL_RST_ATA, idma_ctl);
 	readw(idma_ctl);	/* flush */
 	msleep(1);
-	writew(val & ~IDMA_CTL_RST_ATA, idma_ctl);
+	writew(0, idma_ctl);
 
 	rc = sata_link_resume(link, timing, deadline);
 	if (rc) {
@@ -418,7 +638,7 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 		struct ata_taskfile tf;
 
 		/* wait for link to become ready */
-		rc = ata_sff_wait_after_reset(link, 1, deadline);
+		rc = ata_wait_after_reset(link, deadline, inic_check_ready);
 		/* link occupied, -ENODEV too is an error */
 		if (rc) {
 			ata_link_printk(link, KERN_WARNING, "device not ready "
@@ -426,7 +646,7 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 			return rc;
 		}
 
-		ata_sff_tf_read(ap, &tf);
+		inic_tf_read(ap, &tf);
 		*class = ata_dev_classify(&tf);
 	}
 
@@ -436,18 +656,8 @@ static int inic_hardreset(struct ata_link *link, unsigned int *class,
 static void inic_error_handler(struct ata_port *ap)
 {
 	void __iomem *port_base = inic_port_base(ap);
-	struct inic_port_priv *pp = ap->private_data;
-	unsigned long flags;
 
-	/* reset PIO HSM and stop DMA engine */
 	inic_reset_port(port_base);
-
-	spin_lock_irqsave(ap->lock, flags);
-	ap->hsm_task_state = HSM_ST_IDLE;
-	writeb(pp->dfl_prdctl, port_base + PORT_PRD_CTL);
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	/* PIO and DMA engines have been stopped, perform recovery */
 	ata_std_error_handler(ap);
 }
 
@@ -458,26 +668,18 @@ static void inic_post_internal_cmd(struct ata_queued_cmd *qc)
 		inic_reset_port(inic_port_base(qc->ap));
 }
 
-static void inic_dev_config(struct ata_device *dev)
-{
-	/* inic can only handle upto LBA28 max sectors */
-	if (dev->max_sectors > ATA_MAX_SECTORS)
-		dev->max_sectors = ATA_MAX_SECTORS;
-
-	if (dev->n_sectors >= 1 << 28) {
-		ata_dev_printk(dev, KERN_ERR,
-	"ERROR: This driver doesn't support LBA48 yet and may cause\n"
-	"                data corruption on such devices.  Disabling.\n");
-		ata_dev_disable(dev);
-	}
-}
-
 static void init_port(struct ata_port *ap)
 {
 	void __iomem *port_base = inic_port_base(ap);
+	struct inic_port_priv *pp = ap->private_data;
 
-	/* Setup PRD address */
+	/* clear packet and CPB table */
+	memset(pp->pkt, 0, sizeof(struct inic_pkt));
+	memset(pp->cpb_tbl, 0, IDMA_CPB_TBL_SIZE);
+
+	/* setup PRD and CPB lookup table addresses */
 	writel(ap->prd_dma, port_base + PORT_PRD_ADDR);
+	writel(pp->cpb_tbl_dma, port_base + PORT_CPB_CPBLAR);
 }
 
 static int inic_port_resume(struct ata_port *ap)
@@ -488,28 +690,30 @@ static int inic_port_resume(struct ata_port *ap)
 
 static int inic_port_start(struct ata_port *ap)
 {
-	void __iomem *port_base = inic_port_base(ap);
+	struct device *dev = ap->host->dev;
 	struct inic_port_priv *pp;
-	u8 tmp;
 	int rc;
 
 	/* alloc and initialize private data */
-	pp = devm_kzalloc(ap->host->dev, sizeof(*pp), GFP_KERNEL);
+	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 	ap->private_data = pp;
 
-	/* default PRD_CTL value, DMAEN, WR and START off */
-	tmp = readb(port_base + PORT_PRD_CTL);
-	tmp &= ~(PRD_CTL_DMAEN | PRD_CTL_WR | PRD_CTL_START);
-	pp->dfl_prdctl = tmp;
-
 	/* Alloc resources */
 	rc = ata_port_start(ap);
-	if (rc) {
-		kfree(pp);
+	if (rc)
 		return rc;
-	}
+
+	pp->pkt = dmam_alloc_coherent(dev, sizeof(struct inic_pkt),
+				      &pp->pkt_dma, GFP_KERNEL);
+	if (!pp->pkt)
+		return -ENOMEM;
+
+	pp->cpb_tbl = dmam_alloc_coherent(dev, IDMA_CPB_TBL_SIZE,
+					  &pp->cpb_tbl_dma, GFP_KERNEL);
+	if (!pp->cpb_tbl)
+		return -ENOMEM;
 
 	init_port(ap);
 
@@ -517,21 +721,18 @@ static int inic_port_start(struct ata_port *ap)
 }
 
 static struct ata_port_operations inic_port_ops = {
-	.inherits		= &ata_sff_port_ops,
+	.inherits		= &sata_port_ops,
 
-	.bmdma_setup		= inic_bmdma_setup,
-	.bmdma_start		= inic_bmdma_start,
-	.bmdma_stop		= inic_bmdma_stop,
-	.bmdma_status		= inic_bmdma_status,
+	.check_atapi_dma	= inic_check_atapi_dma,
+	.qc_prep		= inic_qc_prep,
 	.qc_issue		= inic_qc_issue,
+	.qc_fill_rtf		= inic_qc_fill_rtf,
 
 	.freeze			= inic_freeze,
 	.thaw			= inic_thaw,
-	.softreset		= ATA_OP_NULL,	/* softreset is broken */
 	.hardreset		= inic_hardreset,
 	.error_handler		= inic_error_handler,
 	.post_internal_cmd	= inic_post_internal_cmd,
-	.dev_config		= inic_dev_config,
 
 	.scr_read		= inic_scr_read,
 	.scr_write		= inic_scr_write,
@@ -541,12 +742,6 @@ static struct ata_port_operations inic_port_ops = {
 };
 
 static struct ata_port_info inic_port_info = {
-	/* For some reason, ATAPI_PROT_PIO is broken on this
-	 * controller, and no, PIO_POLLING does't fix it.  It somehow
-	 * manages to report the wrong ireason and ignoring ireason
-	 * results in machine lock up.  Tell libata to always prefer
-	 * DMA.
-	 */
 	.flags			= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 	.pio_mask		= 0x1f,	/* pio0-4 */
 	.mwdma_mask		= 0x07, /* mwdma0-2 */
@@ -599,7 +794,6 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 {
 	struct ata_host *host = dev_get_drvdata(&pdev->dev);
 	struct inic_host_priv *hpriv = host->private_data;
-	void __iomem *mmio_base = host->iomap[MMIO_BAR];
 	int rc;
 
 	rc = ata_pci_device_do_resume(pdev);
@@ -607,7 +801,7 @@ static int inic_pci_device_resume(struct pci_dev *pdev)
 		return rc;
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = init_controller(mmio_base, hpriv->cached_hctl);
+		rc = init_controller(hpriv->mmio_base, hpriv->cached_hctl);
 		if (rc)
 			return rc;
 	}
@@ -625,6 +819,7 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ata_host *host;
 	struct inic_host_priv *hpriv;
 	void __iomem * const *iomap;
+	int mmio_bar;
 	int i, rc;
 
 	if (!printed_version++)
@@ -638,38 +833,31 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	host->private_data = hpriv;
 
-	/* acquire resources and fill host */
+	/* Acquire resources and fill host.  Note that PCI and cardbus
+	 * use different BARs.
+	 */
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
-	rc = pcim_iomap_regions(pdev, 0x3f, DRV_NAME);
+	if (pci_resource_flags(pdev, MMIO_BAR_PCI) & IORESOURCE_MEM)
+		mmio_bar = MMIO_BAR_PCI;
+	else
+		mmio_bar = MMIO_BAR_CARDBUS;
+
+	rc = pcim_iomap_regions(pdev, 1 << mmio_bar, DRV_NAME);
 	if (rc)
 		return rc;
 	host->iomap = iomap = pcim_iomap_table(pdev);
+	hpriv->mmio_base = iomap[mmio_bar];
+	hpriv->cached_hctl = readw(hpriv->mmio_base + HOST_CTL);
 
 	for (i = 0; i < NR_PORTS; i++) {
 		struct ata_port *ap = host->ports[i];
-		struct ata_ioports *port = &ap->ioaddr;
-		unsigned int offset = i * PORT_SIZE;
-
-		port->cmd_addr = iomap[2 * i];
-		port->altstatus_addr =
-		port->ctl_addr = (void __iomem *)
-			((unsigned long)iomap[2 * i + 1] | ATA_PCI_CTL_OFS);
-		port->scr_addr = iomap[MMIO_BAR] + offset + PORT_SCR;
-
-		ata_sff_std_ports(port);
-
-		ata_port_pbar_desc(ap, MMIO_BAR, -1, "mmio");
-		ata_port_pbar_desc(ap, MMIO_BAR, offset, "port");
-		ata_port_desc(ap, "cmd 0x%llx ctl 0x%llx",
-		  (unsigned long long)pci_resource_start(pdev, 2 * i),
-		  (unsigned long long)pci_resource_start(pdev, (2 * i + 1)) |
-				      ATA_PCI_CTL_OFS);
-	}
 
-	hpriv->cached_hctl = readw(iomap[MMIO_BAR] + HOST_CTL);
+		ata_port_pbar_desc(ap, mmio_bar, -1, "mmio");
+		ata_port_pbar_desc(ap, mmio_bar, i * PORT_SIZE, "port");
+	}
 
 	/* Set dma_mask.  This devices doesn't support 64bit addressing. */
 	rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
@@ -698,7 +886,7 @@ static int inic_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
-	rc = init_controller(iomap[MMIO_BAR], hpriv->cached_hctl);
+	rc = init_controller(hpriv->mmio_base, hpriv->cached_hctl);
 	if (rc) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "failed to initialize controller\n");
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 842b1a1..bb73b22 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -65,6 +65,7 @@
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
 #include <linux/mbus.h>
+#include <linux/bitops.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -91,9 +92,9 @@ enum {
 	MV_IRQ_COAL_TIME_THRESHOLD	= (MV_IRQ_COAL_REG_BASE + 0xd0),
 
 	MV_SATAHC0_REG_BASE	= 0x20000,
-	MV_FLASH_CTL		= 0x1046c,
-	MV_GPIO_PORT_CTL	= 0x104f0,
-	MV_RESET_CFG		= 0x180d8,
+	MV_FLASH_CTL_OFS	= 0x1046c,
+	MV_GPIO_PORT_CTL_OFS	= 0x104f0,
+	MV_RESET_CFG_OFS	= 0x180d8,
 
 	MV_PCI_REG_SZ		= MV_MAJOR_REG_AREA_SZ,
 	MV_SATAHC_REG_SZ	= MV_MAJOR_REG_AREA_SZ,
@@ -147,18 +148,21 @@ enum {
 	/* PCI interface registers */
 
 	PCI_COMMAND_OFS		= 0xc00,
+	PCI_COMMAND_MRDTRIG	= (1 << 7),	/* PCI Master Read Trigger */
 
 	PCI_MAIN_CMD_STS_OFS	= 0xd30,
 	STOP_PCI_MASTER		= (1 << 2),
 	PCI_MASTER_EMPTY	= (1 << 3),
 	GLOB_SFT_RST		= (1 << 4),
 
-	MV_PCI_MODE		= 0xd00,
+	MV_PCI_MODE_OFS		= 0xd00,
+	MV_PCI_MODE_MASK	= 0x30,
+
 	MV_PCI_EXP_ROM_BAR_CTL	= 0xd2c,
 	MV_PCI_DISC_TIMER	= 0xd04,
 	MV_PCI_MSI_TRIGGER	= 0xc38,
 	MV_PCI_SERR_MASK	= 0xc28,
-	MV_PCI_XBAR_TMOUT	= 0x1d04,
+	MV_PCI_XBAR_TMOUT_OFS	= 0x1d04,
 	MV_PCI_ERR_LOW_ADDRESS	= 0x1d40,
 	MV_PCI_ERR_HIGH_ADDRESS	= 0x1d44,
 	MV_PCI_ERR_ATTRIBUTE	= 0x1d48,
@@ -225,16 +229,18 @@ enum {
 	PHY_MODE4		= 0x314,
 	PHY_MODE2		= 0x330,
 	SATA_IFCTL_OFS		= 0x344,
+	SATA_TESTCTL_OFS	= 0x348,
 	SATA_IFSTAT_OFS		= 0x34c,
 	VENDOR_UNIQUE_FIS_OFS	= 0x35c,
 
-	FIS_CFG_OFS		= 0x360,
-	FIS_CFG_SINGLE_SYNC	= (1 << 16),	/* SYNC on DMA activation */
+	FISCFG_OFS		= 0x360,
+	FISCFG_WAIT_DEV_ERR	= (1 << 8),	/* wait for host on DevErr */
+	FISCFG_SINGLE_SYNC	= (1 << 16),	/* SYNC on DMA activation */
 
 	MV5_PHY_MODE		= 0x74,
-	MV5_LT_MODE		= 0x30,
-	MV5_PHY_CTL		= 0x0C,
-	SATA_INTERFACE_CFG	= 0x050,
+	MV5_LTMODE_OFS		= 0x30,
+	MV5_PHY_CTL_OFS		= 0x0C,
+	SATA_INTERFACE_CFG_OFS	= 0x050,
 
 	MV_M2_PREAMP_MASK	= 0x7e0,
 
@@ -332,10 +338,16 @@ enum {
 	EDMA_CMD_OFS		= 0x28,		/* EDMA command register */
 	EDMA_EN			= (1 << 0),	/* enable EDMA */
 	EDMA_DS			= (1 << 1),	/* disable EDMA; self-negated */
-	ATA_RST			= (1 << 2),	/* reset trans/link/phy */
+	EDMA_RESET		= (1 << 2),	/* reset eng/trans/link/phy */
+
+	EDMA_STATUS_OFS		= 0x30,		/* EDMA engine status */
+	EDMA_STATUS_CACHE_EMPTY	= (1 << 6),	/* GenIIe command cache empty */
+	EDMA_STATUS_IDLE	= (1 << 7),	/* GenIIe EDMA enabled/idle */
 
-	EDMA_IORDY_TMOUT	= 0x34,
-	EDMA_ARB_CFG		= 0x38,
+	EDMA_IORDY_TMOUT_OFS	= 0x34,
+	EDMA_ARB_CFG_OFS	= 0x38,
+
+	EDMA_HALTCOND_OFS	= 0x60,		/* GenIIe halt conditions */
 
 	GEN_II_NCQ_MAX_SECTORS	= 256,		/* max sects/io on Gen2 w/NCQ */
 
@@ -350,15 +362,19 @@ enum {
 	MV_HP_GEN_II		= (1 << 7),	/* Generation II: 60xx */
 	MV_HP_GEN_IIE		= (1 << 8),	/* Generation IIE: 6042/7042 */
 	MV_HP_PCIE		= (1 << 9),	/* PCIe bus/regs: 7042 */
+	MV_HP_CUT_THROUGH	= (1 << 10),	/* can use EDMA cut-through */
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
 	MV_PP_FLAG_NCQ_EN	= (1 << 1),	/* is EDMA set up for NCQ? */
+	MV_PP_FLAG_FBS_EN	= (1 << 2),	/* is EDMA set up for FBS? */
+	MV_PP_FLAG_DELAYED_EH	= (1 << 3),	/* delayed dev err handling */
 };
 
 #define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
 #define IS_GEN_II(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_II)
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
+#define IS_PCIE(hpriv) ((hpriv)->hp_flags & MV_HP_PCIE)
 #define HAS_PCI(host) (!((host)->ports[0]->flags & MV_FLAG_SOC))
 
 #define WINDOW_CTRL(i)		(0x20030 + ((i) << 4))
@@ -433,6 +449,7 @@ struct mv_port_priv {
 	unsigned int		resp_idx;
 
 	u32			pp_flags;
+	unsigned int		delayed_eh_pmp_map;
 };
 
 struct mv_port_signal {
@@ -479,6 +496,7 @@ static int mv5_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
 static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
 static int mv_port_start(struct ata_port *ap);
 static void mv_port_stop(struct ata_port *ap);
+static int mv_qc_defer(struct ata_queued_cmd *qc);
 static void mv_qc_prep(struct ata_queued_cmd *qc);
 static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
@@ -527,6 +545,9 @@ static int mv_pmp_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
 static int  mv_softreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
+static void mv_pmp_error_handler(struct ata_port *ap);
+static void mv_process_crpb_entries(struct ata_port *ap,
+					struct mv_port_priv *pp);
 
 /* .sg_tablesize is (MV_MAX_SG_CT / 2) in the structures below
  * because we have to allow room for worst case splitting of
@@ -548,6 +569,7 @@ static struct scsi_host_template mv6_sht = {
 static struct ata_port_operations mv5_ops = {
 	.inherits		= &ata_sff_port_ops,
 
+	.qc_defer		= mv_qc_defer,
 	.qc_prep		= mv_qc_prep,
 	.qc_issue		= mv_qc_issue,
 
@@ -566,7 +588,6 @@ static struct ata_port_operations mv5_ops = {
 
 static struct ata_port_operations mv6_ops = {
 	.inherits		= &mv5_ops,
-	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
 	.dev_config             = mv6_dev_config,
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
@@ -574,12 +595,11 @@ static struct ata_port_operations mv6_ops = {
 	.pmp_hardreset		= mv_pmp_hardreset,
 	.pmp_softreset		= mv_softreset,
 	.softreset		= mv_softreset,
-	.error_handler		= sata_pmp_error_handler,
+	.error_handler		= mv_pmp_error_handler,
 };
 
 static struct ata_port_operations mv_iie_ops = {
 	.inherits		= &mv6_ops,
-	.qc_defer		= ata_std_qc_defer, /* FIS-based switching */
 	.dev_config		= ATA_OP_NULL,
 	.qc_prep		= mv_qc_prep_iie,
 };
@@ -875,6 +895,29 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 	}
 }
 
+static void mv_wait_for_edma_empty_idle(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+	const u32 empty_idle = (EDMA_STATUS_CACHE_EMPTY | EDMA_STATUS_IDLE);
+	const int per_loop = 5, timeout = (15 * 1000 / per_loop);
+	int i;
+
+	/*
+	 * Wait for the EDMA engine to finish transactions in progress.
+	 * No idea what a good "timeout" value might be, but measurements
+	 * indicate that it often requires hundreds of microseconds
+	 * with two drives in-use.  So we use the 15msec value above
+	 * as a rough guess at what even more drives might require.
+	 */
+	for (i = 0; i < timeout; ++i) {
+		u32 edma_stat = readl(port_mmio + EDMA_STATUS_OFS);
+		if ((edma_stat & empty_idle) == empty_idle)
+			break;
+		udelay(per_loop);
+	}
+	/* ata_port_printk(ap, KERN_INFO, "%s: %u+ usecs\n", __func__, i); */
+}
+
 /**
  *      mv_stop_edma_engine - Disable eDMA engine
  *      @port_mmio: io base address
@@ -907,6 +950,7 @@ static int mv_stop_edma(struct ata_port *ap)
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN))
 		return 0;
 	pp->pp_flags &= ~MV_PP_FLAG_EDMA_EN;
+	mv_wait_for_edma_empty_idle(ap);
 	if (mv_stop_edma_engine(port_mmio)) {
 		ata_port_printk(ap, KERN_ERR, "Unable to stop eDMA\n");
 		return -EIO;
@@ -1057,26 +1101,95 @@ static void mv6_dev_config(struct ata_device *adev)
 	}
 }
 
-static void mv_config_fbs(void __iomem *port_mmio, int enable_fbs)
+static int mv_qc_defer(struct ata_queued_cmd *qc)
 {
-	u32 old_fcfg, new_fcfg, old_ltmode, new_ltmode;
+	struct ata_link *link = qc->dev->link;
+	struct ata_port *ap = link->ap;
+	struct mv_port_priv *pp = ap->private_data;
+
+	/*
+	 * Don't allow new commands if we're in a delayed EH state
+	 * for NCQ and/or FIS-based switching.
+	 */
+	if (pp->pp_flags & MV_PP_FLAG_DELAYED_EH)
+		return ATA_DEFER_PORT;
 	/*
-	 * Various bit settings required for operation
-	 * in FIS-based switching (fbs) mode on GenIIe:
+	 * If the port is completely idle, then allow the new qc.
 	 */
-	old_fcfg   = readl(port_mmio + FIS_CFG_OFS);
-	old_ltmode = readl(port_mmio + LTMODE_OFS);
-	if (enable_fbs) {
-		new_fcfg   = old_fcfg   |  FIS_CFG_SINGLE_SYNC;
-		new_ltmode = old_ltmode |  LTMODE_BIT8;
-	} else { /* disable fbs */
-		new_fcfg   = old_fcfg   & ~FIS_CFG_SINGLE_SYNC;
-		new_ltmode = old_ltmode & ~LTMODE_BIT8;
-	}
-	if (new_fcfg != old_fcfg)
-		writelfl(new_fcfg, port_mmio + FIS_CFG_OFS);
+	if (ap->nr_active_links == 0)
+		return 0;
+
+	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
+		/*
+		 * The port is operating in host queuing mode (EDMA).
+		 * It can accomodate a new qc if the qc protocol
+		 * is compatible with the current host queue mode.
+		 */
+		if (pp->pp_flags & MV_PP_FLAG_NCQ_EN) {
+			/*
+			 * The host queue (EDMA) is in NCQ mode.
+			 * If the new qc is also an NCQ command,
+			 * then allow the new qc.
+			 */
+			if (qc->tf.protocol == ATA_PROT_NCQ)
+				return 0;
+		} else {
+			/*
+			 * The host queue (EDMA) is in non-NCQ, DMA mode.
+			 * If the new qc is also a non-NCQ, DMA command,
+			 * then allow the new qc.
+			 */
+			if (qc->tf.protocol == ATA_PROT_DMA)
+				return 0;
+		}
+	}
+	return ATA_DEFER_PORT;
+}
+
+static void mv_config_fbs(void __iomem *port_mmio, int want_ncq, int want_fbs)
+{
+	u32 new_fiscfg, old_fiscfg;
+	u32 new_ltmode, old_ltmode;
+	u32 new_haltcond, old_haltcond;
+
+	old_fiscfg   = readl(port_mmio + FISCFG_OFS);
+	old_ltmode   = readl(port_mmio + LTMODE_OFS);
+	old_haltcond = readl(port_mmio + EDMA_HALTCOND_OFS);
+
+	new_fiscfg   = old_fiscfg & ~(FISCFG_SINGLE_SYNC | FISCFG_WAIT_DEV_ERR);
+	new_ltmode   = old_ltmode & ~LTMODE_BIT8;
+	new_haltcond = old_haltcond | EDMA_ERR_DEV;
+
+	if (want_fbs) {
+		new_fiscfg = old_fiscfg | FISCFG_SINGLE_SYNC;
+		new_ltmode = old_ltmode | LTMODE_BIT8;
+		if (want_ncq)
+			new_haltcond &= ~EDMA_ERR_DEV;
+		else
+			new_fiscfg |=  FISCFG_WAIT_DEV_ERR;
+	}
+
+	if (new_fiscfg != old_fiscfg)
+		writelfl(new_fiscfg, port_mmio + FISCFG_OFS);
 	if (new_ltmode != old_ltmode)
 		writelfl(new_ltmode, port_mmio + LTMODE_OFS);
+	if (new_haltcond != old_haltcond)
+		writelfl(new_haltcond, port_mmio + EDMA_HALTCOND_OFS);
+}
+
+static void mv_60x1_errata_sata25(struct ata_port *ap, int want_ncq)
+{
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	u32 old, new;
+
+	/* workaround for 88SX60x1 FEr SATA#25 (part 1) */
+	old = readl(hpriv->base + MV_GPIO_PORT_CTL_OFS);
+	if (want_ncq)
+		new = old | (1 << 22);
+	else
+		new = old & ~(1 << 22);
+	if (new != old)
+		writel(new, hpriv->base + MV_GPIO_PORT_CTL_OFS);
 }
 
 static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
@@ -1088,25 +1201,40 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq)
 
 	/* set up non-NCQ EDMA configuration */
 	cfg = EDMA_CFG_Q_DEPTH;		/* always 0x1f for *all* chips */
+	pp->pp_flags &= ~MV_PP_FLAG_FBS_EN;
 
 	if (IS_GEN_I(hpriv))
 		cfg |= (1 << 8);	/* enab config burst size mask */
 
-	else if (IS_GEN_II(hpriv))
+	else if (IS_GEN_II(hpriv)) {
 		cfg |= EDMA_CFG_RD_BRST_EXT | EDMA_CFG_WR_BUFF_LEN;
+		mv_60x1_errata_sata25(ap, want_ncq);
 
-	else if (IS_GEN_IIE(hpriv)) {
-		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
-		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
-		cfg |= (1 << 18);	/* enab early completion */
-		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
+	} else if (IS_GEN_IIE(hpriv)) {
+		int want_fbs = sata_pmp_attached(ap);
+		/*
+		 * Possible future enhancement:
+		 *
+		 * The chip can use FBS with non-NCQ, if we allow it,
+		 * But first we need to have the error handling in place
+		 * for this mode (datasheet section 7.3.15.4.2.3).
+		 * So disallow non-NCQ FBS for now.
+		 */
+		want_fbs &= want_ncq;
+
+		mv_config_fbs(port_mmio, want_ncq, want_fbs);
 
-		if (want_ncq && sata_pmp_attached(ap)) {
+		if (want_fbs) {
+			pp->pp_flags |= MV_PP_FLAG_FBS_EN;
 			cfg |= EDMA_CFG_EDMA_FBS; /* FIS-based switching */
-			mv_config_fbs(port_mmio, 1);
-		} else {
-			mv_config_fbs(port_mmio, 0);
 		}
+
+		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
+		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
+		if (HAS_PCI(ap->host))
+			cfg |= (1 << 18);	/* enab early completion */
+		if (hpriv->hp_flags & MV_HP_CUT_THROUGH)
+			cfg |= (1 << 17); /* enab cut-thru (dis stor&forwrd) */
 	}
 
 	if (want_ncq) {
@@ -1483,25 +1611,186 @@ static struct ata_queued_cmd *mv_get_active_qc(struct ata_port *ap)
 	return qc;
 }
 
-static void mv_unexpected_intr(struct ata_port *ap)
+static void mv_pmp_error_handler(struct ata_port *ap)
 {
+	unsigned int pmp, pmp_map;
 	struct mv_port_priv *pp = ap->private_data;
-	struct ata_eh_info *ehi = &ap->link.eh_info;
-	char *when = "";
 
+	if (pp->pp_flags & MV_PP_FLAG_DELAYED_EH) {
+		/*
+		 * Perform NCQ error analysis on failed PMPs
+		 * before we freeze the port entirely.
+		 *
+		 * The failed PMPs are marked earlier by mv_pmp_eh_prep().
+		 */
+		pmp_map = pp->delayed_eh_pmp_map;
+		pp->pp_flags &= ~MV_PP_FLAG_DELAYED_EH;
+		for (pmp = 0; pmp_map != 0; pmp++) {
+			unsigned int this_pmp = (1 << pmp);
+			if (pmp_map & this_pmp) {
+				struct ata_link *link = &ap->pmp_link[pmp];
+				pmp_map &= ~this_pmp;
+				ata_eh_analyze_ncq_error(link);
+			}
+		}
+		ata_port_freeze(ap);
+	}
+	sata_pmp_error_handler(ap);
+}
+
+static unsigned int mv_get_err_pmp_map(struct ata_port *ap)
+{
+	void __iomem *port_mmio = mv_ap_base(ap);
+
+	return readl(port_mmio + SATA_TESTCTL_OFS) >> 16;
+}
+
+static void mv_pmp_eh_prep(struct ata_port *ap, unsigned int pmp_map)
+{
+	struct ata_eh_info *ehi;
+	unsigned int pmp;
+
+	/*
+	 * Initialize EH info for PMPs which saw device errors
+	 */
+	ehi = &ap->link.eh_info;
+	for (pmp = 0; pmp_map != 0; pmp++) {
+		unsigned int this_pmp = (1 << pmp);
+		if (pmp_map & this_pmp) {
+			struct ata_link *link = &ap->pmp_link[pmp];
+
+			pmp_map &= ~this_pmp;
+			ehi = &link->eh_info;
+			ata_ehi_clear_desc(ehi);
+			ata_ehi_push_desc(ehi, "dev err");
+			ehi->err_mask |= AC_ERR_DEV;
+			ehi->action |= ATA_EH_RESET;
+			ata_link_abort(link);
+		}
+	}
+}
+
+static int mv_handle_fbs_ncq_dev_err(struct ata_port *ap)
+{
+	struct mv_port_priv *pp = ap->private_data;
+	int failed_links;
+	unsigned int old_map, new_map;
+
+	/*
+	 * Device error during FBS+NCQ operation:
+	 *
+	 * Set a port flag to prevent further I/O being enqueued.
+	 * Leave the EDMA running to drain outstanding commands from this port.
+	 * Perform the post-mortem/EH only when all responses are complete.
+	 * Follow recovery sequence from 6042/7042 datasheet (7.3.15.4.2.2).
+	 */
+	if (!(pp->pp_flags & MV_PP_FLAG_DELAYED_EH)) {
+		pp->pp_flags |= MV_PP_FLAG_DELAYED_EH;
+		pp->delayed_eh_pmp_map = 0;
+	}
+	old_map = pp->delayed_eh_pmp_map;
+	new_map = old_map | mv_get_err_pmp_map(ap);
+
+	if (old_map != new_map) {
+		pp->delayed_eh_pmp_map = new_map;
+		mv_pmp_eh_prep(ap, new_map & ~old_map);
+	}
+	failed_links = hweight16(new_map);
+
+	ata_port_printk(ap, KERN_INFO, "%s: pmp_map=%04x qc_map=%04x "
+			"failed_links=%d nr_active_links=%d\n",
+			__func__, pp->delayed_eh_pmp_map,
+			ap->qc_active, failed_links,
+			ap->nr_active_links);
+
+	if (ap->nr_active_links <= failed_links) {
+		mv_process_crpb_entries(ap, pp);
+		mv_stop_edma(ap);
+		mv_eh_freeze(ap);
+		ata_port_printk(ap, KERN_INFO, "%s: done\n", __func__);
+		return 1;	/* handled */
+	}
+	ata_port_printk(ap, KERN_INFO, "%s: waiting\n", __func__);
+	return 1;	/* handled */
+}
+
+static int mv_handle_fbs_non_ncq_dev_err(struct ata_port *ap)
+{
 	/*
-	 * We got a device interrupt from something that
-	 * was supposed to be using EDMA or polling.
+	 * Possible future enhancement:
+	 *
+	 * FBS+non-NCQ operation is not yet implemented.
+	 * See related notes in mv_edma_cfg().
+	 *
+	 * Device error during FBS+non-NCQ operation:
+	 *
+	 * We need to snapshot the shadow registers for each failed command.
+	 * Follow recovery sequence from 6042/7042 datasheet (7.3.15.4.2.3).
 	 */
+	return 0;	/* not handled */
+}
+
+static int mv_handle_dev_err(struct ata_port *ap, u32 edma_err_cause)
+{
+	struct mv_port_priv *pp = ap->private_data;
+
+	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN))
+		return 0;	/* EDMA was not active: not handled */
+	if (!(pp->pp_flags & MV_PP_FLAG_FBS_EN))
+		return 0;	/* FBS was not active: not handled */
+
+	if (!(edma_err_cause & EDMA_ERR_DEV))
+		return 0;	/* non DEV error: not handled */
+	edma_err_cause &= ~EDMA_ERR_IRQ_TRANSIENT;
+	if (edma_err_cause & ~(EDMA_ERR_DEV | EDMA_ERR_SELF_DIS))
+		return 0;	/* other problems: not handled */
+
+	if (pp->pp_flags & MV_PP_FLAG_NCQ_EN) {
+		/*
+		 * EDMA should NOT have self-disabled for this case.
+		 * If it did, then something is wrong elsewhere,
+		 * and we cannot handle it here.
+		 */
+		if (edma_err_cause & EDMA_ERR_SELF_DIS) {
+			ata_port_printk(ap, KERN_WARNING,
+				"%s: err_cause=0x%x pp_flags=0x%x\n",
+				__func__, edma_err_cause, pp->pp_flags);
+			return 0; /* not handled */
+		}
+		return mv_handle_fbs_ncq_dev_err(ap);
+	} else {
+		/*
+		 * EDMA should have self-disabled for this case.
+		 * If it did not, then something is wrong elsewhere,
+		 * and we cannot handle it here.
+		 */
+		if (!(edma_err_cause & EDMA_ERR_SELF_DIS)) {
+			ata_port_printk(ap, KERN_WARNING,
+				"%s: err_cause=0x%x pp_flags=0x%x\n",
+				__func__, edma_err_cause, pp->pp_flags);
+			return 0; /* not handled */
+		}
+		return mv_handle_fbs_non_ncq_dev_err(ap);
+	}
+	return 0;	/* not handled */
+}
+
+static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	char *when = "idle";
+
 	ata_ehi_clear_desc(ehi);
-	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
-		when = " while EDMA enabled";
+	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
+		when = "disabled";
+	} else if (edma_was_enabled) {
+		when = "EDMA enabled";
 	} else {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
 		if (qc && (qc->tf.flags & ATA_TFLAG_POLLING))
-			when = " while polling";
+			when = "polling";
 	}
-	ata_ehi_push_desc(ehi, "unexpected device interrupt%s", when);
+	ata_ehi_push_desc(ehi, "unexpected device interrupt while %s", when);
 	ehi->err_mask |= AC_ERR_OTHER;
 	ehi->action   |= ATA_EH_RESET;
 	ata_port_freeze(ap);
@@ -1519,7 +1808,7 @@ static void mv_unexpected_intr(struct ata_port *ap)
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
+static void mv_err_intr(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 edma_err_cause, eh_freeze_mask, serr = 0;
@@ -1527,24 +1816,42 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	unsigned int action = 0, err_mask = 0;
 	struct ata_eh_info *ehi = &ap->link.eh_info;
-
-	ata_ehi_clear_desc(ehi);
+	struct ata_queued_cmd *qc;
+	int abort = 0;
 
 	/*
-	 * Read and clear the err_cause bits.  This won't actually
-	 * clear for some errors (eg. SError), but we will be doing
-	 * a hard reset in those cases regardless, which *will* clear it.
+	 * Read and clear the SError and err_cause bits.
 	 */
+	sata_scr_read(&ap->link, SCR_ERROR, &serr);
+	sata_scr_write_flush(&ap->link, SCR_ERROR, serr);
+
 	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	ata_ehi_push_desc(ehi, "edma_err_cause=%08x", edma_err_cause);
+	ata_port_printk(ap, KERN_INFO, "%s: err_cause=%08x pp_flags=0x%x\n",
+			__func__, edma_err_cause, pp->pp_flags);
+
+	if (edma_err_cause & EDMA_ERR_DEV) {
+		/*
+		 * Device errors during FIS-based switching operation
+		 * require special handling.
+		 */
+		if (mv_handle_dev_err(ap, edma_err_cause))
+			return;
+	}
 
+	qc = mv_get_active_qc(ap);
+	ata_ehi_clear_desc(ehi);
+	ata_ehi_push_desc(ehi, "edma_err_cause=%08x pp_flags=%08x",
+			  edma_err_cause, pp->pp_flags);
 	/*
 	 * All generations share these EDMA error cause bits:
 	 */
-	if (edma_err_cause & EDMA_ERR_DEV)
+	if (edma_err_cause & EDMA_ERR_DEV) {
 		err_mask |= AC_ERR_DEV;
+		action |= ATA_EH_RESET;
+		ata_ehi_push_desc(ehi, "dev error");
+	}
 	if (edma_err_cause & (EDMA_ERR_D_PAR | EDMA_ERR_PRD_PAR |
 			EDMA_ERR_CRQB_PAR | EDMA_ERR_CRPB_PAR |
 			EDMA_ERR_INTRL_PAR)) {
@@ -1576,13 +1883,6 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 			ata_ehi_push_desc(ehi, "EDMA self-disable");
 		}
 		if (edma_err_cause & EDMA_ERR_SERR) {
-			/*
-			 * Ensure that we read our own SCR, not a pmp link SCR:
-			 */
-			ap->ops->scr_read(ap, SCR_ERROR, &serr);
-			/*
-			 * Don't clear SError here; leave it for libata-eh:
-			 */
 			ata_ehi_push_desc(ehi, "SError=%08x", serr);
 			err_mask |= AC_ERR_ATA_BUS;
 			action |= ATA_EH_RESET;
@@ -1602,10 +1902,29 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 	else
 		ehi->err_mask |= err_mask;
 
-	if (edma_err_cause & eh_freeze_mask)
+	if (err_mask == AC_ERR_DEV) {
+		/*
+		 * Cannot do ata_port_freeze() here,
+		 * because it would kill PIO access,
+		 * which is needed for further diagnosis.
+		 */
+		mv_eh_freeze(ap);
+		abort = 1;
+	} else if (edma_err_cause & eh_freeze_mask) {
+		/*
+		 * Note to self: ata_port_freeze() calls ata_port_abort()
+		 */
 		ata_port_freeze(ap);
-	else
-		ata_port_abort(ap);
+	} else {
+		abort = 1;
+	}
+
+	if (abort) {
+		if (qc)
+			ata_link_abort(qc->dev->link);
+		else
+			ata_port_abort(ap);
+	}
 }
 
 static void mv_process_crpb_response(struct ata_port *ap,
@@ -1632,8 +1951,9 @@ static void mv_process_crpb_response(struct ata_port *ap,
 			}
 		}
 		ata_status = edma_status >> CRPB_FLAG_STATUS_SHIFT;
-		qc->err_mask |= ac_err_mask(ata_status);
-		ata_qc_complete(qc);
+		if (!ac_err_mask(ata_status))
+			ata_qc_complete(qc);
+		/* else: leave it for mv_err_intr() */
 	} else {
 		ata_port_printk(ap, KERN_ERR, "%s: no qc for tag=%d\n",
 				__func__, tag);
@@ -1677,6 +1997,44 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 			 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
 }
 
+static void mv_port_intr(struct ata_port *ap, u32 port_cause)
+{
+	struct mv_port_priv *pp;
+	int edma_was_enabled;
+
+	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
+		mv_unexpected_intr(ap, 0);
+		return;
+	}
+	/*
+	 * Grab a snapshot of the EDMA_EN flag setting,
+	 * so that we have a consistent view for this port,
+	 * even if something we call of our routines changes it.
+	 */
+	pp = ap->private_data;
+	edma_was_enabled = (pp->pp_flags & MV_PP_FLAG_EDMA_EN);
+	/*
+	 * Process completed CRPB response(s) before other events.
+	 */
+	if (edma_was_enabled && (port_cause & DONE_IRQ)) {
+		mv_process_crpb_entries(ap, pp);
+		if (pp->pp_flags & MV_PP_FLAG_DELAYED_EH)
+			mv_handle_fbs_ncq_dev_err(ap);
+	}
+	/*
+	 * Handle chip-reported errors, or continue on to handle PIO.
+	 */
+	if (unlikely(port_cause & ERR_IRQ)) {
+		mv_err_intr(ap);
+	} else if (!edma_was_enabled) {
+		struct ata_queued_cmd *qc = mv_get_active_qc(ap);
+		if (qc)
+			ata_sff_host_intr(ap, qc);
+		else
+			mv_unexpected_intr(ap, edma_was_enabled);
+	}
+}
+
 /**
  *      mv_host_intr - Handle all interrupts on the given host controller
  *      @host: host specific structure
@@ -1688,66 +2046,58 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 {
 	struct mv_host_priv *hpriv = host->private_data;
-	void __iomem *mmio = hpriv->base, *hc_mmio = NULL;
-	u32 hc_irq_cause = 0;
+	void __iomem *mmio = hpriv->base, *hc_mmio;
 	unsigned int handled = 0, port;
 
 	for (port = 0; port < hpriv->n_ports; port++) {
 		struct ata_port *ap = host->ports[port];
-		struct mv_port_priv *pp;
-		unsigned int shift, hardport, port_cause;
-		/*
-		 * When we move to the second hc, flag our cached
-		 * copies of hc_mmio (and hc_irq_cause) as invalid again.
-		 */
-		if (port == MV_PORTS_PER_HC)
-			hc_mmio = NULL;
-		/*
-		 * Do nothing if port is not interrupting or is disabled:
-		 */
+		unsigned int p, shift, hardport, port_cause;
+
 		MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
-		port_cause = (main_irq_cause >> shift) & (DONE_IRQ | ERR_IRQ);
-		if (!port_cause || !ap || (ap->flags & ATA_FLAG_DISABLED))
-			continue;
 		/*
-		 * Each hc within the host has its own hc_irq_cause register.
-		 * We defer reading it until we know we need it, right now:
-		 *
-		 * FIXME later: we don't really need to read this register
-		 * (some logic changes required below if we go that way),
-		 * because it doesn't tell us anything new.  But we do need
-		 * to write to it, outside the top of this loop,
-		 * to reset the interrupt triggers for next time.
+		 * Each hc within the host has its own hc_irq_cause register,
+		 * where the interrupting ports bits get ack'd.
 		 */
-		if (!hc_mmio) {
+		if (hardport == 0) {	/* first port on this hc ? */
+			u32 hc_cause = (main_irq_cause >> shift) & HC0_IRQ_PEND;
+			u32 port_mask, ack_irqs;
+			/*
+			 * Skip this entire hc if nothing pending for any ports
+			 */
+			if (!hc_cause) {
+				port += MV_PORTS_PER_HC - 1;
+				continue;
+			}
+			/*
+			 * We don't need/want to read the hc_irq_cause register,
+			 * because doing so hurts performance, and
+			 * main_irq_cause already gives us everything we need.
+			 *
+			 * But we do have to *write* to the hc_irq_cause to ack
+			 * the ports that we are handling this time through.
+			 *
+			 * This requires that we create a bitmap for those
+			 * ports which interrupted us, and use that bitmap
+			 * to ack (only) those ports via hc_irq_cause.
+			 */
+			ack_irqs = 0;
+			for (p = 0; p < MV_PORTS_PER_HC; ++p) {
+				if ((port + p) >= hpriv->n_ports)
+					break;
+				port_mask = (DONE_IRQ | ERR_IRQ) << (p * 2);
+				if (hc_cause & port_mask)
+					ack_irqs |= (DMA_IRQ | DEV_IRQ) << p;
+			}
 			hc_mmio = mv_hc_base_from_port(mmio, port);
-			hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-			writelfl(~hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+			writelfl(~ack_irqs, hc_mmio + HC_IRQ_CAUSE_OFS);
 			handled = 1;
 		}
 		/*
-		 * Process completed CRPB response(s) before other events.
-		 */
-		pp = ap->private_data;
-		if (hc_irq_cause & (DMA_IRQ << hardport)) {
-			if (pp->pp_flags & MV_PP_FLAG_EDMA_EN)
-				mv_process_crpb_entries(ap, pp);
-		}
-		/*
-		 * Handle chip-reported errors, or continue on to handle PIO.
+		 * Handle interrupts signalled for this port:
 		 */
-		if (unlikely(port_cause & ERR_IRQ)) {
-			mv_err_intr(ap, mv_get_active_qc(ap));
-		} else if (hc_irq_cause & (DEV_IRQ << hardport)) {
-			if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
-				struct ata_queued_cmd *qc = mv_get_active_qc(ap);
-				if (qc) {
-					ata_sff_host_intr(ap, qc);
-					continue;
-				}
-			}
-			mv_unexpected_intr(ap);
-		}
+		port_cause = (main_irq_cause >> shift) & (DONE_IRQ | ERR_IRQ);
+		if (port_cause)
+			mv_port_intr(ap, port_cause);
 	}
 	return handled;
 }
@@ -1894,7 +2244,7 @@ static void mv5_reset_bus(struct ata_host *host, void __iomem *mmio)
 
 static void mv5_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
-	writel(0x0fcfffff, mmio + MV_FLASH_CTL);
+	writel(0x0fcfffff, mmio + MV_FLASH_CTL_OFS);
 }
 
 static void mv5_read_preamp(struct mv_host_priv *hpriv, int idx,
@@ -1913,7 +2263,7 @@ static void mv5_enable_leds(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
 	u32 tmp;
 
-	writel(0, mmio + MV_GPIO_PORT_CTL);
+	writel(0, mmio + MV_GPIO_PORT_CTL_OFS);
 
 	/* FIXME: handle MV_HP_ERRATA_50XXB2 errata */
 
@@ -1931,14 +2281,14 @@ static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 	int fix_apm_sq = (hpriv->hp_flags & MV_HP_ERRATA_50XXB0);
 
 	if (fix_apm_sq) {
-		tmp = readl(phy_mmio + MV5_LT_MODE);
+		tmp = readl(phy_mmio + MV5_LTMODE_OFS);
 		tmp |= (1 << 19);
-		writel(tmp, phy_mmio + MV5_LT_MODE);
+		writel(tmp, phy_mmio + MV5_LTMODE_OFS);
 
-		tmp = readl(phy_mmio + MV5_PHY_CTL);
+		tmp = readl(phy_mmio + MV5_PHY_CTL_OFS);
 		tmp &= ~0x3;
 		tmp |= 0x1;
-		writel(tmp, phy_mmio + MV5_PHY_CTL);
+		writel(tmp, phy_mmio + MV5_PHY_CTL_OFS);
 	}
 
 	tmp = readl(phy_mmio + MV5_PHY_MODE);
@@ -1956,11 +2306,6 @@ static void mv5_reset_hc_port(struct mv_host_priv *hpriv, void __iomem *mmio,
 {
 	void __iomem *port_mmio = mv_port_base(mmio, port);
 
-	/*
-	 * The datasheet warns against setting ATA_RST when EDMA is active
-	 * (but doesn't say what the problem might be).  So we first try
-	 * to disable the EDMA engine before doing the ATA_RST operation.
-	 */
 	mv_reset_channel(hpriv, mmio, port);
 
 	ZERO(0x028);	/* command */
@@ -1975,7 +2320,7 @@ static void mv5_reset_hc_port(struct mv_host_priv *hpriv, void __iomem *mmio,
 	ZERO(0x024);	/* respq outp */
 	ZERO(0x020);	/* respq inp */
 	ZERO(0x02c);	/* test control */
-	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
+	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT_OFS);
 }
 #undef ZERO
 
@@ -2021,13 +2366,13 @@ static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio)
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 tmp;
 
-	tmp = readl(mmio + MV_PCI_MODE);
+	tmp = readl(mmio + MV_PCI_MODE_OFS);
 	tmp &= 0xff00ffff;
-	writel(tmp, mmio + MV_PCI_MODE);
+	writel(tmp, mmio + MV_PCI_MODE_OFS);
 
 	ZERO(MV_PCI_DISC_TIMER);
 	ZERO(MV_PCI_MSI_TRIGGER);
-	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT);
+	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT_OFS);
 	ZERO(PCI_HC_MAIN_IRQ_MASK_OFS);
 	ZERO(MV_PCI_SERR_MASK);
 	ZERO(hpriv->irq_cause_ofs);
@@ -2045,10 +2390,10 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
 
 	mv5_reset_flash(hpriv, mmio);
 
-	tmp = readl(mmio + MV_GPIO_PORT_CTL);
+	tmp = readl(mmio + MV_GPIO_PORT_CTL_OFS);
 	tmp &= 0x3;
 	tmp |= (1 << 5) | (1 << 6);
-	writel(tmp, mmio + MV_GPIO_PORT_CTL);
+	writel(tmp, mmio + MV_GPIO_PORT_CTL_OFS);
 }
 
 /**
@@ -2121,7 +2466,7 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 	void __iomem *port_mmio;
 	u32 tmp;
 
-	tmp = readl(mmio + MV_RESET_CFG);
+	tmp = readl(mmio + MV_RESET_CFG_OFS);
 	if ((tmp & (1 << 0)) == 0) {
 		hpriv->signal[idx].amps = 0x7 << 8;
 		hpriv->signal[idx].pre = 0x1 << 5;
@@ -2137,7 +2482,7 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 
 static void mv6_enable_leds(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
-	writel(0x00000060, mmio + MV_GPIO_PORT_CTL);
+	writel(0x00000060, mmio + MV_GPIO_PORT_CTL_OFS);
 }
 
 static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -2235,11 +2580,6 @@ static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
 {
 	void __iomem *port_mmio = mv_port_base(mmio, port);
 
-	/*
-	 * The datasheet warns against setting ATA_RST when EDMA is active
-	 * (but doesn't say what the problem might be).  So we first try
-	 * to disable the EDMA engine before doing the ATA_RST operation.
-	 */
 	mv_reset_channel(hpriv, mmio, port);
 
 	ZERO(0x028);		/* command */
@@ -2254,7 +2594,7 @@ static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
 	ZERO(0x024);		/* respq outp */
 	ZERO(0x020);		/* respq inp */
 	ZERO(0x02c);		/* test control */
-	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
+	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT_OFS);
 }
 
 #undef ZERO
@@ -2297,38 +2637,39 @@ static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio)
 	return;
 }
 
-static void mv_setup_ifctl(void __iomem *port_mmio, int want_gen2i)
+static void mv_setup_ifcfg(void __iomem *port_mmio, int want_gen2i)
 {
-	u32 ifctl = readl(port_mmio + SATA_INTERFACE_CFG);
+	u32 ifcfg = readl(port_mmio + SATA_INTERFACE_CFG_OFS);
 
-	ifctl = (ifctl & 0xf7f) | 0x9b1000;	/* from chip spec */
+	ifcfg = (ifcfg & 0xf7f) | 0x9b1000;	/* from chip spec */
 	if (want_gen2i)
-		ifctl |= (1 << 7);		/* enable gen2i speed */
-	writelfl(ifctl, port_mmio + SATA_INTERFACE_CFG);
+		ifcfg |= (1 << 7);		/* enable gen2i speed */
+	writelfl(ifcfg, port_mmio + SATA_INTERFACE_CFG_OFS);
 }
 
-/*
- * Caller must ensure that EDMA is not active,
- * by first doing mv_stop_edma() where needed.
- */
 static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no)
 {
 	void __iomem *port_mmio = mv_port_base(mmio, port_no);
 
+	/*
+	 * The datasheet warns against setting EDMA_RESET when EDMA is active
+	 * (but doesn't say what the problem might be).  So we first try
+	 * to disable the EDMA engine before doing the EDMA_RESET operation.
+	 */
 	mv_stop_edma_engine(port_mmio);
-	writelfl(ATA_RST, port_mmio + EDMA_CMD_OFS);
+	writelfl(EDMA_RESET, port_mmio + EDMA_CMD_OFS);
 
 	if (!IS_GEN_I(hpriv)) {
-		/* Enable 3.0gb/s link speed */
-		mv_setup_ifctl(port_mmio, 1);
+		/* Enable 3.0gb/s link speed: this survives EDMA_RESET */
+		mv_setup_ifcfg(port_mmio, 1);
 	}
 	/*
-	 * Strobing ATA_RST here causes a hard reset of the SATA transport,
+	 * Strobing EDMA_RESET here causes a hard reset of the SATA transport,
 	 * link, and physical layers.  It resets all SATA interface registers
 	 * (except for SATA_INTERFACE_CFG), and issues a COMRESET to the dev.
 	 */
-	writelfl(ATA_RST, port_mmio + EDMA_CMD_OFS);
+	writelfl(EDMA_RESET, port_mmio + EDMA_CMD_OFS);
 	udelay(25);	/* allow reset propagation */
 	writelfl(0, port_mmio + EDMA_CMD_OFS);
 
@@ -2392,7 +2733,7 @@ static int mv_hardreset(struct ata_link *link, unsigned int *class,
 		sata_scr_read(link, SCR_STATUS, &sstatus);
 		if (!IS_GEN_I(hpriv) && ++attempts >= 5 && sstatus == 0x121) {
 			/* Force 1.5gb/s link speed and try again */
-			mv_setup_ifctl(mv_ap_base(ap), 0);
+			mv_setup_ifcfg(mv_ap_base(ap), 0);
 			if (time_after(jiffies + HZ, deadline))
 				extra = HZ; /* only extend it once, max */
 		}
@@ -2493,6 +2834,34 @@ static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 		readl(port_mmio + EDMA_ERR_IRQ_MASK_OFS));
 }
 
+static unsigned int mv_in_pcix_mode(struct ata_host *host)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->base;
+	u32 reg;
+
+	if (!HAS_PCI(host) || !IS_PCIE(hpriv))
+		return 0;	/* not PCI-X capable */
+	reg = readl(mmio + MV_PCI_MODE_OFS);
+	if ((reg & MV_PCI_MODE_MASK) == 0)
+		return 0;	/* conventional PCI mode */
+	return 1;	/* chip is in PCI-X mode */
+}
+
+static int mv_pci_cut_through_okay(struct ata_host *host)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->base;
+	u32 reg;
+
+	if (!mv_in_pcix_mode(host)) {
+		reg = readl(mmio + PCI_COMMAND_OFS);
+		if (reg & PCI_COMMAND_MRDTRIG)
+			return 0; /* not okay */
+	}
+	return 1; /* okay */
+}
+
 static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
@@ -2560,7 +2929,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	case chip_7042:
-		hp_flags |= MV_HP_PCIE;
+		hp_flags |= MV_HP_PCIE | MV_HP_CUT_THROUGH;
 		if (pdev->vendor == PCI_VENDOR_ID_TTI &&
 		    (pdev->device == 0x2300 || pdev->device == 0x2310))
 		{
@@ -2590,9 +2959,12 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 				" and avoid the final two gigabytes on"
 				" all RocketRAID BIOS initialized drives.\n");
 		}
+		/* drop through */
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
 		hp_flags |= MV_HP_GEN_IIE;
+		if (board_idx == chip_6042 && mv_pci_cut_through_okay(host))
+			hp_flags |= MV_HP_CUT_THROUGH;
 
 		switch (pdev->revision) {
 		case 0x0:
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d1dfe87..7e206da 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1039,6 +1039,7 @@ extern void ata_eh_thaw_port(struct ata_port *ap);
 
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
+extern void ata_eh_analyze_ncq_error(struct ata_link *link);
 
 extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 		      ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
@@ -1381,6 +1382,21 @@ static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
 	return *(struct ata_port **)&host->hostdata[0];
 }
 
+static inline int ata_check_ready(u8 status)
+{
+	/* Some controllers report 0x77 or 0x7f during intermediate
+	 * not-ready stages.
+	 */
+	if (status == 0x77 || status == 0x7f)
+		return 0;
+
+	/* 0xff indicates either no device or device not ready */
+	if (status == 0xff)
+		return -ENODEV;
+
+	return !(status & ATA_BUSY);
+}
+
 
 /**************************************************************************
  * PMP - drivers/ata/libata-pmp.c
