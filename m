Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYBASeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYBASeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYBASeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:34:01 -0500
Received: from havoc.gtf.org ([69.61.125.42]:44552 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbYBASd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:33:57 -0500
Date: Fri, 1 Feb 2008 13:33:55 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080201183355.GA2940@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI change was ack'd by Greg...

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig         |    2 +-
 drivers/ata/ahci.c          |    2 +
 drivers/ata/ata_piix.c      |   10 +-
 drivers/ata/pata_bf54x.c    |   53 ++---
 drivers/ata/pata_sl82c105.c |   33 +++-
 drivers/ata/sata_mv.c       |  486 +++++++++++++++++++++++++++----------------
 drivers/ata/sata_nv.c       |   18 +-
 drivers/pci/pci.c           |    3 +-
 8 files changed, 389 insertions(+), 218 deletions(-)

Adrian Bunk (1):
      ata_piix.c: make piix_merge_scr() static

Alan Cox (1):
      pata_sl82c105: dual channel support

Bryan Wu (1):
      Blackfin pata-bf54x driver: fix compiling bug - no ata_port struct in struct ata_device any more

Jason Gaston (2):
      ahci: RAID mode SATA patch for Intel ICH10 DeviceID's
      ata_piix: IDE mode SATA patch for Intel ICH10 DeviceID's

Mark Lord (13):
      sata_mv ncq EH fixes
      sata_mv ncq Mask transient IRQs
      sata_mv ncq Rename base to port mmio
      sata_mv ncq Fix EDMA configuration
      sata_mv ncq Add want ncq parameter for EDMA configuration
      sata_mv ncq Use hqtag instead of ioid
      sata_mv ncq Ignore response status LSB on NCQ
      sata_mv ncq Restrict max sectors to 8-bits on GenII NCQ
      sata_mv ncq Use DMA memory pools for hardware memory tables
      sata_mv ncq Introduce per-tag SG tables
      sata_mv ncq Enable NCQ operation
      sata_mv ncq Remove post internal cmd op
      sata_mv ncq Comments and version bump

Robert Hancock (1):
      sata_nv: fix for completion handling

Saeed Bishara (1):
      sata_mv: Remove PCI dependency

Sonic Zhang (3):
      Blackfin pata-bf54x driver: Remove obsolete PM function
      Blackfin pata-bf54x driver: Add debug information
      Blackfin pata-bf54x driver: should cover all possible interrupt sources

Tejun Heo (1):
      pci: allow multiple calls to pcim_enable_device()

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ae19c9b..ba8f7f4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -69,7 +69,7 @@ config ATA_PIIX
 
 config SATA_MV
 	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	help
 	  This option enables support for the Marvell Serial ATA family.
 	  Currently supports 88SX[56]0[48][01] chips.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6f089b8..27c8d56 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -475,6 +475,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci }, /* ICH9M */
 	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
 	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
+	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
+	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a65c8ae..47892e6 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -267,6 +267,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (Tolapai) */
 	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a06, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (ICH10) */
+	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 
 	{ }	/* terminate list */
 };
@@ -1068,7 +1076,7 @@ static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
 	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
 }
 
-u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
+static u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
 {
 	u32 val = 0;
 	int i, mi;
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index a32e3c4..7f87f10 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -299,7 +299,7 @@ static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	*/
 	n6 = num_clocks_min(t6min, fsclk);
 	if (mode >= 0 && mode <= 4 && n6 >= 1) {
-		pr_debug("set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
+		dev_dbg(adev->link->ap->dev, "set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
 		/* calculate the timing values for register transfers. */
 		while (mode > 0 && pio_fsclk[mode] > fsclk)
 			mode--;
@@ -376,7 +376,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_UDMA_0;
 	if (mode >= 0 && mode <= 5) {
-		pr_debug("set udmamode: mode=%d\n", mode);
+		dev_dbg(adev->link->ap->dev, "set udmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is t6 and tc,
 		 * the DIOW - data hold. If one SCLK pulse is longer
 		 * than this minimum value then register
@@ -433,7 +433,7 @@ static void bfin_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	mode = adev->dma_mode - XFER_MW_DMA_0;
 	if (mode >= 0 && mode <= 2) {
-		pr_debug("set mdmamode: mode=%d\n", mode);
+		dev_dbg(adev->link->ap->dev, "set mdmamode: mode=%d\n", mode);
 		/* the most restrictive timing value is tf, the DMACK to
 		 * read data released. If one SCLK pulse is longer than
 		 * this maximum value then the MDMA mode
@@ -697,7 +697,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 			write_atapi_register(base, ATA_REG_LBAL, tf->hob_lbal);
 			write_atapi_register(base, ATA_REG_LBAM, tf->hob_lbam);
 			write_atapi_register(base, ATA_REG_LBAH, tf->hob_lbah);
-			pr_debug("hob: feat 0x%X nsect 0x%X, lba 0x%X "
+			dev_dbg(ap->dev, "hob: feat 0x%X nsect 0x%X, lba 0x%X "
 				 "0x%X 0x%X\n",
 				tf->hob_feature,
 				tf->hob_nsect,
@@ -711,7 +711,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 		write_atapi_register(base, ATA_REG_LBAL, tf->lbal);
 		write_atapi_register(base, ATA_REG_LBAM, tf->lbam);
 		write_atapi_register(base, ATA_REG_LBAH, tf->lbah);
-		pr_debug("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+		dev_dbg(ap->dev, "feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
 			tf->feature,
 			tf->nsect,
 			tf->lbal,
@@ -721,7 +721,7 @@ static void bfin_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 
 	if (tf->flags & ATA_TFLAG_DEVICE) {
 		write_atapi_register(base, ATA_REG_DEVICE, tf->device);
-		pr_debug("device 0x%X\n", tf->device);
+		dev_dbg(ap->dev, "device 0x%X\n", tf->device);
 	}
 
 	ata_wait_idle(ap);
@@ -782,7 +782,7 @@ static void bfin_exec_command(struct ata_port *ap,
 			      const struct ata_taskfile *tf)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
-	pr_debug("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	dev_dbg(ap->dev, "ata%u: cmd 0x%X\n", ap->print_id, tf->command);
 
 	write_atapi_register(base, ATA_REG_CMD, tf->command);
 	ata_pause(ap);
@@ -834,7 +834,7 @@ static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma setup\n");
+	dev_dbg(qc->ap->dev, "in atapi dma setup\n");
 	/* Program the ATA_CTRL register with dir */
 	if (qc->tf.flags & ATA_TFLAG_WRITE) {
 		/* fill the ATAPI DMA controller */
@@ -870,7 +870,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma start\n");
+	dev_dbg(qc->ap->dev, "in atapi dma start\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return;
 
@@ -888,7 +888,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 				sg_dma_address(sg) + sg_dma_len(sg));
 		}
 		enable_dma(CH_ATAPI_TX);
-		pr_debug("enable udma write\n");
+		dev_dbg(qc->ap->dev, "enable udma write\n");
 
 		/* Send ATA DMA write command */
 		bfin_exec_command(ap, &qc->tf);
@@ -898,7 +898,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 			| XFER_DIR));
 	} else {
 		enable_dma(CH_ATAPI_RX);
-		pr_debug("enable udma read\n");
+		dev_dbg(qc->ap->dev, "enable udma read\n");
 
 		/* Send ATA DMA read command */
 		bfin_exec_command(ap, &qc->tf);
@@ -936,7 +936,7 @@ static void bfin_bmdma_stop(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	unsigned int si;
 
-	pr_debug("in atapi dma stop\n");
+	dev_dbg(qc->ap->dev, "in atapi dma stop\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return;
 
@@ -1147,15 +1147,15 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	unsigned short int_status = ATAPI_GET_INT_STATUS(base);
 
-	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON)) {
+	if (ATAPI_GET_STATUS(base) & (MULTI_XFER_ON|ULTRA_XFER_ON))
 		host_stat |= ATA_DMA_ACTIVE;
-	}
-	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT)) {
+	if (int_status & (MULTI_DONE_INT|UDMAIN_DONE_INT|UDMAOUT_DONE_INT|
+		ATAPI_DEV_INT))
 		host_stat |= ATA_DMA_INTR;
-	}
-	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT)) {
-		host_stat |= ATA_DMA_ERR;
-	}
+	if (int_status & (MULTI_TERM_INT|UDMAIN_TERM_INT|UDMAOUT_TERM_INT))
+		host_stat |= ATA_DMA_ERR|ATA_DMA_INTR;
+
+	dev_dbg(ap->dev, "ATAPI: host_stat=0x%x\n", host_stat);
 
 	return host_stat;
 }
