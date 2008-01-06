Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYAFQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYAFQxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbYAFQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:51:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759502AbYAFQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NbVRqEqBD0zO5CR2gkn5d5rEsABXRlFaB/5uBpxiqJqX4ziJyANRkEl16ZQnk3SRJP4UVyypPJuQ3MqXUhf/bB0ZZd/6/VMxJYkY7Afy45wywAFG0o0qs+jmforF1lgBP7NXaP+eBI/oU0RvrQQa0bjFvSPmFVrkDO7EKi6wlhw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:03:10 +0100
Message-Id: <20080106170310.6861.14522.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/8] ide: add struct ide_port_info instances to legacy host drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove 'struct pci_dev *dev' argument from ide_hwif_setup_dma().

* Un-static ide_hwif_setup_dma() and add CONFIG_BLK_DEV_IDEDMA_PCI=n version.

* Add 'const struct ide_port_info *d' argument to ide_device_add[_all]().

* Factor out generic ports init from ide_pci_setup_ports() to ide_init_port(),
  move it to ide-probe.c and call it in in ide_device_add_all() instead of
  ide_pci_setup_ports().

* Move ->mate setup to ide_device_add_all() from ide_port_init().

* Add IDE_HFLAG_NO_AUTOTUNE host flag for host drivers that don't enable
  ->autotune currently.

* Setup hwif->chipset in ide_init_port() but iff pi->chipset is set
  (to not override setup done by ide_hwif_configure()).

* Add ETRAX host handling to ide_device_add_all().

* cmd640.c: set IDE_HFLAG_ABUSE_* also for CONFIG_BLK_DEV_CMD640_ENHANCED=n.

* pmac.c: make pmac_ide_setup_dma() return an error value and move DMA masks
  setup to pmac_ide_setup_device().

