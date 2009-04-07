Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZDGBmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZDGBmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZDGBmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:42:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49337 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbZDGBmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:42:35 -0400
Date: Mon, 6 Apr 2009 21:42:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       axboe@kernel.dk
Subject: [git patches] libata updates
Message-ID: <20090407014232.GA5966@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notables:

- sata_mv fixes

- add definitions for TRIM infrastructure to linux/ata.h 
  (part of "discard" support, for more SSD/flash-friendly operation)

- block/blk-settings.c: code comment speling fix from Alan

- other misc fixes


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 block/blk-settings.c         |    2 +-
 drivers/ata/ahci.c           |   17 ++-
 drivers/ata/ata_piix.c       |    7 +
 drivers/ata/pata_octeon_cf.c |    6 +-
 drivers/ata/sata_mv.c        |  487 ++++++++++++++++++++++++------------------
 include/linux/ata.h          |   41 ++++
 6 files changed, 344 insertions(+), 216 deletions(-)

Alan Cox (1):
      pata_artop: typo

David Daney (1):
      libata: Remove some redundant casts from pata_octeon_cf.c

David Milburn (1):
      libata: ahci enclosure management bios workaround

Mark Lord (8):
      sata_mv: revert SoC irq breakage
      sata_mv: fix irq mask races
      sata_mv: replace 0x1f with ATA_PIO4 (v2)
      sata_mv: workaround errata PCI#7
      sata_mv: workaround errata SATA#26
      sata_mv: cosmetic renames
      sata_mv: workaround errata SATA#13
      sata_mv: shorten register names

Matthew Wilcox (1):
      ata: Add TRIM infrastructure

Tejun Heo (1):
      ata_piix: VGN-BX297XP wants the controller power up on suspend

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 59fd05d..69c42ad 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -431,7 +431,7 @@ EXPORT_SYMBOL(blk_queue_segment_boundary);
  *
  * description:
  *    set required memory and length alignment for direct dma transactions.
- *    this is used when buiding direct io requests for the queue.
+ *    this is used when building direct io requests for the queue.
  *
  **/
 void blk_queue_dma_alignment(struct request_queue *q, int mask)
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 788bba2..6ca4bc0 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -78,6 +78,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
 #define MAX_SLOTS 8
+#define MAX_RETRY 15
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -1115,6 +1116,8 @@ static void ahci_start_port(struct ata_port *ap)
 	struct ahci_port_priv *pp = ap->private_data;
 	struct ata_link *link;
 	struct ahci_em_priv *emp;
+	ssize_t rc;
+	int i;
 
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
@@ -1126,7 +1129,17 @@ static void ahci_start_port(struct ata_port *ap)
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {
 			emp = &pp->em_priv[link->pmp];
-			ahci_transmit_led_message(ap, emp->led_state, 4);
+
+			/* EM Transmit bit maybe busy during init */
+			for (i = 0; i < MAX_RETRY; i++) {
+				rc = ahci_transmit_led_message(ap,
+							       emp->led_state,
+							       4);
+				if (rc == -EBUSY)
+					udelay(100);
+				else
+					break;
+			}
 		}
 	}
 
@@ -1331,7 +1344,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 	em_ctl = readl(mmio + HOST_EM_CTL);
 	if (em_ctl & EM_CTL_TM) {
 		spin_unlock_irqrestore(ap->lock, flags);
-		return -EINVAL;
+		return -EBUSY;
 	}
 
 	/*
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index e5cbe80..942d14a 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1053,6 +1053,13 @@ static int piix_broken_suspend(void)
 				DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M500"),
 			},
 		},
+		{
+			.ident = "VGN-BX297XP",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "VGN-BX297XP"),
+			},
+		},
 
 		{ }	/* terminate list */
 	};
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index efe2c19..8d9343a 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -503,7 +503,7 @@ static void octeon_cf_dma_setup(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct octeon_cf_port *cf_port;
 
-	cf_port = (struct octeon_cf_port *)ap->private_data;
+	cf_port = ap->private_data;
 	DPRINTK("ENTER\n");
 	/* issue r/w command */
 	qc->cursg = qc->sg;
@@ -596,7 +596,7 @@ static unsigned int octeon_cf_dma_finished(struct ata_port *ap,
 	if (ap->hsm_task_state != HSM_ST_LAST)
 		return 0;
 
-	cf_port = (struct octeon_cf_port *)ap->private_data;
+	cf_port = ap->private_data;
 
 	dma_cfg.u64 = cvmx_read_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine));
 	if (dma_cfg.s.size != 0xfffff) {
@@ -657,7 +657,7 @@ static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
 			continue;
 
 		ocd = ap->dev->platform_data;
-		cf_port = (struct octeon_cf_port *)ap->private_data;
+		cf_port = ap->private_data;
 		dma_int.u64 =
 			cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine));
 		dma_cfg.u64 =
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index a377226..fffba9b 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -28,10 +28,6 @@
 /*
  * sata_mv TODO list:
  *
- * --> More errata workarounds for PCI-X.
- *
- * --> Complete a full errata audit for all chipsets to identify others.
- *
  * --> Develop a low-power-consumption strategy, and implement it.
  *
  * --> Add sysfs attributes for per-chip / per-HC IRQ coalescing thresholds.
@@ -44,6 +40,15 @@
  *       connect two SATA ports.
  */
 
+/*
+ * 80x1-B2 errata PCI#11:
+ *
+ * Users of the 6041/6081 Rev.B2 chips (current is C0)
+ * should be careful to insert those cards only onto PCI-X bus #0,
+ * and only in device slots 0..7, not higher.  The chips may not
+ * work correctly otherwise  (note: this is a pretty rare condition).
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -64,7 +69,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.27"
+#define DRV_VERSION	"1.28"
 
 /*
  * module options
@@ -109,23 +114,23 @@ enum {
 	 * Coalescing defers the interrupt until either the IO_THRESHOLD
 	 * (count of completed I/Os) is met, or the TIME_THRESHOLD is met.
 	 */
-	MV_COAL_REG_BASE	= 0x18000,
-	MV_IRQ_COAL_CAUSE	= (MV_COAL_REG_BASE + 0x08),
+	COAL_REG_BASE		= 0x18000,
+	IRQ_COAL_CAUSE		= (COAL_REG_BASE + 0x08),
 	ALL_PORTS_COAL_IRQ	= (1 << 4),	/* all ports irq event */
 
-	MV_IRQ_COAL_IO_THRESHOLD   = (MV_COAL_REG_BASE + 0xcc),
-	MV_IRQ_COAL_TIME_THRESHOLD = (MV_COAL_REG_BASE + 0xd0),
+	IRQ_COAL_IO_THRESHOLD   = (COAL_REG_BASE + 0xcc),
+	IRQ_COAL_TIME_THRESHOLD = (COAL_REG_BASE + 0xd0),
 
 	/*
 	 * Registers for the (unused here) transaction coalescing feature:
 	 */
-	MV_TRAN_COAL_CAUSE_LO	= (MV_COAL_REG_BASE + 0x88),
-	MV_TRAN_COAL_CAUSE_HI	= (MV_COAL_REG_BASE + 0x8c),
+	TRAN_COAL_CAUSE_LO	= (COAL_REG_BASE + 0x88),
+	TRAN_COAL_CAUSE_HI	= (COAL_REG_BASE + 0x8c),
 
-	MV_SATAHC0_REG_BASE	= 0x20000,
-	MV_FLASH_CTL_OFS	= 0x1046c,
-	MV_GPIO_PORT_CTL_OFS	= 0x104f0,
-	MV_RESET_CFG_OFS	= 0x180d8,
+	SATAHC0_REG_BASE	= 0x20000,
+	FLASH_CTL		= 0x1046c,
+	GPIO_PORT_CTL		= 0x104f0,
+	RESET_CFG		= 0x180d8,
 
 	MV_PCI_REG_SZ		= MV_MAJOR_REG_AREA_SZ,
 	MV_SATAHC_REG_SZ	= MV_MAJOR_REG_AREA_SZ,
