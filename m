Return-Path: <linux-kernel-owner+w=401wt.eu-S1030654AbXAYX6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654AbXAYX6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXAYX6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:58:12 -0500
Received: from havoc.gtf.org ([69.61.125.42]:49251 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030654AbXAYX6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:58:09 -0500
Date: Thu, 25 Jan 2007 18:58:07 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070125235807.GA22046@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c           |   57 ++++++++++++++++++++++++++++++++++++------
 drivers/ata/ata_generic.c    |    6 +++-
 drivers/ata/libata-core.c    |   14 +---------
 drivers/ata/libata-sff.c     |   15 +++++++---
 drivers/ata/pata_cmd64x.c    |   23 +++++++++++-----
 drivers/ata/pata_hpt3x2n.c   |    6 ++--
 drivers/ata/pata_it821x.c    |    4 ++-
 drivers/ata/pata_ixp4xx_cf.c |    5 ++-
 drivers/ata/pata_legacy.c    |    4 ++-
 drivers/ata/pata_rz1000.c    |    6 +++-
 drivers/ata/sata_uli.c       |    3 +-
 drivers/ata/sata_via.c       |   12 ++++++++-
 include/linux/libata.h       |    5 ++-
 13 files changed, 113 insertions(+), 47 deletions(-)

Alan (4):
      libata cmd64x: whack into a shape that looks like the documentation
      libata hpt3xn: Hopefully sort out the DPLL logic versus the vendor code
      libata: set_mode, Fix the FIXME
      libata-sff: Don't call bmdma_stop on non DMA capable controllers

Tejun Heo (3):
      sata_via: don't diddle with ATA_NIEN in ->freeze
      ahci: improve and limit spurious interrupt messages, take#3
      libata: implement ATA_FLAG_IGN_SIMPLEX and use it in sata_uli

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e3c7b31..2fe5a58 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -75,6 +75,7 @@ enum {
 	AHCI_CMD_CLR_BUSY	= (1 << 10),
 
 	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
+	RX_FIS_SDB		= 0x58, /* offset of SDB FIS data */
 	RX_FIS_UNK		= 0x60, /* offset of Unknown FIS data */
 
 	board_ahci		= 0,
@@ -202,6 +203,10 @@ struct ahci_port_priv {
 	dma_addr_t		cmd_tbl_dma;
 	void			*rx_fis;
 	dma_addr_t		rx_fis_dma;
+	/* for NCQ spurious interrupt analysis */
+	int			ncq_saw_spurious_sdb_cnt;
+	unsigned int		ncq_saw_d2h:1;
+	unsigned int		ncq_saw_dmas:1;
 };
 
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
@@ -1109,8 +1114,9 @@ static void ahci_host_intr(struct ata_port *ap)
 	void __iomem *mmio = ap->host->mmio_base;
 	void __iomem *port_mmio = ahci_port_base(mmio, ap->port_no);
 	struct ata_eh_info *ehi = &ap->eh_info;
+	struct ahci_port_priv *pp = ap->private_data;
 	u32 status, qc_active;
-	int rc;
+	int rc, known_irq = 0;
 
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
@@ -1137,17 +1143,52 @@ static void ahci_host_intr(struct ata_port *ap)
 
 	/* hmmm... a spurious interupt */
 
-	/* some devices send D2H reg with I bit set during NCQ command phase */
-	if (ap->sactive && (status & PORT_IRQ_D2H_REG_FIS))
+	/* if !NCQ, ignore.  No modern ATA device has broken HSM
+	 * implementation for non-NCQ commands.
+	 */
+	if (!ap->sactive)
 		return;
 
-	/* ignore interim PIO setup fis interrupts */
-	if (ata_tag_valid(ap->active_tag) && (status & PORT_IRQ_PIOS_FIS))
-		return;
+	if (status & PORT_IRQ_D2H_REG_FIS) {
+		if (!pp->ncq_saw_d2h)
+			ata_port_printk(ap, KERN_INFO,
+				"D2H reg with I during NCQ, "
+				"this message won't be printed again\n");
+		pp->ncq_saw_d2h = 1;
+		known_irq = 1;
+	}
+
+	if (status & PORT_IRQ_DMAS_FIS) {
+		if (!pp->ncq_saw_dmas)
+			ata_port_printk(ap, KERN_INFO,
+				"DMAS FIS during NCQ, "
+				"this message won't be printed again\n");
+		pp->ncq_saw_dmas = 1;
+		known_irq = 1;
+	}
+
+	if (status & PORT_IRQ_SDB_FIS &&
+		   pp->ncq_saw_spurious_sdb_cnt < 10) {
+		/* SDB FIS containing spurious completions might be
+		 * dangerous, we need to know more about them.  Print
+		 * more of it.
+		 */
+		const u32 *f = pp->rx_fis + RX_FIS_SDB;
+
+		ata_port_printk(ap, KERN_INFO, "Spurious SDB FIS during NCQ "
+				"issue=0x%x SAct=0x%x FIS=%08x:%08x%s\n",
+				readl(port_mmio + PORT_CMD_ISSUE),
+				readl(port_mmio + PORT_SCR_ACT), f[0], f[1],
+				pp->ncq_saw_spurious_sdb_cnt < 10 ?
+				"" : ", shutting up");
+
+		pp->ncq_saw_spurious_sdb_cnt++;
+		known_irq = 1;
+	}
 
-	if (ata_ratelimit())
+	if (!known_irq)
 		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
-				"(irq_stat 0x%x active_tag %d sactive 0x%x)\n",
+				"(irq_stat 0x%x active_tag 0x%x sactive 0x%x)\n",
 				status, ap->active_tag, ap->sactive);
 }
 
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 908751d..24af560 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -64,6 +64,7 @@ static void generic_error_handler(struct ata_port *ap)
 /**
  *	generic_set_mode	-	mode setting
  *	@ap: interface to set up
+ *	@unused: returned device on error
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *	The BIOS configured everything. Our job is not to fiddle. We
@@ -71,7 +72,7 @@ static void generic_error_handler(struct ata_port *ap)
  *	and respect them.
  */
 