* Add 'struct ide_port_info' instances to legacy host drivers, pass them to
  ide_device_add() calls and then remove open-coded ports initialization.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c          |   25 +++++------
 drivers/ide/arm/ide_arm.c         |    2 
 drivers/ide/arm/rapide.c          |    2 
 drivers/ide/cris/ide-cris.c       |   18 ++++----
 drivers/ide/h8300/ide-h8300.c     |    2 
 drivers/ide/ide-generic.c         |    2 
 drivers/ide/ide-pnp.c             |    2 
 drivers/ide/ide-probe.c           |   82 +++++++++++++++++++++++++++++++++++--
 drivers/ide/ide.c                 |    2 
 drivers/ide/legacy/ali14xx.c      |   24 ++++------
 drivers/ide/legacy/buddha.c       |    2 
 drivers/ide/legacy/dtc2278.c      |   24 ++++------
 drivers/ide/legacy/falconide.c    |    2 
 drivers/ide/legacy/gayle.c        |    2 
 drivers/ide/legacy/ht6560b.c      |   22 ++++-----
 drivers/ide/legacy/ide_platform.c |    2 
 drivers/ide/legacy/macide.c       |    2 
 drivers/ide/legacy/q40ide.c       |    2 
 drivers/ide/legacy/qd65xx.c       |   23 +++++-----
 drivers/ide/legacy/umc8672.c      |   24 ++++------
 drivers/ide/mips/au1xxx-ide.c     |   31 ++++----------
 drivers/ide/mips/swarm.c          |    2 
 drivers/ide/pci/cmd640.c          |   31 ++++++--------
 drivers/ide/pci/cs5520.c          |    2 
 drivers/ide/pci/sgiioc4.c         |   18 +++++---
 drivers/ide/ppc/mpc8xx.c          |    2 
 drivers/ide/ppc/pmac.c            |   84 +++++++++++++++-----------------------
 drivers/ide/setup-pci.c           |   81 +++---------------------------------
 include/linux/ide.h               |   13 ++++-
 29 files changed, 259 insertions(+), 271 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -377,9 +377,6 @@ static void icside_dma_lost_irq(ide_driv
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	hwif->mwdma_mask	= 7; /* MW0..2 */
-	hwif->swdma_mask	= 7; /* SW0..2 */
-
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 	hwif->set_dma_mode	= icside_set_dma_mode;
@@ -459,11 +456,19 @@ icside_register_v5(struct icside_state *
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 }
 
+static const struct ide_port_info icside_v6_port_info __initdata = {
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.mwdma_mask		= ATA_MWDMA2,
+	.swdma_mask		= ATA_SWDMA2,
+};
+
 static int __init
 icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 {
@@ -472,6 +477,7 @@ icside_register_v6(struct icside_state *
 	unsigned int sel = 0;
 	int ret;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -521,30 +527,25 @@ icside_register_v6(struct icside_state *
 	state->hwif[1]    = mate;
 
 	hwif->maskproc    = icside_maskproc;
-	hwif->channel     = 0;
 	hwif->hwif_data   = state;
-	hwif->mate        = mate;
-	hwif->serialized  = 1;
 	hwif->config_data = (unsigned long)ioc_base;
 	hwif->select_data = sel;
 
 	mate->maskproc    = icside_maskproc;
-	mate->channel     = 1;
 	mate->hwif_data   = state;
-	mate->mate        = hwif;
-	mate->serialized  = 1;
 	mate->config_data = (unsigned long)ioc_base;
 	mate->select_data = sel | 1;
 
 	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
 		icside_dma_init(hwif);
 		icside_dma_init(mate);
-	}
+	} else
+		d.mwdma_mask = d.swdma_mask = 0;
 
 	idx[0] = hwif->index;
 	idx[1] = mate->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &d);
 
 	return 0;
 
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -39,7 +39,7 @@ static int __init ide_arm_init(void)
 		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -58,7 +58,7 @@ rapide_probe(struct expansion_card *ec, 
 
 		idx[0] = hwif->index;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 
 		ecard_set_drvdata(ec, hwif);
 		goto out;
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -753,6 +753,15 @@ static void cris_set_dma_mode(ide_drive_
 		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
 }
 
+static const struct ide_port_info cris_port_info __initdata = {
+	.chipset		= ide_etrax100,
+	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
+				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
+	.pio_mask		= ATA_PIO4,
+	.udma_mask		= cris_ultra_mask,
+	.mwdma_mask		= ATA_MWDMA2,
+};
+
 static int __init init_e100_ide(void)
 {
 	hw_regs_t hw;
@@ -780,7 +789,6 @@ static int __init init_e100_ide(void)
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 		hwif->mmio = 1;
-		hwif->chipset = ide_etrax100;
 		hwif->set_pio_mode = &cris_set_pio_mode;
 		hwif->set_dma_mode = &cris_set_dma_mode;
 		hwif->ata_input_data = &cris_ide_input_data;
@@ -799,12 +807,6 @@ static int __init init_e100_ide(void)
 		hwif->INB = &cris_ide_inb;
 		hwif->INW = &cris_ide_inw;
 		hwif->cbl = ATA_CBL_PATA40;
-		hwif->host_flags |= IDE_HFLAG_NO_ATAPI_DMA;
-		hwif->pio_mask = ATA_PIO4,
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
-		hwif->ultra_mask = cris_ultra_mask;
-		hwif->mwdma_mask = 0x07; /* Multiword DMA 0-2 */
 
 		idx[h] = hwif->index;
 	}
@@ -820,7 +822,7 @@ static int __init init_e100_ide(void)
 	cris_ide_set_speed(TYPE_DMA, 0, ATA_DMA2_STROBE, ATA_DMA2_HOLD);
 	cris_ide_set_speed(TYPE_UDMA, ATA_UDMA2_CYC, ATA_UDMA2_DVS, 0);
 
-	ide_device_add(idx);
+	ide_device_add(idx, &cris_port_info);
 
 	return 0;
 }
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -114,7 +114,7 @@ static int __init h8300_ide_init(void)
 
 	idx[0] = index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -23,7 +23,7 @@ static int __init ide_generic_init(void)
 	for (i = 0; i < MAX_HWIFS; i++)
 		idx[i] = ide_hwifs[i].present ? 0xff : i;
 
-	ide_device_add_all(idx);
+	ide_device_add_all(idx, NULL);
 
 	if (ide_hwifs[0].io_ports[IDE_DATA_OFFSET])
 		ide_release_lock();	/* for atari only */
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -49,7 +49,7 @@ static int idepnp_probe(struct pnp_dev *
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev,hwif);
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 
 		return 0;
 	}
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1289,12 +1289,86 @@ static void hwif_register_devices(ide_hw
 	}
 }
 
