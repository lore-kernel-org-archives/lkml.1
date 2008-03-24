Return-Path: <linux-kernel-owner+w=401wt.eu-S1763477AbYCXSjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763477AbYCXSjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762820AbYCXSin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:38:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:42484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762771AbYCXSil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TQDvxjcJgTyVydA4NpMQYxLeoRNOQlRKYVMDvRjbkcXM4WoNNOBB94HqjmwDqiO83DfSMhd6jHjgOFfis+DqFzekdkiUmmAfAS5o2rklnqoGexFfvQw56SxbuSNxf14Okl7IBeXaP8a2URzibuGbVAPLuo2LSw7ufTObcZU970Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2008 19:53:44 +0100
Message-Id: <20080324185344.15320.99641.sendpatchset@localhost.localdomain>
In-Reply-To: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
References: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/5] ide: fix hwif-s initialization
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ide_hwifs[] entry initialization to ide_find_port_slot()
  and remove ide_init_port_data() calls from host drivers.

* Unexport ide_init_port_data().

* Remove no longer needed init_ide_data().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c     |    1 -
 drivers/ide/arm/palm_bk3710.c  |    1 -
 drivers/ide/cris/ide-cris.c    |    2 +-
 drivers/ide/h8300/ide-h8300.c  |    1 -
 drivers/ide/ide-pnp.c          |    1 -
 drivers/ide/ide-probe.c        |   10 +++++++---
 drivers/ide/ide.c              |   15 ---------------
 drivers/ide/legacy/buddha.c    |    1 -
 drivers/ide/legacy/falconide.c |    1 -
 drivers/ide/legacy/gayle.c     |    1 -
 drivers/ide/legacy/ide-cs.c    |    1 -
 drivers/ide/legacy/macide.c    |    1 -
 drivers/ide/legacy/q40ide.c    |    1 -
 drivers/ide/pci/delkin_cb.c    |    1 -
 14 files changed, 8 insertions(+), 30 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -49,7 +49,6 @@ static int __init bastide_register(unsig
 
 	i = hwif->index;
 
-	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = NULL;
 
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -398,7 +398,6 @@ static int __devinit palm_bk3710_probe(s
 
 	i = hwif->index;
 
-	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->mmio = 1;
Index: b/drivers/ide/cris/ide-cris.c
===================================================================
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -811,7 +811,7 @@ static int __init init_e100_ide(void)
 		hwif = ide_find_port();
 		if (hwif == NULL)
 			continue;
-		ide_init_port_data(hwif, hwif->index);
+
 		ide_init_port_hw(hwif, &hw);
 
 		hwif->ata_input_data = &cris_ide_input_data;
Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -105,7 +105,6 @@ static int __init h8300_ide_init(void)
 	}
 
 	index = hwif->index;
-	ide_init_port_data(hwif, index);
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
 	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -61,7 +61,6 @@ static int idepnp_probe(struct pnp_dev *
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
 		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1478,22 +1478,26 @@ ide_hwif_t *ide_find_port_slot(const str
 		for (; i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 	} else {
 		for (i = 2; i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 		for (i = 0; i < 2 && i < MAX_HWIFS; i++) {
 			hwif = &ide_hwifs[i];
 			if (hwif->chipset == ide_unknown)
-				return hwif;
+				goto out_found;
 		}
 	}
 
 	return NULL;
+
+out_found:
+	ide_init_port_data(hwif, i);
+	return hwif;
 }
 EXPORT_SYMBOL_GPL(ide_find_port_slot);
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -121,7 +121,6 @@ void ide_init_port_data(ide_hwif_t *hwif
 
 	ide_port_init_devices_data(hwif);
 }
-EXPORT_SYMBOL_GPL(ide_init_port_data);
 
 static void ide_port_init_devices_data(ide_hwif_t *hwif)
 {
@@ -151,18 +150,6 @@ static void ide_port_init_devices_data(i
 	}
 }
 
-static void __init init_ide_data (void)
-{
-	unsigned int index;
-
-	/* Initialise all interface structures */
-	for (index = 0; index < MAX_HWIFS; ++index) {
-		ide_hwif_t *hwif = &ide_hwifs[index];
-
-		ide_init_port_data(hwif, index);
-	}
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -1024,8 +1011,6 @@ static int __init ide_init(void)
 	}
 	ide_port_class->dev_release = ide_port_class_release;
 
-	init_ide_data();
-
 	proc_ide_create();
 
 	return 0;
Index: b/drivers/ide/legacy/buddha.c
===================================================================
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -225,7 +225,6 @@ fail_base2:
 			if (hwif) {
 				u8 index = hwif->index;
 
-				ide_init_port_data(hwif, index);
 				ide_init_port_hw(hwif, &hw);
 
 				idx[i] = index;
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -87,7 +87,6 @@ static int __init falconide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
 		ide_get_lock(NULL, NULL);
Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -182,7 +182,6 @@ found:
 	if (hwif) {
 	    u8 index = hwif->index;
 
-	    ide_init_port_data(hwif, index);
 	    ide_init_port_hw(hwif, &hw);
 
 	    idx[i] = index;
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -183,7 +183,6 @@ static ide_hwif_t *idecs_register(unsign
 
     i = hwif->index;
 
-    ide_init_port_data(hwif, i);
     ide_init_port_hw(hwif, &hw);
     hwif->port_ops = &idecs_port_ops;
 
Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -125,7 +125,6 @@ static int __init macide_init(void)
 		u8 index = hwif->index;
 		u8 idx[4] = { index, 0xff, 0xff, 0xff };
 
-		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
 		ide_device_add(idx, NULL);
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -139,7 +139,6 @@ static int __init q40ide_init(void)
 
 	hwif = ide_find_port();
 	if (hwif) {
-		ide_init_port_data(hwif, hwif->index);
 		ide_init_port_hw(hwif, &hw);
 
 		idx[i] = hwif->index;
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -87,7 +87,6 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	i = hwif->index;
 
-	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = &delkin_cb_port_ops;
 
