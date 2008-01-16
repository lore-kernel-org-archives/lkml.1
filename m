Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYAPXOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYAPXOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYAPXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:13:40 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbYAPXNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=UJ/qgjjq5MvlWdkUxhUVKKL46xQYk64JkxG6xjtN/45pG36elU14+S75Aeg7AjxlZ2VACWva7tp094CXSiyQMqrnKVN6jrNhMIKoywNCw2Y96EdNTGKYnS9SJ3JBgV4zkTWfspHAdUDTGiAsUHLEJ3RbOoku0tJlK7gXbu1jdRI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:26:17 +0100
Message-Id: <20080116232617.9166.68848.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/22] ide: add 'init_default' and 'restore' arguments to ide_unregister()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add 'init_default' (flag for calling init_hwif_default()) and 'restore'
  (flag for calling ide_hwif_restore()) arguments to ide_unregister().

* Update ide_unregister() users to set 'init_default' and 'restore' flags.

* No need to set 'init_default' flag in ide_register_hw() if the setup done
  by init_hwif_default() is going to be overridden by ide_init_port_hw().

* No need to set 'init_default' and 'restore' flags in cleanup_module().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c          |    2 +-
 drivers/ide/ide-pnp.c             |    7 ++++---
 drivers/ide/ide.c                 |   19 ++++++++++++-------
 drivers/ide/legacy/ide-cs.c       |    2 +-
 drivers/ide/legacy/ide_platform.c |    2 +-
 drivers/ide/mips/au1xxx-ide.c     |    2 +-
 drivers/ide/pci/delkin_cb.c       |    3 ++-
 drivers/ide/pci/scc_pata.c        |    2 +-
 drivers/macintosh/mediabay.c      |    2 +-
 include/linux/ide.h               |    2 +-
 10 files changed, 25 insertions(+), 18 deletions(-)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -76,7 +76,7 @@ static void __devexit rapide_remove(stru
 
 	ecard_set_drvdata(ec, NULL);
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 1, 1);
 
 	ecard_release_resources(ec);
 }
Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -60,9 +60,10 @@ static int idepnp_probe(struct pnp_dev *
 static void idepnp_remove(struct pnp_dev * dev)
 {
 	ide_hwif_t *hwif = pnp_get_drvdata(dev);
-	if (hwif) {
-		ide_unregister(hwif->index);
-	} else
+
+	if (hwif)
+		ide_unregister(hwif->index, 1, 1);
+	else
 		printk(KERN_ERR "idepnp: Unable to remove device, please report.\n");
 }
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -499,6 +499,8 @@ void ide_remove_port_from_hwgroup(ide_hw
 /**
  *	ide_unregister		-	free an IDE interface
  *	@index: index of interface (will change soon to a pointer)
+ *	@init_default: init default hwif flag
+ *	@restore: restore hwif flag
  *
  *	Perform the final unregister of an IDE interface. At the moment
  *	we don't refcount interfaces so this will also get split up.
@@ -518,7 +520,7 @@ void ide_remove_port_from_hwgroup(ide_hw
  *	This is raving bonkers.
  */
 
-void ide_unregister(unsigned int index)
+void ide_unregister(unsigned int index, int init_default, int restore)
 {
 	ide_drive_t *drive;
 	ide_hwif_t *hwif, *g;
@@ -602,9 +604,12 @@ void ide_unregister(unsigned int index)
 
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
-	init_hwif_default(hwif, index);
 
-	ide_hwif_restore(hwif, &tmp_hwif);
+	if (init_default)
+		init_hwif_default(hwif, index);
+
+	if (restore)
+		ide_hwif_restore(hwif, &tmp_hwif);
 
 abort:
 	spin_unlock_irq(&ide_lock);
@@ -710,12 +715,12 @@ int ide_register_hw(hw_regs_t *hw, void 
 				goto found;
 		}
 		for (index = 0; index < MAX_HWIFS; index++)
-			ide_unregister(index);
+			ide_unregister(index, 1, 1);
 	} while (retry--);
 	return -1;
 found:
 	if (hwif->present)
-		ide_unregister(index);
+		ide_unregister(index, 0, 1);
 	else if (!hwif->hold)
 		ide_init_port_data(hwif, index);
 
@@ -1058,7 +1063,7 @@ int generic_ide_ioctl(ide_drive_t *drive
 	        case HDIO_UNREGISTER_HWIF:
 			if (!capable(CAP_SYS_RAWIO)) return -EACCES;
 			/* (arg > MAX_HWIFS) checked in function */
-			ide_unregister(arg);
+			ide_unregister(arg, 1, 1);
 			return 0;
 		case HDIO_SET_NICE:
 			if (!capable(CAP_SYS_ADMIN)) return -EACCES;
@@ -1703,7 +1708,7 @@ void __exit cleanup_module (void)
 	int index;
 
 	for (index = 0; index < MAX_HWIFS; ++index)
-		ide_unregister(index);
+		ide_unregister(index, 0, 0);
 
 	proc_ide_destroy();
 
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -337,7 +337,7 @@ void ide_release(struct pcmcia_device *l
     if (info->ndev) {
 	/* FIXME: if this fails we need to queue the cleanup somehow
 	   -- need to investigate the required PCMCIA magic */
-	ide_unregister(info->hd);
+	ide_unregister(info->hd, 1, 1);
     }
     info->ndev = 0;
 
Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -122,7 +122,7 @@ static int __devexit plat_ide_remove(str
 {
 	ide_hwif_t *hwif = pdev->dev.driver_data;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 1, 1);
 
 	return 0;
 }
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -678,7 +678,7 @@ static int au_ide_remove(struct device *
 	ide_hwif_t *hwif = dev_get_drvdata(dev);
 	_auide_hwif *ahwif = &auide_hwif;
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 1, 1);
 
 	iounmap((void *)ahwif->regbase);
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -99,7 +99,8 @@ delkin_cb_remove (struct pci_dev *dev)
 	ide_hwif_t *hwif = pci_get_drvdata(dev);
 
 	if (hwif)
-		ide_unregister(hwif->index);
+		ide_unregister(hwif->index, 1, 1);
+
 	pci_disable_device(dev);
 }
 
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -736,7 +736,7 @@ static void __devexit scc_remove(struct 
 		hwif->dmatable_cpu = NULL;
 	}
 
-	ide_unregister(hwif->index);
+	ide_unregister(hwif->index, 1, 1);
 
 	hwif->chipset = ide_unknown;
 	iounmap((void*)ports->dma);
Index: b/drivers/macintosh/mediabay.c
===================================================================
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -595,7 +595,7 @@ static void media_bay_step(int i)
     	        if (bay->cd_index >= 0) {
 			printk(KERN_DEBUG "Unregistering mb %d ide, index:%d\n", i,
 			       bay->cd_index);
-			ide_unregister(bay->cd_index);
+			ide_unregister(bay->cd_index, 1, 1);
 			bay->cd_index = -1;
 		}
 	    	if (bay->cd_retry) {
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1211,7 +1211,7 @@ static inline void ide_acpi_set_state(id
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
 extern void ide_hwif_release_regions(ide_hwif_t* hwif);
-extern void ide_unregister (unsigned int index);
+void ide_unregister(unsigned int, int, int);
 
 void ide_register_region(struct gendisk *);
 void ide_unregister_region(struct gendisk *);