@@ -180,40 +185,41 @@ enum {
 
 	/* PCI interface registers */
 
-	PCI_COMMAND_OFS		= 0xc00,
-	PCI_COMMAND_MRDTRIG	= (1 << 7),	/* PCI Master Read Trigger */
+	MV_PCI_COMMAND		= 0xc00,
+	MV_PCI_COMMAND_MWRCOM	= (1 << 4),	/* PCI Master Write Combining */
+	MV_PCI_COMMAND_MRDTRIG	= (1 << 7),	/* PCI Master Read Trigger */
 
-	PCI_MAIN_CMD_STS_OFS	= 0xd30,
+	PCI_MAIN_CMD_STS	= 0xd30,
 	STOP_PCI_MASTER		= (1 << 2),
 	PCI_MASTER_EMPTY	= (1 << 3),
 	GLOB_SFT_RST		= (1 << 4),
 
-	MV_PCI_MODE_OFS		= 0xd00,
+	MV_PCI_MODE		= 0xd00,
 	MV_PCI_MODE_MASK	= 0x30,
 
 	MV_PCI_EXP_ROM_BAR_CTL	= 0xd2c,
 	MV_PCI_DISC_TIMER	= 0xd04,
 	MV_PCI_MSI_TRIGGER	= 0xc38,
 	MV_PCI_SERR_MASK	= 0xc28,
-	MV_PCI_XBAR_TMOUT_OFS	= 0x1d04,
+	MV_PCI_XBAR_TMOUT	= 0x1d04,
 	MV_PCI_ERR_LOW_ADDRESS	= 0x1d40,
 	MV_PCI_ERR_HIGH_ADDRESS	= 0x1d44,
 	MV_PCI_ERR_ATTRIBUTE	= 0x1d48,
 	MV_PCI_ERR_COMMAND	= 0x1d50,
 
-	PCI_IRQ_CAUSE_OFS	= 0x1d58,
-	PCI_IRQ_MASK_OFS	= 0x1d5c,
+	PCI_IRQ_CAUSE		= 0x1d58,
+	PCI_IRQ_MASK		= 0x1d5c,
 	PCI_UNMASK_ALL_IRQS	= 0x7fffff,	/* bits 22-0 */
 
-	PCIE_IRQ_CAUSE_OFS	= 0x1900,
-	PCIE_IRQ_MASK_OFS	= 0x1910,
+	PCIE_IRQ_CAUSE		= 0x1900,
+	PCIE_IRQ_MASK		= 0x1910,
 	PCIE_UNMASK_ALL_IRQS	= 0x40a,	/* assorted bits */
 
 	/* Host Controller Main Interrupt Cause/Mask registers (1 per-chip) */
-	PCI_HC_MAIN_IRQ_CAUSE_OFS = 0x1d60,
-	PCI_HC_MAIN_IRQ_MASK_OFS  = 0x1d64,
-	SOC_HC_MAIN_IRQ_CAUSE_OFS = 0x20020,
-	SOC_HC_MAIN_IRQ_MASK_OFS  = 0x20024,
+	PCI_HC_MAIN_IRQ_CAUSE	= 0x1d60,
+	PCI_HC_MAIN_IRQ_MASK	= 0x1d64,
+	SOC_HC_MAIN_IRQ_CAUSE	= 0x20020,
+	SOC_HC_MAIN_IRQ_MASK	= 0x20024,
 	ERR_IRQ			= (1 << 0),	/* shift by (2 * port #) */
 	DONE_IRQ		= (1 << 1),	/* shift by (2 * port #) */
 	HC0_IRQ_PEND		= 0x1ff,	/* bits 0-8 = HC0's ports */
@@ -234,9 +240,9 @@ enum {
 	HC_MAIN_RSVD_SOC	= (0x3fffffb << 6),     /* bits 31-9, 7-6 */
 
 	/* SATAHC registers */
-	HC_CFG_OFS		= 0,
+	HC_CFG			= 0x00,
 
-	HC_IRQ_CAUSE_OFS	= 0x14,
+	HC_IRQ_CAUSE		= 0x14,
 	DMA_IRQ			= (1 << 0),	/* shift by port # */
 	HC_COAL_IRQ		= (1 << 4),	/* IRQ coalescing */
 	DEV_IRQ			= (1 << 8),	/* shift by port # */
@@ -248,53 +254,54 @@ enum {
 	 * Coalescing defers the interrupt until either the IO_THRESHOLD
 	 * (count of completed I/Os) is met, or the TIME_THRESHOLD is met.
 	 */
-	HC_IRQ_COAL_IO_THRESHOLD_OFS	= 0x000c,
-	HC_IRQ_COAL_TIME_THRESHOLD_OFS	= 0x0010,
+	HC_IRQ_COAL_IO_THRESHOLD	= 0x000c,
+	HC_IRQ_COAL_TIME_THRESHOLD	= 0x0010,
 
-	SOC_LED_CTRL_OFS	= 0x2c,
+	SOC_LED_CTRL		= 0x2c,
 	SOC_LED_CTRL_BLINK	= (1 << 0),	/* Active LED blink */
 	SOC_LED_CTRL_ACT_PRESENCE = (1 << 2),	/* Multiplex dev presence */
 						/*  with dev activity LED */
 
 	/* Shadow block registers */
-	SHD_BLK_OFS		= 0x100,
-	SHD_CTL_AST_OFS		= 0x20,		/* ofs from SHD_BLK_OFS */
+	SHD_BLK			= 0x100,
+	SHD_CTL_AST		= 0x20,		/* ofs from SHD_BLK */
 
 	/* SATA registers */
-	SATA_STATUS_OFS		= 0x300,  /* ctrl, err regs follow status */
-	SATA_ACTIVE_OFS		= 0x350,
-	SATA_FIS_IRQ_CAUSE_OFS	= 0x364,
-	SATA_FIS_IRQ_AN		= (1 << 9),	/* async notification */
+	SATA_STATUS		= 0x300,  /* ctrl, err regs follow status */
+	SATA_ACTIVE		= 0x350,
+	FIS_IRQ_CAUSE		= 0x364,
+	FIS_IRQ_CAUSE_AN	= (1 << 9),	/* async notification */
 
-	LTMODE_OFS		= 0x30c,
+	LTMODE			= 0x30c,	/* requires read-after-write */
 	LTMODE_BIT8		= (1 << 8),	/* unknown, but necessary */
 
+	PHY_MODE2		= 0x330,
 	PHY_MODE3		= 0x310,
-	PHY_MODE4		= 0x314,
+
+	PHY_MODE4		= 0x314,	/* requires read-after-write */
 	PHY_MODE4_CFG_MASK	= 0x00000003,	/* phy internal config field */
 	PHY_MODE4_CFG_VALUE	= 0x00000001,	/* phy internal config field */
 	PHY_MODE4_RSVD_ZEROS	= 0x5de3fffa,	/* Gen2e always write zeros */
 	PHY_MODE4_RSVD_ONES	= 0x00000005,	/* Gen2e always write ones */
 
-	PHY_MODE2		= 0x330,
-	SATA_IFCTL_OFS		= 0x344,
-	SATA_TESTCTL_OFS	= 0x348,
-	SATA_IFSTAT_OFS		= 0x34c,
-	VENDOR_UNIQUE_FIS_OFS	= 0x35c,
+	SATA_IFCTL		= 0x344,
+	SATA_TESTCTL		= 0x348,
+	SATA_IFSTAT		= 0x34c,
+	VENDOR_UNIQUE_FIS	= 0x35c,
 
-	FISCFG_OFS		= 0x360,
+	FISCFG			= 0x360,
 	FISCFG_WAIT_DEV_ERR	= (1 << 8),	/* wait for host on DevErr */
 	FISCFG_SINGLE_SYNC	= (1 << 16),	/* SYNC on DMA activation */
 
 	MV5_PHY_MODE		= 0x74,
-	MV5_LTMODE_OFS		= 0x30,
-	MV5_PHY_CTL_OFS		= 0x0C,
-	SATA_INTERFACE_CFG_OFS	= 0x050,
+	MV5_LTMODE		= 0x30,
+	MV5_PHY_CTL		= 0x0C,
+	SATA_IFCFG		= 0x050,
 
 	MV_M2_PREAMP_MASK	= 0x7e0,
 
 	/* Port registers */
-	EDMA_CFG_OFS		= 0,
+	EDMA_CFG		= 0,
 	EDMA_CFG_Q_DEPTH	= 0x1f,		/* max device queue depth */
 	EDMA_CFG_NCQ		= (1 << 5),	/* for R/W FPDMA queued */
 	EDMA_CFG_NCQ_GO_ON_ERR	= (1 << 14),	/* continue on error */
@@ -303,8 +310,8 @@ enum {
 	EDMA_CFG_EDMA_FBS	= (1 << 16),	/* EDMA FIS-Based Switching */
 	EDMA_CFG_FBS		= (1 << 26),	/* FIS-Based Switching */
 
-	EDMA_ERR_IRQ_CAUSE_OFS	= 0x8,
-	EDMA_ERR_IRQ_MASK_OFS	= 0xc,
+	EDMA_ERR_IRQ_CAUSE	= 0x8,
+	EDMA_ERR_IRQ_MASK	= 0xc,
 	EDMA_ERR_D_PAR		= (1 << 0),	/* UDMA data parity err */
 	EDMA_ERR_PRD_PAR	= (1 << 1),	/* UDMA PRD parity err */
 	EDMA_ERR_DEV		= (1 << 2),	/* device error */
@@ -373,36 +380,36 @@ enum {
 				  EDMA_ERR_INTRL_PAR |
 				  EDMA_ERR_IORDY,
 
-	EDMA_REQ_Q_BASE_HI_OFS	= 0x10,
-	EDMA_REQ_Q_IN_PTR_OFS	= 0x14,		/* also contains BASE_LO */
+	EDMA_REQ_Q_BASE_HI	= 0x10,
+	EDMA_REQ_Q_IN_PTR	= 0x14,		/* also contains BASE_LO */
 
-	EDMA_REQ_Q_OUT_PTR_OFS	= 0x18,
+	EDMA_REQ_Q_OUT_PTR	= 0x18,
 	EDMA_REQ_Q_PTR_SHIFT	= 5,
 
-	EDMA_RSP_Q_BASE_HI_OFS	= 0x1c,
-	EDMA_RSP_Q_IN_PTR_OFS	= 0x20,
-	EDMA_RSP_Q_OUT_PTR_OFS	= 0x24,		/* also contains BASE_LO */
+	EDMA_RSP_Q_BASE_HI	= 0x1c,
+	EDMA_RSP_Q_IN_PTR	= 0x20,
+	EDMA_RSP_Q_OUT_PTR	= 0x24,		/* also contains BASE_LO */
 	EDMA_RSP_Q_PTR_SHIFT	= 3,
 
-	EDMA_CMD_OFS		= 0x28,		/* EDMA command register */
+	EDMA_CMD		= 0x28,		/* EDMA command register */
 	EDMA_EN			= (1 << 0),	/* enable EDMA */
 	EDMA_DS			= (1 << 1),	/* disable EDMA; self-negated */
 	EDMA_RESET		= (1 << 2),	/* reset eng/trans/link/phy */
 
-	EDMA_STATUS_OFS		= 0x30,		/* EDMA engine status */
+	EDMA_STATUS		= 0x30,		/* EDMA engine status */
 	EDMA_STATUS_CACHE_EMPTY	= (1 << 6),	/* GenIIe command cache empty */
 	EDMA_STATUS_IDLE	= (1 << 7),	/* GenIIe EDMA enabled/idle */
 
-	EDMA_IORDY_TMOUT_OFS	= 0x34,
-	EDMA_ARB_CFG_OFS	= 0x38,
+	EDMA_IORDY_TMOUT	= 0x34,
+	EDMA_ARB_CFG		= 0x38,
 
-	EDMA_HALTCOND_OFS	= 0x60,		/* GenIIe halt conditions */
-	EDMA_UNKNOWN_RSVD_OFS	= 0x6C,		/* GenIIe unknown/reserved */
+	EDMA_HALTCOND		= 0x60,		/* GenIIe halt conditions */
+	EDMA_UNKNOWN_RSVD	= 0x6C,		/* GenIIe unknown/reserved */
 
-	BMDMA_CMD_OFS		= 0x224,	/* bmdma command register */
-	BMDMA_STATUS_OFS	= 0x228,	/* bmdma status register */
-	BMDMA_PRD_LOW_OFS	= 0x22c,	/* bmdma PRD addr 31:0 */
-	BMDMA_PRD_HIGH_OFS	= 0x230,	/* bmdma PRD addr 63:32 */
+	BMDMA_CMD		= 0x224,	/* bmdma command register */
+	BMDMA_STATUS		= 0x228,	/* bmdma status register */
+	BMDMA_PRD_LOW		= 0x22c,	/* bmdma PRD addr 31:0 */
+	BMDMA_PRD_HIGH		= 0x230,	/* bmdma PRD addr 63:32 */
 
 	/* Host private flags (hp_flags) */
 	MV_HP_FLAG_MSI		= (1 << 0),
@@ -534,8 +541,8 @@ struct mv_host_priv {
 	void __iomem		*base;
 	void __iomem		*main_irq_cause_addr;
 	void __iomem		*main_irq_mask_addr;
-	u32			irq_cause_ofs;
-	u32			irq_mask_ofs;
+	u32			irq_cause_offset;
+	u32			irq_mask_offset;
 	u32			unmask_all_irqs;
 	/*
 	 * These consistent DMA memory pools give us guaranteed
@@ -694,49 +701,49 @@ static struct ata_port_operations mv_iie_ops = {
 static const struct ata_port_info mv_port_info[] = {
 	{  /* chip_504x */
 		.flags		= MV_GEN_I_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_508x */
 		.flags		= MV_GEN_I_FLAGS | MV_FLAG_DUAL_HC,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_5080 */
 		.flags		= MV_GEN_I_FLAGS | MV_FLAG_DUAL_HC,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv5_ops,
 	},
 	{  /* chip_604x */
 		.flags		= MV_GEN_II_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_608x */
 		.flags		= MV_GEN_II_FLAGS | MV_FLAG_DUAL_HC,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv6_ops,
 	},
 	{  /* chip_6042 */
 		.flags		= MV_GEN_IIE_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_7042 */
 		.flags		= MV_GEN_IIE_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
 	{  /* chip_soc */
 		.flags		= MV_GEN_IIE_FLAGS,
-		.pio_mask	= 0x1f,	/* pio0-4 */
+		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &mv_iie_ops,
 	},
@@ -840,7 +847,7 @@ static inline unsigned int mv_hardport_from_port(unsigned int port)
 
 static inline void __iomem *mv_hc_base(void __iomem *base, unsigned int hc)
 {
-	return (base + MV_SATAHC0_REG_BASE + (hc * MV_SATAHC_REG_SZ));
+	return (base + SATAHC0_REG_BASE + (hc * MV_SATAHC_REG_SZ));
 }
 
 static inline void __iomem *mv_hc_base_from_port(void __iomem *base,
@@ -895,10 +902,10 @@ static void mv_save_cached_regs(struct ata_port *ap)
 	void __iomem *port_mmio = mv_ap_base(ap);
 	struct mv_port_priv *pp = ap->private_data;
 
-	pp->cached.fiscfg = readl(port_mmio + FISCFG_OFS);
-	pp->cached.ltmode = readl(port_mmio + LTMODE_OFS);
-	pp->cached.haltcond = readl(port_mmio + EDMA_HALTCOND_OFS);
-	pp->cached.unknown_rsvd = readl(port_mmio + EDMA_UNKNOWN_RSVD_OFS);
+	pp->cached.fiscfg = readl(port_mmio + FISCFG);
+	pp->cached.ltmode = readl(port_mmio + LTMODE);
+	pp->cached.haltcond = readl(port_mmio + EDMA_HALTCOND);
+	pp->cached.unknown_rsvd = readl(port_mmio + EDMA_UNKNOWN_RSVD);
 }
 
 /**
@@ -913,8 +920,26 @@ static void mv_save_cached_regs(struct ata_port *ap)
 static inline void mv_write_cached_reg(void __iomem *addr, u32 *old, u32 new)
 {
 	if (new != *old) {
+		unsigned long laddr;
 		*old = new;
-		writel(new, addr);
+		/*
+		 * Workaround for 88SX60x1-B2 FEr SATA#13:
+		 * Read-after-write is needed to prevent generating 64-bit
+		 * write cycles on the PCI bus for SATA interface registers
+		 * at offsets ending in 0x4 or 0xc.
+		 *
+		 * Looks like a lot of fuss, but it avoids an unnecessary
+		 * +1 usec read-after-write delay for unaffected registers.
+		 */
+		laddr = (long)addr & 0xffff;
+		if (laddr >= 0x300 && laddr <= 0x33c) {
+			laddr &= 0x000f;
+			if (laddr == 0x4 || laddr == 0xc) {
+				writelfl(new, addr); /* read after write */
+				return;
+			}
+		}
+		writel(new, addr); /* unaffected by the errata */
 	}
 }
 
@@ -931,10 +956,10 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 	index = pp->req_idx << EDMA_REQ_Q_PTR_SHIFT;
 
 	WARN_ON(pp->crqb_dma & 0x3ff);
-	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI_OFS);
+	writel((pp->crqb_dma >> 16) >> 16, port_mmio + EDMA_REQ_Q_BASE_HI);
 	writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | index,
-		 port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
-	writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR_OFS);
+		 port_mmio + EDMA_REQ_Q_IN_PTR);
+	writelfl(index, port_mmio + EDMA_REQ_Q_OUT_PTR);
 
 	/*
 	 * initialize response queue
@@ -943,10 +968,10 @@ static void mv_set_edma_ptrs(void __iomem *port_mmio,
 	index = pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT;
 
 	WARN_ON(pp->crpb_dma & 0xff);
-	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI_OFS);
-	writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR_OFS);
+	writel((pp->crpb_dma >> 16) >> 16, port_mmio + EDMA_RSP_Q_BASE_HI);
+	writelfl(index, port_mmio + EDMA_RSP_Q_IN_PTR);
 	writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) | index,
-		 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+		 port_mmio + EDMA_RSP_Q_OUT_PTR);
 }
 
 static void mv_write_main_irq_mask(u32 mask, struct mv_host_priv *hpriv)
@@ -1004,15 +1029,15 @@ static void mv_clear_and_enable_port_irqs(struct ata_port *ap,
 	u32 hc_irq_cause;
 
 	/* clear EDMA event indicators, if any */
-	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE);
 
 	/* clear pending irq events */
 	hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