-int ide_device_add_all(u8 *idx)
+static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
+			  const struct ide_port_info *d)
 {
-	ide_hwif_t *hwif;
+	if (d->chipset != ide_etrax100)
+		hwif->channel = port;
+
+	if (d->chipset)
+		hwif->chipset = d->chipset;
+
+	if (d->init_iops)
+		d->init_iops(hwif);
+
+	if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
+		ide_hwif_setup_dma(hwif, d);
+
+	if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
+	    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
+		hwif->irq = port ? 15 : 14;
+
+	hwif->host_flags = d->host_flags;
+	hwif->pio_mask = d->pio_mask;
+
+	if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
+		hwif->mate->serialized = hwif->serialized = 1;
+
+	if (d->host_flags & IDE_HFLAG_IO_32BIT) {
+		hwif->drives[0].io_32bit = 1;
+		hwif->drives[1].io_32bit = 1;
+	}
+
+	if (d->host_flags & IDE_HFLAG_UNMASK_IRQS) {
+		hwif->drives[0].unmask = 1;
+		hwif->drives[1].unmask = 1;
+	}
+
+	hwif->swdma_mask = d->swdma_mask;
+	hwif->mwdma_mask = d->mwdma_mask;
+	hwif->ultra_mask = d->udma_mask;
+
+	/* reset DMA masks only for SFF-style DMA controllers */
+	if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 && hwif->dma_base == 0)
+		hwif->swdma_mask = hwif->mwdma_mask = hwif->ultra_mask = 0;
+
+	if ((d->host_flags & IDE_HFLAG_NO_AUTOTUNE) == 0) {
+		hwif->drives[0].autotune = 1;
+		hwif->drives[1].autotune = 1;
+	}
+
+	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
+		hwif->rqsize = 256;
+
+	/* call chipset specific routine for each enabled port */
+	if (d->init_hwif)
+		d->init_hwif(hwif);
+}
+
+int ide_device_add_all(u8 idx[MAX_HWIFS], const struct ide_port_info *d)
+{
+	ide_hwif_t *hwif, *mate = NULL;
 	int i, rc = 0;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
+		if (d == NULL || idx[i] == 0xff) {
+			mate = NULL;
+			continue;
+		}
+
+		hwif = &ide_hwifs[idx[i]];
+
+		if (d->chipset != ide_etrax100 && (i & 1) && mate) {
+			hwif->mate = mate;
+			mate->mate = hwif;
+		}
+
+		mate = (i & 1) ? NULL : hwif;
+
+		ide_init_port(hwif, i & 1, d);
+	}
+
+	for (i = 0; i < MAX_HWIFS; i++) {
 		if (idx[i] == 0xff)
 			continue;
 
@@ -1362,7 +1436,7 @@ int ide_device_add_all(u8 *idx)
 }
 EXPORT_SYMBOL_GPL(ide_device_add_all);
 
-int ide_device_add(u8 idx[4])
+int ide_device_add(u8 idx[4], const struct ide_port_info *d)
 {
 	u8 idx_all[MAX_HWIFS];
 	int i;
@@ -1370,6 +1444,6 @@ int ide_device_add(u8 idx[4])
 	for (i = 0; i < MAX_HWIFS; i++)
 		idx_all[i] = (i < 4) ? idx[i] : 0xff;
 
-	return ide_device_add_all(idx_all);
+	return ide_device_add_all(idx_all, d);
 }
 EXPORT_SYMBOL_GPL(ide_device_add);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -728,7 +728,7 @@ found:
 
 	idx[0] = index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	if (hwifp)
 		*hwifp = hwif;
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -191,9 +191,14 @@ static int __init initRegisters (void) {
 	return t;
 }
 
+static const struct ide_port_info ali14xx_port_info = {
+	.chipset		= ide_ali14xx,
+	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init ali14xx_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
@@ -205,21 +210,10 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	hwif->chipset = ide_ali14xx;
-	hwif->pio_mask = ATA_PIO4;
-	hwif->set_pio_mode = &ali14xx_set_pio_mode;
-	hwif->mate = mate;
-
-	mate->chipset = ide_ali14xx;
-	mate->pio_mask = ATA_PIO4;
-	mate->set_pio_mode = &ali14xx_set_pio_mode;
-	mate->mate = hwif;
-	mate->channel = 1;
+	ide_hwifs[0].set_pio_mode = &ali14xx_set_pio_mode;
+	ide_hwifs[1].set_pio_mode = &ali14xx_set_pio_mode;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &ali14xx_port_info);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -232,7 +232,7 @@ fail_base2:
 			}
 		}
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -86,6 +86,15 @@ static void dtc2278_set_pio_mode(ide_dri
 	}
 }
 
+static const struct ide_port_info dtc2278_port_info __initdata = {
+	.chipset		= ide_dtc2278,
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_IO_32BIT |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
@@ -116,29 +125,16 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	hwif->serialized = 1;
 	hwif->no_io_32bit = 1;	/* disallow ->io_32bit changes */
-	hwif->chipset = ide_dtc2278;
-	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = &dtc2278_set_pio_mode;
 	hwif->drives[0].no_unmask = 1;
 	hwif->drives[1].no_unmask = 1;
-	hwif->drives[0].io_32bit = 1;
-	hwif->drives[1].io_32bit = 1;
-	hwif->mate = mate;
 
-	mate->serialized = 1;
 	mate->no_io_32bit = 1;
-	mate->chipset = ide_dtc2278;
-	mate->pio_mask = ATA_PIO4;
 	mate->drives[0].no_unmask = 1;
 	mate->drives[1].no_unmask = 1;
-	mate->drives[0].io_32bit = 1;
-	mate->drives[1].io_32bit = 1;
-	mate->mate = hwif;
-	mate->channel = 1;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &dtc2278_port_info);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -82,7 +82,7 @@ static int __init falconide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
     }
 
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -186,7 +186,7 @@ found:
 	    release_mem_region(res_start, res_n);
     }
 
-    ide_device_add(idx);
+    ide_device_add(idx, NULL);
 
     return 0;
 }
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -305,6 +305,15 @@ int probe_ht6560b = 0;
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
 
