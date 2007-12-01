Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXLAXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXLAXfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXLAXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:35:26 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33933 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXLAXfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:35:24 -0500
Date: Sat, 1 Dec 2007 18:35:23 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071201233523.GA9624@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |   28 +++++++++++++++++++
 drivers/ata/libata-core.c |    8 +++--
 drivers/ata/libata-eh.c   |   42 +++++++++++++++++++++++------
 drivers/ata/pata_at32.c   |   61 +++++++++++++++++++++++-------------------
 drivers/ata/pata_bf54x.c  |    7 +++++
 drivers/ata/sata_mv.c     |   64 ++++++++++++++++++++++++++++++--------------
 6 files changed, 149 insertions(+), 61 deletions(-)

Alan Cox (1):
      libata: Fix early use of port printk. (Was Re: ata4294967295: failed to start port (errno=-19))

Kristoffer Nyborg Gregertsen (1):
      Several fixes for the AVR32 PATA driver

Mark Lord (1):
      sata_mv: Fix broken Marvell 7042 support.

Peter Missel (1):
      libata: More IVB horkage from TSST

Peter Schwenke (1):
      ata_piix: add more toshiba laptops to broken suspend list

Saeed Bishara (1):
      sata_mv: fix compilation error when enabling DEBUG

Tejun Heo (1):
      libata: report protocol and full CDB on error

sonic zhang (1):
      Set proper ATA UDMA mode for bf548 according to system clock.

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 483269d..b538e1d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -967,6 +967,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M3",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Tecra M3"),
+			},
+		},
+		{
 			.ident = "TECRA M5",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -981,6 +988,20 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA A8",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA A8"),
+			},
+		},
+		{
+			.ident = "Satellite R25",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite R25"),
+			},
+		},
+		{
 			.ident = "Satellite U200",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -988,6 +1009,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "Satellite U200",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "SATELLITE U200"),
+			},
+		},
+		{
 			.ident = "Satellite Pro U200",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 33f0627..b514a80 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4185,6 +4185,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices which get the IVB wrong */
 	{ "QUANTUM FIREBALLlct10 05", "A03.0900", ATA_HORKAGE_IVB, },
 	{ "TSSTcorp CDDVDW SH-S202J", "SB00",	  ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202J", "SB01",	  ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202N", "SB00",	  ATA_HORKAGE_IVB, },
+	{ "TSSTcorp CDDVDW SH-S202N", "SB01",	  ATA_HORKAGE_IVB, },
 
 	/* End Marker */
 	{ }
@@ -6964,12 +6967,11 @@ int ata_host_start(struct ata_host *host)
 		if (ap->ops->port_start) {
 			rc = ap->ops->port_start(ap);
 			if (rc) {
-				ata_port_printk(ap, KERN_ERR, "failed to "
-						"start port (errno=%d)\n", rc);
+				if (rc != -ENODEV)
+					dev_printk(KERN_ERR, host->dev, "failed to start port %d (errno=%d)\n", i, rc);
 				goto err_out;
 			}
 		}
-
 		ata_eh_freeze_port(ap);
 	}
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0dac69d..e6605f0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1850,30 +1850,54 @@ static void ata_eh_link_report(struct ata_link *link)
 		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "");
 
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
-		static const char *dma_str[] = {
-			[DMA_BIDIRECTIONAL]	= "bidi",
-			[DMA_TO_DEVICE]		= "out",
-			[DMA_FROM_DEVICE]	= "in",
-			[DMA_NONE]		= "",
-		};
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 		struct ata_taskfile *cmd = &qc->tf, *res = &qc->result_tf;
+		const u8 *cdb = qc->cdb;
+		char data_buf[20] = "";
+		char cdb_buf[70] = "";
 
 		if (!(qc->flags & ATA_QCFLAG_FAILED) ||
 		    qc->dev->link != link || !qc->err_mask)
 			continue;
 
