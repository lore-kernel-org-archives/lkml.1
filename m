Return-Path: <linux-kernel-owner+w=401wt.eu-S1763675AbXESFra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763675AbXESFra (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXESFrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:47:08 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39407 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXESFrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:47:06 -0400
Date: Sat, 19 May 2007 01:47:04 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ahci: add Marvell support (WIP)
Message-ID: <20070519054704.GA352@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is the work-in-progress for supporting the newer Marvell PATA/SATA
chips like the 6145.

SATA support works, but PATA support is not implemented at all.
There is some temporary code that makes sure the PATA port is disabled,
if enabled.

This can be found in the 'mv-ahci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

    [libata] ahci: Marvell code build fix
    [libata] AHCI: get Marvell SATA going (PATA portion of chip not supported)
    
 drivers/ata/ahci.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e00e1b9..d2d15b2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum {
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
 	board_ahci_sb600	= 4,
+	board_ahci_mv		= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -170,6 +171,7 @@ enum {
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
+	AHCI_FLAG_MV_PATA		= (1 << 28), /* PATA port */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -359,6 +361,17 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_mv */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY | AHCI_FLAG_HONOR_PI |
+				  AHCI_FLAG_MV_PATA,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -430,6 +443,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
 
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -455,11 +471,17 @@ static inline int ahci_nr_ports(u32 cap)
 	return (cap & 0x1f) + 1;
 }
 
-static inline void __iomem *ahci_port_base(struct ata_port *ap)
+static inline void __iomem *__ahci_port_base(struct ata_host *host,
+					     unsigned int port_no)
 {
-	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
+	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 
-	return mmio + 0x100 + (ap->port_no * 0x80);
+	return mmio + 0x100 + (port_no * 0x80);
+}
+
+static inline void __iomem *ahci_port_base(struct ata_port *ap)
+{
+	return __ahci_port_base(ap->host, ap->port_no);
 }
 
 /**
@@ -502,6 +524,20 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 		hpriv->saved_port_map = port_map;
 	}
 
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (pi->flags & AHCI_FLAG_MV_PATA) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "MV_AHCI HACK: port_map %x -> %x\n",
+			   hpriv->port_map,
+			   hpriv->port_map & 0xf);
+
+		port_map &= 0xf;
+	}
+
 	/* cross check port_map and cap.n_ports */
 	if (pi->flags & AHCI_FLAG_HONOR_PI) {
 		u32 tmp_port_map = port_map;
@@ -785,14 +821,27 @@ static void ahci_init_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
+	void __iomem *port_mmio;
 	int i, rc;
 	u32 tmp;
 
+	if (host->ports[0]->flags & AHCI_FLAG_MV_PATA) {
+		port_mmio = __ahci_port_base(host, 4);
+
+		writel(0, port_mmio + PORT_IRQ_MASK);
+
+		/* clear port IRQ */
+		tmp = readl(port_mmio + PORT_IRQ_STAT);
+		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
+		if (tmp)
+			writel(tmp, port_mmio + PORT_IRQ_STAT);
+	}
+
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
-		void __iomem *port_mmio = ahci_port_base(ap);
 		const char *emsg = NULL;
 
+		port_mmio = ahci_port_base(ap);
 		if (ata_port_is_dummy(ap))
 			continue;
 
@@ -807,6 +856,9 @@ static void ahci_init_controller(struct ata_host *host)
 		VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
 		writel(tmp, port_mmio + PORT_SCR_ERR);
 
+		/* select the IRQ events we're interested in */
+		writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+
 		/* clear port IRQ */
 		tmp = readl(port_mmio + PORT_IRQ_STAT);
 		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
