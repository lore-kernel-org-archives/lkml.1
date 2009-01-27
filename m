Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZA0HbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZA0HbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZA0Ha7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:30:59 -0500
Received: from havoc.gtf.org ([69.61.125.42]:40696 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZA0Ha5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:30:57 -0500
Date: Tue, 27 Jan 2009 02:30:55 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090127073055.GA30360@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The sata_mv 8-port fix was for a longstanding and ugly bug, for those
who owned 8-port cards (4-port cards unaffected).

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig              |    6 ++--
 drivers/ata/libata-sff.c         |   12 ++++++-
 drivers/ata/pata_rb532_cf.c      |    2 -
 drivers/ata/pata_via.c           |   22 +++++++++---
 drivers/ata/sata_mv.c            |   56 ++++++++++++++----------------
 drivers/ata/sata_nv.c            |   70 +++++++++++++++++++++++--------------
 include/linux/pci_ids.h          |    4 ++
 7 files changed, 104 insertions(+), 68 deletions(-)
 delete mode 100644 arch/arm/mach-integrator/clock.h

JosephChan@via.com.tw (1):
      [libata] pata_via: support VX855, future chips whose IDE controller use 0x0571

Mark Lord (5):
      sata_mv: fix 8-port timeouts on 508x/6081 chips
      sata_mv: don't read hc_irq_cause
      sata_mv: remove bogus nsect restriction
      sata_mv: msi masking fix (v2)
      sata_mv: no longer experimental (v2)

Phil Sutter (1):
      pata-rb532-cf: remove set_irq_type from finish_io

Tejun Heo (4):
      libata-sff: fix incorrect EH message
      libata: set NODEV_HINT for 0x7f status
      sata_nv: rename nv_nf2_hardreset()
      sata_nv: fix MCP5x reset

Thomas Reitmayr (1):
      sata_mv: Properly initialize main irq mask

diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrator/clock.h
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 503a908..0bcf264 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -112,11 +112,11 @@ config ATA_PIIX
 	  If unsure, say N.
 
 config SATA_MV
-	tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "Marvell SATA support"
 	help
 	  This option enables support for the Marvell Serial ATA family.
-	  Currently supports 88SX[56]0[48][01] chips.
+	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
+	  as well as the newer [67]042 PCI-X/PCIe and SOC devices.
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 5a4aad1..0b299b0 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1322,7 +1322,7 @@ fsm_start:
 					 * condition.  Mark hint.
 					 */
 					ata_ehi_push_desc(ehi, "ST-ATA: "
-						"DRQ=1 with device error, "
+						"DRQ=0 without device error, "
 						"dev_stat 0x%X", status);
 					qc->err_mask |= AC_ERR_HSM |
 							AC_ERR_NODEV_HINT;
@@ -1358,6 +1358,16 @@ fsm_start:
 					qc->err_mask |= AC_ERR_HSM;
 				}
 
+				/* There are oddball controllers with
+				 * status register stuck at 0x7f and
+				 * lbal/m/h at zero which makes it
+				 * pass all other presence detection
+				 * mechanisms we have.  Set NODEV_HINT
+				 * for it.  Kernel bz#7241.
+				 */
+				if (status == 0x7f)
+					qc->err_mask |= AC_ERR_NODEV_HINT;
+
 				/* ata_pio_sectors() might change the
 				 * state to HSM_ST_LAST. so, the state
 				 * is changed after ata_pio_sectors().
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index c2e6fb9..ebfcda2 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -63,8 +63,6 @@ static inline void rb532_pata_finish_io(struct ata_port *ap)
 	   ata_sff_sync might be sufficient. */
 	ata_sff_dma_pause(ap);
 	ndelay(RB500_CF_IO_DELAY);
-
-	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
 }
 
 static void rb532_pata_exec_command(struct ata_port *ap,
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 681169c..79a6c9a 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -86,6 +86,10 @@ enum {
 	VIA_SATA_PATA	= 0x800, /* SATA/PATA combined configuration */
 };
 
+enum {
+	VIA_IDFLAG_SINGLE = (1 << 0), /* single channel controller) */
+};
+
 /*
  * VIA SouthBridge chips.
  */
@@ -97,8 +101,12 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
+	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
 	VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
@@ -122,6 +130,8 @@ static const struct via_isa_bridge {
 	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f, VIA_UDMA_NONE | VIA_SET_FIFO },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK },
 	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,    0x00, 0x2f,
