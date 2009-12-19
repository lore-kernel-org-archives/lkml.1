Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZLSSNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZLSSNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 13:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZLSSNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 13:13:53 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58474 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZLSSNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 13:13:51 -0500
Date: Sat, 19 Dec 2009 13:13:50 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20091219181350.GA21058@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Various fixes, and sata_mv suspend/resume support.



Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c    |    2 +-
 drivers/ata/libata-sff.c     |    2 +-
 drivers/ata/pata_hpt3x2n.c   |   64 ++++++++++---------
 drivers/ata/pata_octeon_cf.c |    2 +-
 drivers/ata/sata_mv.c        |  144 ++++++++++++++++++++++++++++++++++++------
 5 files changed, 163 insertions(+), 51 deletions(-)
 mode change 100644 => 100755 drivers/ata/sata_mv.c

Christoph Hellwig (1):
      libata: use the WRITE_SAME_16 define

H Hartley Sweeten (1):
      pata_octeon_cf: use resource_size(), to fix resource sizing bug

Jeff Garzik (1):
      sata_mv: remove pointless NULL test

Robert Hancock (1):
      libata: fix reporting of drained bytes when clearing DRQ

Saeed Bishara (6):
      sata_mv: increase PIO IORDY timeout
      sata_mv: support clkdev framework
      sata_mv: add power management support for the platform driver
      sata_mv: move the PCI bar description initialization code
      sata_mv: store the board_idx into the host private data
      sata_mv: add power management support for the PCI controllers.

Sergei Shtylyov (1):
      pata_hpt3x2n: fix clock turnaround

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1683ebd..f4ea5a8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3022,7 +3022,7 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case WRITE_16:
 		return ata_scsi_rw_xlat;
 
-	case 0x93 /*WRITE_SAME_16*/:
+	case WRITE_SAME_16:
 		return ata_scsi_write_same_xlat;
 
 	case SYNCHRONIZE_CACHE:
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index efa8773..741065c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2275,7 +2275,7 @@ void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
 	ap = qc->ap;
 	/* Drain up to 64K of data before we give up this recovery method */
 	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
-						&& count < 32768; count++)
+						&& count < 65536; count += 2)
 		ioread16(ap->ioaddr.data_addr);
 
 	/* Can become DEBUG later */
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 9a09a1b..dd26bc7 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
  *
  * TODO
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.7"
+#define DRV_VERSION	"0.3.8"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -264,7 +264,7 @@ static void hpt3x2n_bmdma_stop(struct ata_queued_cmd *qc)
 
 static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 {
-	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+	void __iomem *bmdma = ap->ioaddr.bmdma_addr - ap->port_no * 8;
 
 	/* Tristate the bus */
 	iowrite8(0x80, bmdma+0x73);
@@ -274,9 +274,9 @@ static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 	iowrite8(source, bmdma+0x7B);
 	iowrite8(0xC0, bmdma+0x79);
 
-	/* Reset state machines */
-	iowrite8(0x37, bmdma+0x70);
-	iowrite8(0x37, bmdma+0x74);
+	/* Reset state machines, avoid enabling the disabled channels */
+	iowrite8(ioread8(bmdma+0x70) | 0x32, bmdma+0x70);
+	iowrite8(ioread8(bmdma+0x74) | 0x32, bmdma+0x74);
 
 	/* Complete reset */
 	iowrite8(0x00, bmdma+0x79);
@@ -286,21 +286,10 @@ static void hpt3x2n_set_clock(struct ata_port *ap, int source)
 	iowrite8(0x00, bmdma+0x77);
 }
 
-/* Check if our partner interface is busy */
-
-static int hpt3x2n_pair_idle(struct ata_port *ap)
-{
-	struct ata_host *host = ap->host;
-	struct ata_port *pair = host->ports[ap->port_no ^ 1];
-
-	if (pair->hsm_task_state == HSM_ST_IDLE)
-		return 1;
-	return 0;
-}
-
 static int hpt3x2n_use_dpll(struct ata_port *ap, int writing)
 {
 	long flags = (long)ap->host->private_data;
+
 	/* See if we should use the DPLL */
 	if (writing)
 		return USE_DPLL;	/* Needed for write */
@@ -309,20 +298,35 @@ static int hpt3x2n_use_dpll(struct ata_port *ap, int writing)
 	return 0;
 }
 
