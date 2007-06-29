Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbXF2SL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbXF2SL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933243AbXF2SLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:11:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40939 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932753AbXF2SLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:11:08 -0400
Date: Fri, 29 Jun 2007 19:17:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-ide@vger.kernel.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pata_hpt3x3: support this chip properly including
 alternative BAR layout
Message-ID: <20070629191703.5d9cf602@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases we cannot use BAR0-BAR3 on this chip due to errata. The
relevant interfaces are available via BAR4 and we set the chip up to use
those instead.

This plus testing means it can move from experimental to production spec

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6/drivers/ata/Kconfig linux-2.6.22-rc6/drivers/ata/Kconfig
--- linux.vanilla-2.6.22-rc6/drivers/ata/Kconfig	2007-06-25 00:21:48.000000000 +0100
+++ linux-2.6.22-rc6/drivers/ata/Kconfig	2007-06-29 15:20:26.000000000 +0100
@@ -304,7 +304,7 @@
 	  If unsure, say N.
 
 config PATA_HPT3X3
-	tristate "HPT 343/363 PATA support (Experimental)"
+	tristate "HPT 343/363 PATA support"
 	depends on PCI
 	help
 	  This option enables support for the HPT 343/363
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc6/drivers/ata/pata_hpt3x3.c linux-2.6.22-rc6/drivers/ata/pata_hpt3x3.c
--- linux.vanilla-2.6.22-rc6/drivers/ata/pata_hpt3x3.c	2007-06-25 00:21:48.000000000 +0100
+++ linux-2.6.22-rc6/drivers/ata/pata_hpt3x3.c	2007-06-29 16:41:14.000000000 +0100
@@ -158,19 +158,18 @@
 		pci_write_config_byte(dev, PCI_LATENCY_TIMER, 0x20);
 }
 
-
 /**
  *	hpt3x3_init_one		-	Initialise an HPT343/363
  *	@dev: PCI device
  *	@id: Entry in match table
  *
- *	Perform basic initialisation. The chip has a quirk that it won't
- *	function unless it is at XX00. The old ATA driver touched this up
- *	but we leave it for pci quirks to do properly.
+ *	Perform basic initialisation. We set the device up so we access all
+ *	ports via BAR4. This is neccessary to work around errata.
  */
 
-static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	static int printed_version;
 	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
@@ -179,11 +178,57 @@
 		.udma_mask = 0x07,
 		.port_ops = &hpt3x3_port_ops
 	};
+	/* Register offsets of taskfiles in BAR4 area */
+	static const u8 offset_cmd[2] = { 0x20, 0x28 };
+	static const u8 offset_ctl[2] = { 0x34, 0x3C };
 	const struct ata_port_info *ppi[] = { &info, NULL };
-
-	hpt3x3_init_chipset(dev);
-	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, ppi);
+	struct ata_host *host;
+	int i, rc;
+	void __iomem *base;
+	
+	hpt3x3_init_chipset(pdev);
+
+	if (!printed_version++)
+		dev_printk(KERN_DEBUG, &pdev->dev, "version " DRV_VERSION "\n");
+
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
+	if (!host)
+		return -ENOMEM;
+
+	/* acquire resources and fill host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* Everything is relative to BAR4 if we set up this way */
+	rc = pcim_iomap_regions(pdev, 1 << 4, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+	host->iomap = pcim_iomap_table(pdev);
+	rc = pci_set_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(pdev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+
+	base = host->iomap[4];	/* Bus mastering base */
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_ioports *ioaddr = &host->ports[i]->ioaddr;
+
+		ioaddr->cmd_addr = base + offset_cmd[i];
+		ioaddr->altstatus_addr =
+		ioaddr->ctl_addr = base + offset_ctl[i];
+		ioaddr->bmdma_addr = base;
+		ioaddr->scr_addr = NULL;
+		ata_std_ports(ioaddr);
+	}
+	pci_set_master(pdev);
+	return ata_host_activate(host, pdev->irq, ata_interrupt, IRQF_SHARED,
+				 &hpt3x3_sht);
 }
 
 #ifdef CONFIG_PM