@@ -1213,8 +1213,7 @@ static void bfin_irq_clear(struct ata_port *ap)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
-	pr_debug("in atapi irq clear\n");
-
+	dev_dbg(ap->dev, "in atapi irq clear\n");
 	ATAPI_SET_INT_STATUS(base, ATAPI_GET_INT_STATUS(base)|ATAPI_DEV_INT
 		| MULTI_DONE_INT | UDMAIN_DONE_INT | UDMAOUT_DONE_INT
 		| MULTI_TERM_INT | UDMAIN_TERM_INT | UDMAOUT_TERM_INT);
@@ -1232,7 +1231,7 @@ static unsigned char bfin_irq_on(struct ata_port *ap)
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	u8 tmp;
 
-	pr_debug("in atapi irq on\n");
+	dev_dbg(ap->dev, "in atapi irq on\n");
 	ap->ctl &= ~ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
@@ -1255,7 +1254,7 @@ static void bfin_bmdma_freeze(struct ata_port *ap)
 {
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 
-	pr_debug("in atapi dma freeze\n");
+	dev_dbg(ap->dev, "in atapi dma freeze\n");
 	ap->ctl |= ATA_NIEN;
 	ap->last_ctl = ap->ctl;
 
@@ -1328,7 +1327,7 @@ static void bfin_error_handler(struct ata_port *ap)
 
 static void bfin_port_stop(struct ata_port *ap)
 {
-	pr_debug("in atapi port stop\n");
+	dev_dbg(ap->dev, "in atapi port stop\n");
 	if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
 		free_dma(CH_ATAPI_RX);
 		free_dma(CH_ATAPI_TX);
@@ -1337,7 +1336,7 @@ static void bfin_port_stop(struct ata_port *ap)
 
 static int bfin_port_start(struct ata_port *ap)
 {
-	pr_debug("in atapi port start\n");
+	dev_dbg(ap->dev, "in atapi port start\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
 		return 0;
 
@@ -1373,10 +1372,6 @@ static struct scsi_host_template bfin_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations bfin_pata_ops = {
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 1388cef..81ef207 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sl82c105"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 enum {
 	/*
@@ -206,6 +206,34 @@ static void sl82c105_bmdma_stop(struct ata_queued_cmd *qc)
 	sl82c105_set_piomode(ap, qc->dev);
 }
 
+/**
+ *	sl82c105_qc_defer	-	implement serialization
+ *	@qc: command
+ *
+ *	We must issue one command per host not per channel because
+ *	of the reset bug.
+ *
+ *	Q: is the scsi host lock sufficient ?
+ */
+
+static int sl82c105_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_host *host = qc->ap->host;
+	struct ata_port *alt = host->ports[1 ^ qc->ap->port_no];
+	int rc;
+
+	/* First apply the usual rules */	
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	/* Now apply serialization rules. Only allow a command if the
+	   other channel state machine is idle */
+	if (alt && alt->qc_active)
+		return	ATA_DEFER_PORT;
+	return 0;
+}
+
 static struct scsi_host_template sl82c105_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -245,6 +273,7 @@ static struct ata_port_operations sl82c105_port_ops = {
 	.bmdma_stop	= sl82c105_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
 
+	.qc_defer	= sl82c105_qc_defer,
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
 
@@ -312,7 +341,7 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	};
 	/* for now use only the first port */
 	const struct ata_port_info *ppi[] = { &info_early,
-					       &ata_dummy_port_info };
+					       NULL };
 	u32 val;
 	int rev;
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 7e72463..3c1b5c9 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -29,7 +29,13 @@
   I distinctly remember a couple workarounds (one related to PCI-X)
   are still needed.
 
-  4) Add NCQ support (easy to intermediate, once new-EH support appears)
+  2) Improve/fix IRQ and error handling sequences.
+
+  3) ATAPI support (Marvell claims the 60xx/70xx chips can do it).
+
+  4) Think about TCQ support here, and for libata in general
+  with controllers that suppport it via host-queuing hardware
+  (a software-only implementation could be a nightmare).
 
   5) Investigate problems with PCI Message Signalled Interrupts (MSI).
 
@@ -53,8 +59,6 @@
   Target mode, for those without docs, is the ability to directly
   connect two SATA controllers.
 
-  13) Verify that 7042 is fully supported.  I only have a 6042.
-
 */
 
 