+		if (qc->dma_dir != DMA_NONE) {
+			static const char *dma_str[] = {
+				[DMA_BIDIRECTIONAL]	= "bidi",
+				[DMA_TO_DEVICE]		= "out",
+				[DMA_FROM_DEVICE]	= "in",
+			};
+			static const char *prot_str[] = {
+				[ATA_PROT_PIO]		= "pio",
+				[ATA_PROT_DMA]		= "dma",
+				[ATA_PROT_NCQ]		= "ncq",
+				[ATA_PROT_ATAPI]	= "pio",
+				[ATA_PROT_ATAPI_DMA]	= "dma",
+			};
+
+			snprintf(data_buf, sizeof(data_buf), " %s %u %s",
+				 prot_str[qc->tf.protocol], qc->nbytes,
+				 dma_str[qc->dma_dir]);
+		}
+
+		if (is_atapi_taskfile(&qc->tf))
+			snprintf(cdb_buf, sizeof(cdb_buf),
+				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
+				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
+				 cdb[0], cdb[1], cdb[2], cdb[3],
+				 cdb[4], cdb[5], cdb[6], cdb[7],
+				 cdb[8], cdb[9], cdb[10], cdb[11],
+				 cdb[12], cdb[13], cdb[14], cdb[15]);
+
 		ata_dev_printk(qc->dev, KERN_ERR,
 			"cmd %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
-			"tag %d cdb 0x%x data %u %s\n         "
+			"tag %d%s\n         %s"
 			"res %02x/%02x:%02x:%02x:%02x:%02x/%02x:%02x:%02x:%02x:%02x/%02x "
 			"Emask 0x%x (%s)%s\n",
 			cmd->command, cmd->feature, cmd->nsect,
 			cmd->lbal, cmd->lbam, cmd->lbah,
 			cmd->hob_feature, cmd->hob_nsect,
 			cmd->hob_lbal, cmd->hob_lbam, cmd->hob_lbah,
-			cmd->device, qc->tag, qc->cdb[0], qc->nbytes,
-			dma_str[qc->dma_dir],
+			cmd->device, qc->tag, data_buf, cdb_buf,
 			res->command, res->feature, res->nsect,
 			res->lbal, res->lbam, res->lbah,
 			res->hob_feature, res->hob_nsect,
diff --git a/drivers/ata/pata_at32.c b/drivers/ata/pata_at32.c
index bb250a4..67e574d 100644
--- a/drivers/ata/pata_at32.c
+++ b/drivers/ata/pata_at32.c
@@ -28,7 +28,7 @@
 #include <asm/arch/smc.h>
 
 #define DRV_NAME "pata_at32"
-#define DRV_VERSION "0.0.2"
+#define DRV_VERSION "0.0.3"
 
 /*
  * CompactFlash controller memory layout relative to the base address:
@@ -64,6 +64,8 @@
  *	Mode 2	| 8.3	| 240 ns	 | 0x07
  *	Mode 3	| 11.1	| 180 ns	 | 0x0f
  *	Mode 4	| 16.7	| 120 ns	 | 0x1f
+ *
+ * Alter PIO_MASK below according to table to set maximal PIO mode.
  */
 #define PIO_MASK (0x1f)
 
@@ -85,36 +87,40 @@ struct at32_ide_info {
  */
 static int pata_at32_setup_timing(struct device *dev,
 				  struct at32_ide_info *info,
-				  const struct ata_timing *timing)
+				  const struct ata_timing *ata)
 {
-	/* These two values are found through testing */
-	const int min_recover = 25;
-	const int ncs_hold    = 15;
-
 	struct smc_config *smc = &info->smc;
+	struct smc_timing timing;
 
 	int active;
 	int recover;
 
+	memset(&timing, 0, sizeof(struct smc_timing));
+
 	/* Total cycle time */
-	smc->read_cycle	= timing->cyc8b;
+	timing.read_cycle  = ata->cyc8b;
 
 	/* DIOR <= CFIOR timings */
-	smc->nrd_setup = timing->setup;
-	smc->nrd_pulse = timing->act8b;
+	timing.nrd_setup   = ata->setup;
+	timing.nrd_pulse   = ata->act8b;
+	timing.nrd_recover = ata->rec8b;
+
+	/* Convert nanosecond timing to clock cycles */
+	smc_set_timing(smc, &timing);
 
-	/* Compute recover, extend total cycle if needed */
-	active	= smc->nrd_setup + smc->nrd_pulse;
+	/* Add one extra cycle setup due to signal ring */
+	smc->nrd_setup = smc->nrd_setup + 1;
+
+	active  = smc->nrd_setup + smc->nrd_pulse;
 	recover = smc->read_cycle - active;
 
-	if (recover < min_recover) {
-		smc->read_cycle = active + min_recover;
-		recover = min_recover;
-	}
+	/* Need at least two cycles recovery */
+	if (recover < 2)
+	  smc->read_cycle = active + 2;
 
 	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
-	smc->ncs_read_setup  = 0;
-	smc->ncs_read_pulse  = active + ncs_hold;
+	smc->ncs_read_setup = 1;
+	smc->ncs_read_pulse = smc->read_cycle - 2;
 
 	/* Write timings same as read timings */
 	smc->write_cycle = smc->read_cycle;
@@ -123,11 +129,13 @@ static int pata_at32_setup_timing(struct device *dev,
 	smc->ncs_write_setup = smc->ncs_read_setup;
 	smc->ncs_write_pulse = smc->ncs_read_pulse;
 
-	/* Do some debugging output */
-	dev_dbg(dev, "SMC: C=%d S=%d P=%d R=%d NCSS=%d NCSP=%d NCSR=%d\n",
+	/* Do some debugging output of ATA and SMC timings */
+	dev_dbg(dev, "ATA: C=%d S=%d P=%d R=%d\n",
+		ata->cyc8b, ata->setup, ata->act8b, ata->rec8b);
+
+	dev_dbg(dev, "SMC: C=%d S=%d P=%d NS=%d NP=%d\n",
 		smc->read_cycle, smc->nrd_setup, smc->nrd_pulse,
-		recover, smc->ncs_read_setup, smc->ncs_read_pulse,
-		smc->read_cycle - smc->ncs_read_pulse);
+		smc->ncs_read_setup, smc->ncs_read_pulse);
 
 	/* Finally, configure the SMC */
 	return smc_set_configuration(info->cs, smc);
@@ -182,7 +190,6 @@ static struct scsi_host_template at32_sht = {
 };
 
 static struct ata_port_operations at32_port_ops = {
-	.port_disable		= ata_port_disable,
 	.set_piomode		= pata_at32_set_piomode,
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -203,7 +210,6 @@ static struct ata_port_operations at32_port_ops = {
 
 	.irq_clear		= pata_at32_irq_clear,
 	.irq_on			= ata_irq_on,
-	.irq_ack		= ata_irq_ack,
 
 	.port_start		= ata_sff_port_start,
 };
@@ -223,8 +229,7 @@ static int __init pata_at32_init_one(struct device *dev,
 	/* Setup ATA bindings */
 	ap->ops	     = &at32_port_ops;
 	ap->pio_mask = PIO_MASK;
-	ap->flags    = ATA_FLAG_MMIO | ATA_FLAG_SLAVE_POSS
-		| ATA_FLAG_PIO_POLLING;
+	ap->flags   |= ATA_FLAG_MMIO | ATA_FLAG_SLAVE_POSS;
 
 	/*
 	 * Since all 8-bit taskfile transfers has to go on the lower
@@ -357,12 +362,12 @@ static int __init pata_at32_probe(struct platform_device *pdev)
 	info->smc.tdf_mode	 = 0; /* TDF optimization disabled */
 	info->smc.tdf_cycles	 = 0; /* No TDF wait cycles */
 
-	/* Setup ATA timing */
+	/* Setup SMC to ATA timing */
 	ret = pata_at32_setup_timing(dev, info, &initial_timing);
 	if (ret)
 		goto err_setup_timing;
 
-	/* Setup ATA addresses */
+	/* Map ATA address space */
 	ret = -ENOMEM;
 	info->ide_addr = devm_ioremap(dev, info->res_ide.start, 16);
 	info->alt_addr = devm_ioremap(dev, info->res_alt.start, 16);
@@ -373,7 +378,7 @@ static int __init pata_at32_probe(struct platform_device *pdev)
 	pata_at32_debug_bus(dev, info);
 #endif
 
-	/* Register ATA device */
+	/* Setup and register ATA device */
 	ret = pata_at32_init_one(dev, info);
 	if (ret)
 		goto err_ata_device;
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 81db405..088a41f 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1489,6 +1489,8 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	int board_idx = 0;
 	struct resource *res;
 	struct ata_host *host;
+	unsigned int fsclk = get_sclk();
+	int udma_mode = 5;
 	const struct ata_port_info *ppi[] =
 		{ &bfin_port_info[board_idx], NULL };
 
@@ -1507,6 +1509,11 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -EINVAL;
 
+	while (bfin_port_info[board_idx].udma_mask>0 && udma_fsclk[udma_mode] > fsclk) {
+		udma_mode--;
+		bfin_port_info[board_idx].udma_mask >>= 1;
+	}
+
 	/*
 	 * Now that that's out of the way, wire up the port..
 	 */
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index a43f64d..8d864e5 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -164,10 +164,14 @@ enum {
 	MV_PCI_ERR_ATTRIBUTE	= 0x1d48,
 	MV_PCI_ERR_COMMAND	= 0x1d50,
 
-	PCI_IRQ_CAUSE_OFS		= 0x1d58,
-	PCI_IRQ_MASK_OFS		= 0x1d5c,
+	PCI_IRQ_CAUSE_OFS	= 0x1d58,
+	PCI_IRQ_MASK_OFS	= 0x1d5c,
 	PCI_UNMASK_ALL_IRQS	= 0x7fffff,	/* bits 22-0 */
 
+	PCIE_IRQ_CAUSE_OFS	= 0x1900,
+	PCIE_IRQ_MASK_OFS	= 0x1910,
+	PCIE_UNMASK_ALL_IRQS	= 0x70a,	/* assorted bits */
+
 	HC_MAIN_IRQ_CAUSE_OFS	= 0x1d60,
 	HC_MAIN_IRQ_MASK_OFS	= 0x1d64,
 	PORT0_ERR		= (1 << 0),	/* shift by port # */
@@ -303,6 +307,7 @@ enum {
 	MV_HP_GEN_I		= (1 << 6),	/* Generation I: 50xx */
 	MV_HP_GEN_II		= (1 << 7),	/* Generation II: 60xx */
 	MV_HP_GEN_IIE		= (1 << 8),	/* Generation IIE: 6042/7042 */
+	MV_HP_PCIE		= (1 << 9),	/* PCIe bus/regs: 7042 */
 
 	/* Port private flags (pp_flags) */
 	MV_PP_FLAG_EDMA_EN	= (1 << 0),	/* is EDMA engine enabled? */
@@ -388,7 +393,15 @@ struct mv_port_signal {
 	u32			pre;
 };
 
-struct mv_host_priv;
+struct mv_host_priv {
+	u32			hp_flags;
+	struct mv_port_signal	signal[8];
+	const struct mv_hw_ops	*ops;
+	u32			irq_cause_ofs;
+	u32			irq_mask_ofs;
+	u32			unmask_all_irqs;
+};
+
 struct mv_hw_ops {
 	void (*phy_errata)(struct mv_host_priv *hpriv, void __iomem *mmio,
 			   unsigned int port);
@@ -401,12 +414,6 @@ struct mv_hw_ops {
 	void (*reset_bus)(struct pci_dev *pdev, void __iomem *mmio);
 };
 
-struct mv_host_priv {
-	u32			hp_flags;
-	struct mv_port_signal	signal[8];
-	const struct mv_hw_ops	*ops;
-};
-
 static void mv_irq_clear(struct ata_port *ap);
 static int mv_scr_read(struct ata_port *ap, unsigned int sc_reg_in, u32 *val);
 static int mv_scr_write(struct ata_port *ap, unsigned int sc_reg_in, u32 val);
@@ -631,11 +638,13 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	/* Adaptec 1430SA */
 	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
 
-	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
-
-	/* add Marvell 7042 support */
+	/* Marvell 7042 support */
 	{ PCI_VDEVICE(MARVELL, 0x7042), chip_7042 },
 
+	/* Highpoint RocketRAID PCIe series */
+	{ PCI_VDEVICE(TTI, 0x2300), chip_7042 },
+	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
+
 	{ }			/* terminate list */
 };
 
@@ -1648,13 +1657,14 @@ static void mv_host_intr(struct ata_host *host, u32 relevant, unsigned int hc)
 
 static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
 {
+	struct mv_host_priv *hpriv = host->private_data;
 	struct ata_port *ap;
 	struct ata_queued_cmd *qc;
 	struct ata_eh_info *ehi;
 	unsigned int i, err_mask, printed = 0;
 	u32 err_cause;
 
-	err_cause = readl(mmio + PCI_IRQ_CAUSE_OFS);
+	err_cause = readl(mmio + hpriv->irq_cause_ofs);
 
 	dev_printk(KERN_ERR, host->dev, "PCI ERROR; PCI IRQ cause=0x%08x\n",
 		   err_cause);
@@ -1662,7 +1672,7 @@ static void mv_pci_error(struct ata_host *host, void __iomem *mmio)
 	DPRINTK("All regs @ PCI error\n");
 	mv_dump_all_regs(mmio, -1, to_pci_dev(host->dev));
 
-	writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
+	writelfl(0, mmio + hpriv->irq_cause_ofs);
 
 	for (i = 0; i < host->n_ports; i++) {
 		ap = host->ports[i];
@@ -1926,6 +1936,8 @@ static int mv5_reset_hc(struct mv_host_priv *hpriv, void __iomem *mmio,
 #define ZERO(reg) writel(0, mmio + (reg))
 static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio)
 {
+	struct ata_host     *host = dev_get_drvdata(&pdev->dev);
+	struct mv_host_priv *hpriv = host->private_data;
 	u32 tmp;
 
 	tmp = readl(mmio + MV_PCI_MODE);
@@ -1937,8 +1949,8 @@ static void mv_reset_pci_bus(struct pci_dev *pdev, void __iomem *mmio)
 	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT);
 	ZERO(HC_MAIN_IRQ_MASK_OFS);
 	ZERO(MV_PCI_SERR_MASK);
-	ZERO(PCI_IRQ_CAUSE_OFS);
-	ZERO(PCI_IRQ_MASK_OFS);
+	ZERO(hpriv->irq_cause_ofs);
+	ZERO(hpriv->irq_mask_ofs);
 	ZERO(MV_PCI_ERR_LOW_ADDRESS);
 	ZERO(MV_PCI_ERR_HIGH_ADDRESS);
 	ZERO(MV_PCI_ERR_ATTRIBUTE);
@@ -2170,7 +2182,7 @@ static void mv_phy_reset(struct ata_port *ap, unsigned int *class,
 		mv_scr_read(ap, SCR_ERROR, &serror);
 		mv_scr_read(ap, SCR_CONTROL, &scontrol);
 		DPRINTK("S-regs after ATA_RST: SStat 0x%08x SErr 0x%08x "
-			"SCtrl 0x%08x\n", status, serror, scontrol);
+			"SCtrl 0x%08x\n", sstatus, serror, scontrol);
 	}
 #endif
 
@@ -2490,6 +2502,7 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 		break;
 
 	case chip_7042:
+		hp_flags |= MV_HP_PCIE;
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
 		hp_flags |= MV_HP_GEN_IIE;
@@ -2516,6 +2529,15 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 	}
 
 	hpriv->hp_flags = hp_flags;
+	if (hp_flags & MV_HP_PCIE) {
+		hpriv->irq_cause_ofs	= PCIE_IRQ_CAUSE_OFS;
+		hpriv->irq_mask_ofs	= PCIE_IRQ_MASK_OFS;
+		hpriv->unmask_all_irqs	= PCIE_UNMASK_ALL_IRQS;
+	} else {
+		hpriv->irq_cause_ofs	= PCI_IRQ_CAUSE_OFS;
+		hpriv->irq_mask_ofs	= PCI_IRQ_MASK_OFS;
+		hpriv->unmask_all_irqs	= PCI_UNMASK_ALL_IRQS;
+	}
 
 	return 0;
 }
@@ -2595,10 +2617,10 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 	}
 
 	/* Clear any currently outstanding host interrupt conditions */
-	writelfl(0, mmio + PCI_IRQ_CAUSE_OFS);
+	writelfl(0, mmio + hpriv->irq_cause_ofs);
 
 	/* and unmask interrupt generation for host regs */
-	writelfl(PCI_UNMASK_ALL_IRQS, mmio + PCI_IRQ_MASK_OFS);
+	writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
 
 	if (IS_GEN_I(hpriv))
 		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
@@ -2609,8 +2631,8 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		"PCI int cause/mask=0x%08x/0x%08x\n",
 		readl(mmio + HC_MAIN_IRQ_CAUSE_OFS),
 		readl(mmio + HC_MAIN_IRQ_MASK_OFS),
-		readl(mmio + PCI_IRQ_CAUSE_OFS),
-		readl(mmio + PCI_IRQ_MASK_OFS));
+		readl(mmio + hpriv->irq_cause_ofs),
+		readl(mmio + hpriv->irq_mask_ofs));
 
 done:
 	return rc;
