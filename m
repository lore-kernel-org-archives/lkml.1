Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYB0WKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYB0WKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbYB0WIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:08:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:48912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161AbYB0WI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=BLInnPSjBRqUS9vOP6HUb0xlSh0xsY3/fOXM1LM7eAwTtnJ1n/sC2fz5HsNsr4+PhHyt5BszDwWGOO5gfSJWIFMDOBOAkSpwx0MIX1x2o6f1tEhZU6xv74YYX9kN+emSLJpfB+CCBkpnRvDSrw5D5OGB72AtZEcVM8lXCUf0d1M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide: add ide_legacy_device_add() helper
Date: Wed, 27 Feb 2008 23:20:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802272320.34982.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_legacy_device_add() helper for use by legacy VLB host drivers
(+ convert them to use it).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c      |   32 ++++++++++++++++++++++++++++++++
 drivers/ide/legacy/ali14xx.c |   28 +---------------------------
 drivers/ide/legacy/dtc2278.c |   27 +--------------------------
 drivers/ide/legacy/ht6560b.c |   28 +---------------------------
 drivers/ide/legacy/umc8672.c |   27 +--------------------------
 include/linux/ide.h          |    1 +
 6 files changed, 37 insertions(+), 106 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1629,3 +1629,35 @@ void ide_port_scan(ide_hwif_t *hwif)
 	ide_proc_port_register_devices(hwif);
 }
 EXPORT_SYMBOL_GPL(ide_port_scan);
+
+int ide_legacy_device_add(const struct ide_port_info *d)
+{
+	ide_hwif_t *hwif, *mate;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+	hw_regs_t hw[2];
+
+	memset(&hw, 0, sizeof(hw));
+
+	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
+	hw[0].irq = 14;
+
+	ide_std_init_ports(&hw[1], 0x170, 0x376);
+	hw[1].irq = 15;
+
+	hwif = ide_find_port();
+	if (hwif) {
+		ide_init_port_hw(hwif, &hw[0]);
+		idx[0] = hwif->index;
+	}
+
+	mate = ide_find_port();
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		idx[1] = mate->index;
+	}
+
+	ide_device_add(idx, d);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ide_legacy_device_add);
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -205,10 +205,6 @@ static const struct ide_port_info ali14x
 
 static int __init ali14xx_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
-
 	printk(KERN_DEBUG "ali14xx: base=0x%03x, regOn=0x%02x.\n",
 			  basePort, regOn);
 
@@ -218,29 +214,7 @@ static int __init ali14xx_probe(void)
 		return 1;
 	}
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ali14xx_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&ali14xx_port_info);
 }
 
 int probe_ali14xx;
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -106,9 +106,6 @@ static const struct ide_port_info dtc227
 static int __init dtc2278_probe(void)
 {
 	unsigned long flags;
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 
 	local_irq_save(flags);
 	/*
@@ -128,29 +125,7 @@ static int __init dtc2278_probe(void)
 #endif
 	local_irq_restore(flags);
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &dtc2278_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&dtc2278_port_info);
 }
 
 int probe_dtc2278 = 0;
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -346,10 +346,6 @@ static const struct ide_port_info ht6560
 
 static int __init ht6560b_init(void)
 {
-	ide_hwif_t *hwif, *mate;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
-
 	if (probe_ht6560b == 0)
 		return -ENODEV;
 
@@ -364,29 +360,7 @@ static int __init ht6560b_init(void)
 		goto release_region;
 	}
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &ht6560b_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&ht6560b_port_info);
 
 release_region:
 	release_region(HT_CONFIG_PORT, 1);
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -133,10 +133,7 @@ static const struct ide_port_info umc867
 
 static int __init umc8672_probe(void)
 {
-	ide_hwif_t *hwif, *mate;
 	unsigned long flags;
-	static u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
-	hw_regs_t hw[2];
 
 	if (!request_region(0x108, 2, "umc8672")) {
 		printk(KERN_ERR "umc8672: ports 0x108-0x109 already in use.\n");
@@ -155,29 +152,7 @@ static int __init umc8672_probe(void)
 	umc_set_speeds(current_speeds);
 	local_irq_restore(flags);
 
-	memset(&hw, 0, sizeof(hw));
-
-	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
-	hw[0].irq = 14;
-
-	ide_std_init_ports(&hw[1], 0x170, 0x376);
-	hw[1].irq = 15;
-
-	hwif = ide_find_port();
-	if (hwif) {
-		ide_init_port_hw(hwif, &hw[0]);
-		idx[0] = hwif->index;
-	}
-
-	mate = ide_find_port();
-	if (mate) {
-		ide_init_port_hw(mate, &hw[1]);
-		idx[1] = mate->index;
-	}
-
-	ide_device_add(idx, &umc8672_port_info);
-
-	return 0;
+	return ide_legacy_device_add(&umc8672_port_info);
 }
 
 int probe_umc8672;
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1215,6 +1215,7 @@ void ide_undecoded_slave(ide_drive_t *);
 
 int ide_device_add_all(u8 *idx, const struct ide_port_info *);
 int ide_device_add(u8 idx[4], const struct ide_port_info *);
+int ide_legacy_device_add(const struct ide_port_info *);
 void ide_port_unregister_devices(ide_hwif_t *);
 void ide_port_scan(ide_hwif_t *);
 
