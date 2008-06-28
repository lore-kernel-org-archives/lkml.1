Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYF1VmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYF1VmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 17:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYF1Vlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 17:41:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYF1Vlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 17:41:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=BNnOkeHAaTafsvSHnb4WeVNC65wDCzTPrnSMjELODHsgL0fsJyIsRirj3tIr7jm+fI
         SMhoVkg1F1dAzou2RV//m5ikwgO9NtbYbOdEuUNRgYTZxZYsUg1Hf+7et6U7o9gMtFYr
         5eUg8vl8bieNU0doBT45ud93/Lbvtk+Lc03Es=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 28 Jun 2008 23:43:55 +0200
Message-Id: <20080628214355.21345.94835.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/7] ide: add ide_host_add() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_host_add() helper which does ide_host_alloc()+ide_host_register(),
then convert ide_setup_pci_device[s](), ide_legacy_device_add() and some
host drivers to use it.

While at it:

* Fix ide_setup_pci_device[s](), ide_arm.c, gayle.c, ide-4drives.c,
  macide.c, q40ide.c, cmd640.c and cs5520.c to return correct error value.

* -ENOENT -> -ENOMEM in rapide.c, ide-h8300.c, ide-generic.c, au1xxx-ide.c
  and pmac.c

* -ENODEV -> -ENOMEM in palm_bk3710.c, ide_platform.c and delkin_cb.c

* -1 -> -ENOMEM in ide-pnp.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/ide_arm.c         |    7 +------
 drivers/ide/arm/palm_bk3710.c     |   10 ++++------
 drivers/ide/arm/rapide.c          |    8 ++------
 drivers/ide/h8300/ide-h8300.c     |    9 +--------
 drivers/ide/ide-generic.c         |   11 ++++-------
 drivers/ide/ide-pnp.c             |   16 ++++++++--------
 drivers/ide/ide-probe.c           |   27 +++++++++++++++++++--------
 drivers/ide/legacy/buddha.c       |    5 +----
 drivers/ide/legacy/gayle.c        |    7 +------
 drivers/ide/legacy/ide-4drives.c  |    7 +------
 drivers/ide/legacy/ide-cs.c       |    8 +++-----
 drivers/ide/legacy/ide_platform.c |    8 ++------
 drivers/ide/legacy/macide.c       |    7 +------
 drivers/ide/legacy/q40ide.c       |    7 +------
 drivers/ide/mips/au1xxx-ide.c     |    8 ++------
 drivers/ide/mips/swarm.c          |   10 ++++------
 drivers/ide/pci/cmd640.c          |    7 +------
 drivers/ide/pci/cs5520.c          |    7 +------
 drivers/ide/pci/delkin_cb.c       |    8 +++-----
 drivers/ide/pci/scc_pata.c        |   10 ++++------
 drivers/ide/ppc/pmac.c            |    9 ++++-----
 drivers/ide/setup-pci.c           |   10 ++--------
 include/linux/ide.h               |    2 ++
 23 files changed, 72 insertions(+), 136 deletions(-)