-	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE);
 
 	/* clear FIS IRQ Cause */
 	if (IS_GEN_IIE(hpriv))
-		writelfl(0, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+		writelfl(0, port_mmio + FIS_IRQ_CAUSE);
 
 	mv_enable_port_irqs(ap, port_irqs);
 }
@@ -1048,10 +1073,10 @@ static void mv_set_irq_coalescing(struct ata_host *host,
 		 * GEN_II/GEN_IIE with dual host controllers:
 		 * one set of global thresholds for the entire chip.
 		 */
-		writel(clks,  mmio + MV_IRQ_COAL_TIME_THRESHOLD);
-		writel(count, mmio + MV_IRQ_COAL_IO_THRESHOLD);
+		writel(clks,  mmio + IRQ_COAL_TIME_THRESHOLD);
+		writel(count, mmio + IRQ_COAL_IO_THRESHOLD);
 		/* clear leftover coal IRQ bit */
-		writel(~ALL_PORTS_COAL_IRQ, mmio + MV_IRQ_COAL_CAUSE);
+		writel(~ALL_PORTS_COAL_IRQ, mmio + IRQ_COAL_CAUSE);
 		if (count)
 			coal_enable = ALL_PORTS_COAL_DONE;
 		clks = count = 0; /* force clearing of regular regs below */
@@ -1061,16 +1086,16 @@ static void mv_set_irq_coalescing(struct ata_host *host,
 	 * All chips: independent thresholds for each HC on the chip.
 	 */
 	hc_mmio = mv_hc_base_from_port(mmio, 0);
-	writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD_OFS);
-	writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD_OFS);
-	writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE_OFS);
+	writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD);
+	writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD);
+	writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE);
 	if (count)
 		coal_enable |= PORTS_0_3_COAL_DONE;
 	if (is_dual_hc) {
 		hc_mmio = mv_hc_base_from_port(mmio, MV_PORTS_PER_HC);
-		writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD_OFS);
-		writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD_OFS);
-		writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE_OFS);
+		writel(clks,  hc_mmio + HC_IRQ_COAL_TIME_THRESHOLD);
+		writel(count, hc_mmio + HC_IRQ_COAL_IO_THRESHOLD);
+		writel(~HC_COAL_IRQ, hc_mmio + HC_IRQ_CAUSE);
 		if (count)
 			coal_enable |= PORTS_4_7_COAL_DONE;
 	}
