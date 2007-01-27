Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbXA0Dk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbXA0Dk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 22:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXA0Dk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 22:40:26 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33560 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbXA0DkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 22:40:24 -0500
Date: Fri, 26 Jan 2007 22:40:23 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] ahci: Marvell 6145 SATA support (preliminary)
Message-ID: <20070127034023.GA25959@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The bulk of this patch is largely paranoia-based changes, that turn off
various PATA-related bits.

The SATA portion of this patch is verified working....... if I disable
CONFIG_PCI_MSI and CONFIG_PCI_MMCONFIG.  If those are not disabled, then
my ICH9 test box dies in an interrupt storm.  Booting with acpi=off does
not prevent this interrupt storm.

Were it not for the PATA and interrupt storm bits, I would say that
Marvell 6145 works with a simple PCI ID addition.

 drivers/ata/ahci.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e3c7b31..abe6ea4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -81,6 +81,7 @@ enum {
 	board_ahci_pi		= 1,
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
+	board_ahci_mv		= 4,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -172,6 +173,7 @@ enum {
 	AHCI_FLAG_NO_NCQ		= (1 << 24),
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
+	AHCI_FLAG_MV_PATA		= (1 << 27), /* port 4 == PATA */
 };
 
 struct ahci_cmd_hdr {
@@ -352,6 +354,17 @@ static const struct ata_port_info ahci_port_info[] = {
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
@@ -424,6 +437,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci }, /* SiS 966 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci }, /* SiS 968 */
 
+	/* Marvell */
+	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  0x010601, 0xffffff, board_ahci },
@@ -690,13 +706,27 @@ static void ahci_init_controller(void __iomem *mmio, struct pci_dev *pdev,
 				 int n_ports, unsigned int port_flags,
 				 struct ahci_host_priv *hpriv)
 {
+	void __iomem *port_mmio;
 	int i, rc;
 	u32 tmp;
 
+	if (port_flags & AHCI_FLAG_MV_PATA) {
+		port_mmio = ahci_port_base(mmio, 4);
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
 	for (i = 0; i < n_ports; i++) {
-		void __iomem *port_mmio = ahci_port_base(mmio, i);
 		const char *emsg = NULL;
 
+		port_mmio = ahci_port_base(mmio, i);
+
 		if ((port_flags & AHCI_FLAG_HONOR_PI) &&
 		    !(hpriv->port_map & (1 << i)))
 			continue;
@@ -712,6 +742,9 @@ static void ahci_init_controller(void __iomem *mmio, struct pci_dev *pdev,
 		VPRINTK("PORT_SCR_ERR 0x%x\n", tmp);
 		writel(tmp, port_mmio + PORT_SCR_ERR);
 
+		/* select the IRQ events we're interested in */
+		writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+
 		/* clear port IRQ */
 		tmp = readl(port_mmio + PORT_IRQ_STAT);
 		VPRINTK("PORT_IRQ_STAT 0x%x\n", tmp);
@@ -1489,6 +1522,24 @@ static int ahci_host_init(struct ata_probe_ent *probe_ent)
 	hpriv->port_map = readl(mmio + HOST_PORTS_IMPL);
 	cap_n_ports = ahci_nr_ports(hpriv->cap);
 
+	/*
+	 * Temporary Marvell 6145 hack: PATA port presence
+	 * is asserted through the standard AHCI port
+	 * presence register, as bit 4 (counting from 0)
+	 */
+	if (probe_ent->port_flags & AHCI_FLAG_MV_PATA) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "MV_AHCI HACK: port_map %x -> %x, cap_n %u -> %u\n",
+			   hpriv->port_map,
+			   hpriv->port_map & 0xf,
+			   cap_n_ports,
+			   (cap_n_ports > 4) ? 4 : cap_n_ports);
+
+		hpriv->port_map &= 0xf;
+		if (cap_n_ports > 4)
+			cap_n_ports = 4;
+	}
+
 	VPRINTK("cap 0x%x  port_map 0x%x  n_ports %d\n",
 		hpriv->cap, hpriv->port_map, cap_n_ports);
 
