Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbYBQShg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbYBQShg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbYBQSgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:36:54 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:63272 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYBQSgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:36:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lXt85Z7rcghCk1LSo4fLRltJES5oAwHaZtXYx5/Kq2i3bcrTu2UEuw7sHx0ynhhhWsq4yctv7eB58qt+0e+oqywSkC0fNAebtfHYKNQQ26g5CBXSjWCC67cAJeyqV9KNGS81FKpkd+1ks2KSXwOVJFBe8HnB/0uv5gNE7WhSgfM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Feb 2008 19:51:22 +0100
Message-Id: <20080217185122.16210.63324.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/5] ide: use ide_find_port() in legacy VLB host drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add IDE_HFLAG_QD_2ND_PORT host flag to indicate the need of skipping
  first ide_hwifs[] slot for the second port of QD65xx controller.

* Handle this new host flag in ide_find_port_slot().

* Convert legacy VLB host drivers to use ide_find_port().

While at it:

* Fix couple of printk()-s in qd65xx host driver to not use hwif->name.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c          |    4 +-
 drivers/ide/legacy/ali14xx.c     |   19 ++++++++---
 drivers/ide/legacy/dtc2278.c     |   22 +++++++------
 drivers/ide/legacy/ht6560b.c     |   31 ++++++++++--------
 drivers/ide/legacy/ide-4drives.c |   34 +++++++++++---------
 drivers/ide/legacy/qd65xx.c      |   66 +++++++++++++++++++++------------------
 drivers/ide/legacy/umc8672.c     |   19 ++++++++---
 include/linux/ide.h              |    2 +
 8 files changed, 119 insertions(+), 78 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1459,7 +1459,9 @@ ide_hwif_t *ide_find_port_slot(const str
 	 * ports 0x1f0/0x170 (the ide0/ide1 defaults).
 	 */
 	if (bootable) {
-		for (i = 0; i < MAX_HWIFS; i++) {
+		i = (d && (d->host_flags & IDE_HFLAG_QD_2ND_PORT)) ? 1 : 0;
+
+		for (; i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
 				return hwif;
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -199,7 +199,8 @@ static const struct ide_port_info ali14x
 
 static int __init ali14xx_probe(void)
 {
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	ide_hwif_t *hwif, *mate;
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
@@ -219,11 +220,19 @@ static int __init ali14xx_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
-	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = &ali14xx_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	ide_hwifs[0].set_pio_mode = &ali14xx_set_pio_mode;
-	ide_hwifs[1].set_pio_mode = &ali14xx_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->set_pio_mode = &ali14xx_set_pio_mode;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &ali14xx_port_info);
 
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -102,15 +102,9 @@ static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
 	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
-	if (hwif->chipset != ide_unknown || mate->chipset != ide_unknown)
-		return 1;
-
 	local_irq_save(flags);
 	/*
 	 * This enables the second interface
@@ -137,10 +131,18 @@ static int __init dtc2278_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(hwif, &hw[0]);
-	ide_init_port_hw(mate, &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = dtc2278_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	hwif->set_pio_mode = &dtc2278_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &dtc2278_port_info);
 
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -331,15 +331,12 @@ static const struct ide_port_info ht6560
 static int __init ht6560b_init(void)
 {
 	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	if (probe_ht6560b == 0)
 		return -ENODEV;
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
 	if (!request_region(HT_CONFIG_PORT, 1, DRV_NAME)) {
 		printk(KERN_NOTICE "%s: HT_CONFIG_PORT not found\n",
 			__FUNCTION__);
@@ -359,17 +356,23 @@ static int __init ht6560b_init(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(hwif, &hw[0]);
-	ide_init_port_hw(mate, &hw[1]);
-
-	hwif->selectproc = &ht6560b_selectproc;
-	hwif->set_pio_mode = &ht6560b_set_pio_mode;
-
-	mate->selectproc = &ht6560b_selectproc;
-	mate->set_pio_mode = &ht6560b_set_pio_mode;
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->selectproc     = ht6560b_selectproc;
+		hwif->set_pio_mode   = ht6560b_set_pio_mode;
+		hwif->port_init_devs = ht6560b_port_init_devs;
+		idx[0] = hwif->index;
+	}
 
-	hwif->port_init_devs = ht6560b_port_init_devs;
-	mate->port_init_devs = ht6560b_port_init_devs;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->selectproc     = ht6560b_selectproc;
+		mate->set_pio_mode   = ht6560b_set_pio_mode;
+		mate->port_init_devs = ht6560b_port_init_devs;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &ht6560b_port_info);
 
Index: b/drivers/ide/legacy/ide-4drives.c
===================================================================
--- a/drivers/ide/legacy/ide-4drives.c
+++ b/drivers/ide/legacy/ide-4drives.c
@@ -12,31 +12,37 @@ MODULE_PARM_DESC(probe, "probe for gener
 static int __init ide_4drives_init(void)
 {
 	ide_hwif_t *hwif, *mate;
-	u8 idx[4] = { 0, 1, 0xff, 0xff };
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw;
 
 	if (probe_4drives == 0)
 		return -ENODEV;
 
-	hwif = &ide_hwifs[0];
-	mate = &ide_hwifs[1];
-
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw, 0x1f0, 0x3f6);
 	hw.irq = 14;
 	hw.chipset = ide_4drives;
 
-	ide_init_port_hw(hwif, &hw);
-	ide_init_port_hw(mate, &hw);
-
-	mate->drives[0].select.all ^= 0x20;
-	mate->drives[1].select.all ^= 0x20;
-
-	hwif->mate = mate;
-	mate->mate = hwif;
-
-	hwif->serialized = mate->serialized = 1;
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw);
+		idx[0] = hwif->index;
+	}
+
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw);
+		mate->drives[0].select.all ^= 0x20;
+		mate->drives[1].select.all ^= 0x20;
+		idx[1] = mate->index;
+
+		if (hwif) {
+			hwif->mate = mate;
+			mate->mate = hwif;
+			hwif->serialized = mate->serialized = 1;
+		}
+	}
 
 	ide_device_add(idx, NULL);
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -392,6 +392,7 @@ static int __init qd_probe(int base)
 	u8 config, unit;
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
+	struct ide_port_info d = qd65xx_port_info;
 
 	config = inb(QD_CONFIG_PORT);
 
@@ -400,6 +401,9 @@ static int __init qd_probe(int base)
 
 	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
 
+	if (unit)
+		d.host_flags |= IDE_HFLAG_QD_2ND_PORT;
+
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
@@ -415,16 +419,19 @@ static int __init qd_probe(int base)
 
 		/* qd6500 found */
 
-		hwif = &ide_hwifs[unit];
-		printk(KERN_NOTICE "%s: qd6500 at %#x\n", hwif->name, base);
-		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
-			config, QD_ID3);
-		
 		if (config & QD_CONFIG_DISABLED) {
 			printk(KERN_WARNING "qd6500 is disabled !\n");
 			return -ENODEV;
 		}
 
+		printk(KERN_NOTICE "qd6500 at %#x\n", base);
+		printk(KERN_DEBUG "qd6500: config=%#x, ID3=%u\n",
+			config, QD_ID3);
+
+		hwif = ide_find_port_slot(&d);
+		if (hwif == NULL)
+			return -ENOENT;
+
 		ide_init_port_hw(hwif, &hw[unit]);
 
 		qd_setup(hwif, base, config);
@@ -434,7 +441,7 @@ static int __init qd_probe(int base)
 
 		idx[unit] = unit;
 
-		ide_device_add(idx, &qd65xx_port_info);
+		ide_device_add(idx, &d);
 
 		return 1;
 	}
@@ -458,9 +465,11 @@ static int __init qd_probe(int base)
 		if (control & QD_CONTR_SEC_DISABLED) {
 			/* secondary disabled */
 
-			hwif = &ide_hwifs[unit];
-			printk(KERN_INFO "%s: qd6580: single IDE board\n",
-					 hwif->name);
+			printk(KERN_INFO "qd6580: single IDE board\n");
+
+			hwif = ide_find_port_slot(&d);
+			if (hwif == NULL)
+				return -ENOENT;
 
 			ide_init_port_hw(hwif, &hw[unit]);
 
@@ -471,7 +480,7 @@ static int __init qd_probe(int base)
 
 			idx[unit] = unit;
 
-			ide_device_add(idx, &qd65xx_port_info);
+			ide_device_add(idx, &d);
 
 			outb(QD_DEF_CONTR, QD_CONTROL_PORT);
 
@@ -479,27 +488,26 @@ static int __init qd_probe(int base)
 		} else {
 			ide_hwif_t *mate;
 
-			hwif = &ide_hwifs[0];
-			mate = &ide_hwifs[1];
 			/* secondary enabled */
-			printk(KERN_INFO "%s&%s: qd6580: dual IDE board\n",
-					hwif->name, mate->name);
-
-			ide_init_port_hw(hwif, &hw[0]);
-			ide_init_port_hw(mate, &hw[1]);
-
-			qd_setup(hwif, base, config | (control << 8));
-
-			hwif->port_init_devs = qd6580_port_init_devs;
-			hwif->set_pio_mode = &qd6580_set_pio_mode;
-
-			qd_setup(mate, base, config | (control << 8));
-
-			mate->port_init_devs = qd6580_port_init_devs;
-			mate->set_pio_mode = &qd6580_set_pio_mode;
+			printk(KERN_INFO "qd6580: dual IDE board\n");
 
-			idx[0] = 0;
-			idx[1] = 1;
+			hwif = ide_find_port();
+			if (hwif) {
+				ide_init_port_hw(hwif, &hw[0]);
+				qd_setup(hwif, base, config | (control << 8));
+				hwif->port_init_devs = qd6580_port_init_devs;
+				hwif->set_pio_mode   = qd6580_set_pio_mode;
+				idx[0] = 0;
+			}
+
+			mate = ide_find_port();
+			if (mate) {
+				ide_init_port_hw(mate, &hw[1]);
+				qd_setup(mate, base, config | (control << 8));
+				mate->port_init_devs = qd6580_port_init_devs;
+				mate->set_pio_mode   = qd6580_set_pio_mode;
+				idx[1] = 1;
+			}
 
 			ide_device_add(idx, &qd65xx_port_info);
 
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -128,8 +128,9 @@ static const struct ide_port_info umc867
 
 static int __init umc8672_probe(void)
 {
+	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
-	static u8 idx[4] = { 0, 1, 0xff, 0xff };
+	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 	hw_regs_t hw[2];
 
 	if (!request_region(0x108, 2, "umc8672")) {
@@ -157,11 +158,19 @@ static int __init umc8672_probe(void)
 	ide_std_init_ports(&hw[1], 0x170, 0x376);
 	hw[1].irq = 15;
 
-	ide_init_port_hw(&ide_hwifs[0], &hw[0]);
-	ide_init_port_hw(&ide_hwifs[1], &hw[1]);
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		hwif->set_pio_mode = umc_set_pio_mode;
+		idx[0] = hwif->index;
+	}
 
-	ide_hwifs[0].set_pio_mode = &umc_set_pio_mode;
-	ide_hwifs[1].set_pio_mode = &umc_set_pio_mode;
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		mate->set_pio_mode = umc_set_pio_mode;
+		idx[1] = mate->index;
+	}
 
 	ide_device_add(idx, &umc8672_port_info);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1037,6 +1037,8 @@ enum {
 	IDE_HFLAG_SINGLE		= (1 << 1),
 	/* don't use legacy PIO blacklist */
 	IDE_HFLAG_PIO_NO_BLACKLIST	= (1 << 2),
+	/* set for the second port of QD65xx */
+	IDE_HFLAG_QD_2ND_PORT		= (1 << 3),
 	/* use PIO8/9 for prefetch off/on */
 	IDE_HFLAG_ABUSE_PREFETCH	= (1 << 4),
 	/* use PIO6/7 for fast-devsel off/on */