@@ -1108,7 +1133,7 @@ static void mv_start_edma(struct ata_port *ap, void __iomem *port_mmio,
 		mv_set_edma_ptrs(port_mmio, hpriv, pp);
 		mv_clear_and_enable_port_irqs(ap, port_mmio, DONE_IRQ|ERR_IRQ);
 
-		writelfl(EDMA_EN, port_mmio + EDMA_CMD_OFS);
+		writelfl(EDMA_EN, port_mmio + EDMA_CMD);
 		pp->pp_flags |= MV_PP_FLAG_EDMA_EN;
 	}
 }
@@ -1128,7 +1153,7 @@ static void mv_wait_for_edma_empty_idle(struct ata_port *ap)
 	 * as a rough guess at what even more drives might require.
 	 */
 	for (i = 0; i < timeout; ++i) {
-		u32 edma_stat = readl(port_mmio + EDMA_STATUS_OFS);
+		u32 edma_stat = readl(port_mmio + EDMA_STATUS);
 		if ((edma_stat & empty_idle) == empty_idle)
 			break;
 		udelay(per_loop);
@@ -1148,11 +1173,11 @@ static int mv_stop_edma_engine(void __iomem *port_mmio)
 	int i;
 
 	/* Disable eDMA.  The disable bit auto clears. */
-	writelfl(EDMA_DS, port_mmio + EDMA_CMD_OFS);
+	writelfl(EDMA_DS, port_mmio + EDMA_CMD);
 
 	/* Wait for the chip to confirm eDMA is off. */
 	for (i = 10000; i > 0; i--) {
-		u32 reg = readl(port_mmio + EDMA_CMD_OFS);
+		u32 reg = readl(port_mmio + EDMA_CMD);
 		if (!(reg & EDMA_EN))
 			return 0;
 		udelay(10);
@@ -1262,10 +1287,10 @@ static unsigned int mv_scr_offset(unsigned int sc_reg_in)
 	case SCR_STATUS:
 	case SCR_CONTROL:
 	case SCR_ERROR:
-		ofs = SATA_STATUS_OFS + (sc_reg_in * sizeof(u32));
+		ofs = SATA_STATUS + (sc_reg_in * sizeof(u32));
 		break;
 	case SCR_ACTIVE:
-		ofs = SATA_ACTIVE_OFS;   /* active is not with the others */
+		ofs = SATA_ACTIVE;   /* active is not with the others */
 		break;
 	default:
 		ofs = 0xffffffffU;
@@ -1290,7 +1315,25 @@ static int mv_scr_write(struct ata_link *link, unsigned int sc_reg_in, u32 val)
 	unsigned int ofs = mv_scr_offset(sc_reg_in);
 
 	if (ofs != 0xffffffffU) {
-		writelfl(val, mv_ap_base(link->ap) + ofs);
+		void __iomem *addr = mv_ap_base(link->ap) + ofs;
+		if (sc_reg_in == SCR_CONTROL) {
+			/*
+			 * Workaround for 88SX60x1 FEr SATA#26:
+			 *
+			 * COMRESETs have to take care not to accidently
+			 * put the drive to sleep when writing SCR_CONTROL.
+			 * Setting bits 12..15 prevents this problem.
+			 *
+			 * So if we see an outbound COMMRESET, set those bits.
+			 * Ditto for the followup write that clears the reset.
+			 *
+			 * The proprietary driver does this for
+			 * all chip versions, and so do we.
+			 */
+			if ((val & 0xf) == 1 || (readl(addr) & 0xf) == 1)
+				val |= 0xf000;
+		}
+		writelfl(val, addr);
 		return 0;
 	} else
 		return -EINVAL;
@@ -1368,9 +1411,9 @@ static void mv_config_fbs(struct ata_port *ap, int want_ncq, int want_fbs)
 	}
 
 	port_mmio = mv_ap_base(ap);
-	mv_write_cached_reg(port_mmio + FISCFG_OFS, old_fiscfg, fiscfg);
-	mv_write_cached_reg(port_mmio + LTMODE_OFS, old_ltmode, ltmode);
-	mv_write_cached_reg(port_mmio + EDMA_HALTCOND_OFS, old_haltcond, haltcond);
+	mv_write_cached_reg(port_mmio + FISCFG, old_fiscfg, fiscfg);
+	mv_write_cached_reg(port_mmio + LTMODE, old_ltmode, ltmode);
+	mv_write_cached_reg(port_mmio + EDMA_HALTCOND, old_haltcond, haltcond);
 }
 
 static void mv_60x1_errata_sata25(struct ata_port *ap, int want_ncq)
@@ -1379,13 +1422,13 @@ static void mv_60x1_errata_sata25(struct ata_port *ap, int want_ncq)
 	u32 old, new;
 
 	/* workaround for 88SX60x1 FEr SATA#25 (part 1) */
-	old = readl(hpriv->base + MV_GPIO_PORT_CTL_OFS);
+	old = readl(hpriv->base + GPIO_PORT_CTL);
 	if (want_ncq)
 		new = old | (1 << 22);
 	else
 		new = old & ~(1 << 22);
 	if (new != old)