-static void generic_set_mode(struct ata_port *ap)
+static int generic_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int dma_enabled = 0;
 	int i;
@@ -82,7 +83,7 @@ static void generic_set_mode(struct ata_port *ap)
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->dma_mode = XFER_MW_DMA_0;
@@ -99,6 +100,7 @@ static void generic_set_mode(struct ata_port *ap)
 			}
 		}
 	}
+	return 0;
 }
 
 static struct scsi_host_template generic_sht = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 0d51d13..a388a8d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2431,18 +2431,8 @@ int ata_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 	int i, rc = 0, used_dma = 0, found = 0;
 
 	/* has private set_mode? */
-	if (ap->ops->set_mode) {
-		/* FIXME: make ->set_mode handle no device case and
-		 * return error code and failing device on failure.
-		 */
-		for (i = 0; i < ATA_MAX_DEVICES; i++) {
-			if (ata_dev_ready(&ap->device[i])) {
-				ap->ops->set_mode(ap);
-				break;
-			}
-		}
-		return 0;
-	}
+	if (ap->ops->set_mode)
+		return ap->ops->set_mode(ap, r_failed_dev);
 
 	/* step 1: calculate xfer_mask */
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 623cec9..942aeba 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -827,7 +827,8 @@ void ata_bmdma_error_handler(struct ata_port *ap)
  */
 void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	ata_bmdma_stop(qc);
+	if (qc->ap->ioaddr.bmdma_addr)
+		ata_bmdma_stop(qc);
 }
 
 #ifdef CONFIG_PCI