@@ -73,7 +77,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.01"
+#define DRV_VERSION	"1.20"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -107,14 +111,12 @@ enum {
 
 	/* CRQB needs alignment on a 1KB boundary. Size == 1KB
 	 * CRPB needs alignment on a 256B boundary. Size == 256B
-	 * SG count of 176 leads to MV_PORT_PRIV_DMA_SZ == 4KB
 	 * ePRD (SG) entries need alignment on a 16B boundary. Size == 16B
 	 */
 	MV_CRQB_Q_SZ		= (32 * MV_MAX_Q_DEPTH),
 	MV_CRPB_Q_SZ		= (8 * MV_MAX_Q_DEPTH),
-	MV_MAX_SG_CT		= 176,
+	MV_MAX_SG_CT		= 256,
 	MV_SG_TBL_SZ		= (16 * MV_MAX_SG_CT),
-	MV_PORT_PRIV_DMA_SZ	= (MV_CRQB_Q_SZ + MV_CRPB_Q_SZ + MV_SG_TBL_SZ),
 
 	MV_PORTS_PER_HC		= 4,
 	/* == (port / MV_PORTS_PER_HC) to determine HC from 0-7 port */
@@ -125,6 +127,9 @@ enum {
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 	MV_FLAG_IRQ_COALESCE	= (1 << 29),  /* IRQ coalescing capability */
+	/* SoC integrated controllers, no PCI interface */
+	MV_FLAG_SOC = (1 << 28),
+
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
 				  ATA_FLAG_PIO_POLLING,
@@ -170,7 +175,7 @@ enum {
 
 	PCIE_IRQ_CAUSE_OFS	= 0x1900,
 	PCIE_IRQ_MASK_OFS	= 0x1910,
-	PCIE_UNMASK_ALL_IRQS	= 0x70a,	/* assorted bits */
+	PCIE_UNMASK_ALL_IRQS	= 0x40a,	/* assorted bits */
 
 	HC_MAIN_IRQ_CAUSE_OFS	= 0x1d60,
 	HC_MAIN_IRQ_MASK_OFS	= 0x1d64,
@@ -210,6 +215,7 @@ enum {
 	/* SATA registers */
 	SATA_STATUS_OFS		= 0x300,  /* ctrl, err regs follow status */
 	SATA_ACTIVE_OFS		= 0x350,
+	SATA_FIS_IRQ_CAUSE_OFS	= 0x364,
 	PHY_MODE3		= 0x310,
 	PHY_MODE4		= 0x314,
 	PHY_MODE2		= 0x330,
@@ -222,11 +228,11 @@ enum {
 
 	/* Port registers */
 	EDMA_CFG_OFS		= 0,
-	EDMA_CFG_Q_DEPTH	= 0,			/* queueing disabled */
-	EDMA_CFG_NCQ		= (1 << 5),
-	EDMA_CFG_NCQ_GO_ON_ERR	= (1 << 14),		/* continue on error */
-	EDMA_CFG_RD_BRST_EXT	= (1 << 11),		/* read burst 512B */
-	EDMA_CFG_WR_BUFF_LEN	= (1 << 13),		/* write buffer 512B */
+	EDMA_CFG_Q_DEPTH	= 0x1f,		/* max device queue depth */
+	EDMA_CFG_NCQ		= (1 << 5),	/* for R/W FPDMA queued */
+	EDMA_CFG_NCQ_GO_ON_ERR	= (1 << 14),	/* continue on error */
+	EDMA_CFG_RD_BRST_EXT	= (1 << 11),	/* read burst 512B */
+	EDMA_CFG_WR_BUFF_LEN	= (1 << 13),	/* write buffer 512B */
 
 	EDMA_ERR_IRQ_CAUSE_OFS	= 0x8,
 	EDMA_ERR_IRQ_MASK_OFS	= 0xc,
@@ -244,14 +250,33 @@ enum {
 	EDMA_ERR_CRPB_PAR	= (1 << 10),	/* CRPB parity error */
 	EDMA_ERR_INTRL_PAR	= (1 << 11),	/* internal parity error */
 	EDMA_ERR_IORDY		= (1 << 12),	/* IORdy timeout */
+
 	EDMA_ERR_LNK_CTRL_RX	= (0xf << 13),	/* link ctrl rx error */
-	EDMA_ERR_LNK_CTRL_RX_2	= (1 << 15),
+	EDMA_ERR_LNK_CTRL_RX_0	= (1 << 13),	/* transient: CRC err */
+	EDMA_ERR_LNK_CTRL_RX_1	= (1 << 14),	/* transient: FIFO err */
+	EDMA_ERR_LNK_CTRL_RX_2	= (1 << 15),	/* fatal: caught SYNC */
+	EDMA_ERR_LNK_CTRL_RX_3	= (1 << 16),	/* transient: FIS rx err */
+
 	EDMA_ERR_LNK_DATA_RX	= (0xf << 17),	/* link data rx error */
+
 	EDMA_ERR_LNK_CTRL_TX	= (0x1f << 21),	/* link ctrl tx error */
+	EDMA_ERR_LNK_CTRL_TX_0	= (1 << 21),	/* transient: CRC err */
+	EDMA_ERR_LNK_CTRL_TX_1	= (1 << 22),	/* transient: FIFO err */
+	EDMA_ERR_LNK_CTRL_TX_2	= (1 << 23),	/* transient: caught SYNC */
+	EDMA_ERR_LNK_CTRL_TX_3	= (1 << 24),	/* transient: caught DMAT */
+	EDMA_ERR_LNK_CTRL_TX_4	= (1 << 25),	/* transient: FIS collision */
+
 	EDMA_ERR_LNK_DATA_TX	= (0x1f << 26),	/* link data tx error */
+
 	EDMA_ERR_TRANS_PROTO	= (1 << 31),	/* transport protocol error */
 	EDMA_ERR_OVERRUN_5	= (1 << 5),
 	EDMA_ERR_UNDERRUN_5	= (1 << 6),
+
+	EDMA_ERR_IRQ_TRANSIENT  = EDMA_ERR_LNK_CTRL_RX_0 |
+				  EDMA_ERR_LNK_CTRL_RX_1 |
+				  EDMA_ERR_LNK_CTRL_RX_3 |
+				  EDMA_ERR_LNK_CTRL_TX,
+
 	EDMA_EH_FREEZE		= EDMA_ERR_D_PAR |
 				  EDMA_ERR_PRD_PAR |
 				  EDMA_ERR_DEV_DCON |
@@ -311,12 +336,14 @@ enum {
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
+	MV_PP_FLAG_NCQ_EN	= (1 << 1),	/* is EDMA set up for NCQ? */
 	MV_PP_FLAG_HAD_A_RESET	= (1 << 2),	/* 1st hard reset complete? */
 };
 
 #define IS_GEN_I(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_I)
 #define IS_GEN_II(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_II)
 #define IS_GEN_IIE(hpriv) ((hpriv)->hp_flags & MV_HP_GEN_IIE)
+#define HAS_PCI(host) (!((host)->ports[0]->flags & MV_FLAG_SOC))
 
 enum {
 	/* DMA boundary 0xffff is required by the s/g splitting
@@ -379,8 +406,8 @@ struct mv_port_priv {
 	dma_addr_t		crqb_dma;
 	struct mv_crpb		*crpb;
 	dma_addr_t		crpb_dma;
-	struct mv_sg		*sg_tbl;
-	dma_addr_t		sg_tbl_dma;
+	struct mv_sg		*sg_tbl[MV_MAX_Q_DEPTH];
+	dma_addr_t		sg_tbl_dma[MV_MAX_Q_DEPTH];
 
 	unsigned int		req_idx;
 	unsigned int		resp_idx;
@@ -400,6 +427,14 @@ struct mv_host_priv {
 	u32			irq_cause_ofs;
 	u32			irq_mask_ofs;
 	u32			unmask_all_irqs;
+	/*
+	 * These consistent DMA memory pools give us guaranteed
+	 * alignment for hardware-accessed data structures,
+	 * and less memory waste in accomplishing the alignment.
+	 */
+	struct dma_pool		*crqb_pool;
+	struct dma_pool		*crpb_pool;
+	struct dma_pool		*sg_tbl_pool;
 };
 
 struct mv_hw_ops {
@@ -411,7 +446,7 @@ struct mv_hw_ops {
 	int (*reset_hc)(struct mv_host_priv *hpriv, void __iomem *mmio,
 			unsigned int n_hc);
 	void (*reset_flash)(struct mv_host_priv *hpriv, void __iomem *mmio);
-	void (*reset_bus)(struct pci_dev *pdev, void __iomem *mmio);
+	void (*reset_bus)(struct ata_host *host, void __iomem *mmio);
 };
 
 static void mv_irq_clear(struct ata_port *ap);
@@ -425,10 +460,9 @@ static void mv_qc_prep(struct ata_queued_cmd *qc);
 static void mv_qc_prep_iie(struct ata_queued_cmd *qc);
 static unsigned int mv_qc_issue(struct ata_queued_cmd *qc);
 static void mv_error_handler(struct ata_port *ap);
-static void mv_post_int_cmd(struct ata_queued_cmd *qc);
 static void mv_eh_freeze(struct ata_port *ap);
 static void mv_eh_thaw(struct ata_port *ap);
-static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void mv6_dev_config(struct ata_device *dev);
 
 static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 			   unsigned int port);
@@ -438,7 +472,7 @@ static void mv5_read_preamp(struct mv_host_priv *hpriv, int idx,
 static int mv5_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 			unsigned int n_hc);
 static void mv5_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
-static void mv5_reset_bus(struct pci_dev *pdev, void __iomem *mmio);
+static void mv5_reset_bus(struct ata_host *host, void __iomem *mmio);
 
 static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 			   unsigned int port);
@@ -448,10 +482,17 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 static int mv6_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 			unsigned int n_hc);
 static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio);
-static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio);
+static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio);
 static void mv_channel_reset(struct mv_host_priv *hpriv, void __iomem *mmio,
 			     unsigned int port_no);