Index: b/drivers/ide/arm/ide_arm.c
===================================================================
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -28,7 +28,6 @@
 
 static int __init ide_arm_init(void)
 {
-	struct ide_host *host;
 	unsigned long base = IDE_ARM_IO, ctl = IDE_ARM_IO + 0x206;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
@@ -50,11 +49,7 @@ static int __init ide_arm_init(void)
 	hw.irq = IDE_ARM_IRQ;
 	hw.chipset = ide_generic;
 
-	host = ide_host_alloc(NULL, hws);
-	if (host)
-		ide_host_register(host, NULL, hws);
-
-	return 0;
+	return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(ide_arm_init);
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -351,7 +351,7 @@ static int __devinit palm_bk3710_probe(s
 	struct resource *mem, *irq;
 	struct ide_host *host;
 	unsigned long base;
-	int i;
+	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	clkp = clk_get(NULL, "IDECLK");
@@ -394,16 +394,14 @@ static int __devinit palm_bk3710_probe(s
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	host = ide_host_alloc(&palm_bk3710_port_info, hws);
-	if (host == NULL)
+	rc = ide_host_add(&palm_bk3710_port_info, hws, NULL);
+	if (rc)
 		goto out;
 
-	ide_host_register(host, &palm_bk3710_port_info, hws);
-
 	return 0;
 out:
 	printk(KERN_WARNING "Palm Chip BK3710 IDE Register Fail\n");
-	return -ENODEV;
+	return rc;
 }
 
 /* work with hotplug and coldplug */
Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -52,13 +52,9 @@ rapide_probe(struct expansion_card *ec, 
 	hw.chipset = ide_generic;
 	hw.dev = &ec->dev;
 
-	host = ide_host_alloc(&rapide_port_info, hws);
-	if (host == NULL) {
-		ret = -ENOENT;
+	ret = ide_host_add(&rapide_port_info, hws, &host);
+	if (ret)
 		goto release;
-	}
-
-	ide_host_register(host, &rapide_port_info, hws);
 
 	ecard_set_drvdata(ec, host);
 	goto out;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -191,7 +191,6 @@ static const struct ide_port_info h8300_
 
 static int __init h8300_ide_init(void)
 {
-	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	printk(KERN_INFO DRV_NAME ": H8/300 generic IDE interface\n");
@@ -205,13 +204,7 @@ static int __init h8300_ide_init(void)
 
 	hw_setup(&hw);
 
-	host = ide_host_alloc(&h8300_port_info, hws);
-	if (host == NULL)
-		return -ENOENT;
-
-	ide_host_register(host, &h8300_port_info, hws);
-
-	return 0;
+	return ide_host_add(&h8300_port_info, hws, NULL);
 
 out_busy:
 	printk(KERN_ERR "ide-h8300: IDE I/F resource already used.\n");
Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -28,9 +28,8 @@ MODULE_PARM_DESC(probe_mask, "probe mask
 
 static ssize_t store_add(struct class *cls, const char *buf, size_t n)
 {
-	struct ide_host *host;
 	unsigned int base, ctl;
-	int irq;
+	int irq, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (sscanf(buf, "%x:%x:%d", &base, &ctl, &irq) != 3)
@@ -41,11 +40,9 @@ static ssize_t store_add(struct class *c
 	hw.irq = irq;
 	hw.chipset = ide_generic;
 
-	host = ide_host_alloc(NULL, hws);
-	if (host == NULL)
-		return -ENOENT;
-
-	ide_host_register(host, NULL, hws);
+	rc = ide_host_add(NULL, hws, NULL);
+	if (rc)
+		return rc;
 
 	return n;
 };
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -31,6 +31,7 @@ static int idepnp_probe(struct pnp_dev *
 {
 	struct ide_host *host;
 	unsigned long base, ctl;
+	int rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
@@ -59,19 +60,18 @@ static int idepnp_probe(struct pnp_dev *
 	hw.irq = pnp_irq(dev, 0);
 	hw.chipset = ide_generic;
 
-	host = ide_host_alloc(NULL, hws);
-	if (host) {
-		pnp_set_drvdata(dev, host);
+	rc = ide_host_add(NULL, hws, &host);
+	if (rc)
+		goto out;
 
-		ide_host_register(host, NULL, hws);
-
-		return 0;
-	}
+	pnp_set_drvdata(dev, host);
 
+	return 0;
+out:
 	release_region(ctl, 1);
 	release_region(base, 8);
 
-	return -1;
+	return rc;
 }
 
 static void idepnp_remove(struct pnp_dev *dev)
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1683,6 +1683,24 @@ int ide_host_register(struct ide_host *h
 }
 EXPORT_SYMBOL_GPL(ide_host_register);
 
+int ide_host_add(const struct ide_port_info *d, hw_regs_t **hws,
+		 struct ide_host **hostp)
+{
+	struct ide_host *host;
+
+	host = ide_host_alloc(d, hws);
+	if (host == NULL)
+		return -ENOMEM;
+
+	ide_host_register(host, d, hws);
+
+	if (hostp)
+		*hostp = host;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_host_add);
+
 void ide_host_remove(struct ide_host *host)
 {
 	int i;
@@ -1755,7 +1773,6 @@ static void ide_legacy_init_one(hw_regs_
 
 int ide_legacy_device_add(const struct ide_port_info *d, unsigned long config)
 {
-	struct ide_host *host;
 	hw_regs_t hw[2], *hws[] = { NULL, NULL, NULL, NULL };
 
 	memset(&hw, 0, sizeof(hw));
@@ -1768,12 +1785,6 @@ int ide_legacy_device_add(const struct i
 	    (d->host_flags & IDE_HFLAG_SINGLE))
 		return -ENOENT;
 
-	host = ide_host_alloc(d, hws);
-	if (host == NULL)
-		return -ENOMEM;
-
-	ide_host_register(host, d, hws);
-
-	return 0;
+	return ide_host_add(d, hws, NULL);
 }
 EXPORT_SYMBOL_GPL(ide_legacy_device_add);
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -151,7 +151,6 @@ static void __init buddha_setup_ports(hw
 static int __init buddha_init(void)
 {
 	struct zorro_dev *z = NULL;
-	struct ide_host *host;
 	u_long buddha_board = 0;
 	BuddhaType type;
 	int buddha_num_hwifs, i;
@@ -226,9 +225,7 @@ fail_base2:
 			hws[i] = &hw[i];
 		}
 
-		host = ide_host_alloc(NULL, hws);
-		if (host)
-			ide_host_register(host, NULL, hws);
+		ide_host_add(NULL, hws, NULL);
 	}
 
 	return 0;
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -127,7 +127,6 @@ static int __init gayle_init(void)
     unsigned long phys_base, res_start, res_n;
     unsigned long base, ctrlport, irqport;
     ide_ack_intr_t *ack_intr;
-    struct ide_host *host;
     int a4000, i;
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
@@ -180,11 +179,7 @@ found:
 	hws[i] = &hw[i];
     }
 
-    host = ide_host_alloc(NULL, hws);
-    if (host)
-	ide_host_register(host, NULL, hws);
-
-    return 0;
+    return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(gayle_init);
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -28,7 +28,6 @@ static const struct ide_port_info ide_4d
 
 static int __init ide_4drives_init(void)
 {
-	struct ide_host *host;
 	unsigned long base = 0x1f0, ctl = 0x3f6;
 	hw_regs_t hw, *hws[] = { &hw, &hw, NULL, NULL };
 
@@ -54,11 +53,7 @@ static int __init ide_4drives_init(void)
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
-	host = ide_host_alloc(&ide_4drives_port_info, hws);
-	if (host)
-		ide_host_register(host, &ide_4drives_port_info, hws);
-
-	return 0;
+	return ide_host_add(&ide_4drives_port_info, hws, NULL);
 }
 
 module_init(ide_4drives_init);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -164,7 +164,7 @@ static struct ide_host *idecs_register(u
 {
     struct ide_host *host;
     ide_hwif_t *hwif;
-    int i;
+    int i, rc;
     hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
     if (!request_region(io, 8, DRV_NAME)) {
@@ -186,12 +186,10 @@ static struct ide_host *idecs_register(u
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    host = ide_host_alloc(&idecs_port_info, hws);
-    if (host == NULL)
+    rc = ide_host_add(&idecs_port_info, hws, &host);
+    if (rc)
 	goto out_release;
 
-    ide_host_register(host, &idecs_port_info, hws);
-
     hwif = host->ports[0];
 
     if (hwif->present)
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -99,13 +99,9 @@ static int __devinit plat_ide_probe(stru
 	if (mmio)
 		d.host_flags |= IDE_HFLAG_MMIO;
 
-	host = ide_host_alloc(&d, hws);
-	if (host == NULL) {
-		ret = -ENODEV;
+	ret = ide_host_add(&d, hws, &host);
+	if (ret)
 		goto out;
-	}
-
-	ide_host_register(host, &d, hws);
 
 	platform_set_drvdata(pdev, host);
 
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -92,7 +92,6 @@ static const char *mac_ide_name[] =
 static int __init macide_init(void)
 {
 	ide_ack_intr_t *ack_intr;
-	struct ide_host *host;
 	unsigned long base;
 	int irq;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
@@ -125,11 +124,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	host = ide_host_alloc(NULL, hws);
-	if (host)
-		ide_host_register(host, NULL, hws);
-
-	return 0;
+	return ide_host_add(NULL, hws, NULL);
 }
 
 module_init(macide_init);
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -131,7 +131,6 @@ static const char *q40_ide_names[Q40IDE_
 
 static int __init q40ide_init(void)
 {
-    struct ide_host *host;
     int i;
     hw_regs_t hw[Q40IDE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
 
@@ -160,11 +159,7 @@ static int __init q40ide_init(void)
 	hws[i] = &hw[i];
     }
 
-    host = ide_host_alloc(&q40ide_port_info, hws);
-    if (host)
-	ide_host_register(host, &q40ide_port_info, hws);
-
-    return 0;
+    return ide_host_add(&q40ide_port_info, hws, NULL);
 }
 
 module_init(q40ide_init);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -609,13 +609,9 @@ static int au_ide_probe(struct device *d
 	hw.dev = dev;
 	hw.chipset = ide_au1xxx;
 
-	host = ide_host_alloc(&au1xxx_port_info, hws);
-	if (host == NULL) {
-		ret = -ENOENT;
+	ret = ide_host_add(&au1xxx_port_info, hws, &host);
+	if (ret)
 		goto out;
-	}
-
-	ide_host_register(host, &au1xxx_port_info, hws);
 
 	auide_hwif.hwif = host->ports[0];
 
Index: b/drivers/ide/mips/swarm.c
===================================================================
--- a/drivers/ide/mips/swarm.c
+++ b/drivers/ide/mips/swarm.c
@@ -75,7 +75,7 @@ static int __devinit swarm_ide_probe(str
 	u8 __iomem *base;
 	struct ide_host *host;
 	phys_t offset, size;
-	int i;
+	int i, rc;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
 
 	if (!SIBYTE_HAVE_IDE)
@@ -115,19 +115,17 @@ static int __devinit swarm_ide_probe(str
 	hw.irq = K_INT_GB_IDE;
 	hw.chipset = ide_generic;
 
-	host = ide_host_alloc(&swarm_port_info, hws);
-	if (host == NULL)
+	rc = ide_host_add(&swarm_port_info, hws, &host);
+	if (rc)
 		goto err;
 
-	ide_host_register(host, &swarm_port_info, hws);
-
 	dev_set_drvdata(dev, host);
 
 	return 0;
 err:
 	release_resource(&swarm_ide_resource);
 	iounmap(base);
-	return -ENOMEM;
+	return rc;
 }
 
 static struct device_driver swarm_ide_driver = {
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -709,7 +709,6 @@ static int cmd640x_init_one(unsigned lon
  */
 static int __init cmd640x_init(void)
 {
-	struct ide_host *host;
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	u8 b, cfr;
@@ -829,11 +828,7 @@ static int __init cmd640x_init(void)
 	cmd640_dump_regs();
 #endif
 
-	host = ide_host_alloc(&cmd640_port_info, hws);
-	if (host)
-		ide_host_register(host, &cmd640_port_info, hws);
-
-	return 1;
+	return ide_host_add(&cmd640_port_info, hws, NULL);
 }
 
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -114,7 +114,6 @@ static const struct ide_port_info cyrix_
  
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	struct ide_host *host;
 	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
@@ -140,11 +139,7 @@ static int __devinit cs5520_init_one(str
 
 	ide_pci_setup_ports(dev, d, 14, &hw[0], &hws[0]);
 
-	host = ide_host_alloc(d, hws);
-	if (host)
-		ide_host_register(host, d, hws);
-
-	return 0;
+	return ide_host_add(d, hws, NULL);
 }
 
 static const struct pci_device_id cs5520_pci_tbl[] = {
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -86,12 +86,10 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	host = ide_host_alloc(&delkin_cb_port_info, hws);
-	if (host == NULL)
+	rc = ide_host_add(&delkin_cb_port_info, hws, &host);
+	if (rc)
 		goto out_disable;
 
-	ide_host_register(host, &delkin_cb_port_info, hws);
-
 	pci_set_drvdata(dev, host);
 
 	return 0;
@@ -99,7 +97,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 out_disable:
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	return -ENODEV;
+	return rc;
 }
 
 static void
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -588,7 +588,7 @@ static int scc_ide_setup_pci_device(stru
 	struct scc_ports *ports = pci_get_drvdata(dev);
 	struct ide_host *host;
 	hw_regs_t hw, *hws[] = { &hw, NULL, NULL, NULL };
-	int i;
+	int i, rc;
 
 	memset(&hw, 0, sizeof(hw));
 	for (i = 0; i <= 8; i++)
@@ -597,11 +597,9 @@ static int scc_ide_setup_pci_device(stru
 	hw.dev = &dev->dev;
 	hw.chipset = ide_pci;
 
-	host = ide_host_alloc(d, hws);
-	if (host == NULL)
-		return -ENOMEM;
-
-	ide_host_register(host, d, hws);
+	rc = ide_host_add(d, hws, &host);
+	if (rc)
+		return rc;
 
 	ports->host = host;
 
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1041,6 +1041,7 @@ static int __devinit pmac_ide_setup_devi
 	ide_hwif_t *hwif;
 	hw_regs_t *hws[] = { hw, NULL, NULL, NULL };
 	struct ide_port_info d = pmac_port_info;
+	int rc;
 
 	pmif->broken_dma = pmif->broken_dma_warn = 0;
 	if (of_device_is_compatible(np, "shasta-ata")) {
@@ -1112,11 +1113,9 @@ static int __devinit pmac_ide_setup_devi
 			 pmif->mdev ? "macio" : "PCI", pmif->aapl_bus_id,
 			 pmif->mediabay ? " (mediabay)" : "", hw->irq);
 
-	host = ide_alloc_host(&d, hws);
-	if (host == NULL)
-		return -ENOENT;
-
-	ide_host_register(host, &d, hws);
+	rc = ide_host_add(&d, hws, &host);
+	if (rc)
+		return rc;
 
 	hwif = host->ports[0];
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -540,7 +540,6 @@ out:
 
 int ide_setup_pci_device(struct pci_dev *dev, const struct ide_port_info *d)
 {
-	struct ide_host *host;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 	int ret;
 
@@ -550,9 +549,7 @@ int ide_setup_pci_device(struct pci_dev 
 		/* FIXME: silent failure can happen */
 		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
 
-		host = ide_host_alloc(d, hws);
-		if (host)
-			ide_host_register(host, d, hws);
+		ret = ide_host_add(d, hws, NULL);
 	}
 
 	return ret;
@@ -563,7 +560,6 @@ int ide_setup_pci_devices(struct pci_dev
 			  const struct ide_port_info *d)
 {
 	struct pci_dev *pdev[] = { dev1, dev2 };
-	struct ide_host *host;
 	int ret, i;
 	hw_regs_t hw[4], *hws[] = { NULL, NULL, NULL, NULL };
 
@@ -581,9 +577,7 @@ int ide_setup_pci_devices(struct pci_dev
 		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
 	}
 
-	host = ide_host_alloc(d, hws);
-	if (host)
-		ide_host_register(host, d, hws);
+	ret = ide_host_add(d, hws, NULL);
 out:
 	return ret;
 }
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1224,6 +1224,8 @@ struct ide_host *ide_host_alloc_all(cons
 struct ide_host *ide_host_alloc(const struct ide_port_info *, hw_regs_t **);
 int ide_host_register(struct ide_host *, const struct ide_port_info *,
 		      hw_regs_t **);
+int ide_host_add(const struct ide_port_info *, hw_regs_t **,
+		 struct ide_host **);
 void ide_host_remove(struct ide_host *);
 int ide_legacy_device_add(const struct ide_port_info *, unsigned long);
 void ide_port_unregister_devices(ide_hwif_t *);
