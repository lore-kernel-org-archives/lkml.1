Return-Path: <linux-kernel-owner+w=401wt.eu-S1754477AbZKQPI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbZKQPI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbZKQPIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:08:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40524 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754366AbZKQPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:08:20 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] pata_piccolo: Driver for old Toshiba chipsets
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:52:12 +0000
Message-ID: <20091117145144.15430.55784.stgit@localhost.localdomain>
In-Reply-To: <20091117144450.15430.83450.stgit@localhost.localdomain>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were never able to get docs for this out of Toshiba for years. Dave
Barnes produced a NetBSD driver however and from that we can fill in the
needed tables

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/Kconfig        |   25 +++++---
 drivers/ata/Makefile       |    1 
 drivers/ata/ata_generic.c  |    5 +-
 drivers/ata/pata_piccolo.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h    |    7 +-
 5 files changed, 166 insertions(+), 12 deletions(-)
 create mode 100644 drivers/ata/pata_piccolo.c


diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 36931e0..acca6b6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -667,6 +667,15 @@ config PATA_SIS
 
 	  If unsure, say N.
 
+config PATA_TOSHIBA
+	tristate "Toshiba Piccolo support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  Support for the Toshiba Piccolo controllers. Currently only the
+	  primary channel is supported by this driver.
+
+	  If unsure, say N.
+
 config PATA_VIA
 	tristate "VIA PATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 01e126f..d909435 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
 obj-$(CONFIG_PATA_SIL680)	+= pata_sil680.o
+obj-$(CONFIG_PATA_TOSHIBA)	+= pata_piccolo.o
 obj-$(CONFIG_PATA_VIA)		+= pata_via.o
 obj-$(CONFIG_PATA_WINBOND)	+= pata_sl82c105.o
 obj-$(CONFIG_PATA_WINBOND_VLB)	+= pata_winbond.o
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index ecfd22b..5daf507 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -168,9 +168,12 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
+#if !defined(CONFIG_PATA_TOSHIBA) && !defined(CONFIG_PATA_TOSHIBA_MODULE)
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
-	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
+#endif	
 	/* Must come last. If you add entries adjust this table appropriately */
 	{ PCI_ANY_ID,		PCI_ANY_ID,			   PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_STORAGE_IDE << 8, 0xFFFFFF00UL, 1},
 	{ 0, },
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
new file mode 100644
index 0000000..1157da8
--- /dev/null
+++ b/drivers/ata/pata_piccolo.c
@@ -0,0 +1,140 @@
+/*
+ *  pata_piccolo.c - Toshiba Piccolo PATA/SATA controller driver.
+ *
+ *  This is basically an update to ata_generic.c to add Toshiba Piccolo support
+ *  then split out to keep ata_generic "clean".
+ *
+ *  Copyright 2005 Red Hat Inc, all rights reserved.
+ *
+ *  Elements from ide/pci/generic.c
+ *	    Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
+ *	    Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
+ *
+ *  May be copied or modified under the terms of the GNU General Public License
+ *
+ *  The timing data tables/programming info are courtesy of the NetBSD driver
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+
+#define DRV_NAME "pata_piccolo"
+#define DRV_VERSION "0.0.1"
+
+
+
+static void tosh_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static const u16 pio[6] = {	/* For reg 0x50 low word & E088 */
+		0x0566, 0x0433, 0x0311, 0x0201, 0x0200, 0x0100
+	};
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u16 conf;
+	pci_read_config_word(pdev, 0x50, &conf);
+	conf &= 0xE088;
+	conf |= pio[adev->pio_mode - XFER_PIO_0];
+	pci_write_config_word(pdev, 0x50, conf);
+}
+
+static void tosh_set_dmamode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 conf;
+	pci_read_config_dword(pdev, 0x5C, &conf);
+	conf &= 0x78FFE088;	/* Keep the other bits */
+	if (adev->dma_mode >= XFER_UDMA_0) {
+		int udma = adev->dma_mode - XFER_UDMA_0;
+		conf |= 0x80000000;
+		conf |= (udma + 2) << 28;
+		conf |= (2 - udma) * 0x111;	/* spread into three nibbles */
+	} else {
+		static const u32 mwdma[4] = {
+			0x0655, 0x0200, 0x0200, 0x0100
+		};
+		conf |= mwdma[adev->dma_mode - XFER_MW_DMA_0];
+	}
+	pci_write_config_dword(pdev, 0x5C, conf);
+}
+
+
+static struct scsi_host_template tosh_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations tosh_port_ops = {
+	.inherits	= &ata_bmdma_port_ops,
+	.cable_detect	= ata_cable_unknown,
+	.set_piomode	= tosh_set_piomode,
+	.set_dmamode	= tosh_set_dmamode
+};
+
+/**
+ *	ata_tosh_init		-	attach generic IDE
+ *	@dev: PCI device found
+ *	@id: match entry
+ *
+ *	Called each time a matching IDE interface is found. We check if the
+ *	interface is one we wish to claim and if so we perform any chip
+ *	specific hacks then let the ATA layer do the heavy lifting.
+ */
+
+static int ata_tosh_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	static const struct ata_port_info info = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = ATA_PIO5,
+		.mwdma_mask = ATA_MWDMA2,
+		.udma_mask = ATA_UDMA2,
+		.port_ops = &tosh_port_ops
+	};
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+	/* Just one port for the moment */
+	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL);
+}
+
+static struct pci_device_id ata_tosh[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
+	{ 0, },
+};
+
+static struct pci_driver ata_tosh_pci_driver = {
+	.name 		= DRV_NAME,
+	.id_table	= ata_tosh,
+	.probe 		= ata_tosh_init_one,
+	.remove		= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend	= ata_pci_device_suspend,
+	.resume		= ata_pci_device_resume,
+#endif
+};
+
+static int __init ata_tosh_init(void)
+{
+	return pci_register_driver(&ata_tosh_pci_driver);
+}
+
+
+static void __exit ata_tosh_exit(void)
+{
+	pci_unregister_driver(&ata_tosh_pci_driver);
+}
+
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("Low level driver for Toshiba Piccolo ATA");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, ata_tosh);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(ata_tosh_init);
+module_exit(ata_tosh_exit);
+
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index d201220..bc449e5 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1496,9 +1496,10 @@
 #define PCI_DEVICE_ID_SBE_WANXL400	0x0104
 
 #define PCI_VENDOR_ID_TOSHIBA		0x1179
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0102
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_1	0x0103
-#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0105
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0101
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0102
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_3	0x0103
+#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_5	0x0105
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC95	0x060a
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC97	0x060f
 #define PCI_DEVICE_ID_TOSHIBA_TOPIC100	0x0617

