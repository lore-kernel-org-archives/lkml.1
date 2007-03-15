Return-Path: <linux-kernel-owner+w=401wt.eu-S1751291AbXCOVEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbXCOVEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:04:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXCOVEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:04:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63933 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXCOVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Pn3+WCxMSTcecoKspg2lg+/LuDrdLFQgPh/NhG05XKFeHMT1koEsXKGMuBZHeKB8I+WMMl5NyA26iVC/mkHBN5kvgZf1HrdJ06mwhnCrqfE2we6RXBOC48zGXCDDeBqqExVtDuxjgIB3aabKXj7+1CUl+yuxdGjZdPXjKCtvZv4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ide: remove CONFIG_IDEDMA_{ICS,PCI}_AUTO config options
Date: Thu, 15 Mar 2007 21:46:48 +0100
User-Agent: KMail/1.9.6
Cc: Patrick Horn <phrh@yahoo.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152146.48352.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] ide: remove CONFIG_IDEDMA_{ICS,PCI}_AUTO config options

All modern distributions have been setting these options to "y" for ages.
(additionally "n" cases have been obsoleted for few years).  Therefore use
DMA by default and remove CONFIG_IDEDMA_{ICS,PCI}_AUTO (also remove no longer
needed CONFIG_IDEDMA_AUTO).  This fixes DMA support for rare configurations
where CONFIG_IDEDMA_{ICS,PCI}_AUTO was set to "n" but "hdparm -d 1" was used
to enable DMA support and which were forced to PIO mode by "ide: don't allow
DMA to be enabled if CONFIG_IDEDMA_{ICS,PCI}_AUTO=n" patch.  There is no
functionality loss because "ide=nodma" kernel option is still available.

Cc: Patrick Horn <phrh@yahoo.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ide/Kconfig      |   32 --------------------------------
 drivers/ide/arm/icside.c |   13 +------------
 drivers/ide/ide.c        |    4 ----
 drivers/ide/setup-pci.c  |    5 -----
 4 files changed, 1 insertion(+), 53 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -434,24 +434,8 @@ config BLK_DEV_IDEDMA_FORCED
 
 	  Generally say N here.
 
-config IDEDMA_PCI_AUTO
-	bool "Use PCI DMA by default when available"
-	---help---
-	  Prior to kernel version 2.1.112, Linux used to automatically use
-	  DMA for IDE drives and chipsets which support it. Due to concerns
-	  about a couple of cases where buggy hardware may have caused damage,
-	  the default is now to NOT use DMA automatically. To revert to the
-	  previous behaviour, say Y to this question.
-
-	  If you suspect your hardware is at all flakey, say N here.
-	  Do NOT email the IDE kernel people regarding this issue!
-
-	  It is normally safe to answer Y to this question unless your
-	  motherboard uses a VIA VP2 chipset, in which case you should say N.
-
 config IDEDMA_ONLYDISK
 	bool "Enable DMA only for disks "
-	depends on IDEDMA_PCI_AUTO
 	help
 	  This is used if you know your ATAPI Devices are going to fail DMA
 	  Transfers.
@@ -851,19 +835,6 @@ config BLK_DEV_IDEDMA_ICS
 	  Say Y here if you want to add DMA (Direct Memory Access) support to
 	  the ICS IDE driver.
 
-config IDEDMA_ICS_AUTO
-	bool "Use ICS DMA by default"
-	depends on BLK_DEV_IDEDMA_ICS
-	help
-	  Prior to kernel version 2.1.112, Linux used to automatically use
-	  DMA for IDE drives and chipsets which support it. Due to concerns
-	  about a couple of cases where buggy hardware may have caused damage,
-	  the default is now to NOT use DMA automatically. To revert to the
-	  previous behaviour, say Y to this question.
-
-	  If you suspect your hardware is at all flakey, say N here.
-	  Do NOT email the IDE kernel people regarding this issue!
-
 config BLK_DEV_IDE_RAPIDE
 	tristate "RapIDE interface support"
 	depends on ARM && ARCH_ACORN
@@ -1086,9 +1057,6 @@ config IDEDMA_IVB
 
 	  It is normally safe to answer Y; however, the default is N.
 
-config IDEDMA_AUTO
-	def_bool IDEDMA_PCI_AUTO || IDEDMA_ICS_AUTO
-
 endif
 
 config BLK_DEV_HD_ONLY
Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -196,11 +196,6 @@ static void icside_maskproc(ide_drive_t 
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_ICS
-
-#ifndef CONFIG_IDEDMA_ICS_AUTO
-#warning CONFIG_IDEDMA_ICS_AUTO=n support is obsolete, and will be removed soon.
-#endif
-
 /*
  * SG-DMA support.
  *
@@ -474,12 +469,6 @@ static int icside_dma_lostirq(ide_drive_
 
 static void icside_dma_init(ide_hwif_t *hwif)
 {
-	int autodma = 0;
-
-#ifdef CONFIG_IDEDMA_ICS_AUTO
-	autodma = 1;
-#endif
-
 	printk("    %s: SG-DMA", hwif->name);
 
 	hwif->atapi_dma		= 1;
@@ -489,7 +478,7 @@ static void icside_dma_init(ide_hwif_t *
 	hwif->dmatable_cpu	= NULL;
 	hwif->dmatable_dma	= 0;
 	hwif->speedproc		= icside_set_speed;
-	hwif->autodma		= autodma;
+	hwif->autodma		= 1;
 
 	hwif->ide_dma_check	= icside_dma_check;
 	hwif->dma_host_off	= icside_dma_host_off;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -177,11 +177,7 @@ DECLARE_MUTEX(ide_cfg_sem);
 static int ide_scan_direction; /* THIS was formerly 2.2.x pci=reverse */
 #endif
 
-#ifdef CONFIG_IDEDMA_AUTO
 int noautodma = 0;
-#else
-int noautodma = 1;
-#endif
 
 EXPORT_SYMBOL(noautodma);
 
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -505,11 +505,6 @@ static void ide_hwif_setup_dma(struct pc
 		}
 	}
 }
-
-#ifndef CONFIG_IDEDMA_PCI_AUTO
-#warning CONFIG_IDEDMA_PCI_AUTO=n support is obsolete, and will be removed soon.
-#endif
-
 #endif /* CONFIG_BLK_DEV_IDEDMA_PCI*/
 
 /**
