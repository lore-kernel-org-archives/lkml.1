Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbXGISvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbXGISvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 14:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbXGISvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 14:51:31 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52701 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759872AbXGISv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 14:51:29 -0400
Date: Mon, 9 Jul 2007 14:51:28 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] libata: AHCI: Add support for Marvell AHCI-like chips (initially 6145)
Message-ID: <20070709185128.GA22071@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit cd70c26617f4686355263be4533ce8030242740e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Jul 8 02:29:42 2007 -0400

    [libata] AHCI: Add support for Marvell AHCI-like chips (initially 6145)
    
    Add support for the SATA portion of Marvell's AHCI-compatible chips.
    The PATA port capability, also available via AHCI, is disabled until
    support is completed.
    
    NCQ and PCI MSI are disabled by default.  Marvell says "we use NCQ" in
    their drivers but "we do not use PCI MSI."  Theoretically that implies
    we need to fix ahci.c to work with Marvell NCQ, but one wonders why
    Marvell NCQ is any different from other AHCI chips.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

cd70c26617f4686355263be4533ce8030242740e
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f66e2a5..11e4eb9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
-#define DRV_VERSION	"2.2"
+#define DRV_VERSION	"2.3"
 
 
 enum {
@@ -81,6 +81,7 @@ enum {
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
 	board_ahci_sb600	= 4,
+	board_ahci_mv		= 5,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -171,6 +172,8 @@ enum {
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
+	AHCI_FLAG_MV_PATA		= (1 << 29), /* PATA port */
+	AHCI_FLAG_NO_MSI		= (1 << 30), /* no PCI MSI */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -364,6 +367,18 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_mv */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY | AHCI_FLAG_HONOR_PI |
+				  AHCI_FLAG_NO_NCQ | AHCI_FLAG_NO_MSI |
+				  AHCI_FLAG_MV_PATA,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -459,6 +474,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
 
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -544,6 +562,20 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
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
@@ -856,12 +888,25 @@ static void ahci_init_controller(struct ata_host *host)
 	struct pci_dev *pdev = to_pci_dev(host->dev);
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	int i;
+	void __iomem *port_mmio;
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
 
+		port_mmio = ahci_port_base(ap);
 		if (ata_port_is_dummy(ap))
 			continue;
 
@@ -1738,7 +1783,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	if (pci_enable_msi(pdev))
+	if ((pi.flags & AHCI_FLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
