Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbYCAUqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbYCAUqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYCAUnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbYCAUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=guehtR+IJQnF3pm04mV8LN0DU4oFHkYduL/PhQj1QiHlRNfVgQuxItWAOPIDF4EXcEdMAT7HbljCHDt2iHgfSlWlBv8eVAAJ60D+3Yb6BJoWH5s7DvIcerLCl4+4my9Oror+8jPs52z/3GVpkdjPzlQpiq7a3NQCL6eouLAzKV0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 9/9] ide: cleanup setting hwif->mmio flag
Date: Sat, 1 Mar 2008 21:55:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803012155.45689.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer needed to set hwif->mmio flag to tell IDE layer to not
manage resources so cleanup host drivers that used hwif->mmio flag only
for this purpose.

Ditto for ide_legacy_init_one().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c        |    1 -
 drivers/ide/arm/icside.c          |    1 -
 drivers/ide/arm/ide_arm.c         |    1 -
 drivers/ide/arm/rapide.c          |    1 -
 drivers/ide/cris/ide-cris.c       |    2 +-
 drivers/ide/h8300/ide-h8300.c     |    1 -
 drivers/ide/ide-generic.c         |    1 -
 drivers/ide/ide-pnp.c             |    1 -
 drivers/ide/ide-probe.c           |    1 -
 drivers/ide/legacy/buddha.c       |    2 --
 drivers/ide/legacy/falconide.c    |    1 -
 drivers/ide/legacy/gayle.c        |    2 --
 drivers/ide/legacy/ide-4drives.c  |    2 --
 drivers/ide/legacy/ide_platform.c |    1 -
 drivers/ide/legacy/macide.c       |    2 --
 drivers/ide/legacy/q40ide.c       |    1 -
 drivers/ide/mips/au1xxx-ide.c     |    2 --
 drivers/ide/mips/swarm.c          |    3 +--
 drivers/ide/pci/cmd640.c          |    2 --
 drivers/ide/pci/delkin_cb.c       |    1 -
 drivers/ide/pci/sgiioc4.c         |    1 -
 drivers/ide/ppc/mpc8xx.c          |    2 --
 drivers/ide/ppc/pmac.c            |    2 --
 23 files changed, 2 insertions(+), 32 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -55,7 +55,6 @@ static int __init bastide_register(unsig
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
 	hwif->quirkproc = NULL;
 
 	idx[0] = i;
Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -416,7 +416,6 @@ icside_setup(void __iomem *base, struct 
 		 * Ensure we're using MMIO
 		 */
 		default_hwif_mmiops(hwif);
-		hwif->mmio = 1;
 
 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++) {
 			hwif->io_ports[i] = port;
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -53,7 +53,6 @@ static int __init ide_arm_init(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 		idx[0] = hwif->index;
 
 		ide_device_add(idx, NULL);
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -53,7 +53,6 @@ rapide_probe(struct expansion_card *ec, 
 
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->mmio = 1;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -815,7 +815,7 @@ static int __init init_e100_ide(void)
 			continue;
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
+
 		hwif->ata_input_data = &cris_ide_input_data;
 		hwif->ata_output_data = &cris_ide_output_data;
 		hwif->atapi_input_bytes = &cris_atapi_input_bytes;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -74,7 +74,6 @@ static inline void hwif_setup(ide_hwif_t
 {
 	default_hwif_iops(hwif);
 
-	hwif->mmio  = 1;
 	hwif->OUTW  = mm_outw;
 	hwif->OUTSW = mm_outsw;
 	hwif->INW   = mm_inw;
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -126,7 +126,6 @@ static int __init ide_generic_init(void)
 			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
 			hw.irq = ide_default_irq(io_addr);
 			ide_init_port_hw(hwif, &hw);
-			hwif->mmio = 1;
 
 			idx[i] = i;
 		}
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -63,7 +63,6 @@ static int idepnp_probe(struct pnp_dev *
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev, hwif);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1657,7 +1657,6 @@ static void ide_legacy_init_one(u8 *idx,
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
 		ide_init_port_hw(hwif, hw);
-		hwif->mmio = 1;
 		if (config)
 			hwif->config_data = config;
 		idx[port_no] = hwif->index;
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -228,8 +228,6 @@ fail_base2:
 				ide_init_port_data(hwif, index);
 				ide_init_port_hw(hwif, &hw);
 
-				hwif->mmio = 1;
-
 				idx[i] = index;
 			}
 		}
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -89,7 +89,6 @@ static int __init falconide_init(void)
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -182,8 +182,6 @@ found:
 	    ide_init_port_data(hwif, index);
 	    ide_init_port_hw(hwif, &hw);
 
-	    hwif->mmio = 1;
-
 	    idx[i] = index;
 	} else
 	    release_mem_region(res_start, res_n);
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -43,7 +43,6 @@ static int __init ide_4drives_init(void)
 	hwif = ide_find_port();
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 		idx[0] = hwif->index;
 	}
 
@@ -52,7 +51,6 @@ static int __init ide_4drives_init(void)
 		ide_init_port_hw(mate, &hw);
 		mate->drives[0].select.all ^= 0x20;
 		mate->drives[1].select.all ^= 0x20;
-		mate->mmio = 1;
 		idx[1] = mate->index;
 
 		if (hwif) {
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -100,7 +100,6 @@ static int __devinit plat_ide_probe(stru
 	hw.dev = &pdev->dev;
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
 
 	if (mmio)
 		default_hwif_mmiops(hwif);
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -128,8 +128,6 @@ static int __init macide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->mmio = 1;
-
 		ide_device_add(idx, NULL);
 	}
 
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -141,7 +141,6 @@ static int __init q40ide_init(void)
 	if (hwif) {
 		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 
 		idx[i] = hwif->index;
 	}
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -628,8 +628,6 @@ static int au_ide_probe(struct device *d
 
 	hwif->dev = dev;
 
-	hwif->mmio  = 1;
-
 	/* If the user has selected DDMA assisted copies,
 	   then set up a few local I/O function entry points 
 	*/
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -110,8 +110,7 @@ static int __devinit swarm_ide_probe(str
 
 	/* Setup MMIO ops.  */
 	default_hwif_mmiops(hwif);
-	/* Prevent resource map manipulation.  */
-	hwif->mmio = 1;
+
 	hwif->chipset = ide_generic;
 
 	for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; i++)
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -787,7 +787,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (cmd_hwif0) {
 		ide_init_port_hw(cmd_hwif0, &hw[0]);
-		cmd_hwif0->mmio = 1;
 		idx[0] = cmd_hwif0->index;
 	}
 
@@ -840,7 +839,6 @@ static int __init cmd640x_init(void)
 	 */
 	if (second_port_cmd640 && cmd_hwif1) {
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
-		cmd_hwif1->mmio = 1;
 		idx[1] = cmd_hwif1->index;
 	}
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -93,7 +93,6 @@ delkin_cb_probe (struct pci_dev *dev, co
 		ide_init_port_data(hwif, i);
 
 	ide_init_port_hw(hwif, &hw);
-	hwif->mmio = 1;
 	hwif->port_ops = &delkin_cb_port_ops;
 
 	idx[0] = i;
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -551,7 +551,6 @@ static int sgiioc4_ide_dma_setup(ide_dri
 static void __devinit
 ide_init_sgiioc4(ide_hwif_t * hwif)
 {
-	hwif->mmio = 1;
 	hwif->INB = &sgiioc4_INB;
 
 	if (hwif->dma_base == 0)
Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -814,7 +814,6 @@ static int __init mpc8xx_ide_probe(void)
 		ide_hwif_t *hwif = &ide_hwifs[0];
 
 		ide_init_port_hw(hwif, &hw);
-		hwif->mmio = 1;
 		hwif->pio_mask = ATA_PIO4;
 		hwif->port_ops = &m8xx_port_ops;
 
@@ -826,7 +825,6 @@ static int __init mpc8xx_ide_probe(void)
 		ide_hwif_t *mate = &ide_hwifs[1];
 
 		ide_init_port_hw(mate, &hw);
-		mate->mmio = 1;
 		mate->pio_mask = ATA_PIO4;
 		mate->port_ops = &m8xx_port_ops;
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1045,8 +1045,6 @@ pmac_ide_setup_device(pmac_ide_hwif_t *p
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
 
-	/* Tell common code _not_ to mess with resources */
-	hwif->mmio = 1;
 	hwif->hwif_data = pmif;
 	ide_init_port_hw(hwif, hw);
 	hwif->cbl = pmif->cable_80 ? ATA_CBL_PATA80 : ATA_CBL_PATA40;
