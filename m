Return-Path: <linux-kernel-owner+w=401wt.eu-S936027AbZAPP1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027AbZAPP1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbZAPP12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:27:28 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33031 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536AbZAPP1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:27:24 -0500
Date: Fri, 16 Jan 2009 10:27:21 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20090116152721.GA6994@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And a new, oft-reposted, finally ready cfl driver.

The ioctl fix is notable, an ugly bug.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig                 |    9 +
 drivers/ata/Makefile                |    1 +
 drivers/ata/libata-core.c           |   73 ++--
 drivers/ata/libata-scsi.c           |   17 +-
 drivers/ata/pata_ali.c              |   28 +-
 drivers/ata/pata_atiixp.c           |   32 +-
 drivers/ata/pata_octeon_cf.c        |  965 +++++++++++++++++++++++++++++++++++
 drivers/ata/sata_fsl.c              |    2 +-
 drivers/ata/sata_via.c              |    2 +
 drivers/scsi/ipr.c                  |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/linux/libata.h              |   11 +-
 12 files changed, 1065 insertions(+), 79 deletions(-)
 create mode 100644 drivers/ata/pata_octeon_cf.c

Andrew Morton (1):
      drivers/ata/pata_ali.c: s/isa_bridge/ali_isa_bridge/ to fix alpha build

David Daney (2):
      libata: Add another column to the ata_timing table.
      libata: New driver for OCTEON SOC Compact Flash interface (v7).

Jeff Garzik (1):
      [libata] get-identity ioctl: Fix use of invalid memory pointer

JosephChan@via.com.tw (1):
      sata_via: Add VT8261 support

Michal Sojka (1):
      sata_fsl: Return non-zero on error in probe()

Tejun Heo (1):
      pata_atiixp: update port enabledness test handling

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 1a7be96..503a908 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -698,6 +698,15 @@ config PATA_IXP4XX_CF
 
 	  If unsure, say N.
 
+config PATA_OCTEON_CF
+	tristate "OCTEON Boot Bus Compact Flash support"
+	depends on CPU_CAVIUM_OCTEON
+	help
+	  This option enables a polled compact flash driver for use with
+	  compact flash cards attached to the OCTEON boot bus.
+
+	  If unsure, say N.
+
 config PATA_SCC
 	tristate "Toshiba's Cell Reference Set IDE support"
 	depends on PCI && PPC_CELLEB
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 674965f..7f1ecf9 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
 obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
 obj-$(CONFIG_PATA_SCH)		+= pata_sch.o
 obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
+obj-$(CONFIG_PATA_OCTEON_CF)	+= pata_octeon_cf.o
 obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
 obj-$(CONFIG_PATA_OF_PLATFORM)	+= pata_of_platform.o
 obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 71218d7..88c2428 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3029,33 +3029,33 @@ int sata_set_spd(struct ata_link *link)
  */
 
 static const struct ata_timing ata_timing[] = {
-/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 }, */
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
-	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
-
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 100,   0 },
-	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
-
-/*	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0,   0, 150 }, */
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
+/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 0,  960,   0 }, */
+	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 0,  600,   0 },
+	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 0,  383,   0 },
+	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 0,  240,   0 },
+	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 0,  180,   0 },
+	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 0,  120,   0 },
+	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 0,  100,   0 },
+	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20, 0,   80,   0 },
+
+	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 50, 960,   0 },
+	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 30, 480,   0 },
+	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 20, 240,   0 },
+
+	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 20, 480,   0 },
+	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 5,  150,   0 },
+	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 5,  120,   0 },
+	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 5,  100,   0 },
+	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20, 5,   80,   0 },
+
+/*	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0, 0,    0, 150 }, */
+	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0, 0,    0, 120 },
+	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0, 0,    0,  80 },
+	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0, 0,    0,  60 },
+	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0, 0,    0,  45 },
+	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0, 0,    0,  30 },
+	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0, 0,    0,  20 },
+	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0, 0,    0,  15 },
 
 	{ 0xFF }
 };
@@ -3065,14 +3065,15 @@ static const struct ata_timing ata_timing[] = {
 
 static void ata_timing_quantize(const struct ata_timing *t, struct ata_timing *q, int T, int UT)
 {
-	q->setup   = EZ(t->setup   * 1000,  T);
-	q->act8b   = EZ(t->act8b   * 1000,  T);
-	q->rec8b   = EZ(t->rec8b   * 1000,  T);
-	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
-	q->active  = EZ(t->active  * 1000,  T);
-	q->recover = EZ(t->recover * 1000,  T);
-	q->cycle   = EZ(t->cycle   * 1000,  T);
-	q->udma    = EZ(t->udma    * 1000, UT);
+	q->setup	= EZ(t->setup      * 1000,  T);
+	q->act8b	= EZ(t->act8b      * 1000,  T);
+	q->rec8b	= EZ(t->rec8b      * 1000,  T);
+	q->cyc8b	= EZ(t->cyc8b      * 1000,  T);
+	q->active	= EZ(t->active     * 1000,  T);
+	q->recover	= EZ(t->recover    * 1000,  T);
+	q->dmack_hold	= EZ(t->dmack_hold * 1000,  T);
+	q->cycle	= EZ(t->cycle      * 1000,  T);
+	q->udma		= EZ(t->udma       * 1000, UT);
 }
 
 void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
@@ -3084,6 +3085,7 @@ void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
 	if (what & ATA_TIMING_CYC8B  ) m->cyc8b   = max(a->cyc8b,   b->cyc8b);
 	if (what & ATA_TIMING_ACTIVE ) m->active  = max(a->active,  b->active);
 	if (what & ATA_TIMING_RECOVER) m->recover = max(a->recover, b->recover);
+	if (what & ATA_TIMING_DMACK_HOLD) m->dmack_hold = max(a->dmack_hold, b->dmack_hold);
 	if (what & ATA_TIMING_CYCLE  ) m->cycle   = max(a->cycle,   b->cycle);
 	if (what & ATA_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
 }
@@ -6638,7 +6640,6 @@ EXPORT_SYMBOL_GPL(ata_dev_pair);
 EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
-EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9e92107..a1a6e62 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -423,9 +423,9 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
+static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
+			    void __user *arg)
 {
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
 	u16 __user *dst = arg;
 	char buf[40];
@@ -645,7 +645,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	return rc;
 }
 
