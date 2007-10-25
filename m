Return-Path: <linux-kernel-owner+w=401wt.eu-S1762289AbXJYXeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762289AbXJYXeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760328AbXJYXdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:33:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:3209 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbXJYXdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FAY9/gGzkwscKHT/kSKeq0Jgk+rbrL4HmrjtclZvzSC6P2FoBdKesDXTnC+tAAhAtwvpkCI5nwdqILqIjnxc8yJIu+plxAPoJqQnJKdFIbUUj7akucJBugIX4maEv+ZXjy5GZXvTngcmcKpmuTguiGZi5sFDkTg64BWnE5gJmxw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: remove CONFIG_IDEPCI_SHARE_IRQ config option
Date: Fri, 26 Oct 2007 01:38:06 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260138.06815.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that drive_is_ready() has been fixed for non-PCI hosts we can safely
remove CONFIG_IDEPCI_SHARE_IRQ and always support PCI IRQ sharing.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig    |   12 ------------
 drivers/ide/ide-iops.c |    2 --
 2 files changed, 14 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -366,17 +366,6 @@ comment "PCI IDE chipsets support"
 config BLK_DEV_IDEPCI
 	bool
 
-config IDEPCI_SHARE_IRQ
-	bool "Sharing PCI IDE interrupts support"
-	depends on BLK_DEV_IDEPCI
-	help
-	  Some ATA/IDE chipsets have hardware support which allows for
-	  sharing a single IRQ with other cards. To enable support for
-	  this in the ATA/IDE driver, say Y here.
-
-	  It is safe to say Y to this question, in most cases.
-	  If unsure, say N.
-
 config IDEPCI_PCIBUS_ORDER
 	def_bool BLK_DEV_IDE=y && BLK_DEV_IDEPCI
 
@@ -693,7 +682,6 @@ config BLK_DEV_SVWKS
 config BLK_DEV_SGIIOC4
 	tristate "Silicon Graphics IOC4 chipset ATA/ATAPI support"
 	depends on (IA64_SGI_SN2 || IA64_GENERIC) && SGI_IOC4
-	select IDEPCI_SHARE_IRQ
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds PIO & MultiMode DMA-2 support for the SGI IOC4
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -448,7 +448,6 @@ int drive_is_ready (ide_drive_t *drive)
 	udelay(1);
 #endif
 
-#ifdef CONFIG_IDEPCI_SHARE_IRQ
 	/*
 	 * We do a passive status test under shared PCI interrupts on
 	 * cards that truly share the ATA side interrupt, but may also share
@@ -458,7 +457,6 @@ int drive_is_ready (ide_drive_t *drive)
 	if (hwif->pci_dev && IDE_CONTROL_REG)
 		stat = hwif->INB(IDE_ALTSTATUS_REG);
 	else
-#endif /* CONFIG_IDEPCI_SHARE_IRQ */
 		/* Note: this may clear a pending IRQ!! */
 		stat = hwif->INB(IDE_STATUS_REG);
 
