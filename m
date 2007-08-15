Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbXHOJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbXHOJpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXHOJo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:44:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39553 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbXHOJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:44:57 -0400
Date: Wed, 15 Aug 2007 05:44:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070815094456.GA17804@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c     |    9 ++++++++-
 drivers/ata/libata-core.c  |    2 +-
 drivers/ata/pata_artop.c   |   19 ++++++++++++++-----
 drivers/ata/pata_hpt37x.c  |   20 +++++++++-----------
 drivers/ata/pata_hpt3x2n.c |    8 +++++---
 drivers/ata/pata_isapnp.c  |    2 ++
 drivers/ata/sata_mv.c      |    3 +++
 7 files changed, 42 insertions(+), 21 deletions(-)

Alan Cox (1):
      sata_mv: PCI IDs for Hightpoint RocketRaid 1740/1742

Bartlomiej Zolnierkiewicz (1):
      pata_artop: fix UDMA5 for AEC6280[R] and UDMA6 for AEC6880[R]

Jeff Garzik (1):
      [libata] pata_isapnp: replace missing module device table

Ryan Power (1):
      libata: adjust libata to ignore errors after spinup

Sergei Shtylyov (2):
      pata_hpt37x: actually clock HPT374 with 50 MHz DPLL (take 2)
      pata_hpt{37x|3x2n}: fix clock reporting (take 2)

Tejun Heo (2):
      ata_piix: update map 10b for ich8m
      ata_piix: add TECRA M7 to broken suspend list

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a78832e..071d274 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -436,7 +436,7 @@ static const struct piix_map_db ich8_map_db = {
 		/* PM   PS   SM   SS       MAP */
 		{  P0,  P2,  P1,  P3 }, /* 00b (hardwired when in AHCI) */
 		{  RV,  RV,  RV,  RV },
-		{  IDE,  IDE,  NA,  NA }, /* 10b (IDE mode) */
+		{  P0,  P2, IDE, IDE }, /* 10b (IDE mode) */
 		{  RV,  RV,  RV,  RV },
 	},
 };
@@ -901,6 +901,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M7",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M7"),
+			},
+		},
+		{
 			.ident = "Satellite U205",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 60e78be..99d4fbf 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1723,7 +1723,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 		tf.protocol = ATA_PROT_NODATA;
 		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 		err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
-		if (err_mask) {
+		if (err_mask && id[2] != 0x738c) {
 			rc = -EIO;
 			reason = "SPINUP failed";
 			goto err_out;
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index ce589d9..b5352eb 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -2,6 +2,7 @@
  *    pata_artop.c - ARTOP ATA controller driver
  *
  *	(C) 2006 Red Hat <alan@redhat.com>
+ *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based in part on drivers/ide/pci/aec62xx.c
  *	Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
@@ -28,7 +29,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.3"
+#define DRV_VERSION	"0.4.4"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -430,7 +431,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &artop6260_ops,
 	};
-	static const struct ata_port_info info_626x_fast = {
+	static const struct ata_port_info info_628x = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -438,6 +439,14 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask 	= ATA_UDMA5,
 		.port_ops	= &artop6260_ops,
 	};
+	static const struct ata_port_info info_628x_fast = {
+		.sht		= &artop_sht,
+		.flags		= ATA_FLAG_SLAVE_POSS,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask 	= ATA_UDMA6,
+		.port_ops	= &artop6260_ops,
+	};
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 
 	if (!printed_version++)
@@ -455,13 +464,13 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	else if (id->driver_data == 1)	/* 6260 */
 		ppi[0] = &info_626x;
-	else if (id->driver_data == 2)	{ /* 6260 or 6260 + fast */
+	else if (id->driver_data == 2)	{ /* 6280 or 6280 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
 		u8 reg;
 
-		ppi[0] = &info_626x;
+		ppi[0] = &info_628x;
 		if (inb(io) & 0x10)
-			ppi[0] = &info_626x_fast;
+			ppi[0] = &info_628x_fast;
 		/* Mac systems come up with some registers not set as we
 		   will need them */
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 84d9c55..c5ddd93 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -8,12 +8,10 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
  *
  * TODO
- *	PLL mode
- *	Look into engine reset on timeout errors. Should not be
- *		required.
+ *	Look into engine reset on timeout errors. Should not be	required.
  */
 
 #include <linux/kernel.h>
@@ -26,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.7"
+#define DRV_VERSION	"0.6.9"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -1092,9 +1090,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		int dpll, adjust;
 
 		/* Compute DPLL */
-		dpll = 2;
-		if (port->udma_mask & 0xE0)
-			dpll = 3;
+		dpll = (port->udma_mask & 0xC0) ? 3 : 2;
 
 		f_low = (MHz[clock_slot] * 48) / MHz[dpll];
 		f_high = f_low + 2;
@@ -1116,7 +1112,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
-			printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
+			printk(KERN_ERR "pata_hpt37x: DPLL did not stabilize!\n");
 			return -ENODEV;
 		}
 		if (dpll == 3)
@@ -1124,7 +1120,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[dpll]);
+		printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using %dMHz DPLL.\n",
+		       MHz[clock_slot], MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
@@ -1137,7 +1134,8 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			port = &info_hpt370_33;
 		if (clock_slot < 2 && port == &info_hpt370a)
 			port = &info_hpt370a_33;
-		printk(KERN_INFO "hpt37x: %s: Bus clock %dMHz.\n", chip_table->name, MHz[clock_slot]);
+		printk(KERN_INFO "pata_hpt37x: %s using %dMHz bus clock.\n",
+		       chip_table->name, MHz[clock_slot]);
 	}
 
 	/* Now kick off ATA set up */
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index aa29cde..f8f234b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
- * Portions Copyright (C) 2005-2006	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2007	MontaVista Software, Inc.
  *
  *
  * TODO
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.3"
+#define DRV_VERSION	"0.3.4"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -579,10 +579,12 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 	}
 	if (adjust == 8) {
-		printk(KERN_WARNING "hpt3x2n: DPLL did not stabilize.\n");
+		printk(KERN_ERR "pata_hpt3x2n: DPLL did not stabilize!\n");
 		return -ENODEV;
 	}
 
+	printk(KERN_INFO "pata_hpt37x: bus clock %dMHz, using 66MHz DPLL.\n",
+	       pci_mhz);
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
 	port.private_data = NULL;
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 5525518..91a396f 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -139,6 +139,8 @@ static struct pnp_device_id isapnp_devices[] = {
 	{.id = ""}
 };
 
+MODULE_DEVICE_TABLE(pnp, isapnp_devices);
+
 static struct pnp_driver isapnp_driver = {
 	.name		= DRV_NAME,
 	.id_table	= isapnp_devices,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 8ec5208..3acf65e 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -621,6 +621,9 @@ static const struct pci_device_id mv_pci_tbl[] = {
 	{ PCI_VDEVICE(MARVELL, 0x5041), chip_504x },
 	{ PCI_VDEVICE(MARVELL, 0x5080), chip_5080 },
 	{ PCI_VDEVICE(MARVELL, 0x5081), chip_508x },
+	/* RocketRAID 1740/174x have different identifiers */
+	{ PCI_VDEVICE(TTI, 0x1740), chip_508x },
+	{ PCI_VDEVICE(TTI, 0x1742), chip_508x },
 
 	{ PCI_VDEVICE(MARVELL, 0x6040), chip_604x },
 	{ PCI_VDEVICE(MARVELL, 0x6041), chip_604x },