+static const struct ide_port_info ht6560b_port_info __initdata = {
+	.chipset		= ide_ht6560b,
+	.host_flags		= IDE_HFLAG_SERIALIZE | /* is this needed? */
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE |
+				  IDE_HFLAG_ABUSE_PREFETCH,
+	.pio_mask		= ATA_PIO5,
+};
+
 static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
@@ -328,22 +337,11 @@ static int __init ht6560b_init(void)
 		goto release_region;
 	}
 
-	hwif->chipset = ide_ht6560b;
 	hwif->selectproc = &ht6560b_selectproc;
-	hwif->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
-	hwif->pio_mask = ATA_PIO5;
 	hwif->set_pio_mode = &ht6560b_set_pio_mode;
-	hwif->serialized = 1;	/* is this needed? */
-	hwif->mate = mate;
 
-	mate->chipset = ide_ht6560b;
 	mate->selectproc = &ht6560b_selectproc;
-	mate->host_flags = IDE_HFLAG_ABUSE_PREFETCH;
-	mate->pio_mask = ATA_PIO5;
 	mate->set_pio_mode = &ht6560b_set_pio_mode;
-	mate->serialized = 1;	/* is this needed? */
-	mate->mate = hwif;
-	mate->channel = 1;
 
 	/*
 	 * Setting default configurations for drives
@@ -357,7 +355,7 @@ static int __init ht6560b_init(void)
 	mate->drives[0].drive_data = t;
 	mate->drives[1].drive_data = t;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &ht6560b_port_info);
 
 	return 0;
 
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -108,7 +108,7 @@ static int __devinit plat_ide_probe(stru
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	platform_set_drvdata(pdev, hwif);
 
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -125,7 +125,7 @@ static int __init macide_init(void)
 
 		hwif->mmio = 1;
 
-		ide_device_add(idx);
+		ide_device_add(idx, NULL);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -154,7 +154,7 @@ static int __init q40ide_init(void)
 	}
     }
 
-    ide_device_add(idx);
+    ide_device_add(idx, NULL);
 
     return 0;
 }
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -308,15 +308,10 @@ static int __init qd_testreg(int port)
 static void __init qd_setup(ide_hwif_t *hwif, int base, int config,
 			    unsigned int data0, unsigned int data1)
 {
-	hwif->chipset = ide_qd65xx;
-	hwif->channel = hwif->index;
 	hwif->select_data = base;
 	hwif->config_data = config;
 	hwif->drives[0].drive_data = data0;
 	hwif->drives[1].drive_data = data1;
-	hwif->drives[0].io_32bit =
-	hwif->drives[1].io_32bit = 1;
-	hwif->pio_mask = ATA_PIO4;
 }
 
 /*
@@ -356,6 +351,14 @@ static void __exit qd_unsetup(ide_hwif_t
 }
 */
 