-int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
+		     int cmd, void __user *arg)
 {
 	int val = -EINVAL, rc = -EINVAL;
 
@@ -663,7 +664,7 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 		return 0;
 
 	case HDIO_GET_IDENTITY:
-		return ata_get_identity(scsidev, arg);
+		return ata_get_identity(ap, scsidev, arg);
 
 	case HDIO_DRIVE_CMD:
 		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
@@ -682,6 +683,14 @@ int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
 
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ata_sas_scsi_ioctl);
+
+int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
+{
+	return ata_sas_scsi_ioctl(ata_shost_to_port(scsidev->host),
+				scsidev, cmd, arg);
+}
+EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 
 /**
  *	ata_scsi_qc_new - acquire new ata_queued_cmd reference
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index a7999c1..eb99dbe 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -41,7 +41,7 @@ static int ali_atapi_dma = 0;
 module_param_named(atapi_dma, ali_atapi_dma, int, 0644);
 MODULE_PARM_DESC(atapi_dma, "Enable ATAPI DMA (0=disable, 1=enable)");
 
-static struct pci_dev *isa_bridge;
+static struct pci_dev *ali_isa_bridge;
 
 /*
  *	Cable special cases
@@ -346,13 +346,13 @@ static void ali_c2_c3_postreset(struct ata_link *link, unsigned int *classes)
 	int port_bit = 4 << link->ap->port_no;
 
 	/* If our bridge is an ALI 1533 then do the extra work */
-	if (isa_bridge) {
+	if (ali_isa_bridge) {
 		/* Tristate and re-enable the bus signals */
-		pci_read_config_byte(isa_bridge, 0x58, &r);
+		pci_read_config_byte(ali_isa_bridge, 0x58, &r);
 		r &= ~port_bit;
-		pci_write_config_byte(isa_bridge, 0x58, r);
+		pci_write_config_byte(ali_isa_bridge, 0x58, r);
 		r |= port_bit;
-		pci_write_config_byte(isa_bridge, 0x58, r);
+		pci_write_config_byte(ali_isa_bridge, 0x58, r);
 	}
 	ata_sff_postreset(link, classes);
 }
@@ -467,14 +467,14 @@ static void ali_init_chipset(struct pci_dev *pdev)
 		pci_write_config_byte(pdev, 0x53, tmp);
 	}
 	north = pci_get_bus_and_slot(0, PCI_DEVFN(0,0));
-	if (north && north->vendor == PCI_VENDOR_ID_AL && isa_bridge) {
+	if (north && north->vendor == PCI_VENDOR_ID_AL && ali_isa_bridge) {
 		/* Configure the ALi bridge logic. For non ALi rely on BIOS.
 		   Set the south bridge enable bit */
-		pci_read_config_byte(isa_bridge, 0x79, &tmp);
+		pci_read_config_byte(ali_isa_bridge, 0x79, &tmp);
 		if (pdev->revision == 0xC2)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x04);
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x04);
 		else if (pdev->revision > 0xC2 && pdev->revision < 0xC5)
-			pci_write_config_byte(isa_bridge, 0x79, tmp | 0x02);
+			pci_write_config_byte(ali_isa_bridge, 0x79, tmp | 0x02);
 	}
 	pci_dev_put(north);
 	ata_pci_bmdma_clear_simplex(pdev);
@@ -571,9 +571,9 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ali_init_chipset(pdev);
 