-		writel(new, hpriv->base + MV_GPIO_PORT_CTL_OFS);
+		writel(new, hpriv->base + GPIO_PORT_CTL);
 }
 
 /**
@@ -1409,7 +1452,7 @@ static void mv_bmdma_enable_iie(struct ata_port *ap, int enable_bmdma)
 		new = *old | 1;
 	else
 		new = *old & ~1;
-	mv_write_cached_reg(mv_ap_base(ap) + EDMA_UNKNOWN_RSVD_OFS, old, new);
+	mv_write_cached_reg(mv_ap_base(ap) + EDMA_UNKNOWN_RSVD, old, new);
 }
 
 /*
@@ -1437,8 +1480,8 @@ static void mv_soc_led_blink_enable(struct ata_port *ap)
 		return;
 	hpriv->hp_flags |= MV_HP_QUIRK_LED_BLINK_EN;
 	hc_mmio = mv_hc_base_from_port(mv_host_base(host), ap->port_no);
-	led_ctrl = readl(hc_mmio + SOC_LED_CTRL_OFS);
-	writel(led_ctrl | SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL_OFS);
+	led_ctrl = readl(hc_mmio + SOC_LED_CTRL);
+	writel(led_ctrl | SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL);
 }
 
 static void mv_soc_led_blink_disable(struct ata_port *ap)
@@ -1463,8 +1506,8 @@ static void mv_soc_led_blink_disable(struct ata_port *ap)
 
 	hpriv->hp_flags &= ~MV_HP_QUIRK_LED_BLINK_EN;
 	hc_mmio = mv_hc_base_from_port(mv_host_base(host), ap->port_no);
-	led_ctrl = readl(hc_mmio + SOC_LED_CTRL_OFS);
-	writel(led_ctrl & ~SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL_OFS);
+	led_ctrl = readl(hc_mmio + SOC_LED_CTRL);
+	writel(led_ctrl & ~SOC_LED_CTRL_BLINK, hc_mmio + SOC_LED_CTRL);
 }
 
 static void mv_edma_cfg(struct ata_port *ap, int want_ncq, int want_edma)
@@ -1528,7 +1571,7 @@ static void mv_edma_cfg(struct ata_port *ap, int want_ncq, int want_edma)
 		pp->pp_flags |=  MV_PP_FLAG_NCQ_EN;
 	}
 
-	writelfl(cfg, port_mmio + EDMA_CFG_OFS);
+	writelfl(cfg, port_mmio + EDMA_CFG);
 }
 
 static void mv_port_free_dma_mem(struct ata_port *ap)
@@ -1575,6 +1618,7 @@ static int mv_port_start(struct ata_port *ap)
 	struct device *dev = ap->host->dev;
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	struct mv_port_priv *pp;
+	unsigned long flags;
 	int tag;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
@@ -1610,8 +1654,12 @@ static int mv_port_start(struct ata_port *ap)
 			pp->sg_tbl_dma[tag] = pp->sg_tbl_dma[0];
 		}
 	}
+
+	spin_lock_irqsave(ap->lock, flags);
 	mv_save_cached_regs(ap);
 	mv_edma_cfg(ap, 0, 0);
+	spin_unlock_irqrestore(ap->lock, flags);
+
 	return 0;
 
 out_port_free_dma_mem:
@@ -1630,8 +1678,12 @@ out_port_free_dma_mem:
  */
 static void mv_port_stop(struct ata_port *ap)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(ap->lock, flags);
 	mv_stop_edma(ap);
 	mv_enable_port_irqs(ap, 0);
+	spin_unlock_irqrestore(ap->lock, flags);
 	mv_port_free_dma_mem(ap);
 }
 
@@ -1749,13 +1801,13 @@ static void mv_bmdma_setup(struct ata_queued_cmd *qc)
 	mv_fill_sg(qc);
 
 	/* clear all DMA cmd bits */
-	writel(0, port_mmio + BMDMA_CMD_OFS);
+	writel(0, port_mmio + BMDMA_CMD);
 
 	/* load PRD table addr. */
 	writel((pp->sg_tbl_dma[qc->tag] >> 16) >> 16,
-		port_mmio + BMDMA_PRD_HIGH_OFS);
+		port_mmio + BMDMA_PRD_HIGH);
 	writelfl(pp->sg_tbl_dma[qc->tag],
-		port_mmio + BMDMA_PRD_LOW_OFS);
+		port_mmio + BMDMA_PRD_LOW);
 
 	/* issue r/w command */
 	ap->ops->sff_exec_command(ap, &qc->tf);
@@ -1776,7 +1828,7 @@ static void mv_bmdma_start(struct ata_queued_cmd *qc)
 	u32 cmd = (rw ? 0 : ATA_DMA_WR) | ATA_DMA_START;
 
 	/* start host DMA transaction */
-	writelfl(cmd, port_mmio + BMDMA_CMD_OFS);
+	writelfl(cmd, port_mmio + BMDMA_CMD);
 }
 
 /**
@@ -1795,9 +1847,9 @@ static void mv_bmdma_stop(struct ata_queued_cmd *qc)
 	u32 cmd;
 
 	/* clear start/stop bit */
-	cmd = readl(port_mmio + BMDMA_CMD_OFS);
+	cmd = readl(port_mmio + BMDMA_CMD);
 	cmd &= ~ATA_DMA_START;
-	writelfl(cmd, port_mmio + BMDMA_CMD_OFS);
+	writelfl(cmd, port_mmio + BMDMA_CMD);
 
 	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
 	ata_sff_dma_pause(ap);
@@ -1821,7 +1873,7 @@ static u8 mv_bmdma_status(struct ata_port *ap)
 	 * Other bits are valid only if ATA_DMA_ACTIVE==0,
 	 * and the ATA_DMA_INTR bit doesn't exist.
 	 */
-	reg = readl(port_mmio + BMDMA_STATUS_OFS);
+	reg = readl(port_mmio + BMDMA_STATUS);
 	if (reg & ATA_DMA_ACTIVE)
 		status = ATA_DMA_ACTIVE;
 	else
@@ -2029,28 +2081,28 @@ static unsigned int mv_send_fis(struct ata_port *ap, u32 *fis, int nwords)
 	int i, timeout = 200, final_word = nwords - 1;
 
 	/* Initiate FIS transmission mode */
-	old_ifctl = readl(port_mmio + SATA_IFCTL_OFS);
+	old_ifctl = readl(port_mmio + SATA_IFCTL);
 	ifctl = 0x100 | (old_ifctl & 0xf);
-	writelfl(ifctl, port_mmio + SATA_IFCTL_OFS);
+	writelfl(ifctl, port_mmio + SATA_IFCTL);
 
 	/* Send all words of the FIS except for the final word */
 	for (i = 0; i < final_word; ++i)
-		writel(fis[i], port_mmio + VENDOR_UNIQUE_FIS_OFS);
+		writel(fis[i], port_mmio + VENDOR_UNIQUE_FIS);
 
 	/* Flag end-of-transmission, and then send the final word */
-	writelfl(ifctl | 0x200, port_mmio + SATA_IFCTL_OFS);
-	writelfl(fis[final_word], port_mmio + VENDOR_UNIQUE_FIS_OFS);
+	writelfl(ifctl | 0x200, port_mmio + SATA_IFCTL);
+	writelfl(fis[final_word], port_mmio + VENDOR_UNIQUE_FIS);
 
 	/*
 	 * Wait for FIS transmission to complete.
 	 * This typically takes just a single iteration.
 	 */
 	do {
-		ifstat = readl(port_mmio + SATA_IFSTAT_OFS);
+		ifstat = readl(port_mmio + SATA_IFSTAT);
 	} while (!(ifstat & 0x1000) && --timeout);
 
 	/* Restore original port configuration */
-	writelfl(old_ifctl, port_mmio + SATA_IFCTL_OFS);
+	writelfl(old_ifctl, port_mmio + SATA_IFCTL);
 
 	/* See if it worked */
 	if ((ifstat & 0x3000) != 0x1000) {
@@ -2148,7 +2200,7 @@ static unsigned int mv_qc_issue(struct ata_queued_cmd *qc)
 
 		/* Write the request in pointer to kick the EDMA to life */
 		writelfl((pp->crqb_dma & EDMA_REQ_Q_BASE_LO_MASK) | in_index,
-					port_mmio + EDMA_REQ_Q_IN_PTR_OFS);
+					port_mmio + EDMA_REQ_Q_IN_PTR);
 		return 0;
 
 	case ATA_PROT_PIO:
@@ -2259,7 +2311,7 @@ static unsigned int mv_get_err_pmp_map(struct ata_port *ap)
 {
 	void __iomem *port_mmio = mv_ap_base(ap);
 
-	return readl(port_mmio + SATA_TESTCTL_OFS) >> 16;
+	return readl(port_mmio + SATA_TESTCTL) >> 16;
 }
 
 static void mv_pmp_eh_prep(struct ata_port *ap, unsigned int pmp_map)