+	  VIA_UDMA_133 | VIA_BAD_AST },
 	{ NULL }
 };
 
@@ -460,6 +470,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	static int printed_version;
 	u8 enable;
 	u32 timing;
+	unsigned long flags = id->driver_data;
 	int rc;
 
 	if (!printed_version++)
@@ -469,9 +480,13 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
+	if (flags & VIA_IDFLAG_SINGLE)
+		ppi[1] = &ata_dummy_port_info;
+
 	/* To find out how the IDE will behave and what features we
 	   actually have to look at the bridge not the IDE controller */
-	for (config = via_isa_bridges; config->id; config++)
+	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
+	     config++)
 		if ((isa = pci_get_device(PCI_VENDOR_ID_VIA +
 			!!(config->flags & VIA_BAD_ID),
 			config->id, NULL))) {
@@ -482,10 +497,6 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			pci_dev_put(isa);
 		}
 
-	if (!config->id) {
-		printk(KERN_WARNING "via: Unknown VIA SouthBridge, disabling.\n");
-		return -ENODEV;
-	}
 	pci_dev_put(isa);
 
 	if (!(config->flags & VIA_NO_ENABLES)) {
@@ -587,6 +598,7 @@ static const struct pci_device_id via[] = {
 	{ PCI_VDEVICE(VIA, 0x1571), },
 	{ PCI_VDEVICE(VIA, 0x3164), },
 	{ PCI_VDEVICE(VIA, 0x5324), },
+	{ PCI_VDEVICE(VIA, 0xC409), VIA_IDFLAG_SINGLE },
 
 	{ },
 };
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8691863..f2d8a02 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -33,10 +33,6 @@
  *
  * --> ATAPI support (Marvell claims the 60xx/70xx chips can do it).
  *
- * --> Investigate problems with PCI Message Signalled Interrupts (MSI).
- *
- * --> Cache frequently-accessed registers in mv_port_priv to reduce overhead.
- *
  * --> Develop a low-power-consumption strategy, and implement it.
  *
  * --> [Experiment, low priority] Investigate interrupt coalescing.
@@ -72,7 +68,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"1.24"
+#define DRV_VERSION	"1.25"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
@@ -351,8 +347,6 @@ enum {
 
 	EDMA_HALTCOND_OFS	= 0x60,		/* GenIIe halt conditions */
 
-	GEN_II_NCQ_MAX_SECTORS	= 256,		/* max sects/io on Gen2 w/NCQ */
-
 	/* Host private flags (hp_flags) */
 	MV_HP_FLAG_MSI		= (1 << 0),
 	MV_HP_ERRATA_50XXB0	= (1 << 1),
@@ -883,19 +877,15 @@ static void mv_start_dma(struct ata_port *ap, void __iomem *port_mmio,
 		struct mv_host_priv *hpriv = ap->host->private_data;
 		int hardport = mv_hardport_from_port(ap->port_no);
 		void __iomem *hc_mmio = mv_hc_base_from_port(
-					mv_host_base(ap->host), hardport);
-		u32 hc_irq_cause, ipending;
+					mv_host_base(ap->host), ap->port_no);
+		u32 hc_irq_cause;
 
 		/* clear EDMA event indicators, if any */
 		writelfl(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
-		/* clear EDMA interrupt indicator, if any */
-		hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-		ipending = (DEV_IRQ | DMA_IRQ) << hardport;
-		if (hc_irq_cause & ipending) {
-			writelfl(hc_irq_cause & ~ipending,
-				 hc_mmio + HC_IRQ_CAUSE_OFS);
-		}
+		/* clear pending irq events */
+		hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
+		writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 		mv_edma_cfg(ap, want_ncq);
 
@@ -1099,20 +1089,12 @@ static void mv6_dev_config(struct ata_device *adev)
 	 *
 	 * Gen-II does not support NCQ over a port multiplier
 	 *  (no FIS-based switching).
-	 *
-	 * We don't have hob_nsect when doing NCQ commands on Gen-II.
-	 * See mv_qc_prep() for more info.
 	 */
 	if (adev->flags & ATA_DFLAG_NCQ) {
 		if (sata_pmp_attached(adev->link->ap)) {
 			adev->flags &= ~ATA_DFLAG_NCQ;
 			ata_dev_printk(adev, KERN_INFO,
 				"NCQ disabled for command-based switching\n");
-		} else if (adev->max_sectors > GEN_II_NCQ_MAX_SECTORS) {
-			adev->max_sectors = GEN_II_NCQ_MAX_SECTORS;
-			ata_dev_printk(adev, KERN_INFO,
-				"max_sectors limited to %u for NCQ\n",
-				adev->max_sectors);
 		}
 	}
 }
@@ -1450,7 +1432,8 @@ static void mv_qc_prep(struct ata_queued_cmd *qc)
 	 * only 11 bytes...so we must pick and choose required
 	 * registers based on the command.  So, we drop feature and
 	 * hob_feature for [RW] DMA commands, but they are needed for
-	 * NCQ.  NCQ will drop hob_nsect.
+	 * NCQ.  NCQ will drop hob_nsect, which is not needed there
+	 * (nsect is used only for the tag; feat/hob_feat hold true nsect).
 	 */
 	switch (tf->command) {
 	case ATA_CMD_READ:
@@ -2214,9 +2197,15 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct mv_host_priv *hpriv = host->private_data;
 	unsigned int handled = 0;
+	int using_msi = hpriv->hp_flags & MV_HP_FLAG_MSI;
 	u32 main_irq_cause, pending_irqs;
 
 	spin_lock(&host->lock);
+
+	/* for MSI:  block new interrupts while in here */
+	if (using_msi)
+		writel(0, hpriv->main_irq_mask_addr);
+
 	main_irq_cause = readl(hpriv->main_irq_cause_addr);
 	pending_irqs   = main_irq_cause & hpriv->main_irq_mask;
 	/*
@@ -2230,6 +2219,11 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 			handled = mv_host_intr(host, pending_irqs);
 	}
 	spin_unlock(&host->lock);
+
+	/* for MSI: unmask; interrupt cause bits will retrigger now */
+	if (using_msi)
+		writel(hpriv->main_irq_mask, hpriv->main_irq_mask_addr);
+
 	return IRQ_RETVAL(handled);
 }
 
@@ -2821,8 +2815,7 @@ static void mv_eh_thaw(struct ata_port *ap)
 	writel(0, port_mmio + EDMA_ERR_IRQ_CAUSE_OFS);
 
 	/* clear pending irq events */
-	hc_irq_cause = readl(hc_mmio + HC_IRQ_CAUSE_OFS);
-	hc_irq_cause &= ~((DEV_IRQ | DMA_IRQ) << hardport);
+	hc_irq_cause = ~((DEV_IRQ | DMA_IRQ) << hardport);
 	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	mv_enable_port_irqs(ap, ERR_IRQ);
@@ -3075,6 +3068,9 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK_OFS;
 	}
 
+	/* initialize shadow irq mask with register's value */
+	hpriv->main_irq_mask = readl(hpriv->main_irq_mask_addr);
+
 	/* global interrupt mask: 0 == mask everything */
 	mv_set_main_irq_mask(host, ~0, 0);
 
@@ -3430,9 +3426,9 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		return rc;
 
-	/* Enable interrupts */
-	if (msi && pci_enable_msi(pdev))
-		pci_intx(pdev, 1);
+	/* Enable message-switched interrupts, if requested */
+	if (msi && pci_enable_msi(pdev) == 0)
+		hpriv->hp_flags |= MV_HP_FLAG_MSI;
 
 	mv_dump_pci_cfg(pdev, 0x68);
 	mv_print_info(host);
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6f14606..c49ad0e 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -305,10 +305,10 @@ static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
 static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
+static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
+				   unsigned long deadline);
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
-static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
-			    unsigned long deadline);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
 static int nv_adma_slave_config(struct scsi_device *sdev);