+static int hpt3x2n_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_port *alt = ap->host->ports[ap->port_no ^ 1];
+	int rc, flags = (long)ap->host->private_data;
+	int dpll = hpt3x2n_use_dpll(ap, qc->tf.flags & ATA_TFLAG_WRITE);
+
+	/* First apply the usual rules */
+	rc = ata_std_qc_defer(qc);
+	if (rc != 0)
+		return rc;
+
+	if ((flags & USE_DPLL) != dpll && alt->qc_active)
+		return ATA_DEFER_PORT;
+	return 0;
+}
+
 static unsigned int hpt3x2n_qc_issue(struct ata_queued_cmd *qc)
 {
-	struct ata_taskfile *tf = &qc->tf;
 	struct ata_port *ap = qc->ap;
 	int flags = (long)ap->host->private_data;
+	int dpll = hpt3x2n_use_dpll(ap, qc->tf.flags & ATA_TFLAG_WRITE);
 
-	if (hpt3x2n_pair_idle(ap)) {
-		int dpll = hpt3x2n_use_dpll(ap, (tf->flags & ATA_TFLAG_WRITE));
-		if ((flags & USE_DPLL) != dpll) {
-			if (dpll == 1)
-				hpt3x2n_set_clock(ap, 0x21);
-			else
-				hpt3x2n_set_clock(ap, 0x23);
-		}
+	if ((flags & USE_DPLL) != dpll) {
+		flags &= ~USE_DPLL;
+		flags |= dpll;
+		ap->host->private_data = (void *)(long)flags;
+
+		hpt3x2n_set_clock(ap, dpll ? 0x21 : 0x23);
 	}
 	return ata_sff_qc_issue(qc);
 }
@@ -339,6 +343,8 @@ static struct ata_port_operations hpt3x2n_port_ops = {
 	.inherits	= &ata_bmdma_port_ops,
 
 	.bmdma_stop	= hpt3x2n_bmdma_stop,
+
+	.qc_defer	= hpt3x2n_qc_defer,
 	.qc_issue	= hpt3x2n_qc_issue,
 
 	.cable_detect	= hpt3x2n_cable_detect,
@@ -454,7 +460,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	unsigned int f_low, f_high;
 	int adjust;
 	unsigned long iobase = pci_resource_start(dev, 4);
-	void *hpriv = NULL;
+	void *hpriv = (void *)USE_DPLL;
 	int rc;
 
 	rc = pcim_enable_device(dev);
@@ -539,7 +545,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
 	if (pci_mhz > 60) {
-		hpriv = (void *)PCI66;
+		hpriv = (void *)(PCI66 | USE_DPLL);
 		/*
 		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
 		 * the MISC. register to stretch the UltraDMA Tss timing.
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index d6f6956..37ef416 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -853,7 +853,7 @@ static int __devinit octeon_cf_probe(struct platform_device *pdev)
 			return -EINVAL;
 
 		cs1 = devm_ioremap_nocache(&pdev->dev, res_cs1->start,
-					   res_cs0->end - res_cs1->start + 1);
+					   resource_size(res_cs1));
 
 		if (!cs1)
 			return -ENOMEM;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
old mode 100644
new mode 100755
index a8a7be0..df8ee32
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -59,6 +59,7 @@
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <linux/device.h>
+#include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/ata_platform.h>
 #include <linux/mbus.h>
@@ -538,6 +539,7 @@ struct mv_port_signal {
 
 struct mv_host_priv {
 	u32			hp_flags;
+	unsigned int 		board_idx;
 	u32			main_irq_mask;
 	struct mv_port_signal	signal[8];
 	const struct mv_hw_ops	*ops;
@@ -548,6 +550,10 @@ struct mv_host_priv {
 	u32			irq_cause_offset;
 	u32			irq_mask_offset;
 	u32			unmask_all_irqs;
+
+#if defined(CONFIG_HAVE_CLK)
+	struct clk		*clk;
+#endif
 	/*
 	 * These consistent DMA memory pools give us guaranteed
 	 * alignment for hardware-accessed data structures,
@@ -2775,7 +2781,7 @@ static void mv_port_intr(struct ata_port *ap, u32 port_cause)
 	struct mv_port_priv *pp;
 	int edma_was_enabled;
 
-	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
+	if (ap->flags & ATA_FLAG_DISABLED) {
 		mv_unexpected_intr(ap, 0);
 		return;
 	}
@@ -3393,7 +3399,7 @@ static void mv_soc_reset_hc_port(struct mv_host_priv *hpriv,
 	ZERO(0x024);		/* respq outp */
 	ZERO(0x020);		/* respq inp */
 	ZERO(0x02c);		/* test control */
-	writel(0xbc, port_mmio + EDMA_IORDY_TMOUT);
+	writel(0x800, port_mmio + EDMA_IORDY_TMOUT);
 }
 
 #undef ZERO
@@ -3854,7 +3860,6 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
 /**
  *      mv_init_host - Perform some early initialization of the host.
  *	@host: ATA host to initialize
- *      @board_idx: controller index
  *
  *      If possible, do an early global reset of the host.  Then do
  *      our port init and clear/unmask all/relevant host interrupts.
@@ -3862,13 +3867,13 @@ static int mv_chip_id(struct ata_host *host, unsigned int board_idx)
  *      LOCKING:
  *      Inherited from caller.
  */
-static int mv_init_host(struct ata_host *host, unsigned int board_idx)
+static int mv_init_host(struct ata_host *host)
 {
 	int rc = 0, n_hc, port, hc;
 	struct mv_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->base;
 
-	rc = mv_chip_id(host, board_idx);
+	rc = mv_chip_id(host, hpriv->board_idx);
 	if (rc)
 		goto done;
 
@@ -3905,14 +3910,6 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		void __iomem *port_mmio = mv_port_base(mmio, port);
 
 		mv_port_init(&ap->ioaddr, port_mmio);
-
-#ifdef CONFIG_PCI
-		if (!IS_SOC(hpriv)) {
-			unsigned int offset = port_mmio - mmio;
-			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
-			ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
-		}
-#endif
 	}
 
 	for (hc = 0; hc < n_hc; hc++) {
@@ -4035,12 +4032,21 @@ static int mv_platform_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	host->private_data = hpriv;
 	hpriv->n_ports = n_ports;
+	hpriv->board_idx = chip_soc;
 
 	host->iomap = NULL;
 	hpriv->base = devm_ioremap(&pdev->dev, res->start,
 				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
+#if defined(CONFIG_HAVE_CLK)
+	hpriv->clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(hpriv->clk))
+		dev_notice(&pdev->dev, "cannot get clkdev\n");
+	else
+		clk_enable(hpriv->clk);
+#endif
+
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
 	 */
@@ -4049,12 +4055,12 @@ static int mv_platform_probe(struct platform_device *pdev)
 
 	rc = mv_create_dma_pools(hpriv, &pdev->dev);
 	if (rc)
-		return rc;
+		goto err;
 
 	/* initialize adapter */
-	rc = mv_init_host(host, chip_soc);
+	rc = mv_init_host(host);
 	if (rc)
-		return rc;
+		goto err;
 
 	dev_printk(KERN_INFO, &pdev->dev,
 		   "slots %u ports %d\n", (unsigned)MV_MAX_Q_DEPTH,
@@ -4062,6 +4068,15 @@ static int mv_platform_probe(struct platform_device *pdev)
 
 	return ata_host_activate(host, platform_get_irq(pdev, 0), mv_interrupt,
 				 IRQF_SHARED, &mv6_sht);
+err:
+#if defined(CONFIG_HAVE_CLK)
+	if (!IS_ERR(hpriv->clk)) {
+		clk_disable(hpriv->clk);
+		clk_put(hpriv->clk);
+	}
+#endif
+
+	return rc;
 }
 
 /*
@@ -4076,14 +4091,66 @@ static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_host *host = dev_get_drvdata(dev);
-
+#if defined(CONFIG_HAVE_CLK)
+	struct mv_host_priv *hpriv = host->private_data;
+#endif
 	ata_host_detach(host);
+
+#if defined(CONFIG_HAVE_CLK)
+	if (!IS_ERR(hpriv->clk)) {
+		clk_disable(hpriv->clk);
+		clk_put(hpriv->clk);
+	}
+#endif
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int mv_platform_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	if (host)
+		return ata_host_suspend(host, state);
+	else
+		return 0;
+}
+
+static int mv_platform_resume(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int ret;
+
+	if (host) {
+		struct mv_host_priv *hpriv = host->private_data;
+		const struct mv_sata_platform_data *mv_platform_data = \
+			pdev->dev.platform_data;
+		/*
+		 * (Re-)program MBUS remapping windows if we are asked to.
+		 */
+		if (mv_platform_data->dram != NULL)
+			mv_conf_mbus_windows(hpriv, mv_platform_data->dram);
+
+		/* initialize adapter */
+		ret = mv_init_host(host);
+		if (ret) {
+			printk(KERN_ERR DRV_NAME ": Error during HW init\n");
+			return ret;
+		}
+		ata_host_resume(host);
+	}
+
+	return 0;
+}
+#else
+#define mv_platform_suspend NULL
+#define mv_platform_resume NULL
+#endif
+
 static struct platform_driver mv_platform_driver = {
 	.probe			= mv_platform_probe,
 	.remove			= __devexit_p(mv_platform_remove),
+	.suspend		= mv_platform_suspend,
+	.resume			= mv_platform_resume,
 	.driver			= {
 				   .name = DRV_NAME,
 				   .owner = THIS_MODULE,
@@ -4094,6 +4161,9 @@ static struct platform_driver mv_platform_driver = {
 #ifdef CONFIG_PCI
 static int mv_pci_init_one(struct pci_dev *pdev,
 			   const struct pci_device_id *ent);
+#ifdef CONFIG_PM
+static int mv_pci_device_resume(struct pci_dev *pdev);
+#endif
 
 
 static struct pci_driver mv_pci_driver = {
@@ -4101,6 +4171,11 @@ static struct pci_driver mv_pci_driver = {
 	.id_table		= mv_pci_tbl,
 	.probe			= mv_pci_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= mv_pci_device_resume,
+#endif
+
 };
 
 /* move to PCI layer or libata core? */
@@ -4194,7 +4269,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 	const struct ata_port_info *ppi[] = { &mv_port_info[board_idx], NULL };
 	struct ata_host *host;
 	struct mv_host_priv *hpriv;
-	int n_ports, rc;
+	int n_ports, port, rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_INFO, &pdev->dev, "version " DRV_VERSION "\n");
@@ -4208,6 +4283,7 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 		return -ENOMEM;
 	host->private_data = hpriv;
 	hpriv->n_ports = n_ports;
+	hpriv->board_idx = board_idx;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
@@ -4230,8 +4306,17 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		return rc;
 
+	for (port = 0; port < host->n_ports; port++) {
+		struct ata_port *ap = host->ports[port];
+		void __iomem *port_mmio = mv_port_base(hpriv->base, port);
+		unsigned int offset = port_mmio - hpriv->base;
+
+		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, -1, "mmio");
+		ata_port_pbar_desc(ap, MV_PRIMARY_BAR, offset, "port");
+	}
+
 	/* initialize adapter */
-	rc = mv_init_host(host, board_idx);
+	rc = mv_init_host(host);
 	if (rc)
 		return rc;
 
@@ -4247,6 +4332,27 @@ static int mv_pci_init_one(struct pci_dev *pdev,
 	return ata_host_activate(host, pdev->irq, mv_interrupt, IRQF_SHARED,
 				 IS_GEN_I(hpriv) ? &mv5_sht : &mv6_sht);
 }
+
+#ifdef CONFIG_PM
+static int mv_pci_device_resume(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	/* initialize adapter */
+	rc = mv_init_host(host);
+	if (rc)
+		return rc;
+
+	ata_host_resume(host);
+
+	return 0;
+}
+#endif
 #endif
 
 static int mv_platform_probe(struct platform_device *pdev);
