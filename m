Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYFVTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYFVTfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbYFVTeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:34:31 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:54975 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981AbYFVTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Vz0wmzj5ekbHeHbBuyzqhIAsHJuH4oYEp/Mo4Ts4cQhehD/JopQ1cpzYb2MJh0GXms
         L0SaXPn5/ISwNydKf1cd4hWAtZFrb/VFsn5ahSZL+EoMACFwQ26YjC35gXEzYKRsHqCL
         bySSevFFMBRGxWw1OueLt35cH5fawJWcUDD6Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2008 21:36:19 +0200
Message-Id: <20080622193619.5325.61252.sendpatchset@localhost.localdomain>
In-Reply-To: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
References: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/4] ide: add struct ide_host
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add struct ide_host which keeps pointers to host's ports.

* Add ide_host_alloc[_all]() and ide_host_remove() helpers.

* Pass 'struct ide_host *host' instead of 'u8 *idx' to
  ide_device_add[_all]() and rename it to ide_host_register[_all]().

* Convert host drivers and core code to use struct ide_host.

* Remove no longer needed ide_find_port().

* Make ide_find_port_slot() static.

* Unexport ide_unregister().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
still on TODO:
- fix ide_host_register() to fail only if it cannot add all ports
- add ide_host_add() which does ide_host_alloc() + ide_host_register()
- add ide_host_free() for freeing ide_hwifs[]'s slots and host instance

 drivers/ide/arm/icside.c          |   40 ++++------------
 drivers/ide/arm/ide_arm.c         |   12 +---
 drivers/ide/arm/palm_bk3710.c     |   13 +----
 drivers/ide/arm/rapide.c          |   17 ++----
 drivers/ide/h8300/ide-h8300.c     |   14 +----
 drivers/ide/ide-generic.c         |   28 +++--------
 drivers/ide/ide-pnp.c             |   17 ++----
 drivers/ide/ide-probe.c           |   94 +++++++++++++++++++++++++++-----------
 drivers/ide/ide.c                 |    2 
 drivers/ide/legacy/buddha.c       |   19 ++-----
 drivers/ide/legacy/falconide.c    |   11 +---
 drivers/ide/legacy/gayle.c        |   16 ++----
 drivers/ide/legacy/ide-4drives.c  |   23 ++-------
 drivers/ide/legacy/ide-cs.c       |   48 +++++++++----------
 drivers/ide/legacy/ide_platform.c |   23 ++++-----
 drivers/ide/legacy/macide.c       |   11 +---
 drivers/ide/legacy/q40ide.c       |   15 ++----
 drivers/ide/mips/au1xxx-ide.c     |   25 ++++------
 drivers/ide/mips/swarm.c          |   13 ++---
 drivers/ide/pci/cmd640.c          |   30 +++---------
 drivers/ide/pci/cs5520.c          |    8 ++-
 drivers/ide/pci/delkin_cb.c       |   19 ++-----
 drivers/ide/pci/scc_pata.c        |   24 ++++-----
 drivers/ide/pci/sgiioc4.c         |   13 ++---
 drivers/ide/ppc/pmac.c            |   14 ++---
 drivers/ide/setup-pci.c           |   48 +++++++------------
 include/linux/ide.h               |   21 ++++----
 27 files changed, 264 insertions(+), 354 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -72,7 +72,7 @@ struct icside_state {
 	void __iomem *ioc_base;
 	unsigned int sel;
 	unsigned int type;
-	ide_hwif_t *hwif[2];
+	struct ide_host *host;
 };
 
 #define ICS_TYPE_A3IN	0
@@ -442,10 +442,9 @@ static void icside_setup_ports(hw_regs_t
 static int __init
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
-	ide_hwif_t *hwif;
 	void __iomem *base;
+	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	base = ecardm_iomap(ec, ECARD_RES_MEMC, 0, 0);
 	if (!base)
@@ -465,17 +464,15 @@ icside_register_v5(struct icside_state *
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	hwif = ide_find_port();
-	if (!hwif)
+	host = ide_host_alloc(NULL, hws);
+	if (host == NULL)
 		return -ENODEV;
 
-	state->hwif[0] = hwif;
+	state->host = host;
 
 	ecard_set_drvdata(ec, state);
 
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, NULL, hws);
+	ide_host_register(host, NULL, hws);
 
 	return 0;
 }