@@ -352,6 +352,7 @@ enum nv_host_type
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
 	ADMA,
+	MCP5x,
 	SWNCQ,
 };
 
@@ -363,10 +364,10 @@ static const struct pci_device_id nv_pci_tbl[] = {
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_CK804_SATA2), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA), CK804 },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP04_SATA2), CK804 },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), MCP5x },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), MCP5x },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
@@ -432,7 +433,7 @@ static struct ata_port_operations nv_nf2_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
-	.hardreset		= nv_nf2_hardreset,
+	.hardreset		= nv_noclassify_hardreset,
 };
 
 /* CK804 finally gets hardreset right */
@@ -467,8 +468,19 @@ static struct ata_port_operations nv_adma_ops = {
 	.host_stop		= nv_adma_host_stop,
 };
 
+/* Kernel bz#12351 reports that when SWNCQ is enabled, for hotplug to
+ * work, hardreset should be used and hardreset can't report proper
+ * signature, which suggests that mcp5x is closer to nf2 as long as
+ * reset quirkiness is concerned.  Define separate ops for mcp5x with
+ * nv_noclassify_hardreset().
+ */
+static struct ata_port_operations nv_mcp5x_ops = {
+	.inherits		= &nv_common_ops,
+	.hardreset		= nv_noclassify_hardreset,
+};
+
 static struct ata_port_operations nv_swncq_ops = {
-	.inherits		= &nv_generic_ops,
+	.inherits		= &nv_mcp5x_ops,
 
 	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
@@ -531,6 +543,15 @@ static const struct ata_port_info nv_port_info[] = {
 		.port_ops	= &nv_adma_ops,
 		.private_data	= NV_PI_PRIV(nv_adma_interrupt, &nv_adma_sht),
 	},
+	/* MCP5x */
+	{
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_mcp5x_ops,
+		.private_data	= NV_PI_PRIV(nv_generic_interrupt, &nv_sht),
+	},
 	/* SWNCQ */
 	{
 		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
@@ -1530,6 +1551,17 @@ static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
+static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
+				   unsigned long deadline)
+{
+	bool online;
+	int rc;
+
+	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
+				 &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+
 static void nv_nf2_freeze(struct ata_port *ap)
 {
 	void __iomem *scr_addr = ap->host->ports[0]->ioaddr.scr_addr;
@@ -1554,17 +1586,6 @@ static void nv_nf2_thaw(struct ata_port *ap)
 	iowrite8(mask, scr_addr + NV_INT_ENABLE);
 }
 
-static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
-			    unsigned long deadline)
-{
-	bool online;
-	int rc;
-
-	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
-				 &online, NULL);
-	return online ? -EAGAIN : rc;
-}
-
 static void nv_ck804_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