-	if (isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
+	if (ali_isa_bridge && pdev->revision >= 0x20 && pdev->revision < 0xC2) {
 		/* Are we paired with a UDMA capable chip */
-		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
+		pci_read_config_byte(ali_isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
 	        	ppi[0] = &info_20_udma;
 	}
@@ -617,11 +617,11 @@ static struct pci_driver ali_pci_driver = {
 static int __init ali_init(void)
 {
 	int ret;
-	isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
+	ali_isa_bridge = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
 	ret = pci_register_driver(&ali_pci_driver);
 	if (ret < 0)
-		pci_dev_put(isa_bridge);
+		pci_dev_put(ali_isa_bridge);
 	return ret;
 }
 
@@ -629,7 +629,7 @@ static int __init ali_init(void)
 static void __exit ali_exit(void)
 {
 	pci_unregister_driver(&ali_pci_driver);
-	pci_dev_put(isa_bridge);
+	pci_dev_put(ali_isa_bridge);
 }
 
 
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 0e2cde8..506adde 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -32,21 +32,6 @@ enum {
 	ATIIXP_IDE_UDMA_MODE 	= 0x56
 };
 
-static int atiixp_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	static const struct pci_bits atiixp_enable_bits[] = {
-		{ 0x48, 1, 0x01, 0x00 },
-		{ 0x48, 1, 0x08, 0x00 }
-	};
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
 static int atiixp_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -229,10 +214,9 @@ static struct ata_port_operations atiixp_port_ops = {
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
 	.set_dmamode	= atiixp_set_dmamode,
-	.prereset	= atiixp_pre_reset,
 };
 
-static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
 		.flags = ATA_FLAG_SLAVE_POSS,
@@ -241,8 +225,18 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x3F,
 		.port_ops = &atiixp_port_ops
 	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
-	return ata_pci_sff_init_one(dev, ppi, &atiixp_sht, NULL);
+	static const struct pci_bits atiixp_enable_bits[] = {
+		{ 0x48, 1, 0x01, 0x00 },
+		{ 0x48, 1, 0x08, 0x00 }
+	};
+	const struct ata_port_info *ppi[] = { &info, &info };
+	int i;
+
+	for (i = 0; i < 2; i++)
+		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
+			ppi[i] = &ata_dummy_port_info;
+
+	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
new file mode 100644
index 0000000..0fe4ef3
--- /dev/null
+++ b/drivers/ata/pata_octeon_cf.c
@@ -0,0 +1,965 @@
+/*
+ * Driver for the Octeon bootbus compact flash.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2005 - 2009 Cavium Networks
+ * Copyright (C) 2008 Wind River Systems
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/libata.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <scsi/scsi_host.h>
+
+#include <asm/octeon/octeon.h>
+
+/*
+ * The Octeon bootbus compact flash interface is connected in at least
+ * 3 different configurations on various evaluation boards:
+ *
+ * -- 8  bits no irq, no DMA
+ * -- 16 bits no irq, no DMA
+ * -- 16 bits True IDE mode with DMA, but no irq.
+ *
+ * In the last case the DMA engine can generate an interrupt when the
+ * transfer is complete.  For the first two cases only PIO is supported.
+ *
+ */
+
+#define DRV_NAME	"pata_octeon_cf"
+#define DRV_VERSION	"2.1"
+
+
+struct octeon_cf_port {
+	struct workqueue_struct *wq;
+	struct delayed_work delayed_finish;
+	struct ata_port *ap;
+	int dma_finished;
+};
+
+static struct scsi_host_template octeon_cf_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+/**
+ * Convert nanosecond based time to setting used in the
+ * boot bus timing register, based on timing multiple
+ */
+static unsigned int ns_to_tim_reg(unsigned int tim_mult, unsigned int nsecs)
+{
+	unsigned int val;
+
+	/*
+	 * Compute # of eclock periods to get desired duration in
+	 * nanoseconds.
+	 */
+	val = DIV_ROUND_UP(nsecs * (octeon_get_clock_rate() / 1000000),
+			  1000 * tim_mult);
+
+	return val;
+}
+
+static void octeon_cf_set_boot_reg_cfg(int cs)
+{
+	union cvmx_mio_boot_reg_cfgx reg_cfg;
+	reg_cfg.u64 = cvmx_read_csr(CVMX_MIO_BOOT_REG_CFGX(cs));
+	reg_cfg.s.dmack = 0;	/* Don't assert DMACK on access */
+	reg_cfg.s.tim_mult = 2;	/* Timing mutiplier 2x */
+	reg_cfg.s.rd_dly = 0;	/* Sample on falling edge of BOOT_OE */
+	reg_cfg.s.sam = 0;	/* Don't combine write and output enable */
+	reg_cfg.s.we_ext = 0;	/* No write enable extension */
+	reg_cfg.s.oe_ext = 0;	/* No read enable extension */
+	reg_cfg.s.en = 1;	/* Enable this region */
+	reg_cfg.s.orbit = 0;	/* Don't combine with previous region */
+	reg_cfg.s.ale = 0;	/* Don't do address multiplexing */
+	cvmx_write_csr(CVMX_MIO_BOOT_REG_CFGX(cs), reg_cfg.u64);
+}
+
+/**
+ * Called after libata determines the needed PIO mode. This
+ * function programs the Octeon bootbus regions to support the
+ * timing requirements of the PIO mode.
+ *
+ * @ap:     ATA port information
+ * @dev:    ATA device
+ */
+static void octeon_cf_set_piomode(struct ata_port *ap, struct ata_device *dev)
+{
+	struct octeon_cf_data *ocd = ap->dev->platform_data;
+	union cvmx_mio_boot_reg_timx reg_tim;
+	int cs = ocd->base_region;
+	int T;
+	struct ata_timing timing;
+
+	int use_iordy;
+	int trh;
+	int pause;
+	/* These names are timing parameters from the ATA spec */
+	int t1;
+	int t2;
+	int t2i;
+
+	T = (int)(2000000000000LL / octeon_get_clock_rate());
+
+	if (ata_timing_compute(dev, dev->pio_mode, &timing, T, T))
+		BUG();
+
+	t1 = timing.setup;
+	if (t1)
+		t1--;
+	t2 = timing.active;
+	if (t2)
+		t2--;
+	t2i = timing.act8b;
+	if (t2i)
+		t2i--;
+
+	trh = ns_to_tim_reg(2, 20);
+	if (trh)
+		trh--;
+
+	pause = timing.cycle - timing.active - timing.setup - trh;
+	if (pause)
+		pause--;
+
+	octeon_cf_set_boot_reg_cfg(cs);
+	if (ocd->dma_engine >= 0)
+		/* True IDE mode, program both chip selects.  */
+		octeon_cf_set_boot_reg_cfg(cs + 1);
+
+
+	use_iordy = ata_pio_need_iordy(dev);
+
+	reg_tim.u64 = cvmx_read_csr(CVMX_MIO_BOOT_REG_TIMX(cs));
+	/* Disable page mode */
+	reg_tim.s.pagem = 0;
+	/* Enable dynamic timing */
+	reg_tim.s.waitm = use_iordy;
+	/* Pages are disabled */
+	reg_tim.s.pages = 0;
+	/* We don't use multiplexed address mode */
+	reg_tim.s.ale = 0;
+	/* Not used */
+	reg_tim.s.page = 0;
+	/* Time after IORDY to coninue to assert the data */
+	reg_tim.s.wait = 0;
+	/* Time to wait to complete the cycle. */
+	reg_tim.s.pause = pause;
+	/* How long to hold after a write to de-assert CE. */
+	reg_tim.s.wr_hld = trh;
+	/* How long to wait after a read to de-assert CE. */
+	reg_tim.s.rd_hld = trh;
+	/* How long write enable is asserted */
+	reg_tim.s.we = t2;
+	/* How long read enable is asserted */
+	reg_tim.s.oe = t2;
+	/* Time after CE that read/write starts */
+	reg_tim.s.ce = ns_to_tim_reg(2, 5);
+	/* Time before CE that address is valid */
+	reg_tim.s.adr = 0;
+
+	/* Program the bootbus region timing for the data port chip select. */
+	cvmx_write_csr(CVMX_MIO_BOOT_REG_TIMX(cs), reg_tim.u64);
+	if (ocd->dma_engine >= 0)
+		/* True IDE mode, program both chip selects.  */
+		cvmx_write_csr(CVMX_MIO_BOOT_REG_TIMX(cs + 1), reg_tim.u64);
+}
+
+static void octeon_cf_set_dmamode(struct ata_port *ap, struct ata_device *dev)
+{
+	struct octeon_cf_data *ocd = dev->link->ap->dev->platform_data;
+	union cvmx_mio_boot_dma_timx dma_tim;
+	unsigned int oe_a;
+	unsigned int oe_n;
+	unsigned int dma_ackh;
+	unsigned int dma_arq;
+	unsigned int pause;
+	unsigned int T0, Tkr, Td;
+	unsigned int tim_mult;
+
+	const struct ata_timing *timing;
+
+	timing = ata_timing_find_mode(dev->dma_mode);
+	T0	= timing->cycle;
+	Td	= timing->active;
+	Tkr	= timing->recover;
+	dma_ackh = timing->dmack_hold;
+
+	dma_tim.u64 = 0;
+	/* dma_tim.s.tim_mult = 0 --> 4x */
+	tim_mult = 4;
+
+	/* not spec'ed, value in eclocks, not affected by tim_mult */
+	dma_arq = 8;
+	pause = 25 - dma_arq * 1000 /
+		(octeon_get_clock_rate() / 1000000); /* Tz */
+
+	oe_a = Td;
+	/* Tkr from cf spec, lengthened to meet T0 */
+	oe_n = max(T0 - oe_a, Tkr);
+
+	dma_tim.s.dmack_pi = 1;
+
+	dma_tim.s.oe_n = ns_to_tim_reg(tim_mult, oe_n);
+	dma_tim.s.oe_a = ns_to_tim_reg(tim_mult, oe_a);
+
+	/*
+	 * This is tI, C.F. spec. says 0, but Sony CF card requires
+	 * more, we use 20 nS.
+	 */
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);;
+	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
+
+	dma_tim.s.dmarq = dma_arq;
+	dma_tim.s.pause = ns_to_tim_reg(tim_mult, pause);
+
+	dma_tim.s.rd_dly = 0;	/* Sample right on edge */
+
+	/*  writes only */
+	dma_tim.s.we_n = ns_to_tim_reg(tim_mult, oe_n);
+	dma_tim.s.we_a = ns_to_tim_reg(tim_mult, oe_a);
+
+	pr_debug("ns to ticks (mult %d) of %d is: %d\n", tim_mult, 60,
+		 ns_to_tim_reg(tim_mult, 60));
+	pr_debug("oe_n: %d, oe_a: %d, dmack_s: %d, dmack_h: "
+		 "%d, dmarq: %d, pause: %d\n",
+		 dma_tim.s.oe_n, dma_tim.s.oe_a, dma_tim.s.dmack_s,
+		 dma_tim.s.dmack_h, dma_tim.s.dmarq, dma_tim.s.pause);
+
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_TIMX(ocd->dma_engine),
+		       dma_tim.u64);
+
+}
+
+/**
+ * Handle an 8 bit I/O request.
+ *
+ * @dev:        Device to access
+ * @buffer:     Data buffer
+ * @buflen:     Length of the buffer.
+ * @rw:         True to write.
+ */
+static unsigned int octeon_cf_data_xfer8(struct ata_device *dev,
+					 unsigned char *buffer,
+					 unsigned int buflen,
+					 int rw)
+{
+	struct ata_port *ap		= dev->link->ap;
+	void __iomem *data_addr		= ap->ioaddr.data_addr;
+	unsigned long words;
+	int count;
+
+	words = buflen;
+	if (rw) {
+		count = 16;
+		while (words--) {
+			iowrite8(*buffer, data_addr);
+			buffer++;
+			/*
+			 * Every 16 writes do a read so the bootbus
+			 * FIFO doesn't fill up.
+			 */
+			if (--count == 0) {
+				ioread8(ap->ioaddr.altstatus_addr);
+				count = 16;
+			}
+		}
+	} else {
+		ioread8_rep(data_addr, buffer, words);
+	}
+	return buflen;
+}
+
+/**
+ * Handle a 16 bit I/O request.
+ *
+ * @dev:        Device to access
+ * @buffer:     Data buffer
+ * @buflen:     Length of the buffer.
+ * @rw:         True to write.
+ */
+static unsigned int octeon_cf_data_xfer16(struct ata_device *dev,
+					  unsigned char *buffer,
+					  unsigned int buflen,
+					  int rw)
+{
+	struct ata_port *ap		= dev->link->ap;
+	void __iomem *data_addr		= ap->ioaddr.data_addr;
+	unsigned long words;
+	int count;
+
+	words = buflen / 2;
+	if (rw) {
+		count = 16;
+		while (words--) {
+			iowrite16(*(uint16_t *)buffer, data_addr);
+			buffer += sizeof(uint16_t);
+			/*
+			 * Every 16 writes do a read so the bootbus
+			 * FIFO doesn't fill up.
+			 */
+			if (--count == 0) {
+				ioread8(ap->ioaddr.altstatus_addr);
+				count = 16;
+			}
+		}
+	} else {
+		while (words--) {
+			*(uint16_t *)buffer = ioread16(data_addr);
+			buffer += sizeof(uint16_t);
+		}
+	}
+	/* Transfer trailing 1 byte, if any. */
+	if (unlikely(buflen & 0x01)) {
+		__le16 align_buf[1] = { 0 };
+
+		if (rw == READ) {
+			align_buf[0] = cpu_to_le16(ioread16(data_addr));
+			memcpy(buffer, align_buf, 1);
+		} else {
+			memcpy(align_buf, buffer, 1);
+			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
+		}
+		words++;
+	}
+	return buflen;
+}
+
+/**
+ * Read the taskfile for 16bit non-True IDE only.
+ */
+static void octeon_cf_tf_read16(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	u16 blob;
+	/* The base of the registers is at ioaddr.data_addr. */
+	void __iomem *base = ap->ioaddr.data_addr;
+
+	blob = __raw_readw(base + 0xc);
+	tf->feature = blob >> 8;
+
+	blob = __raw_readw(base + 2);
+	tf->nsect = blob & 0xff;
+	tf->lbal = blob >> 8;
+
+	blob = __raw_readw(base + 4);
+	tf->lbam = blob & 0xff;
+	tf->lbah = blob >> 8;
+
+	blob = __raw_readw(base + 6);
+	tf->device = blob & 0xff;
+	tf->command = blob >> 8;
+
+	if (tf->flags & ATA_TFLAG_LBA48) {
+		if (likely(ap->ioaddr.ctl_addr)) {
+			iowrite8(tf->ctl | ATA_HOB, ap->ioaddr.ctl_addr);
+
+			blob = __raw_readw(base + 0xc);
+			tf->hob_feature = blob >> 8;
+
+			blob = __raw_readw(base + 2);
+			tf->hob_nsect = blob & 0xff;
+			tf->hob_lbal = blob >> 8;
+
+			blob = __raw_readw(base + 4);
+			tf->hob_lbam = blob & 0xff;
+			tf->hob_lbah = blob >> 8;
+
+			iowrite8(tf->ctl, ap->ioaddr.ctl_addr);
+			ap->last_ctl = tf->ctl;
+		} else {
+			WARN_ON(1);
+		}
+	}
+}
+
+static u8 octeon_cf_check_status16(struct ata_port *ap)
+{
+	u16 blob;
+	void __iomem *base = ap->ioaddr.data_addr;
+
+	blob = __raw_readw(base + 6);
+	return blob >> 8;
+}
+
+static int octeon_cf_softreset16(struct ata_link *link, unsigned int *classes,
+				 unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	void __iomem *base = ap->ioaddr.data_addr;
+	int rc;
+	u8 err;
+
+	DPRINTK("about to softreset\n");
+	__raw_writew(ap->ctl, base + 0xe);
+	udelay(20);
+	__raw_writew(ap->ctl | ATA_SRST, base + 0xe);
+	udelay(20);
+	__raw_writew(ap->ctl, base + 0xe);
+
+	rc = ata_sff_wait_after_reset(link, 1, deadline);
+	if (rc) {
+		ata_link_printk(link, KERN_ERR, "SRST failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* determine by signature whether we have ATA or ATAPI devices */
+	classes[0] = ata_sff_dev_classify(&link->device[0], 1, &err);
+	DPRINTK("EXIT, classes[0]=%u [1]=%u\n", classes[0], classes[1]);
+	return 0;
+}
+
+/**
+ * Load the taskfile for 16bit non-True IDE only.  The device_addr is
+ * not loaded, we do this as part of octeon_cf_exec_command16.
+ */
+static void octeon_cf_tf_load16(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+	/* The base of the registers is at ioaddr.data_addr. */
+	void __iomem *base = ap->ioaddr.data_addr;
+
+	if (tf->ctl != ap->last_ctl) {
+		iowrite8(tf->ctl, ap->ioaddr.ctl_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		__raw_writew(tf->hob_feature << 8, base + 0xc);
+		__raw_writew(tf->hob_nsect | tf->hob_lbal << 8, base + 2);
+		__raw_writew(tf->hob_lbam | tf->hob_lbah << 8, base + 4);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+	if (is_addr) {
+		__raw_writew(tf->feature << 8, base + 0xc);
+		__raw_writew(tf->nsect | tf->lbal << 8, base + 2);
+		__raw_writew(tf->lbam | tf->lbah << 8, base + 4);
+		VPRINTK("feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	}
+	ata_wait_idle(ap);
+}
+
+
+static void octeon_cf_dev_select(struct ata_port *ap, unsigned int device)
+{
+/*  There is only one device, do nothing. */
+	return;
+}
+
+/*
+ * Issue ATA command to host controller.  The device_addr is also sent
+ * as it must be written in a combined write with the command.
+ */
+static void octeon_cf_exec_command16(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	/* The base of the registers is at ioaddr.data_addr. */
+	void __iomem *base = ap->ioaddr.data_addr;
+	u16 blob;
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		VPRINTK("device 0x%X\n", tf->device);
+		blob = tf->device;
+	} else {
+		blob = 0;
+	}
+
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	blob |= (tf->command << 8);
+	__raw_writew(blob, base + 6);
+
+
+	ata_wait_idle(ap);
+}
+
+static u8 octeon_cf_irq_on(struct ata_port *ap)
+{
+	return 0;
+}
+
+static void octeon_cf_irq_clear(struct ata_port *ap)
+{
+	return;
+}
+
+static void octeon_cf_dma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct octeon_cf_port *cf_port;
+
+	cf_port = (struct octeon_cf_port *)ap->private_data;
+	DPRINTK("ENTER\n");
+	/* issue r/w command */
+	qc->cursg = qc->sg;
+	cf_port->dma_finished = 0;
+	ap->ops->sff_exec_command(ap, &qc->tf);
+	DPRINTK("EXIT\n");
+}
+
+/**
+ * Start a DMA transfer that was already setup
+ *
+ * @qc:     Information about the DMA
+ */
+static void octeon_cf_dma_start(struct ata_queued_cmd *qc)
+{
+	struct octeon_cf_data *ocd = qc->ap->dev->platform_data;
+	union cvmx_mio_boot_dma_cfgx mio_boot_dma_cfg;
+	union cvmx_mio_boot_dma_intx mio_boot_dma_int;
+	struct scatterlist *sg;
+
+	VPRINTK("%d scatterlists\n", qc->n_elem);
+
+	/* Get the scatter list entry we need to DMA into */
+	sg = qc->cursg;
+	BUG_ON(!sg);
+
+	/*
+	 * Clear the DMA complete status.
+	 */
+	mio_boot_dma_int.u64 = 0;
+	mio_boot_dma_int.s.done = 1;
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine),
+		       mio_boot_dma_int.u64);
+
+	/* Enable the interrupt.  */
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_INT_ENX(ocd->dma_engine),
+		       mio_boot_dma_int.u64);
+
+	/* Set the direction of the DMA */
+	mio_boot_dma_cfg.u64 = 0;
+	mio_boot_dma_cfg.s.en = 1;
+	mio_boot_dma_cfg.s.rw = ((qc->tf.flags & ATA_TFLAG_WRITE) != 0);
+
+	/*
+	 * Don't stop the DMA if the device deasserts DMARQ. Many
+	 * compact flashes deassert DMARQ for a short time between
+	 * sectors. Instead of stopping and restarting the DMA, we'll
+	 * let the hardware do it. If the DMA is really stopped early
+	 * due to an error condition, a later timeout will force us to
+	 * stop.
+	 */
+	mio_boot_dma_cfg.s.clr = 0;
+
+	/* Size is specified in 16bit words and minus one notation */
+	mio_boot_dma_cfg.s.size = sg_dma_len(sg) / 2 - 1;
+
+	/* We need to swap the high and low bytes of every 16 bits */
+	mio_boot_dma_cfg.s.swap8 = 1;
+
+	mio_boot_dma_cfg.s.adr = sg_dma_address(sg);
+
+	VPRINTK("%s %d bytes address=%p\n",
+		(mio_boot_dma_cfg.s.rw) ? "write" : "read", sg->length,
+		(void *)(unsigned long)mio_boot_dma_cfg.s.adr);
+
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine),
+		       mio_boot_dma_cfg.u64);
+}
+
+/**
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static unsigned int octeon_cf_dma_finished(struct ata_port *ap,
+					struct ata_queued_cmd *qc)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct octeon_cf_data *ocd = ap->dev->platform_data;
+	union cvmx_mio_boot_dma_cfgx dma_cfg;
+	union cvmx_mio_boot_dma_intx dma_int;
+	struct octeon_cf_port *cf_port;
+	u8 status;
+
+	VPRINTK("ata%u: protocol %d task_state %d\n",
+		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
+
+
+	if (ap->hsm_task_state != HSM_ST_LAST)
+		return 0;
+
+	cf_port = (struct octeon_cf_port *)ap->private_data;
+
+	dma_cfg.u64 = cvmx_read_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine));
+	if (dma_cfg.s.size != 0xfffff) {
+		/* Error, the transfer was not complete.  */
+		qc->err_mask |= AC_ERR_HOST_BUS;
+		ap->hsm_task_state = HSM_ST_ERR;
+	}
+
+	/* Stop and clear the dma engine.  */
+	dma_cfg.u64 = 0;
+	dma_cfg.s.size = -1;
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine), dma_cfg.u64);
+
+	/* Disable the interrupt.  */
+	dma_int.u64 = 0;
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_INT_ENX(ocd->dma_engine), dma_int.u64);
+
+	/* Clear the DMA complete status */
+	dma_int.s.done = 1;
+	cvmx_write_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine), dma_int.u64);
+
+	status = ap->ops->sff_check_status(ap);
+
+	ata_sff_hsm_move(ap, qc, status, 0);
+
+	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA))
+		ata_ehi_push_desc(ehi, "DMA stat 0x%x", status);
+
+	return 1;
+}
+
+/*
+ * Check if any queued commands have more DMAs, if so start the next
+ * transfer, else do end of transfer handling.
+ */
+static irqreturn_t octeon_cf_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct octeon_cf_port *cf_port;
+	int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	DPRINTK("ENTER\n");
+	for (i = 0; i < host->n_ports; i++) {
+		u8 status;
+		struct ata_port *ap;
+		struct ata_queued_cmd *qc;
+		union cvmx_mio_boot_dma_intx dma_int;
+		union cvmx_mio_boot_dma_cfgx dma_cfg;
+		struct octeon_cf_data *ocd;
+
+		ap = host->ports[i];
+		ocd = ap->dev->platform_data;
+		if (!ap || (ap->flags & ATA_FLAG_DISABLED))
+			continue;
+
+		ocd = ap->dev->platform_data;
+		cf_port = (struct octeon_cf_port *)ap->private_data;
+		dma_int.u64 =
+			cvmx_read_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine));
+		dma_cfg.u64 =
+			cvmx_read_csr(CVMX_MIO_BOOT_DMA_CFGX(ocd->dma_engine));
+
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+		    (qc->flags & ATA_QCFLAG_ACTIVE)) {
+			if (dma_int.s.done && !dma_cfg.s.en) {
+				if (!sg_is_last(qc->cursg)) {
+					qc->cursg = sg_next(qc->cursg);
+					handled = 1;
+					octeon_cf_dma_start(qc);
+					continue;
+				} else {
+					cf_port->dma_finished = 1;
+				}
+			}
+			if (!cf_port->dma_finished)
+				continue;
+			status = ioread8(ap->ioaddr.altstatus_addr);
+			if (status & (ATA_BUSY | ATA_DRQ)) {
+				/*
+				 * We are busy, try to handle it
+				 * later.  This is the DMA finished
+				 * interrupt, and it could take a
+				 * little while for the card to be
+				 * ready for more commands.
+				 */
+				/* Clear DMA irq. */
+				dma_int.u64 = 0;
+				dma_int.s.done = 1;
+				cvmx_write_csr(CVMX_MIO_BOOT_DMA_INTX(ocd->dma_engine),
+					       dma_int.u64);
+
+				queue_delayed_work(cf_port->wq,
+						   &cf_port->delayed_finish, 1);
+				handled = 1;
+			} else {
+				handled |= octeon_cf_dma_finished(ap, qc);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+	DPRINTK("EXIT\n");
+	return IRQ_RETVAL(handled);
+}
+
+static void octeon_cf_delayed_finish(struct work_struct *work)
+{
+	struct octeon_cf_port *cf_port = container_of(work,
+						      struct octeon_cf_port,
+						      delayed_finish.work);
+	struct ata_port *ap = cf_port->ap;
+	struct ata_host *host = ap->host;
+	struct ata_queued_cmd *qc;
+	unsigned long flags;
+	u8 status;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	/*
+	 * If the port is not waiting for completion, it must have
+	 * handled it previously.  The hsm_task_state is
+	 * protected by host->lock.
+	 */
+	if (ap->hsm_task_state != HSM_ST_LAST || !cf_port->dma_finished)
+		goto out;
+
+	status = ioread8(ap->ioaddr.altstatus_addr);
+	if (status & (ATA_BUSY | ATA_DRQ)) {
+		/* Still busy, try again. */
+		queue_delayed_work(cf_port->wq,
+				   &cf_port->delayed_finish, 1);
+		goto out;
+	}
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+	    (qc->flags & ATA_QCFLAG_ACTIVE))
+		octeon_cf_dma_finished(ap, qc);
+out:
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void octeon_cf_dev_config(struct ata_device *dev)
+{
+	/*
+	 * A maximum of 2^20 - 1 16 bit transfers are possible with
+	 * the bootbus DMA.  So we need to throttle max_sectors to
+	 * (2^12 - 1 == 4095) to assure that this can never happen.
+	 */
+	dev->max_sectors = min(dev->max_sectors, 4095U);
+}
+
+/*
+ * Trap if driver tries to do standard bmdma commands.  They are not
+ * supported.
+ */
+static void unreachable_qc(struct ata_queued_cmd *qc)
+{
+	BUG();
+}
+
+static u8 unreachable_port(struct ata_port *ap)
+{
+	BUG();
+}
+
+/*
+ * We don't do ATAPI DMA so return 0.
+ */
+static int octeon_cf_check_atapi_dma(struct ata_queued_cmd *qc)
+{
+	return 0;
+}
+
+static unsigned int octeon_cf_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+
+	switch (qc->tf.protocol) {
+	case ATA_PROT_DMA:
+		WARN_ON(qc->tf.flags & ATA_TFLAG_POLLING);
+
+		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
+		octeon_cf_dma_setup(qc);	    /* set up dma */
+		octeon_cf_dma_start(qc);	    /* initiate dma */
+		ap->hsm_task_state = HSM_ST_LAST;
+		break;
+
+	case ATAPI_PROT_DMA:
+		dev_err(ap->dev, "Error, ATAPI not supported\n");
+		BUG();
+
+	default:
+		return ata_sff_qc_issue(qc);
+	}
+
+	return 0;
+}
+
+static struct ata_port_operations octeon_cf_ops = {
+	.inherits		= &ata_sff_port_ops,
+	.check_atapi_dma	= octeon_cf_check_atapi_dma,
+	.qc_prep		= ata_noop_qc_prep,
+	.qc_issue		= octeon_cf_qc_issue,
+	.sff_dev_select		= octeon_cf_dev_select,
+	.sff_irq_on		= octeon_cf_irq_on,
+	.sff_irq_clear		= octeon_cf_irq_clear,
+	.bmdma_setup		= unreachable_qc,
+	.bmdma_start		= unreachable_qc,
+	.bmdma_stop		= unreachable_qc,
+	.bmdma_status		= unreachable_port,
+	.cable_detect		= ata_cable_40wire,
+	.set_piomode		= octeon_cf_set_piomode,
+	.set_dmamode		= octeon_cf_set_dmamode,
+	.dev_config		= octeon_cf_dev_config,
+};
+
+static int __devinit octeon_cf_probe(struct platform_device *pdev)
+{
+	struct resource *res_cs0, *res_cs1;
+
+	void __iomem *cs0;
+	void __iomem *cs1 = NULL;
+	struct ata_host *host;
+	struct ata_port *ap;
+	struct octeon_cf_data *ocd;
+	int irq = 0;
+	irq_handler_t irq_handler = NULL;
+	void __iomem *base;
+	struct octeon_cf_port *cf_port;
+
+	res_cs0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res_cs0)
+		return -EINVAL;
+
+	ocd = pdev->dev.platform_data;
+
+	cs0 = devm_ioremap_nocache(&pdev->dev, res_cs0->start,
+				   res_cs0->end - res_cs0->start + 1);
+
+	if (!cs0)
+		return -ENOMEM;
+
+	/* Determine from availability of DMA if True IDE mode or not */
+	if (ocd->dma_engine >= 0) {
+		res_cs1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res_cs1)
+			return -EINVAL;
+
+		cs1 = devm_ioremap_nocache(&pdev->dev, res_cs1->start,
+					   res_cs0->end - res_cs1->start + 1);
+
+		if (!cs1)
+			return -ENOMEM;
+	}
+
+	cf_port = kzalloc(sizeof(*cf_port), GFP_KERNEL);
+	if (!cf_port)
+		return -ENOMEM;
+
+	/* allocate host */
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host)
+		goto free_cf_port;
+
+	ap = host->ports[0];
+	ap->private_data = cf_port;
+	cf_port->ap = ap;
+	ap->ops = &octeon_cf_ops;
+	ap->pio_mask = 0x7f; /* Support PIO 0-6 */
+	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY
+		  | ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
+
+	base = cs0 + ocd->base_region_bias;
+	if (!ocd->is16bit) {
+		ap->ioaddr.cmd_addr	= base;
+		ata_sff_std_ports(&ap->ioaddr);
+
+		ap->ioaddr.altstatus_addr = base + 0xe;
+		ap->ioaddr.ctl_addr	= base + 0xe;
+		octeon_cf_ops.sff_data_xfer = octeon_cf_data_xfer8;
+	} else if (cs1) {
+		/* Presence of cs1 indicates True IDE mode.  */
+		ap->ioaddr.cmd_addr	= base + (ATA_REG_CMD << 1) + 1;
+		ap->ioaddr.data_addr	= base + (ATA_REG_DATA << 1);
+		ap->ioaddr.error_addr	= base + (ATA_REG_ERR << 1) + 1;
+		ap->ioaddr.feature_addr	= base + (ATA_REG_FEATURE << 1) + 1;
+		ap->ioaddr.nsect_addr	= base + (ATA_REG_NSECT << 1) + 1;
+		ap->ioaddr.lbal_addr	= base + (ATA_REG_LBAL << 1) + 1;
+		ap->ioaddr.lbam_addr	= base + (ATA_REG_LBAM << 1) + 1;
+		ap->ioaddr.lbah_addr	= base + (ATA_REG_LBAH << 1) + 1;
+		ap->ioaddr.device_addr	= base + (ATA_REG_DEVICE << 1) + 1;
+		ap->ioaddr.status_addr	= base + (ATA_REG_STATUS << 1) + 1;
+		ap->ioaddr.command_addr	= base + (ATA_REG_CMD << 1) + 1;
+		ap->ioaddr.altstatus_addr = cs1 + (6 << 1) + 1;
+		ap->ioaddr.ctl_addr	= cs1 + (6 << 1) + 1;
+		octeon_cf_ops.sff_data_xfer = octeon_cf_data_xfer16;
+
+		ap->mwdma_mask	= 0x1f; /* Support MWDMA 0-4 */
+		irq = platform_get_irq(pdev, 0);
+		irq_handler = octeon_cf_interrupt;
+
+		/* True IDE mode needs delayed work to poll for not-busy.  */
+		cf_port->wq = create_singlethread_workqueue(DRV_NAME);
+		if (!cf_port->wq)
+			goto free_cf_port;
+		INIT_DELAYED_WORK(&cf_port->delayed_finish,
+				  octeon_cf_delayed_finish);
+
+	} else {
+		/* 16 bit but not True IDE */
+		octeon_cf_ops.sff_data_xfer	= octeon_cf_data_xfer16;
+		octeon_cf_ops.softreset		= octeon_cf_softreset16;
+		octeon_cf_ops.sff_check_status	= octeon_cf_check_status16;
+		octeon_cf_ops.sff_tf_read	= octeon_cf_tf_read16;
+		octeon_cf_ops.sff_tf_load	= octeon_cf_tf_load16;
+		octeon_cf_ops.sff_exec_command	= octeon_cf_exec_command16;
+
+		ap->ioaddr.data_addr	= base + ATA_REG_DATA;
+		ap->ioaddr.nsect_addr	= base + ATA_REG_NSECT;
+		ap->ioaddr.lbal_addr	= base + ATA_REG_LBAL;
+		ap->ioaddr.ctl_addr	= base + 0xe;
+		ap->ioaddr.altstatus_addr = base + 0xe;
+	}
+
+	ata_port_desc(ap, "cmd %p ctl %p", base, ap->ioaddr.ctl_addr);
+
+
+	dev_info(&pdev->dev, "version " DRV_VERSION" %d bit%s.\n",
+		 (ocd->is16bit) ? 16 : 8,
+		 (cs1) ? ", True IDE" : "");
+
+
+	return ata_host_activate(host, irq, irq_handler, 0, &octeon_cf_sht);
+
+free_cf_port:
+	kfree(cf_port);
+	return -ENOMEM;
+}
+
+static struct platform_driver octeon_cf_driver = {
+	.probe		= octeon_cf_probe,
+	.driver		= {
+		.name	= DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init octeon_cf_init(void)
+{
+	return platform_driver_register(&octeon_cf_driver);
+}
+
+
+MODULE_AUTHOR("David Daney <ddaney@caviumnetworks.com>");
+MODULE_DESCRIPTION("low-level driver for Cavium OCTEON Compact Flash PATA");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("platform:" DRV_NAME);
+
+module_init(octeon_cf_init);
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 1a56db9..55bc88c 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1288,7 +1288,7 @@ static const struct ata_port_info sata_fsl_port_info[] = {
 static int sata_fsl_probe(struct of_device *ofdev,
 			const struct of_device_id *match)
 {
-	int retval = 0;
+	int retval = -ENXIO;
 	void __iomem *hcr_base = NULL;
 	void __iomem *ssr_base = NULL;
 	void __iomem *csr_base = NULL;
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c18935f..5c62da9 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -92,6 +92,8 @@ static const struct pci_device_id svia_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, 0x5372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x7372), vt6420 },
 	{ PCI_VDEVICE(VIA, 0x5287), vt8251 }, /* 2 sata chnls (Master/Slave) */
+	{ PCI_VDEVICE(VIA, 0x9000), vt8251 },
+	{ PCI_VDEVICE(VIA, 0x9040), vt8251 },
 
 	{ }	/* terminate list */
 };
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 841f460..0782900 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4912,7 +4912,7 @@ static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	if (res && ipr_is_gata(res)) {
 		if (cmd == HDIO_GET_IDENTITY)
 			return -ENOTTY;
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return ata_sas_scsi_ioctl(res->sata_port->ap, sdev, cmd, arg);
 	}
 
 	return -EINVAL;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7448387..1c558d3 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -717,7 +717,7 @@ int sas_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
 
 	if (dev_is_sata(dev))
-		return ata_scsi_ioctl(sdev, cmd, arg);
+		return ata_sas_scsi_ioctl(dev->sata_dev.ap, sdev, cmd, arg);
 
 	return -EINVAL;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b6b8a7f..2c6bd66 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -401,12 +401,14 @@ enum {
 				  ATA_TIMING_CYC8B,
 	ATA_TIMING_ACTIVE	= (1 << 4),
 	ATA_TIMING_RECOVER	= (1 << 5),
-	ATA_TIMING_CYCLE	= (1 << 6),
-	ATA_TIMING_UDMA		= (1 << 7),
+	ATA_TIMING_DMACK_HOLD	= (1 << 6),
+	ATA_TIMING_CYCLE	= (1 << 7),
+	ATA_TIMING_UDMA		= (1 << 8),
 	ATA_TIMING_ALL		= ATA_TIMING_SETUP | ATA_TIMING_ACT8B |
 				  ATA_TIMING_REC8B | ATA_TIMING_CYC8B |
 				  ATA_TIMING_ACTIVE | ATA_TIMING_RECOVER |
-				  ATA_TIMING_CYCLE | ATA_TIMING_UDMA,
+				  ATA_TIMING_DMACK_HOLD | ATA_TIMING_CYCLE |
+				  ATA_TIMING_UDMA,
 };
 
 enum ata_xfer_mask {
@@ -866,6 +868,7 @@ struct ata_timing {
 	unsigned short cyc8b;		/* t0 for 8-bit I/O */
 	unsigned short active;		/* t2 or tD */
 	unsigned short recover;		/* t2i or tK */
+	unsigned short dmack_hold;	/* tj */
 	unsigned short cycle;		/* t0 */
 	unsigned short udma;		/* t2CYCTYP/2 */
 };
@@ -927,6 +930,8 @@ extern void ata_host_init(struct ata_host *, struct device *,
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
+extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
+			    int cmd, void __user *arg);
 extern void ata_sas_port_destroy(struct ata_port *);
 extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
 					   struct ata_port_info *, struct Scsi_Host *);
