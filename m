Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYAPXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYAPXPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYAPXNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:13:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbYAPXNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=H7xCWjBTz0u0shv4wnuAjsPiADdZmPgQ3qHTnvh5RCRza0HBqP3F3GM70Z8OMZdK+poaefE3i4i5hei9J6cat01PONdh1/ImpDxijiWkK53/dQiMyBmXqfZcUSRZa2jDSheAKOn9g5hzIXcA9TkBhw5Su4QKiRtLZ0/Xw+jqR9c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:26:24 +0100
Message-Id: <20080116232624.9166.73929.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/22] ide: add ide_deprecated_find_port() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out code for finding ide_hwifs[] slot from ide_register_hw()
  to ide_deprecated_find_port().

* Convert bast-ide, ide-cs and delkin_cb host drivers to use ide_device_add()
  instead of ide_register_hw() (while at it drop doing "ide_unregister()" loop
  which tries to unregister _all_ IDE interfaces if useable ide_hwifs[] slot
  cannot be find).

This patch leaves us with only two ide_register_hw() users:
- drivers/macintosh/mediabay.c
- drivers/ide/ide.c

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c  |   20 +++++++++++++++++++-
 drivers/ide/ide.c           |   41 +++++++++++++++++++++++++++++------------
 drivers/ide/legacy/ide-cs.c |   25 ++++++++++++++++++++++++-
 drivers/ide/pci/delkin_cb.c |   33 +++++++++++++++++++++++++++------
 include/linux/ide.h         |    1 +
 5 files changed, 100 insertions(+), 20 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -28,8 +28,10 @@ static int __init
 bastide_register(unsigned int base, unsigned int aux, int irq,
 		 ide_hwif_t **hwif)
 {
+	ide_hwif_t *hwif;
 	hw_regs_t hw;
 	int i;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	memset(&hw, 0, sizeof(hw));
 
@@ -44,8 +46,24 @@ bastide_register(unsigned int base, unsi
 	hw.io_ports[IDE_CONTROL_OFFSET] = aux + (6 * 0x20);
 	hw.irq = irq;
 
-	ide_register_hw(&hw, NULL, hwif);
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out;
 
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 1);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
+	hwif->quirkproc = NULL;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+out:
 	return 0;
 }
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -683,6 +683,31 @@ void ide_init_port_hw(ide_hwif_t *hwif, 
 }
 EXPORT_SYMBOL_GPL(ide_init_port_hw);
 
+ide_hwif_t *ide_deprecated_find_port(unsigned long base)
+{
+	ide_hwif_t *hwif;
+	int i;
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->io_ports[IDE_DATA_OFFSET] == base)
+			goto found;
+	}
+
+	for (i = 0; i < MAX_HWIFS; i++) {
+		hwif = &ide_hwifs[i];
+		if (hwif->hold)
+			continue;
+		if (!hwif->present && hwif->mate == NULL)
+			goto found;
+	}
+
+	hwif = NULL;
+found:
+	return hwif;
+}
+EXPORT_SYMBOL_GPL(ide_deprecated_find_port);
+
 /**
  *	ide_register_hw		-	register IDE interface
  *	@hw: hardware registers
@@ -702,18 +727,10 @@ int ide_register_hw(hw_regs_t *hw, void 
 	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	do {
-		for (index = 0; index < MAX_HWIFS; ++index) {
-			hwif = &ide_hwifs[index];
-			if (hwif->io_ports[IDE_DATA_OFFSET] == hw->io_ports[IDE_DATA_OFFSET])
-				goto found;
-		}
-		for (index = 0; index < MAX_HWIFS; ++index) {
-			hwif = &ide_hwifs[index];
-			if (hwif->hold)
-				continue;
-			if (!hwif->present && hwif->mate == NULL)
-				goto found;
-		}
+		hwif = ide_deprecated_find_port(hw->io_ports[IDE_DATA_OFFSET]);
+		index = hwif->index;
+		if (hwif)
+			goto found;
 		for (index = 0; index < MAX_HWIFS; index++)
 			ide_unregister(index, 1, 1);
 	} while (retry--);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -145,13 +145,36 @@ static void ide_detach(struct pcmcia_dev
 
 static int idecs_register(unsigned long io, unsigned long ctl, unsigned long irq, struct pcmcia_device *handle)
 {
+    ide_hwif_t *hwif;
     hw_regs_t hw;
+    int i;
+    u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
+
     memset(&hw, 0, sizeof(hw));
     ide_init_hwif_ports(&hw, io, ctl, NULL);
     hw.irq = irq;
     hw.chipset = ide_pci;
     hw.dev = &handle->dev;
-    return ide_register_hw(&hw, &ide_undecoded_slave, NULL);
+
+    hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+    if (hwif == NULL)
+	return -1;
+
+    i = hwif->index;
+
+    if (hwif->present)
+	ide_unregister(i, 0, 1);
+    else if (!hwif->hold)
+	ide_init_port_data(hwif, i);
+
+    ide_init_port_hw(hwif, &hw);
+    hwif->quirkproc = &ide_undecoded_slave;
+
+    idx[0] = i;
+
+    ide_device_add(idx, NULL);
+
+    return hwif->present ? i : -1;
 }
 
 /*======================================================================
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -51,6 +51,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 	ide_hwif_t *hwif = NULL;
 	ide_drive_t *drive;
 	int i, rc;
+	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
 
 	rc = pci_enable_device(dev);
 	if (rc) {
@@ -77,12 +78,27 @@ delkin_cb_probe (struct pci_dev *dev, co
 	hw.irq = dev->irq;
 	hw.chipset = ide_pci;		/* this enables IRQ sharing */
 
-	rc = ide_register_hw(&hw, &ide_undecoded_slave, &hwif);
-	if (rc < 0) {
-		printk(KERN_ERR "delkin_cb: ide_register_hw failed (%d)\n", rc);
-		pci_disable_device(dev);
-		return -ENODEV;
-	}
+	hwif = ide_deprecated_find_port(hw.io_ports[IDE_DATA_OFFSET]);
+	if (hwif == NULL)
+		goto out_disable;
+
+	i = hwif->index;
+
+	if (hwif->present)
+		ide_unregister(i, 0, 1);
+	else if (!hwif->hold)
+		ide_init_port_data(hwif, i);
+
+	ide_init_port_hw(hwif, &hw);
+	hwif->quirkproc = &ide_undecoded_slave;
+
+	idx[0] = i;
+
+	ide_device_add(idx, NULL);
+
+	if (!hwif->present)
+		goto out_disable;
+
 	pci_set_drvdata(dev, hwif);
 	hwif->dev = &dev->dev;
 	drive = &hwif->drives[0];
@@ -91,6 +107,11 @@ delkin_cb_probe (struct pci_dev *dev, co
 		drive->unmask   = 1;
 	}
 	return 0;
+
+out_disable:
+	printk(KERN_ERR "delkin_cb: no IDE devices found\n");
+	pci_disable_device(dev);
+	return -ENODEV;
 }
 
 static void
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -196,6 +196,7 @@ typedef struct hw_regs_s {
 } hw_regs_t;
 
 struct hwif_s * ide_find_port(unsigned long);
+struct hwif_s *ide_deprecated_find_port(unsigned long);
 void ide_init_port_data(struct hwif_s *, unsigned int);
 void ide_init_port_hw(struct hwif_s *, hw_regs_t *);
 