@@ -2355,14 +2376,9 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (type == CK804 && adma_enabled) {
 		dev_printk(KERN_NOTICE, &pdev->dev, "Using ADMA mode\n");
 		type = ADMA;
-	}
-
-	if (type == SWNCQ) {
-		if (swncq_enabled)
-			dev_printk(KERN_NOTICE, &pdev->dev,
-				   "Using SWNCQ mode\n");
-		else
-			type = GENERIC;
+	} else if (type == MCP5x && swncq_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using SWNCQ mode\n");
+		type = SWNCQ;
 	}
 
 	ppi[0] = &nv_port_info[type];
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d56ad9c..febc10e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1357,6 +1357,7 @@
 #define PCI_DEVICE_ID_VIA_8783_0	0x3208
 #define PCI_DEVICE_ID_VIA_8237		0x3227
 #define PCI_DEVICE_ID_VIA_8251		0x3287
+#define PCI_DEVICE_ID_VIA_8261		0x3402
 #define PCI_DEVICE_ID_VIA_8237A		0x3337
 #define PCI_DEVICE_ID_VIA_8237S		0x3372
 #define PCI_DEVICE_ID_VIA_SATA_EIDE	0x5324
@@ -1366,10 +1367,13 @@
 #define PCI_DEVICE_ID_VIA_CX700		0x8324
 #define PCI_DEVICE_ID_VIA_CX700_IDE	0x0581
 #define PCI_DEVICE_ID_VIA_VX800		0x8353
+#define PCI_DEVICE_ID_VIA_VX855		0x8409
 #define PCI_DEVICE_ID_VIA_8371_1	0x8391
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
 #define PCI_DEVICE_ID_VIA_838X_1	0xB188
 #define PCI_DEVICE_ID_VIA_83_87XX_1	0xB198
+#define PCI_DEVICE_ID_VIA_C409_IDE	0XC409
+#define PCI_DEVICE_ID_VIA_ANON		0xFFFF
 
 #define PCI_VENDOR_ID_SIEMENS           0x110A
 #define PCI_DEVICE_ID_SIEMENS_DSCC4     0x2102
