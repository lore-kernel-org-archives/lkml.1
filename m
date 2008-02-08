Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbYBHAcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbYBHAcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762679AbYBHAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:30:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:22130 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762246AbYBHAaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wrQ/ebf+AJO9niMmY3y2ZE4YlCxplSWxIyUA0hWABDdMMZcl9RC8HZfv4/oMWW6OKvj56fkOyB6CwUciuKEA9nNeBfat6GBK0oifExbGE5qRjzhRiblwlj1K5baE6NIKr21HNw/nNivwAST1h+Yz41iKbJkOul8Xk3Ha1zt3Mmg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 01:44:41 +0100
Message-Id: <20080208004441.17746.56994.sendpatchset@localhost.localdomain>
In-Reply-To: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
References: <20080208004421.17746.32557.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/18] ide: use ide_find_port() instead of ide_deprecated_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use ide_find_port() instead of ide_deprecated_find_port() in bast-ide/
  palm_bk3710/ide-cs/delkin_cb host drivers and in ide_register_hw().

* Remove no longer needed ide_deprecated_find_port().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c    |    2 +-
 drivers/ide/arm/palm_bk3710.c |    2 +-
 drivers/ide/ide.c             |   27 +--------------------------
 drivers/ide/legacy/ide-cs.c   |    2 +-
 drivers/ide/pci/delkin_cb.c   |    2 +-
 include/linux/ide.h           |    1 -
 6 files changed, 5 insertions(+), 31 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -46,7 +46,7 @@ bastide_register(unsigned int base, unsi
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out;
 
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -378,7 +378,7 @@ static int __devinit palm_bk3710_probe(s
 	hw.irq = irq->start;
 	hw.chipset = ide_palm3710;
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out;
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -627,31 +627,6 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
-ide_hwif_t *ide_deprecated_find_port(unsigned long base)
-{
-	ide_hwif_t *hwif;
-	int i;
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
-			goto found;
-	}
-
-	for (i = 0; i < MAX_HWIFS; i++) {
-		hwif = &ide_hwifs[i];
-		if (hwif->hold)
-			continue;
-		if (!hwif->present && hwif->mate == NULL)
-			goto found;
-	}
-
-	hwif = NULL;
-found:
-	return hwif;
-}
-EXPORT_SYMBOL_GPL(ide_deprecated_find_port);
-
 /**
  *	ide_register_hw		-	register IDE interface
  *	@hw: hardware registers
@@ -671,7 +646,7 @@ int ide_register_hw(hw_regs_t *hw, void 
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	do {
-		hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
+		hwif = ide_find_port(hw->io_ports[IDE_DATA_OFFSET]);
 		index = hwif->index;
 		if (hwif)
 			goto found;
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -156,7 +156,7 @@ static int idecs_register(unsigned long 
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
 
-    hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
     if (hwif == NULL)
 	return -1;
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -78,7 +78,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	hwif = ide_find_port(hw.io_ports[IDE_DATA_OFFSET]);
 	if (hwif == NULL)
 		goto out_disable;
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -186,7 +186,6 @@ typedef struct hw_regs_s {
 } hw_regs_t;
 
 struct hwif_s * ide_find_port(unsigned long);
-struct hwif_s *ide_deprecated_find_port(unsigned long);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