+static const struct ide_port_info qd65xx_port_info __initdata = {
+	.chipset		= ide_qd65xx,
+	.host_flags		= IDE_HFLAG_IO_32BIT |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 /*
  * qd_probe:
  *
@@ -397,9 +400,9 @@ static int __init qd_probe(int base)
 
 		hwif->set_pio_mode = &qd6500_set_pio_mode;
 
-		idx[0] = unit;
+		idx[unit] = unit;
 
-		ide_device_add(idx);
+		ide_device_add(idx, &qd65xx_port_info);
 
 		return 1;
 	}
@@ -431,9 +434,9 @@ static int __init qd_probe(int base)
 
 			hwif->set_pio_mode = &qd6580_set_pio_mode;
 
-			idx[0] = unit;
+			idx[unit] = unit;
 
-			ide_device_add(idx);
+			ide_device_add(idx, &qd65xx_port_info);
 
 			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
@@ -460,7 +463,7 @@ static int __init qd_probe(int base)
 			idx[0] = 0;
 			idx[1] = 1;
 
-			ide_device_add(idx);
+			ide_device_add(idx, &qd65xx_port_info);
 
 			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -120,9 +120,14 @@ static void umc_set_pio_mode(ide_drive_t
 	spin_unlock_irqrestore(&ide_lock, flags);
 }
 
+static const struct ide_port_info umc8672_port_info __initdata = {
+	.chipset		= ide_umc8672,
+	.host_flags		= IDE_HFLAG_NO_DMA | IDE_HFLAG_NO_AUTOTUNE,
+	.pio_mask		= ATA_PIO4,
+};
+
 static int __init umc8672_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
 	static u8 idx[4] = { 0, 1, 0xff, 0xff };
 
@@ -143,21 +148,10 @@ static int __init umc8672_probe(void)
 	umc_set_speeds (current_speeds);
 	local_irq_restore(flags);
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	hwif->chipset = ide_umc8672;
-	hwif->pio_mask = ATA_PIO4;
-	hwif->set_pio_mode = &umc_set_pio_mode;
-	hwif->mate = mate;
-
-	mate->chipset = ide_umc8672;
-	mate->pio_mask = ATA_PIO4;
-	mate->set_pio_mode = &umc_set_pio_mode;
-	mate->mate = hwif;
-	mate->channel = 1;
+	ide_hwifs[0].set_pio_mode = &umc_set_pio_mode;
+	ide_hwifs[1].set_pio_mode = &umc_set_pio_mode;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &umc8672_port_info);
 
 	return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -548,6 +548,16 @@ static void auide_setup_ports(hw_regs_t 
 	*ata_regs = ahwif->regbase + (14 << AU1XXX_ATA_REG_OFFSET);
 }
 
+static const struct ide_port_info au1xxx_port_info = {
+	.host_flags		= IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_UNMASK_IRQS,
+	.pio_mask		= ATA_PIO4,
+#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
+	.mwdma_mask		= ATA_MWDMA2,
+#endif
+};
+
 static int au_ide_probe(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -606,21 +616,6 @@ static int au_ide_probe(struct device *d
 
 	hwif->dev = dev;
 
-	hwif->ultra_mask                = 0x0;  /* Disable Ultra DMA */
-#ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
-	hwif->mwdma_mask                = 0x07; /* Multimode-2 DMA  */
-	hwif->swdma_mask                = 0x00;
-#else
-	hwif->mwdma_mask                = 0x0;
-	hwif->swdma_mask                = 0x0;
-#endif
-
-	hwif->pio_mask = ATA_PIO4;
-	hwif->host_flags = IDE_HFLAG_POST_SET_MODE;
-
-	hwif->drives[0].unmask          = 1;
-	hwif->drives[1].unmask          = 1;
-
 	/* hold should be on in all cases */
 	hwif->hold                      = 1;
 
@@ -651,13 +646,9 @@ static int au_ide_probe(struct device *d
 	hwif->ide_dma_test_irq          = &auide_dma_test_irq;
 	hwif->dma_lost_irq		= &auide_dma_lost_irq;
 #endif
-	hwif->channel                   = 0;
 	hwif->select_data               = 0;    /* no chipset-specific code */
 	hwif->config_data               = 0;    /* no chipset-specific code */
 
-	hwif->drives[0].autotune        = 1;    /* 1=autotune, 2=noautotune, 0=default */
-	hwif->drives[1].autotune	= 1;
-
 	hwif->no_io_32bit		= 1;
 
 	auide_hwif.hwif                 = hwif;
@@ -670,7 +661,7 @@ static int au_ide_probe(struct device *d
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &au1xxx_port_info);
 
 	dev_set_drvdata(dev, hwif);
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -129,7 +129,7 @@ static int __devinit swarm_ide_probe(str
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	dev_set_drvdata(dev, hwif);
 
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -703,6 +703,18 @@ static int pci_conf2(void)
 	return 0;
 }
 
+static const struct ide_port_info cmd640_port_info __initdata = {
+	.chipset		= ide_cmd640,
+	.host_flags		= IDE_HFLAG_SERIALIZE |
+				  IDE_HFLAG_NO_DMA |
+				  IDE_HFLAG_NO_AUTOTUNE |
+				  IDE_HFLAG_ABUSE_PREFETCH |
+				  IDE_HFLAG_ABUSE_FAST_DEVSEL,
+#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
+	.pio_mask		= ATA_PIO5,
+#endif
+};
+
 /*
  * Probe for a cmd640 chipset, and initialize it if found.
  */
@@ -760,11 +772,7 @@ static int __init cmd640x_init(void)
 	setup_device_ptrs ();
 	printk("%s: buggy cmd640%c interface on %s, config=0x%02x\n",
 	       cmd_hwif0->name, 'a' + cmd640_chip_version - 1, bus_type, cfr);
-	cmd_hwif0->chipset = ide_cmd640;
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	cmd_hwif0->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
-				IDE_HFLAG_ABUSE_FAST_DEVSEL;
-	cmd_hwif0->pio_mask = ATA_PIO5;
 	cmd_hwif0->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
@@ -815,23 +823,14 @@ static int __init cmd640x_init(void)
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
 	if (second_port_cmd640) {
-		cmd_hwif0->serialized = 1;
-		cmd_hwif1->serialized = 1;
-		cmd_hwif1->chipset = ide_cmd640;
-		cmd_hwif0->mate = cmd_hwif1;
-		cmd_hwif1->mate = cmd_hwif0;
-		cmd_hwif1->channel = 1;
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-		cmd_hwif1->host_flags = IDE_HFLAG_ABUSE_PREFETCH |
-					IDE_HFLAG_ABUSE_FAST_DEVSEL;
-		cmd_hwif1->pio_mask = ATA_PIO5;
+#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 		cmd_hwif1->set_pio_mode = &cmd640_set_pio_mode;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 
 		idx[1] = cmd_hwif1->index;
 	}
 	printk(KERN_INFO "%s: %sserialized, secondary interface %s\n", cmd_hwif1->name,
-		cmd_hwif0->serialized ? "" : "not ", port2);
+			 second_port_cmd640 ? "" : "not ", port2);
 
 	/*
 	 * Establish initial timings/prefetch for all drives.
@@ -876,7 +875,7 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	ide_device_add(idx);
+	ide_device_add(idx, &cmd640_port_info);
 
 	return 1;
 }
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -174,7 +174,7 @@ static int __devinit cs5520_init_one(str
 
 	ide_pci_setup_ports(dev, d, 14, &idx[0]);
 
-	ide_device_add(idx);
+	ide_device_add(idx, d);
 
 	return 0;
 }
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -555,7 +555,6 @@ static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
 	hwif->mmio = 1;
-	hwif->pio_mask = 0x00;
 	hwif->set_pio_mode = NULL; /* Sets timing for PIO mode */
 	hwif->set_dma_mode = &sgiioc4_set_dma_mode;
 	hwif->selectproc = NULL;/* Use the default routine to select drive */
@@ -572,8 +571,6 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	if (hwif->dma_base == 0)
 		return;
 
-	hwif->mwdma_mask = ATA_MWDMA2_ONLY;
-
 	hwif->dma_host_set = &sgiioc4_dma_host_set;
 	hwif->dma_setup = &sgiioc4_ide_dma_setup;
 	hwif->dma_start = &sgiioc4_ide_dma_start;
@@ -583,6 +580,13 @@ ide_init_sgiioc4(ide_hwif_t * hwif)
 	hwif->dma_timeout = &ide_dma_timeout;
 }
 
