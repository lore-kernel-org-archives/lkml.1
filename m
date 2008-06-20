Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbYFTS2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbYFTS2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYFTS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:28:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:15667 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYFTS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=M8jKIcWEsQp6WdfyQmvTM+26/FtLCupVj7BOYEFiSFLTsETY/240gNsddf8rQRGjZN
         kwZACsLVAinmv43lG5tkgsU7qQZW0G+9AfEefNuh4UT6I9ik7VlLyROm4Je1OkqvjOdV
         tj0LpYIRFNhBM0TjCkVDwIe8CfY3R7MIu6fqI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: pass hw_regs_t-s to ide_device_add[_all]()
Date: Fri, 20 Jun 2008 20:29:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806202029.11304.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'hw_regs_t **hws' argument to ide_device_add[_all]() and convert
  host drivers + drivers/ide/setup-pci.c to use it instead of calling
  ide_init_port_hw() directly (however if host has more than 1 port we
  must still set hwif->chipset to hint consecutive ide_find_port() call
  that the ide_hwifs[] slot is occupied).

* Unexport ide_init_port_hw().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c          |   13 ++++++-------
 drivers/ide/arm/ide_arm.c         |    5 ++---
 drivers/ide/arm/palm_bk3710.c     |    6 ++----
 drivers/ide/arm/rapide.c          |    5 ++---
 drivers/ide/h8300/ide-h8300.c     |    5 ++---
 drivers/ide/ide-generic.c         |   23 ++++++++++++-----------
 drivers/ide/ide-pnp.c             |    6 ++----
 drivers/ide/ide-probe.c           |   29 ++++++++++++++++++-----------
 drivers/ide/ide.c                 |    1 -
 drivers/ide/legacy/buddha.c       |   14 +++++++-------
 drivers/ide/legacy/falconide.c    |    6 ++----
 drivers/ide/legacy/gayle.c        |   13 ++++++-------
 drivers/ide/legacy/ide-4drives.c  |   10 ++++++----
 drivers/ide/legacy/ide-cs.c       |    8 +++-----
 drivers/ide/legacy/ide_platform.c |    9 +++------
 drivers/ide/legacy/macide.c       |    6 ++----
 drivers/ide/legacy/q40ide.c       |   14 ++++++--------
 drivers/ide/mips/au1xxx-ide.c     |    6 ++----
 drivers/ide/mips/swarm.c          |    6 ++----
 drivers/ide/pci/cmd640.c          |   10 ++++++----
 drivers/ide/pci/cs5520.c          |    5 +++--
 drivers/ide/pci/delkin_cb.c       |    6 ++----
 drivers/ide/pci/scc_pata.c        |    5 ++---
 drivers/ide/pci/sgiioc4.c         |    6 ++----
 drivers/ide/ppc/pmac.c            |    5 ++---
 drivers/ide/setup-pci.c           |   38 +++++++++++++++++++++++---------------
 include/linux/ide.h               |    7 ++++---
 27 files changed, 129 insertions(+), 138 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -442,8 +442,8 @@ icside_register_v5(struct icside_state *
 {
 	ide_hwif_t *hwif;
 	void __iomem *base;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -467,7 +467,6 @@ icside_register_v5(struct icside_state *
 	if (!hwif)
 		return -ENODEV;
 
-	ide_init_port_hw(hwif, &hw);
 	default_hwif_mmiops(hwif);
 
 	state->hwif[0] = hwif;
@@ -476,7 +475,7 @@ icside_register_v5(struct icside_state *
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, NULL, hws);
 
 	return 0;
 }
@@ -497,9 +496,9 @@ icside_register_v6(struct icside_state *
 	void __iomem *ioc_base, *easi_base;
 	unsigned int sel = 0;
 	int ret;
+	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = icside_v6_port_info;
-	hw_regs_t hw[2];
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
 	if (!ioc_base) {
@@ -545,16 +544,16 @@ icside_register_v6(struct icside_state *
 	if (hwif == NULL)
 		return -ENODEV;
 
-	ide_init_port_hw(hwif, &hw[0]);
+	hwif->chipset = ide_acorn;
 	default_hwif_mmiops(hwif);
 
 	idx[0] = hwif->index;
 
 	mate = ide_find_port();
 	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
 		default_hwif_mmiops(mate);
 
+		hws[1] = &hw[1];
 		idx[1] = mate->index;
 	}
 
@@ -569,7 +568,7 @@ icside_register_v6(struct icside_state *
 		d.dma_ops = NULL;
 	}
 
-	ide_device_add(idx, &d);
+	ide_device_add(idx, &d, hws);
 
 	return 0;
 
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -29,8 +29,8 @@
 static int __init ide_arm_init(void)
 {
 	ide_hwif_t *hwif;
-	hw_regs_t hw;
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!request_region(base, 8, DRV_NAME)) {
@@ -53,10 +53,9 @@ static int __init ide_arm_init(void)
 
 	hwif = ide_find_port();
 	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
 
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, NULL, hws);
 	}
 
 	return 0;
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -353,7 +353,7 @@ static int __devinit palm_bk3710_probe(s
 	ide_hwif_t *hwif;
 	unsigned long base;
 	int i;
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	clkp = clk_get(NULL, "IDECLK");
@@ -402,13 +402,11 @@ static int __devinit palm_bk3710_probe(s
 
 	i = hwif->index;
 
-	ide_init_port_hw(hwif, &hw);
-
 	default_hwif_mmiops(hwif);
 
 	idx[0] = i;
 
-	ide_device_add(idx, &palm_bk3710_port_info);
+	ide_device_add(idx, &palm_bk3710_port_info, hws);
 
 	return 0;
 out:
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -35,8 +35,8 @@ rapide_probe(struct expansion_card *ec, 
 	ide_hwif_t *hwif;
 	void __iomem *base;
 	int ret;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -59,12 +59,11 @@ rapide_probe(struct expansion_card *ec, 
 		goto release;
 	}
 
-	ide_init_port_hw(hwif, &hw);
 	default_hwif_mmiops(hwif);
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, &rapide_port_info);
+	ide_device_add(idx, &rapide_port_info, hws);
 
 	ecard_set_drvdata(ec, hwif);
 	goto out;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -184,9 +184,9 @@ static const struct ide_port_info h8300_
 
 static int __init h8300_ide_init(void)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
 	int index;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
@@ -205,12 +205,11 @@ static int __init h8300_ide_init(void)
 		return -ENOENT;
 
 	index = hwif->index;
-	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
 
 	idx[0] = index;
 
-	ide_device_add(idx, &h8300_port_info);
+	ide_device_add(idx, &h8300_port_info, hws);
 
 	return 0;
 
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -31,7 +31,7 @@ static ssize_t store_add(struct class *c
 	ide_hwif_t *hwif;
 	unsigned int base, ctl;
 	int irq;
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
@@ -46,11 +46,9 @@ static ssize_t store_add(struct class *c
 	hw.irq = irq;
 	hw.chipset = ide_generic;
 
-	ide_init_port_hw(hwif, &hw);
-
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, NULL, hws);
 
 	return n;
 };
@@ -90,6 +88,7 @@ static int __init ide_generic_sysfs_init
 
 static int __init ide_generic_init(void)
 {
+	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
 	u8 idx[MAX_HWIFS];
 	int i;
 
@@ -99,8 +98,8 @@ static int __init ide_generic_init(void)
 	for (i = 0; i < MAX_HWIFS; i++) {
 		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
-		hw_regs_t hw;
 
+		hws[i] = NULL;
 		idx[i] = 0xff;
 
 		if ((probe_mask & (1 << i)) && io_addr) {
@@ -129,17 +128,19 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			memset(&hw, 0, sizeof(hw));
-			ide_std_init_ports(&hw, io_addr, io_addr + 0x206);
-			hw.irq = ide_default_irq(io_addr);
-			hw.chipset = ide_generic;
-			ide_init_port_hw(hwif, &hw);
+			hwif->chipset = ide_generic;
+
+			memset(&hw[i], 0, sizeof(hw[i]));
+			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
+			hw[i].irq = ide_default_irq(io_addr);
+			hw[i].chipset = ide_generic;
 
+			hws[i] = &hw[i];
 			idx[i] = i;
 		}
 	}
 
-	ide_device_add_all(idx, NULL);
+	ide_device_add_all(idx, NULL, hws);
 
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,9 +29,9 @@ static struct pnp_device_id idepnp_devic
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
 	unsigned long base, ctl;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
 
@@ -64,11 +64,9 @@ static int idepnp_probe(struct pnp_dev *
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_hw(hwif, &hw);
-
 		pnp_set_drvdata(dev, hwif);
 
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, NULL, hws);
 
 		return 0;
 	}
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1507,7 +1507,7 @@ out_found:
 }
 EXPORT_SYMBOL_GPL(ide_find_port_slot);
 
-int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
+int ide_device_add_all(u8 *idx, const struct ide_port_info *d, hw_regs_t **hws)
 {
 	ide_hwif_t *hwif, *mate = NULL;
 	int i, rc = 0;
@@ -1520,6 +1520,7 @@ int ide_device_add_all(u8 *idx, const st
 
 		hwif = &ide_hwifs[idx[i]];
 
+		ide_init_port_hw(hwif, hws[i]);
 		ide_port_apply_params(hwif);
 
 		if (d == NULL) {
@@ -1609,15 +1610,18 @@ int ide_device_add_all(u8 *idx, const st
 }
 EXPORT_SYMBOL_GPL(ide_device_add_all);
 
-int ide_device_add(u8 idx[4], const struct ide_port_info *d)
+int ide_device_add(u8 *idx, const struct ide_port_info *d, hw_regs_t **hws)
 {
+	hw_regs_t *hws_all[MAX_HWIFS];
 	u8 idx_all[MAX_HWIFS];
 	int i;
 
-	for (i = 0; i < MAX_HWIFS; i++)
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hws_all[i] = (i < 4) ? hws[i] : NULL;
 		idx_all[i] = (i < 4) ? idx[i] : 0xff;
+	}
 
-	return ide_device_add_all(idx_all, d);
+	return ide_device_add_all(idx_all, d, hws_all);
 }
 EXPORT_SYMBOL_GPL(ide_device_add);
 
@@ -1640,8 +1644,8 @@ void ide_port_scan(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
 
-static void ide_legacy_init_one(u8 *idx, hw_regs_t *hw, u8 port_no,
-				const struct ide_port_info *d,
+static void ide_legacy_init_one(u8 *idx, hw_regs_t **hws, hw_regs_t *hw,
+				u8 port_no, const struct ide_port_info *d,
 				unsigned long config)
 {
 	ide_hwif_t *hwif;
@@ -1677,9 +1681,12 @@ static void ide_legacy_init_one(u8 *idx,
 
 	hwif = ide_find_port_slot(d);
 	if (hwif) {
-		ide_init_port_hw(hwif, hw);
+		hwif->chipset = hw->chipset;
+
 		if (config)
 			hwif->config_data = config;
+
+		hws[port_no] = hw;
 		idx[port_no] = hwif->index;
 	}
 }
@@ -1687,19 +1694,19 @@ static void ide_legacy_init_one(u8 *idx,
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
+	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
 	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
-		ide_legacy_init_one(idx, &hw[0], 0, d, config);
-	ide_legacy_init_one(idx, &hw[1], 1, d, config);
+		ide_legacy_init_one(idx, hws, &hw[0], 0, d, config);
+	ide_legacy_init_one(idx, hws, &hw[1], 1, d, config);
 
 	if (idx[0] == 0xff && idx[1] == 0xff &&
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	ide_device_add(idx, d);
+	ide_device_add(idx, d, hws);
 
 	return 0;
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -288,7 +288,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 	hwif->gendev.parent = hw->parent ? hw->parent : hw->dev;
 	hwif->ack_intr = hw->ack_intr;
 }
-EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
 /*
  *	Locks for IDE setting functionality
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -148,7 +148,6 @@ static void __init buddha_setup_ports(hw
 
 static int __init buddha_init(void)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
 	int i;
 
@@ -159,6 +158,7 @@ static int __init buddha_init(void)
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
+		hw_regs_t hw[3], *hws[] = { NULL, NULL, NULL, NULL };
 		u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
@@ -221,19 +221,19 @@ fail_base2:
 				ack_intr = xsurf_ack_intr;
 			}
 
-			buddha_setup_ports(&hw, base, ctl, irq_port, ack_intr);
+			buddha_setup_ports(&hw[i], base, ctl, irq_port,
+					   ack_intr);
 
 			hwif = ide_find_port();
 			if (hwif) {
-				u8 index = hwif->index;
+				hwif->chipset = ide_generic;
 
-				ide_init_port_hw(hwif, &hw);
-
-				idx[i] = index;
+				hws[i] = &hw[i];
+				idx[i] = hwif->index;
 			}
 		}
 
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, NULL, hws);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -91,8 +91,8 @@ static void __init falconide_setup_ports
 
 static int __init falconide_init(void)
 {
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
 		return 0;
@@ -111,14 +111,12 @@ static int __init falconide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_hw(hwif, &hw);
-
 		/* Atari has a byte-swapped IDE interface */
 		hwif->input_data  = falconide_input_data;
 		hwif->output_data = falconide_output_data;
 
 		ide_get_lock(NULL, NULL);
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, NULL, hws);
 		ide_release_lock();
 	}
 
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -125,6 +125,7 @@ static void __init gayle_setup_ports(hw_
 static int __init gayle_init(void)
 {
     int a4000, i;
+    hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!MACH_IS_AMIGA)
@@ -151,7 +152,6 @@ found:
     for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
 	unsigned long base, ctrlport, irqport;
 	ide_ack_intr_t *ack_intr;
-	hw_regs_t hw;
 	ide_hwif_t *hwif;
 	unsigned long phys_base, res_start, res_n;
 
@@ -179,20 +179,19 @@ found:
 	base = (unsigned long)ZTWO_VADDR(phys_base);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
-	gayle_setup_ports(&hw, base, ctrlport, irqport, ack_intr);
+	gayle_setup_ports(&hw[i], base, ctrlport, irqport, ack_intr);
 
 	hwif = ide_find_port();
 	if (hwif) {
-	    u8 index = hwif->index;
+	    hwif->chipset = ide_generic;
 
-	    ide_init_port_hw(hwif, &hw);
-
-	    idx[i] = index;
+	    hws[i] = &hw[i];
+	    idx[i] = hwif->index;
 	} else
 	    release_mem_region(res_start, res_n);
     }
 
-    ide_device_add(idx, NULL);
+    ide_device_add(idx, NULL, hws);
 
     return 0;
 }
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -30,8 +30,8 @@ static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
 	unsigned long base = 0x1f0, ctl = 0x3f6;
+	hw_regs_t hw, *hws[] = { NULL, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
 
 	if (probe_4drives == 0)
 		return -ENODEV;
@@ -57,17 +57,19 @@ static int __init ide_4drives_init(void)
 
 	hwif = ide_find_port();
 	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
+		hwif->chipset = ide_4drives;
+
+		hws[0] = &hw;
 		idx[0] = hwif->index;
 	}
 
 	mate = ide_find_port();
 	if (mate) {
-		ide_init_port_hw(mate, &hw);
+		hws[1] = &hw;
 		idx[1] = mate->index;
 	}
 
-	ide_device_add(idx, &ide_4drives_port_info);
+	ide_device_add(idx, &ide_4drives_port_info, hws);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -163,8 +163,8 @@ static ide_hwif_t *idecs_register(unsign
 				unsigned long irq, struct pcmcia_device *handle)
 {
     ide_hwif_t *hwif;
-    hw_regs_t hw;
     int i;
+    hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!request_region(io, 8, DRV_NAME)) {
@@ -190,13 +190,11 @@ static ide_hwif_t *idecs_register(unsign
     if (hwif == NULL)
 	goto out_release;
 
-    i = hwif->index;
-
     ide_init_port_hw(hwif, &hw);
 
-    idx[0] = i;
+    idx[0] = hwif->index;
 
-    ide_device_add(idx, &idecs_port_info);
+    ide_device_add(idx, &idecs_port_info, hws);
 
     if (hwif->present)
 	return hwif;
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -54,10 +54,9 @@ static int __devinit plat_ide_probe(stru
 	void __iomem *base, *alt_base;
 	ide_hwif_t *hwif;
 	struct pata_platform_info *pdata;
+	int ret = 0, mmio = 0;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	int ret = 0;
-	int mmio = 0;
-	hw_regs_t hw;
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
@@ -104,8 +103,6 @@ static int __devinit plat_ide_probe(stru
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
 	hw.dev = &pdev->dev;
 
-	ide_init_port_hw(hwif, &hw);
-
 	if (mmio) {
 		d.host_flags |= IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
@@ -113,7 +110,7 @@ static int __devinit plat_ide_probe(stru
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, &d);
+	ide_device_add(idx, &d, hws);
 
 	platform_set_drvdata(pdev, hwif);
 
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -95,7 +95,7 @@ static int __init macide_init(void)
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!MACH_IS_MAC)
 		return -ENODEV;
@@ -130,9 +130,7 @@ static int __init macide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_hw(hwif, &hw);
-
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, NULL, hws);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -112,7 +112,7 @@ static int __init q40ide_init(void)
 {
     int i;
     ide_hwif_t *hwif;
-    const char *name;
+    hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!MACH_IS_Q40)
@@ -121,9 +121,8 @@ static int __init q40ide_init(void)
     printk(KERN_INFO "ide: Q40 IDE controller\n");
 
     for (i = 0; i < Q40IDE_NUM_HWIFS; i++) {
-	hw_regs_t hw;
+	const char *name = q40_ide_names[i];
 
-	name = q40_ide_names[i];
 	if (!request_region(pcide_bases[i], 8, name)) {
 		printk("could not reserve ports %lx-%lx for %s\n",
 		       pcide_bases[i],pcide_bases[i]+8,name);
@@ -135,24 +134,23 @@ static int __init q40ide_init(void)
 		release_region(pcide_bases[i], 8);
 		continue;
 	}
-	q40_ide_setup_ports(&hw, pcide_bases[i],
-			NULL,
-//			m68kide_iops,
+	q40_ide_setup_ports(&hw[i], pcide_bases[i], NULL,
 			q40ide_default_irq(pcide_bases[i]));
 
 	hwif = ide_find_port();
 	if (hwif) {
-		ide_init_port_hw(hwif, &hw);
+		hwif->chipset = ide_generic;
 
 		/* Q40 has a byte-swapped IDE interface */
 		hwif->input_data  = q40ide_input_data;
 		hwif->output_data = q40ide_output_data;
 
+		hws[i] = &hw[i];
 		idx[i] = hwif->index;
 	}
     }
 
-    ide_device_add(idx, NULL);
+    ide_device_add(idx, NULL, hws);
 
     return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -546,8 +546,8 @@ static int au_ide_probe(struct device *d
 	ide_hwif_t *hwif;
 	struct resource *res;
 	int ret = 0;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -596,8 +596,6 @@ static int au_ide_probe(struct device *d
 	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
-	ide_init_port_hw(hwif, &hw);
-
 	/* If the user has selected DDMA assisted copies,
 	   then set up a few local I/O function entry points 
 	*/
@@ -611,7 +609,7 @@ static int au_ide_probe(struct device *d
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, &au1xxx_port_info);
+	ide_device_add(idx, &au1xxx_port_info, hws);
 
 	dev_set_drvdata(dev, hwif);
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -75,8 +75,8 @@ static int __devinit swarm_ide_probe(str
 	ide_hwif_t *hwif;
 	u8 __iomem *base;
 	phys_t offset, size;
-	hw_regs_t hw;
 	int i;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!SIBYTE_HAVE_IDE)
@@ -120,14 +120,12 @@ static int __devinit swarm_ide_probe(str
 	if (hwif == NULL)
 		goto err;
 
-	ide_init_port_hw(hwif, &hw);
-
 	/* Setup MMIO ops. */
 	default_hwif_mmiops(hwif);
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, &swarm_port_info);
+	ide_device_add(idx, &swarm_port_info, hws);
 
 	dev_set_drvdata(dev, hwif);
 
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -717,8 +717,8 @@ static int __init cmd640x_init(void)
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
+	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -787,7 +787,9 @@ static int __init cmd640x_init(void)
 	 * Initialize data for primary port
 	 */
 	if (cmd_hwif0) {
-		ide_init_port_hw(cmd_hwif0, &hw[0]);
+		cmd_hwif0->chipset = ide_cmd640;
+
+		hws[0] = &hw[0];
 		idx[0] = cmd_hwif0->index;
 	}
 
@@ -832,7 +834,7 @@ static int __init cmd640x_init(void)
 	if (second_port_cmd640) {
 		cmd_hwif1 = ide_find_port();
 		if (cmd_hwif1) {
-			ide_init_port_hw(cmd_hwif1, &hw[1]);
+			hws[1] = &hw[1];
 			idx[1] = cmd_hwif1->index;
 		}
 	}
@@ -843,7 +845,7 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	ide_device_add(idx, &cmd640_port_info);
+	ide_device_add(idx, &cmd640_port_info, hws);
 
 	return 1;
 }
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -146,6 +146,7 @@ static const struct ide_port_info cyrix_
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ide_setup_pci_noise(dev, d);
@@ -168,9 +169,9 @@ static int __devinit cs5520_init_one(str
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &idx[0]);
+	ide_pci_setup_ports(dev, d, 14, &idx[0], &hw[0], &hws[0]);
 
-	ide_device_add(idx, d);
+	ide_device_add(idx, d, hws);
 
 	return 0;
 }
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -57,9 +57,9 @@ static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
 	unsigned long base;
-	hw_regs_t hw;
 	ide_hwif_t *hwif = NULL;
 	int i, rc;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	rc = pci_enable_device(dev);
@@ -93,11 +93,9 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	i = hwif->index;
 
-	ide_init_port_hw(hwif, &hw);
-
 	idx[0] = i;
 
-	ide_device_add(idx, &delkin_cb_port_info);
+	ide_device_add(idx, &delkin_cb_port_info, hws);
 
 	pci_set_drvdata(dev, hwif);
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -554,7 +554,7 @@ static int scc_ide_setup_pci_device(stru
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	ide_hwif_t *hwif = NULL;
-	hw_regs_t hw;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
@@ -568,12 +568,11 @@ static int scc_ide_setup_pci_device(stru
 	hw.irq = dev->irq;
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
-	ide_init_port_hw(hwif, &hw);
 	hwif->dev = &dev->dev;
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, d);
+	ide_device_add(idx, d, hws);
 
 	return 0;
 }
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -584,8 +584,8 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
 	ide_hwif_t *hwif;
+	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw;
 	struct ide_port_info d = sgiioc4_port_info;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
@@ -622,8 +622,6 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	if (hwif == NULL)
 		goto err;
 
-	ide_init_port_hw(hwif, &hw);
-
 	/* The IOC4 uses MMIO rather than Port IO. */
 	default_hwif_mmiops(hwif);
 
@@ -634,7 +632,7 @@ sgiioc4_ide_setup_pci_device(struct pci_
 
 	idx[0] = hwif->index;
 
-	if (ide_device_add(idx, &d))
+	if (ide_device_add(idx, &d, hws))
 		return -EIO;
 
 	return 0;
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1008,6 +1008,7 @@ static int __devinit pmac_ide_setup_devi
 	struct device_node *np = pmif->node;
 	const int *bidp;
 	ide_hwif_t *hwif;
+	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = pmac_port_info;
 
@@ -1089,11 +1090,9 @@ static int __devinit pmac_ide_setup_devi
 	default_hwif_mmiops(hwif);
        	hwif->OUTBSYNC = pmac_outbsync;
 
-	ide_init_port_hw(hwif, hw);
-
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, &d);
+	ide_device_add(idx, &d, hws);
 
 #ifdef CONFIG_PMAC_MEDIABAY
 	media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq, hwif);
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -288,6 +288,7 @@ static int ide_pci_check_iomem(struct pc
  *	@d: IDE port info
  *	@port: port number
  *	@irq: PCI IRQ
+ *	@hw: hw_regs_t instance corresponding to this port
  *
  *	Perform the initial set up for the hardware interface structure. This
  *	is done per interface port rather than per PCI device. There may be
@@ -298,11 +299,11 @@ static int ide_pci_check_iomem(struct pc
 
 static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
 				      const struct ide_port_info *d,
-				      unsigned int port, int irq)
+				      unsigned int port, int irq,
+				      hw_regs_t *hw)
 {
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
-	struct hw_regs_s hw;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
@@ -326,17 +327,17 @@ static ide_hwif_t *ide_hwif_configure(st
 		return NULL;
 	}
 
+	memset(hw, 0, sizeof(*hw));
+	hw->irq = irq;
+	hw->dev = &dev->dev;
+	hw->chipset = d->chipset ? d->chipset : ide_pci;
+	ide_std_init_ports(hw, base, ctl | 2);
+
 	hwif = ide_find_port_slot(d);
 	if (hwif == NULL)
 		return NULL;
 
-	memset(&hw, 0, sizeof(hw));
-	hw.irq = irq;
-	hw.dev = &dev->dev;
-	hw.chipset = d->chipset ? d->chipset : ide_pci;
-	ide_std_init_ports(&hw, base, ctl | 2);
-
-	ide_init_port_hw(hwif, &hw);
+	hwif->chipset = hw->chipset;
 
 	return hwif;
 }
@@ -429,6 +430,8 @@ out:
  *	@d: IDE port info
  *	@pciirq: IRQ line
  *	@idx: ATA index table to update
+ *	@hw: hw_regs_t instances corresponding to this PCI IDE device
+ *	@hws: hw_regs_t pointers table to update
  *
  *	Scan the interfaces attached to this device and do any
  *	necessary per port setup. Attach the devices and ask the
@@ -439,7 +442,8 @@ out:
  *	where the chipset setup is not the default PCI IDE one.
  */
 
-void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d, int pciirq, u8 *idx)
+void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
+			 int pciirq, u8 *idx, hw_regs_t *hw, hw_regs_t **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
 	ide_hwif_t *hwif;
@@ -458,10 +462,11 @@ void ide_pci_setup_ports(struct pci_dev 
 			continue;	/* port not enabled */
 		}
 
-		hwif = ide_hwif_configure(dev, d, port, pciirq);
+		hwif = ide_hwif_configure(dev, d, port, pciirq, hw + port);
 		if (hwif == NULL)
 			continue;
 
+		*(hws + port) = hw + port;
 		*(idx + port) = hwif->index;
 	}
 }
@@ -536,15 +541,16 @@ out:
 int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 {
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
 	ret = do_ide_setup_pci_device(dev, d, 1);
 
 	if (ret >= 0) {
 		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(dev, d, ret, &idx[0]);
+		ide_pci_setup_ports(dev, d, ret, &idx[0], &hw[0], &hws[0]);
 
-		ide_device_add(idx, d);
+		ide_device_add(idx, d, hws);
 	}
 
 	return ret;
@@ -556,6 +562,7 @@ int ide_setup_pci_devices(struct pci_dev
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
 	int ret, i;
+	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	for (i = 0; i < 2; i++) {
@@ -569,10 +576,11 @@ int ide_setup_pci_devices(struct pci_dev
 			goto out;
 
 		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(pdev[i], d, ret, &idx[i*2]);
+		ide_pci_setup_ports(pdev[i], d, ret, &idx[i*2], &hw[i*2],
+				    &hws[i*2]);
 	}
 
-	ide_device_add(idx, d);
+	ide_device_add(idx, d, hws);
 out:
 	return ret;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -986,7 +986,8 @@ extern int __ide_pci_register_driver(str
 #define ide_pci_register_driver(d) pci_register_driver(d)
 #endif
 
-void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int, u8 *);
+void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int,
+			 u8 *, hw_regs_t *, hw_regs_t **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -1203,8 +1204,8 @@ void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 
-int ide_device_add_all(u8 *idx, const struct ide_port_info *);
-int ide_device_add(u8 idx[4], const struct ide_port_info *);
+int ide_device_add_all(u8 *, const struct ide_port_info *, hw_regs_t **);
+int ide_device_add(u8 *, const struct ide_port_info *, hw_regs_t **);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