@@ -2292,9 +2344,9 @@ static int mv_req_q_empty(struct ata_port *ap)
 	void __iomem *port_mmio = mv_ap_base(ap);
 	u32 in_ptr, out_ptr;
 
-	in_ptr  = (readl(port_mmio + EDMA_REQ_Q_IN_PTR_OFS)
+	in_ptr  = (readl(port_mmio + EDMA_REQ_Q_IN_PTR)
 			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
-	out_ptr = (readl(port_mmio + EDMA_REQ_Q_OUT_PTR_OFS)
+	out_ptr = (readl(port_mmio + EDMA_REQ_Q_OUT_PTR)
 			>> EDMA_REQ_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
 	return (in_ptr == out_ptr);	/* 1 == queue_is_empty */
 }
@@ -2456,12 +2508,12 @@ static void mv_err_intr(struct ata_port *ap)
 	sata_scr_read(&ap->link, SCR_ERROR, &serr);
 	sata_scr_write_flush(&ap->link, SCR_ERROR, serr);
 
-	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	edma_err_cause = readl(port_mmio + EDMA_ERR_IRQ_CAUSE);
 	if (IS_GEN_IIE(hpriv) && (edma_err_cause & EDMA_ERR_TRANS_IRQ_7)) {
-		fis_cause = readl(port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
-		writelfl(~fis_cause, port_mmio + SATA_FIS_IRQ_CAUSE_OFS);
+		fis_cause = readl(port_mmio + FIS_IRQ_CAUSE);
+		writelfl(~fis_cause, port_mmio + FIS_IRQ_CAUSE);
 	}
-	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	writelfl(~edma_err_cause, port_mmio + EDMA_ERR_IRQ_CAUSE);
 
 	if (edma_err_cause & EDMA_ERR_DEV) {
 		/*
@@ -2479,7 +2531,7 @@ static void mv_err_intr(struct ata_port *ap)
 
 	if (IS_GEN_IIE(hpriv) && (edma_err_cause & EDMA_ERR_TRANS_IRQ_7)) {
 		ata_ehi_push_desc(ehi, "fis_cause=%08x", fis_cause);
-		if (fis_cause & SATA_FIS_IRQ_AN) {
+		if (fis_cause & FIS_IRQ_CAUSE_AN) {
 			u32 ec = edma_err_cause &
 			       ~(EDMA_ERR_TRANS_IRQ_7 | EDMA_ERR_IRQ_TRANSIENT);
 			sata_async_notification(ap);
@@ -2581,7 +2633,7 @@ static void mv_process_crpb_response(struct ata_port *ap,
 		u16 edma_status = le16_to_cpu(response->flags);
 		/*
 		 * edma_status from a response queue entry:
-		 *   LSB is from EDMA_ERR_IRQ_CAUSE_OFS (non-NCQ only).
+		 *   LSB is from EDMA_ERR_IRQ_CAUSE (non-NCQ only).
 		 *   MSB is saved ATA status from command completion.
 		 */
 		if (!ncq_enabled) {
@@ -2613,7 +2665,7 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 	int ncq_enabled = (pp->pp_flags & MV_PP_FLAG_NCQ_EN);
 
 	/* Get the hardware queue position index */
-	in_index = (readl(port_mmio + EDMA_RSP_Q_IN_PTR_OFS)
+	in_index = (readl(port_mmio + EDMA_RSP_Q_IN_PTR)
 			>> EDMA_RSP_Q_PTR_SHIFT) & MV_MAX_Q_DEPTH_MASK;
 
 	/* Process new responses from since the last time we looked */
@@ -2638,7 +2690,7 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 	if (work_done)
 		writelfl((pp->crpb_dma & EDMA_RSP_Q_BASE_LO_MASK) |
 			 (pp->resp_idx << EDMA_RSP_Q_PTR_SHIFT),
-			 port_mmio + EDMA_RSP_Q_OUT_PTR_OFS);
+			 port_mmio + EDMA_RSP_Q_OUT_PTR);
 }
 
 static void mv_port_intr(struct ata_port *ap, u32 port_cause)
@@ -2695,7 +2747,7 @@ static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 
 	/* If asserted, clear the "all ports" IRQ coalescing bit */
 	if (main_irq_cause & ALL_PORTS_COAL_DONE)
-		writel(~ALL_PORTS_COAL_IRQ, mmio + MV_IRQ_COAL_CAUSE);
+		writel(~ALL_PORTS_COAL_IRQ, mmio + IRQ_COAL_CAUSE);
 
 	for (port = 0; port < hpriv->n_ports; port++) {
 		struct ata_port *ap = host->ports[port];
@@ -2739,7 +2791,7 @@ static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 					ack_irqs |= (DMA_IRQ | DEV_IRQ) << p;
 			}
 			hc_mmio = mv_hc_base_from_port(mmio, port);
-			writelfl(~ack_irqs, hc_mmio + HC_IRQ_CAUSE_OFS);
+			writelfl(~ack_irqs, hc_mmio + HC_IRQ_CAUSE);
 			handled = 1;
 		}
 		/*
@@ -2761,7 +2813,7 @@ static int mv_pci_error(struct ata_host *host, void __iomem *mmio)
 	unsigned int i, err_mask, printed = 0;
 	u32 err_cause;
 
-	err_cause = readl(mmio + hpriv->irq_cause_ofs);
+	err_cause = readl(mmio + hpriv->irq_cause_offset);
 
 	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
 		   err_cause);
@@ -2769,7 +2821,7 @@ static int mv_pci_error(struct ata_host *host, void __iomem *mmio)
 	DPRINTK("All regs @ PCI error\n");
 	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
 
-	writelfl(0, mmio + hpriv->irq_cause_ofs);
+	writelfl(0, mmio + hpriv->irq_cause_offset);
 
 	for (i = 0; i < host->n_ports; i++) {
 		ap = host->ports[i];
@@ -2906,7 +2958,7 @@ static void mv5_reset_bus(struct ata_host *host, void __iomem *mmio)
 
 static void mv5_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
-	writel(0x0fcfffff, mmio + MV_FLASH_CTL_OFS);
+	writel(0x0fcfffff, mmio + FLASH_CTL);
 }
 
 static void mv5_read_preamp(struct mv_host_priv *hpriv, int idx,
@@ -2925,7 +2977,7 @@ static void mv5_enable_leds(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
 	u32 tmp;
 
-	writel(0, mmio + MV_GPIO_PORT_CTL_OFS);
+	writel(0, mmio + GPIO_PORT_CTL);
 
 	/* FIXME: handle MV_HP_ERRATA_50XXB2 errata */
 
@@ -2943,14 +2995,14 @@ static void mv5_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 	int fix_apm_sq = (hpriv->hp_flags & MV_HP_ERRATA_50XXB0);
 
 	if (fix_apm_sq) {
-		tmp = readl(phy_mmio + MV5_LTMODE_OFS);
+		tmp = readl(phy_mmio + MV5_LTMODE);
 		tmp |= (1 << 19);
-		writel(tmp, phy_mmio + MV5_LTMODE_OFS);
+		writel(tmp, phy_mmio + MV5_LTMODE);
 
-		tmp = readl(phy_mmio + MV5_PHY_CTL_OFS);
+		tmp = readl(phy_mmio + MV5_PHY_CTL);
 		tmp &= ~0x3;
 		tmp |= 0x1;
-		writel(tmp, phy_mmio + MV5_PHY_CTL_OFS);
+		writel(tmp, phy_mmio + MV5_PHY_CTL);
 	}
 
 	tmp = readl(phy_mmio + MV5_PHY_MODE);
@@ -2971,7 +3023,7 @@ static void mv5_reset_hc_port(struct mv_host_priv *hpriv, void __iomem *mmio,
 	mv_reset_channel(hpriv, mmio, port);
 
 	ZERO(0x028);	/* command */
-	writel(0x11f, port_mmio + EDMA_CFG_OFS);
+	writel(0x11f, port_mmio + EDMA_CFG);
 	ZERO(0x004);	/* timer */
 	ZERO(0x008);	/* irq err cause */
 	ZERO(0x00c);	/* irq err mask */
@@ -2982,7 +3034,7 @@ static void mv5_reset_hc_port(struct mv_host_priv *hpriv, void __iomem *mmio,
 	ZERO(0x024);	/* respq outp */
 	ZERO(0x020);	/* respq inp */
 	ZERO(0x02c);	/* test control */
-	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT_OFS);
+	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
 }
 #undef ZERO
 
@@ -3028,16 +3080,16 @@ static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio)
 	struct mv_host_priv *hpriv = host->private_data;
 	u32 tmp;
 
-	tmp = readl(mmio + MV_PCI_MODE_OFS);
+	tmp = readl(mmio + MV_PCI_MODE);
 	tmp &= 0xff00ffff;
-	writel(tmp, mmio + MV_PCI_MODE_OFS);
+	writel(tmp, mmio + MV_PCI_MODE);
 
 	ZERO(MV_PCI_DISC_TIMER);
 	ZERO(MV_PCI_MSI_TRIGGER);
-	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT_OFS);
+	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT);
 	ZERO(MV_PCI_SERR_MASK);
-	ZERO(hpriv->irq_cause_ofs);
-	ZERO(hpriv->irq_mask_ofs);
+	ZERO(hpriv->irq_cause_offset);
+	ZERO(hpriv->irq_mask_offset);
 	ZERO(MV_PCI_ERR_LOW_ADDRESS);
 	ZERO(MV_PCI_ERR_HIGH_ADDRESS);
 	ZERO(MV_PCI_ERR_ATTRIBUTE);
@@ -3051,10 +3103,10 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
 
 	mv5_reset_flash(hpriv, mmio);
 
-	tmp = readl(mmio + MV_GPIO_PORT_CTL_OFS);
+	tmp = readl(mmio + GPIO_PORT_CTL);
 	tmp &= 0x3;
 	tmp |= (1 << 5) | (1 << 6);
-	writel(tmp, mmio + MV_GPIO_PORT_CTL_OFS);
+	writel(tmp, mmio + GPIO_PORT_CTL);
 }
 
 /**
@@ -3069,7 +3121,7 @@ static void mv6_reset_flash(struct mv_host_priv *hpriv, void __iomem *mmio)
 static int mv6_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 			unsigned int n_hc)
 {
-	void __iomem *reg = mmio + PCI_MAIN_CMD_STS_OFS;
+	void __iomem *reg = mmio + PCI_MAIN_CMD_STS;
 	int i, rc = 0;
 	u32 t;
 
@@ -3127,7 +3179,7 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 	void __iomem *port_mmio;
 	u32 tmp;
 
-	tmp = readl(mmio + MV_RESET_CFG_OFS);
+	tmp = readl(mmio + RESET_CFG);
 	if ((tmp & (1 << 0)) == 0) {
 		hpriv->signal[idx].amps = 0x7 << 8;
 		hpriv->signal[idx].pre = 0x1 << 5;
@@ -3143,7 +3195,7 @@ static void mv6_read_preamp(struct mv_host_priv *hpriv, int idx,
 
 static void mv6_enable_leds(struct mv_host_priv *hpriv, void __iomem *mmio)
 {
-	writel(0x00000060, mmio + MV_GPIO_PORT_CTL_OFS);
+	writel(0x00000060, mmio + GPIO_PORT_CTL);
 }
 
 static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -3201,6 +3253,7 @@ static void mv6_phy_errata(struct mv_host_priv *hpriv, void __iomem *mmio,
 	 * Workaround for 60x1-B2 errata SATA#13:
 	 * Any write to PHY_MODE4 (above) may corrupt PHY_MODE3,
 	 * so we must always rewrite PHY_MODE3 after PHY_MODE4.
+	 * Or ensure we use writelfl() when writing PHY_MODE4.
 	 */
 	writel(m3, port_mmio + PHY_MODE3);
 