+static const struct ide_port_info sgiioc4_port_info __devinitdata = {
+	.chipset		= ide_pci,
+	.host_flags		= IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_NO_AUTOTUNE,
+	.mwdma_mask		= ATA_MWDMA2_ONLY,
+};
+
 static int __devinit
 sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 {
@@ -593,6 +597,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	int h;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
+	struct ide_port_info d = sgiioc4_port_info;
 
 	/*
 	 * Find an empty HWIF; if none available, return -ENOMEM.
@@ -641,7 +646,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->dev = &dev->dev;
-	hwif->channel = 0;	/* Single Channel chip */
 
 	/* The IOC4 uses MMIO rather than Port IO. */
 	default_hwif_mmiops(hwif);
@@ -649,15 +653,17 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base))
+	if (dma_base == 0 || ide_dma_sgiioc4(hwif, dma_base)) {
 		printk(KERN_INFO "%s: %s Bus-Master DMA disabled\n",
 				 hwif->name, DRV_NAME);
+		d.mwdma_mask = 0;
+	}
 
 	ide_init_sgiioc4(hwif);
 
 	idx[0] = hwif->index;
 
-	if (ide_device_add(idx))
+	if (ide_device_add(idx, &d))
 		return -EIO;
 
 	return 0;
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -848,7 +848,7 @@ static int __init mpc8xx_ide_probe(void)
 #endif
 #endif
 
-	ide_device_add(idx);
+	ide_device_add(idx, NULL);
 
 	return 0;
 }
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -412,7 +412,7 @@ kauai_lookup_timing(struct kauai_timing*
  */
 #define IDE_WAKEUP_DELAY	(1*HZ)
 
-static void pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
+static int pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif);
 static int pmac_ide_build_dmatable(ide_drive_t *drive, struct request *rq);
 static void pmac_ide_selectproc(ide_drive_t *drive);
 static void pmac_ide_kauai_selectproc(ide_drive_t *drive);
@@ -1003,6 +1003,17 @@ pmac_ide_do_resume(ide_hwif_t *hwif)
 	return 0;
 }
 
+static const struct ide_port_info pmac_port_info = {
+	.chipset		= ide_pmac,
+	.host_flags		= IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
+				  IDE_HFLAG_PIO_NO_DOWNGRADE |
+				  IDE_HFLAG_POST_SET_MODE |
+				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
+				  IDE_HFLAG_UNMASK_IRQS,
+	.pio_mask		= ATA_PIO4,
+	.mwdma_mask		= ATA_MWDMA2,
+};
+
 /*
  * Setup, register & probe an IDE channel driven by this driver, this is
  * called by one of the 2 probe functions (macio or PCI). Note that a channel
@@ -1016,23 +1027,28 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	struct device_node *np = pmif->node;
 	const int *bidp;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_port_info d = pmac_port_info;
 
 	pmif->cable_80 = 0;
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
-	if (of_device_is_compatible(np, "shasta-ata"))
+	if (of_device_is_compatible(np, "shasta-ata")) {
 		pmif->kind = controller_sh_ata6;
-	else if (of_device_is_compatible(np, "kauai-ata"))
+		d.udma_mask = ATA_UDMA6;
+	} else if (of_device_is_compatible(np, "kauai-ata")) {
 		pmif->kind = controller_un_ata6;
-	else if (of_device_is_compatible(np, "K2-UATA"))
+		d.udma_mask = ATA_UDMA5;
+	} else if (of_device_is_compatible(np, "K2-UATA")) {
 		pmif->kind = controller_k2_ata6;
-	else if (of_device_is_compatible(np, "keylargo-ata")) {
-		if (strcmp(np->name, "ata-4") == 0)
+		d.udma_mask = ATA_UDMA5;
+	} else if (of_device_is_compatible(np, "keylargo-ata")) {
+		if (strcmp(np->name, "ata-4") == 0) {
 			pmif->kind = controller_kl_ata4;
-		else
+			d.udma_mask = ATA_UDMA4;
+		} else
 			pmif->kind = controller_kl_ata3;
-	} else if (of_device_is_compatible(np, "heathrow-ata"))
+	} else if (of_device_is_compatible(np, "heathrow-ata")) {
 		pmif->kind = controller_heathrow;
-	else {
+	} else {
 		pmif->kind = controller_ohare;
 		pmif->broken_dma = 1;
 	}
@@ -1101,19 +1117,10 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	/* Tell common code _not_ to mess with resources */
 	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