@@ -870,7 +871,8 @@ ata_pci_init_native_mode(struct pci_dev *pdev, struct ata_port_info **port, int
 			pci_resource_start(pdev, 1) | ATA_PCI_CTL_OFS;
 		bmdma = pci_resource_start(pdev, 4);
 		if (bmdma) {
-			if (inb(bmdma + 2) & 0x80)
+			if ((!(port[p]->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+			    (inb(bmdma + 2) & 0x80))
 				probe_ent->_host_flags |= ATA_HOST_SIMPLEX;
 			probe_ent->port[p].bmdma_addr = bmdma;
 		}
@@ -886,7 +888,8 @@ ata_pci_init_native_mode(struct pci_dev *pdev, struct ata_port_info **port, int
 		bmdma = pci_resource_start(pdev, 4);
 		if (bmdma) {
 			bmdma += 8;
-			if(inb(bmdma + 2) & 0x80)
+			if ((!(port[p]->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+			    (inb(bmdma + 2) & 0x80))
 				probe_ent->_host_flags |= ATA_HOST_SIMPLEX;
 			probe_ent->port[p].bmdma_addr = bmdma;
 		}
@@ -920,7 +923,8 @@ static struct ata_probe_ent *ata_pci_init_legacy_port(struct pci_dev *pdev,
 		probe_ent->port[0].ctl_addr = ATA_PRIMARY_CTL;
 		if (bmdma) {
 			probe_ent->port[0].bmdma_addr = bmdma;
-			if (inb(bmdma + 2) & 0x80)
+			if ((!(port[0]->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+			    (inb(bmdma + 2) & 0x80))
 				probe_ent->_host_flags |= ATA_HOST_SIMPLEX;
 		}
 		ata_std_ports(&probe_ent->port[0]);
@@ -937,7 +941,8 @@ static struct ata_probe_ent *ata_pci_init_legacy_port(struct pci_dev *pdev,
 		probe_ent->port[1].ctl_addr = ATA_SECONDARY_CTL;
 		if (bmdma) {
 			probe_ent->port[1].bmdma_addr = bmdma + 8;
-			if (inb(bmdma + 10) & 0x80)
+			if ((!(port[1]->flags & ATA_FLAG_IGN_SIMPLEX)) &&
+			    (inb(bmdma + 10) & 0x80))
 				probe_ent->_host_flags |= ATA_HOST_SIMPLEX;
 		}
 		ata_std_ports(&probe_ent->port[1]);
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 15841a5..449162c 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -197,7 +197,7 @@ static void cmd64x_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u8 udma_data[] = {
-		0x31, 0x21, 0x11, 0x25, 0x15, 0x05
+		0x30, 0x20, 0x10, 0x20, 0x10, 0x00
 	};
 	static const u8 mwdma_data[] = {
 		0x30, 0x20, 0x10
@@ -213,12 +213,21 @@ static void cmd64x_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	pci_read_config_byte(pdev, pciD, &regD);
 	pci_read_config_byte(pdev, pciU, &regU);
 
-	regD &= ~(0x20 << shift);
-	regU &= ~(0x35 << shift);
+	/* DMA bits off */
+	regD &= ~(0x20 << adev->devno);
+	/* DMA control bits */
+	regU &= ~(0x30 << shift);
+	/* DMA timing bits */
+	regU &= ~(0x05 << adev->devno);
 
-	if (adev->dma_mode >= XFER_UDMA_0)
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		/* Merge thge timing value */
 		regU |= udma_data[adev->dma_mode - XFER_UDMA_0] << shift;
-	else
+		/* Merge the control bits */
+		regU |= 1 << adev->devno; /* UDMA on */
+		if (adev->dma_mode > 2)	/* 15nS timing */
+			regU |= 4 << adev->devno;
+	} else
 		regD |= mwdma_data[adev->dma_mode - XFER_MW_DMA_0] << shift;
 
 	regD |= 0x20 << adev->devno;
@@ -239,8 +248,8 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 dma_intr;
-	int dma_reg = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_mask = ap->port_no ? ARTTIM2 : CFR;
+	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
+	int dma_reg = ap->port_no ? ARTTIM2 : CFR;
 
 	ata_bmdma_stop(qc);
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index f6817b4..886fab9 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3"
+#define DRV_VERSION	"0.3.2"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -297,11 +297,11 @@ static int hpt3x2n_pair_idle(struct ata_port *ap)
 	return 0;
 }
 
-static int hpt3x2n_use_dpll(struct ata_port *ap, int reading)
+static int hpt3x2n_use_dpll(struct ata_port *ap, int writing)
 {
 	long flags = (long)ap->host->private_data;
 	/* See if we should use the DPLL */
-	if (reading == 0)
+	if (writing)
 		return USE_DPLL;	/* Needed for write */
 	if (flags & PCI66)
 		return USE_DPLL;	/* Needed at 66Mhz */
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 0b56ff3..e8afd48 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -476,6 +476,7 @@ static unsigned int it821x_passthru_qc_issue_prot(struct ata_queued_cmd *qc)
 /**
  *	it821x_smart_set_mode	-	mode setting
  *	@ap: interface to set up
+ *	@unused: device that failed (error only)
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *	The BIOS configured everything. Our job is not to fiddle. We
@@ -483,7 +484,7 @@ static unsigned int it821x_passthru_qc_issue_prot(struct ata_queued_cmd *qc)
  *	and respect them.
  */
 
-static void it821x_smart_set_mode(struct ata_port *ap)
+static int it821x_smart_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int dma_enabled = 0;
 	int i;
@@ -512,6 +513,7 @@ static void it821x_smart_set_mode(struct ata_port *ap)
 			}
 		}
 	}
+	return 0;
 }
 
 /**
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index cb89241..23b8aab 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -23,9 +23,9 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.1"
+#define DRV_VERSION	"0.1.1ac1"
 
-static void ixp4xx_set_mode(struct ata_port *ap)
+static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	int i;
 
@@ -38,6 +38,7 @@ static void ixp4xx_set_mode(struct ata_port *ap)
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static void ixp4xx_phy_reset(struct ata_port *ap)
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index e7bf9d8..581cb33 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -96,6 +96,7 @@ static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
 /**
  *	legacy_set_mode		-	mode setting
  *	@ap: IDE interface
+ *	@unused: Device that failed when error is returned
  *
  *	Use a non standard set_mode function. We don't want to be tuned.
  *
@@ -105,7 +106,7 @@ static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
  *	expand on this as per hdparm in the base kernel.
  */
 
-static void legacy_set_mode(struct ata_port *ap)
+static int legacy_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int i;
 
@@ -118,6 +119,7 @@ static void legacy_set_mode(struct ata_port *ap)
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static struct scsi_host_template legacy_sht = {
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index adf4cc1..cec0729 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -52,19 +52,20 @@ static void rz1000_error_handler(struct ata_port *ap)
 /**
  *	rz1000_set_mode		-	mode setting function
  *	@ap: ATA interface
+ *	@unused: returned device on set_mode failure
  *
  *	Use a non standard set_mode function. We don't want to be tuned. We
  *	would prefer to be BIOS generic but for the fact our hardware is
  *	whacked out.
  */
 
-static void rz1000_set_mode(struct ata_port *ap)
+static int rz1000_set_mode(struct ata_port *ap, struct ata_device **unused)
 {
 	int i;
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_enabled(dev)) {
+		if (ata_dev_ready(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
@@ -72,6 +73,7 @@ static void rz1000_set_mode(struct ata_port *ap)
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 5c603ca..a43aec6 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -128,7 +128,8 @@ static const struct ata_port_operations uli_ops = {
 
 static struct ata_port_info uli_port_info = {
 	.sht            = &uli_sht,
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+			  ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = 0x1f,		/* pio0-4 */
 	.udma_mask      = 0x7f,		/* udma0-6 */
 	.port_ops       = &uli_ops,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 88f0565..55b0123 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -74,6 +74,7 @@ enum {
 static int svia_init_one (struct pci_dev *pdev, const struct pci_device_id *ent);
 static u32 svia_scr_read (struct ata_port *ap, unsigned int sc_reg);
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
+static void svia_noop_freeze(struct ata_port *ap);
 static void vt6420_error_handler(struct ata_port *ap);
 
 static const struct pci_device_id svia_pci_tbl[] = {
@@ -128,7 +129,7 @@ static const struct ata_port_operations vt6420_sata_ops = {
 	.qc_issue		= ata_qc_issue_prot,
 	.data_xfer		= ata_pio_data_xfer,
 
-	.freeze			= ata_bmdma_freeze,
+	.freeze			= svia_noop_freeze,
 	.thaw			= ata_bmdma_thaw,
 	.error_handler		= vt6420_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
@@ -204,6 +205,15 @@ static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val)
 	outl(val, ap->ioaddr.scr_addr + (4 * sc_reg));
 }
 
+static void svia_noop_freeze(struct ata_port *ap)
+{
+	/* Some VIA controllers choke if ATA_NIEN is manipulated in
+	 * certain way.  Leave it alone and just clear pending IRQ.
+	 */
+	ata_chk_status(ap);
+	ap->ops->irq_clear(ap);
+}
+
 /**
  *	vt6420_prereset - prereset for vt6420
  *	@ap: target ATA port
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f7f268e..22aa69e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -177,6 +177,7 @@ enum {
 					      * Register FIS clearing BSY */
 	ATA_FLAG_DEBUGMSG	= (1 << 13),
 	ATA_FLAG_SETXFER_POLLING= (1 << 14), /* use polling for SETXFER */
+	ATA_FLAG_IGN_SIMPLEX	= (1 << 15), /* ignore SIMPLEX */
 
 	/* The following flag belongs to ap->pflags but is kept in
 	 * ap->flags because it's referenced in many LLDs and will be
@@ -612,11 +613,11 @@ struct ata_port_operations {
 	void (*dev_select)(struct ata_port *ap, unsigned int device);
 
 	void (*phy_reset) (struct ata_port *ap); /* obsolete */
-	void (*set_mode) (struct ata_port *ap);
+	int  (*set_mode) (struct ata_port *ap, struct ata_device **r_failed_dev);
 
 	void (*post_set_mode) (struct ata_port *ap);
 
-	int (*check_atapi_dma) (struct ata_queued_cmd *qc);
+	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
 
 	void (*bmdma_setup) (struct ata_queued_cmd *qc);
 	void (*bmdma_start) (struct ata_queued_cmd *qc);