@@ -3252,7 +3305,7 @@ static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
 	mv_reset_channel(hpriv, mmio, port);
 
 	ZERO(0x028);		/* command */
-	writel(0x101f, port_mmio + EDMA_CFG_OFS);
+	writel(0x101f, port_mmio + EDMA_CFG);
 	ZERO(0x004);		/* timer */
 	ZERO(0x008);		/* irq err cause */
 	ZERO(0x00c);		/* irq err mask */
@@ -3263,7 +3316,7 @@ static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
 	ZERO(0x024);		/* respq outp */
 	ZERO(0x020);		/* respq inp */
 	ZERO(0x02c);		/* test control */
-	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT_OFS);
+	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
 }
 
 #undef ZERO
@@ -3308,12 +3361,12 @@ static void mv_soc_reset_bus(struct ata_host *host, void __iomem *mmio)
 
 static void mv_setup_ifcfg(void __iomem *port_mmio, int want_gen2i)
 {
-	u32 ifcfg = readl(port_mmio + SATA_INTERFACE_CFG_OFS);
+	u32 ifcfg = readl(port_mmio + SATA_IFCFG);
 
 	ifcfg = (ifcfg & 0xf7f) | 0x9b1000;	/* from chip spec */
 	if (want_gen2i)
 		ifcfg |= (1 << 7);		/* enable gen2i speed */
-	writelfl(ifcfg, port_mmio + SATA_INTERFACE_CFG_OFS);
+	writelfl(ifcfg, port_mmio + SATA_IFCFG);
 }
 
 static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
@@ -3327,7 +3380,7 @@ static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
 	 * to disable the EDMA engine before doing the EDMA_RESET operation.
 	 */
 	mv_stop_edma_engine(port_mmio);
-	writelfl(EDMA_RESET, port_mmio + EDMA_CMD_OFS);
+	writelfl(EDMA_RESET, port_mmio + EDMA_CMD);
 
 	if (!IS_GEN_I(hpriv)) {
 		/* Enable 3.0gb/s link speed: this survives EDMA_RESET */
@@ -3336,11 +3389,11 @@ static void mv_reset_channel(struct mv_host_priv *hpriv, void __iomem *mmio,
 	/*
 	 * Strobing EDMA_RESET here causes a hard reset of the SATA transport,
 	 * link, and physical layers.  It resets all SATA interface registers
-	 * (except for SATA_INTERFACE_CFG), and issues a COMRESET to the dev.
+	 * (except for SATA_IFCFG), and issues a COMRESET to the dev.
 	 */
-	writelfl(EDMA_RESET, port_mmio + EDMA_CMD_OFS);
+	writelfl(EDMA_RESET, port_mmio + EDMA_CMD);
 	udelay(25);	/* allow reset propagation */
-	writelfl(0, port_mmio + EDMA_CMD_OFS);
+	writelfl(0, port_mmio + EDMA_CMD);
 
 	hpriv->ops->phy_errata(hpriv, mmio, port_no);
 
@@ -3352,12 +3405,12 @@ static void mv_pmp_select(struct ata_port *ap, int pmp)
 {
 	if (sata_pmp_supported(ap)) {
 		void __iomem *port_mmio = mv_ap_base(ap);
-		u32 reg = readl(port_mmio + SATA_IFCTL_OFS);
+		u32 reg = readl(port_mmio + SATA_IFCTL);
 		int old = reg & 0xf;
 
 		if (old != pmp) {
 			reg = (reg & ~0xf) | pmp;
-			writelfl(reg, port_mmio + SATA_IFCTL_OFS);
+			writelfl(reg, port_mmio + SATA_IFCTL);
 		}
 	}
 }
@@ -3432,11 +3485,11 @@ static void mv_eh_thaw(struct ata_port *ap)
 	u32 hc_irq_cause;
 
 	/* clear EDMA errors on this port */
-	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE);
 
 	/* clear pending irq events */
 	hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
-	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
+	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE);
 
 	mv_enable_port_irqs(ap, ERR_IRQ);
 }
@@ -3455,8 +3508,7 @@ static void mv_eh_thaw(struct ata_port *ap)
  */
 static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 {
-	void __iomem *shd_base = port_mmio + SHD_BLK_OFS;
-	unsigned serr_ofs;
+	void __iomem *serr, *shd_base = port_mmio + SHD_BLK;
 
 	/* PIO related setup
 	 */
@@ -3471,23 +3523,23 @@ static void mv_port_init(struct ata_ioports *port,  void __iomem *port_mmio)
 	port->status_addr =
 		port->command_addr = shd_base + (sizeof(u32) * ATA_REG_STATUS);
 	/* special case: control/altstatus doesn't have ATA_REG_ address */
-	port->altstatus_addr = port->ctl_addr = shd_base + SHD_CTL_AST_OFS;
+	port->altstatus_addr = port->ctl_addr = shd_base + SHD_CTL_AST;
 
 	/* unused: */
 	port->cmd_addr = port->bmdma_addr = port->scr_addr = NULL;
 
 	/* Clear any currently outstanding port interrupt conditions */
-	serr_ofs = mv_scr_offset(SCR_ERROR);
-	writelfl(readl(port_mmio + serr_ofs), port_mmio + serr_ofs);
-	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
+	serr = port_mmio + mv_scr_offset(SCR_ERROR);
+	writelfl(readl(serr), serr);
+	writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE);
 
 	/* unmask all non-transient EDMA error interrupts */