-	hw->chipset = ide_pmac;
 	ide_init_port_hw(hwif, hw);
 	hwif->noprobe = pmif->mediabay;
 	hwif->hold = pmif->mediabay;
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
-	hwif->drives[0].unmask = 1;
-	hwif->drives[1].unmask = 1;
-	hwif->drives[0].autotune = IDE_TUNE_AUTO;
-	hwif->drives[1].autotune = IDE_TUNE_AUTO;
-	hwif->host_flags = IDE_HFLAG_SET_PIO_MODE_KEEP_DMA |
-			   IDE_HFLAG_PIO_NO_DOWNGRADE |
-			   IDE_HFLAG_POST_SET_MODE;
-	hwif->pio_mask = ATA_PIO4;
 	hwif->set_pio_mode = pmac_ide_set_pio_mode;
 	if (pmif->kind == controller_un_ata6
 	    || pmif->kind == controller_k2_ata6
@@ -1133,14 +1140,16 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 #endif /* CONFIG_PMAC_MEDIABAY */
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
+	if (pmif->cable_80 == 0)
+		d.udma_mask &= ATA_UDMA2;
 	/* has a DBDMA controller channel */
-	if (pmif->dma_regs)
-		pmac_ide_setup_dma(pmif, hwif);
-#endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
+	if (pmif->dma_regs == 0 || pmac_ide_setup_dma(pmif, hwif) < 0)
+#endif
+		d.udma_mask = d.mwdma_mask = 0;
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx);
+	ide_device_add(idx, &d);
 
 	return 0;
 }
@@ -1721,8 +1730,7 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
  * Allocate the data structures needed for using DMA with an interface
  * and fill the proper list of functions pointers
  */
-static void __init 
-pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
+static int __init pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
 
@@ -1730,7 +1738,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif
 	 * DMA routines ...
 	 */
 	if (dev == NULL)
-		return;
+		return -ENODEV;
 	/*
 	 * Allocate space for the DBDMA commands.
 	 * The +2 is +1 for the stop command and +1 to allow for
@@ -1743,7 +1751,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif
 	if (pmif->dma_table_cpu == NULL) {
 		printk(KERN_ERR "%s: unable to allocate DMA command list\n",
 		       hwif->name);
-		return;
+		return -ENOMEM;
 	}
 
 	hwif->sg_max_nents = MAX_DCMDS;
@@ -1757,29 +1765,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif
 	hwif->dma_timeout = &ide_dma_timeout;
 	hwif->dma_lost_irq = &pmac_ide_dma_lost_irq;
 
-	switch(pmif->kind) {
-		case controller_sh_ata6:
-			hwif->ultra_mask = pmif->cable_80 ? 0x7f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		case controller_un_ata6:
-		case controller_k2_ata6:
-			hwif->ultra_mask = pmif->cable_80 ? 0x3f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		case controller_kl_ata4:
-			hwif->ultra_mask = pmif->cable_80 ? 0x1f : 0x07;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-		default:
-			hwif->ultra_mask = 0x00;
-			hwif->mwdma_mask = 0x07;
-			hwif->swdma_mask = 0x00;
-			break;
-	}
+	return 0;
 }
 
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -399,20 +399,20 @@ static ide_hwif_t *ide_hwif_configure(st
 	return hwif;
 }
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
 /**
  *	ide_hwif_setup_dma	-	configure DMA interface
- *	@dev: PCI device
- *	@d: IDE port info
  *	@hwif: IDE interface
+ *	@d: IDE port info
  *
  *	Set up the DMA base for the interface. Enable the master bits as
  *	necessary and attempt to bring the device DMA into a ready to use
  *	state
  */
 
-static void ide_hwif_setup_dma(struct pci_dev *dev, const struct ide_port_info *d, ide_hwif_t *hwif)
+void ide_hwif_setup_dma(ide_hwif_t *hwif, const struct ide_port_info *d)
 {
-#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+	struct pci_dev *dev = to_pci_dev(hwif->dev);
 	u16 pcicmd;
 
 	pci_read_config_word(dev, PCI_COMMAND, &pcicmd);
@@ -444,8 +444,8 @@ static void ide_hwif_setup_dma(struct pc
 				"(BIOS)\n", hwif->name, d->name);
 		}
 	}
