Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbYCXSjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbYCXSjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762448AbYCXSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:38:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:42484 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762212AbYCXSie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=dwZ3gJujlO4GSx8SpbvUayTvvpnTR1VJwkdNPBXRetyevaRZ6sl9z578Bo4He9s17tAVDZ9C01q6U4TT9pAAc9N/D0amcuqZlVzI8GIUAbZps0NqAVCikupMZgntpQaC/Vu8qqMZGUx8htieRNf0S3dMwoPZ3Ql/a07vzhKctIc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2008 19:53:37 +0100
Message-Id: <20080324185337.15320.23504.sendpatchset@localhost.localdomain>
In-Reply-To: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
References: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/5] ide: make ide_unregister() take 'ide_hwif_t *' as an argument
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Make ide_unregister() take 'ide_hwif_t *hwif' instead of 'unsigned int
  index' (hwif->index) as an argument and update all users accordingly.

While at it:

* Remove unnecessary checks for hwif != NULL from ide-pnp.c::idepnp_remove()
  and delkin_cb.c::delkin_cb_remove().

* Remove needless hwif->chipset assignment from scc_pata.c::scc_remove().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c          |    2 +-
 drivers/ide/ide-pnp.c             |    5 +----
 drivers/ide/ide.c                 |   11 ++++-------
 drivers/ide/legacy/ide-cs.c       |    2 +-
 drivers/ide/legacy/ide_platform.c |    2 +-
 drivers/ide/mips/au1xxx-ide.c     |    2 +-
 drivers/ide/pci/delkin_cb.c       |    3 +--
 drivers/ide/pci/scc_pata.c        |    3 +--
 include/linux/ide.h               |    2 +-
 9 files changed, 12 insertions(+), 20 deletions(-)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -75,7 +75,7 @@ static void __devexit rapide_remove(stru
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	ecard_release_resources(ec);
 }
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -82,10 +82,7 @@ static void idepnp_remove(struct pnp_dev
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
 
-	if (hwif)
-		ide_unregister(hwif->index);
-	else
-		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
+	ide_unregister(hwif);
 
 	release_region(pnp_port_start(dev, 1), 1);
 	release_region(pnp_port_start(dev, 0), 8);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -229,7 +229,7 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
 
 /**
  *	ide_unregister		-	free an IDE interface
- *	@index: index of interface (will change soon to a pointer)
+ *	@index: IDE interface
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -249,19 +249,16 @@ EXPORT_SYMBOL_GPL(ide_port_unregister_de
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index)
+void ide_unregister(ide_hwif_t *hwif)
 {
-	ide_hwif_t *hwif, *g;
+	ide_hwif_t *g;
 	ide_hwgroup_t *hwgroup;
 	int irq_count = 0;
 
-	BUG_ON(index >= MAX_HWIFS);
-
 	BUG_ON(in_interrupt());
 	BUG_ON(irqs_disabled());
 	mutex_lock(&ide_cfg_mtx);
 	spin_lock_irq(&ide_lock);
-	hwif = &ide_hwifs[index];
 	if (!hwif->present)
 		goto abort;
 	__ide_port_unregister_devices(hwif);
@@ -302,7 +299,7 @@ void ide_unregister(unsigned int index)
 		ide_release_dma_engine(hwif);
 
 	/* restore hwif data to pristine status */
-	ide_init_port_data(hwif, index);
+	ide_init_port_data(hwif, hwif->index);
 
 abort:
 	spin_unlock_irq(&ide_lock);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -386,7 +386,7 @@ void ide_release(struct pcmcia_device *l
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
     }
     info->ndev = 0;
 
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -120,7 +120,7 @@ static int __devexit plat_ide_remove(str
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -631,7 +631,7 @@ static int au_ide_remove(struct device *
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	iounmap((void *)ahwif->regbase);
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -119,8 +119,7 @@ delkin_cb_remove (struct pci_dev *dev)
 {
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
-	if (hwif)
-		ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
 	pci_release_regions(dev);
 	pci_disable_device(dev);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -730,9 +730,8 @@ static void __devexit scc_remove(struct 
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif);
 
-	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
 	iounmap((void*)ports->ctl);
 	pci_release_selected_regions(dev, (1 << 2) - 1);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1205,7 +1205,7 @@ static inline void ide_acpi_set_state(id
 #endif
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
-void ide_unregister(unsigned int);
+void ide_unregister(ide_hwif_t *);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