-	writelfl(~EDMA_ERR_IRQ_TRANSIENT, port_mmio + EDMA_ERR_IRQ_MASK_OFS);
+	writelfl(~EDMA_ERR_IRQ_TRANSIENT, port_mmio + EDMA_ERR_IRQ_MASK);
 
 	VPRINTK("EDMA cfg=0x%08x EDMA IRQ err cause/mask=0x%08x/0x%08x\n",
-		readl(port_mmio + EDMA_CFG_OFS),
-		readl(port_mmio + EDMA_ERR_IRQ_CAUSE_OFS),
-		readl(port_mmio + EDMA_ERR_IRQ_MASK_OFS));
+		readl(port_mmio + EDMA_CFG),
+		readl(port_mmio + EDMA_ERR_IRQ_CAUSE),
+		readl(port_mmio + EDMA_ERR_IRQ_MASK));
 }
 
 static unsigned int mv_in_pcix_mode(struct ata_host *host)
@@ -3498,7 +3550,7 @@ static unsigned int mv_in_pcix_mode(struct ata_host *host)
 
 	if (IS_SOC(hpriv) || !IS_PCIE(hpriv))
 		return 0;	/* not PCI-X capable */
-	reg = readl(mmio + MV_PCI_MODE_OFS);
+	reg = readl(mmio + MV_PCI_MODE);
 	if ((reg & MV_PCI_MODE_MASK) == 0)
 		return 0;	/* conventional PCI mode */
 	return 1;	/* chip is in PCI-X mode */
@@ -3511,13 +3563,25 @@ static int mv_pci_cut_through_okay(struct ata_host *host)
 	u32 reg;
 
 	if (!mv_in_pcix_mode(host)) {
-		reg = readl(mmio + PCI_COMMAND_OFS);
-		if (reg & PCI_COMMAND_MRDTRIG)
+		reg = readl(mmio + MV_PCI_COMMAND);
+		if (reg & MV_PCI_COMMAND_MRDTRIG)
 			return 0; /* not okay */
 	}
 	return 1; /* okay */
 }
 
+static void mv_60x1b2_errata_pci7(struct ata_host *host)
+{
+	struct mv_host_priv *hpriv = host->private_data;
+	void __iomem *mmio = hpriv->base;
+
+	/* workaround for 60x1-B2 errata PCI#7 */
+	if (mv_in_pcix_mode(host)) {
+		u32 reg = readl(mmio + MV_PCI_COMMAND);
+		writelfl(reg & ~MV_PCI_COMMAND_MWRCOM, mmio + MV_PCI_COMMAND);
+	}
+}
+
 static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
@@ -3571,6 +3635,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 
 		switch (pdev->revision) {
 		case 0x7:
+			mv_60x1b2_errata_pci7(host);
 			hp_flags |= MV_HP_ERRATA_60X1B2;
 			break;
 		case 0x9:
@@ -3647,12 +3712,12 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 
 	hpriv->hp_flags = hp_flags;
 	if (hp_flags & MV_HP_PCIE) {
-		hpriv->irq_cause_ofs	= PCIE_IRQ_CAUSE_OFS;
-		hpriv->irq_mask_ofs	= PCIE_IRQ_MASK_OFS;
+		hpriv->irq_cause_offset	= PCIE_IRQ_CAUSE;
+		hpriv->irq_mask_offset	= PCIE_IRQ_MASK;
 		hpriv->unmask_all_irqs	= PCIE_UNMASK_ALL_IRQS;
 	} else {
-		hpriv->irq_cause_ofs	= PCI_IRQ_CAUSE_OFS;
-		hpriv->irq_mask_ofs	= PCI_IRQ_MASK_OFS;
+		hpriv->irq_cause_offset	= PCI_IRQ_CAUSE;
+		hpriv->irq_mask_offset	= PCI_IRQ_MASK;
 		hpriv->unmask_all_irqs	= PCI_UNMASK_ALL_IRQS;
 	}
 
@@ -3681,11 +3746,11 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		goto done;
 
 	if (IS_SOC(hpriv)) {
-		hpriv->main_irq_cause_addr = mmio + SOC_HC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_irq_mask_addr  = mmio + SOC_HC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_irq_cause_addr = mmio + SOC_HC_MAIN_IRQ_CAUSE;
+		hpriv->main_irq_mask_addr  = mmio + SOC_HC_MAIN_IRQ_MASK;
 	} else {
-		hpriv->main_irq_cause_addr = mmio + PCI_HC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_irq_cause_addr = mmio + PCI_HC_MAIN_IRQ_CAUSE;
+		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK;
 	}
 
 	/* initialize shadow irq mask with register's value */
@@ -3727,18 +3792,20 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 
 		VPRINTK("HC%i: HC config=0x%08x HC IRQ cause "
 			"(before clear)=0x%08x\n", hc,
-			readl(hc_mmio + HC_CFG_OFS),
-			readl(hc_mmio + HC_IRQ_CAUSE_OFS));
+			readl(hc_mmio + HC_CFG),
+			readl(hc_mmio + HC_IRQ_CAUSE));
 
 		/* Clear any currently outstanding hc interrupt conditions */
-		writelfl(0, hc_mmio + HC_IRQ_CAUSE_OFS);
+		writelfl(0, hc_mmio + HC_IRQ_CAUSE);
 	}
 
-	/* Clear any currently outstanding host interrupt conditions */
-	writelfl(0, mmio + hpriv->irq_cause_ofs);
+	if (!IS_SOC(hpriv)) {
+		/* Clear any currently outstanding host interrupt conditions */
+		writelfl(0, mmio + hpriv->irq_cause_offset);
 
-	/* and unmask interrupt generation for host regs */
-	writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
+		/* and unmask interrupt generation for host regs */
+		writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_offset);
+	}
 
 	/*
 	 * enable only global host interrupts for now.
@@ -3844,7 +3911,7 @@ static int mv_platform_probe(struct platform_device *pdev)
 	host->iomap = NULL;
 	hpriv->base = devm_ioremap(&pdev->dev, res->start,
 				   res->end - res->start + 1);
-	hpriv->base -= MV_SATAHC0_REG_BASE;
+	hpriv->base -= SATAHC0_REG_BASE;
 
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 6617c9f..cb79b7a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -29,6 +29,8 @@
 #ifndef __LINUX_ATA_H__
 #define __LINUX_ATA_H__
 
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
 
@@ -91,6 +93,7 @@ enum {
 	ATA_ID_CFA_POWER	= 160,
 	ATA_ID_CFA_KEY_MGMT	= 162,
 	ATA_ID_CFA_MODES	= 163,
+	ATA_ID_DATA_SET_MGMT	= 169,
 	ATA_ID_ROT_SPEED	= 217,
 	ATA_ID_PIO4		= (1 << 1),
 
@@ -248,6 +251,7 @@ enum {
 	ATA_CMD_SMART		= 0xB0,
 	ATA_CMD_MEDIA_LOCK	= 0xDE,
 	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
+	ATA_CMD_DSM		= 0x06,
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
 
@@ -321,6 +325,9 @@ enum {
 	ATA_SMART_READ_VALUES	= 0xD0,
 	ATA_SMART_READ_THRESHOLDS = 0xD1,
 
+	/* feature values for Data Set Management */
+	ATA_DSM_TRIM		= 0x01,
+
 	/* password used in LBA Mid / LBA High for executing SMART commands */
 	ATA_SMART_LBAM_PASS	= 0x4F,
 	ATA_SMART_LBAH_PASS	= 0xC2,
@@ -723,6 +730,14 @@ static inline int ata_id_has_unload(const u16 *id)
 	return 0;
 }
 
+static inline int ata_id_has_trim(const u16 *id)
+{
+	if (ata_id_major_version(id) >= 7 &&
+	    (id[ATA_ID_DATA_SET_MGMT] & 1))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -863,6 +878,32 @@ static inline void ata_id_to_hd_driveid(u16 *id)
 #endif
 }
 
+/*
+ * Write up to 'max' LBA Range Entries to the buffer that will cover the
+ * extent from sector to sector + count.  This is used for TRIM and for
+ * ADD LBA(S) TO NV CACHE PINNED SET.
+ */
+static inline unsigned ata_set_lba_range_entries(void *_buffer, unsigned max,
+						u64 sector, unsigned long count)
+{
+	__le64 *buffer = _buffer;
+	unsigned i = 0;
+
+	while (i < max) {
+		u64 entry = sector |
+			((u64)(count > 0xffff ? 0xffff : count) << 48);
+		buffer[i++] = __cpu_to_le64(entry);
+		if (count <= 0xffff)
+			break;
+		count -= 0xffff;
+		sector += 0xffff;
+	}
+
+	max = ALIGN(i * 8, 512);
+	memset(buffer + i, 0, max - i * 8);
+	return max;
+}
+
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