+static void mv_edma_cfg(struct mv_port_priv *pp, struct mv_host_priv *hpriv,
+			void __iomem *port_mmio, int want_ncq);
+static int __mv_stop_dma(struct ata_port *ap);
 
+/* .sg_tablesize is (MV_MAX_SG_CT / 2) in the structures below
+ * because we have to allow room for worst case splitting of
+ * PRDs for 64K boundaries in mv_fill_sg().
+ */
 static struct scsi_host_template mv5_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -475,7 +516,8 @@ static struct scsi_host_template mv6_sht = {
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.can_queue		= ATA_DEF_QUEUE,
+	.change_queue_depth	= ata_scsi_change_queue_depth,
+	.can_queue		= MV_MAX_Q_DEPTH - 1,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
@@ -505,7 +547,6 @@ static const struct ata_port_operations mv5_ops = {
 	.irq_on			= ata_irq_on,
 
 	.error_handler		= mv_error_handler,
-	.post_internal_cmd	= mv_post_int_cmd,
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
 
@@ -517,6 +558,7 @@ static const struct ata_port_operations mv5_ops = {
 };
 
 static const struct ata_port_operations mv6_ops = {
+	.dev_config             = mv6_dev_config,
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
 	.check_status		= ata_check_status,
@@ -533,9 +575,9 @@ static const struct ata_port_operations mv6_ops = {
 	.irq_on			= ata_irq_on,
 
 	.error_handler		= mv_error_handler,
-	.post_internal_cmd	= mv_post_int_cmd,
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
+	.qc_defer		= ata_std_qc_defer,
 
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
@@ -561,9 +603,9 @@ static const struct ata_port_operations mv_iie_ops = {
 	.irq_on			= ata_irq_on,
 
 	.error_handler		= mv_error_handler,
-	.post_internal_cmd	= mv_post_int_cmd,
 	.freeze			= mv_eh_freeze,
 	.thaw			= mv_eh_thaw,
+	.qc_defer		= ata_std_qc_defer,
 
 	.scr_read		= mv_scr_read,
 	.scr_write		= mv_scr_write,
@@ -592,26 +634,29 @@ static const struct ata_port_info mv_port_info[] = {
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
 		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
-				  MV_FLAG_DUAL_HC,
+				  ATA_FLAG_NCQ | MV_FLAG_DUAL_HC,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
-		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS,
+		.flags		= MV_COMMON_FLAGS | MV_6XXX_FLAGS |
+				  ATA_FLAG_NCQ,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
@@ -648,13 +693,6 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	{ }			/* terminate list */
 };
 
-static struct pci_driver mv_pci_driver = {
-	.name			= DRV_NAME,
-	.id_table		= mv_pci_tbl,
-	.probe			= mv_init_one,
-	.remove			= ata_pci_remove_one,
-};
-
 static const struct mv_hw_ops mv5xxx_ops = {
 	.phy_errata		= mv5_phy_errata,
 	.enable_leds		= mv5_enable_leds,
@@ -674,45 +712,6 @@ static const struct mv_hw_ops mv6xxx_ops = {
 };
 
 /*
- * module options
- */
-static int msi;	      /* Use PCI msi; either zero (off, default) or non-zero */
-
-
-/* move to PCI layer or libata core? */
-static int pci_go_64(struct pci_dev *pdev)
-{
-	int rc;
-
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
-		if (rc) {
-			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
-			if (rc) {
-				dev_printk(KERN_ERR, &pdev->dev,
-					   "64-bit DMA enable failed\n");
-				return rc;
-			}
-		}
-	} else {
-		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit DMA enable failed\n");
-			return rc;
-		}
-		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
-		if (rc) {
-			dev_printk(KERN_ERR, &pdev->dev,
-				   "32-bit consistent DMA enable failed\n");
-			return rc;
-		}
-	}
-
-	return rc;
-}
-
-/*
  * Functions
  */
 
@@ -815,19 +814,46 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
  *      LOCKING:
  *      Inherited from caller.
  */
-static void mv_start_dma(void __iomem *base, struct mv_host_priv *hpriv,
-			 struct mv_port_priv *pp)
+static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
+			 struct mv_port_priv *pp, u8 protocol)
 {
+	int want_ncq = (protocol == ATA_PROT_NCQ);
+
+	if (pp->pp_flags & MV_PP_FLAG_EDMA_EN) {
+		int using_ncq = ((pp->pp_flags & MV_PP_FLAG_NCQ_EN) != 0);
+		if (want_ncq != using_ncq)
+			__mv_stop_dma(ap);
+	}
 	if (!(pp->pp_flags & MV_PP_FLAG_EDMA_EN)) {
+		struct mv_host_priv *hpriv = ap->host->private_data;
+		int hard_port = mv_hardport_from_port(ap->port_no);
+		void __iomem *hc_mmio = mv_hc_base_from_port(
+				ap->host->iomap[MV_PRIMARY_BAR], hard_port);
+		u32 hc_irq_cause, ipending;
+
 		/* clear EDMA event indicators, if any */
-		writelfl(0, base + EDMA_ERR_IRQ_CAUSE_OFS);
+		writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+
+		/* clear EDMA interrupt indicator, if any */
+		hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
+		ipending = (DEV_IRQ << hard_port) |
+				(CRPB_DMA_DONE << hard_port);
+		if (hc_irq_cause & ipending) {
+			writelfl(hc_irq_cause & ~ipending,
+				 hc_mmio + HC_IRQ_CAUSE_OFS);
+		}
+
+		mv_edma_cfg(pp, hpriv, port_mmio, want_ncq);
+
+		/* clear FIS IRQ Cause */
+		writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
 
-		mv_set_edma_ptrs(base, hpriv, pp);
+		mv_set_edma_ptrs(port_mmio, hpriv, pp);
 
-		writelfl(EDMA_EN, base + EDMA_CMD_OFS);
+		writelfl(EDMA_EN, port_mmio + EDMA_CMD_OFS);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
-	WARN_ON(!(EDMA_EN & readl(base + EDMA_CMD_OFS)));
+	WARN_ON(!(EDMA_EN & readl(port_mmio + EDMA_CMD_OFS)));
 }
 
 /**
@@ -1003,38 +1029,76 @@ static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 		return -EINVAL;
 }
 
-static void mv_edma_cfg(struct ata_port *ap, struct mv_host_priv *hpriv,
-			void __iomem *port_mmio)
+static void mv6_dev_config(struct ata_device *adev)
 {
-	u32 cfg = readl(port_mmio + EDMA_CFG_OFS);
+	/*
+	 * We don't have hob_nsect when doing NCQ commands on Gen-II.
+	 * See mv_qc_prep() for more info.
+	 */
+	if (adev->flags & ATA_DFLAG_NCQ)
+		if (adev->max_sectors > ATA_MAX_SECTORS)
+			adev->max_sectors = ATA_MAX_SECTORS;
+}
+
+static void mv_edma_cfg(struct mv_port_priv *pp, struct mv_host_priv *hpriv,
+			void __iomem *port_mmio, int want_ncq)
+{
+	u32 cfg;
 
 	/* set up non-NCQ EDMA configuration */
-	cfg &= ~(1 << 9);	/* disable eQue */
+	cfg = EDMA_CFG_Q_DEPTH;		/* always 0x1f for *all* chips */
 
-	if (IS_GEN_I(hpriv)) {
-		cfg &= ~0x1f;		/* clear queue depth */
+	if (IS_GEN_I(hpriv))
 		cfg |= (1 << 8);	/* enab config burst size mask */
-	}
 
-	else if (IS_GEN_II(hpriv)) {
-		cfg &= ~0x1f;		/* clear queue depth */
+	else if (IS_GEN_II(hpriv))
 		cfg |= EDMA_CFG_RD_BRST_EXT | EDMA_CFG_WR_BUFF_LEN;
-		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
-	}
 
 	else if (IS_GEN_IIE(hpriv)) {
 		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
 		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
-		cfg &= ~(1 << 19);	/* dis 128-entry queue (for now?) */
 		cfg |= (1 << 18);	/* enab early completion */
 		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
-		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
-		cfg &= ~(EDMA_CFG_NCQ);	/* clear NCQ */
 	}
 
+	if (want_ncq) {
+		cfg |= EDMA_CFG_NCQ;
+		pp->pp_flags |=  MV_PP_FLAG_NCQ_EN;
+	} else
+		pp->pp_flags &= ~MV_PP_FLAG_NCQ_EN;
+
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
 }
 
+static void mv_port_free_dma_mem(struct ata_port *ap)
+{
+	struct mv_host_priv *hpriv = ap->host->private_data;
+	struct mv_port_priv *pp = ap->private_data;
+	int tag;
+
+	if (pp->crqb) {
+		dma_pool_free(hpriv->crqb_pool, pp->crqb, pp->crqb_dma);
+		pp->crqb = NULL;
+	}
+	if (pp->crpb) {
+		dma_pool_free(hpriv->crpb_pool, pp->crpb, pp->crpb_dma);
+		pp->crpb = NULL;
+	}
+	/*
+	 * For GEN_I, there's no NCQ, so we have only a single sg_tbl.
+	 * For later hardware, we have one unique sg_tbl per NCQ tag.
+	 */
+	for (tag = 0; tag < MV_MAX_Q_DEPTH; ++tag) {
+		if (pp->sg_tbl[tag]) {
+			if (tag == 0 || !IS_GEN_I(hpriv))
+				dma_pool_free(hpriv->sg_tbl_pool,
+					      pp->sg_tbl[tag],
+					      pp->sg_tbl_dma[tag]);
+			pp->sg_tbl[tag] = NULL;
+		}
+	}
+}
+
 /**
  *      mv_port_start - Port specific init/start routine.
  *      @ap: ATA channel to manipulate
@@ -1051,51 +1115,47 @@ static int mv_port_start(struct ata_port *ap)
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	struct mv_port_priv *pp;
 	void __iomem *port_mmio = mv_ap_base(ap);
-	void *mem;
-	dma_addr_t mem_dma;
 	unsigned long flags;
-	int rc;
+	int tag, rc;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
-
-	mem = dmam_alloc_coherent(dev, MV_PORT_PRIV_DMA_SZ, &mem_dma,
-				  GFP_KERNEL);
-	if (!mem)
-		return -ENOMEM;
-	memset(mem, 0, MV_PORT_PRIV_DMA_SZ);
+	ap->private_data = pp;
 
 	rc = ata_pad_alloc(ap, dev);
 	if (rc)
 		return rc;
 
-	/* First item in chunk of DMA memory:
-	 * 32-slot command request table (CRQB), 32 bytes each in size
-	 */
-	pp->crqb = mem;
-	pp->crqb_dma = mem_dma;
-	mem += MV_CRQB_Q_SZ;
-	mem_dma += MV_CRQB_Q_SZ;
+	pp->crqb = dma_pool_alloc(hpriv->crqb_pool, GFP_KERNEL, &pp->crqb_dma);
+	if (!pp->crqb)
+		return -ENOMEM;
+	memset(pp->crqb, 0, MV_CRQB_Q_SZ);
 
-	/* Second item:
-	 * 32-slot command response table (CRPB), 8 bytes each in size
-	 */
-	pp->crpb = mem;
-	pp->crpb_dma = mem_dma;
-	mem += MV_CRPB_Q_SZ;
-	mem_dma += MV_CRPB_Q_SZ;
+	pp->crpb = dma_pool_alloc(hpriv->crpb_pool, GFP_KERNEL, &pp->crpb_dma);
+	if (!pp->crpb)
+		goto out_port_free_dma_mem;
+	memset(pp->crpb, 0, MV_CRPB_Q_SZ);
 
-	/* Third item:
-	 * Table of scatter-gather descriptors (ePRD), 16 bytes each
+	/*
+	 * For GEN_I, there's no NCQ, so we only allocate a single sg_tbl.
+	 * For later hardware, we need one unique sg_tbl per NCQ tag.
 	 */
-	pp->sg_tbl = mem;
-	pp->sg_tbl_dma = mem_dma;
+	for (tag = 0; tag < MV_MAX_Q_DEPTH; ++tag) {
+		if (tag == 0 || !IS_GEN_I(hpriv)) {
+			pp->sg_tbl[tag] = dma_pool_alloc(hpriv->sg_tbl_pool,
+					      GFP_KERNEL, &pp->sg_tbl_dma[tag]);
+			if (!pp->sg_tbl[tag])
+				goto out_port_free_dma_mem;
+		} else {
+			pp->sg_tbl[tag]     = pp->sg_tbl[0];
+			pp->sg_tbl_dma[tag] = pp->sg_tbl_dma[0];
+		}
+	}
 
 	spin_lock_irqsave(&ap->host->lock, flags);
 
-	mv_edma_cfg(ap, hpriv, port_mmio);
-
+	mv_edma_cfg(pp, hpriv, port_mmio, 0);
 	mv_set_edma_ptrs(port_mmio, hpriv, pp);
 
 	spin_unlock_irqrestore(&ap->host->lock, flags);
@@ -1104,8 +1164,11 @@ static int mv_port_start(struct ata_port *ap)
 	 * we'll be unable to send non-data, PIO, etc due to restricted access
 	 * to shadow regs.
 	 */
-	ap->private_data = pp;
 	return 0;
+
+out_port_free_dma_mem:
+	mv_port_free_dma_mem(ap);
+	return -ENOMEM;
 }
 
 /**
@@ -1120,6 +1183,7 @@ static int mv_port_start(struct ata_port *ap)
 static void mv_port_stop(struct ata_port *ap)
 {
 	mv_stop_dma(ap);
+	mv_port_free_dma_mem(ap);
 }
 
 /**
@@ -1138,7 +1202,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 	struct mv_sg *mv_sg, *last_sg = NULL;
 	unsigned int si;
 
-	mv_sg = pp->sg_tbl;
+	mv_sg = pp->sg_tbl[qc->tag];
 	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
@@ -1194,7 +1258,8 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	u16 flags = 0;
 	unsigned in_index;
 
-	if (qc->tf.protocol != ATA_PROT_DMA)
+	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ))
 		return;
 
 	/* Fill in command request block
@@ -1203,15 +1268,14 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 		flags |= CRQB_FLAG_READ;
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
-	flags |= qc->tag << CRQB_IOID_SHIFT;	/* 50xx appears to ignore this*/
 
 	/* get current queue index from software */
 	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	pp->crqb[in_index].sg_addr =
-		cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
+		cpu_to_le32(pp->sg_tbl_dma[qc->tag] & 0xffffffff);
 	pp->crqb[in_index].sg_addr_hi =
-		cpu_to_le32((pp->sg_tbl_dma >> 16) >> 16);
+		cpu_to_le32((pp->sg_tbl_dma[qc->tag] >> 16) >> 16);
 	pp->crqb[in_index].ctrl_flags = cpu_to_le16(flags);
 
 	cw = &pp->crqb[in_index].ata_cmd[0];
@@ -1231,13 +1295,11 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	case ATA_CMD_WRITE_FUA_EXT:
 		mv_crqb_pack_cmd(cw++, tf->hob_nsect, ATA_REG_NSECT, 0);
 		break;
-#ifdef LIBATA_NCQ		/* FIXME: remove this line when NCQ added */
 	case ATA_CMD_FPDMA_READ:
 	case ATA_CMD_FPDMA_WRITE:
 		mv_crqb_pack_cmd(cw++, tf->hob_feature, ATA_REG_FEATURE, 0);
 		mv_crqb_pack_cmd(cw++, tf->feature, ATA_REG_FEATURE, 0);
 		break;
-#endif				/* FIXME: remove this line when NCQ added */
 	default:
 		/* The only other commands EDMA supports in non-queued and
 		 * non-NCQ mode are: [RW] STREAM DMA and W DMA FUA EXT, none
@@ -1286,7 +1348,8 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 	unsigned in_index;
 	u32 flags = 0;
 
-	if (qc->tf.protocol != ATA_PROT_DMA)
+	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ))
 		return;
 
 	/* Fill in Gen IIE command request block
@@ -1296,15 +1359,14 @@ static void mv_qc_prep_iie(struct ata_queued_cmd *qc)
 
 	WARN_ON(MV_MAX_Q_DEPTH <= qc->tag);
 	flags |= qc->tag << CRQB_TAG_SHIFT;
-	flags |= qc->tag << CRQB_IOID_SHIFT;	/* "I/O Id" is -really-
-						   what we use as our tag */
+	flags |= qc->tag << CRQB_HOSTQ_SHIFT;
 
 	/* get current queue index from software */
 	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
 
 	crqb = (struct mv_crqb_iie *) &pp->crqb[in_index];
-	crqb->addr = cpu_to_le32(pp->sg_tbl_dma & 0xffffffff);
-	crqb->addr_hi = cpu_to_le32((pp->sg_tbl_dma >> 16) >> 16);
+	crqb->addr = cpu_to_le32(pp->sg_tbl_dma[qc->tag] & 0xffffffff);
+	crqb->addr_hi = cpu_to_le32((pp->sg_tbl_dma[qc->tag] >> 16) >> 16);
 	crqb->flags = cpu_to_le32(flags);
 
 	tf = &qc->tf;
@@ -1351,10 +1413,10 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
-	struct mv_host_priv *hpriv = ap->host->private_data;
 	u32 in_index;
 
-	if (qc->tf.protocol != ATA_PROT_DMA) {
+	if ((qc->tf.protocol != ATA_PROT_DMA) &&
+	    (qc->tf.protocol != ATA_PROT_NCQ)) {
 		/* We're about to send a non-EDMA capable command to the
 		 * port.  Turn off EDMA so there won't be problems accessing
 		 * shadow block, etc registers.
@@ -1363,13 +1425,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 		return ata_qc_issue_prot(qc);
 	}
 
-	mv_start_dma(port_mmio, hpriv, pp);
-
-	in_index = pp->req_idx & MV_MAX_Q_DEPTH_MASK;
-
-	/* until we do queuing, the queue should be empty at this point */
-	WARN_ON(in_index != ((readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
-		>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK));
+	mv_start_dma(ap, port_mmio, pp, qc->tf.protocol);
 
 	pp->req_idx++;
 
@@ -1437,6 +1493,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 		ata_ehi_hotplugged(ehi);
 		ata_ehi_push_desc(ehi, edma_err_cause & EDMA_ERR_DEV_DCON ?
 			"dev disconnect" : "dev connect");
+		action |= ATA_EH_HARDRESET;
 	}
 
 	if (IS_GEN_I(hpriv)) {
@@ -1465,7 +1522,7 @@ static void mv_err_intr(struct ata_port *ap, struct ata_queued_cmd *qc)
 	}
 
 	/* Clear EDMA now that SERR cleanup done */
-	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
 	if (!err_mask) {
 		err_mask = AC_ERR_OTHER;
@@ -1538,23 +1595,17 @@ static void mv_intr_edma(struct ata_port *ap)
 		 * support for queueing.  this works transparently for
 		 * queued and non-queued modes.
 		 */
-		else if (IS_GEN_II(hpriv))
-			tag = (le16_to_cpu(pp->crpb[out_index].id)
-				>> CRPB_IOID_SHIFT_6) & 0x3f;
-
-		else /* IS_GEN_IIE */
-			tag = (le16_to_cpu(pp->crpb[out_index].id)
-				>> CRPB_IOID_SHIFT_7) & 0x3f;
+		else
+			tag = le16_to_cpu(pp->crpb[out_index].id) & 0x1f;
 
 		qc = ata_qc_from_tag(ap, tag);
 
-		/* lower 8 bits of status are EDMA_ERR_IRQ_CAUSE_OFS
-		 * bits (WARNING: might not necessarily be associated
-		 * with this command), which -should- be clear
-		 * if all is well
+		/* For non-NCQ mode, the lower 8 bits of status
+		 * are from EDMA_ERR_IRQ_CAUSE_OFS,
+		 * which should be zero if all went well.
 		 */
 		status = le16_to_cpu(pp->crpb[out_index].flags);
-		if (unlikely(status & 0xff)) {
+		if ((status & 0xff) && !(pp->pp_flags & MV_PP_FLAG_NCQ_EN)) {
 			mv_err_intr(ap, qc);
 			return;
 		}
@@ -1715,20 +1766,21 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	unsigned int hc, handled = 0, n_hcs;
 	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
-	u32 irq_stat;
+	u32 irq_stat, irq_mask;
 
+	spin_lock(&host->lock);
 	irq_stat = readl(mmio + HC_MAIN_IRQ_CAUSE_OFS);
+	irq_mask = readl(mmio + HC_MAIN_IRQ_MASK_OFS);
 
 	/* check the cases where we either have nothing pending or have read
 	 * a bogus register value which can indicate HW removal or PCI fault
 	 */
-	if (!irq_stat || (0xffffffffU == irq_stat))
-		return IRQ_NONE;
+	if (!(irq_stat & irq_mask) || (0xffffffffU == irq_stat))
+		goto out_unlock;
 
 	n_hcs = mv_get_hc_count(host->ports[0]->flags);
-	spin_lock(&host->lock);
 
-	if (unlikely(irq_stat & PCI_ERR)) {
+	if (unlikely((irq_stat & PCI_ERR) && HAS_PCI(host))) {
 		mv_pci_error(host, mmio);
 		handled = 1;
 		goto out_unlock;	/* skip all other HC irq handling */
@@ -1799,8 +1851,9 @@ static int mv5_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val)
 		return -EINVAL;
 }
 
-static void mv5_reset_bus(struct pci_dev *pdev, void __iomem *mmio)
+static void mv5_reset_bus(struct ata_host *host, void __iomem *mmio)
 {
+	struct pci_dev *pdev = to_pci_dev(host->dev);
 	int early_5080;
 
 	early_5080 = (pdev->device == 0x5080) && (pdev->revision == 0);
@@ -1811,7 +1864,7 @@ static void mv5_reset_bus(struct pci_dev *pdev, void __iomem *mmio)
 		writel(tmp, mmio + MV_PCI_EXP_ROM_BAR_CTL);
 	}
 
-	mv_reset_pci_bus(pdev, mmio);
+	mv_reset_pci_bus(host, mmio);
 }
 
 static void mv5_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
@@ -1935,9 +1988,8 @@ static int mv5_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 
 #undef ZERO
 #define ZERO(reg) writel(0, mmio + (reg))
-static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio)
+static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio)
 {
-	struct ata_host     *host = dev_get_drvdata(&pdev->dev);
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 tmp;
 
@@ -2329,11 +2381,6 @@ static void mv_error_handler(struct ata_port *ap)
 		  mv_hardreset, mv_postreset);
 }
 
-static void mv_post_int_cmd(struct ata_queued_cmd *qc)
-{
-	mv_stop_dma(qc->ap);
-}
-
 static void mv_eh_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio = ap->host->iomap[MV_PRIMARY_BAR];
@@ -2427,8 +2474,8 @@ static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 	writelfl(readl(port_mmio + serr_ofs), port_mmio + serr_ofs);
 	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-	/* unmask all EDMA error interrupts */
-	writelfl(~0, port_mmio + EDMA_ERR_IRQ_MASK_OFS);
+	/* unmask all non-transient EDMA error interrupts */
+	writelfl(~EDMA_ERR_IRQ_TRANSIENT, port_mmio + EDMA_ERR_IRQ_MASK_OFS);
 
 	VPRINTK("EDMA cfg=0x%08x EDMA IRQ err cause/mask=0x%08x/0x%08x\n",
 		readl(port_mmio + EDMA_CFG_OFS),
@@ -2586,7 +2633,6 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 {
 	int rc = 0, n_hc, port, hc;
-	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[MV_PRIMARY_BAR];
 	struct mv_host_priv *hpriv = host->private_data;
 
@@ -2607,7 +2653,7 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		goto done;
 
 	hpriv->ops->reset_flash(hpriv, mmio);
-	hpriv->ops->reset_bus(pdev, mmio);
+	hpriv->ops->reset_bus(host, mmio);
 	hpriv->ops->enable_leds(hpriv, mmio);
 
 	for (port = 0; port < host->n_ports; port++) {
@@ -2630,8 +2676,10 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 
 		mv_port_init(&ap->ioaddr, port_mmio);
 
+#ifdef CONFIG_PCI
 		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
 		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
+#endif
 	}
 
 	for (hc = 0; hc < n_hc; hc++) {
@@ -2668,6 +2716,55 @@ done:
 	return rc;
 }
 
+#ifdef CONFIG_PCI
+static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+
+static struct pci_driver mv_pci_driver = {
+	.name			= DRV_NAME,
+	.id_table		= mv_pci_tbl,
+	.probe			= mv_init_one,
+	.remove			= ata_pci_remove_one,
+};
+
+/*
+ * module options
+ */
+static int msi;	      /* Use PCI msi; either zero (off, default) or non-zero */
+
+
+/* move to PCI layer or libata core? */
+static int pci_go_64(struct pci_dev *pdev)
+{
+	int rc;
+
+	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		if (rc) {
+			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+			if (rc) {
+				dev_printk(KERN_ERR, &pdev->dev,
+					   "64-bit DMA enable failed\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit DMA enable failed\n");
+			return rc;
+		}
+		rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
+		if (rc) {
+			dev_printk(KERN_ERR, &pdev->dev,
+				   "32-bit consistent DMA enable failed\n");
+			return rc;
+		}
+	}
+
+	return rc;
+}
+
 /**
  *      mv_print_info - Dump key info to kernel log for perusal.
  *      @host: ATA host to print info about
@@ -2710,6 +2807,26 @@ static void mv_print_info(struct ata_host *host)
 	       scc_s, (MV_HP_FLAG_MSI & hpriv->hp_flags) ? "MSI" : "INTx");
 }
 
+static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
+{
+	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
+							     MV_CRQB_Q_SZ, 0);
+	if (!hpriv->crqb_pool)
+		return -ENOMEM;
+
+	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
+							     MV_CRPB_Q_SZ, 0);
+	if (!hpriv->crpb_pool)
+		return -ENOMEM;
+
+	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
+							     MV_SG_TBL_SZ, 0);
+	if (!hpriv->sg_tbl_pool)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /**
  *      mv_init_one - handle a positive probe of a Marvell host
  *      @pdev: PCI device found
@@ -2755,6 +2872,10 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+	rc = mv_create_dma_pools(hpriv, &pdev->dev);
+	if (rc)
+		return rc;
+
 	/* initialize adapter */
 	rc = mv_init_host(host, board_idx);
 	if (rc)
@@ -2772,15 +2893,22 @@ static int mv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
 				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
 }
+#endif
 
 static int __init mv_init(void)
 {
-	return pci_register_driver(&mv_pci_driver);
+	int rc = -ENODEV;
+#ifdef CONFIG_PCI
+	rc = pci_register_driver(&mv_pci_driver);
+#endif
+	return rc;
 }
 
 static void __exit mv_exit(void)
 {
+#ifdef CONFIG_PCI
 	pci_unregister_driver(&mv_pci_driver);
+#endif
 }
 
 MODULE_AUTHOR("Brett Russ");
@@ -2789,8 +2917,10 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, mv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
+#ifdef CONFIG_PCI
 module_param(msi, int, 0444);
 MODULE_PARM_DESC(msi, "Enable use of PCI MSI (0=off, 1=on)");
+#endif
 
 module_init(mv_init);
 module_exit(mv_exit);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index a0f98fd..bfe92a4 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1011,14 +1011,20 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			}
 
 			if (status & (NV_ADMA_STAT_DONE |
-				      NV_ADMA_STAT_CPBERR)) {
-				u32 check_commands;
+				      NV_ADMA_STAT_CPBERR |
+				      NV_ADMA_STAT_CMD_COMPLETE)) {
+				u32 check_commands = notifier_clears[i];
 				int pos, error = 0;
 
-				if (ata_tag_valid(ap->link.active_tag))
-					check_commands = 1 << ap->link.active_tag;
-				else
-					check_commands = ap->link.sactive;
+				if (status & NV_ADMA_STAT_CPBERR) {
+					/* Check all active commands */
+					if (ata_tag_valid(ap->link.active_tag))
+						check_commands = 1 <<
+							ap->link.active_tag;
+					else
+						check_commands = ap->
+							link.sactive;
+				}
 
 				/** Check CPBs for completed commands */
 				while ((pos = ffs(check_commands)) && !error) {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 71d561f..7d4ce90 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -823,7 +823,8 @@ int pcim_enable_device(struct pci_dev *pdev)
 	dr = get_pci_dr(pdev);
 	if (unlikely(!dr))
 		return -ENOMEM;
-	WARN_ON(!!dr->enabled);
+	if (dr->enabled)
+		return 0;
 
 	rc = pci_enable_device(pdev);
 	if (!rc) {