-#endif /* CONFIG_BLK_DEV_IDEDMA_PCI*/
 }
+#endif /* CONFIG_BLK_DEV_IDEDMA_PCI */
 
 /**
  *	ide_setup_pci_controller	-	set up IDE PCI
@@ -507,7 +507,7 @@ out:
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int pciirq, u8 *idx)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
-	ide_hwif_t *hwif, *mate = NULL;
+	ide_hwif_t *hwif;
 	u8 tmp;
 
 	/*
@@ -529,71 +529,6 @@ void ide_pci_setup_ports(struct pci_dev 
 
 		*(idx + port) = hwif->index;
 	}
-
-	for (port = 0; port < channels; ++port) {
-		if (*(idx + port) == 0xff)
-			continue;
-
-		hwif = &ide_hwifs[*(idx + port)];
-
-		if (mate) {
-			hwif->mate = mate;
-			mate->mate = hwif;
-		}
-
-		hwif->channel = port;
-
-		if (d->init_iops)
-			d->init_iops(hwif);
-
-		if ((d->host_flags & IDE_HFLAG_NO_DMA) == 0)
-			ide_hwif_setup_dma(dev, d, hwif);
-
-		if ((!hwif->irq && (d->host_flags & IDE_HFLAG_LEGACY_IRQS)) ||
-		    (d->host_flags & IDE_HFLAG_FORCE_LEGACY_IRQS))
-			hwif->irq = port ? 15 : 14;
-
-		hwif->host_flags = d->host_flags;
-		hwif->pio_mask = d->pio_mask;
-
-		if ((d->host_flags & IDE_HFLAG_SERIALIZE) && hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-
-		if (d->host_flags & IDE_HFLAG_IO_32BIT) {
-			hwif->drives[0].io_32bit = 1;
-			hwif->drives[1].io_32bit = 1;
-		}
-
-		if (d->host_flags & IDE_HFLAG_UNMASK_IRQS) {
-			hwif->drives[0].unmask = 1;
-			hwif->drives[1].unmask = 1;
-		}
-
-		hwif->swdma_mask = d->swdma_mask;
-		hwif->mwdma_mask = d->mwdma_mask;
-		hwif->ultra_mask = d->udma_mask;
-
-		if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 &&
-		    hwif->dma_base == 0) {
-			hwif->swdma_mask = 0;
-			hwif->mwdma_mask = 0;
-			hwif->ultra_mask = 0;
-		}
-
-		hwif->drives[0].autotune = 1;
-		hwif->drives[1].autotune = 1;
-
-		if (d->host_flags & IDE_HFLAG_RQSIZE_256)
-			hwif->rqsize = 256;
-
-		if (d->init_hwif)
-			/* Call chipset-specific routine
-			 * for each enabled hwif
-			 */
-			d->init_hwif(hwif);
-
-		mate = hwif;
-	}
 }
 
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
@@ -674,7 +609,7 @@ int ide_setup_pci_device(struct pci_dev 
 	ret = do_ide_setup_pci_device(dev, d, &idx[0], 1);
 
 	if (ret >= 0)
-		ide_device_add(idx);
+		ide_device_add(idx, d);
 
 	return ret;
 }
@@ -698,7 +633,7 @@ int ide_setup_pci_devices(struct pci_dev
 			goto out;
 	}
 
-	ide_device_add(idx);
+	ide_device_add(idx, d);
 out:
 	return ret;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1019,6 +1019,13 @@ extern int __ide_pci_register_driver(str
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA_PCI
+void ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
+#else
+static inline void ide_hwif_setup_dma(ide_hwif_t *hwif,
+				      const struct ide_port_info *d) { }
+#endif
+
 extern void default_hwif_iops(ide_hwif_t *);
 extern void default_hwif_mmiops(ide_hwif_t *);
 extern void default_hwif_transport(ide_hwif_t *);
@@ -1092,6 +1099,8 @@ enum {
 	IDE_HFLAG_CLEAR_SIMPLEX		= (1 << 28),
 	/* DSC overlap is unsupported */
 	IDE_HFLAG_NO_DSC		= (1 << 29),
+	/* don't autotune PIO */
+	IDE_HFLAG_NO_AUTOTUNE		= (1 << 30),
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
@@ -1204,8 +1213,8 @@ void ide_unregister_region(struct gendis
 
 void ide_undecoded_slave(ide_drive_t *);
 
-int ide_device_add_all(u8 *idx);
-int ide_device_add(u8 idx[4]);
+int ide_device_add_all(u8 *idx, const struct ide_port_info *);
+int ide_device_add(u8 idx[4], const struct ide_port_info *);
 
 static inline void *ide_get_hwifdata (ide_hwif_t * hwif)
 {