@@ -492,12 +489,11 @@ static const struct ide_port_info icside
 static int __init
 icside_register_v6(struct icside_state *state, struct expansion_card *ec)
 {
-	ide_hwif_t *hwif, *mate;
 	void __iomem *ioc_base, *easi_base;
+	struct ide_host *host;
 	unsigned int sel = 0;
 	int ret;
 	hw_regs_t hw[2], *hws[] = { &hw[0], NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = icside_v6_port_info;
 
 	ioc_base = ecardm_iomap(ec, ECARD_RES_IOCFAST, 0, 0);
@@ -537,25 +533,11 @@ icside_register_v6(struct icside_state *
 	icside_setup_ports(&hw[0], easi_base, &icside_cardinfo_v6_1, ec);
 	icside_setup_ports(&hw[1], easi_base, &icside_cardinfo_v6_2, ec);
 
-	/*
-	 * Find and register the interfaces.
-	 */
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	host = ide_host_alloc(&d, hws);
+	if (host == NULL)
 		return -ENODEV;
 
-	hwif->chipset = ide_acorn;
-
-	idx[0] = hwif->index;
-
-	mate = ide_find_port();
-	if (mate) {
-		hws[1] = &hw[1];
-		idx[1] = mate->index;
-	}
-
-	state->hwif[0]    = hwif;
-	state->hwif[1]    = mate;
+	state->host = host;
 
 	ecard_set_drvdata(ec, state);
 
@@ -565,7 +547,7 @@ icside_register_v6(struct icside_state *
 		d.dma_ops = NULL;
 	}
 
-	ide_device_add(idx, &d, hws);
+	ide_host_register(host, &d, hws);
 
 	return 0;
 
Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -28,10 +28,9 @@
 
 static int __init ide_arm_init(void)
 {
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!request_region(base, 8, DRV_NAME)) {
 		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -51,12 +50,9 @@ static int __init ide_arm_init(void)
 	hw.irq = IDE_ARM_IRQ;
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		idx[0] = hwif->index;
-
-		ide_device_add(idx, NULL, hws);
-	}
+	host = ide_host_alloc(NULL, hws);
+	if (host)
+		ide_host_register(host, NULL, hws);
 
 	return 0;
 }
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -349,11 +349,10 @@ static int __devinit palm_bk3710_probe(s
 {
 	struct clk *clkp;
 	struct resource *mem, *irq;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned long base;
 	int i;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	clkp = clk_get(NULL, "IDECLK");
 	if (IS_ERR(clkp))
@@ -395,15 +394,11 @@ static int __devinit palm_bk3710_probe(s
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	host = ide_host_alloc(&palm_bk3710_port_info, hws);
+	if (host == NULL)
 		goto out;
 
-	i = hwif->index;
-
-	idx[0] = i;
-
-	ide_device_add(idx, &palm_bk3710_port_info, hws);
+	ide_host_register(host, &palm_bk3710_port_info, hws);
 
 	return 0;
 out:
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -32,11 +32,10 @@ static void rapide_setup_ports(hw_regs_t
 static int __devinit
 rapide_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
-	ide_hwif_t *hwif;
 	void __iomem *base;
+	struct ide_host *host;
 	int ret;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ret = ecard_request_resources(ec);
 	if (ret)
@@ -53,17 +52,15 @@ rapide_probe(struct expansion_card *ec, 
 	hw.chipset = ide_generic;
 	hw.dev = &ec->dev;
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
+	host = ide_host_alloc(&rapide_port_info, hws);
+	if (host == NULL) {
 		ret = -ENOENT;
 		goto release;
 	}
 
-	idx[0] = hwif->index;
+	ide_host_register(host, &rapide_port_info, hws);
 
-	ide_device_add(idx, &rapide_port_info, hws);
-
-	ecard_set_drvdata(ec, hwif);
+	ecard_set_drvdata(ec, host);
 	goto out;
 
  release:
@@ -74,11 +71,11 @@ rapide_probe(struct expansion_card *ec, 
 
 static void __devexit rapide_remove(struct expansion_card *ec)
 {
-	ide_hwif_t *hwif = ecard_get_drvdata(ec);
+	struct ide_host *host = ecard_get_drvdata(ec);
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	ecard_release_resources(ec);
 }
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -191,10 +191,8 @@ static const struct ide_port_info h8300_
 
 static int __init h8300_ide_init(void)
 {
-	ide_hwif_t *hwif;
-	int index;
+	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
 
@@ -207,15 +205,11 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	hwif = ide_find_port_slot(&h8300_port_info);
-	if (hwif == NULL)
+	host = ide_host_alloc(&h8300_port_info, hws);
+	if (host == NULL)
 		return -ENOENT;
 
-	index = hwif->index;
-
-	idx[0] = index;
-
-	ide_device_add(idx, &h8300_port_info, hws);
+	ide_host_register(host, &h8300_port_info, hws);
 
 	return 0;
 
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -28,27 +28,24 @@ MODULE_PARM_DESC(probe_mask, "probe mask
 
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned int base, ctl;
 	int irq;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
 		return -EINVAL;
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
-		return -ENOENT;
-
 	memset(&hw, 0, sizeof(hw));
 	ide_std_init_ports(&hw, base, ctl);
 	hw.irq = irq;
 	hw.chipset = ide_generic;
 
-	idx[0] = hwif->index;
+	host = ide_host_alloc(NULL, hws);
+	if (host == NULL)
+		return -ENOENT;
 
-	ide_device_add(idx, NULL, hws);
+	ide_host_register(host, NULL, hws);
 
 	return n;
 };
@@ -89,18 +86,16 @@ static int __init ide_generic_sysfs_init
 static int __init ide_generic_init(void)
 {
 	hw_regs_t hw[MAX_HWIFS], *hws[MAX_HWIFS];
-	u8 idx[MAX_HWIFS];
+	struct ide_host *host;
 	int i;
 
 	printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
 			 "parameter for probing all legacy ISA IDE ports\n");
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		ide_hwif_t *hwif;
 		unsigned long io_addr = ide_default_io_base(i);
 
 		hws[i] = NULL;
-		idx[i] = 0xff;
 
 		if ((probe_mask & (1 << i)) && io_addr) {
 			if (!request_region(io_addr, 8, DRV_NAME)) {
@@ -118,23 +113,18 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			hwif = ide_find_port();
-			if (hwif == NULL)
-				continue;
-
-			hwif->chipset = ide_generic;
-
 			memset(&hw[i], 0, sizeof(hw[i]));
 			ide_std_init_ports(&hw[i], io_addr, io_addr + 0x206);
 			hw[i].irq = ide_default_irq(io_addr);
 			hw[i].chipset = ide_generic;
 
 			hws[i] = &hw[i];
-			idx[i] = i;
 		}
 	}
 
-	ide_device_add_all(idx, NULL, hws);
+	host = ide_host_alloc_all(NULL, hws);
+	if (host)
+		ide_host_register(host, NULL, hws);
 
 	if (ide_generic_sysfs_init())
 		printk(KERN_ERR DRV_NAME ": failed to create ide_generic "
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -29,7 +29,7 @@ static struct pnp_device_id idepnp_devic
 
 static int idepnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	unsigned long base, ctl;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
@@ -59,14 +59,11 @@ static int idepnp_probe(struct pnp_dev *
 	hw.irq = pnp_irq(dev, 0);
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
+	host = ide_host_alloc(NULL, hws);
+	if (host) {
+		pnp_set_drvdata(dev, host);
 
-		pnp_set_drvdata(dev, hwif);
-
-		ide_device_add(idx, NULL, hws);
+		ide_host_register(host, NULL, hws);
 
 		return 0;
 	}
@@ -79,9 +76,9 @@ static int idepnp_probe(struct pnp_dev *
 
 static void idepnp_remove(struct pnp_dev *dev)
 {
-	ide_hwif_t *hwif = pnp_get_drvdata(dev);
+	struct ide_host *host = pnp_get_drvdata(dev);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	release_region(pnp_port_start(dev, 1), 1);
 	release_region(pnp_port_start(dev, 0), 8);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1483,7 +1483,7 @@ static int ide_sysfs_register_port(ide_h
  *	Return the new hwif.  If we are out of free slots return NULL.
  */
 
-ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
+static ide_hwif_t *ide_find_port_slot(const struct ide_port_info *d)
 {
 	ide_hwif_t *hwif;
 	int i;
@@ -1529,14 +1529,63 @@ out_found:
 	ide_init_port_data(hwif, i);
 	return hwif;
 }
-EXPORT_SYMBOL_GPL(ide_find_port_slot);
 
-int ide_device_add_all(u8 *idx, const struct ide_port_info *d, hw_regs_t **hws)
+struct ide_host *ide_host_alloc_all(const struct ide_port_info *d,
+				    hw_regs_t **hws)
+{
+	struct ide_host *host;
+	int i;
+
+	host = kzalloc(sizeof(*host), GFP_KERNEL);
+	if (host == NULL)
+		return NULL;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		ide_hwif_t *hwif;
+
+		if (hws[i] == NULL)
+			continue;
+
+		hwif = ide_find_port_slot(d);
+		if (hwif) {
+			hwif->chipset = hws[i]->chipset;
+
+			host->ports[i] = hwif;
+			host->n_ports++;
+		}
+	}
+
+	if (host->n_ports == 0) {
+		kfree(host);
+		return NULL;
+	}
+
+	return host;
+}
+EXPORT_SYMBOL_GPL(ide_host_alloc_all);
+
+struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
+{
+	hw_regs_t *hws_all[MAX_HWIFS];
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++)
+		hws_all[i] = (i < 4) ? hws[i] : NULL;
+
+	return ide_host_alloc_all(d, hws_all);
+}
+EXPORT_SYMBOL_GPL(ide_host_alloc);
+
+int ide_host_register(struct ide_host *host, const struct ide_port_info *d,
+		      hw_regs_t **hws)
 {
 	ide_hwif_t *hwif, *mate = NULL;
+	u8 idx[MAX_HWIFS];
 	int i, rc = 0;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
+		idx[i] = host->ports[i] ? host->ports[i]->index : 0xff;
+
 		if (idx[i] == 0xff) {
 			mate = NULL;
 			continue;
@@ -1632,22 +1681,20 @@ int ide_device_add_all(u8 *idx, const st
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ide_device_add_all);
+EXPORT_SYMBOL_GPL(ide_host_register);
 
-int ide_device_add(u8 *idx, const struct ide_port_info *d, hw_regs_t **hws)
+void ide_host_remove(struct ide_host *host)
 {
-	hw_regs_t *hws_all[MAX_HWIFS];
-	u8 idx_all[MAX_HWIFS];
 	int i;
 
 	for (i = 0; i < MAX_HWIFS; i++) {
-		hws_all[i] = (i < 4) ? hws[i] : NULL;
-		idx_all[i] = (i < 4) ? idx[i] : 0xff;
+		if (host->ports[i])
+			ide_unregister(host->ports[i]);
 	}
 
-	return ide_device_add_all(idx_all, d, hws_all);
+	kfree(host);
 }
-EXPORT_SYMBOL_GPL(ide_device_add);
+EXPORT_SYMBOL_GPL(ide_host_remove);
 
 void ide_port_scan(ide_hwif_t *hwif)
 {
@@ -1668,11 +1715,10 @@ void ide_port_scan(ide_hwif_t *hwif)
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
 
-static void ide_legacy_init_one(u8 *idx, hw_regs_t **hws, hw_regs_t *hw,
+static void ide_legacy_init_one(hw_regs_t **hws, hw_regs_t *hw,
 				u8 port_no, const struct ide_port_info *d,
 				unsigned long config)
 {
-	ide_hwif_t *hwif;
 	unsigned long base, ctl;
 	int irq;
 
@@ -1704,31 +1750,29 @@ static void ide_legacy_init_one(u8 *idx,
 	hw->chipset = d->chipset;
 	hw->config = config;
 
-	hwif = ide_find_port_slot(d);
-	if (hwif) {
-		hwif->chipset = hw->chipset;
-
-		hws[port_no] = hw;
-		idx[port_no] = hwif->index;
-	}
+	hws[port_no] = hw;
 }
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_host *host;
 	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
 
 	if ((d->host_flags & IDE_HFLAG_QD_2ND_PORT) == 0)
-		ide_legacy_init_one(idx, hws, &hw[0], 0, d, config);
-	ide_legacy_init_one(idx, hws, &hw[1], 1, d, config);
+		ide_legacy_init_one(hws, &hw[0], 0, d, config);
+	ide_legacy_init_one(hws, &hw[1], 1, d, config);
 
-	if (idx[0] == 0xff && idx[1] == 0xff &&
+	if (hws[0] == NULL && hws[1] == NULL &&
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	ide_device_add(idx, d, hws);
+	host = ide_host_alloc(d, hws);
+	if (host == NULL)
+		return -ENOMEM;
+
+	ide_host_register(host, d, hws);
 
 	return 0;
 }
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -276,8 +276,6 @@ abort:
 	mutex_unlock(&ide_cfg_mtx);
 }
 
-EXPORT_SYMBOL(ide_unregister);
-
 void ide_init_port_hw(ide_hwif_t *hwif, hw_regs_t *hw)
 {
 	memcpy(&hwif->io_ports, &hw->io_ports, sizeof(hwif->io_ports));
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -150,18 +150,15 @@ static void __init buddha_setup_ports(hw
 
 static int __init buddha_init(void)
 {
-	ide_hwif_t *hwif;
-	int i;
-
 	struct zorro_dev *z = NULL;
+	struct ide_host *host;
 	u_long buddha_board = 0;
 	BuddhaType type;
-	int buddha_num_hwifs;
+	int buddha_num_hwifs, i;
 
 	while ((z = zorro_find_device(ZORRO_WILDCARD, z))) {
 		unsigned long board;
 		hw_regs_t hw[MAX_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
-		u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 		if (z->id == ZORRO_PROD_INDIVIDUAL_COMPUTERS_BUDDHA) {
 			buddha_num_hwifs = BUDDHA_NUM_HWIFS;
@@ -226,16 +223,12 @@ fail_base2:
 			buddha_setup_ports(&hw[i], base, ctl, irq_port,
 					   ack_intr);
 
-			hwif = ide_find_port();
-			if (hwif) {
-				hwif->chipset = ide_generic;
-
-				hws[i] = &hw[i];
-				idx[i] = hwif->index;
-			}
+			hws[i] = &hw[i];
 		}
 
-		ide_device_add(idx, NULL, hws);
+		host = ide_host_alloc(NULL, hws);
+		if (host)
+			ide_host_register(host, NULL, hws);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -112,7 +112,7 @@ static void __init falconide_setup_ports
 
 static int __init falconide_init(void)
 {
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!MACH_IS_ATARI || !ATARIHW_PRESENT(IDE))
@@ -127,13 +127,10 @@ static int __init falconide_init(void)
 
 	falconide_setup_ports(&hw);
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
-
+	host = ide_host_alloc(&falconide_port_info, hws);
+	if (host) {
 		ide_get_lock(NULL, NULL);
-		ide_device_add(idx, &falconide_port_info, hws);
+		ide_host_register(host, &falconide_port_info, hws);
 		ide_release_lock();
 	}
 
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -127,9 +127,9 @@ static int __init gayle_init(void)
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
+    struct ide_host *host;
     int a4000, i;
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!MACH_IS_AMIGA)
 	return -ENODEV;
@@ -172,23 +172,17 @@ found:
 		return -EBUSY;
 
     for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
-	ide_hwif_t *hwif;
-
 	base = (unsigned long)ZTWO_VADDR(phys_base + i * GAYLE_NEXT_PORT);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
 	gayle_setup_ports(&hw[i], base, ctrlport, irqport, ack_intr);
 
-	hwif = ide_find_port();
-	if (hwif) {
-	    hwif->chipset = ide_generic;
-
-	    hws[i] = &hw[i];
-	    idx[i] = hwif->index;
-	}
+	hws[i] = &hw[i];
     }
 
-    ide_device_add(idx, NULL, hws);
+    host = ide_host_alloc(NULL, hws);
+    if (host)
+	ide_host_register(host, NULL, hws);
 
     return 0;
 }
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -28,10 +28,9 @@ static const struct ide_port_info ide_4d
 
 static int __init ide_4drives_init(void)
 {
-	ide_hwif_t *hwif, *mate;
+	struct ide_host *host;
 	unsigned long base = 0x1f0, ctl = 0x3f6;
-	hw_regs_t hw, *hws[] = { NULL, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw, *hws[] = { &hw, &hw, NULL, NULL };
 
 	if (probe_4drives == 0)
 		return -ENODEV;
@@ -55,21 +54,9 @@ static int __init ide_4drives_init(void)
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
-	hwif = ide_find_port();
-	if (hwif) {
-		hwif->chipset = ide_4drives;
-
-		hws[0] = &hw;
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		hws[1] = &hw;
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ide_4drives_port_info, hws);
+	host = ide_host_alloc(&ide_4drives_port_info, hws);
+	if (host)
+		ide_host_register(host, &ide_4drives_port_info, hws);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -76,7 +76,7 @@ static char *version =
 
 typedef struct ide_info_t {
 	struct pcmcia_device	*p_dev;
-	ide_hwif_t		*hwif;
+	struct ide_host		*host;
     int		ndev;
     dev_node_t	node;
 } ide_info_t;
@@ -134,7 +134,7 @@ static int ide_probe(struct pcmcia_devic
 static void ide_detach(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    ide_hwif_t *hwif = info->hwif;
+    ide_hwif_t *hwif = info->host->ports[0];
     unsigned long data_addr, ctl_addr;
 
     DEBUG(0, "ide_detach(0x%p)\n", link);
@@ -159,13 +159,13 @@ static const struct ide_port_info idecs_
 	.host_flags		= IDE_HFLAG_NO_DMA,
 };
 
-static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
+static struct ide_host *idecs_register(unsigned long io, unsigned long ctl,
 				unsigned long irq, struct pcmcia_device *handle)
 {
+    struct ide_host *host;
     ide_hwif_t *hwif;
     int i;
     hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!request_region(io, 8, DRV_NAME)) {
 	printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
@@ -186,28 +186,26 @@ static ide_hwif_t *idecs_register(unsign
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_find_port();
-    if (hwif == NULL)
+    host = ide_host_alloc(&idecs_port_info, hws);
+    if (host == NULL)
 	goto out_release;
 
-    ide_init_port_hw(hwif, &hw);
+    ide_host_register(host, &idecs_port_info, hws);
 
-    idx[0] = hwif->index;
-
-    ide_device_add(idx, &idecs_port_info, hws);
+    hwif = host->ports[0];
 
     if (hwif->present)
-	return hwif;
+	return host;
 
     /* retry registration in case device is still spinning up */
     for (i = 0; i < 10; i++) {
 	msleep(100);
 	ide_port_scan(hwif);
 	if (hwif->present)
-	    return hwif;
+	    return host;
     }
 
-    return hwif;
+    return host;
 
 out_release:
     release_region(ctl, 1);
@@ -239,7 +237,7 @@ static int ide_config(struct pcmcia_devi
     cistpl_cftable_entry_t *cfg;
     int pass, last_ret = 0, last_fn = 0, is_kme = 0;
     unsigned long io_base, ctl_base;
-    ide_hwif_t *hwif;
+    struct ide_host *host;
 
     DEBUG(0, "ide_config(0x%p)\n", link);
 
@@ -334,21 +332,21 @@ static int ide_config(struct pcmcia_devi
     if (is_kme)
 	outb(0x81, ctl_base+1);
 
-     hwif = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
-     if (hwif == NULL && link->io.NumPorts1 == 0x20) {
+     host = idecs_register(io_base, ctl_base, link->irq.AssignedIRQ, link);
+     if (host == NULL && link->io.NumPorts1 == 0x20) {
 	    outb(0x02, ctl_base + 0x10);
-	    hwif = idecs_register(io_base + 0x10, ctl_base + 0x10,
+	    host = idecs_register(io_base + 0x10, ctl_base + 0x10,
 				  link->irq.AssignedIRQ, link);
     }
 
-    if (hwif == NULL)
+    if (host == NULL)
 	goto failed;
 
     info->ndev = 1;
-    sprintf(info->node.dev_name, "hd%c", 'a' + hwif->index * 2);
-    info->node.major = hwif->major;
+    sprintf(info->node.dev_name, "hd%c", 'a' + host->ports[0]->index * 2);
+    info->node.major = host->ports[0]->major;
     info->node.minor = 0;
-    info->hwif = hwif;
+    info->host = host;
     link->dev_node = &info->node;
     printk(KERN_INFO "ide-cs: %s: Vpp = %d.%d\n",
 	   info->node.dev_name, link->conf.Vpp / 10, link->conf.Vpp % 10);
@@ -379,15 +377,15 @@ failed:
 void ide_release(struct pcmcia_device *link)
 {
     ide_info_t *info = link->priv;
-    ide_hwif_t *hwif = info->hwif;
+    struct ide_host *host = info->host;
 
     DEBUG(0, "ide_release(0x%p)\n", link);
 
-    if (info->ndev) {
+    if (info->ndev)
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(hwif);
-    }
+	ide_host_remove(host);
+
     info->ndev = 0;
 
     pcmcia_disable_device(link);
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -52,11 +52,10 @@ static int __devinit plat_ide_probe(stru
 {
 	struct resource *res_base, *res_alt, *res_irq;
 	void __iomem *base, *alt_base;
-	ide_hwif_t *hwif;
 	struct pata_platform_info *pdata;
+	struct ide_host *host;
 	int ret = 0, mmio = 0;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
@@ -93,12 +92,6 @@ static int __devinit plat_ide_probe(stru
 			res_alt->start, res_alt->end - res_alt->start + 1);
 	}
 
-	hwif = ide_find_port();
-	if (!hwif) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	memset(&hw, 0, sizeof(hw));
 	plat_ide_setup_ports(&hw, base, alt_base, pdata, res_irq->start);
 	hw.dev = &pdev->dev;
@@ -106,11 +99,15 @@ static int __devinit plat_ide_probe(stru
 	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
 
-	idx[0] = hwif->index;
+	host = ide_host_alloc(&d, hws);
+	if (host == NULL) {
+		ret = -ENODEV;
+		goto out;
+	}
 
-	ide_device_add(idx, &d, hws);
+	ide_host_register(host, &d, hws);
 
-	platform_set_drvdata(pdev, hwif);
+	platform_set_drvdata(pdev, host);
 
 	return 0;
 
@@ -120,9 +117,9 @@ out:
 
 static int __devexit plat_ide_remove(struct platform_device *pdev)
 {
-	ide_hwif_t *hwif = pdev->dev.driver_data;
+	struct ide_host *host = pdev->dev.driver_data;
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -91,7 +91,6 @@ static const char *mac_ide_name[] =
 
 static int __init macide_init(void)
 {
-	ide_hwif_t *hwif;
 	ide_ack_intr_t *ack_intr;
 	unsigned long base;
 	int irq;
@@ -125,13 +124,9 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	hwif = ide_find_port();
-	if (hwif) {
-		u8 index = hwif->index;
-		u8 idx[4] = { index, 0xff, 0xff, 0xff };
-
-		ide_device_add(idx, NULL, hws);
-	}
+	host = ide_host_alloc(NULL, hws);
+	if (host)
+		ide_host_register(host, NULL, hws);
 
 	return 0;
 }
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -131,10 +131,9 @@ static const char *q40_ide_names[Q40IDE_
 
 static int __init q40ide_init(void)
 {
+    struct ide_host *host;
     int i;
-    ide_hwif_t *hwif;
     hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
-    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
     if (!MACH_IS_Q40)
       return -ENODEV;
@@ -158,16 +157,12 @@ static int __init q40ide_init(void)
 	q40_ide_setup_ports(&hw[i], pcide_bases[i], NULL,
 			q40ide_default_irq(pcide_bases[i]));
 
-	hwif = ide_find_port();
-	if (hwif) {
-		hwif->chipset = ide_generic;
-
-		hws[i] = &hw[i];
-		idx[i] = hwif->index;
-	}
+	hws[i] = &hw[i];
     }
 
-    ide_device_add(idx, &q40ide_port_info, hws);
+    host = ide_host_alloc(&q40ide_port_info, hws);
+    if (host)
+	ide_host_register(host, &q40ide_port_info, hws);
 
     return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -563,11 +563,10 @@ static int au_ide_probe(struct device *d
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	_auide_hwif *ahwif = &auide_hwif;
-	ide_hwif_t *hwif;
 	struct resource *res;
+	struct ide_host *host;
 	int ret = 0;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 #if defined(CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA)
 	char *mode = "MWDMA2";
@@ -604,25 +603,23 @@ static int au_ide_probe(struct device *d
 		goto out;
 	}
 
-	hwif = ide_find_port();
-	if (hwif == NULL) {
-		ret = -ENOENT;
-		goto out;
-	}
-
 	memset(&hw, 0, sizeof(hw));
 	auide_setup_ports(&hw, ahwif);
 	hw.irq = ahwif->irq;
 	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
-	auide_hwif.hwif                 = hwif;
+	host = ide_host_alloc(&au1xxx_port_info, hws);
+	if (host == NULL) {
+		ret = -ENOENT;
+		goto out;
+	}
 
-	idx[0] = hwif->index;
+	ide_host_register(host, &au1xxx_port_info, hws);
 
-	ide_device_add(idx, &au1xxx_port_info, hws);
+	auide_hwif.hwif = host->ports[0];
 
-	dev_set_drvdata(dev, hwif);
+	dev_set_drvdata(dev, host);
 
 	printk(KERN_INFO "Au1xxx IDE(builtin) configured for %s\n", mode );
 
@@ -634,10 +631,10 @@ static int au_ide_remove(struct device *
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *res;
-	ide_hwif_t *hwif = dev_get_drvdata(dev);
+	struct ide_host *host = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	iounmap((void *)ahwif->regbase);
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -72,12 +72,11 @@ static const struct ide_port_info swarm_
  */
 static int __devinit swarm_ide_probe(struct device *dev)
 {
-	ide_hwif_t *hwif;
 	u8 __iomem *base;
+	struct ide_host *host;
 	phys_t offset, size;
 	int i;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (!SIBYTE_HAVE_IDE)
 		return -ENODEV;
@@ -116,15 +115,13 @@ static int __devinit swarm_ide_probe(str
 	hw.irq = K_INT_GB_IDE;
 	hw.chipset = ide_generic;
 
-	hwif = ide_find_port_slot(&swarm_port_info);
-	if (hwif == NULL)
+	host = ide_host_alloc(&swarm_port_info, hws);
+	if (host == NULL)
 		goto err;
 
-	idx[0] = hwif->index;
+	ide_host_register(host, &swarm_port_info, hws);
 
-	ide_device_add(idx, &swarm_port_info, hws);
-
-	dev_set_drvdata(dev, hwif);
+	dev_set_drvdata(dev, host);
 
 	return 0;
 err:
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -181,11 +181,6 @@ static u8 recovery_counts[4] = {16, 16, 
 static DEFINE_SPINLOCK(cmd640_lock);
 
 /*
- * These are initialized to point at the devices we control
- */
-static ide_hwif_t  *cmd_hwif0, *cmd_hwif1;
-
-/*
  * Interface to access cmd640x registers
  */
 static unsigned int cmd640_key;
@@ -714,11 +709,11 @@ static int cmd640x_init_one(unsigned lon
  */
 static int __init cmd640x_init(void)
 {
+	struct ide_host *host;
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
 	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	if (cmd640_vlb && probe_for_cmd640_vlb()) {
 		bus_type = "VLB";
@@ -781,17 +776,10 @@ static int __init cmd640x_init(void)
 	printk(KERN_INFO "cmd640: buggy cmd640%c interface on %s, config=0x%02x"
 			 "\n", 'a' + cmd640_chip_version - 1, bus_type, cfr);
 
-	cmd_hwif0 = ide_find_port();
-
 	/*
 	 * Initialize data for primary port
 	 */
-	if (cmd_hwif0) {
-		cmd_hwif0->chipset = ide_cmd640;
-
-		hws[0] = &hw[0];
-		idx[0] = cmd_hwif0->index;
-	}
+	hws[0] = &hw[0];
 
 	/*
 	 * Ensure compatibility by always using the slowest timings
@@ -831,13 +819,9 @@ static int __init cmd640x_init(void)
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640) {
-		cmd_hwif1 = ide_find_port();
-		if (cmd_hwif1) {
-			hws[1] = &hw[1];
-			idx[1] = cmd_hwif1->index;
-		}
-	}
+	if (second_port_cmd640)
+		hws[1] = &hw[1];
+
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
 
@@ -845,7 +829,9 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	ide_device_add(idx, &cmd640_port_info, hws);
+	host = ide_host_alloc(&cmd640_port_info, hws);
+	if (host)
+		ide_host_register(host, &cmd640_port_info, hws);
 
 	return 1;
 }
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -114,9 +114,9 @@ static const struct ide_port_info cyrix_
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
+	struct ide_host *host;
 	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	ide_setup_pci_noise(dev, d);
 
@@ -138,9 +138,11 @@ static int __devinit cs5520_init_one(str
 	 *	do all the device setup for us
 	 */
 
-	ide_pci_setup_ports(dev, d, 14, &idx[0], &hw[0], &hws[0]);
+	ide_pci_setup_ports(dev, d, 14, &hw[0], &hws[0]);
 
-	ide_device_add(idx, d, hws);
+	host = ide_host_alloc(d, hws);
+	if (host)
+		ide_host_register(host, d, hws);
 
 	return 0;
 }
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -56,11 +56,10 @@ static const struct ide_port_info delkin
 static int __devinit
 delkin_cb_probe (struct pci_dev *dev, const struct pci_device_id *id)
 {
+	struct ide_host *host;
 	unsigned long base;
-	ide_hwif_t *hwif = NULL;
 	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -87,17 +86,13 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_find_port();
-	if (hwif == NULL)
+	host = ide_host_alloc(&delkin_cb_port_info, hws);
+	if (host == NULL)
 		goto out_disable;
 
-	i = hwif->index;
+	ide_host_register(host, &delkin_cb_port_info, hws);
 
-	idx[0] = i;
-
-	ide_device_add(idx, &delkin_cb_port_info, hws);
-
-	pci_set_drvdata(dev, hwif);
+	pci_set_drvdata(dev, host);
 
 	return 0;
 
@@ -110,9 +105,9 @@ out_disable:
 static void
 delkin_cb_remove (struct pci_dev *dev)
 {
-	ide_hwif_t *hwif = pci_get_drvdata(dev);
+	struct ide_host *host = pci_get_drvdata(dev);
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	pci_release_regions(dev);
 	pci_disable_device(dev);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -65,7 +65,7 @@
 
 static struct scc_ports {
 	unsigned long ctl, dma;
-	ide_hwif_t *hwif;  /* for removing port from system */
+	struct ide_host *host;	/* for removing port from system */
 } scc_ports[MAX_HWIFS];
 
 /* PIO transfer mode  table */
@@ -586,15 +586,10 @@ static int scc_ide_setup_pci_device(stru
 				    const struct ide_port_info *d)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = NULL;
+	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	int i;
 
-	hwif = ide_find_port_slot(d);
-	if (hwif == NULL)
-		return -ENOMEM;
-
 	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i <= 8; i++)
 		hw.io_ports_array[i] = ports->dma + 0x20 + i * 4;
@@ -602,9 +597,13 @@ static int scc_ide_setup_pci_device(stru
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
 
-	idx[0] = hwif->index;
+	host = ide_host_alloc(d, hws);
+	if (host == NULL)
+		return -ENOMEM;
 
-	ide_device_add(idx, d, hws);
+	ide_host_register(host, d, hws);
+
+	ports->host = host;
 
 	return 0;
 }
@@ -848,8 +847,6 @@ static void __devinit init_hwif_scc(ide_
 {
 	struct scc_ports *ports = ide_get_hwifdata(hwif);
 
-	ports->hwif = hwif;
-
 	/* PTERADD */
 	out_be32((void __iomem *)(hwif->dma_base + 0x018), hwif->dmatable_dma);
 
@@ -932,7 +929,8 @@ static int __devinit scc_init_one(struct
 static void __devexit scc_remove(struct pci_dev *dev)
 {
 	struct scc_ports *ports = pci_get_drvdata(dev);
-	ide_hwif_t *hwif = ports->hwif;
+	struct ide_host *host = ports->host;
+	ide_hwif_t *hwif = host->ports[0];
 
 	if (hwif->dmatable_cpu) {
 		pci_free_consistent(dev, PRD_ENTRIES * PRD_BYTES,
@@ -940,7 +938,7 @@ static void __devexit scc_remove(struct 
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif);
+	ide_host_remove(host);
 
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
Index: b/drivers/ide/pci/sgiioc4.c
===================================================================
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -600,9 +600,8 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	unsigned long cmd_base, irqport;
 	unsigned long bar0, cmd_phys_base, ctl;
 	void __iomem *virt_base;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = sgiioc4_port_info;
 
 	/*  Get the CmdBlk and CtrlBlk Base Registers */
@@ -635,16 +634,14 @@ sgiioc4_ide_setup_pci_device(struct pci_
 	hw.chipset = ide_pci;
 	hw.dev = &dev->dev;
 
-	hwif = ide_find_port_slot(&d);
-	if (hwif == NULL)
-		goto err;
-
 	/* Initializing chipset IRQ Registers */
 	writel(0x03, (void __iomem *)(irqport + IOC4_INTR_SET * 4));
 
-	idx[0] = hwif->index;
+	host = ide_host_alloc(&d, hws);
+	if (host == NULL)
+		goto err;
 
-	if (ide_device_add(idx, &d, hws))
+	if (ide_host_register(host, &d, hws))
 		return -EIO;
 
 	return 0;
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1037,9 +1037,8 @@ static int __devinit pmac_ide_setup_devi
 {
 	struct device_node *np = pmif->node;
 	const int *bidp;
-	ide_hwif_t *hwif;
+	struct ide_host *host;
 	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	struct ide_port_info d = pmac_port_info;
 
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
@@ -1112,16 +1111,15 @@ static int __devinit pmac_ide_setup_devi
 			 pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
 			 pmif->mediabay ? " (mediabay)" : "", hw->irq);
 
-	hwif = ide_find_port_slot(&d);
-	if (hwif == NULL)
+	host = ide_alloc_host(&d, hws);
+	if (host == NULL)
 		return -ENOENT;
 
-	idx[0] = hwif->index;
-
-	ide_device_add(idx, &d, hws);
+	ide_host_register(host, &d, hws);
 
 #ifdef CONFIG_PMAC_MEDIABAY
-	media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq, hwif);
+	media_bay_set_ide_infos(np->parent, pmif->regbase, pmif->irq,
+				host->ports[0]);
 #endif
 
 	return 0;
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -288,7 +288,7 @@ static int ide_pci_check_iomem(struct pc
 }
 
 /**
- *	ide_hwif_configure	-	configure an IDE interface
+ *	ide_hw_configure	-	configure a hw_regs_t instance
  *	@dev: PCI device holding interface
  *	@d: IDE port info
  *	@port: port number
@@ -299,23 +299,20 @@ static int ide_pci_check_iomem(struct pc
  *	is done per interface port rather than per PCI device. There may be
  *	more than one port per device.
  *
- *	Returns the new hardware interface structure, or NULL on a failure
+ *	Returns zero on success or an error code.
  */
 
-static ide_hwif_t *ide_hwif_configure(struct pci_dev *dev,
-				      const struct ide_port_info *d,
-				      unsigned int port, int irq,
-				      hw_regs_t *hw)
+static int ide_hw_configure(struct pci_dev *dev, const struct ide_port_info *d,
+			    unsigned int port, int irq, hw_regs_t *hw)
 {
 	unsigned long ctl = 0, base = 0;
-	ide_hwif_t *hwif;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
 		if (ide_pci_check_iomem(dev, d, 2 * port) ||
 		    ide_pci_check_iomem(dev, d, 2 * port + 1)) {
 			printk(KERN_ERR "%s: I/O baseregs (BIOS) are reported "
 					"as MEM for port %d!\n", d->name, port);
-			return NULL;
+			return -EINVAL;
 		}
 
 		ctl  = pci_resource_start(dev, 2*port+1);
@@ -329,7 +326,7 @@ static ide_hwif_t *ide_hwif_configure(st
 	if (!base || !ctl) {
 		printk(KERN_ERR "%s: bad PCI BARs for port %d, skipping\n",
 				d->name, port);
-		return NULL;
+		return -EINVAL;
 	}
 
 	memset(hw, 0, sizeof(*hw));
@@ -338,13 +335,7 @@ static ide_hwif_t *ide_hwif_configure(st
 	hw->chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(hw, base, ctl | 2);
 
-	hwif = ide_find_port_slot(d);
-	if (hwif == NULL)
-		return NULL;
-
-	hwif->chipset = hw->chipset;
-
-	return hwif;
+	return 0;
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -442,7 +433,6 @@ out:
  *	@dev: PCI device
  *	@d: IDE port info
  *	@pciirq: IRQ line
- *	@idx: ATA index table to update
  *	@hw: hw_regs_t instances corresponding to this PCI IDE device
  *	@hws: hw_regs_t pointers table to update
  *
@@ -456,10 +446,9 @@ out:
  */
 
 void ide_pci_setup_ports(struct pci_dev *dev, const struct ide_port_info *d,
-			 int pciirq, u8 *idx, hw_regs_t *hw, hw_regs_t **hws)
+			 int pciirq, hw_regs_t *hw, hw_regs_t **hws)
 {
 	int channels = (d->host_flags & IDE_HFLAG_SINGLE) ? 1 : 2, port;
-	ide_hwif_t *hwif;
 	u8 tmp;
 
 	/*
@@ -475,12 +464,10 @@ void ide_pci_setup_ports(struct pci_dev 
 			continue;	/* port not enabled */
 		}
 
-		hwif = ide_hwif_configure(dev, d, port, pciirq, hw + port);
-		if (hwif == NULL)
+		if (ide_hw_configure(dev, d, port, pciirq, hw + port))
 			continue;
 
 		*(hws + port) = hw + port;
-		*(idx + port) = hwif->index;
 	}
 }
 EXPORT_SYMBOL_GPL(ide_pci_setup_ports);
@@ -553,7 +540,7 @@ out:
 
 int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	struct ide_host *host;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
@@ -561,9 +548,11 @@ int ide_setup_pci_device(struct pci_dev 
 
 	if (ret >= 0) {
 		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(dev, d, ret, &idx[0], &hw[0], &hws[0]);
+		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
 
-		ide_device_add(idx, d, hws);
+		host = ide_host_alloc(d, hws);
+		if (host)
+			ide_host_register(host, d, hws);
 	}
 
 	return ret;
@@ -574,9 +563,9 @@ int ide_setup_pci_devices(struct pci_dev
 			  const struct ide_port_info *d)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
+	struct ide_host *host;
 	int ret, i;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
-	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	for (i = 0; i < 2; i++) {
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
@@ -589,11 +578,12 @@ int ide_setup_pci_devices(struct pci_dev
 			goto out;
 
 		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(pdev[i], d, ret, &idx[i*2], &hw[i*2],
-				    &hws[i*2]);
+		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
 	}
 
-	ide_device_add(idx, d, hws);
+	host = ide_host_alloc(d, hws);
+	if (host)
+		ide_host_register(host, d, hws);
 out:
 	return ret;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -537,6 +537,11 @@ typedef struct hwif_s {
 #endif
 } ____cacheline_internodealigned_in_smp ide_hwif_t;
 
+struct ide_host {
+	ide_hwif_t	*ports[MAX_HWIFS];
+	unsigned int	n_ports;
+};
+
 /*
  *  internal ide interrupt handler type
  */
@@ -795,13 +800,6 @@ int generic_ide_ioctl(ide_drive_t *, str
 extern int ide_vlb_clk;
 extern int ide_pci_clk;
 
-ide_hwif_t *ide_find_port_slot(const struct ide_port_info *);
-
-static inline ide_hwif_t *ide_find_port(void)
-{
-	return ide_find_port_slot(NULL);
-}
-
 extern int ide_end_request (ide_drive_t *drive, int uptodate, int nrsecs);
 int ide_end_dequeued_request(ide_drive_t *drive, struct request *rq,
 			     int uptodate, int nr_sectors);
@@ -1010,7 +1008,7 @@ extern int __ide_pci_register_driver(str
 #endif
 
 void ide_pci_setup_ports(struct pci_dev *, const struct ide_port_info *, int,
-			 u8 *, hw_regs_t *, hw_regs_t **);
+			 hw_regs_t *, hw_regs_t **);
 void ide_setup_pci_noise(struct pci_dev *, const struct ide_port_info *);
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PCI
@@ -1222,8 +1220,11 @@ void ide_undecoded_slave(ide_drive_t *);
 
 void ide_port_apply_params(ide_hwif_t *);
 
-int ide_device_add_all(u8 *, const struct ide_port_info *, hw_regs_t **);
-int ide_device_add(u8 *, const struct ide_port_info *, hw_regs_t **);
+struct ide_host *ide_host_alloc_all(const struct ide_port_info *, hw_regs_t **);
+struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
+int ide_host_register(struct ide_host *, const struct ide_port_info *,
+		      hw_regs_t **);
+void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
